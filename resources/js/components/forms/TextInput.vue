<template>

    <div :class="_class + (setVisible ? '' : ' d-none')">

        <div v-if="label">

            <label v-html="setLabel"/>

            <span v-if="popOver">   
                <pop-over 
                    :content="setPopOver" 
                    :container="popOverContainer ? popOverContainer : $parent.modal ? '#' + $parent.id : 'body'" 
                    :placement="popOverPlacement"
                />
            </span>

            <i v-show="displayClearIcon" class="fa fa-times-circle cp text-danger ml-1 clear-icon" style="font-size: large" title="Clear" @click="clearIconClicked"></i>

        </div>

        <div :class="!readOnly && (inputGroup || inputGroupButtonFlag || lookupLibraryFlag || numberSpinnerFlag) ? 'input-group' : ''">

            <input 
            ref="input-control"
            :name="name" 
            :type="type" 
            :value="setValue || value" 
            @input="$emit('input', $event.target.value)" 
            @change="$emit('change', $event.target.value)"
            :class="'form-control ' + inputClass + ' ' + (error[0] ? 'is-invalid' : '')"
            :required="required" 
            :readonly="setReadOnly" 
            :min="min" 
            :tabIndex="readOnly ? '-1' : ''" 
            :title="setTitle" 
            :placeholder="placeHolder">

            <div v-if="!readOnly && inputGroup" class="input-group-append">
                <span class="input-group-text" v-html="inputGroup"></span>
            </div>

            <div v-if="!readOnly && inputGroupButtonFlag" class="input-group-append">
            <button
                tabindex="-1"
                @click="inputGroupButtonCallback"
                type="button"
                :title="inputGroupButtonTitle"
                class="btn btn-primary"
            ><i :class="'fa fa-lg ' + inputGroupButtonIcon"></i></button>
            </div>            

            <div v-if="!readOnly && lookupLibraryFlag" class="input-group-append">
            <button
                tabindex="-1"
                @click="selectLibraryEntry"
                type="button"
                title="Select wording from the Lookup library"
                :class="error[0] ? 'btn btn-danger multiselect-invalid-feedback' : 'btn btn-primary'"
            ><i class="fa fa-lg fa-edit"></i></button>
            </div>            

            <div v-if="!readOnly && numberSpinnerFlag" class="input-group-append">
                <spinner-button
                    :upCallback="numberSpinnerUpCallback"
                    :downCallback="numberSpinnerDownCallback"
                />
            </div>            


        </div>

        <div v-html="error[0]" class="invalid-feedback"></div>

    </div>

</template>

<script>

//See: https://bangjelkoski.com/blog/building-a-controlled-vue-input-component

export default {

    props: {
        clearIconCallback: { type: String, default: 'clearTextInput' },
        error: {
            type: Array,
            default: function () {
                return [null]
            },
        },
        name: String,
        type: {
            type: String,
            default: 'text',
        },
        value: {
            type: String,
            default: '',
        },
        min: {
            type: String,
            default: '0',
        },
        title: {
            type: String,
            default: '',
        },
        placeHolder: {
            type: String,
            default: '',
        },
        inputGroup: {
            type: String,
            default: '',
        },
        inputGroupButtonFlag: {
            type: Boolean,
            default: false,
        },
        inputGroupButtonTitle: {
            type: String,
            default: '',
        },
        inputGroupButtonIcon: {
            type: String,
            default: 'fa-cog',
        },
        inputGroupButtonCallback: {
            type: Function,
            default: null,
        },
        lookupLibraryCategory: {
            type: String,
            default: '',
        },
        lookupLibraryFlag: {
            type: Boolean,
            default: false,
        },
        vatInputCallback: {
            type: Object,
            default: null,
        },
        numberSpinnerFlag: {
            type: Boolean,
            default: false,
        },
        numberSpinnerUpCallback: {
            type: Function,
            default: null,
        },
        numberSpinnerDownCallback: {
            type: Function,
            default: null,
        },
        popOver: {
            type: String,
            default: '',
        },
        popOverContainer: {
            type: String,
            default: '',
        },
        popOverPlacement: {
            type: String,
            default: 'right'
        },
        label: {
            type: String,
            default: '',
        },
        _class: {
            type: String,
            default: 'col-md-6',
        },
        inputClass: {
            type: String,
            default: '',
        },
        readOnly: {
            type: Boolean,
            default: false,
        },
        required: {
            type: Boolean,
            default: false,
        },
        visible: {
            type: Boolean,
            default: true,
        },
    },

    data() {
        return {
            setValue: null,
            setLabel: null,
            setTitle: null,
            setReadOnly: null,
            setPopOver: null,
            setVisible: null,
            displayClearIcon: false,
        }
    },

    mounted () {

        this.setLabel = this.label;
        this.setTitle = this.title;
        this.setReadOnly = this.readOnly;
        this.setPopOver = this.popOver;
        this.setVisible = this.visible;
    },    

    methods: {

        clearIconClicked() {
            if ( typeof this.$parent[this.clearIconCallback] === 'function') this.$parent[this.clearIconCallback]();
        },

        selectLibraryEntry() {

            this.$root.selectLibrary.callingComponent = this;

            this.$root.selectLibrary.load(this.lookupLibraryCategory, $(this.$refs['input-control']).val());

        },

        librarySelected(data) {

            //$(this.$refs['input-control']).val(htmlDecode(data.description)); // Was not updating the v-model

            //https://stackoverflow.com/questions/46955230/vuejs-binding-not-working-if-update-by-jquery
            $(this.$refs['input-control']).val(htmlDecode(data.description))[0].dispatchEvent(new Event('input'));

            // In case we want to handle a Change event
            this.$emit('change',htmlDecode(data.description));
            

        },
    }

}  
</script>