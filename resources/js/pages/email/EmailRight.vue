<template>

        <email-form 
            v-show="activePage === 'Form'" 
            id="email-right-file-note-form" 
            ref="email-form"
            leftPageTableRef="email-table"
            :modal="false"
        />

</template>

<script>

export default {

    components: {
        EmailForm: () => import("@pages/email/EmailForm"),

    },

    data() {
        return {
            activePage: null,
        }
    },


}

</script>
