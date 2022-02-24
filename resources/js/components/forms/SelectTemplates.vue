<template>

    <div class="modal" :id="id">

        <div class="modal-dialog modal-dialog-centered modal-lg">

            <div class="modal-content" style="border-color:indianred">

                <div class="modal-header indianred">
                    <h2 class="modal-title page-title"><i class="fa fa-file-code-o mr-2"></i>
                    <span v-html="pageTitle()"></span>
                    </h2>
                    <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                </div>

                <div class="modal-body p-3" style="height: 60vh;  overflow-y: auto;">
                    
                    <select-template-table
                        ref="select-templates-table"
                        tableId="global-select-templates-table"
                        :newRecordButton="false"
                        formRef="globalSelectTemplates"
                        :lazyLoadFlag="true"
                        :tagging="true"
                    />

                </div>

                <div class="modal-footer justify-content-between">
                    <div/>
                    <div>

                        <button v-show="selectedRows.length" class="btn btn-success form-button mr-2" type="button" @click="selectClicked" :title="'Select ' + selectedRows.length + ' tagged Template' + (selectedRows.length > 1 ? 's' : '')"><i class="fa fa-check-circle fa-lg mr-2"></i>
                            Select
                            <span class="badge badge-danger ml-2">{{selectedRows.length}}</span>
                        </button>

                        <button class="btn btn-danger form-button" type="button"  v-on:click="hide" title="Cancel selection"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>

                    </div>
                </div>

            </div>

        </div>

    </div>


</template>

<script>

import modalTemplate from "@components/modals/modal-template";

export default {

    mixins: [modalTemplate],       

    data() {
        return {
            callingComponent: null,
            type: null,
            source: null,
            selectedRows: [],
        };
    },

    methods: {

        load( callingComponent, type, source ) {

            this.callingComponent = callingComponent;


            clearTagged( this );

            this.open();

            this.table.selectTableFlag = true;
            this.table.actionColumnWidth = 12;

            this.table.whereRaw = "type = '" + type + "' AND source = '" + source + "'";

            this.type = type;
            this.source = source;

            setTimeout( this.table.loadDataTable );

        },

        selectRecord(id) {

            if ( this.summerNoteInstance ) {
                
                this.insertNewTemplate(id);

            } else {

                if ( typeof this?.callingComponent.templatesSelected === 'function') {
                    
                    this.callingComponent.templatesSelected([id]);

                }

            }

            this.hide();

        },

        selectClicked() {

            this.hide();

            this.callingComponent.templatesSelected(this.selectedRows);

        },

        async insertNewTemplate(templateId) {

            let template = await axios.post('/lolsystemtemplate/get/' + templateId)

            if ( template.data.errors ) {

                showError('Error',template.data.errors);

            } else {

                this.callingComponent.templateContents = template.data.data[0].contents;

                if ( this.callingComponent.previewingFlag ) {

                    root.vueRender( this.callingComponent.templateContents, this.callingComponent.templateData )

                    .then( (renderedContents) => {
                        this.summerNoteInstance.$note.summernote('code',renderedContents);
                    });

                } else {

                    this.summerNoteInstance.$note.summernote('code',templateContents);

                }
            }

        },

        pageTitle() {
            return this?.source ? this.source + ' Templates' : '';
        },

    },


}  
</script>

