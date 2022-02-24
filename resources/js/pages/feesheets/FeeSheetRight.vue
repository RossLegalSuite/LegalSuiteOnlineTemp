<template>
    <fee-sheet-form 
        v-show="activePage === 'Form'" 
        id="fee-sheets-right-fee-sheet-form" 
        ref="fee-sheet-form"
        leftPageTableRef="fee-sheets-table"
        :modal="false"
        uniqueId="fee-sheets-right" 
    />
</template>

<script>

export default {

    components: {
        FeeSheetForm: () => import("./FeeSheetForm"),

    },

    data() {
        return {
            activePage: null,
        }
    },


}

</script>
