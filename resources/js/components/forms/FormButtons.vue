<template>

<div class="modal-footer justify-content-between">
    <div>

        <button v-show="editing && !viewing && !readOnly && !hideDeleteButton" :disabled="preventDelete" :id="$parent.id + '-delete-button'" class="btn form-button btn-primary mr-2" type="button" @click="$emit('delete-clicked')">
            <span :title="preventDelete ? 'You cannot delete this item' : deleteButtonTooltip"><i class="fa fa-trash fa-lg mr-2"></i><span v-text="deleteText"></span></span>
        </button>

        <button v-for="button in leftButtons" v-bind:key="button.text" @click="$parent[button.callback]()" class="btn form-button mr-2" :class="button.class" type="button">
            <span :title="button.title"><i class="fa fa-lg mr-2" :class="button.icon"></i>
                <span v-text="button.text"></span>
            </span>
        </button>

        <button v-for="button in customButtons" v-bind:key="button.text" @click="$parent[button.callback]()" class="btn form-button mr-2" :class="button.class" type="button">
            <span :title="button.title"><i class="fa fa-lg mr-2" :class="button.icon"></i>
                <span v-text="button.text"></span>
            </span>
        </button>

    </div>
    <div>
        <button v-show="!readOnly && !viewing" :id="$parent.id + '-ok-button'" class="btn btn-success form-button mr-2" @click="$emit('ok-clicked')" type="button" :title="saveButtonTooltip"><i class="fa fa-check-circle fa-lg mr-2"></i><span v-text="saveText"></span></button>
        <button :id="$parent.id + '-cancel-button'" class="btn btn-danger form-button" type="button" @click="$emit('cancel-clicked')" :title="closeFlag ||readOnly || viewing || $parent.modal ? 'Close this window' : 'Exit without saving'"><i class="fa fa-times-circle fa-lg mr-2"></i>{{$parent.modal ? 'Close' : (closeFlag ||readOnly || viewing? 'Close' : 'Cancel')}}</button>
    </div>
</div>

</template>

<script>
export default {
    props: {
        record: String,
        editing: Boolean,
        deleteText: {
            type: String,
            default: 'Delete',
        },
        saveText: {
            type: String,
            default: 'OK',
        },
        saveTitle: {
            type: String,
            default: '',
        },
        closeFlag: {
            type: Boolean,
            default: false,
        },
        viewing: {
            type: Boolean,
            default: false,
        },
        readOnly: {
            type: Boolean,
            default: false,
        },
        preventDelete: {
            type: Boolean,
            default: false,
        },
        hideDeleteButton: {
            type: Boolean,
            default: false,
        },
        leftButtons: {
            type: Array,
            default: function () {
                return []
            },
        },

    },

    data() {
        return {
            customButtons: [],
        }
    },

    computed: {

        deleteButtonTooltip() {
            return this.deleteText + " this " + this.record;
        },

        saveButtonTooltip() {

            if (this.saveText !== 'OK') {

                return this.saveTitle ? this.saveTitle : this.saveText + " the " + this.record;

            } else {

                return (this.editing ? "Save" : "Add") + " the " + this.record;

            }
        },
    },

}  
</script>