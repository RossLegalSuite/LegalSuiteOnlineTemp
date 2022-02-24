<template>



<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lgr' : ''">

        <div :class="modal ? 'modal-content blue-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header blue-bg' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3 class="modal-title">
                            <span v-if="!editing && !savedFlag">Component will be Added</span>
                            <span v-else v-html="pageTitle()"></span>
                        </h3>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="modal-body p-3" :style="modal ? 'height:75vh; overflow: unset' : 'overflow: unset'">

                <div class="form-group row">

                    <text-input
                        _class="col-md-4"
                        v-model="record.title"
                        name="title"
                        label="Title"
                        :error="errors.title"
                    />

                    <text-input
                        _class="col-md-5"
                        v-model="record.description"
                        name="description"
                        label="Description"
                        :error="errors.description"
                    />

                    <div class="col-md-3">

                        <label>Data Source</label>
                        <v-select :options="$root.templateSources" :searchable="false" :clearable="false" v-model="record.source"/>

                    </div>

                </div>

                <!-- Need this div here to keep it compatible with common-templates-methods code -->
                <div :id="id + '-content-tab'"> 

                    <div :id="id + '-top-of-form-marker'"/>

                    <div :id="id + '-content-editor'"/>

                    <div v-show="showContentPreviewFlag" style="border: 1px solid rgba(0,0,0,.2);">
                        <div class="note-toolbar card-header" role="toolbar">
                            <div class="note-btn-group btn-group ml-2">
                                <button 
                                    type="button"
                                    class="note-btn btn btn-light btn-sm btn-fullscreen" 
                                    tabindex="-1" 
                                    title="Exit Preview mode"
                                    @click="setEditMode('Contents')">
                                    <i class="fa fa-times-circle mr-2"></i>Exit Preview
                                </button>
                            </div>
                        </div>
                        <div class="pt-1 px-2 mb-2 overflow-auto" :id="id + '-content-previewer-contents'">
                        </div>
                    </div>

                </div>

            </div>

            <div class="modal-footer justify-content-between">

                <div>

                    <span v-show="editing" >
                        <button class="btn btn-danger form-button mr-2" type="button" @click="deleteClicked" title="Delete this Component">
                            <i class="fa fa-times-circle fa-lg mr-2"></i>Delete
                        </button>

                        <button v-show="editing" class="btn btn-secondary form-button" type="button" @click="copyClicked" title="Make a copy of this Component">
                            <i class="fa fa-clone fa-lg mr-2"></i>Copy
                        </button>
                    </span>


                </div>

                <div>

                    <button class="btn btn-yellow form-button mr-3" @click="okClicked(false)" type="button" title="Save the Component and continue editing"><i class="fa fa-check-square fa-lg mr-2"></i>Save</button>

                    <button class="btn btn-success form-button mr-3" @click="okClicked(true)" type="button" title="Save the Component and close the Window"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>

                    <button v-if="savedFlag || editing" class="btn btn-danger form-button" @click="closeForm" type="button" title="Close this screen"><i class="fa fa-times-circle fa-lg mr-2"></i>Close</button>

                    <button v-else class="btn btn-danger form-button" @click="closeForm" type="button" title="Exit without saving"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>

                </div>
            </div>

        </div>
    </div>
    <select-matter :formControls="false" :id="id + '-select-matter'" :ref="id + '-select-matter'" :formRef="id + '-select-matter'"/>

    <select-party :formControls="false" :id="id + '-select-party'" :ref="id + '-select-party'" :formRef="id + '-select-party'"/>

</div>

</template>

<script>

import formTemplate from "@pages/form-template";
import modalTemplate from "@components/modals/modal-template";

import templateMethods from "@pages/system-templates/common-template-methods";

export default {

    mixins: [formTemplate, modalTemplate, templateMethods],

    components: {
        SelectMatter: () => import("@pages/matters/SelectMatter"),
        SelectParty: () => import("@pages/parties/SelectParty"),
    },

    props: {
        resource: {type: String, default: 'Component' },
    },

    methods: {

        editRecord(id) {

            this.previewingContent = false;
            this.showContentPreviewFlag = false;

            this.savedFlag = false;

            this.selectedParty = this.selectedMatter = null;

            this.record.source = null; // To fire the watch to call createPreviewTemplateData() after getting the record

            axios.post('/lolcomponent/get/' + id)

            .then(response => {
                
                this.record = response.data.data[0];

                this.editing = true;

                this.displayForm(); 

                this.initFormData();

                setTimeout(function(){
                    $('input[name="title"]').focus();
                });

            }).catch(error => { 
                showError('Error',error);
            }); 

        },

        initNewRecord() {

            this.previewingContent = false;
            this.showContentPreviewFlag = false;

            this.savedFlag = false;

            this.selectedParty = this.selectedMatter = null;

            this.record.source = null; // To fire the watch to call createPreviewTemplateData() after getting the record

            this.record = {
                title: null,
                description: null,
                source: 'Company',
                contents: '',
            };

            this.editing = false;

            this.displayForm(); 

            this.initFormData();

            setTimeout(function(){
                $('input[name="title"]').focus();
            });

        },

        initFormData() {

            this.errors = {}; 

            this.contentPreviewerContents = $('#' + this.id + '-content-previewer-contents');

            if ( !this.availableSpace ) {

                root.getAvailableSpace('#' + this.id + '-top-of-form-marker', '#' + this.id + ' .modal-footer', 75)

                .then( (availableSpace) => {

                    this.availableSpace = availableSpace;

                    this.contentPreviewerContents.height( this.availableSpace - 10);

                    this.loadContentEditor();

                }).catch( (error) => {
                    showError('Error',error)
                });

            } else {

                this.loadContentEditor();

                this.contentPreviewerContents.height( this.availableSpace - 10);


            }
            

        },

        copyClicked() {

            this.saveComponent( false )

            .then( () => {

                axios.post('/lolcomponent/copy', this.record)
                
                .then(response => {

                    if (response.data.errors) {

                        showError( 'Error', response.data.errors);

                    } else {

                        root.$snotify.simple('The Component was copied successfully', 'Success', { icon: 'img/check.png' });

                        this.highlightRow(response.data.data[0].recordid, {
                            where: "title,<,'" + response.data.data[0].title + "'",
                            orderBy: 'title',
                        });

                    }

                });
                
            }).catch(error => { 

                showError('Error saving Component',error);

            });

        },

        updateContents() {

            this.record.contents = this.contentEditor.summernote('code');
        },


        saveComponent( closeFlag = true ) {

            return new Promise(async (resolve, reject) => {

                try {   

                    root.$snotify.simple('Please wait...', 'Saving Component', { timeout: 0, icon: 'img/cogs.gif' });

                    this.updateContents();

                    let response = await axios.post( '/lolcomponent/store', this.record)

                    root.$snotify.clear();

                    if (response.data.errors) { 

                        reject(response.data.errors);

                    } else {

                        this.errors = {};

                        if (closeFlag) {

                            this.highlightRow(response.data.data[0].recordid, {
                                where: "title,<,'" + response.data.data[0].title + "'",
                                orderBy: 'title',
                            });

                            this.hide();

                        } else {
                            this.savedFlag = true;
                        }

                        resolve();

                    }

                } catch(error) { 

                    root.$snotify.clear();

                    reject(error);

                };
                
            });
        },

        okClicked( closeFlag = true) {

            this.saveComponent(closeFlag)

            .catch(error => { 

                showError('Error saving Component',error);

            });


        },

        pageTitle() {

            return this.record.title;

        },



    },

}

</script>

