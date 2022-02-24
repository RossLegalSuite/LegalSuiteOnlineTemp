<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lg' : ''">

        <div :id="id + '-form-border'" :class="modal ? 'modal-content feenotes-border' : 'card h-100 border-0'">

            <div :id="id + '-form-header'" :class="modal ? 'feenotes-bg' : 'card-header'">

                <div :class="modal ? 'modal-header' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="isPosted()">Posted Fee Note</span>
                            <span v-else-if="!editing && !savedFlag">Fee Note will be Added</span>
                            <span v-else>Fee Note will be Changed</span>
                        </h3>
                        <i v-if="modal" :id="id + '-modal-close-button'" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="card-body form-tab-body overflow-auto">
                <form-tabs :tabs="tabs"/>

                <div v-show="activeTab === 'General'" class="form-tab-content">

                    <div class="form-group row">

                        <div class="col-md-4">
                            <label>Date</label>
                            <date-picker :readOnly="isPosted()" ref="datePickerComponent" v-model="record.formatteddate" :config="$root.datePickerOptions"/>
                        </div>

                        <select-employee
                            :readOnly="isPosted()"
                            :id="id + '-select-employee'"
                            _class="col-md-4"
                            popOver="<h4>Employee</h4>
                            <p>The Employee this Fee Note is assigned to</p>"
                            label="Employee"
                            :ref="uniqueId + '-select-employee'" 
                            :formRef="uniqueId + '-select-employee'"
                        />                        

                        <select-income-account
                            :readOnly="isPosted()"
                            v-show="displayIncomeAccount()"
                            :id="id + '-select-income-account'"
                            _class="col-md-4"
                            popOver="<h4>Income Account</h4><p>The Income Account this Fee is allocated to.</p>"
                            ref="feenote-form-select-income-account" 
                            form-ref="feenote-form-select-income-account"
                        />

                        <select-disbursement-account
                            :readOnly="isPosted()"
                            v-show="displayDisbursementAccount()"
                            :id="id + '-select-disbursement-account'"
                            _class="col-md-4"
                            popOver="<h4>Disbursement Account</h4><p>The Ledger Account this Disbursement is allocated to.</p>"
                            ref="feenote-form-select-disbursement-account" 
                            form-ref="feenote-form-select-disbursement-account"
                        />

                        <select-revenue-stamp-account
                            :readOnly="isPosted()"
                            v-show="displayRevenueStampAccount()"
                            :id="id + '-select-revenue-stamp-account'"
                            _class="col-md-4"
                            popOver="<h4>Revenue Stamp Account</h4><p>The Ledger Account this Revenue Stamp is allocated to.</p>"
                            ref="feenote-form-select-revenue-stamp-account" 
                            form-ref="feenote-form-select-revenue-stamp-account"
                        />

                        <select-creditor
                            :readOnly="isPosted()"
                            v-show="displayCreditors()"
                            :id="id + '-select-creditor'"
                            _class="col-md-4"
                            popOver="<h4>Creditor</h4><p>The Creditor this Fee Note is allocated to.</p>"
                            ref="feenote-form-select-creditor" 
                            form-ref="feenote-form-select-creditor"
                        />



                    </div>

                    <div class="form-group row">
                        <radio-buttons 
                            :popOver="`<h4>Type</h4><p>The type of Fee Note</p>`"
                            :popOverContainer="'#' + id"
                            _class="col-md-12" 
                            :readOnly="isPosted()"
                            :record="record" 
                            column="type1" 
                            :buttons="[
                                {value:'F', text: 'Fee'},
                                {value:'D', text: 'Disbursement'},
                                {value:'R', text: 'Revenue Stamp'},
                                {value:'C', text: 'Creditor'},
                            ]" 
                            name="Type" 
                            label="Type" 
                            @change="typeChanged"
                        />
                    </div>

                    <div class="form-group row">

                        <select-matter
                            :readOnly="isPosted()"
                            popOver="<h4>Matter</h4><p>The Matter this Fee Note is linked to.</p>"
                            :id="id + '-select-matter'"
                            _class="col-md-6"
                            :ref="_uid + '-feenote-form-select-matter'" 
                            :form-ref="_uid + '-feenote-form-select-matter'"

                        />

                        <select-cost-centre
                            :readOnly="isPosted()"
                            popOver="<h4>Cost Centre</h4><p>The Cost Centre this Fee Note is allocated to.</p>"
                            v-show="displayCostCentre()"
                            :id="id + '-select-cost-centre'"
                            _class="col-md-6"
                            :ref="_uid + '-feenote-form-select-cost-centre'" 
                            :form-ref="_uid + '-feenote-form-select-cost-centre'"
                        />

                    </div>

                    <div class="form-group row">

                        <text-area 
                            v-show="hasLongDescription()"
                            _class="col-md-12" 
                            popOver="<h4>Description</h4><p>A description of the Fee Note.</p>"
                            :readOnly="isPosted()"
                            rows="4" 
                            cols="50" 
                            v-model="record.description" 
                            name="description" 
                            label="Description"
                            ref="longFeeNoteDescription"
                            :lookupLibraryFlag="true"
                            lookupLibraryCategory="FeeNote Description"
                        />

                        <text-input 
                            v-show="!hasLongDescription()"
                            _class="col-md-12" 
                            popOver="<h4>Description</h4><p>A description of the Fee Note.</p>"
                            :readOnly="isPosted()"
                            v-model="record.description" 
                            name="description" 
                            label="Description"
                            ref="shortFeeNoteDescription"
                            :lookupLibraryFlag="true"
                            lookupLibraryCategory="FeeNote Description"
                        />

                    </div>

                    <div v-show="$root.control.vatmethod == 'N'" class="form-group row">

                        <text-input 
                            _class="col-md-4"
                            popOver="<h4>Amount</h4><p>The amount of the Fee Note.</p>"
                            input-class="form-input-number" 
                            :value="isPosted() ? $root.formatMoney(record.amount) : record.amount" 
                            label="Amount"
                            ref="feeNoteAmount1"
                        />

                    </div>

                    <div v-show="$root.control.vatmethod != 'N'" class="form-group row">

                        <text-input 
                            v-show="!isPosted()"
                            _class="col-md-4"
                            popOver="<h4>Amount</h4><p>The amount of the Fee Note.</p>"
                            input-class="form-input-number" 
                            v-model="record.amount" 
                            label="Amount"
                            ref="feeNoteAmount"
                        />

                        <text-input 
                            v-show="isPosted()"
                            _class="col-md-4"
                            popOver="<h4>Amount</h4><p>The amount of the Fee Note.</p>"
                            input-class="form-input-number" 
                            :value="$root.formatMoney(record.amount)" 
                            label="Amount"
                            ref="feeNoteAmount"
                        />


                        <text-input 
                            v-show="isPosted()" 
                            popOver="<h4>Vat Amount</h4><p>The Vat applied to this Fee Note.</p>"
                            _class="col-md-4" 
                            input-class="form-input-number"
                            :readOnly="true"
                            :value="$root.formatMoney(record.vatamount)" 
                            label="Vat"
                            ref="feeNoteVat"
                        />


                        <div v-show="!isPosted()" class="col-md-4">

                            <label>Vat Rate</label>
                            <pop-over 
                                :container="'#' + id" 
                                content="<h4>Vat Rate</h4><p>The Vat Rate that applies to this Fee Note.</p>"
                            />
                            <v-select 
                                append-to-body 
                                :calculate-position="$root.popUp"
                                :options="vatRates" 
                                :clearable="false"
                                :searchable="false"
                                v-model="record.vatrate"
                                :reduce="vatRates => vatRates.value"
                            />


                        </div>

                        <div v-show="!isPosted() && isVatable()" class="col-md-4">

                            <label>Inc/Excl Vat</label>
                            <pop-over 
                                :container="'#' + id" 
                                content="<h4>Vat Inc/Excl</h4><p>Specify whether the Amount includes or excludes Vat.</p>"
                            />
                            <v-select 
                                append-to-body 
                                :calculate-position="$root.popUp"
                                :options="vatIe" 
                                :clearable="false"
                                :searchable="false"
                                v-model="record.vatie"
                                :reduce="vatIe => vatIe.value"
                            />

                        </div>

                    </div>

                </div>  

                <div v-show="activeTab === 'Options'" class="form-tab-content">

                    <div class="row">

                        <div class="col-xxl-6">

                            <fieldset><legend>Sundry</legend>

                                <div class="form-group row">

                                    <text-input 
                                        _class="col-md-8"
                                        popOver="<h4>Voucher</h4><p>A reference for this Fee Note (if applicable).</p>
                                        <p>Note: This is an optional field.</p>"
                                        v-model="record.voucher"
                                        label="Voucher"
                                        :readOnly="isPosted()"
                                    />

                                </div>

                                <div class="form-group row">

                                    <div class="col-md-12">

                                        <label>Document Code</label>
                                        <pop-over 
                                            :container="'#' + id" 
                                            content="<h4>Document Code</h4><p>Fee Notes that are added to the Debtors Account can have a Document Code which indicates on which document the Fee appears as a Cost.</p>
                                            <p>You can select the Document on which this debit must appear or select None if it is a general cost unrelated to a specific Document.</p>"
                                        />
                                        <v-select 
                                            :options="documentCodes" 
                                            :clearable="false"
                                            :searchable="false"
                                            v-model="record.documentcode"
                                            :reduce="documentCodes => documentCodes.value"
                                        />

                                    </div>

                                </div>

                            </fieldset>

                        </div>

                        <div class="col-xxl-6 mt-xl-3 mt-xxl-0">

                            <fieldset><legend>Actions</legend>

                                <div class="form-group row">

                                    <div class="col-md-12">

                                        <label v-text="'Debtors Account'" style="margin-bottom: 0.6rem !important;"/>

                                        <pop-over content="
                                        <h4>Add Fee Note to Debtors Account</h4>
                                        <p>Add the Fee Note as a Cost in the Matter's Debtors Account.</p>
                                        "/>

                                        <b-form-checkbox
                                            :id="id + '-add-to-debtors-account'"
                                            v-model="record.addtocolldebitflag"
                                            name="addToCollDebitFlag"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            Add Fee Note to Debtors Account
                                        </b-form-checkbox>

                                    </div>
                                </div>

                                <div class="form-group row">

                                    <div class="col-md-12">

                                        <label v-text="'Invoice'" style="margin-bottom: 0.6rem !important;"/>

                                        <pop-over content="
                                        <h4>Do Not Combine</h4>
                                        <p>Do not combine this Fee Note with other items on an Invoice.</p>
                                        <p>This item will appear as a separate entry.</p>
                                        "/>

                                        <b-form-checkbox
                                            :id="id + '-do-not-combine'"
                                            v-model="record.donotcombineflag"
                                            name="doNotCombine"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            Do not combine this Fee Note
                                        </b-form-checkbox>

                                    </div>
                                </div>

                                <div class="form-group row">

                                    <div class="col-md-12">

                                        <label v-text="'Posting'" style="margin-bottom: 0.6rem !important;"/>

                                        <pop-over content="
                                        <h4>Prevent Posting</h4>
                                        <p>If this option is <strong>selected</strong>, the Fee Note will not be posted to Accounting.</p>
                                        <p>If <strong>unselected</strong>, the Fee Note will be able to be posted to Accounting.</p>
                                        "/>

                                        <b-form-checkbox
                                            :id="id + '-on-hold'"
                                            v-model="record.onhold"
                                            name="onhold"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            Put Fee Note On Hold
                                        </b-form-checkbox>

                                    </div>
                                </div>

                            </fieldset>

                        </div>

                    </div>

                </div>  

                <div v-show="activeTab === 'Details'" class="form-tab-content">

                    <div class="row">

                        <div class="col-xxl-6">

                            <fieldset><legend>General</legend>

                                <div class="form-group row">

                                    <text-input 
                                        _class="col-md-8"
                                        popOver="<h4>Voucher</h4><p>The reference used for this Fee Note.</p>"
                                        v-model="record.voucher"
                                        label="Voucher"
                                        :readOnly="true"
                                    />

                                </div>

                                <div class="form-group row">

                                    <text-input 
                                        _class="col-md-8"
                                        popOver="<h4>Source</h4><p>The application or process that created the Fee Note.</p>"
                                        v-model="record.sourcedescription"
                                        label="Source"
                                        :readOnly="true"
                                    />

                                </div>

                            </fieldset>

                        </div>

                        <div class="col-xxl-6 mt-xl-3 mt-xxl-0">

                            <fieldset><legend>Posting Details</legend>
                            
                                <div class="form-group row">
                                    <text-input 
                                        _class="col-md-8"
                                        popOver="<h4>Date</h4><p>The date the Fee Note was posted.</p>"
                                        v-model="record.formattedposteddate"
                                        label="Date"
                                        :readOnly="true"
                                    />
                                </div>

                                <div class="form-group row">
                                    <text-input 
                                        _class="col-md-8"
                                        popOver="<h4>Batch Number</h4><p>The Batch that contains the posted Fee.</p>"
                                        v-model="record.postedbatchid"
                                        label="Batch No"
                                        :readOnly="true"
                                    />
                                </div>

                                <div class="form-group row">
                                    <text-input 
                                        _class="col-md-8"
                                        popOver="<h4>Posted By</h4><p>The Employee who posted the Batch.</p>"
                                        v-model="record.postedemployee"
                                        label="Posted By"
                                        :readOnly="true"
                                    />
                                </div>


                            </fieldset>

                        </div>

                    </div>
                </div>

            </div>

            <div class="modal-footer justify-content-between">
                <div>

                    <button v-show="editing && !isPosted()" class="btn btn-primary form-button mr-3" type="button" @click="deleteClicked">
                        <span title="Delete this Fee Note"><i class="fa fa-trash fa-lg mr-2"></i>Delete</span>
                    </button>

                </div>
                <div>

                    <button v-if="!isPosted()" class="btn btn-yellow form-button mr-3" @click="okClicked(false)" type="button" title="Save the Item and continue editing"><i class="fa fa-check-square fa-lg mr-2"></i>Save</button>

                    <button v-if="!isPosted()" class="btn btn-success form-button mr-3" @click="okClicked(true)" type="button" title="Save the Item and close the Window"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>

                    <button v-if="savedFlag || editing" class="btn btn-danger form-button" @click="closeForm" type="button" title="Close this screen"><i class="fa fa-times-circle fa-lg mr-2"></i>Close</button>

                    <button v-else class="btn btn-danger form-button" @click="closeForm" type="button" title="Exit without saving"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>

                </div>
            </div>

        </div>

    </div>
    
</div>

</template>    

<script>

import { mapGetters } from 'vuex';
import formTemplate from "@pages/form-template";
import modalTemplate from "@components/modals/modal-template";

export default {

    mixins: [modalTemplate, formTemplate ],
    
    components: {
        SelectMatter: () => import("@pages/matters/SelectMatter"),
        SelectCostCentre: () => import("@pages/matters/SelectCostCentre"),
        SelectIncomeAccount: () => import("@pages/matters/SelectIncomeAccount"),
        SelectDisbursementAccount: () => import("@pages/matters/SelectDisbursementAccount"),
        SelectRevenueStampAccount: () => import("@pages/matters/SelectRevenueStampAccount"),
        SelectCreditor: () => import("@pages/matters/SelectCreditor"),
        SelectEmployee: () => import("@pages/employees/SelectEmployee"),

    },

    props: {
        resource: {type: String, default: 'Fee Notes' },
        secProc: {type: String, default: 'Matters - Desktop - Fee Notes' },
        uniqueId: String,

    },    

    data() {
        return {
            selectedMatter: {},
            vatRates: root.vatRates,
            vatIe: [ { value: 'E', label: 'Excluding' }, { value: 'I', label: 'Including' }],
            documentCodes: [
                { value: null, label: 'None'},
                { value: 'CCJ', label: 'Certified Extract of Civil Judgment'},
                { value: 'EMO', label: 'Emoluments Attachment Order'},
                { value: 'IMM', label: 'Sale of Immovable property'},
                { value: 'JUD', label: 'Judgement'},
                { value: 'LOD', label: 'Letter Of Demand'},
                { value: 'MOV', label: 'Sale of movable property'},
                { value: 'R41', label: 'Postponed proceedings'},
                { value: 'RDJ', label: 'Request for Default Judgment'},
                { value: 'REEMO', label: 'Reissue Emoluments Attachment Order'},
                { value: 'RES65', label: 'Reissue Section 65 Notice to Appear in Court'},
                { value: 'RESUM', label: 'Reissue Summons'},
                { value: 'REWRI', label: 'Reissue Warrant of Execution'},
                { value: 'S57', label: 'Section 57 Consent'},
                { value: 'S65', label: 'Section 65 Notice to Appear in Court'},
                { value: 'SUM', label: 'Summons'},
                { value: 'WOA', label: 'Warrant of Arrest'},
                { value: 'WRI', label: 'Warrant of Execution'},
            ],

            activeTab: 'General',
            tabs: [
                {
                    pageName: "General",
                    title: "Transaction",
                    iconClass: '',
                    visible: true,
                    active: true,
                },
                {
                    pageName: "Options",
                    title: "Options",
                    iconClass: '',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "Details",
                    title: "Details",
                    iconClass: '',
                    visible: false,
                    active: false,
                },

            ],
        }
    },

    computed: {

        ...mapGetters(['currentMatter']),
    },

    methods: {

        editRecord(id) {

            this.setGeneralTab();

            axios.post('/feenote/get',{recordid: id})

            .then(response => {

                this.record = response.data.data[0];

                this.$refs.shortFeeNoteDescription.setReadOnly = this.$refs.longFeeNoteDescription.setReadOnly = this.isPosted();
                this.$refs.feeNoteAmount.setReadOnly = this.$refs.feeNoteAmount1.setReadOnly = this.isPosted();

                if ( this.isPosted() ) {
                    this.$refs.feeNoteVat.setLabel = 'Vat (' + root.vatRates.filter(record => record.value == '1')[0].label + ')';
                }

                this.selectEmployee.record = {
                    recordid: this.record.employeeid,
                    name: htmlDecode(this.record.employeename),
                };


                this.selectMatter.matter = {
                    id: this.record.matterid,
                    fileref: htmlDecode(this.record.matterfileref),
                    description: htmlDecode(this.record.matterdescription),
                };

                this.selectCostCentre.record = {
                    recordid: this.record.costcentreid,
                    description: htmlDecode(this.record.costcentre),
                };

                if ( this.record.type1 == 'F') {
                    
                    this.selectIncomeAccount.record = {
                        recordid: this.record.code2,
                        description: htmlDecode(root.business.filter(record => record.recordid == this.record.code2)[0].description),
                    };

                } else if ( this.record.type1 == 'D') {

                    this.selectDisbursementAccount.record = {
                        recordid: this.record.code2,
                        description: htmlDecode(root.business.filter(record => record.recordid == this.record.code2)[0].description),
                    };

                } else if ( this.record.type == 'R') {

                    this.selectRevenueStampAccount.record = {
                        recordid: this.record.code2,
                        description: htmlDecode(root.business.filter(record => record.recordid == this.record.code2)[0].description),
                    };

                } else if ( this.record.type == 'C') {

                    this.selectCreditor.record = {
                        recordid: this.record.code2,
                        description: htmlDecode(root.creditors.filter(record => record.recordid == this.record.code2)[0].description),
                    };

                }

                this.initFormData();

            }).catch( (error) => {
                showError('Error',error)
            });

        },

        initNewRecord() {

            this.setGeneralTab();

            this.record = {
                formatteddate: moment().format(root.control.dateformat),
                employeeid: root.loggedInEmployeeId,
                matterid: this.currentMatter.recordid || null,
                costcentreid: this.record.costcentreid || null,
                code2: this.record.code2 || root.control.incomeaccid,
                description: null,
                feecodeid:  0,
                feeitemid:  0,
                documentid:  0,
                partyid:  null,
                source: 'W',
                type1: this.record.type1 || 'F',
                option1: '1',
                documentcode: null,
                amount: null,
                postedflag: '0',
                unitid:  0,
                overrideincomeaccflag: 0,
                addtocolldebitflag: 0,
                vatie: this.record.vatie || root.control.feevatieoption == '1' ? 'I' : 'E',
            };

            this.setVatRate();

            // if ( root.control.vatmethod == 'N' ) {

            //     this.record.vatrate = 'N';

            // } else {

            //     this.record.vatrate = '1';

            // }


            if ( this.record.code2 ) {

                this.selectIncomeAccount.record = {
                    recordid: this.record.code2,
                    description: root.incomeAccounts.filter(record => record.recordid == this.record.code2)[0].description,
                };

            } else {

                this.selectIncomeAccount.record = {
                    recordid: null,
                    description: '',
                };

            }

            if ( this.record.matterid ) {

                // ******************************************************************
                // DO axios to get Matter and then call matterSelected() to set some defaults
                // ******************************************************************

                axios.post('/matter/get/' + this.record.matterid)

                .then(response => {

                    if ( response.data.errors ) {

                        showError('Error', response.data.errors);

                    } else {

                        this.matterSelected(response.data.data[0]);

                    }

                }).catch( (error) => {
                    showError('Error getting Matter', error); 
                });


            }

            this.selectMatter.matter = this.currentMatter.recordid ? 
            {
                recordid: this.currentMatter.recordid,
                fileref: htmlDecode(this.currentMatter.fileref),
                description: htmlDecode(this.currentMatter.description),
            } : {
                recordid: null,
                fileref: '',
                description: '',
            };


            this.selectCostCentre.record = this.record.costcentreid ?
            {
                recordid: this.record.costcentreid,
                description: root.costCentres.filter(record => record.recordid == this.record.costcentreid)[0].description,
            } : {
                recordid: null,
                description: '',
            };

            this.selectEmployee.record = {
                recordid: root.loggedInEmployeeId,
                name: root.loggedInEmployeeName,
            };

            this.initFormData();

            setTimeout(() => $('#' + this.id + ' textarea[name="description"]').focus() );

        },

        initFormData() {

            let optionsTab = this.tabs.filter(tab => tab.pageName === 'Options')[0];

            optionsTab.visible = this.record.postedflag == '0' ? true : false;

            let detailsTab = this.tabs.filter(tab => tab.pageName === 'Details')[0];

            detailsTab.visible = this.record.postedflag == '0' ? false : true;

            this.selectMatter.callingComponent = this;

            this.displayForm();

        },

        typeChanged() {

            this.setVatRate();

        },

        matterSelected(selectedRecord) {

            this.selectedMatter = selectedRecord;

            if (selectedRecord.clientfeesheetid == selectedRecord.debtorfeesheetid) {
                this.record.addtocolldebitflag = '1';
            } else {
                this.record.addtocolldebitflag = '0';
            }

            this.record.matterid = selectedRecord.recordid;

            // Set the Cost Centre

            if ( root.loggedInEmployeeUseMatterCostCentreFlag == '1') {

                if ( selectedRecord.costcentreid ) {

                    this.record.costcentreid = selectedRecord.costcentreid;

                    this.selectCostCentre.record = {
                        recordid: this.record.costcentreid,
                        description: root.costCentres.filter(record => record.recordid == this.record.costcentreid)[0].description,
                    }

                }

            }

            // Set the default description
            if ( !this.record.description ) {

                let language = root.languages.filter(record => record.recordid == selectedRecord.accountslanguageid);

                if ( language.length) {

                    if ( this.record.type1 == 'F' ) {
                        this.record.description = language[0].feedescription;
                    } else if ( this.record.type1 == 'D' || this.record.type1 == 'R') {
                        this.record.description = language[0].disbursementdescription;
                    } else if ( this.record.type1 == 'C' ) {
                        this.record.description = language[0].businesscreditordescription;
                    }
                }

            }

            this.setVatRate();

            this.getIncomeAccount().then( ( response ) => {

                this.record.code2 = response.recordid;
                this.record.overrideincomeaccflag = response.overrideincomeaccflag;

            }).catch( (error) => {

                showError('Error getting Income Account',error)
            });


        },        

        setVatRate() {

            if ( this.record.type1 == 'R') {

                this.record.vatrate = 'E';

            } else if ( root.control.vatmethod == 'N' ) {

                this.record.vatrate = 'N';

            } else {

                if (this.selectedMatter?.vatexemptflag == '1' ) {

                    this.record.vatrate = 'Z';

                } else {
                    
                    this.record.vatrate = '1';

                }

            }
        },

        getIncomeAccount() {

            return new Promise((resolve, reject) => {

                axios.post("/utils/getIncomeAccount",{
                    matterId: this.record.matterid, 
                    employeeid: this.record.employeeid
                })

                .then(response => {

                    if (response.data.errors) {

                        reject(response.data.errors );

                    } else {

                        resolve({
                            recordid: response.data.data.recordid,
                            overrideincomeaccflag: response.data.data.overrideincomeaccflag
                        })
                    }

                }).catch(error => { 

                    reject(error);

                });

            });

        },

        hasLongDescription() {
            return this.record?.description && this.record?.description.length > 250 ? true : false;
        },

        isPosted() {
            return this.record?.postedflag == '1' ? true : false;
        },

        isVatable() {
            return this.record?.vatrate == '1' || this.record?.vatrate == '2' || this.record?.vatrate == '3' ? true : false;
        },

        displayIncomeAccount() {
            return this.record?.type1 == 'F' ? true : false;
        },

        displayDisbursementAccount() {
            return this.record?.type1 == 'D' ? true : false;
        },

        displayRevenueStampAccount() {
            return this.record?.type1 == 'R' ? true : false;
        },

        displayCreditors() {
            return this.record?.type1 == 'C' ? true : false;
        },

        displayCostCentre() {

            if ( this.record?.type1 == 'F') {
                return true;
            } else if ( this.record?.type1 == 'D' && root.control.expenditureoption != '2') {
                return true;
            } else {
                return false;
            }

        },


        okClicked( closeFlag = true ) {

            this.record.date = this.record.formatteddate;

            root.$snotify.simple('Please wait...', 'Saving Fee Note', { timeout: 10000, icon: 'img/cogs.gif' });

            axios.post('/feenote/' + (this.savedFlag ? 'update' : 'store'), this.record)
            
            .then(response => {

                if (response.data.errors) {

                    this.setGeneralTab();

                    showError( 'Error', response.data.errors );

                } else {

                    this.record.recordid = response.data.data[0].recordid;

                    root.$snotify.clear();

                    this.errors = {};

                    if (!this.editing && !this.savedFlag) {

                        if (this.table.initialOrder[0][1] == 'asc') {

                            this.highlightRow(response.data.data[0].recordid, {
                                where: ["date,>,0","date,<," + response.data.data[0].date,"sorter,>," + response.data.data[0].sorter],
                                orderBy: ['date,asc','sorter,asc'],
                            });

                        } else {
                            
                            this.highlightRow(response.data.data[0].recordid, {
                                where: ["date,>,0","date,>," + response.data.data[0].date,"sorter,>," + response.data.data[0].sorter],
                                orderBy: ['date,desc','sorter,asc'],
                            });

                        }

                    } else {

                        this.table.refreshRow(response.data.data[0].recordid);

                    }

                    if (closeFlag) {

                        this.closeForm();

                    } else {

                        this.savedFlag = true;
                    }

                }

            }).catch(error => { showError('Error saving ' + this.table.singular, error); });

        },

        canDelete() {
        
            return new Promise((resolve, reject) => {

                if ( this.record.postedflag  == '1') {

                    reject('This Fee Note has been posted. It cannot be deleted');

                } else {

                    resolve();

                }

            });

        },

    },

}

</script>
