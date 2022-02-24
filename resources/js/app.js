import VueAxios from "vue-axios";
import axios from "axios";
import VueRouter from 'vue-router';
import Vuex from 'vuex';

window.compiler = require('vue-template-compiler');

//https://artemsky.github.io/vue-snotify/documentation/index.html
import Snotify from 'vue-snotify';
import 'vue-snotify/styles/material.css';


import "jquery-ui/ui/widgets/draggable.js"; // To drag modals
import 'jquery-ui/themes/base/draggable.css';

import "jquery-ui/ui/tabbable.js"; // Needed for tabGuard

//JQueryUI Sorting
import "jquery-ui/ui/widget.js"; 
import "jquery-ui/ui/data.js"; 
import "jquery-ui/ui/scroll-parent.js"; 
import "jquery-ui/ui/widgets/sortable.js";
import "jquery-ui/ui/widgets/mouse.js";
import 'jquery-ui/themes/base/sortable.css';

// JQueryUI Resizing
//import "jquery-ui/ui/widget.js"; 
//import "jquery-ui/ui/widgets/mouse.js"; 
import "jquery-ui/ui/disable-selection.js"; 
import "jquery-ui/ui/widgets/resizable.js"; 

//import 'jquery-ui/themes/base/all.css';
import 'jquery-ui/themes/base/core.css';
import 'jquery-ui/themes/base/resizable.css';
//import 'jquery-ui/themes/resizable.css';

// import {ContextMenu, ContextMenuItemTypes} from 'jquery-contextmenu';
// window.contextMenu = new ContextMenu();


// https://docxtemplater.readthedocs.io/en/latest/faq.html#docxtemplater-in-a-vuejs-project
window.Docxtemplater = require("docxtemplater");
window.PizZip = require("pizzip");
window.PizZipUtils = require("pizzip/utils/index.js");
window.InspectModule = require("docxtemplater/js/inspect-module");
//window.FileSaver = require('file-saver'); //*****************REMOVE from package.json  */

//https://docxtemplater.readthedocs.io/en/latest/angular_parse.html
window.expressions = require('angular-expressions');
window.assign = require("lodash/assign");

// Define your filter functions here, for example, to be able to write {clientname | lower}
expressions.filters.lower = function(input) {
    if(!input) return input;
    return input.toLowerCase();
}
expressions.filters.upper = function(input) {
    if(!input) return input;
    return input.toUpperCase();
}
expressions.filters.formatCurrency = function(input) {
    if(!input) return input;
    return root.control.currencySymbol + ' ' + input;
}
expressions.filters.capitalize = function(input) {
    if(!input) return input;
    return input.charAt(0).toUpperCase() + input.slice(1).toLowerCase();
}

//Required for the Excel HTML5 export button - Deprecate and remove from package.json
window.JSZip = require("jszip");

// ColorPicker: https://huebee.buzz/
// window.Huebee = require('huebee');
// import "huebee/dist/huebee.min.css";

require("datatables.net-bs4");
require("datatables.net-scroller-bs4");
require("datatables.net-select-bs4");

window.moment = require("moment");

window.Vue = require("vue");

Vue.use(VueRouter, VueAxios, axios);

Vue.use(Vuex);

//https://mattzollinhofer.github.io/vue-typeahead-bootstrap-docs/guide/gettingStarted.html#installation
//import VueTypeaheadBootstrap from 'vue-typeahead-bootstrap';
//Vue.component('vue-typeahead', VueTypeaheadBootstrap)


import vSelect from 'vue-select';

// https://vue-select.org/guide/components.html#setting-globally-at-registration 
vSelect.props.components.default = () => ({
    Deselect: {
        render: createElement => createElement('span', '❌'),
    },
    OpenIndicator: {
        render: createElement => createElement('span', '🔽'),
    },
});


Vue.component('v-select', vSelect);
import 'vue-select/dist/vue-select.css';
import 'vue-multiselect/dist/vue-multiselect.min.css';

//https://vue-select.org/guide/positioning.html#popper-js-integration
import { createPopper } from '@popperjs/core';


// https://getdatepicker.com/4/Options/
import datePicker from 'vue-bootstrap-datetimepicker';
import 'pc-bootstrap4-datetimepicker/build/css/bootstrap-datetimepicker.css';
Vue.use(datePicker);

import {  
    FormInputPlugin, 
    DropdownPlugin,
    FormCheckboxPlugin,
    FormRadioPlugin,
    FormGroupPlugin,
    FormSelectPlugin,
} from 'bootstrap-vue';


Vue.use(FormInputPlugin);
Vue.use(DropdownPlugin);
Vue.use(FormCheckboxPlugin);
Vue.use(FormRadioPlugin);
Vue.use(FormGroupPlugin);
Vue.use(FormSelectPlugin)

const leftTabs = [
    {
        pageName: 'Home',
        title: 'Home',
        routeName: 'home',
        class: 'home-bg',
        icon: 'fa-home',
    },
    {
        pageName: 'Welcome',
        title: 'Home',
        routeName: 'guest',
        class: 'home-bg',
        icon: 'fa-home',
    },
    {
        pageName: 'Matters',
        title: 'Matters',
        routeName: 'matters',
        class: 'matters-bg',
        icon: 'fa-briefcase',
    },
    {
        pageName: 'Parties',
        title: 'Address Book',
        routeName: 'parties',
        class: 'parties-bg',
        icon: 'fa-address-book',
    },

    {
        pageName: 'MatterParties',
        title: 'Parties',
        routeName: 'matter-parties',
        class: 'matter-parties-bg',
        icon: 'fa-user',
    },


    {
        pageName: 'Email',
        title: 'Email',
        routeName: 'email',
        class: 'email-bg',
        icon: 'fa-envelope-o',
    },
    {
        pageName: 'Employees',
        title: 'Employees',
        routeName: 'employees',
        class: 'employees-bg',
        icon: 'fa-id-badge',
    },
    {
        pageName: 'FeeNotes',
        title: 'Fee Notes',
        routeName: 'feenotes',
        class: 'feenotes-bg',
        icon: 'fa-money',
    },
    {
        pageName: 'FileNotes',
        title: 'File Notes',
        routeName: 'filenotes',
        class: 'filenotes-bg',
        icon: 'fa-edit',
    },
    {
        pageName: 'DocLog',
        title: 'Document Log',
        routeName: 'doclog',
        class: 'doclog-bg',
        icon: 'fa-envelope-o',
    },
    {
        pageName: 'Documents',
        title: 'Documents',
        routeName: 'documents',
        class: 'documents-bg',
        icon: 'fa-cog',
    },
    {
        pageName: 'Reminders',
        title: 'Reminders',
        routeName: 'reminders',
        class: 'reminders-bg',
        icon: 'fa-calendar-check-o',
    },
    {
        pageName: 'Document Sets',
        title: 'Document Sets',
        routeName: 'documentSets',
        class: 'document-sets-bg',
        icon: 'fa-clone',
    },
    {
        pageName: 'Fee Sheets',
        title: 'Fee Sheets',
        routeName: 'feeSheets',
        class: 'fee-sheets-bg',
        icon: 'fa-server',
    },
    {
        pageName: 'Fee Codes',
        title: 'Fee Codes',
        routeName: 'feeCodes',
        class: 'fee-codes-bg',
        icon: 'fa-server',
    },
    {
        pageName: 'Extra Screens',
        title: 'Extra Screens',
        routeName: 'extraScreens',
        class: 'components-bg',
        icon: 'fa-server',
    },
    {
        pageName: 'Reports',
        title: 'Reports',
        routeName: 'reports',
        class: 'reports-bg',
        icon: 'fa-print',
    },
    {
        pageName: 'Settings',
        title: 'Settings',
        routeName: 'settings',
        class: 'settings-bg',
        icon: 'fa-cog',
    },


];

//See: https://alligator.io/vuejs/intro-to-vuex/
const store = new Vuex.Store({

    state: {

        currentMatter: {
            recordid: null,
            fileref: null,
            description: null,
            employeeid: null,
            costcentreid: null,
            vatexemptflag: null,
            interestrate: null,
            feesheetid: null,
            debtorcollcommoption: null,
            stagegroupid: null,
        },
        currentParty: {
            recordid: null,
            code: null,
            name: null,
        },
        currentColData: {
            matterid: null,
            emofirstdate: null,
            emoamount: null,
            emocommissionpercent: null,
        },
        currentEmployee: {
            id: null,
            name: null,
            email: null,
        },
        activeLeftTabs: loggedIn ? [leftTabs[0]] : [leftTabs[1]],
        leftTabs: leftTabs,

    },

    getters: {

        activeLeftTabs: state => state.activeLeftTabs,
        leftTabs: state => state.leftTabs,
        currentMatter: state => state.currentMatter,
        currentColData: state => state.currentColData,
        currentEmployee: state => state.currentEmployee,
        currentParty: state => state.currentParty,

    },
    
    mutations: {

        setCurrentMatter(state, currentMatter) {
            state.currentMatter.recordid = currentMatter.recordid;
            state.currentMatter.fileref = currentMatter.fileref;
            state.currentMatter.description = currentMatter.description;
            state.currentMatter.employeeid = currentMatter.employeeid;
            state.currentMatter.costcentreid = currentMatter.costcentreid;
            state.currentMatter.vatexemptflag = currentMatter.vatexemptflag;
            state.currentMatter.interestrate = currentMatter.interestrate;
            state.currentMatter.feesheetid = currentMatter.feesheetid;
            state.currentMatter.stagegroupid = currentMatter.stagegroupid;
            state.currentMatter.debtorcollcommoption = currentMatter.debtorcollcommoption;
        },

        setCurrentColData(state, currentColData) {
            state.currentColData.matterid = currentColData.matterid;
            state.currentColData.emofirstdate = currentColData.emofirstdate;
            state.currentColData.emoamount = currentColData.emoamount;
            state.currentColData.emocommissionpercent = currentColData.emocommissionpercent;
        },

        setCurrentEmployee(state, currentEmployee) {
            state.currentEmployee.recordid = currentEmployee.recordid;
            state.currentEmployee.name = currentEmployee.name;
            state.currentEmployee.email = currentEmployee.email;
        },
        
        setCurrentParty(state, currentParty) {
            state.currentParty.recordid = currentParty.recordid;
            state.currentParty.code = currentParty.code;
            state.currentParty.name = currentParty.name;
        },
        

        displayLeftTab(state, thisTab) {

            let foundTab = state.activeLeftTabs.filter(tab => tab.title == thisTab.title);

            if ( !foundTab.length ) {

                state.activeLeftTabs.push({
                    pageName: thisTab.pageName,
                    title: thisTab.title,
                    routeName: thisTab.routeName,
                    class: thisTab.class,
                    icon: thisTab.icon,
                });
            }

        },

        hideLeftTab(state, pageName) {

            let thisIndex = state.activeLeftTabs.findIndex( leftTab => leftTab.pageName === pageName);
            state.activeLeftTabs.splice(thisIndex,1);

        },

        hideOtherTabs(state, pageName) {

            let thisIndex = state.activeLeftTabs.findIndex( leftTab => leftTab.pageName === pageName);

            if ( thisIndex > -1 ) {
                let homeTab = state.activeLeftTabs[0];
                let thisTab = state.activeLeftTabs[thisIndex];
                state.activeLeftTabs = [homeTab,thisTab];
            }

        },

        hideAllTabs(state) {

            state.activeLeftTabs.splice(1);

        },

    }    

});

Vue.use(Snotify, {
    toast: {
        titleMaxLength: 100,
        bodyMaxLength: 300,
        timeout: 2000,
        showProgressBar: false,
        position: "centerCenter",
    }
});

Vue.config.productionTip = false;
//Vue.config.devtools = false; // Removes "Download the Vue Devtools extension for a better development experience" from the console
//Vue.config.performance = true; //See: https://vuejs.org/v2/api/#performance

require('./bootstrap');

//require("../../node_modules/bootstrap-select/dist/js/bootstrap-select");
require("bootstrap-select/dist/js/bootstrap-select");
import "bootstrap-select/dist/css/bootstrap-select.css";

import routes from './routes';

const router = new VueRouter(routes);

let download = require('./download');   

// Disable the browser's right-click menu
$(document).bind('contextmenu', function () { return false;	});

if ( !loggedIn ) {

    let files = require.context("./components/forms", true, /\.vue$/i);

    files.keys().map(key =>
        Vue.component(key.split("/").pop().split(".")[0],files(key).default)
    );    


    files = require.context("./components/layout", true, /\.vue$/i);

    files.keys().map(key =>
        Vue.component(key.split("/").pop().split(".")[0],files(key).default)
    );    


    window.root = new Vue({
        el: '#app',
        router,
        store,

        mounted() {
            console.clear();
        },

    });    

} else {

    const files = require.context("./components", true, /\.vue$/i);
    
    files.keys().map(key =>
        Vue.component(key.split("/").pop().split(".")[0],files(key).default)
        );    

        axios.post('/lolsettings/get')
        .then(lolSettings => {

            axios.post("/control/get/1")
            .then(control => {

                axios.get("/utils/initializeData").then(session => {

                    if ( session.data.errors ) {

                        showError('Error Initializing Program Data', session.data.errors);

                    } else {

                        window.root = new Vue({
                            el: '#app',
                            router,
                            store,
                            data() {
                                return {
                                    matterLeftTableLoaded: false,
                                    partyLeftTableLoaded: false,
                                    matterPartiesLeftTableLoaded: false,
                                    employeeLeftTableLoaded: false,
                                    feeNoteLeftTableLoaded: false,
                                    doclogLeftTableLoaded: false,
                                    fileNoteLeftTableLoaded: false,
                                    reminderLeftTableLoaded: false,
                                    correspondenceLeftTableLoaded: false,
                                    generatedComponent: null,
                                    control: {},
                                    lolSettings: {},
                                    global: {},
                                    holidays: [],
                                    currentEmployee: {},
                                    supervisorFlag: false,
                                    errorTextColor: '#222',
                                    errorBackgroundColor: '#FAA',
                                    supervisorGroupId: null,
                                    dropdownIsLoading: false,
                                    matters: [],
                                    parties: [],
                                    employees:[],
                                    doclogCategories:[],
                                    doclogSubCategories:[],
                                    employeeRoles:[],
                                    planOfActions:[],
                                    stageGroups:[],
                                    stages:[],
                                    billingRates:[],
                                    accounts:[],
                                    businessBankAccounts: [],
                                    trustBankAccounts: [],
                                    business: [],
                                    incomeAccounts: [],
                                    expenseAccounts: [],
                                    revenueStampAccounts: [],
                                    creditors:[],
                                    costCentres:[],
                                    extraScreens:[],
                                    matterExtraScreens:[],
                                    causeOfActions:[],
                                    languages:[],
                                    branches:[],
                                    vatRates:[],
                                    feeSheets:[],
                                    feeCodes:[],
                                    feeUnits:[],
                                    documentSets:[],
                                    matterTypes:[],
                                    deedsOffices:[],
                                    partyEntities:[],
                                    partyTypes:[],
                                    partyRoles:[],
                                    telephoneTypes:[],
                                    countries:[],
                                    refreshTables: [],
            
                                    accountCategories: [ 'Assets',  'Liabilities', 'Equity', 'Revenue', 'Expenses' ],
                                    accountTypes: ['Business Bank','Trust Bank','Current Asset','Fixed Asset','Inventory','Current Liability','Long Term Liability','Equity','Direct Costs','Expense','Revenue'],
                                    debitCategories: [ 'Assets',  'Expenses' ],
                                    creditCategories: [ 'Liabilities', 'Equity', 'Revenue' ],
                                    assetTypes: ['Business Bank', 'Trust Bank', 'Current Asset',  'Fixed Asset'],
                                    liabilityTypes: ['Current Liability', 'Long Term Liability' ],
                                    paymentMethods: ['EFT', 'Credit Card', 'Direct Deposit', 'Cash', 'Debit Card', 'Cheque', 'Money Transfer', 'Other' ],
                                    batchTypes: ['Journal', 'Bill', 'Disbursement', 'Invoice', 'Transfer', 'Payment', 'Receipt' ],
                                    templateSources: ['Party', 'Matter', 'MatParty', 'Report'],
                                    templateTypes: ['Email', 'Document', 'Report'],
                                    
                                    templateData: {},

                                    documentTemplateSources: ['General', 'Employees', 'Matters', 'Parties', 'Party Roles'],
                                    documentReportSources: ['Employees', 'Matters', 'Parties', 'Party Roles'],
                                    reportDataSources: ['General', 'Accounts', 'Employees', 'Matters', 'Parties', 'Party Roles'],
                                    //correspondenceTypes: ['Document', 'Email', 'Image', 'Video', 'Audio', 'SMS', 'Other'],
                                    //correspondenceTypesArray: [{ text: 'Document', value: 'Document'}, { text: 'Email', value: 'Email'}, { text: 'Image', value: 'Image'}, { text: 'Video', value: 'Video'}, { text: 'Audio', value: 'Audio'}, { text: 'SMS', value: 'SMS'}, { text: 'Other', value: 'Other'}],
                                    documentTemplateTypesArray: [{text: 'General', value: 'General'},  {text: 'Matters', value: 'Matters'},  {text: 'Parties', value: 'Parties'},  {text: 'Party Roles', value: 'Party Roles'},  {text: 'Employees', value: 'Employees'}],
                                    extraScreenTypesArray: [{text: 'All Matters', value: 'Matter'}, {text: 'All Parties', value: 'Party'},{text: 'Matter Type', value: 'Matter Type'},{text: 'Document Set', value: 'Document Set'},{text: 'Party Entity', value: 'Party Entity'},{text: 'Party Type', value: 'Party Type'},{text: 'Party Role', value: 'Party Role'} ],
                                };
                            },

                            computed: {
            
                                screenNarrow() {
                                    return window.innerWidth < 1600 ? true : false;
                                },
                        
                            },

                            created() {

                                this.todaysdate = convertToClarionDate(moment().format('DD MM YYYY'));

                                this.lolSettings = lolSettings.data.data[0]; 

                                this.companyCode = htmlDecode(session.data.companyCode),
                                this.companyName = htmlDecode(session.data.companyName),
                                this.loggedInEmployeeId = session.data.loggedInEmployeeId,
                                this.loggedInEmployeeName = htmlDecode(session.data.loggedInEmployeeName),
                                this.loggedInEmployeeEmail = session.data.loggedInEmployeeEmail,
                                this.loggedInEmployeeUseMatterCostCentreFlag = session.data.loggedInEmployeeUseMatterCostCentreFlag,
                                this.allocateToId = session.data.loggedInEmployeeAllocateToId,
                                this.allocateToName = htmlDecode(session.data.loggedInEmployeeAllocateToName),
                                this.secGroupId = session.data.loggedInEmployeeSecGroupId,
                                this.supervisorFlag = session.data.supervisorFlag;

                                //this.supervisorFlag = false; // TEST SECURITY


                                this.secGroupBusinessOption = session.data.secGroupBusinessOption;
                                this.secGroupMatterOption = session.data.secGroupMatterOption;
                                this.secGroupCreditorOption = session.data.secGroupCreditorOption;
                                this.secGroupCostCentreOption = session.data.secGroupCostCentreOption;
                                this.secGroupEmployeeOption = session.data.secGroupEmployeeOption;
                                this.secGroupClientOption = session.data.secGroupClientOption;
                                this.secGroupSpreadSheetOption = session.data.secGroupSpreadSheetOption;
                                this.secGroupReportOption = session.data.secGroupReportOption;
                                this.secGroupMatterFileRefFlag = session.data.secGroupMatterFileRefFlag;
                                this.secGroupMatterArchivedFlag = session.data.secGroupMatterArchivedFlag;
                                this.secGroupFinancialAlertsFlag = session.data.secGroupFinancialAlertsFlag;

                                this.control = {...control.data.data[0], ...this.lolSettings};

                                this.vatRates = [
                                    {value: '1', label: formatDecimal(this.control.vatpercent1)},
                                    {value: '2', label: formatDecimal(this.control.vatpercent2)},
                                    {value: '3', label: formatDecimal(this.control.vatpercent3)},
                                    {value: 'N', label: 'No Vat'},
                                    {value: 'E', label: 'Vat Exempt'},
                                    {value: 'Z', label: 'Zero Rated'},

                                ];
                                
                                this.templateData.todaysDate = moment(Date.now()).format('Do MMMM YYYY');

                                this.templateData.tableFilter = null;

                                this.templateData.loaded = true;

                                // ***********************************************
                                // Note: More Company globals are set in Pages.vue
                                // ***********************************************

                                //Set the Clarion globals (for evaluating conditions)
                                this.setGlobals();

                                this.setDatePickerOptions();

                                axios.post("/utils/deleteEmployeeTags",{employeeId: this.loggedInEmployeeId})
                                .catch(error => { 

                                    console.log('Error',error);

                                });

                                setTimeout(this.getBasicData, 1000);

                            },
            
                            methods: {

                                getBasicData() {

                                    axios.post("/utils/getBasicData",{employeeId: this.loggedInEmployeeId})

                                    .then(response => {

                                        this.loadingDataModal.hide();

                                        if ( response.data.errors ) {

                                            showError('Error getting Initial Program Data', response.data.errors);

                                        } else {

                                            this.extraScreens = response.data?.extraScreens?.length ? response.data.extraScreens : [];
            
                                            if ( this.extraScreens.length ) {
                                                this.matterExtraScreens = this.extraScreens.filter(extraScreen => extraScreen.screentype == 'M');
                                            } else {
                                                this.matterExtraScreens = [];
                                            }
            
                                            this.currentEmployee = response.data.currentEmployee;

                                            this.doclogCategories = response.data?.docLogCategories?.length ? response.data.docLogCategories : [];
                                            this.doclogSubCategories = response.data?.docLogSubCategories?.length ? response.data.docLogSubCategories : [];
                                            this.employees = response.data?.employees?.length ? response.data.employees : [];
                                            this.secProcs = response.data?.secProcs?.length ? response.data.secProcs : [];
                                            this.partyEntities = response.data?.partyEntities?.length ? response.data.partyEntities : [];
                                            this.partyTypes = response.data?.partyTypes?.length ? response.data.partyTypes : [];
                                            this.partyRoles = response.data?.partyRoles?.length ? response.data.partyRoles : [];
                                            this.languages = response.data?.languages?.length ? response.data.languages : [];
                                            this.telephoneTypes = response.data?.telephoneTypes?.length ? response.data.telephoneTypes : [];
                                            this.deedsOffices = response.data?.deedsOffices?.length ? response.data.deedsOffices : [];
                                            this.documentSets = response.data?.documentSets?.length ? response.data.documentSets : [];
                                            this.costCentres = response.data?.costCentres?.length ? response.data.costCentres : [];

                                            this.business = response.data?.business?.length ? response.data.business : [];
                                            this.incomeAccounts = this.business.filter(record => record.type == '1');
                                            this.disbursementAccounts = this.business.filter(record => record.type == '1' || record.type == '2' || record.type == '3');
                                            this.expenseAccounts = this.business.filter(record => record.type == '2');
                                            this.revenueStampAccounts = this.business.filter(record => record.type == '11');
                                            this.creditors = response.data?.creditors?.length ? response.data.creditors : [];


                                            this.feeSheets = response.data?.feeSheets?.length ? response.data.feeSheets : [];
                                            this.matterTypes = response.data?.matterTypes?.length ? response.data.matterTypes : [];
                                            this.branches = response.data?.branches?.length ? response.data.branches : [];
                                            this.planOfActions = response.data?.planOfActions?.length ? response.data.planOfActions : [];
                                            this.causeOfActions = response.data?.causeOfActions?.length ? response.data.causeOfActions : [];
                                            this.billingRates = response.data?.billingRates?.length ? response.data.billingRates : [];
                                            this.stageGroups = response.data?.stageGroups?.length ? response.data.stageGroups : [];
                                            this.stages = response.data?.stages?.length ? response.data.stages : [];
                                            this.countries = response.data?.countries?.length ? response.data.countries : [];
                                            this.holidays = response.data?.holidays?.length ? response.data.holidays : [];
                                            this.accounts = response.data?.accounts?.length ? response.data.accounts : [];

                                            if ( !this.employees.length ) {

                                                this.currentEmployee = {};

                                                showError('Initialization Error','No Employees found');

                                            } else {

                                                this.templateData.employee = {};

                                                //this.currentEmployee = this.employees.filter(employee => employee.recordid == this.loggedInEmployeeId)[0];

                                                if (!this.currentEmployee) {
                                                    
                                                    showError('Initialization Error','Logged In Employee Record not found ');

                                                } else {

                                                    this.loggedInEmployeeSmtpUserName = this.currentEmployee.smtpusername;
                                                    this.loggedInEmployeeSmtpPassword = this.currentEmployee.smtppassword;

                                                    this.templateData.employee.name = this.currentEmployee.name;
                                                    this.templateData.employee.loginId = this.currentEmployee.loginid;
                                                    this.templateData.employee.email = this.currentEmployee.emailaddress || this.currentEmployee.email;
                                                    this.templateData.employee.cell = this.currentEmployee.cellphone;
                                                    this.templateData.employee.phoneNumber = this.currentEmployee.telephone;
                                                    this.templateData.employee.reference = this.currentEmployee.reference;
                                                    this.templateData.employee.costCentre = this.currentEmployee.costcentredescription;
                                                    this.templateData.employee.type = this.currentEmployee.emptypedescription;
                                                    this.templateData.employee.branch = this.currentEmployee.branchdescription;
                                                    this.templateData.employee.suspendedFlag = this.currentEmployee.suspendedflag;
                                                    this.templateData.employee.supervisorFlag = this.currentEmployee.supervisorflag;
                                                    this.templateData.employee.emailHeader = this.currentEmployee.emailheader;
                                                    this.templateData.employee.emailFooter = this.currentEmployee.emailfooter;
                                                    this.templateData.employee.emailFontFamily = this.currentEmployee.emailfontfamily;
                                                    this.templateData.employee.emailFontSize = this.currentEmployee.emailfontsize;
                                                    this.templateData.employee.emailFontColor = this.currentEmployee.emailfontcolor;
                                                    this.templateData.employee.emailFontStyle = this.currentEmployee.emailfontstyle;
                                                    this.templateData.employee.emailSubject = this.currentEmployee.emailsubject;
                                                    this.templateData.employee.emailEnding = this.currentEmployee.emailending;
                    
                                                }
                                            }
                                            
                                            this.setCompanyTemplateData();

                                        }

                                    }).catch(error => { 

                                        console.log('Error getting Drop Down Tables',error);

                                    });

                                },


                                mimeTypeHelper(mimeType) {

                                    let returnData = {
                                        type: 'Other',
                                        description: 'other'
                                    };
            
                                    // See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
                                    if ( 
                                        mimeType.indexOf("image/") !== -1 && 
                                        mimeType !== 'image/tiff' 
                                    ) {
            
                                        returnData.type = 'Image';
                                        returnData.description = 'image';
            
                                    } else if ( mimeType.indexOf("audio/") !== -1 ) {
            
                                        returnData.type = 'Audio';
                                        returnData.description = 'audio';
            
                                    } else if ( mimeType.indexOf("video/") !== -1 ) {
            
                                        returnData.type = 'Video';
                                        returnData.description = 'video';
            
                                    } else if ( 
            
                                        mimeType.indexOf("opendocument.text") !== -1 ||
                                        mimeType.indexOf("application/msword") !== -1 ||
                                        mimeType.indexOf("officedocument") !== -1
            
                                    ) {
            
                                        returnData.type = 'Word Document';
                                        returnData.description = 'document';
            
                                    } else if ( mimeType.indexOf("/pdf") !== -1 ) {
            
                                        returnData.type = 'Pdf Document';
                                        returnData.description = 'pdf';
            
                                    }
            
                                    return returnData;
            
                                },                 


                                checkPermission( resource, secProc, action) {
                                    
                                    //console.log("checkPermission",resource, secProc, action);
                                    
                                    if (root.control.licencevaliduntil >= 90000) {
                                        root.$snotify.simple('You are not licenced to ' + action + ' a ' + resource, 'Access Denied', { timeout: 3000, icon: 'icons/lock.gif'});
                                        return false;
                                    }
                                    
                                    if ( typeof resource == 'undefined' ) {
                                        console.error('No resource defined in CheckPermission()')
                                        return true;
                                    }
                                    
                                    if ( typeof secProc == 'undefined') {
                                        console.error('No secProc defined in CheckPermission()')
                                        return true;
                                    }


                                    if ( typeof action == 'undefined') {
                                        console.error('No action defined in CheckPermission()')
                                        return true;
                                    }

                                    //console.log("checkPermission secProcDescription = ",secProc + ' - ' + action);
                                    
                                    if (!root.supervisorFlag) {
                                        
                                        let foundSecProc = root.secProcs.filter(secProc => secProc.SecGroupId == root.secGroupId && secProc.AccessFlag == root.supervisorFlag && secProc.Description == secProc + ' - ' + action)[0];

                                        //console.log("checkPermission foundSecProc",foundSecProc);
                                        //console.log("checkPermission foundSecProc.AccessFlag",foundSecProc?.AccessFlag);

                                        if ( foundSecProc?.AccessFlag == '0' ) {

                                            root.$snotify.simple('Your Security Settings do not allow you to ' + action + ' a ' + resource, 'Access Denied', { timeout: 3000, icon: 'icons/lock.gif'});
                                            return false;

                                        }

                                    }
                                    

                                    /**************************** 
                                    TO DO: Pass SP:Description
                                    *****************************
                                    ! Security Check
                                    Clear(SP:Record)
                                    SP:SecGroupId = GLO:SecGroupId
                                    SP:AccessFlag = GLO:SupervisorFlag
                                    Case GlobalRequest
                                    Of InsertRecord
                                        SP:Description = 'Matters - Update - Insert'
                                    Of ChangeRecord
                                        LSF:CheckFieldFlag = True
                                        SP:Description = 'Matters - Update - Change'
                                    Of DeleteRecord
                                        SP:Description = 'Matters - Update - Delete'
                                    Of ViewRecord
                                        SP:Description = 'Matters - Update - View'
                                    Else
                                        SP:Description = 'Matters - Update'
                                    .
                                    IF Access:SecProc.TryFetch(SP:SecGroupKey) Then Access:SecProc.Insert().
                                    IF SP:DisableOnInsertFlag AND GlobalRequest = InsertRecord
                                        LSF:CheckFieldFlag = True
                                    END
                                    If ~SP:AccessFlag and ~GLO:SupervisorFlag
                                        IF GlobalRequest <> ChangeRecord
                                        Message('Access Denied||Your security settings do not allow you access to this area of the program.|',SP:Description,'~lock.ico')
                                        Return RequestCancelled
                                        Else
                                        GlobalRequest = ViewRecord
                                        If ThisSecProc.CheckAccess() Then Return RequestCancelled.
                                        .
                                    .*/
                                    
            
                                    return true;
            
                                },

                                //https://vue-select.org/guide/positioning.html#popper-js-integration
                                popUp (dropdownList, component, {width}) {

                                    dropdownList.style.width = width;
                        
                                    const popper = createPopper(component.$refs.toggle, dropdownList, {
                                    placement: 'top',
                                    modifiers: [
                                        { name: 'offset', options: {offset: [0, -1] } },
                                        {
                                            name: 'toggleClass',
                                            enabled: true,
                                            phase: 'write',
                                            fn ({state}) {
                                                component.$el.classList.toggle('drop-up', state.placement === 'top')
                                            },
                                        }]
                                    });
                        
                                    return () => popper.destroy();
                                },
                        
                                setDatePickerOptions() {
            
                                    this.datePickerOptions = {
                                        focusOnShow: false,
                                        format: 'DD MMM YYYY',
                                        useCurrent: false,                  
                                        widgetPositioning: {
                                            horizontal: 'auto',
                                            vertical: 'bottom'
                                        }
                                    };
                
                                    this.datePickerIsoOptions = {
                                        focusOnShow: false,
                                        format: 'YYYY-MM-DD',
                                        useCurrent: false,                  
                                        widgetPositioning: {
                                            horizontal: 'auto',
                                            vertical: 'bottom'
                                        }
                                    };
                
                                    this.dateTimePickerOptions = {
                                        focusOnShow: false,
                                        format: 'DD MMM YYYY HH:mm:ss',
                                        useCurrent: false,     
                                        widgetPositioning: {
                                            horizontal: 'auto',
                                            vertical: 'bottom'
                                        }
                                    };
                                },

                                async getFormHeight( id, className ) {

                                    return await new Promise( (resolve, reject) => {            
                        
                                        let $formBody = $('#' + id).find( className );

                                        if ( !$formBody.length) {

                                            reject("No form element found in " + id );

                                        } else {

                                            let formHeight = Math.round( $formBody.outerHeight() );
                            
                                            if ( formHeight == 0 ) {
                                                
                                                setTimeout(function () {
                                                    
                                                    formHeight = Math.round( $formBody.outerHeight() );
                            
                                                    if ( formHeight > 0 ) {
                            
                                                        resolve(formHeight);
                            
                                                    } else {
                                                        
                                                        setTimeout(function () {
                                                            formHeight = Math.round( $formBody.outerHeight() );
                                                            
                                                            if ( formHeight > 0 ) {
                                                                resolve(formHeight);
                                                            } else {
                                                                reject("No formHeight obtained in Form (" + id + ")");
                                                            }
                                                        }, 500);
                            
                                                    }
                            
                                                }, 500);
                            
                                            } else {
                            
                                                resolve(formHeight);
                            
                                            }
                                            
                                        }
                        
                                    });
                        
                                },


                                async getAvailableSpace( topElement, bottomElement , spacing = 0) {

                                    return await new Promise( (resolve, reject) => {            

                                        //setTimeout(function () {

                                            let thisTopElement = $(topElement);
                                            let thisBottomElement = $(bottomElement);

                                            if ( !thisTopElement.length) {

                                                reject("No Top Element found - topElement");

                                            } else if ( !thisBottomElement.length) {

                                                reject("No Bottom Element found - bottomElement");

                                            } else {

                                                let returnValue = thisBottomElement.offset().top - thisTopElement.offset().top - spacing;

                                                if ( returnValue < 100 ) returnValue = 100;

                                                resolve(returnValue);

                                            }

                                        //}, 500);                                            

                                    });
                                },

                                createRecordTemplateData(tableName, templateRecord, id, roleid = null, sorter = null ) {

                                    return new Promise( (resolve, reject) => {     

                                        let templateData = this.initTemplateData();

                                        let url = '/' + tableName.toLowerCase() + '/getTemplateData/' + id;

                                        axios.post( url, {...templateRecord, roleid: roleid, sorter: sorter} )
                                        
                                        .then(async response => {
                    
                                            if ( response.data.errors ) {
                        
                                                reject('Error getting ' + tableName + ' Template Data: ' + response.data.errors);
                                                
                                            } else {
                                                

                                                templateData = {...templateData,...response.data};

                                                //*****************************
                                                // PUT THESE IN THE API for Party!!
                                                //*****************************
                                                // let contacts = await axios.post('/partele/get',{parentId: this.templateData.party.recordid});
                                                
                                                // this.templateData.party.contacts = contacts.data;
                                                
                                                // let matters = await axios.post('/matters/get',{parentId: this.templateData.party.recordid});
                                                
                                                // this.templateData.party.matters = matters.data;
                                                
                                                // this.templateData.party.totalMatters = matters.data.length;


                                                resolve(templateData);
                                            }
                                        }).catch(error => { 
            
                                            reject('Error getting ' + tableName + ' Template Data: ' + error);
                
                                        });                                         
                                    });

                                },

                                vueRender( contents, data, registerUserComponentsFlag = true) {

                                    return new Promise((resolve, reject) => {                                     

                                        if ( contents ) {

                                            let generatedText = '';

                                            this.generatedComponent = null;
        
                                            this.registerUserComponents( data, registerUserComponentsFlag )
        
                                            .then( () => {
        
                                                Vue.component('global-generated-component', {
                                                    template: '<div>' + contents + '</div>',
                                                    data() { return data; },
                                                    props: this.setTemplateProps(),
                                                    methods: this.setTemplateMethods(),
                                                });
        
                                                this.generatedComponent = 'global-generated-component';
        
                                                // Wait for component to render
                                                this.$nextTick(() => { 
        
                                                    if ( !$('#global-generated-component').length ) {
        
                                                        this.generatedComponent = null;

                                                        reject('<p>Unable to generate template contents</p>')
        
                                                    } else {
        
                                                        generatedText = $('#global-generated-component').html();
        
                                                        this.generatedComponent = null;

                                                        resolve(generatedText);
                                                    }
        

                                                });


                                            }).catch(error => { 

                                                reject('Error registering Components: ' + error);

                                            });                                            

                                        } else {

                                            resolve('');
                                        }

                                    });

                                },

                                registerUserComponents(templateData, registerUserComponentsFlag = true) {
            
                                    return new Promise((resolve, reject) => { 
            
                                        if ( registerUserComponentsFlag ) {

                                            //let templateMethods = this.setTemplateMethods();

                                            axios.post('/lolcomponent/get')

                                            .then( async components => {
                
                                                //components.data.forEach(component => {
                                                await root.asyncForEach( components.data.data, async (component) => {  

                                                    //https://stackoverflow.com/questions/37389788/vue-js-check-if-a-component-exists
                                                    
                                                    // 22 Mar 2020 - Taken out this line to check if component already registered
                                                    // because the user may have edited a component and we need the latest root.templateData anyway.
                                                    //if ( typeof Vue.options.components[component.title] === 'undefined') {

                                                        Vue.component(component.title, {
                                                            template: '<div>' + component.contents + '</div>',
                                                            data() { return templateData; },
                                                            props: this.setTemplateProps(),
                                                            methods: this.setTemplateMethods(),

                                                        });
                                                    //}

                                                });
                
                                                resolve();


                                            }).catch(error => { 
                
                                                reject('Error registering Components: ' + error);
                    
                                            });                                            

                                        } else {
                                            resolve();
                                        }
                                    });                    
                                },

                                setTemplateProps() {

                                    return {
                                        filterBy: {type: String, default: '' },
                                    };                                    
                                },

                                setTemplateMethods() {

                                    return {

                                        formatMoney(amount, currencySymbolFlag = true, decimalCount = 2, decimal = ".", thousands = ",") {
                                            return formatMoney(amount, currencySymbolFlag, decimalCount, decimal, thousands);
                                        },

                                        getDebtorTransactions(code = null) {
                                            return code ? this.colDebits.filter(record => record.DocumentCode && record.DocumentCode.trim() == code) : this.colDebits;
                                        },
                                        
                                        totalDebtorTransactions(code = null) {
                                            return this.getDebtorTransactions(code).reduce((acc, ele) => {
                                                return acc + parseFloat(ele.Amount) + parseFloat(ele.VatAmount);
                                            }, 0);
                                        }
                                    
                                    };


                                },

                                setCompanyTemplateData( languageId = null) {

                                    if (!languageId) {
                                        languageId = this.control.defaultlanguageid;
                                    }
                                    
                                    let language = this.languages.filter(row => row.recordid == languageId)[0];

                                    this.templateData.company = {};

                                    this.templateData.company.name = language.name;
                                    this.templateData.company.physicalLine1 = language.physicalline1;
                                    this.templateData.company.physicalLine2 = language.physicalline2;
                                    this.templateData.company.physicalLine3 = language.physicalline3;
                                    this.templateData.company.physicalLine4 = language.physicalline4;
                                    this.templateData.company.physicalCode = language.physicalcode;
                                    this.templateData.company.postalLine1 = language.postalline1;
                                    this.templateData.company.postalLine2 = language.postalline2;
                                    this.templateData.company.postalLine3 = language.postalline3;
                                    this.templateData.company.postalLine4 = language.postalline4;
                                    this.templateData.company.postalCode = language.postalcode;
                                    this.templateData.company.currencySymbol = language.currencysymbol;

                                    this.templateData.company.email = this.control.email || '';
                                    this.templateData.company.work = this.control.telephone || '';
                                    this.templateData.company.fax = this.control.fax || '';
                                    this.templateData.company.mobile = this.control.mobile || '';

                                    this.templateData.company.logo = this.lolSettings.logo || '';
                                    this.templateData.company.website = this.lolSettings.website || '';
                                    this.templateData.company.twitter = this.lolSettings.twitter || '';
                                    this.templateData.company.facebook = this.lolSettings.facebook || '';
                                    this.templateData.company.instagram = this.lolSettings.instagram || '';
                                    this.templateData.company.google = this.lolSettings.google || '';
                                    this.templateData.company.otherChannel = this.lolSettings.otherChannel || '';
                                    this.templateData.company.otherPlatform = this.lolSettings.otherPlatform || '';

                                },

                                initTemplateData() {

                                    const templateData = {};
                                    
                                    templateData.matter = templateData.client = templateData.party = templateData.matParty = templateData.report = {};

                                    // Not sure if this will be used.
                                    templateData.documents = [];

                                    return {...templateData, ...root.templateData};
            
                                },

                                setTableToRefresh( route, tableRef, formRef) {
            
                                    let refreshTables = this.refreshTables;
                        
                                    let index = refreshTables.findIndex( refreshTable => refreshTable.route === route && refreshTable.tableRef === tableRef);
                        
                                    if ( index === -1 ) {
                        
                                        //console.log('Added to refeshTables',route, tableRef, formRef);
                        
                                        refreshTables.push({route:route, tableRef: tableRef, formRef});
                                    }
                        
                                },

                                getCurrentVatRate(date) {

                                    try {

                                        let returnValue = 0;

                                        //console.log("this.$store.getters.currentMatter.vatexemptflag",this.$store.getters.currentMatter.vatexemptflag);

                                        if ( this.$store.getters.currentMatter.vatexemptflag ) {

                                            returnValue = 0;
                            
                                        } else if ( this.control.vatmethod != 'N' ) {
                            
                                            if (date < 79352) {
                            
                                                returnValue = this.control.vatpercent2; // Before 1 April 2018
                            
                                            } else {
                            
                                                returnValue = this.control.vatpercent1;
                            
                                            }
                                        }

                                        return returnValue;

                                    } catch(error) { 

                                        showError('Error getting Current Vat Rate', error); 

                                    };

                                },

                                setGlobals() {
            
                                    axios.post("/employee/get/" + this.loggedInEmployeeId)
                                    
                                    .then(response => {
            
                                        this.global = response.data.data[0];
            
                                        this.global.username = this.global.name;
                                        this.global.todaysdate = convertToClarionDate();
            
                                    }).catch(error => { 
            
                                        console.log('Error getting the Logged In Employee',error);
            
                                    });
                                },

                                getDateRange( period ) {
            
                                    let returnValue = { fromDate: null, toDate: null };
            
                                    if ( period === 'Today' ) {
                        
                                        returnValue.fromDate = returnValue.toDate = moment().format('YYYY-MM-DD');
                                        
                                    } else if ( period === 'Yesterday' ) {
                                        
                                        returnValue.fromDate = returnValue.toDate = moment().subtract(1, 'days').format('YYYY-MM-DD');
                        
                                    } else if ( period === 'This Week' ) {
            
                                        returnValue.fromDate = moment().startOf('isoWeek').format('YYYY-MM-DD');
                                        returnValue.toDate = moment().endOf('isoWeek').format('YYYY-MM-DD');
                        
                                    } else if ( period === 'Last Week' ) {
            
                                        returnValue.fromDate = moment().subtract(1, 'week').startOf('isoWeek').format('YYYY-MM-DD');
                                        returnValue.toDate = moment().subtract(1, 'week').endOf('isoWeek').format('YYYY-MM-DD');
                        
                                    } else if ( period === 'This Month' ) {
            
                                        returnValue.fromDate = moment().startOf('month').format('YYYY-MM-DD');
                                        returnValue.toDate = moment().endOf('month').format('YYYY-MM-DD');
            
                                    } else if ( period === 'Last Month' ) {
            
                                        returnValue.fromDate = moment().subtract(1, 'month').startOf('month').format('YYYY-MM-DD');
                                        returnValue.toDate = moment().subtract(1, 'month').endOf('month').format('YYYY-MM-DD');
            
                                    } else if ( period === 'This Quarter' ) {
            
                                        returnValue.fromDate = moment().startOf('quarter').format('YYYY-MM-DD');
                                        returnValue.toDate = moment().endOf('quarter').format('YYYY-MM-DD');
                        
                                    } else if ( period === 'Last Quarter' ) {
            
                                        returnValue.fromDate = moment().subtract(1, 'quarter').startOf('quarter').format('YYYY-MM-DD');
                                        returnValue.toDate = moment().subtract(1, 'quarter').endOf('quarter').format('YYYY-MM-DD');
                        
                                    } else if ( period === 'This Year' ) {
            
                                        returnValue.fromDate = moment().startOf('year').format('YYYY-MM-DD');
                                        returnValue.toDate = moment().endOf('year').format('YYYY-MM-DD');
            
                                    } else if ( period === 'Last Year' ) {
            
                                        returnValue.fromDate = moment().subtract(1, 'year').startOf('year').format('YYYY-MM-DD');
                                        returnValue.toDate = moment().subtract(1, 'year').endOf('year').format('YYYY-MM-DD');
                                    }
            
                                    return returnValue;
                        
                                },
                                        
                                async downloadObject( path, mimeType = 'application/pdf' ) {
            
                                    //https://stackoverflow.com/questions/32545632/how-can-i-download-a-file-using-window-fetch
            
                                    // Note: For docx use mimeType =  'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
                                    
                                    return fetch(path, {
                                        method: 'GET',
                                    })
            
                                    .then((resp) => {
                                        return resp.blob();
                                    })
            
                                    .then((blob) => {
                                        
                                        download(blob, getFileName(path), mimeType);
            
                                    });
            
                                },

                                truncateText(data, cutoff, wordbreak = false ) {
            
                                    return this.truncate(data, cutoff, wordbreak, false, false );
                                
                                },                
                        
                                truncate(data, cutoff, wordbreak = false, escapeHtml = true, returnHtml = true) {
            
                                    return truncate(data, cutoff, wordbreak, escapeHtml, returnHtml);
                                },
            
                                htmlDecode(value) {
            
                                    return htmlDecode(value);
                                },
            
                                // https://www.30secondsofcode.org/js/s/to-kebab-case
                                toKebabCase(str) {
                                    return  str
                                    .match(/[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+/g)
                                    .map(x => x.toLowerCase())
                                    .join('-');
                                },
                                
                                formatMoney(amount, currencySymbolFlag = true, decimalCount = 2, decimal = ".", thousands = ",") {
            
                                    return formatMoney(amount, currencySymbolFlag, decimalCount, decimal, thousands);
            
                                },

                                isset(value) {
            
                                    return isset(value);
            
                                },
            
                                stripCommas(number) {
            
                                    return stripCommas(number);
            
                                },
            
                                formatDecimal(number) {
            
                                    return formatDecimal(number);
            
                                },
            
                                parseMoney(value) {
            
                                    return parseFloat(value.replace(/,/g, ''));
                                },
                                
                                convertMoney(value) {
                                
                                    return value.replace(/,/g, '');
                                },
            
                                formatDate(date) {
            
                                    return moment(date).format(this.control.dateFormat);
            
                                },
            
                                formatDateTime(date) {
            
                                    return moment(date).format(this.control.dateFormat + ' HH:mm:ss');
            
                                },
            
            
                                salesTaxHint( text = 'excl') {
            
                                    if ( this.control.salesTaxFlag ) {
                                        return ' (' + text + ' ' + this.control.salesTaxType + ')';
                                    } else {
                                        return '';
                                    }
                        
                                },
            
                                async asyncForEach(array, callback) {
                                    for (let index = 0; index < array.length; index++) {
                                        await callback(array[index], index, array);
                                    }
                                },        
                                
                        
                            },
            
                        });
            

                    }
                    
                }).catch(error => { 

                    console.log('Error Initializing Program Data',error);

                });


            }).catch(error => {

                console.error('Error encountered in getting the Company in app.js',error);
            });

        }).catch(error => {

            console.error('Error encountered in getting the System Settings in app.js',error);
        });

}

router.beforeEach((to, from, next) => {

    // Navigation Guard
    // Changes the page title based on the router's meta tag. See: https://alligator.io/vuejs/vue-router-modify-head/

    // This goes through the matched routes from last to first, finding the closest route with a title.
    // eg. if we have /some/deep/nested/route and /some, /deep, and /nested have titles, nested's will be chosen.
    const nearestWithTitle = to.matched.slice().reverse().find(r => r.meta && r.meta.title);

    // If a route with a title was found, set the document (page) title to that value.
    if(nearestWithTitle) document.title = nearestWithTitle.meta.title;

    next();

});


