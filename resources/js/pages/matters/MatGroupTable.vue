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
        this.url = "/matgroup/get";
        this.route = "matgroup";
        this.title = 'Groups';
        this.plural = 'Groups';
        this.singular = 'Group';
        this.tableName = 'matgroup';

    },

    methods: {

        defineTableColDefs() {

            let tableColumnDefs = [

                {
                    title: "Groups",
                    name: "grouping.description",
                    data: null,
                    targets: 0,
                    render: function (data) {
                        return htmlDecode(data.groupingdescription);
                    }
                },
            

            ];
        
            return tableColumnDefs;
        }

    },



}  
</script>
