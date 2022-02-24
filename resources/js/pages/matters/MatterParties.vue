<template>
<div>

    <matter-parties-table 
        :ref="uniqueId + '-matter-parties-table'" 
        :formRef="uniqueId + '-matter-parties-form'" 
        :tableId="uniqueId + '-matter-parties-table'"
        :parent-id="currentMatter.recordid"
        :lazy-load-flag="true"
    />

    <matter-parties-form 
        :ref="uniqueId + '-matter-parties-form'" 
        :id="uniqueId + '-edit-matter-parties'"
        :parentTableRef="uniqueId + '-matter-parties-table'"
    />

</div>
</template>  

<script>

import { mapGetters } from 'vuex';

export default {

    components: {
        MatterPartiesTable: () => import("@pages/matter-parties/MatterPartiesTable"),
        MatterPartiesForm: () => import("@pages/matter-parties/MatterPartiesForm"),
    },

    computed: {

        ...mapGetters(['currentMatter']),

    },
    props: {
        uniqueId: String
    },

    methods: {

        newRecordButtonClicked() {

            this.$refs[this.uniqueId + '-matter-parties-form'].parentMatter = this.currentMatter;
            this.$refs[this.uniqueId + '-matter-parties-form'].insertClicked();

        },

    },
}
</script> 