<template>

<div  class="card h-100 border-0">
    
    <div class="card-header">
        <div class="d-flex justify-content-between">
            <h3>Party Types</h3>
            <page-close-button @closeClicked="hide"/>
        </div>
    </div>

    <div class="card-body overflow-auto p-3">

        <party-type-table
            table-id="settings-party-type-table"
            :lazyLoadFlag="true"
            ref="settings-party-type-table"
            :formRef="'settings-party-type-form'"
        />

    </div>

    <party-type-form 
        :id="_uid + '-settings-party-type-form'"
        ref="settings-party-type-form" 
        parentTableRef="settings-party-type-table"
        :modal="true"
    />

</div>
    
</template>

<script>

export default {

    components: {
        PartyTypeTable: () => import("@pages/parties/PartyTypeTable"),
        PartyTypeForm: () => import("@pages/parties/PartyTypeForm"),
    },


    data() {
        return {
            activePage: 'PartyTypes',
            table: null,
        }
    },    

    methods: {

        hide() {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].closePage(this.activePage);

        },


        newRecordButtonClicked: function () {

            this.$refs['settings-party-type-form'].table = this.table;

            this.$refs['settings-party-type-form'].insertClicked();

        },

    },    

}
</script>