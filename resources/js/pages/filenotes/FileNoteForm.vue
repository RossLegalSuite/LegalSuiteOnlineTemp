<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lg' : ''">

        <div :id="id + '-form-border'" :class="modal ? 'modal-content filenotes-border' : 'card h-100 border-0'">

            <div :id="id + '-form-header'" :class="modal ? 'filenotes-bg' : 'card-header'">

                <div :class="modal ? 'modal-header' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="!editing && !savedFlag">File Note will be Added</span>
                            <span v-else>File Note will be Changed</span>
                        </h3>
                        <i v-if="modal" :id="id + '-modal-close-button'" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="card-body form-tab-body overflow-auto">
                <form-tabs :tabs="tabs"/>

                <div v-show="activeTab === 'General'" class="form-tab-content">

                    <div class="form-group row">

                        <div class="col-md-4">
                            <label>Date/Time</label>
                            <date-picker ref="datePickerComponent" v-model="record.datetime" :config="$root.dateTimePickerOptions"/>
                        </div>


                        <div class="col-md-8">

                            <div class="pull-right">
                                <b-form-checkbox
                                    :id="id + '-internal-flag'"
                                    v-model="record.internalflag"
                                    name="internalFlag"
                                    value="1"
                                    unchecked-value="0"
                                    switch 
                                    size="lg"
                                    >
                                    <span>This is an internal (private) File Note</span>

                                    <pop-over content="
                                        <h4>Internal File Note</h4>
                                        <p>If a File Note contains sensitive information or personal comments, you can set it as <em>internal</em>.</p>
                                        <p>Internal File Notes will not be visible to remote users.</p>
                                        <p><strong>Note:</strong> You must filter them out of any reports that may be generated to ensure that these File Notes do not appear on reports that may be sent to outside parties.</p>
                                    "/>

                                </b-form-checkbox>
                            </div>

                        </div>

                    </div>

                    <div class="row">

                        <div class="col-md-6">

                            <div class="form-group row">

                                <select-matter
                                    popOver="<h4>Matter</h4><p>The Matter this File Note is linked to.</p>"
                                    :id="id + '-select-matter'"
                                    _class="col-md-12"
                                    :ref="_uid + '-filenote-form-select-matter'" 
                                    :form-ref="_uid + '-filenote-form-select-matter'"

                                />

                            </div>

                        </div>

                        <div class="col-md-6">

                            <select-employee
                                v-show="editing"
                                :id="id + '-select-employee'"
                                popOver="<h4>Employee</h4>
                                <p>The Employee this File Note is assigned to</p>"
                                label="Employee"
                                :ref="uniqueId + '-select-employee'" 
                                :formRef="uniqueId + '-select-employee'"
                            />

                        </div>

                    </div>

                    <div v-show="showStages()" class="form-group row">

                        <select-stage
                            :id="id + '-select-stage'"
                            _class="col-md-12"
                            popOver="<h4>Stage</h4>
                            <p>The Stage that has been reached on this Matter by creating this File Note.</p>"
                            title="The Stage that has been reached on this Matter"
                            :ref="_uid + '-select-stage'" 
                            :form-ref="_uid + '-select-stage'"
                        />

                    </div>

                    <div v-show="$root.control.filenotereminderflag == '1'" class="form-group row">

                        <select-reminder
                            :id="id + '-select-reminder'"
                            _class="col-md-6"
                            popOver="<h4>Reminder</h4>
                            <p>The Reminder that created this File Note.</p>"
                            title="The Reminder that created this File Note."
                            :ref="_uid + '-select-reminder'" 
                            :form-ref="_uid + '-select-reminder'"
                            :clearIcon="true"
                            clearIconCallback="clearReminder"
                        />

                    </div>

                    <div class="form-group row">

                        <text-area 
                            _class="col-md-12" 
                            popOver="<h4>Description</h4><p>A description of the File Note.</p>"
                            rows="4" 
                            cols="50" 
                            v-model="record.description" 
                            name="description" 
                            label="Description"
                            :lookupLibraryFlag="true"
                            lookupLibraryCategory="The text of the File Note"
                        />

                    </div>

                </div>  

                <div v-show="activeTab === 'Actions'" class="form-tab-content">


                    <fieldset><legend>Reminder</legend>

                        <div class="form-group row">

                            <div class="col-md-12">

                                <b-form-checkbox
                                    :id="id + '-create-reminder-flag'"
                                    v-model="createReminderFlag"
                                    name="createReminderFlag"
                                    value="1"
                                    unchecked-value="0"
                                    switch 
                                    size="lg"
                                    @change="createReminderFlagChanged"
                                    >
                                    <span>Create a Reminder</span>

                                    <pop-over content="
                                        <h4>Create Reminder</h4>
                                        <p>Create a Reminder for the selected Matter when the File Note is saved.</p>
                                    "/>

                                </b-form-checkbox>

                            </div>
                        </div>

                        <div v-show="createReminderFlag == '1'" class="form-group row">
                            <text-input 
                                _class="col-md-9" 
                                popOver="<h4>Description</h4><p>The wording of the Reminder to be created.</p>"
                                v-model="createReminderDescription" 
                                label="Description"
                            />

                            <text-input 
                                _class="col-md-3"
                                popOver="<h4>Days Time</h4><p>In how many days times must the Reminder be created.</p>"
                                input-class="form-input-number" 
                                v-model="createReminderDays" 
                                label="Days Time"
                            />


                        </div>

                    </fieldset>

                    <fieldset class="mt-3"><legend>Fee Note</legend>

                        <div class="form-group row">

                            <div class="col-md-12">

                                <b-form-checkbox
                                    :id="id + '-create-fee-note-flag'"
                                    v-model="createFeeNoteFlag"
                                    name="createFeeNoteFlag"
                                    value="1"
                                    unchecked-value="0"
                                    switch 
                                    size="lg"
                                    @change="createFeeNoteFlagChanged"
                                    >
                                    <span>Create a Fee Note</span>

                                    <pop-over content="
                                        <h4>Create Fee Note</h4>
                                        <p>Create a Fee Note for the selected Matter when the File Note is saved.</p>
                                    "/>

                                </b-form-checkbox>

                            </div>
                        </div>

                        <div v-show="createFeeNoteFlag == '1'" class="form-group row">
                            <text-input 
                                _class="col-md-9" 
                                popOver="<h4>Description</h4><p>The wording of the Fee Note to be created.</p>"
                                v-model="createFeeNoteDescription" 
                                label="Description"
                            />

                            <text-input 
                                _class="col-md-3"
                                popOver="<h4>Amount</h4><p>The amount of the Fee Note (excluding Vat).</p>"
                                input-class="form-input-number" 
                                name="createFeeNoteAmount" 
                                v-model="createFeeNoteAmount" 
                                label="Amount"
                            />


                        </div>

                    </fieldset>

                    <!-- <div v-show="editing && record.createdbyemployee && record.formattedcreateddatetime" class="row mt-3">
                        <div class="col-md-12">
                            <div class="alert alert-danger" v-html="getCreatedByDetails()"/>
                        </div>
                    </div> -->

                </div>  

            </div>

            <div class="modal-footer justify-content-between">
                <div>

                    <button v-show="editing" class="btn btn-primary form-button mr-3" type="button" @click="deleteClicked">
                        <span title="Delete this File Note"><i class="fa fa-trash fa-lg mr-2"></i>Delete</span>
                    </button>

                </div>
                <div>

                    <button class="btn btn-yellow form-button mr-3" @click="okClicked(false)" type="button" title="Save the Item and continue editing"><i class="fa fa-check-square fa-lg mr-2"></i>Save</button>

                    <button class="btn btn-success form-button mr-3" @click="okClicked(true)" type="button" title="Save the Item and close the Window"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>

                    <button v-if="savedFlag || editing" class="btn btn-danger form-button" @click="closeForm" type="button" title="Close this screen"><i class="fa fa-times-circle fa-lg mr-2"></i>Close</button>

                    <button v-else class="btn btn-danger form-button" @click="closeForm" type="button" title="Exit without saving"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>

                </div>
            </div>

        </div>

    </div>
    
</div>

</template>    

<script>

import { mapGetters } from 'vuex';
import formTemplate from "@pages/form-template";
import modalTemplate from "@components/modals/modal-template";

export default {

    mixins: [modalTemplate, formTemplate ],
    
    components: {
        SelectMatter: () => import("@pages/matters/SelectMatter"),
        SelectEmployee: () => import("@pages/employees/SelectEmployee"),
        SelectStage: () => import("./SelectStage"),
        SelectReminder: () => import("./SelectReminder"),
    },

    props: {
        resource: {type: String, default: 'File Notes' },
        secProc: {type: String, default: 'Matters - Desktop - File Notes' },
        uniqueId: String,
    },    

    data() {
        return {
            selectedMatter: {},
            activeTab: 'General',
            createReminderFlag: '0',
            createReminderDescription: '',
            createReminderDays: '7',
            createFeeNoteFlag: '0',
            createFeeNoteDescription: '',
            createFeeNoteAmount: '',
            docgenData: {},
            tabs: [
                {
                    pageName: "General",
                    title: "Details",
                    iconClass: '',
                    visible: true,
                    active: true,
                },
                {
                    pageName: "Actions",
                    title: "Actions",
                    iconClass: '',
                    visible: true,
                    active: false,
                },

            ],
        }
    },

    computed: {

        ...mapGetters(['currentMatter']),
    },

    methods: {

        editRecord(id) {

            this.setGeneralTab();

            axios.post('/filenote/get',{recordid: id})

            .then(response => {

                this.record = response.data.data[0];

                this.selectEmployee.record = {
                    recordid: this.record.employeeid,
                    name: htmlDecode(this.record.employeename),
                };

                this.selectMatter.matter = {
                    id: this.record.matterid,
                    fileref: htmlDecode(this.record.matterfileref),
                    description: htmlDecode(this.record.matterdescription),
                };

                this.selectStage.record = {
                    recordid: this.record.stageid,
                    description: this.record.stagecode + ' - ' + htmlDecode(this.record.stagedescription),
                };

                this.selectReminder.record = {
                    recordid: this.record.todonoteid,
                    description: this.record.todonotedescription ? (this.record.todonotedate + ' - ' + htmlDecode(this.record.todonotedescription) ) : '',
                };

                this.initFormData();

            }).catch( (error) => {
                showError('Error',error)
            });

        },

        initNewRecord() {

            this.setGeneralTab();

            this.record = {

                date: null,
                time: null,
                datetime: moment().format(root.control.dateformat + ' HH:mm:ss'),

                createdby: root.loggedInEmployeeId,
                createddate: moment().format(root.control.dateformat),
                createdtime: moment().format('HH:mm:ss'),

                employeeid: root.loggedInEmployeeId,
                matterid: this.currentMatter.recordid || null,
                stageid: null,
                todonoteid: null,
                description: null,
                source: 'W',
                origin: 20,
                autonotifydate: 0,
                internalflag: root.currentEmployee.filenotesinternalflag,

            };

            this.selectMatter.matter = this.currentMatter.recordid ? 
            {
                recordid: this.currentMatter.recordid,
                fileref: htmlDecode(this.currentMatter.fileref),
                description: htmlDecode(this.currentMatter.description),
            } : {
                recordid: null,
                fileref: '',
                description: '',
            };

            this.selectEmployee.record = {
                recordid: root.loggedInEmployeeId,
                name: root.loggedInEmployeeName,
            };

            this.initFormData();

            setTimeout(() => $('#' + this.id + ' textarea[name="description"]').focus() );

        },

        initFormData() {

            this.createReminderFlag = '0';
            this.createReminderDescription = '';
            this.createReminderDays = '7';

            this.createFeeNoteFlag = '0';
            this.createFeeNoteDescription = '';
            this.createFeeNoteAmount = '';


            this.selectMatter.callingComponent = this;

            if ( this.record.matterid ) {

                // ******************************************************************
                // DO axios to get Matter and then call matterSelected() to set some defaults
                // ******************************************************************

                axios.post('/matter/get/' + this.record.matterid)

                .then(response => {

                    if ( response.data.errors ) {

                        showError('Error', response.data.errors);

                    } else {

                        this.matterSelected(response.data.data[0]);

                    }

                }).catch( (error) => {
                    showError('Error getting Matter', error); 
                });


            }


            this.displayForm();

        },

        matterSelected(selectedRecord) {

            this.selectedMatter = selectedRecord;

            this.selectStage.stageGroupId = selectedRecord?.stagegroupid;
            this.selectReminder.matterId = selectedRecord.recordid;

            this.record.matterid = selectedRecord.recordid;

            this.setDocgenData()

            .then( (docgenResponse) => {

                this.docgenData = docgenResponse;

            }).catch( (error) => {
                showError('Error',error)
            });

        },        

        setDocgenData() {

            return new Promise((resolve, reject) => {

                this.docgenData = {};

                axios.post("/docgen/get/" + this.selectedMatter.docgenid)
                
                .then(response => {

                    if (response.data.errors) {

                        reject(response.data.errors);

                    } else {

                        if ( !response.data.data.length ) {

                            reject('Error getting Docgen data - No Docgen data returned');

                        } else {

                            resolve( response.data.data[0]);

                        }

                    }

                }).catch( (error) => {
                    reject('Error getting Docgen data: ' +error ); 
                });

            });

        },

        showStages() {

            if ( typeof this.record.stageid !== 'undefined' && parseInt(this.record.stageid) > 0 ) {
                return true;
            } else {
                if ( typeof this.docgenData.hidestagesflag == 'undefined' || this.docgenData?.hidestagesflag == "1" ) {
                    return false;
                } else {
                    return true;
                }
            }

        },

        stageSelected(selectedRecord) {
            this.record.stageid = selectedRecord.recordid;
        },

        reminderSelected(selectedRecord) {
            this.record.todonoteid = selectedRecord.recordid;
        },

        clearReminder() {

            this.record.todonoteid = null;

            this.selectReminder.record = {
                recordid: null,
                description: null,
            };

        },


        createFeeNoteFlagChanged(newValue) {

            if (newValue == '1') {

                if ( !this.createFeeNoteDescription ) {
                    this.createFeeNoteDescription = this.record.description;
                }

                setTimeout(() => $('#' + this.id + ' input[name="createFeeNoteAmount"]').focus() );

            }

        },

        createReminderFlagChanged(newValue) {

            if (newValue == '1') {

                if ( !this.createReminderDescription ) {
                    this.createReminderDescription = this.record.description;
                }

            }

        },


        // getCreatedByDetails() {

        //     let returnData = '';

        //     if (this.record.createdbyemployee && this.record.formattedcreateddatetime) {

        //         returnData = 'Inserted by ' + this.record.createdbyemployee  + ' at ' + this.record.formattedcreateddatetime;

        //     }
        //     return returnData;

        // },


        okClicked( closeFlag = true ) {

            let dateStringLength = this.record?.datetime?.length;

            if (!dateStringLength) {
                showError('Error','Please enter a date');
                return;
            }

            this.record.date = this.record.datetime.slice(0, dateStringLength-9);
            this.record.time = this.record.datetime.slice(-8);

            root.$snotify.simple('Please wait...', 'Saving File Note', { timeout: 10000, icon: 'img/cogs.gif' });

            this.record.createreminderflag = this.createReminderFlag;
            this.record.createreminderdescription = this.createReminderDescription;
            this.record.createreminderdays = this.createReminderDays;

            this.record.createfeenoteflag = this.createFeeNoteFlag;
            this.record.createfeenotedescription = this.createFeeNoteDescription;
            this.record.createfeenoteamount = this.createFeeNoteAmount;

            axios.post('/filenote/' + (this.savedFlag ? 'update' : 'store'), this.record)
            
            .then(response => {

                if (response.data.errors) {

                    this.setGeneralTab();

                    showError( 'Error', response.data.errors );

                } else {

                    this.createReminderFlag = '0'; // So it doesn't repeatedly make Reminders when they press Save

                    this.record.recordid = response.data.data[0].recordid;

                    root.$snotify.clear();

                    this.errors = {};

                    if (!this.editing && !this.savedFlag) {

                        if (this.table.initialOrder[0][1] == 'asc') {

                            this.highlightRow(response.data.data[0].recordid, {
                                where: ["filenote.date,>,0","filenote.date,<," + response.data.data[0].date,"filenote.time,<," + response.data.data[0].time],
                                orderBy: ['filenote.date,asc'],
                            });

                        } else {
                            
                            this.highlightRow(response.data.data[0].recordid, {
                                where: ["filenote.date,>,0","filenote.date,>," + response.data.data[0].date,"filenote.time,>," + response.data.data[0].time],
                                orderBy: ['filenote.date,desc'],
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

    },

}

</script>
