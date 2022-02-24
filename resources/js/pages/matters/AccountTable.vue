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
        this.title = 'Accounts';
        this.plural = 'Accounts';
        this.singular = 'Account';
        this.select = ['business.recordid','business.description','business.type'];
        this.tableName = 'business';
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
                // {
                //     title: "Type",
                //     name: "business.Type",
                //     data: null,
                //     targets: 2,
                //     render: function (data) {
                //         return htmlDecode(data.typedescription);
                //         // return htmlDecode(data.typedescription);
                //     }
                // },

            ];
        
            return tableColumnDefs;
        }

    },



}  
</script>
