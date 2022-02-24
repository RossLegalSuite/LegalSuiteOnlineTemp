<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <table-options/>
            <new-record-button v-if="newRecordButton" type="button" :title="'Create a new ' + singular" :text="'New ' + singular"/>
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
        this.url = "/employee_groups/get";
        this.route = "employee_groups";
        this.title = 'Employee Groups';
        this.plural = 'Employee Groups';
        this.singular = 'Employee Group';
    },


    methods: {


        selectRecord(id) {

            axios.post('/employee_groups/get',{recordid: id })

            .then(response => {

                this.record = response.data.data[0];

                this.$parent.employeeGroupSelected(response.data.data[0].id, response.data.data[0].description);

            });

        },

        defineTableColDefs() {

            const targets = this.selectTableFlag ? 1 : 2;

            let tableColumnDefs = [
                {
                    title: "Description",
                    name: "employee_groups.description",
                    data: null,
                    targets: targets,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },

            ];
        
            if (!this.selectTableFlag) {
                
                tableColumnDefs.push({
                    title: "Code",
                    name: "employee_groups.code",
                    data: null,
                    width: '20%',
                    targets: 1,
                    render: function (data) {
                        return htmlDecode(data.code);
                    }
                });
            }
        
            return tableColumnDefs;
        }

    },



}  
</script>
