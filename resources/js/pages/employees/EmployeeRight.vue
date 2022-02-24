<template>
<span>
    <section v-if="$root.employeeLeftTableLoaded">

        <employee-form 
            v-show="activePage === 'Form'" 
            ref="employee-right-employee-form"
            id="employee-right-employee-form"
            leftPageTableRef="employees-table"
            :modal="false"
            uniqueId="employee-right"
        />

        <employee-matters v-show="activePage === 'Matters'"  parentType="Employee" ref="employee-right-employee-matters"/>

        <common-fee-notes v-show="activePage === 'FeeNotes'"  parentType="Employee" ref="employee-right-employee-fee-notes"/>

        <common-file-notes v-show="activePage === 'FileNotes'" parentType="Employee" ref="employee-right-employee-file-notes"/>

        <common-reminders v-show="activePage === 'Reminders'" parentType="Employee" ref="employee-right-employee-reminders"/>

        <common-documents v-show="activePage === 'Documents'" parentType="Employee" ref="employee-right-employee-documents"/>

    </section>

</span>

</template>

<script>

import { mapGetters } from 'vuex';

export default {


    components: {
        EmployeeForm: () => import("./EmployeeForm"),
        EmployeeMatters: () => import("./EmployeeMatters"),
        CommonDocuments: () => import("@pages/common/Documents"),
        CommonFeeNotes: () => import("@pages/common/FeeNotes"),
        CommonFileNotes: () => import("@pages/common/FileNotes"),
        CommonReminders: () => import("@pages/common/Reminders"),

    },

    data() {
        return {
            activePage: null,
        }
    },

    computed: {

        ...mapGetters(['currentEmployee']),

    },


    watch: {
        
        activePage(newValue) {

            let thisTable = null;

            if ( newValue === "Matters") {

                thisTable = this.$refs['employee-right-employee-matters'].table;

                setTimeout(() => {

                    thisTable.employeeId = this.currentEmployee.id;
                    thisTable.subTitle = this.currentEmployee.name;
                    thisTable.loadDataTable();

                });

            } else if ( newValue === "FeeNotes") {

                thisTable = this.$refs['employee-right-employee-fee-notes'].table;

                setTimeout(() => {

                    thisTable.employeeId = this.currentEmployee.id;
                    thisTable.subTitle = this.currentEmployee.name;
                    thisTable.loadDataTable();

                });

            } else if ( newValue === "FileNotes") {

                thisTable = this.$refs['employee-right-employee-file-notes'].table;

                setTimeout(() => {

                    thisTable.employeeId = this.currentEmployee.id;
                    thisTable.subTitle = this.currentEmployee.name;
                    thisTable.loadDataTable();

                });

            } else if ( newValue === "Reminders") {

                thisTable = this.$refs['employee-right-employee-reminders'].table;

                setTimeout(() => {

                    thisTable.targetEmployeeId = this.currentEmployee.id;
                    thisTable.subTitle = this.currentEmployee.name;
                    thisTable.loadDataTable();

                });

            } else if ( newValue === "Documents") {

                thisTable = this.$refs['employee-right-employee-documents'].table;

                setTimeout(() => {

                    thisTable.employeeId = this.currentEmployee.id;
                    thisTable.subTitle = this.currentEmployee.name;
                    thisTable.viewTableFlag = true;
                    thisTable.loadDataTable();

                });


            }
            
        }
    },



}

</script>