<template>




<div  class="card h-100 border-0">
    
    <div class="card-header">
        <div class="d-flex justify-content-between">
            <h3>Employee Groups</h3>
            <page-close-button @closeClicked="hide"/>
        </div>
    </div>

    <div class="card-body overflow-auto p-3">

        <employee-group-table
            table-id="settings-employee-group-table"
            :lazyLoadFlag="true"
            ref="settings-employee-group-table"
            :formRef="'settings-employee-group-form'"
        />

    </div>

    <employee-group-form 
        :id="_uid + '-settings-employee-group-form'"
        ref="settings-employee-group-form" 
        parentTableRef="settings-employee-group-table"
        :modal="true"
    />

</div>
    
</template>

<script>

export default {

    components: {
        EmployeeGroupTable: () => import("@pages/employees/groups/EmployeeGroupTable"),
        EmployeeGroupForm: () => import("@pages/employees/groups/EmployeeGroupForm"),
    },


    data() {
        return {
            activePage: 'EmployeeGroups',
            table: null,
        }
    },    

    methods: {

        hide() {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].closePage(this.activePage);

        },

        newRecordButtonClicked: function () {

            this.$refs['settings-employee-group-form'].table = this.table;

            this.$refs['settings-employee-group-form'].insertClicked();

        },

    },    

}
</script>