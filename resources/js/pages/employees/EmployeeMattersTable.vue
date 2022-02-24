<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <table-options/>
        </div>
    </div>

    <table :id="tableId" class="table bordered" style="width:100%"></table>
    <table-footer/>

</div>
</template>

<script>

import tableTemplate from "@components/tables/table-template";


export default {

    mixins: [tableTemplate],

    created() {
        this.url = "/matters/get";
        this.route = "matters";
        this.title = 'Matters';
        this.plural = 'Matters';
        this.singular = 'Matter';
    },

    methods: {

        defineTableColDefs() {
            
            let targets = this.tagTableFlag ? 1 : 0;

            let tableColumnDefs = [
                {
                    title: "File Ref",
                    name: "matters.fileRef",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Matter',
                    width: "12%",
                    data: null,
                    targets: targets,
                    render: (data) => { 
                        return lookupWrapper('Matter', data.id, htmlDecode(data.fileRef));
                    }
                    
                },
                {
                    title: "Description",
                    name: "matters.description",
                    width: "33%",
                    data: null,
                    targets: targets + 1,
                    render: (data) => {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "Instructed",
                    name: "instructed",
                    filterColumnName: "matters.instructed",
                    filterType: 'Date',
                    visible: false,//visible: !root.screenNarrow,
                    width: "12%",
                    data: null,
                    targets: targets + 2,
                    render: (data) => {
                        return data.instructed;
                    }
                },
                {
                    title: "Client",
                    name: "client.name",
					filterColumnName: 'client.code',
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Party',
                    width: "30%",
                    data: null,
                    targets: targets + 3,
                    render: (data) => {
                        return lookupWrapper('Client', data.clientId, htmlDecode(data.clientName));
                    }
                },
                {
                    title: "Employee",
                    name: "owner.name",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Employee',
                    visible: false,
                    data: null,
                    width: "15%",
                    targets: targets + 4,
                    render: (data) => {
                        return htmlDecode(data.employeeName);
                    }
                },
                {
                    title: "Matter Type",
                    name: "matter_types.description",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'MatterType',
                    visible: false,
                    data: null,
                    width: "15%",
                    targets: targets + 5,
                    render: (data) => {
                        return htmlDecode(data.matterTypeDescription);
                    }
                },
                {
                    title: "Document Set",
                    name: "document_sets.description",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'DocumentSet',
                    visible: false,
                    data: null,
                    width: "15%",
                    targets: targets + 6,
                    render: (data) => {
                        return htmlDecode(data.documentSetDescription);
                    }
                },
                {
                    title: "Branch",
                    name: "branches.description",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Branch',
                    visible: false,
                    data: null,
                    width: "15%",
                    targets: targets + 7,
                    render: (data) => {
                        return htmlDecode(data.branchDescription);
                    }
                },

                {
                    searchable: false,
                    title: "Business Balance",
                    name: "rawBusinessBalance",
                    calculatedColumn: true, // Uses "having" clause instead of "where"
                    filterType: 'Number',
                    class: "text-number",
                    data: null,
                    width: '20%',
                    targets: targets + 8,
                    render: function (data) {
                        return htmlRedText(data.businessBalance, data.rawBusinessBalance < 0);
                        //let _class = data.rawBusinessBalance < 0 ? "text-red" : "";
                        //return '<span class="' + _class + '">' + data.businessBalance + '</span>';
                    }
                },
                {
                    searchable: false,
                    title: "Trust Balance",
                    name: "totalTrustBalance",
                    calculatedColumn: true, // Uses "having" clause instead of "where"
                    filterType: 'Number',
                    class: "text-number",
                    visible: false,
                    data: null,
                    width: '20%',
                    targets: targets + 9,
                    render: function (data) {
                        return data.trustBalance;
                    }
                },
                {
                    searchable: false,
                    title: "Reserved Trust Balance",
                    name: "rawReservedTrustBalance",
                    calculatedColumn: true, // Uses "having" clause instead of "where"
                    filterType: 'Number',
                    class: "text-number",
                    visible: false,
                    data: null,
                    width: '20%',
                    targets: targets + 10,
                    render: function (data) {
                        return data.reservedTrustBalance;
                    }
                },
                {
                    searchable: false,
                    title: "Unreserved Trust Balance",
                    name: "rawUneservedTrustBalance",
                    calculatedColumn: true, // Uses "having" clause instead of "where"
                    filterType: 'Number',
                    class: "text-number",
                    visible: false,
                    data: null,
                    width: '20%',
                    targets: targets + 11,
                    render: function (data) {
                        return data.unreservedTrustBalance;
                    }
                },
                {
                    searchable: false,
                    title: "Business Credits",
                    name: "rawTrustBalance",
                    calculatedColumn: true, // Uses "having" clause instead of "where"
                    filterType: 'Number',
                    class: "text-number",
                    visible: false,
                    data: null,
                    width: '20%',
                    targets: targets + 12,
                    render: function (data) {
                        return data.businessCredits;
                    }
                },
                {
                    searchable: false,
                    title: "Transfer Available",
                    name: "transferAvailable",
                    calculatedColumn: true, // Uses "having" clause instead of "where"
                    filterType: 'Number',
                    class: "text-number",
                    visible: false,
                    data: null,
                    width: '20%',
                    targets: targets + 13,
                    render: function (data) {
                        return data.transferAvailable;
                    }
                },

            ];

            return tableColumnDefs;
        }

    },

}  
</script>
