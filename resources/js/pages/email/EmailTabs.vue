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
                    title: "Message",
                    iconClass: 'fa-envelope-o',
                    visible: false,
                    active: false,
                },
            ]
        }
    },

}  
</script>