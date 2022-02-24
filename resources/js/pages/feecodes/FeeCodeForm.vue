<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lg' : ''">

        <div :class="modal ? 'modal-content steelblue-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header steelblue' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="viewing">Fee Code</span>
                            <span v-else-if="editing">Fee Code will be Changed</span>
                            <span v-else>Fee Code will be Added</span>
                        </h3>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="card-body overflow-auto p-3"  :style="modal ? 'height: 70vh' : ''">

                <div class="form-group row">

                    <text-input 
                        v-if="editing"
                        _class="col-md-4" 
                        popOver="<h4>Code</h4>
                        <p>The code is used to uniquely identify this Fee Code.</p>"
                        :popOverContainer="'#' + id"
                        v-model="record.code"
                        name="code"
                        label="Code"
                        :error="errors.code"
                    />

                    <text-input :_class="editing ? 'col-md-8' : 'col-md-12'" v-model="record.description" name="description" label="Description" :error="errors.description"/>

                </div>

                <fieldset v-show="editing" class="mt-1"><legend>

                    <span>Fee Items</span></legend>

                    <fee-item-table 
                        :ref="id + '-fee-items-table'" 
                        :formRef="id + '-fee-items-table'"
                        :tableId="id + '-fee-items-table'"
                        :lazy-load-flag="true"
                        :formTable="true"
                        :searchInputFocus="false"
                    />

                </fieldset>

            </div>

            <div class="modal-footer justify-content-between">
                <div>

                    <button v-show="editing && !viewing" class="btn btn-danger form-button mr-2" type="button" @click="deleteClicked" title="Delete this Fee Code">
                        <i class="fa fa-times-circle fa-lg mr-2"></i>Delete
                    </button>

                    <button v-show="editing && !viewing" class="btn btn-secondary form-button" type="button" @click="copyClicked" title="Copy this  Fee Code">
                        <i class="fa fa-clone fa-lg mr-2"></i>Copy
                    </button>

                </div>

                <div>

                    <button class="btn btn-success form-button mr-3" @click="okClicked" type="button" title="Save the Fee Code"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>

                    <button v-if="editing" class="btn btn-danger form-button" @click="closeForm" type="button" title="Exit without saving"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>

                    <button v-else class="btn btn-danger form-button" @click="closeForm" type="button" title="Close this screen"><i class="fa fa-times-circle fa-lg mr-2"></i>Close</button>

                </div>
            </div>

        </div>
    </div>

    <fee-item-form 
        :id="id + '-fee-code-form-fee-item-form'"
        ref="fee-items-form" 
        :parentTableRef="id + '-fee-items-table'"
        :modal="true"
    />

    <select-fee-sheets :id="id + '-select-fee-sheets'" :ref="id + '-select-fee-sheets'" :formRef="id + '-select-fee-sheets'"/>

</div>

</template>    

<script>

import FormTemplate from "@pages/form-template";
import modalTemplate from "@components/modals/modal-template";

export default {
    
    mixins: [FormTemplate, modalTemplate],

    components: {
        FeeItemTable: () => import("@pages/feeitems/FeeItemTable"),
        FeeItemForm: () => import("@pages/feeitems/FeeItemForm"),
        SelectFeeSheets: () => import("@pages/feesheets/SelectFeeSheets"),
    },

    props: {
        resource: {type: String, default: 'Fee Codes' },
    },

    methods: {

        editRecord(id) {

            axios.post('/feecodes/get',{recordid: id})

            .then(response => {

                this.record = response.data.data[0];

                this.initFormData();

                this.loadFeeItemsTable();

            });

        },

        initNewRecord( feeSheetId ) {

            console.log('initNewRecord feeSheetId',feeSheetId);

            this.record = {
                code: null,
                description: null,
                feeSheetId: feeSheetId,
            };

            this.initFormData();

        },

        initFormData() {

            //if ( !this.$root.feeSheets.length) this.$root.getFeeSheets();
                
            this.displayForm();

            setTimeout(() => $('#' + this.id + ' input[name="description"]').focus() );

            // if ( this.editing ) {

            //     this.selectFeeSheet.record = {
            //         id: this.record.feeSheetId,
            //         description: htmlDecode(this.record.feeSheetDescription),
            //     };

            // } else {

            //     axios.post("/feesheets/get", { 
            //         id: this.record.feeSheetId 
            //     }).then(response => {

            //         this.selectFeeSheet.record = {
            //             id: response.data.data[0].id,
            //             description: htmlDecode(response.data.data[0].description),
            //         };

            //         this.record.feeSheetId = this.selectFeeSheet.record.id;
            //     });

            // }

        },

        loadFeeItemsTable() {

            this.feeItemsTable = this.$refs[this.id + '-fee-items-table'];

            this.feeItemsTable.parentId = this.record.id;

            this.feeItemsTable.tableOptions = {

                emptyTable: "Add Fee Items",
                ordering: false, // Always order by sorter

            };

            setTimeout(this.feeItemsTable.loadDataTable);

        },

        addFeeItem() {

            this.$refs['fee-items-form'].insertClicked( this.record.id);

        },

        //Deprecate?
        selectRecord(id) {

            axios.post('/feecodes/get',{recordid: id}).then(response => {

                if ( typeof this.$parent.feeCodeSelected === 'function') this.$parent.feeCodeSelected(response.data.data[0]);

            });

        },


        copyClicked() {
            
            this.selectFeeSheets.selectFeeSheets( this.record.feeSheetId, this.record.feeSheetCode);
        },

        feeSheetsSelected(selectedRows, table) {

            // Returns empty array if all are selected
            let params = ( selectedRows.length ) ? { whereIn: { column: 'fee_sheets.id', value: selectedRows } } :  {tableFilter: table.tableFilter};

            params = {...params, orderBy: 'fee_sheets.description'};

            axios.post('/feesheets/get', params)

            .then(response => {

                this.copyFeeCode(response.data);

            });

        },


        copyFeeCode( feeSheets ) {

            let copyRecord = { 
                id: null,
                code: null,
                copyFlag: true,
                copyId: this.record.id,
                feeSheets: feeSheets,
            };

            let saveRecord = { ...this.record, ...copyRecord };

            axios.post('/feecodes/store', saveRecord)
            
            .then(response => {

                if (response.data.errors) {

                    if (response.data.errors.general) { showError( 'Error', response.data.errors.general[0]);} else { this.errors = response.data.errors; }

                } else {

                    root.$snotify.success('The Fee Code was copied successfully');

                    this.$parent.feeCodesTable.refresh();

                }

            });

        },


        okClicked() {

            axios.post('/feecodes/store', this.record)
            
            .then(response => {

                if (response.data.errors) {

                    if (response.data.errors.general) { showError( 'Error', response.data.errors.general[0]);} else { this.errors = response.data.errors; }

                } else {

                    this.errors = {};

                    // In case we are viewing the record from the LookupWrapper, e.g. in SelectFeeCode.vue
                    if ( this.table) {
                        this.highlightTableRow(response.data.id, response.data.code);
                    } else {
                        this.closeForm();
                    }

                }

            }).catch(error => { showError('Error saving ' + this.table.singular, error); });

        },

        highlightTableRow( id, code ) {

            axios.post('/feecodes/getTablePosition', { code: code })

            .then(response => {

                this.table.jumpToRow(id, response.data);
                
                if (!this.editing) {

                    this.editClicked(id);

                } else {

                    this.closeForm();

                }

            });

        },     

    },
}

</script>
