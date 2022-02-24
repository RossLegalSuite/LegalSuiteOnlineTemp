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
        this.url = "/country/get";
        this.route = "Countries";
        this.title = 'Countries';
        this.plural = 'Countries';
        this.singular = 'Country';
        this.select = ['country.recordid','country.description'];
        this.tableName = 'country';
    },


    methods: {

        defineTableColDefs() {

            const targets = this.selectTableFlag ? 1 : 2;

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "country.description",
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
