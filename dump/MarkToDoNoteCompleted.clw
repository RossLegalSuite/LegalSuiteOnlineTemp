MarkToDoNoteAsCompleted PROCEDURE  (TheToDoNoteID,<DoNotSendMessageFlag>) ! Declare Procedure

  CODE
    IF CEM:SynchroniseTasksWithRemindersFlag OR TOD:OutLookTaskID
       DEBUG('CEM:SynchroniseTasksWithRemindersFlag = ' & CEM:SynchroniseTasksWithRemindersFlag & '. TOD:OutLookTaskID = ' & TOD:OutLookTaskID)
       UpdateOutLookTaskFromReminder(2) ! UPDATE THE TASK IN OUTLOOK
    END
    IF CEM:SynchroniseAppointmentsWithRemindersFlag OR TOD:OutLookAppointmentID
       UpdateOutLookAppointmentFromReminder(2) ! UPDATE THE Appointment IN OUTLOOK
    END

    IF GLO:DebuggingFlag
       SETCLIPBOARD(RowCounter{PROP:SQL})
       MESSAGE('CB|THIS REMINDER ( ' & TOD:Description & ') WAS NOT COMPLETED||IT HAS NOW BEEN TICKED USING THIS SCRIPT||Update ToDoNote SET CompletedFlag = 1, CompletedByID = ' & CEM:RecordID & ', DateDone = ' & TOD:DateDone & ', CompletedTime = ' & TOD:CompletedTime & ' WHERE RecordID = ' & TOD:RecordID,'Debugging',ICON:Exclamation)
    END


    IF CEM:ToDoNoteToFileNote

       CLEAR(FIL:Record)
       FIL:MatterID = TOD:MatterID
       FIL:Date = TODAY()
       FIL:EmployeeID = GLO:EmployeeID
       FIL:Description = TOD:Description & ' "Done"'
       FIL:InternalFlag = CEM:FileNotesInternalFlag
       !15/08/2018 PK Naidoo: FB Case 1761
       FIL:CreatedDate = GLO:TodaysDate
       FIL:CreatedTime = CLOCK()
       FIL:CreatedBy = CEM:RecordID
       Access:FileNote.Insert


    END


    CheckLinkedReminders(TOD:MatterID)         ! CHANGE THE DATE OF ANY REMINDERS WHOSE DATES ARE DEPENDENT ON THIS ONE


    IF ~TOI:RecordID

        RETURN

    ELSE


       IF TOD:DateDone AND TOI:CriticalStep

          IF TOI:CriticalStep = 8      ! ENTOMOLOGIST CERTIFICATE RECEIVED

             RowCounter{PROP:SQL} = 'UPDATE ConveyData SET EntomologistFlag = 1, EntomologistDate = ' & TOD:DateDone & ' WHERE MatterID = ' & TOD:MatterID

          ELSIF TOI:CriticalStep = 9   ! ELECTRICAL COMPLIANCE CERTIFICATE RECEIVED

             RowCounter{PROP:SQL} = 'UPDATE ConveyData SET ElectricalFlag = 1, ElectricalDate = ' & TOD:DateDone & ' WHERE MatterID = ' & TOD:MatterID

          ELSIF TOI:CriticalStep = 35   ! Plumbing COMPLIANCE CERTIFICATE RECEIVED

            RowCounter{PROP:SQL} = 'UPDATE ConveyData SET PlumbingFlag = 1, PlumbingDate = ' & TOD:DateDone & ' WHERE MatterID = ' & TOD:MatterID

          ELSIF TOI:CriticalStep = 36   ! Gas COMPLIANCE CERTIFICATE RECEIVED

            RowCounter{PROP:SQL} = 'UPDATE ConveyData SET GasFlag = 1, GasDate = ' & TOD:DateDone & ' WHERE MatterID = ' & TOD:MatterID

          ELSIF TOI:CriticalStep = 4   ! LODGED

             RowCounter{PROP:SQL} = 'UPDATE Matter SET ConveyancingStatusFlag = 3 WHERE RecordID = ' & TOD:MatterID

          ELSIF TOI:CriticalStep = 6   ! REGISTERED

             RowCounter{PROP:SQL} = 'UPDATE Matter SET ConveyancingStatusFlag = 4 WHERE RecordID = ' & TOD:MatterID

          END


       END

       IF TOD:DateDone AND TOI:RecurringFlag       ! THIS RECURRING REMINDER HAS BEEN MARKED AS "COMPLETED"

! IF GLO:DebuggingFlag
!    MESSAGE('This is a recurring Reminder. About to call InsertToDoNote with the Action set to ''Add'' and the RecurringFlag set to 1||MatterID = ' & MAT:RecordID)
! END

           InsertToDoNote(MAT:RecordID,3,0,TOI:RecurringFlag)        ! INSERT NEXT MONTH'S REMINDER

       END


    END



    IF TOD:DateDone AND ~DoNotSendMessageFlag


       IF TOI:FNBMessageNo

          IF GetMatterState(TOD:MatterID)    ! THIS IS A AG FNB MATTER

             IF AddXMLMessage(TOD:MatterID,TOI:FNBMessageNo,TOD:DateDone).

          END
       
       END


      IF TOI:WebLinkMessage

          Clear(ROW:Record)
          RowCounter{PROP:SQL} = 'Select RecordID,WebLinkBankRef From Matter Where RecordID = ' & TOD:MatterID
          If Errorcode() And ErrorCode() <> 33 Then Message('Error Select RecordID,WebLinkBankRef From Matter Where RecordID = ' & TOD:MatterID & '|Error: ' & FileError(),'MarkToDoNote',ICON:Exclamation).
          Next(RowCounter)
          If Errorcode() And ErrorCode() <> 33 Then Message('Error Next(RowCounter)|Error: ' & FileError(),'MarkToDoNote',ICON:Exclamation).

          IF ROW:Description Then A# = XMLSendWebLinkMessage(TOD:MatterID,TOI:WebLinkMessage,0).

       END

    END


   IF TOD:DateDone                                    ! THIS REMINDER HAS BEEN MARKED AS "COMPLETED"

      ProcessToDoItemEvent(TOD:MatterID,TOI:RecordID) ! PROCESS ANY EVENTS LINKED TO THE COMPLETION OF THIS REMINDER

   END






