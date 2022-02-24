@extends('layouts.app', ['activePage' => 'matters', 'pageTitle' => $editing ? 'Edit Matter' : 'New Matter'])

@section('content')

<div class="row justify-content-center">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h2>@if( $editing )Matter will be Changed @else Matter will be Added @endif</h2>
                @if($errors->has('general')) <span class="invalid-feedback" role="alert"><strong>{{ $errors->first('general') }}</strong> </span> @endif
            </div>

            <form id="matter-edit-form" method="post" action="{{$action}}">

                @if( $editing ) @method('PATCH') @endif

                <input name="id" type="hidden" value="{{ $record->id }}">

                @csrf

                <div class="card-body">

                    <div class="row">
                        <div class="col-lg-6">

                            <fieldset><legend>&nbsp;&nbsp;Client Details&nbsp;&nbsp;</legend>

                            <select-matter-client ref="select-matter-client" code="{{$record->code}}" name="{{$record->name}}"></select-matter-client>                                    

                            </fieldset>
                            

                        </div>

                        <div class="col-lg-6 mt-3 mt-lg-0">

                            <fieldset><legend>&nbsp;&nbsp;Settings&nbsp;&nbsp;</legend>
                            </fieldset>
                        </div>
    
                    </div>

                </div>

                <div class="card-footer">
                    <form-buttons title="Matter" :editing="{{$editing}}"></form-buttons>
                </div>
            </form>
            @if( $editing )
            <form id="deleteMatterForm" method="post" action="/parties/{{ $record->id}}">
                @method("DELETE") @csrf
            </form>
            @endif

        </div>
    </div>


</div>
@if ( $editing )
<modal-delete modal-id="delete-matter-modal" title="Party"></modal-delete>
@endif
    

@endsection

@section('scripts')

<script>

    let editing = {{$editing}};

    function confirmDelete() {$("#delete-matter-modal").modal();}

    function deleteRecord() {$("#delete-matter-modal").modal("hide");$("#deleteMatterForm").submit();} 


    function submitForm() {

        $("#matter-edit-form").submit();


    }


</script>
@endsection
