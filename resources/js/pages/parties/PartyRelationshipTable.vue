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
        this.url = "/parrel/get";
        this.route = "parrel";
        this.title = 'Parties';
        this.plural = 'Parties';
        this.singular = 'Party';
        this.tableName = 'parrel';

        //FORMAT('12L|MI@n3@200L(2)|M~Document~@s250@58L(2)|M~Document Date~@d17b@55L(2)|M~Expires~@s19@996L(2)|M~Comments~@s249@/'),FROM(Queue:Browse:8)

    },

    methods: {

        defineTableColDefs() {

            const targets = this.selectTableFlag ? 1 : 0;

            let tableColumnDefs = [
                // {
                //     title: "Document",
                //     name: "parrel.description",
                //     data: null,
                //     targets: targets,
                //     render: function (data) {
                //         return htmlDecode(data.description);
                //     }
                // },
                {
                    title: "Document Date",
                    name: "parrel.date",
                    orderable: false,
                    data: null,
                    width: "20%",
                    targets: targets,
                    render: function (data) {
                        return data.date; //data.formatteddate;
                    }
                },
                // {
                //     title: "Expires",
                //     name: "ficaitem.expiry",
                //     orderable: false,
                //     data: null,
                //     width: "20%",
                //     targets: targets + 2,
                //     render: function (data) {
                //         return 'To Do';
                //     }
                // },
                {
                    title: "Comments",
                    name: "parrel.comments",
                    data: null,
                    targets: targets + 1,
                    render: function (data) {
                        return htmlDecode(data.comments);
                    }
                },

            ];
        
            return tableColumnDefs;
        }

    },



}  
</script>
