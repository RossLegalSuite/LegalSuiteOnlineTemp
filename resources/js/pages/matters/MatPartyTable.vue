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
        this.url = "/party/get";
        this.route = "party";
        this.title = 'Party';
        this.plural = 'Parties';
        this.singular = 'Party';
        this.tableName = 'party';
    },

    methods: {

        defineTableColDefs() {

            let tableColumnDefs = [

                {
                    title: "Name",
                    name: "party.name",
                    data: null,
                    targets: 0,
                    render: function (data) {
                        return htmlDecode(data.name);
                    }
                },
            

            ];
        
            return tableColumnDefs;
        }

    },



}  
</script>
