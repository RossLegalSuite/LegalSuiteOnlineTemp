
<template>
    <div class="modal" :id="id">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-color: indianred;">

            <div class="modal-header indianred">
                <h3 class="modal-title"><i class="fa fa-filter mr-2"></i>Filter Extra Screens</h3>
                <i title="Close this window" class="cp top-right fa fa-times-circle fa-2x text-white" data-dismiss="modal"></i>
            </div>

            <div class="modal-body p-3" style="height: 33vh; overflow-y: auto;">

                <div class="form-group row">
                    <radio-buttons 
                        ref="type-radio-button"
                        label="Location" 
                        :record="typeRadioButtonRecord" 
                        column="value" 
                        name="typeValue" 
                        :buttons="$root.extraScreenTypesArray" 
                        @change="typeRadioButtonChanged"
                    />
                </div>

            </div>

            <div class="modal-footer justify-content-between">
                <div>
                    <button class="btn btn-primary form-button mr-2" type="button" @click="loadAdvancedFilters" title="Advanced Filtering options"><i class="fa fa-cog fa-lg mr-2"></i>Advanced</button>
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

export default {

    mixins: [modalTemplate, filterMethods],

    data() {
        return {
            typeRadioButtonRecord: { value: null},
            typeFilterColumnName: 'extra_screens.location',
        }
    },

    mounted() {
        this.$parent.filterForm = this;
    },    

    methods: {

        modalOpened() {

            this.primeCommonFilters();

        },

    }   
}  
</script>