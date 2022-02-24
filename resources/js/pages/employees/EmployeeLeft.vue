<template>
    <div class="card h-100 border-0">
        <div class="card-header employees-bg">
            <div class="d-flex justify-content-between">
                <h3><i class="fa fa-id-badge mr-2"></i>Employees</h3>
                <page-close-button @closeClicked="closeLeftPage(pageName)"/>
            </div>
        </div>

        <div class="card-body overflow-auto pb-1 pt-3 px-3">

            <employee-table 
                ref="employees-table"
                :lazyLoadFlag="true"
                :tagging="true" 
                formRef="employee-right-employee-form" 
                tableId="employees-table"
            />
            
        </div>

    </div>
</template>     

<script>

import { mapGetters } from 'vuex';
import { mapMutations } from 'vuex';
import leftTemplate from "../left-template";


export default {

    extends: leftTemplate,

    components: {
        EmployeeTable: () => import("./EmployeeTable"),
    },

    data() {
        return {
            tableMounted: false,
            form: null,
            pageName: "Employees",
            selectedRows: [],
            selectedAllFlag: false,
            assembleDocumentsFlag: true,
        };
    },

    computed: {
        ...mapGetters(['leftTabs','activeLeftTabs']),
    },

    watch: {

        tableMounted: function() { this.initializeTable(); },
    },

    mounted() {

        let thisTab = this.leftTabs.filter(tab => tab.pageName === this.pageName);

        if (thisTab.length)  this.displayLeftTab(thisTab[0]);

    },    

    methods: {

        ...mapMutations(['displayLeftTab','hideLeftTab']),

        initializeTable() {

            this.table.loadDataTable(() =>{

                // Used to lazy load the Form (and all its sub components) on the right
                this.$root.employeeLeftTableLoaded = true;

            });

        },


        newRecordButtonClicked() {

            this.form = root.$refs['pages'].$refs["right-page"].$refs['employee-right-employee-form'];

            if ( !this.form.permission('Employees','insert') ) return;

            this.form.insertClicked();

            this.loadPage('Form');
        },


        deleteTaggedRecords() {

            this.tryDeleteTaggedRecords('employees');

        },


    },
}
</script>