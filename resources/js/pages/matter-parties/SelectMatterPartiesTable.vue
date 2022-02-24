<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
            <global-search/>

            <select-party-role 
                :id="tableId + '-select-party-role'" 
                :ref="tableId + '-select-party-role'" 
                :formRef="tableId + '-select-party-role'"
                _class="table-filter-dropdown"
                :showLabel="false"
                :filtering="true"
            />

    </div>

    <table :id="tableId" class="table bordered" style="width:100%"/>

</div>
</template>

<script>

import tableTemplate from "@components/tables/table-template";

export default {

    mixins: [tableTemplate],

    components: {
        SelectPartyRole: () => import("@pages/parties/SelectPartyRole"),
    },

    data() {
        return {
            tableFilters: [],
        }
    },


    created() {
        this.url = "/matter_parties/get";
        this.route = "matter_parties";
        this.title = 'Parties';
        this.plural = 'Parties';
        this.singular = 'Party';

    },

    methods: {

        partyRoleSelected(id, description, code) {

            this.tableFilters = [];
            removeTableFilter(this.tableId);

            const targets = this.tagTableFlag ? 1 : 0;
            this.tableColumn = this.columnDefs[targets + 3];

            let tableFilter = {};

            tableFilter.index = 0;
            tableFilter.targets = targets + 3;
            tableFilter.value = description;
            tableFilter.title = this.tableColumn.title;
            tableFilter.join = "or",
            tableFilter.name = this.tableColumn.filterColumnName ? this.tableColumn.filterColumnName : this.tableColumn.name;
            tableFilter.calculatedColumn = this.tableColumn.calculatedColumn ? this.tableColumn.calculatedColumn : false;
            tableFilter.filterType = this.tableColumn.filterType ? this.tableColumn.filterType : 'String';
            tableFilter.filterTitle = this.tableColumn.filterTitle ? this.tableColumn.filterTitle : this.tableColumn.title;

            this.tableFilters.push(tableFilter);


            setTableFilter(this.tableId,this.tableFilters);

            this.loadDataTable();

        },

        selectRecord(id) {

            if ( this.tagTableFlag ) {

                this.$parent.hide();

                this.$parent.$parent.matterPartiesSelected([id]);

            } else {

                axios.post('/matter_parties/get',{recordid: id})

                .then(response => {

                    if ( typeof this.$parent.$parent.matterPartySelected === 'function') {

                        this.$parent.$parent.matterPartySelected(response.data.data[0].id, response.data.data[0].name);
                        
                    }

                })

                .finally(() => {

                    this.$parent.hide();

                });   


            }

        },        


        defineTableColDefs() {

            const targets = this.tagTableFlag ? 1 : 0;
            
            let tableColumnDefs = [
                {
                    title: "Matter",
                    name: "matters.fileRef",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Matter',
                    data: null,
                    orderable: false,
                    targets: targets + 1,
                    render: function (data) {
                        return htmlDecode(data.matter);
                    }
                },
                {
                    title: "Party",
                    name: "parties.name",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Party',
                    data: null,
                    targets: targets + 2,
                    render: function (data) {
                        return htmlDecode(data.name);
                    }
                },
                {
                    title: "Role",
                    name: "party_roles.description",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'PartyRole',
                    data: null,
                    targets: targets + 3,
                    render: function (data) {
                        return data.role;
                    }
                },
            ];
            return tableColumnDefs;
        }
    },
}  
</script>
