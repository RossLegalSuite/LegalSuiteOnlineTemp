
<template>
    <div class="modal" :id="id">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-color: indianred;">

            <div class="modal-header indianred">
                <h3 class="modal-title"><i class="fa fa-filter mr-2"></i>Filter Items</h3>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="card-body form-tab-body overflow-auto p-3" style="height: 55vh;">

                <form-tabs :tabs="tabs"/>

                <div v-show="activeTab === 'General'" class="form-tab-content">
                    <div class="form-group row">
                        <div class="col-md-12">
                            <b-form-checkbox
                                class="mt-1 mb-1"
                                title="Display items you created"
                                v-model="myRecordsSelected"
                                value="1"
                                unchecked-value="0"
                                @change="myRecordsChanged"
                            >
                            Display My Items
                            </b-form-checkbox>

                        </div>
                    </div>

                    <select-date-filter
                        :id="id + '-date-filter'"
                        :ref="id + '-date-filter'"
                    />


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


                    <div class="row">
                        <div class="col-md-6">

                            <div class="form-group row">
                                <select-doclog-category 
                                    :clearIcon="categoryFilterFlag ? true : false"
                                    clearIconCallback="clearDoclogCategoryFilter"
                                    :id="id + '-select-doclog-category'" 
                                    :ref="id + '-select-doclog-category'" 
                                    :formRef="id + '-select-doclog-category'" 
                                />
                            </div>

                        </div>

                        <div class="col-md-6">

                            <div class="form-group row">
                                <select-doclog-sub-category 
                                    :clearIcon="subCategoryFilterFlag ? true : false"
                                    clearIconCallback="clearDoclogSubCategoryFilter"
                                    :id="id + '-select-doclog-sub-category'" 
                                    :ref="id + '-select-doclog-sub-category'" 
                                    :formRef="id + '-select-doclog-sub-category'" 
                                />
                            </div>

                        </div>
                    </div>

                </div>

                <div v-show="activeTab === 'Custom'" class="form-tab-content">

                    <custom-filter
                        ref="customFilter"
                        popOver="<h4>Custom SQL Filter</h4>
                        <p>A valid SQL <em>where clause</em> to filter the Document Log Items</p>
                        <p><strong>Examples:</strong></p>
                        <p>DocLog.Direction = 2</p>
                        <p>DocLog.Date <= 81234</p>
                        <p>DocLog.EmployeeID = 12 OR DocLog.EmployeeID = 13</p>"
                        :popOverContainer="'#' + id"
                        :lookupLibraryFlag="true"
                        lookupLibraryCategory="Custom string to filter the Document Log Items"
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
        SelectDoclogCategory: () => import("@pages/doclog/SelectDoclogCategory"),
        SelectDoclogSubCategory: () => import("@pages/doclog/SelectDoclogSubCategory"),
    },

    data() {
        return {
            table: null,
            myRecordsSelected: '0',
            myRecordsFilterColumnName: 'employee.name',
            dateFilterColumnName: 'doclog.date',
            descriptionSelected: '',
            descriptionFilterColumnName: 'doclog.description',

            categoryFilterFlag: false,
            categoryFilterColumnName: 'doclogcategory.description',

            subCategoryFilterFlag: false,
            subCategoryFilterColumnName: 'doclogsubcategory.description',
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

    mounted() {
        this.$parent.filterForm = this;
    },

    watch: {

        categoryFilterFlag: function (newValue) {
            if (newValue === false) {
                this.selectDoclogCategory.record = {};
            } else {
                let filter = this.getFilter(this.categoryFilterKey);
                if ( filter !== null ) this.selectDoclogCategory.record = {description: filter.settings.value};
            }
        },

        subCategoryFilterFlag: function (newValue) {
            if (newValue === false) {
                this.selectDoclogSubCategory.record = {};
            } else {
                let filter = this.getFilter(this.subCategoryFilterKey);
                if ( filter !== null ) this.selectDoclogSubCategory.record = {description: filter.settings.value};
            }
        },

    },

    methods: {

        modalOpened() {

            this.setGeneralTab();

            this.$refs.customFilter.initialize(this.table);

            this.primeCommonFilters();

            this.categoryFilterKey = this.getFilterName(this.categoryFilterColumnName);
            this.categoryFilter = this.getFilter(this.categoryFilterKey);
            this.categoryFilterFlag = this.categoryFilter ? true : false;
            this.selectDoclogCategory.record = this.categoryFilterFlag ? {description: this.categoryFilter.settings.value} : {};

            this.subCategoryFilterKey = this.getFilterName(this.subCategoryFilterColumnName);
            this.subCategoryFilter = this.getFilter(this.subCategoryFilterKey);
            this.subCategoryFilterFlag = this.subCategoryFilter ? true : false;
            this.selectDoclogSubCategory.record = this.subCategoryFilterFlag ? {description: this.subCategoryFilter.settings.value} : {};

        },


        doclogCategorySelected( selectedRecord ) {

            this.deleteFilter(this.categoryFilterKey);

            this.addFilter(this.categoryFilterColumnName, this.categoryFilterKey, selectedRecord.description);

            this.categoryFilterFlag = true;

            this.reloadTable();

        },


        clearDoclogCategoryFilter() {

            this.deleteFilter(this.categoryFilterKey);

            this.categoryFilterFlag = false;

            this.reloadTable();

        },

        doclogSubCategorySelected( selectedRecord ) {

            this.deleteFilter(this.subCategoryFilterKey);

            this.addFilter(this.subCategoryFilterColumnName, this.subCategoryFilterKey, selectedRecord.description);

            this.subCategoryFilterFlag = true;

            this.reloadTable();

        },

        clearDoclogSubCategoryFilter() {

            this.deleteFilter(this.subCategoryFilterKey);

            this.subCategoryFilterFlag = false;

            this.reloadTable();

        },


    }   
}  
</script>