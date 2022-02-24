<template>
<span>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <tagged-drop-down v-if="taggedDropDown" :table-id="tableId"/>
            <filter-form-button/>
            <table-options/>
            <new-record-button type="button" :title="'Create a new ' + singular" :text="'New ' + singular"/>
        </div>

    </div>

    <table :id="tableId" class="table bordered" style="width:100%"/>
    <table-footer/>

    <doclog-filter-form
        :id="tableId + '-filter-form'"
        :ref="tableId + '-filter-form'"
    />


</span>
</template>

<script>

import tableTemplate from "@components/tables/table-template";

export default {

    mixins: [tableTemplate],

    components: {
        DoclogFilterForm: () => import("./DoclogFilterForm"),
    },

    created() {
        this.url = "/doclog/get";
        this.route = 'doclog';
        this.tableName = 'doclog';
        this.title = 'Document Log';
        this.plural = 'Items';
        this.singular = 'Item';
    },

    methods: {
        
        defineTableColDefs() {

            const targets = this.tagTableFlag ? 1 : 0;
            const parentColumnVisible = this.parentType === 'General' ? true : false;
            
            let tableColumnDefs = [
                {
                    title: "Date",
                    name: "doclog.date",
                    filterColumnName: "doclog.date",
                    filterType: 'Date',
                    searchable: false,
                    data: null,
                    width: "12%",
                    targets: targets + 1,
                    render: function (data) {
                        return data.formatteddate;
                    }
                },
                {
                    title: "Time",
                    name: "doclog.time",
                    filterExclude: true,
                    searchable: false,
                    orderable: false,
                    visible: false,
                    data: null,
                    width: "12%",
                    targets: targets + 2,
                    render: function (data) {
                        return data.time;
                    }
                },
                {
                    title: "Created By",
                    name: "employee.name",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Employee',
                    data: null,
                    searchable: false,
                    orderable: false,
                    visible: false,
                    width: "15%",
                    targets: targets + 3,
                    render: function (data) {
                        return htmlDecode(data.employeename);
                    }
                },   
                {
                    title: "Description",
                    name: "doclog.description",
                    orderable: false,
                    data: null,
                    width: "25%",
                    targets: targets + 4,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },  

                {
                    title: "Belongs To",
                    name: 'matter.fileref',
                    filterExclude: true,
                    orderable: false,
                    data: null,
                    visible: parentColumnVisible,
                    width: "15%",
                    targets: targets + 5,
                    render: function (data) {
                        return htmlDecode(data.parentlink);
                    }
                },                
                {
                    title: "Category",
                    name: "doclogcategory.description",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'DoclogCategory',
                    data: null,
                    searchable: false,
                    orderable: false,
                    width: "12%",
                    targets: targets + 6,
                    render: function (data) {
                        return data.category;
                    }
                },
                {
                    title: "Sub Category",
                    name: "doclogsubcategory.description",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'DoclogSubCategory',
                    data: null,
                    visible: false,
                    searchable: false,
                    orderable: false,
                    width: "12%",
                    targets: targets + 7,
                    render: function (data) {
                        return data.subcategory;
                    }
                },
                {
                    title: "Direction",
                    name: "doclog.direction",
                    filterType: 'Dropdown',
                    filterControl: 'Dropdown',
                    filterOptions:[ 
                        {value:'1', label: 'Outgoing'},
                        {value:'2', label: 'Incoming'},
                        {value:'0', label: 'Not Applicable'},
                    ],
                    data: null,
                    visible: false,
                    searchable: false,
                    orderable: false,
                    width: "12%",
                    targets: targets + 8,
                    render: function (data) {
                        return data.directiondescription;
                    }
                },                
                {
                    title: "Saved As",
                    name: "doclog.savedname",
                    data: null,
                    visible: false,
                    searchable: false,
                    orderable: false,
                    width: "15%",
                    targets: targets + 9,
                    render: function (data) {
                        return data.savedname ? data.savedname : '';
                    }
                },                
                {
                    title: "Cloud",
                    name: "doclog.url",
                    data: null,
                    visible: false,
                    searchable: false,
                    orderable: false,
                    width: "15%",
                    targets: targets + 10,
                    render: function (data) {
                        
                        return data.url ? '<a target="_blank" href="https://docs.google.com/gview?url=' + encodeURIComponent(data.url) + '&embedded=false">' +  data.url.substring(data.url.lastIndexOf('/')+1) + '</a>' : '';
                    }
                },                

            ];
        
            return tableColumnDefs;
        }

    },

}  
</script>
