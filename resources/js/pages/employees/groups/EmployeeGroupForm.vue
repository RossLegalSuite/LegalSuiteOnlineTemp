<template>

<div :id="id" :class="modal ? 'modal': ''">
    
    <div :class="modal ? 'modal-dialog modal-dialog-centered modal-md' : ''">

        <div :class="modal ? 'modal-content steelblue-border':'card h-100 border-0'">

            <div :class="modal ? '':'card-header'">

                <div :class="modal ? 'modal-header steelblue' : 'd-flex justify-content-between'">

                    <div class="page-title">
                        <h3>
                            <span v-if="record.readOnly ? true : false">{{record.description}} [View Only]</span>                            
                            <span v-else-if="!editing">Employee Group will be Added</span>
                            <span v-else>Employee Group will be Changed</span>
                        </h3>
                        <i v-if="modal" title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
                    </div>

                    <page-close-button v-if="!modal" @closeClicked="closeForm"/>

                </div>

            </div>

            <div class="card-body form-tab-body overflow-auto p-3" style="min-height: 60vh">

                <form-tabs :tabs="tabs"/>

                <div v-show="activeTab === 'General'" class="form-tab-content">

                    <div class="form-group row">

                        <text-input 
                        v-if="editing"
                        :readOnly="record.code === 'SUPER'"
                        _class="col-md-4" 
                        popOver="<h4>Code</h4>
                        <p>The code is used by the program to identify the Employee Group and control the access to areas of the program based on the Permissions set for this Employee Group.</p>"
                        :popOverContainer="'#' + id"
                        v-model="record.code"
                        name="code"
                        label="Code"
                        :error="errors.code"/>
                    </div>

                    <div class="form-group row">
                        <text-input _class="col-md-12" v-model="record.description" name="description" label="Description" :error="errors.description"/>
                    </div>
                </div>

                <div v-show="activeTab === 'Permissions'" class="form-tab-content">

                    <permissions-table 
                        :ref="_uid + '-permissions-table'" 
                        :table-id="_uid + '-permissions-table'"
                        :lazy-load-flag="true"
                        :formTable="true"
                    />


                </div>

            </div>

            <form-buttons :editing="editing" :viewing="viewing" :preventDelete="record.code === 'SUPER' ? true: false" record="Employee Group" @ok-clicked="okClicked" @cancel-clicked="closeForm" @delete-clicked="deleteClicked"/>

        </div>
    </div>
</div>

</template>

<script>

import FormTemplate from "@pages/form-template";
import modalTemplate from "@components/modals/modal-template";

export default {
    
    mixins: [FormTemplate, modalTemplate],

    components: {
        PermissionsTable: () => import("./PermissionsTable"),
    },

    props: {
        resource: {type: String, default: 'Employee Groups' },
    },    

    data() {
        return {
            permissionsTableLoaded: false,
            permissionsTable: null,
            activeTab: 'General',
            tabs: [
                {
                    pageName: "General",
                    title: "Details",
                    iconClass: '',
                    visible: true,
                    active: true,
                },
                {
                    pageName: "Permissions",
                    title: "Permissions",
                    iconClass: '',
                    visible: true,
                    active: false,
                },
            ],

        };
    },
    
    watch: {

        activeTab(newValue, oldValue) {

            if ( newValue === 'Permissions' && !this.permissionsTableLoaded ) {

                this.permissionsTableLoaded = true;

                setTimeout(this.permissionsTable.loadDataTable);

            }
            
        }
    },

    methods: {

        editRecord(id) {

            this.permissionsTableLoaded = false;

            this.activeTab = 'General';
            this.tabs[0].active = true;
            this.tabs[1].visible = true;
            this.tabs[1].active = false;

            axios.post('/employee_groups/get',{recordid: id})

            .then(response => {

                this.record = response.data.data[0];

                this.permissionsTable = this.$refs[this._uid + '-permissions-table'];

                this.permissionsTable.noEditButtonFlag = true;

                this.permissionsTable.parentId = this.record.id;

                this.permissionsTable.tableOptions = {

                    emptyTable: this.record.code === 'SUPER' ? 'Supervisor has ALL permissions' : null,

                    drawCallback: (tableId, api) => {

                        let _this = this;

                        $("." + tableId + '-view-flag').off('click').on('click', function() {

                            _this.updatePermission($(this).attr('data-id'), 'viewFlag');

                        });

                        $("." + tableId + '-insert-flag').off('click').on('click', function() {

                            _this.updatePermission($(this).attr('data-id'), 'insertFlag');

                        });

                        $("." + tableId + '-change-flag').off('click').on('click', function() {

                            _this.updatePermission($(this).attr('data-id'), 'changeFlag');

                        });

                        $("." + tableId + '-delete-flag').off('click').on('click', function() {

                            _this.updatePermission($(this).attr('data-id'), 'deleteFlag');

                        });


                    },                

                };   

                this.initFormData();

            });

        },

        initNewRecord() {

            this.permissionsTableLoaded = false;

            this.activeTab = 'General';
            this.tabs[0].active = true;
            this.tabs[1].visible = false;
            this.tabs[1].active = false;

            this.record = {
                description: null,
                code: null,
            };

            this.initFormData();

            setTimeout(() => $('#' + this.id + ' textarea[name="description"]').focus() );

        },

        initFormData() {
                
            this.displayForm();

            setTimeout(() => $('#' + this.id + ' input[name="description"]').focus() );

        },

        updatePermission( id, column ) {

            axios.post('/permissions/store', {id: id, column: column})

            .then(response => {

                if (response.data.errors) {

                    if (response.data.errors.general) { showError( 'Error', response.data.errors.general[0]);} else { this.errors = response.data.errors; }

                }

            });

        },

        okClicked() {

            axios.post('/employee_groups/store', this.record)
            
            .then(response => {

                if (response.data.errors) {

                    if (response.data.errors.general) { showError( 'Error', response.data.errors.general[0]);} else { this.errors = response.data.errors; }

                } else {

                    this.errors = {};

                    this.highlightTableRow(response.data.id, response.data.code);

                }

            }).catch(error => { showError('Error saving ' + this.table.singular, error); });

        },

        highlightTableRow( id, code ) {

            axios.post('/employee_groups/getTablePosition', { code: code })

            .then(response => {

                this.table.jumpToRow(id, response.data);

                this.closeForm();

            });

        },     

        
    },
}
</script>
