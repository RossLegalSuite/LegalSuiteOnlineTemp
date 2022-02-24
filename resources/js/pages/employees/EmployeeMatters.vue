<template>
    <div class="card h-100 border-0">
        <div class="card-header">
            <div class="d-flex justify-content-between">
                <h3 class="page-title"><i class="fa fa-briefcase mr-3"></i>Matters: <span v-html="pageTitle()"></span></h3>
                <page-close-button @closeClicked="closeClicked"/>
            </div>
        </div>

        <div class="card-body overflow-auto p-3">

            <employee-matters-table 
                ref="employee-matters-table" 
                table-id="employee-matters-table"
                :lazy-load-flag="true"
            />

        </div>
    </div>
</template>  

<script>

import { mapGetters } from 'vuex';

export default {

    components: {
        EmployeeMattersTable: () => import("./EmployeeMattersTable"),
    },

    props: {
        parentType: String,
    },

    computed: {
        ...mapGetters(['currentEmployee']),
    },

    methods: {

        pageTitle() {
            
            return (this.currentEmployee.name) ? this.currentEmployee.name : '';

        },

        closeClicked() { 

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].clearPages();

        },

    },
}
</script> 