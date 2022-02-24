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
            <select-stage-dropdown
                :id="id + '-select-stage-dropdown'"
                :class="error[0] ? 'multiselect-invalid-feedback' : ''"
                openDirection="below"
                placeholder=""
                :options="getStages()" 
                v-model="record"
                track-by="recordid"
                :tabindex="-1"
                label="description"
                :disabled="readOnly || disabled"
                :allow-empty="false"
                :show-labels="false"
                @input="stageSelected"
            >
            <template slot="noResult">No Stages found</template>
            <template slot="noOptions">No Stages found...</template>
            <template slot="option" slot-scope="props">
                <div>
                    <span>{{ props.option.code + ' - ' + props.option.description }}</span>
                </div>
            </template>                            
            </select-stage-dropdown>

            <div v-if="!readOnly" class="input-group-append">
                <button
                    tabindex="-1"
                    v-on:click="selectStage"
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
                    <h2 class="modal-title page-title"><i class="fa fa-server mr-2"></i>Select a Stage</h2>
                    <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                </div>

                <div class="modal-body p-3" style="height: 70vh; overflow-y: auto;">
                    
                    <stage-table
                        :options-button="false"
                        :table-id="id + '-table'"
                        :lazyLoadFlag="true"
                        ref="select-stage-table"
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
import Multiselect from 'vue-multiselect';

export default {

    mixins: [modalTemplate],       

    components: {
        StageTable: () => import("./StageTable"),
        SelectStageDropdown: Multiselect
    },

    props: {
        clearIconCallback: { type: String, default: 'clearSelectStage' },
        clearIcon: { type: Boolean, default: false },
        callback: {
            type: String,
            default: 'stageSelected',
        }, 
        parentName: {
            type: String,
            default: 'selectStage',
        }, 
        title: {
            type: String,
            default: 'Click on the button to select an Stage',
        }, 
        _class: {
            type: String, 
            default: 'col-md-12',
        },
        label: {
            type: String,
            default: 'Stage',
        },
        popOver: { type: String, default:'' },
        popOverContainer: { type: String, default:'' },
        singular: {
            type: String,
            default: 'Stage',
        },
        plural: {
            type: String,
            default: 'Stages',
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
            stageGroupId: null,
        };
    },
    watch: {

        stageGroupId(newValue) {

            //console.log("Watching stageGroupId - newValue",newValue);

            this.stageGroupId = newValue;

            this.getStages();

        },

    },

    mounted () {
        this.$parent[this.parentName] = this;
    },    

    methods: {

        getStages() {

            if (!this.stageGroupId) {
                return [];
            } else {
                return root.stages.filter(record => record.stagegroupid == this.stageGroupId);
            }


        },

        clearIconClicked() {
            if ( typeof this.$parent[this.clearIconCallback] === 'function') this.$parent[this.clearIconCallback]();
        },

        selectStage() {

            this.show();

            this.table.selectTableFlag = true;

            this.table.actionColumnWidth = 12;

            // Being watched - it loads the DataTable
            this.table.stageGroupId = this.stageGroupId;

            //if ( !this.table.table ) setTimeout( this.table.loadDataTable );


        },

        stageSelected(selectedRecord) {

            this.record = {
                recordid: selectedRecord.recordid,
                description: selectedRecord.code + ' - ' + selectedRecord.description
            };

            // Override default one set in form-template.js
            if ( typeof this.$parent.customStageSelected === 'function') {

                this.$parent.customStageSelected(selectedRecord);

            } else if ( typeof this.$parent[this.callback] === 'function') {

                this.$parent[this.callback](selectedRecord);

            }

        },        

        selectRecord(id) {

            this.stageSelected( this.table.table.row('#' + id).data() );

            this.hide();

        },

    },

}  
</script>

