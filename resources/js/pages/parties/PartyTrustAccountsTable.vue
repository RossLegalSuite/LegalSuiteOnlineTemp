<template>
<span>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <tagged-drop-down v-if="taggedDropDown" :table-id="tableId"/>
            <table-options/>
        </div>

    </div>

    <table :id="tableId" class="table bordered" style="width:100%"></table>
    
    <table-footer/>

</span>
</template>

<script>

import tableTemplate from "@components/tables/table-template";

export default {

    mixins: [tableTemplate],

    created() {
        this.url = "/matters/get";
        this.route = "matters";
        this.title = 'Trust Accounts';
        this.plural = 'Accounts';
        this.singular = 'Account';
    },

    data() {
        return {

            tableOptions: {

                createdRow: ( row, data ) => {

                    if (data.backgroundColor !== '#FFF' && data.textColor !== '#000' ) {
                        $(row).css({"color": data.textColor, "background-color": data.backgroundColor}).addClass("custom-colors");
                    }

                },

            }
        }  
    },  


    methods: {
        
        defineTableColDefs() {

            let tableColumnDefs = [
                {
                    title: "File Ref",
                    name: "matters.fileRef",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Matter',
                    width: "12%",
                    data: null,
                    targets: 0,
                    render: (data) => { return htmlDecode(data.fileRef) }
                    
                },
                {
                    title: "Description",
                    name: "matters.description",
                    width: "33%",
                    data: null,
                    targets: 1,
                    render: (data) => {
                        return htmlDecode(data.description);
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
                    targets: 2,
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
                    targets: 3,
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
                    targets: 4,
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
                    targets: 5,
                    render: (data) => {
                        return htmlDecode(data.branchDescription);
                    }
                },
                {
                    searchable: false,
                    title: "Reserved",
                    name: "rawReservedTrustBalance",
                    calculatedColumn: true, // Uses "having" clause instead of "where"
                    filterType: 'Number',
                    class: "text-number",
                    data: null,
                    width: '15%',
                    targets: 6,
                    render: function (data) {
                        return data.reservedTrustBalance;
                    }
                },
                {
                    searchable: false,
                    title: "Unreserved",
                    name: "rawUneservedTrustBalance",
                    calculatedColumn: true, // Uses "having" clause instead of "where"
                    filterType: 'Number',
                    class: "text-number",
                    data: null,
                    width: '15%',
                    targets: 7,
                    render: function (data) {
                        return data.unreservedTrustBalance;
                    }
                },
                {
                    searchable: false,
                    title: "Transfer Available",
                    name: "transferAvailable",
                    calculatedColumn: true, // Uses "having" clause instead of "where"
                    filterType: 'Number',
                    class: "text-number",
                    data: null,
                    width: '20%',
                    targets: 8,
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
