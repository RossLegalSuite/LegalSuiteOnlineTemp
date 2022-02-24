<template>
    <div :class="_class" :style="_style">

        <div v-if="formControl">
            <label class="control-label">{{label}}</label>
            <pop-over v-show="popOver" :content="popOver" :container="popOverContainer ? popOverContainer : $parent.modal ? '#' + $parent.id : 'body'"/>

            <span v-if="clearIcon">
                <i class="fa fa-times-circle cp text-danger ml-1 clear-icon" style="font-size: large" title="Clear the existing filter" @click="clearIconClicked"></i>
            </span>

        </div>

        <div :class="formControl ? 'form-control form-radio-button ' + (boxedFlag ? 'boxed' : '')  : ''">

            <!-- 
            Need the form so the radio buttons do not clash with other radio buttons
            Need the style to override the user-agent styles for a form
            -->
            <form action="" style="margin-block-end: 0 !important;">
                <div v-for="button in buttonArray" v-bind:key="button.value" class="form-check-inline">
                    <label class="form-check-label" :title="button.title">
                        <input tabindex="-1" type="radio" @change="$emit('change', $event.target.value)" class="form-check-input" :disabled="readOnly" :value="button.value" v-model="record[column]" :name="name + button.value">{{button.text}}
                    </label>
                </div>
            </form>

        </div>

        <div v-show="error[0]" v-html="error[0]" class="invalid-feedback"></div>

    </div>                                        

</template>

<script>

//See: https://bangjelkoski.com/blog/building-a-controlled-vue-input-component

export default {
    props: {
        error: {
            type: Array,
            default: function () {
                return [null]
            },
        },
        name: String,
        buttons: Array,
        record: Object,
        column: String,
        boxedFlag: {
            type: Boolean,
            default: false,
        },        
        readOnly: {
            type: Boolean,
            default: false,
        },        
        value: {
            type: String,
            default:'',
        },
        title: {
            type: String,
            default:'',
        },
        formControl: {
            type: Boolean,
            default: true,
        },
        readOnly: {
            type: Boolean,
            default: false,
        },
        popOver: {
            type: String,
            default:'',
        },
        popOverContainer: {
            type: String,
            default:'',
        },
        label: {
            type: String,
            default: '',
        },
        _class: {
            type: String,
            default: 'col-md-12',
        },
        _style: {
            type: String,
            default: '',
        },

    },

    data() {
        return {
            clearIconCallback: 'clearRadioButton',
            clearIcon: false,

            buttonArray: [],
        }
    },    

    created() {
        this.buttonArray = this.buttons;
    },

    methods: {

        clearIconClicked() {
            if ( typeof this.$parent[this.clearIconCallback] === 'function') this.$parent[this.clearIconCallback]();
        },
    },    
}  
</script>