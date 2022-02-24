
<template>
    <div class="modal" :id="id" style="z-index: 2010" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-color: steelblue;">

            <div class="modal-header steelblue">
                
                <h3><i class="fa fa-spinner fa-pulse fa-lg mr-2"/><span v-html="title"/></h3>

            </div>

            <div class="modal-body" style="overflow:unset">

                    <h4 class="text-center">
                        <div class="mt-3">
                            <span v-html="description"/>
                        </div>
                        <div class="mt-3">
                            <span v-html="description1"/>
                        </div>
                    </h4>                
            </div>

            <div class="modal-footer ">
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
            title: '',
            description: '',
            description1: '',
            dialogCancelClicked: 'dialogCancelClicked'
        };
    },


    methods: {

        reset() {

            this.title = '';
            this.description = '';
            this.description1 = '';

            // Disable ESC button
            $(document).off('keyup');            


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