<template>
<div :class="formControls ? _class : ''">
        
    <div v-show="formControls">
        
        <label>{{label}}</label>
        <span v-if="popOver">   
            <pop-over :content="popOver" :container="popOverContainer ? popOverContainer : $parent.modal ? '#' + $parent.id : 'body'"/>
        </span>
        <span v-if="clearIcon">
            <i class="fa fa-times-circle cp text-danger ml-1 clear-icon" style="font-size: large" title="Clear" @click="clearIconClicked"></i>
        </span>
        <div class="input-group">
            <select-country-dropdown
                :id="id + '-select-country-dropdown'"
                :class="error[0] ? 'multiselect-invalid-feedback' : ''"
                openDirection="below"
                placeholder=""
                :options="$root.countries" 
                v-model="record"
                track-by="recordid"
                :tabindex="-1"
                label="description"
                :disabled="readOnly || disabled"
                :allow-empty="false"
                :show-labels="false"
                @input="countrySelected"
            >
            <template slot="noResult">No Countries found</template>
            <template slot="noOptions">No Countries found...</template>
            <template slot="option" slot-scope="props">
                <div>
                    <span>{{ props.option.description }}</span>
                </div>
            </template>                            
            </select-country-dropdown>

            <div v-if="!readOnly" class="input-group-append">
                <button
                    tabindex="-1"
                    v-on:click="selectCountry"
                    type="button"
                    :title="'Select a ' + singular"
                    :class="error[0] ? 'btn btn-danger multiselect-invalid-feedback' : 'btn btn-primary'"
                ><i class="fa fa-cog"></i></button>
            </div>
        </div>
        <div v-html="error[0]" class="invalid-feedback"></div>


    </div>

    <div class="modal" :id="id">

        <div class="modal-dialog modal-dialog-left">

            <div class="modal-content" style="border-color:indianred">

                <div class="modal-header indianred">
                    <h2 class="modal-title page-title"><i class="fa fa-server mr-2"></i>Select a Country</h2>
                    <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                </div>

                <div class="modal-body p-3" style="height: 60vh; overflow-y: auto;">
                    
                    <country-table
                    :options-button="false"
                    :new-record-button="false"
                    :table-id="id + '-table'"
                    :lazyLoadFlag="true"
                    ref="select-country-table"
                    :form-ref="formRef"
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

</div>
</template>

<script>

import modalTemplate from "@components/modals/modal-template";
import Multiselect from 'vue-multiselect';

export default {

    mixins: [modalTemplate],       

    components: {
        CountryTable: () => import("./CountryTable"),
        SelectCountryDropdown: Multiselect
    },

    props: {
        clearIconCallback: { type: String, default: 'clearSelectCountry' },
        clearIcon: { type: Boolean, default: false },
        callback: {
            type: String,
            default: 'countrySelected',
        }, 
        parentName: {
            type: String,
            default: 'selectCountry',
        }, 
        title: {
            type: String,
            default: 'Click on the button to select an Country',
        }, 
        _class: {
            type: String, 
            default: 'col-md-12',
        },
        label: {
            type: String,
            default: 'Country',
        },
        popOver: { type: String, default:'' },
        popOverContainer: { type: String, default:'' },
        singular: {
            type: String,
            default: 'Country',
        },
        plural: {
            type: String,
            default: 'Countries',
        },
        formRef: String,
        formControls: {
            type: Boolean,
            default: true,
        },
        readOnly: {
            type: Boolean,
            default: false,
        },
        error: {
            type: Array,
            default: function () {
                return [null]
            },
        },
    },

    data() {
        return {
            table: null,
            record: null,
            disabled: null,
        };
    },

    mounted () {
        this.$parent[this.parentName] = this;
    },    

    methods: {

        clearIconClicked() {
            if ( typeof this.$parent[this.clearIconCallback] === 'function') this.$parent[this.clearIconCallback]();
        },

        selectCountry() {

            this.show();

            this.table.selectTableFlag = true;

            this.table.actionColumnWidth = 12;

            if ( !this.table.table ) setTimeout( this.table.loadDataTable );


        },

        countrySelected(selectedRecord) {

            // Override default one set in form-template.js
            if ( typeof this.$parent.customCountrySelected === 'function') {

                this.$parent.customCountrySelected(selectedRecord.recordid, selectedRecord.description);

            } else if ( typeof this.$parent[this.callback] === 'function') {

                this.$parent[this.callback](selectedRecord.recordid, selectedRecord.description);

            }

        },        


        selectRecord(id) {

            this.countrySelected( this.table.table.row('#' + id).data() );

            this.hide();

        },

    },

}  
</script>

