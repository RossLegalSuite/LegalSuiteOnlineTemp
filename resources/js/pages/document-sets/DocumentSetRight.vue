<template>
    <document-set-form v-show="activePage === 'Form'" 
        id="document-sets-right-document-form" 
        ref="document-set-form"
        leftPageTableRef="document-sets-table"
        :modal="false"
    />
</template>

<script>

export default {

    components: {
        DocumentSetForm: () => import("./DocumentSetForm"),

    },

    data() {
        return {
            activePage: null,
        }
    },


}

</script>
