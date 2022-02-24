<template>
<div>

    <debtors-account-table 
        :ref="uniqueId + '-debtors-account-table'" 
        :formRef="uniqueId + '-debtors-account-form'" 
        :tableId="uniqueId + '-debtors-account-table'"
        :parent-id="currentMatter.recordid"
        :lazy-load-flag="true"
    />

    <debtors-account-form 
        :ref="uniqueId + '-debtors-account-form'" 
        :id="uniqueId + '-edit-debtors-account'"
        :parentTableRef="uniqueId + '-debtors-account-table'"
    />

</div>
</template>  

<script>

import { mapGetters } from 'vuex';

export default {

    components: {
        DebtorsAccountTable: () => import("@pages/debtors-account/DebtorsAccountTable"),
        DebtorsAccountForm: () => import("@pages/debtors-account/DebtorsAccountForm"),
    },

    computed: {

        ...mapGetters(['currentMatter']),

    },
    props: {
        uniqueId: String
    },

    methods: {

        newRecordButtonClicked() {

            this.$refs[this.uniqueId + '-debtors-account-form'].insertClicked();

        },

    },
}
</script> 