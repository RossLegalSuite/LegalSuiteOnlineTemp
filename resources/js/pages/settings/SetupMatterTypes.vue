<template>

<div  class="card h-100 border-0">
    
    <div class="card-header">
        <div class="d-flex justify-content-between">
            <h3>Matter Types</h3>
            <page-close-button @closeClicked="hide"/>
        </div>
    </div>

    <div class="card-body overflow-auto p-3">

        <matter-type-table
            table-id="settings-matter-type-table"
            :lazyLoadFlag="true"
            ref="settings-matter-type-table"
            :formRef="'settings-matter-type-form'"
        />

    </div>

    <matter-type-form 
        :id="_uid + '-settings-matter-type-form'"
        ref="settings-matter-type-form" 
        :modal="true"
    />

</div>
    
</template>

<script>

export default {

    components: {
        MatterTypeTable: () => import("@pages/matters/MatterTypeTable"),
        MatterTypeForm: () => import("@pages/matters/MatterTypeForm"),
    },


    data() {
        return {
            activePage: 'MatterTypes',
            table: null,
        }
    },    

    methods: {

        hide() {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].closePage(this.activePage);

        },


        newRecordButtonClicked: function () {

            this.$refs['settings-matter-type-form'].table = this.table;

            this.$refs['settings-matter-type-form'].insertClicked();

        },

    },    

}
</script>