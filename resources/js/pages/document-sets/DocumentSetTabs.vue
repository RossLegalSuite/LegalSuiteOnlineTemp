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
                    title: "Document Set",
                    iconClass: 'fa-clone',
                    visible: false,
                    active: false,
                },
            ]
        }
    },

}  
</script>