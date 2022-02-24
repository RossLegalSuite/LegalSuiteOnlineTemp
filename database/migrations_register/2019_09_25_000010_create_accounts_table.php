<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateAccountsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('accounts', function (Blueprint $table) {
            $table->increments('id');

            $table->string('code')->unique();
            
            $table->boolean('systemFlag')->default(1);
            
            $table->enum('category', ['Assets', 'Liabilities', 'Equity', 'Expenses', 'Revenue', 'Archive']);
            $table->enum('type', [
                'Business Bank'
                ,'Trust Bank'
                ,'Current Asset'
                ,'Fixed Asset'
                ,'Inventory'
                ,'Current Liability'
                ,'Long Term Liability'
                ,'Equity'
                ,'Direct Costs'
                ,'Expense'
                ,'Revenue'
            ]);
            $table->string('description');
            $table->string('notes')->nullable();
            $table->string('bankAccountInstitution')->nullable();
            $table->string('bankAccountBranch')->nullable();
            $table->string('bankAccountName')->nullable();
            $table->string('bankAccountNumber')->nullable();
            $table->string('bankAccountCode')->nullable();

            $table->unsignedInteger('taxRateId');

            $table->unsignedInteger('matterId')->nullable();
            $table->unsignedInteger('creditorId')->nullable();
            $table->unsignedInteger('disbursementId')->nullable();

            // Do we need all these?
            // $table->unsignedInteger('invoiceId')->nullable();
            // $table->unsignedInteger('receiptId')->nullable();
            // $table->unsignedInteger('paymentId')->nullable();

            $table->unsignedInteger('parentId')->nullable();

            $table->index(['category']);            
            $table->index(['category', 'type']);            

            // Forign Keys are added after all parent tables have been created in a separate migration

        });    
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('accounts');
    }
}
