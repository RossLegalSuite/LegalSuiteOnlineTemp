

   MEMBER('ACCOUNTS.clw')                             ! This is a MEMBER module


   INCLUDE('ABDROPS.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('ACCOU096.INC'),ONCE        !Local module procedure declarations
                       INCLUDE('ACCOU008.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('ACCOU011.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('ACCOU019.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('ACCOU024.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('ACCOU053.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('ACCOU056.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('ACCOU097.INC'),ONCE        !Req'd for module callout resolution
                     END


ProcessSetArchive PROCEDURE                           !Generated from procedure template - Window

FilesOpened          BYTE
Progress:Thermometer BYTE
ezField              LONG
LOC:ArchiveOption    BYTE(1)
LOC:Notes            CSTRING(1000)
LOC:Archived         LONG
LOC:Pending          LONG
LOC:Unarchived       LONG
LOC:Ignored          LONG
LOC:Message          CSTRING(255)
LOC:Count            LONG
SAV:ArchiveFlag      BYTE
ThisSecProc    Class()
CheckAccess       PROCEDURE(),BYTE,PROC
Update            PROCEDURE(),BYTE,PROC
                End
ProgressWindow       WINDOW('Progress...'),AT(,,232,235),FONT('Arial',9,,),CENTER,TIMER(1),GRAY,DOUBLE,MDI
                       TEXT,AT(8,12,213,153),USE(LOC:Notes),SKIP,TRN,COLOR(COLOR:BTNFACE),READONLY
                       SHEET,AT(4,4,224,200),USE(?Sheet1),WIZARD
                         TAB('Tab 1'),USE(?Tab1)
                           OPTION,AT(8,168,213,28),USE(LOC:ArchiveOption),BOXED
                             RADIO('Archive'),AT(16,180),USE(?LOC:Flag:Radio1),TIP('Archive all Tagged Matters'),VALUE('1')
                             RADIO('UnArchive'),AT(80,180),USE(?LOC:UnarchiveFlag),TIP('Unarchive all Tagged Matters (make live)'),VALUE('0')
                             RADIO('Set To Pending'),AT(148,180),USE(?LOC:UnarchiveFlag:2),TIP('Set matter to pending. <13,10>A pending matter is set set to archived at month-end <13,10>' &|
   'if its balance is zero'),VALUE('2')
                           END
                         END
                       END
                       BUTTON('&OK'),AT(104,209,60,20),USE(?OK),LEFT,FONT(,11,,),TIP('Accept this screen'),ICON('check3.ico'),DEFAULT
                       BUTTON('&Cancel'),AT(168,209,60,20),USE(?Cancel),LEFT,FONT(,11,,),TIP('Cancel this screen'),ICON('delete32.ico')
                     END

ProcessWindow WINDOW('Progress...'),AT(,,202,73),FONT('MS Sans Serif',8,,),CENTER,TIMER(1),GRAY,DOUBLE, |
         MDI
       SHEET,AT(4,4,192,62),USE(?Sheet2),WIZARD
         TAB('Tab 2'),USE(?Tab2)
           GROUP,AT(8,8,182,47),USE(?Group1),BOXED
             STRING(''),AT(15,16,167,10),USE(?Progress:UserString),CENTER
             PROGRESS,USE(LOC:Count),AT(15,29,167,10),RANGE(0,100)
             STRING(''),AT(15,40,167,10),USE(?Progress:PctText),CENTER
           END
         END
       END
     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass

  CODE
  GlobalResponse = ThisWindow.Run()

ProcessTaggedMatters        Routine
  Open(ProcessWindow)
  LOC:Count = 0
  ?LOC:Count{PROP:RangeHigh} = CntTag:PtrM(Tag:Matter)
  Display
  Clear(MAT:Record)
  MAT:RecordID = FstTag:PtrM(Tag:Matter)                ! SET TO THE FIRST TAGGED MATTER
  Loop While MAT:RecordID
    If ~Access:Matter.TryFetch(MAT:PrimaryKey)
      Do SetArchiveFlag
      If Access:Matter.Update()
        If Message('Error Updating Matter|Matter: ' & MAT:FileRef & '|Error: ' & Error() & ' ' & FileError(),'Archive Tagged Matters',ICON:Exclamation,'&Ignore|&Cancel') = 2 Then Break.
      .
    .
    MAT:RecordID = NxtTag:PtrM(Tag:Matter)                ! SET TO NEXT MATTER
    LOC:Count += 1
    Display
  .
  Close(ProcessWindow)
  If LOC:Archived
    If LOC:Message Then LOC:Message = LOC:Message & '|'.
    LOC:Message = LOC:Message & LOC:Archived & ' matter/s archived'
  .
  If LOC:Archived
    If LOC:Message Then LOC:Message = LOC:Message & '|'.
    LOC:Message = LOC:Message & LOC:Pending & ' matter/s set as pending'
  .
  If LOC:Unarchived
    If LOC:Message Then LOC:Message = LOC:Message & '|'.
    LOC:Message = LOC:Message & LOC:Unarchived & ' matter/s unarchived'
  .
  If LOC:Message = ''
    Execute LOC:ArchiveOption + 1
      LOC:Message = 'No matter/s archived!'
      LOC:Message = 'No matter/s unarchived!'
      LOC:Message = 'No matter/s set to pending'
    .
  .
  If LOC:Ignored
    If LOC:Message Then LOC:Message = LOC:Message & '|'.
    LOC:Message = LOC:Message & LOC:Ignored & ' matter/s ignored'
  .
  Message(LOC:Message,'Archive/Unarchive Matters',ICON:Asterisk)
  If Records(GEQ:ErrorQueue) Then BrowseErrorQueue('Archive Information').
SetArchiveFlag  Routine
  SAV:ArchiveFlag = MAT:ArchiveFlag
  Case LOC:ArchiveOption
  Of 1  ! Archive
    If MAT:ArchiveNo <= 0 Then MAT:ArchiveNo = GetNextArchiveNo().
    If (MAT:Actual or MAT:Reserved or MAT:Invested or MAT:Transfer or MAT:BatchedNormal or MAT:BatchedReserved or MAT:BatchedInvested) |
       or (MAT:AgeCurrent or MAT:Age30Day or MAT:Age60Day or MAT:Age90Day or MAT:Age120Day or MAT:Age150Day or MAT:Age180Day) |
       or ((MAT:ConsolidatedFlag = 1 or MAT:ConsolidatedFlag = 2) and (MAT:Actual <> 0 or MAT:Reserved <> 0 or MAT:TotalFees <> 0 or MAT:TotalDisbursements <> 0 or MAT:TotalReceipts <> 0 or MAT:TotalPayments <> 0 or MAT:TotalJournal <> 0)) |
       or (MAT:CreateInvoiceFlag and MAT:InvoiceFlag)
      If MAT:ArchiveFlag = False and MAT:ArchiveStatus = 1
        LOC:Ignored += 1
        GEQ:Message1 = 'Matter: ' & MAT:FileRef
        GEQ:Message2 = 'Ignored (Already Set To Pending)'
        GEQ:Message3 = 'Reserved Archive No: ' & MAT:ArchiveNo
        Add(GEQ:ErrorQueue)
      Else
        MAT:ArchiveFlag = False
        MAT:ArchiveStatus = 1
        LOC:Pending += 1
        GEQ:Message1 = 'Matter: ' & MAT:FileRef
        GEQ:Message2 = 'Set To Pending'
        GEQ:Message3 = 'Reserved Archive No: ' & MAT:ArchiveNo
        Add(GEQ:ErrorQueue)
      .
      MAT:ArchiveDate = 0
    Else
      If MAT:ArchiveFlag = True and MAT:ArchiveStatus = 2
        LOC:Ignored += 1
        GEQ:Message1 = 'Matter: ' & MAT:FileRef
        GEQ:Message2 = 'Ignored (Already Archived)'
        GEQ:Message3 = 'Archive No: ' & MAT:ArchiveNo
        Add(GEQ:ErrorQueue)
      Else
        MAT:ArchiveFlag = True
        MAT:ArchiveStatus = 2
        MAT:ExportedFlag = False ! Reset so that this matter is exported again
        LOC:Archived += 1
        GEQ:Message1 = 'Matter: ' & MAT:FileRef
        GEQ:Message2 = 'Archived'
        GEQ:Message3 = 'Archive No: ' & MAT:ArchiveNo
        Add(GEQ:ErrorQueue)
        
      .
      If ~MAT:ArchiveDate Then MAT:ArchiveDate = GLO:TodaysDate.
    .
  Of 2 ! Set To Pending
      If MAT:ArchiveFlag = False and MAT:ArchiveStatus = 1
        LOC:Ignored += 1
        GEQ:Message1 = 'Matter: ' & MAT:FileRef
        GEQ:Message2 = 'Ignored (Already Set To Pending)'
        GEQ:Message3 = Choose(MAT:ArchiveNo=0,'','Reserved Archive No: ' & MAT:ArchiveNo)
        Add(GEQ:ErrorQueue)
      Else
        MAT:ArchiveFlag = False
        MAT:ArchiveStatus = 1
        LOC:Pending += 1
        GEQ:Message1 = 'Matter: ' & MAT:FileRef
        GEQ:Message2 = 'Set To Pending'
        GEQ:Message3 = Choose(MAT:ArchiveNo=0,'','Reserved Archive No: ' & MAT:ArchiveNo)
        Add(GEQ:ErrorQueue)
      .
  Else ! Un Archaive
    If MAT:ArchiveFlag = False and MAT:ArchiveStatus = 0
      LOC:Ignored += 1
      GEQ:Message1 = 'Matter: ' & MAT:FileRef
      GEQ:Message2 = 'Ignored (Already Live)'
      GEQ:Message3 = ''
      Add(GEQ:ErrorQueue)
    Else
      MAT:ArchiveFlag = False
      MAT:ArchiveStatus = 0
      MAT:ExportedFlag = False ! Reset so that this matter is exported again
      LOC:Unarchived +=1
      GEQ:Message1 = 'Matter: ' & MAT:FileRef
      GEQ:Message2 = 'Set To Live'
      GEQ:Message3 = ''
      Add(GEQ:ErrorQueue)
    .
    MAT:ArchiveDate = 0
  .
  If SAV:ArchiveFlag <> MAT:ArchiveFlag Then
  MAT:ExportedFlag = False
    IF MAT:ArchiveFlag = true THEN
        !FB847   Kelvin 7 6 2017
        Access:Matter.Update
        ProcessSystemEvent(EVENT:MatterArchived,MAT:RecordID)
    END
  END
  

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('ProcessSetArchive')
  SELF.Request = GlobalRequest
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?LOC:Notes
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)
  CLEAR(GlobalResponse)
  SELF.AddItem(Translator)
  SELF.AddItem(?OK,RequestCompleted)
  SELF.AddItem(?Cancel,RequestCancelled)
  Relate:Matter.Open
  SELF.FilesOpened = True
  LOC:Notes = 'NOTES' & '<13,10,13,10>'
  LOC:Notes = LOC:Notes & '1.  If the following balances are not zero then the matter will be set to pending (Actual, Reserved, Invested, Transfer and Batched).' & '<13,10,13,10>'
  LOC:Notes = LOC:Notes & '2.  Matters with outstanding invoices will be set to pending' & '<13,10,13,10>'
  LOC:Notes = LOC:Notes & '3.  Pending matters are checked at month-end.  If the balance of the matter is zero then the matter will be archived.' & '<13,10,13,10>'
  LOC:Notes = LOC:Notes & '4.  Archived numbers are allocated to matters when they are set to archived or as pending.  Once a matter has been given an archive number that number remains with the matter even if the matter is unarchived (Set to live)' & '<13,10,13,10>'
  LOC:Notes = LOC:Notes & '5.  If you capture a batch transaction to an archived matter, that matter will automatically be unarchived when the batch is posted.'
  Free(GEQ:ErrorQueue)
  OPEN(ProgressWindow)
  SELF.Opened=True
    If GLO:SecMatterArchivedFlag = False and ~GLO:SupervisorFlag Then ?LOC:UnArchiveFlag{PROP:Disable} = True.
       ProgressWindow{Prop:Alrt,254}=1024
       ProgressWindow{Prop:Alrt,255}=AltF12
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Matter.Close
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    If ThisSecProc.CheckAccess() Then Return RequestCancelled.
  ReturnValue = PARENT.Run()
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
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?OK
      ThisWindow.Update
      Do ProcessTaggedMatters
    END
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
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisSecProc.CheckAccess  PROCEDURE()
  Code
  Clear(SP:Record)
  SP:SecGroupId = GLO:SecGroupId
  SP:AccessFlag = GLO:SupervisorFlag
  SP:Description = 'File - Archive Tagged Mattes'
  IF Access:SecProc.TryFetch(SP:SecGroupKey) Then Access:SecProc.Insert().
  If ~SP:AccessFlag and ~GLO:SupervisorFlag
    Message('Access Denied||Your security settings do not allow you access to this area of the program.|',SP:Description,'~lock.ico')
    Return Level:Notify
  .
  Return Level:Benign

ThisSecProc.Update  PROCEDURE()
  Code
    Free(GFQ:FieldQueue)
    BrowseSecProc('File - Archive Tagged Mattes',0)
    Return Level:Benign
UpdateFeeNote PROCEDURE                               !Generated from procedure template - Window

GroupComments     Group,PRE()
SAV:FN:MatterId    Like(FN:MatterId)
SAV:FN:Type1       Like(FN:Type1)
SAV:FN:Code2       Like(FN:Code2)
LOC:Comments1       CString(500)
LOC:Comments2       CString(500)

               .
SAV:MatterID      LONG

CurrentTab           STRING(80)
FilesOpened          BYTE
ActionMessage        CSTRING(40)
ezField              LONG
LOC:Details          STRING(255)
LOC:PeriodName       CSTRING(20)
LOC:Business         CSTRING(50)
LOC:Unit             CSTRING(50)
LOC:Matter           CSTRING(50)
LOC:CostCentre       CSTRING(50)
LOC:Employee         CSTRING(50)
LOC:Fee              CSTRING(50)
LOC:Code2            CSTRING(50)
LOC:Creditor         CSTRING(50)
LOC:LanguageId       LONG
LOC:IncomeAccId      LONG
LOC:FCode2           LONG
LOC:DCode2           LONG
LOC:FeeSheetFlag     BYTE
LOC:FeeSheetDesc     CSTRING(100)
LOC:FeeCodeDesc      CSTRING(100)
LOC:FeeItemDesc      CSTRING(100)
LOC:TaggedMattersFlag BYTE
LOC:CCode2           LONG
LOC:Source           CSTRING(20)
SAV:Date             LONG
LOC:RCode2           LONG
LOC:FFilter          CSTRING('01,02,03<0>{11}')
LOC:DFilter          CSTRING('01,02,03,11,12<0>{5}')
LOC:RFilter          CSTRING('11<0>{17}')
LOC:PostedBy         CSTRING(255)
Queue:FileDropCombo:2 QUEUE                           !Queue declaration for browse/combo box using ?LOC:Creditor
CRM:Description        LIKE(CRM:Description)          !List box control field - type derived from field
CRM:RecordID           LIKE(CRM:RecordID)             !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
Queue:FileDropCombo:1 QUEUE                           !Queue declaration for browse/combo box using ?LOC:Code2
BLM1:Description       LIKE(BLM1:Description)         !List box control field - type derived from field
BLM1:RecordId          LIKE(BLM1:RecordId)            !Browse hot field - type derived from field
BLM1:Type              LIKE(BLM1:Type)                !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
Queue:FileDropCombo  QUEUE                            !Queue declaration for browse/combo box using ?LOC:Fee
BLM2:Description       LIKE(BLM2:Description)         !List box control field - type derived from field
BLM2:RecordId          LIKE(BLM2:RecordId)            !Browse hot field - type derived from field
BLM2:Type              LIKE(BLM2:Type)                !Browse hot field - type derived from field
BLM2:NotUsedFlag       LIKE(BLM2:NotUsedFlag)         !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
Queue:FileDropCombo:5 QUEUE                           !Queue declaration for browse/combo box using ?LOC:Employee
EMP:Name               LIKE(EMP:Name)                 !List box control field - type derived from field
EMP:RecordID           LIKE(EMP:RecordID)             !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
Queue:FileDropCombo:4 QUEUE                           !Queue declaration for browse/combo box using ?LOC:CostCentre
COS:Description        LIKE(COS:Description)          !List box control field - type derived from field
COS:RecordID           LIKE(COS:RecordID)             !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
Queue:FileDropCombo:3 QUEUE                           !Queue declaration for browse/combo box using ?BLM3:Description
BLM3:Description       LIKE(BLM3:Description)         !List box control field - type derived from field
BLM3:RecordId          LIKE(BLM3:RecordId)            !Browse hot field - type derived from field
BLM3:Type              LIKE(BLM3:Type)                !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
FDCB28::View:FileDropCombo VIEW(Creditor)
                       PROJECT(CRM:Description)
                       PROJECT(CRM:RecordID)
                     END
FDCB27::View:FileDropCombo VIEW(BusinessAlias)
                       PROJECT(BLM1:Description)
                       PROJECT(BLM1:RecordId)
                       PROJECT(BLM1:Type)
                     END
FDCB25::View:FileDropCombo VIEW(BusinessAlias2)
                       PROJECT(BLM2:Description)
                       PROJECT(BLM2:RecordId)
                       PROJECT(BLM2:Type)
                       PROJECT(BLM2:NotUsedFlag)
                     END
FDCB31::View:FileDropCombo VIEW(Employee)
                       PROJECT(EMP:Name)
                       PROJECT(EMP:RecordID)
                     END
FDCB30::View:FileDropCombo VIEW(CostCentre)
                       PROJECT(COS:Description)
                       PROJECT(COS:RecordID)
                     END
FDCB6::View:FileDropCombo VIEW(BusinessAlias3)
                       PROJECT(BLM3:Description)
                       PROJECT(BLM3:RecordId)
                       PROJECT(BLM3:Type)
                     END
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
QuickWindow          WINDOW('Fee Note Update Form'),AT(,,348,298),FONT('Arial',9,,),CENTER,IMM,HLP('CaptureF'),SYSTEM,GRAY,DOUBLE,MDI
                       SHEET,AT(4,4,339,265),USE(?CurrentTab)
                         TAB('&Transaction  '),USE(?TransactionTab)
                           OPTION('Type'),AT(12,24,209,29),USE(FN:Type1),BOXED,MSG('Fee/Disbursement/Revenue Stamp/Creditor'),TIP('Fee/Disbursement/Revenue Stamp/Creditor')
                             RADIO('Fee'),AT(18,35,28,11),USE(?FN:Type1:Radio1),VALUE('F')
                             RADIO('Disbursement'),AT(47,35,63,10),USE(?FN:Type1:Radio2),VALUE('D')
                             RADIO('Revenue Stamp'),AT(110,35),USE(?FN:Type1:Radio3),VALUE('R')
                             RADIO('Creditor'),AT(176,35,43,10),USE(?FN:Type1:Radio4),VALUE('C')
                           END
                           GROUP,AT(12,56,320,74),USE(?Group9),BOXED
                             PROMPT('&Date:'),AT(19,65),USE(?FN:Date:Prompt),TRN
                             SPIN(@d17),AT(72,65,60,10),USE(FN:Date),IMM,RIGHT(1),FONT('MS Sans Serif',,,),STEP(1),MSG('The date the fee note was made')
                             PROMPT('&Matter:'),AT(19,81),USE(?LOC:Matter:Prompt),TRN
                             ENTRY(@s49),AT(72,81,238,10),USE(LOC:Matter),IMM,FONT('MS Sans Serif',,,),COLOR(0BDFFFFH),ALRT(UpKey),ALRT(DownKey),REQ
                             BUTTON('...'),AT(314,81,10,10),USE(?LookupMatterButton),SKIP
                             PROMPT('Description:'),AT(19,97),USE(?FN:Description:Prompt),TRN
                             ENTRY(@s255),AT(72,97,238,10),USE(FN:Description),IMM,FONT('MS Sans Serif',,,),COLOR(0BDFFFFH),TIP('Fee Description<13,10>Ctrl Z - Zoom'),ALRT(CtrlZ),REQ,MSG('Description of the fee note')
                             TEXT,AT(72,97,238,10),USE(FN:Description,,?FN:Description:Text),TIP('Fee Description<13,10>F2 - Zoom'),ALRT(F2Key),REQ,SINGLE,MSG('Description of the fee note')
                             BUTTON,AT(314,97,9,10),USE(?SelectFeeNoteDescription),SKIP,LEFT,TIP('Select Description From Lookup Library'),ICON('Lookup.ico')
                             BUTTON,AT(59,96,11,11),USE(?FN:Description:Zoom),SKIP,TIP('Zoom Description'),ALRT(CtrlZ),ICON(ICON:Paste)
                             PROMPT('Voucher:'),AT(19,113),USE(?FN:Voucher:Prompt),TRN
                             ENTRY(@s19),AT(72,113,55,10),USE(FN:Voucher),FONT('MS Sans Serif',,,),MSG('Voucher'),TIP('Voucher')
                             CHECK('Send To Debtor''s Account?'),AT(232,115,96,10),USE(FN:AddToCollDebitFlag),SKIP
                           END
                           GROUP,AT(12,132,208,41),USE(?VATGroup),BOXED
                             PROMPT('&Amount:'),AT(19,142),USE(?FN:Amount:Prompt),TRN
                             ENTRY(@n-15.2),AT(79,142,53,10),USE(FN:Amount),DECIMAL(12),FONT('MS Sans Serif',,,),MSG('The actual amount'),TIP('The actual amount')
                             LIST,AT(139,142,73,10),USE(?VatRate),FONT('MS Sans Serif',,,),DROP(10),FROM('1 - 14.00%|2 - 10.00%|3 - 0.00%|No VAT|Zero Rated')
                             PROMPT('VAT:'),AT(19,158),USE(?FN:VatAmount:Prompt),TRN,HIDE
                             ENTRY(@n-18.2),AT(79,158,53,10),USE(FN:VatAmount),HIDE,DECIMAL(12),FONT('MS Sans Serif',,,)
                             LIST,AT(139,158,73,10),USE(?VatIE),HIDE,FONT('MS Sans Serif',,,),MSG('Including/Excluding VAT'),TIP('Including/Excluding VAT'),DROP(5),FROM('Including VAT|Excluding VAT')
                           END
                           GROUP,AT(12,185,208,28),USE(?GroupDCode2),BOXED,HIDE
                             PROMPT('Account:'),AT(20,197),USE(?LOC:Code2:Prompt:2)
                             COMBO(@s49),AT(76,197,120,10),USE(LOC:Code2),IMM,FONT('MS Sans Serif',,,),REQ,FORMAT('196L@s49@'),DROP(10),FROM(Queue:FileDropCombo:1)
                             BUTTON('...'),AT(200,197,10,10),USE(?SelectCode2),SKIP
                           END
                           GROUP,AT(12,180,208,38),USE(?GroupFCode2),BOXED,HIDE
                             CHECK('Override Income Account?'),AT(76,188),USE(FN:OverrideIncomeAccFlag),MSG('Force all fees to be posted to a specific income account'),TIP('Force all fees to be posted to a specific income account')
                             PROMPT('Account:'),AT(20,201),USE(?Prompt15)
                             COMBO(@s49),AT(76,201,120,10),USE(LOC:Fee),IMM,SKIP,FONT('MS Sans Serif',,,),COLOR(COLOR:BTNFACE),REQ,READONLY,FORMAT('196L@s49@'),DROP(10),FROM(Queue:FileDropCombo)
                             BUTTON('...'),AT(200,201,10,10),USE(?SelectFee),SKIP
                           END
                           GROUP,AT(12,185,208,28),USE(?GroupRCode2),BOXED
                             PROMPT('Account:'),AT(20,197),USE(?LOC:Code2:Prompt)
                             COMBO(@s49),AT(76,197,120,10),USE(BLM3:Description),IMM,FONT('MS Sans Serif',,,),FORMAT('196L(2)|M@s49@'),DROP(5),FROM(Queue:FileDropCombo:3),MSG('Description')
                             BUTTON('...'),AT(200,197,10,10),USE(?SelectRCode2),SKIP
                           END
                           GROUP,AT(12,220,208,41),USE(?GroupIncomeExpense),BOXED,HIDE
                             PROMPT('Cost Centre:'),AT(19,230),USE(?LOC:CostCentre:Prompt)
                             COMBO(@s49),AT(76,230,120,10),USE(LOC:CostCentre),IMM,FONT('MS Sans Serif',,,),REQ,FORMAT('76L@s19@'),DROP(10),FROM(Queue:FileDropCombo:4)
                             BUTTON('...'),AT(200,230,10,10),USE(?SelectCostCentre),SKIP
                             PROMPT('Employee'),AT(19,244),USE(?LOC:Employee:Prompt)
                             COMBO(@s49),AT(76,244,120,10),USE(LOC:Employee),IMM,FONT('MS Sans Serif',,,),REQ,FORMAT('116L@s29@'),DROP(10),FROM(Queue:FileDropCombo:5)
                             BUTTON('...'),AT(200,244,10,10),USE(?SelectEmployee),SKIP
                           END
                           GROUP,AT(12,185,208,28),USE(?GroupCreditor),BOXED,HIDE
                             PROMPT('Account:'),AT(20,197),USE(?LOC:Creditor:Prompt)
                             COMBO(@s49),AT(76,197,120,10),USE(LOC:Creditor),IMM,FONT('MS Sans Serif',,,),REQ,FORMAT('196L@s49@'),DROP(10),FROM(Queue:FileDropCombo:2)
                             BUTTON('...'),AT(200,197,10,10),USE(?SelectCreditor),SKIP
                           END
                         END
                         TAB('Details'),USE(?Tab3)
                           CHECK('Do Not Combine'),AT(14,24),USE(FN:DoNotCombineFlag),TIP('Turning this on will combine feenotes that have the same fee sheet detail'),MSG('Never combine this fee note')
                           CHECK('Post To Tagged Matters'),AT(85,24,86,10),USE(LOC:TaggedMattersFlag)
                           CHECK('Fee Note On Hold?'),AT(173,24),USE(FN:OnHold),MSG('Prevent this Fee Note from being posted to accounting')
                           GROUP,AT(12,35,255,105),USE(?Group12),BOXED
                             CHECK('Fee Details'),AT(19,51,48,10),USE(LOC:FeeSheetFlag),TIP('Clearing this field will remove the fee details')
                             PROMPT('Fee Sheet'),AT(19,66),USE(?LOC:FeeSheetDesc:Prompt)
                             ENTRY(@s99),AT(76,66,182,10),USE(LOC:FeeSheetDesc),SKIP,FONT('MS Sans Serif',,,),COLOR(COLOR:BTNFACE),MSG('Description'),TIP('Description'),READONLY
                             PROMPT('Fee Code:'),AT(19,81),USE(?LOC:FeeCodeDesc:Prompt)
                             ENTRY(@s99),AT(76,81,182,10),USE(LOC:FeeCodeDesc),SKIP,FONT('MS Sans Serif',,,),COLOR(COLOR:BTNFACE),READONLY
                             BUTTON('...'),AT(76,45,12,12),USE(?SelectFee:2)
                             PROMPT('Fee Item:'),AT(19,95),USE(?LOC:FeeItemDesc:Prompt)
                             ENTRY(@s99),AT(76,95,182,10),USE(LOC:FeeItemDesc),SKIP,FONT('MS Sans Serif',,,),COLOR(COLOR:BTNFACE),READONLY
                             PROMPT('&Fee Type:'),AT(19,111),USE(?Prompt17)
                             LIST,AT(76,111,60,10),USE(FN:Option1),FONT('MS Sans Serif',,,),DROP(10),FROM('Normal|#1|Admin|#2|Interest|#3|Coll Comm|#4|Agents Allowance|#5|Agreed Fee|#6')
                             PROMPT('Document Code:'),AT(18,127),USE(?Prompt16)
                             LIST,AT(76,127,110,10),USE(?DocumentCode),FONT('MS Sans Serif',,,),DROP(20),FROM('None')
                           END
                           GROUP,AT(12,145,255,82),USE(?Group15),BOXED
                             PROMPT('Posted:'),AT(20,161),USE(?Prompt20)
                             ENTRY(@d17),AT(76,161,60,10),USE(FN:PostedDate),LEFT(1),FONT('MS Sans Serif',,,)
                             PROMPT('Batch No:'),AT(156,161),USE(?FN:PostedBatchId:Prompt)
                             ENTRY(@n_10b),AT(191,161,50,10),USE(FN:PostedBatchId),LEFT(1),FONT('MS Sans Serif',,,)
                             ENTRY(@s254),AT(60,177,199,10),USE(LOC:PostedBy),SKIP,FONT('MS Sans Serif',,,),COLOR(COLOR:BTNFACE),MSG('Description'),TIP('Description'),READONLY
                             PROMPT('&Period:'),AT(20,193),USE(?Period),TRN
                             ENTRY(@s20),AT(60,193,52,10),USE(LOC:PeriodName),SKIP,FONT('MS Sans Serif',,,),COLOR(COLOR:BTNFACE),READONLY
                             BUTTON('...'),AT(114,193,10,10),USE(?SelectPeriod),SKIP,HIDE
                             PROMPT('Source:'),AT(20,209),USE(?LOC:Source:Prompt)
                             ENTRY(@s19),AT(60,209,199,10),USE(LOC:Source),SKIP,FONT('MS Sans Serif',,,),COLOR(COLOR:BTNFACE),MSG('Description'),TIP('Description'),READONLY
                             PROMPT('Posted By:'),AT(20,177),USE(?Prompt20:2)
                             CHECK,AT(60,161),USE(FN:PostedFlag),DISABLE,TRN,MSG('This fee has been posted to accounting')
                           END
                         END
                       END
                       BUTTON('&OK'),AT(213,275,60,18),USE(?OK),LEFT,FONT(,11,,),ICON('check3.ico'),DEFAULT
                       BUTTON('&Cancel'),AT(281,275,62,18),USE(?Cancel),LEFT,FONT(,11,,),ICON('delete32.ico')
                     END

PDSC:FN:Date         CLASS(PDScrollCT)
TakeFieldEvent         PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDSC:FN:PostedDate   CLASS(PDScrollCT)
TakeFieldEvent         PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDPC:FN:Date         CLASS(PDPopCalBtnCT)
TakeAccepted           PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDPC:FN:PostedDate   CLASS(PDPopCalBtnCT)
TakeAccepted           PROCEDURE,BYTE,PROC,VIRTUAL
                     END
ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Open                   PROCEDURE(),DERIVED
PrimeUpdate            PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeCompleted          PROCEDURE(),BYTE,PROC,DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
TakeFieldEvent         PROCEDURE(),BYTE,PROC,DERIVED
TakeNewSelection       PROCEDURE(),BYTE,PROC,DERIVED
TakeSelected           PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
ToolbarForm          ToolbarUpdateClass               !Form Toolbar Manager
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END

FDCB28               CLASS(FileDropComboClass)        !File drop combo manager
Q                      &Queue:FileDropCombo:2         !Reference to browse queue type
                     END

FDCB:Code2           CLASS(FileDropComboClass)        !File drop combo manager
Q                      &Queue:FileDropCombo:1         !Reference to browse queue type
                     END

FDCB:Fee             CLASS(FileDropComboClass)        !File drop combo manager
Q                      &Queue:FileDropCombo           !Reference to browse queue type
ValidateRecord         PROCEDURE(),BYTE,DERIVED
                     END

FDCB31               CLASS(FileDropComboClass)        !File drop combo manager
Q                      &Queue:FileDropCombo:5         !Reference to browse queue type
                     END

FDCB30               CLASS(FileDropComboClass)        !File drop combo manager
Q                      &Queue:FileDropCombo:4         !Reference to browse queue type
                     END

FDCB6                CLASS(FileDropComboClass)        !File drop combo manager
Q                      &Queue:FileDropCombo:3         !Reference to browse queue type
ValidateRecord         PROCEDURE(),BYTE,DERIVED
                     END


  CODE
  GlobalResponse = ThisWindow.Run()

GetIncomeAccId        Routine
  If FN:OverrideIncomeAccFlag Then Exit.
  If LOC:IncomeAccId ! Matter Has Overriding Income Account
    LOC:FCode2 = LOC:IncomeAccId
    Exit
  .
  Case CTL:IncomeAccOption
  Of 1
    EMP:RecordId = FN:EmployeeId
    Access:Employee.Fetch(EMP:PrimaryKey)
    If EMP:IncomeAccId
      LOC:FCode2 = EMP:IncomeAccId
    Else
      Message('Employee :' & EMP:Name & '|Has No Default Income Account!|The Default Income Account Will Be Used','Set Income Account',ICON:Exclamation)
      FN:OverrideIncomeAccFlag = True
      LOC:FCode2 = CTL:IncomeAccId
    .
  Of 2
    COS:RecordId = FN:CostCentreId
    Access:CostCentre.Fetch(COS:PrimaryKey)
    If COS:IncomeAccId
      LOC:FCode2 = COS:IncomeAccId
    Else
      If COS:Description
        Message('Cost Centre: ' & COS:Description & '|Has No Default Income Account!|The Default Income Account Will Be Used','Set Income Account',ICON:Exclamation)
      Else
        Message('Cannot Find The Selected Cost Centre!|The Default Income Account Will Be Used','Set Income Account',ICON:Exclamation)
      .
      FN:OverrideIncomeAccFlag = True
      LOC:FCode2 = CTL:IncomeAccId
    .
  Of 3
    MAT:RecordID = FN:MatterID
    Access:Matter.Fetch(MAT:PrimaryKey)
    MT:RecordID = MAT:MatterTypeID
    Access:MatType.Fetch(MT:PrimaryKey)
    If MT:IncomeAccountID
      LOC:FCode2 = MT:IncomeAccountID
    Else
      If MT:Description
        Message('Matter Type :' & MT:Description & ' Has No Default Income Account!|The Default Income Account Will Be Used','Set Income Account',ICON:Exclamation)
      Else
        Message('Cannot Find The Matter Type For This Matter!|The Default Income Account Will Be Used','Set Income Account',ICON:Exclamation)
      .
      FN:OverrideIncomeAccFlag = True
      LOC:FCode2 = CTL:IncomeAccId
    .
  Of 0
    LOC:FCode2 = CTL:IncomeAccId
  .
GetFeeDetails           Routine
  FI:RecordID = FN:FeeItemId
  Access:FeeItem.Fetch(FI:PrimaryKey)
  LOC:FeeItemDesc = FI:Description

  FC:RecordID = FN:FeeCodeId
  Access:FeeCode.Fetch(FC:PrimaryKey)
  LOC:FeeCodeDesc = FC:Description

  FS:RecordID = FC:FeeSheetId
  Access:FeeSheet.Fetch(FS:PrimaryKey)
  LOC:FeeSheetDesc = FS:Description

  Display
SetType Routine
CheckComments   Routine
  If SAV:FN:MatterId <> FN:MatterId
    LOC:Comments1 = GetComments('M',FN:MatterId)
    SAV:FN:MatterId = FN:MatterId
  .
  FN:Code2 = Choose(Inlist(FN:Type1,'F','D','R','C'),LOC:FCode2,LOC:DCode2,LOC:RCode2,LOC:CCode2,0)
  If SAV:FN:Type1 <> FN:Type1 or SAV:FN:Code2 <> FN:Code2
    If FN:Type1 = 'C'
      LOC:Comments2 = GetComments('C',FN:Code2)
    Else
      LOC:Comments2 = GetComments('B',FN:Code2)
    .
    SAV:FN:Type1 = FN:Type1
    SAV:FN:Code2 = FN:Code2
  .

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request
  OF ViewRecord
    ActionMessage = 'View Record'
  OF InsertRecord
    ActionMessage = 'Fee Note Will Be Added'
  OF ChangeRecord
    ActionMessage = 'Fee Note Will Be Changed'
  END
  QuickWindow{Prop:Text} = ActionMessage
    IF CheckMatterAccess(FN:MatterID)  ! ADDED 8/11/2010
       0{PROP:Text} = 'FeeNote [View Only]'
       ?OK{PROP:Disable} = True
    END
  
    IF FN:RecordID THEN 0{PROP:Text} = 0{PROP:Text} & ' (' & FN:RecordID & ')'.
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    ThisSecProc.Init()
  GlobalErrors.SetProcedureName('UpdateFeeNote')
  SELF.Request = GlobalRequest
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?FN:Type1:Radio1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors
  SELF.FirstField = ?FN:Description
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)
  CLEAR(GlobalResponse)
  SELF.AddItem(Translator)
  SELF.AddUpdateFile(Access:FeeNote)
  SELF.AddItem(?Cancel,RequestCancelled)
  Relate:Business.Open
  Relate:BusinessAlias.Open
  Relate:BusinessAlias2.Open
  Relate:BusinessAlias3.Open
  Relate:ColDebit.Open
  Relate:Color.Open
  Relate:Control.Open
  Relate:CostCentre.Open
  Relate:Creditor.Open
  Relate:Employee.Open
  Relate:FeeCode.Open
  Relate:FeeItem.Open
  Relate:FeeNote.Open
  Relate:FeeSheet.Open
  Relate:Language.Open
  Relate:Library.Open
  Relate:Matter.Open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:FeeNote
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
  If GetControlFile() Then Return Level:Fatal.
  SAV:Date = FN:Date
  If Self.Request = InsertRecord
    FN:Source       = 'I'
    FN:MatterID     = MAT:RecordID
    LOC:Matter      = MAT:FileRef
    FN:Type1        = 'F'
    FN:Option1      = 1
    If GLO:FN_EmployeeID <= 0 ! All
      FN:EmployeeId = GLO:EmployeeID             
    Else
      FN:EmployeeID = GLO:FN_EmployeeID
    .
    !stop(CEM:UseMatterCostCentreFlag & ':' & MAT:CostCentreID & ':' & CEM:DefaultCostCentreId)
    FN:CostCentreId = Choose(CEM:UseMatterCostCentreFlag=1,MAT:CostCentreID,CEM:DefaultCostCentreId)
    FN:Date         = GLO:TodaysDate
    FN:VATRate      = '1'
    FN:VATIE       = Choose(CTL:FeeVatIEOption=1,'I','E')
    FN:AddToCollDebitFlag = True
    LOC:DCode2 = CTL:ExpenseId
    LOC:RCode2 = CTL:RevenueStampId
  Else
!    History::FN:Record.FN:MatterId = FN:MatterId
!    History::FN:Record.FN:Date = FN:Date
    If ~FN:Option1 Then FN:Option1 = 1.
    MAT:RecordId = FN:MatterId
    Access:Matter.Fetch(MAT:PrimaryKey)
    LOC:Matter     = MAT:FileRef
    LOC:LanguageId = MAT:AccountsLanguageID
  .
  LOC:PeriodName = GetPeriodName(FN:Period,FN:Year)
  If FN:FeeCodeID or FN:FeeItemID Then LOC:FeeSheetFlag = True.
  
  Case FN:Type1
  Of 'F'
    LOC:FCode2 = FN:Code2
  Of 'D'
    LOC:DCode2 = FN:Code2
  Of 'R'
    LOC:RCode2 = FN:Code2
  Of 'C'
    LOC:CCode2 = FN:Code2
  .
  LOC:Source = Choose(Inlist(FN:Source,'D','X','L','A','I','H','C','T','S'),'Desktop','Imported','LegalTrax','AddressBook','Inserted','LSW Monitor','Matter Transaction','Time Recording','Excalibur','UnKnown')
  LOC:PostedBy = GetDescription('Employee',FN:PostedBy)
  OPEN(QuickWindow)
  SELF.Opened=True
  ! ADDED BY RICK 24/6/04 - MAKES THE LOOKUP LIBRARY SELECT A DIFFERENT LIST IF
  ! THE MATTER IS AN AFRIKAANS MATTER
  If MAT:AccountsLanguageID = CTL:AfrikaansID Then FN:Description{PROP:Tooltip} = 'Fooi beskrywing'.
  
  Do GetFeeDetails
  
  If Self.Request = InsertRecord
    Post(EVENT:Accepted,?LOC:Matter)
  Else
    If ~CheckEmployeeAllowed(FN:EmployeeID) Then ?OK{PROP:Disable} = True.
  .

  If Self.Request = ChangeRecord and FN:PostedFlag Then ?FN:Type1{PROP:Disable} = True.





  If CTL:VatMethod = 'N'
    FN:VATRate = 'N'
    ?VatRate{PROP:Hide} = True
  Else
    ?VatRate{PROP:From} = GetVatRate('1') & '|' & GetVatRate('2') & '|' & GetVatRate('3') & '|' & GetVatRate('N') & '|' & GetVatRate('E') & '|' & GetVatRate('Z')
    ?VatRate{PROP:Selected} = Inlist(FN:VATRate,'1','2','3','N','E','Z')
    ?VatIE{PROP:Selected} = Inlist(FN:VatIE,'I','E')
  .

  ?DocumentCode{PROP:From} = 'None|Certified Extract of Civil Judgment|Emoluments Attachment Order|Sale of Immovable property|Judgement|Letter Of Demand|Sale of movable property|Postponed proceedings|Request for Default Judgment|Reissue Emoluments Attachment Order|Reissue Section 65 Notice to Appear in Court|Reissue Summons|Reissue Warrant of Execution|Section 57 Consent|Section 65 Notice to Appear in Court|Summons|Warrant of Arrest|Warrant of Execution'
  ?DocumentCode{PROP:Selected} = Inlist(FN:DocumentCode,'','CCJ','EMO','IMM','JUD','LOD','MOV','R41','RDJ','REEMO','RES65','RESUM','REWRI','S57','S65','SUM','WOA','WRI')
  
  If Len(Clip(FN:Description)) > 255
    ?FN:Description{PROP:Hide} = True
    ?FN:Description:Text{PROP:Hide} = False
  Else
    ?FN:Description{PROP:Hide} = False
    ?FN:Description:Text{PROP:Hide} = True
  .
  
  
  IF FN:PostedFlag

   ?OK{PROP:Hide} = True
   ?Cancel{PROP:Text} = 'Close'

   ?FN:VatAmount:Prompt{PROP:Hide} = False
   ?FN:VatAmount{PROP:Hide} = False

   ?VatRate{PROP:Hide} = True
   ?VatIE{PROP:Hide} = True

  END
  
  If 1
    MAT:RecordID = FN:MatterID
    If MAT:RecordID
      Access:Matter.Fetch(MAT:PrimaryKey)
      If GLO:MatterOption = 1
        Change(?LOC:Matter,MAT:OldCode)
      Else
        Change(?LOC:Matter,MAT:FileRef)
      .
    .
  .
       QuickWindow{Prop:Alrt,254}=1024
       QuickWindow{Prop:Alrt,255}=AltF12
  PDPC:FN:Date.Init(?FN:Date,FN:Date,PopCalQ,Def_Config,)
  PDPC:FN:PostedDate.Init(?FN:PostedDate,FN:PostedDate,PopCalQ,Def_Config,)
  PDSC:FN:Date.Init(FN:Date,PDSchedC,?FN:Date,,,)     ! NOTE: Date Scroll and Drop class range limits can be set with Field user options: PDDTRangeLow and PPDTRangeHigh
  PDSC:FN:Date.SetAlert(PDDT_eqSemiMonPlus+1,0)       ! Disable altdown key so it can be used by button.
  PDSC:FN:Date.AddDropID('PDPopCal')
  PDSC:FN:PostedDate.Init(FN:PostedDate,PDSchedC,?FN:PostedDate,,,) ! NOTE: Date Scroll and Drop class range limits can be set with Field user options: PDDTRangeLow and PPDTRangeHigh
  PDSC:FN:PostedDate.SetAlert(PDDT_eqSemiMonPlus+1,0) ! Disable altdown key so it can be used by button.
  PDSC:FN:PostedDate.AddDropID('PDPopCal')
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)
  SELF.AddItem(Resizer)
  SELF.AddItem(ToolbarForm)
  FDCB28.Init(LOC:Creditor,?LOC:Creditor,Queue:FileDropCombo:2.ViewPosition,FDCB28::View:FileDropCombo,Queue:FileDropCombo:2,Relate:Creditor,ThisWindow,GlobalErrors,0,1,0)
  FDCB28.Q &= Queue:FileDropCombo:2
  FDCB28.AddSortOrder(CRM:DescriptionKey)
  FDCB28.AddField(CRM:Description,FDCB28.Q.CRM:Description)
  FDCB28.AddField(CRM:RecordID,FDCB28.Q.CRM:RecordID)
  FDCB28.AddUpdateField(CRM:RecordID,LOC:CCode2)
  ThisWindow.AddItem(FDCB28.WindowComponent)
  FDCB28.DefaultFill = 0
  FDCB:Code2.Init(LOC:Code2,?LOC:Code2,Queue:FileDropCombo:1.ViewPosition,FDCB27::View:FileDropCombo,Queue:FileDropCombo:1,Relate:BusinessAlias,ThisWindow,GlobalErrors,0,1,0)
  BIND('LOC:DFilter',LOC:DFilter)
  FDCB:Code2.Q &= Queue:FileDropCombo:1
  FDCB:Code2.AddSortOrder(BLM1:DescriptionKey)
  FDCB:Code2.SetFilter('BLM1:Type <<= 3')
  FDCB:Code2.AddField(BLM1:Description,FDCB:Code2.Q.BLM1:Description)
  FDCB:Code2.AddField(BLM1:RecordId,FDCB:Code2.Q.BLM1:RecordId)
  FDCB:Code2.AddField(BLM1:Type,FDCB:Code2.Q.BLM1:Type)
  FDCB:Code2.AddUpdateField(BLM1:RecordId,LOC:DCode2)
  ThisWindow.AddItem(FDCB:Code2.WindowComponent)
  FDCB:Code2.DefaultFill = 0
  FDCB:Fee.Init(LOC:Fee,?LOC:Fee,Queue:FileDropCombo.ViewPosition,FDCB25::View:FileDropCombo,Queue:FileDropCombo,Relate:BusinessAlias2,ThisWindow,GlobalErrors,0,1,0)
  BIND('LOC:FFilter',LOC:FFilter)
  FDCB:Fee.Q &= Queue:FileDropCombo
  FDCB:Fee.AddSortOrder(BLM2:DescriptionKey)
  FDCB:Fee.SetFilter('BLM2:Type <<= 3')
  FDCB:Fee.AddField(BLM2:Description,FDCB:Fee.Q.BLM2:Description)
  FDCB:Fee.AddField(BLM2:RecordId,FDCB:Fee.Q.BLM2:RecordId)
  FDCB:Fee.AddField(BLM2:Type,FDCB:Fee.Q.BLM2:Type)
  FDCB:Fee.AddField(BLM2:NotUsedFlag,FDCB:Fee.Q.BLM2:NotUsedFlag)
  FDCB:Fee.AddUpdateField(BLM2:RecordId,LOC:FCode2)
  ThisWindow.AddItem(FDCB:Fee.WindowComponent)
  FDCB:Fee.DefaultFill = 0
  FDCB31.Init(LOC:Employee,?LOC:Employee,Queue:FileDropCombo:5.ViewPosition,FDCB31::View:FileDropCombo,Queue:FileDropCombo:5,Relate:Employee,ThisWindow,GlobalErrors,0,1,0)
  FDCB31.Q &= Queue:FileDropCombo:5
  FDCB31.AddSortOrder(EMP:NameKey)
  FDCB31.AddField(EMP:Name,FDCB31.Q.EMP:Name)
  FDCB31.AddField(EMP:RecordID,FDCB31.Q.EMP:RecordID)
  FDCB31.AddUpdateField(EMP:RecordID,FN:EmployeeID)
  ThisWindow.AddItem(FDCB31.WindowComponent)
  FDCB31.DefaultFill = 0
  FDCB30.Init(LOC:CostCentre,?LOC:CostCentre,Queue:FileDropCombo:4.ViewPosition,FDCB30::View:FileDropCombo,Queue:FileDropCombo:4,Relate:CostCentre,ThisWindow,GlobalErrors,0,1,0)
  FDCB30.Q &= Queue:FileDropCombo:4
  FDCB30.AddSortOrder(COS:DescriptionKey)
  FDCB30.AddField(COS:Description,FDCB30.Q.COS:Description)
  FDCB30.AddField(COS:RecordID,FDCB30.Q.COS:RecordID)
  FDCB30.AddUpdateField(COS:RecordID,FN:CostCentreId)
  ThisWindow.AddItem(FDCB30.WindowComponent)
  FDCB30.DefaultFill = 0
  FDCB6.Init(BLM3:Description,?BLM3:Description,Queue:FileDropCombo:3.ViewPosition,FDCB6::View:FileDropCombo,Queue:FileDropCombo:3,Relate:BusinessAlias3,ThisWindow,GlobalErrors,0,1,0)
  BIND('LOC:RFilter',LOC:RFilter)
  FDCB6.Q &= Queue:FileDropCombo:3
  FDCB6.AddSortOrder(BLM3:DescriptionKey)
  FDCB6.AddField(BLM3:Description,FDCB6.Q.BLM3:Description)
  FDCB6.AddField(BLM3:RecordId,FDCB6.Q.BLM3:RecordId)
  FDCB6.AddField(BLM3:Type,FDCB6.Q.BLM3:Type)
  FDCB6.AddUpdateField(BLM3:RecordId,LOC:RCode2)
  ThisWindow.AddItem(FDCB6.WindowComponent)
  FDCB6.DefaultFill = 0
  SELF.SetAlerts()
  Post(EVENT:Accepted)
    ThisSecProc.SetFields()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  PDSC:FN:Date.Kill
  PDSC:FN:PostedDate.Kill
  PDPC:FN:Date.Kill
  PDPC:FN:PostedDate.Kill
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Business.Close
    Relate:BusinessAlias.Close
    Relate:BusinessAlias2.Close
    Relate:BusinessAlias3.Close
    Relate:ColDebit.Close
    Relate:Color.Close
    Relate:Control.Close
    Relate:CostCentre.Close
    Relate:Creditor.Close
    Relate:Employee.Close
    Relate:FeeCode.Close
    Relate:FeeItem.Close
    Relate:FeeNote.Close
    Relate:FeeSheet.Close
    Relate:Language.Close
    Relate:Library.Close
    Relate:Matter.Close
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Open PROCEDURE

  CODE
  PARENT.Open
  SAV:MatterID = FN:MatterID
  AddToFavourites(FN:MatterID)
  


ThisWindow.PrimeUpdate PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  If FN:ColDebitId and Self.Request = DeleteRecord
    CD:RecordID = FN:ColDebitId
    Access:ColDebit.Fetch(CD:PrimaryKey)
    If CD:RecordID
      Case Message('This feenote created a debtor transaction|Do you want to delete the debtor transaction too?','Delete From Debtors Account',ICON:Question,'&Yes|&No|&Cancel')
      Of 1
        Delete(ColDebit)
        If Errorcode()
          Message('Error Deleting Transaction From Debtors Account!|Error: ' & FileError(),'Delete From Debtors Account',ICON:Exclamation)
          Return RequestCancelled
        .
      Of 3
        Return RequestCancelled
      .
      Delete(Feenote)
      If Errorcode()
        Message('Error Deleting Feenote Transaction!|Error: ' & FileError(),'Delete Feenote',ICON:Exclamation)
        Return RequestCancelled
      .
      Return RequestCompleted
    .
  .
  ReturnValue = PARENT.PrimeUpdate()
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
   If Self.Request = ChangeRecord AND FN:MatterID
     IF RestrictedMatter(FN:MatterID,0) Then Return RequestCancelled.
   .
    If ThisSecProc.CheckAccess() Then Return RequestCancelled.
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled
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
        If ~(1) Then Cycle.
        Update(?)
        If GLO:MatterOption = 1
          MAT:OldCode = Contents(?)
          Access:Matter.Fetch(MAT:OldCodeKey)
          FN:MatterID = MAT:RecordID
          If MAT:OldCode <> Contents(?)
            Select(?)
            Cycle
          .
        Else
          MAT:FileRef = Contents(?)
          Access:Matter.Fetch(MAT:FileRefKey)
          FN:MatterID = MAT:RecordID
          If MAT:FileRef <> Contents(?)
            Select(?)
            Cycle
          .
        End
    OF ?OK
      If Self.Request = InsertRecord
        MAT:RecordID = FN:MatterID
        Access:Matter.Fetch(MAT:PrimaryKey)
        If (MAT:ArchiveFlag = True and GLO:SecMatterArchivedFlag = False and ~GLO:SupervisorFlag)
          Message('You cannot add a feenote to this matter, |it has been archived and you do not have |the required access rights.  Contact |your adminsistrator if your need to |change your access rights or un archive |the matter first.','Insert Fee',ICON:Asterisk)
          Cycle
        .
      .
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?FN:Type1
      If ~QuickWindow{PROP:AcceptAll}
        Post(EVENT:Accepted,?LOC:Matter)
        Do SetType
      .
      
    OF ?LOC:Matter
      If ~QuickWindow{PROP:AcceptAll}
        If MAT:ClientFeeSheetID = MAT:DebtorFeeSheetID
          FN:AddToCollDebitFlag = True
        Else
          FN:AddToCollDebitFlag = False
        .
        If ThisWindow.Request = InsertRecord
          LOC:LanguageId = MAT:AccountsLanguageID
          LAN:RecordId = LOC:LanguageId
          Access:Language.Fetch(LAN:PrimaryKey)
          Case FN:Type1
          Of 'F'
            FN:Description = LAN:FeeDescription
          Of 'D'
            FN:Description = LAN:DisbursementDescription
          Of 'R'
            FN:Description = LAN:DisbursementDescription
          Of 'C'
            FN:Description = LAN:BusinessCreditorDescription
          .
        .
        If CEM:UseMatterCostCentreFlag
          If ~MAT:CostCentreId
            Message('This Matter Has No Cost Centre!','Set Cost Centre',ICON:Exclamation)
          Else
            FN:CostCentreId = MAT:CostCentreId
            Post(EVENT:ACCEPTED,?LOC:CostCentre)
          .
        Else
          FN:CostCentreId = CEM:DefaultCostCentreId
          Post(EVENT:ACCEPTED,?LOC:CostCentre)
        .
        LOC:IncomeAccId = 0
        Case FN:Type1
        Of 'F'
          If MAT:OverrideIncomeAccFlag Then LOC:IncomeAccId = MAT:IncomeAccId.
          Post(EVENT:Accepted,?FN:OverrideIncomeAccFlag)
        Of 'R'
          If CTL:VatMethod <> 'N'
            FN:VATRate = 'E'
            ?VatRate{PROP:Selected} = Inlist(FN:VATRate,'1','2','3','N','E','Z')
          .
        .
        If CTL:VatMethod <> 'N'
          Execute MAT:VatExemptFlag
            FN:VATRate = 'E'
            FN:VATRate = 'Z'
          .
          ?VatRate{PROP:Selected} = Inlist(FN:VATRate,'1','2','3','N','E','Z')
        .
        Display
      .

!      Message('1 Matter Default|FN:VATRate='&FN:VATRate&'|MAT:VatExemptFlag='&MAT:VatExemptFlag)

      IF ~(SAV:MatterID = FN:MatterID)
          SAV:MatterID = FN:MatterID
          AddToFavourites(FN:MatterID)
      END

    OF ?LookupMatterButton
      ThisWindow.Update
       GlobalRequest = SelectRecord                   ! Set Action for Lookup
       !SelectMatter(QuickWindow{PROP:XPos} + ?LookupMatterButton{PROP:XPos}+2,QuickWindow{PROP:YPos},220,QuickWindow{PROP:Height})
       SelectMatter(QuickWindow{PROP:XPos}+2,QuickWindow{PROP:YPos},0,0)
       IF GlobalResponse = RequestCompleted           ! IF Lookup completed
           Execute GLO:MatterOption + 1
             LOC:Matter = MAT:FileRef
             LOC:Matter = MAT:OldCode
           .
           Post(EVENT:ACCEPTED,?LOC:Matter)
       .
    OF ?FN:Description:Text
      If Keycode() = F2Key Then Post(EVENT:Accepted,?FN:Description:Zoom).
      If Len(Clip(FN:Description)) <= 255
        ?FN:Description{PROP:Hide} = False
        ?FN:Description:Text{PROP:Hide} = True
        Display
      .
    OF ?SelectFeeNoteDescription
      ThisWindow.Update
      GlobalRequest = SelectRecord
      GLO:TooltipCategory = 'FeeNote Description'
      BrowseLookup
      If GlobalResponse = RequestCompleted
        Change(?FN:Description,LIB:Description)
      .
    OF ?FN:Description:Zoom
      ThisWindow.Update
      FN:Description = CaptureText(FN:Description,Size(FN:Description))
      If Len(Clip(FN:Description)) > 255
        ?FN:Description{PROP:Hide} = True
        ?FN:Description:Text{PROP:Hide} = False
        Select(?FN:Description:Text)
      Else
        ?FN:Description{PROP:Hide} = False
        ?FN:Description:Text{PROP:Hide} = True
        Select(?FN:Description)
      .
      Display
    OF ?FN:Amount
        If FN:Amount < 0
          If CheckSecurity('Batches - Reverse')
            Select(?)
            Cycle
          .
        .
    OF ?VatRate
      FN:VATRate = Choose(Choice(),'1','2','3','N','E','Z')
      If CheckVatRate(FN:VatRate)
        FN:VatRate = 'N'
        ?{PROP:Selected} = 4
      .
      
    OF ?VatIE
      FN:VatIE = Choose(Choice(),'I','E')
    OF ?LOC:Code2
      If FN:Type1 = 'D'
        BLM:RecordId = LOC:DCode2
        Access:Business.Fetch(BLM:PrimaryKey)
        Change(?,BLM:Description)
        If ValidateBusiness(BLM:RecordId,BLM:Type,LOC:DFilter)
          Select(?)
          Cycle
        .
      .
    OF ?SelectCode2
      ThisWindow.Update
       GlobalRequest = SelectRecord                   ! Set Action for Lookup
       GLO:Filter = LOC:DFilter
       BLM:RecordId = BLM1:RecordId
       !SelectBusiness(QuickWindow{PROP:XPos} + ?LookupMatterButton{PROP:XPos}+2,QuickWindow{PROP:YPos},220,QuickWindow{PROP:Height}-2)
      
       SelectBusiness(QuickWindow{PROP:XPos}+2,QuickWindow{PROP:YPos},0,0)
      
       IF GlobalResponse = RequestCompleted           ! IF Lookup completed
         LOC:DCode2=BLM:RecordId
         FDCB:Code2.ResetQueue(True)
         Post(EVENT:ACCEPTED,?LOC:Code2)
       .
    OF ?FN:OverrideIncomeAccFlag
      If QuickWindow{PROP:AcceptAll} Then Cycle.
      Do GetIncomeAccId
      Post(EVENT:Accepted,?LOC:Fee)
    OF ?LOC:Fee
      If FN:Type1 <> 'F' Then Cycle.
      
      BLM:RecordId = LOC:FCode2
      Access:Business.Fetch(BLM:PrimaryKey)
      Change(?,BLM:Description)
      If ValidateBusiness(BLM:RecordId,BLM:Type,'01,02,03')
        FN:OverrideIncomeAccFlag = True
        LOC:FCode2 = CTL:IncomeAccId
        BLM:RecordId = LOC:FCode2
        Access:Business.Fetch(BLM:PrimaryKey)
        Change(?,BLM:Description)
        Select(?)
      .
      If ~QuickWindow{PROP:AcceptAll}
        If Inlist(BLM:DefaultVatRate,'1','2','3','N','E','Z') and CTL:VatMethod <> 'N'
          FN:VATRate = BLM:DefaultVatRate
          ?VatRate{PROP:Selected} = Inlist(FN:VATRate,'1','2','3','N','E','Z')
          Display
        .
      .
      
!      Message('1 Business Ledger Default|FN:VATRate='&FN:VATRate&'|MAT:VatExemptFlag='&MAT:VatExemptFlag&'|BLM:Description='&BLM:Description&'|BLM:DefaultVatRate='&BLM:DefaultVatRate)

!      message('2 ?VatRatePROP:Selected = ' & ?VatRate{PROP:Selected} &|
!          '|BLM:Description = ' & BLM:Description &|
!          '|FN:VATRate = ' & FN:VATRate)
      
    OF ?SelectFee
      ThisWindow.Update
       GlobalRequest = SelectRecord                   ! Set Action for Lookup
       GLO:Filter = '01'
       !SelectBusiness(QuickWindow{PROP:XPos} + ?LookupMatterButton{PROP:XPos}+2,QuickWindow{PROP:YPos},220,QuickWindow{PROP:Height}-2)
       SelectBusiness(QuickWindow{PROP:XPos}+2,QuickWindow{PROP:YPos},0,0)
      
       IF GlobalResponse = RequestCompleted           ! IF Lookup completed
         LOC:FCode2=BLM:RecordId
         FDCB:Fee.ResetQueue(True)
         Post(EVENT:ACCEPTED,?LOC:Fee)
       .
    OF ?BLM3:Description
      If FN:Type1 = 'R'
        BLM:RecordId = LOC:RCode2
        Access:Business.Fetch(BLM:PrimaryKey)
        Change(?,BLM:Description)
        If ValidateBusiness(BLM:RecordId,BLM:Type,LOC:RFilter)
          Select(?)
          Cycle
        .
      .
    OF ?SelectRCode2
      ThisWindow.Update
       GlobalRequest = SelectRecord                   ! Set Action for Lookup
       GLO:Filter = LOC:RFilter
       BLM:RecordId = BLM1:RecordId
       SelectBusiness(QuickWindow{PROP:XPos} + ?LookupMatterButton{PROP:XPos}+2,QuickWindow{PROP:YPos},220,QuickWindow{PROP:Height}-2)
       IF GlobalResponse = RequestCompleted           ! IF Lookup completed
         LOC:RCode2=BLM:RecordId
         FDCB:Code2.ResetQueue(True)
         Post(EVENT:ACCEPTED,?LOC:Code2)
       .
    OF ?LOC:CostCentre
      COS:RecordId = FN:CostCentreId
      Access:CostCentre.Fetch(COS:PrimaryKey)
      Change(?,COS:Description)
      If ~QuickWindow{PROP:AcceptAll}
        If FN:Type1 = 'F' Then Post(EVENT:Accepted,?FN:OverrideIncomeAccFlag).
      .
    OF ?SelectCostCentre
      ThisWindow.Update
       GlobalRequest = SelectRecord                   ! Set Action for Lookup
       SelectCostCentre
       IF GlobalResponse = RequestCompleted           ! IF Lookup completed
         FN:CostCentreId=COS:RecordId
         FDCB30.ResetQueue(True)
         Post(EVENT:ACCEPTED,?LOC:CostCentre)
       .
    OF ?LOC:Employee
      EMP:RecordId = FN:EmployeeId
      Access:Employee.Fetch(EMP:PrimaryKey)
      Change(?,EMP:Name)
      If ~QuickWindow{PROP:AcceptAll}
        If FN:Type1 = 'F' Then Post(EVENT:Accepted,?FN:OverrideIncomeAccFlag).
      .
    OF ?SelectEmployee
      ThisWindow.Update
       GlobalRequest = SelectRecord                   ! Set Action for Lookup
       SelectEmployee(QuickWindow{PROP:XPos} + ?LookupMatterButton{PROP:XPos}+2,QuickWindow{PROP:YPos},220,QuickWindow{PROP:Height}-2)
       IF GlobalResponse = RequestCompleted           ! IF Lookup completed
         FN:EmployeeId=EMP:RecordId
         FDCB31.ResetQueue(True)
         Post(EVENT:ACCEPTED,?LOC:Employee)
       .
    OF ?LOC:Creditor
      If FN:Type1 <> 'C' Then Cycle.
      CRM:RecordId = LOC:CCode2
      Access:Creditor.Fetch(CRM:PrimaryKey)
    OF ?SelectCreditor
      ThisWindow.Update
       GlobalRequest = SelectRecord                   ! Set Action for Lookup
       SelectCreditor(QuickWindow{PROP:XPos} + ?LookupMatterButton{PROP:XPos}+2,QuickWindow{PROP:YPos},220,QuickWindow{PROP:Height}-2)
       IF GlobalResponse = RequestCompleted           ! IF Lookup completed
         LOC:CCode2=CRM:RecordId
         FDCB28.ResetQueue(True)
         Post(EVENT:ACCEPTED,?LOC:Creditor)
       .
    OF ?LOC:FeeSheetFlag
      If LOC:FeeSheetFlag
        Do GetFeeDetails
      Else
        LOC:FeeSheetDesc = ''
        LOC:FeeCodeDesc  = ''
        LOC:FeeItemDesc  = ''
        Display
      .
    OF ?SelectFee:2
      ThisWindow.Update
      GlobalRequest= SelectRecord
      SelectFee
      If GlobalResponse = RequestCompleted
        FN:FeecodeId = FC:RecordId
        FN:FeeItemId = FI:RecordId
        Do GetFeeDetails
      .
    OF ?DocumentCode
      Execute Choice(?)
        FN:DocumentCode = ''
        FN:DocumentCode = 'CCJ'   ! Certified Extract of Civil Judgment
        FN:DocumentCode = 'EMO'   ! Emoluments Attachment Order
        FN:DocumentCode = 'IMM'   ! Sale of Immovable property
        FN:DocumentCode = 'JUD'   ! Judgement
        FN:DocumentCode = 'LOD'   ! Letter Of Demand
        FN:DocumentCode = 'MOV'   ! Sale of movable property
        FN:DocumentCode = 'R41'   ! Postponed proceedings
        FN:DocumentCode = 'RDJ'   ! Request for Default Judgment
        FN:DocumentCode = 'REEMO' ! Reissue Emoluments Attachment Order
        FN:DocumentCode = 'RES65' ! Reissue Section 65 Notice to Appear in Court
        FN:DocumentCode = 'RESUM' ! Reissue Summons
        FN:DocumentCode = 'REWRI' ! Reissue Warrant of Execution
        FN:DocumentCode = 'S57'   ! Section 57 Consent
        FN:DocumentCode = 'S65'   ! Section 65 Notice to Appear in Court
        FN:DocumentCode = 'SUM'   ! Summons
        FN:DocumentCode = 'WOA'   ! Warrant of Arrest
        FN:DocumentCode = 'WRI'   ! Warrant of Execution
      .
    OF ?OK
      ThisWindow.Update
      If ~LOC:FeeSheetFlag
        FN:FeeCodeID = 0
        FN:FeeItemID = 0
      .
      If FN:Type1 <> 'F' Then FN:Option1 = 1.
      IF SELF.Request = ViewRecord
        POST(EVENT:CloseWindow)
      END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
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
  Case FN:Type1
  Of 'F'
    FN:Code2 = LOC:FCode2
  Of 'D'
    FN:Code2 = LOC:DCode2
  Of 'R'
    FN:Code2 = LOC:RCode2
  Of 'C'
    FN:Code2 = LOC:CCode2
  .
  If SAV:Date and SAV:Date <> FN:Date Then FN:Sorter = 0.
!  If Self.Request = ChangeRecord
!    If History::FN:Record.FN:MatterId <> FN:MatterId or History::FN:Record.FN:Date <> FN:Date Then FN:Sorter = 0.
!  .
  ReturnValue = PARENT.TakeCompleted()
  If ReturnValue = Level:Benign and (Self.Request = InsertRecord or Self.Request = ChangeRecord)
    If FN:AddToCollDebitFlag Then AddColDebitFromFeeNote.
  .
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  PDPC:FN:Date.TakeEvent()
  PDPC:FN:PostedDate.TakeEvent()
  LOOP
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeEvent()
  If EVENT() = EVENT:Accepted and ~QuickWindow{PROP:AcceptAll}
    Case FN:Type1
    Of 'F'
      ?GroupFCode2{PROP:Hide} = False
      ?GroupDCode2{PROP:Hide} = True
      ?GroupRCode2{PROP:Hide} = True
      ?GroupCreditor{PROP:Hide} = True
      ?FN:Option1{PROP:Hide} = False
    Of 'D'
      ?GroupFCode2{PROP:Hide} = True
      ?GroupDCode2{PROP:Hide} = False
      ?GroupRCode2{PROP:Hide} = True
      ?GroupCreditor{PROP:Hide} = True
      ?FN:Option1{PROP:Hide} = True
    Of 'R'
      ?GroupFCode2{PROP:Hide} = True
      ?GroupDCode2{PROP:Hide} = True
      ?GroupRCode2{PROP:Hide} = False
      ?GroupCreditor{PROP:Hide} = True
      ?FN:Option1{PROP:Hide} = True
    Of 'C'
      ?GroupFCode2{PROP:Hide} = True
      ?GroupDCode2{PROP:Hide} = True
      ?GroupRCode2{PROP:Hide} = True
      ?GroupCreditor{PROP:Hide} = False
      ?FN:Option1{PROP:Hide} = True
    END
    If FN:Type1 = 'F'
      ?GroupIncomeExpense{PROP:Hide} = False
    Elsif FN:Type1 = 'D' and Inrange(BLM1:Type,1,3) and  CTL:ExpenditureOption <> 2
      ?GroupIncomeExpense{PROP:Hide} = False
    Else
      ?GroupIncomeExpense{PROP:Hide} = True
    .
    If FN:OverrideIncomeAccFlag
      ?LOC:Fee{PROP:BackGround} = Color:None
      ?LOC:Fee{PROP:Skip} = False
      ?LOC:Fee{PROP:ReadOnly} = False
      ?SelectFee{PROP:Disable} = False
    Else
      ?LOC:Fee{PROP:BackGround} = COLOR:BTNFACE
      ?LOC:Fee{PROP:Skip} = True
      ?LOC:Fee{PROP:ReadOnly} = True
      ?SelectFee{PROP:Disable} = True
    .

    IF FN:PostedFlag

       ?VatIE{PROP:Hide} = True

    ELSE

       If CTL:VatMethod <> 'N'
         If Numeric(FN:VATRate)
           ?VatIE{PROP:Hide} = False
         Else
           ?VatIE{PROP:Hide} = True
         .
       .


    END

    If ?FN:PostedFlag{PROP:Disable} = True
      ?FN:PostedBatchId{PROP:BackGround} = COLOR:BTNFACE
      ?FN:PostedBatchId{PROP:Skip} = True
      ?FN:PostedBatchId{PROP:ReadOnly} = True
      ?FN:PostedDate{PROP:BackGround} = COLOR:BTNFACE
      ?FN:PostedDate{PROP:Skip} = True
      ?FN:PostedDate{PROP:ReadOnly} = True
    Else
      ?FN:PostedBatchId{PROP:BackGround} = COLOR:NONE
      ?FN:PostedBatchId{PROP:Skip} = False
      ?FN:PostedBatchId{PROP:ReadOnly} = False
      ?FN:PostedDate{PROP:BackGround} = COLOR:NONE
      ?FN:PostedDate{PROP:Skip} = True
      ?FN:PostedDate{PROP:ReadOnly} = False
    .
    Do CheckComments
  .
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeFieldEvent PROCEDURE

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
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:Accepted,?LookupMatterButton).
    END
  OF ?FN:Description
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
      If Keycode() = CTRLZ Then Post(EVENT:Accepted,?FN:Description:Zoom).
    END
  END
  ReturnValue = PARENT.TakeFieldEvent()
  IF FIELD()=?FN:Date
    
  END
  IF FIELD()=?FN:PostedDate
    
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
        If GLO:MatterOption = 1
          MAT:OldCode = Contents(?)
          Set(MAT:OldCodeKey,MAT:OldCodeKey)
        Else
          MAT:FileRef = Contents(?)
          Set(MAT:FileRefKey,MAT:FileRefKey)
        End
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
          If GLO:MatterOption = 1
            If ~(Upper(Contents(?)) = Upper(Sub(MAT:OldCode,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,MAT:OldCode)
            ?{PROP:SelEnd} = Len(MAT:OldCode)
          Else
            If ~(Upper(Contents(?)) = Upper(Sub(MAT:FileRef,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,MAT:FileRef)
            ?{PROP:SelEnd} = Len(MAT:FileRef)
          .
            ?{PROP:Touched} = True
            Display
      
      
            If GLO:MatterOption = 1
            Else
            .
            Break
          .
          SetKeycode(0)
        .
    OF ?FN:Description
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        LIB:TooltipCategory = 'FeeNote Description'
        LIB:ShortDesc = Contents(?)
        Set(LIB:CategoryKey,LIB:CategoryKey)
        If KeyCode() = DownKey Then Next(Library).
        If KeyCode() = UpKey Then Previous(Library).
        Loop
          If KeyCode() = UpKey Then Previous(Library) Else Next(Library).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (Library) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(Upper(Contents(?)) = Upper(Sub(LIB:ShortDesc,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,LIB:ShortDesc)
            ?{PROP:SelEnd} = Len(LIB:ShortDesc)
            ?{PROP:Touched} = True
            Display
      
      
            Break
          .
          SetKeycode(0)
        .
    END
  ReturnValue = PARENT.TakeNewSelection()
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
  ReturnValue = PARENT.TakeSelected()
    CASE FIELD()
    OF ?SelectPeriod
      ! No-one is using this so hiding this option 14/9/2004
      
      !SetPeriod(FN:Period,FN:Year,FN:AgingPeriod)
      If GlobalResponse = RequestCompleted Then Change(?LOC:PeriodName,GetPeriodName(FN:Period,FN:Year)).
    END
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
        LSFQ:Field = ?FN:PostedFlag
        LSFQ:Description = 'Posted Settings'
      End
      Begin
        LSFQ:Field = ?FN:Date
        LSFQ:Description = 'Date'
      End
      Begin
        LSFQ:Field = ?FN:Type1
        LSFQ:Description = 'Transaction Type'
      End
      Begin
        LSFQ:Field = ?FN:AddToCollDebitFlag
        LSFQ:Description = 'Send To Debtors Account'
      End
      Begin
        LSFQ:Field = ?FN:Voucher
        LSFQ:Description = 'Voucher'
      End
      Begin
        LSFQ:Field = ?FN:OverrideIncomeAccFlag
        LSFQ:Description = 'Overide Income Account'
      End
      Begin
        LSFQ:Field = ?LOC:Code2
        LSFQ:Description = 'Account'
      End
      Begin
        LSFQ:Field = ?LOC:CostCentre
        LSFQ:Description = 'Cost Centre'
      End
      Begin
        LSFQ:Field = ?LOC:Employee
        LSFQ:Description = 'Employee'
      End
       Break
    .
    If LSF:CheckFieldFlag
      Clear(SF:Record)
      SF:SecGroupId = GLO:SecGroupId
      SF:SecProc    = 'Matters - Desktop - Fee Notes'
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
    SP:Description = 'Matters - Desktop - Fee Notes - Insert'
  Of ChangeRecord
    LSF:CheckFieldFlag = True
    SP:Description = 'Matters - Desktop - Fee Notes - Change'
  Of DeleteRecord
    SP:Description = 'Matters - Desktop - Fee Notes - Delete'
  Of ViewRecord
    SP:Description = 'Matters - Desktop - Fee Notes - View'
  Else
    SP:Description = 'Matters - Desktop - Fee Notes'
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
    BrowseSecProc('Matters - Desktop - Fee Notes',1)
    Return Level:Benign
PDPC:FN:Date.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF FN:Date <> L:Default
    POST(EVENT:Accepted,?FN:Date)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:FN:PostedDate.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF FN:PostedDate <> L:Default
    POST(EVENT:Accepted,?FN:PostedDate)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDSC:FN:Date.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV
PDSC:FN:PostedDate.TakeFieldEvent PROCEDURE
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


FDCB:Fee.ValidateRecord PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.ValidateRecord()
  If BLM2:NotUsedFlag and BLM2:RecordId <> LOC:FCode2 Then Return Record:Filtered.
  If ~Instring(Format(BLM2:Type,@n02),LOC:FFilter,3) Then Return Record:Filtered.
  RETURN ReturnValue


FDCB6.ValidateRecord PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.ValidateRecord()
  If BLM3:NotUsedFlag and BLM3:RecordId <> LOC:RCode2 Then Return Record:Filtered.
  If ~Instring(Format(BLM3:Type,@n02),LOC:RFilter,3) Then Return Record:Filtered.
  RETURN ReturnValue

GetComments          PROCEDURE  (LOC:Type,LOC:Code)   ! Declare Procedure
LOC:Comments         CSTRING(1000)
ezField              LONG
LOC:AccountComment   CSTRING(255)
  CODE
  !message('GetComments|LOC:Type = ' & LOC:Type & '|LOC:Code = ' & LOC:Code)

  Case LOC:Type
  Of 'M'
    If MAT:RecordId <> LOC:Code
      MAT:RecordId = LOC:Code
      Access:Matter.Fetch(MAT:PrimaryKey)
    .
    If ~MAT:RecordId Then Return('').
    If PAR:RecordId <> MAT:ClientId
      PAR:RecordId = MAT:ClientId
      Access:Party.Fetch(PAR:PrimaryKey)
    .
    If MT:RecordID <> MAT:MatterTypeId
      MT:RecordID = MAT:MatterTypeId
      Access:MatTYpe.Fetch(MT:PrimaryKey)
    .
    LOC:Comments =                          'Matter   :' & MAT:FileRef & '<13,10>'
    If PAR:Name    Then LOC:Comments = Clip(LOC:Comments)     & 'Client   :' & PAR:Name & '<13,10>'.
    If GLO:ShowFICAComplianceFlag and ~PAR:FICACompliantFlag Then LOC:Comments = Clip(LOC:Comments)   & '*** NOT FICA COMPLIANT!!!***<13,10>'.
    If MAT:OldCode Then LOC:Comments = Clip(LOC:Comments)     & 'Old Code :' & MAT:OldCode & '<13,10>'.
    LOC:Comments = Clip(LOC:Comments)     & 'Type     :' & MT:Description & '<13,10>'

    LOC:Comments = Clip(LOC:Comments)     & 'Cost Ctr :' & GetDescription('COST CENTRE',MAT:CostCentreID) & '<13,10>'
    LOC:Comments = Clip(LOC:Comments)     & 'Employee :' & GetDescription('EMPLOYEE',MAT:EmployeeID) & '<13,10>'



    LOC:Comments = Clip(LOC:Comments)     & '-{28}' & '<13,10>'
    LOC:Comments = Clip(LOC:Comments)     & MAT:Description & '<13,10>'
    If MAT:ArchiveFlag
      LOC:Comments = Clip(LOC:Comments)   & '***MATTER ARCHIVED***<13,10>'
      LOC:Comments = Clip(LOC:Comments)   & '<13,10>'
    ElsIf MAT:ArchiveStatus = 1
      LOC:Comments = Clip(LOC:Comments)   & '***MATTER PENDING***<13,10>'
      LOC:Comments = Clip(LOC:Comments)   & '<13,10>'
    .
    If MAT:DeleteFlag
      LOC:Comments = Clip(LOC:Comments)   & '***MARKED FOR DELETION***<13,10>'
      LOC:Comments = Clip(LOC:Comments)   & '<13,10>'
    .
    If MAT:AccountComment
      LOC:Comments = Clip(LOC:Comments)   & WordWrap(ReplaceTextBoxFields(MAT:AccountComment,MAT:AccountsLanguageID,0,MAT:RecordID),28,'<13,10>') & '<13,10>'
      LOC:Comments = Clip(LOC:Comments)   & '<13,10>'
    .
    LOC:Comments = Clip(LOC:Comments)     & 'Actual   :' & Format(MAT:Actual,@n-15.2) & '<13,10>'
    If MAT:BatchedNormal
      LOC:Comments = Clip(LOC:Comments)   & 'Batched  :' & Format(MAT:BatchedNormal,@n-15.2) & '<13,10>'
      LOC:Comments = Clip(LOC:Comments)   & 'Total    :' & Format(MAT:Actual + MAT:BatchedNormal,@n-15.2) & '<13,10>'
    .
    LOC:Comments = Clip(LOC:Comments)     & '<13,10>'
    If MAT:Reserved or MAT:BatchedReserved
      LOC:Comments = Clip(LOC:Comments)   & 'Reserved :' & Format(MAT:Reserved,@n-15.2) & '<13,10>'
      If MAT:BatchedReserved
        LOC:Comments = Clip(LOC:Comments) & 'Batched  :' & Format(MAT:BatchedReserved,@n-15.2) & '<13,10>'
        LOC:Comments = Clip(LOC:Comments) & 'Total    :' & Format(MAT:Reserved + MAT:BatchedReserved,@n-15.2) & '<13,10>'
      .
      LOC:Comments = Clip(LOC:Comments)   & '<13,10>'
    .
    If MAT:Invested or MAT:BatchedInvested   
      LOC:Comments = Clip(LOC:Comments)   & 'Invested :' & Format(MAT:Invested,@n-15.2) & '<13,10>'
      If MAT:BatchedInvested
        LOC:Comments = Clip(LOC:Comments) & 'Batched  :' & Format(MAT:BatchedInvested,@n-15.2) & '<13,10>'
        LOC:Comments = Clip(LOC:Comments) & 'Total    :' & Format(MAT:Invested + MAT:BatchedInvested,@n-15.2) & '<13,10>'
      .
      LOC:Comments = Clip(LOC:Comments)   & '<13,10>'
    .
    If MAT:DebtorsBalance
      LOC:Comments = Clip(LOC:Comments) & 'Debtor   :' & Format(MAT:DebtorsBalance,@n-15.2) & '<13,10>'
      Defendant" = GetDescription('MATPARTY NAME',MAT:RecordId,CTL:DefendantRoleID)
      If Defendant" then LOC:Comments = Clip(LOC:Comments) & Defendant" & '<13,10>'.
      LOC:Comments = Clip(LOC:Comments) & '<13,10>'
    .

    If MAT:ArchiveFlag
      Message('Matter: ' & MAT:FileRef & ' - ' & MAT:Description & '||' & 'WARNING: This matter has been archived||Posting transactions to this matter will |cause this matter to become unarchived|','Message',ICON:Asterisk)
    ElsIf MAT:ArchIveStatus
      If Message('Matter: ' & MAT:FileRef & ' - ' & MAT:Description & '||' & 'WARNING: This matter is set as "Pending"||Pending matters will not be archived |until the balance on the matter is zero||Change the matter to "Live", if you do not |want to see this warning again|','Message',ICON:Asterisk,'&Ok|&Live') = 2
        MAT:RecordId = LOC:Code
        Access:Matter.Fetch(MAT:PrimaryKey)
        MAT:ArchiveStatus = 0
        Access:Matter.Update()
      .
    .
    ShowAccountComment

  Of 'C'

    CRM:RecordId = LOC:Code
    Access:Creditor.Fetch(CRM:PrimaryKey)

    If ~CRM:RecordId Then Return('').
    LOC:Comments =                          'Creditor :' & CRM:Description & '<13,10>'
    If CRM:OldCode Then LOC:Comments = Clip(LOC:Comments)     & 'Old Code :' & CRM:OldCode & '<13,10>'.
    LOC:Comments = Clip(LOC:Comments)     & '-{28}' & '<13,10>'
    If CRM:NotUsedFlag
      LOC:Comments = Clip(LOC:Comments)   & '***INACTIVE ACCOUNT***<13,10>'
      LOC:Comments = Clip(LOC:Comments)   & '<13,10>'
    .
    If CRM:Comment
      LOC:Comments = Clip(LOC:Comments)   & WordWrap(CRM:Comment,28,'<13,10>') & '<13,10>'
      LOC:Comments = Clip(LOC:Comments)   & '<13,10>'
    .
    If ~(~GLO:SupervisorFlag and ~GLO:SecCreditorOption)
      LOC:Comments = Clip(LOC:Comments)     & 'Actual   :' & Format(CRM:Actual,@n-15.2) & '<13,10>'
      If CRM:Batched
        LOC:Comments = Clip(LOC:Comments)   & 'Batched  :' & Format(CRM:Batched,@n-15.2) & '<13,10>'
        LOC:Comments = Clip(LOC:Comments)   & 'Total    :' & Format(CRM:Actual + CRM:Batched,@n-15.2) & '<13,10>'
      .
      LOC:Comments = Clip(LOC:Comments)     & '<13,10>'
    Else
      LOC:Comments = Clip(LOC:Comments)     & 'Actual   : Restricted<13,10>'
    .
    LOC:Comments = Clip(LOC:Comments)     & '<13,10>'
    If CRM:NotUsedFlag Then Message('Creditor: ' & CRM:Description & '||' & 'WARNING: This creditor has been marked as inactive','Message',ICON:Asterisk).
    If CRM:CommentOption = 1 and CRM:Comment Then Message('Creditor: ' & CRM:Description & '||' & CRM:Comment,'Message',ICON:Asterisk).

  Of 'B'

    BLM:RecordId = LOC:Code
    Access:Business.Fetch(BLM:PrimaryKey)
    If ~BLM:RecordId Then Return('').
    GetBusinessBalances
    LOC:Comments =                          'Business :' & BLM:Description & '<13,10>'
    If BLM:OldCode Then LOC:Comments = Clip(LOC:Comments)     & 'Old Code :' & BLM:OldCode & '<13,10>'.
    LOC:Comments = Clip(LOC:Comments)     & '-{28}' & '<13,10>'
    If BLM:NotUsedFlag
      LOC:Comments = Clip(LOC:Comments)   & '***INACTIVE ACCOUNT***<13,10>'
      LOC:Comments = Clip(LOC:Comments)   & '<13,10>'
    .
    If BLM:Comment
      LOC:Comments = Clip(LOC:Comments)   & WordWrap(BLM:Comment,28,'<13,10>') & '<13,10>'
      LOC:Comments = Clip(LOC:Comments)   & '<13,10>'
    .
    If ~(~GLO:SupervisorFlag and ~Band(GLO:SecBusinessOption,2^(BLM:Type-1)))
      LOC:Comments = Clip(LOC:Comments)     & 'Balance  :' & Format(GLO:BalanceThisYear,@n-15.2) & '<13,10>'
    Else
      LOC:Comments = Clip(LOC:Comments)     & 'Balance  : Restricted<13,10>'
    .
    LOC:Comments = Clip(LOC:Comments)     & '<13,10>'
    If BLM:NotUsedFlag Then Message('Business Ledger: ' & BLM:Description & '||' & 'WARNING: This account has been marked as inactive','Message',ICON:Asterisk).
    If BLM:CommentOption = 1 and BLM:Comment Then Message('Business Ledger: ' & BLM:Description & '||' & BLM:Comment,'Message',ICON:Asterisk).
  Of 'I'
    If BLM:RecordId <> LOC:Code
      BLM:RecordId = LOC:Code
      Access:Business.Fetch(BLM:PrimaryKey)
    .
    If MAI:MatterId <> MAT:RecordId or MAI:BankId <> LOC:Code
     MAI:MatterId = MAT:RecordId
     MAI:BankId   = LOC:Code
     Access:MatInv.Fetch(MAI:PrimaryKey)
    .
    If ~MAI:MatterId Then Return('').
    LOC:Comments =                          'Client Investment' & '<13,10>'
    LOC:Comments = Clip(LOC:Comments)     & 'Bank     :' & BLM:Description & '<13,10>'
    LOC:Comments = Clip(LOC:Comments)     & '-{28}' & '<13,10>'
    LOC:Comments = Clip(LOC:Comments)     & 'Account  :' & MAI:AccountNo & '<13,10>'
    LOC:Comments = Clip(LOC:Comments)     & 'Balance  :' & Format(MAI:Invested+MAI:WithDrawals+MAI:GPayments+MAI:Interest,@n-15.2) & '<13,10>'
    If MAI:Batched
      LOC:Comments = Clip(LOC:Comments)   & 'Batched  :' & Format(MAI:Batched,@n-15.2) & '<13,10>'
      LOC:Comments = Clip(LOC:Comments)   & 'Total    :' & Format(MAI:Invested+MAI:WithDrawals+MAI:GPayments+MAI:Interest+MAI:Batched,@n-15.2) & '<13,10>'
    .
    LOC:Comments = Clip(LOC:Comments)     & '<13,10>'
  .
  Return LOC:Comments
