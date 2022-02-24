CheckIfCriticalStepChanged PROCEDURE                  ! Declare Procedure

  CODE
! PRESUMES TOD:Record IS IN MEMORY

   IF ~TOD:ToDoItemID THEN RETURN.

   PROPSQLNext('SELECT CriticalStep FROM ToDoItem WHERE RecordID = ' & TOD:ToDoItemID,'CheckIfCriticalStepChanged')

   Access:ConveyData.Open
   Access:ConveyData.Usefile       
   CLEAR(CONV:Record)
   CONV:MatterID = TOD:MatterID
   IF ~Access:ConveyData.TryFetch(CONV:PrimaryKey)

!    message('CriticalStep = ' & ROW:Counter,'CheckIfCriticalStepChanged')

       CASE ROW:Counter

          OF 1

              CONV:Step1Target = TOD:Date

          OF 2 OROf 12                               ! BUYER OR MORTGAGOR SIGNED

              CONV:Step2Target = TOD:Date
              CONV:Step2Completed = TOD:DateDone

          OF 3

              CONV:Step3Target = TOD:Date
              CONV:Step3Completed = TOD:DateDone

          OF 4

              CONV:Step4Target = TOD:Date
              CONV:Step4Completed = TOD:DateDone

!    message('2 CONV:Step4Completed = ' & TOD:DateDone,'CheckIfCriticalStepChanged')



          OF 5

              CONV:Step5Target = TOD:Date
              CONV:Step5Completed = TOD:DateDone

          OF 6  ! THIS IS THE ''Bond Registered'' Reminder

              CONV:Step6Target = TOD:Date
              CONV:Step6Completed = TOD:DateDone

              IF MESSAGE('The Target Date for Registration has been changed.||Do you want to run the Tasks associated with this Event (recommended)?|','Registration date Changed',ICON:Exclamation,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:Yes
                 ProcessSystemEvent(EVENT:TargetRegistrationDateChanged,TOD:MatterID)
              END


       END

       Access:ConveyData.Update
   END

   Access:ConveyData.Close

