function summerNoteToolBar() {
    return [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['paragraph']],
        ['table', ['table']],
        ['insert', ['link', 'picture' ]],
        ['custom1', ['togglecodeview']],
        ['custom2', ['fields']],
        ['custom3', ['preview']],
    ];
    //['view', ['codeview']],
}

function addToggleCodeViewButton() {
    return  {
        togglecodeview: addSummerNoteToggleCodeViewButton
    };
}

function addSummerNoteToggleCodeViewButton(context) {

    var ui = $.summernote.ui;

    var button = ui.button({
        className: 'btn-fullscreen note-codeview-keep ml-2',
        contents: '<i class="fa fa-code mr-2"></i>Code View',
        tooltip: 'Toggle Code View',
        click: () => {
            context.$note.summernote('codeview.toggle');
        }
    });

    return button.render();   
}

function addTemplateFieldsButton() {
    return  {
        fields: this.addSummerNoteTemplateFieldsButton
    };
}

function addSummerNoteTemplateFieldsButton(context) {

    var ui = $.summernote.ui;

    var button = ui.button({
        className: 'btn-fullscreen note-codeview-keep ml-2',
        contents: '<i class="fa fa-file-code-o mr-2"></i>Fields',
        tooltip: 'Insert a Field or Component',
        click: () => {
            root.selectTemplateFields.load(context);
        }
    });

    return button.render();   
}

function addPreviewTemplateButton() {
    return  {
        preview: this.addSummerNotePreviewTemplateButton
    };
}

function addSummerNotePreviewTemplateButton( context ) {

    try {
        
        var ui = $.summernote.ui;
    
        var button = ui.button({
            className: 'btn-fullscreen note-codeview-keep ml-2',
            contents: '<i class="fa fa-file-powerpoint-o mr-2"></i>Preview',
            tooltip: 'Generate the Template and preview the contents',
            click: () => {
                
                context.options.previewMethod(context.options.previewMethodParams);
            }
        });
    
        return button.render();   

    } catch (error) {
        console.log("Error",error);
    }

}

