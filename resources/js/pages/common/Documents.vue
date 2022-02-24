<template>

<div class="card h-100 border-0">

    <div class="card-header">
        <div class="d-flex justify-content-between">
            <h3 class="page-title">Documents: <span v-html="pageTitle()"></span></h3>
            <page-close-button @closeClicked="closeClicked"/>
        </div>
    </div>

    <div class="card-body overflow-auto p-3">

        <common-documents-table 
            :ref="'common-' + parentType.toLowerCase() + '-documents-table'"
            :form-ref="'common-' + parentType.toLowerCase() + '-documents-form'"
            :table-id="'common-' + parentType.toLowerCase() + '-documents-table'"
            :lazy-load-flag="true"
            :parentType="parentType"
        />

        <common-documents-form 
            :id="'common-' + parentType.toLowerCase() + '-documents-form'"
            :ref="'common-' + parentType.toLowerCase() + '-documents-form'"
            :parentTableRef="'common-' + parentType.toLowerCase() + '-documents-table'"
            :modal="true"
        />

    </div>

</div>

</template>

<script>

import { mapGetters } from 'vuex';

export default {

    components: {
        CommonDocumentsTable: () => import("@pages/doclog/DoclogTable"),
        CommonDocumentsForm: () => import("@pages/doclog/DoclogForm"),
    },

    computed: {

        ...mapGetters(['currentMatter', 'currentParty', 'currentEmployee']),

    },

    props: {
        parentType: String,
    },

    data() {
        return {
            selectedRows: [],
            selectedAllFlag: false,
        };
    },

    methods: {

        newRecordButtonClicked() {

            this.$refs['common-' + this.parentType.toLowerCase() + '-documents-form'].currentParentType = this.parentType;
            
            this.$refs['common-' + this.parentType.toLowerCase() + '-documents-form'].insertClicked();

        },

        editRecord(id) {

            let data = this.table.table.row( '#' + id ).data();

            this.$root.previewPdf.title = this.currentMatter.fileref + ': ' + data.description;

            this.$root.previewPdf.document = data;

            this.$root.previewPdf.documentPath = data.url; //Being watched: To load the iFrame

            this.$root.previewPdf.show();

        },

        pageTitle() {
            
            if ( this.parentType === 'Matter') {
                return (this.currentMatter.fileref) ? this.currentMatter.fileref + ' - ' + this.currentMatter.description : '';
            } else if ( this.parentType === 'Party') {
                return (this.currentParty.code) ? this.currentParty.code + ' - ' + this.currentParty.name : '';
            }

        },

        closeClicked() { 

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].clearPages();

        },

    },

}  
</script>

