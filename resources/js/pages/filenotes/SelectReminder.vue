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
            <select-reminder-dropdown
                :id="id + '-select-reminder-dropdown'"
                :class="error[0] ? 'multiselect-invalid-feedback' : ''"
                openDirection="below"
                placeholder=""
                :options="dropdownOptions" 
                v-model="record"
                track-by="recordid"
                :tabindex="-1"
                label="description"
                :disabled="readOnly || disabled"
                :allow-empty="false"
                :show-labels="false"
                @input="reminderSelected"
            >
            <template slot="noResult">No Reminders found</template>
            <template slot="noOptions">No Reminders found...</template>
            <template slot="option" slot-scope="props">
                <div>
                    <span>{{ props.option.formatteddate + ' - ' + props.option.description }}</span>
                </div>
            </template>                            
            </select-reminder-dropdown>

            <div v-if="!readOnly" class="input-group-append">
                <button
                    tabindex="-1"
                    v-on:click="selectReminder"
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
                    <h2 class="modal-title page-title"><i class="fa fa-server mr-2"></i>Select a Reminder</h2>
                    <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                </div>

                <div class="modal-body p-3" style="height: 70vh; overflow-y: auto;">
                    
                    <reminder-table
                        :options-button="false"
                        :table-id="id + '-table'"
                        :lazyLoadFlag="true"
                        ref="select-reminder-table"
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
        ReminderTable: () => import("./ReminderTable"),
        SelectReminderDropdown: Multiselect
    },

    props: {
        clearIconCallback: { type: String, default: 'clearSelectReminder' },
        clearIcon: { type: Boolean, default: false },
        callback: {
            type: String,
            default: 'reminderSelected',
        }, 
        parentName: {
            type: String,
            default: 'selectReminder',
        }, 
        title: {
            type: String,
            default: 'Click on the button to select a Reminder',
        }, 
        _class: {
            type: String, 
            default: 'col-md-12',
        },
        label: {
            type: String,
            default: 'Reminder',
        },
        popOver: { type: String, default:'' },
        popOverContainer: { type: String, default:'' },
        singular: {
            type: String,
            default: 'Reminder',
        },
        plural: {
            type: String,
            default: 'Reminders',
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
            dropdownOptions: [],
            matterId: null,
        };
    },
    watch: {

        matterId(newValue) {

            //console.log("Watching matterId - newValue",newValue);

            this.matterId = newValue;

            this.getReminders();

        },

    },

    mounted () {
        this.$parent[this.parentName] = this;
    },    

    methods: {

        getReminders() {

            if (!this.matterId) {
                this.dropdownOptions = [];

            } else {

                this.getMatterReminders()

                .then( (response) => {
                    
                    this.dropdownOptions = response;

                }).catch( (error) => {
                    showError('Error',error)
                    this.dropdownOptions = [];
                });

            }

        },


        getMatterReminders() {

            return new Promise((resolve, reject) => {

                axios.post('/todonote/get',{where: 'matterid,' + this.matterId})
                
                .then(response => {

                    if (response.data.errors) {

                        reject(response.data.errors);

                    } else {

                        resolve( response.data.data);

                    }

                }).catch( (error) => {
                    reject('Error getting Matter Reminders: ' +error ); 
                });

            });

        },


        clearIconClicked() {
            if ( typeof this.$parent[this.clearIconCallback] === 'function') this.$parent[this.clearIconCallback]();
        },

        selectReminder() {

            this.show();

            this.table.selectTableFlag = true;

            this.table.actionColumnWidth = 12;

            // Being watched - it loads the DataTable
            this.table.matterId = this.matterId;

        },

        reminderSelected(selectedRecord) {

            this.record = {
                recordid: selectedRecord.recordid,
                description: selectedRecord.formatteddate + ' - ' + selectedRecord.description
            };

            // Override default one set in form-template.js
            if ( typeof this.$parent.customReminderSelected === 'function') {

                this.$parent.customReminderSelected(selectedRecord.recordid, selectedRecord.description);

            } else if ( typeof this.$parent[this.callback] === 'function') {

                this.$parent[this.callback](selectedRecord.recordid, selectedRecord.description);

            }

        },        

        selectRecord(id) {

            this.reminderSelected( this.table.table.row('#' + id).data() );

            this.hide();

        },

    },

}  
</script>

