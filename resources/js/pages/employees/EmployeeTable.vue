<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <tagged-drop-down v-if="taggedDropDown" :table-id="tableId"/>
            <filter-button/>
            <table-options v-if="optionsButton" :table-id="tableId"></table-options>
            <new-record-button v-if="newRecordButton" type="button" :title="'Create a new ' + singular" :text="'New ' + singular"/>
        </div>
    </div>

    <table :id="tableId" class="table bordered" style="width:100%"></table>
    <table-footer/>


</div>
</template>

<script>

import tableTemplate from "@components/tables/table-template";

export default {

    mixins: [tableTemplate],

    created() {
        this.url = "/employee/get";
        this.route = "employees";
        this.title = 'Employees';
        this.plural = 'Employees';
        this.singular = 'Employee';
        this.select = ['employee.recordid','employee.name','employee.loginid','employee.suspendedflag'];   
    },

    methods: {

        defineTableColDefs() {
            
            let target = this.tagTableFlag ? 1 : 0;

            let tableColumnDefs = [
                {
                    title: "Name",
                    name: "employee.name",
                    data: null,
                    targets: target + 1,
                    width: "60%",
                    render: (data) => { 
                        if (this.selectTableFlag) {
                            return lookupWrapper('Employee', data.id, htmlDecode(data.name));
                        } else {
                            return data.name;
                        }
                    }
                },
                {
                    title: "Login",
                    name: "employee.loginid",
                    width: '20%',
                    data: null,
                    targets: target + 2,
                    render: function (data) {
                        return data.loginid;
                    }
                },


            ];


            if (!this.selectTableFlag) {
                
                tableColumnDefs.push({
                    title: "Suspended",
                    name: "employee.suspendedflag",
                    data: null,
                    width: '20%',
                    targets: target + 3,
                    render: function (data) {
                        return data.suspendedflag == 1 ? 'Yes' : '';
                    }
                });
            }
        


            return tableColumnDefs;
        }

    },

}  
</script>
