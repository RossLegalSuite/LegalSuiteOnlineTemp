<template>

    <div v-if="$root.fileNoteLeftTableLoaded">
        <file-note-form 
            v-show="activePage === 'Form'" 
            id="file-notes-right-file-note-form" 
            uniqueId="file-notes-right-file-note-form" 
            ref="file-note-form"
            leftPageTableRef="file-notes-table"
            :modal="false"
        />
    </div>

</template>

<script>

export default {

    components: {
        FileNoteForm: () => import("./FileNoteForm"),

    },

    data() {
        return {
            activePage: null,
        }
    },

}

</script>
