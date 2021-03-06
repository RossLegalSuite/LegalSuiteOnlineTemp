export default {

    props: {
        tableId: String,
        tableColumns: {
            type: Boolean,
            default: true,
        },
        hideShowColumns: {
            type: Boolean,
            default: true,
        },
        tagging: {
            type: Boolean,
            default: false,
        },
        lazyLoadFlag: {
            type: Boolean,
            default: false,
        },
        formRef: {
            type: String,
            default: '',
        },
        parentType: {
            type: String,
            default: '',
        },
        buttonText: {
            type: String,
            default: 'Edit',
        },
        buttonTitle: {
            type: String,
            default: '',
        },
        buttonColumnTitle: {
            type: String,
            default: 'Action',
        },
        buttonClass: {
            type: String,
            default: 'success',
        },
        optionsButton: {
            type: Boolean,
            default: true,
        },
        taggedDropDown: {
            type: Boolean,
            default: true,
        },
        newRecordButton: {
            type: Boolean,
            default: true,
        },
        searchInputFocus: {
            type: Boolean,
            default: true,
        },
        formTable: {
            type: Boolean,
            default: false,
        },
        setActionColumnWidth: {
            type: String,
            default: '',
        },
    },

    data() {
        return {

            url: null,
            title: null,
            subTitle: null,
            plural: null,
            singular: null,
            
            recordsFiltered: 0,
            recordsTotal: 0,
            displayingTaggedRecordsFlag: false,
            savedWhereRaw: null,

            table: null,
            settings: null,
            firstOrderingEvent: true,
            formComponent: '',
            initialOrder: { type: Array, default: [] },
            leftColumns: 0,
            initialColumns: { type: Array, default: [0,1] },
            arrayTableFlag: false,
            selectTableFlag: false,
            viewTableFlag: false,
            editButtonRecordId: 'recordid',
            buttonAdditionalDataParameter: null,
            buttonAdditionalParameter: null,
            tagTableFlag: false,
            noEditButtonFlag: false,

            columnDefs: [],
            tableOptions: {}, 
            form: null,
            selectedId: null,
            tableFilter: null,
            tableFilterDescription: null,
            tableFilterTitle: '',

            setButtonText: null,
            setButtonClass: null,
            setButtonTitle: null,
            buttonFunction: null,
            setButtonColumnTitle: null,

        };
    },

    mounted() {

        // Alias to formRef property (so the formRef can also be set via a data attribute)
        this.formComponent = this.formRef;

        // Alias to actionColumnWidth (so the actionColumnWidth can also be set via a data attribute)
        this.actionColumnWidth = this.setActionColumnWidth ? parseInt(this.setActionColumnWidth) : null;

        // Only set this if the table is not a sub table in a Form
        if ( !this.formTable ) {

            // Set this so any forms used in the parent can use this reference for its table
            this.$parent.table = this;
    
            // Can be used by parents that use a lazyLoaded table
            this.$parent.tableMounted = true;
        }


        // If editing a form, can't add child records until the parent is saved
        // So add them to an array usng a custom loadArrayTable() function
        this.tagTableFlag = this.tagging;

        if ( this.tagTableFlag ) this.$parent.selectedRows = [];

        if ( this.arrayTableFlag ) {
            
            if ( typeof this.loadArrayTable === 'function' ) this.loadArrayTable();
            
        } else if ( !this.lazyLoadFlag ) {

            this.loadDataTable();

        }

    },

    methods: {

        loadDataTable( callback = null ) {

            if ( this.tagTableFlag ) {

                this.$parent.selectedRows = [];

                this.getTagged()

                .then( ( taggedRecords ) => {

                    this.$parent.selectedRows = taggedRecords;

                }).catch( (error) => {
                    showError('Error',error)
                });

            }

            // initialOrder is used by jumpToRow() to reset the order and find the row

            if (!this.initialOrder.length ) {

                let target = this.noEditButtonFlag ? 0 : 1;

                if ( this.tagTableFlag ) target = target + 1;

                this.initialOrder = [[target, "asc"]];

            }

            // Datatables sorting will change the initialOrder (for some reason!) if you don't new it up here with ...
            this.table = this.createDataTable( [...this.initialOrder], callback );

        },

        createDataTable( initialOrder, callback = null ) {

            let _this = this;

            this.destroyTable();

            this.columnDefs = this.createColumnDefs();

            this.setUserColumnDefs();

            this.setUserFilters();

            let emptyTable = this.tableOptions.emptyTable ? this.tableOptions.emptyTable :  "No " + this.plural + " found";

            if (!this.tableOptions.scrollY) this.setTableHeight();

            if ( this.tagTableFlag ) {

                this.tableOptions.select = {
                    style: 'multi',
                    selector: 'td:first-child'
                };

            }

            $.fn.dataTable.moment( root.control.dateformat );

            //https://www.gyrocode.com/articles/jquery-datatables-column-reordering-and-resizing/

            let thisTable = $('#' + this.tableId).DataTable({

                autoWidth: false,

                //ordering: true,
                ordering: typeof this.tableOptions.ordering !== 'undefined' ? this.tableOptions.ordering : true,
                order: initialOrder,

                destroy: true,

                dom: this.tableOptions.dom ? this.tableOptions.dom : "rt",

                serverSide: true,

                rowId: this.tableOptions.rowId ? this.tableOptions.rowId : 'recordid',
                columnDefs: this.columnDefs,

                select: this.tableOptions.select ? this.tableOptions.select : false,
                processing: this.tableOptions.hideProcessing ? false : true,

                paging: this.tableOptions?.paging === false ? false : true,
                scroller: this.tableOptions?.paging === false ? null : this.tableOptions?.displayBuffer ? { displayBuffer: this.tableOptions.displayBuffer } : { displayBuffer: 12 },
                scrollY: this.tableOptions.scrollY ? this.tableOptions.scrollY : '67vh',
                scrollX: true,
                scrollCollapse: false,

                stripeClasses: [],

                language: {
                    emptyTable: this.tableOptions.hideProcessing ? "" : emptyTable,
                    processing: this.tableOptions.hideProcessing ? "" : "<p>Loading " + this.title + "...</p>",
                    zeroRecords: "No " + _this.plural + " found",
                    loadingRecords: "",
                },                
                ajax: {
                    url: this.url,
                    type: "POST",
                    data: (data)  => {
                        data.matterId = this.matterId;
                        data.partyId = this.partyId;
                        data.where = this.where;
                        data.whereIn = this.whereIn;
                        data.whereRaw = this.whereRaw || this.tableFilter;
                        data.whereNull = this.whereNull;
                        data.whereNotNull = this.whereNotNull;
                        data.select = this.select;
                        data.selectraw = this.selectraw;
                        data.taggingEmployeeId = this.tagTableFlag ? root.loggedInEmployeeId : null;
                        data.taggingTableName = this.tagTableFlag ? this.tableName : null;
                    }
                },

                createdRow: ( row, data ) => {

                    if ( typeof _this.tableOptions.createdRow === 'function' ) _this.tableOptions.createdRow(row, data);

                    if ( this.tagTableFlag ) {

                        if ( data.tagged == '1' ) {

                            $(row).addClass('selected');

                        }

                    }

                },

                initComplete: function(settings) {

                    let tableId = $(this)[0].id;
                    var api = this.api();

                    // Resizing
                    $('#' + tableId + '_wrapper .dataTables_scrollHead thead th').resizable({
                        handles: "e",
                        alsoResize: '#' + tableId + '_wrapper .dataTables_scrollHead table',
                        stop: function() {
                            _this.saveColumnSettings();
                            _this.loadDataTable();
                        }
                    });

                    //Add the column index to the headers
                    $.each( settings.aoColumns, function (i, column) {
                        $(column.nTh).attr('data-column-index', i);
                    });

                    // Right click on table header
                    // 20 Oct 2020 - Taken out. Not sure if this is needed and looks overly complex (for now)
                    // $('#' + tableId + '_wrapper .dataTables_scrollHead thead th:not(.sorting_disabled)').bind( "contextmenu", function(e) {

                    //     e.preventDefault();

                    //     let idx = parseInt( $(e.target).attr('data-column-index'), 10 );

                    //     let tableFilters = getTableFilter(_this.tableId);

                    //     let tableColumn = _this.columnDefs[idx];

                    //     tableColumn.index = tableFilters.length;
                    //     tableColumn.method = 'Equals';
                    //     tableColumn.join = 'or';

                    //     _this.$root.columnFilterForm.openModal(true, _this.tableId, _this.columnDefs, tableColumn);


                    // });

                    _this.settings = settings;

                    if ( _this.searchInputFocus ) {

                        setTimeout(() => $('#' + tableId + '-datatables-search-for').focus());

                    }

                    if ( typeof callback === 'function') callback();

                    if ( typeof _this.tableOptions.initComplete === 'function' ) _this.tableOptions.initComplete(settings, tableId, api);

                    _this.defaultInitComplete(settings, tableId, api);

                    _this.setFilterDropDown();


                },

                drawCallback: function() {

                    const tableId = $(this)[0].id;
        
                    const api = this.api();

                    const json = api.ajax.json();

                    _this.recordsFiltered = 0;
                    _this.recordsTotal = 0;

                    if ( json && json.recordsTotal > 0 ) {

                        _this.recordsFiltered = json.recordsFiltered;
                        _this.recordsTotal = json.recordsTotal;

                        if ( json.recordsFiltered !== json.recordsTotal ) {
                        
                            $( '#' + tableId + '-footer-records').html('Showing: <strong>' + json.recordsFiltered + ' of ' + json.recordsTotal + '</strong>');
            
                        } else {
            
                            $( '#' + tableId + '-footer-records').html(_this.plural + ': <strong>' + json.recordsTotal + '</strong>');
            
                        }
            
                    } else {

                        $( '#' + tableId + '-footer-records').html('');

                    }
            
                    if ( typeof _this.tableOptions.drawCallback === 'function' ) _this.tableOptions.drawCallback(tableId, api);
                    
                    _this.defaultDrawCallback(tableId, api);

                },

                footerCallback: function(tfoot, data, start, end, display) {
                    
                    const tableId = $(this)[0].id;
        
                    const api = this.api();

                    if ( typeof _this.tableOptions.footerCallback === 'function' ) _this.tableOptions.footerCallback(tableId, api, tfoot, data, start, end, display);
                    

                },

            });

            this.customOrder = [];

            return thisTable;

        },

        setTableHeight() {

            const $thisTable = $('#' + this.tableId);
            
            let $thisContainer = null;

            if ( typeof this.tableOptions.tableContainer === 'undefined' ) {
            
                this.tableOptions.tableContainer = '.card-body';

                $thisContainer = $thisTable.closest(this.tableOptions.tableContainer);

                if ( !$thisContainer.length ) {

                    this.tableOptions.tableContainer = '.modal-body';

                    $thisContainer = $thisTable.closest(this.tableOptions.tableContainer);

                }

            } else {

                //$thisContainer = $thisTable.closest(this.tableOptions.tableContainer);
                $thisContainer = this.tableOptions.tableContainer;

            }

            if ( !$thisContainer.length ) {
                console.error('No table container found for ' + this.tableId);
                return;
            }

                
            if ( typeof this.tableOptions.tableBottom === 'undefined' ) {
                this.tableOptions.tableBottom = 55;
            }

            const thisContainerHeight = Math.round( $thisContainer.outerHeight() );

            let thisTableHeight = 0;

            if ( !thisContainerHeight ) {

                console.error('No ContainerHeight for ' + this.tableId,'Possible duplicate table id or table is not visible yet?');

            } else {

                const tableOffset = Math.round(  $thisTable.offset().top - $thisContainer.offset().top );
    
                thisTableHeight = thisContainerHeight - tableOffset;
    
                thisTableHeight -= this.tableOptions.tableBottom;
            }


            thisTableHeight = thisTableHeight < 150 ? 150 : thisTableHeight;
            
            this.tableOptions.scrollY = thisTableHeight + 'px';

            return this.tableOptions.scrollY; // Return it in case it is called as a function

        },

        destroyTable() {

            //https://stackoverflow.com/questions/32713612/jquery-datatables-destroy-re-create

            if ( $('#' + this.tableId + ' tbody').length ) {

                $('#' + this.tableId).DataTable().destroy();

                let $footer = $('#' + this.tableId + ' tfoot').clone();

                $('#' + this.tableId).empty(); 

                if ( $footer.length ) $('#' + this.tableId).append( $footer);

            }

        },

        setFilterDropDown() {

            if ( this.filterOptions ) {

                if ( this.filterOptions.myRecordsFilterFlag ) {

                    let myRecordsFilter = this.filterOptions.getQuickFilter('MyRecordsQuickFilter');

                    this.filterOptions.myRecordsSelected = myRecordsFilter ? '1' : '0';

                }

                if ( this.filterOptions.periodFilterFlag ) {

                    let periodFilter = this.filterOptions.getQuickFilter('PeriodQuickFilter');
    
                    this.filterOptions.periodSelected = periodFilter ? periodFilter.settings.value : 'All';

                }

                if ( this.filterOptions.customSelectFilterFlag ) {

                    let customSelectFilter = this.filterOptions.getQuickFilter('CustomSelectQuickFilter');

                    this.filterOptions.customSelected = customSelectFilter ? customSelectFilter.settings.value : 'All';
                }

                if ( this.filterOptions.custom1SelectFilterFlag ) {

                    let custom1SelectFilter = this.filterOptions.getQuickFilter('Custom1SelectQuickFilter');

                    this.filterOptions.custom1Selected = custom1SelectFilter ? custom1SelectFilter.settings.value : 'All';

                }

                if ( this.filterOptions.customRadioButtonFilterFlag ) {

                    let customRadioButtonFilter = this.filterOptions.getQuickFilter('CustomRadioButtonQuickFilter');

                    this.filterOptions.customRadioButtonValue = customRadioButtonFilter ? customRadioButtonFilter.settings.value : 'All';

                }
            } 

        },

        setUserFilters() {

            this.tableFilter = this.tableFilterDescription = this.tableFilterTitle = '';

            let tableFilterDescriptionJoin, columnFilterJoin, dateRange, toDate, fromDate;

            let tableFilters = getTableFilter(this.tableId);

            tableFilters = _.sortBy(tableFilters, function(tableFilter) { return tableFilter.index; })

            let normalFilterCounter = 0;
            let calculatedFilterCounter = 0;
            let filterCounter = 0;

            
            tableFilters.forEach( ( tableFilter ) => {

                tableFilterDescriptionJoin = !filterCounter  ? '' : ' ' + tableFilter.join + ' ';

                this.tableFilterDescription += tableFilterDescriptionJoin;

                filterCounter++;

                if ( !tableFilter.calculatedColumn ) {

                    columnFilterJoin = !normalFilterCounter && !calculatedFilterCounter ? '' : ' ' + tableFilter.join + ' ';

                    normalFilterCounter++;

                    if ( tableFilter.filterType === 'Custom SQL Filter' ) {

                        console.error('Custom SQL Filter has no calculatedColumn');

                    } else if ( tableFilter.filterType === 'String' ) {

                        if ( tableFilter.method === 'Starts with' ) {

                            this.tableFilter += columnFilterJoin + tableFilter.name + " like '" + tableFilter.value + "%'";

                        } else if ( tableFilter.method === 'Contains' ) {

                            this.tableFilter += columnFilterJoin + tableFilter.name + " like '%" + tableFilter.value + "%'";

                        } else if ( tableFilter.method === 'Equals' ) {

                            this.tableFilter += columnFilterJoin + tableFilter.name + " = '" + tableFilter.value + "'";

                        }

                    } else if ( tableFilter.filterType === 'Boolean' ) {

                        this.tableFilter += columnFilterJoin + tableFilter.name + ' = ' + tableFilter.value;

                    } else if ( tableFilter.filterType === 'Lookup' || tableFilter.filterType === 'Dropdown' || tableFilter.filterType === 'RadioButton') {

                        this.tableFilter += columnFilterJoin + tableFilter.name + " = '" + tableFilter.value + "'";

                    } else if ( tableFilter.filterType === 'Date' ) {

                        if ( tableFilter.period === 'Custom' ) {

                            fromDate = moment(tableFilter.fromDate).format('YYYY-MM-DD');
                            toDate = moment(tableFilter.toDate).add(1,'days').format('YYYY-MM-DD');

                        } else {

                            dateRange = this.$root.getDateRange(tableFilter.period);

                            fromDate = moment(dateRange.fromDate).format('YYYY-MM-DD');
                            toDate = moment(dateRange.toDate).add(1,'days').format('YYYY-MM-DD');

                        }

                        let castDate = 'CAST(' + tableFilter.name + '-36163 as DateTime)';

                        this.tableFilter += columnFilterJoin + '(' + castDate + " >= '" + fromDate + "' and " + castDate + " < '" + toDate + "')";
                        
                    } else if ( tableFilter.filterType === 'Number' ) {

                        if ( tableFilter.method === 'Between' ) {

                            this.tableFilter += columnFilterJoin + '(' + tableFilter.name + ' >= ' + tableFilter.fromAmount + ' and ' + tableFilter.name + ' <= ' + tableFilter.toAmount + ')';

                        } else if ( tableFilter.method === 'Equal to' ) {

                            this.tableFilter += columnFilterJoin + '(' + tableFilter.name + ' = ' + tableFilter.fromAmount + ')';

                        } else if ( tableFilter.method === 'Not equal to' ) {

                            this.tableFilter += columnFilterJoin + '(' + tableFilter.name + ' <> ' + tableFilter.fromAmount + ')';

                        } else if ( tableFilter.method === 'Less than' ) {

                            this.tableFilter += columnFilterJoin + '(' + tableFilter.name + ' < ' + tableFilter.fromAmount + ')';

                        } else if ( tableFilter.method === 'Less than or equal to' ) {

                            this.tableFilter += columnFilterJoin + '(' + tableFilter.name + ' <= ' + tableFilter.fromAmount + ')';

                        } else if ( tableFilter.method === 'Greater than' ) {

                            this.tableFilter += columnFilterJoin + '(' + tableFilter.name + ' > ' + tableFilter.fromAmount + ')';

                        } else if ( tableFilter.method === 'Greater than or equal to' ) {

                            this.tableFilter += columnFilterJoin + '(' + tableFilter.name + ' >= ' + tableFilter.fromAmount + ')';

                        }

                    } else {

                        this.tableFilter += columnFilterJoin + ' 1 = 1';
                        console.error('Unknown tableFilter.filterType', tableFilter.filterType);
                    }

                } else if ( tableFilter.calculatedColumn ) {

                    tableFilter.calculatedColumn = tableFilter.calculatedColumn.replaceAll('{value}',tableFilter.value);

                    columnFilterJoin = !normalFilterCounter && !calculatedFilterCounter ? '' : ' ' + tableFilter.join + ' ';

                    calculatedFilterCounter++;

                    if ( tableFilter.filterType === 'Custom SQL Filter' ) {

                        this.tableFilterTitle = tableFilter.calculatedColumn;

                        this.tableFilter += columnFilterJoin + '(' + tableFilter.calculatedColumn + ')';

                    } else if ( tableFilter.filterType === 'Number' ) {

                        if ( tableFilter.method === 'Between' ) {

                            this.tableFilter += columnFilterJoin + '(' + tableFilter.calculatedColumn + ' >= ' + tableFilter.fromAmount + ' and ' + tableFilter.calculatedColumn + ' <= ' + tableFilter.toAmount + ')';

                        } else if ( tableFilter.method === 'Equal to' ) {

                            this.tableFilter += columnFilterJoin + tableFilter.calculatedColumn + ' = ' + tableFilter.fromAmount;

                        } else if ( tableFilter.method === 'Not equal to' ) {

                            this.tableFilter += columnFilterJoin + tableFilter.calculatedColumn + ' <> ' + tableFilter.fromAmount;

                        } else if ( tableFilter.method === 'Less than' ) {

                            this.tableFilter += columnFilterJoin + tableFilter.calculatedColumn + ' < ' + tableFilter.fromAmount;

                        } else if ( tableFilter.method === 'Less than or equal to' ) {

                            this.tableFilter += columnFilterJoin + tableFilter.calculatedColumn + ' <= ' + tableFilter.fromAmount;

                        } else if ( tableFilter.method === 'Greater than' ) {

                            this.tableFilter += columnFilterJoin + tableFilter.calculatedColumn + ' > ' + tableFilter.fromAmount;

                        } else if ( tableFilter.method === 'Greater than or equal to' ) {

                            this.tableFilter += columnFilterJoin + tableFilter.calculatedColumn + ' >= ' + tableFilter.fromAmount;

                        }

                    } else if ( tableFilter.filterType === 'Lookup' || tableFilter.filterType === 'Dropdown' || tableFilter.filterType === 'RadioButton') {

                        if ( isNumeric(tableFilter.value) ) {
                            this.tableFilter += columnFilterJoin + tableFilter.calculatedColumn + " = " + tableFilter.value;
                        } else {
                            this.tableFilter += columnFilterJoin + tableFilter.calculatedColumn + " = '" + tableFilter.value + "'";
                        }

                    } else if ( tableFilter.filterType === 'Boolean') {

                        this.tableFilter += columnFilterJoin + tableFilter.calculatedColumn + ' = ' + tableFilter.value;

                    } else {

                        this.tableFilter += columnFilterJoin + ' 1 = 1';
                        console.error('Unknown tableFilter.filterType', tableFilter.filterType);
                    }

                }

                this.tableFilterDescription += getFilterDescription(tableFilter);

            });

            if ( this.tableFilter ) this.tableFilter = '(' + this.tableFilter + ')';

        },

        setUserColumnDefs() {

            let userColumnDef;
            const userColumnDefs = getTableLayout(this.tableId);

            if (userColumnDefs.length === 0 ) return;

            this.columnDefs.forEach(columnDef => {

                userColumnDef = userColumnDefs.find(column => column.targets === columnDef.targets);

                if ( typeof userColumnDef !== 'undefined' ) {

                    columnDef.width = userColumnDef.width + 'px';
                    columnDef.visible = userColumnDef.visible;

                }

            });

        },

        saveColumnSettings() {
            
            let userColumnDefs = getTableLayout(this.tableId);

            let _this = this, width, visible, header, existingSetting, columnDef;
            let $bodyTable = $('#' + this.tableId);

            this.table.columns().every( function ( targets ) {

                visible = this.visible();

                columnDef = _this.columnDefs.find( columnDef => columnDef.targets === targets);
                
                existingSetting = userColumnDefs.findIndex( column => column.targets === targets);
                
                if ( visible ) {
                    
                    header = this.header();
                    width = $(header).width();
                    
                } else {
                    
                    let columnWidth = columnDef.width ? columnDef.width : '15%';

                    if ( columnWidth.indexOf('%') > 0 ) {

                        width = Math.round($bodyTable.width() * parseInt(columnWidth,10) / 100);
    
                    } else {

                        width = parseInt(columnWidth,10);
                    }

                }

                if ( existingSetting !== -1 ) {

                    userColumnDefs[existingSetting].width = width;
                    userColumnDefs[existingSetting].visible = visible;

                } else {

                    userColumnDefs.push({
                        name: columnDef.name,
                        targets: targets,
                        width:  width,
                        visible: visible,
                    });

                }

            });


            setTableLayout(this.tableId,userColumnDefs);

        },

        createColumnDefs() {

            let columnDefs = this.defineTableColDefs();

            let target = this.tagTableFlag ? 1 : 0;

            target = target + this.leftColumns;

            if ( this.formComponent && !this.noEditButtonFlag) {

                let buttonColumnTitle = this.setButtonColumnTitle ? this.setButtonColumnTitle : this.buttonColumnTitle;

                columnDefs.unshift({
                    title: buttonColumnTitle,
                    name: 'action-button',
                    data: null,
                    visible: true,
                    orderable: false,
                    searchable: false,
                    printable: false,
                    targets: target,
                    //width: "8%",
                    width: this.calculateActionColumnWidth(columnDefs) + '%',
                    class: "action-button text-center text-no-ellipse",
                    render: (data) => {


                        let buttonText = this.buttonText;
                        let buttonClass = this.buttonClass;
                        let buttonFunction =  this.setButtonFunction ? this.setButtonFunction : 'editRecord';

                        if ( (typeof data.readOnly !== 'undefined' && data.readOnly == '1') || this.viewTableFlag) { 

                            buttonText = 'View';
                            buttonClass = 'primary';

                        }

                        if ( this.selectTableFlag ) {

                            buttonFunction = 'selectRecord';
                            buttonText = 'Select';
                            buttonClass = 'danger'; 

                        }

                        let objectDescription = data.parentId ? 'sub ' + this.singular : this.singular;

                        buttonText = this.setButtonText ? this.setButtonText : buttonText;


                        buttonClass = this.setButtonClass ? this.setButtonClass : buttonClass;


                        if ( this.tableOptions.actionButtonClassFunction ) {
                            buttonClass = this.tableOptions.actionButtonClassFunction(data);
                        }


                        if ( this.tableOptions.displayActionButtonFunction ) {
                            if ( !this.tableOptions.displayActionButtonFunction(data) ) buttonClass += ' d-none';
                        }

                        if ( this.tableOptions.actionButtonTextFunction ) {
                            buttonText = this.tableOptions.actionButtonTextFunction(data);
                        }

                        let buttonTitle = this.buttonTitle ? this.buttonTitle : buttonText + ' this ' + objectDescription;

                        buttonTitle = this.setButtonTitle ? this.setButtonTitle : buttonTitle;


                        if ( this.buttonAdditionalParameter ) {

                            return '<div class="badge badge-' + buttonClass + ' action-button-badge" title="' + buttonTitle + '" onclick="' + buttonFunction + '(\'' + this.formComponent + '\',\'' + data[this.editButtonRecordId] +  '\',\'' + this.buttonAdditionalParameter + '\')">' + buttonText + '</div>';

                        } else if ( this.buttonAdditionalDataParameter) {

                            return '<div class="badge badge-' + buttonClass + ' action-button-badge" title="' + buttonTitle + '" onclick="' + buttonFunction + '(\'' + this.formComponent + '\',\'' + data[this.editButtonRecordId] +  '\',\'' + data[this.buttonAdditionalDataParameter] + '\')">' + buttonText + '</div>';

                        } else {

                            return '<div class="badge badge-' + buttonClass + ' action-button-badge" title="' + buttonTitle + '" onclick="' + buttonFunction + '(\'' + this.formComponent + '\',\'' + data[this.editButtonRecordId] + '\')">' + buttonText + '</div>';

                        }


                    }

                });

            }

            if ( this.tagTableFlag ) {

                columnDefs.unshift({
                    title: "",
                    name: 'tag-row',
                    class: "select-checkbox text-center text-no-ellipse",
                    data: null,
                    visible: true,
                    orderable: false,
                    searchable: false,
                    printable: false,
                    targets: 0,
                    width: "5%",
                    render: function (data) {
                        return '';
                    }
                });

            }

            return columnDefs;
        },

        calculateActionColumnWidth(columnDefs) {

            if (this.actionColumnWidth ) return this.actionColumnWidth;

            //return 10; //3 Mar 2021 - This seems to be the best default

            let actionColumnWidth = 10;

            if (root.screenNarrow) {
                actionColumnWidth = 10;
            }

            if (columnDefs.length < 5) {

                actionColumnWidth = (this.selectTableFlag || this.setButtonText === 'Select') ? 20 : 15;

            } else if (columnDefs.length === 5) {

                actionColumnWidth = (this.selectTableFlag || this.setButtonText === 'Select') ? 15 : 15;

            }   
            
            return actionColumnWidth;

        },

        defaultInitComplete(settings, tableId, api) {

            let _this = this;
            
            if ( this.tagTableFlag ) {

                api.table().off('user-select').on('user-select', (e, dt, type, cell, originalEvent) => {

                    let rowId = $(originalEvent.target).parent().attr('id');

                    if (this.$parent.selectedRows.includes(rowId)) {

                        this.toggleTaggedRow('remove', rowId);

                    } else {

                        this.toggleTaggedRow('add', rowId);

                    }

                });    

                $('#' + tableId + '_wrapper .dataTables_scrollHead thead th.select-checkbox').prop('title', 'Tag/UnTag All').on('click', () => {

                    //Return if no data in the table
                    if ( !$('#' + this.tableId).DataTable().rows().any() ) return;

                    _this.toggleTaggedRows(_this.$parent);

                });

            }

        },

        toggleTaggedRows( component ) {

            if ( component.selectedRows.length ) {

                clearTagged( component );

            } else {    

                this.table.rows().select();

                axios.post( '/utils/call/tagAll', {
                    tableName: this.tableName,
                    employeeId: root.loggedInEmployeeId,
                    whereRaw: this.whereRaw || this.tableFilter
                })
                .then(response => {
                    
                    if (response.data.errors) {

                        showError('Error', response.data.errors); 

                    } else {

                        component.selectedRows = response.data.data;

                    }

                }).catch( (error) => {
                    showError('Error tagging All', error); 
                });

            }

        },


        toggleTaggedRow( action, rowId ) {

            if ( action == 'add') {

                axios.post( '/utils/call/addTagged', {
                    tableName: this.tableName,
                    employeeId: root.loggedInEmployeeId,
                    taggedId: rowId
                })
                .then(response => {
                    
                    if (response.data.errors) {
                        showError('Error', response.data.errors); 
                    } else {
                        this.$parent.selectedRows.push('' + rowId);
                    }
    
                }).catch( (error) => {
                    showError('Error tagging table row', error); 
                });
    

            } else if ( action == 'remove') {

                axios.post( '/utils/deleteTagged', {
                    tableName: this.tableName,
                    employeeId: root.loggedInEmployeeId,
                    taggedId: rowId
                })
                .then(response => {
                    
                    if (response.data.errors) {
                        showError('Error', response.data.errors); 
                    } else {

                        this.$parent.selectedRows.remove(rowId);

                        this.table.row('#' + rowId).deselect();

                        if (this.displayingTaggedRecordsFlag ) {

                            // If we are displaying Tagged Records and untagging the last one
                            // Reload the table
                            if ( this.table.data().count() == 1 ) {

                                this.displayingTaggedRecordsFlag = false;

                                this.whereRaw = this.savedWhereRaw;
                    
                                this.table.ajax.reload();

                            } else {


                                // Remove from DataTable
                                this.table.row('#' + rowId).remove();

                                // Remove from HTML table
                                $('#' + this.tableId + ' tbody tr#' + rowId).remove();


                            }

                        }

                    }
    
                }).catch( (error) => {
                    showError('Error untagging table row', error); 
                });


            }

        },

        getTagged() {

            return new Promise((resolve, reject) => {

                axios.post( '/utils/call/getTagged', {
                    tableName: this.tableName,
                    employeeId: root.loggedInEmployeeId
                })
                
                .then(response => {

                    if (response.data.errors) {

                        reject(response.data.errors);

                    } else {

                        resolve( response.data.data);

                    }

                }).catch( (error) => {
                    reject('Error getting Tagged records: ' + error ); 
                });

            });

        },

        defaultDrawCallback(tableId, api) {

            this.dataChanged = true; // Can be used by parent components

            // Handle errors returned from API
            if ( typeof api.ajax.json().errors !== 'undefined' ) {

                if ( appEnvironment == 'local') {

                    showError( 'Datatables Error', '<h3>The following error was encountered:</h3>' + api.ajax.json().errors, 'modal-lg');
    
                } else {
    
                    console.error( 'Datatables Error', api.ajax.json().errors);
    
                }

            }

            
            // Highlight search
            if ($("#" + tableId + "-datatables-search-for").length) { 
        
                let body = $(api.table().body());

                if (typeof body.unhighlight === 'function') {

                    body.unhighlight();
        
                    var searchFor = $("#" + tableId + "-datatables-search-for").val();
        
                    if (searchFor) {
            
                        body.highlight(searchFor);
                        body.highlight(searchFor.toLowerCase());
                        body.highlight(searchFor.toUpperCase());

                    }

                }
            }

        },

        refreshRow(id) {

            axios.post(this.url + '/' + id)

            .then(response => {

                if (response.data.errors) { 

                    showError( 'Error Refreshing Row', response.data.errors);

                } else {

                    this.table.row('#' + id).data( response.data.data[0] ).draw();

                    setTimeout(() => { this.highlightRow(id); },1000);

                }    

            }).catch( (error) => {
                showError('Error Refreshing Row', error); 
            });

        },

        jumpToRow(rowId, tablePosition) {

            //console.log("jumpToRow",rowId, tablePosition);

            if ( $('#' + this.tableId).length === 0 ) return; // In case the global form has a table set by SelectMatter for example
            
            this.selectedId = rowId; // Use this to highlight the row in the createdRow callback

            let position = parseInt(tablePosition) - 2;

            if ( position < 0 ) position = 0;

            this.table.order( this.initialOrder ).ajax.reload( () => {

                this.table.scroller.toPosition( parseInt(position), false );

                setTimeout(() => { this.highlightRow(rowId); },1000);

            });

        },


        highlightRow(id) {

            if ( $('#' + this.tableId).length === 0 ) return; // In case the global form has a table set by SelectMatter for example

            this.unHighlightAllRows();

            if ( !$('#' + this.tableId + ' tbody tr#' + id).length ) {

                setTimeout(() => { 

                    if ( !$('#' + this.tableId + ' tbody tr#' + id).length ) {

                        setTimeout(() => { 
                            $('#' + this.tableId + ' tbody tr#' + id).addClass('highlighted');    
                        },2000);
        
                    } else {
        
                        $('#' + this.tableId + ' tbody tr#' + id).addClass('highlighted');
                    }

                }, 2000);

            } else {

                $('#' + this.tableId + ' tbody tr#' + id).addClass('highlighted');
            }

        },
        
        unHighlightAllRows() {

            if ( $('#' + this.tableId).length === 0 ) return; // In case the global form has a table set by SelectMatter for example

            $('#' + this.tableId + ' tbody tr.highlighted').removeClass('highlighted');
        
        },

        async createReportTemplateData() {

            const templateData = root.initTemplateData();

            templateData.report = {
                title: this.title,
                subTitle: this.subTitle,
                date: moment().format(root.control.dateformat + ' HH:mm:ss'),
            };

            templateData.report.columns = [];

            for (let index = 0; index < this.columnDefs.length; index++) {

                if ( this.columnDefs[index].printable !== false && this.columnDefs[index].visible !== false )  {
                    
                    templateData.report.columns.push(this.columnDefs[index]);
                }
                    
            };

            let tableOrder = this.table.order();

            let orderByColumnIndex = tableOrder[0][0];

            let orderByDirection = tableOrder[0][1];

            let orderByColumnName = this.columnDefs[orderByColumnIndex].name;

            const params = {

                where: this.where,
                whereIn: this.whereIn,
                whereNull: this.whereNull,
                whereNotNull: this.whereNotNull,
                selectraw: this.selectraw,
                whereRaw: this.whereRaw || this.tableFilter,
                taggingEmployeeId: this.tagTableFlag ? root.loggedInEmployeeId : null,
                taggingTableName: this.tagTableFlag ? this.tableName : null,

                orderBy: [orderByColumnName + ',' + orderByDirection],

            }

            // Handle any column filters (e.g. in Matters and Parties tables)
            const _this = this;
            let columnWhereClause = '';
            
            this.table.columns().every( function () {
                if (this.search()) {
                    columnWhereClause = _this.columnDefs[this.index()].name + " LIKE '%" + this.search() + "%'";
                }
            });

            if ( columnWhereClause ) {
                if (params.whereRaw) {
                    params.whereRaw = '(' + params.whereRaw + ') AND + (' + columnWhereClause + ')';
                } else {
                    params.whereRaw = columnWhereClause;
                }
            }

            let response = await axios.post(this.url,  params)
            .catch( (error) => {
                showError('Error', error); 
            });

            if (response.data.errors) { 

                showError( 'Error getting Report Template Data', response.data.errors + '<br><br>Url: ' + this.url);

            } else {

                templateData.report.rows = response.data.data;

                if ( this.reportTemplateId == root.lolSettings.debtorsaccounttemplateid  && this.matterId) {

                    let matterResponse = await axios.post('/matter/getTemplateData/' + this.matterId)
                    .catch( (error) => {
                        showError('Error', error); 
                    });

                    templateData.matter = matterResponse.data.matter;

                }

            }

            return templateData;

        },
        
        refresh() {

            if ( this.table ) this.table.ajax.reload();

        },

    },

}