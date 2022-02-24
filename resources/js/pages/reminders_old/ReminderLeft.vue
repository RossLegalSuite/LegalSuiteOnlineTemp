<template>
    <div class="card h-100 border-0">
        <div class="card-header reminders-bg">
            <div class="d-flex justify-content-between">
                <h3><i class="fa fa-calendar-check-o mr-2"></i>Reminders</h3>
                <page-close-button @closeClicked="closeLeftPage(pageName)"/>
            </div>
        </div>

        <div class="card-body overflow-auto pb-1 pt-3 px-3">

            <reminder-table
                :lazy-load-flag="true"
                :tagging="true"
                form-ref="reminder-form" 
                ref="reminders-table" 
                table-id="reminders-table"
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
        };
    },

    computed: {
        ...mapGetters(['leftTabs', 'activeLeftTabs']),
    },

    watch: {

        tableMounted() { this.initializeTable(); },

    },


    mounted() {

        let thisTab = this.leftTabs.filter(tab => tab.pageName === this.pageName);

        if (thisTab.length)  this.displayLeftTab(thisTab[0]);

    },    

    methods: {

        ...mapMutations(['displayLeftTab','hideLeftTab']),

        initializeTable() {

            // Used to lazy load the Form (and all its sub components) on the right
            this.table.loadDataTable(() =>{
                this.$root.reminderLeftTableLoaded = true;
            });


        },

        completeTaggedRecords() {

            showWaiting('Updating Reminders');

            axios.post('/reminders/complete', {id: this.selectedRows, date: moment().format(root.control.dateformat + ' HH:mm:ss')})

            .then(response => {

                if ( response.data.error ) {

                    showError('Error',response.data.error);

                } else {

                    this.table.loadDataTable();

                }

            })

            .finally(() => {

                closeWaiting();

            });


        },

        newRecordButtonClicked() {

            let thisForm = root.$refs['pages'].$refs["right-page"].$refs['reminder-form'];

            thisForm.currentParentType = thisForm.record.parentType || 'Matter';

            thisForm.insertClicked();

        },

        deleteTaggedRecords() {

            this.tryDeleteTaggedRecords('reminders');

        },

    },
}
</script>