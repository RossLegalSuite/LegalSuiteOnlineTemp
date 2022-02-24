<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered' : ''">

        <div :class="modal ? 'modal-content steelblue-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header steelblue' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="!editing">Document Set will be Added</span>
                            <span v-else-if="viewing">Document Set</span>
                            <span v-else>Document Set will be Changed</span>
                        </h3>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="card-body overflow-auto p-3" :style="modal ? 'min-height:40vh' : ''">

                <div class="form-group row">
                    <text-input :_class="modal && !editing ? 'col-md-12' : 'col-md-8'" v-model="record.description" name="description" label="Description" :error="errors.description"/>
                </div>

            </div>

            <form-buttons :editing="editing" record="Document Set" @ok-clicked="okClicked" @cancel-clicked="closeForm" @delete-clicked="deleteClicked"/>

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
        resource: {type: String, default: 'Document Sets' },
    },

    methods: {

        editRecord(id) {

            axios.post('/docgen/get/' + id)

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

            axios.post('/docgen/get/' + id)
            
            .then(response => {

                if ( typeof this.$parent.documentSetSelected === 'function') this.$parent.documentSetSelected(response.data.data[0]);

            });

        },

        okClicked() {

            axios.post('/docgen/store', this.record)
            
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

            axios.post('/generic/getTablePosition', { description: description, tableName: 'docgen' })

            .then(response => {

                this.table.jumpToRow(id, response);
                
                this.closeForm();

            });

        },     

    },
}

</script>
