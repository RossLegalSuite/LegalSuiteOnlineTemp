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

    <reminder-filter-form
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
        ReminderFilterForm: () => import("./ReminderFilterForm"),
    },

    created() {
        this.url = "/reminders/get";
        this.exportUrl = "/reminders/export";
        this.route = "reminders";
        this.title = 'Reminders';
        this.plural = 'Reminders';
        this.singular = 'Reminder';
    },

    methods: {
        
        defineTableColDefs() {

            const targets = this.tagTableFlag ? 1 : 0;
            const parentColumnVisible = this.parentType === 'General' ? true : false;

            let tableColumnDefs = [
                {
                    title: "Created Date",
                    name: "date",
                    filterColumnName: "reminders.date",
                    filterType: 'Date',
                    data: null,
                    visible: false,
                    width: "12%",
                    targets: targets + 1,
                    render: function (data) {
                        return data.dateFormatted;
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
                    width: "15%",
                    targets: targets + 2,
                    render: function (data) {
                        return htmlDecode(data.createdEmployeeName);
                    }
                },   
                {
                    title: "Target Date",
                    name: "targetDate",
                    filterColumnName: "reminders.targetDate",
                    data: null,
                    filterType: 'Date',
                    width: "12%",
                    targets: targets + 3,
                    render: function (data) {
                        return data.targetDate;
                    }
                },
                {
                    title: "Assigned To",
                    name: "target.name",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Employee',
                    data: null,
                    width: "15%",
                    targets: targets + 4,
                    render: function (data) {
                        return htmlDecode(data.targetEmployeeName);
                    }
                },   
                {
                    title: "Description",
                    name: "reminders.description",
                    data: null,
                    width: "35%",
                    targets: targets + 5,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },                
                {
                    title: "Type",
                    name: "reminders.parentType",
                    data: null,
                    filterTitle: 'Linked To',
                    filterType: 'RadioButton',
                    filterControl: 'RadioButton',
                    filterOptions: [{text: 'General', value: 'General'}, {text: 'Matter', value: 'Matter'}, {text: 'Party', value: 'Party'} ],
                    width: "10%",
                    visible: false,
                    targets: targets + 6,
                    render: function (data) {
                        return data.parentType;
                    }
                },
                {
                    name: 'parent',
                    title: "Linked To",
                    filterExclude: true,
                    data: null,
                    width: "15%",
                    visible: parentColumnVisible,
                    targets: targets + 7,
                    render: function (data) {
                        if ( data.parentType === 'Matter') {

                            return lookupWrapper(data.parentType, data.matterId, htmlDecode(data.parent));

                        } else if ( data.parentType === 'Party') {

                            return lookupWrapper(data.parentType, data.partyId, htmlDecode(data.parent));

                        } else if ( data.parentType === 'Employee') {

                            return lookupWrapper(data.parentType, data.employeeId, htmlDecode(data.parent));

                        } else {

                            return htmlDecode(data.parent);
                            
                        }
                    }
                },
                {
                    title: "Matter",
                    name: "matters.fileRef",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Matter',
                    visible: false,
                    data: null,
                    width: "15%",
                    targets: targets + 8,
                    render: function (data) {
                        return htmlDecode(data.matterFileRef);
                    }
                },
                {
                    title: "Party",
                    name: "parties.code",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Party',
                    visible: false,
                    data: null,
                    width: "15%",
                    targets: targets + 9,
                    render: function (data) {
                        return htmlDecode(data.code);
                    }
                },
                {
                    title: "Completed",
                    name: "completedDate",
                    filterColumnName: "reminders.completedFlag",
                    filterType: 'Boolean',
                    filterControl: 'RadioButton',
                    filterOptions: [{text: 'Yes', value: '1'}, {text: 'No', value: '0'}],
                    data: null,
                    width: "15%",
                    targets: targets + 10,
                    render: function (data) {

                        let returnData = '';
                        
                        if (data.completedFlag ) returnData = data.completedDate;

                        return returnData;
                    }
                },
                {
                    title: "Repeat",
                    name: "recurringFlag",
                    filterColumnName: "reminders.recurringFlag",
                    filterType: 'Boolean',
                    filterTitle: 'Repeating',
                    filterControl: 'RadioButton',
                    filterOptions: [{text: 'Yes', value: '1'}, {text: 'No', value: '0'}],
                    visible: false,
                    data: null,
                    width: "15%",
                    targets: targets + 11,
                    render: function (data) {

                        let returnData = '';

                        if ( data.recurringFlag) {

                            returnData = data.recurringPeriod;
                        
                            if (data.recurringPeriod === 'Custom') returnData = 'Every ' + data.recurringCustomAmount + ' ' + data.recurringCustomUnits;

                        }

                        return returnData;
                    }
                },


            ];
        
            return tableColumnDefs;
        }

    },

}  

</script>
