<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lgr' : ''">

        <div :class="modal ? 'modal-content parties-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header parties-bg' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="!editing && !savedFlag">Party will be Added</span>
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

                    <div v-show="isLocked() === true" class="row">
                        <div class="col-md-12">
                            <div class="alert alert-danger" role="alert">
                                ⚠️ This Party cannot be edited - it is locked
                            </div>
                        </div>
                    </div>


                    <div class="form-group row">

                        <select-party-entity
                            popOver="<h4>Entity</h4><p>The Entity of a Party is the legal classification of the Party.</p><p>Some may be juristic persons (such as companies or trusts) while others may be natural persons (such as adults or minors).</p><p>Certain entities can have specific rights, duties and laws which apply to them and so it is important to specify what type of Entity the Party is here.</p>" 
                            _class="col-xxl-4"
                            :id="uniqueId + '-select-party-entity'"
                            title="The Entity of the Party"
                            :ref="uniqueId + '-select-party-entity'"
                            :form-ref="uniqueId + '-select-party-entity'"
                            
                        />

                        <select-party-type
                            popOver="<h4>Type</h4><p>The Party Type is used to further classify the legal status of the Party by specifying what <em>Type</em> of Entity the Party is</p>" 
                            label="Type"
                            _class="col-xxl-4 mt-3 mt-xxl-0"
                            :id="uniqueId + '-select-party-type'"
                            title="The type of Entity"
                            :ref="uniqueId + '-select-party-type'"
                            :form-ref="uniqueId + '-select-party-type'"
                            
                        />

                        <select-party-role
                            popOver="<h4>Default Role</h4>
                            <p>This is the typical, or most common, Role this Party playes on a Matter./p>
                            <p>When this Party is assigned to a Matter, this Role will be chosen by default, 
                                but it can be changed (at the time) if the Party plays a different Role on a particular Matter.</p>" 
                            label="Default Role"
                            _class="col-xxl-4 mt-3 mt-xxl-0"
                            :id="uniqueId + '-select-party-role'"
                            title="The Default Role of the Party"
                            :ref="uniqueId + '-select-party-role'"
                            :form-ref="uniqueId + '-select-party-role'"
                            
                        />

                    </div>

                    <div class="form-group row">

                        <text-input v-if="editing" _class="col-md-4 mt-3 mt-md-0" 
                        v-model="record.matterprefix" name="matterprefix" label="Code" :read-only="true" 
                        pop-over="
                            <h4>Code</h4>
                            <p>A code is used to uniquely identify a Party as well as Matters linked to the Party.</p>
                            <p>For example, if a Party has the code 'ABC1', it's first Matter will be 'ABC1/0001', it's second 'ABC1/0002' etc.</p>
                            <p>Note: The numbering sequence can by changed in the LegalSuite program settings.</p>"
                        />

                        <select-default-language
                            popOver="<h4>Default Language</h4>
                            <p>The preferred language of this Party.</p>
                            <p>Documents assembled or created for this Party will be in this language by default.</p>" 
                            callback="defaultLanguageSelected"
                            parentName="selectDefaultLanguage"
                            label="Language"
                            _class="col-xxl-4 mt-3 mt-xxl-0"
                            :id="uniqueId + '-select-language'"
                            :ref="uniqueId + '-select-language'"
                            :form-ref="uniqueId + '-select-language'"
                            
                        />

                    </div>

                    <div class="form-group row">

                        <text-input _class="col-md-6" 
                            label="Name"
                            v-model="parlang.name" 
                            ref='text-input-name'
                            name="name"
                            pop-over="Dynamic"
                        />

                    </div>

                    <div class="form-group row">

                        <text-input _class="col-md-6" 
                            label="First Names"
                            v-model="parlang.firstname" 
                            ref="text-input-firstname"
                            pop-over="<h4>First Names</h4><p>The first names of the Party.</p><p>These are the formal names as per their ID document or Passport. If the Party has a more colloquial name, you can specify that in the <strong>Known As</strong> field.</p>"

                        />

                        <text-input _class="col-md-4" 
                            label="Title"
                            v-model="parlang.title" 
                            ref="text-input-title"
                            pop-over="<h4>Title</h4><p>The title the Party is addressed as, e.g. Mr, Mrs, Ms, Dr, Prof etc.</p>"

                        />

                        <text-input _class="col-md-2" 
                            label="Initials"
                            v-model="parlang.initials" 
                            ref="text-input-initials"
                            pop-over="<h4>Initials</h4><p>The Party's initials.</p><p>Some legal forms or documents may require the Party's initials. If so, you can specify them here.</p>"

                        />

                    </div>

                    <div class="form-group row">

                        <text-input _class="col-md-6" 
                            label="Alternative"
                            v-model="parlang.alternativename" 
                            ref="text-input-alternativename" 
                            pop-over="Dynamic"
                        />


                        <text-input 
                            v-show="isJursitic() === false"
                            _class="col-md-4" 
                            label="Salutation"
                            v-model="parlang.salutation" 
                            ref="text-input-salutation"
                            pop-over="<h4>Salutation</h4><p>How the Party should be addressed in correspondence such as letters and email.</p>"
                        />


                        <text-input 
                            v-show="isJursitic() === true"
                            _class="col-md-6" 
                            label="Registration Number"
                            v-model="parlang.identitynumber" 
                            title="The registration number of the Party (if applicable)"
                            pop-over="<h4>Number</h4><p>The registration number of the Party (if applicable)</p>"
                        />

                    </div>

                    <div v-show="isJursitic() === true" class="form-group row">

                            <div class="col-md-4">

                                <label>Registration Date</label>

                                <pop-over content="<h4>Registration Date</h4>
                                <p>The registration date of the Party.</p>
                                "/>
                                <date-picker ref="registrationDatePickerComponent" v-model="parlang.trustdate" :config="$root.datePickerOptions"/>
                                <div v-show="errors.trustdate" v-html="errors.trustdate" class="invalid-feedback"></div>

                            </div>

                    </div>

                    <div v-show="!editing" class="form-group row">

                        <text-input 
                            _class="col-md-4" 
                            label="Email Address"
                            v-model="record.emailaddress"
                            title="The default email address of this Party"
                            pop-over="<h4>Email Address</h4><p>The default email address of this Party.</p><p>Additional Contact Details can be added once the Party has been saved</p>"
                            
                        />

                        <text-input 
                            _class="col-md-4" 
                            label="Cell Number"
                            v-model="record.cellphone"
                            title="The cell phone number of this Party"
                            pop-over="<h4>Cell Telephone</h4><p>The default cell phone number of this Party.</p><p>Additional Contact Details can be added once the Party has been saved</p>"
                        />

                        <text-input 
                            _class="col-md-4" 
                            label="Work Telephone"
                            v-model="record.workphone"
                            title="The work phone number of this Party"
                            pop-over="<h4>Work Telephone</h4><p>The default work phone number of this Party.</p><p>Additional Contact Details can be added once the Party has been saved</p>"
                        />


                    </div>


                    <div v-show="isJursitic() === false" class="form-group row">

                        <div class="col-md-4">
                            <label>ID Type</label>
                            <pop-over content="<h4>ID Type</h4><p>The type of document used for identification</p>"/>
                            <v-select
                                :options="identityDocumentTypes" 
                                :clearable="false" 
                                :searchable="false" 
                                :reduce="identityDocumentTypes => identityDocumentTypes.value"
                                v-model="record.identitydocumenttype"
                            />

                        
                        </div>

                        <text-input 
                            _class="col-md-4" 
                            label="Number"
                            v-model="parlang.identitynumber"
                            title="The identification number of the person"
                            pop-over="<h4>Number</h4><p>The identification number of the person.</p>"
                        />

                        <div class="col-md-4">

                            <label>Date Of Birth</label>

                            <pop-over content="<h4>Date Of Birth</h4>
                            <p>The date the person was born.</p>
                            "/>
                            <date-picker ref="birthDatePickerComponent" v-model="parlang.birthdate" :config="$root.datePickerOptions"/>
                            <div v-show="errors.birthdate" v-html="errors.birthdate" class="invalid-feedback"></div>

                        </div>

                    </div>

                    <div class="row mt-3">

                        <div class="col-lg-6">

                            <fieldset><legend>Postal Address</legend>

                                <div class="form-group row">
                                    <text-input _class="col-md-12" v-model="parlang.postalline1" name="postalline1" label="Line 1" />
                                </div>

                                <div class="form-group row">
                                    <text-input _class="col-md-12" v-model="parlang.postalline2" name="postalline2" label="Line 2" />
                                </div>

                                <div class="form-group row">
                                    <text-input _class="col-md-9" v-model="parlang.postalline3" name="postalline3" label="Line 3" />
                                    <text-input _class="col-md-3" v-model="parlang.postalcode" name="postalcode" label="Code" />
                                </div>

                                <div class="form-group row">

                                    <div class="col-md-12">

                                        <label>Country</label>
                                        <select-postal-country
                                            :id="id + '-select-postal-country'"
                                            placeholder=""
                                            :options="$root.countries" 
                                            v-model="postalCountry"
                                            track-by="recordid"
                                            :tabindex="-1"
                                            label="description"
                                            :allow-empty="false"
                                            :show-labels="false"
                                        >
                                        <template slot="noResult">No Countries found</template>
                                        </select-postal-country>


                                    </div>
                                </div>

                            </fieldset>



                        </div>

                        <div class="col-lg-6">

                            <fieldset><legend>Physical Address</legend>

                                <div class="form-group row">
                                    <text-input _class="col-md-12" v-model="parlang.physicalline1" name="physicalline1" label="Line 1" />
                                </div>

                                <div class="form-group row">
                                    <text-input _class="col-md-12" v-model="parlang.physicalline2" name="physicalline2" label="Line 2" />
                                </div>

                                <div class="form-group row">
                                    <text-input _class="col-md-9" v-model="parlang.physicalline3" name="physicalline3" label="Line 3" />
                                    <text-input _class="col-md-3" v-model="parlang.physicalcode" name="physicalcode" label="Code" />
                                </div>

                                <div class="form-group row">

                                    <div class="col-md-12">

                                        <label>Country</label>
                                        <select-physical-country
                                            :id="id + '-select-physical-country'"
                                            placeholder=""
                                            :options="$root.countries" 
                                            v-model="physicalCountry"
                                            track-by="recordid"
                                            :tabindex="-1"
                                            label="description"
                                            :allow-empty="false"
                                            :show-labels="false"
                                        >
                                        <template slot="noResult">No Countries found</template>
                                        </select-physical-country>


                                    </div>
                                </div>

                            </fieldset>

                        </div>

                    </div>

                </div>

                <div v-show="activeTab === 'Contact'" :id="id + '-Contact-form-tab-content'" class="form-tab-content">

                    <div class="row">

                        <div class="col-md-12">

                            <!-- <fieldset><legend>Contact Details</legend> -->

                                <party-number-table
                                    :id="uniqueId + '-party-number-table-form'"
                                    :ref="uniqueId + '-party-number-table'"
                                    :formRef="uniqueId + '-party-number-table'"
                                    :table-id="uniqueId + '-party-numbers-table'"
                                    :lazyLoadFlag="true"
                                    :searchInputFocus="false"
                                />

                            <!-- </fieldset> -->

                        </div>

                    </div>

                </div>

                <div v-show="activeTab === 'Marital'" :id="id + '-Marital-form-tab-content'" class="form-tab-content">

                    <div class="form-group row">

                        <div class="col-md-5">

                            <label>Marital Status</label>
                            <pop-over content="<h4>Marital Status</h4><p>The marital status of the Party</p>"/>
                            <v-select
                                :options="maritalTypes" 
                                :clearable="false" 
                                :searchable="false" 
                                :reduce="maritalTypes => maritalTypes.value"
                                v-model="record.maritalstatus"
                            />


                        </div>

                        <radio-buttons 
                        v-show="record.maritalstatus === 'UNM'"
                        :popOver="`<h4>Unmarried Status</h4>
                            <p>Specify why the Party is unmarried</p>`"
                        _class="col-md-7" 
                        :record="record" 
                        column="unmarriedstatus" 
                        :buttons="[
                            {value:'0', text: 'Never Married'},
                            {value:'1', text: 'Divorced'},
                            {value:'2', text: 'Widowed'},
                        ]" 
                        name="unmarriedstatus" 
                        label="Unmarried Status" 
                        @change="unmarriedStatusChanged"
                        
                        />


                    </div>

                    <div class="form-group row">
                        <text-input 
                        _class="col-md-12" 
                        popOver="<h4>Wording of the Marital Description</h4>
                        <p>The wording of the Party's marital contract here (used in Conveyancing documents).</p>" 
                        v-model="parlang.maritaldescription" 
                        name="maritaldescription" 
                        label="Marital Description Wording" 
                        :lookupLibraryFlag="true"
                        lookupLibraryCategory="A description of the marital contract"
                        />
                    </div>

                    <div v-show="record.maritalstatus !== 'UNM'" class="row">

                        <div class="col-md-6">

                            <fieldset><legend>Marriage Details</legend>

                                <div class="form-group row">

                                    <div class="col-md-8">

                                        <label>Date</label>

                                        <pop-over content="<h4>Marriage Date</h4><p>The date the Party was married.</p>"/>
                                        <date-picker 
                                            :config="$root.datePickerOptions"
                                            v-model="record.formattedmarriagedate" 
                                        />
                                        <div v-show="errors.marriagedate" v-html="errors.marriagedate" class="invalid-feedback"></div>

                                    </div>
                                </div>

                                <div class="form-group row">
                                    <text-input 
                                    _class="col-md-12" 
                                    popOver="<h4>Place of Marriage</h4>
                                    <p>The laws of the Country the Marriage governed by.</p>" 
                                    v-model="record.marriageplace" 
                                    name="marriageplace" 
                                    label="Place" 
                                    :lookupLibraryFlag="true"
                                    lookupLibraryCategory="The Place of the Marriage"
                                    />
                                </div>


                                <div class="form-group row">

                                    <select-domiciled-country
                                        popOver="<h4>Country</h4>
                                        <p>The country the Party's spouse was domiciled in when the marriage was registered.</p>" 
                                        label="Spouse Domiciled In"
                                        _class="col-md-12"
                                        callback="domiciledCountrySelected"
                                        parentName="selectDomiciledCountry"
                                        :id="uniqueId + '-select-domiciled-country'"
                                        :ref="uniqueId + '-select-domiciled-country'"
                                        :form-ref="uniqueId + '-select-domiciled-country'"
                                        
                                    />

                                </div>


                                <div v-show="record.maritalstatus === 'OUT' || record.maritalstatus === 'CUO'" class="form-group row">

                                    <text-input 
                                    _class="col-md-12" 
                                    popOver="<h4>ANC Number</h4>
                                    <p>The number of the antenuptial contract.</p>" 
                                    v-model="record.ancnumber" 
                                    name="ancnumber" 
                                    label="ANC Number" 
                                    />

                                </div>

                                <div v-show="record.maritalstatus === 'OUT' || record.maritalstatus === 'CUO'" class="form-group row">

                                    <div class="col-md-12">

                                        <label>Deeds Office</label>
                                        <pop-over content="<h4>Deeds Office</h4><p>The Deeds Office where the antenuptial contract is registered.</p>"/>
                                        <v-select
                                            :options="$root.deedsOffices" 
                                            label="name"
                                            :clearable="false" 
                                            :searchable="false" 
                                            v-model="parlang.deedsregistry"
                                        />
                                    </div>


                                </div>



                                <div v-show="record.maritalstatus === 'FOR'" class="form-group row">

                                    <select-marriage-country
                                        popOver="<h4>Country</h4>
                                        <p>The country the marriage was registered in.</p>" 
                                        label="Foreign Country"
                                        _class="col-md-12"
                                        callback="marriageCountrySelected"
                                        parentName="selectMarriageCountry"
                                        :id="uniqueId + '-select-marriage-country'"
                                        :ref="uniqueId + '-select-marriage-country'"
                                        :form-ref="uniqueId + '-select-marriage-country'"
                                        
                                    />

                                </div>



                            </fieldset>

                        </div>

                        <div class="col-md-6">

                            <fieldset><legend>Spouse</legend>

                                <div class="form-group row">
                                    
                                    <div class="col-md-12">

                                        <b-form-checkbox
                                            :id="id + '-assisted-flag'"
                                            v-model="record.assistedflag"
                                            name="assistedflag"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>Assisted by spouse?</span>
                                            <pop-over content="<h4>Assisted By Spouse</h4>
                                            <p>Indicates if the Party must be assisted by his/her spouse in a Conveyancing transaction?</p>
                                            "/>
                                        </b-form-checkbox>
                                    </div>
                                </div>   

                                <div class="form-group row">

                                    <text-input 
                                    _class="col-md-12" 
                                    popOver="<h4>Last Name</h4>
                                    <p>The surname or family name of the Party's spouse.</p>" 
                                    v-model="record.spouselastname" 
                                    name="spouselastname" 
                                    label="Last Name" 
                                    />

                                </div>

                                <div class="form-group row">

                                    <text-input 
                                    _class="col-md-12" 
                                    popOver="<h4>First Name(s)</h4>
                                    <p>The first names of the Party's spouse.</p>" 
                                    v-model="record.spousefirstname" 
                                    name="spousefirstname" 
                                    label="First Name(s)" 
                                    />


                                </div>

                                <div class="form-group row">

                                    <text-input 
                                    _class="col-md-6" 
                                    popOver="<h4>Initials</h4>
                                    <p>The initials of the Party's spouse.</p>" 
                                    v-model="record.spouseinitials" 
                                    name="spouseinitials" 
                                    label="Initials" 
                                    />

                                </div>


                                <div class="form-group row">

                                    <text-input 
                                    _class="col-md-8" 
                                    popOver="<h4>Identity Number</h4>
                                    <p>The identity number of the Party's spouse.</p>" 
                                    v-model="record.spouseidentitynumber" 
                                    name="spouseidentitynumber" 
                                    label="Identity Number" 
                                    />

                                </div>

                                <div class="form-group row">

                                    <div class="col-md-8">

                                        <label>Date of Birth</label>

                                        <pop-over content="<h4>Spouse Date of Birth</h4><p>The birth date the Party's spouse (if the identity number is unknown).</p>"/>
                                        <date-picker 
                                            :config="$root.datePickerOptions"
                                            v-model="record.formattedspousebirthdate" 
                                        />
                                        <div v-show="errors.spousebirthdate" v-html="errors.spousebirthdate" class="invalid-feedback"></div>

                                    </div>
                                </div>


                            </fieldset>

                        </div>

                    </div>

                </div>

                <div v-show="activeTab === 'Financial'" :id="id + '-Financial-form-tab-content'" class="form-tab-content">

                    <div class="row">

                        <div class="col-md-12">

                            <fieldset><legend>Tax Details</legend>

                                <div class="form-group row">

                                    <radio-buttons 
                                        popOver="<h4>Tax Payer</h4><p>Specify whether the Party is a Tax Payer or not.</p>"
                                        _class="col-md-12" 
                                        :record="record" 
                                        column="taxpayer" 
                                        :buttons="[
                                            {value:'Y', text: 'Yes'},
                                            {value:'N', text: 'No'},
                                        ]" 
                                        name="taxpayer" 
                                        label="Tax Payer" 
                                        
                                    />
                                    
                                </div>

                                <div class="form-group row">

                                    <text-input 
                                    _class="col-md-8" 
                                    popOver="<h4>Tax Number</h4>
                                    <p>The tax number of the Party.</p>" 
                                    v-model="record.taxnumber" 
                                    name="taxnumber" 
                                    ref='text-input-taxnumber'
                                    label="Dynamic"
                                    />

                                </div>

                                <div class="form-group row">

                                    <text-input 
                                    _class="col-md-8" 
                                    popOver="<h4>Annual Income</h4><p>The gross annual income of the Party.</p>"
                                    type="number" 
                                    input-class="form-input-number" 
                                    v-model="record.annualincome" 
                                    name="annualincome" 
                                    label="Annual Income"
                                    />

                                </div>

                                <div class="form-group row">

                                    <radio-buttons 
                                        popOver="<h4>SA Resident</h4><p>Specify whether the Party is a resident in South Africa or not.</p>"
                                        _class="col-md-12" 
                                        :record="record" 
                                        column="saresident" 
                                        :buttons="[
                                            {value:'Y', text: 'Yes'},
                                            {value:'N', text: 'No'},
                                        ]" 
                                        name="saresident" 
                                        label="SA Resident" 
                                        
                                    />

                                </div>

                                <div v-show="record.saresident === 'N'" class="form-group row">

                                    <select-residence-country
                                        popOver="<h4>Country Of Residence</h4>
                                        <p>The country the Party resides in.</p>" 
                                        _class="col-md-12"
                                        callback="residenceCountrySelected"
                                        parentName="selectResidenceCountry"
                                        :id="uniqueId + '-select-residence-country'"
                                        :ref="uniqueId + '-select-residence-country'"
                                        :form-ref="uniqueId + '-select-residence-country'"
                                        
                                    />

                                </div>

                                <div class="form-group row">

                                    <text-input 
                                    _class="col-md-8" 
                                    popOver="<h4>Passport Number</h4>
                                    <p>The passport number of the Party.</p>" 
                                    v-model="record.passportnumber" 
                                    name="passportnumber" 
                                    label="Passport Number" 
                                    />

                                </div>

                                <div class="form-group row">

                                    <text-input 
                                    _class="col-md-8" 
                                    popOver="<h4>Vat Number</h4>
                                    <p>The Vat number of the Party (if they are registered for VAT).</p>" 
                                    v-model="record.vatnumber" 
                                    name="vatnumber" 
                                    label="Vat Number" 
                                    />

                                </div>

                            </fieldset>

                        </div>

                    </div>

                    <div class="row mt-3" v-show="record.maritalstatus && record.maritalstatus !== 'UNM' && record.maritalstatus !== 'OUT' && record.maritalstatus !== 'CUO' && record.maritalstatus !== 'FOR'">

                        <div class="col-md-12">

                            <fieldset><legend>Spouse's Tax Details</legend>

                                <div class="form-group row">

                                    <radio-buttons 
                                        popOver="<h4>Tax Payer</h4><p>Specify whether the Party's spouse is a Tax Payer or not.</p>"
                                        _class="col-md-12" 
                                        :record="record" 
                                        column="spousetaxpayer" 
                                        :buttons="[
                                            {value:'Y', text: 'Yes'},
                                            {value:'N', text: 'No'},
                                        ]" 
                                        name="spousetaxpayer" 
                                        label="Tax Payer" 
                                        
                                    />
                                    
                                </div>

                                <div class="form-group row">

                                    <text-input 
                                    _class="col-md-8" 
                                    popOver="<h4>Tax Number</h4>
                                    <p>The SARS tax number of the Party's spouse.</p>" 
                                    v-model="record.spousetaxnumber" 
                                    name="spousetaxnumber" 
                                    label="Tax Number" 
                                    />

                                </div>

                                <div class="form-group row">

                                    <text-input 
                                    _class="col-md-8" 
                                    popOver="<h4>Annual Income</h4><p>The gross annual income of the Party's spouse.</p>"
                                    type="number" 
                                    input-class="form-input-number" 
                                    v-model="record.spouseannualincome" 
                                    name="spouseannualincome" 
                                    label="Annual Income"
                                    />

                                </div>

                                <div class="form-group row">

                                    <radio-buttons 
                                        popOver="<h4>SA Resident</h4><p>Specify whether the Party's spouse is a resident in South Africa or not.</p>"
                                        _class="col-md-12" 
                                        :record="record" 
                                        column="spousesaresident" 
                                        :buttons="[
                                            {value:'Y', text: 'Yes'},
                                            {value:'N', text: 'No'},
                                        ]" 
                                        name="spousesaresident" 
                                        label="SA Resident" 
                                        
                                    />

                                </div>

                                <div v-show="record.spousesaresident === 'N'" class="form-group row">

                                    <select-spouse-residence-country
                                        popOver="<h4>Country Of Residence</h4>
                                        <p>The country the Party's spouse resides in.</p>" 
                                        _class="col-md-12"
                                        callback="spouseResidenceCountrySelected"
                                        parentName="selectSpouseResidenceCountry"
                                        :id="uniqueId + '-select-residence-country'"
                                        :ref="uniqueId + '-select-residence-country'"
                                        :form-ref="uniqueId + '-select-residence-country'"
                                        
                                    />

                                </div>

                                <div class="form-group row">

                                    <text-input 
                                    _class="col-md-8" 
                                    popOver="<h4>Passport Number</h4>
                                    <p>The passport number of the Party's spouse.</p>" 
                                    v-model="record.spousepassportnumber" 
                                    name="spousepassportnumber" 
                                    label="Passport Number" 
                                    />

                                </div>

                                <div class="form-group row">

                                    <text-input 
                                    _class="col-md-8" 
                                    popOver="<h4>Vat Number</h4>
                                    <p>The Vat number of the Party's spouse (if they are registered for VAT).</p>" 
                                    v-model="record.spousevatnumber" 
                                    name="spousevatnumber" 
                                    label="Vat Number" 
                                    />

                                </div>


                            </fieldset>

                        </div>

                    </div>

                    <div v-show="isJursitic() === false" class="row mt-3">

                        <div class="col-md-12">

                            <fieldset><legend>Employer</legend>

                                <div class="form-group row">                    

                                    <text-input 
                                        _class="col-md-6" 
                                        label="Name"
                                        v-model="record.employername"
                                        title="The name of the Party's employer"
                                        pop-over="<h4>Auditor Name</h4><p>The name of the Party's employer.</p>"
                                    />

                                </div>

                                <div class="form-group row">                    

                                    <text-input 
                                        _class="col-md-6" 
                                        label="Contact Person"
                                        v-model="record.employercontact"
                                        title="The contact person at the Party's employer"
                                        pop-over="<h4>Contact Person</h4><p>The contact person at the Party's employer.</p>"
                                    />

                                </div>

                                <div class="form-group row">                    

                                    <text-input 
                                        _class="col-md-12" 
                                        label="Postal Address"
                                        v-model="record.employerpostal"
                                        title="The Postal Address of the Party's employer"
                                        pop-over="<h4>Postal Address</h4><p>The Postal Address of the Party's employer.</p>"
                                    />

                                </div>

                                <div class="form-group row">                    

                                    <text-input 
                                        _class="col-md-12" 
                                        label="Physical Address"
                                        v-model="record.employerphysical"
                                        title="The Physical Address of the Party's employer"
                                        pop-over="<h4>Physical Address</h4><p>The Physical Address of the Party's employer.</p>"
                                    />

                                </div>

                                <div class="form-group row">                    

                                    <text-input 
                                        _class="col-md-6" 
                                        label="Phone No"
                                        v-model="record.employerphone"
                                        title="The phone number of the Party's employer"
                                        pop-over="<h4>Phone Number</h4><p>The phone number of the Party's employer.</p>"
                                    />

                                    <text-input 
                                        _class="col-md-6" 
                                        label="Fax No"
                                        v-model="record.employerfax"
                                        title="The fax number of the Party's employer"
                                        pop-over="<h4>Fax Number</h4><p>The fax number of the Party's employer.</p>"
                                    />

                                </div>

                                <div class="form-group row">                    

                                    <text-input 
                                        _class="col-md-6" 
                                        label="Email"
                                        v-model="record.employeremail"
                                        title="The email address of the Party's employer"
                                        pop-over="<h4>Email Address</h4><p>The email address of the Party's employer.</p>"
                                    />

                                </div>

                            </fieldset>

                        </div>
                    </div>


                    <div class="row mt-3">

                        <div class="col-md-12">

                            <fieldset><legend>Auditors</legend>

                                <div class="form-group row">                    

                                    <text-input 
                                        _class="col-md-6" 
                                        label="Name"
                                        v-model="record.auditorname"
                                        title="The name of the Party's auditors"
                                        pop-over="<h4>Auditor Name</h4><p>The name of the Party's auditors.</p>"
                                    />

                                </div>

                                <div class="form-group row">                    

                                    <text-input 
                                        _class="col-md-6" 
                                        label="Contact Person"
                                        v-model="record.auditorcontact"
                                        title="The contact person at the Party's auditors"
                                        pop-over="<h4>Contact Person</h4><p>The contact person at the Party's auditors.</p>"
                                    />

                                </div>

                                <div class="form-group row">                    

                                    <text-input 
                                        _class="col-md-12" 
                                        label="Postal Address"
                                        v-model="record.auditorpostal"
                                        title="The Postal Address of the Party's auditors"
                                        pop-over="<h4>Postal Address</h4><p>The Postal Address of the Party's auditors.</p>"
                                    />

                                </div>

                                <div class="form-group row">                    

                                    <text-input 
                                        _class="col-md-12" 
                                        label="Physical Address"
                                        v-model="record.auditorphysical"
                                        title="The Physical Address of the Party's auditors"
                                        pop-over="<h4>Physical Address</h4><p>The Physical Address of the Party's auditors.</p>"
                                    />

                                </div>

                                <div class="form-group row">                    

                                    <text-input 
                                        _class="col-md-6" 
                                        label="Phone No"
                                        v-model="record.auditorphone"
                                        title="The phone number of the Party's auditors"
                                        pop-over="<h4>Phone Number</h4><p>The phone number of the Party's auditors.</p>"
                                    />

                                    <text-input 
                                        _class="col-md-6" 
                                        label="Fax No"
                                        v-model="record.auditorfax"
                                        title="The fax number of the Party's auditors"
                                        pop-over="<h4>Fax Number</h4><p>The fax number of the Party's auditors.</p>"
                                    />

                                </div>

                                <div class="form-group row">                    

                                    <text-input 
                                        _class="col-md-6" 
                                        label="Email"
                                        v-model="record.auditoremail"
                                        title="The email address of the Party's auditors"
                                        pop-over="<h4>Email Address</h4><p>The email address of the Party's auditors.</p>"
                                    />

                                </div>

                            </fieldset>

                        </div>
                    </div>

                    <div class="row mt-3">

                        <div class="col-md-12">

                            <fieldset><legend>Bank Accounts</legend>

                                <party-bank-accounts-table
                                    :id="uniqueId + '-party-form-bank-accounts-table'"
                                    :ref="uniqueId + '-party-bank-accounts-table'"
                                    :table-id="uniqueId + '-party-bank-accounts-table'"
                                    :lazyLoadFlag="true"
                                    :formTable="true"
                                    :searchInputFocus="false"
                                />

                            </fieldset>

                        </div>

                    </div>

                    <div v-show="isCompany() === true" class="row mt-3">

                        <div class="col-md-12">

                            <fieldset><legend>Shareholders</legend>

                                <party-shareholders-table
                                    :id="uniqueId + '-party-form-shareholders-table'"
                                    :ref="uniqueId + '-party-shareholders-table'"
                                    :table-id="uniqueId + '-party-shareholders-table'"
                                    :lazyLoadFlag="true"
                                    :formTable="true"
                                    :searchInputFocus="false"
                                />

                            </fieldset>

                        </div>

                    </div>

                </div>

                <div v-show="activeTab === 'Fica'" :id="id + '-Fica-form-tab-content'" class="form-tab-content">

                    <div class="form-group row">
                        
                        <div class="col-md-12">

                            <b-form-checkbox
                                :id="id + '-fica-exempt-flag'"
                                v-model="record.noficaflag"
                                name="noficaflag"
                                value="1"
                                unchecked-value="0"
                                switch 
                                size="lg"
                                >
                                <span>This Party is exempt from FICA</span>
                                <pop-over content="<h4>Exempt from FICA</h4>
                                <p>This Party will not be checked for FICA compliance by the program.</p>
                                "/>
                            </b-form-checkbox>
                        </div>
                    </div>   

                    <div v-show="isFicaCompliant() === false && isFicaEnabled() === true" class="row">
                        <div class="col-md-12">
                            <div class="alert alert-danger" role="alert">
                                ⚠️ This Party is not FICA compliant
                            </div>
                        </div>
                    </div>

                    <div v-show="ficaDocumentsRequested() === true" class="row">
                        <div class="col-md-12">
                            <div class="alert alert-success" role="alert">
                                ⚠️ FICA documents were requested on {{record.formattedficarequestdate}}
                            </div>
                        </div>
                    </div>


                    <div v-show="isFicaEnabled() === true" class="row mt-3">

                        <div class="col-md-12">

                            <fieldset><legend>Fica Documents ({{record.entitydescription}})</legend>

                                <party-fica-table
                                    :id="uniqueId + '-party-form-fica-table'"
                                    :ref="uniqueId + '-party-fica-table'"
                                    :table-id="uniqueId + '-party-fica-table'"
                                    :lazyLoadFlag="true"
                                    :formTable="true"
                                    :searchInputFocus="false"
                                />

                            </fieldset>

                        </div>

                    </div>

                </div>

                <div v-show="activeTab === 'Signatories'" :id="id + '-Signatories-form-tab-content'" class="form-tab-content">

                    <div class="row my-3">

                        <div class="col-md-12">

                            <fieldset><legend>Authorised Signatories</legend>

                                <party-signatories-table
                                    :id="uniqueId + '-party-form-signatories-table'"
                                    :ref="uniqueId + '-party-signatories-table'"
                                    :table-id="uniqueId + '-party-signatories-table'"
                                    :lazyLoadFlag="true"
                                    :formTable="true"
                                    :searchInputFocus="false"
                                />

                            </fieldset>

                        </div>

                    </div>

                    <div class="form-group row">
                        <text-input 
                        _class="col-md-12" 
                        popOver="<h4>Authorised By</h4>
                        <p>The phrase used to describe how the signatories were granted the authority to sign.</p>
                        <p>Eg: <em>duly authorised thereto by virtue of a resolution taken at Pretoria on 21 July 2004</em></p>" 
                        v-model="parlang.authorityphrase" 
                        name="authorityphrase" 
                        label="Authorised By" 
                        :lookupLibraryFlag="true"
                        lookupLibraryCategory="The phrase used to describe how the signatories"
                        />
                    </div>

                    <div class="form-group row">
                        <text-input 
                        _class="col-md-6" 
                        popOver="<h4>Capacity Phrase</h4>
                        <p>The phrase used in Conveyancing documents to describe the signatory's capacity to sign.</p>
                        <p>Eg: <em>in my capacity as the PASTOR of the church</em></p>" 
                        v-model="parlang.capacityphrase" 
                        name="capacityphrase" 
                        label="Capacity Phrase" 
                        :lookupLibraryFlag="true"
                        lookupLibraryCategory="The phrase used in Conveyancing documents to desc"
                        />

                        <div class="col-md-4">

                            <label>Date Resolution Signed</label>

                            <pop-over content="<h4>Resolution Date</h4><p>The date the resolution was signed.</p>"/>
                            <date-picker 
                                :config="$root.datePickerOptions"
                                v-model="record.formatteddateresolutionsigned" 
                            />
                            <div v-show="errors.dateresolutionsigned" v-html="errors.dateresolutionsigned" class="invalid-feedback"></div>

                        </div>

                    </div>

                    <div v-show="isTrust() === true" class="form-group row">
                        <text-input 
                        _class="col-md-12" 
                        popOver="<h4>High Court Division</h4>
                        <p>The High Court where the Trust/Estate is registered.</p>" 
                        v-model="parlang.trustdivision" 
                        name="trustdivision" 
                        label="High Court Division" 
                        :lookupLibraryFlag="true"
                        lookupLibraryCategory="The High Court where the trust/estate is registered"
                        />
                    </div>
                </div>

                <div v-show="activeTab === 'Miscellaneous'" :id="id + '-Miscellaneous-form-tab-content'" class="form-tab-content">

                    <div class="row">

                        <div class="col-xxl-6">


                            <div class="form-group row">

                                <text-input 
                                    _class="col-md-12" 
                                    label="Alternate Reference"
                                    v-model="record.alternateref"
                                    title="A unique value for this Party"
                                    pop-over="<h4>Alternate Reference</h4><p>Use this field as a way to store a unique value for this Party.</p><p>This allows other systems to reference this Party using a value other than the Party's name.</p>"
                                />

                            </div>

                            <div class="form-group row">                    

                                <text-input 
                                    _class="col-md-12" 
                                    label="Old Code"
                                    v-model="record.oldcode"
                                    title="The code used by this Party in a previous computer system (optional)"
                                    pop-over="<h4>Old Code</h4><p>The code used by this Party in a previous computer system.</p><p>It is an optional field.</p>"
                                />

                            </div>

                            <div class="form-group row">                    

                                <text-input 
                                    _class="col-md-12" 
                                    label="Docex"
                                    v-model="record.docex"
                                    title="The Docex address of the Party"
                                    pop-over="<h4>Docex Address</h4><p>The Docex address of the Party.</p>"
                                />

                            </div>

                            <div class="form-group row">                    

                                <text-input 
                                    _class="col-md-12" 
                                    label="POA Number"
                                    v-model="record.poanumber"
                                    title="The Power of Attorney number granted by the Registrar"
                                    pop-over="<h4>POA Number</h4><p>The Power of Attorney number granted by the Registrar.</p>"
                                />

                            </div>

                            <div class="form-group row">

                                <text-input 
                                    _class="col-md-12" 
                                    label="LAW Ref"
                                    v-model="record.lawref"
                                    title="The e4 reference for this Party"
                                    pop-over="<h4>LAW Ref</h4><p>The e4 reference for this Party.</p>"
                                />

                            </div>

                            <div class="form-group row">

                                <text-input 
                                    _class="col-md-12" 
                                    label="Legalsuite Firm Code"
                                    v-model="record.legalsuitefirmcode"
                                    pop-over="<h4>Firm Code</h4>
                                    <p>Fill this in if you wish to send your correspondence work electronically to this party/agent.</p><p>Contact this Party to get their Firm Code</p>"
                                />

                            </div>

                            <div class="form-group row">                    

                                <text-input 
                                    _class="col-md-12" 
                                    label="Occupation"
                                    v-model="record.auditorphysical"
                                    title="The Occupation of the Party's auditors"
                                    pop-over="<h4>Occupation</h4><p>A description of the Party's job title.</p>"
                                />

                            </div>

                            <div class="form-group row">

                                <select-default-matter
                                    :id="id + '-select-default-matter'"
                                    _class="col-md-12"
                                    label="Default Matter"
                                    title="The Matter used to bill this Party for sundry items (e.g. from the TradeMarks module)"
                                    :ref="uniqueId + '-select-default-matter'"
                                    :formRef="uniqueId + '-select-default-matter'"
                                    callback="defaultMatterSelected"
                                    parentName="selectDefaultMatter"
                                />

                            </div>

                            <div class="form-group row">                    

                                <text-input 
                                    _class="col-md-12" 
                                    label="Matter Message"
                                    v-model="record.mattertakeonreminder"
                                    title="A message that will pop-up when a User takes on a new Matter for this Party"
                                    pop-over="<h4>Matter Message</h4><p>A message that will pop-up when a User takes on a new Matter for this Party.</p>"
                                    :lookupLibraryFlag="true"
                                    lookupLibraryCategory="A message that will pop-up when a User takes on a new Matter for this Party"
                                />

                            </div>

                        </div>

                        <div class="col-xxl-6 mt-xl-3 mt-xxl-0">

                            <fieldset class="mt-2 mb-3"><legend>Remote Access</legend>

                                <div class="form-group row">                    

                                    <text-input 
                                        _class="col-md-8" 
                                        label="Password"
                                        v-model="record.remoteaccesspassword"
                                        title="The password allocated to this Party to allow access LegalSuite Online"
                                        pop-over="<h4>Remote Access Password</h4><p>The password allocated to this Party to access LegalSuite Online.</p>"
                                    />

                                </div>

                                <div class="form-group row">

                                    <div class="col-md-8">

                                        <label>Expiry Date</label>

                                        <pop-over content="<h4>Expiry Date</h4>
                                        <p>The date the password becomes invalid.</p><p>The Party will not have access after this date.</p>
                                        "/>
                                        <date-picker 
                                            v-model="record.remoteaccessexpiry" 
                                            :config="$root.datePickerOptions"
                                        />

                                    </div>

                                </div>

                            </fieldset>

                            <div class="form-group row mb-2">
                                
                                <div class="col-md-12">

                                    <b-form-checkbox
                                        :id="id + '-inactive-flag'"
                                        v-model="record.inactiveflag"
                                        name="inactiveflag"
                                        value="1"
                                        unchecked-value="0"
                                        switch 
                                        size="lg"
                                        >
                                        <span>This Party is inactive</span>
                                        <pop-over content="<h4>Inactive Party</h4>
                                        <p>This Party is not involved in any Matters and will not be displayed among the Active Parties in the Address Book</p>
                                        "/>
                                    </b-form-checkbox>
                                </div>
                            </div>   

                            <div v-show="$root.supervisorFlag" class="form-group row mb-2">
                                
                                <div class="col-md-12">

                                    <b-form-checkbox
                                        :id="id + '-lock-party-flag'"
                                        v-model="record.lockparty"
                                        name="lockparty"
                                        value="1"
                                        unchecked-value="0"
                                        switch 
                                        size="lg"
                                        >
                                        <span>This Party is locked</span>
                                        <pop-over content="<h4>Locked Party</h4>
                                        <p>Only a user with Supervisor rights can edit this Party (or unlock it).</p>
                                        "/>
                                    </b-form-checkbox>
                                </div>
                            </div>   

                        </div>

                    </div>

                    <div class="row mt-3">

                        <div class="col-md-12">

                            <fieldset><legend>Citations</legend>

                                <div class="form-group row">
                                    <text-area 
                                    _class="col-md-12"
                                    popOver="<h4>Defendant Citation</h4>
                                    <p>The legal description of the Defendant as cited on the summons.</p>"
                                    rows="6" 
                                    cols="50" 
                                    label="Defendant"
                                    v-model="record.defcitation" 
                                    name="defcitation" 
                                    
                                    :lookupLibraryFlag="true"
                                    lookupLibraryCategory="The legal description of the defendant as cited on the summons"
                                    />
                                </div>

                                <div class="form-group row">
                                    <text-area 
                                    _class="col-md-12"
                                    popOver="<h4>Plaintiff Citation</h4>
                                    <p>The legal description of the Plaintiff as cited on the summons.</p>"
                                    rows="6" 
                                    cols="50" 
                                    label="Plaintiff"
                                    v-model="record.placitation" 
                                    name="placitation" 
                                    
                                    :lookupLibraryFlag="true"
                                    lookupLibraryCategory="The legal description of the Plaintiff as cited on the summons"
                                    />
                                </div>

                                <div class="form-group row">
                                    
                                    <div class="col-md-12">

                                        <b-form-checkbox
                                            :id="id + '-domicilium-flag'"
                                            v-model="record.domiciliumflag"
                                            name="domiciliumflag"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            <span>The Physical Address is the Domicilium Address of this Party</span>
                                            <pop-over content="<h4>Domicilium Address</h4>
                                            <p>The Physical Address is the Party's domicilium (used to modify wording on the Summons)</p>
                                            "/>
                                        </b-form-checkbox>
                                    </div>
                                </div>   


                            </fieldset>

                        </div>

                    </div>

                    <div class="row mt-3">

                        <div class="col-md-12">

                            <fieldset><legend>Power of Attorney</legend>

                                <div class="form-group row">

                                    <div class="col-md-4">
                                        <label>Type of Power of Attorney</label>
                                        <pop-over content="<h4>Type of Power of Attorney</h4><p>The POA is a Special or General POA</p>"/>
                                        <v-select
                                            :options="powerOfAttorneyTypes" 
                                            :clearable="false" 
                                            :searchable="false" 
                                            :reduce="powerOfAttorneyTypes => powerOfAttorneyTypes.value"
                                            v-model="record.gpatype"
                                        />


                                    </div>

                                </div>

                                <div class="form-group row">                    

                                    <text-input 
                                        _class="col-md-6" 
                                        label="Signed By"
                                        v-model="record.gpasignedby"
                                    />

                                </div>

                                <div class="form-group row">                    

                                    <text-input 
                                        _class="col-md-6" 
                                        label="Signed At"
                                        v-model="record.gpasignedat"
                                    />

                                </div>

                                <div class="form-group row">

                                    <div class="col-md-6">

                                        <label>Signed On</label>

                                        <date-picker 
                                            :config="$root.datePickerOptions"
                                            v-model="record.formattedgpasignedon" 
                                        />
                                        <div v-show="errors.gpasignedon" v-html="errors.gpasignedon" class="invalid-feedback"></div>

                                    </div>
                                </div>

                                <div class="form-group row">                    

                                    <text-input 
                                        _class="col-md-6" 
                                        label="Power of Attorney Number"
                                        v-model="record.gpanumber"
                                    />

                                </div>

                            </fieldset>

                        </div>

                    </div>

                    <div class="row mt-3">

                        <div class="col-md-12">

                            <fieldset><legend>Notes</legend>

                                <div class="form-group row">
                                    <text-area 
                                    _class="col-md-12"
                                    popOver="<h4>Notes</h4>
                                    <p>General notes about this Party.</p>"
                                    rows="6" 
                                    cols="50" 
                                    label="Notes"
                                    v-model="record.notes" 
                                    name="notes" 
                                    />
                                </div>

                            </fieldset>

                        </div>

                    </div>

                    <div v-show="editing && record.createdid && record.createddate && record.createdtime" class="row mt-3">
                        <div class="col-md-12">
                            <div class="alert alert-primary" v-html="getCreatedByDetails()"/>
                        </div>
                    </div>

                    <div v-show="editing && record.updatedbyid && record.updatedbydate && record.updatedbytime" class="row mt-2">
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
                            <span title="Delete this Party"><i class="fa fa-trash fa-lg mr-2"></i>Delete</span>
                        </button>
                        <button v-show="activeTab == 'General' && editing" class="btn btn-large btn-danger mr-2" type="button" @click="emailParty">
                            <span title="Send an Email to this Party"><i class="fa fa-envelope-o fa-lg mr-2"></i>Email</span>
                        </button>
                        <button v-show="activeTab == 'General' && editing" class="btn btn-large btn-secondary" type="button" @click="generateDocument">
                            <span title="Generate a Document for this Party"><i class="fa fa-cog fa-lg mr-2"></i>Document</span>
                        </button>
                    </div>
                    <div>
                        <button class="btn btn-yellow form-button mr-3" @click="okClicked(false)" type="button" title="Save the Matter and continue editing"><i class="fa fa-check-square fa-lg mr-2"></i>Save</button>
                        <button class="btn btn-success form-button mr-3" @click="okClicked(true)" type="button" title="Save the Party and close"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>
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
import Multiselect from 'vue-multiselect';
import formTemplate from "@pages/form-template";
import modalTemplate from "@components/modals/modal-template";
import extraScreenTemplate from "@pages/extra-screen-template";

export default {

    mixins: [formTemplate, extraScreenTemplate, modalTemplate],

    components: {
        SelectDefaultMatter: () => import("@pages/matters/SelectMatter"),
        PartyNumberTable: () => import("@pages/parties/PartyNumberTable"),
        SelectPartyType: () => import("@pages/parties/SelectPartyType"),
        SelectPartyEntity: () => import("@pages/parties/SelectPartyEntity"),
        SelectPartyRole: () => import("@pages/parties/SelectPartyRole"),
        SelectDefaultLanguage: () => import("@pages/matters/SelectLanguage"),
        SelectMarriageCountry: () => import("@pages/parties/SelectCountry"),
        SelectDomiciledCountry: () => import("@pages/parties/SelectCountry"),
        SelectResidenceCountry: () => import("@pages/parties/SelectCountry"),
        SelectSpouseResidenceCountry: () => import("@pages/parties/SelectCountry"),
        PartyBankAccountsTable: () => import("@pages/parties/PartyBankAccountsTable"),
        PartySignatoriesTable: () => import("@pages/parties/PartySignatoriesTable"),
        PartyShareholdersTable: () => import("@pages/parties/PartyShareholdersTable"),
        PartyFicaTable: () => import("@pages/parties/PartyFicaTable"),
        SelectPostalCountry: Multiselect, SelectPhysicalCountry: Multiselect,
    },

    props: {
        resource: {type: String, default: 'Party' },
        secProc: {type: String, default: 'Browse - Address Book' },
        uniqueId: String,
    },

    data() {
        return {
            parlang: {},
            maritalTypes: [ 
                {label: 'Unmarried', value: 'UNM'},  
                {label: 'Out of Community', value: 'OUT'},  
                {label: 'In Community', value: 'INC'},  
                {label: 'Foreign', value: 'FOR'},  
                {label: 'Civil Union In Community', value: 'CUI'},  
                {label: 'Civil Union Out Of Community', value: 'CUO'},  
                {label: 'Other', value: 'OTM'},  
            ],
            powerOfAttorneyTypes: [ 
                {label: 'General', value: 'G'},  
                {label: 'Special', value: 'S'},  
            ],
            identityDocumentTypes: [ 
                {label: 'ID Document', value: 'I'},  
                {label: 'Passport', value: 'P'},  
                {label: 'Temporary Residence', value: 'T'},  
                {label: 'Other', value: 'O'},  
            ],
            ficaTable: null,
            partyNumberTable: null,
            signatoriesTable: null,
            shareholdersTable: null,
            bankAccountsTable: null,
            postalCountry: {
                id: null,
                description: null,
            },
            physicalCountry: {
                id: null,
                description: null,
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
                    pageName: "Contact",
                    title: "Contact Details",
                    iconClass: '',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "Marital",
                    title: "Marital",
                    iconClass: '',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "Financial",
                    title: "Financial",
                    iconClass: '',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "Fica",
                    title: "Fica",
                    iconClass: '',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "Signatories",
                    title: "Signatories",
                    iconClass: '',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "Miscellaneous",
                    title: "Miscellaneous",
                    iconClass: '',
                    visible: false,
                    active: false,
                },

            ],

        };
    },

    watch: {

        activeTab(newValue) {

            // Restrict tabbing to the tab contents
            $('#' + this.id + "-" + newValue + "-form-tab-content").tabGuard();
            //console.log("Length of the activeTab contents",$('#' + this.id + "-" + newValue + "-form-tab-content").length);


            if ( newValue === "Contact" ) {

                setTimeout(() => {

                    if ( this.partyNumberTable.table ) {

                        this.partyNumberTable.table.columns.adjust;

                    } else {

                        this.partyNumberTable.loadDataTable( this.adjustPartyNumberTableColumns ); 

                    }

                });


            } else if ( newValue === "Financial" ) {

                setTimeout(() => {

                    if ( this.isCompany() ) {

                        if ( this.shareholdersTable.table ) {

                            this.shareholdersTable.table.columns.adjust;

                        } else {

                            this.shareholdersTable.loadDataTable( this.adjustShareholdersTableColumns ); 

                        }
                    }

                    if ( this.bankAccountsTable.table ) {

                        this.bankAccountsTable.table.columns.adjust;

                    } else {

                        this.bankAccountsTable.loadDataTable( this.adjustBankAccountTableColumns ); 

                    }

                });

            } else if ( newValue === "Fica" ) {

                setTimeout(() => {

                    if ( this.ficaTable.table ) {

                        this.ficaTable.table.columns.adjust;

                    } else {

                        this.ficaTable.loadDataTable( this.getFicaStatus ); 

                    }

                });

            } else if ( newValue === "Signatories" ) {

                setTimeout(() => {

                    if ( this.signatoriesTable.table ) {

                        this.signatoriesTable.table.columns.adjust;

                    } else {

                        this.signatoriesTable.loadDataTable( this.adjustSignatoriesTableColumns ); 

                    }

                });

            } else if ( newValue === "Extra" ) {

                this.showExtraScreens();

            }
        }

    },

    methods: {

        ...mapMutations(['setCurrentParty']),

        editRecord(id) {

            this.editing = true;

            this.selectDefaultMatter.callingComponent = this;

            this.setGeneralTab();

            axios.post('/party/get/' + id)

            .then(response => {

                if ( response.data.errors ) {

                    showError('Error', response.data.errors);

                } else {

                    this.record = response.data.data[0];

                    this.record.updatedbyid = root.loggedInEmployeeId;

                    this.displayForm(); 

                    this.setCurrentParty({
                        recordid: this.record.recordid, 
                        code: this.record.matterprefix,
                        name: this.record.name
                    });

                    axios.post("/parlang/get",  {
                        where:["parlang.partyid,=," + this.record.recordid, "parlang.languageid,=," + this.record.defaultlanguageid]
                    })
                    .then(response => {

                        this.parlang = response.data.data[0];

                        this.initFormData();

                    }).catch( (error) => {
                        showError('Error getting ParLang data', error); 
                    });

                }

            }).catch( (error) => {
                showError('Error getting Party', error); 
            });

        },

        initNewRecord() {

            this.editing = false;

            this.setGeneralTab();

            let defaultCountry = root.countries.filter(country => country.recordid == 1)[0];

            this.record = {
                entityid: this.record.entityid ? this.record.entityid : '1',
                partytypeid: this.record.partytypeid ? this.record.partytypeid : '1',
                defaultroleid: this.record.defaultroleid ? this.record.defaultroleid : root.control.clientroleid,
                defaultlanguageid: this.record.defaultlanguageid ? this.record.defaultlanguageid : root.control.defaultlanguageid,
                postalcountryid: defaultCountry?.recordid,
                postalcountrydescription: defaultCountry?.description,
                physicalcountryid: defaultCountry?.recordid,
                physicalcountrydescription: defaultCountry?.description,
                identitydocumenttype: 'I',
                maritalstatus: 'UNM',
                unmarriedstatus: '0',
                clientflag: '0',
                inactiveflag: '0',
                parcategoryid: '3',
                birthdaysmsflag: '0',
            };

            this.record.createdid = root.loggedInEmployeeId;

            this.parlang = {};

            if ( this.record.partytypeid == '2') {
                this.parlang.title = this.record.defaultlanguageid == 1 ? 'Ms' : 'Mev';
            } else if ( this.record.partytypeid == '1') {
                this.parlang.title = this.record.defaultlanguageid == 1 ? 'Mr' : 'Mnr';
            }            

            if ( this.record.defaultlanguageid === root.control.afrikaansid ) {
                this.parlang.maritaldescription = 'Ongetroud';
            } else {
                this.parlang.maritaldescription = 'Unmarried';
            }


            this.displayForm(); 

            this.initFormData();

        },

        initFormData() {

            this.initExtraScreens();

            if ( this.editing ) {

                if ( this.isLocked() ) {
                    this.viewing = true;
                }

            }

            this.maritalTab = this.tabs.filter(tab => tab.pageName === 'Marital')[0];

            this.signatoriesTab = this.tabs.filter(tab => tab.pageName === 'Signatories')[0];

            this.setEntityTabs();

            setTimeout(() => {
                this.$refs.registrationDatePickerComponent.elem.data('DateTimePicker').widgetPositioning(
                    { horizontal: 'right', vertical: 'bottom' }
                );            
                this.$refs.birthDatePickerComponent.elem.data('DateTimePicker').widgetPositioning(
                    { horizontal: 'right', vertical: 'bottom' }
                );            
            }, 1000);

            if ( this.editing ) {

                //Get the Form Body
                let $thisForm = $('#' + this.id);
                let $formBody = $thisForm.find('.form-tab-body');

                //********************
                // Party Number Table
                //********************

                this.partyNumberTable = this.$refs[this.uniqueId + '-party-number-table'];

                this.partyNumberTable.table = null; // Reset to NULL so the ActiveTab watch reloads the table

                //Set the table Height 
                this.partyNumberTable.tableOptions = {
                    scrollY: (Math.round( $formBody.outerHeight() ) - 220)  + 'px',
                };

                this.partyNumberTable.subTitle = this.record.matterprefix + ' - ' + this.record.name;

                this.partyNumberTable.parentId = this.record.recordid; // To save the ParTele

                this.partyNumberTable.noEditButtonFlag = this.isLocked();

                this.partyNumberTable.whereRaw = ["ParTele.PartyId = " + this.record.recordid]; 


                //********************
                // Bank Accounts Table
                //********************

                this.bankAccountsTable = this.$refs[this.uniqueId + '-party-bank-accounts-table'];

                this.bankAccountsTable.table = null; // Reset to NULL so the ActiveTab watch reloads the table

                //Set the table Height
                this.bankAccountsTable.tableOptions = {
                    scrollY: (Math.round( $formBody.outerHeight() ) - 220)  + 'px',
                };

                this.bankAccountsTable.subTitle = this.record.matterprefix + ' - ' + this.record.name;
                this.bankAccountsTable.noEditButtonFlag = true;

                this.bankAccountsTable.whereRaw = ["accbank.accountid = " + this.record.recordid + " AND accbank.accounttype = 'M'"]; 

                //********************
                // Fica Table
                //********************

                this.ficaTable = this.$refs[this.uniqueId + '-party-fica-table'];

                this.ficaTable.table = null; // Reset to NULL so the ActiveTab watch reloads the table

                //Set the table Height 
                this.ficaTable.tableOptions = {
                    scrollY: (Math.round( $formBody.outerHeight() ) - 220)  + 'px',
                };

                this.ficaTable.subTitle = this.record.matterprefix + ' - ' + this.record.name;
                this.ficaTable.noEditButtonFlag = true;

                this.ficaTable.whereRaw = ["ParFica.PartyId = " + this.record.recordid + " AND EntityFica.EntityId = " + this.record.entityid]; 

                //********************
                // Shareholders Table
                //********************

                this.shareholdersTable = this.$refs[this.uniqueId + '-party-shareholders-table'];

                this.shareholdersTable.table = null; // Reset to NULL so the ActiveTab watch reloads the table

                //Set the table Height 
                this.shareholdersTable.tableOptions = {
                    scrollY: (Math.round( $formBody.outerHeight() ) - 270)  + 'px',
                };

                this.shareholdersTable.subTitle = this.record.matterprefix + ' - ' + this.record.name;
                this.shareholdersTable.noEditButtonFlag = true;

                this.shareholdersTable.where = ["PartyId,=," + this.record.recordid]; 

                //********************
                // Signatories Table
                //********************

                this.signatoriesTable = this.$refs[this.uniqueId + '-party-signatories-table'];

                this.signatoriesTable.table = null; // Reset to NULL so the ActiveTab watch reloads the table

                //Set the table Height 
                this.signatoriesTable.tableOptions = {
                    scrollY: (Math.round( $formBody.outerHeight() ) - 270)  + 'px',
                };

                this.signatoriesTable.subTitle = this.record.matterprefix + ' - ' + this.record.name;
                this.signatoriesTable.noEditButtonFlag = true;

                this.signatoriesTable.where = ["PartyId,=," + this.record.recordid]; 

            }

            this.setPartyEntityDropdown();

            this.setPartyTypeDropdown();

            this.setPartyRoleDropdown();

            this.setDefaultLanguageDropdown();

            // Only show Matters linked to this Party
            this.selectDefaultMatter.parentId = this.record.recordid;

            this.selectDefaultMatter.matter = {
                id: this.editing ? this.record.billingmatterid : null,
                fileref: this.editing ? htmlDecode(this.record.billingmatterfileref) : null,
                description: this.editing ? htmlDecode(this.record.billingmatterdescription) : null,
            };


            //****************************************************

            this.postalCountry = {
                recordid: this.record.postalcountryid,
                description: this.record.postalcountrydescription,
            };

            this.physicalCountry = {
                recordid: this.record.physicalcountryid,
                description: this.record.physicalcountrydescription,
            };

            this.selectDomiciledCountry.parlang = {
                recordid: null,
                description: htmlDecode(this.parlang.domiciledin),
            }

            this.selectMarriageCountry.parlang = {
                recordid: null,
                description: htmlDecode(this.parlang.marriagecountry),
            }

            this.selectResidenceCountry.record = {
                recordid: null,
                description: htmlDecode(this.record.countryofresidence),
            }

            this.selectSpouseResidenceCountry.record = {
                recordid: null,
                description: htmlDecode(this.record.spousecountryofresidence),
            }

            setTimeout(() => {
                $('input[name="name"]').focus();
            });

        },

        setScreenLayout() {

            if ( this.isJursitic() || this.isTrust() ) {

                this.$refs['text-input-name'].setLabel = 'Name';
                this.$refs['text-input-name'].setTitle = 'The registered name of the Party';
                this.$refs['text-input-name'].setPopOver = '<h4>Name</h4><p>The official or registered name of the Party</p>';

                this.$refs['text-input-alternativename'].setLabel = 'Trading as';
                this.$refs['text-input-alternativename'].setTitle = 'Known as';
                this.$refs['text-input-alternativename'].setPopOver = '<h4>Trading as</h4><p><p>The <em>name</em> field is the legally registered name of the Party. Some jusristic entities also have a <em>trading name</em> which they use for commercial purposes. If so, you should specify it here.</p>';

                this.$refs['text-input-taxnumber'].setLabel = 'Income Tax Number';


                this.$refs['text-input-firstname'].setVisible = false;
                this.$refs['text-input-title'].setVisible = false;
                this.$refs['text-input-initials'].setVisible = false;

            } else {
                
                this.$refs['text-input-name'].setLabel = 'Surname';
                this.$refs['text-input-name'].setTitle = 'The surname of the person';
                this.$refs['text-input-name'].setPopOver = '<h4>Surname</h4><p>The surname or family name of the person</p>';

                this.$refs['text-input-alternativename'].setLabel = 'Known as';
                this.$refs['text-input-alternativename'].setTitle = 'The nickname or common name of the person (optional)';
                this.$refs['text-input-alternativename'].setPopOver = '<h4>Known as</h4><p>An alternative or <em>friendly</em> name for this Party.</p><p>The first and last names are the formal names of the Party. It can be useful, however, to have a more friendly or colloquial name which can be used when addressing letters or emails to the Party.</p><p>For example, a Party may have the first name of Richard, but is known as Dick and it would be more appropriate to use this in correspondence with the Party.</p><p><strong>Note:</strong> This is an <em>optional</em> field.</p>';

                this.$refs['text-input-taxnumber'].setLabel = 'Income Tax Number';

                this.$refs['text-input-firstname'].setVisible = true;
                this.$refs['text-input-title'].setVisible = true;
                this.$refs['text-input-initials'].setVisible = true;

            }

        },

        partyEntitySelected(id, description, category, juristicflag) {

            this.record.entityid = id;
            this.record.entitycategory = category;
            this.record.entityjuristicflag = juristicflag;


            if ( juristicflag == '1' ) {
                
                //IF Juristic Entity Selected but the Party Type is not Juristic
                if ( this.record.partypecategory == '1' ) {
                    this.resetPartyTypeDropdown();
                }

            } else {
                
                //IF Person Entity Selected but the Party Type is Juristic
                if ( this.record.partypecategory != '1' ) {
                    this.resetPartyTypeDropdown();
                }

            }

            this.setScreenLayout();

        },

        partyTypeSelected(id, description, category) {

            this.record.partytypeid = id;
            this.record.partypecategory = category;

            // Change the title based on Male or Female
            if ( category == '1') {
                if ( id == '2') {
                    this.parlang.title = this.record.defaultlanguageid == 1 ? 'Ms' : 'Mev';
                } else {
                    this.parlang.title = this.record.defaultlanguageid == 1 ? 'Mr' : 'Mnr';
                }
            }

            if ( this.isJursitic() || this.isTrust() ) {

                // THERE IS A JURISTIC ENTITY SET BUT A MALE or FEMALE PARTY TYPE HAS BEEN SELECTED
                if ( category == '1') {

                    this.record.entityid = '1'; //ADULT

                } else {

                    this.record.entityid = this.setAppropriateEntityId();

                }

                this.setPartyEntityDropdown();

            } else {

                // THERE IS A PERSON ENTITY SET BUT A JURISTIC PARTY TYPE HAS BEEN SELECTED
                if ( category !== '1') {

                    this.record.entityid = this.setAppropriateEntityId();

                    this.setPartyEntityDropdown();

                }

            }

            this.setEntityTabs();

        },

        setAppropriateEntityId() {

            if ( parseInt(this.record.partytypeid) >= 3 && parseInt(this.record.partytypeid) <= 5 ) {
                return '5'; // Close Corporation
            } else if ( parseInt(this.record.partytypeid) >= 6 && parseInt(this.record.partytypeid) <= 10 ) {
                return '6'; // Private Company
            } else if ( parseInt(this.record.partytypeid) >= 11 && parseInt(this.record.partytypeid) <= 12 ) {
                return '14'; // Court Official
            } else if ( parseInt(this.record.partytypeid) >= 13 && parseInt(this.record.partytypeid) <= 15 ) {
                return '6'; // Private Company
            } else if ( parseInt(this.record.partytypeid) >= 16 && parseInt(this.record.partytypeid) <= 19 ) {
                return '9'; // Trust
            } else if ( parseInt(this.record.partytypeid) >= 20 && parseInt(this.record.partytypeid) <= 23 ) {
                return '11'; // Government Body
            } else if ( parseInt(this.record.partytypeid) >= 24 && parseInt(this.record.partytypeid) <= 34 ) {
                return '18'; // Non Profit Organisation
            } else if ( parseInt(this.record.partytypeid) >= 35 && parseInt(this.record.partytypeid) <= 39 ) {
                return '14'; // Court Official
            } else  {
                return '15'; // Other
            }

            /*

                {
                "data": [
                    {
                    "recordid": "1",
                    "description": "Male",
                    "category": "1"
                    },
                    {
                    "recordid": "2",
                    "description": "Female",
                    "category": "1"
                    },
                    {
                    "recordid": "3",
                    "description": "Business",
                    "category": "2"
                    },
                    {
                    "recordid": "4",
                    "description": "Estate Agent",
                    "category": "2"
                    },
                    {
                    "recordid": "5",
                    "description": "Mortgage Originator",
                    "category": "2"
                    },
                    {
                    "recordid": "6",
                    "description": "Financial Institution",
                    "category": "2"
                    },
                    {
                    "recordid": "7",
                    "description": "Insurance Company",
                    "category": "2"
                    },
                    {
                    "recordid": "8",
                    "description": "Medical Aid",
                    "category": "2"
                    },
                    {
                    "recordid": "9",
                    "description": "Pension Fund",
                    "category": "2"
                    },
                    {
                    "recordid": "10",
                    "description": "Hotel",
                    "category": "2"
                    },
                    {
                    "recordid": "11",
                    "description": "Advocate",
                    "category": "2"
                    },
                    {
                    "recordid": "12",
                    "description": "Attorney",
                    "category": "2"
                    },
                    {
                    "recordid": "13",
                    "description": "Hospital",
                    "category": "2"
                    },
                    {
                    "recordid": "14",
                    "description": "Developer",
                    "category": "2"
                    },
                    {
                    "recordid": "15",
                    "description": "Other Business",
                    "category": "2"
                    },
                    {
                    "recordid": "16",
                    "description": "Inter Vivos Trust",
                    "category": "3"
                    },
                    {
                    "recordid": "17",
                    "description": "Deceased Estate",
                    "category": "4"
                    },
                    {
                    "recordid": "18",
                    "description": "Insolvent Estate",
                    "category": "4"
                    },
                    {
                    "recordid": "19",
                    "description": "Other Estate",
                    "category": "4"
                    },
                    {
                    "recordid": "20",
                    "description": "Local",
                    "category": "5"
                    },
                    {
                    "recordid": "21",
                    "description": "Provincial",
                    "category": "5"
                    },
                    {
                    "recordid": "22",
                    "description": "National",
                    "category": "5"
                    },
                    {
                    "recordid": "23",
                    "description": "Other Govt Body",
                    "category": "5"
                    },
                    {
                    "recordid": "24",
                    "description": "Religous Body",
                    "category": "6"
                    },
                    {
                    "recordid": "25",
                    "description": "Charity",
                    "category": "6"
                    },
                    {
                    "recordid": "26",
                    "description": "Political Party",
                    "category": "6"
                    },
                    {
                    "recordid": "27",
                    "description": "School",
                    "category": "6"
                    },
                    {
                    "recordid": "28",
                    "description": "Trade Union",
                    "category": "6"
                    },
                    {
                    "recordid": "29",
                    "description": "Club",
                    "category": "6"
                    },
                    {
                    "recordid": "30",
                    "description": "Other NGO",
                    "category": "6"
                    },
                    {
                    "recordid": "31",
                    "description": "Body Corporate",
                    "category": "9"
                    },
                    {
                    "recordid": "32",
                    "description": "University",
                    "category": "7"
                    },
                    {
                    "recordid": "33",
                    "description": "Co op",
                    "category": "7"
                    },
                    {
                    "recordid": "34",
                    "description": "Other Statutory Body",
                    "category": "7"
                    },
                    {
                    "recordid": "35",
                    "description": "Judge",
                    "category": "8"
                    },
                    {
                    "recordid": "36",
                    "description": "Sheriff",
                    "category": "8"
                    },
                    {
                    "recordid": "37",
                    "description": "Registrar",
                    "category": "8"
                    },
                    {
                    "recordid": "38",
                    "description": "Clerk",
                    "category": "8"
                    },
                    {
                    "recordid": "39",
                    "description": "Other Court Official",
                    "category": "8"
                    },
                    {
                    "recordid": "40",
                    "description": "Other Type",
                    "category": "9"
                    },
                    {
                    "recordid": "41",
                    "description": "Unknown Type",
                    "category": "10"
                    },
                    {
                    "recordid": "42",
                    "description": "Police Station",
                    "category": "5"
                    },
                    {
                    "recordid": "43",
                    "description": "Non Profit Organisation",
                    "category": "6"
                    },
                    {
                    "recordid": "44",
                    "description": "Association",
                    "category": "6"
                    },
                    {
                    "recordid": "45",
                    "description": "Mortis Causa Trust",
                    "category": "3"
                    },
                    {
                    "recordid": "46",
                    "description": "Reserved5",
                    "category": "11"
                    },
                    {
                    "recordid": "47",
                    "description": "Reserved6",
                    "category": "11"
                    },
                    {
                    "recordid": "48",
                    "description": "Reserved7",
                    "category": "11"
                    },
                    {
                    "recordid": "49",
                    "description": "Reserved8",
                    "category": "11"
                    },
                    {
                    "recordid": "50",
                    "description": "Reserved9",
                    "category": "11"
                    }
                ]
                }

            */


        },

        partyRoleSelected(id, description, roleScrnFlag, roleScrnId) {

            this.record.defaultroleid = id;

        },

        setPartyEntityDropdown() {

            let data = root.partyEntities.filter(entity => entity.recordid == this.record.entityid)[0];

            if ( data?.recordid ) {

                this.selectPartyEntity.record = {
                    recordid: data.recordid,
                    description: htmlDecode(data.description),
                    category: data.category,
                    jusristicflag: data.jusristicflag,
                };

                this.record.entityid = data.recordid;
                this.record.entitycategory = data.category;
                this.record.entityjusristicflag = data.jusristicflag;

                this.setScreenLayout();

            } else {
                showError( 'Error', 'Party Entity (' + this.record.entityid + ') not found');
            }


        },

        setPartyTypeDropdown() {

            let data = root.partyTypes.filter(type => type.recordid == this.record.partytypeid)[0];

            if ( data?.recordid ) {

                this.selectPartyType.record = {
                    recordid: data.recordid,
                    description: htmlDecode(data.description),
                    category: data.category,
                };

                this.record.partytypeid = data.recordid;
                this.record.partypecategory = data.category;

            } else {
                showError( 'Error', 'Party Type (' + this.record.partytypeid + ') not found');
            }

        },

        setPartyRoleDropdown() {

            let data = root.partyRoles.filter(role => role.recordid == this.record.defaultroleid)[0];

            if ( data?.recordid ) {

                this.selectPartyRole.record = {
                    recordid: data.recordid,
                    description: htmlDecode(data.description),
                    roleScrnId: data.rolescrnid,
                    roleScrnFlag: data.rolescrnflag
                };

            } else {
                showError( 'Error', 'Party Role (' + this.record.defaultroleid + ') not found');
            }

        },

        setDefaultLanguageDropdown() {

            // Fix for bad data
            if (!this.record.defaultlanguageid || this.record.defaultlanguageid == '0') {
                this.record.defaultlanguageid = root.control.defaultlanguageid;
            }

            let data = root.languages.filter(language => language.recordid == this.record.defaultlanguageid)[0];

            if ( data?.recordid ) {

                this.selectDefaultLanguage.record = {
                    recordid: data.recordid,
                    description: htmlDecode(data.description),
                };

            } else {
                showError( 'Error', 'Party Default Language (' + this.record.defaultlanguageid + ') not found');
            }

        },

        resetPartyTypeDropdown() {

            this.record.partytypeid = '1'; //Male

            if ( this.isJursitic() || this.isTrust() ) {

                this.record.partytypeid = this.isTrust() ? '16' : '3'; // Trust or Business

            }

            this.setEntityTabs();

            this.setPartyTypeDropdown();

        },

        setGeneralTab() {

            this.activeTab = 'General';
            this.tabs[0].active = true;

            for (let index = 1; index < this.tabs.length; index++) {

                this.tabs[index].active = false;

                if ( this.tabs[index].pageName == 'Contact' || this.tabs[index].pageName == 'Fica' || this.tabs[index].pageName == 'Financial' || this.tabs[index].pageName == 'Miscellaneous' ) {

                    // These are the permanent tabs
                    this.tabs[index].visible = true;

                } else {

                    // These Tabs are set visible via setEntityTabs()
                    this.tabs[index].visible = false;

                }

            }

        },

        setEntityTabs() {

            //console.log("setEntityTabs this.isJursitic(),this.isTrust()",this.isJursitic(),this.isTrust());

            if ( this.editing ) {

                if ( this.isJursitic() || this.isTrust() ) {
                    
                    this.maritalTab.visible = false;

                    this.signatoriesTab.visible = true;


                } else {

                    this.maritalTab.visible = true;

                    this.signatoriesTab.visible = false;

                }

            } else {


                for (let index = 1; index < this.tabs.length; index++) {

                    if (this.tabs[index].pageName === 'Marital') {

                        if ( this.isJursitic() || this.isTrust() ) {

                            this.tabs[index].visible = false;

                        } else {

                            this.tabs[index].visible = true;

                        }

                    } else {
                        this.tabs[index].visible = false;
                    }

                }


            }

        },

        defaultMatterSelected(id, fileref, description) {

            this.record.billingmatterid = id;

            this.selectDefaultMatter.matter = {
                recordid: id,
                fileref: htmlDecode(fileref),
                description: htmlDecode(description),
            };



        },

        defaultLanguageSelected(id, description) {

            this.selectDefaultLanguage.record = {
                recordid: id,
                description: htmlDecode(description),
            };

            if (this.record.recordid) {

                this.saveParLang( this.record )

                .then( () => {

                    this.record.defaultlanguageid = id;

                    axios.post("/parlang/get",  { 
                        where:["parlang.partyid,=," + this.record.recordid, "parlang.languageid,=," + this.record.defaultlanguageid]
                    })
                    
                    .then(response => {

                        this.parlang = response.data.data[0];

                    }).catch( (error) => {
                        showError('Error getting ParLang data', error); 
                    });

                });

            } else {

                this.record.defaultlanguageid = id;

            }

        },

        unmarriedStatusChanged( value ) {

            if ( value === '0' ) {
                this.parlang.maritaldescription = 'Unmarried';
            } else if ( value === '1' ) {
                this.parlang.maritaldescription = 'Divorced';
            } else if ( value === '2' ) {
                if ( this.selectPartyType.record.recordid === '1') {
                    this.parlang.maritaldescription = 'Widower';
                } else {
                    this.parlang.maritaldescription = 'Widow';
                }
            }

            $('#' + this.id + ' input[name="maritaldescription"]').val(this.parlang.maritaldescription);

        },

        marriageCountrySelected(id, description) {

            this.parlang.marriagecountry = description;

            this.selectMarriageCountry.record = {
                recordid: id,
                description: htmlDecode(description),
            };

        },

        domiciledCountrySelected(id, description) {

            this.parlang.domiciledin = description;

            this.selectDomiciledCountry.record = {
                recordid: id,
                description: htmlDecode(description),
            };

        },

        residenceCountrySelected(id, description) {

            this.record.countryofresidence = description;

            this.selectResidenceCountry.record = {
                recordid: id,
                description: htmlDecode(description),
            };

        },

        spouseResidenceCountrySelected(id, description) {

            this.record.spousecountryofresidence = description;

            this.selectSpouseResidenceCountry.record = {
                recordid: id,
                description: htmlDecode(description),
            };

        },

        isLocked() {

            let returnValue = false;
            

            if ( this.record.lockparty ) {
                
                if ( this.record.lockparty == '1' ) {
                    
                    if ( !root.supervisorFlag ) {
                        returnValue = true;
                    }

                }
            }

            return returnValue;
        },

        isJursitic() {
            return parseInt(this?.record.entityid) > 2 && this?.record.entityid !== '16' ? true : false;
        },

        isTrust() {

            return this?.record.entityid === '9' || this?.record.entityid === '10' ? true : false;

        },

        isCompany() {

            return this?.record.entityid === '5' || this?.record.entityid === '6' || this?.record.entityid === '7' ? true : false;

        },

        isFicaEnabled() {

            return this.record?.noficaflag === '1' ? false : true;
        },

        isFicaCompliant() {

            return this.record?.ficacompliantflag === '1' ? true : false;

        },

        ficaDocumentsRequested() {

            let returnValue = false;

            let ficaRequestDateFlag = this.record?.ficarequestdate > 0 ? true : false;

            if ( !this.isFicaCompliant() && ficaRequestDateFlag ) {

                let requestDate = convertFromClarionDate( this.record.ficarequestdate, false);

                let daysDiff = moment().diff(requestDate, 'days');

                // 30 days have NOT passed since they requested the documents
                if ( daysDiff < 30 ) {
                    returnValue = true;
                }

            }

            return returnValue;

        },

        getFicaStatus() {

            this.ficaTable.table.columns.adjust;

            let _this = this;

            this.record.ficacompliantflag = this.ficaTable.table.data().any() ? '1' : '0';

            this.ficaTable.table.rows().every( function ( index ) {

                let data = this.data();

                if ( data.date && parseInt(data.date) > 0 ) {

                    if ( parseInt(data.expiry) > 0 ) {

                        let ficaExpiresDate = getFicaExpiryDate(data.date, data.expiry, false);

                        if ( ficaExpiresDate.isBefore(moment()) ) {
                            
                            _this.record.ficacompliantflag = '0'; //Document has expired

                        }
                    
                    }
                    
                } else {

                    if ( parseInt(data.expiry) > 0 ) {

                        _this.record.ficacompliantflag = '0'; //Document has not been checked

                    }
                }

            });

        },

        adjustPartyNumberTableColumns() {
            this.partyNumberTable.table.columns.adjust;
        },

        adjustSignatoriesTableColumns() {
            this.signatoriesTable.table.columns.adjust;
        },

        adjustBankAccountTableColumns() {
            this.bankAccountsTable.table.columns.adjust;
        },

        adjustShareholdersTableColumns() {
            this.shareholdersTable.table.columns.adjust;
        },

        getCreatedByDetails() {

            let returnData = '';

            let employee = this.record.createdid ? root.employees.filter(employee => employee.recordid == this.record.createdid)[0] : null;

            if (employee && this.record.createddate && this.record.createdtime) {

                returnData = 'Created by ' + employee.name + ' on ' + convertFromClarionDate(this.record.createddate)  + ' at ' + convertFromClarionTime(this.record.createdtime);

            }
            return returnData;

        },

        getUpdatedByDetails() {

            let returnData = '';

            let employee = this.record.updatedbyid ? root.employees.filter(employee => employee.recordid == this.record.updatedbyid)[0] : null;

            if (employee && this.record.updatedbydate && this.record.updatedbytime) {

                returnData = 'Last updated by ' + employee.name + ' on ' + convertFromClarionDate(this.record.updatedbydate)  + ' at ' + convertFromClarionTime(this.record.updatedbytime);

            }
            return returnData;

        },

        generateDocument() {

            this.generateDocumentsSource = 'Party';

            root.selectTemplates.load(this, 'Document', this.generateDocumentsSource);

        },

        templatesSelected(id) {

            this.selectedRows = [this.record.recordid];

            primeGenerateDocumentPreviewer(this, id);

        },

        emailParty() {

            // This is in common.js
            emailThisParty(this.record.recordid, true);

        },

        async okClicked( closeFlag = true ) {

            if ( !this.parlang.name ) {
                showError('No Name specified','Please give the Party a name');
                return;
            }

            // Check any required Extra Screen Fields
            if ( this.extraScreensVisibleFlag ) {

                let requiredField = await this.checkExtraScreenRequiredFields();

                if ( requiredField ) {
                    
                    this.setExtraScreenTab();                    

                    return;

                }

                //The only write back Tables are Matter, MatParty, ColData, BondData, ConveyData
                //Only add this to the Matter Form and MatParty Form
                //await this.checkExtraWriteBackFields();

            }

            root.$snotify.simple('Please wait...', 'Saving Party', { timeout: 10000, icon: 'img/cogs.gif' });

            this.record.defaultlanguageid = this.selectDefaultLanguage.record.recordid;
            this.record.entityid = this.selectPartyEntity.record.recordid;
            this.record.partytypeid = this.selectPartyType.record.recordid;
            this.record.defaultroleid = this.selectPartyRole.record.recordid;
            this.record.postalcountryId = this.postalCountry.recordid;
            this.record.physicalcountryId = this.physicalCountry.recordid;
            this.record.loggedinemployeeid = root.loggedInEmployeeId;

            // Must send ParLang as a sub object of the party object

            await axios.post( '/party/' + (this.savedFlag ? 'update' : 'store'), {...this.record, parlang: this.parlang})

            .then(response => {

                root.$snotify.clear();

                if (response.data.errors || response.data.error) {

                    this.setGeneralTab();

                    if (response.data.errors) { 
                        showError('Error saving Party', response.data.errors); 
                    } else { 
                        this.errors = response.data.error; 
                    }

                } else {

                    this.record.recordid = response.data.data[0].recordid;

                    this.setCurrentParty({
                        recordid: response.data.data[0].recordid, 
                        code: response.data.data[0].matterprefix,
                        name: response.data.data[0].name
                    });

                    this.highlightRow(response.data.data[0].recordid, {
                        where: "party.matterprefix,<,'" + response.data.data[0].matterprefix + "'",
                        orderBy: 'MatterPrefix',
                    });

                    this.saveExtraScreens(); //Only does it if the user has clicked on the Extra Screen Tab

                    if ( this.editing ) {

                        if ( closeFlag ) {
                            this.closeForm();
                        } else {
                            this.savedFlag = true;
                        }

                    } else {

                        this.savedFlag = true;

                        this.editRecord(response.data.data[0].recordid);
                    }

                }

            }).catch( (error) => {
                root.$snotify.clear();
                showError('Error saving Party', error); 
            });

        },

        saveParLang( party ) {

            return new Promise(async (resolve, reject) => {

                try {

                    this.parlang.partyid = party.recordid;
                    this.parlang.languageid = party.defaultlanguageid;

                    let response = await axios.post( '/parlang/' + (this.savedFlag ? 'update' : 'store'), this.parlang);

                    if (response.data.errors) { 

                        showError( 'Error saving ParLang', response.data.errors);

                        reject();

                    } else {

                        this.parlang.recordid = response.data.data[0].recordid;

                        this.errors = {};

                        resolve();

                    }

                } catch(error) { 

                    showError('Error saving ParLang', error); 

                    reject();
                };
                
            });

        },

        pageTitle() {
            return (this.record.matterprefix) ? this.record.matterprefix + ' - ' + this.record.name : '';
        },
        
    },

}  

</script>
