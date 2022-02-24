<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <global-search/>
        <div>
            <party-filter-form-button/>
            <table-options/>
            <new-record-button v-if="newRecordButton" type="button" :title="'Create a new ' + singular" text="Add"/>
        </div>
    </div>
    <table :id="tableId" class="table bordered" style="width:100%"/>

</div>
</template>

<script>

import tableTemplate from "@components/tables/table-template";
import partyColumns from "./party-columns.js";

export default {
    
    mixins: [tableTemplate, partyColumns],

    components: {
        PartyFilterFormButton: () => import("./PartyFilterFormButton"),
    },

    created() {
        this.url = "/matparty/get";
        this.route = "parties";
        this.title = 'Parties';
        this.plural = 'Parties';
        this.singular = 'Party';
        this.tableName = 'matparty';
    },

    methods: {

        selectRecord(id) {

            this.$parent.hide();

            this.$parent.$parent.partiesSelected([id]);

        },        


    },

}  
</script>





