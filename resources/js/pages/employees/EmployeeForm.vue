<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lg' : ''">

        <div :class="modal ? 'modal-content employees-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header employees-bg' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="!editing">Employee will be Added</span>
                            <span v-else v-html="pageTitle()"></span>
                        </h3>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="card-body overflow-auto p-3">

                <div class="form-group row">

                    <text-input _class="col-md-7" v-model="record.name" :required="true" name="name" label="Name" :error="errors.name"/>

                </div>  

                <div class="form-group row">

                    <text-input _class="col-md-7" v-model="record.email" name="email" label="Email" :error="errors.email"/>

                </div>

                <div v-if="!editing" class="form-group row">

                    <text-input _class="col-md-7" v-model="record.password" :required="true" name="password" label="Password" :error="errors.password"/>

                </div>

                <div v-if="$root.control.smtpAuthentication === 'Yes' && $root.control.smtpServer" class="row">

                    <div class="col-xxl-6 mt-xxl-0 mt-xl-3">

                        <fieldset  style="background: lightgrey;" class="mt-3"><legend>Email Server Login Details</legend>

                            <div class="form-group row">
                                <text-input _class="col-md-12" 
                                    popOver="<h4>User Name</h4>
                                    <p>You can send emails directly from Ettorney and also add received emails to a Matter or Party's Correspondence.</p>
                                    <p>To enable Ettorney to send email and read your email inbox, you need to specify the login details used by this Employee to access the company's Email Server.</p>
                                    <p>You can get these details from your IT dept, hosting company or by examining the settings you use in the email client you normally use to send and receive email.</p>
                                    "
                                    :popOverContainer="'#' + id"
                                    v-model="record.smtpUserName" 
                                    name="smtpUserName" 
                                    label="User Name"
                                    :error="errors.smtpUserName"
                                />
                            </div>

                            <div class="form-group row">
                                <text-input _class="col-md-12" 
                                    v-model="record.smtpPassword" 
                                    name="smtpPassword" 
                                    label="Password" 
                                    :error="errors.smtpPassword"
                                />
                            </div>

                            <div class="text-right">
                                <button v-show="record.smtpUserName && record.smtpPassword" 
                                :id="id + '-test-email-button'" 
                                class="btn btn-danger form-button mt-1" 
                                type="button" 
                                @click="testEmail"
                                >
                                <span title="Check if you can login to the Email Server">
                                    <i class="fa fa-cog fa-lg mr-2"></i>Test Connection</span>
                                </button>
                            </div>


                        </fieldset>

                    </div>

                </div>

            </div>

            <div class="modal-footer justify-content-between">
                <div>
                    <button v-show="editing && !readOnly" class="btn btn-primary form-button mr-3" type="button" @click="deleteClicked">
                        <span title="Delete this Employee"><i class="fa fa-trash fa-lg mr-2"></i>Delete</span>
                    </button>
                    <button v-show="editing && record.id == root.loggedInEmployeeId && !readOnly" class="btn btn-secondary form-button mr-3" type="button" @click="changePassword">
                        <span title="Change the Password for this Employee"><i class="fa fa-recycle fa-lg mr-2"></i>Change Password</span>
                    </button>

                </div>
                <div>
                    <button v-show="!readOnly" class="btn btn-success form-button mr-3" @click="okClicked" type="button" title="Save the Employee"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>
                    <button class="btn btn-danger form-button" @click="closeForm" type="button" title="Exit without saving"><i class="fa fa-times-circle fa-lg mr-2"></i>Close</button>
                </div>
            </div>    

        </div>
    </div>

</div>

</template>

<script>

import { mapMutations } from 'vuex';
import FormTemplate from "@pages/form-template";
import modalTemplate from "@components/modals/modal-template";
import Multiselect from 'vue-multiselect';

export default {

    mixins: [FormTemplate, modalTemplate],


    computed: {
        loggedInEmployeeId() {
            return root.loggedInEmployeeId; 
        }
    },

    props: {
        resource: {type: String, default: 'Employees' },
        parentType: {
            type: String,
            default: 'General'
        },
        title: {
            type: String,
            default: '',
        }, 
        uniqueId: String,
    },

    methods: {

        ...mapMutations(['setCurrentEmployee']),

        editRecord(id) {

            axios.post('/employees/get',{recordid: id})

            .then(response => {

                this.record = response.data.data[0];

                this.setCurrentEmployee({
                    id: this.record.id, 
                    name: this.record.name,
                    email: this.record.email
                });

                this.initFormData();

            });

        },

        initNewRecord() {

            if ( this.parentType === 'General') root.$refs['pages'].$refs["left-page"].clearPages();

            this.record = {
                name: null,
                email: null,
                password: null,
            };

            this.initFormData();

            setTimeout(() => $('#' + this.id + ' input[name="name"]').focus() );

        },

        initFormData() {

            this.displayForm();

        },

        async testEmail() {

            root.$snotify.simple('Logging in to Email Server', 'Connecting', { timeout: 0, icon: 'img/cogs.gif' });

            await this.$root.emailModal.checkSmtpDetails()

            .then( ( smtpDetails) => {

                let params = {
                    incomingServer: smtpDetails.incomingServer,
                    incomingPort: smtpDetails.incomingPort,
                    incomingEncryption: smtpDetails.incomingEncryption,
                    userName: this.record.smtpUserName,
                    password: this.record.smtpPassword,
                };

                axios.post('/mail/testIncomingServer',params)

                .then(response => {

                    root.$snotify.clear();

                    if (response.data.error) {

                        showError('Email Server Error',response.data.error);

                    } else {

                        root.$snotify.simple('Connected to Email Server', 'Success', { timeout: 3000, icon: 'img/check.png' });

                    }

                });

            });


        },


        okClicked() {

            axios.post('/employees/store', this.record)
            
            .then(response => {

                if (response.data.errors) {

                    if (response.data.errors.general) { showError( 'Error', response.data.errors.general[0]);} else { this.errors = response.data.errors; }

                } else {

                    this.errors = {};

                    this.setCurrentEmployee({
                        id: response.data.id, 
                        name: response.data.name,
                        email: response.data.email
                    });

                    if (this.table) {
                        this.highlightTableRow(response.data.id, response.data.name);
                    } else {
                        this.closeForm();
                    }

                }

            }).catch(error => { showError('Error saving ' + this.table.singular, error); });

        },

        changePassword() {
            showError('To Do', 'changePassword');
        },

        highlightTableRow( id, name ) {

            axios.post('/employees/getTablePosition', {
                name: name,
            })

            .then(response => {

                this.table.jumpToRow(id, response.data);
                
                this.closeForm();

            });

        },             

        pageTitle() {
            
            return (this.record.name) ? this.record.name : '';

        },


    },

}  
</script>
