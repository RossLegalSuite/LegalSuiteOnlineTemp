<template>
    <div class="card h-100 border-0">
        <div class="card-header fee-codes-bg">
            <div class="d-flex justify-content-between">
                <h3><i class="fa fa-server mr-2"></i>Fee Codes</h3>
                <page-close-button @closeClicked="closeLeftPage(pageName)"/>
            </div>
        </div>

        <div class="card-body overflow-auto pb-1 pt-2 px-3">

            <fee-code-table 
                formRef="fee-code-form" 
                ref="fee-codes-table" 
                tableId="fee-codes-table"
                setActionColumnWidth="10"
            />

        </div>
    </div>
</template>     

<script>

import { mapGetters } from 'vuex';
import { mapMutations } from 'vuex';
import leftTemplate from "../left-template";

export default {

    extends: leftTemplate,

    components: {
        FeeCodeTable: () => import("./FeeCodeTable"),
    },

    data() {
        return {
            rightPage: null,
            form: null,
            pageName: "Fee Codes",
        };
    },

    computed: {
        ...mapGetters(['leftTabs','activeLeftTabs']),
    },



    mounted() {

        let thisTab = this.leftTabs.filter(tab => tab.pageName === this.pageName);

        if (thisTab.length)  this.displayLeftTab(thisTab[0]);

        if ( !this.$root.feeSheets.length) this.$root.getFeeSheets();

    },    

    methods: {

        ...mapMutations(['displayLeftTab','hideLeftTab']),
        
        newRecordButtonClicked() {

            this.rightPage = root.$refs['pages'].$refs["right-page"];
            
            this.form = this.rightPage.$refs['fee-code-form'];

            this.form.insertClicked();

            this.loadPage('Form');

        },


    },
}
</script>