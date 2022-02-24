<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lg' : ''">

        <div :class="modal ? 'modal-content indianred-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header indianred' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="!editing">Fee Item will be Added</span>
                            <span v-else>Fee Item will be Changed</span>
                        </h3>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="card-body form-tab-body overflow-auto p-3" :style="modal ? 'min-height:65vh' : ''">

                <form-tabs :tabs="tabs"/>

                <div v-show="activeTab === 'General'" class="form-tab-content">

                    <div class="form-group row">
                        <text-input 
                        _class="col-md-12"
                        v-model="record.description"
                        name="description"
                        label="Description"
                        :error="errors.description"
                    />

                    </div>

                    <div class="form-group row">

                        <radio-buttons 
                            popOver="<h4>Type</h4>
                            <p>A Fee Item can create Fee Notes as well as Disbursements.</p>
                            <p>Indicate here whether a Fee or a Disbursement must be created by this item.</p>"
                            :popOverContainer="'#' + id"
                            _class="col-md-6"
                            :record="record"
                            column="type"
                            :buttons="[{value:'Fee', text: 'Fee'},{value:'Disbursement', text: 'Disbursement'}]"
                            name="type"
                            label="Type"
                            :error="errors.type"
                        />


                    </div>


                    <div v-if="unitsDescription" class="row" style="margin-top: -0.75rem;">
                        <div class="col-md-4" style="text-align: right;">
                            {{unitsDescription}}
                        </div>
                    </div>

                </div>

                <div v-show="activeTab === 'Limits'" class="form-tab-content">

                    <div class="form-group row">

                        <div class="col-md-4">
                            <label>From Date</label>
                            <pop-over :container="'#' + id" content="
                            <h4>From Date</h4>
                            <p>This Fee Item will be inserted if the Fee Note date is greater than or equal to this date.</p>
                            "/>

                            <div class="input-group">
                                <date-picker 
                                    @dp-change="hideFromDatePicker" 
                                    ref="fromDatePickerComponent" 
                                    v-model="record.fromDate" 
                                    :config="$root.datePickerOptions"
                                />
                                <div class="input-group-append">
                                    <button
                                        tabindex="-1"
                                        type="button"
                                        title="Click here to select a date"
                                        v-on:click="toggleFromDatePicker"
                                        class="btn btn-primary"
                                    ><i class="fa fa-calendar"></i>
                                    </button>
                                </div>
                            </div>
                            <div v-if="errors.fromDate" v-html="errors.fromDate[0]" class="invalid-feedback"></div>
                        </div>

                        <div class="col-md-4">
                            <label>To Date</label>
                            <pop-over :container="'#' + id" content="
                            <h4>To Date</h4>
                            <p>This Fee Item will be inserted if the Fee Note date is less than or equal to this date.</p>
                            "/>
                            <div class="input-group">
                                <date-picker 
                                    @dp-change="hideToDatePicker" 
                                    ref="toDatePickerComponent" 
                                    v-model="record.toDate" 
                                    :config="$root.datePickerOptions"
                                />
                                <div class="input-group-append">
                                    <button
                                        tabindex="-1"
                                        type="button"
                                        title="Click here to select a date"
                                        v-on:click="toggleToDatePicker"
                                        class="btn btn-primary"
                                    ><i class="fa fa-calendar"></i>
                                    </button>
                                </div>
                            </div>
                            <div v-if="errors.toDate" v-html="errors.toDate[0]" class="invalid-feedback"></div>
                        </div>

                    </div>

                    <div class="form-group row">

                        <text-input 
                            _class="col-md-4"
                            popOver="<h4>From Amount</h4>
                            <p>This Fee Item will be inserted if the <em>quantum</em> of the Matter is greater than or equal to this amount.</p>"
                            :popOverContainer="'#' + id"
                            type="number" 
                            input-class="form-input-number" 
                            v-model="record.fromAmount" 
                            name="fromAmount" 
                            label="From Amount" 
                            :error="errors.fromAmount"
                        />

                        <text-input 
                            _class="col-md-4"
                            popOver="<h4>To Amount</h4>
                            <p>This Fee Item will be inserted if the <em>quantum</em> of the Matter is less than or equal to this amount.</p>"
                            :popOverContainer="'#' + id"
                            type="number" 
                            input-class="form-input-number" 
                            v-model="record.toAmount" 
                            name="toAmount" 
                            label="To Amount" 
                            :error="errors.toAmount"
                        />

                    </div>


                </div>

                <div v-show="activeTab === 'Units'" class="form-tab-content">

                    <div class="form-group row">

                        <div class="col-md-12">

                            <b-form-checkbox
                                :id="id + '-use-units-flag'"
                                v-model="record.unitsFlag"
                                @change="toggleUnitDescription"
                                name="useUnitsFlag"
                                value="1"
                                unchecked-value="0"
                                >
                                Use units
                            </b-form-checkbox>

                        </div>
                    </div>

                    <div v-show="record.unitsFlag == 1" class="form-group row">
                        <select-fee-unit
                            _class="col-md-8"
                            :id="id + '-select-unit'"
                            popOver="<h4>Units</h4>
                            <p>When debiting a Fee (or Disbursement), the amount may be a variable amount, i.e. it depends on the number of units (e.g. pages drafted or minutes spent drafting a document).</p>
                            <p>You can specify the units here and the actual Amount will be calculated by multiplying the <em>per unit</em> Amount by the number of Units.</p>"
                            :popOverContainer="'#' + this.id"
                            title="The units used by this Fee Item"
                            :ref="id + '-select-unit'" 
                            :formRef="id + '-select-unit'"
                            :error="errors.unitsId"
                        />

                        <text-input 
                            _class="col-md-4"
                            popOver="<h4>Factor</h4>
                            <p>In some cases, the units may be a multiple of a larger unit. 
                            For example, a folio is typically 100 words. If you wanted to debit per folio, but only know how many <em>words</em> were in a document, 
                            you could create a Unit called <strong>Folio</strong>, 
                            with the <em>singular</em> and <em>plural</em> as <strong>word</strong> and <strong>words</strong>.</p>
                            <p>You would then set the <em>Factor</em> to 100 and the Fee Item will then prompt the user for <em>the number of words</em> 
                            and multiply the Amount by the number of words divided by 100 when creating the Fee (or Disbursement).</p>"

                            :popOverContainer="'#' + id"
                            type="number" 
                            input-class="form-input-number" 
                            v-model="record.unitsFactor" 
                            name="unitsFactor" 
                            label="Factor" 
                            :error="errors.unitsFactor"
                        />

                    </div>

                    <div v-show="record.unitsFlag == 1" class="form-group row">

                        <text-input 
                            _class="col-md-4"
                            popOver="<h4>Maximum Amount</h4>
                            <p>The amount of the Fee Item cannot be greater than this amount.</p>"
                            :popOverContainer="'#' + id"
                            type="number" 
                            input-class="form-input-number" 
                            v-model="record.maximumAmount" 
                            name="maximumAmount" 
                            label="Maximum Amount" 
                            :error="errors.maximumAmount"
                        />

                    </div>


                </div>


            </div>

            <form-buttons :editing="editing" :viewing="viewing" :readOnly="record.readOnly ? true: false" record="Fee Item" @ok-clicked="okClicked" @cancel-clicked="closeForm" @delete-clicked="deleteClicked"/>

        </div>
    </div>


</div>

</template>    

<script>

import FormTemplate from "@pages/form-template";
import modalTemplate from "@components/modals/modal-template";

export default {
    
    mixins: [FormTemplate, modalTemplate],

    components: {
        SelectFeeUnit: () => import("@pages/feeunits/SelectFeeUnit"),
    },

    props: {
        resource: {type: String, default: 'Fee Items' },
    },

    data() {
        return {
            amount: 0,
            taxAmount: 0,
            totalAmount: 0,
            amountString: '',
            taxAmountString: '',
            totalAmountString: '',
            taxRatePercentage: 0,
            salesTaxDescription: '&nbsp;',
            unitsDescription: '',
            activeTab: 'General',
            tabs: [
                {
                    pageName: "General",
                    title: "Details",
                    iconClass: '',
                    visible: true,
                    active: true,
                },
                {
                    pageName: "Limits",
                    title: "Limits",
                    iconClass: '',
                    visible: true,
                    active: false,
                },
                {
                    pageName: "Units",
                    title: "Units",
                    iconClass: '',
                    visible: true,
                    active: false,
                },
            ],

        }
    },

    methods: {

        editRecord(id) {

            axios.post('/feeitems/get',{recordid: id})

            .then(response => {

                this.record = response.data.data[0];

                this.unitsDescription = 'per ' + this.record.unitsDescription;

                this.initFormData();

            });

        },

        initNewRecord( feeCodeId ) {

            this.unitsDescription = '';

            this.activeTab = 'General';
            this.tabs[0].active = true;
            this.tabs[1].active = false;
            this.tabs[2].active = false;

            this.record = {
                feeCodeId: feeCodeId,
                description: null,
                sorter: null,
                amount: null,
                taxAmount: null,
                taxRateId: this.record.taxRateId ? this.record.taxRateId : root.control.salesTaxRateId,
                type: this.record.type || 'Fee',
                fromDate: null,
                toDate: null,
                fromAmount: null,
                toAmount: null,
                maximumAmount: null,
                unitsFlag: '0',
                unitsId: null,
                unitsFactor: '1',

            };

            this.initFormData();

        },

        initFormData() {

            if ( !this.$root.feeUnits.length) this.$root.getFeeUnits();

            this.initSelectTaxRate();

            if ( this.editing ) {

                this.selectFeeUnit.record = {
                    id: this.record.unitsId,
                    description: htmlDecode(this.record.unitsDescription),
                };

            } else {

                this.selectFeeUnit.record = {};

            }



            this.displayForm();

            setTimeout(() => $('#' + this.id + ' input[name="description"]').focus() );

        },

        selectRecord(id) {

            axios.post('/feeitems/get',{recordid: id}).then(response => {

                if ( typeof this.$parent.feeItemSelected === 'function') this.$parent.feeItemSelected(response.data.data[0]);

            });

        },


        toggleUnitDescription() {

            if ( this.record.unitsFlag == '0') {
                this.unitsDescription = '';
            } else {
                this.unitsDescription = this.selectFeeUnit.record.description ? 'per ' + this.selectFeeUnit.record.description : '';
            }

        },

        feeUnitSelected(id, description) {

            this.record.unitsId = id;

            this.selectFeeUnit.record = {
                id: id,
                description: description,
            };

            this.unitsDescription = 'per ' + description;

        },




        okClicked() {

            this.record.amount = this.amount;
            this.record.taxAmount = this.taxAmount;

            axios.post('/feeitems/store', this.record)
            
            .then(response => {

                if (response.data.errors) {

                    if (response.data.errors.general) { showError( 'Error', response.data.errors.general[0]);} else { this.errors = response.data.errors; }

                } else {

                    this.errors = {};

                    this.highlightTableRow(response.data.id, response.data.sorter);

                }

            }).catch(error => { showError('Error saving ' + this.table.singular, error); });

        },


        toggleFromDatePicker() {
            this.$refs.fromDatePickerComponent.elem.data('DateTimePicker').toggle();
        },
        toggleToDatePicker() {
            this.$refs.toDatePickerComponent.elem.data('DateTimePicker').toggle();
        },

        hideFromDatePicker() {
            this.$refs.fromDatePickerComponent.elem.data('DateTimePicker').hide();
        },

        hideToDatePicker() {
            this.$refs.toDatePickerComponent.elem.data('DateTimePicker').hide();
        },


        highlightTableRow( id, sorter ) {

            axios.post('/feeitems/getTablePosition', { sorter: sorter })

            .then(response => {

                this.table.jumpToRow(id, response.data);
                
                this.closeForm();

            });

        },     

    },
}

</script>
