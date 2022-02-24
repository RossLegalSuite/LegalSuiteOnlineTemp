<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lgr' : ''">

        <div :class="modal ? 'modal-content matters-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header matters-bg' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="!editing && !savedFlag">Matter will be Added</span>
                            <span v-else v-html="pageTitle()"></span>
                        </h3>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="card-body form-tab-body p-3" :style="modal ? 'height:70vh' : ''">

                <form-tabs :tabs="tabs"/>

                <div v-show="activeTab === 'General'" :id="id + '-General-form-tab-content'" class="form-tab-content">

                    <fieldset><legend>Client</legend>

                        <div v-show="matterTakeOnReminder" class="row my-2">
                            <div class="col-md-12">
                                <div class="alert alert-danger" v-html="matterTakeOnReminder"/>
                            </div>
                        </div>

                        <div class="form-group row">

                            <text-input 
                                _class="col-md-8" 
                                :value="clientName" 
                                :readOnly="true" 
                                label="Name"
                                popOver="<h4>Client</h4><p>The Client's Code and Name</p>"
                            />

                            <div class="col-md-4">

                                <label>Instructed</label>

                                <pop-over content="
                                <h4>Date Instructed</h4>
                                <p>This is the date the Client instructed the Company and the Matter was opened.</p>
                                <p>This can be useful to track Matters which are taking a long time or have had no activity for a long period.</p>
                                "/>
                                <date-picker :readOnly="record.readOnly ? true: false" ref="datePickerComponent" v-model="record.formatteddateinstructed" :config="$root.datePickerOptions"/>

                            </div>


                            <select-matter-client
                                :id="id + '-select-matter-client'"
                                _class="col-md-6"
                                label="Client"
                                :formControls="false"
                                :readOnly="editing"
                                title="The Client this Matter belongs to"
                                :ref="uniqueId + '-select-matter-client'"
                                :formRef="uniqueId + '-select-matter-client'"
                                singular="Client"
                                plural="Clients"
                            />
                        </div>          



                        <div class="form-group row">

                            <text-input 
                                _class="col-md-6" 
                                v-model="record.theirref" 
                                label="Their Reference"
                                popOver="<h4>Their Reference</h4>
                                    <p>The client's reference for this Matter</p>"
                            />

                            <text-input 
                                _class="col-md-6" 
                                v-model="record.alternateref" 
                                label="Alternate Ref"
                                popOver="<h4>Alt Ref</h4>
                                    <p>An alternate reference for this Matter.</p>
                                    <p>This field can be used to link to other programs or as a reference to your previous system.</p>"
                            />
                        </div>

                        <div class="form-group row">
                            <select-client-fee-sheet
                                :id="id + '-select-client-feesheet'"
                                callback="clientFeeSheetSelected"
                                parentName="selectClientFeeSheet"
                                _class="col-md-6"
                                popOver="<h4>Fee Sheet</h4><p>The Fee Sheet used to bill the Client.</p>"
                                title="The Fee Sheet used to bill the Client"
                                :ref="uniqueId + '-matter-select-client-feesheet'" 
                                :form-ref="uniqueId + '-matter-select-client-feesheet'"
                                
                            />

                            <div class="col-md-6">

                                <label v-text="'Fee Posting'" style="margin-bottom: 0.6rem !important;"/>

                                <pop-over content="
                                <h4>Fee Posting</h4>
                                <p>If Fees are <em>on hold</em>, Fee Notes for this Matter will NOT be posted to Accounting.</p>
                                <p>This can be useful if the Client will only be billed at a later date (e.g. when the Matter is finalized).</p>
                                "/>

                                <b-form-checkbox
                                    :id="id + '-feenotes-onhold'"
                                    v-model="record.feenotesonhold"
                                    name="feeNotesOnHold"
                                    value="1"
                                    unchecked-value="0"
                                    switch 
                                    size="lg"
                                    >
                                    Fees are on hold
                                </b-form-checkbox>

                            </div>
                        </div>


                    </fieldset> 

                    <fieldset class="mt-3"><legend>Matter</legend>

                        <div class="form-group row">

                            <text-input _class="col-md-4" 
                            v-model="record.fileref" 
                            :required="true" 
                            name="fileref" 
                            label="File Ref"
                            popOver="<h4>File Ref</h4>
                                    <p>The Code assigned to the Matter</p>
                                    <p>This is your reference to this Matter</p>"
                            />

                        </div>

                        <div class="form-group row">
                            
                            <text-input 
                            _class="col-md-12" 
                            v-model="record.description" 
                            :required="true" 
                            name="description" 
                            label="Description"
                            popOver="<h4>Description</h4>
                                    <p>A general description of the Matter</p>"
                            />

                        </div>

                        <div class="row">

                            <div class="col-md-6">

                                <div class="form-group row">
                                    <select-employee
                                        :id="id + '-select-employee'"
                                        _class="col-md-12"
                                        popOver="<h4>Belongs To</h4>
                                        <p>The Employee who 'owns' this Matter</p>"
                                        label="Belongs To"
                                        :ref="uniqueId + '-select-employee'" 
                                        :formRef="uniqueId + '-select-employee'"
                                    />                        
                                </div>

                                <div class="form-group row">
                                    <select-matter-type
                                        :id="id + '-select-matter-type'"
                                        _class="col-md-12"
                                        popOver="<h4>Matter Type</h4><p>The <em>Matter Type</em> indicates the <em>general</em> category this Matter falls under and what area of law may apply to it.</p>"
                                        title="The type of Matter"
                                        :ref="uniqueId + '-select-matter-type'" 
                                        :form-ref="uniqueId + '-select-matter-type'"
                                    />

                                </div>    

                                <div class="form-group row">

                                    <select-document-set
                                        :id="id + '-select-document-set'"
                                        _class="col-md-12"
                                        popOver="<h4>Document Set</h4><p>The <em>Document Set</em> defines the <em>specific</em> area of law this Matter is involved in and the Document Templates it uses to assemble Documents.</p>"
                                        title="The Documents used by this Matter"
                                        :ref="uniqueId + '-select-document-set'" 
                                        :form-ref="uniqueId + '-select-document-set'"
                                    />

                                </div>

                                <div class="form-group row">

                                    <select-language
                                        :id="id + '-select-language'"
                                        _class="col-md-12"
                                        popOver="<h4>Language</h4><p>The <em>default</em> Language the documents will be produced in.</p>
                                        <p>Note: The Language can be changed for individual Parties linked to the Matter so that a Party can receive Documents in their own language.</p>"
                                        title="The default Language used by this Matter"
                                        :ref="uniqueId + '-select-language'" 
                                        :form-ref="uniqueId + '-select-language'"
                                    />

                                </div>

                            </div>

                            <div class="col-md-6">

                                <div v-show="showStages() === true" class="form-group row">

                                    <select-stage-group
                                        :id="id + '-select-stage-group'"
                                        _class="col-md-12"
                                        popOver="<h4>Stage</h4>
                                        <p>The (default) group of Stages used by this Matter. These Stages will be displayed when selecting a Stage for this Matter.</p>"
                                        title="The (default) group of Stages used by this Matter"
                                        :ref="uniqueId + '-select-stage-group'" 
                                        :form-ref="uniqueId + '-select-stage-group'"
                                    />

                                </div>

                                <div v-show="showPlanOfAction() === true" class="form-group row">

                                    <select-plan-of-action
                                        :id="id + '-select-plan-of-action'"
                                        _class="col-md-12"
                                        popOver="<h4>Plan Of Action</h4>
                                        <p>The pre-defined Reminders for this Matter.</p>"
                                        title="The pre-defined Reminders for this Matter"
                                        :ref="uniqueId + '-select-plan-of-action'" 
                                        :form-ref="uniqueId + '-select-plan-of-action'"
                                    />

                                </div>

                                <div v-show="showExtraScreen() === true" class="form-group row">

                                    <select-extra-screen
                                        :id="id + '-select-extra-screen'"
                                        _class="col-md-12"
                                        popOver="<h4>Extra Screen</h4>
                                        <p>The <em>Matter Take On</em> screen for this Matter.</p>"
                                        title="The Matter Take On screen for this Matter"
                                        screenType="M"
                                        :ref="uniqueId + '-select-extra-screen'" 
                                        :form-ref="uniqueId + '-select-extra-screen'"
                                    />

                                </div>

                                <div v-show="showCauseOfAction() === true" class="form-group row">

                                    <select-cause-of-action
                                        :id="id + '-select-cause-of-action'"
                                        _class="col-md-12"
                                        popOver="<h4>Cause Of Action</h4>
                                        <p>The reason the property is being transfered.</p>"
                                        title="The reason the property is being transfered"
                                        :ref="uniqueId + '-select-cause-of-action'" 
                                        :form-ref="uniqueId + '-select-cause-of-action'"
                                    />

                                </div>

                                <div class="form-group row">

                                    <select-branch
                                        :id="id + '-select-branch'"
                                        :checkBox="true"
                                        _class="col-md-12"
                                        popOver="<h4>Branch</h4><p>A Matter may belong to a separate <em>Branch</em> within the Company.</p><p>Matters can be filtered by Branch to show Matters that belong to a certain Branch for reporting and accounting purposes.</p>"
                                        title="The Branch the Matter belongs to"
                                        :ref="uniqueId + '-matter-select-branch'" 
                                        :form-ref="uniqueId + '-matter-select-branch'"
                                    />

                                </div>

                            </div>

                        </div>

                    </fieldset> 

                </div>  

                <div v-show="activeTab === 'Parties'" :id="id + '-Parties-form-tab-content'" class="form-tab-content">

                    <matter-parties
                        :ref="uniqueId + '-matter-parties'"
                        :uniqueId="uniqueId"
                    />

                </div>  

                <div v-show="activeTab === 'Accounting'" :id="id + '-Accounting-form-tab-content'" class="form-tab-content">

                    <div class="row">

                        <div class="col-xxl-6">

                            <fieldset><legend>Settings</legend>

                                <div class="form-group row">

                                    <select-cost-centre
                                        :id="id + '-select-cost-centre'"
                                        _class="col-md-12"
                                        popOver="<h4>Cost Centre</h4>
                                        <p>Fees for this matter will be grouped by this Cost Centre.</p>"
                                        title="Fees for this matter will be grouped by this Cost Centre"
                                        :ref="uniqueId + '-select-cost-centre'" 
                                        :form-ref="uniqueId + '-select-cost-centre'"
                                    />

                                </div>

                                <div class="form-group row">

                                    <select-accounts-language
                                        :id="id + '-select-accounts-language'"
                                        label="Accounts Language"
                                        callback="accountsLanguageSelected"
                                        parentName="selectAccountsLanguage"
                                        _class="col-md-12"
                                        popOver="<h4>Accounts Language</h4>
                                        <p>The <em>Language</em> in which any Accounting documents will be printed.</p>"
                                        :ref="uniqueId + '-select-accounts-language'" 
                                        :form-ref="uniqueId + '-select-accounts-language'"
                                    />

                                </div>

                                <div class="form-group row">

                                    <select-trust-bank
                                        :id="id + '-select-trust-bank'"
                                        label="Trust Bank"
                                        callback="trustBankSelected"
                                        parentName="selectTrustBank"
                                        category="trustBankAccounts"
                                        _class="col-md-12"
                                        popOver="<h4>Trust Bank</h4>
                                        <p>The default Trust Bank account used by this Matter</p>"
                                        :ref="uniqueId + '-select-trust-bank'" 
                                        :form-ref="uniqueId + '-select-trust-bank'"
                                    />

                                </div>

                                <div class="form-group row">

                                    <select-business-bank
                                        :id="id + '-select-business-bank'"
                                        label="Business Bank"
                                        callback="businessBankSelected"
                                        parentName="selectBusinessBank"
                                        category="businessBankAccounts"
                                        _class="col-md-12"
                                        popOver="<h4>Business Bank</h4>
                                        <p>The default Business Bank Account used by this Matter</p>"
                                        :ref="uniqueId + '-select-business-bank'" 
                                        :form-ref="uniqueId + '-select-business-bank'"
                                    />

                                </div>

                            </fieldset>

                            <fieldset class="mt-3"><legend>Collection Commission</legend>

                                <div class="form-group row">
                                
                                    <div class="col-md-8">
                                        <label>Matter</label>
                                        <pop-over content="
                                                <h4>Collection Commission for the Matter</h4>
                                                <p>Charge a Fee for money recovered from the Debtor only (i.e. not the Client)</p>
                                                <p><strong>None</strong>: Do not charge collection commission.</p>
                                                <p><strong>Use Default</strong>: Charge the percent defined in the Settings.</p>
                                                <p><strong>Custom (Incl)</strong>: Charge a custom percent including VAT.</p>
                                                <p><strong>Custom (Excl)</strong>: Charge a custom percent excluding VAT.</p>"

                                        />
                                        <v-select
                                            title="Charge a Fee for money recovered from the Debtor only (i.e. not the Client)"
                                            :options="collCommOptions" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="collCommOptions => collCommOptions.value"
                                            v-model="record.collcommoption"
                                            @option:selected="collCommOptionChanged"
                                        />

                                    </div>

                                    <div class="mt-4 col-md-4">

                                        <b-form-checkbox
                                            :id="id + '-admin-fee'"
                                            v-model="record.collcommsplitflag"
                                            name="CollCommSplitFlag"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg">
                                            <span>Split?</span> 
                                            <pop-over content="
                                                <h4>Split</h4>
                                                <p>Collection commission will be displayed as 2 entries The 1st portion will be the debtors percent The 2nd portion will be the remaining percentage.</p>
                                            "/>
                                        </b-form-checkbox>

                                    </div>

                                </div> 
                                
                                <div v-show="record.collcommoption !== 'N'" class="form-group row">

                                    <text-input popOver="<h4>Percent</h4><p>The percent of the monies received to charge as Collection Commission</p>" inputGroup="%" label="Percent" _class="col-md-6" type="number" input-class="form-input-number" v-model="record.collcommpercent" name="collcommpercent" title="Collection Commission" />

                                    <text-input popOver="<h4>Limit</h4><p>The maximum amount of commission (when calculated as a percentage)</p>" label="Limit" _class="col-md-6" type="number" input-class="form-input-number" v-model="record.collcommlimit" name="collcommlimit" title="Maximum Collection Commission To Charge" />

                                </div> 

                                <div class="form-group row">
                                
                                    <div class="col-md-8">
                                        <label>Debtor</label>
                                        <pop-over content="
                                                <h4>Collection Commission for the Debtor</h4>
                                                <p>Charge the <em>Debtor</em> a fee for monies recovered in lieu of the debt.</p>
                                                <p><strong>None</strong>: Do not charge collection commission.</p>
                                                <p><strong>Use Default</strong>: Charge the percent defined in the Settings.</p>
                                                <p><strong>Custom (Incl)</strong>: Charge a custom percent including VAT.</p>
                                                <p><strong>Custom (Excl)</strong>: Charge a custom percent excluding VAT.</p>
                                                <p><strong>Schedule</strong>: Charge a percent based on dates defined in a Schedule.</p>"
                                        />
                                        <v-select
                                            title="Charge the debtor a collection commision fee for money recovered from the debtor"
                                            :options="debtorCollCommOptions" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="debtorCollCommOptions => debtorCollCommOptions.value"
                                            v-model="record.debtorcollcommoption"
                                            @option:selected="debtorCollCommOptionChanged"
                                        />

                                    </div>

                                </div> 

                                <div v-show="record.debtorcollcommoption !== 'N'" class="form-group row">

                                    <text-input popOver="<h4>Percent</h4><p>The percent of the monies received to charge as Collection Commission</p>" inputGroup="%" label="Percent" _class="col-md-6" type="number" input-class="form-input-number" v-model="record.debtorcollcommpercent" name="debtorcollcommpercent" ref="debtorcollcommpercent" title="Collection Commission" />

                                    <text-input popOver="<h4>Limit</h4><p>The maximum amount of commission (when calculated as a percentage)</p>" label="Limit" _class="col-md-6" type="number" input-class="form-input-number" v-model="record.debtorcollcommlimit" name="debtorcollcommlimit" ref="debtorcollcommlimit" title="Maximum Collection Commission To Charge" />
                                </div> 

                            </fieldset>

                        </div>

                        <div class="col-xxl-6 mt-xl-3 mt-xxl-0">

                            <fieldset><legend>Income Allocation</legend>

                                <div class="row mb-2">
                                    <div class="col-md-12">
                                        <span>Fees posted to Accounting </span>
                                        <span v-if="record.overrideincomeaccflag == '1'">will always use the following Account</span>
                                        <span v-else-if="$root.global.incomeaccoption === '0'">will be assigned to the Account specified in the Program Setting</span>
                                        <span v-else-if="$root.global.incomeaccoption === '1'">will be assigned to the Employee's Income Account</span>
                                        <span v-else-if="$root.global.incomeaccoption === '2'">will be assigned to the Account specified by the Cost Centre</span>
                                        <span v-else-if="$root.global.incomeaccoption === '3'">will be assigned to the Account specified by the Matter Type</span>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-12" title="Force the Fees to be posted to a specific Income Account">
                                        <b-form-checkbox
                                            :id="id + '-override-income-account'"
                                            v-model="record.overrideincomeaccflag"
                                            name="OverrideIncomeAccFlag"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            @change="overrideIncomeAccFlagChanged"
                                            >
                                            Override the Income Account?
                                        </b-form-checkbox>
                                    </div>
                                </div>

                                <div v-show="record.overrideincomeaccflag == '1'" class="form-group row mt-2">

                                    <select-income-account
                                        :id="id + '-select-income-account'"
                                        label="Income Account"
                                        callback="incomeAccountSelected"
                                        parentName="selectIncomeAccount"
                                        category="incomeAccounts"
                                        _class="col-md-12"
                                        popOver="<h4>Override Income Account</h4>
                                        <p>The Income Account the Fees will be posted to.</p>"
                                        :ref="uniqueId + '-select-income-account'" 
                                        :readOnly="record.overrideincomeaccflag == '0' ? true : false" 
                                        :form-ref="uniqueId + '-select-income-account'"
                                    />

                                </div>

                            </fieldset>
                            
                            <fieldset class="mt-3"><legend>Receipting</legend>

                                <div class="form-group row">
                                
                                    <div class="col-md-12">

                                        <label>Type</label>
                                        <pop-over content="
                                            <h4>Receipting Type</h4>
                                            <p>Specify how Receipts are handled for this Matter</p>
                                            "/>
                                        <v-select
                                            title="Specify how Receipts are handled for this Matter"
                                            :options="receiptingOptions" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="receiptingOptions => receiptingOptions.value"
                                            v-model="record.receiptoption"
                                        />

                                    </div>


                                </div>

                                <div class="form-group row">

                                    <text-input v-show="record.receiptoption == 4 || record.receiptoption == 5 " inputGroup="%" label="Percent" _class="col-md-6" type="number" input-class="form-input-number" v-model="record.receiptpercent" name="receiptpercent" title="The Amount Percent Receipts are limited to" />

                                    <text-input v-show="record.receiptoption == 2 || record.receiptoption == 5 " label="Amount" _class="col-md-6" type="number" input-class="form-input-number" v-model="record.receiptamount" name="receiptamount" title="The Amount Receipts are limited to" />

                                    <text-input v-show="record.receiptoption == 3 " :readOnly="true" label="Claim Amount" _class="col-md-6" type="number" input-class="form-input-number" v-model="record.claimamount" name="claimamount" title="The Claim Amount for this Receipt" />

                                </div>
                                
                            </fieldset>

                            <fieldset class="mt-3"><legend>Options</legend>
                                
                                <div class="form-group row">
                                
                                    <div class="col-md-8">
                                        <label>Agents Allowance</label>
                                        <pop-over content="
                                            <h4>Agents Allowance</h4>
                                            <p>Charge Agents Allowance on fees</p>
                                            "/>
                                        <v-select
                                            title="Charge Agents Allowance on fees"
                                            :options="agentOptions" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="agentOptions => agentOptions.value"
                                            v-model="record.agentflag"
                                        />

                                    </div>

                                    <text-input v-show="record.agentflag == 1 || record.agentflag == 2 " inputGroup="%" _class="mt-4 col-md-4" type="number" input-class="form-input-number" v-model="record.agentpercent" name="agentpercent" title="Charge Agents Allowance on this Matter at this rate"/>

                                </div>

                                <div class="form-group row">
                                
                                    <div class="col-md-8">

                                        <b-form-checkbox
                                            :id="id + '-admin-fee'"
                                            v-model="record.adminfeeflag"
                                            name="AdminFee"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg">
                                            <span>Charge Admin Fee</span> 
                                            <pop-over content="
                                                <h4>Charge Admin Fee</h4>
                                                <p>Charge the Client a monthly Admin Fee if there is any financial movement on this Matter?</p>
                                            "/>
                                        </b-form-checkbox>

                                    </div>
                                </div>

                                <div class="form-group row">
                                
                                    <div class="col-md-8">

                                        <b-form-checkbox
                                            :id="id + '-interest'"
                                            v-model="record.interestflag"
                                            name="Interest"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg">
                                            <span>Charge Interest</span>
                                            <pop-over content="
                                            <h4>Charge Interest</h4>
                                            <p>Charge the Client interest if his Account is overdue?</p>
                                            "/>
                                        </b-form-checkbox>

                                    </div>
                                </div>

                                <div class="form-group row">
                                
                                    <div class="col-md-8">

                                        <b-form-checkbox
                                            :id="id + '-investment-fee'"
                                            v-model="record.investmentfeeflag"
                                            name="InvestmentFee"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg">
                                            <span>Charge Investment Fee</span>
                                            <pop-over content="
                                            <h4>Charge Investment Fee</h4>
                                            <p>Investment Handling Fee - This is charged when interest is added to an investment</p>
                                            "/>
                                        </b-form-checkbox>

                                    </div>
                                </div>

                                <div class="form-group row">
                                
                                    <div class="col-md-12">

                                        <b-form-checkbox
                                            :id="id + '-agreed-fee'"
                                            v-model="record.agreedfeeflag"
                                            name="AgreedFee"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg">
                                            <span>Charge an Agreed Fee?</span>
                                            <pop-over content="
                                            <h4>Charge an Agreed Fee?</h4>
                                            <p>The Client has negotiated a set percentage of any receipts as their fee for this Matter</p>
                                        "/>
                                        </b-form-checkbox>

                                    </div>
                                </div>

                                <div v-show="record.agreedfeeflag == '1'" class="form-group row">
                                    <div class="mt-1 col-md-3" title="The Agreed Fee is limited to the Debtor's outstanding costs">
                                        <b-form-checkbox
                                            :id="id + '-agreed-fee-limit'"
                                            v-model="record.agreedfeelimit"
                                            name="AgreedFeeLimit"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg">
                                            <span>Limit?</span>
                                        </b-form-checkbox>

                                    </div>

                                    <text-input  inputGroup="%" _class="col-md-5" type="number" input-class="form-input-number" v-model="record.agreedfeepercent" name="agreedfeepercent" title="Percentage of the Receipt (incl VAT) to generate as a fee(as agreed with the Client)" />

                                </div>    

                                <div class="form-group row">
                                
                                    <div class="col-md-8">
                                        <label>Vat Rate</label>
                                        <pop-over content="
                                            <h4>Vat Rate</h4>
                                            <p>You can set the Matter to 'Zero Rated' for overseas clients, etc</p>
                                        "/>
                                        <v-select
                                            :options="vatRate" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="vatRate => vatRate.value"
                                            v-model="record.vatexemptflag"
                                            title="You can set the Matter to 'Zero Rated' for overseas clients, etc"
                                        />

                                    </div>

                                </div>

                            </fieldset>

                        </div>

                    </div>

                    <div class="row">

                        <div class="col-md-12">
                            <fieldset class=""><legend>Invoice</legend>

                                <div class="form-group row">
                                    <radio-buttons 
                                    :popOver="`<h4>Create</h4>
                                        <p>Invoice (1) - Regular accounting invoice using posted transactions
                                        <br>Proforma Account (2) - A proforma invoice including unposted Fee Notes
                                        <br>None (0) - Do not create invoices for this Matter</p>`"
                                    _class="col-md-12" 
                                    :record="record" 
                                    column="invoiceflag" 
                                    :buttons="[
                                        {value:'1', text: 'Invoice'},
                                        {value:'2', text: 'Proforma Account'},
                                        {value:'0', text: 'None'},
                                    ]" 
                                    name="invoiceflag" 
                                    label="Create" 
                                    @change="invoiceFlagChanged"
                                    />
                                </div>

                                <div class="form-group row">
                                
                                    <div class="col-md-4">
                                        <label>Balance</label>                                        <pop-over content="
                                            <h4>Balance</h4>
                                            <p>Invoice shows BFwd Balance or all transactions on statement</p>
                                            "/>
                                        <v-select
                                            :options="invoiceBFwd" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="invoiceBFwd => invoiceBFwd.value"
                                            v-model="record.invoicebfwdoption"
                                            />

                                    </div>

                                </div>

                            </fieldset>

                            <fieldset class="mt-3"><legend>Fees</legend>

                                <div class="form-group row">
                                
                                    <div class="col-md-8">
                                        <label>Layout</label>                                        <pop-over content="
                                            <h4>Fee Layout</h4>
                                            <p>Itemised - Show the amount next to each fee. Essay Style - Show all fees with one total. Totals Only - Show a total for all fees</p>
                                            "/>
                                        <v-select
                                            :options="invoiceFee" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="invoiceFee => invoiceFee.value"
                                            v-model="feeSettings.feeOption"
                                        />

                                    </div>

                                    <div v-show="feeSettings.feeOption == '0' || feeSettings.feeOption == '1'" class="mt-4 col-md-4">

                                        <b-form-checkbox
                                            :id="id + '-fee-summarize'"
                                            v-model="feeSettings.feeSummarizeFlag"
                                            name="FeeSummarizeFlag"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>Summarise</span>
                                            <pop-over content="
                                            <h4>Summarise</h4>
                                            <p>Summarise fees with the same description
                                            or fees posted to the same ledger account</p>
                                            "/>
                                        </b-form-checkbox>

                                    </div> 

                                </div>

                                <div v-show="feeSettings.feeOption == '1'" class="form-group row">

                                    <div class="col-md-6">
                                        <label>Fee Separator</label>
                                            <pop-over content="
                                            <h4>Fee Separator</h4>
                                            <p>Separate fees with semi-colon or print each fee on a separate line</p>
                                            "/>
                                        <v-select
                                            :options="separatorOptions" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="separatorOptions => separatorOptions.value"
                                            v-model="feeSettings.feeSeparatorOption"
                                        />

                                    </div>

                                </div>

                            </fieldset>

                            <fieldset class="mt-3"><legend>Disbursements</legend>    

                                <div class="form-group row">
                                
                                    <div class="col-md-8">
                                        <label>Layout</label>
                                            <pop-over content="
                                            <h4>Disbursement Layout</h4>
                                            <p>Itemised - Show the amount next to each Disbursement</p>
                                            <p>Essay Style - Show all Disbursements with one total</p>
                                            <p>Totals Only - Show a total of all the Disbursements</p>
                                            <p>Creditors Itemised - Total Business Disbursements but Itemise Creditors Disbursements</p>
                                            "/>
                                        <v-select
                                            :options="disbursementFee" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="disbursementFee => disbursementFee.value"
                                            v-model="disbursementSettings.disbursementOption"
                                        />

                                    </div>

                                    <div v-show="disbursementSettings.disbursementOption == '0' || disbursementSettings.disbursementOption == '1'" class="mt-4 col-md-4">

                                        <b-form-checkbox
                                            :id="id + '-disbursement-summarize'"
                                            v-model="disbursementSettings.disbursementSummarizeFlag"
                                            name="disbursementSummarizeFlag"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>Summarise</span>
                                            <pop-over content="
                                            <h4>Summarise</h4>
                                            <p>Summarise disbursements with the same description
                                            or disbursements posted to the same ledger account</p>
                                            "/>
                                        </b-form-checkbox>

                                    </div> 

                                    <div v-show="disbursementSettings.disbursementOption == '2' " class="mt-4 col-md-4">

                                        <b-form-checkbox
                                            :id="id + '-separate-creditor-disbursement-option'"
                                            v-model="disbursementSettings.separateCreditorDisbursementOption"
                                            name="separateCreditorDisbursementOption"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>Separate Creditor Disbursements</span>
                                            <pop-over content="
                                            <h4>Separate Creditor Disbursements</h4>
                                            <p>Separate the Creditor and Business disbursements</p>
                                            "/>
                                        </b-form-checkbox>

                                    </div> 

                                </div>

                                <div v-show="disbursementSettings.disbursementOption == '1'" class="form-group row">

                                    <div class="col-md-6">
                                        <label>Disbursement Separator</label>
                                            <pop-over content="
                                            <h4>Disbursement Separator</h4>
                                            <p>Separate disbursement with semi-colon or print each disbursement on a separate line</p>
                                            "/>

                                        <v-select
                                            :options="separatorOptions" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="separatorOptions => separatorOptions.value"
                                            v-model="disbursementSettings.disbursementSeparatorOption"
                                        />


                                    </div>

                                    <div class="mt-4 col-md-6">

                                        <b-form-checkbox
                                            :id="id + '-itemise-creditor-disbursement-option'"
                                            v-model="disbursementSettings.itemiseCreditorDisbursementOption"
                                            name="itemiseCreditorDisbursementOption"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>Itemise Creditor Transactions</span>
                                            <pop-over content="
                                            <h4>Itemise Creditor Transactions</h4>
                                            <p>Leave disbursements to creditors as itemised transactions.</p>
                                            "/>
                                        </b-form-checkbox>

                                    </div> 
                                </div>

                            </fieldset>

                        </div>


                    </div>

                    <div class="mt-3 row">

                        <div class="col-md-6">

                            <fieldset class=""><legend>Consolidation</legend>

                                <div class="form-group row">
                                
                                    <div class="col-md-10">
                                        <label>Method</label>

                                        <pop-over content="
                                        <h4>Consolidation Method</h4>

                                        <p><strong>Consolidate Balance Only</strong></p>
                                        <p>Balance are transfered to the consolidated account.
                                        The client for this Account is invoiced.</p>

                                        <p><strong>Full Consolidation</strong></p>
                                        Transfers the balance of the individual Matter and creates one consolidated Invoice.</p>

                                        <p><strong>Consolidation Account</strong></p>
                                        <p>Other Matters are consolidated to this Account.</p>
                                        "/>

                                        <v-select
                                            :options="consolidatedOptions" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="consolidatedOptions => consolidatedOptions.value"
                                            v-model="record.consolidatedflag"/>

                                    </div>

                                </div>

                                <div v-show="record.consolidatedflag == '1' || record.consolidatedflag == '2'" class="form-group row">
                                    
                                        <select-consolidate-matter  
                                            _class="col-md-10"
                                            popOver="<h4>Consolidate To</h4>
                                            <p>Consolidate transactions to this Matter</p>
                                            <p>The Client will receive and Invoice/Statement for the Consolidated Matter with the Fees and Disbursements included from this Matter.</p>"
                                            callback="consolidateMatterSelected"
                                            :clearIcon="true"
                                            parentName="selectConsolidateMatter"
                                            label="Consolidate To"
                                            :id="id + '-select-consoidate-matter'" 
                                            :ref="id + '-select-consoidate-matter'" 
                                            :formRef="id + '-select-consoidate-matter'"/>
                                    </div>

                                

                                <div v-show="record.consolidatedflag == '4'" class="form-group row">
                                
                                    <div class="col-md-10">

                                        <b-form-checkbox
                                            :id="id + '-consolidation-option'"
                                            v-model="record.consolidationoption"
                                            name="consolidationOption"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>Print transactions for each matters on a separate page</span>
                                            <pop-over content="
                                            <h4>Print transactions for each matters on a separate page</h4>
                                            <p>The transactions for each matter will be printed on a separate page.</p>
                                            "/>
                                        </b-form-checkbox>
                                    </div>

                                </div>

                            </fieldset>

                            <fieldset class="mt-3"><legend>Third Party</legend>
                                
                                <div class="form-group row">
                                
                                    <div class="col-md-10">

                                        <b-form-checkbox
                                            :id="id + '-invoice-party'"
                                            v-model="invoicePartyFlag"
                                            name="invoicePartyFlag"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            @change="invoicePartyFlagChanged"
                                            >
                                            <span>Invoice Alternate Party</span>
                                            <pop-over content="
                                            <h4>Invoice Alternate Party</h4>
                                            <p>By default an invoice is sent to the Client.
                                            You can override this by selecting an alternate Party from this Matter</p>"
                                            />
                                        </b-form-checkbox>
                                    </div>

                                </div>

                                <div v-show="invoicePartyFlag == '1'" class="form-group row">

                                        <select-invoice-party
                                            _class="col-md-12"
                                            :id="id + '-select-invoice-party'"
                                            label="Party"
                                            popOver="<h4>Party</h4>
                                            <p>Select a Party to send the Invoice to.</p>"
                                            callback="invoicePartySelected"
                                            parentName="selectInvoiceParty"
                                            :ref="uniqueId + '-select-invoice-party'"
                                            :formRef="uniqueId + '-select-invoice-party'"
                                            :matterId="record.recordid"
                                        />
                                    </div>

                            </fieldset>

                        </div>

                        <div class="col-md-6">  

                            <fieldset class=""><legend>Invoice Options</legend>
                            
                                <div class="form-group row">
                                
                                    <div class="col-md-12">

                                        <b-form-checkbox
                                            :id="id + '-consolidate-disbursement'"
                                            v-model="record.consolidatedisbursementflag"
                                            name="consolidateDisbursement"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>Do Not Combine Fees</span>
                                            <pop-over content="
                                            <h4>Do Not Combine Fees</h4>
                                            <p>Do not combine fees (that are marked in the fee sheet) together for this matter?</p>
                                            "/>
                                        </b-form-checkbox>

                                    </div>
                                </div>

                                <div class="form-group row">
                                
                                    <div class="col-md-12">

                                        <b-form-checkbox
                                            :id="id + '-exclude-units-on-account'"
                                            v-model="record.excludeunitsonaccount"
                                            name="excludeUnitsOnAccount"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>Exclude Units</span>
                                            <pop-over content="
                                            <h4>Exclude Units</h4>
                                            <p>Remove unit portion from description on invoice transactions.
                                            i.e the bracket portion will be removed
                                            e.g  Telephone call (20 min) will become Telephone call</p>
                                            "/>
                                        </b-form-checkbox>

                                    </div>
                                </div>

                                <div class="form-group row">
                                    <div class="col-md-12">

                                        <b-form-checkbox
                                            :id="id + '-override-invoice'"
                                            v-model="record.overrideinvoice"
                                            name="overrideInvoice"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>Override Invoice Layout</span>
                                            <pop-over content="
                                            <h4>Override Invoice Layout</h4>
                                            <p></p>
                                            "/>
                                        </b-form-checkbox>
                                    </div>

                                </div>

                                <div class="form-group row">
                                    
                                    <radio-buttons 
                                    :popOver="`<h4>Type of case</h4>
                                        <p>Action or Application</p>`"
                                    _class="col-md-12" 
                                    :record="colData" 
                                    column="formatOption" 
                                    :boxedFlag="true"
                                    :buttons="[
                                        {value:'0', text: 'Print Invoice & Statements'},
                                        {value:'1', text: 'Print Invoices as Statements'},
                                    ]" 
                                    name="formatOption" 
                                    label="Print Options" 
                                    
                                    />
                                </div>

                                <div class="form-group row">
                                
                                    <div class="col-md-12">

                                        <b-form-checkbox
                                            :id="id + '-separate-invoice'"
                                            v-model="record.separateinvoice"
                                            name="separateInvoice"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>Separate Invoice and Statements</span>
                                            <pop-over content="
                                            <h4>Separate Invoice and Statements</h4>
                                            <p></p>
                                            "/>
                                        </b-form-checkbox>
                                    </div>

                                </div>

                                <div class="form-group row">
                                
                                    <div class="col-md-12">

                                        <b-form-checkbox
                                            :id="id + '-separate-pages'"
                                            v-model="record.separatepages"
                                            name="separatePages"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>Print on Separate Pages</span>
                                            <pop-over content="
                                            <h4>Print on Separate Pages</h4>
                                            <p></p>
                                            "/>
                                        </b-form-checkbox>
                                    </div>

                                </div>

                                <div class="form-group row">
                                
                                    <div class="col-md-12">

                                        <b-form-checkbox
                                            :id="id + '-show-vat'"
                                            v-model="record.showvat"
                                            name="showVat"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>Show the VAT</span>
                                            <pop-over content="
                                            <h4>Show the VAT</h4>
                                            <p></p>
                                            "/>
                                        </b-form-checkbox>
                                    </div>

                                </div>

                                </fieldset>

                        </div>
                    </div>



                </div>

                <div v-show="activeTab === 'Litigation'" :id="id + '-Litigation-form-tab-content'" class="form-tab-content">
                    <div class="row">

                        <div class="col-xxl-6">

                            <fieldset><legend>Litigation</legend>
                            
                                <div class="form-group row">

                                    <text-input  
                                    _class="col-md-6" 
                                    type="number" 
                                    input-class="form-input-number" 
                                    v-model="record.casenumber" 
                                    name="casenumber" 
                                    label="Case Number"
                                    popOver="<h4>Case Number</h4>
                                        <p>The Case Number of this Matter</p>"
                                    />

                                </div>

                                <div class="form-group row">
                                    <radio-buttons 
                                    :popOver="`<h4>Type of case</h4>
                                        <p>Action or Application</p>`"
                                    _class="col-md-12" 
                                    :record="colData" 
                                    column="casetype" 
                                    :buttons="[
                                        {value:'Act', text: 'Action'},
                                        {value:'App', text: 'Application'},
                                    ]" 
                                    name="casetype" 
                                    label="Type of case" 
                                    
                                    />
                                </div>
                            
                                <div class="form-group row">
                                    <radio-buttons 
                                    :popOver="`<h4>We act for</h4>
                                        <p>Who we are acting for?</p>`"
                                    _class="col-md-12" 
                                    :record="colData" 
                                    column="actingfor" 
                                    :buttons="[
                                        {value:'P', text: 'Plaintiff'},
                                        {value:'D', text: 'Defendant'},
                                    ]" 
                                    name="actingfor" 
                                    label="We act for" 
                                    />
                                </div>
                            
                                <div class="form-group row">
                                    <radio-buttons 
                                    :popOver="`<h4>Court</h4>
                                        <p>Which court is the Matter being heard in?</p>`"
                                    _class="col-md-12" 
                                    :record="colData" 
                                    column="courtflag" 
                                    :buttons="[
                                        {value:'M', text: 'District'},
                                        {value:'R', text: 'Regional'},
                                        {value:'H', text: 'High'},
                                    ]" 
                                    name="courtflag" 
                                    label="Court" 
                                    />
                                </div>
                            
                                <div class="form-group row">
                                    <radio-buttons 
                                    :popOver="`<h4>Status</h4>
                                        <p>Is the Matter defended or undefended</p>`"
                                    _class="col-md-12" 
                                    :record="colData" 
                                    column="defended" 
                                    :buttons="[
                                        {value:'U', text: 'Undefended'},
                                        {value:'D', text: 'Defended'},
                                    ]" 
                                    name="defended" 
                                    label="Status" 
                                    />
                                </div>

                                <div class="form-group row">
                                    <select-debtor-fee-sheet
                                        :id="id + '-select-debtor-feesheet'"
                                        callback="debtorFeeSheetSelected"
                                        parentName="selectDebtorFeeSheet"
                                        _class="col-md-12"
                                        label="Debtor's Fee Sheet"
                                        popOver="<h4>Debtor's Fee Sheet</h4><p>The Fee Sheet used to debit the Debtor.</p>"
                                        title="The Debtor's Fee Sheet"
                                        :ref="uniqueId + '-matter-debtor-select-feesheet'" 
                                        :form-ref="uniqueId + '-matter-debtor-select-feesheet'"
                                    />

                                </div>
                                <div class="form-group row">
                                    <text-input
                                    _class="col-md-6" 
                                    type="number" 
                                    input-class="form-input-number" 
                                    v-model="record.claimamount" 
                                    name="claimamount" 
                                    label="Claim Amount"
                                    popOver="<h4>Claim Amount</h4>
                                        <p>The Claim Amount for this Matter</p>"
                                    />

                                </div>

                                <div class="form-group row">
                                    <text-input
                                    inputGroup="%"   
                                    _class="col-md-6" 
                                    type="number" 
                                    input-class="form-input-number" 
                                    v-model="record.interestrate" 
                                    name="interestrate" 
                                    label="Interest"
                                    popOver="<h4>Interest</h4>
                                        <p>The interest charged on the claim by the Plaintiff</p>"
                                    />

                                    <div class="col-md-6">

                                        <label>From</label>

                                        <pop-over content="
                                        <h4>Interest From</h4>
                                        <p>The date from which interest can be calculated</p>
                                        "/>

                                        <date-picker 
                                        :readOnly="record.readOnly ? true: false" 
                                        ref="interestFromDatePickerComponent" 
                                        v-model="record.formattedinterestfrom" 
                                        :config="$root.datePickerOptions"/>

                                    </div>

                                </div>

                                <div class="form-group row">

                                    <div class="col-md-6">

                                        <label>Court Date</label>

                                        <pop-over content="
                                        <h4>Court Date</h4>
                                        <p>The date the Matter has been Set Down</p>
                                        "/>

                                        <date-picker 
                                        v-model="colData.formattedcourtdate" 
                                        :readOnly="record.readOnly ? true: false" 
                                        ref="courtDatePickerComponent" 
                                        :config="$root.datePickerOptions"/>

                                    </div>

                                </div>

                                <div class="form-group row">
                                    <div class="col-md-12">
                            
                                        <b-form-checkbox
                                            :id="id + '-nca-flag'"
                                            v-model="record.ncaflag"
                                            name=":NCAFlag"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>The National Credit Act applies to this Matter</span>
                                            <pop-over content="
                                                <h4>The National Credit Act applies to this Matter?</h4>
                                                <p>Does this Matter fall under the National Credit Act?</p>
                                            "/>
                                        </b-form-checkbox>

                                    </div>

                                </div> 
                            
                                <div class="form-group row">
                                    <div class="col-md-12">
                            
                                        <b-form-checkbox
                                            :id="id + '-attorney-client-flag'"
                                            v-model="colData.attorneyclientflag"
                                            name="attorneyClientFlag"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>Debtor charged on the Attorney/Client scale</span>
                                            <pop-over content="
                                                <h4>Debtor charged on the Attorney/Client scale</h4>
                                                <p>This will add costs that are marked as 'Attorney/Client' to the Litigation Documents when assembled.</p>
                                            "/>
                                        </b-form-checkbox>

                                    </div>

                                </div> 

                                <div class="form-group row">
                                                                <text-input
                                    _class="col-md-12" 
                                    v-model="colData.popupreminder"
                                    type="text" 
                                    input-class="form-input-text" 
                                    name="popupreminder" 
                                    label="Popup Reminder"
                                    popOver="<h4>Popup Reminder</h4>
                                        <p>Show this message whenever the User views the Debtor's Account</p>"
                                    />

                                </div>

                            </fieldset>

                        </div>

                        <div class="col-xxl-6 mt-xl-3 mt-xxl-0">

                            <fieldset><legend>PTP Details</legend>

                                <div class="form-group row">

                                    <text-input
                                    _class="col-md-8" 
                                    type="number" 
                                    input-class="form-input-number" 
                                    v-model="record.debtorpaymentamount" 
                                    name="debtorpaymentamount" 
                                    label="Amount"
                                    popOver="<h4>Amount</h4>
                                        <p>The debtor has made a committment to pay this amount weekly or monthly</p>
                                        <p>If a different amount is receipted, a warning will pop up</p>"
                                    />

                                </div>

                                <div class="form-group row">                            
                                
                                    <div class="col-md-8">
                                        <label>Frequency</label>

                                        <pop-over content="
                                            <h4>Frequency</h4>
                                            <p>Specify when, and how often, the Debtor has promised to make payments.</p>"
                                        />

                                        <v-select
                                            :options="debtorPaymentFrequency" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="debtorPaymentFrequency => debtorPaymentFrequency.value"
                                            v-model="record.debtorpaymentfrequency"
                                        />

                                    </div>

                                    <text-input
                                    v-show="debtorPaymentFrequency == '2' || debtorPaymentFrequency == '4'"
                                    _class="col-md-4" 
                                    type="number" 
                                    input-class="form-input-number" 
                                    v-model="record.debtorpaymentday" 
                                    name="debtorpaymentday" 
                                    label="Day"
                                    popOver="<h4>Day</h4>
                                        <p>The day of the month the payment will be made on (insert 31 if last day of every month)</p>"
                                    />

                                </div>

                                <div class="form-group row">

                                    <div class="col-md-8">

                                        <label>Starting From</label>

                                        <pop-over content="
                                        <h4>Starting From</h4>
                                        <p>The date when the payments began or the effective date</p>
                                        "/>

                                        <date-picker 
                                        :readOnly="record.readOnly ? true: false" 
                                        v-model="colData.formattedptpstartdate" 
                                        ref="courtDatePickerComponent" 
                                        :config="$root.datePickerOptions"/>

                                    </div>
                                </div>

                                <div class="form-group row">                            
                                
                                    <div class="col-md-12">
                                        <label>Method of Payment</label>

                                        <pop-over content="
                                        <h4>Method of Payment</h4>
                                        <p>How the PTP is being paid.</p>
                                        "/>
                            
                                        <v-select
                                            :options="ptpPaymentMethod" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="ptpPaymentMethod => ptpPaymentMethod.value"
                                            v-model="colData.ptppaymentmethod"
                                        />

                                    </div>

                                </div>

                            </fieldset>
                            
                            <fieldset v-show="isRafMatter() === false" class="mt-3"><legend>Debtor Payment Options (Debtors Account)</legend>

                                <div class="form-group row">
                                    <text-input
                                    inputGroup="%"   
                                    _class="col-md-8" 
                                    type="number" 
                                    input-class="form-input-number" 
                                    v-model="record.receiptpercenttocosts" 
                                    name="receiptpercenttocosts" 
                                    label="Receipt Percent To Costs"
                                    popOver="<h4>Receipt Percent To Costs</h4>
                                        <p>What percentage of the Debtors receipt goes to cover Costs first.</p>
                                        <p>The remaining percent goes to the Client or reduces the Capital</p>"
                                    />
                                </div>
                                
                                <div class="form-group row">

                                    <text-input
                                    _class="col-md-8" 
                                    type="number" 
                                    input-class="form-input-number" 
                                    name="payattorneyfirstamount" 
                                    v-model="record.payattorneyfirstamount" 
                                    label="Pay Off these Costs First"
                                    popOver="<h4>Pay Off these Costs First</h4>
                                        <p>Any receipts by the debtor will first go to paying off this amount (optional)</p>"
                                    />

                                </div>

                            </fieldset>


                        </div>

                    </div>
                </div>

                <div v-show="activeTab === 'DebtorsAccount'" :id="id + '-DebtorsAccount-form-tab-content'" class="form-tab-content">

                    <debtors-account
                        :ref="uniqueId + '-debtors-account'"
                        :uniqueId="uniqueId"
                    />

                </div>

                <div v-show="activeTab === 'Miscellaneous'" :id="id + '-Miscellaneous-form-tab-content'" class="form-tab-content">
                    <div class="row">

                        <div class="col-md-6">

                            <fieldset class=""><legend>Sundry Settings</legend>

                                <div class="form-group row">

                                    <select-billing-rate
                                        :id="id + '-select-billing-rate'"
                                        _class="col-md-12"
                                        label="Default Billing Rate"
                                        popOver="<h4>Default Billing Rate</h4>
                                        <p>The Time Billing Rate nomally used on this Matter.</p>"
                                        title="Select a Billing Rate"
                                        :ref="uniqueId + '-select-billing-rate'" 
                                        :form-ref="uniqueId + '-select-billing-rate'"
                                        :clearIcon="true"
                                    />

                                </div>

                                <div v-show="showFeeEstimate() === true" class="form-group row">

                                    <text-input 
                                    _class="col-md-8" 
                                    type="number" 
                                    input-class="form-input-number" 
                                    v-model="record.feeestimate" 
                                    name="feeestimate" 
                                    label="Fee Estimate"
                                    popOver="<h4>Fee Estimate</h4>
                                            <p>An estimate (or promise) of the total amount of Fees and Disbursements that can be expected to be charged on this Matter.</p>
                                            <p>This is useful if a Client has been given an estimate.</p>
                                            <p>A warning can be set to notify the user if the Fees posted to Accounting exceed this amount.</p>"
                                    />

                                    <div class="col-md-12">

                                        <b-form-checkbox
                                            :id="id + '-fee-estimate-warning'"
                                            v-model="record.feeestimatewarningflag"
                                            name="feeEstimateWarningFlag"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>Display a warning if the Fees exceed the Fee Estimate</span>

                                            <pop-over content="
                                            <h4>Fee Estimate Warning</h4>
                                            <p>If the Fees for this Matter exceed the Fee Estimate, you will receive a warning.</p>
                                            <p>This can be useful if a Client has received a quotation and the fees now exceed that amount.</p>
                                            "/>

                                        </b-form-checkbox>

                                    </div>

                                </div>

                                <div v-show="showAccess() === true" class="form-group row">

                                    <div class="col-md-12">

                                        <label>Access</label>
                                        <pop-over content="
                                                    <h4>Access</h4>
                                                    <p>Can other Employees access this Matter?</p>
                                                    "/>
                                        <v-select
                                            :options="matterAccessOptions" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="matterAccessOptions => matterAccessOptions.value"
                                            v-model="record.access"
                                        />

                                    
                                    </div>
                                </div>

                                <div v-show="showFilingCabinet() === true" class="form-group row">
                                    
                                    <text-input 
                                    _class="col-md-12"  
                                    v-model="record.filecabinet" 
                                    name="filecabinet" 
                                    label="Filing Cabinet"
                                    popOver="<h4>Filing Cabinet</h4>
                                            <p>A further reference to help locate this Matter</p>"
                                    />

                                </div>

                                <div class="form-group row">

                                    <div class="col-md-8">

                                        <label>Important Date</label>

                                        <pop-over content="
                                        <h4>Important Date</h4>
                                        <p>A date linked to a Matter that can be used for any purpose by the user (e.g. in a document or as a filter for some reports).</p>
                                        "/>
                                        <date-picker :readOnly="record.readOnly ? true: false" ref="datePickerComponent" v-model="record.formattedimportantdate" :config="$root.datePickerOptions"/>

                                    </div>

                                </div>  
                                
                                <div v-show="isCollectionsMatter() === false" class="form-group row">
                                
                                    <text-input  
                                    _class="col-md-8" 
                                    type="number" 
                                    input-class="form-input-number" 
                                    v-model="record.claimamount" 
                                    name="claimamount" 
                                    label="Claim Amount"
                                    popOver="<h4>Claim Amount</h4>
                                        <p>The Claim Amount for this Matter</p>"
                                    />

                                </div> 

                                <div class="form-group row">

                                    <text-input 
                                    inputGroup="%"
                                    _class="col-md-8" 
                                    type="number" 
                                    input-class="form-input-number" 
                                    v-model="record.discountsurcharge" 
                                    name="discountsurcharge" 
                                    label="Discount/Surcharge"
                                    popOver="<h4>Discount/Surcharge</h4>
                                        <p>The discount or surcharge applied to the fee sheet for this matter</p>"
                                    />

                                </div> 

                                <div v-show="showPrescribesOn() === true" class="form-group row">

                                    <div class="col-md-6">

                                        <label>Prescribes On</label>

                                        <pop-over content="
                                        <h4>Prescribes On</h4>
                                        <p>The date this matter can no longer be heard in court or whose legal status</p>
                                        <p>will become invalid or unenforcable by the process of prescription.</p>
                                        "/>
                                        <date-picker :readOnly="record.readOnly ? true: false" ref="datePickerComponent" v-model="record.formattedprescriptiondate" :config="$root.datePickerOptions"/>

                                    </div>

                                </div>

                                <div v-show="showPrescribesOn() === true" class="form-group row">

                                    <div class="col-md-12">

                                        <b-form-checkbox
                                            :id="id + '-prescription-warning'"
                                            v-model="record.showprescriptionwarningflag"
                                            name="showprescriptionwarningflag"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>Display a warning if Matter is due to prescribe?</span>
                                            <pop-over content="
                                            <h4>Prescription Warning</h4>
                                            <p>Display a message warning the user that the Matter is due to / has prescribed?</p>
                                            "/>
                                        </b-form-checkbox>

                                    </div>

                                </div>  

                            </fieldset>

                        </div>

                        <div class="col-md-6">

                            <fieldset><legend>Status</legend>

                                <div class="form-group row">                            
                                
                                    <div class="col-md-10">
                                        <label>Current Status</label>

                                        <pop-over content="
                                        <h4>Archive Status</h4>
                                        <p><strong>Live</strong> indicates that the Matter has not been Archived.</p>
                                        <p><strong>Pending</strong> indicates that the Matter will be Archived after the next Month End (if it has no unposted Transactions).</p>
                                        <p><strong>Archived</strong> indicates that the Matter is Archived.</p><p>Note: An Archived Matter can be <em>unarchived</em> if necessary (by setting it back to <strong>Live</strong>).</p>
                                        "/>

                                        <v-select
                                            :options="archiveStatus" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="archiveStatus => archiveStatus.value"
                                            v-model="record.archivestatus"
                                            @option:selected="archiveStatusChanged"
                                        />

                                    </div>

                                </div>

                                <div v-show="record.archiveflag == '1' && record.formattedarchivedate" class="form-group row">

                                    <text-input 
                                    _class="col-md-6" 
                                    v-model="record.formattedarchivedate" 
                                    :readOnly="true"
                                    name="archivedate" 
                                    label="Archived On"
                                    popOver="<h4>Archive Date</h4>
                                        <p>The date the Matter was Archived.</p>"
                                    />

                                </div>
                                
                                <div v-show="record.archiveflag == '1' && parseInt(record.archiveno) > 0" class="form-group row">

                                    <text-input 
                                    _class="col-md-6" 
                                    v-model="record.archiveno" 
                                    :readOnly="true"
                                    name="archiveno" 
                                    label="Archive Number"
                                    popOver="<h4>Archive Number</h4>
                                        <p>The unique number used to identify this Matter if it has been archived.</p>"
                                    />

                                </div>    

                            </fieldset>

                            <fieldset class="mt-3"><legend>Fica</legend>
                                <div class="form-group row">
                                    
                                    <div class="col-md-12">

                                        <b-form-checkbox
                                            :id="id + '-fica-flag'"
                                            v-model="record.noficaflag"
                                            name="noFicaFlag"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>This Matter is exempt from Fica</span>
                                            <pop-over content="
                                            <h4>Fica</h4>
                                            <p>This Matter will not be checked for FICA compliance</p>
                                            "/>
                                        </b-form-checkbox>
                                    </div>
                                </div>   
                            </fieldset>

                            <fieldset class="mt-3"><legend>Groups Belonged To</legend>

                                <mat-group-table
                                    :id="uniqueId + '-mat-group-form-table'"
                                    :ref="uniqueId + '-mat-group-table'"
                                    :table-id="uniqueId + '-mat-group-table'"
                                    :lazyLoadFlag="true"
                                    :formTable="true"
                                    :searchInputFocus="false"
                                />

                            </fieldset>

                        </div>

                    </div>      

                    <div class="row">

                        <div class="col-md-12">

                            <fieldset class="mt-3"><legend>General</legend>

                                <div class="form-group row">
                                    <text-area 
                                    _class="col-md-12"
                                    popOver="<h4>General Remarks</h4>
                                    <p>General remarks regarding this Matter</p> 
                                    <p>These can appear on reports to Client (500 characters long)</p>"
                                    rows="6" 
                                    cols="50" 
                                    v-model="record.remarks" 
                                    name="remarks" 
                                    label="Remarks"
                                    
                                    :lookupLibraryFlag="true"
                                    lookupLibraryCategory="General remarks regarding this Matter "
                                    />
                                </div>

                            </fieldset>
                            
                            <fieldset class="mt-3"><legend>Accounting</legend>

                                <div class="form-group row">
                                
                                    <div class="col-md-6">
                                        <label>Display</label>
                                        <pop-over content="
                                        <h4>Display Accounting Message</h4>
                                        <p>A message for the accounts department</p>
                                        <p>Can be used to alert the bookeeper when working on this Matter</p>
                                        <p>(250 characters long).</p>
                                        "/>
                                        <v-select
                                            :options="accountingMessageDisplay" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="accountingMessageDisplay => accountingMessageDisplay.value"
                                            v-model="record.commentoption"
                                            title=""
                                        />

                                    </div>

                                </div>

                                <div class="form-group row">
                                    <text-area 
                                    _class="col-md-12"
                                    popOver="<h4>Accounting Message</h4>
                                    <p>A message for the accounts department</p>
                                    <p>Can be used to alert the bookeeper when working on this Matter</p>
                                    <p>(250 characters long)</p>"
                                    rows="6" 
                                    cols="50" 
                                    v-model="record.accountcomment" 
                                    name="accountComment" 
                                    label="Message"
                                    title=""
                                    :lookupLibraryFlag="true"
                                    lookupLibraryCategory="A message for the accounts department"
                                    />
                                </div>

                            </fieldset>
                            
                            <fieldset class="mt-3"><legend>Internal</legend>

                                <div class="form-group row">
                                
                                    <div class="col-md-6">
                                        <label>Display</label> 
                                        <pop-over content="
                                        <h4>Display Internal Comment</h4>
                                        <p>This message is displayed to the user when they access this Matter</p>
                                        <p>None -The message is not displayed</p>
                                        <p>Popup - The message pops up when the Matter is accessed.</p>
                                        "/>
                                        <v-select
                                            :options="internalMessageDisplay" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="internalMessageDisplay => internalMessageDisplay.value"
                                            v-model="record.internalcommentoption"
                                            title=""
                                        />

                                    </div>

                                </div>

                                <div class="form-group row">
                                    <text-area
                                    _class="col-md-12"
                                    rows="6" 
                                    cols="50" 
                                    popOver="<h4>Internal Comment</h4>
                                    <p>Comment for internal use</p>
                                    <p>It can be used to alert an Employee to a specific issue with the Matter or Client when they access this Matter</p>"
                                    v-model="record.internalcomment" 
                                    name="internalComment" 
                                    label="Comment"
                                    title=""
                                    :lookupLibraryFlag="true"
                                    lookupLibraryCategory="Comment for internal use"
                                    />
                                </div>

                            </fieldset>        
                        </div>
                    </div>    

                    <div v-show="editing && record.updatedbyid && record.updatedbydate && record.updatedbytime" class="row mt-3">
                        <div class="col-md-12">
                            <div class="alert alert-danger" v-html="getUpdatedByDetails()"/>
                        </div>
                    </div>


                </div>

                <div v-show="activeTab === 'Extra'" :id="id + '-Extra-form-tab-content'" class="form-tab-content">

                    <fieldset 
                        v-bind:key="extraScreen.recordid" v-for="(extraScreen, index) in extraScreens" 
                        :class="index > 0 ? 'mt-3 extra-screen-container' : 'extra-screen-container'"
                    >
                        <legend v-html="extraScreen.screentitle + ' (' + extraScreen.recordid + ')'"></legend>
                        <div :id="'extra-screen-form-container-' + extraScreen.recordid">
                            <form action="#" :id="'extra-screen-form-' + extraScreen.recordid"/>
                        </div>
                    </fieldset>

                </div>

            </div>

            
            <div class="modal-footer justify-content-between">
                    <div>
                        <button v-show="activeTab == 'General'" class="btn btn-large btn-primary mr-2" type="button" @click="deleteClicked">
                            <span title="Delete this Matter"><i class="fa fa-trash fa-lg mr-2"></i>Delete</span>
                        </button>
                        <button v-show="activeTab == 'General' && editing" class="btn btn-large btn-danger mr-2" type="button" @click="emailClient">
                            <span title="Send an Email to this Matter's Client"><i class="fa fa-envelope-o fa-lg mr-2"></i>Email</span>
                        </button>
                        <button v-show="activeTab == 'General' && editing" class="btn btn-large btn-secondary" type="button" @click="generateDocument">
                            <span title="Generate a Document for this Matter"><i class="fa fa-cog fa-lg mr-2"></i>Document</span>
                        </button>
                    </div>
                    <div>
                        <button class="btn btn-yellow form-button mr-3" @click="okClicked(false)" type="button" title="Save the Matter and continue editing"><i class="fa fa-check-square fa-lg mr-2"></i>Save</button>
                        <button class="btn btn-success form-button mr-3" @click="okClicked(true)" type="button" title="Save the Matter and close"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>
                        <button v-if="savedFlag || editing" class="btn btn-danger form-button" type="button" @click="closeForm" data-dismiss="modal" title="Close this form"><i class="fa fa-times-circle fa-lg mr-2"></i>Close</button>
                        <button v-else class="btn btn-danger form-button" type="button" @click="closeForm" data-dismiss="modal" title="Exit without saving"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
                    </div>
            </div>


        </div>

    </div>


</div>

</template>

<script>

import { mapMutations } from 'vuex';
import formTemplate from "@pages/form-template";
import modalTemplate from "@components/modals/modal-template";
import extraScreenTemplate from "@pages/extra-screen-template";

export default {

    mixins: [formTemplate, extraScreenTemplate, modalTemplate],

    components: {
        SelectConsolidateMatter: () => import("@pages/matters/SelectMatter"),
        SelectMatterClient: () => import("@pages/parties/SelectParty"),
        SelectMatterType: () => import("@pages/matters/SelectMatterType"),
        SelectDocumentSet: () => import("@pages/document-sets/SelectDocumentSet"),
        SelectBranch: () => import("@pages/matters/SelectBranch"),
        SelectStageGroup: () => import("@pages/matters/SelectStageGroup"),
        SelectBillingRate: () => import("@pages/matters/SelectBillingRate"),
        SelectTrustBank: () => import("@pages/matters/SelectAccount"),
        SelectBusinessBank: () => import("@pages/matters/SelectAccount"),
        SelectIncomeAccount: () => import("@pages/matters/SelectAccount"),
        SelectEmployee: () => import("@pages/employees/SelectEmployee"),
        SelectCostCentre: () => import("@pages/matters/SelectCostCentre"),
        SelectCauseOfAction: () => import("@pages/matters/SelectCauseOfAction"),
        SelectExtraScreen: () => import("@pages/matters/SelectExtraScreen"),
        SelectCostCentre: () => import("@pages/matters/SelectCostCentre"),
        SelectLanguage: () => import("@pages/matters/SelectLanguage"),
        SelectAccountsLanguage: () => import("@pages/matters/SelectLanguage"),
        SelectPlanOfAction: () => import("@pages/matters/SelectPlanOfAction"),
        SelectClientFeeSheet: () => import("@pages/feesheets/SelectFeeSheet"),
        SelectDebtorFeeSheet: () => import("@pages/feesheets/SelectFeeSheet"),
        SelectInvoiceParty: () => import("@pages/parties/SelectMatParty"),
        MatGroupTable: () => import("@pages/matters/MatGroupTable"),
        MatterParties: () => import("@pages/matters/MatterParties"),
        DebtorsAccount: () => import("@pages/debtors-account/DebtorsAccount"),
    },

    props: {
        resource: {type: String, default: 'Matter' },
        secProc: {type: String, default: 'Matters - Update' },
        uniqueId: String,
    },

    data() {
        return {
            saveArchiveStatus: null,
            matPartyTable: null,
            matGroupTable: null,
            colData: {},
            conveyData: {},
            party: {},
            bondData: {},
            docgenData: {},
            clientName: '',
            matterTakeOnReminder: '',
            matterPartiesTable: null,
            matterCounter: 1,
            matterAccessOptions : [ 
                {value:'O', label: 'Open To All' }, 
                {value:'V', label: 'View Only' }, 
                {value:'R', label: 'Restricted' }, 
            ],
            receiptingOptions : [ 
                {value:'0', label: 'Normal'},
                {value:'1', label: 'Reserve All Receipts'},
                {value:'2', label: 'Reserve Up To An Amount'},
                {value:'3', label: 'Reserve Up To Claim Amount'},
                {value:'4', label: 'Reserve a Percentage'},
                {value:'5', label: 'Reserve a Percent Up To'},
            ],
            agentOptions : [ 
                {value:'0', label: 'None'},
                {value:'1', label: 'Use Default'},
                {value:'2', label: 'Custom'},
            ],
            collCommOptions : [ 
                {value:'N', label: 'None'},
                {value:'U', label: 'Use Default'},
                {value:'C', label: 'Custom (Excl)'},
                {value:'I', label: 'Custom (Incl)'},
            ],
            debtorCollCommOptions : [ 
                {value:'N', label: 'None'},
                {value:'U', label: 'Use Default'},
                {value:'C', label: 'Custom (Excl)'},
                {value:'I', label: 'Custom (Incl)'},
                {value:'S', label: 'Schedule'},
            ],
            vatRate : [ 
                {value:'0', label: 'Standard'},
                {value:'2', label: 'Zero Rated'},
                {value:'1', label: 'Vat Exempt'},
            ],
            invoiceBFwd : [ 
                {value:'1', label: 'Brought Forward'},
                {value:'2', label: 'Full'},
                
            ],
            invoiceFee : [ 
                {value:'0', label: 'Itemised'},
                {value:'1', label: 'Essay Style'},
                {value:'2', label: 'Totals Only'},
                
            ],
            archiveStatus : [ 
                {value:'0', label: 'Live'},
                {value:'1', label: 'Pending'},
                {value:'2', label: 'Archived'},
                
            ],
            // 'Monthly|#1|Every 3 Months|#3|Weekly|#2|Bi-Weekly|#4|Every 6 Months|#5'
            debtorPaymentFrequency : [ 
                {value:'1', label: 'Monthly'},
                {value:'2', label: 'Weekly'},
                {value:'3', label: 'Every 3 Months'},
                {value:'4', label: 'Bi-Weekly'},
                {value:'5', label: 'Every 6 Months'},
                
            ],
            // 'Cash|#Cash|Cheque|#Cheque|Credit Card|#Credit Card|Debit Order|#Debit Order|EFT|#EFT|Other|#Other'
            ptpPaymentMethod : [ 
                {value:'Cash', label: 'Cash'},
                {value:'Cheque', label: 'Cheque'},
                {value:'Credit Card', label: 'Credit Card'},
                {value:'Debit Order', label: 'Debit Order'},
                {value:'EFT', label: 'EFT'},
                {value:'Other', label: 'Other'},
                
            ],

            disbursementFee : [ 
                {value:'0', label: 'Itemised'},
                {value:'1', label: 'Essay Style'},
                {value:'2', label: 'Totals Only'},
                {value:'3', label: 'Creditors Itemised'},
                
            ],

            separatorOptions : [ 
                {value:'0', label: 'Separated by a semi-colon'},
                {value:'1', label: 'Each on a new line'},
                
            ],
            accountingMessageDisplay : [ 
                {value:'0', label: 'Default'},
                {value:'1', label: 'Popup'},
                
            ],
            internalMessageDisplay : [ 
                {value:'0', label: 'Default'},
                {value:'1', label: 'Popup'},
                
            ],

            consolidatedOptions : [ 
                // 'No Consolidation|#0|Full Consolidation|#1|Consolidate Balance Only|#2|Consolidation Account|#4'
                {value:'0', label: 'No Consolidation'},
                {value:'1', label: 'Full Consolidation'},
                {value:'2', label: 'Consolidate Balance Only'},
                {value:'4', label: 'Consolidation Account'},
                
            ],
            feeSettings : { 
                feeOption: '0',
                feeSeparatorOption : '0',
                feeSummarizeFlag: '0',

            },
            disbursementSettings : { 
                disbursementOption : '0',
                separateCreditorDisbursementOption : '0',
                disbursementSummarizeFlag: '0',
                itemiseCreditorDisbursementOption: '0',
                disbursementSeparatorOption: '0'

            },

            activeTab: null,
            tabs: [
                {
                    pageName: "General",
                    title: "Details",
                    iconClass: '',
                    visible: true,
                    active: true,
                },
                {
                    pageName: "Parties",
                    title: "Parties",
                    iconClass: '',
                    visible: true,
                    active: false,
                },
                {
                    pageName: "Accounting",
                    title: "Accounting",
                    iconClass: '',
                    visible: true,
                    active: false,
                },
                {
                    pageName: "Litigation",
                    title: "Litigation",
                    iconClass: '',
                    visible: true,
                    active: false,
                },
                {
                    pageName: "DebtorsAccount",
                    title: "Debtors Account",
                    iconClass: '',
                    visible: true,
                    active: false,
                },
                {
                    pageName: "Miscellaneous",
                    title: "Miscellaneous",
                    iconClass: '',
                    visible: true,
                    active: false,
                },
            ],
            
            invoicePartyFlag:null,
            invoiceFlagSelected:null,
        };
    },

    computed: {

        matterType() {
            return this.record.mattertypeid;
        },

        documentSet() {
            return this.record.docgenid;
        },

    },

    watch: {

        activeTab(newValue) {

            // Restrict tabbing to the tab contents
            $('#' + this.id + "-" + newValue + "-form-tab-content").tabGuard();
            //console.log("Length of the activeTab contents",$('#' + this.id + "-" + newValue + "-form-tab-content").length);

            if ( newValue === "Miscellaneous" ) {
                
                setTimeout(() => {

                    if ( this.matGroupTable.table ) {

                        this.matGroupTable.table.columns.adjust;

                    } else {

                        this.matGroupTable.loadDataTable( this.adjustMatGroupTableColumns ); 

                    }

                },100);

            } else if ( newValue === "Parties" ) {
                
                setTimeout(() => {

                    if ( this.matterPartiesTable.table ) {

                        this.matterPartiesTable.table.columns.adjust;

                    } else {

                        this.matterPartiesTable.loadDataTable( this.adjustMatPartiesTableColumns ); 

                    }

                },100);

            } else if ( newValue === "DebtorsAccount" ) {
                
                setTimeout(() => {

                    if ( this.debtorsAccountTable.table ) {

                        this.debtorsAccountTable.table.columns.adjust;

                    } else {

                        this.debtorsAccountTable.loadDataTable( this.adjustDebtorsAccountTableColumns ); 

                    }

                },100);

            } else if ( newValue === "Extra" ) {

                this.showExtraScreens();

            }

        }
    },

    methods: {

        ...mapMutations(['setCurrentMatter', 'setCurrentColData']),

        editRecord(id, createdNewMatterFlag = false) {

            this.matterTakeOnReminder = '';

            this.litigationTab = this.tabs.filter(tab => tab.pageName === 'Litigation')[0];
            this.debtorsAccountTab = this.tabs.filter(tab => tab.pageName === 'DebtorsAccount')[0];

            this.setGeneralTab();

            this.clearData();

            this.editing = true;

            this.action = 'update';

            axios.post('/matter/get/' + id)

            .then(response => {

                if ( response.data.errors ) {

                    showError('Error', response.data.errors);

                } else {

                    this.record = response.data.data[0];

                    this.saveArchiveStatus = this.record.archivestatus;

                    this.record.updatedbyid = this.record.loggedinemployeeid = root.loggedInEmployeeId;

                    this.clientName = this.record.partymatterprefix + '-' + this.record.partyname; 

                    this.setFeeAndDisbursementOptions();

                    this.setCurrentMatter(this.record);

                    this.setCurrentColData({
                        matterid: null,
                        emofirstdate: null,
                        emoamount: null,
                        emocommissionpercent: null,
                    });

                    this.displayForm(); 

                    setTimeout(() => {
                        this.initializeFormTables();

                        // Need this otherwise popovers don't work if taking on a Matter (the first time)
                        $('#' + this.id + " .popover-icon").popover();

                    }, 100);


                    

                    this.setDocgenData()

                    .then( (docgenResponse) => {

                        this.docgenData = docgenResponse;

                        this.litigationTab.visible = this.debtorsAccountTab.visible = this.isCollectionsMatter();

                        this.getSiblingRecords()

                        .then( () => {

                            axios.post("/party/get/" +  this.record.clientid )

                            .then(response => {

                                if (response.data.errors) {

                                    showError( 'Error getting Matter\'s Client data', response.data.errors);

                                } else {

                                    this.party = response.data.data.length ? response.data.data[0] : {};

                                    if (createdNewMatterFlag) {
                                        this.record.description = this.createMatterDescription();
                                    }

                                    this.initFormData();

                                }

                            }).catch( (error) => {
                                showError('Error getting Client data', error); 
                            });


                        }).catch( (error) => {
                            showError('Error',error)
                        });

                    }).catch( (error) => {
                        showError('Error',error)
                    });

                }

            }).catch( (error) => {
                showError('Error getting Matter', error); 
            });

        },

        async initNewRecord(clientId) {

            this.closeForm();

            root.$snotify.simple('Please wait...', 'Creating Matter', { timeout: 10000, icon: 'img/cogs.gif' });

            this.matterTakeOnReminder = '';

            this.setGeneralTab();

            this.clearData();

            this.setTableComponent();   
            
            this.table.unHighlightAllRows();

            this.editing = false;

            this.action = 'store';

            this.record = {
                clientid: clientId,
                loggedinemployeeid: root.loggedInEmployeeId,
            };

            axios.post( '/matter/store', this.record)

            .then(response => {

                root.$snotify.clear();

                if (response.data.errors) {

                    showError('Error creating Matter', response.data.errors); 

                } else {

                    if ( response.data.data.length) {

                        this.checkTakeOnReminder(clientId);

                        this.highlightRow(response.data.data[0].recordid, {
                            where: "matter.fileref,<,'" + response.data.data[0].fileref + "'",
                            orderBy: 'FileRef'
                        });

                        this.editRecord(response.data.data[0].recordid, true);

                    } else {

                        showError('Error creating Matter', 'Record not created. No data returned'); 

                    }

                }

            }).catch( error => {
                root.$snotify.clear();
                showError('Error saving Matter', error); 
            });

        },

        async initFormData() {

            this.initExtraScreens();

            this.$refs.datePickerComponent.elem.data('DateTimePicker').widgetPositioning(
                { horizontal: 'right', vertical: 'bottom' }
            );            


            // ***********************************
            // Prime Drop Downs
            // ***********************************

            //console.log("Prime Drop Downs this.record.consolidateid",typeof this.record.consolidateid,this.record.consolidateid);

            if ( this.record.consolidateid && this.record.consolidateid != '0' ) {

                axios.post("/matter/get",  { 
                    select: ['matter.fileref','matter.description'],
                    whereRaw: "matter.recordid = " + this.record.consolidateid,
                }).then(response => {

                    if (response.data.errors) {

                        showError( 'Error getting Consolidated Matter', response.data.errors);

                    } else {

                        if ( !response.data.data.length ) {

                            showError( 'Error getting Consolidated Matter', 'No Consolidated Matter returned');

                        } else {

                            this.selectConsolidateMatter.matter = {
                                id: this.record.consolidateid,
                                fileref: htmlDecode(response.data.data[0].fileref),
                                description: htmlDecode(response.data.data[0].description),
                            };
                        }
                    }

                }).catch( (error) => {
                    showError('Error getting Consolidated Matter', error); 
                });

            } else {
                this.selectConsolidateMatter.matter = {};
            }

            this.selectConsolidateMatter.callingComponent = this;

            this.selectTrustBank.record = {
                id: this.record.trustbankid,
                description: htmlDecode(this.record.trustbankdescription),
            };

            this.selectBusinessBank.record = {
                id: this.record.businessbankid,
                description: htmlDecode(this.record.businessbankdescription),
            };

            this.selectIncomeAccount.record = {
                id: this.record.incomeaccid,
                description: htmlDecode(this.record.incomeaccountdescription),
            };

            this.selectClientFeeSheet.record = {
                id: this.record.clientfeesheetid,
                description: htmlDecode(this.record.clientfeesheetdescription),
            };
            

            this.selectDebtorFeeSheet.record = {
                id: this.record.debtorfeesheetid,
                description: htmlDecode(this.record.debtorfeesheetdescription),
            };


            if ( this.record.branchflag === '1' ) {

                this.selectBranch.record = {
                    id: this.record.branchid,
                    description: htmlDecode(this.record.branchdescription),
                };


                this.selectBranch.preventSelectionFlag = false;

                if ( parseInt(this.record?.fnbmatterstate) > 0 ) {
                    this.selectBranch.preventSelectionFlag = true;
                    this.selectBranch.preventSelectionMessage = 'The Matter has an FNB Matter State';
                } else if ( this.record?.absalinkflag == '1' ) {
                    this.selectBranch.preventSelectionFlag = true;
                    this.selectBranch.preventSelectionMessage = 'The Matter uses AbsaLink.';
                } else if (this.record?.weblinkbankref) {
                    this.selectBranch.preventSelectionFlag = true;
                    this.selectBranch.preventSelectionMessage = 'The Matter uses WebLink';
                }



            } else {

                this.selectBranch.record = {
                    id: null,
                    description: null,
                };

            }

           this.selectInvoiceParty.partyName = this.record.invoicepartyname;

            this.selectDocumentSet.record = {
                id: this.record.docgenid,
                description: htmlDecode(this.record.docgendescription),
            };

            this.selectMatterType.record = {
                id: this.record.mattertypeid,
                description: htmlDecode(this.record.mattypedescription),
            };

            this.selectStageGroup.record = {
                recordid: this.record.stagegroupid,
                description: htmlDecode(this.record.stagegroupdescription),
            };

            this.selectEmployee.record = {
                recordid: this.record.employeeid,
                name: htmlDecode(this.record.employeename),
            };

            this.selectCostCentre.record = {
                id: this.record.costcentreid,
                description: htmlDecode(this.record.costcentredescription),
            };

            this.selectLanguage.record = {
                id: this.record.documentlanguageid,
                description: htmlDecode(this.record.documentlanguagedescription),
            };

            this.selectAccountsLanguage.record = {
                id: this.record.accountslanguageid,
                description: htmlDecode(this.record.accountslanguagedescription),
            };

            this.selectPlanOfAction.record = {
                id: this.record.todogroupid,
                description: htmlDecode(this.record.planofactiondescription),
            };

            this.selectBillingRate.record = {
                recordid: this.record.defaultbillingrateid,
                description: htmlDecode(this.record.billingratedescription),
            };

            this.selectExtraScreen.record = {};

            if ( this.record?.extrascreenid ) {
                this.selectExtraScreen.record = {
                    recordid: this.record.extrascreenid,
                    description: htmlDecode(this.record.extrascreendescription),
                };
            }



        },


        initializeFormTables() {

            root.getFormHeight(this.id,'.form-tab-body')

            .then( (formHeight) => {

                // ***********************************
                // Debtors Account Table
                // ***********************************

                this.debtorsAccountTable = this.$refs[this.uniqueId + '-debtors-account'].table;

                this.debtorsAccountTable.debtorsBalance = null; // Shown at the footer of the table

                this.debtorsAccountTable.table = null; // Reset to NULL so the ActiveTab watch reloads the table
                this.debtorsAccountTable.subTitle = this.record.fileref + ' - ' + this.record.description;

                // Custom report template
                this.debtorsAccountTable.reportTemplateId = root.lolSettings.debtorsaccounttemplateid;

                this.debtorsAccountTable.matterId = this.record.recordid; 

                this.debtorsAccountTable.tableOptions = {
                    paging: true,
                    displayBuffer: 1000,
                    ordering: false,
                    actionColumnWidth: 15,
                    scrollY: (formHeight - 220)  + 'px',

                    createdRow: ( row, data ) => {
                        setDebtorsAccountRowColor(row, data);
                    },

                    displayActionButtonFunction: (data) => {
                        return data?.type == 'A' || data?.type == 'Z' ? false : true;
                    },

                    actionButtonTextFunction: (data) => {
                        return data?.type == 'I' || data?.type == 'X' || data?.type == 'V' ? 'View' : 'Edit';
                    },

                    actionButtonClassFunction: (data) => {
                        return data?.type == 'I' || data?.type == 'X' || data?.type == 'V' ? 'primary' : 'success';
                    },

                };

                // ***********************************
                // Matter Parties Table
                // ***********************************

                this.matterPartiesTable = this.$refs[this.uniqueId + '-matter-parties'].table;
                this.matterPartiesTable.table = null; // Reset to NULL so the ActiveTab watch reloads the table
                this.matterPartiesTable.subTitle = this.record.fileref + ' - ' + this.record.description;

                //Order by Role and Sorter (hidden columns in table)
                this.matterPartiesTable.initialOrder = [[10, "asc"],[11, "asc"]];

                this.matterPartiesTable.whereRaw = ["MatParty.MatterId = " + this.record.recordid]; 

                this.matterPartiesTable.tableOptions = {
                    actionColumnWidth: 15,
                    scrollY: (formHeight - 220)  + 'px',
                };

                // ***********************************
                // MatGroup Table
                // ***********************************
                this.matGroupTable = this.$refs[this.uniqueId + '-mat-group-table'];
                this.matGroupTable.table = null; // Reset to NULL so the ActiveTab watch reloads the table
                this.matGroupTable.subTitle = this.record.matterprefix + ' - ' + this.record.name;
                this.matGroupTable.noEditButtonFlag = true;

                this.matGroupTable.whereRaw = ["MatGroup.MatterId = " + this.record.recordid]; 

                // Set the table Height 
                this.matGroupTable.tableOptions = {
                    scrollY: (formHeight * 0.5) + 'px',
                };


            }).catch( (error) => {
                showError('Error',error)
            });

        },

        createMatterDescription() {

            if ( root.currentEmployee.defaultmatterdescription ) {

                return this.evaluateRecord(root.currentEmployee.defaultmatterdescription)
                
            } else {
                
                let separator = root.currentEmployee.autodescriptionseparator ? root.currentEmployee.autodescriptionseparator : '-';
                return this.party.name + ' ' + separator + ' New Matter';

            }

        },

        setDocgenData() {

            return new Promise((resolve, reject) => {

                this.docgenData = {};

                axios.post("/docgen/get/" + this.record.docgenid)
                
                .then(response => {

                    if (response.data.errors) {

                        reject(response.data.errors);

                    } else {

                        if ( !response.data.data.length ) {

                            reject('Error getting Docgen data - No Docgen data returned');

                        } else {

                            resolve( response.data.data[0]);

                        }

                    }

                }).catch( (error) => {
                    reject('Error getting Docgen data: ' +error ); 
                });

            });


        },

        getSiblingRecords() {

            return new Promise(async (resolve) => {

                if ( this.isCollectionsMatter() ) {
                    
                    await this.getColData();

                } else if ( this.isConveyancingMatter() ) {

                    await this.getBondData();
                    await this.getConveyData();

                }

                resolve();
            });

        },

        getColData() {

            axios.post("/coldata/get",  { where: "coldata.matterid,=," + this.record.recordid })
            
            .then(response => {

                if (response.data.errors) {

                    showError( 'Error getting Collections data', response.data.errors);

                } else {

                    if ( !response.data.data.length ) {

                        this.colData.matterid = this.record.recordid;
                        this.colData.casetype = 'Act';
                        this.colData.actingfor = 'P';
                        this.colData.courtflag = 'M';
                        this.colData.defended = 'U';
                        this.colData.attorneyclientflag = 0;

                        this.saveColData()

                        .then( (data) => {

                            this.colData = data;

                            // Need this in debtorsAccountForm
                            this.setCurrentColData({
                                matterid: this.colData.matterid,
                                emofirstdate: this.colData.emofirstdate,
                                emoamount: this.colData.emoamount,
                                emocommissionpercent: this.colData.emocommissionpercent,
                            });


                        }).catch( (error) => {

                            showError( 'Error getting Collections data', error);
                            
                        });

                    } else {

                        this.colData = response.data.data[0];

                        // Need this in debtorsAccountForm
                        this.setCurrentColData({
                            matterid: this.colData.matterid,
                            emofirstdate: this.colData.emofirstdate,
                            emoamount: this.colData.emoamount,
                            emocommissionpercent: this.colData.emocommissionpercent,
                        });

                    }

                }

            }).catch( (error) => {
                showError('Error getting ColData data', error); 
            });

        },

        getBondData() {

            axios.post("/bonddata/get",  { where: "bonddata.matterid,=," + this.record.recordid })
            
            .then(response => {

                if (response.data.errors) {

                    showError( 'Error getting Bond data', response.data.errors);

                } else {

                    if ( !response.data.data.length ) {

                        this.saveBondData()

                        .then( (data) => {

                            this.bondData = data;

                        }).catch( (error) => {

                            showError( 'Error getting Bond data', error);
                            
                        });

                    } else {

                        this.bondData = response.data.data[0];

                    }

                }

            }).catch( (error) => {
                showError('Error getting Bond data', error); 
            });

        },

        getConveyData() {

            axios.post("/conveydata/get",  { where: "conveydata.matterid,=," + this.record.recordid })

            .then(response => {

                if (response.data.errors) {

                    showError( 'Error getting Convey data', response.data.errors);

                } else {

                    if ( !response.data.data.length ) {

                        this.saveConveyData()

                        .then( (data) => {

                            this.conveyData = data;

                        }).catch( (error) => {

                            showError( 'Error getting Convey data', error);
                            
                        });

                    } else {

                        this.conveyData = response.data.data[0];

                    }

                    if ( this.conveyData?.bondcauseid ) {

                        this.selectCauseOfAction.record = {
                            recordid: this.conveyData.bondcauseid,
                            description: htmlDecode(this.conveyData.bondcausedescription),
                        };
                    }

                }

            }).catch( (error) => {
                showError('Error getting Convey data', error); 
            });

        },

        async okClicked( closeFlag = true ) {

            // Check any required Extra Screen Fields
            if ( this.extraScreensVisibleFlag ) {

                let requiredField = await this.checkExtraScreenRequiredFields();

                if ( requiredField ) {
                    
                    this.setExtraScreenTab();                    

                    return;

                }

                //The only write back Tables are Matter, MatParty, ColData, BondData, ConveyData
                //Only add this to the Matter Form and MatParty Form
                await this.checkExtraWriteBackFields();

            }

            root.$snotify.simple('Please wait...', 'Saving Matter', { timeout: 10000, icon: 'img/cogs.gif' });

            this.saveMatter()

            .then( (matter) => {

                this.highlightRow(matter.recordid, {
                    where: "matter.fileref,<,'" + matter.fileref + "'",
                    orderBy: 'FileRef'
                });

                this.setCurrentMatter(this.record);

                this.saveExtraScreens(); //Only does it if the user has clicked on the Extra Screen Tab

                if ( this.isCollectionsMatter() ) {

                    this.saveColData()

                    .then( () => {

                        root.$snotify.clear();
                        if ( closeFlag ) {
                            this.closeForm();
                        } else {
                            this.savedFlag = true;
                        }

                    }).catch( () => {
                        root.$snotify.clear();
                    });

                } else if ( this.isConveyancingMatter() ) {

                    this.saveBondData()

                    .then( () => {

                        this.saveConveyData()

                        .then( () => {

                            root.$snotify.clear();

                            if ( closeFlag ) {
                                this.closeForm();
                            } else {
                                this.savedFlag = true;
                            }

                        }).catch( () => {
                            root.$snotify.clear();
                        });

                    }).catch( () => {
                        root.$snotify.clear();
                    });

                } else {

                    root.$snotify.clear();

                    if ( closeFlag ) {
                        this.closeForm();
                    } else {
                        this.savedFlag = true;
                    }

                }

            }).catch( ( error ) => {

                showError('Error updating Matter', error);

                root.$snotify.clear();
            });

        },
        

        saveMatter() {

            return new Promise(async (resolve, reject) => {

                try {   

                    this.record.archivedate = this.record.formattedarchivedate;
                    this.record.dateinstructed = this.record.formatteddateinstructed;
                    this.record.importantdate = this.record.formattedimportantdate;
                    this.record.interestfrom = this.record.formattedinterestfrom;
                    this.record.prescriptiondate  = this.record.formattedprescriptiondate;
                
                    //this.record.branchflag = this.selectBranch.record.recordid ? '1' : '0';

                    this.updateFeeAndDisbursementOptions();

                    this.record.loggedinemployeeid = root.loggedInEmployeeId;

                    let response = await axios.post( '/matter/' + (this.savedFlag ? 'update' : 'store'), this.record)

                    if (response.data.errors) { 

                        showError('Error saving Matter', response.data.errors); 
                        reject();

                    } else {

                        this.record.recordid = response.data.data[0].recordid;

                        this.errors = {};

                        resolve(response.data.data[0]);

                    }

                } catch(error) { 

                    showError('Error saving Matter', error); 

                    reject();
                };
                
            });

        },

        saveColData() {

            return new Promise(async (resolve, reject) => {

                try {

                    this.colData.courtdate = this.colData?.formattedcourtdate;
                    this.colData.ptpstartdate = this.colData?.formattedptpstartdate;

                    let response = await axios.post('/coldata/' + (this.savedFlag ? 'update' : 'store'), this.colData)

                    if (response.data.errors) { 
                        reject(response.data.errors);
                    } else {

                        this.colData.recordid = response.data.data[0].recordid;

                        resolve( response.data.data[0]);
                    }

                } catch(error) { 
                    reject(error);
                };
                    
            });
        },

        saveBondData() {

            return new Promise(async (resolve, reject) => {

                try {

                    let response = await axios.post('/bonddata/' + (this.savedFlag ? 'update' : 'store'), this.bondData)

                    if (response.data.errors) { 
                        reject(response.data.errors);
                    } else {

                        this.bondData.recordid = response.data.data[0].recordid;

                        resolve( response.data.data[0]);
                    }

                } catch(error) { 
                    reject(error);
                };
                    
            });
        },

        saveConveyData() {

            return new Promise(async (resolve, reject) => {

                try {

                    let response = await axios.post('/conveyData/' + (this.savedFlag ? 'update' : 'store'), this.conveyData)

                    if (response.data.errors) { 

                        reject(response.data.errors);

                    } else {

                        this.conveyData.recordid = response.data.data[0].recordid;

                        resolve( response.data.data[0]);
                    }


                } catch(error) { 
                    reject(error);
                };

            });
        },

        checkTakeOnReminder(id) {

            axios.post("/party/get",  {
                select: 'party.mattertakeonreminder',
                whereRaw: 'party.recordid = ' + id
            })
            
            .then(response => {

                if ( response.data.errors ) {

                    showError('Error', '<p>An error was encountered getting the Matter Take On Reminder from the Client</p><p>' + response.data.errors + '</p>');

                } else {

                    if ( response.data.data[0].mattertakeonreminder ) {

                        this.matterTakeOnReminder = response.data.data[0].mattertakeonreminder

                        root.$snotify.clear();
                        root.$snotify.simple(response.data.data[0].mattertakeonreminder, 'Reminder', { timeout: 3000, icon: 'img/check.png' });

                    }

                }

            }).catch( (error) => {
                showError('Error checking Matter take on reminder', error); 
            });

        },

        clearData() {

            this.docgenData = this.party = this.colData = this.bondData = this.conveyData = {};
            
            this.selectCauseOfAction.record = {};

        },

        isCollectionsMatter() {

            return this.docgenData?.type == 'LIT' && this.docgenData?.code != 'AMO' ? true : false;
        },

        isRafMatter() {

            return this.docgenData?.code == 'RAF' ? true : false;
        },

        isBondMatter() {

            return this.docgenData?.type == 'BON' ? true : false;
        },

        isTransfersMatter() {

            return this.docgenData?.type == 'TRN' ? true : false;
        },

        isConveyancingMatter() {

            return this.docgenData?.type == 'BON' || this.docgenData?.type == 'TRN' ? true : false;
        },

        showCauseOfAction() {
            return this?.record.docgenid == root.control.transfersdocgenid ? true : false;
        },

        //console.log('docgenData flags',
        // this.docgenData.hideaccessflag, 
        // this.docgenData.hideprescribesonflag, 
        // this.docgenData.hidefilingcabinetflag, 
        // this.docgenData.hidefeeestimateflag, 

        showAccess() {
            return this.docgenData?.hideaccessflag == "1" ? false : true;
        },

        branchFlagChanged(value) {

            this.record.branchflag = value;

            console.log("branchFlagChanged",this.record.branchflag);

            if ( this.record.branchflag === '1' ) {

                this.selectBranch.record = {
                    id: this.record.branchid,
                    description: htmlDecode(this.record.branchdescription),
                };

            } else {

                this.selectBranch.record = {
                    id: null,
                    description: null,
                };

            }


        },


        showPrescribesOn() {
            return this.docgenData?.hideprescribesonflag == "1" ? false : true;
        },

        showFilingCabinet() {
            return this.docgenData?.hidefilingcabinetflag == "1" ? false : true;
        },

        showFeeEstimate() {
            return this.docgenData?.hidefeeestimateflag == "1" ? false : true;
        },

        showPlanOfAction() {
            return this.docgenData?.hideplanofactionflag == "1" ? false : true;
        },

        showExtraScreen() {
            return this.docgenData?.hideextrascreenflag == "1" ? false : true;
        },

        showStages() {
            return this.docgenData?.hidestagesflag == "1" ? false : true;
        },

        setGeneralTab() {

            this.activeTab = 'General';
            this.tabs[0].active = true;

            for (let index = 1; index < this.tabs.length; index++) {

                this.tabs[index].active = false;

                //Show this Tab after retrieving the DocgenData
                if ( this.tabs[index].pageName == 'Litigation' || this.tabs[index].pageName == 'DebtorsAccount' ) {

                    this.tabs[index].visible = false;

                }

            }
        },

        collCommOptionChanged(option){

            if ( option.value === 'N') {

                this.record.collcommpercent = '0';
                this.record.collcommlimit = '0';

                $('#' + this.id + ' input[name="collcommpercent"]').val(this.record.collcommpercent);
                $('#' + this.id + ' input[name="collcommlimit"]').val(this.record.collcommlimit);

            } else if ( option.value === 'U') {

                this.record.collcommpercent = root.control.collcommpercent;
                this.record.collcommlimit = root.control.collcommlimit;

                $('#' + this.id + ' input[name="collcommpercent"]').val(this.record.collcommpercent);
                $('#' + this.id + ' input[name="collcommlimit"]').val(this.record.collcommlimit);

            }

        },

        debtorCollCommOptionChanged(option){

            this.$refs['debtorcollcommpercent'].setReadOnly = false;
            this.$refs['debtorcollcommlimit'].setReadOnly = false;

            if ( option.value === 'N') {

                this.record.debtorcollcommpercent = '0';
                this.record.debtorcollcommlimit = '0';

                $('#' + this.id + ' input[name="debtorcollcommpercent"]').val(this.record.debtorcollcommpercent);
                $('#' + this.id + ' input[name="debtorcollcommlimit"]').val(this.record.debtorcollcommlimit);

            } else if ( option.value === 'U') {

                this.record.debtorcollcommpercent = root.control.collcommpercent;
                this.record.debtorcollcommlimit = root.control.collcommlimit;

                $('#' + this.id + ' input[name="debtorcollcommpercent"]').val(this.record.debtorcollcommpercent);
                $('#' + this.id + ' input[name="debtorcollcommlimit"]').val(this.record.debtorcollcommlimit);

            } else if ( option.value === 'S') {

                this.$refs['debtorcollcommpercent'].setReadOnly = true;
                this.$refs['debtorcollcommlimit'].setReadOnly = true;

                axios.get("/utils/getCollCommPercentAndLimit?date=" + root.todaysdate)
                .then(response => {

                    this.record.debtorcollcommpercent = response.data.commission;
                    this.record.debtorcollcommlimit = response.data.limit;

                    $('#' + this.id + ' input[name="debtorcollcommpercent"]').val(this.record.debtorcollcommpercent);
                    $('#' + this.id + ' input[name="debtorcollcommlimit"]').val(this.record.debtorcollcommlimit);

                }).catch( (error) => {
                    showError('Error getting Collection Commission Schedule', error); 
                });

            }

        },

        archiveStatusChanged(option){

            if ( this.record.archiveflag == '1' && !root.supervisorFlag && root.secGroupMatterArchivedFlag != '1') {
                showError('Access Denied', '<p>You cannot unarchive this Matter.<p></p>You do not have the correct security rights.</p>');
                this.record.archivestatus = this.saveArchiveStatus;
                return;
            }

            if ( option.value == '0' || option.value == '1') {

                this.record.archiveflag = '0';

            } else if ( option.value == '2' ) {

                //**********************************************
                // Note - this is also checked in the API
                //**********************************************

                if (parseInt(this.record.actual) > 0 || 
                    parseInt(this.record.reserved) > 0 || 
                    parseInt(this.record.invested) > 0 || 
                    parseInt(this.record.transfer) > 0 || 
                    parseInt(this.record.batchednormal) > 0 || 
                    parseInt(this.record.batchedreserved) > 0 || 
                    parseInt(this.record.batchedinvested) > 0) {

                    this.record.archiveflag = '0';
                    this.record.archivestatus = this.saveArchiveStatus = '1';
                    showError('Access Denied', '<p>You cannot archive a Matter if any of these balances (Actual, Reserved, Invested, Transfer or Batched) are not zero.</p><p>This Matter has been set to "Pending".</p><p>The Matter will then be archived at Period-End if all balances are zero and there are no outstanding Invoices.</p>');

                } else if ( (this.record.consolidatedflag == '1' || this.record.consolidatedflag == '2') && 
                    (parseInt(this.record.actual) != 0 || 
                    parseInt(this.record.reserved) != 0 || 
                    parseInt(this.record.totalfees) != 0 || 
                    parseInt(this.record.totaldisbursements) != 0 || 
                    parseInt(this.record.totalreceipts) != 0 ||
                    parseInt(this.record.totalpayments) != 0 ||
                    parseInt(this.record.totaljournal) != 0)
                ) {

                    this.record.archiveflag = '0';
                    this.record.archivestatus = this.saveArchiveStatus = '1';
                    showError('Access Denied', '<p>You cannot archive a Matter that is marked for Consolidation and still has balances.</p><p>This Matter has been set to "Pending".</p><p>The Matter will then be archived at Period-End if all balances are zero and there are no outstanding Invoices.</p>');

                } else if ( this.record.createinvoiceflag == '1' && this.record.invoiceFlag == '1') {

                    this.record.archiveflag = '0';
                    this.record.archivestatus = this.saveArchiveStatus = '1';
                    showError('Access Denied', '<p>You cannot archive a Matter if there is an outstanding Invoice||Either create an invoice for this Matter or mark this Matter as "Do Not Create Invoice"</p><p>This Matter has been set to "Pending".</p><p>The Matter will then be archived at Period-End if all balances are zero and there are no outstanding Invoices.</p>');

                } else {

                    this.record.archiveflag = '1';
                    this.record.archivestatus = this.saveArchiveStatus = '2';

                }

            }

        },

        overrideIncomeAccFlagChanged(value) {

            if (!value) {

                this.record.incomeaccid = null;

                this.selectIncomeAccount.record = {};

            }

        },

        invoicePartyFlagChanged(value) {

            if (!value) {

                this.record.invoicepartyid = null;

                this.selectInvoiceParty.partyName = '';

            }

        },

        invoiceFlagChanged(newValue) {

            console.log("invoiceFlagChanged, disable when none here");

        },

        partySelected(selectedRecord) {

            this.initNewRecord(selectedRecord.recordid);

        },     

        invoicePartySelected(id, name, partyid) {

            this.record.invoicepartyid = partyid;

            this.selectInvoiceParty.partyname = htmlDecode(name);

        },

        branchSelected(selectedRecord) {

            this.record.branchflag = '1';
            this.record.branchid = selectedRecord.recordid;

            //Set the Bank accounts to the Branch's bank accounts
            if ( selectedRecord.businessbankid ) this.businessBankSelected(selectedRecord.businessbankid, selectedRecord.businessbankdescription);
            if ( selectedRecord.trustbankid ) this.trustBankSelected(selectedRecord.trustbankid, selectedRecord.trustbankdescription);


        },

        stageGroupSelected(id, description) {

            this.record.stagegroupid = id;

        },

        trustBankSelected(id, description) {

            this.record.trustbankid = id;

        },
        
        businessBankSelected(id, description) {

            this.record.businessbankid = id;

        },

        incomeAccountSelected(id, description) {

            this.record.incomeaccid = id;

        },

        costCentreSelected(id, description) {

            this.record.costcentreid = id;

        },

        languageSelected(id, description) {

            this.record.documentlanguageid = id;

        },

        accountsLanguageSelected(id, description) {

            this.record.accountslanguageid = id;

        },

        clientFeeSheetSelected(id, description) {

            this.record.clientfeesheetid = id;

            //Called from matterTypeSelected()
            this.selectClientFeeSheet.record = {
                recordid: id,
                description: htmlDecode(description),
            };


        },

        debtorFeeSheetSelected(id, description) {

            this.record.debtorfeesheetid = id;

        },

        matterTypeSelected(selectedRecord) {

            this.record.mattertypeid = selectedRecord.recordid;

            // Change the ClientFeeSheetId
            if ( selectedRecord.feesheetid && selectedRecord.feesheetdescription ) {
                this.clientFeeSheetSelected(selectedRecord.feesheetid,selectedRecord.feesheetdescription);
            }

        },

        documentSetSelected(selectedRecord) {

            this.record.docgenid = selectedRecord.recordid;

            this.docgenData = selectedRecord;

            this.getSiblingRecords();

            this.litigationTab.visible = this.debtorsAccountTab.visible = this.isCollectionsMatter();

            if ( this.record.docgenid != root.control.transfersdocgenid ) {
                this.conveyData.bondcauseid = "0";
            }

            // Change the ToDoGroupId
            if ( selectedRecord.todogroupid && selectedRecord.todogroupdescription ) {
                this.planOfActionSelected(selectedRecord.todogroupid,selectedRecord.todogroupdescription);
            }

        },

        planOfActionSelected(id, description) {

            this.record.todogroupid = id;

            //Called from documentSetSelected()
            this.selectPlanOfAction.record = {
                recordid: id,
                description: htmlDecode(description),
            };

        },


        causeOfActionSelected(id, description) {

            this.conveyData.bondcauseid = id;

            this.selectCauseOfAction.record = {
                recordid: id,
                description: htmlDecode(description),
            };

        },
        
        extraScreenSelected(id, description) {

            this.record.extrascreenid = id;

            // Re-initialize Extra Sceens
            this.initExtraScreens();

        },

        billingRateSelected(id, description) {

            this.record.defaultbillingrateid = id;

        },

        clearSelectBillingRate() {

            this.selectBillingRate.record = {
                recordid: null,
                description: '',
            };

            this.record.defaultbillingrateid = null;
            
        },

        adjustMatGroupTableColumns() {
            this.matGroupTable.table.columns.adjust;
        },

        adjustMatPartiesTableColumns() {
            this.matterPartiesTable.table.columns.adjust;
        },

        adjustDebtorsAccountTableColumns() {

            this.debtorsAccountTable.table.columns.adjust;

            this.debtorsAccountTable.debtorsBalance = this.record.debtorsbalance;

        },

        updateFeeAndDisbursementOptions() {

            if( this.feeSettings.feeOption == 2) {
                
                this.record.invoicefeeoption = 6;
                
            } else if ( this.feeSettings.feeOption == 1 && this.feeSettings.feeSeparatorOption == 0 && this.feeSettings.feeSummarizeFlag == 0){

                this.record.invoicefeeoption = 1;

            } else if ( this.feeSettings.feeOption == 1 && this.feeSettings.feeSeparatorOption == 1 && this.feeSettings.feeSummarizeFlag == 0){
                
                this.record.invoicefeeoption = 2 ;

            } else if ( this.feeSettings.feeOption == 1 && this.feeSettings.feeSeparatorOption == 0 && this.feeSettings.feeSummarizeFlag == 1){

                this.record.invoicefeeoption = 3 ;

            } else if ( this.feeSettings.feeOption == 1 && this.feeSettings.feeSeparatorOption == 1 && this.feeSettings.feeSummarizeFlag == 1){

                this.record.invoicefeeoption = 4 ;

            } else if ( this.feeSettings.feeOption == 0 && this.feeSettings.feeSummarizeFlag == 1){

                this.record.invoicefeeoption = 5 ;

            } else {
                this.record.invoicefeeoption = 0 ;
            }
            
            if ( this.disbursementSettings.disbursementOption == '2' ){

                if ( this.disbursementSettings.separateCreditorDisbursementOption == '1'){

                    this.record.invoicedisbursementoption = '11';

                } else {

                    this.record.invoicedisbursementoption = '6';

                }

            } else if ( this.disbursementSettings.disbursementOption == '3' ){

                this.record.invoicedisbursementoption = '12';

            } else if ( this.disbursementSettings.disbursementOption == '1' && this.disbursementSettings.disbursementSeparatorOption == '0' && this.disbursementSettings.disbursementSummarizeFlag == '0' && this.disbursementSettings.itemiseCreditorDisbursementOption == '0'){

                this.record.invoicedisbursementoption = '1';

            } else if ( this.disbursementSettings.disbursementOption == '1' && this.disbursementSettings.disbursementSeparatorOption == '1' && this.disbursementSettings.disbursementSummarizeFlag == '0' && this.disbursementSettings.itemiseCreditorDisbursementOption == '0'){

                this.record.invoicedisbursementoption = '2';

            } else if ( this.disbursementSettings.disbursementOption == '1' && this.disbursementSettings.disbursementSeparatorOption == '0' && this.disbursementSettings.disbursementSummarizeFlag == '1' && this.disbursementSettings.itemiseCreditorDisbursementOption == '0'){

                this.record.invoicedisbursementoption = '3';

            } else if ( this.disbursementSettings.disbursementOption == '1' && this.disbursementSettings.disbursementSeparatorOption == '1' && this.disbursementSettings.disbursementSummarizeFlag == '1' && this.disbursementSettings.itemiseCreditorDisbursementOption == '0'){

                this.record.invoicedisbursementoption = '4';

            } else if ( this.disbursementSettings.disbursementOption == '0' && this.disbursementSettings.disbursementSummarizeFlag == '1'){

                this.record.invoicedisbursementoption = '5';

            } else if ( this.disbursementSettings.disbursementOption == '1' && this.disbursementSettings.disbursementSeparatorOption == '0' && this.disbursementSettings.disbursementSummarizeFlag == '0' && this.disbursementSettings.itemiseCreditorDisbursementOption == '1'){

                this.record.invoicedisbursementoption = '7';

            } else if ( this.disbursementSettings.disbursementOption == '1' && this.disbursementSettings.disbursementSeparatorOption == '1' && this.disbursementSettings.disbursementSummarizeFlag == '0' && this.disbursementSettings.itemiseCreditorDisbursementOption == '1'){

                this.record.invoicedisbursementoption = '8';

            } else if ( this.disbursementSettings.disbursementOption == '1' && this.disbursementSettings.disbursementSeparatorOption == '0' && this.disbursementSettings.disbursementSummarizeFlag == '1' && this.disbursementSettings.itemiseCreditorDisbursementOption == '1'){

                this.record.invoicedisbursementoption = '9';

            } else if ( this.disbursementSettings.disbursementOption == '1' && this.disbursementSettings.disbursementSeparatorOption == '1' && this.disbursementSettings.disbursementSummarizeFlag == '1' && this.disbursementSettings.itemiseCreditorDisbursementOption == '1'){

                this.record.invoicedisbursementoption = '10';

            } else {

                this.record.invoicedisbursementoption = '0';
            }

        },

        setFeeAndDisbursementOptions() {

            if (!this.record.invoicefeeoption || this.record.invoicefeeoption == '0'){
                this.feeSettings.feeOption = '0';
                this.feeSettings.feeSeparatorOption = '0';
                this.feeSettings.feeSummarizeFlag = '0';

            } else if (this.record.invoicefeeoption == '1'){
                this.feeSettings.feeOption = '1';
                this.feeSettings.feeSeparatorOption = '0';
                this.feeSettings.feeSummarizeFlag = '0';

            } else if (this.record.invoicefeeoption == '2'){
                this.feeSettings.feeOption = '1';
                this.feeSettings.feeSeparatorOption = '1';
                this.feeSettings.feeSummarizeFlag = '0';
                    
            } else if (this.record.invoicefeeoption == '3'){
                this.feeSettings.feeOption = '1';
                this.feeSettings.feeSeparatorOption = '0';
                this.feeSettings.feeSummarizeFlag = '1';
                    
            } else if (this.record.invoicefeeoption == '4'){
                this.feeSettings.feeOption = '1';
                this.feeSettings.feeSeparatorOption = '1';
                this.feeSettings.feeSummarizeFlag = '1';
                    
            } else if (this.record.invoicefeeoption == '5'){
                this.feeSettings.feeOption = '0';
                this.feeSettings.feeSeparatorOption = '0';
                this.feeSettings.feeSummarizeFlag = '1';
                    
            } else if (this.record.invoicefeeoption == '6'){
                this.feeSettings.feeOption = '2';
                this.feeSettings.feeSeparatorOption = '0';
                this.feeSettings.feeSummarizeFlag = '0';
                
            }


            if (!this.record.invoicedisbursementoption || this.record.invoicedisbursementoption == '0'){

                this.disbursementSettings.disbursementOption = '0';
                this.disbursementSettings.separateCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSummarizeFlag = '0';
                this.disbursementSettings.itemiseCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSeparatorOption = '0';

            } else if (this.record.invoicedisbursementoption == '1'){

                this.disbursementSettings.disbursementOption = '1';
                this.disbursementSettings.separateCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSummarizeFlag = '0';
                this.disbursementSettings.itemiseCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSeparatorOption = '0';

            } else if (this.record.invoicedisbursementoption == '2'){

                this.disbursementSettings.disbursementOption = '1';
                this.disbursementSettings.separateCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSummarizeFlag = '0';
                this.disbursementSettings.itemiseCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSeparatorOption = '1';

                    
            } else if (this.record.invoicedisbursementoption == '3'){

                this.disbursementSettings.disbursementOption = '0';
                this.disbursementSettings.separateCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSummarizeFlag = '1';
                this.disbursementSettings.itemiseCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSeparatorOption = '0';

            } else if (this.record.invoicedisbursementoption == '4'){

                this.disbursementSettings.disbursementOption = '1';
                this.disbursementSettings.separateCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSummarizeFlag = '1';
                this.disbursementSettings.itemiseCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSeparatorOption = '1';

            } else if (this.record.invoicedisbursementoption == '5'){

                this.disbursementSettings.disbursementOption = '0';
                this.disbursementSettings.separateCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSummarizeFlag = '1';
                this.disbursementSettings.itemiseCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSeparatorOption = '0';

            } else if (this.record.invoicedisbursementoption == '6'){

                this.disbursementSettings.disbursementOption = '2';
                this.disbursementSettings.separateCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSummarizeFlag = '0';
                this.disbursementSettings.itemiseCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSeparatorOption = '0';
                    
            } else if (this.record.invoicedisbursementoption == '7'){

                this.disbursementSettings.disbursementOption = '1';
                this.disbursementSettings.separateCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSummarizeFlag = '0';
                this.disbursementSettings.itemiseCreditorDisbursementOption = '1';
                this.disbursementSettings.disbursementSeparatorOption = '0';

            } else if (this.record.invoicedisbursementoption == '8'){

                this.disbursementSettings.disbursementOption = '1';
                this.disbursementSettings.separateCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSummarizeFlag = '0';
                this.disbursementSettings.itemiseCreditorDisbursementOption = '1';
                this.disbursementSettings.disbursementSeparatorOption = '1';

            } else if (this.record.invoicedisbursementoption == '9'){

                this.disbursementSettings.disbursementOption = '1';
                this.disbursementSettings.separateCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSummarizeFlag = '1';
                this.disbursementSettings.itemiseCreditorDisbursementOption = '1';
                this.disbursementSettings.disbursementSeparatorOption = '0';
                    
            } else if (this.record.invoicedisbursementoption == '10'){

                this.disbursementSettings.disbursementOption = '1';
                this.disbursementSettings.separateCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSummarizeFlag = '1';
                this.disbursementSettings.itemiseCreditorDisbursementOption = '1';
                this.disbursementSettings.disbursementSeparatorOption = '1';

            } else if (this.record.invoicedisbursementoption == '11'){

                this.disbursementSettings.disbursementOption = '2';
                this.disbursementSettings.separateCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSummarizeFlag = '0';
                this.disbursementSettings.itemiseCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSeparatorOption = '1';

            } else if (this.record.invoicedisbursementoption == '12'){

                this.disbursementSettings.disbursementOption = '3';
                this.disbursementSettings.separateCreditorDisbursementOption = '0';
                this.disbursementSettings.disbursementSummarizeFlag = '1';
                this.disbursementSettings.itemiseCreditorDisbursementOption = '1';
                this.disbursementSettings.disbursementSeparatorOption = '1';

            }
        },

        consolidateMatterSelected(selectedRecord) {

            if ( selectedRecord.recordid == this.record.recordid) {

                showError('Error','<p>You cannot consolidate this Matter with itself.</p>');

            } else if ( selectedRecord.consolidateid && selectedRecord.consolidateid != '0' ) {

                showError('Error','<p>You cannot consolidate this Matter with ' + selectedRecord.fileref + '.</p><p>It is consolidated to another Matter.</p><p>You can only consolidate this Matter with a Matter that is not already consolidated.</p>');

            } else if ( selectedRecord?.consolidatedflag !== "4" ) {

                showError('Error','<p>You cannot consolidate this Matter with ' + selectedRecord.fileref + '.</p><p>It is not a "Consolidated Account".</p>');

            } else {

                this.record.consolidateid = selectedRecord.recordid;

            }

        },

        selectConsolidateMatterClearIconCallback() {

            this.record.consolidateid = null;

            this.selectConsolidateMatter.matter = {};

        },

        getUpdatedByDetails() {

            let returnData = '';

            let employee = this.record.updatedbyid ? root.employees.filter(employee => employee.recordid == this.record.updatedbyid)[0] : null;

            if (employee && this.record.updatedbydate && this.record.updatedbytime) {

                returnData = 'Last updated by ' + employee.name + ' on ' + convertFromClarionDate(this.record.updatedbydate)  + ' at ' + convertFromClarionTime(this.record.updatedbytime);

            }
            return returnData;

        },


        async generateDocument() {

            this.generateDocumentsSource = 'Matter';

            root.selectTemplates.load(this, 'Document', this.generateDocumentsSource);

        },

        templatesSelected(id) {

            this.selectedRows = [this.record.recordid];

            primeGenerateDocumentPreviewer(this, id);

        },

        emailClient() {

            // This is in common.js
            emailThisParty(this.record.clientid, true);

        },


        refreshFormTables() {

        },

        pageTitle() {
            
            return (this.record.fileref) ? this.record.fileref + (this.record.description ? ' - ' + this.record.description : '') : '';

        },

    },

}  
</script>
