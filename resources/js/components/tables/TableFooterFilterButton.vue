<template>

<span v-if="$parent.tableFilterDescription">
    <span class="btn btn-danger btn-sm" title="View/Edit filter settings" @click="$root.tableFilterSettings.openModal($parent.tableId, $parent)">
        Filtered
    </span>
    <span class="ml-2" style="font-size: 0.8rem;" v-html="$parent.tableFilterDescription.trim()"></span>
</span>


</template>

