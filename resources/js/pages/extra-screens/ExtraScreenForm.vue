<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-lg' : ''">

        <div :class="modal ? 'modal-content creditors-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header creditors-bg' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="!editing">Extra Screen will be Added</span>
                            <span v-else>Extra Screen will be Changed</span>
                        </h3>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="card-body overflow-auto p-3" :style="modal ? 'min-height:65vh' : ''">

                <div class="form-group row">

                    <text-input _class="col-xxl-4 col-xl-5" v-model="record.title" name="title" 
                    @change="setPrefix" label="Title" :error="errors.title"
                    :popOverContainer="'#' + this.id"
                    pop-over="<h4>Title</h4>
                        <p>The <strong>Title</strong> will be displayed as either the Tab title or Section title depending on its position.</p>
                        <p>The title is also used as the <em>prefix</em> of the <em>fields</em> which can be used in Document Templates (to assemble documents with the Extra Screen data).</p>
                        <p>For example, if the title of the Extra Screen is 'Insurance Details' and it contains a field called 'Policy Number', you can insert this into a Document by inserting <strong>insuranceDetails->policyNumber</strong> in the document.</p>
                        <p><strong>Note:</strong>The title of the Extra Screen must be unique and it is advisable that it is not changed otherwise any Documents using the old title (i.e. prefix) will no longer work and each Document will need to be modified.</p>"
                    />
                    

                    <text-input _class="col-xxl-8 col-xl-7" v-model="record.description" name="description" label="Description" :error="errors.description"
                    :popOverContainer="'#' + this.id"
                    pop-over="<h4>Description</h4>
                    <p>Provide a <strong>description</strong> to describe the purpose of the Extra Screen or to give additional details about it.</p>
                    <p>It is <em>not</em> displayed on the Extra Screen.</p>"
                    />

                </div>

                <div class="form-group row">

                    <div class="col-xxl-4 col-xl-5">

                        <label>Position</label>
                        <pop-over :container="'#' + id" content="
                            <h4>Extra Screen Position</h4>
                            <p>An Extra Screen can be displayed in the Details tab of the Form it belongs to or in its own Tab (at the top of the Form).</p>
                            <p>Choose <strong>Form</strong> to display the Extra Screen in the Form or choose <strong>Tab</strong> to display it in it's own tab.</p>
                            <p>Choose the approprate position based on its relevance and the available space used by other Extra Screens and their tabs.</p>
                        "/>
                        <v-select 
                            :options="screenPositionOptions" 
                            :clearable="false"
                            :searchable="false"
                            v-model="record.position"
                            :reduce="screenPositionOptions => screenPositionOptions.value"
                        />

                    </div>

                    <text-input _class="col-xxl-4 col-xl-5" v-model="record.prefix" name="prefix" 
                    @change="convertPrefix" label="Prefix" :error="errors.prefix"
                    :popOverContainer="'#' + this.id"
                    pop-over="<h4>Prefix</h4>
                        <p>The <strong>Prefix</strong> serves to identify the <em>data</em> in the Extra Screen to enable it to be used in a Document Template.</p>
                        <p>To conform to pre-defined standards, the prefix must be in <em>camel case</em>. For example, 'Letter Of Demand' in camel case is 'letterOfDemand'. Note: You can type in <em>normal text</em> (i.e. non camel case) if you prefer - the program will convert it to camel case for you.</p>
                        <p>The Field Labels will be used as the suffix and will also be converted to camel case. So if the prefix of the Extra Screen is 'letterOfDemand' and it contains a Field called 'Cause Of Action', the name of the Merge Field (which you can insert into a Document Template) will be <strong>letterOfDemand->causeOfAction</strong>.</p>
                        <p><strong>Note:</strong>The prefix of the Extra Screen must be unique and it is advisable that it is not changed otherwise any Templates using the old prefix will no longer work.</p>"
                    />

                </div>

                <div class="form-group row">

                    <div class="col-xxl-5 col-xl-6">

                        <label>Location</label>
                        <pop-over :container="'#' + id" content="
                            <h4>Extra Screen Location</h4>
                            <p>Extra Screens can be added to a Matter or Party form to allow the user to capture additional information that may be relevant for a certian type of Party or type of Matter or if a Party plays a certain Role on a Matter.</p>
                            <p>The location can be set to the following:</p>
                            <p><strong>All Matters</strong>: Display this screen for <em>all</em> Matters.</p>
                            <p><strong>All Parties</strong>: Display this screen for <em>all</em> Parties.</p>
                            <p><strong>Matter Type</strong>: Display this screen for Matters with this Matter Type.</p>
                            <p><strong>Document Set</strong>: Display this screen for Matters with this Document Set.</p>
                            <p><strong>Party Role</strong>: Display this screen for <em>Matter Parties</em> who plays this Role on a Matter.</p>
                            <p><strong>Party Type</strong>: Display this screen for Parties of this Type.</p>
                            <p><strong>Party Entity</strong>: Display this screen for Parties who are this type of Entity.</p>
                        "/>
                        <v-select 
                            :options="screenLocationOptions" 
                            :clearable="false"
                            :searchable="false"
                            v-model="record.location"
                            :reduce="screenLocationOptions => screenLocationOptions.value"
                        />

                    </div>

                    <select-matter-type
                        v-show="record.location === 'Matter Type'"
                        :id="id + '-select-matter-type'"
                        _class="col-xxl-6 col-xl-7"
                        popOver="<h4>Matter Type</h4><p>Only display this Extra Screen for Matters with this Matter Type.</p>"
                        :popOverContainer="modal ? '#' + id : 'body'"
                        title="Display this Extra Screen for Matters with this Matter Type"
                        :ref="id + '-select-matter-type'" 
                        :form-ref="id + '-select-matter-type'"
                        :error="errors.matterTypeId"
                    />

                    <select-document-set
                        v-show="record.location === 'Document Set'"
                        :id="id + '-select-document-set'"
                        _class="col-xxl-6 col-xl-7"
                        popOver="<h4>Matter Type</h4><p>Only display this Extra Screen for Matters with this Document Set.</p>"
                        :popOverContainer="modal ? '#' + id : 'body'"
                        title="Display this Extra Screen for Matters with this Document Set"
                        :ref="id + '-select-document-set'" 
                        :form-ref="id + '-select-document-set'"
                        :error="errors.documentSetId"
                    />


                    <select-party-entity
                        v-show="record.location === 'Party Entity'"
                        popOver="<h4>Party Entity</h4><p>Only display this Extra Screen for Parties that are this Entity Type.</p>" 
                        :popOverContainer="modal ? '#' + id : 'body'"
                        label="Party Entity"
                        _class="col-xxl-6 col-xl-7"
                        :id="id + '-select-party-entity'"
                        title="The Entity of the Party"
                        :ref="id + '-select-party-entity'" 
                        :form-ref="id + '-select-party-entity'"
                        :error="errors.partyEntityId"
                    />

                    <select-party-type
                        v-show="record.location === 'Party Type'"
                        popOver="<h4>Party Type</h4><p>Only display this Extra Screen for Parties that are this Type of Entity.</p>" 
                        :popOverContainer="modal ? '#' + id : 'body'"
                        label="Party Type"
                        _class="col-xxl-6 col-xl-7"
                        :id="id + '-select-party-type'"
                        title="The Type of Party"
                        :ref="id + '-select-party-type'" 
                        :form-ref="id + '-select-party-type'"
                        :error="errors.partyTypeId"
                    />

                    <select-party-role 
                        v-show="record.location === 'Party Role'"
                        popOver="<h4>Party Role</h4><p><p>Display this Extra Screen for Parties that play this Role on a Matter.</p>" 
                        :popOverContainer="modal ? '#' + id : 'body'"
                        label="Party Role"
                        _class="col-xxl-6 col-xl-7"
                        :id="id + '-select-party-role'" 
                        title="Roles a Party can play on a Matter"
                        :ref="id + '-select-party-role'" 
                        :formRef="id + '-select-party-role'"
                        :error="errors.partyRoleId" 
                    />


                </div>

                <div v-show="formBuilderMode === 'edit'" class="row">

                    <div class="col-md-12">

                        <fieldset class="mt-1 pb-2">

                            <legend class="cp" @click="toggleMode"><i class="fa fa-server mr-2"></i>View Form</legend>

                            <div :id="id + '-form-edit'"/>

                        </fieldset>

                    </div>
                </div>

                <div v-show="formBuilderMode === 'view'" class="row">

                    <div class="col-md-12">

                        <fieldset class="mt-1 pb-2">

                            <legend class="btn-danger cp" @click="toggleMode"><i class="fa fa-edit mr-2"></i>Edit Form</legend>

                            <div :id="id + '-form-view'">
                                <form :id="id + '-form-view-form'" action="#"></form>
                            </div>

                        </fieldset>

                    </div>
                </div>
            </div>

            <form-buttons :editing="editing" :viewing="viewing" record="Extra Screen" @ok-clicked="okClicked" @cancel-clicked="closeForm" @delete-clicked="deleteClicked"/>

        </div>
    </div>


</div>

</template>

<script>

//https://github.com/kevinchappell/formBuilder
//https://formbuilder.online/docs/formBuilder/overview/

import FormTemplate from "@pages/form-template";
import modalTemplate from "@components/modals/modal-template";

export default {

    mixins: [FormTemplate, modalTemplate],

    components: {
        SelectMatterType: () => import("@pages/matters/SelectMatterType"),
        SelectDocumentSet: () => import("@pages/document-sets/SelectDocumentSet"),
        SelectPartyRole: () => import("@pages/parties/SelectPartyRole"),
        SelectPartyType: () => import("@pages/parties/SelectPartyType"),
        SelectPartyEntity: () => import("@pages/parties/SelectPartyEntity"),
        //ExtraScreenTemplatesTable: () => import("./ExtraScreenTemplatesTable"),
        //ExtraScreenTemplatesForm: () => import("./ExtraScreenTemplatesForm"),
    },

    props: {
        resource: {type: String, default: 'Extra Screens' },
        uniqueId: String,
    },


    data() {
        return {
            screenPositionOptions : [ 
                {value:'Tab', label: 'Tab' }, 
                {value:'Form', label: 'Form' }, 
            ],
            screenLocationOptions : [ 
                {value:'Matter', label: 'All Matters' }, 
                {value:'Party', label: 'All Parties' }, 
                {value:'Matter Type', label: 'Matter Type' }, 
                {value:'Document Set', label: 'Document Set' }, 
                {value:'Party Role', label: 'Party Role' }, 
                {value:'Party Type', label: 'Party Type' }, 
                {value:'Party Entity', label: 'Party Entity' }, 
            ],
            formBuilderOptions: {
                editOnAdd: true,
                disabledActionButtons: ['clear','save'],
                disabledAttrs: ['subtype','required','access','name', 'value','multiple','maxlength','min','max','step'],
                disableFields: ['file','autocomplete','button','checkbox-group','hidden','radio-group','header','paragraph'],
                controlOrder: [ 'date','text','textarea','number','header','paragraph' ],
                formData: [],
                thisVueComponent: this,
                onCloseFieldEdit: function() {

                    // Clever hack to get this.record from the Vue Component to show the Merge Field name
                    //console.log('this.thisVueComponent.record.prefix',this.thisVueComponent.record.prefix);
                    
                    setTimeout(() => {
                    
                        let _this = this;

                        $('.form-wrap.form-builder .field-label').each( function() {

                            let thisHtml = $( this ).html();

                            if ( thisHtml.indexOf("Merge Field name") === -1 ) {
                                
                                console.log('Doing ',$( this ).text());
                                $( this ).html(thisHtml + '  <span title="Merge Field name" style="font-weight: bold">{' + toCamelCase(_this.thisVueComponent.record.prefix) + '.' + toCamelCase( $( this ).text() ) + '}</span>') ;
                            }

                        });


                    }, 500);
                }
            },
            formBuilderFields: [],
            formBuilder: null,
            formBuilderMode: 'edit',
            //templatesTable: null,
        };
    },

    methods: {

        // newRecordButtonClicked() {
        //     this.$refs[this._uid + '-extra-screen-templates-form'].insertClicked( this.record.id );
        // },

        editRecord(id) {

            axios.post('/extra_screens/get',{recordid: id})

            .then(response => {

                this.record = response.data.data[0];

                if ( this.record.matterTypeId ) {
                    this.selectMatterType.record = {
                        id: this.record.matterTypeId,
                        description: htmlDecode(this.record.matterTypeDescription),
                    };
                }

                if ( this.record.documentSetId ) {
                    this.selectDocumentSet.record = {
                        id: this.record.documentSetId,
                        description: htmlDecode(this.record.documentSetDescription),
                    };
                }

                if ( this.record.partyEntityId ) {
                    this.selectPartyEntity.record = {
                        id: this.record.partyEntityId,
                        description: htmlDecode(this.record.partyEntityDescription),
                    };
                }

                if ( this.record.partyTypeId ) {
                    this.selectPartyType.record = {
                        id: this.record.partyTypeId,
                        description: htmlDecode(this.record.partyTypeDescription),
                    };
                }

                if ( this.record.partyRoleId ) {
                    this.selectPartyRole.record = {
                        id: this.record.partyRoleId,
                        description: htmlDecode(this.record.partyRoleDescription),
                    };
                }

                axios.post('/extra_screen_fields/get',{parentId: this.record.id})

                .then(response => {

                    response.data.forEach(row => {
                        row.values = JSON.parse(row.values);
                        row.required = row.required ? true : false;
                    });

                    this.formBuilderFields = response.data;

                    //console.log('this.formBuilderFields',this.formBuilderFields);

                    this.initFormData();

                    // setTimeout(() => {

                    //     this.templatesTable = this.$refs[this._uid + '-extra-screen-templates-table'];

                    //     //Set the table Height manually
                    //     let $thisForm = $('#' + this.id);
                    //     let $formBody = $thisForm.find('.form-tab-body');

                    //     this.templatesTable.tableOptions = {
                            
                    //         scrollY: (Math.round( $formBody.outerHeight() ) - 180)  + 'px',

                    //     };

                    //     this.templatesTable.extraScreenId = id;
                    //     this.templatesTable.subTitle = this.record.description;
                        
                    //     this.templatesTable.loadDataTable();
                    // });


                });

            });

        },

        initNewRecord() {

            this.formBuilderFields = [];

            this.formBuilderMode = 'edit';
            
            this.record = {
                createdById: root.loggedInEmployeeId,
                location: 'Matter',
                position: 'Tab',
                prefix: null,
                title: null,
                description: null,
                matterTypeId: null,
                documentSetId: null,
                partyRoleId: null,
                partyEntityId: null,
                partyTypeId: null,
            };

            this.initFormData();

            setTimeout(() => $('#' + this.id + ' input[name="title"]').focus() );

        },

        initFormData() {

            this.displayForm();

            this.displayFormBuilder();

        },

        displayFormBuilder() {

            this.formEditor = $( '#' + this.id + '-form-edit');

            this.formViewer = $( '#' + this.id + '-form-view');
            

            if ( !this.formBuilder ) {
                
                this.formBuilderOptions.formData = this.formBuilderFields;

                this.formBuilder = this.formEditor.formBuilder(this.formBuilderOptions);

            } else {

                this.formBuilder.actions.setData(this.formBuilderFields);

            }

            setTimeout(() => {
                this.showMergeFieldNames();
            }, 1000);
            
        },

        showMergeFieldNames() {

            let _this = this;

            $('.form-wrap.form-builder .field-label').each( function() {
                $( this ).html($( this ).html() + '  <span title="Merge Field name" style="font-weight: bold">{' + toCamelCase(_this.record.prefix) + '.' + toCamelCase( $( this ).text() ) + '}</span>') ;
            });

        },

        toggleMode() {

            this.formBuilder.actions.save();

            this.formBuilderMode = this.formBuilderMode === 'view' ? 'edit' : 'view';

            if ( this.formBuilderMode === 'view' ) {

                let _this = this;

                $('form', this.formViewer).formRender({
                    formData: this.formBuilder.formData,
                    notify: {
                        success: () => {

                            // Clever way of hooking into the "after rendered" event
                            $('.rendered-form label').each( function() {
                                $( this ).html($( this ).html() + '  <span style="font-weight: bold">{' + toCamelCase(_this.record.prefix) + '.' + toCamelCase( $( this ).text() ) + '}</span>') ;
                            });

                            return ''; 
                        },
                        warning: function(message) { return console.warn(message); },
                        error: function(message) { return console.error(message); },
                    },

                });

            }

        },




        checkForDuplicateFieldLabels() {

            return new Promise( (resolve, reject) => {

                let duplicateFlag = false, duplicateLabel = '', checkForDuplicateFields = [];

                let formBuilderFields = this.formBuilder.actions.getData();

                formBuilderFields.forEach(formBuilderField => {

                    checkForDuplicateFields = formBuilderFields.filter(field => field.label == formBuilderField.label);
                    
                    if ( checkForDuplicateFields.length > 1 ) { 
                        duplicateFlag = true;
                        duplicateLabel = formBuilderField.label;
                    }
                    
                });
                if ( duplicateFlag ) {
                    reject(duplicateLabel);
                } else {
                    resolve();
                }

            });

        },

        okClicked() {

            this.checkForDuplicateFieldLabels()
            .then( () => {

                this.record.matterTypeId = this.record.location === 'Matter Type' ? this.selectMatterType.record.id : null;
                this.record.documentSetId = this.record.location === 'Document Set' ? this.selectDocumentSet.record.id : null;
                this.record.partyEntityId = this.record.location === 'Party Entity' ? this.selectPartyEntity.record.id : null;
                this.record.partyTypeId = this.record.location === 'Party Type' ? this.selectPartyType.record.id : null;
                this.record.partyRoleId = this.record.location === 'Party Role' ? this.selectPartyRole.record.id : null;

                //console.log('this.formBuilder.actions.getData()',this.formBuilder.actions.getData());

                let formFields = { formFields: JSON.stringify(this.formBuilder.actions.getData()) };

                //console.log('formFields',formFields);

                axios.post('/extra_screens/store', { ...this.record, ...formFields } )

                .then(response => {

                    if (response.data.errors) {

                        if (response.data.errors.general) { showError( 'Error', response.data.errors.general[0]);} else { this.errors = response.data.errors; }

                    } else {

                        this.errors = {};

                        this.highlightTableRow(response.data.id, response.data.title);

                    }

                }).catch(error => { showError('Error saving ' + this.table.singular, error); });


            })
            .catch( (duplicateLabel) => {
                showError('Form Design Error','<p>The Field Names in the Form must be unique</p><p>The Field Label "' + duplicateLabel + '" is not unique.</p>');
            });


        },

        setPrefix() {

            if (this.editing) return;
            
            if (!this.record.prefix) {
                
                this.record.prefix = toCamelCase(this.record.title);
                $('input[name="prefix"]').val(this.record.prefix);

            }

            // Do the description as well... to help the user
            if (!this.record.description) {
                
                this.record.description = this.record.title;
                $('input[name="description"]').val(this.record.description);

            }

        },

        convertPrefix() {

            if (this.record.prefix) {

                this.record.prefix = toCamelCase(this.record.prefix);
                $('input[name="prefix"]').val(this.record.prefix);

            }

        },

        highlightTableRow( id, title ) {

            axios.post('/extra_screens/getTablePosition', { title: title })

            .then(response => {

                this.table.jumpToRow(id, response.data);
                
                this.closeForm();

            });

        },     

    },

}  




</script>