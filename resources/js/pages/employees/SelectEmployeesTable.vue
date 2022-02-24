<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <table-options/>
        </div>
    </div>
    <table :id="tableId" class="table bordered" style="width:100%"></table>
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
        this.select = ['employee.recordid','employee.name'];   
    },

    methods: {

        selectRecord(id) {

            this.$parent.hide();

            this.$parent.$parent.employeesSelected([id]);

        },        

        defineTableColDefs: function () {

            const target = this.tagTableFlag ? 1 : 0;

            let tableColumnDefs = [
                {
                    title: "Name",
                    name: "employee.name",
                    data: null,
                    targets: target + 1,
                    width: "80%",
                    render: (data) => { 
                        // if (this.selectTableFlag) {
                        //     return lookupWrapper('Employee', data.id, htmlDecode(data.name));
                        // } else {
                        //     return data.name;
                        // }
                        return htmlDecode(data.name);

                    }
                },
                // {
                //     title: "Login",
                //     name: "employee.loginid",
                //     width: '20%',
                //     data: null,
                //     targets: target + 2,
                //     render: function (data) {
                //         return data.loginid;
                //     }
                // },

            ];
            return tableColumnDefs;
        }

    },

}  
</script>
