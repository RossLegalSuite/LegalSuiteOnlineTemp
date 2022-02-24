<template>

    <right-hand-tabs ref="right-hand-tabs" :tabs="tabs"/>

</template>

<script>

export default {

    data() {
        return {
            tabs: [
                {
                    pageName: "Form",
                    title: "Employee",
                    iconClass: 'fa-id-badge',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "Matters",
                    title: "Matters",
                    resource: "Matters",
                    iconClass: 'fa-briefcase',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "FeeNotes",
                    title: "Fee Notes",
                    resource: "Fee Notes",
                    iconClass: 'fa-money',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "FileNotes",
                    title: "File Notes",
                    resource: "File Notes",
                    iconClass: 'fa-edit',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "Reminders",
                    title: "Reminders",
                    resource: "Reminders",
                    iconClass: 'fa-tags',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "Documents",
                    title: "Correspondence",
                    resource: "Correspondence",
                    iconClass: 'fa-file-word-o',
                    visible: false,
                    active: false,
                },

            ]
        }
    },

}  
</script>