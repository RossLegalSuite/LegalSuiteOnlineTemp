

   MEMBER('DESKTOP.clw')                              ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('DESKT148.INC'),ONCE        !Local module procedure declarations
                       INCLUDE('DESKT060.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT061.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT079.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT080.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT086.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT087.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT090.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT093.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT095.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT096.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT097.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT098.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT099.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT101.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT102.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT103.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT104.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT105.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT114.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT154.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT158.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT164.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT176.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT181.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT182.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('DESKT183.INC'),ONCE        !Req'd for module callout resolution
                     END


BrowseDesktop PROCEDURE                               !Generated from procedure template - Window

!1 BRW54 - Matter       Queue:Browse:1          ?MattersTab         ?MattersBrowse
!2 BRW2 - FeeNote       Queue:Browse            ?FeeNotesTab        ?FeeNoteBrowse
!3 BRW52 - FileNote     Queue:Browse:2          ?FileNotesTab       ?FileNoteBrowse
!4 BRW15 - ToDoNote     Queue:Browse:3          ?RemindersTab       ?ToDoNoteBrowse
!5 BRW22 - Time Records (MA) Queue:Browse:4     ?TimeRecordingTab   ?TimeRecordingBrowse
!6 BRW36 - DataLink     Queue:Browse:5       
!7 BRW35 - ABSALink     Queue:Browse:9          ?ABSALinkTab        ?ABSALinkBrowse
!8 BRW46 - FNBLink      Queue:Browse:7          ?FNBLinkTab         ?FNBLinkBrowse
!9 BRW33 - SARSLink    Queue:Browse:11         ?SARSTab            ?SARSLinkBrowse
!10 BRW38 - RepEmp      Queue:Browse:6          ?ReportsTab         ?ReportList

LOC:IconSpacing            BYTE(22)
LOC:IconSize               BYTE(20)
LOC:QBEFilterFeenoteString CSTRING(1000)
LOC:QBEFilterFileNoteString CSTRING(1000)
LOC:QBEFilterToDoNoteString CSTRING(1000)
LOC:QBEFilterMatActivString CSTRING(1000)
LOC:QBEFilterLawMatterMessageString CSTRING(1000)

LOC:TaggedRecordID  LONG

SAV:FIL:RecordID    LONG
SAV:FN:RecordID     LONG
LOC:FN_Type                          CSTRING(50)
SAV:LOC:FN_Type                      LIKE(LOC:FN_Type)
LOC:WorkFlowDocument                 CSTRING(50)

EVENT:SendEmailButton                EQUATE(54002)
EVENT:SendSMSButton                  EQUATE(54003)
EVENT:CopyMatter                     EQUATE(54004)
EVENT:CreateInvoice                  EQUATE(54005)
EVENT:ResetColumnWidthsButton        EQUATE(54006)
EVENT:FavouritesButton               EQUATE(54007)
EVENT:AssignLawRefButton             EQUATE(54008)
EVENT:ReassignDataLinkMatterButton   EQUATE(54009)
EVENT:ExportMatterButton             EQUATE(54010)

LOC:BranchID         LONG
SAV:ErrorQueue       QUEUE,PRE(SAV)
Message1               CSTRING(250)
Message2               CSTRING(250)
Message3               CSTRING(250)
Message4               CSTRING(250)
Message5               CSTRING(250)
Message6               CSTRING(250)
PartyID                LONG
MatterID               LONG
                     END

LOC:UnreadRecords    LONG
LOC:CurrentRecord    LONG

LOC:AG_SuiteID                 LONG
SAV:LOC:AG_SuiteID             LONG

LOC:DisplayFutureTasksFlag     BYTE
LOC:Source                     BYTE
LOC:StartClock                 LONG
LOC:MarkingMultipleMattersFlag BYTE
LOC:ThisMatterID               LONG
LOC:Command                    CSTRING(512)


SAV:DateDone                LONG
LOC:GetEmailLanguageFlag    BYTE
THIS:PartyLanguageID        LONG

LOC:QBEFilterString        LIKE(GLO:QBEFilterString)
LOC:CurrentFilterString    LIKE(GLO:QBEFilterString)

LOC:ShowFileNoteIconsFlag  BYTE
LOC:ShowToDoNoteIconsFlag  BYTE

LOC:ShowMatterIconsFlag    BYTE


LOC:TOD_CriticalStepID  LONG
SAV:TOD_CriticalStepID  LONG


LOC:Counter             LONG

LOC:IconFileName         CSTRING(100)

LOC:NewMatterIconID      LONG
LOC:ArchivedMatterIconID LONG

LOC:ProgressID           LONG
LOC:BP:RecordID          LONG
LOC:QuickSearch          CSTRING(20)
LOC:UnreadMessages       LONG
LOC:ProgramInitialized   LONG
LOC:StayOnThisMatterID   LONG
LOC:OpenedFiles          BYTE
LOC:ThisPartyID          LONG
LOC:FoundEmailAddress    BYTE
LOC:NewMatterState       BYTE

LOC:AutoMessage          BYTE
LOC:BranchRecordId       LONG
LOC:FirstImportFlag      BYTE
LOC:MessagesImportedFlag BYTE

LOC:SchemaDirectory CSTRING(255)
LOC:UseThisMatterID LONG
LOC:TOD:Date        LONG
LOC:TOD:RecordID    LONG
SAVED:EmployeeID    LONG
LOC:Result          BYTE
LOC:EmployeeDropDownCounter       LONG
LOC:CostCentreDropDownCounter     LONG
SAV:MAT:RecordID                  LONG
SAV:MAT:DateInstructed            LONG
SAV:COL:CourtDate                 LONG
LOC:BP:KorbitecMsgIDRef           LONG
LOC:BP:LawRef                     LONG
LOC:Error                         LONG


LOC:ContactID        LONG
LOC:SMSRecipient     CSTRING(100)
LOC:ThisRoleID       LONG
LOC:SMSBody          CSTRING(1000)
LOC:ThisSMSBody      CSTRING(1000)
SAVE:Path            CSTRING(200)
LOC:SMSCounter             LONG
LOC:LastWarningMatterID    LONG
LOC:TaxNumber              LIKE(PAR:TaxNumber)

SMSQueue     QUEUE,PRE(SMSQ)
Number         CSTRING(21)
PartyID        LONG
MatterID       LONG
             END


EmailFileNotesQueue     QUEUE,PRE(EFILQ)  ! FOR EMAILING TAGGED FILENOTES
Date                      LIKE(FIL:Date)
Description               LIKE(FIL:Description)
                   END



CircularDirQueue         QUEUE,PRE()
CDQ:Name                    STRING(FILE:MaxFilename)
CDQ:ShortName               STRING(13)
CDQ:Date                    LONG
CDQ:Time                    LONG
CDQ:Size                    LONG
CDQ:Attrib                  BYTE
                         END

!SAV:ToDoGroupID      LONG
SAV:TOD:RecordID     LONG
!SAV:TOD:Date         LONG
!SAV:TOD:DateDone     LONG
LOC:DeleteResponse   BYTE
SAV:MME:FileName     LIKE(MME:FileName)

LOC:NumberOfDataLinkMessages   LONG
LOC:DataLinkInboxStatus         CSTRING(50)

LOC:FNBMatterState               CSTRING(100)
LOC:ABSAMatterState               CSTRING(100)
LOC:MatterLawRef                 CSTRING(150)

LOC:AddedSavedReportsFlag       BYTE

LOC:FilterABSALinkString            CSTRING(500)
LOC:FilterFNBLinkString             CSTRING(500)
LOC:FilterSARSLinkString             CSTRING(500)
LOC:FilterLawMatterMessageString   CSTRING(500)

LOC:DAT_Matter      CSTRING(10)

LOC:DAT_Period      CSTRING(20)

LOC:Voucher         CSTRING(20)

SAV:DAT_Matter      CSTRING(10)

SAV:DAT_Period      CSTRING(20)
LOC:DAT_FromDate    LONG
LOC:DAT_ToDate      LONG
SAV:DAT_FromDate    LONG
SAV:DAT_ToDate      LONG

LOC:MA_BilledFlag      CSTRING(20)

LOC:TotalToBeTagged        LONG
LOC:DisplayProgessWindowFlag  BYTE
LOC:DocGenID               LONG
SAV:GlobalResponse         LIKE(GlobalResponse)
LOC:DataLinkSourceMatter      LIKE(MAT:FileRef)
LOC:DataLinkTargetMatter LIKE(MAT:FileRef)
LOC:FeeNotesSkipped        BYTE
LOC:FilteredFeeNotesFlag   BYTE
LOC:NewLawRef        CSTRING(10)
LOC:TotalRecords           LONG
LOC:MAT:RecordID           LONG
LOC:LawLinkID              LONG
SAV:ReportDestination      LIKE(GLO:ReportDestination)
LOC:AdustCounter           SHORT
LOC:ClientID               LONG

LOC:StrippedFileRef        LIKE(MAT:FileRef)
LOC:Path                   CSTRING(200)

LOC:FavouriteRecordID  LONG
LOC:JumpToRecordID     LONG

LOC:BRW1             LONG
LOC:BRW2             LONG
LOC:MatterID         LONG
LOC:EmailMatterID    LONG
LOC:ButtonXPos       LONG
LOC:MatterWord       CSTRING(30)

LOC:OutLookObj       CSTRING(35)
LOC:MailItemObj      CSTRING(35)


LOC:TaggedMatterList CSTRING(2000)


LOC:MaxValue         LONG
LOC:Body             LIKE(DOL:EmailBody)

LOC:Subject          CSTRING(150)
LOC:TheirRef         LIKE(MAT:TheirRef)
LOC:ThisEmail        CSTRING(50)

LOC:IsolationLevel      SHORT
LOC:MaxStatements       SHORT
LOC:CurLine             LONG
LOC:CurCol              LONG
LOC:HeadingLineNumber   LONG
LOC:FNVatAmount         DECIMAL(11,2)
LOC:FNLoopCounter       SHORT
LOC:DisbursementCounter SHORT

ProgressWindow WINDOW('Processing Records'),AT(,,201,39),FONT('MS Sans Serif',8,,),CENTER,GRAY,DOUBLE, |
         MDI
       PROGRESS,USE(?ProgressBar),AT(7,12,187,10),RANGE(0,100)
     END

QuickQuoteWindow WINDOW('Quick Quote'),AT(,,164,182),FONT('Arial',9,,FONT:regular),CENTER,GRAY
       STRING('Please choose the type of Quotation:'),AT(15,8),USE(?String23A),FONT(,11,,)
       BUTTON('&Bond'),AT(28,28,107,25),USE(?BondsQuoteButton),LEFT,FONT(,12,COLOR:Black,FONT:bold,CHARSET:ANSI), |
           TIP('Calculate Bond Costs'),ICON('document_certificate.ico')
       BUTTON('&Transfer'),AT(28,68,107,25),USE(?TransfersQuoteButton),LEFT,FONT(,12,COLOR:Black,FONT:bold,CHARSET:ANSI), |
           TIP('Calculate Transfers Costs'),ICON('document_exchange.ico')
       BUTTON('&Consents'),AT(28,108,107,25),USE(?CancellationsQuoteButton),LEFT,FONT(,12,COLOR:Black,FONT:bold,CHARSET:ANSI), |
           TIP('Calculate the Costs of various consents including Cancelling a Bond'),ICON('document_delete.ico')
       BUTTON('&Cancel'),AT(99,156,60,20),USE(?CostsCancelButton),LEFT,FONT(,11,,),TIP('Exit'),ICON('delete32.ico')
     END

UpdateVoucherWindow WINDOW('Update Voucher On Tagged Fee Notes'),AT(,,158,75),FONT('MS Sans Serif',8,,FONT:regular), |
         CENTER,GRAY,MODAL
       STRING('Enter the Voucher with which the tagged '),AT(12,4),USE(?String22)
       STRING('matters will be updated'),AT(12,14),USE(?String23)
       STRING('Voucher:'),AT(12,30),USE(?Voucher)
       ENTRY(@s20),AT(52,30,98,10),USE(LOC:Voucher)
       BUTTON('&OK'),AT(52,52,47,14),USE(?VoucherOKButton),LEFT,ICON('smalltick.ico'),DEFAULT
       BUTTON('&Cancel'),AT(104,52,47,14),USE(?VoucherCancelButton),LEFT,ICON('smallcross.ico')
     END

LOC:BankDownloadSelection    LONG
LOC:SuiteDownloadSelection   LONG

LAWSelectionWindow WINDOW('Select Messages'),AT(,,189,86),FONT('Arial',9,,FONT:regular),CENTER,GRAY
       OPTION('Download Messages for the following Bank'),AT(8,8,167,45),USE(LOC:BankDownloadSelection), |
           BOXED
         RADIO('ABSA'),AT(20,23),USE(?LOC:BankDownloadSelection:Radio2),VALUE('1')
         RADIO('Standard Bank'),AT(20,37),USE(?LOC:BankDownloadSelection:Radio3),VALUE('2')
       END
       BUTTON('&OK'),AT(59,60,60,20),USE(?LAWSelectionOKButton),LEFT,FONT(,11,,),ICON('check3.ico'),DEFAULT
       BUTTON('&Cancel'),AT(125,60,60,20),USE(?LAWSelectionCancelButton),LEFT,FONT(,11,,),ICON('delete32.ico')
     END




MatterPartyView  VIEW(MatParty)
                   PROJECT(MP:RecordID)
                   PROJECT(MP:MatterID)
                   JOIN(ROL:PrimaryKey,MP:RoleID)
                      PROJECT(ROL:LOLNotifyFlag)
                    END
                 END

SAV:FN_Date             LIKE(FN:Date)
SAV:FN_MatterID         LIKE(FN:MatterID)

SAV:TOD_RecordID         LIKE(TOD:RecordID)
SAV:TOD_MatterID         LIKE(TOD:MatterID)


LOC:SearchedForMatter           CSTRING(100)
LOC:WindowHeading               CSTRING(250)
LOC:FilterMessage               CSTRING(200)
LOC:OpenedMergingFiles          BYTE

LOC:CurrentMatterID             LONG
SAV:FN_CurrentMatterID             LONG
SAV:FIL_CurrentMatterID             LONG
SAV:TOD_CurrentMatterID             LONG
SAV:MA_CurrentMatterID             LONG
SAV:FNB_CurrentMatterID     LONG
SAV:SARS_CurrentMatterID     LONG

SAV:ABSA_CurrentMatterID     LONG
SAV:DAT_CurrentMatterID     LONG

LOC:MA_ActivityID               LONG
LOC:CurrentMatterFileRef        CSTRING(75)
LOC:DifferentDocumentSetsFlag        BYTE
SAV:DocgenID                    LONG
SavPosition                     STRING(260)
SAV:LastMatterID                LONG
SAV:CurrentChoice               SHORT
SAV:GlobalDefaultCostCentreID   LONG
LOC:EveryoneAllowedFlag         BYTE
SAV:FN_Matter                   CSTRING(10)
SAV:FN_FromDate                 LIKE(FN:Date)
SAV:FN_ToDate                   LIKE(FN:Date)
SAV:FN_EmployeeID               LONG
SAV:FN_CostCentreID               LONG
SAV:MA_CostCentreID               LONG
SAV:FN_Period                   CSTRING(20)
SAV:TOD_Matter                   CSTRING(10)
SAV:TOD_FromDate                 LIKE(TOD:Date)
SAV:TOD_ToDate                   LIKE(TOD:Date)
SAV:TOD_Period                   CSTRING(20)
SAV:TOD_EmployeeID               LONG
SAV:MA_Matter                   CSTRING(10)
SAV:MA_FromDate                 LIKE(MA:Date)
SAV:MA_ToDate                   LIKE(MA:Date)
SAV:MA_EmployeeID               LONG
SAV:MA_Period                   CSTRING(20)
SAV:MA_ActivityID               LONG
SAV:FIL_Matter                   CSTRING(10)
SAV:FIL_FromDate                 LIKE(FIL:Date)
SAV:FIL_ToDate                   LIKE(FIL:Date)
SAV:FIL_EmployeeID               LONG
SAV:FIL_Period                   CSTRING(20)


!COLOR:SCROLLBAR         EQUATE (80000000H)
!COLOR:BACKGROUND        EQUATE (80000001H)
!COLOR:ACTIVECAPTION     EQUATE (80000002H)
!COLOR:INACTIVECAPTION   EQUATE (80000003H)
!COLOR:MENU              EQUATE (80000004H)
!COLOR:WINDOW            EQUATE (80000005H)
!COLOR:WINDOWFRAME       EQUATE (80000006H)
!COLOR:MENUTEXT          EQUATE (80000007H)
!COLOR:WINDOWTEXT        EQUATE (80000008H)
!COLOR:CAPTIONTEXT       EQUATE (80000009H)
!COLOR:ACTIVEBORDER      EQUATE (8000000AH)
!COLOR:INACTIVEBORDER    EQUATE (8000000BH)
!COLOR:APPWORKSPACE      EQUATE (8000000CH)
!COLOR:HIGHLIGHT         EQUATE (8000000DH)
!COLOR:HIGHLIGHTTEXT     EQUATE (8000000EH)
!COLOR:BTNFACE           EQUATE (8000000FH)
!COLOR:BTNSHADOW         EQUATE (80000010H)
!COLOR:GRAYTEXT          EQUATE (80000011H)
!COLOR:BTNTEXT           EQUATE (80000012H)
!COLOR:INACTIVECAPTIONTEXT EQUATE (80000013H)
!COLOR:BTNHIGHLIGHT        EQUATE (80000014H)

OpeningDesktopScreen WINDOW,AT(,,210,96),COLOR(COLOR:APPWORKSPACE),CENTER,NOFRAME
       STRING('Loading...'),AT(11,28,180,42),USE(?LoadingMattersMessage),TRN,CENTER,FONT('Arial',48,COLOR:Gray,FONT:bold,CHARSET:ANSI)
     END


!OpeningDesktopScreen WINDOW,AT(,,200,200),CENTER,WALLPAPER('SplashScreen.jpg'), |
!         NOFRAME
!       STRING('Loading your Matters...'),AT(19,185,171,12),USE(?LoadingMattersMessage),TRN,CENTER,FONT('Arial',14,,FONT:bold)
!     END

!OpeningDesktopScreen WINDOW('Opening LegalSuite Desktop'),AT(,,120,50),CENTER,GRAY
!       IMAGE('desktop.ico'),AT(15,11,18,18),USE(?DesktopImage)
!       STRING('Please Wait . . .'),AT(47,23),USE(?String111)
!       STRING('Initialising files'),AT(44,8),USE(?String112)
!     END


LOC:AdjustFeesPercent   DECIMAL(11,2)
LOC:AdjustFeesHow       CSTRING(5)
AdjustFeesScreen WINDOW('Adjust Tagged Amounts'),AT(,,125,61),FONT('MS Sans Serif',8,,FONT:regular),CENTER,IMM,SYSTEM,GRAY
       OPTION,AT(8,4,47,31),USE(LOC:AdjustFeesHow)
         RADIO('Increase'),AT(12,9),USE(?LOC:AdjustFeesHow:Radio1),VALUE('UP')
         RADIO('Decrease'),AT(12,20),USE(?LOC:AdjustFeesHow:Radio2),VALUE('DOWN')
       END
       STRING('by'),AT(60,16),USE(?AdjustfeesString2)
       ENTRY(@n_9.2),AT(72,16,31,9),USE(LOC:AdjustFeesPercent),RIGHT,TIP('The percentage to adjust')
       STRING('%'),AT(105,16),USE(?AdjustFeesString1),FONT(,,,FONT:bold)
       BUTTON('&Ok'),AT(28,44,42,12),USE(?AdjustFeesOKButton),LEFT,ICON('smalltick.ico')
       BUTTON('&Cancel'),AT(76,44,45,12),USE(?AdjustFeesCancelButton),LEFT,ICON('smallcross.ico')
     END



LOC:AdjustVatRate STRING(1)


AdjustVatRateScreen WINDOW('Adjust Vat Rate'),AT(,,143,63),FONT('MS Sans Serif',8,,FONT:regular),CENTER, |
         IMM,SYSTEM,GRAY
       PROMPT('New Vat Rate:'),AT(9,17),USE(?LOC:AdjustVatRatePrompt)
       LIST,AT(64,17,67,10),USE(LOC:AdjustVatRate),TIP('Change the Fee Notes to this Vat Rate'),DROP(10), |
           FROM('1 - 14.00%|2 - 10.00%|3 - 0.00%|No VAT|Zero Rated')
       BUTTON('&Ok'),AT(43,44,42,12),USE(?AdjustVatRateOKButton),LEFT,ICON('smalltick.ico')
       BUTTON('&Cancel'),AT(91,44,45,12),USE(?AdjustVatRateCancelButton),LEFT,ICON('smallcross.ico')
     END


LOC:SARSSelection       CSTRING(25)

LOC:FIL_Internal       CSTRING(20)
SAV:FIL_Internal       CSTRING(20)

LOC:FIL_Status      CSTRING(20)
LOC:FIL_Employee      CSTRING(30)
LOC:MA_Activity      CSTRING(30)

! Datalink - Nick 23/3/2015
SAV:XMLMessageBody    CSTRING(100000)
SAV:MAT:FileRef       Like(MAT:FileRef)
SAV:MAT:LawRef        Like(MAT:LawRef )

LOC:ViewAllEmployeeData BYTE
LOC:ViewAllEmployeeDesc CSTRING(50)
LOC:Minutes          SHORT
LOC:ABSA_TurnAroundTime CSTRING(20)
LOC:Division         CSTRING(51)
LOC:AG_Suite_Description CSTRING(51)
LOC:TOD_Status       CSTRING(20)
LOC:TOD_CriticalStep CSTRING(100)
LOC:SortDesktopOption STRING(1)
LOC:Employee         CSTRING(51)
LOC:QuickFeeCode     CSTRING(10)
LOC:DAT_Date         LONG
LOC:LetterHeadFlag   BYTE
LOC:ReportDestination STRING(1)
LOC:ReportCategory   CSTRING(20)
LocalReportQueue     QUEUE,PRE(LRQ)
Title                CSTRING(50)
Description          CSTRING(150)
Category             CSTRING(15)
RecordID             LONG
EmployeeID           LONG
                     END
LOC:MA_Billable      CSTRING(20)
LOC:PostedOption     CSTRING(10)
LOC:WordProgressString1 STRING(50)
LOC:WordProgressString2 STRING(50)
LOC:ReturnCode       BYTE
LOC:WordProgressString3 STRING(50)
SAV:Choice           SHORT
LOC:FN_Period        CSTRING(20)
LOC:FN_Matter        CSTRING(10)
LOC:FN_ToDate        LIKE(FN:Date)
LOC:FN_FromDate      LIKE(FN:Date)
LOC:FIL_Matter       CSTRING(10)
LOC:FIL_Period       CSTRING(20)
LOC:FIL_ToDate       LIKE(FIL:Date)
LOC:FIL_FromDate     LIKE(FIL:Date)
LOC:TOD_Matter       CSTRING(10)
LOC:TOD_Period       CSTRING(20)
LOC:TOD_FromDate     LIKE(TOD:Date)
LOC:TOD_ToDate       LIKE(TOD:Date)
LOC:MA_Matter        CSTRING(20)
LOC:MA_Period        CSTRING(20)
LOC:MA_ToDate        LIKE(MA:Date)
LOC:MA_FromDate      LIKE(MA:Date)
LOC:MatterType       CSTRING(50)
LOC:RangeObject      CSTRING(35)
LOC:FilterString     CSTRING(250)
LOC:FilterMatterString CSTRING(5000)
TMP:FilterString     CSTRING(255)
LOC:FilterFeenoteString CSTRING(2000)
LOC:FilterFileNoteString CSTRING(2000)
LOC:FilterToDoNoteString CSTRING(2000)
LOC:FilterMatActivString CSTRING(2000)
LOC:FindFileRef      CSTRING(20)
LOC:UserName         CSTRING(20)
LOC:ClientName       CSTRING(50)
LOC:DocgenModule     CSTRING(35)
Tag                  STRING(10)
FilesOpened          BYTE
Save:MAT:RecordID    LONG
LOC:RUNNING          BYTE
LOC:MergeProgressString CSTRING(75)
LOC:DocumentLanguage CSTRING(10)
LOC:FeeDescription   CSTRING(255)
LOC:Tentative        BYTE
LOC:FN_Employee      CSTRING(30)
LOC:MA_Employee      CSTRING(30)
LOC:Private          BYTE
LOC:MadeFeeNote      BYTE
LOC:Location         CSTRING(50)
LOC:DayOfWeek        CSTRING(12)
LOC:TOD_Employee     CSTRING(20)
LOC:OnHold           BYTE
LOC:TotalFees        DECIMAL(11,2)
LOC:TotalDisb        DECIMAL(11,2)
LOC:TotalMAFees      DECIMAL(11,2)
LOC:TotalMAMinutes   CSTRING(20)
LOC:TotalMAHours     LONG
LOC:GoAhead          BYTE
LOC:ColDebitFlag     BYTE
LOC:PostedFlag       BYTE
LOC:FileNotePostedFlag BYTE
LOC:Status           CSTRING(49)
LOC:FN:AmountExcl    DECIMAL(11,2)
LOC:FN:AmountIncl    DECIMAL(11,2)
LOC:FN:VatAmount     DECIMAL(11,2)
LOC:FN:VatDesc       CSTRING(20)
LOC:Billable         BYTE
LOC:Tagged           LONG
LOC:TotalMABillableAmount DECIMAL(11,2)
LOC:MA_HoursAndMinutes CSTRING(10)
LOC:LastStage        CSTRING(100)
LOC:LastFileNote     CSTRING(100)
LOC:TaggedTotalFees  DECIMAL(11,2)
CopyButtonPressed    BYTE
LOC:FN_CostCentre    CSTRING(50)
LOC:FICAComplianceFlag BYTE
LOC:FICAWords        CSTRING(4)
LOC:ExportFilter     CSTRING(255)
LOC:TotalsString     CSTRING(100)
LOC:FilteredMatters  LONG
LOC:TaggedMatters    LONG
LOC:NumberOfMattersMessage CSTRING(75)
LOC:ToFrom           CSTRING(10)
LOC:Period1          CSTRING(20)
LOC:TargetLodgementDate LONG
LOC:ToDoNoteCreatedDateTime CSTRING(25)
LOC:DaysTaken        LONG
LOC:DaysDiff         LONG
LOC:LAWToFrom        CSTRING(10)
LOC:LawRef           CSTRING(20)
LOC:LAW_DisplayOption STRING(1)
LOC:ConveyStatus     STRING(10)
LOC:LAW_Period       CSTRING(20)
LOC:LAW_Matter       CSTRING(10)
LOC:FileNoteEmployee CSTRING(50)
LOC:BondPropRecordId LONG
LOC:FNBExportedMessage CSTRING(100)
LOC:RatesExportedMessage STRING(100)
LOC:ABSAMatterMessageDesc CSTRING(31)
LOC:Branch           CSTRING(31)
LOC:Completed        CSTRING(21)
LOC:ProgressIndicator CSTRING(100)
LOC:ProgressText     CSTRING(100)
LOC:MessageIndicator STRING(10)
LOC:KorbitecMsgIDRef LONG
LOC:ColDebitWording  CSTRING(5)
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
LOC:ABSA_DG_Code     CSTRING(6)
LOC:ABSA_Direction   CSTRING(11)
LOC:LinkedMatterRef  STRING(50)
LOC:GuaranteesIssued CSTRING(20)
LOC:GHUBLicensed     BYTE
LOC:ABSAExportedMessage CSTRING(50)


LOC:FNB_Period      CSTRING(20)
LOC:FNB_Matter      CSTRING(10)
LOC:FNB_ToDate      LONG
LOC:FNB_FromDate    LONG
SAV:FNB_ToDate      LONG
SAV:FNB_FromDate    LONG
SAV:FNB_Matter      CSTRING(10)
SAV:FNB_Period      CSTRING(20)

LOC:AG_Suite_DescList      CSTRING(1001)





LOC:SARS_ActionDate  LONG
LOC:SARS_Period      CSTRING(20)
LOC:SARS_Matter      CSTRING(10)
LOC:SARS_ToDate      LONG
LOC:SARS_FromDate    LONG
SAV:SARS_ToDate      LONG
SAV:SARS_FromDate    LONG
SAV:SARS_Matter      CSTRING(10)
SAV:SARS_Period      CSTRING(20)



LOC:ABSA_Matter      CSTRING(10)
LOC:ABSA_Period      CSTRING(20)
LOC:ABSA_ToDate      LONG
LOC:ABSA_FromDate    LONG
SAV:ABSA_Matter      CSTRING(10)
SAV:ABSA_Period      CSTRING(20)
SAV:ABSA_DG_Code     LIKE(DG1:Code)
SAV:ABSA_Direction   CSTRING(11)
SAV:ABSA_ToDate      LONG
SAV:ABSA_FromDate    LONG


LOC:MA_CostCentre    CSTRING(50)

LOC:FilteredFileNotes  LONG
LOC:TaggedFileNotes    LONG
LOC:FilteredReminders  LONG
LOC:TaggedReminders    LONG
LOC:FilteredFeeNotes   LONG
LOC:FilteredMatActivs  LONG
LOC:FilteredLawMatterMessages  LONG

LOC:FilterFeenoteSQLString  LIKE(LOC:FilterFeenoteString)

SAV:PostedOption        LIKE(LOC:PostedOption)
SAV:TOD_Status LIKE(LOC:TOD_Status)
SAV:TOD_CriticalStep LIKE(LOC:TOD_CriticalStep)
SAV:FIL_Status LIKE(LOC:FIL_Status)
SAV:MA_BilledFlag LIKE(LOC:MA_BilledFlag)

FN_Employee:Queue   QUEUE,PRE(FNQ)
Name              LIKE(EMP:Name)
RecordID          LIKE(EMP:RecordID)
                    END
FN_CostCentre:Queue   QUEUE,PRE(FNCCQ)
Description       LIKE(COS:Description)
RecordID          LIKE(COS:RecordID)
                    END
MA_CostCentre:Queue   QUEUE,PRE(MACCQ)
Description       LIKE(COS:Description)
RecordID          LIKE(COS:RecordID)
                    END
FIL_Employee:Queue   QUEUE,PRE(FILQ)
Name              LIKE(EMP:Name)
RecordID          LIKE(EMP:RecordID)
                    END
TOD_Employee:Queue   QUEUE,PRE(TODQ)
Name              LIKE(EMP:Name)
RecordID          LIKE(EMP:RecordID)
                    END
TOD_CriticalStep:Queue   QUEUE,PRE(CRIQ)
Description       LIKE(CRI:Description)
RecordID          LIKE(CRI:RecordID)
                    END

MA_Employee:Queue   QUEUE,PRE(MAQ)
Name              LIKE(EMP:Name)
RecordID          LIKE(EMP:RecordID)
                    END
MA_Activity:Queue   QUEUE,PRE(ACTQ)
Description        LIKE(ACT:Description)
RecordID           LIKE(ACT:RecordID)
                    END
AG_Division:Queue QUEUE,PRE(AGDQ)
Description         LIKE(LAW_SUI:Description)
SuiteId             LIKE(LAW_SUI:SuiteID)
                  END

SAV:LOC:FilterMatterString LIKE(LOC:FilterMatterString)
SAV:LOC:TaggedMatterList   LIKE(LOC:TaggedMatterList)

LOC:SortKey54                   SHORT          !Current column being sorted
SAV:SortKey54                   SHORT          !Current column being sorted
LOC:PreSortKey54                SHORT          !Previous column sorted
LOC:PreHeader54                 CSTRING(30)
LOC:SortKey52                   SHORT          !Current column being sorted
SAV:SortKey52                   SHORT          !Current column being sorted
LOC:PreSortKey52                SHORT          !Previous column sorted
LOC:PreHeader52                 CSTRING(30)
BRW54::View:Browse   VIEW(Matter)
                       PROJECT(MAT:FileRef)
                       PROJECT(MAT:AlternateRef)
                       PROJECT(MAT:RecordID)
                       PROJECT(MAT:Description)
                       PROJECT(MAT:LawRef)
                       PROJECT(MAT:DateInstructed)
                       PROJECT(MAT:DebtorsBalance)
                       PROJECT(MAT:ArchiveFlag)
                       PROJECT(MAT:ArchiveNo)
                       PROJECT(MAT:ArchiveStatus)
                       PROJECT(MAT:ToDoGroupID)
                       PROJECT(MAT:ConveyancingStatusFlag)
                       PROJECT(MAT:MessageWaitingFlag)
                       PROJECT(MAT:FNBMatterState)
                       PROJECT(MAT:ConsolidatedFlag)
                       PROJECT(MAT:Actual)
                       PROJECT(MAT:Reserved)
                       PROJECT(MAT:Invested)
                       PROJECT(MAT:LawSuite)
                       PROJECT(MAT:ABSALinkFlag)
                       PROJECT(MAT:EmployeeID)
                       PROJECT(MAT:ArchiveDate)
                       PROJECT(MAT:NTURequestDate)
                       PROJECT(MAT:NTUReceiveDate)
                       PROJECT(MAT:CancelToReAssignDate)
                       PROJECT(MAT:LinkedMatterID)
                       PROJECT(MAT:MatterTypeID)
                       PROJECT(MAT:DocgenID)
                       PROJECT(MAT:ClientID)
                       JOIN(CONV:PrimaryKey,MAT:RecordID)
                         PROJECT(CONV:Step4Completed)
                         PROJECT(CONV:Step6Completed)
                       END
                       JOIN(MT:PrimaryKey,MAT:MatterTypeID)
                         PROJECT(MT:Description)
                         PROJECT(MT:RecordID)
                         PROJECT(MT:Color1)
                         PROJECT(MT:Color2)
                       END
                       JOIN(DG:PrimaryKey,MAT:DocgenID)
                         PROJECT(DG:Description)
                         PROJECT(DG:Type)
                         PROJECT(DG:RecordID)
                       END
                       JOIN(PAR:PrimaryKey,MAT:ClientID)
                         PROJECT(PAR:Name)
                         PROJECT(PAR:FICACompliantFlag)
                         PROJECT(PAR:RecordID)
                       END
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?MattersBrowse
Tag                    LIKE(Tag)                      !List box control field - type derived from local data
Tag_NormalFG           LONG                           !Normal forground color
Tag_NormalBG           LONG                           !Normal background color
Tag_SelectedFG         LONG                           !Selected forground color
Tag_SelectedBG         LONG                           !Selected background color
Tag_Icon               LONG                           !Entry's icon ID
LOC:MessageIndicator   LIKE(LOC:MessageIndicator)     !List box control field - type derived from local data
LOC:MessageIndicator_NormalFG LONG                    !Normal forground color
LOC:MessageIndicator_NormalBG LONG                    !Normal background color
LOC:MessageIndicator_SelectedFG LONG                  !Selected forground color
LOC:MessageIndicator_SelectedBG LONG                  !Selected background color
LOC:MessageIndicator_Icon LONG                        !Entry's icon ID
LOC:GuaranteesIssued   LIKE(LOC:GuaranteesIssued)     !List box control field - type derived from local data
LOC:GuaranteesIssued_NormalFG LONG                    !Normal forground color
LOC:GuaranteesIssued_NormalBG LONG                    !Normal background color
LOC:GuaranteesIssued_SelectedFG LONG                  !Selected forground color
LOC:GuaranteesIssued_SelectedBG LONG                  !Selected background color
LOC:ProgressIndicator  LIKE(LOC:ProgressIndicator)    !List box control field - type derived from local data
LOC:ProgressIndicator_NormalFG LONG                   !Normal forground color
LOC:ProgressIndicator_NormalBG LONG                   !Normal background color
LOC:ProgressIndicator_SelectedFG LONG                 !Selected forground color
LOC:ProgressIndicator_SelectedBG LONG                 !Selected background color
LOC:ProgressIndicator_Icon LONG                       !Entry's icon ID
MAT:FileRef            LIKE(MAT:FileRef)              !List box control field - type derived from field
MAT:FileRef_NormalFG   LONG                           !Normal forground color
MAT:FileRef_NormalBG   LONG                           !Normal background color
MAT:FileRef_SelectedFG LONG                           !Selected forground color
MAT:FileRef_SelectedBG LONG                           !Selected background color
LOC:ProgressText       LIKE(LOC:ProgressText)         !List box control field - type derived from local data
LOC:ProgressText_NormalFG LONG                        !Normal forground color
LOC:ProgressText_NormalBG LONG                        !Normal background color
LOC:ProgressText_SelectedFG LONG                      !Selected forground color
LOC:ProgressText_SelectedBG LONG                      !Selected background color
MAT:AlternateRef       LIKE(MAT:AlternateRef)         !List box control field - type derived from field
MAT:AlternateRef_NormalFG LONG                        !Normal forground color
MAT:AlternateRef_NormalBG LONG                        !Normal background color
MAT:AlternateRef_SelectedFG LONG                      !Selected forground color
MAT:AlternateRef_SelectedBG LONG                      !Selected background color
LOC:LinkedMatterRef    LIKE(LOC:LinkedMatterRef)      !List box control field - type derived from local data
LOC:LinkedMatterRef_NormalFG LONG                     !Normal forground color
LOC:LinkedMatterRef_NormalBG LONG                     !Normal background color
LOC:LinkedMatterRef_SelectedFG LONG                   !Selected forground color
LOC:LinkedMatterRef_SelectedBG LONG                   !Selected background color
MAT:RecordID           LIKE(MAT:RecordID)             !List box control field - type derived from field
MAT:RecordID_NormalFG  LONG                           !Normal forground color
MAT:RecordID_NormalBG  LONG                           !Normal background color
MAT:RecordID_SelectedFG LONG                          !Selected forground color
MAT:RecordID_SelectedBG LONG                          !Selected background color
LOC:FICAWords          LIKE(LOC:FICAWords)            !List box control field - type derived from local data
LOC:FICAWords_NormalFG LONG                           !Normal forground color
LOC:FICAWords_NormalBG LONG                           !Normal background color
LOC:FICAWords_SelectedFG LONG                         !Selected forground color
LOC:FICAWords_SelectedBG LONG                         !Selected background color
PAR:Name               LIKE(PAR:Name)                 !List box control field - type derived from field
PAR:Name_NormalFG      LONG                           !Normal forground color
PAR:Name_NormalBG      LONG                           !Normal background color
PAR:Name_SelectedFG    LONG                           !Selected forground color
PAR:Name_SelectedBG    LONG                           !Selected background color
MAT:Description        LIKE(MAT:Description)          !List box control field - type derived from field
MAT:Description_NormalFG LONG                         !Normal forground color
MAT:Description_NormalBG LONG                         !Normal background color
MAT:Description_SelectedFG LONG                       !Selected forground color
MAT:Description_SelectedBG LONG                       !Selected background color
MAT:LawRef             LIKE(MAT:LawRef)               !List box control field - type derived from field
MAT:LawRef_NormalFG    LONG                           !Normal forground color
MAT:LawRef_NormalBG    LONG                           !Normal background color
MAT:LawRef_SelectedFG  LONG                           !Selected forground color
MAT:LawRef_SelectedBG  LONG                           !Selected background color
MT:Description         LIKE(MT:Description)           !List box control field - type derived from field
MT:Description_NormalFG LONG                          !Normal forground color
MT:Description_NormalBG LONG                          !Normal background color
MT:Description_SelectedFG LONG                        !Selected forground color
MT:Description_SelectedBG LONG                        !Selected background color
DG:Description         LIKE(DG:Description)           !List box control field - type derived from field
DG:Description_NormalFG LONG                          !Normal forground color
DG:Description_NormalBG LONG                          !Normal background color
DG:Description_SelectedFG LONG                        !Selected forground color
DG:Description_SelectedBG LONG                        !Selected background color
LOC:Employee           LIKE(LOC:Employee)             !List box control field - type derived from local data
LOC:Employee_NormalFG  LONG                           !Normal forground color
LOC:Employee_NormalBG  LONG                           !Normal background color
LOC:Employee_SelectedFG LONG                          !Selected forground color
LOC:Employee_SelectedBG LONG                          !Selected background color
MAT:DateInstructed     LIKE(MAT:DateInstructed)       !List box control field - type derived from field
MAT:DateInstructed_NormalFG LONG                      !Normal forground color
MAT:DateInstructed_NormalBG LONG                      !Normal background color
MAT:DateInstructed_SelectedFG LONG                    !Selected forground color
MAT:DateInstructed_SelectedBG LONG                    !Selected background color
LOC:Status             LIKE(LOC:Status)               !List box control field - type derived from local data
LOC:Status_NormalFG    LONG                           !Normal forground color
LOC:Status_NormalBG    LONG                           !Normal background color
LOC:Status_SelectedFG  LONG                           !Selected forground color
LOC:Status_SelectedBG  LONG                           !Selected background color
MAT:DebtorsBalance     LIKE(MAT:DebtorsBalance)       !List box control field - type derived from field
MAT:DebtorsBalance_NormalFG LONG                      !Normal forground color
MAT:DebtorsBalance_NormalBG LONG                      !Normal background color
MAT:DebtorsBalance_SelectedFG LONG                    !Selected forground color
MAT:DebtorsBalance_SelectedBG LONG                    !Selected background color
MT:RecordID            LIKE(MT:RecordID)              !Browse hot field - type derived from field
MT:Color1              LIKE(MT:Color1)                !Browse hot field - type derived from field
MT:Color2              LIKE(MT:Color2)                !Browse hot field - type derived from field
MAT:ArchiveFlag        LIKE(MAT:ArchiveFlag)          !Browse hot field - type derived from field
MAT:ArchiveNo          LIKE(MAT:ArchiveNo)            !Browse hot field - type derived from field
MAT:ArchiveStatus      LIKE(MAT:ArchiveStatus)        !Browse hot field - type derived from field
STA:RecordID           LIKE(STA:RecordID)             !Browse hot field - type derived from field
MAT:ToDoGroupID        LIKE(MAT:ToDoGroupID)          !Browse hot field - type derived from field
PAR:FICACompliantFlag  LIKE(PAR:FICACompliantFlag)    !Browse hot field - type derived from field
LAW_MAT:LawRef         LIKE(LAW_MAT:LawRef)           !Browse hot field - type derived from field
MAT:ConveyancingStatusFlag LIKE(MAT:ConveyancingStatusFlag) !Browse hot field - type derived from field
MAT:MessageWaitingFlag LIKE(MAT:MessageWaitingFlag)   !Browse hot field - type derived from field
MAT:FNBMatterState     LIKE(MAT:FNBMatterState)       !Browse hot field - type derived from field
MAT:ConsolidatedFlag   LIKE(MAT:ConsolidatedFlag)     !Browse hot field - type derived from field
MAT:Actual             LIKE(MAT:Actual)               !Browse hot field - type derived from field
MAT:Reserved           LIKE(MAT:Reserved)             !Browse hot field - type derived from field
MAT:Invested           LIKE(MAT:Invested)             !Browse hot field - type derived from field
MAT:LawSuite           LIKE(MAT:LawSuite)             !Browse hot field - type derived from field
MAT:ABSALinkFlag       LIKE(MAT:ABSALinkFlag)         !Browse hot field - type derived from field
CONV:Step4Completed    LIKE(CONV:Step4Completed)      !Browse hot field - type derived from field
CONV:Step6Completed    LIKE(CONV:Step6Completed)      !Browse hot field - type derived from field
MAT:EmployeeID         LIKE(MAT:EmployeeID)           !Browse hot field - type derived from field
DG:Type                LIKE(DG:Type)                  !Browse hot field - type derived from field
MAT:ArchiveDate        LIKE(MAT:ArchiveDate)          !Browse hot field - type derived from field
MAT:NTURequestDate     LIKE(MAT:NTURequestDate)       !Browse hot field - type derived from field
MAT:NTUReceiveDate     LIKE(MAT:NTUReceiveDate)       !Browse hot field - type derived from field
MAT:CancelToReAssignDate LIKE(MAT:CancelToReAssignDate) !Browse hot field - type derived from field
MAT:LinkedMatterID     LIKE(MAT:LinkedMatterID)       !Browse hot field - type derived from field
MAT3:RecordID          LIKE(MAT3:RecordID)            !Browse hot field - type derived from field
DG:RecordID            LIKE(DG:RecordID)              !Related join file key field - type derived from field
PAR:RecordID           LIKE(PAR:RecordID)             !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW52::View:Browse   VIEW(FileNote)
                       PROJECT(FIL:Date)
                       PROJECT(FIL:Description)
                       PROJECT(FIL:InternalFlag)
                       PROJECT(FIL:EmployeeID)
                       PROJECT(FIL:FeeNoteID)
                       PROJECT(FIL:Color)
                       PROJECT(FIL:RecordID)
                       PROJECT(FIL:Time)
                       PROJECT(FIL:MatterID)
                       PROJECT(FIL:StageID)
                       JOIN(STA:PrimaryKey,FIL:StageID)
                         PROJECT(STA:Code)
                         PROJECT(STA:LargeIconFileName)
                         PROJECT(STA:SmallIconFileName)
                         PROJECT(STA:RecordID)
                       END
                       JOIN(MAT1:PrimaryKey,FIL:MatterID)
                         PROJECT(MAT1:FileRef)
                         PROJECT(MAT1:Description)
                         PROJECT(MAT1:Access)
                         PROJECT(MAT1:EmployeeID)
                         PROJECT(MAT1:RecordID)
                       END
                     END
Queue:Browse:4       QUEUE                            !Queue declaration for browse/combo box using ?FileNoteBrowse
Tag                    LIKE(Tag)                      !List box control field - type derived from local data
Tag_NormalFG           LONG                           !Normal forground color
Tag_NormalBG           LONG                           !Normal background color
Tag_SelectedFG         LONG                           !Selected forground color
Tag_SelectedBG         LONG                           !Selected background color
Tag_Icon               LONG                           !Entry's icon ID
LOC:ProgressIndicator  LIKE(LOC:ProgressIndicator)    !List box control field - type derived from local data
LOC:ProgressIndicator_NormalFG LONG                   !Normal forground color
LOC:ProgressIndicator_NormalBG LONG                   !Normal background color
LOC:ProgressIndicator_SelectedFG LONG                 !Selected forground color
LOC:ProgressIndicator_SelectedBG LONG                 !Selected background color
LOC:ProgressIndicator_Icon LONG                       !Entry's icon ID
LOC:FileNotePostedFlag LIKE(LOC:FileNotePostedFlag)   !List box control field - type derived from local data
LOC:FileNotePostedFlag_NormalFG LONG                  !Normal forground color
LOC:FileNotePostedFlag_NormalBG LONG                  !Normal background color
LOC:FileNotePostedFlag_SelectedFG LONG                !Selected forground color
LOC:FileNotePostedFlag_SelectedBG LONG                !Selected background color
LOC:FileNotePostedFlag_Icon LONG                      !Entry's icon ID
FIL:Date               LIKE(FIL:Date)                 !List box control field - type derived from field
FIL:Date_NormalFG      LONG                           !Normal forground color
FIL:Date_NormalBG      LONG                           !Normal background color
FIL:Date_SelectedFG    LONG                           !Selected forground color
FIL:Date_SelectedBG    LONG                           !Selected background color
MAT1:FileRef           LIKE(MAT1:FileRef)             !List box control field - type derived from field
MAT1:FileRef_NormalFG  LONG                           !Normal forground color
MAT1:FileRef_NormalBG  LONG                           !Normal background color
MAT1:FileRef_SelectedFG LONG                          !Selected forground color
MAT1:FileRef_SelectedBG LONG                          !Selected background color
MAT1:Description       LIKE(MAT1:Description)         !List box control field - type derived from field
MAT1:Description_NormalFG LONG                        !Normal forground color
MAT1:Description_NormalBG LONG                        !Normal background color
MAT1:Description_SelectedFG LONG                      !Selected forground color
MAT1:Description_SelectedBG LONG                      !Selected background color
STA:Code               LIKE(STA:Code)                 !List box control field - type derived from field
STA:Code_NormalFG      LONG                           !Normal forground color
STA:Code_NormalBG      LONG                           !Normal background color
STA:Code_SelectedFG    LONG                           !Selected forground color
STA:Code_SelectedBG    LONG                           !Selected background color
FIL:Description        LIKE(FIL:Description)          !List box control field - type derived from field
FIL:Description_NormalFG LONG                         !Normal forground color
FIL:Description_NormalBG LONG                         !Normal background color
FIL:Description_SelectedFG LONG                       !Selected forground color
FIL:Description_SelectedBG LONG                       !Selected background color
LOC:Employee           LIKE(LOC:Employee)             !List box control field - type derived from local data
LOC:Employee_NormalFG  LONG                           !Normal forground color
LOC:Employee_NormalBG  LONG                           !Normal background color
LOC:Employee_SelectedFG LONG                          !Selected forground color
LOC:Employee_SelectedBG LONG                          !Selected background color
STA:LargeIconFileName  LIKE(STA:LargeIconFileName)    !Browse hot field - type derived from field
STA:SmallIconFileName  LIKE(STA:SmallIconFileName)    !Browse hot field - type derived from field
FIL:InternalFlag       LIKE(FIL:InternalFlag)         !Browse hot field - type derived from field
MAT1:Access            LIKE(MAT1:Access)              !Browse hot field - type derived from field
MAT1:EmployeeID        LIKE(MAT1:EmployeeID)          !Browse hot field - type derived from field
FIL:EmployeeID         LIKE(FIL:EmployeeID)           !Browse hot field - type derived from field
FIL:FeeNoteID          LIKE(FIL:FeeNoteID)            !Browse hot field - type derived from field
FIL:Color              LIKE(FIL:Color)                !Browse hot field - type derived from field
FIL:RecordID           LIKE(FIL:RecordID)             !Primary key field - type derived from field
FIL:Time               LIKE(FIL:Time)                 !Browse key field - type derived from field
FIL:MatterID           LIKE(FIL:MatterID)             !Browse key field - type derived from field
STA:RecordID           LIKE(STA:RecordID)             !Related join file key field - type derived from field
MAT1:RecordID          LIKE(MAT1:RecordID)            !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW2::View:Browse    VIEW(FeeNote)
                       PROJECT(FN:Date)
                       PROJECT(FN:VatAmount)
                       PROJECT(FN:AmountIncl)
                       PROJECT(FN:CapturedPeriod)
                       PROJECT(FN:Voucher)
                       PROJECT(FN:PostedDate)
                       PROJECT(FN:PostedBatchId)
                       PROJECT(FN:RecordID)
                       PROJECT(FN:UnitFlag)
                       PROJECT(FN:UnitText)
                       PROJECT(FN:UnitQuantity)
                       PROJECT(FN:Description)
                       PROJECT(FN:Type1)
                       PROJECT(FN:EmployeeID)
                       PROJECT(FN:OnHold)
                       PROJECT(FN:Amount)
                       PROJECT(FN:VATRate)
                       PROJECT(FN:VATIE)
                       PROJECT(FN:ColDebitId)
                       PROJECT(FN:PostedFlag)
                       PROJECT(FN:CombinedQuantity)
                       PROJECT(FN:MatterID)
                       PROJECT(FN:CombinedFlag)
                       PROJECT(FN:Sorter)
                       PROJECT(FN:CostCentreId)
                       JOIN(MAT1:PrimaryKey,FN:MatterID)
                         PROJECT(MAT1:FileRef)
                         PROJECT(MAT1:Description)
                         PROJECT(MAT1:FeeNotesOnHold)
                         PROJECT(MAT1:EmployeeID)
                         PROJECT(MAT1:Access)
                         PROJECT(MAT1:RecordID)
                         PROJECT(MAT1:ClientID)
                         JOIN(PAR1:PrimaryKey,MAT1:ClientID)
                           PROJECT(PAR1:Name)
                           PROJECT(PAR1:RecordID)
                         END
                       END
                       JOIN(COS:PrimaryKey,FN:CostCentreId)
                         PROJECT(COS:Description)
                         PROJECT(COS:RecordID)
                       END
                     END
Queue:Browse         QUEUE                            !Queue declaration for browse/combo box using ?FeeNoteBrowse
Tag                    LIKE(Tag)                      !List box control field - type derived from local data
Tag_NormalFG           LONG                           !Normal forground color
Tag_NormalBG           LONG                           !Normal background color
Tag_SelectedFG         LONG                           !Selected forground color
Tag_SelectedBG         LONG                           !Selected background color
Tag_Icon               LONG                           !Entry's icon ID
LOC:OnHold             LIKE(LOC:OnHold)               !List box control field - type derived from local data
LOC:OnHold_NormalFG    LONG                           !Normal forground color
LOC:OnHold_NormalBG    LONG                           !Normal background color
LOC:OnHold_SelectedFG  LONG                           !Selected forground color
LOC:OnHold_SelectedBG  LONG                           !Selected background color
LOC:OnHold_Icon        LONG                           !Entry's icon ID
LOC:PostedFlag         LIKE(LOC:PostedFlag)           !List box control field - type derived from local data
LOC:PostedFlag_NormalFG LONG                          !Normal forground color
LOC:PostedFlag_NormalBG LONG                          !Normal background color
LOC:PostedFlag_SelectedFG LONG                        !Selected forground color
LOC:PostedFlag_SelectedBG LONG                        !Selected background color
LOC:PostedFlag_Icon    LONG                           !Entry's icon ID
FN:Date                LIKE(FN:Date)                  !List box control field - type derived from field
FN:Date_NormalFG       LONG                           !Normal forground color
FN:Date_NormalBG       LONG                           !Normal background color
FN:Date_SelectedFG     LONG                           !Selected forground color
FN:Date_SelectedBG     LONG                           !Selected background color
MAT1:FileRef           LIKE(MAT1:FileRef)             !List box control field - type derived from field
MAT1:FileRef_NormalFG  LONG                           !Normal forground color
MAT1:FileRef_NormalBG  LONG                           !Normal background color
MAT1:FileRef_SelectedFG LONG                          !Selected forground color
MAT1:FileRef_SelectedBG LONG                          !Selected background color
MAT1:Description       LIKE(MAT1:Description)         !List box control field - type derived from field
MAT1:Description_NormalFG LONG                        !Normal forground color
MAT1:Description_NormalBG LONG                        !Normal background color
MAT1:Description_SelectedFG LONG                      !Selected forground color
MAT1:Description_SelectedBG LONG                      !Selected background color
PAR1:Name              LIKE(PAR1:Name)                !List box control field - type derived from field
PAR1:Name_NormalFG     LONG                           !Normal forground color
PAR1:Name_NormalBG     LONG                           !Normal background color
PAR1:Name_SelectedFG   LONG                           !Selected forground color
PAR1:Name_SelectedBG   LONG                           !Selected background color
LOC:FeeDescription     LIKE(LOC:FeeDescription)       !List box control field - type derived from local data
LOC:FeeDescription_NormalFG LONG                      !Normal forground color
LOC:FeeDescription_NormalBG LONG                      !Normal background color
LOC:FeeDescription_SelectedFG LONG                    !Selected forground color
LOC:FeeDescription_SelectedBG LONG                    !Selected background color
LOC:FN:AmountExcl      LIKE(LOC:FN:AmountExcl)        !List box control field - type derived from local data
LOC:FN:AmountExcl_NormalFG LONG                       !Normal forground color
LOC:FN:AmountExcl_NormalBG LONG                       !Normal background color
LOC:FN:AmountExcl_SelectedFG LONG                     !Selected forground color
LOC:FN:AmountExcl_SelectedBG LONG                     !Selected background color
FN:VatAmount           LIKE(FN:VatAmount)             !List box control field - type derived from field
FN:VatAmount_NormalFG  LONG                           !Normal forground color
FN:VatAmount_NormalBG  LONG                           !Normal background color
FN:VatAmount_SelectedFG LONG                          !Selected forground color
FN:VatAmount_SelectedBG LONG                          !Selected background color
FN:AmountIncl          LIKE(FN:AmountIncl)            !List box control field - type derived from field
FN:AmountIncl_NormalFG LONG                           !Normal forground color
FN:AmountIncl_NormalBG LONG                           !Normal background color
FN:AmountIncl_SelectedFG LONG                         !Selected forground color
FN:AmountIncl_SelectedBG LONG                         !Selected background color
FN:CapturedPeriod      LIKE(FN:CapturedPeriod)        !List box control field - type derived from field
FN:CapturedPeriod_NormalFG LONG                       !Normal forground color
FN:CapturedPeriod_NormalBG LONG                       !Normal background color
FN:CapturedPeriod_SelectedFG LONG                     !Selected forground color
FN:CapturedPeriod_SelectedBG LONG                     !Selected background color
LOC:FN:VatDesc         LIKE(LOC:FN:VatDesc)           !List box control field - type derived from local data
LOC:FN:VatDesc_NormalFG LONG                          !Normal forground color
LOC:FN:VatDesc_NormalBG LONG                          !Normal background color
LOC:FN:VatDesc_SelectedFG LONG                        !Selected forground color
LOC:FN:VatDesc_SelectedBG LONG                        !Selected background color
LOC:Employee           LIKE(LOC:Employee)             !List box control field - type derived from local data
LOC:Employee_NormalFG  LONG                           !Normal forground color
LOC:Employee_NormalBG  LONG                           !Normal background color
LOC:Employee_SelectedFG LONG                          !Selected forground color
LOC:Employee_SelectedBG LONG                          !Selected background color
FN:Voucher             LIKE(FN:Voucher)               !List box control field - type derived from field
FN:Voucher_NormalFG    LONG                           !Normal forground color
FN:Voucher_NormalBG    LONG                           !Normal background color
FN:Voucher_SelectedFG  LONG                           !Selected forground color
FN:Voucher_SelectedBG  LONG                           !Selected background color
COS:Description        LIKE(COS:Description)          !List box control field - type derived from field
COS:Description_NormalFG LONG                         !Normal forground color
COS:Description_NormalBG LONG                         !Normal background color
COS:Description_SelectedFG LONG                       !Selected forground color
COS:Description_SelectedBG LONG                       !Selected background color
LOC:ColDebitWording    LIKE(LOC:ColDebitWording)      !List box control field - type derived from local data
LOC:ColDebitWording_NormalFG LONG                     !Normal forground color
LOC:ColDebitWording_NormalBG LONG                     !Normal background color
LOC:ColDebitWording_SelectedFG LONG                   !Selected forground color
LOC:ColDebitWording_SelectedBG LONG                   !Selected background color
FN:PostedDate          LIKE(FN:PostedDate)            !List box control field - type derived from field
FN:PostedDate_NormalFG LONG                           !Normal forground color
FN:PostedDate_NormalBG LONG                           !Normal background color
FN:PostedDate_SelectedFG LONG                         !Selected forground color
FN:PostedDate_SelectedBG LONG                         !Selected background color
FN:PostedBatchId       LIKE(FN:PostedBatchId)         !List box control field - type derived from field
FN:PostedBatchId_NormalFG LONG                        !Normal forground color
FN:PostedBatchId_NormalBG LONG                        !Normal background color
FN:PostedBatchId_SelectedFG LONG                      !Selected forground color
FN:PostedBatchId_SelectedBG LONG                      !Selected background color
FN:RecordID            LIKE(FN:RecordID)              !Browse hot field - type derived from field
FN:UnitFlag            LIKE(FN:UnitFlag)              !Browse hot field - type derived from field
FN:UnitText            LIKE(FN:UnitText)              !Browse hot field - type derived from field
FN:UnitQuantity        LIKE(FN:UnitQuantity)          !Browse hot field - type derived from field
FN:Description         LIKE(FN:Description)           !Browse hot field - type derived from field
FN:Type1               LIKE(FN:Type1)                 !Browse hot field - type derived from field
FN:EmployeeID          LIKE(FN:EmployeeID)            !Browse hot field - type derived from field
MAT1:FeeNotesOnHold    LIKE(MAT1:FeeNotesOnHold)      !Browse hot field - type derived from field
FN:OnHold              LIKE(FN:OnHold)                !Browse hot field - type derived from field
FN:Amount              LIKE(FN:Amount)                !Browse hot field - type derived from field
FN:VATRate             LIKE(FN:VATRate)               !Browse hot field - type derived from field
FN:VATIE               LIKE(FN:VATIE)                 !Browse hot field - type derived from field
FN:ColDebitId          LIKE(FN:ColDebitId)            !Browse hot field - type derived from field
FN:PostedFlag          LIKE(FN:PostedFlag)            !Browse hot field - type derived from field
FN:CombinedQuantity    LIKE(FN:CombinedQuantity)      !Browse hot field - type derived from field
FN:MatterID            LIKE(FN:MatterID)              !Browse hot field - type derived from field
FN:CombinedFlag        LIKE(FN:CombinedFlag)          !Browse hot field - type derived from field
MAT1:EmployeeID        LIKE(MAT1:EmployeeID)          !Browse hot field - type derived from field
MAT1:Access            LIKE(MAT1:Access)              !Browse hot field - type derived from field
FN:Sorter              LIKE(FN:Sorter)                !Browse key field - type derived from field
MAT1:RecordID          LIKE(MAT1:RecordID)            !Related join file key field - type derived from field
PAR1:RecordID          LIKE(PAR1:RecordID)            !Related join file key field - type derived from field
COS:RecordID           LIKE(COS:RecordID)             !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW15::View:Browse   VIEW(ToDoNote)
                       PROJECT(TOD:Date)
                       PROJECT(TOD:Description)
                       PROJECT(TOD:DateDone)
                       PROJECT(TOD:CompletedTime)
                       PROJECT(TOD:CreatedDate)
                       PROJECT(TOD:CreatedTime)
                       PROJECT(TOD:AutoNotifyDate)
                       PROJECT(TOD:ToDoItemID)
                       PROJECT(TOD:PartyID)
                       PROJECT(TOD:DateAdjustment)
                       PROJECT(TOD:EmployeeID)
                       PROJECT(TOD:Priority)
                       PROJECT(TOD:RecordID)
                       PROJECT(TOD:MatterID)
                       PROJECT(TOD:NextDocumentID)
                       JOIN(MAT1:PrimaryKey,TOD:MatterID)
                         PROJECT(MAT1:FileRef)
                         PROJECT(MAT1:Description)
                         PROJECT(MAT1:DateInstructed)
                         PROJECT(MAT1:RecordID)
                       END
                       JOIN(TOI:PrimaryKey,TOD:ToDoItemID)
                         PROJECT(TOI:Code)
                         PROJECT(TOI:WebLinkMessage)
                         PROJECT(TOI:FNBMessageNo)
                         PROJECT(TOI:CriticalStep)
                         PROJECT(TOI:AutoNotifyFlag)
                         PROJECT(TOI:AutoNotifyMessage)
                         PROJECT(TOI:Description)
                         PROJECT(TOI:BaseDateOption)
                         PROJECT(TOI:Days)
                         PROJECT(TOI:BaseDateOptionOther)
                         PROJECT(TOI:BeforeAfterOption)
                         PROJECT(TOI:BaseDateOtherID)
                         PROJECT(TOI:RecordID)
                         JOIN(CRI:PrimaryKey,TOI:CriticalStep)
                           PROJECT(CRI:LargeIconFileName)
                           PROJECT(CRI:RecordID)
                           PROJECT(CRI:SmallIconFileName)
                         END
                       END
                       JOIN(DOC:PrimaryKey,TOD:NextDocumentID)
                         PROJECT(DOC:Description)
                         PROJECT(DOC:RecordID)
                       END
                     END
Queue:Browse:3       QUEUE                            !Queue declaration for browse/combo box using ?ToDoNoteBrowse
Tag                    LIKE(Tag)                      !List box control field - type derived from local data
Tag_NormalFG           LONG                           !Normal forground color
Tag_NormalBG           LONG                           !Normal background color
Tag_SelectedFG         LONG                           !Selected forground color
Tag_SelectedBG         LONG                           !Selected background color
Tag_Icon               LONG                           !Entry's icon ID
LOC:ProgressIndicator  LIKE(LOC:ProgressIndicator)    !List box control field - type derived from local data
LOC:ProgressIndicator_NormalFG LONG                   !Normal forground color
LOC:ProgressIndicator_NormalBG LONG                   !Normal background color
LOC:ProgressIndicator_SelectedFG LONG                 !Selected forground color
LOC:ProgressIndicator_SelectedBG LONG                 !Selected background color
LOC:ProgressIndicator_Icon LONG                       !Entry's icon ID
TOD:Date               LIKE(TOD:Date)                 !List box control field - type derived from field
TOD:Date_NormalFG      LONG                           !Normal forground color
TOD:Date_NormalBG      LONG                           !Normal background color
TOD:Date_SelectedFG    LONG                           !Selected forground color
TOD:Date_SelectedBG    LONG                           !Selected background color
MAT1:FileRef           LIKE(MAT1:FileRef)             !List box control field - type derived from field
MAT1:FileRef_NormalFG  LONG                           !Normal forground color
MAT1:FileRef_NormalBG  LONG                           !Normal background color
MAT1:FileRef_SelectedFG LONG                          !Selected forground color
MAT1:FileRef_SelectedBG LONG                          !Selected background color
MAT1:Description       LIKE(MAT1:Description)         !List box control field - type derived from field
MAT1:Description_NormalFG LONG                        !Normal forground color
MAT1:Description_NormalBG LONG                        !Normal background color
MAT1:Description_SelectedFG LONG                      !Selected forground color
MAT1:Description_SelectedBG LONG                      !Selected background color
TOD:Description        LIKE(TOD:Description)          !List box control field - type derived from field
TOD:Description_NormalFG LONG                         !Normal forground color
TOD:Description_NormalBG LONG                         !Normal background color
TOD:Description_SelectedFG LONG                       !Selected forground color
TOD:Description_SelectedBG LONG                       !Selected background color
LOC:Employee           LIKE(LOC:Employee)             !List box control field - type derived from local data
LOC:Employee_NormalFG  LONG                           !Normal forground color
LOC:Employee_NormalBG  LONG                           !Normal background color
LOC:Employee_SelectedFG LONG                          !Selected forground color
LOC:Employee_SelectedBG LONG                          !Selected background color
TOD:DateDone           LIKE(TOD:DateDone)             !List box control field - type derived from field
TOD:DateDone_NormalFG  LONG                           !Normal forground color
TOD:DateDone_NormalBG  LONG                           !Normal background color
TOD:DateDone_SelectedFG LONG                          !Selected forground color
TOD:DateDone_SelectedBG LONG                          !Selected background color
TOD:CompletedTime      LIKE(TOD:CompletedTime)        !List box control field - type derived from field
TOD:CompletedTime_NormalFG LONG                       !Normal forground color
TOD:CompletedTime_NormalBG LONG                       !Normal background color
TOD:CompletedTime_SelectedFG LONG                     !Selected forground color
TOD:CompletedTime_SelectedBG LONG                     !Selected background color
LOC:DaysTaken          LIKE(LOC:DaysTaken)            !List box control field - type derived from local data
LOC:DaysTaken_NormalFG LONG                           !Normal forground color
LOC:DaysTaken_NormalBG LONG                           !Normal background color
LOC:DaysTaken_SelectedFG LONG                         !Selected forground color
LOC:DaysTaken_SelectedBG LONG                         !Selected background color
LOC:DaysDiff           LIKE(LOC:DaysDiff)             !List box control field - type derived from local data
LOC:DaysDiff_NormalFG  LONG                           !Normal forground color
LOC:DaysDiff_NormalBG  LONG                           !Normal background color
LOC:DaysDiff_SelectedFG LONG                          !Selected forground color
LOC:DaysDiff_SelectedBG LONG                          !Selected background color
TOD:CreatedDate        LIKE(TOD:CreatedDate)          !List box control field - type derived from field
TOD:CreatedDate_NormalFG LONG                         !Normal forground color
TOD:CreatedDate_NormalBG LONG                         !Normal background color
TOD:CreatedDate_SelectedFG LONG                       !Selected forground color
TOD:CreatedDate_SelectedBG LONG                       !Selected background color
TOD:CreatedTime        LIKE(TOD:CreatedTime)          !List box control field - type derived from field
TOD:CreatedTime_NormalFG LONG                         !Normal forground color
TOD:CreatedTime_NormalBG LONG                         !Normal background color
TOD:CreatedTime_SelectedFG LONG                       !Selected forground color
TOD:CreatedTime_SelectedBG LONG                       !Selected background color
DOC:Description        LIKE(DOC:Description)          !List box control field - type derived from field
DOC:Description_NormalFG LONG                         !Normal forground color
DOC:Description_NormalBG LONG                         !Normal background color
DOC:Description_SelectedFG LONG                       !Selected forground color
DOC:Description_SelectedBG LONG                       !Selected background color
TOI:Code               LIKE(TOI:Code)                 !List box control field - type derived from field
TOI:Code_NormalFG      LONG                           !Normal forground color
TOI:Code_NormalBG      LONG                           !Normal background color
TOI:Code_SelectedFG    LONG                           !Selected forground color
TOI:Code_SelectedBG    LONG                           !Selected background color
TOI:WebLinkMessage     LIKE(TOI:WebLinkMessage)       !List box control field - type derived from field
TOI:WebLinkMessage_NormalFG LONG                      !Normal forground color
TOI:WebLinkMessage_NormalBG LONG                      !Normal background color
TOI:WebLinkMessage_SelectedFG LONG                    !Selected forground color
TOI:WebLinkMessage_SelectedBG LONG                    !Selected background color
TOI:FNBMessageNo       LIKE(TOI:FNBMessageNo)         !List box control field - type derived from field
TOI:FNBMessageNo_NormalFG LONG                        !Normal forground color
TOI:FNBMessageNo_NormalBG LONG                        !Normal background color
TOI:FNBMessageNo_SelectedFG LONG                      !Selected forground color
TOI:FNBMessageNo_SelectedBG LONG                      !Selected background color
TOD:AutoNotifyDate     LIKE(TOD:AutoNotifyDate)       !Browse hot field - type derived from field
TOI:CriticalStep       LIKE(TOI:CriticalStep)         !Browse hot field - type derived from field
TOI:AutoNotifyFlag     LIKE(TOI:AutoNotifyFlag)       !Browse hot field - type derived from field
TOI:AutoNotifyMessage  LIKE(TOI:AutoNotifyMessage)    !Browse hot field - type derived from field
TOI:Description        LIKE(TOI:Description)          !Browse hot field - type derived from field
TOD:ToDoItemID         LIKE(TOD:ToDoItemID)           !Browse hot field - type derived from field
TOD:PartyID            LIKE(TOD:PartyID)              !Browse hot field - type derived from field
DOC:RecordID           LIKE(DOC:RecordID)             !Browse hot field - type derived from field
MAT1:DateInstructed    LIKE(MAT1:DateInstructed)      !Browse hot field - type derived from field
TOI:BaseDateOption     LIKE(TOI:BaseDateOption)       !Browse hot field - type derived from field
TOI:Days               LIKE(TOI:Days)                 !Browse hot field - type derived from field
TOI:BaseDateOptionOther LIKE(TOI:BaseDateOptionOther) !Browse hot field - type derived from field
TOI:BeforeAfterOption  LIKE(TOI:BeforeAfterOption)    !Browse hot field - type derived from field
TOI:BaseDateOtherID    LIKE(TOI:BaseDateOtherID)      !Browse hot field - type derived from field
TOD:DateAdjustment     LIKE(TOD:DateAdjustment)       !Browse hot field - type derived from field
TOD:EmployeeID         LIKE(TOD:EmployeeID)           !Browse hot field - type derived from field
CRI:LargeIconFileName  LIKE(CRI:LargeIconFileName)    !Browse hot field - type derived from field
CRI:RecordID           LIKE(CRI:RecordID)             !Browse hot field - type derived from field
CRI:SmallIconFileName  LIKE(CRI:SmallIconFileName)    !Browse hot field - type derived from field
TOD:Priority           LIKE(TOD:Priority)             !Browse hot field - type derived from field
TOD:RecordID           LIKE(TOD:RecordID)             !Primary key field - type derived from field
TOD:MatterID           LIKE(TOD:MatterID)             !Browse key field - type derived from field
MAT1:RecordID          LIKE(MAT1:RecordID)            !Related join file key field - type derived from field
TOI:RecordID           LIKE(TOI:RecordID)             !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW22::View:Browse   VIEW(MatActiv)
                       PROJECT(MA:Date)
                       PROJECT(MA:Description)
                       PROJECT(MA:BillableAmount)
                       PROJECT(MA:EmployeeID)
                       PROJECT(MA:MatterID)
                       PROJECT(MA:Sorter)
                       PROJECT(MA:BillableFlag)
                       PROJECT(MA:FeeNoteID)
                       PROJECT(MA:RecordID)
                       PROJECT(MA:Minutes)
                       PROJECT(MA:CostCentreID)
                       PROJECT(MA:ActivityID)
                       JOIN(FeeNoteAlias,'FN1:RecordID = MA:FeeNoteID')
                         PROJECT(FN1:PostedFlag)
                       END
                       JOIN(MAT1:PrimaryKey,MA:MatterID)
                         PROJECT(MAT1:FileRef)
                         PROJECT(MAT1:Description)
                         PROJECT(MAT1:EmployeeID)
                         PROJECT(MAT1:Access)
                         PROJECT(MAT1:RecordID)
                       END
                       JOIN(COS:PrimaryKey,MA:CostCentreID)
                         PROJECT(COS:Description)
                         PROJECT(COS:RecordID)
                       END
                       JOIN(ACT:PrimaryKey,MA:ActivityID)
                         PROJECT(ACT:Description)
                         PROJECT(ACT:RecordID)
                       END
                     END
Queue:Browse:5       QUEUE                            !Queue declaration for browse/combo box using ?TimeRecordingBrowse
Tag                    LIKE(Tag)                      !List box control field - type derived from local data
Tag_NormalFG           LONG                           !Normal forground color
Tag_NormalBG           LONG                           !Normal background color
Tag_SelectedFG         LONG                           !Selected forground color
Tag_SelectedBG         LONG                           !Selected background color
Tag_Icon               LONG                           !Entry's icon ID
LOC:Billable           LIKE(LOC:Billable)             !List box control field - type derived from local data
LOC:Billable_NormalFG  LONG                           !Normal forground color
LOC:Billable_NormalBG  LONG                           !Normal background color
LOC:Billable_SelectedFG LONG                          !Selected forground color
LOC:Billable_SelectedBG LONG                          !Selected background color
LOC:Billable_Icon      LONG                           !Entry's icon ID
MA:Date                LIKE(MA:Date)                  !List box control field - type derived from field
MA:Date_NormalFG       LONG                           !Normal forground color
MA:Date_NormalBG       LONG                           !Normal background color
MA:Date_SelectedFG     LONG                           !Selected forground color
MA:Date_SelectedBG     LONG                           !Selected background color
MAT1:FileRef           LIKE(MAT1:FileRef)             !List box control field - type derived from field
MAT1:FileRef_NormalFG  LONG                           !Normal forground color
MAT1:FileRef_NormalBG  LONG                           !Normal background color
MAT1:FileRef_SelectedFG LONG                          !Selected forground color
MAT1:FileRef_SelectedBG LONG                          !Selected background color
MAT1:Description       LIKE(MAT1:Description)         !List box control field - type derived from field
MAT1:Description_NormalFG LONG                        !Normal forground color
MAT1:Description_NormalBG LONG                        !Normal background color
MAT1:Description_SelectedFG LONG                      !Selected forground color
MAT1:Description_SelectedBG LONG                      !Selected background color
ACT:Description        LIKE(ACT:Description)          !List box control field - type derived from field
ACT:Description_NormalFG LONG                         !Normal forground color
ACT:Description_NormalBG LONG                         !Normal background color
ACT:Description_SelectedFG LONG                       !Selected forground color
ACT:Description_SelectedBG LONG                       !Selected background color
MA:Description         LIKE(MA:Description)           !List box control field - type derived from field
MA:Description_NormalFG LONG                          !Normal forground color
MA:Description_NormalBG LONG                          !Normal background color
MA:Description_SelectedFG LONG                        !Selected forground color
MA:Description_SelectedBG LONG                        !Selected background color
LOC:MA_HoursAndMinutes LIKE(LOC:MA_HoursAndMinutes)   !List box control field - type derived from local data
LOC:MA_HoursAndMinutes_NormalFG LONG                  !Normal forground color
LOC:MA_HoursAndMinutes_NormalBG LONG                  !Normal background color
LOC:MA_HoursAndMinutes_SelectedFG LONG                !Selected forground color
LOC:MA_HoursAndMinutes_SelectedBG LONG                !Selected background color
MA:BillableAmount      LIKE(MA:BillableAmount)        !List box control field - type derived from field
MA:BillableAmount_NormalFG LONG                       !Normal forground color
MA:BillableAmount_NormalBG LONG                       !Normal background color
MA:BillableAmount_SelectedFG LONG                     !Selected forground color
MA:BillableAmount_SelectedBG LONG                     !Selected background color
LOC:Employee           LIKE(LOC:Employee)             !List box control field - type derived from local data
LOC:Employee_NormalFG  LONG                           !Normal forground color
LOC:Employee_NormalBG  LONG                           !Normal background color
LOC:Employee_SelectedFG LONG                          !Selected forground color
LOC:Employee_SelectedBG LONG                          !Selected background color
COS:Description        LIKE(COS:Description)          !List box control field - type derived from field
COS:Description_NormalFG LONG                         !Normal forground color
COS:Description_NormalBG LONG                         !Normal background color
COS:Description_SelectedFG LONG                       !Selected forground color
COS:Description_SelectedBG LONG                       !Selected background color
MA:EmployeeID          LIKE(MA:EmployeeID)            !Browse hot field - type derived from field
MA:MatterID            LIKE(MA:MatterID)              !Browse hot field - type derived from field
MA:Sorter              LIKE(MA:Sorter)                !Browse hot field - type derived from field
MA:BillableFlag        LIKE(MA:BillableFlag)          !Browse hot field - type derived from field
MA:FeeNoteID           LIKE(MA:FeeNoteID)             !Browse hot field - type derived from field
MA:RecordID            LIKE(MA:RecordID)              !Browse hot field - type derived from field
MA:Minutes             LIKE(MA:Minutes)               !Browse hot field - type derived from field
MAT1:EmployeeID        LIKE(MAT1:EmployeeID)          !Browse hot field - type derived from field
MAT1:Access            LIKE(MAT1:Access)              !Browse hot field - type derived from field
FN1:PostedFlag         LIKE(FN1:PostedFlag)           !Browse hot field - type derived from field
MAT1:RecordID          LIKE(MAT1:RecordID)            !Related join file key field - type derived from field
COS:RecordID           LIKE(COS:RecordID)             !Related join file key field - type derived from field
ACT:RecordID           LIKE(ACT:RecordID)             !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW36::View:Browse   VIEW(LawMatterMessage)
                       PROJECT(MME:ClarionDate)
                       PROJECT(MME:FileName)
                       PROJECT(MME:WebServiceValidatorId)
                       PROJECT(MME:WebServiceValidatorStatus)
                       PROJECT(MME:RecordID)
                       PROJECT(MME:MatterID)
                       PROJECT(MME:Date)
                       PROJECT(MME:LAW_MessageID)
                       JOIN(MAT1:PrimaryKey,MME:MatterID)
                         PROJECT(MAT1:FileRef)
                         PROJECT(MAT1:Description)
                         PROJECT(MAT1:LawRef)
                         PROJECT(MAT1:RecordID)
                       END
                       JOIN(LAW_MSG:RecordIDKey,MME:LAW_MessageID)
                         PROJECT(LAW_MSG:Number)
                         PROJECT(LAW_MSG:Message)
                         PROJECT(LAW_MSG:Filter)
                         PROJECT(LAW_MSG:RecordID)
                       END
                     END
Queue:Browse:2       QUEUE                            !Queue declaration for browse/combo box using ?LawMatterMessageBrowse
Tag                    LIKE(Tag)                      !List box control field - type derived from local data
Tag_Icon               LONG                           !Entry's icon ID
MME:ClarionDate        LIKE(MME:ClarionDate)          !List box control field - type derived from field
MAT1:FileRef           LIKE(MAT1:FileRef)             !List box control field - type derived from field
MAT1:Description       LIKE(MAT1:Description)         !List box control field - type derived from field
MAT1:LawRef            LIKE(MAT1:LawRef)              !List box control field - type derived from field
LOC:ToFrom             LIKE(LOC:ToFrom)               !List box control field - type derived from local data
LAW_MSG:Number         LIKE(LAW_MSG:Number)           !List box control field - type derived from field
LAW_MSG:Message        LIKE(LAW_MSG:Message)          !List box control field - type derived from field
MME:FileName           LIKE(MME:FileName)             !List box control field - type derived from field
MME:WebServiceValidatorId LIKE(MME:WebServiceValidatorId) !List box control field - type derived from field
MME:WebServiceValidatorStatus LIKE(MME:WebServiceValidatorStatus) !List box control field - type derived from field
LAW_MSG:Filter         LIKE(LAW_MSG:Filter)           !Browse hot field - type derived from field
MME:RecordID           LIKE(MME:RecordID)             !Primary key field - type derived from field
MME:MatterID           LIKE(MME:MatterID)             !Browse key field - type derived from field
MME:Date               LIKE(MME:Date)                 !Browse key field - type derived from field
MAT1:RecordID          LIKE(MAT1:RecordID)            !Related join file key field - type derived from field
LAW_MSG:RecordID       LIKE(LAW_MSG:RecordID)         !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW46::View:Browse   VIEW(AG_MatterMessage)
                       PROJECT(AGMM:Date)
                       PROJECT(AGMM:Time)
                       PROJECT(AGMM:Details)
                       PROJECT(AGMM:EmployeeID)
                       PROJECT(AGMM:RecordID)
                       PROJECT(AGMM:MatterID)
                       PROJECT(AGMM:MessageID)
                       JOIN(AGM:PrimaryKey,AGMM:MessageID)
                         PROJECT(AGM:MessageID)
                         PROJECT(AGM:Description)
                         PROJECT(AGM:Direction)
                         PROJECT(AGM:RecordID)
                       END
                       JOIN(MAT1:PrimaryKey,AGMM:MatterID)
                         PROJECT(MAT1:FileRef)
                         PROJECT(MAT1:Description)
                         PROJECT(MAT1:BranchID)
                         PROJECT(MAT1:LawSuite)
                         PROJECT(MAT1:RecordID)
                         JOIN(LAW_SUI:SuiteKey,MAT1:LawSuite)
                           PROJECT(LAW_SUI:Description)
                           PROJECT(LAW_SUI:SuiteID)
                         END
                         JOIN(DocgenAlias,'DG1:RecordId = MAT1:DocGenId')
                           PROJECT(DG1:Code)
                         END
                       END
                     END
Queue:Browse:7       QUEUE                            !Queue declaration for browse/combo box using ?FNBLinkBrowse
AGMM:Date              LIKE(AGMM:Date)                !List box control field - type derived from field
AGMM:Time              LIKE(AGMM:Time)                !List box control field - type derived from field
MAT1:FileRef           LIKE(MAT1:FileRef)             !List box control field - type derived from field
MAT1:Description       LIKE(MAT1:Description)         !List box control field - type derived from field
LOC:Branch             LIKE(LOC:Branch)               !List box control field - type derived from local data
DG1:Code               LIKE(DG1:Code)                 !List box control field - type derived from field
LAW_SUI:Description    LIKE(LAW_SUI:Description)      !List box control field - type derived from field
LOC:Employee           LIKE(LOC:Employee)             !List box control field - type derived from local data
AGM:MessageID          LIKE(AGM:MessageID)            !List box control field - type derived from field
AGM:Description        LIKE(AGM:Description)          !List box control field - type derived from field
AGM:Direction          LIKE(AGM:Direction)            !List box control field - type derived from field
AGMM:Details           LIKE(AGMM:Details)             !List box control field - type derived from field
MAT1:BranchID          LIKE(MAT1:BranchID)            !Browse hot field - type derived from field
AGMM:EmployeeID        LIKE(AGMM:EmployeeID)          !Browse hot field - type derived from field
MAT1:LawSuite          LIKE(MAT1:LawSuite)            !Browse hot field - type derived from field
AGMM:RecordID          LIKE(AGMM:RecordID)            !Primary key field - type derived from field
AGMM:MatterID          LIKE(AGMM:MatterID)            !Browse key field - type derived from field
AGM:RecordID           LIKE(AGM:RecordID)             !Related join file key field - type derived from field
MAT1:RecordID          LIKE(MAT1:RecordID)            !Related join file key field - type derived from field
LAW_SUI:SuiteID        LIKE(LAW_SUI:SuiteID)          !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW35::View:Browse   VIEW(ABSA_MatterMessage)
                       PROJECT(ABMM:Date)
                       PROJECT(ABMM:Time)
                       PROJECT(ABMM:MessageNumber)
                       PROJECT(ABMM:MessageDescription)
                       PROJECT(ABMM:MessageDirection)
                       PROJECT(ABMM:Details)
                       PROJECT(ABMM:EmployeeID)
                       PROJECT(ABMM:RecordID)
                       PROJECT(ABMM:MatterID)
                       JOIN(MAT1:PrimaryKey,ABMM:MatterID)
                         PROJECT(MAT1:FileRef)
                         PROJECT(MAT1:Description)
                         PROJECT(MAT1:BranchID)
                         PROJECT(MAT1:RecordID)
                         JOIN(DocgenAlias,'DG1:RecordId = MAT1:DocGenId')
                           PROJECT(DG1:Code)
                         END
                       END
                     END
Queue:Browse:9       QUEUE                            !Queue declaration for browse/combo box using ?ABSALinkBrowse
ABMM:Date              LIKE(ABMM:Date)                !List box control field - type derived from field
ABMM:Time              LIKE(ABMM:Time)                !List box control field - type derived from field
MAT1:FileRef           LIKE(MAT1:FileRef)             !List box control field - type derived from field
MAT1:Description       LIKE(MAT1:Description)         !List box control field - type derived from field
LOC:Branch             LIKE(LOC:Branch)               !List box control field - type derived from local data
DG1:Code               LIKE(DG1:Code)                 !List box control field - type derived from field
LOC:Employee           LIKE(LOC:Employee)             !List box control field - type derived from local data
ABMM:MessageNumber     LIKE(ABMM:MessageNumber)       !List box control field - type derived from field
ABMM:MessageDescription LIKE(ABMM:MessageDescription) !List box control field - type derived from field
ABMM:MessageDirection  LIKE(ABMM:MessageDirection)    !List box control field - type derived from field
ABMM:Details           LIKE(ABMM:Details)             !List box control field - type derived from field
MAT1:BranchID          LIKE(MAT1:BranchID)            !Browse hot field - type derived from field
ABMM:EmployeeID        LIKE(ABMM:EmployeeID)          !Browse hot field - type derived from field
ABMM:RecordID          LIKE(ABMM:RecordID)            !Primary key field - type derived from field
ABMM:MatterID          LIKE(ABMM:MatterID)            !Browse key field - type derived from field
MAT1:RecordID          LIKE(MAT1:RecordID)            !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW33::View:Browse   VIEW(SARS_MatterMessage)
                       PROJECT(SMM:Date)
                       PROJECT(SMM:Time)
                       PROJECT(SMM:Description)
                       PROJECT(SMM:TD_ReferenceNumber)
                       PROJECT(SMM:Status)
                       PROJECT(SMM:ErrorMessage)
                       PROJECT(SMM:EmployeeID)
                       PROJECT(SMM:RecordID)
                       PROJECT(SMM:MatterID)
                       JOIN(MatterAlias,'MAT1:RecordId = SMM:MatterID')
                         PROJECT(MAT1:FileRef)
                         PROJECT(MAT1:RecordID)
                       END
                     END
Queue:Browse:11      QUEUE                            !Queue declaration for browse/combo box using ?SARSLinkBrowse
SMM:Date               LIKE(SMM:Date)                 !List box control field - type derived from field
SMM:Time               LIKE(SMM:Time)                 !List box control field - type derived from field
MAT1:FileRef           LIKE(MAT1:FileRef)             !List box control field - type derived from field
LOC:Employee           LIKE(LOC:Employee)             !List box control field - type derived from local data
SMM:Description        LIKE(SMM:Description)          !List box control field - type derived from field
SMM:TD_ReferenceNumber LIKE(SMM:TD_ReferenceNumber)   !List box control field - type derived from field
SMM:Status             LIKE(SMM:Status)               !List box control field - type derived from field
SMM:ErrorMessage       LIKE(SMM:ErrorMessage)         !List box control field - type derived from field
MAT1:RecordID          LIKE(MAT1:RecordID)            !Browse hot field - type derived from field
SMM:EmployeeID         LIKE(SMM:EmployeeID)           !Browse hot field - type derived from field
SMM:RecordID           LIKE(SMM:RecordID)             !Primary key field - type derived from field
SMM:MatterID           LIKE(SMM:MatterID)             !Browse key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
LOC:CopyFlag21    BYTE
LOC:PageSetup50   CSTRING(20)
LOC:SSRow:50      Long
LOC:QueueCounter:50 Long
LOC:SSCol:50   Long
LOC:Filename:50    CSTRING(255)
SSQueue:50     Queue,PRE(SSQ:50)
FieldNo       BYTE
Heading       CSTRING(30)
FieldName     CSTRING(30)
Picture       CSTRING(30)
AlignH        BYTE
AlignV        BYTE
ColumnWidth   SHORT
FormatType    BYTE
FormatString  BYTE
TotalOption   BYTE
            END

SSWindow:50 WINDOW('Print'),AT(,,343,192),FONT('MS Sans Serif',8,,FONT:regular),CENTER,IMM,ICON('Print.ico'), |
         SYSTEM,GRAY,MAX,RESIZE,MODAL
       MENUBAR
         MENU('&File'),USE(?SSFile:50)
           ITEM('Print<9>CtrlP'),USE(?SSFilePrint:50),KEY(CtrlP)
           ITEM,SEPARATOR
           ITEM('&Close<9>CtrlF4'),USE(?SSClose:50),KEY(CtrlF4)
         END
       END
       TOOLBAR,AT(0,0,,18)
         BUTTON,AT(4,3,15,14),USE(?SSPrint:50),FLAT,TIP('Print'),ICON(ICON:Print)
         BUTTON,AT(20,3,15,14),USE(?SSPreview:50),FLAT,TIP('Preview'),ICON('bpreview.ico')
         BUTTON,AT(36,3,15,14),USE(?SSExcel:50),FLAT,TIP('Load Report In Excel'),ICON('excel1.ico')
         BUTTON,AT(52,3,15,14),USE(?SSEdit:50),FLAT,TIP('Edit Spreadsheet'),ICON('pageview.ico')
         GROUP,AT(-6,0,349,2),USE(?SSGroup:50),BOXED,BEVEL(0,0,0600H)
         END
       END
       OLE,AT(0,0,343,176),USE(?SSOle:50),HIDE,COMPATIBILITY(0)
       END
       OLE,AT(0,0,343,176),USE(?OleExcel:50),HIDE,COMPATIBILITY(0)
       END
     END
LOC:PageSetup58   CSTRING(20)
LOC:SSRow:58      Long
LOC:QueueCounter:58 Long
LOC:SSCol:58   Long
LOC:Filename:58    CSTRING(255)
SSQueue:58     Queue,PRE(SSQ:58)
FieldNo       BYTE
Heading       CSTRING(30)
FieldName     CSTRING(30)
Picture       CSTRING(30)
AlignH        BYTE
AlignV        BYTE
ColumnWidth   SHORT
FormatType    BYTE
FormatString  BYTE
TotalOption   BYTE
            END

SSWindow:58 WINDOW('Print'),AT(,,343,192),FONT('MS Sans Serif',8,,FONT:regular),CENTER,IMM,ICON('Print.ico'), |
         SYSTEM,GRAY,MAX,RESIZE,MODAL
       MENUBAR
         MENU('&File'),USE(?SSFile:58)
           ITEM('Print<9>CtrlP'),USE(?SSFilePrint:58),KEY(CtrlP)
           ITEM,SEPARATOR
           ITEM('&Close<9>CtrlF4'),USE(?SSClose:58),KEY(CtrlF4)
         END
       END
       TOOLBAR,AT(0,0,,18)
         BUTTON,AT(4,3,15,14),USE(?SSPrint:58),FLAT,TIP('Print'),ICON(ICON:Print)
         BUTTON,AT(20,3,15,14),USE(?SSPreview:58),FLAT,TIP('Preview'),ICON('bpreview.ico')
         BUTTON,AT(36,3,15,14),USE(?SSExcel:58),FLAT,TIP('Load Report In Excel'),ICON('excel1.ico')
         BUTTON,AT(52,3,15,14),USE(?SSEdit:58),FLAT,TIP('Edit Spreadsheet'),ICON('pageview.ico')
         GROUP,AT(-6,0,349,2),USE(?SSGroup:58),BOXED,BEVEL(0,0,0600H)
         END
       END
       OLE,AT(0,0,343,176),USE(?SSOle:58),HIDE,COMPATIBILITY(0)
       END
       OLE,AT(0,0,343,176),USE(?OleExcel:58),HIDE,COMPATIBILITY(0)
       END
     END
NoticeQueue    QUEUE,Pre()
NQ:Description       CSTRING(255)
NQ:Url               CSTRING(255)
               END
ThisNotice     CLASS()
Init              PROCEDURE(),BYTE,PROC
Kill              PROCEDURE(),BYTE,PROC
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
BRW15::Filter        BYTE,AUTO
BRW2::Filter         BYTE,AUTO
BRW22::Filter        BYTE,AUTO
BRW36::Filter        BYTE,AUTO
BRW52::Filter        BYTE,AUTO
BRW54::Filter        BYTE,AUTO
BRW15::NoMoreTagsMsg STRING('There are no more tagged records!')
BRW15::IgnoreMouseRight BYTE(False)
BRW15::NoScrollDown  BYTE(False)
BRW22::NoMoreTagsMsg STRING('There are no more tagged records!')
BRW22::IgnoreMouseRight BYTE(False)
BRW22::NoScrollDown  BYTE(False)
BRW2::NoMoreTagsMsg  STRING('There are no more tagged records!')
BRW2::IgnoreMouseRight BYTE(False)
BRW2::NoScrollDown   BYTE(False)
BRW36::NoMoreTagsMsg STRING('There are no more tagged records!')
BRW36::IgnoreMouseRight BYTE(False)
BRW36::NoScrollDown  BYTE(False)
BRW52::NoMoreTagsMsg STRING('There are no more tagged records!')
BRW52::IgnoreMouseRight BYTE(False)
BRW52::NoScrollDown  BYTE(False)
BRW54::NoMoreTagsMsg STRING('There are no more tagged records!')
BRW54::IgnoreMouseRight BYTE(False)
BRW54::NoScrollDown  BYTE(False)
QuickWindow          WINDOW('LegalSuite Desktop'),AT(,,577,359),FONT('Arial',9,,),CENTER,IMM,ICON('index.ico'),CENTERED,SYSTEM,GRAY,MAX,RESIZE,MDI
                       SHEET,AT(3,39,571,317),USE(?CurrentTab),DROPID('FromSMS','~FILE')
                         TAB('  &Matters  '),USE(?MattersTab)
                           PROMPT('&Quick Find:'),AT(9,57),USE(?LOC:QuickSearch:Prompt)
                           ENTRY(@s19),AT(49,57,57,10),USE(LOC:QuickSearch),FONT('MS Sans Serif',,,),COLOR(COLOR:White)
                           LIST,AT(9,70,549,254),USE(?MattersBrowse),IMM,HVSCROLL,FORMAT('9L|*I@s10@12L|*I@s10@12L(2)|M*@s10@12L*I@s99@Z(1)Q''Matter Progress''60L(2)|M*~Fil' &|
   'e Ref~@s19@85L(2)|M*~Status~L(4)@s99@60L(2)|M*~Alternate Ref~@s99@60R(2)|M*~Link' &|
   'ed Matter~L@s49@30R(2)|M*~ ID~L@n_12@19C(2)|M*~FICA~@s3@85L(2)|M*~Client~@s99@12' &|
   '0L(2)|M*~Description~@s99@40R(6)|M*~Law Ref~C(2)@n_10b@70L(2)|M*~Matter Type~@s4' &|
   '9@80L(2)|M*~Document Set~@s34@75L(2)|M*~Belongs To~@s50@55L(2)|M*~Instructed~@d1' &|
   '7b@76L(2)|M*~Archive Status~@s49@60R(2)|M*~Debtor''s Balance~L@n-15.2@/'),FROM(Queue:Browse:1)
                           BUTTON('&Tag'),AT(67,108,48,12),USE(?TagOne),SKIP,TIP('Tag this item')
                           BUTTON('&Untag'),AT(115,108,48,12),USE(?UntagOne),SKIP,TIP('Untag this item')
                           BUTTON('&Flip'),AT(163,108,48,12),USE(?FlipOne),SKIP,TIP('Flip the tag on this item')
                           BUTTON('Tag &All'),AT(67,122,48,12),USE(?TagAll),SKIP,TIP('Tag all items')
                           BUTTON('Unta&g All'),AT(115,122,48,12),USE(?UntagAll),SKIP,TIP('Untag all items')
                           BUTTON('F&lip All'),AT(163,122,48,12),USE(?FlipAll),SKIP,TIP('Flip the tags on all items')
                           GROUP,AT(2,1,572,35),USE(?Group1),BOXED
                             BUTTON,AT(8,8,25,24),USE(?DocgenDatabaseButton),SKIP,TIP('Document Generator Database (F3)'),ICON('window_database.ico')
                             BUTTON,AT(8,8,25,24),USE(?ExtraScreenButton),SKIP,TIP('View/Edit the Document Extra Screen data for the Matter (ALT F10)'),ICON('extra_screens.ico')
                             BUTTON,AT(8,8,25,24),USE(?PartiesButton),SKIP,TIP('Parties for this Matter (F4)'),ICON('matter_users.ico')
                             BUTTON,AT(8,8,25,24),USE(?MatterEmployeesButton),SKIP,TIP('Employees involved in this Matter'),ICON('user1_time.ico')
                             BUTTON,AT(8,8,25,24),USE(?LedgerEnquiryButton),SKIP,TIP('Matter Transactions (F5)'),ICON('matter_money.ico')
                             BUTTON,AT(8,8,25,24),USE(?DocumentLogButton),SKIP,TIP('Document Log (F6)'),ICON('folder_document.ico')
                             BUTTON,AT(8,8,25,24),USE(?BillOfCostsButton),SKIP,TIP('Bill of Costs (F11)'),ICON('document_money.ico')
                             BUTTON,AT(8,8,25,24),USE(?CreateCustomisedInvoiceButton),SKIP,TIP('Create a customised Tax Invoice (from posted transactions only)'),ICON('Tax_Invoice.ico')
                             BUTTON,AT(8,8,25,24),USE(?DebtorsBalanceButton),SKIP,TIP('Debtor''s Account (F7)'),ICON('money_ok.ico')
                             BUTTON,AT(8,8,26,24),USE(?DisplayDashboard),SKIP,TIP('Management dashboard'),ICON('oszillograph.ico')
                             BUTTON,AT(8,8,25,24),USE(?QuickQuoteButton),SKIP,HIDE,TIP('Quick Calculation of Conveyancing Fees (F11)'),ICON('calculator1.ico')
                             BUTTON,AT(8,8,26,24),USE(?ShowFavouritesButton),SKIP,TIP('Show recently accessed Matters (F12)'),ICON('favourites.ico')
                             BUTTON,AT(8,8,25,24),USE(?MatterSummaryButton),SKIP,TIP('Create a detailed summary of the highlighted Matter<13,10>or print summaries for tagg' &|
   'ed Matters'),ICON('document_chart.ico')
                             BUTTON,AT(8,8,25,24),USE(?MAT:QBESearchButton:2),SKIP,TIP('Search for Matters using Query By Example (QBE)'),ICON('folder_view.ico')
                             BUTTON,AT(8,8,24,24),USE(?SendEmpMessage),SKIP,TIP('Send an instant message to an Employee or Employees regarding the highlighted Ma' &|
   'tter'),ICON('usermessage.ico')
                             BUTTON,AT(8,8,25,24),USE(?ManagementReportButton),SKIP,TIP('Matter Reports'),ICON('printer.ico')
                             BUTTON,AT(8,8,25,24),USE(?UpdateGuarantees),SKIP,TIP('Update the status of all Guarantees submitted to the Guarantee Hub'),ICON('safe.ico')
                             BUTTON,AT(8,8,25,24),USE(?CheckSheetButton),SKIP,TIP('Check Sheet (F7)'),ICON('preferences.ico')
                             BUTTON,AT(8,8,25,24),USE(?ToggleMatterIconsButton),SKIP,TIP('Show the Icons (ALT F5)'),ICON('column_add.ico')
                             BUTTON,AT(8,8,25,25),USE(?ViewRatesClearanceButton),SKIP,TIP('Go to the RatesClearance.Com website'),ICON('server_view.ico')
                             BUTTON,AT(432,8,24,24),USE(?BondCentreOrGatewayPropertyHubDocsButtonMatterTab),LEFT,TIP('Download documents from the Bond Centre or Attorney Gateway'),ICON('document_down.ico')
                             BUTTON,AT(488,8,24,24),USE(?SelectDocumentsButton),SKIP,TIP('Assemble Documents (F9)'),ICON('component_edit.ico')
                             BUTTON,AT(460,8,24,24),USE(?STDOnlineDocumentMatterTab),TIP('Assemble the online KODA documents<13,10>for the current matter'),ICON('assemble_koda1.jpg')
                             BUTTON,AT(516,8,24,24),USE(?FindMatterButton),SKIP,TIP('Search for a Matter (F2)'),ICON('index_view.ico')
                             BUTTON,AT(544,8,24,24),USE(?FilterButton),SKIP,TIP('Filter Matters (F8)<13,10>Scroll through saved Filters (ALT F8)<13,10>Clear Filter (ALT F9' &|
   ')'),ICON('funnel.ico')
                           END
                           BUTTON('&Insert'),AT(67,140,42,12),USE(?Insert:3),HIDE
                           BUTTON('&Change'),AT(111,140,42,12),USE(?Change:3),HIDE
                           BUTTON('&Delete'),AT(155,140,42,12),USE(?Delete:3),HIDE
                           BUTTON('Print'),AT(237,142,101,12),USE(?MatterReportsPrintButton),HIDE
                           BUTTON('Sho&w Tagged'),AT(8,331,54,12),USE(?MAT:OptFilterButton),SKIP
                           PROMPT('Total:'),AT(65,332),USE(?LOC:FilteredMatters:Prompt)
                           ENTRY(@n_9),AT(85,332,47,10),USE(LOC:FilteredMatters),SKIP,RIGHT(1),FONT('MS Sans Serif',,,),COLOR(COLOR:Silver),TIP('The total number of Matters displayed'),READONLY
                           PROMPT('Tagged:'),AT(137,332),USE(?LOC:TaggedMatters:Prompt),HIDE
                           ENTRY(@n_9),AT(169,332,47,10),USE(LOC:TaggedMatters),SKIP,HIDE,RIGHT(1),FONT('MS Sans Serif',,,),COLOR(COLOR:Silver),TIP('The total number of tagged Matters'),READONLY
                           BUTTON,AT(10,10,1,1),USE(?TimerButton),SKIP
                           BUTTON('Conveyancing &Exception'),AT(215,109,83,12),USE(?ConveyancingException,10000),SKIP,HIDE,TIP('Flip the tag on this item')
                           BUTTON('&Close'),AT(501,330,68,20),USE(?Close),SKIP,LEFT,FONT('Arial',11,,),TIP('Close this window'),ICON('delete32.ico')
                         END
                         TAB('  F&ee Notes  '),USE(?FeeNotesTab)
                           PROMPT('&Quick Fee:'),AT(8,54),USE(?LOC:QuickFeeCode:Prompt)
                           ENTRY(@s19),AT(44,54,60,10),USE(LOC:QuickFeeCode),FONT('MS Sans Serif',,,),TIP('Type in a Fee Code and press TAB'),REQ,OVR
                           LIST,AT(8,69,542,265),USE(?FeeNoteBrowse),IMM,HVSCROLL,FORMAT('10L|F*I@s10@12L|F*I@s10@Q''Fee Note On Hold''12L|F*I@s10@Q''Fee Note Posted''48L(2)|' &|
   'M*~Date~@D17@60L(2)|M*~File Ref~@s49@100L(2)|M*~Matter~@s99@75L(2)|M*~Client~@s9' &|
   '9@139L(2)|M*~Description~@s254@59R(2)|M*~Amount (Excl)~@n-15.2@52R(2)|M*~VAT~@n-' &|
   '15.2@60R(2)|M*~Amount (Incl)~@n-15.2@24C|M*~Period~@n02@60L(2)|M*~Vat Rate~@s19@' &|
   '100L(2)|M*~Employee~@s50@50L(2)|M*~Voucher~@s49@100L(2)|M*~Cost Centre~@s49@62C(' &|
   '4)|M*~Debtor''s Account~C(2)@s3@60L(2)|M*~Posted Date~@d17b@76L(2)|M*~Posted Batc' &|
   'h No~@s19@'),FROM(Queue:Browse)
                           GROUP,AT(2,1,572,35),USE(?Group2),BOXED
                             BUTTON,AT(7,8,26,24),USE(?FeeSheetButton),TIP('Insert a fee using the fee sheet'),ICON('Money_add.ico')
                             BUTTON,AT(36,8,26,24),USE(?ProformaInvoiceButton),LEFT,TIP('Create an Invoice'),ICON('Tax_Invoice.ico')
                             BUTTON,AT(65,8,26,24),USE(?PostFeesButton),TIP('Post Fee Notes to Accounting'),ICON('money_Ok.ico')
                             BUTTON,AT(94,8,26,24),USE(?LedgerEnquiryButton:2),LEFT,TIP('Matter Transactions'),ICON('matter_money.ico')
                             BUTTON,AT(123,8,26,24),USE(?EmployeeBalancesButton),TIP('Show the Employee''s balances for each accounting period'),ICON('chart_money.ico')
                             BUTTON,AT(152,8,26,24),USE(?FN:QBESearchButton),TIP('Search for Fee Notes using QBE'),ICON('folder_view.ico')
                             BUTTON,AT(181,8,26,24),USE(?FN:QBEPrintButton),TIP('Fee Note report'),ICON('printer.ico')
                             BUTTON,AT(210,8,26,24),USE(?FeeNoteJumpToMatterButton),LEFT,TIP('Jump to the Matter linked to this Fee Note'),ICON('index_new.ico')
                             BUTTON,AT(239,8,26,24),USE(?RefreshFeeNotesButton),LEFT,TIP('Refresh Fee Notes'),ICON('recycle.ico')
                             PROMPT('&Type:'),AT(240,9),USE(?LOC:FN_Type:Prompt),TRN
                             LIST,AT(260,9,59,9),USE(LOC:FN_Type),DROP(4),FROM('Creditor|Disbursement|Fee|All')
                             LIST,AT(496,21,72,9),USE(LOC:FN_Employee),VSCROLL,TIP('Display items for a specific Employee or all Employees'),FORMAT('116L(2)@s29@'),DROP(20),FROM(FN_Employee:Queue)
                             LIST,AT(260,21,59,9),USE(LOC:PostedOption),DROP(3),FROM('Unposted|Posted|All')
                             PROMPT('&Date:'),AT(352,9,17,10),USE(?LOC:FN_Period:Prompt),TRN
                             LIST,AT(372,9,66,9),USE(LOC:FN_Period),VSCROLL,TIP('The date range to display items'),FORMAT('76L(2)@s19@'),DROP(10),FROM('Today|All|Yesterday|This Week|Last Week|This Month|Last Month|This Period|This Fin Year|Custom')
                             BUTTON('...'),AT(444,9,9,9),USE(?CustomFN_PeriodButton),TIP('Specify the date range')
                             PROMPT('&Status'),AT(236,21),USE(?LOC:PostedOption:Prompt),TRN
                             PROMPT('M&atter:'),AT(471,9),USE(?LOC:FN_MatterPrompt),TRN
                             LIST,AT(496,9,72,9),USE(LOC:FN_Matter),TIP('Display Fee Notes for which Matters'),FORMAT('36L(2)@s9@'),DROP(4),FROM('All|Current|Filtered|Tagged')
                             PROMPT('Co&st Centre:'),AT(328,21),USE(?CostCentre:Prompt),TRN
                             LIST,AT(372,21,82,9),USE(LOC:FN_CostCentre),VSCROLL,TIP('Display Fee Notes for a specific Cost Centre'),FORMAT('196L(2)|M@s49@'),DROP(20),FROM(FN_CostCentre:Queue)
                             PROMPT('Em&ployee:'),AT(459,21),USE(?LOC:FN_EmployeePrompt),TRN
                           END
                           BUTTON('Reassign Fee Notes'),AT(255,95,93,13),USE(?AdjustFeenotes),HIDE
                           BUTTON('Adjust Vat Rate'),AT(113,149,58,13),USE(?AdjustVatRateButton),HIDE,TIP('Adjust the Vat Rate of the highlighted/tagged Fee Note(s)')
                           BUTTON('Adjust fees'),AT(133,149,58,13),USE(?AdjustFeesButton),HIDE,TIP('Adjust the amount of the highlighted/tagged Fee Note(s)')
                           BUTTON('&Print'),AT(167,138,49,12),USE(?FN:PrintButton),HIDE
                           BUTTON('&Insert'),AT(85,106,42,12),USE(?Insert),HIDE
                           BUTTON('&Change'),AT(129,106,42,12),USE(?Change),HIDE
                           BUTTON('&Delete'),AT(173,106,42,12),USE(?Delete),HIDE
                           BUTTON('Tag &Fees'),AT(315,132,58,13),USE(?TagFeesButton),HIDE
                           BUTTON('&Tag'),AT(37,138,48,12),USE(?TagOne:2)
                           BUTTON('&Untag'),AT(85,138,48,12),USE(?UntagOne:2)
                           BUTTON('Cop&y to Debtor''s Account'),AT(319,194,93,13),USE(?CopyToDebtorButton),HIDE
                           BUTTON('Remove from Proforma Account'),AT(203,211,112,13),USE(?ClearProformaIDButton),HIDE
                           BUTTON('Export Fee Notes'),AT(35,188,93,13),USE(?ExportFeeNoteButton),HIDE
                           BUTTON('Put on hold'),AT(315,154,58,13),USE(?OnholdButton),HIDE
                           BUTTON('Update Voucher'),AT(215,194,93,13),USE(?UpdateVoucherButton),HIDE
                           BUTTON('Import From Ledger'),AT(165,156,93,13),USE(?ImportFromLedgerButton),HIDE,TIP('Import transactions from the Ledger')
                           BUTTON('Take off hold'),AT(317,170,58,13),USE(?OffHoldButton),HIDE
                           BUTTON('Tag &Disbursement'),AT(299,116,93,13),USE(?TagDisbursementsButton),HIDE
                           BUTTON('Combine fees'),AT(215,178,93,13),USE(?CombineFeesButton),HIDE
                           IMAGE('block.ico'),AT(72,337,15,12),USE(?Image2),CENTERED
                           BUTTON,AT(553,116,16,14),USE(?MoveUp),SKIP,FLAT,TIP('Move fee note up one'),ICON('UP.ICO')
                           BUTTON,AT(553,138,16,14),USE(?MoveDown),SKIP,FLAT,TIP('Move fee note down one'),ICON('DOWN.ICO')
                           BUTTON('Tag &All'),AT(37,148,48,12),USE(?TagAll:2)
                           BUTTON('Unta&g All'),AT(85,148,48,12),USE(?UntagAll:2)
                           STRING('= On Hold'),AT(88,338),USE(?Image2:String)
                           BUTTON('Sho&w Tagged'),AT(8,337,54,13),USE(?FN:OptFilterButton),TIP('Show "All" or "Only Tagged" items?')
                           PROMPT('Disbursements:'),AT(339,338),USE(?LOC:TotalDisb:Prompt),HIDE
                           ENTRY(@n-15.2b),AT(395,338,60,10),USE(LOC:TotalDisb),SKIP,HIDE,DECIMAL(12),FONT('MS Sans Serif',,,),COLOR(COLOR:Silver),TIP('Total Disbursements (Excluding VAT)'),READONLY
                           PROMPT('Fees:'),AT(467,338),USE(?LOC:TotalFees:Prompt),HIDE
                           ENTRY(@n-15.2b),AT(491,338,60,10),USE(LOC:TotalFees),SKIP,HIDE,DECIMAL(12),FONT('MS Sans Serif',,,),COLOR(COLOR:Silver),TIP('Total Fees (Excluding VAT)'),READONLY
                           IMAGE('smmoney.ico'),AT(128,337,15,12),USE(?Image1),CENTERED
                           STRING('= Posted'),AT(140,338),USE(?Image1:String)
                         END
                         TAB('  F&ile Notes  '),USE(?FileNotesTab)
                           LIST,AT(7,61,561,273),USE(?FileNoteBrowse),IMM,HVSCROLL,MSG('Browsing Records'),FORMAT('10L|F*I@s10@10L|F*I@s99@10L|F*I@s10@Q''Fee Note Posted''48L(2)|M*~Date~@d17@60L(2)' &|
   '|M*~File Ref~@s49@175L(2)|M*~Matter~@s99@36L(2)|M*~Stage~@s9@255L(2)|M*~File Not' &|
   'e~@s255@104L(2)|M*~Employee~@s50@'),FROM(Queue:Browse:4)
                           GROUP,AT(2,1,572,35),USE(?Group3),BOXED
                             BUTTON,AT(7,8,25,24),USE(?EmailFileNoteButton),TIP('Email the highlighted FileNote'),ICON('mail_earth.ico')
                             BUTTON,AT(35,8,25,24),USE(?PrintFileNoteButton),TIP('Print out the highlighted/tagged FileNote(s)'),ICON('document_edit.ico')
                             BUTTON,AT(63,8,25,24),USE(?FIL:QBESearchButton),TIP('Search for File Notes using QBE'),ICON('folder_view.ico')
                             BUTTON,AT(91,8,25,24),USE(?FIL:QBEPrintButton),TIP('File Note report'),ICON('printer.ico')
                             BUTTON,AT(119,8,25,24),USE(?ToggleFileNoteIconsButton),LEFT,TIP('Show the Icons (ALT F5)'),ICON('column_add.ico')
                             BUTTON,AT(147,8,25,24),USE(?FileNoteJumpToMatterButton),LEFT,TIP('Jump to the Matter linked to this File Note'),ICON('index_new.ico')
                             BUTTON,AT(175,8,26,24),USE(?RefreshFileNotesButton),LEFT,TIP('Refresh File Notes'),ICON('recycle.ico')
                             PROMPT('Em&ployee:'),AT(336,9),USE(?LOC:FIL_EmployeePrompt),TRN
                             LIST,AT(376,9,92,9),USE(LOC:FIL_Employee),VSCROLL,TIP('Display items for a specific Employee or all Employees'),FORMAT('116L(2)@s29@'),DROP(20),FROM(FIL_Employee:Queue)
                             PROMPT('M&atter:'),AT(480,9),USE(?LOC:FIL_MatterPrompt),TRN
                             LIST,AT(508,9,52,9),USE(LOC:FIL_Matter),TIP('Display File Notes for which Matters'),FORMAT('36L(2)@s9@'),DROP(4),FROM('All|Current|Filtered|Tagged')
                             PROMPT('Status:'),AT(248,22),USE(?LOC:FIL_InternalPrompt),TRN
                             LIST,AT(276,22,50,9),USE(LOC:FIL_Internal),TIP('Display Internal or Not Internal File Notes'),FORMAT('36L(2)@s15@'),DROP(3),FROM('All|Internal|Not Internal')
                             PROMPT('&Stages:'),AT(336,22),USE(?LOC:FIL_StatusPrompt),TRN
                             LIST,AT(376,22,92,9),USE(LOC:FIL_Status),TIP('Display File Notes with completed or incomplete Stages'),FORMAT('36L(2)@s15@'),DROP(3),FROM('All|No Stage|Stage Reached')
                             PROMPT('&Date:'),AT(480,22),USE(?LOC:FIL_Period:Prompt),TRN
                             LIST,AT(508,22,52,9),USE(LOC:FIL_Period),VSCROLL,TIP('The date range to display items'),FORMAT('76L(2)@s19@'),DROP(8),FROM('Today|All|Yesterday|This Week|This Month|Last Month|This Year|Custom')
                             BUTTON('...'),AT(562,22,9,9),USE(?CustomFIL_PeriodButton),TIP('Specify the date range')
                           END
                           BUTTON('Export File Notes'),AT(231,90,93,13),USE(?ExportFileNoteButton),HIDE
                           BUTTON('&Tag'),AT(79,108,48,12),USE(?TagOne:3),MSG('Tag this item'),TIP('Tag this item')
                           BUTTON('&Untag'),AT(127,108,48,12),USE(?UntagOne:3),MSG('Untag this item'),TIP('Untag this item')
                           BUTTON('Tag &All'),AT(79,122,48,12),USE(?TagAll:3),MSG('Tag all items'),TIP('Tag all items')
                           BUTTON('Unta&g All'),AT(127,122,48,12),USE(?UntagAll:3),MSG('Untag all items'),TIP('Untag all items')
                           BUTTON('&Print'),AT(135,130,49,12),USE(?FIL:PrintButton),HIDE
                           BUTTON('C&opy'),AT(291,140,48,14),USE(?Copy),HIDE,LEFT,TIP('Copy')
                           BUTTON('&Make a Fee Note'),AT(181,146,73,15),USE(?MakeFeeNoteButton),HIDE
                           BUTTON('&Insert'),AT(131,164,42,12),USE(?Insert:5),HIDE
                           BUTTON('&Change'),AT(175,164,42,12),USE(?Change:5),HIDE
                           BUTTON('&Delete'),AT(219,164,42,12),USE(?Delete:5),HIDE
                           BUTTON('Make External'),AT(355,117,93,13),USE(?MakeExternalButton),HIDE
                           BUTTON('Make Internal'),AT(355,93,93,13),USE(?MakeInternalButton),HIDE
                           BUTTON('Sho&w Tagged'),AT(8,338,54,12),USE(?FIL:OptFilterButton)
                           IMAGE('bok.ico'),AT(68,338,15,12),USE(?FileNotePostedImage1),CENTERED
                           STRING('= Fee Note Created'),AT(80,339),USE(?FileNotePostedImage1:String)
                           PROMPT('Total:'),AT(502,339),USE(?LOC:FilteredFileNotes:Prompt)
                           ENTRY(@n_9),AT(522,339,47,10),USE(LOC:FilteredFileNotes),SKIP,RIGHT(1),FONT('MS Sans Serif',,,),COLOR(COLOR:Silver),TIP('The total number of FileNotes displayed'),READONLY
                           PROMPT('Tagged:'),AT(416,339),USE(?LOC:TaggedFileNotes:Prompt),HIDE
                           ENTRY(@n_9),AT(446,339,47,10),USE(LOC:TaggedFileNotes),SKIP,HIDE,RIGHT(1),FONT('MS Sans Serif',,,),COLOR(COLOR:Silver),TIP('The total number of tagged FileNotes'),READONLY
                         END
                         TAB('  &Reminders  '),USE(?RemindersTab)
                           LIST,AT(9,72,543,262),USE(?ToDoNoteBrowse),IMM,HVSCROLL,FORMAT('9L|F*I@s10@10L(2)*I@s99@50L(2)|M*~Date~@d17@60L(2)|M*~File Ref~@s49@100L(2)|M*~M' &|
   'atter~@s99@123L(2)|M*~Reminder~@s149@116L(2)|M*~For Action~@s50@50L(2)|M*~Date D' &|
   'one~@d17b@35L(2)|M*~Time~@t3b@20R(2)|M*~Days~@n_5b@20R(2)|M*~Diff~@n-_6b@50L(2)|' &|
   'M*~Created~@d17b@35L(2)|M*~Time~@t3b@100L(2)|M*~Suggested Next Document~@s254@55' &|
   'L(2)|M*~Code~@s19@75L(2)|M*~Web Link~@s30@56L(2)M*~Attorney Gateway~@n_5@/'),FROM(Queue:Browse:3)
                           GROUP,AT(2,1,572,35),USE(?Group5),BOXED
                             BUTTON('  &Done'),AT(7,9,58,22),USE(?MakeDoneButton),LEFT,FONT(,11,,),TIP('Mark the Reminder as ''Done'''),ICON('tick1.ico')
                             BUTTON,AT(68,8,25,24),USE(?AdjustRemindersButton),TIP('Adjust the target dates of the Reminders'),ICON('calendar_down.ico')
                             BUTTON,AT(96,8,25,24),USE(?EmailToDoNoteButton),LEFT,TIP('Email the highlighted Reminder'),ICON('mail_earth.ico')
                             BUTTON,AT(124,8,25,24),USE(?PrintToDoNoteButton),LEFT,TIP('Print the highlighted/tagged Reminders'),ICON('document_edit.ico')
                             BUTTON,AT(152,8,25,24),USE(?TOD:QBESearchButton),TIP('Search for Reminders using QBE'),ICON('folder_view.ico')
                             BUTTON,AT(180,8,25,24),USE(?TOD:QBEPrintButton),TIP('Reminder report'),ICON('printer.ico')
                             BUTTON,AT(208,8,25,24),USE(?MakeRemindersDocumentsButton),TIP('Assemble Documents from Reminders'),ICON('component_edit.ico')
                             BUTTON,AT(236,8,25,24),USE(?ToggleToDoNoteIconsButton),LEFT,TIP('Show the Icons (ALT F5)'),ICON('column_add.ico')
                             BUTTON,AT(264,8,25,24),USE(?ToDoNoteJumpToMatterButton),LEFT,TIP('Jump to the Matter linked to this Reminder'),KEY(AltG),ICON('index_new.ico')
                             BUTTON,AT(292,8,26,24),USE(?RefreshToDoNotesButton),LEFT,TIP('Refresh the Reminders'),ICON('recycle.ico')
                             PROMPT('Em&ployee:'),AT(330,9),USE(?LOC:TOD_EmployeePrompt),TRN
                             LIST,AT(370,8,96,10),USE(LOC:TOD_Employee),VSCROLL,TIP('Display items for a specific Employee or all Employees'),FORMAT('116L(2)@s29@'),DROP(20),FROM(TOD_Employee:Queue)
                             PROMPT('M&atter:'),AT(474,9),USE(?LOC:TOD_MatterPrompt),TRN
                             LIST,AT(498,9,62,9),USE(LOC:TOD_Matter),TIP('Display items for which Matters'),FORMAT('36L(2)@s9@'),DROP(4),FROM('All|Current|Filtered|Tagged')
                             PROMPT('C&ritical Step:'),AT(330,23),USE(?LOC:TOD_CriticalStepPrompt),TRN
                             LIST,AT(370,23,96,9),USE(LOC:TOD_CriticalStep),VSCROLL,TIP('Display Reminders that are linked to a Critical Step<13,10>EMP:TOD_CriticalStep'),FORMAT('116L(2)|M@s29@'),DROP(20),FROM(TOD_CriticalStep:Queue)
                             PROMPT('&Date:'),AT(474,23),USE(?LOC:TOD_Period:Prompt),TRN
                             LIST,AT(498,23,62,9),USE(LOC:TOD_Period),VSCROLL,TIP('The date range to display Reminders'),FORMAT('76L(2)@s19@'),DROP(9),FROM('Today|All|This Week|Yesterday|This Month|Last Month|This Year|Today & Earlier|Custom')
                             BUTTON('...'),AT(562,23,9,9),USE(?CustomTOD_PeriodButton),TIP('Specify the date range')
                           END
                           OPTION('Display'),AT(35,54,131,13),USE(LOC:TOD_Status)
                             RADIO('Incomplete'),AT(37,57,49,10),USE(?LOC:TOD_Status:Radio1),VALUE('Incomplete')
                             RADIO('Completed'),AT(87,57,48,10),USE(?LOC:TOD_Status:Radio2),VALUE('Completed')
                             RADIO('All'),AT(137,57),USE(?LOC:TOD_Status:Radio3),VALUE('All')
                           END
                           PROMPT('&Display:'),AT(9,56),USE(?LOC:TOD_Status:Prompt)
                           BUTTON('&Print'),AT(375,109,49,12),USE(?TOD:PrintButton),HIDE
                           BUTTON('Make an Appointment  in OutLook (F6)'),AT(51,193,141,13),USE(?MakeOutLookAppointmentButton),HIDE,LEFT,TIP('Make a Task in OutLook based on the highlighted Reminder (F5)')
                           BUTTON('Make a Task in OutLook (F5)'),AT(51,169,141,13),USE(?MakeOutLookTaskButton),HIDE,LEFT,TIP('Make a Task in OutLook based on the highlighted Reminder (F5)')
                           BUTTON('Optional Reminders'),AT(231,178,93,13),USE(?OptionalRemindersButton),HIDE
                           BUTTON('Refresh Reminders'),AT(231,122,93,13),USE(?RefreshRemindersButton),HIDE,LEFT,TIP('Refresh Reminders<13,10>(Check if any have been added by other processes or users)')
                           BUTTON('Export Reminders'),AT(231,100,93,13),USE(?ExportToDoNoteButton),HIDE
                           BUTTON('&Insert'),AT(125,108,42,12),USE(?Insert:2),HIDE
                           BUTTON('&Change'),AT(169,108,42,12),USE(?Change:2),HIDE
                           BUTTON('&Delete'),AT(75,108,42,12),USE(?Delete:2),HIDE
                           BUTTON('&Tag'),AT(95,127,48,12),USE(?TagOne:4)
                           BUTTON('&Untag'),AT(143,127,48,12),USE(?UntagOne:4)
                           BUTTON('Tag &All'),AT(95,138,48,12),USE(?TagAll:4)
                           BUTTON('Unta&g All'),AT(143,138,48,12),USE(?UntagAll:4)
                           BUTTON('Current Matter [Incomplete] (ALT+F3)'),AT(351,138,131,13),USE(?CurrentMatterRemindersButton),HIDE,KEY(AltF3)
                           BUTTON('Current Matter [All] (ALT+F4)'),AT(351,156,93,13),USE(?AllCurrentMatterRemindersButton),HIDE,KEY(AltF4)
                           BUTTON('&Reload Plan of Action Items'),AT(231,154,95,16),USE(?ReloadPlanOfActionButton),HIDE,TIP('Reload the Plan of Action and reset all dates')
                           BUTTON('My Reminders (ALT+F2)'),AT(351,178,93,13),USE(?MyRemindersButton),HIDE,KEY(AltF2)
                           BUTTON('Sho&w Tagged'),AT(8,339,54,12),USE(?TOD:OptFilterButton),TIP('Show "All" or "Only Tagged" items?')
                           PROMPT('Total:'),AT(486,339),USE(?LOC:FilteredReminders:Prompt)
                           ENTRY(@n_9),AT(507,339,47,10),USE(LOC:FilteredReminders),SKIP,RIGHT(1),FONT('MS Sans Serif',,,),COLOR(COLOR:Silver),TIP('The total number of Reminders displayed'),READONLY
                           PROMPT('Tagged:'),AT(403,339),USE(?LOC:TaggedReminders:Prompt),HIDE
                           ENTRY(@n_9),AT(431,339,47,10),USE(LOC:TaggedReminders),SKIP,HIDE,RIGHT(1),FONT('MS Sans Serif',,,),COLOR(COLOR:Silver),TIP('The total number of tagged Reminders'),READONLY
                           STRING('Hint: ALT F2: My Reminders   ALT F3/F4: Current Matter (Incomplete/All)'),AT(354,60),USE(?RemindersSpeedKeys),FONT('Arial',8,,)
                           BUTTON,AT(553,101,16,14),USE(?MoveReminderUp),FLAT,TIP('Move the Reminder up'),ICON('UP.ICO')
                           BUTTON,AT(553,125,16,14),USE(?MoveReminderDown),FLAT,TIP('Move the Reminder down'),ICON('DOWN.ICO')
                         END
                         TAB('  T&ime Records  '),USE(?TimeRecordingTab),HIDE
                           LIST,AT(8,59,560,273),USE(?TimeRecordingBrowse),IMM,HVSCROLL,FORMAT('10L|F*I@s10@10L|F*I@s25@45L(2)|M*~Date~@d17@60L(2)|M*~File Ref~@s49@100L(2)|M*~M' &|
   'atter~@s99@60L(2)|M*~Activity~@s49@134L(2)|M*~Details~@s149@31L(2)|M*~Time~@s9@6' &|
   '0R(2)|M*~Billable~@n-15.2b@100L(2)|M*~Employee~@s50@196L(2)|M*~Cost Centre~@s49@'),FROM(Queue:Browse:5)
                           GROUP,AT(2,1,572,35),USE(?Group4),BOXED
                             BUTTON,AT(7,9,26,24),USE(?SelectActivityButton),TIP('Insert a time record (and fee) by Activity'),ICON('date-time_preferences.ico')
                             BUTTON,AT(36,9,26,24),USE(?TimeaFeeButton),LEFT,TIP('Time a fee using a stopwatch. <13,10>Press F10 once to pop up the screen.<13,10>Press F10 ' &|
   'again to start the timer.'),ICON('stopwatch.ico')
                             BUTTON,AT(65,9,26,24),USE(?MatterEmployeesButton:2),TIP('Employees involved in the highlighted Matter'),ICON('user1_time.ico')
                             BUTTON,AT(94,9,26,24),USE(?MA:QBESearchButton),TIP('Search for Time Records using QBE'),ICON('folder_view.ico')
                             BUTTON,AT(123,9,26,24),USE(?MA:QBEPrintButton),TIP('Timed records report'),ICON('printer.ico')
                             BUTTON,AT(152,9,26,24),USE(?MatActivJumpToMatterButton),LEFT,TIP('Jump to the Matter linked to this Time Record'),ICON('index_new.ico')
                             PROMPT('&Activity:'),AT(381,24),USE(?LOC:MA_ActivityPrompt),TRN
                             LIST,AT(409,24,66,9),USE(LOC:MA_Activity),TIP('Display records for a specific Activity or all Activities'),FORMAT('116L(2)@s29@'),DROP(20),FROM(MA_Activity:Queue)
                             PROMPT('Em&ployee:'),AT(249,24),USE(?LOC:MA_EmployeePrompt),TRN
                             LIST,AT(293,24,80,9),USE(LOC:MA_Employee),VSCROLL,TIP('Display items for a specific Employee or all Employees'),FORMAT('116L(2)@s29@'),DROP(20),FROM(MA_Employee:Queue)
                             PROMPT('Co&st Centre:'),AT(249,8),USE(?LOC:MA_CostCentrePrompt),TRN
                             LIST,AT(293,8,80,9),USE(LOC:MA_CostCentre),VSCROLL,TIP('Display items for a specific Cost Centre or all Cost Centres'),FORMAT('116L(2)@s29@'),DROP(20),FROM(MA_CostCentre:Queue)
                             PROMPT('&Billed:'),AT(381,8),USE(?LOC:MA_BilledFlagPrompt),TRN
                             LIST,AT(409,8,66,10),USE(LOC:MA_BilledFlag),TIP('Display items for which Fee Notes have been made, or not'),FORMAT('36L(2)@s15@'),DROP(3),FROM('All|Billed|Not Billed')
                             PROMPT('M&atter:'),AT(481,8),USE(?LOC:MA_MatterPrompt),TRN
                             LIST,AT(505,8,52,9),USE(LOC:MA_Matter),TIP('Display items for the current Matter or all Matters'),FORMAT('36L(2)@s9@'),DROP(4),FROM('All|Current|Filtered|Tagged')
                             BUTTON,AT(181,9,26,24),USE(?RefreshTimeRecordsButton),TIP('Refresh the Timed Records'),ICON('recycle.ico')
                             PROMPT('&Date:'),AT(481,24),USE(?LOC:MA_Period:Prompt),TRN
                             LIST,AT(505,24,52,9),USE(LOC:MA_Period),VSCROLL,TIP('The date range to display items'),FORMAT('76L(2)@s19@'),DROP(8),FROM('Today|All|This Week|Yesterday|This Month|Last Month|This Year|Custom')
                             BUTTON('...'),AT(561,24,9,9),USE(?CustomMA_PeriodButton),TIP('Specify the date range')
                           END
                           BUTTON('Export Timed Records'),AT(263,103,93,13),USE(?ExportMatActivButton),HIDE
                           BUTTON('&Tag'),AT(143,162,48,12),USE(?TagOne:5)
                           BUTTON('&Print'),AT(147,140,49,12),USE(?MA:PrintButton),HIDE
                           BUTTON('&Insert'),AT(109,122,42,12),USE(?Insert:6),HIDE
                           BUTTON('&Change'),AT(153,122,42,12),USE(?Change:6),HIDE
                           BUTTON('&Delete'),AT(197,122,42,12),USE(?Delete:6),HIDE
                           BUTTON('Create Fee Notes'),AT(269,132,69,12),USE(?CreateFeeNotesFromMAButton),HIDE
                           BUTTON('Adjust Time'),AT(405,137,93,13),USE(?AdjustTimeButton),HIDE
                           BUTTON('&Untag'),AT(191,162,48,12),USE(?UntagOne:5)
                           BUTTON('Change Billing Rate'),AT(339,162,69,12),USE(?ChangeBillingRateButton),HIDE
                           BUTTON('Tag &All'),AT(143,172,48,12),USE(?TagAll:5)
                           BUTTON('Unta&g All'),AT(191,172,48,12),USE(?UntagAll:5)
                           BUTTON('Sho&w Tagged'),AT(4,338,54,14),USE(?MA:OptFilterButton),TIP('Show "All" or "Only Tagged" items?')
                           BUTTON,AT(61,339,16,12),USE(?BillableIcon),SKIP,FLAT,TIP('Fee Notes were inserted from these Time Records'),ICON('bok.ico')
                           STRING('= Fee Note created'),AT(76,340),USE(?BillableIconString)
                           BUTTON,AT(141,339,16,12),USE(?PostedIcon),SKIP,FLAT,TIP('Fee Notes were inserted and have been posted from these Time Records'),ICON('smmoney.ico')
                           STRING('= Fee Note posted'),AT(156,340),USE(?PostedIconString)
                           PROMPT('Totals:'),AT(433,340),USE(?LOC:TotalMAMinutes:Prompt)
                           ENTRY(@s19),AT(457,340,52,10),USE(LOC:TotalMAMinutes),SKIP,LEFT(1),FONT('MS Sans Serif',,,FONT:bold),COLOR(COLOR:Silver),TIP('The total time'),READONLY
                           ENTRY(@n-15.2b),AT(513,340,56,10),USE(LOC:TotalMABillableAmount),SKIP,DECIMAL(12),FONT('MS Sans Serif',,,FONT:bold),COLOR(COLOR:Silver),TIP('The total billable amount'),READONLY
                         END
                         TAB('  DataLin&k  '),USE(?DataLinkTab),HIDE
                           GROUP,AT(2,1,572,35),USE(?DataLinkGroup),BOXED
                             BUTTON,AT(8,8,28,24),USE(?SendReceiveButton),LEFT,TIP('Check for Messages (Send/Receive)'),ICON('REPLACE2.ico')
                             BUTTON,AT(37,8,28,24),USE(?ProcessInboxMessages),TIP('Process the messages in your inbox.'),ICON('settings2.ico')
                             BUTTON,AT(66,8,28,24),USE(?SendXMLMessageButton),LEFT,TIP('Send a Message'),ICON('SendMessage.ico')
                             BUTTON,AT(95,8,28,24),USE(?ViewDatalinkXML),LEFT,TIP('View the XML File associated with this Message'),ICON('note_view.ico')
                             BUTTON,AT(124,8,28,24),USE(?ExploreInbox),LEFT,TIP('View the files stored in the Inbox'),ICON('inbox_into.ico')
                             BUTTON,AT(182,8,28,24),USE(?ExploreOutbox),LEFT,TIP('View the files stored in the Outbox'),ICON('outbox_out.ico')
                             BUTTON,AT(211,8,28,24),USE(?SetupDataLinkButton),LEFT,TIP('DataLink Settings'),ICON('WINDOW_GEAR.ico')
                             BUTTON,AT(240,8,28,24),USE(?DAT:QBESearchButton),TIP('Search for Messages using QBE'),ICON('folder_view.ico')
                             BUTTON,AT(269,8,28,24),USE(?DAT:QBEPrintButton),TIP('DataLink report'),ICON('printer.ico')
                             BUTTON,AT(298,8,25,24),USE(?DataLinkJumpToMatterButton),LEFT,TIP('Jump to the Matter associated with this Message'),ICON('index_new.ico')
                             PROMPT('M&atter:'),AT(478,9),USE(?LOC:DAT_MatterPrompt),TRN
                             LIST,AT(506,9,52,9),USE(LOC:DAT_Matter),TIP('Display Messages for which Matters'),FORMAT('36L(2)@s9@'),DROP(4),FROM('All|Current|Filtered|Tagged')
                             BUTTON('Button 210'),AT(153,8,28,24),USE(?ViewDatalinkXMLFolder),LEFT,TIP('View the folder where the XMLs are stored for this matter'),ICON('WINDOW_VIEW.ico')
                             PROMPT('&Date:'),AT(478,23),USE(?LOC:DAT_Period:Prompt),TRN
                             LIST,AT(506,23,52,9),USE(LOC:DAT_Period),VSCROLL,TIP('The date range to display items'),FORMAT('76L(2)@s19@'),DROP(8),FROM('Today|All|This Week|Yesterday|This Month|Last Month|This Year|Custom')
                             BUTTON('...'),AT(562,23,9,9),USE(?CustomDAT_PeriodButton),TIP('Specify the date range')
                           END
                           LIST,AT(7,68,561,267),USE(?LawMatterMessageBrowse),IMM,HVSCROLL,FORMAT('9L|FI@s10@49L(2)|M~Date~@d17b@60L(2)|M~File Ref~@s49@100L(2)|M~Matter~@s99@39R(2' &|
   ')|M~Law Ref~R(3)@n_9@36L(4)|M~To/From~L(2)@s9@35L(7)|M~Message~L(1)@n_5b@180L(2)' &|
   '|M~Description~@s100@550L(2)|M~File Name~@s99@150L(2)|M~WebService Reference~@s3' &|
   '9@50L(2)|M~WebService Status~@s99@'),FROM(Queue:Browse:2)
                           BUTTON('Export DataLink Messages'),AT(231,90,93,13),USE(?ExportDataLinkButton),HIDE
                           BUTTON('&Insert'),AT(149,108,42,12),USE(?Insert:4),HIDE
                           BUTTON('&Change'),AT(193,108,42,12),USE(?Change:4),HIDE
                           BUTTON('&Delete'),AT(237,108,42,12),USE(?Delete:4),HIDE
                           BUTTON('&Tag'),AT(109,140,48,12),USE(?TagOne:6)
                           BUTTON('&Untag'),AT(157,140,48,12),USE(?UntagOne:6)
                           BUTTON('Tag &All'),AT(109,151,48,12),USE(?TagAll:6)
                           BUTTON('Unta&g All'),AT(157,151,48,12),USE(?UntagAll:6)
                           BUTTON('Sho&w Tagged'),AT(7,339,54,12),USE(?MME:OptFilterButton),TIP('Show "All" or "Only Tagged" items?')
                           STRING(@s50),AT(7,57,134,10),USE(LOC:DataLinkInboxStatus)
                         END
                         TAB('  &Bond Centre  '),USE(?ABSALinkTab),HIDE
                           GROUP,AT(2,1,572,35),USE(?ABSALinkGroup),BOXED
                             BUTTON,AT(11,8,28,24),USE(?ABSAImportExportButton),LEFT,TIP('Download Messages from the Bond Centre'),ICON('server_to_client.ico')
                             BUTTON,AT(43,8,28,24),USE(?SendABSAMessageButton),DISABLE,LEFT,TIP('Send a Message to the Bond Centre'),ICON('server_from_client.ico')
                             BUTTON,AT(75,8,28,24),USE(?ABSASendReceiveDocsButton),DISABLE,LEFT,TIP('Download documents from the Bond Centre'),ICON('document_down.ico')
                             BUTTON,AT(107,8,25,24),USE(?DocumentLogButton:2),TIP('View the Document Log for this Matter'),ICON('folder_document.ico')
                             BUTTON,AT(296,8,25,24),USE(?ABSALinkJumpToMatterButton),LEFT,TIP('Jump to the Matter associated with this Message'),ICON('index_new.ico')
                             BUTTON,AT(136,8,28,24),USE(?STDOnlineDocument),TIP('Assemble the online KODA documents<13,10>for the current matter'),ICON('assemble_koda1.jpg')
                             BUTTON,AT(168,8,28,24),USE(?Internet),LEFT,TIP('Go to the LAW Property website<13,10>www.e4.co.za<13,10>'),ICON('earth_preferences.ico')
                             BUTTON,AT(200,8,28,24),USE(?InternetNew),LEFT,TIP('Go to the LAW Compliance website<13,10>www.ficacard.co.za'),ICON('earth_lock.ico')
                             BUTTON,AT(232,8,28,24),USE(?ABSAMessageCentreButton),HIDE,LEFT,TIP('Load the Bond message centre'),ICON('mail_server.ico')
                             BUTTON,AT(264,8,28,24),USE(?ABSACircularsButton),LEFT,TIP('View the Bank Circulars'),ICON('note_view.ico')
                             PROMPT('M&atter:'),AT(480,9),USE(?LOC:ABSA_MatterPrompt),TRN
                             LIST,AT(504,9,52,9),USE(LOC:ABSA_Matter),TIP('Display Messages for which Matters'),FORMAT('36L(2)@s9@'),DROP(3),FROM('All|Current|Filtered')
                             ENTRY(@s19),AT(362,9,25,10),USE(LOC:ABSA_TurnAroundTime),SKIP,DISABLE,HIDE,COLOR(COLOR:Silver),READONLY
                             PROMPT('To/From:'),AT(392,22),USE(?LOC:ABSA_Direction:Prompt),TRN
                             LIST,AT(424,22,47,9),USE(LOC:ABSA_Direction),TIP('Display Sent/Received Messages'),DROP(5),FROM('All|#All|To|#To|From|#From')
                             PROMPT('&Bank:'),AT(400,9),USE(?LOC:ABSA_DG_Code:Prompt),TRN
                             LIST,AT(424,9,47,9),USE(LOC:ABSA_DG_Code),TIP('Select the Document Set to filter with'),DROP(5),FROM('All|#All|ABSA|#ABSA|STD|#STD')
                             PROMPT('&Date:'),AT(480,22),USE(?LOC:ABSA_Period:Prompt),TRN
                             LIST,AT(504,23,52,9),USE(LOC:ABSA_Period),VSCROLL,TIP('The date range to display items'),FORMAT('76L(2)@s19@'),DROP(8),FROM('Today|All|This Week|Yesterday|This Month|Last Month|This Year|Custom')
                             BUTTON('...'),AT(560,23,9,9),USE(?CustomABSA_PeriodButton),TIP('Specify the date range')
                             PROMPT('Days in Pipeline:'),AT(306,9),USE(?LOC:ABSA_TurnAroundTime:Prompt),TRN,HIDE
                             BUTTON('Button 218'),AT(325,8,25,24),USE(?ABSAUBODocuments),DISABLE,HIDE,LEFT,TIP('Retrieve the UBO Documents for this matter'),ICON('branch.ico')
                           END
                           STRING(@s100),AT(48,56,298,10),USE(LOC:ABSAMatterState),HIDE
                           STRING('Matter State:'),AT(8,56),USE(?LOC:ABSAMatterState:Prompt),HIDE
                           STRING(@s75),AT(383,56,185,10),USE(LOC:ABSAExportedMessage),FONT(,,COLOR:Red,,CHARSET:ANSI)
                           LIST,AT(8,69,560,250),USE(?ABSALinkBrowse),IMM,HVSCROLL,FORMAT('50L(2)|M~Date~@d17b@37L(2)|M~Time~@t3@60L(2)|M~File Ref~@s49@150L(2)|M~Matter~@s' &|
   '199@60L(2)|M~Branch~@s19@24L(2)|M~Bank~@s5@68L(2)|M~Sent/Received By~@s50@23R(5)' &|
   '|M~No~C(2)@n_5@169L(2)|M~Message Description~@s100@40L(2)|M~To/From~@s10@1020L(2' &|
   ')|M~Details~@s255@'),FROM(Queue:Browse:9)
                           BUTTON('&Print'),AT(257,116,46,14),USE(?Print:4),HIDE,TIP('Print This List')
                           BUTTON('&Insert'),AT(179,141,42,12),USE(?Insert:12),HIDE
                           BUTTON('&Change'),AT(223,141,42,12),USE(?Change:10),HIDE
                           BUTTON('&Delete'),AT(267,141,42,12),USE(?Delete:10),HIDE
                           BUTTON('Standard Bank Workflow'),AT(8,325,82,22),USE(?ABSAMilestoneRulesButton),SKIP,LEFT,TIP('View  a document explaining the current Messages and Workflow for this Bank'),ICON('std.ico')
                           BUTTON('ABSA Bond Centre Interface'),AT(201,325,84,22),USE(?AbsaBondCentreInterfaceHelpButton),SKIP,LEFT,ICON('absa.ico')
                           BUTTON('SBSA Processes and Escalation Procedure'),AT(96,325,100,22),USE(?SBSAProcessEscalationProcedure),SKIP,LEFT,TIP('View the SBSA Processes and Escalation Procedure'),ICON('std.ico')
                         END
                         TAB('  &Gateway  '),USE(?FNBLinkTab),HIDE
                           GROUP,AT(2,1,572,35),USE(?FNBLinkGroup),BOXED
                             BUTTON,AT(8,8,28,24),USE(?AttorneyGatewayButton),LEFT,TIP('Import and Export messages to and from Attorney Gateway'),ICON('SendReceive.ico')
                             BUTTON,AT(70,8,28,24),USE(?DocumentHubButton),LEFT,TIP('Download documents from Attorney Gateway'),ICON('document_down.ico')
                             BUTTON,AT(39,8,28,24),USE(?SendFNBMessageButton),LEFT,TIP('Send a Message via Attorney Gateway'),ICON('server_from_client.ico')
                             BUTTON,AT(101,8,28,24),USE(?PrintFNBInstructionButton),LEFT,TIP('Print the Instruction details'),ICON('printer_view.ico')
                             BUTTON,AT(132,8,25,24),USE(?DocumentLogButton:3),TIP('View the Document Log for this Matter'),ICON('folder_document.ico')
                             BUTTON,AT(160,8,28,24),USE(?DocumentHubButton:2),LEFT,TIP('Download documents from Attorney Gateway'),ICON('assemble_koda1.jpg')
                             BUTTON,AT(191,8,28,24),USE(?AG_MessageCentreButton),LEFT,TIP('Load the Attorney Gateway Message Centre'),ICON('mail_server.ico')
                             BUTTON,AT(222,8,28,24),USE(?FNBCircularsButton),LEFT,TIP('View the Bank Circulars'),ICON('note_view.ico')
                             BUTTON,AT(253,8,25,24),USE(?FNBLinkJumpToMatterButton),LEFT,TIP('Jump to the Matter associated with this Message'),ICON('index_new.ico')
                             PROMPT('M&atter:'),AT(482,9),USE(?LOC:FNB_MatterPrompt),TRN
                             LIST,AT(506,9,52,9),USE(LOC:FNB_Matter),TIP('Display Messages for which Matters'),FORMAT('36L(2)@s9@'),DROP(3),FROM('All|Current|Filtered')
                             PROMPT('Division:'),AT(318,9),USE(?LOC:AG_Suite_Description:Prompt),TRN
                             LIST,AT(350,9,127,9),USE(LOC:AG_Suite_Description),VSCROLL,FORMAT('120L(2)|M@s50@'),DROP(15),FROM(AG_Division:Queue)
                             PROMPT('&Date:'),AT(482,23),USE(?LOC:FNB_Period:Prompt),TRN
                             LIST,AT(506,23,52,9),USE(LOC:FNB_Period),VSCROLL,TIP('The date range to display items'),FORMAT('76L(2)@s19@'),DROP(8),FROM('Today|All|This Week|Yesterday|This Month|Last Month|This Year|Custom')
                             BUTTON('...'),AT(562,23,9,9),USE(?CustomFNB_PeriodButton),TIP('Specify the date range')
                           END
                           STRING(@s75),AT(339,57,228,10),USE(LOC:FNBExportedMessage),RIGHT,FONT(,10,COLOR:Red,FONT:bold,CHARSET:ANSI)
                           STRING('Matter State:'),AT(9,57),USE(?LOC:FNBMatterState:Prompt)
                           STRING(@s100),AT(51,57,260,10),USE(LOC:FNBMatterState)
                           LIST,AT(9,70,558,278),USE(?FNBLinkBrowse),IMM,HVSCROLL,FORMAT('50L(2)|M~Date~@d17b@35L(2)|M~Time~@t3@60L(2)|M~File Ref~@s49@150L(2)|M~Matter~@s' &|
   '199@60L(2)|M~Branch~@s19@33L(5)|M~Docs~L(2)@s5@150L(2)|M~Division~@s50@69L(2)|M~' &|
   'Sent/Received By~@s50@22R(2)|M~No~C(3)@n_5@160L(2)|M~Message~@s49@33L(2)|M~To/Fr' &|
   'om~@s4@1020L(2)|M~Details~@s255@/'),FROM(Queue:Browse:7)
                           BUTTON('Change Matter State'),AT(247,114,86,14),USE(?ChangeMatterStateButton),HIDE
                           BUTTON('Make Config File'),AT(315,132,86,14),USE(?MakeConfigButton),HIDE
                           BUTTON('&Insert'),AT(91,138,42,12),USE(?Insert:7),HIDE
                           BUTTON('&Change'),AT(135,138,42,12),USE(?Change:7),HIDE
                           BUTTON('&Delete'),AT(179,138,42,12),USE(?Delete:7),HIDE
                           BUTTON('Specify Schema Location'),AT(319,164,86,14),USE(?MakeConfigButton:2),HIDE
                           BUTTON('&Print'),AT(171,170,46,14),USE(?Print),HIDE,TIP('Print This List')
                         END
                         TAB('  &SARS  '),USE(?SARSTab),HIDE
                           GROUP,AT(2,1,572,35),USE(?SARSLinkGroup),BOXED
                             BUTTON,AT(10,8,28,24),USE(?SARSSubmitTDButton),LEFT,TIP('Apply for Transfer Duty<13,10>SARSTransferDuty.exe'),ICON('DocumentsUp.ico')
                             BUTTON,AT(42,8,28,24),USE(?SARSSubmitCancellationButton),DISABLE,LEFT,TIP('Send a TDR Cancellation Message to SARS<13,10>SARSTransferDuty.exe'),ICON('outbox_out.ico')
                             BUTTON,AT(74,8,28,24),USE(?SARSRequestCorrespondenceButton),DISABLE,LEFT,TIP('Request Correspondence from SARS<13,10>SARSTransferDuty.exe'),ICON('inbox_into.ico')
                             BUTTON,AT(106,8,28,24),USE(?SARSCheckStatusCurrentMatterButton),DISABLE,LEFT,TIP('Check Status on current matter<13,10>SARSTransferDuty.exe'),ICON('Documents2Help.ico')
                             BUTTON,AT(234,8,25,24),USE(?SARSLinkJumpToMatterButton),LEFT,TIP('Jump to the Matter associated with this Message'),ICON('index_new.ico')
                             BUTTON,AT(138,8,28,24),USE(?SARSCheckAllStatusesButton),DISABLE,LEFT,TIP('Check Status on all matters<13,10>SARSTransferDuty.exe'),ICON('DocumentsHelp.ico')
                             BUTTON,AT(170,8,28,24),USE(?Internet:3),LEFT,TIP('Go to the SARS website<13,10>www.sarsefiling.co.za'),ICON('earth_preferences.ico')
                             BUTTON,AT(202,8,28,24),USE(?SARSCircularsButton),LEFT,TIP('Display SARS Circulars'),ICON('note_view.ico')
                             BUTTON,AT(263,8,28,24),USE(?SARSRegisterButton),HIDE,LEFT,TIP('Register with SARS per Employee<13,10>SARSTransferDuty.exe'),ICON('User3_OK.ico')
                             PROMPT('M&atter:'),AT(481,9),USE(?LOC:SARS_MatterPrompt),TRN
                             LIST,AT(505,9,52,9),USE(LOC:SARS_Matter),TIP('Display SARS collaborations for which Matters'),FORMAT('36L(2)@s9@'),DROP(3),FROM('All|Current|Filtered')
                             PROMPT('&Date:'),AT(481,23),USE(?LOC:SARS_Period:Prompt),TRN
                             LIST,AT(505,23,52,9),USE(LOC:SARS_Period),VSCROLL,TIP('The date range to display items'),FORMAT('76L(2)@s19@'),DROP(8),FROM('Today|All|This Week|Yesterday|This Month|Last Month|This Year|Custom')
                             BUTTON('...'),AT(561,23,9,9),USE(?CustomSARS_PeriodButton),TIP('Specify the date range')
                           END
                           LIST,AT(11,57,558,293),USE(?SARSLinkBrowse),IMM,HVSCROLL,FORMAT('48L(2)|M~Date~@d17@36L(2)|M~Time~@t3@70L(2)|M~File Ref~@s49@67L(2)|M~Employee~@s' &|
   '50@80L(2)|M~Type~@s20@87L(2)|M~TD Reference Number~@s50@141L(2)|M~Status~@s255@1' &|
   '020L(2)|M~Error Message~@s255@'),FROM(Queue:Browse:11)
                           BUTTON('&Change'),AT(227,107,42,12),USE(?Change:12),HIDE
                           BUTTON('&Delete'),AT(271,107,42,12),USE(?Delete:12),HIDE
                         END
                       END
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Open                   PROCEDURE(),DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeCloseEvent         PROCEDURE(),BYTE,PROC,DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
TakeFieldEvent         PROCEDURE(),BYTE,PROC,DERIVED
TakeNewSelection       PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW54                CLASS(BrowseClass)               !Browse using ?MattersBrowse
Q                      &Queue:Browse:1                !Reference to browse queue
ApplyFilter            PROCEDURE(),DERIVED
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
Open                   PROCEDURE(),DERIVED
ResetQueue             PROCEDURE(BYTE ResetMode),DERIVED
ResetSort              PROCEDURE(BYTE Force),BYTE,PROC,DERIVED
SetQueueRecord         PROCEDURE(),DERIVED
TakeEvent              PROCEDURE(),DERIVED
TakeNewSelection       PROCEDURE(),DERIVED
ValidateRecord         PROCEDURE(),BYTE,DERIVED
                     END

BRW54::Sort0:Locator EntryLocatorClass                !Default Locator
BRW54::Sort1:Locator EntryLocatorClass                !Conditional Locator - LOC:SortKey54 = -5
BRW54::Sort2:Locator EntryLocatorClass                !Conditional Locator - LOC:SortKey54 = 7
BRW54::Sort3:Locator EntryLocatorClass                !Conditional Locator - LOC:SortKey54 = -7
BRW54::Sort4:Locator EntryLocatorClass                !Conditional Locator - LOC:SortKey54 = 9
BRW54::Sort5:Locator EntryLocatorClass                !Conditional Locator - LOC:SortKey54 = -9
BRW54::Sort6:Locator EntryLocatorClass                !Conditional Locator - LOC:SortKey54 = 12
BRW54::Sort7:Locator EntryLocatorClass                !Conditional Locator - LOC:SortKey54 = -12
BRW54::Sort8:Locator StepLocatorClass                 !Conditional Locator - LOC:SortKey54 = 17
BRW54::Sort9:Locator StepLocatorClass                 !Conditional Locator - LOC:SortKey54 = -17
BRW52                CLASS(BrowseClass)               !Browse using ?FileNoteBrowse
Q                      &Queue:Browse:4                !Reference to browse queue
ApplyFilter            PROCEDURE(),DERIVED
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
PrimeRecord            PROCEDURE(BYTE SuppressClear = 0),BYTE,PROC,DERIVED
ResetQueue             PROCEDURE(BYTE ResetMode),DERIVED
ResetSort              PROCEDURE(BYTE Force),BYTE,PROC,DERIVED
SetQueueRecord         PROCEDURE(),DERIVED
ValidateRecord         PROCEDURE(),BYTE,DERIVED
                     END

BRW2                 CLASS(BrowseClass)               !Browse using ?FeeNoteBrowse
Q                      &Queue:Browse                  !Reference to browse queue
ApplyFilter            PROCEDURE(),DERIVED
Ask                    PROCEDURE(BYTE Request),BYTE,PROC,DERIVED
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
ResetQueue             PROCEDURE(BYTE ResetMode),DERIVED
SetQueueRecord         PROCEDURE(),DERIVED
ValidateRecord         PROCEDURE(),BYTE,DERIVED
                     END

BRW15                CLASS(BrowseClass)               !Browse using ?ToDoNoteBrowse
Q                      &Queue:Browse:3                !Reference to browse queue
ApplyFilter            PROCEDURE(),DERIVED
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
ResetQueue             PROCEDURE(BYTE ResetMode),DERIVED
SetQueueRecord         PROCEDURE(),DERIVED
ValidateRecord         PROCEDURE(),BYTE,DERIVED
                     END

BRW22                CLASS(BrowseClass)               !Browse using ?TimeRecordingBrowse
Q                      &Queue:Browse:5                !Reference to browse queue
ApplyFilter            PROCEDURE(),DERIVED
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
ResetQueue             PROCEDURE(BYTE ResetMode),DERIVED
SetQueueRecord         PROCEDURE(),DERIVED
ValidateRecord         PROCEDURE(),BYTE,DERIVED
                     END

BRW36                CLASS(BrowseClass)               !Browse using ?LawMatterMessageBrowse
Q                      &Queue:Browse:2                !Reference to browse queue
ApplyFilter            PROCEDURE(),DERIVED
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
ResetQueue             PROCEDURE(BYTE ResetMode),DERIVED
SetQueueRecord         PROCEDURE(),DERIVED
ValidateRecord         PROCEDURE(),BYTE,DERIVED
                     END

BRW36::Sort0:Locator StepLocatorClass                 !Default Locator
BRW46                CLASS(BrowseClass)               !Browse using ?FNBLinkBrowse
Q                      &Queue:Browse:7                !Reference to browse queue
ApplyFilter            PROCEDURE(),DERIVED
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
ResetQueue             PROCEDURE(BYTE ResetMode),DERIVED
ResetSort              PROCEDURE(BYTE Force),BYTE,PROC,DERIVED
SetQueueRecord         PROCEDURE(),DERIVED
                     END

BRW35                CLASS(BrowseClass)               !Browse using ?ABSALinkBrowse
Q                      &Queue:Browse:9                !Reference to browse queue
ApplyFilter            PROCEDURE(),DERIVED
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
ResetQueue             PROCEDURE(BYTE ResetMode),DERIVED
ResetSort              PROCEDURE(BYTE Force),BYTE,PROC,DERIVED
SetQueueRecord         PROCEDURE(),DERIVED
                     END

BRW33                CLASS(BrowseClass)               !Browse using ?SARSLinkBrowse
Q                      &Queue:Browse:11               !Reference to browse queue
ApplyFilter            PROCEDURE(),DERIVED
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
ResetQueue             PROCEDURE(BYTE ResetMode),DERIVED
SetQueueRecord         PROCEDURE(),DERIVED
                     END

BRW33::Sort0:Locator StepLocatorClass                 !Default Locator
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END

LOC:UserInputString     CSTRING(200)
LOC:UserPrompt          CSTRING(30)

LOC:DocgenType          LIKE(DG:Type)

TheSorter          LONG
SAV:ReportFileID   LONG

LOC:TotalRows           LONG
LOC:CurrentRow          LONG
LOC:TotalColumns        SHORT


MatterQueue             QUEUE,PRE(MQ)
RecordID                LONG
                        END

SAV:ReportCategory  LIKE(LOC:ReportCategory)


            MAP
               AddElectronicLinkLog(STRING, STRING, <STRING>, <STRING>)
               GetLAW_Mattr(),BYTE
               GetLAWref(LONG),STRING
               RunBondCentreProgram(LONG,LONG,STRING)
            END


  CODE
  GlobalResponse = ThisWindow.Run()

ChangeQuickSearchPrompt   ROUTINE


       IF ABS(LOC:SortKey54) = 12
          ?LOC:QuickSearch{PROP:Tooltip} = 'Type in the first part of the Description and press TAB'
       ELSIF ABS(LOC:SortKey54) = 9
          ?LOC:QuickSearch{PROP:Tooltip} = 'Type in the RecordID and press TAB'
       ELSIF ABS(LOC:SortKey54) = 7
          ?LOC:QuickSearch{PROP:Tooltip} = 'Type in the Alternate Reference and press TAB'
       ELSIF ABS(LOC:SortKey54) = 5
         ?LOC:QuickSearch{PROP:Tooltip} = 'Type in the File Ref and press TAB'
       END




LoadOnlineDocs      ROUTINE

       IF MAT:DocgenID
          DG:RecordID = MAT:DocgenID
          IF ~Access:Docgen.TryFetch(DG:PrimaryKey)
              IF UserLicensed(DG:RecordID)
                 PropSQLNext('Select top 1 KODA.RecordID from Docgen BASE  inner join Docgen KODA on KODA.Code = ''KD''+BASE.Code AND BASE.RecordID='&DG:RecordID)

                 if ROW:Counter AND UserLicensed(ROW:Counter)
                 !CASE DG:Code
                 ! 30/03/2015 Sameer: Add ABSA and NED since KODA can do these now !18 July 2017 AS Can HIP and most FNB things !
                 !25 Nov 2019 added ABSAP (KDS)
                 !OF 'STD' OROF 'ABSA' OROF 'NED' OROF 'CAN' OROF 'FNB' OROF 'FNBH' OROF 'HIP' OROF 'MERC' OROF 'FNBWC' !OROF 'ABSAP' !OROF 'FNBLC' !OROF 'FNBCP' Taking out FNBLC as per email from Susan. FNBCP was taken out as per email from Ilze
                    OnlineDocs(MAT:RecordID,DG:Code)
                !OF 'FNBLC' OROF 'FNBCP'     !Adding this in to test FB 317 Kelvin 24 Oct 2017 - taking out because KODA removed it from their XSD - 25 Nov 2019
                 !   IF CTL:FirmCode = 'ACME01'
                 !       OnlineDocs(MAT:RecordID,DG:Code)
                 !   ELSE
                 !       MESSAGE('There are no Online Documents available for this document set:|' & DG:Description,'Incorrect Document Set', ICON:Exclamation)
                 !   END
                 elsif DG:Code = 'TRN'
                 !OF 'TRN'

                    PropSQLNext('Select RecordId, AG_MatterKref From Matter Where RecordID = ' & MAT:RecordID)
                    If ~ROW:Description
                        Message('This Matter does not have a AG_MatterKref Reference Number','Unable to download Documents',ICON:Exclamation)
                        EXIT
                    End

                    PropSQLNext('Select Count (1) From AG_MatterMessage Where MatterID = ' & MAT:RecordID)
                    If ~ROW:Counter
                        Message('There are no existing Messages for this Matter','Unable to download Documents',ICON:Exclamation)
                        EXIT
                    End

                    DO LoadPropertyHubDocuments

                ELSE
                    MESSAGE('There are no Online Documents available for this document set:|' & DG:Description,'Incorrect Document Set', ICON:Exclamation)
                   ! MESSAGE('Unable to load the Online Documents for this Matter because it is a ' & DG:Description & ' type of Matter.','Incorrect Document Set', ICON:Exclamation)

                END
             END
         END
     ELSE
        MESSAGE('There are no Online Documents available for this document set:|' & DG:Description,'Incorrect Document Set', ICON:Exclamation)
        !MESSAGE('Unable to load the Online Documents - No Document Set specified for this Matter (' & MAT:FileRef & ')','No Document Set', ICON:Exclamation)
     END


LoadPropertyHubDocuments    ROUTINE


        IF EXISTS('PropertyHub.EXE')

          PropSQLNext('Select Count (1) From DocLog Where MatterId = ' & MAT:RecordID)
          Count# = ROW:Counter

          RUN('PropertyHub.EXE ConnectionString="' & GLO:ConnectionString & '" ' & MAT:RecordID & ' ' & CEM:RecordID,1)

          If ErrorCode()
            Message(Error() & '||Error running program PropertyHub.EXE||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
          Else

            AddElectronicLinkLog('Loaded PropertyHub.EXE','AG')

            PropSQLNext('Select Count (1) From DocLog Where MatterId = ' & MAT:RecordID)
            If Count# <> ROW:Counter
              GLO:MatterID = MAT:RecordID
              BrowseDocLog
              GLO:MatterID = 0
            End

          End
        Else
          Message('PropertyHub.EXE Not Found||Phone LegalSuite Support for assistance','Error loading program',ICON:Exclamation)
        End



CheckFeeEstimate    ROUTINE


  IF (CEM:FeeEstimateWarningFlag OR MAT:FeeEstimateWarningFlag) AND MAT:FeeEstimate AND LOC:LastWarningMatterID <> MAT:RecordID
     
     PropSQLNext('Select Sum(AmountIncl) FROM FeeNote WHERE MatterID = ' & MAT:RecordID)
     IF ROW:Counter > MAT:FeeEstimate
        MESSAGE('Warning.||This Matter''s Fees and Disbursements (' & CLIP(LEFT(FORMAT(ROW:Counter,@n11.2)))  & ') exceed the Fee Estimate (' & CLIP(LEFT(FORMAT(MAT:FeeEstimate,@n11.2)))  & ') set for this Matter',MAT:FileRef & ' - ' & MAT:Description,ICON:Exclamation)
     END
  END

  LOC:LastWarningMatterID = MAT:RecordID


AddRecipientsToGlabalEmailQueue     ROUTINE

          SETCURSOR(CURSOR:Wait)

          GLO:EmailRoleID = ROL:RecordID
          GLO:EmailLanguageID = 0

          THIS:PartyLanguageID = -1
          LOC:GetEmailLanguageFlag = 0

      
          FREE(GEMQ:EmailQueue)
          CLEAR(GEMQ:EmailQueue)
      
          FREE(GEQ:ErrorQueue)
          CLEAR(GEQ:ErrorQueue)

           CLEAR(MAT:Record)
           MAT:RecordID = FstTag:PtrM(TAG:Matter)
      
           LOOP
      
              LOC:ContactID = 0
      
              CLEAR(MP:Record)
              MP:MatterID = MAT:RecordID
              MP:RoleID = GLO:EmailRoleID
              SET(MP:MatterRoleKey,MP:MatterRoleKey)
      
              LOOP UNTIL Access:MatParty.Next()
      
                   IF ~(MP:MatterID = MAT:RecordID) THEN BREAK.
                   IF ~(MP:RoleID = GLO:EmailRoleID) THEN BREAK.


                  IF ~MP:LanguageID THEN MP:LanguageID = CTL:DefaultLanguageID.    ! JUST IN CASE.

                  ! CHECK EMAIL LANGUAGE
                  IF THIS:PartyLanguageID = -1           ! FIRST ONE
                     THIS:PartyLanguageID = MP:LanguageID
                  ELSE
                     IF ~(THIS:PartyLanguageID = MP:LanguageID)
                          LOC:GetEmailLanguageFlag = 1  ! ASK THE USER WHAT LANGUAGE THE EMAIL IS IN
                     END
                  END

                  PropSQLNext('SELECT OtherPartyID FROM ParRel WHERE PartyID = ' & MP:PartyID & ' AND DefaultContactFlag = 1')
                  LOC:ContactID = ROW:Counter
                  IF LOC:ContactID 
                     LOC:ThisPartyID = LOC:ContactID
                  ELSE
                     LOC:ThisPartyID = MP:PartyID
                  END
      
                  LOC:FoundEmailAddress = 0
      
                  CLEAR(PTE:Record)
                  PTE:PartyID = LOC:ThisPartyID
                  PTE:TelephoneTypeID = CTL:EmailPhoneID
                  SET(PTE:TelephoneTypeKey,PTE:TelephoneTypeKey)
                  LOOP UNTIL Access:ParTele.Next()
      
                       IF ~(PTE:PartyID = LOC:ThisPartyID) THEN BREAK.
      
                       IF PTE:Number
      
                          LOC:FoundEmailAddress = 1
      
                          GEMQ:EmailAddress = PTE:Number
                          GEMQ:PartyID = LOC:ThisPartyID
                          GEMQ:MatterID = MP:MatterID
                          GEMQ:PartyName = GetDescription('PARTY NAME',LOC:ThisPartyID)
      
                          ADD(GEMQ:EmailQueue,+GEMQ:EmailAddress)
      
                       END

                  END


                  IF LOC:FoundEmailAddress = 0 AND LOC:ContactID  ! IF NO EMAIL ADDRESSES FOR THE CONTACT. TRY THE MAIN PARTY

                     LOC:ThisPartyID = MP:PartyID

                     CLEAR(PTE:Record)
                     PTE:PartyID = LOC:ThisPartyID
                     PTE:TelephoneTypeID = CTL:EmailPhoneID
                     SET(PTE:TelephoneTypeKey,PTE:TelephoneTypeKey)
                     LOOP UNTIL Access:ParTele.Next()
         
                          IF ~(PTE:PartyID = LOC:ThisPartyID) THEN BREAK.
         
                          IF PTE:Number
         
                             LOC:FoundEmailAddress = 1
         
                             GEMQ:EmailAddress = PTE:Number
                             GEMQ:PartyID = LOC:ThisPartyID
                             GEMQ:MatterID = MP:MatterID
                             GEMQ:PartyName = GetDescription('PARTY NAME',LOC:ThisPartyID)
         
                             ADD(GEMQ:EmailQueue,+GEMQ:EmailAddress)
         
                          END
                     END

                  END


                  IF LOC:FoundEmailAddress = 0
      
                      PropSQLNext('Select 0,Name,0,0,0,MatterPrefix FROM Party WHERE RecordID = ' & LOC:ThisPartyID)
      
                      GEQ:Message1 = ROW:Description1      ! CHECK IF ALREADY ADDED THIS PARTY TO THE ERROR QUEUE
                      GET(GEQ:ErrorQueue,GEQ:Message1)
      
                      IF ERROR()
                         CLEAR(GEQ:ErrorQueue)
                         GEQ:PartyID = LOC:ThisPartyID
                         GEQ:MatterID = MP:MatterID
                         GEQ:Message1 = ROW:Description1
                         GEQ:Message2 = ROW:Description
                         GEQ:Message3 = 'No email address'
                         ADD(GEQ:ErrorQueue,GEQ:Message1)
                      END
      
      
                  END
      
      
              END
      
              MAT:RecordID = NxtTag:PtrM(TAG:Matter)
              IF ~MAT:RecordID THEN BREAK.
      
      
           END
           SETCURSOR

           IF LOC:GetEmailLanguageFlag

              CASE MESSAGE('Some ' & GetDescription('Role',GLO:EmailRoleID) & 's in these Matters have different Languages as their Default Language.||This could cause a problem if Merge Fields are used in the body of the Email.||Please specify the Language of this Email|','Select Email Language',ICON:Exclamation,'&English|&Afrikaans',1,0)

                   OF 1
                      GLO:EmailLanguageID = CTL:EnglishID
                   OF 2
                      GLO:EmailLanguageID = CTL:AfrikaansID

              END

           ELSE

              GLO:EmailLanguageID = THIS:PartyLanguageID

           END




CheckFutureTasks        ROUTINE


  ! **************** CHECK FOR ANY FUTURE TASKS ***********************************
  LOC:DisplayFutureTasksFlag = 0
  PROPSQLNext('SELECT RecordID FROM FutureTask WHERE EmployeeID = ' & CEM:RecordID & ' AND Status = 0 AND Date <= ' & GLO:TodaysDate & ' AND Date > 0')
  IF ROW:Counter
     LOC:DisplayFutureTasksFlag = 1
  END

  ! CHECK FOR ANY THAT ARE DELAYED UNTIL A CERTAIN CONDITION IS TRUE. NOTE: Date = 0
  PROPSQLNext('SELECT RecordID FROM FutureTask WHERE EmployeeID = ' & CEM:RecordID & ' AND Status = 0 AND Date = 0')

  IF ROW:Counter    ! IF THERE ARE SOME THEN CHECK THERE DELAYUNTIL CONDITION
     
     BIND('TAS:DelayUntil',TAS:DelayUntil)
     CLEAR(ROW:Counter)
     PropSQL('SELECT TaskID,'''',RecordID,MatterID FROM FutureTask WHERE EmployeeID = ' & CEM:RecordID & ' AND Status = 0 AND Date = 0')
     LOOP
         NEXT(RowCounter)
         IF ERROR() THEN BREAK.


         TAS:RecordID = ROW:Counter
         IF Access:Task.Fetch(TAS:PrimaryKey) THEN CYCLE.

         IF ~TAS:DelayUntil THEN CYCLE.

         GetAllTables(ROW:Amount2,0)

         IF EVALUATE(TAS:DelayUntil)  ! SET ITS DATE TO TODAY'S DATE SO IT WILL BE IN THE LIST OF FUTURE TASKS
            Matter{PROP:SQL} = 'UPDATE FutureTask SET Date = ' & GLO:TodaysDate & ' WHERE RecordID = ' & ROW:Amount1
            LOC:DisplayFutureTasksFlag = 1
         END

     END

     UNBIND(TAS:DelayUntil)


  END


  IF LOC:DisplayFutureTasksFlag
     GlobalRequest = SelectRecord
     DisplayFutureTask(0)

     IF GlobalResponse = RequestCompleted
        PROPSQL('SELECT RecordID FROM FutureTask WHERE EmployeeID = ' & CEM:RecordID & ' AND Status = 0 AND Date <= ' & GLO:TodaysDate)
        LOOP
           NEXT(RowCounter)
           IF ERROR() THEN BREAK.
           ProcessFutureTask(ROW:Counter)
        END
     END
  END




ProgramInitialization   ROUTINE
                               

      GLO:EnableInstantMessagingFlag = True   ! DELAYED THIS UNTIL AFTER THE DESKTOP HAS OPENED

      IF LOC:ProgramInitialized THEN EXIT.    ! RUN THESE FUNCTIONS BELOW EVERYTIME THE DESKTOP IS OPENED

      LOC:ProgramInitialized = 1


      DO CreateGlobalQueues


      IF ~GLO:ProgramStarted    ! RUN PROGRAM STARTED EVENT ONLY ONCE
          GLO:ProgramStarted = 1
          ProcessSystemEvent(EVENT:ProgramStarted,-1) 
      END
        

CreateGlobalQueues     ROUTINE

  ! CREATE A GLOBAL QUEUE OF Languages THAT CAN BE USED IN DROP DOWNS AND SELECT LISTS

  IF ~RECORDS(GLANQ:LanguageQueue)
      CLEAR(LAN:Record)
      SET(LAN:PrimaryKey,LAN:PrimaryKey)
      LOOP UNTIL Access:Language.Next()
           GLANQ:Description = LAN:Description
           GLANQ:RecordID = LAN:RecordID
           ADD(GLANQ:LanguageQueue)
      END
  END

  ! CREATE A GLOBAL QUEUE OF Branches THAT CAN BE USED IN DROP DOWNS AND SELECT LISTS
  IF ~RECORDS(GBRAQ:BranchQueue)
      CLEAR(BRA:Record)
      SET(BRA:PrimaryKey,BRA:PrimaryKey)
      
      LOOP UNTIL Access:Branch.Next()

           GBRAQ:Description = BRA:Description
           GBRAQ:RecordID = BRA:RecordID
           ADD(GBRAQ:BranchQueue,GBRAQ:RecordID)

      END
      
  END


CreateTaggedMatterList ROUTINE

         ! 18/11/2015 Sameer: Request from Jennifer: Always use the list of tagged matters from the TaggedMatter table
!        IF CntTag:PtrM(Tag:Matter) < 1000
!
!           LOC:TaggedMatterList = ''     ! BUILD UP A LIST OF TAGGED MATTERS
!
!           LOC:MatterID = FstTag:PtrM(Tag:Matter)
!           LOOP
!              LOC:TaggedMatterList = LOC:TaggedMatterList & LOC:MatterID
!              LOC:MatterID = NxtTag:PtrM(Tag:Matter)
!              IF ~LOC:MatterID THEN BREAK.
!              LOC:TaggedMatterList = LOC:TaggedMatterList & ','
!           END
!
!       ELSE
!
!           LOC:TaggedMatterList = 'SELECT MatterID FROM TaggedMatter WHERE EmployeeID = ' & CEM:RecordID
!
!       END
       
       LOC:TaggedMatterList = 'SELECT MatterID FROM TaggedMatter WHERE EmployeeID = ' & CEM:RecordID


ShowUnReadMessagesStatus        ROUTINE


  LOC:UnreadMessages = 0

  IF GLO:EnableABSALinkFlag
     PROPSQLNEXT('SELECT COUNT(1) FROM ABSA_MatterMessage JOIN Matter ON Matter.RecordID = ABSA_MatterMessage.MatterID WHERE ReadFlag = 0 AND Matter.EmployeeID = ' & CEM:RecordID)
     LOC:UnreadMessages += ROW:Counter
  END

  IF GLO:EnableFNBLinkFlag
     PROPSQLNEXT('SELECT COUNT(1) FROM AG_MatterMessage JOIN Matter ON Matter.RecordID = AG_MatterMessage.MatterID WHERE ReadFlag = 0 AND Matter.EmployeeID = ' & CEM:RecordID)
     LOC:UnreadMessages += ROW:Counter
  END


ResetColumnWidths         ROUTINE


   Access:EmpDisplaySettings.Open
   Access:EmpDisplaySettings.UseFile


   EDS:EmployeeID = CEM:RecordID
   IF Access:EmpDisplaySettings.TryFetch(EDS:PrimaryKey)
      CLEAR(EDS:Record)
      EDS:EmployeeID = CEM:RecordID
      Access:EmpDisplaySettings.Insert
   END

   Access:EmpDisplaySettings.Close
     !Added extra column for FB 1902
!   IF EDS:DesktopMatterColumn1 < 5 THEN EDS:DesktopMatterColumn1 =   10.
!   IF EDS:DesktopMatterColumn2 < 5 THEN EDS:DesktopMatterColumn2 =   10.
!   IF EDS:DesktopMatterColumn2 < 5 THEN EDS:DesktopMatterColumn2 =   10.
!   IF EDS:DesktopMatterColumn4 < 5 THEN EDS:DesktopMatterColumn4 =   60.
!   IF EDS:DesktopMatterColumn5 < 5 THEN EDS:DesktopMatterColumn5 =   90.
!   IF EDS:DesktopMatterColumn6 < 5 THEN EDS:DesktopMatterColumn6 =   60.
!   IF EDS:DesktopMatterColumn7 < 5 THEN EDS:DesktopMatterColumn7 =   60.
!   IF EDS:DesktopMatterColumn8 < 5 THEN EDS:DesktopMatterColumn8 =   30.
!   IF EDS:DesktopMatterColumn9 < 5 THEN EDS:DesktopMatterColumn9 =   20.
!   IF EDS:DesktopMatterColumn10 < 5 THEN EDS:DesktopMatterColumn10 = 85.
!   IF EDS:DesktopMatterColumn11 < 5 THEN EDS:DesktopMatterColumn11 = 120.
!   IF EDS:DesktopMatterColumn12 < 5 THEN EDS:DesktopMatterColumn12 = 40.
!   IF EDS:DesktopMatterColumn13 < 5 THEN EDS:DesktopMatterColumn13 = 70.
!   IF EDS:DesktopMatterColumn14 < 5 THEN EDS:DesktopMatterColumn14 = 80.
!   IF EDS:DesktopMatterColumn15 < 5 THEN EDS:DesktopMatterColumn15 = 75.
!   IF EDS:DesktopMatterColumn16 < 5 THEN EDS:DesktopMatterColumn16 = 55.
!   IF EDS:DesktopMatterColumn17 < 5 THEN EDS:DesktopMatterColumn17 = 75.
!   IF EDS:DesktopMatterColumn18 < 5 THEN EDS:DesktopMatterColumn18 = 50.
   IF EDS:DesktopMatterColumn1 < 5 THEN EDS:DesktopMatterColumn1 =   10.
   IF EDS:DesktopMatterColumn2 < 5 THEN EDS:DesktopMatterColumn2 =   10.
   IF EDS:DesktopMatterColumn3 < 5 THEN EDS:DesktopMatterColumn3 =   12.    
   IF EDS:DesktopMatterColumn4 < 5 THEN EDS:DesktopMatterColumn4 =   10.
   IF EDS:DesktopMatterColumn5 < 5 THEN EDS:DesktopMatterColumn5 =   60.
   IF EDS:DesktopMatterColumn6 < 5 THEN EDS:DesktopMatterColumn6 =   90.
   IF EDS:DesktopMatterColumn7 < 5 THEN EDS:DesktopMatterColumn7 =   60.
   IF EDS:DesktopMatterColumn8 < 5 THEN EDS:DesktopMatterColumn8 =   60.
   IF EDS:DesktopMatterColumn9 < 5 THEN EDS:DesktopMatterColumn9 =   30.
   IF EDS:DesktopMatterColumn10 < 5 THEN EDS:DesktopMatterColumn10 = 20.
   IF EDS:DesktopMatterColumn11 < 5 THEN EDS:DesktopMatterColumn11 = 85.
   IF EDS:DesktopMatterColumn12 < 5 THEN EDS:DesktopMatterColumn12 = 120.
   IF EDS:DesktopMatterColumn13 < 5 THEN EDS:DesktopMatterColumn13 = 40.
   IF EDS:DesktopMatterColumn14 < 5 THEN EDS:DesktopMatterColumn14 = 70.
   IF EDS:DesktopMatterColumn15 < 5 THEN EDS:DesktopMatterColumn15 = 80.
   IF EDS:DesktopMatterColumn16 < 5 THEN EDS:DesktopMatterColumn16 = 75.
   IF EDS:DesktopMatterColumn17 < 5 THEN EDS:DesktopMatterColumn17 = 55.
   IF EDS:DesktopMatterColumn18 < 5 THEN EDS:DesktopMatterColumn18 = 75.
   IF EDS:DesktopMatterColumn19 < 5 THEN EDS:DesktopMatterColumn19 = 50.
   !Added extra column for FB 1902
   IF EDS:DesktopFeeNoteColumn1 < 5 THEN EDS:DesktopFeeNoteColumn1 = 9.
   IF EDS:DesktopFeeNoteColumn2 < 5 THEN EDS:DesktopFeeNoteColumn2 = 9.
   IF EDS:DesktopFeeNoteColumn3 < 5 THEN EDS:DesktopFeeNoteColumn3 = 9.
   IF EDS:DesktopFeeNoteColumn4 < 5 THEN EDS:DesktopFeeNoteColumn4 = 48.
   IF EDS:DesktopFeeNoteColumn5 < 5 THEN EDS:DesktopFeeNoteColumn5 = 60.
   IF EDS:DesktopFeeNoteColumn6 < 5 THEN EDS:DesktopFeeNoteColumn6 = 100.
   IF EDS:DesktopFeeNoteColumn7 < 5 THEN EDS:DesktopFeeNoteColumn7 = 90.
   IF EDS:DesktopFeeNoteColumn8 < 5 THEN EDS:DesktopFeeNoteColumn8 = 140.
   IF EDS:DesktopFeeNoteColumn9 < 5 THEN EDS:DesktopFeeNoteColumn9 = 60.
   IF EDS:DesktopFeeNoteColumn10 < 5 THEN EDS:DesktopFeeNoteColumn10 = 50.
   IF EDS:DesktopFeeNoteColumn11 < 5 THEN EDS:DesktopFeeNoteColumn11 = 60.
   IF EDS:DesktopFeeNoteColumn12 < 5 THEN EDS:DesktopFeeNoteColumn12 = 25.
   IF EDS:DesktopFeeNoteColumn13 < 5 THEN EDS:DesktopFeeNoteColumn13 = 60.
   IF EDS:DesktopFeeNoteColumn14 < 5 THEN EDS:DesktopFeeNoteColumn14 = 116.
   IF EDS:DesktopFeeNoteColumn15 < 5 THEN EDS:DesktopFeeNoteColumn15 = 200.
   IF EDS:DesktopFeeNoteColumn16 < 5 THEN EDS:DesktopFeeNoteColumn16 = 60.
   IF EDS:DesktopFeeNoteColumn17 < 5 THEN EDS:DesktopFeeNoteColumn17 = 75.

   IF EDS:DesktopFileNoteColumn1 < 5 THEN EDS:DesktopFileNoteColumn1 = 10.
   IF EDS:DesktopFileNoteColumn2 < 5 THEN EDS:DesktopFileNoteColumn2 = 10.
   IF EDS:DesktopFileNoteColumn3 < 5 THEN EDS:DesktopFileNoteColumn3 = 10.
   IF EDS:DesktopFileNoteColumn4 < 5 THEN EDS:DesktopFileNoteColumn4 = 56.
   IF EDS:DesktopFileNoteColumn5 < 5 THEN EDS:DesktopFileNoteColumn5 = 60.
   IF EDS:DesktopFileNoteColumn6 < 5 THEN EDS:DesktopFileNoteColumn6 = 100.
   IF EDS:DesktopFileNoteColumn7 < 5 THEN EDS:DesktopFileNoteColumn7 = 30.
   IF EDS:DesktopFileNoteColumn8 < 5 THEN EDS:DesktopFileNoteColumn8 = 250.
   IF EDS:DesktopFileNoteColumn9 < 5 THEN EDS:DesktopFileNoteColumn9 = 116.

   IF EDS:DesktopReminderColumn1 < 5 THEN EDS:DesktopReminderColumn1 = 10.
   IF EDS:DesktopReminderColumn2 < 5 THEN EDS:DesktopReminderColumn2 = 10.
   IF EDS:DesktopReminderColumn3 < 5 THEN EDS:DesktopReminderColumn3 = 50.
   IF EDS:DesktopReminderColumn4 < 5 THEN EDS:DesktopReminderColumn4 = 60.
   IF EDS:DesktopReminderColumn5 < 5 THEN EDS:DesktopReminderColumn5 = 100.
   IF EDS:DesktopReminderColumn6 < 5 THEN EDS:DesktopReminderColumn6 = 125.
   IF EDS:DesktopReminderColumn7 < 5 THEN EDS:DesktopReminderColumn7 = 115.
   IF EDS:DesktopReminderColumn8 < 5 THEN EDS:DesktopReminderColumn8 = 50.
   IF EDS:DesktopReminderColumn9 < 5 THEN EDS:DesktopReminderColumn9 = 35.
   IF EDS:DesktopReminderColumn10 < 5 THEN EDS:DesktopReminderColumn10 = 20.
   IF EDS:DesktopReminderColumn11 < 5 THEN EDS:DesktopReminderColumn11 = 20.
   IF EDS:DesktopReminderColumn12 < 5 THEN EDS:DesktopReminderColumn12 = 50.
   IF EDS:DesktopReminderColumn13 < 5 THEN EDS:DesktopReminderColumn13 = 35.
   IF EDS:DesktopReminderColumn14 < 5 THEN EDS:DesktopReminderColumn14 = 100.
   IF EDS:DesktopReminderColumn15 < 5 THEN EDS:DesktopReminderColumn15 = 200.
   IF EDS:DesktopReminderColumn16 < 5 THEN EDS:DesktopReminderColumn16 = 75.
   IF EDS:DesktopReminderColumn17 < 5 THEN EDS:DesktopReminderColumn17 = 60.



   IF EDS:DesktopMatActivColumn1 < 5 THEN EDS:DesktopMatActivColumn1 = 9.
   IF EDS:DesktopMatActivColumn2 < 5 THEN EDS:DesktopMatActivColumn2 = 9.
   IF EDS:DesktopMatActivColumn3 < 5 THEN EDS:DesktopMatActivColumn3 = 45.
   IF EDS:DesktopMatActivColumn4 < 5 THEN EDS:DesktopMatActivColumn4 = 60.
   IF EDS:DesktopMatActivColumn5 < 5 THEN EDS:DesktopMatActivColumn5 = 100.
   IF EDS:DesktopMatActivColumn6 < 5 THEN EDS:DesktopMatActivColumn6 = 60.
   IF EDS:DesktopMatActivColumn7 < 5 THEN EDS:DesktopMatActivColumn7 = 135.
   IF EDS:DesktopMatActivColumn8 < 5 THEN EDS:DesktopMatActivColumn8 = 30.
   IF EDS:DesktopMatActivColumn9 < 5 THEN EDS:DesktopMatActivColumn9 = 60.
   IF EDS:DesktopMatActivColumn10 < 5 THEN EDS:DesktopMatActivColumn10 = 75.
   IF EDS:DesktopMatActivColumn11 < 5 THEN EDS:DesktopMatActivColumn11 = 190.
   IF EDS:DesktopDataLinkColumn1 < 5 THEN EDS:DesktopDataLinkColumn1 = 9.
   IF EDS:DesktopDataLinkColumn2 < 5 THEN EDS:DesktopDataLinkColumn2 = 50.
   IF EDS:DesktopDataLinkColumn3 < 5 THEN EDS:DesktopDataLinkColumn3 = 60.
   IF EDS:DesktopDataLinkColumn4 < 5 THEN EDS:DesktopDataLinkColumn4 = 100.
   IF EDS:DesktopDataLinkColumn5 < 5 THEN EDS:DesktopDataLinkColumn5 = 35.
   IF EDS:DesktopDataLinkColumn6 < 5 THEN EDS:DesktopDataLinkColumn6 = 35.
   IF EDS:DesktopDataLinkColumn7 < 5 THEN EDS:DesktopDataLinkColumn7 = 35.
   IF EDS:DesktopDataLinkColumn8 < 5 THEN EDS:DesktopDataLinkColumn8 = 180.
   IF EDS:DesktopDataLinkColumn9 < 5 THEN EDS:DesktopDataLinkColumn9 = 200.
   IF EDS:AddressBookColumn1 < 5 THEN EDS:AddressBookColumn1 = 9.
   IF EDS:AddressBookColumn2 < 5 THEN EDS:AddressBookColumn2 = 50.
   IF EDS:AddressBookColumn3 < 5 THEN EDS:AddressBookColumn3 = 50.
   IF EDS:AddressBookColumn4 < 5 THEN EDS:AddressBookColumn4 = 70.
   IF EDS:AddressBookColumn5 < 5 THEN EDS:AddressBookColumn5 = 125.
   IF EDS:AddressBookColumn6 < 5 THEN EDS:AddressBookColumn6 = 55.
   IF EDS:AddressBookColumn7 < 5 THEN EDS:AddressBookColumn7 = 45.
   IF EDS:AddressBookColumn8 < 5 THEN EDS:AddressBookColumn8 = 25.
   IF EDS:AddressBookColumn9 < 5 THEN EDS:AddressBookColumn9 = 25.
   IF EDS:AddressBookColumn10 < 5 THEN EDS:AddressBookColumn10 = 75.
   IF EDS:DocLogColumn1 < 5 THEN EDS:DocLogColumn1 = 9.
   IF EDS:DocLogColumn2 < 5 THEN EDS:DocLogColumn2 = 70.
   IF EDS:DocLogColumn3 < 5 THEN EDS:DocLogColumn3 = 120.
   IF EDS:DocLogColumn4 < 5 THEN EDS:DocLogColumn4 = 100.
   IF EDS:DocLogColumn5 < 5 THEN EDS:DocLogColumn5 = 100.
   IF EDS:DocLogColumn6 < 5 THEN EDS:DocLogColumn6 = 90.
   IF EDS:DocLogColumn7 < 5 THEN EDS:DocLogColumn7 = 100.
   IF EDS:DocLogColumn8 < 5 THEN EDS:DocLogColumn8 = 100.
   IF EDS:DocLogColumn9 < 5 THEN EDS:DocLogColumn9 = 80.
   IF EDS:DocLogColumn10 < 5 THEN EDS:DocLogColumn10 = 100.
   IF EDS:DocLogColumn11 < 5 THEN EDS:DocLogColumn11 = 80.
   IF EDS:DocLogColumn12 < 5 THEN EDS:DocLogColumn12 = 40.
   IF EDS:DocLogColumn13 < 5 THEN EDS:DocLogColumn13 = 28.


  ?MattersBrowse{PROPLIST:Width,4} = EDS:DesktopMatterColumn4

  IF CEM:ShowAlternateRefFlag
     IF ~EDS:DesktopMatterColumn7 THEN EDS:DesktopMatterColumn7 = 60.
     ?MattersBrowse{PROPLIST:Width,7} = EDS:DesktopMatterColumn7 !was EDS:DesktopMatterColumn5 !FB1902 made it 7  , was 6
  ELSE
     ?MattersBrowse{PROPLIST:Width,7} = 0
  END
  !Added by Kelvin - 26 Aug 2016
  IF CEM:ShowLinkedRefFlag
     IF ~EDS:DesktopMatterColumn8 THEN EDS:DesktopMatterColumn8 = 60.     !FB1902 made it 8  , was 7
     ?MattersBrowse{PROPLIST:Width,8} = EDS:DesktopMatterColumn8
  ELSE
     ?MattersBrowse{PROPLIST:Width,8} = 0
  END

  IF CEM:ShowMatterIDFlag
     IF ~EDS:DesktopMatterColumn9 THEN EDS:DesktopMatterColumn9 = 50.    !FB1902 made it 9  , was 8
     ?MattersBrowse{PROPLIST:Width,9} = EDS:DesktopMatterColumn9
  ELSE
     ?MattersBrowse{PROPLIST:Width,9} = 0
  END

  IF GLO:ShowFICAComplianceFlag
     IF ~EDS:DesktopMatterColumn10 THEN EDS:DesktopMatterColumn10 = 30. !FB1902 made it 10  , was 9
     ?MattersBrowse{PROPLIST:Width,10} = EDS:DesktopMatterColumn10
  ELSE
     ?MattersBrowse{PROPLIST:Width,10} = 0
  END

  ?MattersBrowse{PROPLIST:Width,11} = EDS:DesktopMatterColumn11  !FB1902   was 10 now 11
  ?MattersBrowse{PROPLIST:Width,12} = EDS:DesktopMatterColumn12 !FB1902 was 11 now 12


  ?MattersBrowse{PROPLIST:Width,13} = 0   !FB1902 was 12 now 13

  !?MattersBrowse{PROPLIST:Width,13} = EDS:DesktopMatterColumn13
  ?MattersBrowse{PROPLIST:Width,14} = EDS:DesktopMatterColumn14
  ?MattersBrowse{PROPLIST:Width,15} = EDS:DesktopMatterColumn15
  ?MattersBrowse{PROPLIST:Width,16} = EDS:DesktopMatterColumn16
  ?MattersBrowse{PROPLIST:Width,17} = EDS:DesktopMatterColumn17 !FB1902
  !FB1902 was 17 now 18
  IF (CEM:ProgressIndicatorFlag = 'C' OR CEM:ProgressIndicatorFlag = 'S') AND LOC:ShowMatterIconsFlag ! NO NEED TO SHOW THE ARCHIVE STATUS BECAUSE THE ICONS SHOW THAT ALREADY
     ?MattersBrowse{PROPLIST:Width,18} = 0
  ELSE
     IF EDS:DesktopMatterColumn18 = 0 THEN EDS:DesktopMatterColumn1 = 50.
     ?MattersBrowse{PROPLIST:Width,18} = EDS:DesktopMatterColumn18
  END

  IF GLO:InterfaceOption = 'L'  !FB1902 was 18 now 19
        IF ~EDS:DesktopMatterColumn19 THEN EDS:DesktopMatterColumn19 = 300.
     ?MattersBrowse{PROPLIST:Width,19} = EDS:DesktopMatterColumn19
  ELSE
     ?MattersBrowse{PROPLIST:Width,19} = 0
  END


  IF ~EDS:DesktopFeeNoteColumn5 THEN EDS:DesktopFeeNoteColumn5 = 70.
  IF ~EDS:DesktopFeeNoteColumn6 THEN EDS:DesktopFeeNoteColumn6 = 100.

  ?FeeNoteBrowse{PROPLIST:Width,1} = 10
  ?FeeNoteBrowse{PROPLIST:Width,2} = 10
  ?FeeNoteBrowse{PROPLIST:Width,3} = 10
  ?FeeNoteBrowse{PROPLIST:Width,4} = EDS:DesktopFeeNoteColumn4
  ?FeeNoteBrowse{PROPLIST:Width,5} = EDS:DesktopFeeNoteColumn5
  ?FeeNoteBrowse{PROPLIST:Width,6} = EDS:DesktopFeeNoteColumn6
  ?FeeNoteBrowse{PROPLIST:Width,7} = 0  ! ON THE SCREEN BUT WANT IT ON THE RIGHT-CLICK PRINT OUT
  ?FeeNoteBrowse{PROPLIST:Width,8} = EDS:DesktopFeeNoteColumn8
  ?FeeNoteBrowse{PROPLIST:Width,9} = EDS:DesktopFeeNoteColumn9
  ?FeeNoteBrowse{PROPLIST:Width,10} = EDS:DesktopFeeNoteColumn10
  ?FeeNoteBrowse{PROPLIST:Width,11} = EDS:DesktopFeeNoteColumn11
  ?FeeNoteBrowse{PROPLIST:Width,12} = EDS:DesktopFeeNoteColumn12
  ?FeeNoteBrowse{PROPLIST:Width,13} = EDS:DesktopFeeNoteColumn13
  ?FeeNoteBrowse{PROPLIST:Width,14} = EDS:DesktopFeeNoteColumn14
  ?FeeNoteBrowse{PROPLIST:Width,15} = EDS:DesktopFeeNoteColumn15
  ?FeeNoteBrowse{PROPLIST:Width,16} = EDS:DesktopFeeNoteColumn16
  ?FeeNoteBrowse{PROPLIST:Width,17} = EDS:DesktopFeeNoteColumn17
  ! Changed
  IF ~EDS:DesktopFileNoteColumn5 THEN EDS:DesktopFileNoteColumn5 = 70.
  IF ~EDS:DesktopFileNoteColumn6 THEN EDS:DesktopFileNoteColumn6 = 100.
  IF ~EDS:DesktopFileNoteColumn9 THEN EDS:DesktopFileNoteColumn9 = 100.
  ?FileNoteBrowse{PROPLIST:Width,1} = 10
  ?FileNoteBrowse{PROPLIST:Width,2} = 10
  ?FileNoteBrowse{PROPLIST:Width,3} = 10
  ?FileNoteBrowse{PROPLIST:Width,4} = EDS:DesktopFileNoteColumn4
  ?FileNoteBrowse{PROPLIST:Width,5} = EDS:DesktopFileNoteColumn5
  ?FileNoteBrowse{PROPLIST:Width,6} = EDS:DesktopFileNoteColumn6
  ?FileNoteBrowse{PROPLIST:Width,7} = EDS:DesktopFileNoteColumn7
  ?FileNoteBrowse{PROPLIST:Width,8} = EDS:DesktopFileNoteColumn8
  ?FileNoteBrowse{PROPLIST:Width,9} = EDS:DesktopFileNoteColumn9


  ?ToDoNoteBrowse{PROPLIST:Width,1} = 10
  ?ToDoNoteBrowse{PROPLIST:Width,2} = 10
  ?ToDoNoteBrowse{PROPLIST:Width,3} = EDS:DesktopReminderColumn3
  IF ~EDS:DesktopReminderColumn4 THEN EDS:DesktopReminderColumn4 = 70.
  IF ~EDS:DesktopReminderColumn5 THEN EDS:DesktopReminderColumn5 = 100.
  ?ToDoNoteBrowse{PROPLIST:Width,4} = EDS:DesktopReminderColumn4
  ?ToDoNoteBrowse{PROPLIST:Width,5} = EDS:DesktopReminderColumn5
  ?ToDoNoteBrowse{PROPLIST:Width,6} = EDS:DesktopReminderColumn6
  ?ToDoNoteBrowse{PROPLIST:Width,7} = EDS:DesktopReminderColumn7
  ?ToDoNoteBrowse{PROPLIST:Width,8} = EDS:DesktopReminderColumn8
  ?ToDoNoteBrowse{PROPLIST:Width,9} = EDS:DesktopReminderColumn9
  ?ToDoNoteBrowse{PROPLIST:Width,10} = EDS:DesktopReminderColumn10
  ?ToDoNoteBrowse{PROPLIST:Width,11} = EDS:DesktopReminderColumn11
  ?ToDoNoteBrowse{PROPLIST:Width,12} = EDS:DesktopReminderColumn12
  ?ToDoNoteBrowse{PROPLIST:Width,13} = EDS:DesktopReminderColumn13
  ?ToDoNoteBrowse{PROPLIST:Width,14} = EDS:DesktopReminderColumn14
  ?ToDoNoteBrowse{PROPLIST:Width,15} = EDS:DesktopReminderColumn15
  ?ToDoNoteBrowse{PROPLIST:Width,16} = EDS:DesktopReminderColumn16
  ?ToDoNoteBrowse{PROPLIST:Width,17} = EDS:DesktopReminderColumn17




  IF GLO:TimeRecordingFlag
     IF ~EDS:DesktopMatActivColumn4 THEN EDS:DesktopMatActivColumn4 = 70.
     IF ~EDS:DesktopMatActivColumn5 THEN EDS:DesktopMatActivColumn5 = 100.
     ?TimeRecordingBrowse{PROPLIST:Width,1} = 10
     ?TimeRecordingBrowse{PROPLIST:Width,2} = 10
     ?TimeRecordingBrowse{PROPLIST:Width,3} = EDS:DesktopMatActivColumn3
     ?TimeRecordingBrowse{PROPLIST:Width,4} = EDS:DesktopMatActivColumn4
     ?TimeRecordingBrowse{PROPLIST:Width,5} = EDS:DesktopMatActivColumn5
     ?TimeRecordingBrowse{PROPLIST:Width,6} = EDS:DesktopMatActivColumn6
     ?TimeRecordingBrowse{PROPLIST:Width,7} = EDS:DesktopMatActivColumn7
     ?TimeRecordingBrowse{PROPLIST:Width,8} = EDS:DesktopMatActivColumn8
     ?TimeRecordingBrowse{PROPLIST:Width,9} = EDS:DesktopMatActivColumn9
     ?TimeRecordingBrowse{PROPLIST:Width,10} = EDS:DesktopMatActivColumn10
     ?TimeRecordingBrowse{PROPLIST:Width,11} = EDS:DesktopMatActivColumn11
  END

  IF ~EDS:DesktopDataLinkColumn3 THEN EDS:DesktopDataLinkColumn3 = 70.
  IF ~EDS:DesktopDataLinkColumn4 THEN EDS:DesktopDataLinkColumn4 = 100.

  ?LawMatterMessageBrowse{PROPLIST:Width,1} = 10
  ?LawMatterMessageBrowse{PROPLIST:Width,2} = EDS:DesktopDataLinkColumn2
  ?LawMatterMessageBrowse{PROPLIST:Width,3} = EDS:DesktopDataLinkColumn3
  ?LawMatterMessageBrowse{PROPLIST:Width,4} = EDS:DesktopDataLinkColumn4
  ?LawMatterMessageBrowse{PROPLIST:Width,5} = EDS:DesktopDataLinkColumn5
  ?LawMatterMessageBrowse{PROPLIST:Width,6} = EDS:DesktopDataLinkColumn6
  ?LawMatterMessageBrowse{PROPLIST:Width,7} = EDS:DesktopDataLinkColumn7
  ?LawMatterMessageBrowse{PROPLIST:Width,8} = EDS:DesktopDataLinkColumn8
  ?LawMatterMessageBrowse{PROPLIST:Width,9} = EDS:DesktopDataLinkColumn9


    IF ?FeeNoteBrowse{PROPLIST:Width,5} > 0 THEN EDS:DesktopFeeNoteColumn5 = ?FeeNoteBrowse{PROPLIST:Width,5}.
    IF ?FeeNoteBrowse{PROPLIST:Width,6} > 0 THEN EDS:DesktopFeeNoteColumn6 = ?FeeNoteBrowse{PROPLIST:Width,6}.


    IF LOC:FN_Matter = 'Current'
       ?FeeNoteBrowse{PROPLIST:Width,5} = 0
       ?FeeNoteBrowse{PROPLIST:Width,6} = 0
    ELSE
       ?FeeNoteBrowse{PROPLIST:Width,5} = EDS:DesktopFeeNoteColumn5
       ?FeeNoteBrowse{PROPLIST:Width,6} = EDS:DesktopFeeNoteColumn6
    END

   ! Changed
   IF ?FileNoteBrowse{PROPLIST:Width,5} > 0 THEN EDS:DesktopFileNoteColumn4 = ?FileNoteBrowse{PROPLIST:Width,5}.
   IF ?FileNoteBrowse{PROPLIST:Width,6} > 0 THEN EDS:DesktopFileNoteColumn5 = ?FileNoteBrowse{PROPLIST:Width,6}.

   ! Changed
   IF LOC:FIL_Matter = 'Current'
      ?FileNoteBrowse{PROPLIST:Width,5} = 0
      ?FileNoteBrowse{PROPLIST:Width,6} = 0
   ELSE
      ?FileNoteBrowse{PROPLIST:Width,5} = EDS:DesktopFileNoteColumn4
      ?FileNoteBrowse{PROPLIST:Width,6} = EDS:DesktopFileNoteColumn5
   END

  IF ?ToDoNoteBrowse{PROPLIST:Width,4} > 0 THEN EDS:DesktopReminderColumn4 = ?ToDoNoteBrowse{PROPLIST:Width,4}.
  IF ?ToDoNoteBrowse{PROPLIST:Width,5} > 0 THEN EDS:DesktopReminderColumn5 = ?ToDoNoteBrowse{PROPLIST:Width,5}.

  IF LOC:TOD_Matter = 'Current'
     ?ToDoNoteBrowse{PROPLIST:Width,4} = 0
     ?ToDoNoteBrowse{PROPLIST:Width,5} = 0
  ELSE
     ?ToDoNoteBrowse{PROPLIST:Width,4} = EDS:DesktopReminderColumn4
     ?ToDoNoteBrowse{PROPLIST:Width,5} = EDS:DesktopReminderColumn5
  END

  IF GLO:TimeRecordingFlag

      IF ?TimeRecordingBrowse{PROPLIST:Width,4} > 0 THEN EDS:DesktopMatActivColumn4 = ?TimeRecordingBrowse{PROPLIST:Width,4}.
      IF ?TimeRecordingBrowse{PROPLIST:Width,5} > 0 THEN EDS:DesktopMatActivColumn5 = ?TimeRecordingBrowse{PROPLIST:Width,5}.


      IF LOC:MA_Matter = 'Current'
         ?TimeRecordingBrowse{PROPLIST:Width,4} = 0
         ?TimeRecordingBrowse{PROPLIST:Width,5} = 0
      ELSE
         ?TimeRecordingBrowse{PROPLIST:Width,4} = EDS:DesktopMatActivColumn4
         ?TimeRecordingBrowse{PROPLIST:Width,5} = EDS:DesktopMatActivColumn5
      END
   END

   IF LOC:DAT_Matter = 'Current'
      ?LawMatterMessageBrowse{PROPLIST:Width,3} = 0
      ?LawMatterMessageBrowse{PROPLIST:Width,4} = 0
   ELSE
      ?LawMatterMessageBrowse{PROPLIST:Width,3} = EDS:DesktopDataLinkColumn3
      ?LawMatterMessageBrowse{PROPLIST:Width,4} = EDS:DesktopDataLinkColumn4
   END


   IF LOC:FNB_Matter = 'Current'

      ?FNBLinkBrowse{PROPLIST:Width,3} = 0
      ?FNBLinkBrowse{PROPLIST:Width,4} = 0

   ELSE
      ?FNBLinkBrowse{PROPLIST:Width,3} = 50
      ?FNBLinkBrowse{PROPLIST:Width,4} = 150
   END



   IF LOC:ABSA_Matter = 'Current'

      ?ABSALinkBrowse{PROPLIST:Width,3} = 0
      ?ABSALinkBrowse{PROPLIST:Width,4} = 0

   ELSE

      ?ABSALinkBrowse{PROPLIST:Width,3} = 50
      ?ABSALinkBrowse{PROPLIST:Width,4} = 150

   END


ToggleFileNoteIcons       ROUTINE

    IF LOC:ShowFileNoteIconsFlag
       ?ToggleFileNoteIconsButton{PROP:Icon} = '~column_delete.ico'
       ?ToggleFileNoteIconsButton{PROP:Tooltip} = 'Hide the icons'
    ELSE
       ?ToggleFileNoteIconsButton{PROP:Icon} = '~column_add.ico'
       ?ToggleFileNoteIconsButton{PROP:Tooltip} = 'Show the icons'
    END

  IF LOC:ShowFileNoteIconsFlag
     IF CEM:DisplayLargeIconsFlag
        ! Changed
        ?FileNoteBrowse{PROP:LineHeight} = 20
        ?FileNoteBrowse{PROPLIST:Width,1} = 12     ! TAG
        ?FileNoteBrowse{PROPLIST:Width,2} = 25     ! ProgressIcon
        ?FileNoteBrowse{PROP:IconList,2} = '~Check_Left.ICO'
        ?FileNoteBrowse{PROPLIST:Width,3} = 25     ! PostedIcon
        ?FileNoteBrowse{PROP:IconList,3} = '~bok.ico'
      ELSE
        ! Changed
        ?FileNoteBrowse{PROPLIST:Width,1} = 14     ! TAG
        ?FileNoteBrowse{PROPLIST:Width,2} = 14     ! ProgressIcon
        ?FileNoteBrowse{PROPLIST:Width,3} = 14     ! PostedIcon
        ?FileNoteBrowse{PROP:LineHeight} = 12
        ?FileNoteBrowse{PROP:IconList,2} = '~Check.ICO'
        ?FileNoteBrowse{PROP:IconList,3} = '~bok.ico'
     END
  ELSE
     ! Changed
     ?FileNoteBrowse{PROP:LineHeight} = 10

     ?FileNoteBrowse{PROP:IconList,2} = '~Check.ICO'

     ?FileNoteBrowse{PROPLIST:Width,1} = 10
     ?FileNoteBrowse{PROPLIST:Width,2} = 0
     ?FileNoteBrowse{PROPLIST:Width,3} = 10
     ?FileNoteBrowse{PROP:IconList,3} = '~bok.ico'
  END


ToggleToDoNoteIcons       ROUTINE

    IF LOC:ShowToDoNoteIconsFlag
       ?ToggleToDoNoteIconsButton{PROP:Icon} = '~column_delete.ico'
       ?ToggleToDoNoteIconsButton{PROP:Tooltip} = 'Hide the icons'
    ELSE
       ?ToggleToDoNoteIconsButton{PROP:Icon} = '~column_add.ico'
       ?ToggleToDoNoteIconsButton{PROP:Tooltip} = 'Show the icons'
    END


  IF LOC:ShowToDoNoteIconsFlag
     IF CEM:DisplayLargeIconsFlag
        ?ToDoNoteBrowse{PROP:LineHeight} = 20
        ?ToDoNoteBrowse{PROPLIST:Width,1} = 12     ! TAG
        ?ToDoNoteBrowse{PROPLIST:Width,2} = 25     ! ProgressIcon
        ?ToDoNoteBrowse{PROP:IconList,2} = '~Check_Left.ICO'
      ELSE
        ?ToDoNoteBrowse{PROPLIST:Width,1} = 14     ! TAG
        ?ToDoNoteBrowse{PROPLIST:Width,2} = 14     ! ProgressIcon
        ?ToDoNoteBrowse{PROP:LineHeight} = 12
        ?ToDoNoteBrowse{PROP:IconList,2} = '~Check.ICO'
     END
  ELSE
     ?ToDoNoteBrowse{PROP:LineHeight} = 10

     ?ToDoNoteBrowse{PROP:IconList,2} = '~Check.ICO'

     ?ToDoNoteBrowse{PROPLIST:Width,1} = 10
     ?ToDoNoteBrowse{PROPLIST:Width,2} = 0
  END




ToggleMatterIcons       ROUTINE

    IF LOC:ShowMatterIconsFlag
       ?ToggleMatterIconsButton{PROP:Icon} = '~column_delete.ico'
       ?ToggleMatterIconsButton{PROP:Tooltip} = 'Hide the progress icons'
    ELSE
       ?ToggleMatterIconsButton{PROP:Icon} = '~column_add.ico'
       ?ToggleMatterIconsButton{PROP:Tooltip} = 'Show the progress icons'
    END

    IF LOC:ShowMatterIconsFlag
    ELSE
       ?MattersBrowse{PROP:LineHeight} = 10
    END


  IF LOC:ShowMatterIconsFlag

     IF CEM:DisplayLargeIconsFlag

        ?MattersBrowse{PROP:LineHeight} = 20

        ?MattersBrowse{PROPLIST:Width,1} = 12     ! TAG
        ?MattersBrowse{PROPLIST:Width,4} = 25     ! ProgressIcon !FB1902 was 3 now 4
        IF CEM:ProgressIndicatorFlag = 'S'
           ?MattersBrowse{PROPLIST:Width,2} = 0     ! MessageWaiting
        ELSE
           ?MattersBrowse{PROPLIST:Width,2} = 12    ! MessageWaiting
        END
        ?MattersBrowse{PROPLIST:Width,6} = EDS:DesktopMatterColumn6   ! ProgressText  !FB1902 was 5 now 6

        ?MattersBrowse{PROP:IconList,2} = '~Check_Left.ICO'
        ?MattersBrowse{PROP:IconList,3} = '~Matter_Lock.ico'
        ?MattersBrowse{PROP:IconList,4} = '~Matter_New.ico'
        ?MattersBrowse{PROP:IconList,5} = '~Envelope_left.ico'
        ?MattersBrowse{PROP:IconList,6} = '~Large_Cross.ico'

    ELSE

        ?MattersBrowse{PROP:LineHeight} = 12

        ?MattersBrowse{PROPLIST:Width,1} = 14     ! TAG
        IF CEM:ProgressIndicatorFlag = 'S'
           ?MattersBrowse{PROPLIST:Width,2} = 0     ! MessageWaiting
        ELSE
           ?MattersBrowse{PROPLIST:Width,2} = 14    ! MessageWaiting
        END
        ?MattersBrowse{PROPLIST:Width,4} = 14     ! ProgressIcon !FB1902 was 3 now 4
        ?MattersBrowse{PROPLIST:Width,6} = EDS:DesktopMatterColumn5   ! ProgressText  !FB1902 was 5 now 6

        ?MattersBrowse{PROP:IconList,2} = '~Check.ICO'
        ?MattersBrowse{PROP:IconList,3} = '~Small_Lock.ico'
        ?MattersBrowse{PROP:IconList,4} = '~Small_New.ico'
        ?MattersBrowse{PROP:IconList,5} = '~Envelope.ico'
        ?MattersBrowse{PROP:IconList,6} = '~Small_Cross.ico'


    END

  ELSE

     ?MattersBrowse{PROP:LineHeight} = 10
     ?MattersBrowse{PROPLIST:Width,1} = 10
     ?MattersBrowse{PROPLIST:Width,2} = 0
     ?MattersBrowse{PROPLIST:Width,3} = 0 
     ?MattersBrowse{PROPLIST:Width,4} = 0  !FB1902 was 3 now 4
     ?MattersBrowse{PROPLIST:Width,6} = 0 !FB1902 was 5 now 6

     ?MattersBrowse{PROP:IconList,2} = '~Check.ICO'


  END




RefreshFNBLinkBrowse    ROUTINE

         IF ?FNBLinkTab{PROP:Hide} THEN EXIT.

         IF LOC:FNB_Matter = 'Current'

            ?FNBLinkBrowse{PROPLIST:Width,3} = 0
            ?FNBLinkBrowse{PROPLIST:Width,4} = 0
            ?FNBLinkBrowse{PROPLIST:Width,5} = 0

            ?LOC:FNBMatterState:Prompt{PROP:Hide} = FALSE
            LOC:FNBMatterState = GetMatterStateString(LOC:CurrentMatterID)

            PropSQL('UPDATE AG_MatterMessage SET ReadFlag = 1 WHERE MatterID = ' & LOC:CurrentMatterID)

         ELSE

            ?FNBLinkBrowse{PROPLIST:Width,3} = 50
            ?FNBLinkBrowse{PROPLIST:Width,4} = 150

            IF RECORDS(GBRAQ:BranchQueue) > 1
               ?FNBLinkBrowse{PROPLIST:Width,5} = 60
            ELSE
               ?FNBLinkBrowse{PROPLIST:Width,5} = 0
            END
            LOC:FNBMatterState = ''
            HIDE(?LOC:FNBMatterState:Prompt)
         END
         BRW46.ResetSort(1)

RefreshSARSLinkBrowse    ROUTINE


         IF ?SARSTab{PROP:Hide} THEN  EXIT.

         IF LOC:SARS_Matter = 'Current'

            ?SARSLinkBrowse{PROPLIST:Width,3} = 0

         ELSE

            IF RECORDS(GBRAQ:BranchQueue) > 1
               ?SARSLinkBrowse{PROPLIST:Width,3} = 60
            ELSE
               ?SARSLinkBrowse{PROPLIST:Width,3} = 0
            END

         END

         PropSQLNext('Select RecordId,Code from Docgen where RecordID = (Select DocGenId From Matter Where RecordID = ' & LOC:CurrentMatterID & ')')

         If ErrorCode()
           DISABLE(?SARSSubmitTDButton)
           DISABLE(?SARSSubmitCancellationButton)
           DISABLE(?SARSRequestCorrespondenceButton)
           DISABLE(?SARSCheckStatusCurrentMatterButton)
           DISABLE(?SARSCheckAllStatusesButton)
         Else
           If InList(ROW:Description,'TRN','STR','DEV')
             !FB 1462
             PropSQLNext('Select MatterID,Type from BondData WHERE Type = ''H'' AND MatterID = ' & LOC:CurrentMatterID & '')
             IF ROW:Description = 'H'
                 DISABLE(?SARSSubmitTDButton)
                 DISABLE(?SARSSubmitCancellationButton)
                 DISABLE(?SARSRequestCorrespondenceButton)
                 DISABLE(?SARSCheckStatusCurrentMatterButton)
                 DISABLE(?SARSCheckAllStatusesButton)
             ELSE
             !FB 1462 END
                 ENABLE(?SARSSubmitTDButton)
                 ENABLE(?SARSSubmitCancellationButton)
                 ENABLE(?SARSRequestCorrespondenceButton)
                 ENABLE(?SARSCheckStatusCurrentMatterButton)
                 ENABLE(?SARSCheckAllStatusesButton)
             !FB 1462
             END
             !FB 1462 END
           Else
             DISABLE(?SARSSubmitTDButton)
             DISABLE(?SARSSubmitCancellationButton)
             DISABLE(?SARSRequestCorrespondenceButton)
             DISABLE(?SARSCheckStatusCurrentMatterButton)
             DISABLE(?SARSCheckAllStatusesButton)
           End
         End

         IF LOC:SARS_Matter = 'Current' And LOC:CurrentMatterID
            !FB 1462
            !PropSQLNext('Select Count(1) From SARS_MatterMessage Where SARS_MatterMessage.MatterID = ' & LOC:CurrentMatterID)
           PropSQLNext('Select Count(1) From SARS_MatterMessage INNER JOIN BondData ON BondData.MatterId = SARS_MatterMessage.MatterID AND BondData.Type <> ''H'' Where SARS_MatterMessage.MatterID = ' & LOC:CurrentMatterID)
           !FB 1462 END
           IF ROW:Counter
             ENABLE(?SARSSubmitCancellationButton)
             ENABLE(?SARSRequestCorrespondenceButton)
             ENABLE(?SARSCheckStatusCurrentMatterButton)
             ENABLE(?SARSCheckAllStatusesButton)
           Else
             DISABLE(?SARSSubmitCancellationButton)
             DISABLE(?SARSRequestCorrespondenceButton)
             DISABLE(?SARSCheckStatusCurrentMatterButton)
             DISABLE(?SARSCheckAllStatusesButton)
           End
         Else
           DISABLE(?SARSSubmitCancellationButton)
           DISABLE(?SARSRequestCorrespondenceButton)
           DISABLE(?SARSCheckStatusCurrentMatterButton)
           DISABLE(?SARSCheckAllStatusesButton)
         End

         If CEM:SARS_LoginName And CEM:SARS_LoginKey
           HIDE(?SARSRegisterButton)
         Else
           UNHIDE(?SARSRegisterButton)
         End

         BRW33.ResetSort(1)



RefreshABSALinkBrowse    ROUTINE

         IF ?ABSALinkTab{PROP:Hide} THEN EXIT.
         ?LOC:ABSA_TurnAroundTime{PROP:Hide} = True
         ?LOC:ABSA_TurnAroundTime:Prompt{PROP:Hide} = True
         IF LOC:ABSA_Matter = 'Current' And LOC:CurrentMatterID

            PropSQLNext('Select Count(1) From ABSA_MatterMessage Where MatterID = ' & LOC:CurrentMatterID)

            IF ROW:Counter

              ENABLE(?ABSASendReceiveDocsButton)
              ENABLE(?BondCentreOrGatewayPropertyHubDocsButtonMatterTab)
              ENABLE(?SendABSAMessageButton)

            Else

              DISABLE(?ABSASendReceiveDocsButton)
              DISABLE(?BondCentreOrGatewayPropertyHubDocsButtonMatterTab)
              DISABLE(?SendABSAMessageButton)

            End

         Else

            DISABLE(?ABSASendReceiveDocsButton)
            DISABLE(?BondCentreOrGatewayPropertyHubDocsButtonMatterTab)
            DISABLE(?SendABSAMessageButton)

         End

         IF LOC:ABSA_Matter = 'Current'

            ?ABSALinkBrowse{PROPLIST:Width,3} = 0
            ?ABSALinkBrowse{PROPLIST:Width,4} = 0
            ?ABSALinkBrowse{PROPLIST:Width,5} = 0

            ! Sameer 30/06/2014 - Hidden as per Jenny's request
            !?LOC:ABSAMatterState:Prompt{PROP:Hide} = FALSE
            !LOC:ABSAMatterState = GetABSAMatterState(LOC:CurrentMatterID)

            PropSQL('UPDATE ABSA_MatterMessage SET ReadFlag = 1 WHERE MatterID = ' & LOC:CurrentMatterID)

         ELSE

            ?ABSALinkBrowse{PROPLIST:Width,3} = 50
            ?ABSALinkBrowse{PROPLIST:Width,4} = 150

            IF RECORDS(GBRAQ:BranchQueue) > 1
               ?ABSALinkBrowse{PROPLIST:Width,5} = 60
            ELSE
               ?ABSALinkBrowse{PROPLIST:Width,5} = 0
            END

            ! Sameer 30/06/2014 - Hidden as per Jenny's request (no need to hide what is already hidden)
            !LOC:ABSAMatterState = ''
            !HIDE(?LOC:ABSAMatterState:Prompt)
         END
         !FB 2833
         ?ABSAUBODocuments{PROP:Hide} = true
         DISABLE(?ABSAUBODocuments)
         !FB 2833 END
         !FB 2659
         IF LOC:ABSA_Matter = 'Current'
              IF CTL:FirmCode = 'ACME01' OR CTL:FirmCode = 'SMIT06'
                IF MAT:DocgenID AND ~MAT:ArchiveStatus
                    DG:RecordID = MAT:DocgenID
                    IF ~Access:Docgen.TryFetch(DG:PrimaryKey)
                        IF DG:Code = 'ABSA'
                            PropSQLNext('Select TurnAroundTimeLastChecked,'''',StopCheckingTurnAroundTime from BondAbsa WHERE MatterID = '&MAT:RecordID)
                            IF (~ROW:Counter OR ROW:Counter < GLO:TodaysDate) !AND ~ROW:Amount1
                                IF EXISTS('TurnAroundTimeCheck.exe')
                                   PROPSQL('UPDATE BondAbsa SET TurnAroundTimeLastChecked = ' & GLO:TodaysDate & '  WHERE MatterID = '&MAT:RecordID)
                                   RUN('TurnAroundTimeCheck.exe "sqllogin=' & GLO:SQLLogin & '" Branch=' & MAT:BranchID & ' Employee=' & CEM:RecordID & ' Matter=' & MAT:RecordID)
                                   If ErrorCode()
                                       Message(Error() & '||Error running program TurnAroundTimeCheck.exe||Phone LegalSuite Support','Error running program',ICON:Exclamation)
                                   End        
                                 Else
                                   Message('TurnAroundTimeCheck.exe Not Found||Phone LegalSuite Support','Error running program',ICON:Exclamation)
                                 End !END IF EXISTS('TurnAroundTimeCheck.exe')         
                             END !END  IF ROW:Counter < GLO:Today AND ~ROW:Amount
                             PropSQLNext('Select TurnAroundTime from BondAbsa WHERE MatterID = '&MAT:RecordID)
                             IF ROW:Counter
                                 LOC:ABSA_TurnAroundTime = ROW:Counter
                                 ?LOC:ABSA_TurnAroundTime{PROP:Hide} = false
                                 ?LOC:ABSA_TurnAroundTime:Prompt{PROP:Hide} = False
                             ELSE
                                 ?LOC:ABSA_TurnAroundTime{PROP:Hide} = True
                                 ?LOC:ABSA_TurnAroundTime:Prompt{PROP:Hide} = True
                             END   !END if ROW:Counter
                        End  !IF ABSA
                    END  !If tryfetch
                END !IF MAT:DocgenID AND ~MAT:ArchiveStatus
            END !if ACME01
         END  !IF Current
         !FB 2659 END
         !FB 2833
         !IF CTL:FirmCode = 'ACME01'
             IF LOC:ABSA_Matter = 'Current'
                    IF MAT:DocgenID
                        DG:RecordID = MAT:DocgenID
                        IF ~Access:Docgen.TryFetch(DG:PrimaryKey)
                            IF DG:Code = 'ABSA'
                                PropSQLNext('Select TOP 1 MatParty.MatterID FROM MatParty <13,10> ' & |
                                            'inner join Party on  MatterID = ' & MAT:RecordID & ' AND Party.RecordID = MatParty.PartyID  <13,10> ' & |
                                            'inner join Entity on Entity.RecordID = Party.EntityID AND ISNULL(Entity.JuristicFlag,0) = 1  <13,10> ' & |
                                            'inner join Control on MortgagorRoleID = MatParty.RoleID --OR SuretyRoleId = MatParty.RoleID')
                                IF (ROW:Counter AND ROW:Counter = MAT:RecordID)
                                    ?ABSAUBODocuments{PROP:Hide} = false
                                    ENABLE(?ABSAUBODocuments)
                                 END !END  IF ROW:Counter
                            End  !IF ABSA
                        END  !If tryfetch
                    END !IF MAT:DocgenID
             END  !IF Current
         !END !IF CTL:FirmCode = 'ACME01'
         !FB 2833 END
         BRW35.ResetSort(1)

         !POST(EVENT:ScrollBottom,?ABSALinkBrowse)


RefreshDataLinkBrowse   ROUTINE


         IF ?DATALinkTab{PROP:Hide} THEN EXIT.

         IF ?LawMatterMessageBrowse{PROPLIST:Width,3} > 0 THEN EDS:DesktopDataLinkColumn3 = ?LawMatterMessageBrowse{PROPLIST:Width,3}.
         IF ?LawMatterMessageBrowse{PROPLIST:Width,4} > 0 THEN EDS:DesktopDataLinkColumn4 = ?LawMatterMessageBrowse{PROPLIST:Width,4}.

         IF LOC:DAT_Matter = 'Current'
            ?LawMatterMessageBrowse{PROPLIST:Width,3} = 0
            ?LawMatterMessageBrowse{PROPLIST:Width,4} = 0
         ELSE
            ?LawMatterMessageBrowse{PROPLIST:Width,3} = EDS:DesktopDataLinkColumn3
            ?LawMatterMessageBrowse{PROPLIST:Width,4} = EDS:DesktopDataLinkColumn4
         END


         BRW36.ResetSort(1)




RefreshMatActivBrowse   ROUTINE


         IF ?TimeRecordingTab{PROP:Hide} THEN EXIT.

         IF ?TimeRecordingBrowse{PROPLIST:Width,4} > 0 THEN EDS:DesktopMatActivColumn4 = ?TimeRecordingBrowse{PROPLIST:Width,4}.
         IF ?TimeRecordingBrowse{PROPLIST:Width,5} > 0 THEN EDS:DesktopMatActivColumn5 = ?TimeRecordingBrowse{PROPLIST:Width,5}.

         IF LOC:MA_Matter = 'Current'
            ?TimeRecordingBrowse{PROPLIST:Width,4} = 0
            ?TimeRecordingBrowse{PROPLIST:Width,5} = 0
         ELSE
            ?TimeRecordingBrowse{PROPLIST:Width,4} = EDS:DesktopMatActivColumn4
            ?TimeRecordingBrowse{PROPLIST:Width,5} = EDS:DesktopMatActivColumn5
         END

          IF (LOC:MA_Employee = 'All' AND LOC:MA_CostCentre = 'All' AND LOC:MA_Matter <> 'Current') AND ~LOC:ViewAllEmployeeData
             MESSAGE('You do not have sufficient rights to view All Time Records for All Employees and All Cost Centres. ||Your security settings do not allow you access to this area of the program.|' & LOC:ViewAllEmployeeDesc,'Restricted Function','~lock.ico')
             LOC:MA_Employee = GLO:UserName
             DISPLAY(?LOC:MA_Employee)
             GLO:MA_EmployeeID = CEM:RecordID

             DO MakeFilterMatActivString


          END

          DO SetMatActivOptFilterButton

          BRW22.ResetSort(1)


SetMatActivOptFilterButton      ROUTINE


         ?MA:OptFilterButton{PROP:Tooltip} = 'Total Records : ' & LOC:TotalRecords & '<13,10>Filtered : ' & LOC:FilteredMatActivs & '<13,10>Tagged : ' & CntTag:PtrM(Tag:MatActiv)! & '<13,10>Selection     : ' & LOC:FilterMatActivString


         DO TotalMatActiv     ! DISPLAY THE TOTALS AT THE BOTTOM


RefreshToDoNoteBrowse   ROUTINE


          
          IF ?ToDoNoteBrowse{PROPLIST:Width,4} > 0 THEN EDS:DesktopReminderColumn4 = ?ToDoNoteBrowse{PROPLIST:Width,4}.
          IF ?ToDoNoteBrowse{PROPLIST:Width,5} > 0 THEN EDS:DesktopReminderColumn5 = ?ToDoNoteBrowse{PROPLIST:Width,5}.

          IF LOC:TOD_Matter = 'Current'
             ?ToDoNoteBrowse{PROPLIST:Width,4} = 0
             ?ToDoNoteBrowse{PROPLIST:Width,5} = 0
          ELSE
             ?ToDoNoteBrowse{PROPLIST:Width,4} = EDS:DesktopReminderColumn4
             ?ToDoNoteBrowse{PROPLIST:Width,5} = EDS:DesktopReminderColumn5
          END
          
          DO SetToDoNoteOptFilterButton
          
          BRW15.ResetSort(1)

SetToDoNoteOptFilterButton      ROUTINE

         ?TOD:OptFilterButton{PROP:Tooltip} = 'Total Records: ' & LOC:TotalRecords & '<13,10>Filtered: ' & LOC:FilteredReminders & '<13,10>Tagged: ' & CntTag:PtrM(Tag:ToDoNote) !& '<13,10>Selection: ' & LOC:FilterToDoNoteSQLString


         LOC:TaggedReminders = CntTag:PtrM(Tag:ToDoNote)
         


         IF LOC:TaggedReminders

            UNHIDE(?LOC:TaggedReminders)
            UNHIDE(?LOC:TaggedReminders:Prompt)
            ?TOD:OptFilterButton{PROP:Disable} = False

            DISPLAY(?LOC:TaggedReminders)

         ELSE

            HIDE(?LOC:TaggedReminders)
            HIDE(?LOC:TaggedReminders:Prompt)
            IF BRW15::Filter = 1 ! THE USER IS SHOWING TAGGED RECORDS
               ?TOD:OptFilterButton{PROP:Disable} = False
            ELSE
               ?TOD:OptFilterButton{PROP:Disable} = True
            END

         END



RefreshFileNoteBrowse       ROUTINE
         ! Changed
         IF ?FileNoteBrowse{PROPLIST:Width,5} > 0 THEN EDS:DesktopFileNoteColumn5 = ?FileNoteBrowse{PROPLIST:Width,5}.
         IF ?FileNoteBrowse{PROPLIST:Width,6} > 0 THEN EDS:DesktopFileNoteColumn6 = ?FileNoteBrowse{PROPLIST:Width,6}.

         IF LOC:FIL_Matter = 'Current'
            ?FileNoteBrowse{PROPLIST:Width,5} = 0
            ?FileNoteBrowse{PROPLIST:Width,6} = 0
         ELSE
            ?FileNoteBrowse{PROPLIST:Width,5} = EDS:DesktopFileNoteColumn5
            ?FileNoteBrowse{PROPLIST:Width,6} = EDS:DesktopFileNoteColumn6
         END

         DO SetFileNoteOptFilterButton

         BRW52.ResetSort(1)

SetFileNoteOptFilterButton      ROUTINE

         ?FIL:OptFilterButton{PROP:Tooltip} = 'Total Records: ' & LOC:TotalRecords & '<13,10>Filtered: ' & LOC:FilteredFileNotes & '<13,10>Tagged: ' & CntTag:PtrM(Tag:FileNote) !& '<13,10>Selection: ' & LOC:FilterFileNoteSQLString
         LOC:TaggedFileNotes = CntTag:PtrM(Tag:FileNote)


         IF LOC:TaggedFileNotes
            UNHIDE(?LOC:TaggedFileNotes)
            UNHIDE(?LOC:TaggedFileNotes:Prompt)
            ?FIL:OptFilterButton{PROP:Disable} = False

            DISPLAY(?LOC:TaggedFileNotes)
         ELSE
            HIDE(?LOC:TaggedFileNotes)
            HIDE(?LOC:TaggedFileNotes:Prompt)
            IF BRW52::Filter = 1 ! THE USER IS SHOWING TAGGED RECORDS
               ?FIL:OptFilterButton{PROP:Disable} = False
            ELSE
               ?FIL:OptFilterButton{PROP:Disable} = True
            END
         END


RefreshFeeNoteBrowse        ROUTINE

          IF ?FeeNoteBrowse{PROPLIST:Width,5} > 0 THEN EDS:DesktopFeeNoteColumn5 = ?FeeNoteBrowse{PROPLIST:Width,5}.
          IF ?FeeNoteBrowse{PROPLIST:Width,6} > 0 THEN EDS:DesktopFeeNoteColumn6 = ?FeeNoteBrowse{PROPLIST:Width,6}.

          IF LOC:FN_Matter = 'Current'
             ?FeeNoteBrowse{PROPLIST:Width,5} = 0
             ?FeeNoteBrowse{PROPLIST:Width,6} = 0
          ELSE
             ?FeeNoteBrowse{PROPLIST:Width,5} = EDS:DesktopFeeNoteColumn5
             ?FeeNoteBrowse{PROPLIST:Width,6} = EDS:DesktopFeeNoteColumn6
          END

          IF (LOC:FN_Employee = 'All' AND LOC:FN_CostCentre = 'All' AND LOC:FN_Matter <> 'Current') AND ~LOC:ViewAllEmployeeData
             MESSAGE('You do not have sufficient rights to view All Fees for All Employees and All Cost Centres. ||Your security settings do not allow you access to this area of the program.|' & LOC:ViewAllEmployeeDesc,'Restricted Function','~lock.ico')
             LOC:FN_Employee = GLO:UserName
             DISPLAY(?LOC:FN_Employee)
             GLO:FN_EmployeeID = CEM:RecordID

             DO MakeFilterFeenoteString


          END


         If ~(SAV:FN_Matter = LOC:FN_Matter)
           If LOC:FN_Matter = 'Current'
             ?MoveUp{PROP:Disable} = False
             ?MoveDown{PROP:Disable} = False
           Else
             ?MoveUp{PROP:Disable} = True
             ?MoveDown{PROP:Disable} = True
           .
         .

         DO SetFeeNoteOptFilterButton

         BRW2.ResetSort(1)




SetFeeNoteOptFilterButton      ROUTINE

         ?FN:OptFilterButton{PROP:Tooltip} = 'Total Records : ' & LOC:TotalRecords & '<13,10>Filtered : ' & LOC:FilteredFeeNotes & '<13,10>Tagged : ' & CntTag:PtrM(Tag:FeeNote)! & '<13,10>Selection : ' & LOC:FilterFeeNoteString

         IF FstTag:PtrM(Tag:FeeNote)
            ?FN:OptFilterButton{PROP:Disable} = False
         ELSE
            IF BRW2::Filter = 1 ! THE USER IS SHOWING TAGGED RECORDS
               ?FN:OptFilterButton{PROP:Disable} = False
            ELSE
               ?FN:OptFilterButton{PROP:Disable} = True
            END
         END




CheckIfMatterCanBeViewed        ROUTINE

         IF LOC:FilterMatterString AND GLO:CurrentMatterID

            PropSQLNext('SELECT COUNT(1) WHERE ' & GLO:CurrentMatterID & ' IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')')

            IF ~ROW:Counter  ! IT IS NOT BEING DISPLAYED

                IF MESSAGE('The program is unable to display this Matter.||It may be filtered out and therefore is not being displayed in the current list of Matters.||Would you like to take off the filtering so that the Matter can be located?|','Matter Unavailable (' & MAT:FileRef & ')',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:Yes

                   DO ClearFiltering
                   LOC:QBEFilterString = ''

                   IF GLO:CurrentMatterID
                      MAT:RecordID = GLO:CurrentMatterID
                      Access:Matter.Fetch(MAT:PrimaryKey)
                   ELSE
                      CLEAR(MAT:Record)
                   END
                   BRW54.ApplyFilter
                   BRW54.ResetFromBuffer
                   BRW54.PostNewSelection
                END
            END
         END


RefreshMatterBrowse     ROUTINE


         DO CheckIfMatterCanBeViewed

         DO CreateTaggedMatterList

         IF LOC:FilterMatterString
            IF LOC:FN_Matter = 'Filtered' OR LOC:FN_Matter = 'Tagged' THEN DO RefreshFeeNoteBrowse.
            IF LOC:FIL_Matter = 'Filtered' OR LOC:FIL_Matter = 'Tagged' THEN DO RefreshFileNoteBrowse.
            IF LOC:TOD_Matter = 'Filtered' OR LOC:TOD_Matter = 'Tagged' THEN DO RefreshToDoNoteBrowse.
            IF LOC:MA_Matter = 'Filtered' OR LOC:MA_Matter = 'Tagged' THEN DO RefreshMatActivBrowse.
            IF LOC:DAT_Matter = 'Filtered' OR LOC:DAT_Matter = 'Tagged' THEN DO RefreshDataLinkBrowse.
            IF LOC:FNB_Matter = 'Filtered' OR LOC:FNB_Matter = 'Tagged' THEN DO RefreshFNBLinkBrowse.
            IF LOC:SARS_Matter = 'Filtered' OR LOC:SARS_Matter = 'Tagged' THEN DO RefreshSARSLinkBrowse.
            IF LOC:ABSA_Matter = 'Filtered' OR LOC:ABSA_Matter = 'Tagged' THEN DO RefreshABSALinkBrowse.
         END

         IF LOC:StayOnThisMatterID
            MAT:RecordID = LOC:StayOnThisMatterID
            Access:Matter.Fetch(MAT:PrimaryKey)
         ELSIF GLO:CurrentMatterID
            MAT:RecordID = GLO:CurrentMatterID
            Access:Matter.Fetch(MAT:PrimaryKey)
         ELSE
            CLEAR(MAT:Record)
         END
         BRW54.ApplyFilter
         BRW54.ResetFromBuffer
         BRW54.PostNewSelection



SendEmail   ROUTINE

     IF ~LOC:EmailMatterID
         MESSAGE('No Matter has been specified while sending emial from the Desktop.||Cannot send the email because it needs to be associated with a Matter.||Please report this Error to LegalSuite Software Support.','No Matter',ICON:Exclamation)
         EXIT
     END

     SendEmailMessage(LOC:EmailMatterID,0,0,'',LOC:Subject,LOC:Body)

     LOC:EmailMatterID = 0

CreateFileNoteQBEQueue      ROUTINE

      FREE(QBEQ:QBEQueue)

      AddCommonQBEColumns('FileNote')

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FileNote'
      QBEQ:Description = 'Stage Code'
      QBEQ:Column = 'StageID'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = 'Stage'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'Code'
      QBEQ:Lookup1Type = 'S'
!      QBEQ:DropListSQL = 'SELECT 0,Code FROM Stage ORDER BY Code'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FileNote'
      QBEQ:Description = 'Stage Description'
      QBEQ:Column = 'StageID'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = 'Stage'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'Description'
      QBEQ:Lookup1Type = 'S'
!      QBEQ:DropListSQL = 'SELECT 0,Description FROM Stage ORDER BY Description'
      ADD(QBEQ:QBEQueue)

! Rick - 7 Aug 1014 Seems to hang SQL
      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FileNote'
      QBEQ:Description = 'Internal'
      QBEQ:Column = 'InternalFlag'
      QBEQ:Type = 'O'
      QBEQ:Option1Wording = 'Yes'
      QBEQ:Option1Type = 'N'
      QBEQ:Option1Value = '1'
      QBEQ:Option2Wording = 'No'
      QBEQ:Option2Type = 'N'
      QBEQ:Option2Value = '0'
      ADD(QBEQ:QBEQueue)


      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FileNote'
      QBEQ:Description = 'Time'
      QBEQ:Column = 'Time'
      QBEQ:Type = 'T'
      QBEQ:Format = 'T'
      ADD(QBEQ:QBEQueue)


      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FileNote'
      QBEQ:Description = 'Created By'
      QBEQ:Column = '(SELECT Name from Employee WHERE recordid = A.createdby)'
      QBEQ:Type = 'S'
      QBEQ:SpecialInstructions = 'Function'
      ADD(QBEQ:QBEQueue)


      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FileNote'
      QBEQ:Description = 'Created Date'
      QBEQ:Column = 'CreatedDate'
      QBEQ:Type = 'D'
      QBEQ:Format = 'D'
      ADD(QBEQ:QBEQueue)
      

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FileNote'
      QBEQ:Description = 'Created Time'
      QBEQ:Column = 'CreatedTime'
      QBEQ:Type = 'T'
      QBEQ:Format = 'T'
      ADD(QBEQ:QBEQueue)

      SORT(QBEQ:QBEQueue,QBEQ:Description)
      If ErrorCode() Then Message('ERROR: ' & ErrorCode() & ' ' & Error()).


CreateToDoNoteQBEQueue      ROUTINE

      FREE(QBEQ:QBEQueue)

      AddCommonQBEColumns('ToDoNote')

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'ToDoNote'
      QBEQ:Description = 'Status'
      QBEQ:Column = 'CompletedFlag'
      QBEQ:Type = 'O'
      QBEQ:Option1Wording = 'Completed'
      QBEQ:Option1Type = 'N'
      QBEQ:Option1Value = '1'
      QBEQ:Option2Wording = 'Incomplete'
      QBEQ:Option2Type = 'N'
      QBEQ:Option2Value = '0'
      ADD(QBEQ:QBEQueue)


      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'ToDoNote'
      QBEQ:Description = 'Done By'
      QBEQ:Column = 'CompletedByID'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = '(select * from employee)'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'Name'
      QBEQ:Lookup1Type = 'S'
      ADD(QBEQ:QBEQueue)


      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'ToDoNote'
      QBEQ:Description = 'Completed Notes'
      QBEQ:Column = 'CompletedByNotes'
      QBEQ:Type = 'S'
      ADD(QBEQ:QBEQueue)
      


      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'ToDoNote'
      QBEQ:Description = 'Next Document'
      QBEQ:Column = 'NextDocumentID'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = 'Document'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'Description'
      QBEQ:Lookup1Type = 'S'
      ADD(QBEQ:QBEQueue)

      
      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'ToDoNote'
      QBEQ:Description = 'Completed Date'
      QBEQ:Column = 'DateDone'
      QBEQ:Type = 'D'
      QBEQ:Format = 'D'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'ToDoNote'
      QBEQ:Description = 'Created By'
      QBEQ:Column = 'CreatedByID'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = 'Employee'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'Name'
      QBEQ:Lookup1Type = 'S'
      ADD(QBEQ:QBEQueue)



      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'ToDoNote'
      QBEQ:Description = 'Created Date'
      QBEQ:Column = 'CreatedDate'
      QBEQ:Type = 'D'
      QBEQ:Format = 'D'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'ToDoNote'
      QBEQ:Description = 'Completed Time'
      QBEQ:Column = 'CompletedTime'
      QBEQ:Type = 'T'
      QBEQ:Format = 'T'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'ToDoNote'
      QBEQ:Description = 'Created Time'
      QBEQ:Column = 'CreatedTime'
      QBEQ:Type = 'T'
      QBEQ:Format = 'T'
      ADD(QBEQ:QBEQueue)


      SORT(QBEQ:QBEQueue,QBEQ:Description)
      If ErrorCode() Then Message('ERROR: ' & ErrorCode() & ' ' & Error()).

CreateFeeNoteQBEQueue      ROUTINE

      FREE(QBEQ:QBEQueue)

      AddCommonQBEColumns('FeeNote')


      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'Batch Number'
      QBEQ:Column = 'PostedBatchId'
      QBEQ:Type = 'I'       ! INTEGER
      QBEQ:SpecialInstructions = 'Do Not Total'
      ADD(QBEQ:QBEQueue)



      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'Posted Date'
      QBEQ:Column = 'PostedDate'
      QBEQ:Type = 'D'
      QBEQ:Format = 'D'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'Captured Period'
      QBEQ:Column = 'CapturedPeriod'
      QBEQ:Type = 'I'
      QBEQ:Format = 'I'
      QBEQ:SpecialInstructions = 'Do Not Total'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'Captured Year'
      QBEQ:Column = 'CapturedYear'
      QBEQ:Type = 'D'
      QBEQ:Format = 'D'
      ADD(QBEQ:QBEQueue)


      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'Cost Centre (Record)'
      QBEQ:Column = 'CostCentreID'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = 'CostCentre'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'Description'
      QBEQ:Lookup1Type = 'S'
      QBEQ:DropListSQL = 'SELECT 0,Description FROM CostCentre ORDER BY Description'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'Amount (Incl VAT)'
      QBEQ:Column = 'AmountIncl'
      QBEQ:Type = 'N'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'Amount (Ex VAT)'
      QBEQ:Column = 'AmountIncl - FeeNote.VatAmount'
      QBEQ:Type = 'N'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'VAT Amount'
      QBEQ:Column = 'VatAmount'
      QBEQ:Type = 'N'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'Units (Description)'
      QBEQ:Column = 'UnitText'
      QBEQ:Type = 'S'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'Units (Amount)'
      QBEQ:Column = 'UnitQuantity'
      QBEQ:Type = 'N'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'Vat Rate'
      QBEQ:Column = 'VatRate'
      QBEQ:Type = 'S'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'VAT Inc/Excl'
      QBEQ:Column = 'VATIE'
      QBEQ:Type = 'O'
      QBEQ:Option1Wording = 'Excluding'
      QBEQ:Option1Type = 'S'
      QBEQ:Option1Value = 'E'
      QBEQ:Option2Wording = 'Including'
      QBEQ:Option2Type = 'S'
      QBEQ:Option2Value = 'I'
      ADD(QBEQ:QBEQueue)
      
      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'Voucher'
      QBEQ:Column = 'Voucher'
      QBEQ:Type = 'S'
      ADD(QBEQ:QBEQueue)
      
      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'On Hold'
      QBEQ:Column = 'OnHold'
      QBEQ:Type = 'O'
      QBEQ:Option1Wording = 'True'
      QBEQ:Option1Type = 'N'
      QBEQ:Option1Value = '1'
      QBEQ:Option2Wording = 'False'
      QBEQ:Option2Type = 'N'
      QBEQ:Option2Value = '0'
      ADD(QBEQ:QBEQueue)
      
      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'Posted'
      QBEQ:Column = 'PostedFlag'
      QBEQ:Type = 'O'
      QBEQ:Option1Wording = 'True'
      QBEQ:Option1Type = 'N'
      QBEQ:Option1Value = '1'
      QBEQ:Option2Wording = 'False'
      QBEQ:Option2Type = 'N'
      QBEQ:Option2Value = '0'
      ADD(QBEQ:QBEQueue)


      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'Type'
      QBEQ:Column = 'Type1'
      QBEQ:Type = 'O'
      QBEQ:Option1Wording = 'Fee'
      QBEQ:Option1Type = 'S'
      QBEQ:Option1Value = 'F'
      QBEQ:Option2Wording = 'Disbursement'
      QBEQ:Option2Type = 'S'
      QBEQ:Option2Value = 'D'
      QBEQ:Option3Wording = 'Revenue Stamp'
      QBEQ:Option3Type = 'S'
      QBEQ:Option3Value = 'R'
      QBEQ:Option4Wording = 'Creditor'
      QBEQ:Option4Type = 'S'
      QBEQ:Option4Value = 'C'
      ADD(QBEQ:QBEQueue)


      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'ColDebit ID'
      QBEQ:Column = 'ColDebitId'
      QBEQ:Type = 'I'
      ADD(QBEQ:QBEQueue)
      !FB508 - Kelvin 3 Jan 2017
      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'Fee Item'
      QBEQ:Column = 'FeeItemID'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = 'FeeItem'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'Description'
      QBEQ:Lookup1Type = 'S'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'Fee Code'
      QBEQ:Column = 'FeeCodeID'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = 'FeeCode'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'Description'
      QBEQ:Lookup1Type = 'S'
      ADD(QBEQ:QBEQueue)

       CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'FeeNote'
      QBEQ:Description = 'Fee Sheet'
      QBEQ:Column = 'FeeCodeID'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = 'FeeCode'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'FeeSheetID'
      QBEQ:Lookup1Type = 'L'
      QBEQ:Lookup2Table = 'FeeSheet'
      QBEQ:Lookup2Join = 'RecordID'
      QBEQ:Lookup2Column = 'Description'
      QBEQ:Lookup2Type = 'S'
      !FB508 END
      ADD(QBEQ:QBEQueue)


      SORT(QBEQ:QBEQueue,QBEQ:Description)
      If ErrorCode() Then Message('ERROR: ' & ErrorCode() & ' ' & Error()).


CreateMatActivQBEQueue      ROUTINE

      FREE(QBEQ:QBEQueue)

      AddCommonQBEColumns('MatActiv')


      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'MatActiv'
      QBEQ:Description = 'Activity'
      QBEQ:Column = 'ActivityID'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = 'Activity'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'Description'
      QBEQ:Lookup1Type = 'S'
      QBEQ:DropListSQL = 'SELECT 0,Description FROM Activity ORDER BY Description'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'MatActiv'
      QBEQ:Description = 'Billing Rate'
      QBEQ:Column = 'BillingRateID'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = 'BillingRate'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'Description'
      QBEQ:Lookup1Type = 'S'
      QBEQ:DropListSQL = 'SELECT 0,Description FROM BillingRate ORDER BY Description'
      ADD(QBEQ:QBEQueue)


      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'MatActiv'
      QBEQ:Description = 'Cost Centre (Record)'
      QBEQ:Column = 'CostCentreID'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = 'CostCentre'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'Description'
      QBEQ:Lookup1Type = 'S'
      QBEQ:DropListSQL = 'SELECT 0,Description FROM CostCentre ORDER BY Description'
      ADD(QBEQ:QBEQueue)



      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'MatActiv'
      QBEQ:Description = 'Minutes'
      QBEQ:Column = 'Minutes'
      QBEQ:Type = 'N'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'MatActiv'
      QBEQ:Description = 'Rate Per Hour'
      QBEQ:Column = 'RatePerHour'
      QBEQ:Type = 'N'
      QBEQ:SpecialInstructions = 'Do Not Total'
      ADD(QBEQ:QBEQueue)


      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'MatActiv'
      QBEQ:Description = 'Rate Per Minute'
      QBEQ:Column = 'RatePerMinute'
      QBEQ:Type = 'N'
      QBEQ:SpecialInstructions = 'Do Not Total'

      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'MatActiv'
      QBEQ:Description = 'Billable Amount'
      QBEQ:Column = 'BillableAmount'
      QBEQ:Type = 'N'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'MatActiv'
      QBEQ:Description = 'Billable Flag'
      QBEQ:Column = 'BillableFlag'
      QBEQ:Type = 'O'
      QBEQ:Option1Wording = 'True'
      QBEQ:Option1Type = 'N'
      QBEQ:Option1Value = '1'
      QBEQ:Option2Wording = 'False'
      QBEQ:Option2Type = 'N'
      QBEQ:Option2Value = '0'
      ADD(QBEQ:QBEQueue)

      SORT(QBEQ:QBEQueue,QBEQ:Description)
      If ErrorCode() Then Message('ERROR: ' & ErrorCode() & ' ' & Error()).




CreateLawMatterMessageQBEQueue  ROUTINE

      FREE(QBEQ:QBEQueue)

      AddCommonQBEColumns('LawMatterMessage')

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'LawMatterMessage'
      QBEQ:Description = 'Message Number'
      QBEQ:Column = 'LAW_MessageID'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = 'LAW_Messg'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'Number'
      QBEQ:Lookup1Type = 'I'
      QBEQ:SpecialInstructions = 'Do Not Total'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'LawMatterMessage'
      QBEQ:Description = 'Message Description'
      QBEQ:Column = 'LAW_MessageID'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = 'LAW_Messg'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'Message'
      QBEQ:Lookup1Type = 'S'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'LawMatterMessage'
      QBEQ:Description = 'LAW Ref'
      QBEQ:Column = 'MatterID'
      QBEQ:Format = 'N'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = 'Matter'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'LawRef'
      QBEQ:Lookup1Type = 'I'
      QBEQ:SpecialInstructions = 'Do Not Total'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'LawMatterMessage'
      QBEQ:Description = 'Matter SuiteID'
      QBEQ:Column = 'MatterID'
      QBEQ:Format = 'N'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = 'Matter'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'LawSuite'
      QBEQ:Lookup1Type = 'I'
      QBEQ:SpecialInstructions = 'Do Not Total'
      ADD(QBEQ:QBEQueue)

      SORT(QBEQ:QBEQueue,QBEQ:Description)
      If ErrorCode() Then Message('ERROR: ' & ErrorCode() & ' ' & Error()).

CreateLaw_TransQBEQueue  ROUTINE

      FREE(QBEQ:QBEQueue)

      AddCommonQBEColumns('Law_Trans')


      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'LAW_Trans'
      QBEQ:Description = 'LAW Message Number'
      QBEQ:Column = 'Indicator'
      QBEQ:Type = 'I'
      QBEQ:SpecialInstructions = 'Do Not Total'
      ADD(QBEQ:QBEQueue)


      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'LAW_Trans'
      QBEQ:Description = 'LAW Message Details'
      QBEQ:Column = 'Description'
      QBEQ:Type = 'S'
      ADD(QBEQ:QBEQueue)

      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'LAW_Trans'
      QBEQ:Description = 'LAW Message Reason'
      QBEQ:Column = 'Reason'
      QBEQ:Type = 'S'
      ADD(QBEQ:QBEQueue)


      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'Law_Trans'
      QBEQ:Description = 'Matter SuiteID'
      QBEQ:Column = 'MatterID'
      QBEQ:Format = 'N'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = 'Matter'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'LawSuite'
      QBEQ:Lookup1Type = 'I'
      QBEQ:SpecialInstructions = 'Do Not Total'
      ADD(QBEQ:QBEQueue)


!      CLEAR(QBEQ:QBEQueue)
!      QBEQ:Table = 'Law_Trans'
!      QBEQ:Description = 'Message Description'
!      QBEQ:Column = 'Indicator'
!      QBEQ:Type = 'L'   ! LOOKUP
!      QBEQ:Lookup1Table = 'LAW_Messg'
!      QBEQ:Lookup1Join = 'RecordID'
!      QBEQ:Lookup1Column = 'Message'
!      QBEQ:Lookup1Type = 'S'
!      ADD(QBEQ:QBEQueue)



      CLEAR(QBEQ:QBEQueue)
      QBEQ:Table = 'Law_Trans'
      QBEQ:Description = 'LAW Ref'
      QBEQ:Column = 'MatterID'
      QBEQ:Format = 'N'
      QBEQ:Type = 'L'   ! LOOKUP
      QBEQ:Lookup1Table = 'Matter'
      QBEQ:Lookup1Join = 'RecordID'
      QBEQ:Lookup1Column = 'LawRef'
      QBEQ:Lookup1Type = 'I'
      QBEQ:SpecialInstructions = 'Do Not Total'
      ADD(QBEQ:QBEQueue)



      SORT(QBEQ:QBEQueue,QBEQ:Description)
      If ErrorCode() Then Message('ERROR: ' & ErrorCode() & ' ' & Error()).



ConvertMTTtoFeeNotes    ROUTINE


     IF MTT:TranType = 'F'|
     OR MTT:TranType = 'D' |
     OR (MTT:TranType = 'P' and MTT:TranType1 = 'D')
     ! BRING THROUGH FEES , DISBURSEMENTS
     ELSE
        EXIT
     END

     IF MTT:BusTrust <> 'B' AND MTT:BusTrust <> 'T' THEN EXIT.
     IF MTT:BookType = 'T' THEN EXIT.   ! DON'T WANT ALL THE TRANSFERS TO THE CONSOLIDATED ACCOUNT


     CLEAR(FN:Record)

     FN:MatterID = MTT:MatterID
     FN:EmployeeID = MTT:EmployeeID
     IF ~FN:EmployeeID
        FN:EmployeeID = CEM:RecordID
     END
     FN:CostCentreID = MTT:CostCentreID
     FN:Date = MTT:Date
     FN:Description = MTT:Description
     FN:Amount = MTT:Amount
     FN:PostedFlag = 1
     FN:Voucher = MTT:Voucher
     FN:Period = MTT:Period
     FN:Year = MTT:Year
     FN:Type1 = MTT:TranType
     FN:PostedBatchId = MTT:BatchId
     FN:Source = 'C'

     FN:VATIE = 'I'
     FN:VATRATE = MTT:VatRate
     FN:Option1 = 1

     If MTT:TranType = 'F' Then FN:Type1 = 'F' Else FN:Type1 = 'D'.
     If MTT:RefType = 'C' Then FN:Type1 = 'C'. ! Creditor Disbursement

      FN:Code2 = MTT:RefID
!     FN:PostedDate =
!     MTT:VatPercent

     Access:FeeNote.Insert

ClearFiltering  ROUTINE


        LOC:QBEFilterString = ''

         ClearDesktopFilter ! THIS NOW HAS SECURITY CHECKING  7/3/2009

         Do DisplayHeading

         FLUSH(BRW54::View:Browse)

         PropSQLNext('SELECT TOP 1 RecordID FROM MATTER ORDER BY FileRef')
         IF ROW:Counter
            MAT:RecordID = ROW:Counter
            Access:Matter.TryFetch(MAT:PrimaryKey)
         END

         LOC:FilterMatterString = ''
         GLO:FilterMatterSQLString = ''

         BRW54::View:Browse{PROP:SQLFilter} = ''

         CLEAR(MAT:Record)
         BRW54.ResetFromBuffer
         BRW54.PostNewSelection

         Select(?MattersBrowse)


SetDefaultFilter          ROUTINE


      CLEAR(EDF:Record)
      EDF:RecordID = CEM:EmpDefaultFilterID
      IF ~Access:EmpDefaultFilter.Fetch(EDF:PrimaryKey)
          EDF:EmployeeID = CEM:RecordID

          SET(EDF:DescriptionKey,EDF:DescriptionKey)
          IF Access:EmpDefaultFilter.Next()
             CLEAR(EDF:Record)
             EDF:EmployeeID = CEM:RecordID
             SET(EDF:DescriptionKey,EDF:DescriptionKey)
             IF Access:EmpDefaultFilter.Next() THEN EXIT.
             IF EDF:EmployeeID <> CEM:RecordID THEN EXIT.
          ELSE


             IF EDF:EmployeeID <> CEM:RecordID THEN EXIT.
             IF Access:EmpDefaultFilter.Next()
                CLEAR(EDF:Record)
                EDF:EmployeeID = CEM:RecordID
                SET(EDF:DescriptionKey,EDF:DescriptionKey)
                IF Access:EmpDefaultFilter.Next() THEN EXIT.
                IF EDF:EmployeeID <> CEM:RecordID THEN EXIT.
             ELSE


                IF EDF:EmployeeID <> CEM:RecordID
                   CLEAR(EDF:Record)
                   EDF:EmployeeID = CEM:RecordID
                   SET(EDF:DescriptionKey,EDF:DescriptionKey)
                   IF Access:EmpDefaultFilter.Next() THEN EXIT.

                   IF EDF:EmployeeID <> CEM:RecordID THEN EXIT.
                END

             END
          END
      ELSE


          CLEAR(EDF:Record)
          EDF:EmployeeID = CEM:RecordID
          SET(EDF:DescriptionKey,EDF:DescriptionKey)


          IF Access:EmpDefaultFilter.Next() THEN EXIT.
          IF EDF:EmployeeID <> CEM:RecordID THEN EXIT.
      END


         DO BRW54::UntagAll

         GLO:FilterMatterTypeID = 0  ! DEPRECATE THESE
         GLO:FilterMatterTypeFlag = EDF:FilterMatterTypeFlag
         GLO:FilterGroupFlag  = EDF:FilterGroupFlag
         GLO:RestrictToBranchList = EDF:RestrictToBranchList

         GLO:FilterCriticalStepsInListFlag = EDF:FilterCriticalStepsInListFlag
         GLO:RestrictToCriticalStepList = EDF:RestrictToCriticalStepList

         GLO:FilterCriticalStepsNotInListFlag = EDF:FilterCriticalStepsNotInListFlag
         GLO:FilterCriticalStepsNotInList = EDF:FilterCriticalStepsNotInList

         GLO:RestrictToEmployeeList = EDF:RestrictToEmployeeList
         GLO:RestrictToDocGenList = EDF:RestrictToDocGenList
         GLO:RestrictToMatterTypeList = EDF:RestrictToMatterTypeList
         GLO:RestrictToCostCentreList = EDF:RestrictToCostCentreList
         GLO:FilterBranchFlag = EDF:FilterBranchFlag
         GLO:FilterCostCentreID = 0
         GLO:FilterCostCentreFlag = EDF:FilterCostCentreFlag
         GLO:FilterGroupID  = EDF:FilterGroupID
         GLO:FilterEmployeeFlag  = EDF:FilterEmployeeFlag
         GLO:FilterDateFlag  = EDF:FilterDateFlag
         GLO:FilterFromDate  = EDF:FilterFromDate
         GLO:FilterToDate  = EDF:FilterToDate
         GLO:FilterDocgenFlag  = EDF:FilterDocgenFlag
         GLO:FilterDocgenID  = 0
         GLO:FilterSheriffAreaFlag  = EDF:FilterSheriffAreaFlag
         GLO:FilterSheriffAreaID  = EDF:FilterSheriffAreaID 
         GLO:FilterEmployeeID  = 0
         GLO:FilterMattersBy = EDF:FilterMattersBy
         GLO:FilterBalances  = EDF:FilterBalances
         GLO:FilterAging  = EDF:FilterAging

         GLO:FilterLastInvoiceDate = EDF:FilterLastInvoiceDate


         GLO:FilterFavouritesFlag  = EDF:FilterFavouritesFlag
         GLO:FilterDebtLinkFlag  = EDF:FilterDebtLinkFlag
         GLO:FilterDebtLinkCategory  = EDF:FilterDebtLinkCategory
         GLO:FilterConveyancingStatusFlag  = EDF:FilterConveyancingStatusFlag
         GLO:FilterConveyancingStatus  = EDF:FilterConveyancingStatus
         GLO:FilterStatusArchiveFlag  = EDF:FilterStatusArchiveFlag
         GLO:FilterStatusPendingFlag  = EDF:FilterStatusPendingFlag
         GLO:FilterStatusLiveFlag  = EDF:FilterStatusLiveFlag
         GLO:FilterStageFlag  = EDF:FilterStageFlag
         GLO:FilterStageID  = EDF:FilterStageID
         GLO:FilterParGroupFlag  = EDF:FilterParGroupFlag
         GLO:FilterParGroupID  = EDF:FilterParGroupID
         GLO:FilterParRegionFlag  = EDF:FilterParRegionFlag
         GLO:FilterParCategoryFlag  = EDF:FilterParCategoryFlag
         GLO:FilterParAnyStageFlag  = EDF:FilterParAnyStageFlag
         GLO:FilterParLastStageFlag  = EDF:FilterParLastStageFlag
         GLO:FilterParRegionID  = EDF:FilterParRegionID
         GLO:FilterParCategoryID  = EDF:FilterParCategoryID
         GLO:FilterParAnyStageID  = EDF:FilterParAnyStageID
         GLO:FilterParLastStageID = EDF:FilterParLastStageID
         GLO:RestrictToClientList = EDF:RestrictToClientList
         IF GLO:RestrictToClientList 
             GLO:RestrictToClientFlag = 1
         ELSE
             GLO:RestrictToClientFlag = 0
         END

         CLEAR(EMP:Record)
         EMP:RecordID = CEM:RecordID
         IF ~Access:Employee.Fetch(EMP:PrimaryKey)

             EMP:EmpDefaultFilterID = EDF:RecordID

             EMP:FilterMatterTypeID = 0 ! DEPRECATE THIS
             EMP:FilterMatterTypeFlag = EDF:FilterMatterTypeFlag
             EMP:FilterGroupFlag  = EDF:FilterGroupFlag
             EMP:FilterCostCentreFlag = EDF:FilterCostCentreFlag
             EMP:FilterCostCentreID = 0 ! DEPRECATE THIS
             EMP:FilterBranchFlag = EDF:FilterBranchFlag
             EMP:FilterBranchID = 0 ! DEPRECATE THIS
             EMP:RestrictToBranchList = EDF:RestrictToBranchList


             EMP:FilterInactiveMattersFlag = EDF:FilterInactiveMattersFlag
             EMP:FilterInactiveFileNotesFlag = EDF:FilterInactiveFileNotesFlag
             EMP:FilterFileNotesOption = EDF:FilterFileNotesOption
             EMP:FilterInactiveFeeNotesFlag = EDF:FilterInactiveFeeNotesFlag
             EMP:FilterInactiveToDoNotesFlag = EDF:FilterInactiveToDoNotesFlag
             EMP:FilterInactiveColDebitFlag = EDF:FilterInactiveColDebitFlag
             EMP:FilterInactiveMatTranFlag = EDF:FilterInactiveMatTranFlag
             EMP:FilterInactiveDays = EDF:FilterInactiveDays


             EMP:FilterCriticalStepsInListFlag = EDF:FilterCriticalStepsInListFlag
             EMP:RestrictToCriticalStepList = EDF:RestrictToCriticalStepList

             EMP:FilterCriticalStepsNotInListFlag = EDF:FilterCriticalStepsNotInListFlag
             EMP:FilterCriticalStepsNotInList = EDF:FilterCriticalStepsNotInList


             EMP:RestrictToEmployeeList = EDF:RestrictToEmployeeList
             EMP:RestrictToDocGenList = EDF:RestrictToDocGenList
             EMP:RestrictToMatterTypeList = EDF:RestrictToMatterTypeList
             EMP:RestrictToCostCentreList = EDF:RestrictToCostCentreList
             EMP:FilterGroupID  = EDF:FilterGroupID
             EMP:FilterEmployeeFlag  = EDF:FilterEmployeeFlag
             EMP:FilterDateFlag  = EDF:FilterDateFlag
             EMP:FilterFromDate  = EDF:FilterFromDate
             EMP:FilterDateOption = EDF:FilterDateOption
             EMP:FilterToDate  = EDF:FilterToDate
             EMP:FilterDocgenFlag  = EDF:FilterDocgenFlag
             EMP:FilterDocgenID  = 0 ! DEPRECATE THIS
             EMP:FilterSheriffAreaFlag  = EDF:FilterSheriffAreaFlag
             EMP:FilterSheriffAreaID  = EDF:FilterSheriffAreaID 
             EMP:FilterEmployeeID  = 0 ! DEPRECATE THIS
             EMP:FilterMattersBy = EDF:FilterMattersBy
             EMP:FilterBalances  = EDF:FilterBalances
             EMP:FilterAging  = EDF:FilterAging

             EMP:FilterLastInvoiceDate = EDF:FilterLastInvoiceDate

             EMP:FilterFavouritesFlag  = EDF:FilterFavouritesFlag
             EMP:FilterDebtLinkFlag  = EDF:FilterDebtLinkFlag
             EMP:FilterDebtLinkCategory  = EDF:FilterDebtLinkCategory
             EMP:FilterDebtLinkFlag  = EDF:FilterDebtLinkFlag
             EMP:FilterConveyancingStatusFlag  = EDF:FilterConveyancingStatusFlag
             EMP:FilterConveyancingStatus  = EDF:FilterConveyancingStatus

             EMP:FilterStatusArchiveFlag  = EDF:FilterStatusArchiveFlag
             EMP:FilterStatusPendingFlag  = EDF:FilterStatusPendingFlag
             EMP:FilterStatusLiveFlag  = EDF:FilterStatusLiveFlag
             EMP:FilterStageFlag  = EDF:FilterStageFlag
             EMP:FilterStageID  = EDF:FilterStageID
             EMP:FilterParGroupFlag  = EDF:FilterParGroupFlag
             EMP:FilterParGroupID  = EDF:FilterParGroupID
             EMP:FilterParRegionFlag  = EDF:FilterParRegionFlag
             EMP:FilterParCategoryFlag  = EDF:FilterParCategoryFlag
             EMP:FilterParAnyStageFlag  = EDF:FilterParAnyStageFlag
             EMP:FilterParLastStageFlag  = EDF:FilterParLastStageFlag
             EMP:FilterParRegionID  = EDF:FilterParRegionID
             EMP:FilterParCategoryID  = EDF:FilterParCategoryID
             EMP:FilterParAnyStageID  = EDF:FilterParAnyStageID
             EMP:FilterParLastStageID = EDF:FilterParLastStageID
             EMP:RestrictToClientList = EDF:RestrictToClientList
             IF EMP:RestrictToClientList
                EMP:RestrictToClientFlag = 1
             ELSE
                EMP:RestrictToClientFlag = 0
             END

             IF ~Access:Employee.Update()
                 CEM:Record :=: EMP:Record
             END

         END

         Do DisplayHeading

         DO RefreshMatterBrowse

         Select(?MattersBrowse)

!   ELSE
!
!         MESSAGE('No Default Filter was found for Employee (' & CEM:Name & ')',ERROR(),ICON:Exclamation)

!   END
   



CreateFeeNotesFromTaggedMA         ROUTINE

   OPEN(ProgressWindow)
   ProgressWindow{PROP:Text} = 'Creating Fee Notes'
   ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:MatActiv)
   DISPLAY

   IF ~CntTag:PtrM(TAG:MatActiv)
       SetTag:PtrM(TAG:MatActiv,MA:RecordID) ! If User didn't Tag Then Tag Current Activity
   END

   CLEAR(MA:Record)
   MA:RecordID = FstTag:PtrM(TAG:MatActiv)
   LOOP 
        IF ~Access:MatActiv.TryFetch(MA:PrimaryKey)

            IF MA:FeeNoteID
               IF MESSAGE('A Fee Note has already been created from this Time Record||' & MA:Description & '||Do you want to create another Fee Note?|','Fee Note exists',ICON:Exclamation,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:Yes
                  AddFeeNoteFromMA
               END
            ELSE
               AddFeeNoteFromMA
            END
            ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
            DISPLAY
        END
        MA:RecordID = NxtTag:PtrM(TAG:MatActiv)
        IF ~MA:RecordID THEN BREAK.
   END

   CLOSE(ProgressWindow)

   DO BRW22::UntagAll

   DO RefreshMatActivBrowse
   DO RefreshFeeNoteBrowse
   




ShowDataLinkInboxStatus       ROUTINE


  IF GLO:DataLinkFlag                 ! USING DATALINK
     IF CEM:DataLinkBranchID
        LOC:NumberOfDataLinkMessages = CheckDataLinkMessages(CEM:DataLinkBranchID,'Count')
        CASE LOC:NumberOfDataLinkMessages
             OF 0
                LOC:DataLinkInboxStatus = 'There are no messages in your inbox'
             OF 1
                LOC:DataLinkInboxStatus = 'There is 1 message in your inbox'
             ELSE
                LOC:DataLinkInboxStatus = 'There are ' & LOC:NumberOfDataLinkMessages & ' messages in your inbox'
        END
     ELSE
        LOC:DataLinkInboxStatus = 'No DataLink Branch has been specified.'
     END

  END


ShowFNBExportedStatus       ROUTINE

         LOC:FNBExportedMessage = ''

         PROPSQLNext('SELECT COUNT(1) FROM MessagesToSend WHERE ExportedFlag = 0 OR ExportedFlag IS NULL')

         IF ROW:Counter = 1
            LOC:FNBExportedMessage = '1 message needs to be exported'
         ELSIF ROW:Counter > 1
            LOC:FNBExportedMessage = CLIP(LEFT(FORMAT(ROW:Counter,@N_5))) & ' messages need to be exported'
         END


         PROPSQLNext('SELECT COUNT(1) FROM MessagesReceived WHERE (ImportedFlag = 0 OR ImportedFlag IS NULL) AND EmployeeID = ' & CEM:RecordID)
!         PROPSQLNext('SELECT COUNT(1) FROM MessagesReceived WHERE (ImportedFlag = 0 OR ImportedFlag IS NULL)')

         IF ROW:Counter = 1
            IF LOC:FNBExportedMessage 
               LOC:FNBExportedMessage = LOC:FNBExportedMessage & ' and 1 needs to be imported'
            ELSE
               LOC:FNBExportedMessage = '1 message needs to be imported'
            END
         ELSIF ROW:Counter > 1
            IF LOC:FNBExportedMessage 
                 LOC:FNBExportedMessage = LOC:FNBExportedMessage & ' and ' & CLIP(LEFT(FORMAT(ROW:Counter,@N_5))) & ' need to be imported'
            ELSE
                 LOC:FNBExportedMessage = CLIP(LEFT(FORMAT(ROW:Counter,@N_5))) & ' messages need to be imported'
            END
         END

         DISPLAY(?LOC:FNBExportedMessage)

ShowABSAImportedStatus       ROUTINE

         LOC:ABSAExportedMessage = ''
         IF GLO:SupervisorFlag
            PropSQLNext('SELECT COUNT(1) FROM ABSA_MessagesReceived WHERE (ImportedFlag IS NULL OR ImportedFlag = 0)')
         ELSE
            PropSQLNext('SELECT COUNT(1) FROM ABSA_MessagesReceived WHERE (ImportedFlag IS NULL OR ImportedFlag = 0) AND EmployeeID = ' & CEM:RecordID)
         END

         IF ROW:Counter = 1
            IF GLO:SupervisorFlag
               LOC:ABSAExportedMessage = 'There is 1 message that needs to be imported'
            ELSE
               LOC:ABSAExportedMessage = 'You have 1 message that needs to be imported'
            END
         ELSIF ROW:Counter > 1
            IF GLO:SupervisorFlag
               LOC:ABSAExportedMessage = 'There are ' & CLIP(LEFT(FORMAT(ROW:Counter,@N_5))) & ' messages that need to be imported'
            ELSE
               LOC:ABSAExportedMessage = 'You have ' & CLIP(LEFT(FORMAT(ROW:Counter,@N_5))) & ' messages that need to be imported'
            END
         END

         DISPLAY(?LOC:ABSAExportedMessage)


RemoveXMLMessage ROUTINE

    IF ~SAV:MME:FileName THEN EXIT.
    GLO:TestFileName = GetRoot(SAV:MME:FileName)
    IF LOC:DeleteResponse <> 3
       LOC:DeleteResponse = MESSAGE('This DataLink message has an XML file associated with it:||' & GLO:TestFileName & '||Do you want to Delete this XML file as well?|','Confirm deletion',ICON:Question,'No|Yes|All|Cancel',1)
    END
    IF LOC:DeleteResponse = 2 OR LOC:DeleteResponse = 3 THEN REMOVE(TestFile).



AddTimedRecords         ROUTINE

   IF ~FstTag:PtrM(TAG:MatActiv)
       SetTag:PtrM(TAG:MatActiv,ACT:RecordID) ! If User didn't Tag Then Tag Current Activity
   END

   CLEAR(ACT:Record)
   ACT:RecordID = FstTag:PtrM(TAG:MatActiv)                
   LOOP 
        IF ~Access:Activity.TryFetch(ACT:PrimaryKey)

            IF ~GetTimedRecord(MA:MatterID)

               IF ~Access:MatActiv.Insert()

                   IF GLO:MAFeeNoteFlag 
                      AddFeeNoteFromMA
                   END

  
                   IF GLO:MADisbursementID
                      SetTag:PtrM(Tag:FeeCode,GLO:MADisbursementID)

                      GLO:FeeNoteDate = MA:Date  ! USE THE DATE OF THE TIME RECORD TO MAKE THE DISBURSEMENT
                      AddFeeNote(CEM:RecordID,MA:CostCentreID)
                      GLO:FeeNoteDate = 0

                      NewTag:PtrM(Tag:FeeCode)
                   END

                   IF GLO:MAFileNoteFlag
                      DO AddFileNote
                   END

                   IF GLO:MAToDoNoteFlag
                      DO AddToDoNote
                   END

                   AddToFavourites(MA:MatterID)


               END

            END
        END
        ACT:RecordID = NxtTag:PtrM(TAG:MatActiv)                
        IF ~ACT:RecordID THEN BREAK.
   END

   GLO:StopWatchNotes = ''

   DO BRW22::UntagAll

   GLO:MAFeeNoteFlag = 0
   GLO:MADisbursementID = 0
   GLO:MAFileNoteFlag = 0
   GLO:MAToDoNoteFlag = 0

   DO RefreshFeeNoteBrowse

   DO RefreshMatActivBrowse

   DO RefreshFileNoteBrowse

   DO RefreshToDoNoteBrowse


AddFileNote              ROUTINE

  IF MA:MatterID = 0 THEN EXIT.

  CLEAR(FIL:Record)
  FIL:MatterID = MA:MatterID

  ! 12/11/2018 PK Naidoo: FB Case 1923 - some Stage Codes do not allow the users to adjust the dates on the File Notes.
  IF GLO:StageCodeNoDateChangeFlag

     FIL:Date = GLO:TodaysDate

  ELSE

     FIL:Date = MA:Date

  END

  GLO:StageCodeNoDateChangeFlag = 0 ! Set this back to 0 so that we don't reuse it with the next File Note.

  FIL:StageID = GLO:FileNoteStageID

  GLO:FileNoteStageID = 0 ! Set this back to 0 so that we don't reuse it with the next File Note.



  FIL:EmployeeID = MA:EmployeeID

  IF GLO:StopWatchNotes
     FIL:Description = GLO:StopWatchNotes
  ELSE
     IF GLO:FileNoteDescription
        FIL:Description = GLO:FileNoteDescription
        GLO:FileNoteDescription = ''
     ELSE
        FIL:Description = MA:Description
     END
  END
  FIL:InternalFlag = CEM:FileNotesInternalFlag

  !15/08/2018 PK Naidoo: FB Case 1748
  FIL:CreatedDate = GLO:TodaysDate
  FIL:CreatedTime = CLOCK()
  FIL:CreatedBy = CEM:RecordID

  Access:FileNote.Insert

AddToDONote              ROUTINE
  IF MA:MatterID = 0 THEN EXIT.

  CLEAR(TOD:Record)
  TOD:MatterID = MA:MatterID
  TOD:Date = MA:Date + GLO:ToDoNoteDays
  TOD:Date = CheckHoliday(TOD:Date)
  TOD:EmployeeID = MA:EmployeeID
  IF GLO:StopWatchNotes
     TOD:Description = GLO:StopWatchNotes
  ELSE
     TOD:Description = GLO:ToDoNoteDescription
  END
  Access:ToDoNote.Insert

PutFeesOnHold           ROUTINE


        IF ~FstTag:PtrM(Tag:FeeNote) AND FN:RecordID
            IF ~Access:FeeNote.TryFetch(FN:PrimaryKey)
                FN:OnHold = True
                Access:FeeNote.Update
            END
            EXIT
        END

        OPEN(ProgressWindow)
        ProgressWindow{PROP:Text} = 'Placing Tagged Fee Notes On Hold'
        ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:FeeNote)
        CLEAR(FN:Record)
        FN:RecordID = FstTag:PtrM(Tag:FeeNote)                ! SET TO THE FIRST TAGGED FeeNote
        LOOP
          IF ~Access:FeeNote.TryFetch(FN:PrimaryKey)
            FN:OnHold = True
            Access:FeeNote.Update
          END
          ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
          DISPLAY
          FN:RecordID = NxtTag:PtrM(Tag:FeeNote)                ! SET TO NEXT FeeNote
          IF ~FN:RecordID THEN BREAK.
        END
        CLOSE(ProgressWindow)

ClearProformaID           ROUTINE

        IF ~FstTag:PtrM(Tag:FeeNote) AND FN:RecordID
            IF ~Access:FeeNote.TryFetch(FN:PrimaryKey)
                FN:ProformaHeaderID = 0
                Access:FeeNote.Update
            END
            EXIT
        END

        OPEN(ProgressWindow)
        ProgressWindow{PROP:Text} = 'Clearing the ProformaHeaderID of the Tagged Fee Notes'
        ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:FeeNote)
        CLEAR(FN:Record)
        FN:RecordID = FstTag:PtrM(Tag:FeeNote)                ! SET TO THE FIRST TAGGED FeeNote
        LOOP
          IF ~Access:FeeNote.TryFetch(FN:PrimaryKey)
            FN:ProformaHeaderID = 0
            Access:FeeNote.Update
          END
          ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
          DISPLAY
          FN:RecordID = NxtTag:PtrM(Tag:FeeNote)                ! SET TO NEXT FeeNote
          IF ~FN:RecordID THEN BREAK.
        END
        CLOSE(ProgressWindow)



TakeFeesOffHold      ROUTINE


        IF ~FstTag:PtrM(Tag:FeeNote) AND FN:RecordID
            IF ~Access:FeeNote.TryFetch(FN:PrimaryKey)
                FN:OnHold = False
                Access:FeeNote.Update
            END
            EXIT
        END


        OPEN(ProgressWindow)
        ProgressWindow{PROP:Text} = 'Taking Tagged Fee Notes Off Hold'
        ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:FeeNote)
        CLEAR(FN:Record)
        FN:RecordID = FstTag:PtrM(Tag:FeeNote)                ! SET TO THE FIRST TAGGED FeeNote
        LOOP
          IF ~Access:FeeNote.TryFetch(FN:PrimaryKey)
            FN:OnHold = False
            Access:FeeNote.Update
          END
          ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
          DISPLAY
          FN:RecordID = NxtTag:PtrM(Tag:FeeNote)                ! SET TO NEXT FeeNote
          IF ~FN:RecordID THEN BREAK.
        END
        CLOSE(ProgressWindow)

UpdateVoucher           ROUTINE

        IF ~FstTag:PtrM(Tag:FeeNote) AND FN:RecordID
            MESSAGE('Tag the Fee Notes that you want to update the voucher first.','Update Fee Notes',ICON:Exclamation)
            EXIT
        END

        OPEN(UpdateVoucherWindow)
        LOC:GoAhead = 0
        LOC:Voucher = ''
        Display
        Accept
          Case Field()
          Of ?VoucherOKButton
            Case Event()
            Of EVENT:Accepted
              LOC:GoAhead = 1
              Break
            End
          Of ?VoucherCancelButton
            Case Event()
            Of EVENT:Accepted
              Break
            End
          End
        End
        CLOSE(UpdateVoucherWindow)

        If LOC:GoAhead
          CLEAR(FN:Record)
          FN:RecordID = FstTag:PtrM(Tag:FeeNote)                ! SET TO THE FIRST TAGGED FeeNote
          LOOP
            If ~Access:FeeNote.TryFetch(FN:PrimaryKey)
              If ~FN:OnHold And ~FN:PostedFlag
                FN:Voucher = LOC:Voucher
                Access:FeeNote.Update
              End
            End
            FN:RecordID = NxtTag:PtrM(Tag:FeeNote)                ! SET TO NEXT FeeNote
            IF ~FN:RecordID THEN BREAK.
          End
        End

CombineAllFees                      ROUTINE

       CLEAR(MatterQueue)
       FREE(MatterQueue)

       LOOP XX# = 1 TO RECORDS(Queue:Browse)
            GET(Queue:Browse,XX#)
            IF CntTag:PtrM(Tag:FeeNote)
               IF ~Queue:Browse.Tag THEN CYCLE.
            END
            MQ:RecordID = Queue:Browse.FN:MatterID
            GET(MatterQueue,MQ:RecordID)
            IF ERROR()
               ADD(MatterQueue,MQ:RecordID)
            END
       END

       IF RECORDS(MatterQueue)
          IF CntTag:PtrM(Tag:FeeNote)
             IF MESSAGE('This procedure will amalgamate the tagged fee notes into one combined fee note. It cannot be undone. Do you want to continue?','Combine Fee Notes',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:Yes
                DO RunCombineFees
             END
          ELSE
             IF MESSAGE('This procedure will try amalgamate all the fee notes into one combined fee note.||It will only combine fees (or disbursements) that were created by the SAME Fee Code from a built-in Fee Sheet.||This process cannot be undone.||You may want to tag the items you want to combine - so you can specify exactly which ones must be combined.||Do you want to continue?','Combine Fee Notes',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:Yes
                DO RunCombineFees
             END
          END
      END


RunCombineFees  ROUTINE

       LOOP XXX# = 1 TO RECORDS(MatterQueue)
            Get(MatterQueue,XXX#)
            MAT:RecordID = MQ:RecordID


            IF ~Access:Matter.TryFetch(MAT:PrimaryKey)

                IF CntTag:PtrM(Tag:FeeNote)
                   CombineFees(MAT:RecordID,1)  ! DO IT TO TAGGED FEES FOR THIS MATTER ONLY
                ELSE
                   CombineFees(MAT:RecordID,0)  ! DO IT TO ALL FEES
                END

            END
       END



MakeMatterFilterString        ROUTINE


  LOC:FilterMatterString = GetMatterFilterString()


! 14/9/2014 - RICK - NOT TAGGING QBE MATTERS ANYMORE - IT TAKES TOO LONG
  IF LOC:QBEFilterString

      IF LOC:FilterMatterString
    !FB44  - KDS 28 11 2016 - trying to rememedy a speed issue
         LOC:FilterMatterString = LOC:FilterMatterString & ' AND Matter.RecordID IN (SELECT DISTINCT Matter.RecordID FROM ' & LOC:QBEFilterString & ')'
      ELSE
      !FB44  - KDS 28 11 2016 - trying to rememedy a speed issue
         LOC:FilterMatterString = 'Matter.RecordID IN (SELECT DISTINCT Matter.RecordID FROM ' & LOC:QBEFilterString & ')'
      END

      ?MAT:QBESearchButton:2{PROP:Icon} = '~folder_delete.ico'
      ?MAT:QBESearchButton:2{PROP:Tooltip} = 'Clear the QBE filter'

  ELSE

      ?MAT:QBESearchButton:2{PROP:Icon} = '~folder_view.ico'
      ?MAT:QBESearchButton:2{PROP:Tooltip} = 'Filter the Matters using QBE'

  END


  IF LOC:FilterMatterString
     !DEBUG('SELECT Count(1) FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID LEFT OUTER JOIN Party ON Party.RecordID = Matter.ClientID LEFT OUTER JOIN MatType ON MatType.RecordID = Matter.MatterTypeID  WHERE ' & LOC:FilterMatterString)
     PropSQLNext('SELECT Count(1) FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID LEFT OUTER JOIN Party ON Party.RecordID = Matter.ClientID LEFT OUTER JOIN MatType ON MatType.RecordID = Matter.MatterTypeID  WHERE ' & LOC:FilterMatterString)

     LOC:FilteredMatters = ROW:Counter

     PropSQLNext('SELECT rows FROM sysindexes WHERE id = OBJECT_ID(''Matter'') AND indid < 2')
     LOC:TotalRecords = ROW:Counter

  ELSE

     PropSQLNext('SELECT rows FROM sysindexes WHERE id = OBJECT_ID(''Matter'') AND indid < 2')
     LOC:TotalRecords = ROW:Counter
     LOC:FilteredMatters = ROW:Counter

  END





  IF FstTag:PtrM(Tag:Matter) 
     GLO:MatterCounter = CntTag:PtrM(Tag:Matter)         ! USED IN HARD-CODED & MANAGEMENT REPORTS
  ELSE
     GLO:MatterCounter = LOC:FilteredMatters         
  END


  IF BRW54::Filter = 1 ! THE USER IS SHOWING TAGGED RECORDS
     IF FstTag:PtrM(Tag:Matter) 


  ! *** CHANGED BY RICK ON 15/5/2008 - THIS FUNCTION DOES IT MUCH BETTER (I HOPE!) **************
  ! *** AND IT HANDLES LARGE TAGGED SETS (BY WRITING THEM TO A TABLE)              **************

         LOC:FilterMatterString = CreateQBEFilterString(TAG:Matter,'Matter')

  ! *********************************************************************************************


     END

 END


SetMatterOptFilterButton   ROUTINE

      LOC:TaggedMatters = CntTag:PtrM(Tag:Matter)

      ?MAT:OptFilterButton{PROP:Tooltip} = 'Total Records: ' & LOC:TotalRecords & '<13,10>Filtered: ' & LOC:FilteredMatters & '<13,10>Tagged: ' & LOC:TaggedMatters

      IF LOC:TaggedMatters
         UNHIDE(?LOC:TaggedMatters)
         UNHIDE(?LOC:TaggedMatters:Prompt)
         ?MAT:OptFilterButton{PROP:Disable} = False
         DISPLAY(?LOC:TaggedMatters)
         GLO:MAT_ShowTagged = 1
      ELSE
         GLO:MAT_ShowTagged = 0
         HIDE(?LOC:TaggedMatters)
         HIDE(?LOC:TaggedMatters:Prompt)
         IF BRW54::Filter = 1 ! THE USER IS SHOWING TAGGED RECORDS
            ?MAT:OptFilterButton{PROP:Disable} = False
         ELSE
            ?MAT:OptFilterButton{PROP:Disable} = True
         END
      END
      



TotalMatActiv            ROUTINE


  IF CTL:ShowDesktopTotalsFlag

     If LOC:FilterMatActivString
       PropSQLNext('SELECT SUM(Minutes) FROM MatActiv where ' & REPLACE(LOC:FilterMatActivString,'MA:',''))
     Else
       PropSQLNext('SELECT SUM(Minutes) FROM MatActiv')
     .
     LOC:TotalMAMinutes = GetHoursAndMinutes(ROW:Counter)
     DISPLAY(?LOC:TotalMAMinutes)

     If LOC:FilterMatActivString
       PropSQLNext('SELECT SUM(BillableAmount) FROM MatActiv where ' & REPLACE(LOC:FilterMatActivString,'MA:',''))
     Else
       PropSQLNext('SELECT SUM(BillableAmount) FROM MatActiv')
     .
     LOC:TotalMABillableAmount = ROW:Counter

     DISPLAY(?LOC:TotalMABillableAmount)

  ELSE

!                           PROMPT('Totals:'),AT(405,220),USE(?LOC:TotalMAMinutes:Prompt)
!                           ENTRY(@s19),AT(429,220,52,10),USE(LOC:TotalMAMinutes),SKIP,LEFT(1),FONT(,,,FONT:bold),COLOR(COLOR:Silver),TIP('The total time'),READONLY
!                           PROMPT(''),AT(413,222),USE(?LOC:TotalMABillableAmount:Prompt)
!                           ENTRY(@n-15.2b),AT(485,220,56,10),USE(LOC:TotalMABillableAmount),SKIP,DECIMAL(12),FONT(,,,FONT:bold),COLOR(COLOR:Silver),TIP('The total billable amount'),READONLY

     HIDE(?LOC:TotalMAMinutes:Prompt)
     HIDE(?LOC:TotalMAMinutes)
     HIDE(?LOC:TotalMABillableAmount)


  END

TotalFeeNotes            ROUTINE


  IF CTL:ShowDesktopTotalsFlag


     LOC:TotalFees = 0
     LOC:TotalDisb = 0
     If LOC:FilterFeeNoteString
        PropSQLNext('Select Sum(AmountIncl-VatAmount) FROM FeeNote WHERE ' & LOC:FilterFeeNoteString  & ' AND Type1 = ''F''')
     Else
        PropSQLNext('Select Sum(AmountIncl-VatAmount) FROM FeeNote WHERE Type1 = ''F''')
     END
     LOC:TotalFees = ROW:Counter

     If LOC:FilterFeeNoteString
        PropSQLNext('Select Sum(AmountIncl-VatAmount) FROM FeeNote WHERE ' & LOC:FilterFeeNoteString  & ' AND Type1 <> ''F''')
     Else
        PropSQLNext('Select Sum(AmountIncl-VatAmount) FROM FeeNote WHERE Type1 <> ''F''')
     END
     LOC:TotalDisb = ROW:Counter
     DISPLAY(?LOC:TotalDisb)
     DISPLAY(?LOC:TotalFees)
     UNHIDE(?LOC:TotalDisb:Prompt)
     UNHIDE(?LOC:TotalDisb)
     UNHIDE(?LOC:TotalFees:Prompt)
     UNHIDE(?LOC:TotalFees)


  ELSE

!                           PROMPT('Disbursements:'),AT(309,220),USE(?LOC:TotalDisb:Prompt)
!                           ENTRY(@n-15.2b),AT(361,220,60,10),USE(LOC:TotalDisb),SKIP,DECIMAL(12),COLOR(COLOR:Silver),TIP('Total Disbursements (Excluding VAT)'),READONLY
!                           PROMPT('Fees:'),AT(433,220),USE(?LOC:TotalFees:Prompt)
!                           ENTRY(@n-15.2b),AT(457,220,60,10),USE(LOC:TotalFees),SKIP,DECIMAL(12),COLOR(COLOR:Silver),TIP('Total Fees (Excluding VAT)'),READONLY

    HIDE(?LOC:TotalDisb:Prompt)
    HIDE(?LOC:TotalDisb)
    HIDE(?LOC:TotalFees:Prompt)
    HIDE(?LOC:TotalFees)

  END




MakeFilterFeenoteString     ROUTINE

    DO SetFN_DatePeriod

! 14/9/2014 - RICK - NOT TAGGING QBE ANYMORE - IT TAKES TOO LONG

    LOC:FilterFeenoteString = ''

    IF LOC:QBEFilterFeeNoteString

        LOC:FilterFeenoteString = 'FeeNote.RecordID IN (SELECT FeeNote.RecordID FROM ' & LOC:QBEFilterFeeNoteString & ')'

      ?FN:QBESearchButton{PROP:Icon} = '~folder_delete.ico'
      ?FN:QBESearchButton{PROP:Tooltip} = 'Clear the QBE filter'

  ELSE

      ?FN:QBESearchButton{PROP:Icon} = '~folder_view.ico'
      ?FN:QBESearchButton{PROP:Tooltip} = 'Filter the Fee Notes using QBE'

  END
    !FB 1084 Kelvin 3 Oct 2017
    IF LOC:FN_Type = 'Disbursement'
       IF LOC:FilterFeeNoteString 
          LOC:FilterFeeNoteString = LOC:FilterFeeNoteString & ' AND FeeNote.Type1 <> ''F''' !was = ''D'' but that didn't include revenue stamp and creditors. Spoke to Nicole
       ELSE
          LOC:FilterFeeNoteString = ' FeeNote.Type1 = ''D'''
       END
    ELSIF LOC:FN_Type = 'Fee'
       IF LOC:FilterFeeNoteString 
         LOC:FilterFeenoteString = LOC:FilterFeenoteString & ' AND FeeNote.Type1 = ''F'''
       ELSE
         LOC:FilterFeenoteString = ' FeeNote.Type1 = ''F'''
       END
    ELSIF LOC:FN_Type = 'Creditor'
  !FB 1302 KDS 20 Feb 2018
       IF LOC:FilterFeeNoteString 
         LOC:FilterFeenoteString = LOC:FilterFeenoteString & ' AND FeeNote.Type1 = ''C'''
       ELSE
         LOC:FilterFeenoteString = ' FeeNote.Type1 = ''C'''
       END
    END

    IF LOC:FN_Period = 'This Period'
       IF LOC:FilterFeeNoteString 
          LOC:FilterFeeNoteString = LOC:FilterFeeNoteString & ' AND FeeNote.CapturedPeriod = ' & CTL:CurrentPeriod & ' and FeeNote.CapturedYear = ' & CTL:LastFYrEnd
       ELSE
          LOC:FilterFeeNoteString = 'FeeNote.CapturedPeriod = ' & CTL:CurrentPeriod & ' and FeeNote.CapturedYear = ' & CTL:LastFYrEnd
       END
    ELSIF LOC:FN_Period = 'This Fin Year'
       IF LOC:FilterFeeNoteString 
         LOC:FilterFeenoteString = LOC:FilterFeenoteString & ' AND FeeNote.CapturedYear = ' & CTL:LastFYrEnd
       ELSE
         LOC:FilterFeenoteString = 'FeeNote.CapturedYear = ' & CTL:LastFYrEnd
       END
    ELSE

       IF LOC:FN_FromDate
          IF LOC:FilterFeeNoteString 
             LOC:FilterFeeNoteString = LOC:FilterFeeNoteString & ' AND FeeNote.Date >= ' & LOC:FN_FromDate
          ELSE
             LOC:FilterFeeNoteString = 'FeeNote.Date >= ' & LOC:FN_FromDate
          END
       END

       IF LOC:FN_ToDate
          IF LOC:FilterFeeNoteString 
             LOC:FilterFeeNoteString = LOC:FilterFeeNoteString & ' AND FeeNote.Date <= ' & LOC:FN_ToDate
          ELSE
             LOC:FilterFeeNoteString = 'FeeNote.Date <= ' & LOC:FN_ToDate
          END
       END

    END

    Case LOC:PostedOption[1]
    Of 'U'
      IF LOC:FilterFeenoteString
         LOC:FilterFeenoteString = LOC:FilterFeenoteString & ' AND FeeNote.PostedFlag <> 1'
      ELSE
         LOC:FilterFeenoteString = 'FeeNote.PostedFlag <> 1'
      END
    Of 'P'
      IF LOC:FilterFeenoteString
         LOC:FilterFeenoteString = LOC:FilterFeenoteString & ' AND FeeNote.PostedFlag = 1'
      ELSE
         LOC:FilterFeenoteString = 'FeeNote.PostedFlag = 1'
      END
    .
    IF GLO:FN_EmployeeID > 0
      IF LOC:FilterFeenoteString
         LOC:FilterFeenoteString = LOC:FilterFeenoteString & ' and FeeNote.EmployeeID = ' & GLO:FN_EmployeeID
      ELSE
         LOC:FilterFeenoteString = 'FeeNote.EmployeeID = ' & GLO:FN_EmployeeID
      END
    ELSIF GLO:FN_EmployeeID = -999999 AND GLO:WorkgroupList
      IF LOC:FilterFeenoteString
         LOC:FilterFeenoteString = LOC:FilterFeenoteString & ' and FeeNote.EmployeeID IN ' & GLO:WorkgroupList
      ELSE
         LOC:FilterFeenoteString = 'FeeNote.EmployeeID IN ' & GLO:WorkgroupList
      END
    .
    IF GLO:FN_CostCentreID > 0
      IF LOC:FilterFeenoteString
         LOC:FilterFeenoteString = LOC:FilterFeenoteString & ' and FeeNote.CostCentreID = ' & GLO:FN_CostCentreID
      ELSE
         LOC:FilterFeenoteString = 'FeeNote.CostCentreID = ' & GLO:FN_CostCentreID
      END
    .

! Nick - test
    IF LOC:FN_Matter = 'Current'
       IF LOC:FilterFeenoteString
          LOC:FilterFeenoteString = LOC:FilterFeenoteString & ' and FeeNote.MatterID = ' & LOC:CurrentMatterID
       ELSE
          LOC:FilterFeenoteString = 'FeeNote.MatterID = ' & LOC:CurrentMatterID
       END
    END

    IF LOC:FN_Matter = 'Filtered'
       IF LOC:FilterMatterString
          IF LOC:FilterFeenoteString
             LOC:FilterFeenoteString = LOC:FilterFeenoteString & ' AND FeeNote.MatterID IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')'
          ELSE
             LOC:FilterFeenoteString = 'FeeNote.MatterID IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')'
          END
       END
    ELSIF LOC:FN_Matter = 'Tagged'

       IF FstTag:PtrM(Tag:Matter)

          DO CreateTaggedMatterList

          IF LOC:FilterFeenoteString
             LOC:FilterFeenoteString = LOC:FilterFeenoteString & ' AND FeeNote.MatterID IN (' & LOC:TaggedMatterList & ')'
          ELSE
             LOC:FilterFeenoteString = 'FeeNote.MatterID IN (' & LOC:TaggedMatterList & ')'
          END

       END

    END

    IF CTL:ShowDesktopTotalsFlag

       IF LOC:FilterFeeNoteString
          PropSQLNext('SELECT Count(1) FROM FeeNote WHERE ' & LOC:FilterFeeNoteString)
       ELSE
          PropSQLNext('SELECT rows FROM sysindexes WHERE id = OBJECT_ID(''FeeNote'') AND indid < 2')
       END
       LOC:FilteredFeeNotes = ROW:Counter

       PropSQLNext('SELECT rows FROM sysindexes WHERE id = OBJECT_ID(''FeeNote'') AND indid < 2')
       LOC:TotalRecords = ROW:Counter

    END

    IF BRW2::Filter = 1 ! THE USER IS SHOWING TAGGED RECORDS
       IF FstTag:PtrM(Tag:FeeNote) 
         LOC:FilterFeenoteString = CreateQBEFilterString(TAG:FeeNote,'FeeNote')
       END
    END


MakeFilterFilenoteString    ROUTINE

   DO SetFIL_DatePeriod


! 14/9/2014 - RICK - NOT TAGGING QBE ANYMORE - IT TAKES TOO LONG

    LOC:FilterFileNoteString = ''

    IF LOC:QBEFilterFileNoteString

        LOC:FilterFileNoteString = 'FileNote.RecordID IN (SELECT FileNote.RecordID FROM ' & LOC:QBEFilterFileNoteString & ')'

        ?FIL:QBESearchButton{PROP:Icon} = '~folder_delete.ico'
        ?FIL:QBESearchButton{PROP:Tooltip} = 'Clear the QBE filter'

    ELSE

        ?FIL:QBESearchButton{PROP:Icon} = '~folder_view.ico'
        ?FIL:QBESearchButton{PROP:Tooltip} = 'Filter the File Notes using QBE'

    END



    IF LOC:FIL_FromDate
       IF LOC:FilterFileNoteString 
          LOC:FilterFileNoteString = LOC:FilterFileNoteString & ' AND FileNote.Date >= ' & LOC:FIL_FromDate
       ELSE
          LOC:FilterFileNoteString = 'FileNote.Date >= ' & LOC:FIL_FromDate
       END
    END

    IF LOC:FIL_ToDate
       IF LOC:FilterFileNoteString 
          LOC:FilterFileNoteString = LOC:FilterFileNoteString & ' AND FileNote.Date <= ' & LOC:FIL_ToDate
       ELSE
          LOC:FilterFileNoteString = 'FileNote.Date <= ' & LOC:FIL_ToDate
       END
    END

   IF GLO:FIL_EmployeeID > 0
      IF LOC:FilterFilenoteString 
         LOC:FilterFilenoteString = LOC:FilterFilenoteString & ' AND FileNote.EmployeeID = ' & GLO:FIL_EmployeeID
      ELSE
         LOC:FilterFilenoteString = 'FileNote.EmployeeID = ' & GLO:FIL_EmployeeID
      END
   ELSIF GLO:FIL_EmployeeID = -999999 AND GLO:WorkgroupList
      IF LOC:FilterFilenoteString 
         LOC:FilterFilenoteString = LOC:FilterFilenoteString & ' AND FileNote.EmployeeID IN ' & GLO:WorkgroupList
      ELSE
         LOC:FilterFilenoteString = 'FileNote.EmployeeID IN ' & GLO:WorkgroupList
      END
   END
  
   IF LOC:FIL_Matter = 'Current'
      IF LOC:FilterFileNoteString 
         LOC:FilterFileNoteString = LOC:FilterFileNoteString & ' AND FileNote.MatterID = ' & LOC:CurrentMatterID
      ELSE
         LOC:FilterFileNoteString = 'FileNote.MatterID = ' & LOC:CurrentMatterID
      END
   END


    IF LOC:FIL_Status = 'No Stage'
       IF LOC:FilterFileNoteString
          LOC:FilterFileNoteString = LOC:FilterFileNoteString & ' and FileNote.StageID = 0'
       ELSE
          LOC:FilterFileNoteString = 'FileNote.StageID = 0'
       END
    ELSIF LOC:FIL_Status = 'Stage Reached'
       IF LOC:FilterFileNoteString
          LOC:FilterFileNoteString = LOC:FilterFileNoteString & ' and FileNote.StageID > 0'
       ELSE
          LOC:FilterFileNoteString = 'FileNote.StageID > 0'
       END
    END

    IF LOC:FIL_Internal = 'Internal'
       IF LOC:FilterFileNoteString
          LOC:FilterFileNoteString = LOC:FilterFileNoteString & ' and FileNote.InternalFlag = 1'
       ELSE
          LOC:FilterFileNoteString = 'FileNote.InternalFlag = 1'
       END
    ELSIF LOC:FIL_Internal = 'Not Internal'
       IF LOC:FilterFileNoteString
          LOC:FilterFileNoteString = LOC:FilterFileNoteString & ' and (FileNote.InternalFlag = 0 OR FileNote.InternalFlag IS NULL)'
       ELSE
          LOC:FilterFileNoteString = '(FileNote.InternalFlag = 0 OR FileNote.InternalFlag IS NULL)'
       END
    END


   IF LOC:FIL_Matter = 'Filtered'
      IF LOC:FilterMatterString
         IF LOC:FilterFileNoteString
            LOC:FilterFileNoteString = LOC:FilterFileNoteString & ' AND FileNote.MatterID IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')'
         ELSE
            LOC:FilterFileNoteString = 'FileNote.MatterID IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')'
         END
      END

    ELSIF LOC:FIL_Matter = 'Tagged'

       IF FstTag:PtrM(Tag:Matter)

          DO CreateTaggedMatterList

          IF LOC:FilterFilenoteString
             LOC:FilterFilenoteString = LOC:FilterFilenoteString & ' AND FileNote.MatterID IN (' & LOC:TaggedMatterList & ')'
          ELSE
             LOC:FilterFilenoteString = 'FileNote.MatterID IN (' & LOC:TaggedMatterList & ')'
          END

       END

   END


   IF CTL:ShowDesktopTotalsFlag

      IF LOC:FilterFileNoteString
         PropSQLNext('SELECT Count(1) FROM FileNote LEFT OUTER JOIN Employee ON Employee.RecordID = FileNote.EmployeeID LEFT OUTER JOIN Stage ON Stage.RecordID = FileNote.StageID LEFT OUTER JOIN Matter ON Matter.RecordID = FileNote.MatterID WHERE ' & LOC:FilterFileNoteString)
         LOC:FilteredFileNotes = ROW:Counter

         PropSQLNext('SELECT rows FROM sysindexes WHERE id = OBJECT_ID(''FileNote'') AND indid < 2')
         LOC:TotalRecords = ROW:Counter
      ELSE
         PropSQLNext('SELECT rows FROM sysindexes WHERE id = OBJECT_ID(''FileNote'') AND indid < 2')
         LOC:FilteredFileNotes = ROW:Counter
         LOC:TotalRecords = ROW:Counter
      END


   ELSE


       HIDE(?LOC:FilteredFileNotes:Prompt)
       HIDE(?LOC:FilteredFileNotes)

    END



    IF BRW52::Filter = 1 ! THE USER IS SHOWING TAGGED RECORDS
       IF FstTag:PtrM(Tag:FileNote) 
         LOC:FilterFilenoteString = CreateQBEFilterString(TAG:FileNote,'FileNote')
       END
    END





MakeFilterToDonoteString    ROUTINE

    DO SetTOD_DatePeriod

! 14/9/2014 - RICK - NOT TAGGING QBE ANYMORE - IT TAKES TOO LONG

    LOC:FilterToDoNoteString = ''

    IF LOC:QBEFilterToDoNoteString

        LOC:FilterToDoNoteString = 'ToDoNote.RecordID IN (SELECT ToDoNote.RecordID FROM ' & LOC:QBEFilterToDoNoteString & ')'

        ?TOD:QBESearchButton{PROP:Icon} = '~folder_delete.ico'
        ?TOD:QBESearchButton{PROP:Tooltip} = 'Clear the QBE filter'

    ELSE

        ?TOD:QBESearchButton{PROP:Icon} = '~folder_view.ico'
        ?TOD:QBESearchButton{PROP:Tooltip} = 'Filter the Reminders using QBE'

    END


    IF LOC:TOD_FromDate
       IF LOC:FilterToDoNoteString 
          LOC:FilterToDoNoteString = LOC:FilterToDoNoteString & ' AND ToDoNote.Date >= ' & LOC:TOD_FromDate
       ELSE
          LOC:FilterToDoNoteString = 'ToDoNote.Date >= ' & LOC:TOD_FromDate
       END
    END

    IF LOC:TOD_ToDate
       IF LOC:FilterToDoNoteString 
          LOC:FilterToDoNoteString = LOC:FilterToDoNoteString & ' AND ToDoNote.Date <= ' & LOC:TOD_ToDate
       ELSE
          LOC:FilterToDoNoteString = 'ToDoNote.Date <= ' & LOC:TOD_ToDate
       END
    END


    IF LOC:TOD_Status = 'Incomplete'
       IF LOC:FilterToDoNoteString 
          LOC:FilterToDoNoteString = LOC:FilterToDoNoteString & ' and (ToDoNote.DateDone = 0 OR ToDoNote.DateDone IS NULL)'
       ELSE
          LOC:FilterToDoNoteString = '(ToDoNote.DateDone = 0 OR ToDoNote.DateDone IS NULL)'
       END
    ELSIF LOC:TOD_Status = 'Completed'
       IF LOC:FilterToDoNoteString 
          LOC:FilterToDoNoteString = LOC:FilterToDoNoteString & ' and ToDoNote.DateDone > 0'
       ELSE
          LOC:FilterToDoNoteString = 'ToDoNote.DateDone > 0'
       END
    END

    IF LOC:TOD_CriticalStepID > 0
       IF LOC:FilterToDoNoteString 
          LOC:FilterToDoNoteString = LOC:FilterToDoNoteString & ' AND ToDoItem.CriticalStep = ' & LOC:TOD_CriticalStepID
       ELSE
          LOC:FilterToDoNoteString = 'ToDoItem.CriticalStep = ' & LOC:TOD_CriticalStepID
       END
    END

    IF GLO:TOD_EmployeeID > 0
       IF LOC:FilterToDoNoteString 
          LOC:FilterToDoNoteString = LOC:FilterToDoNoteString & ' and ToDoNote.EmployeeID = ' & GLO:TOD_EmployeeID
       ELSE
          LOC:FilterToDoNoteString = 'ToDoNote.EmployeeID = ' & GLO:TOD_EmployeeID
       END
    ELSIF GLO:TOD_EmployeeID = -999999 AND GLO:WorkgroupList
       IF LOC:FilterToDoNoteString 
          LOC:FilterToDoNoteString = LOC:FilterToDoNoteString & ' and ToDoNote.EmployeeID IN ' & GLO:WorkgroupList
       ELSE
          LOC:FilterToDoNoteString = 'ToDoNote.EmployeeID IN ' & GLO:WorkgroupList
       END
    END


    IF LOC:TOD_Matter = 'Current'
       IF LOC:FilterToDoNoteString 
          LOC:FilterToDoNoteString = LOC:FilterToDoNoteString & ' and ToDoNote.MatterID = ' & LOC:CurrentMatterID
       ELSE
          LOC:FilterToDoNoteString = 'ToDoNote.MatterID = ' & LOC:CurrentMatterID
       END
    END


   IF LOC:TOD_Matter = 'Filtered'
      IF LOC:FilterMatterString
         IF LOC:FilterToDoNoteString
            LOC:FilterToDoNoteString = LOC:FilterToDoNoteString & ' AND ToDoNote.MatterID IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')'
         ELSE
            LOC:FilterToDoNoteString = 'ToDoNote.MatterID IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')'
         END
      END
    ELSIF LOC:TOD_Matter = 'Tagged'

       IF FstTag:PtrM(Tag:Matter)

          DO CreateTaggedMatterList

          IF LOC:FilterToDonoteString
             LOC:FilterToDonoteString = LOC:FilterToDonoteString & ' AND ToDoNote.MatterID IN (' & LOC:TaggedMatterList & ')'
          ELSE
             LOC:FilterToDonoteString = 'ToDoNote.MatterID IN (' & LOC:TaggedMatterList & ')'
          END

       END

   END

   IF CTL:ShowDesktopTotalsFlag

      IF LOC:FilterToDoNoteString
         PropSQLNext('SELECT Count(1) FROM ToDoNote LEFT OUTER JOIN ToDoItem ON ToDoNote.ToDoItemID = ToDoItem.RecordID WHERE ' & LOC:FilterToDoNoteString)
      ELSE
          PropSQLNext('SELECT rows FROM sysindexes WHERE id = OBJECT_ID(''ToDoNote'') AND indid < 2')
      END
      LOC:FilteredReminders = ROW:Counter
      PropSQLNext('SELECT rows FROM sysindexes WHERE id = OBJECT_ID(''ToDoNote'') AND indid < 2')
      LOC:TotalRecords = ROW:Counter

   ELSE


!                           PROMPT('Total:'),AT(73,221),USE(?LOC:FilteredReminders:Prompt)
!                           ENTRY(@n_9),AT(95,221,47,10),USE(LOC:FilteredReminders),SKIP,RIGHT(1),COLOR(COLOR:Silver),TIP('The total number of Reminders displayed'),READONLY


      HIDE(?LOC:FilteredReminders:Prompt)
      HIDE(?LOC:FilteredReminders)

   END




    IF BRW15::Filter = 1 ! THE USER IS SHOWING TAGGED RECORDS
       IF FstTag:PtrM(Tag:ToDoNote) 
         LOC:FilterToDonoteString = CreateQBEFilterString(TAG:ToDoNote,'ToDoNote')
       END
    END


MakeFilterMatActivString    ROUTINE

    DO SetMA_DatePeriod

! 14/9/2014 - RICK - NOT TAGGING QBE ANYMORE - IT TAKES TOO LONG

    LOC:FilterMatActivString = ''

    IF LOC:QBEFilterMatActivString

        LOC:FilterMatActivString = 'MatActiv.RecordID IN (SELECT MatActiv.RecordID FROM ' & LOC:QBEFilterMatActivString & ')'

        ?MA:QBESearchButton{PROP:Icon} = '~folder_delete.ico'
        ?MA:QBESearchButton{PROP:Tooltip} = 'Clear the QBE filter'

    ELSE

        ?MA:QBESearchButton{PROP:Icon} = '~folder_view.ico'
        ?MA:QBESearchButton{PROP:Tooltip} = 'Filter the Time Records using QBE'

    END


    IF LOC:MA_FromDate
       IF LOC:FilterMatActivString 
          LOC:FilterMatActivString = LOC:FilterMatActivString & ' AND MatActiv.Date >= ' & LOC:MA_FromDate
       ELSE
          LOC:FilterMatActivString = 'MatActiv.Date >= ' & LOC:MA_FromDate
       END
    END

    IF LOC:MA_ToDate
       IF LOC:FilterMatActivString 
          LOC:FilterMatActivString = LOC:FilterMatActivString & ' AND MatActiv.Date <= ' & LOC:MA_ToDate
       ELSE
          LOC:FilterMatActivString = 'MatActiv.Date <= ' & LOC:MA_ToDate
       END
    END


    IF LOC:MA_BilledFlag = 'Billed'
       IF LOC:FilterMatActivString 
          LOC:FilterMatActivString = LOC:FilterMatActivString & ' and MatActiv.FeeNoteID > 0'
       ELSE
          LOC:FilterMatActivString = 'MatActiv.FeeNoteID > 0'
       END
    ELSIF LOC:MA_BilledFlag = 'Not Billed'
       IF LOC:FilterMatActivString 
          LOC:FilterMatActivString = LOC:FilterMatActivString & ' and MatActiv.FeeNoteID = 0'
       ELSE
          LOC:FilterMatActivString = 'MatActiv.FeeNoteID = 0'
       END
    END

    IF GLO:MA_EmployeeID > 0
       IF LOC:FilterMatActivString
          LOC:FilterMatActivString = LOC:FilterMatActivString & ' and MatActiv.EmployeeID = ' & GLO:MA_EmployeeID
       ELSE
          LOC:FilterMatActivString = 'MatActiv.EmployeeID = ' & GLO:MA_EmployeeID
       END
    ELSIF GLO:MA_EmployeeID = -999999 AND GLO:WorkgroupList
       IF LOC:FilterMatActivString
          LOC:FilterMatActivString = LOC:FilterMatActivString & ' and MatActiv.EmployeeID IN ' & GLO:WorkgroupList
       ELSE
          LOC:FilterMatActivString = 'MatActiv.EmployeeID IN ' & GLO:WorkgroupList
       END
    END

    IF GLO:MA_CostCentreID > 0
      IF LOC:FilterMatActivString
         LOC:FilterMatActivString = LOC:FilterMatActivString & ' AND MatActiv.CostCentreID = ' & GLO:MA_CostCentreID
      ELSE
         LOC:FilterMatActivString = LOC:FilterMatActivString & 'MatActiv.CostCentreID = ' & GLO:MA_CostCentreID
      END
    .


    IF LOC:MA_ActivityID > 0
       IF LOC:FilterMatActivString
          LOC:FilterMatActivString = LOC:FilterMatActivString & ' AND MatActiv.ActivityID = ' & LOC:MA_ActivityID
       ELSE
          LOC:FilterMatActivString = 'MatActiv.ActivityID = ' & LOC:MA_ActivityID
       END
    END

    IF LOC:MA_Matter = 'Current'
       IF LOC:FilterMatActivString
          LOC:FilterMatActivString = LOC:FilterMatActivString & ' and MatActiv.MatterID = ' & LOC:CurrentMatterID
       ELSE
          LOC:FilterMatActivString = 'MatActiv.MatterID = ' & LOC:CurrentMatterID
       END
    END


   IF LOC:MA_Matter = 'Filtered'
      IF LOC:FilterMatterString
         IF LOC:FilterMatActivString
            LOC:FilterMatActivString = LOC:FilterMatActivString & ' AND MatActiv.MatterID IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')'
         ELSE
            LOC:FilterMatActivString = 'MatActiv.MatterID IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')'
         END
      END
   ELSIF LOC:MA_Matter = 'Tagged'
       IF FstTag:PtrM(Tag:Matter)

          DO CreateTaggedMatterList

          IF LOC:FilterMatActivString
             LOC:FilterMatActivString = LOC:FilterMatActivString & ' AND MatActiv.MatterID IN (' & LOC:TaggedMatterList & ')'
          ELSE
             LOC:FilterMatActivString = 'MatActiv.MatterID IN (' & LOC:TaggedMatterList & ')'
          END

       END

   END


   IF CTL:ShowDesktopTotalsFlag


      IF LOC:FilterMatActivString
         PropSQLNext('SELECT Count(1) FROM MatActiv WHERE ' & LOC:FilterMatActivString)
      ELSE
          PropSQLNext('SELECT rows FROM sysindexes WHERE id = OBJECT_ID(''MatActiv'') AND indid < 2')
      END
      LOC:FilteredMatActivs = ROW:Counter

      PropSQLNext('SELECT rows FROM sysindexes WHERE id = OBJECT_ID(''MatActiv'') AND indid < 2')
      LOC:TotalRecords = ROW:Counter

    END


    IF BRW22::Filter = 1 ! THE USER IS SHOWING TAGGED RECORDS
         LOC:FilterMatActivString = CreateQBEFilterString(TAG:MatActiv,'MatActiv')
    END


MakeFilterLawMatterMessageString    ROUTINE

   DO SetDAT_DatePeriod

   IF LOC:DAT_Period = 'All'
      LOC:FilterLawMatterMessageString = ''
   ELSE
      LOC:FilterLawMatterMessageString = 'DateDiff(dd,-36163,LawMatterMessage.Date) >= ' & LOC:DAT_FromDate & ' AND DateDiff(dd,-36163,LawMatterMessage.Date) <= ' & LOC:DAT_ToDate
   END



   IF LOC:QBEFilterLawMatterMessageString

      IF LOC:FilterLawMatterMessageString
         LOC:FilterLawMatterMessageString = LOC:FilterLawMatterMessageString & ' AND LawMatterMessage.RecordID IN (SELECT LawMatterMessage.RecordID FROM ' & LOC:QBEFilterLawMatterMessageString & ')'
      ELSE
         LOC:FilterLawMatterMessageString = 'LawMatterMessage.RecordID IN (SELECT LawMatterMessage.RecordID FROM ' & LOC:QBEFilterLawMatterMessageString & ')'
      END

        ?DAT:QBESearchButton{PROP:Icon} = '~folder_delete.ico'
        ?DAT:QBESearchButton{PROP:Tooltip} = 'Clear the QBE filter'

    ELSE

        ?DAT:QBESearchButton{PROP:Icon} = '~folder_view.ico'
        ?DAT:QBESearchButton{PROP:Tooltip} = 'Filter the Messages using QBE'

    END



   IF LOC:DAT_Matter = 'Current'
      IF LOC:FilterLawMatterMessageString 
         LOC:FilterLawMatterMessageString = LOC:FilterLawMatterMessageString & ' AND LawMatterMessage.MatterID = ' & LOC:CurrentMatterID
      ELSE
         LOC:FilterLawMatterMessageString = 'LawMatterMessage.MatterID = ' & LOC:CurrentMatterID
      END
   END



   IF LOC:DAT_Matter = 'Filtered'
      IF LOC:FilterMatterString
         IF LOC:FilterLawMatterMessageString
            LOC:FilterLawMatterMessageString = LOC:FilterLawMatterMessageString & ' AND LawMatterMessage.MatterID IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')'
         ELSE
            LOC:FilterLawMatterMessageString = 'LawMatterMessage.MatterID IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')'
         END
      END

    ELSIF LOC:DAT_Matter = 'Tagged'

       IF FstTag:PtrM(Tag:Matter)

          DO CreateTaggedMatterList

          IF LOC:FilterLawMatterMessageString
             LOC:FilterLawMatterMessageString = LOC:FilterLawMatterMessageString & ' AND LawMatterMessage.MatterID IN (' & LOC:TaggedMatterList & ')'
          ELSE
             LOC:FilterLawMatterMessageString = 'LawMatterMessage.MatterID IN (' & LOC:TaggedMatterList & ')'
          END

       END

   END


   IF CTL:ShowDesktopTotalsFlag


      IF LOC:FilterLawMatterMessageString
         PropSQLNext('SELECT Count(1) FROM LawMatterMessage WHERE ' & LOC:FilterLawMatterMessageString)
      ELSE
         PropSQLNext('SELECT rows FROM sysindexes WHERE id = OBJECT_ID(''LawMatterMessage'') AND indid < 2')
      END
      LOC:FilteredLawMatterMessages = ROW:Counter

      PropSQLNext('SELECT rows FROM sysindexes WHERE id = OBJECT_ID(''LawMatterMessage'') AND indid < 2')
      LOC:TotalRecords = ROW:Counter

    END


    IF BRW36::Filter = 1 ! THE USER IS SHOWING TAGGED RECORDS
       IF FstTag:PtrM(Tag:LawMatterMessage) 
         LOC:FilterLawMatterMessageString = CreateQBEFilterString(Tag:LawMatterMessage,'LawMatterMessage')
       END
    END


MakeFilterFNBLinkString    ROUTINE


! jess

    DO SetFNB_DatePeriod


    LOC:FilterFNBLinkString = ''

    IF LOC:FNB_FromDate
       IF LOC:FilterFNBLinkString 
          LOC:FilterFNBLinkString = LOC:FilterFNBLinkString & ' AND AG_MatterMessage.Date >= ' & LOC:FNB_FromDate
       ELSE
          LOC:FilterFNBLinkString = 'AG_MatterMessage.Date >= ' & LOC:FNB_FromDate
       END
    END

    IF LOC:FNB_ToDate
       IF LOC:FilterFNBLinkString 
          LOC:FilterFNBLinkString = LOC:FilterFNBLinkString & ' AND AG_MatterMessage.Date <= ' & LOC:FNB_ToDate
       ELSE
          LOC:FilterFNBLinkString = 'AG_MatterMessage.Date <= ' & LOC:FNB_ToDate
       END
    END

    IF LOC:FNB_Matter = 'Current'
       IF LOC:FilterFNBLinkString 
          LOC:FilterFNBLinkString = LOC:FilterFNBLinkString & ' And AG_MatterMessage.MatterID = ' & LOC:CurrentMatterID
       ELSE
          LOC:FilterFNBLinkString = 'AG_MatterMessage.MatterID = ' & LOC:CurrentMatterID
       END
    END

    !Message('1 AGDQ:Description=' & AGDQ:Description & '|AGDQ:SuiteID=' & AGDQ:SuiteID)

! Eugene
    IF AGDQ:SuiteID <> -1  ! IF NOT ALL

       IF LOC:FilterFNBLinkString 
          LOC:FilterFNBLinkString = LOC:FilterFNBLinkString & ' And LAW_Suite.SuiteID = ' & AGDQ:SuiteID
       ELSE
          LOC:FilterFNBLinkString = ' LAW_Suite.SuiteID = ' & AGDQ:SuiteID
       END
    END

    IF LOC:FNB_Matter = 'Filtered'


       IF LOC:FilterMatterString
          IF LOC:FilterFNBLinkString
             LOC:FilterFNBLinkString = LOC:FilterFNBLinkString & ' AND AG_MatterMessage.MatterID IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')'
          ELSE
             LOC:FilterFNBLinkString = 'AG_MatterMessage.MatterID IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')'
          END
       END


    END


!                    SETCLIPBOARD('SELECT * FROM AG_MatterMessage WHERE ' & LOC:FilterFNBLinkString)
!                    MESSAGE('1 SELECT * FROM AG_MatterMessage WHERE ' & LOC:FilterFNBLinkString)


MakeFilterSARSLinkString    ROUTINE

    DO SetSARS_DatePeriod

    LOC:FilterSARSLinkString = ''

    IF LOC:SARS_FromDate
       IF LOC:FilterSARSLinkString 
          LOC:FilterSARSLinkString = LOC:FilterSARSLinkString & ' AND SARS_MatterMessage.Date >= ' & LOC:SARS_FromDate
       ELSE
          LOC:FilterSARSLinkString = 'SARS_MatterMessage.Date >= ' & LOC:SARS_FromDate
       END
    END

    IF LOC:SARS_ToDate
       IF LOC:FilterSARSLinkString 
          LOC:FilterSARSLinkString = LOC:FilterSARSLinkString & ' AND SARS_MatterMessage.Date <= ' & LOC:SARS_ToDate
       ELSE
          LOC:FilterSARSLinkString = 'SARS_MatterMessage.Date <= ' & LOC:SARS_ToDate
       END
    END

   IF LOC:SARS_Matter = 'Current'
      IF LOC:FilterSARSLinkString 
         LOC:FilterSARSLinkString = LOC:FilterSARSLinkString & ' And SARS_MatterMessage.MatterID = ' & LOC:CurrentMatterID
      ELSE
         LOC:FilterSARSLinkString = 'SARS_MatterMessage.MatterID = ' & LOC:CurrentMatterID
      END
   END

   IF LOC:SARS_Matter = 'Filtered'
      IF LOC:FilterMatterString
         IF LOC:FilterSARSLinkString
            LOC:FilterSARSLinkString = LOC:FilterSARSLinkString & ' AND SARS_MatterMessage.MatterID IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')'
         ELSE
            LOC:FilterSARSLinkString = 'SARS_MatterMessage.MatterID IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')'
         END
      END
   END

!   SETCLIPBOARD('SELECT * FROM SARS_MatterMessage WHERE ' & LOC:FilterSARSLinkString)
!   MESSAGE('SELECT * FROM SARS_MatterMessage WHERE ' & LOC:FilterSARSLinkString)

MakeFilterABSALinkString    ROUTINE

    DO SetABSA_DatePeriod


    LOC:FilterABSALinkString = ''

    IF LOC:ABSA_FromDate
       IF LOC:FilterABSALinkString 
          LOC:FilterABSALinkString = LOC:FilterABSALinkString & ' AND ABSA_MatterMessage.Date >= ' & LOC:ABSA_FromDate
       ELSE
          LOC:FilterABSALinkString = 'ABSA_MatterMessage.Date >= ' & LOC:ABSA_FromDate
       END
    END

    IF LOC:ABSA_ToDate
       IF LOC:FilterABSALinkString 
          LOC:FilterABSALinkString = LOC:FilterABSALinkString & ' AND ABSA_MatterMessage.Date <= ' & LOC:ABSA_ToDate
       ELSE
          LOC:FilterABSALinkString = 'ABSA_MatterMessage.Date <= ' & LOC:ABSA_ToDate
       END
    END

    IF LOC:ABSA_Direction = 'To'
       IF LOC:FilterABSALinkString 
          LOC:FilterABSALinkString = LOC:FilterABSALinkString & ' And ABSA_MatterMessage.MessageDirection = ''To'''
       ELSE
          LOC:FilterABSALinkString = 'ABSA_MatterMessage.MessageDirection = ''To'''
       END
    ELSIF LOC:ABSA_Direction = 'From'
       IF LOC:FilterABSALinkString 
          LOC:FilterABSALinkString = LOC:FilterABSALinkString & ' And ABSA_MatterMessage.MessageDirection = ''From'''
       ELSE
          LOC:FilterABSALinkString = 'ABSA_MatterMessage.MessageDirection = ''From'''
       END
    END


    IF LOC:ABSA_Matter = 'Current'
       IF LOC:FilterABSALinkString 
          LOC:FilterABSALinkString = LOC:FilterABSALinkString & ' And ABSA_MatterMessage.MatterID = ' & LOC:CurrentMatterID
       ELSE
          LOC:FilterABSALinkString = 'ABSA_MatterMessage.MatterID = ' & LOC:CurrentMatterID
       END
    END


    IF LOC:ABSA_Matter = 'Current'
       LOC:ABSA_DG_Code = 'All'
       ?LOC:ABSA_DG_Code{PROP:Selected} = 1
    END

    IF LOC:ABSA_DG_Code <> 'All'
       IF LOC:FilterABSALinkString 
          LOC:FilterABSALinkString = LOC:FilterABSALinkString & ' AND DocGenAlias.Code = ''' & LOC:ABSA_DG_Code & ''''
       ELSE
          LOC:FilterABSALinkString = 'DocGenAlias.Code = ''' & LOC:ABSA_DG_Code & ''''
       END
    END



    IF LOC:ABSA_Matter = 'Filtered'
       IF LOC:FilterMatterString
          IF LOC:FilterABSALinkString
             LOC:FilterABSALinkString = LOC:FilterABSALinkString & ' AND ABSA_MatterMessage.MatterID IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')'
          ELSE
             LOC:FilterABSALinkString = 'ABSA_MatterMessage.MatterID IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')'
          END
       END
    END




SetFN_DatePeriod       ROUTINE

      IF LOC:FN_Period = 'Custom'
         UNHIDE(?CustomFN_PeriodButton)
      ELSE
         HIDE(?CustomFN_PeriodButton)
      END

      CASE LOC:FN_Period
           OF 'Today'
               LOC:FN_FromDate = GLO:TodaysDate
               LOC:FN_ToDate = GLO:TodaysDate
           OF 'Yesterday'
               LOC:FN_FromDate = GLO:TodaysDate-1
               LOC:FN_ToDate = GLO:TodaysDate-1
           OF 'This Week'
               IF GLO:TodaysDate%7 = 0  ! IF SUNDAY
                  LOC:FN_FromDate = GLO:TodaysDate - 6
               ELSE
                  LOC:FN_FromDate = GLO:TodaysDate - GLO:TodaysDate%7 + 1
               END
               LOC:FN_ToDate = LOC:FN_FromDate + 6
           OF 'Last Week'
               IF GLO:TodaysDate%7 = 0  ! IF SUNDAY
                  LOC:FN_FromDate = GLO:TodaysDate + 1
               ELSE
                  LOC:FN_FromDate = GLO:TodaysDate - GLO:TodaysDate%7 + 1
               END
               LOC:FN_FromDate -= 7
               LOC:FN_ToDate = LOC:FN_FromDate + 6
           OF 'This Month'
               LOC:FN_FromDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))
               IF MONTH(GLO:TodaysDate) = 12
                  LOC:FN_ToDate = DATE(12,31,YEAR(GLO:TodaysDate))
               ELSE
                  LOC:FN_ToDate = DATE(MONTH(GLO:TodaysDate)+1,1,YEAR(GLO:TodaysDate))-1
               END
           OF 'Last Month'
               IF MONTH(GLO:TodaysDate) = 1
                  LOC:FN_FromDate = DATE(12,1,YEAR(GLO:TodaysDate)-1)
               ELSE
                  LOC:FN_FromDate = DATE(MONTH(GLO:TodaysDate)-1,1,YEAR(GLO:TodaysDate))
               END
               LOC:FN_ToDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))-1
           OF 'This Fin Year'
               LOC:FN_FromDate = 0
               LOC:FN_ToDate = 0
           OF 'This Period' 
               LOC:FN_FromDate = 0
               LOC:FN_ToDate = 0
           OF 'All'
               LOC:FN_FromDate = 0
               LOC:FN_ToDate = 0
       END

SetFIL_DatePeriod       ROUTINE

      IF LOC:FIL_Period = 'Custom'
         UNHIDE(?CustomFIL_PeriodButton)
      ELSE
         HIDE(?CustomFIL_PeriodButton)
      END


      CASE LOC:FIL_Period
           OF 'Today'
               LOC:FIL_FromDate = GLO:TodaysDate
               LOC:FIL_ToDate = GLO:TodaysDate
           OF 'Yesterday'
               LOC:FIL_FromDate = GLO:TodaysDate-1
               LOC:FIL_ToDate = GLO:TodaysDate-1
           OF 'This Week'
               IF GLO:TodaysDate%7 = 0  ! IF SUNDAY
                  LOC:FIL_FromDate = GLO:TodaysDate - 6
               ELSE
                  LOC:FIL_FromDate = GLO:TodaysDate - GLO:TodaysDate%7 + 1
               END
               LOC:FIL_ToDate = LOC:FIL_FromDate + 6
           OF 'This Month'
               LOC:FIL_FromDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))
               IF MONTH(GLO:TodaysDate) = 12
                  LOC:FIL_ToDate = DATE(12,31,YEAR(GLO:TodaysDate))
               ELSE
                  LOC:FIL_ToDate = DATE(MONTH(GLO:TodaysDate)+1,1,YEAR(GLO:TodaysDate))-1
               END
           OF 'Last Month'
               IF MONTH(GLO:TodaysDate) = 1
                  LOC:FIL_FromDate = DATE(12,1,YEAR(GLO:TodaysDate)-1)
               ELSE
                  LOC:FIL_FromDate = DATE(MONTH(GLO:TodaysDate)-1,1,YEAR(GLO:TodaysDate))
               END
               LOC:FIL_ToDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))-1
           OF 'This Year'
               LOC:FIL_FromDate = DATE(1,1,YEAR(GLO:TodaysDate))
               LOC:FIL_ToDate = DATE(12,31,YEAR(GLO:TodaysDate))
           OF 'All'
               LOC:FIL_FromDate = 0
               LOC:FIL_ToDate = 0
       END
       !SELECT(?FileNoteBrowse)

SetTOD_DatePeriod       ROUTINE

      IF LOC:TOD_Period = 'Custom'
         UNHIDE(?CustomTOD_PeriodButton)
      ELSE
         HIDE(?CustomTOD_PeriodButton)
      END


      CASE LOC:TOD_Period
           OF 'Today'
               LOC:TOD_FromDate = GLO:TodaysDate
               LOC:TOD_ToDate = GLO:TodaysDate
           OF 'Yesterday'
               LOC:TOD_FromDate = GLO:TodaysDate-1
               LOC:TOD_ToDate = GLO:TodaysDate-1
           OF 'Today & Earlier'
               LOC:TOD_FromDate = 0
               LOC:TOD_ToDate = GLO:TodaysDate
           OF 'This Week'
               IF GLO:TodaysDate%7 = 0  ! IF SUNDAY
                  LOC:TOD_FromDate = GLO:TodaysDate - 6
               ELSE
                  LOC:TOD_FromDate = GLO:TodaysDate - GLO:TodaysDate%7 + 1
               END
               LOC:TOD_ToDate = LOC:TOD_FromDate + 6
           OF 'This Month'
               LOC:TOD_FromDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))
               IF MONTH(GLO:TodaysDate) = 12
                  LOC:TOD_ToDate = DATE(12,31,YEAR(GLO:TodaysDate))
               ELSE
                  LOC:TOD_ToDate = DATE(MONTH(GLO:TodaysDate)+1,1,YEAR(GLO:TodaysDate))-1
               END
           OF 'Last Month'
               IF MONTH(GLO:TodaysDate) = 1
                  LOC:TOD_FromDate = DATE(12,1,YEAR(GLO:TodaysDate)-1)
               ELSE
                  LOC:TOD_FromDate = DATE(MONTH(GLO:TodaysDate)-1,1,YEAR(GLO:TodaysDate))
               END
               LOC:TOD_ToDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))-1
           OF 'This Year'
               LOC:TOD_FromDate = DATE(1,1,YEAR(GLO:TodaysDate))
               LOC:TOD_ToDate = DATE(12,31,YEAR(GLO:TodaysDate))
           OF 'All'
               LOC:TOD_FromDate = 0
               LOC:TOD_ToDate = 0
       END
       !SELECT(?ToDoNoteBrowse)


SetMA_DatePeriod       ROUTINE


      IF LOC:MA_Period = 'Custom'
         UNHIDE(?CustomMA_PeriodButton)
      ELSE
         HIDE(?CustomMA_PeriodButton)
      END


      CASE LOC:MA_Period
           OF 'Today'
               LOC:MA_FromDate = GLO:TodaysDate
               LOC:MA_ToDate = GLO:TodaysDate
           OF 'Yesterday'
               LOC:MA_FromDate = GLO:TodaysDate-1
               LOC:MA_ToDate = GLO:TodaysDate-1
           OF 'This Week'
               IF GLO:TodaysDate%7 = 0  ! IF SUNDAY
                  LOC:MA_FromDate = GLO:TodaysDate - 6
               ELSE
                  LOC:MA_FromDate = GLO:TodaysDate - GLO:TodaysDate%7 + 1
               END
               LOC:MA_ToDate = LOC:MA_FromDate + 6
           OF 'This Month'
               LOC:MA_FromDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))
               IF MONTH(GLO:TodaysDate) = 12
                  LOC:MA_ToDate = DATE(12,31,YEAR(GLO:TodaysDate))
               ELSE
                  LOC:MA_ToDate = DATE(MONTH(GLO:TodaysDate)+1,1,YEAR(GLO:TodaysDate))-1
               END
           OF 'Last Month'
               IF MONTH(GLO:TodaysDate) = 1
                  LOC:MA_FromDate = DATE(12,1,YEAR(GLO:TodaysDate)-1)
               ELSE
                  LOC:MA_FromDate = DATE(MONTH(GLO:TodaysDate)-1,1,YEAR(GLO:TodaysDate))
               END
               LOC:MA_ToDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))-1
           OF 'This Year'
               LOC:MA_FromDate = DATE(1,1,YEAR(GLO:TodaysDate))
               LOC:MA_ToDate = DATE(12,31,YEAR(GLO:TodaysDate))
           OF 'All'
               LOC:MA_FromDate = 0
               LOC:MA_ToDate = 0
       END
       !SELECT(?TimeRecordingBrowse)

SetDAT_DatePeriod       ROUTINE


      IF LOC:DAT_Period = 'Custom'
         UNHIDE(?CustomDAT_PeriodButton)
      ELSE
         HIDE(?CustomDAT_PeriodButton)
      END


      CASE LOC:DAT_Period
           OF 'Today'
               LOC:DAT_FromDate = GLO:TodaysDate
               LOC:DAT_ToDate = GLO:TodaysDate
           OF 'Yesterday'
               LOC:DAT_FromDate = GLO:TodaysDate-1
               LOC:DAT_ToDate = GLO:TodaysDate-1
           OF 'This Week'
               IF GLO:TodaysDate%7 = 0  ! IF SUNDAY
                  LOC:DAT_FromDate = GLO:TodaysDate - 6
               ELSE
                  LOC:DAT_FromDate = GLO:TodaysDate - GLO:TodaysDate%7 + 1
               END
               LOC:DAT_ToDate = LOC:DAT_FromDate + 6
           OF 'This Month'
               LOC:DAT_FromDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))
               IF MONTH(GLO:TodaysDate) = 12
                  LOC:DAT_ToDate = DATE(12,31,YEAR(GLO:TodaysDate))
               ELSE
                  LOC:DAT_ToDate = DATE(MONTH(GLO:TodaysDate)+1,1,YEAR(GLO:TodaysDate))-1
               END
           OF 'Last Month'
               IF MONTH(GLO:TodaysDate) = 1
                  LOC:DAT_FromDate = DATE(12,1,YEAR(GLO:TodaysDate)-1)
               ELSE
                  LOC:DAT_FromDate = DATE(MONTH(GLO:TodaysDate)-1,1,YEAR(GLO:TodaysDate))
               END
               LOC:DAT_ToDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))-1
           OF 'This Year'
               LOC:DAT_FromDate = DATE(1,1,YEAR(GLO:TodaysDate))
               LOC:DAT_ToDate = DATE(12,31,YEAR(GLO:TodaysDate))
           OF 'All'
               LOC:DAT_FromDate = 0
               LOC:DAT_ToDate = 0
       END



SetFNB_DatePeriod       ROUTINE


      IF LOC:FNB_Period = 'Custom'
         UNHIDE(?CustomFNB_PeriodButton)
      ELSE
         HIDE(?CustomFNB_PeriodButton)
      END


      CASE LOC:FNB_Period
           OF 'Today'
               LOC:FNB_FromDate = GLO:TodaysDate
               LOC:FNB_ToDate = GLO:TodaysDate
           OF 'Yesterday'
               LOC:FNB_FromDate = GLO:TodaysDate-1
               LOC:FNB_ToDate = GLO:TodaysDate-1
           OF 'This Week'
               IF GLO:TodaysDate%7 = 0  ! IF SUNDAY
                  LOC:FNB_FromDate = GLO:TodaysDate - 6
               ELSE
                  LOC:FNB_FromDate = GLO:TodaysDate - GLO:TodaysDate%7 + 1
               END
               LOC:FNB_ToDate = LOC:FNB_FromDate + 6
           OF 'This Month'
               LOC:FNB_FromDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))
               IF MONTH(GLO:TodaysDate) = 12
                  LOC:FNB_ToDate = DATE(12,31,YEAR(GLO:TodaysDate))
               ELSE
                  LOC:FNB_ToDate = DATE(MONTH(GLO:TodaysDate)+1,1,YEAR(GLO:TodaysDate))-1
               END
           OF 'Last Month'
               IF MONTH(GLO:TodaysDate) = 1
                  LOC:FNB_FromDate = DATE(12,1,YEAR(GLO:TodaysDate)-1)
               ELSE
                  LOC:FNB_FromDate = DATE(MONTH(GLO:TodaysDate)-1,1,YEAR(GLO:TodaysDate))
               END
               LOC:FNB_ToDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))-1
           OF 'This Year'
               LOC:FNB_FromDate = DATE(1,1,YEAR(GLO:TodaysDate))
               LOC:FNB_ToDate = DATE(12,31,YEAR(GLO:TodaysDate))
           OF 'All'
               LOC:FNB_FromDate = 0
               LOC:FNB_ToDate = 0
       END


SetSARS_DatePeriod       ROUTINE


      IF LOC:SARS_Period = 'Custom'
         UNHIDE(?CustomSARS_PeriodButton)
      ELSE
         HIDE(?CustomSARS_PeriodButton)
      END


      CASE LOC:SARS_Period
           OF 'Today'
               LOC:SARS_FromDate = GLO:TodaysDate
               LOC:SARS_ToDate = GLO:TodaysDate
           OF 'Yesterday'
               LOC:SARS_FromDate = GLO:TodaysDate-1
               LOC:SARS_ToDate = GLO:TodaysDate-1
           OF 'This Week'
               IF GLO:TodaysDate%7 = 0  ! IF SUNDAY
                  LOC:SARS_FromDate = GLO:TodaysDate - 6
               ELSE
                  LOC:SARS_FromDate = GLO:TodaysDate - GLO:TodaysDate%7 + 1
               END
               LOC:SARS_ToDate = LOC:SARS_FromDate + 6
           OF 'This Month'
               LOC:SARS_FromDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))
               IF MONTH(GLO:TodaysDate) = 12
                  LOC:SARS_ToDate = DATE(12,31,YEAR(GLO:TodaysDate))
               ELSE
                  LOC:SARS_ToDate = DATE(MONTH(GLO:TodaysDate)+1,1,YEAR(GLO:TodaysDate))-1
               END
           OF 'Last Month'
               IF MONTH(GLO:TodaysDate) = 1
                  LOC:SARS_FromDate = DATE(12,1,YEAR(GLO:TodaysDate)-1)
               ELSE
                  LOC:SARS_FromDate = DATE(MONTH(GLO:TodaysDate)-1,1,YEAR(GLO:TodaysDate))
               END
               LOC:SARS_ToDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))-1
           OF 'This Year'
               LOC:SARS_FromDate = DATE(1,1,YEAR(GLO:TodaysDate))
               LOC:SARS_ToDate = DATE(12,31,YEAR(GLO:TodaysDate))
           OF 'All'
               LOC:SARS_FromDate = 0
               LOC:SARS_ToDate = 0
       END

SetABSA_DatePeriod       ROUTINE


      IF LOC:ABSA_Period = 'Custom'
         UNHIDE(?CustomABSA_PeriodButton)
      ELSE
         HIDE(?CustomABSA_PeriodButton)
      END


      CASE LOC:ABSA_Period
           OF 'Today'
               LOC:ABSA_FromDate = GLO:TodaysDate
               LOC:ABSA_ToDate = GLO:TodaysDate
           OF 'Yesterday'
               LOC:ABSA_FromDate = GLO:TodaysDate-1
               LOC:ABSA_ToDate = GLO:TodaysDate-1
           OF 'This Week'
               IF GLO:TodaysDate%7 = 0  ! IF SUNDAY
                  LOC:ABSA_FromDate = GLO:TodaysDate - 6
               ELSE
                  LOC:ABSA_FromDate = GLO:TodaysDate - GLO:TodaysDate%7 + 1
               END
               LOC:ABSA_ToDate = LOC:ABSA_FromDate + 6
           OF 'This Month'
               LOC:ABSA_FromDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))
               IF MONTH(GLO:TodaysDate) = 12
                  LOC:ABSA_ToDate = DATE(12,31,YEAR(GLO:TodaysDate))
               ELSE
                  LOC:ABSA_ToDate = DATE(MONTH(GLO:TodaysDate)+1,1,YEAR(GLO:TodaysDate))-1
               END
           OF 'Last Month'
               IF MONTH(GLO:TodaysDate) = 1
                  LOC:ABSA_FromDate = DATE(12,1,YEAR(GLO:TodaysDate)-1)
               ELSE
                  LOC:ABSA_FromDate = DATE(MONTH(GLO:TodaysDate)-1,1,YEAR(GLO:TodaysDate))
               END
               LOC:ABSA_ToDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))-1
           OF 'This Year'
               LOC:ABSA_FromDate = DATE(1,1,YEAR(GLO:TodaysDate))
               LOC:ABSA_ToDate = DATE(12,31,YEAR(GLO:TodaysDate))
           OF 'All'
               LOC:ABSA_FromDate = 0
               LOC:ABSA_ToDate = 0
       END



BindFilteringVariables  ROUTINE

  BIND('LOC:DAT_FromDate',LOC:DAT_FromDate)
  BIND('LOC:FNB_FromDate',LOC:FNB_FromDate)
  BIND('LOC:ABSA_FromDate',LOC:ABSA_FromDate)


  BIND('LOC:CurrentMatterID',LOC:CurrentMatterID)

  BIND('LOC:FN_FromDate',LOC:FN_FromDate)
  BIND('LOC:FN_ToDate',LOC:FN_ToDate)
  BIND('GLO:FN_EmployeeID',GLO:FN_EmployeeID)
  BIND('GLO:FN_CostCentreID',GLO:FN_CostCentreID)
  BIND('GLO:MA_CostCentreID',GLO:MA_CostCentreID)
  BIND('GLO:FIL_EmployeeID',GLO:FIL_EmployeeID)

  BIND('LOC:FIL_FromDate',LOC:FIL_FromDate)
  BIND('LOC:FIL_ToDate',LOC:FIL_ToDate)

  BIND('LOC:TOD_FromDate',LOC:TOD_FromDate)
  BIND('LOC:TOD_ToDate',LOC:TOD_ToDate)
  BIND('GLO:TOD_EmployeeID',GLO:TOD_EmployeeID)

  BIND('LOC:MA_FromDate',LOC:MA_FromDate)
  BIND('LOC:MA_ToDate',LOC:MA_ToDate)
  BIND('GLO:MA_EmployeeID',GLO:MA_EmployeeID)
  BIND('LOC:MA_ActivityID',LOC:MA_ActivityID)


UnBindFilteringVariables  ROUTINE


  UNBIND('LOC:DAT_FromDate')
  UNBIND('LOC:FNB_FromDate')
  UNBIND('LOC:ABSA_FromDate')


  UNBIND('LOC:CurrentMatterID')

  UNBIND('LOC:FN_FromDate')
  UNBIND('LOC:FN_ToDate')
  UNBIND('GLO:FN_EmployeeID')
  UNBIND('GLO:FN_CostCentreID')
  UNBIND('GLO:MA_CostCentreID')
  UNBIND('GLO:FIL_EmployeeID')

  UNBIND('LOC:FIL_FromDate')
  UNBIND('LOC:FIL_ToDate')

  UNBIND('LOC:TOD_FromDate')
  UNBIND('LOC:TOD_ToDate')
  UNBIND('GLO:TOD_EmployeeID')

  UNBIND('LOC:MA_FromDate')
  UNBIND('LOC:MA_ToDate')
  UNBIND('GLO:MA_EmployeeID')
  UNBIND('LOC:MA_ActivityID')

FillCriticalStepQueue      Routine

  Free(TOD_CriticalStep:Queue)

  CLEAR(CRI:Record)
  SET(CRI:PrimaryKey,CRI:PrimaryKey)
  LOOP UNTIL Access:CriticalStep.Next()
       CRIQ:Description = CRI:Description
       CRIQ:RecordID = CRI:RecordID

       IF CRI:Description <> 'Reserved'
          ADD(TOD_CriticalStep:Queue,CRIQ:Description)
       END

  END

  CRIQ:Description = 'All'
  CRIQ:RecordID = -1
  ADD(TOD_CriticalStep:Queue,1)
  !FB701
  IF CEM:TOD_CriticalStep
    CRIQ:RecordID = CEM:TOD_CriticalStep
    Get(TOD_CriticalStep:Queue,CRIQ:RecordID)
    LOC:TOD_CriticalStepID = CRIQ:RecordID
    LOC:TOD_CriticalStep = CRIQ:Description
  Else
   LOC:TOD_CriticalStep = 'All' ! START ON ALL
   LOC:TOD_CriticalStepID = -1
  End




FillAG_Suite_DescriptionQueue      Routine

  Free(AG_Division:Queue)

  CLEAR(LAW_SUI:Record)
  SET(LAW_SUI:SuiteKey,LAW_SUI:SuiteKey)
  LOOP UNTIL Access:LAW_Suite.Next()
    If LAW_SUI:AG_institutionKref
      If LAW_SUI:TestFlag
        If Sub(CTL:FirmCode,1,4) = 'ACME'
          AGDQ:Description = LAW_SUI:Description
          AGDQ:SuiteId = LAW_SUI:SuiteId
          ADD(AG_Division:Queue,AGDQ:Description)
          LOC:AG_Suite_DescList = LOC:AG_Suite_DescList & '|' & AGDQ:Description
        End
      Else
        AGDQ:Description = LAW_SUI:Description
        AGDQ:SuiteId = LAW_SUI:SuiteId
        ADD(AG_Division:Queue,AGDQ:Description)
        LOC:AG_Suite_DescList = LOC:AG_Suite_DescList & '|' & AGDQ:Description
      End
    End
  END

  AGDQ:Description = 'All'
  AGDQ:SuiteId = -1
  ADD(AG_Division:Queue,1)

  IF CEM:Filter_AG_Suite
    AGDQ:SuiteID = CEM:Filter_AG_Suite
    Get(AG_Division:Queue,AGDQ:SuiteID)
    LOC:AG_Suite_Description = AGDQ:Description
  Else
    LOC:AG_Suite_Description = 'All' ! START ON ALL
    AGDQ:Description = LOC:AG_Suite_Description
    AGDQ:SuiteId = -1
  End

  If LOC:AG_Suite_Description <> 'All'
    AGDQ:Description = LOC:AG_Suite_Description
    Get(AG_Division:Queue,AGDQ:Description)
    If ErrorCode()
      LOC:AG_Suite_Description = 'All' ! START ON ALL
      AGDQ:Description = LOC:AG_Suite_Description
      AGDQ:SuiteId = -1
    End
  End
  SAV:LOC:AG_SuiteID = AGDQ:SuiteId
  LOC:AG_SuiteID = AGDQ:SuiteId

FillCostCentreQueue      Routine

  Free(FN_CostCentre:Queue)
  Free(MA_CostCentre:Queue)
  CLEAR(COS:Record)
  SET(COS:PrimaryKey,COS:PrimaryKey)
  LOOP UNTIL Access:CostCentre.Next()
       FNCCQ:Description = COS:Description
       FNCCQ:RecordID = COS:RecordID

       MACCQ:Description = COS:Description
       MACCQ:RecordID = COS:RecordID

       IF COS:Recordid = SAV:GlobalDefaultCostCentreID OR |
          GLO:SupervisorFlag OR |
          GLO:SecCostCentreOption = 1

          ADD(FN_CostCentre:Queue,FNCCQ:Description)
          ADD(MA_CostCentre:Queue,MACCQ:Description)

       END
  END

  FNCCQ:Description = 'All'
  FNCCQ:RecordID = -1
  ADD(FN_CostCentre:Queue,1)


  IF GLO:FN_CostCentreID = -1
     LOC:FN_CostCentre   = FNCCQ:Description
  ELSIF GLO:FN_CostCentreID > 0
     LOC:FN_CostCentre   = GetDescription('Cost Centre',GLO:FN_CostCentreID)
  ELSE
     LOC:FN_CostCentre   = FNCCQ:Description
     GLO:FN_CostCentreID = FNCCQ:RecordId
  END


  SAV:FN_CostCentreID = GLO:FN_CostCentreID


  MACCQ:Description = 'All'
  MACCQ:RecordID = -1
  ADD(MA_CostCentre:Queue,1)


  IF GLO:MA_CostCentreID = -1
     LOC:MA_CostCentre   = MACCQ:Description
  ELSIF GLO:MA_CostCentreID > 0
     LOC:MA_CostCentre   = GetDescription('Cost Centre',GLO:MA_CostCentreID)
  ELSE
     LOC:MA_CostCentre   = MACCQ:Description
     GLO:MA_CostCentreID = MACCQ:RecordId
  END


  SAV:MA_CostCentreID = GLO:MA_CostCentreID

  LOC:CostCentreDropDownCounter = RECORDS(FN_CostCentre:Queue)  ! USE THIS TO INCREASE THE DROP DOWN
  IF LOC:CostCentreDropDownCounter > 40 THEN LOC:CostCentreDropDownCounter = 40.



FillEmployeeQueues      Routine


  Free(FN_Employee:Queue)
  Free(FIL_Employee:Queue)
  Free(TOD_Employee:Queue)
  Free(MA_Employee:Queue)



  Free(MA_Activity:Queue)
  CLEAR(ACT:Record)
  SET(ACT:PrimaryKey,ACT:PrimaryKey)
  LOOP UNTIL Access:Activity.Next()
       ACTQ:Description = ACT:Description
       ACTQ:RecordID = ACT:RecordID
       ADD(MA_Activity:Queue,ACTQ:Description)
  END
  ACTQ:Description = 'All'
  ACTQ:RecordID = -1
  ADD(MA_Activity:Queue,1)

  IF GLO:MA_ActivityID = -1
     LOC:MA_Activity   = ACTQ:Description
     LOC:MA_ActivityID = ACTQ:RecordId
  ELSIF GLO:MA_ActivityID > 0
     LOC:MA_ActivityID = GLO:MA_ActivityID
     LOC:MA_Activity   = GetDescription('Activity',GLO:MA_ActivityID)
  ELSE
     LOC:MA_Activity   = ACTQ:Description
     LOC:MA_ActivityID = ACTQ:RecordId
  END

  GLO:MA_ActivityID = LOC:MA_ActivityID
  SAV:MA_ActivityID = LOC:MA_ActivityID


  LOOP X# = 1 TO RECORDS(GEMPQ2:EmployeeQueue2)

        Get(GEMPQ2:EmployeeQueue2,X#)


       IF GEMPQ2:SuspendedFlag THEN CYCLE.            ! DO NOT DISPLAY USERS WHO ARE SUSPENDED

       IF GEMPQ2:RecordID = CEM:RecordID              ! IF THIS USER IS THE LOGGED IN USER

          Do AddQueues

       ELSIF GLO:SupervisorFlag

          Do AddQueues

       ELSE

          EA:EmployeeAllowedID = CEM:RecordID
          EA:EmployeeGrantingID = GEMPQ2:RecordID
          If Access:EmpAllow.TryFetch(EA:PrimaryKey) Then Cycle.

          DO AddQueues

       END
  END



  IF GLO:WorkGroupFlag  ! THIS USER HAS A WORKGROUP
     FNQ:Name = 'My Workgroup'
     FNQ:RecordID = -999999
     ADD(FN_Employee:Queue,1)
     FILQ:Name = 'My Workgroup'
     FILQ:RecordID = -999999
     ADD(FIL_Employee:Queue,1)
     TODQ:Name = 'My Workgroup'
     TODQ:RecordID = -999999
     ADD(TOD_Employee:Queue,1)
     MAQ:Name = 'My Workgroup'
     MAQ:RecordID = -999999
     ADD(MA_Employee:Queue,1)
  END

  FNQ:Name = 'All'
  FNQ:RecordID = -1
  ADD(FN_Employee:Queue,1)
  FILQ:Name = 'All'
  FILQ:RecordID = -1
  ADD(FIL_Employee:Queue,1)
  TODQ:Name = 'All'
  TODQ:RecordID = -1
  ADD(TOD_Employee:Queue,1)
  MAQ:Name = 'All'
  MAQ:RecordID = -1
  ADD(MA_Employee:Queue,1)


  IF ~LOC:FN_Employee
      LOC:FN_Employee = 'All'
      GLO:FN_EmployeeID = -1
  END

  IF ~LOC:FIL_Employee
      LOC:FIL_Employee = 'All'
      GLO:FIL_EmployeeID = -1
  END

  IF ~LOC:TOD_Employee
      LOC:TOD_Employee = 'All'
      GLO:TOD_EmployeeID = -1
  END

  IF ~LOC:MA_Employee
      LOC:MA_Employee = 'All'
      GLO:MA_EmployeeID = -1
  END


  SAV:FIL_EmployeeID = GLO:FIL_EmployeeID
  SAV:FN_EmployeeID = GLO:FN_EmployeeID
  SAV:TOD_EmployeeID = GLO:TOD_EmployeeID
  SAV:MA_EmployeeID = GLO:MA_EmployeeID

  LOC:EmployeeDropDownCounter = RECORDS(FN_Employee:Queue)  ! USE THIS TO INCREASE THE DROP DOWN
  IF LOC:EmployeeDropDownCounter > 40 THEN LOC:EmployeeDropDownCounter = 40.


AddQueues       Routine

  FNQ:Name = GEMPQ2:Name
  FNQ:RecordID = GEMPQ2:RecordID
  ADD(FN_Employee:Queue,FNQ:Name)
  FILQ:Name = GEMPQ2:Name
  FILQ:RecordID = GEMPQ2:RecordID
  ADD(FIL_Employee:Queue,FILQ:Name)
  TODQ:Name = GEMPQ2:Name
  TODQ:RecordID = GEMPQ2:RecordID
  ADD(TOD_Employee:Queue,TODQ:Name)
  MAQ:Name = GEMPQ2:Name
  MAQ:RecordID = GEMPQ2:RecordID
  ADD(MA_Employee:Queue,MAQ:Name)

  ! FILTERED BY THIS LAST TIME SO SET THE DROP DOWN WITH THIS NAME

  IF GLO:FN_EmployeeID = -999999 AND GLO:WorkGroupFlag
     LOC:FN_Employee = 'My Workgroup'
  ELSIF GLO:FN_EmployeeID = GEMPQ2:RecordID   
     LOC:FN_Employee = GEMPQ2:Name         
  END

  IF GLO:FIL_EmployeeID = -999999 AND GLO:WorkGroupFlag
     LOC:FIL_Employee = 'My Workgroup'
  ELSIF GLO:FIL_EmployeeID = GEMPQ2:RecordID
     LOC:FIL_Employee = GEMPQ2:Name         
  END

  IF GLO:TOD_EmployeeID = -999999 AND GLO:WorkGroupFlag
     LOC:TOD_Employee = 'My Workgroup'
  ELSIF GLO:TOD_EmployeeID = GEMPQ2:RecordID
     LOC:TOD_Employee = GEMPQ2:Name         
  END

  IF GLO:MA_EmployeeID = -999999 AND GLO:WorkGroupFlag
     LOC:MA_Employee = 'My Workgroup'
  ELSIF GLO:MA_EmployeeID = GEMPQ2:RecordID
     LOC:MA_Employee = GEMPQ2:Name        
  END


MouseClickOnProgressIndicatorIcon ROUTINE
    IF LOC:ShowMatterIconsFlag = 0 THEN EXIT.

  IF  KEYCODE() = MouseLeft AND ?MattersBrowse{PROP:Visible}  |
  AND INRANGE(MOUSEX(), ?MattersBrowse{PROP:XPos}, ?MattersBrowse{PROP:XPos} + ?MattersBrowse{PROP:Width} - 1)  |
  AND INRANGE(MOUSEY(), ?MattersBrowse{PROP:YPos}, ?MattersBrowse{PROP:YPos} + ?MattersBrowse{PROP:Height}  |
                                     - CHOOSE(?MattersBrowse{PROP:HScroll} OR ?MattersBrowse{PROP:VCR},9,1))  |
  AND ?MattersBrowse{PROPLIST:MouseDownRow} > 0 AND ?MattersBrowse{PROPLIST:MouseDownZone} <> LISTZONE:Right  |
  AND  ?MattersBrowse{PROPLIST:MouseDownField} = 4

      BRW54.UpdateViewRecord
      
          IF MAT:ArchiveStatus

             IF MAT:ArchiveStatus = 1
                MESSAGE('This Matter will be archived after month end',MAT:FileRef & ' - ' & MAT:Description,'~Matter_Lock.ico')
             ELSIF MAT:ArchiveStatus = 2
                MESSAGE('This Matter has been archived.',MAT:FileRef & ' - ' & MAT:Description,'~Matter_Lock.ico')
             END

          ELSIF MAT:ConveyancingStatusFlag = 1 AND MAT:NTURequestDate ! NTU REQUEST SENT

             MESSAGE('NTU request sent on ' & CLIP(LEFT(FORMAT(MAT:NTURequestDate,@d17))),MAT:FileRef & ' - ' & MAT:Description,'~Large_Cross.ico')


          ELSIF MAT:ConveyancingStatusFlag = 2 AND MAT:NTUReceiveDate ! NTU RECEIVED

             MESSAGE('NTU instruction received on ' & CLIP(LEFT(FORMAT(MAT:NTUReceiveDate,@d17))),MAT:FileRef & ' - ' & MAT:Description,'~Large_Cross.ico')


          ELSIF MAT:ConveyancingStatusFlag = 3 AND MAT:CancelToReassignDate ! NTU RECEIVED

             MESSAGE('Cancel to re-assign instruction received on ' & CLIP(LEFT(FORMAT(MAT:CancelToReassignDate,@d17))),MAT:FileRef & ' - ' & MAT:Description,'~Large_Cross.ico')


          ELSE

             IF CEM:ProgressIndicatorFlag = 'C'
                PROPSQLNext('SELECT dbo.GetLastCriticalStep(' & MAT:RecordID & ')')
             ELSE
                PROPSQLNext('SELECT dbo.GetLastStage(' & MAT:RecordID & ')')
             END

             LOC:ProgressID = ROW:Counter

             IF LOC:ProgressID

                IF CEM:ProgressIndicatorFlag = 'C'
                   PROPSQLNext('SELECT ToDoNote.DateDone, ToDoNote.Description,0,0,0, CriticalStep.LargeIconFileName FROM ToDoNote' &|
                               ' JOIN ToDoItem ON ToDoNote.ToDoItemID = ToDoItem.RecordID ' &|
                               ' JOIN CriticalStep ON CriticalStep.RecordID = ToDoItem.CriticalStep ' &|
                               ' WHERE MatterID = ' & MAT:RecordID &|
                               ' AND ToDoNote.RecordID = ' & LOC:ProgressID)


                   MESSAGE(FORMAT(ROW:Counter,@d17) & ' - ' & ROW:Description,MAT:FileRef & ' - ' & MAT:Description,GetRoot(ROW:Description1))

                ELSE

                   PROPSQLNext('SELECT FileNote.Date, FileNote.Description,0,0,0,Stage.LargeIconFileName FROM FileNote' &|
                               ' JOIN Stage ON FileNote.StageID = Stage.RecordID ' &|
                               ' WHERE MatterID = ' & MAT:RecordID &|
                               ' AND FileNote.RecordID = ' & LOC:ProgressID)


                   MESSAGE(FORMAT(ROW:Counter,@d17) & ' - ' & ROW:Description,MAT:FileRef & ' - ' & MAT:Description,GetRoot(ROW:Description1))

                END

             ELSE

                IF MAT:DateInstructed
                   IF CEM:ProgressIndicatorFlag = 'C'
                      MESSAGE('This Matter was received on ' & CLIP(LEFT(FORMAT(MAT:DateInstructed,@d17))) & '.||No Critical Steps have been completed in the Reminders screen.|',MAT:FileRef & ' - ' & MAT:Description,'~Matter_New.ico')
                   ELSE
                      MESSAGE('This Matter was received on ' & CLIP(LEFT(FORMAT(MAT:DateInstructed,@d17))) & '.||No Stages have been inserted in the File Notes screen.|',MAT:FileRef & ' - ' & MAT:Description,'~Matter_New.ico')
                   END
                ELSE
                   IF CEM:ProgressIndicatorFlag = 'C'
                      MESSAGE('No Instruction Date could be found for this Matter and no Critical Steps have been completed in the Reminders screen.|',MAT:FileRef & ' - ' & MAT:Description,'~Matter_New.ico')
                   ELSE
                      MESSAGE('No Instruction Date could be found for this Matter and no Stage has been inserted in the File Notes screen.|',MAT:FileRef & ' - ' & MAT:Description,'~Matter_New.ico')
                   END
                END

             END

          END
      
 END


MouseClickOnGuaranteeIndicatorIcon ROUTINE


  IF LOC:ShowMatterIconsFlag = 0 OR LOC:GHUBLicensed = 0 OR DG:Type <> 'BON' THEN EXIT.

  IF  KEYCODE() = MouseLeft AND ?MattersBrowse{PROP:Visible}  |
  AND INRANGE(MOUSEX(), ?MattersBrowse{PROP:XPos}, ?MattersBrowse{PROP:XPos} + ?MattersBrowse{PROP:Width} - 1)  |
  AND INRANGE(MOUSEY(), ?MattersBrowse{PROP:YPos}, ?MattersBrowse{PROP:YPos} + ?MattersBrowse{PROP:Height}  |
                                     - CHOOSE(?MattersBrowse{PROP:HScroll} OR ?MattersBrowse{PROP:VCR},9,1))  |
  AND ?MattersBrowse{PROPLIST:MouseDownRow} > 0 AND ?MattersBrowse{PROPLIST:MouseDownZone} <> LISTZONE:Right  |
  AND ?MattersBrowse{PROPLIST:MouseDownField} = 3 

      BRW54.UpdateViewRecord
      PropSQLNext('Select SUM(CASE WHEN ISNULL(GuaranteeHubStatus,0) = 3 THEN  1 ELSE 0 END), <13,10> ' & |
                '        COUNT(1) from BondGuar <13,10> ' & |
                '        WHERE ISNULL(GuaranteeHubStatus,0) < 4 AND ISNULL(GuaranteeHubIdentity,'''') <> ''''  <13,10> ' & |
                '        AND MatterID = ' & MAT:RecordID)
        IF ~ROW:Description
            Message('This Matter has no Guarantees on it')
        ELSIF ROW:Counter = 1 AND ROW:Description = '1'
            Message('This Matter has 1 Guarantee that have been submitted to the Guarantee Hub and it has been authorised')
        ELSIF ROW:Counter <> 1 AND ROW:Description = '1'
            Message('This matter has 1 Guarantee that has been submitted to the Guarantee Hub and it has not been issued')
        ELSIF ROW:Counter = 1 AND ROW:Description <> '1'
            Message('This Matter has '&ROW:Description&' Guarantees that have been submitted to the Guarantee Hub and 1 has been issued')
        ELSE
            Message('This Matter has '&ROW:Description&' Guarantees that have been submitted to the Guarantee Hub and '&ROW:Counter&' have been authorised')
        END
 END



MouseClickOnMessageIndicatorIcon ROUTINE

  IF  KEYCODE() = MouseLeft AND ?MattersBrowse{PROP:Visible}  |
      AND INRANGE(MOUSEX(), ?MattersBrowse{PROP:XPos}, ?MattersBrowse{PROP:XPos} + ?MattersBrowse{PROP:Width} - 1)  |
      AND INRANGE(MOUSEY(), ?MattersBrowse{PROP:YPos}, ?MattersBrowse{PROP:YPos} + ?MattersBrowse{PROP:Height}  |
                                         - CHOOSE(?MattersBrowse{PROP:HScroll} OR ?MattersBrowse{PROP:VCR},9,1))  |
      AND ?MattersBrowse{PROPLIST:MouseDownRow} > 0 AND ?MattersBrowse{PROPLIST:MouseDownZone} <> LISTZONE:Right  |
      AND ?MattersBrowse{PROPLIST:MouseDownField} = 2

      BRW54.UpdateViewRecord


      IF MAT:MessageWaitingFlag

         PropSQL('UPDATE Matter SET MessageWaitingFlag = 0 WHERE RecordID = ' & MAT:RecordID)


         BRW54.PostNewSelection
         BRW54.ResetFromBuffer
         SELECT(?MattersBrowse,CHOICE(?MattersBrowse))


         IF MAT:FNBMatterState

            LOC:FNB_Matter = 'Current'
            LOC:FNB_Period = 'All'
            LOC:AG_Suite_Description = 'All'
            LOC:AG_SuiteID = -1
            SELECT(?FNBLinkBrowse)

         ELSIF MAT:ABSALinkFlag

            LOC:ABSA_Matter = 'Current'
            LOC:ABSA_Period = 'All'
            LOC:ABSA_DG_Code = 'All'
            LOC:ABSA_Direction = 'All'
            SELECT(?ABSALinkBrowse)


         ELSE

            PROPSQLNext('SELECT COUNT(1) FROM AG_MatterMessage WHERE MatterID = ' & MAT:RecordID)
            IF ROW:Counter
               LOC:FNB_Matter = 'Current'
               LOC:FNB_Period = 'All'
               LOC:AG_Suite_Description = 'All'
               LOC:AG_SuiteID = -1
               SELECT(?FNBLinkBrowse)
               EXIT
            END
            PROPSQLNext('SELECT COUNT(1) FROM SARS_MatterMessage WHERE MatterID = ' & MAT:RecordID)
            IF ROW:Counter
               LOC:SARS_Matter = 'Current'
               LOC:SARS_Period = 'All'
               SELECT(?SARSLinkBrowse)
               EXIT
            END
            PROPSQLNext('SELECT COUNT(1) FROM ABSA_MatterMessage WHERE MatterID = ' & MAT:RecordID)
            IF ROW:Counter
               LOC:ABSA_Matter = 'Current'
               LOC:ABSA_Period = 'All'
               LOC:ABSA_DG_Code = 'All'
               LOC:ABSA_Direction = 'All'
               SELECT(?ABSALinkBrowse)
               EXIT
            END

            !MESSAGE('The program is unable to display the Electronic Messages for this Matter (' & MAT:FileRef & ').||Unknown Electronic Message Type

         END
      END
  END


DisplayHeading  ROUTINE

  Case CHOICE(?CurrentTab)

  Of 1

    ?Change{PROP:DEFAULT} = False
    ?Change:6{PROP:DEFAULT} = False
    ?Change:2{PROP:DEFAULT} = False
    ?Change:5{PROP:DEFAULT} = False
    ?Change:3{PROP:DEFAULT} = True  ! Default ENTER Button
    ?Change:7{PROP:DEFAULT} = False
    ?Change:10{PROP:DEFAULT} = False


    LOC:WindowHeading = GetMatterFilterHeading()

    IF LOC:QBEFilterString THEN LOC:WindowHeading = '[QBE] ' & LOC:WindowHeading.


    GLO:FilterMessage = LOC:WindowHeading

    Select(?MattersBrowse)

    IF GLO:LowResolutionFlag
       SETFONT(?MattersTab,'MS Sans Serif',9,,FONT:Bold)
    ELSE
      SETFONT(?MattersTab,'MS Sans Serif',10,,FONT:Bold)
    END

    SETFONT(?FeeNotesTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FileNotesTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?RemindersTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?TimeRecordingTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?DataLinkTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FNBLinkTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?SARSTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?ABSALinkTab,'MS Sans Serif',9,,FONT:Regular)
    

  Of 2

    ?Change:6{PROP:DEFAULT} = False
    ?Change:2{PROP:DEFAULT} = False
    ?Change:5{PROP:DEFAULT} = False
    ?Change:3{PROP:DEFAULT} = False
    ?Change{PROP:DEFAULT} = True
    ?Change:7{PROP:DEFAULT} = False
    
    ?Change:10{PROP:DEFAULT} = False


    Case LOC:FN_Matter

    Of 'Current'

      LOC:WindowHeading = 'Fee Notes (' & LOC:CurrentMatterFileRef & ')'

    ELSE

      LOC:WindowHeading = 'Fee Notes (' & LOC:FN_Matter & ' Matters)'

    END


    IF LOC:QBEFilterFeeNoteString THEN LOC:WindowHeading = '[QBE] ' & LOC:WindowHeading.

    Select(?FeeNoteBrowse)

    SETFONT(?MattersTab,'MS Sans Serif',9,,FONT:Regular)

    IF GLO:LowResolutionFlag
       SETFONT(?FeeNotesTab,'MS Sans Serif',9,,FONT:Bold)
    ELSE
      SETFONT(?FeeNotesTab,'MS Sans Serif',10,,FONT:Bold)
    END


    SETFONT(?FileNotesTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?RemindersTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?TimeRecordingTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?DataLinkTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FNBLinkTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?SARSTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?ABSALinkTab,'MS Sans Serif',9,,FONT:Regular)
    



  Of 3

    ?Change{PROP:DEFAULT} = False
    ?Change:2{PROP:DEFAULT} = False
    ?Change:6{PROP:DEFAULT} = False
    ?Change:3{PROP:DEFAULT} = False
    ?Change:5{PROP:DEFAULT} = True
    ?Change:7{PROP:DEFAULT} = False
    
    ?Change:10{PROP:DEFAULT} = False
!    ?Change:12{PROP:DEFAULT} = False


    Case LOC:FIL_Matter
    Of 'Current'
        LOC:WindowHeading = 'File Notes (' & LOC:CurrentMatterFileRef & ')'
!        IF LOC:FIL:DisplayFilterString
!           LOC:WindowHeading = LOC:WindowHeading & ' [QBE: ' & LOC:FIL:DisplayFilterString & ']'
!        END

    ELSE
!       IF LOC:FIL:DisplayFilterString
!          LOC:WindowHeading = 'File Notes (QBE:' & LOC:FIL:DisplayFilterString & ')'
!       ELSE
          LOC:WindowHeading = 'File Notes (' & LOC:FIL_Matter & ' Matters)'
!       END
    .

    IF LOC:QBEFilterFileNoteString THEN LOC:WindowHeading = '[QBE] ' & LOC:WindowHeading.

    Select(?FileNoteBrowse)

    SETFONT(?MattersTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FeeNotesTab,'MS Sans Serif',9,,FONT:Regular)

    IF GLO:LowResolutionFlag
       SETFONT(?FileNotesTab,'MS Sans Serif',9,,FONT:Bold)
    ELSE
      SETFONT(?FileNotesTab,'MS Sans Serif',10,,FONT:Bold)
    END


    SETFONT(?RemindersTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?TimeRecordingTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?DataLinkTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FNBLinkTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?SARSTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?ABSALinkTab,'MS Sans Serif',9,,FONT:Regular)
    

  Of 4

    ?Change{PROP:DEFAULT} = False
    ?Change:5{PROP:DEFAULT} = False
    ?Change:6{PROP:DEFAULT} = False
    ?Change:3{PROP:DEFAULT} = False
    ?Change:2{PROP:DEFAULT} = True
    ?Change:7{PROP:DEFAULT} = False
    
    ?Change:10{PROP:DEFAULT} = False
!    ?Change:12{PROP:DEFAULT} = False

    Case LOC:TOD_Matter
    Of 'Current'
      LOC:WindowHeading = 'Reminders (' & LOC:CurrentMatterFileRef & ')'
    ELSE
      LOC:WindowHeading = 'Reminders (' & LOC:TOD_Matter & ' Matters)'
    .

    IF LOC:QBEFilterToDoNoteString THEN LOC:WindowHeading = '[QBE] ' & LOC:WindowHeading.

    Select(?ToDoNoteBrowse)

    SETFONT(?MattersTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FeeNotesTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FileNotesTab,'MS Sans Serif',9,,FONT:Regular)

    IF GLO:LowResolutionFlag
       SETFONT(?RemindersTab,'MS Sans Serif',9,,FONT:Bold)
    ELSE
      SETFONT(?RemindersTab,'MS Sans Serif',10,,FONT:Bold)
    END


    SETFONT(?TimeRecordingTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?DataLinkTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FNBLinkTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?SARSTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?ABSALinkTab,'MS Sans Serif',9,,FONT:Regular)
    


  Of 5

    ?Change{PROP:DEFAULT} = False
    ?Change:2{PROP:DEFAULT} = False
    ?Change:5{PROP:DEFAULT} = False
    ?Change:3{PROP:DEFAULT} = False
    ?Change:6{PROP:DEFAULT} = True
    ?Change:7{PROP:DEFAULT} = False
    
    ?Change:10{PROP:DEFAULT} = False
!    ?Change:12{PROP:DEFAULT} = False

    Case LOC:MA_Matter
    Of 'Current'
      LOC:WindowHeading = 'Time Records (' & LOC:CurrentMatterFileRef & ')'
    ELSE
      LOC:WindowHeading = 'Time Records (' & LOC:MA_Matter & ' Matters)'
    .

    IF LOC:QBEFilterMatActivString THEN LOC:WindowHeading = '[QBE] ' & LOC:WindowHeading.

    Select(?TimeRecordingBrowse)


    SETFONT(?MattersTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FeeNotesTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FileNotesTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?RemindersTab,'MS Sans Serif',9,,FONT:Regular)

    IF GLO:LowResolutionFlag
       SETFONT(?TimeRecordingTab,'MS Sans Serif',9,,FONT:Bold)
    ELSE
      SETFONT(?TimeRecordingTab,'MS Sans Serif',10,,FONT:Bold)
    END

    SETFONT(?DataLinkTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FNBLinkTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?SARSTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?ABSALinkTab,'MS Sans Serif',9,,FONT:Regular)
    

  Of 6   ! DATALink

    ?Change{PROP:DEFAULT} = False
    ?Change:2{PROP:DEFAULT} = False
    ?Change:5{PROP:DEFAULT} = False
    ?Change:3{PROP:DEFAULT} = False
    ?Change:6{PROP:DEFAULT} = False
    ?Change:7{PROP:DEFAULT} = False
    
    ?Change:10{PROP:DEFAULT} = False
!    ?Change:12{PROP:DEFAULT} = False

    Case LOC:DAT_Matter
    Of 'Current'
!      IF LOC:CurrentMatterLawRef
!         LOC:WindowHeading = 'DataLink Messages (' & LOC:CurrentMatterFileRef & ') [' & LOC:CurrentMatterLawRef & ']'
!      ELSE
         LOC:WindowHeading = 'DataLink Messages (' & LOC:CurrentMatterFileRef & ')'
!      END
    ELSE
      LOC:WindowHeading = 'DataLink Messages (' & LOC:DAT_Matter & ' Matters)'
    .

    Select(?LawMatterMessageBrowse)

    SETFONT(?MattersTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FeeNotesTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FileNotesTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?RemindersTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?TimeRecordingTab,'MS Sans Serif',9,,FONT:Regular)

    IF GLO:LowResolutionFlag
       SETFONT(?DataLinkTab,'MS Sans Serif',9,,FONT:Bold)
    ELSE
      SETFONT(?DataLinkTab,'MS Sans Serif',10,,FONT:Bold)
    END


    SETFONT(?FNBLinkTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?SARSTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?ABSALinkTab,'MS Sans Serif',9,,FONT:Regular)
    


  Of 7      ! ABSALink

    ?Change{PROP:DEFAULT} = False
    ?Change:2{PROP:DEFAULT} = False
    ?Change:5{PROP:DEFAULT} = False
    ?Change:3{PROP:DEFAULT} = False
    ?Change:6{PROP:DEFAULT} = False
    ?Change:7{PROP:DEFAULT} = False
    ?Change:10{PROP:DEFAULT} = True

    Case LOC:ABSA_Matter
    Of 'Current'
      LOC:WindowHeading = 'Bond Centre Messages (' & LOC:CurrentMatterFileRef & ')'
    ELSE
      LOC:WindowHeading = 'Bond Centre Messages (' & LOC:ABSA_Matter & ' Matters)'
    .
    ! 02/04/2015 Sameer: Placeholder for ensuring Online Docs button has correct tooltip (if the other code doesn't work)

    Select(?ABSALinkBrowse)

    SETFONT(?MattersTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FeeNotesTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FileNotesTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?RemindersTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?TimeRecordingTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?DataLinkTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FNBLinkTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?SARSTab,'MS Sans Serif',9,,FONT:Regular)

    IF GLO:LowResolutionFlag
       SETFONT(?ABSALinkTab,'MS Sans Serif',9,,FONT:Bold)
    ELSE
      SETFONT(?ABSALinkTab,'MS Sans Serif',10,,FONT:Bold)
    END



  Of 8      ! FNBLink

    ?Change{PROP:DEFAULT} = False
    ?Change:2{PROP:DEFAULT} = False
    ?Change:5{PROP:DEFAULT} = False
    ?Change:3{PROP:DEFAULT} = False
    ?Change:6{PROP:DEFAULT} = False
    ?Change:7{PROP:DEFAULT} = True
    ?Change:10{PROP:DEFAULT} = False

    Case LOC:FNB_Matter
    Of 'Current'
        LOC:WindowHeading = 'Gateway Messages (' & LOC:CurrentMatterFileRef & ')'
    ELSE
      LOC:WindowHeading = 'Gateway Messages (' & LOC:FNB_Matter & ' Matters)'
    .


    Select(?FNBLinkBrowse)

    SETFONT(?MattersTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FeeNotesTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FileNotesTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?RemindersTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?TimeRecordingTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?DataLinkTab,'MS Sans Serif',9,,FONT:Regular)

    IF GLO:LowResolutionFlag
       SETFONT(?FNBLinkTab,'MS Sans Serif',9,,FONT:Bold)
    ELSE
      SETFONT(?FNBLinkTab,'MS Sans Serif',10,,FONT:Bold)
    END


    SETFONT(?SARSTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?ABSALinkTab,'MS Sans Serif',9,,FONT:Regular)
    


  Of 9     ! SARSLink

    ?Change{PROP:DEFAULT} = False
    ?Change:2{PROP:DEFAULT} = False
    ?Change:5{PROP:DEFAULT} = False
    ?Change:3{PROP:DEFAULT} = False
    ?Change:6{PROP:DEFAULT} = False
    ?Change:7{PROP:DEFAULT} = False
    
    ?Change:10{PROP:DEFAULT} = False

    Case LOC:SARS_Matter
    Of 'Current'
        LOC:WindowHeading = 'SARS Matters (' & LOC:CurrentMatterFileRef & ')'
    ELSE
      LOC:WindowHeading = 'SARS Matters (' & LOC:SARS_Matter & ' Matters)'
    .


    Select(?SARSLinkBrowse)

    SETFONT(?MattersTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FeeNotesTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FileNotesTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?RemindersTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?TimeRecordingTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?DataLinkTab,'MS Sans Serif',9,,FONT:Regular)
    SETFONT(?FNBLinkTab,'MS Sans Serif',9,,FONT:Regular)

    IF GLO:LowResolutionFlag
       SETFONT(?SARSTab,'MS Sans Serif',9,,FONT:Bold)
    ELSE
      SETFONT(?SARSTab,'MS Sans Serif',10,,FONT:Bold)
    END


    SETFONT(?ABSALinkTab,'MS Sans Serif',9,,FONT:Regular)
    
  .

  QuickWindow{PROP:Text} = LOC:WindowHeading

AddDocMergeQueue    ROUTINE

      PropSQL('DELETE DocMergeQueue WHERE EmployeeID = ' & CEM:RecordID)

      CLEAR(DMQ:Record)
      DMQ:Description = DOC:Description
      DMQ:EmployeeID = CEM:RecordID
      DMQ:DocumentID = DOC:RecordID
      DMQ:DocCategoryID = DOC:DocCategoryID
      DMQ:Copies = DOC:PrintCopies
      IF ~DMQ:Copies THEN DMQ:Copies = 1.


      IF ~Access:DocMergeQueue.Insert()

          PropSQLNext('SELECT MAX(RecordID) FROM DocMergeQueue WHERE EmployeeID = ' & CEM:RecordID)


          IF ~DMQ:RecordID 
              DMQ:RecordID = ROW:Counter
          END

         SetTag:Ptrm(TAG:DocMergeQueue,DMQ:RecordID)


     END


UpdateBillingRate         ROUTINE

   If Access:BillingRate.TryFetch(BR:PrimaryKey) Then Exit.

   OPEN(ProgressWindow)
   ProgressWindow{PROP:Text} = 'Update Billing Rate'
   ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:MatActiv)
   DISPLAY

   If ~CntTag:PtrM(TAG:MatActiv)
     SetTag:PtrM(TAG:MatActiv,MA:RecordID) ! If User didn't Tag Then Tag Current Activity
   End

   Clear(MA:Record)
   MA:RecordID = FstTag:PtrM(TAG:MatActiv)
   Loop
     If ~Access:MatActiv.TryFetch(MA:PrimaryKey)
       MA:BillingRateID = BR:RecordID

       PropSQLNext('SELECT BillableFlag FROM Activity Where RecordID = ' & MA:ActivityID)
       MA:BillableFlag = ROW:Counter
       IF MA:BillableFlag
         MA:RatePerHour = GetRatePerHour(MA:EmployeeID,MA:ActivityID,BR:RecordID,MA:MatterID)
         MA:Amount = GetTimedAmount(MA:Minutes,MA:RatePerHour,MA:EmployeeID)
         MA:BillableAmount = MA:Amount
       Else
         MA:Amount = 0
         MA:BillableAmount = 0
       End
       If Access:MatActiv.Update()
         Message('Error Updating MatActive File|Error:' & Error(),'Updating Rate',ICON:Exclamation)
       End

       IF MA:FeeNoteID

         FN:RecordID = MA:FeeNoteID
         Access:FeeNote.Fetch(FN:PrimaryKey)

         If FN:RecordID

            AddFeeNoteFromMA(ChangeRecord)

            DO RefreshFeeNoteBrowse

         End

       End

       ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
       Display
     End
     MA:RecordID = NxtTag:PtrM(TAG:MatActiv)
     If ~MA:RecordID Then Break.
   End

   Close(ProgressWindow)

   DO RefreshFeeNoteBrowse
   DO RefreshMatActivBrowse

CombineTaggedFees                      ROUTINE

    CLEAR(MatterQueue)
    FREE(MatterQueue)
    CLEAR(FN:Record)
    FN:RecordID = FstTag:PtrM(Tag:FeeNote)                ! SET TO THE FIRST TAGGED FeeNote
    LOOP 
         IF ~Access:FeeNote.TryFetch(FN:PrimaryKey)

             MQ:RecordID = FN:MatterID
             GET(MatterQueue,MQ:RecordID)
             IF ERROR()
                ADD(MatterQueue,MQ:RecordID)
             END
         END
         FN:RecordID = NxtTag:PtrM(Tag:FeeNote)                ! SET TO NEXT FeeNote
         IF ~FN:RecordID THEN BREAK.
    END

    LOOP X# = 1 TO RECORDS(MatterQueue)

         Get(MatterQueue,X#)
         MAT:RecordID = MQ:RecordID

         IF ~Access:Matter.TryFetch(MAT:PrimaryKey)

             IF RestrictedMatter(MAT:RecordID,0) THEN CYCLE.
             IF ViewOnlyMatter(MAT:RecordID,0) THEN CYCLE.

             CombineFees(MAT:RecordID)
         END
    END


RefreshCurrentBrowse    ROUTINE

      CASE Choice(?CurrentTab)
      
      OF 1

         DO SetMatterOptFilterButton


         IF ~(SAV:SortKey54 = LOC:SortKey54)
              SAV:SortKey54 = LOC:SortKey54
              DO ChangeQuickSearchPrompt

              BRW54.ResetSort(1)

              SELECT(?MattersBrowse)


         END


         GLO:CurrentMatterID = LOC:CurrentMatterID      ! CAN BE USED BY PROCEDURES IN OTHER THREADS TO PRIME "SELECT MATTER" (E.G. PROCESSEVENT

         ?STDOnlineDocumentMatterTab{PROP:Tooltip} = 'Assemble the online KODA documents for ' & MAT:FileRef

      OF 2

         DO SetFeeNoteOptFilterButton


         IF ~(SAV:FN_FromDate = LOC:FN_FromDate) |
         Or ~(SAV:FN_ToDate = LOC:FN_ToDate) |
         Or ~(SAV:FN_Period = LOC:FN_Period) |
         Or ~(SAV:FN_EmployeeID = GLO:FN_EmployeeID) |
         Or ~(SAV:FN_CostCentreID = GLO:FN_CostCentreID) |
         Or ~(SAV:FN_Matter = LOC:FN_Matter) |
         Or ~(SAV:LOC:FN_Type = LOC:FN_Type) |
         Or ~(SAV:PostedOption = LOC:PostedOption) |
         Or ~(SAV:FN_CurrentMatterID = LOC:CurrentMatterID) AND LOC:FN_Matter = 'Current' |
         Or LOC:FN_Matter = 'Filtered' AND ~(SAV:LOC:FilterMatterString = LOC:FilterMatterString) |
         Or LOC:FN_Matter = 'Tagged' AND ~(SAV:LOC:TaggedMatterList = LOC:TaggedMatterList)

              DO RefreshFeeNoteBrowse

              ?FeeNoteBrowse{PROP:Selected} = 1

              Do DisplayHeading

         END
      
         SAV:FN_Period = LOC:FN_Period
         SAV:FN_FromDate = LOC:FN_FromDate
         SAV:FN_ToDate = LOC:FN_ToDate
         SAV:FN_EmployeeID = GLO:FN_EmployeeID
         SAV:FN_CostCentreID = GLO:FN_CostCentreID
         SAV:FN_Matter = LOC:FN_Matter
         SAV:PostedOption = LOC:PostedOption
         SAV:FN_CurrentMatterID = LOC:CurrentMatterID
         SAV:LOC:FilterMatterString = LOC:FilterMatterString
         SAV:LOC:TaggedMatterList = LOC:TaggedMatterList
         SAV:LOC:FN_Type = LOC:FN_Type


      OF 3


         DO SetFileNoteOptFilterButton

         IF ~(SAV:FIL_FromDate = LOC:FIL_FromDate) |
         Or ~(SAV:FIL_ToDate = LOC:FIL_ToDate) |
         Or ~(SAV:FIL_Period = LOC:FIL_Period) |
         Or ~(SAV:FIL_CurrentMatterID = LOC:CurrentMatterID) AND LOC:FIL_Matter = 'Current' |
         Or LOC:FIL_Matter = 'Filtered' AND ~(SAV:LOC:FilterMatterString = LOC:FilterMatterString) |
         Or LOC:FIL_Matter = 'Tagged' AND ~(SAV:LOC:TaggedMatterList = LOC:TaggedMatterList) |
         Or ~(SAV:FIL_Status = LOC:FIL_Status) |
         Or ~(SAV:FIL_Internal = LOC:FIL_Internal) |
         Or ~(SAV:FIL_EmployeeID = GLO:FIL_EmployeeID) |
         Or ~(SAV:FIL_Matter = LOC:FIL_Matter)

             DO RefreshFileNoteBrowse
             ?FileNoteBrowse{PROP:Selected} = 1
             Do DisplayHeading

         END
         SAV:FIL_Period = LOC:FIL_Period
         SAV:FIL_FromDate = LOC:FIL_FromDate
         SAV:FIL_ToDate = LOC:FIL_ToDate
         SAV:FIL_Matter = LOC:FIL_Matter
         SAV:FIL_Status = LOC:FIL_Status
         SAV:FIL_Internal = LOC:FIL_Internal
         SAV:FIL_EmployeeID = GLO:FIL_EmployeeID
         SAV:FIL_CurrentMatterID = LOC:CurrentMatterID
         SAV:LOC:FilterMatterString = LOC:FilterMatterString
         SAV:LOC:TaggedMatterList = LOC:TaggedMatterList



      OF 4

         DO SetToDoNoteOptFilterButton

         IF ~(SAV:TOD_FromDate = LOC:TOD_FromDate) |
         Or ~(SAV:TOD_ToDate = LOC:TOD_ToDate) |
         Or ~(SAV:TOD_Period = LOC:TOD_Period) |
         Or ~(SAV:TOD_EmployeeID = GLO:TOD_EmployeeID) |
         Or ~(SAV:TOD_CurrentMatterID = LOC:CurrentMatterID) AND LOC:TOD_Matter = 'Current' |
         Or LOC:TOD_Matter = 'Filtered' AND ~(SAV:LOC:FilterMatterString = LOC:FilterMatterString) |
         Or LOC:TOD_Matter = 'Tagged' AND ~(SAV:LOC:TaggedMatterList = LOC:TaggedMatterList) |
         Or ~(SAV:TOD_Status = LOC:TOD_Status) |
         Or ~(SAV:TOD_CriticalStepID = LOC:TOD_CriticalStepID) |
         Or ~(SAV:TOD_Matter = LOC:TOD_Matter)


            DO RefreshToDoNoteBrowse

            ?ToDoNoteBrowse{PROP:Selected} = 1
            Do DisplayHeading


         END
      
        SAV:TOD_Period = LOC:TOD_Period
        SAV:TOD_FromDate = LOC:TOD_FromDate
        SAV:TOD_ToDate = LOC:TOD_ToDate
        SAV:TOD_Matter = LOC:TOD_Matter
        SAV:TOD_EmployeeID = GLO:TOD_EmployeeID
        SAV:TOD_Status = LOC:TOD_Status
        SAV:TOD_CriticalStepID = LOC:TOD_CriticalStepID
        SAV:TOD_CurrentMatterID = LOC:CurrentMatterID
        SAV:LOC:FilterMatterString = LOC:FilterMatterString
        SAV:LOC:TaggedMatterList = LOC:TaggedMatterList



      OF 5


         DO SetMatActivOptFilterButton

         IF ~(SAV:MA_FromDate = LOC:MA_FromDate) |
         Or ~(SAV:MA_ToDate = LOC:MA_ToDate) |
         Or ~(SAV:MA_Period = LOC:MA_Period) |
         Or ~(SAV:MA_EmployeeID = GLO:MA_EmployeeID) |
         Or ~(SAV:MA_CostCentreID = GLO:MA_CostCentreID) |
         Or ~(SAV:MA_ActivityID = LOC:MA_ActivityID) |
         Or ~(SAV:MA_CurrentMatterID = LOC:CurrentMatterID) AND LOC:MA_Matter = 'Current' |
         Or LOC:MA_Matter = 'Filtered' AND ~(SAV:LOC:FilterMatterString = LOC:FilterMatterString) |
         Or LOC:MA_Matter = 'Tagged' AND ~(SAV:LOC:TaggedMatterList = LOC:TaggedMatterList) |
         Or ~(SAV:MA_BilledFlag = LOC:MA_BilledFlag) |
         Or ~(SAV:MA_Matter = LOC:MA_Matter)



            DO RefreshMatActivBrowse
            ?TimeRecordingBrowse{PROP:Selected} = 1
            Do DisplayHeading

         END
      
        SAV:MA_Period = LOC:MA_Period
        SAV:MA_FromDate = LOC:MA_FromDate
        SAV:MA_ToDate = LOC:MA_ToDate
        SAV:MA_Matter = LOC:MA_Matter
        SAV:MA_EmployeeID = GLO:MA_EmployeeID
        SAV:MA_CostCentreID = GLO:MA_CostCentreID
        SAV:MA_ActivityID = LOC:MA_ActivityID
        SAV:MA_BilledFlag = LOC:MA_BilledFlag
        SAV:MA_CurrentMatterID = LOC:CurrentMatterID
        SAV:LOC:FilterMatterString = LOC:FilterMatterString
        SAV:LOC:TaggedMatterList = LOC:TaggedMatterList


      OF 6
      
         IF ~(SAV:DAT_FromDate = LOC:DAT_FromDate) |
         Or ~(SAV:DAT_ToDate = LOC:DAT_ToDate) |
         Or ~(SAV:DAT_Period = LOC:DAT_Period) |
         Or ~(SAV:DAT_CurrentMatterID = LOC:CurrentMatterID) AND LOC:DAT_Matter = 'Current' |
         Or LOC:DAT_Matter = 'Filtered' AND ~(SAV:LOC:FilterMatterString = LOC:FilterMatterString) |
         Or LOC:DAT_Matter = 'Tagged' AND ~(SAV:LOC:TaggedMatterList = LOC:TaggedMatterList)  |
         Or ~(SAV:DAT_Matter = LOC:DAT_Matter)

             DO RefreshDataLinkBrowse

             ?LawMatterMessageBrowse{PROP:Selected} = 1
             Do DisplayHeading

         END
         SAV:DAT_Period = LOC:DAT_Period
         SAV:DAT_FromDate = LOC:DAT_FromDate
         SAV:DAT_ToDate = LOC:DAT_ToDate
         SAV:DAT_Matter = LOC:DAT_Matter
         SAV:DAT_CurrentMatterID = LOC:CurrentMatterID
         SAV:LOC:FilterMatterString = LOC:FilterMatterString
         SAV:LOC:TaggedMatterList = LOC:TaggedMatterList


      OF 7
      
         IF ~(SAV:ABSA_FromDate = LOC:ABSA_FromDate) |
         Or ~(SAV:ABSA_ToDate = LOC:ABSA_ToDate) |
         Or ~(SAV:ABSA_Period = LOC:ABSA_Period) |
         Or ~(SAV:ABSA_DG_Code = LOC:ABSA_DG_Code) |
         Or ~(SAV:ABSA_Direction = LOC:ABSA_Direction) |
         Or ~(SAV:ABSA_CurrentMatterID = LOC:CurrentMatterID) AND LOC:ABSA_Matter = 'Current' |
         Or LOC:ABSA_Matter = 'Filtered' AND ~(SAV:LOC:FilterMatterString = LOC:FilterMatterString) |
         Or LOC:ABSA_Matter = 'Tagged' AND ~(SAV:LOC:TaggedMatterList = LOC:TaggedMatterList)  |
         Or ~(SAV:ABSA_Matter = LOC:ABSA_Matter)


             !DO MakeFilterABSALinkString

             ! 30/03/2015 Sameer: We can now assemble ABSA KODA documents, so comment this out
             !IF LOC:ABSA_DG_Code = 'ABSA'
             !   DISABLE(?STDOnlineDocument)
             !ELSE
             !   ENABLE(?STDOnlineDocument)
             !END

             ! 30/03/2015 Sameer: Change the KODA button tooltip depending on DG:Code (maybe not LOC:ABSA_DG_Code?)
!             CASE DG:Code
!
!             OF 'STD'
!
!               ?STDOnlineDocument{PROP:Tooltip} = 'Assemble the online Standard Bank documents'
!
!             OF 'ABSA'
!
!               ?STDOnlineDocument{PROP:Tooltip} = 'Assemble the online ABSA documents'
!
!             OF 'NED'
!
!               ?STDOnlineDocument{PROP:Tooltip} = 'Assemble the online Nedbank documents'
!
!             END


             DO RefreshABSALinkBrowse

             ?ABSALinkBrowse{PROP:Selected} = 1
             Do DisplayHeading

         END
         SAV:ABSA_Matter = LOC:ABSA_Matter
         SAV:ABSA_Period = LOC:ABSA_Period
         SAV:ABSA_DG_Code = LOC:ABSA_DG_Code
         SAV:ABSA_Direction = LOC:ABSA_Direction
         SAV:ABSA_FromDate = LOC:ABSA_FromDate
         SAV:ABSA_ToDate = LOC:ABSA_ToDate
         SAV:ABSA_CurrentMatterID = LOC:CurrentMatterID
         SAV:LOC:FilterMatterString = LOC:FilterMatterString
         SAV:LOC:TaggedMatterList = LOC:TaggedMatterList

         ! 02/04/2015 Sameer: Change the KODA buttons tooltip to show the current matter FileRef
         ?STDOnlineDocument{PROP:Tooltip} = 'Assemble the online KODA documents for ' & MAT:FileRef
         ?STDOnlineDocumentMatterTab{PROP:Tooltip} = 'Assemble the online KODA documents for ' & MAT:FileRef

      OF 8
      
         IF ~(SAV:FNB_FromDate = LOC:FNB_FromDate) |
         Or ~(SAV:FNB_ToDate = LOC:FNB_ToDate) |
         Or ~(SAV:FNB_Period = LOC:FNB_Period) |
         Or ~(SAV:FNB_CurrentMatterID = LOC:CurrentMatterID) AND LOC:FNB_Matter = 'Current' |
         Or LOC:FNB_Matter = 'Filtered' AND ~(SAV:LOC:FilterMatterString = LOC:FilterMatterString) |
         Or LOC:FNB_Matter = 'Tagged' AND ~(SAV:LOC:TaggedMatterList = LOC:TaggedMatterList) |
         Or ~(SAV:FNB_Matter = LOC:FNB_Matter) |
         Or ~(SAV:LOC:AG_SuiteID = LOC:AG_SuiteID)

             DO MakeFilterFNBLinkString

             DO RefreshFNBLinkBrowse

             ?FNBLinkBrowse{PROP:Selected} = 1
             Do DisplayHeading

         END
         SAV:FNB_Period = LOC:FNB_Period
         SAV:FNB_FromDate = LOC:FNB_FromDate
         SAV:FNB_ToDate = LOC:FNB_ToDate
         SAV:FNB_Matter = LOC:FNB_Matter
         SAV:LOC:AG_SuiteID = LOC:AG_SuiteID
         SAV:FNB_CurrentMatterID = LOC:CurrentMatterID
         SAV:LOC:FilterMatterString = LOC:FilterMatterString
         SAV:LOC:TaggedMatterList = LOC:TaggedMatterList



      OF 9



         IF ~(SAV:SARS_FromDate = LOC:SARS_FromDate) |
         Or ~(SAV:SARS_ToDate = LOC:SARS_ToDate) |
         Or ~(SAV:SARS_Period = LOC:SARS_Period) |
         Or ~(SAV:SARS_CurrentMatterID = LOC:CurrentMatterID) AND LOC:SARS_Matter = 'Current' |
         Or LOC:SARS_Matter = 'Filtered' AND ~(SAV:LOC:FilterMatterString = LOC:FilterMatterString) |
         Or LOC:SARS_Matter = 'Tagged' AND ~(SAV:LOC:TaggedMatterList = LOC:TaggedMatterList) |
         Or ~(SAV:SARS_Matter = LOC:SARS_Matter)

             DO MakeFilterSARSLinkString

             DO RefreshSARSLinkBrowse

             ?SARSLinkBrowse{PROP:Selected} = 1
             Do DisplayHeading

         END
         SAV:SARS_Period = LOC:SARS_Period
         SAV:SARS_FromDate = LOC:SARS_FromDate
         SAV:SARS_ToDate = LOC:SARS_ToDate
         SAV:SARS_Matter = LOC:SARS_Matter
         SAV:SARS_CurrentMatterID = LOC:CurrentMatterID
         SAV:LOC:FilterMatterString = LOC:FilterMatterString
         SAV:LOC:TaggedMatterList = LOC:TaggedMatterList



      END


SARSRunProgram        Routine

  If ~LOC:SARSSelection Then Exit.

  SMM:EmployeeId = CEM:RecordID
  Case LOC:SARSSelection
  Of 'Register'
    Do SARSTransferDutyExe
  Of 'RequestTDStatus_All'
    Do SARSTransferDutyExe
  Else
    Clear(SMM:Record)
    SMM:MatterID = MAT:RecordID
    SMM:Date = Today()
    SMM:Time = Clock()
    SMM:EmployeeId = CEM:RecordID
    Case LOC:SARSSelection
    Of 'SubmitTD'
      SMM:Description = 'Submit Transfer Duty'
    Of 'RequestCorrespondenceTD'
      SMM:Description = 'Request Correspondence'
    Of 'RequestTDStatus'
      SMM:Description = 'Request Status'
    Of 'SendMessageToSARS'
      SMM:Description = 'Send a Message To SARS'
    End
    SMM:TD_ReferenceNumber = '0'
    SMM:Status = 'Failed'
    SMM:Status = 'An unexpected error occurred, please try again.'
    IF Access:SARS_MatterMessage.Insert()
      MESSAGE('The SARS_MatterMessage Could not be created.||Error: ' & ERRORCODE() & ', ' & ERROR(),'Did not run SARSTransferDuty.exe',ICON:Exclamation)
    Else
      PropSQLNext('Select RecordId From SARS_MatterMessage Where MatterId = ' & SMM:MatterID & ' And Date = ' & SMM:Date & ' And Time = ' & SMM:Time & ' And EmployeeId = ' & SMM:EmployeeId & ' And Description = ''' & SMM:Description & '''')
      SMM:RecordId = ROW:Counter

  !          Message('1 SMM:RecordID='&SMM:RecordID&'|SMM:MatterID='&SMM:MatterID&'|SMM:Description='& Replace(SMM:Description,' ',''))

      Do SARSTransferDutyExe

  ! ******************  ADD FILENOTE **************************

      CLEAR(FIL:Record)

      FIL:Date = GLO:TodaysDate
      FIL:Time = CLOCK()
      FIL:Description = 'Message Sent: ' & SMM:Description
      FIL:MatterID   = SMM:MatterID
      FIL:EmployeeID = SMM:EmployeeId
!      FIL:InternalFlag = CEM:FileNotesInternalFlag
      FIL:InternalFlag = 1          ! Rick Said I must change this

      IF Access:FileNote.Insert()
        MESSAGE('The File Note Could not be created.||Error: ' & ERRORCODE() & ', ' & ERROR(),'Did not run SARSTransferDuty.exe',ICON:Exclamation)
      END
    End
  End

  BRW33.ApplyFilter
  BRW33.ResetFromBuffer

SARSTransferDutyExe         Routine

  IF CheckIFDotNetInstalled()
    IF EXISTS('SARSTransferDuty.exe')
      RUN('SARSTransferDuty.exe ' & SMM:RecordId & ' ' & SMM:MatterID & ' ' & SMM:EmployeeId & ' "' & Replace(LOC:SARSSelection,' ','') & '"', 1)
      If ErrorCode()
        Message(Error() & '||Error running program SARSTransferDuty.exe||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
      End
    Else
      Message('SARSTransferDuty.exe Not Found||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
    End
  END




BRW2::SequencedMoveUp ROUTINE
  MS::MoveType=1
  DO BRW2::SequencedMove

BRW2::SequencedMoveDown ROUTINE
  MS::MoveType=2                                      ! "Up" to the user is "down" sequentially
  DO BRW2::SequencedMove

BRW2::SequencedMoveBegin ROUTINE
  MS::MoveType=3
  DO BRW2::SequencedMove

BRW2::SequencedMoveEnd ROUTINE
  MS::MoveType=4
  DO BRW2::SequencedMove

BRW2::SequencedMove ROUTINE
  !--------------------- Initialization
  MS::OrigSequence=FN:Sorter                          ! Save original sequence
  !--------------------- End:  Initialization
  !--------------------- Test if we can move
  DO BRW2::MS::SetToOriginalRecord
  DO BRW2::MS::GetNextSequencedRecord                 ! Try to get next record
  IF MS::OutOfRange                                   ! If nothing to swap with,
     DO BRW2::MS:CleanUp                              ! quietly exit
     EXIT                                             ! No movement possible
  .
  MS::TargetSequence=FN:Sorter                        ! Save target sequence value

  !--------------------- End:  Test if we can move
  !--------------------- Move current record to a temporary location
  DO BRW2::MS:PrimeFieldsHigh
  SET(FN:DateMatterKey,FN:DateMatterKey)
  MS::OutOfRange=Access:FeeNote.Previous()            ! Find last in sequence
  MS::SwapSequence=FN:Sorter+1                        ! Save the sequence number of the last in this order

  DO BRW2::MS:PrimeFieldsLow
  FN:Sorter=MS::OrigSequence                          ! Restore original record
  MS::OutOfRange=Access:FeeNote.Fetch(FN:DateMatterKey)

  FN:Sorter=MS::SwapSequence                          ! Place the current record in the new location
  IF Access:FeeNote.TryUpdate()
     MS::Section='Put Swap Out'
     DO BRW2::MS:ErrorCheck
  .
  !--------------------- End:  Move current record to a temporary location

  !--------------------- Move all other records
  DO BRW2::MS::SetToOriginalRecord
  LOOP WHILE NOT(MS::OutOfRange) AND FN:Sorter<>MS::SwapSequence
     MS::TargetSequence=FN:Sorter                     ! Save next target
     FN:Sorter=MS::OrigSequence                       ! Change to previous record's location
     Access:FeeNote.Update()                          ! Update the file
     EXECUTE MS::MoveType                             ! Move, or finish
        BREAK                                         ! Move once, then done
        BREAK                                         ! Move once, then done
        DO BRW2::MS::GetNextSequencedRecord
        DO BRW2::MS::GetNextSequencedRecord
        DO BRW2::MS::GetNextSequencedRecord
        DO BRW2::MS::GetNextSequencedRecord
     .
     MS::OrigSequence=MS::TargetSequence
  .
  !--------------------- End:  Move all other records

  !--------------------- Move original record into final position
  IF FN:Sorter<>MS::SwapSequence OR MS::OutOfRange
     DO BRW2::MS:PrimeFieldsLow
     FN:Sorter=MS::SwapSequence                       ! Restore original record
     MS::OutOfRange=Access:FeeNote.Fetch(FN:DateMatterKey)
  .

  FN:Sorter=MS::TargetSequence
  Access:FeeNote.Update()
  !--------------------- End:  Move original record into final position

  DO BRW2::MS:CleanUp                                 ! Logout, flush, etc.

  BRW2.ResetFromBuffer()
  SELECT(?FeeNoteBrowse)


BRW2::MS:ErrorCheck ROUTINE
  IF ERRORCODE()
     MESSAGE('Record swap error: <13>' & ERROR() & '<13>FeeNote, FN:DateMatterKey' |
       & '<13>Key Field FN:MatterID = ' & FN:MatterID |
       & '<13>Key Field FN:Date = ' & FN:Date |
       & '<13>Key Field FN:Sorter = ' & FN:Sorter |
       & '<13>Section = ' & MS::Section |
       & '<13>' ,'Error!')

  .

BRW2::MS:CleanUp ROUTINE

BRW2::MS:PrimeFieldsLow ROUTINE
   CLEAR(FN:Record,-1)
   FN:MatterID=SAV:FN_MatterID
   FN:Date=SAV:FN_Date

BRW2::MS:PrimeFieldsHigh ROUTINE
   CLEAR(FN:Record,1)
   FN:MatterID=SAV:FN_MatterID
   FN:Date=SAV:FN_Date

BRW2::MS::GetNextSequencedRecord ROUTINE
  MS::OutOfRange=0
  EXECUTE (2 - MS::MoveType % 2)
     MS::OutOfRange=Access:FeeNote.TryPrevious()
     MS::OutOfRange=Access:FeeNote.TryNext()
  .
  DO BRW2::MS::TestSequencedRange

BRW2::MS::SetToOriginalRecord ROUTINE
  DO BRW2::MS:PrimeFieldsLow
  FN:Sorter=MS::OrigSequence                          ! Start with the current record
  SET(FN:DateMatterKey,FN:DateMatterKey)
  DO BRW2::MS::GetNextSequencedRecord                 ! Get current record

BRW2::MS::TestSequencedRange ROUTINE
  !IF ERRORCODE()=33 |
  IF MS::OutOfRange=1 |
     OR FN:MatterID<>SAV:FN_MatterID |
     OR FN:Date<>SAV:FN_Date |
     THEN
        MS::OutOfRange=1
  .

!--------------------------------------
BRW15::HideTaggingButtons ROUTINE
  HIDE(?TagOne:4)
  HIDE(?UntagOne:4)
  HIDE(?TagAll:4)
  HIDE(?UntagAll:4)
!--------------------------------------
BRW15::WipeTags ROUTINE
  NewTag:PtrM(TAG:ToDoNote)
!--------------------------------------
BRW15::TagOne ROUTINE
  SetTag:PtrM(TAG:ToDoNote, TOD:RecordID)
  Tag = '*'
  DO BRW15::AfterSingleTag
!--------------------------------------
BRW15::UntagOne ROUTINE
  ClrTag:PtrM(TAG:ToDoNote, TOD:RecordID)
  CLEAR(Tag)
  DO BRW15::AfterSingleTag
!--------------------------------------
BRW15::TagAll ROUTINE
  SETCURSOR(CURSOR:Wait)
  BRW15.Reset
  LOOP UNTIL BRW15.Next()
    YIELD# += 1; IF ~YIELD# % 10 THEN YIELD.
    SetTag:PtrM(TAG:ToDoNote, TOD:RecordID)
  END!LOOP
  SETCURSOR
  BRW15.ResetQueue(RESET:Queue)
  SELECT(?ToDoNoteBrowse,CHOICE(?ToDoNoteBrowse))
!--------------------------------------
BRW15::UntagAll ROUTINE
  ?TOD:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
  BRW15::Filter = 0
  NewTag:PtrM(TAG:ToDoNote)
  Tag = ''
  BRW15.ResetQueue(RESET:Queue)
  SELECT(?ToDoNoteBrowse,CHOICE(?ToDoNoteBrowse))
!--------------------------------------
BRW15::FlipOne ROUTINE
  RvsTag:PtrM(TAG:ToDoNote, TOD:RecordID)
  IF Queue:Browse:3.Tag
    CLEAR(Tag)
  ELSE
    Tag = '*'
  END!IF
  DO BRW15::AfterSingleTag
!--------------------------------------
BRW15::AfterSingleTag ROUTINE
  IF Tag
    Queue:Browse:3.Tag_Icon = 2
  ELSE
    Queue:Browse:3.Tag_Icon = 1
  END!IF
  Queue:Browse:3.Tag = Tag
  PUT(Queue:Browse:3)
  ASSERT(~ERRORCODE())
  SELECT(?ToDoNoteBrowse,CHOICE(?ToDoNoteBrowse))
!--------------------------------------
BRW15::MouseLeftFlipTag ROUTINE
  DATA
BRW15::Ctl SHORT,AUTO
  CODE
  IF  KEYCODE() = MouseLeft AND FOCUS() = ?ToDoNoteBrowse  |
  AND INRANGE(MOUSEX(), ?ToDoNoteBrowse{PROP:XPos}, ?ToDoNoteBrowse{PROP:XPos} + ?ToDoNoteBrowse{PROP:Width} - 1)  |
  AND INRANGE(MOUSEY(), ?ToDoNoteBrowse{PROP:YPos}, ?ToDoNoteBrowse{PROP:YPos} + ?ToDoNoteBrowse{PROP:Height}  |
                                     - CHOOSE(?ToDoNoteBrowse{PROP:HScroll} OR ?ToDoNoteBrowse{PROP:VCR},9,1))  |
  AND ?ToDoNoteBrowse{PROPLIST:MouseDownRow} > 0 AND ?ToDoNoteBrowse{PROPLIST:MouseDownZone} <> LISTZONE:Right  |
  AND ?ToDoNoteBrowse{PROPLIST:MouseDownField} = 1
    BRW15::Ctl = ?ToDoNoteBrowse
    LOOP WHILE BRW15::Ctl
      IF BRW15::Ctl{PROP:Disable} THEN EXIT.
      BRW15::Ctl = BRW15::Ctl{PROP:Parent}
    END!LOOP
    BRW15.UpdateViewRecord
    DO BRW15::FlipOne
  END!IF
!--------------------------------------
BRW22::HideTaggingButtons ROUTINE
  HIDE(?TagOne:5)
  HIDE(?UntagOne:5)
  HIDE(?TagAll:5)
  HIDE(?UntagAll:5)
!--------------------------------------
BRW22::WipeTags ROUTINE
  NewTag:PtrM(TAG:MatActiv)
!--------------------------------------
BRW22::TagOne ROUTINE
  SetTag:PtrM(TAG:MatActiv, MA:RecordID)
  Tag = '*'
  DO BRW22::AfterSingleTag
!--------------------------------------
BRW22::UntagOne ROUTINE
  ClrTag:PtrM(TAG:MatActiv, MA:RecordID)
  CLEAR(Tag)
  DO BRW22::AfterSingleTag
!--------------------------------------
BRW22::TagAll ROUTINE
  SETCURSOR(CURSOR:Wait)
  BRW22.Reset
  LOOP UNTIL BRW22.Next()
    YIELD# += 1; IF ~YIELD# % 10 THEN YIELD.
    SetTag:PtrM(TAG:MatActiv, MA:RecordID)
  END!LOOP
  SETCURSOR
  BRW22.ResetQueue(RESET:Queue)
  SELECT(?TimeRecordingBrowse,CHOICE(?TimeRecordingBrowse))
!--------------------------------------
BRW22::UntagAll ROUTINE
  ?MA:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
  BRW22::Filter = 0
  NewTag:PtrM(TAG:MatActiv)
  Tag = ''
  BRW22.ResetQueue(RESET:Queue)
  SELECT(?TimeRecordingBrowse,CHOICE(?TimeRecordingBrowse))
!--------------------------------------
BRW22::FlipOne ROUTINE
  RvsTag:PtrM(TAG:MatActiv, MA:RecordID)
  IF Queue:Browse:5.Tag
    CLEAR(Tag)
  ELSE
    Tag = '*'
  END!IF
  DO BRW22::AfterSingleTag
!--------------------------------------
BRW22::AfterSingleTag ROUTINE
  IF Tag
    Queue:Browse:5.Tag_Icon = 2
  ELSE
    Queue:Browse:5.Tag_Icon = 1
  END!IF
  Queue:Browse:5.Tag = Tag
  PUT(Queue:Browse:5)
  ASSERT(~ERRORCODE())
  SELECT(?TimeRecordingBrowse,CHOICE(?TimeRecordingBrowse))
!--------------------------------------
BRW22::MouseLeftFlipTag ROUTINE
  DATA
BRW22::Ctl SHORT,AUTO
  CODE
  IF  KEYCODE() = MouseLeft AND FOCUS() = ?TimeRecordingBrowse  |
  AND INRANGE(MOUSEX(), ?TimeRecordingBrowse{PROP:XPos}, ?TimeRecordingBrowse{PROP:XPos} + ?TimeRecordingBrowse{PROP:Width} - 1)  |
  AND INRANGE(MOUSEY(), ?TimeRecordingBrowse{PROP:YPos}, ?TimeRecordingBrowse{PROP:YPos} + ?TimeRecordingBrowse{PROP:Height}  |
                                     - CHOOSE(?TimeRecordingBrowse{PROP:HScroll} OR ?TimeRecordingBrowse{PROP:VCR},9,1))  |
  AND ?TimeRecordingBrowse{PROPLIST:MouseDownRow} > 0 AND ?TimeRecordingBrowse{PROPLIST:MouseDownZone} <> LISTZONE:Right  |
  AND ?TimeRecordingBrowse{PROPLIST:MouseDownField} = 1
    BRW22::Ctl = ?TimeRecordingBrowse
    LOOP WHILE BRW22::Ctl
      IF BRW22::Ctl{PROP:Disable} THEN EXIT.
      BRW22::Ctl = BRW22::Ctl{PROP:Parent}
    END!LOOP
    BRW22.UpdateViewRecord
    DO BRW22::FlipOne
  END!IF
!--------------------------------------
BRW2::HideTaggingButtons ROUTINE
  HIDE(?TagOne:2)
  HIDE(?UntagOne:2)
  HIDE(?TagAll:2)
  HIDE(?UntagAll:2)
!--------------------------------------
BRW2::WipeTags ROUTINE
  NewTag:PtrM(TAG:FeeNote)
!--------------------------------------
BRW2::TagOne ROUTINE
  SetTag:PtrM(TAG:FeeNote, FN:RecordID)
  Tag = '*'
  DO BRW2::AfterSingleTag
!--------------------------------------
BRW2::UntagOne ROUTINE
  ClrTag:PtrM(TAG:FeeNote, FN:RecordID)
  CLEAR(Tag)
  DO BRW2::AfterSingleTag
!--------------------------------------
BRW2::TagAll ROUTINE
  SETCURSOR(CURSOR:Wait)
  BRW2.Reset
  LOOP UNTIL BRW2.Next()
    YIELD# += 1; IF ~YIELD# % 10 THEN YIELD.
    SetTag:PtrM(TAG:FeeNote, FN:RecordID)
  END!LOOP
  SETCURSOR
  BRW2.ResetQueue(RESET:Queue)
  SELECT(?FeeNoteBrowse,CHOICE(?FeeNoteBrowse))
!--------------------------------------
BRW2::UntagAll ROUTINE
  ?FN:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
  BRW2::Filter = 0
  NewTag:PtrM(TAG:FeeNote)
  Tag = ''
  BRW2.ResetQueue(RESET:Queue)
  SELECT(?FeeNoteBrowse,CHOICE(?FeeNoteBrowse))
!--------------------------------------
BRW2::FlipOne ROUTINE
  RvsTag:PtrM(TAG:FeeNote, FN:RecordID)
  IF Queue:Browse.Tag
    CLEAR(Tag)
  ELSE
    Tag = '*'
  END!IF
  DO BRW2::AfterSingleTag
!--------------------------------------
BRW2::AfterSingleTag ROUTINE
  IF Tag
    Queue:Browse.Tag_Icon = 2
  ELSE
    Queue:Browse.Tag_Icon = 1
  END!IF
  Queue:Browse.Tag = Tag
  PUT(Queue:Browse)
  ASSERT(~ERRORCODE())
  SELECT(?FeeNoteBrowse,CHOICE(?FeeNoteBrowse))
!--------------------------------------
BRW2::MouseLeftFlipTag ROUTINE
  DATA
BRW2::Ctl SHORT,AUTO
  CODE
  IF  KEYCODE() = MouseLeft AND FOCUS() = ?FeeNoteBrowse  |
  AND INRANGE(MOUSEX(), ?FeeNoteBrowse{PROP:XPos}, ?FeeNoteBrowse{PROP:XPos} + ?FeeNoteBrowse{PROP:Width} - 1)  |
  AND INRANGE(MOUSEY(), ?FeeNoteBrowse{PROP:YPos}, ?FeeNoteBrowse{PROP:YPos} + ?FeeNoteBrowse{PROP:Height}  |
                                     - CHOOSE(?FeeNoteBrowse{PROP:HScroll} OR ?FeeNoteBrowse{PROP:VCR},9,1))  |
  AND ?FeeNoteBrowse{PROPLIST:MouseDownRow} > 0 AND ?FeeNoteBrowse{PROPLIST:MouseDownZone} <> LISTZONE:Right  |
  AND ?FeeNoteBrowse{PROPLIST:MouseDownField} = 1
    BRW2::Ctl = ?FeeNoteBrowse
    LOOP WHILE BRW2::Ctl
      IF BRW2::Ctl{PROP:Disable} THEN EXIT.
      BRW2::Ctl = BRW2::Ctl{PROP:Parent}
    END!LOOP
    BRW2.UpdateViewRecord
    DO BRW2::FlipOne
  END!IF
!--------------------------------------
BRW36::HideTaggingButtons ROUTINE
  HIDE(?TagOne:6)
  HIDE(?UntagOne:6)
  HIDE(?TagAll:6)
  HIDE(?UntagAll:6)
!--------------------------------------
BRW36::WipeTags ROUTINE
  NewTag:PtrM(TAG:LAWMatterMessage)
!--------------------------------------
BRW36::TagOne ROUTINE
  SetTag:PtrM(TAG:LAWMatterMessage, MME:RecordID)
  Tag = '*'
  DO BRW36::AfterSingleTag
!--------------------------------------
BRW36::UntagOne ROUTINE
  ClrTag:PtrM(TAG:LAWMatterMessage, MME:RecordID)
  CLEAR(Tag)
  DO BRW36::AfterSingleTag
!--------------------------------------
BRW36::TagAll ROUTINE
  SETCURSOR(CURSOR:Wait)
  BRW36.Reset
  LOOP UNTIL BRW36.Next()
    YIELD# += 1; IF ~YIELD# % 10 THEN YIELD.
    SetTag:PtrM(TAG:LAWMatterMessage, MME:RecordID)
  END!LOOP
  SETCURSOR
  BRW36.ResetQueue(RESET:Queue)
  SELECT(?LawMatterMessageBrowse,CHOICE(?LawMatterMessageBrowse))
!--------------------------------------
BRW36::UntagAll ROUTINE
  ?MME:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
  BRW36::Filter = 0
  NewTag:PtrM(TAG:LAWMatterMessage)
  Tag = ''
  BRW36.ResetQueue(RESET:Queue)
  SELECT(?LawMatterMessageBrowse,CHOICE(?LawMatterMessageBrowse))
!--------------------------------------
BRW36::FlipOne ROUTINE
  RvsTag:PtrM(TAG:LAWMatterMessage, MME:RecordID)
  IF Queue:Browse:2.Tag
    CLEAR(Tag)
  ELSE
    Tag = '*'
  END!IF
  DO BRW36::AfterSingleTag
!--------------------------------------
BRW36::AfterSingleTag ROUTINE
  IF Tag
    Queue:Browse:2.Tag_Icon = 2
  ELSE
    Queue:Browse:2.Tag_Icon = 1
  END!IF
  Queue:Browse:2.Tag = Tag
  PUT(Queue:Browse:2)
  ASSERT(~ERRORCODE())
  SELECT(?LawMatterMessageBrowse,CHOICE(?LawMatterMessageBrowse))
!--------------------------------------
BRW36::MouseLeftFlipTag ROUTINE
  DATA
BRW36::Ctl SHORT,AUTO
  CODE
  IF  KEYCODE() = MouseLeft AND ?LawMatterMessageBrowse{PROP:Visible}  |
  AND INRANGE(MOUSEX(), ?LawMatterMessageBrowse{PROP:XPos}, ?LawMatterMessageBrowse{PROP:XPos} + ?LawMatterMessageBrowse{PROP:Width} - 1)  |
  AND INRANGE(MOUSEY(), ?LawMatterMessageBrowse{PROP:YPos}, ?LawMatterMessageBrowse{PROP:YPos} + ?LawMatterMessageBrowse{PROP:Height}  |
                                     - CHOOSE(?LawMatterMessageBrowse{PROP:HScroll} OR ?LawMatterMessageBrowse{PROP:VCR},9,1))  |
  AND ?LawMatterMessageBrowse{PROPLIST:MouseDownRow} > 0 AND ?LawMatterMessageBrowse{PROPLIST:MouseDownZone} <> LISTZONE:Right  |
  AND ?LawMatterMessageBrowse{PROPLIST:MouseDownField} = 1
    BRW36::Ctl = ?LawMatterMessageBrowse
    LOOP WHILE BRW36::Ctl
      IF BRW36::Ctl{PROP:Disable} THEN EXIT.
      BRW36::Ctl = BRW36::Ctl{PROP:Parent}
    END!LOOP
    BRW36.UpdateViewRecord
    DO BRW36::FlipOne
  END!IF
!--------------------------------------
BRW52::HideTaggingButtons ROUTINE
  HIDE(?TagOne:3)
  HIDE(?UntagOne:3)
  HIDE(?TagAll:3)
  HIDE(?UntagAll:3)
!--------------------------------------
BRW52::WipeTags ROUTINE
  NewTag:PtrM(TAG:FileNote)
!--------------------------------------
BRW52::TagOne ROUTINE
  SetTag:PtrM(TAG:FileNote, FIL:RecordID)
  Tag = '*'
  DO BRW52::AfterSingleTag
!--------------------------------------
BRW52::UntagOne ROUTINE
  ClrTag:PtrM(TAG:FileNote, FIL:RecordID)
  CLEAR(Tag)
  DO BRW52::AfterSingleTag
!--------------------------------------
BRW52::TagAll ROUTINE
  SETCURSOR(CURSOR:Wait)
  BRW52.Reset
  LOOP UNTIL BRW52.Next()
    YIELD# += 1; IF ~YIELD# % 10 THEN YIELD.
    SetTag:PtrM(TAG:FileNote, FIL:RecordID)
  END!LOOP
  SETCURSOR
  BRW52.ResetQueue(RESET:Queue)
  SELECT(?FileNoteBrowse,CHOICE(?FileNoteBrowse))
!--------------------------------------
BRW52::UntagAll ROUTINE
  ?FIL:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
  BRW52::Filter = 0
  NewTag:PtrM(TAG:FileNote)
  Tag = ''
  BRW52.ResetQueue(RESET:Queue)
  SELECT(?FileNoteBrowse,CHOICE(?FileNoteBrowse))
!--------------------------------------
BRW52::FlipOne ROUTINE
  RvsTag:PtrM(TAG:FileNote, FIL:RecordID)
  IF Queue:Browse:4.Tag
    CLEAR(Tag)
  ELSE
    Tag = '*'
  END!IF
  DO BRW52::AfterSingleTag
!--------------------------------------
BRW52::AfterSingleTag ROUTINE
  IF Tag
    Queue:Browse:4.Tag_Icon = 2
  ELSE
    Queue:Browse:4.Tag_Icon = 1
  END!IF
  Queue:Browse:4.Tag = Tag
  PUT(Queue:Browse:4)
  ASSERT(~ERRORCODE())
  SELECT(?FileNoteBrowse,CHOICE(?FileNoteBrowse))
!--------------------------------------
BRW52::MouseLeftFlipTag ROUTINE
  DATA
BRW52::Ctl SHORT,AUTO
  CODE
  IF  KEYCODE() = MouseLeft AND ?FileNoteBrowse{PROP:Visible}  |
  AND INRANGE(MOUSEX(), ?FileNoteBrowse{PROP:XPos}, ?FileNoteBrowse{PROP:XPos} + ?FileNoteBrowse{PROP:Width} - 1)  |
  AND INRANGE(MOUSEY(), ?FileNoteBrowse{PROP:YPos}, ?FileNoteBrowse{PROP:YPos} + ?FileNoteBrowse{PROP:Height}  |
                                     - CHOOSE(?FileNoteBrowse{PROP:HScroll} OR ?FileNoteBrowse{PROP:VCR},9,1))  |
  AND ?FileNoteBrowse{PROPLIST:MouseDownRow} > 0 AND ?FileNoteBrowse{PROPLIST:MouseDownZone} <> LISTZONE:Right  |
  AND ?FileNoteBrowse{PROPLIST:MouseDownField} = 1
    BRW52::Ctl = ?FileNoteBrowse
    LOOP WHILE BRW52::Ctl
      IF BRW52::Ctl{PROP:Disable} THEN EXIT.
      BRW52::Ctl = BRW52::Ctl{PROP:Parent}
    END!LOOP
    BRW52.UpdateViewRecord
    DO BRW52::FlipOne
  END!IF
!--------------------------------------
BRW54::HideTaggingButtons ROUTINE
  HIDE(?TagOne)
  HIDE(?UntagOne)
  HIDE(?FlipOne)
  HIDE(?TagAll)
  HIDE(?UntagAll)
  HIDE(?FlipAll)
!--------------------------------------
BRW54::TagOne ROUTINE
  BRW54.UpdateViewRecord
  SetTag:PtrM(TAG:Matter, MAT:RecordID)
  Tag = '*'
  DO BRW54::AfterSingleTag
!--------------------------------------
BRW54::UntagOne ROUTINE
  BRW54.UpdateViewRecord
  ClrTag:PtrM(TAG:Matter, MAT:RecordID)
  CLEAR(Tag)
  DO BRW54::AfterSingleTag
!--------------------------------------
BRW54::TagAll ROUTINE
  PROPSQL('DELETE TaggedMatter WHERE EmployeeID = ' & CEM:RecordID)

  IF LOC:FilterMatterString
     
     PROPSQL('INSERT TaggedMatter SELECT ' & CEM:RecordID & ', RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString)
  ELSE
     
     PROPSQL('INSERT TaggedMatter SELECT ' & CEM:RecordID & ', RecordID FROM Matter')
  END


  DO  CreateTaggedMatterList
  
  SETCURSOR(CURSOR:Wait)
  BRW54.Reset
  LOOP UNTIL BRW54.Next()
    YIELD# += 1; IF ~YIELD# % 10 THEN YIELD.
    SetTag:PtrM(TAG:Matter, MAT:RecordID)
  END!LOOP
  SETCURSOR
  BRW54.ResetQueue(RESET:Queue)
  SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
!--------------------------------------
BRW54::UntagAll ROUTINE
      
  ?MAT:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
  BRW54::Filter = 0
  PROPSQL('DELETE TaggedMatter WHERE EmployeeID = ' & CEM:RecordID)
  
  DO  CreateTaggedMatterList
  NewTag:PtrM(TAG:Matter)
  Tag = ''
  BRW54.ResetQueue(RESET:Queue)
  SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
!--------------------------------------
BRW54::FlipAll ROUTINE
  
    PROPSQL('IF OBJECT_ID (''dbo.Tagged' & CEM:RecordID & ''', ''U'') IS NOT NULL DROP TABLE dbo.Tagged' & CEM:RecordID &|
           ' CREATE TABLE dbo.Tagged' & CEM:RecordID & ' (MatterID Int)')
  
   PROPSQL('INSERT dbo.Tagged' & CEM:RecordID & ' SELECT MatterID FROM TaggedMatter WHERE EmployeeID = ' & CEM:RecordID)
  
   PROPSQL('DELETE TaggedMatter WHERE EmployeeID = ' & CEM:RecordID)
  
   IF LOC:FilterMatterString
      PROPSQL('INSERT TaggedMatter SELECT ' & CEM:RecordID & ', RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ' AND Matter.RecordID NOT IN (SELECT MatterID FROM Tagged' & CEM:RecordID & ')')
   ELSE
      PROPSQL('INSERT TaggedMatter SELECT ' & CEM:RecordID & ', RecordID FROM Matter WHERE Matter.RecordID NOT IN (SELECT MatterID FROM Tagged' & CEM:RecordID & ')')
   END
  
   PROPSQL('DROP TABLE dbo.Tagged' & CEM:RecordID)
  
  DO  CreateTaggedMatterList
  SETCURSOR(CURSOR:Wait)
  BRW54.Reset
  LOOP UNTIL BRW54.Next()
    YIELD# += 1; IF ~YIELD# % 10 THEN YIELD.
    RvsTag:PtrM(TAG:Matter, MAT:RecordID)
  END!LOOP
  SETCURSOR
  BRW54.ResetQueue(RESET:Queue)
  SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
!--------------------------------------
BRW54::FlipOne ROUTINE
  BRW54.UpdateViewRecord
  RvsTag:PtrM(TAG:Matter, MAT:RecordID)
                    
  IF Queue:Browse:1.Tag
    CLEAR(Tag)
  ELSE
    Tag = '*'
  END!IF
  DO BRW54::AfterSingleTag
!--------------------------------------
BRW54::AfterSingleTag ROUTINE
  IF Tag
    Queue:Browse:1.Tag_Icon = 2
  ELSE
    Queue:Browse:1.Tag_Icon = 1
  END!IF
  Queue:Browse:1.Tag = Tag
  PUT(Queue:Browse:1)
  ASSERT(~ERRORCODE())
  IF Tag
     PROPSQL('IF (SELECT COUNT(1) FROM TaggedMatter WHERE EmployeeID = ' & CEM:RecordID & ' AND MatterID = ' & Queue:Browse:1.MAT:RecordID & ') = 0' &|
             ' INSERT TaggedMatter SELECT ' & CEM:RecordID & ', ' & Queue:Browse:1.MAT:RecordID)
  ELSE
     PROPSQL('DELETE TaggedMatter WHERE EmployeeID = ' & CEM:RecordID & ' AND MatterID = ' & Queue:Browse:1.MAT:RecordID)
  END
  
  DO  CreateTaggedMatterList
  
  SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
!--------------------------------------
BRW54::MouseLeftFlipTag ROUTINE
  DATA
BRW54::Ctl SHORT,AUTO
  CODE
  IF  KEYCODE() = MouseLeft AND FOCUS() = ?MattersBrowse  |
  AND INRANGE(MOUSEX(), ?MattersBrowse{PROP:XPos}, ?MattersBrowse{PROP:XPos} + ?MattersBrowse{PROP:Width} - 1)  |
  AND INRANGE(MOUSEY(), ?MattersBrowse{PROP:YPos}, ?MattersBrowse{PROP:YPos} + ?MattersBrowse{PROP:Height}  |
                                     - CHOOSE(?MattersBrowse{PROP:HScroll} OR ?MattersBrowse{PROP:VCR},9,1))  |
  AND ?MattersBrowse{PROPLIST:MouseDownRow} > 0 AND ?MattersBrowse{PROPLIST:MouseDownZone} <> LISTZONE:Right  |
  AND ?MattersBrowse{PROPLIST:MouseDownField} = 1
    BRW54::Ctl = ?MattersBrowse
    LOOP WHILE BRW54::Ctl
      IF BRW54::Ctl{PROP:Disable} THEN EXIT.
      BRW54::Ctl = BRW54::Ctl{PROP:Parent}
    END!LOOP
    BRW54.UpdateViewRecord
    DO BRW54::FlipOne
  END!IF

ThisWindow.Ask PROCEDURE

  CODE
  DO BRW15::WipeTags
  DO BRW22::WipeTags
  DO BRW2::WipeTags
  DO BRW36::WipeTags
  DO BRW52::WipeTags
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    ThisSecProc.Init()
  IF GlobalRequest <> SelectRecord
    IF NOT GLO:RUNNING:BrowseDesktop
      GLO:RUNNING:BrowseDesktop=THREAD()
      LOC:RUNNING= GLO:RUNNING:BrowseDesktop
    ELSE
      POST(EVENT:GainFocus,,GLO:RUNNING:BrowseDesktop)
      RETURN(Level:Fatal)
    END
  END
    PropSQLNext('Select Count(1)  FROM Licensed INNER JOIN Docgen ON Licensed.DocgenID = Docgen.RecordID AND Docgen.NoOfUsers > 0 AND Docgen.Code = ''GHUB'' WHERE EmployeeID = ' & CEM:RecordID)

    LOC:GHUBLicensed =  ROW:Counter
   

    IF ~GLO:ProgramStarted    ! DISPLAY THOUGHTS WINDOW ONLY ONCE

      IF CEM:NoThoughtsFlag OR GLO:ReloggingOnFlag

         OPEN(OpeningDesktopScreen)

         IF CEM:DesktopBackground  

              EXECUTE GLO:DesktopBackground
                  OpeningDesktopScreen{PROP:WallPaper} = '~bluetile.jpg'
                  OpeningDesktopScreen{PROP:WallPaper} = '~pinktile.jpg'
                  OpeningDesktopScreen{PROP:WallPaper} = '~tantile.jpg'
                  OpeningDesktopScreen{PROP:WallPaper} = '~marbletile.jpg'
                  OpeningDesktopScreen{PROP:WallPaper} = '~bricks.bmp'
              END

              OpeningDesktopScreen{PROP:Tiled} = 1

          ELSE
              OpeningDesktopScreen{PROP:WallPaper} = ''
          END

          DISPLAY

      END
  END

  !STOP('?PartiesButton = ' & ?PartiesButton)
  GlobalErrors.SetProcedureName('BrowseDesktop')
  SELF.Request = GlobalRequest
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?LOC:QuickSearch:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors
  SELF.FirstField = ?MattersBrowse
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)
  CLEAR(GlobalResponse)
  SELF.AddItem(?Close,RequestCancelled)
  Relate:ABSAFees.Open
  Relate:ABSAPayment.Open
  Relate:ABSA_MatterMessage.Open
  Relate:AG_MatterMessage.Open
  Relate:AccBank.Open
  Relate:Activity.Open
  Relate:BondABSA.Open
  Relate:BondArea.Open
  Relate:BondCause.Open
  Relate:BondData.Open
  Relate:BondDebit.Open
  Relate:BondDefs.Open
  Relate:BondDeposit.Open
  Relate:BondFNB.Open
  Relate:BondGuar.Open
  Relate:BondProp.Open
  Relate:BondPropAlias.Open
  Relate:BondShare.Open
  Relate:Branch.Open
  Relate:BranchLang.Open
  Relate:Changes.Open
  Relate:CheckSheetScreen.Open
  Relate:Claim.Open
  Relate:Clause.Open
  Relate:ColData.Open
  Relate:ColDebit.Open
  Relate:ColRent.Open
  Relate:ConsentType.Open
  Relate:ConveyData.Open
  Relate:CostCentre.Open
  Relate:CriticalStep.Open
  Relate:CustomReportField.Open
  Relate:DeedsOffice.Open
  Relate:Delivery.Open
  Relate:DeliveryFeeCode.Open
  Relate:Descript.Open
  Relate:DocCategory.Open
  Relate:DocCheckList.Open
  Relate:DocDebit.Open
  Relate:DocDebitLang.Open
  Relate:DocDef.Open
  Relate:DocDisplayCriteria.Open
  Relate:DocEvent.Open
  Relate:DocFileNote.Open
  Relate:DocLang.Open
  Relate:DocLog.Open
  Relate:DocLogAttachment.Open
  Relate:DocLogCategory.Open
  Relate:DocMergeQueue.Open
  Relate:DocScrn.Open
  Relate:DocScrnEvent.Open
  Relate:DocScrnField.Open
  Relate:DocToDoItem.Open
  Relate:Docgen.Open
  Relate:DocgenAlias.Open
  Relate:DocgenDebit.Open
  Relate:Document.Open
  Relate:DocumentExtraScreen.Open
  Relate:ElectronicLinkLog.Open
  Relate:EmpAlert.Open
  Relate:EmpDefaultFilter.Open
  Relate:Employee.Open
  Relate:EmployeeAlias.Open
  Relate:EmployeeAlias2.Open
  Relate:Entity.Open
  Relate:EntityFica.Open
  Relate:EntityLang.Open
  Relate:Event.Open
  Relate:EventAlias.Open
  Relate:Favourites.Open
  Relate:FeeCode.Open
  Relate:FeeItem.Open
  Relate:FeeLink.Open
  Relate:FeeNote.Open
  Relate:FeeNoteAlias.Open
  Relate:FeeScale.Open
  Relate:FeeSheet.Open
  Relate:FeeSheetAlias.Open
  Relate:FeeText.Open
  Relate:Field.Open
  Relate:FieldVar.Open
  Relate:FileNote.Open
  Relate:Invoice.Open
  Relate:LAW_Mattr.Open
  Relate:LAW_Messg.Open
  Relate:LAW_Suite.Open
  Relate:Language.Open
  Relate:LanguageAlias.Open
  Relate:LawMatterMessage.Open
  Relate:Library.Open
  Relate:Licensed.Open
  Relate:LogFile.Open
  Relate:MatActiv.Open
  Relate:MatDef.Open
  Relate:MatDefParty.Open
  Relate:MatEmployee.Open
  Relate:MatField.Open
  Relate:MatGroup.Open
  Relate:MatParty.Open
  Relate:MatTran.Open
  Relate:MatType.Open
  Relate:Matter.Open
  Relate:MatterAlias.Open
  Relate:MatterAlias2.Open
  Relate:MatterPartyAlias.Open
  Relate:MatterPartyAlias2.Open
  Relate:Notification.Open
  Relate:PTypeDef.Open
  Relate:ParCategory.Open
  Relate:ParFica.Open
  Relate:ParField.Open
  Relate:ParLang.Open
  Relate:ParRegion.Open
  Relate:ParRolSc.Open
  Relate:ParSign.Open
  Relate:ParTele.Open
  Relate:ParType.Open
  Relate:Party.Open
  Relate:PlanOfAction.Open
  Relate:PronText.Open
  Relate:Province.Open
  Relate:RafData.Open
  Relate:RepEmp.Open
  Relate:RepEmpPlanOfAction.Open
  Relate:Report.Open
  Relate:ReportEmp.Open
  Relate:Role.Open
  Relate:RoleLang.Open
  Relate:RowCounter.Open
  Relate:SARS_MatterMessage.Open
  Relate:SMSLog.Open
  Relate:SafeLog.Open
  Relate:SafeType.Open
  Relate:SecProc.Open
  Relate:Stage.Open
  Relate:Task.Open
  Relate:TaskAlias.Open
  Relate:ToDoItem.Open
  Relate:ToDoNote.Open
  Relate:ToDoText.Open
  Relate:TownshipData.Open
  Relate:TranDefs.Open
  Relate:VarLang.Open
  Relate:Variable.Open
  SELF.FilesOpened = True
  BindAllVariables          ! DO ALL THE BINDING HERE

  DO BindFilteringVariables
  
  IF GetControlFile().
  
  GLO:BrowseMattersThread = THREAD()

  PROPSQL('DELETE TaggedMatter WHERE EmployeeID = ' & CEM:RecordID)

  SAV:GlobalDefaultCostCentreID = CEM:DefaultCostCentreId

  GLO:ReportCategory = CEM:ReportCategory

  GLO:FN_Matter     = CEM:FN_Matter
  GLO:FIL_Matter    = CEM:FIL_Matter
  GLO:TOD_Matter    = CEM:TOD_Matter
  GLO:MA_Matter     = CEM:MA_Matter

  GLO:FN_EmployeeID = CEM:FN_EmployeeID
  GLO:FIL_EmployeeID = CEM:FIL_EmployeeID
  GLO:TOD_EmployeeID = CEM:TOD_EmployeeID
  GLO:MA_EmployeeID = CEM:MA_EmployeeID

  GLO:MA_ActivityID = CEM:MA_ActivityID

  GLO:FN_CostCentreID = CEM:FN_CostCentreID
  GLO:MA_CostCentreID = CEM:MA_CostCentreID

  GLO:FN_Period = CEM:FN_Period
  GLO:FIL_Period = CEM:FIL_Period
  GLO:TOD_Period = CEM:TOD_Period
  GLO:MA_Period = CEM:MA_Period

  GLO:FN_FromDate = CEM:FN_FromDate
  GLO:FN_ToDate = CEM:FN_ToDate
  GLO:FIL_FromDate = CEM:FIL_FromDate
  GLO:FIL_ToDate = CEM:FIL_ToDate
  GLO:TOD_FromDate = CEM:TOD_FromDate
  GLO:TOD_ToDate = CEM:TOD_ToDate
  GLO:MA_FromDate = CEM:MA_FromDate
  GLO:MA_ToDate = CEM:MA_ToDate

  GLO:TOD_Status = CEM:TOD_Status
!  GLO:MA_Billable = CEM:MA_BilledFlag
  GLO:PostedOption = CEM:PostedOption

  DO FillEmployeeQueues
  DO FillCostCentreQueue

  DO FillCriticalStepQueue
  DO FillAG_Suite_DescriptionQueue

  LOC:ReportCategory = GLO:ReportCategory
  IF ~LOC:ReportCategory 
      IF GLO:InterfaceOption = 'C'      !IF CONVEYANCING USER
         LOC:ReportCategory = 'Conveyancing'
      ELSIF GLO:InterfaceOption = 'L'   
         LOC:ReportCategory = 'Litigation'
      ELSE
         LOC:ReportCategory = 'General'
      END
  END

  IF ~GLO:ReportDestination THEN
    GLO:ReportDestination = 'X'
  .

  LOC:FN_Matter = GLO:FN_Matter
  LOC:FIL_Matter = GLO:FIL_Matter
  LOC:TOD_Matter = GLO:TOD_Matter
  LOC:MA_Matter = GLO:MA_Matter
  LOC:DAT_Matter = CEM:DAT_Matter
  LOC:FNB_Matter = CEM:FNB_Matter
  !FB701 kelvin 20 Mar 2017
  LOC:TOD_CriticalStepID = CEM:TOD_CriticalStep

  LOC:AG_SuiteID = CEM:Filter_AG_Suite
  LOC:ABSA_Matter = CEM:ABSA_Matter
  LOC:ABSA_DG_Code = CEM:ABSA_DG_Code
  LOC:SARS_Matter = CEM:SARS_Matter


  IF ~LOC:FN_Matter THEN LOC:FN_Matter = 'Current'.
  IF ~LOC:FIL_Matter THEN LOC:FIL_Matter = 'Current'.
  IF ~LOC:TOD_Matter THEN LOC:TOD_Matter= 'All'.
  IF ~LOC:MA_Matter THEN LOC:MA_Matter = 'All'.
  IF ~LOC:DAT_Matter THEN LOC:DAT_Matter = 'Current'.
  IF ~LOC:FNB_Matter THEN LOC:FNB_Matter = 'Current'.
  IF ~LOC:AG_Suite_Description THEN LOC:AG_Suite_Description = 'All'.
  IF ~LOC:AG_SuiteID THEN LOC:AG_SuiteID = -1.
  IF ~LOC:ABSA_Matter THEN LOC:ABSA_Matter = 'Current'.
  IF ~LOC:ABSA_DG_Code THEN LOC:ABSA_DG_Code = 'All'.
  IF ~LOC:ABSA_Direction THEN LOC:ABSA_Direction = 'All'.
  IF ~LOC:SARS_Matter THEN LOC:SARS_Matter = 'Current'.


  LOC:FN_Period    = GLO:FN_Period
  LOC:FIL_Period   = GLO:FIL_Period
  LOC:TOD_Period   = GLO:TOD_Period

  LOC:MA_Period    = GLO:MA_Period
  LOC:DAT_Period   = CEM:DAT_Period
  LOC:FNB_Period   = CEM:FNB_Period
  LOC:ABSA_Period  = CEM:ABSA_Period
  LOC:SARS_Period  = CEM:SARS_Period

  LOC:FN_FromDate    = GLO:FN_FromDate
  LOC:FIL_FromDate   = GLO:FIL_FromDate
  LOC:TOD_FromDate   = GLO:TOD_FromDate
  LOC:MA_FromDate    = GLO:MA_FromDate
  LOC:DAT_FromDate   = CEM:DAT_FromDate
  LOC:FNB_FromDate   = CEM:FNB_FromDate
  LOC:ABSA_FromDate  = CEM:ABSA_FromDate
  LOC:SARS_FromDate  = CEM:SARS_FromDate


  LOC:FN_ToDate    = GLO:FN_ToDate
  LOC:FIL_ToDate   = GLO:FIL_ToDate
  LOC:TOD_ToDate   = GLO:TOD_ToDate
  LOC:MA_ToDate    = GLO:MA_ToDate
  LOC:DAT_ToDate   = CEM:DAT_ToDate
  LOC:FNB_ToDate   = CEM:FNB_ToDate
  LOC:ABSA_ToDate  = CEM:ABSA_ToDate
  LOC:SARS_ToDate  = CEM:SARS_ToDate

  !FB 1084
  IF ~LOC:FN_Type THEN LOC:FN_Type = 'All'.
  SAV:LOC:FN_Type = LOC:FN_Type

  IF ~LOC:FN_Period THEN LOC:FN_Period = 'All'.
  IF ~LOC:FIL_Period THEN LOC:FIL_Period = 'All'.
  IF ~LOC:TOD_Period THEN LOC:TOD_Period= 'All'.
  IF ~LOC:MA_Period THEN LOC:MA_Period = 'Today'.
  IF ~LOC:DAT_Period THEN LOC:DAT_Period = 'All'.
  IF ~LOC:FNB_Period THEN LOC:FNB_Period = 'All'.
  IF ~LOC:AG_Suite_Description THEN LOC:AG_Suite_Description = 'All'.
  IF ~LOC:AG_SuiteID THEN LOC:AG_SuiteID = -1.
  IF ~LOC:ABSA_Period THEN LOC:ABSA_Period = 'All'.
  IF ~LOC:SARS_Period THEN LOC:SARS_Period = 'All'.

  LOC:TOD_Status = GLO:TOD_Status
  LOC:FIL_Status = CEM:FIL_Status
  IF ~LOC:FIL_Status THEN LOC:FIL_Status = 'All'.

  LOC:FIL_Internal = 'All'
  SAV:FIL_Internal = 'All'

  IF ~LOC:TOD_Status THEN LOC:TOD_Status = 'Incomplete'.

  LOC:MA_BilledFlag = GLO:MA_Billable
  IF ~LOC:MA_BilledFlag THEN LOC:MA_BilledFlag = 'All'.

  LOC:PostedOption = GLO:PostedOption
  IF ~LOC:PostedOption THEN LOC:PostedOption = 'Unposted'.  ! Initialise to Unposted

  CASE LOC:PostedOption
       OF 'Unposted'
           ?LOC:PostedOption{PROP:Selected} = 1
       OF 'Posted'
           ?LOC:PostedOption{PROP:Selected} = 2
       OF 'All'
           ?LOC:PostedOption{PROP:Selected} = 3
       ELSE
           LOC:PostedOption = 'Unposted'
           ?LOC:PostedOption{PROP:Selected} = 1
  END


  SAV:FN_Period = LOC:FN_Period
  DO SetFN_DatePeriod
  
  SAV:FIL_Period = LOC:FIL_Period
  DO SetFIL_DatePeriod

  SAV:DAT_Period = LOC:DAT_Period
  DO SetDAT_DatePeriod


  SAV:FNB_Period = LOC:FNB_Period
  DO SetFNB_DatePeriod


  SAV:SARS_Period = LOC:SARS_Period
  DO SetSARS_DatePeriod

  SAV:ABSA_Period = LOC:ABSA_Period
  DO SetABSA_DatePeriod

  SAV:ABSA_DG_Code = LOC:ABSA_DG_Code
  SAV:ABSA_Direction = LOC:ABSA_Direction

  SAV:TOD_Period = LOC:TOD_Period
  SAV:FIL_Status = LOC:FIL_Status
  SAV:TOD_Status = LOC:TOD_Status
  DO SetTOD_DatePeriod
  
  SAV:MA_BilledFlag = LOC:MA_BilledFlag
  SAV:MA_Period = LOC:MA_Period
  DO SetMA_DatePeriod
  
  SAV:PostedOption = LOC:PostedOption

  IF GLO:FilterMattersBy               ! CLEAR ANY USER FILTERS IN CASE THEY ARE NON-SENSICAL
     CEM:FilterMattersBy = ''          ! AND CAUSING THE DESKTOP TO HANG
     GLO:FilterMattersBy = ''
  END


  IF ~GLO:ProgramStarted    ! DISPLAY THOUGHTS WINDOW ONLY ONCE

      IF CEM:NoThoughtsFlag OR GLO:ReloggingOnFlag
         CLOSE(OpeningDesktopScreen)
      ELSE
      !   CLOSE(ThoughtsWindow)
      END
  END
!Commented out by Kelvin
!  ! TRY AND DISPLAY THE MOST RECENT ENTRY IN THIS EMPLOYEES FAVOURITES
!  PropSQLNext('SELECT TOP 1 MatterID FROM Favourites WHERE EmployeeID = ' & CEM:RecordID & ' ORDER BY Date Desc,Time Desc')
!
!  IF ROW:Counter
!     LOC:FavouriteRecordID = ROW:Counter
!
!     DO MakeMatterFilterString
!
!     IF LOC:FilterMatterString  ! IS IT BEING DISPLAYED WITH THE CURRENT FILER SETTINGS?
!        PropSQLNext('SELECT COUNT(1) WHERE ' & LOC:FavouriteRecordID & ' IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')')
!        IF ROW:Counter
!           MAT:RecordID = LOC:FavouriteRecordID
!           Access:Matter.TryFetch(MAT:PrimaryKey)
!
!           BRW54.StartAtCurrent = True
!
!        END
!     ELSE
!        MAT:RecordID = LOC:FavouriteRecordID
!        Access:Matter.TryFetch(MAT:PrimaryKey)
!
!        BRW54.StartAtCurrent = True
!
!     END
!  END



   IF CEM:FilterDateFlag
        IF CEM:FilterDateOption = 'Today'
            GLO:FilterToDate = GLO:TodaysDate
            GLO:FilterFromDate = GLO:TodaysDate

        ELSIF CEM:FilterDateOption = 'This Week'
            IF GLO:TodaysDate%7 = 0  ! IF SUNDAY
               GLO:FilterFromDate = GLO:TodaysDate - 6
            ELSE
               GLO:FilterFromDate = GLO:TodaysDate - GLO:TodaysDate%7 + 1
            END
            GLO:FilterToDate = GLO:FilterFromDate + 6

        ELSIF CEM:FilterDateOption = 'This Month'
             GLO:FilterFromDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))
             IF MONTH(GLO:TodaysDate) = 12
                GLO:FilterToDate = DATE(12,31,YEAR(GLO:TodaysDate))
             ELSE
                GLO:FilterToDate = DATE(MONTH(GLO:TodaysDate)+1,1,YEAR(GLO:TodaysDate))-1
             END
        ELSIF CEM:FilterDateOption = 'This Year'
             GLO:FilterFromDate = DATE(1,1,YEAR(GLO:TodaysDate))
             GLO:FilterToDate = DATE(12,31,YEAR(GLO:TodaysDate))
        END
   END



  FLUSH(BRW54::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW54::View:Browse,30,2,5,300)
  BRW54.Init(?MattersBrowse,Queue:Browse:1.ViewPosition,BRW54::View:Browse,Queue:Browse:1,Relate:Matter,SELF)
  FLUSH(BRW52::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW52::View:Browse,30,2,5,300)
  BRW52.Init(?FileNoteBrowse,Queue:Browse:4.ViewPosition,BRW52::View:Browse,Queue:Browse:4,Relate:FileNote,SELF)
  FLUSH(BRW2::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW2::View:Browse,30,2,5,300)
  BRW2.Init(?FeeNoteBrowse,Queue:Browse.ViewPosition,BRW2::View:Browse,Queue:Browse,Relate:FeeNote,SELF)
  FLUSH(BRW15::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW15::View:Browse,30,2,5,300)
  BRW15.Init(?ToDoNoteBrowse,Queue:Browse:3.ViewPosition,BRW15::View:Browse,Queue:Browse:3,Relate:ToDoNote,SELF)
  FLUSH(BRW22::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW22::View:Browse,30,2,5,300)
  BRW22.Init(?TimeRecordingBrowse,Queue:Browse:5.ViewPosition,BRW22::View:Browse,Queue:Browse:5,Relate:MatActiv,SELF)
  FLUSH(BRW36::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW36::View:Browse,30,2,5,300)
  BRW36.Init(?LawMatterMessageBrowse,Queue:Browse:2.ViewPosition,BRW36::View:Browse,Queue:Browse:2,Relate:LawMatterMessage,SELF)
  FLUSH(BRW46::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW46::View:Browse,30,2,5,300)
  BRW46.Init(?FNBLinkBrowse,Queue:Browse:7.ViewPosition,BRW46::View:Browse,Queue:Browse:7,Relate:AG_MatterMessage,SELF)
  FLUSH(BRW35::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW35::View:Browse,30,2,5,300)
  BRW35.Init(?ABSALinkBrowse,Queue:Browse:9.ViewPosition,BRW35::View:Browse,Queue:Browse:9,Relate:ABSA_MatterMessage,SELF)
  FLUSH(BRW33::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW33::View:Browse,30,2,5,300)
  BRW33.Init(?SARSLinkBrowse,Queue:Browse:11.ViewPosition,BRW33::View:Browse,Queue:Browse:11,Relate:SARS_MatterMessage,SELF)
  CLT:TemplateId  = GLO:TemplateId
  CLT:Description = 'Browse the Matter File  ----------------------------------- LEGALSUITE DESKTOP'
  If Access:Color.Fetch(CLT:PrimaryKey)
    CLT:TemplateId    = GLO:TemplateId
    CLT:Description   = 'Browse the Matter File  ----------------------------------- LEGALSUITE DESKTOP'
    CLT:Text          = -2147450880
    CLT:Background    = 8454143
    CLT:SelText       = 8454143
    CLT:SelBackground = 255
    CLT:Grid          = 8454143
    Access:Color.Insert()
  END
  ColorText:7#          = CLT:Text
  ColorBackground:7#    = CLT:Background
  ColorSelText:7#       = CLT:SelText
  ColorSelBackground:7# = CLT:SelBackground
  ColorGrid:7#          = CLT:Grid
  ! FORCE THESE COLOURS
  ColorText:7#          = GLO:ColorText
  ColorBackground:7#    = GLO:ColorBackground
  ColorSelText:7#       = GLO:ColorSelText
  ColorSelBackground:7# = GLO:ColorSelBackground
  ColorGrid:7#          = GLO:ColorGrid


  OPEN(QuickWindow)
  SELF.Opened=True
    QuickWindow{PROP:Center} = True
    QuickWindow{PROP:Hide} = True

!   IF GLO:LowResolutionFlag
!
!      SETFONT(0,'MS Sans Serif',8)
!
!   END

!**********************************************************************************************************************************************


   ?FeeNoteBrowse{PROP:LineHeight} = 10
   ?TimeRecordingBrowse{PROP:LineHeight} = 10

  IF GLO:TimeRecordingFlag
      ?TimeRecordingTab{PROP:Hide} = False
  END

  IF GLO:DataLinkFlag                 ! USING DATALINK
     ?DataLinkTab{PROP:Hide} = False
  END
  PropSQLNext('Select top 1 RecordID from DocGen WHERE Code like ''KD%'' and NoOfUsers <> 0')
  IF ROW:Counter!  CTL:EnableSBSAKodaFlag OR CTL:EnableABSAKodaFlag OR CTL:EnableNEDKodaFlag OR CTL:EnableMERCKodaFlag ! RICK 30/5/2014  + SAMEER 30/03/2015
     UNHIDE(?STDOnlineDocument)
     ENABLE(?STDOnlineDocumentMatterTab)
  ELSE
     HIDE(?STDOnlineDocument)
     DISABLE(?STDOnlineDocumentMatterTab)
  END

  

  PropSQLNext('Select Count(AG_AttorneyKref) From Branch Where AG_AttorneyKref <> ''''')
  If ROW:Counter
    UNHIDE(?ABSAMessageCentreButton)
  Else
    HIDE(?ABSAMessageCentreButton)
  End


  !GLO:GuaranteeHubFlag = CTL:PHEnabledFlag

  IF GLO:EnableSARSLinkFlag
     ?SARSTab{PROP:Hide} = False
  END

  IF GLO:EnableFNBLinkFlag AND GLO:InterfaceOption <> 'L'

     ?FNBLinkTab{PROP:Hide} = False

     DO ShowFNBExportedStatus

  END


  IF GLO:EnableABSALinkFlag AND GLO:InterfaceOption <> 'L'

     ?ABSALinkTab{PROP:Hide} = False
     DO ShowABSAImportedStatus

  END

  DO ShowUnReadMessagesStatus



  IF GLO:LowResolutionFlag
     LOC:IconSpacing = 26
     LOC:IconSize = 24


    !?Group1{PROP:Height} = 33  ! ******************* TESTING

  ELSE
     LOC:IconSpacing = 28
     LOC:IconSize = 25
  END

  LOC:ButtonXPos = 8

  ?DocgenDatabaseButton{PROP:XPos} = LOC:ButtonXPos
  ?DocgenDatabaseButton{PROP:Height} = LOC:IconSize
  ?DocgenDatabaseButton{PROP:Width} = LOC:IconSize

  LOC:ButtonXPos += LOC:IconSpacing


  ?CheckSheetButton{PROP:XPos} = LOC:ButtonXPos
  ?CheckSheetButton{PROP:Height} = LOC:IconSize
  ?CheckSheetButton{PROP:Width} = LOC:IconSize

  LOC:ButtonXPos += LOC:IconSpacing

  ?ExtraScreenButton{PROP:XPos} = LOC:ButtonXPos
  ?ExtraScreenButton{PROP:Height} = LOC:IconSize
  ?ExtraScreenButton{PROP:Width} = LOC:IconSize

  LOC:ButtonXPos += LOC:IconSpacing

  ?PartiesButton{PROP:XPos} = LOC:ButtonXPos
  ?PartiesButton{PROP:Height} = LOC:IconSize
  ?PartiesButton{PROP:Width} = LOC:IconSize

  LOC:ButtonXPos += LOC:IconSpacing

  IF GLO:TimeRecordingFlag

     ?MatterEmployeesButton{PROP:XPos} = LOC:ButtonXPos
     ?MatterEmployeesButton{PROP:Height} = LOC:IconSize
     ?MatterEmployeesButton{PROP:Width} = LOC:IconSize

     LOC:ButtonXPos += LOC:IconSpacing

  ELSE

     ?MatterEmployeesButton{PROP:Hide} = True

  END

  ?LedgerEnquiryButton{PROP:XPos} = LOC:ButtonXPos
  ?LedgerEnquiryButton{PROP:Height} = LOC:IconSize
  ?LedgerEnquiryButton{PROP:Width} = LOC:IconSize
  LOC:ButtonXPos += LOC:IconSpacing

  ?DocumentLogButton{PROP:XPos} = LOC:ButtonXPos
  ?DocumentLogButton{PROP:Height} = LOC:IconSize
  ?DocumentLogButton{PROP:Width} = LOC:IconSize
  LOC:ButtonXPos += LOC:IconSpacing


  ?UpdateGuarantees{PROP:Hide} = True

  IF GLO:InterfaceOption = 'C'          !IF CONVEYANCING USER
     
     ?CreateCustomisedInvoiceButton{PROP:Hide} = True
     ?BillOfCostsButton{PROP:Hide} = True
     ?DebtorsBalanceButton{PROP:Hide} = True
     IF LOC:GHUBLicensed AND CEM:ShowMatterIconsFlag
     
        ?UpdateGuarantees{PROP:Hide} = False
        ?UpdateGuarantees{PROP:XPos} = LOC:ButtonXPos
        ?UpdateGuarantees{PROP:Height} = LOC:IconSize
        ?UpdateGuarantees{PROP:Width} = LOC:IconSize
        LOC:ButtonXPos += LOC:IconSpacing
        
     
     END

  ELSE

     HIDE(?LOC:TOD_CriticalStepPrompt)
     HIDE(?LOC:TOD_CriticalStep)

     SAV:TOD_CriticalStep = 0
     LOC:TOD_CriticalStep = 0

     ?CreateCustomisedInvoiceButton{PROP:Hide} = False
     ?BillOfCostsButton{PROP:Hide} = False
     ?DebtorsBalanceButton{PROP:Hide} = False


     ?CheckSheetButton{PROP:Tooltip} = 'Check Sheet' ! 29/9/2013 - F7 button was duplicated with ?DebtorsBalanceButton so have taken out (F7) from the tooltip

     ?CreateCustomisedInvoiceButton{PROP:XPos} = LOC:ButtonXPos
     ?CreateCustomisedInvoiceButton{PROP:Height} = LOC:IconSize
     ?CreateCustomisedInvoiceButton{PROP:Width} = LOC:IconSize

     LOC:ButtonXPos += LOC:IconSpacing

     ?BillOfCostsButton{PROP:XPos} = LOC:ButtonXPos
     ?BillOfCostsButton{PROP:Height} = LOC:IconSize
     ?BillOfCostsButton{PROP:Width} = LOC:IconSize

     LOC:ButtonXPos += LOC:IconSpacing

     ?DebtorsBalanceButton{PROP:XPos} = LOC:ButtonXPos
     ?DebtorsBalanceButton{PROP:Height} = LOC:IconSize
     ?DebtorsBalanceButton{PROP:Width} = LOC:IconSize

     LOC:ButtonXPos += LOC:IconSpacing

  END

  IF CTL:FirmCode = 'ACME01'

   ?DisplayDashBoard{PROP:XPos} = LOC:ButtonXPos
   ?DisplayDashBoard{PROP:Height} = LOC:IconSize
   ?DisplayDashBoard{PROP:Width} = LOC:IconSize

   LOC:ButtonXPos += LOC:IconSpacing

   ELSE

   ?DisplayDashBoard{PROP:Hide} = True

  END

  IF GLO:InterfaceOption = 'C'      !IF CONVEYANCING USER

     ?QuickQuoteButton{PROP:Hide} = False
     ?QuickQuoteButton{PROP:XPos} = LOC:ButtonXPos

     ?QuickQuoteButton{PROP:Height} = LOC:IconSize
     ?QuickQuoteButton{PROP:Width} = LOC:IconSize

    LOC:ButtonXPos += LOC:IconSpacing

     IF GLO:RatesClearanceUserFlag !AND CTL:UseRatesClearanceComFlag
        UNHIDE(?ViewRatesClearanceButton)
        ?ViewRatesClearanceButton{PROP:XPos} = LOC:ButtonXPos

        ?ViewRatesClearanceButton{PROP:Height} = LOC:IconSize
        ?ViewRatesClearanceButton{PROP:Width} = LOC:IconSize


        LOC:ButtonXPos += LOC:IconSpacing
     ELSE
        HIDE(?ViewRatesClearanceButton)
     END

  ELSE

     HIDE(?QuickQuoteButton)
     HIDE(?ViewRatesClearanceButton)

  END


  ?ShowFavouritesButton{PROP:XPos} = LOC:ButtonXPos
  ?ShowFavouritesButton{PROP:Height} = LOC:IconSize
  ?ShowFavouritesButton{PROP:Width} = LOC:IconSize

  LOC:ButtonXPos += LOC:IconSpacing



  ?MatterSummaryButton{PROP:XPos} = LOC:ButtonXPos
  ?MatterSummaryButton{PROP:Height} = LOC:IconSize
  ?MatterSummaryButton{PROP:Width} = LOC:IconSize
  LOC:ButtonXPos += LOC:IconSpacing

  ?MAT:QBESearchButton:2{PROP:XPos} = LOC:ButtonXPos
  ?MAT:QBESearchButton:2{PROP:Height} = LOC:IconSize
  ?MAT:QBESearchButton:2{PROP:Width} = LOC:IconSize
  LOC:ButtonXPos += LOC:IconSpacing

  !?MAT:QBEPrintButton{PROP:XPos} = LOC:ButtonXPos
  !LOC:ButtonXPos += LOC:IconSpacing

  ?ToggleMatterIconsButton{PROP:XPos} = LOC:ButtonXPos
  ?ToggleMatterIconsButton{PROP:Height} = LOC:IconSize
  ?ToggleMatterIconsButton{PROP:Width} = LOC:IconSize
  LOC:ButtonXPos += LOC:IconSpacing

  ?SendEmpMessage{PROP:XPos} = LOC:ButtonXPos
  ?SendEmpMessage{PROP:Height} = LOC:IconSize
  ?SendEmpMessage{PROP:Width} = LOC:IconSize
  LOC:ButtonXPos += LOC:IconSpacing


  ?ManagementReportButton{PROP:XPos} = LOC:ButtonXPos
  ?ManagementReportButton{PROP:Height} = LOC:IconSize
  ?ManagementReportButton{PROP:Width} = LOC:IconSize
  LOC:ButtonXPos += LOC:IconSpacing

   !?UpdateGuarantees{PROP:XPos} = LOC:ButtonXPos
   !?UpdateGuarantees{PROP:Height} = LOC:IconSize
   !?UpdateGuarantees{PROP:Width} = LOC:IconSize
   !LOC:ButtonXPos += LOC:IconSpacing

  !If Keyboard() Then Ask.

  !If CTL:FirmCode = 'ACME01' OR CTL:FirmCode = 'ZZZZZZ' OR Band(Keystate(),0100h)
  ! ?ManagementReportButton{PROP:Hide} = false
  ! END


  LOC:ShowMatterIconsFlag = CEM:ShowMatterIconsFlag
  LOC:ShowFileNoteIconsFlag = CEM:ShowFileNoteIconsFlag
  LOC:ShowToDoNoteIconsFlag = CEM:ShowToDoNoteIconsFlag

  UNHIDE(?ToggleMatterIconsButton)
  UNHIDE(?ToggleFileNoteIconsButton)
  UNHIDE(?ToggleToDoNoteIconsButton)



   ?BondCentreOrGatewayPropertyHubDocsButtonMatterTab{PROP:Height} = LOC:IconSize
   ?SelectDocumentsButton{PROP:Height} = LOC:IconSize
   ?STDOnlineDocumentMatterTab{PROP:Height} = LOC:IconSize
   ?FindMatterButton{PROP:Height} = LOC:IconSize
   ?FilterButton{PROP:Height} = LOC:IconSize


   ?BondCentreOrGatewayPropertyHubDocsButtonMatterTab{PROP:Width} = LOC:IconSize
   ?SelectDocumentsButton{PROP:Width} = LOC:IconSize
   ?STDOnlineDocumentMatterTab{PROP:Width} = LOC:IconSize
   ?FindMatterButton{PROP:Width} = LOC:IconSize
   ?FilterButton{PROP:Width} = LOC:IconSize
!
!
!  ?BondCentreOrGatewayPropertyHubDocsButtonMatterTab{PROP:XPos} = LOC:ButtonXPos
!  LOC:ButtonXPos += LOC:IconSpacing
!
!  ?SelectDocumentsButton{PROP:XPos} = LOC:ButtonXPos
!  LOC:ButtonXPos += LOC:IconSpacing
!
!  ?STDOnlineDocumentMatterTab{PROP:XPos} = LOC:ButtonXPos
!  LOC:ButtonXPos += LOC:IconSpacing
!
!  ?FindMatterButton{PROP:XPos} = LOC:ButtonXPos
!  LOC:ButtonXPos += LOC:IconSpacing
!
!  ?FilterButton{PROP:XPos} = LOC:ButtonXPos
!  LOC:ButtonXPos += LOC:IconSpacing



!**********************************************************************************************************************************************




    IF GLO:ThoughtsWindowThread

      QuickWindow{Prop:Timer} = CEM:DisplayThoughtsPeriod * 100

   END

    ALIAS(F1Key,CtrlAltF1)  ! NEED THIS TO BE ABLE TO TRAP THE F1 KEY

    SAV:FN_Period = LOC:FN_Period
    SAV:FN_FromDate = LOC:FN_FromDate
    SAV:FN_ToDate = LOC:FN_ToDate
    SAV:FN_EmployeeID = GLO:FN_EmployeeID
    SAV:FN_CostCentreID = GLO:FN_CostCentreID
    SAV:FN_Matter = LOC:FN_Matter
    SAV:PostedOption = LOC:PostedOption

    SAV:SARS_Period = LOC:SARS_Period
    SAV:SARS_FromDate = LOC:SARS_FromDate
    SAV:SARS_ToDate = LOC:SARS_ToDate
    SAV:SARS_Matter = LOC:SARS_Matter

    SAV:FIL_Period = LOC:FIL_Period
    SAV:FIL_FromDate = LOC:FIL_FromDate
    SAV:FIL_ToDate = LOC:FIL_ToDate
    SAV:FIL_Matter = LOC:FIL_Matter
    SAV:FIL_Status = LOC:FIL_Status
    SAV:FIL_EmployeeID = GLO:FIL_EmployeeID
 
    SAV:TOD_Period = LOC:TOD_Period
    SAV:TOD_FromDate = LOC:TOD_FromDate
    SAV:TOD_ToDate = LOC:TOD_ToDate
    SAV:TOD_Matter = LOC:TOD_Matter
    SAV:TOD_EmployeeID = GLO:TOD_EmployeeID
    SAV:TOD_Status = LOC:TOD_Status
  
    SAV:MA_Period = LOC:MA_Period
    SAV:MA_FromDate = LOC:MA_FromDate
    SAV:MA_ToDate = LOC:MA_ToDate
    SAV:MA_Matter = LOC:MA_Matter
    SAV:MA_EmployeeID = GLO:MA_EmployeeID
    SAV:MA_CostCentreID = GLO:MA_CostCentreID
    SAV:MA_ActivityID = LOC:MA_ActivityID
    SAV:MA_BilledFlag = LOC:MA_BilledFlag

    SAV:DAT_Period = LOC:DAT_Period
    SAV:DAT_FromDate = LOC:DAT_FromDate
    SAV:DAT_ToDate = LOC:DAT_ToDate
    SAV:DAT_Matter = LOC:DAT_Matter

    SAV:FNB_Period   = LOC:FNB_Period
    SAV:FNB_FromDate = LOC:FNB_FromDate
    SAV:FNB_ToDate   = LOC:FNB_ToDate
    SAV:FNB_Matter   = LOC:FNB_Matter
    SAV:LOC:AG_SuiteID = LOC:AG_SuiteID

    SAV:SARS_Period   = LOC:SARS_Period
    SAV:SARS_FromDate = LOC:SARS_FromDate
    SAV:SARS_ToDate   = LOC:SARS_ToDate
    SAV:SARS_Matter   = LOC:SARS_Matter

    SAV:ABSA_Matter = LOC:ABSA_Matter
    SAV:ABSA_Period = LOC:ABSA_Period
    SAV:ABSA_DG_Code = LOC:ABSA_DG_Code
    SAV:ABSA_Direction = LOC:ABSA_Direction
    SAV:ABSA_FromDate = LOC:ABSA_FromDate
    SAV:ABSA_ToDate = LOC:ABSA_ToDate




    BRW54.Popup.AddItemMimic('&Print', ?MatterReportsPrintButton)
    BRW2.Popup.AddItemMimic('&Print', ?FN:PrintButton)
    BRW52.Popup.AddItemMimic('&Print', ?FIL:PrintButton)
    BRW15.Popup.AddItemMimic('&Print', ?TOD:PrintButton)
    BRW22.Popup.AddItemMimic('&Print', ?MA:PrintButton)


    BRW54.Popup.SetLevel(BRW54.Popup.AddItem('-', 'BRW54.PrintSeparator2'),1)
    BRW2.Popup.SetLevel(BRW2.Popup.AddItem('-', 'BRW12.PrintSeparator1'),1)
    BRW52.Popup.SetLevel(BRW52.Popup.AddItem('-', 'BRW52.PrintSeparator1'),1)
    BRW15.Popup.SetLevel(BRW15.Popup.AddItem('-', 'BRW15.PrintSeparator1'),1)
    BRW22.Popup.SetLevel(BRW22.Popup.AddItem('-', 'BRW22.PrintSeparator1'),1)


    ! 30/6/08 - TRY AND INCREASE THIS (UP TO 50)
    ?LOC:FN_Employee{PROP:Drop} = LOC:EmployeeDropDownCounter
    ?LOC:FIL_Employee{PROP:Drop} = LOC:EmployeeDropDownCounter
    ?LOC:TOD_Employee{PROP:Drop} = LOC:EmployeeDropDownCounter
    ?LOC:MA_Employee{PROP:Drop} = LOC:EmployeeDropDownCounter
  
    ?LOC:FN_CostCentre{PROP:Drop} = LOC:CostCentreDropDownCounter
    ?LOC:MA_CostCentre{PROP:Drop} = LOC:CostCentreDropDownCounter

   ! 02/04/2015 Sameer: Change the KODA button tooltip to show the current matter FileRef
   ?STDOnlineDocument{PROP:Tooltip} = 'Assemble the online KODA documents for ' & MAT:FileRef
   ?STDOnlineDocumentMatterTab{PROP:Tooltip} = 'Assemble the online KODA documents for ' & MAT:FileRef
  
  
  ! 4/4/2012 MOVED THE ALERT KEY SETUP TO HERE (FROM THE WINDOW) BECAUSE OF A GPF WHEN TRYING TO ADD MORE CONTROLS TO THE SCREEN

   QuickWindow{Prop:Alrt,229}=CtrlAltF1
   QuickWindow{Prop:Alrt,230}=F1Key
   QuickWindow{Prop:Alrt,231}=F2Key
   QuickWindow{Prop:Alrt,232}=F3Key
   QuickWindow{Prop:Alrt,233}=F4Key
   QuickWindow{Prop:Alrt,234}=F5Key
   QuickWindow{Prop:Alrt,235}=F6Key
   QuickWindow{Prop:Alrt,236}=F7Key
   QuickWindow{Prop:Alrt,237}=F8Key
   QuickWindow{Prop:Alrt,238}=F9Key
   QuickWindow{Prop:Alrt,239}=F10Key
   QuickWindow{Prop:Alrt,240}=F11Key
   QuickWindow{Prop:Alrt,241}=F12Key
   QuickWindow{Prop:Alrt,242}=AltF1
   QuickWindow{Prop:Alrt,243}=AltF2
   QuickWindow{Prop:Alrt,244}=AltF3
   QuickWindow{Prop:Alrt,245}=AltF4
   QuickWindow{Prop:Alrt,246}=AltF5
   QuickWindow{Prop:Alrt,247}=AltF6
   QuickWindow{Prop:Alrt,248}=AltF7
   QuickWindow{Prop:Alrt,249}=AltF8
   QuickWindow{Prop:Alrt,250}=AltF9
   QuickWindow{Prop:Alrt,251}=AltF10


       QuickWindow{Prop:Alrt,254}=1024
       QuickWindow{Prop:Alrt,255}=AltF12
  ?TOD:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
  BRW15::Filter = 0
  ?FN:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
  BRW2::Filter = 0
  ?MA:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
  BRW22::Filter = 0
  ?MME:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
  BRW36::Filter = 0
  ?FIL:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
  BRW52::Filter = 0
  ?MAT:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
  BRW54::Filter = 0
  BRW52.Popup.AddItemMimic('C&opy',?Copy)
  DO BRW15::HideTaggingButtons
  QuickWindow{PROP:Alrt,255} = MouseLeft
  ?ToDoNoteBrowse{PROPLIST:Resize,1}             = ''
  ?ToDoNoteBrowse{PROPLIST:Width,1}              = 11
  ?ToDoNoteBrowse{PROPLIST:Left,1}               = 1
  ?ToDoNoteBrowse{PROPLIST:LeftOffset,1}         = 11
  ?ToDoNoteBrowse{PROPLIST:Icon,1}               = 1
  DO BRW22::HideTaggingButtons
  QuickWindow{PROP:Alrt,255} = MouseLeft
  ?TimeRecordingBrowse{PROPLIST:Resize,1}             = ''
  ?TimeRecordingBrowse{PROPLIST:Width,1}              = 11
  ?TimeRecordingBrowse{PROPLIST:Left,1}               = 1
  ?TimeRecordingBrowse{PROPLIST:LeftOffset,1}         = 11
  ?TimeRecordingBrowse{PROPLIST:Icon,1}               = 1
  DO BRW2::HideTaggingButtons
  QuickWindow{PROP:Alrt,255} = MouseLeft
  ?FeeNoteBrowse{PROPLIST:Resize,1}             = ''
  ?FeeNoteBrowse{PROPLIST:Width,1}              = 11
  ?FeeNoteBrowse{PROPLIST:Left,1}               = 1
  ?FeeNoteBrowse{PROPLIST:LeftOffset,1}         = 11
  ?FeeNoteBrowse{PROPLIST:Icon,1}               = 1
  DO BRW36::HideTaggingButtons
  QuickWindow{PROP:Alrt,255} = MouseLeft
  ?LawMatterMessageBrowse{PROPLIST:Resize,1}             = ''
  ?LawMatterMessageBrowse{PROPLIST:Width,1}              = 11
  ?LawMatterMessageBrowse{PROPLIST:Left,1}               = 1
  ?LawMatterMessageBrowse{PROPLIST:LeftOffset,1}         = 11
  ?LawMatterMessageBrowse{PROPLIST:Icon,1}               = 1
  DO BRW52::HideTaggingButtons
  QuickWindow{PROP:Alrt,255} = MouseLeft
  ?FileNoteBrowse{PROPLIST:Resize,1}             = ''
  ?FileNoteBrowse{PROPLIST:Width,1}              = 11
  ?FileNoteBrowse{PROPLIST:Left,1}               = 1
  ?FileNoteBrowse{PROPLIST:LeftOffset,1}         = 11
  ?FileNoteBrowse{PROPLIST:Icon,1}               = 1
  DO BRW54::HideTaggingButtons
  QuickWindow{PROP:Alrt,255} = MouseLeft
  ?MattersBrowse{PROPLIST:Resize,1}             = ''
  ?MattersBrowse{PROPLIST:Width,1}              = 11
  ?MattersBrowse{PROPLIST:Left,1}               = 1
  ?MattersBrowse{PROPLIST:LeftOffset,1}         = 11
  ?MattersBrowse{PROPLIST:Icon,1}               = 1
! 31/5/2013 - RE-FACTORED THE POPUP MENU TO REDUCE THE NUMBER OF CONTROLS ON THE DESKTOP
   
   

   BRW54.Popup.AddItemEvent('Send Email Message',EVENT:SendEmailButton,?MattersBrowse)
   BRW54.Popup.AddItemEvent('Send SMS Message',EVENT:SendSMSButton,?MattersBrowse)

   BRW54.Popup.AddItem('-','Separator')

   BRW54.Popup.AddItemEvent('Print Accounting Invoice',EVENT:CreateInvoice,?MattersBrowse)
   BRW54.Popup.AddItem('-','Separator')
   BRW54.Popup.AddItemEvent('Add to Recently Used List',EVENT:FavouritesButton,?MattersBrowse)
   IF GLO:DataLinkFlag 
      BRW54.Popup.AddItemEvent('Assign LAW Reference',EVENT:AssignLawRefButton,?MattersBrowse)
   END
   IF GLO:DataLinkFlag
      BRW54.Popup.AddItemEvent('Re-assign DataLink Matter',EVENT:ReassignDataLinkMatterButton,?MattersBrowse)
   END

   BRW54.Popup.SetLevel(BRW54.Popup.AddItemMimic('Conveyancing Exception Report', ?ConveyancingException),1)
   BRW54.Popup.AddItem('-','Separator')

   BRW54.Popup.AddItemEvent('Copy Matter',EVENT:CopyMatter,?MattersBrowse)
   BRW54.Popup.AddItemEvent('&Export Tagged Items',EVENT:ExportMatterButton,?MattersBrowse)
   BRW54.Popup.AddItem('-','Separator')
   BRW54.Popup.AddItemEvent('Reset Column Widths',EVENT:ResetColumnWidthsButton,?MattersBrowse)
   BRW54.Popup.AddItem('-','Separator')




  BRW54.Q &= Queue:Browse:1
  
  BRW54.AddSortOrder(,MAT:FileRefDescKey)
  BRW54.AddLocator(BRW54::Sort1:Locator)
  BRW54::Sort1:Locator.Init(?LOC:QuickSearch,MAT:FileRef,,BRW54)
  BRW54.AddResetField(BRW54::Filter)
  BRW54.AddSortOrder(,MAT:AlternateRefKey)
  BRW54.AddLocator(BRW54::Sort2:Locator)
  BRW54::Sort2:Locator.Init(?LOC:QuickSearch,MAT:AlternateRef,,BRW54)
  BRW54.AddResetField(BRW54::Filter)
  BRW54.AddSortOrder(,MAT:AlternateRefDescKey)
  BRW54.AddLocator(BRW54::Sort3:Locator)
  BRW54::Sort3:Locator.Init(?LOC:QuickSearch,MAT:AlternateRef,,BRW54)
  BRW54.AddResetField(BRW54::Filter)
  BRW54.AddSortOrder(,MAT:PrimaryKey)
  BRW54.AddLocator(BRW54::Sort4:Locator)
  BRW54::Sort4:Locator.Init(?LOC:QuickSearch,MAT:RecordID,,BRW54)
  BRW54.AddResetField(BRW54::Filter)
  BRW54.AddSortOrder(,MAT:RecordIDDescKey)
  BRW54.AddLocator(BRW54::Sort5:Locator)
  BRW54::Sort5:Locator.Init(?LOC:QuickSearch,MAT:RecordID,,BRW54)
  BRW54.AddResetField(BRW54::Filter)
  BRW54.AddSortOrder(,MAT:DescriptionKey)
  BRW54.AddLocator(BRW54::Sort6:Locator)
  BRW54::Sort6:Locator.Init(?LOC:QuickSearch,MAT:Description,,BRW54)
  BRW54.AddResetField(BRW54::Filter)
  BRW54.AddSortOrder(,MAT:DescriptionDescKey)
  BRW54.AddLocator(BRW54::Sort7:Locator)
  BRW54::Sort7:Locator.Init(?LOC:QuickSearch,MAT:Description,,BRW54)
  BRW54.AddResetField(BRW54::Filter)
  BRW54.AddSortOrder(,MAT:DateInstructedKey)
  BRW54.AddLocator(BRW54::Sort8:Locator)
  BRW54::Sort8:Locator.Init(,MAT:DateInstructed,1,BRW54)
  BRW54.AddResetField(BRW54::Filter)
  BRW54.AddSortOrder(,MAT:DateInstructedDescKey)
  BRW54.AddLocator(BRW54::Sort9:Locator)
  BRW54::Sort9:Locator.Init(,MAT:DateInstructed,1,BRW54)
  BRW54.AddResetField(BRW54::Filter)
  BRW54.AddSortOrder(,MAT:FileRefKey)
  BRW54.AddLocator(BRW54::Sort0:Locator)
  BRW54::Sort0:Locator.Init(?LOC:QuickSearch,MAT:FileRef,,BRW54)
  BRW54.AddResetField(BRW54::Filter)
  BIND('Tag',Tag)
  BIND('LOC:MessageIndicator',LOC:MessageIndicator)
  BIND('LOC:GuaranteesIssued',LOC:GuaranteesIssued)
  BIND('LOC:ProgressIndicator',LOC:ProgressIndicator)
  BIND('LOC:ProgressText',LOC:ProgressText)
  BIND('LOC:LinkedMatterRef',LOC:LinkedMatterRef)
  BIND('LOC:FICAWords',LOC:FICAWords)
  BIND('LOC:Employee',LOC:Employee)
  BIND('LOC:Status',LOC:Status)
  ?MattersBrowse{PROP:IconList,1} = '~BLANK.ICO'
  ?MattersBrowse{PROP:IconList,2} = '~CHECK.ICO'
  BRW54.AddField(Tag,BRW54.Q.Tag)
  BRW54.AddField(LOC:MessageIndicator,BRW54.Q.LOC:MessageIndicator)
  BRW54.AddField(LOC:GuaranteesIssued,BRW54.Q.LOC:GuaranteesIssued)
  BRW54.AddField(LOC:ProgressIndicator,BRW54.Q.LOC:ProgressIndicator)
  BRW54.AddField(MAT:FileRef,BRW54.Q.MAT:FileRef)
  BRW54.AddField(LOC:ProgressText,BRW54.Q.LOC:ProgressText)
  BRW54.AddField(MAT:AlternateRef,BRW54.Q.MAT:AlternateRef)
  BRW54.AddField(LOC:LinkedMatterRef,BRW54.Q.LOC:LinkedMatterRef)
  BRW54.AddField(MAT:RecordID,BRW54.Q.MAT:RecordID)
  BRW54.AddField(LOC:FICAWords,BRW54.Q.LOC:FICAWords)
  BRW54.AddField(PAR:Name,BRW54.Q.PAR:Name)
  BRW54.AddField(MAT:Description,BRW54.Q.MAT:Description)
  BRW54.AddField(MAT:LawRef,BRW54.Q.MAT:LawRef)
  BRW54.AddField(MT:Description,BRW54.Q.MT:Description)
  BRW54.AddField(DG:Description,BRW54.Q.DG:Description)
  BRW54.AddField(LOC:Employee,BRW54.Q.LOC:Employee)
  BRW54.AddField(MAT:DateInstructed,BRW54.Q.MAT:DateInstructed)
  BRW54.AddField(LOC:Status,BRW54.Q.LOC:Status)
  BRW54.AddField(MAT:DebtorsBalance,BRW54.Q.MAT:DebtorsBalance)
  BRW54.AddField(MT:RecordID,BRW54.Q.MT:RecordID)
  BRW54.AddField(MT:Color1,BRW54.Q.MT:Color1)
  BRW54.AddField(MT:Color2,BRW54.Q.MT:Color2)
  BRW54.AddField(MAT:ArchiveFlag,BRW54.Q.MAT:ArchiveFlag)
  BRW54.AddField(MAT:ArchiveNo,BRW54.Q.MAT:ArchiveNo)
  BRW54.AddField(MAT:ArchiveStatus,BRW54.Q.MAT:ArchiveStatus)
  BRW54.AddField(STA:RecordID,BRW54.Q.STA:RecordID)
  BRW54.AddField(MAT:ToDoGroupID,BRW54.Q.MAT:ToDoGroupID)
  BRW54.AddField(PAR:FICACompliantFlag,BRW54.Q.PAR:FICACompliantFlag)
  BRW54.AddField(LAW_MAT:LawRef,BRW54.Q.LAW_MAT:LawRef)
  BRW54.AddField(MAT:ConveyancingStatusFlag,BRW54.Q.MAT:ConveyancingStatusFlag)
  BRW54.AddField(MAT:MessageWaitingFlag,BRW54.Q.MAT:MessageWaitingFlag)
  BRW54.AddField(MAT:FNBMatterState,BRW54.Q.MAT:FNBMatterState)
  BRW54.AddField(MAT:ConsolidatedFlag,BRW54.Q.MAT:ConsolidatedFlag)
  BRW54.AddField(MAT:Actual,BRW54.Q.MAT:Actual)
  BRW54.AddField(MAT:Reserved,BRW54.Q.MAT:Reserved)
  BRW54.AddField(MAT:Invested,BRW54.Q.MAT:Invested)
  BRW54.AddField(MAT:LawSuite,BRW54.Q.MAT:LawSuite)
  BRW54.AddField(MAT:ABSALinkFlag,BRW54.Q.MAT:ABSALinkFlag)
  BRW54.AddField(CONV:Step4Completed,BRW54.Q.CONV:Step4Completed)
  BRW54.AddField(CONV:Step6Completed,BRW54.Q.CONV:Step6Completed)
  BRW54.AddField(MAT:EmployeeID,BRW54.Q.MAT:EmployeeID)
  BRW54.AddField(DG:Type,BRW54.Q.DG:Type)
  BRW54.AddField(MAT:ArchiveDate,BRW54.Q.MAT:ArchiveDate)
  BRW54.AddField(MAT:NTURequestDate,BRW54.Q.MAT:NTURequestDate)
  BRW54.AddField(MAT:NTUReceiveDate,BRW54.Q.MAT:NTUReceiveDate)
  BRW54.AddField(MAT:CancelToReAssignDate,BRW54.Q.MAT:CancelToReAssignDate)
  BRW54.AddField(MAT:LinkedMatterID,BRW54.Q.MAT:LinkedMatterID)
  BRW54.AddField(MAT3:RecordID,BRW54.Q.MAT3:RecordID)
  BRW54.AddField(DG:RecordID,BRW54.Q.DG:RecordID)
  BRW54.AddField(PAR:RecordID,BRW54.Q.PAR:RecordID)
  BRW52.Q &= Queue:Browse:4
  
  BRW52.AddSortOrder(,FIL:DateMatterDescendingKey)
  BRW52.AddResetField(BRW52::Filter)
  BRW52.AddSortOrder(,FIL:DateMatterKey)
  BRW52.AddResetField(BRW52::Filter)
  BIND('Tag',Tag)
  BIND('LOC:ProgressIndicator',LOC:ProgressIndicator)
  BIND('LOC:FileNotePostedFlag',LOC:FileNotePostedFlag)
  BIND('LOC:Employee',LOC:Employee)
  ?FileNoteBrowse{PROP:IconList,1} = '~BLANK.ICO'
  ?FileNoteBrowse{PROP:IconList,2} = '~CHECK.ICO'
  ?FileNoteBrowse{PROP:IconList,3} = '~bok.ico'
  ?FileNoteBrowse{PROP:IconList,4} = '~BLANK.ICO'
  BRW52.AddField(Tag,BRW52.Q.Tag)
  BRW52.AddField(LOC:ProgressIndicator,BRW52.Q.LOC:ProgressIndicator)
  BRW52.AddField(LOC:FileNotePostedFlag,BRW52.Q.LOC:FileNotePostedFlag)
  BRW52.AddField(FIL:Date,BRW52.Q.FIL:Date)
  BRW52.AddField(MAT1:FileRef,BRW52.Q.MAT1:FileRef)
  BRW52.AddField(MAT1:Description,BRW52.Q.MAT1:Description)
  BRW52.AddField(STA:Code,BRW52.Q.STA:Code)
  BRW52.AddField(FIL:Description,BRW52.Q.FIL:Description)
  BRW52.AddField(LOC:Employee,BRW52.Q.LOC:Employee)
  BRW52.AddField(STA:LargeIconFileName,BRW52.Q.STA:LargeIconFileName)
  BRW52.AddField(STA:SmallIconFileName,BRW52.Q.STA:SmallIconFileName)
  BRW52.AddField(FIL:InternalFlag,BRW52.Q.FIL:InternalFlag)
  BRW52.AddField(MAT1:Access,BRW52.Q.MAT1:Access)
  BRW52.AddField(MAT1:EmployeeID,BRW52.Q.MAT1:EmployeeID)
  BRW52.AddField(FIL:EmployeeID,BRW52.Q.FIL:EmployeeID)
  BRW52.AddField(FIL:FeeNoteID,BRW52.Q.FIL:FeeNoteID)
  BRW52.AddField(FIL:Color,BRW52.Q.FIL:Color)
  BRW52.AddField(FIL:RecordID,BRW52.Q.FIL:RecordID)
  BRW52.AddField(FIL:Time,BRW52.Q.FIL:Time)
  BRW52.AddField(FIL:MatterID,BRW52.Q.FIL:MatterID)
  BRW52.AddField(STA:RecordID,BRW52.Q.STA:RecordID)
  BRW52.AddField(MAT1:RecordID,BRW52.Q.MAT1:RecordID)
  BRW2.Q &= Queue:Browse
  
  BRW2.AddSortOrder(,FN:DateMatterKey)
  BRW2.AddResetField(BRW2::Filter)
  BIND('Tag',Tag)
  BIND('LOC:OnHold',LOC:OnHold)
  BIND('LOC:PostedFlag',LOC:PostedFlag)
  BIND('LOC:FeeDescription',LOC:FeeDescription)
  BIND('LOC:FN:AmountExcl',LOC:FN:AmountExcl)
  BIND('LOC:FN:VatDesc',LOC:FN:VatDesc)
  BIND('LOC:Employee',LOC:Employee)
  BIND('LOC:ColDebitWording',LOC:ColDebitWording)
  ?FeeNoteBrowse{PROP:IconList,1} = '~BLANK.ICO'
  ?FeeNoteBrowse{PROP:IconList,2} = '~CHECK.ICO'
  ?FeeNoteBrowse{PROP:IconList,3} = '~smmoney.ico'
  ?FeeNoteBrowse{PROP:IconList,4} = '~BLANK.ICO'
  ?FeeNoteBrowse{PROP:IconList,5} = '~block.ico'
  BRW2.AddField(Tag,BRW2.Q.Tag)
  BRW2.AddField(LOC:OnHold,BRW2.Q.LOC:OnHold)
  BRW2.AddField(LOC:PostedFlag,BRW2.Q.LOC:PostedFlag)
  BRW2.AddField(FN:Date,BRW2.Q.FN:Date)
  BRW2.AddField(MAT1:FileRef,BRW2.Q.MAT1:FileRef)
  BRW2.AddField(MAT1:Description,BRW2.Q.MAT1:Description)
  BRW2.AddField(PAR1:Name,BRW2.Q.PAR1:Name)
  BRW2.AddField(LOC:FeeDescription,BRW2.Q.LOC:FeeDescription)
  BRW2.AddField(LOC:FN:AmountExcl,BRW2.Q.LOC:FN:AmountExcl)
  BRW2.AddField(FN:VatAmount,BRW2.Q.FN:VatAmount)
  BRW2.AddField(FN:AmountIncl,BRW2.Q.FN:AmountIncl)
  BRW2.AddField(FN:CapturedPeriod,BRW2.Q.FN:CapturedPeriod)
  BRW2.AddField(LOC:FN:VatDesc,BRW2.Q.LOC:FN:VatDesc)
  BRW2.AddField(LOC:Employee,BRW2.Q.LOC:Employee)
  BRW2.AddField(FN:Voucher,BRW2.Q.FN:Voucher)
  BRW2.AddField(COS:Description,BRW2.Q.COS:Description)
  BRW2.AddField(LOC:ColDebitWording,BRW2.Q.LOC:ColDebitWording)
  BRW2.AddField(FN:PostedDate,BRW2.Q.FN:PostedDate)
  BRW2.AddField(FN:PostedBatchId,BRW2.Q.FN:PostedBatchId)
  BRW2.AddField(FN:RecordID,BRW2.Q.FN:RecordID)
  BRW2.AddField(FN:UnitFlag,BRW2.Q.FN:UnitFlag)
  BRW2.AddField(FN:UnitText,BRW2.Q.FN:UnitText)
  BRW2.AddField(FN:UnitQuantity,BRW2.Q.FN:UnitQuantity)
  BRW2.AddField(FN:Description,BRW2.Q.FN:Description)
  BRW2.AddField(FN:Type1,BRW2.Q.FN:Type1)
  BRW2.AddField(FN:EmployeeID,BRW2.Q.FN:EmployeeID)
  BRW2.AddField(MAT1:FeeNotesOnHold,BRW2.Q.MAT1:FeeNotesOnHold)
  BRW2.AddField(FN:OnHold,BRW2.Q.FN:OnHold)
  BRW2.AddField(FN:Amount,BRW2.Q.FN:Amount)
  BRW2.AddField(FN:VATRate,BRW2.Q.FN:VATRate)
  BRW2.AddField(FN:VATIE,BRW2.Q.FN:VATIE)
  BRW2.AddField(FN:ColDebitId,BRW2.Q.FN:ColDebitId)
  BRW2.AddField(FN:PostedFlag,BRW2.Q.FN:PostedFlag)
  BRW2.AddField(FN:CombinedQuantity,BRW2.Q.FN:CombinedQuantity)
  BRW2.AddField(FN:MatterID,BRW2.Q.FN:MatterID)
  BRW2.AddField(FN:CombinedFlag,BRW2.Q.FN:CombinedFlag)
  BRW2.AddField(MAT1:EmployeeID,BRW2.Q.MAT1:EmployeeID)
  BRW2.AddField(MAT1:Access,BRW2.Q.MAT1:Access)
  BRW2.AddField(FN:Sorter,BRW2.Q.FN:Sorter)
  BRW2.AddField(MAT1:RecordID,BRW2.Q.MAT1:RecordID)
  BRW2.AddField(PAR1:RecordID,BRW2.Q.PAR1:RecordID)
  BRW2.AddField(COS:RecordID,BRW2.Q.COS:RecordID)
  BRW15.Q &= Queue:Browse:3
  
  BRW15.AddSortOrder(,TOD:DateMatterKey)
  BRW15.AddResetField(BRW15::Filter)
  BIND('Tag',Tag)
  BIND('LOC:ProgressIndicator',LOC:ProgressIndicator)
  BIND('LOC:Employee',LOC:Employee)
  BIND('LOC:DaysTaken',LOC:DaysTaken)
  BIND('LOC:DaysDiff',LOC:DaysDiff)
  ?ToDoNoteBrowse{PROP:IconList,1} = '~BLANK.ICO'
  ?ToDoNoteBrowse{PROP:IconList,2} = '~CHECK.ICO'
  ?ToDoNoteBrowse{PROP:IconList,3} = '~star_red.ico'
  ?ToDoNoteBrowse{PROP:IconList,4} = '~star_yellow.ico'
  BRW15.AddField(Tag,BRW15.Q.Tag)
  BRW15.AddField(LOC:ProgressIndicator,BRW15.Q.LOC:ProgressIndicator)
  BRW15.AddField(TOD:Date,BRW15.Q.TOD:Date)
  BRW15.AddField(MAT1:FileRef,BRW15.Q.MAT1:FileRef)
  BRW15.AddField(MAT1:Description,BRW15.Q.MAT1:Description)
  BRW15.AddField(TOD:Description,BRW15.Q.TOD:Description)
  BRW15.AddField(LOC:Employee,BRW15.Q.LOC:Employee)
  BRW15.AddField(TOD:DateDone,BRW15.Q.TOD:DateDone)
  BRW15.AddField(TOD:CompletedTime,BRW15.Q.TOD:CompletedTime)
  BRW15.AddField(LOC:DaysTaken,BRW15.Q.LOC:DaysTaken)
  BRW15.AddField(LOC:DaysDiff,BRW15.Q.LOC:DaysDiff)
  BRW15.AddField(TOD:CreatedDate,BRW15.Q.TOD:CreatedDate)
  BRW15.AddField(TOD:CreatedTime,BRW15.Q.TOD:CreatedTime)
  BRW15.AddField(DOC:Description,BRW15.Q.DOC:Description)
  BRW15.AddField(TOI:Code,BRW15.Q.TOI:Code)
  BRW15.AddField(TOI:WebLinkMessage,BRW15.Q.TOI:WebLinkMessage)
  BRW15.AddField(TOI:FNBMessageNo,BRW15.Q.TOI:FNBMessageNo)
  BRW15.AddField(TOD:AutoNotifyDate,BRW15.Q.TOD:AutoNotifyDate)
  BRW15.AddField(TOI:CriticalStep,BRW15.Q.TOI:CriticalStep)
  BRW15.AddField(TOI:AutoNotifyFlag,BRW15.Q.TOI:AutoNotifyFlag)
  BRW15.AddField(TOI:AutoNotifyMessage,BRW15.Q.TOI:AutoNotifyMessage)
  BRW15.AddField(TOI:Description,BRW15.Q.TOI:Description)
  BRW15.AddField(TOD:ToDoItemID,BRW15.Q.TOD:ToDoItemID)
  BRW15.AddField(TOD:PartyID,BRW15.Q.TOD:PartyID)
  BRW15.AddField(DOC:RecordID,BRW15.Q.DOC:RecordID)
  BRW15.AddField(MAT1:DateInstructed,BRW15.Q.MAT1:DateInstructed)
  BRW15.AddField(TOI:BaseDateOption,BRW15.Q.TOI:BaseDateOption)
  BRW15.AddField(TOI:Days,BRW15.Q.TOI:Days)
  BRW15.AddField(TOI:BaseDateOptionOther,BRW15.Q.TOI:BaseDateOptionOther)
  BRW15.AddField(TOI:BeforeAfterOption,BRW15.Q.TOI:BeforeAfterOption)
  BRW15.AddField(TOI:BaseDateOtherID,BRW15.Q.TOI:BaseDateOtherID)
  BRW15.AddField(TOD:DateAdjustment,BRW15.Q.TOD:DateAdjustment)
  BRW15.AddField(TOD:EmployeeID,BRW15.Q.TOD:EmployeeID)
  BRW15.AddField(CRI:LargeIconFileName,BRW15.Q.CRI:LargeIconFileName)
  BRW15.AddField(CRI:RecordID,BRW15.Q.CRI:RecordID)
  BRW15.AddField(CRI:SmallIconFileName,BRW15.Q.CRI:SmallIconFileName)
  BRW15.AddField(TOD:Priority,BRW15.Q.TOD:Priority)
  BRW15.AddField(TOD:RecordID,BRW15.Q.TOD:RecordID)
  BRW15.AddField(TOD:MatterID,BRW15.Q.TOD:MatterID)
  BRW15.AddField(MAT1:RecordID,BRW15.Q.MAT1:RecordID)
  BRW15.AddField(TOI:RecordID,BRW15.Q.TOI:RecordID)
  BRW22.Q &= Queue:Browse:5
  
  BRW22.AddSortOrder(,MA:DateMatterKey)
  BRW22.AddResetField(BRW22::Filter)
  BIND('Tag',Tag)
  BIND('LOC:Billable',LOC:Billable)
  BIND('LOC:MA_HoursAndMinutes',LOC:MA_HoursAndMinutes)
  BIND('LOC:Employee',LOC:Employee)
  ?TimeRecordingBrowse{PROP:IconList,1} = '~BLANK.ICO'
  ?TimeRecordingBrowse{PROP:IconList,2} = '~CHECK.ICO'
  ?TimeRecordingBrowse{PROP:IconList,3} = '~bok.ico'
  ?TimeRecordingBrowse{PROP:IconList,4} = '~smmoney.ico'
  ?TimeRecordingBrowse{PROP:IconList,5} = '~blank.ico'
  BRW22.AddField(Tag,BRW22.Q.Tag)
  BRW22.AddField(LOC:Billable,BRW22.Q.LOC:Billable)
  BRW22.AddField(MA:Date,BRW22.Q.MA:Date)
  BRW22.AddField(MAT1:FileRef,BRW22.Q.MAT1:FileRef)
  BRW22.AddField(MAT1:Description,BRW22.Q.MAT1:Description)
  BRW22.AddField(ACT:Description,BRW22.Q.ACT:Description)
  BRW22.AddField(MA:Description,BRW22.Q.MA:Description)
  BRW22.AddField(LOC:MA_HoursAndMinutes,BRW22.Q.LOC:MA_HoursAndMinutes)
  BRW22.AddField(MA:BillableAmount,BRW22.Q.MA:BillableAmount)
  BRW22.AddField(LOC:Employee,BRW22.Q.LOC:Employee)
  BRW22.AddField(COS:Description,BRW22.Q.COS:Description)
  BRW22.AddField(MA:EmployeeID,BRW22.Q.MA:EmployeeID)
  BRW22.AddField(MA:MatterID,BRW22.Q.MA:MatterID)
  BRW22.AddField(MA:Sorter,BRW22.Q.MA:Sorter)
  BRW22.AddField(MA:BillableFlag,BRW22.Q.MA:BillableFlag)
  BRW22.AddField(MA:FeeNoteID,BRW22.Q.MA:FeeNoteID)
  BRW22.AddField(MA:RecordID,BRW22.Q.MA:RecordID)
  BRW22.AddField(MA:Minutes,BRW22.Q.MA:Minutes)
  BRW22.AddField(MAT1:EmployeeID,BRW22.Q.MAT1:EmployeeID)
  BRW22.AddField(MAT1:Access,BRW22.Q.MAT1:Access)
  BRW22.AddField(FN1:PostedFlag,BRW22.Q.FN1:PostedFlag)
  BRW22.AddField(MAT1:RecordID,BRW22.Q.MAT1:RecordID)
  BRW22.AddField(COS:RecordID,BRW22.Q.COS:RecordID)
  BRW22.AddField(ACT:RecordID,BRW22.Q.ACT:RecordID)
  BRW36.Q &= Queue:Browse:2
  
  BRW36.AddSortOrder(,MME:MatterKey)
  BRW36.AddLocator(BRW36::Sort0:Locator)
  BRW36::Sort0:Locator.Init(,MME:MatterID,,BRW36)
  BRW36.AddResetField(BRW36::Filter)
  BIND('Tag',Tag)
  BIND('LOC:ToFrom',LOC:ToFrom)
  ?LawMatterMessageBrowse{PROP:IconList,1} = '~BLANK.ICO'
  ?LawMatterMessageBrowse{PROP:IconList,2} = '~CHECK.ICO'
  BRW36.AddField(Tag,BRW36.Q.Tag)
  BRW36.AddField(MME:ClarionDate,BRW36.Q.MME:ClarionDate)
  BRW36.AddField(MAT1:FileRef,BRW36.Q.MAT1:FileRef)
  BRW36.AddField(MAT1:Description,BRW36.Q.MAT1:Description)
  BRW36.AddField(MAT1:LawRef,BRW36.Q.MAT1:LawRef)
  BRW36.AddField(LOC:ToFrom,BRW36.Q.LOC:ToFrom)
  BRW36.AddField(LAW_MSG:Number,BRW36.Q.LAW_MSG:Number)
  BRW36.AddField(LAW_MSG:Message,BRW36.Q.LAW_MSG:Message)
  BRW36.AddField(MME:FileName,BRW36.Q.MME:FileName)
  BRW36.AddField(MME:WebServiceValidatorId,BRW36.Q.MME:WebServiceValidatorId)
  BRW36.AddField(MME:WebServiceValidatorStatus,BRW36.Q.MME:WebServiceValidatorStatus)
  BRW36.AddField(LAW_MSG:Filter,BRW36.Q.LAW_MSG:Filter)
  BRW36.AddField(MME:RecordID,BRW36.Q.MME:RecordID)
  BRW36.AddField(MME:MatterID,BRW36.Q.MME:MatterID)
  BRW36.AddField(MME:Date,BRW36.Q.MME:Date)
  BRW36.AddField(MAT1:RecordID,BRW36.Q.MAT1:RecordID)
  BRW36.AddField(LAW_MSG:RecordID,BRW36.Q.LAW_MSG:RecordID)
  BRW46.Q &= Queue:Browse:7
  
  BRW46.AddSortOrder(,AGMM:MatterKey)
  BRW46.AddSortOrder(,AGMM:DateTimeKey)
  BIND('LOC:Branch',LOC:Branch)
  BIND('LOC:Employee',LOC:Employee)
  BRW46.AddField(AGMM:Date,BRW46.Q.AGMM:Date)
  BRW46.AddField(AGMM:Time,BRW46.Q.AGMM:Time)
  BRW46.AddField(MAT1:FileRef,BRW46.Q.MAT1:FileRef)
  BRW46.AddField(MAT1:Description,BRW46.Q.MAT1:Description)
  BRW46.AddField(LOC:Branch,BRW46.Q.LOC:Branch)
  BRW46.AddField(DG1:Code,BRW46.Q.DG1:Code)
  BRW46.AddField(LAW_SUI:Description,BRW46.Q.LAW_SUI:Description)
  BRW46.AddField(LOC:Employee,BRW46.Q.LOC:Employee)
  BRW46.AddField(AGM:MessageID,BRW46.Q.AGM:MessageID)
  BRW46.AddField(AGM:Description,BRW46.Q.AGM:Description)
  BRW46.AddField(AGM:Direction,BRW46.Q.AGM:Direction)
  BRW46.AddField(AGMM:Details,BRW46.Q.AGMM:Details)
  BRW46.AddField(MAT1:BranchID,BRW46.Q.MAT1:BranchID)
  BRW46.AddField(AGMM:EmployeeID,BRW46.Q.AGMM:EmployeeID)
  BRW46.AddField(MAT1:LawSuite,BRW46.Q.MAT1:LawSuite)
  BRW46.AddField(AGMM:RecordID,BRW46.Q.AGMM:RecordID)
  BRW46.AddField(AGMM:MatterID,BRW46.Q.AGMM:MatterID)
  BRW46.AddField(AGM:RecordID,BRW46.Q.AGM:RecordID)
  BRW46.AddField(MAT1:RecordID,BRW46.Q.MAT1:RecordID)
  BRW46.AddField(LAW_SUI:SuiteID,BRW46.Q.LAW_SUI:SuiteID)
  BRW35.Q &= Queue:Browse:9
  
  BRW35.AddSortOrder(,ABMM:MatterKey)
  BRW35.AddSortOrder(,ABMM:DateTimeKey)
  BIND('LOC:Branch',LOC:Branch)
  BIND('LOC:Employee',LOC:Employee)
  BRW35.AddField(ABMM:Date,BRW35.Q.ABMM:Date)
  BRW35.AddField(ABMM:Time,BRW35.Q.ABMM:Time)
  BRW35.AddField(MAT1:FileRef,BRW35.Q.MAT1:FileRef)
  BRW35.AddField(MAT1:Description,BRW35.Q.MAT1:Description)
  BRW35.AddField(LOC:Branch,BRW35.Q.LOC:Branch)
  BRW35.AddField(DG1:Code,BRW35.Q.DG1:Code)
  BRW35.AddField(LOC:Employee,BRW35.Q.LOC:Employee)
  BRW35.AddField(ABMM:MessageNumber,BRW35.Q.ABMM:MessageNumber)
  BRW35.AddField(ABMM:MessageDescription,BRW35.Q.ABMM:MessageDescription)
  BRW35.AddField(ABMM:MessageDirection,BRW35.Q.ABMM:MessageDirection)
  BRW35.AddField(ABMM:Details,BRW35.Q.ABMM:Details)
  BRW35.AddField(MAT1:BranchID,BRW35.Q.MAT1:BranchID)
  BRW35.AddField(ABMM:EmployeeID,BRW35.Q.ABMM:EmployeeID)
  BRW35.AddField(ABMM:RecordID,BRW35.Q.ABMM:RecordID)
  BRW35.AddField(ABMM:MatterID,BRW35.Q.ABMM:MatterID)
  BRW35.AddField(MAT1:RecordID,BRW35.Q.MAT1:RecordID)
  BRW33.Q &= Queue:Browse:11
  
  BRW33.AddSortOrder(,SMM:MatterKey)
  BRW33.AddLocator(BRW33::Sort0:Locator)
  BRW33::Sort0:Locator.Init(,SMM:MatterID,,BRW33)
  BIND('LOC:Employee',LOC:Employee)
  BRW33.AddField(SMM:Date,BRW33.Q.SMM:Date)
  BRW33.AddField(SMM:Time,BRW33.Q.SMM:Time)
  BRW33.AddField(MAT1:FileRef,BRW33.Q.MAT1:FileRef)
  BRW33.AddField(LOC:Employee,BRW33.Q.LOC:Employee)
  BRW33.AddField(SMM:Description,BRW33.Q.SMM:Description)
  BRW33.AddField(SMM:TD_ReferenceNumber,BRW33.Q.SMM:TD_ReferenceNumber)
  BRW33.AddField(SMM:Status,BRW33.Q.SMM:Status)
  BRW33.AddField(SMM:ErrorMessage,BRW33.Q.SMM:ErrorMessage)
  BRW33.AddField(MAT1:RecordID,BRW33.Q.MAT1:RecordID)
  BRW33.AddField(SMM:EmployeeID,BRW33.Q.SMM:EmployeeID)
  BRW33.AddField(SMM:RecordID,BRW33.Q.SMM:RecordID)
  BRW33.AddField(SMM:MatterID,BRW33.Q.SMM:MatterID)
  Resizer.Init(AppStrategy:Surface)
  SELF.AddItem(Resizer)
   IF GLO:LowResolutionFlag

      CEM:WindowWidth = 560
      CEM:WindowHeight = 290

   ELSE

      IF CEM:AutoSizeDesktopWindow
           CEM:WindowWidth = GetSystemMetrics(0) * 0.5 !0.60
           CEM:WindowHeight = (GetSystemMetrics(1) * 0.4) - 5 !0.45
      END

      IF ~CEM:WindowWidth AND ~CEM:WindowHeight         
          CEM:WindowWidth = GetSystemMetrics(0) * 0.5 !0.60
          CEM:WindowHeight = (GetSystemMetrics(1) * 0.4) - 5 !0.45
      END

   END

   IF CEM:WindowWidth
      QuickWindow{PROP:Width} = CEM:WindowWidth
      ?CurrentTab{PROP:Width} = CEM:WindowWidth - 8
      ?Group1{PROP:Width} = CEM:WindowWidth - 8
   END

   IF CEM:WindowHeight
      QuickWindow{PROP:Height} = CEM:WindowHeight
      ?CurrentTab{PROP:Height} = CEM:WindowHeight - 15
   END

   QuickWindow{PROP:Center} = True


   !DEBUG('CEM:WindowHeight = ' & CEM:WindowHeight & '|CEM:WindowWidth = ' & CEM:WindowWidth)
  
  
       LOC:SortKey54 = 5
       LOC:PreSortKey54 = LOC:SortKey54
       LOC:PreHeader54 = ?MattersBrowse{PROPLIST:Header,LOC:SortKey54}
       ?MattersBrowse{PROPLIST:Header,LOC:SortKey54} = '[+] ' & ?MattersBrowse{PROPLIST:Header,LOC:SortKey54}
       LOC:SortKey52 = 4
       LOC:PreSortKey52 = LOC:SortKey52
       LOC:PreHeader52 = ?FileNoteBrowse{PROPLIST:Header,LOC:SortKey52}
       ?FileNoteBrowse{PROPLIST:Header,LOC:SortKey52} = '[+] ' & ?FileNoteBrowse{PROPLIST:Header,LOC:SortKey52}
    BRW46.Popup.AddItemMimic('&Print', ?Print)
    BRW35.Popup.AddItemMimic('&Print', ?Print:4)
  BRW2.AskProcedure = 1
  BRW15.AskProcedure = 2
  BRW22.AskProcedure = 3
  BRW36.AskProcedure = 4
  BRW46.AskProcedure = 5
  BRW52.AskProcedure = 6
  BRW54.AskProcedure = 7
  BRW35.AskProcedure = 8
  BRW33.AskProcedure = 9
   ! ENABLE OR DISABLE FILENOTE DATE SORTING
   IF CEM:FileNotesDescendingFlag
      LOC:SortKey52 = -4
      ?FileNoteBrowse{PROPLIST:Header,ABS(LOC:SortKey52)} = '[-] ' & LOC:PreHeader52
      BRW52.SetSort(1,0)
   ELSE
      LOC:SortKey52 = 4
      ?FileNoteBrowse{PROPLIST:Header,ABS(LOC:SortKey52)} = LOC:PreHeader52
      BRW52.SetSort(2,0)
   END
   LOC:PreSortKey52 = LOC:SortKey52


  SAV:SortKey54 = LOC:SortKey54
  BRW54.AddToolbarTarget(Toolbar)
  BRW52.AddToolbarTarget(Toolbar)
  BRW2.AddToolbarTarget(Toolbar)
  BRW15.AddToolbarTarget(Toolbar)
  BRW22.AddToolbarTarget(Toolbar)
  BRW36.AddToolbarTarget(Toolbar)
  BRW46.AddToolbarTarget(Toolbar)
  BRW35.AddToolbarTarget(Toolbar)
  BRW33.AddToolbarTarget(Toolbar)
       BRW54.AddSortOrder(,)
       BRW54.AppendOrder('MAT:DebtorsBalance,MAT:RecordID')
       BRW54.AddSortOrder(,)
       BRW54.AppendOrder('-MAT:DebtorsBalance,MAT:RecordID')
      ?MattersBrowse{Prop:Alrt,256} = MouseLeft  !Alert Key used with Push Button Sort.
      ?FileNoteBrowse{Prop:Alrt,256} = MouseLeft  !Alert Key used with Push Button Sort.
  SELF.SetAlerts()
    ThisSecProc.SetFields()
  BRW15.Popup.SetLevel(BRW15.Popup.AddItem('-', 'STAG::Separator1'),1)
  BRW15.Popup.SetLevel(BRW15.Popup.AddItemMimic('TagOne', ?TagOne:4),1)
  BRW15.Popup.SetLevel(BRW15.Popup.AddItemMimic('UntagOne', ?UntagOne:4),1)
  BRW15.Popup.SetLevel(BRW15.Popup.AddItem('-', 'STAG::Separator2'),1)
  BRW15.Popup.SetLevel(BRW15.Popup.AddItemMimic('TagAll', ?TagAll:4),1)
  BRW15.Popup.SetLevel(BRW15.Popup.AddItemMimic('UntagAll', ?UntagAll:4),1)
  BRW22.Popup.SetLevel(BRW22.Popup.AddItem('-', 'STAG::Separator1'),1)
  BRW22.Popup.SetLevel(BRW22.Popup.AddItemMimic('TagOne', ?TagOne:5),1)
  BRW22.Popup.SetLevel(BRW22.Popup.AddItemMimic('UntagOne', ?UntagOne:5),1)
  BRW22.Popup.SetLevel(BRW22.Popup.AddItem('-', 'STAG::Separator2'),1)
  BRW22.Popup.SetLevel(BRW22.Popup.AddItemMimic('TagAll', ?TagAll:5),1)
  BRW22.Popup.SetLevel(BRW22.Popup.AddItemMimic('UntagAll', ?UntagAll:5),1)
  BRW2.Popup.SetLevel(BRW2.Popup.AddItem('-', 'STAG::Separator1'),1)
  BRW2.Popup.SetLevel(BRW2.Popup.AddItemMimic('TagOne', ?TagOne:2),1)
  BRW2.Popup.SetLevel(BRW2.Popup.AddItemMimic('UntagOne', ?UntagOne:2),1)
  BRW2.Popup.SetLevel(BRW2.Popup.AddItem('-', 'STAG::Separator2'),1)
  BRW2.Popup.SetLevel(BRW2.Popup.AddItemMimic('TagAll', ?TagAll:2),1)
  BRW2.Popup.SetLevel(BRW2.Popup.AddItemMimic('UntagAll', ?UntagAll:2),1)
  BRW36.Popup.SetLevel(BRW36.Popup.AddItem('-', 'STAG::Separator1'),1)
  BRW36.Popup.SetLevel(BRW36.Popup.AddItemMimic('TagOne', ?TagOne:6),1)
  BRW36.Popup.SetLevel(BRW36.Popup.AddItemMimic('UntagOne', ?UntagOne:6),1)
  BRW36.Popup.SetLevel(BRW36.Popup.AddItem('-', 'STAG::Separator2'),1)
  BRW36.Popup.SetLevel(BRW36.Popup.AddItemMimic('TagAll', ?TagAll:6),1)
  BRW36.Popup.SetLevel(BRW36.Popup.AddItemMimic('UntagAll', ?UntagAll:6),1)
  BRW52.Popup.SetLevel(BRW52.Popup.AddItem('-', 'STAG::Separator1'),1)
  BRW52.Popup.SetLevel(BRW52.Popup.AddItemMimic('TagOne', ?TagOne:3),1)
  BRW52.Popup.SetLevel(BRW52.Popup.AddItemMimic('UntagOne', ?UntagOne:3),1)
  BRW52.Popup.SetLevel(BRW52.Popup.AddItem('-', 'STAG::Separator2'),1)
  BRW52.Popup.SetLevel(BRW52.Popup.AddItemMimic('TagAll', ?TagAll:3),1)
  BRW52.Popup.SetLevel(BRW52.Popup.AddItemMimic('UntagAll', ?UntagAll:3),1)
  BRW54.Popup.SetLevel(BRW54.Popup.AddItem('-', 'STAG::Separator1'),1)
  BRW54.Popup.SetLevel(BRW54.Popup.AddItemMimic('TagOne', ?TagOne),1)
  BRW54.Popup.SetLevel(BRW54.Popup.AddItemMimic('UntagOne', ?UntagOne),1)
  BRW54.Popup.SetLevel(BRW54.Popup.AddItemMimic('FlipOne', ?FlipOne),1)
  BRW54.Popup.SetLevel(BRW54.Popup.AddItem('-', 'STAG::Separator2'),1)
  BRW54.Popup.SetLevel(BRW54.Popup.AddItemMimic('TagAll', ?TagAll),1)
  BRW54.Popup.SetLevel(BRW54.Popup.AddItemMimic('UntagAll', ?UntagAll),1)
  BRW54.Popup.SetLevel(BRW54.Popup.AddItemMimic('FlipAll', ?FlipAll),1)
  BRW46.Popup.SetLevel(BRW46.Popup.AddItem('-', 'BRW46.Separator1'),1)
  BRW46.Popup.SetLevel(BRW46.Popup.AddItemMimic('Change the Matter State', ?ChangeMatterStateButton),1)
  BRW46.Popup.SetLevel(BRW46.Popup.AddItem('-', 'BRW46.Separator2'),1)
  BRW46.Popup.SetLevel(BRW46.Popup.AddItemMimic('Make Config File', ?MakeConfigButton),1)
  BRW46.Popup.SetLevel(BRW46.Popup.AddItem('-', 'BRW46.Separator3'),1)
  BRW46.Popup.SetLevel(BRW46.Popup.AddItemMimic('Specify Schema Location', ?MakeConfigButton:2),1)



  IF GLO:TimeRecordingFlag
     BRW52.Popup.AddItemMimic('&Create a Time Record',?MakeFeeNoteButton)
  ELSE
     BRW52.Popup.AddItemMimic('&Make a Fee Note',?MakeFeeNoteButton)
  END


  BRW15.Popup.AddItem('-', 'BRW15.Separator1')

  BRW15.Popup.AddItemMimic('&My Reminders [Incomplete] (ALT F2)',?MyRemindersButton)
  BRW15.Popup.AddItemMimic('&Current Matter''s Reminders [Incomplete] (ALT F3)',?CurrentMatterRemindersButton)
  BRW15.Popup.AddItemMimic('&Current Matter''s Reminders [All] (ALT F4)',?AllCurrentMatterRemindersButton)

  BRW15.Popup.SetLevel(BRW15.Popup.AddItem('-', 'BRW15.ExportSeparator121'),1)

  BRW15.Popup.AddItemMimic('Make a &Task in OutLook (F5)',?MakeOutLookTaskButton)
  BRW15.Popup.AddItemMimic('Make an &Appointment in OutLook (F6)',?MakeOutLookAppointmentButton)
  BRW15.Popup.SetLevel(BRW15.Popup.AddItem('-', 'BRW15.ExportSeparator12331'),1)

  BRW15.Popup.AddItemMimic('Reload Plan of Action Items', ?ReloadPlanOfActionButton)

  BRW15.Popup.AddItem('-', 'BRW15.Separator2')
  BRW15.Popup.AddItemMimic('&Refresh Reminders',?RefreshRemindersButton)

  BRW15.Popup.AddItem('-', 'BRW15.Separator3')
  BRW15.Popup.AddItemMimic('&Optional Reminders',?OptionalRemindersButton)

  BRW2.Popup.SetLevel(BRW2.Popup.AddItem('-', 'BRW2.Separator1'),1)
  BRW2.Popup.AddItemMimic('Tag &Fees', ?TagFeesButton)
  BRW2.Popup.AddItemMimic('Tag &Disbursements', ?TagDisbursementsButton)
  BRW2.Popup.SetLevel(BRW2.Popup.AddItem('-', 'BRW2.Separator3'),1)
  BRW2.Popup.AddItemMimic('&Adjust Tagged Fees On Hold',?AdjustFeesButton)
  BRW2.Popup.AddItemMimic('&Adjust Vat Rate',?AdjustVatRateButton)
  BRW2.Popup.AddItemMimic('&Update Voucher On Tagged Fees',?UpdateVoucherButton)
  BRW2.Popup.AddItemMimic('&Put Tagged Fees On Hold', ?OnHoldButton)
  BRW2.Popup.AddItemMimic('&Take Tagged Fees Off Hold', ?OffHoldButton)
  BRW2.Popup.AddItemMimic('&Remove from Proforma Account', ?ClearProformaIDButton)
  BRW2.Popup.SetLevel(BRW2.Popup.AddItem('-', 'BRW2.Separator4'),1)
  BRW2.Popup.AddItemMimic('Co&mbine Tagged Items', ?CombineFeesButton)
  BRW2.Popup.AddItemMimic('Cop&y to Debtor''s Account', ?CopyToDebtorButton)
  BRW2.Popup.AddItemMimic('&Import from Ledger',?ImportFromLedgerButton)
  BRW2.Popup.AddItemMimic('Adjust FeeNotes', ?AdjustFeenotes)

  BRW2.Popup.SetLevel(BRW2.Popup.AddItem('-', 'BRW2.ExportSeparator1'),1)
  BRW15.Popup.SetLevel(BRW15.Popup.AddItem('-', 'BRW15.ExportSeparator1'),1)
  BRW22.Popup.SetLevel(BRW22.Popup.AddItem('-', 'BRW22.ExportSeparator1'),1)
  BRW52.Popup.SetLevel(BRW52.Popup.AddItem('-', 'BRW52.ExportSeparator1'),1)
  BRW36.Popup.SetLevel(BRW36.Popup.AddItem('-', 'BRW36.ExportSeparator1'),1)

  BRW2.Popup.AddItemMimic('&Export Tagged Items',?ExportFeenoteButton)
  BRW15.Popup.AddItemMimic('&Export Tagged Items',?ExportToDoNoteButton)
  BRW52.Popup.AddItemMimic('&Export Tagged Items',?ExportFileNoteButton)
  BRW22.Popup.AddItemMimic('&Export Tagged Items',?ExportMatActivButton)
  BRW36.Popup.AddItemMimic('&Export Tagged Items',?ExportDataLinkButton)

  BRW22.Popup.AddItemMimic('&Adjust Time',?AdjustTimeButton)
  BRW22.Popup.SetLevel(BRW22.Popup.AddItem('-', 'BRW22.Separator121'),1)
  BRW22.Popup.AddItemMimic('C&reate Fee Notes',?CreateFeeNotesFromMAButton)
  BRW22.Popup.AddItemMimic('Change &Billing Rate',?ChangeBillingRateButton)

  BRW52.Popup.SetLevel(BRW52.Popup.AddItem('-', 'BRW52.Separator121'),1)
  BRW52.Popup.AddItemMimic('Make Internal',?MakeInternalButton)
  BRW52.Popup.AddItemMimic('Make External',?MakeExternalButton)


      ?FeeNoteBrowse{PROP:FontColor} = ColorText:7#
      ?FeeNoteBrowse{PROP:Background} = ColorBackground:7#
      ?FeeNoteBrowse{PROP:SelectedColor} = ColorSelText:7#
      ?FeeNoteBrowse{PROP:SelectedFillColor} = ColorSelBackground:7#
      ?FeeNoteBrowse{PROPLIST:GRID} = ColorGrid:7#
      ?FileNoteBrowse{PROP:FontColor} = ColorText:7#
      ?FileNoteBrowse{PROP:Background} = ColorBackground:7#
      ?FileNoteBrowse{PROP:SelectedColor} = ColorSelText:7#
      ?FileNoteBrowse{PROP:SelectedFillColor} = ColorSelBackground:7#
      ?FileNoteBrowse{PROPLIST:GRID} = ColorGrid:7#
      ?ToDoNoteBrowse{PROP:FontColor} = ColorText:7#
      ?ToDoNoteBrowse{PROP:Background} = ColorBackground:7#
      ?ToDoNoteBrowse{PROP:SelectedColor} = ColorSelText:7#
      ?ToDoNoteBrowse{PROP:SelectedFillColor} = ColorSelBackground:7#
      ?ToDoNoteBrowse{PROPLIST:GRID} = ColorGrid:7#
      ?TimeRecordingBrowse{PROP:FontColor} = ColorText:7#
      ?TimeRecordingBrowse{PROP:Background} = ColorBackground:7#
      ?TimeRecordingBrowse{PROP:SelectedColor} = ColorSelText:7#
      ?TimeRecordingBrowse{PROP:SelectedFillColor} = ColorSelBackground:7#
      ?TimeRecordingBrowse{PROPLIST:GRID} = ColorGrid:7#
      ?LawMatterMessageBrowse{PROP:FontColor} = ColorText:7#
      ?LawMatterMessageBrowse{PROP:Background} = ColorBackground:7#
      ?LawMatterMessageBrowse{PROP:SelectedColor} = ColorSelText:7#
      ?LawMatterMessageBrowse{PROP:SelectedFillColor} = ColorSelBackground:7#
      ?LawMatterMessageBrowse{PROPLIST:GRID} = ColorGrid:7#
      ?FNBLinkBrowse{PROP:FontColor} = ColorText:7#
      ?FNBLinkBrowse{PROP:Background} = ColorBackground:7#
      ?FNBLinkBrowse{PROP:SelectedColor} = ColorSelText:7#
      ?FNBLinkBrowse{PROP:SelectedFillColor} = ColorSelBackground:7#
      ?FNBLinkBrowse{PROPLIST:GRID} = ColorGrid:7#
      ?ABSALinkBrowse{PROP:FontColor} = ColorText:7#
      ?ABSALinkBrowse{PROP:Background} = ColorBackground:7#
      ?ABSALinkBrowse{PROP:SelectedColor} = ColorSelText:7#
      ?ABSALinkBrowse{PROP:SelectedFillColor} = ColorSelBackground:7#
      ?ABSALinkBrowse{PROPLIST:GRID} = ColorGrid:7#
      ?MattersBrowse{PROP:FontColor} = ColorText:7#
      ?MattersBrowse{PROP:Background} = ColorBackground:7#
      ?MattersBrowse{PROP:SelectedColor} = ColorSelText:7#
      ?MattersBrowse{PROP:SelectedFillColor} = ColorSelBackground:7#
      ?MattersBrowse{PROPLIST:GRID} = ColorGrid:7#
      ?SARSLinkBrowse{PROP:FontColor} = ColorText:7#
      ?SARSLinkBrowse{PROP:Background} = ColorBackground:7#
      ?SARSLinkBrowse{PROP:SelectedColor} = ColorSelText:7#
      ?SARSLinkBrowse{PROP:SelectedFillColor} = ColorSelBackground:7#
      ?SARSLinkBrowse{PROPLIST:GRID} = ColorGrid:7#
  SAV:LOC:FilterMatterString = LOC:FilterMatterString
  SAV:LOC:TaggedMatterList = LOC:TaggedMatterList

  DO ResetColumnWidths

  DO ToggleMatterIcons
  DO ToggleFileNoteIcons
  DO ToggleToDoNoteIcons

  Toolbar.SetTarget(?MattersBrowse)
       Clear(SP:Record)
       SP:SecGroupId = GLO:SecGroupId
       SP:Description = 'Matters - Desktop - View All Employees'
       If Access:SecProc.TryFetch(SP:SecGroupKey)
         SP:AccessFlag = False
         Access:SecProc.Insert()
       END
       LOC:ViewAllEmployeeDesc = SP:Description
       If GLO:SupervisorFlag Then LOC:ViewAllEmployeeData = True Else LOC:ViewAllEmployeeData = SP:AccessFlag.
       
  
    If ~CEM:NoticeFlag Then ThisNotice.Init.
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  
   Access:EmpDisplaySettings.Open
   Access:EmpDisplaySettings.UseFile
  
  
  CLEAR(EDS:Record)
  EDS:EmployeeID = CEM:recordID
   IF Access:EmpDisplaySettings.TryFetch(EDS:PrimaryKey)
      CLEAR(EDS:Record)
      EDS:EmployeeID = CEM:RecordID
      Access:EmpDisplaySettings.Insert
   END
  
  
  
  EDS:EmployeeID = CEM:RecordID
  EDS:DesktopMatterColumn1 = ?MattersBrowse{PROPLIST:Width,1}
  EDS:DesktopMatterColumn2 = ?MattersBrowse{PROPLIST:Width,2}
  EDS:DesktopMatterColumn3 = ?MattersBrowse{PROPLIST:Width,3}
  EDS:DesktopMatterColumn4 = ?MattersBrowse{PROPLIST:Width,4}
  EDS:DesktopMatterColumn5 = ?MattersBrowse{PROPLIST:Width,5}
  EDS:DesktopMatterColumn6 = ?MattersBrowse{PROPLIST:Width,6}
  EDS:DesktopMatterColumn7 = ?MattersBrowse{PROPLIST:Width,7}
  EDS:DesktopMatterColumn8 = ?MattersBrowse{PROPLIST:Width,8}
  EDS:DesktopMatterColumn9 = ?MattersBrowse{PROPLIST:Width,9}
  EDS:DesktopMatterColumn10 = ?MattersBrowse{PROPLIST:Width,10}
  EDS:DesktopMatterColumn11 = ?MattersBrowse{PROPLIST:Width,11}
  EDS:DesktopMatterColumn12 = ?MattersBrowse{PROPLIST:Width,12}
  EDS:DesktopMatterColumn13 = ?MattersBrowse{PROPLIST:Width,13}
  EDS:DesktopMatterColumn14 = ?MattersBrowse{PROPLIST:Width,14}
  EDS:DesktopMatterColumn15 = ?MattersBrowse{PROPLIST:Width,15}
  EDS:DesktopMatterColumn16 = ?MattersBrowse{PROPLIST:Width,16}
  EDS:DesktopMatterColumn17 = ?MattersBrowse{PROPLIST:Width,17}
  EDS:DesktopMatterColumn18 = ?MattersBrowse{PROPLIST:Width,18}
  EDS:DesktopMatterColumn19 = ?MattersBrowse{PROPLIST:Width,19}   !FB1902
  
  EDS:DesktopFeeNoteColumn1 = ?FeeNoteBrowse{PROPLIST:Width,1}
  EDS:DesktopFeeNoteColumn2 = ?FeeNoteBrowse{PROPLIST:Width,2}
  EDS:DesktopFeeNoteColumn3 = ?FeeNoteBrowse{PROPLIST:Width,3}
  EDS:DesktopFeeNoteColumn4 = ?FeeNoteBrowse{PROPLIST:Width,4}
  
  IF LOC:FN_Matter <> 'Current'
     EDS:DesktopFeeNoteColumn5 = ?FeeNoteBrowse{PROPLIST:Width,5}
     EDS:DesktopFeeNoteColumn6 = ?FeeNoteBrowse{PROPLIST:Width,6}
  END
  
  EDS:DesktopFeeNoteColumn7 = ?FeeNoteBrowse{PROPLIST:Width,7}
  EDS:DesktopFeeNoteColumn8 = ?FeeNoteBrowse{PROPLIST:Width,8}
  EDS:DesktopFeeNoteColumn9 = ?FeeNoteBrowse{PROPLIST:Width,9}
  EDS:DesktopFeeNoteColumn10 = ?FeeNoteBrowse{PROPLIST:Width,10}
  EDS:DesktopFeeNoteColumn11 = ?FeeNoteBrowse{PROPLIST:Width,11}
  EDS:DesktopFeeNoteColumn12 = ?FeeNoteBrowse{PROPLIST:Width,12}
  EDS:DesktopFeeNoteColumn13 = ?FeeNoteBrowse{PROPLIST:Width,13}
  EDS:DesktopFeeNoteColumn14 = ?FeeNoteBrowse{PROPLIST:Width,14}
  EDS:DesktopFeeNoteColumn15 = ?FeeNoteBrowse{PROPLIST:Width,15}
  EDS:DesktopFeeNoteColumn16 = ?FeeNoteBrowse{PROPLIST:Width,16}
  EDS:DesktopFeeNoteColumn17 = ?FeeNoteBrowse{PROPLIST:Width,17}
  ! Changed
  EDS:DesktopFileNoteColumn1 = ?FileNoteBrowse{PROPLIST:Width,1}
  EDS:DesktopFileNoteColumn2 = ?FileNoteBrowse{PROPLIST:Width,2}
  EDS:DesktopFileNoteColumn3 = ?FileNoteBrowse{PROPLIST:Width,3}
  EDS:DesktopFileNoteColumn4 = ?FileNoteBrowse{PROPLIST:Width,4}
  EDS:DesktopFileNoteColumn5 = ?FileNoteBrowse{PROPLIST:Width,5}
  EDS:DesktopFileNoteColumn6 = ?FileNoteBrowse{PROPLIST:Width,6}
  EDS:DesktopFileNoteColumn7 = ?FileNoteBrowse{PROPLIST:Width,7}
  EDS:DesktopFileNoteColumn8 = ?FileNoteBrowse{PROPLIST:Width,8}
  EDS:DesktopFileNoteColumn9 = ?FileNoteBrowse{PROPLIST:Width,9}
  EDS:DesktopFileNoteColumn10 = ?FileNoteBrowse{PROPLIST:Width,10}
  
  EDS:DesktopReminderColumn1 = ?ToDoNoteBrowse{PROPLIST:Width,1}
  EDS:DesktopReminderColumn2 = ?ToDoNoteBrowse{PROPLIST:Width,2}
  EDS:DesktopReminderColumn3 = ?ToDoNoteBrowse{PROPLIST:Width,3}
  EDS:DesktopReminderColumn4 = ?ToDoNoteBrowse{PROPLIST:Width,4}
  EDS:DesktopReminderColumn5 = ?ToDoNoteBrowse{PROPLIST:Width,5}
  EDS:DesktopReminderColumn6 = ?ToDoNoteBrowse{PROPLIST:Width,6}
  EDS:DesktopReminderColumn7 = ?ToDoNoteBrowse{PROPLIST:Width,7}
  EDS:DesktopReminderColumn8 = ?ToDoNoteBrowse{PROPLIST:Width,8}
  EDS:DesktopReminderColumn9 = ?ToDoNoteBrowse{PROPLIST:Width,9}
  EDS:DesktopReminderColumn10 = ?ToDoNoteBrowse{PROPLIST:Width,10}
  EDS:DesktopReminderColumn11 = ?ToDoNoteBrowse{PROPLIST:Width,11}
  EDS:DesktopReminderColumn12 = ?ToDoNoteBrowse{PROPLIST:Width,12}
  EDS:DesktopReminderColumn13 = ?ToDoNoteBrowse{PROPLIST:Width,13}
  EDS:DesktopReminderColumn14 = ?ToDoNoteBrowse{PROPLIST:Width,14}
  EDS:DesktopReminderColumn15 = ?ToDoNoteBrowse{PROPLIST:Width,15}
  EDS:DesktopReminderColumn16 = ?ToDoNoteBrowse{PROPLIST:Width,16}
  EDS:DesktopReminderColumn17 = ?ToDoNoteBrowse{PROPLIST:Width,17}
  
  IF GLO:TimeRecordingFlag
     EDS:DesktopMatActivColumn1 = ?TimeRecordingBrowse{PROPLIST:Width,1}
     EDS:DesktopMatActivColumn2 = ?TimeRecordingBrowse{PROPLIST:Width,2}
     EDS:DesktopMatActivColumn3 = ?TimeRecordingBrowse{PROPLIST:Width,3}
     IF LOC:MA_Matter <> 'Current'
        EDS:DesktopMatActivColumn4 = ?TimeRecordingBrowse{PROPLIST:Width,4}
        EDS:DesktopMatActivColumn5 = ?TimeRecordingBrowse{PROPLIST:Width,5}
     END
     EDS:DesktopMatActivColumn6 = ?TimeRecordingBrowse{PROPLIST:Width,6}
     EDS:DesktopMatActivColumn7 = ?TimeRecordingBrowse{PROPLIST:Width,7}
     EDS:DesktopMatActivColumn8 = ?TimeRecordingBrowse{PROPLIST:Width,8}
     EDS:DesktopMatActivColumn9 = ?TimeRecordingBrowse{PROPLIST:Width,9}
     EDS:DesktopMatActivColumn10 = ?TimeRecordingBrowse{PROPLIST:Width,10}
     EDS:DesktopMatActivColumn11 = ?TimeRecordingBrowse{PROPLIST:Width,11}
  END
  
  EDS:DesktopDataLinkColumn1 = ?LawMatterMessageBrowse{PROPLIST:Width,1}
  EDS:DesktopDataLinkColumn2 = ?LawMatterMessageBrowse{PROPLIST:Width,2}
  IF LOC:DAT_Matter <> 'Current'
     EDS:DesktopDataLinkColumn3 = ?LawMatterMessageBrowse{PROPLIST:Width,3}
     EDS:DesktopDataLinkColumn4 = ?LawMatterMessageBrowse{PROPLIST:Width,4}
  END
  EDS:DesktopDataLinkColumn5 = ?LawMatterMessageBrowse{PROPLIST:Width,5}
  EDS:DesktopDataLinkColumn6 = ?LawMatterMessageBrowse{PROPLIST:Width,6}
  EDS:DesktopDataLinkColumn7 = ?LawMatterMessageBrowse{PROPLIST:Width,7}
  EDS:DesktopDataLinkColumn8 = ?LawMatterMessageBrowse{PROPLIST:Width,8}
  EDS:DesktopDataLinkColumn9 = ?LawMatterMessageBrowse{PROPLIST:Width,9}
  
  IF Access:EmpDisplaySettings.Update()
     MESSAGE('Error encountered saving column widths for Employee (' & CEM:Name & ')',ERROR(),ICON:Exclamation)
  END
  
  Access:EmpDisplaySettings.Close
  
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:ABSAFees.Close
    Relate:ABSAPayment.Close
    Relate:ABSA_MatterMessage.Close
    Relate:AG_MatterMessage.Close
    Relate:AccBank.Close
    Relate:Activity.Close
    Relate:BondABSA.Close
    Relate:BondArea.Close
    Relate:BondCause.Close
    Relate:BondData.Close
    Relate:BondDebit.Close
    Relate:BondDefs.Close
    Relate:BondDeposit.Close
    Relate:BondFNB.Close
    Relate:BondGuar.Close
    Relate:BondProp.Close
    Relate:BondPropAlias.Close
    Relate:BondShare.Close
    Relate:Branch.Close
    Relate:BranchLang.Close
    Relate:Changes.Close
    Relate:CheckSheetScreen.Close
    Relate:Claim.Close
    Relate:Clause.Close
    Relate:ColData.Close
    Relate:ColDebit.Close
    Relate:ColRent.Close
    Relate:ConsentType.Close
    Relate:ConveyData.Close
    Relate:CostCentre.Close
    Relate:CriticalStep.Close
    Relate:CustomReportField.Close
    Relate:DeedsOffice.Close
    Relate:Delivery.Close
    Relate:DeliveryFeeCode.Close
    Relate:Descript.Close
    Relate:DocCategory.Close
    Relate:DocCheckList.Close
    Relate:DocDebit.Close
    Relate:DocDebitLang.Close
    Relate:DocDef.Close
    Relate:DocDisplayCriteria.Close
    Relate:DocEvent.Close
    Relate:DocFileNote.Close
    Relate:DocLang.Close
    Relate:DocLog.Close
    Relate:DocLogAttachment.Close
    Relate:DocLogCategory.Close
    Relate:DocMergeQueue.Close
    Relate:DocScrn.Close
    Relate:DocScrnEvent.Close
    Relate:DocScrnField.Close
    Relate:DocToDoItem.Close
    Relate:Docgen.Close
    Relate:DocgenAlias.Close
    Relate:DocgenDebit.Close
    Relate:Document.Close
    Relate:DocumentExtraScreen.Close
    Relate:ElectronicLinkLog.Close
    Relate:EmpAlert.Close
    Relate:EmpDefaultFilter.Close
    Relate:Employee.Close
    Relate:EmployeeAlias.Close
    Relate:EmployeeAlias2.Close
    Relate:Entity.Close
    Relate:EntityFica.Close
    Relate:EntityLang.Close
    Relate:Event.Close
    Relate:EventAlias.Close
    Relate:Favourites.Close
    Relate:FeeCode.Close
    Relate:FeeItem.Close
    Relate:FeeLink.Close
    Relate:FeeNote.Close
    Relate:FeeNoteAlias.Close
    Relate:FeeScale.Close
    Relate:FeeSheet.Close
    Relate:FeeSheetAlias.Close
    Relate:FeeText.Close
    Relate:Field.Close
    Relate:FieldVar.Close
    Relate:FileNote.Close
    Relate:Invoice.Close
    Relate:LAW_Mattr.Close
    Relate:LAW_Messg.Close
    Relate:LAW_Suite.Close
    Relate:Language.Close
    Relate:LanguageAlias.Close
    Relate:LawMatterMessage.Close
    Relate:Library.Close
    Relate:Licensed.Close
    Relate:LogFile.Close
    Relate:MatActiv.Close
    Relate:MatDef.Close
    Relate:MatDefParty.Close
    Relate:MatEmployee.Close
    Relate:MatField.Close
    Relate:MatGroup.Close
    Relate:MatParty.Close
    Relate:MatTran.Close
    Relate:MatType.Close
    Relate:Matter.Close
    Relate:MatterAlias.Close
    Relate:MatterAlias2.Close
    Relate:MatterPartyAlias.Close
    Relate:MatterPartyAlias2.Close
    Relate:Notification.Close
    Relate:PTypeDef.Close
    Relate:ParCategory.Close
    Relate:ParFica.Close
    Relate:ParField.Close
    Relate:ParLang.Close
    Relate:ParRegion.Close
    Relate:ParRolSc.Close
    Relate:ParSign.Close
    Relate:ParTele.Close
    Relate:ParType.Close
    Relate:Party.Close
    Relate:PlanOfAction.Close
    Relate:PronText.Close
    Relate:Province.Close
    Relate:RafData.Close
    Relate:RepEmp.Close
    Relate:RepEmpPlanOfAction.Close
    Relate:Report.Close
    Relate:ReportEmp.Close
    Relate:Role.Close
    Relate:RoleLang.Close
    Relate:RowCounter.Close
    Relate:SARS_MatterMessage.Close
    Relate:SMSLog.Close
    Relate:SafeLog.Close
    Relate:SafeType.Close
    Relate:SecProc.Close
    Relate:Stage.Close
    Relate:Task.Close
    Relate:TaskAlias.Close
    Relate:ToDoItem.Close
    Relate:ToDoNote.Close
    Relate:ToDoText.Close
    Relate:TownshipData.Close
    Relate:TranDefs.Close
    Relate:VarLang.Close
    Relate:Variable.Close
  RatesClearanceComKill




  END
  GLO:BrowseMattersThread = 0
  GlobalErrors.SetProcedureName
  IF LOC:RUNNING
    GLO:RUNNING:BrowseDesktop=0
  END
  RETURN ReturnValue


ThisWindow.Open PROCEDURE

  CODE
      IF GLO:ThoughtsWindowThread
  
       IF ~CEM:DisplayThoughtsPeriod  ! IF NO DELAY THEN CLOSE WINDOW NOW
  
            POST(EVENT:CloseWindow,,GLO:ThoughtsWindowThread)
  
            GLO:ThoughtsWindowThread = 0
  
        ELSE
  
            !QuickWindow{PROP:Active} = 0
  
        END
  
    END
  
  PARENT.Open
   
! Kelvin -6 Sep 2016 - moved here to make it work
   ! TRY AND DISPLAY THE MOST RECENT ENTRY IN THIS EMPLOYEES FAVOURITES
  PropSQLNext('SELECT TOP 1 MatterID FROM Favourites WHERE EmployeeID = ' & CEM:RecordID & ' ORDER BY Date Desc,Time Desc')

  IF ROW:Counter
     LOC:FavouriteRecordID = ROW:Counter

     DO MakeMatterFilterString

     IF LOC:FilterMatterString  ! IS IT BEING DISPLAYED WITH THE CURRENT FILER SETTINGS?
        PropSQLNext('SELECT COUNT(1) WHERE ' & LOC:FavouriteRecordID & ' IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')')
        IF ROW:Counter
           MAT:RecordID = LOC:FavouriteRecordID
           Access:Matter.TryFetch(MAT:PrimaryKey)
           BRW54.ResetFromFile
           BRW54.PostNewSelection
           !BRW54.StartAtCurrent = True
           !BRW54.Reset(true)
           !BRW54.TakeNewSelection()
           !thisWindow.Reset(true)

        END
     ELSE
        MAT:RecordID = LOC:FavouriteRecordID
        Access:Matter.TryFetch(MAT:PrimaryKey)
        BRW54.ResetFromFile
        BRW54.PostNewSelection
        !BRW54.StartAtCurrent = True
        !BRW54.TakeNewSelection()
        !BRW54.Reset(true)
        !thisWindow.Reset(true)

     END
  END

   DO DisplayHeading
   Resizer.Resize

   QuickWindow{PROP:Hide} = False

   ! 7 Sep 2016 - Rick: Put "DO ProgramInitialization" back. Seemed to have been deleted and "DO ToggleMatterIcons" put in its place
   !DO ToggleMatterIcons
   DO ProgramInitialization

  
  IF ~GLO:ReloggingOnFlag

      IF CTL:DisableAlertsFlag
      ELSE

         GLO:EnableInstantMessagingFlag = 0
         
         CheckEmployeeAlerts

         IF RECORDS(AMQ:AlertMessageQueue)
         
            START(BrowseEmpAlert)

         END

         GLO:EnableInstantMessagingFlag = 1

      END

  END
    ! 10/09/2015 Sameer: show some buttons on the main Matter screen (for Conveyancing only)
    IF (GLO:InterfaceOption = 'C') THEN
  
      UNHIDE(?STDOnlineDocumentMatterTab)
      UNHIDE(?BondCentreOrGatewayPropertyHubDocsButtonMatterTab)
  
    ELSE
  
      HIDE(?STDOnlineDocumentMatterTab)
      HIDE(?BondCentreOrGatewayPropertyHubDocsButtonMatterTab)
  
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
  IF Number = BRW54.AskProcedure AND REQUEST = ChangeRecord
     IF ShowFICAStatus(MAT:RecordID)     ! PREVENT ACCESS
        RETURN LEVEL:Notify
     END

     SAVED:EmployeeID = MAT:EmployeeID   ! CHECK IF WE NEED TO RE-ALLOCATE UNDONE REMINDERS FOR THIS EMPLOYEE
  END

  IF Number = BRW15.AskProcedure            ! CHECK IF WE NEED TO MARK THE TODONOTE AS DONE OR CHANGE THE DATEDONE
     SAV:DateDone = TOD:DateDone
  END


! RICK - 19/8/2014 - FIXED BIG BUG

! IF YOU HAVE A MESSAGEBOX IN THIS SECTION IT  THIS GIVES A BIND ERROR OR FILE NOT OPEN ERROR *** ONLY IF YOU USE THE DELETE KEY ********:

! MOVED ALL THE DELETION CODE CODE TO ?DELETE TAKEACCEPTED

!              LOC:TableName = 'Matter'
!
!
!              IF CheckMatterAccess(MAT:RecordID)  ! ADDED 8/11/2010
!                 MESSAGE('Unable to Delete this Matter.||You do not have Access rights to this Matter|','Access Denied',ICON:Exclamation)
!              ELSE
!                 IF MESSAGE('Are you sure you want to delete this ' & LOC:TableName & '?','Delete',ICON:Question,BUTTON:OK+BUTTON:Cancel,BUTTON:OK) = BUTTON:OK
!                    DeleteMatter(MAT:RecordID)
!
!                    BRW54.ResetFromBuffer
!                    BRW54.PostNewSelection
!                 END
!              END

              
!              RETURN (LEVEL:Notify)







  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled
  ELSE
    GlobalRequest = Request
    EXECUTE Number
      UpdateFeeNote
      UpdateToDoNote
      UpdateMatActiv
      UpdateLawMatterMessage
      UpdateAG_MatterMessage
      UpdateFileNote
      UpdateMatter
      UpdateMatterMessage
      UpdateSARSMatterMessage
    END
    ReturnValue = GlobalResponse
  END
  SAV:GlobalResponse = GlobalResponse   ! SAVE THIS BECAUSE IT CAN BE CHANGED BY SOME OF THE PROCEDURES BELOW



  IF Number = BRW15.AskProcedure AND REQUEST <> DeleteRecord
     IF SAV:GlobalResponse = RequestCompleted
     
        SAV:TOD:RecordID = TOD:RecordID    ! SAVE IT SO WE CAN GET IT AFTERWARDS SO IT JUMPS TO THE ADDED TODO NOTE

        IF ~(SAV:DateDone = TOD:DateDone) AND TOD:DateDone

           IF ~SAV:DateDone                ! THE USER HAS PUT IN A COMPLETED DATE

               MarkToDoNoteAsCompleted(TOD:RecordID)

               DO RefreshToDoNoteBrowse

           ELSE                            ! THE USER HAS CHANGED THE COMPLETED DATE

               CheckIfCriticalStepChanged

               CheckLinkedReminders(TOD:MatterID)                      ! ADJUST ANY LINKED REMINDERS

               DO RefreshToDoNoteBrowse

           END

        END
     END
     ?Close{PROP:DISABLE} = FALSE
  END

  If Number = BRW22.AskProcedure AND REQUEST <> DeleteRecord AND SAV:GlobalResponse = RequestCompleted ! AFTER Accessing MatActiv

     IF GLO:MAFeeNoteFlag



        IF MA:FeeNoteID AND Request = ChangeRecord

           FN:RecordID = MA:FeeNoteID
           Access:FeeNote.Fetch(FN:PrimaryKey)

           IF FN:RecordID and MESSAGE('A Fee Note has already been made from this record.||Do you want to create another Fee Note?','Changing a Time Record',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:No

              IF GLO:MAFileNoteFlag
                 AddFeeNoteFromMA(ChangeRecord,FIL:RecordID)
              ELSE
                 AddFeeNoteFromMA(ChangeRecord)
              END

           ELSE

              IF GLO:MAFileNoteFlag
                 AddFeeNoteFromMA(,FIL:RecordID)
              ELSE
                 AddFeeNoteFromMA
              END

           END

        ELSE

           IF GLO:MAFileNoteFlag
              AddFeeNoteFromMA(,FIL:RecordID)
           ELSE
              AddFeeNoteFromMA
           END

        END

     ELSE   ! THE USER CHANGED THE TIME RECORD BUT NEVER TICKED "MAKE A FEE NOTE"
            ! BUT A FEE NOTE EXISTS SO ASK IF HE WANTS TO CHANGE IT

        IF MA:FeeNoteID
           FN:RecordID = MA:FeeNoteID
           Access:FeeNote.Fetch(FN:PrimaryKey)
           IF FN:RecordID
               IF Request = ChangeRecord
                   IF FN:PostedFlag
                      MESSAGE('A Fee Note was created from this Time Record but it has already been posted.||The Fee Note will therefore not be changed.','Changing a Time Record',ICON:Exclamation)
                   ELSE
                      IF MESSAGE('A Fee Note was created from this Time Record.||It has not been posted yet.||Do you want to update it with the changes you made to this Time Record','Changing a Time Record',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:Yes
                         AddFeeNoteFromMA(ChangeRecord)
                         DO RefreshFeeNoteBrowse
                      END
                   END
               END
            END
        END
     END


     IF GLO:MADisbursementID
        IF Request = ChangeRecord

           IF MA:DisbursementID

              IF MESSAGE('A Disbursement has already been made from this record.||Do you want to create another Disbursement?','Changing a Time Record',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:No
              ELSE
                  SetTag:PtrM(Tag:FeeCode,GLO:MADisbursementID)
                  GLO:FeeNoteDate = MA:Date  ! USE THE DATE OF THE TIME RECORD TO MAKE THE DISBURSEMENT
                  AddFeeNote(CEM:RecordID,MA:CostCentreID)
                  GLO:FeeNoteDate = 0
                  NewTag:PtrM(Tag:FeeCode)
              END

           ELSE
               SetTag:PtrM(Tag:FeeCode,GLO:MADisbursementID)
               GLO:FeeNoteDate = MA:Date  ! USE THE DATE OF THE TIME RECORD TO MAKE THE DISBURSEMENT
               AddFeeNote(CEM:RecordID,MA:CostCentreID)
               GLO:FeeNoteDate = 0
               NewTag:PtrM(Tag:FeeCode)
           END

        ELSIF Request = InsertRecord

           SetTag:PtrM(Tag:FeeCode,GLO:MADisbursementID)
           GLO:FeeNoteDate = MA:Date  ! USE THE DATE OF THE TIME RECORD TO MAKE THE DISBURSEMENT
           AddFeeNote(CEM:RecordID,MA:CostCentreID)
           GLO:FeeNoteDate = 0
           NewTag:PtrM(Tag:FeeCode)

        END

     END

     IF GLO:MAFeeNoteFlag OR GLO:MADisbursementID

        GLO:MADisbursementID = False
        GLO:MAFeeNoteFlag = False

        DO RefreshFeeNoteBrowse

     END


     DO TotalMatActiv


     IF GLO:MAToDoNoteFlag
        DO RefreshToDoNoteBrowse
     END

     IF GLO:MAFileNoteFlag
        DO RefreshFileNoteBrowse
     END


     ! RICK 2/8/2012 - CLEARED ALL THESE GLOBALS - WERE CAUSING PROBLEM IN AddFeeNoteFromMA
     GLO:ToDoNoteDays = 0
     GLO:ToDONoteDescription = ''
     GLO:FeeNoteDescription = ''
     GLO:FeeNoteVoucher = ''
     GLO:DisbursementDescription = ''
     GLO:MAToDoNoteFlag = 0
     GLO:MAFileNoteFlag = 0
     GLO:MAFeeNoteFlag = 0
     GLO:MADisbursementID = 0
     GLO:FeeNoteDate = 0



     !FB579 - Kelvin 13-feb-2017
       
     IF Request = ChangeRecord

      PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL(MA:Description) & ''','&MA:BillableAmount&',''MatActiv'',2,' & CEM:RecordID & ',' & MA:RecordID & ',''' & StripSQL(MAT:FileRef) & ''',''UpdateMatActiv''','FileManager - Update Time Record')

     ELSE

      PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL(MA:Description) & ''','&MA:BillableAmount&',''MatActiv'',1,' & CEM:RecordID & ',' & MA:RecordID & ',''' & StripSQL(MAT:FileRef) & ''',''UpdateMatActiv''','FileManager - Insert Time Record')

     END



  END

  IF Number = BRW2.AskProcedure  AND SAV:GlobalResponse = RequestCompleted 

    IF LOC:FN_Matter = 'Current' 
       LOC:LastWarningMatterID = -1  ! SO IT CHECKS THIS MATTER WHEN THE USERS POSTS SOME FEES
       DO CheckFeeEstimate
    END

  END


  ! UPDATE TOTAL AT BOTTOM AFTER ADDING AN ITEM MANUALLY
  LOC:AdustCounter = 0
  IF Request = InsertRecord
     LOC:AdustCounter = 1
  ELSIF Request = DeleteRecord
     LOC:AdustCounter = -1
  END
  
  IF SAV:GlobalResponse = RequestCompleted AND LOC:AdustCounter
      IF Number = BRW52.AskProcedure
            LOC:FilteredFileNotes += LOC:AdustCounter
            DISPLAY(?LOC:FilteredFileNotes)
      ELSIF Number = BRW54.AskProcedure
            LOC:FilteredMatters += LOC:AdustCounter
            DISPLAY(?LOC:FilteredMatters)
      ELSIF Number = BRW15.AskProcedure
            LOC:FilteredReminders += LOC:AdustCounter
            DISPLAY(?LOC:FilteredReminders)
      END
  END

! *********************PROGRESS ICONS **********************************************


  IF Number = BRW15.AskProcedure AND SAV:GlobalResponse = RequestCompleted

      IF CEM:ProgressIndicatorFlag = 'C' AND LOC:ShowMatterIconsFlag  ! UPDATE THE PROGRESS ICON.
         BRW54.ApplyFilter
         BRW54.ResetFromBuffer
      END

  END




  IF Number = BRW52.AskProcedure AND SAV:GlobalResponse = RequestCompleted

      IF CEM:ProgressIndicatorFlag = 'S' AND LOC:ShowMatterIconsFlag  ! UPDATE THE PROGRESS ICON.
         BRW54.ApplyFilter
         BRW54.ResetFromBuffer
      END

  END

  ! ************ AFTER  MATTER TAKE ON *********************************************************************************************

  IF Number = BRW54.AskProcedure AND GlobalResponse = RequestCompleted
     SAV:SortKey54 = 255 ! FORCES A RESORT
  END


  ! ********************** FILE NOTES ************************************

  IF Number = BRW52.AskProcedure AND SAV:GlobalResponse = RequestCompleted AND Request <> DeleteRecord ! AFTER MODIFYING OR INSERTING A FileNote

     SAV:FIL:RecordID = FIL:RecordID    ! SAVE IT SO WE CAN GET IT AFTERWARDS SO IT JUMPS TO THE ADDED TODO NOTE

     ProcessFileNote(Request)

  END




  IF Number = BRW54.AskProcedure AND SAV:GlobalResponse = RequestCompleted


     IF Request = DeleteRecord  ! STOP THE RECORD RETRIEVAL ERROR BECAUSE IT EMPTIES THE QUEUES AND
                                ! AND THEN THE OTHER BROWSES DO NOT HAVE "GHOST" RECORDS IN THEIR VIEWS
                                ! E.G. A REMINDER THAT WAS DELETED BY SQL TRIGGER WHEN THE MATTER WAS DELETED.



     ELSE


           ! ADDED 13/08/2010
           GLO:CurrentMatterID = MAT:RecordID
           DO CheckIfMatterCanBeViewed


           IF Request = InsertRecord


              IF GLO:LOLEnabledFlag 

                 CLEAR(MP:Record)
                 MP:MatterID = MAT:RecordID
                 SET(MP:MatterRoleKey,MP:MatterRoleKey)
                 OPEN(MatterPartyView)
                 LOOP
                      NEXT(MatterPartyView)
                      IF ERRORCODE() THEN BREAK.
                      IF ~(MP:MatterID = MAT:RecordID) THEN BREAK.


                      IF ROL:LOLNotifyFlag
                         IF GLO:DebuggingFlag
                            SendLOLLoginDetails(MP:RecordID,0) ! TURN MESSAGES ON
                         ELSE
                            SendLOLLoginDetails(MP:RecordID,1) ! SEND IN SILENT MODE
                         END
                      END

                 END
                 CLOSE(MatterPartyView)

              END


              IF MAT:ToDoGroupID

                 SetMatterPlanOfAction(MAT:RecordID,MAT:ToDoGroupID)

                 DO RefreshToDoNoteBrowse

              END

           END

           ! ACTIVATE SYSTEM EVENTS

           EXECUTE Request
              ProcessSystemEvent(EVENT:MatterInserted,MAT:RecordID)
              ProcessSystemEvent(EVENT:MatterUpdated,MAT:RecordID)
           END

           ! IF THE MATTER IS ALLOCATED TO ANOTHER EMPLOYEE - OFTEN YOU WANT TO SEND A MESSAGE (OR REMINDER) TO THE NEW EMPLOYEE
           IF Request = ChangeRecord AND (SAVED:EmployeeID <> MAT:EmployeeID)
               IF MESSAGE('Would you like to reassign all incomplete reminders to the new employee?','Re-assign Reminders',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No) = BUTTON:Yes
                  ! REALLOCATE THE UNDONE REMINDERS 
                   PropSQL('Update ToDoNote SET EmployeeID = ' & MAT:EmployeeID & ' WHERE MatterID = ' & MAT:RecordID & ' AND EmployeeID = ' & SAVED:EmployeeID & ' And DateDone = 0')  !FB 2161 uncomment this line and commenting the one below. Just in case.
                  !PropSQL('Update ToDoNote SET EmployeeID = ' & MAT:EmployeeID & ' WHERE MatterID = ' & MAT:RecordID & ' And DateDone = 0')
               END
               ProcessSystemEvent(EVENT:MatterReallocated,MAT:RecordID)
           END


     END


  END



  IF Request <> DeleteRecord AND SAV:GlobalResponse = RequestCompleted 

     IF Number = BRW15.AskProcedure AND SAV:TOD:RecordID
        TOD:RecordID = SAV:TOD:RecordID    ! SAVED IT SO WE JUMP TO THE ADDED RECORD
        Access:ToDoNote.TryFetch(TOD:PrimaryKey)

     ELSIF Number = BRW52.AskProcedure AND SAV:FIL:RecordID
        FIL:RecordID = SAV:FIL:RecordID    ! SAVED IT SO WE JUMP TO THE ADDED RECORD
        Access:FileNote.TryFetch(FIL:PrimaryKey)

     END

  END






  LOC:CopyFlag21 = False
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
    OF ?PartiesButton
       ThisWindow.Update
       AddToFavourites(MAT:RecordID)
       GLO:RecordID = 0
       BrowseMatParty
       SELECT(?MattersBrowse)
      IF GLO:RecordID !<> MP.MatterID
          LOC:JumpToRecordID = GLO:RecordID
          POST(EVENT:JumpToMatter)
      .
      
      
    OF ?MatterEmployeesButton
       ThisWindow.Update
       BrowseMatEmployee
       SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
    OF ?MAT:QBESearchButton:2
        LOC:QBEFilterString = ''

        DO MakeMatterFilterString

        CreateMatterQBEQueue

        LOC:QBEFilterString = GetUserQBEFilter(TAG:Matter,'Filter the Matters using QBE',LOC:FilterMatterString)

        DO DisplayHeading

        DO RefreshMatterBrowse

        IF GLO:DebuggingFlag
           IF LOC:FilterMatterString
              SETCLIPBOARD('SELECT * FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString)
              MESSAGE('This is the SQL script being used by the Desktop. It has been copied to your clipboard.||' & 'SELECT * FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString,'Debugging',ICON:Exclamation)
           END
        END

        Select(?MattersBrowse,1)

    OF ?UpdateGuarantees
           GLO:FileName = 'GuaranteeMatterIdFile_'& CEM:RecordID &'.csv'
           GLO:DOSFIleOUT   = GLO:FileName
      
           LOOP 1 TIMES
      
                IF EXISTS(GLO:Filename)
                    REMOVE(GLO:Filename)
                    IF ERRORCODE()
      
                        MESSAGE('Error Removing File|Filename: ' & GLO:FileName & '|Error: ' & Error(),'Remove File Error',ICON:Exclamation)
                        BREAK
      
                    END
                END
      
                Create(DOSFileOut)
                IF ERRORCODE()
      
                    MESSAGE('Error Creating File|Filename: ' & GLO:FileName & '|Error: ' & Error(),'File Creation Error',ICON:Exclamation)
                    CLOSE(DOSFileOut)
                    BREAK
      
                END
      
           END
      
           Relate:DOSFileOut.Open
      
           DOUT:Line = ''
      
           MAT:RecordId = FstTag:PtrM(TAG:Matter)
      
           LOOP
      
             DOUT:Line = CLIP(DOUT:Line) & MAT:RecordId & ','
      
             MAT:RecordId = NxtTag:PtrM(Tag:Matter)
      
             IF ~MAT:RecordId THEN BREAK.
      
           END ! LOOP
      
           Append(DOSFileOut,LEN(CLIP(DOUT:Line)) - 1) ! Save the file and remove trailing comma
      
           Relate:DOSFileOut.Close
           ! ---- END Write to File ----
      
           IF EXISTS('UpdatingAllGuarantees.exe')
             RUN('UpdatingAllGuarantees.exe login="' & GLO:SQLLogin & '" "file=' & GLO:Filename&'"', 1)
             POST(EVENT:RefreshMatters)
           ELSE
      
             Message('UpdatingAllGuarantees.exe Not Found||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
             Return Level:Notify
      
           END
    OF ?ToggleMatterIconsButton
        IF  LOC:ShowMatterIconsFlag
            LOC:ShowMatterIconsFlag = 0
        ELSE
            LOC:ShowMatterIconsFlag = 1
        END
      
        DO ToggleMatterIcons
       SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
      
    OF ?ConveyancingException
!      !Kelvin 28 3 2017 - no case
!      GLO:Filename = 'ExceptionMatterIdFile_'& CEM:RecordID &'.txt'
!      IF EXISTS(GLO:Filename)
!        REMOVE(GLO:Filename)
!        IF ERRORCODE()
!            MESSAGE('Error Removing DataLink File|Filename: ' & GLO:FileName & '|Error: ' & Error(),'Print Cheque',ICON:Exclamation)
!        END !IF ERRORCODE()
!      END !IF EXISTS(GLO:Filename)
!      IF FstTag:PtrM(TAG:Matter)
!        MAT:RecordId = FstTag:PtrM(TAG:Matter)
!        LOC:ExceptionMatterIdsCsv = ''
!        LOOP
!            Access:Matter.Fetch(MAT:PrimaryKey)
!            LOC:ExceptionMatterIdsCsv = LOC:ExceptionMatterIdsCsv & MAT:RecordId & ','
!            MAT:RecordId = NxtTag:PtrM(Tag:Matter)
!            IF ~MAT:RecordId THEN
!                ! Remove trailing comma
!                LOC:ExceptionMatterIdsCsv = SUB(LOC:ExceptionMatterIdsCsv, 1, LEN(LOC:ExceptionMatterIdsCsv) - 1)
!                BREAK
!            END !IF ~MAT:RecordId THEN
!        END ! LOOP
!        CREATE(ASCIIFILE)
!        IF ERRORCODE()
!           CLOSE(ASCIIFILE)
!         END !IF ERRORCODE()
!         Relate:AsciiFile.Open
!         ASC:String = LOC:ExceptionMatterIdsCsv
!         ADD(ASCIIFILE)
!         IF ERRORCODE()
!          MESSAGE('Error Adding Data To Conveyancing Exception File|Filename: ' & GLO:FileName & '|Error: ' & Error(),'Conveyancing File',ICON:Exclamation)
!        END !IF ERRORCODE()
!        CLOSE(ASCIIFILE)
!      END !FstTag:PtrM(TAG:Matter)
!      IF EXISTS('ExceptionReport.exe')
!        RUN('ExceptionReport.exe login="' & GLO:SQLLogin & '" "EmployeeId=' & CEM:RecordID & '" "file=' & GLO:Filename&'"', 1)
!      ELSE
!        Message('ExceptionReport.exe Not Found||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
!        Return Level:Notify
!      END !IF EXISTS('LegalSuite.LawDataLinkIntegration.exe')

          ! ---- Write to File ------

           GLO:FileName = 'ExceptionMatterIdFile_'& CEM:RecordID &'.csv'
           GLO:DOSFIleOUT   = GLO:FileName

           LOOP 1 TIMES

                IF EXISTS(GLO:Filename)
                    REMOVE(GLO:Filename)
                    IF ERRORCODE()

                        MESSAGE('Error Removing File|Filename: ' & GLO:FileName & '|Error: ' & Error(),'Remove File Error',ICON:Exclamation)
                        BREAK

                    END
                END

                Create(DOSFileOut)
                IF ERRORCODE()

                    MESSAGE('Error Creating File|Filename: ' & GLO:FileName & '|Error: ' & Error(),'File Creation Error',ICON:Exclamation)
                    CLOSE(DOSFileOut)
                    BREAK

                END

           END

           Relate:DOSFileOut.Open

           DOUT:Line = ''

           MAT:RecordId = FstTag:PtrM(TAG:Matter)

           LOOP

             DOUT:Line = CLIP(DOUT:Line) & MAT:RecordId & ','

             MAT:RecordId = NxtTag:PtrM(Tag:Matter)

             IF ~MAT:RecordId THEN BREAK.

           END ! LOOP

           Append(DOSFileOut,LEN(CLIP(DOUT:Line)) - 1) ! Save the file and remove trailing comma

           Relate:DOSFileOut.Close
           ! ---- END Write to File ----

           IF EXISTS('ExceptionReport.exe')

             
             RUN('ExceptionReport.exe login="' & GLO:SQLLogin & '" "EmployeeId=' & CEM:RecordID & '" "file=' & GLO:Filename&'"', 1)

           ELSE

             Message('ExceptionReport.exe Not Found||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
             Return Level:Notify

           END
      
    OF ?Close
      POST(EVENT:CloseWindow)
    OF ?LOC:QuickFeeCode
      CLEAR(MAT1:Record)
      ThisWindow.Update
      
      IF LOC:FN_Matter = 'Current'
      
        LOC:MAT:RecordID = LOC:CurrentMatterID
      
      ELSE
      
        IF MAT1:RecordID
           LOC:MAT:RecordID = GetMatterID(MAT1:RecordID)
        ELSE
           IF ~SAV:LastMatterID THEN SAV:LastMatterID = LOC:CurrentMatterID.
           LOC:MAT:RecordID = GetMatterID(SAV:LastMatterID)
         END
      
      END
      IF ~LOC:MAT:RecordID THEN CYCLE.
      
      
      MAT:RecordID = LOC:MAT:RecordID
      Access:Matter.TryFetch(MAT:PrimaryKey) ! NEED MATTER IN MEMORY TO SELECT THE CORRECT FEE SHEEETS ETC AND FOR ADDFEENOTE BELOW
      
      IF ~MAT:AccountsLanguageID
          MESSAGE('This matter has no Accounting Language selected.||This must be specified when you take on a Matter so the appropriate Fee Items can be inserted.',MAT:FileRef & ' - ' & MAT:Description,ICON:Exclamation)
          CYCLE
      ELSIF ~MAT:ClientFeeSheetID
          MESSAGE('This matter has no Fee Sheet selected.||This must be specified when you take on a Matter so the appropriate Fee Codes can be displayed.',MAT:FileRef & ' - ' & MAT:Description,ICON:Exclamation)
          CYCLE
      END
      
      FS:RecordID = MAT:ClientFeeSheetID
      IF Access:FeeSheet.Fetch(FS:PrimaryKey)
         MESSAGE('Unable to find the Fee Sheet for this matter.||Reason: ' & ERROR(),MAT:FileRef & ' - ' & MAT:Description,ICON:Exclamation)
         CYCLE
      END
      
      
      Clear(FC:Record)
      FC:Code = LOC:QuickFeeCode
      IF Access:FeeCode.TryFetch(FC:CodeKey)
      ELSE
         IF ~CntTag:PtrM(Tag:FeeCode) Then SetTag:PtrM(Tag:FeeCode,FC:RecordID). ! If No Tags Then Tag Current FeeCode
         GLO:FeeNoteDate = GetUserDate(GLO:TodaysDate)
         IF GLO:FeeNoteDate
      
            IF GLO:FN_EmployeeID > 0
               AddFeeNote(GLO:FN_EmployeeID,GLO:FeeNoteCostCentreID)
            ELSIF GLO:FeeNoteEmployeeId
               AddFeeNote(GLO:FeeNoteEmployeeId,GLO:FeeNoteCostCentreID)
            ELSE
               AddFeeNote(CEM:RecordID,GLO:FeeNoteCostCentreID)
            END
      
            GLO:FeeNoteDate = GLO:TodaysDate   ! RESET IT IN CASE USER DOES A MERGE NEXT
      
         ELSE
            CYCLE  ! USER CANCELLED FROM DATE INPUT SCREEN
         END
      
         DO TotalFeeNotes
      
         BRW2.ApplyFilter
      
         FN:RecordID = GLO:AddedFeeNoteID
         Access:FeeNote.TryFetch(FN:PrimaryKey)
      
         DO RefreshFeeNoteBrowse
      
          DO RefreshMatActivBrowse
      
      END
      
      NewTag:PtrM(Tag:FeeCode)
      SELECT(?FeeNoteBrowse)
      
    OF ?FN:QBESearchButton
! RICK 14/9/2014 - NOT TAGGING QBE RESULTS ANYMORE - TAKES TOO LONG. JUST FILTERING

            LOC:QBEFilterFeeNoteString = ''

            DO MakeFilterFeeNoteString

            DO CreateFeeNoteQBEQueue
      
            LOC:QBEFilterFeeNoteString = GetUserQBEFilter(TAG:FeeNote,'Search for Fee Notes',LOC:FilterFeeNoteString)

            DO DisplayHeading

            DO RefreshFeeNoteBrowse

            Select(?FeeNoteBrowse,1)


           IF GLO:DebuggingFlag
              IF LOC:FilterFeeNoteString
                 SETCLIPBOARD('SELECT * FROM FeeNote WHERE ' & LOC:FilterMatterString)
                 MESSAGE('This is the Filter being used by the Desktop. The script has been copied to your clipboard.||' & 'SELECT * FROM FeeNote WHERE ' & LOC:FilterFeeNoteString,'Debugging',ICON:Exclamation)
              END
           END


    OF ?FN:QBEPrintButton
            DO CreateFeeNoteQBEQueue
      
            CLEAR(GLO:QBEFilterString)

            LOC:TaggedRecordID = FstTag:PtrM(Tag:FeeNote)
            IF LOC:TaggedRecordID AND BRW2::Filter = 0 ! THERE ARE TAGGED ITEMS BUT THE USER IS SHOWING ALL RECORDS
               IF MESSAGE('Do you want to print the tagged Fee Notes only?','Report Options',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:No
                  LOC:TaggedRecordID = 0
               END
            END
            
           IF LOC:TaggedRecordID
               GLO:QBEFilterString = CreateQBEFilterString(TAG:FeeNote,'A')
           ELSE
              GLO:QBEFilterString = BRW2::View:Browse{PROP:SQLFilter}
           END

           PrintUserQBEReport(0{PROP:Handle},TAG:FeeNote,'Fee Note Report')

    OF ?FeeNoteJumpToMatterButton
        SELECT(?MattersBrowse)
        LOC:JumpToRecordID = FN:MatterID
        POST(EVENT:JumpToMatter)
        SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
    OF ?CustomFN_PeriodButton
        LOC:FN_Period = 'Custom'
        ?LOC:FN_Period{PROP:SELECTED} = ?LOC:FN_Period{PROP:ITEMS}
        IF ~LOC:FN_FromDate THEN LOC:FN_FromDate = GLO:TodaysDate.
        IF ~LOC:FN_ToDate THEN LOC:FN_ToDate = GLO:TodaysDate.
        IF LOC:FN_ToDate > GLO:TodaysDate + 10000 THEN LOC:FN_ToDate = GLO:TodaysDate.
        GetDateRange(LOC:FN_FromDate,LOC:FN_ToDate)
    OF ?FN:PrintButton
      POST(EVENT:Accepted,?FN:QBEPrintButton)
    OF ?MoveUp
       ThisWindow.Update
       SAV:FN_Date = FN:Date
       SAV:FN_MatterID = FN:MatterID
      
    OF ?MoveDown
       ThisWindow.Update
       SAV:FN_Date = FN:Date
       SAV:FN_MatterID = FN:MatterID
    OF ?EmailFileNoteButton
            ThisWindow.Update

            IF FIL:MatterID
               LOC:ClientID = 0
               PropSQLNext('SELECT ClientID,TheirRef FROM Matter WHERE RecordID = ' & FIL:MatterID)
               LOC:ClientID = ROW:Counter
               IF ROW:Description
                  LOC:TheirRef = ROW:Description
                  LOC:Subject = GetDescription('PARTY NAME',ROW:Counter) & ' (' & LOC:TheirRef & ') [' & GetDescription('Matter FileRef',FIL:MatterID) & ' - ' & GetDescription('Matter Description',FIL:MatterID) & ']'
               ELSE
                  LOC:Subject = GetDescription('PARTY NAME',ROW:Counter) & ' [' & GetDescription('Matter FileRef',FIL:MatterID) & ' - ' & GetDescription('Matter Description',FIL:MatterID) & ']'
               END
            ELSE
               LOC:Subject = 'File Note'
            END
            LOC:EmailMatterID = FIL:MatterID
      
      
            IF FstTag:PtrM(Tag:FileNote)


               ! 21/1/2014 - PUTTING THEM IN A QUEUE FIRST SO THEY ARE INSERTED IN DATE ORDER

               LOC:Body  = ''
               FREE(EmailFileNotesQueue)

               CLEAR(FIL:Record)
               FIL:RecordID = FstTag:PtrM(Tag:FileNote)
               LOOP 
                    IF ~Access:FileNote.TryFetch(FIL:PrimaryKey)

                        EFILQ:Date = FIL:Date
                        EFILQ:Description = FIL:Description
                        ADD(EmailFileNotesQueue,EFILQ:Date)

                    END
                    FIL:RecordID = NxtTag:PtrM(Tag:FileNote)                ! SET TO NEXT FileNote
                    IF ~FIL:RecordID THEN BREAK.
               END


               LOOP EmailFileNotesQueueCounter# = 1 TO RECORDS(EmailFileNotesQueue)

                    GET(EmailFileNotesQueue,EmailFileNotesQueueCounter#)
      
      
                    IF LOC:Body 
                       LOC:Body = LOC:Body & '<13,10>------------------<13,10>' & Format(EFILQ:Date,@d17) & '<13,10>' & EFILQ:Description
                    ELSE
                       LOC:Body = Format(EFILQ:Date,@d17) & '<13,10>' & EFILQ:Description
                    END
      
               END



            ELSE
               LOC:Body = Format(FIL:Date,@d17) & '<13,10>' & FIL:Description
            END
      
            DO SendEmail
            SELECT(?FileNoteBrowse)
      
            
    OF ?PrintFileNoteButton
      ThisWindow.Update
      PrintFileNote(1)
      SELECT(?FileNoteBrowse)
    OF ?FIL:QBESearchButton
! RICK 14/9/2014 - NOT TAGGING QBE RESULTS ANYMORE - TAKES TOO LONG. JUST FILTERING

            LOC:QBEFilterFileNoteString = ''

            DO MakeFilterFileNoteString

            DO CreateFileNoteQBEQueue
      
            LOC:QBEFilterFileNoteString = GetUserQBEFilter(TAG:FileNote,'Search for File Notes',LOC:FilterFileNoteString)

            DO DisplayHeading

            DO RefreshFileNoteBrowse

            Select(?FileNoteBrowse,1)


           IF GLO:DebuggingFlag
              IF LOC:FilterFileNoteString
                 SETCLIPBOARD('SELECT * FROM FileNote WHERE ' & LOC:FilterMatterString)
                 MESSAGE('This is the Filter being used by the Desktop. The script has been copied to your clipboard.||' & 'SELECT * FROM FileNote WHERE ' & LOC:FilterFileNoteString,'Debugging',ICON:Exclamation)
              END
           END

    OF ?FIL:QBEPrintButton
            DO CreateFileNoteQBEQueue
      
            CLEAR(GLO:QBEFilterString)
            LOC:TaggedRecordID = FstTag:PtrM(Tag:FileNote)
            IF LOC:TaggedRecordID AND BRW52::Filter = 0 ! THERE ARE TAGGED ITEMS BUT THE USER IS SHOWING ALL RECORDS
               IF MESSAGE('Do you want to print the tagged File Notes only?','Report Options',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:No
                  LOC:TaggedRecordID = 0
               END
            END
            
            IF LOC:TaggedRecordID
               GLO:QBEFilterString = CreateQBEFilterString(TAG:FileNote,'A')
            ELSE
               GLO:QBEFilterString = BRW52::View:Browse{PROP:SQLFilter}
           END
      
           PrintUserQBEReport(0{PROP:Handle},TAG:FileNote,'File Note Report')
    OF ?ToggleFileNoteIconsButton
        IF  LOC:ShowFileNoteIconsFlag
            LOC:ShowFileNoteIconsFlag = 0
        ELSE
            LOC:ShowFileNoteIconsFlag = 1
        END
      
        DO ToggleFileNoteIcons
        SELECT(?FileNoteBrowse)
      
    OF ?FileNoteJumpToMatterButton
        SELECT(?MattersBrowse)
        LOC:JumpToRecordID = FIL:MatterID
        POST(EVENT:JumpToMatter)
        SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
    OF ?CustomFIL_PeriodButton
        LOC:FIL_Period = 'Custom'
        ?LOC:FIL_Period{PROP:SELECTED} = ?LOC:FIL_Period{PROP:ITEMS}
        IF ~LOC:FIL_FromDate THEN LOC:FIL_FromDate = GLO:TodaysDate.
        IF ~LOC:FIL_ToDate THEN LOC:FIL_ToDate = GLO:TodaysDate.
        IF LOC:FIL_ToDate > GLO:TodaysDate + 10000 THEN LOC:FIL_ToDate = GLO:TodaysDate.
        GetDateRange(LOC:FIL_FromDate,LOC:FIL_ToDate)
      
    OF ?FIL:PrintButton
      POST(EVENT:Accepted,?FIL:QBEPrintButton)
    OF ?Copy
      LOC:CopyFlag21 = True
      Post(EVENT:Accepted,?Insert:5)
    OF ?MakeDoneButton
      IF FstTag:PtrM(TAG:ToDoNote)


         ! WARN USER IF MARKING MULTIPLE MATTERS AT THE SAME TIME

         LOC:MarkingMultipleMattersFlag = 0
         LOC:ThisMatterID = 0

         CLEAR(TOD:Record)
         TOD:RecordID = FstTag:PtrM(Tag:ToDoNote)                
         LOOP 
              IF Access:ToDoNote.TryFetch(TOD:PrimaryKey) THEN CYCLE.

              IF LOC:ThisMatterID AND LOC:ThisMatterID <> TOD:MatterID
                 LOC:MarkingMultipleMattersFlag = 1
                 BREAK
              END

              LOC:ThisMatterID = TOD:MatterID


              TOD:RecordID = NxtTag:PtrM(Tag:ToDoNote)                
              IF ~TOD:RecordID THEN BREAK.
         END

         IF LOC:MarkingMultipleMattersFlag

            IF MESSAGE('You have tagged Reminders from different Matters.||Are you sure you want to mark all these Reminders as "Done"?|','Warning',ICON:Exclamation,BUTTON:Yes+BUTTON:No,BUTTON:No) = BUTTON:No
               CYCLE
            END

         END
            

         OPEN(ProgressWindow)
         ProgressWindow{PROP:Text} = 'Marking Reminders'
         ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:ToDoNote)
         CLEAR(TOD:Record)
         TOD:RecordID = FstTag:PtrM(Tag:ToDoNote)                ! SET TO THE FIRST TAGGED ToDoNote
         LOOP 
              IF Access:ToDoNote.TryFetch(TOD:PrimaryKey) THEN CYCLE.
              MarkToDoNote(TOD:RecordID)

              ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
              DISPLAY
              TOD:RecordID = NxtTag:PtrM(Tag:ToDoNote)                ! SET TO NEXT ToDoNote
              IF ~TOD:RecordID THEN BREAK.
              SAV:TOD:RecordID = TOD:RecordID
         END
         CLOSE(ProgressWindow)
         DO BRW15::UntagAll
         TOD:RecordID = SAV:TOD:RecordID
         Access:ToDoNote.Fetch(TOD:PrimaryKey)
      ELSE
         ThisWindow.Update
         MarkToDoNote(TOD:RecordID)
      END


      IF CEM:ProgressIndicatorFlag = 'C' AND LOC:ShowMatterIconsFlag  ! UPDATE THE PROGRESS ICON.
         BRW54.ApplyFilter
         BRW54.ResetFromBuffer
      END


      DO RefreshFileNoteBrowse
      DO RefreshToDoNoteBrowse
      ThisWindow.Update
       SELECT(?ToDoNoteBrowse)

    OF ?EmailToDoNoteButton
            ThisWindow.Update

            IF TOD:MatterID
               LOC:ClientID = 0
               PropSQLNext('SELECT ClientID,TheirRef FROM Matter WHERE RecordID = ' & TOD:MatterID)
               LOC:ClientID = ROW:Counter
               IF ROW:Description
                  LOC:TheirRef = ROW:Description
                  LOC:Subject = GetDescription('PARTY NAME',ROW:Counter) & ' (' & LOC:TheirRef & ') [' & GetDescription('Matter FileRef',TOD:MatterID) & ' - ' & GetDescription('Matter Description',TOD:MatterID) & ']'
               ELSE
                  LOC:Subject = GetDescription('PARTY NAME',ROW:Counter) & ' [' & GetDescription('Matter FileRef',TOD:MatterID) & ' - ' & GetDescription('Matter Description',TOD:MatterID) & ']'
               END

            ELSE
               LOC:Subject = 'Reminder'
            END

            IF FstTag:PtrM(Tag:ToDoNote)
               LOC:Body  = ''
               CLEAR(TOD:Record)
               TOD:RecordID = FstTag:PtrM(Tag:ToDoNote)
               LOOP 
                    IF ~Access:ToDoNote.TryFetch(TOD:PrimaryKey)
      
                        IF TOD:DateDone and TOD:CompletedFlag
                           LOC:TOD:Date = TOD:DateDone
                        ELSE
                           LOC:TOD:Date = TOD:Date
                        END

                        IF LOC:Body 
                           LOC:Body = LOC:Body & '<13,10>------------------<13,10>' & Format(LOC:TOD:Date,@d17) & '<13,10>' & TOD:Description
                        ELSE
                           LOC:Body = Format(LOC:TOD:Date,@d17) & '<13,10>' & TOD:Description
                        END

                        IF TOD:CompletedFlag AND TOD:CompletedByNotes
                           LOC:Body = LOC:Body & '<13,10>' & TOD:CompletedByNotes
                        END

                    END
                    TOD:RecordID = NxtTag:PtrM(Tag:ToDoNote)                ! SET TO NEXT ToDoNote
                    IF ~TOD:RecordID THEN BREAK.
               END
      
            ELSE

               IF TOD:DateDone and TOD:CompletedFlag
                  LOC:TOD:Date = TOD:DateDone
               ELSE
                  LOC:TOD:Date = TOD:Date
               END

               LOC:Body = Format(LOC:TOD:Date,@d17) & '<13,10>' & TOD:Description

               IF TOD:CompletedFlag AND TOD:CompletedByNotes
                  LOC:Body = LOC:Body & '<13,10>' & TOD:CompletedByNotes
               END

            END
            LOC:EmailMatterID = TOD:MatterID
            DO SendEmail
            SELECT(?ToDoNoteBrowse)
    OF ?PrintToDoNoteButton
       ThisWindow.Update
       PrintToDoNote(1)
       SELECT(?ToDoNoteBrowse)
      
    OF ?TOD:QBESearchButton
! RICK 14/9/2014 - NOT TAGGING QBE RESULTS ANYMORE - TAKES TOO LONG. JUST FILTERING

            LOC:QBEFilterToDoNoteString = ''

            DO MakeFilterToDoNoteString

            DO CreateToDoNoteQBEQueue
      
            LOC:QBEFilterToDoNoteString = GetUserQBEFilter(TAG:ToDoNote,'Search for Reminders',LOC:FilterToDoNoteString)

            DO DisplayHeading

            DO RefreshToDoNoteBrowse

            Select(?ToDoNoteBrowse,1)


           IF GLO:DebuggingFlag
              IF LOC:FilterToDoNoteString
                 SETCLIPBOARD('SELECT * FROM ToDoNote WHERE ' & LOC:FilterMatterString)
                 MESSAGE('This is the Filter being used by the Desktop. The script has been copied to your clipboard.||' & 'SELECT * FROM ToDoNote WHERE ' & LOC:FilterToDoNoteString,'Debugging',ICON:Exclamation)
              END
           END

    OF ?TOD:QBEPrintButton
            DO CreateToDoNoteQBEQueue
      
            CLEAR(GLO:QBEFilterString)
            LOC:TaggedRecordID = FstTag:PtrM(Tag:ToDoNote)
            IF LOC:TaggedRecordID AND BRW15::Filter = 0 ! THERE ARE TAGGED ITEMS BUT THE USER IS SHOWING ALL RECORDS
               IF MESSAGE('Do you want to print the tagged items only?','Report Options',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:No
                  LOC:TaggedRecordID = 0
               END
            END

            IF LOC:TaggedRecordID
               GLO:QBEFilterString = CreateQBEFilterString(TAG:ToDoNote,'A')
            ELSE
               GLO:QBEFilterString = BRW15::View:Browse{PROP:SQLFilter}
            END
            PrintUserQBEReport(0{PROP:Handle},TAG:ToDoNote,'Reminders')
    OF ?ToggleToDoNoteIconsButton
        IF  LOC:ShowToDoNoteIconsFlag
            LOC:ShowToDoNoteIconsFlag = 0
        ELSE
            LOC:ShowToDoNoteIconsFlag = 1
        END
      
        DO ToggleToDoNoteIcons
        SELECT(?ToDoNoteBrowse)
      
    OF ?CustomTOD_PeriodButton
        LOC:TOD_Period = 'Custom'
        ?LOC:TOD_Period{PROP:SELECTED} = ?LOC:TOD_Period{PROP:ITEMS}
        IF ~LOC:TOD_FromDate THEN LOC:TOD_FromDate = GLO:TodaysDate.
        IF ~LOC:TOD_ToDate THEN LOC:TOD_ToDate = GLO:TodaysDate.
        IF LOC:TOD_ToDate > GLO:TodaysDate + 10000 THEN LOC:TOD_ToDate = GLO:TodaysDate.
        GetDateRange(LOC:TOD_FromDate,LOC:TOD_ToDate)
        SELECT(?ToDoNoteBrowse)
      
    OF ?TOD:PrintButton
      POST(EVENT:Accepted,?TOD:QBEPrintButton)
    OF ?OptionalRemindersButton
      IF LOC:TOD_Matter = 'Current'  AND LOC:CurrentMatterID
      
            CLEAR(MAT:Record)
            MAT:RecordID = LOC:CurrentMatterID
      
            IF ~Access:Matter.Fetch(MAT:PrimaryKey)
      
                GlobalRequest = SelectRecord
          
                BrowseOptionalToDoItem(MAT:ToDoGroupID)
          
                IF GlobalResponse = RequestCompleted
          
                   IF ~CntTag:PtrM(Tag:ToDoItem) Then SetTag:PtrM(Tag:ToDoItem,TOI:RecordID). ! If No Tags Then Tag Current FeeCode
          
                   CLEAR(TOI:Record)
                   TOI:RecordID = FstTag:PtrM(Tag:ToDoItem)
                   LOOP 
                        IF ~Access:ToDoItem.TryFetch(TOI:PrimaryKey)
      
                           CLEAR(TOD:Record)
      
                           InsertToDoNote(MAT:RecordID,3,0)       ! COMMON PROCEDURE (SHARED WITH MERGEDOCUMENTS)
                                                                  ! ACTION = 3 (ADD) 0 = CURRENT PARTY - NOT USED FROM HERE
                           IF TOI:OptionalEventID
      
                              RunEvent# = ProcessEvent(TOI:OptionalEventID,MAT:RecordID,0,'')
                           END
      
                        END
                        TOI:RecordID = NxtTag:PtrM(Tag:ToDoItem)
                        IF ~TOI:RecordID THEN BREAK.
                   END
          
                 END
          
                 NewTag:PtrM(Tag:ToDoItem)
          
                 CheckLinkedReminders(TOD:MatterID)
          
                 DO RefreshToDoNoteBrowse
      
            END
      
      ELSE
      
       MESSAGE('This can only be done if you are viewing the Reminders for a single Matter.||Change the view to the "Current" Matter and try again.','Invalid Setting',ICON:Exclamation)
      
      END
      
      
      
        SELECT(?ToDoNoteBrowse)
    OF ?RefreshRemindersButton
         CLEAR(TOD:Record)
         DO RefreshToDoNoteBrowse
         SELECT(?ToDoNoteBrowse,1)
    OF ?CurrentMatterRemindersButton
       LOC:TOD_Matter= 'Current'
       LOC:TOD_Employee = 'All'
       GLO:TOD_EmployeeID = -1
       LOC:TOD_Period = 'All'
       LOC:TOD_Status = 'Incomplete'
      
       LOC:TOD_CriticalStep = 'All' 
       LOC:TOD_CriticalStepID = -1
      
      
       SAV:TOD_FromDate = LOC:TOD_FromDate
       SAV:TOD_ToDate = LOC:TOD_ToDate
       SAV:TOD_Period = LOC:TOD_Period
       SAV:TOD_EmployeeID = GLO:TOD_EmployeeID
       SAV:TOD_Status = LOC:TOD_Status
       SAV:TOD_Matter = LOC:TOD_Matter
       SAV:TOD_CriticalStepID = LOC:TOD_CriticalStepID
      
       DO RefreshToDoNoteBrowse
      
       DO DisplayHeading
       SELECT(?ToDoNoteBrowse,1)
    OF ?AllCurrentMatterRemindersButton
       LOC:TOD_Matter= 'Current'
       LOC:TOD_Employee = 'All'
       GLO:TOD_EmployeeID = -1
       LOC:TOD_Period = 'All'
       LOC:TOD_Status = 'All'
      
       LOC:TOD_CriticalStep = 'All' 
       LOC:TOD_CriticalStepID = -1
      
      
       SAV:TOD_FromDate = LOC:TOD_FromDate
       SAV:TOD_ToDate = LOC:TOD_ToDate
       SAV:TOD_Period = LOC:TOD_Period
       SAV:TOD_EmployeeID = GLO:TOD_EmployeeID
       SAV:TOD_Status = LOC:TOD_Status
       SAV:TOD_Matter = LOC:TOD_Matter
       SAV:TOD_CriticalStepID = LOC:TOD_CriticalStepID
      
       DO RefreshToDoNoteBrowse
      
       DO DisplayHeading
       SELECT(?ToDoNoteBrowse,1)
      
    OF ?MyRemindersButton
       LOC:TOD_Matter= 'All'
       LOC:TOD_Employee = CEM:Name
       GLO:TOD_EmployeeID = CEM:RecordID
       LOC:TOD_Period = 'Today & Earlier'
       LOC:TOD_Status = 'Incomplete'
      
       LOC:TOD_CriticalStep = 'All'
       LOC:TOD_CriticalStepID = -1
      
       SAV:TOD_FromDate = LOC:TOD_FromDate
       SAV:TOD_ToDate = LOC:TOD_ToDate
       SAV:TOD_Period = LOC:TOD_Period
       SAV:TOD_EmployeeID = GLO:TOD_EmployeeID
       SAV:TOD_Status = LOC:TOD_Status
       SAV:TOD_Matter = LOC:TOD_Matter
       SAV:TOD_CriticalStepID = LOC:TOD_CriticalStepID
      
       DO RefreshToDoNoteBrowse
      
       DO DisplayHeading
       SELECT(?ToDoNoteBrowse,1)
    OF ?MA:QBESearchButton
! RICK 14/9/2014 - NOT TAGGING QBE RESULTS ANYMORE - TAKES TOO LONG. JUST FILTERING

            LOC:QBEFilterMatActivString = ''

            DO MakeFilterMatActivString

            DO CreateMatActivQBEQueue
      
            LOC:QBEFilterMatActivString = GetUserQBEFilter(TAG:MatActiv,'Search for Time Records',LOC:FilterMatActivString)

            DO DisplayHeading

            DO RefreshMatActivBrowse

            Select(?TimeRecordingBrowse,1)


           IF GLO:DebuggingFlag
              IF LOC:FilterMatActivString
                 SETCLIPBOARD('SELECT * FROM MatActiv WHERE ' & LOC:FilterMatterString)
                 MESSAGE('This is the Filter being used by the Desktop. The script has been copied to your clipboard.||' & 'SELECT * FROM MatActiv WHERE ' & LOC:FilterMatActivString,'Debugging',ICON:Exclamation)
              END
           END
    OF ?MA:QBEPrintButton
            DO CreateMatActivQBEQueue
      
            CLEAR(GLO:QBEFilterString)
            LOC:TaggedRecordID = FstTag:PtrM(Tag:MatActiv)
            IF LOC:TaggedRecordID AND BRW22::Filter = 0 ! THERE ARE TAGGED ITEMS BUT THE USER IS SHOWING ALL RECORDS
               IF MESSAGE('Do you want to print the tagged Records only?','Report Options',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:No
                  LOC:TaggedRecordID = 0
               END
            END
            
            IF LOC:TaggedRecordID
               GLO:QBEFilterString = CreateQBEFilterString(TAG:MatActiv,'A')
            ELSE
               GLO:QBEFilterString = BRW22::View:Browse{PROP:SQLFilter}
            END
            PrintUserQBEReport(0{PROP:Handle},TAG:MatActiv,'Time/Activity Report')
    OF ?CustomMA_PeriodButton
        LOC:MA_Period = 'Custom'
        ?LOC:MA_Period{PROP:SELECTED} = ?LOC:MA_Period{PROP:ITEMS}
        IF ~LOC:MA_FromDate THEN LOC:MA_FromDate = GLO:TodaysDate.
        IF ~LOC:MA_ToDate THEN LOC:MA_ToDate = GLO:TodaysDate.
        IF LOC:MA_ToDate > GLO:TodaysDate + 10000 THEN LOC:MA_ToDate = GLO:TodaysDate.
        GetDateRange(LOC:MA_FromDate,LOC:MA_ToDate)
      
    OF ?MA:PrintButton
      POST(EVENT:Accepted,?MA:QBEPrintButton)
    OF ?AdjustTimeButton
      ! pk here
      AdjustTimeMatActiv
      DO RefreshMatActivBrowse
      
    OF ?SendReceiveButton
      ThisWindow.Update

      NewTag:PtrM(TAG:Matter)
      IF CEM:DataLinkBranchID
         !13/08/2014 Check if MAT:LawSuite has a valid value
         IF ~MAT:LawSuite
             IF MAT:DataLinkSuite
                MAT:LawSuite = MAT:DataLinkSuite
                Access:Matter.Update
             END
         END

         ! 27/01/2015 Sameer: Don't check for valid MAT:LawSuite when receiving messages from the bank since these messages are not related to the selected matter
         ! 27/01/2015 Sameer: All we are doing here is receiving messages (and sending back acknowledgement messages in some cases, see ProcessLitigationMatter)
         !IF ~MAT:LawSuite OR MAT:LawSuite = 0
         !    Message(MAT:FileRef & ' is not a LAW Matter.|','Error',ICON:Exclamation)
         !    !BREAK
         !END

         ! 05/05/2016 Sameer: We use the new EXE for both Nedbank and Standard Bank
         IF EXISTS('LegalSuite.LawDataLinkIntegration.exe')
           IF (CTL:FirmCode = 'ACME01') THEN
             
             RUN('LegalSuite.LawDataLinkIntegration.exe ' & GLO:SQLLogin & ' Action=' & 'GetMessage' & ' BranchId=' & BRA:RecordID & ' SuiteId=' & MAT:LawSuite & ' MessageId=' & LAW_MSG:Number & ' MatterId=' & MAT:RecordID & ' EmployeeId=' & CEM:RecordID & ' MatterIdFile=0 DefaultBank=' & CEM:DefaultBank & ' /Debug /Test', 1)
           ELSE
             IF (CEM:DebuggingFlag) THEN
             
               RUN('LegalSuite.LawDataLinkIntegration.exe ' & GLO:SQLLogin & ' Action=' & 'GetMessage' & ' BranchId=' & BRA:RecordID & ' SuiteId=' & MAT:LawSuite & ' MessageId=' & LAW_MSG:Number & ' MatterId=' & MAT:RecordID & ' EmployeeId=' & CEM:RecordID & ' MatterIdFile=0 DefaultBank=' & CEM:DefaultBank & ' /Debug', 1)
             ELSE
             
               RUN('LegalSuite.LawDataLinkIntegration.exe ' & GLO:SQLLogin & ' Action=' & 'GetMessage' & ' BranchId=' & BRA:RecordID & ' SuiteId=' & MAT:LawSuite & ' MessageId=' & LAW_MSG:Number & ' MatterId=' & MAT:RecordID & ' EmployeeId=' & CEM:RecordID & ' MatterIdFile=0 DefaultBank=' & CEM:DefaultBank, 1)
             END
           END
         ELSE
           MESSAGE('Unable to locate e4 DataLink Integration program file (LegalSuite.LawDataLinkIntegration.exe)','Unable to load e4 DataLink Integration program',ICON:Exclamation)
         END

         ! Carry on as normal
         !MESSAGE('About to call DataLink.CheckDataLinkMessages(BranchId, ''Read'')')
         Result# = CheckDataLinkMessages(CEM:DataLinkBranchID,'Read')
!               message('Result# = ' & Result# &|
!                       '|CntTag:PtrM(TAG:Matter) = ' & CntTag:PtrM(TAG:Matter) &|
!                       '|FstTag:PtrM(TAG:Matter) = ' & FstTag:PtrM(TAG:Matter))
         IF CntTag:PtrM(TAG:Matter)
            DO ShowDataLinkInboxStatus
            SELECT(?MattersBrowse)
            LOC:JumpToRecordID = FstTag:PtrM(TAG:Matter)
            POST(EVENT:JumpToMatter)
            SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
         ELSE
            DO ShowDataLinkInboxStatus
         END
      ELSE
         GlobalRequest = SelectRecord
         BrowseBranch
         IF GlobalResponse = RequestCompleted
            IF BRA:RecordID
               CEM:DataLinkBranchID = BRA:RecordID
               PropSQL('UPDATE Employee SET DataLinkBranchID = ' & BRA:RecordID & ' WHERE RecordID = ' & CEM:RecordID)
               Result# = CheckDataLinkMessages(CEM:DataLinkBranchID,'Read')
               IF CntTag:PtrM(TAG:Matter)
                  DO ShowDataLinkInboxStatus
                  SELECT(?MattersBrowse)
                  LOC:JumpToRecordID = FstTag:PtrM(TAG:Matter)
                  POST(EVENT:JumpToMatter)
                  SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
               ELSE
                  DO ShowDataLinkInboxStatus
               END
            END
         END
      END ! IF CEM:DataLinkBranchID

      

    OF ?ProcessInboxMessages
       ! 15/02/2017 PK Naidoo:
       GlobalRequest = SelectRecord
      
       BrowseBranch
       IF GlobalResponse = RequestCompleted
          IF BRA:RecordID
             CEM:DataLinkBranchID = BRA:RecordID
             PropSQL('UPDATE Employee SET DataLinkBranchID = ' & BRA:RecordID & ' WHERE RecordID = ' & CEM:RecordID)
             Result# = CheckDataLinkMessages(CEM:DataLinkBranchID,'Read')
             IF CntTag:PtrM(TAG:Matter)
                DO ShowDataLinkInboxStatus
                SELECT(?MattersBrowse)
                LOC:JumpToRecordID = FstTag:PtrM(TAG:Matter)
                POST(EVENT:JumpToMatter)
                SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
             ELSE
                DO ShowDataLinkInboxStatus
             END
          END
       END
    OF ?SendXMLMessageButton
    LOOP 1 TIMES

         IF FstTag:PtrM(TAG:Matter)

            IF MESSAGE('Do you want to send the same Message for all the tagged Matters?','Sending DataLink Message',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:No

               MESSAGE('Untag the Matters before sending a DataLink message','Untag Matters',ICON:Exclamation)
               BREAK

            ELSE

               IF ~CEM:DataLinkBranchID
                   GlobalRequest = SelectRecord
                   BrowseBranch
                   IF GlobalResponse = RequestCompleted
                      IF BRA:RecordID
                         CEM:DataLinkBranchID = BRA:RecordID
                         PropSQL('UPDATE Employee SET DataLinkBranchID = ' & BRA:RecordID & ' WHERE RecordID = ' & CEM:RecordID)
                     END
                  END
               END
               
               IF ~CEM:DataLinkBranchID THEN BREAK.
               
               BRA:RecordID = CEM:DataLinkBranchID
               IF Access:Branch.TryFetch(BRA:PrimaryKey)
                  Message('Unable to access the Branch (' & CEM:DataLinkBranchID & ').|','Branch Access Error',ICON:Exclamation)
                  BREAK
               END


               GlobalRequest = SelectRecord
               SelectXMLMessage(FstTag:PtrM(Tag:Matter))
           
               IF GlobalResponse = RequestCompleted

                  ! Changed By Rick - Better pattern to write out a CSV

                  GLO:FileName     = 'DataLink\MatterIdFile' & CEM:RecordID & '.txt'
                  GLO:DOSFIleOUT   = GLO:FileName

                  LOOP 1 TIMES

                    IF EXISTS(GLO:Filename)

                        REMOVE(GLO:Filename)
                        IF ERRORCODE()

                          MESSAGE('Error Removing DataLink File|Filename: ' & GLO:FileName & '|Error: ' & Error(),'Remove File Error',ICON:Exclamation)
                          BREAK

                        END
                    END

                    Create(DOSFileOut)
                    IF ERRORCODE()

                        MESSAGE('Error Creating DataLink File|Filename: ' & GLO:FileName & '|Error: ' & Error(),'File Creation Error',ICON:Exclamation)
                        CLOSE(DOSFileOut)
                        BREAK

                     END

                   END

                   Relate:DOSFileOut.Open

                   DOUT:Line = ''

                   MAT:RecordId = FstTag:PtrM(TAG:Matter)

                   LOOP

                     DOUT:Line = CLIP(DOUT:Line) & MAT:RecordId & ','

                     MAT:RecordId = NxtTag:PtrM(Tag:Matter)

                     IF ~MAT:RecordId THEN BREAK.

                   END ! LOOP


                   ! Save the file and remove trailing comma
                   Append(DOSFileOut,LEN(CLIP(DOUT:Line)) - 1)

                   Relate:DOSFileOut.Close


                   ! 05/05/2016 Sameer: We use the new EXE for both Nedbank and Standard Bank

                   !IF CTL:FirmCode <> 'ACME01' AND INLIST(MAT:LawSuite, 459, 472, 473) THEN
                       ! 10/11/2015 Sameer: Build up matterId CSV from tagged matters
!                       MAT:RecordId = FstTag:PtrM(TAG:Matter)
!                       LOC:DataLinkMatterIdsCsv = ''
!
!                       LOOP
!
!                         Access:Matter.Fetch(MAT:PrimaryKey)
!
!                         LOC:DataLinkMatterIdsCsv = LOC:DataLinkMatterIdsCsv & MAT:RecordId & ','
!
!                         MAT:RecordId = NxtTag:PtrM(Tag:Matter)
!
!                         IF ~MAT:RecordId THEN
!
!                           ! Remove trailing comma
!                           LOC:DataLinkMatterIdsCsv = SUB(LOC:DataLinkMatterIdsCsv, 1, LEN(LOC:DataLinkMatterIdsCsv) - 1)
!
!                           BREAK
!                         END
!
!                       END ! LOOP
!
!                       ! 22/03/2017 PK Naidoo: FB Case 595
!                        ! -------- WRITE TO FILE -----------
!
!                        GLO:Filename = 'DataLink\MatterIdFile.txt'
!
!                        IF EXISTS(GLO:Filename)
!
!                            REMOVE(GLO:Filename)
!                            IF ERRORCODE()
!
!                              MESSAGE('Error Removing DataLink File|Filename: ' & GLO:FileName & '|Error: ' & Error(),'Print Cheque',ICON:Exclamation)
!
!                            END
!                        END
!
!                        CREATE(ASCIIFILE)
!                        IF ERRORCODE()
!
!                          MESSAGE('Error Creating DataLink File|Filename: ' & GLO:FileName & '|Error: ' & Error(),'DataLink File',ICON:Exclamation)
!                          CLOSE(ASCIIFILE)
!                        END
!
!                        Relate:AsciiFile.Open
!
!                        !OPEN(ASCIIFILE)
!                        !IF ERRORCODE()
!
!                        !  MESSAGE('Error Opening DataLink File|Filename: ' & GLO:FileName & '|Error: ' & Error(),'DataLink File',ICON:Exclamation)
!                        !  CLOSE(ASCIIFILE)
!                        !END
!
!                        ASC:String = LOC:DataLinkMatterIdsCsv
!                        
!                        ADD(ASCIIFILE)
!
!                        IF ERRORCODE()
!
!                          MESSAGE('Error Adding Data To DataLink File|Filename: ' & GLO:FileName & '|Error: ' & Error(),'DataLink File',ICON:Exclamation)
!
!                        END
!
!                        CLOSE(ASCIIFILE)
!
!                       ! ------------ END -----------------


                       IF EXISTS('LegalSuite.LawDataLinkIntegration.exe')
                         IF (CTL:FirmCode = 'ACME01') THEN
                           
                           RUN('LegalSuite.LawDataLinkIntegration.exe ' & GLO:SQLLogin & ' Action=' & 'PutMessage' & ' BranchId=' & BRA:RecordID & ' SuiteId=' & MAT:LawSuite & ' MessageId=' & LAW_MSG:Number & ' MatterId=0 EmployeeId=' & CEM:RecordID & ' MatterIdFile="' & GLO:Filename & '" /Debug /Test', 1)
                         ELSE
                           IF (CEM:DebuggingFlag) THEN
                           
                             RUN('LegalSuite.LawDataLinkIntegration.exe ' & GLO:SQLLogin & ' Action=' & 'PutMessage' & ' BranchId=' & BRA:RecordID & ' SuiteId=' & MAT:LawSuite & ' MessageId=' & LAW_MSG:Number & ' MatterId=0 EmployeeId=' & CEM:RecordID & ' MatterIdFile="' & GLO:Filename & '" /Debug', 1)
                           ELSE

                             RUN('LegalSuite.LawDataLinkIntegration.exe ' & GLO:SQLLogin & ' Action=' & 'PutMessage' & ' BranchId=' & BRA:RecordID & ' SuiteId=' & MAT:LawSuite & ' MessageId=' & LAW_MSG:Number & ' MatterId=0 EmployeeId=' & CEM:RecordID & ' MatterIdFile="' & GLO:Filename & '"', 1)
                           END
                         END
                       ELSE
                         MESSAGE('Unable to locate e4 DataLink Integration program file (LegalSuite.LawDataLinkIntegration.exe)','Unable to load e4 DataLink Integration program',ICON:Exclamation)
                       END

                       IF RECORDS(GEQ:ErrorQueue)
                         BrowseErrorQueue('Finished Sending Message (' & LAW_MSG:Number & ')')
                      END

                      DO RefreshFileNoteBrowse

                      DO RefreshDataLinkBrowse

                   !ELSE
!                       ! Old implementation
!                       Debug('before CreateXMLMessage')
!                       IF ~CreateXMLMessage(FstTag:PtrM(Tag:Matter),LAW_MSG:RecordID)
!
!                           CLEAR(MAT:Record)
!                           MAT:RecordID = FstTag:PtrM(Tag:Matter)
!                           SAV:MAT:FileRef = ''
!                           LOOP
!                                IF ~Access:Matter.Fetch(MAT:PrimaryKey)
!
!                                    IF ~MAT:LawSuite
!                                        Message(MAT:FileRef & ' is not a LAW Matter.|','Skipping This Matter',ICON:Exclamation)
!                                    ELSE
!                                        If SAV:MAT:FileRef <> '' ! ignore first time
!                                          Debug('Use Last XML: ' & SAV:MAT:FileRef)
!                                          SetMessageBody(SAV:MAT:FileRef,SAV:MAT:LAWRef,MAT:FileRef,MAT:LAWRef)
!                                        .
!                                        XMLSendDataLinkLAWMessage(MAT:RecordID,LAW_MSG:Number,CEM:DataLinkBranchID)
!                                        SAV:MAT:FileRef = MAT:FileRef
!                                        SAV:MAT:LAWRef = MAT:LAWRef
!                                    END
!
!                                END
!
!                                MAT:RecordID = NxtTag:PtrM(Tag:Matter)
!                                IF ~MAT:RecordID THEN BREAK.
!
!                           END
!
!                           IF RECORDS(GEQ:ErrorQueue)
!                              BrowseErrorQueue('Finished Sending Message (' & LAW_MSG:Number & ')')
!                           END
!
!                           DO RefreshFileNoteBrowse
!
!                           DO RefreshDataLinkBrowse
!
!                       END ! IF CreateXMLMessage
!                   END ! IF CTL:FirmCode <> 'ACME01' AND INLIST(MAT:LawSuite, 459, 472, 473)

               END ! IF GlobalResponse = RequestCompleted

            END  ! IF MESSAGE

         ELSE    ! NO TAGGED MATTERS
           
           CLEAR(MAT1:Record)
           ThisWindow.Update
           
           IF LOC:DAT_Matter = 'Current'

             LOC:MAT:RecordID = LOC:CurrentMatterID
             
           ELSE

             IF MAT1:RecordID

                  LOC:MAT:RecordID = GetMatterID(MAT1:RecordID)
                
             ELSE
                IF ~SAV:LastMatterID THEN SAV:LastMatterID = LOC:CurrentMatterID.

                  LOC:MAT:RecordID = GetMatterID(SAV:LastMatterID)
                
              END

           END
           IF ~LOC:MAT:RecordID THEN CYCLE.
           
           MAT:RecordID = LOC:MAT:RecordID
           Access:Matter.Fetch(MAT:PrimaryKey)

           IF ~MAT:LawSuite
               IF MAT:DataLinkSuite
                  MAT:LawSuite = MAT:DataLinkSuite
                  Access:Matter.Update
               END
           END

           
           IF ~MAT:LawSuite
               Message(MAT:FileRef & ' is not a LAW Matter.|','Error',ICON:Exclamation)
               BREAK
           END
           
           IF ~CEM:DataLinkBranchID
               GlobalRequest = SelectRecord
               BrowseBranch
               IF GlobalResponse = RequestCompleted
                  IF BRA:RecordID
                     CEM:DataLinkBranchID = BRA:RecordID
                     PropSQL('UPDATE Employee SET DataLinkBranchID = ' & BRA:RecordID & ' WHERE RecordID = ' & CEM:RecordID)
                 END
              END
           END
           
           IF ~CEM:DataLinkBranchID THEN BREAK.
           
           BRA:RecordID = CEM:DataLinkBranchID
           IF Access:Branch.TryFetch(BRA:PrimaryKey)
              Message('Unable to access the Branch (' & CEM:DataLinkBranchID & ').|','Branch Access Error',ICON:Exclamation)
              BREAK
           END
           
           AddToFavourites(LOC:MAT:RecordID)

           GlobalRequest = SelectRecord
           SelectXMLMessage(LOC:MAT:RecordID)
           
           IF GlobalResponse = RequestCompleted

              ! 05/05/2016 Sameer: We use the new EXE for both Nedbank and Standard Bank

               !IF CTL:FirmCode <> 'ACME01' AND INLIST(MAT:LawSuite, 459, 472, 473) THEN
                   IF EXISTS('LegalSuite.LawDataLinkIntegration.exe')
                     IF (CTL:FirmCode = 'ACME01') THEN
                       
                       RUN('LegalSuite.LawDataLinkIntegration.exe ' & GLO:SQLLogin & ' Action=' & 'PutMessage' & ' BranchId=' & BRA:RecordID & ' SuiteId=' & MAT:LawSuite & ' MessageId=' & LAW_MSG:Number & ' MatterId=' & MAT:RecordID & ' EmployeeId=' & CEM:RecordID & ' MatterIdFile=0 /Debug /Test', 1)
                     ELSE
                       IF (CEM:DebuggingFlag) THEN
                       
                         RUN('LegalSuite.LawDataLinkIntegration.exe ' & GLO:SQLLogin & ' Action=' & 'PutMessage' & ' BranchId=' & BRA:RecordID & ' SuiteId=' & MAT:LawSuite & ' MessageId=' & LAW_MSG:Number & ' MatterId=' & MAT:RecordID & ' EmployeeId=' & CEM:RecordID & ' MatterIdFile=0 /Debug', 1)
                       ELSE
                       
                         RUN('LegalSuite.LawDataLinkIntegration.exe ' & GLO:SQLLogin & ' Action=' & 'PutMessage' & ' BranchId=' & BRA:RecordID & ' SuiteId=' & MAT:LawSuite & ' MessageId=' & LAW_MSG:Number & ' MatterId=' & MAT:RecordID & ' EmployeeId=' & CEM:RecordID & ' MatterIdFile=0 ', 1)
                       END
                     END
                   ELSE
                     MESSAGE('Unable to locate e4 DataLink Integration program file (LegalSuite.LawDataLinkIntegration.exe)','Unable to load e4 DataLink Integration program',ICON:Exclamation)
                   END

                  IF RECORDS(GEQ:ErrorQueue)
                    BrowseErrorQueue('Finished Sending Message (' & LAW_MSG:Number & ')')
                  END

                  DO RefreshFileNoteBrowse

                  DO RefreshDataLinkBrowse

              !ELSE
!                  ! Old implementation
!                  IF ~CreateXMLMessage(LOC:MAT:RecordID,LAW_MSG:RecordID)
!                      XMLSendDataLinkLAWMessage(LOC:MAT:RecordID,LAW_MSG:Number,CEM:DataLinkBranchID)
!                      IF RECORDS(GEQ:ErrorQueue)
!                         BrowseErrorQueue('Finished Sending Message (' & LAW_MSG:Number & ')')
!                      END
!
!                      DO RefreshFileNoteBrowse
!
!                      DO RefreshDataLinkBrowse
!
!                  END
!              END ! IF CTL:FirmCode <> 'ACME01' AND INLIST(MAT:LawSuite, 459, 472, 473)
           END

        END

   END ! LOOP 1 TIMES
    OF ?ExploreInbox
            IF CEM:DataLinkBranchID
               BRA:RecordID = CEM:DataLinkBranchID
               IF ~Access:Branch.Fetch(BRA:PrimaryKey)
                  IF BRA:DataLinkInboxLocation
      
                     ! 05/05/2016 Sameer: Use ShellExecute to open the folder instead
                     !RUN('EXPLORER.EXE /e,/select,' & GetRoot(BRA:DataLinkInboxLocation))
                     SHELL:AssocFile = GetRoot(BRA:DataLinkInboxLocation)
                     SHELL:Operation = 'open'
                     SHELL:Param     = ''
                     SHELL:Directory = ''
              
                     ShellExecute(GetDesktopWindow(),SHELL:Operation,SHELL:AssocFile,SHELL:Param,SHELL:Directory,1)
      
                     If ErrorCode()
                        Message(Error() & '||Error running program EXPLORER.EXE||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                     End
                  END
               END
      
            ELSE
               GlobalRequest = SelectRecord
               BrowseBranch
               IF GlobalResponse = RequestCompleted
                  IF BRA:RecordID
                     CEM:DataLinkBranchID = BRA:RecordID
                     PropSQL('UPDATE Employee SET DataLinkBranchID = ' & BRA:RecordID & ' WHERE RecordID = ' & CEM:RecordID)
      
                     IF ~Access:Branch.Fetch(BRA:PrimaryKey)
                         IF BRA:DataLinkInboxLocation
      
                            ! 05/05/2016 Sameer: Use ShellExecute to open the folder instead
                            !RUN('EXPLORER.EXE /e,/select,' & GetRoot(BRA:DataLinkInboxLocation))
                            SHELL:AssocFile = GetRoot(BRA:DataLinkInboxLocation)
                            SHELL:Operation = 'open'
                            SHELL:Param     = ''
                            SHELL:Directory = ''
                     
                            ShellExecute(GetDesktopWindow(),SHELL:Operation,SHELL:AssocFile,SHELL:Param,SHELL:Directory,1)
      
                            If ErrorCode()
                               Message(Error() & '||Error running program EXPLORER.EXE||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                            End
                         END
                     END
                  END
               END
            END
      
            
      
      
      
    OF ?ExploreOutbox
            IF CEM:DataLinkBranchID
               BRA:RecordID = CEM:DataLinkBranchID
               IF ~Access:Branch.Fetch(BRA:PrimaryKey)
                  IF BRA:DataLinkOutboxLocation
                     
                     ! 05/05/2016 Sameer: Use ShellExecute to open the folder instead
                     !RUN('EXPLORER.EXE /e,/select,' & GetRoot(BRA:DataLinkOutboxLocation))
                     SHELL:AssocFile = GetRoot(BRA:DataLinkOutboxLocation)
                     SHELL:Operation = 'open'
                     SHELL:Param     = ''
                     SHELL:Directory = ''
              
                     ShellExecute(GetDesktopWindow(),SHELL:Operation,SHELL:AssocFile,SHELL:Param,SHELL:Directory,1)
      
                     If ErrorCode()
                        Message(Error() & '||Error running program EXPLORER.EXE||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                     End
                  END
               END
      
            ELSE
               GlobalRequest = SelectRecord
               BrowseBranch
               IF GlobalResponse = RequestCompleted
                  IF BRA:RecordID
                     CEM:DataLinkBranchID = BRA:RecordID
                     PropSQL('UPDATE Employee SET DataLinkBranchID = ' & BRA:RecordID & ' WHERE RecordID = ' & CEM:RecordID)
      
                     IF ~Access:Branch.Fetch(BRA:PrimaryKey)
                         IF BRA:DataLinkOutboxLocation
      
                            ! 05/05/2016 Sameer: Use ShellExecute to open the folder instead
                            !RUN('EXPLORER.EXE /e,/select,' & GetRoot(BRA:DataLinkOutboxLocation))
                            SHELL:AssocFile = GetRoot(BRA:DataLinkOutboxLocation)
                            SHELL:Operation = 'open'
                            SHELL:Param     = ''
                            SHELL:Directory = ''
                     
                            ShellExecute(GetDesktopWindow(),SHELL:Operation,SHELL:AssocFile,SHELL:Param,SHELL:Directory,1)
      
                            If ErrorCode()
                               Message(Error() & '||Error running program EXPLORER.EXE||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                            End
                         END
                     END
                  END
               END
            END
      
            
      
      
      
    OF ?DAT:QBESearchButton
! RICK 14/9/2014 - NOT TAGGING QBE RESULTS ANYMORE - TAKES TOO LONG. JUST FILTERING
!JESS2
            LOC:QBEFilterFeeNoteString = ''

            DO MakeFilterLawMatterMessageString

            DO CreateLawMatterMessageQBEQueue
      
            LOC:QBEFilterLawMatterMessageString = GetUserQBEFilter(TAG:LawMatterMessage,'Search for DataLink Messages',LOC:FilterLawMatterMessageString)

            DO DisplayHeading

            DO RefreshDataLinkBrowse

            Select(?LawMatterMessageBrowse,1)


           IF GLO:DebuggingFlag
              IF LOC:FilterLawMatterMessageString
                 SETCLIPBOARD('SELECT * FROM LawMatterMessage WHERE ' & LOC:FilterLawMatterMessageString)
                 MESSAGE('This is the Filter being used by the Desktop. The script has been copied to your clipboard.||' & 'SELECT * FROM LawMatterMessage WHERE ' & LOC:FilterLawMatterMessageString,'Debugging',ICON:Exclamation)
              END
           END

      
    OF ?DAT:QBEPrintButton
            DO CreateLawMatterMessageQBEQueue
      
            CLEAR(GLO:QBEFilterString)
            LOC:TaggedRecordID = FstTag:PtrM(Tag:LawMatterMessage)
            IF LOC:TaggedRecordID AND BRW36::Filter = 0 ! THERE ARE TAGGED ITEMS BUT THE USER IS SHOWING ALL RECORDS
               IF MESSAGE('Do you want to print the tagged Messages only?','Report Options',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:No
                  LOC:TaggedRecordID = 0
               END
            END
            
            IF LOC:TaggedRecordID
               GLO:QBEFilterString = CreateQBEFilterString(TAG:LawMatterMessage,'A')
            ELSE
               GLO:QBEFilterString = BRW36::View:Browse{PROP:SQLFilter}
           END
      
           PrintUserQBEReport(0{PROP:Handle},TAG:LawMatterMessage,'DataLink Message Report')
      
    OF ?DataLinkJumpToMatterButton
        SELECT(?MattersBrowse)
        LOC:JumpToRecordID = MME:MatterID
        POST(EVENT:JumpToMatter)
        SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
    OF ?CustomDAT_PeriodButton
        LOC:DAT_Period = 'Custom'
        ?LOC:DAT_Period{PROP:SELECTED} = ?LOC:DAT_Period{PROP:ITEMS}
        IF ~LOC:DAT_FromDate THEN LOC:DAT_FromDate = GLO:TodaysDate.
        IF ~LOC:DAT_ToDate THEN LOC:DAT_ToDate = GLO:TodaysDate.
        IF LOC:DAT_ToDate > GLO:TodaysDate + 10000 THEN LOC:DAT_ToDate = GLO:TodaysDate.
        GetDateRange(LOC:DAT_FromDate,LOC:DAT_ToDate)
      
    OF ?ABSAImportExportButton
        LOC:BankDownloadSelection = 1
        !FB 1321
        !IF CTL:AG_TestSuiteFlag
        !   LOC:SuiteDownloadSelection = 118
        !Else
        !   LOC:SuiteDownloadSelection = 119
        !End
        LOC:SuiteDownloadSelection = -1
        !FB 1321 END

        PropSQLNext('Select Count (1) FROM Licensed WHERE EmployeeID = ' & GLO:EmployeeId & ' And DocgenID IN (SELECT RecordID FROM Docgen WHERE NoOfUsers > 0 AND Code IN (''ABSA'',''STD''))')
        If ROW:Counter > 1

          LOC:GoAhead = 0
          LOC:BankDownloadSelection = 1
          OPEN(LAWSelectionWindow)
          Display
          Accept
            Case Field()
            Of ?LAWSelectionOKButton
              Case Event()
              Of EVENT:Accepted
                LOC:GoAhead = 1
                Break
              End
            Of ?LAWSelectionCancelButton
              Case Event()
              Of EVENT:Accepted
                Break
              End
            End
          End
          CLOSE(LAWSelectionWindow)

          If ~LOC:GoAhead
            Message('Operation aborted by User','Import Cancelled',ICON:Exclamation)
            PropSQL('Update Control Set EmployeeIdUpdatingABSA = 0 Where RecordID = 1')
            Return Level:Notify
          End

          Case LOC:BankDownloadSelection

          Of 1                                  ! ABSA
            IF CTL:AG_TestSuiteFlag
              LOC:SuiteDownloadSelection = 118
            Else
              LOC:SuiteDownloadSelection = 119
            End

          Of 2                                  ! STD
            IF CTL:AG_TestSuiteFlag
              LOC:SuiteDownloadSelection = 10
            Else
              LOC:SuiteDownloadSelection = 12
            End
          End

        Else

          PropSQLNext('Select DocGenID FROM Licensed WHERE EmployeeID = ' & GLO:EmployeeId & ' And DocgenID IN (SELECT RecordID FROM Docgen WHERE NoOfUsers > 0 AND Code IN (''ABSA'',''STD''))')
          PropSQLNext('Select RecordId,Code From DocGen where RecordID = ' & ROW:Counter)

          Case ROW:Description
          Of 'ABSA'
            LOC:BankDownloadSelection = 1
            IF CTL:AG_TestSuiteFlag
              LOC:SuiteDownloadSelection = 118
            Else
              LOC:SuiteDownloadSelection = 119
            End
          Of 'STD'
            LOC:BankDownloadSelection = 2
            IF CTL:AG_TestSuiteFlag
              LOC:SuiteDownloadSelection = 10
            Else
              LOC:SuiteDownloadSelection = 12
            End
          End
        End
        !FB 1321
        IF LOC:SuiteDownloadSelection > 1
            RunBondCentreProgram(0,LOC:SuiteDownloadSelection,'Get_Messages')
        END
        !FB 1321 END

        FREE(GEQ:ErrorQueue)
        CLEAR(GEQ:ErrorQueue)
        LOC:JumpToRecordID = 0
        GLO:RecordID = 0

        YIELD

        ProcessUnReadABSAMessages(LOC:SuiteDownloadSelection)

        IF RECORDS(GEQ:ErrorQueue)
           BrowseErrorQueue('Finished Importing Bond Centre messages')
        END
        
        LOC:JumpToRecordID = GLO:RecordID ! SETTING THIS TO THE FIRST MATTER IMPORTED SO USER JUMPS TO IT.
        IF LOC:JumpToRecordID
          SELECT(?MattersBrowse)
          POST(EVENT:JumpToMatter)
          SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
        END
      
        DO RefreshABSALinkBrowse
        Do ShowABSAImportedStatus

    OF ?SendABSAMessageButton
      
        FREE(GEQ:ErrorQueue)
        CLEAR(GEQ:ErrorQueue)
          
        CLEAR(MAT1:Record)
        ThisWindow.Update
      
        IF LOC:ABSA_Matter = 'Current'
          LOC:MAT:RecordID = LOC:CurrentMatterID
        ELSE
          IF MAT1:RecordID
             LOC:MAT:RecordID = GetMatterID(MAT1:RecordID)
          ELSE
             IF ~SAV:LastMatterID THEN SAV:LastMatterID = LOC:CurrentMatterID.
             LOC:MAT:RecordID = GetMatterID(SAV:LastMatterID)
          END
        END
        IF ~LOC:MAT:RecordID THEN CYCLE.
      
        RunBondCentreProgram(LOC:MAT:RecordID,0,'Put_Message')
      
        FREE(GEQ:ErrorQueue)
        CLEAR(GEQ:ErrorQueue)
        LOC:JumpToRecordID = 0
        
        AddElectronicLinkLog('Send ABSA Message','ABS')
      
        DO RefreshABSALinkBrowse
        Do ShowABSAImportedStatus

    OF ?ABSASendReceiveDocsButton
      
        FREE(GEQ:ErrorQueue)
        CLEAR(GEQ:ErrorQueue)
          
        CLEAR(MAT1:Record)
        ThisWindow.Update
      
        IF LOC:ABSA_Matter = 'Current'
          LOC:MAT:RecordID = LOC:CurrentMatterID
        ELSE
          IF MAT1:RecordID
            LOC:MAT:RecordID = GetMatterID(MAT1:RecordID)
          ELSE
            IF ~SAV:LastMatterID THEN SAV:LastMatterID = LOC:CurrentMatterID.
            LOC:MAT:RecordID = GetMatterID(SAV:LastMatterID)
          END
        END
        IF ~LOC:MAT:RecordID THEN CYCLE.
      
        RunBondCentreProgram(LOC:MAT:RecordID,0,'Get_Documents')

        FREE(GEQ:ErrorQueue)
        CLEAR(GEQ:ErrorQueue)
        LOC:JumpToRecordID = 0

        DO RefreshABSALinkBrowse

        Do ShowABSAImportedStatus


        ! 12/11/2013 - TAKE THE USER STRAIGHT TO THE DOCUMENT LOG
        GLO:MatterID = LOC:MAT:RecordID
        AddToFavourites(LOC:MAT:RecordID)
        BrowseDocLog
        GLO:MatterID = 0
        SELECT(?ABSALinkBrowse)



    OF ?ABSALinkJumpToMatterButton
        SELECT(?MattersBrowse)
        LOC:JumpToRecordID = ABMM:MatterID
        POST(EVENT:JumpToMatter)
        SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
      
    OF ?ABSAMessageCentreButton
        LOC:BranchRecordId = AG_GetBranchID(0)
      
        IF LOC:BranchRecordId = 0      ! USER ABORTED SELECTION
      
            Return Level:Notify
      
        ELSIF LOC:BranchRecordId < 0   ! NO BRANCHES HAVE AN ATTORNEY KREF
      
            IF MESSAGE('The FNBLink needs to have at least one branch setup in LegalSuite to identify your company when you communicate with the bank.' &|
                       '||None of your branches have been activated, i.e. they have not been registered with the Attorney Gateway.' &|
                       '||Would you like to activate your branch now?','No Activated Branch found',ICON:Exclamation,BUTTON:Yes+Button:No,BUTTON:Yes,1) = BUTTON:Yes
      
               BrowseBranch
      
            END
      
            Return Level:Notify
      
        ELSE
          IF EXISTS('AGLoadMC.exe')
            RUN('AGLoadMC.exe "'  & GLO:SQLLogin & '" ' & LOC:BranchRecordId & ' ' & CEM:RecordID &' ' & MAT:RecordID)
            If ErrorCode()
              Message(Error() & '||Error running program AGLoadMC.exe||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
              Return Level:Notify
            End
          Else
            Message('AGLoadMC.exe Not Found||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
            Return Level:Notify
          End
      
        END
      
    OF ?ABSACircularsButton
        BrowseBankCirculars('ABSA')
        BrowseBankCirculars('SBSA')
    OF ?CustomABSA_PeriodButton
        LOC:ABSA_Period = 'Custom'
        ?LOC:ABSA_Period{PROP:SELECTED} = ?LOC:ABSA_Period{PROP:ITEMS}
        IF ~LOC:ABSA_FromDate THEN LOC:ABSA_FromDate = GLO:TodaysDate.
        IF ~LOC:ABSA_ToDate THEN LOC:ABSA_ToDate = GLO:TodaysDate.
        IF LOC:ABSA_ToDate > GLO:TodaysDate + 10000 THEN LOC:ABSA_ToDate = GLO:TodaysDate.
        GetDateRange(LOC:ABSA_FromDate,LOC:ABSA_ToDate)
      
    OF ?ABSAUBODocuments
      !FB 2833
      LOC:BankDownloadSelection = 1
            
              LOC:SuiteDownloadSelection = -1
            
      
      
                PropSQLNext('Select DocGenID FROM Licensed WHERE EmployeeID = ' & GLO:EmployeeId & ' And DocgenID IN (SELECT RecordID FROM Docgen WHERE NoOfUsers > 0 AND Code IN (''ABSA''))')
                PropSQLNext('Select RecordId,Code From DocGen where RecordID = ' & ROW:Counter)
      
                Case ROW:Description
                Of 'ABSA'
                  LOC:BankDownloadSelection = 1
                  IF CTL:AG_TestSuiteFlag
                    LOC:SuiteDownloadSelection = 118
                  Else
                    LOC:SuiteDownloadSelection = 119
                  End
                End
              
              !FB 1321
              IF LOC:SuiteDownloadSelection > 1
                  RunBondCentreProgram(LOC:CurrentMatterID,LOC:SuiteDownloadSelection,'Get_UBO_Documents')
              END
              !FB 1321 END
      
              FREE(GEQ:ErrorQueue)
              CLEAR(GEQ:ErrorQueue)
              LOC:JumpToRecordID = 0
              GLO:RecordID = 0
      
              YIELD
      
      !        ProcessUnReadABSAMessages(LOC:SuiteDownloadSelection)
      !
      !        IF RECORDS(GEQ:ErrorQueue)
      !           BrowseErrorQueue('Finished Importing Bond Centre messages')
      !        END
      !        
      !        LOC:JumpToRecordID = GLO:RecordID ! SETTING THIS TO THE FIRST MATTER IMPORTED SO USER JUMPS TO IT.
      !        IF LOC:JumpToRecordID
      !          SELECT(?MattersBrowse)
      !          POST(EVENT:JumpToMatter)
      !          SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
      !        END
            
              !DO RefreshABSALinkBrowse
              !Do ShowABSAImportedStatus
               GLO:MatterID = LOC:CurrentMatterID
               AddToFavourites(LOC:CurrentMatterID)
               BrowseDocLog
               GLO:MatterID = 0
               SELECT(?ABSALinkBrowse)
              !FB 2833 END
      
    OF ?Insert:12
      POST(Event:Accepted,?SendABSAMessageButton)
      Return Level:Notify
    OF ?SBSAProcessEscalationProcedure
      !pk here
    OF ?SendFNBMessageButton
  FREE(GEQ:ErrorQueue)
  CLEAR(GEQ:ErrorQueue)
    
  CLEAR(MAT1:Record)
  ThisWindow.Update

  IF LOC:FNB_Matter = 'Current'

    LOC:MAT:RecordID = LOC:CurrentMatterID

  ELSE

    IF MAT1:RecordID
       LOC:MAT:RecordID = GetMatterID(MAT1:RecordID)
    ELSE
       IF ~SAV:LastMatterID THEN SAV:LastMatterID = LOC:CurrentMatterID.
       LOC:MAT:RecordID = GetMatterID(SAV:LastMatterID)
     END

  END
  IF ~LOC:MAT:RecordID THEN CYCLE.

  LOOP 1 TIMES

      MAT:RecordID = LOC:MAT:RecordID
      IF Access:Matter.Fetch(MAT:PrimaryKey) THEN BREAK.

      IF ~MAT:FNBMatterState
          MESSAGE('This Matter (' & MAT:FileRef & ' - ' & MAT:Description & ') has no ''Matter State'' which may indicate it was not received via the FNB Attorney Gateway.||Unable to send a message regarding this Matter via the Attorney Gateway','Invalid  Matter State',ICON:Exclamation)
          BREAK
      END

      IF ~MAT:BranchID
          PropSQLNext('SELECT COUNT(1) FROM Branch WHERE AG_AttorneyKref <> ''''') ! CHECK IF THERE ARE BRANCHES
          IF ROW:Counter = 1
             PropSQLNext('SELECT TOP 1 RecordID FROM Branch WHERE AG_AttorneyKref <> ''''')
             MAT:BranchID = ROW:Counter
             Access:Matter.Update
          ELSIF ROW:Counter > 1
             GlobalRequest = SelectRecord
             SelectBranch
             IF GlobalResponse = RequestCompleted
                MAT:BranchID = BRA:RecordID
                Access:Matter.Update
             ELSE
                MESSAGE('No Branch has been allocated to this Matter ( ' & MAT:FileRef & ')','Unable to send message',ICON:Exclamation)
                BREAK
             END
          END
      END

      BON:MatterID = LOC:MAT:RecordID
      IF Access:BondData.Fetch(BON:PrimaryKey)
         MESSAGE('This Matter (' & MAT:FileRef & ' - ' & MAT:Description & ') has no BondData record associated with it. ||Unable to send a message to FNB','No Account Number',ICON:Exclamation)
         BREAK
      END

      CLEAR(AGM:Record)
      GlobalRequest = SelectRecord

      SelectFNBMessage(LOC:MAT:RecordID,'T')

      If GlobalResponse = RequestCompleted

         IF AGM:MessageID = 0 THEN
           BREAK
         END

         AddElectronicLinkLog('Export AG Instruction','AG')
         DEBUG('About to send MT' & AGM:MessageID & ' on Matter ' & MAT:FileRef)
         X# = AddXMLMessage(LOC:MAT:RecordID,AGM:MessageID)
         IF X# > 0 THEN
           MESSAGE('Unable to send MT' & AGM:MessageID & ' on LawSuite ' & MAT:LawSuite & '.||Please contact LegalSuite Support', 'Error Sending Message', ICON:Exclamation)
           BREAK ! Let's not try to send any subsequent messages since the current one failed to send
         END
         DEBUG('Finished sending MT' & AGM:MessageID & ' on Matter ' & MAT:FileRef)

         IF RECORDS(GEQ:ErrorQueue)
         DEBUG('Call BrowseErrorQueue')
           BrowseErrorQueue('Finished sending messages')
         END

         IF LOC:FNB_Matter = 'Current'
           LOC:FNBMatterState = GetMatterStateString(LOC:CurrentMatterID)
           DISPLAY(?LOC:FNBMatterState)
         END

         DEBUG('Get ToDoItem, SQL: ' & 'SELECT TOP 1 RecordID FROM ToDoItem WHERE FNBMessageNo = ' & AGM:MessageID & ' AND ToDoGroupID = ' & MAT:ToDoGroupID)
         PROPSQLNext('SELECT TOP 1 RecordID FROM ToDoItem WHERE FNBMessageNo = ' & AGM:MessageID & ' AND ToDoGroupID = ' & MAT:ToDoGroupID)
         IF ROW:Counter
           DEBUG('Get ToDoNote')
           PROPSQLNext('SELECT RecordID FROM ToDoNote WHERE MatterID = ' & MAT:RecordID & ' AND ToDOItemID = ' & ROW:Counter & ' AND CompletedFlag = 0')
           IF ROW:Counter
             DEBUG('Call MarkToDoNote')
             MarkToDoNote(ROW:Counter,1)  ! THE SECOND PARAMETER TELL IT NOT TO SEND THE MESSAGE (BECAUSE IT HAS JUST BEEN SENT!)
             DEBUG('Call RefreshToDoNoteBrowse')
             DO RefreshToDoNoteBrowse
           END
         END
         
         ! 30/03/2015 Sameer: When sending an MT4:
         IF AGM:MessageID = 4 THEN ! Lodged
            ! 21/02/2017 PK Naidoo : FB Case 242
            IF (INLIST(MAT:LawSuite, 17, 18)) THEN
               DEBUG('About to auto-send MT302 after MT4')
               ! 30/03/2015 Sameer: Also automatically send an MT302 afterwards
               AGM:MessageID = 302 ! DOTS Message
               AddElectronicLinkLog('Export AG Instruction','AG')
               X# = AddXMLMessage(LOC:MAT:RecordID, AGM:MessageID)
               IF X# > 0 THEN
                 MESSAGE('Unable to auto-send MT302: DOTS Message after the MT4: Lodged Message on LawSuite ' & MAT:LawSuite & '.||Please contact LegalSuite Support', 'Error Auto-Sending Message', ICON:Exclamation)
                 BREAK ! Let's not try to send any subsequent messages since the current one failed to send
               END
            END

           ! 13/11/2015 Sameer: Also automatically send an MT13 afterwards - but only for HIP (SuiteIds 17, 18)
           IF (INLIST(MAT:LawSuite, 17, 18)) THEN
             DEBUG('About to auto-send MT13 after MT4')
             AGM:MessageID = 13 ! ATP Message
             AddElectronicLinkLog('Export AG Instruction','AG')
             X# = AddXMLMessage(LOC:MAT:RecordID, AGM:MessageID)
             IF X# > 0 THEN
               MESSAGE('Unable to auto-send MT13: ATP Message after the MT4: Lodged Message on LawSuite ' & MAT:LawSuite & '.||Please contact LegalSuite Support', 'Error Auto-Sending Message', ICON:Exclamation)
               BREAK ! Let's not try to send any subsequent messages since the current one failed to send
             END

           END

           IF RECORDS(GEQ:ErrorQueue)
             BrowseErrorQueue('Finished sending messages')
           END

           IF LOC:FNB_Matter = 'Current'
             LOC:FNBMatterState = GetMatterStateString(LOC:CurrentMatterID)
             DISPLAY(?LOC:FNBMatterState)
           END

           DO RefreshFNBLinkBrowse

           PROPSQLNext('SELECT TOP 1 RecordID FROM ToDoItem WHERE FNBMessageNo = ' & AGM:MessageID & ' AND ToDoGroupID = ' & MAT:ToDoGroupID)
           IF ROW:Counter
             PROPSQLNext('SELECT RecordID FROM ToDoNote WHERE MatterID = ' & MAT:RecordID & ' AND ToDOItemID = ' & ROW:Counter & ' AND CompletedFlag = 0')
             IF ROW:Counter
               MarkToDoNote(ROW:Counter,1)  ! THE SECOND PARAMETER TELL IT NOT TO SEND THE MESSAGE (BECAUSE IT HAS JUST BEEN SENT!)
               DO RefreshToDoNoteBrowse
             END
           END

         END ! IF AGM:MessageID = 4

      END ! If GlobalResponse = RequestCompleted

  END ! LOOP 1 TIMES

  DO ShowFNBExportedStatus
  !FB 1027
  BRW46.ResetFromFile
    OF ?AG_MessageCentreButton
      
        LOC:BranchRecordId = AG_GetBranchID(0)
      
        IF LOC:BranchRecordId = 0      ! USER ABORTED SELECTION
      
            Return Level:Notify
      
        ELSIF LOC:BranchRecordId < 0   ! NO BRANCHES HAVE AN ATTORNEY KREF
      
            IF MESSAGE('The FNBLink needs to have at least one branch setup in LegalSuite to identify your company when you communicate with the bank.' &|
                       '||None of your branches have been activated, i.e. they have not been registered with the Attorney Gateway.' &|
                       '||Would you like to activate your branch now?','No Activated Branch found',ICON:Exclamation,BUTTON:Yes+Button:No,BUTTON:Yes,1) = BUTTON:Yes
      
               BrowseBranch
      
            END
      
            Return Level:Notify
      
        ELSE
            IF EXISTS('AGLoadMC.exe')
              DEBUG('GLO:SQLLogin = ' & GLO:SQLLogin)
              DEBUG('LOC:BranchRecordId = ' & LOC:BranchRecordId)
              DEBUG('CEM:RecordID = ' & CEM:RecordID)
              RUN('AGLoadMC.exe "'  & GLO:SQLLogin & '" ' & LOC:BranchRecordId & ' ' & CEM:RecordID&' ' & MAT:RecordID)
              If ErrorCode()
                Message(Error() & '||Error running program AGLoadMC.exe||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                BREAK
              End
            Else
              Message('AGLoadMC.exe Not Found||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
              BREAK
            End
        END
      
        DO ShowFNBExportedStatus
      
      
    OF ?FNBCircularsButton
      BrowseBankCirculars('FNB')
    OF ?FNBLinkJumpToMatterButton
        SELECT(?MattersBrowse)
        LOC:JumpToRecordID = AGMM:MatterID
        POST(EVENT:JumpToMatter)
        SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
      
    OF ?CustomFNB_PeriodButton
        LOC:FNB_Period = 'Custom'
        ?LOC:FNB_Period{PROP:SELECTED} = ?LOC:FNB_Period{PROP:ITEMS}
        IF ~LOC:FNB_FromDate THEN LOC:FNB_FromDate = GLO:TodaysDate.
        IF ~LOC:FNB_ToDate THEN LOC:FNB_ToDate = GLO:TodaysDate.
        IF LOC:FNB_ToDate > GLO:TodaysDate + 10000 THEN LOC:FNB_ToDate = GLO:TodaysDate.
        GetDateRange(LOC:FNB_FromDate,LOC:FNB_ToDate)
      
    OF ?ChangeMatterStateButton
      IF LOC:FNB_Matter = 'Current'  AND LOC:CurrentMatterID
      
        IF ~(GLO:AdministratorPassword = GetUserPassword())

         ELSE
      
           PropSQLNext('Select RecordID, Code From Docgen Where RecordID = ' & MAT:DocGenId)
           If ROW:Description = 'TRN'
             LOC:NewMatterState = GetUserMatterStateTRN(MAT:FileRef)  ! -1 IF THE USER ABORTS BECAUSE ZERO IS A MATTER STATE
           Else
             If Inlist(MAT:LawSuite,24,25)                                  ! FNB
               LOC:NewMatterState = GetUserMatterStateFNB(MAT:FileRef)      ! -1 IF THE USER ABORTS BECAUSE ZERO IS A MATTER STATE
             ElsIf Inlist(MAT:LawSuite,17,18,124,125,126,127,225,226,231,232,237,238)               ! FNBCPF - Actually Generic bond registration
               LOC:NewMatterState = GetUserMatterStateFNBCPF(MAT:FileRef)   ! -1 IF THE USER ABORTS BECAUSE ZERO IS A MATTER STATE
             ElsIf Inlist(MAT:LawSuite,19,20,23,24,25)                      ! FNBH
               LOC:NewMatterState = GetUserMatterStateFNBH(MAT:FileRef)     ! -1 IF THE USER ABORTS BECAUSE ZERO IS A MATTER STATE
             ElsIf Inlist(MAT:LawSuite,3,4,75,76,77,78,79,97,98,209,210,229,230,235,241,236,242)    ! FNB Cancellations (CAN) - Actually COnsent Instructions
               LOC:NewMatterState = GetUserMatterStateCAN(MAT:FileRef)      ! -1 IF THE USER ABORTS BECAUSE ZERO IS A MATTER STATE
             ElsIf Inlist(MAT:LawSuite,142,143,144,145,146,147,149,150)     ! FNB Transfers (TRN) AG Transfers
               LOC:NewMatterState = GetUserMatterStateTRN(MAT:FileRef)      ! -1 IF THE USER ABORTS BECAUSE ZERO IS A MATTER STATE
             Else
               LOC:NewMatterState = GetUserMatterStateFNB(MAT:FileRef)      ! -1 IF THE USER ABORTS BECAUSE ZERO IS A MATTER STATE
             End
           End
           IF LOC:NewMatterState >= 0
              PropSQL('UPDATE Matter SET FNBMatterState = ' & LOC:NewMatterState & ' WHERE RecordID = ' & LOC:CurrentMatterID)
    
!                MESSAGE(RowCounter{PROP:SQL})
    
              LOC:FNBMatterState = GetMatterStateString(LOC:CurrentMatterID)
              DISPLAY(?LOC:FNBMatterState)
           END

         END
      ELSE
      
       MESSAGE('This can only be done if you are viewing the Messages for a single Matter.||Change the view to the "Current" Matter and try again.','Invalid Setting',ICON:Exclamation)
      
      END
    OF ?MakeConfigButton
      LOOP 1 TIMES
         GLO:DOSFIleOUT   = PATH() & '\AttorneyGateway.exe.config'
         Create(DOSFileOut)
      
         IF Error()
            Message('Error (' & CLIP(ERROR()) & ') creating XML file (' & GLO:DOSFIleOUT & ')')
            BREAK
         END
        
         Open(DOSFileOut)
         IF Error() 
            Message('Error (' & CLIP(ERROR()) & ') opening XML file (' & GLO:DOSFIleOUT & ')')
            BREAK
         End
      
         PropSQLNext('SELECT 0,db_name(0)')  ! GET THE DATABASE NAME
      
         DOUT:Line = '<?xml version="1.0" encoding="utf-8"?>' &|
                     '<13,10><configuration>' &|
                     '<13,10><connectionStrings>' &|
                     '<13,10><add name="database" connectionString="Server=' & GLO:SQLServer & '; Database=' & ROW:Description & '; User Id=' & GLO:SQLUser & '; Password=' & GLO:SQLPassword & '" providerName="System.Data.SqlClient" />' &|
                     '<13,10></connectionStrings>' &|
                     '<13,10></configuration>'
      
         Append(DOSFileOut,LEN(CLIP(DOUT:Line)))
         If ErrorCode()
            Message('Could not create ''' & GLO:DOSFIleOUT & '''.||Error = ' & Error() ,'Error Creating Config File',ICON:Exclamation)
            Close(DOSFileOut)
            BREAK
         END
         Close(DOSFileOut)
         MESSAGE('Created ''' & GLO:DOSFIleOUT & '''||' & DOUT:Line,'Successful',ICON:Exclamation)
      
      END
      
    OF ?Insert:7
      POST(Event:Accepted,?SendFNBMessageButton)
      Return Level:Notify
    OF ?MakeConfigButton:2
        SpecifySchemaLocation()
      
    OF ?SARSLinkJumpToMatterButton
        SELECT(?MattersBrowse)
        LOC:JumpToRecordID = SMM:MatterId
        POST(EVENT:JumpToMatter)
        SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?TagOne
      ThisWindow.Update
      DO BRW54::TagOne
       SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
    OF ?UntagOne
      ThisWindow.Update
      DO BRW54::UntagOne
    OF ?FlipOne
      ThisWindow.Update
      DO BRW54::FlipOne
    OF ?TagAll
      ThisWindow.Update
      DO BRW54::TagAll
    OF ?UntagAll
      ThisWindow.Update
      DO BRW54::UntagAll
    OF ?FlipAll
      ThisWindow.Update
      DO BRW54::FlipAll
    OF ?DocgenDatabaseButton
      ThisWindow.Update
      ! CHOOSE WHICH DOCGEN DATABASE TO LOAD
      
       IF RestrictedMatter(MAT:RecordID,0) THEN CYCLE.

       IF ShowFICAStatus(MAT:RecordID) ! PREVENT ACCESS
          RETURN LEVEL:Notify
       END

       AddToFavourites(MAT:RecordID)

       DO CheckFeeEstimate

       IF MAT:DocgenID
          GLO:DocgenCode = ''
          LOC:DocgenType = ''
          DG:RecordID = MAT:DocgenID
          IF ~Access:Docgen.TryFetch(DG:PrimaryKey)
              IF UserLicensed(DG:RecordID)
                 GLO:DocgenCode = DG:Code
                 LOC:DocgenType = DG:Type
      
                 IF ~LOC:DocgenType
                     MESSAGE('No ''Type'' has been specified for this Docgen Module.||The program is unable to determine which Database to load.',DG:Description,ICON:Exclamation)
                 ELSE
                     CASE LOC:DocgenType

                          OF 'BON'

                              UpdateBondDatabase

                              ProcessSystemEvent(EVENT:MatterUpdated,MAT:RecordID)

                          OF 'TRN' OROF 'DEV'

                              IF LOC:DocgenType = 'DEV'

                                 GLO:RecordID = 0

                                 UpdateTownShipRegister


                              IF GlobalResponse = RequestCompleted AND CONV:GroupID

                                 IF LOC:DocgenType = 'TRN' OR  MESSAGE('Do you want to display the Properties linked to this Development?','Change Desktop Filter',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:Yes
                                    ClearDesktopFilter ! THIS NOW HAS SECURITY CHECKING  7/3/2009


                                    GLO:FilterGroupFlag = 1
                                    GLO:FilterGroupID = CONV:GroupID

                                    Access:EmployeeAlias2.Open
                                    Access:EmployeeAlias2.UseFile

                                    EMP2:RecordID = GLO:EmployeeID

                                    IF ~Access:EmployeeAlias2.Fetch(EMP2:PrimaryKey)

                                        EMP2:FilterGroupFlag = 1
                                        EMP2:FilterGroupID = CONV:GroupID

                                        IF ~Access:EmployeeAlias2.Update()
                                            CEM:Record :=: EMP2:Record
                                        ELSE
                                            MESSAGE('Error updating Employee''s filter settings|',ERROR(),ICON:Exclamation)
                                        END

                                    END

                                    Access:EmployeeAlias2.Close

                                    Do DisplayHeading

                                    BRW54.ApplyFilter
                                    !BRW54.ResetFromBuffer
                                  !BRW54.PostNewSelection
                                  POST(EVENT:ScrollTop,?MattersBrowse)
                                 END
                              END


                                 IF GLO:RecordID
                                    LOC:JumpToRecordID = GLO:RecordID
                                    POST(EVENT:JumpToMatter)
                                    SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
                                 END

                              ELSE

                                 UpdateTransferDatabase

                              END

                              ProcessSystemEvent(EVENT:MatterUpdated,MAT:RecordID)


                          OF 'CAN'

                              BrowseBondCanc

                              ProcessSystemEvent(EVENT:MatterUpdated,MAT:RecordID)

                          OF 'LIT' OROF 'RAF'

                              UpdateLitigationDatabase

                              ProcessSystemEvent(EVENT:MatterUpdated,MAT:RecordID)


                          OF 'STR'
                              GLO:RecordID = 0

                              UpdateSectTitleDatabase


                              IF GlobalResponse = RequestCompleted AND CONV:GroupID


                                 IF MESSAGE('Do you want to display the Properties linked to this Sectional Title Register?','Change Desktop Filter',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:Yes


                                    ClearDesktopFilter ! THIS NOW HAS SECURITY CHECKING  7/3/2009


                                    GLO:FilterGroupFlag = 1
                                    GLO:FilterGroupID = CONV:GroupID

                                    Access:EmployeeAlias2.Open
                                    Access:EmployeeAlias2.UseFile

                                    EMP2:RecordID = GLO:EmployeeID

                                    IF ~Access:EmployeeAlias2.Fetch(EMP2:PrimaryKey)

                                        EMP2:FilterGroupFlag = 1
                                        EMP2:FilterGroupID = CONV:GroupID

                                       IF ~Access:EmployeeAlias2.Update()
                                           CEM:Record :=: EMP2:Record
                                       ELSE
                                           MESSAGE('Error updating Employee''s filter settings|',ERROR(),ICON:Exclamation)
                                       END

                                    END

                                    Access:EmployeeAlias2.Close

                                    Do DisplayHeading

                                    BRW54.ApplyFilter
                                    POST(EVENT:ScrollTop,?MattersBrowse)

                                 END

                              END


                              IF GLO:RecordID
                                 LOC:JumpToRecordID = GLO:RecordID
                                 POST(EVENT:JumpToMatter)
                                 SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
                              END

                              ProcessSystemEvent(EVENT:MatterUpdated,MAT:RecordID)

      
                          ELSE

                              MESSAGE('This Matter (' & MAT:FileRef & ' - ' & MAT:Description & ') does not use a Document Database module.','No Document Set',ICON:Exclamation)
                     END
                 END
              END
          ELSE
              MESSAGE('Error getting Document Set with Record Number = ' & MAT:DocgenID & '||While trying to load Database',MAT:FileRef & ' - ' & MAT:Description,ICON:Exclamation)
          END
       ELSE
          MESSAGE('This Matter does not have a Document Set associated with it.',MAT:FileRef & ' - ' & MAT:Description,ICON:Exclamation)
       END
       SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
    OF ?ExtraScreenButton
      ThisWindow.Update
      LOC:StayOnThisMatterID = MAT:RecordID
      
      UpdateMatterExtraScreens

!      MESSAGE('GlobalResponse = ' & GlobalResponse &|
!              '|CHOICE(?MattersBrowse) = ' & CHOICE(?MattersBrowse))



      DO RefreshMatterBrowse


      IF GlobalResponse = RequestCompleted
      

         ! Rick FB# 1412 - 27 Jul 2018 - Was causing an error and putting deleted ToDoNotes back - SO HAVE COMMENTED THIS OUT. NOT SURE WHY IT WAS THERE?
         !RefreshMatterPlanOfAction(MAT:RecordID)
      
         DO RefreshToDoNoteBrowse
      
         LOC:StayOnThisMatterID = 0
      
      
      END

      SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
    OF ?LedgerEnquiryButton
      ThisWindow.Update
      AddToFavourites(MAT:RecordID)
      Start(BrowseMatterTransactions,25000,MAT:RecordId)
      
    OF ?DocumentLogButton
      ThisWindow.Update
      IF RestrictedMatter(MAT:RecordID,0) THEN CYCLE.
      
      GLO:MatterID = MAT:RecordID
      AddToFavourites(MAT:RecordID)
      BrowseDocLog
      GLO:MatterID = 0
      SELECT(?MattersBrowse)
      
    OF ?BillOfCostsButton
      ThisWindow.Update
          IF RestrictedMatter(MAT:RecordID,0) THEN CYCLE.
      
          AddToFavourites(MAT:RecordID)
      
          CLEAR(DG:Record)
          DG:Code = 'BIL'
          IF ~Access:Docgen.TryFetch(DG:CodeKey)
              IF UserLicensed(DG:RecordID)
                 BrowseBillNote
              END
          ELSE
             MESSAGE('Unable to grant access to the Bill of Costs Module.||Reason: There is no Bill of Costs Document Set .||Hint: A Bill of Costs Document Set must exist (and have the code ''BIL'') and the relevant users licensed to it.','Access Denied','~lock.ico')
          END
         SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
    OF ?CreateCustomisedInvoiceButton
      ThisWindow.Update
        IF RestrictedMatterAlias(MAT:RecordID,0) THEN CYCLE.
      
        AddToFavourites(MAT:RecordID)
      
      
        Case MAT:ConsolidatedFlag
        Of 1
          Message('This matter has been marked to consolidate |to another matter.||You must either unconsolidate this matter |or create an invoice for the consolidated matter','Create Invoice',ICON:Exclamation)
          CYCLE
        Of 2
          If MAT:Actual or MAT:Reserved or MAT:Invested
            Message('This matter has been marked to consolidate |balances with another matter.||You must either unconsolidate this matter or |consolidate the balances first','Create Invoice',ICON:Exclamation)
            CYCLE
          .
        Else
          PropSQLNext('Select count(1) from matter where InvoiceFlag = 1 and (Actual <> 0 or Reserved <> 0) and ConsolidatedFlag <> 3 and ConsolidateId = ' & MAT:RecordID)
          If Errorcode()
            Message('Error Checking Consolidated Matters|Error: ' & FileError(),'Invoices',ICON:Exclamation)
          Else
            If ROW:Counter
              Message('Some of the matters consolidated to |this invoice still have outstanding balances|Consolidate these matters first','Create Invoices',ICON:Asterisk)
              CYCLE
            .
          .
        .
      
        GlobalRequest = SelectRecord
      
        SelectInvoice
      
        IF GlobalResponse = RequestCompleted
           CreateTaxInvoice
           !BrowseCustomInvoice
        END
       SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
      
    OF ?DebtorsBalanceButton
      ThisWindow.Update
      IF RestrictedMatter(MAT:RecordID,0) THEN CYCLE.
      
      AddToFavourites(MAT:RecordID)


      DG:RecordID = MAT:DocgenID
      IF ~Access:Docgen.TryFetch(DG:PrimaryKey)
          IF DG:Type = 'LIT'

                LOC:StayOnThisMatterID = MAT:RecordID
                BrowseColDebit
                DO RefreshMatterBrowse
                LOC:StayOnThisMatterID = 0
                Select(?MattersBrowse)

          ELSE

             MESSAGE('This Matter does not have a Litigation Document Set associated with it.||The Debtors Balance is only available to Litigation Matters.','Access Denied','~lock.ico')

          END

      ELSE

          MESSAGE('This Matter does not have a Litigation Document Set associated with it.||The Debtors Balance is only available to Litigation Matters.','Access Denied','~lock.ico')

      END
      SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
    OF ?DisplayDashboard
      ThisWindow.Update
      DisplayDashBoard
      
    OF ?QuickQuoteButton
      ThisWindow.Update
             LOC:GoAhead = 0
             OPEN(QuickQuoteWindow)
             DISPLAY
             ACCEPT
                 CASE FIELD()
                      OF ?TransfersQuoteButton
                         CASE EVENT()
                              OF EVENT:Accepted
                                 LOC:GoAhead = 1
                                 BREAK
                         END
                      OF ?BondsQuoteButton
                         CASE EVENT()
                              OF EVENT:Accepted
                                 LOC:GoAhead = 2
                                 BREAK
                         END
                      OF ?CancellationsQuoteButton
                         CASE EVENT()
                              OF EVENT:Accepted
                                 LOC:GoAhead = 3
                                 BREAK
                         END
                      OF ?CostsCancelButton
                         CASE EVENT()
                              OF EVENT:Accepted
                                 BREAK
                         END
                 END
             END
             CLOSE(QuickQuoteWindow)

!   MESSAGE('LOC:GoAhead = ' & LOC:GoAhead)

             EXECUTE LOC:GoAhead
                QuickTransferQuote
                QuickBondQuote
                QuickCancellationQuote
             END
      
             SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
    OF ?ShowFavouritesButton
      ThisWindow.Update
           GlobalRequest = SelectRecord
           BrowseEmployeeFavourites
           IF GlobalResponse = RequestCompleted
      
              IF FstTag:PtrM(Tag:Favourites)
                 NewTag:PtrM(TAG:Matter)
                 CLEAR(FAV:Record)
                 FAV:RecordID = FstTag:PtrM(Tag:Favourites)
                 LOOP
                      IF ~Access:Favourites.Fetch(FAV:PrimaryKey)
                          SetTag:PtrM(TAG:Matter,FAV:MatterID)
                      END
                      FAV:RecordID = NxtTag:PtrM(Tag:Favourites)
                      IF ~FAV:RecordID THEN BREAK.
                 END
                 POST(EVENT:ShowTaggedMatters)
                 SELECT(?MattersBrowse,1)
              ELSE
                LOC:JumpToRecordID = FAV:MatterID
                POST(EVENT:JumpToMatter)
                SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
              END
           ELSE
             SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
           END
           
      
      
    OF ?MatterSummaryButton
      ThisWindow.Update
        IF FstTag:PtrM(TAG:Matter)
           IF MESSAGE('Do you want to print summaries for all the tagged Matters?','Matter Summary',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:No
              IF ~RestrictedMatter(MAT:RecordID,0) THEN PrintMatterSummary(MAT:RecordID,0).
           ELSE
              CLEAR(MAT:Record)
              MAT:RecordID = FstTag:PtrM(Tag:Matter)
              LOOP
                   IF ~Access:Matter.Fetch(MAT:PrimaryKey)
                       IF ~RestrictedMatter(MAT:RecordID,0) THEN PrintMatterSummary(MAT:RecordID,1).
                   END
                   MAT:RecordID = NxtTag:PtrM(Tag:Matter)
                   IF ~MAT:RecordID THEN BREAK.
              END
           END
        ELSE
           IF ~RestrictedMatter(MAT:RecordID,0) THEN PrintMatterSummary(MAT:RecordID,0).
        END
        SELECT(?MattersBrowse)
      
      
    OF ?SendEmpMessage
      ThisWindow.Update
      GLO:EmpMessageMatterID = GLO:CurrentMatterID
      START(SendEmpMessage)
      
    OF ?ManagementReportButton
      ThisWindow.Update
!      PROPSQLNext('SELECT COUNT(1) FROM TaggedMatter WHERE EmployeeID = ' & CEM:RecordID)
!
!
!      IF ROW:Counter
!
!         GLO:MatterCounter = ROW:Counter
!
!         LOC:NumberOfMattersMessage = 'There are ' & CLIP(LEFT(FORMAT(GLO:MatterCounter))) & ' (Tagged) Matters currently selected'

      IF FstTag:PtrM(Tag:Matter)

         GLO:MatterCounter = CntTag:PtrM(Tag:Matter)         ! USED IN HARD-CODED & MANAGEMENT REPORTS

         LOC:NumberOfMattersMessage = 'There are ' & CLIP(LEFT(FORMAT(GLO:MatterCounter))) & ' (Tagged) Matters currently selected'


      ELSE
      
      
        IF LOC:FilterMatterString

           PropSQLNext('SELECT Count(1) FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString)

        ELSE

           PropSQLNext('SELECT rows FROM sysindexes WHERE id = OBJECT_ID(''Matter'') AND indid < 2')

        END

        GLO:MatterCounter = ROW:Counter
      
      
        LOC:NumberOfMattersMessage = 'There are ' & CLIP(LEFT(FORMAT(GLO:MatterCounter))) & ' Matters currently selected'
      
      END
      
      
      BrowseManagementReports(LOC:NumberOfMattersMessage)
      
    OF ?CheckSheetButton
      ThisWindow.Update
       IF RestrictedMatter(MAT:RecordID,0) THEN CYCLE.

       AddToFavourites(MAT:RecordID)


       IF MAT:DocgenID
          GLO:DocgenCode = ''
          LOC:DocgenType = ''
          DG:RecordID = MAT:DocgenID
          IF ~Access:Docgen.TryFetch(DG:PrimaryKey)
              IF UserLicensed(DG:RecordID)
                 GLO:DocgenCode = DG:Code
                 LOC:DocgenType = DG:Type
      
                 IF ~LOC:DocgenType

                     MESSAGE('No ''Type'' has been specified for this Docgen Module.||The program is unable to determine which Database to load.',DG:Description,ICON:Exclamation)

                 ELSE

                     CASE LOC:DocgenType
                          OF 'CAN'
                              UpdateCancMatterCheckSheet(DG:RecordID)
                              LOC:StayOnThisMatterID = MAT:RecordID
                              POST(EVENT:RefreshMatters)
                              LOC:StayOnThisMatterID = 0
                          OF 'BON' OROF 'TRN' !OROF 'CAN'
                               UpdateMatterCheckSheet(DG:RecordID)
                              LOC:StayOnThisMatterID = MAT:RecordID
                              POST(EVENT:RefreshMatters)
                              LOC:StayOnThisMatterID = 0
                              

                          OF 'LIT' 

                              UpdateMatterLitigationCheckSheet

                          ELSE

                              MESSAGE('This Matter (' & MAT:FileRef & ' - ' & MAT:Description & ') does not use a Check Sheet.','No Check Sheet',ICON:Exclamation)
                     END
                 END
              END
          ELSE
              MESSAGE('Error getting Document Set with Record Number = ' & MAT:DocgenID & '||While trying to load Database',MAT:FileRef & ' - ' & MAT:Description,ICON:Exclamation)
          END
       ELSE
          MESSAGE('This Matter does not have a Document Set associated with it.',MAT:FileRef & ' - ' & MAT:Description,ICON:Exclamation)
       END
       SELECT(?MattersBrowse,CHOICE(?MattersBrowse))

    OF ?ViewRatesClearanceButton
      ThisWindow.Update
      IF LOC:BranchID
         BRA:RecordID = LOC:BranchID
         Access:Branch.Fetch(BRA:PrimaryKey)
      END
      
      LOC:BranchID = GetBranchID()
      
      IF ~LOC:BranchID THEN CYCLE.
      
      IF GLO:DebuggingFlag
         MESSAGE('About to call ViewRatesClearanceWebSite()||BranchID = ' & LOC:BranchID,'Debugging',ICON:Exclamation)
      END
      
      ViewRatesClearanceWebSite(LOC:BranchID)
      
    OF ?BondCentreOrGatewayPropertyHubDocsButtonMatterTab
      ThisWindow.Update
      ! 09/09/2015 Sameer: Conditionally run the code on the ABSASendReceiveDocsButton (Bond Centre tab) or the DocumentHubButton (Gateway tab)
      IF (INLIST(DG:Code, 'ABSA', 'STD')) THEN
      
        ! Run ABSASendReceiveDocsButton on the Bond Centre tab
        POST(EVENT:Accepted, ?ABSASendReceiveDocsButton)
      
      ELSIF (INLIST(DG:Code, 'TRN')) THEN
      
        ! Run DocumentHubButton on the Gateway tab
        POST(EVENT:Accepted, ?DocumentHubButton)
      
      ELSE
      
        ! Do nothing, even though the button looks clickable
      
      END
      
    OF ?SelectDocumentsButton
      ThisWindow.Update
      IF RestrictedMatter(MAT:RecordID,0)
         CYCLE
      END


      IF ~CntTag:PtrM(Tag:Matter)                  ! IF NO MATTERS ARE TAGGED
          SetTag:PtrM(TAG:Matter, MAT:RecordID)    ! TAG THE ONE THE USER IS ON
          Queue:Browse:1.Tag_Icon = 2
          Queue:Browse:1.Tag = Tag
          PUT(Queue:Browse:1)
          DISPLAY
      END


      MAT:RecordID = FstTag:PtrM(Tag:Matter)

      IF ShowFICAStatus(MAT:RecordID) ! PREVENT ACCESS
         RETURN LEVEL:Notify
      END

      SETCURSOR(CURSOR:Wait)

      Access:Matter.Fetch(MAT:PrimaryKey)

      Save:MAT:RecordID = MAT:RecordID

      AddToFavourites(MAT:RecordID)

      LOC:DocGenID = 0          ! USE THIS TO SET THE Document Set FOR SELECTDOCUMENTS

      IF MAT:DocgenID

         IF ~UserLicensed(MAT:DocgenID,True)          ! Don't show message

             LOC:DocGenID = CTL:GeneralDocgenID       ! IF NOT LICENSED THEN ONLY DISPLAY GENERAL DOCUMENTS

         ELSE
             LOC:DocGenID = MAT:DocgenID
         END

      ELSE

        IF ~CTL:GeneralDocgenID
            MESSAGE('This matter has no Document Set specified. Therefore the General Documents will be displayed.||The Custom Documents could not be displayed because the Custom Document Set cannot been identified.' & |
                    '||Please specify which Document Set is the ''Custom Documents''.||Choose ''Miscellaneous'' and then ''Record Identifiers'' from the Setup Menu to do this.','Specify Custom Document Set',ICON:Exclamation)
            SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
            SETCURSOR
            CYCLE
        ELSE
            LOC:DocGenID = CTL:GeneralDocgenID      ! IF NO DOCGEN MODULE THEN ONLY DISPLAY GENERAL DOCUMENTS
        END

      END

      LOC:DifferentDocumentSetsFlag = False

      IF CntTag:PtrM(Tag:Matter) = 1            ! IF ONE MATTER IS TAGGED
          MAT:RecordID = FstTag:PtrM(Tag:Matter)   ! GET THE TAGGED MATTER
          Access:Matter.TryFetch(MAT:PrimaryKey)
      ELSE
          CLEAR(MAT:Record)
          MAT:RecordID = FstTag:PtrM(Tag:Matter)                ! SET TO THE FIRST TAGGED MATTER
          IF ~Access:Matter.TryFetch(MAT:PrimaryKey)
              SAV:DocgenID = MAT:DocgenID
          END
          LOOP
            IF ~Access:Matter.TryFetch(MAT:PrimaryKey)
              IF ~(SAV:DocgenID = MAT:DocgenID) THEN LOC:DifferentDocumentSetsFlag = True;BREAK.
            END
            MAT:RecordID = NxtTag:PtrM(Tag:Matter)                ! SET TO NEXT MATTER
            IF ~MAT:RecordID THEN BREAK.
          END
      END



      IF LOC:DifferentDocumentSetsFlag = True
         LOC:DocGenID = CTL:GeneralDocgenID      ! IF DIFFERENT DOCGEN MODULES THEN ONLY DISPLAY GENERAL DOCUMENTS
      END

      GLO:MergeFromAddressBookFlag = False

      SETCURSOR



      IF LOC:DocGenID


            LOC:StayOnThisMatterID = MAT:RecordID  ! SO IT STAYS ON THE SAME MATTER

            SelectDocumentsNew(LOC:DocGenID)

            DO RefreshMatterBrowse

            LOC:StayOnThisMatterID = 0


      ELSE

           MESSAGE('No valid (licensed) Document Set could be found for this Matter (' & MAT:FileRef & ')||This Matter has a Document Set = ' & MAT:DocgenID & '||The Custom Document Set also cannot be identified.' & |
                   '||Please allocate this Matter to a Document Set and also specify which Document Set is the ''Custom Documents''.||Choose ''Miscellaneous'' and then ''Record Identifiers'' from the Setup Menu to do this.||If the problem persists, please contact LegalSuite.','Specify Custom Document Set',ICON:Exclamation)

      END

      IF CntTag:PtrM(TAG:Matter) = 1    ! IF THE USER DIDN'T TAG ANY MATTERS, I.E. THE PROGRAM TAGGED JUST THE ONE.
         NewTag:PtrM(Tag:Matter)        ! THEN UNTAG THE ONE.
      END

      NewTag:PtrM(Tag:Party)

      BRW54.ResetQueue(RESET:Queue)   ! REMOVE TAG


      BRW2.ResetQueue(RESET:Done)    ! IN CASE ANY FEE NOTES, FILE NOES OR REMINDERS ARE ADDED OR DELETED
      BRW52.ResetQueue(RESET:Done)   ! OTHERWISE GET THE "RECORD NOT FOUND" ERROR
      BRW15.ResetQueue(RESET:Done)
      IF GLO:TimeRecordingFlag
         BRW22.ResetQueue(RESET:Done)
      END

      SELECT(?MattersBrowse,CHOICE(?MattersBrowse))

    OF ?STDOnlineDocumentMatterTab
      ThisWindow.Update
      POST(EVENT:Accepted, ?STDOnlineDocument)
    OF ?FindMatterButton
      ThisWindow.Update
      LOC:JumpToRecordID = 0
!      LOC:JumpToRecordID = SearchMatter(MAT:RecordID)
      LOC:JumpToRecordID = SearchMatterNew()
      IF LOC:JumpToRecordID
         BRW54.ResetQueue( Reset:Queue )
         POST(EVENT:JumpToMatter)
      END
      SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
    OF ?FilterButton
      ThisWindow.Update
      GLO:RecordID = CEM:RecordID

      FilterMatters

      GLO:RecordID = 0
      GLO:CurrentMatterID = 0

      IF GlobalResponse = RequestCompleted

         Do DisplayHeading

         DO RefreshMatterBrowse

         IF GLO:DebuggingFlag
            IF LOC:FilterMatterString
               SETCLIPBOARD('SELECT * FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString)
               MESSAGE('This is the SQL script being used by the Desktop. It has been copied to your clipboard.||' & 'SELECT * FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString,'Debugging',ICON:Exclamation)
            ELSE
               MESSAGE('This is the SQL script being used by the Desktop. It has been copied to your clipboard.||' & 'SELECT * FROM Matter','Debugging',ICON:Exclamation)
            END
         END

         Select(?MattersBrowse,1)

     END

    OF ?Change:3
      ThisWindow.Update
       DO CheckFeeEstimate
      
    OF ?Delete:3
      ThisWindow.Update
      
              IF CheckMatterAccess(MAT:RecordID)  ! ADDED 8/11/2010
                 MESSAGE('Unable to Delete this Matter (' & MAT:FileRef & ')||You do not have Access rights to this Matter|','Access Denied',ICON:Exclamation)
              ELSE
                 IF MESSAGE('Are you sure you want to delete this Matter (' & MAT:FileRef & ')','Confirm Matter Deletion',ICON:Question,BUTTON:OK+BUTTON:Cancel,BUTTON:OK) = BUTTON:OK
      
                    DeleteMatter(MAT:RecordID)
      
      
                    BRW54.ResetFromBuffer
                    BRW54.PostNewSelection
                    !FB 411 - removing this to stop an error
                    !IF LOC:FilterMatterString
                       IF LOC:FN_Matter <> 'All' THEN DO RefreshFeeNoteBrowse.
                       IF LOC:FIL_Matter <> 'All' THEN DO RefreshFileNoteBrowse.
                       IF LOC:TOD_Matter <> 'All' THEN DO RefreshToDoNoteBrowse.
                       IF LOC:MA_Matter <> 'All' THEN DO RefreshMatActivBrowse.
                       IF LOC:DAT_Matter <> 'All' THEN DO RefreshDataLinkBrowse.
                       IF LOC:FNB_Matter <> 'All' THEN DO RefreshFNBLinkBrowse.
                       IF LOC:AG_Suite_Description <> 'All' THEN DO RefreshFNBLinkBrowse.
                       IF LOC:ABSA_Matter <> 'All' THEN DO RefreshABSALinkBrowse.
                       IF LOC:SARS_Matter <> 'All' THEN DO RefreshSARSLinkBrowse.
                    !END
      
      
                 END
              END
      
      
              RETURN (LEVEL:Notify)
      
      
      
    OF ?MatterReportsPrintButton
      ThisWindow.Update
            CreateMatterQBEQueue
            
            
            CLEAR(GLO:QBEFilterString)
            LOC:TaggedRecordID = FstTag:PtrM(Tag:Matter)
            IF LOC:TaggedRecordID 
               IF MESSAGE('Do you want to print the tagged Matters only?','Ad Hoc Report',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:No
                  LOC:TaggedRecordID = 0
               END
            END
            
            IF LOC:TaggedRecordID
            
               GLO:QBEFilterString = CreateQBEFilterString(TAG:Matter,'A')
            
            ELSE
            
              GLO:QBEFilterString = GLO:FilterMatterSQLString
            
            END
            
            PrintUserQBEReport(0{PROP:Handle},TAG:Matter,'Matter Report')
    OF ?MAT:OptFilterButton
      ThisWindow.Update
      IF BRW54::Filter
        ?MAT:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
        BRW54::Filter = 0
      ELSE
        ?MAT:OptFilterButton{PROP:Text} = 'Sho&w All'
        BRW54::Filter = 1
      END!IF
      SELECT(?MattersBrowse)
      ThisWindow.Reset
      ?MattersBrowse{PROP:VScroll} = CHOOSE(RECORDS(Queue:Browse:1) = ?MattersBrowse{PROP:Items}, True, False)
      POST(EVENT:ScrollTop,?MattersBrowse)
      
    OF ?FeeSheetButton
      ThisWindow.Update
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
      
      
      CLEAR(MAT1:Record)
      ThisWindow.Update

      IF LOC:FN_Matter = 'Current'

        LOC:MAT:RecordID = LOC:CurrentMatterID

      ELSE

        IF MAT1:RecordID
           LOC:MAT:RecordID = GetMatterID(MAT1:RecordID)
        ELSE
           IF ~SAV:LastMatterID THEN SAV:LastMatterID = LOC:CurrentMatterID.
           LOC:MAT:RecordID = GetMatterID(SAV:LastMatterID)
         END

      END

      IF ~LOC:MAT:RecordID
          GLO:StopWatchMinutes = 0
          CYCLE
      END

      MAT:RecordID = LOC:MAT:RecordID
      Access:Matter.TryFetch(MAT:PrimaryKey) ! NEED MATTER IN MEMORY TO SELECT THE CORRECT FEE SHEEETS ETC AND FOR ADDFEENOTE BELOW

      AddToFavourites(MAT:RecordID)

      IF ~MAT:AccountsLanguageID
          MESSAGE('This matter has no Accounting Language selected.||This must be specified when you take on a Matter so the appropriate Fee Items can be inserted.',MAT:FileRef & ' - ' & MAT:Description,ICON:Exclamation)
          GLO:StopWatchMinutes = 0
          CYCLE
      ELSIF ~MAT:ClientFeeSheetID
          MESSAGE('This matter has no Fee Sheet selected.||This must be specified when you take on a Matter so the appropriate Fee Codes can be displayed.',MAT:FileRef & ' - ' & MAT:Description,ICON:Exclamation)
          GLO:StopWatchMinutes = 0
          CYCLE
      END
      
      FS:RecordID = MAT:ClientFeeSheetID
      IF Access:FeeSheet.Fetch(FS:PrimaryKey)
         MESSAGE('Unable to find the Fee Sheet for this matter.||Reason: ' & ERROR(),MAT:FileRef & ' - ' & MAT:Description,ICON:Exclamation)
         GLO:StopWatchMinutes = 0
         CYCLE
      END
      
      GlobalRequest = SelectRecord
      SelectFeeCode


      IF GlobalResponse = RequestCompleted

         IF ~CntTag:PtrM(Tag:FeeCode) Then SetTag:PtrM(Tag:FeeCode,FC:RecordID). ! If No Tags Then Tag Current FeeCode

         IF GLO:StopWatchMinutes

            GLO:FeeNoteDate = GLO:TodaysDate

         ELSE

           GLO:FeeNoteDate = GetUserDate(GLO:TodaysDate)

         END

         IF GLO:FeeNoteDate

            IF AddFeeNote(GLO:FeeNoteEmployeeId,GLO:FeeNoteCostCentreID,,GLO:StopWatchMinutes)


               IF GLO:StopWatchMinutes AND GLO:StopWatchNotes
                  CLEAR(FIL:Record)
                  FIL:MatterID = MAT:RecordID
                  FIL:Date = GLO:FeeNoteDate
                  FIL:EmployeeID = GLO:FeeNoteEmployeeId
                  FIL:Description = GLO:StopWatchNotes
                  FIL:InternalFlag = CEM:FileNotesInternalFlag
                  IF Access:FileNote.Insert()
                     MESSAGE('Unable to add Fee Note from Timed Stopwatch Record.||Error = ' & ERROR(),'Adding Fee Note',ICON:Exclamation)
                  END
                  GLO:StopWatchNotes = ''
               END


            END

            GLO:StopWatchMinutes = 0
            GLO:FeeNoteDate = GLO:TodaysDate   ! RESET IT IN CASE USER DOES A MERGE NEXT

         ELSE

            GLO:StopWatchMinutes = 0
            CYCLE  ! USER CANCELLED FROM DATE INPUT SCREEN

         END
      
         NewTag:PtrM(Tag:FeeCode)

         DO TotalFeeNotes

         FN:RecordID = GLO:AddedFeeNoteID
         Access:FeeNote.TryFetch(FN:PrimaryKey)

         DO RefreshFeeNoteBrowse

         DO RefreshMatActivBrowse

       END
       GLO:StopWatchMinutes = 0
    END

    SELECT(?FeeNoteBrowse)
      
    OF ?ProformaInvoiceButton
      ThisWindow.Update
      IF RestrictedMatterAlias(MAT:RecordID,0) THEN CYCLE.

      AddToFavourites(MAT:RecordID)

      IF LOC:FN_Period <> 'All' OR|
         GLO:FN_EmployeeID > 0  OR |
         GLO:FN_EmployeeID = -999999  OR |
         GLO:FN_CostCentreID > 0 OR |
         LOC:PostedOption <> 'All' OR |
         LOC:FN_Type <> 'All' !KDS FB 1503
         LOC:FilteredFeeNotesFlag = True
      ELSE
         LOC:FilteredFeeNotesFlag = False
      END

      PrintProforma(FN:MatterId,LOC:FilterFeeNoteSQLString,LOC:FilteredFeeNotesFlag)
    OF ?PostFeesButton
      ThisWindow.Update
  Clear(SP:Record)
  SP:SecGroupId = GLO:SecGroupId
  SP:Description = 'Matters - Desktop - Fee Notes - Post'
  If Access:SecProc.TryFetch(SP:SecGroupKey)
    SP:AccessFlag = True
    Access:SecProc.Insert()
  END
  If ~SP:AccessFlag and ~GLO:SupervisorFlag
      Message('You do not have sufficient rights to Post Fees.','Access Denied','~lock.ico')
      Cycle
  END


  IF ~FstTag:PtrM(Tag:FeeNote)      ! IF NOTHING TAGGED

      IF RestrictedMatterAlias(MAT:RecordID,0) THEN CYCLE.
      IF ViewOnlyMatterAlias(MAT:RecordID,0) THEN CYCLE.

      Do BRW2::TagOne
      If ~CntTag:PtrM(Tag:FeeNote) Then CYCLE.
  
  !    MESSAGE('You must tag the Fee Notes you want to post.||Hint: Use your Right Click Button to pop up a menu which will allow you to tag all.','Legalsuite Desktop',ICON:Asterisk)
  !    Cycle
  End
  
  !message('CntTag:PtrM(Tag:FeeNote) = ' & CntTag:PtrM(Tag:FeeNote) &|
  !        '|fstTag:PtrM(Tag:FeeNote) = ' & FstTag:PtrM(Tag:FeeNote))
  
  
  IF CntTag:PtrM(Tag:FeeNote) > 1
     IF MESSAGE('Do you want to Post these tagged Fee Notes to the Accounting module?','Posting Fees',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:No THEN CYCLE.
  END
  DO CombineTaggedFees
  ProcessFeeNote()
  
  DO BRW2::UntagAll

  IF GLO:TimeRecordingFlag
      DO RefreshMatActivBrowse
  END

  DO RefreshFeeNoteBrowse

  SELECT(?FeeNoteBrowse)
  
    OF ?LedgerEnquiryButton:2
      ThisWindow.Update
      POST(EVENT:Accepted,?LedgerEnquiryButton)
    OF ?EmployeeBalancesButton
      ThisWindow.Update
      IF GLO:FN_EmployeeID > 0
         CLEAR(EMP:Record)
         EMP:RecordID = GLO:EmployeeId
         Access:Employee.TryFetch(EMP:PrimaryKey)
         EmployeeBalance(GLO:FN_EmployeeID)
      ELSE
         MESSAGE('Please select an Employee from the drop down list before selecting this option.','No Employee selected',ICON:Exclamation)
      END
      SELECT(?FeeNoteBrowse)

    OF ?RefreshFeeNotesButton
      ThisWindow.Update
      ! 16/02/2017 Rick & PK Naidoo: Refresh FeeNote Browse
      !BRW2.ResetQueue(RESET:Done)
      
      BRW2.ResetSort(1)
      
      Select(?FeeNoteBrowse)
      
      
    OF ?LOC:FN_Employee
          Get(FN_Employee:Queue,Choice())
          GLO:FN_EmployeeID = FNQ:RecordID
    OF ?LOC:FN_CostCentre
          Get(FN_CostCentre:Queue,Choice())
          GLO:FN_CostCentreID = FNCCQ:RecordID
      
    OF ?AdjustFeenotes
      ThisWindow.Update
              IF ~FstTag:PtrM(TAG:FeeNote)
                  SetTag:PtrM(TAG:FeeNote,FN:RecordID)
              END
      
              SAV:FN:RecordID = FN:RecordID
              AdjustFeeNotes
      
              FN:RecordID = SAV:FN:RecordID ! TRY STAY ON THE CURRENT RECORD
              IF Access:FeeNote.TryFetch(FN:PrimaryKey) THEN CLEAR(FN:Record).
      
              DO RefreshFeeNoteBrowse
              SELECT(?FeeNoteBrowse)
    OF ?AdjustVatRateButton
      ThisWindow.Update
      IF ~FstTag:PtrM(Tag:FeeNote)
          MESSAGE('No Fee Notes are tagged.||You must tag the Fee Notes you want to adjust first.||Hint: Right-click and choose ''Tag Fees'' to tag fees only i.e. not disbursements.','Adjust Vat Rate',ICON:Exclamation)
          Cycle
      .
      LOC:AdjustVatRate = '1'
      
      OPEN(AdjustVatRateScreen)
      
      ?LOC:AdjustVatRate{PROP:From} = GetVatRate('1') & '|' & GetVatRate('2') & '|' & GetVatRate('3') & '|' & GetVatRate('N') & '|' & GetVatRate('E') & '|' & GetVatRate('Z')
      
      ?LOC:AdjustVatRate{PROP:Selected} = 1
      
      SELECT(?LOC:AdjustVatRate)
      DISPLAY
      
      ACCEPT
       CASE ACCEPTED()
       OF ?AdjustVatRateOKButton
      
         CLOSE(AdjustVatRateScreen)
         BREAK
      
       OF ?AdjustVatRateCancelButton
      
         CLOSE(AdjustVatRateScreen)
         LOC:AdjustVatRate = ''
         BREAK
      
       END
      
       CLOSE(AdjustVatRateScreen)
      
      END
      
      IF LOC:AdjustVatRate <> ''
      
         OPEN(ProgressWindow)
         
         ProgressWindow{PROP:Text} = 'Adjusting Vat Rates'
         ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:FeeNote)
         
         CLEAR(FN:Record)
         FN:RecordID = FstTag:PtrM(Tag:FeeNote)                ! SET TO THE FIRST TAGGED FeeNote
         LOOP
           IF ~Access:FeeNote.TryFetch(FN:PrimaryKey)
              FN:VatRate = LOC:AdjustVatRate
             Access:FeeNote.Update
           END
           ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
           DISPLAY
           FN:RecordID = NxtTag:PtrM(Tag:FeeNote)                ! SET TO NEXT FeeNote
           IF ~FN:RecordID THEN BREAK.
         END
         CLOSE(ProgressWindow)
      
      END
      
      DO BRW2::UntagAll
      DO RefreshFeeNoteBrowse
      SELECT(?FeeNoteBrowse)
      
      
    OF ?AdjustFeesButton
      ThisWindow.Update
      IF ~FstTag:PtrM(Tag:FeeNote)
        MESSAGE('No Fee Notes are tagged.||You must tag the Fee Notes you want to adjust first.||Hint: Right-click and choose ''Tag Fees'' to tag fees only i.e. not disbursements.','Adjust Amounts',ICON:Exclamation)
        Cycle
      .
      LOC:AdjustFeesHow = 'UP'
      OPEN(AdjustFeesScreen)
      SELECT(?LOC:AdjustFeesPercent)
      DISPLAY
      ACCEPT
         CASE ACCEPTED()
         OF ?AdjustFeesOKButton

           CLOSE(AdjustFeesScreen)
           BREAK

         OF ?AdjustFeesCancelButton

           CLOSE(AdjustFeesScreen)
           LOC:AdjustFeesPercent = 0
           BREAK

         END

         CLOSE(AdjustFeesScreen)

      END
      IF LOC:AdjustFeesPercent
        OPEN(ProgressWindow)
        ProgressWindow{PROP:Text} = 'Adjusting Amounts'
        ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:FeeNote)
        CLEAR(FN:Record)
        FN:RecordID = FstTag:PtrM(Tag:FeeNote)                ! SET TO THE FIRST TAGGED FeeNote
        LOOP
          IF ~Access:FeeNote.TryFetch(FN:PrimaryKey)
            IF LOC:AdjustFeesHow = 'DOWN'
               FN:Amount = FN:Amount - (FN:Amount * LOC:AdjustFeesPercent/100)
            ELSE
               FN:Amount = FN:Amount + (FN:Amount * LOC:AdjustFeesPercent/100)
            END
            Access:FeeNote.Update
          END
          ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
          DISPLAY
          FN:RecordID = NxtTag:PtrM(Tag:FeeNote)                ! SET TO NEXT FeeNote
          IF ~FN:RecordID THEN BREAK.
        END
        CLOSE(ProgressWindow)
      END
      
      DO BRW2::UntagAll
      DO RefreshFeeNoteBrowse
      SELECT(?FeeNoteBrowse)
      
    OF ?Delete
      ThisWindow.Update
              Clear(SP:Record)
              SP:SecGroupId = GLO:SecGroupId
              SP:AccessFlag = GLO:SupervisorFlag
              SP:Description = 'Matters - Desktop - Fee Notes - Delete'
              IF Access:SecProc.TryFetch(SP:SecGroupKey) Then Access:SecProc.Insert().
              If ~SP:AccessFlag and ~GLO:SupervisorFlag
                  Message('You do not have permission to delete Fee Notes','Desktop - Fee Note - Delete','~lock.ico')
                  RETURN(LEVEL:Notify)
              END
      
      
              IF FstTag:PtrM(TAG:FeeNote)
      
      
                 IF MESSAGE('There are ' & CntTag:PtrM(TAG:FeeNote) & ' FeeNotes tagged.||Do you want to Delete the Tagged FeeNotes?','Deleting Fee Notes',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:Yes
                    OPEN(ProgressWindow)
                    LOC:FeeNotesSkipped = 0
                    ProgressWindow{PROP:Text} = 'Deleting Fee Notes'
                    ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:FeeNote)
                    CLEAR(FN:Record)
                    FN:RecordID = FstTag:PtrM(Tag:FeeNote)                ! SET TO THE FIRST TAGGED FeeNote
                    LOOP 
                         IF ~Access:FeeNote.TryFetch(FN:PrimaryKey)
      
                             LOOP 1 TIMES
                                  IF CheckMatterAccess(FN:MatterID)  ! ADDED 8/11/2010
                                     MESSAGE('Unable to Delete this Fee Note.||You do not have Access rights to this Matter|','Access Denied',ICON:Exclamation)
                                     BREAK
                                  END
      
                                  DELETE(FeeNote)
      
                                  PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL(FN:Description) & ''',' & FN:Amount & ',''FeeNote'',3,' & CEM:RecordID & ',' & FN:RecordID & ',(SELECT FileRef FROM Matter WHERE RecordID = ' & FN:MatterID & '),''' & GlobalErrors.GetProcedureName() & '''','FileManager - Delete FeeNote in Desktop')
      
                             END
                         END
      
                         ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
                         DISPLAY
                         FN:RecordID = NxtTag:PtrM(Tag:FeeNote)                ! SET TO NEXT FeeNote
                         IF ~FN:RecordID THEN BREAK.
                    END
                    CLOSE(ProgressWindow)
                    NewTag:PtrM(Tag:FeeNote)         ! CLEAR THE TAGS
                    CLEAR(FN:Record)
                    DO RefreshFeeNoteBrowse
                    SELECT(?FeeNoteBrowse,CHOICE(?FeeNoteBrowse))
            
            
                 END
      
              ELSE
      
                 IF CheckMatterAccess(FN:MatterID)  ! ADDED 8/11/2010
      
                    MESSAGE('Unable to Delete this Fee Note.||You do not have Access rights to this Matter|','Access Denied',ICON:Exclamation)
      
                 ELSE
      
                    IF MESSAGE('Are you sure you want to Delete this Fee Note?|','Confirm Deletion',ICON:Question,BUTTON:OK+BUTTON:Cancel,BUTTON:OK) = BUTTON:OK
      
      
                       PROPSQL('DELETE FeeNote WHERE RecordID = ' & FN:RecordID)
                       PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL(FN:Description) & ''',' &  FN:Amount & ',''FeeNote'',3,' & CEM:RecordID & ',' & FN:RecordID & ',(SELECT FileRef FROM Matter WHERE RecordID = ' & FN:MatterID & '),''' & GlobalErrors.GetProcedureName() & '''','FileManager - Delete FeeNote in Desktop')
      
                       FLUSH(BRW2.View)
                       DELETE(Queue:Browse)
                       BRW2.ResetQueue(Reset:Queue)
                       ThisWindow.Reset(True) ! Nick - 6/7/2015 - Adding this stops error when editing the Timed Record (MatActiv) that is linked to the deleted feenote
                    END
      
                 END
      
              END
      
      
             RETURN(LEVEL:Notify)
      
      
    OF ?TagFeesButton
      ThisWindow.Update
        SET(BRW2::View:Browse)
        LOOP
            NEXT(BRW2::View:Browse)
            IF ERRORCODE() THEN BREAK.
            IF BRW2.ValidateRecord() THEN CYCLE.
            IF FN:Type1 = 'F'
               SetTag:PtrM(TAG:FeeNote,FN:RecordID)
            END
        END
        IF CntTag:PtrM(TAG:FeeNote)
           MESSAGE(CntTag:PtrM(TAG:FeeNote) & ' Fee Notes were tagged.','Tagging Fees',ICON:Exclamation)
           DO RefreshFeeNoteBrowse
        ELSE
           MESSAGE(' No Fee Notes were tagged.||None of the fee notes displayed are ''fees''.','Tagging Fees',ICON:Exclamation)
        END
        SELECT(?FeeNoteBrowse,CHOICE(?FeeNoteBrowse))
      
    OF ?TagOne:2
      ThisWindow.Update
      DO BRW2::TagOne
    OF ?UntagOne:2
      ThisWindow.Update
      DO BRW2::UntagOne
    OF ?CopyToDebtorButton
      ThisWindow.Update
      IF FstTag:PtrM(TAG:FeeNote)
         OPEN(ProgressWindow)
         ProgressWindow{PROP:Text} = 'Copying tagged Fee Notes to the Debtors Account'
         ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:FeeNote)
         CLEAR(FN:Record)
         FN:RecordID = FstTag:PtrM(Tag:FeeNote)                ! SET TO THE FIRST TAGGED FeeNote
         LOOP
           IF ~Access:FeeNote.TryFetch(FN:PrimaryKey)
             AddColDebitFromFeenote
             ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
             DISPLAY
             FN:RecordID = NxtTag:PtrM(Tag:FeeNote)                ! SET TO NEXT FeeNote
             IF ~FN:RecordID THEN BREAK.
           END
         END
         CLOSE(ProgressWindow)
         DO BRW2::UntagAll
         DO RefreshFeeNoteBrowse
      ELSE
         MESSAGE('No fee notes are tagged.||You must tag the fee notes you want to copy first.','Copy Fees',ICON:Exclamation)
      END
      SELECT(?FeeNoteBrowse,CHOICE(?FeeNoteBrowse))
      
    OF ?ClearProformaIDButton
      ThisWindow.Update
      DO ClearProformaID
      DO BRW2::UntagAll
      DO RefreshFeeNoteBrowse
      
    OF ?ExportFeeNoteButton
      ThisWindow.Update
      !If ~FstTag:PtrM(TAG:FeeNote)
      !  Message('No FeeNotes Have Been Tagged|Tag FeeNotes First','Export Data',ICON:Asterisk)
      !  Cycle
      !.
      If GetReportEmp(TAG:FeeNote,2) Then Cycle.
      If FstTag:PtrM(TAG:FeeNote)
        REE:FeeNoteOption = 2
      .
      Case LOC:FN_Matter
      Of 'Current'
        REE:MatterOption = 1
        REE:MatterId = LOC:CurrentMatterID
      Of 'Tagged'
        REE:MatterOption = 2
      .
      If LOC:FN_FromDate or LOC:FN_ToDate
        REE:TransactionDateOption = 1
        REE:FromTransactionDate = LOC:FN_FromDate
        REE:ToTransactionDate = LOC:FN_ToDate
      .
      Case LOC:PostedOption
      Of 'Unposted'
        REE:CustomOption = 1
        REE:Custom = Choose(~~REE:Custom, REE:Custom & ' and ','') & 'FN:PostedFlag = 0'
      Of 'Posted'
        REE:CustomOption = 1
        REE:Custom = Choose(~~REE:Custom, REE:Custom & ' and ','') & 'FN:PostedFlag = 1'
      .
      If GLO:FN_CostCentreID > 0
        REE:CustomOption = 1
        REE:Custom = Choose(~~REE:Custom, REE:Custom & ' and ','') & 'FN:CostCentreId = ' & GLO:FN_CostCentreID
      .
      If GLO:FN_EmployeeID > 0
        REE:CustomOption = 1
        REE:Custom = Choose(~~REE:Custom, REE:Custom & ' and ','') & 'FN:EmployeeId = ' & GLO:FN_EmployeeID
      .
      If Access:ReportEmp.Update() Then Cycle.
      START(ExportXML, 25000, TAG:Feenote)
    OF ?OnholdButton
      ThisWindow.Update
         DO PutFeesOnHold
         DO BRW2::UntagAll
         DO RefreshFeeNoteBrowse

    OF ?UpdateVoucherButton
      ThisWindow.Update
        DO UpdateVoucher
        DO RefreshFeeNoteBrowse
    OF ?ImportFromLedgerButton
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
                        DO ConvertMTTtoFeeNotes
                    END
                    ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
                    DISPLAY
                    MTT:RecordID = NxtTag:PtrM(TAG:MatTran)                ! SET TO NEXT MATTER
                    IF ~MTT:RecordID THEN CLEAR(MTT:Record);BREAK.
                   
               END
               NewTag:PtrM(TAG:MatTran)
               CLOSE(ProgressWindow)
           ELSE
               DO ConvertMTTtoFeeNotes
           END
           DO RefreshFeeNoteBrowse
       END
    OF ?OffHoldButton
      ThisWindow.Update
         DO TakeFeesOffHold

         DO BRW2::UntagAll
         DO RefreshFeeNoteBrowse

    OF ?TagDisbursementsButton
      ThisWindow.Update
        SET(BRW2::View:Browse)
        LOOP
            NEXT(BRW2::View:Browse)
            IF ERRORCODE() THEN BREAK.
            IF BRW2.ValidateRecord() THEN CYCLE.
            IF FN:Type1 = 'D' OR FN:Type1 = 'R'
               SetTag:PtrM(TAG:FeeNote,FN:RecordID)
            END
        END
        IF CntTag:PtrM(TAG:FeeNote)
           MESSAGE(CntTag:PtrM(TAG:FeeNote) & ' Fee Notes were tagged.','Tagging Disbursements',ICON:Exclamation)
           DO RefreshFeeNoteBrowse
        ELSE
           MESSAGE(' No Fee Notes were tagged.||None of the fee notes displayed are ''disbursements''.','Tagging Fees',ICON:Exclamation)
        END
        SELECT(?FeeNoteBrowse,CHOICE(?FeeNoteBrowse))
      
    OF ?CombineFeesButton
      ThisWindow.Update
         DO CombineAllFees
         DO BRW2::UntagAll
         DO RefreshFeeNoteBrowse
    OF ?MoveUp
      ThisWindow.Update
      DO BRW2::SequencedMoveUp
    OF ?MoveDown
      ThisWindow.Update
      DO BRW2::SequencedMoveDown
    OF ?TagAll:2
      ThisWindow.Update
      DO BRW2::TagAll
    OF ?UntagAll:2
      ThisWindow.Update
      DO BRW2::UntagAll
    OF ?FN:OptFilterButton
      ThisWindow.Update
      IF BRW2::Filter
        ?FN:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
        BRW2::Filter = 0
      ELSE
        ?FN:OptFilterButton{PROP:Text} = 'Sho&w All'
        BRW2::Filter = 1
      END!IF
      SELECT(?FeeNoteBrowse)
      ThisWindow.Reset
      ?FeeNoteBrowse{PROP:VScroll} = CHOOSE(RECORDS(Queue:Browse) = ?FeeNoteBrowse{PROP:Items}, True, False)
      DO TotalFeeNotes ! FB Case 1478 PK Naidoo: placed this bit of code back as the Fee Note Browse did not refresh the totals when switching tabs.
      POST(EVENT:ScrollTop,?FeeNoteBrowse)

    OF ?RefreshFileNotesButton
      ThisWindow.Update
      ! 16/02/2017 Rick & PK Naidoo: Refresh FeeNote Browse

      !BRW52.ResetQueue(RESET:Done)
      ! FB Case 1330
      BRW52.ResetSort(1)

      Select(?FileNoteBrowse)



    OF ?LOC:FIL_Employee
          Get(FIL_Employee:Queue,Choice())
          GLO:FIL_EmployeeID = FILQ:RecordID
      
    OF ?ExportFileNoteButton
      ThisWindow.Update
      If GetReportEmp(TAG:FileNote,2) Then Cycle.
      If FstTag:PtrM(TAG:FileNote)
        REE:FileNoteOption = 2
      .
      If LOC:FIL_FromDate or LOC:FIL_ToDate
        REE:TransactionDateOption = 1
        REE:FromTransactionDate = LOC:FIL_FromDate
        REE:ToTransactionDate = LOC:FIL_ToDate
      .
      
      Case LOC:FIL_Status
      Of 'No Stage'
        REE:CustomOption = 1
        REE:Custom = Choose(~~REE:Custom, REE:Custom & ' and ','') & 'FIL:StageID = 0'
      Of 'Stage Reached'
        REE:CustomOption = 1
        REE:Custom = Choose(~~REE:Custom, REE:Custom & ' and ','') & 'FIL:StageID > 0'
      .
      
      Case LOC:FIL_Internal
      Of 'Internal'
        REE:CustomOption = 1
        REE:Custom = Choose(~~REE:Custom, REE:Custom & ' and ','') & 'FIL:InternalFlag = 1'
      Of 'Not Internal'
        REE:CustomOption = 1
        REE:Custom = Choose(~~REE:Custom, REE:Custom & ' and ','') & 'FIL:InternalFlag <> 1'
      .
      
      
      Case LOC:FIL_Matter
      Of 'Current'
        REE:MatterOption = 1
        REE:MatterId = LOC:CurrentMatterID
      Of 'Tagged'
        REE:MatterOption = 2
      .
      If GLO:FIL_EmployeeID > 0
        REE:CustomOption = 1
        REE:Custom = Choose(~~REE:Custom, REE:Custom & ' and ','') & 'FIL:EmployeeId = ' & GLO:FIL_EmployeeID
      .
      
      If Access:ReportEmp.Update() Then Cycle.
      START(ExportXML, 25000, TAG:FileNote)
    OF ?TagOne:3
      ThisWindow.Update
      DO BRW52::TagOne
    OF ?UntagOne:3
      ThisWindow.Update
      DO BRW52::UntagOne
    OF ?TagAll:3
      ThisWindow.Update
      DO BRW52::TagAll
    OF ?UntagAll:3
      ThisWindow.Update
      DO BRW52::UntagAll
    OF ?MakeFeeNoteButton
      ThisWindow.Update
      IF GLO:TimeRecordingFlag
         CLEAR(MA:Record)
         MA:MatterID = FIL:MatterID
         MA:Description = FIL:Description
         GlobalRequest = SelectRecord
         BrowseActivity
         IF GlobalResponse = RequestCompleted
            IF ~GetTimedRecord(MA:MatterID)
                  IF ~Access:MatActiv.Insert()
                      IF GLO:MAFeeNoteFlag
                         !4 Aug 2017 - KDS - fix for 794
                         AddFeeNoteFromMA(,FIL:RecordID)
                      END
      
                      IF GLO:MADisbursementID
                         
                         SetTag:PtrM(Tag:FeeCode,GLO:MADisbursementID)
                         GLO:FeeNoteDate = MA:Date  ! USE THE DATE OF THE TIME RECORD TO MAKE THE DISBURSEMENT
                         AddFeeNote(CEM:RecordID,MA:CostCentreID)
                         GLO:FeeNoteDate = 0
                         NewTag:PtrM(Tag:FeeCode)
                      END
      
!                      IF GLO:MAToDoNoteFlag
!                       DO AddToDoNote
!                     END
      
                  END
      
            END
      
         END

         BRW52.ResetQueue(RESET:Done)
      
      ELSE

         AddFeeNoteFromFileNote
         ! 24/05/2017 PK Naidoo: FB Case 794 - Refresh the Browse once a Fee Note has been created from a File Note
         BRW52.ResetQueue(RESET:Done)
      
      END
      
    OF ?Delete:5
      ThisWindow.Update
      
              Clear(SP:Record)
              SP:SecGroupId = GLO:SecGroupId
              SP:AccessFlag = GLO:SupervisorFlag
              SP:Description = 'Matters - Desktop - File Notes - Update - Delete'
              IF Access:SecProc.TryFetch(SP:SecGroupKey) Then Access:SecProc.Insert().
              If ~SP:AccessFlag and ~GLO:SupervisorFlag
                  Message('You do not have permission to delete File Notes','Desktop - File Note - Delete','~lock.ico')
                  RETURN(LEVEL:Notify)
              END
         
      
              IF FstTag:PtrM(TAG:FileNote)
            
                 IF MESSAGE('There are ' & CntTag:PtrM(TAG:FileNote) & ' File Notes tagged.||Do you want to Delete the Tagged File Notes?','Deleting File Notes',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:Yes
      
                    OPEN(ProgressWindow)
                    ProgressWindow{PROP:Text} = 'Deleting File Notes'
                    ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:FileNote)
                    CLEAR(FIL:Record)
                    FIL:RecordID = FstTag:PtrM(Tag:FileNote)                ! SET TO THE FIRST TAGGED FileNote
                    LOOP 
                         IF ~Access:FileNote.TryFetch(FIL:PrimaryKey)
      
                             LOOP 1 TIMES
                                  IF CheckMatterAccess(FIL:MatterID)  ! ADDED 8/11/2010
                                     MESSAGE('Unable to Delete this File Note.||You do not have Access rights to this Matter|','Access Denied',ICON:Exclamation)
                                     BREAK
                                  END
      
                                  DELETE(FileNote)
      
                                  PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL(FIL:Description) & ''',0,''FileNote'',3,' & CEM:RecordID & ',' & FIL:RecordID & ',(SELECT FileRef FROM Matter WHERE RecordID = ' & FIL:MatterID & '),''' & GlobalErrors.GetProcedureName() & '''','FileManager - Delete FileNote in Desktop')
      
                                  LOC:FilteredFileNotes -= 1
      
      
                             END
      
                         END
                         ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
                         DISPLAY
                         FIL:RecordID = NxtTag:PtrM(Tag:FileNote)                ! SET TO NEXT FileNote
                         IF ~FIL:RecordID THEN BREAK.
                    END
                    CLOSE(ProgressWindow)
      
                    DISPLAY(?LOC:FilteredFileNotes)
      
      
                    NewTag:PtrM(Tag:FileNote)
      
                    DO RefreshFileNoteBrowse
                    SELECT(?FileNoteBrowse,1)
      
                 END
      
              ELSE
      
                 IF CheckMatterAccess(FIL:MatterID)  ! ADDED 8/11/2010
                    MESSAGE('Unable to Delete this File Note.||You do not have Access rights to this Matter|','Access Denied',ICON:Exclamation)
                 ELSE
      
                    IF MESSAGE('Are you sure you want to Delete this File Note?|','Confirm Deletion',ICON:Question,BUTTON:OK+BUTTON:Cancel,BUTTON:OK) = BUTTON:OK
      
      
                       PROPSQL('DELETE FileNote WHERE RecordID = ' & FIL:RecordID)
                       PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL(FIL:Description) & ''',0,''FileNote'',3,' & CEM:RecordID & ',' & FIL:RecordID & ',(SELECT FileRef FROM Matter WHERE RecordID = ' & FIL:MatterID & '),''' & GlobalErrors.GetProcedureName() & '''','FileManager - Delete FileNote in Desktop')
      
      
                       LOC:FilteredFileNotes -= 1
                       DISPLAY(?LOC:FilteredFileNotes)
      
      
                       FLUSH(BRW52.View)
                       DELETE(Queue:Browse:2)
                       BRW52.ResetQueue(Reset:Queue)
      
      
                       IF CEM:ProgressIndicatorFlag = 'S' AND LOC:ShowMatterIconsFlag  ! UPDATE THE PROGRESS ICON.
                          BRW54.ApplyFilter
                          BRW54.ResetFromBuffer
                       END
      
      
                    END
      
                 END
      
              END
      
              RETURN(LEVEL:Notify)
      
      
    OF ?MakeExternalButton
      ThisWindow.Update
              
              IF FstTag:PtrM(TAG:FileNote)
            
                 IF MESSAGE('There are ' & CntTag:PtrM(TAG:FileNote) & ' File Notes tagged.||Do you want to set all of the Tagged File Notes to External','Updating File Notes',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:Yes
      
                    OPEN(ProgressWindow)
                    ProgressWindow{PROP:Text} = 'Updating File Notes'
                    ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:FileNote)
                    CLEAR(FIL:Record)
                    FIL:RecordID = FstTag:PtrM(Tag:FileNote)                ! SET TO THE FIRST TAGGED FileNote
                    LOOP 
                         IF ~Access:FileNote.TryFetch(FIL:PrimaryKey)
      
                             LOOP 1 TIMES
                                  IF CheckMatterAccess(FIL:MatterID)  ! ADDED 8/11/2010
                                     MESSAGE('Unable to Update this File Note.||You do not have Access rights to this Matter|','Access Denied',ICON:Exclamation)
                                     BREAK
                                  END
                                  FIL:InternalFlag = 0
                                  Access:FileNote.Update
      
                                  PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL(FIL:Description) & ''',0,''FileNote'',2,' & CEM:RecordID & ',' & FIL:RecordID & ',(SELECT FileRef FROM Matter WHERE RecordID = ' & FIL:MatterID & '),''' & GlobalErrors.GetProcedureName() & '''','FileManager - Update FileNote in Desktop')
      
                                  LOC:FilteredFileNotes -= 1
      
      
                             END
      
                         END
                         ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
                         DISPLAY
                         FIL:RecordID = NxtTag:PtrM(Tag:FileNote)                ! SET TO NEXT FileNote
                         IF ~FIL:RecordID THEN BREAK.
                    END
                    CLOSE(ProgressWindow)
      
                    DISPLAY(?LOC:FilteredFileNotes)
      
      
                    NewTag:PtrM(Tag:FileNote)
      
                    DO RefreshFileNoteBrowse
                    SELECT(?FileNoteBrowse,1)
      
                 END
      
              ELSE
      
                 IF CheckMatterAccess(FIL:MatterID)  ! ADDED 8/11/2010
                    MESSAGE('Unable to Update this File Note.||You do not have Access rights to this Matter|','Access Denied',ICON:Exclamation)
                 ELSE
      
                    IF MESSAGE('Are you sure you want to set this File Note to external?|','Confirm Update',ICON:Question,BUTTON:OK+BUTTON:Cancel,BUTTON:OK) = BUTTON:OK
                       PROPSQL('UPDATE FileNote SET InternalFlag = 0 WHERE RecordID = ' & FIL:RecordID)
                       PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL(FIL:Description) & ''',0,''FileNote'',2,' & CEM:RecordID & ',' & FIL:RecordID & ',(SELECT FileRef FROM Matter WHERE RecordID = ' & FIL:MatterID & '),''' & GlobalErrors.GetProcedureName() & '''','FileManager - Update FileNote in Desktop')
      
      
                       LOC:FilteredFileNotes -= 1
                       DISPLAY(?LOC:FilteredFileNotes)
      
      
                       FLUSH(BRW52.View)
                       DELETE(Queue:Browse:2)
                       BRW52.ResetQueue(Reset:Queue)
      
      
                       IF CEM:ProgressIndicatorFlag = 'S' AND LOC:ShowMatterIconsFlag  ! UPDATE THE PROGRESS ICON.
                          BRW54.ApplyFilter
                          BRW54.ResetFromBuffer
                       END
      
      
                    END
      
                 END
      
              END
      
              RETURN(LEVEL:Notify)
    OF ?MakeInternalButton
      ThisWindow.Update
              
              IF FstTag:PtrM(TAG:FileNote)
            
                 IF MESSAGE('There are ' & CntTag:PtrM(TAG:FileNote) & ' File Notes tagged.||Do you want to set all of the Tagged File Notes to Internal?','Updating File Notes',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:Yes
      
                    OPEN(ProgressWindow)
                    ProgressWindow{PROP:Text} = 'Updating File Notes'
                    ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:FileNote)
                    CLEAR(FIL:Record)
                    FIL:RecordID = FstTag:PtrM(Tag:FileNote)                ! SET TO THE FIRST TAGGED FileNote
                    LOOP 
                         IF ~Access:FileNote.TryFetch(FIL:PrimaryKey)
      
                             LOOP 1 TIMES
                                  IF CheckMatterAccess(FIL:MatterID)  ! ADDED 8/11/2010
                                     MESSAGE('Unable to Update this File Note.||You do not have Access rights to this Matter|','Access Denied',ICON:Exclamation)
                                     BREAK
                                  END
                                  FIL:InternalFlag = 1
                                  Access:FileNote.Update
      
                                  PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL(FIL:Description) & ''',0,''FileNote'',2,' & CEM:RecordID & ',' & FIL:RecordID & ',(SELECT FileRef FROM Matter WHERE RecordID = ' & FIL:MatterID & '),''' & GlobalErrors.GetProcedureName() & '''','FileManager - Update FileNote in Desktop')
      
                                  LOC:FilteredFileNotes -= 1
      
      
                             END
      
                         END
                         ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
                         DISPLAY
                         FIL:RecordID = NxtTag:PtrM(Tag:FileNote)                ! SET TO NEXT FileNote
                         IF ~FIL:RecordID THEN BREAK.
                    END
                    CLOSE(ProgressWindow)
      
                    DISPLAY(?LOC:FilteredFileNotes)
      
      
                    NewTag:PtrM(Tag:FileNote)
      
                    DO RefreshFileNoteBrowse
                    SELECT(?FileNoteBrowse,1)
      
                 END
      
              ELSE
      
                 IF CheckMatterAccess(FIL:MatterID)  ! ADDED 8/11/2010
                    MESSAGE('Unable to Update this File Note.||You do not have Access rights to this Matter|','Access Denied',ICON:Exclamation)
                 ELSE
      
                    IF MESSAGE('Are you sure you want to set this File Note to internal?|','Confirm Update',ICON:Question,BUTTON:OK+BUTTON:Cancel,BUTTON:OK) = BUTTON:OK
                       PROPSQL('UPDATE FileNote SET InternalFlag = 1 WHERE RecordID = ' & FIL:RecordID)
                       PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL(FIL:Description) & ''',0,''FileNote'',2,' & CEM:RecordID & ',' & FIL:RecordID & ',(SELECT FileRef FROM Matter WHERE RecordID = ' & FIL:MatterID & '),''' & GlobalErrors.GetProcedureName() & '''','FileManager - Update FileNote in Desktop')
      
      
                       LOC:FilteredFileNotes -= 1
                       DISPLAY(?LOC:FilteredFileNotes)
      
      
                       FLUSH(BRW52.View)
                       DELETE(Queue:Browse:2)
                       BRW52.ResetQueue(Reset:Queue)
      
      
                       IF CEM:ProgressIndicatorFlag = 'S' AND LOC:ShowMatterIconsFlag  ! UPDATE THE PROGRESS ICON.
                          BRW54.ApplyFilter
                          BRW54.ResetFromBuffer
                       END
      
      
                    END
      
                 END
      
              END
      
              RETURN(LEVEL:Notify)
    OF ?FIL:OptFilterButton
      ThisWindow.Update
      IF BRW52::Filter
        ?FIL:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
        BRW52::Filter = 0
      ELSE
        ?FIL:OptFilterButton{PROP:Text} = 'Sho&w All'
        BRW52::Filter = 1
      END!IF
      SELECT(?FileNoteBrowse)
      ThisWindow.Reset
      ?FileNoteBrowse{PROP:VScroll} = CHOOSE(RECORDS(Queue:Browse:4) = ?FileNoteBrowse{PROP:Items}, True, False)
      POST(EVENT:ScrollTop,?FileNoteBrowse)

      
    OF ?AdjustRemindersButton
      ThisWindow.Update
        IF ~FstTag:PtrM(TAG:ToDoNote)
            SetTag:PtrM(TAG:ToDoNote,TOD:RecordID)
        END

        SAV:TOD:RecordID = TOD:RecordID
        AdjustToDoNotes

        TOD:RecordID = SAV:TOD:RecordID ! TRY STAY ON THE CURRENT RECORD
        IF Access:ToDoNote.TryFetch(TOD:PrimaryKey) THEN CLEAR(TOD:Record).

        DO RefreshToDoNoteBrowse
        SELECT(?ToDoNoteBrowse)



    OF ?MakeRemindersDocumentsButton
      ThisWindow.Update
            NewTag:PtrM(TAG:DocMergeQueue)
            NewTag:Ptrm(TAG:Matter)
      
            PropSQL('Delete DocMergeQueue WHERE EmployeeID = ' & CEM:RecordID)
      
            IF FstTag:PtrM(TAG:ToDoNote)
              CLEAR(TOD:Record)
              TOD:RecordID = FstTag:PtrM(TAG:ToDoNote)               
              LOOP 
                IF ~Access:ToDoNote.TryFetch(TOD:PrimaryKey)
                  IF TOD:MatterID AND TOD:NextDocumentID
      
                    SetTag:Ptrm(TAG:Matter,TOD:MatterID)
      
                    DOC:RecordID = TOD:NextDocumentID
                    IF ~Access:Document.TryFetch(DOC:PrimaryKey)
                        PropSQLNext('SELECT 0,FileRef FROM Matter WHERE RecordID = ' & TOD:MatterID)
      
                        DO AddDocMergeQueue
      
                        IF ~TOD:DateDone
                            TOD:DateDone = GLO:TodaysDate
                            Access:ToDoNote.Update
                        END
                    ELSE
                      MESSAGE('Document (' & TOD:NextDocumentID & ') not found.','Error',ICON:Exclamation)
                    END
      
                  END
      
                END
      
                TOD:RecordID = NxtTag:PtrM(TAG:ToDoNote)
                IF ~TOD:RecordID THEN BREAK.
              END
      
              DO BRW15::UntagAll
      
            ELSE
              ThisWindow.Update
              IF TOD:MatterID AND TOD:NextDocumentID
      
                 SetTag:Ptrm(TAG:Matter,TOD:MatterID)
      
                 DOC:RecordID = TOD:NextDocumentID
                 IF ~Access:Document.TryFetch(DOC:PrimaryKey)
      
                     DO AddDocMergeQueue
      
                     IF ~TOD:DateDone
                         TOD:DateDone = GLO:TodaysDate
                         Access:ToDoNote.Update
                      END
                 ELSE
      
                      MESSAGE('Document (' & TOD:NextDocumentID & ') not found.','Error',ICON:Exclamation)
      
                 END
               ELSE
                 MESSAGE('No Documents can be made from this Reminder.||The Reminder must be assigned to a Matter and have a Document associated with it.','Message',ICON:Exclamation)
               END
            END
      
            MergeDocuments
      
            DO RefreshToDoNoteBrowse
            SELECT(?ToDoNoteBrowse,CHOICE(?ToDoNoteBrowse))
    OF ?ToDoNoteJumpToMatterButton
      ThisWindow.Update
        SELECT(?MattersBrowse)
        LOC:JumpToRecordID = TOD:MatterID
        POST(EVENT:JumpToMatter)
        SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
    OF ?RefreshToDoNotesButton
      ThisWindow.Update
      ! 07/04/2016 PK Naidoo: Refresh ToDoNote Browse
      !BRW15.ResetQueue(RESET:Done)
      
            ! 25/06/2018 PK Naidoo: FB Case 1653
            BRW15.ResetSort(1)
      
            Select(?ToDoNoteBrowse)
    OF ?LOC:TOD_Employee
        Get(TOD_Employee:Queue,Choice())
        GLO:TOD_EmployeeID = TODQ:RecordID
    OF ?LOC:TOD_CriticalStep
        Get(TOD_CriticalStep:Queue,Choice())
        LOC:TOD_CriticalStepID = CRIQ:RecordID
      
    OF ?MakeOutLookAppointmentButton
      ThisWindow.Update
      IF ~Access:ToDoNote.Fetch(TOD:PrimaryKey)
      
          IF TOD:OutLookAppointmentID
      
             CASE MESSAGE('An Appointment has already been created in OutLook for this Reminder|','Appointment Already Exists',ICON:Exclamation,'&View|&Delete|&Cancel',1)
                  OF 1
                     UpdateOutLookAppointmentFromReminder(4)  ! VIEW THE Appointment
                  OF 2
                     UpdateOutLookAppointmentFromReminder(3)  ! DELETE THE Appointment
             END
      
          ELSE
      
             IF UpdateOutLookAppointmentFromReminder(1)  ! CREATE THE Appointment
      
                IF MESSAGE('An Appointment was created successfully in OutLook|','Appointment Created',ICON:Exclamation,'&View|&Ok',2) = 1
                   Access:ToDoNote.Fetch(TOD:PrimaryKey)
                   UpdateOutLookAppointmentFromReminder(4)  ! VIEW THE Appointment
                END
      
             END
      
          END
      
      ELSE
      
          MESSAGE('Error accessing Reminder||Error: ' & ERROR(),'Data Access Error',ICON:Exclamation)
      
      END
      
      SELECT(?ToDoNoteBrowse,CHOICE(?ToDoNoteBrowse))
      
    OF ?MakeOutLookTaskButton
      ThisWindow.Update
      IF ~Access:ToDoNote.Fetch(TOD:PrimaryKey)
      
          IF TOD:OutLookTaskID
      
             CASE MESSAGE('A Task has already been created in OutLook for this Reminder|','Task Already Exists',ICON:Exclamation,'&View Task|&Delete Task|&Cancel',1)
                  OF 1
                     UpdateOutLookTaskFromReminder(4)  ! VIEW THE TASK
                  OF 2
                     UpdateOutLookTaskFromReminder(3)  ! DELETE THE TASK
             END
      
          ELSE
      
             IF UpdateOutLookTaskFromReminder(1)  ! CREATE THE TASK
      
                IF MESSAGE('A Task was created successfully in OutLook|','Task Created',ICON:Exclamation,'&View|&Ok',2) = 1
                   Access:ToDoNote.Fetch(TOD:PrimaryKey)
                   UpdateOutLookTaskFromReminder(4)  ! VIEW THE TASK
                END
      
             END
      
          END
      
      ELSE
      
          MESSAGE('Error accessing Reminder||Error: ' & ERROR(),'Data Access Error',ICON:Exclamation)
      
      END
      
      SELECT(?ToDoNoteBrowse,CHOICE(?ToDoNoteBrowse))
      
    OF ?ExportToDoNoteButton
      ThisWindow.Update
      If GetReportEmp(TAG:ToDoNote,2) Then Cycle.
      If FstTag:PtrM(TAG:ToDoNote)
        REE:ToDoNoteOption = 2
      .
      If LOC:TOD_FromDate or LOC:TOD_ToDate
        REE:TransactionDateOption = 1
        REE:FromTransactionDate = LOC:TOD_FromDate
        REE:ToTransactionDate = LOC:TOD_ToDate
      .
      Case LOC:TOD_Matter
      Of 'Current'
        REE:MatterOption = 1
        REE:MatterId = LOC:CurrentMatterID
      Of 'Tagged'
        REE:MatterOption = 2
      .
      Case LOC:TOD_Status
      Of 'Incomplete'
        REE:CustomOption = 1
        REE:Custom = Choose(~~REE:Custom, REE:Custom & ' and ','') & 'TOD:DateDone = 0'
      Of 'Completed'
        REE:CustomOption = 1
        REE:Custom = Choose(~~REE:Custom, REE:Custom & ' and ','') & 'TOD:DateDone > 0'
      .
      
      If GLO:TOD_EmployeeID > 0
        REE:CustomOption = 1
        REE:Custom = Choose(~~REE:Custom, REE:Custom & ' and ','') & 'TOD:EmployeeID = ' & GLO:TOD_EmployeeID
      .
      If Access:ReportEmp.Update() Then Cycle.
      START(ExportXML, 25000, TAG:ToDoNote)
    OF ?Delete:2
      ThisWindow.Update
              Clear(SP:Record)
              SP:SecGroupId = GLO:SecGroupId
              SP:AccessFlag = GLO:SupervisorFlag
              SP:Description = 'Matters - Desktop - Reminders - Update - Delete'
              IF Access:SecProc.TryFetch(SP:SecGroupKey) Then Access:SecProc.Insert().
              If ~SP:AccessFlag and ~GLO:SupervisorFlag
                  Message('You do not have permission to delete Reminders','Access Denied','~lock.ico')
                  RETURN(LEVEL:Notify)
              END
      
      
              IF FstTag:PtrM(TAG:ToDoNote)
            
      
                 IF MESSAGE('There are ' & CntTag:PtrM(TAG:ToDoNote) & ' Reminders tagged.||Do you want to Delete the Tagged Reminders?','Confirm Deletion',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:Yes
      
                    OPEN(ProgressWindow)
                    ProgressWindow{PROP:Text} = 'Deleting Reminders'
                    ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:ToDoNote)
                    CLEAR(TOD:Record)
                    TOD:RecordID = FstTag:PtrM(Tag:ToDoNote)                ! SET TO THE FIRST TAGGED ToDoNote
                    LOOP 
                         IF ~Access:ToDoNote.TryFetch(TOD:PrimaryKey)
            
                             LOOP 1 TIMES
                                  IF CheckMatterAccess(TOD:MatterID)  ! ADDED 8/11/2010
                                     MESSAGE('Unable to Delete this Reminder.||You do not have Access rights to this Matter|','Access Denied',ICON:Exclamation)
                                     BREAK
                                  END
            
                                  DELETE(ToDoNote)
                 
                                  PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL(TOD:Description) & ''',0,''ToDoNote'',3,' & CEM:RecordID & ',' & TOD:RecordID & ',(SELECT FileRef FROM Matter WHERE RecordID = ' & TOD:MatterID & '),''' & GlobalErrors.GetProcedureName() & '''','FileManager - Delete Reminder in Desktop')
                 
                                  YIELD# += 1; IF ~YIELD# % 10 THEN YIELD.
            
                                  IF CEM:SynchroniseTasksWithRemindersFlag AND TOD:OutLookTaskID
                                     UpdateOutLookTaskFromReminder(3) ! DELETE THE TASK FROM OUTLOOK
                                  END
                                  
                                  IF CEM:SynchroniseAppointmentsWithRemindersFlag AND TOD:OutLookAppointmentID
                                     UpdateOutLookAppointmentFromReminder(3) ! DELETE THE Appointment FROM OUTLOOK
                                  END
      
                                  If LOC:FilteredReminders > 0 Then LOC:FilteredReminders -= 1.
      
                            END
            
            
                         END
                         ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
                         DISPLAY
                         TOD:RecordID = NxtTag:PtrM(Tag:ToDoNote)                ! SET TO NEXT ToDoNote
                         IF ~TOD:RecordID THEN BREAK.
                    END
      
                    CLOSE(ProgressWindow)
      
                    DO BRW15::UntagAll
      
                    IF CEM:ProgressIndicatorFlag = 'C' AND LOC:ShowMatterIconsFlag  ! UPDATE THE PROGRESS ICON.
                       BRW54.ApplyFilter
                       BRW54.ResetFromBuffer
                    END
      
                    DISPLAY(?LOC:FilteredReminders)
      
      
                    CLEAR(TOD:Record)
                    DO RefreshToDoNoteBrowse
      
                    SELECT(?ToDoNoteBrowse,CHOICE(?ToDoNoteBrowse))
      
                 END
            
              ELSE
            
                 IF CheckMatterAccess(TOD:MatterID)  ! ADDED 8/11/2010
                    MESSAGE('Unable to Delete this Reminder.||You do not have Access rights to this Matter|','Access Denied',ICON:Exclamation)
                    RETURN LEVEL:Notify
      
      
                 ELSE
      
                    IF MESSAGE('Are you sure you want to Delete this Reminder?|','Confirm Deletion',ICON:Question,BUTTON:OK+BUTTON:Cancel,BUTTON:OK) = BUTTON:OK
      
      
                       PROPSQL('DELETE ToDoNote WHERE RecordID = ' & TOD:RecordID)
                       PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL(TOD:Description) & ''',0,''ToDoNote'',3,' & CEM:RecordID & ',' & TOD:RecordID & ',''' & MAT1:FileRef & ''',''Delete Reminder''','Deleted Reminder in Desktop')
      
      
                       IF CEM:SynchroniseTasksWithRemindersFlag AND TOD:OutLookTaskID
                          UpdateOutLookTaskFromReminder(3) ! DELETE THE TASK FROM OUTLOOK
                       END
                       
                       IF CEM:SynchroniseAppointmentsWithRemindersFlag AND TOD:OutLookAppointmentID
                          UpdateOutLookAppointmentFromReminder(3) ! DELETE THE Appointment FROM OUTLOOK
                       END
      
                       FLUSH(BRW15.View)
                       DELETE(Queue:Browse:3)
                       BRW15.ResetQueue(Reset:Queue)
      
                       IF CEM:ProgressIndicatorFlag = 'C' AND LOC:ShowMatterIconsFlag  ! UPDATE THE PROGRESS ICON.
                          BRW54.ApplyFilter
                          BRW54.ResetFromBuffer
                       END
      
                       If LOC:FilteredReminders > 0 Then LOC:FilteredReminders -= 1.
      
      
                       DISPLAY(?LOC:FilteredReminders)
      
      
      
                    END
      
      
      
                 END
            
            
              END
      
              RETURN(LEVEL:Notify)
      
      
    OF ?TagOne:4
      ThisWindow.Update
      DO BRW15::TagOne
    OF ?UntagOne:4
      ThisWindow.Update
      DO BRW15::UntagOne
    OF ?TagAll:4
      ThisWindow.Update
      DO BRW15::TagAll
    OF ?UntagAll:4
      ThisWindow.Update
      DO BRW15::UntagAll
    OF ?ReloadPlanOfActionButton
      ThisWindow.Update
      CLEAR(MAT1:Record)
      ThisWindow.Update
      
      IF LOC:TOD_Matter = 'Current'
      
        LOC:MAT:RecordID = LOC:CurrentMatterID
      
      ELSE
      
        IF MAT1:RecordID
           LOC:MAT:RecordID = GetMatterID(MAT1:RecordID)
        ELSE
           IF ~SAV:LastMatterID THEN SAV:LastMatterID = LOC:CurrentMatterID.
           LOC:MAT:RecordID = GetMatterID(SAV:LastMatterID)
         END
      
      END
      IF ~LOC:MAT:RecordID THEN CYCLE.
      
      
      MAT:RecordID = LOC:MAT:RecordID
      IF ~Access:Matter.Fetch(MAT:PrimaryKey)
          IF MAT:ToDoGroupID
             IF MESSAGE('Are you sure you want to reload the Plan of Action for this Matter (' & MAT:FileRef & ')?||All existing entries (that were created by the original Plan of Action) will be completely overwritten.','Reload Plan of Action',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:Yes
                ToDoNote{PROP:SQL} = 'Delete ToDoNote Where ToDoItemID > 0 AND MatterID = ' & MAT:RecordID
                SetMatterPlanOfAction(MAT:RecordID,MAT:ToDoGroupID)
                DO RefreshToDoNoteBrowse
             END
          ELSE
             MESSAGE('This Matter (' & MAT:FileRef & ') has no Plan of Action specified','No Plan of Action',ICON:Exclamation)
          END
          SELECT(?ToDoNoteBrowse)
      END
      
    OF ?TOD:OptFilterButton
      ThisWindow.Update
      IF BRW15::Filter
        ?TOD:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
        BRW15::Filter = 0
      ELSE
        ?TOD:OptFilterButton{PROP:Text} = 'Sho&w All'
        BRW15::Filter = 1
      END!IF
      SELECT(?ToDoNoteBrowse)
      ThisWindow.Reset
      ?ToDoNoteBrowse{PROP:VScroll} = CHOOSE(RECORDS(Queue:Browse:3) = ?ToDoNoteBrowse{PROP:Items}, True, False)
      POST(EVENT:ScrollTop,?ToDoNoteBrowse)

    OF ?MoveReminderUp
      ThisWindow.Update
      ! FURBURGER
      GET(Queue:Browse:3,POINTER(Queue:Browse:3)-1)
      IF ~Access:ToDoNote.Fetch(TOD:PrimaryKey)
          IF TOD:Date <> Queue:Browse:3.TOD:Date - 1
             TOD:Date = Queue:Browse:3.TOD:Date - 1
             IF ~Access:ToDoNote.TryUpdate()
      
                 BRW15.ResetFromBuffer
                 BRW15.PostNewSelection
      
                 CheckIfCriticalStepChanged
      
             END
          END
      END
      
    OF ?MoveReminderDown
      ThisWindow.Update
      GET(Queue:Browse:3,POINTER(Queue:Browse:3)+1)
      IF ~Access:ToDoNote.Fetch(TOD:PrimaryKey)
          IF TOD:Date <> Queue:Browse:3.TOD:Date + 1
             TOD:Date = Queue:Browse:3.TOD:Date + 1
             IF ~Access:ToDoNote.TryUpdate()
      
                 BRW15.ResetFromBuffer
                 BRW15.PostNewSelection
      
                 CheckIfCriticalStepChanged
      
             END
          END
      END
      
    OF ?SelectActivityButton
      ThisWindow.Update
      IF ~SAV:LastMatterID THEN SAV:LastMatterID = MA:MatterID.
      CLEAR(MA:Record)
      IF LOC:MA_Matter = 'Current'
         MA:MatterID = LOC:CurrentMatterID
      ELSE
         MA:MatterID = GetMatterID(SAV:LastMatterID)
      END
      IF ~MA:MatterID Then Cycle.
      
      SAV:LastMatterID = MA:MatterID
      
      GlobalRequest = SelectRecord
      BrowseActivity
      IF GlobalResponse = RequestCompleted
         DO AddTimedRecords
      END
      SELECT(?TimeRecordingBrowse)
    OF ?TimeaFeeButton
      ThisWindow.Update
     GLO:MatterID = MAT:RecordID

!     MESSAGE('GLO:TimerScreenThread = ' & GLO:TimerScreenThread)
!
     IF GLO:TimerScreenThread
        POST(EVENT:Iconize,,GLO:TimerScreenThread)
     END

     GLO:TimerScreenThread = START(GetStopWatchTime1)
     


    OF ?MatterEmployeesButton:2
      ThisWindow.Update
      IF LOC:MA_Matter = 'Current'
         MA:MatterID =  LOC:CurrentMatterID
      ELSIF ~RECORDS(Queue:Browse:5)
         MA:MatterID = GetMatterID(SAV:LastMatterID)
      END
      IF MA:MatterID
         MAT:RecordID = MA:MatterID
         Access:Matter.TryFetch(MAT:PrimaryKey)
         BrowseMatEmployee
      END
      SELECT(?TimeRecordingBrowse)
    OF ?MatActivJumpToMatterButton
      ThisWindow.Update
        SELECT(?MattersBrowse)
        LOC:JumpToRecordID = MA:MatterID
        POST(EVENT:JumpToMatter)
        SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
    OF ?LOC:MA_Activity
        Get(MA_Activity:Queue,Choice())
        LOC:MA_ActivityID = ACTQ:RecordID
    OF ?LOC:MA_Employee
        Get(MA_Employee:Queue,Choice())
        GLO:MA_EmployeeID = MAQ:RecordID
    OF ?LOC:MA_CostCentre
          Get(MA_CostCentre:Queue,Choice())
          GLO:MA_CostCentreID = MACCQ:RecordID
      
    OF ?RefreshTimeRecordsButton
      ThisWindow.Update
      ! 08/06/2016 PK Naidoo - Added a Refresh Button for the Timed Records browse
      !BRW22.ResetQueue(RESET:Done)
      
      
            ! 25/06/2018 PK Naidoo: FB Case 1653
            BRW22.ResetSort(1)
      
            Select(?TimeRecordingBrowse)
    OF ?ExportMatActivButton
      ThisWindow.Update
      If GetReportEmp(TAG:MatActiv,2) Then Cycle.
      If FstTag:PtrM(TAG:MatActiv)
        REE:MatActivOption = 2
      .
      If LOC:MA_FromDate or LOC:MA_ToDate
        REE:TransactionDateOption = 1
        REE:FromTransactionDate = LOC:MA_FromDate
        REE:ToTransactionDate = LOC:MA_ToDate
      .
      Case LOC:MA_Matter
      Of 'Current'
        REE:MatterOption = 1
        REE:MatterId = LOC:CurrentMatterID
      Of 'Tagged'
        REE:MatterOption = 2
      .
      
      IF LOC:MA_ActivityID > 0
        REE:CustomOption = 1
        REE:Custom = Choose(~~REE:Custom, REE:Custom & ' and ','') & 'MA.ActivityID = ' & LOC:MA_ActivityID
      .
      
      If GLO:MA_EmployeeID > 0
        REE:CustomOption = 1
        REE:Custom = Choose(~~REE:Custom, REE:Custom & ' and ','') & 'MA:EmployeeID = ' & GLO:MA_EmployeeID
      .
      If Access:ReportEmp.Update() Then Cycle.
      START(ExportXML, 25000, TAG:MatActiv)
    OF ?TagOne:5
      ThisWindow.Update
      DO BRW22::TagOne
    OF ?Delete:6
      ThisWindow.Update
      Clear(SP:Record)
      SP:SecGroupId = GLO:SecGroupId
      SP:AccessFlag = GLO:SupervisorFlag
      SP:Description = 'Matters - Desktop - Time Records - Update - Delete'
      
      
      !message('1 SP:Description = ' & SP:Description & ' SP:AccessFlag = ' & SP:AccessFlag  & ' GLO:SupervisorFlag = ' & GLO:SupervisorFlag)
      
      
      IF Access:SecProc.TryFetch(SP:SecGroupKey)
      
      
      Access:SecProc.Insert()
      
      !message('2 Not found - added. SP:Description = ' & SP:Description & ' SP:AccessFlag = ' & SP:AccessFlag  & ' GLO:SupervisorFlag = ' & GLO:SupervisorFlag)
      
      END
      
      If ~SP:AccessFlag and ~GLO:SupervisorFlag
      Message('Access Denied||Your security settings do not allow you access to this area of the program.|',SP:Description,'~lock.ico')
      Return Level:Notify
      .
      
      
      
              IF FstTag:PtrM(TAG:MatActiv)
      
                 IF MESSAGE('There are ' & CntTag:PtrM(TAG:MatActiv) & ' Time Records tagged.||Do you want to Delete the Tagged Time Records?','Deleting Time Records',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:Yes
                    OPEN(ProgressWindow)
                    ProgressWindow{PROP:Text} = 'Deleting Time Records'
                    ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:MatActiv)
                    CLEAR(MA:Record)
                    MA:RecordID = FstTag:PtrM(TAG:MatActiv)                ! SET TO THE FIRST TAGGED FileNote
                    LOOP 
                         IF ~Access:MatActiv.TryFetch(MA:PrimaryKey)
      
                             LOOP 1 TIMES
      
                                  IF CheckMatterAccess(MA:MatterID)
                                     MESSAGE('Unable to Delete this Time Record (' & MA:Description & ').||You do not have Access rights to this Matter|','Access Denied',ICON:Exclamation)
                                     BREAK
                                  END
            
      
                                  IF MA:FeeNoteID
                                     PROPSQLNext('SELECT PostedFlag FROM FeeNote WHERE RecordID = ' & MA:FeeNoteID)
                                     IF ROW:Counter
                                        MESSAGE('A Fee Note was created from this Time Record (' & MA:Description & ')|and it has been posted to Accounting.||It cannot be deleted.','Access Denied',ICON:Exclamation)
                                        Break
                                     END
                                  END
      
                                  !FB579 - Kelvin 13-feb-2017
                                  PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL(MA:Description) & ''','& MA:BillableAmount &',''MatActiv'',3,' & CEM:RecordID & ',' & MA:RecordID & ',(SELECT FileRef FROM Matter WHERE RecordID = ' & MA:MatterID & '),''UpdateMatActiv''','FileManager - Delete Time Record in Desktop')
                                  !FB579 - Kelvin 13-feb-2017
                                  DELETE(MatActiv)
                                  
                 
                                  YIELD# += 1; IF ~YIELD# % 10 THEN YIELD.
      
                             END
      
                         END
                         ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
                         DISPLAY
                         MA:RecordID = NxtTag:PtrM(TAG:MatActiv)                ! SET TO NEXT FileNote
                         IF ~MA:RecordID THEN BREAK.
                    END
                    CLOSE(ProgressWindow)
                    DO BRW22::UntagAll
                    CLEAR(MA:Record)
                    DO RefreshMatActivBrowse
                    SELECT(?TimeRecordingBrowse,CHOICE(?TimeRecordingBrowse))
                 END
      
              ELSE
            
                 IF CheckMatterAccess(MA:MatterID)  
                    MESSAGE('Unable to Delete this Time Record.||You do not have Access rights to this Matter|','Access Denied',ICON:Exclamation)
                    RETURN LEVEL:Notify
                 END
      
                 IF MA:FeeNoteID AND FN1:PostedFlag
                    MESSAGE('A Fee Note was created from this Time Record and it has been posted to Accounting.||It cannot be deleted.','Deleting a Time Record',ICON:Exclamation)
                    RETURN(LEVEL:Notify)
                 END
      
      
                 IF MESSAGE('Are you sure you want to delete this Time Record?','Delete',ICON:Question,BUTTON:OK+BUTTON:Cancel,BUTTON:OK) = BUTTON:OK
                    !Commented out by Kelvin - 19 - 10 -2016 - as per Jennifer FB 396 - Fee note was not deleted when timerecord was tagged, so matched this to that
                    !IF MA:FeeNoteID
                       !FN:RecordID = MA:FeeNoteID
                       !IF ~Access:FeeNote.Fetch(FN:PrimaryKey)
                           !PROPSQL('DELETE FeeNote WHERE RecordID = ' & MA:FeeNoteID)
                       !    PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL(FN:Description) & ''',0,''FeeNote'',3,' & CEM:RecordID & ',' & FN:RecordID & ',(SELECT FileRef FROM Matter WHERE RecordID = ' & FN:MatterID & '),''' & GlobalErrors.GetProcedureName() & '''','Delete Time Record in Desktop')
                       !END
                    !END
                    !FB579 - Kelvin 13-feb-2017
                    PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL(MA:Description) & ''','& MA:BillableAmount &',''MatActiv'',3,' & CEM:RecordID & ',' & MA:RecordID & ',(SELECT FileRef FROM Matter WHERE RecordID = ' & MA:MatterID & '),''UpdateMatActiv''','FileManager - Delete Time Record in Desktop')
                    !FB579 - Kelvin 13-feb-2017
      
                    PROPSQL('DELETE MatActiv WHERE RecordID = ' & MA:RecordID)
      
                    FLUSH(BRW22.View)
                    DELETE(Queue:Browse:4)
                    BRW22.ResetQueue(Reset:Queue)
      
      
                 END
      
      
      
              END
      
              RETURN(LEVEL:Notify)
      
      
    OF ?CreateFeeNotesFromMAButton
      ThisWindow.Update
      DO CreateFeeNotesFromTaggedMA
    OF ?UntagOne:5
      ThisWindow.Update
      DO BRW22::UntagOne
    OF ?ChangeBillingRateButton
      ThisWindow.Update
        GlobalRequest = SelectRecord
        BrowseBillingRate
        IF GlobalResponse = RequestCompleted
          DO UpdateBillingRate
        End
    OF ?TagAll:5
      ThisWindow.Update
      DO BRW22::TagAll
    OF ?UntagAll:5
      ThisWindow.Update
      DO BRW22::UntagAll
    OF ?MA:OptFilterButton
      ThisWindow.Update
      IF BRW22::Filter
        ?MA:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
        BRW22::Filter = 0
      ELSE
        ?MA:OptFilterButton{PROP:Text} = 'Sho&w All'
        BRW22::Filter = 1
      END!IF
      SELECT(?TimeRecordingBrowse)
      ThisWindow.Reset
      ?TimeRecordingBrowse{PROP:VScroll} = CHOOSE(RECORDS(Queue:Browse:5) = ?TimeRecordingBrowse{PROP:Items}, True, False)
      POST(EVENT:ScrollTop,?TimeRecordingBrowse)

    OF ?ViewDatalinkXML
      ThisWindow.Update
      GLO:TestFileName = GetRoot(MME:FileName)
      IF GLO:TestFileName
        SHELL:AssocFile     =    GLO:TestFileName
        SHELL:Param         =    ''
        SHELL:Directory     =    ''
        SHELL:Operation     =    'open'
        ShellExecute(GetDesktopWindow(),SHELL:Operation,SHELL:AssocFile,SHELL:Param,SHELL:Directory,1)
      END
    OF ?SetupDataLinkButton
      ThisWindow.Update
      BrowseDataLinkSetup
      ThisWindow.Reset
    OF ?ViewDatalinkXMLFolder
      ThisWindow.Update
            IF CEM:DataLinkBranchID
               BRA:RecordID = CEM:DataLinkBranchID
               IF ~Access:Branch.Fetch(BRA:PrimaryKey)
                  IF BRA:DataLinkSavedLocation
                     
                     ! 05/05/2016 Sameer: Use ShellExecute to open the folder instead
                     !RUN('EXPLORER.EXE /e,/select,' & GetRoot(BRA:DataLinkSavedLocation))
                     SHELL:AssocFile = GetRoot(BRA:DataLinkSavedLocation)
                     SHELL:Operation = 'open'
                     SHELL:Param     = ''
                     SHELL:Directory = ''
              
                     ShellExecute(GetDesktopWindow(),SHELL:Operation,SHELL:AssocFile,SHELL:Param,SHELL:Directory,1)
      
                     If ErrorCode()
                        Message(Error() & '||Error running program EXPLORER.EXE||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                     End
                  END
               END
      
            ELSE
               GlobalRequest = SelectRecord
               BrowseBranch
               IF GlobalResponse = RequestCompleted
                  IF BRA:RecordID
                     CEM:DataLinkBranchID = BRA:RecordID
                     PropSQL('UPDATE Employee SET DataLinkBranchID = ' & BRA:RecordID & ' WHERE RecordID = ' & CEM:RecordID)
      
                     IF ~Access:Branch.Fetch(BRA:PrimaryKey)
                         IF BRA:DataLinkSavedLocation
      
                            ! 05/05/2016 Sameer: Use ShellExecute to open the folder instead
                            !RUN('EXPLORER.EXE /e,/select,' & GetRoot(BRA:DataLinkSavedLocation))
                            SHELL:AssocFile = GetRoot(BRA:DataLinkSavedLocation)
                            SHELL:Operation = 'open'
                            SHELL:Param     = ''
                            SHELL:Directory = ''
                     
                            ShellExecute(GetDesktopWindow(),SHELL:Operation,SHELL:AssocFile,SHELL:Param,SHELL:Directory,1)
      
                            If ErrorCode()
                               Message(Error() & '||Error running program EXPLORER.EXE||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                            End
                         END
                     END
                  END
               END
            END
    OF ?ExportDataLinkButton
      ThisWindow.Update
      If GetReportEmp(TAG:LAWMatterMessage,2) Then Cycle.
      If FstTag:PtrM(TAG:LAWMatterMessage)
        REE:LAWMatterMessageOption = 2
      .
      If LOC:DAT_FromDate or LOC:DAT_ToDate
        REE:TransactionDateOption = 1
        REE:FromTransactionDate = LOC:DAT_FromDate
        REE:ToTransactionDate = LOC:DAT_ToDate
      .
      
      
      Case LOC:DAT_Matter
      Of 'Current'
        REE:MatterOption = 1
        REE:MatterId = LOC:CurrentMatterID
      Of 'Tagged'
        REE:MatterOption = 2
      .
      
      If Access:ReportEmp.Update() Then Cycle.
      START(ExportXML, 25000, TAG:LAWMatterMessage)
      
    OF ?Insert:4
      ThisWindow.Update
      POST(Event:Accepted,?SendXMLMessageButton)
      Return Level:Notify
    OF ?Change:4
      ThisWindow.Update
      !26/2/2010 - commented this out and add UpdateLawMatterMessage to allow them to change the filename of the actual data file
      ! they can still viewtheXML from the ?ViewDatalinkXML button
      
      !POST(Event:Accepted,?ViewDatalinkXML)
      !Return Level:Notify
    OF ?Delete:4
      ThisWindow.Update
      
                  Clear(SP:Record)
                  SP:SecGroupId = GLO:SecGroupId
                  SP:AccessFlag = 0 ! DON'T ALLOW THEM IN INITIALLY UNLESS THEY ARE SUPERVISOR
                  SP:Description = 'Datalink Messages - Delete'
                  IF Access:SecProc.TryFetch(SP:SecGroupKey)
                     Access:SecProc.Insert()
                  END
                  If ~SP:AccessFlag and ~GLO:SupervisorFlag
                      Message('You do not have sufficient rights to delete DataLink Messages.','Access Denied','~lock.ico')
                      Return Level:Notify
              
                  END
            
                  LOC:DeleteResponse = 0
      
                  IF FstTag:PtrM(TAG:LawMatterMessage)
      
                     IF MESSAGE('There are ' & CntTag:PtrM(TAG:LawMatterMessage) & ' items tagged.||Do you want to Delete all the Tagged Items?','Deleting DataLink Messages',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:Yes
                        OPEN(ProgressWindow)
                        ProgressWindow{PROP:Text} = 'Deleting multiple items'
                        ?ProgressBar{PROP:RangeHigh} = CntTag:PtrM(TAG:LawMatterMessage)
                        CLEAR(MME:Record)
                        MME:RecordID = FstTag:PtrM(Tag:LawMatterMessage)                ! SET TO THE FIRST TAGGED LawMatterMessage
                        LOOP 
                             IF ~Access:LawMatterMessage.TryFetch(MME:PrimaryKey)
                                 SAV:MME:FileName = GetRoot(MME:FileName)
                                 DO RemoveXMLMessage
                                 IF LOC:DeleteResponse = 4 THEN BREAK.         ! USER CANCELLED
                                 DELETE(LawMatterMessage)
                             END
                             ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1
                             DISPLAY
                             MME:RecordID = NxtTag:PtrM(Tag:LawMatterMessage)                ! SET TO NEXT LawMatterMessage
                             IF ~MME:RecordID THEN BREAK.
                        END
                        NewTag:PtrM(TAG:LawMatterMessage)
                        CLOSE(ProgressWindow)
                        CLEAR(MME:Record)
                        DO RefreshDataLinkBrowse
                        SELECT(?LawMatterMessageBrowse,CHOICE(?LawMatterMessageBrowse))
                     END
      
                 ELSE
      
                    IF MESSAGE('Do you want to Delete this DataLink Message?','Deleting Message',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:Yes
      
                       SAV:MME:FileName = GetRoot(MME:FileName)
                       DO RemoveXMLMessage
                       IF LOC:DeleteResponse <>  4
                          DELETE(LawMatterMessage)
                          CLEAR(MME:Record)
                          DO RefreshDataLinkBrowse
                       END
                       SELECT(?LawMatterMessageBrowse,CHOICE(?LawMatterMessageBrowse))
      
                    END
      
                 END
      
                 RETURN(LEVEL:Notify)
      
      
    OF ?TagOne:6
      ThisWindow.Update
      DO BRW36::TagOne
    OF ?UntagOne:6
      ThisWindow.Update
      DO BRW36::UntagOne
    OF ?TagAll:6
      ThisWindow.Update
      DO BRW36::TagAll
    OF ?UntagAll:6
      ThisWindow.Update
      DO BRW36::UntagAll
    OF ?MME:OptFilterButton
      ThisWindow.Update
      IF BRW36::Filter
        ?MME:OptFilterButton{PROP:Text} = 'Sho&w Tagged'
        BRW36::Filter = 0
      ELSE
        ?MME:OptFilterButton{PROP:Text} = 'Sho&w All'
        BRW36::Filter = 1
      END!IF
      SELECT(?LawMatterMessageBrowse)
      ThisWindow.Reset
      ?LawMatterMessageBrowse{PROP:VScroll} = CHOOSE(RECORDS(Queue:Browse:2) = ?LawMatterMessageBrowse{PROP:Items}, True, False)
      POST(EVENT:ScrollTop,?LawMatterMessageBrowse)
      
    OF ?DocumentLogButton:2
      ThisWindow.Update
      IF RestrictedMatter(MAT:RecordID,0) THEN CYCLE.
      
      GLO:MatterID = MAT:RecordID
      AddToFavourites(MAT:RecordID)
      BrowseDocLog
      GLO:MatterID = 0
      SELECT(?ABSALinkBrowse)
      
    OF ?STDOnlineDocument
      ThisWindow.Update
      DO LoadOnlineDocs
    OF ?Internet
      ThisWindow.Update
      ! SHELL:AssocFile='www.lawactive.co.za'
      ! SHELL:AssocFile='www.lawproperty.co.za'
       SHELL:AssocFile='www.e4.co.za'
       SHELL:Param=''; SHELL:Directory='';SHELL:Operation='open'
       ShellExecute(GetDesktopWindow(),SHELL:Operation,SHELL:AssocFile,SHELL:Param,SHELL:Directory,1)
    OF ?InternetNew
      ThisWindow.Update
      ! SHELL:AssocFile='http://www.ficacard.co.za/LawComplianceStaging/Views/Compliance/Default.aspx'
       SHELL:AssocFile='www.lawcompliance.co.za'
       SHELL:Param=''; SHELL:Directory='';SHELL:Operation='open'
       ShellExecute(GetDesktopWindow(),SHELL:Operation,SHELL:AssocFile,SHELL:Param,SHELL:Directory,1)
      
    OF ?Print:4
      ThisWindow.Update
      SetCursor(CURSOR:Wait)
      PUSHBIND
      BIND('ABMM:Date',ABMM:Date)
      BIND('ABMM:Time',ABMM:Time)
      BIND('MAT1:FileRef',MAT1:FileRef)
      BIND('MAT1:Description',MAT1:Description)
      BIND('LOC:Branch',LOC:Branch)
      BIND('DG1:Code',DG1:Code)
      BIND('LOC:Employee',LOC:Employee)
      BIND('ABMM:MessageNumber',ABMM:MessageNumber)
      BIND('ABMM:MessageDescription',ABMM:MessageDescription)
      BIND('ABMM:MessageDirection',ABMM:MessageDirection)
      BIND('ABMM:Details',ABMM:Details)
      If CEM:PrintXMLFlag
        PrintXMLInit(QuickWindow{PROP:Text})
      
        PrintXMLAddField('Date','ABMM:Date',0,0,0,'@d17b',0,'')
        PrintXMLAddField('Time','ABMM:Time',0,0,0,'@t3',0,'')
        PrintXMLAddField('File Ref','MAT1:FileRef',0,0,0,'@s49',0,'')
        PrintXMLAddField('Matter','MAT1:Description',0,0,0,'@s199',0,'')
        PrintXMLAddField('Branch','LOC:Branch',0,0,0,'@s19',0,'')
        PrintXMLAddField('Bank','DG1:Code',0,0,0,'@s5',0,'')
        PrintXMLAddField('Sent/Received By','LOC:Employee',0,0,0,'@s50',0,'')
        PrintXMLAddField('No','ABMM:MessageNumber',3,0,0,'@n_5',0,'')
        PrintXMLAddField('Message Description','ABMM:MessageDescription',0,0,0,'@s100',0,'')
        PrintXMLAddField('To/From','ABMM:MessageDirection',0,0,0,'@s10',0,'')
        PrintXMLAddField('Details','ABMM:Details',0,0,0,'@s255',0,'')
      Else
        Free(SSQueue:58)
        a# = 1
        Loop
          Clear(SSQueue:58)
          Execute a#
            Begin
              SkipThisColumn# = False
              SSQ:58:FieldName    = 'ABMM:Date'
              SSQ:58:Heading      = 'Date'
              SSQ:58:Picture      = '@d17b'
            .
            Begin
              SkipThisColumn# = False
              SSQ:58:FieldName    = 'ABMM:Time'
              SSQ:58:Heading      = 'Time'
              SSQ:58:Picture      = '@t3'
            .
            Begin
              SkipThisColumn# = False
              SSQ:58:FieldName    = 'MAT1:FileRef'
              SSQ:58:Heading      = 'File Ref'
              SSQ:58:Picture      = '@s49'
            .
            Begin
              SkipThisColumn# = False
              SSQ:58:FieldName    = 'MAT1:Description'
              SSQ:58:Heading      = 'Matter'
              SSQ:58:Picture      = '@s199'
            .
            Begin
              SkipThisColumn# = False
              SSQ:58:FieldName    = 'LOC:Branch'
              SSQ:58:Heading      = 'Branch'
              SSQ:58:Picture      = '@s19'
            .
            Begin
              SkipThisColumn# = False
              SSQ:58:FieldName    = 'DG1:Code'
              SSQ:58:Heading      = 'Bank'
              SSQ:58:Picture      = '@s5'
            .
            Begin
              SkipThisColumn# = False
              SSQ:58:FieldName    = 'LOC:Employee'
              SSQ:58:Heading      = 'Sent/Received By'
              SSQ:58:Picture      = '@s50'
            .
            Begin
              SkipThisColumn# = False
              SSQ:58:FieldName    = 'ABMM:MessageNumber'
              SSQ:58:Heading      = 'No'
              SSQ:58:Picture      = '@n_5'
              SSQ:58:AlignH       = 5
            .
            Begin
              SkipThisColumn# = False
              SSQ:58:FieldName    = 'ABMM:MessageDescription'
              SSQ:58:Heading      = 'Message Description'
              SSQ:58:Picture      = '@s100'
            .
            Begin
              SkipThisColumn# = False
              SSQ:58:FieldName    = 'ABMM:MessageDirection'
              SSQ:58:Heading      = 'To/From'
              SSQ:58:Picture      = '@s10'
            .
            Begin
              SkipThisColumn# = False
              SSQ:58:FieldName    = 'ABMM:Details'
              SSQ:58:Heading      = 'Details'
              SSQ:58:Picture      = '@s255'
            .
          .
          SSQ:58:FieldNo = a#
          If ~SkipThisColumn# Then Add(SSQueue:58,SSQ:58:FieldNo).
          If a# = 11 Then Break.
          a# +=1
        .
        Open(SSWindow:58)
        SSWindow:58{PROP:Text} = 'Print ' & QuickWindow{PROP:Text}
        SSWindow:58{PROP:Maximize} = True
        ?SSOle:58{PROP:Create} = 'TTF161.TTF1.6'
        If ~?SSOle:58{PROP:Ole}
          Message('Spreadsheet OCX Not Registered, Press OK To Register','',ICON:Asterisk)
          RUN('regsvr32 ttf16.ocx')
          ?SSOle:58{PROP:Create} = 'TTF161.TTF1.6'
          If ~?SSOle:58{PROP:Ole}
            Close(SSWindow:58)
            Message('The Spreadsheet OCX cannot be registered, try registering it at the DOS prompt by typing "regsvr32 ttf16.ocx"','',ICON:Hand)
            SetCursor
            Cycle
          .
        .
      
        ?SSOle:58{'Row'} = 1
        Loop a# = 1 to Records(SSQueue:58)
          Get(SSQueue:58,a#)
          ?SSOle:58{'Col'} = a#
          ?SSOle:58{'Entry'} = SSQ:58:Heading
          ?SSOle:58{'FontBold'} = 1
          ?SSOle:58{'FontUnderline'} = 1
          If SSQ:58:AlignH Then ?SSOle:58{'HAlign'} = SSQ:58:AlignH-1.
          If SSQ:58:AlignV Then ?SSOle:58{'HAlign'} = SSQ:58:AlignV-1.
        .
      
        LOC:SSRow:58 = 2
      .
      Set(BRW35::View:Browse)
      Loop
        Next(BRW35::View:Browse)
        If Errorcode() = 33 Then Break.
        If Errorcode()
          Message('Error Reading Data|Error :' & Error(),'Print',ICON:Exclamation)
          Break
        .
        If BRW35.ValidateRecord() Then Cycle.
        BRW35.SetQueueRecord
        If CEM:PrintXMLFlag
          PrintXMLAddData
        Else
          LOC:SSRow:58 += 1
          ?SSOle:58{'Row'} = LOC:SSRow:58
          Loop a# = 1 to Records(SSQueue:58)
            Get(SSQueue:58,a#)
            ?SSOle:58{'Col'} = a#
            ?SSOle:58{'Entry'} = Clip(Left(Format(Evaluate(SSQ:58:FieldName),SSQ:58:Picture)))
            Execute SSQ:58:FormatType - 1
              ?SSOle:58{'FormatCurrency2'}
              ?SSOle:58{'FormatCurrency'}
              ?SSOle:58{'FormatFixed2'}
              ?SSOle:58{'FormatFixed'}
              ?SSOle:58{'FormatPercent'}
              ?SSOle:58{'Entry'} = Format(?SSOle:58{'Entry'},@d17b)
              ?SSOle:58{'Entry'} = Format(?SSOle:58{'Entry'},@t7b)
              ?SSOle:58{'NumberFormat'} = '@'
              ?SSOle:58{'NumberFormat'} = SSQ:58:FormatString
            .
            If SSQ:58:AlignH Then ?SSOle:58{'HAlign'} = SSQ:58:AlignH-1.
            If SSQ:58:AlignV Then ?SSOle:58{'HAlign'} = SSQ:58:AlignV-1.
            ?SSOle:58{'WordWrap'} = 1
          .
        .
      End
      If CEM:PrintXMLFlag
        PrintXMLRun
        POPBIND
        SetCursor
      Else
        LOOP LOC:SSCol:58 = 1 TO RECORDS(SSQueue:58)
          Get(SSQueue:58,LOC:SSCol:58)
          If SSQ:58:ColumnWidth
            ?SSOle:58{'ColWidth(' & LOC:SSCol:58 & ')'} = SSQ:58:ColumnWidth * 256
          Else
            ?SSOle:58{'SetColWidthAuto(1,' & LOC:SSCol:58 & ',' & LOC:SSRow:58 & ',' & LOC:SSCol:58 & ',0)'}
          .
          If SSQ:58:TotalOption > 1
            ?SSOle:58{'Row'} = LOC:SSRow:58 + 1
            ?SSOle:58{'Col'} = LOC:SSCol:58
            ?SSOle:58{'SetBorder(-1,-1,-1,1,6,0,0,0,0,0,0)'}
            Execute SSQ:58:TotalOption - 1
              ?SSOle:58{'Entry'} = '=Sum(' & Chr(64 + LOC:SSCol:58) & '2:' & Chr(64 + LOC:SSCol:58) & LOC:SSRow:58 & ')'
              ?SSOle:58{'Entry'} = '=CountA(' & Chr(64 + LOC:SSCol:58) & '2:' & Chr(64 + LOC:SSCol:58) & LOC:SSRow:58 & ')'
              ?SSOle:58{'Entry'} = '=Average(' & Chr(64 + LOC:SSCol:58) & '2:' & Chr(64 + LOC:SSCol:58) & LOC:SSRow:58 & ')'
            .
            Execute SSQ:58:FormatType - 1
              ?SSOle:58{'FormatCurrency2'}
              ?SSOle:58{'FormatCurrency'}
              ?SSOle:58{'FormatFixed2'}
              ?SSOle:58{'FormatFixed'}
              ?SSOle:58{'FormatPercent'}
              ?SSOle:58{'Entry'} = Format(?SSOle:58{'Entry'},@d17b)
              ?SSOle:58{'Entry'} = Format(?SSOle:58{'Entry'},@t7b)
              z# = 1 ! Dummy Filler
              ?SSOle:58{'NumberFormat'} = SSQ:58:FormatString
            .
            If SSQ:58:AlignH Then ?SSOle:58{'HAlign'} = SSQ:58:AlignH-1.
            If SSQ:58:AlignV Then ?SSOle:58{'HAlign'} = SSQ:58:AlignV-1.
          .
        .
        LOC:PageSetup58 = ?SSOle:58{'GetPageSetup'}
        ?SSOle:58{LOC:PageSetup58 & '.PaperSize'} = 9
        ?SSOle:58{'SetPageSetup(' & LOC:PageSetup58 & ')'}
        ?SSOle:58{'PrintScaleFitToPage'} = True
        ?SSOle:58{'PrintScaleFitHPages'} = 1
        ?SSOle:58{'PrintScaleFitVPages'} = 16384
        ?SSOle:58{'PrintLandscape'} = 0
        ?SSOle:58{'PrintHeader'} = '&C&B&U' & QuickWindow{PROP:Text}
        ?SSOle:58{'PrintGridLines'} = 0
        ?SSOle:58{'ShowVScrollBar'} = 1
        ?SSOle:58{'ShowHScrollBar'} = 1
        ?SSOle:58{PROP:Hide} = False
        ?SSOle:58{'Col'} = 1
        ?SSOle:58{'Row'} = 1
        SetCursor
        Accept
          Case Event()
          Of EVENT:Sized
            ?SSOle:58{PROP:Width}  = SSWindow:58{PROP:Width}
            ?SSOle:58{PROP:Height} = SSWindow:58{PROP:Height} - 19
            ?SSGroup:58{PROP:Width}  = SSWindow:58{PROP:Width} + 5
          Of EVENT:Accepted
            Case Field()
            Of ?SSClose:58
              Break
            Of ?SSExcel:58
              SetCursor(Cursor:Wait)
              LOC:Filename:58 = Path()
              If Sub(LOC:Filename:58,Len(LOC:Filename:58),1) <> '\' Then LOC:Filename:58 = LOC:Filename:58 & '\'.
              LOC:Filename:58 = LOC:Filename:58 & 'Temp\'
              LOC:Filename:58 = LOC:Filename:58 & GLO:LoginId & '.xls'
              ?SSOle:58{'WriteEx("' & LOC:Filename:58 & '",11)'}
              ?OleExcel:58{PROP:Hide} = False
              ExcelObj" = ?OleExcel:58{'Application'}
              If ~ExcelObj" OR ExcelObj" = 'GetPropertyFailed' OR ExcelObj" = 'No ole automation interface'
                ?OleExcel:58{PROP:Create} = 'Excel.Application'
                ExcelObj" = ?OleExcel:58{'Application'}
                If ~ExcelObj"
                  SetCursor
                  Message('Unable to establish an OLE link with the Microsoft Excel program.||Is Excell Installed correctly?','Printing Report',ICON:Exclamation)
                  Cycle
                .
              .
      
              ?OleExcel:58{'ScreenUpdating'} = False
              ?OleExcel:58{'Workbooks.Open(Filename="' & LOC:Filename:58 & '")'}
              If Errorcode()
                SetCursor
                Message('Unable to open file|Filename: ' & LOC:Filename:58 & GLO:LoginId & '.xls' & '|Error: ' & Error(),'Printing Report',ICON:Exclamation)
                Cycle
              .
              ?OleExcel:58{'ActiveSheet.PageSetup.Orientation'} = 2  ! SET TO LANDSCAPE
      
      
      
              ?OleExcel:58{'ScreenUpdating'} = True
              ?OleExcel:58{'Visible'} = -1
              ?OleExcel:58{PROP:Release} = ExcelObj"
              ?OleExcel:58{PROP:Deactivate} = ExcelObj"
              Post(EVENT:Accepted,?SSClose:58)
            Of ?SSPrint:58
              ?SSOle:58{'FilePrint(0)'}
            Of ?SSPreview:58
              ?SSOle:58{'FilePrintPreview'}
            Of ?SSFilePrint:58
              ?SSOle:58{'FilePrint(1)'}
            Of ?SSEdit:58
              SSWindow:58{PROP:Maximize} = True
              ?SSOle:58{'LaunchDesigner'}
              Break
            .
          .
        End
        ?SSOle:58{PROP:Release} = ?SSOle:58{'Application'}
        ?SSOle:58{PROP:Deactivate} = ?SSOle:58{'Application'}
        Destroy(?SSOle:58)
        Destroy(?OleExcel:58)
        Close(SSWindow:58)
        POPBIND
      .
    OF ?Delete:10
      ThisWindow.Update
              IF ABMM:RecordID
                IF ~(GLO:AdministratorPassword = GetUserPassword())
                     MESSAGE('Unable to delete this Message.||You do not have Supervisor Access.|','Access Denied',ICON:Exclamation)
                    RETURN(LEVEL:Notify)
                ELSE
      
                  PropSQL('DELETE ABSA_MatterMessage WHERE RecordID = ' & ABMM:RecordID)
                  CLEAR(ABMM:Record)
                  DO RefreshABSALinkBrowse
                  RETURN(LEVEL:Notify)
                END
              ELSE
                RETURN(LEVEL:Notify)
              END
      
      
    OF ?ABSAMilestoneRulesButton
      ThisWindow.Update
      LOC:WorkFlowDocument = ''
      
      IF LOC:ABSA_DG_Code = 'STD'
         LOC:WorkFlowDocument = 'SBSAWorkflow.PDF'
      ELSIF LOC:ABSA_DG_Code = 'ABSA'
         LOC:WorkFlowDocument = 'ABSAWorkflow.PDF'
      END
      ! 03/07/2015 Sameer: This is now only for Standard Bank
      LOC:WorkflowDocument = 'SBSA Current Workflow.pdf'
      
      IF ~LOC:WorkFlowDocument
      
          IF LOC:ABSA_Matter = 'Current'
            LOC:MAT:RecordID = LOC:CurrentMatterID
      
          ELSE
      
            IF MAT1:RecordID
              LOC:MAT:RecordID = GetMatterID(MAT1:RecordID)
            ELSE
              IF ~SAV:LastMatterID THEN SAV:LastMatterID = LOC:CurrentMatterID.
              LOC:MAT:RecordID = GetMatterID(SAV:LastMatterID)
            END
          END
          
          IF LOC:MAT:RecordID
      
            MAT:RecordID = LOC:MAT:RecordID
            IF ~Access:Matter.Fetch(MAT:PrimaryKey)
              PropSQLNext('Select RecordId,Code From Docgen Where RecordId = ' & MAT:DocGenID)
              Case ROW:Description
              Of 'STD'
                LOC:WorkFlowDocument = 'SBSAWorkflow.PDF'
              Else
                LOC:WorkFlowDocument = 'ABSAWorkflow.PDF'
              End
            End
          
          End
      END
      
      IF LOC:WorkFlowDocument
         SHELL:Param       =    ''
         SHELL:Directory   =    ''
         SHELL:Operation   =    'open'
         SHELL:AssocFile   =    LOC:WorkFlowDocument
         ShellExecute(GetDesktopWindow(),SHELL:Operation,SHELL:AssocFile,SHELL:Param,SHELL:Directory,1)
      END
      
      OMIT('*** Workflow Rules ***')
      
            SHELL:AssocFile     =    GetRoot('%root%\help\SBSA Current Workflow.pdf')
            SHELL:Param         =    ''
            SHELL:Directory     =    ''
            SHELL:Operation     =    'open'
            ShellExecute(GetDesktopWindow(),SHELL:Operation,SHELL:AssocFile,SHELL:Param,SHELL:Directory,1)
      ! *** Workflow Rules ***
      
    OF ?AbsaBondCentreInterfaceHelpButton
      ThisWindow.Update
        ! Load the ABSA Bond Centre Interface article, on the LegalSuite website
        SHELL:AssocFile     =    'http://www.legalsuite.co.za/index.php?article=250'
        SHELL:Param         =    ''
        SHELL:Directory     =    ''
        SHELL:Operation     =    'open'
        ShellExecute(GetDesktopWindow(),SHELL:Operation,SHELL:AssocFile,SHELL:Param,SHELL:Directory,1)
    OF ?SBSAProcessEscalationProcedure
      ThisWindow.Update
         SHELL:Param       =    ''
         SHELL:Directory   =    ''
         SHELL:Operation   =    'open'
         SHELL:AssocFile   =    GetRoot('%root%\circulars\SBSA - ATTORNEY ESCALATION PROCESS UPDATED 28 OCT 2019.pdf')
         ShellExecute(GetDesktopWindow(),SHELL:Operation,SHELL:AssocFile,SHELL:Param,SHELL:Directory,1)
      
    OF ?AttorneyGatewayButton
      ThisWindow.Update
  PropSQLNext('Select AG_TestSuiteFlag From Control')
  If ROW:Counter
    MESSAGE('Your Attorney Gateway is in Test Mode which means that you will not receive|Live Instructions from FNB.||Please contact LegalSuite Software Support to rectify this.','Attorney Gateway Testing',ICON:Exclamation)
  End

  AddElectronicLinkLog('Import AG Instructions','AG')

  IF CheckIFDotNetInstalled()
    IF EXISTS('AGImportExport.exe')
      RUN('AGImportExport.exe "'  & GLO:SQLLogin & '" ' & CEM:RecordID, 1)
      If ErrorCode()
        Message(Error() & '||Error running program AGImportExport.exe||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
      End
    Else
      Message('AGImportExport.exe Not Found||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
    End
  END

  FREE(GEQ:ErrorQueue)
  CLEAR(GEQ:ErrorQueue)
  LOC:JumpToRecordID = 0
  GLO:RecordID = 0
  
  ProcessUnReadFNBMessages

  PROPSQLNext('SELECT COUNT(1) FROM MessagesToSend WHERE ExportedFlag = 0 OR ExportedFlag IS NULL')
  IF ROW:Counter
    IF CheckIFDotNetInstalled()
      IF EXISTS('AGImportExport.exe')
        RUN('AGImportExport.exe "'  & GLO:SQLLogin & '" 0', 1)
        If ErrorCode()
          Message(Error() & '||Error running program AGImportExport.exe||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
        End
      Else
        Message('AGImportExport.exe Not Found||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
      End
    END
  End

  DO RefreshFNBLinkBrowse

  LOC:JumpToRecordID = GLO:RecordID ! SETTING THIS TO THE FIRST MATTER IMPORTED SO USER JUMPS TO IT.
  IF LOC:JumpToRecordID
    SELECT(?MattersBrowse)
    POST(EVENT:JumpToMatter)
    SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
  END

  DO ShowFNBExportedStatus
    OF ?DocumentHubButton
      ThisWindow.Update
      DO LoadOnlineDocs
      DO RefreshFNBLinkBrowse
      DO ShowFNBExportedStatus
    OF ?PrintFNBInstructionButton
      ThisWindow.Update
      PrintFNBGeneralReport
      ThisWindow.Reset
    OF ?DocumentLogButton:3
      ThisWindow.Update
      IF RestrictedMatter(MAT:RecordID,0) THEN CYCLE.
      
      GLO:MatterID = MAT:RecordID
      AddToFavourites(MAT:RecordID)
      BrowseDocLog
      GLO:MatterID = 0
      SELECT(?FNBLinkBrowse)
      
    OF ?DocumentHubButton:2
      ThisWindow.Update
        DO LoadOnlineDocs
        DO RefreshFNBLinkBrowse
        DO ShowFNBExportedStatus
      
    OF ?LOC:AG_Suite_Description
          Get(AG_Division:Queue,Choice())
          LOC:AG_SuiteID = AGDQ:SuiteID
      
    OF ?Delete:7
      ThisWindow.Update
             IF AGMM:RecordID
      
                IF ~(GLO:AdministratorPassword = GetUserPassword())
      
                     MESSAGE('Unable to delete this Message.||You do not have Supervisor Access.|','Access Denied',ICON:Exclamation)
      
                 ELSE
      
                     PropSQLNext('SELECT COUNT(1) FROM MessagesToSend WHERE AG_MatterMessageID = ' & AGMM:RecordID)
                     IF ROW:Counter
                        IF MESSAGE('Do you want to Remove the Message in the MessagesToSend table as well?|','Confirm removal',ICON:Question,BUTTON:Yes+BUTTON:NO,BUTTON:Yes,1) = BUTTON:Yes
                           PropSQL('UPDATE MessagesToSend Set ExportedFlag = ISNULL(ExportedFlag,0) + 2 WHERE AG_MatterMessageID = ' & AGMM:RecordID)      !FB 1095 added is null
                        END
                     END
      
                     PropSQL('DELETE AG_MatterMessage WHERE RecordID = ' & AGMM:RecordID)
      
                     CLEAR(AGMM:Record)
                     DO RefreshFNBLinkBrowse
                     DO ShowFNBExportedStatus !FB 1095
                 END
      
            END
             RETURN(LEVEL:Notify)
      
      
    OF ?Print
      ThisWindow.Update
      SetCursor(CURSOR:Wait)
      PUSHBIND
      BIND('AGMM:Date',AGMM:Date)
      BIND('AGMM:Time',AGMM:Time)
      BIND('MAT1:FileRef',MAT1:FileRef)
      BIND('MAT1:Description',MAT1:Description)
      BIND('LOC:Branch',LOC:Branch)
      BIND('DG1:Code',DG1:Code)
      BIND('LAW_SUI:Description',LAW_SUI:Description)
      BIND('LOC:Employee',LOC:Employee)
      BIND('AGM:MessageID',AGM:MessageID)
      BIND('AGM:Description',AGM:Description)
      BIND('AGM:Direction',AGM:Direction)
      BIND('AGMM:Details',AGMM:Details)
      If CEM:PrintXMLFlag
        PrintXMLInit('FNB Messages')
      
        PrintXMLAddField('Date','AGMM:Date',0,0,0,'@d17b',0,'')
        PrintXMLAddField('Time','AGMM:Time',0,0,0,'@t3',0,'')
        PrintXMLAddField('File Ref','MAT1:FileRef',0,0,0,'@s49',0,'')
        PrintXMLAddField('Matter','MAT1:Description',0,0,0,'@s199',0,'')
        PrintXMLAddField('Branch','LOC:Branch',0,0,0,'@s19',0,'')
        PrintXMLAddField('Docs','DG1:Code',0,0,0,'@s5',0,'')
        PrintXMLAddField('Division','LAW_SUI:Description',0,0,0,'@s50',0,'')
        PrintXMLAddField('Sent/Received By','LOC:Employee',0,0,0,'@s50',0,'')
        PrintXMLAddField('No','AGM:MessageID',3,0,0,'@n_5',0,'')
        PrintXMLAddField('Message','AGM:Description',0,0,0,'@s49',0,'')
        PrintXMLAddField('To/From','AGM:Direction',0,0,0,'@s4',0,'')
        PrintXMLAddField('Details','AGMM:Details',0,0,0,'@s255',0,'')
      Else
        Free(SSQueue:50)
        a# = 1
        Loop
          Clear(SSQueue:50)
          Execute a#
            Begin
              SkipThisColumn# = False
              SSQ:50:FieldName    = 'AGMM:Date'
              SSQ:50:Heading      = 'Date'
              SSQ:50:Picture      = '@d17b'
            .
            Begin
              SkipThisColumn# = False
              SSQ:50:FieldName    = 'AGMM:Time'
              SSQ:50:Heading      = 'Time'
              SSQ:50:Picture      = '@t3'
            .
            Begin
              SkipThisColumn# = False
              SSQ:50:FieldName    = 'MAT1:FileRef'
              SSQ:50:Heading      = 'File Ref'
              SSQ:50:Picture      = '@s49'
            .
            Begin
              SkipThisColumn# = False
              SSQ:50:FieldName    = 'MAT1:Description'
              SSQ:50:Heading      = 'Matter'
              SSQ:50:Picture      = '@s199'
            .
            Begin
              SkipThisColumn# = False
              SSQ:50:FieldName    = 'LOC:Branch'
              SSQ:50:Heading      = 'Branch'
              SSQ:50:Picture      = '@s19'
            .
            Begin
              SkipThisColumn# = False
              SSQ:50:FieldName    = 'DG1:Code'
              SSQ:50:Heading      = 'Docs'
              SSQ:50:Picture      = '@s5'
            .
            Begin
              SkipThisColumn# = False
              SSQ:50:FieldName    = 'LAW_SUI:Description'
              SSQ:50:Heading      = 'Division'
              SSQ:50:Picture      = '@s50'
            .
            Begin
              SkipThisColumn# = False
              SSQ:50:FieldName    = 'LOC:Employee'
              SSQ:50:Heading      = 'Sent/Received By'
              SSQ:50:Picture      = '@s50'
            .
            Begin
              SkipThisColumn# = False
              SSQ:50:FieldName    = 'AGM:MessageID'
              SSQ:50:Heading      = 'No'
              SSQ:50:Picture      = '@n_5'
              SSQ:50:AlignH       = 5
            .
            Begin
              SkipThisColumn# = False
              SSQ:50:FieldName    = 'AGM:Description'
              SSQ:50:Heading      = 'Message'
              SSQ:50:Picture      = '@s49'
            .
            Begin
              SkipThisColumn# = False
              SSQ:50:FieldName    = 'AGM:Direction'
              SSQ:50:Heading      = 'To/From'
              SSQ:50:Picture      = '@s4'
            .
            Begin
              SkipThisColumn# = False
              SSQ:50:FieldName    = 'AGMM:Details'
              SSQ:50:Heading      = 'Details'
              SSQ:50:Picture      = '@s255'
            .
          .
          SSQ:50:FieldNo = a#
          If ~SkipThisColumn# Then Add(SSQueue:50,SSQ:50:FieldNo).
          If a# = 12 Then Break.
          a# +=1
        .
        Open(SSWindow:50)
        SSWindow:50{PROP:Text} = 'Print ' & QuickWindow{PROP:Text}
        SSWindow:50{PROP:Maximize} = True
        ?SSOle:50{PROP:Create} = 'TTF161.TTF1.6'
        If ~?SSOle:50{PROP:Ole}
          Message('Spreadsheet OCX Not Registered, Press OK To Register','',ICON:Asterisk)
          RUN('regsvr32 ttf16.ocx')
          ?SSOle:50{PROP:Create} = 'TTF161.TTF1.6'
          If ~?SSOle:50{PROP:Ole}
            Close(SSWindow:50)
            Message('The Spreadsheet OCX cannot be registered, try registering it at the DOS prompt by typing "regsvr32 ttf16.ocx"','',ICON:Hand)
            SetCursor
            Cycle
          .
        .
      
        ?SSOle:50{'Row'} = 1
        Loop a# = 1 to Records(SSQueue:50)
          Get(SSQueue:50,a#)
          ?SSOle:50{'Col'} = a#
          ?SSOle:50{'Entry'} = SSQ:50:Heading
          ?SSOle:50{'FontBold'} = 1
          ?SSOle:50{'FontUnderline'} = 1
          If SSQ:50:AlignH Then ?SSOle:50{'HAlign'} = SSQ:50:AlignH-1.
          If SSQ:50:AlignV Then ?SSOle:50{'HAlign'} = SSQ:50:AlignV-1.
        .
      
        LOC:SSRow:50 = 2
      .
      Set(BRW46::View:Browse)
      Loop
        Next(BRW46::View:Browse)
        If Errorcode() = 33 Then Break.
        If Errorcode()
          Message('Error Reading Data|Error :' & Error(),'Print',ICON:Exclamation)
          Break
        .
        If BRW46.ValidateRecord() Then Cycle.
        BRW46.SetQueueRecord
        If CEM:PrintXMLFlag
          PrintXMLAddData
        Else
          LOC:SSRow:50 += 1
          ?SSOle:50{'Row'} = LOC:SSRow:50
          Loop a# = 1 to Records(SSQueue:50)
            Get(SSQueue:50,a#)
            ?SSOle:50{'Col'} = a#
            ?SSOle:50{'Entry'} = Clip(Left(Format(Evaluate(SSQ:50:FieldName),SSQ:50:Picture)))
            Execute SSQ:50:FormatType - 1
              ?SSOle:50{'FormatCurrency2'}
              ?SSOle:50{'FormatCurrency'}
              ?SSOle:50{'FormatFixed2'}
              ?SSOle:50{'FormatFixed'}
              ?SSOle:50{'FormatPercent'}
              ?SSOle:50{'Entry'} = Format(?SSOle:50{'Entry'},@d17b)
              ?SSOle:50{'Entry'} = Format(?SSOle:50{'Entry'},@t7b)
              ?SSOle:50{'NumberFormat'} = '@'
              ?SSOle:50{'NumberFormat'} = SSQ:50:FormatString
            .
            If SSQ:50:AlignH Then ?SSOle:50{'HAlign'} = SSQ:50:AlignH-1.
            If SSQ:50:AlignV Then ?SSOle:50{'HAlign'} = SSQ:50:AlignV-1.
            ?SSOle:50{'WordWrap'} = 1
          .
        .
      End
      If CEM:PrintXMLFlag
        PrintXMLRun
        POPBIND
        SetCursor
      Else
        LOOP LOC:SSCol:50 = 1 TO RECORDS(SSQueue:50)
          Get(SSQueue:50,LOC:SSCol:50)
          If SSQ:50:ColumnWidth
            ?SSOle:50{'ColWidth(' & LOC:SSCol:50 & ')'} = SSQ:50:ColumnWidth * 256
          Else
            ?SSOle:50{'SetColWidthAuto(1,' & LOC:SSCol:50 & ',' & LOC:SSRow:50 & ',' & LOC:SSCol:50 & ',0)'}
          .
          If SSQ:50:TotalOption > 1
            ?SSOle:50{'Row'} = LOC:SSRow:50 + 1
            ?SSOle:50{'Col'} = LOC:SSCol:50
            ?SSOle:50{'SetBorder(-1,-1,-1,1,6,0,0,0,0,0,0)'}
            Execute SSQ:50:TotalOption - 1
              ?SSOle:50{'Entry'} = '=Sum(' & Chr(64 + LOC:SSCol:50) & '2:' & Chr(64 + LOC:SSCol:50) & LOC:SSRow:50 & ')'
              ?SSOle:50{'Entry'} = '=CountA(' & Chr(64 + LOC:SSCol:50) & '2:' & Chr(64 + LOC:SSCol:50) & LOC:SSRow:50 & ')'
              ?SSOle:50{'Entry'} = '=Average(' & Chr(64 + LOC:SSCol:50) & '2:' & Chr(64 + LOC:SSCol:50) & LOC:SSRow:50 & ')'
            .
            Execute SSQ:50:FormatType - 1
              ?SSOle:50{'FormatCurrency2'}
              ?SSOle:50{'FormatCurrency'}
              ?SSOle:50{'FormatFixed2'}
              ?SSOle:50{'FormatFixed'}
              ?SSOle:50{'FormatPercent'}
              ?SSOle:50{'Entry'} = Format(?SSOle:50{'Entry'},@d17b)
              ?SSOle:50{'Entry'} = Format(?SSOle:50{'Entry'},@t7b)
              z# = 1 ! Dummy Filler
              ?SSOle:50{'NumberFormat'} = SSQ:50:FormatString
            .
            If SSQ:50:AlignH Then ?SSOle:50{'HAlign'} = SSQ:50:AlignH-1.
            If SSQ:50:AlignV Then ?SSOle:50{'HAlign'} = SSQ:50:AlignV-1.
          .
        .
        LOC:PageSetup50 = ?SSOle:50{'GetPageSetup'}
        ?SSOle:50{LOC:PageSetup50 & '.PaperSize'} = 9
        ?SSOle:50{'SetPageSetup(' & LOC:PageSetup50 & ')'}
        ?SSOle:50{'PrintScaleFitToPage'} = True
        ?SSOle:50{'PrintScaleFitHPages'} = 1
        ?SSOle:50{'PrintScaleFitVPages'} = 16384
        ?SSOle:50{'PrintLandscape'} = 1
        ?SSOle:50{'PrintHeader'} = '&C&B&U' & 'FNB Messages'
        ?SSOle:50{'PrintGridLines'} = 0
        ?SSOle:50{'ShowVScrollBar'} = 1
        ?SSOle:50{'ShowHScrollBar'} = 1
        ?SSOle:50{PROP:Hide} = False
        ?SSOle:50{'Col'} = 1
        ?SSOle:50{'Row'} = 1
        SetCursor
        Accept
          Case Event()
          Of EVENT:Sized
            ?SSOle:50{PROP:Width}  = SSWindow:50{PROP:Width}
            ?SSOle:50{PROP:Height} = SSWindow:50{PROP:Height} - 19
            ?SSGroup:50{PROP:Width}  = SSWindow:50{PROP:Width} + 5
          Of EVENT:Accepted
            Case Field()
            Of ?SSClose:50
              Break
            Of ?SSExcel:50
              SetCursor(Cursor:Wait)
              LOC:Filename:50 = Path()
              If Sub(LOC:Filename:50,Len(LOC:Filename:50),1) <> '\' Then LOC:Filename:50 = LOC:Filename:50 & '\'.
              LOC:Filename:50 = LOC:Filename:50 & 'Temp\'
              LOC:Filename:50 = LOC:Filename:50 & GLO:LoginId & '.xls'
              ?SSOle:50{'WriteEx("' & LOC:Filename:50 & '",11)'}
              ?OleExcel:50{PROP:Hide} = False
              ExcelObj" = ?OleExcel:50{'Application'}
              If ~ExcelObj" OR ExcelObj" = 'GetPropertyFailed' OR ExcelObj" = 'No ole automation interface'
                ?OleExcel:50{PROP:Create} = 'Excel.Application'
                ExcelObj" = ?OleExcel:50{'Application'}
                If ~ExcelObj"
                  SetCursor
                  Message('Unable to establish an OLE link with the Microsoft Excel program.||Is Excell Installed correctly?','Printing Report',ICON:Exclamation)
                  Cycle
                .
              .
      
              ?OleExcel:50{'ScreenUpdating'} = False
              ?OleExcel:50{'Workbooks.Open(Filename="' & LOC:Filename:50 & '")'}
              If Errorcode()
                SetCursor
                Message('Unable to open file|Filename: ' & LOC:Filename:50 & GLO:LoginId & '.xls' & '|Error: ' & Error(),'Printing Report',ICON:Exclamation)
                Cycle
              .
              ?OleExcel:50{'ActiveSheet.PageSetup.Orientation'} = 2  ! SET TO LANDSCAPE
      
      
      
              ?OleExcel:50{'ScreenUpdating'} = True
              ?OleExcel:50{'Visible'} = -1
              ?OleExcel:50{PROP:Release} = ExcelObj"
              ?OleExcel:50{PROP:Deactivate} = ExcelObj"
              Post(EVENT:Accepted,?SSClose:50)
            Of ?SSPrint:50
              ?SSOle:50{'FilePrint(0)'}
            Of ?SSPreview:50
              ?SSOle:50{'FilePrintPreview'}
            Of ?SSFilePrint:50
              ?SSOle:50{'FilePrint(1)'}
            Of ?SSEdit:50
              SSWindow:50{PROP:Maximize} = True
              ?SSOle:50{'LaunchDesigner'}
              Break
            .
          .
        End
        ?SSOle:50{PROP:Release} = ?SSOle:50{'Application'}
        ?SSOle:50{PROP:Deactivate} = ?SSOle:50{'Application'}
        Destroy(?SSOle:50)
        Destroy(?OleExcel:50)
        Close(SSWindow:50)
        POPBIND
      .
    OF ?SARSSubmitTDButton
      ThisWindow.Update
  CLEAR(MAT1:Record)
  ThisWindow.Update

  IF LOC:SARS_Matter = 'Current'

    LOC:MAT:RecordID = LOC:CurrentMatterID

  ELSE

    IF MAT1:RecordID
       LOC:MAT:RecordID = GetMatterID(MAT1:RecordID)
    ELSE
       IF ~SAV:LastMatterID THEN SAV:LastMatterID = LOC:CurrentMatterID.
       LOC:MAT:RecordID = GetMatterID(SAV:LastMatterID)
     END

  END
  IF ~LOC:MAT:RecordID THEN CYCLE.

  MAT:RecordID = LOC:MAT:RecordID
  IF Access:Matter.Fetch(MAT:PrimaryKey) THEN CYCLE.

  LOC:Error = UpdateSARSCheckSheet(MAT:RecordID)

!  Message('1 LOC:Error='&LOC:Error)

  If LOC:Error = -1 
    LOC:Error = 0
  Else
    LOC:Error = 1
  End

  If LOC:Error                ! Comment this out when it is live
!    Message('Errors Have been Detected.|A SARS Application cannot be performed','Data Validation Error')
    Cycle
  Else
!    Message('No Errors Have been Detected.|A SARS Application can be performed','Data Validation Error')
  End

  LOC:SARSSelection = 'SubmitTD'
  Do SARSRunProgram

    OF ?SARSSubmitCancellationButton
      ThisWindow.Update
        CLEAR(MAT1:Record)
        ThisWindow.Update
      
        IF LOC:SARS_Matter = 'Current'
      
          LOC:MAT:RecordID = LOC:CurrentMatterID
      
        ELSE
      
          IF MAT1:RecordID
             LOC:MAT:RecordID = GetMatterID(MAT1:RecordID)
          ELSE
             IF ~SAV:LastMatterID THEN SAV:LastMatterID = LOC:CurrentMatterID.
             LOC:MAT:RecordID = GetMatterID(SAV:LastMatterID)
           END
      
        END
        IF ~LOC:MAT:RecordID THEN CYCLE.
      
        MAT:RecordID = LOC:MAT:RecordID
        IF Access:Matter.Fetch(MAT:PrimaryKey) THEN CYCLE.
      
        LOC:SARSSelection = 'SubmitCancellation'
        Do SARSRunProgram
    OF ?SARSRequestCorrespondenceButton
      ThisWindow.Update
        CLEAR(MAT1:Record)
        ThisWindow.Update
      
        IF LOC:SARS_Matter = 'Current'
      
          LOC:MAT:RecordID = LOC:CurrentMatterID
      
        ELSE
      
          IF MAT1:RecordID
             LOC:MAT:RecordID = GetMatterID(MAT1:RecordID)
          ELSE
             IF ~SAV:LastMatterID THEN SAV:LastMatterID = LOC:CurrentMatterID.
             LOC:MAT:RecordID = GetMatterID(SAV:LastMatterID)
           END
      
        END
        IF ~LOC:MAT:RecordID THEN CYCLE.
      
        MAT:RecordID = LOC:MAT:RecordID
        IF Access:Matter.Fetch(MAT:PrimaryKey) THEN CYCLE.
      
        LOC:SARSSelection = 'RequestCorrespondenceTD'
        Do SARSRunProgram
      
    OF ?SARSCheckStatusCurrentMatterButton
      ThisWindow.Update
        CLEAR(MAT1:Record)
        ThisWindow.Update
      
        IF LOC:SARS_Matter = 'Current'
      
          LOC:MAT:RecordID = LOC:CurrentMatterID
      
        ELSE
      
          IF MAT1:RecordID
             LOC:MAT:RecordID = GetMatterID(MAT1:RecordID)
          ELSE
             IF ~SAV:LastMatterID THEN SAV:LastMatterID = LOC:CurrentMatterID.
             LOC:MAT:RecordID = GetMatterID(SAV:LastMatterID)
           END
      
        END
        IF ~LOC:MAT:RecordID THEN CYCLE.
      
        MAT:RecordID = LOC:MAT:RecordID
        IF Access:Matter.Fetch(MAT:PrimaryKey) THEN CYCLE.
      
        LOC:SARSSelection = 'RequestTDStatus'
        Do SARSRunProgram
      
    OF ?SARSCheckAllStatusesButton
      ThisWindow.Update
        CLEAR(MAT1:Record)
        ThisWindow.Update
      
        IF LOC:SARS_Matter = 'Current'
      
          LOC:MAT:RecordID = LOC:CurrentMatterID
      
        ELSE
      
          IF MAT1:RecordID
             LOC:MAT:RecordID = GetMatterID(MAT1:RecordID)
          ELSE
             IF ~SAV:LastMatterID THEN SAV:LastMatterID = LOC:CurrentMatterID.
             LOC:MAT:RecordID = GetMatterID(SAV:LastMatterID)
           END
      
        END
        IF ~LOC:MAT:RecordID THEN CYCLE.
      
        MAT:RecordID = LOC:MAT:RecordID
        IF Access:Matter.Fetch(MAT:PrimaryKey) THEN CYCLE.
      
        LOC:SARSSelection = 'RequestTDStatus_All'
        Do SARSRunProgram
      
    OF ?Internet:3
      ThisWindow.Update
      ! SHELL:AssocFile='www.sarsefiling.co.za'
       SHELL:AssocFile='https://secure.sarsefiling.co.za/app/login' !FB2419 changing url !'https://secure.sarsefiling.co.za/!Generator/WebWiz.aspx?BusinessProcessCode=BPLogin&ProcessCode=Login&ActionCode=Load'
       SHELL:Param=''; SHELL:Directory='';SHELL:Operation='open'
       ShellExecute(GetDesktopWindow(),SHELL:Operation,SHELL:AssocFile,SHELL:Param,SHELL:Directory,1)
    OF ?SARSCircularsButton
      ThisWindow.Update
        BrowseBankCirculars('SARS')
    OF ?SARSRegisterButton
      ThisWindow.Update
        LOC:SARSSelection = 'Register'
        Do SARSRunProgram
    OF ?CustomSARS_PeriodButton
      ThisWindow.Update
        LOC:SARS_Period = 'Custom'
        ?LOC:SARS_Period{PROP:SELECTED} = ?LOC:SARS_Period{PROP:ITEMS}
        IF ~LOC:SARS_FromDate THEN LOC:SARS_FromDate = GLO:TodaysDate.
        IF ~LOC:SARS_ToDate THEN LOC:SARS_ToDate = GLO:TodaysDate.
        IF LOC:SARS_ToDate > GLO:TodaysDate + 10000 THEN LOC:SARS_ToDate = GLO:TodaysDate.
        GetDateRange(LOC:SARS_FromDate,LOC:SARS_ToDate)
      
    OF ?Delete:12
      ThisWindow.Update
      
              IF SMM:RecordID
      
                IF ~(GLO:AdministratorPassword = GetUserPassword())
                     MESSAGE('Unable to delete this Message.||You do not have Supervisor Access.|','Access Denied',ICON:Exclamation)
                ELSE
                     PropSQL('DELETE SARS_MatterMessage WHERE RecordID = ' & SMM:RecordID)
                     CLEAR(SMM:Record)
                     DO RefreshSARSLinkBrowse
                END
      
              END
              RETURN(LEVEL:Notify)
      
      
      
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeCloseEvent PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  BRW54.UpdateBuffer
  AddToFavourites(MAT:RecordID,1) ! SAVE THE LAST MATTER THE USER WAS WORKING ON - DON'T DISPLAY POPUP MESSAGE


  IF GLO:EdTheHandle
     IF CloseTer(GLO:EdTheHandle,True).
  END

  GLO:ReloggingOnFlag = True        ! SO IT DOESN'T SHOW THE EMPALERTS AGAIN

  ! SAVE THE DESKTOP SETTINGS

     If QuickWindow{PROP:Width} <> 0
       CEM:WindowWidth = QuickWindow{PROP:Width}
       CEM:WindowHeight = QuickWindow{PROP:Height}
     .
     CEM:ReportCategory = LOC:ReportCategory
     
     CEM:FN_Matter     = LOC:FN_Matter
     CEM:FIL_Matter    = LOC:FIL_Matter
     CEM:TOD_Matter    = LOC:TOD_Matter
     CEM:MA_Matter     = LOC:MA_Matter
     CEM:DAT_Matter    = LOC:DAT_Matter
     CEM:FNB_Matter    = LOC:FNB_Matter
     CEM:Filter_AG_Suite = LOC:AG_SuiteID
     CEM:ABSA_Matter   = LOC:ABSA_Matter
     CEM:SARS_Matter   = LOC:SARS_Matter

     CEM:FN_EmployeeID = GLO:FN_EmployeeID
     CEM:FIL_EmployeeID = GLO:FIL_EmployeeID
     CEM:TOD_EmployeeID = GLO:TOD_EmployeeID
     CEM:MA_EmployeeID = GLO:MA_EmployeeID
     
     CEM:FN_CostCentreID = GLO:FN_CostCentreID
     CEM:MA_CostCentreID = GLO:MA_CostCentreID
     
     CEM:ABSA_DG_Code = LOC:ABSA_DG_Code

     CEM:MA_ActivityID = LOC:MA_ActivityID
     
     CEM:FN_Period = LOC:FN_Period
     CEM:FIL_Period = LOC:FIL_Period
     CEM:TOD_Period = LOC:TOD_Period
     CEM:MA_Period = LOC:MA_Period
     CEM:DAT_Period = LOC:DAT_Period
     CEM:FNB_Period = LOC:FNB_Period
     CEM:ABSA_Period = LOC:ABSA_Period
     CEM:SARS_Period = LOC:SARS_Period

     CEM:FN_FromDate = LOC:FN_FromDate
     CEM:FN_ToDate = LOC:FN_ToDate
     CEM:FIL_FromDate = LOC:FIL_FromDate
     CEM:FIL_ToDate = LOC:FIL_ToDate
     CEM:TOD_FromDate = LOC:TOD_FromDate
     CEM:TOD_ToDate = LOC:TOD_ToDate
     CEM:MA_FromDate = LOC:MA_FromDate
     CEM:MA_ToDate = LOC:MA_ToDate
     CEM:DAT_FromDate = LOC:DAT_FromDate
     CEM:FNB_FromDate = LOC:FNB_FromDate
     CEM:ABSA_FromDate = LOC:ABSA_FromDate
     CEM:SARS_FromDate = LOC:SARS_FromDate

     CEM:DAT_ToDate = LOC:DAT_ToDate
     CEM:FNB_ToDate = LOC:FNB_ToDate
     CEM:ABSA_ToDate = LOC:ABSA_ToDate
     CEM:SARS_ToDate = LOC:SARS_ToDate

     CEM:TOD_Status = LOC:TOD_Status
     CEM:TOD_CriticalStep = LOC:TOD_CriticalStepID
     CEM:FIL_Status = LOC:FIL_Status
     CEM:MA_Billable = LOC:MA_BilledFlag
     CEM:PostedOption = LOC:PostedOption
     CEM:ShowMatterIconsFlag = LOC:ShowMatterIconsFlag
     CEM:ShowFileNoteIconsFlag = LOC:ShowFileNoteIconsFlag
     CEM:ShowToDoNoteIconsFlag = LOC:ShowToDoNoteIconsFlag


     GLO:ReportCategory = LOC:ReportCategory
     
     GLO:FN_Matter     = LOC:FN_Matter
     GLO:FIL_Matter    = LOC:FIL_Matter
     GLO:TOD_Matter    = LOC:TOD_Matter
     GLO:MA_Matter     = LOC:MA_Matter
     
     GLO:FN_Period = LOC:FN_Period
     GLO:FIL_Period = LOC:FIL_Period
     GLO:TOD_Period = LOC:TOD_Period
     GLO:MA_Period = LOC:MA_Period

     GLO:FN_FromDate = LOC:FN_FromDate
     GLO:FN_ToDate = LOC:FN_ToDate
     GLO:FIL_FromDate = LOC:FIL_FromDate
     GLO:FIL_ToDate = LOC:FIL_ToDate
     GLO:TOD_FromDate = LOC:TOD_FromDate
     GLO:TOD_ToDate = LOC:TOD_ToDate
     GLO:MA_FromDate = LOC:MA_FromDate
     GLO:MA_ToDate = LOC:MA_ToDate

     GLO:TOD_Status = LOC:TOD_Status
     
     GLO:MA_Billable = LOC:MA_BilledFlag
     GLO:PostedOption = LOC:PostedOption


  CLEAR(EMP:Record)
  EMP:RecordID = CEM:RecordID
  IF ~Access:Employee.Fetch(EMP:PrimaryKey)


     ! DESKTOP FILTERING SETTINGS

     EMP:ReportCategory = LOC:ReportCategory


     If QuickWindow{PROP:Width} <> 0

        !Adjust for 9pt font
        EMP:WindowWidth = QuickWindow{PROP:Width}
        EMP:WindowHeight = QuickWindow{PROP:Height}

     END

     EMP:FN_Matter    = LOC:FN_Matter
     EMP:FIL_Matter   = LOC:FIL_Matter
     EMP:TOD_Matter   = LOC:TOD_Matter
     EMP:MA_Matter    = LOC:MA_Matter
     EMP:DAT_Matter   = LOC:DAT_Matter
     EMP:FNB_Matter   = LOC:FNB_Matter
     EMP:Filter_AG_Suite = LOC:AG_SuiteID
     EMP:ABSA_Matter  = LOC:ABSA_Matter
     EMP:SARS_Matter  = LOC:SARS_Matter

     EMP:FN_EmployeeID = GLO:FN_EmployeeID
     EMP:FIL_EmployeeID = GLO:FIL_EmployeeID
     EMP:TOD_EmployeeID = GLO:TOD_EmployeeID
     EMP:MA_EmployeeID = GLO:MA_EmployeeID
     
     EMP:FN_CostCentreID = GLO:FN_CostCentreID
     EMP:MA_CostCentreID = GLO:MA_CostCentreID

     EMP:ABSA_DG_Code  = LOC:ABSA_DG_Code

     EMP:MA_ActivityID = LOC:MA_ActivityID
     
     EMP:FN_Period    = LOC:FN_Period
     EMP:FIL_Period   = LOC:FIL_Period
     EMP:TOD_Period   = LOC:TOD_Period
     EMP:MA_Period    = LOC:MA_Period
     EMP:DAT_Period   = LOC:DAT_Period
     EMP:FNB_Period   = LOC:FNB_Period
     EMP:ABSA_Period  = LOC:ABSA_Period
     EMP:SARS_Period  = LOC:SARS_Period

     EMP:FN_FromDate    = LOC:FN_FromDate
     EMP:FN_ToDate      = LOC:FN_ToDate
     EMP:FIL_FromDate   = LOC:FIL_FromDate
     EMP:FIL_ToDate     = LOC:FIL_ToDate
     EMP:TOD_FromDate   = LOC:TOD_FromDate
     EMP:TOD_ToDate     = LOC:TOD_ToDate
     EMP:MA_FromDate    = LOC:MA_FromDate
     EMP:MA_ToDate      = LOC:MA_ToDate
     EMP:DAT_FromDate   = LOC:DAT_FromDate
     EMP:FNB_FromDate   = LOC:FNB_FromDate
     EMP:ABSA_FromDate  = LOC:ABSA_FromDate
     EMP:SARS_FromDate  = LOC:SARS_FromDate

     EMP:DAT_ToDate   = LOC:DAT_ToDate
     EMP:FNB_ToDate   = LOC:FNB_ToDate
     EMP:ABSA_ToDate  = LOC:ABSA_ToDate
     EMP:SARS_ToDate  = LOC:SARS_ToDate

     EMP:TOD_Status = LOC:TOD_Status
     EMP:TOD_CriticalStep = LOC:TOD_CriticalStepID
     EMP:FIL_Status = LOC:FIL_Status
     EMP:MA_Billable = LOC:MA_BilledFlag
     EMP:PostedOption = LOC:PostedOption
     
     ! SAVE THE FILE SEARCHING SETTINGS LAST USED BY THIS EMPLOYEE
     EMP:SearchHow = CEM:SearchHow
     EMP:SearchWhat = CEM:SearchWhat
     EMP:SearchBy = CEM:SearchBy

     EMP:FilterMattersBy = CEM:FilterMattersBy
     EMP:BuildNo = CEM:BuildNo
     EMP:ShowMatterIconsFlag = CEM:ShowMatterIconsFlag
     EMP:ShowFileNoteIconsFlag = CEM:ShowFileNoteIconsFlag
     EMP:ShowToDoNoteIconsFlag = CEM:ShowToDoNoteIconsFlag

     Access:Employee.Update

  END


  DO UnBindFilteringVariables



  ReturnValue = PARENT.TakeCloseEvent()
  RETURN ReturnValue


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeEvent()
   Case EVENT()

   OF EVENT:MarkToDoNote        ! CALLED FROM CheckForLawDeedProgressMessages
                                ! DOING IT HERE SO THAT ALL THE FILES ARE OPEN


      IF GLO:RecordID
         MarkToDoNote(GLO:RecordID)
         GLO:RecordID = 0
      END

   Of EVENT:FinishedTiming

      IF GLO:StopWatchMinutes 

         IF GLO:TimeRecordingFlag
            IF ~SAV:LastMatterID THEN SAV:LastMatterID = MA:MatterID.
            IF LOC:MA_Matter = 'Current'
               LOC:UseThisMatterID = LOC:CurrentMatterID
            ELSIF SAV:LastMatterID
               LOC:UseThisMatterID = GetMatterID(SAV:LastMatterID)
            ELSE
               LOC:UseThisMatterID = GetMatterID(GLO:MatterID)
            END
         ELSE
            IF ~SAV:LastMatterID THEN SAV:LastMatterID = FN:MatterID.
            IF LOC:FN_Matter = 'Current'
               LOC:UseThisMatterID = LOC:CurrentMatterID
            ELSIF SAV:LastMatterID
               LOC:UseThisMatterID = GetMatterID(SAV:LastMatterID)
            ELSE
               LOC:UseThisMatterID = GetMatterID(GLO:MatterID)
            END
         END

         IF LOC:UseThisMatterID
      
            SAV:LastMatterID = MA:MatterID


            IF GLO:TimeRecordingFlag

               GlobalRequest = SelectRecord
               BrowseActivity

               IF GlobalResponse = RequestCompleted
                  CLEAR(MA:Record)
                  MA:MatterID = LOC:UseThisMatterID
                  DO AddTimedRecords
                  GLO:StopWatchMinutes = 0
               END

            ELSE
               POST(EVENT:Accepted,?FeeSheetButton) ! LET THE USER DEBIT A FEE CODE
            END

         END

      END


   Of EVENT:RefreshTaggedMatters
      BRW54.ResetQueue(RESET:Queue)  ! JUST SHOW THE TAGS

   Of EVENT:RefreshFeeNotes         ! CALLED FROM ADDFEENOTE

      DO RefreshFeeNoteBrowse


   Of EVENT:RefreshMatters

      DO DisplayHeading

      DO RefreshMatterBrowse
      DO RefreshFeeNoteBrowse
      DO RefreshFileNoteBrowse
      DO RefreshToDoNoteBrowse
      DO RefreshMatActivBrowse
      DO RefreshDataLinkBrowse
      DO RefreshFNBLinkBrowse
      DO RefreshABSALinkBrowse

      ThisWindow.Update


   OF EVENT:ShowTaggedMatters    ! CALLED FROM COLLECTIONS IMPORT & ALERTS

         POST(EVENT:Accepted,?MAT:OptFilterButton)

   Of EVENT:JumpToMatter

      IF ~LOC:JumpToRecordID THEN LOC:JumpToRecordID = GLO:RecordID.  ! FOR OUTSIDE CALLS 

      GLO:RecordID = 0
      IF LOC:JumpToRecordID

         IF LOC:FilterMatterString

            PropSQLNext('SELECT COUNT(1) WHERE ' & LOC:JumpToRecordID & ' IN (SELECT Matter.RecordID FROM Matter LEFT OUTER JOIN ConveyData ON ConveyData.MatterID = Matter.RecordID WHERE ' & LOC:FilterMatterString & ')')

            IF ROW:Counter  ! IT IS BEING DISPLAYED

                MAT:RecordID = LOC:JumpToRecordID
                Access:Matter.TryFetch(MAT:PrimaryKey)

                BRW54.ResetFromBuffer

                ThisWindow.Update

                LOC:CurrentMatterID = MAT:RecordID
                LOC:CurrentMatterFileRef = MAT:FileRef & ' - ' & MAT:Description


            ELSE

                IF MESSAGE('The program is unable to display this Matter.||It may be filtered out and therefore is not being displayed in the current list of Matters.||Would you like to take off the filtering so that the Matter can be located?|','Matter Unavailable (' & CLIP(LEFT(FORMAT(LOC:JumpToRecordID,@N_9))) & ')',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:Yes

                   DO ClearFiltering
                   LOC:QBEFilterString = ''


                   BRW54.ApplyFilter

                   MAT:RecordID = LOC:JumpToRecordID
                   Access:Matter.TryFetch(MAT:PrimaryKey)

                   BRW54.ResetFromBuffer
                   ThisWindow.Update

                   LOC:CurrentMatterID = MAT:RecordID
                   LOC:CurrentMatterFileRef = MAT:FileRef & ' - ' & MAT:Description

                ELSE
                   POST(EVENT:ScrollTop,?MattersBrowse)
                END
            END

         ELSE

!             IF FstTag:PtrM(TAG:Matter)
!                NewTag:PtrM(TAG:Matter)
!                BRW54::Filter = 0
!                DO SetMatterOptFilterButton
!             END
!             DO BRW54::UntagAll

             MAT:RecordID = LOC:JumpToRecordID
             Access:Matter.TryFetch(MAT:PrimaryKey)
             BRW54.ResetFromBuffer

             ThisWindow.Update
             LOC:CurrentMatterID = MAT:RecordID
             LOC:CurrentMatterFileRef = MAT:FileRef & ' - ' & MAT:Description

         END


         LOC:JumpToRecordID = 0

      ELSE

         POST(EVENT:ScrollTop,?MattersBrowse)

      END

   END
  
    If Event() = EVENT:Accepted Then ThisSecProc.SetFields().
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
  OF ?MattersBrowse
    CASE EVENT()
    OF EVENT:AlertKey
      
       
       IF  KEYCODE() = MouseLeft
          IF ?MattersBrowse{PROPLIST:MouseDownRow} = 0                     !Mouse Left click in Browse header
              IF ?MattersBrowse{PropList:MouseDownZone} = ListZone:Right   !If column is being resized,
                  CYCLE                                                  !CYCLE.
              END
      
              CASE ?MattersBrowse{PROPLIST:MouseDownField}
              OF 1
              OF 2
              OF 3
              OF 4
              OF 6
              OF 8
              OF 10
              OF 11
              OF 13
              OF 14
              OF 15
              OF 16
              OF 18
              ELSE
                  LOC:SortKey54 = ?MattersBrowse{PROPLIST:MouseDownField}                                      !Mouse Left click in Browse Column number
                  IF LOC:SortKey54 = LOC:PreSortKey54                                             !If the same LOC:SortKey54 has been selected before
                      LOC:SortKey54=LOC:SortKey54-(LOC:SortKey54*2)                    !Reverse sort direction
                      ?MattersBrowse{PROPLIST:Header,ABS(LOC:SortKey54)} = '[-] ' & LOC:PreHeader54
                  ELSE                                                                                                  !New LOC:SortKey selected
                      IF LOC:PreSortKey54 <> 0                                                               !If LOC:SortKey has been selected before
                          ?MattersBrowse{PROPLIST:Header,ABS(LOC:PreSortKey54)} = LOC:PreHeader54   !Remove sort direction from header
                      END
                      LOC:PreHeader54 = ?MattersBrowse{PROPLIST:Header,ABS(LOC:SortKey54)}          !Save header text without sort direction
                      ?MattersBrowse{PROPLIST:Header,ABS(LOC:SortKey54)} = '[+] ' & LOC:PreHeader54    !Add sort direction to header
                  END
                  LOC:PreSortKey54 = LOC:SortKey54
              END
          ELSE
              BRW54.TakeNewSelection()                  
          END
          ThisWindow.Reset
       END
       
    OF EVENT:PreAlertKey
            IF KEYCODE() <> MouseLeft
               CYCLE
            ELSIF ?MattersBrowse{PROPLIST:MouseDownZone} <> LISTZONE:HEADER
               CYCLE
            END
    END
  OF ?FileNoteBrowse
    CASE EVENT()
    OF EVENT:AlertKey
       !IF ~CEM:FileNotesDescendingFlag THEN CYCLE.
      
       
       IF  KEYCODE() = MouseLeft
          IF ?FileNoteBrowse{PROPLIST:MouseDownRow} = 0                     !Mouse Left click in Browse header
              IF ?FileNoteBrowse{PropList:MouseDownZone} = ListZone:Right   !If column is being resized,
                  CYCLE                                                  !CYCLE.
              END
      
              CASE ?FileNoteBrowse{PROPLIST:MouseDownField}
              OF 1
              OF 2
              OF 3
              OF 5
              OF 6
              OF 7
              OF 8
              OF 9
              ELSE
                  LOC:SortKey52 = ?FileNoteBrowse{PROPLIST:MouseDownField}                                      !Mouse Left click in Browse Column number
                  IF LOC:SortKey52 = LOC:PreSortKey52                                             !If the same LOC:SortKey52 has been selected before
                      LOC:SortKey52=LOC:SortKey52-(LOC:SortKey52*2)                    !Reverse sort direction
                      ?FileNoteBrowse{PROPLIST:Header,ABS(LOC:SortKey52)} = '[-] ' & LOC:PreHeader52
                  ELSE                                                                                                  !New LOC:SortKey selected
                      IF LOC:PreSortKey52 <> 0                                                               !If LOC:SortKey has been selected before
                          ?FileNoteBrowse{PROPLIST:Header,ABS(LOC:PreSortKey52)} = LOC:PreHeader52   !Remove sort direction from header
                      END
                      LOC:PreHeader52 = ?FileNoteBrowse{PROPLIST:Header,ABS(LOC:SortKey52)}          !Save header text without sort direction
                      ?FileNoteBrowse{PROPLIST:Header,ABS(LOC:SortKey52)} = '[+] ' & LOC:PreHeader52    !Add sort direction to header
                  END
                  LOC:PreSortKey52 = LOC:SortKey52
              END
          ELSE
              BRW52.TakeNewSelection()                  
          END
          ThisWindow.Reset
       END
       
    OF EVENT:PreAlertKey
            IF KEYCODE() <> MouseLeft
               CYCLE
            ELSIF ?FileNoteBrowse{PROPLIST:MouseDownZone} <> LISTZONE:HEADER
               CYCLE
            END
    END
  END
  DO  RefreshCurrentBrowse
  ReturnValue = PARENT.TakeFieldEvent()
  CASE FIELD()
  OF ?CurrentTab
    CASE EVENT()
    OF EVENT:Drop
      ThisWindow.Update
      GLO:MatterID = MAT:RecordID
      
      IF DRAGID() = 'FromSMS'
      
         Access:EmployeeSMS.Open
         Access:EmployeeSMS.UseFile
      
         CLEAR(ESM:Record)
         ESM:RecordId = DROPID()
      
         IF ~Access:EmployeeSMS.Fetch(ESM:PrimaryKey)
      
             CLEAR(DOL:Record)
      
             DOL:MatterID = GLO:MatterID
             DOL:EmployeeID    = GLO:EmployeeID
             DOL:Description   = CLIP(ESM:Message)
             DOL:EmailFlag     = 2 ! SMS
             DOL:EmailSentDate = FORMAT(GLO:TodaysDate,@d18)
             DOL:EmailFrom     = ESM:FromNumber
             DOL:EmailFolder   = ESM:ToNumber
             DOL:NoOfPages     = 1
             DOL:NoOfWords     = CountWords(ESM:Message)
             DOL:Date          = ESM:Date
             DOL:Time          = ESM:Time
             DOL:DocLogCategoryID = CTL:DocLogCategorySMSID
      
             IF ESM:BoxOption = 0
                DOL:Direction = 2   ! Incoming
             ELSE
                DOL:Direction = 1   ! Outgoing
             END
      
             IF ~Access:Doclog.Insert()
      
!                 BRW1.ResetFromFile
!                 BRW1.PostNewSelection
!      
!                 DO DisplayTabs
!                 Do RebuildTabTreeQueue:10
      
                 MESSAGE('SMS messsage successfully added to the Document Log for this Matter',MAT:FileRef,ICON:Exclamation)
      
             END
             Access:EmployeeSMS.Close
      
         END
      
      ELSE
      
         CLEAR(DOL:Record)
         GlobalRequest = InsertRecord
         ImportDocumentIntoDocLog(DROPID())
      
      END
      
      
    END
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
    OF ?CurrentTab
    
    IF ~LOC:OpenedFiles           ! Eugene uncommented this as he needs the LAW files to be opened

          DO CheckFutureTasks

          LOC:OpenedFiles = 1
      END

      DO ProgramInitialization


      IF Choice(?CurrentTab) = 6

         DO ShowDataLinkInboxStatus

      ELSIF Choice(?CurrentTab) = 2

            IF LOC:FN_Matter = 'Current'
               LOC:LastWarningMatterID = -1  ! SO IT CHECKS THIS MATTER IN CASE THE USERS POSTS SOME FEES
               DO CheckFeeEstimate
            END

      END

      DO RefreshCurrentBrowse


    OF ?MattersBrowse
      ThisWindow.Update
      LOC:CurrentMatterID = MAT:RecordID
      LOC:CurrentMatterFileRef = MAT:FileRef & ' - ' & MAT:Description

    END
  ReturnValue = PARENT.TakeNewSelection()
  OMIT('*** Change Tab Heading ***')
     !*** Change Tab Heading ***
    CASE FIELD()
    OF ?CurrentTab
      Do DisplayHeading
    OF ?LOC:FN_Period
       IF LOC:FN_Period = 'Custom'
          UNHIDE(?CustomFN_PeriodButton)
          POST(EVENT:Accepted,?CustomFN_PeriodButton)
       ELSE
          HIDE(?CustomFN_PeriodButton)
          DO SetFN_DatePeriod
       END
       
    OF ?LOC:FIL_Period
       IF LOC:FIL_Period = 'Custom'
          UNHIDE(?CustomFIL_PeriodButton)
          POST(EVENT:Accepted,?CustomFIL_PeriodButton)
       ELSE
          HIDE(?CustomFIL_PeriodButton)
          DO SetFIL_DatePeriod
       END
      
    OF ?LOC:TOD_Period
       IF LOC:TOD_Period = 'Custom'
          UNHIDE(?CustomTOD_PeriodButton)
          POST(EVENT:Accepted,?CustomTOD_PeriodButton)
       ELSE
          HIDE(?CustomTOD_PeriodButton)
          DO SetTOD_DatePeriod
       END
      
    OF ?LOC:MA_Period
       IF LOC:MA_Period = 'Custom'
          UNHIDE(?CustomMA_PeriodButton)
          POST(EVENT:Accepted,?CustomMA_PeriodButton)
       ELSE
          HIDE(?CustomMA_PeriodButton)
          DO SetMA_DatePeriod
       END
      
    OF ?LOC:DAT_Period
       IF LOC:DAT_Period = 'Custom'
          UNHIDE(?CustomDAT_PeriodButton)
          POST(EVENT:Accepted,?CustomDAT_PeriodButton)
       ELSE
          DO SetDAT_DatePeriod
          HIDE(?CustomDAT_PeriodButton)
       END
      
    OF ?LOC:ABSA_Period
       IF LOC:ABSA_Period = 'Custom'
          UNHIDE(?CustomABSA_PeriodButton)
          POST(EVENT:Accepted,?CustomABSA_PeriodButton)
       ELSE
          DO SetABSA_DatePeriod
          HIDE(?CustomABSA_PeriodButton)
       END
      
    OF ?LOC:FNB_Period
       IF LOC:FNB_Period = 'Custom'
          UNHIDE(?CustomFNB_PeriodButton)
          POST(EVENT:Accepted,?CustomFNB_PeriodButton)
       ELSE
          DO SetFNB_DatePeriod
          HIDE(?CustomFNB_PeriodButton)
       END
      
    OF ?LOC:SARS_Period
             IF LOC:SARS_Period = 'Custom'
                UNHIDE(?CustomSARS_PeriodButton)
                POST(EVENT:Accepted,?CustomSARS_PeriodButton)
             ELSE
                DO SetSARS_DatePeriod
                HIDE(?CustomSARS_PeriodButton)
             END
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
    OF EVENT:LoseFocus
      ! SO OTHER WINDOWS CAN GET THE SAME SIZE AS THIS WINDOW
      If QuickWindow{PROP:Width} <> 0
       CEM:WindowWidth = QuickWindow{PROP:Width}
       CEM:WindowHeight = QuickWindow{PROP:Height}
      .
      
    OF EVENT:GainFocus
   IF GLO:ThoughtsWindowThread


   ELSE
      IF 1=0
      QuickWindow{PROP:Active}=TRUE
      IF QuickWindow{PROP:Iconize}=TRUE
        QuickWindow{PROP:Iconize}=''
      END
      END

  END
    END
  ReturnValue = PARENT.TakeWindowEvent()
    CASE EVENT()
    OF EVENT:AlertKey
      DO BRW15::MouseLeftFlipTag
      DO BRW22::MouseLeftFlipTag
      DO BRW2::MouseLeftFlipTag
      DO BRW36::MouseLeftFlipTag
      DO BRW52::MouseLeftFlipTag
      DO BRW54::MouseLeftFlipTag
      DO MouseClickOnProgressIndicatorIcon
      DO MouseClickOnMessageIndicatorIcon
      DO MouseClickOnGuaranteeIndicatorIcon
      
    OF EVENT:PreAlertKey
      IF KEYCODE()=MouseLeft THEN CYCLE.
      IF KEYCODE()=MouseLeft THEN CYCLE.
      IF KEYCODE()=MouseLeft THEN CYCLE.
      IF KEYCODE()=MouseLeft THEN CYCLE.
      IF KEYCODE()=MouseLeft THEN CYCLE.
      IF KEYCODE()=MouseLeft THEN CYCLE.
      IF KEYCODE() = CtrlAltF1

         EXECUTE CHOICE(?CurrentTab)   
            POST(EVENT:Accepted,?DocgenDatabaseButton)
            POST(EVENT:Accepted,?FeeSheetButton)
            POST(EVENT:Accepted,?EmailFileNoteButton)
            POST(EVENT:Accepted,?MakeDoneButton)
            POST(EVENT:Accepted,?SelectActivityButton)
         END
         SETKEYCODE(0)


      ELSIF KEYCODE() = F2Key

         EXECUTE CHOICE(?CurrentTab)
             BEGIN
                 SELECT(?MattersTab)
                 POST(EVENT:Accepted,?FindMatterButton)
             END
         END
         SETKEYCODE(0)


      ELSIF KEYCODE() = F3Key

         EXECUTE CHOICE(?CurrentTab)   
            POST(EVENT:Accepted,?DocgenDatabaseButton)
         END
         SETKEYCODE(0)


      ELSIF KEYCODE() = F4Key

         EXECUTE CHOICE(?CurrentTab)   
            POST(EVENT:Accepted,?PartiesButton)
         END
         SETKEYCODE(0)

      ELSIF KEYCODE() = F5Key

         IF CHOICE(?CurrentTab) = 1  ! User is on the Matters Tab
            POST(EVENT:Accepted,?LedgerEnquiryButton)
         ELSIF CHOICE(?CurrentTab) = 4     ! User is on the Reminders Tab
            POST(EVENT:Accepted,?MakeOutLookTaskButton)
         END
         SETKEYCODE(0)

      ELSIF KEYCODE() = F6Key

         IF CHOICE(?CurrentTab) = 1
            POST(EVENT:Accepted,?DocumentLogButton)
         ELSIF CHOICE(?CurrentTab) = 4     ! User is on the Reminders Tab
            POST(EVENT:Accepted,?MakeOutLookAppointmentButton)
         END
         SETKEYCODE(0)


      ELSIF KEYCODE() = F7Key

         EXECUTE CHOICE(?CurrentTab)   
            IF GLO:InterfaceOption = 'C'
               POST(EVENT:Accepted,?CheckSheetButton)
            ELSE
               POST(EVENT:Accepted,?DebtorsBalanceButton)
            END
         END
         SETKEYCODE(0)


      ELSIF KEYCODE() = F8Key

         EXECUTE CHOICE(?CurrentTab)   
            POST(EVENT:Accepted,?FilterButton)
         END
         SETKEYCODE(0)

      ELSIF KEYCODE() = F9Key

         EXECUTE CHOICE(?CurrentTab)   
            POST(EVENT:Accepted,?SelectDocumentsButton)
         END
         SETKEYCODE(0)

      ELSIF KEYCODE() = F10Key

         SELECT(?TimeRecordingTab)
         POST(EVENT:Accepted,?TimeaFeeButton)
         SETKEYCODE(0)

      ELSIF KEYCODE() = F11Key

         EXECUTE CHOICE(?CurrentTab)
            BEGIN
                IF GLO:InterfaceOption = 'C'
                   POST(EVENT:Accepted,?QuickQuoteButton)
                ELSE
                   POST(EVENT:Accepted,?BillOfCostsButton)
                END
            END
         END
         SETKEYCODE(0)

      ELSIF KEYCODE() = F12Key

         EXECUTE CHOICE(?CurrentTab)   
            POST(EVENT:Accepted,?ShowFavouritesButton)
         END
         SETKEYCODE(0)

      ELSIF KEYCODE() = AltF2

         POST(EVENT:Accepted,?MyRemindersButton)
         SETKEYCODE(0)

      ELSIF KEYCODE() = AltF3

         POST(EVENT:Accepted,?CurrentMatterRemindersButton)
         SETKEYCODE(0)

      ELSIF KEYCODE() = AltF4

         POST(EVENT:Accepted,?AllCurrentMatterRemindersButton)
         SETKEYCODE(0)


      ELSIF KEYCODE() = AltF5

         Case CHOICE(?CurrentTab)
              OF 1
                 POST(EVENT:Accepted,?ToggleMatterIconsButton)
              OF 3
                 POST(EVENT:Accepted,?ToggleFileNoteIconsButton)
              OF 4
                 POST(EVENT:Accepted,?ToggleToDoNoteIconsButton)
         END
         SETKEYCODE(0)


      ELSIF KEYCODE() = AltF6

         IF CHOICE(?CurrentTab)= 1
            POST(EVENT:FavouritesButton,?MattersBrowse)
         END
         SETKEYCODE(0)

      ELSIF KEYCODE() = AltF7

         ! SAME CODE IS USED IN BROWSEDOCLOG

!         IF ~CEM:ScannedDocumentsLocation
!             CEM:ScannedDocumentsLocation = CTL:ScannedDocumentsLocation
!         END
!         IF ~CEM:ScannedDocumentsLocation
!             MESSAGE('There is no default directory set up for the Documents.||Press OK to specify the directory where the Documents are normally located.|','Specify Default Directory',ICON:exclamation)
!             CEM:ScannedDocumentsLocation = GetRoot(GLO:MergedDocumentLocation)
!             FILEDIALOG('Scanned Documents are located at',CEM:ScannedDocumentsLocation,,FILE:Directory+FILE:KeepDir+FILE:LongName)
!             PropSQL('UPDATE Employee SET ScannedDocumentsLocation = ''' & CEM:ScannedDocumentsLocation & ''' WHERE RecordID = ' & CEM:RecordID)
!         END
!
!         ThisWindow.Update
!
!         LOC:StrippedFileRef = REPLACE(MAT:FileRef,'/','-')
!
!         LOC:Path = CEM:ScannedDocumentsLocation & '\' & StripFileRefCharacters(LOC:StrippedFileRef) !& '\'
!         IF ~Exists(LOC:Path) Then a# = MkDir(LOC:Path).
!         RUN('EXPLORER.EXE /e,/select,' & LOC:Path)


        LOC:Path = GetScannedDocumentsLocation(MAT:FileRef)

        If ~Exists(LOC:Path) Then a# = MkDir(LOC:Path).
        RUN('EXPLORER.EXE /e,/open,' & LOC:Path)
        If ErrorCode()
          Message(Error() & '||Error running program EXPLORER.EXE||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
        End



         SETKEYCODE(0)

      ELSIF KEYCODE() = AltF8

         IF CHOICE(?CurrentTab)= 1
            DO SetDefaultFilter
         END
         SETKEYCODE(0)

      ELSIF KEYCODE() = AltF9

         IF CHOICE(?CurrentTab)= 1

            DO ClearFiltering


         END

         SETKEYCODE(0)

      ELSIF KEYCODE() = AltF10

         IF CHOICE(?CurrentTab)= 1
            POST(EVENT:Accepted,?ExtraScreenButton)
         END
         SETKEYCODE(0)

      ELSIF KEYCODE() = CtrlAltG

         MESSAGE('CtrlAltG Pressed')
         SETKEYCODE(0)

      END
    OF EVENT:Timer
      IF GLO:ThoughtsWindowThread

            POST(EVENT:CloseWindow,,GLO:ThoughtsWindowThread)

            GLO:ThoughtsWindowThread = 0

      ELSE

            QuickWindow{Prop:Timer} = 0 ! DON'T NEED THE TIMER ANY MORE

      END

    OF EVENT:Sized
      !QuickWindow{PROP:Hide} = False
      
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

ThisNotice.Init  PROCEDURE()
  Code
    Free(NoticeQueue)
      NQ:Description = 'The description of a Party in the Address Book has been improved.||You can now specify the Entity, Type and Default Role of an entry, For more information, click on the "More Info" button '
      NQ:URL         = 'http://www.legalsuite.co.za/manuals/PartiesAndEntitiesRevised.html'
      Add(NoticeQueue)
      NQ:Description = 'The Lookup Library function has been improved. Please read the White Paper by clicking on the "More Info" button'
      NQ:URL         = 'http://www.legalsuite.co.za/manuals/Lookup library.mht'
      Add(NoticeQueue)
      NQ:Description = 'You can now re-size the Desktop screen in LegalSuite to take advantage of bigger screen sizes and resolutions.'
      NQ:URL         = ''
      Add(NoticeQueue)
      NQ:Description = 'The new ABSA Web Service is now live.|Please contact the LegalSuite Helpdesk on 0861 711150'
      NQ:URL         = ''
      Add(NoticeQueue)
    EMN:EmployeeId    = GLO:EmployeeId
    EMN:ProcedureName = 'BrowseDesktop'
    Access:EmpNotice.Fetch(EMN:EmployeeProcedureKey)
    If Records(NoticeQueue) > EMN:LastNoticeNo
      BrowseNotice('BrowseDesktop',EMN:LastNoticeNo,NoticeQueue)
    .
    Return Level:Benign
ThisNotice.Kill  PROCEDURE()
  Code
  Free(NoticeQueue)
  Return Level:Benign
ThisSecProc.Init  PROCEDURE()
  Code
  Free(LocalSecFieldQueue)
  Loop a# = 1 to 100
    Execute a#
      Begin
        LSFQ:Field = ?FeeNotesTab
        LSFQ:Description = 'Feenotes Tab'
      End
      Begin
        LSFQ:Field = ?FileNotesTab
        LSFQ:Description = 'FileNotes Tab'
      End
      Begin
        LSFQ:Field = ?RemindersTab
        LSFQ:Description = 'Reminders Tab'
      End
      Begin
        LSFQ:Field = ?FilterButton
        LSFQ:Description = 'Filter Matters'
      End
      Begin
        LSFQ:Field = ?CreateCustomisedInvoiceButton
        LSFQ:Description = 'Custom Tax Invoice'
      End
      Begin
        LSFQ:Field = ?TimeRecordingTab
        LSFQ:Description = 'Time Recording Tab'
      End
      Begin
        LSFQ:Field = ?DataLinkTab
        LSFQ:Description = 'DataLink Tab'
      End
      Begin
        LSFQ:Field = ?ABSALinkTab
        LSFQ:Description = 'ABSA Link Tab'
      End
      Begin
        LSFQ:Field = ?FNBLinkTab
        LSFQ:Description = 'FNB Link Tab'
      End
      Begin
        LSFQ:Field = ?SendReceiveButton
        LSFQ:Description = 'Import DataLink Messages'
      End
      Begin
        LSFQ:Field = ?ProcessInboxMessages
        LSFQ:Description = 'Process Inbox Messages'
      End
       Break
    .
    If LSF:CheckFieldFlag
      Clear(SF:Record)
      SF:SecGroupId = GLO:SecGroupId
      SF:SecProc    = 'Matters - Desktop'
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
  LSF:CheckFieldFlag = True
  SP:Description = 'Matters - Desktop'
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
    BrowseSecProc('Matters - Desktop',0)
    Return Level:Benign

BRW54.ApplyFilter PROCEDURE

  CODE
   ! TRYING TO IMPROVE RESOURCES ON SQL SERVER.
   IF ~(CHOICE(?CurrentTab) = 1)
       BRW54::View:Browse{PROP:SQLFilter} = '1=0'
       RETURN
   END




!   DO MakeMatterFilterString
!
!   IF LOC:FilterMatterString
!      BRW54::View:Browse{PROP:SQLFilter} = LOC:FilterMatterString
!      BRW54::View:Browse{PROP:SQLFilter} = Replace(BRW54::View:Browse{PROP:SQLFilter},'Matter.','A.')
!      BRW54::View:Browse{PROP:SQLFilter} = Replace(BRW54::View:Browse{PROP:SQLFilter},'ConveyData.','B.')
!      BRW54::View:Browse{PROP:SQLFilter} = Replace(BRW54::View:Browse{PROP:SQLFilter},'MatType.','C.')
!      BRW54::View:Browse{PROP:SQLFilter} = Replace(BRW54::View:Browse{PROP:SQLFilter},'Docgen.','D.')
!      BRW54::View:Browse{PROP:SQLFilter} = Replace(BRW54::View:Browse{PROP:SQLFilter},'Party.','E.')
!   ELSE
!      BRW54::View:Browse{PROP:SQLFilter} = ''
!   END
!
!   GLO:FilterMatterSQLString = BRW54::View:Browse{PROP:SQLFilter}


  DO MakeMatterFilterString
  
  
  IF LOC:FilterMatterString
  
      BRW54::View:Browse{PROP:SQLFilter} = Replace(LOC:FilterMatterString,'Matter.','A.')
  
      BRW54::View:Browse{PROP:SQLFilter} = Replace(BRW54::View:Browse{PROP:SQLFilter},'ConveyData.','B.')
  
      GLO:FilterMatterSQLString = BRW54::View:Browse{PROP:SQLFilter}
  
  ELSE
  
     GLO:FilterMatterSQLString = ''
     BRW54::View:Browse{PROP:SQLFilter} = ''
  
  END
   RETURN
  
  PARENT.ApplyFilter


BRW54.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert:3
    SELF.ChangeControl=?Change:3
    SELF.DeleteControl=?Delete:3
  END


BRW54.Open PROCEDURE

  CODE
  
  PARENT.Open
  


BRW54.ResetQueue PROCEDURE(BYTE ResetMode)

  CODE
  PARENT.ResetQueue(ResetMode)
    
    IF Choice(?CurrentTab) = 1

     IF RECORDS(SELF.ListQueue)
        ?DocgenDatabaseButton{PROP:Disable} = False
        ?PartiesButton{PROP:Disable} = False
        ?LedgerEnquiryButton{PROP:Disable} = False
        ?SelectDocumentsButton{PROP:Disable} = False
        ?FindMatterButton{PROP:Disable} = False
        ?ToggleMatterIconsButton{PROP:Disable} = False
        ?BillOfCostsButton{PROP:Disable} = False
        ?DebtorsBalanceButton{PROP:Disable} = False
        ?ExtraScreenButton{PROP:Disable} = False
        ?DocumentLogButton{PROP:Disable} = False
        ?MatterEmployeesButton{PROP:Disable} = False
        ?FeeNotesTab{PROP:Disable} = False
        ?FileNotesTab{PROP:Disable} = False
        ?RemindersTab{PROP:Disable} = False
        ?TimeRecordingTab{PROP:Disable} = False
        ?CreateCustomisedInvoiceButton{PROP:Disable} = False
        ?ShowFavouritesButton{PROP:Disable} = False
        ?MatterSummaryButton{PROP:Disable} = False
        ?CheckSheetButton{PROP:Disable} = False
        ?MAT:QBESearchButton:2{PROP:Disable} = False
        !?MAT:QBEPrintButton{PROP:Disable} = False

     ELSE

        ?DocgenDatabaseButton{PROP:Disable} = True
        ?PartiesButton{PROP:Disable} = True
        ?LedgerEnquiryButton{PROP:Disable} = True
        ?SelectDocumentsButton{PROP:Disable} = True
        ?FindMatterButton{PROP:Disable} = True
        ?ToggleMatterIconsButton{PROP:Disable} = True
        ?BillOfCostsButton{PROP:Disable} = True
        ?DebtorsBalanceButton{PROP:Disable} = True
        ?ExtraScreenButton{PROP:Disable} = True
        ?DocumentLogButton{PROP:Disable} = True
        ?MatterEmployeesButton{PROP:Disable} = True
        ?FeeNotesTab{PROP:Disable} = True
        ?FileNotesTab{PROP:Disable} = True
        ?RemindersTab{PROP:Disable} = True
        ?TimeRecordingTab{PROP:Disable} = True
        ?CreateCustomisedInvoiceButton{PROP:Disable} = True
        ?ShowFavouritesButton{PROP:Disable} = True
        ?MatterSummaryButton{PROP:Disable} = True
        ?CheckSheetButton{PROP:Disable} = True
        ?MAT:QBESearchButton:2{PROP:Disable} = True
        !?MAT:QBEPrintButton{PROP:Disable} = True

     END

     DO SetMatterOptFilterButton

  END
    
  IF RECORDS(SELF.ListQueue)
    ?TagOne{PROP:Disable} = 0
    ?UntagOne{PROP:Disable} = 0
    ?FlipOne{PROP:Disable} = 0
    ?TagAll{PROP:Disable} = 0
    ?UntagAll{PROP:Disable} = 0
    ?FlipAll{PROP:Disable} = 0
  ELSE
    ?TagOne{PROP:Disable} = 1
    ?UntagOne{PROP:Disable} = 1
    ?FlipOne{PROP:Disable} = 1
    ?TagAll{PROP:Disable} = 1
    ?UntagAll{PROP:Disable} = 1
    ?FlipAll{PROP:Disable} = 1
  END


BRW54.ResetSort PROCEDURE(BYTE Force)

ReturnValue          BYTE,AUTO

  CODE
  
    IF LOC:SortKey54 = 19
        RETURN SELF.SetSort(11,Force)
    ELSIF LOC:SortKey54 = -19
        RETURN SELF.SetSort(12,Force)
    END
  
  IF LOC:SortKey54 = -5
    RETURN SELF.SetSort(1,Force)
  ELSIF LOC:SortKey54 = 7
    RETURN SELF.SetSort(2,Force)
  ELSIF LOC:SortKey54 = -7
    RETURN SELF.SetSort(3,Force)
  ELSIF LOC:SortKey54 = 9
    RETURN SELF.SetSort(4,Force)
  ELSIF LOC:SortKey54 = -9
    RETURN SELF.SetSort(5,Force)
  ELSIF LOC:SortKey54 = 12
    RETURN SELF.SetSort(6,Force)
  ELSIF LOC:SortKey54 = -12
    RETURN SELF.SetSort(7,Force)
  ELSIF LOC:SortKey54 = 17
    RETURN SELF.SetSort(8,Force)
  ELSIF LOC:SortKey54 = -17
    RETURN SELF.SetSort(9,Force)
  ELSE
    RETURN SELF.SetSort(10,Force)
  END
  ReturnValue = PARENT.ResetSort(Force)
  RETURN ReturnValue


BRW54.SetQueueRecord PROCEDURE

  CODE
  Tag = CHOOSE(~GetTag:PtrM(TAG:Matter, MAT:RecordID), '', '*')
  SELF.Q.Tag = Tag
  ! DOING IT THIS WAY BECAUSE IT SEEMS AS IF YOU GET AN "INVALID KEY FILE" ERROR IF YOU HAVE 5 OR MORE JOINS.
 

  LOC:Employee = GetEmployeeNameFromQueue(MAT:EmployeeID)
  
  
!  GEMPQ2:RecordID = MAT:EmployeeID
!  GET(GEMPQ2:EmployeeQueue2,GEMPQ2:RecordID)
!  IF ERROR()
!    PropSQLNext('Select RecordId,Name From Employee Where RecordId = ' & MAT:EmployeeID)
!    LOC:Employee = Left(ROW:Description & ' (Inactive Employee)')
!  ELSE
!    LOC:Employee = GEMPQ2:Name
!  End
  
  LOC:Status = ''
  Execute MAT:ArchiveStatus + 1
    LOC:Status = 'Live Matter'
    LOC:Status = 'Pending Archiving'
    LOC:Status = 'Archived'
  .
  If MAT:ArchiveNo > 0 Then LOC:Status = LOC:Status & ' (' & MAT:ArchiveNo & ')'.
  
  IF PAR:FICACompliantFlag
     LOC:FICAWords = 'Yes'
  ELSE
     LOC:FICAWords = 'No'
  END

  LOC:ProgressText = ''
  LOC:ProgressID = 0
  LOC:ProgressIndicator = ''
  LOC:IconFileName = ''
  LOC:LinkedMatterRef = ''
  IF LOC:ShowMatterIconsFlag

     IF MAT:ArchiveStatus

         IF MAT:ArchiveStatus = 1
            LOC:ProgressText = LOC:Status
         ELSE
            LOC:ProgressText = 'Archived on ' & CLIP(LEFT(FORMAT(MAT:ArchiveDate,@d17))) & ' (' & MAT:ArchiveNo & ')'
          END

     ELSIF MAT:ConveyancingStatusFlag = 1 AND MAT:NTURequestDate ! NTU REQUEST SENT

            LOC:ProgressText = 'NTU request sent on ' & CLIP(LEFT(FORMAT(MAT:NTURequestDate,@d17)))


     ELSIF MAT:ConveyancingStatusFlag = 2 AND MAT:NTUReceiveDate ! NTU RECEIVED

            LOC:ProgressText = 'NTU instruction received on ' & CLIP(LEFT(FORMAT(MAT:NTUReceiveDate,@d17)))


     ELSIF MAT:ConveyancingStatusFlag = 3 AND MAT:CancelToReassignDate ! NTU RECEIVED

            LOC:ProgressText = 'Cancel to re-assign instruction received on ' & CLIP(LEFT(FORMAT(MAT:CancelToReassignDate,@d17)))

     ELSE

        IF CEM:ProgressIndicatorFlag = 'C'
           PROPSQLNext('SELECT dbo.GetLastCriticalStep(' & MAT:RecordID & ')')
           LOC:ProgressID = ROW:Counter
        ELSIF CEM:ProgressIndicatorFlag = 'S'
           PROPSQLNext('SELECT dbo.GetLastStage(' & MAT:RecordID & ')')
           LOC:ProgressID = ROW:Counter
        END




        IF LOC:ProgressID

            IF CEM:ProgressIndicatorFlag = 'S'
               PROPSQLNext('SELECT 0,Description FROM FileNote WHERE RecordID = ' & LOC:ProgressID)
            ELSIF CEM:ProgressIndicatorFlag = 'C'
               PROPSQLNext('SELECT 0,Description FROM ToDoNote WHERE RecordID = ' & LOC:ProgressID)
            END
            LOC:ProgressText = ROW:Description

            IF CEM:ProgressIndicatorFlag = 'S'
               PROPSQLNext('SELECT 0,LargeIconFileName,0,0,0,SmallIconFileName FROM Stage WHERE RecordID = (SELECT StageID FROM FileNote WHERE RecordID = ' & LOC:ProgressID & ')')
            ELSIF CEM:ProgressIndicatorFlag = 'C'
               PROPSQLNext('SELECT 0,LargeIconFileName,0,0,0,SmallIconFileName FROM CriticalStep WHERE RecordID = (SELECT CriticalStep FROM ToDoItem WHERE RecordID = (SELECT ToDoItemID FROM ToDoNote WHERE RecordID = ' & LOC:ProgressID & '))')
            END
            IF CEM:DisplayLargeIconsFlag
               LOC:IconFileName = GetRoot(ROW:Description)
            ELSE
               LOC:IconFileName = GetRoot(ROW:Description1)
            END

        ELSE

            IF MAT:DateInstructed
               LOC:ProgressText = 'Instructed on ' & FORMAT(MAT:DateInstructed,@d17)
            ELSE
               LOC:ProgressText = 'No Instruction Date found'
            END

        END

     END

  END
  IF LOC:GHUBLicensed AND LOC:ShowMatterIconsFlag AND DG:Type = 'BON'
    PropSQLNext('Select SUM(CASE WHEN ISNULL(GuaranteeHubStatus,0) = 3 THEN  1 ELSE 0 END), <13,10> ' & |
                '        COUNT(1) from BondGuar <13,10> ' & |
                '        WHERE ISNULL(GuaranteeHubStatus,0) < 4 AND ISNULL(GuaranteeHubIdentity,'''') <> ''''  <13,10> ' & |
                '        AND MatterID = ' & MAT:RecordID)
    LOC:GuaranteesIssued = ROW:Counter & '/' & ROW:Description
   
  ELSE
   LOC:GuaranteesIssued = ''
  END


  PARENT.SetQueueRecord
  SELF.Q.Tag_NormalFG = -1
  SELF.Q.Tag_NormalBG = -1
  SELF.Q.Tag_SelectedFG = -1
  SELF.Q.Tag_SelectedBG = -1
  SELF.Q.Tag_Icon = 0
  SELF.Q.LOC:MessageIndicator_NormalFG = -1
  SELF.Q.LOC:MessageIndicator_NormalBG = -1
  SELF.Q.LOC:MessageIndicator_SelectedFG = -1
  SELF.Q.LOC:MessageIndicator_SelectedBG = -1
  SELF.Q.LOC:MessageIndicator_Icon = 0
  SELF.Q.LOC:GuaranteesIssued_NormalFG = -1
  SELF.Q.LOC:GuaranteesIssued_NormalBG = -1
  SELF.Q.LOC:GuaranteesIssued_SelectedFG = -1
  SELF.Q.LOC:GuaranteesIssued_SelectedBG = -1
  SELF.Q.LOC:ProgressIndicator_NormalFG = -1
  SELF.Q.LOC:ProgressIndicator_NormalBG = -1
  SELF.Q.LOC:ProgressIndicator_SelectedFG = -1
  SELF.Q.LOC:ProgressIndicator_SelectedBG = -1
  SELF.Q.LOC:ProgressIndicator_Icon = 0
  SELF.Q.MAT:FileRef_NormalFG = -1
  SELF.Q.MAT:FileRef_NormalBG = -1
  SELF.Q.MAT:FileRef_SelectedFG = -1
  SELF.Q.MAT:FileRef_SelectedBG = -1
  SELF.Q.LOC:ProgressText_NormalFG = -1
  SELF.Q.LOC:ProgressText_NormalBG = -1
  SELF.Q.LOC:ProgressText_SelectedFG = -1
  SELF.Q.LOC:ProgressText_SelectedBG = -1
  SELF.Q.MAT:AlternateRef_NormalFG = -1
  SELF.Q.MAT:AlternateRef_NormalBG = -1
  SELF.Q.MAT:AlternateRef_SelectedFG = -1
  SELF.Q.MAT:AlternateRef_SelectedBG = -1
  SELF.Q.LOC:LinkedMatterRef_NormalFG = -1
  SELF.Q.LOC:LinkedMatterRef_NormalBG = -1
  SELF.Q.LOC:LinkedMatterRef_SelectedFG = -1
  SELF.Q.LOC:LinkedMatterRef_SelectedBG = -1
  SELF.Q.MAT:RecordID_NormalFG = -1
  SELF.Q.MAT:RecordID_NormalBG = -1
  SELF.Q.MAT:RecordID_SelectedFG = -1
  SELF.Q.MAT:RecordID_SelectedBG = -1
  SELF.Q.LOC:FICAWords_NormalFG = -1
  SELF.Q.LOC:FICAWords_NormalBG = -1
  SELF.Q.LOC:FICAWords_SelectedFG = -1
  SELF.Q.LOC:FICAWords_SelectedBG = -1
  SELF.Q.PAR:Name_NormalFG = -1
  SELF.Q.PAR:Name_NormalBG = -1
  SELF.Q.PAR:Name_SelectedFG = -1
  SELF.Q.PAR:Name_SelectedBG = -1
  SELF.Q.MAT:Description_NormalFG = -1
  SELF.Q.MAT:Description_NormalBG = -1
  SELF.Q.MAT:Description_SelectedFG = -1
  SELF.Q.MAT:Description_SelectedBG = -1
  SELF.Q.MAT:LawRef_NormalFG = -1
  SELF.Q.MAT:LawRef_NormalBG = -1
  SELF.Q.MAT:LawRef_SelectedFG = -1
  SELF.Q.MAT:LawRef_SelectedBG = -1
  SELF.Q.MT:Description_NormalFG = -1
  SELF.Q.MT:Description_NormalBG = -1
  SELF.Q.MT:Description_SelectedFG = -1
  SELF.Q.MT:Description_SelectedBG = -1
  SELF.Q.DG:Description_NormalFG = -1
  SELF.Q.DG:Description_NormalBG = -1
  SELF.Q.DG:Description_SelectedFG = -1
  SELF.Q.DG:Description_SelectedBG = -1
  SELF.Q.LOC:Employee_NormalFG = -1
  SELF.Q.LOC:Employee_NormalBG = -1
  SELF.Q.LOC:Employee_SelectedFG = -1
  SELF.Q.LOC:Employee_SelectedBG = -1
  SELF.Q.MAT:DateInstructed_NormalFG = -1
  SELF.Q.MAT:DateInstructed_NormalBG = -1
  SELF.Q.MAT:DateInstructed_SelectedFG = -1
  SELF.Q.MAT:DateInstructed_SelectedBG = -1
  SELF.Q.LOC:Status_NormalFG = -1
  SELF.Q.LOC:Status_NormalBG = -1
  SELF.Q.LOC:Status_SelectedFG = -1
  SELF.Q.LOC:Status_SelectedBG = -1
  SELF.Q.MAT:DebtorsBalance_NormalFG = -1
  SELF.Q.MAT:DebtorsBalance_NormalBG = -1
  SELF.Q.MAT:DebtorsBalance_SelectedFG = -1
  SELF.Q.MAT:DebtorsBalance_SelectedBG = -1
  IF Tag
    Queue:Browse:1.Tag_Icon = 2
  ELSE
    Queue:Browse:1.Tag_Icon = 1
  END!IF
      SELF.Q.Tag_NormalFG   = COLOR:None
      SELF.Q.Tag_NormalBG   = COLOR:None
      SELF.Q.Tag_SelectedFG = COLOR:None
      SELF.Q.Tag_SelectedBG = COLOR:None
      SELF.Q.LOC:MessageIndicator_NormalFG   = COLOR:None
      SELF.Q.LOC:MessageIndicator_NormalBG   = COLOR:None
      SELF.Q.LOC:MessageIndicator_SelectedFG = COLOR:None
      SELF.Q.LOC:MessageIndicator_SelectedBG = COLOR:None
      SELF.Q.LOC:GuaranteesIssued_NormalFG   = COLOR:None
      SELF.Q.LOC:GuaranteesIssued_NormalBG   = COLOR:None
      SELF.Q.LOC:GuaranteesIssued_SelectedFG = COLOR:None
      SELF.Q.LOC:GuaranteesIssued_SelectedBG = COLOR:None
      SELF.Q.LOC:ProgressIndicator_NormalFG   = COLOR:None
      SELF.Q.LOC:ProgressIndicator_NormalBG   = COLOR:None
      SELF.Q.LOC:ProgressIndicator_SelectedFG = COLOR:None
      SELF.Q.LOC:ProgressIndicator_SelectedBG = COLOR:None
      SELF.Q.MAT:FileRef_NormalFG   = COLOR:None
      SELF.Q.MAT:FileRef_NormalBG   = COLOR:None
      SELF.Q.MAT:FileRef_SelectedFG = COLOR:None
      SELF.Q.MAT:FileRef_SelectedBG = COLOR:None
      SELF.Q.LOC:ProgressText_NormalFG   = COLOR:None
      SELF.Q.LOC:ProgressText_NormalBG   = COLOR:None
      SELF.Q.LOC:ProgressText_SelectedFG = COLOR:None
      SELF.Q.LOC:ProgressText_SelectedBG = COLOR:None
      SELF.Q.MAT:AlternateRef_NormalFG   = COLOR:None
      SELF.Q.MAT:AlternateRef_NormalBG   = COLOR:None
      SELF.Q.MAT:AlternateRef_SelectedFG = COLOR:None
      SELF.Q.MAT:AlternateRef_SelectedBG = COLOR:None
      SELF.Q.LOC:LinkedMatterRef_NormalFG   = COLOR:None
      SELF.Q.LOC:LinkedMatterRef_NormalBG   = COLOR:None
      SELF.Q.LOC:LinkedMatterRef_SelectedFG = COLOR:None
      SELF.Q.LOC:LinkedMatterRef_SelectedBG = COLOR:None
      SELF.Q.MAT:RecordID_NormalFG   = COLOR:None
      SELF.Q.MAT:RecordID_NormalBG   = COLOR:None
      SELF.Q.MAT:RecordID_SelectedFG = COLOR:None
      SELF.Q.MAT:RecordID_SelectedBG = COLOR:None
      SELF.Q.LOC:FICAWords_NormalFG   = COLOR:None
      SELF.Q.LOC:FICAWords_NormalBG   = COLOR:None
      SELF.Q.LOC:FICAWords_SelectedFG = COLOR:None
      SELF.Q.LOC:FICAWords_SelectedBG = COLOR:None
      SELF.Q.PAR:Name_NormalFG   = COLOR:None
      SELF.Q.PAR:Name_NormalBG   = COLOR:None
      SELF.Q.PAR:Name_SelectedFG = COLOR:None
      SELF.Q.PAR:Name_SelectedBG = COLOR:None
      SELF.Q.MAT:Description_NormalFG   = COLOR:None
      SELF.Q.MAT:Description_NormalBG   = COLOR:None
      SELF.Q.MAT:Description_SelectedFG = COLOR:None
      SELF.Q.MAT:Description_SelectedBG = COLOR:None
      SELF.Q.MAT:LawRef_NormalFG   = COLOR:None
      SELF.Q.MAT:LawRef_NormalBG   = COLOR:None
      SELF.Q.MAT:LawRef_SelectedFG = COLOR:None
      SELF.Q.MAT:LawRef_SelectedBG = COLOR:None
      SELF.Q.MT:Description_NormalFG   = COLOR:None
      SELF.Q.MT:Description_NormalBG   = COLOR:None
      SELF.Q.MT:Description_SelectedFG = COLOR:None
      SELF.Q.MT:Description_SelectedBG = COLOR:None
      SELF.Q.DG:Description_NormalFG   = COLOR:None
      SELF.Q.DG:Description_NormalBG   = COLOR:None
      SELF.Q.DG:Description_SelectedFG = COLOR:None
      SELF.Q.DG:Description_SelectedBG = COLOR:None
      SELF.Q.LOC:Employee_NormalFG   = COLOR:None
      SELF.Q.LOC:Employee_NormalBG   = COLOR:None
      SELF.Q.LOC:Employee_SelectedFG = COLOR:None
      SELF.Q.LOC:Employee_SelectedBG = COLOR:None
      SELF.Q.MAT:DateInstructed_NormalFG   = COLOR:None
      SELF.Q.MAT:DateInstructed_NormalBG   = COLOR:None
      SELF.Q.MAT:DateInstructed_SelectedFG = COLOR:None
      SELF.Q.MAT:DateInstructed_SelectedBG = COLOR:None
      SELF.Q.LOC:Status_NormalFG   = COLOR:None
      SELF.Q.LOC:Status_NormalBG   = COLOR:None
      SELF.Q.LOC:Status_SelectedFG = COLOR:None
      SELF.Q.LOC:Status_SelectedBG = COLOR:None
      SELF.Q.MAT:DebtorsBalance_NormalFG   = COLOR:None
      SELF.Q.MAT:DebtorsBalance_NormalBG   = COLOR:None
      SELF.Q.MAT:DebtorsBalance_SelectedFG = COLOR:None
      SELF.Q.MAT:DebtorsBalance_SelectedBG = COLOR:None
    If (CEM:ColourMyMattersFlag <>  1 AND MT:RecordID)
      SELF.Q.Tag_NormalFG   = MT:Color1
      SELF.Q.Tag_NormalBG   = MT:Color2
      SELF.Q.Tag_SelectedFG = MT:Color2
      SELF.Q.Tag_SelectedBG = MT:Color1
      SELF.Q.LOC:MessageIndicator_NormalFG   = MT:Color1
      SELF.Q.LOC:MessageIndicator_NormalBG   = MT:Color2
      SELF.Q.LOC:MessageIndicator_SelectedFG = MT:Color2
      SELF.Q.LOC:MessageIndicator_SelectedBG = MT:Color1
      SELF.Q.LOC:GuaranteesIssued_NormalFG   = MT:Color1
      SELF.Q.LOC:GuaranteesIssued_NormalBG   = MT:Color2
      SELF.Q.LOC:GuaranteesIssued_SelectedFG = MT:Color2
      SELF.Q.LOC:GuaranteesIssued_SelectedBG = MT:Color1
      SELF.Q.LOC:ProgressIndicator_NormalFG   = MT:Color1
      SELF.Q.LOC:ProgressIndicator_NormalBG   = MT:Color2
      SELF.Q.LOC:ProgressIndicator_SelectedFG = MT:Color2
      SELF.Q.LOC:ProgressIndicator_SelectedBG = MT:Color1
      SELF.Q.MAT:FileRef_NormalFG   = MT:Color1
      SELF.Q.MAT:FileRef_NormalBG   = MT:Color2
      SELF.Q.MAT:FileRef_SelectedFG = MT:Color2
      SELF.Q.MAT:FileRef_SelectedBG = MT:Color1
      SELF.Q.LOC:ProgressText_NormalFG   = MT:Color1
      SELF.Q.LOC:ProgressText_NormalBG   = MT:Color2
      SELF.Q.LOC:ProgressText_SelectedFG = MT:Color2
      SELF.Q.LOC:ProgressText_SelectedBG = MT:Color1
      SELF.Q.MAT:AlternateRef_NormalFG   = MT:Color1
      SELF.Q.MAT:AlternateRef_NormalBG   = MT:Color2
      SELF.Q.MAT:AlternateRef_SelectedFG = MT:Color2
      SELF.Q.MAT:AlternateRef_SelectedBG = MT:Color1
      SELF.Q.LOC:LinkedMatterRef_NormalFG   = MT:Color1
      SELF.Q.LOC:LinkedMatterRef_NormalBG   = MT:Color2
      SELF.Q.LOC:LinkedMatterRef_SelectedFG = MT:Color2
      SELF.Q.LOC:LinkedMatterRef_SelectedBG = MT:Color1
      SELF.Q.MAT:RecordID_NormalFG   = MT:Color1
      SELF.Q.MAT:RecordID_NormalBG   = MT:Color2
      SELF.Q.MAT:RecordID_SelectedFG = MT:Color2
      SELF.Q.MAT:RecordID_SelectedBG = MT:Color1
      SELF.Q.LOC:FICAWords_NormalFG   = MT:Color1
      SELF.Q.LOC:FICAWords_NormalBG   = MT:Color2
      SELF.Q.LOC:FICAWords_SelectedFG = MT:Color2
      SELF.Q.LOC:FICAWords_SelectedBG = MT:Color1
      SELF.Q.PAR:Name_NormalFG   = MT:Color1
      SELF.Q.PAR:Name_NormalBG   = MT:Color2
      SELF.Q.PAR:Name_SelectedFG = MT:Color2
      SELF.Q.PAR:Name_SelectedBG = MT:Color1
      SELF.Q.MAT:Description_NormalFG   = MT:Color1
      SELF.Q.MAT:Description_NormalBG   = MT:Color2
      SELF.Q.MAT:Description_SelectedFG = MT:Color2
      SELF.Q.MAT:Description_SelectedBG = MT:Color1
      SELF.Q.MAT:LawRef_NormalFG   = MT:Color1
      SELF.Q.MAT:LawRef_NormalBG   = MT:Color2
      SELF.Q.MAT:LawRef_SelectedFG = MT:Color2
      SELF.Q.MAT:LawRef_SelectedBG = MT:Color1
      SELF.Q.MT:Description_NormalFG   = MT:Color1
      SELF.Q.MT:Description_NormalBG   = MT:Color2
      SELF.Q.MT:Description_SelectedFG = MT:Color2
      SELF.Q.MT:Description_SelectedBG = MT:Color1
      SELF.Q.DG:Description_NormalFG   = MT:Color1
      SELF.Q.DG:Description_NormalBG   = MT:Color2
      SELF.Q.DG:Description_SelectedFG = MT:Color2
      SELF.Q.DG:Description_SelectedBG = MT:Color1
      SELF.Q.LOC:Employee_NormalFG   = MT:Color1
      SELF.Q.LOC:Employee_NormalBG   = MT:Color2
      SELF.Q.LOC:Employee_SelectedFG = MT:Color2
      SELF.Q.LOC:Employee_SelectedBG = MT:Color1
      SELF.Q.MAT:DateInstructed_NormalFG   = MT:Color1
      SELF.Q.MAT:DateInstructed_NormalBG   = MT:Color2
      SELF.Q.MAT:DateInstructed_SelectedFG = MT:Color2
      SELF.Q.MAT:DateInstructed_SelectedBG = MT:Color1
      SELF.Q.LOC:Status_NormalFG   = MT:Color1
      SELF.Q.LOC:Status_NormalBG   = MT:Color2
      SELF.Q.LOC:Status_SelectedFG = MT:Color2
      SELF.Q.LOC:Status_SelectedBG = MT:Color1
      SELF.Q.MAT:DebtorsBalance_NormalFG   = MT:Color1
      SELF.Q.MAT:DebtorsBalance_NormalBG   = MT:Color2
      SELF.Q.MAT:DebtorsBalance_SelectedFG = MT:Color2
      SELF.Q.MAT:DebtorsBalance_SelectedBG = MT:Color1
    End
    If (GEMPQ2:Color1 AND CEM:ColorizeFlag  AND CEM:ColourMyMattersFlag = 1 AND CEM:ShowJustMyColoursFlag <> 1)
      SELF.Q.Tag_NormalFG   = GEMPQ2:Color1
      SELF.Q.Tag_NormalBG   = GEMPQ2:Color2
      SELF.Q.Tag_SelectedFG = GEMPQ2:Color2
      SELF.Q.Tag_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:MessageIndicator_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:MessageIndicator_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:MessageIndicator_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:MessageIndicator_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:GuaranteesIssued_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:GuaranteesIssued_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:GuaranteesIssued_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:GuaranteesIssued_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:ProgressIndicator_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:ProgressIndicator_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:ProgressIndicator_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:ProgressIndicator_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT:FileRef_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT:FileRef_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT:FileRef_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT:FileRef_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:ProgressText_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:ProgressText_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:ProgressText_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:ProgressText_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT:AlternateRef_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT:AlternateRef_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT:AlternateRef_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT:AlternateRef_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:LinkedMatterRef_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:LinkedMatterRef_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:LinkedMatterRef_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:LinkedMatterRef_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT:RecordID_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT:RecordID_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT:RecordID_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT:RecordID_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:FICAWords_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:FICAWords_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:FICAWords_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:FICAWords_SelectedBG = GEMPQ2:Color1
      SELF.Q.PAR:Name_NormalFG   = GEMPQ2:Color1
      SELF.Q.PAR:Name_NormalBG   = GEMPQ2:Color2
      SELF.Q.PAR:Name_SelectedFG = GEMPQ2:Color2
      SELF.Q.PAR:Name_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT:LawRef_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT:LawRef_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT:LawRef_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT:LawRef_SelectedBG = GEMPQ2:Color1
      SELF.Q.MT:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.MT:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.MT:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.MT:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.DG:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.DG:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.DG:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.DG:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT:DateInstructed_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT:DateInstructed_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT:DateInstructed_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT:DateInstructed_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:Status_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:Status_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:Status_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:Status_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT:DebtorsBalance_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT:DebtorsBalance_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT:DebtorsBalance_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT:DebtorsBalance_SelectedBG = GEMPQ2:Color1
    End
    If (GEMPQ2:Color1 AND CEM:ColorizeFlag  AND CEM:ColourMyMattersFlag = 1 AND CEM:ShowJustMyColoursFlag = 1 AND GEMPQ2:RecordID = CEM:RecordID)
      SELF.Q.Tag_NormalFG   = GEMPQ2:Color1
      SELF.Q.Tag_NormalBG   = GEMPQ2:Color2
      SELF.Q.Tag_SelectedFG = GEMPQ2:Color2
      SELF.Q.Tag_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:MessageIndicator_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:MessageIndicator_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:MessageIndicator_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:MessageIndicator_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:GuaranteesIssued_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:GuaranteesIssued_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:GuaranteesIssued_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:GuaranteesIssued_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:ProgressIndicator_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:ProgressIndicator_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:ProgressIndicator_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:ProgressIndicator_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT:FileRef_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT:FileRef_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT:FileRef_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT:FileRef_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:ProgressText_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:ProgressText_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:ProgressText_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:ProgressText_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT:AlternateRef_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT:AlternateRef_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT:AlternateRef_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT:AlternateRef_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:LinkedMatterRef_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:LinkedMatterRef_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:LinkedMatterRef_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:LinkedMatterRef_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT:RecordID_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT:RecordID_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT:RecordID_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT:RecordID_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:FICAWords_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:FICAWords_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:FICAWords_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:FICAWords_SelectedBG = GEMPQ2:Color1
      SELF.Q.PAR:Name_NormalFG   = GEMPQ2:Color1
      SELF.Q.PAR:Name_NormalBG   = GEMPQ2:Color2
      SELF.Q.PAR:Name_SelectedFG = GEMPQ2:Color2
      SELF.Q.PAR:Name_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT:LawRef_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT:LawRef_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT:LawRef_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT:LawRef_SelectedBG = GEMPQ2:Color1
      SELF.Q.MT:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.MT:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.MT:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.MT:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.DG:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.DG:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.DG:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.DG:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT:DateInstructed_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT:DateInstructed_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT:DateInstructed_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT:DateInstructed_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:Status_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:Status_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:Status_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:Status_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT:DebtorsBalance_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT:DebtorsBalance_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT:DebtorsBalance_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT:DebtorsBalance_SelectedBG = GEMPQ2:Color1
    End
   IF LOC:ShowMatterIconsFlag

      IF SELF.Q.MAT:MessageWaitingFlag
         SELF.Q.LOC:MessageIndicator_Icon = 5
      ELSE
         SELF.Q.LOC:MessageIndicator_Icon = 0
      END

      IF SELF.Q.MAT:ArchiveStatus

         SELF.Q.LOC:ProgressIndicator_Icon = 3


      ELSIF CEM:ProgressIndicatorFlag = 'C' AND SELF.Q.MAT:ConveyancingStatusFlag = 1 AND SELF.Q.MAT:NTURequestDate ! NTU REQUEST SENT

         SELF.Q.LOC:ProgressIndicator_Icon = 6


      ELSIF CEM:ProgressIndicatorFlag = 'C' AND SELF.Q.MAT:ConveyancingStatusFlag = 2 AND SELF.Q.MAT:NTUReceiveDate ! NTU RECEIVED

         SELF.Q.LOC:ProgressIndicator_Icon = 6


      ELSIF CEM:ProgressIndicatorFlag = 'C' AND SELF.Q.MAT:ConveyancingStatusFlag = 3 AND SELF.Q.MAT:CancelToReassignDate ! NTU RECEIVED

         SELF.Q.LOC:ProgressIndicator_Icon = 6

      ELSIF LOC:ProgressID

         IF LOC:IconFileName
         
            ?MattersBrowse{PROP:IconList,LOC:ProgressID+6} = LOC:IconFileName
         
            SELF.Q.LOC:ProgressIndicator_Icon = LOC:ProgressID+6
         
         ELSE
         
            SELF.Q.LOC:ProgressIndicator_Icon = 0
         
         END

      ELSE

        SELF.Q.LOC:ProgressIndicator_Icon = 0

     END

   END
   SELF.Q.LOC:LinkedMatterRef = ''


       ! 7 Sep 2016 - Kelvin - added linekd matter column on desktop
        if (SELF.Q.MAT:LinkedMatterID > 0)
            PropSQLNext('Select top 1 0,L.FileRef from Matter M INNER JOIN Matter L ON M.LinkedMatterID = L.RecordID WHERE M.RecordID = ' & SELF.Q.MAT:RecordID)
            If ROW:Description
                SELF.Q.LOC:LinkedMatterRef = ROW:Description
            else
                SELF.Q.LOC:LinkedMatterRef = ''
            End
        else
            SELF.Q.LOC:LinkedMatterRef = ''
        End

    







BRW54.TakeEvent PROCEDURE

  CODE
  PARENT.TakeEvent
        CASE EVENT()

          OF EVENT:CopyMatter

             Clear(SP:Record)
             SP:SecGroupId = GLO:SecGroupId
             SP:Description = 'Matters - Desktop - Copy'
             If Access:SecProc.TryFetch(SP:SecGroupKey)
               SP:AccessFlag = True
               Access:SecProc.Insert()
             END

             If SP:AccessFlag Or GLO:SupervisorFlag
               IF RECORDS(Queue:Browse:1)
                  ThisWindow.Update
                  IF ~RestrictedMatter(MAT:RecordID,0)

                      CopyMatter

                      LOC:StayOnThisMatterID = MAT:RecordID
                      Select(?MattersBrowse)
                      If GlobalResponse = RequestCompleted THEN DO RefreshMatterBrowse.
                      LOC:StayOnThisMatterID = 0
                   END
               END
             Else
               Message('You do not have sufficient rights to Copy Matters.','Access Denied','~lock.ico')
             End

          OF EVENT:CreateInvoice


             IF RECORDS(Queue:Browse:1)

               ThisWindow.Update

               IF ~RestrictedMatter(MAT:RecordID,0)
                
                    AddToFavourites(MAT:RecordID)
                
                    CreateSingleInvoice(MAT:RecordId,1)
                END

             END

          OF EVENT:ResetColumnWidthsButton

             Do ResetColumnWidths

          OF EVENT:FavouritesButton


            ThisWindow.Update

            IF ~RestrictedMatter(MAT:RecordID,0)
            
                IF GLO:FilterFavouritesFlag
                   PropSQL('Delete Favourites WHERE MatterID = ' & MAT:RecordID & ' AND EmployeeID = ' & CEM:RecordID)
                
                   LOC:StayOnThisMatterID = MAT:RecordID
                   DO RefreshMatterBrowse
                   LOC:StayOnThisMatterID = 0
                   Select(?MattersBrowse)
                ELSE
                   PropSQLNext('Select MatterID From Favourites WHERE MatterID = ' & MAT:RecordID & ' AND EmployeeID = ' & CEM:RecordID)
                   IF ROW:Counter
                      MESSAGE('This Matter is already in the Recently Used List.','Adding Matter',ICON:Exclamation)
                   ELSE
                      FAV:MatterID = MAT:RecordID
                      FAV:EmployeeID = CEM:RecordID
                      IF ~Access:Favourites.Insert()
                          BEEP
                      END
                   END
                END

            END


          OF EVENT:AssignLawRefButton

             IF GLO:AdministratorPassword = GetUserPassword()
           
                 ThisWindow.Update

                 LOC:NewLawRef = GetUserInput('','Assign Law Ref (' & MAT:FileRef & ')','Law Ref:')

                 IF LOC:NewLawRef
                    IF NUMERIC(LOC:NewLawRef)
                       PropSQL('UPDATE Matter SET LawRef = 0, InternalComment = ''This LAW reference (' & LOC:NewLawRef & ') was assigned to ' & MAT:FileRef & ' by ' & GLO:UserName & ' on ' & CLIP(LEFT(FORMAT(GLO:TodaysDate,@d18))) & ''' WHERE RecordID = ' & MAT:RecordID)
                       PropSQL('UPDATE Matter SET LawRef = ' & LOC:NewLawRef & ' WHERE RecordID = ' & MAT:RecordID)
                       PropSQL('UPDATE LAW_Mattr SET LawRef = ' & LOC:NewLawRef & ' WHERE MatterID = ' & MAT:RecordID)
                       MESSAGE('Law Reference (' & LOC:NewLawRef & ' ) has been assigned to ' & MAT:FileRef,'Completed',ICON:Exclamation)
                    ELSE
                       MESSAGE('A Law Reference must be numeric.||Invalid reference','Assignment Unsuccessful',ICON:Exclamation)
                    END
                 END
           
             END
             SELECT(?MattersBrowse,CHOICE(?MattersBrowse))

          OF EVENT:ReassignDataLinkMatterButton

               ThisWindow.Update

               IF ~RestrictedMatter(MAT:RecordID,0)
              
                  GlobalRequest = SelectRecord
                  SelectMatterAlias
                  IF GlobalResponse = RequestCompleted
                     LOC:DataLinkSourceMatter = GetDescription('MATTER',MAT:RecordID)
                     LOC:DataLinkTargetMatter = MAT1:FileRef & ' - ' & MAT1:Description
                     IF MESSAGE('This procedure can be used to re-assign a Matter that was created by LAW to an existing Matter in LegalSuite.||This procedure will copy the Law Reference, Alternate Reference and any File Notes to the selected Matter so that LAW will use this Matter in future (instead of the existing one that was created by LAW).||Once this process is complete, you can delete the Matter created (erroneously) by LAW if you wish.||Are you sure you want to re-assign this (new) DataLink Matter||' & LOC:DataLinkSourceMatter & '||to this existing Matter||' & LOC:DataLinkTargetMatter & '||','Confirm Re-Assignment',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:Yes
                        ReassignDataLinkMatter(MAT:RecordID,MAT1:RecordID)
                     END
                  END
               END
               SELECT(?MattersBrowse,CHOICE(?MattersBrowse))

          OF EVENT:ExportMatterButton

             LOOP 1 TIMES

                ThisWindow.Update
                IF ~RestrictedMatter(MAT:RecordID,0)
                
                    If GetReportEmp(TAG:Matter,2) Then BREAK.
                    If FstTag:PtrM(TAG:Matter)
                      REE:MatterOption = 2
                    .
                    If Access:ReportEmp.Update() Then BREAK.
                    START(ExportXML, 25000, TAG:Matter)
                END

             END

          OF EVENT:SendEmailButton

             LOOP 1 TIMES

                  ThisWindow.Update

                  IF ~CntTag:PtrM(Tag:Matter)                  ! IF NO MATTERS ARE TAGGED
                      SetTag:PtrM(TAG:Matter, MAT:RecordID)    ! TAG THE ONE THE USER IS ON
                      Queue:Browse:1.Tag_Icon = 2
                      Queue:Browse:1.Tag = Tag
                      PUT(Queue:Browse:1)
                      DISPLAY
                  END

                   IF CntTag:PtrM(TAG:Matter) > 1
                      IF MESSAGE('There are ' & CntTag:PtrM(TAG:Matter) & ' Matters tagged.||Do you want to send an email to a Party linked to these Tagged Matters?','Sending Email',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:No
                         BREAK
                      END
                   END
                  
                   GlobalRequest = SelectRecord

                   SelectRole
                  
                   IF GlobalResponse = RequestCompleted
                  
                       DO AddRecipientsToGlabalEmailQueue

                       IF ~RECORDS(GEMQ:EmailQueue)
                          Message('None of the Parties have an email addesss.','Unable to send Email',ICON:Exclamation)
                          GLO:EmailRoleID = 0
                          GLO:EmailLanguageID = 0
                          BREAK
                  
                       ELSE
                  
                          IF RECORDS(GEQ:ErrorQueue)
                             BrowseMessageSendingErrors('The following Parties do not have email addresses')
                          END
                  
                          
                          !FB 1638 (trying something)
                          IF CntTag:PtrM(TAG:Matter) > 1
                            GLO:SendingMultipleEmailsFlag = 1
                            SendEmailMessage(0,0,0,'',CEM:EmailSubject,'')
                          ELSE
                            SendEmailMessage(LOC:CurrentMatterID,0,0,'',CEM:EmailSubject,'')
                          END
                          GLO:SendingMultipleEmailsFlag = 0
                          GLO:EmailRoleID = 0
                          GLO:EmailLanguageID = 0

                       END

                   END
                   
                   SELECT(?MattersBrowse,CHOICE(?MattersBrowse))
                   
      
             END



        OF EVENT:SendSMSButton

            LOOP 1 TIMES

                ThisWindow.Update
                
                IF ~CntTag:PtrM(Tag:Matter)                  ! IF NO MATTERS ARE TAGGED
                    SetTag:PtrM(TAG:Matter, MAT:RecordID)    ! TAG THE ONE THE USER IS ON
                    Queue:Browse:1.Tag_Icon = 2
                    Queue:Browse:1.Tag = Tag
                    PUT(Queue:Browse:1)
                    DISPLAY
                END
                
                
                 IF CntTag:PtrM(TAG:Matter) > 1
                    IF MESSAGE('There are ' & CntTag:PtrM(TAG:Matter) & ' Matters tagged.||Do you want to send an SMS message to a Party linked to these Tagged Matters?','Sending SMS Message',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:No
                       BREAK
                    END
                 END
                
                 SAVE:Path = PATH()
                 IF ~CTL:SMSProvider OR ~CTL:SMSPassword
                     MESSAGE('You must set up your SMS Service Provider and Security Code before using the SMS feature in LegalSuite.||Go to Setup/Program Settings/Miscellaneous','Send SMS',ICON:Asterisk)
                     BREAK
                 ELSIF  EdLoadOutlook()
                     MESSAGE('Unable to load MS Outlook','Error loading Outlook',ICON:Exclamation)
                     BREAK
                 END
                
                 Access:MatParty.UseFile
                
                 FREE(SMSQueue)
                 CLEAR(SMSQueue)
                 FREE(GEQ:ErrorQueue)
                 CLEAR(GEQ:ErrorQueue)
                 FREE(SAV:ErrorQueue)
                 CLEAR(SAV:ErrorQueue)

                 GlobalRequest = SelectRecord

                 SelectRole

                 IF GlobalResponse = RequestCompleted
                    LOC:ThisRoleID = ROL:RecordID
                    LOC:SMSBody = ''

                    ! 12/05/2016 Sameer: Commented this out because GetUserSMSInput() called below does the same thing and so this just ends up duplicating whatever was set in Setup | Employees | SMS
!                    CASE GLO:SMSFileRefFlag
!                         OF 1
!                            LOC:SMSBody = '[[(MAT:FileRef)]]'
!                         OF 2
!                            LOC:SMSBody = '[[(MAT:Description)]]'
!                         OF 3
!                            LOC:SMSBody = '[[(MAT:FileRef)]] - [[(MAT:Description)]]'
!                    END
                
                    LOC:SMSBody = GetUserSMSInput(0,LOC:SMSBody,'Type in SMS message','Message (max 160 characters)')
                    
                    IF LOC:SMSBody
                       CLEAR(MAT:Record)
                       MAT:RecordID = FstTag:PtrM(TAG:Matter)
                       SETCURSOR(CURSOR:Wait)
                       LOOP
                          CLEAR(MP:Record)
                          MP:MatterID = MAT:RecordID
                          MP:RoleID = LOC:ThisRoleID
                          SET(MP:MatterRoleKey,MP:MatterRoleKey)
                
                
                
                          LOOP UNTIL Access:MatParty.Next()
                               IF ~(MP:MatterID = MAT:RecordID) THEN BREAK.
                               IF ~(MP:RoleID = LOC:ThisRoleID) THEN BREAK.
                
                               LOC:SMSRecipient = GetDescription('PARTY CELL',MP:PartyID)
                
                               IF LOC:SMSRecipient  ! SEND IT TO ALL HIS CELL NUMBERS
                
                                  PropSQL('Select Party.RecordID,ParTele.Number,0,0,0,Party.MatterPrefix,Party.Name FROM Party Join ParTele ON ParTele.PartyID = Party.RecordID WHERE ParTele.PartyID = ' & MP:PartyID & ' AND ParTele.TelephoneTypeID = ' & CTL:CellPhoneID)
                
                                  LOOP
                                      NEXT(RowCounter)
                                      If Errorcode() = 33 Then Break.
                                      If Errorcode()
                                         Message('Error Sending SMS||Error: ' & Error(),'Send SMS',ICON:Exclamation)
                                         Break
                                      End
                
                                      IF ROW:Description
                                         SMSQ:Number = ROW:Description       ! DON'T SEND TO THE SAME NUMBER MORE THAN ONCE
                
                                         GET(SMSQueue,SMSQ:Number,SMSQ:MatterID)
                                         IF ERROR()
                                            SMSQ:Number = ROW:Description
                                            SMSQ:PartyID = ROW:Counter
                                            SMSQ:MatterID = MP:MatterID
                
                                            ADD(SMSQueue,SMSQ:Number)
                
                                         ELSE
                
                                            PropSQLNext('Select RecordID,Name,0,0,0,MatterPrefix FROM Party WHERE RecordID = ' & MP:PartyID)
                                            CLEAR(GEQ:ErrorQueue)
                                            GEQ:PartyID = ROW:Counter
                                            GEQ:MatterID = MP:MatterID
                                            GEQ:Message1 = ROW:Description1
                                            GEQ:Message2 = ROW:Description
                                            GEQ:Message3 = 'Duplicate cell phone number'
                                            ADD(GEQ:ErrorQueue)
                
                
                                         END
                                      END
                                  END
                
                               ELSE
                
                                  PropSQLNext('Select RecordID,Name,0,0,0,MatterPrefix FROM Party WHERE RecordID = ' & MP:PartyID)
                                  CLEAR(GEQ:ErrorQueue)
                                  GEQ:PartyID = ROW:Counter
                                  GEQ:MatterID = MP:MatterID
                                  GEQ:Message1 = ROW:Description1
                                  GEQ:Message2 = ROW:Description
                                  ADD(GEQ:ErrorQueue)
                  
                               END
                          END
                          MAT:RecordID = NxtTag:PtrM(TAG:Matter)
                          IF ~MAT:RecordID THEN BREAK.
                       END
                       SETCURSOR
                    END
                 END
                
                
                
                
                 LOOP LOC:SMSCounter = 1 TO RECORDS(SMSQueue)
                      GET(SMSQueue,LOC:SMSCounter)
                      IF INSTRING('[[',LOC:SMSBody,1)
                         MAT:RecordID = SMSQ:MatterID
                         IF ~Access:Matter.Fetch(MAT:PrimaryKey)
                             LOC:ThisSMSBody = ReplaceTextBoxFields(LOC:SMSBody,MAT:DocumentLanguageID,SMSQ:PartyID,SMSQ:MatterID)
                         END
                      ELSE
                         LOC:ThisSMSBody = LOC:SMSBody
                      END
                
                      If SendAndLogSMS(SMSQ:MatterID,SMSQ:PartyID,SMSQ:Number,LOC:ThisSMSBody,1)
                        PropSQLNext('Select RecordID,Name,0,0,0,MatterPrefix FROM Party WHERE RecordID = ' & SMSQ:PartyID)
                        CLEAR(GEQ:ErrorQueue)
                        GEQ:PartyID = ROW:Counter
                        GEQ:MatterID = SMSQ:MatterID
                        GEQ:Message1 = ROW:Description1
                        GEQ:Message2 = 'Cell: ' & SMSQ:Number & ' Name: ' & ROW:Description
                        PropSQLNext('Select RecordId,FileRef From Matter Where RecordId = ' & SMSQ:MatterID)
                        GEQ:Message3 = Format(Today(),@d17) & ' ' & Format(Clock(),@T3) & ' File Ref: ' & ROW:Description
                        GEQ:Message3 = GEQ:Message3 & ' Error: Reason Unknown. SMS: ' & LOC:ThisSMSBody
                        ADD(GEQ:ErrorQueue)
                      Else

! I am adding the sucessful SMS's to a Temporary List which can be printed out as a report. This will list the sucessful SMS's.

                        CLEAR(SAV:ErrorQueue)
                        SAV:PartyID  = SMSQ:PartyID
                        SAV:MatterID = SMSQ:MatterID
                        PropSQLNext('Select RecordId,Name,0,0,0,MatterPrefix From Party Where RecordId = ' & SMSQ:PartyID)
                        SAV:Message1 = ROW:Description1
                        SAV:Message2 = 'Cell: ' & SMSQ:Number & ' Name: ' & ROW:Description
                        PropSQLNext('Select RecordId,FileRef From Matter Where RecordId = ' & SMSQ:MatterID)
                        SAV:Message3 = Format(Today(),@d17) & ' ' & Format(Clock(),@T3) & ' File Ref: ' & ROW:Description
                        SAV:Message3 = SAV:Message3 & ' SMS: ' & LOC:ThisSMSBody
                        ADD(SAV:ErrorQueue)
                      End
          !

                 END
                 
                 IF RECORDS(SMSQueue) = 1
                    MESSAGE('The SMS message was sent successfully.||There were ' & CLIP(LEFT(FORMAT(RECORDS(GEQ:ErrorQueue),@N_5))) & ' messages that could not be sent.|','Completed','~sms.ico')
                 ELSIF RECORDS(SMSQueue) > 1
                    MESSAGE('The SMS messages were sent successfully.||There were ' & CLIP(LEFT(FORMAT(RECORDS(GEQ:ErrorQueue),@N_5))) & ' messages that could not be sent.|','Completed','~sms.ico')
                 ELSE
                    MESSAGE('No SMS messages were sent.||There were ' & CLIP(LEFT(FORMAT(RECORDS(GEQ:ErrorQueue),@N_5))) & ' errors messages.|','Completed','~sms.ico')
                 END
                
                 SETPATH(SAVE:Path)
                
                 IF RECORDS(GEQ:ErrorQueue)
                    BrowseMessageSendingErrors
                 END

                 LOC:UnreadRecords = Records(SAV:ErrorQueue)        ! Process Queue
                 IF LOC:UnreadRecords
                   FREE(GEQ:ErrorQueue)
                   Loop LOC:CurrentRecord = 1 to LOC:UnreadRecords
                     Get(SAV:ErrorQueue,LOC:CurrentRecord)
                     CLEAR(GEQ:ErrorQueue)
                     GEQ:PartyID  = SAV:PartyID
                     GEQ:MatterID = SAV:MatterID
                     GEQ:Message1 = SAV:Message1
                     GEQ:Message2 = SAV:Message2
                     GEQ:Message3 = SAV:Message3
                     ADD(GEQ:ErrorQueue)
                   End
                   BrowseMessagesSent('The following SMS messages were successfully sent')
                 End
                 Free(SAV:ErrorQueue)

                 BRW54.ResetQueue(Reset:Queue)
                 SELECT(?MattersBrowse,CHOICE(?MattersBrowse))

            END

        END


BRW54.TakeNewSelection PROCEDURE

  CODE
  PARENT.TakeNewSelection
        IF (INLIST(DG:Code, 'ABSA', 'STD')) THEN
  
          ! This is for ABSASendReceiveDocsButton on the Bond Centre tab
          ENABLE(?BondCentreOrGatewayPropertyHubDocsButtonMatterTab)
          ?BondCentreOrGatewayPropertyHubDocsButtonMatterTab{PROP:Tooltip} = 'Download documents from the Bond Centre'
  
        ELSIF (INLIST(DG:Code, 'TRN')) THEN
  
          ! This is for DocumentHubButton on the Gateway tab
          ENABLE(?BondCentreOrGatewayPropertyHubDocsButtonMatterTab)
          ?BondCentreOrGatewayPropertyHubDocsButtonMatterTab{PROP:Tooltip} = 'Download documents from Attorney Gateway'
  
        ELSE
  
          ! Invalid DG:Code
          DISABLE(?BondCentreOrGatewayPropertyHubDocsButtonMatterTab)
          ?BondCentreOrGatewayPropertyHubDocsButtonMatterTab{PROP:Tooltip} = 'Cannot download documents for DocGen Code: ' & DG:Code
  
        END


BRW54.ValidateRecord PROCEDURE

ReturnValue          BYTE,AUTO

BRW54::RecordStatus  BYTE,AUTO
  CODE
  ReturnValue = PARENT.ValidateRecord()
  RETURN ReturnValue
  
  BRW54::RecordStatus=ReturnValue
  IF BRW54::RecordStatus NOT=Record:OK THEN RETURN BRW54::RecordStatus.
  IF BRW54::Filter
    IF ~GetTag:PtrM(TAG:Matter, MAT:RecordID) THEN RETURN Record:Filtered.
  END!IF
  ReturnValue=BRW54::RecordStatus
  RETURN ReturnValue


BRW52.ApplyFilter PROCEDURE

  CODE
   ! TRYING TO IMPROVE RESOURCES ON SQL SERVER.
   IF ~(CHOICE(?CurrentTab) = 3)
       BRW52::View:Browse{PROP:SQLFilter} = '1=0'
       RETURN
   END

   DO MakeFilterFileNoteString
  
   IF LOC:FilterFileNoteString
      BRW52::View:Browse{PROP:SQLFilter} = LOC:FilterFileNoteString
      BRW52::View:Browse{PROP:SQLFilter} = Replace(BRW52::View:Browse{PROP:SQLFilter},'FileNote.','A.')
      BRW52::View:Browse{PROP:SQLFilter} = Replace(BRW52::View:Browse{PROP:SQLFilter},'Stage.','B.')
   ELSE
      BRW52::View:Browse{PROP:SQLFilter} = ''
   END




   RETURN
  
  PARENT.ApplyFilter


BRW52.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert:5
    SELF.ChangeControl=?Change:5
    SELF.DeleteControl=?Delete:5
  END


BRW52.PrimeRecord PROCEDURE(BYTE SuppressClear = 0)

ReturnValue          BYTE,AUTO

  CODE
  If LOC:CopyFlag21
    SuppressClear = True
  .
  ReturnValue = PARENT.PrimeRecord(SuppressClear)
  If ReturnValue Then LOC:CopyFlag21 = False.
  RETURN ReturnValue


BRW52.ResetQueue PROCEDURE(BYTE ResetMode)

  CODE
  PARENT.ResetQueue(ResetMode)
  IF Choice(?CurrentTab) = 3
  
     DO SetFileNoteOptFilterButton
     
     IF RECORDS(SELF.ListQueue)
        ?EmailFileNoteButton{PROP:Disable} = False
        ?PrintFileNoteButton{PROP:Disable} = False
        ?FileNoteJumpToMatterButton{PROP:Disable} = False
        ?MakeFeeNoteButton{PROP:Disable} = False
        !?CopyFileNote{PROP:Disable} = False
     ELSE
        ?EmailFileNoteButton{PROP:Disable} = True
        ?PrintFileNoteButton{PROP:Disable} = True
        ?FileNoteJumpToMatterButton{PROP:Disable} = True
        ?MakeFeeNoteButton{PROP:Disable} = True
        !?CopyFileNote{PROP:Disable} = True
     END
  
  END
  IF RECORDS(SELF.ListQueue)
    ?TagOne:3{PROP:Disable} = 0
    ?UntagOne:3{PROP:Disable} = 0
    ?TagAll:3{PROP:Disable} = 0
    ?UntagAll:3{PROP:Disable} = 0
  ELSE
    ?TagOne:3{PROP:Disable} = 1
    ?UntagOne:3{PROP:Disable} = 1
    ?TagAll:3{PROP:Disable} = 1
    ?UntagAll:3{PROP:Disable} = 1
  END


BRW52.ResetSort PROCEDURE(BYTE Force)

ReturnValue          BYTE,AUTO

  CODE
  IF LOC:SortKey52 = -4
    RETURN SELF.SetSort(1,Force)
  ELSE
    RETURN SELF.SetSort(2,Force)
  END
  ReturnValue = PARENT.ResetSort(Force)
  RETURN ReturnValue


BRW52.SetQueueRecord PROCEDURE

  CODE
  Tag = CHOOSE(~GetTag:PtrM(TAG:FileNote, FIL:RecordID), '', '*')
  SELF.Q.Tag = Tag
  IF MAT1:Access = 'R' AND ~(CEM:RecordID = MAT1:EmployeeID) AND ~GLO:SupervisorFlag
     FIL:Description = 'Restricted Matter'
  END

  LOC:Employee = GetEmployeeNameFromQueue(FIL:EmployeeID)


  PARENT.SetQueueRecord
  SELF.Q.Tag_NormalFG = -1
  SELF.Q.Tag_NormalBG = -1
  SELF.Q.Tag_SelectedFG = -1
  SELF.Q.Tag_SelectedBG = -1
  SELF.Q.Tag_Icon = 0
  SELF.Q.LOC:ProgressIndicator_NormalFG = -1
  SELF.Q.LOC:ProgressIndicator_NormalBG = -1
  SELF.Q.LOC:ProgressIndicator_SelectedFG = -1
  SELF.Q.LOC:ProgressIndicator_SelectedBG = -1
  SELF.Q.LOC:ProgressIndicator_Icon = 0
  SELF.Q.LOC:FileNotePostedFlag_NormalFG = -1
  SELF.Q.LOC:FileNotePostedFlag_NormalBG = -1
  SELF.Q.LOC:FileNotePostedFlag_SelectedFG = -1
  SELF.Q.LOC:FileNotePostedFlag_SelectedBG = -1
  IF (FIL:FeeNoteID>0)
    SELF.Q.LOC:FileNotePostedFlag_Icon = 3
  ELSE
    SELF.Q.LOC:FileNotePostedFlag_Icon = 4
  END
  SELF.Q.FIL:Date_NormalFG = -1
  SELF.Q.FIL:Date_NormalBG = -1
  SELF.Q.FIL:Date_SelectedFG = -1
  SELF.Q.FIL:Date_SelectedBG = -1
  SELF.Q.MAT1:FileRef_NormalFG = -1
  SELF.Q.MAT1:FileRef_NormalBG = -1
  SELF.Q.MAT1:FileRef_SelectedFG = -1
  SELF.Q.MAT1:FileRef_SelectedBG = -1
  SELF.Q.MAT1:Description_NormalFG = -1
  SELF.Q.MAT1:Description_NormalBG = -1
  SELF.Q.MAT1:Description_SelectedFG = -1
  SELF.Q.MAT1:Description_SelectedBG = -1
  SELF.Q.STA:Code_NormalFG = -1
  SELF.Q.STA:Code_NormalBG = -1
  SELF.Q.STA:Code_SelectedFG = -1
  SELF.Q.STA:Code_SelectedBG = -1
  SELF.Q.FIL:Description_NormalFG = -1
  SELF.Q.FIL:Description_NormalBG = -1
  SELF.Q.FIL:Description_SelectedFG = -1
  SELF.Q.FIL:Description_SelectedBG = -1
  SELF.Q.LOC:Employee_NormalFG = -1
  SELF.Q.LOC:Employee_NormalBG = -1
  SELF.Q.LOC:Employee_SelectedFG = -1
  SELF.Q.LOC:Employee_SelectedBG = -1
  IF Tag
    Queue:Browse:4.Tag_Icon = 2
  ELSE
    Queue:Browse:4.Tag_Icon = 1
  END!IF
      SELF.Q.Tag_NormalFG   = COLOR:None
      SELF.Q.Tag_NormalBG   = COLOR:None
      SELF.Q.Tag_SelectedFG = COLOR:None
      SELF.Q.Tag_SelectedBG = COLOR:None
      SELF.Q.LOC:ProgressIndicator_NormalFG   = COLOR:None
      SELF.Q.LOC:ProgressIndicator_NormalBG   = COLOR:None
      SELF.Q.LOC:ProgressIndicator_SelectedFG = COLOR:None
      SELF.Q.LOC:ProgressIndicator_SelectedBG = COLOR:None
      SELF.Q.LOC:FileNotePostedFlag_NormalFG   = COLOR:None
      SELF.Q.LOC:FileNotePostedFlag_NormalBG   = COLOR:None
      SELF.Q.LOC:FileNotePostedFlag_SelectedFG = COLOR:None
      SELF.Q.LOC:FileNotePostedFlag_SelectedBG = COLOR:None
      SELF.Q.FIL:Date_NormalFG   = COLOR:None
      SELF.Q.FIL:Date_NormalBG   = COLOR:None
      SELF.Q.FIL:Date_SelectedFG = COLOR:None
      SELF.Q.FIL:Date_SelectedBG = COLOR:None
      SELF.Q.MAT1:FileRef_NormalFG   = COLOR:None
      SELF.Q.MAT1:FileRef_NormalBG   = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedFG = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedBG = COLOR:None
      SELF.Q.MAT1:Description_NormalFG   = COLOR:None
      SELF.Q.MAT1:Description_NormalBG   = COLOR:None
      SELF.Q.MAT1:Description_SelectedFG = COLOR:None
      SELF.Q.MAT1:Description_SelectedBG = COLOR:None
      SELF.Q.STA:Code_NormalFG   = COLOR:None
      SELF.Q.STA:Code_NormalBG   = COLOR:None
      SELF.Q.STA:Code_SelectedFG = COLOR:None
      SELF.Q.STA:Code_SelectedBG = COLOR:None
      SELF.Q.FIL:Description_NormalFG   = COLOR:None
      SELF.Q.FIL:Description_NormalBG   = COLOR:None
      SELF.Q.FIL:Description_SelectedFG = COLOR:None
      SELF.Q.FIL:Description_SelectedBG = COLOR:None
      SELF.Q.LOC:Employee_NormalFG   = COLOR:None
      SELF.Q.LOC:Employee_NormalBG   = COLOR:None
      SELF.Q.LOC:Employee_SelectedFG = COLOR:None
      SELF.Q.LOC:Employee_SelectedBG = COLOR:None
    If (GEMPQ2:Color1 AND CEM:ColorizeFlag AND CEM:ShowJustMyColoursFlag <> 1 AND FIL:Color < 1)
      SELF.Q.Tag_NormalFG   = GEMPQ2:Color1
      SELF.Q.Tag_NormalBG   = GEMPQ2:Color2
      SELF.Q.Tag_SelectedFG = GEMPQ2:Color2
      SELF.Q.Tag_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:ProgressIndicator_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:ProgressIndicator_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:ProgressIndicator_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:ProgressIndicator_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:FileNotePostedFlag_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:FileNotePostedFlag_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:FileNotePostedFlag_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:FileNotePostedFlag_SelectedBG = GEMPQ2:Color1
      SELF.Q.FIL:Date_NormalFG   = GEMPQ2:Color1
      SELF.Q.FIL:Date_NormalBG   = GEMPQ2:Color2
      SELF.Q.FIL:Date_SelectedFG = GEMPQ2:Color2
      SELF.Q.FIL:Date_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT1:FileRef_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT1:FileRef_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT1:FileRef_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT1:FileRef_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT1:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT1:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT1:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT1:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.STA:Code_NormalFG   = GEMPQ2:Color1
      SELF.Q.STA:Code_NormalBG   = GEMPQ2:Color2
      SELF.Q.STA:Code_SelectedFG = GEMPQ2:Color2
      SELF.Q.STA:Code_SelectedBG = GEMPQ2:Color1
      SELF.Q.FIL:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.FIL:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.FIL:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.FIL:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedBG = GEMPQ2:Color1
    End
    If (GEMPQ2:Color1 AND CEM:ColorizeFlag AND CEM:ShowJustMyColoursFlag = 1 AND GEMPQ2:RecordID = CEM:RecordID AND FIL:Color < 1)
      SELF.Q.Tag_NormalFG   = GEMPQ2:Color1
      SELF.Q.Tag_NormalBG   = GEMPQ2:Color2
      SELF.Q.Tag_SelectedFG = GEMPQ2:Color2
      SELF.Q.Tag_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:ProgressIndicator_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:ProgressIndicator_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:ProgressIndicator_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:ProgressIndicator_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:FileNotePostedFlag_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:FileNotePostedFlag_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:FileNotePostedFlag_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:FileNotePostedFlag_SelectedBG = GEMPQ2:Color1
      SELF.Q.FIL:Date_NormalFG   = GEMPQ2:Color1
      SELF.Q.FIL:Date_NormalBG   = GEMPQ2:Color2
      SELF.Q.FIL:Date_SelectedFG = GEMPQ2:Color2
      SELF.Q.FIL:Date_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT1:FileRef_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT1:FileRef_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT1:FileRef_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT1:FileRef_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT1:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT1:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT1:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT1:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.STA:Code_NormalFG   = GEMPQ2:Color1
      SELF.Q.STA:Code_NormalBG   = GEMPQ2:Color2
      SELF.Q.STA:Code_SelectedFG = GEMPQ2:Color2
      SELF.Q.STA:Code_SelectedBG = GEMPQ2:Color1
      SELF.Q.FIL:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.FIL:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.FIL:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.FIL:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedBG = GEMPQ2:Color1
    End
    If (CEM:ColorizeFlag <> 1 AND FIL:InternalFlag AND FIL:Color < 1)
      SELF.Q.Tag_NormalFG   = COLOR:Red
      SELF.Q.Tag_NormalBG   = COLOR:None
      SELF.Q.Tag_SelectedFG = COLOR:None
      SELF.Q.Tag_SelectedBG = COLOR:Red
      SELF.Q.LOC:ProgressIndicator_NormalFG   = COLOR:Red
      SELF.Q.LOC:ProgressIndicator_NormalBG   = COLOR:None
      SELF.Q.LOC:ProgressIndicator_SelectedFG = COLOR:None
      SELF.Q.LOC:ProgressIndicator_SelectedBG = COLOR:Red
      SELF.Q.LOC:FileNotePostedFlag_NormalFG   = COLOR:Red
      SELF.Q.LOC:FileNotePostedFlag_NormalBG   = COLOR:None
      SELF.Q.LOC:FileNotePostedFlag_SelectedFG = COLOR:None
      SELF.Q.LOC:FileNotePostedFlag_SelectedBG = COLOR:Red
      SELF.Q.FIL:Date_NormalFG   = COLOR:Red
      SELF.Q.FIL:Date_NormalBG   = COLOR:None
      SELF.Q.FIL:Date_SelectedFG = COLOR:None
      SELF.Q.FIL:Date_SelectedBG = COLOR:Red
      SELF.Q.MAT1:FileRef_NormalFG   = COLOR:Red
      SELF.Q.MAT1:FileRef_NormalBG   = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedFG = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedBG = COLOR:Red
      SELF.Q.MAT1:Description_NormalFG   = COLOR:Red
      SELF.Q.MAT1:Description_NormalBG   = COLOR:None
      SELF.Q.MAT1:Description_SelectedFG = COLOR:None
      SELF.Q.MAT1:Description_SelectedBG = COLOR:Red
      SELF.Q.STA:Code_NormalFG   = COLOR:Red
      SELF.Q.STA:Code_NormalBG   = COLOR:None
      SELF.Q.STA:Code_SelectedFG = COLOR:None
      SELF.Q.STA:Code_SelectedBG = COLOR:Red
      SELF.Q.FIL:Description_NormalFG   = COLOR:Red
      SELF.Q.FIL:Description_NormalBG   = COLOR:None
      SELF.Q.FIL:Description_SelectedFG = COLOR:None
      SELF.Q.FIL:Description_SelectedBG = COLOR:Red
      SELF.Q.LOC:Employee_NormalFG   = COLOR:Red
      SELF.Q.LOC:Employee_NormalBG   = COLOR:None
      SELF.Q.LOC:Employee_SelectedFG = COLOR:None
      SELF.Q.LOC:Employee_SelectedBG = COLOR:Red
    End
    If (FIL:Color > 0)
      SELF.Q.Tag_NormalFG   = FIL:Color
      SELF.Q.Tag_NormalBG   = COLOR:None
      SELF.Q.Tag_SelectedFG = FIL:Color
      SELF.Q.Tag_SelectedBG = COLOR:None
      SELF.Q.LOC:ProgressIndicator_NormalFG   = FIL:Color
      SELF.Q.LOC:ProgressIndicator_NormalBG   = COLOR:None
      SELF.Q.LOC:ProgressIndicator_SelectedFG = FIL:Color
      SELF.Q.LOC:ProgressIndicator_SelectedBG = COLOR:None
      SELF.Q.LOC:FileNotePostedFlag_NormalFG   = FIL:Color
      SELF.Q.LOC:FileNotePostedFlag_NormalBG   = COLOR:None
      SELF.Q.LOC:FileNotePostedFlag_SelectedFG = FIL:Color
      SELF.Q.LOC:FileNotePostedFlag_SelectedBG = COLOR:None
      SELF.Q.FIL:Date_NormalFG   = FIL:Color
      SELF.Q.FIL:Date_NormalBG   = COLOR:None
      SELF.Q.FIL:Date_SelectedFG = FIL:Color
      SELF.Q.FIL:Date_SelectedBG = COLOR:None
      SELF.Q.MAT1:FileRef_NormalFG   = FIL:Color
      SELF.Q.MAT1:FileRef_NormalBG   = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedFG = FIL:Color
      SELF.Q.MAT1:FileRef_SelectedBG = COLOR:None
      SELF.Q.MAT1:Description_NormalFG   = FIL:Color
      SELF.Q.MAT1:Description_NormalBG   = COLOR:None
      SELF.Q.MAT1:Description_SelectedFG = FIL:Color
      SELF.Q.MAT1:Description_SelectedBG = COLOR:None
      SELF.Q.STA:Code_NormalFG   = FIL:Color
      SELF.Q.STA:Code_NormalBG   = COLOR:None
      SELF.Q.STA:Code_SelectedFG = FIL:Color
      SELF.Q.STA:Code_SelectedBG = COLOR:None
      SELF.Q.FIL:Description_NormalFG   = FIL:Color
      SELF.Q.FIL:Description_NormalBG   = COLOR:None
      SELF.Q.FIL:Description_SelectedFG = FIL:Color
      SELF.Q.FIL:Description_SelectedBG = COLOR:None
      SELF.Q.LOC:Employee_NormalFG   = FIL:Color
      SELF.Q.LOC:Employee_NormalBG   = COLOR:None
      SELF.Q.LOC:Employee_SelectedFG = FIL:Color
      SELF.Q.LOC:Employee_SelectedBG = COLOR:None
    End
    If (FIL:Color > 0 AND FIL:InternalFlag)
      SELF.Q.Tag_NormalFG   = FIL:Color
      SELF.Q.Tag_NormalBG   = COLOR:None
      SELF.Q.Tag_SelectedFG = FIL:Color
      SELF.Q.Tag_SelectedBG = COLOR:Red
      SELF.Q.LOC:ProgressIndicator_NormalFG   = FIL:Color
      SELF.Q.LOC:ProgressIndicator_NormalBG   = COLOR:None
      SELF.Q.LOC:ProgressIndicator_SelectedFG = FIL:Color
      SELF.Q.LOC:ProgressIndicator_SelectedBG = COLOR:Red
      SELF.Q.LOC:FileNotePostedFlag_NormalFG   = FIL:Color
      SELF.Q.LOC:FileNotePostedFlag_NormalBG   = COLOR:None
      SELF.Q.LOC:FileNotePostedFlag_SelectedFG = FIL:Color
      SELF.Q.LOC:FileNotePostedFlag_SelectedBG = COLOR:Red
      SELF.Q.FIL:Date_NormalFG   = FIL:Color
      SELF.Q.FIL:Date_NormalBG   = COLOR:None
      SELF.Q.FIL:Date_SelectedFG = FIL:Color
      SELF.Q.FIL:Date_SelectedBG = COLOR:Red
      SELF.Q.MAT1:FileRef_NormalFG   = FIL:Color
      SELF.Q.MAT1:FileRef_NormalBG   = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedFG = FIL:Color
      SELF.Q.MAT1:FileRef_SelectedBG = COLOR:Red
      SELF.Q.MAT1:Description_NormalFG   = FIL:Color
      SELF.Q.MAT1:Description_NormalBG   = COLOR:None
      SELF.Q.MAT1:Description_SelectedFG = FIL:Color
      SELF.Q.MAT1:Description_SelectedBG = COLOR:Red
      SELF.Q.STA:Code_NormalFG   = FIL:Color
      SELF.Q.STA:Code_NormalBG   = COLOR:None
      SELF.Q.STA:Code_SelectedFG = FIL:Color
      SELF.Q.STA:Code_SelectedBG = COLOR:Red
      SELF.Q.FIL:Description_NormalFG   = FIL:Color
      SELF.Q.FIL:Description_NormalBG   = COLOR:None
      SELF.Q.FIL:Description_SelectedFG = FIL:Color
      SELF.Q.FIL:Description_SelectedBG = COLOR:Red
      SELF.Q.LOC:Employee_NormalFG   = FIL:Color
      SELF.Q.LOC:Employee_NormalBG   = COLOR:None
      SELF.Q.LOC:Employee_SelectedFG = FIL:Color
      SELF.Q.LOC:Employee_SelectedBG = COLOR:Red
    End
   IF LOC:ShowFileNoteIconsFlag
  
      IF CEM:DisplayLargeIconsFlag
         LOC:IconFileName = GetRoot(STA:LargeIconFileName)
      ELSE
         LOC:IconFileName = GetRoot(STA:SmallIconFileName)
      END
  
      IF LOC:IconFileName
      
         ?FileNoteBrowse{PROP:IconList,STA:RecordID+2} = LOC:IconFileName
      
         SELF.Q.LOC:ProgressIndicator_Icon = STA:RecordID+2
      
      ELSE
      
         SELF.Q.LOC:ProgressIndicator_Icon = 0
      
      END
  
   ELSE
   
      SELF.Q.LOC:ProgressIndicator_Icon = 0
   
   END
  
  
  


BRW52.ValidateRecord PROCEDURE

ReturnValue          BYTE,AUTO

BRW52::RecordStatus  BYTE,AUTO
  CODE
  ReturnValue = PARENT.ValidateRecord()
   IF ~GLO:SupervisorFlag
       IF MAT1:Access = 'R' AND ~(CEM:RecordID = MAT1:EmployeeID) THEN RETURN Record:Filtered.
   END
  
   RETURN ReturnValue
  
  BRW52::RecordStatus=ReturnValue
  IF BRW52::RecordStatus NOT=Record:OK THEN RETURN BRW52::RecordStatus.
  IF BRW52::Filter
    IF ~GetTag:PtrM(TAG:FileNote, FIL:RecordID) THEN RETURN Record:Filtered.
  END!IF
  ReturnValue=BRW52::RecordStatus
  RETURN ReturnValue


BRW2.ApplyFilter PROCEDURE

  CODE
   IF ~(CHOICE(?CurrentTab) = 2)
       BRW2::View:Browse{PROP:SQLFilter} = '1=0'
       RETURN
   END


   DO MakeFilterFeenoteString

   IF LOC:FilterFeenoteString
      LOC:FilterFeeNoteSQLString = Replace(LOC:FilterFeenoteString,'FeeNote.','A.')
      BRW2::View:Browse{PROP:SQLFilter} = LOC:FilterFeenoteSQLString
   ELSE
      BRW2::View:Browse{PROP:SQLFilter} = ''
   END

   RETURN
  PARENT.ApplyFilter


BRW2.Ask PROCEDURE(BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Ask(Request)
!  If GlobalResponse = RequestCompleted and (Request = InsertRecord or Request = ChangeRecord)
!    If FN:AddToCollDebitFlag Then AddColDebitFromFeeNote.
!  END
!
! Nick has put this back into UpdateFeeNote now that we can get the RecordID
  
  
  RETURN ReturnValue


BRW2.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert
    SELF.ChangeControl=?Change
    SELF.DeleteControl=?Delete
  END


BRW2.ResetQueue PROCEDURE(BYTE ResetMode)

  CODE
  PARENT.ResetQueue(ResetMode)
!KIMBERLY

  IF Choice(?CurrentTab) = 2

    DO SetFeeNoteOptFilterButton
  
    IF RECORDS(SELF.ListQueue)
       ?PostFeesButton{PROP:Disable} = False
       ?ProformaInvoiceButton{PROP:Disable} = False
       ?AdjustFeesButton{PROP:Disable} = False
       ?UpdateVoucherButton{PROP:Disable} = False
       ?FeeNoteJumpToMatterButton{PROP:Disable} = False

       DO TotalFeeNotes

    ELSE

       ?PostFeesButton{PROP:Disable} = True
       ?ProformaInvoiceButton{PROP:Disable} = True
       ?AdjustFeesButton{PROP:Disable} = True
       ?UpdateVoucherButton{PROP:Disable} = True
       ?FeeNoteJumpToMatterButton{PROP:Disable} = True
  
        ! THE USER IS SHOWING TAGGED RECORDS AND THERE ARE NO RECORDS VISIBLE (MAYBE THEY WERE POSTED)
        IF BRW2::Filter = 1 AND ?FN:OptFilterButton{PROP:Disable} = False
           POST(EVENT:Accepted,?FN:OptFilterButton)  ! SHOW ALL OTHERWISE THE USER IS CONFUSED
        END

       LOC:TotalFees = 0
       LOC:TotalDisb = 0
       DISPLAY(?LOC:TotalDisb)
       DISPLAY(?LOC:TotalFees)


    END

  END
  IF RECORDS(SELF.ListQueue)
    ?TagOne:2{PROP:Disable} = 0
    ?UntagOne:2{PROP:Disable} = 0
    ?TagAll:2{PROP:Disable} = 0
    ?UntagAll:2{PROP:Disable} = 0
  ELSE
    ?TagOne:2{PROP:Disable} = 1
    ?UntagOne:2{PROP:Disable} = 1
    ?TagAll:2{PROP:Disable} = 1
    ?UntagAll:2{PROP:Disable} = 1
  END


BRW2.SetQueueRecord PROCEDURE

  CODE
  LOC:FN:AmountExcl = FN:AmountIncl - FN:VatAmount
  LOC:FN:VatDesc    = GetVatDesc(FN:VatRate,FN:VatIE)

  LOC:Employee = GetEmployeeNameFromQueue(FN:EmployeeID)

  LOC:FeeDescription = FN:Description
  
  IF FN:CombinedQuantity
     LOC:FeeDescription = '(' & CLIP(LEFT(FORMAT(FN:CombinedQuantity,@n_5))) & ') ' & LOC:FeeDescription
  END
  
  If FN:ColDebitId
    LOC:ColDebitWording = 'Yes'
  Else
    LOC:ColDebitWording = 'No'
  .
  
  Tag = CHOOSE(~GetTag:PtrM(TAG:FeeNote, FN:RecordID), '', '*')
  SELF.Q.Tag = Tag
  PARENT.SetQueueRecord
  SELF.Q.Tag_NormalFG = -1
  SELF.Q.Tag_NormalBG = -1
  SELF.Q.Tag_SelectedFG = -1
  SELF.Q.Tag_SelectedBG = -1
  SELF.Q.Tag_Icon = 0
  SELF.Q.LOC:OnHold_NormalFG = -1
  SELF.Q.LOC:OnHold_NormalBG = -1
  SELF.Q.LOC:OnHold_SelectedFG = -1
  SELF.Q.LOC:OnHold_SelectedBG = -1
  IF (FN:OnHold OR MAT1:FeeNotesOnHold)
    SELF.Q.LOC:OnHold_Icon = 5
  ELSE
    SELF.Q.LOC:OnHold_Icon = 4
  END
  SELF.Q.LOC:PostedFlag_NormalFG = -1
  SELF.Q.LOC:PostedFlag_NormalBG = -1
  SELF.Q.LOC:PostedFlag_SelectedFG = -1
  SELF.Q.LOC:PostedFlag_SelectedBG = -1
  IF (FN:PostedFlag=1)
    SELF.Q.LOC:PostedFlag_Icon = 3
  ELSE
    SELF.Q.LOC:PostedFlag_Icon = 4
  END
  SELF.Q.FN:Date_NormalFG = -1
  SELF.Q.FN:Date_NormalBG = -1
  SELF.Q.FN:Date_SelectedFG = -1
  SELF.Q.FN:Date_SelectedBG = -1
  SELF.Q.MAT1:FileRef_NormalFG = -1
  SELF.Q.MAT1:FileRef_NormalBG = -1
  SELF.Q.MAT1:FileRef_SelectedFG = -1
  SELF.Q.MAT1:FileRef_SelectedBG = -1
  SELF.Q.MAT1:Description_NormalFG = -1
  SELF.Q.MAT1:Description_NormalBG = -1
  SELF.Q.MAT1:Description_SelectedFG = -1
  SELF.Q.MAT1:Description_SelectedBG = -1
  SELF.Q.PAR1:Name_NormalFG = -1
  SELF.Q.PAR1:Name_NormalBG = -1
  SELF.Q.PAR1:Name_SelectedFG = -1
  SELF.Q.PAR1:Name_SelectedBG = -1
  SELF.Q.LOC:FeeDescription_NormalFG = -1
  SELF.Q.LOC:FeeDescription_NormalBG = -1
  SELF.Q.LOC:FeeDescription_SelectedFG = -1
  SELF.Q.LOC:FeeDescription_SelectedBG = -1
  SELF.Q.LOC:FN:AmountExcl_NormalFG = -1
  SELF.Q.LOC:FN:AmountExcl_NormalBG = -1
  SELF.Q.LOC:FN:AmountExcl_SelectedFG = -1
  SELF.Q.LOC:FN:AmountExcl_SelectedBG = -1
  SELF.Q.FN:VatAmount_NormalFG = -1
  SELF.Q.FN:VatAmount_NormalBG = -1
  SELF.Q.FN:VatAmount_SelectedFG = -1
  SELF.Q.FN:VatAmount_SelectedBG = -1
  SELF.Q.FN:AmountIncl_NormalFG = -1
  SELF.Q.FN:AmountIncl_NormalBG = -1
  SELF.Q.FN:AmountIncl_SelectedFG = -1
  SELF.Q.FN:AmountIncl_SelectedBG = -1
  SELF.Q.FN:CapturedPeriod_NormalFG = -1
  SELF.Q.FN:CapturedPeriod_NormalBG = -1
  SELF.Q.FN:CapturedPeriod_SelectedFG = -1
  SELF.Q.FN:CapturedPeriod_SelectedBG = -1
  SELF.Q.LOC:FN:VatDesc_NormalFG = -1
  SELF.Q.LOC:FN:VatDesc_NormalBG = -1
  SELF.Q.LOC:FN:VatDesc_SelectedFG = -1
  SELF.Q.LOC:FN:VatDesc_SelectedBG = -1
  SELF.Q.LOC:Employee_NormalFG = -1
  SELF.Q.LOC:Employee_NormalBG = -1
  SELF.Q.LOC:Employee_SelectedFG = -1
  SELF.Q.LOC:Employee_SelectedBG = -1
  SELF.Q.FN:Voucher_NormalFG = -1
  SELF.Q.FN:Voucher_NormalBG = -1
  SELF.Q.FN:Voucher_SelectedFG = -1
  SELF.Q.FN:Voucher_SelectedBG = -1
  SELF.Q.COS:Description_NormalFG = -1
  SELF.Q.COS:Description_NormalBG = -1
  SELF.Q.COS:Description_SelectedFG = -1
  SELF.Q.COS:Description_SelectedBG = -1
  SELF.Q.LOC:ColDebitWording_NormalFG = -1
  SELF.Q.LOC:ColDebitWording_NormalBG = -1
  SELF.Q.LOC:ColDebitWording_SelectedFG = -1
  SELF.Q.LOC:ColDebitWording_SelectedBG = -1
  SELF.Q.FN:PostedDate_NormalFG = -1
  SELF.Q.FN:PostedDate_NormalBG = -1
  SELF.Q.FN:PostedDate_SelectedFG = -1
  SELF.Q.FN:PostedDate_SelectedBG = -1
  SELF.Q.FN:PostedBatchId_NormalFG = -1
  SELF.Q.FN:PostedBatchId_NormalBG = -1
  SELF.Q.FN:PostedBatchId_SelectedFG = -1
  SELF.Q.FN:PostedBatchId_SelectedBG = -1
  IF Tag
    Queue:Browse.Tag_Icon = 2
  ELSE
    Queue:Browse.Tag_Icon = 1
  END!IF
      SELF.Q.Tag_NormalFG   = COLOR:NONE
      SELF.Q.Tag_NormalBG   = COLOR:NONE
      SELF.Q.Tag_SelectedFG = COLOR:NONE
      SELF.Q.Tag_SelectedBG = COLOR:NONE
      SELF.Q.LOC:OnHold_NormalFG   = COLOR:NONE
      SELF.Q.LOC:OnHold_NormalBG   = COLOR:NONE
      SELF.Q.LOC:OnHold_SelectedFG = COLOR:NONE
      SELF.Q.LOC:OnHold_SelectedBG = COLOR:NONE
      SELF.Q.LOC:PostedFlag_NormalFG   = COLOR:NONE
      SELF.Q.LOC:PostedFlag_NormalBG   = COLOR:NONE
      SELF.Q.LOC:PostedFlag_SelectedFG = COLOR:NONE
      SELF.Q.LOC:PostedFlag_SelectedBG = COLOR:NONE
      SELF.Q.FN:Date_NormalFG   = COLOR:NONE
      SELF.Q.FN:Date_NormalBG   = COLOR:NONE
      SELF.Q.FN:Date_SelectedFG = COLOR:NONE
      SELF.Q.FN:Date_SelectedBG = COLOR:NONE
      SELF.Q.MAT1:FileRef_NormalFG   = COLOR:NONE
      SELF.Q.MAT1:FileRef_NormalBG   = COLOR:NONE
      SELF.Q.MAT1:FileRef_SelectedFG = COLOR:NONE
      SELF.Q.MAT1:FileRef_SelectedBG = COLOR:NONE
      SELF.Q.MAT1:Description_NormalFG   = COLOR:NONE
      SELF.Q.MAT1:Description_NormalBG   = COLOR:NONE
      SELF.Q.MAT1:Description_SelectedFG = COLOR:NONE
      SELF.Q.MAT1:Description_SelectedBG = COLOR:NONE
      SELF.Q.PAR1:Name_NormalFG   = COLOR:NONE
      SELF.Q.PAR1:Name_NormalBG   = COLOR:NONE
      SELF.Q.PAR1:Name_SelectedFG = COLOR:NONE
      SELF.Q.PAR1:Name_SelectedBG = COLOR:NONE
      SELF.Q.LOC:FeeDescription_NormalFG   = COLOR:NONE
      SELF.Q.LOC:FeeDescription_NormalBG   = COLOR:NONE
      SELF.Q.LOC:FeeDescription_SelectedFG = COLOR:NONE
      SELF.Q.LOC:FeeDescription_SelectedBG = COLOR:NONE
      SELF.Q.LOC:FN:AmountExcl_NormalFG   = COLOR:NONE
      SELF.Q.LOC:FN:AmountExcl_NormalBG   = COLOR:NONE
      SELF.Q.LOC:FN:AmountExcl_SelectedFG = COLOR:NONE
      SELF.Q.LOC:FN:AmountExcl_SelectedBG = COLOR:NONE
      SELF.Q.FN:VatAmount_NormalFG   = COLOR:NONE
      SELF.Q.FN:VatAmount_NormalBG   = COLOR:NONE
      SELF.Q.FN:VatAmount_SelectedFG = COLOR:NONE
      SELF.Q.FN:VatAmount_SelectedBG = COLOR:NONE
      SELF.Q.FN:AmountIncl_NormalFG   = COLOR:NONE
      SELF.Q.FN:AmountIncl_NormalBG   = COLOR:NONE
      SELF.Q.FN:AmountIncl_SelectedFG = COLOR:NONE
      SELF.Q.FN:AmountIncl_SelectedBG = COLOR:NONE
      SELF.Q.FN:CapturedPeriod_NormalFG   = COLOR:NONE
      SELF.Q.FN:CapturedPeriod_NormalBG   = COLOR:NONE
      SELF.Q.FN:CapturedPeriod_SelectedFG = COLOR:NONE
      SELF.Q.FN:CapturedPeriod_SelectedBG = COLOR:NONE
      SELF.Q.LOC:FN:VatDesc_NormalFG   = COLOR:NONE
      SELF.Q.LOC:FN:VatDesc_NormalBG   = COLOR:NONE
      SELF.Q.LOC:FN:VatDesc_SelectedFG = COLOR:NONE
      SELF.Q.LOC:FN:VatDesc_SelectedBG = COLOR:NONE
      SELF.Q.LOC:Employee_NormalFG   = COLOR:NONE
      SELF.Q.LOC:Employee_NormalBG   = COLOR:NONE
      SELF.Q.LOC:Employee_SelectedFG = COLOR:NONE
      SELF.Q.LOC:Employee_SelectedBG = COLOR:NONE
      SELF.Q.FN:Voucher_NormalFG   = COLOR:NONE
      SELF.Q.FN:Voucher_NormalBG   = COLOR:NONE
      SELF.Q.FN:Voucher_SelectedFG = COLOR:NONE
      SELF.Q.FN:Voucher_SelectedBG = COLOR:NONE
      SELF.Q.COS:Description_NormalFG   = COLOR:NONE
      SELF.Q.COS:Description_NormalBG   = COLOR:NONE
      SELF.Q.COS:Description_SelectedFG = COLOR:NONE
      SELF.Q.COS:Description_SelectedBG = COLOR:NONE
      SELF.Q.LOC:ColDebitWording_NormalFG   = COLOR:NONE
      SELF.Q.LOC:ColDebitWording_NormalBG   = COLOR:NONE
      SELF.Q.LOC:ColDebitWording_SelectedFG = COLOR:NONE
      SELF.Q.LOC:ColDebitWording_SelectedBG = COLOR:NONE
      SELF.Q.FN:PostedDate_NormalFG   = COLOR:NONE
      SELF.Q.FN:PostedDate_NormalBG   = COLOR:NONE
      SELF.Q.FN:PostedDate_SelectedFG = COLOR:NONE
      SELF.Q.FN:PostedDate_SelectedBG = COLOR:NONE
      SELF.Q.FN:PostedBatchId_NormalFG   = COLOR:NONE
      SELF.Q.FN:PostedBatchId_NormalBG   = COLOR:NONE
      SELF.Q.FN:PostedBatchId_SelectedFG = COLOR:NONE
      SELF.Q.FN:PostedBatchId_SelectedBG = COLOR:NONE
    If (CEM:ColorizeFlag <> 1 AND FN:Type1 = 'D')
      SELF.Q.Tag_NormalFG   = COLOR:Green
      SELF.Q.Tag_NormalBG   = COLOR:None
      SELF.Q.Tag_SelectedFG = COLOR:None
      SELF.Q.Tag_SelectedBG = COLOR:Green
      SELF.Q.LOC:OnHold_NormalFG   = COLOR:Green
      SELF.Q.LOC:OnHold_NormalBG   = COLOR:None
      SELF.Q.LOC:OnHold_SelectedFG = COLOR:None
      SELF.Q.LOC:OnHold_SelectedBG = COLOR:Green
      SELF.Q.LOC:PostedFlag_NormalFG   = COLOR:Green
      SELF.Q.LOC:PostedFlag_NormalBG   = COLOR:None
      SELF.Q.LOC:PostedFlag_SelectedFG = COLOR:None
      SELF.Q.LOC:PostedFlag_SelectedBG = COLOR:Green
      SELF.Q.FN:Date_NormalFG   = COLOR:Green
      SELF.Q.FN:Date_NormalBG   = COLOR:None
      SELF.Q.FN:Date_SelectedFG = COLOR:None
      SELF.Q.FN:Date_SelectedBG = COLOR:Green
      SELF.Q.MAT1:FileRef_NormalFG   = COLOR:Green
      SELF.Q.MAT1:FileRef_NormalBG   = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedFG = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedBG = COLOR:Green
      SELF.Q.MAT1:Description_NormalFG   = COLOR:Green
      SELF.Q.MAT1:Description_NormalBG   = COLOR:None
      SELF.Q.MAT1:Description_SelectedFG = COLOR:None
      SELF.Q.MAT1:Description_SelectedBG = COLOR:Green
      SELF.Q.PAR1:Name_NormalFG   = COLOR:Green
      SELF.Q.PAR1:Name_NormalBG   = COLOR:None
      SELF.Q.PAR1:Name_SelectedFG = COLOR:None
      SELF.Q.PAR1:Name_SelectedBG = COLOR:Green
      SELF.Q.LOC:FeeDescription_NormalFG   = COLOR:Green
      SELF.Q.LOC:FeeDescription_NormalBG   = COLOR:None
      SELF.Q.LOC:FeeDescription_SelectedFG = COLOR:None
      SELF.Q.LOC:FeeDescription_SelectedBG = COLOR:Green
      SELF.Q.LOC:FN:AmountExcl_NormalFG   = COLOR:Green
      SELF.Q.LOC:FN:AmountExcl_NormalBG   = COLOR:None
      SELF.Q.LOC:FN:AmountExcl_SelectedFG = COLOR:None
      SELF.Q.LOC:FN:AmountExcl_SelectedBG = COLOR:Green
      SELF.Q.FN:VatAmount_NormalFG   = COLOR:Green
      SELF.Q.FN:VatAmount_NormalBG   = COLOR:None
      SELF.Q.FN:VatAmount_SelectedFG = COLOR:None
      SELF.Q.FN:VatAmount_SelectedBG = COLOR:Green
      SELF.Q.FN:AmountIncl_NormalFG   = COLOR:Green
      SELF.Q.FN:AmountIncl_NormalBG   = COLOR:None
      SELF.Q.FN:AmountIncl_SelectedFG = COLOR:None
      SELF.Q.FN:AmountIncl_SelectedBG = COLOR:Green
      SELF.Q.FN:CapturedPeriod_NormalFG   = COLOR:Green
      SELF.Q.FN:CapturedPeriod_NormalBG   = COLOR:None
      SELF.Q.FN:CapturedPeriod_SelectedFG = COLOR:None
      SELF.Q.FN:CapturedPeriod_SelectedBG = COLOR:Green
      SELF.Q.LOC:FN:VatDesc_NormalFG   = COLOR:Green
      SELF.Q.LOC:FN:VatDesc_NormalBG   = COLOR:None
      SELF.Q.LOC:FN:VatDesc_SelectedFG = COLOR:None
      SELF.Q.LOC:FN:VatDesc_SelectedBG = COLOR:Green
      SELF.Q.LOC:Employee_NormalFG   = COLOR:Green
      SELF.Q.LOC:Employee_NormalBG   = COLOR:None
      SELF.Q.LOC:Employee_SelectedFG = COLOR:None
      SELF.Q.LOC:Employee_SelectedBG = COLOR:Green
      SELF.Q.FN:Voucher_NormalFG   = COLOR:Green
      SELF.Q.FN:Voucher_NormalBG   = COLOR:None
      SELF.Q.FN:Voucher_SelectedFG = COLOR:None
      SELF.Q.FN:Voucher_SelectedBG = COLOR:Green
      SELF.Q.COS:Description_NormalFG   = COLOR:Green
      SELF.Q.COS:Description_NormalBG   = COLOR:None
      SELF.Q.COS:Description_SelectedFG = COLOR:None
      SELF.Q.COS:Description_SelectedBG = COLOR:Green
      SELF.Q.LOC:ColDebitWording_NormalFG   = COLOR:Green
      SELF.Q.LOC:ColDebitWording_NormalBG   = COLOR:None
      SELF.Q.LOC:ColDebitWording_SelectedFG = COLOR:None
      SELF.Q.LOC:ColDebitWording_SelectedBG = COLOR:Green
      SELF.Q.FN:PostedDate_NormalFG   = COLOR:Green
      SELF.Q.FN:PostedDate_NormalBG   = COLOR:None
      SELF.Q.FN:PostedDate_SelectedFG = COLOR:None
      SELF.Q.FN:PostedDate_SelectedBG = COLOR:Green
      SELF.Q.FN:PostedBatchId_NormalFG   = COLOR:Green
      SELF.Q.FN:PostedBatchId_NormalBG   = COLOR:None
      SELF.Q.FN:PostedBatchId_SelectedFG = COLOR:None
      SELF.Q.FN:PostedBatchId_SelectedBG = COLOR:Green
    End
    If (CEM:ColorizeFlag <> 1 AND FN:Type1 = 'R')
      SELF.Q.Tag_NormalFG   = COLOR:Teal
      SELF.Q.Tag_NormalBG   = COLOR:None
      SELF.Q.Tag_SelectedFG = COLOR:None
      SELF.Q.Tag_SelectedBG = COLOR:Teal
      SELF.Q.LOC:OnHold_NormalFG   = COLOR:Teal
      SELF.Q.LOC:OnHold_NormalBG   = COLOR:None
      SELF.Q.LOC:OnHold_SelectedFG = COLOR:None
      SELF.Q.LOC:OnHold_SelectedBG = COLOR:Teal
      SELF.Q.LOC:PostedFlag_NormalFG   = COLOR:Teal
      SELF.Q.LOC:PostedFlag_NormalBG   = COLOR:None
      SELF.Q.LOC:PostedFlag_SelectedFG = COLOR:None
      SELF.Q.LOC:PostedFlag_SelectedBG = COLOR:Teal
      SELF.Q.FN:Date_NormalFG   = COLOR:Teal
      SELF.Q.FN:Date_NormalBG   = COLOR:None
      SELF.Q.FN:Date_SelectedFG = COLOR:None
      SELF.Q.FN:Date_SelectedBG = COLOR:Teal
      SELF.Q.MAT1:FileRef_NormalFG   = COLOR:Teal
      SELF.Q.MAT1:FileRef_NormalBG   = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedFG = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedBG = COLOR:Teal
      SELF.Q.MAT1:Description_NormalFG   = COLOR:Teal
      SELF.Q.MAT1:Description_NormalBG   = COLOR:None
      SELF.Q.MAT1:Description_SelectedFG = COLOR:None
      SELF.Q.MAT1:Description_SelectedBG = COLOR:Teal
      SELF.Q.PAR1:Name_NormalFG   = COLOR:Teal
      SELF.Q.PAR1:Name_NormalBG   = COLOR:None
      SELF.Q.PAR1:Name_SelectedFG = COLOR:None
      SELF.Q.PAR1:Name_SelectedBG = COLOR:Teal
      SELF.Q.LOC:FeeDescription_NormalFG   = COLOR:Teal
      SELF.Q.LOC:FeeDescription_NormalBG   = COLOR:None
      SELF.Q.LOC:FeeDescription_SelectedFG = COLOR:None
      SELF.Q.LOC:FeeDescription_SelectedBG = COLOR:Teal
      SELF.Q.LOC:FN:AmountExcl_NormalFG   = COLOR:Teal
      SELF.Q.LOC:FN:AmountExcl_NormalBG   = COLOR:None
      SELF.Q.LOC:FN:AmountExcl_SelectedFG = COLOR:None
      SELF.Q.LOC:FN:AmountExcl_SelectedBG = COLOR:Teal
      SELF.Q.FN:VatAmount_NormalFG   = COLOR:Teal
      SELF.Q.FN:VatAmount_NormalBG   = COLOR:None
      SELF.Q.FN:VatAmount_SelectedFG = COLOR:None
      SELF.Q.FN:VatAmount_SelectedBG = COLOR:Teal
      SELF.Q.FN:AmountIncl_NormalFG   = COLOR:Teal
      SELF.Q.FN:AmountIncl_NormalBG   = COLOR:None
      SELF.Q.FN:AmountIncl_SelectedFG = COLOR:None
      SELF.Q.FN:AmountIncl_SelectedBG = COLOR:Teal
      SELF.Q.FN:CapturedPeriod_NormalFG   = COLOR:Teal
      SELF.Q.FN:CapturedPeriod_NormalBG   = COLOR:None
      SELF.Q.FN:CapturedPeriod_SelectedFG = COLOR:None
      SELF.Q.FN:CapturedPeriod_SelectedBG = COLOR:Teal
      SELF.Q.LOC:FN:VatDesc_NormalFG   = COLOR:Teal
      SELF.Q.LOC:FN:VatDesc_NormalBG   = COLOR:None
      SELF.Q.LOC:FN:VatDesc_SelectedFG = COLOR:None
      SELF.Q.LOC:FN:VatDesc_SelectedBG = COLOR:Teal
      SELF.Q.LOC:Employee_NormalFG   = COLOR:Teal
      SELF.Q.LOC:Employee_NormalBG   = COLOR:None
      SELF.Q.LOC:Employee_SelectedFG = COLOR:None
      SELF.Q.LOC:Employee_SelectedBG = COLOR:Teal
      SELF.Q.FN:Voucher_NormalFG   = COLOR:Teal
      SELF.Q.FN:Voucher_NormalBG   = COLOR:None
      SELF.Q.FN:Voucher_SelectedFG = COLOR:None
      SELF.Q.FN:Voucher_SelectedBG = COLOR:Teal
      SELF.Q.COS:Description_NormalFG   = COLOR:Teal
      SELF.Q.COS:Description_NormalBG   = COLOR:None
      SELF.Q.COS:Description_SelectedFG = COLOR:None
      SELF.Q.COS:Description_SelectedBG = COLOR:Teal
      SELF.Q.LOC:ColDebitWording_NormalFG   = COLOR:Teal
      SELF.Q.LOC:ColDebitWording_NormalBG   = COLOR:None
      SELF.Q.LOC:ColDebitWording_SelectedFG = COLOR:None
      SELF.Q.LOC:ColDebitWording_SelectedBG = COLOR:Teal
      SELF.Q.FN:PostedDate_NormalFG   = COLOR:Teal
      SELF.Q.FN:PostedDate_NormalBG   = COLOR:None
      SELF.Q.FN:PostedDate_SelectedFG = COLOR:None
      SELF.Q.FN:PostedDate_SelectedBG = COLOR:Teal
      SELF.Q.FN:PostedBatchId_NormalFG   = COLOR:Teal
      SELF.Q.FN:PostedBatchId_NormalBG   = COLOR:None
      SELF.Q.FN:PostedBatchId_SelectedFG = COLOR:None
      SELF.Q.FN:PostedBatchId_SelectedBG = COLOR:Teal
    End
    If (CEM:ColorizeFlag <> 1 AND FN:Type1 = 'C')
      SELF.Q.Tag_NormalFG   = 0808040H
      SELF.Q.Tag_NormalBG   = COLOR:None
      SELF.Q.Tag_SelectedFG = COLOR:None
      SELF.Q.Tag_SelectedBG = 0808040H
      SELF.Q.LOC:OnHold_NormalFG   = 0808040H
      SELF.Q.LOC:OnHold_NormalBG   = COLOR:None
      SELF.Q.LOC:OnHold_SelectedFG = COLOR:None
      SELF.Q.LOC:OnHold_SelectedBG = 0808040H
      SELF.Q.LOC:PostedFlag_NormalFG   = 0808040H
      SELF.Q.LOC:PostedFlag_NormalBG   = COLOR:None
      SELF.Q.LOC:PostedFlag_SelectedFG = COLOR:None
      SELF.Q.LOC:PostedFlag_SelectedBG = 0808040H
      SELF.Q.FN:Date_NormalFG   = 0808040H
      SELF.Q.FN:Date_NormalBG   = COLOR:None
      SELF.Q.FN:Date_SelectedFG = COLOR:None
      SELF.Q.FN:Date_SelectedBG = 0808040H
      SELF.Q.MAT1:FileRef_NormalFG   = 0808040H
      SELF.Q.MAT1:FileRef_NormalBG   = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedFG = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedBG = 0808040H
      SELF.Q.MAT1:Description_NormalFG   = 0808040H
      SELF.Q.MAT1:Description_NormalBG   = COLOR:None
      SELF.Q.MAT1:Description_SelectedFG = COLOR:None
      SELF.Q.MAT1:Description_SelectedBG = 0808040H
      SELF.Q.PAR1:Name_NormalFG   = 0808040H
      SELF.Q.PAR1:Name_NormalBG   = COLOR:None
      SELF.Q.PAR1:Name_SelectedFG = COLOR:None
      SELF.Q.PAR1:Name_SelectedBG = 0808040H
      SELF.Q.LOC:FeeDescription_NormalFG   = 0808040H
      SELF.Q.LOC:FeeDescription_NormalBG   = COLOR:None
      SELF.Q.LOC:FeeDescription_SelectedFG = COLOR:None
      SELF.Q.LOC:FeeDescription_SelectedBG = 0808040H
      SELF.Q.LOC:FN:AmountExcl_NormalFG   = 0808040H
      SELF.Q.LOC:FN:AmountExcl_NormalBG   = COLOR:None
      SELF.Q.LOC:FN:AmountExcl_SelectedFG = COLOR:None
      SELF.Q.LOC:FN:AmountExcl_SelectedBG = 0808040H
      SELF.Q.FN:VatAmount_NormalFG   = 0808040H
      SELF.Q.FN:VatAmount_NormalBG   = COLOR:None
      SELF.Q.FN:VatAmount_SelectedFG = COLOR:None
      SELF.Q.FN:VatAmount_SelectedBG = 0808040H
      SELF.Q.FN:AmountIncl_NormalFG   = 0808040H
      SELF.Q.FN:AmountIncl_NormalBG   = COLOR:None
      SELF.Q.FN:AmountIncl_SelectedFG = COLOR:None
      SELF.Q.FN:AmountIncl_SelectedBG = 0808040H
      SELF.Q.FN:CapturedPeriod_NormalFG   = 0808040H
      SELF.Q.FN:CapturedPeriod_NormalBG   = COLOR:None
      SELF.Q.FN:CapturedPeriod_SelectedFG = COLOR:None
      SELF.Q.FN:CapturedPeriod_SelectedBG = 0808040H
      SELF.Q.LOC:FN:VatDesc_NormalFG   = 0808040H
      SELF.Q.LOC:FN:VatDesc_NormalBG   = COLOR:None
      SELF.Q.LOC:FN:VatDesc_SelectedFG = COLOR:None
      SELF.Q.LOC:FN:VatDesc_SelectedBG = 0808040H
      SELF.Q.LOC:Employee_NormalFG   = 0808040H
      SELF.Q.LOC:Employee_NormalBG   = COLOR:None
      SELF.Q.LOC:Employee_SelectedFG = COLOR:None
      SELF.Q.LOC:Employee_SelectedBG = 0808040H
      SELF.Q.FN:Voucher_NormalFG   = 0808040H
      SELF.Q.FN:Voucher_NormalBG   = COLOR:None
      SELF.Q.FN:Voucher_SelectedFG = COLOR:None
      SELF.Q.FN:Voucher_SelectedBG = 0808040H
      SELF.Q.COS:Description_NormalFG   = 0808040H
      SELF.Q.COS:Description_NormalBG   = COLOR:None
      SELF.Q.COS:Description_SelectedFG = COLOR:None
      SELF.Q.COS:Description_SelectedBG = 0808040H
      SELF.Q.LOC:ColDebitWording_NormalFG   = 0808040H
      SELF.Q.LOC:ColDebitWording_NormalBG   = COLOR:None
      SELF.Q.LOC:ColDebitWording_SelectedFG = COLOR:None
      SELF.Q.LOC:ColDebitWording_SelectedBG = 0808040H
      SELF.Q.FN:PostedDate_NormalFG   = 0808040H
      SELF.Q.FN:PostedDate_NormalBG   = COLOR:None
      SELF.Q.FN:PostedDate_SelectedFG = COLOR:None
      SELF.Q.FN:PostedDate_SelectedBG = 0808040H
      SELF.Q.FN:PostedBatchId_NormalFG   = 0808040H
      SELF.Q.FN:PostedBatchId_NormalBG   = COLOR:None
      SELF.Q.FN:PostedBatchId_SelectedFG = COLOR:None
      SELF.Q.FN:PostedBatchId_SelectedBG = 0808040H
    End
    If (GEMPQ2:Color1 AND CEM:ColorizeFlag AND CEM:ShowJustMyColoursFlag <> 1)
      SELF.Q.Tag_NormalFG   = GEMPQ2:Color1
      SELF.Q.Tag_NormalBG   = GEMPQ2:Color2
      SELF.Q.Tag_SelectedFG = GEMPQ2:Color2
      SELF.Q.Tag_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:OnHold_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:OnHold_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:OnHold_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:OnHold_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:PostedFlag_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:PostedFlag_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:PostedFlag_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:PostedFlag_SelectedBG = GEMPQ2:Color1
      SELF.Q.FN:Date_NormalFG   = GEMPQ2:Color1
      SELF.Q.FN:Date_NormalBG   = GEMPQ2:Color2
      SELF.Q.FN:Date_SelectedFG = GEMPQ2:Color2
      SELF.Q.FN:Date_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT1:FileRef_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT1:FileRef_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT1:FileRef_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT1:FileRef_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT1:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT1:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT1:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT1:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.PAR1:Name_NormalFG   = GEMPQ2:Color1
      SELF.Q.PAR1:Name_NormalBG   = GEMPQ2:Color2
      SELF.Q.PAR1:Name_SelectedFG = GEMPQ2:Color2
      SELF.Q.PAR1:Name_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:FeeDescription_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:FeeDescription_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:FeeDescription_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:FeeDescription_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:FN:AmountExcl_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:FN:AmountExcl_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:FN:AmountExcl_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:FN:AmountExcl_SelectedBG = GEMPQ2:Color1
      SELF.Q.FN:VatAmount_NormalFG   = GEMPQ2:Color1
      SELF.Q.FN:VatAmount_NormalBG   = GEMPQ2:Color2
      SELF.Q.FN:VatAmount_SelectedFG = GEMPQ2:Color2
      SELF.Q.FN:VatAmount_SelectedBG = GEMPQ2:Color1
      SELF.Q.FN:AmountIncl_NormalFG   = GEMPQ2:Color1
      SELF.Q.FN:AmountIncl_NormalBG   = GEMPQ2:Color2
      SELF.Q.FN:AmountIncl_SelectedFG = GEMPQ2:Color2
      SELF.Q.FN:AmountIncl_SelectedBG = GEMPQ2:Color1
      SELF.Q.FN:CapturedPeriod_NormalFG   = GEMPQ2:Color1
      SELF.Q.FN:CapturedPeriod_NormalBG   = GEMPQ2:Color2
      SELF.Q.FN:CapturedPeriod_SelectedFG = GEMPQ2:Color2
      SELF.Q.FN:CapturedPeriod_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:FN:VatDesc_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:FN:VatDesc_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:FN:VatDesc_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:FN:VatDesc_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedBG = GEMPQ2:Color1
      SELF.Q.FN:Voucher_NormalFG   = GEMPQ2:Color1
      SELF.Q.FN:Voucher_NormalBG   = GEMPQ2:Color2
      SELF.Q.FN:Voucher_SelectedFG = GEMPQ2:Color2
      SELF.Q.FN:Voucher_SelectedBG = GEMPQ2:Color1
      SELF.Q.COS:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.COS:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.COS:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.COS:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:ColDebitWording_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:ColDebitWording_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:ColDebitWording_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:ColDebitWording_SelectedBG = GEMPQ2:Color1
      SELF.Q.FN:PostedDate_NormalFG   = GEMPQ2:Color1
      SELF.Q.FN:PostedDate_NormalBG   = GEMPQ2:Color2
      SELF.Q.FN:PostedDate_SelectedFG = GEMPQ2:Color2
      SELF.Q.FN:PostedDate_SelectedBG = GEMPQ2:Color1
      SELF.Q.FN:PostedBatchId_NormalFG   = GEMPQ2:Color1
      SELF.Q.FN:PostedBatchId_NormalBG   = GEMPQ2:Color2
      SELF.Q.FN:PostedBatchId_SelectedFG = GEMPQ2:Color2
      SELF.Q.FN:PostedBatchId_SelectedBG = GEMPQ2:Color1
    End
    If (GEMPQ2:Color1 AND CEM:ColorizeFlag AND CEM:ShowJustMyColoursFlag = 1 AND GEMPQ2:RecordID = CEM:RecordID)
      SELF.Q.Tag_NormalFG   = GEMPQ2:Color1
      SELF.Q.Tag_NormalBG   = GEMPQ2:Color2
      SELF.Q.Tag_SelectedFG = GEMPQ2:Color2
      SELF.Q.Tag_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:OnHold_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:OnHold_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:OnHold_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:OnHold_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:PostedFlag_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:PostedFlag_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:PostedFlag_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:PostedFlag_SelectedBG = GEMPQ2:Color1
      SELF.Q.FN:Date_NormalFG   = GEMPQ2:Color1
      SELF.Q.FN:Date_NormalBG   = GEMPQ2:Color2
      SELF.Q.FN:Date_SelectedFG = GEMPQ2:Color2
      SELF.Q.FN:Date_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT1:FileRef_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT1:FileRef_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT1:FileRef_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT1:FileRef_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT1:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT1:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT1:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT1:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.PAR1:Name_NormalFG   = GEMPQ2:Color1
      SELF.Q.PAR1:Name_NormalBG   = GEMPQ2:Color2
      SELF.Q.PAR1:Name_SelectedFG = GEMPQ2:Color2
      SELF.Q.PAR1:Name_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:FeeDescription_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:FeeDescription_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:FeeDescription_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:FeeDescription_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:FN:AmountExcl_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:FN:AmountExcl_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:FN:AmountExcl_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:FN:AmountExcl_SelectedBG = GEMPQ2:Color1
      SELF.Q.FN:VatAmount_NormalFG   = GEMPQ2:Color1
      SELF.Q.FN:VatAmount_NormalBG   = GEMPQ2:Color2
      SELF.Q.FN:VatAmount_SelectedFG = GEMPQ2:Color2
      SELF.Q.FN:VatAmount_SelectedBG = GEMPQ2:Color1
      SELF.Q.FN:AmountIncl_NormalFG   = GEMPQ2:Color1
      SELF.Q.FN:AmountIncl_NormalBG   = GEMPQ2:Color2
      SELF.Q.FN:AmountIncl_SelectedFG = GEMPQ2:Color2
      SELF.Q.FN:AmountIncl_SelectedBG = GEMPQ2:Color1
      SELF.Q.FN:CapturedPeriod_NormalFG   = GEMPQ2:Color1
      SELF.Q.FN:CapturedPeriod_NormalBG   = GEMPQ2:Color2
      SELF.Q.FN:CapturedPeriod_SelectedFG = GEMPQ2:Color2
      SELF.Q.FN:CapturedPeriod_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:FN:VatDesc_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:FN:VatDesc_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:FN:VatDesc_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:FN:VatDesc_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedBG = GEMPQ2:Color1
      SELF.Q.FN:Voucher_NormalFG   = GEMPQ2:Color1
      SELF.Q.FN:Voucher_NormalBG   = GEMPQ2:Color2
      SELF.Q.FN:Voucher_SelectedFG = GEMPQ2:Color2
      SELF.Q.FN:Voucher_SelectedBG = GEMPQ2:Color1
      SELF.Q.COS:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.COS:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.COS:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.COS:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:ColDebitWording_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:ColDebitWording_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:ColDebitWording_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:ColDebitWording_SelectedBG = GEMPQ2:Color1
      SELF.Q.FN:PostedDate_NormalFG   = GEMPQ2:Color1
      SELF.Q.FN:PostedDate_NormalBG   = GEMPQ2:Color2
      SELF.Q.FN:PostedDate_SelectedFG = GEMPQ2:Color2
      SELF.Q.FN:PostedDate_SelectedBG = GEMPQ2:Color1
      SELF.Q.FN:PostedBatchId_NormalFG   = GEMPQ2:Color1
      SELF.Q.FN:PostedBatchId_NormalBG   = GEMPQ2:Color2
      SELF.Q.FN:PostedBatchId_SelectedFG = GEMPQ2:Color2
      SELF.Q.FN:PostedBatchId_SelectedBG = GEMPQ2:Color1
    End


BRW2.ValidateRecord PROCEDURE

ReturnValue          BYTE,AUTO

BRW2::RecordStatus   BYTE,AUTO
  CODE
  ReturnValue = PARENT.ValidateRecord()
  IF ~GLO:SupervisorFlag
      IF MAT1:Access = 'R' AND ~(CEM:RecordID = MAT1:EmployeeID) THEN RETURN Record:Filtered.
  END
  RETURN ReturnValue
  BRW2::RecordStatus=ReturnValue
  IF BRW2::RecordStatus NOT=Record:OK THEN RETURN BRW2::RecordStatus.
  IF BRW2::Filter
    IF ~GetTag:PtrM(TAG:FeeNote, FN:RecordID) THEN RETURN Record:Filtered.
  END!IF
  ReturnValue=BRW2::RecordStatus
  RETURN ReturnValue


BRW15.ApplyFilter PROCEDURE

  CODE
   IF ~(CHOICE(?CurrentTab) = 4)
       BRW15::View:Browse{PROP:SQLFilter} = '1=0'
       RETURN
   END


   DO MakeFilterToDonoteString

   IF LOC:FilterToDonoteString

     LOC:FilterToDonoteString = Replace(LOC:FilterToDonoteString,'ToDoNote.','A.')
     LOC:FilterToDonoteString = Replace(LOC:FilterToDonoteString,'ToDoItem.','C.')
     
   END
   BRW15::View:Browse{PROP:SQLFilter} = LOC:FilterToDonoteString
   Debug(LOC:FilterToDonoteString)

   RETURN

  PARENT.ApplyFilter


BRW15.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert:2
    SELF.ChangeControl=?Change:2
    SELF.DeleteControl=?Delete:2
  END


BRW15.ResetQueue PROCEDURE(BYTE ResetMode)

  CODE
  PARENT.ResetQueue(ResetMode)
  IF Choice(?CurrentTab) = 4
  
  
     DO SetToDoNoteOptFilterButton
     
     IF RECORDS(SELF.ListQueue)
       ?MakeOutLookTaskButton{PROP:Disable} = False
       ?MakeOutLookAppointmentButton{PROP:Disable} = False
       ?MakeRemindersDocumentsButton{PROP:Disable} = False
       ?MakeDoneButton{PROP:Disable} = False
       ?AdjustRemindersButton{PROP:Disable} = False
       ?ToDoNoteJumpToMatterButton{PROP:Disable} = False
       ?EmailToDoNoteButton{PROP:Disable} = False
       ?PrintToDoNoteButton{PROP:Disable} = False
     ELSE
       ?MakeOutLookTaskButton{PROP:Disable} = True
       ?MakeOutLookAppointmentButton{PROP:Disable} = True
       ?MakeRemindersDocumentsButton{PROP:Disable} = True
       ?MakeDoneButton{PROP:Disable} = True
       ?AdjustRemindersButton{PROP:Disable} = True
       ?ToDoNoteJumpToMatterButton{PROP:Disable} = True
       ?EmailToDoNoteButton{PROP:Disable} = True
       ?PrintToDoNoteButton{PROP:Disable} = True
     END
  
  END
  IF RECORDS(SELF.ListQueue)
    ?TagOne:4{PROP:Disable} = 0
    ?UntagOne:4{PROP:Disable} = 0
    ?TagAll:4{PROP:Disable} = 0
    ?UntagAll:4{PROP:Disable} = 0
  ELSE
    ?TagOne:4{PROP:Disable} = 1
    ?UntagOne:4{PROP:Disable} = 1
    ?TagAll:4{PROP:Disable} = 1
    ?UntagAll:4{PROP:Disable} = 1
  END


BRW15.SetQueueRecord PROCEDURE

  CODE
  Tag = CHOOSE(~GetTag:PtrM(TAG:ToDoNote, TOD:RecordID), '', '*')
  SELF.Q.Tag = Tag
  LOC:Employee = GetEmployeeNameFromQueue(TOD:EmployeeID)

  PARENT.SetQueueRecord
   IF TOD:DateDone AND MAT1:DateInstructed
      SELF.Q.LOC:DaysTaken = TOD:DateDone - MAT1:DateInstructed
   ELSE
      SELF.Q.LOC:DaysTaken = 0
   END
   
   
   IF TOD:DateDone
      SELF.Q.LOC:DaysDiff = TOD:DateDone - TOD:Date
   ELSE
      SELF.Q.LOC:DaysDiff = 0
   END
  
  SELF.Q.Tag_NormalFG = -1
  SELF.Q.Tag_NormalBG = -1
  SELF.Q.Tag_SelectedFG = -1
  SELF.Q.Tag_SelectedBG = -1
  SELF.Q.Tag_Icon = 0
  SELF.Q.LOC:ProgressIndicator_NormalFG = -1
  SELF.Q.LOC:ProgressIndicator_NormalBG = -1
  SELF.Q.LOC:ProgressIndicator_SelectedFG = -1
  SELF.Q.LOC:ProgressIndicator_SelectedBG = -1
  IF (TOD:Priority=1)
    SELF.Q.LOC:ProgressIndicator_Icon = 4
  ELSIF (TOD:Priority=2)
    SELF.Q.LOC:ProgressIndicator_Icon = 3
  ELSE
    SELF.Q.LOC:ProgressIndicator_Icon = 0
  END
  SELF.Q.TOD:Date_NormalFG = -1
  SELF.Q.TOD:Date_NormalBG = -1
  SELF.Q.TOD:Date_SelectedFG = -1
  SELF.Q.TOD:Date_SelectedBG = -1
  SELF.Q.MAT1:FileRef_NormalFG = -1
  SELF.Q.MAT1:FileRef_NormalBG = -1
  SELF.Q.MAT1:FileRef_SelectedFG = -1
  SELF.Q.MAT1:FileRef_SelectedBG = -1
  SELF.Q.MAT1:Description_NormalFG = -1
  SELF.Q.MAT1:Description_NormalBG = -1
  SELF.Q.MAT1:Description_SelectedFG = -1
  SELF.Q.MAT1:Description_SelectedBG = -1
  SELF.Q.TOD:Description_NormalFG = -1
  SELF.Q.TOD:Description_NormalBG = -1
  SELF.Q.TOD:Description_SelectedFG = -1
  SELF.Q.TOD:Description_SelectedBG = -1
  SELF.Q.LOC:Employee_NormalFG = -1
  SELF.Q.LOC:Employee_NormalBG = -1
  SELF.Q.LOC:Employee_SelectedFG = -1
  SELF.Q.LOC:Employee_SelectedBG = -1
  SELF.Q.TOD:DateDone_NormalFG = -1
  SELF.Q.TOD:DateDone_NormalBG = -1
  SELF.Q.TOD:DateDone_SelectedFG = -1
  SELF.Q.TOD:DateDone_SelectedBG = -1
  SELF.Q.TOD:CompletedTime_NormalFG = -1
  SELF.Q.TOD:CompletedTime_NormalBG = -1
  SELF.Q.TOD:CompletedTime_SelectedFG = -1
  SELF.Q.TOD:CompletedTime_SelectedBG = -1
  SELF.Q.LOC:DaysTaken_NormalFG = -1
  SELF.Q.LOC:DaysTaken_NormalBG = -1
  SELF.Q.LOC:DaysTaken_SelectedFG = -1
  SELF.Q.LOC:DaysTaken_SelectedBG = -1
  SELF.Q.LOC:DaysDiff_NormalFG = -1
  SELF.Q.LOC:DaysDiff_NormalBG = -1
  SELF.Q.LOC:DaysDiff_SelectedFG = -1
  SELF.Q.LOC:DaysDiff_SelectedBG = -1
  SELF.Q.TOD:CreatedDate_NormalFG = -1
  SELF.Q.TOD:CreatedDate_NormalBG = -1
  SELF.Q.TOD:CreatedDate_SelectedFG = -1
  SELF.Q.TOD:CreatedDate_SelectedBG = -1
  SELF.Q.TOD:CreatedTime_NormalFG = -1
  SELF.Q.TOD:CreatedTime_NormalBG = -1
  SELF.Q.TOD:CreatedTime_SelectedFG = -1
  SELF.Q.TOD:CreatedTime_SelectedBG = -1
  SELF.Q.DOC:Description_NormalFG = -1
  SELF.Q.DOC:Description_NormalBG = -1
  SELF.Q.DOC:Description_SelectedFG = -1
  SELF.Q.DOC:Description_SelectedBG = -1
  SELF.Q.TOI:Code_NormalFG = -1
  SELF.Q.TOI:Code_NormalBG = -1
  SELF.Q.TOI:Code_SelectedFG = -1
  SELF.Q.TOI:Code_SelectedBG = -1
  SELF.Q.TOI:WebLinkMessage_NormalFG = -1
  SELF.Q.TOI:WebLinkMessage_NormalBG = -1
  SELF.Q.TOI:WebLinkMessage_SelectedFG = -1
  SELF.Q.TOI:WebLinkMessage_SelectedBG = -1
  SELF.Q.TOI:FNBMessageNo_NormalFG = -1
  SELF.Q.TOI:FNBMessageNo_NormalBG = -1
  SELF.Q.TOI:FNBMessageNo_SelectedFG = -1
  SELF.Q.TOI:FNBMessageNo_SelectedBG = -1
  IF Tag
    Queue:Browse:3.Tag_Icon = 2
  ELSE
    Queue:Browse:3.Tag_Icon = 1
  END!IF
      SELF.Q.Tag_NormalFG   = COLOR:None
      SELF.Q.Tag_NormalBG   = COLOR:None
      SELF.Q.Tag_SelectedFG = COLOR:None
      SELF.Q.Tag_SelectedBG = COLOR:None
      SELF.Q.LOC:ProgressIndicator_NormalFG   = COLOR:None
      SELF.Q.LOC:ProgressIndicator_NormalBG   = COLOR:None
      SELF.Q.LOC:ProgressIndicator_SelectedFG = COLOR:None
      SELF.Q.LOC:ProgressIndicator_SelectedBG = COLOR:None
      SELF.Q.TOD:Date_NormalFG   = COLOR:None
      SELF.Q.TOD:Date_NormalBG   = COLOR:None
      SELF.Q.TOD:Date_SelectedFG = COLOR:None
      SELF.Q.TOD:Date_SelectedBG = COLOR:None
      SELF.Q.MAT1:FileRef_NormalFG   = COLOR:None
      SELF.Q.MAT1:FileRef_NormalBG   = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedFG = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedBG = COLOR:None
      SELF.Q.MAT1:Description_NormalFG   = COLOR:None
      SELF.Q.MAT1:Description_NormalBG   = COLOR:None
      SELF.Q.MAT1:Description_SelectedFG = COLOR:None
      SELF.Q.MAT1:Description_SelectedBG = COLOR:None
      SELF.Q.TOD:Description_NormalFG   = COLOR:None
      SELF.Q.TOD:Description_NormalBG   = COLOR:None
      SELF.Q.TOD:Description_SelectedFG = COLOR:None
      SELF.Q.TOD:Description_SelectedBG = COLOR:None
      SELF.Q.LOC:Employee_NormalFG   = COLOR:None
      SELF.Q.LOC:Employee_NormalBG   = COLOR:None
      SELF.Q.LOC:Employee_SelectedFG = COLOR:None
      SELF.Q.LOC:Employee_SelectedBG = COLOR:None
      SELF.Q.TOD:DateDone_NormalFG   = COLOR:None
      SELF.Q.TOD:DateDone_NormalBG   = COLOR:None
      SELF.Q.TOD:DateDone_SelectedFG = COLOR:None
      SELF.Q.TOD:DateDone_SelectedBG = COLOR:None
      SELF.Q.TOD:CompletedTime_NormalFG   = COLOR:None
      SELF.Q.TOD:CompletedTime_NormalBG   = COLOR:None
      SELF.Q.TOD:CompletedTime_SelectedFG = COLOR:None
      SELF.Q.TOD:CompletedTime_SelectedBG = COLOR:None
      SELF.Q.LOC:DaysTaken_NormalFG   = COLOR:None
      SELF.Q.LOC:DaysTaken_NormalBG   = COLOR:None
      SELF.Q.LOC:DaysTaken_SelectedFG = COLOR:None
      SELF.Q.LOC:DaysTaken_SelectedBG = COLOR:None
      SELF.Q.LOC:DaysDiff_NormalFG   = COLOR:None
      SELF.Q.LOC:DaysDiff_NormalBG   = COLOR:None
      SELF.Q.LOC:DaysDiff_SelectedFG = COLOR:None
      SELF.Q.LOC:DaysDiff_SelectedBG = COLOR:None
      SELF.Q.TOD:CreatedDate_NormalFG   = COLOR:None
      SELF.Q.TOD:CreatedDate_NormalBG   = COLOR:None
      SELF.Q.TOD:CreatedDate_SelectedFG = COLOR:None
      SELF.Q.TOD:CreatedDate_SelectedBG = COLOR:None
      SELF.Q.TOD:CreatedTime_NormalFG   = COLOR:None
      SELF.Q.TOD:CreatedTime_NormalBG   = COLOR:None
      SELF.Q.TOD:CreatedTime_SelectedFG = COLOR:None
      SELF.Q.TOD:CreatedTime_SelectedBG = COLOR:None
      SELF.Q.DOC:Description_NormalFG   = COLOR:None
      SELF.Q.DOC:Description_NormalBG   = COLOR:None
      SELF.Q.DOC:Description_SelectedFG = COLOR:None
      SELF.Q.DOC:Description_SelectedBG = COLOR:None
      SELF.Q.TOI:Code_NormalFG   = COLOR:None
      SELF.Q.TOI:Code_NormalBG   = COLOR:None
      SELF.Q.TOI:Code_SelectedFG = COLOR:None
      SELF.Q.TOI:Code_SelectedBG = COLOR:None
      SELF.Q.TOI:WebLinkMessage_NormalFG   = COLOR:None
      SELF.Q.TOI:WebLinkMessage_NormalBG   = COLOR:None
      SELF.Q.TOI:WebLinkMessage_SelectedFG = COLOR:None
      SELF.Q.TOI:WebLinkMessage_SelectedBG = COLOR:None
      SELF.Q.TOI:FNBMessageNo_NormalFG   = COLOR:None
      SELF.Q.TOI:FNBMessageNo_NormalBG   = COLOR:None
      SELF.Q.TOI:FNBMessageNo_SelectedFG = COLOR:None
      SELF.Q.TOI:FNBMessageNo_SelectedBG = COLOR:None
    If (TOI:CriticalStep AND CEM:ProgressIndicatorFlag = 'C')
      SELF.Q.Tag_NormalFG   = COLOR:Red
      SELF.Q.Tag_NormalBG   = COLOR:None
      SELF.Q.Tag_SelectedFG = COLOR:None
      SELF.Q.Tag_SelectedBG = COLOR:Red
      SELF.Q.LOC:ProgressIndicator_NormalFG   = COLOR:Red
      SELF.Q.LOC:ProgressIndicator_NormalBG   = COLOR:None
      SELF.Q.LOC:ProgressIndicator_SelectedFG = COLOR:None
      SELF.Q.LOC:ProgressIndicator_SelectedBG = COLOR:Red
      SELF.Q.TOD:Date_NormalFG   = COLOR:Red
      SELF.Q.TOD:Date_NormalBG   = COLOR:None
      SELF.Q.TOD:Date_SelectedFG = COLOR:None
      SELF.Q.TOD:Date_SelectedBG = COLOR:Red
      SELF.Q.MAT1:FileRef_NormalFG   = COLOR:Red
      SELF.Q.MAT1:FileRef_NormalBG   = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedFG = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedBG = COLOR:Red
      SELF.Q.MAT1:Description_NormalFG   = COLOR:Red
      SELF.Q.MAT1:Description_NormalBG   = COLOR:None
      SELF.Q.MAT1:Description_SelectedFG = COLOR:None
      SELF.Q.MAT1:Description_SelectedBG = COLOR:Red
      SELF.Q.TOD:Description_NormalFG   = COLOR:Red
      SELF.Q.TOD:Description_NormalBG   = COLOR:None
      SELF.Q.TOD:Description_SelectedFG = COLOR:None
      SELF.Q.TOD:Description_SelectedBG = COLOR:Red
      SELF.Q.LOC:Employee_NormalFG   = COLOR:Red
      SELF.Q.LOC:Employee_NormalBG   = COLOR:None
      SELF.Q.LOC:Employee_SelectedFG = COLOR:None
      SELF.Q.LOC:Employee_SelectedBG = COLOR:Red
      SELF.Q.TOD:DateDone_NormalFG   = COLOR:Red
      SELF.Q.TOD:DateDone_NormalBG   = COLOR:None
      SELF.Q.TOD:DateDone_SelectedFG = COLOR:None
      SELF.Q.TOD:DateDone_SelectedBG = COLOR:Red
      SELF.Q.TOD:CompletedTime_NormalFG   = COLOR:Red
      SELF.Q.TOD:CompletedTime_NormalBG   = COLOR:None
      SELF.Q.TOD:CompletedTime_SelectedFG = COLOR:None
      SELF.Q.TOD:CompletedTime_SelectedBG = COLOR:Red
      SELF.Q.LOC:DaysTaken_NormalFG   = COLOR:Red
      SELF.Q.LOC:DaysTaken_NormalBG   = COLOR:None
      SELF.Q.LOC:DaysTaken_SelectedFG = COLOR:None
      SELF.Q.LOC:DaysTaken_SelectedBG = COLOR:Red
      SELF.Q.LOC:DaysDiff_NormalFG   = COLOR:Red
      SELF.Q.LOC:DaysDiff_NormalBG   = COLOR:None
      SELF.Q.LOC:DaysDiff_SelectedFG = COLOR:None
      SELF.Q.LOC:DaysDiff_SelectedBG = COLOR:Red
      SELF.Q.TOD:CreatedDate_NormalFG   = COLOR:Red
      SELF.Q.TOD:CreatedDate_NormalBG   = COLOR:None
      SELF.Q.TOD:CreatedDate_SelectedFG = COLOR:None
      SELF.Q.TOD:CreatedDate_SelectedBG = COLOR:Red
      SELF.Q.TOD:CreatedTime_NormalFG   = COLOR:Red
      SELF.Q.TOD:CreatedTime_NormalBG   = COLOR:None
      SELF.Q.TOD:CreatedTime_SelectedFG = COLOR:None
      SELF.Q.TOD:CreatedTime_SelectedBG = COLOR:Red
      SELF.Q.DOC:Description_NormalFG   = COLOR:Red
      SELF.Q.DOC:Description_NormalBG   = COLOR:None
      SELF.Q.DOC:Description_SelectedFG = COLOR:None
      SELF.Q.DOC:Description_SelectedBG = COLOR:Red
      SELF.Q.TOI:Code_NormalFG   = COLOR:Red
      SELF.Q.TOI:Code_NormalBG   = COLOR:None
      SELF.Q.TOI:Code_SelectedFG = COLOR:None
      SELF.Q.TOI:Code_SelectedBG = COLOR:Red
      SELF.Q.TOI:WebLinkMessage_NormalFG   = COLOR:Red
      SELF.Q.TOI:WebLinkMessage_NormalBG   = COLOR:None
      SELF.Q.TOI:WebLinkMessage_SelectedFG = COLOR:None
      SELF.Q.TOI:WebLinkMessage_SelectedBG = COLOR:Red
      SELF.Q.TOI:FNBMessageNo_NormalFG   = COLOR:Red
      SELF.Q.TOI:FNBMessageNo_NormalBG   = COLOR:None
      SELF.Q.TOI:FNBMessageNo_SelectedFG = COLOR:None
      SELF.Q.TOI:FNBMessageNo_SelectedBG = COLOR:Red
    End
    If (GEMPQ2:Color1 AND CEM:ColorizeFlag AND CEM:ShowJustMyColoursFlag <> 1 AND CEM:ProgressIndicatorFlag <> 'C')
      SELF.Q.Tag_NormalFG   = GEMPQ2:Color1
      SELF.Q.Tag_NormalBG   = GEMPQ2:Color2
      SELF.Q.Tag_SelectedFG = GEMPQ2:Color2
      SELF.Q.Tag_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:ProgressIndicator_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:ProgressIndicator_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:ProgressIndicator_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:ProgressIndicator_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOD:Date_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOD:Date_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOD:Date_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOD:Date_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT1:FileRef_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT1:FileRef_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT1:FileRef_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT1:FileRef_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT1:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT1:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT1:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT1:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOD:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOD:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOD:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOD:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOD:DateDone_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOD:DateDone_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOD:DateDone_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOD:DateDone_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOD:CompletedTime_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOD:CompletedTime_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOD:CompletedTime_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOD:CompletedTime_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:DaysTaken_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:DaysTaken_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:DaysTaken_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:DaysTaken_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:DaysDiff_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:DaysDiff_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:DaysDiff_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:DaysDiff_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOD:CreatedDate_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOD:CreatedDate_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOD:CreatedDate_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOD:CreatedDate_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOD:CreatedTime_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOD:CreatedTime_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOD:CreatedTime_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOD:CreatedTime_SelectedBG = GEMPQ2:Color1
      SELF.Q.DOC:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.DOC:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.DOC:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.DOC:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOI:Code_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOI:Code_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOI:Code_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOI:Code_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOI:WebLinkMessage_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOI:WebLinkMessage_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOI:WebLinkMessage_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOI:WebLinkMessage_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOI:FNBMessageNo_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOI:FNBMessageNo_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOI:FNBMessageNo_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOI:FNBMessageNo_SelectedBG = GEMPQ2:Color1
    End
    If (GEMPQ2:Color1 AND CEM:ColorizeFlag AND CEM:ShowJustMyColoursFlag = 1 AND GEMPQ2:RecordID = CEM:RecordID AND CEM:ProgressIndicatorFlag <> 'C')
      SELF.Q.Tag_NormalFG   = GEMPQ2:Color1
      SELF.Q.Tag_NormalBG   = GEMPQ2:Color2
      SELF.Q.Tag_SelectedFG = GEMPQ2:Color2
      SELF.Q.Tag_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:ProgressIndicator_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:ProgressIndicator_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:ProgressIndicator_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:ProgressIndicator_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOD:Date_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOD:Date_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOD:Date_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOD:Date_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT1:FileRef_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT1:FileRef_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT1:FileRef_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT1:FileRef_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT1:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT1:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT1:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT1:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOD:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOD:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOD:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOD:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOD:DateDone_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOD:DateDone_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOD:DateDone_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOD:DateDone_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOD:CompletedTime_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOD:CompletedTime_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOD:CompletedTime_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOD:CompletedTime_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:DaysTaken_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:DaysTaken_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:DaysTaken_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:DaysTaken_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:DaysDiff_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:DaysDiff_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:DaysDiff_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:DaysDiff_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOD:CreatedDate_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOD:CreatedDate_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOD:CreatedDate_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOD:CreatedDate_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOD:CreatedTime_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOD:CreatedTime_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOD:CreatedTime_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOD:CreatedTime_SelectedBG = GEMPQ2:Color1
      SELF.Q.DOC:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.DOC:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.DOC:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.DOC:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOI:Code_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOI:Code_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOI:Code_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOI:Code_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOI:WebLinkMessage_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOI:WebLinkMessage_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOI:WebLinkMessage_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOI:WebLinkMessage_SelectedBG = GEMPQ2:Color1
      SELF.Q.TOI:FNBMessageNo_NormalFG   = GEMPQ2:Color1
      SELF.Q.TOI:FNBMessageNo_NormalBG   = GEMPQ2:Color2
      SELF.Q.TOI:FNBMessageNo_SelectedFG = GEMPQ2:Color2
      SELF.Q.TOI:FNBMessageNo_SelectedBG = GEMPQ2:Color1
    End
!   IF SELF.Q.TOD:DateDone
!  
!      SELF.Q.LOC:ProgressIndicator_Icon = 8     ! DONE
!  
!   ELSE
!  
!     IF GLO:TodaysDate - SELF.Q.TOD:Date > 10   ! RED CARD - LATE BY OVER 10 DAYS
!  
!        SELF.Q.LOC:ProgressIndicator_Icon = 6
!  
!     ELSIF GLO:TodaysDate - SELF.Q.TOD:Date > 3 ! YELLOW CARD - LATE BY OVER 3 DAYS
!  
!        SELF.Q.LOC:ProgressIndicator_Icon = 5
!  
!     ELSE
!  
!        SELF.Q.LOC:ProgressIndicator_Icon = 7   ! DUE NOW
!     END
!  
!   END
    !FB 4548
   !IF SELF.Q.TOD:Priority = 1
   ! SELF.Q.LOC:ProgressIndicator_Icon = 5
   !ELSIF SELF.Q.TOD:Priority = 2
   ! SELF.Q.LOC:ProgressIndicator_Icon = 6
   !ELSE
   !END
   !FB 4548 END
  
!!   IF LOC:ShowToDoNoteIconsFlag
!!
!!      IF CEM:DisplayLargeIconsFlag
!!         LOC:IconFileName = GetRoot(CRI:LargeIconFileName)
!!      ELSE
!!         LOC:IconFileName = GetRoot(CRI:SmallIconFileName)
!!      END
!!
!!      IF LOC:IconFileName
!!      
!!         ?ToDoNoteBrowse{PROP:IconList,CRI:RecordID + 2} = LOC:IconFileName
!!      
!!         SELF.Q.LOC:ProgressIndicator_Icon = CRI:RecordID + 2
!!      
!!      ELSE
!!      
!!         SELF.Q.LOC:ProgressIndicator_Icon = 0
!!      
!!      END
!!  
!!   ELSE
!!   
!!      SELF.Q.LOC:ProgressIndicator_Icon = 0
!!   
!!   END



BRW15.ValidateRecord PROCEDURE

ReturnValue          BYTE,AUTO

BRW15::RecordStatus  BYTE,AUTO
  CODE
  ReturnValue = PARENT.ValidateRecord()
  IF ~GLO:SupervisorFlag
      IF MAT1:Access = 'R' AND ~(CEM:RecordID = MAT1:EmployeeID) THEN RETURN Record:Filtered.
  END
  
  RETURN ReturnValue
  BRW15::RecordStatus=ReturnValue
  IF BRW15::RecordStatus NOT=Record:OK THEN RETURN BRW15::RecordStatus.
  IF BRW15::Filter
    IF ~GetTag:PtrM(TAG:ToDoNote, TOD:RecordID) THEN RETURN Record:Filtered.
  END!IF
  ReturnValue=BRW15::RecordStatus
  RETURN ReturnValue


BRW22.ApplyFilter PROCEDURE

  CODE
   IF ~(CHOICE(?CurrentTab) = 5)
       BRW22::View:Browse{PROP:SQLFilter} = '1=0'
       RETURN
   END


   DO MakeFilterMatActivString

   IF LOC:FilterMatActivString
      BRW22::View:Browse{PROP:SQLFilter} = Replace(LOC:FilterMatActivString,'MatActiv.','A.')
   ELSE
      BRW22::View:Browse{PROP:SQLFilter} = ''
   END
   RETURN




  
  PARENT.ApplyFilter


BRW22.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert:6
    SELF.ChangeControl=?Change:6
    SELF.DeleteControl=?Delete:6
  END


BRW22.ResetQueue PROCEDURE(BYTE ResetMode)

  CODE
  PARENT.ResetQueue(ResetMode)
  IF Choice(?CurrentTab) = 5

       DO SetMatActivOptFilterButton

       IF RECORDS(SELF.ListQueue)
         ?MatActivJumpToMatterButton{PROP:Disable} = False
   !      ?MatterEmployeesButton:2{PROP:Disable} = False
       ELSE
         ?MatActivJumpToMatterButton{PROP:Disable} = True
   !      ?MatterEmployeesButton:2{PROP:Disable} = True
       END
   END
  IF RECORDS(SELF.ListQueue)
    ?TagOne:5{PROP:Disable} = 0
    ?UntagOne:5{PROP:Disable} = 0
    ?TagAll:5{PROP:Disable} = 0
    ?UntagAll:5{PROP:Disable} = 0
  ELSE
    ?TagOne:5{PROP:Disable} = 1
    ?UntagOne:5{PROP:Disable} = 1
    ?TagAll:5{PROP:Disable} = 1
    ?UntagAll:5{PROP:Disable} = 1
  END


BRW22.SetQueueRecord PROCEDURE

  CODE
  Tag = CHOOSE(~GetTag:PtrM(TAG:MatActiv, MA:RecordID), '', '*')
  SELF.Q.Tag = Tag
  LOC:MA_HoursAndMinutes = GetHoursAndMinutes(MA:Minutes)

  LOC:Employee = GetEmployeeNameFromQueue(MA:EmployeeID)

  PARENT.SetQueueRecord
  SELF.Q.Tag_NormalFG = -1
  SELF.Q.Tag_NormalBG = -1
  SELF.Q.Tag_SelectedFG = -1
  SELF.Q.Tag_SelectedBG = -1
  SELF.Q.Tag_Icon = 0
  SELF.Q.LOC:Billable_NormalFG = -1
  SELF.Q.LOC:Billable_NormalBG = -1
  SELF.Q.LOC:Billable_SelectedFG = -1
  SELF.Q.LOC:Billable_SelectedBG = -1
  IF (MA:FeeNoteID > 0 AND ~FN1:PostedFlag)
    SELF.Q.LOC:Billable_Icon = 3
  ELSIF (MA:FeeNoteID > 0 AND FN1:PostedFlag)
    SELF.Q.LOC:Billable_Icon = 4
  ELSE
    SELF.Q.LOC:Billable_Icon = 5
  END
  SELF.Q.MA:Date_NormalFG = -1
  SELF.Q.MA:Date_NormalBG = -1
  SELF.Q.MA:Date_SelectedFG = -1
  SELF.Q.MA:Date_SelectedBG = -1
  SELF.Q.MAT1:FileRef_NormalFG = -1
  SELF.Q.MAT1:FileRef_NormalBG = -1
  SELF.Q.MAT1:FileRef_SelectedFG = -1
  SELF.Q.MAT1:FileRef_SelectedBG = -1
  SELF.Q.MAT1:Description_NormalFG = -1
  SELF.Q.MAT1:Description_NormalBG = -1
  SELF.Q.MAT1:Description_SelectedFG = -1
  SELF.Q.MAT1:Description_SelectedBG = -1
  SELF.Q.ACT:Description_NormalFG = -1
  SELF.Q.ACT:Description_NormalBG = -1
  SELF.Q.ACT:Description_SelectedFG = -1
  SELF.Q.ACT:Description_SelectedBG = -1
  SELF.Q.MA:Description_NormalFG = -1
  SELF.Q.MA:Description_NormalBG = -1
  SELF.Q.MA:Description_SelectedFG = -1
  SELF.Q.MA:Description_SelectedBG = -1
  SELF.Q.LOC:MA_HoursAndMinutes_NormalFG = -1
  SELF.Q.LOC:MA_HoursAndMinutes_NormalBG = -1
  SELF.Q.LOC:MA_HoursAndMinutes_SelectedFG = -1
  SELF.Q.LOC:MA_HoursAndMinutes_SelectedBG = -1
  SELF.Q.MA:BillableAmount_NormalFG = -1
  SELF.Q.MA:BillableAmount_NormalBG = -1
  SELF.Q.MA:BillableAmount_SelectedFG = -1
  SELF.Q.MA:BillableAmount_SelectedBG = -1
  SELF.Q.LOC:Employee_NormalFG = -1
  SELF.Q.LOC:Employee_NormalBG = -1
  SELF.Q.LOC:Employee_SelectedFG = -1
  SELF.Q.LOC:Employee_SelectedBG = -1
  SELF.Q.COS:Description_NormalFG = -1
  SELF.Q.COS:Description_NormalBG = -1
  SELF.Q.COS:Description_SelectedFG = -1
  SELF.Q.COS:Description_SelectedBG = -1
  IF Tag
    Queue:Browse:5.Tag_Icon = 2
  ELSE
    Queue:Browse:5.Tag_Icon = 1
  END!IF
      SELF.Q.Tag_NormalFG   = COLOR:None
      SELF.Q.Tag_NormalBG   = COLOR:None
      SELF.Q.Tag_SelectedFG = COLOR:None
      SELF.Q.Tag_SelectedBG = COLOR:None
      SELF.Q.LOC:Billable_NormalFG   = COLOR:None
      SELF.Q.LOC:Billable_NormalBG   = COLOR:None
      SELF.Q.LOC:Billable_SelectedFG = COLOR:None
      SELF.Q.LOC:Billable_SelectedBG = COLOR:None
      SELF.Q.MA:Date_NormalFG   = COLOR:None
      SELF.Q.MA:Date_NormalBG   = COLOR:None
      SELF.Q.MA:Date_SelectedFG = COLOR:None
      SELF.Q.MA:Date_SelectedBG = COLOR:None
      SELF.Q.MAT1:FileRef_NormalFG   = COLOR:None
      SELF.Q.MAT1:FileRef_NormalBG   = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedFG = COLOR:None
      SELF.Q.MAT1:FileRef_SelectedBG = COLOR:None
      SELF.Q.MAT1:Description_NormalFG   = COLOR:None
      SELF.Q.MAT1:Description_NormalBG   = COLOR:None
      SELF.Q.MAT1:Description_SelectedFG = COLOR:None
      SELF.Q.MAT1:Description_SelectedBG = COLOR:None
      SELF.Q.ACT:Description_NormalFG   = COLOR:None
      SELF.Q.ACT:Description_NormalBG   = COLOR:None
      SELF.Q.ACT:Description_SelectedFG = COLOR:None
      SELF.Q.ACT:Description_SelectedBG = COLOR:None
      SELF.Q.MA:Description_NormalFG   = COLOR:None
      SELF.Q.MA:Description_NormalBG   = COLOR:None
      SELF.Q.MA:Description_SelectedFG = COLOR:None
      SELF.Q.MA:Description_SelectedBG = COLOR:None
      SELF.Q.LOC:MA_HoursAndMinutes_NormalFG   = COLOR:None
      SELF.Q.LOC:MA_HoursAndMinutes_NormalBG   = COLOR:None
      SELF.Q.LOC:MA_HoursAndMinutes_SelectedFG = COLOR:None
      SELF.Q.LOC:MA_HoursAndMinutes_SelectedBG = COLOR:None
      SELF.Q.MA:BillableAmount_NormalFG   = COLOR:None
      SELF.Q.MA:BillableAmount_NormalBG   = COLOR:None
      SELF.Q.MA:BillableAmount_SelectedFG = COLOR:None
      SELF.Q.MA:BillableAmount_SelectedBG = COLOR:None
      SELF.Q.LOC:Employee_NormalFG   = COLOR:None
      SELF.Q.LOC:Employee_NormalBG   = COLOR:None
      SELF.Q.LOC:Employee_SelectedFG = COLOR:None
      SELF.Q.LOC:Employee_SelectedBG = COLOR:None
      SELF.Q.COS:Description_NormalFG   = COLOR:None
      SELF.Q.COS:Description_NormalBG   = COLOR:None
      SELF.Q.COS:Description_SelectedFG = COLOR:None
      SELF.Q.COS:Description_SelectedBG = COLOR:None
    If (GEMPQ2:Color1 AND CEM:ColorizeFlag AND CEM:ShowJustMyColoursFlag <> 1)
      SELF.Q.Tag_NormalFG   = GEMPQ2:Color1
      SELF.Q.Tag_NormalBG   = GEMPQ2:Color2
      SELF.Q.Tag_SelectedFG = GEMPQ2:Color2
      SELF.Q.Tag_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:Billable_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:Billable_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:Billable_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:Billable_SelectedBG = GEMPQ2:Color1
      SELF.Q.MA:Date_NormalFG   = GEMPQ2:Color1
      SELF.Q.MA:Date_NormalBG   = GEMPQ2:Color2
      SELF.Q.MA:Date_SelectedFG = GEMPQ2:Color2
      SELF.Q.MA:Date_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT1:FileRef_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT1:FileRef_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT1:FileRef_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT1:FileRef_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT1:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT1:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT1:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT1:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.ACT:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.ACT:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.ACT:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.ACT:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.MA:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.MA:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.MA:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.MA:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:MA_HoursAndMinutes_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:MA_HoursAndMinutes_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:MA_HoursAndMinutes_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:MA_HoursAndMinutes_SelectedBG = GEMPQ2:Color1
      SELF.Q.MA:BillableAmount_NormalFG   = GEMPQ2:Color1
      SELF.Q.MA:BillableAmount_NormalBG   = GEMPQ2:Color2
      SELF.Q.MA:BillableAmount_SelectedFG = GEMPQ2:Color2
      SELF.Q.MA:BillableAmount_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedBG = GEMPQ2:Color1
      SELF.Q.COS:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.COS:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.COS:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.COS:Description_SelectedBG = GEMPQ2:Color1
    End
    If (GEMPQ2:Color1 AND CEM:ColorizeFlag AND CEM:ShowJustMyColoursFlag = 1 AND GEMPQ2:RecordID = CEM:RecordID)
      SELF.Q.Tag_NormalFG   = GEMPQ2:Color1
      SELF.Q.Tag_NormalBG   = GEMPQ2:Color2
      SELF.Q.Tag_SelectedFG = GEMPQ2:Color2
      SELF.Q.Tag_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:Billable_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:Billable_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:Billable_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:Billable_SelectedBG = GEMPQ2:Color1
      SELF.Q.MA:Date_NormalFG   = GEMPQ2:Color1
      SELF.Q.MA:Date_NormalBG   = GEMPQ2:Color2
      SELF.Q.MA:Date_SelectedFG = GEMPQ2:Color2
      SELF.Q.MA:Date_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT1:FileRef_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT1:FileRef_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT1:FileRef_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT1:FileRef_SelectedBG = GEMPQ2:Color1
      SELF.Q.MAT1:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.MAT1:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.MAT1:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.MAT1:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.ACT:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.ACT:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.ACT:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.ACT:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.MA:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.MA:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.MA:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.MA:Description_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:MA_HoursAndMinutes_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:MA_HoursAndMinutes_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:MA_HoursAndMinutes_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:MA_HoursAndMinutes_SelectedBG = GEMPQ2:Color1
      SELF.Q.MA:BillableAmount_NormalFG   = GEMPQ2:Color1
      SELF.Q.MA:BillableAmount_NormalBG   = GEMPQ2:Color2
      SELF.Q.MA:BillableAmount_SelectedFG = GEMPQ2:Color2
      SELF.Q.MA:BillableAmount_SelectedBG = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalFG   = GEMPQ2:Color1
      SELF.Q.LOC:Employee_NormalBG   = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedFG = GEMPQ2:Color2
      SELF.Q.LOC:Employee_SelectedBG = GEMPQ2:Color1
      SELF.Q.COS:Description_NormalFG   = GEMPQ2:Color1
      SELF.Q.COS:Description_NormalBG   = GEMPQ2:Color2
      SELF.Q.COS:Description_SelectedFG = GEMPQ2:Color2
      SELF.Q.COS:Description_SelectedBG = GEMPQ2:Color1
    End


BRW22.ValidateRecord PROCEDURE

ReturnValue          BYTE,AUTO

BRW22::RecordStatus  BYTE,AUTO
  CODE
  ReturnValue = PARENT.ValidateRecord()
  IF ~GLO:SupervisorFlag
      IF MAT1:Access = 'R' AND ~(CEM:RecordID = MAT1:EmployeeID) THEN RETURN Record:Filtered.
  END
  RETURN ReturnValue
  BRW22::RecordStatus=ReturnValue
  IF BRW22::RecordStatus NOT=Record:OK THEN RETURN BRW22::RecordStatus.
  IF BRW22::Filter
    IF ~GetTag:PtrM(TAG:MatActiv, MA:RecordID) THEN RETURN Record:Filtered.
  END!IF
  ReturnValue=BRW22::RecordStatus
  RETURN ReturnValue


BRW36.ApplyFilter PROCEDURE

  CODE
   IF ~(CHOICE(?CurrentTab) = 6)
       BRW36::View:Browse{PROP:SQLFilter} = '1=0'
       RETURN
   END

   DO MakeFilterLawMatterMessageString
   IF LOC:FilterLawMatterMessageString
      BRW36::View:Browse{PROP:SQLFilter} = Replace(LOC:FilterLawMatterMessageString,'LawMatterMessage.','A.')
   ELSE
      BRW36::View:Browse{PROP:SQLFilter} = ''
   END
   RETURN

   

  PARENT.ApplyFilter


BRW36.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert:4
    SELF.ChangeControl=?Change:4
    SELF.DeleteControl=?Delete:4
  END


BRW36.ResetQueue PROCEDURE(BYTE ResetMode)

  CODE
  PARENT.ResetQueue(ResetMode)
    IF RECORDS(SELF.ListQueue)
       ?ViewDatalinkXML{PROP:Disable} = False
       ?DataLinkJumpToMatterButton{PROP:Disable} = False
    ELSE
       ?ViewDatalinkXML{PROP:Disable} = True
       ?DataLinkJumpToMatterButton{PROP:Disable} = True
    END
  
  IF RECORDS(SELF.ListQueue)
    ?TagOne:6{PROP:Disable} = 0
    ?UntagOne:6{PROP:Disable} = 0
    ?TagAll:6{PROP:Disable} = 0
    ?UntagAll:6{PROP:Disable} = 0
  ELSE
    ?TagOne:6{PROP:Disable} = 1
    ?UntagOne:6{PROP:Disable} = 1
    ?TagAll:6{PROP:Disable} = 1
    ?UntagAll:6{PROP:Disable} = 1
  END


BRW36.SetQueueRecord PROCEDURE

  CODE
  IF LAW_MSG:Filter = 'T'
     LOC:ToFrom = 'To'
  ELSIF LAW_MSG:Filter = 'F'
     LOC:ToFrom = 'From'
  ELSE
     LOC:ToFrom = 'Unknown'
  END
  Tag = CHOOSE(~GetTag:PtrM(TAG:LAWMatterMessage, MME:RecordID), '', '*')
  SELF.Q.Tag = Tag
  PARENT.SetQueueRecord
  SELF.Q.Tag_Icon = 0
  IF Tag
    Queue:Browse:2.Tag_Icon = 2
  ELSE
    Queue:Browse:2.Tag_Icon = 1
  END!IF


BRW36.ValidateRecord PROCEDURE

ReturnValue          BYTE,AUTO

BRW36::RecordStatus  BYTE,AUTO
  CODE
  ReturnValue = PARENT.ValidateRecord()
  BRW36::RecordStatus=ReturnValue
  IF BRW36::RecordStatus NOT=Record:OK THEN RETURN BRW36::RecordStatus.
  IF BRW36::Filter
    IF ~GetTag:PtrM(TAG:LAWMatterMessage, MME:RecordID) THEN RETURN Record:Filtered.
  END!IF
  ReturnValue=BRW36::RecordStatus
  RETURN ReturnValue


BRW46.ApplyFilter PROCEDURE

  CODE
   IF ~(CHOICE(?CurrentTab) = 8)
       BRW46::View:Browse{PROP:SQLFilter} = '1=0'
       RETURN
   END
  
!JESS

   DO MakeFilterFNBLinkString


   !MESSAGE('BRW46.ApplyFilter||LOC:FilterFNBLinkString = ' & LOC:FilterFNBLinkString)

  
   LOC:FilterFNBLinkString = Replace(LOC:FilterFNBLinkString,'AG_MatterMessage.','A.')
   LOC:FilterFNBLinkString = Replace(LOC:FilterFNBLinkString,'LAW_Suite.','D.')



   !SETCLIPBOARD(LOC:FilterFNBLinkString)

   BRW46::View:Browse{PROP:SQLFilter} = LOC:FilterFNBLinkString
  
   RETURN


  PARENT.ApplyFilter


BRW46.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert:7
    SELF.ChangeControl=?Change:7
    SELF.DeleteControl=?Delete:7
  END


BRW46.ResetQueue PROCEDURE(BYTE ResetMode)

  CODE
  PARENT.ResetQueue(ResetMode)
  IF RECORDS(SELF.ListQueue)
    ?DocumentLogButton:3{PROP:Disable} = False
    ?FNBLinkJumpToMatterButton{PROP:Disable} = False
    ?PrintFNBInstructionButton{PROP:Disable} = False
  ELSE
    ?DocumentLogButton:3{PROP:Disable} = True
    ?FNBLinkJumpToMatterButton{PROP:Disable} = True
    ?PrintFNBInstructionButton{PROP:Disable} = True
  END
  
  


BRW46.ResetSort PROCEDURE(BYTE Force)

ReturnValue          BYTE,AUTO

  CODE
  IF LOC:FNB_Matter = 'Current'
    RETURN SELF.SetSort(1,Force)
  ELSE
    RETURN SELF.SetSort(2,Force)
  END
  ReturnValue = PARENT.ResetSort(Force)
  RETURN ReturnValue


BRW46.SetQueueRecord PROCEDURE

  CODE
  GBRAQ:RecordID = MAT1:BranchID
  GET(GBRAQ:BranchQueue,GBRAQ:RecordID)
  IF ERROR() THEN LOC:Branch = 'Unknown Branch' ELSE LOC:Branch = GBRAQ:Description.


  LOC:Employee = GetEmployeeNameFromQueue(AGMM:EmployeeID)

  PARENT.SetQueueRecord


BRW35.ApplyFilter PROCEDURE

  CODE
   IF ~(CHOICE(?CurrentTab) = 7)
       BRW35::View:Browse{PROP:SQLFilter} = '1=0'
       RETURN
   END
  
  
   DO MakeFilterABSALinkString
  
!   SETCLIPBOARD('SELECT * FROM ABSA_MatterMessage WHERE ' & LOC:FilterABSALinkString)
!   Message('1 LOC:FilterABSALinkString=' & LOC:FilterABSALinkString)
  
   BRW35::View:Browse{PROP:SQLFilter} = Replace(LOC:FilterABSALinkString,'ABSA_MatterMessage.','A.')
   BRW35::View:Browse{PROP:SQLFilter} = Replace(BRW35::View:Browse{PROP:SQLFilter},'DocGenAlias.','C.')
  
   RETURN
  
  PARENT.ApplyFilter


BRW35.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert:12
    SELF.ChangeControl=?Change:10
    SELF.DeleteControl=?Delete:10
  END


BRW35.ResetQueue PROCEDURE(BYTE ResetMode)

  CODE
  PARENT.ResetQueue(ResetMode)
  IF RECORDS(SELF.ListQueue)
     ?DocumentLogButton:2{PROP:Disable} = False
  ELSE
     ?DocumentLogButton:2{PROP:Disable} = True
  END
  


BRW35.ResetSort PROCEDURE(BYTE Force)

ReturnValue          BYTE,AUTO

  CODE
  IF LOC:ABSA_Matter = 'Current'
    RETURN SELF.SetSort(1,Force)
  ELSE
    RETURN SELF.SetSort(2,Force)
  END
  ReturnValue = PARENT.ResetSort(Force)
  RETURN ReturnValue


BRW35.SetQueueRecord PROCEDURE

  CODE
  GBRAQ:RecordID = MAT1:BranchID
  GET(GBRAQ:BranchQueue,GBRAQ:RecordID)
  IF ERROR() THEN LOC:Branch = 'Unknown Branch' ELSE LOC:Branch = GBRAQ:Description.

  LOC:Employee = GetEmployeeNameFromQueue(ABMM:EmployeeID)
  
  PARENT.SetQueueRecord


BRW33.ApplyFilter PROCEDURE

  CODE
   IF ~(CHOICE(?CurrentTab) = 9)
       BRW33::View:Browse{PROP:SQLFilter} = '1=0'
       RETURN
   END
  
  
   DO MakeFilterSARSLinkString
  
   BRW33::View:Browse{PROP:SQLFilter} = Replace(LOC:FilterSARSLinkString,'SARS_MatterMessage.','A.')
  
   RETURN
  
  PARENT.ApplyFilter


BRW33.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.ChangeControl=?Change:12
    SELF.DeleteControl=?Delete:12
  END


BRW33.ResetQueue PROCEDURE(BYTE ResetMode)

  CODE
  PARENT.ResetQueue(ResetMode)
!  IF RECORDS(SELF.ListQueue)
!     ?SARSJumpToMatterButton{PROP:Disable} = False
!  ELSE
!     ?SARSJumpToMatterButton{PROP:Disable} = True
!  END


BRW33.SetQueueRecord PROCEDURE

  CODE
  LOC:Employee = GetEmployeeNameFromQueue(SMM:EmployeeID)

  PARENT.SetQueueRecord


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  !OMIT('SetStrategyOmit')
  
  SELF.SetParentDefaults
  SELF.SetStrategy(?DocgenDatabaseButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ExtraScreenButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?PartiesButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?MatterEmployeesButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LedgerEnquiryButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?DocumentLogButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?BillOfCostsButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?DebtorsBalanceButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?QuickQuoteButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?MAT:QBESearchButton:2, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?SelectDocumentsButton, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?FindMatterButton, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?FilterButton, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ShowFavouritesButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FilteredMatters:Prompt, Resize:FixLeft+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?LOC:FilteredMatters, Resize:FixLeft+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?LOC:TaggedMatters:Prompt, Resize:FixLeft+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?LOC:TaggedMatters, Resize:FixLeft+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?Group3, Resize:FixLeft+Resize:FixTop, Resize:LockHeight)
  SELF.SetStrategy(?EmailFileNoteButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?PrintFileNoteButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?FIL:QBESearchButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?FIL:QBEPrintButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FIL_Employee, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FIL_EmployeePrompt, Resize:FixRight+Resize:FixTop, Resize:LockWidth)
  SELF.SetStrategy(?LOC:FIL_MatterPrompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FIL_Matter, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FIL_StatusPrompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FIL_Status, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FIL_Period:Prompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FIL_Period, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?Group5, Resize:FixLeft+Resize:FixTop, Resize:LockHeight)
  SELF.SetStrategy(?LOC:TOD_Employee, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:TOD_EmployeePrompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:TOD_MatterPrompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:TOD_Matter, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:TOD_Period:Prompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:TOD_Period, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?CustomTOD_PeriodButton, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?Group4, Resize:FixLeft+Resize:FixTop, Resize:LockHeight)
  SELF.SetStrategy(?LOC:MA_ActivityPrompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:MA_Activity, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:MA_EmployeePrompt, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:MA_Employee, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:MA_CostCentre, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:MA_CostCentrePrompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:MA_BilledFlagPrompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:MA_BilledFlag, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:MA_MatterPrompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:MA_Matter, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:MA_Period:Prompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:MA_Period, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?CustomMA_PeriodButton, Resize:FixRight+Resize:FixTop, Resize:LockWidth)
  SELF.SetStrategy(?LOC:TotalMAMinutes:Prompt, Resize:FixRight+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?LOC:TotalMAMinutes, Resize:FixRight+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?BillableIconString, Resize:FixLeft+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?BillableIcon, Resize:FixLeft+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?DataLinkGroup, Resize:FixLeft+Resize:FixTop, Resize:LockHeight)
  SELF.SetStrategy(?DAT:QBESearchButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?DAT:QBEPrintButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:DAT_MatterPrompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:DAT_Matter, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ExploreOutbox, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ExploreInbox, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?SendXMLMessageButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ViewDatalinkXML, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?SendReceiveButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?SetupDataLinkButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:DAT_Period:Prompt, Resize:FixRight+Resize:FixTop, Resize:LockWidth)
  SELF.SetStrategy(?LOC:DAT_Period, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?CustomDAT_PeriodButton, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:DataLinkInboxStatus, Resize:FixXCenter+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?LOC:MA_EmployeePrompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?MakeRemindersDocumentsButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?TOD:QBESearchButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?TOD:QBEPrintButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?MatterSummaryButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FNBMatterState, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FNBMatterState:Prompt, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?CreateCustomisedInvoiceButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?CustomFNB_PeriodButton, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?SendFNBMessageButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?AttorneyGatewayButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?FNBLinkGroup, Resize:FixLeft+Resize:FixTop, Resize:LockHeight)
  SELF.SetStrategy(?ABSAImportExportButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:ABSA_MatterPrompt, Resize:FixRight, Resize:LockSize)
  SELF.SetStrategy(?LOC:ABSA_Matter, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:ABSA_Period:Prompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:ABSA_Period, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?CustomABSA_PeriodButton, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:ABSAExportedMessage, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ABSALinkGroup, Resize:FixLeft+Resize:FixTop, Resize:LockHeight)
  SELF.SetStrategy(?LOC:FNBExportedMessage, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?RemindersSpeedKeys, Resize:FixRight+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?LOC:QuickSearch:Prompt, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:QuickSearch, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:TOD_CriticalStepPrompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:TOD_CriticalStep, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:TOD_Status, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:TOD_Status:Radio1, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:TOD_Status:Radio2, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:TOD_Status:Radio3, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:TOD_Status:Prompt, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?RemindersSpeedKeys, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?MoveReminderUp, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?MoveReminderDown, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?MattersBrowse, Resize:FixLeft+Resize:FixTop, Resize:ConstantRight+Resize:ConstantBottom)
  SELF.SetStrategy(?CheckSheetButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?Group1, Resize:FixLeft+Resize:FixTop, Resize:ConstantRight+Resize:LockHeight)
  SELF.SetStrategy(?SendEmpMessage, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FNBMatterState, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?InternetNew, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?SendABSAMessageButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ABSAMessageCentreButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ABSAImportExportButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?SARSRegisterButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ViewRatesClearanceButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ABSAMilestoneRulesButton, Resize:FixLeft+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?STDOnlineDocument, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?FileNotePostedImage1, Resize:FixLeft+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?FileNotePostedImage1:String, Resize:FixLeft+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?DisplayDashboard, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LedgerEnquiryButton:2, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?Group2, Resize:FixLeft+Resize:FixTop, Resize:LockHeight)
  SELF.SetStrategy(?SBSAProcessEscalationProcedure, Resize:FixLeft+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?LOC:ABSA_TurnAroundTime, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:ABSA_TurnAroundTime:Prompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ABSAUBODocuments, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  !SetStrategyOmit
  !SELF.SetParentDefaults

  SELF.SetStrategy(?CustomFN_PeriodButton, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FN_Employee, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:PostedOption, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FN_Period:Prompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FN_Period, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:PostedOption:Prompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FN_MatterPrompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FN_Matter, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?CostCentre:Prompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FN_CostCentre, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FN_EmployeePrompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FN_Type:Prompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FN_Type, Resize:FixRight+Resize:FixTop, Resize:LockSize)


  SELF.SetStrategy(?MoveUp, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?MoveDown, Resize:FixRight+Resize:FixTop, Resize:LockSize)
 

  SELF.SetStrategy(?CustomFIL_PeriodButton, Resize:FixRight+Resize:FixTop, Resize:LockSize)


  SELF.SetStrategy(?LOC:FIL_InternalPrompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FIL_Internal, Resize:FixRight+Resize:FixTop, Resize:LockSize)


  SELF.SetStrategy(?PostedIconString, Resize:FixLeft+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?PostedIcon, Resize:FixLeft+Resize:FixBottom, Resize:LockSize)

  SELF.SetStrategy(?DocumentHubButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?DocumentHubButton:2, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:SARS_MatterPrompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:SARS_Matter, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:SARS_Period:Prompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:SARS_Period, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?CustomSARS_PeriodButton, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ToggleMatterIconsButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ToggleFileNoteIconsButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ToggleToDoNoteIconsButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)

  SELF.SetStrategy(?LOC:ABSAMatterState:Prompt, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:ABSAMatterState, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?DocumentLogButton:2, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?Internet, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ABSASendReceiveDocsButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ABSACircularsButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?FNBCircularsButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?SARSCircularsButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FNB_MatterPrompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FNB_Matter, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:AG_Suite_Description:Prompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:AG_Suite_Description, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FNB_Period:Prompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:FNB_Period, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?CustomFNB_PeriodButton, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:ABSA_DG_Code:Prompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:ABSA_DG_Code, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:ABSA_Direction:Prompt, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LOC:ABSA_Direction, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?FN:OptFilterButton, Resize:Fixleft+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?Image1:String, Resize:Fixleft+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?Image1, Resize:Fixleft+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?Image2:String, Resize:Fixleft+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?Image2, Resize:Fixleft+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?LOC:TotalDisb:Prompt, Resize:FixRight+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?LOC:TotalDisb, Resize:FixRight+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?LOC:TotalFees:Prompt, Resize:FixRight+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?LOC:TotalFees, Resize:FixRight+Resize:FixBottom, Resize:LockSize)

  SELF.SetStrategy(?FeeSheetButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ProformaInvoiceButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?PostFeesButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?LedgerEnquiryButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?EmployeeBalancesButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?FN:QBESearchButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?FN:QBEPrintButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?FeeNoteJumpToMatterButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?RefreshFeeNotesButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)


  SELF.SetStrategy(?RefreshFileNotesButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)

  SELF.SetStrategy(?LOC:FilteredFileNotes:Prompt, Resize:FixRight+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?LOC:FilteredFileNotes, Resize:FixRight+Resize:FixBottom, Resize:LockSize)

  SELF.SetStrategy(?LOC:TaggedFileNotes:Prompt, Resize:FixRight+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?LOC:TaggedFileNotes, Resize:FixRight+Resize:FixBottom, Resize:LockSize)


  SELF.SetStrategy(?RefreshToDoNotesButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?MakeDoneButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?AdjustRemindersButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?EmailToDoNoteButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?PrintToDoNoteButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?TOD:QBESearchButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?TOD:QBEPrintButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?MakeRemindersDocumentsButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ToggleToDoNoteIconsButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?ToDoNoteJumpToMatterButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)

  SELF.SetStrategy(?LOC:FilteredReminders:Prompt, Resize:FixRight+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?LOC:FilteredReminders, Resize:FixRight+Resize:FixBottom, Resize:LockSize)

  SELF.SetStrategy(?LOC:TaggedReminders:Prompt, Resize:FixRight+Resize:FixBottom, Resize:LockSize)
  SELF.SetStrategy(?LOC:TaggedReminders, Resize:FixRight+Resize:FixBottom, Resize:LockSize)


  SELF.SetStrategy(?RefreshRemindersButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?RefreshTimeRecordsButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)


  SELF.SetStrategy(?SARSSubmitTDButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?SARSSubmitCancellationButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?SARSRequestCorrespondenceButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?SARSRequestCorrespondenceButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?SARSCheckStatusCurrentMatterButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?SARSLinkJumpToMatterButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?SARSCheckAllStatusesButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?Internet:3, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?SARSCircularsButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)

  SELF.SetStrategy(?SARSLinkGroup, Resize:FixLeft+Resize:FixTop, Resize:LockHeight)
  SELF.SetStrategy(?BondCentreOrGatewayPropertyHubDocsButtonMatterTab, Resize:FixRight+Resize:FixTop, Resize:LockSize)

  SELF.SetStrategy(?LOC:DataLinkInboxStatus, Resize:FixLeft+Resize:FixTop, Resize:LockSize)


  SELF.SetStrategy(?ABSALinkJumpToMatterButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?DataLinkJumpToMatterButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)


  ! ********************************** FIX FOR STBB *******************************************
   SELF.SetStrategy(?DocgenDatabaseButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?ExtraScreenButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?PartiesButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?MatterEmployeesButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?LedgerEnquiryButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?DocumentLogButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?BillOfCostsButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?CreateCustomisedInvoiceButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?DebtorsBalanceButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?DisplayDashboard, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?QuickQuoteButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?ShowFavouritesButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?MatterSummaryButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?MAT:QBESearchButton:2, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?SendEmpMessage, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?ManagementReportButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?UpdateGuarantees, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?CheckSheetButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?ToggleMatterIconsButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)
   SELF.SetStrategy(?ViewRatesClearanceButton, Resize:FixLeft+Resize:FixTop, Resize:LockSize)


  SELF.SetStrategy(?CurrentTab, Resize:FixLeft+Resize:FixTop, Resize:ConstantRight+Resize:ConstantBottom)

  SELF.SetStrategy(?Group1, Resize:FixLeft+Resize:FixTop, Resize:ConstantRight+Resize:LockHeight)

  SELF.SetStrategy(?MattersBrowse, Resize:FixLeft+Resize:FixTop, Resize:ConstantRight+Resize:ConstantBottom)

  SELF.SetStrategy(?BondCentreOrGatewayPropertyHubDocsButtonMatterTab, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?SelectDocumentsButton, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?STDOnlineDocumentMatterTab, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?FindMatterButton, Resize:FixRight+Resize:FixTop, Resize:LockSize)
  SELF.SetStrategy(?FilterButton, Resize:FixRight+Resize:FixTop, Resize:LockSize)



  SELF.SetStrategy(?LOC:TotalMABillableAmount, Resize:FixRight+Resize:FixBottom, Resize:LockSize)



RunBondCentreProgram       PROCEDURE(LONG TheMatterID, LONG TheSuiteID, STRING TheMethod)

  CODE

      IF TheMatterID > 0
         MAT:RecordID = TheMatterID
         IF Access:Matter.Fetch(MAT:PrimaryKey) THEN RETURN.

         TheSuiteID = MAT:LawSuite

         IF ~MAT:BranchID
             MAT:BranchID = GetBranchID()
             If MAT:BranchID
               Access:Matter.Update
             Else
               MESSAGE('No Branch has been allocated to this Matter ( ' & MAT:FileRef & ')','Unable to load the Bond Centre',ICON:Exclamation)
               RETURN
             End
         END
     
         BON:MatterID = MAT:RecordID
         IF Access:BondData.Fetch(BON:PrimaryKey)
            MESSAGE('This Matter (' & MAT:FileRef & ' - ' & MAT:Description & ') has no BondData record associated with it.','No Account Number',ICON:Exclamation)
            RETURN
         END

       END

       IF TheSuiteID = 118 OR TheSuiteID = 119

          !IF CTL:UseLawBondCentreFlag

              IF EXISTS('LAWBondCentre.exe')
                 RUN('LAWBondCentre.exe ConnectionString="' & GLO:ConnectionString & '" ' & CEM:RecordID & ' ' & MAT:RecordID & ' ' & TheSuiteID & ' "' & TheMethod & '"',1) ! RUN THE IMPORT EXPORT PROGRAM  and wait for it to exit
                 If ErrorCode()
                    Message(Error() & '||Error running program LAWBondCentre.exe||Phone LegalSuite Support for assistance','Error running program',ICON:Exclamation)
                  End
              Else
                 Message('LAWBondCentre.exe Not Found||Phone LegalSuite Support for assistance','Error running program',ICON:Exclamation)
              End

!          ELSE
!
!             IF EXISTS('ABSA_BondCentre.exe')
!               RUN('ABSA_BondCentre.exe ConnectionString="' & GLO:ConnectionString & '" ' & CEM:RecordID & ' ' & MAT:RecordID & ' ' & TheSuiteID & ' "' & TheMethod & '"',1) ! RUN THE IMPORT EXPORT PROGRAM
!               If ErrorCode()
!                 Message(Error() & '||Error running program ABSA_BondCentre.exe||Phone LegalSuite Support for assistance','Error running program',ICON:Exclamation)
!               End
!             Else
!               Message('ABSA_BondCentre.exe Not Found||Phone LegalSuite Support for assistance','Error running program',ICON:Exclamation)
!             End

          !END

       ELSIF TheSuiteID = 10 OR TheSuiteID = 12


              IF EXISTS('LAWBondCentre.exe')
                RUN('LAWBondCentre.exe ConnectionString="' & GLO:ConnectionString & '" ' & CEM:RecordID & ' ' & MAT:RecordID & ' ' & TheSuiteID & ' "' & TheMethod & '"',1) ! RUN THE IMPORT EXPORT PROGRAM    and wait for it to exit
                If ErrorCode()
                  Message(Error() & '||Error running program LAWBondCentre.exe||Phone LegalSuite for assistance','Error running program',ICON:Exclamation)
                End
              Else
                Message('LAWBondCentre.exe Not Found||Phone LegalSuite Support for assistance','Error running program',ICON:Exclamation)
              End


        END






GetLAWref        PROCEDURE(LONG TheMatterID)

! GETS THE LAWREF FOR THE MATTER AND IF THERE ARE MORE THAN ONE PROPERTY WITH LAWREFS, IT RETURNS THEM ALL


   CODE

   LOC:MatterLawRef = ''
   CLEAR(ROW:Record)
   PropSQL('SELECT COUNT(1) FROM BondProp WHERE MatterID = ' & TheMatterID & ' AND LawRef > 0')
   IF ROW:Counter
      PropSQLNext('SELECT LawRef FROM BondProp WHERE MatterID = ' & TheMatterID & ' AND LawRef > 0')
      IF LOC:MatterLawRef
         LOC:MatterLawRef = LOC:MatterLawRef & ' / ' & CLIP(LEFT(FORMAT(ROW:Counter,@n_15)))
      ELSE
         LOC:MatterLawRef = CLIP(LEFT(FORMAT(ROW:Counter,@n_15)))
      END
   END

   RETURN LOC:MatterLawRef


GetLAW_Mattr        PROCEDURE

! TRIES TO GET THE LAWREF FROM LAW_MATTR IF NOT FOUND IN MAT:LawRef

LOC:FoundLAW_MattrFlag   BYTE

   CODE

   LOC:FoundLAW_MattrFlag = 0

   IF ~SAV:LastMatterID THEN SAV:LastMatterID = MAT:RecordID.
   
   IF LOC:LAW_Matter = 'Current'
     LOC:MAT:RecordID = LOC:CurrentMatterID
   ELSE
     IF SAV:LastMatterID
       LOC:MAT:RecordID = GetMatterID(SAV:LastMatterID)
     ELSE
       IF ~LOC:CurrentMatterID THEN LOC:CurrentMatterID = MAT1:RecordID.
       LOC:MAT:RecordID = GetMatterID(LOC:CurrentMatterID)
     END
   END
   IF ~LOC:MAT:RecordID
     RETURN LOC:FoundLAW_MattrFlag
   END
   SAV:LastMatterID = LOC:MAT:RecordID

   IF MAT:RecordID <> SAV:LastMatterID
     MAT:RecordID = SAV:LastMatterID
     If Access:Matter.TryFetch(MAT:PrimaryKey)
       RETURN LOC:FoundLAW_MattrFlag
     End
   End

   If LAW_MAT:MatterID <> MAT:RecordID
     LAW_MAT:MatterID = MAT:RecordID
     If Access:LAW_Mattr.TryFetch(LAW_MAT:MatterKey)
       RETURN LOC:FoundLAW_MattrFlag
     End
   End

   IF BON:MatterID <> MAT:RecordID
     BON:MatterID = MAT:RecordID
     If Access:BondData.TryFetch(BON:PrimaryKey)
       RETURN LOC:FoundLAW_MattrFlag
     End
   End

   IF CONV:MatterID <> MAT:RecordID
     CONV:MatterID = MAT:RecordID
     If Access:ConveyData.TryFetch(CONV:PrimaryKey)
       RETURN LOC:FoundLAW_MattrFlag
     End
   End

   LOC:FoundLAW_MattrFlag = 1


   RETURN LOC:FoundLAW_MattrFlag

AddElectronicLinkLog        PROCEDURE(STRING TheMessage1, STRING TheSource, <STRING TheMessage2>, <STRING TheMessage3>)

  CODE

  CLEAR(ELL:Record)
  ELL:EmployeeID = CEM:RecordID
  ELL:Date = TODAY()
  ELL:Time = CLOCK()
  ELL:Message1 = TheMessage1
  ELL:Message1 = TheMessage1
  ELL:Message2 = TheMessage2
  ELL:Message3 = TheMessage3
  ELL:Source = TheSource
  ELL:SuccessFlag = 1

  Access:ElectronicLinkLog.Insert
