<template>

<div style="background: steelblue; color: white; padding: 1px 10px; height:100%; border-top-right-radius: 0.25rem; border-bottom-right-radius: 0.25rem;">
    <div @click="upPressed"><i class="fa fa-sort-asc fa-lg cp" title="Increase amount" style="margin-top:3px"></i></div>
    <div @click="downPressed"><i class="fa fa-sort-desc fa-lg cp" title="Decrease amount" style="margin-top:-5px"></i></div>
</div>

</template>

<script>

export default {

    props: {

        downCallback: {
            type: Function,
            default: null,
        },

        upCallback: {
            type: Function,
            default: null,
        },


    },

    methods: {

        downPressed() {
            this.downCallback();
        },

        upPressed() {
            this.upCallback();
        },

    },


}  
</script>