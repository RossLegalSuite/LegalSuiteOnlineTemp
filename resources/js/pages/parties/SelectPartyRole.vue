<template>
<div :class="formControls ? _class : ''">

    <div v-show="formControls">
        
        <label v-if="showLabel">{{label}}</label>
        <span v-if="popOver">   
            <pop-over :content="popOver" :container="popOverContainer ? popOverContainer : $parent.modal ? '#' + $parent.id : 'body'"/>
        </span>
        <span v-if="clearIcon">
            <i class="fa fa-times-circle cp text-danger ml-1 clear-icon" style="font-size: large" title="Clear" @click="clearIconClicked"></i>
        </span>
        <div v-show="setReadOnly">

            <input
                :value="record ? record.description : ''"
                class="form-control"
                readonly
            />
        </div>

        <div v-show="!setReadOnly" class="input-group">

            <select-party-role-dropdown
                :id="id + '-select-party-role-dropdown'"
                :class="error[0] ? 'multiselect-invalid-feedback' : ''"
                openDirection="below"
                :placeholder="filtering ? 'Filter by Role' : ''"
                :options="$root.partyRoles" 
                v-model="record"
                track-by="recordid"
                :tabindex="-1"
                label="description"
                :disabled="readOnly || disabled"
                :allow-empty="false"
                :show-labels="false"
                @input="partyRoleSelected"
            >
            <template slot="noResult">No Roles found</template>
            <template slot="noOptions">No Roles found...</template>
            <template slot="option" slot-scope="props">
                <div>
                    <span>{{ props.option.description }}</span>
                </div>
            </template>                            
            </select-party-role-dropdown>

            <div v-show="!setReadOnly" class="input-group-append">
                <button
                    tabindex="-1"
                    v-on:click="selectPartyRole"
                    type="button"
                    :title="'Select a ' + singular"
                    :class="error[0] ? 'btn btn-danger multiselect-invalid-feedback' : 'btn btn-primary'"
                ><i class="fa fa-cog"></i></button>
            </div>
        </div>
        <div v-if="!filtering" v-html="error[0]" class="invalid-feedback"></div>


    </div>

    <div class="modal" :id="id">

        <div class="modal-dialog modal-dialog-left">

            <div class="modal-content" style="border-color:indianred">

                <div class="modal-header indianred">
                    <h2 class="modal-title page-title"><i class="fa fa-server mr-2"></i>Select a {{singular}}</h2>
                    <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                </div>

                <div class="modal-body p-3" style="height: 60vh; overflow-y: auto;">
                    
                    <party-role-table
                    :options-button="false"
                    :table-id="id + '-table'"
                    :lazyLoadFlag="true"
                    :ref="_uid + '-select-party-role-table'"
                    :form-ref="formRef"
                    />

                </div>

                <div class="modal-footer ">
                    <button class="btn btn-danger form-button" type="button"  v-on:click="hide" title="Cancel selection"><i class="fa fa-times-circle fa-lg mr-2"></i>Cancel</button>
                </div>

            </div>

        </div>

    </div>

</div>
</template>

<script>

import modalTemplate from "@components/modals/modal-template";
import Multiselect from 'vue-multiselect';

export default {

    mixins: [modalTemplate],       

    components: {
        PartyRoleTable: () => import("./PartyRoleTable"),
        SelectPartyRoleDropdown: Multiselect
    },

    props: {
        clearIconCallback: { type: String, default: 'clearSelectPartyRole' },
        clearIcon: { type: Boolean, default: false },
        title: {
            type: String,
            default: 'Click on the button to select a Party Role',
        }, 
        _class: {
            type: String, 
            default: 'col-md-12',
        },
        label: {
            type: String,
            default: 'Role',
        },
        singular: {
            type: String,
            default: 'Role',
        },
        plural: {
            type: String,
            default: 'Roles',
        },
        formRef: String,
        showLabel: {
            type: Boolean,
            default: true,
        },
        filtering: {
            type: Boolean,
            default: false,
        },
        formControls: {
            type: Boolean,
            default: true,
        },
        readOnly: {
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
            table: null,
            record: null,
            disabled: null,
            setReadOnly: null,
        };
    },


    mounted () {
        this.$parent.selectPartyRole = this;
        this.setReadOnly = this.readOnly;
    },    

    methods: {

        clearIconClicked() {
            if ( typeof this.$parent[this.clearIconCallback] === 'function') this.$parent[this.clearIconCallback]();
        },

        newRecordButtonClicked() {

            this.$refs[this._uid + '-select-party-role-form'].insertClicked();

        },

        selectPartyRole() {

            this.show();

            this.table.selectTableFlag = true;
            this.table.actionColumnWidth = 12;

            if ( !this.table.table ) setTimeout( this.table.loadDataTable );

        },


        partyRoleSelected(selectedRecord) {

            this.record.recordid = selectedRecord.recordid;
            this.record.description = htmlDecode(selectedRecord.description);

            if ( typeof this.$parent.partyRoleSelected === 'function') {
                this.$parent.partyRoleSelected(selectedRecord.recordid, selectedRecord.description, selectedRecord.rolescrnflag, selectedRecord.rolescrnid);
            }

        },        

        selectRecord(id) {

            this.partyRoleSelected( this.table.table.row('#' + id).data() );

            this.hide();

        },

    },

}  
</script>

