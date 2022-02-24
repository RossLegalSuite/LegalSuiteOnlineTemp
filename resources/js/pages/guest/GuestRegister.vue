<template>

<div id="guest-register-form" class="card h-100 border-0">
    
    <div class="card-header">
        <div class="d-flex justify-content-between">
            <h3><i class="fa fa-edit mr-2"></i>Register</h3>
            <page-close-button @closeClicked="hide"/>
        </div>
    </div>

    <div class="card-body overflow-auto pt-2 p-3">

        <div v-show="!checkRegisterFlag" class="row">
            <div class="col-lg-12 mb-4">

                <fieldset>
                    <legend>Registration</legend>

                    <div class="form-group row">
                        <text-input 
                            _class="col-md-6"
                            popOver="<h4>Firm Code</h4>                                        
                            <p><strong>Enter your Company's Firm Code</strong></p>"
                            popOverContainer="#guest-register-form"
                            v-model="record.firmcode" 
                            name="firmcode" 
                            label="Firm Code"
                            :error="errors.firmcode"
                        />
                        <div class="col-md-6" style="align-self: flex-end;">
                            <button 
                                id="checkRegister" 
                                class="btn btn-info form-button mb-1" 
                                type="button" 
                                @click="checkRegister">
                                Register
                            </button>
                        </div>
                    </div>
                    <p>Please enter your Company's Firm Code, this will check if the company is registered on the LegalSuite API and grant LegalSuite Online Access.</p>
                </fieldset>

            </div>
        </div>

        <div v-show="checkRegisterFlag" class="row">

            <div class="col-lg-12 mb-3">
                <fieldset>

                    <legend>Registration</legend>

                    <div class="form-group row">

                        <div class="col-lg-12">

                            <p>There is no Company with this FirmCode Registered, please enter the Company and SQL Server Details below to Register</p>

                        </div>
                    
                    </div>

                </fieldset>
            </div>    

            <div class="col-lg-6">

                <fieldset>
                    <legend>Company</legend>

                    <div class="form-group row">
                        <text-input 
                            _class="col-md-12"
                            popOver="<h4>User</h4>                                        
                            <p><strong>Enter your first name and last name here</strong></p>
                            <p>Note: Since you are the person who registered the company, you will be added as and Employee with <em>Administrator privileges</em>.</p>
                            <p>The Adminstrator has the highest security level and has access to all areas of the program and can add additional Employees, for example, once you have logged into the program.</p>"
                            popOverContainer="#guest-register-form"
                            v-model="record.name" 
                            name="name" 
                            label="Name"
                            :error="errors.name"
                        />
                    </div>

                    <div class="form-group row">

                        <text-input 
                            _class="col-md-12" 
                            popOver="<h4>Email Address</h4>
                            <p>Enter your email address here.</p>
                            <p>You will use this email address to login to this Company.</p>"
                            popOverContainer="#guest-register-form"
                            v-model="record.email" 
                            name="email" 
                            label="Email"
                            :error="errors.email"/>
                    </div>         

                    <div class="form-group row">

                        <text-input 
                            _class="col-md-12" 
                            popOver="<h4>Website</h4>
                            <p>Enter the address of your website here.</p>"
                            popOverContainer="#guest-register-form"
                            v-model="record.website" 
                            name="website" 
                            label="Website"
                            :error="errors.website"/>

                    </div>                                        

                    <div class="form-group row">

                        <text-input 
                            _class="col-md-6" 
                            popOver="<h4>Password</h4>
                            <p>Please provide a strong password.</p>
                            <p>You will use this password to login to this Company.</p>"
                            popOverContainer="#guest-register-form"
                            v-model="record.password" 
                            type="password" 
                            name="password" 
                            label="Password"
                            :error="errors.password"/>

                    </div>                                        
                    <div class="form-group row">

                        <text-input 
                            _class="col-md-6" 
                            popOver="<h4>password_confirmation</h4>
                            <p>Please confirm your password.</p>
                            <p>You will use this password to login to this Company.</p>"
                            popOverContainer="#guest-register-form"
                            v-model="record.password_confirmation" 
                            type="password" 
                            name="password_confirmation" 
                            label="Password"
                            :error="errors.password_confirmation"/>

                    </div>                                        


                </fieldset>

            </div>

            <div class="col-lg-6">
                <fieldset>
                    <legend>Database</legend>

                    <div class="form-group row">
                        <text-input 
                            _class="col-md-12"
                            popOver="<h4>Host</h4><p>xxx.</p>"
                            popOverContainer="#guest-register-form"
                            v-model="record.dbhost" 
                            name="dbhost" 
                            label="Host"
                            :error="errors.dbhost"
                        />
                    </div>
                    <div class="form-group row">
                        <text-input 
                            _class="col-md-12"
                            popOver="<h4>Port</h4><p>xxx.</p>"
                            popOverContainer="#guest-register-form"
                            v-model="record.dbport" 
                            name="dbport" 
                            label="Port"
                            :error="errors.dbport"
                        />
                    </div>
                    <div class="form-group row">
                        <text-input 
                            _class="col-md-12"
                            popOver="<h4>Database</h4><p>xxx</p>"
                            popOverContainer="#guest-register-form"
                            v-model="record.dbdatabase" 
                            name="dbdatabase" 
                            label="Database"
                            :error="errors.dbdatabase"
                        />
                    </div>
                    <div class="form-group row">
                        <text-input 
                            _class="col-md-12"
                            popOver="<h4>Username</h4><p>xxx</p>"
                            popOverContainer="#guest-register-form"
                            v-model="record.dbusername" 
                            name="dbusername" 
                            label="Username"
                            :error="errors.dbusername"
                        />
                    </div>
                    <div class="form-group row">
                        <text-input 
                            _class="col-md-12"
                            popOver="<h4>Password</h4><p>xxx</p>"
                            popOverContainer="#guest-register-form"
                            v-model="record.dbpassword" 
                            name="dbpassword" 
                            label="Password"
                            :error="errors.dbpassword"
                        />
                    </div>


                </fieldset>
                
            </div>

        </div>


    </div>

    <form-buttons v-if="checkRegisterFlag" :editing="false" saveText="Register" saveTitle="Register a Company" record="Company" @ok-clicked="okClicked" @cancel-clicked="hide" />

</div>

</template>

<script>


export default {


    data() {
        return {
            checkRegisterFlag:false,
            submittingFlag: false,
            activePage: 'Register',
            record: {},
            errors: {},
        }
    },

    mounted() {

        var urlParams = new URLSearchParams(window.location.search);

        if ( urlParams.has('register') ) {

            this.$root.$refs['pages'].$refs['right-page'].activePage = 'Register';

        }
    },


    methods: {

        loadComponent() {

            this.submittingFlag = false;

            this.errors = {};

            // ************************** FOR TESTING ***************************
            if ( appEnvironment === 'local') {

                this.record.company_code = 'ACME';
                this.record.company_name = 'Acme Inc';
                this.record.company_trading_name = 'Acme Attorneys';
                this.record.email = 'admin@acme.co.za';
                this.record.password = 'secret';
                this.record.password_confirmation = 'secret';
                this.record.name = 'Rick Jordan';

                this.record.website = 'legalsuite.co.za';

                this.record.dbhost = 'legalsuite.dyndns.org';
                this.record.dbport = '1433';
                this.record.dbdatabase = 'legalsuite';

                this.record.dbusername = 'ls';
                this.record.dbpassword = 'password';

                $('input[name="company_code"]').val(this.record.company_code);
                $('input[name="company_name"]').val(this.record.company_name);
                $('input[name="company_trading_name"]').val(this.record.company_trading_name);
                $('input[name="name"]').val(this.record.name);
                $('input[name="email"]').val(this.record.email);
                $('input[name="password"]').val(this.record.password);
            }

            // ******************************************************************

        },


        checkRegister() {

            this.submittingFlag = true;

            this.errors = {}; // Clear previous errors

            // root.$snotify.simple('Checking Register', 'Please wait...', { timeout: 0, icon: 'img/cogs.gif' });

            axios.post('/checkRegister', this.record)

            .finally(() => { this.submittingFlag = false; })

            .then(response => {
                // console.log("Response");
                // console.log(response);
                // root.$snotify.clear();

                if (response.data.errors) {


                    if (response.data.errors) { 
                        showError( 'Error', response.data.errors);
                    } 

                } else if (response.data.response == 'Client not Registered') {
                    this.checkRegisterFlag = true;

                }

                this.errors = {};

                // root.$snotify.simple('Registering your Company', 'Please wait...', { timeout: 60, icon: 'img/check.png' });

                this.activePage = "Login";
            });

        },

        async companyNameChanged() {

            if (!this.record.company_trading_name) {
                
                this.record.company_trading_name = this.record.company_name;
                $('input[name="company_trading_name"]').val(this.record.company_name);

            }

            if (!this.record.company_code) {

                try {

                    let response = await axios.post('/generateCompanyCode',{
                        name: this.record.company_name
                    });

                    this.record.company_code = response.data;
                    
                    $('input[name="company_code"]').val(response.data);

                } catch(error) { 

                    showError('Error generating Company Code', error); 

                };
                

            }



        },

        checkData() {

            //showError('Access denied','<p>You cannot delete ' + rowData.description + '</p><p>It is associated with this email.</p>');

            if ( ! $('input[name="name"]')[0].checkValidity() ) {
                validationError('Please enter your name'); 
                return false;
            }

            if ( ! $("#email")[0].checkValidity() ) {
                validationError('Please enter your email address'); 
                return false;
            }

            if ( ! $("#password")[0].checkValidity() ) {
                validationError('Please provide a password'); 
                return false;
            }
            

            if ( ! $("#company_code")[0].checkValidity() ) {
                validationError('Please enter a company code'); 
                return false;
            }

            if ( ! $("#company_name")[0].checkValidity() ) {
                validationError('Please enter a company name'); 
                return false;
            }
            
            if ( ! $("#company_trading_name")[0].checkValidity() ) {
                validationError('Please enter a trading name for the company'); 
                return false;
            }
            
            
            return true;
        },

        okClicked() {

            this.submittingFlag = true;

            this.errors = {}; // Clear previous errors

            this.record.company_timezone = "+02:00";
            this.record.company_country = "ZA";

            root.$snotify.simple('Registering your Company', 'Please wait...', { timeout: 0, icon: 'img/cogs.gif' });

            axios.post('/register', this.record)

            .finally(() => { this.submittingFlag = false; })
            
            .then(response => {

                this.submittingFlag = false;

                if (response.data.errors) {

                    root.$snotify.clear();

                    if (response.data.errors) { showError( 'Error', response.data.errors);} else { this.errors = response.data.errors; }

                } else {

                    this.errors = {};

                    document.cookie = "company=" + this.record.company_code;
                    document.cookie = "login=" + this.record.email;

                    root.$snotify.clear();
                    window.location = '/?login';
                    showSuccess( 'Success', response);
                    // window.location = '/?registration=success';

                    
                }

            });

        },


        hide() {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].closePage(this.activePage);

        },

    },

}

</script>
