<template>

    <div class="d-flex align-items-end" :id="$parent.id + '-form-tabs'">

        <div v-for="(tab, index) in tabs" :key="tab.pageName" 
        :class="(tab.visible ? 'tab-item form-tab-item tab' + (index+1) + (tab.active ? ' tab-active px-2' : ' ') : '')" 
        @click="showPage(tab.pageName)">

            <span v-show="tab.visible" v-html="tab.title"/>

        </div>

    </div>

</template>

<script>

export default {

    props: {
        tabs: Array,
    },


    methods: {

        loadPages( pageName ) {

            this.tabs.forEach(tab => {
                tab.active = false;
                tab.visible = true;
                if ( tab.pageName === pageName ) {
                    tab.active = true;
                }
            });

            this.$parent.activeTab = pageName;
            //setTimeout( this.$parent.activeTab = pageName );

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

            this.$parent.activeTab = pageName;
            //setTimeout( this.$parent.activeTab = pageName );

        },

        showPage( pageName ) {

            
            this.tabs.forEach(tab => {
                tab.active = false;
                if ( tab.pageName === pageName ) {
                    tab.active = true;
                    tab.visible = true;
                }
            });

            this.$parent.activeTab = pageName;

            // setTimeout was giving an error ('Reference Contact not found' - where 'Contact' was the pageName)
            //setTimeout( this.$parent.activeTab = pageName );

        },

        clearPages() {

            this.tabs.forEach(tab => {
                tab.active = false;
                tab.visible = false;
            });

            this.$parent.activeTab = null;
            //setTimeout( this.$parent.activeTab = null );

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
                this.$parent.activeTab = visibleTabs[0].pageName;
            } else {
                this.$parent.activeTab = null;
            }

        },

    },

}  
</script>