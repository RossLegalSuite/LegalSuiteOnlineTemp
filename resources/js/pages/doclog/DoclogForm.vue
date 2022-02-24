<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lg' : ''">

        <div :class="modal ? 'modal-content doclog-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header doclog-bg' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="!editing && !savedFlag">Item will be Added</span>
                            <span v-else>Item will be Changed</span>
                        </h3>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="card-body form-tab-body overflow-auto p-3" :style="modal ? 'min-height:50vh' : ''">

                <div class="d-flex justify-content-between">

                    <form-tabs :tabs="tabs"/>

                    <div>

                        <drop-down-button 
                            v-show="activeTab === 'Document' && !isMessage()"
                            :buttons="actionButtons"
                        />

                    </div>

                </div>

                <div v-show="activeTab === 'General'" class="form-tab-content">

                    <div class="form-group row">

                        <div class="col-md-4">

                            <label>Date/Time</label>
                            <date-picker ref="datePickerComponent" v-model="record.datetime" :config="$root.dateTimePickerOptions"/>
                        </div>

                        <text-input v-if="editing" _class="col-md-4" :readOnly="true" v-model="record.employeename" name="createdBy" label="Created By" />

                    </div>

                    <div class="form-group row">
                        <text-input 
                            _class="col-md-12" 
                            v-model="record.description" 
                            name="description"
                            label="Description"
                            popOver="<h4>Description</h4><p>A description of the Item.</p>"
                        />
                    </div>  

                    <div class="form-group row">

                        <div class="col-md-6">

                            <label>Category</label>
                            <pop-over content="
                                <h4>Category</h4>
                                <p>Specify the Category the item belongs to.</p>"
                            />
                            <v-select
                                :options="doclogCategories" 
                                label="description"
                                :clearable="false" 
                                :searchable="true" 
                                :reduce="doclogCategories => doclogCategories.recordid"
                                v-model="record.doclogcategoryid"
                            >
                            <span slot="no-options">Category not found</span>
                            </v-select>
                        </div>

                        <div class="col-md-6">

                            <label>Sub Category</label>
                            <pop-over content="
                                <h4>Sub Category</h4>
                                <p>Specify the Sub Category the item belongs to.
                                <p>Note: This is an optional field</p>"
                            />
                            <v-select
                                :options="doclogSubCategories" 
                                label="description"
                                :clearable="true" 
                                :searchable="true" 
                                :reduce="doclogSubCategories => doclogSubCategories.recordid"
                                v-model="record.doclogsubcategoryid"
                            >
                            <span slot="no-options">Sub Category not found</span>
                            </v-select>
                        </div>

                    </div>

                    <div class="form-group row">
                        <radio-buttons 
                        popOver="<h4>Linked To</h4>
                            <p>Documents are automatically added to the Document Log when you <em>assemble a document</em> for a Matter or Party, 
                            but you can also add other items (such as images, audio and video) and manually link them to a Matter or Party.</p>"
                        :popOverContainer="'#' + id"
                        _style="flex: 1;padding-right: 5px;padding-left: 15px;" 
                        :record="record" 
                        column="parenttype" 
                        :buttons="[
                            {value:'Matter', text: 'Matter', title: 'The Correspondence is linked to a specific Matter'},
                            {value:'Party', text: 'Party', title: 'The Correspondence is linked to a specific Party'},
                        ]" 
                        name="parentType" 
                        label="Linked To" 
                        @change="parentTypeChanged"
                        />


                        <select-matter
                            v-show="record.parenttype === 'Matter'"
                            _style="flex: 3;padding-right: 15px;padding-left: 5px;" 
                            :id="id + '-select-matter'"
                            title="The Matter this Item is linked to"
                            :ref="_uid + '-doclog-form-select-matter'" 
                            :form-ref="_uid + '-doclog-form-select-matter'"
                        />

                        <select-party
                            v-show="record.parenttype === 'Party'"
                            _style="flex: 3;padding-right: 15px;padding-left: 5px;" 
                            :id="id + '-select-party'"
                            title="The Party this Item is linked to"
                            :ref="_uid + '-doclog-select-party'" 
                            :form-ref="_uid + '-doclog-select-party'"
                        />

                    </div>

                    <div class="form-group row">
                        <radio-buttons 
                            :popOver="`<h4>Direction</h4>
                            <p><strong>Outgoing:</strong> This item was generated internally.</p>
                            <p><strong>Incoming:</strong> This item was sent to us by a third party.</p>
                            <p><strong>Not Applicable:</strong> The direction is not applicable or irrelevant for this item.</p>`"
                            _class="col-md-12" 
                            :record="record" 
                            column="direction" 
                            :buttons="[
                                {value:'1', text: 'Outgoing'},
                                {value:'2', text: 'Incoming'},
                                {value:'0', text: 'Not Applicable'},
                            ]" 
                            name="direction" 
                            label="Direction" 
                        />
                    </div>

                    <div v-show="editing && record.savedname && !record.url && !isMessage()" class="form-group row">

                        <text-input  
                            _class="col-md-12"
                            popOver="<h4>Saved As</h4><p>The path and file name of the saved file.</p>"
                            :readOnly="true" 
                            v-model="record.savedname"
                            label="Saved As"
                        />

                    </div>

                    <div v-show="editing && record.url" class="form-group row">
                        <text-input 
                            _class="col-md-12" 
                            popOver="<h4>Cloud Url</h4><p>The url of the file saved in the Cloud.</p>"
                            :readOnly="true" 
                            v-model="record.url" 
                            label="Cloud Url" 
                            :inputGroupButtonFlag="true"
                            :inputGroupButtonCallback="viewItem"
                            :inputGroupButtonTitle="'View Item'"
                            :inputGroupButtonIcon="'fa-external-link'"
                        />
                        <a id="doclog-form-view-item" v-if="editing && record.url" :href="record.url" target="_blank" class="d-none"/>
                    </div>

                </div>  

                <div v-if="activeTab === 'Document'" class="form-tab-content" style="height:100%">

                    <div v-if="isMessage()">

                        <div v-if="record.type === 'email'">
                            <div class="form-group row">
                                <text-input class="col-md-6" :readOnly="true" v-model="record.emailfrom" label="From"/>
                                <text-input class="col-md-6" :readOnly="true" v-model="record.emailrecipients" label="To"/>
                            </div>

                            <div v-if="record.emailcc" class="form-group row">
                                <text-input class="col-md-12" :readOnly="true" v-model="record.emailcc" label="CC"/>
                            </div>

                            <div class="form-group row">
                                <text-input class="col-md-12" :readOnly="true" v-model="record.description" label="Subject"/>
                            </div>

                            <div class="form-group row">
                                <text-area 
                                    _class="col-md-12"
                                    rows="6" 
                                    cols="50" 
                                    v-model="record.emailbody" 
                                    name="emailbody" 
                                    label="Message"
                                />
                            </div>

                        </div>

                        <div v-if="record.type === 'sms'">
                            <div class="form-group row">
                                <text-input class="col-md-6" :readOnly="true" v-model="record.emailfrom" label="From"/>
                            </div>

                            <div class="form-group row">
                                <text-input class="col-md-12" :readOnly="true" v-model="record.emailfolder" label="Details"/>
                            </div>

                            <div class="form-group row">
                                <text-area 
                                    _class="col-md-12"
                                    rows="6" 
                                    cols="50" 
                                    v-model="record.emailbody" 
                                    name="emailbody" 
                                    label="Message"
                                />
                            </div>

                        </div>

                    </div>

                    <div v-else>

                        <div v-if="record.url" style="height:100%">

                            <div v-if="record.type === 'document' || record.type === 'xml'" style="height:100%">

                                <iframe :id="_uid + '-document-iframe'" 
                                    :name="_uid + '-document-iframe'" 
                                    width='100%' 
                                    height='100%' 
                                    frameborder='0'
                                />

                            </div>

                            <img v-else-if="record.type === 'image'" 
                                :id="_uid + '-image'" 
                                class="img-fluid border" 
                                alt="Image"
                            >

                            <Media
                                v-else-if="record.type === 'audio'"
                                :id="_uid + '-audio'"
                                kind="audio"
                                :src="[]"
                                ref="audio-player"
                                :controls="true"
                            />

                            <Media
                                v-else-if="record.type === 'video'"
                                :id="_uid + '-video'"
                                kind="video"
                                :src="[]"
                                ref="video-player"
                                :style="{width: '100%'}"
                                :controls="true"
                            />

                        </div>

                        <div v-else style="min-height:50vh" class="row">

                            <div v-if="record.url" class="col-md-12">
                                <div class="centercenter">
                                    <div style="text-align: center">
                                        <a :href="record.url" target="_blank">
                                            <h3 class="text-success">Click here to view this Document</h3>
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <div v-else class="col-md-12">
                                <div class="centercenter">
                                    <div style="text-align: center">
                                        <h4 class="text-danger">This document has not been uploaded to the Cloud.</h4>
                                        <button class="btn btn-primary form-button mt-3" type="button" @click="uploadToTheCloud">
                                            <span title="Upload this Item to the Cloud"><i class="fa fa-cloud-upload fa-lg mr-2"></i>Upload</span>
                                        </button>
                                        <div class="mt-2">Click here to upload it to the Cloud</div>

                                    </div>
                                </div>
                            </div>

                        </div>

                    </div>


                </div>

            </div>

            <div class="modal-footer justify-content-between">
                <div>

                    <upload-button 
                        v-show="!record.url && !isMessage() && activeTab === 'General'" 
                        :id="id" 
                        buttonText="Upload File"
                        title="Upload a document, image, audio file or any type of file"
                        ref="upload-button"
                    />

                    <button v-show="editing" class="btn btn-primary form-button mr-3" type="button" @click="deleteClicked">
                        <span title="Delete this Item"><i class="fa fa-trash fa-lg mr-2"></i>Delete</span>
                    </button>

                </div>
                <div>

                    <button v-if="!isMessage()" class="btn btn-yellow form-button mr-3" @click="okClicked(false)" type="button" title="Save the Item and continue editing"><i class="fa fa-check-square fa-lg mr-2"></i>Save</button>

                    <button v-if="!isMessage()" class="btn btn-success form-button mr-3" @click="okClicked(true)" type="button" title="Save the Item and close the Window"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>

                    <button v-if="savedFlag || editing" class="btn btn-danger form-button" @click="closeForm" type="button" title="Close this screen"><i class="fa fa-times-circle fa-lg mr-2"></i>Close</button>

                    <button v-else class="btn btn-danger form-button" @click="closeForm" type="button" title="Exit without saving"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
                </div>
            </div>

        </div>
    </div>
</div>

</template>    

<script>

//https://vue-select.org/guide/positioning.html#popper-js-integration
import { createPopper } from '@popperjs/core';

import { mapGetters } from 'vuex';
import formTemplate from "@pages/form-template";
import modalTemplate from "@components/modals/modal-template";
import Media from '@dongido/vue-viaudio'

export default {

    mixins: [modalTemplate, formTemplate ],

    components: {
        SelectMatter: () => import("@pages/matters/SelectMatter"),
        SelectParty: () => import("@pages/parties/SelectParty"),
    },

    props: {
        resource: {type: String, default: 'DocLog' },
        secProc: {type: String, default: 'Document Log' },
    },

    computed: {
        ...mapGetters(['currentMatter','currentParty']),
    },    

    watch: {

        activeTab(newValue) {

            if ( newValue === "Document" ) {

                if (this.record.url) this.setSourceContainer();

            }
        },

    },

    data() {
        return {
            actionButtons: [],
            doclogCategories: root.doclogCategories,
            doclogSubCategories: root.doclogSubCategories,
            fileType: null,
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
                    pageName: "Document",
                    title: "Document",
                    iconClass: '',
                    visible: false,
                    active: false,
                },
            ],

        };
    },    

    methods: {

        editRecord(id) {

            this.setGeneralTab();

            this.clearSourceContainers();

            axios.post('/doclog/get',{recordid: id})

            .then(async response => {

                this.record = response.data.data[0];

                if ( !this.record.category ) this.record.doclogcategoryid = null;
                if ( !this.record.subcategory ) this.record.doclogsubcategoryid = null;

                this.selectMatter.matter = {
                    id: this.record.matterid,
                    fileref: htmlDecode(this.record.matterfileref),
                    description: htmlDecode(this.record.matterdescription),
                };

                this.selectParty.partyName = this.record.partyname;

                await this.getFileType().then( ( fileTypeResponse ) => {

                    this.record.type = fileTypeResponse.type;
                    this.record.mimeType = fileTypeResponse.mimetype;

                    if ( this.record.type == 'unknown' ) {
                        this.hideDocumentTab();
                    } else {
                        this.unHideDocumentTab();
                    }

                    this.initFormData();

                }).catch( (error) => {

                    showError('Error',error)
                });

            });

        },

        initNewRecord() {

            this.setGeneralTab();

            this.hideDocumentTab();

            this.setGeneralTab();

            this.clearSourceContainers();

            let defaultCategory = root.doclogCategories.filter(category => category.description == 'Document')[0];

            this.record = {
                employeeid: root.loggedInEmployeeId,
                parenttype: 'Matter',
                type: 'document',
                direction: '1',
                doclogcategoryid: defaultCategory ? defaultCategory.recordid : 1,
                doclogsubcategoryid: null,
                emailflag: '0',
                matterid: this.currentMatter.recordid || null,
                partyid: null, 
                description: null,
                date: null,
                time: null,
                datetime: moment().format(root.control.dateformat + ' HH:mm:ss'),
            };

            this.selectMatter.matter = this.currentMatter.fileref ? 
            {
                recordid: this.currentMatter.recordid,
                fileref: htmlDecode(this.currentMatter.fileref),
                description: htmlDecode(this.currentMatter.description),
            } : {
                recordid: null,
                fileref: '',
                description: '',
            };

            this.selectParty.partyName =  this.currentParty.code ? this.currentParty.code + ' - ' + this.currentParty.name : null;

            this.initFormData();

            setTimeout(() => $('#' + this.id + ' input[name="description"]').focus() );

        },

        initFormData() {

            this.selectMatter.callingComponent = this;
            this.selectParty.callingComponent = this;

            this.setActionButtons();

            this.setDocumentTabTitle();

            this.displayForm();

        },

        isMessage() {
            return this.record?.emailflag == '1' || this.record?.emailflag == '2' ? true : false;
        },

        isEmail() {
            return this.record?.emailflag == '1' ? true : false;
        },

        isSms() {
            return this.record?.emailflag == '2' ? true : false;
        },

        setActionButtons() {

            let buttons = [
                {text: 'Change', title: 'Upload a new file and replace the existing one', callback: 'replaceFile', class: 'btn-secondary', icon:'fa-refresh'},
            ]

            if (this.record.url) {
                buttons.unshift({text: 'Email', title: 'Email', callback: 'emailDocument', class: 'btn-danger', icon:'fa-envelope'});
                buttons.unshift({text: 'Download', title: 'Download the file', callback: 'downloadFile', class: 'btn-primary', icon:'fa-download'});

            }
            if (this.record.type === 'document' || this.record.type === 'image') {
                buttons.unshift({text: 'Print', title: 'Print', callback: 'printDocument', class: 'btn-success', icon:'fa-print'});
            }

            this.actionButtons = buttons;

        },

        getFileType() {

            return new Promise((resolve, reject) => {

                if (this.record.emailflag == '1') {

                    resolve({type:'email', mimetype: ''});

                } else if (this.record.emailflag == '2') {

                    resolve({type:'sms', mimetype: ''});

                } else if (this.record.url || this.record.savedname) {

                    axios.post('/utils/getFileType',{filename: this.record.url || this.record.savedname })
        
                    .then(response => {

                        if (response.data.errors) {

                            reject(response.data.errors);

                        } else {

                            resolve(response.data.data);
                        }

                    });

                } else {

                    resolve({type:'unknown', mimetype: ''});

                }

            });

        },

        viewItem() {
            $('#doclog-form-view-item').get(0).click();
        },

        uploadToTheCloud() {

            root.$snotify.simple(this.record.description, 'Uploading', { timeout: 0, icon: 'img/cogs.gif' });

            axios.post('/doclog/upload/' + this.record.recordid)

            .then(response => {

                if (response.data.errors) {

                    showError('Error',response.data.errors);

                } else {

                    axios.post('/file/checkIfRemoteFileExists',{ url: response.data.data.url })

                    .then(fileCheckResponse => {

                        if (fileCheckResponse.data.result === true) {

                            root.$snotify.clear();

                            this.record.url = response.data.data.url;

                            this.setSourceContainer();

                        } else {

                            this.record.url = null;

                            showError('File Not Found','<p><em>' + this.record.savedname + '</em> was not found.</p><p>It may be inaccessible or has been moved or deleted.</p>');

                        }

                    }).catch(error => { 

                        showError('Error',error);

                    });

                }

            });

        },

        async uploadFile(file) {

            // Test different file type from here: https://file-examples.com/

            //console.log('file.type',file.type );

            let mimeType = root.mimeTypeHelper(file.type);

            this.fileType = mimeType.type;
            this.record.type = mimeType.description;

            this.record.mimeType = file.type;
            this.record.description = this.record.description || file.name;
            

            let folder = this.getFolder();

            this.setDocumentTabTitle();

            root.$snotify.simple(file.name, 'Uploading', { timeout: 0, icon: 'img/cogs.gif' });

            var formData = new FormData();

            formData.append("file", file);
            formData.append("fileName", file.name);
            formData.append("folder", folder);

            let response = await axios.post('/file/upload', formData, {
                headers: {'Content-Type': 'multipart/form-data'}
            });

            if (response.data.error) {

                root.$snotify.clear();

                showError('Error uploading document',response.data.error);

            } else {


                root.$snotify.clear();

                this.record.url = response.data.url;

                this.setActionButtons();

                this.unHideDocumentTab();

                this.setDocumentTab();

                this.errors = {};

            }

        },

        getFolder() {

            if ( this.record.parenttype === 'Matter' ) {
                return 'matters/' + this.record.matterid + '/doclog';
            } else if ( this.record.parenttype === 'Party' ) {
                return 'parties/' + this.record.partyid + '/doclog';
            } else {
                showError('System Error', 'Unable to determine the correct folder to save the file. Saving it in the General folder.');
                return 'general/doclog';
            }

        },

        setSourceContainer() {

            setTimeout(() => {

                if ( this.record.type === 'audio' || this.record.type === 'video') {

                    if ( isEncoded(this.record.url) ) {
                        this.$refs[this.record.type.toLowerCase() + '-player'].src = [this.record.url];
                    } else {
                        this.$refs[this.record.type.toLowerCase() + '-player'].src = [encodeURI(this.record.url)];
                    }

                } else if ( this.record.type === 'image') {
                    

                    if ( isEncoded(this.record.url) ) {
                        $('#' + this._uid + '-image').attr('src',this.record.url);
                    } else {
                        $('#' + this._uid + '-image').attr('src',encodeURI(this.record.url));
                    }

                } else { 
                    
                    $('#' + this._uid + '-document-iframe')[0].src = "https://docs.google.com/gview?url=" + encodeURIComponent(this.record.url) + "&embedded=true";

                }

            });

        },

        clearSourceContainers() {

            if ( $('#' + this._uid + '-document-iframe').length) $('#' + this._uid + '-document-iframe')[0].src = '';
            if ( this.$refs['audio-player'] ) this.$refs['audio-player'].src = [];
            if ( this.$refs['video-player'] ) this.$refs['video-player'].src = [];

        },

        setDocumentTab() {

            if ( this.activeTab === 'Document' ) {

                this.setSourceContainer();

            } else {

                this.activeTab = 'Document';
                this.tabs[0].active = false;
                this.tabs[1].active = true;

            }
        },

        setDocumentTabTitle() {

            if ( this.record.type === 'other' ) {

                this.tabs[1].title = this.userFriendlyFileType(this.record.mimeType);

            } else {

                this.tabs[1].title = this.record.type.capitalize();

            }

        },

        userFriendlyFileType( type) {

            let returnData = type;

            if ( type.indexOf('application/vnd.') === 0 ) {

                returnData = type.substring(16).capitalize();

            } else if ( type.indexOf('application/') === 0 ) {

                returnData = type.substring(12).capitalize();

            } else if ( type.indexOf('image/') === 0 ) {

                returnData = type.substring(6).capitalize() + ' Image';

            }

            return returnData;

        },

        hideDocumentTab() {
            this.tabs[1].visible = false;
        },

        unHideDocumentTab() {
            this.tabs[1].visible = true;
        },

        // hideAttachmentsTab() {
            
        //     if ( this.tabs[2].visible ) {
        //         this.setGeneralTab();
        //         this.tabs[2].visible = false;
        //     }
        // },

        // unHideAttachmentsTab() {
        //     this.tabs[2].visible = true;
        // },

        replaceFile() {
            this.$refs['upload-button'].selectFile();
        },

        downloadFile() {
            root.downloadObject(this.record.url, this.record.mimeType);
        },

        parentTypeChanged(newValue) {

            this.record.parenttype = newValue;

            this.selectMatter.matter = { id:null, fileref:'', description:''};
            this.record.matterid = 0;

            this.selectParty.partyName = null;
            this.record.partyid = 0;

            // if ( newValue === 'Matter' ) {
            //     this.record.partyid = 0;
            // } else if ( newValue === 'Party' ) {
            //     this.record.matterid = 0;
            // }

        },

        matterSelected(selectedRecord) {
            this.record.matterid = selectedRecord.recordid;
            this.record.partyid = 0;
            this.record.parenttype = 'Matter';
        },

        partySelected(selectedRecord) {
            this.record.partyid = selectedRecord.recordid;
            this.record.matterid = 0;
            this.record.parenttype = 'Party';
        },

        okClicked( closeFlag = true ) {

            let dateStringLength = this.record?.datetime?.length;

            if (!dateStringLength) {
                showError('Error','Please enter a date');
                return;
            }

            this.record.date = this.record.datetime.slice(0, dateStringLength-9);
            this.record.time = this.record.datetime.slice(-8);

            root.$snotify.simple('Please wait...', 'Saving Item', { timeout: 10000, icon: 'img/cogs.gif' });

            axios.post('/doclog/' + (this.savedFlag ? 'update' : 'store'), this.record)
            
            .then(response => {

                if (response.data.errors) {

                    this.setGeneralTab();

                    showError( 'Error', response.data.errors );

                } else {

                    this.record.recordid = response.data.data[0].recordid;

                    root.$snotify.clear();

                    this.errors = {};

                    if (!this.editing && !this.savedFlag) {

                        if (this.table.initialOrder[0][1] == 'asc') {

                            this.highlightRow(response.data.data[0].recordid, {
                                where: ["date,>,0","date,<," + response.data.data[0].date,"time,<," + response.data.data[0].time],
                                orderBy: ['date,asc', 'time,asc'],
                            });

                        } else {

                            this.highlightRow(response.data.data[0].recordid, {
                                where: ["date,>,0","date,>," + response.data.data[0].date,"time,>," + response.data.data[0].time],
                                orderBy: ['date,desc', 'time,desc'],
                            });

                        }

                    } else {

                        this.table.refreshRow(response.data.data[0].recordid);

                    }

                    if (closeFlag) {

                        this.closeForm();

                    } else {

                        this.savedFlag = true;
                    }

                }

            }).catch(error => { showError('Error saving ' + this.table.singular, error); });

        },

        printDocument() {

            this.$root.previewPdf.document = this.record;

            this.$root.previewPdf.printDocument();

        },

        emailDocument() {
            this.$root.previewPdf.document = this.record;
            this.$root.previewPdf.emailDocument( this.record.description, this.record.description );
        },
    },

}

</script>
