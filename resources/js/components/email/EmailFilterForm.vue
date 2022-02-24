
<template>
    <div class="modal" :id="id">
        <div class="modal-dialog modal-dialog-right" style="margin-top:10vh">
            <div class="modal-content red-border">

            <div class="modal-header red-bg">
                <h3 class="modal-title"><i class="fa fa-filter mr-2"></i>Filter Email Addresses</h3>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="card-body overflow-auto p-3" style="height: 45vh;">


                <div class="form-group row">

                    <text-input 
                        _class="col-md-8" 
                        v-model="email" 
                        name="email" 
                        label="Email Contains" 
                        popOver="<h4>Email Contains</h4><p>Filter by an email address or part of an email address</p>"
                        :clearIcon="emailFilterFlag ? true : false"
                        clearIconCallback="clearEmailFilter"
                        ref="emailTextInput"

                    />

                </div>                                        

                <div class="form-group row">

                    <text-input 
                        _class="col-md-8" 
                        v-model="party" 
                        name="partyName" 
                        label="Name Contains" 
                        popOver="<h4>Name Contains</h4><p>Filter by a Party name or part of a Party's name</p>"
                        :clearIcon="partyFilterFlag ? true : false"
                        clearIconCallback="clearpartyFilter"
                        ref="partyTextInput"
                    />

                </div>                                        


            </div>

            <div class="modal-footer justify-content-between">
                <div>
                    
                </div>
                <div>
                    <button class="btn btn-danger form-button" type="button" @click="hide" title="Close this screen"><i class="fa fa-times-circle fa-lg mr-2"></i>Close</button>
                </div>
            </div>

            </div>
        </div>
    </div>
</template>

<script>

import modalTemplate from "@components/modals/modal-template";
import filterMethods from "@components/filters/filter-methods";
import { debounce } from 'lodash';

export default {

    mixins: [modalTemplate, filterMethods],

    created() {
        this.debounceAddEmailFilter = debounce((value) => { this.addEmailFilter(value) }, 750);
        this.debounceAddPartyFilter = debounce((value) => { this.addPartyFilter(value) }, 750);
    }, 

    data() {
        return {
            table: null,
            email: null,
            emailFilterFlag: false,
            emailFilterColumnName: 'Partele.Number',
            party: null,
            partyFilterFlag: false,
            partyFilterColumnName: 'Party.Name',
        }

    },

    watch: {


        email: function (newValue) {

            if (newValue) {
                this.debounceAddEmailFilter( newValue );
            } else {
                this.clearEmailFilter();
            }
        },

        emailFilterFlag: function (newValue) {

            console.log("Watching emailFilterFlag newValue = ",newValue);

            this.$refs.emailTextInput.displayClearIcon = newValue;

            if (newValue === false) {
                this.email = '';
            } else {
                let filter = this.getFilter(this.emailFilterKey);
                if ( filter !== null ) this.email = filter.settings.value;
            }
        },


        party: function (newValue) {

            if (newValue) {
                this.debounceAddPartyFilter( newValue );
            } else {
                this.clearPartyFilter();
            }
        },

        partyFilterFlag: function (newValue) {

            console.log("Watching partyFilterFlag newValue = ",newValue);

            this.$refs.partyTextInput.displayClearIcon = newValue;

            if (newValue === false) {
                this.party = '';
            } else {
                let filter = this.getFilter(this.partyFilterKey);
                if ( filter !== null ) this.party = filter.settings.value;
            }
        },

    },    

    methods: {

        modalOpened(){

            this.emailFilterKey = this.getFilterName(this.emailFilterColumnName);
            this.emailFilter = this.getFilter(this.emailFilterKey);
            if (this.emailFilter) {
                this.email = this.emailFilter.settings.value
                this.emailFilterFlag = true;
            } else {
                this.email = '';
                this.emailFilterFlag = false;
            }
            this.$refs.emailTextInput.displayClearIcon = this.emailFilterFlag;

            this.partyFilterKey = this.getFilterName(this.partyFilterColumnName);
            this.partyFilter = this.getFilter(this.partyFilterKey);
            if (this.partyFilter) {
                this.party = this.partyFilter.settings.value
                this.partyFilterFlag = true;
            } else {
                this.party = '';
                this.partyFilterFlag = false;
            }
            this.$refs.partyTextInput.displayClearIcon = this.partyFilterFlag;


        },

        addEmailFilter( value ) {

            console.log("Calling addEmailFilter");

            this.deleteFilter(this.emailFilterKey);

            this.addFilter(this.emailFilterColumnName, this.emailFilterKey, value, null, 'Contains');

            this.emailFilterFlag = true;

            this.reloadTable();

        },        

        clearEmailFilter() {

            this.deleteFilter(this.emailFilterKey);

            this.emailFilterFlag = false;

            this.reloadTable();

        },

        addPartyFilter( value ) {

            console.log("Calling addPartyFilter");

            this.deleteFilter(this.partyFilterKey);

            this.addFilter(this.partyFilterColumnName, this.partyFilterKey, value, null, 'Contains');

            this.partyFilterFlag = true;

            this.reloadTable();

        },        

        clearPartyFilter() {

            this.deleteFilter(this.partyFilterKey);

            this.partyFilterFlag = false;

            this.reloadTable();

        },


    }   
}  
</script>