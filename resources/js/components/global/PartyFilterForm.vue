
<template>
    <div class="modal" :id="id">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-color: indianred;">

            <div class="modal-header indianred">
                <h3 class="modal-title"><i class="fa fa-filter mr-2"></i>Filter Parties</h3>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="card-body form-tab-body overflow-auto p-3" style="height: 66vh;">

                <form-tabs :tabs="tabs"/>

                <div v-show="activeTab === 'General'" class="form-tab-content">

                    <fieldset><legend>Role</legend>

                        <div v-show="!partyRoleFilterFlag" class="form-group row">

                            <div class="col-md-6">

                                <!-- <label v-text="'Clients'" style="margin-bottom: 0.6rem !important;"/>

                                <pop-over content="
                                <h4>Parties who are Clients</h4>
                                <p>Display Parties who are Clients on at least one Matter.</p>
                                "/> -->

                                <b-form-checkbox
                                    class="mt-1 mb-1"
                                    title="Display Parties who are Clients on at least one Matter"
                                    v-model="isClientSelected"
                                    value="1"
                                    unchecked-value="0"
                                    @change="isClientChanged"
                                >
                                Display Parties who are Clients
                                </b-form-checkbox>

                            </div>

                        </div>

                        <div v-show="isClientSelected != '1'" class="form-group row">

                            <select-party-role
                                label="Select Role"
                                popOver="<h4>Party Role</h4><p>Display Parties who play a Role in one or more Matters</p>"
                                :clearIcon="partyRoleFilterFlag ? true : false"
                                clearIconCallback="clearPartyRoleFilter"
                                _class="col-md-6"
                                :id="id + '-select-party-role'" 
                                :ref="id + '-select-party-role'" 
                                :formRef="id + '-select-party-role'" 
                            />

                        </div>

                    </fieldset>
                    <div class="form-group row">

                        <select-party-entity
                            popOver="<h4>Party Entity</h4><p>Display Parties who are a specific Entity</p>"
                            :clearIcon="partyEntityFilterFlag ? true : false"
                            clearIconCallback="clearPartyEntityFilter"
                            _class="col-md-6"
                            :id="id + '-select-party-entity'" 
                            :ref="id + '-select-party-entity'" 
                            :formRef="id + '-select-party-entity'" 
                        />

                        <select-party-type
                            popOver="<h4>Party Type</h4><p>Display Parties who are a specific Type of Entity</p>"
                            :clearIcon="partyTypeFilterFlag ? true : false"
                            clearIconCallback="clearPartyTypeFilter"
                            _class="col-md-6"
                            :id="id + '-select-party-type'" 
                            :ref="id + '-select-party-type'" 
                            :formRef="id + '-select-party-type'" 
                        />

                    </div>

                </div>

                <div v-show="activeTab === 'Custom'" class="form-tab-content">

                    <custom-filter
                        ref="customFilter"
                        popOver="<h4>Custom SQL Filter</h4>
                        <p>A valid SQL where clause to filter Parties</p>
                        <p><strong>Example:</strong></p>
                        <p>Party.MatterPrefx like 'BRA%'</p>"
                        :popOverContainer="'#' + id"
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
        SelectPartyType: () => import("@pages/parties/SelectPartyType"),
        SelectPartyEntity: () => import("@pages/parties/SelectPartyEntity"),
        SelectPartyRole: () => import("@pages/parties/SelectPartyRole"),
    },

    data() {

        return {
            table: null,
            isClientSelected: '0',
            isClientFilterColumnName: 'isClient',
            partyEntityFilterFlag: false,
            partyEntityFilterKey: null,
            partyEntityFilterColumnName: 'Entity.Description',
            partyTypeFilterFlag: false,
            partyTypeFilterKey: null,
            partyTypeFilterColumnName: 'ParType.Description',
            partyRoleFilterFlag: false,
            partyRoleFilterKey: null,
            partyRoleFilterColumnName: 'Role.Description',
            activeTab: 'General',
            tabs: [
                {
                    pageName: "General",
                    title: "General",
                    iconClass: '',
                    visible: true,
                    active: true,
                },
            ],
        }

    },

    watch: {

        partyEntityFilterFlag: function (newValue) {

            if (newValue === false) {
                this.selectPartyEntity.record = {};
            } else {
                let filter = this.getFilter(this.partyEntityFilterKey);
                if ( filter !== null ) this.selectPartyEntity.record = {description: filter.settings.value};
            }
        },

        partyTypeFilterFlag: function (newValue) {
            if (newValue === false) {
                this.selectPartyType.record = {};
            } else {
                let filter = this.getFilter(this.partyTypeFilterKey);

                if ( filter !== null ) this.selectPartyType.record = {description: filter.settings.value};
            }
        },

        partyRoleFilterFlag: function (newValue) {
            if (newValue === false) {
                this.selectPartyRole.record = {};
            } else {
                this.partyRoleFilterKey = this.getFilterName(this.partyRoleFilterColumnName);
                this.partyRoleFilter = this.getFilter(this.partyRoleFilterKey);

                if ( this.partyRoleFilter !== null ) this.selectPartyRole.record = root.partyRoles.filter(record => record.recordid == this.partyRoleFilter.settings.value)[0];
            }
        },

    },    

    methods: {

        modalOpened() {


            this.setGeneralTab();

            this.$refs.customFilter.initialize(this.table);


            this.isClientFilterKey = this.getFilterName(this.isClientFilterColumnName);
            this.isClientFilter = this.getFilter(this.isClientFilterKey);
            this.isClientSelected = this.isClientFilter ? '1' : '0';


            //Prime the DropDown filters
            this.partyEntityFilterKey = this.getFilterName(this.partyEntityFilterColumnName);
            this.partyEntityFilter = this.getFilter(this.partyEntityFilterKey);
            this.partyEntityFilterFlag = this.partyEntityFilter ? true : false;
            this.selectPartyEntity.record = this.partyEntityFilterFlag ? {description: this.partyEntityFilter.settings.value} : {};

            this.partyTypeFilterKey = this.getFilterName(this.partyTypeFilterColumnName);
            this.partyTypeFilter = this.getFilter(this.partyTypeFilterKey);
            this.partyTypeFilterFlag = this.partyTypeFilter ? true : false;
            this.selectPartyType.record = this.partyTypeFilterFlag ? {description: this.partyTypeFilter.settings.value} : {};

            this.partyRoleFilterKey = this.getFilterName(this.partyRoleFilterColumnName);
            this.partyRoleFilter = this.getFilter(this.partyRoleFilterKey);
            this.partyRoleFilterFlag = this.partyRoleFilter ? true : false;

            if ( this.partyRoleFilterFlag ) {
                this.selectPartyRole.record = root.partyRoles.filter(record => record.recordid == this.partyRoleFilter.settings.value)[0];
            } else {
                this.selectPartyRole.record =  {};
            }

        },


        isClientChanged(newValue) {

            this.deleteFilter(this.isClientFilterKey);

            if (newValue == 1) {

                this.clearPartyRoleFilter();

                this.addFilter(this.isClientFilterColumnName, this.isClientFilterKey, '1', null, 'Equals', null, 'Is Client equals Yes');
            }

            this.reloadTable();

        },


        partyRoleSelected(id, description) {


            this.deleteFilter(this.partyRoleFilterKey);


            if ( this.isClientSelected == '1' ) {
                this.isClientSelected = '0';
                this.isClientChanged();
            }


            this.addFilter(this.partyRoleFilterColumnName, this.partyRoleFilterKey, id, null, 'Equals', null, 'Parties who are ' + description + 's');

            this.partyRoleFilterFlag = true;

            this.reloadTable();

        },

        clearPartyRoleFilter() {

            this.deleteFilter(this.partyRoleFilterKey);

            this.partyRoleFilterFlag = false;

            this.reloadTable();

        },


        partyEntitySelected(id, description) {

            this.deleteFilter(this.partyEntityFilterKey);

            this.addFilter(this.partyEntityFilterColumnName, this.partyEntityFilterKey, description);

            this.partyEntityFilterFlag = true;

            this.reloadTable();

        },

        clearPartyEntityFilter() {

            this.deleteFilter(this.partyEntityFilterKey);

            this.partyEntityFilterFlag = false;

            this.reloadTable();

        },

        partyTypeSelected(id, description) {

            this.deleteFilter(this.partyTypeFilterKey);

            this.addFilter(this.partyTypeFilterColumnName, this.partyTypeFilterKey, description);

            this.partyTypeFilterFlag = true;

            this.reloadTable();

        },

        clearPartyTypeFilter() {

            this.deleteFilter(this.partyTypeFilterKey);

            this.partyTypeFilterFlag = false;

            this.reloadTable();

        },

        setGeneralTab() {

            this.activeTab = 'General';
            this.tabs[0].active = true;

            for (let index = 1; index < this.tabs.length; index++) {

                this.tabs[index].active = false;

            }

        },

    }   
}  
</script>