<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <table-options/>
            <new-record-button v-if="newRecordButton" type="button" :title="'Create a new ' + singular" text="Add"/>
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
        this.url = "/feesheet/get";
        this.route = "feesheets";
        this.title = 'Fee Sheets';
        this.plural = 'Fee Sheets';
        this.singular = 'Fee Sheet';
        this.tableName = 'feesheet';
    },


    methods: {

        defineTableColDefs() {

            // const targets = this.selectTableFlag ? 1 : 2;

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "feesheet.description",
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
