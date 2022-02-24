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
        this.url = "/lolsystemtemplate/get";
        this.route = "templates";
        this.title = 'Templates';
        this.plural = 'Templates';
        this.singular = 'Template';
        this.tableName = 'lolsystemtemplate';
    },

    methods: {
        
        defineTableColDefs: function () {

            let targets = this.tagTableFlag ? 1 : 0;

            let tableColumnDefs = [
                {
                    title: "Title",
                    name: "title",
                    width: "20%",
                    data: null,
                    targets: targets + 1,
                    render: function (data) {
                        return htmlDecode(data.title);
                    }
                },
                {
                    title: "Description",
                    name: "description",
                    data: null,
                    width: "50%",
                    targets: targets + 2,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "Role",
                    name: "roleid",
                    width: "12%",
                    data: null,
                    visible: this.tagTableFlag,
                    targets: targets + 3,
                    render: function (data) {
                        return data?.roledescription ? data.roledescription : '';
                    }
                }

            ];

            return tableColumnDefs;

        }

    },    

}  
</script>
