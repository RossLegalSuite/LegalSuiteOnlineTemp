<template>

<div  class="card h-100 border-0">
    
    <div class="card-header">
        <div class="d-flex justify-content-between">
            <h3>Branches</h3>
            <page-close-button @closeClicked="hide"/>
        </div>
    </div>

    <div class="card-body overflow-auto p-3">

        <branch-table
            table-id="settings-branch-table"
            :lazyLoadFlag="true"
            ref="settings-branch-table"
            :formRef="'settings-branch-form'"
        />

    </div>

    <branch-form 
        :id="_uid + '-settings-branch-form'"
        ref="settings-branch-form" 
        parentTableRef="settings-branch-table"
        :modal="true"
    />

</div>
    
</template>

<script>

export default {

    components: {
        BranchTable: () => import("@pages/matters/BranchTable"),
        BranchForm: () => import("@pages/matters/BranchForm"),
    },


    data() {
        return {
            activePage: 'Branches',
            table: null,
        }
    },    

    methods: {

        hide() {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].closePage(this.activePage);

        },


        newRecordButtonClicked: function () {

            this.$refs['settings-branch-form'].table = this.table;

            this.$refs['settings-branch-form'].insertClicked();

        },

    },    

}
</script>