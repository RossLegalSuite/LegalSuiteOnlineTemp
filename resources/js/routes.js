import pages from './pages/pages';
import guestPages from './pages/guestPages';

// See: https://alligator.io/vuejs/lazy-loading-vue-cli-3-webpack/
function lazyLoad(component){
    return() => import(/* webpackChunkName: "view-[request]" */ `${component}.vue`)
}

export default {
    mode: 'history',
    routes: [
        {
            path: '/',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/guest/GuestTabs'),
            },
            children: [{
                path: '/',
                name: 'guest',
                components: {
                    leftPage: lazyLoad('./pages/guest/GuestLeft'),
                    rightPage: lazyLoad('./pages/guest/GuestRight'),
                }
            }],
            meta: { title: 'LegalSuite Online' },
        },
        {
            path: '/login/:firmcode',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/client/ClientTabs'),
            },
            children: [{
                path: '/login/:firmcode',
                name: 'client',
                components: {
                    leftPage: lazyLoad('./pages/client/ClientLeft'),
                    rightPage: lazyLoad('./pages/client/ClientRight'),
                }
            }],
            meta: { title: 'LegalSuite Online' },
        },
        {
            path: '/home',
            component: pages,
            children: [{
                path: '/home',
                name: 'home',
                components: {
                    leftPage: lazyLoad('./pages/home/HomeLeft'),
                    rightPage: lazyLoad('./pages/home/HomeRight'),
                }
            }],
            meta: { title: 'LegalSuite - Home' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/parties/PartyTabs'),
            },
            children: [{
                path: '/parties',
                name: 'parties',
                components: {
                    leftPage: lazyLoad('./pages/parties/PartyLeft'),
                    rightPage: lazyLoad('./pages/parties/PartyRight'),
                }
            }],
            meta: { title: 'LegalSuite - Address Book' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/matter-parties/MatterPartiesTabs'),
            },
            children: [{
                path: '/matter-parties',
                name: 'matter-parties',
                components: {
                    leftPage: lazyLoad('./pages/matter-parties/MatterPartiesLeft'),
                    rightPage: lazyLoad('./pages/matter-parties/MatterPartiesRight'),
                }
            }],
            meta: { title: 'LegalSuite - Parties' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/employees/EmployeeTabs'),
            },
            children: [{
                path: '/employees',
                name: 'employees',
                components: {
                    leftPage: lazyLoad('./pages/employees/EmployeeLeft'),
                    rightPage: lazyLoad('./pages/employees/EmployeeRight'),
                }
            }],
            meta: { title: 'LegalSuite - Employees' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/matters/MatterTabs'),
            },
            children: [{
                path: '/matters',
                name: 'matters',
                components: {
                    leftPage: lazyLoad('./pages/matters/MatterLeft'),
                    rightPage: lazyLoad('./pages/matters/MatterRight'),
                }
            }],
            meta: { title: 'LegalSuite - Matters' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/email/EmailTabs'),
            },
            children: [{
                path: '/email',
                name: 'email',
                components: {
                    leftPage: lazyLoad('./pages/email/EmailLeft'),
                    rightPage: lazyLoad('./pages/email/EmailRight'),
                }
            }],
            meta: { title: 'LegalSuite - Email' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/feenotes/FeeNoteTabs'),
            },
            children: [{
                path: '/feenotes',
                name: 'feenotes',
                components: {
                    leftPage: lazyLoad('./pages/feenotes/FeeNoteLeft'),
                    rightPage: lazyLoad('./pages/feenotes/FeeNoteRight'),
                }
            }],
            meta: { title: 'LegalSuite - Fee Notes' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/filenotes/FileNoteTabs'),
            },
            children: [{
                path: '/filenotes',
                name: 'filenotes',
                components: {
                    leftPage: lazyLoad('./pages/filenotes/FileNoteLeft'),
                    rightPage: lazyLoad('./pages/filenotes/FileNoteRight'),
                }
            }],
            meta: { title: 'LegalSuite - File Notes' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/doclog/DoclogTabs'),
            },
            children: [{
                path: '/doclog',
                name: 'doclog',
                components: {
                    leftPage: lazyLoad('./pages/doclog/DoclogLeft'),
                    rightPage: lazyLoad('./pages/doclog/DoclogRight'),
                }
            }],
            meta: { title: 'LegalSuite - Document Log' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/documents/DocumentsTabs'),
            },
            children: [{
                path: '/documents',
                name: 'documents',
                components: {
                    leftPage: lazyLoad('./pages/documents/DocumentsLeft'),
                    rightPage: lazyLoad('./pages/documents/DocumentsRight'),
                }
            }],
            meta: { title: 'LegalSuite - Generated Documents' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/reminders/ReminderTabs'),
            },
            children: [{
                path: '/reminders',
                name: 'reminders',
                components: {
                    leftPage: lazyLoad('./pages/reminders/ReminderLeft'),
                    rightPage: lazyLoad('./pages/reminders/ReminderRight'),
                }
            }],
            meta: { title: 'LegalSuite - Reminders' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/document-sets/DocumentSetTabs'),
            },
            children: [{
                path: '/document_sets',
                name: 'documentSets',
                components: {
                    leftPage: lazyLoad('./pages/document-sets/DocumentSetLeft'),
                    rightPage: lazyLoad('./pages/document-sets/DocumentSetRight'),
                }
            }],
            meta: { title: 'LegalSuite - Document Sets' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/feesheets/FeeSheetTabs'),
            },
            children: [{
                path: '/feesheets',
                name: 'feeSheets',
                components: {
                    leftPage: lazyLoad('./pages/feesheets/FeeSheetLeft'),
                    rightPage: lazyLoad('./pages/feesheets/FeeSheetRight'),
                }
            }],
            meta: { title: 'LegalSuite - Fee Sheets' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/feecodes/FeeCodeTabs'),
            },
            children: [{
                path: '/feecodes',
                name: 'feeCodes',
                components: {
                    leftPage: lazyLoad('./pages/feecodes/FeeCodeLeft'),
                    rightPage: lazyLoad('./pages/feecodes/FeeCodeRight'),
                }
            }],
            meta: { title: 'LegalSuite - Fee Codes' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/document-templates/DocumentTabs'),
            },
            children: [{
                path: '/document_templates',
                name: 'documentTemplates',
                components: {
                    leftPage: lazyLoad('./pages/document-templates/DocumentLeft'),
                    rightPage: lazyLoad('./pages/document-templates/DocumentRight'),
                }
            }],
            meta: { title: 'LegalSuite - Document Templates' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/templates/TemplateTabs'),
            },
            children: [{
                path: '/templates',
                name: 'systemTemplates',
                components: {
                    leftPage: lazyLoad('./pages/templates/TemplateLeft'),
                    rightPage: lazyLoad('./pages/templates/TemplateRight'),
                }
            }],
            meta: { title: 'LegalSuite - System Templates' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/components/ComponentTabs'),
            },
            children: [{
                path: '/components',
                name: 'components',
                components: {
                    leftPage: lazyLoad('./pages/components/ComponentLeft'),
                    rightPage: lazyLoad('./pages/components/ComponentRight'),
                }
            }],
            meta: { title: 'LegalSuite - Components' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/extra-screens/ExtraScreenTabs'),
            },
            children: [{
                path: '/extra_screens',
                name: 'extraScreens',
                components: {
                    leftPage: lazyLoad('./pages/extra-screens/ExtraScreenLeft'),
                    rightPage: lazyLoad('./pages/extra-screens/ExtraScreenRight'),
                }
            }],
            meta: { title: 'LegalSuite - Extra Screens' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/reports/ReportTabs'),
            },
            children: [{
                path: '/reports',
                name: 'reports',
                components: {
                    leftPage: lazyLoad('./pages/reports/ReportLeft'),
                    rightPage: lazyLoad('./pages/reports/ReportRight'),
                }
            }],
            meta: { title: 'LegalSuite - Reports' },
        },
        {
            path: '/page',
            components: {
                default: loggedIn ? pages : guestPages,
                rightHandTabs: lazyLoad('./pages/settings/SettingsTabs'),
            },
            children: [{
                path: '/settings',
                name: 'settings',
                components: {
                    leftPage: lazyLoad('./pages/settings/SettingsLeft'),
                    rightPage: lazyLoad('./pages/settings/SettingsRight'),
                    //rightHandTabs: lazyLoad('./pages/settings/SettingsTabs'),
                },
            }],
            meta: { title: 'LegalSuite - Settings' },
        },
    ]
}