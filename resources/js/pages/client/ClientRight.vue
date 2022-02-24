<template>

<div id="client-right">

    <!-- <client-login v-show="activePage === 'Login'" ref="client-login"/> -->
</div>

</template>

<script>
export default {
    components: {
        //ClientLogin: () => import("./ClientLogin"),
    },
    data() {
        return {
            activePage: 'null',
        }
    },
    watch: {
        
        activePage(newValue) {
            $('#client-right .popover-icon').popover();
            if ( newValue === "Login") {
                this.$refs['client-login'].loadComponent();
            }
            
        }
    },
}  
</script>