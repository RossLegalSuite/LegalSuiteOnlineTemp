<template>
    <div class="card h-100 border-0">
        <div class="card-header assemble-bg">
            <div class="d-flex justify-content-between">
                <h3><i class="fa fa-cogs mr-2"></i>Assemble Documents</h3>
                <page-close-button @closeClicked="closeLeftPage(pageName)"/>
            </div>
        </div>

        <div class="card-body overflow-auto pb-1 pt-3 px-3">

            <assemble-table 
                :lazyLoadFlag="true"
                :tagging="true"
                formRef="left-page" 
                ref="assemble-table" 
                tableId="assemble-table"
            />

        </div>

        <select-matters id="assemble-select-matters" ref="assemble-select-matters" formRef="assemble-select-matters"/>

        <select-parties id="assemble-select-parties" ref="assemble-select-parties" formRef="assemble-select-parties"/>

        <select-matter-parties id="assemble-select-matter-parties" ref="assemble-select-matter-parties" formRef="assemble-select-matter-parties"/>

        <select-employees id="assemble-select-employees" ref="assemble-select-employees" formRef="assemble-select-employees"/>

    </div>
</template>     

<script>

import { mapGetters } from 'vuex';
import { mapMutations } from 'vuex';
import leftTemplate from "../left-template";

export default {

    extends: leftTemplate,

    components: {
        AssembleTable: () => import("./AssembleTable"),
        SelectMatters: () => import("@pages/matters/SelectMatters"),
        SelectParties: () => import("@pages/parties/SelectParties"),
        SelectMatterParties: () => import("@pages/matter-parties/SelectMatterParties"),
        SelectEmployees: () => import("@pages/employees/SelectEmployees"),
    },

    data() {
        return {
            pageName: "Assemble",
            tableMounted: false,
            rightPage: null,
            form: null,
            document: {},
            abortMerge: false,
            selectedTemplates: [], // Copy of selectedRows so it doesn't confuse the Tagging
            selectedRows: [],
            selectedAllFlag: false,
            assembleDocumentsFlag: true,
            mergeTemplateSource: '',
        };
    },

    computed: {
        ...mapGetters(['leftTabs','activeLeftTabs']),
    },

    watch: {

        mergeTemplateSource(newValue) {

            if ( newValue === 'General' ) {

                this.mergeGeneralTemplates();

            } else if ( newValue === 'Parties' ) {

                this.mergePartyTemplates();

            } else if ( newValue === 'Party Roles' ) {

                this.mergeMatterPartyTemplates();

            } else if ( newValue === 'Matters' ) {

                this.mergeMatterTemplates();

            } else if ( newValue === 'Employees' ) {

                this.mergeEmployeeTemplates();

            }

        },

        abortMerge(newValue) {

            if ( newValue === true ) root.$snotify.clear();

        },

        tableMounted() { this.initializeTable(); },

    },

    mounted() {

        let thisTab = this.leftTabs.filter(tab => tab.pageName === this.pageName);

        if (thisTab.length)  this.displayLeftTab(thisTab[0]);

    },    

    methods: {

        ...mapMutations(['displayLeftTab','hideLeftTab']),


        selectRecord(id) {

            this.mergeTemplateSource = ''; // Reset this (in case they aborted the last Select) so it fires the watch()

            //Wrap this in a timeout, so the watch() fires 
            setTimeout(() => {
                
                root.documentAssembly.batchId = Date.now();

                this.selectedTemplates = [id];

                this.mergeTemplateSource = 'Parties'; // Start Here (or get the source form the DatatTable!!)

            });
        },


        assembleDocuments() {

            this.mergeTemplateSource = '';

            if ( !this.selectedRows.length) {

                showError('No Templates selected', 'Please tag a Template (or multiple Template) first' );

            } else {

                //Wrap this in a timeout, so the watch() fires 
                setTimeout(() => {

                    root.documentAssembly.batchId = Date.now();

                    this.selectedTemplates = JSON.parse(JSON.stringify(this.selectedRows));

                    this.mergeTemplateSource = 'Parties'; // Go to next step
                });

            }
            
        },        

        async mergePartyTemplates() {

            let response = await axios.post('/document_templates/get', {
                whereIn: { column: 'document_templates.id', value: this.selectedTemplates },
                where: { column: 'document_templates.source', value: 'Parties'},
            });

            if ( response.data.length ) {
                this.selectParties.selectParties();
            } else {
                this.mergeTemplateSource = 'Party Roles'; // Go to next step
            }

        },        

        async mergeMatterPartyTemplates() {

            let response = await axios.post('/document_templates/get', {
                whereIn: { column: 'document_templates.id', value: this.selectedTemplates },
                where: { column: 'document_templates.source', value: 'Party Roles'},
            });

            if ( response.data.length ) {
                this.selectMatterParties.selectMatterParties();
            } else {
                this.mergeTemplateSource = 'Matters'; // Go to next step
            }

        },        

        async mergeMatterTemplates() {

            let response = await axios.post('/document_templates/get', {
                whereIn: { column: 'document_templates.id', value: this.selectedTemplates },
                where: { column: 'document_templates.source', value: 'Matters'},
            });

            if ( response.data.length ) {
                this.selectMatters.selectMatters();
            } else {
                this.mergeTemplateSource = 'General'; // Go to next step
            }

        },        

        async mergeGeneralTemplates() {

            let response = await axios.post('/document_templates/get', {
                whereIn: { column: 'document_templates.id', value: this.selectedTemplates },
                where: { column: 'document_templates.source', value: 'General'},
            });

            if ( response.data.length ) {
                this.assembleGeneralDocuments();
            } else {
                this.mergeTemplateSource = 'Employees';
            }
        },

        async mergeEmployeeTemplates() {

            let response = await axios.post('/document_templates/get', {
                whereIn: { column: 'document_templates.id', value: this.selectedTemplates },
                where: { column: 'document_templates.source', value: 'Employees'},
            });

            if ( response.data.length ) {
                this.selectEmployees.selectEmployees();
            } else {
                this.mergeTemplateSource = '';
            }

        },


        async partiesSelected(selectedParties, table) {

            root.documentAssembly.tablePage = root.documentAssembly.whereClause = null;
            root.documentAssembly.singular = 'Party';
            root.documentAssembly.plural = 'Parties';
            root.documentAssembly.abortMerge = false;

            let params = ( this.selectedTemplates.length ) ? 
            { dataFormat: 'idArray', where: { column: 'document_templates.source', value: 'Parties'}, whereIn: { column: 'document_templates.id', value: this.selectedTemplates } } : 
            { dataFormat: 'idArray', where: { column: 'document_templates.source', value: 'Parties'} };

            let response = await axios.post('/document_templates/get', params);

            root.$snotify.simple(response.data.data[0].title, 'Assembling', { timeout: 0, icon: 'img/cogs.gif' });

            await root.asyncForEach( response.data, async (document) => {

                    const params = ( selectedParties.length ) ? 
                    { dataFormat: 'idArray', whereIn: { column: 'parties.id', value: selectedParties } } : 
                    { dataFormat: 'idArray', tableFilter: table.tableFilter, tableHaving: table.tableHaving };

                    const response = await axios.post('/party/get', params);

                    await root.asyncForEach( response.data, async (record) => {            

                        if ( !root.documentAssembly.abortMerge ) {

                            this.setMergeOptions(record.code, record.id, document);

                            $('.snotify-simple .snotifyToast__body').text(document.title + ' with ' + record.name);

                            await root.documentAssembly.createPartyDocument( record.id )
                            .then( async (convertResponse) => {
                                await root.documentAssembly.storeCorrespondence( convertResponse, document, record );
                            });

                        }

                    });

            });

            ///Throttle to avoid calling Matter Parties if only one Template was selected
            this.mergeTemplateSource = this.selectedTemplates.length > 1 ? 'Party Roles': '';

            this.showMergedDocuments();

            root.$snotify.clear();

        },

        async matterPartiesSelected(selectedMatterParties, table) {

            root.documentAssembly.tablePage = root.documentAssembly.whereClause = null;
            root.documentAssembly.singular = 'Matter Party';
            root.documentAssembly.plural = 'Matter Parties';
            root.documentAssembly.abortMerge = false;

            let params = ( this.selectedTemplates.length ) ? 
            { dataFormat: 'idArray', where: { column: 'document_templates.source', value: 'Party Roles'}, whereIn: { column: 'document_templates.id', value: this.selectedTemplates } } : 
            { dataFormat: 'idArray', where: { column: 'document_templates.source', value: 'Party Roles'} };

            let response = await axios.post('/document_templates/get', params);

            root.$snotify.simple(response.data.data[0].title, 'Assembling', { timeout: 0, icon: 'img/cogs.gif' });

            await root.asyncForEach( response.data, async (document) => {

                    const params = ( selectedMatterParties.length ) ? 
                    { dataFormat: 'idArray', whereIn: { column: 'matter_parties.id', value: selectedMatterParties } } : 
                    { dataFormat: 'idArray', tableFilter: table.tableFilter, tableHaving: table.tableHaving };

                    const response = await axios.post('/matter_parties/get', params);

                    await root.asyncForEach( response.data, async (record) => {            

                        if ( !root.documentAssembly.abortMerge ) {

                            this.setMergeOptions(record.code, record.id, document);

                            $('.snotify-simple .snotifyToast__body').text(document.title + ' with ' + record.name);

                            await root.documentAssembly.createMatterPartyDocument( record.id )
                            .then( async (convertResponse) => {
                                await root.documentAssembly.storeCorrespondence( convertResponse, document, record );
                            });

                        }

                    });

            });

            ///Throttle to avoid calling Matters if only one Template was selected
            this.mergeTemplateSource = this.selectedTemplates.length > 1 ? 'Matters': '';

            this.showMergedDocuments();
            
            root.$snotify.clear();

        },

        async mattersSelected(selectedMatters, table) {

            root.documentAssembly.tablePage = root.documentAssembly.whereClause = null;
            root.documentAssembly.singular = 'Matter';
            root.documentAssembly.plural = 'Matters';
            root.documentAssembly.abortMerge = false;

            let params = ( this.selectedTemplates.length ) ? 
            { dataFormat: 'idArray', where: { column: 'document_templates.source', value: 'Matters'}, whereIn: { column: 'document_templates.id', value: this.selectedTemplates } } : 
            { dataFormat: 'idArray', where: { column: 'document_templates.source', value: 'Matters'} };

            let response = await axios.post('/document_templates/get', params);

            root.$snotify.simple(response.data.data[0].title, 'Assembling', { timeout: 0, icon: 'img/cogs.gif' });

            await root.asyncForEach( response.data, async (document) => {

                    const params = ( selectedMatters.length ) ? 
                    { dataFormat: 'idArray', whereIn: { column: 'matters.id', value: selectedMatters } } : 
                    { dataFormat: 'idArray', tableFilter: table.tableFilter, tableHaving: table.tableHaving };

                    const response = await axios.post('/matters/get', params);

                    await root.asyncForEach( response.data, async (record) => {            

                        if ( !root.documentAssembly.abortMerge ) {

                            this.setMergeOptions(record.fileRef, record.id, document);

                            $('.snotify-simple .snotifyToast__body').text(document.title + ' with ' + record.fileRef);

                            await root.documentAssembly.createMatterDocument( record.id )
                            .then( async (convertResponse) => {
                                await root.documentAssembly.storeCorrespondence( convertResponse, document, record );
                            });

                        }
                        

                    });

            });

            ///Throttle to avoid calling General if only one Template was selected
            this.mergeTemplateSource = this.selectedTemplates.length > 1 ? 'General': '';

            this.showMergedDocuments();
            
            root.$snotify.clear();

        },


        async employeesSelected(selectedEmployees, table) {

            root.documentAssembly.tablePage = root.documentAssembly.whereClause = null;
            root.documentAssembly.singular = 'Employee';
            root.documentAssembly.plural = 'Employees';
            root.documentAssembly.abortMerge = false;

            let params = ( this.selectedTemplates.length ) ? 
            { dataFormat: 'idArray', where: { column: 'document_templates.source', value: 'Employees'}, whereIn: { column: 'document_templates.id', value: this.selectedTemplates } } : 
            { dataFormat: 'idArray', where: { column: 'document_templates.source', value: 'Employees'} };

            let response = await axios.post('/document_templates/get', params);

            root.$snotify.simple(response.data.data[0].title, 'Assembling', { timeout: 0, icon: 'img/cogs.gif' });

            await root.asyncForEach( response.data, async (document) => {

                    const params = ( selectedEmployees.length ) ? 
                    { dataFormat: 'idArray', whereIn: { column: 'employees.id', value: selectedEmployees } } : 
                    { dataFormat: 'idArray', tableFilter: table.tableFilter, tableHaving: table.tableHaving };

                    const response = await axios.post('/employees/get', params);

                    await root.asyncForEach( response.data, async (record) => {            

                        if ( !root.documentAssembly.abortMerge ) {

                            this.setMergeOptions(record.name, record.id, document);

                            $('.snotify-simple .snotifyToast__body').text(document.title + ' with ' + record.name);

                            await root.documentAssembly.createEmployeeDocument( record.id )
                            .then( async (convertResponse) => {
                                await root.documentAssembly.storeCorrespondence( convertResponse, document, record );
                            });

                        }

                    });

            });

            this.mergeTemplateSource = '';

            this.showMergedDocuments();
            
            root.$snotify.clear();

        },


        async assembleGeneralDocuments() {

            root.documentAssembly.tablePage = root.documentAssembly.whereClause = null;
            root.documentAssembly.singular = 'General';
            root.documentAssembly.plural = 'General';
            root.documentAssembly.abortMerge = false;

            let params = ( this.selectedTemplates.length ) ? 
            { dataFormat: 'idArray', where: { column: 'document_templates.source', value: 'General'}, whereIn: { column: 'document_templates.id', value: this.selectedTemplates } } : 
            { dataFormat: 'idArray', where: { column: 'document_templates.source', value: 'General'} };

            let response = await axios.post('/document_templates/get', params);

            root.$snotify.simple(response.data.data[0].title, 'Assembling', { timeout: 0, icon: 'img/cogs.gif' });

            await root.asyncForEach( response.data, async (document) => {

                if ( !root.documentAssembly.abortMerge ) {

                    this.setMergeOptions('', 0, document);                    

                    $('.snotify-simple .snotifyToast__body').text(document.title)

                    await root.documentAssembly.assembleThisDocument()
                    .then( async ( convertResponse ) => {             
                        await root.documentAssembly.storeCorrespondence( convertResponse, document, {} );
                    });

                }

            });

            ///Throttle to avoid calling Employees if only one Template was selected
            this.mergeTemplateSource = this.selectedTemplates.length > 1 ? 'Employees': '';

            this.showMergedDocuments();
            
            root.$snotify.clear();

        },

        showMergedDocuments() {

            this.$root.setTableToRefresh('correspondence', 'correspondence-table');

            let assembleRight = root.$refs['pages'].$refs["right-page"];

            assembleRight.showPage = true;

            assembleRight.source = root.documentAssembly.mergeOptions.dataSource;

            assembleRight.loadTable(root.documentAssembly.batchId);
            
        },

        setMergeOptions(uniqueIdentifier, id, document) {

            let destinationFileName = document.fileName;

            if ( uniqueIdentifier ) {
                destinationFileName = document.fileName.split('.')[0] + ' ' + makeValidPathString(uniqueIdentifier) + '.docx';
            }

            root.documentAssembly.mergeOptions = {
                source: document.docxFile,
                destinationFileName: destinationFileName,
                destinationFolder: 'merged',
                dataSource: document.source,
                id: id,
                uniqueFileName: true
            };
        },

        editClicked(id) {

            axios.post('/document_templates/get',{recordid: id})

            .then(response => {
                
                let data = response.data.data[0];

                this.$root.previewPdf.title = 'Template: ' + data.description;

                this.$root.previewPdf.document = data;

                this.$root.previewPdf.documentPath = data.pdfFile; //Being watched: To load the iFrame

                this.$root.previewPdf.show();

            });

        },

        emptyDocumentLogTable() {  // Called by AssembleRight

            root.$refs['pages'].$refs["right-page"].loadTable(Date.now());

        },

        initializeTable() {
            
            this.table.setButtonTitle = 'Assemble this Document';
            this.table.setButtonText = 'Select';
            this.table.setButtonFunction = 'selectRecord';
            this.table.actionColumnWidth = 12;
            

            this.table.loadDataTable();

        },
    },
}
</script>