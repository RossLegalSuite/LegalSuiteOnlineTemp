<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <filter-form-button/>
            <table-options/>
            <new-record-button v-if="newRecordButton" type="button" :title="'Create a new ' + singular" :text="'New ' + singular"/>
        </div>

    </div>

    <table :id="tableId" class="table bordered" style="width:100%"></table>
    <table-footer ref="tableFooter"/>

    <system-templates-filter-form
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
        SystemTemplatesFilterForm: () => import("./SystemTemplatesFilterForm"),
    },


    created() {
        this.url = "/lolsystemtemplate/get";
        this.route = "templates";
        this.title = 'Templates';
        this.plural = 'Templates';
        this.singular = 'Template';
        this.tableName = 'lolsystemtemplate';
    },

    methods: {
        
        defineTableColDefs: function () {

            let tableColumnDefs = [
                {
                    title: "Title",
                    name: "title",
                    width: "25%",
                    data: null,
                    targets: 1,
                    render: function (data) {
                        return htmlDecode(data.title);
                    }
                },
                {
                    title: "Description",
                    name: "description",
                    data: null,
                    width: "40%",
                    targets: 2,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "Type",
                    visible: true,
                    searchable: true,
                    filterExclude: false,
                    name: "type",
                    width: "12%",
                    data: null,
                    targets: 3,
                    render: function (data) {
                        return data.type;
                    }
                },
                {
                    title: "Source",
                    visible: false,
                    searchable: true,
                    filterExclude: false,
                    name: "source",
                    width: "12%",
                    data: null,
                    targets: 4,
                    render: function (data) {
                        return data.source;
                    }
                },
                {
                    title: "Role",
                    visible: false,
                    searchable: true,
                    filterExclude: false,
                    name: "roleid",
                    width: "12%",
                    data: null,
                    targets: 5,
                    render: function (data) {
                        return data?.roledescription ? data.roledescription : '';
                    }
                }

            ];


            return tableColumnDefs;
        }

    },    

}  
</script>
