<template>
    <div class="card h-100 border-0">
        <div class="card-header email-bg">
            <div class="d-flex justify-content-between">
                <h3><i class="fa fa-envelope-o mr-2"></i>Email</h3>
                <page-close-button @closeClicked="closeLeftPage(pageName)"/>
            </div>
        </div>

        <div id="email-left-body" class="card-body overflow-auto pb-1 pt-3 px-3">

            <div class="d-flex justify-content-between mb-1">

                <div class="form-group">
                    <input 
                        class="form-control search-input"
                        id="email-left-search-email-folder"
                        v-model="searchFor"
                        type="search"
                        placeholder="Search..."
                    >
                </div>


                <!-- <div class="form-group d-flex">
                    <div :class="searchFor ? 'input-group' : ''">
                        <input 
                            class="form-control search-input"
                            id="email-left-search-email-folder"
                            v-model="searchFor"
                            type="search"
                            placeholder="Search..."
                        >

                        <div v-if="searchFor" class="input-group-append">
                            <button
                                tabindex="-1"
                                @click="clearSearch"
                                type="button"
                                title="Clear the search"
                                class="btn btn-danger"
                            ><i class="fa fa-times"></i></button>
                        </div>

                    </div>

                </div> -->

                <div class="d-flex justify-content-between">

                    <div style="min-width: 12vw">
                        <select-email-folder
                            id="email-left-select-email-folder"
                            placeholder=""
                            :options="folders" 
                            v-model="selectedFolder"
                            :tabindex="-1"
                            :allow-empty="false"
                            :show-labels="false"
                        >
                        <template slot="noResult">Folder not found</template>
                        </select-email-folder>
                    </div>
                    <div class="ml-2 centercenter">
                        <img 
                            class="cp"
                            style="height:28px; margin-bottom: 7px;" 
                            src="/img/recycle.png"
                            title="Check for new messages"
                            @click="refreshFolder('')"
                        >
                    </div>

                </div>


            </div>

            <table :id="tableId" class="table bordered" style="table-layout: auto; width:100%"></table>

            <div v-if="numberOfPages > 1" class="mt-1 text-right">

                <span v-show="currentPage > 0" 
                title="Previous page"
                @click="previousPage">
                    <i class="fa fa-toggle-left fa-lg cp mr-1"></i>
                </span>

                <span>Showing {{pageStart}} - {{pageEnd}} of {{numberOfEmails}}</span>

                <span v-show="currentPage + 1 < numberOfPages" 
                title="Next page"
                @click="nextPage">
                    <i class="fa fa-toggle-right fa-lg cp ml-1"></i>
                </span>

            </div>

            <div v-else-if="numberOfEmails" class="mt-1 text-right">
                <span>Showing {{numberOfEmails}} of {{numberOfEmails}}</span>
            </div>

        </div>
    </div>
</template>     

<script>

import { mapGetters } from 'vuex';
import { mapMutations } from 'vuex';
import leftTemplate from "../left-template";
import Multiselect from 'vue-multiselect';

export default {

    extends: leftTemplate,

    components: {
        SelectEmailFolder: Multiselect,
    },

    data() {
        return {
            tableId: "email-left-email-table",
            pageName: "Email",
            searchFor: '',
            smtpDetails: {},
            params: null,
            folders: ['INBOX'],
            newFolderFlag: true,
            selectedFolder: 'INBOX',
            folderMailIds: [],
            pages: [],
            numberOfEmails: 0,
            numberOfPages: 0,
            currentPage: 0,
            pageSize: 50,
        };
    },

    computed: {

        ...mapGetters(['leftTabs', 'activeLeftTabs']),

        pageStart() {
            return this.currentPage ? 
            (this.currentPage * this.pageSize) + 1
            : 1;
        },

        pageEnd() {

            return this.pageStart + this.pageSize > this.numberOfEmails ?
            this.numberOfEmails :
            this.pageStart + this.pageSize - 1;
        }
    },

    watch: {

        searchFor(newValue) {

            this.table.search(newValue).draw();


        },


        selectedFolder(newValue) {

            this.refreshFolder(newValue);

        },


    },


    mounted() {

        let thisTab = this.leftTabs.filter(tab => tab.pageName === this.pageName);

        if (thisTab.length)  this.displayLeftTab(thisTab[0]);

        this.$root.emailLeftPage = this;

    },    

    methods: {

        ...mapMutations(['displayLeftTab','hideLeftTab']),

        initializePage() {

            this.loadDataTable( [], true );

            this.getEmailMessages()
            .then( (data) => {

                this.table.destroy();

                this.loadDataTable( data );

                this.getFolders();

            });

            let _this = this;

        },

        loadDataTable( emails, loadingFlag = false) {

            let _this = this;

            //Set the table Height manually
            let $thisBody = $('#email-left-body');
            let scrollY = (Math.round( $thisBody.outerHeight() ) - 135)  + 'px';

            this.table = $('#' + this.tableId).DataTable({
                destroy: true,
                dom: "t",
                data: emails,
                serverSide: false,
                paging: false,
                select: false,
                scrollX: true,
                responsive: false,
                scrollY: scrollY,
                scroller: false,
                scrollCollapse: false,
                rowId: "mailId",
                ordering: true,
                order: [[1, "desc"]],
                language: {
                    emptyTable: loadingFlag ? 
                    _this.currentPage ? "Fetching emails...Please wait" : "Loading " + _this.selectedFolder + " folder...Please wait" 
                    : "No emails found",
                },
                columnDefs: [
                    {
                        title: "Action",
                        data: null,
                        class: "text-center",
                        width: "20%",
                        orderable: false,
                        targets: 0,
                        render: function (data) {
                                return '<span class="badge badge-success action-button-badge" onclick="componentFunctionById(' + _this._uid + ',\'viewEmail\',' + data.mailId + ')"  title ="View this email message">View</span>';
                        }
                    },
                    {
                        title: "Date",
                        data: null,
                        width: "20%",
                        targets: 1,
                        render: function (data) {
                            return data.date ?
                            moment(data.date).format('YYYY-MM-DD HH:mm:ss')
                            : '';
                        }
                    },
                    {
                        title: "From",
                        data: null,
                        width: "20%",
                        targets: 2,
                        render: function (data) {
                            return data.from ? data.from : '';
                        }
                    },
                    {
                        title: "Subject",
                        data: null,
                        width: "20%",
                        targets: 3,
                        render: function (data) {
                            return data.subject ? data.subject : '';
                        }
                    },
                    {
                        title: "CC",
                        data: null,
                        width: "20%",
                        targets: 4,
                        render: function (data) {
                            return data.cc ? data.cc : '';
                        }
                    },
                    {
                        title: "Body",
                        data: null,
                        //width: "20%",
                        visible: false,
                        targets: 5,
                        render: function (data) {
                            return data.text ? data.text : '';
                        }
                    },

                ]
            });

        },

        refreshFolder( newFolder ) {

            this.clearForm();

            let refreshFolder = newFolder || this.selectedFolder;

            this.resetPaging();

            //this.newFolderFlag = newFolder ? true: false;
            this.newFolderFlag = true;

            this.refreshTable(refreshFolder);
        },

        refreshTable(folder) {

            root.$snotify.simple('Please Wait..', 'Fetching emails', { timeout: 0, icon: 'img/cogs.gif' });

            this.getEmailMessages(folder)

            .then( (data) => {

                root.$snotify.clear();

                this.table.destroy();

                this.loadDataTable( data );

            }).catch( () => { 

                root.$snotify.clear();

            });    

        },

        async getEmailMessages( folder = 'INBOX') {

            this.selectedFolder = folder;

            return new Promise(async (resolve, reject) => {

                this.params = {
                    incomingServer: this.$root.smtpDetails.incomingServer,
                    incomingPort: this.$root.smtpDetails.incomingPort,
                    incomingEncryption: this.$root.smtpDetails.incomingEncryption,
                    userName: this.$root.smtpDetails.smtpUserName,
                    password: this.$root.smtpDetails.smtpPassword,
                    folder: folder,
                    mailIds: this.folderMailIds,
                    currentPage: this.currentPage,
                    pageSize: this.pageSize,
                };

                //console.log('getEmailMessages this.params',this.params);

                axios.post('/mail/getMessages',this.params)

                .then(response => {

                    //root.$snotify.clear();

                    if (response.data.error) {

                        showError('Email Server Error',response.data.error);

                        reject();

                    } else {

                        if ( this.newFolderFlag ) {

                            this.newFolderFlag = false;

                            this.folderMailIds = response.data.folderMailIds;

                            this.numberOfEmails = this.folderMailIds.length;

                            if ( this.numberOfEmails ) {

                                this.numberOfPages = Math.ceil(this.numberOfEmails/this.pageSize);

                            } else {

                                this.numberOfPages = 0

                            }

                        }

                        //console.log('numberOfEmails',this.numberOfEmails);
                        //console.log('numberOfPages',this.numberOfPages);

                        resolve(response.data.emails);

                    }

                }).catch(error => { reject(); showError('Error Reading Email', error); });    

            });

        },

        async viewEmail(id) {

            this.highlightRow(id);

            let data = this.table.row( '#' + id ).data();

            let thisForm = root.$refs['pages'].$refs["right-page"].$refs['email-form'];

            let params = {...this.params, id: id, folder: this.selectedFolder};

            thisForm.showEmailMessage(data, params);

        },

        getFolders() {

            let params = {
                incomingServer: this.$root.smtpDetails.incomingServer,
                incomingPort: this.$root.smtpDetails.incomingPort,
                incomingEncryption: this.$root.smtpDetails.incomingEncryption,
                userName: this.$root.smtpDetails.smtpUserName,
                password: this.$root.smtpDetails.smtpPassword,
            }

            axios.post('/mail/getFolders',params)
            .then(response => {

                if (response.data.error) {

                    showError('Email Server Error','<p>An error was encountered getting the Mailbox folders.</p><p>' + response.data.error + '</p>');

                } else {

                    this.folders = response.data.folders;

                }

            }).catch(error => { reject(); showError('Error Getting Folders', error); });

        },

        resetPaging() {

            this.newFolderFlag = true;
            this.folderMailIds = [];
            this.pages = [];
            this.numberOfEmails = 0;
            this.numberOfPages = 0;
            this.currentPage = 0;
            this.pageSize = 50;

        },

        clearForm() {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].clearPages();

        },

        previousPage() {

            this.currentPage--;

            this.clearForm();

            this.refreshTable(this.selectedFolder);

        },

        nextPage() {

            this.currentPage++;

            this.clearForm();

            this.refreshTable(this.selectedFolder);

        },

        highlightRow(id) {

            if ( $('#' + this.tableId).length === 0 ) return; // In case the global form has a table set by SelectMatter for example

            this.unHighlightAllRows();

            $('#' + this.tableId + ' tbody tr#' + id).addClass('highlighted');

        },
        
        unHighlightAllRows() {

            if ( $('#' + this.tableId).length === 0 ) return; // In case the global form has a table set by SelectMatter for example

            $('#' + this.tableId + ' tbody tr.highlighted').removeClass('highlighted');
        
        },

    },
}
</script>