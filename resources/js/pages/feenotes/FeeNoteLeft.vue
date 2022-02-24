<template>
    <div class="card h-100 border-0">
        <div class="card-header feenotes-bg">
            <div class="d-flex justify-content-between">
                <h3><i class="fa fa-money mr-2"></i>Fee Notes</h3>
                <page-close-button @closeClicked="closeLeftPage(pageName)"/>
            </div>
        </div>

        <div id="fee-note-left-body" class="card-body overflow-auto pb-0 pt-3 px-3">

            <fee-note-table
                :lazy-load-flag="true"
                :tagging="false"
                form-ref="fee-note-form" 
                ref="fee-notes-table" 
                tableId="fee-notes-table"
                parentType="General"
            />

        </div>

        <select-fee-codes :formControls="false" id="fee-note-left-select-fee-codes" ref="fee-note-left-select-fee-codes" formRef="fee-note-left-select-fee-codes"/> 
        <add-fee-notes id="fee-note-left-add-fee-notes" ref="fee-note-left-add-fee-notes"/> 
        <select-matter :formControls="false" id="fee-note-left-select-matter" ref="fee-note-left-select-matter" formRef="fee-note-left-select-matter"/>

    </div>
</template>     

<script>

import { mapGetters } from 'vuex';
import { mapMutations } from 'vuex';
import leftTemplate from "../left-template";

export default {

    extends: leftTemplate,

    components: {
        FeeNoteTable: () => import("./FeeNoteTable"),
        AddFeeNotes: () => import("./AddFeeNotes"),
        SelectFeeCodes: () => import("@pages/feecodes/SelectFeeCodes"),
        SelectMatter: () => import("@pages/matters/SelectMatter"),
    },

    data() {
        return {
            pageName: "FeeNotes",
            selectedRows: [],
            selectedAllFlag: false,
            tableMounted: false,
            selectedMatter: {},
        };
    },

    computed: {
        ...mapGetters(['leftTabs', 'activeLeftTabs', 'currentMatter']),
    },

    watch: {

        tableMounted() { this.initializeTable(); },

    },

    activated() {

        if ( $('#fee-notes-table').length ) {

            let scrollTop = $('#fee-notes-table' + '_wrapper .dataTables_scrollBody').offset().top;
            let tableTop = $('#fee-notes-table').offset().top;

            if ( tableTop > scrollTop ) this.table.table.ajax.reload();

        }
    },


    mounted() {

        let thisTab = this.leftTabs.filter(tab => tab.pageName === this.pageName);

        if (thisTab.length)  this.displayLeftTab(thisTab[0]);

    },    

    methods: {

        ...mapMutations(['displayLeftTab','hideLeftTab']),

        initializeTable() {

            // Order by Date descending
            this.table.initialOrder = [[1, "desc"], [2, "asc"]];

            this.table.tableOptions = { tableBottom: 80 }; 

            // Used to lazy load the Form (and all its sub components) on the right
            this.table.loadDataTable(() =>{
                this.$root.feeNoteLeftTableLoaded = true;
            });

        },

        newRecordButtonClicked() {

            let thisForm = root.$refs['pages'].$refs["right-page"].$refs['fee-note-form'];

            thisForm.insertClicked();

        },

        selectFeeCode() {

            this.selectMatter.selectMatter(this);

        },

        matterSelected(selectedRecord) {

            this.selectedMatter = selectedRecord;

            this.selectFeeCodes.selectFeeCodes(selectedRecord.clientfeesheetid);

        },

        feeCodesSelected(taggedRecords) {

            root.$snotify.simple('Creating the Fee Notes', 'Please Wait..', { timeout: 0, icon: 'img/cogs.gif' });

            axios.post('/utils/call/getFeeItems', { 
                matterId: this.selectedMatter.recordid,
                employeeId: this.selectedMatter.employeeid,
                languageId: this.selectedMatter.accountslanguageid,
                feeCodes: taggedRecords.join()
            })

            .then(response => {

                if ( response.data.errors ) {

                    showError('Error', response.data.errors);

                } else {

                    const todaysDate = moment().format(root.control.dateformat);

                    root.$snotify.clear();

                    this.addFeeNotes.show();

                    this.addFeeNotes.loadDataTable(response.data.data, this.selectedMatter, todaysDate);
                }

            }).catch( (error) => {

                showError('Error',error);

            });


        },



    },
}
</script>