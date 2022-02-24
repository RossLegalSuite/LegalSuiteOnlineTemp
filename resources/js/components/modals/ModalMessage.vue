
<template>
    <div class="modal" :id="id" style="z-index: 2000">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-color: steelblue;">

        <div class="modal-header steelblue">
            <h2 class="modal-title" :id="titleId">{{title}}</h2>
            <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
        </div>

        <div class="modal-body">
            <h3 v-html="body" style="line-height: 1.5;" :id="bodyId"></h3>
        </div>

        <div class="modal-footer">
            <button class="btn btn-danger shadowed" type="button" data-dismiss="modal" title="Close"><i class="fa fa-times-circle fa-lg mr-2"></i>Close</button>
        </div>

        </div>
    </div>
    </div>
</template>

<script>
export default {
    props: {
        id: String,
        title: String,
        body: String,
    },
    computed: {
        titleId: function() {
            return this.id + '-title';
        },
        bodyId: function() {
            return this.id + '-body';
        },
    },
}  
</script>