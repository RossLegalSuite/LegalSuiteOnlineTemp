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
        this.url = "/parfica/get";
        this.route = "parfica";
        this.title = 'Documents';
        this.plural = 'Documents';
        this.singular = 'Document';
        this.tableName = 'parfica';
        this.initialOrder = [[1, "desc"]];

    },

    methods: {

        defineTableColDefs() {

            let tableColumnDefs = [
                {
                    title: "",
                    name: "ficaitem.description",
                    data: null,
                    class: 'text-center',
                    width: root.screenNarrow ? '8%' : '5%',
                    orderable: false,
                    searchable: false,
                    printable: false,
                    targets: 0,
                    render: (data) => {

                        let icon = '', title = '';

                        if ( data.date && parseInt(data.date) > 0 ) {

                            if ( parseInt(data.expiry) > 0 ) {

                                let ficaExpiresDate = getFicaExpiryDate(data.date, data.expiry, false);

                                if ( ficaExpiresDate.isBefore(moment()) ) {

                                    icon = '❌';
                                    title = 'Document has expired';

                                } else {

                                    icon = '✅';
                                    title = 'Document is valid';

                                }
                            
                            } else {

                                // Never expires
                                icon = '✅';
                                title = 'Document is valid';

                            }
                            
                        } else {

                            if ( parseInt(data.expiry) === 0 ) {

                                // Never expires
                                icon = '✅';
                                title = 'Document is valid';

                            } else {

                                icon = '❓';
                                title = 'Document has not been checked';

                            }
                        }

                        return '<span class="cp" title="' + title + '">' + icon + '</span>';

                    }
                },
                {
                    title: "Document",
                    name: "ficaitem.description",
                    data: null,
                    width: "30%",
                    targets: 1,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "Document Date",
                    name: "parfica.date",
                    orderable: false,
                    data: null,
                    width: "20%",
                    targets: 2,
                    render: function (data) {

                        if ( parseInt(data.expiry) === 0 ) {

                            return 'Not applicable';

                        } else {

                            if ( data.date && parseInt(data.date) > 0 ) {

                                return data.formatteddate;

                            } else {

                                return '<span class="text-danger">Not specified</span>';

                            }
                        }
                    }
                },
                {
                    title: "Expires",
                    name: "ficaitem.expiry",
                    orderable: false,
                    data: null,
                    width: "20%",
                    targets: 3,
                    render: function (data) {

                        let ficaExpiresDate = 'Never';

                        if ( data.expiry && parseInt(data.expiry) > 0 ) {

                            if ( data.date && parseInt(data.date) > 0 ) {

                                ficaExpiresDate = getFicaExpiryDate(data.date, data.expiry);

                            } else {

                                ficaExpiresDate = data.expiry + ' months';
                            }
                            
                        }

                        return ficaExpiresDate;

                    }
                },
                {
                    title: "Comments",
                    name: "parfica.comments",
                    data: null,
                    targets: 4,
                    render: function (data) {
                        return htmlDecode(data.comments);
                    }
                },

            ];
        
            return tableColumnDefs;
        }

    },



}  
</script>
