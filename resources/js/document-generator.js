


function generatePdfDocument( options ) {

    return new Promise( (resolve, reject) => {

        let bodyHtml, headerHtml, footerHtml;

        root.registerUserComponents( options.templateData, options.registerUserComponents)

        .then( async () => {

            if (options.templateRecord.header) {
                await root.vueRender( options.templateRecord.header, options.templateData, false )
                .then( (html) => { 
                    headerHtml = html; 
                }).catch( (error) => {
                    reject(error);
                });
            }

            if (options.templateRecord.contents) {
                await root.vueRender( options.templateRecord.contents, options.templateData, false )
                .then( (html) => { 
                    bodyHtml = html; 
                }).catch( (error) => {
                    reject(error);
                });
            }

            if (options.templateRecord.footer) {
                await root.vueRender( options.templateRecord.footer, options.templateData, false )
                .then( (html) => { 
                    footerHtml = html; 
                }).catch( (error) => {
                    reject(error);
                });
            }

            const params = { 
                ...options.templateRecord,  
                headerHtml: headerHtml,
                bodyHtml: bodyHtml,
                footerHtml: footerHtml,
                folder: options.folder,
                fileName: options.fileName,
                password: options.password ? templateRecord.password : null,
                allow: options.password ? this.getPdfPermissions(templateRecord) : null,
            };
    
            axios.post('/pdf/htmlToPdf', params)
    
            .then(response => {
    
                if ( response.data.error ) {
    
                    reject('Error creating PDF: ' + response.data.error);
    
                } else {
    
                    resolve({
                        url: response.data.url, 
                        path: response.data.path,
                    });
                }

            }).catch(error => { 

                reject('Error creating PDF: ' + error);

            });                                            

        }).catch(error => { 

            reject('Error registering Components: ' + error);

        });                                            

    });

}

function getPdfPermissions(templateRecord) {

    let permissions = [];

    if ( templateRecord.allowprint ) permissions.push('Printing');
    if ( templateRecord.allowedit ) permissions.push('ModifyContents');
    if ( templateRecord.allowcopy ) permissions.push('CopyContents');

    return permissions.join(' '); // Return a spaced string of permissions

}

