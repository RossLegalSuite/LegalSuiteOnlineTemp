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
        this.url = "/parshare/get";
        this.route = "parshare";
        this.title = 'Shareholders';
        this.plural = 'Shareholders';
        this.singular = 'Shareholder';
        this.tableName = 'parshare';
    },

    methods: {

        defineTableColDefs() {

            const targets = this.selectTableFlag ? 1 : 0;

            let tableColumnDefs = [
                {
                    title: "First Name",
                    name: "parshare.firstname",
                    data: null,
                    targets: targets,
                    render: function (data) {
                        return htmlDecode(data.firstname);
                    }
                },
                {
                    title: "Last Name",
                    name: "parshare.lastname",
                    data: null,
                    targets: targets + 1,
                    render: function (data) {
                        return htmlDecode(data.lastname);
                    }
                },

            ];
        
            return tableColumnDefs;
        }

    },

}  
</script>
