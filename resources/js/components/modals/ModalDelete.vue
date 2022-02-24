
<template>
<div class="modal" :id="id">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-color: indianred;">

            <div class="modal-header indianred">
                <h2 class="modal-title"><i class="fa fa-warning fa-lg mr-2"></i><span v-html="title"></span></h2>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>
    
            <div class="modal-body" style="overflow-y: unset;">
                <h3 id="modal-delete-text" style="line-height: 1.5;">Are you sure you want to 
                    <span v-text="deletePrefix"></span>
                    <br>
                    <span v-html="description"></span><span v-if="deleteSuffix" v-html="deleteSuffix"></span><span v-else>?</span></h3>
            </div>
    
            <div class="modal-footer ">
                <button class="btn btn-success form-button shadowed mr-2" type="button" @click="deleteClicked" :title="'Delete ' + description"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>
                <button class="btn btn-danger form-button shadowed" type="button" data-dismiss="modal" title="Abort deletion"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
    
            </div>

        </div>
    </div>
</div>

</template>

<script>
import { createLogger } from 'vuex';

import modalTemplate from "./modal-template";

export default {

    mixins: [modalTemplate],   

    props: {
        id: String,
    },    

    data() {
        return {
            deletePrefix: 'delete',
            description: 'this Record',
            deleteSuffix: '',
            title: 'Confirm Deletion',
        };
    },

    methods: {

        deleteClicked() {

            let path, params;

            this.hide();

            // console.log('deleteClicked',this.callingComponent,typeof this.callingComponent.deleteRecord);

            // console.log("this.callingComponent.record",this.callingComponent.record);

            //debugger;

            if ( this.callingComponent && typeof this.callingComponent.deleteRecord === 'function') {
                
                this.callingComponent.deleteRecord(this.callingComponent?.record?.recordid); // You can override default behaviour in the calling component

            } else {

                if ( this.callingComponent && this.callingComponent.table.route && this.callingComponent.record.recordid) {

                    axios.post('/' + this.callingComponent.table.tableName + '/delete/' + this.callingComponent.record.recordid)
                    
                    .then(response => {

                        if (response.data.error) {

                            showError( 'Error', 'An error was encountered trying to delete a record.<br><br>' + response.data.error);
                            this.callingComponent = null; // For safety

                        } else {

                            if ( this.callingComponent.table ) {

                                this.callingComponent.table.table.ajax.reload();

                            }

                            this.callingComponent.closeForm();

                            if ( typeof this.callingComponent.deleteCallback === 'function') this.callingComponent.deleteCallback();

                            this.callingComponent = null; // For safety

                        }

                    });

                } else {

                    this.$emit("delete-record"); // Must be in kebab case

                }

            }

        }

    }
}  
</script>