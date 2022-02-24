
<template>
    <div class="modal" :id="id">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-color: indianred;">

            <div class="modal-header indianred">
                <h3 class="modal-title"><i class="fa fa-filter mr-2"></i>Filter Matters</h3>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="card-body form-tab-body overflow-auto p-3" style="height: 66vh;">

                <form-tabs :tabs="tabs"/>

                <div v-show="activeTab === 'General'" class="form-tab-content">

                    <div class="form-group row">
                        <div class="col-md-12">
                            <b-form-checkbox
                                class="mt-1 mb-1"
                                title="Display Matters that belong to you"
                                v-model="myRecordsSelected"
                                value="1"
                                unchecked-value="0"
                                @change="myRecordsChanged"
                            >
                            Display My Matters
                            </b-form-checkbox>

                        </div>
                    </div>

                    <select-date-filter
                        :id="id + '-date-filter'"
                        :ref="id + '-date-filter'"
                        label="Date Instructed"
                    />

                    <div class="row">

                        <div class="col-md-6">

                            <div class="form-group row">

                                <select-matter-client 
                                    :clearIcon="partyFilterFlag ? true : false"
                                    clearIconCallback="clearPartyFilter"
                                    :id="id + '-select-matter-client'" 
                                    :ref="id + '-select-matter-client'" 
                                    :formRef="id + '-select-matter-client'" 
                                    label="Client"
                                    title="The Client this Matter belongs to"
                                    singular="Client"
                                    plural="Clients"
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
                                />
                            </div>
                        </div>

                    </div>

                    <div class="row">

                        <div class="col-md-6">

                            <div class="form-group row">
                                <select-branch
                                    :clearIcon="branchFilterFlag ? true : false"
                                    clearIconCallback="clearBranchFilter"
                                    :id="id + '-select-branch'" 
                                    :ref="id + '-select-branch'" 
                                    :formRef="id + '-select-branch'" 
                                />
                            </div>

                        </div>

                        <div class="col-md-6">

                            <div class="form-group row">
                                <select-document-set 
                                    :clearIcon="documentSetFilterFlag ? true : false"
                                    clearIconCallback="clearDocumentSetFilter"
                                    :id="id + '-select-document-set'" 
                                    :ref="id + '-select-document-set'" 
                                    :formRef="id + '-select-document-set'" 
                                />
                            </div>

                        </div>

                    </div>

                    <div class="row">
                        <div class="col-md-6">

                            <div class="form-group row">
                                <select-matter-type 
                                    :clearIcon="matterTypeFilterFlag ? true : false"
                                    clearIconCallback="clearMatterTypeFilter"
                                    :id="id + '-select-matter-type'" 
                                    :ref="id + '-select-matter-type'" 
                                    :formRef="id + '-select-matter-type'" 
                                />
                            </div>

                        </div>

                        <div class="col-md-6">

                            <div class="form-group row">
                                <select-cost-centre 
                                    :clearIcon="costCentreFilterFlag ? true : false"
                                    clearIconCallback="clearCostCentreFilter"
                                    :id="id + '-select-cost-centre'" 
                                    :ref="id + '-select-cost-centre'" 
                                    :formRef="id + '-select-cost-centre'" 
                                />
                            </div>

                        </div>
                    </div>
                </div>

                <div v-show="activeTab === 'Conveyancing'" class="form-tab-content">

                    <div class="form-group row">
                    
                        <div class="col-md-6">
                            <label>Conveyancing Status</label>

                            <i v-show="conveyancingStatus" class="fa fa-times-circle cp text-danger ml-1 clear-icon" style="font-size: large" title="Clear the existing filter" @click="clearConveyancingStatus"></i>

                            <v-select
                                title="Filter the Matters by their Conveyancing status"
                                :options="conveyancingStatusOptions" 
                                :clearable="false" 
                                :searchable="false" 
                                :reduce="conveyancingStatusOptions => conveyancingStatusOptions.value"
                                v-model="conveyancingStatus"
                            />
                    
                        </div>
                    </div>


                    <select-date-filter
                        :id="id + '-lodged-date-filter'"
                        :ref="id + '-lodged-date-filter'"
                        label="Date Lodged"
                    />

                    <select-date-filter
                        :id="id + '-registered-date-filter'"
                        :ref="id + '-registered-date-filter'"
                        label="Date Registered"
                    />


                </div>

                <div v-show="activeTab === 'Financial'" class="form-tab-content">

                    <amount-filter
                        :id="id + '-business-filter'"
                        :ref="id + '-business-filter'"
                        label="Business Balance"
                    />

                    <amount-filter
                        :id="id + '-trust-filter'"
                        :ref="id + '-trust-filter'"
                        label="Transfer Available"
                    />
                </div>

                <div v-show="activeTab === 'Custom'" class="form-tab-content">

                    <custom-filter
                        ref="customFilter"
                        popOver="<h4>Custom SQL Filter</h4>
                        <p>A valid SQL where clause to filter the Matters</p>
                        <p><strong>Examples:</strong></p>
                        <p>Matter.ClaimAmount > 0</p>
                        <p>Matter.ArchiveDate <= 81234</p>
                        <p>ConveyData.Step6Completed > 79361</p>
                        <p>Matter.StageGroupID = 12 OR StageGroupID = 13</p>
                        <p>Matter.ToDoGroupID IN (SELECT RecordID FROM PlanOfAction WHERE Description = 'Bonds')</p>"
                        :popOverContainer="'#' + id"
                        :lookupLibraryFlag="true"
                        lookupLibraryCategory="Custom string to filter Matters"
                    />
                </div>

            </div>

            <div class="modal-footer justify-content-between">
                <div>
                    <button class="btn btn-secondary form-button mr-2" type="button" @click="loadAdvancedFilters" title="Advanced Filtering options"><i class="fa fa-cog fa-lg mr-2"></i>Advanced</button>
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
        SelectMatterClient: () => import("@pages/parties/SelectParty"),
        SelectMatterType: () => import("@pages/matters/SelectMatterType"),
        SelectDocumentSet: () => import("@pages/document-sets/SelectDocumentSet"),
        SelectCostCentre: () => import("@pages/matters/SelectCostCentre"),
        SelectBranch: () => import("@pages/matters/SelectBranch"),
        SelectEmployee: () => import("@pages/employees/SelectEmployee"),
    },

    data() {
        return {
            table: null,
            myRecordsSelected: '0',
            partyFilterFlag: false,
            branchFilterFlag: false,
            employeeFilterFlag: false,
            matterTypeFilterFlag: false,
            documentSetFilterFlag: false,
            costCentreFilterFlag: false,
            partyFilterColumnName: 'Party.Name',
            branchFilterColumnName: 'Branch.Description',
            employeeFilterColumnName: 'Employee.Name',
            matterTypeFilterColumnName: 'MatType.Description',
            documentSetFilterColumnName: 'DocGen.Description',
            costCentreFilterColumnName: 'CostCentre.Description',
            businessFilterColumnName: 'Matter.Actual',
            trustFilterColumnName: 'Matter.Transfer',
            dateFilterColumnName: 'Matter.DateInstructed',
            lodgedDateFilterColumnName: 'ConveyData.Step4Completed',
            registeredDateFilterColumnName: 'ConveyData.Step6Completed',
            myRecordsFilterColumnName: 'Employee.Name',
            conveyancingStatus: null,
            conveyancingStatusFilterColumnName: 'Matter.ConveyancingStatusFlag',
            conveyancingStatusOptions : [ 
                {value:'1', label: 'New Instruction'},
                {value:'2', label: 'Amended Instruction'},
                {value:'3', label: 'Lodged'},
                {value:'4', label: 'Registered'},
                {value:'5', label: 'NTU Instruction'},
                {value:'6', label: 'Withdrawn'},
                {value:'7', label: 'Cancelled'},
            ],
            activeTab: 'General',
            tabs: [
                {
                    pageName: "General",
                    title: "General",
                    iconClass: '',
                    visible: true,
                    active: true,
                },
                {
                    pageName: "Conveyancing",
                    title: "Conveyancing",
                    iconClass: '',
                    visible: true,
                    active: false,
                },
                {
                    pageName: "Financial",
                    title: "Financial",
                    iconClass: '',
                    visible: true,
                    active: false,
                },
            ],
        }

    },

    watch: {

        partyFilterFlag: function (newValue) {
            if (newValue === false) {
                this.selectParty.party = '';
            } else {
                let filter = this.getFilter(this.partyFilterKey);
                if ( filter !== null ) {
                    axios.post('/party/get',{
                        whereRaw: "matterprefix = '" + filter.settings.value + "'",
                    })
                    .then(response => {

                        if (response.data.errors) { 

                            showError( 'Error', response.data.errors);
                            this.partyFilterFlag = false;

                        } else {

                            if ( response.data.data.length ) {
                                this.selectParty.partyName = htmlDecode(response.data.data[0].matterprefix + ' - ' + response.data.data[0].name);
                            } else {
                                showError( 'Error', 'No Party found');
                                this.partyFilterFlag = false;
                            }

                        }
                    });
                }
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

        branchFilterFlag: function (newValue) {
            if (newValue === false) {
                this.selectBranch.record = {};
            } else {
                let filter = this.getFilter(this.branchFilterKey);
                if ( filter !== null ) this.selectBranch.record = {description: filter.settings.value};
            }
        },

        matterTypeFilterFlag: function (newValue) {
            if (newValue === false) {
                this.selectMatterType.record = {};
            } else {
                let filter = this.getFilter(this.matterTypeFilterKey);
                if ( filter !== null ) this.selectMatterType.record = {description: filter.settings.value};
            }
        },

        documentSetFilterFlag: function (newValue) {
            if (newValue === false) {
                this.selectDocumentSet.record = {};
            } else {
                let filter = this.getFilter(this.documentSetFilterKey);
                if ( filter !== null ) this.selectDocumentSet.record = {description: filter.settings.value};
            }
        },

        costCentreFilterFlag: function (newValue) {
            if (newValue === false) {
                this.selectCostCentre.record = {};
            } else {
                let filter = this.getFilter(this.costCentreFilterKey);
                if ( filter !== null ) this.selectCostCentre.record = {description: filter.settings.value};
            }
        },

        conveyancingStatus: function (newValue) {
            
            this.setConveyancingStatusFilter(newValue);

        },

    },    

    methods: {

        modalOpened(){

            this.setGeneralTab();

            this.$refs.customFilter.initialize(this.table);

            this.primeCommonFilters();

            //Prime the DropDown filters
            this.partyFilterKey = this.getFilterName(this.partyFilterColumnName);
            this.partyFilter = this.getFilter(this.partyFilterKey);
            this.partyFilterFlag = this.partyFilter ? true : false;

            if ( this.partyFilterFlag ) {

                axios.post('/party/get',{
                    whereRaw: "matterprefix = '" + this.partyFilter.settings.value + "'",
                })

                .then(response => {

                    if (response.data.errors) { 

                        showError( 'Error', response.data.errors);
                        this.partyFilterFlag = false;

                    } else {

                        if ( response.data.data.length ) {
                            this.selectParty.partyName = htmlDecode(response.data.data[0].matterprefix + ' - ' + response.data.data[0].name);
                        } else {
                            showError( 'Error', 'No Party found');
                            this.partyFilterFlag = false;
                        }

                    }
                });
            }

            this.branchFilterKey = this.getFilterName(this.branchFilterColumnName);
            this.branchFilter = this.getFilter(this.branchFilterKey);
            this.branchFilterFlag = this.branchFilter ? true : false;
            this.selectBranch.record = this.branchFilterFlag ? {description: this.branchFilter.settings.value} : {};

            this.employeeFilterKey = this.getFilterName(this.employeeFilterColumnName);
            this.employeeFilter = this.getFilter(this.employeeFilterKey);
            this.employeeFilterFlag = this.employeeFilter ? true : false;
            this.selectEmployee.record = this.employeeFilterFlag ? {name: this.employeeFilter.settings.value} : {};

            this.matterTypeFilterKey = this.getFilterName(this.matterTypeFilterColumnName);
            this.matterTypeFilter = this.getFilter(this.matterTypeFilterKey);
            this.matterTypeFilterFlag = this.matterTypeFilter ? true : false;
            this.selectMatterType.record = this.matterTypeFilterFlag ? {description: this.matterTypeFilter.settings.value} : {};

            this.documentSetFilterKey = this.getFilterName(this.documentSetFilterColumnName);
            this.documentSetFilter = this.getFilter(this.documentSetFilterKey);
            this.documentSetFilterFlag = this.documentSetFilter ? true : false;
            this.selectDocumentSet.record = this.documentSetFilterFlag ? {description: this.documentSetFilter.settings.value} : {};

            this.costCentreFilterKey = this.getFilterName(this.costCentreFilterColumnName);
            this.costCentreFilter = this.getFilter(this.costCentreFilterKey);
            this.costCentreFilterFlag = this.costCentreFilter ? true : false;
            this.selectCostCentre.record = this.costCentreFilterFlag ? {description: this.costCentreFilter.settings.value} : {};

            // Prime the Conveyancing Status Dropdown
            this.conveyancingStatusFilterKey = this.getFilterName(this.conveyancingStatusFilterColumnName);
            this.conveyancingStatusFilter = this.getFilter(this.conveyancingStatusFilterKey);
            let conveyancingStatusFilteredFlag = this.conveyancingStatusFilter ? true : false;

            if (conveyancingStatusFilteredFlag) {
                this.conveyancingStatus = this.conveyancingStatusFilter.settings.value;
            }


            // Prime the Lodged Date Filter 
            this.lodgedDateFilterKey = this.getFilterName(this.lodgedDateFilterColumnName);
            this.lodgedDateFilter = this.getFilter(this.lodgedDateFilterKey);

            let lodgedDateFilterComponent = this.$refs[this.id + '-lodged-date-filter'];

            lodgedDateFilterComponent.primeFilter(this.lodgedDateFilterKey, this.lodgedDateFilterColumnName);

            let lodgedDateFilteredFlag = this.lodgedDateFilter ? true : false;

            if ( lodgedDateFilteredFlag ) {

                lodgedDateFilterComponent.period = this.lodgedDateFilter.settings.period;
                lodgedDateFilterComponent.currentPeriod = this.lodgedDateFilter.settings.period;
                lodgedDateFilterComponent.toDate = this.lodgedDateFilter.settings.toDate;
                lodgedDateFilterComponent.fromDate = this.lodgedDateFilter.settings.fromDate;
            }


            // Prime the Registered Date Filter 
            this.registeredDateFilterKey = this.getFilterName(this.registeredDateFilterColumnName);
            this.registeredDateFilter = this.getFilter(this.registeredDateFilterKey);

            let registeredDateFilterComponent = this.$refs[this.id + '-registered-date-filter'];

            registeredDateFilterComponent.primeFilter(this.registeredDateFilterKey, this.registeredDateFilterColumnName);

            let registeredDateFilteredFlag = this.registeredDateFilter ? true : false;

            if ( registeredDateFilteredFlag ) {

                registeredDateFilterComponent.period = this.registeredDateFilter.settings.period;
                registeredDateFilterComponent.currentPeriod = this.registeredDateFilter.settings.period;
                registeredDateFilterComponent.toDate = this.registeredDateFilter.settings.toDate;
                registeredDateFilterComponent.fromDate = this.registeredDateFilter.settings.fromDate;
            }


            // Prime the Business Filter component
            let businessFilterKey = this.getFilterName(this.businessFilterColumnName);
            this.$refs[this.id + '-business-filter'].primeFilter(businessFilterKey, this.businessFilterColumnName);

            // Prime the Trust Filter component
            let trustFilterKey = this.getFilterName(this.trustFilterColumnName);
            this.$refs[this.id + '-trust-filter'].primeFilter(trustFilterKey, this.trustFilterColumnName);


        },

        clearConveyancingStatus() {

            this.conveyancingStatus = null;
        },

        setConveyancingStatusFilter( value ) {

            this.deleteFilter(this.conveyancingStatusFilterKey);

            if ( value ) {

                this.addFilter(this.conveyancingStatusFilterColumnName, this.conveyancingStatusFilterKey, value, value, 'Equal to');

            }

            this.table.setUserFilters();

            this.table.table.ajax.reload();

        },

        branchSelected(id, description) {

            this.deleteFilter(this.branchFilterKey);

            this.addFilter(this.branchFilterColumnName, this.branchFilterKey, description);

            this.branchFilterFlag = true;

            this.table.setUserFilters();

            this.table.table.ajax.reload();

        },

        clearBranchFilter() {

            this.deleteFilter(this.branchFilterKey);

            this.branchFilterFlag = false;

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

        documentSetSelected( selectedRecord ) {

            this.deleteFilter(this.documentSetFilterKey);

            this.addFilter(this.documentSetFilterColumnName, this.documentSetFilterKey, selectedRecord.description);

            this.documentSetFilterFlag = true;

            this.reloadTable();

        },

        clearDocumentSetFilter() {

            this.deleteFilter(this.documentSetFilterKey);

            this.documentSetFilterFlag = false;

            this.reloadTable();

        },

        costCentreSelected( id, description ) {

            this.deleteFilter(this.costCentreFilterKey);

            this.addFilter(this.costCentreFilterColumnName, this.costCentreFilterKey, description);

            this.costCentreFilterFlag = true;

            this.reloadTable();

        },

        clearCostCentreFilter() {

            this.deleteFilter(this.costCentreFilterKey);

            this.costCentreFilterFlag = false;

            this.reloadTable();

        },

        matterTypeSelected( selectedRecord ) {

            this.deleteFilter(this.matterTypeFilterKey);

            this.addFilter(this.matterTypeFilterColumnName, this.matterTypeFilterKey, selectedRecord.description);

            this.matterTypeFilterFlag = true;

            this.reloadTable();

        },

        clearMatterTypeFilter() {

            this.deleteFilter(this.matterTypeFilterKey);

            this.matterTypeFilterFlag = false;

            this.reloadTable();

        },



    }   
}  
</script>