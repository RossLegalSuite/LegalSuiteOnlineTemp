<template>
<div>
    <div class="modal" :id="id" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-color: forestgreen;">

                <div class="modal-header forestgreen">
                    <h2 class="modal-title">
                        <!-- <img class="mr-3" src="/img/LogoMenuSmall.gif" alt="logo" style="width:20%;"> -->
                        <img class="mr-2" src="/img/favicon.ico" alt="logo">
                        LegalSuite Online
                    </h2>
                </div>

                <div class="modal-body p-3" style="overflow:unset">

                    <h4 class="text-center">
                        <div>
                            
                            <!-- <img class="mr-3" src="/img/cogs.gif" alt="cogs" style="width:20%;"> -->
                            <span>Connecting you to the LegalSuite program</span>
                        </div>
                        <div class="mt-3">
                            <i class="fa fa-spinner fa-pulse fa-lg mr-2"></i>
                            <span>Please wait....</span>
                        </div>
                    </h4>
                    <!-- <h3 style="line-height: 1.5;">
                        Initializing the program. . . Please wait.
                    </h3> -->
                </div>

            </div>
        </div>
    </div>

</div>
</template>

<script>

import modalTemplate from "../modals/modal-template";

export default {

    mixins: [modalTemplate],

    props: {
        id: String,
    },


}  
</script>