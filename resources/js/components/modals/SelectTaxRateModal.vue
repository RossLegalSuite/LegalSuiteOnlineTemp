<template>
    <div class="modal" :id="id">

        <div class="modal-dialog modal-dialog-centered">

            <div class="modal-content" style="border-color:indianred">

                <div class="modal-header indianred">
                    <h2 class="modal-title page-title"><i class="fa fa-server mr-2"></i>Select a {{$root.control.salesTaxType}} Rate</h2>
                    <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                </div>

                <div class="modal-body p-3" style="height: 60vh; overflow-y: auto;">
                    
                    <tax-rates-table
                        :optionsButton="true"
                        :tableId="id + '-select-tax-rates-table'"
                        formRef="globalSelectTaxRate"
                        ref="tax-rates-table"
                        :newRecordButton="false"
                        :lazyLoadFlag="true"
                    />

                </div>

                <div class="modal-footer ">
                    <button class="btn btn-danger form-button" type="button"  v-on:click="hide" title="Cancel selection"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
                </div>

            </div>

        </div>

    </div>
</template>

<script>

import modalTemplate from "./modal-template";

export default {

    mixins: [modalTemplate],
    
    components: {
        TaxRatesTable: () => import("@pages/settings/TaxRatesTable"),
    },

    mounted() {
        this.$parent.selectTaxRate = this;
    },

    data() {
        return {
            callback: null,
        }
    },

    methods: {

        selectRecord(id) {

            axios.post('/taxrates/get',{recordid: id })

            .then(response => {

                if ( this.callback && typeof this.callback.taxRateSelected === 'function' ) {

                    this.callback.taxRateSelected(response.data.data[0]);

                }

            })

            .finally(() => {

                this.hide();

            });   

        },

    },
}
</script>