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
                    title: "Party",
                    iconClass: 'fa-user',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "Matters",
                    title: "Matters",
                    resource: "Matters",
                    iconClass: 'fa-briefcase',
                    color: 'matters-bg',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "FileNotes",
                    title: "File Notes",
                    resource: "File Notes",
                    iconClass: 'fa-edit',
                    color: 'filenotes-bg',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "Reminders",
                    title: "Reminders",
                    resource: "Reminders",
                    iconClass: 'fa-tags',
                    color: 'reminders-bg',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "Documents",
                    title: "Correspondence",
                    resource: "Correspondence",
                    iconClass: 'fa-file-word-o',
                    color: 'doclog-bg',
                    visible: false,
                    active: false,
                },

            ]
        }
    },

}  
</script>