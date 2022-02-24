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
        this.url = "/feesheets/get";
        this.route = "feesheets";
        this.title = 'Fee Sheets';
        this.plural = 'Fee Sheets';
        this.singular = 'Fee Sheet';
    },

    methods: {


        defineTableColDefs: function () {

            const targets = this.tagTableFlag ? 1 : 0;

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "fee_sheets.description",
                    data: null,
                    targets: targets + 1,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
            ];            
            return tableColumnDefs;
        }

    },

}  
</script>
