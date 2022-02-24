<template>

<!-- 
Using v-once here 
Rendering plain HTML elements is very fast in Vue, but sometimes you might have a component that contains a lot of static content. In these cases, you can ensure that it’s only evaluated once and then cached by adding the v-once 
See: vuejs.org/v2/guide/components-edge-cases.html#Cheap-Static-Components-with-v-once
-->


<button v-once type="button" class="btn btn-danger btn-sm mr-2" 
    title="Filter the records in the table" 
    @click="$root.tableFilterSettings.openModal($parent.tableId, $parent)"
>
<i class="fa fa-filter mr-2"></i>Filter

</button>

</template>

