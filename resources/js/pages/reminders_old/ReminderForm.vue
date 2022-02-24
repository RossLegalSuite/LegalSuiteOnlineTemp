<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lg' : ''">

        <div :id="id + '-form-border'" :class="modal ? 'modal-content reminders-border':'card h-100 border-0'">

            <div :id="id + '-form-header'" :class="modal ? 'reminders-bg':'card-header'">

                <div :class="modal ? 'modal-header' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="!editing">Reminder will be Added</span>
                            <span v-else-if="viewing">Reminder</span>
                            <span v-else>Reminder will be Changed</span>
                        </h3>
                        <i v-if="modal" :id="id + '-modal-close-button'" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="card-body overflow-auto p-3">
                <div class="row">

                    <div class="col-md-8">

                        <div v-if="editing || errors.createdById || errors.dateTime" class="form-group row">

                            <text-input  _class="col-md-6" :readOnly="true" v-model="record.dateTime" name="dateTime" label="Created On" :error="errors.dateTime" />
                            <text-input  _class="col-md-4" :readOnly="true" v-model="record.createdEmployeeName" name="createdById" label="Created By" :error="errors.createdById" />

                        </div>

                        <div class="form-group row">

                            <div class="col-md-6">

                                <label>Target Date</label>

                                <pop-over content="<h4>Target Date</h4>
                                <p>The Target Date is the date by which the Reminder <em>should</em> be completed by.</p>
                                <p>By setting a Target Date, it not only diarises the Reminder for that date but also allows you to monitor which Matters are falling behind.</p>"
                                :container="'#' + id"/>

                                <div class="input-group">
                                    <date-picker @dp-change="hideTargetDatePicker" :readOnly="record.readOnly ? true: false" ref="targetDatePickerComponent" v-model="record.targetDate" :config="$root.datePickerOptions"/>
                                    <div class="input-group-append">
                                        <button
                                            tabindex="-1"
                                            type="button"
                                            title="Click here to select a date"
                                            v-on:click="toggleTargetDatePicker"
                                            class="btn btn-primary"
                                        ><i class="fa fa-calendar"></i>
                                        </button>
                                    </div>
                                </div>
                                <div v-if="errors.targetDate" v-html="errors.targetDate[0]" class="invalid-feedback"></div>

                            </div>


                            <div class="col-md-6">

                                <label>Assigned To</label>

                                <pop-over content="<h4>Assigned To</h4>
                                <p>The Employee who the task is assigned to and who it <em>should</em> be completed by.</p>
                                <p>Another Employee may complete the task, but this Employee is the person it is intended for and who will see it when they view their Reminders.</p>"
                                :container="'#' + this.id"/>


                                <employee-dropdown
                                    :id="id + '-assigned-employee-dropdown'"
                                    openDirection="below"
                                    placeholder=""
                                    :options="$root.employees" 
                                    v-model="targetEmployee"
                                    track-by="recordid"
                                    :tabindex="-1"
                                    label="name"
                                    :allow-empty="false"
                                    :show-labels="false"
                                >
                                <template slot="noResult">No Employees found</template>
                                <template slot="noOptions">No Employees found...</template>
                                <template slot="option" slot-scope="props"><div><span>{{ props.option.name }}</span></div></template>
                                </employee-dropdown>
                                <div v-if="errors.targetEmployeeId" v-html="errors.targetEmployeeId[0]" class="invalid-feedback"></div>

                            </div>

                        </div>

                        <div class="form-group row">
                            <radio-buttons 
                            _class="col-md-12" 
                            popOver="<h4>Reminder Type</h4>
                                <p>Reminders are typically linked to a <strong><em>Matter</em></strong> or a <strong><em>Party</em></strong> to remind you to take some action on a particular Matter or Party.</p>
                                <p>You can also create <strong><em>General</em></strong> Reminders which are not linked to a specific Matter or Party. These can be used to create a Reminder to do something of a general or company-specific nature.</p>"
                            :popOverContainer="'#' + id"
                            :record="record" 
                            column="parentType" 
                            :buttons="[
                                {value:'Matter', text: 'Matter', title: 'The Reminder is linked to a specific Matter'},
                                {value:'Party', text: 'Party', title: 'The Reminder is linked to a specific Party'},
                                {value:'General', text: 'General', title: 'The Reminder is not associated with a specific Matter or Party'},
                            ]" 
                            name="parentType" 
                            label="Type" 
                            :error="errors.parentType"
                            />
                        </div>


                    </div>

                    <div v-show="record.completedFlag == 1" class="col-md-4">
                            
                        <div class="form-group row">

                            <div class="col-md-12">

                                <fieldset class="mt-2">
                                    <legend style="padding-top:5px" title="Click here to mark the Reminder as Incomplete"> 
                                        <b-form-checkbox
                                            :id="id + '-completed-reminder-checkbox'"
                                            v-model="record.completedFlag"
                                            name="completedReminderCheckBox"
                                            value="1"
                                            unchecked-value="0"
                                            >
                                            Completed
                                        </b-form-checkbox>
                                    </legend>

                                    <div class="form-group row">

                                        <div class="col-md-12">

                                            <label>Date</label>

                                            <div class="input-group">
                                                <date-picker @dp-change="hideCompletedDatePicker" :readOnly="record.readOnly ? true: false" ref="completedDatePickerComponent" v-model="record.completedDateTime" :config="$root.dateTimePickerOptions"/>
                                                <div class="input-group-append">
                                                    <button
                                                        tabindex="-1"
                                                        type="button"
                                                        title="Click here to select a date"
                                                        v-on:click="toggleCompletedDatePicker"
                                                        class="btn btn-primary"
                                                    ><i class="fa fa-calendar"></i>
                                                    </button>
                                                </div>
                                            </div>
                                            <div v-if="errors.completedDateTime" v-html="errors.completedDateTime[0]" class="invalid-feedback"></div>

                                        </div>
                                    </div>

                                    <div class="form-group row">

                                        <div class="col-md-12">

                                            <label>Completed By</label>
                                            <employee-dropdown
                                                :id="id + 'completed-employee-dropdown'"
                                                openDirection="below"
                                                placeholder=""
                                                :options="$root.employees" 
                                                v-model="completedEmployee"
                                                track-by="recordid"
                                                :tabindex="-1"
                                                label="name"
                                                :allow-empty="false"
                                                :show-labels="false"
                                            >
                                            <template slot="noResult">No Employees found</template>
                                            <template slot="noOptions">No Employees found...</template>
                                            <template slot="option" slot-scope="props"><div><span>{{ props.option.name }}</span></div></template>
                                            </employee-dropdown>
                                            <div v-if="errors.completedEmployeeId" v-html="errors.completedEmployeeId[0]" class="invalid-feedback"></div>

                                        </div>

                                    </div>

                                </fieldset>
                            </div>

                        </div>

                    </div>

                </div>

                <div v-show="record.parentType !== 'General'" class="form-group row">

                    <select-matter
                        v-show="record.parentType === 'Matter'"
                        _class="col-md-10"
                        :id="id + '-select-matter'"
                        title="The Matter this Reminder is linked to"
                        ref="reminder-select-matter" 
                        form-ref="reminder-select-matter"
                        :error="errors.matterId"
                    />

                    <select-party
                        v-show="record.parentType === 'Party'"
                        _class="col-md-10"
                        :id="id + '-select-party'"
                        title="The Party this Reminder is linked to"
                        ref="reminder-select-party" 
                        form-ref="reminder-select-party"
                        :error="errors.partyId"
                    />

                </div>

                <div class="form-group row">

                    <text-area _class="col-md-12" rows="4" cols="50" v-model="record.description" name="description" label="Description" :error="errors.description"/>

                </div>  

                <div v-show="record.recurringFlag == 1" class="form-group row">
                    <div class="col-md-12">
                        <fieldset class="mt-2">
                            <legend style="padding-top:5px" title="Click here to cancel the repetition"> 
                            <b-form-checkbox
                                :id="id + '-recurring-reminder-checkbox'"
                                v-model="record.recurringFlag"
                                name="recurringReminderCheckBox"
                                value="1"
                                unchecked-value="0"
                                >
                                Recurring Reminder
                            </b-form-checkbox>
                            </legend>

                            <div class="form-group row">

                                <div class="col-md-3">
                                    <label>Repeating</label>
                                    <v-select append-to-body :calculate-position="$root.popUp" :options="recurringPeriods" :clearable="false" :searchable="false" v-model="record.recurringPeriod"/>
                                </div>

                                <text-input v-show="record.recurringPeriod == 'Custom'" _class="col-md-3" type="number" input-class="form-input-number" v-model="record.recurringCustomAmount" name="recurringCustomAmount" label="Every" :error="errors.recurringCustomAmount" />

                                <div v-show="record.recurringPeriod == 'Custom'" class="col-md-3">

                                    <label>Period</label>
                                    <v-select append-to-body :calculate-position="$root.popUp" :options="customPeriods" :clearable="false" :searchable="false" v-model="record.recurringCustomUnits"/>

                                </div>

                            </div>

                        </fieldset>

                    </div>

                </div>

            </div>

            <div class="modal-footer justify-content-between">
                <div>
                    <button v-show="editing" class="btn btn-primary form-button mr-3" type="button" @click="deleteClicked">
                        <span title="Delete this Reminder"><i class="fa fa-trash fa-lg mr-2"></i>Delete</span>
                    </button>

                    <button v-if="record.recurringFlag == 0" class="btn btn-secondary form-button mr-3" @click="toggleRepeated" type="button" title="Make this a recurring Reminder"><i class="fa fa-recycle fa-lg mr-2"></i>Repeat</button>
                    <button v-if="record.completedFlag == 0" class="btn btn-important form-button mr-3" @click="toggleCompleted" type="button" title="Mark the Reminder as 'Done'"><i class="fa fa-check-circle fa-lg mr-2"></i>Completed</button>
                </div>
                <div>
                    <button class="btn btn-success form-button mr-3" @click="okClicked" type="button" title="Save the Reminder"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>
                    <button class="btn btn-danger form-button" @click="closeForm" type="button" title="Exit without saving"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
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
import FormTemplate from "@pages/form-template";
import modalTemplate from "@components/modals/modal-template";
import Multiselect from 'vue-multiselect';

export default {

    mixins: [FormTemplate, modalTemplate],
    
    components: {
        SelectMatter: () => import("@pages/matters/SelectMatter"),
        SelectParty: () => import("@pages/parties/SelectParty"),
        EmployeeDropdown: Multiselect,
    },

    props: {
        resource: {type: String, default: 'Reminders' },
        title: {
            type: String,
            default: '',
        }, 
    },

    data() {
        return {
            currentParentType: null,
            targetEmployee: {
                id: null,
                name: null,
            },
            completedEmployee: {
                id: null,
                name: null,
            },
            customPeriods: ['Days','Weeks','Months','Years'],
            recurringPeriods: ['Daily','Weekly','Fortnightly','Monthly','Bi Monthly','3 Months','6 Months','Yearly','Custom'],
        };
    },

    computed: {
        ...mapGetters(['currentMatter','currentParty','currentEmployee']),
    },    


    methods: {

        editRecord(id) {

            axios.post('/reminders/get',{recordid: id})

            .then(response => {

                this.record = response.data.data[0];

                this.initFormData();

                this.selectMatter.matter = {
                    id: this.record.matterId,
                    matter: this.record.matter,
                };

                this.selectParty.partyName = '???';


            });

        },

        initNewRecord() {

            this.initFormData();

            this.record = {
                createdById: root.loggedInEmployeeId,
                createdEmployeeName: root.loggedInEmployeeName,

                parentType: this.currentParentType,

                matterId: this.currentMatter.recordid && this.parentType === 'Matter' ? this.currentMatter.recordid : null,
                partyId: this.currentParty.recordid && this.parentType === 'Party' ? this.currentParty.recordid : null,
                description: null,
                dateTime: moment().format(root.control.dateformat + ' HH:mm:ss'),

                targetEmployeeId: null,
                targetDate: moment().format(root.control.dateformat),

                completedFlag: 0,
                completedEmployeeId: null,
                completedDateTime: null,
                completedEmployeeId: null,
                completedDescription: null,

                recurringFlag: 0,
                recurringPeriod: 'Monthly',
                recurringCustomUnits: 'Days',
                recurringCustomAmount: '5',

            };

            this.selectMatter.matter = 
                this.currentMatter.fileref ? {
                    id: this.currentMatter.recordid,
                    matter: this.currentMatter.fileref + ' - ' + this.currentMatter.description
                } : null;

            this.selectParty.partyName = this.currentParty.code ? this.currentParty.code + ' - ' + this.currentParty.name : null;

            setTimeout(() => $('#' + this.id + ' textarea[name="description"]').focus() );

        },

        initFormData() {

            if ( !this.editing ) {

                this.targetEmployee.id = this.parentType === 'Employee' ? this.currentEmployee.id : root.loggedInEmployeeId;
                this.targetEmployee.name = this.parentType === 'Employee' ? this.currentEmployee.name : root.loggedInEmployeeName;

            } else {

                this.targetEmployee.id = this.record.targetEmployeeId;
                this.targetEmployee.name = this.record.targetEmployeeName;

                this.completedEmployee.id = this.record.completedEmployeeId;
                this.completedEmployee.name = this.record.completedEmployeeName;

            }

            this.displayForm();

        },
        
        toggleTargetDatePicker() {
            this.$refs.targetDatePickerComponent.elem.data('DateTimePicker').toggle();
        },
        toggleCompletedDatePicker() {
            this.$refs.completedDatePickerComponent.elem.data('DateTimePicker').toggle();
        },

        hideTargetDatePicker() {
            this.$refs.targetDatePickerComponent.elem.data('DateTimePicker').hide();
        },

        hideCompletedDatePicker() {
            this.$refs.completedDatePickerComponent.elem.data('DateTimePicker').hide();
        },


        toggleCompleted() {

            this.record.completedFlag = this.record.completedFlag == 1 ? 0 : 1;
            this.record.completedDateTime = this.record.completedFlag ? moment().format(root.control.dateformat + ' HH:mm:ss') : null;
            this.completedEmployee.id = this.record.completedEmployeeId = root.loggedInEmployeeId;
            this.completedEmployee.name = this.record.completedEmployeeName = root.loggedInEmployeeName;

        },

        toggleRepeated() {

            this.record.recurringFlag = this.record.recurringFlag == 1 ? 0 : 1;

        },

        okClicked() {

            this.record.targetEmployeeId = this.targetEmployee.id;

            this.record.matterId = this.record.parentType === 'Matter' && this.selectMatter.matter ? this.selectMatter.matter.id : null;
            this.record.partyId = this.record.parentType === 'Party' && this.selectParty.party ? this.selectParty.party.id : null;

            if ( this.record.completedFlag == 1 ) {

                this.record.completedEmployeeId = this.completedEmployee.id;

            } else {

                this.record.completedDateTime = null;            

            }

            axios.post('/reminders/store', this.record)
            
            .then(response => {

                if (response.data.errors) {

                    if (response.data.errors.general) { showError( 'Error', response.data.errors.general[0]);} else { this.errors = response.data.errors; }

                } else {

                    this.errors = {};

                    if ( response.data.recurringFlag == 1 && response.data.completedFlag == 1 && !response.data.childId ) {

                        axios.post('/reminders/get', {id: response.data.childId} )

                        .then(record => {

                            this.highlightTableRow(record.data[0].id, record.data[0].dateTime);

                        });

                    } else {

                        if ( this.id !== 'reminders-right-reminder-form' ) {

                            this.$root.setTableToRefresh('reminders', 'reminders-table');

                        }


                        this.highlightTableRow(response.data.id, response.data.date);

                    }

                    
                }

            }).catch(error => { showError('Error saving ' + this.table.singular, error); });

        },

        highlightTableRow( id, date ) {

            axios.post('/reminders/getTablePosition', {
                date: date,
            })

            .then(response => {

                this.table.jumpToRow(id, response.data);
                
                this.closeForm();

            });

        },     

    },

}

</script>
