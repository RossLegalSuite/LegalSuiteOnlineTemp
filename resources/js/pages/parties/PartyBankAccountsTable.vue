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
        this.url = "/accbank/get";
        this.route = "accbank";
        this.title = 'Accounts';
        this.plural = 'Accounts';
        this.singular = 'Account';
        this.tableName = 'accbank';
    },

    methods: {

        defineTableColDefs() {

            const targets = this.selectTableFlag ? 1 : 0;

            let tableColumnDefs = [
                {
                    title: "Name",
                    name: "accbank.description",
                    data: null,
                    width: "35%",
                    targets: targets,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "Number",
                    name: "accbank.accountno",
                    data: null,
                    targets: targets + 1,
                    render: function (data) {
                        return htmlDecode(data.accountno);
                    }
                },
                {
                    title: "Institution",
                    name: "accbank.institution",
                    data: null,
                    targets: targets + 2,
                    render: function (data) {
                        return htmlDecode(data.institution);
                    }
                },
                {
                    title: "Branch",
                    name: "accbank.branch",
                    data: null,
                    targets: targets + 3,
                    render: function (data) {
                        return htmlDecode(data.branch);
                    }
                },
                // {
                //     title: "Code",
                //     name: "accbank.branchcode",
                //     data: null,
                //     targets: targets + 4,
                //     render: function (data) {
                //         return htmlDecode(data.branchcode);
                //     }
                // },

            ];
        
            return tableColumnDefs;
        }

    },



}  
</script>
