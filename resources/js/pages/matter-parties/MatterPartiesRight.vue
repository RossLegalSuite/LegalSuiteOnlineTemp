<template>

    <div v-if="$root.matterPartiesLeftTableLoaded">
        <matter-parties-form 
            v-show="activePage === 'Form'" 
            id="matter-parties-right-matter-party-form" 
            uniqueId="matter-parties-right-matter-party-form" 
            ref="matter-party-form"
            leftPageTableRef="matter-parties-table"
            :modal="false"
        />
    </div>

</template>

<script>

export default {

    components: {
        MatterPartiesForm: () => import("./MatterPartiesForm"),

    },

    data() {
        return {
            activePage: null,
        }
    },

}

</script>
