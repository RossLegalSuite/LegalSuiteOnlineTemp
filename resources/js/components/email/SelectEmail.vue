<template>

<div class="modal" :id="id">

    <div class="modal-dialog modal-dialog-left modal-lgr">

        <div class="modal-content blue-border">

            <div class="modal-header blue-bg">
                <h2 class="modal-title page-title"><i class="fa fa-server mr-2"></i>Select Email Address</h2>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="modal-body p-3" style="height: 70vh; overflow-y: auto;">
                
                <select-email-table 
                    :table-id="id + '-table'" 
                    :lazyLoadFlag="true" 
                    ref="select-email-table" 
                />

            </div>

            <div class="modal-footer justify-content-between">
                <div>
                </div>

                <div>
                    <button v-show="selectedRows.length || selectedAllFlag" class="btn btn-success form-button mr-2" type="button"  @click="addSelectedEmails" :title="'Add the selected Email Address' + (selectedRows.length > 1 ? 'es' : '')"><i class="fa fa-check-circle fa-lg mr-2"></i>
                        Add
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

import modalTemplate from "../modals/modal-template";

export default {

    mixins: [modalTemplate],       

    props: {
        selectRecordsCallback: String,
    },

    data() {
        return {
            table: null,
            selectedRows: [],
            selectedAllFlag: false,
        };
    },

    methods: {

        load() {

            this.open();

            this.table.formComponent = this.id; // The same as ref!!

            this.table.tagTableFlag = true;

            this.table.selectTableFlag = true;
            this.table.actionColumnWidth = 12;

            this.selectedRows = [];

            this.table.tableOptions = { tableBottom: 80  };

            this.table.loadDataTable();

        },     


        selectRecord(id) {

            let selectedEmails = [];

            let data = this.table.table.row( '#' + id ).data();

            selectedEmails.push({
                id: data.id,
                emailAddress: htmlDecode(data.number),
                name: htmlDecode(data.partyname),
            });


            this.$parent[this.selectRecordsCallback](selectedEmails);

            this.hide();

        },


        addSelectedEmails() {

            let selectedEmails = [];

            this.selectedRows.forEach(id => {

                let data = this.table.table.row( '#' + id ).data();

                selectedEmails.push({
                    id: data.id,
                    emailAddress: htmlDecode(data.number),
                    name: htmlDecode(data.partyname),
                });

            });

            this.$parent[this.selectRecordsCallback](selectedEmails);

            this.hide();

        },

    },    

}  
</script>

