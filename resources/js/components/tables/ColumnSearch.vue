<template>
<div class="datatables-search">
    
    <div class="input-group">

        <input 
            :id="$parent.tableId + '-datatables-search-for'" 
            v-model="searchFor" 
            type="search" 
            :title="setButtonTitle()" 
            :placeholder="setInputPlaceHolder()" 
            class="form-control search-input" 
            v-on:search="searchTable"
        >

        <div class="input-group-append">

            <button :title="setButtonTitle()" v-on:click="searchTable" class="btn btn-success" style="border-right: 2px solid lightgray;">
                <span class="fa fa-search"></span>
            </button>

            <button type="button" title="Specify search criteria" class="btn btn-primary dropdown-toggle dropdown-toggle-split" data-toggle="dropdown"/>

            <div class="dropdown-menu shadowed">
                <div class="text-center"><strong>Search By</strong></div>
                <div role="separator" class="dropdown-divider"></div>

                <div v-for="searchableColumn in searchableColumns" 
                    v-bind:key="searchableColumn.name" 
                    @click="changeSearchColumn(searchableColumn.title)" 
                    class="dropdown-item cp">
                    <span v-if="searchColumn == searchableColumn.title"  class="text-success fa fa-check-circle"></span>
                    <span :class="searchColumn == searchableColumn.title ? 'font-weight-bold':''" v-text="searchableColumn.title"/>
                </div>

                <div class="dropdown-item cp" v-on:click="changeSearchColumn('All Columns')">
                    <span v-if="searchColumn == 'All Columns'" class="text-success fa fa-check-circle"></span>
                    <span :class="searchColumn == 'All Columns' ? 'font-weight-bold':''">All Columns</span>
                </div>
            </div>
        </div>


    </div>


</div>

</template>

<script>

export default {

    props: {
        searchableColumns: {
            type: Array,
            default: function () {
                return []
            },
        },
        initialSearchColumn: String,
    },


    data() {
        return {
            searchFor: null,
            searchColumn: null,
        };
    },

    mounted () {
        this.searchColumn = this.initialSearchColumn;
    },    


    methods: {

        changeSearchColumn(column) {

            this.searchColumn = column;

        }, 

        clearSearch() {

            this.searchFor = null;

            this.clearPreviousSearch( true );

        },

        clearPreviousSearch( reloadFlag = false ) {

            let tableColumn;

            // Clear global search
            $('#' + this.$parent.tableId).DataTable().search('', true, false);

            // Clear columns searches
            this.searchableColumns.forEach(searchableColumn => {

                tableColumn = this.$parent.columnDefs.filter(tableColumn => tableColumn.name === searchableColumn.name)[0];

                if ( tableColumn ) {
                    $('#' + this.$parent.tableId).DataTable()
                    .columns(tableColumn.targets)
                    .search('', false, false);
                } else {
                    showError('Error Clearing Search', 'Search Column (' + searchableColumn.title + ') not found');
                }

            });

            if ( reloadFlag ) {

                $('#' + this.$parent.tableId).DataTable().ajax.reload();
            }

        },

        searchTable() {

            // Datatables bug (Doesn't search for &)
            //https://datatables.net/forums/discussion/53203/searchpane-doesnt-return-results-if-item-contains-an-ampersand

            if (this.searchFor) {

                this.clearPreviousSearch();

                if (this.searchColumn == 'All Columns') {

                    $('#' + this.$parent.tableId).DataTable()
                    .search(this.searchFor, false, true)
                    .ajax.reload();

                } else  {

                    this.searchableColumns.forEach(searchableColumn => {

                        if (this.searchColumn == searchableColumn.title) {

                            let tableColumn = this.$parent.columnDefs.filter(tableColumn => tableColumn.name === searchableColumn.name)[0];

                            if ( tableColumn ) {

                                $('#' + this.$parent.tableId).DataTable()
                                .columns(tableColumn.targets)
                                .search(this.searchFor, false, false)
                                .ajax.reload();

                            } else {
                                showError('Error Applying Search', 'Search Column (' + searchableColumn.name + ') not found');
                            }

                        }

                    });

                }

            } else {

                this.clearPreviousSearch(true);
            }

        },

        setInputPlaceHolder() {

            if (this.searchColumn == 'All Columns') {
                return 'Search all columns...';
            } else {
                return this.searchColumn + '...';
            }

        },

        setButtonTitle() {
            return 'Click here to search by ' + this.searchColumn;
        }

    } 

}  
</script>