<template>

    <div class="filofax-page p-2">

        <div class="d-flex">

            <div class="program-icon" @click="loadTab('Matters')">
                <img src="/icons/portfolio.gif">
                <div class="program-icon-text">Matters</div>
            </div>

            <div class="program-icon" @click="loadTab('Parties')">
                <img src="/icons/user-group.gif">
                <div class="program-icon-text">Address Book</div>
            </div>

            <div class="program-icon" @click="loadTab('MatterParties')">
                <img src="/icons/matter-parties.png">
                <div class="program-icon-text">Parties</div>
            </div>

        </div>

        <div class="d-flex">

            <div class="program-icon" @click="loadTab('FeeNotes')">
                <img src="/icons/finance.gif">
                <div class="program-icon-text">Fee Notes</div>
            </div>


            <div class="program-icon" @click="loadTab('FileNotes')">
                <img src="/icons/notepad.gif">
                <div class="program-icon-text">File Notes</div>
            </div>

            <div class="program-icon" @click="loadTab('Reminders')">
                <img src="/icons/bulletin-board.gif">
                <div class="program-icon-text">Reminders</div>
            </div>

            <div class="program-icon" @click="loadTab('DocLog')">
                <img src="/icons/bookmark.gif">
                <div class="program-icon-text">Document Log</div>
            </div>

        </div>

        <div class="d-none">

            <div class="program-icon" @click="loadTab('Employees')">
                <img src="/icons/profile-id.gif">
                <div class="program-icon-text">Employees</div>
            </div>

            <div class="program-icon" @click="loadEmail">
                <img src="/icons/mail2.gif">
                <div class="program-icon-text">Email</div>
            </div>

            <div class="program-icon" @click="loadTab('Reports')">
                <img src="/icons/chart-graph.gif">
                <div class="program-icon-text">Reports</div>
            </div>

        </div>


        <div class="d-flex">

            <div class="program-icon" @click="loadTab('Settings')">
                <img src="/icons/under-construction.gif">
                <div class="program-icon-text">Settings</div>
            </div>

            <!-- <div class="program-icon" @click="loadTab('Help')">
                <img src="/icons/help-chalkboard.gif">
                <div class="program-icon-text">Help</div>
            </div> -->

            <!-- <div class="program-icon" @click="runTest">
                <img src="/icons/dashboard.gif">
                <div class="program-icon-text">Test</div>
            </div>  -->


            <div class="program-icon" @click="logout">
                <img src="/icons/power.gif">
                <div class="program-icon-text">Logout</div>
            </div>

        </div>
    

        <!-- <div class="text-center" style="position:absolute;bottom:10px;">

            <img class="mr-5" src="/img/legalsuite-logo.gif" alt="logo" style="width:20%;">
            <img src="/img/logo.svg" alt="logo" style="width:20%;"> 

        </div>-->

        <!-- <img class="text-center" src="/img/legalsuite-logo.gif" alt="logo" style="width:20%;position:absolute; bottom: 10px; left:40%"> -->
        <!-- <img class="text-center" src="/img/logo.svg" alt="logo" style="width:20%;position:absolute; bottom: 10px; left:40%"> -->

    </div>
</template>

<script>

import { mapGetters } from 'vuex';
import { mapMutations } from 'vuex';
export default {

    computed: {
        ...mapGetters(['leftTabs']),
    },

    data() {
        return {
            componentName: null,
            emailLoaded: false,
        }
    },

    methods: {

        ...mapMutations([
            'displayLeftTab',
        ]),     

        runTest() {

            console.log("Run Tests");

            // for (let i = 0; i < 6; i++) {

            //     console.log("runTest i",i);

                    // Put some Ajax call here

            // }

        },

        async loadEmail() {

            if ( this.emailLoaded ) {

                this.loadTab('Email');

            } else {
                
                await this.$root.emailModal.checkSmtpDetails(root.smtpDetails)

                .then( ( smtpDetails ) => {

                    this.loadTab('Email');

                    this.emailLoaded = true;

                    root.smtpDetails = smtpDetails;

                    // In case the user clicks too quickly on the Email icon
                    if ( typeof this.$root.emailLeftPage === 'undefined') {

                        root.$snotify.simple('Please wait...', 'Initializing', { timeout: 2000, icon: 'img/cogs.gif' });

                        setTimeout(() => {
                            
                            this.$root.emailLeftPage.initializePage();

                        }, 2000);

                    } else {

                        this.$root.emailLeftPage.initializePage();
                    }

                }).catch( () => {
                    console.log('Email settings incomplete');
                });


            }
        },

        loadTab( name ) {

            let thisTab = this.leftTabs.filter(tab => tab.pageName == name);

            if (thisTab.length) {

                this.displayLeftTab(thisTab[0]);
    
                this.$router.push({ name: thisTab[0].routeName });

            }
        },

        logout() {

            axios.post('/logout').then(response => {

                window.location = response.data;

            });

        }
    }
}

</script>

