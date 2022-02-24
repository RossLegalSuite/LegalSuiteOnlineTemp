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
            ]
        }
    },

}  
</script>