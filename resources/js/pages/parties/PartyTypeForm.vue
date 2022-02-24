<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-md' : ''">

        <div :class="modal ? 'modal-content steelblue-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header steelblue' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="record.readOnly ? true : false">{{record.description}} [View Only]</span>                            
                            <span v-else-if="!editing">Party Type will be Added</span>
                            <span v-else-if="viewing">Party Type</span>
                            <span v-else>Party Type will be Changed</span>
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
                    <p>The code is used to uniquely identify this Party Type.</p>
                    <p>This can be used in Document Assembly, for example, to construct sections of a Document for different Parties.</p>"
                    :popOverContainer="'#' + id"
                    v-model="record.code"
                    name="code"
                    label="Code"
                    :error="errors.code"/>


                    <radio-buttons 
                    _class="col-md-8" 
                    popOver="<h4>Type</h4><p>This is used to indicate the indicate the legal status of a Party.</p>
                    <p>Juristic persons are corporate or institutional organizations like companies or trusts while natural persons are male or female adults or minors.</p>"
                    :popOverContainer="'#' + id"
                    :record="record" 
                    column="type" 
                    :buttons="[
                        {value:'N', text: 'Person', title: 'The Type is a Natural Person'},
                        {value:'J', text: 'Jursistic', title: 'The Type is a Juristic Person'},
                    ]" 
                    name="type" 
                    label="Type" 
                    :error="errors.type"
                    />
                </div>

                <div class="form-group row">
                    <text-input _class="col-md-12" v-model="record.description" name="description" label="Description" :error="errors.description"/>
                </div>

            </div>

            <form-buttons :editing="editing" :viewing="viewing" record="Party Type" @ok-clicked="okClicked" @cancel-clicked="closeForm" @delete-clicked="deleteClicked"/>

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
        resource: {type: String, default: 'Party Types' },
    },

    methods: {

        editRecord(id) {

            axios.post('/party_types/get',{recordid: id})

            .then(response => {

                this.record = response.data.data[0];

                this.initFormData();

            });

        },

        initNewRecord() {

            this.record = {
                description: null,
                type: 'J',
                code: null
            };

            this.initFormData();

            setTimeout(() => $('#' + this.id + ' textarea[name="description"]').focus() );

        },

        initFormData() {
                
            this.displayForm();

            setTimeout(() => $('#' + this.id + ' input[name="description"]').focus() );


        },


        okClicked() {

            axios.post('/party_types/store', this.record)
            
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

            axios.post('/party_types/getTablePosition', { code: code })

            .then(response => {

                this.table.jumpToRow(id, response.data);
                
                this.closeForm();

            });

        },     

        
    },
}

</script>
