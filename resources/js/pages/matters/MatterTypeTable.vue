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
        this.url = "/mattype/get";
        this.route = "matter_types";
        this.title = 'Matter Types';
        this.plural = 'Matter Types';
        this.singular = 'Matter Type';
        this.tableName = 'mattype';
        this.select = [
            'mattype.recordid',
            'mattype.description',
            'mattype.feesheetid',
            'feesheet.description as feesheetdescription',
        ];

    },

    methods: {

        defineTableColDefs() {

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "mattype.description",
                    data: null,
                    targets: 1,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "",
                    visible: false,
                    searchable: false,
                    filterExclude: true,
                    name: "mattype.feesheetid",
                    data: null,
                    targets: 2,
                    render: (data) => {
                        return data.feesheetid;
                    }
                },
                {
                    title: "",
                    visible: false,
                    searchable: false,
                    filterExclude: true,
                    name: "feesheet.description",
                    data: null,
                    targets: 3,
                    render: (data) => {
                        return data.feesheetdescription;
                    }
                },

            ];

            return tableColumnDefs;
        }

    },

}  
</script>
