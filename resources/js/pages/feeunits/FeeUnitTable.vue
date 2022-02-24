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
        this.url = "/feeunits/get";
        this.route = "feeunits";
        this.title = 'Units';
        this.plural = 'Units';
        this.singular = 'Unit';
    },


    methods: {

        defineTableColDefs() {

            const targets = this.selectTableFlag ? 1 : 2;

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "fee_units.description",
                    data: null,
                    targets: targets,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },

            ];
        
            if (!this.selectTableFlag) {
                
                tableColumnDefs.push(
                {
                    title: "Code",
                    name: "fee_units.code",
                    width: '20%',
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
