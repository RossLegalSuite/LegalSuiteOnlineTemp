<template>
    <fee-code-form 
        v-show="activePage === 'Form'" 
        id="fee-codes-right-fee-code-form" 
        ref="fee-code-form"
        leftPageTableRef="fee-codes-table"
        :modal="false"
        uniqueId="fee-codes-right" 
    />
</template>

<script>

export default {

    components: {
        FeeCodeForm: () => import("./FeeCodeForm"),

    },

    data() {
        return {
            activePage: null,
        }
    },


}

</script>
