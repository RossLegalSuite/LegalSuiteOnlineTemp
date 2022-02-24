<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <table-options/>
            <new-record-button type="button" :title="'Create a new ' + singular" text="Add"/>
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
        this.url = "/billingrate/get";
        this.route = "billingrates";
        this.title = 'Billing Rates';
        this.plural = 'Billing Rates';
        this.singular = 'Billing Rate';
        this.select = ['billingrate.recordid','billingrate.description','billingrate.amount'];
        this.tableName = 'billingrate';
    },

    methods: {

        defineTableColDefs() {

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "billingrate.Description",
                    data: null,
                    targets: 1,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "Per Hour",
                    name: "billingrate.Amount",
                    data: null,
                    targets: 2,
                    render: function (data) {
                        return htmlDecode(data.amount);
                    }
                },

            ];
        
            return tableColumnDefs;
        }

    },



}  
</script>
