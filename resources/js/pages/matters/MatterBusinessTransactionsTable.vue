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
        this.url = "/matters/getBusinessTransactions";
        this.route = "matters";
        this.title = 'Matter Transactions';
        this.plural = 'Matter Transactions';
        this.singular = 'Matter Transaction';
    },

    methods: {
        

        defineTableColDefs: function () {

            let tableColumnDefs = [
                {
                    title: "Date",
                    name: "date",
                    filterColumnName: "date",
                    filterType: 'Date',
                    data: null,
                    width: '12%',
                    targets: 0,
                    render: function (data) {
                        return data.dateFormatted;
                    }
                },
                {
                    title: "Source",
                    name: "documentNumber",
                    filterColumnName: "documentId",
                    filterType: 'Number',
                    data: null,
                    width: '20%',
                    targets: 1,
                    render: function (data) {
                        return lookupWrapper(data.documentType, data.documentId, data.documentNumber);
                    }
                },
                {
                    title: "Description",
                    name: "description",
                    data: null,
                    width: "50%",
                    targets: 2,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },                {
                    title: "Amount",
                    name: "amount",
                    class: "text-right",
                    data: null,
                    width: "15%",
                    targets: 3,
                    render: function (data) {

                        let _class = data.rawAmount < 0 ? "text-red" : "";
                        return '<span class="' + _class + '">' + data.amount + '</span>';

                    }
                },
            ];

/*
                {
                    title: "Invoice #",
                    name: "invoiceNumber",
                    filterColumnName: "invoiceId",
                    filterType: 'Number',
                    data: null,
                    width: '10%',
                    targets: 1,
                    render: function (data) {
                        return lookupWrapper('Invoice', data.invoiceId, data.invoiceNumber);
                    }
                },
                {
                    title: "Receipt #",
                    name: "receiptNumber",
                    filterColumnName: "receiptId",
                    filterType: 'Number',
                    data: null,
                    width: '10%',
                    targets: 2,
                    render: function (data) {
                        return lookupWrapper('Receipt', data.receiptId, data.receiptNumber);
                    }
                },
*/
        
            return tableColumnDefs;
        }

    },



}  
</script>
