<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <tagged-drop-down v-if="taggedDropDown" :table-id="tableId"/>
            <filter-form-button/>
            <table-options/>
            <new-record-button type="button" :title="'Create a new ' + singular" :text="'New ' + singular"/>

        </div>

    </div>

    <table :id="tableId" class="table bordered" style="width:100%"/>
    <table-footer/>

    <file-note-filter-form
        :id="tableId + '-filter-form'"
        :ref="tableId + '-filter-form'"
    />

</div>
</template>

<script>

import tableTemplate from "@components/tables/table-template";

export default {

    mixins: [tableTemplate],

    components: {
        FileNoteFilterForm: () => import("./FileNoteFilterForm"),
    },

    created() {
        this.url = "/filenote/get";
        this.route = "filenote";
        this.tableName = 'filenote';
        this.title = 'File Notes';
        this.plural = 'File Notes';
        this.singular = 'File Note';
    },

    methods: {

        defineTableColDefs() {

            const targets = this.tagTableFlag ? 1 : 0;
            const parentColumnVisible = this.parentType === 'General' ? true : false;

            let tableColumnDefs = [
                {
                    title: "Date",
                    name: "filenote.date",
                    filterColumnName: "filenote.date",
                    filterType: 'Date',
                    data: null,
                    width: "12%",
                    targets: targets + 1,
                    render: function (data) {
                        return data.formatteddate;
                    }
                },
                {
                    title: "Time",
                    name: "filenote.time",
                    filterExclude: true,
                    searchable: false,
                    orderable: false,
                    visible: false,
                    data: null,
                    width: "12%",
                    targets: targets + 2,
                    render: function (data) {
                        return data.time;
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
                    title: "Stage",
                    name: "stage.code",
                    data: null,
                    filterExclude: true,
                    orderable: false,
                    searchable: false,
                    width: "10%",
                    targets: targets + 4,
                    render: function (data) {
                        return data.stagecode;
                    }
                },
                {
                    title: "Description",
                    name: "filenote.description",
                    data: null,
                    orderable: false,
                    width: "35%",
                    targets: targets + 5,
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
                    targets: targets + 6,
                    render: function (data) {
                        return htmlDecode(data.employeename);
                    }
                },   

            ];
        
            return tableColumnDefs;
        }

    },

}  
</script>
