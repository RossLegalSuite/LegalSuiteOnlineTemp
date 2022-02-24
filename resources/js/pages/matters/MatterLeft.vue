<template>
    <div class="card h-100 border-0">
        <div class="card-header matters-bg">
            <div class="d-flex justify-content-between">
                <h3><i class="fa fa-briefcase mr-2"></i>Matters</h3>
                <page-close-button @closeClicked="closeLeftPage(pageName)"/>
            </div>
        </div>

        <div class="card-body overflow-auto pb-1 pt-3 px-3">

            <matter-table 
                ref="matters-table" 
                :lazyLoadFlag="true"
                :tagging="true"
                form-ref="matter-right-matter-form" 
                tableId="matters-table"
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
        MatterTable: () => import("./MatterTable"),
    },

    data() {
        return {
            tableMounted: false,
            form: null,
            pageName: "Matters",
            selectedRows: [],
            selectedAllFlag: false,
            generateDocumentsFlag: true,
            generateDocumentsSource: 'Matter',
            generateDocumentsPlural: 'Matters',
        };
    },

    computed: {
        ...mapGetters(['leftTabs', 'currentMatter','activeLeftTabs']),
    },

    watch: {

        tableMounted() { 
            this.initializeTable(); 
        },

    },

    activated() {

        // Fixing bug between Vue keep-alive functionality and DataTables
        // The activated event in Vue means keep-alive has re-activated the component
        // If the user has scrolled the table - DataTables scroller sets the absolute position of the table
        // But if the user goes to another Tab and then back to this Tab, the table looks blank because 
        // the Scroller's absolute position is still there (and the table is now out of the view port)
        // The simplest solution is to compare the top positions (to see if the user has scrolled)
        // and, if so, reload the table (which sorts everything out)
        // This code needs to be on any Left Page that has a table

        if ( $('#matters-table').length ) {

            let scrollTop = $('#matters-table' + '_wrapper .dataTables_scrollBody').offset().top;
            let tableTop = $('#matters-table').offset().top;

            if ( tableTop > scrollTop ) this.table.table.ajax.reload();

        }
    },

    mounted() {

        let thisTab = this.leftTabs.filter(tab => tab.pageName === this.pageName);

        if (thisTab.length) this.displayLeftTab(thisTab[0]);

    },

    methods: {

        ...mapMutations(['displayLeftTab','hideLeftTab']),


        initializeTable() {

            this.table.tableOptions = { tableBottom: 80 }; 

            this.table.loadDataTable(() =>{
                
                // Used to lazy load the Form (and all its sub components) on the right
                //https://vueschool.io/articles/vuejs-tutorials/lazy-loading-individual-vue-components-and-prefetching/
                root.matterLeftTableLoaded = true;

                // root.matterScrollBodyPosition = $('#' + this.table.tableId + '_wrapper .dataTables_scrollBody').offset();

                // root.matterTablePosition = $('#' + this.table.tableId).offset();

                // console.log("root.matterScrollBodyPosition",root.matterScrollBodyPosition);
                // console.log("root.matterTablePosition",root.matterTablePosition);

                //$('#' + this.table.tableId).css(root.matterTablePosition);

            });

        },


        newRecordButtonClicked() {

            this.form = root.$refs['pages'].$refs["right-page"].$refs['matter-right-matter-form'];

            if ( !this.form.permission('Insert') ) return;

            if ( root.currentEmployee.defaultclientid ) {

                this.form.partySelected({ recordid: root.currentEmployee.defaultclientid});

            } else {

                this.form.$refs[this.form.uniqueId + '-select-matter-client'].selectParty( this.form );
                
            }

        },

        /*deleteTaggedRecords() {

            this.tryDeleteTaggedRecords('matters');

        },*/

    },
}
</script> 