<template>
<div :class="formControls ? _class : ''">

    <div v-show="formControls">
        
        <label>{{label}}</label>
        <span v-if="popOver">   
            <pop-over :content="popOver" :container="popOverContainer ? popOverContainer : $parent.modal ? '#' + $parent.id : 'body'"/>
        </span>
        <span v-if="clearIcon">
            <i class="fa fa-times-circle cp text-danger ml-1 clear-icon" style="font-size: large" title="Clear the Default Billing Rate" @click="clearIconClicked"></i>
        </span>
        <div class="input-group">
            <select-billing-rate-dropdown
                :id="id + '-select-billing-rate-dropdown'"
                :class="error[0] ? 'multiselect-invalid-feedback' : ''"
                openDirection="below"
                placeholder=""
                :options="$root.billingRates" 
                v-model="record"
                track-by="recordid"
                :tabindex="-1"
                label="description"
                :disabled="readOnly || disabled"
                :allow-empty="false"
                :show-labels="false"
                @input="billingRateSelected"
            >
            <template slot="noResult">No Billing Rates found</template>
            <template slot="noOptions">No Billing Rates found...</template>
            <template slot="option" slot-scope="props">
                <div>
                    <span>{{ props.option.description }}</span>
                </div>
            </template>                            
            </select-billing-rate-dropdown>

            <div v-if="!readOnly" class="input-group-append">
                <button
                    tabindex="-1"
                    v-on:click="selectBillingRate"
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
                    
                    <billing-rate-table
                    :options-button="false"
                    :new-record-button="true"
                    :table-id="id + '-table'"
                    :lazyLoadFlag="true"
                    ref="select-billing-rate-table"
                    :formRef="formRef"
                    />


                </div>

                <div class="modal-footer ">
                    <button class="btn btn-danger form-button" type="button"  v-on:click="hide" title="Cancel selection"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
                </div>

            </div>

        </div>

    </div>

    <!-- <billing-rate-form
        :id="id + '-form'"
        ref="select-billing-rate-form"
    /> -->

</div>
</template>

<script>

import modalTemplate from "@components/modals/modal-template";
import Multiselect from 'vue-multiselect';

export default {

    mixins: [modalTemplate],       

    components: {
        BillingRateTable: () => import("./BillingRateTable"),
        // BillingRateForm: () => import("./BillingRateForm"),
        SelectBillingRateDropdown: Multiselect
    },

    props: {
        clearIconCallback: { type: String, default: 'clearSelectBillingRate' },
        clearIcon: { type: Boolean, default: false },
        title: {
            type: String,
            default: 'Click on the button to select a Billing Rate',
        }, 
        _class: {
            type: String, 
            default: 'col-md-12',
        },
        label: {
            type: String,
            default: 'Billing Rates',
        },
        singular: {
            type: String,
            default: 'Billing Rate',
        },
        plural: {
            type: String,
            default: 'Billing Rates',
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

    mounted () {
        this.$parent.selectBillingRate = this;
    },    

    methods: {

        clearIconClicked() {
            if ( typeof this.$parent[this.clearIconCallback] === 'function') this.$parent[this.clearIconCallback]();
        },

        newRecordButtonClicked() {

            this.$refs['select-billing-rate-form'].table = this.$refs['select-billing-rate-table'];
            this.$refs['select-billing-rate-form'].insertClicked();

        },

        selectBillingRate() {

            this.show();

            this.table.selectTableFlag = true;
            this.table.actionColumnWidth = 12;

            if ( !this.table.table ) setTimeout( this.table.loadDataTable );

        },

        billingRateSelected(selectedRecord) {

            this.record = {
                recordid: selectedRecord.recordid,
                description: selectedRecord.description
            };

            if ( typeof this.$parent.billingRateSelected === 'function') this.$parent.billingRateSelected(selectedRecord.recordid, selectedRecord.description);

            this.hide();

        },        

        selectRecord(id) {

            this.billingRateSelected( this.table.table.row('#' + id).data() );

        },

    },

}  
</script>

