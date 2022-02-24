<template>
    <div class="card h-100 border-0">
        <div class="card-header">
            <div class="d-flex justify-content-between">
                <h3 class="page-title">Matters: <span v-html="pageTitle()"></span></h3>
                <page-close-button @closeClicked="closeClicked"/>
            </div>
        </div>

        <div class="card-body overflow-auto p-3">

            <party-matters-table 
                ref="party-matters-table" 
                table-id="party-matters-table"
                :lazy-load-flag="true"
            />

        </div>
    </div>
</template>  

<script>

import { mapGetters } from 'vuex';

export default {

    components: {
        PartyMattersTable: () => import("./PartyMattersTable"),
    },

    props: {
        parentType: String,
    },

    computed: {
        ...mapGetters(['currentParty']),
    },

    methods: {

        pageTitle() {
            
            return (this.currentParty.code) ? this.currentParty.code + ' - ' + this.currentParty.name : '';

        },

        closeClicked() { 

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].clearPages();

        },

    },
}
</script> 