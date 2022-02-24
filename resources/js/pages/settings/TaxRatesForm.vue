<template>

<section>

    <div class="modal" :id="id">

        <div class="modal-dialog modal-dialog-centered modal-lg">

            <div class="modal-content" style="border-color:steelblue">

                <div class="modal-header steelblue">
                    <h2 class="modal-title page-title"><i class="fa fa-calculator mr-2"></i>
                    <span v-if="!editing">Rate will be Added</span>
                    <span v-else-if="viewing">Rate</span>
                    <span v-else >Rate will be Changed</span>
                    </h2>
                    <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                </div>

                <div class="modal-body" style="min-height: 50vh;">
                    
                    <div class="row">
                        <div class="col-lg-12">

                            <div class="form-group row">

                                <text-input _class="col-md-8" v-model="record.description" name="description" label="Description" :error="errors.description"/>

                            </div>             


                            <fieldset class="mt-1"><legend>Components</legend>

                                <tax-rate-components-table 
                                    ref="tax-rate-components-table" 
                                    form-ref="tax-rate-components-form" 
                                    table-id="tax-rate-components-table"
                                    :lazy-load-flag="true"
                                />

                            </fieldset>

                            <!-- <div class="form-group row">

                                <text-input input-group="%" _class="col-md-3" input-class="form-input-number" v-model="record.rate" name="rate" label="Rate" :error="errors.rate" />

                            </div> -->

                        </div>

                    </div>

                </div>

                <form-buttons :editing="editing" :viewing="viewing" record="Tax Rate" @ok-clicked="okClicked" @cancel-clicked="hide" @delete-clicked="deleteClicked" />

            </div>

        </div>

    </div>


</section>

</template>

<script>

import modalTemplate from "@components/modals/modal-template";

import FormTemplate from "@pages/form-template";

export default {

    mixins: [FormTemplate, modalTemplate],  

    components: {
        TaxRateComponentsTable: () => import("./TaxRateComponentsTable"),
    },

    props: {
        resource: {type: String, default: 'Tax Rates' },
    },

    methods: {

        editRecord(id) {

            axios.post('/taxrates/get',{recordid: id})

            .then(response => {
                
                this.record = response.data.data[0];

                this.show();

                // **************************************
                // Load the tax rate components table
                // **************************************
                let taxRateComponentsTable = this.$refs['tax-rate-components-table'];

                taxRateComponentsTable.parentId = this.record.id;

                taxRateComponentsTable.tableOptions = {

                    scrollY : '30vh',

                    drawCallback: () => {
                        this.calculateTotalTaxRate();
                    },                   

                };

                taxRateComponentsTable.loadDataTable();

                setTimeout(function(){
                    $('input[name="description"]').focus();
                });

            });

        },

        calculateTotalTaxRate() {

            console.log('calculateTotalTaxRate');
        },

        initNewRecord() {

            // ??? this.table = this.$parent.$refs["tax-rates-table"];

            this.record = {
                description: null,
            };

            this.show();

            setTimeout(function(){
                $('input[name="description"]').focus();
            });

        },


        okClicked() {
            
            axios.post('/taxrates/store', this.record)
            
            .then(response => {

                if (response.data.errors) {

                    if (response.data.errors.general) { showError( 'Error', response.data.errors.general[0]);} else { this.errors = response.data.errors; }

                } else {

                    this.errors = {};

                    this.highlightTableRow(response.data.id, response.data.fromDate);
                        
                }

            }).catch(error => { showError('Error saving ' + this.table.singular, error); });

        },

        highlightTableRow( id, fromDate) {


            axios.post('/taxrates/getTablePosition', {
                fromDate: fromDate,
            })

            .then(response => {

                this.table.jumpToRow(id, response.data);
                
                this.closeForm();

            });

        },     
        
    },


}

</script>
