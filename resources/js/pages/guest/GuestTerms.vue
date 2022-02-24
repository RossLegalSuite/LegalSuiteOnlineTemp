<template>

<div class="card h-100 border-0">
    
    <div class="card-header">
        <div class="d-flex justify-content-between">
            <h3><i class="fa fa-pencil-square-o mr-2"></i>Terms & Conditions</h3>
            <page-close-button @closeClicked="hide"/>
        </div>
    </div>

    <div class="card-body form-tab-body overflow-auto">

        <form-tabs :tabs="tabs"/>

        <div v-show="activeTab === 'General'" class="form-tab-content">
            <div class="row">

                <div class="col-md-12">
                    <p>The program, its owners, agents and/or any third parties connected wth the program do not provide any warranty or guarantee as to the accuracy, legality, timeliness, performance, completeness or suitability of the information and materials found or offered by this program for any particular purpose.</p>
                    <p>You acknowledge that such information and materials may contain inaccuracies or errors and we expressly exclude liability for any such inaccuracies or errors to the fullest extent permitted by law.
                    </p>
                    <p>Your use of any modules, functions, methods, information or materials on this program is entirely at your own risk, for which we shall not be liable. It shall be your responsibility to ensure that any accounting methods, reports, templates, documents, products, services or information made available by this program meet your specific requirements and are used entirely at your own risk.</p>
                    <p>This program contains material which is owned by or licensed to Ettorney Limited. This material includes, but is not limited to the design, layout, look, appearance, algorithms, functionality, documents and reports. Reproduction and/or distribution of any part of the program, including but not limited to its templates, reports or documents is strictly prohibited.</p>
                    <p>Your use of this program and any dispute arising out of such use is subject to the laws and jursidiction of Mauritius.</p>
                    <p>By continuing to use this program, you are expressly agreeing to comply with and shall be bound by the <em>general terms and conditions</em> of use, which together with our <em>privacy policy</em> govern Ettorney Limited’s relationship with you in relation to this program.</p> 
                    <p>If you disagree with any part of these terms and conditions, please do not use the program.</p>

                </div>

            </div>
        </div>
        <div v-show="activeTab === 'Privacy'" class="form-tab-content">
            <div class="row">
                <div class="col-md-12">
                </div>
            </div>
        </div>

        <!-- <div v-show="activeTab === 'Conduct'" class="form-tab-content">
            <div class="row">
                <div class="col-md-12">
                </div>
            </div>
        </div> -->

    </div>


</div>

</template>

<script>

export default {

    data() {
        return {
            activePage: 'Terms',
            activeTab: 'General',
            tabs: [
                {
                    pageName: "General",
                    title: "General",
                    iconClass: '',
                    visible: true,
                    active: true,
                },
                {
                    pageName: "Privacy",
                    title: "Privacy Policy",
                    iconClass: '',
                    visible: true,
                    active: false,
                },
                // {
                //     pageName: "Conduct",
                //     title: "Code of Conduct",
                //     iconClass: '',
                //     visible: true,
                //     active: false,
                // },
            ]
        }
    },

    methods: {

        hide() {
            this.$root.$refs['right-hand-tab-container'].$refs['right-hand-tabs'].closePage(this.activePage);
        },

    },    


}
</script>

