<template>

<div class="modal" :id="id">

    <div class="modal-dialog modal-dialog-left modal-lgr">

        <div class="modal-content" style="border-color:indianred">

            <div class="modal-header indianred">
                <h2 class="modal-title page-title"><i class="fa fa-server mr-2"></i>Select Matters</h2>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="modal-body p-3" style="height: 60vh; overflow-y: auto;">

                <select-matters-table 
                    :tableId="id + '-matters-table'" 
                    :lazyLoadFlag="true" 
                    :tagging="true" 
                    :ref="id + '-select-matters-table'" 
                    :formRef="id + '-select-matters-table'"
                />


            </div>

            <div class="modal-footer justify-content-between">

                <div>
                    <modal-table-filter-footer/>
                </div>

                <div>

                    <button v-show="selectedRows.length || selectedAllFlag" class="btn btn-success form-button mr-2" type="button" @click="selectClicked" :title="'Select ' + selectedRows.length + ' tagged Matter' + (selectedRows.length > 1 ? 's' : '')"><i class="fa fa-check-circle fa-lg mr-2"></i>
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
        SelectMattersTable: () => import("./SelectMattersTable"),
    },

    data() {
        return {
            table: null,
            selectedRows: [],
            selectedAllFlag: false,
        };
    },

    mounted () {
        this.$parent.selectMatters = this;
    },    

    methods: {

        selectMatters() {

            this.open();

            this.table.setButtonTitle = 'Select this Matter';
            this.table.setButtonText = 'Select';
            this.table.setButtonFunction = 'selectRecord';
            this.table.actionColumnWidth = 12;

            this.table.tableOptions = {

                createdRow: ( row, data ) => {

                    if (data.backgroundColor !== '#FFF' && data.textColor !== '#000' ) {
                        $(row).css({"color": data.textColor, "background-color": data.backgroundColor}).addClass("custom-colors");
                    }

                },
            };

            this.table.loadDataTable();

        },

        selectClicked() {

            this.hide();

            // Return empty array if all are selected

            if ( this.selectedAllFlag ) {

                    this.table.setUserFilters();

                    this.$parent.mattersSelected([], this.table);
                
                } else {
                    
                    this.$parent.mattersSelected(this.selectedRows);

            }

            this.selectedAllFlag = false;
            this.selectedRows = [];

        },

    },

}  
</script>

