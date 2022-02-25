<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateRemindersTable extends Migration
{
    public function up()
    {
        Schema::create('reminders', function (Blueprint $table) {
            $table->increments('id');

            $table->enum('parentType', ['Matter', 'Party', 'General'])->default('Matter');
            $table->unsignedInteger('matterId')->nullable();
            $table->unsignedInteger('partyId')->nullable();

            $table->dateTime('date');
            $table->unsignedInteger('createdById');
            $table->text('description');

            $table->date('targetDate');
            $table->unsignedInteger('targetEmployeeId');

            $table->boolean('completedFlag')->default(0);
            $table->dateTime('completedDate')->nullable();
            $table->unsignedInteger('completedEmployeeId')->nullable();

            //Used for repeating the Reminder
            $table->unsignedInteger('childId')->nullable();
            $table->unsignedInteger('parentId')->nullable();

            //If the Reminder is marked as done, and if this is Recurring Reminder, the user will be prompted to Insert it again in x days
            $table->boolean('recurringFlag')->default(0);
            $table->enum('recurringPeriod', ['Daily', 'Weekly', 'Fortnightly', 'Monthly', 'Bi Monthly', '3 Months', '6 Months', 'Yearly', 'Custom'])->default('Monthly');

            //CustomDatePeriod
            $table->enum('recurringCustomUnits', ['Days', 'Weeks', 'Months', 'Years'])->default('Days');
            $table->unsignedInteger('recurringCustomAmount')->nullable();

            $table->index(['targetDate']);
            $table->index(['parentType']);
            $table->index(['parentType', 'targetDate']);

            $table->foreign('partyId')
            ->references('id')->on('parties')
            ->onDelete('restrict');

            $table->foreign('matterId')
            ->references('id')->on('matters')
            ->onDelete('restrict');

            $table->foreign('createdById')
            ->references('id')->on('employees')
            ->onDelete('restrict');

            $table->foreign('targetEmployeeId')
            ->references('id')->on('employees')
            ->onDelete('restrict');

            $table->foreign('completedEmployeeId')
            ->references('id')->on('employees')
            ->onDelete('restrict');
        });
    }

    public function down()
    {
        Schema::dropIfExists('reminders');
    }
}
