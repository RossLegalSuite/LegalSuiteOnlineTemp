<template>
<span>


    <b-dropdown v-if="parent.selectedRows && parent.selectedRows.length" 
    :id="this.tableId + '-actions-dropdown-menu'" size="sm" right variant="secondary" class="mr-2" :title="'Perform tasks on the tagged ' + $parent.plural">
        <template v-slot:button-content>
            <i class="fa fa-check-square-o fa-lg mr-2 pt-1" ></i>Tagged
            <span class="badge badge-danger mx-1">{{parent.selectedRows.length}}</span>
        </template>

        <b-dropdown-item-button 
            v-show="parent.generateDocumentsFlag && parent.generateDocumentsSource"
            variant="secondary" 
            :title="'Assemble documents for the tagged ' + $parent.plural" 
            @click="generateDocuments">
            <i class="fa fa-cog fa-lg mr-2"></i>Generate Documents
        </b-dropdown-item-button>
        
        <b-dropdown-divider v-if="parent.generateDocumentsFlag && parent.generateDocumentsSource"/>

        <b-dropdown-item-button 
            v-show="parent.emailRecords"
            variant="secondary" 
            :title="emailTaggedTitle"
            @click="emailRecords">
            <i class="fa fa-envelope-o fa-lg mr-2"></i>
            <span v-text="emailTaggedText"></span>
        </b-dropdown-item-button>
        
        <b-dropdown-divider v-if="parent.emailRecords"/>

        <b-dropdown-item-button 
            v-show="parent.completeTaggedRecords"
            variant="secondary" 
            :title="'Mark the tagged ' + table.plural + 'as Completed'" 
            @click="completeTaggedRecords">
            <i class="fa fa-edit fa-lg mr-2"></i>Complete Tagged {{table.plural}} 
        </b-dropdown-item-button>
        
        <b-dropdown-divider v-if="parent.completeTaggedRecords"/>

        <b-dropdown-item-button 
            v-show="parent.deleteTaggedRecords"
            variant="secondary" 
            :title="'Delete the tagged ' + table.plural"
            @click="deleteTaggedRecords">
            <i class="fa fa-times-circle fa-lg mr-2"></i>Delete Tagged {{table.plural}}
        </b-dropdown-item-button>

        <b-dropdown-divider v-if="parent.deleteTaggedRecords"/>

        <b-dropdown-item-button
            v-show="!table.displayingTaggedRecordsFlag" 
            variant="secondary" 
            :title="'Display the tagged ' + table.plural"
            @click="displayTaggedRecords">
            <i class="fa fa-tags fa-lg mr-2"></i>Show Tagged
        </b-dropdown-item-button>

        <b-dropdown-item-button
            v-show="table.displayingTaggedRecordsFlag" 
            variant="secondary" 
            :title="'Display all the ' + table.plural"
            @click="displayTaggedAndUntaggedRecords">
            <i class="fa fa-database fa-lg mr-2"></i>Show All
        </b-dropdown-item-button>

        <b-dropdown-divider/>

        <b-dropdown-item-button 
            variant="secondary" 
            :title="'Untag the tagged ' + table.plural"
            @click="unTagAllRecords">
            <i class="fa fa-times-circle fa-lg mr-2"></i>Untag All
        </b-dropdown-item-button>



    </b-dropdown>

</span>
</template>

<script>

export default {

    props: {
        tableId: String,
    },

    computed: {

        emailTaggedText() {
            return this.parent.selectedRows.length > 1 ? 'Email Tagged ' + this.$parent.plural : 'Email Tagged ' + this.$parent.singular;
        },

        emailTaggedTitle() {
            return this.parent.selectedRows.length > 1 ? 'Send emails to the tagged ' + this.$parent.plural : 'Send an email to the tagged ' + this.$parent.singular;
        },

    },


    created() {

        this.table = this.$parent;
        this.parent = this.table.$parent;
        this.table.actionsDropDown = this;

    },    

    methods: {

        displayTaggedRecords() {

            this.table.displayingTaggedRecordsFlag = true;

            this.table.savedWhereRaw = this.table.whereRaw;

            this.table.whereRaw = this.table.tableName + ".recordid in (select taggedId from LolTagged where [LolTagged].[tableName] = '" + this.table.tableName + "' and [LolTagged].[employeeId] = " + root.loggedInEmployeeId + ")";

            this.table.table.ajax.reload();

        },

        displayTaggedAndUntaggedRecords() {

            this.table.displayingTaggedRecordsFlag = false;

            this.table.whereRaw = this.table.savedWhereRaw;

            this.table.table.ajax.reload();

        },

        unTagAllRecords() {

            this.table.toggleTaggedRows(this.parent);

        },

        emailRecords() {

            if ( this.parent.selectedRows.length > 1) {

                if ( typeof this.parent.emailRecords === 'function') {
                    this.parent.emailRecords();
                } else {
                    console.error('emailRecords() Not found in parent');
                }

            } else {


                if ( typeof this.parent.emailThisRecord === 'function') {
                    this.parent.emailThisRecord(this.parent.selectedRows[0]);
                } else {
                    console.error('emailThisRecord() Not found in parent');
                }

            }

        },

        generateDocuments() {

            this.templateType = 'Document';

            root.selectTemplates.load(this, 'Document', this.parent.generateDocumentsSource);

        },

        templatesSelected( selectedTemplates ) {

            primeGenerateDocumentPreviewer( this.parent, selectedTemplates );

        },

        // For Reminders
        completeTaggedRecords() {
            if ( typeof this.parent.completeTaggedRecords === 'function') {
                this.parent.completeTaggedRecords();
            } else {
                console.error('completeTaggedRecords() Not found in parent');
            }
        },

        deleteTaggedRecords() {
            if ( typeof this.parent.deleteTaggedRecords === 'function') {
                this.parent.deleteTaggedRecords();
            } else {
                console.error('deleteTaggedRecords() Not found in parent');
            }
        },

    }
}  
</script>
