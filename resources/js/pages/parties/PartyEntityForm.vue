<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-md' : ''">

        <div :class="modal ? 'modal-content steelblue-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header steelblue' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="record.readOnly ? true : false">{{record.description}} [View Only]</span>                            
                            <span v-else-if="!editing">Party Entity will be Added</span>
                            <span v-else-if="viewing">Party Entity</span>
                            <span v-else>Party Entity will be Changed</span>
                        </h3>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="card-body overflow-auto p-3" style="min-height: 40vh">

                <div class="form-group row">

                    <text-input 
                    v-if="editing"
                    _class="col-md-4" 
                    popOver="<h4>Code</h4>
                    <p>The code is used to uniquely identify this Entity.</p>
                    <p>This can be used in Document Assembly, for example, to construct sections of a Document for different Parties.</p>"
                    :popOverContainer="'#' + id"
                    v-model="record.code"
                    name="code"
                    label="Code"
                    :error="errors.code"/>

                    <text-input 
                    _class="col-md-4" 
                    popOver="<h4>Party Color</h4>
                        <p>You can set a <em>color</em> for an Entity.</p>
                        <p>Parties will then be displayed in this color which makes it easy to identify Parties of different Entity Types.</p>"
                    :popOverContainer="'#' + id"
                    v-model="record.backgroundColor"
                    name="backgroundColor"
                    label="Background Color"
                    :error="errors.backgroundColor"/>

                </div>

                <div class="form-group row">

                    <radio-buttons 
                    _class="col-md-12" 
                    popOver="<h4>Type</h4><p>The Entity Type is used to indicate the legal status of a Party.</p>
                    <p>Juristic persons are corporate or institutional organizations like companies or trusts while natural persons are male or female adults or minors.</p>"
                    :popOverContainer="'#' + id"
                    :record="record" 
                    column="type" 
                    :buttons="[
                        {value:'N', text: 'Person', title: 'The Entity is a Natural Person'},
                        {value:'J', text: 'Jursistic', title: 'The Entity is a Juristic Person'},
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


            <form-buttons :editing="editing" :viewing="viewing" record="Party Entity" @ok-clicked="okClicked" @cancel-clicked="closeForm" @delete-clicked="deleteClicked"/>

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
        resource: {type: String, default: 'Party Entities' },
    },


    mounted() {

        var elem = $('#' + this.id + ' input[name="backgroundColor"]')[0];
        this.backgroundColorPicker = new Huebee( elem );
        
        this.backgroundColorPicker.on( 'change', ( color, hue, sat, lum ) => {
            this.record.backgroundColor = color;
            this.record.textColor = $('#' + this.id + ' input[name="backgroundColor"]').css('color') === 'rgb(34, 34, 34)' ? '#222' : '#FFF';
        });

    },

    data() {
        return {
            descriptionInput: null,
            backgroundColorPicker: null,
        }
    },

    methods: {

        editRecord(id) {

            axios.post('/party_entities/get',{recordid: id})

            .then(response => {

                this.record = response.data.data[0];

                this.initFormData();

            });

        },

        initNewRecord() {

            this.record = {
                description: null,
                type: 'J',
                textColor: '#000',
                backgroundColor: '#FFF',
                code: null
            };

            this.initFormData();

            setTimeout(() => $('#' + this.id + ' textarea[name="description"]').focus() );

        },

        initFormData() {
                
            this.displayForm();

            this.descriptionInput = $('#' + this.id + ' input[name="description"]');

            setTimeout(() => this.descriptionInput.focus() );


        },


        okClicked() {

            axios.post('/party_entities/store', this.record)
            
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

            axios.post('/party_entities/getTablePosition', { code: code })

            .then(response => {

                this.table.jumpToRow(id, response.data);
                
                this.closeForm();

            });

        },     

        copyBackgroundColor() {

            console.log('copyBackgroundColor');

        },

        pasteBackgroundColor() {

            console.log('pasteBackgroundColor');

        },

        
    },
}

</script>
