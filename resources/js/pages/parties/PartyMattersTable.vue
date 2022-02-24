<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <table-options/>
        </div>
    </div>

    <table :id="tableId" class="table bordered" style="width:100%"></table>
    <table-footer/>

</div>
</template>

<script>

import tableTemplate from "@components/tables/table-template";


export default {

    mixins: [tableTemplate],

    created() {
        this.url = "/matparty/get";
        this.route = "matparty";
        this.tableName = 'matparty';
        this.title = 'Parties';
        this.plural = 'Parties';
        this.singular = 'Party';
    },

    methods: {

        defineTableColDefs() {
            
            let targets = this.tagTableFlag ? 1 : 0;

            let tableColumnDefs = [
                {
                    title: "Matter",
                    name: 'matter.fileref',
                    filterExclude: true,
                    orderable: false,
                    data: null,
                    width: "60%",
                    targets: targets,
                    render: function (data) {
                        return htmlDecode(data.parentlink);
                    }
                },                
                {
                    title: "Role",
                    name: "role.description",
                    data: null,
                    orderable: false,
                    targets: targets + 1,
                    render: function (data) {

                        let sorterIndicator = '';

                        if ( parseInt(data.sorter) > 1 ) {
                            sorterIndicator = ' (' + data.sorter + ')';
                        }

                        return htmlDecode(data.roledescription) + sorterIndicator;

                    }
                },
                {
                    title: "Reference",
                    name: "matparty.reference",
                    data: null,
                    orderable: false,
                    targets: targets + 2,
                    render: function (data) {
                        return htmlDecode(data.reference);
                    }
                },
            ];

            return tableColumnDefs;
        }

    },

}  
</script>
