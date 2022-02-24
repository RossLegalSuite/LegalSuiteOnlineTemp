<template>

<div class="modal" :id="id">

    <div class="modal-dialog modal-dialog modal-lg">

        <div class="modal-content" style="border-color:indianred">

            <div class="modal-header indianred">
                <h2 class="modal-title page-title"><i class="fa fa-file-pdf-o mr-2"></i>Assembled Documents</h2>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="modal-body p-3" style="height: 60vh; overflow-y: auto;">

                <div class="boxed p-3" style="height:65vh">

                    <view-assembled-table 
                        :table-id="id + '-view-assembled-table'" 
                        :lazyLoadFlag="true" 
                        :tagging="true"
                        :formRef="id + '-view-assembled-table'"
                        :ref="id + '-view-assembled-table'"
                    />

                </div>

            </div>

            <div class="modal-footer justify-content-between">

                <div></div>

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

export default {

    mixins: [modalTemplate],

    components: {
        ViewAssembledTable: () => import("./DocumentLogTable"),
    },

    data() {
        return {
            table: null,
            selectedRows: [],
            selectedAllFlag: false,
            selectedAllRows: false,
        };
    },

    mounted () {
        this.$parent.viewAssembled = this;
    },    

    methods: {

        load( batchId ) {

            this.open();

            this.selectedAllRows = false;

            this.table.where = { column: 'batchId', value: batchId };

            this.table.selectTableFlag = true;

            this.table.setButtonTitle = 'View this Document';
            this.table.setButtonText = 'View';
            this.table.setButtonClass = 'primary';
            this.table.actionColumnWidth = 10;

            this.table.tableOptions = {

                tableBottom: 80,

                drawCallback: (tableId, api) => {
                    
                    if ( !this.selectedAllRows ) {
                        
                        this.selectedAllRows = true;

                        this.table.toggleTaggedRows(this);
                    }


                }
            }

            this.table.loadDataTable();

        },

    },

}  
</script>

