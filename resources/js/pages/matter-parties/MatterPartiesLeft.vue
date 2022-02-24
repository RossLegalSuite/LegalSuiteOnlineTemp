<template>
    <div class="card h-100 border-0">
        <div class="card-header matter-parties-bg">
            <div class="d-flex justify-content-between">
                <h3><i class="fa fa-user mr-2"></i>Parties who play a Role on a Matter</h3>
                <page-close-button @closeClicked="closeLeftPage(pageName)"/>
            </div>
        </div>

        <div id="matter-party-left-body" class="card-body overflow-auto pb-0 pt-3 px-3">

            <matter-parties-table
                :lazy-load-flag="true"
                :tagging="true"
                parentType="General"
                form-ref="matter-party-form" 
                ref="matter-parties-table" 
                tableId="matter-parties-table"
                :newRecordButton="false"
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
        MatterPartiesTable: () => import("./MatterPartiesTable"),
    },

    data() {
        return {
            pageName: "MatterParties",
            selectedRows: [],
            selectedAllFlag: false,
            tableMounted: false,
            selectedMatter: {},
            generateDocumentsFlag: true,
            generateDocumentsSource: 'MatParty',
            generateDocumentsPlural: 'Parties',
        };
    },

    computed: {
        ...mapGetters(['leftTabs', 'activeLeftTabs', 'currentMatter']),
    },

    watch: {

        tableMounted() { this.initializeTable(); },

    },

    activated() {

        if ( $('#matter-parties-table').length ) {

            let scrollTop = $('#matter-parties-table' + '_wrapper .dataTables_scrollBody').offset().top;
            let tableTop = $('#matter-parties-table').offset().top;

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

            //this.table.initialOrder = [[1, "asc"]];

            this.table.tableOptions = { tableBottom: 80 }; 

            // Used to lazy load the Form (and all its sub components) on the right
            this.table.loadDataTable(() =>{
                this.$root.matterPartiesLeftTableLoaded = true;
            });

        },

        newRecordButtonClicked() {

            let thisForm = root.$refs['pages'].$refs["right-page"].$refs['matter-party-form'];

            thisForm.insertClicked();

        },

        emailThisRecord(id) {

            emailThisMatParty(id); // This is in common.js

        },

        emailRecords() {

            root.$snotify.simple('Please wait...', 'Generating Emails', { timeout: 0, icon: 'img/cogs.gif' });

            root.emailModal.initialize();
            root.emailModal.defaultAttachmentFlag = false;
            root.emailModal.mailMergeFlag = true;
            root.emailModal.mailMergePlural = 'Matter Parties';
            root.emailModal.callingComponent = this;

            root.emailModal.mailMergeEmails = [];

            axios.post('/lolsystemtemplate/get/' + root.lolSettings.matpartiesemailtemplateid)

            .then(templateResponse => {

                if ( templateResponse.data.errors ) {

                    showError('Error',templateResponse.data.errors);

                } else {

                    root.emailModal.templateRecord = this.templateRecord = templateResponse.data.data[0];

                    let params = ( this.selectedRows.length ) ? { whereIn: 'MatParty.recordid,' + this.selectedRows.join()  } :  {tableFilter: this.table.tableFilter};

                    axios.post('/matparty/get', {...params, select: ['MatParty.RecordID','MatParty.PartyID','MatParty.MatterID']})

                    .then(async response => {

                        if (response.data.errors) { 

                            showError('Error getting Matter Parties', response.data.errors); 

                        } else {

                            await root.asyncForEach(response.data.data, async (matParty) => {   

                                var partyResponse = await axios.post('/party/get/' + matParty.partyid,{select: ['Party.RecordId as recordid', 'Email.Number as emailaddress']});

                                if ( partyResponse.data.errors ) {

                                    showError('Error',partyResponse.data.errors);

                                } else {

                                    var party = partyResponse.data.data[0];

                                    if ( party.emailaddress ) {

                                        root.emailModal.mailMergeEmails.push(party.emailaddress);

                                        root.emailModal.multipleRecipients.push({
                                            value: matParty.recordid,
                                            label: party.emailaddress + ' (' + matParty.recordid + ')',
                                        });

                                    }

                                }

                            });

                            root.$snotify.clear();

                            if (root.emailModal.mailMergeEmails.length) {

                                let firstMatParty = response.data.data[0];

                                root.emailModal.selectedRecipient = root.emailModal.multipleRecipients[0];

                                root.emailModal.mailMergeManyFlag = root.emailModal.mailMergeEmails.length > 15 ? true : false;

                                if (root.emailModal.mailMergeEmails.length > 1 ) {

                                    root.emailModal.title = 'Email Selected Matter Parties (' + root.emailModal.mailMergeEmails.length + ')';

                                    root.emailModal.subject = this.templateRecord.subject;

                                    root.emailModal.mailMergeSelectedDescription = 'Selected Matter Parties (' + root.emailModal.mailMergeEmails.length + ')';

                                    root.emailModal.templateContents = this.templateRecord.contents;

                                    root.createRecordTemplateData('matparty',this.templateRecord, firstMatParty.recordid)

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

                                    this.emailThisRecord(firstMatParty.recordid);

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

                console.log("A generateEmails emailParams",emailParams);

                let abortProcess = false;
                let emailCounter = 0;

                root.$snotify.simple('Selected Matter Parties', 'Preparing emails', { timeout: 0, icon: 'img/cogs.gif' });

                let emailComponentTemplate = emailParams.body;

                let tableParams = ( this.selectedRows.length ) ? { whereIn: 'matparty.recordid,' + this.selectedRows.join()  } :  {tableFilter: this.table.tableFilter};

                axios.post('/matparty/get', tableParams)

                .then(async response => {

                    if (response.data.errors) { 

                        showError('Error getting Matter Parties', response.data.errors); 

                    } else {

                        await root.asyncForEach( response.data.data, async (matParty) => { 

                            var partyResponse = await axios.post('/party/get/' + matParty.partyid,{select: ['Party.RecordId as recordid','Party.Name as name','Email.Number as emailaddress']});

                            if ( partyResponse.data.errors ) {

                                showError('Error',partyResponse.data.errors);

                            } else {

                                var party = partyResponse.data.data[0];

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

                                    emailCounter++;

                                    emailParams.to = [party.emailaddress];
                                    emailParams.body = '';

                                    await root.createRecordTemplateData(this.generateDocumentsSource.toLowerCase(), this.templateRecord, matParty.recordid,)

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
                                                showError('Emailing Matter Parties Error','Unable to generate template contents');

                                            });

                                        }).catch(error => { 

                                            abortProcess = true;
                                            showError('Emailing Matter Parties Error','Unable to generate subject contents');

                                        });  

                                    }).catch( (error) => {

                                        abortProcess = true;
                                        showError('Matter Parties Template Error',error);

                                    });

                                }
                            }

                        });


                        if ( !abortProcess ) {

                            setTimeout(() => {
                                $('.snotify-simple .snotifyToast__title').text('Completed');
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