<template>

    <div class="card h-100 border-0">
        <div class="card-header settings-bg">
            <div class="d-flex justify-content-between">
                <h3>Settings</h3>
                <page-close-button @closeClicked="closeLeftPage(pageName)"/>
            </div>
        </div>

        <div class="card-body overflow-auto p-1">


            <div class="d-flex">

                <div class="program-icon" @click="showPage('Company')">
                    <img src="/icons/toolbox.gif">
                    <div class="program-icon-text">Settings</div>
                </div>

                <div class="program-icon" @click="showPage('Templates')">
                    <img src="/icons/blueprint.gif">
                    <div class="program-icon-text">Templates</div>
                </div>

                <div class="program-icon" @click="showPage('Components')">
                    <img src="/icons/envelop.gif">
                    <div class="program-icon-text">Components</div>
                </div>

            </div>

        </div>
    </div>

</template>

<script>

import leftTemplate from "../left-template";
import { mapGetters } from 'vuex';
import { mapMutations } from 'vuex';

export default {

    extends: leftTemplate,

    computed: {
        ...mapGetters(['leftTabs','activeLeftTabs']),
    },

    data() {
        return {
            pageName: 'Settings',
        }
    },

    methods: {

        ...mapMutations(['displayLeftTab','hideLeftTab']),  

        showPage( pageName) {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].showPage( pageName );

        },

        // loadSystemPages() {
            
        //     this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].showPage( 'System Components' );
        //     this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].showPage( 'System Templates' );
            

        // },

        loadLeftTab( name) {

            let thisTab = this.leftTabs.filter(tab => tab.pageName == name);

            if (thisTab.length) {

                this.displayLeftTab(thisTab[0]);
    
                this.$router.push({ name: thisTab[0].routeName });


            }
        },

    }

}
</script> 

