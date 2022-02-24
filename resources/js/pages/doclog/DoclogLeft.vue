<template>
    <div class="card h-100 border-0">
        <div class="card-header doclog-bg">
            <div class="d-flex justify-content-between">
                <h3><i class="fa fa-envelope-o mr-2"></i>Document Log</h3>
                <page-close-button @closeClicked="closeLeftPage(pageName)"/>
            </div>
        </div>

        <div class="card-body overflow-auto pb-1 pt-3 px-3">

            <doclog-table
                ref="doclog-table" 
                :lazy-load-flag="true"
                :tagging="false"
                form-ref="doclog-form" 
                table-id="doclog-table"
                parentType="General"
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
        DoclogTable: () => import("./DoclogTable"),
    },

    data() {
        return {
            rightPage: null,
            form: null,
            pageName: "DocLog",
            selectedRows: [],
            selectedAllFlag: false,
            tableMounted: false,
        };
    },

    computed: {
        ...mapGetters(['leftTabs', 'activeLeftTabs']),
    },

    watch: {

        tableMounted() { this.initializeTable(); },

    },

    activated() {

        if ( $('#doclog-table').length ) {

            let scrollTop = $('#doclog-table' + '_wrapper .dataTables_scrollBody').offset().top;
            let tableTop = $('#doclog-table').offset().top;

            if ( tableTop > scrollTop ) this.table.table.ajax.reload();

        }
    },

    mounted() {

        let thisTab = this.leftTabs.filter(tab => tab.pageName === this.pageName);

        if (thisTab.length)  this.displayLeftTab(thisTab[0]);

    },    

    methods: {

        ...mapMutations(['displayLeftTab','hideLeftTab']),

        initializeTable() {

            // Order by Date, Time descending
            this.table.initialOrder = [[1, "desc"],[2, "desc"]];

            this.table.tableOptions = { tableBottom: 80 }; 

            this.table.loadDataTable(() =>{
                this.$root.doclogLeftTableLoaded = true;
            });

        },

        newRecordButtonClicked() {

            let thisForm = root.$refs['pages'].$refs["right-page"].$refs['doclog-form'];

            thisForm.currentParentType = thisForm.record.parentType || 'Matter';

            thisForm.insertClicked();

        },

    },
}
</script>