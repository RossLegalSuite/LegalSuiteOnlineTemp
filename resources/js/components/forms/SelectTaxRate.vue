<template>
    <div :class="_class">
        <label>{{$root.control.salesTaxType}} Rate</label>

        <pop-over v-show="popOver" :content="popOver"/>

        <select class="form-control" 
        :id="id" 
        name="taxRateId" 
        model="taxRateId" 
        title="The applicable Tax Rate"/> 
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

    },

    data() {
        return {
            selectedId: null,
        }  
    },

    methods: {

        refreshComponent(id) {

            var $select = $('#' + this.id);

            $select.selectpicker('refresh');

            $select.selectpicker('val',  id);            

        },
        loadComponent() {

            axios.post("/taxrates/get")
            
            .then(response => {

                let _this = this;

                var $select = $('#' + this.id);

                $select.empty();

                $.each(response.data, function(index, value) {
                    $select.append('<option value="' + value.id + '">' + value.description + '</option>');
                });

                $select.selectpicker();

                $select.selectpicker('refresh');

                $select.selectpicker('val',  this.selectedId);

                $select.off('changed.bs.select').on('changed.bs.select', function () {

                    _this.$parent.record.taxRateId =  $(this).val();

                    //console.log('Changed dropdown _this.$parent.record.taxRateId',_this.$parent.record.taxRateId);

                });


            });

        },

    },
};
</script>