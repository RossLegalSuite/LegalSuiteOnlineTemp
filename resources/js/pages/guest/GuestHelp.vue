<template>

<div class="card h-100 border-0">
    
    <div class="card-header">
        <div class="d-flex justify-content-between">
            <h3><i class="fa fa-info-circle mr-2"></i>Help</h3>
            <page-close-button @closeClicked="hide"/>
        </div>
    </div>

    <div class="card-body overflow-auto pl-4 p-3">

        <div class="form-group row">

            <h4>Help</h4>

        </div>                                        

    </div>

    

</div>

</template>


<script>

export default {

    data() {
        return {
            activePage: 'Help',
        }
    },

    methods: {

        hide() {

            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].closePage(this.activePage);

        },

    },

}

</script>
