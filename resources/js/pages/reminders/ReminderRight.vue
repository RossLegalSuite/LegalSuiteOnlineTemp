<template>

    <div v-if="$root.reminderLeftTableLoaded">
        <reminder-form 
            v-show="activePage === 'Form'" 
            id="reminders-right-reminder-form" 
            uniqueId="reminders-right-reminder-form" 
            ref="reminder-form"
            leftPageTableRef="reminders-table"
            :modal="false"
        />
    </div>

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
