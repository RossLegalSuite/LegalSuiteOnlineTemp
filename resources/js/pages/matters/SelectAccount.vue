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
            <select-account-dropdown
                :id="id + '-select-account-dropdown'"
                :class="error[0] ? 'multiselect-invalid-feedback' : ''"
                openDirection="below"
                :options="setDropDownOptions()"
                placeholder=""
                v-model="record"
                track-by="recordid"
                :tabindex="-1"
                label="description"
                :disabled="readOnly || disabled"
                :allow-empty="false"
                :show-labels="false"
                @input="accountSelected"
            >
            <template slot="noResult">No Accounts found</template>
            <template slot="noOptions">No Accounts found...</template>
            <template slot="option" slot-scope="props">
                <div>
                    <span>{{ props.option.description }}</span>
                </div>
            </template>                            
            </select-account-dropdown>

            <div v-if="!readOnly" class="input-group-append">
                <button
                    tabindex="-1"
                    v-on:click="selectAccount"
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
                    <h2 class="modal-title page-title">
                        <i class="fa fa-server mr-2"></i>
                        <span v-text="setTitle()"/>
                    </h2>
                    <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                </div>

                <div class="modal-body p-3" style="height: 60vh; overflow-y: auto;">
                    
                    <account-table
                    :options-button="false"
                    :table-id="id + '-table'"
                    :lazyLoadFlag="true"
                    ref="select-account-table"
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
import Multiselect from 'vue-multiselect';

export default {

    mixins: [modalTemplate],       

    components: {
        AccountTable: () => import("./AccountTable"),
        SelectAccountDropdown: Multiselect
    },

    props: {
        category: {
            type: String, 
            default: null,
        },        
        clearIconCallback: { type: String, default: 'clearSelectAccount' },
        clearIcon: { type: Boolean, default: false },
        callback: {
            type: String,
            default: 'accountSelected',
        },  
        parentName: {
            type: String,
            default: 'selectAccount',
        }, 
        title: {
            type: String,
            default: 'Click on the button to select a Account',
        }, 
        _class: {
            type: String, 
            default: 'col-md-12',
        },
        label: {
            type: String,
            default: 'Accounts',
        },
        singular: {
            type: String,
            default: 'Account',
        },
        plural: {
            type: String,
            default: 'Accounts',
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
        this.$parent[this.parentName] = this;
    },    

    methods: {

        clearIconClicked() {
            if ( typeof this.$parent[this.clearIconCallback] === 'function') this.$parent[this.clearIconCallback]();
        },

        newRecordButtonClicked() {

            this.$refs['select-account-form'].table = this.$refs['select-account-table'];
            this.$refs['select-account-form'].insertClicked();

        },

        selectAccount() {

            this.show();

            this.table.selectTableFlag = true;
            this.table.actionColumnWidth = 12;

            if ( this.category ) {
                this.table.where = ['business.type,=,' + this.getType(), 'NotUsedFlag,<>,1'];
            } else {
                this.table.where = ['NotUsedFlag,<>,1'];
            }            

            this.table.loadDataTable();

        },

        accountSelected(selectedRecord) {

            if ( typeof this.$parent[this.callback] === 'function') 
            this.$parent[this.callback](selectedRecord.recordid, selectedRecord.description);

            this.hide();

        },        

        selectRecord(id) {

            this.accountSelected( this.table.table.row('#' + id).data() );

            this.hide();

        },


        setTitle() {

            let returnValue = 'Select ';

            if ( this.category === 'incomeAccounts') {

                returnValue += 'an Income Account';

            } else if ( this.category === 'trustBankAccounts') {
                
                returnValue += 'a Trust Bank Account';

            } else if ( this.category === 'businessBankAccounts') {
                
                returnValue += 'a Business Bank Account';
            }

            return returnValue;

        },

        getType() {

            let returnValue = '1';

            if ( this.category === 'incomeAccounts') {

                returnValue = '1';

            } else if ( this.category === 'trustBankAccounts') {

                returnValue = '14';

            } else if ( this.category === 'businessBankAccounts') {

                returnValue = '13';
            }

            return returnValue;
        },

        setDropDownOptions() {

            if ( this.category === 'incomeAccounts') {

                return root.accounts.filter(account => account.type == 1);

            } else if ( this.category === 'trustBankAccounts') {
                
                return root.accounts.filter(account => account.type == 14);

            } else if ( this.category === 'businessBankAccounts') {
                
                return root.accounts.filter(account => account.type == 13);

            }

        },



    },

}  
</script>

