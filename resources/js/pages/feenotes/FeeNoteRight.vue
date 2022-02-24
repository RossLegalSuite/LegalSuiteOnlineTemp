<template>

    <div v-if="$root.feeNoteLeftTableLoaded">
        <fee-note-form 
            v-show="activePage === 'Form'" 
            id="fee-notes-right-fee-note-form" 
            uniqueId="fee-notes-right-fee-note-form" 
            ref="fee-note-form"
            leftPageTableRef="fee-notes-table"
            :modal="false"
        />
    </div>

</template>

<script>

export default {

    components: {
        FeeNoteForm: () => import("./FeeNoteForm"),

    },

    data() {
        return {
            activePage: null,
        }
    },

}

</script>
