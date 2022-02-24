<template>
<span>
    <section v-if="$root.matterLeftTableLoaded">

        <matter-form 
            v-show="activePage === 'Form'" 
            ref="matter-right-matter-form"
            id="matter-right-matter-form"
            leftPageTableRef="matters-table"
            :modal="false"
            uniqueId="matter-right"
        />

        <common-fee-notes v-show="activePage === 'FeeNotes'" parentType="Matter" ref="matter-right-matter-fee-notes"/>

        <common-file-notes v-show="activePage === 'FileNotes'" parentType="Matter" ref="matter-right-matter-file-notes"/>

        <common-reminders v-show="activePage === 'Reminders'" parentType="Matter" ref="matter-right-matter-reminders"/>

        <common-documents v-show="activePage === 'Documents'" parentType="Matter" ref="matter-right-matter-documents"/>

    </section>

</span>

</template>

<script>

import { mapGetters } from 'vuex';

export default {

    components: {
        CommonFeeNotes: () => import("@pages/common/FeeNotes"),
        CommonFileNotes: () => import("@pages/common/FileNotes"),
        CommonReminders: () => import("@pages/common/Reminders"),
        CommonDocuments: () => import("@pages/common/Documents"),
    },

    data() {
        return {
            activePage: null,
        }
    },

    computed: {

        ...mapGetters(['currentMatter']),

    },

    watch: {
        
        activePage(newValue) {

            let thisTable = null;

            if ( newValue === "FeeNotes") {

                thisTable = this.$refs['matter-right-matter-fee-notes'].table;

                thisTable.where  = 'matter.recordid,=,' + this.currentMatter.recordid;
                thisTable.subTitle = this.currentMatter.fileref + ' - ' + this.currentMatter.description;

                setTimeout(thisTable.loadDataTable);

            } else if ( newValue === "FileNotes") {

                thisTable = this.$refs['matter-right-matter-file-notes'].table;

                thisTable.where  = 'matter.recordid,=,' + this.currentMatter.recordid;
                thisTable.subTitle = this.currentMatter.fileref + ' - ' + this.currentMatter.description;

                setTimeout(thisTable.loadDataTable);

            } else if ( newValue === "Reminders") {

                thisTable = this.$refs['matter-right-matter-reminders'].table;

                thisTable.where  = 'matter.recordid,=,' + this.currentMatter.recordid;
                thisTable.subTitle = this.currentMatter.fileref + ' - ' + this.currentMatter.description;

                setTimeout(thisTable.loadDataTable);

            } else if ( newValue === "Documents") {

                thisTable = this.$refs['matter-right-matter-documents'].table;

                thisTable.where  = 'matter.recordid,=,' + this.currentMatter.recordid;

                thisTable.subTitle = this.currentMatter.fileref + ' - ' + this.currentMatter.description;
                //thisTable.viewTableFlag = true;

                setTimeout(thisTable.loadDataTable);


            }
            
        }
    },

}

</script>