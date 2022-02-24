export default Vue.extend({

    methods: {

        defineTableColDefs() {
            
            let targets = this.tagTableFlag ? 1 : 0;

            let tableColumnDefs = [
                {
                    title: "Code",
                    name: "Party.MatterPrefix",
                    data: null,
                    width: "10%",
                    targets: targets + 1,
                    render: (data) => { 
                        if (this.selectTableFlag) {
                            return lookupWrapper('Party', data.recordid, data.matterprefix);
                        } else {
                            return data.matterprefix;
                        }
                    }
                },
                {
                    title: "Name",
                    name: "Party.Name",
                    data: null,
                    orderable: false,
                    width: "40%",
                    targets: targets + 2,
                    render: function (data) {
                        return htmlDecode(data.name);
                    }
                },
                {
                    title: "Entity",
                    name: "Entity.Description",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'PartyEntity',
                    visible: false,
                    data: null,
                    orderable: false,
                    width: "15%",
                    targets: targets + 3,
                    render: function (data) {
                        return data.entitydescription;
                    }
                },
                {
                    title: "Type",
                    name: "ParType.Description",
					filterType: 'Lookup',
					filterControl: 'Lookup',
                    filterTable: 'PartyType',
                    visible: false,
                    data: null,
                    orderable: false,
                    width: "15%",
                    targets: targets + 4,
                    render: function (data) {
                        return data.partypedescription;
                    }
                },
                {
                    title: "ID Number",
                    name: "Party.IdentityNumber",
                    visible: false,
                    data: null,
                    orderable: false,
                    width: "15%",
                    targets: targets + 5,
                    render: function (data) {
                        return data.identitynumber ? htmlDecode(data.identitynumber) : '';
                    }
                },
                {
                    title: "Address",
                    name: "ParLang.PhysicalLine1",
                    data: null,
                    orderable: false,
                    width: "15%",
                    targets: targets + 6,
                    render: function (data) {
                        return data.physicaladdress ? htmlDecode(data.physicaladdress) : '';
                    }
                },
                {
                    title: "Postal",
                    name: "ParLang.PostalLine1",
                    visible: false,
                    data: null,
                    orderable: false,
                    width: "15%",
                    targets: targets + 7,
                    render: function (data) {
                        return data.postaladdress ? htmlDecode(data.postaladdress) : '';
                    }
                },
                {
                    title: "Email",
                    name: "Email.Number",
                    data: null,
                    orderable: false,
                    width: "15%",
                    targets: targets + 8,
                    render: function (data) {
                        if (data.emailaddress) {
                            return lookupWrapper('Email Party', data.recordid, data.emailaddress);
                        } else {
                            return '';
                        }
                    }
                },
                {
                    title: "Mobile",
                    name: "Cell.Number",
                    data: null,
                    orderable: false,
                    width: "15%",
                    targets: targets + 9,
                    render: function (data) {
                        if ( data.cellnumber ) {
                            return htmlAnchor( 'tel:', htmlDecode(data.cellnumber));
                        } else {
                            return '';
                        }
                    }
                },
                {
                    title: "Is Client",
                    name: "isClient",
                    filterType: 'Dropdown',
                    filterControl: 'Dropdown',
                    filterOptions:[ 
                        {value:'0', label: 'No'},
                        {value:'1', label: 'Yes'},
                    ],                    
                    calculatedColumn: 'CASE WHEN Party.RecordId IN (SELECT PartyID FROM MatParty WHERE RoleID = 1) THEN 1 ELSE 0 END',
                    visible: false,
                    data: null,
                    orderable: false,
                    width: "15%",
                    targets: targets + 10,
                    render: function (data) {
                        return data.isclient;
                    }
                },
                {
                    title: "Role",
                    name: "Role.Description",
                    filterType: 'Lookup',
                    filterControl: 'Lookup',
                    filterTable: 'PartyRole',
                    visible: false,
                    //filterExclude: true,
                    calculatedColumn: "CASE WHEN Party.RecordId IN (SELECT partyID FROM MatParty WHERE roleId = {value}) THEN {value} ELSE null END",
                    data: null,
                    orderable: false,
                    targets: targets + 11,
                    render: function (data) {
                        return '';
                    }
                },
            ];

            return tableColumnDefs;

        }

    },

})