
<template>
    <div class="modal" :id="id">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-color: indianred;">

            <div class="modal-header indianred">
                <h3 class="modal-title"><i class="fa fa-filter mr-2"></i>Filter Reminders</h3>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="modal-body p-3" style="height: 50vh; overflow-y: auto;">

                <div class="form-group row">
                    <div class="col-md-12">
                        <b-form-checkbox
                            class="mt-1 mb-1"
                            title="Display Reminders assigned to you"
                            v-model="myRecordsSelected"
                            value="1"
                            unchecked-value="0"
                            @change="myRecordsChanged"
                        >
                        Display My Reminders
                        </b-form-checkbox>

                    </div>
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


                <select-date-filter
                    :id="id + '-created-date-filter'"
                    :ref="id + '-created-date-filter'"
                    label="Created Date"
                />

                <select-date-filter
                    :id="id + '-target-date-filter'"
                    :ref="id + '-target-date-filter'"
                    label="Target Date"
                />

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
            myRecordsSelected: '0',
            myRecordsFilterColumnName: 'target.name',
            createdDateFilterColumnName: 'date',
            targetDateFilterColumnName: 'targetDate',

            statusRadioButtonRecord: { value: null},
            statusFilterColumnName: 'completedDate',
            statusArray: [{ text:'All', value:'All'}, { text:'Completed', value:'1'}, { text:'Incomplete', value:'0'}],
        }
    },

    mounted() {
        this.$parent.filterForm = this;
    },    

    methods: {

        modalOpened() {

            this.primeCommonFilters();

            // Prime the Created Date Filter 
            let createdDateFilterKey = this.getFilterName(this.createdDateFilterColumnName);
            this.$refs[this.id + '-created-date-filter'].primeFilter(createdDateFilterKey, this.createdDateFilterColumnName);

            // Prime the Target Date Filter 
            let targetDateFilterKey = this.getFilterName(this.targetDateFilterColumnName);
            this.$refs[this.id + '-target-date-filter'].primeFilter(targetDateFilterKey, this.targetDateFilterColumnName);



        },


    }   
}  
</script>