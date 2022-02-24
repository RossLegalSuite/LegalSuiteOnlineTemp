<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lg' : ''">

        <div :class="modal ? 'modal-content matter-parties-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header matter-parties-bg' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3 class="modal-title">
                            <span v-if="!editing">Party will be Added</span>
                            <span v-else v-html="pageTitle()"></span>
                        </h3>
                        <h6 class="mb-0" v-html="pageSubTitle()"></h6>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="modal-body form-tab-body overflow-auto p-3" :style="modal ? 'height:65vh' : ''">

                <form-tabs :tabs="tabs"/>

                <div v-show="activeTab === 'General'" class="form-tab-content">

                    <div class="form-group row">
                        <select-party 
                            :popOver="partyPopOverText()" 
                            :popOverContainer="'#' + id"
                            :id="id + '-select-party'" 
                            :ref="id + '-select-party'" 
                            :formRef="id + '-select-party'"
                            _class="col-md-8"
                            :error="errors.party" 
                        />
                    </div>


                    <div class="row">

                        <div class="col-md-12">

                            <div v-if="errors.matterid" v-html="errors.matterid[0]" class="invalid-feedback"></div>
                            <div v-if="errors.sorter" v-html="errors.sorter[0]" class="invalid-feedback"></div>
                            <div v-if="errors.partyid" v-html="errors.partyid[0]" class="invalid-feedback"></div>

                        </div>

                    </div>

                    <div class="form-group row">
                        <select-party-role 
                            :popOver="partyRolePopOverText()" 
                            :popOverContainer="'#' + id"
                            :readOnly="editing && role.recordid && $root.control.clientroleid === role.recordid ? true : false"
                            :id="id + '-select-party-role'" 
                            :ref="id + '-select-party-role'" 
                            :formRef="id + '-select-party-role'"
                            _class="col-md-6"
                            :error="errors.party" 
                        />
                    </div>

                    <div class="form-group row">

                        <text-input 
                            _class="col-md-4"
                            popOver="<h4>Their Reference</h4><p>A Party may have their own reference for a Matter. If so, you can add it here and then use it as <em>their reference</em> in correspondence with them regarding this Matter.</p>"
                            :popOverContainer="'#' + this.id"
                            v-model="record.reference"
                            name="reference"
                            label="Their Reference"

                        />
                        
                    </div>

                    <div class="form-group row">

                        <select-default-language
                            popOver="<h4>Default Language</h4>
                            <p>The preferred language of this Party.</p>" 
                            callback="defaultLanguageSelected"
                            parentName="selectDefaultLanguage"
                            label="Language"
                            _class="col-xxl-8 mt-3 mt-xxl-0"
                            :id="id + '-select-language'"
                            :ref="id + '-select-language'"
                            :form-ref="id + '-select-language'"
                            :error="errors.languageid"
                        />


                    </div>

                    <div class="form-group row">

                        <text-input 
                            _class="col-md-8"
                            popOver="<h4>Matter Description</h4><p>You can give each Party a custom Matter Description so that it is more meaningful to them when used in correspondence to the Party.</p>"
                            :popOverContainer="'#' + this.id"
                            v-model="record.matterdescription"
                            name="matterdescription"
                            label="Matter Description"

                        />
                        
                    </div>

                    <div v-show="editing && role.recordid && (role.recordid == $root.control.defendantroleid || role.recordid == $root.control.plaintiffroleid)" class="row mt-3">

                        <div class="col-lg-12">

                            <fieldset><legend>Nomine Officio</legend>

                                <div class="form-group row">

                                    <div class="col-md-12">

                                        <label v-text="'Nomine Officio?'" style="margin-bottom: 0.6rem !important;"/>

                                        <pop-over content="<h4>Nomine Officio</h4><p>This Party is representing another legal entity or person, i.e they are not acting in their personal capacity.</p>"/>

                                        <b-form-checkbox
                                            :id="id + '-no-flag'"
                                            v-model="record.noflag"
                                            name="noFlag"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            This Party is representing another legal entity
                                        </b-form-checkbox>

                                    </div>

                                </div>

                                <div class="form-group row">

                                    <text-input 
                                        _class="col-md-12"
                                        popOver="<h4>Capacity</h4><p>The capacity they are acting as (e.g. Trustee/ Curator).</p>"
                                        v-model="record.nocapacity"
                                        name="nocapacity"
                                        label="Capacity"

                                    />
                                    
                                </div>

                                <div class="form-group row">

                                    <text-input 
                                        _class="col-md-12"
                                        popOver="<h4>Principal</h4><p>The Principal they are acting on behalf of (e.g. The ABC Trust).</p>"
                                        v-model="record.noprincipal"
                                        name="noprincipal"
                                        label="Principal"

                                    />
                                    
                                </div>


                            </fieldset>

                        </div>
                        
                    </div>

                    <div v-show="editing && role.recordid && role.recordid == $root.control.suretyroleid" class="row mt-3">

                        <div class="col-lg-8">

                            <fieldset><legend>Surety Details</legend>

                                <div class="form-group row">

                                    <div class="col-md-12">

                                        <label v-text="'Unlimited?'" style="margin-bottom: 0.6rem !important;"/>

                                        <pop-over content="<h4>Unlimited Security</h4><p>The Surety is not limited to a specific amount.</p>"/>

                                        <b-form-checkbox
                                            :id="id + '-surety-unlimited-flag'"
                                            v-model="record.suretyunlimitedflag"
                                            name="suretyunlimitedflag"
                                            value="1"
                                            unchecked-value="0"
                                            switch 
                                            size="lg"
                                            >
                                            The Surety is not limited to a specific amount
                                        </b-form-checkbox>

                                    </div>

                                </div>

                                <div v-show="record.suretyunlimitedflag && record.suretyunlimitedflag != '1'" class="form-group row">
                                    <text-input 
                                        _class="col-md-8" 
                                        popOver="<h4>Surety Amount</h4>
                                        <p>The Amount of the Surety</p>"
                                        label="Amount" 
                                        type="number" 
                                        input-class="form-input-number"
                                        v-model="record.suretyamount"
                                        name="suretyamount" 
                                        title="The Amount of the Surety" 
                                        :error="errors.suretyamount"
                                    />
                                </div>

                                <div class="form-group row">
                                    <text-area 
                                    _class="col-md-12"
                                    popOver="<h4>Security Details</h4>
                                    <p>A description of any security linked to this suretyship</p>"
                                    rows="6" 
                                    cols="50" 
                                    v-model="record.suretysecurity" 
                                    name="suretysecurity" 
                                    label="Security Details"
                                    :error="errors.suretysecurity"/>
                                </div>


                            </fieldset>

                        </div>

                    </div>
                </div>

                <div v-show="activeTab === 'Extra'" class="form-tab-content">

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
                        <button v-if="activeTab == 'General' && editing && showDeleteButton()" class="btn btn-large btn-primary" type="button" @click="deleteClicked">
                            <span title="Delete"><i class="fa fa-trash fa-lg mr-2"></i>Delete</span>
                        </button>

                        <button v-show="activeTab == 'General' && editing" class="btn btn-large btn-danger mr-2" type="button" @click="emailParty">
                            <span title="Send an Email to this Party"><i class="fa fa-envelope-o fa-lg mr-2"></i>Email</span>
                        </button>
                        <button v-show="activeTab == 'General' && editing" class="btn btn-large btn-secondary" type="button" @click="generateDocument">
                            <span title="Generate a Document for this Party"><i class="fa fa-cog fa-lg mr-2"></i>Document</span>
                        </button>

                    </div>
                    <div>
                        <button class="btn btn-success form-button mr-3" @click="okClicked" type="button" title="Save"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>
                        <button class="btn btn-danger form-button" type="button" data-dismiss="modal" title="Exit without saving"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
                    </div>
            </div>

        </div>
    </div>
</div>

</template>

<script>

import { mapMutations } from 'vuex';
import { mapGetters } from 'vuex';
import modalTemplate from "@components/modals/modal-template";
import formTemplate from "@pages/form-template";
import extraScreenTemplate from "@pages/extra-screen-template";

export default {

    mixins: [formTemplate, extraScreenTemplate, modalTemplate],

    components: {
        SelectParty: () => import("@pages/parties/SelectParty"),
        SelectPartyRole: () => import("@pages/parties/SelectPartyRole"),
        SelectDefaultLanguage: () => import("@pages/matters/SelectLanguage"),
    },

    props: {
        resource: {type: String, default: 'MatParty' },
    },

    data() {
        return {
            parentMatter: {},
            role: {
                id: null,
                description: null,
            },
            party: {},
            matter: {},
            formTitle: '',
            activeTab: 'General',
            tabs: [
                {
                    pageName: "General",
                    title: "Details",
                    iconClass: '',
                    visible: true,
                    active: true,
                },
            ],
        };
    },    

    computed: {

        ...mapGetters(['currentMatter','currentParty']),

    },

    watch: {

        activeTab(newValue) {

            if ( newValue === "Extra" ) {

                this.showExtraScreens();

            }

        },

    },

    methods: {

        ...mapMutations(['setCurrentParty','setCurrentMatter']),

        editRecord(id) {

            this.setGeneralTab();

            axios.post("/matparty/get/" + id)
            
            .then(response => {

                if ( response.data.errors ) {

                    showError('Error', response.data.errors);

                } else {

                    this.record = response.data.data[0];

                    this.setCurrentParty({
                        id: this.record.partyid, 
                        code: this.record.partymatterprefix,
                        name: this.record.partyname
                    });

                    this.setCurrentMatter(this.record);
                    
                    this.displayForm(); 

                    this.initFormData();

                    // These are needed to evaluate the Extra Screens
                    this.getMatter();
                    this.getParty();

                    setTimeout(() => $('#' + this.id + ' input[name="reference"]').focus() );
                }

            }).catch( (error) => {
                showError('Error getting Matter Party', error); 
            });

        },

        initNewRecord() {

            this.setGeneralTab();

            this.record = {
                matterid: this.parentMatter.id,
                partyid: null,
                languageid: root.control.defaultlanguageid,
                roleid: this.record.roleid ? this.record.roleid : null,
                sorter: 0,
                reference: '',
            };


            this.displayForm(); 

            this.initFormData();

        },

        initFormData() {

            this.setPartyDropdown();

            this.setPartyRoleDropdown();

            this.setDefaultLanguageDropdown();

            this.initExtraScreens();

        },

        setPartyDropdown() {

            this.selectParty.setReadOnly = !this.showDeleteButton();

            this.selectParty.partyName = this.record.partyname ? this.record.partyname : '';

        },        

        setPartyRoleDropdown() {

            this.selectPartyRole.setReadOnly = !this.showDeleteButton();

            if ( this.record.roleid ) {

                let data = root.partyRoles.filter(role => role.recordid == this.record.roleid)[0];

                if ( data?.recordid ) {

                    this.selectPartyRole.record = {
                        recordid: data.recordid,
                        description: htmlDecode(data.description),
                    };

                } else {
                    showError( 'Error', 'Party Role (' + this.record.roleid + ') not found');
                }

            } else {

                    this.selectPartyRole.record = {
                        recordid: null,
                        description: '',
                    };

            }

        },        

        getMatter() {
            
            axios.post("/matter/get/" + this.record.matterid)

            .then(response => {

                if ( response.data.errors ) {

                    showError('Error', response.data.errors);

                } else {

                    this.matter = response.data.data[0];
                }

            }).catch( (error) => {
                showError('Error getting the Matter for the MatParty', error); 

            });

        },

        getParty() {

            axios.post("/party/get/" + this.record.partyid)
            
            .then(response => {

                if ( response.data.errors ) {

                    showError('Error', response.data.errors);

                } else {

                    this.party = response.data.data[0];
                }

            }).catch( (error) => {
                showError('Error getting the Party for the MatParty', error); 

            });

        },

        setGeneralTab() {

            this.activeTab = 'General';
            this.tabs[0].active = true;

            for (let index = 1; index < this.tabs.length; index++) {

                this.tabs[index].active = false;
                this.tabs[index].visible = this.editing ? true : false;

            }

        },

        setDefaultLanguageDropdown() {

            // Fix for bad data
            if (!this.record.languageid || this.record.languageid == '0') {
                this.record.languageid = root.control.defaultlanguageid;
            }

            let data = root.languages.filter(language => language.recordid == this.record.languageid)[0];

            if ( data?.recordid ) {

                this.selectDefaultLanguage.record = {
                    recordid: data.recordid,
                    description: htmlDecode(data.description),
                };

            } else {
                showError( 'Error', 'Party Default Language (' + this.record.defaultlanguageid + ') not found');
            }

        },

        showDeleteButton() {

            let returnValue = true;

            if ( !this.editing ) {

                returnValue = false;

            } else if ( this.record.roleid == root.control.clientroleid && parseInt(this.record.sorter) == 1 ) {

                returnValue = false;
            }

            return returnValue;

        },


        generateDocument() {

            this.generateDocumentsSource = 'MatParty';

            root.selectTemplates.load(this, 'Document', this.generateDocumentsSource);

        },

        templatesSelected(id) {

            this.selectedRows = [this.record.recordid];

            primeGenerateDocumentPreviewer(this, id);

        },


        emailParty() {

            // This is in common.js
            emailThisMatParty(this.record.recordid, true);

        },


        partyRoleSelected(id, description, roleScrnFlag, roleScrnId) {

            this.record.roleid = id;
        },

        defaultLanguageSelected(id, description) {

            this.record.languageid = id;

            this.selectDefaultLanguage.record = {
                recordid: id,
                description: htmlDecode(description),
            };
        },

        async okClicked() {

            if (!this.record.partyid) {
                
                showError('No Party selected','Please select a Party');
                return;

            } else if (!this.record.roleid) {
                
                showError('No Role selected','Please select a Role');
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
                await this.checkExtraWriteBackFields();

            }

            root.$snotify.simple('Please wait...', 'Saving Party', { timeout: 10000, icon: 'img/cogs.gif' });

            try {
                
                if ( this.editing ) {

                    let checkSorter = await axios.post("/matter_parties/checkSorter", this.record );

                    this.record.sorter = checkSorter.data;

                } else {

                    this.record.sorter = this.countRoles() + 1;

                }

                axios.post("/matparty/store", this.record )

                .then(response => {

                    if (response.data.errors) { 

                        root.$snotify.clear();

                        showError( 'Error', response.data.errors);

                    } else {

                        this.errors = {};

                        //console.log("Saved MatParty response.data.data",response.data.data);

                        this.saveExtraScreens(); //Only does it if the user has clicked on the Extra Screen Tab

                        if ( this.editing ) {

                            this.table.table.ajax.reload( () => {

                                //this.table.clientRoleExists = this.checkIfClientRoleExists();

                                this.highlightTableRow(response.data.data[0].recordid, response.data.data[0].matterid, this.role.description, response.data.data[0].sorter);

                            });

                        } else {

                            this.highlightTableRow(response.data.data[0].recordid, response.data.data[0].matterid, this.role.description, response.data.data[0].sorter);

                        }

                        root.$snotify.clear();

                    }

                }).catch( (error) => {
                    throw error;
                });


            } catch(error) { 

                root.$snotify.clear();

                showError('Error saving Party', error); 
            }


        },

        highlightTableRow( recordId, matterId, roleDescription, sorter ) {

            axios.post('/matter_parties/getTablePosition', {
                recordId: recordId,
                matterId: matterId,
                roleDescription: roleDescription,
                sorter: sorter,
            })

            .then(response => {

                if (response.data.errors) { 

                    showError( 'Error', response.data.errors);

                } else {

                    this.table.jumpToRow(recordId, response.data.data);
                    
                    this.hide();
                }
            }).catch( (error) => {
                showError('Error getting Matter Party Table Position', error); 
            });

        },     

        countRoles() {

            let countRoles = 0;
            let _this = this;

            this.table.table.rows().every( function () {

                let thisRow = this.data();

                if ( parseInt(thisRow.roleid) === parseInt(_this.record.roleid) ) countRoles++;

            });

            return countRoles;

        },

        moveMatterPartyUp(id) {

            axios.post("/matter_parties/move-up",{ recordId: id })
            
            .then(response => {

                console.log("move-up response",response);

                if (response.data.error) {

                    showError( 'Error Moving Matter Party', response.data.error);

                } else {

                    if ( !this.table ) this.setTableComponent();

                    this.table.table.ajax.reload( () => {

                        $('#' + this.table.tableId + ' tbody tr.highlighted').removeClass('highlighted');
                        $('#' + this.table.tableId + ' tbody tr#' + id).addClass('highlighted');

                    });

                }

            });
            
        },

        checkIfClientRoleExists() {

            if ( !this.table ) this.setTableComponent();
            
            let clientRoleExists = false;
            let _this = this;

            this.table.table.rows().every( function ( index ) {
                
                let thisRow = this.data();

                if ( parseInt(thisRow.roleid) === parseInt(root.control.clientroleid) ) clientRoleExists = true;

            });

            return clientRoleExists;

        },

        pageTitle() {

            if ( this.editing ) {

                return this.party?.name;

            } else {

                return  'Party will be Added';
            }

        },

        pageSubTitle() {

            if ( !this.modal && this.editing ) {

                if ( this.selectPartyRole && this.selectPartyRole.record && this.selectMatter && this.selectMatter.matter) {

                    return '<strong>' + this.selectPartyRole.record.description + ':</strong> ' + this.selectMatter.matter.matter;

                } else {

                    return  '';
                }

            } else {
                return '';
            }
        },

        matterPopOverText() {

            let returnValue = '<h4>Matter</h4><p>The Matter this Party is linked to.</p>';

            if (this.editing && this.role.recordid && root.control.clientroleid === this.role.recordid) {

                returnValue += '<p><strong>Note:</strong> You cannot change the Client of a Matter.</p>' 
            }

            return returnValue;

        },

        partyPopOverText() {

            let returnValue = `<h4>Party</h4><p>A Matter can have a number of Parties linked to it who play different Roles on the Matter.</p>
                                        <p>For example, besides a Client, another Party may be the Defendant on the Matter and another Party may be a Witness.</p>
                                        <p><strong>Hint:</strong> If the Client is a jusristic Entity (such as a company), it can be useful to add someone within the organization with the Role of <em>Contact Person</em> so you can generate Correspondence addressed to this person (who is acting on behalf of the Company).</p>`;
                                        
            if (this.editing && this.role && root.control.clientroleid === this.role.recordid) {

                returnValue += '<p><strong>Note:</strong> You cannot change the Client of a Matter.</p>' 
            }

            return returnValue;

        },

        partyRolePopOverText() {

            let returnValue = `<h4>Party's Role</h4>
            <p>Specify the Role the Party plays on this Matter.</p>
            <p>A Party can play <em>more than one Role</em> on a Matter.</p>
            <p>For example, the Client can also be the Plaintiff in a Matter as well as a Witness. In this case, the same Party will play 3 <em>Roles</em> on the Matter - Client, Plaintiff and Witness.</p>`;
                                        
            if (this.editing && this.role && root.control.clientroleid === this.role.recordid) {

                returnValue += '<p><strong>Note:</strong> You cannot change the Client of a Matter.</p>' 
            }

            return returnValue;

        },


    },


}

</script>
