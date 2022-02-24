<template>

<section>
    <div class="d-flex justify-content-between table-functions-row">

        <global-search/>

        <div>
        </div>

    </div>

    <table :id="tableId" class="table bordered" style="width:100%"/>

</section>
</template>

<script>

import tableTemplate from "@components/tables/table-template";

export default {

    mixins: [tableTemplate],

    created() {
        this.url = "/permissions/get";
        this.route = "permissions";
        this.title = 'Permissions';
        this.plural = 'Permissions';
        this.singular = 'Permission';
    },

    methods: {

        defineTableColDefs: function () {

            let _this = this;

            let tableColumnDefs = [

                {
                    title: "Resource",
                    name: "resources.description",
                    data: null,
                    width: '40%',
                    targets: 0,
                    render: function (data) {
                        return data.resourceDescription
                    }
                },
                {
                    searchable: false,
                    orderable: false,
                    title: "View",
                    name: "permissions.viewFlag",
                    class: "text-center",
                    data: null,
                    width: '15%',
                    targets: 1,
                    render: function (data) {
                        let checked = data.viewFlag ? 'checked' : '';
                        return '<input ' + checked + ' id="' + _this.tableId + '-view-flag-' + data.id + '" data-id="' + data.id +  '" type="checkbox" class="' + _this.tableId + '-view-flag">';
                    }
                },
                {
                    searchable: false,
                    orderable: false,
                    title: "Insert",
                    name: "permissions.insertFlag",
                    class: "text-center",
                    data: null,
                    width: '15%',
                    targets: 2,
                    render: function (data) {
                        let checked = data.insertFlag ? 'checked' : '';
                        return '<input ' + checked + ' id="' + _this.tableId + '-insert-flag-' + data.id + '" data-id="' + data.id +  '" type="checkbox" class="' + _this.tableId + '-insert-flag">';
                    }
                },
                {
                    searchable: false,
                    orderable: false,
                    title: "Change",
                    name: "permissions.changeFlag",
                    class: "text-center",
                    data: null,
                    width: '15%',
                    targets: 3,
                    render: function (data) {
                        let checked = data.changeFlag ? 'checked' : '';
                        return '<input ' + checked + ' id="' + _this.tableId + '-change-flag-' + data.id + '" data-id="' + data.id +  '" type="checkbox" class="' + _this.tableId + '-change-flag">';
                    }
                },
                {
                    searchable: false,
                    orderable: false,
                    title: "Delete",
                    name: "permissions.deleteFlag",
                    class: "text-center",
                    data: null,
                    width: '15%',
                    targets: 4,
                    render: function (data) {
                        let checked = data.deleteFlag ? 'checked' : '';
                        return '<input ' + checked + ' id="' + _this.tableId + '-delete-flag-' + data.id + '" data-id="' + data.id +  '" type="checkbox" class="' + _this.tableId + '-delete-flag">';
                    }
                },

            ];
        
        
            return tableColumnDefs;
        }

    },

}  
</script>