
<template>
<div class="modal" :id="id" style="z-index: 2000">
    <div class="modal-dialog modal-dialog-right" style="margin-top:15vh">
        <div class="modal-content blue-border">

            <div class="modal-header blue-bg">
                <h2 class="modal-title" v-html="title"/>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="modal-body">

                <div class="form-group row">
                    <text-input 
                        _class="col-md-12"
                        popOver='<h4>Search For</h4>
                        <p>Search for text and replace it with alternative text.</p>
                        <p>You can use Regex expressions here to perform more complex search and replace operations.</p>
                        <p>Click on the Help button below to find out more.</p>'
                        :popOverContainer="'#' + id"
                        v-model="searchFor" 
                        name="searchFor" 
                        label="Search For" :error="searchForError"
                    />

                </div>

                <div class="form-group row">
                    <text-input 
                        _class="col-md-12"
                        popOver="<h4>Replace With</h4>
                        <p>Replace the searched for text with this text.</p>
                        <p>Leave this blank to delete text.</p>"
                        :popOverContainer="'#' + id"
                        v-model="replaceWith" 
                        name="replaceWith" 
                        label="Replace With"
                    />
                </div>

                <div class="form-group row">

                    <div class="col-md-12">

                        <b-form-checkbox
                            :id="id + '-case-sensitive-checkbox'"
                            v-model="caseSensitiveFlag"
                            name="caseSensitiveFlag"
                            value="i"
                            unchecked-value=""
                            >
                            Case Sensitive?
                        </b-form-checkbox>

                    </div>
                </div>


            </div>

            <div class="modal-footer justify-content-between">
                <div>
                    <button class="btn btn-primary form-button mr-3" type="button" @click="showRegexHelp">
                        <span title="Regex help"><i class="fa fa-question-circle fa-lg mr-2"></i>Help</span>
                    </button>

                </div>
                <div>
                    <button class="btn btn-success form-button mr-2" type="button" @click="okClicked" title="Continue"><i class="fa fa-check-circle fa-lg mr-2"></i>OK</button>
                    <button class="btn btn-danger form-button" type="button" @click="cancelClicked" title="Abort"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
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

    props: {
        id: String,
    },

    data() {
        return {
            title: 'Search and Replace',
            searchForError: [],
            searchFor: '',
            replaceWith: '',
            caseSensitiveFlag: '',
            taggedRecordsFlag: false,
        };
    },

    mounted () {
        this.$parent.searchAndReplaceModal = this;
    },    

    methods: {

        display( taggedRecordsFlag ) {

            this.taggedRecordsFlag = taggedRecordsFlag;
            this.searchForError = [];
            this.searchFor = this.replaceWith = '';

            this.show();

            setTimeout(function(){
                $('input[name="searchFor"]').focus();
            });

        },

        showRegexHelp() {

            axios.post('/help/get', {
                fileName: 'regex.html'
            })

            .then(response => {

                if (response.data.error) {

                    showError('An error was encountered retrieving a help file',response.data.error);

                } else {

                    showHelp('Advanced Search & Replace', response.data.contents);//, sizeClass);

                }
            });


        },


        okClicked() {

            if ( !this.searchFor ) {

                this.searchForError.push('Please specify what to search for');

            } else {

                this.hide();

                if ( typeof this.$parent.searchAndReplaceOkClicked === 'function') {
                    
                    this.$parent.searchAndReplaceOkClicked(this.searchFor, this.replaceWith, this.taggedRecordsFlag, this.caseSensitiveFlag); 

                } else {

                    console.log('searchAndReplaceOkClicked not defined in parent');

                }

            }

        },

        cancelClicked() {

            this.hide();

            if ( typeof this.$parent.searchAndReplaceCancelClicked === 'function') {
                
                this.$parent.searchAndReplaceCancelClicked(); 

            }

        },


    }   
}  
</script>