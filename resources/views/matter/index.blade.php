@extends('layouts.app', ['activePage' => 'matters', 'pageTitle' => 'Matters'])

@section('content')
<div class="container-fluid">
    <div class="row justify-content-center">
        <div class="col-lg-12">

            <div class="card h-100">
                <div class="card-header">
                    <div class="d-flex justify-content-between">
                        <h2><i class="fa fa-briefcase fa-lg mr-2"></i>Matters</h2>
                        <a title="New Matter" href="\matters\create"><i class="fa fa-plus-circle fa-2x text-success"></i></a>
                    </div>
                </div>

                <div class="card-body p-3">

                    <matter-table table-id="matters-table"></matter-table>
                    
                    
                </div>
            </div>
        </div>
    </div>


</div>
@endsection
