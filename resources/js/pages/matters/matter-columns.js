export default Vue.extend({

    methods: {

        defineTableColDefs() {

            const targets = this.tagTableFlag ? 1 : 0;

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
                            // return 'xyz';
                        if (this.selectTableFlag) {
                            return lookupWrapper('Matter', data.recordid, htmlDecode(data.fileref));
                        } else {
                            return htmlDecode(data.fileref);
                        }
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
                        return lookupWrapper('Client', data.clientid, htmlDecode(data.partyname));
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
                {
                    title: "Matter Type",
                    name: "MatType.Description",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'MatterType',
                    data: null,
                    orderable: false,
                    width: "20%",
                    targets: targets + 4,
                    render: (data) => {
                        return htmlDecode(data.mattypedescription);
                    }
                },
                {
                    title: "Document Set",
                    name: "DocGen.Description",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'DocumentSet',
                    visible: false,
                    data: null,
                    orderable: false,
                    width: "20%",
                    targets: targets + 5,
                    render: (data) => {
                        return htmlDecode(data.docgendescription);
                    }
                },
                {
                    title: "Cost Centre",
                    name: "CostCentre.Description",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'CostCentre',
                    visible: false,
                    data: null,
                    orderable: false,
                    width: "20%",
                    targets: targets + 6,
                    render: (data) => {
                        return htmlDecode(data.costcentredescription);
                    }
                },
                
                {
                    title: "Belongs To",
                    name: "Employee.Name",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Employee',
                    visible: false,
                    data: null,
                    orderable: false,
                    width: "15%",
                    targets: targets + 7,
                    render: (data) => {
                        return htmlDecode(data.employeename);
                    }
                },
                {
                    title: "Instructed",
                    name: "Matter.DateInstructed",
                    filterType: 'Date',
                    visible: false,
                    width: "12%",
                    data: null,
                    orderable: false,
                    targets: targets + 8,
                    render: (data) => {
                        return data.formatteddateinstructed;
                    }
                },
                {
                    title: "Fee Sheet",
                    name: "ClientFeeSheet.Description",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'FeeSheet',
                    visible: false,
                    data: null,
                    orderable: false,
                    width: "20%",
                    targets: targets + 9,
                    render: (data) => {
                        return htmlDecode(data.clientfeesheetdescription);
                    }
                },
                
                {
                    title: "Branch",
                    name: "Branch.Description",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'Branch',
                    visible: false,
                    data: null,
                    orderable: false,
                    width: "15%",
                    targets: targets + 10,
                    render: (data) => {
                        return htmlDecode(data.branchdescription);
                    }
                },

                {
                    title: "Lodged",
                    name: "ConveyData.Step4Completed",
                    filterType: 'Date',
                    visible: false,
                    width: "12%",
                    data: null,
                    orderable: false,
                    targets: targets + 11,
                    render: (data) => {
                        return data.formattedstep4completed;
                    }
                },

                {
                    title: "Registered",
                    name: "ConveyData.Step6Completed",
                    filterType: 'Date',
                    visible: false,
                    width: "12%",
                    data: null,
                    orderable: false,
                    targets: targets + 12,
                    render: (data) => {
                        return data.formattedstep6completed;
                    }
                },
                {
                    title: "Conveyancing Status",
                    name: "Matter.ConveyancingStatusFlag",
                    filterType: 'Dropdown',
                    filterControl: 'Dropdown',
                    filterOptions:[ 
                        {value:'1', label: 'New Instruction'},
                        {value:'2', label: 'Amended Instruction'},
                        {value:'3', label: 'Lodged'},
                        {value:'4', label: 'Registered'},
                        {value:'5', label: 'NTU Instruction'},
                        {value:'6', label: 'Withdrawn'},
                        {value:'7', label: 'Cancelled'},
                    ],
                    width: "15%",
                    data: null,
                    orderable: false,
                    //filterExclude: true,
                    visible: false,
                    targets: targets + 13,
                    render: (data) => {
                        if ( data.conveyancingstatusflag == 1 ) {
                            return 'New Instruction';
                        } else if ( data.conveyancingstatusflag == 2 ) {
                            return 'Amended Instruction';
                        } else if ( data.conveyancingstatusflag == 3 ) {
                            return 'Lodged';
                        } else if ( data.conveyancingstatusflag == 4 ) {
                            return 'Registered';
                        } else if ( data.conveyancingstatusflag == 5 ) {
                            return 'NTU';
                        } else if ( data.conveyancingstatusflag == 6 ) {
                            return 'Withdrawn';
                        } else if ( data.conveyancingstatusflag == 7 ) {
                            return 'Cancelled';
                        } else {
                            return data.conveyancingstatusflag;
                        }

                    }
                },

                {
                    searchable: false,
                    title: "Business Balance",
                    name: "Matter.Actual",
                    //calculatedColumn: true, // Uses "having" clause instead of "where"
                    filterType: 'Number',
                    class: "text-number",
                    visible: false,
                    data: null,
                    orderable: false,
                    width: '20%',
                    targets: targets + 14,
                    render: function (data) {
                        if (data.actual) {
                            return htmlRedText(data.actual, parseFloat(data.actual) < 0);
                        } else {
                            return '0.00';
                        }
                    }
                },

                {
                    searchable: false,
                    title: "Transfer Available",
                    name: "Matter.Transfer",
                    //calculatedColumn: true, // Uses "having" clause instead of "where"
                    filterType: 'Number',
                    class: "text-number",
                    visible: false,
                    data: null,
                    orderable: false,
                    width: '20%',
                    targets: targets + 15,
                    render: function (data) {
                        if (data.transfer) {
                            return htmlRedText(data.transfer, parseFloat(data.transfer) < 0);
                        } else {
                            return '0.00';
                        }
                    }
                },
                {
                    title: "",
                    searchable: false,
                    visible: false,
                    filterExclude: true,
                    name: "Matter.ConsolidateId",
                    data: null,
                    orderable: false,
                    targets: targets + 16,
                    render: function (data) {
                        return data.consolidateid;
                    }
                },
                {
                    title: "",
                    searchable: false,
                    visible: false,
                    filterExclude: true,
                    name: "Matter.ConsolidatedFlag",
                    data: null,
                    orderable: false,
                    targets: targets + 17,
                    render: function (data) {
                        return data.consolidatedflag;
                    }
                },

            ];
        
            return tableColumnDefs;
        }


    }

})