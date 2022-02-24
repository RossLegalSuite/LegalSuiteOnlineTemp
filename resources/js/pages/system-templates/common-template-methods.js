export default Vue.extend({

    data() {
        return {
            templateData: {
                matter: {},
                client: {},
                party: {},
                matParty: {},
                report: {},
                documents: [],
            },
            savedFlag: false,
            previewingContent: false,
            showContentPreviewFlag: false,
            systemTemplate: false,
            availableSpace: null,
            contentEditor: null,
            contentPreviewerContents: null,
            selectedMatter: null,
            selectedParty: null,
        }
    },

    watch: {

        source(newValue) {

            this.createPreviewTemplateData(newValue);

        },

    },

    methods: {

        createPreviewTemplateData(source) {

            this.templateData = root.initTemplateData();

            if ( source === 'Report' ) {

                this.createReportExampleTemplateData();

            } else if ( source === 'Documents' ) {

                this.createDocumentExampleTemplateData();

            } else  {
                
                if ( source == 'Matter' ) {

                    if ( $.isEmptyObject(this.templateData.matter) ) {

                        axios.post('/matter/first')

                        .then( async response => {

                            if ( response.data.errors ) {

                                showError('Error',response.data.errors);

                            } else {

                                this.templateData = await this.getPreviewTemplateData('matter',response.data.recordid);

                            }

                        }).catch(error => { 

                            showError('Error',error);

                        });

                    }

                } else if ( source == 'Party' ) {

                    if ( $.isEmptyObject(this.templateData.party) ) {

                        axios.post('/party/first')

                        .then( async response => {

                            if ( response.data.errors ) {

                                showError('Error',response.data.errors);

                            } else {

                                this.templateData = await this.getPreviewTemplateData('party',response.data.recordid);

                            }

                        }).catch(error => { 

                            showError('Error',error);

                        });

                    }

                }

            }

        },

        async getPreviewTemplateData( tableName, recordId) {

            let sorter = this.record.roleid ? 1 : null;

            return await root.createRecordTemplateData(tableName, this.record, recordId, sorter)

            .then( (templateData) => {

                return templateData;

            }).catch( (error) => {

                showError('Generating Preview getPreviewTemplateData Error',error);

                return {};

            });
        },

        loadContentEditor( displayFlag = true ) {

            if ( !this.contentEditor ) {

                this.contentEditor = $('#' + this.id + '-content-editor').summernote({
                    callingComponent: this,
                    height: this.availableSpace,
                    addDefaultFonts: false,
                    focus: this.editing, 
                    toolbar: summerNoteToolBar(),
                    previewMethod: this.showPreview,
                    previewMethodParams: 'Contents',
                    buttons: { ...addToggleCodeViewButton(), ...addPreviewTemplateButton(), ...addTemplateFieldsButton()},

                });
            } else {
                $('#' + this.id + '-content-tab .note-editor').toggle(displayFlag);
            }
            
            this.contentEditor.summernote('code',this.record.contents);

        },

        showPreview( section = 'Contents') {

            if (section == 'Contents') {

                if ( !this.contentEditor.summernote('code') ) {

                    root.$snotify.simple('Nothing to preview - please add some contents', 'Error', { icon: 'img/delete.png' });
                    return;

                } else {

                    this.previewingContent = true;

                }

            } else if (section == 'Header') {

                if ( !this.headerEditor.summernote('code') ) {

                    root.$snotify.simple('Nothing to preview - please add some contents', 'Error', { icon: 'img/delete.png' });
                    return;

                } else {

                    this.previewingHeader = true;

                }
            } else if (section == 'Footer') {

                if ( !this.footerEditor.summernote('code') ) {

                    root.$snotify.simple('Nothing to preview - please add some contents', 'Error', { icon: 'img/delete.png' });
                    return;

                } else {

                    this.previewingFooter = true;

                }
            }
            
            if ( this.record.source === 'Party')   {

                if ( this.selectedParty ) {
                    this.partySelected(this.selectedParty);
                } else {
                    this.selectParty.selectParty(this);
                }

            } else if ( this.record.source === 'Matter' ) {

                if ( this.selectedMatter ) {
                    this.matterSelected(this.selectedMatter);
                } else {
                    this.selectMatter.selectMatter(this);
                }

            } else if ( this.record.source === 'Report' ) {

                this.loadReport();

            } else if ( this.record.source === 'Documents' ) {

                this.setPreviewMode();

            } else  {

                this.templateData = root.initTemplateData();

                this.setPreviewMode();

            }

        },

        createDocumentExampleTemplateData() {

            this.templateData.documents = [
                { 
                    description: 'Document1',
                    fileName: 'document1.pdf',
                },
                { 
                    description: 'Document2',
                    fileName: 'document2.pdf',
                },
            ];
        },

        createReportExampleTemplateData() {

            this.templateData.report = {

                title: this.record.title,
                date: moment().format(root.control.dateformat + ' HH:mm:ss'),

            };

            this.templateData.report.columns = [
                { 
                    title: 'Column 1',
                    render: ( row ) => { return row.data1},
                },
                { 
                    title: 'Column 2',
                    render: ( row ) => { return row.data2},
                },
                { 
                    title: 'Column 3',
                    render: ( row ) => { return row.data3},
                },
                { 
                    title: 'Column 4',
                    render: ( row ) => { return row.data4},
                },
                { 
                    title: 'Column 5',
                    render: ( row ) => { return row.data5},
                },
            ];

            
            this.templateData.report.rows = [
                {
                "data1": "Row 1",
                "data2": "Row 1",
                "data3": "Row 1",
                "data4": "Row 1",
                "data5": "Row 1",
                }, 
                {
                "data1": "Row 2",
                "data2": "Row 2",
                "data3": "Row 2",
                "data4": "Row 2",
                "data5": "Row 2",
                }, 
                {
                "data1": "Row 3",
                "data2": "Row 3",
                "data3": "Row 3",
                "data4": "Row 3",
                "data5": "Row 3",
                }, 
            ];

            return this.templateData;

        },

        loadReport() {

            this.createReportExampleTemplateData();

            this.setPreviewMode();
        },

        async previewPdfDocument() {

            // This is shared by SystemTemplatesForm.vue and SystemComponentsForm.vue
            // So use this to switch between the different save methods
            let saveMethod = (typeof this.saveTemplate === 'function') ? this.saveTemplate : this.saveComponent;

            saveMethod( false )

            .then( () => {

                let createTemplateDataMethod = root.initTemplateData;

                if ( this.source == 'Matter' ) {

                    createTemplateDataMethod =  this.createMatterTemplateData;

                } else if ( this.source == 'Party' ) {
                    
                    createTemplateDataMethod =  this.createPartyTemplateData;

                } else if ( this.source == 'Report' ) {

                    createTemplateDataMethod = createReportExampleTemplateData;

                } 

                root.$snotify.simple('Please wait...', 'Creating PDF', { timeout: 0, icon: 'img/cogs.gif' });

                axios.post('/lolsystemtemplate/get/' + this.record.recordid)

                .then(async response => {

                    if ( response.data.errors ) {

                        showError('Error',response.data.errors);

                    } else {

                        let templateData = await createTemplateDataMethod();

                        await generatePdfDocument({
                            templateRecord: response.data.data[0],
                            templateData: templateData,
                            folder: 'previews', 
                            fileName: 'preview.pdf',
                        })
                        .then(response => {

                            root.$snotify.clear();

                            root.previewPdf.documentPath = response.url; //Being watched: To load the iFrame

                            root.previewPdf.show();

                        }).catch(error => { 

                            showError('Generating Pdf Error',error);

                        });

                    }

                }).catch(error => { 

                    showError('Error',error);

                });


            });

        },

        async createMatterTemplateData() {

            return await root.createRecordTemplateData('matter',this.record, this.currentRecord.recordid, 1)

            .then( (templateData) => {

                this.templateData = templateData;

                return templateData;

            }).catch( (error) => {

                showError('Generating Preview createTemplateData Error',error);

                return {};

            });

        },

        async createPartyTemplateData() {

            return await root.createRecordTemplateData('party', this.record, this.currentRecord.recordid)

            .then( (templateData) => {

                this.templateData = templateData;

                return templateData;

            }).catch( (error) => {

                showError('Generating Preview createTemplateData Error',error);

                return {};

            });

        },

        async matterSelected( selectedRecord ) {

            this.selectedMatter = this.currentRecord = selectedRecord; // Required to create TemplateData

            this.templateData = await root.createRecordTemplateData('matter',this.record, selectedRecord.recordid, 1)

            .then( (templateData) => {

                return templateData;

            }).catch( (error) => {

                showError('Creating Matter TemplateData Error',error);

                return {};

            });

            if ( this.templateData.loaded ) {
                this.setPreviewMode();
            }
        },

        async partySelected( selectedRecord ) {

            this.selectedParty = this.currentRecord = selectedRecord; // Required to create TemplateData

            this.templateData = await root.createRecordTemplateData('party',this.record, selectedRecord.recordid, 1)

            .then( (templateData) => {

                return templateData;

            }).catch( (error) => {

                showError('Creating Party TemplateData Error',error);

                return {};

            });

            if ( this.templateData.loaded ) {
                this.setPreviewMode();
            } else {
                this.previewingContent = this.previewingHeader = this.previewingFooter = false;
            }

        },

        setEditMode( section = 'Contents' ) {

            if ( section == 'Contents' ) {
                
                this.hideContentPreviewer();

            } else if ( section == 'Header' ) {
                
                this.hideHeaderPreviewer();

            } else if ( section == 'Footer' ) {
                
                this.hideFooterPreviewer();

            }

        },

        setPreviewMode() {

            if ( this.previewingContent && !this.showContentPreviewFlag ) {

                this.showContentPreviewer();

                root.vueRender( this.contentEditor.summernote('code'), this.templateData )

                .then( (renderedHtml) => {

                    this.setContentPreviewContents(renderedHtml);
                
                }).catch(error => { 

                    showError('Error', error)

                    this.hideContentPreviewer();

                });  
            }                                       

            if ( this.previewingHeader && !this.showHeaderPreviewFlag ) {

                this.showHeaderPreviewer();

                root.vueRender( this.headerEditor.summernote('code'), this.templateData )

                .then( (renderedHtml) => {

                    this.setHeaderPreviewContents(renderedHtml);
                
                }).catch(error => { 

                    showError('Error', error)

                    this.hideHeaderPreviewer();

                });  
                
            }

            if ( this.previewingFooter && !this.showFooterPreviewFlag ) {

                this.showFooterPreviewer();

                root.vueRender( this.footerEditor.summernote('code'), this.templateData )

                .then( (renderedHtml) => {

                    this.setFooterPreviewContents(renderedHtml);
                
                }).catch(error => { 

                    showError('Error', error)

                    this.hideFooterPreviewer();

                });                                         
            }
        },

        showContentPreviewer() {

            $('#' + this.id + '-content-tab .note-editor').toggle();

            this.showContentPreviewFlag = true;

            this.setContentPreviewContents('<h3 class="mt-5 text-center">Generating contents .... please wait.</h3>');

        },

        hideContentPreviewer() {

            this.setContentPreviewContents('');

            this.previewingContent = this.showContentPreviewFlag = false;

            $('#' + this.id + '-content-tab .note-editor').toggle();

        },

        setContentPreviewContents( value ) {
            this.contentPreviewerContents.html(value);
        },

    }

})