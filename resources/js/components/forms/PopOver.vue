<template>
  <span 
  class="fa fa-question-circle popover-icon" 
  data-toggle="popover" 
  :data-placement="placement" 
  data-html="true"
  data-trigger="hover"
  :data-container="container ? container : $parent.modal ? '#' + $parent.id : 'body'" 
  :data-content="content">
  </span>
</template>

<script>
export default {
  props: {
    content: String,
    container: {
      type: String,
      default: ''
    },
    placement: {
      type: String,
      default: 'right'
    }

  },
};
</script>