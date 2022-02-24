<template>
<div :class="formControls ? _class : ''">

    <div v-show="formControls">
        
        <label>{{label}}</label>
        <span v-if="popOver">   
            <pop-over :content="popOver" :container="popOverContainer ? popOverContainer : $parent.modal ? '#' + $parent.id : 'body'"/>
        </span>
        <span v-if="clearIcon">
            <i class="fa fa-times-circle cp text-danger ml-1 clear-icon" style="font-size: large" title="Clear" @click="clearIconClicked"></i>
        </span>
        <div class="input-group">
            <select-cause-of-action-dropdown
                :id="id + '-select-cause-of-action-dropdown'"
                :class="error[0] ? 'multiselect-invalid-feedback' : ''"
                openDirection="below"
                placeholder=""
                :options="$root.causeOfActions" 
                v-model="record"
                track-by="recordid"
                :tabindex="-1"
                label="description"
                :disabled="readOnly || disabled"
                :allow-empty="false"
                :show-labels="false"
                @input="causeOfActionSelected"
            >
            <template slot="noResult">No Cause of Actions found</template>
            <template slot="noOptions">No Cause of Actions found...</template>
            <template slot="option" slot-scope="props">
                <div>
                    <span>{{ props.option.description }}</span>
                </div>
            </template>                            
            </select-cause-of-action-dropdown>

            <div v-if="!readOnly" class="input-group-append">
                <button
                    tabindex="-1"
                    v-on:click="selectCauseOfAction"
                    type="button"
                    :title="'Select a ' + singular"
                    :class="error[0] ? 'btn btn-danger multiselect-invalid-feedback' : 'btn btn-primary'"
                ><i class="fa fa-cog"></i></button>
            </div>
        </div>
        <div v-html="error[0]" class="invalid-feedback"></div>


    </div>

    <div class="modal" :id="id">

        <div class="modal-dialog modal-dialog-left">

            <div class="modal-content" style="border-color:indianred">

                <div class="modal-header indianred">
                    <h2 class="modal-title page-title"><i class="fa fa-server mr-2"></i>Select a {{singular}}</h2>
                    <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                </div>

                <div class="modal-body p-3" style="height: 60vh; overflow-y: auto;">
                    
                    <cause-of-action-table
                    :options-button="false"
                    :table-id="id + '-table'"
                    :lazyLoadFlag="true"
                    ref="select-cause-of-action-table"
                    :formRef="formRef"
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
import { debounce } from 'lodash';
import Multiselect from 'vue-multiselect';

export default {

    mixins: [modalTemplate],       

    components: {
        CauseOfActionTable: () => import("./CauseOfActionTable"),
        SelectCauseOfActionDropdown: Multiselect
    },

    props: {
        clearIconCallback: { type: String, default: 'clearSelectCauseOfAction' },
        clearIcon: { type: Boolean, default: false },
        title: {
            type: String,
            default: 'Click on the button to select a Cause of Action',
        }, 
        _class: {
            type: String, 
            default: 'col-md-12',
        },
        label: {
            type: String,
            default: 'Cause of Action',
        },
        singular: {
            type: String,
            default: 'Cause of Action',
        },
        plural: {
            type: String,
            default: 'Cause of Actions',
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
        };
    },

    mounted () {
        this.$parent.selectCauseOfAction = this;
    },    

    methods: {

        clearIconClicked() {
            if ( typeof this.$parent[this.clearIconCallback] === 'function') this.$parent[this.clearIconCallback]();
        },

        newRecordButtonClicked() {

            this.$refs['select-cause-of-action-form'].table = this.$refs['select-cause-of-action-table'];
            this.$refs['select-cause-of-action-form'].insertClicked();

        },

        selectCauseOfAction() {

            this.show();

            this.table.selectTableFlag = true;
            this.table.actionColumnWidth = 12;

            if ( !this.table.table ) setTimeout( this.table.loadDataTable );

        },

        causeOfActionSelected(selectedRecord) {

            this.record = {
                recordid: selectedRecord.recordid,
                description: selectedRecord.description
            };

            if ( typeof this.$parent.causeOfActionSelected === 'function') this.$parent.causeOfActionSelected(selectedRecord.recordid, selectedRecord.description);

            this.hide();

        },        

        selectRecord(id) {

            this.causeOfActionSelected( this.table.table.row('#' + id).data() );

            this.hide();

        },
    },

}  
</script>

