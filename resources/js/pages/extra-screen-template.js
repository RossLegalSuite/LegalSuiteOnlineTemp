export default Vue.extend({

    data() {
        return {
            extraScreensVisibleFlag: false,
            visibleExtraScreens: [],
            extraScreens: [],
            tableName: '',
            fieldData: {},
        }
    },


    methods: {

        showExtraScreens() {

            this.extraScreensVisibleFlag = true;

            if ( !this.visibleExtraScreens.length ) {

                root.$snotify.simple('Loading Extra Screens', 'Please wait', { timeout: 0, icon: 'img/cogs.gif' });                

                this.createExtraScreens().then( () => {

                    root.$snotify.clear();

                    this.populateExtraScreenData();

                }).catch( () => { root.$snotify.clear(); });
            }
        },

        initExtraScreens() {

            this.extraScreensVisibleFlag = false;

            if (!this.tabs.filter(tab => tab.pageName === 'Extra').length ) {

                this.tabs.push({
                    pageName: "Extra",
                    title: "Extra Screens",
                    iconClass: '',
                    visible: false,
                    active: false,
                });

            }

            this.extraScreenTab = this.tabs.filter(tab => tab.pageName === 'Extra')[0];

            this.extraScreenTab.visible = this.extraScreenTab.active = false; // Hide the Extra Screen Tab

            this.extraScreens = [];         // This array is used to display the Extra Screens in the UI
            this.visibleExtraScreens = [];  // This array is used to store the settings of each Extra Screen

            $('#' + this.id + ' .extra-screen-container').remove(); //Remove any Extra Screens

            if ( this.editing && this.resource) {

                let whereRaw = '', extraScreenTable = '';

                if ( this.resource == 'Matter' ) {

                    extraScreenTable = 'matdocsc';
                    
                    whereRaw = ["MatterId = " + this.record.recordid];
                    
                } else if ( this.resource == 'Party' ) {
                    
                    extraScreenTable = 'parfield';

                    whereRaw = ["PartyId = " + this.record.recordid];
                    
                } else if ( this.resource == 'MatParty' ) {
                    
                    extraScreenTable = 'parrolsc';

                    whereRaw = ["MatPartyId = " + this.record.recordid];

                }

                if ( !whereRaw ) {
                    console.log("No Extra Screen Type specified for resource: " + this.resource + " in initExtraScreens()");
                    return;
                }

                axios.post("/" + extraScreenTable + "/get",  { 
                    whereRaw: whereRaw,
                    orderBy: 'description'
                }).then(response => {

                    if ( response.data.errors ) {

                        showError(extraScreenTable + ' Error', response.data.errors);

                    } else {

                        if ( response.data?.data.length) {

                            response.data.data.forEach(extraScreen => {
                                
                                this.extraScreens.push(extraScreen); 

                                this.extraScreenTab.visible = true;
                            });
                        }

                    }

                }).catch( (error) => {
                    showError('An error was encountered getting the ' + extraScreenTable + ' data', error); 
                });

                // Add the Matter Extra Screen as well
                if ( this.resource == 'Matter' && this.record.extrascreenid && parseInt(this.record.extrascreenid) > 0  ) {

                    axios.post("/docscrn/get/" + this.record.extrascreenid)
                    
                    .then(async response => {

                        if ( response.data.errors ) {

                            showError('DocScrn Get Error', response.data.errors);

                        } else {

                            if ( response.data.data.length ) {

                                this.extraScreens.push(response.data.data[0]); 

                                this.extraScreenTab.visible = true;

                                //console.log("2 Matter Extra Screen - extraScreens",this.extraScreens);

                            }
                        }    
                    }).catch( (error) => {
                        showError('Error getting DocScrn data', error); 
                    });

                }

            }

        },

        createExtraScreens() {

            return new Promise( async (resolve, reject) => {

                await asyncForEach( this.extraScreens, async (extraScreen) => {

                    try {

                        this.setFieldTableParameters( extraScreen );

                        // Need these for evaluating labels
                        let fieldTableResponse = await axios.post("/" + this.fieldTableParams.tableName + "/get",  { 
                            where: this.fieldTableParams.where
                        }).catch( (error) => {
                            showError('An error was encountered getting ' + this.fieldTableParams.tableName, error); 
                        });

                        if ( fieldTableResponse.data.errors ) throw fieldTableResponse.data.errors;

                        this.fieldData = fieldTableResponse.data.data[0] ? fieldTableResponse.data.data[0] : { field1:'',field2:'',field3:'',field4:'',field5:'',field6:'',field7:'',field8:'',field9:'',field10:'',field11:'',field12:'',field13:'',field14:'',field15:'',field16:'',field17:'',field18:'',field19:'',field20:'',field21:'',field22:'',field23:'',field24:'',field25:'',field26:'',field27:'',field28:'',field29:'',field30:''};

                        let formFields = [];

                        let response = await axios.post("/docscrnfield/get",  { 
                            where: "DocScrnID,=," + extraScreen.recordid
                        }).catch( (error) => {
                            showError('Error getting DocScrnField data', error); 
                        });

                        if ( response.data.errors ) throw response.data.errors;

                        await asyncForEach( response.data.data, async (field) => {

                            let fieldType = 'text';

                            if ( field.fieldtype == 'D' ) {
                                fieldType = 'date';
                            } else if ( field.fieldtype == 'N' ) {
                                fieldType = 'number';
                            } else if ( field.fieldtype == 'Y' || field.fieldtype == 'R' || field.fieldtype == 'L' ) {
                                fieldType = 'select'; 
                            }

                            let dropDownValues = [];

                            if ( field.fieldtype == 'R' ) {

                                let values = [];
                                let labels = [];

                                if ( field.fielddropdownoptions ) {

                                    // Can be something like 
                                    // School Fees|#S|After Care|#A|Hostel Fees|#H
                                    // OR
                                    // Active|#|Inactive|#
                                    // OR
                                    // Active|Inactive

                                    values = field.fielddropdownoptions.match(/#(\w?)/g);

                                    if ( values?.length ) {

                                        let strippedValues = field.fielddropdownoptions.replace(/\|#(\w?)/g,'');

                                        for (let index = 0; index < values.length; index++) {
                                            values[index] = values[index].replace('#','');
                                        }

                                        labels = strippedValues.split("|");

                                    } else {

                                        // If something like //Active|Inactive
                                        values = field.fielddropdownoptions.split("|");
                                        labels = field.fielddropdownoptions.split("|");
                                    }

                                    for (let index = 0; index < labels.length; index++) {

                                        // If no value (e.g. Active|#|Inactive|#) then set the value to the label
                                        values[index] = !values[index] ? labels[index] : values[index];
                                        
                                        dropDownValues.push({ "label": labels[index], "value": values[index], "selected": false });
                                        
                                    }
                                }

                            } else if ( field.fieldtype == 'Y' ) {

                                dropDownValues.push({ "label": "Yes", "value": "Y", "selected": false });

                                dropDownValues.push({ "label": "No", "value": "N", "selected": false });

                            } else if ( field.fieldtype == 'L' ) {

                                if ( field.lookuptable && field.lookupcolumn ) {

                                    let lookupResponse = await axios.post("/" + field.lookuptable.toLowerCase() + "/get",  { 
                                        select: [field.lookupcolumn],
                                        orderBy: [field.lookupcolumn],
                                        whereRaw: field.lookupscript ? [field.lookupscript] : null,
                                    }).catch( (error) => {
                                        showError('An error was encountered getting ' + field.lookuptable, error); 
                                    });
        
                                    if ( lookupResponse.errors ) throw lookupResponse.errors;

                                    lookupResponse.data.data.forEach(data => {
                                        dropDownValues.push(data[field.lookupcolumn.toLowerCase()]);
                                    });

                                }

                            }

                            if ( field.hideflag == '1' ) {

                                if ( field.hidecondition ) {

                                    let hideField = this.evaluateRecord( field.hidecondition );

                                    if (hideField) fieldType = 'hidden';

                                } else {

                                    fieldType = 'hidden';

                                }

                            }

                            let disabledFlag = false;

                            if ( field.disableflag == '1' ) {

                                if ( field.disablecondition ) {

                                    let disableField = this.evaluateRecord( field.disablecondition );

                                    if (disableField) disabledFlag = true;

                                } else {

                                    disabledFlag = true;

                                }

                            }

                            let label = this.evaluateRecord( field.fieldprompt );

                            let formField = {
                                id: this.id + '-extra-field-input-' + extraScreen.recordid + '-' + field.fieldnumber,
                                name: this.id + '-extra-field-input-' + extraScreen.recordid + '-' + field.fieldnumber,
                                fieldNumber: field.fieldnumber,

                                disabledFlag: disabledFlag,
                                fieldCalculation: field.fieldcalculation,
                                fieldRequiredCondition: field.fieldrequiredcondition,
                                fieldRequiredFlag: field.fieldrequiredflag,
                                defaultValue: field.defaultvalue,

                                writeBackTable: field.writebacktable,
                                writeBackColumn: field.writebackcolumn,
                                writeBackCondition: field.writebackcondition,
                                writeBackFlag: field.writebackflag,
                                writeBackRoleId: field.writebackroleid,

                                type: fieldType,
                                label: label,
                                subtype: null,
                                className: 'form-control',
                                description: field.fieldhelp,
                                placeholder: null,
                                required: field.fieldrequiredflag == '1' ? true : false,
                                values: dropDownValues,
                                value: null,
                            };

                            formFields.push(formField);

                        });

                        let formViewer = $( '#extra-screen-form-container-' + extraScreen.recordid);

                        setTimeout(() => {
                            $( '#extra-screen-form-' + extraScreen.recordid, formViewer).formRender({
                                formData: formFields,
                                notify: {
                                    success: function() { return ''; },
                                    warning: function(message) { return console.warn(message); },
                                    error: function(message) { return console.error(message); },
                                }
                            });
                        });

                        //Add to extraScreens array (used to add the data to the extra screen)
                        this.visibleExtraScreens.push({...extraScreen, formFields: formFields});

                    } catch (error) {
                        //root.$snotify.simple('Adding ExtraScreen ' + extraScreen.description + ':' + error, 'Error', { timeout: 3000, icon: 'img/delete.png' });
                        console.log('Adding ExtraScreen ' + extraScreen.description + ':' + error);

                    }

                });

                resolve();

            });

        },

        async populateExtraScreenData() {

            await asyncForEach( this.visibleExtraScreens, async (extraScreen) => {

                try {

                    this.setFieldTableParameters( extraScreen );

                    let response = await axios.post("/" + this.fieldTableParams.tableName + "/get",  { 
                        where: this.fieldTableParams.where
                    }).catch( (error) => {
                        showError('An error was encountered getting ' + fieldTableParams.tableName, error); 
                    });

                    if ( response.errors ) throw response.errors;

                    this.fieldData = response.data.data[0];

                    // In case no Field data has been added yet for this screen
                    if (!this.fieldData) {

                        this.fieldData = { field1:'',field2:'',field3:'',field4:'',field5:'',field6:'',field7:'',field8:'',field9:'',field10:'',field11:'',field12:'',field13:'',field14:'',field15:'',field16:'',field17:'',field18:'',field19:'',field20:'',field21:'',field22:'',field23:'',field24:'',field25:'',field26:'',field27:'',field28:'',field29:'',field30:''};
                        
                    }

                    for (let index = 1; index < 31; index++) {
                        
                        let formField = extraScreen.formFields.filter(formField => formField.fieldNumber == index)[0];

                        if ( formField ) {

                            let inputField = $('#' + this.id + '-extra-field-input-' + extraScreen.recordid + '-' + index);

                            if ( inputField.length ) {

                                if ( formField?.fieldCalculation ) {
                                    
                                    //console.log("formField.fieldCalculation",formField.fieldCalculation,formField);
                                    
                                    inputField.val( this.evaluateRecord( formField.fieldCalculation ) );
                                    
                                } else if ( formField?.defaultValue && !this.fieldData['field' + index]) {
                                    
                                    //console.log("formField.defaultValue",formField.defaultValue,formField);
                                    
                                    inputField.val( this.evaluateRecord( formField.defaultValue ) );
                                    
                                } else if ( formField.type == 'date') {
                                    
                                    inputField.val( convertFromClarionDate(this.fieldData['field' + index], true, 'YYYY-MM-DD') );
                                    
                                } else {

                                    inputField.val( this.fieldData['field' + index]);
                                }


                                if ( formField.disabledFlag || formField.fieldCalculation) {
                                    inputField.prop("disabled", true);
                                }

                            }

                        }
                    }

                } catch (error) {
                    root.$snotify.simple('Populating ExtraScreen ' + extraScreen.description + ':' + error, 'Error', { timeout: 3000, icon: 'img/delete.png' });
                }

            });

        },

        setFieldTableParameters( extraScreen) {

            this.fieldTableParams = {};

            if ( this.resource == 'Matter' ) {

                if ( extraScreen.screentype == 'M' ) {

                    this.fieldTableParams = {
                        tableName: 'matfield',
                        where:["MatterId,=," + this.record.recordid]
                    };

                } else {

                    this.fieldTableParams = {
                        tableName: 'matdocsc',
                        where:["MatterId,=," + this.record.recordid, "DocScreenId,=," + extraScreen.recordid]
                    };

                }


            } else if ( this.resource == 'Party' ) {

                this.fieldTableParams = {
                    tableName: 'parfield',
                    where:["PartyId,=," + this.record.recordid, "DocScreenId,=," + extraScreen.recordid]
                };


            } else if ( this.resource == 'MatParty' ) {
                
                this.fieldTableParams = {
                    tableName: 'parrolsc',
                    where:["MatPartyId,=," + this.record.recordid, "RoleScreenId,=," + extraScreen.recordid]
                };

            }

            if ($.isEmptyObject(this.fieldTableParams)) {

                showError('System Error', 'No fieldTableParams set in createExtraScreens');
            }


        },

        async checkExtraScreenRequiredFields() {

            var requiredFieldFlag = false;

            await asyncForEach( this.visibleExtraScreens, async (extraScreen) => {

                if ( !requiredFieldFlag ) {

                    for (let index = 1; index < 21; index++) {

                        let formField = extraScreen.formFields.filter(formField => formField.fieldNumber == index)[0];

                        if ( formField?.fieldRequiredFlag == '1') {

                            let inputField = $('#' + this.id + '-extra-field-input-' + extraScreen.recordid + '-' + index);

                            if ( inputField.length ) {

                                if ( !inputField.val() ) {

                                    if ( formField.fieldRequiredCondition ) {

                                        let required = this.evaluateRecord( formField.fieldRequiredCondition );

                                        if (required) {

                                            requiredFieldFlag = true;

                                            setTimeout(() => { 
                                                inputField.addClass('is-invalid');
                                                inputField.after('<div class="invalid-feedback">This field is required</div>');
                                                inputField.focus(); 
                                            });

                                            break;
                                        }

                                    } else {

                                        requiredFieldFlag = true;

                                        setTimeout(() => { 
                                            inputField.addClass('is-invalid'); 
                                            inputField.after('<div class="invalid-feedback">This field is required</div>'); 
                                            inputField.focus(); 
                                        });

                                        break;

                                    }

                                }
                            }
                        }

                    }

                }

            });

            return requiredFieldFlag;

        },

        async checkExtraWriteBackFields() {

            // The only write back Tables are Matter, MatParty, ColData, BondData, ConveyData
            // Only call this in the Matter Form and MatParty Form

            await asyncForEach( this.visibleExtraScreens, async (extraScreen) => {

                for (let index = 1; index < 21; index++) {

                    let formField = extraScreen.formFields.filter(formField => formField.fieldNumber == index)[0];

                    if ( formField?.writeBackFlag == '1' && formField?.writeBackTable && formField?.writeBackColumn ) {

                        let inputField = $('#' + this.id + '-extra-field-input-' + extraScreen.recordid + '-' + index);

                        if ( inputField.length ) {

                            if ( formField.writeBackCondition ) {

                                let writeBack = false;

                                if ( this.resource == 'Matter') {
                                    writeBack = this.evaluateMatter( formField.writeBackCondition, this.record, this?.coldata, this?.bonddata, this?.conveydata );
                                } else if ( this.resource == 'Matter') {
                                    writeBack = this.evaluateMatParty( formField.writeBackCondition, this.record );
                                }
                                
                                if (writeBack) {

                                    this.writeBackData( formField );

                                }

                            } else {

                                this.writeBackData( formField );

                            }

                        }
                    }

                }


            });

        },

        writeBackData( formField ) {

            //Something like this

            if ( this.resource == 'Matter') {
                if ( formField.writeBackTable == 'Matter' ) {
                    this.record[formField.writeBackColumn.toLowerCase()] = inputField.val();
                } else if ( formField.writeBackTable == 'ColData' ) {
                    if ( this.coldata ) this.coldata[formField.writeBackColumn.toLowerCase()] = inputField.val();
                } else if ( formField.writeBackTable == 'ConveyData' ) {
                    if ( this.conveydata ) this.conveydata[formField.writeBackColumn.toLowerCase()] = inputField.val();
                } else if ( formField.writeBackTable == 'BondData' ) {
                    if ( this.bondata ) this.bondata[formField.writeBackColumn.toLowerCase()] = inputField.val();
                }

            } else if ( this.resource == 'MatParty') {

                //Note - handle formField.writeBackRoleId
                // Doesn't seem to work in LegalSuite - DSF:WriteBackColumn is disabled in UpdateDocScrnField if MatParty table selected
                // if ( formField.writeBackTable == 'MatParty' ) {
                //     this.record[formField.writeBackColumn.toLowerCase()] = inputField.val();
                // }
            }

        },


        evaluateRecord(evaluateString) { 

            if (!evaluateString) return '';

            // In case the Label is "Date" or "Comment". These are Javascript functions
            if (evaluateString.toLowerCase() == 'date' || evaluateString == 'Comment') {
                return evaluateString; 
            }

            // Party table is common to all
            evaluateString = evaluateString.replace(/par\:/gi, "party.");
            
            evaluateString = evaluateString.replace(/party\.[a-zA-Z0-9]\w+/g, function(v) { return v.toLowerCase(); });
            
            // TO DO: handle mattertype

            let matparty = {}, matter = {}, party = {}, parlang = {}, parfield = {}, docgen = {}, mattype = {}, bonddata = {}, conveydata = {}, coldata = {}, matfield = {};

            if ( this.resource == 'Matter' || this.resource == 'MatParty') {

                party = this.party;

                evaluateString = evaluateString.replace(/mat\:/gi, "matter.");
                evaluateString = evaluateString.replace(/matter\.[a-zA-Z0-9]\w+/g, function(v) { return v.toLowerCase(); });

                if ( this.resource == 'Matter') {

                    matter = this.record;
                    matfield = this.fieldData;

                    evaluateString = evaluateString.replace(/mef\:/gi, "matfield.");
                    evaluateString = evaluateString.replace(/matfield\.[a-zA-Z0-9]\w+/g, function(v) { return v.toLowerCase(); });

                    docgen = this.docgenData;
                    mattype = this.matterTypeData;
                    bonddata = this.bondData;
                    conveydata = this.conveyData;
                    coldata = this.colData;
                    
                    evaluateString = evaluateString.replace(/dg\:/gi, "docgen.");
                    evaluateString = evaluateString.replace(/mt\:/gi, "mattype.");
                    evaluateString = evaluateString.replace(/bon\:/gi, "bonddata.");
                    evaluateString = evaluateString.replace(/conv\:/gi, "conveydata.");
                    evaluateString = evaluateString.replace(/col\:/gi, "coldata.");

                    evaluateString = evaluateString.replace(/docgen\.[a-zA-Z0-9]\w+/g, function(v) { return v.toLowerCase(); });
                    evaluateString = evaluateString.replace(/mattype\.[a-zA-Z0-9]\w+/g, function(v) { return v.toLowerCase(); });
                    evaluateString = evaluateString.replace(/bonddata\.[a-zA-Z0-9]\w+/g, function(v) { return v.toLowerCase(); });
                    evaluateString = evaluateString.replace(/conveydata\.[a-zA-Z0-9]\w+/g, function(v) { return v.toLowerCase(); });
                    evaluateString = evaluateString.replace(/coldata\.[a-zA-Z0-9]\w+/g, function(v) { return v.toLowerCase(); });

                } else if ( this.resource == 'MatParty') {

                    matparty = this.record;
                    matter = this.matter;

                    evaluateString = evaluateString.replace(/mp\:/gi, "matparty.");
                    evaluateString = evaluateString.replace(/matparty\.[a-zA-Z0-9]\w+/g, function(v) { return v.toLowerCase(); });
                }

                //console.log("evaluateRecord for " + this.resource + " this.party",this.party.name);
                //console.log("evaluateRecord for " + this.resource + " this.matter",this.matter.description);


            } else if ( this.resource == 'Party' ) {

                party = this.record;
                parlang = this.parlang;
                parfield = this.fieldData;

                // Party tables
                evaluateString = evaluateString.replace(/pl\:/gi, "parlang.");
                evaluateString = evaluateString.replace(/pef\:/gi, "parfield.");

                evaluateString = evaluateString.replace(/parlang\.[a-zA-Z0-9]\w+/g, function(v) { return v.toLowerCase(); });
                evaluateString = evaluateString.replace(/parfield\.[a-zA-Z0-9]\w+/g, function(v) { return v.toLowerCase(); });

                
            // } else if ( this.resource == 'MatParty' ) {

            //     let matparty = this.record;

            //     // MatParty tables
            //     evaluateString = evaluateString.replace(/mp\:/gi, "matparty.");

            //     evaluateString = evaluateString.replace(/matparty\.[a-zA-Z0-9]\w+/g, function(v) { return v.toLowerCase(); });

            } else {
                console.log("No valid resource specified for evaluateRecord");
                return '';
            }

            try {
                
                evaluateString = replaceClarionEvaluates(evaluateString);

                //console.log("In evaluateRecord() in extra-screen-template.js - evaluateString",evaluateString);

                let fieldName = '';

                if (evaluateString.startsWith('[[') && evaluateString.endsWith(']]') ) {

                    fieldName = evaluateString.slice(2,-2);

                    if (fieldName.startsWith('(') && fieldName.endsWith(')') ) {

                        //e.g. [[(MAT:FileRef  + '/'  + PAR:Name)]]

                        //console.log("In evaluateRecord() in extra-screen-template.js - fieldName.slice(1,-1)",fieldName.slice(1,-1));

                        return eval(fieldName.slice(1,-1));

                    } else {

                        console.log("Must look up Merge Fields and generate the Field Contents in evaluateRecord() in extra-screen-template.js",' FieldName = ' + fieldName);

                        //Access:Field.TryFetch(FLD:NameKey) = Level:Benign
                    
                        //LOC:FieldContents = MakeTheField('LSW')

                    }

                } else {
                    return eval(evaluateString);
                }


            } catch(error) { 

                return evaluateString;

            };


        },

        setExtraScreenTab() {

            this.activeTab = 'Extra';

            for (let index = 0; index < this.tabs.length; index++) {
                this.tabs[index].active = false;
            }

            this.extraScreenTab.active = this.extraScreenTab.visible = true;

        },

        async saveExtraScreens() {

            if ( !this.extraScreensVisibleFlag ) return;


            //'M' = select matterid from matfield
            //'D' = select docscreenid, matterid from matdocsc
            //'P' = select docscreenid, partyid  from parfield
            //'R' = select rolescreenid, matpartyid from ParRolSc


            await asyncForEach( this.visibleExtraScreens, async (extraScreen) => {

                let extraScreenData = {};

                if ( extraScreen.screentype == 'M' ) {
                    
                    extraScreenData.matterId = this.record.recordid;
                    
                } else if ( extraScreen.screentype == 'D' ) {
                    
                    extraScreenData.docScreenId = extraScreen.recordid;
                    
                    extraScreenData.matterId = this.record.recordid;
                    
                } else if ( extraScreen.screentype == 'P' ) {
                    
                    extraScreenData.docScreenId = extraScreen.recordid;
                    
                    extraScreenData.partyId = this.record.recordid;
                    
                } else if ( extraScreen.screentype == 'R' ) {
                    
                    extraScreenData.roleScreenId = extraScreen.recordid;

                    extraScreenData.matPartyId = this.record.recordid;
                    
                } 


                extraScreen.formFields.forEach(formField => {

                    let inputField = $('#' + this.id + '-extra-field-input-' + extraScreen.recordid + '-' + formField.fieldNumber);

                    if ( inputField.length ) {

                        if ( formField.type == 'date' ) {
                            extraScreenData['field' + formField.fieldNumber] = convertToClarionDate(inputField.val());
                        } else {
                            extraScreenData['field' + formField.fieldNumber] = inputField.val();
                        }

                    }

                });

                extraScreenData.queryString = jQuery.param(extraScreenData);

                let response = await axios.post('/extrascreens/store', {...extraScreenData, screenType: extraScreen.screentype});

                if (response.data.errors || response.data.error) {

                    if (response.data.errors) { 
                        root.$snotify.simple('Saving ExtraScreen (' + extraScreen.description + ') data:' + response.data.errors, 'Error', { timeout: 3000, icon: 'img/delete.png' });
                    } else { 
                        root.$snotify.simple('Saving ExtraScreen (' + extraScreen.description + ') data:' + response.data.error, 'Error', { timeout: 3000, icon: 'img/delete.png' });
                    }

                }

            });            
        },

    },

})
