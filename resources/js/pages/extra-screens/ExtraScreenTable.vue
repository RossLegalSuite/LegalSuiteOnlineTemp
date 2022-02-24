<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <filter-form-button/>
            <table-options/>
            <new-record-button type="button" :title="'Create a new ' + singular" :text="'New ' + singular"/>
        </div>

    </div>

    <table :id="tableId" class="table bordered" style="width:100%"/>
    <table-footer ref="tableFooter"/>

    <extra-screen-filter-form
        :id="tableId + '-filter-form'"
        :ref="tableId + '-filter-form'"
    />

</div>
</template>

<script>

import tableTemplate from "@components/tables/table-template";

export default {

    mixins: [tableTemplate],

    components: {
        ExtraScreenFilterForm: () => import("./ExtraScreenFilterForm"),
    },

    created() {
        this.url = "/extra_screens/get";
        this.route = "extra-screens";
        this.title = 'Extra Screens';
        this.plural = 'Extra Screens';
        this.singular = 'Extra Screen';
    },
    
    methods: {

        defineTableColDefs() {

            let targets = this.tagTableFlag ? 1 : 0;

            let tableColumnDefs = [
                {
                    title: "Title",
                    name: "extra_screens.title",
                    data: null,
                    width: "20%",
                    targets: targets + 1,
                    render: function (data) {
                        return htmlDecode(data.title);
                    }
                },
                {
                    title: "Description",
                    name: "extra_screens.description",
                    data: null,
                    width: "30%",
                    targets: targets + 2,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "Created By",
                    name: "created.name",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Employee',
                    data: null,
                    visible: false,
                    width: "20%",
                    targets: targets + 3,
                    render: function (data) {
                        return htmlDecode(data.createdEmployeeName);
                    }
                },   
                {
                    title: "Location",
                    name: "extra_screens.location",
                    data: null,
                    filterType: 'RadioButton',
                    filterControl: 'RadioButton',
                    filterOptions: this.$root.extraScreenTypesArray,
                    width: "25%",
                    targets: targets + 4,
                    render: function (data) {
                        return data.locationDescription;
                    }
                },
                {
                    title: "Position",
                    name: "extra_screens.position",
                    data: null,
                    filterType: 'RadioButton',
                    filterControl: 'RadioButton',
                    filterOptions: [{text: 'Tab', value: 'Tab'}, {text: 'Form', value: 'Form'} ],
                    width: "15%",
                    targets: targets + 5,
                    render: function (data) {
                        return data.position;
                    }
                },

            ];

            return tableColumnDefs;

        }
    },

}  
</script>
