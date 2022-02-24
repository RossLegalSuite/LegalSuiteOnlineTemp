<template>
<div class="datatables-search">
    
    <div class="input-group input-group-sm">

        <input :id="$parent.tableId + '-datatables-search-for'" v-model="searchFor" type="search" title="Search For" placeholder="Search..." class="form-control search-input" v-on:search="searchTable">

        <button title="Click here to search" v-on:click="searchTable" class="btn btn-primary btn-sm datatables-search-button">
            <span class="fa fa-search"></span>
        </button>

        <button title="Clear the search" v-show="searchFor" v-on:click="clearSearch" class="btn btn-danger btn-sm datatables-search-button">
            <span class="fa fa-times"></span>
        </button>

    </div>


</div>

</template>

<script>

export default {

    data() {
        return {
            searchFor: null,
        };
    },

    methods: {

        clearSearch() {

            this.searchFor = null;

            this.clearPreviousSearch( true );

        },

        clearPreviousSearch( reloadFlag = false ) {

            $('#' + this.$parent.tableId).DataTable().search('', false, false);

            if ( reloadFlag ) {

                $('#' + this.$parent.tableId).DataTable().ajax.reload();
            }


        },

        searchTable() {

            this.clearPreviousSearch();

            if (this.searchFor) {

                $('#' + this.$parent.tableId).DataTable()
                .search(this.searchFor, false, false)
                .ajax.reload();

            }

        },

    } 

}  
</script>