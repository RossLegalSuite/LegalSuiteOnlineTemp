<template>

<div  class="card h-100 border-0">
    
    <div class="card-header">
        <div class="d-flex justify-content-between">
            <h3>Components</h3>
            <page-close-button @closeClicked="hide"/>
        </div>
    </div>

    <div class="card-body overflow-auto p-3">

        <system-components-table
            table-id="settings-system-components-table"
            :lazyLoadFlag="true"
            ref="settings-system-components-table"
            formRef="settings-system-components-form"
        />

    </div>

    <system-components-form 
        :id="_uid + '-settings-system-components-form'"
        ref="settings-system-components-form" 
        parentTableRef="settings-system-components-table"
        :modal="true"
    />

</div>
    
</template>

<script>

export default {

    components: {
        SystemComponentsTable: () => import("@pages/system-components/SystemComponentsTable"),
        SystemComponentsForm: () => import("@pages/system-components/SystemComponentsForm"),
    },


    data() {
        return {
            activePage: 'System Components',
            table: null,
        }
    },    

    methods: {

        hide() {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].closePage(this.activePage);

        },


        newRecordButtonClicked: function () {

            this.$refs['settings-system-components-form'].table = this.table;

            this.$refs['settings-system-components-form'].insertClicked();

        },

    },    

}
</script>