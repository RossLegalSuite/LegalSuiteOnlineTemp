<template>
    <extra-screen-form 
        v-show="activePage === 'Form'" 
        ref="extra-screen-form"
        id="extra-screen-right-extra-screen-form"
        leftPageTableRef="extra-screens-table"
        :modal="false"
        uniqueId="extra-screen-right"
    />
</template>

<script>

export default {

    components: {
        ExtraScreenForm: () => import("./ExtraScreenForm"),

    },

    data() {
        return {
            activePage: null,
        }
    },


}

</script>
