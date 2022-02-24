<template>
<section>

    <div class="modal" :id="id">

        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content red-border">

                <div class="modal-header red-bg">
                    <h2 class="modal-title"><i class="fa fa-filter mr-2"></i>Table Filters</h2>
                    <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                </div>

                <div class="modal-body p-3" style="min-height: 35vh; max-height: 75vh; overflow-y: auto;">

                    <div class="text-right mb-2">
                        <pop-over content="<h4>Filtering Data</h4><p>The data in a table can be filtered to display a subset of records.</p>
                            <p>Filters can be defined for one or more columns in a table and each column can have more than one filter applied to it.</p>
                            <p>When using multiple filters, you can use <em>and/or</em> logic to indicate if a filter must be exclusive (or) or inclusive (and).</p>
                            <p>This enables you to create a simple filter to display data for a certain date range, for example, or more complex queries to extract the specific data you require.</p>"
                            :container="'#' + this.id"/>
                        <new-record-button type="button" title="Create a new filter" text="Add a Filter" @newRecordButtonClicked="newRecordButtonClicked"/>

                    </div>


                    <table :id="id + '-table'" class="table bordered" style="table-layout: auto; width:100%"></table>

                </div>

                <div class="modal-footer justify-content-between">
                    <div>
                        <button v-if="displayClearFilterButton" class="btn btn-secondary form-button mr-2" type="button" @click="clearFilters" title="Clear all filter settings"><i class="fa fa-ban fa-lg mr-2"></i>Clear Filters</button>
                    </div>
                    <div>
                        <button class="btn btn-danger form-button shadowed" type="button" data-dismiss="modal" title="Close this window"><i class="fa fa-times-circle fa-lg mr-2"></i>Close</button>
                    </div>
                </div>

            </div>
        </div>

    </div>
</section>
</template>

<script>

import modalTemplate from "../modals/modal-template";

export default {

    mixins: [modalTemplate],

    props: {
        id: String,
    },

    data() {
        return {
            tableComponent: null,
            table: null,
            tableId: null,
            displayClearFilterButton: false,
            tableRows: [],
        }
    },


    methods: {

        openModal(tableId, tableComponent) {

            this.tableId = tableId;
            this.tableComponent = tableComponent;

            this.show();

            this.loadTableFilters();

        },

        loadTableFilters() {

            this.tableRows = [];

            this.displayClearFilterButton = false;

            let _this = this, joinWording;

            let tableFilters = getTableFilter(this.tableId);

            this.displayClearFilterButton = tableFilters.length ? true : false;

            tableFilters.forEach( tableFilter => {

                if ( tableFilter.name !== 'Custom SQL Filter' ) {

                    let columnDef = this.tableComponent.columnDefs.find( column => column.targets === tableFilter.targets);

                    this.tableRows.push({
                        index: tableFilter.index,
                        key: tableFilter.key,
                        name: columnDef.name,
                        targets: columnDef.targets,
                        title: columnDef.title,
                        calculatedColumn: columnDef.calculatedColumn,
                        filterType: columnDef.filterType ? columnDef.filterType : 'String',
                        filterControl: columnDef.filterControl ? columnDef.filterControl : 'Input',
                        filterOptions: columnDef.filterOptions ? columnDef.filterOptions : [],
                        filterTitle: columnDef.filterTitle ? columnDef.filterTitle : columnDef.title,
                        fromAmount: tableFilter.fromAmount,
                        fromDate: tableFilter.fromDate,
                        join: tableFilter.join,
                        method: tableFilter.method,
                        period: tableFilter.period,
                        toAmount: tableFilter.toAmount,
                        toDate: tableFilter.toDate,
                        value: tableFilter.value,
                        description: tableFilter.description,
                    });

                } else {

                    this.tableRows.push({
                        index: tableFilter.index,
                        key: tableFilter.key,
                        name: tableFilter.filterType,
                        targets: tableFilter.filterType,
                        title: tableFilter.filterType,
                        calculatedColumn: tableFilter.calculatedColumn,
                        filterType: tableFilter.filterType,
                        filterTitle: tableFilter.filterTitle,
                        filterControl: tableFilter.filterType,
                        filterOptions: tableFilter.filterType,
                        fromAmount: tableFilter.fromAmount,
                        fromDate: tableFilter.fromDate,
                        join: tableFilter.join,
                        method: tableFilter.method,
                        period: tableFilter.period,
                        toAmount: tableFilter.toAmount,
                        toDate: tableFilter.toDate,
                        value: tableFilter.value,
                        description: tableFilter.description,
                    });

                }

            });

            this.table = $('#' + this.id + '-table').DataTable({
                destroy: true,
                dom: "t",
                data: _this.tableRows,
                serverSide: false,
                paging: false,
                select: false,
                scrollX: true,
                responsive: false,
                scrollY: false,
                scroller: false,
                rowId: "index",
                ordering: true,
                order: [[4, "asc"]],
                language: {emptyTable: "No Filters found" },                
                columnDefs: [
                    {
                        title: "",
                        data: null,
                        class: 'text-center',
                        width: '5%',
                        orderable: false,
                        searchable: false,
                        targets: 0,
                        render: (data) => {
                            return parseInt(data.index) > 0 ? '<span class="cp" title="Move this Filter up" onclick="componentFunction(\'tableFilterSettings\',\'moveFilterUp\',' + data.index + ')">🔼</span>' : '';
                        }
                    },

                    {
                        title: "Action",
                        data: null,
                        class: "text-center",
                        width: "15%",
                        orderable: false,
                        targets: 1,
                        render: function (data) {
                            return '<span class="badge badge-success py-2 px-2" onclick="componentFunction(\'tableFilterSettings\',\'editColumnFilter\',' + data.index + ')"  title ="Modify the Filter settings">Edit</span>';
                        }
                    },
                    {
                        title: "Filter",
                        data: null,
                        width: "50%",
                        orderable: false,
                        targets: 2,
                        render: function (data) { 

                            joinWording = parseInt(data.index) > 0 ? '<strong><em>' + data.join.toUpperCase() + '</em></strong>....' : '';

                            if (data.filterType === 'Custom SQL Filter') {

                                return joinWording + data.calculatedColumn.trim();

                            } else if ( data.description ) {

                                return joinWording + data.description.trim();

                            } else if ( data.filterType === 'String' ) {

                                return joinWording + data.title + ' ' + data.method + ' "' + truncate(data.value,20) + '"';

                            } else if ( data.filterType === 'Boolean' ) {

                                return joinWording + data.title + ' is <strong>' + (data.value == 1 ? 'True' : 'False') + '</strong>';

                            } else if ( data.filterType === 'Lookup' || data.filterType === 'Dropdown' ) {

                                return joinWording + data.title + ' equals <strong>' + data.value + '</strong>';

                            } else if ( data.filterType === 'RadioButton' ) {

                                return joinWording + data.title + ' equals <strong>' + data.value + '</strong>';

                            } else if ( data.filterType === 'Date' ) {

                                if ( data.period === 'Custom' ) {

                                    return joinWording + data.title + ' between <strong>' + moment(data.fromDate).format(root.control.dateformat) + '</strong> and <strong>' + moment(data.toDate).format(root.control.dateformat) + '</strong>';

                                } else {

                                    return joinWording + data.title + ' is <strong>' + data.period.toLowerCase() + '</strong>';

                                }

                            } else if ( data.filterType === 'Number' ) {

                                if ( data.method === 'Between' ) {
                                    
                                    return joinWording + data.title + ' Between <strong>' + data.fromAmount + '</strong> and <strong>' + data.toAmount + '</strong>';

                                } else {

                                    return joinWording + data.title + ' is ' + data.method + ' <strong>' + data.fromAmount + '</strong>';;

                                }

                            } else {

                                return "Unknown filterType - " + data.filterType;

                            }

                        }
                    },
                    {
                        title: "",
                        data: null,
                        class: 'text-center',
                        width: '5%',
                        orderable: false,
                        searchable: false,
                        targets: 3,
                        render: (data) => {
                            return '<i class="fa fa-2x fa-times-circle cp text-danger" title="Remove this Filter" onclick="componentFunction(\'tableFilterSettings\',\'deleteTableFilter\',' + data.index + ',1)"></i>';
                        }
                    },
                    {
                        title: "",
                        data: null,
                        targets: 4,
                        visible: false,
                        render: function (data) {
                            return data.index;
                        }
                    },
                    {
                        title: "",
                        data: null,
                        targets: 5,
                        visible: false,
                        render: function (data) {
                            return data.description;
                        }
                    },
                    {
                        title: "",
                        data: null,
                        targets: 6,
                        visible: false,
                        render: function (data) {
                            return data.calculatedColumn ? data.calculatedColumn : '';
                        }
                    },
                    {
                        title: "",
                        data: null,
                        targets: 7,
                        visible: false,
                        render: function (data) {
                            return data.key;
                        }
                    },
                ]
            });

        },

        clearFilters() {
            
            removeTableFilter(this.tableId);

            this.tableComponent.loadDataTable( this.loadTableFilters );

            this.close();

        },

        newRecordButtonClicked() {

            root.columnFilterForm.openModal(false, this.tableId, this.tableComponent, null);
            
        },

        editColumnFilter(index) {

            let tableRow = this.table.row( '#' + index ).data();

            root.columnFilterForm.openModal(true, this.tableId, this.tableComponent, tableRow );

        },

        moveFilterUp(index) {

            this.tableFilters = getTableFilter(this.tableId);

            //tableFilters = _.sortBy(tableFilters, function(tableFilter) { return tableFilter.index; })

            let tableFilterAboveIndex = this.tableFilters.findIndex( tableFilter => tableFilter.index === index-1);
            let thisTableFilterIndex = this.tableFilters.findIndex( tableFilter => tableFilter.index === index);

            this.tableFilters[tableFilterAboveIndex].index = index;
            this.tableFilters[thisTableFilterIndex].index = index - 1;

            setTableFilter(this.tableId,this.tableFilters);

            this.tableComponent.loadDataTable( this.loadTableFilters );
            
        },

        deleteTableFilter(index, refreshModal = true ) {

            this.tableFilters = getTableFilter(this.tableId);

            this.tableFilters.splice(index,1);

            // If no filters left for this target, delete the filter ( i.e. tidy up)
            if ( this.tableFilters.length ) {

                //Ensure indexes run from zero onwards
                let idx = 0;
                this.tableFilters.forEach(tableFilter => {
                    tableFilter.index = idx;
                    idx++;
                });


                setTableFilter(this.tableId,this.tableFilters);

            } else {

                removeTableFilter(this.tableId);

            }

            if ( refreshModal ) {

                //this.tableComponent.loadDataTable( this.loadTableFilters );

                this.tableComponent.setUserFilters();

                this.tableComponent.table.ajax.reload( this.loadTableFilters );


            }

        },

    }

}  
</script>
