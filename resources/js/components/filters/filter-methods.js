export default Vue.extend({

    methods: {

        primeCommonFilters() {

            // Prime the myRecords Filter Check Box
            if ( typeof this.myRecordsFilterColumnName !== 'undefined') {
                this.myRecordsFilterKey = this.getFilterName(this.myRecordsFilterColumnName);
                this.myRecordsFilter = this.getFilter(this.myRecordsFilterKey);
                this.myRecordsSelected = this.myRecordsFilter ? '1' : '0';
            }
            
            // Prime the Date Filter 
            if ( typeof this.dateFilterColumnName !== 'undefined') {
                let dateFilterKey = this.getFilterName(this.dateFilterColumnName);
                this.$refs[this.id + '-date-filter'].primeFilter(dateFilterKey, this.dateFilterColumnName);
            }
            
            // Prime the Description Filter 
            if ( typeof this.descriptionFilterColumnName !== 'undefined') {
                this.descriptionFilterKey = this.getFilterName(this.descriptionFilterColumnName);
                this.descriptionFilter = this.getFilter(this.descriptionFilterKey);

                if ( this.descriptionFilter ) {
                    this.$refs[this.id + '-description-filter'].displayClearIcon = true;
                    this.$refs[this.id + '-description-filter'].setValue = this.descriptionFilter.settings.value;
                } else {
                    this.$refs[this.id + '-description-filter'].displayClearIcon = false;
                }
            }

            // Prime the Amount Filter component
            if ( typeof this.amountFilterColumnName !== 'undefined') {
                let amountFilterKey = this.getFilterName(this.amountFilterColumnName);

                

                this.$refs[this.id + '-amount-filter'].primeFilter(amountFilterKey, this.amountFilterColumnName);
            }

            if ( typeof this.typeFilterColumnName !== 'undefined') {

                this.typeRadioButtonComponent = this.$refs['type-radio-button'];

                this.typeFilterKey = this.getFilterName(this.typeFilterColumnName);
                this.typeFilter = this.getFilter(this.typeFilterKey);
                this.typeFilterFlag = this.typeFilter ? true : false;

                this.typeRadioButtonComponent.clearIcon = this.typeFilterFlag;
                this.typeRadioButtonComponent.clearIconCallback = 'clearTypeFilter';
                this.typeRadioButtonRecord.value = null; 
            }

            // Prime the Status Radio Button - Other methods are in filter-methods.js
            if ( typeof this.statusFilterColumnName !== 'undefined') {
                this.statusRadioButtonComponent = this.$refs['status-radio-button'];

                this.statusFilterKey = this.getFilterName(this.statusFilterColumnName);
                this.statusFilter = this.getFilter(this.statusFilterKey);
                this.statusFilterFlag = this.statusFilter ? true : false;

                this.statusRadioButtonComponent.clearIconCallback = 'clearStatusFilter';
                this.statusRadioButtonComponent.clearIcon = this.statusFilterFlag;

                if ( this.statusFilterFlag ) {
                    this.statusRadioButtonRecord.value = this.statusFilter.settings.value; 
                } else {
                    this.statusRadioButtonRecord.value = null; 
                }
            }

        },

        getFilterName(columnName) {

            let columnDefIndex = this.table.columnDefs.findIndex( columnDef => columnDef.name === columnName);

            if ( columnDefIndex === -1 ) {
                console.error('columnDef named ' + columnName + ' not found in addFilter() in FilterOptions');
                return 'UnknownColumnName' + toCamelCase(columnName) + 'Filter';
            } 
            return toCamelCase(this.table.singular + this.table.columnDefs[columnDefIndex].title) + 'Filter';
        },

        getColumnDef(columnName) {

            let columnDefIndex = this.table.columnDefs.findIndex( columnDef => columnDef.name === columnName);

            if ( columnDefIndex === -1 ) {
                console.error('columnDef named ' + columnName + ' not found in addFilter() in FilterOptions');
                return null;
            } 
            return this.table.columnDefs[columnDefIndex];
        },

        addFilter(columnName, key, value, value1 = null, method = 'Equals', period = null, description = '') {

            let columnDefIndex = this.table.columnDefs.findIndex( columnDef => columnDef.name === columnName);

            if ( columnDefIndex === -1 ) {
                console.error('columnDef named ' + columnName + ' not found in addFilter() in FilterOptions');
                return;
            } 

            let columnDef = this.table.columnDefs[columnDefIndex];
            
            let record = {
                key: key,
                fromDate: columnDef.filterType === 'Date' ? value : null,
                toDate: columnDef.filterType === 'Date' ? value1 : null,
                period: columnDef.filterType === 'Date' ? period : null,
                fromAmount: columnDef.filterType === 'Number' ? value : null,
                toAmount: columnDef.filterType === 'Number' ? value1 : null,
                value: value,
                value1: value1,
                description: description,
                method: method,
                join: 'and',
                targets: columnDef.targets,
                title: columnDef.title,
                name: columnDef.filterColumnName ? columnDef.filterColumnName : columnDef.name,
                calculatedColumn: columnDef.calculatedColumn ? columnDef.calculatedColumn : false,
                filterType: columnDef.filterType ? columnDef.filterType : 'String',
                filterTitle: columnDef.filterTitle ? columnDef.filterTitle : columnDef.title,
            };

            let tableFilters = getTableFilter(this.table.tableId);

            let filter = this.getFilter(key);

            if ( filter == null ) {

                record.index = tableFilters.length;

                tableFilters.push(record);

            } else {     

                tableFilters[filter.index] = record;

            }

            setTableFilter(this.table.tableId, tableFilters);

        },

        addCustomFilter(key, record) {

            let tableFilters = getTableFilter(this.table.tableId);

            let filter = this.getFilter(key);

            if ( filter == null ) {

                record.index = tableFilters.length;

                tableFilters.push(record);

            } else {     

                tableFilters[filter.index] = record;

            }

            setTableFilter(this.table.tableId, tableFilters);

        },

        getFilter(key) {

            let tableFilters = getTableFilter(this.table.tableId)

            let filterIndex = tableFilters.findIndex( tableFilter => tableFilter.key === key);

            if ( filterIndex > -1 ) {

                return {index: filterIndex, settings: tableFilters[filterIndex]};

            }

            return null;
        },

        deleteFilter(key) {

            let tableFilter = this.getFilter(key);

            if ( tableFilter ) {
                
                this.$root.tableFilterSettings.tableId = this.table.tableId;

                this.$root.tableFilterSettings.deleteTableFilter(tableFilter.index,false)

            }

        },

        loadAdvancedFilters() {

            this.close();

            this.$root.tableFilterSettings.openModal(this.table.tableId, this.table)

        },



        // ******************************************************************
        // These are repeated often in some Filter Forms - so putting it here
        // ******************************************************************
        descriptionCleared() {

            this.deleteFilter(this.descriptionFilterKey);

            this.descriptionSelected = this.$refs[this.id + '-description-filter'].setValue = '';
            this.$refs[this.id + '-description-filter'].displayClearIcon = false;

            this.reloadTable();


        },

        setDescription(newValue) {

            this.deleteFilter(this.descriptionFilterKey);

            if (newValue) {
                this.addFilter(this.descriptionFilterColumnName, this.descriptionFilterKey, newValue, null, 'Contains');
                this.$refs[this.id + '-description-filter'].displayClearIcon = true;
                this.$refs[this.id + '-description-filter'].setValue = newValue;
            } else {
                this.$refs[this.id + '-description-filter'].displayClearIcon = false;
            }

            this.reloadTable();


        },

        myRecordsChanged(newValue) {

            this.deleteFilter(this.myRecordsFilterKey);

            if (newValue == 1) this.addFilter(this.myRecordsFilterColumnName, this.myRecordsFilterKey, root.loggedInEmployeeName);

            this.reloadTable();

        },

        statusRadioButtonChanged(newValue) {

            this.deleteFilter(this.statusFilterKey);

            if ( newValue !== 'All') {
                
                this.statusRadioButtonComponent.clearIcon = true;

                let description = this.statusArray.filter(record => record.value == newValue)[0].text;

                this.addFilter(this.statusFilterColumnName, this.statusFilterKey, newValue, null, 'Equals', null, description);

            }

            this.reloadTable();

        },

        clearStatusFilter() {

            this.statusRadioButtonComponent.clearIcon = false;

            this.deleteFilter(this.statusFilterKey);

            this.reloadTable();

            //Clear the Type Radio Button radio buttons
            this.statusRadioButtonRecord.value = null; 

            // let allOption = this.statusArray.find(obj => obj.text === 'All');

            // if ( typeof allOption === 'undefined') {
            //     this.statusRadioButtonRecord.value = null; 
            // } else {
            //     this.statusRadioButtonRecord.value = 'All'; 
            // }

        },


        typeRadioButtonChanged(newValue) {

            this.deleteFilter(this.typeFilterKey);
            
            if ( newValue !== 'All') {
                
                this.typeRadioButtonComponent.clearIcon = true;

                this.addFilter(this.typeFilterColumnName, this.typeFilterKey, newValue);

            }

            this.reloadTable();

        },

        clearTypeFilter() {

            this.typeRadioButtonComponent.clearIcon = false;

            this.deleteFilter(this.typeFilterKey);

            this.reloadTable();

            //Clear the Type Radio Button radio buttons
            this.typeRadioButtonRecord.value = null; 

        },

        partySelected(selectedRecord) {

            this.deleteFilter(this.partyFilterKey);

            this.addFilter(this.partyFilterColumnName, this.partyFilterKey, selectedRecord.matterprefix);

            this.partyFilterFlag = true;

            this.reloadTable();

        },

        clearPartyFilter() {

            this.deleteFilter(this.partyFilterKey);

            this.partyFilterFlag = false;

            this.selectParty.partyName = '';

            this.reloadTable();

        },

        reloadTable() {

            this.table.setUserFilters();

            this.table.table.ajax.reload();

        },



    }

})