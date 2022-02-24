


   MEMBER('MASTER.clw')                               ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABDROPS.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('MASTE171.INC'),ONCE        !Local module procedure declarations
                       INCLUDE('MASTE172.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('MASTE241.INC'),ONCE        !Req'd for module callout resolution
                     END


UpdateFileNote PROCEDURE                              !Generated from procedure template - Window


/***********************************
##ROSS Look at these Procedures:
/***********************************
ThisWindow.Open PROCEDURE
ThisWindow.PrimeFields PROCEDURE
ThisWindow.PrimeUpdate PROCEDURE
ThisWindow.Init PROCEDURE
TakeFieldEvent() - This is code that is called when a field is "Accepted"

NOTE: 
1) root.control = CTL: (i.e. the Control table)
2) root.currentEmployee = CEM: is the Current Employee


LOC:MoveDown        LONG(20)
LOC:AddedSuspendedEmployeeID    LONG
SAV:FIL:Description LIKE(FIL:Description)
CurrentTab           STRING(80)
Reminders:Queue      QUEUE,PRE(REMQ)
Description          LIKE(TOD1:Description)
Date                 LONG
RecordID             LONG
                     END
LOC:ToDoNote         CSTRING(100)
LOC:InsertedBy       CSTRING(256)
LOC:ReminderDate     LONG
LOC:ReturnValue      BYTE
LOC:Message          CSTRING(255)
LOC:Script           CSTRING(1000)
FilesOpened          BYTE
ezField              LONG
ActionMessage        CSTRING(40)
LOC:Matter           CSTRING(50)
LOC:StageDesc        CSTRING(150)
LOC:PrintFlag        BYTE
LOC:MatterDescription CSTRING(75)
LOC:StageCode        LIKE(STA:Code)
LOC:Employee         CSTRING(30)
LOC:StageGroupID     LONG
LOC:LookupPropText   STRING(2)
returnVar            STRING(128)
loc:notInDictionary  STRING(128)
loc:changeTo         STRING(128)
loc:SuggestionsQ     QUEUE,PRE(lq1)
Word                 STRING(128)
                     END
LoopCntr             LONG
loc:CheckGrammar     LONG
LOC:InstantMessageFlag BYTE
LOC:ClientName      LIKE(PAR:Name)
SAV:StageID         LONG
SAV:MatterID        LONG
LOC:NoDateChangeFlag    BYTE
LOC:FileNoteGlobalRequest LIKE(GlobalRequest)
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
QuickWindow          WINDOW('FileNote Update Form'),AT(,,383,262),FONT('Arial',9,,),CENTER,IMM,ICON('note.ico'),TIMER(500),SYSTEM,GRAY,DOUBLE,MDI
                       PROMPT('&Date:'),AT(8,5),USE(?Prompt2)
                       SPIN(@d17),AT(48,5,60,10),USE(FIL:Date),FONT('MS Sans Serif',,,),TIP('The date of the file note<13,10>FIL:Date'),STEP(1)
                       STRING(@t3b),AT(129,6),USE(FIL:Time)
                       PROMPT('M&atter'),AT(8,21),USE(?MatterPrompt)
                       ENTRY(@s49),AT(48,21,68,10),USE(LOC:Matter),IMM,FONT('MS Sans Serif',,,),COLOR(0BDFFFFH),TIP('The Matter this File Note is linked to. <13,10>This is an auto-complete field, i.e. t' &|
   'ype the first few character to locate the entry'),REQ
                       ENTRY(@s74),AT(120,21,163,10),USE(LOC:MatterDescription),SKIP,FONT('MS Sans Serif',,,),COLOR(COLOR:Silver),TIP('Description of the Matter'),READONLY
                       BUTTON('...'),AT(288,21,11,11),USE(?LookupMatterButton),SKIP,TIP('Select a Matter')
                       PROMPT('E&mployee:'),AT(8,37),USE(?Prompt6)
                       LIST,AT(47,36,129,10),USE(LOC:Employee),VSCROLL,FORMAT('196L(2)|M@s49@'),DROP(25),FROM(GEMPQ:EmployeeQueue)
                       BUTTON('...'),AT(288,53,11,11),USE(?LookupStageButton),SKIP,TIP('Lookup the stage codes')
                       GROUP,AT(2,63,331,21),USE(?ReminderGroup)
                         PROMPT('Reminder:'),AT(8,70),USE(?LOC:ToDoNote:Prompt)
                         LIST,AT(48,69,234,11),USE(LOC:ToDoNote),VSCROLL,TIP('Reminder linked to this File Note'),FORMAT('80L(2)@s200@'),DROP(15),FROM(Reminders:Queue)
                         BUTTON('...'),AT(288,68,11,11),USE(?LookupRemindersButton),TIP('Select a Reminder')
                         BUTTON,AT(303,69,14,11),USE(?RemoveReminderButton),TIP('Remove the Reminder linked to this File Note'),ICON('smcross.ico')
                       END
                       GROUP,AT(3,81,379,179),USE(?BottomGroup)
                         PROMPT('&Stage:'),AT(8,54),USE(?Stage:Prompt)
                         ENTRY(@s9),AT(48,53,41,10),USE(LOC:StageCode),IMM,FONT('MS Sans Serif',,,),COLOR(0BDFFFFH),TIP('The stage this Matter has completed. <13,10>This is an auto-complete field, i.e. type' &|
   ' the first few character to locate the entry'),ALRT(UpKey),ALRT(DownKey)
                         ENTRY(@s49),AT(96,53,187,11),USE(LOC:StageDesc),SKIP,FONT('MS Sans Serif',,,),COLOR(COLOR:Silver),TIP('Description of the Stage'),READONLY
                         BUTTON('...'),AT(180,36,10,10),USE(?LookupEmployeeButton),SKIP,TIP('Lookup an employee')
                         PROMPT('&Note:'),AT(8,83),USE(?Prompt5)
                         TEXT,AT(48,85,317,70),USE(FIL:Description),IMM,VSCROLL,TIP('The text of the File Note<13,10>Press F7 to check the spelling<13,10>FIL:Description'),ALRT(CtrlUp),ALRT(CtrlDown),REQ
                         BUTTON,AT(369,96,11,11),USE(?SelectColourButton),SKIP,TIP('Colour of the File Note text.'),KEY(CtrlL),ICON('paint_small.ico')
                         BUTTON,AT(369,83,11,11),USE(?LookupLibraryButton),SKIP,TIP('Lookup and insert text from the Lookup Library (Ctrl L)'),KEY(CtrlL),ICON('Lookup.ico')
                         STRING('F7 - Check spelling'),AT(305,160),USE(?String3)
                         GROUP('&Actions (after pressing OK)'),AT(8,170,371,63),USE(?ActionGroup),BOXED
                           CHECK('&Email this File Note?'),AT(16,214),USE(GLO:EmailFileNoteFlag),SKIP,TIP('Automatically email this File Note to someone')
                           CHECK('Send an &Instant Message?'),AT(108,214),USE(GLO:InstantMessageFlag),SKIP,TIP('Automatically email this File Note to someone')
                           CHECK('Create a  &Fee Note?'),AT(16,183),USE(GLO:MakeFeeNoteFlag),SKIP,TIP('Make a Fee Note based on this File Note?')
                           TEXT,AT(108,183,264,10),USE(GLO:FeeNoteDescription),IMM,TIP('The text of the Fee Note'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),SINGLE
                           CHECK('Insert a &Reminder?'),AT(16,199),USE(GLO:MakeToDoNoteFlag),SKIP,TIP('Make a Reminder based on this File Note?')
                           TEXT,AT(108,199,193,10),USE(GLO:ToDoNoteDescription),IMM,TIP('The text of the Reminder'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),SINGLE
                           PROMPT('in'),AT(304,199),USE(?GLO:ToDoNoteDays:Prompt)
                           ENTRY(@D17),AT(360,199,0,11),USE(LOC:ReminderDate),DISABLE,FONT('MS Sans Serif',,,)
                           SPIN(@n_5b),AT(312,199,31,10),USE(GLO:ToDoNoteDays),RIGHT(1),FONT('MS Sans Serif',,,),TIP('How many days ahead?')
                           STRING('days'),AT(344,199),USE(?DaysTimeString)
                         END
                         CHECK('&This is an Internal (private) File Note?'),AT(252,3),USE(FIL:InternalFlag),SKIP,TIP('This File Note is for internal use only. <13,10>If ticked, you can filter these out of some reports so Clients cannot see them.<13,10>FIL:InternalFlag')
                         BUTTON('&OK'),AT(254,237,60,20),USE(?OK),LEFT,FONT(,11,,),ICON('check3.ico'),DEFAULT
                         BUTTON('&Cancel'),AT(319,237,60,20),USE(?Cancel),LEFT,FONT(,11,,),ICON('delete32.ico')
                         STRING(@s255),AT(8,243,227,10),USE(LOC:InsertedBy)
                       END
                     END

PDSC:FIL:Date        CLASS(PDScrollCT)
TakeFieldEvent         PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDSC:LOC:ReminderDate CLASS(PDScrollCT)
TakeFieldEvent         PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDPC:FIL:Date        CLASS(PDPopCalBtnCT)
TakeAccepted           PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDPC:LOC:ReminderDate CLASS(PDPopCalBtnCT)
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
TakeSelected           PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
WordDoc10            Class(oiWord)
CheckSpelling_Init     PROCEDURE (),long, proc, virtual, name('CHECKSPELLING_INIT@F16OIWORD')
CheckSpelling_Kill     PROCEDURE (),long, proc, virtual, name('CHECKSPELLING_KILL@F16OIWORD')
GetRtfText             PROCEDURE (*string checkText, long hControl), virtual, name('GETRTFTEXT@F16OIWORD')
Init                   PROCEDURE (long pStartVisible=1, long pEnableEvents=1),long,proc,virtual,name('INIT@F16OIWORD')
Kill                   PROCEDURE (long pUnloadCOM=1),long,proc,virtual,name('KILL@F16OIWORD')
ReplaceRtfText         PROCEDURE (string oldWord, string newWord, long hControl), virtual, name('REPLACERTFTEXT@F16OIWORD')
SpellWord              PROCEDURE (string pWord, *oiwWordsQ WordsQ, *long pCommand), string, virtual, name('SPELLWORD@F16OIWORD')
TakeEvent              PROCEDURE (string pEventString1, string pEventString2, long pEventNumber=0, long pEventType=0, long pEventStatus=0),virtual,name('TAKEEVENT@F16OIWORD')
                     End

    ! ReportType = Basic
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

ResetRemindersQueue     ROUTINE
  IF QuickWindow{PROP:AcceptAll} THEN EXIT.

  IF ~FIL:MatterID THEN EXIT.
  Free(Reminders:Queue)
  CLEAR(TOD1:Record)
  TOD1:MatterID = FIL:MatterID
  SET(TOD1:MatterKey,TOD1:MatterKey)
  LOOP UNTIL Access:ToDoNoteAlias.Next()

!       message('LOOPING THRU TOD1:MatterKey|GOT TOD1:Description = ' & TOD1:Description)

       IF ~(TOD1:MatterID = FIL:MatterID) THEN BREAK.

       REMQ:Date = TOD1:Date
       REMQ:Description = TOD1:Description
       REMQ:RecordID = TOD1:RecordID
       ADD(Reminders:Queue,REMQ:Date)
  END


  !?LOC:ToDoNote{PROP:Selected} = 0


!  REMQ:Description = 'None'
!  REMQ:RecordID = 0
!  ADD(Reminders:Queue,1)



SetReminderDropDown         ROUTINE



  IF GLO:LinkingReminderID

    FIL:ToDoNoteID = GLO:LinkingReminderID

    ?GLO:MakeToDoNoteFlag{PROP:Disable} = True
    ?GLO:ToDoNoteDescription{PROP:Disable} = True
    ?GLO:ToDoNoteDays{PROP:Disable} = True

  END

  GLO:LinkingReminderID = 0

  IF FIL:ToDoNoteID

     SORT(Reminders:Queue,REMQ:RecordID)
     CLEAR(Reminders:Queue)
     REMQ:RecordID = FIL:ToDoNoteID
     GET(Reminders:Queue,REMQ:RecordID)

     IF ~ERROR()         ! THE USER MAY BE SUSPENDED SO ADD THEM TEMPORARILY TO THE REMQ: SO THE DROP DOWN WORKS AS NORMAL  (AND TAKE THEM OUT WHEN CLOSING THIS WINDOW)
        !MESSAGE('Got Reminders:Queue|RECORDS(Reminders:Queue) = ' & RECORDS(Reminders:Queue) & '|REMQ:Description = ' & REMQ:Description & '|POSITION(Reminders:Queue) = ' & POSITION(Reminders:Queue))
        ! FIL:ToDoNoteID = ' & FIL:ToDoNoteID & '. REMQ:Description = ' & REMQ:Description & '. REMQ:RecordID = ' & REMQ:RecordID)
        LOC:ToDoNote = REMQ:Description

        ?LOC:ToDoNote{PROP:Selected} = POSITION(Reminders:Queue)

     END

  END



CheckStage  Routine
  LOC:ReturnValue = Level:Benign
  If ~FIL:StageId Then Exit.

  STA:RecordID = FIL:StageId
  Access:Stage.Fetch(STA:PrimaryKey)
  If ~STA:ConditionOption Then Exit.

  StageCodeCount# = 1;
  b# = 0
  Loop
    b# = Instring(',',STA:Condition,1,b#+1)
    If b# = 0 Then Break.
    StageCodeCount# += 1
  .


  !Find if stages exist
  LOC:Script = 'Select Count(1) From (Select Distinct Stage.Code From FileNote ' & |
               'Inner join Stage On Stage.RecordID = filenote.StageID ' & |
               'Where MatterId = ' & FIL:MatterId & ' And Stage.Code in (' & STA:Condition & ') ) A'
  Debug(LOC:Script)
  PropSqlNext(LOC:Script)
  If ROW:Counter = StageCodeCount# Then Exit.

  If STA:ConditionOption = 1 !Warining
      If Instring(',',STA:Condition)
        LOC:Message = 'You should not capture this stage yet.  All of the following stages should be completed first: ' & STA:Condition
      Else
        LOC:Message = 'You should not capture this stage yet.  The following stages should be completed first: ' & STA:Condition
      .
      If Message(LOC:Message,'Missing Stage',ICON:Asterisk, '&Ignore|&Cancel') = 2 Then LOC:ReturnValue = Level:Notify.
  Else                       !Restrict
      If Instring(',',STA:Condition)
        LOC:Message = 'You cannot capture this stage yet.  All of the following stages must be completed first: ' & STA:Condition
      Else
        LOC:Message = 'You cannot capture this stage yet.  The following stages must be completed first: ' & STA:Condition
      .
      Message('You cannot capture this stage yet.  One of the following must be completed first: ' & STA:Condition,'Missing Stage',ICON:Asterisk)
      LOC:ReturnValue = Level:Notify
  .
  OMIT('*** BUG IN TEMPLATE ****')
Rtn_CheckSpelling_WordDoc10  routine  ! CapeSoft Office Inside
  data
oiSpellText         &string
  code
    case Focus()
    of ?LOC:Matter
        Update(?LOC:Matter)
        oiSpellText &= new string(size(LOC:Matter))
        oiSpellText = LOC:Matter
        WordDoc10.SpellCheckString(oiSpellText)
        LOC:Matter = oiSpellText
        Display(?LOC:Matter)
        Dispose(oiSpellText)
    of ?LOC:MatterDescription
        Update(?LOC:MatterDescription)
        oiSpellText &= new string(size(LOC:MatterDescription))
        oiSpellText = LOC:MatterDescription
        WordDoc10.SpellCheckString(oiSpellText)
        LOC:MatterDescription = oiSpellText
        Display(?LOC:MatterDescription)
        Dispose(oiSpellText)
    of ?LOC:StageCode
        Update(?LOC:StageCode)
        oiSpellText &= new string(size(LOC:StageCode))
        oiSpellText = LOC:StageCode
        WordDoc10.SpellCheckString(oiSpellText)
        LOC:StageCode = oiSpellText
        Display(?LOC:StageCode)
        Dispose(oiSpellText)
    of ?LOC:StageDesc
        Update(?LOC:StageDesc)
        oiSpellText &= new string(size(LOC:StageDesc))
        oiSpellText = LOC:StageDesc
        WordDoc10.SpellCheckString(oiSpellText)
        LOC:StageDesc = oiSpellText
        Display(?LOC:StageDesc)
        Dispose(oiSpellText)
    of ?FIL:Description
        Update(?FIL:Description)
        oiSpellText &= new string(size(FIL:Description))
        oiSpellText = FIL:Description
        WordDoc10.SpellCheckString(oiSpellText)
        FIL:Description = oiSpellText
        Display(?FIL:Description)
        Dispose(oiSpellText)
    of ?GLO:FeeNoteDescription
        Update(?GLO:FeeNoteDescription)
        oiSpellText &= new string(size(GLO:FeeNoteDescription))
        oiSpellText = GLO:FeeNoteDescription
        WordDoc10.SpellCheckString(oiSpellText)
        GLO:FeeNoteDescription = oiSpellText
        Display(?GLO:FeeNoteDescription)
        Dispose(oiSpellText)
    of ?GLO:ToDoNoteDescription
        Update(?GLO:ToDoNoteDescription)
        oiSpellText &= new string(size(GLO:ToDoNoteDescription))
        oiSpellText = GLO:ToDoNoteDescription
        WordDoc10.SpellCheckString(oiSpellText)
        GLO:ToDoNoteDescription = oiSpellText
        Display(?GLO:ToDoNoteDescription)
        Dispose(oiSpellText)
    of ?LOC:ReminderDate
        Update(?LOC:ReminderDate)
        oiSpellText &= new string(size(LOC:ReminderDate))
        oiSpellText = LOC:ReminderDate
        WordDoc10.SpellCheckString(oiSpellText)
        LOC:ReminderDate = oiSpellText
        Display(?LOC:ReminderDate)
        Dispose(oiSpellText)
    end
    Message('The spelling check is complete.','Spelling', icon:asterisk)
    *** BUG IN TEMPLATE ****


Rtn_CheckSpelling_WordDoc10  routine  ! CapeSoft Office Inside
  data
oiSpellText         &string
  code
        Update(?FIL:Description)
        oiSpellText &= new string(SIZE(FIL:Description))
        oiSpellText = CLIP(FIL:Description)
        WordDoc10.SpellCheckString(oiSpellText)
        FIL:Description = oiSpellText
        Display(?FIL:Description)
        Dispose(oiSpellText)
        Message('The spelling check is complete.|','Spell checking complete', icon:asterisk)



ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request
  OF ViewRecord
    ActionMessage = 'View Record'
  OF InsertRecord
    ActionMessage = 'Adding a File Note'
  OF ChangeRecord
    ActionMessage = 'Changing a File Note'
  END
  QuickWindow{Prop:Text} = ActionMessage
    IF CheckMatterAccess(FIL:MatterID)  ! ADDED 8/11/2010
       0{PROP:Text} = 'File Note [View Only]'
       ?OK{PROP:Disable} = True
  END
  IF FIL:RecordID THEN 0{Prop:Text} = 0{Prop:Text} & ' (' & FIL:RecordID & ')'.
  
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    ThisSecProc.Init()
  GlobalErrors.SetProcedureName('UpdateFileNote')
  SELF.Request = GlobalRequest
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Prompt2
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)
  CLEAR(GlobalResponse)
  SELF.AddUpdateFile(Access:FileNote)
  SELF.AddItem(?Cancel,RequestCancelled)
  Relate:FileNote.Open
  Relate:Matter.Open
  Relate:ParTele.Open
  Relate:Stage.Open
  Relate:ToDoNoteAlias.Open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:FileNote
  IF SELF.Request = ViewRecord
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = 0
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.DeleteAction = Delete:Auto
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  SELF.FirstField = ?FIL:Description
  
  IF FIL:EmployeeID
     LOC:Employee = GETDescription('Employee',FIL:EmployeeID)
  END

  GLO:EnableInstantMessagingFlag = FALSE


  IF SELF.Request = ChangeRecord ! FIL:RecordID > 0 ! Updated as Bentley have File Notes with negative RecordIDs

     ! FB Case 1688 PK Naidoo: Display the log if available
     IF FIL:CreatedBy > 0

         LOC:InsertedBy = 'Inserted by ' & GetDescription('EMPLOYEE',FIL:CreatedBy) & ' at ' & FORMAT(FIL:CreatedTime,@T3) & ' on ' & FORMAT(FIL:CreatedDate,@D17B)

     ELSE

         LOC:InsertedBy = ''

     END

  END

  DISPLAY
  OPEN(QuickWindow)
  SELF.Opened=True
    LOC:MoveDown = 15
    IF ~CTL:FileNoteReminderFlag

        0{PROP:Height} = 0{PROP:Height} - LOC:MoveDown

        ?Prompt5{PROP:YPos} = ?Prompt5{PROP:YPos} - LOC:MoveDown
        ?FIL:Description{PROP:YPos} = ?FIL:Description{PROP:YPos} - LOC:MoveDown
        ?LookupLibraryButton{PROP:YPos} = ?LookupLibraryButton{PROP:YPos} - LOC:MoveDown
        ?String3{PROP:YPos} = ?String3{PROP:YPos} - LOC:MoveDown
        ?ActionGroup{PROP:YPos} = ?ActionGroup{PROP:YPos} - LOC:MoveDown
        ?GLO:EmailFileNoteFlag{PROP:YPos} = ?GLO:EmailFileNoteFlag{PROP:YPos} - LOC:MoveDown
        ?GLO:InstantMessageFlag{PROP:YPos} = ?GLO:InstantMessageFlag{PROP:YPos} - LOC:MoveDown
        ?GLO:MakeFeeNoteFlag{PROP:YPos} = ?GLO:MakeFeeNoteFlag{PROP:YPos} - LOC:MoveDown
        ?GLO:FeeNoteDescription{PROP:YPos} = ?GLO:FeeNoteDescription{PROP:YPos} - LOC:MoveDown
        ?GLO:MakeToDoNoteFlag{PROP:YPos} = ?GLO:MakeToDoNoteFlag{PROP:YPos} - LOC:MoveDown
        ?GLO:ToDoNoteDescription{PROP:YPos} = ?GLO:ToDoNoteDescription{PROP:YPos} - LOC:MoveDown
        ?GLO:ToDoNoteDays:Prompt{PROP:YPos} = ?GLO:ToDoNoteDays:Prompt{PROP:YPos} - LOC:MoveDown
        ?LOC:ReminderDate{PROP:YPos} = ?LOC:ReminderDate{PROP:YPos} - LOC:MoveDown
        ?GLO:ToDoNoteDays{PROP:YPos} = ?GLO:ToDoNoteDays{PROP:YPos} - LOC:MoveDown
        ?DaysTimeString{PROP:YPos} = ?DaysTimeString{PROP:YPos} - LOC:MoveDown
        ?OK{PROP:YPos} = ?OK{PROP:YPos} - LOC:MoveDown
        ?Cancel{PROP:YPos} = ?Cancel{PROP:YPos} - LOC:MoveDown
        ?LOC:InsertedBy{PROP:YPos} = ?LOC:InsertedBy{PROP:YPos} - LOC:MoveDown
        ?SelectColourButton{PROP:YPos} = ?SelectColourButton{PROP:YPos} - LOC:MoveDown

        HIDE(?ReminderGroup)
    ELSE

    END

    ! 10/07/2019 PK Naidoo - FB Case 2399
    IF FIL:Color > 0
       ?FIL:Description{PROP:FontColor} = FIL:Color
    END


    GEMPQ:RecordID = FIL:EmployeeID
    GET(GEMPQ:EmployeeQueue,GEMPQ:RecordID)

    IF ERROR()         ! THE USER MAY BE SUSPENDED SO ADD THEM TEMPORARILY TO THE GEMPQ: SO THE DROP DOWN WORKS AS NORMAL  (AND TAKE THEM OUT WHEN CLOSING THIS WINDOW)

      CLEAR(GEMPQ:EmployeeQueue)
      GEMPQ:Name = GETDescription('Employee',FIL:EmployeeID)

      IF GEMPQ:Name

         GEMPQ:RecordID = FIL:EmployeeID
         ADD(GEMPQ:EmployeeQueue,GEMPQ:Name)

         LOC:AddedSuspendedEmployeeID = FIL:EmployeeID

         LOC:Employee = GEMPQ:Name
         ?LOC:Employee{PROP:Selected} = POSITION(GEMPQ:EmployeeQueue)

      END

    ELSE

        LOC:Employee = GEMPQ:Name
        ?LOC:Employee{PROP:Selected} = POSITION(GEMPQ:EmployeeQueue)

    END




  IF Self.Request = InsertRecord                ! IF NOT ALLOWED TO EDIT DATA THEN DISBALE THE OK BUTTON
  ELSE
     IF ~CheckEmployeeAllowed(FIL:EmployeeID)
         ?OK{PROP:Disable} = True
     END
  END
  GLO:MakeToDoNoteFlag = False
  GLO:MakeFeeNoteFlag = False

  IF GLO:TimeRecordingFlag
     ?GLO:MakeFeeNoteFlag{PROP:Text} = 'Create a Time Record'
     ?GLO:MakeFeeNoteFlag{PROP:Tooltip} = 'Create a Time Record based on this File Note?'
  END


  If FIL:MatterID
    MAT:RecordID = FIL:MatterID
    Access:Matter.Fetch(MAT:PrimaryKey)
    Change(?LOC:Matter,MAT:FileRef)
    LOC:MatterDescription = MAT:Description
    LOC:StageGroupID = MAT:StageGroupID
  .

  If FIL:StageID
    STA:RecordID = FIL:StageID
    Access:Stage.Fetch(STA:PrimaryKey)
    Change(?LOC:StageCode,STA:Code)
    LOC:StageDesc = STA:Description
    ! 17/07/2018 PK Naidoo: FB Case 1687
    LOC:NoDateChangeFlag = STA:DateChangeFlag

    IF LOC:NoDateChangeFlag
        ! If we're changing a record, do not set the date to today.
        IF ~FIL:RecordID

            FIL:Date = GLO:TodaysDate

        END

        ?FIL:Date{PROP:Disable} = True
        ?FIL:Date{PROP:Tip} = 'No Date Change is enabled via the selected Stage Code.'
      
    ELSE
      
        ?FIL:Date{PROP:Disable} = False
        ?FIL:Date{PROP:Tip} = 'Select the Date'
      
    END

  .

  If FIL:EmployeeID
     EMP:RecordID = FIL:EmployeeID
     Access:Employee.Fetch(EMP:PrimaryKey)
     Change(?LOC:Employee,EMP:Name)
  .


  SAV:StageID = FIL:StageID


    IF CTL:FileNoteReminderFlag
       DO ResetRemindersQueue
       DO SetReminderDropDown
    END


       QuickWindow{Prop:Alrt,254}=1024
       QuickWindow{Prop:Alrt,255}=AltF12
  PDPC:FIL:Date.Init(?FIL:Date,FIL:Date,PopCalQ,Def_Config,)
  PDPC:LOC:ReminderDate.Init(?LOC:ReminderDate,LOC:ReminderDate,PopCalQ,Def_Config,)
  PDSC:FIL:Date.Init(FIL:Date,PDSchedC,?FIL:Date,,,)  ! NOTE: Date Scroll and Drop class range limits can be set with Field user options: PDDTRangeLow and PPDTRangeHigh
  PDSC:FIL:Date.SetAlert(PDDT_eqSemiMonPlus+1,0)      ! Disable altdown key so it can be used by button.
  PDSC:FIL:Date.AddDropID('PDPopCal')
  PDSC:LOC:ReminderDate.Init(LOC:ReminderDate,PDSchedC,?LOC:ReminderDate,,,) ! NOTE: Date Scroll and Drop class range limits can be set with Field user options: PDDTRangeLow and PPDTRangeHigh
  PDSC:LOC:ReminderDate.SetAlert(PDDT_eqSemiMonPlus+1,0) ! Disable altdown key so it can be used by button.
  PDSC:LOC:ReminderDate.AddDropID('PDPopCal')
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)
  SELF.AddItem(Resizer)
  SELF.AddItem(ToolbarForm)
  
  QuickWindow{Prop:Alrt,255} = F7Key                  ! CapeSoft Office Inside - SpellChecking
  SELF.SetAlerts()
    ThisSecProc.SetFields()
  
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  PDSC:FIL:Date.Kill
  PDSC:LOC:ReminderDate.Kill
  PDPC:FIL:Date.Kill
  PDPC:LOC:ReminderDate.Kill
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:FileNote.Close
    Relate:Matter.Close
    Relate:ParTele.Close
    Relate:Stage.Close
    Relate:ToDoNoteAlias.Close
  END
  GLO:EnableInstantMessagingFlag = TRUE
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Open PROCEDURE

  CODE
  PARENT.Open
!JESS
          SAV:MatterID = FIL:MatterID
          AddToFavourites(FIL:MatterID)
   OMIT('***BOB***')
  WordDoc10.Init (0, 0)
         !***BOB***


ThisWindow.PrimeFields PROCEDURE

  CODE
    FIL:Date = GLO:TodaysDate
    FIL:EmployeeID = GLO:EmployeeID
    FIL:MatterID = MAT:RecordId
    FIL:AutoNotifyDate = 0
    FIL:InternalFlag = CEM:FileNotesInternalFlag
  PARENT.PrimeFields


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  IF FIL:MatterID AND GlobalRequest = ChangeRecord
     MAT:RecordID = FIL:MatterID
     Access:Matter.Fetch(MAT:PrimaryKey)
     IF RestrictedMatter(MAT:RecordID,0)
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
    BrowseLookup
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
    OF ?LOC:Matter
      IF ~QuickWindow{PROP:AcceptAll}
      
        If ~(FIL:MatterID) Then Cycle.
        Update(?)
        MAT:FileRef = Contents(?)
        Access:Matter.Fetch(MAT:FileRefKey)
        FIL:MatterID = MAT:RecordID
        LOC:MatterDescription = MAT:Description
        LOC:StageGroupID = MAT:StageGroupID
      
           !RESET THE REMINDERS DROPDOWN
           LOC:ToDoNote = ''
      
           DO ResetRemindersQueue
      
           FIL:ToDoNoteID = 0
      
      
           DISPLAY
      
        If MAT:FileRef <> Contents(?)
          Select(?)
          Cycle
        .
      
      END
      
    OF ?LOC:Employee
              GET(GEMPQ:EmployeeQueue,CHOICE())
              FIL:EmployeeID = GEMPQ:RecordID
    OF ?LOC:StageCode
      IF ~LOC:StageCode
          FIL:StageID = 0
          LOC:StageDesc = ''
      END
      ! Verify AutoComplete

      IF ~LOC:StageCode THEN CYCLE.

      Update(?)
      CLEAR(STA:Record)
      STA:StageGroupID = MAT:StageGroupID
      STA:Code = Contents(?)
      Set(STA:StageGroupKey,STA:StageGroupKey)


      IF Access:Stage.Next()
            Select(?)
            CYCLE
      ELSE
         IF STA:InactiveFlag = 1
            Select(?)
            CYCLE
         END
      END



      If STA:Code <> Contents(?)
        Select(?)
        Cycle
      .
      
      FIL:StageID = STA:RecordID
      LOC:StageDesc = STA:Description

      ! 17/07/2018 PK Naidoo: FB Case 1687
      LOC:NoDateChangeFlag = STA:DateChangeFlag

      FIL:Color = STA:FileNoteColor
   
      IF FIL:Color
          ?FIL:Description{PROP:FontColor} = FIL:Color
      END

      IF LOC:NoDateChangeFlag
        ! Only change the date to today on Insert
        IF ~FIL:RecordID

            FIL:Date = GLO:TodaysDate

        END

        ?FIL:Date{PROP:Disable} = True
        ?FIL:Date{PROP:Tip} = 'No Date Change is enabled via the selected Stage Code.'
      
      ELSE
      
        ?FIL:Date{PROP:Disable} = False
        ?FIL:Date{PROP:Tip} = 'Select the Date'
      
      END

      If ~QuickWindow{PROP:AcceptAll}
      

           IF STA:MakeFeeNoteFlag OR STA:Amount
              GLO:MakeFeeNoteFlag = 1
              GLO:MakeFeeNoteAmount = STA:Amount
           ELSE
              GLO:MakeFeeNoteFlag = 0
              GLO:MakeFeeNoteAmount = 0
           END
           DISPLAY(?GLO:MakeFeeNoteFlag)
      
      
      
      END
      
      
      omit('**** omit this stuff ***')
        If ~(FIL:StageID) Then Cycle.
        Update(?)
        STA:StageGroupID = MAT:StageGroupID
        STA:Code = Contents(?)
        Access:Stage.Fetch(STA:StageGroupKey)
        FIL:StageID = STA:RecordID
        LOC:StageDesc = STA:Description
        LOC:StageCode = STA:Code
        If STA:Code <> Contents(?)
          Select(?)
          Cycle
        .
      ! **** omit this stuff ***
    OF ?SelectColourButton
      ! 10/07/2019 PK Naidoo - FB Case 2399
      IF ColorDialog('Text Colour',FIL:Color)
         ?FIL:Description{PROP:FontColor} = FIL:Color
      END
    OF ?GLO:InstantMessageFlag
          IF GLO:InstantMessageFlag
              GLO:EmpMessageMatterID = FIL:MatterID
          ELSE
              GLO:EmpMessageMatterID = 0
          END
    OF ?LOC:ReminderDate
          ! 04/10/2017 PK Naidoo: FB Case 856
          IF LOC:ReminderDate
      
              IF LOC:ReminderDate < GLO:TodaysDate
      
                  LOC:ReminderDate = GLO:TodaysDate ! If the user selects a date before today for a reminder
      
              END
      
              GLO:ToDoNoteDays = LOC:ReminderDate - GLO:TodaysDate
              DEBUG('GLO:ToDoNoteDays = ' & GLO:ToDoNoteDays)
          END
    OF ?OK
        IF FIL:StageID
           IF CheckMatterConditions('F') THEN CYCLE.
      
           Do CheckStage
           If LOC:ReturnValue Then Cycle.
        END
        IF GLO:TimeRecordingFlag Then GLO:StopwatchNotes = GLO:FeeNoteDescription.

        ! FB Case 1688 PK Naidoo: We're now logging the following fields
        IF FIL:RecordID = 0 OR SELF.Request = InsertRecord ! If we're copying the File Note, the FIL:RecordID is still in memory
      
            FIL:CreatedDate = GLO:TodaysDate
            FIL:CreatedTime = CLOCK()
            FIL:CreatedBy = CEM:RecordID

        END

!        LOC:FileNoteGlobalRequest = GlobalRequest
!        IF LOC:InstantMessageFlag
!      
!           SendEmpMessageWithParams(FIL:MatterID,FIL:Description)
!      
!        END
!        GlobalRequest = LOC:FileNoteGlobalRequest
      
        
        
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?LOC:Matter
!JESS
     IF ~(SAV:MatterID = FIL:MatterID)
          SAV:MatterID = FIL:MatterID
          AddToFavourites(FIL:MatterID)
     END

    OF ?LookupMatterButton
      ThisWindow.Update
        GlobalRequest = SelectRecord
        SelectMatterAlias
        IF GlobalResponse = RequestCompleted
           LOC:Matter = GetDescription('Matter FileRef',MAT1:RecordID)
           LOC:MatterDescription = GetDescription('Matter Description',MAT1:RecordID)
           FIL:MatterID = MAT1:RecordID
           LOC:StageGroupID = MAT1:StageGroupID
      
           !RESET THE REMINDERS DROPDOWN
           LOC:ToDoNote = ''
      
           DO ResetRemindersQueue
      
           FIL:ToDoNoteID = 0
      
      
           DISPLAY
           IF ~(SAV:MatterID = FIL:MatterID)
                SAV:MatterID = FIL:MatterID
                AddToFavourites(FIL:MatterID)
           END
        END
    OF ?LookupStageButton
      ThisWindow.Update
      GlobalRequest = SelectRecord
      
      ! CLEAR ANY PREVIOUSLY TAGGED STAGES
      PROPSQL('DELETE TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
      
      SelectStage(LOC:StageGroupID)
      
      If GlobalResponse = RequestCompleted
         LOC:StageDesc = STA:Description
         LOC:StageCode = STA:Code
         FIL:StageID = STA:RecordID
         FIL:Color = STA:FileNoteColor
      
         IF FIL:Color
             ?FIL:Description{PROP:FontColor} = FIL:Color
         END
      
         LOC:NoDateChangeFlag = STA:DateChangeFlag
      
         IF FIL:MatterID
            MAT:StageGroupID = STA:StageGroupID
            Access:Matter.TryUpdate
         END
      
         DISPLAY
         CLEAR(GlobalRequest)
      END
      
      IF LOC:NoDateChangeFlag
        ! Only change the date to today on Insert
        IF ~FIL:RecordId
      
            FIL:Date = GLO:TodaysDate
      
        END
        ?FIL:Date{PROP:Disable} = True
        ?FIL:Date{PROP:Tip} = 'No Date Change is enabled via the selected Stage Code.'
      
      ELSE
      
        ?FIL:Date{PROP:Disable} = False
        ?FIL:Date{PROP:Tip} = 'Select the Date'
      
      END
      
      
    OF ?LookupRemindersButton
      ThisWindow.Update
      GlobalRequest = SelectRecord
      
      SelectMatterReminder
      
      If GlobalResponse = RequestCompleted
         LOC:ToDoNote = TOD2:Description
         FIL:ToDoNoteID = TOD2:RecordID
      
         DISPLAY
         CLEAR(GlobalRequest)
      END
    OF ?RemoveReminderButton
      ThisWindow.Update
      LOC:ToDoNote = ''
      FIL:ToDoNoteID = 0
      DISPLAY
      
    OF ?LookupEmployeeButton
      ThisWindow.Update
            GlobalRequest = SelectRecord
            SelectEmployee
            IF GlobalResponse = RequestCompleted
               FIL:EmployeeID = EMP:RecordID
               LOC:Employee = EMP:Name
            END
            DISPLAY
      
    OF ?LookupLibraryButton
      ThisWindow.Update
      GLO:TooltipCategory = ?FIL:Description{PROP:Tooltip}
      IF GLO:TooltipCategory
      
         FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
         IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
      
         SAV:PROP:SelStart# = ?FIL:Description{PROP:SelStart}
         GLO:TooltipContents = ?FIL:Description{PROP:ScreenText}
         GlobalRequest = SelectRecord
         BrowseLookup
         IF GlobalResponse = RequestCompleted
            LIB:Description = ReplaceTextBoxFields(LIB:Description,0,-1,-1,0)
            IF FIL:Description     ! IF THERE ALREADY IS TEXT IN THIS FIELD
               IF SAV:PROP:SelStart#  >= LEN(FIL:Description) ! THE CURSOR IS AT THE END
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                     FIL:Description = LIB:Description
                     FIL:Description =  FIL:Description & LIB:Description
                  END
               ELSE
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                     FIL:Description = LIB:Description
                     FIL:Description =  SUB(Contents(?FIL:Description),1,SAV:PROP:SelStart#-1) & LIB:Description & SUB(Contents(?FIL:Description),SAV:PROP:SelStart#,1000)
                  END
               END
            ELSE
              FIL:Description = LIB:Description
            END
            DISPLAY(?FIL:Description)
            SELECT(?FIL:Description,SAV:PROP:SelStart# + LEN(LIB:Description))
         END
         CLEAR(GlobalRequest)
      ELSE
         MESSAGE('This Field does not have a Tooltip.||Unable to display the lookup library.','Program Error',ICON:Exclamation)
      END
      
      
      
      
    OF ?OK
      ThisWindow.Update
      IF SELF.Request = ViewRecord
        POST(EVENT:CloseWindow)
      END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeCloseEvent PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  IF ?GLO:MakeFeeNoteFlag{Prop:Checked} = False
     GLO:MakeFeeNoteAmount = 0
  END
  
  
  IF ~(SAV:StageID = FIL:StageID) AND FIL:StageID
       GLO:CheckEventStageID = FIL:StageID
  END
  
  ReturnValue = PARENT.TakeCloseEvent()
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
  ReturnValue = PARENT.TakeCompleted()
   !MESSAGE('ThisWindow.TakeCompleted|FIL:ToDoNoteID = ' & FIL:ToDoNoteID & '|FIL:Description = ' & FIL:Description)
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
   
  
  RETURN ReturnValue


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  PDPC:FIL:Date.TakeEvent()
  PDPC:LOC:ReminderDate.TakeEvent()
  LOOP
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeEvent()
    WordDoc10.TakeEvent ('', '')
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
  CASE FIELD()
  OF ?LOC:StageCode
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
    END
  END
   IF GLO:MakeToDoNoteFlag
      
      ?GLO:ToDoNoteDescription{PROP:Disable} = False
      ?GLO:ToDoNoteDays{PROP:Disable} = False
      ?GLO:ToDoNoteDays:Prompt{PROP:Disable} = False
      ?DaysTimeString{PROP:Disable} = False
      ?LOC:ReminderDate{PROP:Disable} = False
  
      IF ~GLO:ToDoNoteDays THEN GLO:ToDoNoteDays = 1.
      IF ~GLO:ToDoNoteDescription THEN GLO:ToDoNoteDescription = FIL:Description.
  
  ELSE
  
      GLO:ToDoNoteDays = 0
      GLO:ToDoNoteDescription = ''
      ?GLO:ToDoNoteDescription{PROP:Disable} = True
      ?GLO:ToDoNoteDays{PROP:Disable} = True
      ?GLO:ToDoNoteDays:Prompt{PROP:Disable} = True
      ?DaysTimeString{PROP:Disable} = True
      ?LOC:ReminderDate{PROP:Disable} = True
  
  END
  
  IF GLO:MakeFeeNoteFlag
     ?GLO:FeeNoteDescription{PROP:Disable} = False
     IF ~GLO:FeeNoteDescription
         GLO:FeeNoteDescription = FIL:Description
     END
  ELSE
     GLO:FeeNoteDescription = ''
     ?GLO:FeeNoteDescription{PROP:Disable} = True
  END
  
  DISPLAY
  
  ReturnValue = PARENT.TakeFieldEvent()
  IF FIELD()=?FIL:Date
    
  END
  IF FIELD()=?LOC:ReminderDate
    
  END
  IF ?FIL:Description{PROP:ScreenText}
     SAV:FIL:Description = ?FIL:Description{PROP:ScreenText}
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
            LOC:MatterDescription = MAT:Description
            Display
      
      
            Break
          .
          SetKeycode(0)
        .
    OF ?LOC:ToDoNote
          GET(Reminders:Queue,CHOICE())
          FIL:ToDoNoteID = REMQ:RecordID
          
    OF ?LOC:StageCode
      STA:RecordID = 0
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        STA:StageGroupID = MAT:StageGroupID
        STA:Code = Contents(?)
        Set(STA:StageGroupKey,STA:StageGroupKey)
        If KeyCode() = DownKey Then Next(Stage).
        If KeyCode() = UpKey Then Previous(Stage).
        Loop
          If KeyCode() = UpKey Then Previous(Stage) Else Next(Stage).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (Stage) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(STA:InactiveFlag = 0) Then Cycle.
          If ~(Upper(Contents(?)) = Upper(Sub(STA:Code,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,STA:Code)
            ?{PROP:SelEnd} = Len(STA:Code)
            ?{PROP:Touched} = True
            LOC:StageDesc = STA:Description
            LOC:StageCode = STA:Code
            FIL:StageID = STA:RecordID
            !pk here
            Display
      
      
            Post(EVENT:Accepted,?LOC:StageCode)
            Break
          .
          SetKeycode(0)
        .
    END
  ReturnValue = PARENT.TakeNewSelection()
  
  ! REMOVED PREEMPTIVE LIBRARY LOOKUPS FROM TEMPLATE ON 27/5/2009
  ! SUSPECT IT WAS CAUSING PERFORMANCE ISSUES AND POSSIBLY EXITING WITHOUT ERRORS (BECAUSE IT WAS DOING THIS INTERMTTENTLY WHEN TESTING TODAY)
  
  
  
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeSelected PROCEDURE

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
    OF ?FIL:Description
      IF FIL:StageID AND ~FIL:Description
         FIL:Description = LOC:StageDesc
         DISPLAY(?FIL:Description)
      END
      
    END
  ReturnValue = PARENT.TakeSelected()
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
    OF EVENT:LoseFocus
       QuickWindow{PROP:Timer} = 0
       !ADDED QUICK SAVED - kELVIN fb491 24 Nov 2016
       SAV:FIL:Description = ?FIL:Description{PROP:ScreenText}
       FIL:Description = SAV:FIL:Description
       DISPLAY(?FIL:Description)
       !Removed CLIP - FB491 - reuqets from jennifer 28 Nov 2016
       !?FIL:Description{PROP:Selected} = LEN(CLIP(FIL:Description)) + 1
       ?FIL:Description{PROP:Selected} = LEN(FIL:Description) + 1
    OF EVENT:GainFocus
       QuickWindow{PROP:Timer} = 500
      
       FIL:Description = SAV:FIL:Description
       DISPLAY(?FIL:Description)
       !Removed CLIP - FB491 - reuqets from jennifer 28 Nov 2016
       !?FIL:Description{PROP:Selected} = LEN(CLIP(FIL:Description)) + 1
       ?FIL:Description{PROP:Selected} = LEN(FIL:Description) + 1
    OF EVENT:Timer
      SAV:FIL:Description = ?FIL:Description{PROP:ScreenText}
    END
  ReturnValue = PARENT.TakeWindowEvent()
    CASE EVENT()
    OF EVENT:AlertKey
        if KeyCode() = F7Key                          ! CapeSoft Office Inside - SpellChecking
            do Rtn_CheckSpelling_WordDoc10
        end
    OF EVENT:CloseWindow
      WordDoc10.Kill()
          WordDoc10.Kill()
    OF EVENT:Timer
      
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

ThisSecProc.Init  PROCEDURE()
  Code
  Free(LocalSecFieldQueue)
  Loop a# = 1 to 100
    Execute a#
      Begin
        LSFQ:Field = ?FIL:Date
        LSFQ:Description = 'Date'
      End
      Begin
        LSFQ:Field = ?LOC:Employee
        LSFQ:Description = 'Employee'
      End
      Begin
        LSFQ:Field = ?LookupEmployeeButton
        LSFQ:Description = 'Employee Lookup Button'
      End
      Begin
        LSFQ:Field = ?FIL:InternalFlag
        LSFQ:Description = 'Internal Flag'
      End
       Break
    .
    If LSF:CheckFieldFlag
      Clear(SF:Record)
      SF:SecGroupId = GLO:SecGroupId
      SF:SecProc    = 'Matters - Desktop - File Notes - Update'
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
    SP:Description = 'Matters - Desktop - File Notes - Update - Insert'
  Of ChangeRecord
    LSF:CheckFieldFlag = True
    SP:Description = 'Matters - Desktop - File Notes - Update - Change'
  Of DeleteRecord
    SP:Description = 'Matters - Desktop - File Notes - Update - Delete'
  Of ViewRecord
    SP:Description = 'Matters - Desktop - File Notes - Update - View'
  Else
    SP:Description = 'Matters - Desktop - File Notes - Update'
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
    BrowseSecProc('Matters - Desktop - File Notes - Update',1)
    Return Level:Benign
!---------------------------------------------------------------------------------
WordDoc10.CheckSpelling_Init   PROCEDURE ()
ReturnValue   long
  CODE
  ReturnValue = PARENT.CheckSpelling_Init ()
  self.TakeSnapShotOfWindowPos()

  Return ReturnValue
!---------------------------------------------------------------------------------
!---------------------------------------------------------------------------------
WordDoc10.CheckSpelling_Kill   PROCEDURE ()
ReturnValue   long
  CODE
  self.RestoreSnapShotOfWindowPos()
  ReturnValue = PARENT.CheckSpelling_Kill ()
  Return ReturnValue
!---------------------------------------------------------------------------------
!---------------------------------------------------------------------------------
WordDoc10.GetRtfText   PROCEDURE (*string checkText, long hControl)
  CODE
    case hControl
    end
    return
  PARENT.GetRtfText (checkText,hControl)
!---------------------------------------------------------------------------------
WordDoc10.Init   PROCEDURE (long pStartVisible=1, long pEnableEvents=1)
ReturnValue   long
  CODE
  ReturnValue = PARENT.Init (pStartVisible,pEnableEvents)
  self.TakeSnapShotOfWindowPos()

  Return ReturnValue
!---------------------------------------------------------------------------------
!---------------------------------------------------------------------------------
WordDoc10.Kill   PROCEDURE (long pUnloadCOM=1)
ReturnValue   long
  CODE
  self.RestoreSnapShotOfWindowPos()
  ReturnValue = PARENT.Kill (pUnloadCOM)
  Return ReturnValue
!---------------------------------------------------------------------------------
!---------------------------------------------------------------------------------
WordDoc10.ReplaceRtfText   PROCEDURE (string oldWord, string newWord, long hControl)
  CODE
    case hControl
    end
    return
  PARENT.ReplaceRtfText (oldWord,newWord,hControl)
!---------------------------------------------------------------------------------
WordDoc10.SpellWord   PROCEDURE (string pWord, *oiwWordsQ WordsQ, *long pCommand)
ReturnValue    string(255)
  CODE
    return oiShowSpellingSuggestions (pWord, WordsQ, pCommand)
  ReturnValue = PARENT.SpellWord (pWord,WordsQ,pCommand)
  Return ReturnValue
!---------------------------------------------------------------------------------
!---------------------------------------------------------------------------------
WordDoc10.TakeEvent   PROCEDURE (string pEventString1, string pEventString2, long pEventNumber=0, long pEventType=0, long pEventStatus=0)
  CODE
  PARENT.TakeEvent (pEventString1,pEventString2,pEventNumber,pEventType,pEventStatus)
    if pEventType = 0 and Event() = Event:Accepted
    end
PDPC:FIL:Date.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF FIL:Date <> L:Default
    POST(EVENT:Accepted,?FIL:Date)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:LOC:ReminderDate.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF LOC:ReminderDate <> L:Default
    POST(EVENT:Accepted,?LOC:ReminderDate)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDSC:FIL:Date.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV
PDSC:LOC:ReminderDate.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV

Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults

