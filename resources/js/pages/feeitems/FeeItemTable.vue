<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <table-options/>
            <button class="btn btn-success btn-sm" title="Add a Fee Item" @click="$parent.addFeeItem">
                <i class="fa fa-plus-square mr-2"></i>Add Item
            </button>
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
        this.url = "/feeitems/get";
        this.route = "feeitems";
        this.title = 'Fee Items';
        this.plural = 'Fee Items';
        this.singular = 'Fee Item';
    },


    methods: {

        editClicked(id) {

            this.$parent.$refs['fee-items-form'].editClicked(id);

        },


        moveFeeItemUp(id) {

            axios.post("/feeitems/move-up",{ id: id })
            
            .then(response => {

                if (response.data.error) {

                    showError( 'Error Moving Fee Item', response.data.error);

                } else {

                    this.$parent.feeItemsTable.table.ajax.reload( () => {

                        $('#' + this.$parent.feeItemsTable.tableId + ' tbody tr.highlighted').removeClass('highlighted');
                        $('#' + this.$parent.feeItemsTable.tableId + ' tbody tr#' + id).addClass('highlighted');

                    });

                }

            });
            
        },


        defineTableColDefs() {

            const targets = this.selectTableFlag ? 1 : 2;

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "fee_items.description",
                    data: null,
                    orderable: false,
                    targets: targets,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "Type",
                    name: "fee_items.type",
                    data: null,
                    orderable: false,
                    width: "12%",
                    targets: targets + 1,
                    render: function (data) {
                        return data.type;
                    }
                },
                {
                    title: "Units",
                    name: "fee_items.unitsDescription",
                    data: null,
                    orderable: false,
                    width: "12%",
                    targets: targets + 2,
                    render: function (data) {
                        return data.unitsDescription;
                    }
                },
                {
                    title: "Net Amount",
                    name: "fee_items.amount",
                    filterType: 'Number',
                    class: "text-number",
                    data: null,
                    orderable: false,
                    visible: true,
                    width: "15%",
                    targets: targets + 3,
                    render: function (data) {
                        return data.amount;
                    }
                },
                {
                    title: root.control.salesTaxType,
                    name: "fee_items.taxAmount",
                    filterType: 'Number',
                    class: "text-number",
                    data: null,
                    orderable: false,
                    width: "12%",
                    targets: targets + 4,
                    render: function (data) {
                        return data.taxAmount;
                    }
                },
                {
                    title: "Amount",
                    name: "fee_items.totalAmount",
                    filterType: 'Number',
                    class: "text-number",
                    data: null,
                    orderable: false,
                    width: "15%",
                    targets: targets + 5,
                    render: function (data) {
                        return data.totalAmount;
                    }
                },

            ];
        
            if (!this.selectTableFlag) {
                
                tableColumnDefs.push(
                {
                    title: "",
                    data: null,
                    class: 'text-center',
                    width: root.screenNarrow ? '10%' : '7%',
                    orderable: false,
                    searchable: false,
                    printable: false,
                    targets: 1,
                    render: (data) => {
                        return parseInt(data.sorter) > 1 ? '<span class="cp" title="Move this Item up" onclick="componentFunction(\'' + this.formComponent + '\',\'moveFeeItemUp\',' + data.id + ')">🔼</span>' : '';
                    }
                });
            }

            return tableColumnDefs;
        }

    },

}  
</script>
