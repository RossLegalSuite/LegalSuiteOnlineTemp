<template>
    <span>
        <span v-if="type ==='icon'" :class="'cp mr-1 ' + (hidden ? 'd-none' : 'd-inline-block')" :title="title" @click="newRecordButtonClicked"><i :class="'fa ' + icon + ' fa-2x ' + colorClass"></i></span>
        <button v-else :class="'btn btn-sm ' + _class + ' ' + (hidden ? 'd-none' : 'd-inline-block')" :title="title" @click="newRecordButtonClicked" v-html="buttonText"></button>
    </span>
</template>

<script>

export default {

    props: {
        callback:{
            type: String,
            default: ''
        },
        title:{
            type: String,
            default: 'Create a new Record'
        },
        type:{
            type: String,
            default: 'icon'
        },
        text:{
            type: String,
            default: 'New Record'
        },
        icon:{
            type: String,
            default: 'fa-plus-square'
        },
        colorClass:{
            type: String,
            default: ''
        },
        _class:{
            type: String,
            default: 'btn-success'
        }
    },
    data() {
        return {
            hidden: false,
        }
    },

    computed: {

        buttonText: function () {
            return '<i class="fa ' + this.icon + ' mr-2"></i>' + this.text;
        }

    },

    methods: {

        newRecordButtonClicked() {

            if ( this.callback ) {

                this.$emit(this.callback);

            } else if ( typeof this.$parent.$parent.newRecordButtonClicked === 'function' ) {

                this.$parent.$parent.newRecordButtonClicked();

            } else {

                this.$emit('newRecordButtonClicked');

            }

        }
    },

}  
</script>