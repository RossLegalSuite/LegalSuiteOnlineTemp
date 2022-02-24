<template>

<div class="modal" :id="id">

    <div class="modal-dialog modal-dialog-left modal-lg">

        <div class="modal-content" style="border-color:steelblue">

            <div class="modal-header steelblue">
                <h2 class="modal-title page-title"><i class="fa fa-server mr-2"></i>Select Fee Codes</h2>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="modal-body p-3" style="height: 70vh; overflow-y: auto;">

                    <select-fee-codes-table 
                        :tableId="id + '-fee-codes-table'" 
                        :lazyLoadFlag="true" 
                        :tagging="true" 
                        ref="select-fee-code-table" 
                        :formRef="formRef"
                    />

            </div>

            <div class="modal-footer justify-content-between">

                <div>
                    <modal-table-filter-footer/>
                </div>

                <div>

                    <button v-show="selectedRows.length || selectedAllFlag" class="btn btn-success form-button mr-2" type="button" @click="selectClicked" :title="'Select ' + selectedRows.length + ' tagged Fee Code' + (selectedRows.length > 1 ? 's' : '')"><i class="fa fa-check-circle fa-lg mr-2"></i>
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
        SelectFeeCodesTable: () => import("./FeeCodeTable"),
    },
    props: {
        formRef: String,
    },

    data() {
        return {
            table: null,
            selectedRows: [],
            selectedAllFlag: false,
        };
    },

    mounted () {
        this.$parent.selectFeeCodes = this;
    },    

    methods: {


        selectFeeCodes( feeSheetId ) {

            this.open();

            this.table.selectTableFlag = true;
            this.table.setButtonTitle = 'Select this Fee Code';
            this.table.setButtonText = 'Select';
            this.table.setButtonFunction = 'selectRecord';
            this.table.actionColumnWidth = 12;

            // Prime the v-select
            // Note: This is being "watched" so it will load the table as well
            this.table.feeSheetId = feeSheetId;


        },

        selectRecord(id) {

            this.hide();

            this.$parent.feeCodesSelected([id]);


        },

        selectClicked() {

            this.hide();

            this.table.getTagged()

            .then( ( taggedRecords ) => {

                this.$parent.feeCodesSelected(taggedRecords);

                resetTagged(this);

            }).catch( (error) => {
                showError('Error',error)
            });




        },

    },

}  
</script>

