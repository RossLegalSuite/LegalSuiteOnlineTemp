<template>

<div id="guest-right">

    <guest-login v-show="activePage === 'Login'" ref="guest-login"/>

    <guest-register v-show="activePage === 'Register'" ref="guest-register"/>

    <!-- <guest-about v-show="activePage === 'About'" ref="guest-about"/>
    <guest-help v-show="activePage === 'Help'" ref="guest-help"/>
    <guest-terms v-show="activePage === 'Terms'" ref="guest-terms"/> -->


</div>
</template>

<script>
export default {
    components: {
        GuestLogin: () => import("./GuestLogin"),
        GuestRegister: () => import("./GuestRegister"),
        //GuestHelp: () => import("./GuestHelp"),
        //GuestAbout: () => import("./GuestAbout"),
        //GuestTerms: () => import("./GuestTerms"),
    },
    data() {
        return {
            activePage: 'null',
        }
    },
    watch: {
        
        activePage(newValue) {
            $('#guest-right .popover-icon').popover();
            if ( newValue === "Login") {
                this.$refs['guest-login'].loadComponent();
            } else if ( newValue === "Register") {
                
                this.$refs['guest-register'].loadComponent();
            }
            
        }
    },
}  
</script>