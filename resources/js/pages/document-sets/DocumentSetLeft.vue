<template>
    <div class="card h-100 border-0">
        <div class="card-header document-sets-bg">
            <div class="d-flex justify-content-between">
                <h3><i class="fa fa-clone mr-2"></i>Document Sets</h3>
                <page-close-button @closeClicked="closeLeftPage(pageName)"/>
            </div>
        </div>

        <div class="card-body overflow-auto pb-1 pt-3 px-3">

            <document-set-table 
                form-ref="document-set-form" 
                ref="document-sets-table" 
                table-id="document-sets-table"
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
        DocumentSetTable: () => import("./DocumentSetTable"),
    },

    data() {
        return {
            rightPage: null,
            form: null,
            pageName: "Document Sets",
        };
    },

    computed: {
        ...mapGetters(['leftTabs','activeLeftTabs']),
    },



    mounted() {

        let thisTab = this.leftTabs.filter(tab => tab.pageName === this.pageName);

        if (thisTab.length)  this.displayLeftTab(thisTab[0]);

    },    

    methods: {

        ...mapMutations(['displayLeftTab','hideLeftTab']),
        
        newRecordButtonClicked() {

            this.rightPage = root.$refs['pages'].$refs["right-page"];
            
            this.form = this.rightPage.$refs['document-set-form'];

            this.form.insertClicked();

            this.loadPage('Form');

        },


    },
}
</script>