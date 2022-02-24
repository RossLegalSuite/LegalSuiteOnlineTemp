<template>
<section>

    <div class="modal" :id="id">

        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content red-border">

                <div class="modal-header red-bg">
                    <h2 class="modal-title"><i class="fa fa-server mr-2"></i>Table Layout</h2>
                    <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                </div>

                <div class="modal-body p-3" style="max-height: 75vh; min-height: 50vh; overflow-y: auto;">

                    <table :id="id + '-table'" class="table bordered" style="table-layout: auto; width:100%"></table>

                </div>

                <div class="modal-footer justify-content-between">
                    <div>
                        <button class="btn btn-secondary form-button mr-2" type="button" @click="defaultLayout" title="Reset the columns to the original program settings"><i class="fa fa-history fa-lg mr-2"></i>Default</button>
                        <button class="btn btn-warning form-button mr-2" type="button" @click="fitLayout" title="Adjust the columns to fit the width of the table"><i class="fa fa-exchange fa-lg mr-2"></i>Auto Fit</button> 
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
            value: 50,
            tableComponent: null,
            tableId: null,
            tableColumns: [],
        }
    },


    methods: {

        defaultLayout() {
            
            removeTableLayout(this.tableId);

            this.tableComponent.loadDataTable( this.displayColumns );

            this.close();

        },

        fitLayout() {

            let remainingColumns = 0, remainingPercent = 0, userColumnDef, thisColumn, percent, padding, totalPercent = 0, totalWidth = 0, totalNewTotalWidth = 0,$header;

            const currentTableWidth = $('#' + this.tableId).width();
            const targetTableWidth = Math.round( $('#' + this.tableId + '_wrapper .dataTables_scroll').width() ) - 2;
            
            //console.log('tableWidths current/target',currentTableWidth,targetTableWidth);
            
            let columnDimensions = [], columnIndex = -1;
            
            let userColumnDefs = getTableLayout(this.tableId);

            // Set the Tag Row to 5%
            thisColumn = this.tableComponent.columnDefs.find( columnDef => columnDef.name === 'tag-row');

            if ( thisColumn && thisColumn.visible ) {

                userColumnDef = userColumnDefs.find( column => column.targets === thisColumn.targets);

                if ( userColumnDef ) {

                        $header = $( this.tableComponent.table.column(thisColumn.targets).header() );

                        percent = 5;
                        padding = $header.outerWidth() - $header.width();
                        userColumnDef.width = Math.round((targetTableWidth * percent / 100) - padding);

                        totalPercent += percent

                }

            }

            // Set the Action Button Width
            thisColumn = this.tableComponent.columnDefs.find( columnDef => columnDef.name === 'action-button');

            if ( thisColumn && thisColumn.visible ) {

                userColumnDef = userColumnDefs.find( column => column.targets === thisColumn.targets);

                if ( userColumnDef ) {

                        $header = $( this.tableComponent.table.column(thisColumn.targets).header() );

                        //percent = 8;
                        percent = this.tableComponent.calculateActionColumnWidth(this.tableComponent.columnDefs);
                        padding = $header.outerWidth() - $header.width();
                        userColumnDef.width = Math.round((targetTableWidth * percent / 100) - padding);

                        totalPercent += percent

                }

            }

            this.tableComponent.columnDefs.forEach( columnDef => {

                if ( columnDef.name !== 'tag-row' && columnDef.name !== 'action-button' && columnDef.name !== 'toggle-child' ) {

                    userColumnDef = userColumnDefs.find( column => column.targets === columnDef.targets);

                    if ( userColumnDef && userColumnDef.visible ) remainingColumns++;
                }

            });

            // Do the remaining Columns
            remainingPercent = Math.round((100 - totalPercent) / remainingColumns) - 1;

            //console.log('remainingColumns',remainingColumns);
            //console.log('remainingPercent',remainingPercent);

            this.tableComponent.columnDefs.forEach( columnDef => {

                if ( columnDef.name !== 'tag-row' && columnDef.name !== 'action-button'  && columnDef.name !== 'toggle-child' ) {

                    userColumnDef = userColumnDefs.find( column => column.targets === columnDef.targets);

                    if ( userColumnDef && userColumnDef.visible ) {

                        $header = $( this.tableComponent.table.column(columnDef.targets).header() );

                        percent = remainingPercent;
                        padding = $header.outerWidth() - $header.width();
                        userColumnDef.width = Math.round((targetTableWidth * percent / 100) - padding);

                        totalPercent += percent

                    }

                }

            });

            //console.log('totalPercent',totalPercent);

            setTableLayout(this.tableId,userColumnDefs);

            this.tableComponent.loadDataTable();

            this.close();

        },

 
        openModal(tableId, tableComponent) {

            this.tableId = tableId;
            this.tableComponent = tableComponent;

            this.show();

            this.displayColumns();

        },

        async displayColumns() {

            await this.tableComponent.saveColumnSettings();

            let tableOrder = this.tableComponent.table.order();

            let orderByColumnIndex = tableOrder[0][0];

            let orderByDirection = tableOrder[0][1];
            
            this.tableColumns = [];

            let _this = this, visible, width, title, target, $tableColumn, existingSetting;

            let userColumnDefs = getTableLayout(this.tableId);

            this.tableComponent.columnDefs.forEach( (columnDef, index) => {

                existingSetting = userColumnDefs.findIndex( column => column.targets === columnDef.targets);

                if ( existingSetting !== -1 ) {

                    width = parseInt(userColumnDefs[existingSetting].width,10);
                    visible = userColumnDefs[existingSetting].visible;
                }

                if ( columnDef.name === 'tag-row' ) {
                    title = 'Tag';
                } else if ( columnDef.name === 'action-button' ) {
                    title = 'Action';
                } else if ( columnDef.name === 'toggle-child' ) {
                    title = 'Toggle';
                } else {
                    title = columnDef.title;
                }

                this.tableColumns.push({
                    name: columnDef.name,
                    targets: columnDef.targets,
                    orderByColumnIndex: orderByColumnIndex,
                    orderByDirection: orderByDirection,
                    index: index,
                    title: title,
                    width: width,
                    visible: visible,
                    checked: visible ? 'checked' : '',
                });

            });

            $('#' + this.id + '-table').DataTable({
                destroy: true,
                dom: "t",
                data: _this.tableColumns,
                serverSide: false,
                paging: false,
                select: false,
                scrollX: false,
                responsive: false,
                scrollY: false,
                scroller: false,
                rowId: "index",
                ordering: true,
                order: [[0, "asc"]],
                columnDefs: [
                    {
                        title: "",
                        data: null,
                        targets: 0,
                        visible: false,
                        render: function (data) {
                            return data.index;
                        }
                    },
                    {
                        title: "Display",
                        data: null,
                        class: "text-center",
                        width: "15%",
                        orderable: false,
                        targets: 1,
                        render: function (data) {
                            return '<input tabindex="-1" onclick="componentFunction(\'tableLayoutModal\',\'toggleColumn\',' + data.targets + ')" type="checkbox" title ="Toggle (Hide/Display) this column" id="visible-checkbox-' + data.targets + '" ' + data.checked + '>';
                        }
                    },
                    {
                        title: "Column",
                        data: null,
                        orderable: false,
                        width: "55%",
                        targets: 2,
                        render: function (data) {
                            if ( data.orderByColumnIndex === data.targets) {

                                return data.title + (data.orderByDirection === 'asc' ? '<i class="fa fa-lg fa-toggle-up ml-2" title="Sorted by this column in ascending order"></i>' : '<i class="fa fa-lg fa-toggle-down ml-2" title="Sorted by this column in descending order"></i>');

                            } else {

                                return data.title;

                            }
                        }
                    },
                    {
                        title: "Width",
                        data: null,
                        width: "30%",
                        class: "text-center",
                        orderable: false,
                        targets: 3,
                        render: function (data) {
                            let returnValue = '<div class="center-items">';
                            returnValue += '<i title="Decrease the column width by 10%" class="cp fa fa-minus-circle fa-2x text-danger mr-3" onclick="componentFunction(\'tableLayoutModal\',\'adjustColumn\',' + data.targets + ',\'Decrease\')"></i>';
                            returnValue += '<input form-control form-control-sm" onchange="componentFunction(\'tableLayoutModal\',\'resizeColumn\',' + data.targets + ')" type="number" min="0" max="1000" step="10" value="' + data.width + '" title ="Manually set the width of this column in pixels" id="width-input-' + data.targets + '">';
                            returnValue += '<i title="Increase the column width by 10%" class="cp fa fa-plus-circle fa-2x text-success ml-2" onclick="componentFunction(\'tableLayoutModal\',\'adjustColumn\',' + data.targets + ',\'Increase\')"></i>';
                            returnValue += '</div>';
                            return returnValue;
                        }
                    },

                ]
            });



        },

        adjustColumn(targets, method) {

            let value = parseInt($('#width-input-' + targets).val());

            if ( method === 'Increase') {

                value += parseInt(value * 0.2);

            } else if ( method === 'Decrease') {

                value -= parseInt(value * 0.2);

            }

            if ( value < 10 ) value = 10;
            if ( value > 1000 ) value = 1000;

            $('#width-input-' + targets).val( value );

            this.resizeColumn(targets)

        },
        resizeColumn(targets) {

            //console.log('resizeColumn',targets, $('#width-input-' + targets).val());

            let userColumnDefs = getTableLayout(this.tableId);

            let existingSetting = userColumnDefs.findIndex( column  => column.targets === targets);

            if ( existingSetting !== -1 ) {

                userColumnDefs[existingSetting].width = $('#width-input-' + targets).val();

                setTableLayout(this.tableId,userColumnDefs);

                $('#' + this.tableComponent.tableId + ' thead th:eq(' + targets + ')').width(userColumnDefs[existingSetting].width);
                $('#' + this.tableComponent.tableId + '_wrapper .dataTables_scrollHead thead th:eq(' + targets + ')').width(userColumnDefs[existingSetting].width);

                this.tableComponent.columnDefs[targets].width = this.tableComponent.columnDefs[targets].sWidth = $('#width-input-' + targets).val() + 'px';

            }


        },

        toggleColumn(targets) {

            let state;

            let userColumnDefs = getTableLayout(this.tableId);

            let existingSetting = userColumnDefs.findIndex( column  => column.targets === targets);

            if ( existingSetting !== -1 ) {

                state = !userColumnDefs[existingSetting].visible;
                
                userColumnDefs[existingSetting].visible = state;

            } else {

                state = !this.tableComponent.table.column(targets).visible();

                let columnDefWidth = this.tableComponent.columnDefs[targets].width;

                if ( columnDefWidth.indexOf('%') > 0 ) {

                    let $bodyTable = $('#' + this.tableId);

                    columnDefWidth = Math.round($bodyTable.width() * parseInt(columnDefWidth,10) / 100);

                } else {

                    columnDefWidth = parseInt(columnDefWidth,10);

                }

                userColumnDefs.push({
                    name: this.tableComponent.columnDefs[targets].name,
                    targets: targets,
                    width: columnDefWidth,
                    visible: state,
                })

            }

            setTableLayout(this.tableId,userColumnDefs);

            //console.log('toggleColumn userColumnDefs',state, userColumnDefs);

            if ( !state ) {

                this.tableComponent.table.column(targets).visible(state, false);
                this.tableComponent.table.columns.adjust();

            } else {

                //this.tableComponent.table.column(targets).visible(state, false);
                //this.tableComponent.table.columns.adjust();
                this.tableComponent.loadDataTable();

            }

        },


    }

}  
</script>
