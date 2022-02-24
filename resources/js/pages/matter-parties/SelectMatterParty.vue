<template>

    <div class="modal" :id="id">

        <div class="modal-dialog modal-dialog-left modal-lg">

            <div class="modal-content" style="border-color:indianred">

                <div class="modal-header indianred">
                    <h2 class="modal-title page-title"><i class="fa fa-server mr-2"></i>Select a Matter Party</h2>
                    <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                </div>

                <div class="modal-body p-3" style="height: 60vh; overflow-y: auto;">
                    
                    <select-matter-party-table 
                        :tableId="id + '-matter-party-table'" 
                        :lazyLoadFlag="true" 
                        :ref="id + '-select-matter-party-table'" 
                        :formRef="id + '-select-matter-party-table'"
                    />

                </div>

                <div class="modal-footer justify-content-between">

                    <div>
                        <modal-table-filter-footer/>
                    </div>

                    <div>
                        <button class="btn btn-danger form-button" type="button"  v-on:click="hide" title="Cancel selection"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
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
        SelectMatterPartyTable: () => import("./SelectMatterPartiesTable"),
    },

    props: {
        formRef: String,
    },

    data() {
        return {
            table: null,
            employee: null,
            disabled: null,
        };
    },

    mounted () {
        this.$parent.selectMatterParty = this;
    },    

    methods: {

        selectMatterParty() {

            this.open();

            this.table.setButtonTitle = 'Select this Party';
            this.table.setButtonText = 'Select';
            this.table.setButtonFunction = 'selectRecord';
            this.table.actionColumnWidth = 12;

            this.table.loadDataTable();

        },



    },

}  
</script>

