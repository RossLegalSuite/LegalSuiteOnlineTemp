<template>

<div  class="card h-100 border-0">
    
    <div class="card-header">
        <div class="d-flex justify-content-between">
            <h3>Party Roles</h3>
            <page-close-button @closeClicked="hide"/>
        </div>
    </div>

    <div class="card-body overflow-auto p-3">

        <party-role-table
            table-id="settings-party-role-table"
            :lazyLoadFlag="true"
            ref="settings-party-role-table"
            formRef="settings-party-role-form"
        />

    </div>

    <party-role-form 
        :id="_uid + '-settings-party-role-form'"
        ref="settings-party-role-form" 
        parentTableRef="settings-party-role-table"
        :modal="true"
    />

</div>
    
</template>

<script>

export default {

    components: {
        PartyRoleTable: () => import("@pages/parties/PartyRoleTable"),
        PartyRoleForm: () => import("@pages/parties/PartyRoleForm"),
    },


    data() {
        return {
            activePage: 'PartyRoles',
            table: null,
        }
    },    

    methods: {

        hide() {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].closePage(this.activePage);

        },


        newRecordButtonClicked: function () {

            this.$refs['settings-party-role-form'].table = this.table;

            this.$refs['settings-party-role-form'].insertClicked();

        },

    },    

}
</script>