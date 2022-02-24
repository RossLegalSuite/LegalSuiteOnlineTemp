<template>

<table v-if="$parent.table">
    <tr v-if="$parent.table.tableFilterDescription">
        <td>
            <table>
                <tr>
                    <td class="badge badge-danger" style="padding: 0.4em 0.5em;" title="View/Edit filter settings" @click="$root.tableFilterSettings.openModal($parent.table.tableId, $parent.table)">
                        Filtered
                    </td>
                    <td class="pl-2">
                        <span style="font-size: 0.8rem;" v-html="$parent.table.tableFilterDescription.trim()"></span>
                    </td>
                    <td>
                        <i class="fa fa-times-circle cp text-danger ml-1 clear-icon" style="font-size: large" title="Clear this filter" @click="clearFilters"></i>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

</template>

<script>

export default {

    methods: {

        clearFilters() {

            removeTableFilter(this.$parent.table.tableId);

            this.$parent.table.loadDataTable();

        },

    },

}  
</script>
