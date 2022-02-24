<template>

<div  class="card h-100 border-0">
    
    <div class="card-header">
        <div class="d-flex justify-content-between">
            <h3>Units</h3>
            <page-close-button @closeClicked="hide"/>
        </div>
    </div>

    <div class="card-body overflow-auto p-3">

        <fee-unit-table
            table-id="settings-fee-unit-table"
            :lazyLoadFlag="true"
            ref="settings-fee-unit-table"
            :formRef="'settings-fee-unit-form'"
        />

    </div>

    <fee-unit-form 
        :id="_uid + '-settings-fee-unit-form'"
        ref="settings-fee-unit-form" 
        parentTableRef="settings-fee-unit-table"
        :modal="true"
    />

</div>
    
</template>

<script>

export default {

    components: {
        FeeUnitTable: () => import("@pages/feeunits/FeeUnitTable"),
        FeeUnitForm: () => import("@pages/feeunits/FeeUnitForm"),
    },


    data() {
        return {
            activePage: 'FeeUnits',
            table: null,
        }
    },    

    methods: {

        hide() {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].closePage(this.activePage);

        },


        newRecordButtonClicked: function () {

            this.$refs['settings-fee-unit-form'].table = this.table;

            this.$refs['settings-fee-unit-form'].insertClicked();

        },

    },    

}
</script>