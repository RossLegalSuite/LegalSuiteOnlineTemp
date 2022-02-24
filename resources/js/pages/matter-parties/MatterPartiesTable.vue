<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <tagged-drop-down v-if="taggedDropDown" :table-id="tableId"/>
            <filter-form-button v-if="parentType === 'General'"/>
            <table-options/>
            <new-record-button v-if="newRecordButton" type="button" :title="'Create a new ' + singular" :text="'New ' + singular"/>            
        </div>

    </div>

    <table :id="tableId" class="table bordered" style="width:100%"/>
    <table-footer v-if="parentType === 'General'"/>

    <matter-parties-filter-form
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
        MatterPartiesFilterForm: () => import("./MatterPartiesFilterForm"),
    },


    created() {
        this.url = "/matparty/get";
        this.route = "matparty";
        this.tableName = 'matparty';
        this.title = 'Parties';
        this.plural = 'Parties';
        this.singular = 'Party';
    },

    methods: {

        defineTableColDefs() {

            const targets = this.tagTableFlag ? 1 : 0;
            const matterColumnVisible = this.parentType === 'General' ? true : false;
            const extraColumnsVisible = this.parentType === 'General' ? false : true;

            let tableColumnDefs = [
                {
                    title: "Party",
                    name: "party.matterprefix",
                    data: null,
                    width: "25%",
                    targets: targets + 1,
                    render: function (data) {
                        return htmlDecode(data.partylink);
                    }
                },
                {
                    title: "Matter",
                    name: 'matter.fileref',
                    filterExclude: true,
                    data: null,
                    orderable: false,
                    visible: matterColumnVisible,
                    width: "25%",
                    targets: targets + 2,
                    render: function (data) {
                        return htmlDecode(data.matterlink);
                    }
                },                
                {
                    title: "Contact",
                    name: "contact.name",
                    data: null,
                    orderable: false,
                    visible: false,
                    targets: targets + 3,
                    render: function (data) {
                        if ( data.contactname ) {
                            return lookupWrapper('Party', data.contactrecordid, htmlDecode(data.contactname));
                        } else {
                            return '';
                        }
                    }
                },
                {
                    title: "Role",
                    name: "role.description",
                    data: null,
                    width: "20%",
                    orderable: false,
                    targets: targets + 4,
                    render: (data) => {

                        let sorterIndicator = '';

                        if ( parseInt(data.sorter) > 1 ) {
                            sorterIndicator = ' (' + data.sorter + ')';
                        }

                        return htmlDecode(data.roledescription) + sorterIndicator;
                    }
                },
                {
                    title: "Reference",
                    name: "matparty.reference",
                    data: null,
                    visible: false,
                    orderable: false,
                    targets: targets + 5,
                    render: function (data) {
                        return htmlDecode(data.reference);
                    }
                },
                {
                    title: "Email",
                    name: "email.number",
                    data: null,
                    visible: extraColumnsVisible,
                    orderable: false,
                    targets: targets + 6,
                    render: function (data) {
                        if (data.emailaddress) {
                            return lookupWrapper('Email Party', data.partyid, data.emailaddress);
                        } else {
                            return '';
                        }                    }
                },
                {
                    title: "Mobile",
                    name: "cell.number",
                    data: null,
                    visible: extraColumnsVisible,
                    orderable: false,
                    targets: targets + 7,
                    render: function (data) {
                        return htmlAnchor( 'tel:', htmlDecode(data.cellnumber));
                    }
                },
                {
                    title: "Work",
                    name: "work.number",
                    data: null,
                    visible: extraColumnsVisible,
                    orderable: false,
                    visible: false,
                    targets: targets + 8,
                    render: function (data) {
                        return htmlAnchor( 'tel:', htmlDecode(data.worknumber));
                    }
                },
                {
                    title: "Language",
                    name: "language.description",
                    data: null,
                    orderable: false,
                    visible: false,
                    targets: targets + 9,
                    render: function (data) {
                        return data.languagedescription;
                    }
                },
                {
                    title: "",
                    visible: false,
                    searchable: false,
                    filterExclude: true,
                    name: "role.description",
                    data: null,
                    targets: targets + 10,
                    render: (data) => {
                        return data.roledescription;
                    }
                },
                {
                    title: "",
                    visible: false,
                    searchable: false,
                    filterExclude: true,
                    name: "matparty.sorter",
                    data: null,
                    targets: targets + 11,
                    render: (data) => {
                        return data.sorter;
                    }
                },                
                {
                    title: "",
                    visible: false,
                    searchable: false,
                    filterExclude: true,
                    name: "matparty.partyid",
                    data: null,
                    targets: targets + 12,
                    render: (data) => {
                        return data.partyid;
                    }
                },                
            ];
            return tableColumnDefs;
        }
    },
}  
</script>
