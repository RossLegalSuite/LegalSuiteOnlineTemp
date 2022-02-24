<template>
<div>
    <div class="form-group row">
        <text-area 
            _class="col-md-12" 
            :popOver="popOver"
            :popOverContainer="popOverContainer"
            clearIconCallback="clearCustomSqlFilter"
            v-model="customSqlFilter" 
            name="customSqlFilter" 
            ref="customSqlFilterTextInput" 
            label="Custom SQL Filter" 
            @change="customFilterChanged"
            @input="customFilterChanged"
            :lookupLibraryFlag="lookupLibraryFlag"
            :lookupLibraryCategory="lookupLibraryCategory"
        />
    </div>

    <div class="form-group row">

        <div class="col-md-12 text-right">

            <button 
                v-show="customSqlFilter && !customSqlTested"
                type="button" class="btn btn-primary form-button"
                title="Test the Custom Filter before applying it"
                @click="testCustomSqlFilter">
                <i class="fa fa-bug fa-lg mr-2"></i>Test
            </button>

            <button 
                v-show="customSqlTested"
                type="button" class="btn btn-success form-button"
                title="Apply this filter"
                @click="setCustomSqlFilter">
                <i class="fa fa-check-circle fa-lg mr-2"></i>Apply
            </button>

        </div>

    </div>
    <div class="form-group row">

        <div class="col-md-12 text-right">
            <div v-show="customSqlTested" v-html="'Press the Apply button<br>to add the Filter'"/>
        </div>

    </div>

</div>


</template>

<script>
import filterMethods from "@components/filters/filter-methods";

export default {

    mixins: [filterMethods],   

    props: {
        lookupLibraryCategory: {
            type: String,
            default: '',
        },
        lookupLibraryFlag: {
            type: Boolean,
            default: false,
        },
        popOver: {
            type: String,
            default: '',
        },
        popOverContainer: {
            type: String,
            default: '',
        },
        popOverPlacement: {
            type: String,
            default: 'right'
        },
    },

    data() {
        return {
            table: null,
            customSqlFilter: '',
            customSqlFilterKey: 'customSqlFilter',
            customSqlTested: false,
        }
    },

    methods: {

        initialize( table ) {

            this.table = table;

            if (this.$parent.tabs && !this.$parent.tabs.filter(tab => tab.pageName === 'Custom').length ) {

                this.$parent.tabs.push({
                    pageName: "Custom",
                    title: "Custom",
                    iconClass: '',
                    visible: true,
                    active: false,
                });

            }

            let customSqlFilter = this.getCustomSqlFilter();

            if ( customSqlFilter ) {

                this.customSqlFilter = customSqlFilter.settings.calculatedColumn;
                this.$refs.customSqlFilterTextInput.displayClearIcon = true;

            } else {

                this.customSqlFilter = '';
                this.$refs.customSqlFilterTextInput.displayClearIcon = false;
            }


        },

        getCustomSqlFilter() {

            if (this.table.tableId) {
                return this.getFilter(this.customSqlFilterKey);
            } else {
                return null;
            }

        },

        clearCustomSqlFilter() {

            this.customSqlTested = false;
            
            this.customSqlFilter = '';

            this.$refs.customSqlFilterTextInput.displayClearIcon = false;

            this.setCustomSqlFilter();

        },

        // Triggered by keyboard input OR Lookup Library 
        customFilterChanged( value ) {

            this.customSqlTested = false;
            
            this.customSqlFilter = replaceClarionPrefixes(value);

        },

        testCustomSqlFilter() {

            let value = this.customSqlFilter;

            root.$snotify.simple('Please wait...', 'Testing Filter', { timeout: 0, icon: 'img/cogs.gif' });

            axios.post("/" + this.table.tableName + "/get",  { 
                whereRaw: value,
                method: 'count'
            }).then(response => {

                root.$snotify.clear();

                if (response.data.errors) {

                    showError( 'Custom SQL Error', response.data.errors);

                } else {

                    root.$snotify.simple(response.data.data + ' Records were found', 'Success', { timeout: 2000, icon: 'img/check.png' });

                    this.customSqlTested = true;
                }

            }).catch( (error) => {
                root.$snotify.clear();
                showError('Error testing Custom SQL', error); 
            });            

        },


        setCustomSqlFilter() {

            let value = this.customSqlFilter;

            this.deleteFilter(this.customSqlFilterKey);

            if ( value ) {

                let record = {
                    key: this.customSqlFilterKey,
                    fromDate: null,
                    toDate: null,
                    period: null,
                    fromAmount: null,
                    toAmount: null,
                    value: null,
                    method: null,
                    join: 'and',
                    description: 'Custom Filter',
                    targets: -1,
                    title: 'Custom SQL Filter',
                    name: 'Custom SQL Filter',
                    calculatedColumn: value,
                    filterType: 'Custom SQL Filter',
                    filterTitle: 'Custom SQL Filter',
                };

                this.addCustomFilter(this.customSqlFilterKey, record);

                this.$refs.customSqlFilterTextInput.displayClearIcon = true;

                // Hide the Apply Button
                this.customSqlTested = false;

            }

            this.table.setUserFilters();

            this.table.table.ajax.reload();

        },


    },


}  
</script>