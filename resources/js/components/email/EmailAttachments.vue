<template>

<div class="modal" :id="id">

    <div class="modal-dialog modal-dialog-left modal-lg">

        <div class="modal-content" style="border-color:indianred">

            <div class="modal-header indianred">
                <h2 class="modal-title page-title"><i class="fa fa-server mr-2"></i>Attachments: <span v-html="title"></span></h2>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="modal-body p-3" style="max-height: 75vh; min-height: 50vh; overflow-y: auto;">
                
                <email-attachments-table 
                    :id="id + '-table-modal'" 
                    :tableId="id + '-table'" 
                    :lazyLoadFlag="true"
                    ref="table" 
                />

            </div>

            <div class="modal-footer ">
                <button class="btn btn-danger form-button" type="button"  v-on:click="hide" title="Close this window"><i class="fa fa-times-circle fa-lg mr-2"></i>Close</button>
            </div>

        </div>

    </div>

    <modal-delete :id="id + '-delete-attachment-modal'" ref="delete-attachment-modal" @delete-record="deleteRecord"/>


</div>

</template>

<script>

import modalTemplate from "../modals/modal-template";

export default {

    mixins: [modalTemplate],       

    components: {
        EmailAttachmentsTable: () => import("./EmailAttachmentsTable"),
    },

    data() {
        return {
            title: null,
            table: null,
            deleteRowId: null,
        };
    },

    mounted() {

        // Set this so any parents can refer to it easily
        
        this.$parent.emailAttachments = this;
        
        // Adjusting the columns here because the table is loaded hidden
        let _this = this;

        $('#' + this.id).on('shown.bs.modal', function (e) {

            if ( _this.table && typeof _this.table !== 'undefined') {
                
                if ( _this.table.table && typeof _this.table.table !== 'undefined') {
                    
                    _this.table.table.columns.adjust();

                }
            }
        });


    },

    methods: {

        deleteAttachment(id) {

            this.deleteRowId = id;

            let rowData = this.table.table.row("#" + id).data();

            if ( rowData.defaultFlag === true ) {

                showError('Access denied','<p>You cannot delete ' + rowData.description + '</p><p>It is associated with this email.</p>');

            } else {

                this.$refs['delete-attachment-modal'].callingComponent = this;
                this.$refs['delete-attachment-modal'].description = rowData.description;
                this.$refs['delete-attachment-modal'].show();

            }

        },


        deleteRecord() {

            this.table.table.row('#' + this.deleteRowId).remove().draw();

            this.deleteRowId = null;

        },


    },    

}  
</script>

