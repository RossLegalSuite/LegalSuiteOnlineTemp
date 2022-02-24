<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lg' : ''">

        <div :class="modal ? 'modal-content documents-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header documents-bg' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3 v-text="pageTitle()"/>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>


            <div class="modal-body p-0" style="overflow:unset">
                    
                <!-- <div :id="id + '-top-of-form-marker'"/> -->
                <div :id="id + '-pdf-container'" style="min-height: 200px;">

                    <iframe class="iframe-container" :id="_uid + '-preview-document-pdf-iframe'"></iframe>
                    <iframe class="iframe-container d-none" :id="_uid + '-preview-document-print-iframe'"></iframe>

                </div>
            </div>

            <div class="modal-footer justify-content-between">
                <div>
                    <div>
                        <button class="btn btn-success form-button mr-3" type="button" @click="printDocument" title="Print the document"><i class="fa fa-print fa-lg mr-2"></i>Print</button>
                        <button class="btn btn-danger form-button mr-3" type="button" @click="emailDocument(null,null)" title="Send via email"><i class="fa fa-envelope-o fa-lg mr-2"></i>Email</button>
                        <button class="btn btn-primary form-button mr-3" type="button" @click="downloadDocument" title="Download the document"><i class="fa fa-download fa-lg mr-2"></i>Download</button>
                    </div>
                </div>
                <div>
                    <button class="btn btn-danger form-button" @click="closeForm" type="button" title="Exit without saving"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
                </div>
            </div>

        </div>
    </div>
</div>

</template>    

<script>

import FormTemplate from "@pages/form-template";
import modalTemplate from "@components/modals/modal-template";

export default {
    
    mixins: [FormTemplate, modalTemplate],

    props: {
        resource: {type: String, default: 'Documents' },
    },

    data() {
        return {
            documentPath: null,
            document: null,
        };
    },    

    mounted() {
        root.documentsRightForm = this;
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

    methods: {

        editRecord(id) {

            axios.post('/doclog/get/' + id)

            .then(response => {

                this.document = response.data.data[0];

                this.displayForm(); 

                this.documentPath = this.document.url;

            }).catch(error => { 
                showError('Error',error);
            }); 

        },

        downloadDocument() {

            root.downloadObject(this.document.url);

        },

        async emailDocument( title, subject) {

            try {

                let emailModal = this.$root.emailModal;

                emailModal.initialize();

                emailModal.toAddress = this.document.partyemailaddress;

                if ( !title ) {
                    emailModal.title = 'Email ' + this.document.description;
                } else {
                    emailModal.title = title
                }

                if ( !subject ) {
                    emailModal.subject = this.document.description;
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

                showError('Error loading Email in Documents Form', error); 

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

        pageTitle() {

            let parent = this.document?.matterfileref || this.document?.partymatterprefix;

            if ( this.document?.description) {
                return parent ? parent + ' - ' + this.document.description : this.document.description;
            } else {
                return '';
            }

        },


    },

}

</script>
