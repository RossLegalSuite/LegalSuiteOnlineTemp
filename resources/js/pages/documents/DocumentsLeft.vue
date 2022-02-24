<template>
    <div class="card h-100 border-0">
        <div class="card-header documents-bg">
            <div class="d-flex justify-content-between">
                <h3><i class="fa fa-cog mr-2"></i>Generated Documents</h3>
                <page-close-button @closeClicked="closeLeftPage(pageName)"/>
            </div>
        </div>

        <div class="card-body overflow-auto pb-1 pt-3 px-3">

            <documents-table
                :lazy-load-flag="true"
                :tagging="true"
                form-ref="documents-right-documents-form" 
                ref="documents-table" 
                table-id="documents-table"
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
        DocumentsTable: () => import("./DocumentsTable"),
    },

    data() {
        return {
            rightPage: null,
            form: null,
            pageName: "Documents",
            selectedRows: [],
            selectedAllFlag: false,
            tableMounted: false,
            table: null,
        };
    },

    computed: {
        ...mapGetters(['leftTabs', 'activeLeftTabs']),
    },

    watch: {

        tableMounted() { 

            this.loadTable(); 

        },

    },


    mounted() {

        let thisTab = this.leftTabs.filter(tab => tab.pageName === this.pageName);

        if (thisTab.length) this.displayLeftTab(thisTab[0]);

        root.documentsLeftComponent = this;

    },    

    methods: {

        ...mapMutations(['displayLeftTab','hideLeftTab']),

        reset() {

            // Clear the table
            $('#' + this.table.tableId).empty();

            // Close the pages on the right if opened previously by the user
            root.documentsRightHandTabs.$refs['right-hand-tabs'].clearPages();

            // Clear the displayed PDF as well
            if ( root.documentsRightForm ) root.documentsRightForm.documentPath = null;

            // Clear any tagged records
            clearTagged( this );


        },

        loadTable() {

            this.table.whereRaw = 'time = ' + root.generatedDocumentsTime;
            this.table.viewTableFlag = true;
            this.table.actionColumnWidth = 12;
            this.table.source = root.generatedDocumentsSource;

            setTimeout( this.table.loadDataTable( () => {

                // Show the first document on the right
                let id = this.table.table.row(0).data().recordid;

                $('#' + this.table.tableId + ' tbody tr#' + id).addClass('highlighted');

                editRecord('documents-right-documents-form', id);


            }));

        },

    },
}
</script>