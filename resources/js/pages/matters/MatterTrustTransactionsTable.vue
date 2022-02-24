<template>
<div>

    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <table-options/>
        </div>
    </div>

    <table :id="tableId" class="table bordered" style="width:100%"/>
    

</div>
</template>

<script>

import tableTemplate from "@components/tables/table-template";

export default {

    mixins: [tableTemplate],


    created() {
        this.url = "/matters/getTrustTransactions";
        this.route = "matters";
        this.title = 'Matter Trust Account';
        this.plural = 'Trust Account Transactions';
        this.singular = 'Transaction';
    },

    methods: {

        defineTableColDefs: function () {

            let tableColumnDefs = [
                {
                    title: "Date",
                    name: "date",
                    filterColumnName: "date",
                    filterType: 'Date',
                    width: "15%",
                    data: null,
                    targets: 1,
                    render: function (data) {
                        return data.dateFormatted;
                    }
                },
                {
                    title: "Account",
                    name: "account",
                    data: null,
                    targets: 2,
                    render: function (data) {
                        return data.account;
                    }
                },
                {
                    title: "Reference",
                    name: "reference",
                    data: null,
                    targets: 3,
                    render: function (data) {
                        return getAccountingLookups(data);
                    }
                },
                {
                    title: "Debit",
                    name: "debit",
                    class: "text-right",
                    data: null,
                    width: "15%",
                    targets: 4,
                    render: function (data) {
                        return data.debit
                    }
                },
                {
                    title: "Credit",
                    name: "credit",
                    class: "text-right",
                    data: null,
                    width: "15%",
                    targets: 5,
                    render: function (data) {
                        return data.credit
                    }
                },
            ];

                return tableColumnDefs;
            }

        },



}  
</script>
