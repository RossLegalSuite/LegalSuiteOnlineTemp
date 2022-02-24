<template>
<div>

    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <div class="v-select-15">
                <v-select 
                    :options="feeSheets" 
                    label="description"
                    :clearable="false"
                    :searchable="false"
                    v-model="feeSheetId"
                    :reduce="feeSheets => feeSheets.recordid"
                />
            </div>
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
        this.url = "/feecode/get";
        this.route = "feecode";
        this.tableName = "feecode";
        this.title = 'Fee Codes';
        this.plural = 'Fee Codes';
        this.singular = 'Fee Code';
    },

    data() {
        return {
            feeSheets: root.feeSheets,
            feeSheetId: null,
        }
    },

    watch: {

        feeSheetId(newValue) {

            // Clears the tags without reloading the table with ajax.reload()
            resetTagged(this.$parent);

            // Set the whereRaw clause
            this.whereRaw = 'feesheetid = ' + newValue;

            // Load the table
            this.loadDataTable();

        },

    },



    methods: {

        editClicked(id) {

            this.$parent.$refs['fee-codes-form'].editClicked(id);

        },

        defineTableColDefs() {

            const targets = this.selectTableFlag ? 2 : 1;

            let tableColumnDefs = [
                {
                    title: "Code",
                    name: "feecode.code",
                    width: '20%',
                    data: null,
                    targets: targets,
                    render: (data) => { 
                        if (this.selectTableFlag) {
                            return lookupWrapper('Fee Code', data.recordid, htmlDecode(data.code));
                        } else {
                            return htmlDecode(data.code);
                        }
                    }
                },
                {
                    title: "Description",
                    name: "feecode.description",
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
