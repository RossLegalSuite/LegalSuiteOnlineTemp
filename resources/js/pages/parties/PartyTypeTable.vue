<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <table-options/>
            <new-record-button v-if="newRecordButton" type="button" :title="'Create a new ' + singular" text="Add"/>
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
        this.url = "/partype/get";
        this.route = "partype";
        this.title = 'Types';
        this.plural = 'Types';
        this.singular = 'Type';
        this.select = ['partype.recordid','partype.description','partype.category'];
        this.tableName = 'partype';
    },


    methods: {

        defineTableColDefs() {

            const targets = this.selectTableFlag ? 1 : 2;

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "partype.description",
                    data: null,
                    targets: targets,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "Type",
                    name: "partype.type",
                    data: null,
                    targets: targets + 1,
                    render: function (data) {
                        return data.type === 'N' ? 'Person' : 'Juristic';
                    }
                },

            ];

            if (!this.selectTableFlag) {
                
                tableColumnDefs.push(
                {
                    title: "Code",
                    name: "party_types.code",
                    width: '15%',
                    data: null,
                    targets: 1,
                    render: function (data) {
                        return htmlDecode(data.code);
                    }
                });
            }

            return tableColumnDefs;
        }

    },



}  
</script>
