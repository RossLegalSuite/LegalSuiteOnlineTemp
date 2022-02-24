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
        this.url = "/entity/get";
        this.route = "entity";
        this.title = 'Entities';
        this.plural = 'Entities';
        this.singular = 'Entity';
        this.select = ['entity.recordid','entity.description','entity.category','entity.juristicflag'];
        this.tableName = 'entity';
    },

    methods: {

        defineTableColDefs() {

            const targets = this.selectTableFlag ? 1 : 2;

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "entity.description",
                    data: null,
                    targets: targets,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "Type",
                    name: "entity.juristicflag",
                    data: null,
                    targets: targets + 1,
                    render: function (data) {
                        return data.juristicflag === '0' ? 'Person' : 'Juristic';
                    }
                },

            ];
        
            return tableColumnDefs;
        }

    },



}  
</script>
