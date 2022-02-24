<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lgr' : ''">

        <div :class="modal ? 'modal-content blue-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header blue-bg' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3 class="modal-title">
                            <span v-if="!editing && !savedFlag">Template will be Added</span>
                            <span v-else v-html="pageTitle()"></span>
                        </h3>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>


            <div class="modal-body form-tab-body p-3" :style="modal ? 'height:75vh; overflow: unset' : 'overflow: unset'">

                <form-tabs :tabs="tabs"/>

                <div v-show="activeTab === 'General'" class="form-tab-content">

                    <div :id="id + '-top-of-form-marker'"/>

                    <div class="form-group row">

                        <text-input
                            _class="col-md-6"
                            v-model="record.title"
                            name="title"
                            label="Title"
                        />
                    </div>

                    <div class="form-group row">
                        <text-input
                            _class="col-md-12"
                            v-model="record.description"
                            name="description"
                            label="Description"
                        />

                    </div>

                    <div class="form-group row">

                        <div class="col-md-3">

                            <label>Type</label>
                            <pop-over content="
                                <h4>Type</h4>
                                <p>Templates can generate Documents, Emails and Reports.</p>
                                <p>Some are used internally. For example, the Table Report is used as a template to print out the contents of a Table.</p>
                                <p>All templates, however, are editable and you can specify the layout and contents by editing the Template here.</p>"
                            />
                            <v-select 
                                :options="$root.templateTypes" 
                                :searchable="false" 
                                :clearable="false" 
                                v-model="record.type"
                                @option:selected="templateTypeChanged"
                            />

                        </div>

                        <div class="col-md-3">

                            <label>Data Source</label>
                            <pop-over content="
                                <h4>Data Source</h4>
                                <p>The Data Source indicates where the Template gets its data.</p>
                                <p>If set to Party, for example, the Template will retrieve the data from each tagged Party (from the Address Book) and assemble the Document.</p>
                                <p>If set to Matter, the Template will retrieve the data from each tagged Matter and assemble the Document.</p>
                                <p>If set to MatParty, the Template will retrieve the data from each tagged Matter Party and assemble the Document.</p>
                                <p>If set to Report, the Template will retrieve the data from the current table.</p>
                                <p>The Company, Employee and General fields, e.g. <em>company.name</em>, are always avaiable and can be used in any Template regardless of its Data Source.</p>"
                            />
                            <v-select :options="$root.templateSources" :searchable="false" :clearable="false" v-model="record.source"/>

                        </div>

                        <div v-show="source == 'Matter'" class="col-md-6">

                            <label>Role</label>

                            <pop-over content="
                                <h4>Role</h4>
                                <p>A Template that uses the <em>Matter</em> data source will assemble Documents for
                                each tagged Matter (if the Role is not specified).</p>
                                <p>If a Role is selected, e.g. Defendant, Documents will be assembled for every Party who is a Defendant on each Matter. In this case, both the Matter and the Party fields can be used in the Template - the Party fields, with the <em>party</em> prefix, will relate to the Defendant.</p>
                                <p><strong>Note:</strong>
                                <br/>
                                The Matter's Client data is always available using Fields with the <em>client</em> prefix.
                                For example, <strong>&lcub;&lcub;client.name&rcub;&rcub;</strong> will refer to the Client's name and <strong>&lcub;&lcub;party.name&rcub;&rcub;</strong> will refer to the Defendant's name.</p>"
                            />


                            <v-select 
                            :options="templateRoles" 
                            :reduce="templateRoles => templateRoles.recordid"
                            label="description"
                            :searchable="true" 
                            :clearable="true" 
                            v-model="record.roleid"
                            >
                            <span slot="no-options">Role not found</span>
                            </v-select>

                        </div>

                    </div>

                    <div v-show="isEmailType()" class="form-group row">

                        <text-input
                            _class="col-md-8"
                            v-model="record.subject"
                            label="Email Subject"
                            popOver="<h4>Email  Subject</h4>
                            <p>Enter a (default) subject for the email.</p>
                            <p>Note: You can use merge fields here to insert dynamic content, e.g. &#123;&#123;matter.fileref + ' ' + matter.description&#125;&#125;.</p>
                            "
                        />

                    </div>

                </div>

                <div v-show="activeTab === 'Contents'" :id="id + '-content-tab'" class="form-tab-content pt-2 pb-1" style="background: unset; overflow: unset">

                    <div :id="id + '-content-editor'"/>

                    <div v-show="showContentPreviewFlag" style="border: 1px solid rgba(0,0,0,.2);">
                        <div class="note-toolbar card-header" role="toolbar">
                            <div class="note-btn-group btn-group">
                                <button 
                                    type="button"
                                    class="note-btn btn btn-light btn-sm btn-fullscreen" 
                                    tabindex="-1" 
                                    title="Preview the contents in a PDF document"
                                    @click="previewPdfDocument">
                                    <i class="fa fa-file-pdf-o mr-2"></i>Generate PDF
                                </button>
                            </div>
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

                <div v-show="activeTab === 'Header'" :id="id + '-header-tab'" class="form-tab-content pt-2 pb-1" style="background: unset; overflow: unset">

                    <div :id="id + '-header-editor'"/>

                    <div v-show="showHeaderPreviewFlag" style="border: 1px solid rgba(0,0,0,.2);">
                        <div class="note-toolbar card-header" role="toolbar">
                            <div class="note-btn-group btn-group ml-2">
                                <button 
                                    type="button"
                                    class="note-btn btn btn-light btn-sm btn-fullscreen" 
                                    tabindex="-1" 
                                    title="Exit Preview mode"
                                    @click="setEditMode('Header')">
                                    <i class="fa fa-times-circle mr-2"></i>Exit Preview
                                </button>
                            </div>
                        </div>
                        <div class="pt-1 px-2 mb-2 overflow-auto" :id="id + '-header-previewer-contents'">
                        </div>
                    </div>

                </div>

                <div v-show="activeTab === 'Footer'" :id="id + '-footer-tab'" class="form-tab-content pt-2 pb-1" style="background: unset; overflow: unset">

                    <div :id="id + '-footer-editor'"/>

                    <div v-show="showFooterPreviewFlag" style="border: 1px solid rgba(0,0,0,.2);">
                        <div class="note-toolbar card-header" role="toolbar">
                            <div class="note-btn-group btn-group ml-2">
                                <button 
                                    type="button"
                                    class="note-btn btn btn-light btn-sm btn-fullscreen" 
                                    tabindex="-1" 
                                    title="Exit Preview mode"
                                    @click="setEditMode('Footer')">
                                    <i class="fa fa-times-circle mr-2"></i>Exit Preview
                                </button>
                            </div>
                        </div>
                        <div class="pt-1 px-2 mb-2 overflow-auto" :id="id + '-footer-previewer-contents'">
                        </div>
                    </div>
                </div>

                <div v-show="activeTab === 'Settings'" class="form-tab-content pt-2 pb-1">

                    <div class="row">

                        <div class="col-md-6">

                            <fieldset class="mt-3"><legend>Page Settings</legend>

                                <div class="form-group row">
                                    <div class="col-lg-6">
                                        <label>Orientation</label>
                                        <select class="form-control" name="orientation" v-model="record.orientation" title="The default orientation of the PDF document generated by the template"> 
                                            <option value="Portrait">Portrait</option>
                                            <option value="Landscape">Landscape</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group row">

                                    <text-input _class="col-md-6" type="number" input-class="form-input-number" v-model="record.topmargin" name="topmargin" label="Top Margin"/>

                                    <text-input _class="col-md-6" type="number" input-class="form-input-number" v-model="record.bottommargin" name="bottommargin" label="Bottom Margin"/>

                                </div>
                                
                                <div class="form-group row">

                                    <text-input _class="col-md-6" type="number" input-class="form-input-number" v-model="record.leftmargin" name="leftmargin" label="Left Margin"/>

                                    <text-input _class="col-md-6" type="number" input-class="form-input-number" v-model="record.rightmargin" name="rightmargin" label="Right Margin"/>

                                </div>

                            </fieldset>

                        </div>

                        <div class="col-md-6">

                            <fieldset  class="mt-3"><legend>PDF Settings</legend>

                                <div class="form-group row">

                                    <text-input
                                        _class="col-md-6"
                                        v-model="record.password"
                                        name="password"
                                        label="Password"
                                    />
                                </div>

                                <div v-show="record.password" class="form-group row">

                                    <div class="col-md-12">

                                        <b-form-checkbox
                                            :id="id + '-allow-print-checkbox'"
                                            v-model="record.allowprint"
                                            name="allowprintCheckBox"
                                            value="1"
                                            unchecked-value="0"
                                            >
                                            Allow the user to print the PDF
                                            
                                        </b-form-checkbox>
                                    </div>
                                </div>

                                <div v-show="record.password" class="form-group row">

                                    <div class="col-md-12">

                                        <b-form-checkbox
                                            :id="id + '-allow-copy-checkbox'"
                                            v-model="record.allowcopy"
                                            name="allowcopyCheckBox"
                                            value="1"
                                            unchecked-value="0"
                                            >
                                            Allow the user to copy & paste text from the PDF

                                        </b-form-checkbox>
                                    </div>
                                </div>

                                <div v-show="record.password" class="form-group row">

                                    <div class="col-md-12">

                                        <b-form-checkbox
                                            :id="id + '-allow-edit-checkbox'"
                                            v-model="record.allowedit"
                                            name="alloweditCheckBox"
                                            value="1"
                                            unchecked-value="0"
                                            >
                                            Allow the user to edit the PDF (with a PDF editor)

                                        </b-form-checkbox>
                                    </div>
                                </div>

                            </fieldset>

                        </div>
                    </div>

                </div>

            </div>

            <div class="modal-footer justify-content-between">

                <div>

                    <span v-show="activeTab == 'General' && editing" >
                        <button v-show="editing && !systemTemplate" class="btn btn-danger form-button mr-2" type="button" @click="deleteClicked" title="Delete this Template">
                            <i class="fa fa-times-circle fa-lg mr-2"></i>Delete
                        </button>

                        <button v-show="editing" class="btn btn-secondary form-button" type="button" @click="copyClicked" title="Make a copy of this Template">
                            <i class="fa fa-clone fa-lg mr-2"></i>Copy
                        </button>
                    </span>

                </div>

                <div >

                    <button class="btn btn-yellow form-button mr-3" @click="okClicked(false)" type="button" title="Save the Template and continue editing"><i class="fa fa-check-square fa-lg mr-2"></i>Save</button>

                    <button class="btn btn-success form-button mr-3" @click="okClicked(true)" type="button" title="Save the Template and close the Window"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>

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
        resource: {type: String, default: 'Template' },
    },

    data() {
        return {
            headerEditor: null,
            footerEditor: null,
            previewingFooter: false,
            previewingHeader: false,
            showHeaderPreviewFlag: false,
            showFooterPreviewFlag: false,
            templateRoles: root.partyRoles,
            activeTab: 'General',
            tabs: [
                {
                    pageName: "General",
                    title: "Details",
                    iconClass: '',
                    visible: true,
                    active: true,
                },
                {
                    pageName: "Contents",
                    title: "Contents",
                    iconClass: '',
                    visible: true,
                    active: false,
                },
                {
                    pageName: "Header",
                    title: "Header",
                    iconClass: '',
                    visible: true,
                    active: false,
                },
                {
                    pageName: "Footer",
                    title: "Footer",
                    iconClass: '',
                    visible: true,
                    active: false,
                },
                {
                    pageName: "Settings",
                    title: "Settings",
                    iconClass: '',
                    visible: true,
                    active: false,
                },
            ],
        };
    },

    computed: {

        source() {
            return this.record.source;
        },

        type() {
            return this.record.type;
        },

    },

    watch: {

        activeTab(newValue) {

            if ( newValue === "Header" ) {
                this.loadHeaderEditor();
            }
            if ( newValue === "Footer" ) {
                this.loadFooterEditor();
            }

        },

    },

    methods: {

        editRecord(id) {

            this.previewingContent = this.previewingHeader = this.previewingFooter = false;
            this.showContentPreviewFlag = this.showHeaderPreviewFlag = this.showFooterPreviewFlag = false;

            this.savedFlag = false;

            this.selectedParty = this.selectedMatter = null;

            this.record.source = null; // To fire the watch to call createPreviewTemplateData() after getting the record

            axios.post('/lolsystemtemplate/get/' + id)

            .then(response => {
                
                this.record = response.data.data[0];

                this.editing = true;

                this.systemTemplate = this.record.recordid == root.lolSettings.reporttemplateid || 
                this.record.recordid == root.lolSettings.reportemailtemplateid ||
                this.record.recordid == root.lolSettings.documentemailtemplateid;

                this.setGeneralTab();

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

            this.previewingContent = this.previewingHeader = this.previewingFooter = false;
            this.showContentPreviewFlag = this.showHeaderPreviewFlag = this.showFooterPreviewFlag = false;

            this.savedFlag = false;

            this.selectedParty = this.selectedMatter = null;

            this.record.source = null; // To fire the watch to call createPreviewTemplateData() after getting the record

            this.record = {
                title: null,
                description: null,
                type: 'Document',
                source: 'Party',
                roleid: null,
                contents: '',
                subject: '',
                header: '',
                footer: '',
                password: '' + (new Date()).getTime(),
                allowprint: true,
                allowcopy: false,
                allowedit: true,
                topmargin: '5',
                bottommargin: '5',
                leftmargin: '5',
                rightmargin: '5',
                orientation: 'Portrait',
            };

            this.editing = false;

            this.setGeneralTab();

            this.displayForm(); 

            this.initFormData();

            setTimeout(function(){
                $('input[name="title"]').focus();
            });

        },

        initFormData() {

            this.errors = {}; 


            this.footerTab = this.tabs.filter(tab => tab.pageName === 'Footer')[0];
            this.headerTab = this.tabs.filter(tab => tab.pageName === 'Header')[0];

            this.toggleHeaderFooterTabs();


            this.contentPreviewerContents = $('#' + this.id + '-content-previewer-contents');
            this.headerPreviewerContents = $('#' + this.id + '-header-previewer-contents');
            this.footerPreviewerContents = $('#' + this.id + '-footer-previewer-contents');

            this.headerEditor = this.footerEditor = null;

            if ( !this.availableSpace ) {

                root.getAvailableSpace('#' + this.id + '-top-of-form-marker', '#' + this.id + ' .modal-footer', 75)

                .then( (availableSpace) => {

                    this.availableSpace = availableSpace;

                    this.contentPreviewerContents.height( this.availableSpace - 10);
                    this.headerPreviewerContents.height( this.availableSpace - 10);
                    this.footerPreviewerContents.height( this.availableSpace - 10);

                    this.loadContentEditor();

                }).catch( (error) => {
                    showError('Error',error)
                });

            } else {

                this.loadContentEditor();

                this.contentPreviewerContents.height( this.availableSpace - 10);
                this.headerPreviewerContents.height( this.availableSpace - 10);
                this.footerPreviewerContents.height( this.availableSpace - 10);

            }

        },

        setOptions( createTemplateDataMethod) {

            const returnData =  {
                title: 'Preview PDF', 
                notifyMessage: 'Generating PDF', 
                folder: 'previews', 
                fileName: 'preview.pdf',
                templateId: this.record.recordid,
                createTemplateData: createTemplateDataMethod,
            };

            return returnData;

        },      



        templateTypeChanged( option ) {

            this.toggleHeaderFooterTabs();
        },

        isEmailType() {
            return this.record?.type == "Email" ? true : false;
        },

        toggleHeaderFooterTabs() {

            this.headerTab.visible = this.footerTab.visible = !this.isEmailType();

        },

        loadHeaderEditor() {

            //if (this.showHeaderPreviewFlag) return;

            if (!this.headerEditor ) {

                this.headerEditor = $('#' + this.id + '-header-editor').summernote({
                    callingComponent: this,
                    height: this.availableSpace,
                    addDefaultFonts: false,
                    focus: false, 
                    toolbar: summerNoteToolBar(),
                    previewMethod: this.showPreview,
                    previewMethodParams: 'Header',
                    buttons: { ...addToggleCodeViewButton(), ...addPreviewTemplateButton(), ...addTemplateFieldsButton()},
                });

            // } else {
            //     $('#' + this.id + '-header-tab .note-editor').toggle(true);
            }

            this.headerEditor.summernote('code',this.record.header);

        },

        loadFooterEditor() {

            //if (this.showFooterPreviewFlag) return;

            if (!this.footerEditor ) {

                this.footerEditor = $('#' + this.id + '-footer-editor').summernote({
                    callingComponent: this,
                    height: this.availableSpace,
                    addDefaultFonts: false,
                    focus: false, 
                    toolbar: summerNoteToolBar(),
                    previewMethod: this.showPreview,
                    previewMethodParams: 'Footer',
                    buttons: { ...addToggleCodeViewButton(), ...addPreviewTemplateButton(), ...addTemplateFieldsButton()},
                });

            // } else {
            //     $('#' + this.id + '-footer-tab .note-editor').toggle(true);
            }

            this.footerEditor.summernote('code',this.record.footer);

        },

        showHeaderPreviewer() {

            $('#' + this.id + '-header-tab .note-editor').toggle();

            this.setHeaderPreviewContents('<h3 class="mt-5 text-center">Generating preview .... please wait.</h3>');
            
            this.showHeaderPreviewFlag = true;
        },

        hideHeaderPreviewer() {

            this.setHeaderPreviewContents('');

            this.previewingHeader = this.showHeaderPreviewFlag = false;

            $('#' + this.id + '-header-tab .note-editor').toggle();

        },

        setHeaderPreviewContents( value ) {
            this.headerPreviewerContents.html(value);
        },

        showFooterPreviewer() {

            $('#' + this.id + '-footer-tab .note-editor').toggle();

            this.setFooterPreviewContents('<h3 class="mt-5 text-center">Generating preview .... please wait.</h3>');

            this.showFooterPreviewFlag = true;
        },

        hideFooterPreviewer() {

            this.setFooterPreviewContents('');

            this.previewingFooter = this.showFooterPreviewFlag = false;

            $('#' + this.id + '-footer-tab .note-editor').toggle();

        },

        setFooterPreviewContents( value ) {
            this.footerPreviewerContents.html(value);
        },

        updateContents() {

            this.record.contents = this.contentEditor.summernote('code');

            if ( this.headerEditor ) this.record.header = this.headerEditor.summernote('code');
            if ( this.footerEditor ) this.record.footer = this.footerEditor.summernote('code');

        },

        saveTemplate( closeFlag = true ) {

            return new Promise(async (resolve, reject) => {

                try {   

                    root.$snotify.simple('Please wait...', 'Saving Template', { timeout: 0, icon: 'img/cogs.gif' });

                    this.updateContents();

                    let response = await axios.post( '/lolsystemtemplate/store', this.record)

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

        okClicked( closeFlag = true ) {

            this.saveTemplate(closeFlag)
            .catch(error => { 

                showError('Error saving Template',error);

            });


        },

        copyClicked() {

            this.saveTemplate( false )

            .then( () => {

                axios.post('/lolsystemtemplate/copy', this.record)
                
                .then(response => {

                    if (response.data.errors) {

                        showError( 'Error', response.data.errors);

                    } else {

                        root.$snotify.simple('The Template was copied successfully', 'Success', { icon: 'img/check.png' });

                        this.highlightRow(response.data.data[0].recordid, {
                            where: "title,<,'" + response.data.data[0].title + "'",
                            orderBy: 'title',
                        });

                    }

                });

            }).catch(error => { 

                showError('Error saving Template',error);

            });

        },

        pageTitle() {

            return this.record.title;

        },

        canDelete() {

            return new Promise((resolve, reject) => {

                if ( this.source === 'components' ) {

                    axios.post('/components/canDelete', {title: this.record.title})

                    .then(response => {

                        if ( !response.data ) {

                            showError('Unable to delete the Component','It is used in at least one Template');

                            reject();

                        } else {

                            resolve();

                        }
                        
                    })

                    .catch(error => {
                        reject();
                    });

                } else {

                    resolve();

                }

            });

        }


    },

}

</script>

