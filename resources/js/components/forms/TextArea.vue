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

            <i v-show="lookupLibraryFlag && !readOnly" class="fa fa-edit cp text-success ml-1 clear-icon" style="font-size: large" title="Select from the Lookup library" @click="selectLibraryEntry"></i>

            <i v-show="displayClearIcon" class="fa fa-times-circle cp text-danger ml-1 clear-icon" style="font-size: large" title="Clear" @click="clearIconClicked"></i>

        </div>

        <textarea 
            ref="input-control"
            :rows="rows" 
            :cols="cols" 
            :name="name" 
            :value="value || setValue" 
            :title="setTitle" 
            :placeholder="placeHolder"
            :class="'form-control ' + inputClass + ' ' + (error[0] ? 'is-invalid' : '')"
            :required="required" 
            :readonly="setReadOnly" 
            :tabIndex="setReadOnly ? '-1' : ''" 
            @input="$emit('input', $event.target.value)" 
            @change="$emit('change', $event.target.value)"
        />         

        <div v-show="error[0]" v-html="error[0]" class="invalid-feedback"></div>
    </div>                                        

</template>

<script>

//See: https://bangjelkoski.com/blog/building-a-controlled-vue-input-component

export default {

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

    props: {
        error: {
            type: Array,
            default: function () {
                return [null]
            },
        },

        name: String,

        rows: {
            type: String,
            default:'4',
        },
        cols: {
            type: String,
            default:'50',
        },
        value: {
            type: String,
            default:'',
        },
        title: {
            type: String,
            default:'',
        },
        placeHolder: {
            type: String,
            default:'',
        },
        popOver: {
            type: String,
            default:'',
        },
        label: {
            type: String,
            default: 'Label Not Specified',
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
        lookupLibraryCategory: {
            type: String,
            default: '',
        },
        lookupLibraryFlag: {
            type: Boolean,
            default: false,
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
        clearIconCallback: {
            type: String,
            default: ''
        },

    },

    methods: {

        clearIconClicked() {

            if ( typeof this.$parent[this.clearIconCallback] === 'function') {
                this.$parent[this.clearIconCallback]();
            }
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

    },


}  
</script>