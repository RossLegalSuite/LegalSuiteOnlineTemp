
<template>
    <div class="modal" :id="id">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-color: indianred;">

            <div class="modal-header indianred">
                <h3 class="modal-title"><i class="fa fa-filter mr-2"></i>Filter Matter Parties</h3>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="card-body form-tab-body overflow-auto p-3" style="height: 55vh;">

                <form-tabs :tabs="tabs"/>

                <div v-show="activeTab === 'General'" class="form-tab-content">

                    <div class="row">

                        <div class="col-md-6">

                            <div class="form-group row">
                                <select-party
                                    :clearIcon="partyFilterFlag ? true : false"
                                    clearIconCallback="clearPartyFilter"
                                    :id="id + '-select-party'" 
                                    :ref="id + '-select-party'" 
                                    :formRef="id + '-select-party'"
                                    label="Party" 
                                />
                            </div>


                        </div>

                        <div class="col-md-6">
                            <div class="form-group row">
                                <select-matter
                                    :clearIcon="matterFilterFlag ? true : false"
                                    clearIconCallback="clearMatterFilter"
                                    :id="id + '-select-matter'" 
                                    :ref="id + '-select-matter'" 
                                    :formRef="id + '-select-matter'"
                                    label="Matter" 
                                />
                            </div>
                        </div>

                    </div>

                    <div class="form-group row">
                        <select-role
                            :clearIcon="roleFilterFlag ? true : false"
                            clearIconCallback="clearRoleFilter"
                            :id="id + '-select-role'" 
                            :ref="id + '-select-role'" 
                            :formRef="id + '-select-role'" 
                            _class="col-md-6"
                        />
                    </div>

                </div>

                <div v-show="activeTab === 'Custom'" class="form-tab-content">

                    <custom-filter
                        ref="customFilter"
                        popOver="<h4>Custom SQL Filter</h4>
                        <p>A valid SQL <em>where clause</em> to filter the Matter Parties</p>
                        <p><strong>Examples:</strong></p>
                        <p>MatParty.Reference LIKE '%abcdef%'</p>
                        <p>MatParty.RoleID = 2 OR MatParty.RoleID = 3</p>"
                        :popOverContainer="'#' + id"
                        :lookupLibraryFlag="true"
                        lookupLibraryCategory="Custom string to filter the Matter Parties"
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
        SelectRole: () => import("@pages/parties/SelectPartyRole"),
        SelectMatter: () => import("@pages/matters/SelectMatter"),
        SelectParty: () => import("@pages/parties/SelectParty"),
    },

    data() {
        return {
            table: null,
            activeTab: 'General',
            partyFilterFlag: false,
            partyFilterColumnName: 'party.matterprefix',

            matterFilterFlag: false,
            matterFilterColumnName: 'matter.fileref',

            roleFilterFlag: false,
            roleFilterColumnName: 'role.description',
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

        partyFilterFlag: function (newValue) {
            if (newValue === false) {
                this.selectParty.record = '';
            } else {
                let filter = this.getFilter(this.partyFilterKey);
                if ( filter !== null ) this.selectParty.partyName = filter.settings.value;
            }
        },

        matterFilterFlag: function (newValue) {
            if (newValue === false) {
                this.selectMatter.matter = { fileref: '', description: ''};
            } else {
                let filter = this.getFilter(this.matterFilterKey);
                if ( filter !== null ) this.selectMatter.matter = {fileref: filter.settings.value, description: ''};
            }
        },


        roleFilterFlag: function (newValue) {
            if (newValue === false) {
                this.selectPartyRole.record = {};
            } else {
                let filter = this.getFilter(this.roleFilterKey);
                if ( filter !== null ) this.selectPartyRole.record = {description: filter.settings.value};
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

            this.partyFilterKey = this.getFilterName(this.partyFilterColumnName);
            this.partyFilter = this.getFilter(this.partyFilterKey);
            this.partyFilterFlag = this.partyFilter ? true : false;
            this.selectParty.partyName = this.partyFilterFlag ? this.partyFilter.settings.value : '';

            this.matterFilterKey = this.getFilterName(this.matterFilterColumnName);
            this.matterFilter = this.getFilter(this.matterFilterKey);
            this.matterFilterFlag = this.matterFilter ? true : false;
            this.selectMatter.matter = this.matterFilterFlag ? {fileref: this.matterFilter.settings.value, description: ''} : { fileref: '', description: ''};


            this.roleFilterKey = this.getFilterName(this.roleFilterColumnName);
            this.roleFilter = this.getFilter(this.roleFilterKey);
            this.roleFilterFlag = this.roleFilter ? true : false;
            this.selectPartyRole.record = this.roleFilterFlag ? {description: this.roleFilter.settings.value} : {};

        },

        partySelected(selectedRecord) {

            this.deleteFilter(this.partyFilterKey);

            this.addFilter(this.partyFilterColumnName, this.partyFilterKey, htmlDecode(selectedRecord.matterprefix));

            this.partyFilterFlag = true;

            this.reloadTable();

        },

        clearPartyFilter() {

            this.deleteFilter(this.partyFilterKey);

            this.partyFilterFlag = false;

            this.reloadTable();

        },

        matterSelected(selectedRecord) {

            this.deleteFilter(this.matterFilterKey);

            this.addFilter(this.matterFilterColumnName, this.matterFilterKey, htmlDecode(selectedRecord.fileref));

            this.matterFilterFlag = true;

            this.reloadTable();

        },

        clearMatterFilter() {

            this.deleteFilter(this.matterFilterKey);

            this.matterFilterFlag = false;

            this.reloadTable();

        },


        partyRoleSelected(id, description) {

            this.deleteFilter(this.roleFilterKey);

            this.addFilter(this.roleFilterColumnName, this.roleFilterKey, description);

            this.roleFilterFlag = true;

            this.reloadTable();

        },

        clearRoleFilter() {

            this.deleteFilter(this.roleFilterKey);

            this.roleFilterFlag = false;

            this.reloadTable();

        },


    }   
}  
</script>