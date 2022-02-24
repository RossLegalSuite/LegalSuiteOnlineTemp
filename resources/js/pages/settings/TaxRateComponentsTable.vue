<template>

<section>

    <div class="d-flex justify-content-between table-functions-row">

        <global-search/>
        <div>
            <new-record-button type="button" :title="'Create a new ' + singular" :text="'New ' + singular"/>
        </div>
    </div>

    <table :id="tableId" class="table bordered" style="width:100%"></table>

</section>
</template>

<script>

import tableTemplate from "@components/tables/table-template";

export default {

    mixins: [tableTemplate],

    data() {
        return {
            taxRateId: null,
        };
    },

    created() {
        this.url = "/taxratecomponents/get";
        this.route = "taxratecomponents";
        this.title = 'Components';
        this.plural = 'Components';
        this.singular = 'Component';
    },

    methods: {


        editRecord(id) {


        },


        defineTableColDefs() {
            


            let target = 1;

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "tax_components.description",
                    data: null,
                    targets: target,
                    render: function (data) {
                        return htmlDecode(data.component_description);
                    }
                },
                {
                    title: "Rate",
                    name: "tax_components.rate",
                    class: "searchable text-right",
                    data: null,
                    targets: 2,
                    render: function (data) {
                        return data.component_rate + '%';
                    },
                },


            ];

            return tableColumnDefs;

        }

    },



}  
</script>