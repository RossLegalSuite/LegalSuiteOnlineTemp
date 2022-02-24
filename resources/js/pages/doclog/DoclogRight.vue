<template>

    <div v-if="$root.doclogLeftTableLoaded">
        <doclog-form 
            v-show="activePage === 'Form'" 
            id="doclog-right-doclog-form" 
            ref="doclog-form"
            leftPageTableRef="doclog-table"
            parentType="General"
            :modal="false"
        />
    </div>

</template>

<script>

export default {

    components: {
        DoclogForm: () => import("./DoclogForm"),

    },

    data() {
        return {
            activePage: null,
        }
    },


}

</script>
