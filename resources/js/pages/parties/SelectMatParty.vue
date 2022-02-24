<template>
<div :class="formControls ? _class : ''">
        
    <div v-show="formControls">
        
        <label>{{label}}</label>
        <span v-if="popOver">   
            <pop-over :content="popOver" :container="popOverContainer ? popOverContainer : $parent.modal ? '#' + $parent.id : 'body'"/>
        </span>
        <span v-if="clearIcon">
            <i class="fa fa-times-circle cp text-danger ml-1 clear-icon" style="font-size: large" title="Clear this selection" @click="clearIconClicked"></i>
        </span>
        <div class="input-group">

            <input
                :value="partyName"
                class="form-control"
                readonly
            />

            <div v-if="!readOnly" class="input-group-append">
                <button
                    tabindex="-1"
                    v-on:click="selectMatParty"
                    type="button"
                    :title="'Select a ' + singular"
                    :class="error[0] ? 'btn btn-danger multiselect-invalid-feedback' : 'btn btn-primary'"
                ><i class="fa fa-cog"></i></button>
            </div>
        </div>
        <div v-html="error[0]" class="invalid-feedback"></div>


    </div>

    <div class="modal" :id="id">

        <div class="modal-dialog modal-dialog-left modal-lg">

            <div class="modal-content" style="border-color:indianred">

                <div class="modal-header indianred">
                    <h2 class="modal-title page-title"><i class="fa fa-server mr-2"></i>Select a {{singular}}</h2>
                    <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                </div>

                <div class="modal-body p-3" style="height: 70vh; overflow-y: auto;">
                    
                    <matter-parties-table
                        :table-id="id + '-table'"
                        :lazyLoadFlag="true"
                        :ref="id + '-select-mat-party-table'"
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
        MatterPartiesTable: () => import("@pages/matter-parties/MatterPartiesTable"),
    },

    props: {
        matterId: { type: String, default:'' },
        clearIconCallback: { type: String, default: 'clearSelectParty' },
        clearIcon: { type: Boolean, default: false },
        title: {
            type: String,
            default: 'Click on the button to select a Party.',
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
        };
    },

    mounted () {
        this.$parent[this.parentName] = this;
    },    

    methods: {

        clearIconClicked() {
            if ( typeof this.$parent[this.clearIconCallback] === 'function') this.$parent[this.clearIconCallback]();
        },

        selectMatParty() {

            this.show();

            this.table.selectTableFlag = true;

            this.table.actionColumnWidth = 12;
            
            if ( this.matterId ) {
                this.table.whereRaw = "MatterId = " + this.matterId;
            }

            this.table.loadDataTable();

        },


        matPartySelected(selectedRecord) {

            this.partyName = selectedRecord.partyname;

            if ( typeof this.$parent[this.callback] === 'function') {
                this.$parent[this.callback](selectedRecord.recordid, selectedRecord.partyname, selectedRecord.partyid);
            }
        },        

        selectRecord(id) {

            this.matPartySelected( this.table.table.row('#' + id).data() );

            this.hide();


        },

    },

}  
</script>

