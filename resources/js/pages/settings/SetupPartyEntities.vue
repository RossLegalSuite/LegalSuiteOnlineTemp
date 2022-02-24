<template>

<div  class="card h-100 border-0">
    
    <div class="card-header">
        <div class="d-flex justify-content-between">
            <h3>Party Entities</h3>
            <page-close-button @closeClicked="hide"/>
        </div>
    </div>

    <div class="card-body overflow-auto p-3">

        <party-entity-table
            table-id="settings-party-entity-table"
            :lazyLoadFlag="true"
            ref="settings-party-entity-table"
            :formRef="'settings-party-entity-form'"
        />

    </div>

    <party-entity-form 
        :id="_uid + '-settings-party-entity-form'"
        ref="settings-party-entity-form" 
        parentTableRef="settings-party-entity-table"
        :modal="true"
    />

</div>
    
</template>

<script>

export default {

    components: {
        PartyEntityTable: () => import("@pages/parties/PartyEntityTable"),
        PartyEntityForm: () => import("@pages/parties/PartyEntityForm"),
    },


    data() {
        return {
            activePage: 'PartyEntities',
            table: null,
        }
    },    

    methods: {

        hide() {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].closePage(this.activePage);

        },


        newRecordButtonClicked: function () {

            this.$refs['settings-party-entity-form'].table = this.table;

            this.$refs['settings-party-entity-form'].insertClicked();

        },

    },    

}
</script>