<template>

<div v-show="showPage" class="card h-100 border-0">
    
    <div class="card-header">
        <div class="d-flex justify-content-between">

            <div class="page-title">
                <h3><i class="fa mr-2 fa-file-pdf-o"></i>
                    <span v-html="pageTitle"></span>
                </h3>
            </div>

            <page-close-button @closeClicked="hide"/>

        </div>
    </div>

    <div class="card-body overflow-auto p-3">

            <document-log-table 
                ref="document-log-table" 
                formRef="right-page"
                :tagging="true"
                :table-id="_uid + '-document-log-table'"
                :lazy-load-flag="true"
            />

    </div>

</div>

</template>

<script>

export default {

    components: {
        DocumentLogTable: () => import("./DocumentLogTable"),
    },


    data() {
        return {
            tableHasData: false,
            showPage: false,
            source: null,
            pageTitle: 'Assembled Documents',
            fileName: null,
            record: {},
            selectedRows: [],
            selectedAllFlag: false,
            selectedAllRows: false,
        };
    },

    methods: {

        editClicked(id) {

            let data = this.table.table.row( '#' + id ).data();


            this.$root.previewPdf.title = data.description;

            this.$root.previewPdf.document = data;
            console.log('this.$root.previewPdf.document',this.$root.previewPdf.document);

            this.$root.previewPdf.documentPath = data.url; //Being watched: To load the iFrame
            console.log('this.$root.previewPdf.documentPath',this.$root.previewPdf.documentPath);

            this.$root.previewPdf.show();

        },


        emptyTable() {

            let assembleLeft = root.$refs['pages'].$refs["left-page"];

            assembleLeft.emptyDocumentLogTable();

        },

        loadTable(batchId) {

            this.selectedAllRows = false;

            this.table.where = { column: 'batchId', value: batchId };

            this.table.actionColumnWidth = 10;

            this.table.tableOptions = {

                drawCallback: (tableId, api) => {
                    
                    // Select all rows (so use can perform Actions on them without having to Tag them manually)
                    if ( !this.selectedAllRows ) {
                        
                        this.selectedAllRows = true;

                        this.table.toggleTaggedRows(this);
                    }

                    this.tableHasData = api.data().any();

                }
            }

            this.table.viewTableFlag = true;
                
            setTimeout( this.table.loadDataTable );            

        },

        hide() { 

            this.showPage = false;

        },

    },

}  
</script>

