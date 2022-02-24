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
            <select-fee-unit-dropdown
                :id="id + '-select-feeunit-dropdown'"
                :class="error[0] ? 'multiselect-invalid-feedback' : ''"
                openDirection="below"
                placeholder=""
                :options="$root.feeUnits" 
                v-model="record"
                track-by="recordid"
                :tabindex="-1"
                label="description"
                :disabled="readOnly || disabled"
                :allow-empty="false"
                :show-labels="false"
                @input="feeUnitSelected"
                :loading="$root.dropdownIsLoading"
                :internal-search="false"
                @search-change="debounceFindFeeUnits"
            >
            <template slot="noResult">No Fee Units found</template>
            <template slot="noOptions">No Fee Units found...</template>
            <template slot="option" slot-scope="props">
                <div>
                    <span>{{ props.option.description }}</span>
                </div>
            </template>                            
            </select-fee-unit-dropdown>

            <div v-if="!readOnly" class="input-group-append">
                <button
                    tabindex="-1"
                    v-on:click="selectFeeUnit"
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
                    <h2 class="modal-title page-title"><i class="fa fa-server mr-2"></i>Select a {{singular}}</h2>
                    <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                </div>

                <div class="modal-body p-3" style="height: 60vh; overflow-y: auto;">
                    
                    <fee-unit-table
                    :options-button="false"
                    :new-record-button="true"
                    :table-id="id + '-table'"
                    :lazyLoadFlag="true"
                    ref="select-feeunit-table"
                    :formRef="formRef"
                    />


                </div>

                <div class="modal-footer ">
                    <button class="btn btn-danger form-button" type="button"  v-on:click="hide" title="Cancel selection"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
                </div>

            </div>

        </div>

    </div>

    <fee-unit-form
        :id="id + '-form'"
        ref="select-feeunit-form"
    />

</div>
</template>

<script>

import modalTemplate from "@components/modals/modal-template";
import { debounce } from 'lodash';
import Multiselect from 'vue-multiselect';

export default {

    mixins: [modalTemplate],       

    components: {
        FeeUnitTable: () => import("./FeeUnitTable"),
        FeeUnitForm: () => import("./FeeUnitForm"),
        SelectFeeUnitDropdown: Multiselect
    },

    props: {
        clearIconCallback: { type: String, default: 'clearSelectFeeUnit' },
        clearIcon: { type: Boolean, default: false },
        title: {
            type: String,
            default: 'Click on the button to select a Fee Unit',
        }, 
        _class: {
            type: String, 
            default: 'col-md-12',
        },
        label: {
            type: String,
            default: 'Unit',
        },
        singular: {
            type: String,
            default: 'Unit',
        },
        plural: {
            type: String,
            default: 'Units',
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
        popOver: { type: String, default:'' },
        popOverContainer: { type: String, default:'' },
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

    created() {
        this.debounceFindFeeUnits = debounce((query) => { this.$root.getFeeUnits(query) }, 500);
    }, 

    mounted () {
        this.$parent.selectFeeUnit = this;
    },    

    methods: {

        clearIconClicked() {
            if ( typeof this.$parent[this.clearIconCallback] === 'function') this.$parent[this.clearIconCallback]();
        },

        newRecordButtonClicked() {

            this.$refs['select-feeunit-form'].table = this.$refs['select-feeunit-table'];
            this.$refs['select-feeunit-form'].insertClicked();

        },

        selectFeeUnit() {

            if ( !this.$root.feeUnits.length && this.formControls) this.$root.getFeeUnits();

            this.show();

            this.table.selectTableFlag = true;
            this.table.actionColumnWidth = 12;

            if ( !this.table.table ) setTimeout( this.table.loadDataTable );

        },

        feeUnitSelected(selectedRecord) {

            if ( typeof this.$parent.feeUnitSelected === 'function') this.$parent.feeUnitSelected(selectedRecord.id, selectedRecord.description);

            this.hide();

        },        

        // Used by CustomFilterForm.vue
        setByDescription(description) {

            axios.post('/feeunits/get',{ description: description })
            .then(response => { this.record = response.data.data[0]; });

        },

        selectRecord(id) {

            axios.post('/feeunits/get',{recordid: id })

            .then(response => {

                this.record = response.data.data[0];

                this.feeUnitSelected(response.data.data[0]);

            })

            .finally(() => {

                this.hide();

            });   

        },

    },

}  
</script>

