<template>

    <div class="d-lg-flex filofax-page-container" id="filofax-both-pages">

        <div class="filofax-left-page" id="filofax-left-page">

            <keep-alive>
                <router-view ref="left-page" name="leftPage" :key="$route.name"/>
            </keep-alive>
    
        </div>


        <div class="filofax-binder d-none d-lg-block"></div>
        
        <div class="filofax-right-page" id="filofax-right-page">

            <keep-alive>
                <router-view ref="right-page" name="rightPage" :key="$route.name"/>
            </keep-alive>
            

        </div>

        <component v-show="false" :is="$root.generatedComponent" id="global-generated-component"/>

        <loading-data-modal ref="loadingDataModal" id="loading-data-modal"/>

        <email-modal ref="emailModal" id="email-modal"/>

        <table-layout-modal ref="tableLayoutModal" id="table-layout-modal"/>

        <table-filter-settings ref="tableFilterSettings" id="table-filter-settings"/>

        <column-filter-form ref="columnFilterForm" id="column-filter-form"/>

        <preview-documents ref="previewDocuments" id="preview-documents"/>

        <preview-pdf ref="previewPdf" id="preview-pdf"/>

        <preview-html ref="previewHtml" id="preview-html"/>

        <iframe class="d-none" id="global-print-table" name="global-print-table"></iframe>

        <modal-delete ref="deleteModal" id="global-delete-modal"/>
        <modal-dialog ref="dialogModal" id="global-dialog-modal"/>
        <generating-documents-modal ref="generatingDocumentsModal" id="global-generating-documents-modal"/> -->

        <matter-form ref="globalMatterForm" uniqueId="global-matter-form" id="global-matter-form" :modal="true" :readOnly="true" />
        <party-form ref="globalPartyForm" uniqueId="global-party-form" id="global-party-form" :modal="true" :readOnly="true" />

        <select-library ref="globalSelectLibrary" id="global-select-library"/>
        <select-component ref="globalSelectComponent" id="global-select-component"/>
        <select-template ref="globalSelectTemplate" id="global-select-template"/>
        <select-templates ref="globalSelectTemplates" id="global-select-templates"/>
        <select-template-fields ref="globalSelectTemplateFields" id="global-select-template-fields"/>

        <party-filter-form id="global-party-filter-form" ref="partyFilterForm"/>
        <matter-filter-form id="global-matter-filter-form" ref="matterFilterForm"/>
        <email-filter-form id="global-email-filter-form" ref="emailFilterForm"/>

        <!-- <employee-form ref="globalEmployeeForm" uniqueId="global-employee-form" id="global-employee-form" :modal="true" :readOnly="true" />
        <fee-note-form ref="globalFeeNoteForm" uniqueId="global-fee-note-form" id="global-fee-note-form" :modal="true" :readOnly="true" /> 
        <fee-code-form ref="globalFeeCodeForm" uniqueId="global-fee-code-form" id="global-fee-code-form" :modal="true" :readOnly="true" />  -->

    </div>

</template>

<script>

export default {

    // 14 Jan 2022 - Not sure if we need these?
    components: {
        // EmployeeForm: () => import("@pages/employees/EmployeeForm"),
        // FeeNoteForm: () => import("@pages/feenotes/FeeNoteForm"),
        // FeeCodeForm: () => import("@pages/feecodes/FeeCodeForm"),
    },

    computed: {

        currentRouteName() {

            return this.$route ? this.$route.name : null;

        }
    },

    watch: {
        
        currentRouteName(newValue) {

            //console.log("currentRouteName",newValue);
            
            // 26 Mar 2021 - Sometimes get an error: "TypeError: Cannot read property 'route' of null"
            if ( newValue == null ) return;

            //Check if a Form requires a table (or tables) to be refreshed

            this.$root.refreshTables.forEach(table => {
                
                if (table && table.route === newValue) {

                    console.log('refreshing ', table.tableRef);

                    componentFunction(table.tableRef, 'refresh');

                    if (table.formRef) {

                        componentFunction(table.formRef, 'refresh');

                    }
                }
                
            });

            // Remove the refreshed tables from the array
            for (let index = 0; index < this.$root.refreshTables.length; index++) {
                
                const table = this.$root.refreshTables[index];

                if (table && table.route === newValue ) {
                    this.$root.refreshTables.splice(index, 1);
                }
                
            }

        }
    },

    mounted() {

        this.$root.loadingDataModal = this.$refs.loadingDataModal;

        this.$root.loadingDataModal.show();

        this.$root.partyFilterForm = this.$refs.partyFilterForm;
        this.$root.matterFilterForm = this.$refs.matterFilterForm;
        this.$root.emailFilterForm = this.$refs.emailFilterForm;

        this.$root.selectLibrary = this.$refs.globalSelectLibrary;
        this.$root.selectComponent = this.$refs.globalSelectComponent;
        this.$root.selectTemplate = this.$refs.globalSelectTemplate;
        this.$root.selectTemplates = this.$refs.globalSelectTemplates;
        this.$root.selectTemplateFields = this.$refs.globalSelectTemplateFields;

        this.$root.previewDocuments = this.$refs.previewDocuments;

        this.$root.previewPdf = this.$refs.previewPdf;
        this.$root.previewHtml = this.$refs.previewHtml;

        this.$root.emailModal = this.$refs.emailModal;
        this.$root.tableLayoutModal = this.$refs.tableLayoutModal;
        this.$root.tableFilterSettings = this.$refs.tableFilterSettings;
        this.$root.columnFilterForm = this.$refs.columnFilterForm;
        this.$root.deleteModal = this.$refs.deleteModal;
        this.$root.dialogModal = this.$refs.dialogModal;
        this.$root.generatingDocumentsModal = this.$refs.generatingDocumentsModal;

    },

    methods: {

    },
}
</script>





