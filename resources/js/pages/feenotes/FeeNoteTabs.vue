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
                    title: "Fee Note",
                    iconClass: 'fa-money',
                    visible: false,
                    active: false,
                },
            ]
        }
    },

}  
</script>