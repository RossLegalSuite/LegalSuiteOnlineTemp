<template>
    <span class="cp" @click="$emit('closeClicked')" title="Close this page"><i class="fa fa-times-circle fa-2x" :class="colorClass"></i></span>
</template>

<script>

export default {

    props: {
        colorClass:{
            type: String,
            default: ''
        }
    },



}  
</script>