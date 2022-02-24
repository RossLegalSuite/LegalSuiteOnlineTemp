<template>
<div :class="formControls ? _class : ''" :style="_style">
        
    <div v-show="formControls">
        
        <label>{{label}}</label>
        <span v-if="popOver">   
            <pop-over :content="popOver" :container="popOverContainer ? popOverContainer : $parent.modal ? '#' + $parent.id : 'body'"/>
        </span>
        <span v-if="clearIcon">
            <i class="fa fa-times-circle cp text-danger ml-1 clear-icon" style="font-size: large" title="Clear this selection" @click="clearIconClicked"></i>
        </span>
        <div class="form-group">
            <div class="input-group">

                <input
                    :value="partyName"
                    class="form-control"
                    readonly
                />

                <div v-show="!setReadOnly" class="input-group-append">
                    <button
                        tabindex="-1"
                        v-on:click="selectParty"
                        type="button"
                        :title="'Select a ' + singular"
                        :class="error[0] ? 'btn btn-danger multiselect-invalid-feedback' : 'btn btn-primary'"
                    ><i class="fa fa-cog"></i></button>
                </div>
            </div>
        </div>
        <div v-html="error[0]" class="invalid-feedback"></div>


    </div>

    <div class="modal" :id="id">

        <div class="modal-dialog modal-dialog-left modal-lgr">

            <div class="modal-content" style="border-color:indianred">

                <div class="modal-header indianred">
                    <h2 class="modal-title page-title"><i class="fa fa-server mr-2"></i>Select a {{singular}}</h2>
                    <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                </div>

                <div class="modal-body p-3" style="height: 70vh; overflow-y: auto;">
                    
                    <party-table
                    :options-button="false"
                    :new-record-button="true"
                    :table-id="id + '-table'"
                    :lazyLoadFlag="true"
                    :ref="id + '-select-party-table'"
                    :form-ref="formRef"
                    />

                </div>

                <div class="modal-footer justify-content-between">

                    <div>
                        <modal-table-filter-footer/>
                    </div>

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
        PartyTable: () => import("./SelectPartiesTable"),
    },

    props: {
        clearIconCallback: { type: String, default: 'clearSelectParty' },
        clearIcon: { type: Boolean, default: false },
        title: {
            type: String,
            default: 'Click on the button to select a Party',
        },
        callback: {
            type: String,
            default: 'partySelected',
        },  
        parentName: {
            type: String,
            default: 'selectParty',
        }, 
        _class: {
            type: String, 
            default: 'col-md-12',
        },
        _style: {
            type: String,
            default: '',
        },
        label: {
            type: String,
            default: 'Party',
        },
        singular: {
            type: String,
            default: 'Party',
        },
        plural: {
            type: String,
            default: 'Parties',
        },
        formRef: String,
        formControls: {
            type: Boolean,
            default: true,
        },
        readOnly: {
            type: Boolean,
            default: false,
        },
        tableOnly: {
            type: Boolean,
            default: false,
        },
        popOver: { type: String, default:'' },
        popOverContainer: { type: String, default:'' },
        error: {
            type: Array,
            default: function () {
                return [null]
            },
        },
    },

    data() {
        return {
            callingComponent: null,
            table: null,
            partyName: '',
            disabled: null,
            setReadOnly: null,
        };
    },

    mounted () {
        this.$parent[this.parentName] = this;
        this.setReadOnly = this.readOnly;
    },    

    methods: {

        clearIconClicked() {
            if ( typeof this.$parent[this.clearIconCallback] === 'function') this.$parent[this.clearIconCallback]();
        },

        newRecordButtonClicked() {

            let partyForm = this.$root.$refs['pages'].$refs['globalPartyForm'];

            partyForm.table = this.$refs[this.id + '-select-party-table'];

            partyForm.insertClicked();

        },

        selectParty( callingComponent ) {

            // Work out the callingComponent because the global party form also has a SelectParty
            // It is best practice to set it in the component that uses SelectParty
            // e.g. this.selectParty.callingComponent = this;
            if ( !this.callingComponent && callingComponent && callingComponent._isVue ) this.callingComponent = callingComponent;

            if ( !this.callingComponent && this.$parent._isVue && typeof this.$parent[this.callback] === 'function') this.callingComponent = this.$parent;

            if ( !this.callingComponent ) {
                console.error("No Calling Component specified in SelectParty");
                return;
            }

            this.show();

            this.table.selectTableFlag = true;

            this.table.actionColumnWidth = 12;

            if ( !this.table.table ) setTimeout( this.table.loadDataTable );

        },

        partySelected(selectedRecord) {

            this.partyName = htmlDecode(selectedRecord.matterprefix + ' - ' + selectedRecord.name);

            // Override default one set in form-template.js
            if ( typeof this.callingComponent.customPartySelected === 'function') {
                
                this.callingComponent.customPartySelected(selectedRecord);

            } else if ( typeof this.callingComponent[this.callback] === 'function') {

                this.callingComponent[this.callback](selectedRecord);

            }


        },        

        selectRecord(id) {

            this.partySelected( this.table.table.row('#' + id).data() );

            this.hide();

        },

        // Used by CustomFilterForm.vue
        setByMatterPrefix(matterPrefix) {

            axios.post('/party/get',{ 
                whereRaw: "matterPrefix = '" + matterPrefix + "'"
            })
            
            .then(response => { 
                this.partyName =  htmlDecode(response.data.data[0].matterprefix + ' - ' + response.data.data[0].name);
            }).catch( (error) => {
                showError('Error getting Party by MatterPrefix', error); 
            });

        },


    },

}  
</script>

