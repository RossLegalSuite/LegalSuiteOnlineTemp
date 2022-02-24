<template>

<span>
    <form style="display:none">
        <input type="file" :id="id + '-select-file'">
    </form>
    <button :id="id + '-upload-button'" :class="_class" type="button" @click="selectFile">
        <span :title="title"><i class="fa fa-upload fa-lg mr-2"></i>{{buttonText}}</span>
    </button>
</span>


</template>

<script>

export default {

    props: {
        id: String,
        _class:{
            type: String,
            default: 'btn btn-primary form-button mr-3'
        },
        buttonText:{
            type: String,
            default: 'Upload'
        },
        title:{
            type: String,
            default: 'Upload a File'
        },
        maxSize:{
            type: Number,
            default: 50
        },

    },

    mounted () {

        let _this = this;

        $('#' + this.id + '-select-file').on("change",function() {

            if ( $(this)[0].files.length) {

                if ( !_this.checkUploadedFileSize( $(this)[0].files[0] ) ) {
                    _this.resetManualUploadInput( $('#' + this.id) );
                    return;
                }

                _this.$parent.uploadFile( $(this)[0].files[0] );
                
            }

        });
    },

    methods: {

        selectFile() {

            $('#' + this.id + '-select-file').click();

        },

        checkUploadedFileSize( file ) {

            if ( file.size > ( this.maxSize * 1000000 ) ) {
                showError( "Upload Error", "<em>" + file.name + "</em> is too big to upload.<br><br>The maximum size allowed is " + this.maxSize + "MB." );
                return false;
            }

            return true;

        },

        resetManualUploadInput(e) {

            //http://stackoverflow.com/questions/1043957/clearing-input-type-file-using-jquery/13351234#13351234

            e.wrap('<form>').closest('form').get(0).reset();
            e.unwrap();

        },

    },


}  
</script>