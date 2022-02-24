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
        this.url = "/business/get";
        this.route = "business";
        this.title = 'Income Accounts';
        this.plural = 'Income Accounts';
        this.singular = 'Income Account';
        this.select = ['business.recordid','business.description'];
        this.tableName = 'business';
        this.where = 'type,1';
    },

    methods: {

        defineTableColDefs() {

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "business.Description",
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
