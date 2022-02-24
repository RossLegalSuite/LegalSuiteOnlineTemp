<template>
<span>


    <b-dropdown v-if="parent.selectedRows && parent.selectedRows.length" 
    :id="this.tableId + '-actions-dropdown-menu'" size="sm" right variant="secondary" class="mr-2" :title="'Perform tasks on the tagged ' + $parent.plural">
        <template v-slot:button-content>
            <i class="fa fa-check-square-o fa-lg mr-2 pt-1" ></i>Tagged
            <span class="badge badge-danger mx-1">{{parent.selectedRows.length}}</span>
        </template>

        <b-dropdown-item-button 
            variant="secondary" 
            :title="'Print the tagged ' + $parent.plural" 
            @click="printDocuments">
            <i class="fa fa-print fa-lg mr-2"></i>Print
        </b-dropdown-item-button>
        
        <b-dropdown-divider/>


        <b-dropdown-item-button
            v-show="!table.displayingTaggedRecordsFlag" 
            variant="secondary" 
            :title="'Display the tagged ' + table.plural"
            @click="displayTaggedRecords">
            <i class="fa fa-tags fa-lg mr-2"></i>Show Tagged
        </b-dropdown-item-button>

        <b-dropdown-item-button
            v-show="table.displayingTaggedRecordsFlag" 
            variant="secondary" 
            :title="'Display all the ' + table.plural"
            @click="displayTaggedAndUntaggedRecords">
            <i class="fa fa-database fa-lg mr-2"></i>Show All
        </b-dropdown-item-button>

        <b-dropdown-divider/>

        <b-dropdown-item-button 
            variant="secondary" 
            :title="'Untag the tagged ' + table.plural"
            @click="unTagAllRecords">
            <i class="fa fa-times-circle fa-lg mr-2"></i>Untag All
        </b-dropdown-item-button>



    </b-dropdown>

</span>
</template>

<script>

export default {

    props: {
        tableId: String,
    },

    created() {

        this.table = this.$parent;
        this.parent = this.table.$parent;
        this.table.actionsDropDown = this;

    },    

    methods: {

        printDocuments() {

            this.pdfFiles = [];

            this.parent.selectedRows.forEach(id => {

                // console.log("id",id);
                // console.log("this.table.table",this.table.table);
                // console.log("this.table.table.row( '#' + id )",this.table.table.row( '#' + id ));

                let data = this.table.table.row( '#' + id ).data();

                //console.log("data",data);

                this.pdfFiles.push({
                    handle: data.recordid,
                    url: data.url,
                    fileName: data.savedname,
                    folder: 'documents',
                    path: data.emailfolder,
                });

            });

            console.log("pdfFiles",this.pdfFiles);

            this.processDocuments();

        },

        processDocuments(action = 'Print') {

            root.$snotify.simple('Preparing documents...', action + ' Documents', { timeout: 0, icon: 'img/cogs.gif' });

            axios.post('/pdf/combine', {
                pdfFiles: JSON.stringify(this.pdfFiles),
                folder: 'documents',
                saveAs: 'Documents ' + moment().format('YYYY-MM-DD-HH-mm-ss') + '.pdf',
            })

            .finally(() => { root.$snotify.clear() })

            .then(( response ) => {

                if ( response.data.errors ) {

                    showError('Error combining Documents',response.data.errors);

                } else {

                    let pdfDocument = {
                        description: 'Documents',
                        fileName: getFileName(response.data.url),
                        url: response.data.url,
                        path: response.data.path,
                    };

                    this.$root.previewPdf.document = pdfDocument;

                    this.$root.previewPdf.title = 'Documents';

                    if ( action === 'Print') {

                        this.$root.previewPdf.printDocument();

                    } else if ( action === 'Email') {

                        this.$root.previewPdf.emailDocument(null, null);

                    } else if ( action === 'Download') {

                        this.$root.previewPdf.downloadDocument();
                    }

                }

            });


        },


        displayTaggedRecords() {

            this.table.displayingTaggedRecordsFlag = true;

            this.table.savedWhereRaw = this.table.whereRaw;

            this.table.whereRaw = this.table.tableName + ".recordid in (select taggedId from LolTagged where [LolTagged].[tableName] = '" + this.table.tableName + "' and [LolTagged].[employeeId] = " + root.loggedInEmployeeId + ")";

            this.table.table.ajax.reload();

        },

        displayTaggedAndUntaggedRecords() {

            this.table.displayingTaggedRecordsFlag = false;

            this.table.whereRaw = this.table.savedWhereRaw;

            this.table.table.ajax.reload();

        },

        unTagAllRecords() {

            this.table.toggleTaggedRows(this.parent);

        },


    }
}  
</script>
