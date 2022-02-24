UpdateToDoNote PROCEDURE                              !Generated from procedure template - Window

LOC:AddedSuspendedEmployeeID    LONG

TOD:Description:Zoomed       BYTE
TOD:CompletedByNotes:Zoomed  BYTE
SAV:PROP:ScreenText CSTRING(1000)
LOC:ValidDate               BYTE
LOC:EMailAddress            CSTRING(50)
LOC:Subject                 CSTRING(200)
LOC:ReminderCalculatedFrom  CSTRING(100)
SAV:TOD:Date                LONG
SAV:DateDone                LONG
LOC:UsingLOCDescriptionFlag BYTE
LOC:EmailBodyString         CSTRING(500)
CurrentTab           STRING(80)
LOC:Period           CSTRING(255)
LOC:Recurring        BYTE
SAV:MatterID         LONG
LOC:Matter           CSTRING(50)
FilesOpened          BYTE
ezField              LONG
ActionMessage        CSTRING(40)
LOC:NextDocument     CSTRING(100)
LOC:Employee         CSTRING(50)
LOC:MatterDescription CSTRING(75)
LOC:CompletedBy      CSTRING(50)
LOC:LookupPropText   STRING(2)
LOC:SendEmpMessageFlag BYTE
LOC:SendEmailFlag    BYTE
LOC:CreatedByEmployee CSTRING(20)
LOC:Description      CSTRING(1000)
LOC:CreateOutLookTaskFlag BYTE
LOC:CreateOutLookAppointmentFlag BYTE
LOC:CreatedDate      CSTRING(20)
LOC:RecurringDays    LONG
SAV:LOC:CreateOutLookTaskFlag   BYTE(255)
SAV:LOC:CreateOutLookAppointmentFlag   BYTE(255)

LOC:Selected             LONG
SAV:LOC:Description      LIKE(LOC:Description)
SAV:TOD:Description      LIKE(TOD:Description)
SAV:TOD:CompletedByNotes LIKE(TOD:CompletedByNotes)

SAV:CompletedFlag       BYTE(255)
INITIAL:CompletedFlag   BYTE
LSF:CheckFieldFlag   Byte
LocalSecFieldQueue   Queue,Pre()
LSFQ:Field             Long
LSFQ:Description       CString(255)
LSFQ:HideFlag          Byte
LSFQ:DisableFlag       Byte
                     .
ThisSecProc    Class()
Init              PROCEDURE(),BYTE,PROC
SetFields         PROCEDURE(),BYTE,PROC
Kill              PROCEDURE(),BYTE,PROC
CheckAccess       PROCEDURE(),BYTE,PROC
Update            PROCEDURE(),BYTE,PROC
                End
QuickWindow          WINDOW('ToDoNote Update Form'),AT(,,397,244),FONT('Arial',9,,),CENTER,IMM,ICON('TODONOTE.ICO'),TIMER(500),SYSTEM,GRAY,DOUBLE,MDI
                       SHEET,AT(1,2,393,212),USE(?Sheet1)
                         TAB('  General   '),USE(?Tab1)
                           GROUP('Created By'),AT(5,18,385,28),USE(?CreatedGroup),BOXED,TRN
                             PROMPT('Employee:'),AT(12,30),USE(?LOC:CreatedByEmployee:Prompt),TRN
                             ENTRY(@s19),AT(59,30,123,10),USE(LOC:CreatedByEmployee),SKIP,FONT('MS Sans Serif',,,),COLOR(0D2D2D2H),TIP('Who created this Reminder<13,10>TOD:CreatedByID'),READONLY
                             PROMPT('On:'),AT(187,30),USE(?TOD:CreatedDate:Prompt),TRN
                             ENTRY(@s19),AT(203,30,63,10),USE(LOC:CreatedDate),SKIP,LEFT(1),FONT('MS Sans Serif',,,),COLOR(0D2D2D2H),TIP('The date the Reminder was created<13,10>TOD:CreatedDate'),READONLY
                             PROMPT('Time:'),AT(267,30),USE(?TOD:Time:Prompt),TRN
                             ENTRY(@t3),AT(291,30,43,10),USE(TOD:CreatedTime),SKIP,LEFT(1),FONT('MS Sans Serif',,,),COLOR(0D2D2D2H),TIP('The time the Reminder was created<13,10>TOD:CreatedTime'),READONLY
                           END
                           GROUP('For Action'),AT(5,48,385,58),USE(?ReminderGroup),BOXED,TRN
                             PROMPT('Target D&ate:'),AT(10,60),USE(?Prompt3),TRN
                             SPIN(@d17),AT(67,60,56,10),USE(TOD:Date),FONT('MS Sans Serif',,,),TIP('Date this task must be done on<13,10>TOD:Date'),STEP(1)
                             PROMPT('&Employee:'),AT(143,60),USE(?Prompt5),TRN
                             LIST,AT(179,60,123,10),USE(LOC:Employee),VSCROLL,FORMAT('196L(2)|M@s49@'),DROP(25),FROM(GEMPQ:EmployeeQueue)
                             BUTTON('...'),AT(307,60,10,10),USE(?LookupEmployeeButton),SKIP,TIP('Lookup an employee')
                             PROMPT('&Description:'),AT(10,75),USE(?Prompt4),TRN
                             BUTTON,AT(53,74,11,11),USE(?Description:ZoomButton),SKIP,TIP('Expand the entry field'),ICON(ICON:Paste)
                             ENTRY(@s255),AT(67,74,303,10),USE(LOC:Description),IMM,FONT('MS Sans Serif',,,),TIP('What must be done<13,10>TOD:Description'),ALRT(CtrlUp),ALRT(CtrlDown),ALRT(UpKey),ALRT(DownKey),REQ
                             TEXT,AT(67,74,303,10),USE(TOD:Description),IMM,TIP('What must be done<13,10>Press F12 to check the spelling<13,10>TOD:Description'),REQ,SINGLE
                             BUTTON,AT(375,74,10,10),USE(?LookupLibraryButton),SKIP,TIP('Lookup and insert text from the Lookup Library (Ctrl L)'),KEY(CtrlL),ICON('Lookup.ico')
                             PROMPT('&Matter:'),AT(10,88),USE(?LOC:Matter:Prompt),TRN
                             ENTRY(@s49),AT(67,88,63,10),USE(LOC:Matter),IMM,FONT('MS Sans Serif',,,),COLOR(0BDFFFFH),TIP('The Matter this Reminder is related to<13,10>This is an auto-complete field, i.e. typ' &|
   'e the first few character to locate the entry<13,10>TOD:MatterID'),REQ
                             ENTRY(@s74),AT(135,88,235,10),USE(LOC:MatterDescription),SKIP,FONT('MS Sans Serif',,,),COLOR(0D2D2D2H),READONLY
                             BUTTON('...'),AT(375,88,10,10),USE(?LookupMatterButton),SKIP
                           END
                           GROUP('Completed By'),AT(5,108,385,46),USE(?Group1),BOXED,TRN
                             CHECK('Done?'),AT(12,122),USE(TOD:CompletedFlag),TRN,TIP('This Reminder has been attended to<13,10>TOD:CompletedFlag')
                             SPIN(@d17b),AT(66,121,56,10),USE(TOD:DateDone),FONT('MS Sans Serif',,,),TIP('Date this Reminder was completed<13,10>TOD:DateDone'),STEP(1)
                             PROMPT('Done &By:'),AT(142,122),USE(?CompletedBy:Prompt),TRN
                             LIST,AT(178,122,123,10),USE(LOC:CompletedBy),VSCROLL,FORMAT('196L(2)|M@s49@'),DROP(25),FROM(GEMPQ1:EmployeeQueue1)
                             BUTTON('...'),AT(306,122,10,10),USE(?LookupEmployeeButton:2),SKIP,TIP('Lookup an employee')
                             PROMPT('No&tes:'),AT(12,139),USE(?TOD:CompletedByNotes:Prompt),TRN
                             BUTTON,AT(52,137,11,11),USE(?Description:ZoomButton:2),SKIP,LEFT,TIP('Expand the entry field'),ICON(ICON:Paste)
                             TEXT,AT(66,138,303,10),USE(TOD:CompletedByNotes),IMM,TIP('Notes regarding the completion of this task (e.g. why it is late)<13,10>TOD:Completed' &|
   'ByNotes'),ALRT(CtrlUp),ALRT(CtrlDown),SINGLE
                             BUTTON,AT(371,138,10,10),USE(?LookupLibraryButton:2),SKIP,TIP('Lookup and insert text from the Lookup Library (Ctrl L)'),KEY(CtrlL),ICON('Lookup.ico')
                           END
                           GROUP('Options'),AT(5,156,385,54),USE(?OptionsGroup),BOXED,TRN
                             PROMPT('Next Document'),AT(12,169),USE(?Prompt6),TRN
                             ENTRY(@s99),AT(73,169,292,10),USE(LOC:NextDocument),SKIP,FONT('MS Sans Serif',,,),COLOR(0D2D2D2H),TIP('The Document the user can assemble after completing the Reminder<13,10>TOD:NextDocume' &|
   'ntID'),READONLY
                             BUTTON('...'),AT(369,169,10,10),USE(?NextDocumentButton),SKIP,TIP('Lookup a List of Documents')
                             CHECK('&Send an Instant Message'),AT(12,183),USE(LOC:SendEmpMessageFlag),TRN,TIP('Send an instant message to the Employee based on this Reminder')
                             CHECK('Se&nd an Email message'),AT(121,183),USE(LOC:SendEmailFlag),TRN,TIP('Send the Employee an Email based on this Reminder?')
                             CHECK('Create a Task in OutLook'),AT(12,197),USE(LOC:CreateOutLookTaskFlag),TRN,TIP('Create a Task in OutLook based on this Reminder')
                             CHECK('Create an Appointment in OutLook'),AT(121,197),USE(LOC:CreateOutLookAppointmentFlag),TRN,TIP('Create an Appointment in OutLook based on this Reminder')
                             PROMPT('&Importance'),AT(249,197),USE(?TOD:Priority:Prompt),TRN
                             LIST,AT(292,197,63,10),USE(TOD:Priority),VSCROLL,TIP('The Recurring Period<13,10>'),FORMAT('196L(2)|M@s49@'),DROP(25),FROM('Low|#0|Medium|#1|High|#2')
                             CHECK('C&harge the Client for this email'),AT(249,183),USE(GLO:ConfirmEmailChargeFlag),SKIP,TRN,TIP('Charge the Client a Fee for this email<13,10>See Setup | Employees for the Fee Code t' &|
   'hat will be used')
                           END
                         END
                         TAB('  Advanced   '),USE(?Tab2)
                           GROUP('Recurring Reminder'),AT(5,18,253,34),USE(?Group5),BOXED
                             CHECK('Repeat this Reminder'),AT(11,32,79,10),USE(TOD:RecurringFlag),TRN,TIP('This is a Recurring Reminder')
                             LIST,AT(136,33,106,10),USE(TOD:RecurringPeriod),VSCROLL,TIP('The Recurring Period<13,10>'),FORMAT('196L(2)|M@s49@'),DROP(25),FROM('Daily|#Daily|Weekly|#Weekly|Fortnightly|#Fortnightly|Monthly|#Monthly|Bi-Monthly|#Bi-Monthly|6-Months|#6-Months|Yearly|#Yearly|Custom|#Custom')
                             BUTTON('...'),AT(244,33,9,10),USE(?CustomRecurringPeriodButton),DISABLE,TIP('Specify the Custom Date Period<13,10>')
                             PROMPT('Period:'),AT(112,33),USE(?LOC:Period:Prompt),TRN
                           END
                         END
                       END
                       BUTTON('&OK'),AT(267,219,60,20),USE(?ToDoOK),LEFT,FONT(,11,,),ICON('check3.ico'),DEFAULT
                       BUTTON('&Cancel'),AT(332,219,60,20),USE(?Cancel),LEFT,FONT(,11,,),ICON('delete32.ico')
                       BUTTON('Make a File Note'),AT(3,220,87,20),USE(?MakeFileNoteButton),LEFT,TIP('Create a File Note linked to this Reminder.'),ICON('C:\lsw\Icons\document_edit.ico')
                     END

PDPC:TOD:Date        CLASS(PDPopCalBtnCT)
TakeAccepted           PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDPC:TOD:DateDone    CLASS(PDPopCalBtnCT)
TakeAccepted           PROCEDURE,BYTE,PROC,VIRTUAL
                     END
ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Open                   PROCEDURE(),DERIVED
PrimeFields            PROCEDURE(),PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeCloseEvent         PROCEDURE(),BYTE,PROC,DERIVED
TakeCompleted          PROCEDURE(),BYTE,PROC,DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
TakeFieldEvent         PROCEDURE(),BYTE,PROC,DERIVED
TakeNewSelection       PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
Update                 PROCEDURE(),DERIVED
                     END

Toolbar              ToolbarClass
ToolbarForm          ToolbarUpdateClass               !Form Toolbar Manager
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END

CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
                    END

  CODE
  GlobalResponse = ThisWindow.Run()


ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request
  OF ViewRecord
    ActionMessage = 'View Record'
  OF InsertRecord
    ActionMessage = 'Adding a Reminder'
  OF ChangeRecord
    ActionMessage = 'Changing a Reminder'
  END
  QuickWindow{Prop:Text} = ActionMessage
    IF CheckMatterAccess(TOD:MatterID)  ! ADDED 8/11/2010
         0{PROP:Text} = 'Reminder [View Only]'
         ?ToDoOK{PROP:Disable} = True
    END
  
    ! 27/08/2018 PK Naidoo: FB Case 1828
    IF TOD:RecordID 
        0{Prop:Text} = 0{Prop:Text} & ' (' & TOD:RecordID & ')'
    END
  
  
    IF CTL:FileNoteReminderFlag AND TOD:RecordID > 0
       UNHIDE(?MakeFileNoteButton)
    ELSE
       HIDE(?MakeFileNoteButton)
    END
  
  
    IF TOD:RecurringPeriod = ''
  
       TOD:RecurringPeriod = 'Daily'
  
    ELSIF TOD:RecurringPeriod = 'Custom'
  
       ?CustomRecurringPeriodButton{PROP:Disable} = FALSE
  
    ELSE
  
       ?CustomRecurringPeriodButton{PROP:Disable} = TRUE
  
    END
  
    ! 09/07/2019 PK Naidoo - FB Case 2383
    IF LOC:SendEmailFlag
    
       ?GLO:ConfirmEmailChargeFlag{PROP:Disable} = FALSE
  
    ELSE
    
       ?GLO:ConfirmEmailChargeFlag{PROP:Disable} = TRUE
       GLO:ConfirmEmailChargeFlag = FALSE
    END
  
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    ThisSecProc.Init()
  GlobalErrors.SetProcedureName('UpdateToDoNote')
  SELF.Request = GlobalRequest
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?LOC:CreatedByEmployee:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)
  CLEAR(GlobalResponse)
  SELF.AddUpdateFile(Access:ToDoNote)
  SELF.AddItem(?Cancel,RequestCancelled)
  Relate:Employee.Open
  Relate:Library.Open
  Relate:Matter.Open
  Relate:ToDoItemEvent.Open
  Relate:ToDoNote.Open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:ToDoNote
  IF SELF.Request = ViewRecord
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = 0
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.DeleteAction = Delete:Auto
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = ?ToDoOK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  IF TOD:CompletedFlag
     SELF.FirstField = ?TOD:CompletedByNotes
  ELSE
     SELF.FirstField = ?TOD:Date
  END

  SAV:TOD:Date = TOD:Date
  SAV:DateDone = TOD:DateDone


  IF ~TOD:CreatedTime
      TOD:CreatedTime = CLOCK()
  END
  IF ~TOD:CreatedDate
      IF TOD:Date
         TOD:CreatedDate = TOD:Date
      ELSE
         TOD:CreatedDate = GLO:TodaysDate
      END
  END
  LOC:CreatedDate = FORMAT(TOD:CreatedDate,@D17)


  IF ~TOD:CreatedByID
      TOD:CreatedByID = CEM:RecordID
  END

  LOC:CreatedByEmployee = GETDescription('Employee',TOD:CreatedByID)
  

  IF TOD:EmployeeID
     LOC:Employee = GETDescription('Employee',TOD:EmployeeID)
  END

  IF TOD:CompletedByID
     LOC:CompletedBy = GETDescription('Employee',TOD:CompletedByID)
  END


  IF TOD:NextDocumentID
     LOC:NextDocument = GETDescription('Document',TOD:NextDocumentID)
  END

  If TOD:MatterID
     LOC:Matter = GetDescription('Matter FileRef',TOD:MatterID)
     LOC:MatterDescription = GetDescription('Matter Description',TOD:MatterID)
  END

  INITIAL:CompletedFlag = TOD:CompletedFlag

  IF TOD:RecurringPeriod = 'Custom'

     ?CustomRecurringPeriodButton{PROP:Disable} = FALSE

  ELSE

     ?CustomRecurringPeriodButton{PROP:Disable} = TRUE

  END



  OPEN(QuickWindow)
  SELF.Opened=True
  IF TOD:ToDoItemID
      CLEAR(ROW:Record)
      RowCounter{PROP:SQL} = 'SELECT BaseDateOtherID,BaseDateOption,Days,0,0,BaseDateOptionOther,BeforeAfterOption,Code FROM ToDoItem WHERE RecordID = ' & TOD:ToDoItemID
      NEXT(RowCounter)
      IF ROW:Description

         LOC:ReminderCalculatedFrom = CLIP(LEFT(FORMAT(ROW:Amount1,@n_5)))

         IF ROW:Description2 = 'B'
            LOC:ReminderCalculatedFrom = LOC:ReminderCalculatedFrom & ' days before'
         ELSE
            LOC:ReminderCalculatedFrom = LOC:ReminderCalculatedFrom & ' days after'
         END

         CASE ROW:Description
            OF 'T'
               LOC:ReminderCalculatedFrom = LOC:ReminderCalculatedFrom & ' Today''s Date'
            OF 'I'
               LOC:ReminderCalculatedFrom = LOC:ReminderCalculatedFrom & ' the Date of Instruction'
            OF 'C'
               LOC:ReminderCalculatedFrom = LOC:ReminderCalculatedFrom & ' the Court Date'
            OF 'L'
               LOC:ReminderCalculatedFrom = LOC:ReminderCalculatedFrom & ' the Target Lodgement Date'
            OF 'O'
               LOC:ReminderCalculatedFrom = LOC:ReminderCalculatedFrom & ' ' &  ROW:Description1 & ' (' & EVALUATE(ROW:Description1) & ')'
            OF 'R'
               LOC:ReminderCalculatedFrom = LOC:ReminderCalculatedFrom & ' "' & GetDescription('TODOITEM',ROW:Counter) & '"'
            ELSE
               LOC:ReminderCalculatedFrom = LOC:ReminderCalculatedFrom & ' an unknown base date (' & ROW:Description & ')'
        END
  
         ?TOD:Date{PROP:Tooltip} = 'This item (' & ROW:Description3 & ') is a calculated date.' &|
         '<13,10>' & LOC:ReminderCalculatedFrom & '.' &|
         '<13,10>It has been adjusted manually by ' & CLIP(LEFT(FORMAT(TOD:DateAdjustment,@N-_5))) & ' days' &|
         '<13,10>TOD:Date'
  
      END
  
  END

  ! 04/10/2018 PK Naidoo - FB Case 1818
  IF CEM:SynchroniseTasksWithRemindersFlag
     LOC:CreateOutLookTaskFlag = TRUE
  END

  IF CEM:SynchroniseAppointmentsWithRemindersFlag
     LOC:CreateOutLookAppointmentFlag = TRUE
  END

!  IF CEM:SynchroniseTasksWithRemindersFlag
!     HIDE(?LOC:CreateOutLookTaskFlag)
!  END
!
!  IF CEM:SynchroniseAppointmentsWithRemindersFlag
!     HIDE(?LOC:CreateOutLookAppointmentFlag)
!  ELSE
!
!      IF CEM:SynchroniseTasksWithRemindersFlag
!         ?LOC:CreateOutLookAppointmentFlag{PROP:XPos} = ?LOC:CreateOutLookTaskFlag{PROP:XPos}
!      END
!
!
!  END
!
!
!  IF CEM:SynchroniseTasksWithRemindersFlag AND CEM:SynchroniseAppointmentsWithRemindersFlag
!     0{PROP:Height} = 0{PROP:Height} - 20
!     ?OptionsGroup{PROP:Height} = ?OptionsGroup{PROP:Height} - 20
!     ?ToDoOK{PROP:YPos} = ?ToDoOK{PROP:YPos} - 20
!     ?Cancel{PROP:YPos} = ?Cancel{PROP:YPos} - 20
!  END

  IF TOD:RecurringFlag

     IF TOD:RecurringPeriod = ''

       TOD:RecurringPeriod = 'Daily'

     ELSIF TOD:RecurringPeriod = 'Custom'

       ?CustomRecurringPeriodButton{PROP:Disable} = FALSE

     ELSE

       ?CustomRecurringPeriodButton{PROP:Disable} = TRUE

     END

     ?TOD:RecurringPeriod{PROP:Disable} = FALSE
     ?LOC:Period:Prompt{PROP:Disable} = FALSE

  ELSE

     ?TOD:RecurringPeriod{PROP:Disable} = TRUE
     ?CustomRecurringPeriodButton{PROP:Disable} = TRUE
     ?LOC:Period:Prompt{PROP:Disable} = TRUE

  END

       QuickWindow{Prop:Alrt,254}=1024
       QuickWindow{Prop:Alrt,255}=AltF12
  PDPC:TOD:Date.Init(?TOD:Date,TOD:Date,PopCalQ,Def_Config,)
  PDPC:TOD:DateDone.Init(?TOD:DateDone,TOD:DateDone,PopCalQ,Def_Config,)
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)
  SELF.AddItem(Resizer)
  ! DOING THIS SO PREMEPTIVE TEXT WORKS
  
  IF LEN(TOD:Description) > 255
     UNHIDE(?TOD:Description)
     HIDE(?LOC:Description)
     LOC:UsingLOCDescriptionFlag = FALSE
  ELSE
     LOC:Description = TOD:Description
     HIDE(?TOD:Description)
     UNHIDE(?LOC:Description)
     LOC:UsingLOCDescriptionFlag = TRUE
  END
  
  
     GEMPQ:RecordID = TOD:EmployeeID
     GET(GEMPQ:EmployeeQueue,GEMPQ:RecordID)
  
     IF ERROR()         ! THE USER MAY BE SUSPENDED SO ADD THEM TEMPORARILY TO THE GEMPQ: SO THE DROP DOWN WORKS AS NORMAL  (AND TAKE THEM OUT WHEN CLOSING THIS WINDOW)
  
       CLEAR(GEMPQ:EmployeeQueue)
       GEMPQ:Name = GETDescription('Employee',TOD:EmployeeID)
  
       IF GEMPQ:Name
  
          GEMPQ:RecordID = TOD:EmployeeID
          ADD(GEMPQ:EmployeeQueue,GEMPQ:Name)
  
          LOC:AddedSuspendedEmployeeID = TOD:EmployeeID
  
          LOC:Employee = GEMPQ:Name
          ?LOC:Employee{PROP:Selected} = POSITION(GEMPQ:EmployeeQueue)
  
       END
  
     ELSE
  
         LOC:Employee = GEMPQ:Name
         ?LOC:Employee{PROP:Selected} = POSITION(GEMPQ:EmployeeQueue)
  
     END
  
  
  
  
  GEMPQ1:RecordID = TOD:CompletedByID
  GET(GEMPQ1:EmployeeQueue1,GEMPQ1:RecordID)
  IF ~ERROR() THEN ?LOC:CompletedBy{PROP:Selected} = POSITION(GEMPQ1:EmployeeQueue1).
  
  SELF.AddItem(ToolbarForm)
  SELF.SetAlerts()
    ThisSecProc.SetFields()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  PDPC:TOD:Date.Kill
  PDPC:TOD:DateDone.Kill
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Employee.Close
    Relate:Library.Close
    Relate:Matter.Close
    Relate:ToDoItemEvent.Close
    Relate:ToDoNote.Close
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Open PROCEDURE

  CODE
  PARENT.Open
!JESS
     SAV:MatterID = TOD:MatterID
     AddToFavourites(TOD:MatterID)



ThisWindow.PrimeFields PROCEDURE

  CODE
    OMIT('***Omit this***')
    TOD:Date = GLO:TodaysDate
    TOD:MatterID = MAT:RecordId
    TOD:AutoNotifyDate = 0
    ***Omit this***
  
    IF ~TOD:Date
        DEBUG('No TOD:Date')
        TOD:Date = GLO:TodaysDate
    END
    TOD:MatterID = MAT:RecordId
    TOD:AutoNotifyDate = 0
  
    IF GLO:TOD_EmployeeID > 0
       TOD:EmployeeID = GLO:TOD_EmployeeID
    ELSE
       TOD:EmployeeID = GLO:EmployeeID
    END
    IF ~TOD:EmployeeID
        TOD:EmployeeID = MAT:EmployeeID
    END
  
  
    TOD:CreatedTime = CLOCK()
    TOD:CreatedDate = GLO:TodaysDate
    TOD:CreatedByID = CEM:RecordID
  
  
  PARENT.PrimeFields


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    If Self.Request = ChangeRecord AND TOD:MatterID
       IF RestrictedMatter(TOD:MatterID,0)
          Return RequestCancelled
       END
    END
    If ThisSecProc.CheckAccess() Then Return RequestCancelled.
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled
  END
     IF LOC:AddedSuspendedEmployeeID
  
        GEMPQ:RecordID = LOC:AddedSuspendedEmployeeID
        
        GET(GEMPQ:EmployeeQueue,GEMPQ:RecordID)
        IF ~ERROR()
            DELETE(GEMPQ:EmployeeQueue)
        END
     END
  
  
  
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled
  ELSE
    GlobalRequest = Request
    EXECUTE Number
      BrowseLookup
      BrowseLookup
    END
    ReturnValue = GlobalResponse
  END
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE ACCEPTED()
    OF ?LOC:Employee
        GET(GEMPQ:EmployeeQueue,CHOICE())
        TOD:EmployeeID = GEMPQ:RecordID
        
    OF ?LOC:Description
        IF LOC:UsingLOCDescriptionFlag
           TOD:Description = LOC:Description
        END
      
    OF ?LOC:Matter
      OMIT('****TwoFields****')
        If ~(TOD:MatterID) Then Cycle.
        Update(?)
        MAT:FileRef = Contents(?)
        Access:Matter.Fetch(MAT:FileRefKey)
        TOD:MatterID = MAT:RecordID
        If MAT:FileRef <> Contents(?)
          Select(?)
          Cycle
        .
      !****TwoFields****
        If ~(TOD:MatterID) Then Cycle.
        Update(?)
        MAT:FileRef = Contents(?)
        Access:Matter.Fetch(MAT:FileRefKey)
        TOD:MatterID = MAT:RecordID
        LOC:MatterDescription = GetDescription('Matter Description',TOD:MatterID)
        If MAT:FileRef <> Contents(?)
          Select(?)
          Cycle
        .
    OF ?LOC:CompletedBy
        GET(GEMPQ1:EmployeeQueue1,CHOICE())
        TOD:CompletedByID = GEMPQ1:RecordID
    OF ?LOC:SendEmailFlag
      ! 09/07/2019 PK Naidoo - FB Case 2383
      IF LOC:SendEmailFlag
      
         ?GLO:ConfirmEmailChargeFlag{PROP:Disable} = FALSE
      
      ELSE
      
         ?GLO:ConfirmEmailChargeFlag{PROP:Disable} = TRUE
         GLO:ConfirmEmailChargeFlag = FALSE
      
      END
    OF ?TOD:RecurringFlag
      IF TOD:RecurringFlag
      
         IF TOD:RecurringPeriod = ''
      
           TOD:RecurringPeriod = 'Daily'
      
         ELSIF TOD:RecurringPeriod = 'Custom'
      
        
      
           ?CustomRecurringPeriodButton{PROP:Disable} = FALSE
      
         ELSE
      
           ?CustomRecurringPeriodButton{PROP:Disable} = TRUE
      
         END
      
         ?TOD:RecurringPeriod{PROP:Disable} = FALSE
         ?LOC:Period:Prompt{PROP:Disable} = FALSE
      
      ELSE
      
         ?TOD:RecurringPeriod{PROP:Disable} = TRUE
         ?CustomRecurringPeriodButton{PROP:Disable} = TRUE
         ?LOC:Period:Prompt{PROP:Disable} = TRUE
      
      END
    OF ?TOD:RecurringPeriod
      IF TOD:RecurringPeriod = 'Custom'
      
         ?CustomRecurringPeriodButton{PROP:Disable} = FALSE
      
      ELSE
      
         ?CustomRecurringPeriodButton{PROP:Disable} = TRUE
      
      END
      
    OF ?CustomRecurringPeriodButton
      GetCustomDateRange(TOD:RecurringCustomAmount,TOD:RecurringCustomType,TOD:RecurringCustomAmount,TOD:RecurringCustomType)
      
    OF ?ToDoOK
      IF ~TOD:CompletedFlag  ! CHECK IF THE DATE IS VALID IF INSERTING AND NOT ALREADY COMPLETED
      
          IF TOD:Date AND TOD:Date < GLO:TodaysDate
             IF MESSAGE('The date is prior to todays date.||Are you sure this is correct?||Do you want to re-enter the date?','Confirm Date',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes,1) = BUTTON:Yes
                SELECT(?TOD:Date)
                CYCLE
             END
          END
      
      
          LOC:ValidDate = CheckIfHoliday(TOD:Date)
      
          IF GLO:DebuggingFlag  AND LOC:ValidDate
             MESSAGE('TOD:Date was ' & format(TOD:Date,@d17))
          END
      
      
          IF LOC:ValidDate = 2
             IF MESSAGE('The date falls on a weekend.||Do you want the program to assign it to the next available working day?','Confirm Date',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes,1) = BUTTON:Yes
                TOD:Date = CheckHoliday(TOD:Date)
                DISPLAY(?TOD:Date)
             END
          ELSIF LOC:ValidDate = 1
             IF MESSAGE('The date falls on a public holiday.||Do you want the program to assign it to the next available working day?','Confirm Date',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes,1) = BUTTON:Yes
                TOD:Date = CheckHoliday(TOD:Date)
                DISPLAY(?TOD:Date)
             END
          END
      
          IF GLO:DebuggingFlag  AND LOC:ValidDate
             MESSAGE('TOD:Date now is ' & format(TOD:Date,@d17))
          END
      ELSE
          ! 20/08/2018 PK Naidoo: If the Reminder is marked as done, and if this is Recurring Reminder, the user will be prompted to Insert it again in x days
          IF TOD:RecurringFlag
      
              RecurringReminder(TOD:DateDone + LOC:RecurringDays,TOD:RecordID)
      
          END
      END
      
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?LookupEmployeeButton
      ThisWindow.Update
            GlobalRequest = SelectRecord
            SelectEmployee
            IF GlobalResponse = RequestCompleted
               TOD:EmployeeID = EMP:RecordID
               LOC:Employee = EMP:Name
            END
            DISPLAY
      
    OF ?Description:ZoomButton
      ThisWindow.Update
            IF TOD:Description:Zoomed

               TOD:Description:Zoomed = FALSE
               ?TOD:Description{PROP:Single} = TRUE
               ?TOD:Description{PROP:Height} = 10
               ?TOD:Description{PROP:VScroll} = False
            
               ?LOC:Matter{PROP:Hide} = False
               ?LOC:MatterDescription{PROP:Hide} = False
               ?Description:ZoomButton{PROP:Tooltip} = 'Expand the entry field'

            ELSE

               TOD:Description:Zoomed = TRUE

               IF LOC:UsingLOCDescriptionFlag

                  TOD:Description = LOC:Description

                   !  MESSAGE('LOC:Description = ' & LOC:Description &|
                   !          '|TOD:Description = ' & TOD:Description)

                  UNHIDE(?TOD:Description)
                  DISPLAY(?TOD:Description)
                  HIDE(?LOC:Description)
                  LOC:UsingLOCDescriptionFlag = FALSE
               END

               ?TOD:Description{PROP:Single} = FALSE
               ?TOD:Description{PROP:Height} = 40
               ?TOD:Description{PROP:VScroll} = True
            
               ?LOC:Matter{PROP:Hide} = True
               ?LOC:MatterDescription{PROP:Hide} = True
               ?Description:ZoomButton{PROP:Tooltip} = 'Contract the entry field'

            END

            SELECT(?TOD:Description)

    OF ?LOC:Description
      
    OF ?TOD:Description
      
    OF ?LookupLibraryButton
      ThisWindow.Update
      GLO:TooltipCategory = ?TOD:Description{PROP:Tooltip}
      IF GLO:TooltipCategory
      
         FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
         IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
      
         SAV:PROP:SelStart# = ?TOD:Description{PROP:SelStart}
         GLO:TooltipContents = ?TOD:Description{PROP:ScreenText}
         GlobalRequest = SelectRecord
         BrowseLookup
         IF GlobalResponse = RequestCompleted
            LIB:Description = ReplaceTextBoxFields(LIB:Description,0,-1,-1,0)
            IF TOD:Description     ! IF THERE ALREADY IS TEXT IN THIS FIELD
               IF SAV:PROP:SelStart#  >= LEN(TOD:Description) ! THE CURSOR IS AT THE END
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                     TOD:Description = LIB:Description
                     TOD:Description =  TOD:Description & LIB:Description
                  END
               ELSE
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                     TOD:Description = LIB:Description
                     TOD:Description =  SUB(Contents(?TOD:Description),1,SAV:PROP:SelStart#-1) & LIB:Description & SUB(Contents(?TOD:Description),SAV:PROP:SelStart#,1000)
                  END
               END
            ELSE
              TOD:Description = LIB:Description
            END
            DISPLAY(?TOD:Description)
            SELECT(?TOD:Description,SAV:PROP:SelStart# + LEN(LIB:Description))
         END
         CLEAR(GlobalRequest)
      ELSE
         MESSAGE('This Field does not have a Tooltip.||Unable to display the lookup library.','Program Error',ICON:Exclamation)
      END
      
      
      
      
       IF LOC:UsingLOCDescriptionFlag AND GlobalResponse = RequestCompleted
      
          LOC:Description = TOD:Description
      
          DISPLAY(?LOC:Description)
      
       END
    OF ?LOC:Matter
!JESS
     IF ~(SAV:MatterID = TOD:MatterID)
          SAV:MatterID = TOD:MatterID
          AddToFavourites(TOD:MatterID)
     END

    OF ?LookupMatterButton
      ThisWindow.Update
      GlobalRequest = SelectRecord
      SelectMatterAlias
      IF GlobalResponse = RequestCompleted
         LOC:Matter = GetDescription('Matter FileRef',MAT1:RecordID)
         LOC:MatterDescription = GetDescription('Matter Description',MAT1:RecordID)
         TOD:MatterID = MAT1:RecordID
         DISPLAY
         IF ~(SAV:MatterID = TOD:MatterID)
              SAV:MatterID = TOD:MatterID
              AddToFavourites(TOD:MatterID)
         END
      END
    OF ?LookupEmployeeButton:2
      ThisWindow.Update
            GlobalRequest = SelectRecord
            SelectEmployee
            IF GlobalResponse = RequestCompleted
               TOD:CompletedByID = EMP:RecordID
               LOC:CompletedBy = EMP:Name
            END
            DISPLAY
      
    OF ?Description:ZoomButton:2
      ThisWindow.Update
      
            IF TOD:CompletedByNotes:Zoomed
               TOD:CompletedByNotes:Zoomed = FALSE
               ?TOD:CompletedByNotes{PROP:Single} = TRUE
               ?TOD:CompletedByNotes{PROP:Height} = 10
               ?TOD:CompletedByNotes{PROP:VScroll} = False
      
      
               ?OptionsGroup{PROP:Boxed} = 1
               ?Prompt6{PROP:Hide} = False
               ?LOC:NextDocument{PROP:Hide} = False
      
      
               ?Description:ZoomButton:2{PROP:Tooltip} = 'Expand the entry field'
            
            ELSE
      
               TOD:CompletedByNotes:Zoomed = TRUE
               ?TOD:CompletedByNotes{PROP:Single} = FALSE
               ?TOD:CompletedByNotes{PROP:Height} = 40
               ?TOD:CompletedByNotes{PROP:VScroll} = True
            
               ?OptionsGroup{PROP:Boxed} = 0
               ?Prompt6{PROP:Hide} = True
               ?LOC:NextDocument{PROP:Hide} = True
      
               ?Description:ZoomButton:2{PROP:Tooltip} = 'Contract the entry field'

               DISPLAY(?TOD:CompletedByNotes)
      
             END
      
             SELECT(?TOD:CompletedByNotes)
      
      
      
    OF ?LookupLibraryButton:2
      ThisWindow.Update
      GLO:TooltipCategory = ?TOD:CompletedByNotes{PROP:Tooltip}
      IF GLO:TooltipCategory
      
         FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
         IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
      
         SAV:PROP:SelStart# = ?TOD:CompletedByNotes{PROP:SelStart}
         GLO:TooltipContents = ?TOD:CompletedByNotes{PROP:ScreenText}
         GlobalRequest = SelectRecord
         BrowseLookup
         IF GlobalResponse = RequestCompleted
            LIB:Description = ReplaceTextBoxFields(LIB:Description,0,-1,-1,0)
            IF TOD:CompletedByNotes     ! IF THERE ALREADY IS TEXT IN THIS FIELD
               IF SAV:PROP:SelStart#  >= LEN(TOD:CompletedByNotes) ! THE CURSOR IS AT THE END
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                     TOD:CompletedByNotes = LIB:Description
                     TOD:CompletedByNotes =  TOD:CompletedByNotes & LIB:Description
                  END
               ELSE
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                     TOD:CompletedByNotes = LIB:Description
                     TOD:CompletedByNotes =  SUB(Contents(?TOD:CompletedByNotes),1,SAV:PROP:SelStart#-1) & LIB:Description & SUB(Contents(?TOD:CompletedByNotes),SAV:PROP:SelStart#,1000)
                  END
               END
            ELSE
              TOD:CompletedByNotes = LIB:Description
            END
            DISPLAY(?TOD:CompletedByNotes)
            SELECT(?TOD:CompletedByNotes,SAV:PROP:SelStart# + LEN(LIB:Description))
         END
         CLEAR(GlobalRequest)
      ELSE
         MESSAGE('This Field does not have a Tooltip.||Unable to display the lookup library.','Program Error',ICON:Exclamation)
      END
      
      
      
      
    OF ?NextDocumentButton
      ThisWindow.Update
        IF ~TOD:MatterID
            MESSAGE('You have to assign the Reminder to a Matter before you can specify the Document.','No Matter Specified',ICON:Exclamation)
        ELSIF ~MAT:DocgenID
            MESSAGE('This Matter|' & LOC:Matter & '|does not have a valid Document Set associated with it .','No Document Set',ICON:Exclamation)
        ELSE
            GlobalRequest = SelectRecord
            GLO:DocgenID = MAT:DocgenID
            SelectNextDocument
            IF GlobalResponse = RequestCompleted
               TOD:NextDocumentID = DOC1:RecordID
               LOC:NextDocument = DOC1:Description
            ELSE
               TOD:NextDocumentID = 0
               LOC:NextDocument = ''
            END
            DISPLAY
            GLO:DocgenID = 0
        END
    OF ?ToDoOK
      ThisWindow.Update
      IF SELF.Request = ViewRecord
        POST(EVENT:CloseWindow)
      END
    OF ?MakeFileNoteButton
      ThisWindow.Update
      tempglobalrequest$ = GlobalRequest
      GlobalRequest = InsertRecord
      GLO:LinkingReminderID = TOD:RecordID
      
      UpdateFileNote
      
      ! Clear it from memory
      FIL:RecordID = 0
      GLO:LinkingReminderID = 0
      GlobalRequest = tempglobalrequest$
      
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeCloseEvent PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.TakeCloseEvent()
!  IF TOD:ToDoItemID AND TOD:CompletedFlag AND (INITIAL:CompletedFlag = 0)  ! THE USER COMPLETED THIS REMINDER
!     ProcessToDoItemEvent(TOD:MatterID,TOD:ToDoItemID)
!  END
  RETURN ReturnValue


ThisWindow.TakeCompleted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
   IF LOC:UsingLOCDescriptionFlag
      TOD:Description = LOC:Description
   END

   IF TOD:CompletedByID AND ~TOD:DateDone
      IF TOD:CompletedFlag
         TOD:DateDone = GLO:ToDaysDate
         TOD:CompletedTime = CLOCK()
      ELSE
         TOD:CompletedByID = 0
      END
   END

!   message('TOD:DateDone = ' & TOD:DateDone &|
!           '|SAV:DateDone = ' & SAV:DateDone &|
!           '|TOD:ToDoItemID = ' & TOD:ToDoItemID)


   IF ~(SAV:DateDone = TOD:DateDone) 

       IF TOD:ToDoItemID

!
!
!   message('2222222||TOD:DateDone = ' & TOD:DateDone &|
!           '|SAV:DateDone = ' & SAV:DateDone &|
!           '|TOD:ToDoItemID = ' & TOD:ToDoItemID)


          CLEAR(ROW:Record)
          RowCounter{PROP:SQL} = 'SELECT CriticalStep FROM ToDoItem WHERE RecordID = ' & TOD:ToDoItemID
          NEXT(RowCounter)

          IF ROW:Counter = 8  ! ENTOMOLOGIST CERTIFICATE RECEIVED

            RowCounter{PROP:SQL} = 'UPDATE ConveyData SET EntomologistFlag = 1, EntomologistDate = ' & TOD:DateDone & ' WHERE MatterID = ' & TOD:MatterID

          ELSIF ROW:Counter = 9   ! ELECTRICAL COMPLIANCE CERTIFICATE RECEIVED

            RowCounter{PROP:SQL} = 'UPDATE ConveyData SET ElectricalFlag = 1, ElectricalDate = ' & TOD:DateDone & ' WHERE MatterID = ' & TOD:MatterID

          ELSIF ROW:Counter = 35   ! Plumbing COMPLIANCE CERTIFICATE RECEIVED

            RowCounter{PROP:SQL} = 'UPDATE ConveyData SET PlumbingFlag = 1, PlumbingDate = ' & TOD:DateDone & ' WHERE MatterID = ' & TOD:MatterID

          ELSIF ROW:Counter = 36   ! Gas COMPLIANCE CERTIFICATE RECEIVED

            RowCounter{PROP:SQL} = 'UPDATE ConveyData SET GasFlag = 1, GasDate = ' & TOD:DateDone & ' WHERE MatterID = ' & TOD:MatterID

          END


          ! 24/7/2013 - MOVED THIS HERE
          CheckIfCriticalStepChanged


       END

   END



   ! 24/7/2013 - IT WAS HERE??????
!   IF TOD:ToDoItemID AND SAV:TOD:Date
!
!      IF ~(SAV:TOD:Date = TOD:Date) or ~(SAV:DateDone = TOD:DateDone)
!
!          CheckIfCriticalStepChanged
!
!      END
!
!   END
  
  
   IF LOC:SendEmpMessageFlag
      CLEAR(EM:Record)
      EM:SentFromID = CEM:RecordID
      EM:MatterID = TOD:MatterID
      EM:SentDate = TODAY()
      EM:SentTime = CLOCK()
      EM:ActionID = 1
      EM:Message = TOD:Description
      EM:SentToID = TOD:EmployeeID
      Access:EmpMessage.TryInsert
   END


   IF LOC:CreateOutLookTaskFlag

      UpdateOutLookTaskFromReminder(1)

   END


   IF LOC:CreateOutLookAppointmentFlag

      UpdateOutLookAppointmentFromReminder(1)

   ELSIF CEM:SynchroniseAppointmentsWithRemindersFlag AND Self.Request = InsertRecord

      UpdateOutLookAppointmentFromReminder(1)

   END

   IF LOC:SendEmailFlag !pk here
      LOC:EMailAddress = GetDescription('EMPLOYEE EMAIL',TOD:EmployeeID)
      IF LOC:EMailAddress
         LOC:Subject = 'Reminder: ' & MAT:FileRef & ' - ' & MAT:Description

         IF LEN(CLIP(TOD:CompletedByNotes)) > 0

            LOC:EmailBodyString = TOD:Description & '<13,10> Notes: ' & TOD:CompletedByNotes

         ELSE

            LOC:EmailBodyString = TOD:Description

         END

         SendAndLogEMail(TOD:MatterID,0,LOC:EMailAddress,LOC:Subject,LOC:EmailBodyString)

      ELSE
         MESSAGE('Unable to send email. The Employee does not have an email address.','Email Not Sent',ICON:Exclamation)
      END
   END

  ReturnValue = PARENT.TakeCompleted()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  PDPC:TOD:Date.TakeEvent()
  PDPC:TOD:DateDone.TakeEvent()
  LOOP
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeEvent()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeFieldEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  
      IF ~0{Prop:AcceptAll} AND (?{PROP:Type} = 8 OR ?{PROP:Type} = 17) AND ?{PROP:Tooltip}
          IF EVENT() = EVENT:AlertKey
             IF Keycode() = DownKey OR Keycode() = UpKey
                POST(EVENT:NewSelection,?)
             ELSIF Keycode() = CtrlDown or Keycode() = CtrlUp
                Update(?)
                GLO:TooltipCategory = ?{PROP:Tooltip}
                FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
                IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
  
                a# = Len(Clip(Contents(?)))
                b# = ?{PROP:SelStart}
  
                GLO:TooltipContents = ?{PROP:ScreenText}
                GlobalRequest = SelectRecord
                BrowseLookup
  
  
                IF GlobalResponse = RequestCompleted
                   IF Contents(?)     ! IF THERE ALREADY IS TEXT IN THIS FIELD
                      IF b#  >= a#    ! THE CURSOR IS AT THE END
                         EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                            Change(?,LIB:Description)
                            Change(?,Contents(?) & LIB:Description)
                         END
                      ELSE
                         EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                           Change(?,LIB:Description)
                           Change(?,SUB(Contents(?),1,b#-1) & LIB:Description & CLIP(SUB(Contents(?),b#,5000)))
                         END
                      END
                   ELSE
                      Change(?,LIB:Description)
                   END
                   Post(EVENT:Accepted,?)
  
  
                   DISPLAY(?)
                   SELECT(?,b# + LEN(LIB:Description))
                END
                CLEAR(GlobalRequest)
       
             END
          END
      END
  
  
  LOOP
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
     IF 0{PROP:AcceptAll} THEN RETURN LEVEL:Benign.

     IF ~(SAV:LOC:CreateOutLookTaskFlag = LOC:CreateOutLookTaskFlag)
          SAV:LOC:CreateOutLookTaskFlag = LOC:CreateOutLookTaskFlag

          IF LOC:CreateOutLookTaskFlag
             IF TOD:OutLookTaskID
         
                CASE MESSAGE('A Task has already been created in OutLook for this Reminder|','Task Already Exists',ICON:Exclamation,'&View Task|&Delete Task|&Cancel',1)
                     OF 1
                        UpdateOutLookTaskFromReminder(4)  ! VIEW THE TASK

                        LOC:CreateOutLookTaskFlag = 0
                        DISPLAY(?LOC:CreateOutLookTaskFlag)
                        SAV:LOC:CreateOutLookTaskFlag = LOC:CreateOutLookTaskFlag

                     OF 2
                        UpdateOutLookTaskFromReminder(3)  ! DELETE THE TASK
                        TOD:OutLookTaskID = ''
                     ELSE

                        LOC:CreateOutLookTaskFlag = 0
                        DISPLAY(?LOC:CreateOutLookTaskFlag)
                        SAV:LOC:CreateOutLookTaskFlag = LOC:CreateOutLookTaskFlag

                END
         

             END
          END



     END



     IF ~(SAV:LOC:CreateOutLookAppointmentFlag = LOC:CreateOutLookAppointmentFlag)
          SAV:LOC:CreateOutLookAppointmentFlag = LOC:CreateOutLookAppointmentFlag
          IF LOC:CreateOutLookAppointmentFlag
             IF TOD:OutLookAppointmentID
         
                CASE MESSAGE('An Appointment has already been created in OutLook for this Reminder|','Appointment Already Exists',ICON:Exclamation,'&View|&Deletet|&Cancel',1)
                     OF 1
                        UpdateOutLookAppointmentFromReminder(4)  ! VIEW THE Appointment
                        LOC:CreateOutLookAppointmentFlag = 0
                        DISPLAY(?LOC:CreateOutLookAppointmentFlag)
                        SAV:LOC:CreateOutLookAppointmentFlag = LOC:CreateOutLookAppointmentFlag
                     OF 2
                        UpdateOutLookAppointmentFromReminder(3)  ! DELETE THE Appointment
                        TOD:OutLookAppointmentID = ''
                     ELSE
                        LOC:CreateOutLookAppointmentFlag = 0
                        DISPLAY(?LOC:CreateOutLookAppointmentFlag)
                        SAV:LOC:CreateOutLookAppointmentFlag = LOC:CreateOutLookAppointmentFlag
                END


             END
          END
     END

  IF ~(SAV:CompletedFlag = TOD:CompletedFlag)
      SAV:CompletedFlag = TOD:CompletedFlag

      IF TOD:CompletedFlag

         ?LOC:CompletedBy{PROP:Disable} = FALSE

         IF ~TOD:CompletedByID
             TOD:CompletedByID = CEM:RecordID
             LOC:CompletedBy = CEM:Name
         END

         ?TOD:DateDone{PROP:Disable} = FALSE

         IF ~TOD:DateDone
            TOD:DateDone = GLO:TodaysDate
            TOD:CompletedTime = CLOCK()
         END

      ELSE

         TOD:DateDone = 0
         TOD:CompletedTime = 0
         TOD:CompletedByID = 0
         LOC:CompletedBy = ''
         ?TOD:DateDone{PROP:Disable} = TRUE
         ?LOC:CompletedBy{PROP:Disable} = TRUE
      END

  END
  DISPLAY

  ReturnValue = PARENT.TakeFieldEvent()
   IF ?LOC:Description{PROP:ScreenText}
      SAV:LOC:Description = ?LOC:Description{PROP:ScreenText}
   END
  
   IF ?TOD:Description{PROP:ScreenText}
      SAV:TOD:Description = ?TOD:Description{PROP:ScreenText}
   END
  
   IF ?TOD:CompletedByNotes{PROP:ScreenText}
      SAV:TOD:CompletedByNotes = ?TOD:CompletedByNotes{PROP:ScreenText}
   END
  
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeNewSelection PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE FIELD()
    OF ?LOC:Description
!       IF LEN(LOC:Description) <= 5 ! DOING THIS BECAUSE IT WAS A BIT SLOW
!
!          GLO:TooltipCategory = ?LOC:Description{PROP:Tooltip}
!          FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
!          IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
!
!          PropSQL('SELECT 0,Description from Library WHERE ShortDesc LIKE ''' & LOC:Description & '%'' AND ToolTipCategory = ''' & GLO:TooltipCategory & '''','Reminder Auto Complete')
!
!          IF ROW:Description
!      
!            Change(?,ROW:Description)
!            ?{PROP:SelEnd} = Len(ROW:Description)
!            ?{PROP:Touched} = True
!            Display
!            Post(EVENT:Accepted,?LOC:Description)
!      
!          END
!      
!       END
       
    OF ?LOC:Matter
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        MAT:FileRef = Contents(?)
        Set(MAT:FileRefKey,MAT:FileRefKey)
        If KeyCode() = DownKey Then Next(Matter).
        If KeyCode() = UpKey Then Previous(Matter).
        Loop
          If KeyCode() = UpKey Then Previous(Matter) Else Next(Matter).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (Matter) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(MAT:ArchiveFlag = 0) Then Cycle.
          If ~(Upper(Contents(?)) = Upper(Sub(MAT:FileRef,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,MAT:FileRef)
            ?{PROP:SelEnd} = Len(MAT:FileRef)
            ?{PROP:Touched} = True
            Display
      
      
            Post(EVENT:Accepted,?LOC:Matter)
            Break
          .
          SetKeycode(0)
        .
    END
  ReturnValue = PARENT.TakeNewSelection()
  
  
  ! REMOVED PREEMPTIVE LIBRARY LOOKUPS FROM TEMPLATE ON 27/5/2009
  ! SUSPECT IT WAS CAUSING PERFORMANCE ISSUES AND POSSIBLY EXITING WITHOUT ERRORS (BECAUSE IT WAS DOING THIS INTERMTTENTLY WHEN TESTING TODAY)
  
  
  
!*** OMIT THIS AUTO COMPLETE CODE ***
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeWindowEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE EVENT()
    Of 2000
      ThisSecProc.Update()
    END
  ReturnValue = PARENT.TakeWindowEvent()
    CASE EVENT()
    OF EVENT:LoseFocus
       QuickWindow{PROP:Timer} = 0
       LOC:Description = SAV:LOC:Description
       DISPLAY(?LOC:Description)
       ?LOC:Description{PROP:Selected} = LEN(CLIP(LOC:Description)) + 1
      
      
       TOD:Description = SAV:TOD:Description
       DISPLAY(?TOD:Description)
       ?TOD:Description{PROP:Selected} = LEN(CLIP(TOD:Description)) + 1
      
       TOD:CompletedByNotes = SAV:TOD:CompletedByNotes
       DISPLAY(?TOD:CompletedByNotes)
       ?TOD:CompletedByNotes{PROP:Selected} = LEN(CLIP(TOD:CompletedByNotes)) + 1
      
    OF EVENT:GainFocus
       QuickWindow{PROP:Timer} = 500
      
       LOC:Description = SAV:LOC:Description
       DISPLAY(?LOC:Description)
       ?LOC:Description{PROP:Selected} = LEN(CLIP(LOC:Description)) + 1
      
      
       TOD:Description = SAV:TOD:Description
       DISPLAY(?TOD:Description)
       ?TOD:Description{PROP:Selected} = LEN(CLIP(TOD:Description)) + 1
      
       TOD:CompletedByNotes = SAV:TOD:CompletedByNotes
       DISPLAY(?TOD:CompletedByNotes)
       ?TOD:CompletedByNotes{PROP:Selected} = LEN(CLIP(TOD:CompletedByNotes)) + 1
      
    OF EVENT:Timer
       SAV:LOC:Description = ?LOC:Description{PROP:ScreenText}
       SAV:TOD:Description = ?TOD:Description{PROP:ScreenText}
       SAV:TOD:CompletedByNotes = ?TOD:CompletedByNotes{PROP:ScreenText}
      
      
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.Update PROCEDURE

  CODE
  IF LOC:UsingLOCDescriptionFlag
     TOD:Description = LOC:Description
  END
  PARENT.Update

ThisSecProc.Init  PROCEDURE()
  Code
  Free(LocalSecFieldQueue)
  Loop a# = 1 to 100
    Execute a#
      Begin
        LSFQ:Field = ?TOD:Date
        LSFQ:Description = 'Target Date'
      End
      Begin
        LSFQ:Field = ?LOC:Employee
        LSFQ:Description = 'Employee Drop Down List'
      End
      Begin
        LSFQ:Field = ?LookupEmployeeButton
        LSFQ:Description = 'Employee Lookup Button'
      End
      Begin
        LSFQ:Field = ?LOC:Description
        LSFQ:Description = 'Description (small)'
      End
      Begin
        LSFQ:Field = ?TOD:Description
        LSFQ:Description = 'Description (Large)'
      End
      Begin
        LSFQ:Field = ?LOC:Matter
        LSFQ:Description = 'Matter'
      End
      Begin
        LSFQ:Field = ?LookupMatterButton
        LSFQ:Description = 'Lookup Matter Button'
      End
      Begin
        LSFQ:Field = ?TOD:CompletedFlag
        LSFQ:Description = 'Done?'
      End
      Begin
        LSFQ:Field = ?TOD:DateDone
        LSFQ:Description = 'Date Done'
      End
      Begin
        LSFQ:Field = ?LOC:CompletedBy
        LSFQ:Description = 'Done By Drop Down List'
      End
      Begin
        LSFQ:Field = ?LookupEmployeeButton:2
        LSFQ:Description = 'Done By Lookup Button'
      End
      Begin
        LSFQ:Field = ?TOD:CompletedByNotes
        LSFQ:Description = 'Notes'
      End
       Break
    .
    If LSF:CheckFieldFlag
      Clear(SF:Record)
      SF:SecGroupId = GLO:SecGroupId
      SF:SecProc    = 'Matters - Desktop - Reminders - Update'
      SF:Description = LSFQ:Description
      Access:SecField.Fetch(SF:SecGroupKey)
      LSFQ:HideFlag = SF:HideFlag
      LSFQ:DisableFlag = SF:DisableFlag
    .
    Add(LocalSecFieldQueue)
  .
  Return Level:Benign

ThisSecProc.Kill  PROCEDURE()
  Code
  Free(LocalSecFieldQueue)
  Return Level:Benign

ThisSecProc.SetFields  PROCEDURE()
  Code
  If ~GLO:SupervisorFlag
    b# =  Records(LocalSecFieldQueue)
    Loop a# = 1 to b#
      Get(LocalSecFieldQueue,a#)
      If LSFQ:HideFlag Then LSFQ:Field{PROP:Hide} = True.
      If LSFQ:DisableFlag Then LSFQ:Field{PROP:Disable} = True.
    .
  .
  Return Level:Benign

ThisSecProc.CheckAccess  PROCEDURE()
  Code
  Clear(SP:Record)
  SP:SecGroupId = GLO:SecGroupId
  SP:AccessFlag = GLO:SupervisorFlag
  Case GlobalRequest
  Of InsertRecord
    SP:Description = 'Matters - Desktop - Reminders - Update - Insert'
  Of ChangeRecord
    LSF:CheckFieldFlag = True
    SP:Description = 'Matters - Desktop - Reminders - Update - Change'
  Of DeleteRecord
    SP:Description = 'Matters - Desktop - Reminders - Update - Delete'
  Of ViewRecord
    SP:Description = 'Matters - Desktop - Reminders - Update - View'
  Else
    SP:Description = 'Matters - Desktop - Reminders - Update'
  .
  IF Access:SecProc.TryFetch(SP:SecGroupKey) Then Access:SecProc.Insert().
  IF SP:DisableOnInsertFlag AND GlobalRequest = InsertRecord
    LSF:CheckFieldFlag = True
  END
  If ~SP:AccessFlag and ~GLO:SupervisorFlag
    Message('Access Denied||Your security settings do not allow you access to this area of the program.|',SP:Description,'~lock.ico')
    Return Level:Notify
  .
  Return Level:Benign

ThisSecProc.Update  PROCEDURE()
  Code
    Free(GFQ:FieldQueue)
    b# = Records(LocalSecFieldQueue)
    Loop a# = 1 to b#
      Get(LocalSecFieldQueue,a#)
      GFQ:Field = LSFQ:Field
      GFQ:Description = LSFQ:Description
      Add(GFQ:FieldQueue)
    .
    BrowseSecProc('Matters - Desktop - Reminders - Update',1)
    Return Level:Benign
PDPC:TOD:Date.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF TOD:Date <> L:Default
    POST(EVENT:Accepted,?TOD:Date)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:TOD:DateDone.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF TOD:DateDone <> L:Default
    POST(EVENT:Accepted,?TOD:DateDone)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV

Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults

CheckIfHoliday       PROCEDURE  (TheDate)             ! Declare Procedure
ezField              LONG
LOC:ReturnValue      BYTE(0)
  CODE
        IF ~TheDate THEN RETURN(LOC:ReturnValue).


        GHOLQ:Date = TheDate
        GET(GHOLQ:HolidayQueue,GHOLQ:Date)


        IF ~ERRORCODE()                       ! IT FALLS ON A PUBLIC HOLIDAY
           LOC:ReturnValue = 1
        ELSIF TheDate%7 = 0 OR TheDate%7 = 6 ! IT IS A SATURDAY OR SUNDAY
           LOC:ReturnValue = 2
        END

        RETURN(LOC:ReturnValue)

