export default Vue.extend({


    mounted() {

        let thisTab = this.leftTabs.filter(tab => tab.pageName == this.pageName);

        if (thisTab.length) this.displayLeftTab(thisTab[0]);


        this.$nextTick(() => { 

            var urlParams = new URLSearchParams(window.location.search);

            if ( urlParams.has('tab') ) {
                this.loadPage( urlParams.get('tab') );
            }


        });

    },

    methods: {

        closeLeftPage( pageName) {

            let thisTabIndex = this.activeLeftTabs.findIndex(tab => tab.pageName == pageName);

            let siblingTab = this.activeLeftTabs[thisTabIndex - 1];

            this.hideLeftTab(pageName);

            this.$router.push({ name: siblingTab.routeName });

        },

        loadPages( pageName) {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].loadPages( pageName );

        },

        loadPage( pageName) {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].loadPage( pageName );

        },

        clearPages() {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].clearPages();

        },

        tryDeleteTaggedRecords(table) {

            axios.post('/' + table + '/delete', {id: this.selectedRows})
            
            .then(response => {

                if (response.data.errors) {

                    let message = response.data.errors.length + ' ' + this.table.plural + ' were not deleted because they are linked to other records in the program';

                    if ( response.data.errors.length === 1 ) {

                        message = '1 ' + this.table.singular + ' was not deleted because it is linked to other records in the program';
                    }

                    root.$snotify.simple(message, 'Delete Result', { timeout: 5000});

                }

                this.table.loadDataTable();

            });
        },

    },

})
