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
            <!-- @change="handleInputChanged" -->

        <div class="input-group-append">

            <button :title="setButtonTitle()" v-on:click="searchTable" class="btn btn-success" style="border-right: 2px solid lightgray;">
                <span class="fa fa-search"></span>
            </button>

            <!-- <button title="Clear the search" v-show="searchFor" v-on:click="clearSearch" class="btn btn-danger" style="border-right: 2px solid lightgray;">
                <span class="fa fa-times"></span>
            </button> -->

            <button type="button" title="Specify search criteria" class="btn btn-primary dropdown-toggle dropdown-toggle-split" data-toggle="dropdown"/>

            <div class="dropdown-menu">
                <div class="text-center"><strong>Search By</strong></div>
                <div role="separator" class="dropdown-divider"></div>
                <div class="dropdown-item cp" v-on:click="changeSearchFlag('File Ref')">
                    <span v-if="searchFlag == 'File Ref'" class="text-success fa fa-check-circle"></span>
                    <span>File Ref</span>
                </div>
                <div class="dropdown-item cp" v-on:click="changeSearchFlag('Description')">
                    <span v-if="searchFlag == 'Description'" class="text-success fa fa-check-circle"></span>
                    <span>Description</span>
                </div>
                <div class="dropdown-item cp" v-on:click="changeSearchFlag('All Columns')">
                    <span v-if="searchFlag == 'All Columns'" class="text-success fa fa-check-circle"></span>
                    <span>All Columns</span>
                </div>
            </div>
        </div>


    </div>


</div>

</template>

<script>

export default {

    data() {
        return {
            searchFor: null,
            searchFlag: 'File Ref',
        };
    },

    methods: {

        changeSearchFlag(flag) {

            this.searchFlag = flag;

        }, 

        clearSearch() {

            this.searchFor = null;

            this.clearPreviousSearch( true );

        },

        clearPreviousSearch( reloadFlag = false ) {

            $('#' + this.$parent.tableId).DataTable().search('', true, false);

            let tableColumn = this.$parent.columnDefs.filter(tableColumn => tableColumn.name === 'Matter.FileRef')[0];

            if ( tableColumn ) {
                $('#' + this.$parent.tableId).DataTable()
                .columns(tableColumn.targets)
                .search('', false, false);
            } else {
                showError('Error Clearing Search', 'Search Column (Matter.FileRef) not found');
            }

            tableColumn = this.$parent.columnDefs.filter(tableColumn => tableColumn.name === 'Matter.Description')[0];

            if ( tableColumn ) {
                $('#' + this.$parent.tableId).DataTable()
                .columns(tableColumn.targets)
                .search('', false, false);
            } else {
                showError('Error Clearing Search', 'Search Column (Matter.Description) not found');
            }

            if ( reloadFlag ) {

                $('#' + this.$parent.tableId).DataTable().ajax.reload();
            }

        },

        searchTable() {

            // Datatables bug (Doesn't search for &)
            //https://datatables.net/forums/discussion/53203/searchpane-doesnt-return-results-if-item-contains-an-ampersand

            if (this.searchFor) {

                this.clearPreviousSearch();

                if (this.searchFlag == 'All Columns') {

                    $('#' + this.$parent.tableId).DataTable()
                    .search(regexSearchText, false, true)
                    .ajax.reload();

                } else if (this.searchFlag == 'File Ref') {

                    let tableColumn = this.$parent.columnDefs.filter(tableColumn => tableColumn.name === 'Matter.FileRef')[0];

                    if ( tableColumn ) {

                        $('#' + this.$parent.tableId).DataTable()
                        .columns(tableColumn.targets)
                        .search(this.searchFor, false, false)
                        .ajax.reload();

                    } else {
                        showError('Error Applying Search', 'Search Column (Matter.FileRef) not found');
                    }

                } else if (this.searchFlag == 'Description') {

                    let tableColumn = this.$parent.columnDefs.filter(tableColumn => tableColumn.name === 'Matter.Description')[0];

                    if ( tableColumn ) {

                        $('#' + this.$parent.tableId).DataTable()
                        .columns(tableColumn.targets)
                        .search(this.searchFor, false, false)
                        .ajax.reload();


                    } else {
                        showError('Error Applying Search', 'Search Column (Matter.Description) not found');
                    }

                }

            } else {

                this.clearPreviousSearch(true);
            }

        },

        // handleInputChanged(e) {

        //     console.log("handleInputChanged e",e);
        //     console.log("handleInputChanged e.target",e.target);
        //     console.log("handleInputChanged e.target.value",e.target.value);

        // },

        setInputPlaceHolder() {

            if (this.searchFlag == 'All Columns') {
                return 'Search...';
            } else {
                return this.searchFlag + '...';
            }

        },
        setButtonTitle() {
            return 'Click here to search by ' + this.searchFlag;
        }


    } 

}  
</script>