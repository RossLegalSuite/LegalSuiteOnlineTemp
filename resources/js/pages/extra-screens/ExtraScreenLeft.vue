<template>
    <div class="card h-100 border-0">
        <div class="card-header components-bg">
            <div class="d-flex justify-content-between">
                <h3><i class="fa fa-server mr-2"></i>Extra Screens</h3>
                <page-close-button @closeClicked="closeLeftPage(pageName)"/>
            </div>
        </div>

        <div class="card-body overflow-auto p-3">

            <extra-screen-table 
                form-ref="extra-screen-form" 
                ref="extra-screens-table" 
                table-id="extra-screens-table"
            />

        </div>
    </div>
</template>     

<script>

import { mapGetters } from 'vuex';
import { mapMutations } from 'vuex';
import leftComponent from "../left-template";


export default {

    extends: leftComponent,

    components: {
        ExtraScreenTable: () => import("./ExtraScreenTable"),
    },

    data() {
        return {
            rightPage: null,
            form: null,
            pageName: "Extra Screens",
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

            this.form = root.$refs['pages'].$refs["right-page"].$refs['extra-screen-form'];

            if ( !this.form.permission('Extra Screens','insert') ) return;

            this.form.insertClicked();

            this.loadPage('Form');


        },

    },
}
</script>