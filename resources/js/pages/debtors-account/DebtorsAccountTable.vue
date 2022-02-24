<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <table-options/>
            <new-record-button type="button" :title="'Add a ' + singular" text="Add Transaction"/>
        </div>
    </div>

    <table :id="tableId" class="table bordered" style="width:100%"></table>

    <div v-show="debtorsBalance" class="text-right mt-1 mr-1" style="font-size: 0.7vw;">
        <strong>Debtors Balance:</strong> {{$root.formatMoney(debtorsBalance)}}
    </div>

</div>
</template>

<script>

import tableTemplate from "@components/tables/table-template";


export default {

    mixins: [tableTemplate],

    created() {
        this.url = "/coldebits/get";
        this.route = "coldebits";
        this.title = 'Debtors Account';
        this.plural = 'Debtor Transactions';
        this.singular = 'Debtor Transaction';
        this.tableName = 'coldebit';

    },

    data() {
        return {
            debtorsBalance: null,
        };
    },

    methods: {

        defineTableColDefs() {

            let tableColumnDefs = [
                {
                    title: "Date",
                    name: "coldebit.date",
                    data: null,
                    width: "15%",
                    targets: 1,
                    render: function (data) {
                        return data.formatteddate;
                    }
                },
                {
                    title: "Description",
                    name: "coldebit.description",
                    data: null,
                    width: "40%",
                    targets: 2,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "Type",
                    name: "coldebit.typedescription",
                    data: null,
                    width: "12.5%",
                    targets: 3,
                    render: function (data) {
                        return data.typedescription;
                    }
                },
                {
                    title: "Code",
                    visible: false,
                    //title: "Timerstamp",
                    name: "coldebit.documentcode",
                    data: null,
                    width: "10%",
                    targets: 4,
                    render: function (data) {
                        return data.documentcode ? htmlDecode(data.documentcode) : '';
                        //return data.timerstamp;
                    }
                },
                {
                    title: "Amount",
                    name: "coldebit.totalamount",
                    data: null,
                    class: "text-number",
                    width: "15%",
                    targets: 5,
                    render: function (data) {
                        return data.totalamount;
                    }
                },
                {
                    title: "Cost Balance",
                    visible: false,
                    name: "coldebit.costbalance",
                    data: null,
                    filterType: 'Number',
                    class: "text-number",
                    width: '15%',
                    targets: 6,
                    render: function (data) {
                        return data.costbalance;
                    }
                },
                {
                    title: "Interest Balance",
                    visible: false,
                    name: "coldebit.interestbalance",
                    data: null,
                    filterType: 'Number',
                    class: "text-number",
                    width: '15%',
                    targets: 7,
                    render: function (data) {
                        return data.interestbalance;
                    }
                },
                {
                    title: "Capital Balance",
                    visible: false,
                    name: "coldebit.capitalbalance",
                    data: null,
                    filterType: 'Number',
                    class: "text-number",
                    width: '15%',
                    targets: 8,
                    render: function (data) {
                        return data.capitalbalance;
                    }
                },
                {
                    title: "Balance",
                    name: "coldebit.balance",
                    data: null,
                    filterType: 'Number',
                    class: "text-number",
                    width: '15%',
                    targets: 9,
                    render: function (data) {
                        return data.balance;
                    }
                },

                {
                    title: "",
                    visible: false,
                    searchable: false,
                    filterExclude: true,
                    name: "coldebit.collcommflag",
                    data: null,
                    targets: 10,
                    render: (data) => {
                        return data?.collcommflag ? data.collcommflag : 0;
                    }
                },
                {
                    title: "",
                    visible: false,
                    searchable: false,
                    filterExclude: true,
                    name: "coldebit.vatflag",
                    data: null,
                    targets: 11,
                    render: (data) => {
                        return data?.vatflag ? data.vatflag : 0;
                    }
                },
                {
                    title: "",
                    visible: false,
                    searchable: false,
                    filterExclude: true,
                    name: "coldebit.overrideemocommflag",
                    data: null,
                    targets: 12,
                    render: (data) => {
                        return data?.overrideemocommflag ? data.overrideemocommflag : 0;
                    }
                },
                {
                    title: "",
                    visible: false,
                    searchable: false,
                    filterExclude: true,
                    name: "coldebit.exportedflag",
                    data: null,
                    targets: 13,
                    render: (data) => {
                        return data?.exportedflag ? data.exportedflag : 0;
                    }
                },
                {
                    title: "",
                    visible: false,
                    searchable: false,
                    filterExclude: true,
                    name: "coldebit.amount",
                    data: null,
                    targets: 14,
                    render: (data) => {
                        return data?.amount ? data.amount : 0;
                    }
                },
                {
                    title: "",
                    visible: false,
                    searchable: false,
                    filterExclude: true,
                    name: "coldebit.vatamount",
                    data: null,
                    targets: 15,
                    render: (data) => {
                        return data?.vatamount ? data.vatamount : 0;
                    }
                },
                {
                    title: "",
                    visible: false,
                    searchable: false,
                    filterExclude: true,
                    data: null,
                    targets: 16,
                    render: (data) => {
                        return data.employeename;
                    }
                },
                {
                    title: "",
                    visible: false,
                    searchable: false,
                    filterExclude: true,
                    data: null,
                    targets: 17,
                    render: (data) => {
                        return data.reference;
                    }
                },

            ];
        
            return tableColumnDefs;
        }

    },

}  
</script>
