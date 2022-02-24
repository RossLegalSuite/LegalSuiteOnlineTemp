<template>

<div id="guest-login-form" class="card h-100 border-0">
    
    <div class="card-header">
        <div class="d-flex justify-content-between">
            <h3><i class="fa fa-lock mr-2"></i>Login to LegalSuite</h3>
            <page-close-button @closeClicked="hide"/>
        </div>
    </div>

    <div class="card-body overflow-auto pl-4 p-3">
        
        <div v-if="errors.database" class="row mb-3">

            <div class="col-lg-12">

                <fieldset>
                    <legend>Database Error</legend>
                        <div v-if="errors.database" v-html="errors.database[0]" class="invalid-feedback"></div>
                </fieldset>
            </div>

        </div>

        <div class="form-group row">

            <text-input 
                _class="col-md-4"
                popOver="<h4>Company</h4>
                <p>Enter the Code of the Company you want to login to here.</p>
                <p>Note: This code is assigned to your firm when LegalSuite Online is activated.</p>"
                popOverContainer="#guest-login-form"
                v-model="record.company" 
                name="company" 
                label="Company"
                :error="errors.company"
            />

        </div>  

        <div class="form-group row">

            <text-input 
                _class="col-md-4" 
                popOver="<h4>User</h4><p>Enter the <em>Employee Code</em> you use to login to the LegalSuite program.</p>"
                popOverContainer="#guest-login-form"
                v-model="record.login" 
                name="login" 
                label="User"
                :error="errors.login"/>

        </div>                                        

        <div class="form-group row">

            <text-input 
                _class="col-md-4" 
                popOver="<h4>Password</h4><p>Enter the password you use to login to the LegalSuite program.</p>"
                popOverContainer="#guest-login-form"
                v-model="record.password" 
                type="password" 
                name="password" 
                label="Password"
                :error="errors.password"/>

        </div>                                        

    </div>

    <form-buttons v-if="!submittingFlag" :editing="false" saveText="Login" saveTitle="Login to the program" record="User" @ok-clicked="okClicked" @cancel-clicked="hide" />

</div>

</template>


<script>

export default {

    data() {
        return {
            submittingFlag: false,
            activePage: 'Login',
            record: {},
            errors: {},
        }
    },

    mounted() {

        var urlParams = new URLSearchParams(window.location.search);

        if ( urlParams.has('login') ) {

            this.$root.$refs['pages'].$refs['right-page'].activePage = 'Login';

        }

    },

    methods: {

        loadComponent() {

            this.submittingFlag = false;

            this.errors = {};

            const urlParams = new URLSearchParams(window.location.search);

            const urlCompany = urlParams.get('company');
            const urlLogin = urlParams.get('login');

            this.record.company = urlCompany ? urlCompany : getCookie('company');
            this.record.login = urlLogin ? urlLogin : getCookie('login');

            
                
            // ************************** FOR TESTING ***************************
            //if ( appEnvironment === 'local') {

                this.record.company = 'ACME01';
                this.record.login = 'RJ';
                this.record.password = 'lsw123';

                $('input[name="company"]').val(this.record.company)
                $('input[name="login"]').val(this.record.login)
                $('input[name="password"]').val(this.record.password)
            //}
            // ******************************************************************

            setTimeout(() => {

                if (this.record.company && !this.record.login) {

                    $('input[name="login"]').focus();

                } else if (!this.record.company && this.record.login) {

                    $('input[name="company"]').focus();

                } else if (this.record.company && this.record.login) {

                    $('input[name="password"]').focus();

                } else {

                    $('input[name="company"]').focus();

                }

            }, 100);


        },

        okClicked() {

            this.submittingFlag = true;

            this.errors = {}; // Clear previous errors

            root.$snotify.simple('Logging in ' + this.record.login, 'Company: ' + this.record.company, { timeout: 0, icon: 'img/cogs.gif' });

            axios.post('/login', this.record)

            .finally(() => { this.submittingFlag = false; })

            .then(response => {

                //console.log('response',response);

                if (response.data.errors) {

                    root.$snotify.clear();

                    if (response.data.errors) { 
                        showError( 'Error', response.data.errors);
                    } 

                } else {

                    this.errors = {};

                    document.cookie = "company=" + this.record.company;
                    document.cookie = "login=" + this.record.login;

                    window.location = '/home';

                }

            });

        },

        hide() {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].closePage(this.activePage);

        },

    },

}

</script>
