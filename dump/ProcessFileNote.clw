ProcessFileNote      PROCEDURE  (TheRequest)          ! Declare Procedure
LOC:ClientID        LONG
LOC:TheirRef        CSTRING(50)
LOC:Recipient       CSTRING(200)
LOC:Subject         CSTRING(200)
LOC:Body            LIKE(FIL:Description)
  CODE
      IF TheRequest = DeleteRecord THEN RETURN.

      IF GLO:CheckEventStageID      ! THIS IS SET IN UPDATEFILENOTE IF A STAGE IS INSERTED
         ProcessStageEvent(FIL:MatterID,GLO:CheckEventStageID)
         GLO:CheckEventStageID = 0
      END


      !MAKE A TODO NOTE FROM A FILE NOTE
      IF GLO:MakeToDoNoteFlag 
         CLEAR(TOD:Record)
         SETNULL(TOD:RecordID)
         IF GLO:ToDoNoteDays
            TOD:Date = GLO:ToDaysDate + GLO:ToDoNoteDays
            GLO:ToDoNoteDays = 0
         ELSE
            TOD:Date = FIL:Date
         END
         TOD:Date = CheckHoliday(TOD:Date)
         debug('GLO:ToDoNoteDescription:' & GLO:ToDoNoteDescription)
         IF GLO:ToDoNoteDescription
            TOD:Description = GLO:ToDoNoteDescription
            GLO:ToDoNoteDescription = ''
         ELSE
            TOD:Description = FIL:Description
         END
         TOD:MatterID = FIL:MatterID

         IF GLO:ToDoNoteEmployeeID
            TOD:EmployeeID = GLO:ToDoNoteEmployeeID
            GLO:ToDoNoteEmployeeID = 0
         ELSE
            TOD:EmployeeID = FIL:EmployeeID
         END
         Access:ToDoNote.UseFile

         IF ~Access:ToDoNote.Insert()
             FLUSH(ToDONote)
             Access:ToDoNote.Fetch(TOD:PrimaryKey)
             GlobalRequest = ChangeRecord
             UpdateToDoNote
          ELSE
             MESSAGE(ERROR() & '|Creating To Do Note.','Error Occured',ICON:Exclamation)
         END

         GLO:MakeToDoNoteFlag = 0

      END

      !MAKE A FEENOTE FROM A FILE NOTE
      IF GLO:MakeFeeNoteFlag 

         IF GLO:TimeRecordingFlag

            !AddTimeRecord(FIL:MatterID, FIL:RecordID)
            !14 Jun 2018 PK Naidoo: FB Case 1605
            AddTimeRecord(FIL:MatterID, FIL:RecordID, FIL:Date)

         ELSE

            AddFeeNoteFromFileNote

         END

         GLO:MakeFeeNoteFlag = 0
         GLO:MakeFeeNoteAmount = 0
      END


      !MAKE A EMAIL FROM A FILE NOTE
      IF GLO:EmailFileNoteFlag 

         GLO:EmailFileNoteFlag = 0      ! RESET IT

         IF FIL:MatterID
            LOC:ClientID = 0
            CLEAR(ROW:Record)
            ROWCounter{PROP:SQL} = 'SELECT ClientID,TheirRef FROM Matter WHERE RecordID = ' & FIL:MatterID
            NEXT(RowCounter)
            LOC:ClientID = ROW:Counter
            IF ROW:Description
               LOC:TheirRef = ROW:Description
               LOC:Subject = GetDescription('PARTY NAME',ROW:Counter) & ' (' & LOC:TheirRef & ') [' & GetDescription('Matter FileRef',FIL:MatterID) & ' - ' & GetDescription('Matter Description',FIL:MatterID) & ']'
            ELSE
               LOC:Subject = GetDescription('PARTY NAME',ROW:Counter) & ' [' & GetDescription('Matter FileRef',FIL:MatterID) & ' - ' & GetDescription('Matter Description',FIL:MatterID) & ']'
            END

            IF GLO:EmailRecipient
               LOC:Recipient = GLO:EmailRecipient
               GLO:EmailRecipient = ''
            END



            LOC:Body = Format(FIL:Date,@d17) & '<13,10>' & FIL:Description

            SendEmailMessage(FIL:MatterID,0,0,LOC:Recipient,LOC:Subject,LOC:Body)

         ELSE

            MESSAGE('Cannot email this File Note.||It is not linked to a Matter','Error sending email',ICON:Exclamation)

         END
      END

      IF GLO:InstantMessageFlag

           GLO:InstantMessageFlag = FALSE

           SendEmpMessageWithParams(FIL:MatterID,FIL:Description, 1)

           
      END

      GLO:MakeToDoNoteFlag = False
