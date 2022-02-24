<template>
    <div class="card h-100 border-0">
        <div class="card-header filenotes-bg">
            <div class="d-flex justify-content-between">
                <h3><i class="fa fa-calendar-check-o mr-2"></i>Reminders</h3>
                <page-close-button @closeClicked="closeLeftPage(pageName)"/>
            </div>
        </div>

        <div id="reminder-left-body" class="card-body overflow-auto pb-0 pt-3 px-3">

            <reminder-table
                :lazy-load-flag="true"
                :tagging="false"
                form-ref="reminder-form" 
                ref="reminders-table" 
                tableId="reminders-table"
                parentType="General"
            />

        </div>

    </div>
</template>     

<script>

import { mapGetters } from 'vuex';
import { mapMutations } from 'vuex';
import leftTemplate from "../left-template";

export default {

    extends: leftTemplate,

    components: {
        ReminderTable: () => import("./ReminderTable"),
    },

    data() {
        return {
            pageName: "Reminders",
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

        if ( $('#reminders-table').length ) {

            let scrollTop = $('#reminders-table' + '_wrapper .dataTables_scrollBody').offset().top;
            let tableTop = $('#reminders-table').offset().top;

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
            this.table.initialOrder = [[3, "desc"]];

            this.table.tableOptions = { tableBottom: 80 }; 

            // Used to lazy load the Form (and all its sub components) on the right
            this.table.loadDataTable(() =>{
                this.$root.reminderLeftTableLoaded = true;
            });

        },

        newRecordButtonClicked() {

            let thisForm = root.$refs['pages'].$refs["right-page"].$refs['reminder-form'];

            thisForm.insertClicked();

        },


    },
}
</script>