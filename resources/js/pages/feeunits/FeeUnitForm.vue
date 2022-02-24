<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered' : ''">

        <div :class="modal ? 'modal-content steelblue-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header steelblue' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="!editing">Unit will be Added</span>
                            <span v-else>Unit will be Changed</span>
                        </h3>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="card-body overflow-auto p-3">

                <div class="form-group row">

                    <text-input 
                        v-if="editing"
                        _class="col-md-4" 
                        popOver="<h4>Code</h4>
                        <p>The code is used to uniquely identify this Unit.</p>"
                        :popOverContainer="'#' + id"
                        v-model="record.code"
                        name="code"
                        label="Code"
                        :error="errors.code"
                    />

                    <text-input 
                    :_class="editing ? 'col-md-8' : 'col-md-12'" 
                    v-model="record.description" 
                    @change="setSingularAndPlural"
                    name="description" 
                    label="Description"
                    :error="errors.description"/>

                </div>

                <div class="form-group row">

                    <text-input 
                        _class="col-md-6" 
                        popOver="<h4>Singular</h4>
                        <p>A description of one of these Units.</p>"
                        :popOverContainer="'#' + id"
                        v-model="record.singular"
                        name="singular"
                        label="Singular"
                        :error="errors.singular"
                    />

                    <text-input 
                        _class="col-md-6" 
                        popOver="<h4>Plural</h4>
                        <p>A description of more than one of these Units.</p>"
                        :popOverContainer="'#' + id"
                        v-model="record.plural"
                        name="plural"
                        label="Plural"
                        :error="errors.plural"
                    />


                </div>

            </div>

            <form-buttons :editing="editing" :viewing="viewing" :readOnly="record.readOnly ? true: false" record="Unit" @ok-clicked="okClicked" @cancel-clicked="closeForm" @delete-clicked="deleteClicked"/>

        </div>
    </div>


</div>

</template>    

<script>

import FormTemplate from "@pages/form-template";
import modalTemplate from "@components/modals/modal-template";

export default {
    
    mixins: [FormTemplate, modalTemplate],

    props: {
        resource: {type: String, default: 'Fee Units' },
        uniqueId: String
    },
    
    methods: {

        editRecord(id) {

            axios.post('/feeunits/get',{recordid: id})

            .then(response => {

                this.record = response.data.data[0];

                this.initFormData();

            });

        },

        initNewRecord() {

            this.record = {
                code: null,
                description: null,
                singular: null,
                plural: null,
                timeBasedFlag: false,
                minutesPerUnit: null,
            };

            this.initFormData();

        },

        initFormData() {
                
            this.displayForm();

            setTimeout(() => $('#' + this.id + ' input[name="description"]').focus() );

        },


        selectRecord(id) {

            axios.post('/feeunits/get',{recordid: id}).then(response => {

                if ( typeof this.$parent.feeUnitSelected === 'function') this.$parent.feeUnitSelected(response.data.data[0]);

            });

        },


        setSingularAndPlural() {

            if (this.editing) return;
            
            if (!this.record.singular) {
                
                this.record.singular = this.record.description.toLowerCase();
                $('input[name="singular"]').val(this.record.singular);

                this.record.plural = this.record.singular + 's';
                $('input[name="plural"]').val(this.record.plural);

            }
        },


        okClicked() {

            axios.post('/feeunits/store', this.record)
            
            .then(response => {

                if (response.data.errors) {

                    if (response.data.errors.general) { showError( 'Error', response.data.errors.general[0]);} else { this.errors = response.data.errors; }

                } else {

                    this.$root.getFeeUnits();

                    this.errors = {};

                    this.highlightTableRow(response.data.id, response.data.code);

                }

            }).catch(error => { showError('Error saving ' + this.table.singular, error); });

        },

        highlightTableRow( id, code ) {

            axios.post('/feeunits/getTablePosition', { code: code })

            .then(response => {

                this.table.jumpToRow(id, response.data);
                
                this.closeForm();

            });

        },     

    },
}

</script>
