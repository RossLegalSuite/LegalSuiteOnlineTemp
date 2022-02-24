<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lg' : ''">

        <div :id="id + '-form-border'" :class="modal ? 'modal-content todonotes-border' : 'card h-100 border-0'">

            <div :id="id + '-form-header'" :class="modal ? 'todonotes-bg' : 'card-header'">

                <div :class="modal ? 'modal-header' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="!editing && !savedFlag">Reminder will be Added</span>
                            <span v-else>Reminder will be Changed</span>
                        </h3>
                        <i v-if="modal" :id="id + '-modal-close-button'" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="card-body form-tab-body overflow-auto">
                <form-tabs :tabs="tabs"/>

                <div v-show="activeTab === 'General'" class="form-tab-content">


                    <fieldset><legend>Created By</legend>

                        <div class="form-group row">

                            <text-input _class="col-md-4" :readOnly="true" v-model="record.employeename" label="Employee"/>
                            <text-input _class="col-md-4" :readOnly="true" v-model="record.formattedcreateddate" label="Date"/>
                            <text-input _class="col-md-4" :readOnly="true" v-model="record.formattedcreatedtime" label="Time"/>

                        </div>


                    </fieldset>

                    <fieldset class="mt-3"><legend>For Action</legend>

                        <div class="row">

                            <div class="col-md-5">

                                <div class="form-group row">

                                    <div class="col-md-12">
                                        <label>Target Date</label>

                                        <pop-over content="
                                            <h4>Target Date</h4>
                                            <p>The date this Reminder should be completed on.</p>
                                        "/>

                                        <date-picker ref="datePickerComponent" v-model="record.formatteddate" :config="$root.datePickerOptions"/>
                                    </div>

                                </div>

                            </div>

                            <div class="col-md-7">

                                <div class="form-group row">

                                    <select-employee
                                        :id="id + '-select-employee'"
                                        popOver="<h4>Employee</h4>
                                        <p>The Employee this Reminder is assigned to</p>"
                                        label="Assigned To"
                                        :ref="uniqueId + '-select-employee'" 
                                        :formRef="uniqueId + '-select-employee'"
                                    />

                                </div>

                            </div>

                        </div>

                        <div class="form-group row">

                            <select-matter
                                popOver="<h4>Matter</h4><p>The Matter this Reminder is linked to.</p>"
                                :id="id + '-select-matter'"
                                _class="col-md-8"
                                :ref="_uid + '-todonote-form-select-matter'" 
                                :form-ref="_uid + '-todonote-form-select-matter'"

                            />

                        </div>

                        <div class="form-group row">

                            <text-area 
                                _class="col-md-12" 
                                popOver="<h4>Description</h4><p>A description of the Reminder, i.e. what action should be taken.</p>"
                                rows="4" 
                                cols="50" 
                                v-model="record.description" 
                                name="description" 
                                label="Description"
                                :lookupLibraryFlag="true"
                                lookupLibraryCategory="What must be done"
                            />

                        </div>

                        <div class="form-group row">

                            <div class="col-md-12">

                                <b-form-checkbox
                                    :id="id + '-completed-flag'"
                                    v-model="record.completedflag"
                                    name="completedFlag"
                                    value="1"
                                    unchecked-value="0"
                                    switch 
                                    size="lg"
                                    @change="completedFlagChanged"
                                    >
                                    <span>Completed</span>

                                    <pop-over content="
                                        <h4>Completed</h4>
                                        <p>Indicates whether the Reminder has been completed or not.</p>
                                    "/>

                                </b-form-checkbox>

                            </div>
                        </div>


                    </fieldset>

                    <fieldset v-show="record.completedflag && record.completedflag == '1'" class="mt-3"><legend>Completed</legend>

                        <div class="form-group row">

                            <div class="col-md-4">
                                <label>Date/Time</label>
                                <date-picker 
                                    ref="completedDatePickerComponent" 
                                    v-model="record.formatteddatetimedone" 
                                    :config="$root.dateTimePickerOptions"
                                />
                            </div>

                        </div>

                        <div class="form-group row">

                            <select-employee
                                :id="id + '-select-completed-by-employee'"
                                popOver="<h4>Employee</h4>
                                <p>The Employee who completed this Reminder</p>"
                                _class="col-md-6"
                                label="Completed By"
                                :ref="uniqueId + '-select-completed-by-employee'" 
                                :formRef="uniqueId + '-select-completed-by-employee'"
                                callback="completedEmployeeSelected"
                                parentName="selectCompletedEmployee"
                            />

                        </div>

                        <div class="form-group row">

                            <text-input 
                                _class="col-md-12" 
                                popOver="<h4>Completion Notes</h4><p>Notes regarding the completion of this task (e.g. why it is late).</p>"
                                label="Notes"
                                v-model="record.completedbynotes" 
                                name="completedbynotes" 
                                :lookupLibraryFlag="true"
                                lookupLibraryCategory="Notes regarding the completion of this task (e.g."
                            />

                        </div>

                    </fieldset>

                </div>  

                <div v-show="activeTab === 'Advanced'" class="form-tab-content">

                    <fieldset class="mt-3"><legend>Recurring Reminder</legend>

                        <div class="form-group row">

                            <div class="col-md-12">

                                <b-form-checkbox
                                    :id="id + '-recurring-flag'"
                                    v-model="record.recurringflag"
                                    value="1"
                                    unchecked-value="0"
                                    switch 
                                    size="lg"
                                    @change="recurringFlagChanged"
                                    >
                                    <span>Repeat This Reminder</span>

                                    <pop-over content="
                                        <h4>Recurring Reminder</h4>
                                        <p>Indicates whether the Reminder must be created again once it has been completed.</p>
                                    "/>

                                </b-form-checkbox>

                            </div>
                        </div>

                        <div v-show="record.recurringflag && record.recurringflag == '1'" class="form-group row">

                            <div class="col-md-4">

                                <label>Period</label>
                                <pop-over 
                                    :container="'#' + id" 
                                    content="<h4>Period</h4>
                                    <p>The frequency or period the Reminder must be repeated.</p>"
                                />
                                <v-select 
                                    :options="periods" 
                                    :clearable="false"
                                    :searchable="false"
                                    v-model="record.recurringperiod"
                                    :reduce="periods => periods.value"
                                />

                            </div>

                        </div>


                    </fieldset>

                </div>  

            </div>

            <div class="modal-footer justify-content-between">
                <div>

                    <button v-show="editing" class="btn btn-primary form-button mr-3" type="button" @click="deleteClicked">
                        <span title="Delete this Reminder"><i class="fa fa-trash fa-lg mr-2"></i>Delete</span>
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
    },

    props: {
        resource: {type: String, default: 'Reminders' },
        secProc: {type: String, default: 'Matters - Desktop - Reminders' },
        uniqueId: String,
    },    

    data() {
        return {
            activeTab: 'General',
            periods: [
                { value: 'Daily', label: 'Daily'},
                { value: 'Weekly', label: 'Weekly'},
                { value: 'Fortnightly', label: 'Fortnightly'},
                { value: 'Monthly', label: 'Monthly'},
                { value: 'Bi-Monthly', label: 'BiMonthly'},
                { value: '6-Months', label: 'Every 6 Months'},
                { value: 'Yearly', label: 'Yearly'},
                { value: 'Custom', label: 'Custom'},
            ],

            tabs: [
                {
                    pageName: "General",
                    title: "Details",
                    iconClass: '',
                    visible: true,
                    active: true,
                },
                {
                    pageName: "Advanced",
                    title: "Advanced",
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

            axios.post('/todonote/get',{recordid: id})

            .then(response => {

                this.record = response.data.data[0];

                this.selectEmployee.record = {
                    recordid: this.record.employeeid,
                    name: htmlDecode(this.record.employeename),
                };

                this.selectCompletedEmployee.record = {
                    recordid: this.record.completedbyid,
                    name: htmlDecode(this.record.completedbyemployee),
                };

                this.selectMatter.matter = {
                    id: this.record.matterid,
                    fileref: htmlDecode(this.record.matterfileref),
                    description: htmlDecode(this.record.matterdescription),
                };

                this.initFormData();

            }).catch( (error) => {
                showError('Error',error)
            });

        },

        initNewRecord() {

            this.setGeneralTab();

            this.record = {

                createdbyid: root.loggedInEmployeeId,
                formattedcreateddate: moment().format(root.control.dateformat),
                formattedcreatedtime: moment().format('HH:mm:ss'),

                formatteddate: moment().add(1, 'week').format(root.control.dateformat),
                formatteddatetimedone: null,

                employeename: root.loggedInEmployeeName,
                employeeid: root.loggedInEmployeeId,

                matterid: this.currentMatter.recordid || null,
                description: null,
                partyid: null,

                completedbyid: null,
                completedflag: null,
                completedbynotes: null,
                completedtime: null,
                datedone: null,
                dateadjustment: null,

                source: 'W',
                nextdocumentid: null,
                todoitemid: null,
                autonotifydate: null,

                recurringflag: '0',
                recurringperiod: null,
                recurringcustomtype: null,

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

            this.selectCompletedEmployee.record = {};


            this.initFormData();

            setTimeout(() => $('#' + this.id + ' textarea[name="description"]').focus() );

        },

        initFormData() {

            this.selectMatter.callingComponent = this;

            this.displayForm();

        },

        recurringFlagChanged(newValue) {

            if (newValue == '1') {
                if (!this.record.recurringperiod) this.record.recurringperiod = 'Monthly';
            }

        },

        completedFlagChanged(newValue) {

            if (newValue == '1') {

                this.record.formatteddatetimedone = moment().format(root.control.dateformat + ' HH:mm:ss');

                this.record.completedbyid = root.loggedInEmployeeId;

                this.selectCompletedEmployee.record = {
                    recordid: root.loggedInEmployeeId,
                    name: root.loggedInEmployeeName,
                };


                setTimeout(() => $('#' + this.id + ' input[name="completedbynotes"]').focus() );

            }

        },

        completedEmployeeSelected(selectedRecord) {

            this.record.completedbyid = selectedRecord.recordid;

        },

        okClicked( closeFlag = true ) {

            this.record.createddate = this.record.formattedcreateddate;
            this.record.createdtime = this.record.formattedcreatedtime;

            this.record.date = this.record.formatteddate;

            let dateStringLength = this.record?.formatteddatetimedone?.length;

            if (dateStringLength && this.record.completedflag == '1') {
                this.record.datedone = this.record.formatteddatetimedone.slice(0, dateStringLength-9);
                this.record.completedtime = this.record.formatteddatetimedone.slice(-8);
            } else {
                this.record.datedone = null;
                this.record.completedtime = null;
            }



            root.$snotify.simple('Please wait...', 'Saving Reminder', { timeout: 10000, icon: 'img/cogs.gif' });

            axios.post('/todonote/' + (this.savedFlag ? 'update' : 'store'), {...this.record, loggedinemployeeid: root.loggedInEmployeeId})
            
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
                                where: ["todonote.date,>,0","todonote.date,<," + response.data.data[0].date],
                                orderBy: ['todonote.date,asc'],
                            });

                        } else {
                            
                            this.highlightRow(response.data.data[0].recordid, {
                                where: ["todonote.date,>,0","todonote.date,>," + response.data.data[0].date],
                                orderBy: ['todonote.date,desc'],
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
