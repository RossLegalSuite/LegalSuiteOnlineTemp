<template>

    <right-hand-tabs ref="right-hand-tabs" :tabs="tabs"/>

</template>

<script>

export default {

    mounted() {
        root.documentsRightHandTabs = this;
    },

    data() {
        return {
            tabs: [
                {
                    pageName: "Form",
                    title: "Document",
                    iconClass: 'fa-file-pdf-o',
                    visible: false,
                    active: false,
                },
            ]
        }
    },

}  
</script>