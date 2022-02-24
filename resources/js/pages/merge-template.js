export default Vue.extend({

        // See: https://www.dropzonejs.com/#configuration-options
        data() {
            return {
                source: null,
                uploading: false, // Toggle the Save button
                pdfFile: null,
                dropOptions: {
                    url: "/file/selected",
                    maxFilesize: 50, // 50MB
                    createImageThumbnails: false,
                    acceptedFiles: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
                },
    
            };
        },
    
        watch: {
    
            abortMerge: function (newValue) {
    
                if ( newValue === true ) root.$snotify.clear();
    
            },
    
            pdfFile: function(newValue) {
    
                if ( newValue ) {
                    
                    setTimeout(() => {
                        
                        $('#' + this.id + '-pdf-iframe')[0].src = newValue;
                        
                    });
                }
                
            }
        },

    methods: {


        async employeeSelected( id, name ) {

            root.$snotify.simple(this.record.title + ' with ' + name, 'Assembling', { timeout: 0, icon: 'img/cogs.gif' });

            await root.documentAssembly.createEmployeeDocument( id )
            .then ( convertResponse => {
                this.showMergedDocument(convertResponse);
            }); 

            root.$snotify.clear();

        },

        // Override default one set in form-template.js
        async customMatterSelected( selectedRecord ) {

            root.$snotify.simple(this.record.title + ' with ' + selectedRecord.fileref, 'Assembling', { timeout: 0, icon: 'img/cogs.gif' });

            await root.documentAssembly.createMatterDocument( id )
            .then ( convertResponse => {
                this.showMergedDocument(convertResponse);
            });

            root.$snotify.clear();


        },
        
        // Override default one set in form-template.js
        async customPartySelected( selectedRecord ) {

            root.$snotify.simple(this.record.title + ' with ' + selectedRecord.name, 'Assembling', { timeout: 0, icon: 'img/cogs.gif' });

            await root.documentAssembly.createPartyDocument( id )
            .then ( convertResponse => {
                this.showMergedDocument(convertResponse);
            });

            root.$snotify.clear(); 

        },


        async matterPartySelected( id, name ) {

            root.$snotify.simple(this.record.title + ' with ' + name, 'Assembling', { timeout: 0, icon: 'img/cogs.gif' });

            await root.documentAssembly.createMatterPartyDocument( id )
            .then ( convertResponse => {
                this.showMergedDocument(convertResponse);
            }); 

            root.$snotify.clear();

        },


        showMergedDocument(convertResponse) {

            let pdfDocument = {
                description: this.record.description,
                fileName: getFileName(convertResponse.url),
                url: convertResponse.url,
                path: convertResponse.path,
            };

            this.$root.previewPdf.title = this.record.title;

            this.$root.previewPdf.document = pdfDocument;

            this.$root.previewPdf.documentPath = convertResponse.url; //Being watched: To load the iFrame

            this.$root.previewPdf.show();

        },

        checkDocumentSource(docxFile) {

            //https://docxtemplater.readthedocs.io/en/latest/faq.html#get-list-of-placeholders
            root.documentAssembly.loadFile(docxFile, ( error, content ) => {

                if (error) {
                    this.source = 'General';

                    throw error; //Ajax error is handled in window.onerror in custom.js

                } else {

                    var zip = new PizZip(content);

                    //console.log('zip.files[word/document.xml]',zip.files['word/document.xml']);

                    var iModule = InspectModule();
                    const doc = new Docxtemplater(zip, { modules: [iModule] });
                    doc.render();

                    const tags = iModule.getAllTags();

                    let partyFields = false, matterFields = false, employeeFields = false;

                    //https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/entries
                    for (const [key, value] of Object.entries(tags)) {

                        if ( key.indexOf("party.") !== -1 || key.indexOf("parties") !== -1 ) {
                            partyFields = true;
                        } else if ( key.indexOf("matter.") !== -1 || key.indexOf("matters") !== -1 ) {
                            matterFields = true;
                        } else if ( key.indexOf("employee.") !== -1 || key.indexOf("employees") !== -1 ) {
                            employeeFields = true;
                        }
                    }

                    if ( partyFields && matterFields ) {
                        this.source = 'Party Roles';
                    } else if ( partyFields ) {
                        this.source = 'Parties';
                    } else if ( matterFields ) {
                        this.source = 'Matters';
                    } else if ( employeeFields ) {
                        this.source = 'Employees';
                    } else {
                        this.source = 'General';
                    }

                    //console.log('checkDocumentSource() source',this.source);
                }
                
            });

        },

        async documentUploaded(file) {

            this.uploading = true; // Hide the Save button

            this.pdfFile = '';// Clear this in case they upload the same file name

            var formData = new FormData();

            formData.append("file", file);
            formData.append("fileName", file.name);
            formData.append("folder", 'templates');

            let response = await axios.post('/file/upload', formData, {
                headers: {'Content-Type': 'multipart/form-data'}
            });

            if (response.data.error) {

                showError('Error uploading document',response.data.error);

                this.uploading = false; // Show the Save button

            } else {

                this.record.path = response.data.path;
                this.record.fileName = file.name;
                this.record.docxFile = response.data.url;

                this.checkDocumentSource(this.record.docxFile);

                if (!this.record.title) this.record.title = this.record.fileName.split('.')[0];
                if (!this.record.description) this.record.description = this.record.fileName.split('.')[0];

                const convertOptions = {
                    destinationPath: 'templates',
                    docxFileName: file.name,
                    source: this.record.docxFile,
                    sourceLocation: 'cloud',
                };

                let convertResponse = await root.documentAssembly.convertToPdf(convertOptions);

                this.uploading = false; // Show the Save button
                
                if ( convertResponse.error ) {

                    showError('PDF Conversion Error',convertResponse.error);

                } else {

                    this.record.pdfFile = this.pdfFile = convertResponse.url;

                    if ( this.editing ) {

                        //Update the record but don't close the form
                        this.okClicked(false);

                    }

                }

            }

        },
        
 
        downloadDocument() {

            root.downloadObject(this.record.docxFile,'application/vnd.openxmlformats-officedocument.wordprocessingml.document');

        },
        replaceDocument() {

            this.$refs['drop-zone-component'].removeAllFiles();

            this.record.path = null;
            this.record.fileName = null;

            $('#' + this.id + '-drop-zone-component').click();

        },

        documentUploadError(file, message, xhr)  {

            showError('Error uploading document', message);

            this.$refs['drop-zone-component'].removeAllFiles();

        },

    },
})
