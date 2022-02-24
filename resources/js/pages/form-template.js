export default Vue.extend({
    
    props: {
        parentTableRef: {
            type: String,
            default: '',
        },        
        leftPageTableRef: {
            type: String,
            default: '',
        },        
        readOnly: {
            type: Boolean,
            default: false,
        },        
    },

    data() {
        return {
            table: null,
            action: null,
            savedFlag: false,
            editing: false,
            viewing: false,
            processing: false, // To prevent double clicking on OK button
            record: {},
            errors: {},
        }
    },

    methods: {

        permission(action) {

            return root.checkPermission(this.resource, this.secProc, action);

        },


        insertClicked( anyDataObject ) {

            if ( this.secProc ) {
                if ( !this.permission('Insert') ) return;
            }

            this.setTableComponent();

            this.savedFlag = this.editing = false;

            this.action = 'store';

            if (this.table) this.table.unHighlightAllRows();

            this.errors = {};

            setTimeout(() => { $('#' + this.id + " .popover-icon").popover(); }, 100);

            this.initNewRecord( anyDataObject );

        },

        editClicked( id, viewing = false ) {

            if ( this.secProc ) {
                if ( !this.permission('Change') ) return;
            }

            this.errors = {};

            this.savedFlag = false;

            this.editing = true;

            this.action = 'update';

            this.viewing = viewing;

            if ( !this.viewing ) this.setTableComponent();

            if (this.table) this.table.highlightRow(id);

            setTimeout(() => { $('#' + this.id + " .popover-icon").popover(); }, 100);

            this.editRecord(id);

        },

        deleteClicked() {

            if ( this.secProc ) {
                if ( !this.permission('Delete') ) return;
            }

            if ( typeof this.canDelete === 'function') {
            
                this.canDelete()
                
                .then(() => {

                    this.showDeleteModal();

                }).catch( (error) => {

                    showError( 'Access Denied', error);

                });

            } else {

                this.showDeleteModal();

            }

        },

        highlightRow( id, params ) {

            if ( this.table ) {

                axios.post('/' + this.table.tableName + '/get', { 
                    ...params, 
                    whereRaw: this.table.tableFilter, 
                    method: 'count'
                })

                .then(response => {

                    if (response.data.errors) { 

                        showError( 'Error', response.data.errors);

                    } else {

                        this.table.jumpToRow(id, response.data.data);

                    }

                }).catch( (error) => {
                    showError('Error getting Table Position', error); 
                });

            }
        },    


        showDeleteModal() { 

            this.$root.deleteModal.callingComponent = this;
            this.$root.deleteModal.description = 'this ' + this.table.singular;
            this.$root.deleteModal.show();

        },

        setAllTablesToRefresh() {
            this.$root.setTableToRefresh('bills', 'bills-table', 'bill-transactions-table');
            this.$root.setTableToRefresh('payments', 'payments-table', 'payment-bills-posted-table');
            this.$root.setTableToRefresh('invoices', 'invoices-table', 'invoice-transactions-table');
            this.$root.setTableToRefresh('disbursements', 'disbursements-table');
            this.$root.setTableToRefresh('feenotes', 'fee-notes-table');
            this.$root.setTableToRefresh('statements', 'statement-table');
            this.$root.setTableToRefresh('statements', 'statement-transactions-table');
            this.$root.setTableToRefresh('matters', 'matters-table', 'matter-right-matter-form');
            this.$root.setTableToRefresh('parties', 'parties-table', 'party-right-party-form');
            this.$root.setTableToRefresh('creditors', 'creditors-table');
            this.$root.setTableToRefresh('accounts', 'accounts-table');
            this.$root.setTableToRefresh('batches', 'batches-table');
            this.refreshAccountingReports();
        },
        
        refreshAccountingReports() {
            this.$root.setTableToRefresh('reports', 'report-trial-balance');
            this.$root.setTableToRefresh('reports', 'report-balance-sheet');
            this.$root.setTableToRefresh('reports', 'report-income-statement');
        },

        setTableComponent() {

            if ( this.leftPageTableRef ) {
                this.table = this.$root.$refs['pages'].$refs['left-page'].$refs[this.leftPageTableRef];
            } else if ( this.parentTableRef ) {
                this.table = this.$parent.$refs[this.parentTableRef];
            }

            //console.log('this.table - ' + this.id, this.table);

            // Note - This is usually caused by TWO OR MORE forms having the same id!!
            // if (!this.table) {
            //     console.error('No Table set for ' + this.id);
            //     console.log('this.$parent.$refs',this.$parent.$refs);
            //     console.log('this.parentTableRef',this.parentTableRef);
            //     console.log('this.leftPageTableRef',this.leftPageTableRef);
            // }

        },

        refresh() {

            //console.log('refreshing ' + this.table.route + ' Form');
            
            axios.post('/' + this.table.route + '/get',{recordid: this.record.id}).then(response => {this.record = response.data.data[0]});

            if ( typeof this.refreshFormTables === 'function') this.refreshFormTables();

            
        },

        hide() { 

            if (!this.modal) {

                this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].clearPages();

            } else {

                this.closeModal();

            }

        },       

        matterSelected(selectedRecord) {

            this.record.matterid = selectedRecord.recordid;

        },        

        partySelected(selectedRecord) {

            this.record.partyid = selectedRecord.recordid;

        },        

        employeeSelected(selectedRecord) {

            this.record.employeeid = selectedRecord.recordid;

        },        

        displayForm() { 
            if (!this.modal) {
                root.$refs['pages'].$refs["left-page"].loadPages('Form');
            } else {
                this.show();
            }    
            if ( typeof this.formOpened === 'function') this.formOpened();  
        },

        closeForm() { 

            if (!this.modal) {
                this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].clearPages();
            } else {
                this.close();
            }

        },   

        setGeneralTab() {

            this.activeTab = 'General';
            this.tabs[0].active = true;

            for (let index = 1; index < this.tabs.length; index++) {

                this.tabs[index].active = false;

            }

        },


    },

})
