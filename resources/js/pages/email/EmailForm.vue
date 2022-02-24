<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lg' : ''">

        <div :class="modal ? 'modal-content email-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header email-bg' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            {{record.subject}}
                        </h3>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <!-- Fill remaining vertical space with CSS using display:flex
            Note: See "<div style="flex: 1 1 auto;"> on the iframe row below
            https://stackoverflow.com/questions/25098042/fill-remaining-vertical-space-with-css-using-displayflex -->

            <div  class="card-body form-tab-body overflow-auto p-3">

                <form-tabs :tabs="tabs"/>

                <div v-show="activeTab === 'General'" 
                    :id="id + '-form-tab-content'" 
                    class="form-tab-content"
                    style="display: flex; align-items: stretch; flex-flow: column;"
                >

                    <div class="form-group row">
                        <text-input class="col-md-6" :readOnly="true" v-model="record.date" label="Date"/>
                    </div>

                    <div class="form-group row">
                        <text-input class="col-md-6" :readOnly="true" v-model="record.from" label="From"/>
                        <text-input class="col-md-6" :readOnly="true" v-model="record.to" label="To"/>
                    </div>

                    <div v-if="record.cc" class="form-group row">
                        <text-input class="col-md-12" :readOnly="true" v-model="record.cc" label="CC"/>
                    </div>


                    <div 
                    style="flex: 1 1 auto; background: white; margin-right: 0px; margin-left: 0px;"
                    class="row boxed"
                    >
                        <div style="padding-left: 0;padding-right: 0" class="col-md-12">
                            <iframe class="iframe-container" id="email-form-message-iframe"></iframe>
                        </div>
                    </div>

                </div>  

                <div v-show="activeTab === 'Attachments'" 
                    class="form-tab-content"
                    style="background: white;"
                >

                    <div class="d-flex">

                        <div 
                            v-bind:key="attachment.id" 
                            v-for="attachment in attachments"
                            class="program-icon"
                            @click="viewAttachment(attachment.fileName, attachment.id)"
                        >
                            <img :src="'/icons/file-types/' + attachment.imageFileName" :alt="attachment.imageFileName">
                            <div class="program-icon-text">{{attachment.fileName}}</div>
                        </div>

                    </div>

                    <div class="d-none">

                        <div 
                            v-bind:key="attachment.id" 
                            v-for="attachment in attachments"
                        >
                            <a :id="id + '-attachment-icon-' + attachment.id" href="" target="_blank" rel="noopener noreferrer"></a>
                        </div>

                    </div>

                </div>


            </div>

            <div class="modal-footer justify-content-between">
                <div>

                    <div v-show="emailLoaded" class="dropdown" title="Add this message to a Matter, Party or Employee's Correspondence">
                        <button class="btn btn-primary form-button dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown">
                            <i class="fa fa-plus-square fa-lg mr-2"></i>
                            Correspondence
                        </button>
                        <div class="dropdown-menu">
                            <div class="dropdown-item cp" @click="addToMatter"><i class="fa fa-briefcase fa-lg mr-2"></i>Add to a Matter</div>
                            <div class="dropdown-item cp" @click="addToParty"><i class="fa fa-user fa-lg mr-2"></i>Add to a Party</div>
                        </div>
                    </div>

                </div>

                <div>
                    <button class="btn btn-danger form-button" @click="closeForm" type="button" title="Close this screen"><i class="fa fa-times-circle fa-lg mr-2"></i>Close</button>
                </div>
            </div>

        </div>
    </div>

    <select-matter :formControls="false" :id="id + '-select-matter'" :ref="id + '-select-matter'" :formRef="id + '-select-matter'"/>
    <select-party :formControls="false" :id="id + '-select-party'" :ref="id + '-select-party'" :formRef="id + '-select-party'"/>

</div>

</template>    

<script>

import FormTemplate from "@pages/form-template";
import modalTemplate from "@components/modals/modal-template";

export default {
    
    mixins: [FormTemplate, modalTemplate],

    components: {
        SelectMatter: () => import("@pages/matters/SelectMatter"),
        SelectParty: () => import("@pages/parties/SelectParty"),
    },

    props: {
        resource: {type: String, default: 'Email' },
    },

    data() {
        return {
            record: {},
            attachments: [],
            emailLoaded: false,
            savedAttachments: false,
            savedAttachmentsUrl: '',
            iframeHeight: '',
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
                    pageName: "Attachments",
                    title: "Attachments",
                    iconClass: '',
                    visible: false,
                    active: false,
                },
            ],

        };
    },    

    watch: {

        activeTab(newValue) {

            if ( newValue === "Attachments" ) {

                // if (!this.gotContents) {

                //     this.gotContents = true;
                //     this.displayContents();
                // }

            }
        },

    },

    methods: {

        showEmailMessage( record, params ) {

            this.params = params;

            this.emailLoaded = false;

            $('#email-form-message-iframe')[0].srcdoc = `
                <html style="height: 100%;"><head></head><body style="height: 100%;">            
                <div style="margin: 0px;justify-content: center; align-items: center; display: flex; height: 100%;">
                    <div style="text-align: center">
                        <h3 style="color:forestgreen">Loading contents...Please wait</h3>
                    </div>
                </div>
                </body>
                </html>
            `;

            this.savedAttachments = false;
            this.savedAttachmentsUrl = '';

            this.attachments = [];

            this.record = record;

            this.displayContents();

            this.setGeneralTab();

            this.displayForm();

        },

        displayContents() {

            axios.post('/mail/getMessageBody', this.params)

            .then(response => {

                if (response.data.error) {

                    showError('Email Server Error',response.data.error);

                } else {

                    this.emailLoaded = true;

                    setTimeout(() => {
                        
                        $('#email-form-message-iframe')[0].srcdoc = response.data.body;
                        
                    });

                    this.attachments = response.data.attachments;

                    // this.attachments.forEach(attachment => {

                    //     let mimeType = this.$root.mimeTypeHelper(attachment.mimeType);
            
                    //     attachment.fileType = mimeType.type;
                    //     attachment.fileTypeDescription = mimeType.description;
                        
                    // });

                    if ( this.attachments.length ) {
                        this.setAttachmentsTab();
                    }

                }

            });

        },

        viewAttachment( fileName, id ) {

            let encodedFileName = encodeURI(fileName);

            if ( !this.savedAttachments ) {

                root.$snotify.simple('Fetching attachment', 'Please Wait..', { timeout: 0, icon: 'img/cogs.gif' });

                axios.post('/mail/saveAttachments',this.params)

                .then(response => {

                    root.$snotify.clear();

                    this.savedAttachments = true;
                    this.savedAttachmentsUrl = response.data.url;

                    $('#' + this.id + '-attachment-icon-' + id).attr('href',response.data.url + '/' + encodedFileName);

                    $('#' + this.id + '-attachment-icon-' + id)[0].click();


                }).catch(error => { root.$snotify.clear(); showError('Email Server Error', error); });    


            } else {

                $('#' + this.id + '-attachment-icon-' + id).attr('href',this.savedAttachmentsUrl + '/' + encodedFileName);

                $('#' + this.id + '-attachment-icon-' + id)[0].click();

            }

        },

        uploadAttachments() {

            let errorFlag = false;
            let timeStamp = new Date().getTime();

            root.$snotify.simple('Uploading attachments', 'Please Wait..', { timeout: 0, icon: 'img/cogs.gif' });

            return new Promise(async (resolve, reject) => {

                await root.asyncForEach(this.attachments, async (attachment) => {
            
                    if (!errorFlag) {

                        let response = await axios.post('/file/uploadFile', {
                            localFolder: 'temp',
                            remoteFolder: 'attachments/' + timeStamp,
                            fileName: attachment.fileName,
                        })
                        .catch(error => { 
                            errorFlag = true;
                            showError('Error Saving Attachments', error); 
                        });    

                        if (response.data.error) {
                            
                            errorFlag = true;
                            showError('Error Saving Attachments',response.data.error);

                        } else {

                            attachment.path = response.data.path;
                            attachment.url = response.data.url;
                            //console.log('Uploaded ' + attachment.fileName, attachment);
                        }

                    }

                });

                root.$snotify.clear();

                if ( errorFlag ) {
                    reject();
                } else {
                    resolve();
                }

            });

        },

        saveAttachments() {

            return new Promise( (resolve, reject) => {

                if ( this.attachments.length && !this.savedAttachments ) {

                    root.$snotify.simple('Saving attachments', 'Please Wait..', { timeout: 0, icon: 'img/cogs.gif' });

                    axios.post('/mail/saveAttachments',this.params)

                    .then(response => {

                        this.savedAttachments = true;
                        this.savedAttachmentsUrl = response.data.url;

                        root.$snotify.clear();

                        resolve();

                    }).catch(error => { reject(); root.$snotify.clear(); showError('Email Server Error', error); });

                } else {
                    resolve();
                }

            });

        },

        uploadEmailFile() {

            return new Promise( (resolve, reject) => {

                root.$snotify.simple('Saving email message', 'Please Wait..', { timeout: 0, icon: 'img/cogs.gif' });

                let fileName = new Date().getTime() + '.eml';

                axios.post('/mail/uploadEmailMessage',{...this.params, fileName: fileName} )

                .then(response => {

                    root.$snotify.clear();

                    if (response.data.error) {

                        showError('Error Upoading Email',response.data.error);

                        reject();

                    } else {

                        resolve({
                            url: response.data.url,
                            path: response.data.path,
                            fileName: fileName,
                        });
                    }

                }).catch(error => { 

                    root.$snotify.clear(); 
                    showError('Error Upoading Email', error); 
                    reject(); 

                });


            });


        },

        addCorrespondence(parentType, id, savedEmail) {

            let correspondenceRecord = {};
            
            correspondenceRecord.dateTime = this.record.date;
            correspondenceRecord.matterId = parentType === 'Matter' ? id : null;
            correspondenceRecord.partyId = parentType === 'Party' ? id : null;

            correspondenceRecord.parentType = parentType;
            correspondenceRecord.type = 'Email';
            correspondenceRecord.description = this.record.subject;

            correspondenceRecord.path = savedEmail.path;
            correspondenceRecord.fileName = savedEmail.fileName;
            correspondenceRecord.url = savedEmail.url;
            correspondenceRecord.fileType = 'application/octet-stream';

            axios.post('/correspondence/store', {...correspondenceRecord, attachments: JSON.stringify(this.attachments)})
            
            .then(response => {

                if (response.data.errors) {

                    if (response.data.errors.general) { showError( 'Error saving Correspondence', response.data.errors.general[0]);} else { this.errors = response.data.errors; }

                } else {

                    console.log('Saved Correspondence',correspondenceRecord);

                }

            }).catch(error => { showError('Error saving Correspondence from Email', error); });



        },

        addToMatter() {
            this.selectMatter.selectMatter(this);
        },

        addToParty() {
            this.selectParty.selectParty(this);
        },

        customMatterSelected( selectedRecord ) {

            this.uploadEmailFile()

            .then( ( savedEmail ) => {

                if ( this.attachments.length) {

                    this.saveAttachments()
                    .then( () => {

                        this.uploadAttachments()
                        .then( () => {
                            this.addCorrespondence('Matter', selectedRecord.recordid, savedEmail);
                        }).catch( () => {
                            console.log('Error Uploading Attachments');
                        });

                    }).catch( () => {
                        console.log('Error Saving Attachments');
                    });

                } else {
                    this.addCorrespondence('Matter', selectedRecord.recordid, savedEmail);
                }

            }).catch( () => {
                console.log('Error Saving Email File');
            });

        },

        setAttachmentsTab() {
            this.tabs[1].visible = true;
        },

    },
}

</script>
