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
            <tagged-drop-down v-if="taggedDropDown" :table-id="tableId"/>

            <matter-filter-form-button/>

            <table-options v-if="optionsButton"/>

            <new-record-button v-if="newRecordButton" type="button" :title="'Create a new ' + singular" :text="'New ' + singular"/>
        </div>

    </div>

    <table :id="tableId" class="table bordered" style="width:100%"></table>
    <table-footer/>

</div>
</template>

<script>

import tableTemplate from "@components/tables/table-template";
import matterColumns from "./matter-columns.js";

export default {

    mixins: [tableTemplate, matterColumns],

    components: {
        MatterFilterFormButton: () => import("./MatterFilterFormButton"),
    },


    created() {
        this.url = "/matter/get";
        this.route = "matters";
        this.tableName = "matter";
        this.exportUrl = "/matters/export";
        this.title = 'Matters';
        this.plural = 'Matters';
        this.singular = 'Matter';

        this.selectraw = [ 
            'Matter.RecordId',
            'Matter.ClientId',
            'Matter.FileRef',
            'Matter.Description',
            "CASE WHEN ISNULL(Matter.DateInstructed,0) = 0 OR Matter.DateInstructed = 0 OR Matter.DateInstructed > 100000 THEN '' ELSE  CONVERT(VarChar(12),CAST(Matter.DateInstructed-36163 as DateTime),106) END AS FormattedDateInstructed",
            'ClientFeeSheet.Description AS ClientFeeSheetDescription',
            'Matter.ConveyancingStatusflag',
            "CASE WHEN ISNULL(ConveyData.Step4Completed,0) = 0 OR ConveyData.Step4Completed = 0 OR ConveyData.Step4Completed > 100000 THEN '' ELSE  CONVERT(VarChar(12),CAST(ConveyData.Step4Completed-36163 as DateTime),106) END AS FormattedStep4Completed",
            "CASE WHEN ISNULL(ConveyData.Step6Completed,0) = 0 OR ConveyData.Step6Completed = 0 OR ConveyData.Step6Completed > 100000 THEN '' ELSE  CONVERT(VarChar(12),CAST(ConveyData.Step6Completed-36163 as DateTime),106) END AS FormattedStep6Completed",
            'Matter.Actual',
            'Matter.Transfer',
            'Matter.ConsolidateID',
            'Matter.ConsolidatedFlag',
            'Party.Name as PartyName',
            'Employee.Name as EmployeeName',
            "MatType.Description AS MatTypeDescription",
            "Docgen.Description AS DocGenDescription",
            "CostCentre.Description AS CostCentreDescription",
            "Branch.Description AS BranchDescription",
            "CASE WHEN ISNULL(LolTagged.taggedId,0) = 0 THEN 0 ELSE 1 END AS tagged"
        ];    
    },


}  
</script>
