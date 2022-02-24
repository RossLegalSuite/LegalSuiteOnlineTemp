<template>

    <right-hand-tabs ref="right-hand-tabs" :tabs="tabs"/>

</template>

<script>

export default {

    data() {

        return {
            tabs: [
                {
                    pageName: "Company",
                    title: "Settings",
                    iconClass: 'fa-cog',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "Templates",
                    title: "Templates",
                    iconClass: 'fa-clone',
                    visible: false,
                    active: false,
                },
                {
                    pageName: "Components",
                    title: "Components",
                    iconClass: 'fa-book',
                    visible: false,
                    active: false,
                },

            ],
        }
    },

}  
</script>