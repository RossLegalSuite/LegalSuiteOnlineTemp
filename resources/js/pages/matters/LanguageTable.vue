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
        this.url = "/language/get";
        this.route = "languages";
        this.title = 'Languages';
        this.plural = 'Languages';
        this.singular = 'Language';
        this.select = ['language.recordid','language.description'];
        this.tableName = 'language';
    },

    methods: {

        defineTableColDefs() {

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "language.Description",
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
