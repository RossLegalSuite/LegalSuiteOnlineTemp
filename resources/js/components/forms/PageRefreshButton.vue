<template>

    <span class="cp mr-2" @click="clicked" title="Refresh the data on this page">
        <i class="fa fa-refresh" style="font-size: 1.8em;" :class="colorClass"></i>
    </span>

</template>

<script>

export default {

    props: {
        colorClass:{
            type: String,
            default: ''
        }
    },

    methods: {

        clicked: function () {
            this.$emit("refreshPage");
        },
        
    },


}  
</script>