<template>
<div :id="id">

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
            :label="filterRecord.method === 'Between' ? 'From' : '&nbsp;'"
            :error="fromAmountError"
            ref="fromAmount"
        />

        <text-input
            v-show="filterRecord.method === 'Between'"
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
</template>

<script>
export default {

    props: {
        id: String,
        label: {
            type: String,
            default:'Amount',
        },
    },

    data() {

        return {
            filterName: null,
            filterColumn: null,
            showApplyButton: false,
            currentMethod: 'Greater than',
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

            if ( newValue === 'Between' ) {
                this.$refs.fromAmount.setLabel = 'From';
            } else {
                this.$refs.fromAmount.setLabel = '&nbsp;';
            }

            if (!this.filterRecord.fromAmount) {
                this.showApplyButton = false;
                return;
            }

            if ( newValue === 'Between' ) {

                if (!this.filterRecord.toAmount) {
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

            if ( this.filterRecord.method === 'Between' ) {

                if (!this.filterRecord.toAmount) {
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

            if (!this.filterRecord.fromAmount) {
                this.showApplyButton = false;
                return;
            }

            this.showApplyButton = true;

        },

    },


    methods: {

        primeFilter(filterName, filterColumn) {

            this.filterName = filterName;
            this.filterColumn = filterColumn;

            this.showApplyButton = false;

            this.fromAmountError = [];
            this.toAmountError = [];

            this.methodDropDown = this.$refs['select-amount-method'];

            let amountFilter = this.$parent.getFilter(filterName);

            if ( amountFilter ) {

                this.methodDropDown.clearIcon = true;

                this.currentMethod = amountFilter.settings.method;

                this.filterRecord.fromAmount = this.currentFromAmount = amountFilter.settings.fromAmount;
                this.filterRecord.toAmount = this.currentToAmount = amountFilter.settings.toAmount;

            } else {

                this.methodDropDown.clearIcon = false;

                this.currentMethod = 'Greater than';

                this.filterRecord.fromAmount = this.currentFromAmount = null;
                this.filterRecord.toAmount = this.currentToAmount = null;

            }

            this.filterRecord.method = this.currentMethod;

            this.methodDropDown.selectedMethod = this.filterRecord.method; 


            this.methodDropDown.loadComponent();

        },

        applyAmountFilter() {

            this.toAmountError = [];
            this.fromAmountError = [];

            if (!this.filterRecord.fromAmount) {
                this.fromAmountError.push('Please enter an Amount');
                return;
            }

            if ( this.filterRecord.method === 'Between' ) {

                if (!this.filterRecord.toAmount) {
                    this.toAmountError.push('Please enter an Amount');
                    return;
                }

                if ( parseFloat(this.filterRecord.fromAmount) > parseFloat(this.filterRecord.toAmount) ) {
                    this.fromAmountError.push('The From Amount cannot be greater than the To Amount');
                    return;
                }

            }


            this.showApplyButton = false;

            this.methodDropDown.clearIcon = true;

            this.$parent.deleteFilter(this.filterName);

            this.$parent.addFilter(this.filterColumn, this.filterName, this.filterRecord.fromAmount, this.filterRecord.toAmount, this.filterRecord.method);

            this.$parent.table.setUserFilters();

            this.$parent.table.table.ajax.reload();

            //this.filterRecord.fromAmount = this.currentFromAmount = null;
            //this.filterRecord.toAmount = this.currentToAmount = null;

        },

        clearFilter() {

            this.fromAmountError = [];
            this.toAmountError = [];

            this.methodDropDown.clearIcon = false;

            this.$parent.deleteFilter(this.filterName);

            this.$parent.table.setUserFilters();

            this.$parent.table.table.ajax.reload();

            this.filterRecord.fromAmount = this.currentFromAmount = null;
            this.filterRecord.toAmount = this.currentToAmount = null;

        },


    }


}
</script>

