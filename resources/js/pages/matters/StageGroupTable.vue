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
        this.url = "/stagegroup/get";
        this.route = "stagegroups";
        this.title = 'Stage Groups';
        this.plural = 'Stage Groups';
        this.singular = 'Stage Group';
        this.select = ['stagegroup.recordid','stagegroup.description'];
        this.tableName = 'stagegroup';
    },

    methods: {

        defineTableColDefs() {

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "stagegroup.Description",
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
