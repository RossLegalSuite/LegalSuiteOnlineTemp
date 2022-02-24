<template>
    <div class="card h-100 border-0">
        <div class="card-header parties-bg">
            <div class="d-flex justify-content-between">
                <h3><i class="fa fa-address-book mr-2"></i>Address Book</h3>
                <page-close-button @closeClicked="closeLeftPage(pageName)"/>
            </div>
        </div>

        <div class="card-body overflow-auto pb-1 pt-3 px-3">

            <party-table 
                ref="parties-table"
                :lazyLoadFlag="true"
                :tagging="true" 
                formRef="party-right-party-form" 
                tableId="parties-table"
            />
            
        </div>

    </div>
</template>     

<script>

import { mapGetters } from 'vuex';
import { mapMutations } from 'vuex';
import leftTemplate from "../left-template";

export default {

    extends: leftTemplate,

    components: {
        PartyTable: () => import("./PartyTable"),
    },

    data() {
        return {
            tableMounted: false,
            form: null,
            pageName: "Parties",
            selectedRows: [],
            selectedAllFlag: false,
            generateDocumentsFlag: true,
            generateDocumentsSource: 'Party',
            generateDocumentsPlural: 'Parties',
        };
    },

    computed: {
        ...mapGetters(['leftTabs','activeLeftTabs']),
    },

    watch: {
        tableMounted: function() { this.initializeTable(); },
    },

    activated() {

        // Fixing bug between Vue keep-alive functionality and DataTables
        // The activated event in Vue means keep-alive has re-activated the component
        // If the user has scrolled the table - DataTables scroller sets the absolute position of the table
        // But if the user goes to another Tab and then back to this Tab, the table looks blank because 
        // the Scroller's absolute position is still there (and the table is now out of the view port)
        // The simplest solution is to compare the top positions (to see if the user has scrolled)
        // and, if so, reload the table (which sorts everything out)
        // This code needs to be on any Left Page that has a table

        if ( $('#parties-table').length ) {

            let scrollTop = $('#parties-table' + '_wrapper .dataTables_scrollBody').offset().top;
            let tableTop = $('#parties-table').offset().top;

            if ( tableTop > scrollTop ) this.table.table.ajax.reload();

        }
    },

    mounted() {

        let thisTab = this.leftTabs.filter(tab => tab.pageName === this.pageName);

        if (thisTab.length)  this.displayLeftTab(thisTab[0]);

    },    

    methods: {

        ...mapMutations(['displayLeftTab','hideLeftTab']),

        initializeTable() {

            this.table.tableOptions = { tableBottom: 80 }; // Space for the footer
            
            this.table.loadDataTable(() =>{

                // Used to lazy load the Form (and all its sub components) on the right
                this.$root.partyLeftTableLoaded = true;

            });

        },

        newRecordButtonClicked() {

            this.form = root.$refs['pages'].$refs["right-page"].$refs['party-right-party-form'];

            //Matters - Desktop - File Notes - Update
            //Browse - Address Book
            if ( !this.form.permission('Insert') ) return;

            this.form.insertClicked();

            this.loadPage('Form');

        },

        emailThisRecord(id) {

            emailThisParty(id, true); // This is in common.js

        },

        emailRecords() {

            root.emailModal.initialize();
            root.emailModal.defaultAttachmentFlag = false;
            root.emailModal.mailMergeFlag = true;
            root.emailModal.mailMergePlural = 'Parties';
            root.emailModal.callingComponent = this;


            axios.post('/lolsystemtemplate/get/' + root.lolSettings.partiesemailtemplateid)

            .then(templateResponse => {

                if ( templateResponse.data.errors ) {

                    showError('Error',templateResponse.data.errors);

                } else {

                    root.emailModal.templateRecord = this.templateRecord = templateResponse.data.data[0];

                    let params = ( this.selectedRows.length ) ? { whereIn: 'party.recordid,' + this.selectedRows.join()  } :  {tableFilter: this.table.tableFilter};

                    params = {...params, select: ['Party.RecordId as recordid', 'Party.MatterPrefix as matterprefix', 'Email.Number as emailaddress']};

                    axios.post('/party/get', params)

                    .then(response => {

                        if (response.data.errors) { 

                            showError('Error getting Parties', response.data.errors); 

                        } else {

                            root.emailModal.mailMergeEmails = [];

                            response.data.data.forEach(party => {

                                if ( party.emailaddress ) {

                                    root.emailModal.mailMergeEmails.push(party.emailaddress);

                                    root.emailModal.multipleRecipients.push({
                                        value: party.recordid,
                                        label: party.emailaddress + ' (' + party.matterprefix + ')',
                                    });

                                }

                            });

                            if (root.emailModal.mailMergeEmails.length) {

                                let firstParty = response.data.data[0];

                                root.emailModal.selectedRecipient = root.emailModal.multipleRecipients[0];

                                root.emailModal.mailMergeManyFlag = root.emailModal.mailMergeEmails.length > 15 ? true : false;

                                if (root.emailModal.mailMergeEmails.length > 1 ) {

                                    root.emailModal.title = 'Email Selected Parties (' + root.emailModal.mailMergeEmails.length + ')';

                                    root.emailModal.subject = this.templateRecord.subject;

                                    root.emailModal.mailMergeSelectedDescription = 'Selected Parties (' + root.emailModal.mailMergeEmails.length + ')';

                                    root.emailModal.templateContents = this.templateRecord.contents;

                                    root.createRecordTemplateData('party',this.templateRecord, firstParty.recordid)

                                    .then( (templateData) => {

                                        root.emailModal.templateData = templateData;

                                        root.emailModal.show();

                                        root.emailModal.generateEmailBody();

                                        setTimeout(() => {

                                            $('#' + root.emailModal.id + ' input[name="subject"]').focus();

                                        });

                                    }).catch( (error) => {

                                        showError('Error',error);

                                    });

                                } else {

                                    //root.emailModal.mailMergeSelectedDescription = firstParty.emailaddress;
                                    this.emailThisRecord(firstParty.recordid);

                                }

                            } else {

                                showError('No Email Addresses were found','None of the Parties selected have <em>default</em> email addresses');
                            }
                        }

                    }).catch(error => {
                        showError('Error', error); 
                    });
                }
            }).catch( (error) => {

                showError('Error',error);

            });

        },

        generateEmails( emailParams ) {

            try {

                let abortProcess = false;
                let emailCounter = 0;

                root.$snotify.simple('Selected Parties', 'Preparing emails', { timeout: 0, icon: 'img/cogs.gif' });

                let emailComponentTemplate = emailParams.body;

                let tableParams = ( this.selectedRows.length ) ? { whereIn: 'party.recordid,' + this.selectedRows.join()  } :  {tableFilter: this.table.tableFilter};

                tableParams = {...tableParams, select: ['Party.RecordId as recordid', 'Party.Name as name', 'Email.Number as emailaddress']};

                axios.post('/party/get', tableParams)

                .then(async response => {

                    if (response.data.errors) { 

                        showError('Error getting Email Addresses', response.data.errors); 

                    } else {

                        await root.asyncForEach( response.data.data, async (party) => { 

                            if ( party.emailaddress && !abortProcess ) {

                                //debugger;

                                // *****************************************************
                                // Add this back later - when other code is working
                                // *****************************************************
                                // let extraScreens = await axios.post('/extra_screens/getPartyMergeFields', {
                                //     parentId: party.recordid,
                                //     dataFormat: 'array'
                                // });

                                // extraScreens.data.forEach(extraScreen => {
                                //     if ( typeof partyData[extraScreen.prefix] === 'undefined') {
                                //         party[extraScreen.prefix] = {};
                                //     }
                                //     party[extraScreen.prefix][toCamelCase(extraScreen.label)] = extraScreen.value;
                                // });

                                emailParams.to = [party.emailaddress];
                                emailParams.body = '';

                                emailCounter++;

                                root.createRecordTemplateData(this.generateDocumentsSource.toLowerCase(), this.templateRecord, party.recordid)

                                .then( async (templateData) => {

                                    await root.vueRender( this.templateRecord.subject, templateData )

                                    .then( async (renderedHtml) => {

                                        emailParams.subject = renderedHtml;

                                        await root.vueRender( emailComponentTemplate, templateData )

                                        .then( (renderedContents) => {

                                            setTimeout(() => {
                                                $('.snotify-simple .snotifyToast__title').text('Sending Email To');
                                                $('.snotify-simple .snotifyToast__body').text(party.name + ' ' + party.emailaddress);
                                            },10);

                                            emailParams.body = renderedContents;

                                            axios.post('/mail/sendEmail',emailParams)

                                            .then(response => {

                                                if (response.data.error) {

                                                    root.$snotify.error(response.data.error + ' - Email: ' + emailParams.to,'Error sending Email',
                                                    {
                                                        timeout: 3000,
                                                        position: 'centerCenter',
                                                        showProgressBar: true,
                                                    });

                                                }

                                            });

                                        }).catch( () => {

                                            abortProcess = true;
                                            showError('Emailing Parties Error','Unable to generate template contents');

                                        });

                                    }).catch(error => { 

                                        abortProcess = true;
                                        showError('Emailing Parties Error','Unable to generate subject contents');

                                    });  

                                }).catch( (error) => {

                                    abortProcess = true;
                                    showError('Parties Template Error',error);

                                });

                            }

                        });

                        if ( !abortProcess ) {

                            setTimeout(() => {
                                $('.snotify-simple .snotifyToast__body').text('Completed');
                                $('.snotify-simple .snotifyToast__body').text(emailCounter + (emailCounter > 1 ? ' emails sent': ' emails sent'));
                            },500);

                            setTimeout(() => { root.$snotify.clear(); }, 3000);

                        }

                    }

                }).catch(error => { 

                    console.log('Error getting Parties',error);

                });

            } catch (error) {

                showError('Error Sending emails',error);

            };


        },

    },
}
</script>