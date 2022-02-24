<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <table-options/>
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
        this.url = "/docgen/get";
        this.route = "document_sets";
        this.title = 'Document Sets';
        this.plural = 'Document Sets';
        this.singular = 'Document Set';
        this.tableName = 'docgen';
    },

    methods: {

        defineTableColDefs() {

            let tableColumnDefs = [
                {
                    title: "Code",
                    name: "docgen.code",
                    data: null,
                    width: "20%",
                    targets: 1,
                    render: function (data) {
                        return htmlDecode(data.code);
                    }
                },
                {
                    title: "Description",
                    name: "docgen.description",
                    data: null,
                    targets: 2,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "",
                    visible: false,
                    searchable: false,
                    filterExclude: true,
                    name: "docgen.todogroupid",
                    data: null,
                    targets: 3,
                    render: (data) => {
                        return data.todogroupid;
                    }
                },
                {
                    title: "",
                    visible: false,
                    searchable: false,
                    filterExclude: true,
                    name: "todogroup.description",
                    data: null,
                    targets: 4,
                    render: (data) => {
                        return data.todogroupdescription;
                    }
                },
            ];
        
            return tableColumnDefs;
        }

    },



}  
</script>
