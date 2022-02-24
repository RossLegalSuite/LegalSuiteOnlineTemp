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
        this.url = "/teletype/get";
        this.route = "teletype";
        this.title = 'Contact Methods';
        this.plural = 'Contact Methods';
        this.singular = 'Contact Method';
        this.select = ['teletype.recordid','teletype.description'];
        this.tableName = 'teletype';
    },


    methods: {

        defineTableColDefs() {

            const targets = this.selectTableFlag ? 1 : 2;

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "teletype.description",
                    data: null,
                    targets: targets,
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
