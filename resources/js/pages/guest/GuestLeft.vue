<template>

    <div class="filofax-page p-2">

        <div class="text-center mt-3" style="position: absolute; bottom: 20px; width: 100%;">
            <img src="/img/legalsuite-logo.gif" alt="Logo" class="" style="width: 30%;">
        </div>

        <div class="d-flex">

            <div id="login-icon" class="program-icon" @click="showPage('Login')"
            >
                <img src="/icons/power.gif">
                <div class="program-icon-text">Login</div>

                <div
                id="login-tooltip" 
                data-container="body" 
                data-toggle="manual" 
                data-placement="bottom" 
                data-content="Click on the Login button to login"
                ></div>

            </div>

            <div class="program-icon" @click="showPage('Register')">
                <img src="/icons/profile-id.gif">
                <div class="program-icon-text">Register</div>
            </div>

        </div>

        <!-- <div class="d-flex">

            <div class="program-icon" @click="showPage('Terms')">
                <img src="/icons/terms.gif">
                <div class="program-icon-text">Terms & Conditions</div>
            </div>


            <div class="program-icon" @click="showPage('Help')">
                <img src="/icons/help-chalkboard.gif">
                <div class="program-icon-text">Help</div>
            </div>

            <div class="program-icon" @click="showPage('About')">
                <img src="/icons/photo-album.gif">
                <div class="program-icon-text">About</div>
            </div>

        </div>Z -->


    </div>
</template>

<script>

export default {

    mounted () {

        // Show the Login Page
        var checkExist = setInterval(() => {

            if (this.$root.$refs['pages'].$refs['right-page']) {

                this.showPage('Login');

                clearInterval(checkExist);

            }
            
        }, 100); // check every 100ms

    },

    methods: {

        showPage( pageName) {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].showPage( pageName );

        },

    }
}

</script>

