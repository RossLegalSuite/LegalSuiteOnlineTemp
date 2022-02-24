<template>
<span>
    <section v-if="$root.partyLeftTableLoaded">

        <party-form 
            v-show="activePage === 'Form'" 
            ref="party-right-party-form"
            id="party-right-party-form"
            leftPageTableRef="parties-table"
            :modal="false"
            uniqueId="party-right"
        />

        <party-matters v-show="activePage === 'Matters'" ref="party-right-party-matters"/>

        <common-file-notes v-show="activePage === 'FileNotes'" parentType="Party" ref="party-right-party-file-notes"/>

        <common-reminders v-show="activePage === 'Reminders'" parentType="Party" ref="party-right-party-reminders"/>

        <common-documents v-show="activePage === 'Documents'" parentType="Party" ref="party-right-party-documents"/>


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
        PartyMatters: () => import("./PartyMatters"),
    },

    data() {
        return {
            activePage: null,
        }
    },

    computed: {
        ...mapGetters(['currentParty']),
    },

    watch: {
        
        activePage(newValue) {

            let thisTable = null;

            if ( newValue === "Matters") {

                thisTable = this.$refs['party-right-party-matters'].table;

                //Order by Role and Sorter (hidden columns in table)
                thisTable.initialOrder = [[10, "asc"],[11, "asc"]];

                thisTable.where = 'matparty.partyid,' + this.currentParty.recordid ;
                thisTable.subTitle = this.currentParty.code + ' - ' + this.currentParty.name;

                setTimeout(thisTable.loadDataTable);

            } else if ( newValue === "FileNotes") {

                thisTable = this.$refs['party-right-party-file-notes'].table;

                thisTable.where  = 'party.recordid,=,' + this.currentParty.recordid;

                thisTable.subTitle = this.currentParty.code + ' - ' + this.currentParty.name;

                setTimeout(thisTable.loadDataTable);

            } else if ( newValue === "Reminders") {

                thisTable = this.$refs['party-right-party-reminders'].table;

                thisTable.where  = 'party.recordid,=,' + this.currentParty.recordid;
                thisTable.subTitle = this.currentParty.code + ' - ' + this.currentParty.name;

                setTimeout(thisTable.loadDataTable);

            } else if ( newValue === "Documents") {

                thisTable = this.$refs['party-right-party-documents'].table;

                thisTable.where  = 'party.recordid,=,' + this.currentParty.recordid;
                thisTable.subTitle = this.currentParty.code + ' - ' + this.currentParty.name;
                thisTable.viewTableFlag = true;

                setTimeout(thisTable.loadDataTable);

            }
            
        }
    },



}

</script>