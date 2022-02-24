<template>

    <section v-if="$root.reminderLeftTableLoaded">

        <reminder-form 
            v-show="activePage === 'Form'" 
            id="reminders-right-reminder-form" 
            ref="reminder-form"
            leftPageTableRef="reminders-table"
            parentType="Matter"
            :modal="false"
        />

    </section>
</template>

<script>

export default {

    components: {
        ReminderForm: () => import("./ReminderForm"),

    },

    data() {
        return {
            activePage: null,
        }
    },


}

</script>
