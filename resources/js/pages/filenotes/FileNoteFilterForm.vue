
<template>
    <div class="modal" :id="id">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-color: indianred;">

            <div class="modal-header indianred">
                <h3 class="modal-title"><i class="fa fa-filter mr-2"></i>Filter File Notes</h3>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="card-body form-tab-body overflow-auto p-3" style="height: 55vh;">

                <form-tabs :tabs="tabs"/>

                <div v-show="activeTab === 'General'" class="form-tab-content">

                    <div class="form-group row">
                        <div class="col-md-12">
                            <b-form-checkbox
                                class="mt-1 mb-1"
                                title="Display File Notes allocated to you"
                                v-model="myRecordsSelected"
                                value="1"
                                unchecked-value="0"
                                @change="myRecordsChanged"
                            >
                            Display My File Notes
                            </b-form-checkbox>

                        </div>
                    </div>

                    <select-date-filter
                        :id="id + '-date-filter'"
                        :ref="id + '-date-filter'"
                    />


                    <div class="row">

                        <div class="col-md-6">

                            <div class="form-group row">
                                <select-stage
                                    :clearIcon="stageFilterFlag ? true : false"
                                    clearIconCallback="clearStageFilter"
                                    :id="id + '-select-stage'" 
                                    :ref="id + '-select-stage'" 
                                    :formRef="id + '-select-stage'" 
                                />
                            </div>


                        </div>

                        <div class="col-md-6">

                            <div class="form-group row">
                                <select-employee
                                    :clearIcon="employeeFilterFlag ? true : false"
                                    clearIconCallback="clearEmployeeFilter"
                                    :id="id + '-select-employee'" 
                                    :ref="id + '-select-employee'" 
                                    :formRef="id + '-select-employee'"
                                    label="Created By" 
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
                        <p>A valid SQL <em>where clause</em> to filter the File Notes</p>
                        <p><strong>Examples:</strong></p>
                        <p>FileNote.Description LIKE '%Document%'</p>
                        <p>FileNote.Date <= 81234</p>
                        <p>FileNote.EmployeeID = 12 OR FileNote.EmployeeID = 13</p>"
                        :popOverContainer="'#' + id"
                        :lookupLibraryFlag="true"
                        lookupLibraryCategory="Custom string to filter the File Notes"
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
        SelectStage: () => import("./SelectStage"),
        SelectEmployee: () => import("@pages/employees/SelectEmployee"),
    },


    data() {
        return {
            table: null,
            myRecordsSelected: '0',
            myRecordsFilterColumnName: 'employee.name',
            dateFilterColumnName: 'filenote.date',
            descriptionSelected: '',
            descriptionFilterColumnName: 'filenote.description',

            employeeFilterFlag: false,
            stageFilterFlag: false,
            stageFilterColumnName: 'stage.code',
            employeeFilterColumnName: 'employee.name',


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

        employeeFilterFlag: function (newValue) {
            if (newValue === false) {
                this.selectEmployee.record = {};
            } else {
                let filter = this.getFilter(this.employeeFilterKey);
                if ( filter !== null ) this.selectEmployee.record = {name: filter.settings.value};
            }
        },

        stageFilterFlag: function (newValue) {
            if (newValue === false) {
                this.selectStage.record = {};
            } else {
                let filter = this.getFilter(this.stageFilterKey);
                if ( filter !== null ) this.selectStage.record = {description: filter.settings.value};
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

            this.stageFilterKey = this.getFilterName(this.stageFilterColumnName);
            this.stageFilter = this.getFilter(this.stageFilterKey);
            this.stageFilterFlag = this.stageFilter ? true : false;

            if ( this.stageFilterFlag ) {

                let stage = root.stages.filter(record => record.recordid == this.stageFilter.settings.value1)[0];

                this.selectStage.stageGroupId = stage.stagegroupid;

                this.selectStage.record = {
                    recordid: stage.recordid,
                    description: stage.description,
                }

            } else {
                this.selectStage.record = {};
            }

            if ( !this.selectStage.stageGroupId ) {
                this.selectStage.stageGroupId = root.stageGroups[0].recordid;
            }


            this.employeeFilterKey = this.getFilterName(this.employeeFilterColumnName);
            this.employeeFilter = this.getFilter(this.employeeFilterKey);
            this.employeeFilterFlag = this.employeeFilter ? true : false;
            this.selectEmployee.record = this.employeeFilterFlag ? {name: this.employeeFilter.settings.value} : {};

        },

        stageSelected(selectedRecord) {

            this.deleteFilter(this.stageFilterKey);

            this.addFilter(this.stageFilterColumnName, this.stageFilterKey, selectedRecord.code, selectedRecord.recordid, 'Equals', null, 'Stage = ' + selectedRecord.code + ' - ' + selectedRecord.description);

            this.stageFilterFlag = true;

            this.table.setUserFilters();

            this.table.table.ajax.reload();

        },

        clearStageFilter() {

            this.deleteFilter(this.stageFilterKey);

            this.stageFilterFlag = false;

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


    }   
}  
</script>