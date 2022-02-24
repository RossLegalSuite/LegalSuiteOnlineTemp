<template>

    <div class="modal" :id="id" style="z-index: 3000">
        <div class="modal-dialog modal-dialog-centered modal-lgr">
            <div class="modal-content red-border">

                <div class="modal-header red-bg">
                    <div class="page-title">
                        <h3>
                            <i class='fa fa-file-pdf-o mr-2'></i>
                            <span v-html="title"></span>
                        </h3>
                        <i :id="id + '-modal-close-button'" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>
                </div>

                <div class="modal-body p-0" style="max-height: 75vh; min-height: 50vh; overflow-y: auto;">
                    
                    <div :id="id + '-body'" style="min-height:70vh">

                        <iframe class="iframe-container" :id="_uid + '-preview-document-pdf-iframe'"></iframe>
                        <iframe class="iframe-container d-none" :id="_uid + '-preview-document-print-iframe'"></iframe>

                    </div>
                </div>

                <div class="modal-footer justify-content-between">
                    <div>
                        <button v-show="showPrintButton" class="btn btn-success form-button mr-3" type="button" @click="printDocument" title="Print the document"><i class="fa fa-print fa-lg mr-2"></i>Print</button>
                        <button v-show="showEmailButton" class="btn btn-danger form-button mr-3" type="button" @click="emailDocument(null,null)" title="Send via email"><i class="fa fa-envelope-o fa-lg mr-2"></i>Email</button>
                        <button v-show="showDownloadButton" class="btn btn-primary form-button mr-3" type="button" @click="downloadDocument" title="Download the document"><i class="fa fa-download fa-lg mr-2"></i>Download</button>
                    </div>
                    <div>
                        <button class="btn btn-danger form-button" type="button" data-dismiss="modal" title="Close this window"><i class="fa fa-times-circle fa-lg mr-2"></i>Close</button>
                    </div>
                </div>

            </div>
        </div>
    </div>

</template>

<script>

import modalTemplate from "./modal-template";

export default {

    mixins: [modalTemplate],

    data() {
        return {
            title: null,
            subTitle: null,
            document: null,
            documentPath: null,
            showPrintButton: true,
            showEmailButton: true,
            showDownloadButton: true,
        }
    },

    watch: {

        documentPath: function(newValue) {

            $('#' + this._uid + '-preview-document-pdf-iframe')[0].src = '';

            if (newValue) {

                setTimeout(() => {
                    
                    $('#' + this._uid + '-preview-document-pdf-iframe')[0].src = newValue;

                });
            
            }
        }
    },

    mounted() {

        this.$parent.previewDocument = this;

    },


    methods: {

        // onHidden() is called by modal-template.js on hidden.bs.modal event 
        onHidden() {

            // Clear the iFrame so it is blank the next time 
            // so it doesn't briefly show the previously viewed document)
            this.documentPath = null;

        },

        downloadDocument() {

            root.downloadObject(this.document.url);

        },

        async emailDocument( title, subject) {

            try {

                let emailModal = this.$root.emailModal;

                emailModal.initialize();

                if ( title == null ) {
                    emailModal.title = 'Email ' + this.title;
                } else {
                    emailModal.title = title
                }

                if ( subject == null ) {
                    emailModal.subject = this.title;
                } else {
                    emailModal.subject = subject
                }

                emailModal.defaultAttachmentUploaded = true;
                emailModal.emailAttachments.table.defaultAttachmentUploaded = true;

                emailModal.emailAttachments.table.addAttachment(this.document.description, this.document.url);

                let template = await axios.post('/lolsystemtemplate/get/' + root.lolSettings.documentemailtemplateid )

                if ( template.data.errors ) {

                    showError('Error',template.data.errors);

                } else {

                    emailModal.templateRecord = template.data.data[0];
                    emailModal.templateContents = template.data.data[0].contents;
                    emailModal.source = template.data.data[0].source;

                    emailModal.show();

                    emailModal.templateData = root.initTemplateData();

                    emailModal.templateData.documents = [];
                    emailModal.templateData.documents.push(this.document);

                    emailModal.generateEmailBody();
                }

            } catch(error) { 

                showError('Error loading Email in Preview Document', error); 

            };

        },

        printDocument() {

            // Need to get a local copy of the blob - otherwise browser blocks javascript from accessing iFrame content from another site.

            fetch(this.document.url, {
                method: 'GET',
            })

            .then((resp) => {
                return resp.blob();
            })

            .then((blob) => {

                var objectURL = URL.createObjectURL(blob);

                $('#' + this._uid + '-preview-document-print-iframe')[0].src = '';
                $('#' + this._uid + '-preview-document-print-iframe')[0].src = objectURL;

                objectURL = URL.revokeObjectURL(blob);
            })

            .then(() => {

                window.setTimeout(() => {
                    $('#' + this._uid + '-preview-document-print-iframe')[0].contentWindow.print();
                }, 100)

            });

        },        

    }

}
</script>

