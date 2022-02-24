<template>
<div>
    <div class="d-flex justify-content-between table-functions-row">
        <div>
            <global-search/>
        </div>
        <div>
            <new-record-button type="button" title="Add a Contact Method for this Party" text="Add" callback="newPartyNumber" @newPartyNumber="newPartyNumber" />
        </div>
    </div>



    <table :id="tableId" class="table bordered" style="table-layout: auto; width:100%"></table>

    <div class="modal" :id="id">
        <form class="modal-dialog modal-dialog-centered" @submit="submitForm">
            <div class="modal-content steelblue-border">

                <div class="modal-header steelblue">
                    <h4 class="modal-title page-title">{{formTitle}}</h4>
                    
                    <i title="Close this window" class="modal-close-button fa fa-times-circle fa-2x" data-dismiss="modal"></i>
                </div>

                <div class="card-body overflow-auto p-3" style="min-height: 40vh">

                    <div class="form-group row">

                        <select-telephone-type
                            popOver="<h4>Type of Contact Method</h4>
                            <p>The type of Contact Method.</p>" 
                            :popOverContainer="modal ? '#' + id : 'body'"
                            label="Contact Method"
                            _class="col-md-8"
                            :id="id + '-select-telephone-type'"
                            title="The type of Contact Method"
                            :ref="id + '-select-telephone-type'"
                            :form-ref="id + '-select-telephone-type'"
                        />

                    </div>

                    <div class="form-group row">

                        <div class="col-md-8">

                            <label>{{setLabel()}}</label>
                            <input 
                                class="form-control" 
                                :class="partyNumber.errorFlag ? 'is-invalid' : ''" 
                                name="description" 
                                v-model="partyNumber.description" 
                                type="text" 
                                required
                                >

                                <div v-show="partyNumber.errorFlag" class="invalid-feedback" role="alert">
                                    <strong>{{partyNumber.errorMessage}}</strong>
                                </div>

                        </div>



                    </div>

                    <div class="form-group row mt-3">

                        <div class="col-md-12">

                            <b-form-checkbox
                                :id="id + '-internal-flag-checkbox'"
                                v-model="partyNumber.internalFlag"
                                name="internalFlagCheckBox"
                                value="1"
                                unchecked-value="0"
                                switch 
                                size="lg"
                            >
                            <span>Do not show to Remote Users</span>
                            </b-form-checkbox>


                            <!-- 
                                <pop-over  
                                :container="'#' + id"
                                content="
                                    <h4>Remote Users</h4>
                                    <p>If a Remote User is logged in and viewing this Party, there may be certain Contact Numbers that are internal or private.</p>
                                    <p>If so, you can hide these from Remote Users by selecting this option.</p>"/>
                            -->

                        </div>
                    </div>


                </div>

                <div class="modal-footer justify-content-between">
                        <div>
                            <button v-if="partyNumber.id" class="btn btn-large btn-primary" type="button" @click="deleteRecord">
                                <span title="Delete"><i class="fa fa-trash fa-lg mr-2"></i>Delete</span>
                            </button>
                        </div>
                        <div>
                            <button class="btn btn-success form-button mr-3" type="submit" title="Save"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>
                            <button class="btn btn-danger form-button" type="button" data-dismiss="modal" title="Exit without saving"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
                        </div>
                </div>

            </div>

        </form>
    </div>


</div>
</template>

<script>

import modalTemplate from "@components/modals/modal-template";
import tableTemplate from "@components/tables/table-template";


export default {
    
    mixins: [modalTemplate, tableTemplate],

    components: {
        SelectTelephoneType: () => import("@pages/parties/SelectTelephoneType"),
    },

    created() {
        this.url = "/partele/get";
        this.route = "partytele";
        this.title = 'Contact Details';
        this.plural = 'Contact Details';
        this.singular = 'Contact';
        this.tableName = 'partele';
    },

    data() {
        return {
            partyNumber: {
                table: null,
                id: null,
                method: null,
                methodId: null,
                description: null,
                sorter: null,
                internalFlag: null,
                errorFlag: false,
                errorMessage: '',
            },
            formTitle: '',
        };
    },

    methods: {
        defineTableColDefs: function () {

            let target = this.noEditButtonFlag ? 0 : 1;
            
            let tableColumnDefs = [
                {
                    title: "Type",
                    name: "teletype.description",
                    data: null,
                    targets: target,
                    render: function (data) {
                        return htmlDecode(data.teletypedescription);
                    }
                },
                {
                    title: "Contact",
                    name: "partele.number",
                    data: null,
                    targets: target + 1,
                    render: function (data) {

                        let number = data.teletypedescription.toLowerCase();

                        if ( number.includes('mail') ) {

                            return lookupWrapper('Email Party', data.partyid, data.number);

                        } else if ( number.includes('work') ||
                                    number.includes('cell') ||
                                    number.includes('home') ||
                                    number.includes('number') ) {

                            return htmlAnchor( 'tel:', htmlDecode(data.number));

                        } else {

                            return data.number;

                        }
                    }
                },


            ];
        
            return tableColumnDefs;
        },

        loadArrayTable() {

            this.partyNumber.errorFlag = false;
            this.partyNumber.errorMessage = '';

            this.columnDefs = this.createColumnDefs();

            this.partyNumber.table = $('#' + this.tableId).DataTable({
                destroy: true,
                serverSide: false,
                dom: "rt",
                rowId: 'id',
                scrollY: '20Vh',
                processing: false,
                
                ordering: true,
                select: false,
                scrollX: true,
                scrollCollapse: false,
                scroller: { loadingIndicator: false },

                language: {
                    emptyTable: "",
                    processing: "",
                    zeroRecords: "",
                    loadingRecords: "",
                },
                data: [],             
                order: [[1, "asc"]],
                columnDefs: this.columnDefs,
            });
            
        },

        newPartyNumber() {

            this.partyNumber.errorFlag = false;
            this.partyNumber.errorMessage = '';
            this.partyNumber.id = null;
            this.partyNumber.description = null;
            this.partyNumber.internalFlag = '0';
            this.partyNumber.sorter = '1';

            // Work on this..
            this.partyNumber.method = 'Email';
            this.partyNumber.methodId = root.control.emailphoneid;

            this.selectTelephoneType.record = {
                recordid: this.partyNumber.methodId,
                description: this.partyNumber.method,
                internalflag: this.partyNumber.internalFlag,
            }

            this.formTitle = 'Contact Number will be Added';

            $('#' + this.id).modal();
            $('#' + this.id + ' input[name="description"]').focus();

            setTimeout(() => { $('#' + this.id + " .popover-icon").popover(); }, 100);            

        },    

        editClicked(id) {

            this.partyNumber.errorFlag = false;
            this.partyNumber.errorMessage = '';

            let rowData = this.table.row('#' + id).data();

            //console.log('rowData',rowData);

            if (typeof rowData === 'object') {

                this.partyNumber.id = id;
                this.partyNumber.method = rowData.teletypedescription;
                this.partyNumber.methodId = rowData.telephonetypeid;
                this.partyNumber.description = rowData.number;
                this.partyNumber.internalFlag = rowData.internalflag;
                this.partyNumber.sorter = rowData.sorter;

                //console.log('this.partyNumber',this.partyNumber);

                this.selectTelephoneType.record = {
                    recordid: rowData.teletypeid,
                    description: rowData.teletypedescription,
                    internalflag: rowData.internalFlag,
                }

                this.formTitle = 'Contact Number will be Changed';

                $('#' + this.id).modal();
                $('#' + this.id + ' input[name="description"]').focus();

                setTimeout(() => { $('#' + this.id + " .popover-icon").popover(); }, 100);

            } else {

                showError( 'System Error', 'Party Number (' + id + ') not found trying to Edit row');

            }
        },

        setLabel() {

            if ( this.partyNumber.method && this.partyNumber.method.toLowerCase().includes('email')) {
                return "Email Address";
            } else {
                return "Number";
            }

        },

        telephoneTypeSelected(id,description,internalFlag) {

            this.partyNumber.method = description;
            this.partyNumber.methodId = id;
            this.partyNumber.internalFlag = internalFlag;

        },

        submitForm(e) {

            e.preventDefault();

            console.log('this.partyNumber.methodId,root.control.emailphoneid',this.partyNumber.methodId,root.control.emailphoneid);

            if ( this.partyNumber.methodId === root.control.emailphoneid) {

                if (!isValidEmailAddress(this.partyNumber.description)) {

                    this.partyNumber.errorFlag = true;
                    this.partyNumber.errorMessage = 'Invalid email address';

                    $('#' + this.id + ' input[name="description"]').focus();

                    return;

                }
            }


            if ( this.partyNumber.description && this.partyNumber.method && this.partyNumber.methodId ) {

                this.partyNumber.errorFlag = false;
                this.savePartyNumber();

            } else {

                showError( 'Error', 'Record could not be Saved');

            }
        },

        savePartyNumber() {

            let _this = this;

            let record = {
                recordid: this.partyNumber.id,
                partyId: this.parentId,
                number: this.partyNumber.description,
                telephonetypeid: this.partyNumber.methodId,
                internalFlag: this.partyNumber.internalFlag ? this.partyNumber.internalFlag : '0', 
                sorter: this.partyNumber.sorter, 
            };


            axios.post('/partele/store', record )

            .then(response => {

                if (response.data.errors ) {

                    this.partyNumber.errorFlag = true;
                    this.partyNumber.errorMessage = response.data.errors;

                    $('#' + this.id + ' input[name="description"]').focus();

                } else {

                    this.table.ajax.reload();

                    $('#' + this.id).modal('hide');
                }
                

            });



        },

        forgetPartyNumbers() {

            axios.get("/parties/forgetPartyNumbers");

        },


        storePartyNumbers() {

            var rowData = [];

            this.partyNumber.table.rows().every( function ( index ) {

                let thisRow = this.data();
        
                rowData.push({
                    method: thisRow.method,
                    description: thisRow.description,
                    internalFlag: thisRow.internalFlag,
                })

            });

        },


        deleteRecord() {

            axios.post("/partele/delete/" + this.partyNumber.id)
            
            .then(response => {

                this.table.ajax.reload();

                $('#' + this.id).modal('hide');

            });


        },



    },


}  
</script>
