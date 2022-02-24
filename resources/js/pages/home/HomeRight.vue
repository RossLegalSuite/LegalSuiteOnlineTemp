<template>
    <div class="card h-100 border-0">
        <div class="card-header">

            <div v-if="this.$root.lolSettings.logo" class="text-center">
                <img :src="this.$root.lolSettings.logo" class="img-fluid my-2" style="max-height:10vh;" alt="Company Logo">
            </div>

            <h3 v-else class="text-center">{{this.$root.control.name}}</h3>

        </div>

        <div class="card-body overflow-auto pb-1 pt-3 px-3">

        </div>


    </div>

</template>


