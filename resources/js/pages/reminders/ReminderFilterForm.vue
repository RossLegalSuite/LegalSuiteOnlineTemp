
<template>
    <div class="modal" :id="id">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-color: indianred;">

            <div class="modal-header indianred">
                <h3 class="modal-title"><i class="fa fa-filter mr-2"></i>Filter Reminders</h3>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="card-body form-tab-body overflow-auto p-3" style="height: 55vh;">

                <form-tabs :tabs="tabs"/>

                <div v-show="activeTab === 'General'" class="form-tab-content">

                    <div class="form-group row">
                        <div class="col-md-12">
                            <b-form-checkbox
                                class="mt-1 mb-1"
                                title="Display Reminders allocated to you"
                                v-model="myRecordsSelected"
                                value="1"
                                unchecked-value="0"
                                @change="myRecordsChanged"
                            >
                            Display My Reminders
                            </b-form-checkbox>

                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <select-date-filter
                                :id="id + '-created-date-filter'"
                                :ref="id + '-created-date-filter'"
                                label="Created Date"
                                _class="col-md-12"
                            />
                        </div>

                        <div class="col-md-4">
                            <select-date-filter
                                :id="id + '-target-date-filter'"
                                :ref="id + '-target-date-filter'"
                                label="Target Date"
                                _class="col-md-12"
                            />
                        </div>

                        <div class="col-md-4">
                            <select-date-filter
                                :id="id + '-completed-date-filter'"
                                :ref="id + '-completed-date-filter'"
                                label="Completed Date"
                                _class="col-md-12"
                            />
                        </div>
                    </div>

                    <div class="row">

                        <div class="col-md-4">

                            <div class="form-group row">
                                <select-employee
                                    :clearIcon="createdEmployeeFilterFlag ? true : false"
                                    clearIconCallback="clearCreatedEmployeeFilter"
                                    :id="id + '-select-created-employee'" 
                                    :ref="id + '-select-created-employee'" 
                                    :formRef="id + '-select-created-employee'"
                                    label="Created By" 
                                    callback="createdEmployeeSelected"
                                    parentName="selectCreatedEmployee"
                                />
                            </div>


                        </div>

                        <div class="col-md-4">
                            <div class="form-group row">
                                <select-employee
                                    :clearIcon="employeeFilterFlag ? true : false"
                                    clearIconCallback="clearEmployeeFilter"
                                    :id="id + '-select-employee'" 
                                    :ref="id + '-select-employee'" 
                                    :formRef="id + '-select-employee'"
                                    label="Assigned To" 
                                />
                            </div>

                        </div>

                        <div class="col-md-4">
                            <div class="form-group row">
                                <select-employee
                                    :clearIcon="completedEmployeeFilterFlag ? true : false"
                                    clearIconCallback="clearCompletedEmployeeFilter"
                                    :id="id + '-select-completed-employee'" 
                                    :ref="id + '-select-completed-employee'" 
                                    :formRef="id + '-select-completed-employee'"
                                    label="Completed By" 
                                    callback="completedEmployeeSelected"
                                    parentName="selectCompletedEmployee"
                                />
                            </div>

                        </div>

                    </div>

                    <div class="row">
                        <div class="col-md-6">

                            <div class="form-group row">
                                <radio-buttons 
                                    ref="status-radio-button"
                                    label="Completed" 
                                    :record="statusRadioButtonRecord" 
                                    column="value" 
                                    name="value" 
                                    :buttons="statusArray" 
                                    @change="statusRadioButtonChanged"
                                />
                            </div>

                        </div>

                        <div class="col-md-6">

                            <div class="form-group row">
                                <radio-buttons 
                                    ref="overdue-radio-button"
                                    label="Overdue" 
                                    :record="overdueRadioButtonRecord" 
                                    column="value" 
                                    name="value" 
                                    :buttons="overdueArray" 
                                    @change="overdueRadioButtonChanged"
                                />
                            </div>

                        </div>
                    </div>


                    <div class="form-group row">
                        <text-input 
                            v-model="descriptionSelected" 
                            popOver="<h4>Description</h4><p>Enter a description or part of a description and press TAB to filter the records.</p>"
                            @change="setDescription" 
                            label="Description"
                            :ref="id + '-description-filter'"
                            :clearIconCallback="'descriptionCleared'"
                        />

                    </div>

                </div>

                <div v-show="activeTab === 'Custom'" class="form-tab-content">

                    <custom-filter
                        ref="customFilter"
                        popOver="<h4>Custom SQL Filter</h4>
                        <p>A valid SQL <em>where clause</em> to filter the Reminders</p>
                        <p><strong>Examples:</strong></p>
                        <p>TodoNote.Description LIKE '%Remember%'</p>
                        <p>TodoNote.Date <= 81234</p>
                        <p>TodoNote.EmployeeID = 12 OR TodoNote.EmployeeID = 13</p>"
                        :popOverContainer="'#' + id"
                        :lookupLibraryFlag="true"
                        lookupLibraryCategory="Custom string to filter the Reminders"
                    />
                </div>


            </div>

            <div class="modal-footer justify-content-between">
                <div>
                    <button class="btn btn-primary form-button mr-2" type="button" @click="loadAdvancedFilters" title="Advanced Filtering options"><i class="fa fa-cog fa-lg mr-2"></i>Advanced</button>
                </div>
                <div>
                    <button class="btn btn-danger form-button" type="button" @click="hide" title="Close this screen"><i class="fa fa-times-circle fa-lg mr-2"></i>Close</button>
                </div>
            </div>

            </div>
        </div>
    </div>
</template>

<script>

import modalTemplate from "@components/modals/modal-template";
import filterMethods from "@components/filters/filter-methods";

export default {

    mixins: [modalTemplate, filterMethods],

    components: {
        SelectEmployee: () => import("@pages/employees/SelectEmployee"),
    },


    data() {
        return {
            table: null,
            myRecordsSelected: '0',
            myRecordsFilterColumnName: 'employee.name',

            descriptionSelected: '',
            descriptionFilterColumnName: 'todonote.description',

            createdEmployeeFilterFlag: false,
            createdEmployeeFilterColumnName: 'createdby.name',

            employeeFilterFlag: false,
            employeeFilterColumnName: 'employee.name',

            completedEmployeeFilterFlag: false,
            completedEmployeeFilterColumnName: 'completedby.name',

            createdDateFilterColumnName: 'todonote.createddate',
            targetDateFilterColumnName: 'todonote.date',
            completedDateFilterColumnName: 'todonote.datedone',

            statusRadioButtonRecord: { value: null},
            statusFilterColumnName: 'completedFlag',
            statusArray: [{ text:'Completed', value:'1'}, { text:'Incomplete', value:'0'}],

            overdueRadioButtonRecord: { value: null},
            overdueFilterColumnName: 'overdueFlag',
            overdueArray: [{ text:'Overdue', value:'1'}, { text:'Not Overdue', value:'0'}],

            activeTab: 'General',
            tabs: [
                {
                    pageName: "General",
                    title: "General",
                    iconClass: '',
                    visible: true,
                    active: true,
                }
            ],        
        }
    },

    watch: {

        createdEmployeeFilterFlag: function (newValue) {
            if (newValue === false) {
                this.selectCreatedEmployee.record = {};
            } else {
                let filter = this.getFilter(this.createdEmployeeFilterKey);
                if ( filter !== null ) this.selectCreatedEmployee.record = {name: filter.settings.value};
            }
        },

        employeeFilterFlag: function (newValue) {
            if (newValue === false) {
                this.selectEmployee.record = {};
            } else {
                let filter = this.getFilter(this.employeeFilterKey);
                if ( filter !== null ) this.selectEmployee.record = {name: filter.settings.value};
            }
        },

        completedEmployeeFilterFlag: function (newValue) {
            if (newValue === false) {
                this.selectCompletedEmployee.record = {};
            } else {
                let filter = this.getFilter(this.completedEmployeeFilterKey);
                if ( filter !== null ) this.selectCompletedEmployee.record = {name: filter.settings.value};
            }
        },

    },    

    mounted() {
        this.$parent.filterForm = this;
    },    

    methods: {

        modalOpened() {

            this.setGeneralTab();

            this.$refs.customFilter.initialize(this.table);

            this.primeCommonFilters();


            // Prime the Created Date Filter 
            let createdDateFilterKey = this.getFilterName(this.createdDateFilterColumnName);
            this.$refs[this.id + '-created-date-filter'].primeFilter(createdDateFilterKey, this.createdDateFilterColumnName);

            // Prime the Target Date Filter 
            let targetDateFilterKey = this.getFilterName(this.targetDateFilterColumnName);
            this.$refs[this.id + '-target-date-filter'].primeFilter(targetDateFilterKey, this.targetDateFilterColumnName);

            // Prime the Completed Date Filter 
            let completedDateFilterKey = this.getFilterName(this.completedDateFilterColumnName);
            this.$refs[this.id + '-completed-date-filter'].primeFilter(completedDateFilterKey, this.completedDateFilterColumnName);


            this.createdEmployeeFilterKey = this.getFilterName(this.createdEmployeeFilterColumnName);
            this.createdEmployeeFilter = this.getFilter(this.createdEmployeeFilterKey);
            this.createdEmployeeFilterFlag = this.createdEmployeeFilter ? true : false;
            this.selectCreatedEmployee.record = this.createdEmployeeFilterFlag ? {name: this.createdEmployeeFilter.settings.value} : {};

            this.employeeFilterKey = this.getFilterName(this.employeeFilterColumnName);
            this.employeeFilter = this.getFilter(this.employeeFilterKey);
            this.employeeFilterFlag = this.employeeFilter ? true : false;
            this.selectEmployee.record = this.employeeFilterFlag ? {name: this.employeeFilter.settings.value} : {};

            this.completedEmployeeFilterKey = this.getFilterName(this.completedEmployeeFilterColumnName);
            this.completedEmployeeFilter = this.getFilter(this.completedEmployeeFilterKey);
            this.completedEmployeeFilterFlag = this.completedEmployeeFilter ? true : false;
            this.selectCompletedEmployee.record = this.completedEmployeeFilterFlag ? {name: this.completedEmployeeFilter.settings.value} : {};


            this.overdueRadioButtonComponent = this.$refs['overdue-radio-button'];

            this.overdueFilterKey = this.getFilterName(this.overdueFilterColumnName);
            this.overdueFilter = this.getFilter(this.overdueFilterKey);
            this.overdueFilterFlag = this.overdueFilter ? true : false;

            this.overdueRadioButtonComponent.clearIconCallback = 'clearOverdueFilter';
            this.overdueRadioButtonComponent.clearIcon = this.overdueFilterFlag;

            if ( this.overdueFilterFlag ) {
                this.overdueRadioButtonRecord.value = this.overdueFilter.settings.value; 
            } else {
                this.overdueRadioButtonRecord.value = null; 
            }

        },

        overdueRadioButtonChanged(newValue) {

            this.deleteFilter(this.overdueFilterKey);

            if ( newValue !== 'All') {
                
                this.overdueRadioButtonComponent.clearIcon = true;

                let description = this.overdueArray.filter(record => record.value == newValue)[0].text;

                this.addFilter(this.overdueFilterColumnName, this.overdueFilterKey, newValue, null, 'Equals', null, description);

            }

            this.reloadTable();

        },

        clearOverdueFilter() {

            this.overdueRadioButtonComponent.clearIcon = false;

            this.deleteFilter(this.overdueFilterKey);

            this.reloadTable();

            //Clear the Type Radio Button radio buttons
            this.overdueRadioButtonRecord.value = null; 


        },

        createdEmployeeSelected(selectedRecord) {

            this.deleteFilter(this.createdEmployeeFilterKey);

            this.addFilter(this.createdEmployeeFilterColumnName, this.createdEmployeeFilterKey, selectedRecord.name);

            this.createdEmployeeFilterFlag = true;

            this.reloadTable();

        },

        clearCreatedEmployeeFilter() {

            this.deleteFilter(this.createdEmployeeFilterKey);

            this.createdEmployeeFilterFlag = false;

            this.reloadTable();

        },

        employeeSelected(selectedRecord) {

            this.deleteFilter(this.employeeFilterKey);

            this.addFilter(this.employeeFilterColumnName, this.employeeFilterKey, selectedRecord.name);

            this.employeeFilterFlag = true;

            this.reloadTable();

        },

        clearEmployeeFilter() {

            this.deleteFilter(this.employeeFilterKey);

            this.employeeFilterFlag = false;

            this.reloadTable();

        },

        completedEmployeeSelected(selectedRecord) {

            this.deleteFilter(this.completedEmployeeFilterKey);

            this.addFilter(this.completedEmployeeFilterColumnName, this.completedEmployeeFilterKey, selectedRecord.name);

            this.completedEmployeeFilterFlag = true;

            this.reloadTable();

        },

        clearCompletedEmployeeFilter() {

            this.deleteFilter(this.completedEmployeeFilterKey);

            this.completedEmployeeFilterFlag = false;

            this.reloadTable();

        },

    }   
}  
</script>