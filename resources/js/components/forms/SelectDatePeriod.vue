<template>
    <div :class="_class">
        <label v-html="label"/>

        <pop-over v-show="popOver" :content="popOver"/>

        <span v-if="clearIcon">
            <i class="fa fa-times-circle cp text-danger ml-1 clear-icon" style="font-size: large" title="Clear the existing filter" @click="clearIconClicked"></i>
        </span>

        <select class="form-control" 
        :data-container="'#' + $parent.id"
        :id="id" 
        title="Select the date range"/> 
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
            default:'Period',
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
            selectedPeriod: null,
            periods: ['Today', 'Yesterday', 'This Week', 'Last Week', 'This Month', 'Last Month', 'This Quarter', 'Last Quarter', 'This Year', 'Last Year', 'Custom' ],
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

            $.each(this.periods, function(index, value) {
                $select.append('<option value="' + value + '">' + value + '</option>');
            });

            $select.selectpicker();

            $select.selectpicker('refresh');
            
            $select.selectpicker('val',  this.selectedPeriod);

            $select.off('changed.bs.select').on('changed.bs.select', function () {

                _this.$parent[_this.parentRecord].period = $(this).val();

            });


        },

    },
};
</script>