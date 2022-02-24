<template>
    <div  class="row h-100">
        <div class="col-lg-12 my-auto text-center">
            <h4>{{title}}</h4>
        </div>
    </div>
    
</template>

<script>

export default {

    props: {
        title:{
            type: String,
            default: 'Loading . . . Please wait'
        }
    },



}  
</script>
