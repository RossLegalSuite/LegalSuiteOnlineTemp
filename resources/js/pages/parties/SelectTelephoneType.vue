<template>
<div :class="formControls ? _class : ''">

    <div v-show="formControls">
        
        <label v-if="showLabel">{{label}}</label>
        <span v-if="popOver">   
            <pop-over :content="popOver" :container="popOverContainer ? popOverContainer : $parent.modal ? '#' + $parent.id : 'body'"/>
        </span>
        <div class="input-group">
            <select-telephone-type-dropdown
                :id="id + '-select-telephone-type-dropdown'"
                :class="error[0] ? 'multiselect-invalid-feedback' : ''"
                openDirection="below"
                :placeholder="filtering ? 'Filter by Role' : ''"
                :options="$root.telephoneTypes" 
                v-model="record"
                track-by="recordid"
                :tabindex="-1"
                label="description"
                :disabled="readOnly || disabled"
                :allow-empty="false"
                :show-labels="false"
                @input="telephoneTypeSelected"
            >
            <template slot="noResult">No Contact Methods found</template>
            <template slot="noOptions">No Contact Methods found...</template>
            <template slot="option" slot-scope="props">
                <div>
                    <span>{{ props.option.description }}</span>
                </div>
            </template>                            
            </select-telephone-type-dropdown>

            <div v-if="!readOnly" class="input-group-append">
                <button
                    tabindex="-1"
                    v-on:click="selectTelephoneTypes"
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
                    
                    <telephone-type-table
                    :table-id="id + '-table'"
                    :lazyLoadFlag="true"
                    :ref="_uid + '-select-telephone-type-table'"
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
        TelephoneTypeTable: () => import("./TelephoneTypeTable"),
        SelectTelephoneTypeDropdown: Multiselect
    },

    props: {
        title: {
            type: String,
            default: 'Click on the button to select a Contact Method',
        }, 
        _class: {
            type: String, 
            default: 'col-md-12',
        },
        label: {
            type: String,
            default: 'Contact Method',
        },
        singular: {
            type: String,
            default: 'Contact Method',
        },
        plural: {
            type: String,
            default: 'Contact Methods',
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
        };
    },

    mounted () {
        this.$parent.selectTelephoneType = this;
    },    

    methods: {


        selectTelephoneTypes() {

            this.show();

            this.table.selectTableFlag = true;
            this.table.actionColumnWidth = 12;

            if ( !this.table.table ) setTimeout( this.table.loadDataTable );

        },


        telephoneTypeSelected(selectedRecord) {

            if ( typeof this.$parent.telephoneTypeSelected === 'function') {
                this.$parent.telephoneTypeSelected(selectedRecord.recordid, selectedRecord.description, selectedRecord.internalflag);
            }

        },        

        selectRecord(id) {

            axios.post('/teletype/get/' + id)

            .then(response => {

                this.record = response.data.data[0];

                this.telephoneTypeSelected(response.data.data[0]);

            })

            .finally(() => {

                this.hide();

            });   

        },

    },

}  
</script>

