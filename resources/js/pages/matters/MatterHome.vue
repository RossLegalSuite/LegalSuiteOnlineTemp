<template>
<span>
   

    <div class="filofax-page p-2">

        <div class="d-flex">

            <div class="program-icon" @click="newMatter()">
                <img src="/icons/add-green.gif">
                <div class="program-icon-text">New Matter</div>
            </div>

            <div class="program-icon">
                <img src="/icons/printer.gif">
                <div class="program-icon-text">Print</div>
            </div>

            <div class="program-icon">
                <img src="/icons/chart-graph.gif">
                <div class="program-icon-text">Export</div>
            </div>

            <div class="program-icon">
                <img src="/icons/blueprint.gif">
                <div class="program-icon-text">Layout</div>
            </div>

        </div>


        <div class="d-flex">
            <div class="program-icon" @click="loadPage('FileNotes')">
                <img src="/icons/notepad.gif">
                <div class="program-icon-text">File Notes</div>
            </div>
            <div class="program-icon" @click="loadPage('FeeNotes')">
                <img src="/icons/finance.gif">
                <div class="program-icon-text">Fee Notes</div>
            </div>
            <div class="program-icon">
                <img src="/icons/post-note.gif">
                <div class="program-icon-text">Reminders</div>
            </div>
            <div class="program-icon">
                <img src="/icons/document.gif">
                <div class="program-icon-text">Documents</div>
            </div>
        </div>



    </div>




</span>

</template>

<script>


export default {


    methods: {


        loadPage( pageName) {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].loadPage( pageName );

        },



    }

}

</script>