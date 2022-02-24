<template>

    <div class="card h-100 border-0">
        <div class="card-header">
            <div class="d-flex justify-content-between">
                <h3 class="page-title">Summary: <span v-html="pageTitle()"></span></h3>
                <div>
                    <page-refresh-button @refreshPage="refreshPage"/>
                    <page-close-button @closeClicked="closeClicked"/>
                </div>
            </div>
        </div>

        <div class="card-body overflow-auto p-3">

            <page-loading v-if="loading"/>

            <div v-else class="row">

                <div class="col-md-4">

                    <fieldset class="mt-1" style="padding: 0rem 1rem;"><legend>Work in Progress</legend>
                        
                        <ul class="leaders mb-2">
                            <li>
                                <span>Fees</span>
                                <span>{{record.unpostedFees}}</span>
                            </li>
                            <li v-show="$root.parseMoney(record.unpostedDisbursements) > 0">
                                <span>Disbursements</span>
                                <span>{{record.unpostedDisbursements}}</span>
                            </li>
                            
                            <li v-show="$root.parseMoney(record.unpostedTax) != 0">
                                <span>{{$root.control.salesTaxType}}</span>
                                <span>{{record.unpostedTax}}</span>
                            </li>
                        </ul>

                        <div style="border-top: 1px solid slategrey"></div>
                        <ul class="leaders">
                            <li style="font-weight: 600;">
                                <span>Total</span>
                                <span>{{record.unpostedTotal}}</span>
                            </li>
                        </ul>

                    </fieldset>


                </div>

                <div class="col-md-4">

                    <fieldset class="mt-1" style="padding: 0rem 1rem;"><legend>Invoiced</legend>
                        
                        <ul class="leaders mb-2">
                            <li>
                                <span>Fees</span>
                                <span>{{record.postedFees}}</span>
                            </li>
                            <li v-show="$root.parseMoney(record.postedDisbursements) > 0">
                                <span>Disbursements</span>
                                <span>{{record.postedDisbursements}}</span>
                            </li>
                            
                            <li v-show="$root.parseMoney(record.postedTax) != 0">
                                <span>{{$root.control.salesTaxType}}</span>
                                <span>{{record.postedTax}}</span>
                            </li>
                        </ul>

                        <div style="border-top: 1px solid slategrey"></div>
                        <ul class="leaders">
                            <li style="font-weight: 600;">
                                <span>Total</span>
                                <span>{{record.postedTotal}}</span>
                            </li>
                        </ul>


                        <ul v-show="$root.parseMoney(record.businessCredits) > 0" class="leaders mb-2">
                            <li>
                                <span>Business Receipts</span>
                                <span>{{record.businessCredits}}</span>
                            </li>
                        </ul>

                    </fieldset>

                </div>

                <div class="col-md-4">

                    <fieldset class="mt-1" style="padding: 0rem 1rem;"><legend>Transfer</legend>

                        <ul  class="leaders mb-2">
                            <li>
                                <span>Trust Account</span>
                                <span>{{record.trustBalance}}</span>
                            </li>
                            <li v-show="$root.parseMoney(record.postedTotal) > 0">
                                <span>Transfer Available</span>
                                <span v-text="calculateTransferAmount()"></span>
                                
                            </li>
                            
                        </ul>

                        <div v-show="parseFloat(trustTansferAmount) > 0" class="text-center my-3">
                            <button type="button" title="Transfer funds from Trust to Business" class="btn btn-danger form-button mr-2" @click="trustTransfer">
                                <i class="fa fa-refresh fa-lg mr-2"></i>Tansfer Funds
                            </button>
                        </div>

                    </fieldset>

                </div>

            </div>

        </div>

    </div>

</template>

<script>

    import { mapGetters } from 'vuex';

    export default {

        data() {
            return {
                trustTansferAmount: 0,
                loading: true,
                record: {},
            };
        },

        computed: {

        ...mapGetters(['currentMatter']),

        },

        methods: {

            calculateTransferAmount() { 


                this.trustTansferAmount = 0;
                let postedTotal = parseMoney(this.record.postedTotal);
                let trustBalance = parseMoney(this.record.trustBalance);
                
                if ( postedTotal > 0 && trustBalance > 0 ) {

                    if ( trustBalance > postedTotal ) {

                        this.trustTansferAmount = postedTotal;

                    } else {
                        
                        this.trustTansferAmount = trustBalance;

                    }

                }

                //return formatMoney(this.trustTansferAmount);
                return this.trustTansferAmount;

            },

            trustTransfer() { 

                console.log('trustTransfer',this.trustTansferAmount);

            },

            pageTitle() {
                
                return (this.currentMatter.fileref) ? this.currentMatter.fileref + ' - ' + this.currentMatter.description : '';

            },


            closeClicked() { 

                this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].clearPages();

            },

            refreshPage() { 

                this.loading = true;

                axios.post('/matters/get',{recordid: this.currentMatter.recordid})

                .then(response => {
                    
                    this.record = response.data.data[0];
                    this.loading = false;

                });

            },

        },

        
    }
</script>

