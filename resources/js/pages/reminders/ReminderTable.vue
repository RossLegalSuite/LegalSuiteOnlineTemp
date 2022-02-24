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
        this.url = "/todonote/get";
        this.route = "reminder";
        this.tableName = 'todonote';
        this.title = 'Reminders';
        this.plural = 'Reminders';
        this.singular = 'Reminder';
    },

    methods: {

        /*

    protected $fillable = [
							'matterid',
							'employeeid',
							'date',
							'description',
							'nextdocumentid',
							'datedone',
							'recordid',
							'todoitemid',
							'autonotifydate',
							'completedbyid',
							'completedflag',
							'completedbynotes',
							'partyid',
							'createdbyid',
							'createddate',
							'createdtime',
							'completedtime',
							'dateadjustment',
							'outlooktaskid',
							'outlookappointmentid',
							'appttime',
							'recurringflag',
							'recurringperiod',
							'recurringcustomtype',
							'recurringcustomamount',
							'priority'
    ];


        */


        defineTableColDefs() {

            const targets = this.tagTableFlag ? 1 : 0;
            const parentColumnVisible = this.parentType === 'General' ? true : false;

            let tableColumnDefs = [
                {
                    title: "Created",
                    name: "todonote.createddate",
                    filterColumnName: "todonote.createddate",
                    filterType: 'Date',
                    data: null,
                    visible: false,
                    width: "12%",
                    targets: targets + 1,
                    render: function (data) {
                        return data.formattedcreateddate;
                    }
                },

                {
                    title: "Created By",
                    name: "createdby.name",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Employee',
                    data: null,
                    orderable: false,
                    searchable: false,
                    visible: false,
                    width: "15%",
                    targets: targets + 2,
                    render: function (data) {
                        return htmlDecode(data.createdbyemployee);
                    }
                },   

                {
                    title: "Date",
                    name: "todonote.date",
                    filterColumnName: "todonote.date",
                    filterType: 'Date',
                    data: null,
                    width: "12%",
                    targets: targets + 3,
                    render: function (data) {
                        return data.formatteddate;
                    }
                },
                {
                    title: "Matter",
                    name: 'matter.fileref',
                    filterExclude: true,
                    orderable: false,
                    data: null,
                    visible: parentColumnVisible,
                    width: "15%",
                    targets: targets + 4,
                    render: function (data) {
                        return htmlDecode(data.parentlink);
                    }
                },                
                {
                    title: "Description",
                    name: "todonote.description",
                    data: null,
                    orderable: false,
                    width: "35%",
                    targets: targets + 5,
                    render: function (data) {
                        return htmlDecode(data.description);
                    }
                },
                {
                    title: "Assigned To",
                    name: "employee.name",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Employee',
                    data: null,
                    orderable: false,
                    searchable: false,
                    visible: false,
                    width: "15%",
                    targets: targets + 6,
                    render: function (data) {
                        return htmlDecode(data.employeename);
                    }
                },   
                {
                    title: "Done",
                    name: "completedFlag",
                    filterColumnName: "todonote.completedflag",
                    filterType: 'Boolean',
                    filterControl: 'RadioButton',
                    filterOptions: [{text: 'Yes', value: '1'}, {text: 'No', value: '0'}],
                    visible: false,
                    data: null,
                    width: "7%",
                    targets: targets + 7,
                    render: function (data) {
                        return (data.completedFlag ) ? 'Yes' : 'No';
                    }
                },
                {
                    title: "Overdue",
                    name: "overdueFlag",
                    filterColumnName: "overdueflag",
                    filterType: 'Boolean',
                    filterControl: 'RadioButton',
                    filterOptions: [{text: 'Yes', value: '1'}, {text: 'No', value: '0'}],
                    visible: false,
                    data: null,
                    width: "7%",
                    targets: targets + 8,
                    render: function (data) {
                        return (data.overdueFlag ) ? 'Yes' : 'No';
                    }
                },
                {
                    title: "Completed By",
                    name: "completedby.name",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Employee',
                    data: null,
                    visible: false,
                    width: "15%",
                    targets: targets + 9,
                    render: function (data) {
                        return htmlDecode(data.completedbyemployee);
                    }
                },   
                {
                    title: "Completed",
                    name: "todonote.datedone",
                    filterColumnName: "todonote.datedone",
                    filterType: 'Date',
                    data: null,
                    width: "12%",
                    targets: targets + 10,
                    render: function (data) {
                        return data.formatteddatedone;
                    }
                },
                {
                    title: "Days Taken",
                    name: 'DaysTaken',
                    filterExclude: true,
                    orderable: false,
                    searchable: false,
                    data: null,
                    width: "10%",
                    targets: targets + 11,
                    render: function (data) {
                        return data.daystaken != '0' ? data.daystaken : '';
                    }
                },                
                {
                    title: "Variance",
                    name: 'DaysDiff',
                    filterExclude: true,
                    orderable: false,
                    searchable: false,
                    visible: false,
                    data: null,
                    width: "10%",
                    targets: targets + 12,
                    render: function (data) {
                        return parseInt(data.datedone) > 0 ? data.daysdiff : '';
                    }
                },                
            ];
        
            return tableColumnDefs;
        }

    },

}  
</script>
