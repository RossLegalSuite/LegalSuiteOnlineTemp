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
                    title: "Matter",
                    iconClass: 'fa-briefcase',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "FeeNotes",
                    title: "Fee Notes",
                    resource: "Fee Notes",
                    iconClass: 'fa-money',
                    color: 'feenotes-bg',
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
                    title: "Document Log",
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