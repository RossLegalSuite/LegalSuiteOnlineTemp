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
        this.url = "/docscrn/get";
        this.route = "docscrn";
        this.title = 'Extra Screens';
        this.plural = 'Extra Screens';
        this.singular = 'Extra Screen';
        this.select = ['docscrn.recordid','docscrn.description'];
        this.tableName = 'docscrn';
    },

    methods: {

        defineTableColDefs() {

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "docscrn.Description",
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
