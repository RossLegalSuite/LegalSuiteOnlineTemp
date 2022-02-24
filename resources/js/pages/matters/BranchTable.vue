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
        this.url = "/branch/get";
        this.route = "branches";
        this.title = 'Branches';
        this.plural = 'Branches';
        this.singular = 'Branch';
        this.select = [
            'branch.recordid',
            'branch.description',
        ];
        this.tableName = 'branch';
    },

    methods: {

        defineTableColDefs() {

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "branch.Description",
                    data: null,
                    targets: 1,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                // {
                //     title: "",
                //     visible: false,
                //     filterExclude: true,
                //     searchable: false,
                //     name: "branch.trustbankid",
                //     data: null,
                //     targets: 2,
                //     render: function (data) {
                //         return htmlDecode(data.trustbankid);
                //     }
                // },
                // {
                //     title: "",
                //     visible: false,
                //     filterExclude: true,
                //     searchable: false,
                //     name: "branch.trustbankdescription",
                //     data: null,
                //     targets: 3,
                //     render: function (data) {
                //         return htmlDecode(data.trustbankdescription);
                //     }
                // },
                // {
                //     title: "",
                //     visible: false,
                //     filterExclude: true,
                //     searchable: false,
                //     name: "branch.businessbankid",
                //     data: null,
                //     targets: 4,
                //     render: function (data) {
                //         return htmlDecode(data.businessbankid);
                //     }
                // },
                // {
                //     title: "",
                //     visible: false,
                //     filterExclude: true,
                //     searchable: false,
                //     name: "branch.businessbankdescription",
                //     data: null,
                //     targets: 5,
                //     render: function (data) {
                //         return htmlDecode(data.businessbankdescription);
                //     }
                // },

            ];
        
            return tableColumnDefs;
        }

    },



}  
</script>
