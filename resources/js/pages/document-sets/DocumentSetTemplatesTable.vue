<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <table-options/>
            <new-record-button type="button" :title="'Create a new ' + singular" :text="'New ' + singular"/>
        </div>

    </div>

    <table :id="tableId" class="table bordered" style="width:100%"></table>
    <table-footer ref="tableFooter"/>

</div>
</template>

<script>

import tableTemplate from "@components/tables/table-template";

export default {

    mixins: [tableTemplate],

    created() {
        this.url = "/document_templates/get";
        this.route = "document_templates";
        this.title = 'Templates';
        this.plural = 'Templates';
        this.singular = 'Template';
    },

    methods: {


/*
        selectRecord(id) {

            this.$parent.selectedRows.push(id);

            this.$parent.selectClicked();

        },

        editClicked(id) {

            axios.post('/document_templates/get',{recordid: id})

            .then(response => {
                
                let data = response.data.data[0];

                this.$root.previewPdf.title = 'Document Set Template: ' + data.description;

                this.$root.previewPdf.document = data;

                this.$root.previewPdf.documentPath = data.pdfFile; //Being watched: To load the iFrame

                this.$root.previewPdf.show();

            });

        },        
        
*/
        defineTableColDefs: function () {
            
            let tableColumnDefs = [
                {
                    title: "Title",
                    name: "document_templates.title",
                    data: null,
                    targets: 1,
                    render: function (data) {
                        return htmlDecode(data.title);
                    }
                },
                {
                    title: "Description",
                    name: "document_templates.description",
                    data: null,
                    targets: 2,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "Template",
                    name: "document_templates.fileName",
                    data: null,
                    targets: 3,
                    render: (data) => {

                        // Fix because this table is shared between DocumentLeft.vue and SelectDocuments.vue
                        if (this.setButtonText === 'Select') {
                            return lookupWrapper('Select Document Template', data.id, data.fileName);
                        } else {
                            return lookupWrapper('Document Template', data.id, data.fileName);
                        }
                    }
                },
                // {
                //     title: "pdfFile",
                //     data: null,
                //     visible: false,
                //     searchable: false,
                //     targets: 4,
                //     render: function (data) {
                //         return data.pdfFile;
                //     }
                // },

            ];
        
        
            return tableColumnDefs;
        }

    },    

}  
</script>
