BrowseColDebit PROCEDURE                              !Generated from procedure template - Browse

LOC:DataSeperator    CSTRING(5)
LOC:LineFeed         CSTRING(5)

LOC:TaggedMatters    LONG
LOC:EmailSubject     LIKE(DOL:Description)
LOC:EmailBody        LIKE(DOL:EmailBody)
LOC:CapitalReductionSettings  CSTRING(100)

SAV:MatterID         LONG
LOC:LastInterestDate        LONG
LOC:MatterTakeOnReminderFlag   BYTE
LOC:Amount         DECIMAL(11,2)
LOC:Total5         DECIMAL(11,2)
LOC:Total4c        DECIMAL(11,2)
LOC:Total4d        DECIMAL(11,2)
LOC:Total4         DECIMAL(11,2)
LOC:Total3         DECIMAL(11,2)
LOC:Total2         DECIMAL(11,2)
LOC:Total1         DECIMAL(11,2)
LOC:LastDate       LONG
LOC:Column         LONG
LOC:Debug          BYTE
LOC:InterestSettings   CSTRING(200)
LOC:CostRatio            LONG
LOC:SavedName          LIKE(GLO:FileName)
LOC:TempSavedName      LIKE(GLO:FileName)
LOC:DebtorName         CSTRING(100)
SAV:CD:Date            LONG
LOC:GoAhead            BYTE
LOC:TotalRows            LONG
LOC:TotalColumns         LONG
LOC:CurrentRow           LONG
LOC:ColumnLetter         CSTRING(5)
LOC:FontSize              BYTE(10)
LOC:ReportInterestFlag      BYTE
LOC:ReportInterestDaysFlag  BYTE
LOC:ReportCollCommFlag      BYTE
LOC:ReportDebitsAndCreditsFlag BYTE
LOC:ReportEmailFlag         BYTE
LOC:PaymentsFlag            BYTE
LOC:ReportTranTypeFlag      BYTE
LOC:ReportTotalsFlag        BYTE
LOC:LetterheadFlag          BYTE
LOC:PrintInLandscape        BYTE
LOC:SettlementFlag          BYTE
LOC:CostRatioFlag           BYTE
LOC:ReportHeading           CSTRING(150)
LOC:ReportFooterIncludeFile         LIKE(RE:ReportFooterIncludeFile)
LOC:CurrentColumn       LONG
SAV:GLO:WordprocessorOption  LIKE(GLO:WordprocessorOption)
LOC:LetterHead          CSTRING(250)
LOC:InsertText          CSTRING(1000)
LOC:EndOfDocument       CSTRING(35)
LOC:TestPath            CSTRING(250)

LOC:EmailRecipient      CSTRING(50)



LOC:ReportFooterFileName  CSTRING(150)
LOC:ClientPrompt        CString(20)
LOC:DebtorPrompt        CString(20)
LOC:MatterPrompt        CString(20)
LOC:InterestPrompt      CString(20)
LOC:PrintedByPrompt     CString(20)
!LOC:ReportDestination   LIKE(GLO:ReportDestination)
LOC:ExcelRow            LONG
LOC:LetterHeadTempdName CSTRING(250)


LOC:WordTable           CSTRING(35)
wdColorGray10           EQUATE(15132390)
RangeObj                CSTRING(35)
xlEdgeTop               EQUATE(8)
xlEdgeBottom            EQUATE(9)
xlTop                   EQUATE(-4160)

wdAutoFitFixed          EQUATE(0)
wdAutoFitContent        EQUATE(1)
wdAutoFitWindow         EQUATE(2)

wdPreferredWidthPoints  EQUATE(3)
wdPreferredWidthPercent EQUATE(2)
wdPreferredWidthAuto    EQUATE(1)

wdWord8TableBehavior    EQUATE(0)
wdWord9TableBehavior    EQUATE(1)

wdFormatDocumentDefault EQUATE(16)
wdFormatDocument        EQUATE(0)

PrintSummaryReportWindow WINDOW('Report Options'),AT(,,366,224),FONT('Arial',9,,FONT:regular),CENTER, |
         GRAY,MODAL
      PANEL,AT(5,3,354,189),USE(?Panel1)
      PROMPT('Heading:'),AT(13,13),USE(?Prompt:Heading)
      ENTRY(@s150),AT(46,13,182,10),USE(LOC:ReportHeading),FONT('MS Sans Serif',,,),TIP('Specify the heading of the Report')
      CHECK('Insert a Letterhead?'),AT(14,31),USE(LOC:LetterheadFlag),TIP('Insert a letterhead at the top of the report?')
      CHECK('Include the Settlement Calculation?'),AT(14,47),USE(LOC:SettlementFlag),TIP('Include the settlement calculation?')
      CHECK('Include Cost to Balance Ratio?'),AT(14,63),USE(LOC:CostRatioFlag),TIP('Insert the Cost / Balance ratio in the report?')
      GROUP('Show separate columns for '),AT(14,77,183,71),USE(?ColumnsGroup),BOXED
         CHECK('Interest'),AT(22,105),USE(LOC:ReportInterestFlag)
         CHECK('Interest Days'),AT(22,117),USE(LOC:ReportInterestDaysFlag)
         CHECK('Collection Commission'),AT(102,105),USE(LOC:ReportCollCommFlag)
         CHECK('Debits && Credits'),AT(22,93),USE(LOC:ReportDebitsAndCreditsFlag)
         CHECK('Payments'),AT(102,93),USE(LOC:PaymentsFlag)
         CHECK('Transaction Type'),AT(102,117),USE(LOC:ReportTranTypeFlag)
         CHECK('Show the Totals for each of these columns?'),AT(22,131),USE(LOC:ReportTotalsFlag),TIP('Insert the totals at the bottom of the report?')
      END
      CHECK('Print in Landscape'),AT(250,88),USE(LOC:PrintInLandscape),TIP('Print the report in landscape view.')
      OPTION('Destination'),AT(250,10,99,60),USE(GLO:ReportDestination),BOXED,TIP('Where should the report be printed?')
         RADIO('PDF'),AT(257,23),USE(?GLO:ReportDestination:Radio1),TIP('Print the report as a PDF document'), |
            VALUE('P')
         RADIO('MS Word'),AT(257,38),USE(?GLO:ReportDestination:Radio2),TIP('Print the report in Microsoft Word'), |
            VALUE('M')
         RADIO('Excel Spreadsheet'),AT(258,52),USE(?GLO:ReportDestination:Radio3),TIP('Print the report in Microsoft Excel'), |
            VALUE('X')
      END
      CHECK('Email the report'),AT(250,74),USE(LOC:ReportEmailFlag),TIP('Send the report via email after it is created')
      PROMPT('Font Size:'),AT(15,154),USE(?LOC:FontSize:Prompt)
      LIST,AT(65,154,31,10),USE(LOC:FontSize),TIP('The font size of the transactions table in the report<13,10>You can reduce the font s' &|
         'ize to make the table fit better'),DROP(10),FROM('7|8|9|10|11|12|13|14')
      BUTTON('&OK'),AT(230,198,60,20),USE(?OkButton1),LEFT,FONT(,11,,),ICON('check3.ico'),DEFAULT
      BUTTON('&Cancel'),AT(299,198,60,20),USE(?CancelButton1),LEFT,FONT(,11,,),ICON('delete32.ico')
      PROMPT('Report Footer:'),AT(14,173),USE(?Prompt3)
      ENTRY(@s150),AT(65,173,267,11),USE(LOC:ReportFooterIncludeFile),FONT('MS Sans Serif',,,),TIP('The filename of the Text or Message to appear at the bottom of the report<13,10>RE:Re' &|
         'portFooterIncludeFile')
      BUTTON('...'),AT(338,172,12,12),USE(?LookupFileButton),SKIP,TIP('Browse for the file')
   END


LOC:ReportProgressWindowString  CSTRING(50)

ReportProgressWindow WINDOW('Generating Report'),AT(,,254,79),CENTER,SYSTEM,GRAY,DOUBLE
      STRING('Creating the Debtor''s Report'),AT(65,8),USE(?ReportProgressWindowString1411),FONT('Arial',15,,)
      STRING(@s50),AT(7,33,241,10),USE(LOC:ReportProgressWindowString),CENTER,FONT('Arial',12,,)
      STRING('Please wait...'),AT(104,58),USE(?ReportProgressWindowWait),FONT('Arial',12,,)
   END


FileLookup11         CLASS(SelectFileClass)
Ask                    PROCEDURE(BYTE KeepDir=0),STRING
Ask                    PROCEDURE(SelectFileQueue FileQueue,BYTE KeepDir = 0)
Init                   PROCEDURE()
                     END

LOC:Counter:8            LONG
LOC:Row:8                LONG
LOC:VatRate              DECIMAL(11,2)
LOC:Initialised          BYTE
LOC:CollCommPerc         DECIMAL(11,2)
LOC:CollCommLimit        DECIMAL(11,2)
LOC:CalculateInterestOn  DECIMAL(11,2)
LOC:InterestRate         DECIMAL(11,2)
LOC:SettleAmount         DECIMAL(11,2)
LOC:Commission           DECIMAL(11,2)
LOC:InterestWording      CSTRING(100)
LOC:ThisInterestDate     DATE
LOC:VAT                  DECIMAL(11,2)
LOC:SettleType           STRING(1)

LOC:CollCommLim          DECIMAL(11,2)
LOC:CollCommAct          DECIMAL(11,2)
LOC:Costs                DECIMAL(11,2)




ProgressWindow WINDOW('Deleting Transactions'),AT(,,201,39),FONT('MS Sans Serif',8,,),CENTER,GRAY,DOUBLE,MODAL
               PROGRESS,USE(?ProgressBar),AT(7,12,187,10),RANGE(0,100)
               END



LOC:TranType         CSTRING(20)
LOC:DisplayAmount    CSTRING(20)
Tag                  STRING(10)
MS::MoveType         BYTE
MS::OutOfRange       BYTE
MS::OrigSequence     LONG
MS::TargetSequence   LONG
MS::SwapSequence     LONG
MS::SavePosition     STRING(255)
MS::InsertSequence   LONG
MS::DeleteSequence   LONG
MS::Section          CSTRING(12)
MS::DoNotCommit      BYTE
LOC:DisplayCostAmount DECIMAL(15,2)
LOC:DisplayInterestAmount DECIMAL(15,2)
LOC:Source           CSTRING(30)
BRW1::View:Browse    VIEW(ColDebit)
                     PROJECT(CD:Date)
                     PROJECT(CD:Description)
                     PROJECT(CD:DocumentCode)
                     PROJECT(CD:CostBalance)
                     PROJECT(CD:InterestBalance)
                     PROJECT(CD:CapitalBalance)
                     PROJECT(CD:Balance)
                     PROJECT(CD:Amount)
                     PROJECT(CD:VatAmount)
                     PROJECT(CD:VATFlag)
                     PROJECT(CD:RecordID)
                     PROJECT(CD:MatterID)
                     PROJECT(CD:Type)
                     PROJECT(CD:CollCommFlag)
                     PROJECT(CD:Category)
                     PROJECT(CD:TimerStamp)
                     PROJECT(CD:EmployeeID)
                     PROJECT(CD:BatchId)
                     PROJECT(CD:TransID)
                     PROJECT(CD:LineId)
                     PROJECT(CD:OverrideEMOCommFlag)
                     END
Queue:Browse         QUEUE                            !Queue declaration for browse/combo box using ?List:2
Tag                    LIKE(Tag)                      !List box control field - type derived from local data
Tag_NormalFG           LONG                           !Normal forground color
Tag_NormalBG           LONG                           !Normal background color
Tag_SelectedFG         LONG                           !Selected forground color
Tag_SelectedBG         LONG                           !Selected background color
Tag_Icon               LONG                           !Entry's icon ID
CD:Date                LIKE(CD:Date)                  !List box control field - type derived from field
CD:Date_NormalFG       LONG                           !Normal forground color
CD:Date_NormalBG       LONG                           !Normal background color
CD:Date_SelectedFG     LONG                           !Selected forground color
CD:Date_SelectedBG     LONG                           !Selected background color
CD:Description         LIKE(CD:Description)           !List box control field - type derived from field
CD:Description_NormalFG LONG                          !Normal forground color
CD:Description_NormalBG LONG                          !Normal background color
CD:Description_SelectedFG LONG                        !Selected forground color
CD:Description_SelectedBG LONG                        !Selected background color
LOC:TranType           LIKE(LOC:TranType)             !List box control field - type derived from local data
LOC:TranType_NormalFG  LONG                           !Normal forground color
LOC:TranType_NormalBG  LONG                           !Normal background color
LOC:TranType_SelectedFG LONG                          !Selected forground color
LOC:TranType_SelectedBG LONG                          !Selected background color
CD:DocumentCode        LIKE(CD:DocumentCode)          !List box control field - type derived from field
CD:DocumentCode_NormalFG LONG                         !Normal forground color
CD:DocumentCode_NormalBG LONG                         !Normal background color
CD:DocumentCode_SelectedFG LONG                       !Selected forground color
CD:DocumentCode_SelectedBG LONG                       !Selected background color
LOC:DisplayAmount      LIKE(LOC:DisplayAmount)        !List box control field - type derived from local data
LOC:DisplayAmount_NormalFG LONG                       !Normal forground color
LOC:DisplayAmount_NormalBG LONG                       !Normal background color
LOC:DisplayAmount_SelectedFG LONG                     !Selected forground color
LOC:DisplayAmount_SelectedBG LONG                     !Selected background color
CD:CostBalance         LIKE(CD:CostBalance)           !List box control field - type derived from field
CD:CostBalance_NormalFG LONG                          !Normal forground color
CD:CostBalance_NormalBG LONG                          !Normal background color
CD:CostBalance_SelectedFG LONG                        !Selected forground color
CD:CostBalance_SelectedBG LONG                        !Selected background color
CD:InterestBalance     LIKE(CD:InterestBalance)       !List box control field - type derived from field
CD:InterestBalance_NormalFG LONG                      !Normal forground color
CD:InterestBalance_NormalBG LONG                      !Normal background color
CD:InterestBalance_SelectedFG LONG                    !Selected forground color
CD:InterestBalance_SelectedBG LONG                    !Selected background color
CD:CapitalBalance      LIKE(CD:CapitalBalance)        !List box control field - type derived from field
CD:CapitalBalance_NormalFG LONG                       !Normal forground color
CD:CapitalBalance_NormalBG LONG                       !Normal background color
CD:CapitalBalance_SelectedFG LONG                     !Selected forground color
CD:CapitalBalance_SelectedBG LONG                     !Selected background color
CD:Balance             LIKE(CD:Balance)               !List box control field - type derived from field
CD:Balance_NormalFG    LONG                           !Normal forground color
CD:Balance_NormalBG    LONG                           !Normal background color
CD:Balance_SelectedFG  LONG                           !Selected forground color
CD:Balance_SelectedBG  LONG                           !Selected background color
CD:Amount              LIKE(CD:Amount)                !Browse hot field - type derived from field
CD:VatAmount           LIKE(CD:VatAmount)             !Browse hot field - type derived from field
CD:VATFlag             LIKE(CD:VATFlag)               !Browse hot field - type derived from field
CD:RecordID            LIKE(CD:RecordID)              !Browse hot field - type derived from field
CD:MatterID            LIKE(CD:MatterID)              !Browse hot field - type derived from field
CD:Type                LIKE(CD:Type)                  !Browse hot field - type derived from field
CD:CollCommFlag        LIKE(CD:CollCommFlag)          !Browse hot field - type derived from field
CD:Category            LIKE(CD:Category)              !Browse hot field - type derived from field
CD:TimerStamp          LIKE(CD:TimerStamp)            !Browse hot field - type derived from field
CD:EmployeeID          LIKE(CD:EmployeeID)            !Browse hot field - type derived from field
CD:BatchId             LIKE(CD:BatchId)               !Browse hot field - type derived from field
CD:TransID             LIKE(CD:TransID)               !Browse hot field - type derived from field
CD:LineId              LIKE(CD:LineId)                !Browse hot field - type derived from field
CD:OverrideEMOCommFlag LIKE(CD:OverrideEMOCommFlag)   !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
ThisSecProc    Class()
CheckAccess       PROCEDURE(),BYTE,PROC
Update            PROCEDURE(),BYTE,PROC
               End
QuickWindow          WINDOW('Debtors Account'),AT(,,569,286),FONT('Arial',9,,FONT:regular),CENTER,IMM,CENTERED,SYSTEM,GRAY,MAX,RESIZE,MDI
                     BUTTON('&Insert'),AT(272,148,42,12),USE(?Insert),HIDE
                     BUTTON('&Change'),AT(272,164,42,12),USE(?Change),HIDE,DEFAULT
                     BUTTON('&Print'),AT(104,168,55,17),USE(?PrintListButton),HIDE
                     BUTTON('View Batch'),AT(196,173,62,13),USE(?ViewBatchButton),HIDE
                     BUTTON('Import from Ledger'),AT(264,128,65,14),USE(?ImportLedgerButton),HIDE
                     BUTTON('Export Tagged Items'),AT(66,147,101,14),USE(?ExportColDebitButton),HIDE
                     BUTTON('Create Fee Notes'),AT(264,112,65,14),USE(?CreateFeeNotesButton),HIDE
                     BUTTON('Untag'),AT(92,124,44,14),USE(?UntagOne),HIDE
                     BUTTON('Untag All'),AT(152,124,44,14),USE(?UntagAll),HIDE
                     LIST,AT(4,59,561,199),USE(?List:2),IMM,HVSCROLL,FORMAT('9L(2)|M*I@s10@50L(2)|M*~Date~@d17b@300L(2)|M*~Description~@s254@49L(2)|M*~Type~@' &|
   's19@24L(2)|M*~Code~@s5@56R(2)|M*~Amount~@s19@60R(2)|M*~Cost Balance~@n-15.2@60R(' &|
   '2)|M*~Interest Balance~@n-15.2@60R(2)|M*~Capital Balance~@n-15.2@60R(2)|M*~Debto' &|
   'rs Balance~@n-15.2@'),FROM(Queue:Browse)
                     GROUP,AT(4,1,438,35),USE(?IconGroupBox),BOXED
                        BUTTON,AT(8,9,28,24),USE(?FeesButton),SKIP,TIP('Insert a fee from the fee sheet (F3)'),KEY(F3Key),ICON('money_add.ico')
                        BUTTON,AT(40,9,28,24),USE(?SettingsButton),SKIP,TIP('Change Settings (F4)'),KEY(F4Key),ICON('window_gear.ico')
                        BUTTON,AT(72,9,28,24),USE(?PaymentsButton),SKIP,TIP('Payment Calculator (F5)'),KEY(F5Key),ICON('payment.ico')
                        BUTTON,AT(104,9,28,24),USE(?SettlementButton),SKIP,TIP('Settlement Calculation (F6)'),KEY(F6Key),ICON('handshake.ico')
                        BUTTON,AT(136,9,28,24),USE(?TotalsButton),SKIP,TIP('Show Totals (F7)'),KEY(F7Key),ICON('accounting.ico')
                        BUTTON,AT(168,9,28,24),USE(?PrintButton),SKIP,LEFT,TIP('Detailed Debtors Report (F8)'),KEY(F8Key),ICON('Printer.ico')
                        BUTTON,AT(201,9,28,24),USE(?EmailButton),LEFT,TIP('Send the Debtors Report via email to the Defendant or tagged Matters (F9)'),KEY(F9Key),ICON('mail_earth.ico')
                     END
                     STRING('Cost Balance:'),AT(448,4,53,10),USE(?LOC:DisplayCostAmount:Prompt)
                     ENTRY(@n-21.2),AT(504,4,60,10),USE(LOC:DisplayCostAmount),SKIP,DECIMAL(12),FONT('MS Sans Serif',,,FONT:bold,CHARSET:ANSI),COLOR(COLOR:BTNFACE),TIP('Outstanding costs to be paid by the debtor before the capital balance can be red' &|
   'uced<13,10>MAT:DebtorsCostsBalance'),READONLY
                     STRING('Interest Balance:'),AT(448,18,55,10),USE(?LOC:DisplayInterestAmount:Prompt)
                     ENTRY(@n-21.2),AT(504,18,60,10),USE(LOC:DisplayInterestAmount),SKIP,DECIMAL(12),FONT('MS Sans Serif',,,FONT:bold,CHARSET:ANSI),COLOR(COLOR:BTNFACE),TIP('Outstanding Interest to be paid by the debtor before the capital balance can be ' &|
   'reduced<13,10>MAT:DebtorsInterestBalance'),READONLY
                     STRING('Capital Balance:'),AT(448,31),USE(?String2:3)
                     ENTRY(@n-21.2),AT(504,31,60,10),USE(MAT:DebtorsCapitalBalance),SKIP,DECIMAL(12),FONT('MS Sans Serif',,,FONT:bold,CHARSET:ANSI),COLOR(COLOR:BTNFACE),TIP('The amount interest is calculated on.<13,10>MAT:DebtorsCapitalBalance'),READONLY
                     STRING('Debtors Balance:'),AT(448,45),USE(?String2:4)
                     ENTRY(@n-21.2),AT(504,45,60,10),USE(MAT:DebtorsBalance),SKIP,DECIMAL(12),FONT('MS Sans Serif',,,FONT:bold),COLOR(COLOR:BTNFACE),TIP('The amount the debtor currently owes<13,10>MAT:DebtorsBalance'),READONLY
                     BUTTON('&Delete'),AT(272,180,42,12),USE(?Delete),HIDE
                     STRING(@s200),AT(4,46,437,10),USE(LOC:InterestSettings)
                     STRING(@s100),AT(4,263,408,10),USE(LOC:CapitalReductionSettings)
                     BUTTON('Tag'),AT(92,96,44,14),USE(?TagOne),HIDE
                     BUTTON('Tag All'),AT(148,96,44,14),USE(?TagAll),HIDE
                     BUTTON('&OK'),AT(505,263,61,20),USE(?Close),SKIP,LEFT,FONT(,11,,,CHARSET:ANSI),TIP('Save and exit'),ICON('check3.ico')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Open                   PROCEDURE(),DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
Update                 PROCEDURE(),DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)               !Browse using ?List:2
Q                      &Queue:Browse                  !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
Reset                  PROCEDURE(),DERIVED
Reset                  PROCEDURE(BYTE Locate),DERIVED
ResetFromAsk           PROCEDURE(*BYTE Request,*BYTE Response),DERIVED
ResetFromBuffer        PROCEDURE(),DERIVED
ResetFromFile          PROCEDURE(),DERIVED
ResetFromView          PROCEDURE(),DERIVED
ResetQueue             PROCEDURE(BYTE ResetMode),DERIVED
SetQueueRecord         PROCEDURE(),DERIVED
UpdateBuffer           PROCEDURE(),DERIVED
UpdateViewRecord       PROCEDURE(),DERIVED
UpdateWindow           PROCEDURE(),DERIVED
                     END

BRW1::Sort0:Locator  StepLocatorClass                 !Default Locator
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


CODE
GlobalResponse = ThisWindow.Run()

PrintAccountInWord  ROUTINE

   LOC:DataSeperator  = '<09>'
   LOC:LineFeed = '<13,10>'


      DO CalculateSettlement

      LOC:ClientPrompt = 'Client:'
      LOC:DebtorPrompt = 'Debtor:'
      LOC:MatterPrompt = 'Matter:'
      LOC:InterestPrompt = 'Interest:'
      LOC:PrintedByPrompt = 'Printed By:'


      GLO:WordObj{PROP:Release} = GLO:WordObj{PROP:Object}
      GLO:WordObj{PROP:Deactivate}
      DESTROY(GLO:WordObj)

      GLO:WordObj = CREATE(0,CREATE:OLE)
      GLO:WordObj{PROP:Create} = 'Word.Application'

      IF ~GLO:WordObj{'Application'}
         MESSAGE('Unable to load Microsoft Word','OLE Error',ICON:Exclamation)
         EXIT
      END

      GLO:WordObj{'Visible'} = 0
      GLO:WordObj{'Documents.Add'}
      GLO:WordObj{'ActiveWindow.View.Type'} = 1  ! Normal View is faster for processing



   ! Speeding up Word:  https://msdn.microsoft.com/en-us/library/aa537149(v=office.11).aspx


      GLO:WordObj{'ScreenUpdating'} = False
      GLO:WordObj{'Options.CheckGrammarAsYouType'} = 0
      GLO:WordObj{'ActiveDocument.ShowGrammaticalErrors'} = 0
      GLO:WordObj{'Options.CheckSpellingAsYouType'} = 0
      GLO:WordObj{'Options.Pagination'} = 0
      GLO:WordObj{'ActiveDocument.ShowSpellingErrors'} = 0
      GLO:WordObj{'Application.ErrorCheckingOptions.BackgroundChecking'} = False


      !****************************** TESTING ********************************************
      !GLO:WordObj{'Visible'} = 1
      !GLO:WordObj{'ActiveWindow.View.Type'} = 3  ! Normal View is faster for processing
      !****************************** TESTING ********************************************


      IF LOC:LetterheadFlag

         IF MP:MatterID = MAT:RecordID AND  MP:RoleID = CTL:DefendantRoleID
            GLO:WordObj{'Selection.InsertAfter("' & GetDescription('PARTY ADDRESSEE',MP:PartyID) & '<13,10>' & GetDescription('PARTY POSTAL ADDRESS',MP:PartyID) & '<13,10>")'}
            GLO:WordObj{'Selection.Collapse(0)'}
            GLO:WordObj{'Selection.TypeParagraph'}
         END

      END

      ! Report Heading
      GLO:WordObj{'Selection.InsertAfter("' & LOC:ReportHeading & '<13,10>")'}

      GLO:WordObj{'Selection.Font.Underline'} = 1
      GLO:WordObj{'Selection.Font.Bold'} = 1
      GLO:WordObj{'Selection.Font.Size'} = 16
      GLO:WordObj{'Selection.ParagraphFormat.Alignment'} = 1 ! Centred

      ! NEW PARAGRAPH
      GLO:WordObj{'Selection.Collapse(0)'}
      GLO:WordObj{'Selection.TypeParagraph'}
      GLO:WordObj{'Selection.ParagraphFormat.Alignment'} = 0 
      GLO:WordObj{'Selection.Font.Reset'}


      LOC:InsertText = LOC:ClientPrompt & '<09>' & GetDescription('Party Name',MAT:ClientID) & '<13,10>'
      GLO:WordObj{'Selection.InsertAfter("' & LOC:InsertText & '")'}

      LOC:InsertText = LOC:DebtorPrompt & '<09>' & GetDescription('MATPARTY NAME',MAT:RecordID,CTL:DefendantRoleID) & ' (ID: ' & GetDescription('MATPARTY ID NUMBER',MAT:RecordID,CTL:DefendantRoleID) & ')' & '<13,10>'
      GLO:WordObj{'Selection.InsertAfter("' & LOC:InsertText & '")'}

      LOC:InsertText = LOC:MatterPrompt & '<09>' & MAT:FileRef & ' - ' & MAT:Description & '<13,10>'
      GLO:WordObj{'Selection.InsertAfter("' & LOC:InsertText & '")'}

      LOC:InsertText = LOC:InterestPrompt & '<09>' & LOC:InterestSettings & '<13,10>'
      GLO:WordObj{'Selection.InsertAfter("' & LOC:InsertText & '")'}

      IF LOC:CostRatioFlag

         LOC:CostRatio = (MAT:DebtorsTotalCosts + MAT:DebtorsTotalCommission)*100/MAT:ClaimAmount
         LOC:InsertText = 'Cost to Claim Ratio:<09>' & CLIP(LEFT(FORMAT(LOC:CostRatio,@n_9))) & '%<13,10>'
         GLO:WordObj{'Selection.InsertAfter("' & LOC:InsertText & '")'}

      END

      LOC:InsertText = LOC:PrintedByPrompt & '<09>' & GLO:UserName & ' for ' & CTL:Name & ' on ' & FORMAT(Today(),@D17) & ' at ' & FORMAT(CLOCK(),@T7) & '<13,10>'
      GLO:WordObj{'Selection.InsertAfter("' & LOC:InsertText & '")'}


         LOC:WordTable = GLO:WordObj{'Selection.ConvertToTable(Separator=1, Format=16, AutoFitBehavior=' & wdAutoFitWindow & ', DefaultTableBehavior=' & wdWord8TableBehavior & ')'}

         GLO:WordObj{LOC:WordTable & '.Columns(1).PreferredWidthType'} = wdPreferredWidthPercent
         GLO:WordObj{LOC:WordTable & '.Columns(1).PreferredWidth'} = 20

         GLO:WordObj{LOC:WordTable & '.Columns(2).PreferredWidthType'} = wdPreferredWidthPercent
         GLO:WordObj{LOC:WordTable & '.Columns(2).PreferredWidth'} = 80

         ! Bold and shade heading column
         GLO:WordObj{LOC:WordTable & '.Columns(1).Select'}
         GLO:WordObj{'Selection.Font.Bold'} = 1
         GLO:WordObj{'Selection.Cells.Shading.BackgroundPatternColor'} = wdColorGray10


      GLO:WordObj{LOC:WordTable & '.Select'} ! SELECT THE TABLE SO WE CAN COLLAPSE TO THE RIGHT OF IT

      ! NEW PARAGRAPH
      GLO:WordObj{'Selection.Collapse(0)'}
      GLO:WordObj{'Selection.TypeParagraph'}
      GLO:WordObj{'Selection.ParagraphFormat.Alignment'} = 0 
      GLO:WordObj{'Selection.Font.Reset'}

      ! Report Sub Heading
      GLO:WordObj{'Selection.InsertAfter("Transactions<13,10>")'}
      GLO:WordObj{'Selection.Font.Underline'} = 1
      GLO:WordObj{'Selection.Font.Bold'} = 1
      GLO:WordObj{'Selection.Font.Size'} = 16
      GLO:WordObj{'Selection.ParagraphFormat.Alignment'} = 1 ! Centred

      ! NEW PARAGRAPH
      GLO:WordObj{'Selection.Collapse(0)'}
      GLO:WordObj{'Selection.TypeParagraph'}
      GLO:WordObj{'Selection.ParagraphFormat.Alignment'} = 0 
      GLO:WordObj{'Selection.Font.Reset'}


      ! Table column headings

      DO CreateTransactionHeadings

      GLO:WordObj{'Selection.InsertAfter("' & LOC:InsertText & '")'}

      LOOP LOC:CurrentRow = 1 TO LOC:TotalRows

      GET(Queue:Browse,LOC:CurrentRow)

      DO CreateTansactionData

      GLO:WordObj{'Selection.InsertAfter("' & LOC:InsertText & '")'}

      END

      ! Add the current balance at the end
      LOC:InsertText = '<09>Current Balance'
      LOOP LOC:CurrentColumn = 3 TO LOC:TotalColumns
         LOC:InsertText = LOC:InsertText & '<09>'
      END
      LOC:InsertText = LOC:InsertText & CLIP(LEFT(FORMAT(Queue:Browse.CD:Balance,@n-15.2))) & '<13,10>'
      GLO:WordObj{'Selection.InsertAfter("' & LOC:InsertText & '")'}


      IF RE:Check7  ! INCLUDE TOTALS

         LOC:InsertText = 'Totals<09>'

         IF LOC:ReportTranTypeFlag THEN LOC:InsertText = LOC:InsertText & '<09>'.

         IF RE:Check4
            LOC:InsertText = LOC:InsertText & '<09>' & CLIP(LEFT(FORMAT(LOC:Total4d,@n-15.2B)))
            LOC:InsertText = LOC:InsertText & '<09>' & CLIP(LEFT(FORMAT(LOC:Total4c,@n-15.2B)))
         ELSE ! pk here
            LOC:InsertText = LOC:InsertText & '<09>' !& CLIP(LEFT(FORMAT(LOC:Total4,@n-15.2B)))
         END
         ! 06 Jan 2021 PK Naidoo - FB Case 3230
         IF RE:Check5
            LOC:InsertText = LOC:InsertText & '<09>' & CLIP(LEFT(FORMAT(-LOC:Total5,@n-15.2B)))
         END
         IF RE:Check3
            LOC:InsertText = LOC:InsertText & '<09>' & CLIP(LEFT(FORMAT(LOC:Total3,@n-15.2B)))
         END
         IF RE:Check2
            LOC:InsertText = LOC:InsertText & '<09>' & CLIP(LEFT(FORMAT(LOC:Total2,@n-15.2B)))
         END
         IF RE:Check1
            LOC:InsertText = LOC:InsertText & '<09>' & CLIP(LEFT(FORMAT(LOC:Total1,@n-15.2B)))
         END
         LOC:InsertText = LOC:InsertText & '<09><13,10>'

         GLO:WordObj{'Selection.InsertAfter("' & LOC:InsertText & '")'}

      END


      LOC:WordTable = GLO:WordObj{'Selection.ConvertToTable(Separator=1, Format=16, AutoFitBehavior=' & wdAutoFitWindow & ', DefaultTableBehavior=' & wdWord8TableBehavior & ')'}

      TotalColumns# = GLO:WordObj{'Selection.Tables(1).Columns.Count'}

      DescriptionColumnWidth# = 100 - ( TotalColumns# * 11 )

      IF DescriptionColumnWidth# < 20 THEN DescriptionColumnWidth# = 20.

      OtherColumnWidth# = (100 - DescriptionColumnWidth#) / (TotalColumns#-1)

      !MESSAGE('DescriptionColumnWidth# = ' & DescriptionColumnWidth# & '|OtherColumnWidth# = ' & OtherColumnWidth#)

      GLO:WordObj{LOC:WordTable & '.Columns(1).PreferredWidthType'} = wdPreferredWidthPercent
      GLO:WordObj{LOC:WordTable & '.Columns(1).PreferredWidth'} = OtherColumnWidth#


      GLO:WordObj{LOC:WordTable & '.Columns(2).PreferredWidthType'} = wdPreferredWidthPercent
      GLO:WordObj{LOC:WordTable & '.Columns(2).PreferredWidth'} = DescriptionColumnWidth#


      LOOP Col# = 3 TO TotalColumns#

         GLO:WordObj{LOC:WordTable & '.Columns(' & Col# & ').PreferredWidthType'} = wdPreferredWidthPercent
         GLO:WordObj{LOC:WordTable & '.Columns(' & Col# & ').PreferredWidth'} = OtherColumnWidth#

      END

      TotalRows# = GLO:WordObj{'Selection.Tables(1).Rows.Count'}

      ! Bold and shade heading row
      GLO:WordObj{'Selection.Tables(1).Rows(1).Select'}
      GLO:WordObj{'Selection.Font.Bold'} = 1
      GLO:WordObj{'Selection.Cells.Shading.BackgroundPatternColor'} = wdColorGray10

      ! Bold and shade last row
      GLO:WordObj{'Selection.Tables(1).Rows(' & TotalRows# & ').Select'}
      GLO:WordObj{'Selection.Font.Bold'} = 1
      GLO:WordObj{'Selection.Cells.Shading.BackgroundPatternColor'} = wdColorGray10


      ! Right justify the amount columns
      LOOP LOC:CurrentColumn = 3 TO LOC:TotalColumns

         GLO:WordObj{'Selection.Tables(1).Columns(' & LOC:CurrentColumn & ').Select'}
         GLO:WordObj{'Selection.ParagraphFormat.Alignment'} = 2 ! Right justified

      END

      ! Format the table
      GLO:WordObj{'Selection.Tables(1).Select'}
      GLO:WordObj{'Selection.Font.Size'} = LOC:FontSize
      GLO:WordObj{'Selection.Rows.Alignment'} = 1


      ! NEW PARAGRAPH
      GLO:WordObj{'Selection.Collapse(0)'}
      GLO:WordObj{'Selection.TypeParagraph'}


      !******************************** SETTLEMENT **********************************************************************

      IF LOC:SettlementFlag 


         ! NEW PARAGRAPH
         GLO:WordObj{'Selection.Collapse(0)'}
         GLO:WordObj{'Selection.TypeParagraph'}
         GLO:WordObj{'Selection.ParagraphFormat.Alignment'} = 0 
         GLO:WordObj{'Selection.Font.Reset'}

         ! Report Sub Heading
         GLO:WordObj{'Selection.InsertAfter("Settlement Details<13,10>")'}
         GLO:WordObj{'Selection.Font.Underline'} = 1
         GLO:WordObj{'Selection.Font.Bold'} = 1
         GLO:WordObj{'Selection.Font.Size'} = 16
         GLO:WordObj{'Selection.ParagraphFormat.Alignment'} = 1 ! Centred

         ! NEW PARAGRAPH
         GLO:WordObj{'Selection.Collapse(0)'}
         GLO:WordObj{'Selection.TypeParagraph'}
         GLO:WordObj{'Selection.ParagraphFormat.Alignment'} = 0 
         GLO:WordObj{'Selection.Font.Reset'}



         LOC:InsertText = 'Current Balance<09>' & GLO:CurrencySymbol & CLIP(LEFT(FORMAT(MAT:DebtorsBalance,@n-15.2))) & '<13,10>'
         GLO:WordObj{'Selection.InsertAfter("' & LOC:InsertText & '")'}

         LOC:InsertText = 'Plus Collection Commission<09>' & GLO:CurrencySymbol & CLIP(LEFT(FORMAT(LOC:Costs,@n-15.2))) & '<13,10>'
         GLO:WordObj{'Selection.InsertAfter("' & LOC:InsertText & '")'}

         LOC:InsertText = 'VAT on Commission<09>' & GLO:CurrencySymbol & CLIP(LEFT(FORMAT(LOC:VAT,@n-15.2))) & '<13,10>'
         GLO:WordObj{'Selection.InsertAfter("' & LOC:InsertText & '")'}

         LOC:InsertText = 'Settlement Amount<09>'& GLO:CurrencySymbol & CLIP(LEFT(FORMAT(LOC:SettleAmount,@n-15.2))) & '<13,10>'
         GLO:WordObj{'Selection.InsertAfter("' & LOC:InsertText & '")'}

         LOC:WordTable = GLO:WordObj{'Selection.ConvertToTable(Separator=1, Format=16, AutoFitBehavior=' & wdAutoFitWindow & ', DefaultTableBehavior=' & wdWord8TableBehavior & ')'}

         GLO:WordObj{LOC:WordTable & '.Columns(1).PreferredWidthType'} = wdPreferredWidthPercent
         GLO:WordObj{LOC:WordTable & '.Columns(1).PreferredWidth'} = 40

         GLO:WordObj{LOC:WordTable & '.Columns(2).PreferredWidthType'} = wdPreferredWidthPercent
         GLO:WordObj{LOC:WordTable & '.Columns(2).PreferredWidth'} = 60

         ! Bold and shade heading column
         GLO:WordObj{LOC:WordTable & '.Columns(1).Select'}
         GLO:WordObj{'Selection.Font.Bold'} = 1
         GLO:WordObj{'Selection.Cells.Shading.BackgroundPatternColor'} = wdColorGray10

         GLO:WordObj{LOC:WordTable & '.Select'} ! SELECT THE TABLE SO WE CAN COLLAPSE TO THE RIGHT OF IT


         ! NEW PARAGRAPH
         GLO:WordObj{'Selection.Collapse(0)'}

         LOC:InsertText = 'Note:The settlement amount is valid up and until ' & Format(GLO:TodaysDate,@d17)
         GLO:WordObj{'Selection.InsertAfter("' & LOC:InsertText & '")'}
         GLO:WordObj{'Selection.Font.Reset'}


      END


      ! NEW PARAGRAPH
      GLO:WordObj{'Selection.Collapse(0)'}
      GLO:WordObj{'Selection.TypeParagraph'}

   !***************************** FOOTER *************************************************************************


      IF LOC:ReportFooterIncludeFile

         LOC:ReportFooterFileName = GetRoot(LOC:ReportFooterIncludeFile)

         GLO:TestFileName = LOC:ReportFooterFileName

         OPEN(TestFile,0)

         IF ERROR() AND ERRORCODE() <> 52


         ELSE

            CLOSE(TestFile)

            GLO:WordObj{'Selection.InsertFile(FileName="' & LOC:ReportFooterFileName & '",ConfirmConversions=False)'}

            SAV:GLO:WordprocessorOption = GLO:WordprocessorOption

            GLO:WordprocessorOption = 'M'

            ReplaceMergeFields('',LOC:ReportFooterFileName)

            GLO:WordprocessorOption = SAV:GLO:WordprocessorOption

            RangeObj = GLO:WordObj{'ActiveDocument.StoryRanges(1)'} ! Go to Main Story
            GLO:WordObj{RangeObj & '.Select'}


            ! NEW PARAGRAPH
            GLO:WordObj{'Selection.Collapse(0)'}
            GLO:WordObj{'Selection.TypeParagraph'}


         END

      END

   !**************************** SET TO ARIAL **************************************************************************


      GLO:WordObj{'Selection.WholeStory'}
      GLO:WordObj{'Selection.Font.Name'} = 'Arial'
      GLO:WordObj{'Selection.Collapse(0)'}


   !***************************** LETTERHEAD *************************************************************************
      ! 21/11/2019 PK Naidoo - FB Case 2727
      ! 28/01/2020 PK Naidoo - FB Case 2727 - Some MatParty did not have a Language ID, so I changed the IF statement a bit.
      IF MP:MatterID = MAT:RecordID AND  MP:RoleID = CTL:DefendantRoleID
         LOC:LetterHead = GetDescription('Debtor LetterHead',GLO:EmployeeID,MP:LanguageID)
      END

      IF ~LOC:LetterHead
         LOC:LetterHead = GetDescription('Debtor LetterHead',GLO:EmployeeID,GLO:DefaultLanguageID)
      END

      IF LOC:LetterHead AND LOC:LetterheadFlag

         LOC:ReportProgressWindowString = 'Inserting the letterhead'; DISPLAY
         
         GLO:TestFileName = LOC:LetterHead

         OPEN(TestFile,0)
         IF ERROR() AND ERRORCODE() <> 52


         ELSE

            CLOSE(TestFile)

            ! Save the report, load the letterhead and insert the report below the letterhead

            IF CTL:UseMSWordDocxFlag

               LOC:TempSavedName = LOC:SavedName & '.docx'
               Result$ = GLO:WordObj{'ActiveDocument.SaveAs(FileName = "' & LOC:TempSavedName & '",AddToRecentFiles=False,FileFormat=' & wdFormatDocumentDefault & ')'}

            ELSE

               LOC:TempSavedName = LOC:SavedName & '.doc'
               Result$ = GLO:WordObj{'ActiveDocument.SaveAs(FileName = "' & LOC:TempSavedName & '",AddToRecentFiles=False,FileFormat=' & wdFormatDocument & ')'}

            END


            GLO:WordObj{'ActiveDocument.Close(SaveChanges=0)'}

            GLO:WordObj{'Documents.Open(ReadOnly=True, FileName = "' & LOC:LetterHead & '")'}

            GLO:WordObj{'ActiveWindow.View.Type'} = 3

            GetAllTables(MAT:RecordID)

            SAV:GLO:WordprocessorOption = GLO:WordprocessorOption

            GLO:WordprocessorOption = 'M'

            ReplaceMergeFields('','Letterhead')

            GLO:WordprocessorOption = SAV:GLO:WordprocessorOption

            GLO:WordObj{'Selection.EndKey(Unit=6)'} ! Go to the end of the letterhead

            ! NEW PARAGRAPH
            GLO:WordObj{'Selection.Collapse(0)'}
            GLO:WordObj{'Selection.TypeParagraph'}

            GLO:WordObj{'Selection.InsertFile(FileName="' & LOC:TempSavedName & '",ConfirmConversions=False)'}

         END

      END

      !IF ~LOC:LetterheadFlag  THEN  GLO:WordObj{'ActiveDocument.PageSetup.Orientation'} = 1. ! Set it to Landscape
      ! 06 Dec 2018: PK Naidoo - FB Case 1626
      IF LOC:PrintInLandscape

         GLO:WordObj{'ActiveDocument.PageSetup.Orientation'} = 1 ! Set it to Landscape

      END

      IF GLO:ReportDestination = 'P'

      LOC:SavedName = LOC:SavedName & '.pdf'
      GLO:WordObj{'ActiveDocument.ExportAsFixedFormat(OutputFileName="' & LOC:SavedName & '", ExportFormat=17, OpenAfterExport=False)'}

      ELSE

      IF CTL:UseMSWordDocxFlag

         LOC:SavedName = LOC:SavedName & '.docx'
         Result$ = GLO:WordObj{'ActiveDocument.SaveAs(FileName = "' & LOC:SavedName & '",AddToRecentFiles=False,FileFormat=' & wdFormatDocumentDefault & ')'}

      ELSE

         LOC:SavedName = LOC:SavedName & '.doc'
         Result$ = GLO:WordObj{'ActiveDocument.SaveAs(FileName = "' & LOC:SavedName & '",AddToRecentFiles=False,FileFormat=' & wdFormatDocument & ')'}

      END

      END

      GLO:WordObj{'Application.Quit(SaveChanges=0)'}

      GLO:WordObj{PROP:Release} = GLO:WordObj{PROP:Object}
      GLO:WordObj{PROP:Deactivate}
      DESTROY(GLO:WordObj)

PrintAccountInExcel  ROUTINE


   LOC:DataSeperator  = ','
   LOC:LineFeed = ''

   IF EdOpenReport(0,LOC:SavedName & '.XLS',True,,-998) ! Set the ReportID to clean up after displaying the imported CSV
      EXIT
   END

   DO CreateTransactionHeadings

   EXP:String = CLIP(LOC:InsertText)

   LOOP LOC:CurrentRow = 1 TO LOC:TotalRows

   GET(Queue:Browse,LOC:CurrentRow)

   YIELD# += 1; IF ~YIELD# % 10 THEN YIELD.

   ADD(ExportFile)     ! ADD PREVIOUS ROW

   DO CreateTansactionData

   EXP:String = CLIP(LOC:InsertText)

   END


   IF RE:Check7  ! INCLUDE TOTALS

         ADD(ExportFile)     ! ADD PREVIOUS ROW


         LOC:InsertText = 'Totals' & LOC:DataSeperator

         IF LOC:ReportTranTypeFlag THEN LOC:InsertText = LOC:InsertText & LOC:DataSeperator.

         IF RE:Check4
            LOC:InsertText = LOC:InsertText & LOC:DataSeperator & CLIP(LEFT(FORMAT(LOC:Total4d,@n-_15.2B)))
            LOC:InsertText = LOC:InsertText & LOC:DataSeperator & CLIP(LEFT(FORMAT(LOC:Total4c,@n-_15.2B)))
         ELSE ! pk here
            LOC:InsertText = LOC:InsertText & LOC:DataSeperator !& CLIP(LEFT(FORMAT(LOC:Total4,@n-_15.2B)))
         END
         ! 06 Jan 2021 PK Naidoo - FB Case 3230
         IF RE:Check5
            LOC:InsertText = LOC:InsertText & LOC:DataSeperator & CLIP(LEFT(FORMAT(-LOC:Total5,@n-_15.2B)))
         END
         IF RE:Check3
            LOC:InsertText = LOC:InsertText & LOC:DataSeperator & CLIP(LEFT(FORMAT(LOC:Total3,@n-_15.2B)))
         END
         IF RE:Check2
            LOC:InsertText = LOC:InsertText & LOC:DataSeperator & CLIP(LEFT(FORMAT(LOC:Total2,@n-_15.2B)))
         END
         IF RE:Check1
            LOC:InsertText = LOC:InsertText & LOC:DataSeperator & CLIP(LEFT(FORMAT(LOC:Total1,@n-_15.2B)))
         END
         LOC:InsertText = LOC:InsertText & LOC:DataSeperator

         EXP:String = CLIP(LOC:InsertText)


      END


   EdDisplayReport(LOC:ReportHeading,MAT:FileRef & ' - ' & MAT:Description)

CreateTransactionHeadings   ROUTINE

   ! USE THIS QUEUE TO FORMAT THE COLUMNS IN EXCEL
   FREE(ACQ:AlertColumnQueue)
   CLEAR(ACQ:AlertColumnQueue)


   LOC:InsertText = 'Date' & LOC:DataSeperator & 'Description'


   ACQ:Type = 'Date'
   ADD(ACQ:AlertColumnQueue)

   ACQ:Type = 'Text'
   ADD(ACQ:AlertColumnQueue)


   IF LOC:ReportTranTypeFlag
      LOC:InsertText = LOC:InsertText & LOC:DataSeperator & 'Type'

      ACQ:Type = 'Text'
      ADD(ACQ:AlertColumnQueue)


   END
   IF LOC:ReportDebitsAndCreditsFlag
      LOC:InsertText = LOC:InsertText & LOC:DataSeperator & 'Debits'
      LOC:InsertText = LOC:InsertText & LOC:DataSeperator & 'Credits'


      ACQ:Type = 'Currency'
      ADD(ACQ:AlertColumnQueue)

      ACQ:Type = 'Currency'
      ADD(ACQ:AlertColumnQueue)

   ELSE

      LOC:InsertText = LOC:InsertText & LOC:DataSeperator & 'Amount'

      ACQ:Type = 'Currency'
      ADD(ACQ:AlertColumnQueue)


   END

   IF LOC:PaymentsFlag

      LOC:InsertText = LOC:InsertText & LOC:DataSeperator & 'Paid'

      ACQ:Type = 'Currency'
      ADD(ACQ:AlertColumnQueue)

   END


   IF LOC:ReportCollCommFlag

      LOC:InsertText = LOC:InsertText & LOC:DataSeperator & 'Comm'

      ACQ:Type = 'Currency'
      ADD(ACQ:AlertColumnQueue)


   END

   IF LOC:ReportInterestDaysFlag

      LOC:InsertText = LOC:InsertText & LOC:DataSeperator & 'Days'

      ACQ:Type = 'Integer'
      ADD(ACQ:AlertColumnQueue)


   END

   IF LOC:ReportInterestFlag

      LOC:InsertText = LOC:InsertText & LOC:DataSeperator & 'Interest'

      ACQ:Type = 'Decimal'
      ADD(ACQ:AlertColumnQueue)


   END

   LOC:InsertText = LOC:InsertText & LOC:DataSeperator & 'Balance' & LOC:LineFeed

   ACQ:Type = 'Currency'
   ADD(ACQ:AlertColumnQueue)



CreateTansactionData       ROUTINE


      LOC:InsertText = FORMAT(Queue:Browse.CD:Date,@d17B)
      LOC:InsertText = LOC:InsertText & LOC:DataSeperator & StripQuotes(StripLineFeeds(StripCommas(Queue:Browse.CD:Description)))

      IF LOC:ReportTranTypeFlag
         LOC:InsertText = LOC:InsertText & LOC:DataSeperator & Queue:Browse.LOC:TranType
      END

      IF LOC:ReportDebitsAndCreditsFlag
         IF Queue:Browse.CD:Type <> 'P' AND Queue:Browse.CD:Type <> 'V'

            IF RE:Check1 AND (Queue:Browse.CD:Type = 'I' OR Queue:Browse.CD:Type = 'J' OR Queue:Browse.CD:Type = 'Y')
               LOC:InsertText = LOC:InsertText & LOC:DataSeperator ! DON'T REPEAT THE INTEREST
            ELSIF RE:Check3 AND Queue:Browse.CD:Type = 'X'
               LOC:InsertText = LOC:InsertText & LOC:DataSeperator ! DON'T REPEAT THE COLL COMM
            ELSE
               LOC:InsertText = LOC:InsertText & LOC:DataSeperator
               IF LOC:CurrentRow > 1
                     LOC:InsertText = LOC:InsertText & CLIP(LEFT(StripCommas(Queue:Browse.LOC:DisplayAmount)))
                     LOC:Total4d += Queue:Browse.CD:Amount + Queue:Browse.CD:VatAmount
               END
            END

            LOC:InsertText = LOC:InsertText & LOC:DataSeperator ! BLANK
         ELSE
            LOC:InsertText = LOC:InsertText & LOC:DataSeperator ! BLANK

            LOC:InsertText = LOC:InsertText & LOC:DataSeperator
            IF LOC:CurrentRow > 1
               LOC:InsertText = LOC:InsertText & CLIP(LEFT(StripCommas(Queue:Browse.LOC:DisplayAmount)))
               LOC:Total4c += Queue:Browse.CD:Amount + Queue:Browse.CD:VatAmount
            END
         END

      ELSE
         LOC:InsertText = LOC:InsertText & LOC:DataSeperator
         IF LOC:CurrentRow > 1 
            LOC:InsertText = LOC:InsertText & CLIP(LEFT(StripCommas(Queue:Browse.LOC:DisplayAmount)))
            LOC:Total4 += Queue:Browse.CD:Amount + Queue:Browse.CD:VatAmount
         END

      END

      IF LOC:PaymentsFlag
         IF Queue:Browse.CD:Type = 'P' AND Queue:Browse.CD:Category = 'P'
            LOC:Amount = Queue:Browse.CD:Amount + Queue:Browse.CD:VatAmount
         ELSE
            LOC:Amount = 0
         END
         
         LOC:InsertText = LOC:InsertText & LOC:DataSeperator & CLIP(LEFT(FORMAT(-LOC:Amount,@n-_15.2B)))
         LOC:Total5 += LOC:Amount
      END


      IF LOC:ReportCollCommFlag
         IF Queue:Browse.CD:Type = 'X' 
            LOC:Amount = Queue:Browse.CD:Amount + Queue:Browse.CD:VatAmount
         ELSE
            LOC:Amount = 0
         END
         LOC:InsertText = LOC:InsertText & LOC:DataSeperator & CLIP(LEFT(FORMAT(LOC:Amount,@n-_15.2B)))
         LOC:Total3 += LOC:Amount
      END

      IF LOC:ReportInterestDaysFlag
         IF (Queue:Browse.CD:Type = 'I' OR Queue:Browse.CD:Type = 'J' OR Queue:Browse.CD:Type = 'Y') AND LOC:LastDate
            LOC:Amount = Queue:Browse.CD:Date - LOC:LastDate + 1

            LOC:LastDate = Queue:Browse.CD:Date + 1
         ELSE
            LOC:Amount = 0
         END
         LOC:InsertText = LOC:InsertText & LOC:DataSeperator & CLIP(LEFT(FORMAT(LOC:Amount,@n_5B)))
         LOC:Total2 += LOC:Amount
      END

      IF LOC:ReportInterestFlag
         IF Queue:Browse.CD:Type = 'I' OR Queue:Browse.CD:Type = 'J' OR Queue:Browse.CD:Type = 'Y'
            LOC:Amount = Queue:Browse.CD:Amount + Queue:Browse.CD:VatAmount
         ELSE
            LOC:Amount = 0
         END
         LOC:InsertText = LOC:InsertText & LOC:DataSeperator & CLIP(LEFT(FORMAT(LOC:Amount,@n-_15.2B)))
         LOC:Total1 += LOC:Amount
      END

      LOC:InsertText = LOC:InsertText & LOC:DataSeperator  & CLIP(LEFT(FORMAT(Queue:Browse.CD:Balance,@n-_15.2)))
      LOC:InsertText = LOC:InsertText & LOC:LineFeed




PrintDeborsAccount  ROUTINE
      DEBUG('GLO:ReportDestination = ' & GLO:ReportDestination)

      SAV:MatterID = MAT:RecordID

      IF ~INLIST(GLO:ReportDestination,'M','P','X') THEN GLO:ReportDestination = 'P'.
      
      LOC:Total5 = 0
      LOC:Total4c = 0
      LOC:Total4d = 0
      LOC:Total4 = 0
      LOC:Total3 = 0
      LOC:Total2 = 0
      LOC:Total1 = 0


      OPEN(PrintSummaryReportWindow)

      RE:EmployeeID = GLO:EmployeeID
      RE:ReportID = -1342                    ! USING AN ARBITARY NUMBER TO IDENTIFY THIS REPORT
      IF Access:RepEmp.TryFetch(RE:PrimaryKey)
         Access:RepEmp.Insert
      ELSE
         LOC:ReportInterestFlag      = RE:Check1
         LOC:ReportInterestDaysFlag  = RE:Check2
         LOC:ReportCollCommFlag      = RE:Check3
         LOC:ReportDebitsAndCreditsFlag = RE:Check4
         LOC:PaymentsFlag            = RE:Check5
         LOC:ReportTranTypeFlag      = RE:Check6
         LOC:ReportTotalsFlag        = RE:Check7
         LOC:LetterheadFlag          = RE:Check8
         LOC:SettlementFlag          = RE:Check9
         LOC:CostRatioFlag           = RE:Check10
         LOC:FontSize                = RE:Check11
         LOC:ReportEmailFlag         = RE:Check12
         LOC:ReportHeading           = RE:ReportHeading
         LOC:ReportFooterIncludeFile = RE:ReportFooterIncludeFile
         IF ~LOC:ReportHeading THEN LOC:ReportHeading = 'Detailed Debtor''s Report'.

      END


      ?LOC:FontSize{PROP:Selected} = LOC:FontSize - 6

      IF GLO:ReportDestination = 'X'

         LOC:SettlementFlag = 0
         LOC:CostRatioFlag = 0
         LOC:LetterheadFlag = 0
         LOC:PrintInLandscape = 0
         ?LOC:LetterheadFlag{PROP:Disable} = True
         ?LOC:SettlementFlag{PROP:Disable} = True
         ?LOC:CostRatioFlag{PROP:Disable} = True
         ?LOC:PrintInLandscape{PROP:Disable} = True
         
      END

      LOC:GoAhead = 0
      DISPLAY
      ACCEPT
         CASE FIELD()
               OF ?LookupFileButton

                  CASE EVENT()
                  OF EVENT:Accepted
                     SavePath" = Path()
                     FileLookup11.DefaultFile=GetRoot(LOC:ReportFooterIncludeFile)
                     LOC:ReportFooterIncludeFile = SetRoot(FileLookup11.Ask(1))
                     DISPLAY
                     SetPath(SavePath")
                  END

               OF ?OKButton1
                  CASE EVENT()
                     OF EVENT:Accepted

                        IF LOC:ReportEmailFlag AND GLO:ReportDestination = 'X'
                           GLO:ReportDestination = 'P'
                           DISPLAY
                           MESSAGE('Reports should not be sent via Excel for security reasons.||The recommended format is PDF','Report Format for Emails', ICON:Exclamation)
                        ELSE
                           LOC:GoAhead = 1
                           BREAK
                        END
                  END
               OF ?CancelButton1
                  CASE EVENT()
                     OF EVENT:Accepted
                        BREAK
                  END
         END
         IF GLO:ReportDestination = 'X'
            LOC:SettlementFlag = 0
            LOC:CostRatioFlag = 0
            LOC:LetterheadFlag = 0
            LOC:PrintInLandscape = 0
            ?LOC:LetterheadFlag{PROP:Disable} = True
            ?LOC:SettlementFlag{PROP:Disable} = True
            ?LOC:CostRatioFlag{PROP:Disable} = True
            ?LOC:PrintInLandscape{PROP:Disable} = True
         ELSE
            ?LOC:LetterheadFlag{PROP:Disable} = False
            ?LOC:SettlementFlag{PROP:Disable} = False
            ?LOC:CostRatioFlag{PROP:Disable} = False
            ?LOC:PrintInLandscape{PROP:Disable} = False
         END
      END

      CLOSE(PrintSummaryReportWindow)


      RE:EmployeeID = GLO:EmployeeID
      RE:ReportID = -1342
      RE:Check1 = LOC:ReportInterestFlag
      RE:Check2 = LOC:ReportInterestDaysFlag
      RE:Check3 = LOC:ReportCollCommFlag
      RE:Check4 = LOC:ReportDebitsAndCreditsFlag
      RE:Check5 = LOC:PaymentsFlag
      RE:Check6 = LOC:ReportTranTypeFlag
      RE:Check7 = LOC:ReportTotalsFlag
      RE:Check8 = LOC:LetterheadFlag
      RE:Check9 = LOC:SettlementFlag
      RE:Check10  = LOC:CostRatioFlag
      RE:Check11  = LOC:FontSize
      RE:FontSize = LOC:FontSize
      RE:Check12 = LOC:ReportEmailFlag
      RE:ReportHeading = LOC:ReportHeading
      RE:ReportFooterIncludeFile = LOC:ReportFooterIncludeFile


      ! 3/8/2014 - CAN'T TOTAL IF NOT SHOWING INDIVIDAUL COLUMNS TO TOTAL
      IF RE:Check7
         IF ~RE:Check1 AND ~RE:Check2 AND ~RE:Check3 AND ~RE:Check4 AND ~RE:Check5
            RE:Check7 = 0
         END
      END


      Access:RepEmp.Update

      IF LOC:GoAhead = 0 THEN EXIT.


      
      LOC:TotalColumns = 4 + LOC:ReportInterestFlag + LOC:ReportInterestDaysFlag  + LOC:ReportCollCommFlag + LOC:PaymentsFlag + LOC:ReportDebitsAndCreditsFlag + LOC:ReportTranTypeFlag


      FREE(GEQ:ErrorQueue)
      CLEAR(GEQ:ErrorQueue)


      SETCURSOR(Cursor:Wait)
      OPEN(ReportProgressWindow)
      LOC:ReportProgressWindowString = 'Loading the Debtors Report'; DISPLAY


      LOC:TestPath = CLIP(GetRoot(GLO:MergedDocumentLocation))

      If ~Exists(LOC:TestPath)

         a# = MkDir(LOC:TestPath)

      END


      IF LOC:TaggedMatters

         !GLO:SendingMultipleEmailsFlag = 1

         CLEAR(MAT:Record)
         LOOP

         MAT:RecordId = Choose(MAT:RecordId=0,FstTag:PtrM(Tag:Matter),NxtTag:PtrM(Tag:Matter))

         IF ~MAT:RecordId THEN BREAK.

         IF Access:Matter.Fetch(MAT:PrimaryKey)
            Message('Error Reading Matter|Account :' & MAT:RecordId & '|' & Error(),'Check Payment VAT',ICON:Exclamation)
            CYCLE
         END

         LOC:ReportProgressWindowString = 'Generating the Debtors Report for ' & MAT:FileRef; DISPLAY

         SetColDebitTotals(MAT:RecordID)

         IF RECORDS(CDQ:ColDebitQueue)

            DO PopulateQueue:Browse

            DO PrintTheReport

         END

         END

         !GLO:SendingMultipleEmailsFlag = 0

         ! GET ORIGINAL MATTER BACK IN MEMORY

         MAT:RecordID = SAV:MatterID

         IF Access:Matter.Fetch(MAT:PrimaryKey)
            Message('Error Reading Matter|Record ID :' & MAT:RecordId & '|' & Error(),'After Printing Debtors Report',ICON:Exclamation)
            Exit
         END

         CLOSE(ReportProgressWindow)
         SETCURSOR

         IF LOC:ReportEmailFlag
            MESSAGE('Finished sending the Debtors Reports for ' & CLIP(LEFT(FORMAT(LOC:TaggedMatters,@n_5))) & ' Matters.','Completed',ICON:Exclamation)
         END

         DO ResetTheBrowseQueue

      ELSE

      DO PrintTheReport

      CLOSE(ReportProgressWindow)
      SETCURSOR


      END


      IF RECORDS(GEQ:ErrorQueue) AND LOC:TaggedMatters AND LOC:ReportEmailFlag
         BrowseMessageSendingErrors('Emails were NOT sent for the following reasons')
      END



      FREE(GEMQ:EmailQueue)
      CLEAR(GAQ:GlobalAttachmentQueue)
      FREE(GAQ:GlobalAttachmentQueue)

      FREE(GEQ:ErrorQueue)
      CLEAR(GEQ:ErrorQueue)




PrintTheReport     ROUTINE


      CLEAR(MP:Record)
      MP:MatterID = MAT:RecordID
      MP:RoleID = CTL:DefendantRoleID
      SET(MP:MatterRoleKey,MP:MatterRoleKey)
      IF Access:MatParty.Next()
         MESSAGE('Unable to locate the Defendant for this Matter.||' & ERROR(),MAT:FileRef,ICON:Exclamation)
         EXIT

      ELSE

         IF MP:MatterID <> MAT:RecordID OR MP:RoleID <> CTL:DefendantRoleID

            IF LOC:TaggedMatters AND LOC:ReportEmailFlag

               CLEAR(GEQ:ErrorQueue)
               GEQ:PartyID = MP:PartyID
               GEQ:MatterID = MAT:RecordID
               GEQ:Message1 = MAT:FileRef
               GEQ:Message2 = MAT:Description
               GEQ:Message3 = 'This Matter has no Defendant'
               ADD(GEQ:ErrorQueue,GEQ:Message1)

            ELSE

               MESSAGE('Unable to locate the Defendant for this Matter.',MAT:FileRef & ' - ' & MAT:Description,ICON:Exclamation)

            END

            EXIT

         END


      END


      LOC:DebtorName = GetDescription('PARTY NAME',MP:PartyID)


      IF LOC:ReportEmailFlag

         LOC:EmailRecipient = GetDescription('PARTY EMAIL',MP:PartyID)

         IF ~LOC:EmailRecipient

            IF LOC:TaggedMatters

               CLEAR(GEQ:ErrorQueue)
               GEQ:PartyID = MP:PartyID
               GEQ:MatterID = MAT:RecordID
               GEQ:Message1 = MAT:FileRef
               GEQ:Message2 = MAT:Description
               GEQ:Message3 = 'The Defendant (' & LOC:DebtorName & ') has no email address'
               ADD(GEQ:ErrorQueue,GEQ:Message1)

            ELSE

               MESSAGE('The Defendant (' & LOC:DebtorName & ') does not have an email address.',LOC:DebtorName,ICON:Exclamation)

            END

            EXIT

      END

      END



      LOC:SavedName = CLIP(GetRoot(GLO:MergedDocumentLocation)) & CLIP(LEFT(FORMAT(TODAY(),@d12))) & ' ' & CLIP(LEFT(FORMAT(CLOCK(),@t5))) & ' ' & CLIP(StripCharacters(LOC:DebtorName)) &  ' - Debtor Account'


      LOC:TotalColumns = 4 + RE:Check1 + RE:Check2  + RE:Check3 + RE:Check4 + RE:Check5 + RE:Check6
      LOC:TotalRows = RECORDS(Queue:Browse)

      LOC:LastDate = MAT:InterestFrom


      IF GLO:ReportDestination = 'X'
         GLO:FileName = LOC:SavedName !pk here
         LOC:ReportProgressWindowString = 'Loading Excel'; DISPLAY
         DO PrintAccountInExcel

      ELSE

      LOC:ReportProgressWindowString = 'Loading Word'; DISPLAY
      DO PrintAccountInWord

      END

      CLEAR(DOL:Record)
      DOL:MatterID = MAT:RecordID
      DOL:Description = 'Debtor''s Account'
      DOL:EmployeeID = GLO:EmployeeID
      DOL:Date = GLO:TodaysDate
      DOL:Time = CLOCK()

      !PK & RJ FB#2262

      IF GLO:ReportDestination = 'X'
      DOL:SavedName = SetRoot(LOC:SavedName & '.XLS',1)
      ELSE
      DOL:SavedName = SetRoot(LOC:SavedName,1)
      END

      
      Access:DocLog.Insert


      IF LOC:ReportEmailFlag

         FREE(GEMQ:EmailQueue)
         CLEAR(GAQ:GlobalAttachmentQueue)
         FREE(GAQ:GlobalAttachmentQueue)

         GAQ:FileName = LOC:SavedName
         ADD(GAQ:GlobalAttachmentQueue)


         LOC:EmailSubject = DOL:Description & ' (' & MAT:FileRef & ' - '  & MAT:Description & ')'


         LOC:ReportProgressWindowString = 'Sending email to ' & LOC:DebtorName; DISPLAY

         !IF LOC:TaggedMatters

            SendAndLogEmail(MAT:RecordID,MP:PartyID,LOC:EmailRecipient,LOC:EmailSubject,'')

         !ELSE

         !   SendEmailMessage(DOL:MatterID,MP:PartyID,0,LOC:EmailRecipient,LOC:EmailSubject,'')

         !END


      ELSE

         SHELL:AssocFile = LOC:SavedName
         SHELL:Param = ''
         SHELL:Directory = ''
         SHELL:Operation = 'open'
         ShellExecute(GetDesktopWindow(),SHELL:Operation,SHELL:AssocFile,SHELL:Param,SHELL:Directory,1)

   END


   FREE(ACQ:AlertColumnQueue)
   CLEAR(ACQ:AlertColumnQueue)
ResetTheBrowseQueue     ROUTINE

   SetColDebitTotals(MAT:RecordID)

   DO PopulateQueue:Browse

   IF COL:NewInDuplumRuleFlag   ! THE TOTAL COSTS ARE USED IN THE NEW IN DUPLUM RULE SO SHOW THESE TO THE USER

      LOC:DisplayCostAmount = MAT:DebtorsTotalCosts + MAT:DebtorsTotalCommission
      ?LOC:DisplayCostAmount:Prompt{PROP:Text} = 'Total Costs'
      ?LOC:DisplayCostAmount{PROP:Tooltip} = 'The Total Costs (incl Commission)<13>MAT:DebtorsTotalCosts + MAT:DebtorsTotalCommission'

      LOC:DisplayInterestAmount = MAT:DebtorsTotalInterest
      ?LOC:DisplayInterestAmount:Prompt{PROP:Text} = 'Total Interest'
      ?LOC:DisplayInterestAmount:Prompt{PROP:Tooltip} = 'The Total Interest<13>MAT:DebtorsTotalInterest'

   ELSE

      LOC:DisplayCostAmount = MAT:DebtorsCostsBalance
      ?LOC:DisplayCostAmount:Prompt{PROP:Text} = 'Cost Balance'
      ?LOC:DisplayCostAmount{PROP:Tooltip} = 'The Outstanding costs to be paid by the debtor before the capital balance can be reduced<13>MAT:DebtorsCostsBalance'


      LOC:DisplayInterestAmount = MAT:DebtorsInterestBalance
      ?LOC:DisplayInterestAmount:Prompt{PROP:Text} = 'Interest Balance'
      ?LOC:DisplayInterestAmount:Prompt{PROP:Tooltip} = 'The Outstanding Interest to be paid by the debtor before the capital balance can be reduced<13>MAT:DebtorsInterestBalance'

   END

   DISPLAY
   SELECT(?List:2, CHOICE(?List:2))



PopulateQueue:Browse       ROUTINE


   CLEAR(Queue:Browse)
   FREE(Queue:Browse)
   LOOP Y# = 1 TO RECORDS(CDQ:ColDebitQueue)

         GET(CDQ:ColDebitQueue,Y#)
         IF ERRORCODE() THEN BREAK.
         CLEAR(Queue:Browse)

         Queue:Browse.CD:Date                = CDQ:Date
         Queue:Browse.CD:Description         = CDQ:Description


         LOC:DisplayAmount = FORMAT(CDQ:Amount + CDQ:VatAmount,@N-15.2)
         IF CDQ:Type = 'P' OR CDQ:Type = 'V'   ! PAYMENT OR EMPLOYER'S COMMISSION
            LOC:DisplayAmount = FORMAT(-CDQ:Amount,@N-15.2)
         END

         LOC:TranType = GetCDTranType(CDQ:TranType,CDQ:Type,CDQ:Category)

         Queue:Browse.LOC:TranType           = LOC:TranType
         Queue:Browse.LOC:DisplayAmount      = LOC:DisplayAmount
         Queue:Browse.CD:Balance             = CDQ:Balance
         Queue:Browse.CD:DocumentCode        = CDQ:DocumentCode
         Queue:Browse.CD:CostBalance         = CDQ:CostBalance
         Queue:Browse.CD:InterestBalance     = CDQ:InterestBalance
         Queue:Browse.CD:CapitalBalance      = CDQ:CapitalBalance
         Queue:Browse.CD:Amount              = CDQ:Amount
         Queue:Browse.CD:VatAmount           = CDQ:VatAmount
         Queue:Browse.CD:VATFlag             = CDQ:VATFlag
         Queue:Browse.CD:RecordID            = CDQ:RecordID
         Queue:Browse.CD:MatterID            = CDQ:MatterID
         Queue:Browse.CD:Type                = CDQ:Type
         Queue:Browse.CD:CollCommFlag        = CDQ:CollCommFlag
         Queue:Browse.CD:Category            = CDQ:Category
         Queue:Browse.CD:TimerStamp          = CDQ:TimerStamp
         Queue:Browse.Mark                   = 0
         Queue:Browse.ViewPosition           = ''

         DO SetRowColours

         ADD(Queue:Browse,Queue:Browse.CD:Date,Queue:Browse.CD:TimerStamp)

   END


SetRowColours    ROUTINE


   Tag = CHOOSE(~GetTag:PtrM(TAG:ColCost, Queue:Browse.CD:RecordID), '', '*')
   Queue:Browse.Tag = Tag

   IF Tag
   Queue:Browse.Tag_Icon = 2
   ELSE
   Queue:Browse.Tag_Icon = 1
   END

   If Queue:Browse.CD:Category = 'J'
      Queue:Browse.Tag_NormalFG   = COLOR:Navy
      Queue:Browse.Tag_NormalBG   = COLOR:None
      Queue:Browse.Tag_SelectedFG = COLOR:None
      Queue:Browse.Tag_SelectedBG = COLOR:Navy
      Queue:Browse.CD:Date_NormalFG   = COLOR:Navy
      Queue:Browse.CD:Date_NormalBG   = COLOR:None
      Queue:Browse.CD:Date_SelectedFG = COLOR:None
      Queue:Browse.CD:Date_SelectedBG = COLOR:Navy
      Queue:Browse.CD:Description_NormalFG   = COLOR:Navy
      Queue:Browse.CD:Description_NormalBG   = COLOR:None
      Queue:Browse.CD:Description_SelectedFG = COLOR:None
      Queue:Browse.CD:Description_SelectedBG = COLOR:Navy
      Queue:Browse.LOC:TranType_NormalFG   = COLOR:Navy
      Queue:Browse.LOC:TranType_NormalBG   = COLOR:None
      Queue:Browse.LOC:TranType_SelectedFG = COLOR:None
      Queue:Browse.LOC:TranType_SelectedBG = COLOR:Navy
      Queue:Browse.LOC:DisplayAmount_NormalFG   = COLOR:Navy
      Queue:Browse.LOC:DisplayAmount_NormalBG   = COLOR:None
      Queue:Browse.LOC:DisplayAmount_SelectedFG = COLOR:None
      Queue:Browse.LOC:DisplayAmount_SelectedBG = COLOR:Navy
      Queue:Browse.CD:Balance_NormalFG   = COLOR:Navy
      Queue:Browse.CD:Balance_NormalBG   = COLOR:None
      Queue:Browse.CD:Balance_SelectedFG = COLOR:None
      Queue:Browse.CD:Balance_SelectedBG = COLOR:Navy
      Queue:Browse.CD:DocumentCode_NormalFG   = COLOR:Navy
      Queue:Browse.CD:DocumentCode_NormalBG   = COLOR:None
      Queue:Browse.CD:DocumentCode_SelectedFG = COLOR:None
      Queue:Browse.CD:DocumentCode_SelectedBG = COLOR:Navy
      Queue:Browse.CD:CostBalance_NormalFG   = COLOR:Navy
      Queue:Browse.CD:CostBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:CostBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:CostBalance_SelectedBG = COLOR:Navy
      Queue:Browse.CD:InterestBalance_NormalFG   = COLOR:Navy
      Queue:Browse.CD:InterestBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:InterestBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:InterestBalance_SelectedBG = COLOR:Navy
      Queue:Browse.CD:CapitalBalance_NormalFG   = COLOR:Navy
      Queue:Browse.CD:CapitalBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:CapitalBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:CapitalBalance_SelectedBG = COLOR:Navy
   ELSIF CDQ:Description[1] = '#' OR CDQ:Description[1] = '*'
      Queue:Browse.Tag_NormalFG   = COLOR:Olive
      Queue:Browse.Tag_NormalBG   = COLOR:None
      Queue:Browse.Tag_SelectedFG = COLOR:None
      Queue:Browse.Tag_SelectedBG = COLOR:Olive
      Queue:Browse.CD:Date_NormalFG   = COLOR:Olive
      Queue:Browse.CD:Date_NormalBG   = COLOR:None
      Queue:Browse.CD:Date_SelectedFG = COLOR:None
      Queue:Browse.CD:Date_SelectedBG = COLOR:Olive
      Queue:Browse.CD:Description_NormalFG   = COLOR:Olive
      Queue:Browse.CD:Description_NormalBG   = COLOR:None
      Queue:Browse.CD:Description_SelectedFG = COLOR:None
      Queue:Browse.CD:Description_SelectedBG = COLOR:Olive
      Queue:Browse.LOC:TranType_NormalFG   = COLOR:Olive
      Queue:Browse.LOC:TranType_NormalBG   = COLOR:None
      Queue:Browse.LOC:TranType_SelectedFG = COLOR:None
      Queue:Browse.LOC:TranType_SelectedBG = COLOR:Olive
      Queue:Browse.LOC:DisplayAmount_NormalFG   = COLOR:Olive
      Queue:Browse.LOC:DisplayAmount_NormalBG   = COLOR:None
      Queue:Browse.LOC:DisplayAmount_SelectedFG = COLOR:None
      Queue:Browse.LOC:DisplayAmount_SelectedBG = COLOR:Olive
      Queue:Browse.CD:Balance_NormalFG   = COLOR:Olive
      Queue:Browse.CD:Balance_NormalBG   = COLOR:None
      Queue:Browse.CD:Balance_SelectedFG = COLOR:None
      Queue:Browse.CD:Balance_SelectedBG = COLOR:Olive
      Queue:Browse.CD:DocumentCode_NormalFG   = COLOR:Olive
      Queue:Browse.CD:DocumentCode_NormalBG   = COLOR:None
      Queue:Browse.CD:DocumentCode_SelectedFG = COLOR:None
      Queue:Browse.CD:DocumentCode_SelectedBG = COLOR:Olive
      Queue:Browse.CD:CostBalance_NormalFG   = COLOR:Olive
      Queue:Browse.CD:CostBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:CostBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:CostBalance_SelectedBG = COLOR:Olive
      Queue:Browse.CD:InterestBalance_NormalFG   = COLOR:Olive
      Queue:Browse.CD:InterestBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:InterestBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:InterestBalance_SelectedBG = COLOR:Olive
      Queue:Browse.CD:CapitalBalance_NormalFG   = COLOR:Olive
      Queue:Browse.CD:CapitalBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:CapitalBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:CapitalBalance_SelectedBG = COLOR:Olive
   ELSIF Queue:Browse.CD:Type = 'P' OR Queue:Browse.CD:Type = 'V'   ! COLLECTION COMMISSION OR EMPLOYER'S COMMISSION
      Queue:Browse.Tag_NormalFG   = COLOR:Red
      Queue:Browse.Tag_NormalBG   = COLOR:None
      Queue:Browse.Tag_SelectedFG = COLOR:None
      Queue:Browse.Tag_SelectedBG = COLOR:Red
      Queue:Browse.CD:Date_NormalFG   = COLOR:Red
      Queue:Browse.CD:Date_NormalBG   = COLOR:None
      Queue:Browse.CD:Date_SelectedFG = COLOR:None
      Queue:Browse.CD:Date_SelectedBG = COLOR:Red
      Queue:Browse.CD:Description_NormalFG   = COLOR:Red
      Queue:Browse.CD:Description_NormalBG   = COLOR:None
      Queue:Browse.CD:Description_SelectedFG = COLOR:None
      Queue:Browse.CD:Description_SelectedBG = COLOR:Red
      Queue:Browse.LOC:TranType_NormalFG   = COLOR:Red
      Queue:Browse.LOC:TranType_NormalBG   = COLOR:None
      Queue:Browse.LOC:TranType_SelectedFG = COLOR:None
      Queue:Browse.LOC:TranType_SelectedBG = COLOR:Red
      Queue:Browse.LOC:DisplayAmount_NormalFG   = COLOR:Red
      Queue:Browse.LOC:DisplayAmount_NormalBG   = COLOR:None
      Queue:Browse.LOC:DisplayAmount_SelectedFG = COLOR:None
      Queue:Browse.LOC:DisplayAmount_SelectedBG = COLOR:Red
      Queue:Browse.CD:Balance_NormalFG   = COLOR:Red
      Queue:Browse.CD:Balance_NormalBG   = COLOR:None
      Queue:Browse.CD:Balance_SelectedFG = COLOR:None
      Queue:Browse.CD:Balance_SelectedBG = COLOR:Red
      Queue:Browse.CD:DocumentCode_NormalFG   = COLOR:Red
      Queue:Browse.CD:DocumentCode_NormalBG   = COLOR:None
      Queue:Browse.CD:DocumentCode_SelectedFG = COLOR:None
      Queue:Browse.CD:DocumentCode_SelectedBG = COLOR:Red
      Queue:Browse.CD:CostBalance_NormalFG   = COLOR:Red
      Queue:Browse.CD:CostBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:CostBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:CostBalance_SelectedBG = COLOR:Red
      Queue:Browse.CD:InterestBalance_NormalFG   = COLOR:Red
      Queue:Browse.CD:InterestBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:InterestBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:InterestBalance_SelectedBG = COLOR:Red
      Queue:Browse.CD:CapitalBalance_NormalFG   = COLOR:Red
      Queue:Browse.CD:CapitalBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:CapitalBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:CapitalBalance_SelectedBG = COLOR:Red
   ELSIF Queue:Browse.CD:Type = 'J' OR Queue:Browse.CD:Type = 'I' OR Queue:Browse.CD:Type = 'Y'
      Queue:Browse.Tag_NormalFG   = COLOR:Green
      Queue:Browse.Tag_NormalBG   = COLOR:None
      Queue:Browse.Tag_SelectedFG = COLOR:None
      Queue:Browse.Tag_SelectedBG = COLOR:Green
      Queue:Browse.CD:Date_NormalFG   = COLOR:Green
      Queue:Browse.CD:Date_NormalBG   = COLOR:None
      Queue:Browse.CD:Date_SelectedFG = COLOR:None
      Queue:Browse.CD:Date_SelectedBG = COLOR:Green
      Queue:Browse.CD:Description_NormalFG   = COLOR:Green
      Queue:Browse.CD:Description_NormalBG   = COLOR:None
      Queue:Browse.CD:Description_SelectedFG = COLOR:None
      Queue:Browse.CD:Description_SelectedBG = COLOR:Green
      Queue:Browse.LOC:TranType_NormalFG   = COLOR:Green
      Queue:Browse.LOC:TranType_NormalBG   = COLOR:None
      Queue:Browse.LOC:TranType_SelectedFG = COLOR:None
      Queue:Browse.LOC:TranType_SelectedBG = COLOR:Green
      Queue:Browse.LOC:DisplayAmount_NormalFG   = COLOR:Green
      Queue:Browse.LOC:DisplayAmount_NormalBG   = COLOR:None
      Queue:Browse.LOC:DisplayAmount_SelectedFG = COLOR:None
      Queue:Browse.LOC:DisplayAmount_SelectedBG = COLOR:Green
      Queue:Browse.CD:Balance_NormalFG   = COLOR:Green
      Queue:Browse.CD:Balance_NormalBG   = COLOR:None
      Queue:Browse.CD:Balance_SelectedFG = COLOR:None
      Queue:Browse.CD:Balance_SelectedBG = COLOR:Green
      Queue:Browse.CD:DocumentCode_NormalFG   = COLOR:Green
      Queue:Browse.CD:DocumentCode_NormalBG   = COLOR:None
      Queue:Browse.CD:DocumentCode_SelectedFG = COLOR:None
      Queue:Browse.CD:DocumentCode_SelectedBG = COLOR:Green
      Queue:Browse.CD:CostBalance_NormalFG   = COLOR:Green
      Queue:Browse.CD:CostBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:CostBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:CostBalance_SelectedBG = COLOR:Green
      Queue:Browse.CD:InterestBalance_NormalFG   = COLOR:Green
      Queue:Browse.CD:InterestBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:InterestBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:InterestBalance_SelectedBG = COLOR:Green
      Queue:Browse.CD:CapitalBalance_NormalFG   = COLOR:Green
      Queue:Browse.CD:CapitalBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:CapitalBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:CapitalBalance_SelectedBG = COLOR:Green
   ELSIF Queue:Browse.CD:Type = 'X'
      Queue:Browse.Tag_NormalFG   = COLOR:Purple
      Queue:Browse.Tag_NormalBG   = COLOR:None
      Queue:Browse.Tag_SelectedFG = COLOR:None
      Queue:Browse.Tag_SelectedBG = COLOR:Purple
      Queue:Browse.CD:Date_NormalFG   = COLOR:Purple
      Queue:Browse.CD:Date_NormalBG   = COLOR:None
      Queue:Browse.CD:Date_SelectedFG = COLOR:None
      Queue:Browse.CD:Date_SelectedBG = COLOR:Purple
      Queue:Browse.CD:Description_NormalFG   = COLOR:Purple
      Queue:Browse.CD:Description_NormalBG   = COLOR:None
      Queue:Browse.CD:Description_SelectedFG = COLOR:None
      Queue:Browse.CD:Description_SelectedBG = COLOR:Purple
      Queue:Browse.LOC:TranType_NormalFG   = COLOR:Purple
      Queue:Browse.LOC:TranType_NormalBG   = COLOR:None
      Queue:Browse.LOC:TranType_SelectedFG = COLOR:None
      Queue:Browse.LOC:TranType_SelectedBG = COLOR:Purple
      Queue:Browse.LOC:DisplayAmount_NormalFG   = COLOR:Purple
      Queue:Browse.LOC:DisplayAmount_NormalBG   = COLOR:None
      Queue:Browse.LOC:DisplayAmount_SelectedFG = COLOR:None
      Queue:Browse.LOC:DisplayAmount_SelectedBG = COLOR:Purple
      Queue:Browse.CD:Balance_NormalFG   = COLOR:Purple
      Queue:Browse.CD:Balance_NormalBG   = COLOR:None
      Queue:Browse.CD:Balance_SelectedFG = COLOR:None
      Queue:Browse.CD:Balance_SelectedBG = COLOR:Purple
      Queue:Browse.CD:DocumentCode_NormalFG   = COLOR:Purple
      Queue:Browse.CD:DocumentCode_NormalBG   = COLOR:None
      Queue:Browse.CD:DocumentCode_SelectedFG = COLOR:None
      Queue:Browse.CD:DocumentCode_SelectedBG = COLOR:Purple
      Queue:Browse.CD:CostBalance_NormalFG   = COLOR:Purple
      Queue:Browse.CD:CostBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:CostBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:CostBalance_SelectedBG = COLOR:Purple
      Queue:Browse.CD:InterestBalance_NormalFG   = COLOR:Purple
      Queue:Browse.CD:InterestBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:InterestBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:InterestBalance_SelectedBG = COLOR:Purple
      Queue:Browse.CD:CapitalBalance_NormalFG   = COLOR:Purple
      Queue:Browse.CD:CapitalBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:CapitalBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:CapitalBalance_SelectedBG = COLOR:Purple
   ELSE
      Queue:Browse.Tag_NormalFG   = COLOR:None
      Queue:Browse.Tag_NormalBG   = COLOR:None
      Queue:Browse.Tag_SelectedFG = COLOR:None
      Queue:Browse.Tag_SelectedBG = COLOR:None
      Queue:Browse.CD:Date_NormalFG   = COLOR:None
      Queue:Browse.CD:Date_NormalBG   = COLOR:None
      Queue:Browse.CD:Date_SelectedFG = COLOR:None
      Queue:Browse.CD:Date_SelectedBG = COLOR:None
      Queue:Browse.CD:Description_NormalFG   = COLOR:None
      Queue:Browse.CD:Description_NormalBG   = COLOR:None
      Queue:Browse.CD:Description_SelectedFG = COLOR:None
      Queue:Browse.CD:Description_SelectedBG = COLOR:None
      Queue:Browse.LOC:TranType_NormalFG   = COLOR:None
      Queue:Browse.LOC:TranType_NormalBG   = COLOR:None
      Queue:Browse.LOC:TranType_SelectedFG = COLOR:None
      Queue:Browse.LOC:TranType_SelectedBG = COLOR:None
      Queue:Browse.LOC:DisplayAmount_NormalFG   = COLOR:None
      Queue:Browse.LOC:DisplayAmount_NormalBG   = COLOR:None
      Queue:Browse.LOC:DisplayAmount_SelectedFG = COLOR:None
      Queue:Browse.LOC:DisplayAmount_SelectedBG = COLOR:None
      Queue:Browse.CD:Balance_NormalFG   = COLOR:None
      Queue:Browse.CD:Balance_NormalBG   = COLOR:None
      Queue:Browse.CD:Balance_SelectedFG = COLOR:None
      Queue:Browse.CD:Balance_SelectedBG = COLOR:None
      Queue:Browse.CD:DocumentCode_NormalFG   = COLOR:None
      Queue:Browse.CD:DocumentCode_NormalBG   = COLOR:None
      Queue:Browse.CD:DocumentCode_SelectedFG = COLOR:None
      Queue:Browse.CD:DocumentCode_SelectedBG = COLOR:None
      Queue:Browse.CD:CostBalance_NormalFG   = COLOR:None
      Queue:Browse.CD:CostBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:CostBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:CostBalance_SelectedBG = COLOR:None
      Queue:Browse.CD:InterestBalance_NormalFG   = COLOR:None
      Queue:Browse.CD:InterestBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:InterestBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:InterestBalance_SelectedBG = COLOR:None
      Queue:Browse.CD:CapitalBalance_NormalFG   = COLOR:None
      Queue:Browse.CD:CapitalBalance_NormalBG   = COLOR:None
      Queue:Browse.CD:CapitalBalance_SelectedFG = COLOR:None
      Queue:Browse.CD:CapitalBalance_SelectedBG = COLOR:None
   End

DisplayInterestSettings     ROUTINE

   LOC:InterestSettings = ''

   IF (MAT:InterestFrom AND MAT:InterestRate) OR MAT:IntRateScheduleID
      IF MAT:InterestCompoundedFlag
         LOC:InterestSettings = 'Compounded Interest'
      ELSE
         LOC:InterestSettings = 'Normal Interest'
      END
      IF MAT:IntRateScheduleID
         IRS:RecordID = MAT:IntRateScheduleID
         IF ~Access:IntRateSchedule.Fetch(IRS:PrimaryKey)

               IF COL:IntRateScheduleVariance

                  IF COL:IntRateScheduleVariance > 0

                     LOC:InterestSettings = CLIP(LOC:InterestSettings) & ' [' & IRS:Description & ' +' & CLIP(LEFT(FORMAT(COL:IntRateScheduleVariance,@N_9.4))) & '%]'
                  ELSE
                     LOC:InterestSettings = CLIP(LOC:InterestSettings) & ' [' & IRS:Description & ' -' & CLIP(LEFT(FORMAT(COL:IntRateScheduleVariance,@N_9.4))) & '%]'
                  END

               ELSE

                  LOC:InterestSettings = CLIP(LOC:InterestSettings) & ' [' & IRS:Description & ']'

               END

         ELSE
               LOC:InterestSettings = CLIP(LOC:InterestSettings) & ' Error accessing interest rate schedule.'
         END
      ELSE
         LOC:InterestSettings = CLIP(LOC:InterestSettings) & ' fixed @ ' & CLIP(LEFT(FORMAT(MAT:InterestRate,@n_9.4~%~)))
      END
      IF MAT:InterestOnCostsFlag
         LOC:InterestSettings = CLIP(LOC:InterestSettings) & ' (On Costs)'
      END


      If MAT:InterestFrom
         LOC:InterestSettings = CLIP(LOC:InterestSettings) & ' from ' & CLIP(LEFT(FORMAT(MAT:InterestFrom,@d17)))
         If MAT:InterestEndDate
            LOC:InterestSettings = CLIP(LOC:InterestSettings) & ' up until ' & CLIP(LEFT(FORMAT(MAT:InterestEndDate,@d17)))
         END
      END

      IF COL:InterestEndAmount
         LOC:InterestSettings = CLIP(LOC:InterestSettings) & ' (Maximum: '& GLO:CurrencySymbol & CLIP(LEFT(FORMAT(COL:InterestEndAmount,@n13.2))) & ')'
      END


   ELSE
      LOC:InterestSettings = 'No Interest'
   END


   IF COL:NewInDuplumRuleFlag
      LOC:InterestSettings = LOC:InterestSettings & ' - calculated ito Section 103 of the National Credit Act No. 34 of 2005'
   END


   EXECUTE COL:ReduceCapitalFlag+1
      LOC:CapitalReductionSettings = 'Reduce the Costs, then Interest and then Capital'
      LOC:CapitalReductionSettings = 'Reduce the Capital, then Costs and then Interest'
      LOC:CapitalReductionSettings = 'Reduce the Interest, then Costs and then Capital'
      LOC:CapitalReductionSettings = 'Reduce the Capital, then Interest and then Costs'
      LOC:CapitalReductionSettings = 'Reduce the Interest, then Capital and then Costs'
   END


   IF COL:ReceiptPercentToCostsFlag
      LOC:CapitalReductionSettings = LOC:CapitalReductionSettings & ' (Percent to costs: ' & CLIP(LEFT(FORMAT(MAT:ReceiptPercentToCosts,@N_6.2))) & '%'
      IF MAT:ReceiptPercentToDate
         LOC:CapitalReductionSettings = LOC:CapitalReductionSettings & ' until ' &  CLIP(LEFT(FORMAT(MAT:ReceiptPercentToDate,@d17))) & ')'
      ELSE
         LOC:CapitalReductionSettings = LOC:CapitalReductionSettings & ')'
      END
   END


   
BRW1::TagOne ROUTINE

SetTag:PtrM(TAG:ColCost, CD:RecordID)
Tag = '*'
DO BRW1::AfterSingleTag


BRW1::WipeTags ROUTINE
NewTag:PtrM(TAG:ColCost)


BRW1::UntagOne ROUTINE

ClrTag:PtrM(TAG:ColCost, CD:RecordID)
CLEAR(Tag)
DO BRW1::AfterSingleTag



BRW1::FlipOne ROUTINE
RvsTag:PtrM(TAG:ColCost, CD:RecordID)

IF Queue:Browse.Tag
   CLEAR(Tag)
ELSE
   Tag = '*'
END!IF
DO BRW1::AfterSingleTag


BRW1::AfterSingleTag ROUTINE
IF Tag
   Queue:Browse.Tag_Icon = 2
ELSE
   Queue:Browse.Tag_Icon = 1
END!IF
Queue:Browse.Tag = Tag
PUT(Queue:Browse)
ASSERT(~ERRORCODE())
SELECT(?List:2,CHOICE(?List:2))

BRW1::MouseLeftFlipTag ROUTINE

IF  KEYCODE() = MouseLeft AND ?List:2{PROP:Visible}  |
AND INRANGE(MOUSEX(), ?List:2{PROP:XPos}, ?List:2{PROP:XPos} + ?List:2{PROP:Width} - 1)  |
AND INRANGE(MOUSEY(), ?List:2{PROP:YPos}, ?List:2{PROP:YPos} + ?List:2{PROP:Height}  |
                                    - CHOOSE(?List:2{PROP:HScroll} OR ?List:2{PROP:VCR},9,1))  |
AND ?List:2{PROPLIST:MouseDownRow} > 0 AND ?List:2{PROPLIST:MouseDownZone} <> LISTZONE:Right  |
AND ?List:2{PROPLIST:MouseDownField} = 1

GET(Queue:Browse,Choice(?List:2))

!    message('Choice(?List:2)) = ' & Choice(?List:2) &|
!            '|Queue:Browse.CD:RecordID = ' & Queue:Browse.CD:RecordID &|
!            '|Queue:Browse.CD:TYPE = ' & Queue:Browse.cd:type)

   CD:RecordID = Queue:Browse.CD:RecordID
   IF Queue:Browse.CD:TYPE = 'D' OR Queue:Browse.CD:TYPE = 'P' OR Queue:Browse.CD:TYPE = 'J'  OR Queue:Browse.CD:Type = 'W' !FB 905
      BRW1.UpdateViewRecord
      DO BRW1::FlipOne
   END
END


BRW1::TagAll ROUTINE

LOOP X# = 1 TO RECORDS(Queue:Browse)
      GET(Queue:Browse,X#)
      IF ERROR() THEN BREAK.
      IF Queue:Browse.CD:Type = 'D' OR Queue:Browse.CD:Type = 'P' OR Queue:Browse.CD:Type = 'J' OR Queue:Browse.CD:Type = 'W' !FB 905
         SetTag:PtrM(TAG:ColCost, Queue:Browse.CD:RecordID)
         Queue:Browse.Tag_Icon = 2
         Queue:Browse.Tag = '*'
         PUT(Queue:Browse)
      END
END
SELECT(?List:2,CHOICE(?List:2))

BRW1::UnTagAll ROUTINE

LOOP X# = 1 TO RECORDS(Queue:Browse)
      GET(Queue:Browse,X#)
      IF ERROR() THEN BREAK.
      IF Queue:Browse.CD:Type = 'D' OR Queue:Browse.CD:Type = 'P' OR Queue:Browse.CD:Type = 'J' OR Queue:Browse.CD:Type = 'W' !FB 905
         ClrTag:PtrM(TAG:ColCost, Queue:Browse.CD:RecordID)
         Queue:Browse.Tag_Icon = 1
         Queue:Browse.Tag = ''
         PUT(Queue:Browse)
      END
END
SELECT(?List:2,CHOICE(?List:2))

AddFeeNote              ROUTINE


CLEAR(FN:Record)
FN:MatterID = CD:MatterID
FN:Date = CD:Date
FN:EmployeeID = CD:EmployeeID
IF ~FN:EmployeeID THEN FN:EmployeeID = GLO:EmployeeID.
FN:Source = 'D'
RowCounter{PROP:SQL} = 'SELECT CostCentreId FROM Matter WHERE RecordID = ' & CD:MatterID
NEXT(RowCounter)
FN:CostCentreId = ROW:Counter

IF CD:Category = 'R'
   FN:VATIE = 'I'
   FN:VATRATE = 'N'
   FN:Type1 = 'D'
   FN:Code2 = CTL:RevenueStampId
ELSE
   FN:VATIE = 'E'
   FN:Type1 = 'F'
   FN:Code2 = GetIncomeAccount(FN:MatterID,FN:EmployeeID)
   IF MAT:VatExemptFlag = 1
      FN:VATRATE = 'E'
   ELSIF MAT:VatExemptFlag = 2
      FN:VATRATE = 'Z'
   ELSIF CTL:VatMethod = 'N' or ~CD:VATFlag
      FN:VATRATE = 'N'
   ELSE
      FN:VATRATE = '1'
   END
END
FN:Description = CD:Description
FN:NetAmount = CD:Amount
FN:Amount = CD:Amount

FN:Option1 = 1
IF Access:FeeNote.Insert()
   MESSAGE('Unable to add Fee Note from Debtor Transaction.||Error: ' & ERROR(),'Error adding Fee Note',ICON:Exclamation)
ELSE
   IF ~CntTag:PtrM(TAG:ColCost)
         MESSAGE('A Fee Note was successfully created from the Debtor Transaction.','Added Fee Note',ICON:Exclamation)
   END
END
ConvertMTTToCDOld         ROUTINE ! Create new ConvertMTTToCD to closer match the process used in accounting - Nick 13/11/2008

   IF MTT:TranType = 'F'|
   OR MTT:TranType = 'D'|
   OR MTT:TranType = 'P'|
   OR MTT:TranType = 'J'|
   OR MTT:TranType = 'R'
   ! BRING THROUGH FEES , DISBURSEMENTS, PAYMENTS, JOURNALS AND RECEIPTS ONLY
   ELSE
      EXIT
   END


   IF MTT:BookType = 'T' THEN EXIT.             ! THIS WILL EXCLUDE CONSOLIDATION JOURNAL ENTRIES

   IF MTT:BusTrust = 'B' OR MTT:BusTrust = 'T' OR MTT:BusTrust = 'V'
   ELSE
      EXIT
   END

   CLEAR(CD:Record)
   CD:BatchID = MTT:BatchID
   CD:TransID = MTT:TransID
   CD:LineID = MTT:LineID
   If Access:ColDebit.TryFetch(CD:BatchKey) <> Level:Notify Then EXIT.


   CD:MatterID = MAT:RecordID
   CD:EmployeeID = GLO:EmployeeID
   CD:Date = MTT:Date

   IF MTT:TranType = 'J'
      CD:Category = 'J'
      IF MTT:Amount < 0
         CD:Type = 'P'
      ELSE
         CD:Type = 'D'
      END
      CD:Reference = MTT:Voucher
      CD:VatAmount = 0
      CD:Amount = ABS(MTT:Amount) 
      CD:VATFlag = False
   ELSIF MTT:Amount < 0
      CD:Type = 'P'
      CD:Category = 'P'
      IF MTT:BookType = 'C'       ! THIS IS A RECEIPT FROM A CORRESPONDENT
         CD:CollCommFlag = False
      ELSE
         CD:CollCommFlag = True
         IF MAT:DebtorCollCommOption = 'N' Then CD:CollCommFlag = False.
      END
      CD:InterestRate = MAT:InterestRate
      CD:Category = 'P'
      CD:Reference = MTT:Voucher
      CD:VatAmount = 0
      CD:Amount = ABS(MTT:Amount) 
      CD:VATFlag = False
   ELSE
      CD:Type = 'D'
      CD:Category = 'C'
      CD:VatAmount = GetVatAmount(MTT:Amount,,MTT:VatRate,'I')
      CD:Amount = ABS(MTT:Amount) - CD:VatAmount

      IF CD:VatAmount THEN CD:VATFlag = True.
   END
   CD:Description = MTT:Description
   CD:BatchID = MTT:BatchID
   CD:TransID = MTT:TransID
   CD:LineID = MTT:LineID
   CD:Origin = 2

   Access:ColDebit.Insert


ConvertMTTToCD         ROUTINE
If ~Inlist(MTT:BusTrust,'B','T','V') Then Exit.
IF MTT:BookType = 'T' THEN EXIT.             ! THIS WILL EXCLUDE CONSOLIDATION JOURNAL ENTRIES
If MTT:TranType = 'R' Then Do AddDebtorPayment. ! and MTT:TranType1 = 'D' - Allow no debtor transactions
If MTT:TranType = 'P' Then Do AddDebtorDisbursement.
If MTT:TranType = 'D' Then Do AddDebtorDisbursement.
If MTT:TranType = 'F' Then Do AddDebtorFee.
If MTT:TranType = 'J' Then Do AddJournal.

!=============================================================================
AddDebtorPayment    Routine
Clear(RowCounter)
RowCounter{PROP:SQL} = 'Select Recordid from coldebit where batchid = ' & MTT:BatchId & ' and transid = ' & MTT:TransId & ' and lineid = ' & MTT:LineId
Next(RowCounter)
If ~ErrorCode() Then Exit. ! Record Already Exists
If ErrorCode() <> 33
   Message('Error Getting Debtor Transaction|Matter: ' & MAT:FileRef & '|Batch: ' & GetBatchDesc(MTT:BatchId,MTT:TransId,MTT:LineId) & '|Error: ' & SQLError(),'Add Debtor Transaction',ICON:Exclamation)
   Exit
.

Clear(CD:Record)
CD:BatchId            = MTT:BatchId
CD:TransId            = MTT:TransId
CD:LineId             = MTT:LineId
CD:MatterID           = MTT:MatterId
CD:ColCostID          = 0
CD:EmployeeID         = GLO:EmployeeId
CD:TimerStamp         = Clock()
CD:Date               = MTT:Date
CD:Type               = 'P'
CD:Description        = MTT:Description
CD:InterestRate       = 0
CD:Amount             = -MTT:Amount
CD:VATFlag            = False
CD:VatAmount          = 0
CD:CollCommFlag = True
IF MAT:DebtorCollCommOption = 'N' Then CD:CollCommFlag = False.
If MTT:BookType = 'C' Then CD:CollCommFlag = False. ! Don't add collcomm for CashCollected
CD:InterestFlag       = True
CD:Category           = 'P'
CD:Reference          = MTT:Voucher
CD:Origin             = 2 ! Imported From MatTran
If Access:ColDebit.Insert() Then Exit.

!  IF MAT:ColDebitFeeCodeID
!    NewTag:PtrM(Tag:FeeCode)
!    SetTag:PtrM(Tag:FeeCode,MAT:ColDebitFeeCodeID)
!    GLO:FeeNoteDate = CD:Date
!    IF AddColDebit().
!    GLO:FeeNoteDate = GLO:TodaysDate   ! RESET IT IN CASE USER DOES A MERGE NEXT
!  END


!=============================================================================
AddDebtorFee       Routine
Clear(RowCounter)
RowCounter{PROP:SQL} = 'Select Recordid from coldebit where batchid = ' & MTT:BatchId & ' and transid = ' & MTT:TransId & ' and lineid = ' & MTT:LineId
Next(RowCounter)
If ~ErrorCode() Then Exit. ! Record Already Exists
If ErrorCode() <> 33
   Message('Error Getting Debtor Transaction|Matter: ' & MAT:FileRef & '|Batch: ' & GetBatchDesc(MTT:BatchId,MTT:TransId,MTT:LineId) & '|Error: ' & SQLError(),'Add Debtor Transaction',ICON:Exclamation)
   Exit
.

Clear(CD:Record)
CD:BatchId            = MTT:BatchId
CD:TransId            = MTT:TransId
CD:LineId             = MTT:LineId
CD:MatterID           = MTT:MatterId
CD:ColCostID          = 0
CD:EmployeeID         = GLO:EmployeeId
CD:TimerStamp         = Clock()
CD:Date               = MTT:Date
CD:Type               = 'D'
CD:Description        = MTT:Description
CD:InterestRate       = MAT:InterestRate
CD:Amount             = GetVatExcl(MTT:Amount,MTT:VatPercent)
CD:VatAmount          = GetVatAmount(MTT:Amount,MTT:VatPercent)
If CD:VatAmount Then CD:VatFlag = True.
CD:CollCommFlag       = 0
CD:InterestFlag       = False
CD:Category           = 'C'
CD:Origin             = 3
If Access:ColDebit.Insert() THen Exit.

!=============================================================================
AddDebtorDisbursement       Routine
Clear(RowCounter)
RowCounter{PROP:SQL} = 'Select Recordid from coldebit where batchid = ' & MTT:BatchId & ' and transid = ' & MTT:TransId & ' and lineid = ' & MTT:LineId
Next(RowCounter)
If ~ErrorCode() Then Exit. ! Record Already Exists
If ErrorCode() <> 33
   Message('Error Getting Debtor Transaction|Matter: ' & MAT:FileRef & '|Batch: ' & GetBatchDesc(MTT:BatchId,MTT:TransId,MTT:LineId) & '|Error: ' & SQLError(),'Add Debtor Transaction',ICON:Exclamation)
   Exit
.

Clear(CD:Record)
CD:BatchId            = MTT:BatchId
CD:TransId            = MTT:TransId
CD:LineId             = MTT:LineId
CD:MatterID           = MTT:MatterId
CD:ColCostID          = 0
CD:EmployeeID         = GLO:EmployeeId
CD:TimerStamp         = Clock()
CD:Date               = MTT:Date
CD:Type               = 'D'
CD:Description        = MTT:Description ! & ' - ' & MTT:RefDesc
CD:InterestRate       = MAT:InterestRate
CD:Amount             = GetVatExcl(MTT:Amount,MTT:VatPercent)
CD:VatAmount          = GetVatAmount(MTT:Amount,MTT:VatPercent)
If CD:VatAmount Then CD:VatFlag = True.
CD:CollCommFlag       = 0
CD:InterestFlag       = False
CD:Category           = 'C'
If MTT:RefType = 'C' ! Creditor
   CRM:RecordId = MTT:RefId
   Access:Creditor.Fetch(CRM:PrimaryKey)
   If CRM:Type = 2 Then CD:Category = 'S'. ! Sheriff
   If CRM:Type = 3 Then CD:Category = 'T'. ! Tracing Agent
.
CD:Origin             = 2 ! Imported From MatTran
If Access:ColDebit.Insert() THen Exit.


!=============================================================================
AddJournal       Routine
Clear(RowCounter)
RowCounter{PROP:SQL} = 'Select Recordid from coldebit where batchid = ' & MTT:BatchId & ' and transid = ' & MTT:TransId & ' and lineid = ' & MTT:LineId
Next(RowCounter)
If ~ErrorCode() Then Exit. ! Record Already Exists
If ErrorCode() <> 33
   Message('Error Getting Debtor Transaction|Matter: ' & MAT:FileRef & '|Batch: ' & GetBatchDesc(MTT:BatchId,MTT:TransId,MTT:LineId) & '|Error: ' & SQLError(),'Add Debtor Transaction',ICON:Exclamation)
   Exit
.

Clear(CD:Record)
CD:BatchId            = MTT:BatchId
CD:TransId            = MTT:TransId
CD:LineId             = MTT:LineId
CD:MatterID           = MTT:MatterId
CD:EmployeeID         = GLO:EmployeeId
CD:TimerStamp         = Clock()
CD:Date               = MTT:Date
IF MTT:Amount < 0
   CD:Type = 'P'
ELSE
   CD:Type = 'D'
.
CD:Description        = MTT:Description & ' - ' & MTT:RefDesc
CD:Amount             = ABS(MTT:Amount)
CD:Category           = 'J'
CD:Reference          = MTT:Voucher
CD:Origin             = 2 ! Imported From MatTran
If Access:ColDebit.Insert() Then Exit.


CalculateSettlement  ROUTINE

LOC:SettleType = 'B'
IF LOC:SettleType = 'B'
   LOC:SettleAmount = MAT:DebtorsBalance + (MAT:DebtorsBalance * LOC:CollCommPerc / 100) * (1 + (LOC:VatRate/100))
ELSE
   LOC:SettleAmount = MAT:DebtorsBalance * (10000/(10000-(100*LOC:CollCommPerc)-(LOC:VatRate*LOC:CollCommPerc)))
END
LOC:CollCommLim = LOC:CollCommLimit * (1 + (LOC:VatRate / 100))
LOC:CollCommAct = LOC:SettleAmount - MAT:DebtorsBalance
IF LOC:CollCommAct > LOC:CollCommLim
   LOC:CollCommAct = LOC:CollCommLim
   LOC:SettleAmount = MAT:DebtorsBalance + LOC:CollCommLim
END
LOC:VAT = LOC:CollCommAct * LOC:VatRate / (100 + LOC:VatRate)
LOC:Costs = LOC:CollCommAct - LOC:VAT

If MAT:DebtorCollCommOption = 'I'
   LOC:SettleAmount -= LOC:VAT
   LOC:Costs = GetVatExcl(LOC:Costs,LOC:VatRate)
   LOC:VAT = LOC:Costs * LOC:VatRate / (100 + LOC:VatRate)
.




FileLookup11.Ask PROCEDURE(BYTE KeepDir=0)

ReturnValue          ANY



CODE

! Parent Call
ReturnValue = PARENT.Ask(KeepDir)

RETURN ReturnValue


FileLookup11.Ask PROCEDURE(SelectFileQueue FileQueue,BYTE KeepDir = 0)



CODE

! Parent Call
PARENT.Ask(FileQueue,KeepDir)



FileLookup11.Init PROCEDURE



CODE

! Parent Call
PARENT.Init


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

CODE
GlobalErrors.SetProcedureName('BrowseColDebit')
SELF.Request = GlobalRequest
ReturnValue = PARENT.Init()
IF ReturnValue THEN RETURN ReturnValue.
SELF.FirstField = ?Insert
SELF.VCRRequest &= VCRRequest
SELF.Errors &= GlobalErrors
SELF.AddItem(Toolbar)
CLEAR(GlobalRequest)
CLEAR(GlobalResponse)
Relate:BatHead.Open
Relate:BatTran.Open
Relate:ColDebit.Open
Relate:Color.Open
Relate:Creditor.Open
Relate:DocLog.Open
Relate:FeeNote.Open
Relate:IntRatePeriod.Open
Relate:IntRateSchedule.Open
Relate:MatParty.Open
Relate:Matter.Open
Relate:Report.Open
Relate:ReportEmp.Open
Relate:SecProc.Open
SELF.FilesOpened = True
SELF.FirstField = ?List:2
FREE(CDQ:ColDebitQueue)
CLEAR(CDQ:ColDebitQueue)

CLEAR(COL:Record)
COL:MatterID = MAT:RecordID
IF Access:ColData.Fetch(COL:MatterKey)      ! IF COULDN'T FIND THE RECORD
   COL:MatterID = MAT:RecordID
   Access:ColData.Insert
END


FLUSH(BRW1::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
!BUFFER(BRW1::View:Browse,30,2,5,300)
BRW1.Init(?List:2,Queue:Browse.ViewPosition,BRW1::View:Browse,Queue:Browse,Relate:ColDebit,SELF)
ColorText:4#          = GLO:ColorText
ColorBackground:4#    = GLO:ColorBackground
ColorSelText:4#       = GLO:ColorSelText
ColorSelBackground:4# = GLO:ColorSelBackground
ColorGrid:4#          = GLO:ColorGrid
OPEN(QuickWindow)
SELF.Opened=True
0{PROP:Text} = 'Debtor''s Account (' & MAT:FileRef & ' - ' & MAT:Description & ')'

GLO:DocumentCode = ''
DO DisplayInterestSettings

IF MAT:VatExemptFlag
   LOC:VatRate = 0
ELSIF CTL:VatMethod <> 'N'
   LOC:VatRate = CTL:VATPercent1
ELSE
   LOC:VatRate = 0
END

   CASE MAT:DebtorCollCommOption
      OF 'N' ! NONE
         LOC:CollCommPerc = 0
         LOC:CollCommLimit = 0
      OF 'U' ! DEFAULT
         LOC:CollCommPerc = CTL:CollCommPercent
         LOC:CollCommLimit = CTL:CollCommLimit
      OF 'S' ! SCHEDULE
         LOC:CollCommPerc = GetCollCommPercent(GLO:TodaysDate)
         LOC:CollCommLimit = GetCollCommLimit(GLO:TodaysDate)
      ELSE   ! CUSTOM
         LOC:CollCommPerc = MAT:DebtorCollCommPercent
         LOC:CollCommLimit = MAT:DebtorCollCommLimit
   END


SETCURSOR
BRW1.Popup.AddItemMimic('&Print',?PrintListButton)
BRW1.Popup.AddItemMimic('&Import from Ledger',?ImportLedgerButton)
BRW1.Popup.AddItemMimic('&Create Fee Notes',?CreateFeeNotesButton)
0{PROP:Alrt,255} = MouseLeft
?List:2{PROP:IconList,1} = '~BLANK.ICO'
?List:2{PROP:IconList,2} = '~CHECK.ICO'

BRW1.Popup.SetLevel(BRW1.Popup.AddItem('-', 'STAG::Separator1'),1)
BRW1.Popup.SetLevel(BRW1.Popup.AddItemMimic('TagOne', ?TagOne),1)
BRW1.Popup.SetLevel(BRW1.Popup.AddItemMimic('UntagOne', ?UntagOne),1)
BRW1.Popup.SetLevel(BRW1.Popup.AddItem('-', 'STAG::Separator2'),1)
BRW1.Popup.SetLevel(BRW1.Popup.AddItemMimic('TagAll', ?TagAll),1)
BRW1.Popup.SetLevel(BRW1.Popup.AddItemMimic('UntagAll', ?UntagAll),1)
BRW1.Popup.SetLevel(BRW1.Popup.AddItem('-', 'STAG::Separator1'),1)

If GLO:RemoteClientId
   ?FeesButton{PROP:Hide} = True
   ?SettingsButton{PROP:Hide} = True
   ?PaymentsButton{PROP:Hide} = True
   ?SettlementButton{PROP:Hide} = True
   ?TotalsButton{PROP:Hide} = True

   ?Insert{PROP:Disable} = True
   ?Change{PROP:Disable} = True
   ?Delete{PROP:Disable} = True
   ?ImportLedgerButton{PROP:Disable} = True
   ?ExportColDebitButton{PROP:Disable} = True
   ?CreateFeeNotesButton{PROP:Disable} = True
   ?TagOne{PROP:Disable} = True
   ?TagAll{PROP:Disable} = True
   ?UntagOne{PROP:Disable} = True
   ?UntagAll{PROP:Disable} = True
End

      QuickWindow{Prop:Alrt,254}=1024
      QuickWindow{Prop:Alrt,255}=AltF12
BRW1.Q &= Queue:Browse
BRW1.FileLoaded = 1

BRW1.AddSortOrder(,CD:MatterKey)
BRW1.AddRange(CD:MatterID,Relate:ColDebit,Relate:Matter)
BRW1.AddLocator(BRW1::Sort0:Locator)
BRW1::Sort0:Locator.Init(,CD:Date,,BRW1)
BIND('Tag',Tag)
BIND('LOC:TranType',LOC:TranType)
BIND('LOC:DisplayAmount',LOC:DisplayAmount)
BRW1.AddField(Tag,BRW1.Q.Tag)
BRW1.AddField(CD:Date,BRW1.Q.CD:Date)
BRW1.AddField(CD:Description,BRW1.Q.CD:Description)
BRW1.AddField(LOC:TranType,BRW1.Q.LOC:TranType)
BRW1.AddField(CD:DocumentCode,BRW1.Q.CD:DocumentCode)
BRW1.AddField(LOC:DisplayAmount,BRW1.Q.LOC:DisplayAmount)
BRW1.AddField(CD:CostBalance,BRW1.Q.CD:CostBalance)
BRW1.AddField(CD:InterestBalance,BRW1.Q.CD:InterestBalance)
BRW1.AddField(CD:CapitalBalance,BRW1.Q.CD:CapitalBalance)
BRW1.AddField(CD:Balance,BRW1.Q.CD:Balance)
BRW1.AddField(CD:Amount,BRW1.Q.CD:Amount)
BRW1.AddField(CD:VatAmount,BRW1.Q.CD:VatAmount)
BRW1.AddField(CD:VATFlag,BRW1.Q.CD:VATFlag)
BRW1.AddField(CD:RecordID,BRW1.Q.CD:RecordID)
BRW1.AddField(CD:MatterID,BRW1.Q.CD:MatterID)
BRW1.AddField(CD:Type,BRW1.Q.CD:Type)
BRW1.AddField(CD:CollCommFlag,BRW1.Q.CD:CollCommFlag)
BRW1.AddField(CD:Category,BRW1.Q.CD:Category)
BRW1.AddField(CD:TimerStamp,BRW1.Q.CD:TimerStamp)
BRW1.AddField(CD:EmployeeID,BRW1.Q.CD:EmployeeID)
BRW1.AddField(CD:BatchId,BRW1.Q.CD:BatchId)
BRW1.AddField(CD:TransID,BRW1.Q.CD:TransID)
BRW1.AddField(CD:LineId,BRW1.Q.CD:LineId)
BRW1.AddField(CD:OverrideEMOCommFlag,BRW1.Q.CD:OverrideEMOCommFlag)
Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)
SELF.AddItem(Resizer)
   IF CEM:WindowWidth
      QuickWindow{PROP:Width} = CEM:WindowWidth
   END
   IF CEM:WindowHeight
      QuickWindow{PROP:Height} = CEM:WindowHeight
   END

   QuickWindow{PROP:Center} = True
   QuickWindow{PROP:Hide} = True

FileLookup11.Init
FileLookup11.Flags=BOR(FileLookup11.Flags,FILE:LongName)
FileLookup11.SetMask('Documents','*.doc;*.docx;*.rtf')
FileLookup11.AddMask('All','*.*')
FileLookup11.WindowTitle='Report Footer'

BRW1.AskProcedure = 1
BRW1.AddToolbarTarget(Toolbar)
SELF.SetAlerts()
   BRW1.Popup.AddItem('-', 'ViewBatchSeparator1')
   BRW1.Popup.AddItemMimic('ViewBatch',?ViewBatchButton)
   BRW1.Popup.AddItem('-', 'ExportSeparator1')
   BRW1.Popup.AddItemMimic('Export Items', ?ExportColDebitButton)
      ?List:2{PROP:FontColor} = ColorText:4#
      ?List:2{PROP:Background} = ColorBackground:4#
      ?List:2{PROP:SelectedColor} = ColorSelText:4#
      ?List:2{PROP:SelectedFillColor} = ColorSelBackground:4#
      ?List:2{PROPLIST:GRID} = ColorGrid:4#
RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

CODE
ReturnValue = PARENT.Kill()
IF ReturnValue THEN RETURN ReturnValue.
IF SELF.FilesOpened
   Relate:BatHead.Close
   Relate:BatTran.Close
   Relate:ColDebit.Close
   Relate:Color.Close
   Relate:Creditor.Close
   Relate:DocLog.Close
   Relate:FeeNote.Close
   Relate:IntRatePeriod.Close
   Relate:IntRateSchedule.Close
   Relate:MatParty.Close
   Relate:Matter.Close
   Relate:Report.Close
   Relate:ReportEmp.Close
   Relate:SecProc.Close
END
GlobalErrors.SetProcedureName
RETURN ReturnValue


ThisWindow.Open PROCEDURE

CODE
DO ResetTheBrowseQueue
?List:2{PROP:Selected} = 1
?List:2{PROP:VScroll} = 1

PARENT.Open
IF COL:PopupReminder
   MESSAGE(COL:PopupReminder,'Reminder',ICON:Exclamation)
END



ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

CODE
   If ThisSecProc.CheckAccess() Then Return RequestCancelled.
ReturnValue = PARENT.Run()
RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

CODE
IF Number = BRW1.AskProcedure AND Request > 1  ! NOT INSERT

      If Inlist(Queue:Browse.CD:Type,'A','Z','I','X','V')
         Execute Inlist(Queue:Browse.CD:Type,'A','Z','I','X','V')
            Message('You cannot modify the Opening Balance.||Hint: You can change the Opening Balance on the settings screen (Use the ''Change Settings'' icon).','Deleting Balance','~no.ico')
            Message('You cannot modify this transaction. It is calculated by the program automatically.','Deleting Balance','~no.ico')
            Message('You cannot modify an Interest Transaction.||Hint: It can be changed by editing its associated Payment Transaction or changing the Calculation Settings.','Deleting Interest Transaction','~no.ico')
            Message('You cannot modify a Collection Commission Transaction.||Hint: It can be changed by editing its associated Payment Transaction or changing the Collection Commission settings for this Matter.','Deleting Collection Commission','~no.ico')
            Message('You cannot modify an Employer''s Commission Transaction.||Hint: It can be removed by overriding the Employer''s Commission setting on its associated Payment Transaction .','Deleting Employer''s Commission','~no.ico')
         .
         Select(?List:2)
         RETURN(LEVEL:Notify)
      ELSE
         CD:RecordID = Queue:Browse.CD:RecordID
         Access:ColDebit.Fetch(CD:PrimaryKey)
      END

END


ReturnValue = PARENT.Run(Number,Request)
IF SELF.Request = ViewRecord
   ReturnValue = RequestCancelled
ELSE
   GlobalRequest = Request
   UpdateColDebit
   ReturnValue = GlobalResponse
END
IF GlobalResponse = RequestCompleted

   IF Number = BRW1.AskProcedure AND Request = 1   ! INSERTING A DEBTOR PAYMENT

      IF CD:Type = 'P' AND CD:Category = 'P'

         ProcessSystemEvent(EVENT:Debtor_Receipt,CD:MatterId)

         IF MAT:ColDebitFeeCodeID

            NewTag:PtrM(Tag:FeeCode)
            SetTag:PtrM(Tag:FeeCode,MAT:ColDebitFeeCodeID)
            GLO:FeeNoteDate = CD:Date
            IF AddColDebit().
            GLO:FeeNoteDate = GLO:TodaysDate   ! RESET IT IN CASE USER DOES A MERGE NEXT


         END



      END

   END

   DO ResetTheBrowseQueue
   ReturnValue = 0

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
   OF ?CreateFeeNotesButton
      LOOP 1 TIMES
      
      Clear(SP:Record)
      SP:SecGroupId = GLO:SecGroupId
      SP:AccessFlag = GLO:SupervisorFlag
      SP:Description = 'Matters - Desktop - Fee Notes - Insert'
      IF Access:SecProc.TryFetch(SP:SecGroupKey) Then Access:SecProc.Insert().
      If ~SP:AccessFlag and ~GLO:SupervisorFlag
         Message('Access Denied||Your security settings do not allow you access to this area of the program.|',SP:Description,'~lock.ico')
         BREAK
      .
      
      
      
         IF FstTag:PtrM(TAG:ColCost)
            IF MESSAGE('Do you want to create Fee Notes from all the Tagged items?||Note: Payments, Interest Calculations and Balances will be ignored. Revenue Stamps will become disbursements. All other transactions will become fees.','Create Fee Notes',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:Yes
               OPEN(ProgressWindow)
               ProgressWindow{PROP:Text} = 'Creating Fee Notes'
               ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:ColCost)
               CLEAR(CD:Record)
               CD:RecordID = FstTag:PtrM(TAG:ColCost)                ! SET TO THE FIRST TAGGED MATTER
               LOOP 
                  IF ~Access:ColDebit.TryFetch(CD:PrimaryKey)
                        IF CD:Type <> 'P' AND CD:Type <> 'V'     ! IGNORE PAYMENTS
                           DO AddFeeNote
                        END
                  END
                  ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
                  DISPLAY
                  CD:RecordID = NxtTag:PtrM(TAG:ColCost)                ! SET TO NEXT MATTER
                  IF ~CD:RecordID THEN CLEAR(CD:Record);BREAK.
                  
               END
               NewTag:PtrM(TAG:ColCost)
               CLOSE(ProgressWindow)
            END
         ELSE
         IF MESSAGE('Create a Fee Note from ||' & CD:Description & '?','Create Fee Note',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:Yes
            DO AddFeeNote
         END
         END
      
      END
      
      SELECT(?List:2)
      
   OF ?UntagOne
            DO BRW1::UntagOne
   OF ?UntagAll
      DO BRW1::UnTagAll
   OF ?FeesButton
      IF ~MAT:DebtorFeeSheetID
         MESSAGE('This matter has no Debtor''s Fee Sheet selected.||This must be specified when you take on a Matter so the appropriate Fee Codes can be displayed.',MAT:FileRef & ' - ' & MAT:Description,ICON:Exclamation)
      ELSE
         FS:RecordID = MAT:DebtorFeeSheetID
         IF ~Access:FeeSheet.Fetch(FS:PrimaryKey)
            GlobalRequest = SelectRecord
            SelectFeeCode
            IF GlobalResponse = RequestCompleted
               IF ~CntTag:PtrM(Tag:FeeCode)             ! IF THE USER DID NOT TAG ANY
                  SetTag:PtrM(Tag:FeeCode,FC:RecordID) ! THEN TAG IT
               END
               GLO:FeeNoteDate = GetUserDate(GLO:TodaysDate)
               IF GLO:FeeNoteDate
                  IF AddColDebit().
                  GLO:FeeNoteDate = GLO:TodaysDate   ! RESET IT IN CASE USER DOES A MERGE NEXT
               END
            END
            NewTag:PtrM(Tag:FeeCode)         ! CLEAR THE TAGS
            DO ResetTheBrowseQueue
            
         END
      END
      SELECT(?List:2)
      
      
   OF ?PaymentsButton
      LOC:LastInterestDate = 0
      LOOP Y# = 1 TO RECORDS(Queue:Browse)
      
         GET(Queue:Browse,Y#)
      
         IF Queue:Browse.LOC:TranType = 'Interest'
      
            LOC:LastInterestDate = Queue:Browse.CD:Date
      
         END
      END
      IF ~LOC:LastInterestDate THEN LOC:LastInterestDate = MAT:InterestFrom.
      IF ~LOC:LastInterestDate THEN LOC:LastInterestDate = GLO:TodaysDate.
      
      ShowPaymentFigures(MAT:DebtorsCapitalBalance,MAT:DebtorsInterestBalance,MAT:DebtorsCostsBalance,LOC:LastInterestDate)
      SELECT(?List:2)
      
   OF ?SettlementButton
      IF MAT:DebtorsBalance > 0
         IF ShowSettlementFigures(MAT:DebtorsBalance)
            DO ResetTheBrowseQueue
         END
      ELSE
         MESSAGE('There is no balance to settle.','No balance',ICON:Exclamation)
      END
      SELECT(?List:2)
      
   OF ?TotalsButton
      ViewDebtorTotals
      SELECT(?List:2)
   OF ?Delete
         Clear(SP:Record)
         SP:SecGroupId = GLO:SecGroupId
         SP:AccessFlag = GLO:SupervisorFlag
         SP:Description = 'Debtors Account - Delete'
         IF Access:SecProc.TryFetch(SP:SecGroupKey) Then Access:SecProc.Insert().
         If ~SP:AccessFlag and ~GLO:SupervisorFlag
            Message('You do not have access rights to this procedure|Procedure: ' & SP:Description,'Access Denied','~lock.ico')
            RETURN(LEVEL:Notify)
         .
      
         IF FstTag:PtrM(TAG:ColCost)
            IF MESSAGE('Do you want to Delete all the Tagged items?','Deleting Debtor Transactions',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:Yes
               OPEN(ProgressWindow)
               ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:ColCost)
               CLEAR(CD:Record)
               CD:RecordID = FstTag:PtrM(TAG:ColCost)                ! SET TO THE FIRST TAGGED MATTER
               LOOP 
                  IF ~Access:ColDebit.TryFetch(CD:PrimaryKey)
                        Relate:ColDebit.Delete(0)
                  END
                  ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
                  DISPLAY
                  CD:RecordID = NxtTag:PtrM(TAG:ColCost)                ! SET TO NEXT MATTER
                  IF ~CD:RecordID THEN CLEAR(CD:Record);BREAK.
                  
               END
               NewTag:PtrM(TAG:ColCost)
               CLOSE(ProgressWindow)
               DO ResetTheBrowseQueue
               RETURN(LEVEL:Notify)
            ELSE
               RETURN(LEVEL:Notify)
            END
         ELSE
            ThisWindow.Update
            IF MESSAGE('Are you sure you want to delete||' & CD:Description,'Delete Transaction',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:No THEN CYCLE.
         END
   OF ?TagOne
            IF CD:Type = 'D' OR CD:Type = 'P' OR CD:Type = 'J' OR CD:Type = 'W'
               DO BRW1::TagOne
            END
   OF ?TagAll
      DO BRW1::TagAll
   END
ReturnValue = PARENT.TakeAccepted()
   CASE ACCEPTED()
   OF ?PrintListButton
      ThisWindow.Update
      GLO:ReportDestination = 'X'
      DO  PrintDeborsAccount
   OF ?ViewBatchButton
      ThisWindow.Update
      GET(Queue:Browse,Choice(?List:2))
      CD:RecordID = Queue:Browse.CD:RecordID
      Access:ColDebit.Fetch(CD:PrimaryKey)
      If CD:BatchId = 0
      Message('You cannot view the batch for this transaction|This transaction was not created from a batch','View Batch',ICON:Asterisk)
      Cycle
      .
      BAH:RecordId = CD:BatchId
      If Access:BatHead.Fetch(BAH:PrimaryKey) Then Cycle.
      BAT:BatchId = CD:BatchId
      BAT:TransId = CD:TransId
      If Access:BatTran.Fetch(BAT:BatchKey) Then Cycle.
      GlobalRequest = ChangeRecord
      UpdateBatTran
   OF ?ImportLedgerButton
      ThisWindow.Update
      GlobalRequest = SelectRecord
      SelectMatterTransactions
      IF GlobalResponse = RequestCompleted
         IF FstTag:PtrM(TAG:MatTran)
               OPEN(ProgressWindow)
               ProgressWindow{PROP:Text} = 'Importing transactions'
               ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:MatTran)
               DISPLAY
               CLEAR(MTT:Record)
               MTT:RecordID = FstTag:PtrM(TAG:MatTran)                ! SET TO THE FIRST TAGGED MATTER
               LOOP 
                  IF ~Access:MatTran.TryFetch(MTT:PrimaryKey)
                        DO ConvertMTTtoCD
                  END
                  ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
                  DISPLAY
                  MTT:RecordID = NxtTag:PtrM(TAG:MatTran)                ! SET TO NEXT MATTER
                  IF ~MTT:RecordID THEN CLEAR(MTT:Record);BREAK.
                  
               END
               NewTag:PtrM(TAG:MatTran)
               CLOSE(ProgressWindow)
         ELSE
               DO ConvertMTTtoCD
         END
         DO ResetTheBrowseQueue
      END
      
      
   OF ?ExportColDebitButton
      ThisWindow.Update
      If ~FstTag:PtrM(TAG:ColCost)
      Message('No Debtor Transactions Have Been Tagged|Tag Debtor Transactions First','Export Data',ICON:Asterisk)
      Cycle
      .
      If GetReportEmp(TAG:ColCost,2) Then Cycle.
      REE:MatterOption   = 1
      REE:MatterId       = MAT:RecordId
      REE:ColDebitOption = 2
      If Access:ReportEmp.Update() Then Cycle.
      START(ExportXML, 25000, TAG:ColCost)
   OF ?SettingsButton
      ThisWindow.Update
      IF UpdateInterestSettings()
         DO ResetTheBrowseQueue
         DO DisplayInterestSettings
      END
      SELECT(?List:2)
   OF ?PrintButton
      ThisWindow.Update
      LOC:TaggedMatters = CntTag:PtrM(Tag:Matter)
      IF LOC:TaggedMatters
         IF MESSAGE('There are ' & CLIP(LEFT(FORMAT(LOC:TaggedMatters,@n_5))) & ' Tagged Matters currently selected.||Do you want to print the Debtor''s Report for the Tagged Matters?','Multiple Matters Selected',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:No
            LOC:TaggedMatters = 0
         END
      END

   DO PrintDeborsAccount

   OF ?EmailButton
      ThisWindow.Update
      LOC:ReportEmailFlag = 1
      GLO:ReportDestination = 'P'
      
      
      LOC:TaggedMatters = CntTag:PtrM(Tag:Matter)
      IF LOC:TaggedMatters
         IF MESSAGE('There are ' & CLIP(LEFT(FORMAT(LOC:TaggedMatters,@n_5))) & ' Tagged Matters currently selected.||Do you want to email the Debtor''s Report to the Defendants in all the Tagged Matters?','Multiple Matters Selected',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:No
            LOC:TaggedMatters = 0
         END
      END
      
      
      DO PrintDeborsAccount
      
   OF ?Close
      ThisWindow.Update
      POST(EVENT:CloseWindow)
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
   OF EVENT:Sized
      QuickWindow{PROP:Hide} = False
      
   END
ReturnValue = PARENT.TakeWindowEvent()
   CASE EVENT()
   OF EVENT:AlertKey
            DO BRW1::MouseLeftFlipTag
   OF EVENT:PreAlertKey
            IF KEYCODE()=MouseLeft THEN CYCLE.
   END
   RETURN ReturnValue
END
ReturnValue = Level:Fatal
RETURN ReturnValue


ThisWindow.Update PROCEDURE

CODE
GET(Queue:Browse,CHOICE(?List:2))
IF Inlist(Queue:Browse.CD:Type,'Y','A','Z','I','X')
   CLEAR(CD:Record)
!     MESSAGE('CLEARED CD:Record IN ThisWindow.Update PROCEDURE')
   RETURN
END

PARENT.Update


ThisSecProc.CheckAccess  PROCEDURE()
Code
Clear(SP:Record)
SP:SecGroupId = GLO:SecGroupId
SP:AccessFlag = GLO:SupervisorFlag
SP:Description = 'Matters - Desktop - Debtors Account'
IF Access:SecProc.TryFetch(SP:SecGroupKey) Then Access:SecProc.Insert().
If ~SP:AccessFlag and ~GLO:SupervisorFlag
   Message('Access Denied||Your security settings do not allow you access to this area of the program.|',SP:Description,'~lock.ico')
   Return Level:Notify
.
Return Level:Benign

ThisSecProc.Update  PROCEDURE()
Code
   Free(GFQ:FieldQueue)
   BrowseSecProc('Matters - Desktop - Debtors Account',0)
   Return Level:Benign

BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

CODE
PARENT.Init(ListBox,Posit,V,Q,RM,WM)
IF WM.Request <> ViewRecord
   SELF.InsertControl=?Insert
   SELF.ChangeControl=?Change
   SELF.DeleteControl=?Delete
END


BRW1.Reset PROCEDURE

CODE
RETURN
PARENT.Reset


BRW1.Reset PROCEDURE(BYTE Locate)

CODE
RETURN
PARENT.Reset(Locate)


BRW1.ResetFromAsk PROCEDURE(*BYTE Request,*BYTE Response)

CODE
RETURN
PARENT.ResetFromAsk(Request,Response)


BRW1.ResetFromBuffer PROCEDURE

CODE
RETURN
PARENT.ResetFromBuffer


BRW1.ResetFromFile PROCEDURE

CODE
RETURN
PARENT.ResetFromFile


BRW1.ResetFromView PROCEDURE

CODE
   RETURN
SETCURSOR(Cursor:Wait)
Relate:ColDebit.SetQuickScan(1)
SELF.Reset
LOOP
   CASE SELF.Next()
   OF Level:Notify
      BREAK
   OF Level:Fatal
      RETURN
   END
   SELF.SetQueueRecord
END
PARENT.ResetFromView
Relate:ColDebit.SetQuickScan(0)
SETCURSOR()


BRW1.ResetQueue PROCEDURE(BYTE ResetMode)

CODE
RETURN
PARENT.ResetQueue(ResetMode)


BRW1.SetQueueRecord PROCEDURE

CODE
RETURN
PARENT.SetQueueRecord
SELF.Q.Tag_NormalFG = -1
SELF.Q.Tag_NormalBG = -1
SELF.Q.Tag_SelectedFG = -1
SELF.Q.Tag_SelectedBG = -1
SELF.Q.Tag_Icon = 0
SELF.Q.CD:Date_NormalFG = -1
SELF.Q.CD:Date_NormalBG = -1
SELF.Q.CD:Date_SelectedFG = -1
SELF.Q.CD:Date_SelectedBG = -1
SELF.Q.CD:Description_NormalFG = -1
SELF.Q.CD:Description_NormalBG = -1
SELF.Q.CD:Description_SelectedFG = -1
SELF.Q.CD:Description_SelectedBG = -1
SELF.Q.LOC:TranType_NormalFG = -1
SELF.Q.LOC:TranType_NormalBG = -1
SELF.Q.LOC:TranType_SelectedFG = -1
SELF.Q.LOC:TranType_SelectedBG = -1
SELF.Q.CD:DocumentCode_NormalFG = -1
SELF.Q.CD:DocumentCode_NormalBG = -1
SELF.Q.CD:DocumentCode_SelectedFG = -1
SELF.Q.CD:DocumentCode_SelectedBG = -1
SELF.Q.LOC:DisplayAmount_NormalFG = -1
SELF.Q.LOC:DisplayAmount_NormalBG = -1
SELF.Q.LOC:DisplayAmount_SelectedFG = -1
SELF.Q.LOC:DisplayAmount_SelectedBG = -1
SELF.Q.CD:CostBalance_NormalFG = -1
SELF.Q.CD:CostBalance_NormalBG = -1
SELF.Q.CD:CostBalance_SelectedFG = -1
SELF.Q.CD:CostBalance_SelectedBG = -1
SELF.Q.CD:InterestBalance_NormalFG = -1
SELF.Q.CD:InterestBalance_NormalBG = -1
SELF.Q.CD:InterestBalance_SelectedFG = -1
SELF.Q.CD:InterestBalance_SelectedBG = -1
SELF.Q.CD:CapitalBalance_NormalFG = -1
SELF.Q.CD:CapitalBalance_NormalBG = -1
SELF.Q.CD:CapitalBalance_SelectedFG = -1
SELF.Q.CD:CapitalBalance_SelectedBG = -1
SELF.Q.CD:Balance_NormalFG = -1
SELF.Q.CD:Balance_NormalBG = -1
SELF.Q.CD:Balance_SelectedFG = -1
SELF.Q.CD:Balance_SelectedBG = -1


BRW1.UpdateBuffer PROCEDURE

CODE

PARENT.UpdateBuffer


BRW1.UpdateViewRecord PROCEDURE

CODE
CLEAR(CD:Record)
CD:Date                = Queue:Browse.CD:Date
CD:Description         = Queue:Browse.CD:Description
CD:Balance             = Queue:Browse.CD:Balance
CD:CostBalance         = Queue:Browse.CD:CostBalance
CD:InterestBalance     = Queue:Browse.CD:InterestBalance
CD:CapitalBalance      = Queue:Browse.CD:CapitalBalance
CD:Amount              = Queue:Browse.CD:Amount
CD:VatAmount           = Queue:Browse.CD:VatAmount
CD:VATFlag             = Queue:Browse.CD:VATFlag
CD:RecordID            = Queue:Browse.CD:RecordID
CD:MatterID            = Queue:Browse.CD:MatterID
CD:Type                = Queue:Browse.CD:Type
CD:CollCommFlag        = Queue:Browse.CD:CollCommFlag
CD:Category            = Queue:Browse.CD:Category
CD:TimerStamp          = Queue:Browse.CD:TimerStamp
CD:OverrideEMOCommFlag = Queue:Browse.CD:OverrideEMOCommFlag
RETURN


PARENT.UpdateViewRecord


BRW1.UpdateWindow PROCEDURE

CODE
RETURN
PARENT.UpdateWindow


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


CODE
PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
SELF.SetParentDefaults
SELF.SetStrategy(?Close, Resize:FixRight+Resize:FixBottom, Resize:LockSize)
SELF.SetStrategy(?String2:3, Resize:FixRight+Resize:FixTop, Resize:LockSize)
SELF.SetStrategy(?MAT:DebtorsCapitalBalance, Resize:FixRight+Resize:FixTop, Resize:LockSize)
SELF.SetStrategy(?LOC:InterestSettings, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
SELF.SetStrategy(?MAT:DebtorsBalance, Resize:FixRight+Resize:FixTop, Resize:LockSize)
SELF.SetStrategy(?LOC:DisplayCostAmount:Prompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
SELF.SetStrategy(?LOC:DisplayCostAmount, Resize:FixRight+Resize:FixTop, Resize:LockSize)
SELF.SetStrategy(?LOC:DisplayInterestAmount:Prompt, Resize:FixRight+Resize:FixTop, Resize:LockWidth)
SELF.SetStrategy(?LOC:DisplayInterestAmount, Resize:FixRight+Resize:FixTop, Resize:LockSize)
SELF.SetStrategy(?String2:4, Resize:FixRight+Resize:FixTop, Resize:LockSize)
SELF.SetStrategy(?IconGroupBox, Resize:FixLeft+Resize:FixTop, Resize:ConstantRight+Resize:LockHeight)
SELF.SetStrategy(?LOC:CapitalReductionSettings, Resize:FixLeft+Resize:FixBottom, Resize:LockSize)

