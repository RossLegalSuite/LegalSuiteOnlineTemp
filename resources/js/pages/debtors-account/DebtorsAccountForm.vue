<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lg' : ''">

        <div :class="modal ? 'modal-content blue-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header blue-bg' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3 class="modal-title">
                            <span v-html="pageTitle()"></span>
                        </h3>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="modal-body overflow-auto p-3" :style="modal ? 'height:65vh' : ''">

                <div class="form-group row">

                    <div class="col-md-4">

                        <label>Date</label>

                        <date-picker 
                            :readOnly="viewing" 
                            ref="datePickerComponent" 
                            v-model="record.formatteddate" 
                            :config="$root.datePickerOptions"
                        />

                    </div>


                    <text-input 
                        v-show="!virtual && editing"
                        popOver="<h4>Employee</h4><p>The User who inserted the Transaction.</p>"
                        _class="col-md-4"
                        v-model="record.employeename"
                        :readOnly="true"
                        name="employee"
                        label="Employee"
                    />


                    <text-input 
                        v-show="!virtual"
                        popOver="<h4>Document Code</h4><p>Indicates which process this transaction appears on (e.g. LOD).</p>"
                        :_class="editing ? 'col-md-4' : 'col-md-4 offset-md-4'"
                        v-model="record.documentcode"
                        :readOnly="viewing"
                        name="documentcode"
                        label="Document Code"
                    />


                </div>

                <div class="form-group row">

                    <text-input 
                        _class="col-md-12"
                        v-model="record.description"
                        :readOnly="viewing"
                        name="description"
                        label="Description"
                        :lookupLibraryFlag="true"
                        lookupLibraryCategory="Description"
                    />
                    
                </div>

                <div class="form-group row">
                
                    <div v-show="virtual" class="col-md-5">
                        <label>Type</label>
                        <pop-over content="
                            <h4>Type</h4>
                            <p><strong>Cost</strong> - Increases the Cost Balance (except if it's Category is set to <em>Journal</em> which increases the Capital Balance). </p><p><strong>Type = D</strong></p>
                            <p><strong>Payment</strong> - Reduces the Balances (based on the rules defined in the Settings) and (optionally) attracts Collection Commission (except if it's Category is set to <em>Journal</em> which then simply decreases the Capital Balance) </p><p><strong>Type = P</strong></p>
                            <p><strong>Interest</strong> - Increases the Interest Balance. This is a <strong><em>virtual</em></strong> transaction, i.e. it is calculated and inserted by the program whenever a Payment is made, but interest may also be inserted manually by the User if required </p><p><strong>Type = I (Virual transaction) or Type = J (Manually inserted)</strong></p>
                            <p><strong>Collection Commission</strong> - This is a <strong><em>virtual</em></strong> transaction and is applied when a Payment is made and increases the Cost Balance </p><p><strong>Type = X (Virual transaction) or Type = W (Manually inserted)</strong></p>
                            <p><strong>Employer's Commission</strong> - This is a <strong><em>virtual</em></strong> transaction and is applied when a Payment is made and there is an Emoluments Attachment Order. It is treated as a Payment and therefore decreases the Capital Balance </p><p><strong>Type = V</strong></p>
                            "
                        />
                        <v-select
                            :tabindex="-1"
                            :options="allTypes" 
                            :clearable="false" 
                            :searchable="false" 
                            :reduce="allTypes => allTypes.value"
                            v-model="record.type"
                            @option:selected="typeChanged"
                        />

                    </div>

                    <div v-show="!virtual" class="col-md-5">
                        <label>Type</label>
                        <pop-over content="
                            <h4>Type</h4>
                            <p><strong>Debit</strong>: Increases the Cost Balance (except if it's Category is set to <em>Journal</em> which then <em>increases</em> the Capital Balance)</p>
                            <p><strong>Credit</strong>: Reduces the Capital Balance and attracts Collection Commission (except if it's Category is set to <em>Journal</em>)</p>
                            <p><strong>Interest</strong>: Interest manually inserted by the user - Increases the Interest Balance</p>
                            <p><strong>Collection Commission</strong>: Collection commission manually inserted by the user - Increases the Cost Balance</p>"
                        />
                        <v-select
                            :tabindex="-1"
                            :options="editingTypes" 
                            :clearable="false" 
                            :searchable="false" 
                            :reduce="editingTypes => editingTypes.value"
                            v-model="record.type"
                            @option:selected="typeChanged"
                        />

                    </div>

                    <div v-show="isDebit() && !isManualInterest() && !virtual" class="col-md-5">
                        <label>Category</label>
                        <pop-over content="
                            <h4>Category</h4>
                            <p>A Category is used to classify the Transactions by its type. Some Categories (such a the Journal category) indicate how the Transaction affects the Balances.</p>"
                        />
                        <v-select
                            :tabindex="-1"
                            :options="debitCategories" 
                            :clearable="false" 
                            :searchable="false" 
                            :reduce="debitCategories => debitCategories.value"
                            v-model="record.category"
                            @option:selected="categoryChanged"
                        />

                    </div>


                    <div v-show="!isDebit() && !isManualInterest() && !virtual" class="col-md-5">
                        <label>Category</label>
                        <pop-over content="
                            <h4>Category</h4>
                            <p>A Category is used to classify the Transactions by its type. Some Categories (such a the Journal category) indicate how the Transaction affects the Balances.</p>"
                        />
                        <v-select
                            :tabindex="-1"
                            :options="creditCategories" 
                            :clearable="false" 
                            :searchable="false" 
                            :reduce="creditCategories => creditCategories.value"
                            v-model="record.category"
                            @option:selected="categoryChanged"
                        />

                    </div>

                </div> 

                <div class="row">

                    <div class="col-md-5">
                        <div class="form-group row">

                            <text-input 
                                label="Amount" 
                                _class="col-md-10" 
                                type="number" 
                                input-class="form-input-number" 
                                :readOnly="viewing"
                                v-model="record.amount" 
                                name="amount"
                                @change="amountChanged"
                            />
                        </div>

                        <div v-show="isVatable()" class="form-group row">

                            <text-input 
                                label="Vat Amount" 
                                _class="col-md-10" 
                                type="number" 
                                input-class="form-input-number" 
                                :readOnly="true"
                                v-model="record.vatamount" 
                                name="vatamount" 
                            />

                        </div>
                    </div>

                    <div v-show="isVatable() || isPayment() || isCommissionable() || showEmployerCommission()" class="col-md-7">

                        <fieldset class="my-2"><legend>Options</legend>

                            <div v-show="isVatable()" class="form-group row">
                                <div class="col-md-12">

                                    <!-- <label v-text="'Vat'" style="margin-bottom: 0.6rem !important;"/> -->

                                    <b-form-checkbox
                                        :id="id + '-vatflag'"
                                        v-model="record.vatflag"
                                        name="vatflag"
                                        value="1"
                                        unchecked-value="0"
                                        switch 
                                        size="lg"
                                        @change="calculateVatAmount"
                                        >
                                        Charge Vat on this Transaction
                                    </b-form-checkbox>

                                </div>
                            </div>

                            <div v-show="isCommissionable()" class="form-group row">
                                <div class="col-md-12">

                                    <!-- <label v-text="'Collection Commission'" style="margin-bottom: 0.6rem !important;"/> -->

                                    <b-form-checkbox
                                        :id="id + '-collcommflag'"
                                        v-model="record.collcommflag"
                                        name="collcommflag"
                                        value="1"
                                        unchecked-value="0"
                                        switch 
                                        size="lg"
                                        >
                                        Charge Collection Commission
                                    </b-form-checkbox>

                                </div>
                            </div>

                            <div v-show="showEmployerCommission()" class="form-group row">
                                <div class="col-md-12">

                                    <!-- <label v-text="'Employer\'s Commission'" style="margin-bottom: 0.6rem !important;"/> -->

                                    <b-form-checkbox
                                        :id="id + '-overrideemocommflag'"
                                        v-model="record.overrideemocommflag"
                                        name="overrideemocommflag"
                                        value="1"
                                        unchecked-value="0"
                                        switch 
                                        size="lg"
                                        >
                                        Charge Employer's Commission
                                    </b-form-checkbox>

                                </div>
                            </div>

                            <div v-show="isPayment()" class="form-group row">

                                <text-input 
                                    popOver="<h4>Reference</h4><p>A reference for this Transaction (e.g. the receipt no).</p>"
                                    _class="col-md-4"
                                    v-model="record.reference"
                                    :readOnly="viewing"
                                    name="reference"
                                    label="Reference"
                                />

                            </div>


                        </fieldset>

                    </div>

                </div>


                <!-- <div v-show="!virtual" class="form-group row">

                    <div class="col-md-8">

                        <b-form-checkbox
                            :id="id + '-exportedflag'"
                            v-model="record.exportedflag"
                            name="exportedflag"
                            value="1"
                            unchecked-value="0"
                            switch 
                            size="lg"
                            >
                            Exported?
                        </b-form-checkbox>

                    </div>

                </div>  -->

            </div>

            <div class="modal-footer justify-content-between">
                    <div>
                        <button v-show="!viewing" class="btn btn-large btn-primary" type="button" @click="deleteClicked">
                            <span title="Delete"><i class="fa fa-trash fa-lg mr-2"></i>Delete</span>
                        </button>
                    </div>
                    <div>
                        <button v-show="!viewing" class="btn btn-success form-button mr-3" @click="okClicked" type="button" title="Save"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>
                        <button v-show="!viewing" class="btn btn-danger form-button" type="button" data-dismiss="modal" title="Exit without saving"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
                        <button v-show="viewing" class="btn btn-danger form-button" type="button" data-dismiss="modal" title="Exit"><i class="fa fa-times-circle fa-lg mr-2"></i>Close</button>
                    </div>
            </div>

        </div>
    </div>
</div>

</template>

<script>

import { mapGetters } from 'vuex';
import modalTemplate from "@components/modals/modal-template";
import formTemplate from "@pages/form-template";

export default {

    mixins: [formTemplate, modalTemplate],

    props: {
        resource: {type: String, default: 'ColDebit' },
        secProc: {type: String, default: 'Debtors Account - Update' },
    },

    data() {
        return {
            virtual: false,
            editingTypes : [ 
                {label: 'Debit', value: 'D'},
                {label: 'Credit' , value: 'P'},
                {label: 'Interest', value: 'J'},
                {label: 'Collection Commission', value: 'W'},
            ],
            allTypes : [ 
                {label: 'Cost', value: 'D'},
                {label: 'Payment' , value: 'P'},
                {label: 'Interest', value: 'I'},
                {label: '*Interest', value: 'J'},
                {label: 'Collection Commission', value: 'X'},
                {label: '*Collection Commission', value: 'W'},
                {label: 'Employer\'s Commission', value: 'V'},
            ],
            debitCategories : [ 
                {label: 'Cost', value: 'C'},
                {label: 'Admin Fee' , value: 'A'},
                {label: 'Sheriff\'s Fee', value: 'S'},
                {label: 'Tracing Fee', value: 'T'},
                {label: 'Revenue Stamp', value: 'R'},
                {label: 'Postage', value: 'P'},
                {label: 'Journal', value: 'J'},
                {label: 'Other', value: 'O'},
            ],
            creditCategories : [ 
                {label: 'Payment', value: 'P'},
                {label: 'Journal' , value: 'J'},
            ],
        };
    },    

    computed: {

        ...mapGetters(['currentMatter','currentColData']),

    },


    methods: {

        editRecord(id) {


            this.record = this.table.table.row('#' + id).data();

            console.log("this.record.formatteddate",this.record.formatteddate);

            if ( this.record.type == 'I' || this.record.type == 'X' || this.record.type == 'V') {
                this.viewing = this.virtual = true;
            } else {
                this.viewing = this.virtual = false;
            }

            // Example
            //this.$refs['debtorcollcommpercent'].setReadOnly = false;

            /*  Columns
                amount
                balance
                capitalbalance
                category
                costbalance
                date
                description
                employeename
                formatteddate
                interestbalance
                interestrate
                lastinterestdate
                matterid
                recordid
                timerstamp
                totalamount
                trantype
                type
                typedescription
                vatamount

            */

            this.initFormData();


        },

        initNewRecord() {

            this.record = {
                matterid: this.currentMatter.recordid,
                formatteddate: moment().format(root.datePickerOptions.format),
                description: '',
                type: this.record.type ? this.record.type : 'D',
                category: this.record.category ? this.record.category : 'C',
                employeename: root.loggedInEmployeeName,
                employeeid: root.loggedInEmployeeId,
                interestrate: this.currentMatter.interestrate,
                collcommflag: this.currentMatter.debtorcollcommoption == 'N' ? 0 : 1,
                amount: null,
                vatamount: null,
                vatflag: root.control.vatmethod == 'N' ? 0 : 1,
                reference: '',
                documentcode: '',
            };


            this.initFormData();

        },

        initFormData() {
            
            this.displayForm(); 

            if (!this.viewing) {
                setTimeout(() => $('#' + this.id + ' input[name="description"]').focus() );
            }


        },

        isDebit() {
            if ( this.virtual ) {
                return false;
            } else {
                return this?.record.type == 'D' || this?.record.type == 'J' || this?.record.type == 'W'  ? true : false;
            }
        },

        isManualInterest() {
            return this?.record.type == 'J' ? true : false;
        },

        isPayment() {
            return this?.record.type == 'P' ? true : false;
        },

        isVatable() {
            if ( this.virtual ) {
                return false;
            } else {
                return this?.record.type == 'D' || this?.record.type == 'W'  ? true : false;
            }
        },

        isCommissionable() {
            if ( this.virtual ) {
                return false;
            } else {
                return !this.isDebit() && this?.record.category != 'J'  ? true : false;
            }
        },

        showEmployerCommission() {

            if (this?.record.type == 'P' && this?.record.date && parseInt(this?.record.date) >= parseInt(this.currentColData.emofirstdate) && this.currentColData.emoamount && this.currentColData.emocommissionpercent) {
                return true;
            } else {
                return false;
            }

        },

        amountChanged(value) {

            this.record.amount = formatDecimal(value);

            this.calculateVatAmount();

        },

        calculateVatAmount(vatFlag = null) {

            if (!vatFlag ) vatFlag = this.record.vatflag;

            let vatAmount = '0.00';

            if (vatFlag == '1') {

                let vatRate = root.getCurrentVatRate(this.record.date);
            
                vatAmount = '' + formatDecimal(this.record.amount * vatRate / 100);

            }

            $('#' + this.id + ' input[name="vatamount"]').val( vatAmount );

            this.record.vatamount = vatAmount;

        },        

        typeChanged(option){

            console.log("Handle type changed",option);

            if (this.record.type == 'D' || this.record.type == 'W') { // Cost or Collection Commission

                this.record.category = 'C';

            } else if (this.record.type == 'J') { // User inserted Interest

                this.record.category = 'I';

            } else if (this.record.type == 'P') { // Payment

                    this.record.category = 'P';

            }

        },

        categoryChanged(option){

            this.record.category = option.value;

        },

        okClicked() {

            this.record.date = this.record.formatteddate;

            axios.post('/coldebit/store', this.record)

            .then(response => {

                if (response.data.errors) {

                    showError('Error saving Debtor Transaction', response.data.errors); 

                } else {

                    this.errors = {};

                    this.hide();

                    //console.log("response.data.data",response.data.data);

                    this.table.table.ajax.reload( () => {

                        this.table.table.row('#' + response.data.data[0].recordid).scrollTo();

                        setTimeout(() => { this.table.highlightRow(response.data.data[0].recordid); },1000);

                        //let tablePosition = this.table.table.row('#' + response.data.data[0].recordid).index();

                        // console.log("tablePosition",tablePosition);

                        // console.log("response.data.data[0].recordid",response.data.data[0].recordid);

                        // this.jumpToRow(response.data.data[0].recordid, tablePosition);

                    });

                }

            }).catch( error => {
                showError('Error saving Debtor Transaction', error); 
            });


        },


        // jumpToRow(recordId, tablePosition) {

        //     this.table.table.scroller.toPosition( tablePosition, false );

        //     setTimeout(() => { this.table.highlightRow(recordId); },1000);

        // },



        highlightTableRow( id ) {

            console.error("'highlightTableRow - TO DO",id);

        },     

        pageTitle() {

            if ( this.editing ) {

                return this.virtual ? 'Virtual Transaction' : 'Transaction will be Changed';

            } else {

                return  'Transaction will be Added';
            }

        },



    },


}

</script>
