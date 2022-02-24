async function primeGenerateDocumentPreviewer( callingComponent, selectedTemplates) {

    let firstTemplate = null;

    root.$snotify.simple('Please wait...', 'Generating Preview', { timeout: 0, icon: 'img/cogs.gif' });

    // Reset the data
    root.previewDocuments.initialize( callingComponent );

    root.previewDocuments.multipleTemplatesFlag = ( selectedTemplates.length > 1 ) ? true : false;

    await root.asyncForEach(selectedTemplates, async (templateId) => {

        let response = await axios.post('/lolsystemtemplate/get/' + templateId);

        if ( response.data.errors ) {

            showError('Error',response.data.errors);

        } else {

            root.previewDocuments.multipleTemplates.push({
                value: response.data.data[0].recordid,
                label: response.data.data[0].title,
            });

            if ( !firstTemplate ) firstTemplate = response.data.data[0];

            if ( !root.previewDocuments.selectedTemplate ) {

                root.previewDocuments.selectedTemplate = response.data.data[0].recordid;

            }
        }

    });

    loadGenerateDocumentPreviewer( callingComponent, firstTemplate );

}


function loadGenerateDocumentPreviewer( callingComponent, firstTemplate ) {

    let params = {};

    if ( callingComponent.generateDocumentsSource == 'Party') {

        params = { 
            whereIn: 'party.recordid,' + callingComponent.selectedRows.join(),
            select: ['Party.RecordId as recordid', 'Party.MatterPrefix as code', 'Party.Name as description'],
            orderBy: 'Party.MatterPrefix'
        } 

    } else if ( callingComponent.generateDocumentsSource == 'Matter') {

        params = { 
            whereIn: 'matter.recordid,' + callingComponent.selectedRows.join(),
            select: ['Matter.RecordId as recordid', 'Matter.FileRef as code', 'Matter.Description as description'],
            orderBy: 'Matter.FileRef'
        }

    } else if ( callingComponent.generateDocumentsSource == 'MatParty') {

        params = { 
            whereIn: 'matparty.recordid,' + callingComponent.selectedRows.join(),
            select: ['MatParty.RecordId as recordid', 'Party.MatterPrefix as code', 'Party.Name as description'],
            orderBy: 'Party.MatterPrefix'
        }
    }

    axios.post('/' +  callingComponent.generateDocumentsSource.toLowerCase() + '/get', params)

    .then(async response => {

        if (response.data.errors) { 

            showError('Error getting Records', response.data.errors); 

        } else {

            await root.asyncForEach(response.data.data, async (record) => {                

                root.previewDocuments.multipleRecords.push({
                    value: record.recordid,
                    label: record.code + ' (' + record.description + ')',
                });

                if ( !root.previewDocuments.selectedRecord ) {

                    root.previewDocuments.selectedRecord = record.recordid;

                }

            });


            let firstRecord = response.data.data[0];

            if ( callingComponent.selectedRows.length > 1 ) {

                root.previewDocuments.multipleRecordsFlag = true;
                root.previewDocuments.multipleRecordsLabel = callingComponent.generateDocumentsSource;

            }

            root.previewDocuments.title = root.previewDocuments.multipleRecordsFlag ? 'Preview Documents' : 'Preview Document';

            let roleId = null;
            let sorter = null;

            if ( firstTemplate.roleid ) {
                roleId = firstTemplate.roleid;
                sorter = 1;
            }

            root.createRecordTemplateData(callingComponent.generateDocumentsSource,firstTemplate, firstRecord.recordid, roleId, sorter)

            .then( (templateData) => {

                root.previewDocuments.templateData = templateData;

                // Check if a MatParty was found for this RoleId
                if ( roleId && $.isEmptyObject(templateData.matParty)) {

                    root.previewDocuments.templateContents = '<h3 class="mt-5 text-center">This Matter does not have a ' + root.partyRoles.filter(role => role.recordid == roleId)[0].description + '.</h3>';
                    root.previewDocuments.templateContents += '<h3 class="mt-2 text-center">A ' + firstTemplate.title + ' will not be generated for this Matter.</h3>';

                } else {

                    root.previewDocuments.templateContents = firstTemplate.contents;

                }

                root.$snotify.clear();

                root.previewDocuments.show();

                root.previewDocuments.generateFirstDocumentContents();

            }).catch( (error) => {

                showError('Error',error);

            });

        }

    }).catch(error => {
        showError('Error', error); 
    });

}

function emailThisMatParty(id, notifyFlag = false) {

    if (notifyFlag) root.$snotify.simple('Please wait...', 'Preparing email', { timeout: 0, icon: 'img/cogs.gif' });

    axios.post('/matparty/get/' + id)

    .then(matPartyResponse => {

        axios.post('/party/get/' + matPartyResponse.data.data[0].partyid)

        .then(partyResponse => {
    
            let party = partyResponse.data.data[0];
    
            if ( !party.emailaddress ) {
    
                showError('No Email Address', 'Please add the Party\'s email address in the <strong>Contact Details</strong> tab.');
    
            } else {

                root.emailModal.initialize();
                root.emailModal.defaultAttachmentFlag = false;

                root.emailModal.title = 'Email ' + party.name;
                root.emailModal.toAddress = party.emailaddress;

                axios.post('/lolsystemtemplate/get/' + root.lolSettings.matpartiesemailtemplateid)

                .then(response => {

                    if ( response.data.errors ) {

                        showError('Error',response.data.errors);

                    } else {

                        root.emailModal.templateRecord = response.data.data[0];

                        root.emailModal.templateContents = root.emailModal.templateRecord.contents;

                        //root.emailModal.subject = root.emailModal.templateRecord.subject;

                        root.createRecordTemplateData('matparty',root.emailModal.templateRecord, id)

                        .then( (templateData) => {

                            root.emailModal.templateData = templateData;

                            if (notifyFlag) root.$snotify.clear();

                            root.emailModal.show();

                            root.emailModal.generateEmailBody();

                            setTimeout(() => {

                                $('#' + root.emailModal.id + ' input[name="subject"]').focus();

                            });

                        }).catch( (error) => {

                            showError('Error',error);

                        });


                    }

                }).catch( (error) => {

                    showError('Error',error);

                });

            }
            
        }).catch( (error) => {

            showError('Error',error);
    
        });
    

    }).catch( (error) => {

        showError('Error',error);

    });

}

function emailThisParty(id, notifyFlag = false) {

    if (notifyFlag) root.$snotify.simple('Please wait...', 'Preparing email', { timeout: 0, icon: 'img/cogs.gif' });

    axios.post('/party/get/' + id)

    .then(partyResponse => {

        let party = partyResponse.data.data[0];

        if ( !party.emailaddress ) {

            showError('No Email Address', 'Please add this Party\'s email address in the <strong>Contact Details</strong> tab.');

        } else {

            root.emailModal.initialize();
            root.emailModal.defaultAttachmentFlag = false;

            root.emailModal.title = 'Email ' + party.name;
            root.emailModal.toAddress = party.emailaddress;

            axios.post('/lolsystemtemplate/get/' + root.lolSettings.partiesemailtemplateid)

            .then(response => {

                if ( response.data.errors ) {

                    showError('Error',response.data.errors);

                } else {

                    root.emailModal.templateRecord = response.data.data[0];

                    root.emailModal.templateContents = root.emailModal.templateRecord.contents;

                    root.createRecordTemplateData('party',root.emailModal.templateRecord, party.recordid)

                    .then( (templateData) => {

                        root.emailModal.templateData = templateData;

                        if (notifyFlag) root.$snotify.clear();

                        root.emailModal.show();

                        root.emailModal.generateEmailBody();

                        setTimeout(() => {

                            $('#' + root.emailModal.id + ' input[name="subject"]').focus();

                        });

                    }).catch( (error) => {

                        showError('Error',error);

                    });


                }

            }).catch( (error) => {

                showError('Error',error);

            });

        }


    }).catch( (error) => {

        showError('Error',error);

    });

}

function resetTagged( callingComponent ) {

    // Clears the tags without reloading the table
    // Need this is some components (e.g. FeeCodeTable.vuew)
    clearTagged( callingComponent, false );

}

function clearTagged( callingComponent, reload = true ) {

    //console.log("clearTagged called - root.testComponent",callingComponent);
    //root.testComponent = callingComponent;

    if ( callingComponent.selectedRows.length ) {
        
        if ( callingComponent.table.table ) {
            callingComponent.table.displayingTaggedRecordsFlag = false;
            callingComponent.table.table.rows().deselect();
            if ( reload ) {
                callingComponent.table.whereRaw = null;
                callingComponent.table.table.ajax.reload();
            }
        }

        //https://www.tutorialspoint.com/in-javascript-how-to-empty-an-array

        callingComponent.selectedRows.splice(0, callingComponent.selectedRows.length);

        callingComponent.selectedAllFlag = false;

        // Clear the tags in the database
        axios.post( '/utils/clearTagged', {
            tableName: callingComponent.table.tableName,
            employeeId: root.loggedInEmployeeId
        })
            
        .then(response => {

            if (response.data.errors) {
                showError('Error', response.data.errors); 
            }
            
        }).catch( (error) => {
            showError('Error clearing Tags', error); 
        });
    }
}

function printHtml( body ) {

    try {
        
        let html = `
        <!DOCTYPE html>
        <html lang="en" class="no-js">
            <head>
                <meta charset="utf-8">
                <link href="https://d22oktazhmwkct.cloudfront.net/program.css" rel="stylesheet">
            </head>
            <body onload="window.print()">
                ${body}
            </body>
        </html>`;

        const newWin = window.frames["global-print-table"];
        newWin.document.write(html);
        newWin.document.close();

    } catch (error) {
        showError('Error printing Html', error);
    }

}

