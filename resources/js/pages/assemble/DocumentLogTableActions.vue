<template>
<span>

    <b-dropdown v-if="$parent.$parent.selectedRows && $parent.$parent.selectedRows.length" :id="tableId + '-actions-dropdown-menu'" size="sm" right variant="danger" class="mr-2" :title="$parent.singular + ' functions'">

        <template v-slot:button-content>
            <i class="fa fa-cog mr-2" ></i>Tagged
        </template>

        <b-dropdown-item-button variant="danger" :title="'Print the tagged ' + $parent.plural" @click="combineDocuments('Print')"><i class="fa fa-print mr-2"></i>Print Documents</b-dropdown-item-button>
        <b-dropdown-item-button variant="danger" :title="'Download the tagged ' + $parent.plural" @click="combineDocuments('Download')"><i class="fa fa-download mr-2"></i>Download Documents</b-dropdown-item-button>
        <b-dropdown-item-button variant="danger" :title="'Email the tagged ' + $parent.plural" @click="combineDocuments('Email')"><i class="fa fa-envelope-o mr-2"></i>Email Documents</b-dropdown-item-button>
        <b-dropdown-divider v-if="$parent.$parent.tableHasData"/>
        <b-dropdown-item-button v-if="$parent.$parent.tableHasData" variant="danger" title="Clear the list of Assembled Documents (the documents themselves will not be deleted)" @click="$parent.$parent.emptyTable"><i class="fa fa-window-close-o fa-lg mr-2"></i>Clear Results</b-dropdown-item-button>
    </b-dropdown>


</span>
</template>

<script>

export default {

    props: {
        tableId: String,
    },

    mounted() {

        this.$parent.actionsDropDown = this;

    },    

    methods: {

        combineDocuments( action ) {

            root.$snotify.simple('Preparing documents...', action + ' Documents', { timeout: 0, icon: 'img/cogs.gif' });

            let savedFileName = 'Documents ' + moment().format('YYYY-MM-DD-HH-mm-ss') + '.pdf';

            this.pdfFiles = [];

            this.$parent.$parent.selectedRows.forEach(id => {

                let data = this.$parent.table.row( '#' + id ).data();

                this.pdfFiles.push(data);

            });         
            
            axios.post('/pdf/combine', {
                pdfFiles: JSON.stringify(this.pdfFiles),
                folder: 'documents',
                saveAs: savedFileName
            })

            .finally(() => { root.$snotify.clear() })

            .then(( response ) => {

                if ( response.data.error ) {

                    showError('Error combining Documents',response.data.error);

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


    }
}  
</script>
