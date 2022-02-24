<template>

    <!-- <section v-if="$root.documentsLeftTableLoaded"> -->

        <documents-form 
            v-show="activePage === 'Form'" 
            id="documents-right-documents-form" 
            ref="documents-right-documents-form"
            leftPageTableRef="documents-table"
            :modal="false"
        />

    <!-- </section> -->

</template>

<script>

export default {

    components: {
        DocumentsForm: () => import("./DocumentsForm"),
    },


    mounted() {
        root.documentsRightComponent = this;
    },    


    data() {
        return {
            activePage: null,
        }
    },


}

</script>
