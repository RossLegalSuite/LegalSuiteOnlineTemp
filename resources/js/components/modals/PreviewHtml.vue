<template>

    <div class="modal" :id="id" style="z-index: 3000">
        <div class="modal-dialog modal-dialog-centered modal-xl">
            <div class="modal-content red-border">

                <div class="modal-header red-bg">
                    <div class="page-title">
                        <h3>
                            <i class='fa fa-book mr-2'></i>
                            <span v-html="title"></span>
                        </h3>
                        <i :id="id + '-modal-close-button'" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>
                </div>

                <div class="modal-body p-3" style="max-height: 75vh; min-height: 50vh; overflow-y: auto;" v-html="htmlBody"/>

                <div class="modal-footer justify-content-between">
                    <div>
                        <button class="btn btn-success form-button mr-3" type="button" @click="printDocument" title="Print the document"><i class="fa fa-print fa-lg mr-2"></i>Print</button>
                    </div>
                    <div>
                        <button class="btn btn-danger form-button" type="button" data-dismiss="modal" title="Close this window"><i class="fa fa-times-circle fa-lg mr-2"></i>Close</button>
                    </div>
                </div>

            </div>
        </div>
    </div>

</template>

<script>

import modalTemplate from "./modal-template";

export default {

    mixins: [modalTemplate],

    data() {
        return {
            title: null,
            callingComponent: null,
            htmlBody: '',
        }
    },

    mounted() {

        this.$parent.previewHtml = this;

    },


    methods: {

        load( callingComponent) {

            this.callingComponent = callingComponent;

            this.show();

        },

        printDocument() {

            if (this.callingComponent.recordsFiltered > 10000 ) {

                root.dialogModal.callingComponent = this;
                root.dialogModal.okCallback = 'sendToPrinter';
                root.dialogModal.title = 'Warning';
                root.dialogModal.description = '<p>This report contains ' + this.callingComponent.recordsFiltered + ' rows.<p>';
                root.dialogModal.description += '<p>It may take a while to print.<p>';
                root.dialogModal.description += '<p>Press <strong>OK</strong> to continue or <strong>Cancel</strong> to abort.<p>';
                root.dialogModal.show();

            } else {

                this.sendToPrinter();

            }

        },   

        sendToPrinter() {

            printHtml(this.htmlBody);

        },

    }

}
</script>

