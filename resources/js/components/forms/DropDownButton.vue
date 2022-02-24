<template>
<span>

    <b-dropdown :id="$parent.id + '-dropdown-button'" size="sm" right variant="primary" class="mr-3 form-button">

        <template v-slot:button-content>
            <span :title="dropDownTitle">
                <i class="fa fa-cog mr-2" ></i>{{dropDownText}}
            </span>
        </template>

        <div class="px-2 text-center" >

            <button v-for="button in buttons" v-bind:key="button.text" @click="$parent[button.callback]()" class="btn form-button w-100 my-1" :class="button.class" type="button">
                <span :title="button.title"><i class="fa fa-lg mr-2" :class="button.icon"></i>
                    <span v-text="button.text"></span>
                </span>
            </button>

        </div>

    </b-dropdown>

</span>
</template>

<script>
export default {
    props: {
        dropDownText: {
            type: String,
            default: 'Actions',
        },
        dropDownTitle: {
            type: String,
            default: 'Perform additional actions',
        },
        buttons: {
            type: Array,
            default: function () {
                return []
            },
        },
    },

}  
</script>