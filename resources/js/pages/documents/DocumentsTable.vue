<template>
<span>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <documents-tagged-drop-down :table-id="tableId"/>
            <table-options/>
        </div>

    </div>

    <table :id="tableId" class="table bordered" style="width:100%"/>
    <table-footer/>

</span>
</template>

<script>

import tableTemplate from "@components/tables/table-template";

export default {

    mixins: [tableTemplate],

    components: {
        DocumentsTaggedDropDown: () => import("./DocumentsTaggedDropDown"),
    },


    created() {
        this.url = "/doclog/get";
        this.route = 'documents';
        this.tableName = 'doclog';
        this.title = 'Generated Documents';
        this.plural = 'Documents';
        this.singular = 'Document';
    },



    methods: {
        
        defineTableColDefs() {

            const targets = this.tagTableFlag ? 1 : 0;

            const matterColumnVisible = this.source == 'Matter' ? true : false;
            const partyColumnVisible = this.source == 'Party' ? true : false;

            let tableColumnDefs = [
                {
                    title: "Date",
                    name: "date",
                    filterColumnName: "doclog.date",
                    filterType: 'Date',
                    data: null,
                    width: "12%",
                    targets: targets + 1,
                    render: function (data) {
                        return data.formatteddate;
                    }
                },

                {
                    title: "Party",
                    name: "party.matterprefix",
                    data: null,
                    width: '25%',
                    visible: partyColumnVisible,
                    targets: targets + 2,
                    render: function (data) {
                        return data.partymatterprefix + ' - ' + data.partyname;
                    }
                },

                {
                    title: "Matter",
                    name: "matter.fileref",
                    data: null,
                    width: '35%',
                    visible: matterColumnVisible,
                    targets: targets + 3,
                    render: function (data) {
                        return data.matterfileref + ' - ' + data.matterdescription;
                    }
                },                

                {
                    title: "Description",
                    name: "doclog.description",
                    data: null,
                    width: "45%",
                    targets: targets + 4,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "",
                    searchable: false,
                    visible: false,
                    filterExclude: true,
                    name: "doclog.url",
                    data: null,
                    targets: targets + 5,
                    render: function (data) {
                        return data.url;
                    }
                },
                {
                    title: "",
                    searchable: false,
                    visible: false,
                    filterExclude: true,
                    name: "doclog.savedname",
                    data: null,
                    targets: targets + 6,
                    render: function (data) {
                        return data.savedname;
                    }
                },
                {
                    title: "",
                    searchable: false,
                    visible: false,
                    filterExclude: true,
                    name: "doclog.emailfolder",
                    data: null,
                    targets: targets + 7,
                    render: function (data) {
                        return data.emailfolder;
                    }
                },
                {
                    title: "",
                    searchable: false,
                    visible: false,
                    filterExclude: true,
                    name: "doclog.recordid",
                    data: null,
                    targets: targets + 7,
                    render: function (data) {
                        return data.recordid;
                    }
                },


            ];

            /*if ( this.source == 'Matter') {
                
                tableColumnDefs.push({
                    title: "Matter",
                    name: "matter.fileref",
                    data: null,
                    width: '25%',
                    targets: targets + 2,
                    render: function (data) {
                        return data.matterfileref + ' - ' + data.matterdescription;
                    }
                });

            } else if ( this.source == 'Party') {
                
                tableColumnDefs.push({
                    title: "Party",
                    name: "party.matterprefix",
                    data: null,
                    width: '25%',
                    targets: targets + 2,
                    render: function (data) {
                        return data.partymatterprefix + ' - ' + data.partyname;
                    }
                });
            }

            console.log("source",this.source);
            console.log("tableColumnDefs",tableColumnDefs);*/

            return tableColumnDefs;
        }

    },

}  
</script>
