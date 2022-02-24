
<template>
    <div class="modal" :id="id" style="z-index: 2050">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-color: steelblue;">

            <div class="modal-header steelblue">
                <h3 class="modal-title" v-html="title"/>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="modal-body">
                <h4 v-html="description"/>
            </div>

            <div class="modal-footer ">
                <button class="btn btn-success form-button mr-2" type="button" @click="okClicked" title="Continue"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>
                <button class="btn btn-danger form-button" type="button" @click="cancelClicked" title="Abort"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>

            </div>

            </div>
        </div>
    </div>
</template>

<script>

import modalTemplate from "./modal-template";

export default {

    mixins: [modalTemplate],   

    props: {
        id: String,
    },

    data() {
        return {
            title: 'Heading',
            description: 'Description',
            okCallback: 'dialogOkClicked',
            dialogCancelClicked: 'dialogCancelClicked'
        };
    },


    methods: {

        okClicked() {

            this.hide();

            if ( typeof this.callingComponent[this.okCallback] === 'function') {

                this.callingComponent[this.okCallback](); 

            }

        },

        cancelClicked() {

            this.hide();

            if ( typeof this.callingComponent[this.cancelCallback] === 'function') {

                this.callingComponent[this.cancelCallback](); 

            }

        },


    }   
}  
</script>