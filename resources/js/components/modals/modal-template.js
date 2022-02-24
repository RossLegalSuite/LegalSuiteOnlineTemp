export default Vue.extend({

    
    props: {
        id: String,
        modal: {
            type: Boolean,
            default: true
        },
    },

    mounted() {

        
        if ( !this.modal ) return;

        //console.log('Modal mounted modal = ',this.modal);

        //let this = this;

        // Checking for modals with no ID's or multiple ID's
        if ( typeof this.id === 'undefined') console.error('modal-template no id',this.$el);
        if ( $('#' + this.id).length > 1 ) console.error('modal-template multiple ids',this.$el);
        if ( !$('#' + this.id).length  ) console.error('modal-template no length',this.$el);
        

        $('#' + this.id).appendTo("body");

        //Make the modal draggable
        $(".modal-content").draggable( { handle: ".modal-header", containment: "body" });

        
        // 10 June 2020 - once() was causing problems
        //$('#' + this.id).on('shown.bs.modal', once(function (e) {

        $('#' + this.id).on('hidden.bs.modal', () => {

            // Set the ESC key on the next open modal
            let openModals = $('.modal.show').length;

            $(document).off('keyup');
            
            if ( openModals ) {
                
                let id = $('.modal.show')[openModals - 1].id;

                // Handle ESC button
                // Can override esc and click anywhere with 
                //<div class="modal" :id="id" data-backdrop="static" data-keyboard="false">
                
                if ( $('#' + this.id).data( "keyboard" ) !== 'false' ) {

                    $(document).on('keyup', function (e) {

                        if (e.key === 'Escape' )  $('#' + id).modal('hide');

                    });
                    
                }

            }

            // Call any custom "hidden" function for this modal
            if ( typeof this.onHidden === 'function' ) {
                this.onHidden();
            }

        });

        $('#' + this.id).on('shown.bs.modal', function (e) {

            setTimeout(() => {
                

                let modalsOpen = $('.modal-backdrop').length;

                let backdropIndex = parseInt( $('.modal-backdrop').last().css( "z-index") );

                let nextBackdropIndex = backdropIndex + (20 * modalsOpen);
                
                $('.modal-backdrop').last().css( "z-index", nextBackdropIndex );

                if ( modalsOpen > 1 ) {
                    $('.modal-backdrop').last().css( "opacity", "0.25" );
                }
                
                $(this).css( "z-index", nextBackdropIndex + 1);
                
            });

            // Restrict tabbing to the Form section
            if ($('#' + this.id + " .modal-body").length) {
                $('#' + this.id + " .modal-body").tabGuard();
            } else if ($('#' + this.id + " .card-body").length) {
                $('#' + this.id + " .card-body").tabGuard();
            } else {
                console.error("Modal (" + this.id + ") does not have a modal-body or card-body");
            }

            //console.log('# + this.id +  .modal-body','#' + this.id + ' .modal-body', $('#' + this.id + ' .modal-body').length);

            $('#' + this.id + " .popover-icon").popover();

            // Handle ESC button
            // Can override esc and click anywhere with 
            //<div class="modal" :id="id" data-backdrop="static" data-keyboard="false">

            if ( $('#' + this.id).data( "keyboard" ) !== 'false' ) {

                $(document).off('keyup').on('keyup', (e) => {

                    if (e.key === 'Escape') $('#' + this.id).modal('hide');

                });            

            }
        });

    },

    methods: {

        show() { 

            $('#' + this.id).modal({keyboard: true});

            if ( typeof this.modalOpened === 'function') this.modalOpened();

        },

        hide() { 
            
            $('#' + this.id).modal('hide');
        },

        // Alias functions
        open() { 
            this.show();
        },

        close() { 
            $('#' + this.id).modal('hide');
        },

        closeModal() { 
            
            $('#' + this.id).modal('hide');
        },

        setGeneralTab() {

            this.activeTab = 'General';
            this.tabs[0].active = true;

            for (let index = 1; index < this.tabs.length; index++) {

                this.tabs[index].active = false;

            }

        },
    },

})
