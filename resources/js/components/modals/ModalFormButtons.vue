<template>
<div class="d-flex justify-content-between">
    <div>
        <button v-show="editing" class="btn btn-large btn-primary" type="button" @click="deleteClicked">
            <span :title="deleteTitle"><i class="fa fa-trash fa-lg mr-2"></i><span v-text="deleteText"></span></span>
        </button>
    </div>
    <div>
        <button class="btn btn-success form-button shadowed mr-2" :id="submitButtonId" @click="okClicked" type="button" :title="saveTitle"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>
        <button class="btn btn-danger form-button shadowed" type="button" @click="cancelClicked" title="Exit without saving"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
    </div>
</div>
</template>

<script>

export default {

    props: {
        title: String,
        editing: Boolean,
        submitButtonId: {
            type: String,
            default: 'form-submit-button',
        },
        deleteText: {
            type: String,
            default: 'Delete',
        }
    },
    computed: {

        deleteTitle: function() {
            return this.deleteText + " this " + this.title;
        },
        saveTitle: function() {
            return "Save " + this.title + " details";
        },
    },

    methods: {

        deleteClicked: function () {
            this.$emit("deleteClicked");
        },
        cancelClicked: function () {
            this.$emit("cancelClicked");
        },
        okClicked: function () {
            this.$emit("okClicked");
        },
        
    },


}  
</script>