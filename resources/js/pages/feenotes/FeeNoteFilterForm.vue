
<template>
    <div class="modal" :id="id">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-color: indianred;">

            <div class="modal-header indianred">
                <h3 class="modal-title"><i class="fa fa-filter mr-2"></i>Filter Fee Notes</h3>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="card-body form-tab-body overflow-auto p-3" style="height: 55vh;">

                <form-tabs :tabs="tabs"/>

                <div v-show="activeTab === 'General'" class="form-tab-content">

                    <div class="form-group row">
                        <div class="col-md-12">
                            <b-form-checkbox
                                class="mt-1 mb-1"
                                title="Display Fee Notes allocated to you"
                                v-model="myRecordsSelected"
                                value="1"
                                unchecked-value="0"
                                @change="myRecordsChanged"
                            >
                            Display My Fee Notes
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

                    <div class="form-group row">
                        <radio-buttons 
                            ref="status-radio-button"
                            label="Status" 
                            :record="statusRadioButtonRecord" 
                            column="value" 
                            name="value" 
                            :buttons="statusArray" 
                            @change="statusRadioButtonChanged"
                        />
                    </div>

                    <amount-filter
                        :id="id + '-amount-filter'"
                        :ref="id + '-amount-filter'"
                    />

                </div>

                <div v-show="activeTab === 'Custom'" class="form-tab-content">

                    <custom-filter
                        ref="customFilter"
                        popOver="<h4>Custom SQL Filter</h4>
                        <p>A valid SQL <em>where clause</em> to filter the Fee Notes</p>
                        <p><strong>Examples:</strong></p>
                        <p>FeeNote.VatRate = 'E' AND FeeNote.Description LIKE '%Stamp%'</p>
                        <p>FeeNote.Date <= 81234</p>
                        <p>FeeNote.EmployeeID = 12 OR FeeNote.EmployeeID = 13</p>"
                        :popOverContainer="'#' + id"
                        :lookupLibraryFlag="true"
                        lookupLibraryCategory="Custom string to filter the Fee Notes"
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

    data() {
        return {
            table: null,
            myRecordsSelected: '0',
            myRecordsFilterColumnName: 'employee.name',
            dateFilterColumnName: 'feenote.date',
            descriptionSelected: '',
            descriptionFilterColumnName: 'feenote.description',
            amountFilterColumnName: 'feenote.amount',

            statusRadioButtonRecord: { value: null},
            statusFilterColumnName: 'feenote.postedflag',
            statusArray: [ { text:'Posted', value:'1'}, { text:'Unposted', value:'0'}],
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

    methods: {

        modalOpened() {

            this.setGeneralTab();

            this.$refs.customFilter.initialize(this.table);

            this.primeCommonFilters();

        },

    }   
}  
</script>