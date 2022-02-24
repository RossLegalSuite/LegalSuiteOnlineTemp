<template>
<span>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <tagged-drop-down v-if="taggedDropDown" :table-id="tableId"/>
            <filter-form-button/>
            <table-options/>
            <button class="btn btn-secondary btn-sm d-inline-block mr-2"
                type="button"
                @click="selectFeeCodes"
                title="Select a Fee Code"
            ><i class="fa fa-plus-square mr-2"></i>Fee Code</button>
            <new-record-button type="button" :title="'Create a new ' + singular" :text="'New ' + singular"/>

        </div>

    </div>

    <table :id="tableId" class="table bordered" style="width:100%"/>
    <table-footer/>

    <fee-note-filter-form
        :id="tableId + '-filter-form'"
        :ref="tableId + '-filter-form'"
    />

</span>
</template>

<script>

import tableTemplate from "@components/tables/table-template";

export default {

    mixins: [tableTemplate],

    components: {
        FeeNoteFilterForm: () => import("./FeeNoteFilterForm"),
    },

    created() {
        this.url = "/feenote/get";
        this.route = "feenote";
        this.tableName = 'feenote';
        this.title = 'Fee Notes';
        this.plural = 'Fee Notes';
        this.singular = 'Fee Note';
    },

    methods: {

        selectFeeCodes() {

            if (typeof this.$parent.selectFeeCode === 'function') this.$parent.selectFeeCode();

        },

        defineTableColDefs() {

            const targets = this.tagTableFlag ? 1 : 0;
            const parentColumnVisible = this.parentType === 'General' ? true : false;

            let tableColumnDefs = [
                {
                    title: "Date",
                    name: "feenote.date",
                    filterColumnName: "feenote.date",
                    filterType: 'Date',
                    data: null,
                    width: "12%",
                    targets: targets + 1,
                    render: function (data) {
                        return data.formatteddate;
                    }
                },
                {
                    title: "Sorter",
                    name: "feenote.sorter",
                    filterExclude: true,
                    searchable: false,
                    orderable: false,
                    visible: false,
                    data: null,
                    width: "12%",
                    targets: targets + 2,
                    render: function (data) {
                        return data.sorter;
                    }
                },
                {
                    title: "Matter",
                    name: 'matter.fileref',
                    filterExclude: true,
                    orderable: false,
                    data: null,
                    visible: parentColumnVisible,
                    width: "15%",
                    targets: targets + 3,
                    render: function (data) {
                        return htmlDecode(data.parentlink);
                    }
                },                

                {
                    title: "Description",
                    name: "feenote.description",
                    data: null,
                    orderable: false,
                    width: "35%",
                    targets: targets + 4,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "Created By",
                    name: "employee.name",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Employee',
                    data: null,
                    orderable: false,
                    searchable: false,
                    visible: false,
                    width: "15%",
                    targets: targets + 5,
                    render: function (data) {
                        return htmlDecode(data.employeename);
                    }
                },   
                {
                    title: "Amount Excl",
                    name: "amountexcl",
                    filterExclude: true,
                    orderable: false,
                    searchable: false,
                    class: "text-number",
                    data: null,
                    visible: false,
                    width: "15%",
                    targets: targets + 6,
                    render: function (data) {
                        return data.amountexcl;
                    }
                },
                {
                    title: "Vat Rate",
                    name: "vatrate",
                    filterExclude: true,
                    orderable: false,
                    searchable: false,
                    visible: false,
                    data: null,
                    width: "12%",
                    targets: targets + 7,
                    render: function (data) {
                        return data.vatratedescription;
                    }
                },
                {
                    title: "Vat",
                    name: "vatamount",
                    filterExclude: true,
                    orderable: false,
                    searchable: false,
                    visible: false,
                    class: "text-number",
                    data: null,
                    width: "12%",
                    targets: targets + 8,
                    render: function (data) {
                        return 'data.vatamount';
                    }
                },
                {
                    title: "Amount",
                    name: "feenote.amount",
                    filterType: 'Number',
                    class: "text-number",
                    data: null,
                    orderable: false,
                    width: "15%",
                    targets: targets + 9,
                    render: function (data) {
                        return data.amount;
                    }
                },
                {
                    title: "Posted On",
                    name: "feenote.posteddate",
                    filterColumnName: "feenote.posteddate",
                    filterType: 'Date',
                    data: null,
                    orderable: false,
                    width: "12%",
                    targets: targets + 10,
                    render: function (data) {
                        return data.postedflag == '1' ? data.formattedposteddate : '';
                    }
                },

                {
                    title: "Posted",
                    name: 'feenote.postedflag',
                    filterTitle: 'Status',
                    filterType: 'RadioButton',
                    filterControl: 'RadioButton',
                    filterOptions: [{text: 'Posted', value: '1'}, {text: 'UnPosted', value: '0'} ],
                    orderable: false,
                    searchable: false,
                    visible: false,
                    data: null,
                    width: "15%",
                    targets: targets + 11,
                    render: function (data) {
                        return htmlDecode(data.postedflag);
                    }
                },                


            ];
        
            return tableColumnDefs;
        }

    },

}  
</script>
