<template>

<table class="page-footer">
    <tr>
        <td v-if="$parent.tableFilterDescription">
            <table class="page-footer-table">
                <tr>
                    <td class="badge badge-danger" style="padding: 0.4em 0.5em;" title="View/Edit filter settings" @click="$root.tableFilterSettings.openModal($parent.tableId, $parent)">
                        Filtered
                    </td>
                    <td class="pl-2">
                        <span style="font-size: 0.8rem;" :title="$parent.tableFilterTitle" v-html="$parent.tableFilterDescription.trim()"></span>
                    </td>
                    <td>
                        <i class="fa fa-times-circle cp text-danger ml-1 clear-icon" style="font-size: large" title="Clear this filter" @click="clearFilters"></i>
                    </td>
                </tr>
            </table>
        </td>
        <td class="text-right" :id="$parent.tableId + '-footer-records'"/>
    </tr>
</table>

</template>

<script>

export default {

    methods: {

        clearFilters() {

            removeTableFilter(this.$parent.tableId);

            this.$parent.loadDataTable();

        },

    },

}  
</script>
