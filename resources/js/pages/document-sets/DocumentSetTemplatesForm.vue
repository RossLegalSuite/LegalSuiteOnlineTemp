<template>

<div :id="id" :class="modal ? 'modal': ''">
<!--     
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lgr' : ''">

        <div :id="id + '-form-border'" :class="modal ? 'modal-content steelblue-border':'card h-100 border-0'">

            <div :id="id + '-form-header'" :class="modal ? 'steelblue':'card-header'">

                <div :class="modal ? 'modal-header' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="!editing">Template will be Added</span>
                            <span v-else v-html="pageTitle()"></span>
                        </h3>
                        <i v-if="modal" :id="id + '-modal-close-button'" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="card-body form-tab-body overflow-auto p-3" :style="modal ? 'min-height:50vh' : ''">

                <div class="form-group row">

                    <text-input
                        _class="col-md-4"
                        v-model="record.title"
                        name="title"
                        label="Title"
                        :error="errors.title"
                    />

                    <text-input
                        _class="col-md-8"
                        v-model="record.description"
                        name="description"
                        label="Description"
                        :error="errors.description"
                    />


                </div>

                <div v-if="errors.pdfFile && !errors.fileName" class="mt-3 text-danger" v-html="errors.pdfFile[0]"/>
                <div v-if="errors.docxFile && !errors.fileName" class="mt-3 text-danger" v-html="errors.docxFile[0]"/>

                <div v-show="!pdfFile" class="form-group row" style="flex-shrink: 0; flex-grow: 1; margin-bottom: 0 !important;">
                    <div class="col-md-12">

                        <label>Template</label>
                        <span>
                            <pop-over content="
                                <h4>Document Template</h4>
                                <p>A Template is a Word Document with placeholders which indicate where data from the program must be inserted.</p>
                                <p>These placeholders are replaced with data when the document is assembled or <em>merged</em> with a Matter, Party, Employee etc.</p>
                                <p>You can make your own Templates and use them to assemble documents to generate letters to your Clients or even assemble complex legal documents.</p>
                                <p>The generated documents will contain data from each Client thus creating documents customized individually for each Client.</p>
                                " 
                                :container="'#' + this.id"
                            />
                        </span>
                        <vue-dropzone
                            class="boxed"
                            :id="id + '-drop-zone-component'"
                            ref="drop-zone-component" 
                            :options="dropOptions" 
                            :useCustomSlot=true 
                            @vdropzone-error="documentUploadError"
                            @vdropzone-success="documentUploaded"
                        >
                            <div class="dropzone-custom-content cp">
                                <h3 class="text-success">Drag and drop a Word Document here</h3>
                                <div class="subtitle">...or click anywhere in this box to manually select a document</div>
                                <h4 v-if="errors.fileName" v-html="'Please upload a document'" class="mt-3 text-danger text-center"></h4>
                            </div>
                        </vue-dropzone>


                    </div>
                </div>

                <div v-show="pdfFile" class="row mt-3">
                    <div class="col-md-12">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h4>Template</h4>
                            </div>
                            <div>
                                <button class="btn btn-danger btn-sm d-inline-block mr-2" @click="testMerge" title="Generate a test Document using this Template"><i class="fa fa-file-word-o mr-2"></i>Test Document</button>
                                <button class="btn btn-secondary btn-sm d-inline-block mr-2" @click="replaceDocument" title="Replace the Template"><i class="fa fa-refresh mr-2"></i>Replace</button>
                                <button class="btn btn-primary btn-sm d-inline-block" @click="downloadDocument" title="Download the Template"><i class="fa fa-download mr-2"></i>Download</button>
                            </div>
                        </div>
                    </div>
                </div>
                

                <div v-show="pdfFile" style="min-height:50vh; padding-right: 1.5vw;" class="row">
                    <div class="col-md-12">
                        <iframe class="iframe-container" :id="id + '-pdf-iframe'"></iframe>
                    </div>
                </div>

            </div>

            <div class="modal-footer justify-content-between">
                <div>

                    <button v-show="editing" class="btn btn-primary form-button mr-3" type="button" @click="deleteClicked">
                        <span title="Delete this Template"><i class="fa fa-trash fa-lg mr-2"></i>Delete</span>
                    </button>

                </div>

                <div>

                    <button class="btn btn-success form-button mr-3" @click="okClicked" type="button" 
                    :title="uploading ? 'Uploading the Document' : 'Save the Template'">
                        <i :class="uploading ? 'fa fa-upload': 'fa fa-check-circle' + ' fa-lg mr-2'"></i>
                        <span v-html="uploading ? 'Uploading...' : 'Save'"></span>
                    </button>

                    <button v-if="editing" class="btn btn-danger form-button" @click="hide" type="button" title="Close without saving"><i class="fa fa-times-circle fa-lg mr-2"></i>Close</button>
                    <button v-else class="btn btn-danger form-button" @click="hide" type="button" title="Exit without saving"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>

                </div>
            </div>

        </div>
    </div> -->

    <!-- This was causing a circular call in webpack???
    <select-matter :formControls="false" :id="id + '-select-matter'" :ref="id + '-select-matter'" :formRef="id + '-select-matter'"/> -->

</div>

</template>

<script>

//import vueDropzone from "vue2-dropzone";

//import MergeTemplate from "@pages/merge-template";
import FormTemplate from "@pages/form-template";
import modalTemplate from "@components/modals/modal-template";

export default {

    //mixins: [MergeTemplate, FormTemplate, modalTemplate],

    components: {
        //SelectMatter: () => import("@pages/matters/SelectMatter"),
        //vueDropzone: vueDropzone,
    },

    props: {
        id: String,
        resource: {type: String, default: 'Document Templates' },
        modal: {
            type: Boolean,
            default: false
        },
    },

    methods: {

        editRecord(id) {

            axios.post('/document_templates/get',{recordid: id})

            .then(response => {
                
                this.record = response.data.data[0];

                this.pdfFile = this.record.pdfFile; //Being watched

                this.editing = true;

                this.initFormData();

                setTimeout(function(){
                    $('input[name="title"]').focus();
                });

            });

        },

        initNewRecord(id) {

            this.record = {
                title: null,
                description: null,
                documentSetId: id,
                path: null,
                fileName: null,
                pdfFile: null,
                source: 'Matters',
                employeeId: root.loggedInEmployeeId,
            };

            this.pdfFile = null;

            this.initFormData();

            setTimeout(function(){
                $('input[name="title"]').focus();
            });

        },

        initFormData() {

            this.errors = {}; 

            this.uploading = false; // Show the Save button

            this.displayForm();

            //https://rowanwins.github.io/vue-dropzone/docs/dist/#/methods

            this.$refs['drop-zone-component'].removeAllFiles(true);

        },

        setOptions(id = null) {

            this.abortMerge = false;

            this.mergeOptions = {
                source: this.record.docxFile,
                destinationFileName: this.record.fileName,
                destinationFolder: 'merged',
                dataSource: 'Matters',
                id: id,
                download: false,
            };

        },

        async testMerge() {
            
            this.selectMatter.selectMatter(this);

        },

        okClicked(closeForm = true) {

            if ( this.uploading ) {
                showError('Document is uploading', 'Please wait for the upload to complete.');
                return;
            }

            axios.post('/document_templates/store', this.record)
            
            .then(response => {

                if (response.data.errors) {

                    if (response.data.errors.general) { showError( 'Error', response.data.errors.general[0]);} else { this.errors = response.data.errors; }

                } else {

                    this.errors = {};

                    if ( closeForm ) {

                        this.highlightTableRow(response.data.id, response.data.title);

                        this.closeForm();

                    }

                }

            });


        },

        highlightTableRow( id, title) {

            axios.post('/document_templates/getTablePosition', {
                title: title,
            })

            .then(response => {

                this.table.jumpToRow(id, response.data);

            });

        },     

        pageTitle() {

            return this.record.title;

        },
    }

}

</script>


<style src='vue2-dropzone/dist/vue2Dropzone.min.css'></style>

