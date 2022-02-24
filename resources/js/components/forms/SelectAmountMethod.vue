<template>
    <div :class="_class">
        
        <label>{{label}}</label>

        <pop-over v-show="popOver" :content="popOver"/>

        <span v-if="clearIcon">
            <i class="fa fa-times-circle cp text-danger ml-1 clear-icon" style="font-size: large" title="Clear the existing filter" @click="clearIconClicked"></i>
        </span>

        <select 
            class="form-control" 
            :id="id" 
            title="Select the range of the amounts"
        /> 

    </div>
</template>

<script>
export default {

    props: {
        id: String,
        label: {
            type: String,
            default: 'Value',
        },
        _class: {
            type: String,
            default: 'col-md-6',
        },
        popOver: {
            type: String,
            default:'',
        },
        parentRecord: {
            type: String,
            default:'record',
        },

    },

    data() {
        return {
            clearIconCallback: 'clearFilter',
            clearIcon: false,
            selectedMethod: null,
            methods: ['Equal to','Not equal to','Less than','Greater than','Less than or equal to','Greater than or equal to','Between'],
        }  
    },

    methods: {

        clearIconClicked() {
            if ( typeof this.$parent[this.clearIconCallback] === 'function') this.$parent[this.clearIconCallback]();
        },

        loadComponent() {

            let _this = this;

            var $select = $('#' + this.id);

            $select.empty();

            $.each(this.methods, function(index, value) {
                $select.append('<option value="' + value + '">' + value + '</option>');
            });

            $select.selectpicker();

            $select.selectpicker('refresh');
            
            $select.selectpicker('val', this.selectedMethod);

            $select.off('changed.bs.select').on('changed.bs.select', function () {

                _this.$parent[_this.parentRecord].method = $(this).val();

            });

        },

    },
};
</script>