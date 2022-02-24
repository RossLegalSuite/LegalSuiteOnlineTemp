<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <div class="v-select-15">
                <v-select 
                    :options="stageGroups" 
                    label="description"
                    :clearable="false"
                    :searchable="false"
                    v-model="stageGroupId"
                    :reduce="stageGroups => stageGroups.recordid"
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
        this.url = "/stage/get";
        this.route = "stages";
        this.title = 'Stages';
        this.plural = 'Stages';
        this.singular = 'Stage';
        this.select = ['stage.recordid','stage.description','stage.code'];
        this.tableName = 'stage';
    },

    data() {
        return {
            stageGroups: root.stageGroups,
            stageGroupId: null,
        }
    },

    watch: {

        stageGroupId(newValue) {

            // Set the whereRaw clause
            this.whereRaw = 'stagegroupid = ' + newValue;

            // Load the table
            this.loadDataTable();

        },

    },


    methods: {

        defineTableColDefs() {

            let tableColumnDefs = [
                {
                    title: "Code",
                    name: "stage.code",
                    data: null,
                    width: '20%',
                    targets: 1,
                    render: function (data) {
                        return data.code;
                    }
                },
                {
                    title: "Description",
                    name: "stage.Description",
                    data: null,
                    width: '70%',
                    targets: 2,
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
