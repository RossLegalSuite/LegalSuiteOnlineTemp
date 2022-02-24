<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <table-options/>
            <new-record-button type="button" :title="'Create a new ' + singular" text="New"/>
        </div>
    </div>

    <table :id="tableId" class="table bordered" style="width:100%"></table>

</div>
</template>

<script>

import tableTemplate from "@components/tables/table-template";


export default {

    mixins: [tableTemplate],

    created() {
        this.url = "/library/get";
        this.route = "Library";
        this.title = 'Entries';
        this.plural = 'Entries';
        this.singular = 'Entry';
        this.tableName = 'library';
        this.selectTableFlag = true;
        this.actionColumnWidth = 12;
    },


    methods: {

        defineTableColDefs() {

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "library.description",
                    data: null,
                    targets: 1,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },

            ];

        
            return tableColumnDefs;
        }

    },



}  
</script>
