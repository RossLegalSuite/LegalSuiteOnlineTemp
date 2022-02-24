<template>



    <div class="modal" :id="id">

        <div class="modal-dialog modal-dialog-centered modal-lg">

            <div class="modal-content" style="border-color:indianred">

                <div class="modal-header indianred">
                    <h2 class="modal-title page-title"><i class="fa fa-file-code-o mr-2"></i>Select a Template</h2>
                    <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                </div>

                <div class="modal-body p-3" style="height: 60vh;  overflow-y: auto;">
                    
                    <select-template-table
                        ref="select-template-table"
                        tableId="global-select-template-table"
                        :newRecordButton="false"
                        formRef="globalSelectTemplate"
                        :lazyLoadFlag="true"
                    />

                </div>

                <div class="modal-footer justify-content-between">
                    <div/>
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

    data() {
        return {
            callingComponent: null,
            type: null,
            source: null,
        };
    },

    methods: {

        load( callingComponent, type, source ) {

            this.callingComponent = callingComponent;

            this.open();

            this.table.selectTableFlag = true;
            this.table.actionColumnWidth = 12;

            this.table.whereRaw = "type = '" + type + "' AND source = '" + source + "'";

            this.type = type;
            this.source = source;

            setTimeout( this.table.loadDataTable );


        },

        selectRecord(id) {

            this.callingComponent.templateSelected(id);

            this.hide();

        },


    },

}  
</script>

