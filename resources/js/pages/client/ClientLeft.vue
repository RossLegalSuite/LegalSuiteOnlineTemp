<template>

    <!-- <div class="filofax-page p-2">

        <div>
            Firm Code: {{$route.params.firmcode}}
        </div>

    </div> -->

<div id="client-login-form" class="card h-100 border-0">
    
    <div v-show="gotApiKeyFlag" class="card-header">
        <div class="d-flex justify-content-between">
            <h3><i class="fa fa-building mr-2"></i>{{companyName}}</h3>
        </div>
    </div>

    <div class="card-body overflow-auto p-3">
        
        <div v-show="errorFlag" class="row mt-5">

            <div class="col-md-6 offset-md-3">

                <fieldset><legend style="background-color: indianred">Error</legend>

                    {{errorMessage}}

                </fieldset>

            </div>
        </div>

        <div v-if="errors.database" class="row mb-3">

            <div class="col-lg-12">

                <fieldset>
                    <legend>Database Error</legend>
                        <div v-if="errors.database" v-html="errors.database[0]" class="invalid-feedback"></div>
                </fieldset>
            </div>

        </div>

        <fieldset v-show="gotApiKeyFlag">
            <legend>Login</legend>

            <div class="form-group row">

                <text-input 
                    _class="col-md-4" 
                    ref='text-input-login'
                    popOverContainer="#client-login-form"
                    pop-over="Dynamic"
                    v-model="record.login" 
                    name="login" 
                    label="Code"
                    :error="errors.login"/>

            </div>                                        

            <div class="form-group row">

                <text-input 
                    _class="col-md-4" 
                    ref='text-input-password'
                    popOverContainer="#client-login-form"
                    pop-over="Dynamic"
                    v-model="record.password" 
                    type="password" 
                    name="password" 
                    label="Password"
                    :error="errors.password"/>

            </div>                                        

        </fieldset>

    </div>

    <div class="modal-footer justify-content-between">
        <div/>
        <div v-show="!submittingFlag && gotApiKeyFlag">
            <button class="btn btn-success form-button mr-2" type="button" @click="okClicked" title="Continue"><i class="fa fa-check-circle fa-lg mr-2"></i>Login</button>
        </div>
    </div>


</div>


</template>

<script>

export default {

    mounted () {

        //root.$snotify.simple('Connecting to ' + this.$route.params.firmcode.capitalize(), 'Please wait...', { timeout: 0, icon: 'img/cogs.gif' });

        axios.post('/utils/getapikey', {
            company: this.$route.params.firmcode,
        })
        
        .then(response => {

            console.log("response.data",response.data);

            //root.$snotify.clear();

            if (response.data.errors) {

                this.errorFlag = true;
                this.errorMessage = response.data.errors;

            } else {

                this.companyName = response.data.name;
                this.errorFlag = false;
                this.errorMessage = '';
                this.gotApiKeyFlag = true;

                this.$refs['text-input-login'].setPopOver = '<h4>Code</h4><p>Enter the code provided to you by ' + this.companyName + '.</p>';
                this.$refs['text-input-password'].setPopOver = '<h4>Password</h4><p>Enter the password provided to you by ' + this.companyName + '.</p>';

                $('#client-login-form .popover-icon').popover();


            }

        }).catch(error => { 
            this.errorFlag = true;
            this.errorMessage = error;

        });

        // Show the Login Page
        // var checkExist = setInterval(() => {

        //     if (this.$root.$refs['pages'].$refs['right-page']) {

        //         //console.log("typeof this.$route",typeof this.$route);

        //         this.showPage('Login');

        //         clearInterval(checkExist);

        //     }
            
        // }, 100); // check every 100ms

    },


    data() {
        return {

            submittingFlag: false,
            record: {},
            errors: {},

            companyName: '',

            errorFlag: false,
            errorMessage: '',
            gotApiKeyFlag: false,
        }
    },

    methods: {

        okClicked() {

            console.log("OkClicked"); return;

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


        showPage( pageName) {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].showPage( pageName );

        },

    }
}

</script>

