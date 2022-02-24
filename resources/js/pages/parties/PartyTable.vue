<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <column-search
            :searchableColumns="[
                {title:'Code', name: 'Party.MatterPrefix'},
                {title:'Name', name: 'Party.Name'},
                {title:'ID/Reg Number', name: 'Party.IdentityNumber'},
                {title:'Physical', name: 'ParLang.PhysicalLine1'},
                {title:'Postal', name: 'ParLang.PostalLine1'},
                {title:'Email Address', name: 'Email.Number'},
                {title:'Mobile Number', name: 'Cell.Number'},
            ]"
            initialSearchColumn="Code"
        />

        <div>
            <tagged-drop-down v-if="taggedDropDown" :table-id="tableId"/>
            <party-filter-form-button/>
            <table-options/>
            <new-record-button v-if="newRecordButton" type="button" :title="'Create a new ' + singular" :text="'New ' + singular"/>
        </div>
    </div>

    <table :id="tableId" class="table bordered" style="width:100%"></table>
    <table-footer/>

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
        this.url = "/party/get";
        this.route = "parties";
        this.tableName = "party";
        this.exportUrl = "/parties/export";
        this.title = 'Parties';
        this.plural = 'Parties';
        this.singular = 'Party';
        this.selectraw = [ 
            'Party.RecordID',
            'Party.MatterPrefix',
            'Party.Name',
            'Entity.Description as entitydescription',
            'ParType.Description as partypedescription',
            "ParLang.PhysicalLine1 + ' ' + ParLang.PhysicalLine2  + ' ' + ParLang.PhysicalLine3 + ' ' + ParLang.PhysicalCode as PhysicalAddress",
            "ParLang.PostalLine1 + ' ' + ParLang.PostalLine2  + ' ' + ParLang.PostalLine3 + ' ' + ParLang.PostalCode as PostalAddress",
            'Party.IdentityNumber',
            'Email.Number as emailaddress',
            'Cell.Number as cellnumber',
            "CASE WHEN Party.RecordId IN (SELECT PartyID FROM MatParty WHERE RoleID = 1) THEN 'Yes' ELSE 'No' END As isClient",
            "CASE WHEN ISNULL(LolTagged.taggedId,0) = 0 THEN 0 ELSE 1 END AS tagged"
        ]; 
    },

}  
</script>
