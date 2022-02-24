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
        this.url = "/doclogsubcategory/get";
        this.route = "doclogsubcategories";
        this.title = 'Sub Categories';
        this.plural = 'Sub Categories';
        this.singular = 'Sub Category';
        this.tableName = 'doclogsubcategory';
        this.select = [
            'doclogsubcategory.recordid',
            'doclogsubcategory.description',
        ];

    },

    methods: {

        defineTableColDefs() {

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "doclogsubcategory.description",
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
