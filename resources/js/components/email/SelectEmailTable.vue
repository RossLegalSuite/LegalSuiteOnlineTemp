<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <email-filter-form-button/>
        </div>
    </div>

    <table :id="tableId" class="table bordered" style="width:100%"></table>
    <table-footer/>


</div>
</template>

<script>

import tableTemplate from "../tables/table-template";

export default {

    mixins: [tableTemplate],

    created() {
        this.url = "/partele/get";
        this.title = 'Emails';
        this.plural = 'Email Addresses';
        this.singular = 'Email Address';
        this.tableName = 'partele';
        this.where = ['DefaultEmailFlag,1','TelephoneTypeID,' + root.control.emailphoneid,]
    },

    methods: {
        
        defineTableColDefs: function () {
            
            let tableColumnDefs = [
                {
                    title: "Email",
                    name: "Partele.Number",
                    data: null,
                    width: "30%",
                    targets: 2,
                    render: function (data) {
                        return htmlDecode(data.number);
                    }
                },
                {
                    title: "Party",
                    name: "Party.Name",
                    data: null,
                    width: "60%",
                    targets: 3,
                    render: function (data) {
                        return htmlDecode(data.partylink);
                    }
                },
            ];
            return tableColumnDefs;
        }

    },


}  
</script>
