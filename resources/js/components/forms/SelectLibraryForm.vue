<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered' : ''">

        <div :class="modal ? 'modal-content indianred-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header indianred' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="!editing">Library Entry will be Added</span>
                            <span v-else>Library Entry will be Changed</span>
                        </h3>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="modal-body overflow-auto p-3">

                <div class="form-group row">

                    <text-input 
                        _class="col-md-12" 
                        v-model="record.description" 
                        name="description" 
                        label="Description"
                        :error="errors.description"
                    />

                </div>

            </div>

            <div class="modal-footer justify-content-between">
                    <div>
                    </div>
                    <div>
                        <button class="btn btn-success form-button mr-3" @click="okClicked" type="button" title="Save the Matter and close"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>
                        <button class="btn btn-danger form-button" type="button" data-dismiss="modal" title="Exit without saving"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
                    </div>
            </div>

        </div>
    </div>

</div>

</template>    

<script>

import FormTemplate from "@pages/form-template";
import modalTemplate from "@components/modals/modal-template";

export default {
    
    mixins: [FormTemplate, modalTemplate],

    props: {
        resource: {type: String, default: 'Library' },
    },

    data() {
        return {
            lookupLibraryCategory: null,
        };
    },    
    
    methods: {

        initNewRecord() {

            this.record = {
                description: null,
                tooltipcategory: this.lookupLibraryCategory,
                shortdesc: null,
            };

            this.initFormData();

        },

        initFormData() {
                
            this.displayForm();

            setTimeout(() => $('#' + this.id + ' input[name="description"]').focus() );

        },


        okClicked() {

            this.record.shortdesc = this.record.description;

            axios.post('/library/store', this.record)

            .then(response => {

                if (response.data.errors) {

                    showError('Error', response.data.errors); 

                } else {

                    this.errors = {};

                    console.log("response.data.data",response.data.data);

                    this.highlightRow(response.data.data[0].recordid, {
                        where: "description,<,'" + response.data.data[0].description + "'",
                        orderBy: 'description',
                    });


                    this.closeForm();

                }

            }).catch(error => { showError('Error saving ' + this.table.singular, error); });

        },

    },
}

</script>
