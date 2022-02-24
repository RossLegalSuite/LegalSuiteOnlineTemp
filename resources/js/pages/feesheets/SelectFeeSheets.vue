<template>

<div class="modal" :id="id">

    <div class="modal-dialog modal-dialog-left modal-lg">

        <div class="modal-content" style="border-color:indianred">

            <div class="modal-header indianred">
                <h2 class="modal-title page-title"><i class="fa fa-server mr-2"></i>Select Fee Sheet(s)</h2>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="modal-body p-3" style="height: 60vh; overflow-y: auto;">

                    <select-fee-sheets-table 
                        :tableId="id + '-fee-sheets-table'" 
                        :lazyLoadFlag="true" 
                        :tagging="true" 
                        ref="select-fee-sheet-table" 
                        :formRef="formRef"
                    />

            </div>

            <div class="modal-footer justify-content-between">

                <div>
                    <modal-table-filter-footer/>
                </div>

                <div>

                    <button v-show="selectedRows.length || selectedAllFlag" class="btn btn-success form-button mr-2" type="button" @click="selectClicked" :title="'Select ' + selectedRows.length + ' tagged Fee Sheet' + (selectedRows.length > 1 ? 's' : '')"><i class="fa fa-check-circle fa-lg mr-2"></i>
                        Select
                        <span class="badge badge-danger ml-2">{{ selectedAllFlag ? 'All' : selectedRows.length}}</span>
                    </button>

                    <button class="btn btn-danger form-button" type="button" @click="hide" title="Cancel selection"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>

                </div>
            </div>

        </div>

    </div>

</div>

</template>

<script>

import modalTemplate from "@components/modals/modal-template";

export default {

    mixins: [modalTemplate],

    components: {
        SelectFeeSheetsTable: () => import("./SelectFeeSheetsTable"),
    },
    props: {
        formRef: String,
    },

    data() {
        return {
            table: null,
            preSelectedRows: [],
            selectedRows: [],
            selectedAllFlag: false,
        };
    },

    mounted () {
        this.$parent.selectFeeSheets = this;
    },    

    methods: {

        selectFeeSheets( feeSheetId, feeSheetCode ) {

            this.open();

            this.table.setButtonTitle = 'Select this Fee Sheet';
            this.table.setButtonText = 'Select';
            this.table.setButtonFunction = 'selectRecord';

            // Needs work - changed how tagging works (see table-template.js)
            this.preSelectedRows = ['' + feeSheetId];

            this.table.loadDataTable( this.highlightFeeSheet(feeSheetId, feeSheetCode) );

        },

        highlightFeeSheet(feeSheetId, feeSheetCode) {

            axios.post('/feesheets/getTablePosition', { code: feeSheetCode })

            .then(response => {

                this.table.jumpToRow(feeSheetId, response.data);

            });


        },

        selectRecord(id) {

            this.hide();

            this.$parent.feeSheetsSelected([id]);


        },

        selectClicked() {

            this.hide();

            // Return empty array if all are selected
            if ( this.selectedAllFlag ) {

                //this.table.setUserFilters();

                this.$parent.feeSheetsSelected([], this.table);
            
            } else {
                
                this.$parent.feeSheetsSelected(this.selectedRows);

            }

            this.selectedAllFlag = false;
            this.selectedRows = [];

        },

    },

}  
</script>

