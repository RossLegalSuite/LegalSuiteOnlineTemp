<template>

<div id="settings-right">

    <setup-company v-show="activePage === 'Company'" ref="setup-company"/>

    <setup-system-templates v-show="activePage === 'Templates'" ref="setup-system-templates"/>

    <setup-system-components v-show="activePage === 'Components'" ref="setup-system-components"/>

</div>
</template>

<script>

export default {
    components: {
        SetupCompany: () => import("./SetupCompany"),
        SetupSystemTemplates: () => import("./SetupSystemTemplates"),
        SetupSystemComponents: () => import("./SetupSystemComponents"),
    },

    data() {
        return {
            activePage: null,
            table: null,
            templatesTable: null,
            componentsTable: null,
        }
    },

    watch: {
        
        activePage(newValue) {

            $('#settings-right .popover-icon').popover();

            if ( newValue === "Company") {

                let setupCompany = this.$refs['setup-company'];

                setupCompany.record = {...root.control, ...root.lolSettings};

                setupCompany.activeTab = 'LetterHead';

                //console.log("settingsRight - setupCompany.record",setupCompany.record);

            } else if ( newValue === "Templates") {

                this.templatesTable = this.$refs['setup-system-templates'].$refs['settings-system-templates-table']

                setTimeout(() => {

                    if ( this.templatesTable.table ) {

                        this.templatesTable.table.columns.adjust;

                    } else {

                        this.templatesTable.selectTableFlag = false;

                        this.templatesTable.tableOptions = { tableBottom: 80 }; 

                        this.templatesTable.loadDataTable( this.adjustTemplatesTableColumns ); 

                    }

                },100);

            } else if ( newValue === "Components") {

                this.componentsTable = this.$refs['setup-system-components'].$refs['settings-system-components-table']

                setTimeout(() => {

                    if ( this.componentsTable.table ) {

                        this.componentsTable.table.columns.adjust;

                    } else {

                        this.componentsTable.tableOptions = { tableBottom: 80 }; 

                        this.componentsTable.loadDataTable( this.adjustComponentsTableColumns ); 

                    }

                },100);

            }
            

        }
    },
    methods: {

        adjustTemplatesTableColumns() {
            this.templatesTable.table.columns.adjust;
        },

        adjustComponentsTableColumns() {
            this.componentsTable.table.columns.adjust;
        },

    },


}  
</script>
