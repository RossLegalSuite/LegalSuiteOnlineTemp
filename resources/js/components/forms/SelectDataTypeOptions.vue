<template>

    <div :class="_class">

        <label v-if="label">{{label}}</label>

        <pop-over v-show="popOver" :content="popOver"/>

        <span v-if="clearIcon">
            <i class="fa fa-times-circle cp text-danger ml-1 clear-icon" style="font-size: large" title="Clear the existing filter" @click="clearIconClicked"></i>
        </span>

        <select class="form-control" 
        :id="id" 
        name="option" 
        model="option" 
        title="Select an option"/> 
    </div>
</template>

<script>
export default {

    props: {
        id: String,
        _class: {
            type: String,
            default: 'col-md-6',
        },
        popOver: {
            type: String,
            default:'',
        },
        label: {
            type: String,
            default: '',
        },
        parentRecord: {
            type: String,
            default:'record',
        },

    },

    data() {
        return {
            clearIconCallback: 'clearDropDownFilter',
            clearIcon: false,
            selectedOption: null,
            options: [],
        }  
    },

    methods: {

        clearIconClicked() {
            if ( typeof this.$parent[this.clearIconCallback] === 'function') this.$parent[this.clearIconCallback]();
        },


        loadComponent() {

            let _this = this;

            this.dropDown = $('#' + this.id);

            this.dropDown.empty();

            $.each(this.options, function(index, option) {

                // Can set filterOptions to: 
                // 1) an array of objects like [{value:'1', label: 'New Instruction'}] OR {value:'1', description: 'New Instruction'}
                // or 
                // 2) an array of strings like ['New Instruction', 'Amended Instruction']
                
                if ( typeof option === 'object') {
                    _this.dropDown.append('<option value="' + option.value + '">' + option?.label || option?.description + '</option>');
                } else {
                    _this.dropDown.append('<option value="' + option + '">' + option + '</option>');
                }

            });

            this.dropDown.selectpicker();

            this.dropDown.selectpicker('refresh');
            
            this.dropDown.selectpicker('val', this.selectedOption);

            this.dropDown.off('changed.bs.select').on('changed.bs.select', function () {

                _this.$parent[_this.parentRecord].value = $(this).val();

            });


        },

    },
};
</script>