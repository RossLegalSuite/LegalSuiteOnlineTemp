<template>

<button type="button" class="btn btn-danger btn-sm mr-2" 
    title="Filter the Email Addresses" 
    @click="loadFilterForm"
>
<i class="fa fa-filter mr-2"></i>Filter

</button>

</template>
<script>

export default {

    methods: {
        loadFilterForm() {
            this.$root.emailFilterForm.table = this.$parent;
            this.$root.emailFilterForm.show();

        }
    },
}

</script>

