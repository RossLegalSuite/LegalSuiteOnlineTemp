<template>

    <div class="d-lg-flex filofax-page-container" id="filofax-both-pages">

        <div class="filofax-left-page" id="filofax-left-page">

            <keep-alive>
                <router-view ref="left-page" name="leftPage" :key="$route.name"/>
            </keep-alive>
    
        </div>


        <div class="filofax-binder d-none d-lg-block"></div>
        
        <div class="filofax-right-page" id="filofax-right-page">

            <keep-alive>
                <router-view ref="right-page" name="rightPage" :key="$route.name"/>
            </keep-alive>
            

        </div>

    </div>

</template>

