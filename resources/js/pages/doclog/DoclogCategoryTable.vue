<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <table-options/>
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
        this.url = "/doclogcategory/get";
        this.route = "doclogcategories";
        this.title = 'Categories';
        this.plural = 'Categories';
        this.singular = 'Category';
        this.tableName = 'doclogcategory';
        this.select = [
            'doclogcategory.recordid',
            'doclogcategory.description',
        ];

    },

    methods: {

        defineTableColDefs() {

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "doclogcategory.description",
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
