<template>

    <div class="d-flex d-none align-items-end"> 

        <router-link v-for="tab in activeLeftTabs" v-bind:key="tab.title.toLowerCase() + '-tab'" :to="{ name: tab.routeName}"  
        :class="'d-table tab-item ' + tab.class + (tabsWidth < tabMaximumWidth ? ' ' : ' tab-item-small ')">

            <div :class="'d-table-row ' + (tab.title !== 'Home' ? 'clickable-tab' : 'clickable-home-tab')" :id="tab.pageName.toLowerCase() + '-lefthand-tab'" 
            :data-page-name="tab.pageName"
            :data-route-name="tab.routeName"
            >
                <div class="d-table-cell tab-item-icon">
                    <span class="fa mr-1" :class="tab.icon"></span>
                </div>
                <div class="d-table-cell">
                    {{tab.title}}
                </div>
            </div>

        </router-link>

    </div>

</template>

<script>

import { mapGetters } from 'vuex';
import { mapMutations } from 'vuex';

export default {

    computed: {
        ...mapGetters(['activeLeftTabs']),
    },

    data() {
        return {
            tabsWidth: 0,
            tabMaximumWidth: Math.round( window.innerWidth / 2) - 75
        }
    },

    watch: {

        activeLeftTabs() {

            let _this = this;

            $.contextMenu( 'destroy', '.clickable-home-tab' );

            $.contextMenu( 'destroy', '.clickable-tab' );

            if ( this.activeLeftTabs.length > 1 ) {

                $.contextMenu({
                    selector: '.clickable-tab',
                    build: ($triggerElement, e) => {
                        return {
                            items: {
                                closeThisTab: {name: "Close this Tab", icon: "fa-times-circle", callback: (key, opt) => { 

                                    let pageName = $(e.currentTarget).attr('data-page-name');

                                    let thisTabIndex = this.activeLeftTabs.findIndex(tab => tab.pageName == pageName);

                                    let siblingTab = this.activeLeftTabs[thisTabIndex - 1];

                                    this.hideLeftTab(pageName);

                                    this.$router.push({ name: siblingTab.routeName });


                                }},

                                closeOtherTabs: {name: "Close other Tabs", icon: "fa-tasks", callback: (key, opt) => { 

                                    let pageName = $(e.currentTarget).attr('data-page-name');
                                    let routeName = $(e.currentTarget).attr('data-route-name');

                                    this.hideOtherTabs(pageName);

                                    if ( this.$router.currentRoute.name !== routeName) this.$router.push({ name: routeName });

                                }},

                                closeAllTabs: {name: "Close all Tabs", icon: "fa-tasks", callback: (key, opt) => { 
                                    this.hideAllTabs();
                                    this.$router.push({ name: 'home' });
                                }},
                            }
                        };
                    }
                });

                $.contextMenu({
                    selector: '.clickable-home-tab',
                    build: ($triggerElement, e) => {
                        return {
                            items: {
                                closeOtherTabs: {name: "Close other Tabs", icon: "fa-tasks", callback: (key, opt) => { 

                                    let routeName = $(e.currentTarget).attr('data-route-name');

                                    this.hideAllTabs();

                                    if ( this.$router.currentRoute.name !== routeName) this.$router.push({ name: routeName });


                                }},
                            }
                        };
                    }
                });

            }

            this.tabsWidth = 0;

            setTimeout(() => {
                
                $(".filofax-left-tabs .align-items-end").children().each(function() {

                    _this.tabsWidth += $(this).outerWidth();

                });

            });
            
        }
    },

    methods: {

        ...mapMutations(['hideLeftTab','hideAllTabs','hideOtherTabs']),

    },
}  
</script>