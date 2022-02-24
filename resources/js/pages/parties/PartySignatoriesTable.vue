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
        this.url = "/parsign/get";
        this.route = "parsign";
        this.title = 'Signatories';
        this.plural = 'Signatories';
        this.singular = 'Signatory';
        this.tableName = 'parsign';
    },

    methods: {

        defineTableColDefs() {

            const targets = this.selectTableFlag ? 1 : 0;

            let tableColumnDefs = [
                {
                    title: "First Name",
                    name: "parsign.firstname",
                    data: null,
                    targets: targets,
                    render: function (data) {
                        return htmlDecode(data.firstname);
                    }
                },
                {
                    title: "Last Name",
                    name: "parsign.lastname",
                    data: null,
                    targets: targets + 1,
                    render: function (data) {
                        return htmlDecode(data.lastname);
                    }
                },
                {
                    title: "Position",
                    name: "parsign.position",
                    data: null,
                    targets: targets + 2,
                    render: function (data) {
                        return htmlDecode(data.position);
                    }
                },

            ];
        
            return tableColumnDefs;
        }

    },

}  
</script>
