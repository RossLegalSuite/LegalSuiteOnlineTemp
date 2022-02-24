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
                    title: "Reminder",
                    iconClass: 'fa-calendar-check-o',
                    visible: false,
                    active: false,
                },
            ]
        }
    },

}  
</script>