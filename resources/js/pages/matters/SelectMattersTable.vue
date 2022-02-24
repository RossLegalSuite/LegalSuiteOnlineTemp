<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <column-search
            :searchableColumns="[
                {title:'File Ref', name: 'Matter.FileRef'},
                {title:'Description', name: 'Matter.Description'},
                {title:'Client Name', name: 'Party.Name'},
            ]"
            initialSearchColumn="File Ref"      
        />
        <div>
            
        </div>
    </div>
    <table :id="tableId" class="table bordered" style="width:100%"/>

</div>
</template>

<script>

import tableTemplate from "@components/tables/table-template";
//import matterColumns from "./matter-columns.js";

export default {
    
    mixins: [tableTemplate],

    components: {
        MatterFilterFormButton: () => import("./MatterFilterFormButton"),
    },

    created() {
        this.url = "/matter/get";
        this.route = "matter";
        this.title = 'Matters';
        this.plural = 'Matters';
        this.singular = 'Matter';
        this.tableName = "matter";
        
    },

    methods: {
        
        defineTableColDefs() {

            const targets = 0;

            let tableColumnDefs = [
                {
                    title: "File Ref",
                    name: "Matter.FileRef",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Matter',
                    width: "12%",
                    data: null,
                    targets: targets + 1,
                    render: (data) => { 
                        return htmlDecode(data.fileref);
                    }
                    
                },
                {
                    title: "Client",
                    name: "Party.Name",
					filterColumnName: 'Party.MatterPrefix',
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Party',
                    width: "20%",
                    data: null,
                    orderable: false,
                    targets: targets + 2,
                    render: (data) => {
                        return htmlDecode(data.partyname);
                    }
                },
                {
                    title: "Description",
                    name: "Matter.Description",
                    width: "20%",
                    data: null,
                    orderable: false,
                    targets: targets + 3,
                    render: (data) => {
                        return htmlDecode(data.description);
                    }
                },

            ];
        
            return tableColumnDefs;
        }

    },
    
}  
</script>
