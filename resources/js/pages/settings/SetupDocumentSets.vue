<template>

<div  class="card h-100 border-0">
    
    <div class="card-header">
        <div class="d-flex justify-content-between">
            <h3>Document Sets</h3>
            <page-close-button @closeClicked="hide"/>
        </div>
    </div>

    <div class="card-body overflow-auto p-3">

        <document-set-table
            table-id="settings-document-set-table"
            :lazyLoadFlag="true"
            ref="settings-document-set-table"
            :formRef="'settings-document-set-form'"
        />

    </div>

    <document-set-form 
        :id="_uid + '-settings-document-set-form'"
        ref="settings-document-set-form" 
        parentTableRef="settings-document-set-table"
        :modal="true"
    />

</div>
    
</template>

<script>

export default {

    components: {
        DocumentSetTable: () => import("@pages/document-sets/DocumentSetTable"),
        DocumentSetForm: () => import("@pages/document-sets/DocumentSetForm"),
    },


    data() {
        return {
            activePage: 'DocumentSets',
            table: null,
        }
    },    

    methods: {

        hide() {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].closePage(this.activePage);

        },


        newRecordButtonClicked: function () {

            this.$refs['settings-document-set-form'].table = this.table;

            this.$refs['settings-document-set-form'].insertClicked();

        },

    },    

}
</script>