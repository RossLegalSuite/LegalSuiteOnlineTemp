<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <table-options/>
            <new-record-button v-if="newRecordButton" type="button" :title="'Create a new ' + singular" :text="'New ' + singular"/>
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
        this.url = "/lolcomponent/get";
        this.route = "components";
        this.title = 'Components';
        this.plural = 'Components';
        this.singular = 'Component';
        this.tableName = 'lolcomponent';
    },

    methods: {
        
        defineTableColDefs: function () {

            let tableColumnDefs = [
                {
                    title: "Title",
                    name: "title",
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
                    targets: 2,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "Data Source",
                    name: "source",
                    data: null,
                    targets: 3,
                    render: function (data) {
                        return data.source;
                    }
                },
                // {
                //     title: "",
                //     visible: false,
                //     searchable: false,
                //     filterExclude: true,
                //     name: "contents",
                //     data: null,
                //     targets: 4,
                //     render: function (data) {
                //         return data.contents;
                //     }
                // },


            ];
        
            return tableColumnDefs;
        }

    },    

}  
</script>
