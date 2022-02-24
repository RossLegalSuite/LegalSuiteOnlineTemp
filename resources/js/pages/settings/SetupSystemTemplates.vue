<template>

<div  class="card h-100 border-0">
    
    <div class="card-header">
        <div class="d-flex justify-content-between">
            <h3>Templates</h3>
            <page-close-button @closeClicked="hide"/>
        </div>
    </div>

    <div class="card-body overflow-auto p-3">

        <system-templates-table
            table-id="settings-system-templates-table"
            :lazyLoadFlag="true"
            ref="settings-system-templates-table"
            formRef="settings-system-templates-form"
        />

    </div>

    <system-templates-form 
        :id="_uid + '-settings-system-templates-form'"
        ref="settings-system-templates-form" 
        parentTableRef="settings-system-templates-table"
        :modal="true"
    />

</div>
    
</template>

<script>

export default {

    components: {
        SystemTemplatesTable: () => import("@pages/system-templates/SystemTemplatesTable"),
        SystemTemplatesForm: () => import("@pages/system-templates/SystemTemplatesForm"),
    },


    data() {
        return {
            activePage: 'System Templates',
            table: null,
        }
    },    

    methods: {

        hide() {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].closePage(this.activePage);

        },


        newRecordButtonClicked: function () {

            this.$refs['settings-system-templates-form'].table = this.table;

            this.$refs['settings-system-templates-form'].insertClicked();

        },

    },    

}
</script>