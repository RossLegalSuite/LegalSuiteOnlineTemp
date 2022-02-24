<template>
    <div class="card h-100 border-0">
        <div class="card-header filenotes-bg">
            <div class="d-flex justify-content-between">
                <h3><i class="fa fa-edit mr-2"></i>File Notes</h3>
                <page-close-button @closeClicked="closeLeftPage(pageName)"/>
            </div>
        </div>

        <div id="file-note-left-body" class="card-body overflow-auto pb-0 pt-3 px-3">

            <file-note-table
                :lazy-load-flag="true"
                :tagging="false"
                form-ref="file-note-form" 
                ref="file-notes-table" 
                tableId="file-notes-table"
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
        FileNoteTable: () => import("./FileNoteTable"),
    },

    data() {
        return {
            pageName: "FileNotes",
            selectedRows: [],
            selectedAllFlag: false,
            tableMounted: false,
            selectedMatter: {},
        };
    },

    computed: {
        ...mapGetters(['leftTabs', 'activeLeftTabs', 'currentMatter']),
    },

    watch: {

        tableMounted() { this.initializeTable(); },

    },

    activated() {

        if ( $('#file-notes-table').length ) {

            let scrollTop = $('#file-notes-table' + '_wrapper .dataTables_scrollBody').offset().top;
            let tableTop = $('#file-notes-table').offset().top;

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

            // Used to lazy load the Form (and all its sub components) on the right
            this.table.loadDataTable(() =>{
                this.$root.fileNoteLeftTableLoaded = true;
            });

        },

        newRecordButtonClicked() {

            let thisForm = root.$refs['pages'].$refs["right-page"].$refs['file-note-form'];

            thisForm.insertClicked();

        },


    },
}
</script>