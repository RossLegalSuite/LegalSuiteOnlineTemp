<template>
    <div class="card h-100 border-0">
        <div class="card-header">
            <div class="d-flex justify-content-between">
                <h3 class="page-title">File Notes: <span v-html="pageTitle()"></span></h3>
                <page-close-button @closeClicked="closeClicked"/>
            </div>
        </div>

        <div class="card-body overflow-auto p-3">

            <common-file-notes-table 
                :ref="'common-' + parentType.toLowerCase() + '-file-notes-table'"
                :form-ref="'common-' + parentType.toLowerCase() + '-file-notes-form'"
                :table-id="'common-' + parentType.toLowerCase() + '-file-notes-table'"
                :lazy-load-flag="true"
                :parentType="parentType"
            />

            <common-file-notes-form 
                :id="'common-' + parentType.toLowerCase() + '-file-notes-form'"
                :ref="'common-' + parentType.toLowerCase() + '-file-notes-form'"
                :parentTableRef="'common-' + parentType.toLowerCase() + '-file-notes-table'"
                :modal="true"
            />

        </div>
    </div>
</template>  

<script>

import { mapGetters } from 'vuex';

export default {

    components: {
        CommonFileNotesTable: () => import("@pages/filenotes/FileNoteTable"),
        CommonFileNotesForm: () => import("@pages/filenotes/FileNoteForm"),
    },

    props: {
        parentType: String,
    },

    computed: {
        ...mapGetters(['currentMatter', 'currentParty', 'currentEmployee' ]),
    },

    methods: {

        closeClicked() { 

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].clearPages();

        },

        pageTitle() {
            
            if ( this.parentType === 'Matter') {
                return (this.currentMatter.fileref) ? this.currentMatter.fileref + ' - ' + this.currentMatter.description : '';
            } else if ( this.parentType === 'Party') {
                return (this.currentParty.code) ? this.currentParty.code + ' - ' + this.currentParty.name : '';
            } else if ( this.parentType === 'Employee') {
                return (this.currentEmployee.name) ? this.currentEmployee.name : '';
            }

        },

        newRecordButtonClicked() {

            this.$refs['common-' + this.parentType.toLowerCase() + '-file-notes-form'].currentParentType = this.parentType;
            
            this.$refs['common-' + this.parentType.toLowerCase() + '-file-notes-form'].insertClicked();

        },

    },
}
</script> 