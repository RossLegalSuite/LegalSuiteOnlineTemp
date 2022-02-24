<template>

    <div>

        <div class="modal" :id="id">

            <div class="modal-dialog modal-dialog-left modal-lg">

                <div class="modal-content" style="border-color:indianred">

                    <div class="modal-header indianred">
                        <h2 class="modal-title page-title"><i class="fa fa-edit mr-2"></i>Lookup Library</h2>
                        <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <div class="modal-body p-3" style="height: 60vh; overflow-y: auto;">
                        
                        <select-library-table
                            ref="select-library-table"
                            tableId="global-select-library-table"
                            formRef="globalSelectLibrary"
                            :lazyLoadFlag="true"
                        />

                    </div>

                    <div class="modal-footer justify-content-between">

                        <div>
                            <button v-show="existingText" class="btn btn-large btn-secondary" type="button" @click="addExistingText">
                                <span :title="'Add \'' + existingText + '\' to the Library'"><i class="fa fa-plus-circle fa-lg mr-2"></i> Add </span>
                            </button>
                        </div>

                        <div>
                            <button class="btn btn-danger form-button" type="button"  v-on:click="hide" title="Cancel selection"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
                        </div>
                    </div>

                </div>

            </div>

        </div>

        <select-library-form
            :id="id + '-form'"
            ref="select-library-form"
        />


    </div>


</template>

<script>

import modalTemplate from "@components/modals/modal-template";

export default {

    mixins: [modalTemplate],       

    components: {
        SelectLibraryForm: () => import("./SelectLibraryForm"),
    },

    props: {

    },

    data() {
        return {
            callingComponent: null,
            previousLookupLibraryCategory: null,
            lookupLibraryCategory: null,
            existingText: '',
        };
    },

    methods: {

        newRecordButtonClicked() {

            this.$refs['select-library-form'].existingText = this.existingText;
            this.$refs['select-library-form'].lookupLibraryCategory = this.lookupLibraryCategory;
            this.$refs['select-library-form'].table = this.$refs['select-library-table'];

            this.$refs['select-library-form'].insertClicked();

        },

        load( lookupLibraryCategory, existingText = '', summerNoteInstance = null ) {

            this.summerNoteInstance = summerNoteInstance;

            this.lookupLibraryCategory = lookupLibraryCategory;

            this.existingText = existingText;

            this.show();

            if ( !this.previousLookupLibraryCategory || this.previousLookupLibraryCategory != lookupLibraryCategory) {

                //this.table.whereRaw = ["tooltipcategory like '%" + lookupLibraryCategory.substring(0, 49) + "%'"];
                this.table.whereRaw = ["tooltipcategory = '" + lookupLibraryCategory + "'"];

                setTimeout( this.table.loadDataTable );

                this.previousLookupLibraryCategory = lookupLibraryCategory;
            }
        },


        selectRecord(id) {

            let data = this.table.table.row('#' + id).data();

            if ( !this.summerNoteInstance ) {

                this.callingComponent?.librarySelected(data);

            } else {

                this.summerNoteInstance.invoke('editor.insertText', data.description);

            }

            this.hide();

        },

        addExistingText() {

            axios.post('/library/store', {
                description: this.existingText,
                tooltipcategory: this.lookupLibraryCategory,
                shortdesc: this.existingText,
            })

            .then(response => {

                if (response.data.errors) { 

                    showError('Error', response.data.errors); 

                } else {

                    this.highlightRow(response.data.data[0].recordid, {
                        where: "description,<,'" + response.data.data[0].description + "'",
                        orderBy: 'description',
                    });

                    this.existingText = '';

                }

            }).catch(error => { showError('Error saving ' + this.table.singular, error); });

        },

    },

}  
</script>

