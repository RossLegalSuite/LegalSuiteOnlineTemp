<template>
    <div class="card h-100 border-0">
        <div class="card-header">
            <div class="d-flex justify-content-between">
                <h3 class="page-title">Fee Notes: <span v-html="pageTitle()"></span></h3>
                <page-close-button @closeClicked="closeClicked"/>
            </div>
        </div>

        <div class="card-body overflow-auto p-3">

            <common-fee-notes-table 
                :ref="'common-' + parentType.toLowerCase() + '-fee-notes-table'" 
                :formRef="'common-' + parentType.toLowerCase() + '-fee-notes-form'" 
                :tableId="'common-' + parentType.toLowerCase() + '-fee-notes-table'"
                :lazyLoadFlag="true"
                :parentType="parentType"
            />

            <common-fee-notes-form 
                :ref="'common-' + parentType.toLowerCase() + '-fee-notes-form'" 
                :uniqueId="'common-' + parentType.toLowerCase() + '-fee-notes-form'"
                :id="'common-' + parentType.toLowerCase() + '-fee-notes-form'"
                :parentTableRef="'common-' + parentType.toLowerCase() + '-fee-notes-table'"
                :modal="true"
            />
            
        </div>

        <select-fee-codes :formControls="false" :id="'common-' + parentType.toLowerCase() + '-select-fee-codes'" :ref="'common-' + parentType.toLowerCase() + '-select-fee-codes'" :formRef="'common-' + parentType.toLowerCase() + '-select-fee-codes'"/> 
        <select-matter :formControls="false" :id="'common-' + parentType.toLowerCase() + '-select-matter'" :ref="'common-' + parentType.toLowerCase() + '-select-matter'" :formRef="'common-' + parentType.toLowerCase() + '-select-matter'"/> 
        <add-fee-notes :id="'common-' + parentType.toLowerCase() + '-add-fee-notes'" :ref="'common-' + parentType.toLowerCase() + '-add-fee-notes'"/> 

    </div>
</template>  

<script>

import { mapGetters } from 'vuex';

export default {

    components: {
        CommonFeeNotesTable: () => import("@pages/feenotes/FeeNoteTable"),
        CommonFeeNotesForm: () => import("@pages/feenotes/FeeNoteForm"),
        AddFeeNotes: () => import("@pages/feenotes/AddFeeNotes"),
        SelectFeeCodes: () => import("@pages/feecodes/SelectFeeCodes"),
        SelectMatter: () => import("@pages/matters/SelectMatter"),
    },

    computed: {

        ...mapGetters(['currentMatter', 'currentParty', 'currentEmployee']),

    },

    props: {
        parentType: String,
    },

    data() {
        return {
            selectedMatterId: null,
        };
    },


    methods: {

        selectFeeCode() {

            if ( this.parentType === "Matter" ) {
                
                this.selectedMatterId = this.currentMatter.recordid;

                axios.post('/matters/get',{
                    id: this.currentMatter.recordid,
                    basicColumns: true
                })

                .then(response => {


                    this.selectFeeCodes.selectFeeCodes(response.data.data[0].feeSheetId);
                });

            } else {

                this.selectMatter.selectMatter(this);

            }

        },

        matterSelected(id) {

            this.selectedMatterId = id;

            axios.post('/matters/get',{
                id: id,
                basicColumns: true
            })

            .then(response => {

                this.selectFeeCodes.selectFeeCodes(response.data.data[0].feeSheetId);
            });

        },


        async feeCodesSelected(selectedRows, feeSheetId) {

            axios.post('/feecodes/getFeeItems', {
                feeCodes: selectedRows,
                feeSheetId: feeSheetId,
            })
            
            .then(response => {

                if (response.data.error) {

                    showError( 'Error', response.data.error);

                } else {

                    const dateNow = moment().format(root.control.dateformat + ' HH:mm:ss');

                    response.data.feeItems.forEach(feeItem => {
                        feeItem.allocatedToId = loggedInEmployeeAllocateToId;
                        feeItem.allocatedEmployeeName = loggedInEmployeeAllocateToName;
                        feeItem.dateTime = dateNow;
                        feeItem.originalAmount = feeItem.amount;
                    });

                    this.addFeeNotes.show();

                    this.addFeeNotes.loadDataTable(response.data.feeItems, dateNow);

                }

            }).catch(error => { showError('Error getting Fee Items', error); });

        },


        closeClicked() { 

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].clearPages();

        },

        pageTitle() {
            
            if ( this.parentType === 'Matter') {
                return (this.currentMatter.fileref) ? this.currentMatter.fileref + ' - ' + this.currentMatter.description : '';
            } else if ( this.parentType === 'Employee') {
                return (this.currentEmployee.name) ? this.currentEmployee.name : '';
            }

        },


        newRecordButtonClicked() {

            this.$refs['common-' + this.parentType.toLowerCase() + '-fee-notes-form'].insertClicked();

        },

    },
}
</script> 