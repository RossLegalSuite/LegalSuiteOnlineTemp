
<template>
    <div class="modal" :id="id">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-color: indianred;">

            <div class="modal-header indianred">
                <h3 class="modal-title"><i class="fa fa-filter mr-2"></i>{{title}}</h3>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="modal-body p-3" style="height: 33vh; overflow-y: auto;">

                <div class="form-group row">

                    <select-amount-method 
                        _class="col-md-5" 
                        parentRecord="filterRecord"
                        :id="id + '-select-amount-method'" 
                        ref="select-amount-method"
                        :label="label"
                    />

                    <text-input
                        _class="col-md-2"
                        type="number"
                        input-class="form-input-number" 
                        v-model="filterRecord.fromAmount"
                        name="fromAmount"
                        :label="currentMethod === 'Between' ? 'From' : '&nbsp;'"
                        :error="fromAmountError"
                    />

                    <text-input
                        v-show="currentMethod === 'Between'"
                        _class="col-md-2"
                        type="number"
                        input-class="form-input-number" 
                        v-model="filterRecord.toAmount"
                        name="toAmount"
                        label="To"
                        :error="toAmountError"
                    />

                    <div class="col-md-3">

                        <button 
                            style="margin-top: 1.8rem"
                            type="button" class="btn btn-success btn-sm"
                            v-show="showApplyButton"
                            title="Apply this filter"
                            @click="applyAmountFilter">
                            <i class="fa fa-plus-circle mr-2"></i>Apply
                        </button>

                    </div>

                </div>

            </div>

            <div class="modal-footer justify-content-between">
                <div>
                </div>
                <div>
                    <button class="btn btn-success form-button mr-2" type="button" @click="okClicked" title="Continue"><i class="fa fa-check-circle fa-lg mr-2"></i>Print</button>
                    <button class="btn btn-danger form-button" type="button" @click="hide" title="Abort"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
                </div>
            </div>

            </div>
        </div>
    </div>
</template>

<script>

import modalTemplate from "@components/modals/modal-template";

export default {

    mixins: [modalTemplate],

    props: {
        callbackMethod: String,
        title: {
            type: String,
            default:'Filter Amount',
        },
        label: {
            type: String,
            default:'Amount',
        },
    },


    data() {
        return {
            showApplyButton: false,
            currentMethod: 'Fredddd!!!',
            currentFromAmount: null,
            currentToAmount: null,
            filterRecord: {
                method: null,
                fromAmount: null,
                toAmount: null,
            },
            fromAmountError: [],
            toAmountError: [],

        }
    },

    computed: {

        filterMethod() {
            return this.filterRecord.method;
        },

        filterFromAmount() {
            return this.filterRecord.fromAmount;
        },

        filterToAmount() {
            return this.filterRecord.toAmount;
        },

    },

    watch: {

        filterMethod: function (newValue) {

            if ( newValue === this.currentMethod ) return;

            this.currentMethod = newValue;

            if (!this.filterFromAmount) {
                this.showApplyButton = false;
                return;
            }

            if ( newValue === 'Between' ) {

                if (!this.filterToAmount) {
                    this.showApplyButton = false;
                    return;
                }

            }

            this.showApplyButton = true;


        },

        filterFromAmount: function (newValue) {

            if ( newValue === this.currentFromAmount ) return;

            this.currentFromAmount = newValue;

            if (!newValue) {
                this.showApplyButton = false;
                return;
            }

            if ( this.currentMethod === 'Between' ) {

                if (!this.filterToAmount) {
                    this.showApplyButton = false;
                    return;
                }

            }

            this.showApplyButton = true;

        },

        filterToAmount: function (newValue) {

            if ( newValue === this.currentToAmount ) return;

            this.currentToAmount = newValue;

            if (!newValue) {
                this.showApplyButton = false;
                return;
            }

            if (!this.filterFromAmount) {
                this.showApplyButton = false;
                return;
            }

            this.showApplyButton = true;

        },

    },

    mounted() {
        this.$parent.filterAmountForm = this;
    },    

    methods: {

        modalOpened() {

            this.showApplyButton = true;

            this.fromAmountError = [];
            this.toAmountError = [];

            this.methodDropDown = this.$refs['select-amount-method'];

            this.filterRecord.fromAmount = this.currentFromAmount = '0';
            this.filterRecord.toAmount = this.currentToAmount = null;

            this.currentMethod = null;
            //this.currentMethod = 'Greater than';
            //this.filterRecord.method = this.currentMethod;

            //this.methodDropDown.selectedMethod = this.filterRecord.method; 
            this.methodDropDown.selectedMethod = 'Greater than'; 

            
            this.methodDropDown.loadComponent();

        },

        applyAmountFilter() {

            //Doing this so the filterDescription is not populated if okClicked
            if (!this.currentMethod) this.currentMethod = 'Greater than';

            //console.log('applyAmountFilter this.currentMethod',this.currentMethod);

            this.toAmountError = [];
            this.fromAmountError = [];

            if (!this.filterFromAmount) {
                this.fromAmountError.push('Please enter an Amount');
                return;
            }

            if ( this.currentMethod === 'Between' ) {

                if (!this.filterToAmount) {
                    this.toAmountError.push('Please enter an Amount');
                    return;
                }

                if ( parseFloat(this.filterFromAmount) > parseFloat(this.filterToAmount) ) {
                    this.fromAmountError.push('The From Amount cannot be greater than the To Amount');
                    return;
                }

            }

            this.showApplyButton = false;

            this.okClicked();

        },

        okClicked() {

            this.hide();

            if ( typeof this.$parent[this.callbackMethod] === 'function') {
                
                this.$parent[this.callbackMethod](this.currentMethod, this.filterFromAmount, this.filterToAmount);

            }

        }

    }   
}  
</script>