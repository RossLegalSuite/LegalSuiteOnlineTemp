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
                    title: "Fee Code",
                    iconClass: 'fa-server',
                    visible: false,
                    active: false,
                },
            ]
        }
    },

}  
</script>