<template>

    <div class="d-flex align-items-end">

        <div v-for="(tab, index) in tabs" :key="tab.pageName" 
        :class="(tab.visible ? 'd-table tab-item ' + (tab.color ? tab.color : 'tab' + index) + (tab.active ? ' tab-active ' : ' ') + (tabsWidth < tabMaximumWidth ? ' ' : ' tab-item-small ') : '')" 
        @click="showPage(tab.pageName)">

            <div  class="d-table-row">
                <div class="d-table-cell tab-item-icon">
                    <span v-show="tab.visible" :class="'fa mr-1 ' + tab.iconClass"></span>
                </div>
                <div class="d-table-cell">
                    <div v-show="tab.visible" v-html="tab.title"/>
                </div>
            </div>

        </div>

    </div>

</template>

<script>

export default {

    props: {
        tabs: Array,
    },

    data() {
        return {
            rightPage: null,
            tabsWidth: 0,
            tabMaximumWidth: Math.round( window.innerWidth / 2) - 75

        }
    },

    mounted() {

        this.$nextTick(() => { 
            this.rightPage = this.$root.$refs['pages'].$refs['right-page']; 
        });

    },

    methods: {

        checkTabWidths() {

            let _this = this;

            this.tabsWidth = 0;

            setTimeout(() => {
                
                $(".filofax-right-tabs .align-items-end").children().each(function() {

                    _this.tabsWidth += $(this).outerWidth();

                });

            });
            
        },

        loadPages( pageName ) {

            this.tabs.forEach(tab => {
                
                tab.active = false;

                // if ( tab.resource ) {
                //     tab.visible = this.$root.checkPermission(tab.resource, 'viewFlag')
                // } else {
                //     tab.visible = true;
                // }
                tab.visible = true;

                if ( tab.pageName === pageName ) {
                    tab.active = true;
                }
            });

            this.rightPage.activePage = pageName;

            if (this.tabs.length > 5) this.checkTabWidths();

        },

        loadPage( pageName ) {

            this.tabs.forEach(tab => {
                tab.active = false;
                tab.visible = false;
                if ( tab.pageName === pageName ) {
                    tab.active = true;
                    tab.visible = true;
                }
            });

            this.rightPage.activePage = pageName;

        },

        showPage( pageName ) {

            this.tabs.forEach(tab => {
                tab.active = false;
                if ( tab.pageName === pageName ) {
                    tab.active = true;
                    tab.visible = true;
                }
            });

            this.rightPage.activePage = pageName;

        },

        clearPages() {

            this.tabs.forEach(tab => {
                tab.active = false;
                tab.visible = false;
            });

            this.rightPage.activePage = null;

        },

        closePage( pageName ) {

            let foundTab = this.tabs.filter(tab => tab.pageName == pageName);

            if ( foundTab.length === 1 ) {
                foundTab[0].active = false;
                foundTab[0].visible = false;
            } else {
                console.log('closePage - Could not find the ' + pageName + ' Tab',foundTab);
            }

            let visibleTabs = this.tabs.filter(tab => tab.visible == true);

            if ( visibleTabs.length ) {
                visibleTabs[0].active = true;
                this.rightPage.activePage = visibleTabs[0].pageName;
            } else {
                this.rightPage.activePage = null;
            }

        },

    },

}  
</script>