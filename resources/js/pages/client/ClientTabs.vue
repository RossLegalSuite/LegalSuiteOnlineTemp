<template>

    <right-hand-tabs ref="right-hand-tabs" :tabs="tabs"/>

</template>

<script>

export default {

    data() {

        return {
            tabs: [
                {
                    pageName: "Login",
                    title: "Login",
                    iconClass: 'fa-lock',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "Help",
                    title: "Help",
                    iconClass: 'fa-info-circle',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "About",
                    title: "About",
                    iconClass: 'fa-language',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "Terms",
                    title: "Terms & Conditions",
                    iconClass: 'fa-pencil-square-o',
                    visible: false,
                    active: false,
                },
            ],
        }
    },

    mounted() {

        var urlParams = new URLSearchParams(window.location.search), pageName, foundTab;

        if ( urlParams.has('login') ) {

            pageName = 'Login';
            foundTab = this.tabs.filter(tab => tab.pageName == pageName);

            if ( foundTab.length === 1 ) {
                foundTab[0].active = true;
                foundTab[0].visible = true;
            } else {
                console.log('closePage - Could not find the ' + pageName + ' Tab',foundTab);
            }


        } else if ( urlParams.has('register') ) {

            // this.tabs[1].active = this.tabs[1].visible = true;
            pageName = 'Register';
            foundTab = this.tabs.filter(tab => tab.pageName == pageName);

            if ( foundTab.length === 1 ) {
                foundTab[0].active = true;
                foundTab[0].visible = true;
            } else {
                console.log('closePage - Could not find the ' + pageName + ' Tab',foundTab);
            }

        }
    },


}  
</script>