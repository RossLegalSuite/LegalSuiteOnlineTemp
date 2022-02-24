<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-md' : ''">

        <div :class="modal ? 'modal-content steelblue-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header steelblue' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="record.readOnly ? true : false">{{record.description}} [View Only]</span>                            
                            <span v-else-if="!editing">Party Role will be Added</span>
                            <span v-else-if="viewing">Party Role</span>
                            <span v-else>Party Role will be Changed</span>
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
                    :readOnly="record.code === 'client' || record.code === 'contact'"
                    _class="col-md-4" 
                    popOver="<h4>Code</h4>
                    <p>The code is used to uniquely identify this Party Role.</p>
                    <p>This can be used in Document Assembly, for example, to construct sections of a Document for different Parties.</p>"
                    :popOverContainer="'#' + id"
                    v-model="record.code"
                    name="code"
                    label="Code"
                    :error="errors.code"/>
                </div>

                <div class="form-group row">
                    <text-input 
                        _class="col-md-12" 
                        popOver="<h4>Description</h4>
                        <p>A general description of this Role.</p>"
                        :popOverContainer="'#' + id"
                        @change="setPlural" 
                        v-model="record.description"
                        name="description"
                        label="Description"
                        :error="errors.description"
                    />
                </div>

                <div class="form-group row">

                    <text-input 
                        _class="col-md-6"
                        popOver="<h4>Plural</h4>
                        <p>This is used in Document Templates to loop through Parties with this Role using {#plural} where <em>plural</em> is the value entered here.</p>
                        <p><strong>Note:</strong>It is not changed otherwise any Documents using the {#plural} syntax will no longer work and each Document will need to be modified.</p>
                        "
                        :popOverContainer="'#' + id"
                        v-model="record.plural"
                        name="plural"
                        label="Plural"
                        :error="errors.plural"
                    />
                </div>

            </div>

            <form-buttons :editing="editing" :viewing="viewing" :preventDelete="record.code === 'client' ? true: false" record="Party Role" @ok-clicked="okClicked" @cancel-clicked="closeForm" @delete-clicked="deleteClicked"/>

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
        resource: {type: String, default: 'Party Roles' },
    },

    methods: {

        editRecord(id) {

            axios.post('/party_roles/get',{recordid: id})

            .then(response => {

                this.record = response.data.data[0];

                this.initFormData();

            });

        },

        initNewRecord() {

            this.record = {
                description: null,
                code: null,
                plural: null,
            };

            this.initFormData();

            setTimeout(() => $('#' + this.id + ' textarea[name="description"]').focus() );

        },

        initFormData() {
            
            this.displayForm();
            
            setTimeout(() => $('#' + this.id + ' input[name="description"]').focus() );

        },

        setPlural() {

            if (this.editing) return;
            
            if (!this.record.plural) {
                this.record.plural = toCamelCase(this.record.description);
                this.record.plural = this.record.plural.toLowerCase() + 's';
                $('input[name="plural"]').val(this.record.plural);
            }

        },

        okClicked() {

            axios.post('/party_roles/store', this.record)
            
            .then(response => {

                if (response.data.errors) {

                    if (response.data.errors.general) { showError( 'Error', response.data.errors.general[0]);} else { this.errors = response.data.errors; }

                } else {

                    this.errors = {};

                    this.highlightTableRow(response.data.id, response.data.code);

                }

            }).catch(error => { showError('Error saving ' + this.table.singular, error); });

        },

        highlightTableRow( id, code ) {

            axios.post('/party_roles/getTablePosition', { code: code })

            .then(response => {

                this.table.jumpToRow(id, response.data);
                
                this.closeForm();

            });

        },     

        
    },
}

</script>
