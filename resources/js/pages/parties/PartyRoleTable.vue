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
        this.url = "/role/get";
        this.route = "Roles";
        this.title = 'Roles';
        this.plural = 'Roles';
        this.singular = 'Role';
        this.select = ['role.recordid','role.description'];
        this.tableName = 'role';
    },


    methods: {

        defineTableColDefs() {

            const targets = this.selectTableFlag ? 1 : 2;

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "role.description",
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
