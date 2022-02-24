<template>
    <div>

        <div class="text-primary font-weight-bold">Balance</div>

        <b-form-radio-group 
        v-model="radioButtonValue" 
        title="Display records that have a certain balance"
        name="custom-radiobutton" 
        @change="radioButtonValueChanged">

            <b-form-radio value="All">All</b-form-radio>
            <b-form-radio value="Any">Any</b-form-radio>
            <b-form-radio value="Debit">Debit</b-form-radio>
            <b-form-radio value="Credit">Credit</b-form-radio>
            <b-form-radio value="Nil">Nil</b-form-radio>

        </b-form-radio-group>
    </div>
</template>

<script>

export default {

    props: {
        parent: Object,
        quickFilterKey: String,
        columnName: String,
    },    
    data() {
        // Note: These are primed in table-template.js using setFilterDropDown()
        return {
            radioButtonValue: 'All',
        }
    },


    methods: {

        radioButtonValueChanged(newValue) {

            this.parent.deleteQuickFilter(this.quickFilterKey + 'QuickFilter');

            if ( newValue === 'Nil') {
                this.parent.addQuickFilter(this.columnName, this.quickFilterKey + 'QuickFilter', '0', 'Equal to');
            } else if ( newValue === 'Debit') {
                this.parent.addQuickFilter(this.columnName, this.quickFilterKey + 'QuickFilter', '0', 'Greater than');
            } else if ( newValue === 'Credit') {
                this.parent.addQuickFilter(this.columnName, this.quickFilterKey + 'QuickFilter', '0', 'Less than');
            } else if ( newValue === 'Any') {
                this.parent.addQuickFilter(this.columnName, this.quickFilterKey + 'QuickFilter', '0', 'Not equal to');
            }

            this.parent.$parent.setUserFilters();

            this.parent.$parent.table.ajax.reload();

        },

    },

}

</script>
