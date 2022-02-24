<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div/>
    </div>

    <table :id="tableId" class="table bordered" style="width:100%"></table>

</div>
</template>

<script>

import tableTemplate from "@components/tables/table-template";

export default {

    mixins: [tableTemplate],

    created() {
        this.url = "/todonote/get";
        this.route = "todonotes";
        this.title = 'Reminders';
        this.plural = 'Reminders';
        this.singular = 'Reminder';
        this.select = ['todonote.recordid','todonote.description'];
        this.tableName = 'todonote';
    },

    data() {
        return {
            matterId: null,
        }
    },

    watch: {

        matterId(newValue) {

            // Set the whereRaw clause
            this.whereRaw = 'matterid = ' + newValue;

            // Load the table
            this.loadDataTable();

        },

    },


    methods: {

        defineTableColDefs() {

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "todonote.Description",
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
