<template>
<section>
    <div class="modal" :id="id">

        <div class="modal-dialog modal-dialog-left modal-lg">

            <div class="modal-content" style="border-color:indianred">

                <div class="modal-header indianred">
                    <h2 class="modal-title page-title">Select an Employee Group</h2>
                    <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                </div>

                <div class="modal-body p-3" style="height: 60vh; overflow-y: auto;">
                    
                    <employee-group-table
                    :options-button="false"
                    :table-id="id + '-table'"
                    :lazyLoadFlag="true"
                    ref="select-employee-group-table"
                    formRef="select-employee-group-table"
                    />

                </div>

                <div class="modal-footer ">
                    <button class="btn btn-danger form-button" type="button"  v-on:click="hide" title="Cancel selection"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
                </div>

            </div>

        </div>

    </div>

    <employee-group-form :id="id + '-employee-group-form'"  :ref="_uid + '-employee-group-form'"/>


</section>
</template>

<script>

import modalTemplate from "@components/modals/modal-template";

export default {

    mixins: [modalTemplate],       

    components: {
        EmployeeGroupTable: () => import("./EmployeeGroupTable"),
        EmployeeGroupForm: () => import("./EmployeeGroupForm"),
    },

    data() {
        return {
            table: null,
            error: null,
        };
    },

    methods: {

        selectEmployeeGroup() {

            this.show();

            this.table.selectTableFlag = true;
            this.table.actionColumnWidth = 12;

            if ( !this.table.table ) setTimeout( this.table.loadDataTable );

        },

        employeeGroupSelected(id, description) {
            
            if ( typeof this.$parent.employeeGroupSelected === 'function') {

                this.$parent.employeeGroupSelected(id, description);

                this.hide();

            }
            
        },



        newRecordButtonClicked() {

            this.$refs[this._uid + '-employee-group-form'].table = this.table;
            this.$refs[this._uid + '-employee-group-form'].insertClicked();

        },

    },

}  
</script>

