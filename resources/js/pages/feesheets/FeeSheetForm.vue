<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lg' : ''">

        <div :class="modal ? 'modal-content steelblue-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header steelblue' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="!editing">Fee Sheet will be Added</span>
                            <span v-else-if="viewing">Fee Sheet</span>
                            <span v-else>Fee Sheet will be Changed</span>
                        </h3>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="card-body overflow-auto p-3">

                <div class="form-group row">

                    <text-input :_class="editing ? 'col-md-8' : 'col-md-12'" v-model="record.description" name="description" label="Description" :error="errors.description"/>

                </div>

            </div>

            <div class="modal-footer justify-content-between">
                <div>

                    <button v-show="editing" class="btn btn-danger form-button mr-2" type="button" @click="deleteClicked" title="Delete this Fee Code">
                        <i class="fa fa-times-circle fa-lg mr-2"></i>Delete
                    </button>

                </div>

                <div>

                    <button class="btn btn-success form-button mr-3" @click="okClicked" type="button" title="Save the Fee Code"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>

                    <button class="btn btn-danger form-button" @click="closeForm" type="button" title="Exit without saving"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>

                </div>
            </div>

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
        resource: {type: String, default: 'Fee Sheets' },
    },
    
    methods: {

        editRecord(id) {

            axios.post('/generic/get',{
                id: id,
                tableName: 'feesheet',
            })

            .then(response => {

                this.record = response.data.data[0];
                this.record.id = response.data.data[0].recordid;

                this.initFormData();

            });

        },

        initNewRecord() {

            this.record = {
                description: null,
            };

            this.initFormData();

            setTimeout(() => $('#' + this.id + ' textarea[name="description"]').focus() );

        },

        initFormData() {
                
            this.displayForm();

            setTimeout(() => $('#' + this.id + ' input[name="description"]').focus() );

        },

       
        selectRecord(id) {

            axios.post('/generic/get',{recordid: id, tableName: 'feesheet'}).then(response => {

                if ( typeof this.$parent.feesheetSelected === 'function') this.$parent.feesheetSelected(response.data.data[0]);

            });

        },


        okClicked() {

            axios.post('/generic/store', {...this.record, tableName: 'feesheet'})
            
            .then(response => {

                if (response.data.errors) {

                    if (response.data.errors) showError( 'Error', response.data.errors);


                } else {

                    this.errors = {};

                       this.highlightTableRow(response.data.data[0].recordid, response.data.data[0].description);

                }

            }).catch(error => { showError('Error saving ' + this.table.singular, error); });

        },

        highlightTableRow( id, description ) {

            axios.post('/generic/getTablePosition', { description: description, tableName: 'feesheet' })

            .then(response => {

                this.table.jumpToRow(id, response);
                
                if (!this.editing) {

                    this.editClicked(id);

                } else {

                    this.closeForm();

                }

            });

        },     

    },
}

</script>
