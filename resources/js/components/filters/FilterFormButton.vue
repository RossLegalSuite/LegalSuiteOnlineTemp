<template>

<button type="button" class="btn btn-danger btn-sm mr-2" 
    title="Filter the records in the Table" 
    @click="loadFilterForm"
>
<i class="fa fa-filter mr-2"></i>Filter

</button>

</template>
<script>

export default {

    methods: {
        loadFilterForm() {

            this.$parent.filterForm.table = this.$parent;
            this.$parent.filterForm.show();

        }
    },
}

</script>
