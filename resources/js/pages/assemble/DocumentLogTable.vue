<template>

<section>
    <div class="d-flex justify-content-between table-functions-row">

        <global-search/>

        <div>
            <document-log-table-actions :table-id="tableId"/>
            <table-options :tableId="tableId"/>
        </div>

    </div>

    <table :id="tableId" class="table bordered" style="width:100%"></table>

</section>
</template>

<script>

import tableTemplate from "@components/tables/table-template";

export default {

    mixins: [tableTemplate],

    components: {
        DocumentLogTableActions: () => import("./DocumentLogTableActions"),
    },

    created() {
        this.url = "/correspondence/get";
        this.route = "correspondence";
        this.title = 'Documents';
        this.plural = 'Documents';
        this.singular = 'Document';
    },

    methods: {

        selectRecord(id) {

            this.highlightRow(id);

            let data = this.table.row( '#' + id ).data();

            this.$root.previewPdf.title = data.description + ' (' + (data.matter || data.party || data.employeeName || 'General Correspondence') + ')';

            this.$root.previewPdf.document = data;

            this.$root.previewPdf.documentPath = data.url; //Being watched: To load the iFrame

            this.$root.previewPdf.show();

        },

        defineTableColDefs() {
            
            let tableColumnDefs = [

                {
                    title: "Created",
                    name: "date",
                    width: "25%",
                    data: null,
                    targets: 2,
                    render: function (data) {
                        return data.dateFormatted;
                    }
                },
                {
                    title: "Document",
                    name: "description",
                    width: "30%",
                    data: null,
                    targets: 3,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "Location",
                    searchable: false,
                    orderable: false,
                    width: "25%",
                    data: null,
                    targets: 4,
                    render: function (data) {
                        return htmlDecode(data.matter || data.party || data.employeeName || 'General Correspondence');
                    }
                },
                // {
                //     title: "File Name",
                //     name: "fileName",
                //     data: null,
                //     visible: false,
                //     targets: 5,
                //     render: function (data) {
                //         return data.fileName;
                //     }
                // },
                // {
                //     title: "Path",
                //     data: null,
                //     visible: false,
                //     searchable: false,
                //     targets: 6,
                //     render: function (data) {
                //         return data.path;
                //     }
                // },
                // {
                //     title: "Url",
                //     data: null,
                //     visible: false,
                //     searchable: false,
                //     targets: 7,
                //     render: function (data) {
                //         return data.url;
                //     }
                // },

            ];

            return tableColumnDefs;

        }

    },

}  
</script>