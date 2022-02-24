<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <table-options v-if="optionsButton"/>
            <new-record-button v-if="newRecordButton" type="button" :title="'Create a new ' + singular" 
            :text="'New ' + singular"
            callback="newTaxRate" @newTaxRate="newTaxRate"
            />
        </div>

    </div>

    <table :id="tableId" class="table bordered" style="width:100%"></table>

</div>
</template>

<script>

import tableTemplate from "@components/tables/table-template";


export default {

    mixins: [tableTemplate],

    props: {
        optionsButton: {
            type: Boolean,
            default: false,
        },
    },

    created() {
        this.url = "/taxrates/get";
        this.route = "taxrates";
        this.title = 'Rates';
        this.plural = 'Rates';
        this.singular = 'Rate';
    },

    methods: {
        
        newTaxRate() {

            this.$parent.$refs['tax-rates-form'].insertClicked();

        },


        defineTableColDefs() {
            
            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "tax_rates.description",
                    data: null,
                    targets: 1,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "Rate",
                    name: "tax_rates.rate",
                    class: "text-right",
                    data: null,
                    targets: 2,
                    render: function (data) {
                        return data.rate + '%';
                    },
                },

            ];
        
        
            return tableColumnDefs;
        }

    },    

}  
</script>
