<template>

    <div>

        <div class="modal" :id="id">

            <div class="modal-dialog modal-dialog-left">

                <div class="modal-content" style="border-color:indianred">

                    <div class="modal-header indianred">
                        <h2 class="modal-title page-title"><i class="fa fa-cubes mr-2"></i>Insert Component</h2>
                        <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <div class="modal-body p-3" style="height: 60vh; overflow-y: auto;">
                        
                        <select-component-table
                            ref="select-component-table"
                            tableId="global-select-component-table"
                            :newRecordButton="false"
                            formRef="globalSelectComponent"
                            :lazyLoadFlag="true"
                        />

                    </div>

                    <div class="modal-footer justify-content-between">

                        <div>
                            <button class="btn btn-danger form-button" type="button"  v-on:click="hide" title="Cancel selection"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
                        </div>
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

    components: {
        SelectComponentTable: () => import("@pages/system-components/SystemComponentsTable"),
    },

    methods: {

        load( summerNoteInstance ) {

            this.summerNoteInstance = summerNoteInstance;

            this.show();

            this.table.selectTableFlag = true;
            this.table.actionColumnWidth = 12;

            setTimeout( this.table.loadDataTable );

        },


        selectRecord(id) {

            let data = this.table.table.row('#' + id).data();

            // console.log("this.summerNoteInstance",this.summerNoteInstance);
            // console.log("this.summerNoteInstance.$note",this.summerNoteInstance.$note);
            // console.log("this.summerNoteInstance.options.pageId",this.summerNoteInstance.options.pageId);

            let codeViewFlag = this.summerNoteInstance.$note.summernote('codeview.isActivated');

            if ( !codeViewFlag ) this.summerNoteInstance.$note.summernote('codeview.toggle');

            let pageId = this.summerNoteInstance.options.pageId;

            let codeMirrorElement = $('#' + pageId + ' .CodeMirror');

            if ( codeMirrorElement.length ) {

                let codeViewInstance = codeMirrorElement[0].CodeMirror;

                if ( codeViewInstance ) {

                    codeViewInstance.replaceSelection( '<component is="' + toKebabCase(data.title) + '"><strong>[' + data.title.capitalize() + ']</strong></component>' );

                } else {

                    showError('Error','codeView Instance not found');
                }


            } else {

                showError('Error','codeView Element not found');

            }

            if ( !codeViewFlag ) this.summerNoteInstance.$note.summernote('codeview.toggle');

            this.hide();

        },


    },

}  
</script>

