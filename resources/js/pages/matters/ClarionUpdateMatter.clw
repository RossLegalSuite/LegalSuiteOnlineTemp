Interpret            PROCEDURE  (TheString)           ! Declare Procedure
LOC:String      CSTRING(10000)

LOC:Test        STRING(20)
  CODE
  LOC:String = TheString

  BIND('LOC:String',LOC:String)

  LOC:Test = EVALUATE('GLO:UserName')
  IF ERRORCODE() THEN BindAllVariables.
  
  IF INSTRING('[[',LOC:String,1)
      
      LOC:String = ReplaceTextBoxFields(LOC:String,MAT:DocumentLanguageID,MAT:ClientID,MAT:RecordID,CTL:ClientRoleID)
      

  ELSE

      IF NUMERIC(LOC:String)
        LOC:String = EVALUATE('''' & LOC:String & '''')  ! EVALUATE(0831234567) = 8231234567 , I.E. IT DROPS THE LEADING ZERO
      ELSE
        LOC:String = EVALUATE(LOC:String)
        IF ~LOC:String
            IF TheString[4] = ':'      ! SOMETHING LIKE MEF:Field1 and MEF:Field1 happens to BE blank
            ELSE
                LOC:String = EVALUATE('''' & TheString & '''')
            END
        END
      END
  END

!  IF GLO:DebuggingFlag
!   MESSAGE('1 Interpreting text||LOC:String = ' & LOC:String &|
!           '|EVALUATE(LOC:String) = ' & EVALUATE(LOC:String) &|
!           '|EVALUATE(''LOC:String'') = ' & EVALUATE('''' & LOC:String & ''''),'Debugging Interpret()',ICON:Exclamation)
!   END
!

  UNBIND('LOC:String')

  RETURN LOC:String


ReplaceTextBoxFields PROCEDURE  (TheString,TheLanguageID,<TheCurrentPartyID>,<TheCurrentMatterID>,<TheCurrentRoleID>) ! Declare Procedure
LOC:SQL              BYTE
LOC:CurrentMatterID LONG
LOC:CurrentPartyID  LONG
LOC:CurrentRoleID   LONG
LOC:FoundBegin      LONG
LOC:FoundEnd        LONG
LOC:FieldName       LIKE(FLD:Name)
LOC:TextField       CSTRING(100000)
LOC:FieldContents   CSTRING(100000)
LOC:SafetyValve     LONG
LOC:Before         CSTRING(100000)
LOC:After          CSTRING(100000)
  CODE
  
  LOC:TextField = TheString
  IF ~INSTRING('[[',LOC:TextField,1) THEN RETURN TheString.
  IF TheCurrentMatterID > -1    ! SET IT TO -1 IF YOU DON'T WANT IT TO GET ALL THE TABLES
    LOC:CurrentMatterID = TheCurrentMatterID
    IF ~LOC:CurrentMatterID THEN LOC:CurrentMatterID = MAT:RecordID.
  END
  IF TheCurrentPartyID > -1
    LOC:CurrentPartyID = TheCurrentPartyID
    IF ~LOC:CurrentPartyID THEN LOC:CurrentPartyID = PAR:RecordID.

    LOC:CurrentRoleID = TheCurrentRoleID
    IF ~LOC:CurrentRoleID THEN LOC:CurrentRoleID = MP:RoleID.

  END
  IF TheLanguageID
    GLO:DocumentLanguageID = TheLanguageID
  ELSE
    GLO:DocumentLanguageID = MAT:DocumentLanguageID
  END
  IF ~GLO:DocumentLanguageID 
      GLO:DocumentLanguageID = CTL:DefaultLanguageID
  END
  IF ~GLO:DocumentLanguageID 
      GLO:DocumentLanguageID = 1
  END

  GetAllTables(LOC:CurrentMatterID,LOC:CurrentPartyID)    ! NEED THESE FOR EVALUATING THE FIELDS
                                                          ! NOTE: PASSING -1 DOESN'T GET ANY TABLES

  LOOP
  
      IF INSTRING('[[IF(',LOC:TextField,1)

          LOC:TextField = ReplaceTextBoxIFStatements(LOC:TextField) ! Checks for any IF statements

      ELSE
  
          BREAK
      END
      LOC:SafetyValve += 1
      IF LOC:SafetyValve > 100 THEN BREAK.
  END

  !Kelvin - 22 Sep 2016 - Reset safety valve for the below loop
  LOC:SafetyValve = 0

  LOOP

      LOC:FieldContents = ''
      LOC:FoundBegin = INSTRING('[[',LOC:TextField,1)
      IF LOC:FoundBegin
          LOC:FoundEnd = INSTRING(']]',LOC:TextField,1)
      END

        
        IF LOC:FoundBegin AND LOC:FoundEnd AND LOC:FoundEnd > LOC:FoundBegin !AND (LOC:FoundEnd - LOC:FoundBegin) < 100    ! JUST IN CASE A FIELD HAS NO ENDING ]]
            LOC:FieldName = SUB(LOC:TextField,LOC:FoundBegin+2,LOC:FoundEnd - (LOC:FoundBegin+2))
            
            IF LOC:FieldName = 'SQL'
                
                LOC:SQL = true
                LOC:Before = SUB(LOC:TextField,1,LOC:FoundBegin -1)
                LOC:TextField = SUB(LOC:TextField,LOC:FoundBegin+7,10000)
                
                LOC:FoundEnd = INSTRING('[[ENDSQL]]',LOC:TextField,1)
                LOC:After = SUB(LOC:TextField,LOC:FoundEnd+10,10000)
                
                LOC:TextField = SUB(LOC:TextField,1,LOC:FoundEnd-1)
                
                LOC:FieldContents = ''
            ELSIF INLIST(LOC:FieldName,'LETTERHEAD','FAXHEAD','ACCOUNTHEAD','PARTICULARS','NONPREJ CLAUSE','EMPLOYEE CLAUSE','HEADER','FOOTER','LOGO:') OR |
              INLIST(LOC:FieldName,'B_SIGN_LINE','S_SIGN_LINE','M_SIGN_LINE')

                  LOC:FieldContents = ''
          
            ELSE
                  
                  CLEAR(FLD:Record)
                  FLD:Name = LOC:FieldName


                  IF FLD:Name[1] = '(' AND FLD:Name[LEN(FLD:name)] = ')'       ! SOMETHING LIKE [[(MAT:FileRef)]]
                    
                    LOC:FieldContents = CLIP(LEFT(EVALUATE(SUB(FLD:Name,2,LEN(FLD:Name)-2))))
                    
                    
                  
                  ELSIF LOC:FieldName = 'TAB'

                    LOC:FieldContents = '<09>'
                    

                  ELSIF LOC:FieldName = 'HRT'

                    LOC:FieldContents = '<13,10>'
                              

                  ELSIF UPPER(LOC:FieldName) = 'SUBTOTAL.AMOUNT'
                        LOC:FieldContents = CLIP(LEFT(FORMAT(GLO:InvoiceDebitTotalAmount+GLO:InvoiceCreditTotalAmount,@N-_18.2b)))

                  ELSIF UPPER(LOC:FieldName) = 'SUBTOTAL.VATAMOUNT'
                        LOC:FieldContents = CLIP(LEFT(FORMAT(GLO:InvoiceDebitTotalVat+GLO:InvoiceCreditTotalVat,@N-_18.2b)))
                        

                  ELSIF UPPER(LOC:FieldName) = 'SUBTOTAL.CREDITAMOUNT'
                        LOC:FieldContents = CLIP(LEFT(FORMAT(GLO:InvoiceCreditTotalAmount,@N-_18.2b)))
                                  
                  ELSIF UPPER(LOC:FieldName) = 'SUBTOTAL.DEBITAMOUNT'
                        LOC:FieldContents = CLIP(LEFT(FORMAT(GLO:InvoiceDebitTotalAmount,@N-_18.2b)))
                                            
                  ELSIF UPPER(LOC:FieldName) = 'SUBTOTAL.FEEAMOUNT'
                        LOC:FieldContents = CLIP(LEFT(FORMAT(GLO:InvoiceFeeTotalAmount,@N-_18.2b)))
                                                      
                  ELSIF UPPER(LOC:FieldName) = 'SUBTOTAL.DISBAMOUNT'
                        LOC:FieldContents = CLIP(LEFT(FORMAT(GLO:InvoiceDisbTotalAmount,@N-_18.2b)))
                                                                
                  ELSIF UPPER(LOC:FieldName) = 'TOTAL.DEBITAMOUNT'
                        LOC:FieldContents = CLIP(LEFT(FORMAT(GLO:InvoiceDebitTotalAmount + GLO:InvoiceDebitTotalVat,@N-_18.2b)))
                                                                          
                  ELSIF UPPER(LOC:FieldName) = 'TOTAL.CREDITAMOUNT'
                        LOC:FieldContents = CLIP(LEFT(FORMAT(GLO:InvoiceCreditTotalAmount + GLO:InvoiceCreditTotalVat,@N-_18.2b)))
                                                                                      
                  ELSIF UPPER(LOC:FieldName) = 'TOTAL.AMOUNT'
                        LOC:FieldContents = CLIP(LEFT(FORMAT(GLO:InvoiceDebitTotalAmount + GLO:InvoiceDebitTotalVat + GLO:InvoiceCreditTotalAmount + GLO:InvoiceCreditTotalVat,@N-_18.2b)))
                                                                                                


                  ELSIF CountPeriods(FLD:Name) >= 3 OR UPPER(FLD:Name[1:9]) = 'SELECTED.' OR UPPER(FLD:Name[1:7]) = 'TAGGED.'
                    LOC:FieldContents = MakeThePartyField(FLD:Name,LOC:CurrentPartyID,LOC:CurrentRoleID,GLO:DocumentLanguageID,'LSW')

                  ELSIF Access:Field.TryFetch(FLD:NameKey) = Level:Benign
                    
                    LOC:FieldContents = MakeTheField('LSW')
                  ELSE
                    
                    LOC:FieldContents = GetUserInput('','Input required [' & MAT:FileRef & '] for ' & LOC:TextField,FLD:NAME & ':')
                  END
            END
            
            LOC:TextField = REPLACE(LOC:TextField,'[[' & LOC:FieldName & ']]',LOC:FieldContents)
            
            



        ELSE
            BREAK
        END
        !Kelvin - 22 Sep 2016 - Added safety valve to this loop
        LOC:SafetyValve += 1
        IF LOC:SafetyValve > 100 THEN BREAK.
  END
  IF LOC:SQL
    ! NOTE: THE USER MUST USE "SELECT 0,NAME FROM....." SO ROW:Description gets the String value
            CLEAR(ROW:Record)
            ROW:Counter = 0
            ROW:Amount1 = 0
            ROW:Description = ''
            PROPSQLNEXT(LOC:TextField)
            IF ROW:Counter
            LOC:TextField = ROW:Counter
            ELSIF ROW:Description
              LOC:TextField = ROW:Description
            ELSIF ROW:Amount1
              LOC:TextField = ROW:Amount1
            ELSE
              LOC:TextField = ''
            END
            
  END
  IF LOC:Before
    LOC:TextField  = LOC:Before  & LOC:TextField !  ReplaceTextBoxFields PROCEDURE  (TheString,TheLanguageID,<TheCurrentPartyID>,<TheCurrentMatterID>,<TheCurrentRoleID>)
  END
  IF LOC:AFter
      LOC:AFter =  ReplaceTextBoxFields(LOC:After,TheLanguageID,TheCurrentPartyID,TheCurrentMatterID,TheCurrentRoleID)
      IF (LOC:After)
        LOC:TextField = LOC:TextField & LOC:After
      END
  END
  RETURN(LOC:TextField)



UpdateMatter PROCEDURE (<LOC:DefaultOption>)          !Generated from procedure template - Window

/***********************************
Look at:
/***********************************
ThisWindow.Open PROCEDURE
ThisWindow.PrimeFields PROCEDURE
ThisWindow.PrimeUpdate PROCEDURE
ThisWindow.Init PROCEDURE
TakeFieldEvent()


SAV:MAT:DebtorPaymentFrequency      BYTE(255)

SAV:MAT:ExtraScreenID           LONG
SAV:MAT:ArchiveFlag     LIKE(MAT:ArchiveFlag)

LOC:NextYPos                    LONG
LOC:AddedSuspendedEmployeeID    LONG
LOC:MovedDown                   BYTE
LOC:ConveyDataExistsFlag        BYTE
SAV:MAT:DocgenID                LONG
SAV:MAT:BranchID                LONG
LOC:VideoToRun                  CSTRING(200)
LOC:ColDataExistsFlag           BYTE
SAV:LOC:InvoicePartyFlag        BYTE(255)
SAV:MAT:OverrideIncomeAccFlag   BYTE(255)
SAV:MAT:InvoiceFlagvoiceFlag    BYTE(255)
SAV:MAT:BranchFlag              BYTE(255)
SAV:LOC:AgreedFeeFlag           BYTE(255)
SAV:MAT:ConsolidatedFlag        BYTE(255)
SAV:MAT:DebtorCollCommOption LIKE(MAT:DebtorCollCommOption)
SAV:MAT:CollCommOption       LIKE(MAT:CollCommOption)
SAV:MAT:ReceiptOption        LIKE(MAT:ReceiptOption)
SAV:MAT:FileRef             LIKE(MAT:FileRef)
LOC:LawRef          LONG

LOC:NextField       LONG
LOC:LettersUsed     CSTRING(100)
LOC:BoundVariablesFlag  BYTE
LOC:Longest1        LONG
LOC:Longest2        LONG
LOC:NeedEntryFlag   BYTE
LOC:ScreenCounter   EQUATE(1)
LOC:ThisField       LONG
LOC:Field           LONG
LOC:FieldCounter    LONG
LOC:ParentField     LONG
LOC:XPos            LONG
LOC:YPos            LONG
LOC:LineSpacing     BYTE
LOC:SafetyValve     LONG
LOC:Wide            LONG
LOC:Medium          LONG
LOC:Narrow1         LONG
LOC:Narrow2         LONG
OTHER:RoleID        LONG
LOC:LeftMargin      LONG
X                   SHORT
Y                   BYTE
Width               SHORT
Height              SHORT
LOC:FirstCustomField    LONG
LOC:LastCustomField     LONG

SAV:Field21YPos         LONG

THIS:Calculation       CSTRING(255)
BIND:FieldCalculation  LIKE(DSF:FieldCalculation)
LOC:MDS:Field          CSTRING(255),DIM(30)
LOC:MDS:Prompt         CSTRING(30),DIM(30)

LOC:DS:FieldCalculation  LIKE(DSF:FieldCalculation),DIM(30)
LOC:DS:FieldType         LIKE(DSF:FieldType),DIM(30)
LOC:DS:FieldRequiredFlag LIKE(DSF:FieldRequiredFlag),DIM(30)
LOC:DS:FieldRequiredCondition  LIKE(DSF:FieldRequiredCondition),DIM(30)
BIND:FieldRequiredCondition  LIKE(DSF:FieldRequiredCondition)

LOC:DS:FieldHelp         LIKE(DSF:FieldHelp),DIM(30)
LOC:DS:Field             LIKE(DSF:FieldPrompt),DIM(30)
LOC:DS:FieldDropDownOptions LIKE(DSF:FieldDropDownOptions),DIM(30)

LOC:DS:DisableFlag LIKE(DSF:DisableFlag),DIM(30)
LOC:DS:DisableCondition  LIKE(DSF:DisableCondition),DIM(30)
BIND:DisableCondition  LIKE(DSF:DisableCondition)

LOC:DS:HideFlag LIKE(DSF:HideFlag),DIM(30)
LOC:DS:HideCondition  LIKE(DSF:HideCondition),DIM(30)
BIND:HideCondition  LIKE(DSF:HideCondition)


LOC:DS:FieldRequiredStarFieldNumber  LONG,DIM(30)

LOC:DS:FieldDefaultValue       CSTRING(255),DIM(30)


LOC:FieldNumber        LONG,DIM(30)
LOC:PromptNumber       LONG,DIM(30)
!LOC:ButtonNumber       LONG,DIM(30)


LOC:Field1      EQUATE(1)
LOC:Field2      EQUATE(2)
LOC:Field3      EQUATE(3)
LOC:Field4      EQUATE(4)
LOC:Field5      EQUATE(5)
LOC:Field6      EQUATE(6)
LOC:Field7      EQUATE(7)
LOC:Field8      EQUATE(8)
LOC:Field9      EQUATE(9)
LOC:Field10      EQUATE(10)
LOC:Field11      EQUATE(11)
LOC:Field12      EQUATE(12)
LOC:Field13      EQUATE(13)
LOC:Field14      EQUATE(14)
LOC:Field15      EQUATE(15)
LOC:Field16      EQUATE(16)
LOC:Field17      EQUATE(17)
LOC:Field18      EQUATE(18)
LOC:Field19      EQUATE(19)
LOC:Field20      EQUATE(20)
LOC:Field21      EQUATE(21)
LOC:Field22      EQUATE(22)
LOC:Field23      EQUATE(23)
LOC:Field24      EQUATE(24)
LOC:Field25      EQUATE(25)
LOC:Field26      EQUATE(26)
LOC:Field27      EQUATE(27)
LOC:Field28      EQUATE(28)
LOC:Field29      EQUATE(29)
LOC:Field30      EQUATE(30)


ProgressWindow WINDOW('Processing Records'),AT(,,201,39),FONT('MS Sans Serif',8,,),CENTER,GRAY,DOUBLE
                PROGRESS,USE(?ProgressBar),AT(7,12,187,10),RANGE(0,100)
              END

LOC:DoNotAddParties BYTE
LOC:AddedDeveloper  BYTE
LOC:ExtraLine       CSTRING(200)
SAV:ClaimAmount         LIKE(MAT:ClaimAmount)
SAV:ArchiveStatus       LIKE(MAT:ArchiveStatus)
!SaveMatter              USHORT
SAV:RoleId              LONG
SAV:BranchFlag          BYTE
SAV:MDF:ClientID        LIKE(MDF:ClientID)
LOC:InsertMatDefaults   BYTE
LOC:PartyMatterNumber   SHORT
SAV:EmployeeID          LONG
SavPosition             STRING(260)
LOC:AddedPlaintiff      BYTE
LOC:AddedSeller         BYTE
LOC:AddedMortgagee      BYTE
LOC:CopyingBondPropID   LONG
LOC:SlashPos            SHORT

SAV:DefaultClientID     LONG
SAV:ToDoNoteDocgenID    LONG

SAV:Mat:Record      LIKE(MAT:Record)
SAV:COL:Record      LIKE(COL:Record)


!FeeSheetQueue       QUEUE,PRE(FSQ)
!Description            LIKE(FS:Description)
!RecordID               LIKE(FS:RecordID)
!                    END
!
SAV:MAT:ClientID         LONG    ! Used to diplay Reminder message

LOC:Password         CSTRING(20)
LOC:GoAhead          BYTE

EnterPasswordWindow WINDOW('Password Required'),AT(,,192,75),FONT('MS Sans Serif',8,,FONT:regular),CENTER, |
        GRAY,MODAL
      STRING('This is an Imported Instruction which means that you'),AT(12,4),USE(?String2)
      STRING('need to enter a Password to perform this operation'),AT(12,14),USE(?PWString2)
      STRING('Password:'),AT(12,30),USE(?PWString1)
      ENTRY(@s20),AT(51,30,126,10),USE(LOC:Password),UPR,PASSWORD
      BUTTON('&OK'),AT(76,52,47,14),USE(?PWOkButton2),LEFT,ICON('smalltick.ico'),DEFAULT
      BUTTON('&Cancel'),AT(130,52,47,14),USE(?PWCancelButton2),LEFT,ICON('smallcross.ico')
    END

CurrentTab           STRING(80)
LOC:SeparateCreditorDisbursementOption BYTE
LOC:Branch           CSTRING(50)
SAV:ClientID         LONG
SAV:MatterTypeID     LONG
SAV:DocgenID         LONG
FilesOpened          BYTE
ActionMessage        CSTRING(40)
LOC:MatterType       CSTRING(50)
LOC:DocumentLanguage CSTRING(20)
LOC:Employee         CSTRING(30)
LOC:ContactName      CSTRING(50)
LOC:ContactType      CSTRING(25)
LOC:DocgenModule     CSTRING(35)
LOC:BankDescription  CSTRING(30)
LOC:ClientFeeSheet   CSTRING(100)
LOC:PartyFeeSheet    CSTRING(100)
LOC:AccountsLanguage CSTRING(20)
LOC:MatGroup         CSTRING(50)
LOC:TakeOnDebit      CSTRING(50)
LOC:Matter           CSTRING(50)
LOC:IncomeAcc        CSTRING(50)
LOC:TrustAccount     CSTRING(50)
LOC:CostCentre       CSTRING(50)
LOC:Event            CSTRING(50)
LOC:ConsolidatedMatter CSTRING(50)
LOC:StatementType    CSTRING(20)
LOC:StatementFormat  CSTRING(20)
LOC:ConsolidatedDesc CSTRING(20)
LOC:SaveDefaultsFlag BYTE
LOC:ClientName       CSTRING(50)
LOC:ClientID         LONG
LOC:ExtraScreen      CSTRING(50)
LOC:MatterPrefix     CSTRING(20)
LOC:NumberOfColumns  SHORT
LOC:ColumnCounter    BYTE
LOC:ToDoGroup        CSTRING(50)
LOC:IncomeAccountDesc CSTRING(55)
LOC:DebtorFeeSheet   CSTRING(50)
LOC:BusinessBank     CSTRING(50)
LOC:TrustBank        CSTRING(50)
LOC:DocGenType       CSTRING(4)
LOC:DeleteArchiveOption BYTE
SAV:ArchiveFlag      BYTE
SAV:LastArchiveId    LONG
SAV:ArchiveNo        LONG
LOC:AgreedFeeFlag    BYTE
LOC:DefaultBillingRate CSTRING(100)
LOC:Docgencode       CSTRING(6)
SAV:ConsolidateId    LONG
LOC:StageGroup       CSTRING(50)
LOC:NextDistributionNo LONG
LOC:Record           LONG
LOC:Records          LONG
LOC:FeeOption        BYTE
LOC:FeeSeparatorOption BYTE
LOC:DisbursementSeparatorOption BYTE
LOC:DisbursementOption BYTE
LOC:FeeSummarizeFlag BYTE
LOC:DisbursementSummarizeFlag BYTE
LOC:FormatOption     BYTE
LOC:SeparatePagesFlag BYTE
LOC:SeparateInvoiceStatementFlag BYTE
LOC:ShowVatFlag      BYTE
LOC:ItemiseCreditorDisbursementOption BYTE
LOC:OverrideInvoiceFormat BYTE
LOC:LookupPropText   STRING(2)
LOC:InvoicePartyFlag BYTE
LOC:InvoiceParty     CSTRING(255)
LOC:LastUpdatedBy    CSTRING(50)
LOC:CauseOfAction    CSTRING(100)
LOC:FileRef          LIKE(MAT:FileRef)
SAV:DocGenType    LIKE(LOC:DocGenType)
SAV:DocGenCode    LIKE(LOC:DocGenCode)
FDB19::View:FileDrop VIEW(LanguageAlias)
                      PROJECT(LAN1:Description)
                      PROJECT(LAN1:RecordID)
                    END
Queue:FileDrop:1     QUEUE                            !Queue declaration for browse/combo box using ?LOC:DocumentLanguage
LAN1:Description       LIKE(LAN1:Description)         !List box control field - type derived from field
LAN1:RecordID          LIKE(LAN1:RecordID)            !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                    END
FDB18::View:FileDrop VIEW(MatType)
                      PROJECT(MT:Description)
                      PROJECT(MT:RecordID)
                    END
Queue:FileDrop:5     QUEUE                            !Queue declaration for browse/combo box using ?LOC:MatterType
MT:Description         LIKE(MT:Description)           !List box control field - type derived from field
MT:RecordID            LIKE(MT:RecordID)              !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                    END
FDB16::View:FileDrop VIEW(FeeSheet)
                      PROJECT(FS:Description)
                      PROJECT(FS:RecordID)
                    END
Queue:FileDrop:6     QUEUE                            !Queue declaration for browse/combo box using ?LOC:ClientFeeSheet
FS:Description         LIKE(FS:Description)           !List box control field - type derived from field
FS:RecordID            LIKE(FS:RecordID)              !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                    END
FDB6::View:FileDrop  VIEW(DocScrn)
                      PROJECT(DS:Description)
                      PROJECT(DS:ScreenType)
                      PROJECT(DS:RecordID)
                    END
Queue:FileDrop:3     QUEUE                            !Queue declaration for browse/combo box using ?LOC:ExtraScreen
DS:Description         LIKE(DS:Description)           !List box control field - type derived from field
DS:ScreenType          LIKE(DS:ScreenType)            !Browse hot field - type derived from field
DS:RecordID            LIKE(DS:RecordID)              !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                    END
FDB10::View:FileDrop VIEW(Language)
                      PROJECT(LAN:Description)
                      PROJECT(LAN:RecordID)
                    END
Queue:FileDrop:4     QUEUE                            !Queue declaration for browse/combo box using ?LOC:AccountsLanguage
LAN:Description        LIKE(LAN:Description)          !List box control field - type derived from field
LAN:RecordID           LIKE(LAN:RecordID)             !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                    END
FDB17::View:FileDrop VIEW(PlanOfAction)
                      PROJECT(POA:Description)
                      PROJECT(POA:RecordID)
                    END
Queue:FileDrop:7     QUEUE                            !Queue declaration for browse/combo box using ?LOC:ToDoGroup
POA:Description        LIKE(POA:Description)          !List box control field - type derived from field
POA:RecordID           LIKE(POA:RecordID)             !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                    END
FDB2::View:FileDrop  VIEW(Docgen)
                      PROJECT(DG:Description)
                      PROJECT(DG:Type)
                      PROJECT(DG:NoOfUsers)
                      PROJECT(DG:ToDoGroupID)
                      PROJECT(DG:Code)
                      PROJECT(DG:RecordID)
                    END
Queue:FileDrop       QUEUE                            !Queue declaration for browse/combo box using ?LOC:DocgenModule
DG:Description         LIKE(DG:Description)           !List box control field - type derived from field
DG:Type                LIKE(DG:Type)                  !Browse hot field - type derived from field
DG:NoOfUsers           LIKE(DG:NoOfUsers)             !Browse hot field - type derived from field
DG:ToDoGroupID         LIKE(DG:ToDoGroupID)           !Browse hot field - type derived from field
DG:Code                LIKE(DG:Code)                  !Browse hot field - type derived from field
DG:RecordID            LIKE(DG:RecordID)              !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                    END
FDB7::View:FileDrop  VIEW(CostCentre)
                      PROJECT(COS:Description)
                      PROJECT(COS:RecordID)
                      PROJECT(COS:NotUsedFlag)
                    END
Queue:FileDrop:10    QUEUE                            !Queue declaration for browse/combo box using ?LOC:CostCentre
COS:Description        LIKE(COS:Description)          !List box control field - type derived from field
COS:RecordID           LIKE(COS:RecordID)             !Browse hot field - type derived from field
COS:NotUsedFlag        LIKE(COS:NotUsedFlag)          !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                    END
FDB23::View:FileDrop VIEW(StageGroup)
                      PROJECT(STG:Description)
                      PROJECT(STG:RecordID)
                    END
Queue:FileDrop:8     QUEUE                            !Queue declaration for browse/combo box using ?LOC:StageGroup
STG:Description        LIKE(STG:Description)          !List box control field - type derived from field
STG:RecordID           LIKE(STG:RecordID)             !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                    END
FDB27::View:FileDrop VIEW(Branch)
                      PROJECT(BRA:Description)
                      PROJECT(BRA:RecordID)
                    END
Queue:FileDrop:9     QUEUE                            !Queue declaration for browse/combo box using ?LOC:Branch
BRA:Description        LIKE(BRA:Description)          !List box control field - type derived from field
BRA:RecordID           LIKE(BRA:RecordID)             !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                    END
FDB31::View:FileDrop VIEW(FeeSheetAlias)
                      PROJECT(FS1:Description)
                      PROJECT(FS1:RecordID)
                    END
Queue:FileDrop:11    QUEUE                            !Queue declaration for browse/combo box using ?FS1:Description
FS1:Description        LIKE(FS1:Description)          !List box control field - type derived from field
FS1:RecordID           LIKE(FS1:RecordID)             !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                    END
FDB32::View:FileDrop VIEW(BondCause)
                      PROJECT(BONC:Description)
                      PROJECT(BONC:RecordID)
                    END
Queue:FileDrop:12    QUEUE                            !Queue declaration for browse/combo box using ?LOC:CauseOfAction
BONC:Description       LIKE(BONC:Description)         !List box control field - type derived from field
BONC:RecordID          LIKE(BONC:RecordID)            !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                    END
BRW20::View:Browse   VIEW(MatGroup)
                      PROJECT(MG:MatterID)
                      PROJECT(MG:GroupID)
                      JOIN(GRO:PrimaryKey,MG:GroupID)
                        PROJECT(GRO:Description)
                        PROJECT(GRO:RecordID)
                      END
                    END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?GroupList
GRO:Description        LIKE(GRO:Description)          !List box control field - type derived from field
MG:MatterID            LIKE(MG:MatterID)              !Primary key field - type derived from field
MG:GroupID             LIKE(MG:GroupID)               !Primary key field - type derived from field
GRO:RecordID           LIKE(GRO:RecordID)             !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
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
QuickWindow          WINDOW('Matter Update Form'),AT(,,473,232),FONT('Arial',9,,),CENTER,IMM,ICON('matters.ico'),SYSTEM,GRAY,DOUBLE,MDI
                      SHEET,AT(4,5,464,201),USE(?CurrentTab),SPREAD
                        TAB('&General'),USE(?Tab:1)
                          GROUP('Client'),AT(12,24,270,78),USE(?Group8),BOXED
                            PROMPT('Cod&e:'),AT(20,36),USE(?Prompt39)
                            ENTRY(@s19),AT(68,36,46,10),USE(LOC:MatterPrefix),IMM,FONT('MS Sans Serif',,,),COLOR(0BDFFFFH),TIP('Type in the Client''s code and press TAB<13,10>This is an auto-complete field, i.e. ty' &|
  'pe the first few character to locate the entry<13,10>[PAR:MatterPrefix]'),ALRT(CtrlUp),ALRT(CtrlDown),ALRT(UpKey),ALRT(DownKey),REQ
                            ENTRY(@s49),AT(120,36,139,10),USE(LOC:ClientName),IMM,SKIP,FONT('MS Sans Serif',,,),COLOR(COLOR:BTNFACE),TIP('The Client''s Name<13,10>[PAR:Name]'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),READONLY
                            BUTTON('...'),AT(264,36,10,10),USE(?SelectClient),SKIP,TIP('Lookup the Address Book')
                            PROMPT('&Reference:'),AT(20,52),USE(?MAT:TheirRef:Prompt)
                            ENTRY(@s49),AT(68,52,77,10),USE(MAT:TheirRef),IMM,FONT('MS Sans Serif',,,),TIP('The client''s reference for this matter<13,10>MAT:TheirRef'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                            PROMPT('Alt Ref:'),AT(156,52),USE(?MAT:AlternateRef:Prompt)
                            ENTRY(@s99),AT(184,52,89,10),USE(MAT:AlternateRef),IMM,FONT('MS Sans Serif',,,),TIP('An alternate reference for this matter<13,10>This field can be used to link to other ' &|
  'programs<13,10>MAT:AlternateRef'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),OVR
                            PROMPT('&Instructed:'),AT(20,68),USE(?Prompt40)
                            SPIN(@d17),AT(68,68,59,10),USE(MAT:DateInstructed),FONT('MS Sans Serif',,,),TIP('The date instructed by client<13,10>MAT:DateInstructed'),STEP(1)
                            PROMPT('LAW Ref:'),AT(148,68),USE(?LOC:LawRef:Prompt),HIDE
                            ENTRY(@n_11),AT(184,68,55,10),USE(LOC:LawRef),SKIP,HIDE,RIGHT(1),FONT('MS Sans Serif',,,),COLOR(COLOR:BTNFACE),TIP('The LAW reference for this Matter<13,10>MAT:LawRef'),READONLY
                            PROMPT('&Fee Sheet'),AT(20,84),USE(?AttorneyClientPrompt)
                            LIST,AT(68,84,124,10),USE(LOC:ClientFeeSheet),TIP('The Fee Sheet used to bill the Client<13,10>[MAT:ClientFeeSheetID]'),FORMAT('196L@s49@'),DROP(15),FROM(Queue:FileDrop:6)
                            CHECK('Put Fees on hold?'),AT(200,84,71,10),USE(MAT:FeeNotesOnHold),SKIP,TIP('Prevent fee notes from being posted to accounting<13,10>MAT:FeeNotesOnHold')
                          END
                          GROUP('Matter'),AT(12,108,270,93),USE(?Group9),BOXED
                            PROMPT('&Description:'),AT(20,120),USE(?MAT:Description:Prompt)
                            ENTRY(@s199),AT(68,120,205,10),USE(MAT:Description),IMM,FONT('MS Sans Serif',,,),TIP('A general description of the Matter<13,10>MAT:Description'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),REQ
                            PROMPT('&File reference:'),AT(20,136),USE(?MAT:FileRef:Prompt)
                            ENTRY(@s49),AT(68,136,72,10),USE(MAT:FileRef),IMM,FONT('MS Sans Serif',,,),TIP('The Code assigned to the Matter<13,10>This is typically your reference on this Matter' &|
  '<13,10>MAT:FileRef'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),OVR
                            PROMPT('O&ld Ref:'),AT(152,136),USE(?MAT:OldRef:Prompt)
                            ENTRY(@s99),AT(184,136,89,10),USE(MAT:OldCode),IMM,FONT('MS Sans Serif',,,),TIP('The number/reference used in a previous computer system<13,10>MAT:OldCode'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                            PROMPT('&Belongs To:'),AT(20,152),USE(?LOC:BelongsTo:Prompt)
                            LIST,AT(68,152,124,10),USE(LOC:Employee),VSCROLL,FONT('MS Sans Serif',,,),TIP('The Employee who ''owns'' this matter<13,10>[MAT:EmployeeID]'),FORMAT('196L(2)|M@s49@'),DROP(25),FROM(GEMPQ:EmployeeQueue)
                            PROMPT('Matter T&ype:'),AT(20,168),USE(?MAT:MatterType:Prompt)
                            LIST,AT(68,168,124,10),USE(LOC:MatterType),FONT('MS Sans Serif',,,),TIP('The type of Matter - a general category to group like matters together<13,10>[MAT:Mat' &|
  'terTypeID]'),FORMAT('196L@s49@'),DROP(10),FROM(Queue:FileDrop:5)
                            CHECK(' Branch?'),AT(20,184),USE(MAT:BranchFlag),TIP('Does this matter belong to a branch?<13,10>[MAT:BranchFlag]')
                            LIST,AT(67,184,124,10),USE(LOC:Branch),FONT('MS Sans Serif',,,),TIP('The branch this Matter belongs to<13,10>[MAT:BranchID]'),FORMAT('196L(2)|M@s49@'),DROP(10),FROM(Queue:FileDrop:9)
                          END
                          GROUP('Settings'),AT(288,24,173,176),USE(?Group12),BOXED
                            PROMPT('Doc&ument Set'),AT(292,36,53,10),USE(?DocgenModule:Prompt)
                            LIST,AT(348,36,105,10),USE(LOC:DocgenModule),FONT('MS Sans Serif',,,),TIP('Which set of documents are used by this Matter<13,10>[MAT:DocgenID]'),FORMAT('80L(2)@s30@'),DROP(20),FROM(Queue:FileDrop)
                            PROMPT('Cause of Action:'),AT(292,52,55,10),USE(?LOC:CauseOfAction:Prompt),HIDE
                            LIST,AT(348,52,105,10),USE(LOC:CauseOfAction),HIDE,FONT('MS Sans Serif',,,),FORMAT('796L(2)|M@s199@'),DROP(25),FROM(Queue:FileDrop:12)
                            PROMPT('&Language:'),AT(292,53,55,10),USE(?LOC:DocumentLanguage:Prompt)
                            LIST,AT(348,52,105,10),USE(LOC:DocumentLanguage),FONT('MS Sans Serif',,,),TIP('The language the documents will be produced in<13,10>[MAT:DocumentLanguageID]'),FORMAT('76L(2)@s19@'),DROP(5),FROM(Queue:FileDrop:1)
                            PROMPT('&Plan of Action:'),AT(292,68,55,10),USE(?LOC:ToDoGroup:Prompt)
                            LIST,AT(348,68,105,10),USE(LOC:ToDoGroup),VSCROLL,FONT('MS Sans Serif',,,),TIP('The pre-defined Reminders for this Matter<13,10>[MAT:ToDoGroupID]'),FORMAT('596L(2)@s149@'),DROP(17),FROM(Queue:FileDrop:7)
                            PROMPT('E&xtra Screen:'),AT(292,84,55,10),USE(?ExtraScreenPrompt)
                            LIST,AT(348,84,105,10),USE(LOC:ExtraScreen),VSCROLL,FONT('MS Sans Serif',,,),TIP('Extra information required for this Matter<13,10>[MAT:ExtraScreenID]'),FORMAT('196L(2)@s49@'),DROP(17),FROM(Queue:FileDrop:3)
                            PROMPT('&Stages'),AT(292,100,55,10),USE(?LOC:StageGroupPrompt)
                            LIST,AT(348,100,105,10),USE(LOC:StageGroup),FONT('MS Sans Serif',,,),TIP('The (default) group of Stages used by this Matter<13,10>These Stages will be displaye' &|
  'd when selecting a Stage for this Matter<13,10>[MAT:StageID]'),FORMAT('196L(2)|M@s49@'),DROP(15),FROM(Queue:FileDrop:8)
                            PROMPT('&Access: '),AT(292,116,55,10),USE(?MAT:Access:Prompt)
                            STRING(''),AT(292,180,162,10),USE(?ParentMatter),TRN
                            LIST,AT(348,116,105,10),USE(MAT:Access),FONT('MS Sans Serif',,,),TIP('Can other Employees access this Matter?<13,10>MAT:Access'),DROP(5),FROM('Open To All|#O|View Only|#V|Restricted|#R')
                            PROMPT('&Fee Estimate:'),AT(292,132,55,10),USE(?MAT:FeeEstimate:Prompt)
                            ENTRY(@n-15.2b),AT(348,132,60,10),USE(MAT:FeeEstimate),DECIMAL(12),FONT('MS Sans Serif',,,),TIP('An estimate (or promise) of the fees that can be expected to be charged on this ' &|
  'Matter<13,10>MAT:FeeEstimate')
                            CHECK('Warning?'),AT(416,132,44,10),USE(MAT:FeeEstimateWarningFlag),TIP('Display a message if the Fees exceed the fee estimate<13,10>MAT:FeeEstimateWarningFla' &|
  'g')
                            PROMPT('F&iling Cabinet:'),AT(292,148,55,10),USE(?MAT:FileCabinet:Prompt)
                            ENTRY(@s30),AT(348,148,105,10),USE(MAT:FileCabinet),IMM,FONT('MS Sans Serif',,,),TIP('A further reference to help locate this matter<13,10>MAT:FileCabinet'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                            PROMPT('Linked Matter'),AT(292,164),USE(?LOC:FileRef:Prompt)
                            ENTRY(@s49),AT(348,164,93,10),USE(LOC:FileRef),IMM,FONT('MS Sans Serif',,,),TIP('Link another matter to this matter<13,10>MAT:LinkedMatterId'),ALRT(UpKey),ALRT(DownKey)
                            BUTTON('...'),AT(444,164,10,10),USE(?LookupMatter),TIP('Select a Matter to assign as the linked matter')
                          END
                        END
                        TAB('&Accounting'),USE(?AccountingTab)
                          GROUP,AT(12,21,251,68),USE(?Group14),BOXED
                            PROMPT('Co&st Centre:'),AT(20,32),USE(?Prompt36)
                            LIST,AT(92,32,150,10),USE(LOC:CostCentre),FONT('MS Sans Serif',,,),TIP('Fees for this matter will be grouped by this Cost Centre<13,10>[MAT:CostCentreID]'),FORMAT('196L@s49@'),DROP(10),FROM(Queue:FileDrop:10)
                            PROMPT('&Accounts Language:'),AT(20,46),USE(?AccountsLanguagePrompt)
                            LIST,AT(92,46,150,10),USE(LOC:AccountsLanguage),FONT('MS Sans Serif',,,),TIP('The Language in which any Accounting documents will be printed<13,10>[MAT:AccountsLan' &|
  'guageID]'),FORMAT('76L@s19@'),DROP(5),FROM(Queue:FileDrop:4)
                            PROMPT('Tr&ust Bank:'),AT(20,60),USE(?Prompt35)
                            BUTTON('...'),AT(244,60,10,10),USE(?LookupTrustBank)
                            ENTRY(@s49),AT(92,60,150,10),USE(LOC:TrustBank),IMM,FONT('MS Sans Serif',,,),COLOR(0BDFFFFH),TIP('The default Trust Bank account used by this Matter<13,10>This is an auto-complete fie' &|
  'ld, i.e. type the first few character to locate the entry<13,10>[MAT:TrustBankID]'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),REQ
                            PROMPT('Business Bank:'),AT(20,74),USE(?Prompt35:2)
                            ENTRY(@s49),AT(92,74,150,10),USE(LOC:BusinessBank),IMM,FONT('MS Sans Serif',,,),COLOR(0BDFFFFH),TIP('The default Business bank account used by this Matter<13,10>This is an auto-complete ' &|
  'field, i.e. type the first few character to locate the entry<13,10>[MAT:BusinessBankI' &|
  'D]'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),REQ
                            BUTTON('...'),AT(244,75,10,10),USE(?LookupBusinessBank)
                          END
                          GROUP('Receipting'),AT(272,24,186,49),USE(?Group15),BOXED
                            LIST,AT(284,36,120,10),USE(?ReceiptOption),FONT('MS Sans Serif',,,),TIP('Specify how receipts are handled for this Matter<13,10>[MAT:ReceiptOption]'),DROP(6),FROM('Normal|Reserve All Receipts|Reserve Up To An Amount|Reserve Up To Claim Amount|Reserve Percentage|Reserve Percentage Up To')
                            ENTRY(@n6.2~%~),AT(408,36,34,9),USE(MAT:ReceiptPercent),HIDE,RIGHT,FONT('MS Sans Serif',,,),TIP('The amount receipts are limited to<13,10>MAT:ReceiptPercent')
                            PROMPT('&Amount:'),AT(284,52),USE(?MAT:ReceiptAmount:Prompt),HIDE
                            ENTRY(@n-15.2),AT(316,52,65,10),USE(MAT:ReceiptAmount),HIDE,DECIMAL(12),FONT('MS Sans Serif',,,),TIP('The amount receipts are limited to<13,10>MAT:ReceiptAmount')
                            PROMPT('Cl&aim Amount:'),AT(284,52),USE(?MAT:ClaimAmount:Prompt:Accounting),HIDE
                            ENTRY(@n-15.2),AT(331,52,60,10),USE(MAT:ClaimAmount,,?MAT:ClaimAmount:Accounting),SKIP,HIDE,DECIMAL(12),FONT('MS Sans Serif',,,),COLOR(COLOR:BTNFACE),MSG('The amount of the claim'),TIP('The amount of the claim'),READONLY
                          END
                          GROUP('Collection Commission'),AT(12,160,251,41),USE(?GroupCollComm),BOXED
                            PROMPT('Matter'),AT(20,172),USE(?Prompt41)
                            LIST,AT(52,171,56,10),USE(?CollCommOption),FONT('MS Sans Serif',,,),TIP('Charge a Fee for money recovered from the Debtor only (i.e. not the Client)<13,10>[MA' &|
  'T:CollCommOption]'),DROP(5),FROM('None|Use Default|Custom(Excl)|Custom (Incl)')
                            ENTRY(@n7.2~%~),AT(112,171,36,10),USE(MAT:CollCommPercent),RIGHT,FONT('MS Sans Serif',,,),TIP('Collection Commission<13,10>MAT:CollCommPercent')
                            ENTRY(@n-15.2),AT(152,171,56,10),USE(MAT:CollCommLimit),RIGHT,FONT('MS Sans Serif',,,),TIP('Maximum Collection Commission To Charge<13,10>MAT:CollCommLimit')
                            CHECK('Split'),AT(212,171,29,11),USE(MAT:CollCommSplitFlag),TIP('Collection commission will be displayed as 2 entries<13,10>The 1st portion will be th' &|
  'e debtors percent<13,10>The 2nd portion will be the remaining percentage.<13,10>MAT:CollCo' &|
  'mmSplitFlag')
                            LIST,AT(52,186,56,10),USE(?DebtorCollCommOption),TIP('Charge the debtor a collection commision fee<13,10>for money recovered from the debto' &|
  'r<13,10>[MAT:DebtorCollCommOption]'),DROP(5),FROM('None|Use Default|Custom (Excl)|Custom (Incl)|Schedule')
                            ENTRY(@n7.2~%~),AT(112,186,36,10),USE(MAT:DebtorCollCommPercent),RIGHT,FONT('MS Sans Serif',,,),TIP('Collection Commission<13,10>MAT:DebtorCollCommPercent')
                            ENTRY(@n-15.2),AT(152,186,56,10),USE(MAT:DebtorCollCommLimit),RIGHT,FONT('MS Sans Serif',,,),TIP('Maximum Collection Commission To Charge<13,10>MAT:DebtorCollCommLimit')
                            PROMPT('Debtor'),AT(20,186),USE(?Prompt42)
                          END
                          GROUP('Options'),AT(272,92,186,108),USE(?MiscSettingsGroup),BOXED
                            CHECK('Ch&arge Admin Fee'),AT(280,122),USE(MAT:AdminFeeFlag),TIP('Charge the client a Monthly Admin Fee if there is any financial movement on this' &|
  ' matter?<13,10>MAT:AdminFeeFlag')
                            CHECK('C&harge Interest'),AT(280,137),USE(MAT:InterestFlag),TIP('Charge the client interest if his account is overdue?<13,10>MAT:InterestFlag')
                            PROMPT('Agents Allowance:'),AT(280,108),USE(?Prompt41:2)
                            LIST,AT(344,108,56,10),USE(MAT:AgentFlag),FONT('MS Sans Serif',,,),TIP('Charge agents allowance on fees<13,10>[MAT:AgentFlag]'),DROP(5),FROM('None|#0|Use Default|#1|Custom|#2')
                            ENTRY(@n-8.4),AT(404,108,43,10),USE(MAT:AgentPercent),RIGHT,FONT('MS Sans Serif',,,),TIP('Charge agents allowance on this matter at this rate<13,10>MAT:AgentPercent')
                            PROMPT('Vat Rate:'),AT(280,184),USE(?Prompt64)
                            CHECK('Charge an Agreed Fee?'),AT(280,167),USE(LOC:AgreedFeeFlag),TIP('The Client has negotiated a set percentage of any receipts as their fee for this' &|
  ' Matter')
                            ENTRY(@n_7.2~%~),AT(372,167,36,10),USE(MAT:AgreedFeePercent),RIGHT(2),FONT('MS Sans Serif',,,),TIP('Percentage of the receipt (incl VAT) to generate as a fee<13,10>(as agreed with the C' &|
  'lient)<13,10>MAT:AgreedFeePercent')
                            CHECK('Limited?'),AT(413,167),USE(MAT:AgreedFeeLimit),TIP('The Agreed Fee is limited to the Debtor''s outstanding costs<13,10>MAT:AgreedFeeLimit')
                            CHECK('Investment Fee'),AT(280,152,63,10),USE(MAT:InvestmentFeeFlag),TIP('Investment Handling Fee - This is charged when interest is added to an investmen' &|
  't<13,10>MAT:InvestmentFeeFlag')
                            LIST,AT(316,184,56,10),USE(MAT:VatExemptFlag),FONT('MS Sans Serif',,,),TIP('You can set the matter to "Zero Rated"<13,10>for overseas clients, etc<13,10>[MAT:VatExemp' &|
  'tFlag]'),DROP(10),FROM('Standard|#0|Zero Rated|#2|Vat Exempt|#1''')
                          END
                          GROUP('Income Allocation'),AT(12,92,251,64),USE(?IncomeAllocationGroup),BOXED
                            STRING('The Default Income Account For This Matter'),AT(20,105),USE(?String5)
                            STRING(@s54),AT(20,116,174,10),USE(LOC:IncomeAccountDesc)
                            CHECK('&Post all fees for this matter to this Income Account?'),AT(20,128),USE(MAT:OverrideIncomeAccFlag),TIP('Force all fees to be posted to a specific income account<13,10>MAT:OverrideIncomeAccF' &|
  'lag')
                            PROMPT('Account:'),AT(20,140,37,10),USE(?IncomeAccount:Prompt)
                            ENTRY(@s49),AT(92,140,150,10),USE(LOC:IncomeAcc),IMM,FONT('MS Sans Serif',,,),COLOR(0BDFFFFH),TIP('The income account the Fees will be posted to<13,10>This is an auto-complete field, i' &|
  '.e. type the first few character to locate the entry<13,10>[MAT:IncomeAccID]'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),REQ
                            BUTTON('...'),AT(244,140,10,10),USE(?LookupIncomeAcc)
                          END
                        END
                        TAB('Invoicing'),USE(?Tab7)
                          GROUP('Consolidation'),AT(12,108,225,46),USE(?ConsolidationGroup),BOXED
                            PROMPT('M&ethod:'),AT(20,120),USE(?Prompt43)
                            LIST,AT(76,120,100,10),USE(MAT:ConsolidatedFlag),FONT('MS Sans Serif',,,),TIP('Consolidate Balance Only - <13,10>   Balance are transfered to the consolidated accou' &|
  'nt.<13,10>   The client for this account is invoiced.<13,10,13,10>Full Consolidation - <13>Transf' &|
  'ers the balance of the individual Matter and creates one consolidated Invoice,<13,10>' &|
  '<13,10>Consolidation Account<13,10>  Other matters are consolidated to this account.<13,10,13,10,13,10>' &|
  'MAT:ConsolidatedFlag'),DROP(10),FROM('No Consolidation|#0|Full Consolidation|#1|Consolidate Balance Only|#2|Consolidation Account|#4')
                            CHECK('Print transactions for each matters on a separate page'),AT(20,136),USE(MAT:ConsolidationOption),HIDE,TIP('The transactions for each matter will be printed on a separate page.<13,10>MAT:Consol' &|
  'idationOption')
                            ENTRY(@s19),AT(76,136,141,10),USE(LOC:ConsolidatedDesc),IMM,FONT('MS Sans Serif',,,),COLOR(0BDFFFFH),TIP('Consolidate transactions to this Matter<13,10>This is an auto-complete field, i.e. ty' &|
  'pe the first few character to locate the entry<13,10>[MAT:ConsolidateID]'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                            BUTTON('...'),AT(220,136,10,10),USE(?SelectConsolidatedMatter)
                            PROMPT('Co&nsolidate To:'),AT(20,136),USE(?ConsolidatedDesc:Prompt)
                          END
                          GROUP,AT(12,156,225,46),USE(?Group20),BOXED
                            CHECK('Invoice Alternate Party'),AT(24,168),USE(LOC:InvoicePartyFlag),TIP('By default an invoice is sent the the client.<13,10>You can override this by selectin' &|
  'g an<13,10>alternate party from this matter')
                            PROMPT('Party:'),AT(24,184),USE(?Prompt70)
                            ENTRY(@s254),AT(76,184,141,10),USE(LOC:InvoiceParty),IMM,FONT('MS Sans Serif',,,),COLOR(0BDFFFFH),TIP('Select party to send invoice to'),ALRT(UpKey),ALRT(DownKey),REQ
                            BUTTON(',,,'),AT(220,184,10,10),USE(?SelectInvoiceParty)
                          END
                          GROUP('Settings'),AT(12,24,451,76),USE(?Group17),BOXED
                            GROUP('Options'),AT(358,32,99,42),USE(?GroupInvoiceOptions),BOXED
                              CHECK('&Do not combine fees'),AT(367,44,81,10),USE(MAT:ConsolidateDisbursementsFlag),TIP('Do not combine fees (that are marked in the fee sheet) together for this matter?' &|
  '<13,10>MAT:ConsolidateDisbursementsFlag')
                              CHECK('Exclude Units'),AT(367,58,60,10),USE(MAT:ExcludeUnitsOnAccountFlag),TIP('Remove unit portion from description on invoice transactions.<13,10>i.e the bracket p' &|
  'ortion will be removed<13,10>e.g  Telephone call (20 min) will become Telephone call<13>' &|
  '<10>MAT:ExcludeUnitsOnAccountFlag')
                            END
                            OPTION('Allow Invoice Creation?'),AT(73,33,161,16),USE(MAT:InvoiceFlag),TIP('Invoice (1) - Regular accounting invoice using posted transactions<13,10>Proforma Acc' &|
  'ount (2) - A proforma invoice including unposted Fee Notes<13,10>None (0) - Do not cr' &|
  'eate invoices for this Matter<13,10>MAT:InvoiceFlag')
                              RADIO('Invoice'),AT(75,37),USE(?MAT:InvoiceFlag:Radio1),TIP('Create a regular accounting invoice from posted transactions<13,10>MAT:InvoiceFlag = ' &|
  '1'),VALUE('1')
                              RADIO('Proforma Account'),AT(114,37),USE(?MAT:InvoiceFlag:Radio2),TIP('Create a Proforma Account from posted transactions and unposted Fee Notes<13,10>MAT:I' &|
  'nvoiceFlag = 2'),VALUE('2')
                              RADIO('None'),AT(187,37),USE(?MAT:InvoiceFlag:Radio3),TIP('Do not create invoices for this Matter<13,10>MAT:InvoiceFlag = 0'),VALUE('0')
                            END
                            PROMPT('Create:'),AT(20,38),USE(?Prompt72)
                            PROMPT('&Balance'),AT(20,53),USE(?Prompt82)
                            LIST,AT(76,53,40,10),USE(MAT:InvoiceBFwdOption),FONT('MS Sans Serif',,,),TIP('Invoice shows BFwd Balance or all transactions on statement<13,10>MAT:InvoiceBFwdOpti' &|
  'on'),DROP(10),FROM('B/Fwd|#1|Full|#2')
                            CHECK('Separate Creditor Disbursements'),AT(152,84),USE(LOC:SeparateCreditorDisbursementOption),TIP('Separate the Creditor and Business disbursements')
                            PROMPT('&Fees'),AT(19,68),USE(?Prompt79)
                            LIST,AT(76,68,70,10),USE(LOC:FeeOption),FONT('MS Sans Serif',,,),TIP('Itemised - Show the amount next to each fee<13,10>Essay Style - Show all fees with on' &|
  'e total<13,10>Totals Only - Show a total for all fees<13,10>MAT:InvoiceFeeOption'),DROP(10),FROM('Itemised|#0|Essay Style|#1|Totals Only|#2')
                            LIST,AT(152,68,100,10),USE(LOC:FeeSeparatorOption),FONT('MS Sans Serif',,,),TIP('Separate fees with semi-colon or <13,10>print each fee on a separate line'),DROP(10),FROM('Separated by a semi-colon|#0|Each on a new line|#1')
                            CHECK('S&ummarise'),AT(152,68),USE(LOC:FeeSummarizeFlag,,?LOC:FeeSummarizeFlag:2),TIP('Summarise fees with the same description<13,10>or fees posted to the same ledger acco' &|
  'unt')
                            CHECK('S&ummarise'),AT(256,68),USE(LOC:FeeSummarizeFlag),TIP('Summarise fees with the same description<13,10>or fees posted to the same ledger acco' &|
  'unt')
                            PROMPT('D&isbursements'),AT(19,84),USE(?Prompt78)
                            LIST,AT(76,84,70,10),USE(LOC:DisbursementOption),FONT('MS Sans Serif',,,),TIP('Itemised - Show the amount next to each Disbursement<13,10>Essay Style - Show all Dis' &|
  'bursements with one total<13,10>Totals Only - Show a total of all the Disbursements<13,10>' &|
  'Creditors Itemised - Total Business Disbursements but Itemise Creditors Disburse' &|
  'ments<13,10>MAT:InvoiceDisbursementOption'),DROP(10),FROM('Itemised|#0|Essay Style|#1|Totals Only|#2|Creditors Itemised|#3')
                            LIST,AT(152,84,100,10),USE(LOC:DisbursementSeparatorOption),FONT('MS Sans Serif',,,),TIP('Separate disbursement with semi-colon or <13,10>print each disbursement on a separate' &|
  ' line'),DROP(10),FROM('Separated by a semi-colon|#0|Each on a new line|#1')
                            CHECK('Su&mmarise'),AT(152,84),USE(LOC:DisbursementSummarizeFlag,,?LOC:DisbursementSummarizeFlag:2),TIP('Summarise disbursements with the same description<13,10>or disbursements posted to th' &|
  'e same ledger account')
                            CHECK('Su&mmarise'),AT(256,84),USE(LOC:DisbursementSummarizeFlag),TIP('Summarise disbursements with the same description<13,10>or disbursements posted to th' &|
  'e same ledger account')
                            CHECK('Itemise Creditor Transactions'),AT(305,84,105,10),USE(LOC:ItemiseCreditorDisbursementOption),HIDE,TIP('Leave disbursements to creditors as itemised transactions.<13,10>')
                          END
                          GROUP('Invoice Options'),AT(316,104,147,97),USE(?GroupInvoiceFormat),BOXED
                            CHECK('Override Invoice Layout'),AT(324,116),USE(LOC:OverrideInvoiceFormat)
                            OPTION('Option 2'),AT(324,132,128,57),USE(LOC:FormatOption)
                              RADIO('Print Invoice && Statements'),AT(324,132),USE(?Option2:Radio1),VALUE('0')
                              RADIO('Print Invoices as Statements'),AT(324,172),USE(?Option2:Radio1:3),VALUE('1')
                            END
                            CHECK('Separate Invoices and Statements'),AT(332,144),USE(LOC:SeparateInvoiceStatementFlag)
                            CHECK('Print on Separate Pages'),AT(332,156),USE(LOC:SeparatePagesFlag)
                            CHECK('Show the VAT'),AT(332,184),USE(LOC:ShowVatFlag)
                          END
                        END
                        TAB('&Litigation'),USE(?CollectionsTab)
                          PROMPT('&Type of case:'),AT(15,28),USE(?TypeOfCasePrompt)
                          OPTION('Case &Type'),AT(64,28,112,16),USE(COL:CaseType),TIP('Action or Application<13,10>[COL:CaseType]')
                            RADIO('Action'),AT(67,28),USE(?COL:CaseType:Radio1),TIP('COL:CaseType = ''Act'''),VALUE('Act')
                            RADIO('Application'),AT(120,28),USE(?COL:CaseType:Radio2),TIP('COL:CaseType = ''App'''),VALUE('App')
                          END
                          GROUP('PTP Details'),AT(276,28,173,87),USE(?Group21),BOXED
                            PROMPT('Amount:'),AT(284,44),USE(?MAT:DebtorPaymentAmount:Prompt)
                            ENTRY(@n-10.2),AT(332,44,49,10),USE(MAT:DebtorPaymentAmount),DECIMAL(12),FONT('MS Sans Serif',,,),TIP('The debtor has made a committment to pay this amount weekly or monthly<13,10>If a dif' &|
  'ferent amount is receipted, a warning will pop up<13,10>MAT:DebtorPaymentAmount')
                            PROMPT('Frequency:'),AT(284,60),USE(?MAT:DebtorPaymentFrequency:Prompt)
                            LIST,AT(332,60,59,10),USE(MAT:DebtorPaymentFrequency),FONT('MS Sans Serif',,,),TIP('The frequency of the Debtor payments<13,10>1 = Monthly; 2 = Weekly<13,10>MAT:DebtorPayment' &|
  'Frequency'),DROP(5),FROM('Monthly|#1|Every 3 Months|#3|Weekly|#2|Bi-Weekly|#4|Every 6 Months|#5')
                            ENTRY(@n_2),AT(416,60,24,10),USE(MAT:DebtorPaymentDay),RIGHT(1),FONT('MS Sans Serif',,,),TIP('The day of the month the payment will be made on (insert 31 if last day of every' &|
  ' month)<13,10>MAT:DebtorPaymentDay')
                            STRING('Day:'),AT(396,60),USE(?MAT:DebtorPaymentDay:Prompt)
                            PROMPT('&Starting From:'),AT(284,76),USE(?COL:PTPStartDate:Prompt)
                            SPIN(@d17b),AT(332,76,59,10),USE(COL:PTPStartDate),RIGHT(1),FONT('MS Sans Serif',,,),TIP('The date when the payments began or the effective date<13,10>COL:PTPStartDate')
                            PROMPT('Method of Payment:'),AT(284,92),USE(?COL:PTPPaymentMethod:Prompt)
                            LIST,AT(352,92,81,10),USE(COL:PTPPaymentMethod),FONT('MS Sans Serif',,,),TIP('How the PTP is being paid.<13,10>COL:PTPPaymentMethod'),DROP(5),FROM('Cash|#Cash|Cheque|#Cheque|Credit Card|#Credit Card|Debit Order|#Debit Order|EFT|#EFT|Other|#Other')
                          END
                          PROMPT('&We act for:'),AT(15,44),USE(?WeActingForPrompt)
                          OPTION('&Acting For'),AT(60,40,117,16),USE(COL:ActingFor),TIP('Who we are acting for<13,10>[COL:ActingFor]')
                            RADIO('Plaintiff'),AT(68,45),USE(?COL:ActingFor:Radio1),TIP('COL:ActingFor = ''P'''),VALUE('P')
                            RADIO('Defendant'),AT(120,45),USE(?COL:ActingFor:Radio2),TIP('COL:ActingFor = ''P'''),VALUE('D')
                          END
                          PROMPT('Status:'),AT(15,76),USE(?StatusPrompt)
                          OPTION,AT(60,72,117,16),USE(COL:Defended),TIP('Is the matter defended or undefended<13,10>[COL:Defended]')
                            RADIO('Undefended'),AT(68,77),USE(?COL:Defended:Radio1),TIP('COL:Defended = ''U'''),VALUE('U')
                            RADIO('Defended'),AT(120,77),USE(?COL:Defended:Radio2),TIP('COL:Defended = ''D'''),VALUE('D')
                          END
                          PROMPT('&Fee Sheet:'),AT(15,92),USE(?AttorneyClientPrompt:2)
                          LIST,AT(68,93,105,10),USE(FS1:Description),FONT('MS Sans Serif',,,),FORMAT('396L(2)|M@s99@'),DROP(15),FROM(Queue:FileDrop:11)
                          PROMPT('C&laim Amount:'),AT(15,108),USE(?MAT:ClaimAmount:Prompt)
                          ENTRY(@n-15.2),AT(68,108,55,10),USE(MAT:ClaimAmount),DECIMAL(12),FONT('MS Sans Serif',,,),TIP('The claim amount or quantum<13,10>MAT:ClaimAmount')
                          PROMPT('Case N&umber:'),AT(136,108),USE(?MAT:CaseNumber:Prompt)
                          ENTRY(@s29),AT(184,108,77,10),USE(MAT:CaseNumber),IMM,FONT('MS Sans Serif',,,),TIP('The case number of this matter<13,10>MAT:CaseNumber'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                          PROMPT('&Interest:'),AT(15,124),USE(?MAT:InterestRate:Prompt)
                          ENTRY(@n11.4~%~),AT(68,124,43,10),USE(MAT:InterestRate),RIGHT,FONT('MS Sans Serif',,,),TIP('The interest charged on the claim by the Plaintiff<13,10>MAT:InterestRate')
                          PROMPT('&From'),AT(116,124),USE(?MAT:InterestFrom:Prompt)
                          ENTRY(@d17),AT(136,124,60,10),USE(MAT:InterestFrom),RIGHT(1),FONT('MS Sans Serif',,,),TIP('The date from which interest can be calculated<13,10>MAT:InterestFrom')
                          PROMPT('Co&urt Date:'),AT(16,140),USE(?COL:CourtDate:Prompt)
                          SPIN(@d17b),AT(68,140,60,10),USE(COL:CourtDate),RIGHT(1),FONT('MS Sans Serif',,,),TIP('The date the Matter has been Set Down<13,10>COL:CourtDate')
                          BUTTON('&Create Reminder'),AT(143,138,66,14),USE(?CreateReminder),LEFT,TIP('Create a Reminder')
                          BUTTON('&Edit Reminder'),AT(143,138,66,14),USE(?EditReminder),LEFT,TIP('Edit the Reminder')
                          CHECK('The National Credit Act applies to this Matter?'),AT(16,157),USE(MAT:NCAFlag),TIP('Does this Matter fall under the National Credit Act?')
                          OPTION,AT(60,56,163,19),USE(COL:CourtFlag),MSG('Which court is the matter being heard in?'),TIP('Which court is the matter being heard in?')
                            RADIO('District'),AT(68,60),USE(?COL:CourtFlag:Radio1),TIP('District Division of the Magistrates Court<13,10>COL:CourtFlag = ''M'''),VALUE('M')
                            RADIO('Regional'),AT(120,60),USE(?COL:CourtFlag:Radio2),TIP('Regional Division of the Magistrates Court<13,10>COL:CourtFlag = ''R'''),VALUE('R')
                            RADIO('High'),AT(174,60),USE(?COL:CourtFlag:Radio3),TIP('The High Court<13,10>COL:CourtFlag = ''H'''),VALUE('H')
                          END
                          PROMPT('Co&urt:'),AT(16,60),USE(?Prompt69)
                          CHECK('Debtor is being charged on the Attorney/Client scale?'),AT(16,172,195,10),USE(COL:AttorneyClientFlag),TIP('Include costs on the processes that are marked ''Attorney/Client''<13,10>COL:AttorneyCl' &|
  'ientFlag')
                          PROMPT('Popup Reminder:'),AT(16,188),USE(?COL:PopupReminder:Prompt)
                          ENTRY(@s199),AT(76,188,191,10),USE(COL:PopupReminder),IMM,FONT('MS Sans Serif',,,),TIP('Show this message whenever the User accesses the Debtors Account<13,10>COL:PopupRemin' &|
  'der'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                          GROUP('Debtor Payment Options (Debtors Account)'),AT(276,124,170,50),USE(?DebtorPaymentGroup),BOXED
                            PROMPT('Receipt Percent To Costs:'),AT(284,140),USE(?MAT:ReceiptPercentToCosts:Prompt)
                            ENTRY(@n-10.2),AT(372,140,29,10),USE(MAT:ReceiptPercentToCosts),DECIMAL(12),FONT('MS Sans Serif',,,),TIP('What percentage of the Debtors receipt goes to cover Costs first.<13,10>The remaining' &|
  ' percent goes to the Client or reduces the Capital<13,10>MAT:ReceiptPercentToCosts')
                            PROMPT('Pay Off these Costs First: '),AT(284,156),USE(?MAT:PayAttorneyFirstAmount:Prompt)
                            ENTRY(@n-15.2),AT(372,156,55,10),USE(MAT:PayAttorneyFirstAmount),DECIMAL(12),FONT('MS Sans Serif',,,),TIP('Any receipts by the debtor will first go to paying off this amount (optional)<13,10>M' &|
  'AT:PayAttorneyFirstAmount')
                            STRING('%'),AT(404,140),USE(?String3:2),FONT(,,,FONT:bold)
                          END
                        END
                        TAB('&Distribution'),USE(?GroupDistributionTab)
                          PROMPT('Cl&aim Amount:'),AT(16,32),USE(?MAT:ClaimAmount:Prompt:3)
                          ENTRY(@n-15.2),AT(92,32,60,10),USE(MAT:ClaimAmount,,?MAT:ClaimAmount:3),SKIP,DECIMAL(12),FONT('MS Sans Serif',,,),COLOR(COLOR:BTNFACE),TIP('The total of all Creditors'' claims'),READONLY
                          ENTRY(@s29),AT(92,48,77,10),USE(MAT:CaseNumber,,?MAT:CaseNumber:2),IMM,FONT('MS Sans Serif',,,),TIP('The case number of this matter'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                          PROMPT('Case N&umber:'),AT(16,48),USE(?MAT:CaseNumber:Prompt:2)
                          PROMPT('Next Distribution No:'),AT(16,64),USE(?MAT:LastDistributionNo:Prompt)
                          ENTRY(@n-14),AT(92,64,60,10),USE(LOC:NextDistributionNo),RIGHT(1),FONT('MS Sans Serif',,,),TIP('The next distribution for this matter<13,10>will be allocated this number')
                          PROMPT('Distribution Group:'),AT(16,80),USE(?Prompt71)
                          LIST,AT(92,80,77,10),USE(MAT:DistributionGroup),FONT('MS Sans Serif',,,),TIP('Allocate this matter to a distribution group.<13,10>MAT:DistributionGroup'),DROP(10),FROM('None|#0|Jan/Apr/Jul/Oct|#1|Feb/May/Aug/Nov|#2|Mar/Jun/Sep/Dec|#3')
                        END
                        TAB('&Miscellaneous'),USE(?MiscellaneousTab)
                          GROUP('Groups Belonged To'),AT(276,25,152,101),USE(?Group13),BOXED
                            LIST,AT(284,37,134,65),USE(?GroupList),IMM,NOBAR,VSCROLL,FONT('MS Sans Serif',,,),TIP('User-defined groups allow you to group certain matters together'),FORMAT('196L(2)@s49@'),FROM(Queue:Browse:1)
                            BUTTON('&Insert'),AT(284,108,30,12),USE(?Insert:2),SKIP
                            BUTTON('&Delete'),AT(320,108,30,12),USE(?Delete:2),SKIP
                          END
                          GROUP('Status'),AT(16,140,215,60),USE(?StatusGroup),BOXED
                            PROMPT('Cu&rrent Status:'),AT(24,153),USE(?Prompt44)
                            LIST,AT(96,153,60,10),USE(?ArchiveStatus),FONT('MS Sans Serif',,,),TIP('Pending means the Matter will be Archived after month end, but  only if it has n' &|
  'o more transactions.<13,10>Archived means it is available but hidden from view. It ca' &|
  'n be unachived to become Live again.<13,10>MAT:ArchiveStatus'),DROP(10),FROM('Live|Pending|Archived')
                            BUTTON('Storage Details'),AT(164,148,60,16),USE(?ButtonStorageDetails)
                            PROMPT('&Archive Date:'),AT(24,169),USE(?MAT:ArchiveDate:Prompt)
                            ENTRY(@d17b),AT(96,169,60,10),USE(MAT:ArchiveDate),LEFT,FONT('MS Sans Serif',,,),TIP('The date this Matter was archived<13,10>MAT:ArchiveDate')
                            PROMPT('A&rchive Number:'),AT(24,185),USE(?MAT:ArchiveNo:Prompt)
                            ENTRY(@n_13b),AT(96,185,60,10),USE(MAT:ArchiveNo),LEFT,FONT('MS Sans Serif',,,),TIP('A unique number used to identify this matter once it has been archived<13,10>MAT:Arch' &|
  'iveNo')
                          END
                          PROMPT('Last Updated By:'),AT(240,192),USE(?Prompt68)
                          STRING(@s49),AT(300,192,161,10),USE(LOC:LastUpdatedBy)
                          GROUP('Sundry Settings'),AT(16,25,215,111),USE(?GroupSundySettings),BOXED
                            PROMPT('&Default Billing Rate:'),AT(24,40),USE(?LOC:DefaultBillingRate:Prompt)
                            ENTRY(@s99),AT(96,40,110,10),USE(LOC:DefaultBillingRate),IMM,SKIP,FONT('MS Sans Serif',,,),COLOR(COLOR:Silver),TIP('The Time Billing Rate nomally used on this Matter<13,10>MAT:DefaultBillingRateID'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),READONLY
                            ENTRY(@n-14),AT(124,40,19,10),USE(MAT:DefaultBillingRateID),HIDE,RIGHT(1),FONT('MS Sans Serif',,,),TIP('The default Rate used to bill Clients')
                            BUTTON('...'),AT(208,40,11,11),USE(?CallLookup),TIP('Lookup a Billing Rate')
                            PROMPT('&Important Date:'),AT(24,56),USE(?MAT:ImportantDate:Prompt)
                            SPIN(@d17b),AT(96,56,68,10),USE(MAT:ImportantDate),RIGHT(1),FONT('MS Sans Serif',,,),TIP('A date linked to a Matter that can be used for any purpose by the user (e.g. in ' &|
  'a document or as a filter for some reports)<13,10>MAT:ImportantDate')
                            PROMPT('Cl&aim Amount:'),AT(24,72),USE(?MAT:ClaimAmount:Prompt:2)
                            ENTRY(@n-15.2),AT(96,72,60,10),USE(MAT:ClaimAmount,,?MAT:ClaimAmount:2),DECIMAL(12),FONT('MS Sans Serif',,,),MSG('The amount of the claim'),TIP('The amount of the claim')
                            PROMPT('&Discount/Surcharge:'),AT(24,88),USE(?MAT:DiscountSurcharge:Prompt)
                            ENTRY(@n-7.2),AT(96,88,29,10),USE(MAT:DiscountSurcharge),DECIMAL(12),FONT('MS Sans Serif',,,),TIP('The discount or surcharge applied to the fee sheet for this matter<13,10>MAT:Discount' &|
  'Surcharge')
                            STRING('%'),AT(128,88),USE(?String3),FONT(,,,FONT:bold)
                            PROMPT('&Prescribes On:'),AT(24,104,55,10),USE(?MAT:PrescriptionDate:Prompt)
                            ENTRY(@D17),AT(96,104,60,10),USE(MAT:PrescriptionDate),RIGHT(1),FONT('MS Sans Serif',,,),TIP('The date this matter can no longer be heard in court or whose legal status <13,10>wil' &|
  'l become invalid or unenforcable by the process of prescription<13,10>MAT:Prescriptio' &|
  'nDate')
                            CHECK('Warning?'),AT(172,104),USE(MAT:ShowPrescriptionWarningFlag),TIP('Display a message warning the user that the matter is due to / has prescribed?')
                            PROMPT('Fica:'),AT(24,120),USE(?Prompt73)
                            CHECK('This matter is exempt from FICA'),AT(96,120),USE(MAT:NoFICAFlag),TIP('This matter will not be checked for FICA compliance')
                          END
                        END
                        TAB('E&xtra Screen1'),USE(?ExtraScreen1Tab),HIDE
                        END
                        TAB('Co&mments'),USE(?CommentsTab)
                          GROUP('General Remarks'),AT(12,28,221,79),USE(?GeneralRemarksGroup),BOXED
                            TEXT,AT(20,44,191,55),USE(MAT:Remarks),VSCROLL,TIP('General remarks regarding this Matter <13,10>These can appear on reports to Client<13,10>(' &|
  '500 characters long)<13,10>MAT:Remarks'),ALRT(CtrlUp),ALRT(CtrlDown)
                            BUTTON,AT(216,44,10,10),USE(?LookupLibraryButton),SKIP,TIP('Lookup and insert text from the Lookup Library (Ctrl L)'),KEY(CtrlL),ICON('Lookup.ico')
                          END
                          GROUP('A&ccounting Message'),AT(244,28,219,79),USE(?AccountingMessageGroup),BOXED
                            PROMPT('&Display:'),AT(252,42),USE(?AccountingCommentOption:Prompt)
                            LIST,AT(280,42,54,10),USE(?AccountingCommentOption),SKIP,FONT('MS Sans Serif',,,),TIP('This message is displayed to the bookkeeper when capturing a transaction<13,10>It can' &|
  ' be set to:<13,10>Default -The message is displayed in the Info Pad<13,10>Popup - The mess' &|
  'age pops up when the Matter is selected<13,10>MAT:CommentOption'),DROP(10),FROM('Default|Popup')
                            TEXT,AT(252,58,190,42),USE(MAT:AccountComment),VSCROLL,TIP('A message for the accounts department<13,10>Can be used to alert the bookeeper when w' &|
  'orking on this Matter<13,10>(250 characters long)<13,10>MAT:AccountComment'),ALRT(CtrlUp),ALRT(CtrlDown)
                            BUTTON,AT(448,58,10,10),USE(?LookupLibraryButton:2),SKIP,TIP('Lookup and insert text from the Lookup Library (Ctrl L)'),KEY(CtrlL),ICON('Lookup.ico')
                          END
                          GROUP('I&nternal Comment:'),AT(244,116,219,83),USE(?InternalCommentGroup),BOXED
                            LIST,AT(280,132,54,10),USE(?InternalCommentOption),SKIP,FONT('MS Sans Serif',,,),TIP('This message is displayed to the user when they access this Matter<13,10>None -The me' &|
  'ssage is not displayed<13,10>Popup - The message pops up when the Matter is accessed<13>' &|
  '<10>MAT:InternalCommentOption'),DROP(10),FROM('None|Popup')
                            PROMPT('&Display:'),AT(252,132),USE(?InternalCommentOption:Prompt:2)
                            TEXT,AT(252,148,190,42),USE(MAT:InternalComment),VSCROLL,TIP('Comment for internal use<13,10>Can be used to alert the users when they access this M' &|
  'atter(250 characters long)<13,10>MAT:InternalComment'),ALRT(CtrlUp),ALRT(CtrlDown)
                            BUTTON,AT(448,148,10,10),USE(?LookupLibraryButton:3),SKIP,TIP('Lookup and insert text from the Lookup Library (Ctrl L)'),KEY(CtrlL),ICON('Lookup.ico')
                          END
                        END
                      END
                      BUTTON('&Snapshot'),AT(4,210,67,20),USE(?SetAsDefault),SKIP,LEFT,TIP('Use this matter as a default when taking on new matters.'),ICON('camera.ico')
                      BUTTON,AT(80,210,26,20),USE(?VidoeButton),HIDE,LEFT,TIP('Watch a training video on this section'),ICON('videocamera_run.ico')
                      BUTTON('&OK'),AT(340,209,62,20),USE(?OK),LEFT,FONT(,11,,),ICON('check3.ico'),DEFAULT
                      BUTTON('&Cancel'),AT(408,209,62,20),USE(?Cancel),LEFT,FONT(,11,,),ICON('delete32.ico')
                    END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Open                   PROCEDURE(),DERIVED
PrimeFields            PROCEDURE(),PROC,DERIVED
PrimeUpdate            PROCEDURE(),BYTE,PROC,DERIVED
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
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                    END

FDB19                CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:1              !Reference to display queue
                    END

FDB18                CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:5              !Reference to display queue
                    END

FDB16                CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:6              !Reference to display queue
                    END

FDB6                 CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:3              !Reference to display queue
ValidateRecord         PROCEDURE(),BYTE,DERIVED
                    END

FDB10                CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:4              !Reference to display queue
                    END

FDB17                CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:7              !Reference to display queue
                    END

FDB2                 CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop                !Reference to display queue
ValidateRecord         PROCEDURE(),BYTE,DERIVED
                    END

FDB7                 CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:10             !Reference to display queue
                    END

FDB23                CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:8              !Reference to display queue
                    END

FDB27                CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:9              !Reference to display queue
                    END

FDB31                CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:11             !Reference to display queue
                    END

FDB32                CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:12             !Reference to display queue
TakeAccepted           PROCEDURE(),DERIVED
                    END

BRW20                CLASS(BrowseClass)               !Browse using ?GroupList
Q                      &Queue:Browse:1                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
                    END

BRW20::Sort0:Locator StepLocatorClass                 !Default Locator
CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
                    END

  CODE
  GlobalResponse = ThisWindow.Run()

SetEmployeeDropDown         ROUTINE

  IF MAT:EmployeeID

    GEMPQ:RecordID = MAT:EmployeeID
    GET(GEMPQ:EmployeeQueue,GEMPQ:RecordID)

    IF ERROR()         ! THE USER MAY BE SUSPENDED SO ADD THEM TEMPORARILY TO THE GEMPQ: SO THE DROP DOWN WORKS AS NORMAL  (AND TAKE THEM OUT WHEN CLOSING THIS WINDOW)

      CLEAR(GEMPQ:EmployeeQueue)
      GEMPQ:Name = GETDescription('Employee',MAT:EmployeeID)

      IF GEMPQ:Name

          GEMPQ:RecordID = MAT:EmployeeID
          ADD(GEMPQ:EmployeeQueue,GEMPQ:Name)

          LOC:AddedSuspendedEmployeeID = MAT:EmployeeID

          LOC:Employee = GEMPQ:Name
          ?LOC:Employee{PROP:Selected} = POSITION(GEMPQ:EmployeeQueue)

      END

    ELSE

        LOC:Employee = GEMPQ:Name
        ?LOC:Employee{PROP:Selected} = POSITION(GEMPQ:EmployeeQueue)

    END


  END



AddCheckSheetScreens ROUTINE

  ! JAN 2010 - ADD THEM NOW BECAUSE SOME EVENTS ETC WRITE TO THEM IMMEDIATELY AND IF THEY DON'T EXIST IT CAUSES PROBLEMA

!  Access:CheckSheetScreen.Open
!  Access:CheckSheetScreen.UseFile

  CLEAR(DS:Record)
  SET(DS:PrimaryKey,DS:PrimaryKey)
  LOOP UNTIL Access:DocScrn.Next()
  
      IF ~DS:TrueCondition THEN CYCLE.

      IF ~DS:ScreenType = 'C' THEN CYCLE.    ! ONLY LOOK AT CHECK SHEET SCREENS

      IF DS:TrueCondition
        IF EVALUATE(DS:TrueCondition) = '0' THEN CYCLE.
      END


      CLEAR(CSS:Record)
      CSS:MatterID = MAT:RecordID
      CSS:DocScreenID = DS:RecordID
      IF Access:CheckSheetScreen.TryFetch(CSS:PrimaryKey)
        CSS:MatterID = MAT:RecordID
        CSS:DocScreenID = DS:RecordID
        Access:CheckSheetScreen.Insert
      END
  
  END

!  Access:CheckSheetScreen.Close


MoveSettingsFields      ROUTINE

    IF ~MAT:DocgenID THEN EXIT.


    DG:RecordID = MAT:DocgenID
    IF Access:Docgen.Fetch(DG:PrimaryKey)
        MESSAGE('Error getting Document Set (' & MAT:DocgenID & ')','Error',ICON:Exclamation)
        EXIT
    END


    LOC:NextYPos = 52

    IF MAT:DocgenID = CTL:TransfersDocgenID
        UNHIDE(?LOC:CauseOfAction:Prompt)
        UNHIDE(?LOC:CauseOfAction)
        LOC:NextYPos += 16
    ELSE
        CONV:BondCauseID = 0
        HIDE(?LOC:CauseOfAction:Prompt)
        HIDE(?LOC:CauseOfAction)
    END


    ?LOC:DocumentLanguage:Prompt{PROP:Ypos} = LOC:NextYPos
    ?LOC:DocumentLanguage{PROP:Ypos} = LOC:NextYPos
    LOC:NextYPos += 16

    IF DG:HidePlanOfActionFlag
        HIDE(?LOC:ToDoGroup:Prompt,?LOC:ToDoGroup)
    ELSE
        UNHIDE(?LOC:ToDoGroup:Prompt,?LOC:ToDoGroup)
        ?LOC:ToDoGroup:Prompt{PROP:Ypos} = LOC:NextYPos
        ?LOC:ToDoGroup{PROP:Ypos} = LOC:NextYPos
        LOC:NextYPos += 16
    END

    IF DG:HideExtraScreenFlag
        HIDE(?ExtraScreenPrompt,?LOC:ExtraScreen)
    ELSE
        UNHIDE(?ExtraScreenPrompt,?LOC:ExtraScreen)
        ?ExtraScreenPrompt{PROP:Ypos} = LOC:NextYPos
        ?LOC:ExtraScreen{PROP:Ypos} = LOC:NextYPos
        LOC:NextYPos += 16
    END

    IF DG:HideStagesFlag
        HIDE(?LOC:StageGroupPrompt,?LOC:StageGroup)
    ELSE
        UNHIDE(?LOC:StageGroupPrompt,?LOC:StageGroup)
        ?LOC:StageGroupPrompt{PROP:Ypos} = LOC:NextYPos
        ?LOC:StageGroup{PROP:Ypos} = LOC:NextYPos
        LOC:NextYPos += 16
    END

    IF DG:HideAccessFlag
        HIDE(?MAT:Access:Prompt,?MAT:Access)
    ELSE
        UNHIDE(?MAT:Access:Prompt,?MAT:Access)
        ?MAT:Access:Prompt{PROP:Ypos} = LOC:NextYPos
        ?MAT:Access{PROP:Ypos} = LOC:NextYPos
        LOC:NextYPos += 16
    END


    IF DG:HideFeeEstimateFlag
        HIDE(?MAT:FeeEstimate:Prompt,?MAT:FeeEstimateWarningFlag)
    ELSE
        UNHIDE(?MAT:FeeEstimate:Prompt,?MAT:FeeEstimateWarningFlag)
        ?MAT:FeeEstimate:Prompt{PROP:Ypos} = LOC:NextYPos
        ?MAT:FeeEstimate{PROP:Ypos} = LOC:NextYPos
        ?MAT:FeeEstimateWarningFlag{PROP:Ypos} = LOC:NextYPos
        LOC:NextYPos += 16
    END




    IF DG:HideFilingCabinetFlag
        HIDE(?MAT:FileCabinet:Prompt,?MAT:FileCabinet)
    ELSE
        UNHIDE(?MAT:FileCabinet:Prompt,?MAT:FileCabinet)
        ?MAT:FileCabinet:Prompt{PROP:Ypos} = LOC:NextYPos
        ?MAT:FileCabinet{PROP:Ypos} = LOC:NextYPos
        LOC:NextYPos += 16
    END

!18/11/2014 Rick - Moved to Miscellaneous settings because could not move the pop-up date calendar next to it
    
    IF DG:HidePrescribesOnFlag
        HIDE(?MAT:PrescriptionDate:Prompt,?MAT:PrescriptionDate)
        !FB 880 hide warning as well
        HIDE(?MAT:ShowPrescriptionWarningFlag)
    ELSE
        UNHIDE(?MAT:PrescriptionDate:Prompt,?MAT:PrescriptionDate)
        !FB 880 hide warning as well
        UNHIDE(?MAT:ShowPrescriptionWarningFlag)
    END


    ?LOC:FileRef:Prompt{PROP:Ypos} = LOC:NextYPos
    ?LOC:FileRef{PROP:Ypos} = LOC:NextYPos
    ?LookupMatter{PROP:Ypos} = LOC:NextYPos
    LOC:NextYPos += 16


AddClientParty   ROUTINE

  IF ~(SAV:ClientID = MAT:ClientID) AND MAT:ClientID

      DG:RecordID = MAT:DocgenID
      Access:Docgen.Fetch(DG:PrimaryKey)

      SAV:ClientID = MAT:ClientID

      PAR:RecordID = MAT:ClientID              ! UPDATE LOC:ClientName
      IF ~Access:Party.Fetch(PAR:PrimaryKey)

          LOC:ClientName = PAR:Name
          LOC:MatterPrefix = PAR:MatterPrefix
          IF ~PAR:ClientFlag                       ! MARK THE CLIENT PARTY AS A CLIENT
              PAR:ClientFlag = True
              Access:Party.Update()
          END
      ELSE
          LOC:ClientName = ''
          LOC:MatterPrefix = ''
          DISPLAY
          EXIT
      END

      CLEAR(MP:Record)
      MP:MatterID = MAT:RecordID               ! ADD THE CLIENT TO THE MATTERPARTIES
      MP:RoleID = CTL:ClientRoleID
      MP:Sorter = 1
      IF Access:MatParty.TryFetch(MP:MatterRoleKey)     ! THERE IS NO CLIENT IN THE LIST OF MATTER PARTIES
          MP:MatterID = MAT:RecordID
          MP:RoleID = CTL:ClientRoleID
          MP:PartyID = MAT:ClientID

          MP:ContactID = GetDefaultContact(MP:PartyID)
          MP:LanguageID = GetDefaultPartyLanguage(MP:PartyID)

          MP:Reference = MAT:TheirRef
          MP:MatterDescription = MAT:Description
          Access:MatParty.TryInsert

      ELSE
          MP:PartyID = MAT:ClientID
          IF MAT:TheirRef THEN MP:Reference = MAT:TheirRef.
          IF ~MP:ContactID
              MP:ContactID = GetDefaultContact(MP:PartyID)
          END
          MP:MatterDescription = MAT:Description
          Access:MatParty.TryUpdate

      END


      IF MAT:DocgenID AND ~LOC:AddedPlaintiff AND DG:Type = 'LIT' AND DG:Code <> 'AMO'
          CLEAR(MP:Record)
          MP:MatterID = MAT:RecordID
          IF COL:ActingFor = 'D' THEN MP:RoleID = CTL:DefendantRoleID ELSE MP:RoleID = CTL:PlaintiffRoleID.
          MP:Sorter = 1
          IF Access:MatParty.TryFetch(MP:MatterRoleKey)     ! THERE IS NO PLAINTIFF IN THE LIST OF MATTER PARTIES
            MP:MatterID = MAT:RecordID
            IF COL:ActingFor = 'D' THEN MP:RoleID = CTL:DefendantRoleID ELSE MP:RoleID = CTL:PlaintiffRoleID.
            MP:PartyID = MAT:ClientID
            MP:Reference = MAT:TheirRef
            MP:MatterDescription = MAT:Description
            MP:LanguageID = GetDefaultPartyLanguage(MP:PartyID)

            IF ~Access:MatParty.Insert()
                LOC:AddedPlaintiff = True
            END
          END
      END

      IF MAT:DocgenID AND ~LOC:AddedSeller AND DG:Type = 'TRN'
          CLEAR(MP:Record)
          MP:MatterID = MAT:RecordID
          MP:RoleID = CTL:SellerRoleID
          MP:Sorter = 1
          IF Access:MatParty.TryFetch(MP:MatterRoleKey)     ! THERE IS NO SELLER IN THE LIST OF MATTER PARTIES
            MP:MatterID = MAT:RecordID
            MP:RoleID = CTL:SellerRoleID
            MP:PartyID = MAT:ClientID
            MP:ContactID = GetDefaultContact(MP:PartyID)
            MP:LanguageID = GetDefaultPartyLanguage(MP:PartyID)
            MP:Reference = MAT:TheirRef
            MP:MatterDescription = MAT:Description

            IF ~Access:MatParty.Insert()
                LOC:AddedSeller = True
            END
          END
      END

      IF MAT:DocgenID AND ~LOC:AddedMortgagee AND DG:Type = 'BON'
          CLEAR(MP:Record)
          MP:MatterID = MAT:RecordID
          MP:RoleID = CTL:MortgageeRoleID
          MP:Sorter = 1
          IF Access:MatParty.TryFetch(MP:MatterRoleKey)     ! THERE IS NO MORTGAGOR IN THE LIST OF MATTER PARTIES
            MP:MatterID = MAT:RecordID
            MP:RoleID = CTL:MortgageeRoleID
            MP:PartyID = MAT:ClientID
            MP:ContactID = GetDefaultContact(MP:PartyID)
            MP:LanguageID = GetDefaultPartyLanguage(MP:PartyID)
            MP:Reference = MAT:TheirRef
            MP:MatterDescription = MAT:Description

            IF ~Access:MatParty.Insert()
                LOC:AddedMortgagee = True
            END
          END
      END

      IF MAT:DocgenID AND ~LOC:AddedDeveloper AND DG:Type = 'STR'
          CLEAR(MP:Record)
          MP:MatterID = MAT:RecordID
          MP:RoleID = CTL:DeveloperRoleID
          MP:Sorter = 1
          IF Access:MatParty.TryFetch(MP:MatterRoleKey)     ! THERE IS NO MORTGAGOR IN THE LIST OF MATTER PARTIES
            MP:MatterID = MAT:RecordID
            MP:RoleID = CTL:DeveloperRoleID
            MP:PartyID = MAT:ClientID
            MP:ContactID = GetDefaultContact(MP:PartyID)
            MP:LanguageID = GetDefaultPartyLanguage(MP:PartyID)
            MP:Reference = MAT:TheirRef
            MP:MatterDescription = MAT:Description

            IF ~Access:MatParty.Insert()
                LOC:AddedDeveloper = True

            END
          END
      END

  END


AddMatterDescription        ROUTINE
      IF CEM:AutoDescriptionFlag

          IF CEM:AutoDescriptionSeparator AND ~CEM:DefaultMatterDescription

            OTHER:RoleID = 0
            DG:RecordID = MAT:DocgenID
            IF Access:DocGen.TryFetch(DG:PrimaryKey) THEN CLEAR(DG:Record).

            CASE DG:Type
                  OF 'LIT'
                      IF COL:ActingFor = 'D' THEN OTHER:RoleID = CTL:PlaintiffRoleID ELSE OTHER:RoleID = CTL:DefendantRoleID.
                  OF 'TRN'
                      OTHER:RoleID = CTL:BuyerRoleID
                  OF 'BON'
                      OTHER:RoleID = CTL:MortgagorRoleID
            END

            CLEAR(MP:Record)
            MP:MatterID = MAT:RecordId
            MP:Sorter   = 1
            MP:RoleID   = OTHER:RoleID
            IF Access:MatParty.Fetch(MP:MatterRoleKey)

                MAT:Description = LOC:ClientName

            ELSE

                MAT:Description = LOC:ClientName & ' ' & GLO:AutoDescriptionSeparator & ' ' & GetDescription('PARTY NAME',MP:PartyID)

            END

          ELSE
            IF CEM:DefaultMatterDescription

                Access:Matter.Update
                MAT:Description = Interpret(CEM:DefaultMatterDescription)
                debug('MAT:Description= ' & MAT:Description & ' Interpret(' & CEM:DefaultMatterDescription & ')')
            END
          END

          IF MAT:Description
            MP:MatterID = MAT:RecordID               ! PUT IN THE MATTER DESCRIPTION
            MP:RoleID = CTL:ClientRoleID
            MP:Sorter = 1
            IF ~Access:MatParty.TryFetch(MP:MatterRoleKey)
                MP:MatterDescription = MAT:Description
                Access:MatParty.TryUpdate
            END

            DISPLAY(?MAT:Description)

          END

      END
SetDefaults        Routine


  CLEAR(MDF:Record)
  MDF:EmployeeID = GLO:EmployeeId               ! IF MDF:CLIENTID = 0 THEN THIS IS THE 'GENERAL' MATTER DEFAULTS
  MDF:ClientID = MAT:ClientID




  IF ~Access:MatDef.Fetch(MDF:EmployeeClientKey)



      AssignMatterDefaults


      IF ~MAT:BranchFlag THEN MAT:BranchID = 0.


      If MAT:AgreedFeePercent Then LOC:AgreedFeeFlag = True ELSE LOC:AgreedFeeFlag = False.

      Do SetScreenFields


  END



  If LOC:DefaultOption
    MAT:DocgenId = CTL:AMODocgenId
    MAT:CollCommOption = 'N'
    MAT:DebtorCollCommOption = 'N'
    MAT:DistributionGroup = (Month(GLO:TodaysDate)-1)%3+1
  .

SaveDefaults    Routine

  ! Update MAT:Records before saving
  Do SetInvoiceOption

  LOC:InsertMatDefaults = False

  CLEAR(MDF:Record)
  MDF:EmployeeID = GLO:EmployeeId
  MDF:ClientID = MAT:ClientID
  SET(MDF:EmployeeClientKey,MDF:EmployeeClientKey)
  If ~Access:MatDef.Next() AND MDF:EmployeeID = GLO:EmployeeId  AND MDF:ClientID = MAT:ClientID
  ELSE
      LOC:InsertMatDefaults = True
  END

  MDF:EmployeeID             = GLO:EmployeeId

  MDF:CaseType             = COL:CaseType
  MDF:ActingFor            = COL:ActingFor
  MDF:CourtFlag            = COL:CourtFlag
  MDF:Defended             = COL:Defended
  MDF:AttorneyClientFlag   = COL:AttorneyClientFlag
  MDF:CourtDate            = COL:CourtDate

  MDF:MatterEmployeeID       = MAT:EmployeeId
  MDF:BondCauseID            = CONV:BondCauseID

  MDF:ClientID               = MAT:ClientID
  MDF:DocgenID               = MAT:DocgenID
  MDF:ToDoGroupID            = MAT:ToDoGroupID
  MDF:MatterTypeID           = MAT:MatterTypeID
  MDF:DocumentLanguageID     = MAT:DocumentLanguageID
  MDF:ExtraScreenID          = MAT:ExtrascreenID
  MDF:BankID                 = MAT:BankID
  MDF:FileCabinet            = MAT:FileCabinet
  MDF:Discount               = MAT:Discount
  MDF:PrescriptionDate       = MAT:PrescriptionDate
  MDF:CaseNumber             = MAT:CaseNumber
  MDF:Access                 = MAT:Access
  MDF:TheirRef               = MAT:TheirRef
  MDF:Contact                = MAT:Contact
  MDF:Salutation             = MAT:Salutation
  MDF:OldRef                 = MAT:OldCode
  MDF:CommentOption          = MAT:CommentOption
  MDF:InternalCommentOption  = MAT:InternalCommentOption
  MDF:InternalComment        = MAT:InternalComment
  MDF:AccountComment         = MAT:AccountComment
  MDF:ClientFeeSheetID       = MAT:ClientFeeSheetID
  MDF:DebtorFeeSheetID       = MAT:DebtorFeeSheetID
  MDF:AccountsLanguageID     = MAT:AccountsLanguageID
  MDF:FeeNotesOnHold         = MAT:FeeNotesOnHold
  MDF:InterestRate           = MAT:InterestRate
  MDF:AgentFlag              = MAT:AgentFlag
  MDF:AdminFeeFlag           = MAT:AdminFeeFlag
  MDF:InterestFlag           = MAT:InterestFlag
  MDF:VatExemptFlag          = MAT:VatExemptFlag
  MDF:InvestmentFeeFlag      = MAT:InvestmentFeeFlag
  MDF:DiscountSurcharge      = MAT:DiscountSurcharge
  MDF:ReceiptOption          = MAT:ReceiptOption
  MDF:ReceiptAmount          = MAT:ReceiptAmount
  MDF:ReceiptPercent         = MAT:ReceiptPercent
  MDF:ConsolidateId          = MAT:ConsolidateId
  MDF:ConsolidatedFlag       = MAT:ConsolidatedFlag
  MDF:InvoiceFlag            = MAT:InvoiceFlag
  MDF:InvoiceBFwdOption         = MAT:InvoiceBFwdOption
  MDF:InvoiceFeeOption          = MAT:InvoiceFeeOption
  MDF:InvoiceDisbursementOption = MAT:InvoiceDisbursementOption
  MDF:InvoiceFormat          = MAT:InvoiceFormat
  MDF:CostCentreID           = MAT:CostCentreID
  MDF:OverrideIncomeAccFlag  = MAT:OverrideIncomeAccFlag
  MDF:IncomeAccId            = MAT:IncomeAccId
  MDF:TrustBankId            = MAT:TrustBankId
  MDF:BusinessBankId         = MAT:BusinessBankId
  MDF:BranchFlag             = MAT:BranchFlag
  MDF:BranchID               = MAT:BranchID
  MDF:MovementFlag           = MAT:MovementFlag
  MDF:CollCommOption         = MAT:CollCommOption
  MDF:CollCommPercent        = MAT:CollCommPercent
  MDF:CollCommLimit          = MAT:CollCommLimit
  MDF:DebtorCollCommOption   = MAT:DebtorCollCommOption
  MDF:DebtorCollCommPercent  = MAT:DebtorCollCommPercent
  MDF:DebtorCollCommLimit    = MAT:DebtorCollCommLimit
  MDF:ConsolidateDisbursementsFlag = MAT:ConsolidateDisbursementsFlag
  MDF:AgreedFeePercent       = MAT:AgreedFeePercent
  MDF:AgreedFeeLimit         = MAT:AgreedFeeLimit
  MDF:ReceiptPercentToCosts  = MAT:ReceiptPercentToCosts
  MDF:PayAttorneyFirstAmount = MAT:PayAttorneyFirstAmount
  MDF:ColDebitFeeCodeID      = MAT:ColDebitFeeCodeID

  MDF:ExcludeUnitsOnAccountFlag    = MAT:ExcludeUnitsOnAccountFlag

  MDF:DefaultBillingRateID   = MAT:DefaultBillingRateID
  MDF:StageGroupID           = MAT:StageGroupID



  IF ~MDF:BranchFlag THEN SETNULL(MDF:BranchID).

  IF MDF:BranchID = 0 THEN SETNULL(MDF:BranchID).  ! SO IT DOESN'T USE THE DEFAULT SETTINGS FOR BRANCH (NONE)

  IF MDF:ExtraScreenID = 0 THEN SETNULL(MDF:ExtraScreenID).


  ! QUICK WAY TO ASSIGN MATGROUPS TO THE DEFAULTS WITHOUT HAVING TO CREATE ANOTHER TABLE
  MDF:MatGroup = ''
  IF RECORDS(Queue:Browse:1)
    LOOP X# = 1 TO RECORDS(Queue:Browse:1)
          GET(Queue:Browse:1,X#)
          IF MDF:MatGroup 
            MDF:MatGroup = MDF:MatGroup & ' ' & Queue:Browse:1.MG:GroupID
          ELSE
            MDF:MatGroup = Queue:Browse:1.MG:GroupID
          END
    END
  END
  MDF:ShowPrescriptionWarningFlag = MAT:ShowPrescriptionWarningFlag
  IF LOC:InsertMatDefaults
    If Access:MatDef.Insert() Then Exit.
  ELSE
    If Access:MatDef.Update() Then Exit.
  END



SetScreenFields      Routine


  If MAT:AgreedFeePercent Then LOC:AgreedFeeFlag = True.
  If MAT:InvoicePartyId Then LOC:InvoicePartyFlag = True.
  SAV:LastArchiveId = CTL:LastArchiveId
  SAV:ArchiveNo = MAT:ArchiveNo

  ?ReceiptOption{PROP:Selected} = MAT:ReceiptOption + 1
  ?CollCommOption{PROP:Selected} = InList(MAT:CollCommOption,'N','U','C')
  ?DebtorCollCommOption{PROP:Selected} = InList(MAT:DebtorCollCommOption,'N','U','C','I','S')
  ?ArchiveStatus{PROP:Selected} = MAT:ArchiveStatus + 1


  ! GET THE DROP DOWNS TO REFLECT THE MATTER DEFAULTS

  IF CONV:BondCauseID
    BONC:RecordID = CONV:BondCauseID
    IF ~Access:BondCause.TryFetch(BONC:PrimaryKey)
    END
  END

  DO SetEmployeeDropDown

  ?AccountingCommentOption{PROP:Selected} = MAT:CommentOption + 1
  ?InternalCommentOption{PROP:Selected} = MAT:InternalCommentOption + 1
  


  IF MAT:ClientId
    PAR:RecordId = MAT:ClientId
    IF ~Access:Party.TryFetch(PAR:PrimaryKey)
        LOC:ClientName = PAR:Name
        LOC:MatterPrefix = PAR:MatterPrefix
    ELSE
      LOC:ClientName = ''
      LOC:MatterPrefix = ''
    END

  ELSE
    LOC:ClientName = ''
    LOC:MatterPrefix = ''
  .

  If MAT:ConsolidateId
    MAT1:RecordId = MAT:ConsolidateId
    IF ~Access:MatterAlias.TryFetch(MAT1:PrimaryKey)
        LOC:ConsolidatedDesc = MAT1:FileRef
    Else
      LOC:ConsolidatedDesc = ''
    END
  Else
    LOC:ConsolidatedDesc = ''
  .

  If MAT:OverrideIncomeAccFlag and MAT:IncomeAccId
    BLM:RecordId  = MAT:IncomeAccId
    IF ~Access:Business.TryFetch(BLM:PrimaryKey)
        LOC:IncomeAcc = BLM:Description
    Else
      LOC:IncomeAcc = ''
    END
  Else
    LOC:IncomeAcc = ''
  .



  IF MAT:TrustBankId
    BLM:RecordId  = MAT:TrustBankId
    IF ~Access:Business.TryFetch(BLM:PrimaryKey)
        LOC:TrustBank = BLM:Description
    ELSE
        LOC:TrustBank = ''
    END
  ELSE
    LOC:TrustBank = ''
  END

  IF MAT:BusinessBankId
    BLM:RecordId = MAT:BusinessBankId
    IF ~Access:Business.TryFetch(BLM:PrimaryKey)
        LOC:BusinessBank = BLM:Description
    ELSE
        LOC:BusinessBank = ''
    END
  ELSE
      LOC:BusinessBank = ''
  END





!  If MAT:BranchID 
!
!    BRA:RecordID = MAT:BranchID
!    IF ~Access:Branch.TryFetch(BRA:PrimaryKey)
!        LOC:Branch = BRA:Description
!    ELSE
!        LOC:Branch = ''
!    END
!
!  ELSE
!
!    LOC:Branch = ''
!
!  END
!

  IF MAT:DefaultBillingRateID
    BR:RecordID = MAT:DefaultBillingRateID
    IF ~Access:BillingRate.TryFetch(BR:PrimaryKey)
        LOC:DefaultBillingRate = BR:Description
    ELSE
        LOC:DefaultBillingRate = ''
    END
  ELSE
    LOC:DefaultBillingRate = ''
  END

Case MAT:InvoiceFeeOption
Of 0
  LOC:FeeOption          = 0 ! Itemised
  LOC:FeeSeparatorOption = 0
  LOC:FeeSummarizeFlag   = 0
Of 1
  LOC:FeeOption          = 1 ! Essay Style
  LOC:FeeSeparatorOption = 0 ! Semicolon
  LOC:FeeSummarizeFlag   = 0
Of 2
  LOC:FeeOption          = 1 ! Essay Style
  LOC:FeeSeparatorOption = 1 ! Cr/Lf
  LOC:FeeSummarizeFlag   = 0
Of 3
  LOC:FeeOption          = 1 ! Essay Style
  LOC:FeeSeparatorOption = 0 ! Semicolon
  LOC:FeeSummarizeFlag   = 1 ! Summarise
Of 4
  LOC:FeeOption          = 1 ! Essay Style
  LOC:FeeSeparatorOption = 1 ! Cr/Lf
  LOC:FeeSummarizeFlag   = 1 ! Summarise
Of 5 ! Itemised Summary
  LOC:FeeOption          = 0 ! Itemised
  LOC:FeeSeparatorOption = 0 
  LOC:FeeSummarizeFlag   = 1 ! Summarise
Of 6 ! Total Only
  LOC:FeeOption          = 2 ! Totals Only
  LOC:FeeSeparatorOption = 0
  LOC:FeeSummarizeFlag   = 0 
.

Case MAT:InvoiceDisbursementOption
Of 0                                                                                                           
  LOC:DisbursementOption           = 0 ! Itemised
  LOC:DisbursementSeparatorOption  = 0
  LOC:DisbursementSummarizeFlag    = 0
Of 1
  LOC:DisbursementOption           = 1 ! Essay Style
  LOC:DisbursementSeparatorOption  = 0 ! Semicolon
  LOC:DisbursementSummarizeFlag    = 0
Of 2
  LOC:DisbursementOption           = 1 ! Essay Style
  LOC:DisbursementSeparatorOption  = 1 ! Cr/Lf
  LOC:DisbursementSummarizeFlag    = 0
Of 3
  LOC:DisbursementOption           = 1 ! Essay Style
  LOC:DisbursementSeparatorOption  = 0 ! Semicolon
  LOC:DisbursementSummarizeFlag    = 1 ! Summarise
Of 4
  LOC:DisbursementOption           = 1 ! Essay Style
  LOC:DisbursementSeparatorOption  = 1 ! Cr/Lf
  LOC:DisbursementSummarizeFlag    = 1 ! Summarise
Of 5 ! Itemised Summary
  LOC:DisbursementOption           = 0 ! Itemised
  LOC:DisbursementSeparatorOption  = 0
  LOC:DisbursementSummarizeFlag    = 1 ! Summarise
Of 6 ! Total Only
  LOC:DisbursementOption           = 2 ! Totals Only
  LOC:DisbursementSeparatorOption  = 0
  LOC:DisbursementSummarizeFlag    = 0


! Itemise Creditors Disbursements ----------------------------------------------

Of 7 
  LOC:DisbursementOption           = 1 ! Essay Style
  LOC:DisbursementSeparatorOption  = 0 ! Semicolon
  LOC:DisbursementSummarizeFlag    = 0
  LOC:ItemiseCreditorDisbursementOption = 1
Of 8
  LOC:DisbursementOption           = 1 ! Essay Style
  LOC:DisbursementSeparatorOption  = 1 ! Cr/Lf
  LOC:DisbursementSummarizeFlag    = 0
  LOC:ItemiseCreditorDisbursementOption = 1
Of 9
  LOC:DisbursementOption           = 1 ! Essay Style
  LOC:DisbursementSeparatorOption  = 0 ! Semicolon
  LOC:DisbursementSummarizeFlag    = 1 ! Summarise
  LOC:ItemiseCreditorDisbursementOption = 1
Of 10
  LOC:DisbursementOption           = 1 ! Essay Style
  LOC:DisbursementSeparatorOption  = 1 ! Cr/Lf
  LOC:DisbursementSummarizeFlag    = 1 ! Summarise
  LOC:ItemiseCreditorDisbursementOption = 1

Of 11 ! Total both Business and Creditor Disbursements
  LOC:DisbursementOption           = 2 ! 
  LOC:DisbursementSeparatorOption  = 0
  LOC:DisbursementSummarizeFlag    = 0
  LOC:SeparateCreditorDisbursementOption = 1


Of 12 ! Total both Business Disbursements but itemise Creditor Disbursements
  LOC:DisbursementOption           = 3
  LOC:DisbursementSeparatorOption  = 0
  LOC:DisbursementSummarizeFlag    = 0
  LOC:SeparateCreditorDisbursementOption = 1

.

  If MAT:InvoiceFormat
    LOC:OverrideInvoiceFormat = True
    Case MAT:InvoiceFormat
    Of 1 ! Old Onvoice
      LOC:FormatOption = 0
    Of 2 ! New Format
      LOC:FormatOption = 0
      LOC:SeparateInvoiceStatementFlag = True
    Of 3 ! Separate Pages
      LOC:FormatOption = 0
      LOC:SeparateInvoiceStatementFlag = True
      LOC:SeparatePagesFlag = True
    Of 4 ! Invoices Must Show as Statements
      LOC:FormatOption = 1
    Of 5
      LOC:FormatOption = 1
      LOC:ShowVATFlag = True
    .
  Else
    LOC:OverrideInvoiceFormat = False
    Case CTL:InvoiceFormat
    Of 1 ! Old Onvoice
      LOC:FormatOption = 0
    Of 2 ! New Format
      LOC:FormatOption = 0
      LOC:SeparateInvoiceStatementFlag = True
    Of 3 ! Separate Pages
      LOC:FormatOption = 0
      LOC:SeparateInvoiceStatementFlag = True
      LOC:SeparatePagesFlag = True
    Of 4 ! Invoices Must Show as Statements
      LOC:FormatOption = 1
    Of 5
      LOC:FormatOption = 1
      LOC:ShowVATFlag = True
    .
  .
CheckFields     Routine


  If ~MAT:DocumentLanguageID
    MAT:DocumentLanguageID = GLO:DefaultLanguageID
  .
  If ~MAT:AccountsLanguageID
    MAT:AccountsLanguageID = GLO:DefaultLanguageID
  .
  If ~MAT:TrustBankId
    MAT:TrustBankId = CTL:TrustBankId
  .
  If ~MAT:BusinessBankId
    MAT:BusinessBankId = CTL:BusinessBankId
  .
  If MAT:ArchiveFlag
    If MAT:ArchiveStatus <> 2 Then MAT:ArchiveStatus = 2.
  Else
    If ~InRange(MAT:ArchiveStatus,0,1) Then MAT:ArchiveStatus = 0.
  .
  IF MAT:DocgenID
    DG:RecordID = MAT:DocgenID
    IF ~Access:Docgen.TryFetch(DG:PrimaryKey)
        LOC:DocGenType = DG:Type
        LOC:DocGenCode = DG:Code
    Else
      LOC:DocGenType = ''
      LOC:DocGenCode = ''
    .
  Else
    LOC:DocGenType = ''
    LOC:DocGenCode = ''
  .
  !If LOC:DocGenType = 'LIT' and ~MAT:DebtorFeeSheetID Then Do GetMagCourtFeeSheet.

  IF ~MAT:InterestRate
      CLEAR(CDE:Record)
      CDE:EmployeeID = GLO:EmployeeID
      CDE:LanguageID = MAT:DocumentLanguageID
      IF ~Access:ColDef.TryFetch(CDE:PrimaryKey)
          MAT:InterestRate = CDE:InterestRate
      END
  END

  IF MAT:CollCommOption = 'U'
    MAT:CollCommPercent = CTL:CollCommPercent
    MAT:CollCommLimit   = CTL:CollCommLimit
  END

  IF MAT:DebtorCollCommOption = 'U'
    MAT:DebtorCollCommPercent = CTL:CollCommPercent
    MAT:DebtorCollCommLimit   = CTL:CollCommLimit
  END


CopyMatParty    ROUTINE             ! DONE WHEN INIT THE PROCEDURE

  CLEAR(MP:Record)
  MP:MatterID = GLO:CopyingRecordID
  SET(MP:MatterRoleKey,MP:MatterRoleKey)
  LOOP UNTIL Access:MatParty.Next()
      IF ~(MP:MatterID = GLO:CopyingRecordID) THEN BREAK.
      SavPosition = POSITION(MP:MatterRoleKey)
      MP:MatterID = MAT:RecordID
      Access:MatParty.Insert()
      
      REGET(MP:MatterRoleKey,SavPosition)
      SET(MP:MatterRoleKey,MP:MatterRoleKey)
      IF Access:MatParty.Next() THEN BREAK.
  END


TakeFieldEvent      ROUTINE


  IF ~(SAV:MAT:BranchFlag = MAT:BranchFlag)
        SAV:MAT:BranchFlag = MAT:BranchFlag


        IF MAT:BranchFlag

          ?LOC:Branch{PROP:Disable} = False

        Else

          MAT:BranchID = 0
          LOC:Branch = ''
          CHANGE(?LOC:Branch,'')
          DISPLAY(?LOC:Branch)

          ?LOC:Branch{PROP:Disable} = True

        End
    END



    IF ~(SAV:MAT:BranchID = MAT:BranchID) AND MAT:BranchID AND MAT:BranchFlag

          SAV:MAT:BranchID = MAT:BranchID

          BRA:RecordID = MAT:Branchid
          IF ~Access:Branch.TryFetch(BRA:PrimaryKey)
              IF MAT:TrustBankID AND MAT:TrustBankID <> BRA:TrustBankID 
                MAT:TrustBankID = BRA:TrustBankID
              END
              IF MAT:BusinessBankID AND MAT:BusinessBankID <> BRA:BusinessBankID
                MAT:BusinessBankID = BRA:BusinessBankID
              END
          END

    END



    IF ~(SAV:MAT:ExtraScreenID = MAT:ExtraScreenID) AND MAT:ExtraScreenID
          SAV:MAT:ExtraScreenID = MAT:ExtraScreenID

            DO DisplayExtraScreen

    END



    IF ?CollectionsTab{PROP:Hide} <> 1     !THIS IS A COLLECTIONS/LITIGATION MATTER


        IF ~(SAV:MAT:DebtorPaymentFrequency = MAT:DebtorPaymentFrequency)
            SAV:MAT:DebtorPaymentFrequency = MAT:DebtorPaymentFrequency
            IF MAT:DebtorPaymentFrequency = 1 OR MAT:DebtorPaymentFrequency = 3 OR MAT:DebtorPaymentFrequency = 5
                ?MAT:DebtorPaymentDay{PROP:Hide} = False
                ?MAT:DebtorPaymentDay:Prompt{PROP:Hide} = False
            ELSE
                ?MAT:DebtorPaymentDay{PROP:Hide} = True
                ?MAT:DebtorPaymentDay:Prompt{PROP:Hide} = True
            END
        END



        IF ~LOC:ColDataExistsFlag

            COL:MatterID = MAT:RecordID
            IF Access:ColData.TryFetch(COL:MatterKey)
            
              CLEAR(COL:Record)
              COL:MatterID = MAT:RecordID

              CLEAR(MDF:Record)
              MDF:EmployeeID = GLO:EmployeeId               ! IF MDF:CLIENTID = 0 THEN THIS IS THE 'GENERAL' MATTER DEFAULTS
              MDF:ClientID = MAT:ClientID
              IF ~Access:MatDef.Fetch(MDF:EmployeeClientKey)
                  COL:CaseType             = MDF:CaseType
                  COL:ActingFor            = MDF:ActingFor
                  COL:CourtFlag            = MDF:CourtFlag
                  COL:Defended             = MDF:Defended
                  COL:AttorneyClientFlag   = MDF:AttorneyClientFlag
                  COL:CourtDate            = MDF:CourtDate
              END


              IF Access:ColData.TryInsert()
                  MESSAGE('Error encountered adding ColData.||Error = ' & ERROR(),'Adding ColData',ICON:Exclamation)
              ELSE
                  LOC:ColDataExistsFlag = 1
              END

            ELSE
              LOC:ColDataExistsFlag = 1
            END

        END

    END


    IF ~(SAV:MAT:ClientID = MAT:ClientID) AND MAT:ClientID AND ThisWindow.Request = InsertRecord AND Field() <> ?LOC:MatterPrefix
          SAV:MAT:ClientID = MAT:ClientID

        ! DISPLAY THE REMINDER MESSAGE FOR THIS CLIENT
          IF PAR:MatterTakeOnReminder
            MESSAGE(PAR:MatterTakeOnReminder,'Reminder',ICON:Exclamation)
          END

    END

    IF SAV:DocGenCode <> LOC:DocGenCode OR SAV:DocGenType = LOC:DocGenType

        SAV:DocGenCode = LOC:DocGenCode
        SAV:DocGenType = LOC:DocGenType

        IF LOC:DocGenCode = 'AMO'
          ?GroupDistributionTab{PROP:Hide} = False
          ?CollectionsTab{PROP:Hide} = True
          ?GroupSundySettings{PROP:Hide} = True
          ?DebtorPaymentGroup{PROP:Hide} = True
        ELSE
          ?GroupDistributionTab{PROP:Hide} = True
          ?GroupSundySettings{PROP:Hide} = False
          ?DebtorPaymentGroup{PROP:Hide} = False
          If LOC:DocGenType = 'LIT' OR LOC:DocGenType = 'RAF'
            ?CollectionsTab{PROP:Hide} = False
            If LOC:DocGenType = 'RAF'
              ?DebtorPaymentGroup{PROP:Hide} = True
            ELSE
              ?DebtorPaymentGroup{PROP:Hide} = False
            END
          ELSE
            ?CollectionsTab{PROP:Hide} = True

          END
        END

        IF ?CollectionsTab{PROP:Hide} <> 1

          IF ~COL:CourtFlag THEN COL:CourtFlag = 'M'.
          IF ~COL:CaseType THEN COL:CaseType = 'Act'.
          IF ~COL:ActingFor THEN COL:ActingFor = 'P'.
          IF ~COL:Defended THEN COL:Defended = 'U'.

          ! 05/07/2017 PK Naidoo - FB Case 857
          IF COL:CourtDateReminderID
              
              ?CreateReminder{PROP:Hide} = True
              ?EditReminder{PROP:Hide} = False
        
          ELSE
              
              ?CreateReminder{PROP:Hide} = False
              ?EditReminder{PROP:Hide} = True
        
          END


        END

    END
##Here
    IF ~(SAV:MAT:ReceiptOption = MAT:ReceiptOption)
        SAV:MAT:ReceiptOption = MAT:ReceiptOption
        Case MAT:ReceiptOption
        Of 2
          ?MAT:ReceiptPercent{PROP:Hide} = True
          ?MAT:ReceiptAmount:Prompt{PROP:Hide} = False
          ?MAT:ReceiptAmount{PROP:Hide} = False
          ?MAT:ClaimAmount:Prompt:Accounting{PROP:Hide} = True
          ?MAT:ClaimAmount:Accounting{PROP:Hide} = True
        Of 3
          ?MAT:ReceiptPercent{PROP:Hide} = True
          ?MAT:ReceiptAmount:Prompt{PROP:Hide} = True
          ?MAT:ReceiptAmount{PROP:Hide} = True
          ?MAT:ClaimAmount:Prompt:Accounting{PROP:Hide} = False
          ?MAT:ClaimAmount:Accounting{PROP:Hide} = False
        Of 4
          ?MAT:ReceiptPercent{PROP:Hide} = False
          ?MAT:ReceiptAmount:Prompt{PROP:Hide} = True
          ?MAT:ReceiptAmount{PROP:Hide} = True
          ?MAT:ClaimAmount:Prompt:Accounting{PROP:Hide} = True
          ?MAT:ClaimAmount:Accounting{PROP:Hide} = True
        Of 5
          ?MAT:ReceiptPercent{PROP:Hide} = False
          ?MAT:ReceiptAmount:Prompt{PROP:Hide} = False
          ?MAT:ReceiptAmount{PROP:Hide} = False
          ?MAT:ClaimAmount:Prompt:Accounting{PROP:Hide} = True
          ?MAT:ClaimAmount:Accounting{PROP:Hide} = True
        ELSE
          ?MAT:ReceiptPercent{PROP:Hide} = True
          ?MAT:ReceiptAmount:Prompt{PROP:Hide} = True
          ?MAT:ReceiptAmount{PROP:Hide} = True
          ?MAT:ClaimAmount:Prompt:Accounting{PROP:Hide} = True
          ?MAT:ClaimAmount:Accounting{PROP:Hide} = True
        END
    END
  
    If ~(SAV:MAT:OverrideIncomeAccFlag = MAT:OverrideIncomeAccFlag)
        SAV:MAT:OverrideIncomeAccFlag = MAT:OverrideIncomeAccFlag
        If MAT:OverrideIncomeAccFlag
          ?IncomeAccount:Prompt{PROP:Disable} = False
          ?LOC:IncomeAcc{PROP:Disable} = False
          ?LOC:IncomeAcc{PROP:Background} = Color:None
          ?LookupIncomeAcc{PROP:Disable} = False
        Else
          ?IncomeAccount:Prompt{PROP:Disable} = True
          ?LOC:IncomeAcc{PROP:Disable} = True
          ?LOC:IncomeAcc{PROP:Background} = COLOR:BTNFACE
          ?LookupIncomeAcc{PROP:Disable} = True
        End
    END

    If ~(SAV:MAT:ConsolidatedFlag = MAT:ConsolidatedFlag)
        SAV:MAT:ConsolidatedFlag = MAT:ConsolidatedFlag
        Case MAT:ConsolidatedFlag
        Of 0
          ?MAT:ConsolidationOption{PROP:Hide} = True
          ?ConsolidatedDesc:Prompt{PROP:Hide} = False
          ?LOC:ConsolidatedDesc{PROP:Hide}    = False
          ?SelectConsolidatedMatter{PROP:Hide} = False
          ?LOC:ConsolidatedDesc{PROP:Skip}       = False
          ?LOC:ConsolidatedDesc{PROP:ReadOnly}   = False
          ?LOC:ConsolidatedDesc{PROP:Background} = COLOR:BTNFACE
          ?SelectConsolidatedMatter{PROP:Disable} = True
        Of 4
          ?MAT:ConsolidationOption{PROP:Hide} = False
          ?ConsolidatedDesc:Prompt{PROP:Hide} = True
          ?LOC:ConsolidatedDesc{PROP:Hide}    = True
          ?SelectConsolidatedMatter{PROP:Hide} = True
        Else
          ?MAT:ConsolidationOption{PROP:Hide} = True
          ?ConsolidatedDesc:Prompt{PROP:Hide} = False
          ?LOC:ConsolidatedDesc{PROP:Hide}    = False
          ?SelectConsolidatedMatter{PROP:Hide} = False
          ?LOC:ConsolidatedDesc{PROP:Disable}    = False
          ?LOC:ConsolidatedDesc{PROP:Skip}       = False
          ?LOC:ConsolidatedDesc{PROP:ReadOnly}   = False
          ?LOC:ConsolidatedDesc{PROP:Background} = Color:None
          ?SelectConsolidatedMatter{PROP:Disable} = False
        END
    END

  IF ~(SAV:MAT:CollCommOption = MAT:CollCommOption)
        SAV:MAT:CollCommOption = MAT:CollCommOption
        Case MAT:CollCommOption
        Of 'U'

          ! Rick - 21 May 2018
          Change(?MAT:CollCommPercent,CTL:CollCommPercent)
          Change(?MAT:CollCommLimit,CTL:CollCommLimit)


          ?MAT:CollCommPercent{PROP:Disable} = True
          ?MAT:CollCommPercent{PROP:Background} = COLOR:BTNFACE
          ?MAT:CollCommLimit{PROP:Disable} = True
          ?MAT:CollCommLimit{PROP:Background} = COLOR:BTNFACE



        Of 'C' OrOf 'I'
          ?MAT:CollCommPercent{PROP:Disable} = False
          ?MAT:CollCommPercent{PROP:Background} = Color:None
          ?MAT:CollCommLimit{PROP:Disable} = False
          ?MAT:CollCommLimit{PROP:Background} = Color:None
        Else
          ?MAT:CollCommPercent{PROP:Disable} = True
          ?MAT:CollCommPercent{PROP:Background} = COLOR:BTNFACE
          ?MAT:CollCommLimit{PROP:Disable} = True
          ?MAT:CollCommLimit{PROP:Background} = COLOR:BTNFACE
        .
    END

    IF ~(SAV:MAT:DebtorCollCommOption = MAT:DebtorCollCommOption)
        SAV:MAT:DebtorCollCommOption = MAT:DebtorCollCommOption
        Case MAT:DebtorCollCommOption
        Of 'U'

          ! Rick - 21 May 2018
          Change(?MAT:DebtorCollCommPercent,CTL:CollCommPercent)
          Change(?MAT:DebtorCollCommLimit,CTL:CollCommLimit)


          ?MAT:DebtorCollCommPercent{PROP:Disable} = True
          ?MAT:DebtorCollCommPercent{PROP:Background} = COLOR:BTNFACE
          ?MAT:DebtorCollCommLimit{PROP:Disable} = True
          ?MAT:DebtorCollCommLimit{PROP:Background} = COLOR:BTNFACE


        Of 'C' OrOf 'I'
          ?MAT:DebtorCollCommPercent{PROP:Disable} = False
          ?MAT:DebtorCollCommPercent{PROP:Background} = Color:None
          ?MAT:DebtorCollCommLimit{PROP:Disable} = False
          ?MAT:DebtorCollCommLimit{PROP:Background} = Color:None
        Else
          ?MAT:DebtorCollCommPercent{PROP:Disable} = True
          ?MAT:DebtorCollCommPercent{PROP:Background} = COLOR:BTNFACE
          ?MAT:DebtorCollCommLimit{PROP:Disable} = True
          ?MAT:DebtorCollCommLimit{PROP:Background} = COLOR:BTNFACE
        .
    END

  Case MAT:AgentFlag
  Of 0
    ?MAT:AgentPercent{PROP:Hide} = True
  Of 1
    ?MAT:AgentPercent{PROP:Hide} = False
    ?MAT:AgentPercent{PROP:Disable} = True
    ?MAT:AgentPercent{PROP:Background} = COLOR:BTNFACE
  Of 2
    ?MAT:AgentPercent{PROP:Hide} = False
    ?MAT:AgentPercent{PROP:Disable} = False
    ?MAT:AgentPercent{PROP:Background} = Color:None
  .


    If ~(SAV:LOC:AgreedFeeFlag = LOC:AgreedFeeFlag)
        SAV:LOC:AgreedFeeFlag = LOC:AgreedFeeFlag
        If LOC:AgreedFeeFlag
          ?MAT:AgreedFeePercent{PROP:Disable} = False
          ?MAT:AgreedFeeLimit{PROP:Disable} = False
          ?MAT:AgreedFeePercent{PROP:Background} = COLOR:NONE
        Else
          MAT:AgreedFeePercent = 0
          MAT:AgreedFeeLimit = 0
          ?MAT:AgreedFeePercent{PROP:Disable} = True
          ?MAT:AgreedFeeLimit{PROP:Disable} = True
          ?MAT:AgreedFeePercent{PROP:Background} = COLOR:BTNFACE
        .
    END


  IF ~(SAV:ArchiveStatus = MAT:ArchiveStatus)
      SAV:ArchiveStatus = MAT:ArchiveStatus
      DO HideArchiveNumber
  END


  IF MAT:DocgenID AND ~(SAV:MAT:DocgenID = MAT:DocgenID)
    SAV:MAT:DocgenID = MAT:DocgenID

    DO MoveSettingsFields

  END



  IF MAT:DocgenID AND ~(SAV:ToDoNoteDocgenID = MAT:DocgenID)
    DG:RecordID = MAT:DocgenID
    IF ~Access:Docgen.TryFetch(DG:PrimaryKey)
  
        POA:RecordID = DG:ToDoGroupID
        IF ~Access:PlanOfAction.TryFetch(POA:PrimaryKey)
            MAT:ToDoGroupID = POA:RecordID
            LOC:ToDoGroup = POA:Description
            DISPLAY(?LOC:ToDoGroup)
        ELSE
            MAT:ToDoGroupID = 0
            LOC:ToDoGroup = ''
            DISPLAY(?LOC:ToDoGroup)
        END
    END
    SAV:ToDoNoteDocgenID = MAT:DocgenID
  END
  
  
  
  ! THE DEFAULT FEE SHEET IS RETRIEVED FROM THE MATTERTYPE FILE
  IF MAT:MatterTypeID AND ~(SAV:MatterTypeID = MAT:MatterTypeID)


    MT:RecordID = MAT:MatterTypeID
    IF ~Access:MatType.TryFetch(MT:PrimaryKey)

        MAT:ClientFeeSheetID = MT:FeeSheetID
        FS:RecordID = MT:FeeSheetID
        IF ~Access:FeeSheet.TryFetch(FS:PrimaryKey)
            MAT:ClientFeeSheetID = FS:RecordID
            LOC:ClientFeeSheet = FS:Description
            DISPLAY(?LOC:ClientFeeSheet)
        END
    END
    SAV:MatterTypeID = MAT:MatterTypeID
  END


    If ~(SAV:LOC:InvoicePartyFlag = LOC:InvoicePartyFlag)
        SAV:LOC:InvoicePartyFlag = LOC:InvoicePartyFlag
        If LOC:InvoicePartyFlag
          ?LOC:InvoiceParty{PROP:Disable} = False
          ?LOC:InvoiceParty{PROP:Background} = 0BDFFFFH
          ?LOC:InvoiceParty{PROP:Disable} = False
          ?SelectInvoiceParty{PROP:Disable} = False
        Else
          ?LOC:InvoiceParty{PROP:Disable} = True
          ?LOC:InvoiceParty{PROP:Disable} = True
          ?LOC:InvoiceParty{PROP:Background} = COLOR:BTNFACE
          ?SelectInvoiceParty{PROP:Disable} = True
        End
    END



HideArchiveNumber   ROUTINE

      IF MAT:ArchiveStatus = 0 AND MAT:ArchiveFlag = False AND MAT:ArchiveNo = 0
        ?MAT:ArchiveNo:Prompt{PROP:Hide} = True
        ?MAT:ArchiveNo{PROP:Hide} = True
        ?MAT:ArchiveDate:Prompt{PROP:Hide} = True
        ?MAT:ArchiveDate{PROP:Hide} = True
        ?StatusGroup{PROP:Height} = 30
      ELSE
        ?MAT:ArchiveNo:Prompt{PROP:Hide} = False
        ?MAT:ArchiveNo{PROP:Hide} = False
        ?MAT:ArchiveDate:Prompt{PROP:Hide} = False
        ?MAT:ArchiveDate{PROP:Hide} = False
        ?StatusGroup{PROP:Height} = 60
      END


CopyOtherFiles  ROUTINE

  SETCURSOR(CURSOR:Wait)
  OPEN(ProgressWindow)
  ProgressWindow{PROP:Text} = 'Copying Related Files'
  ?ProgressBar{PROP:RangeHigh} = 12
  DISPLAY


  !***************************************************************
  ! MatGroup
  !***************************************************************
  CLEAR(MG:Record)
  MG:MatterID = GLO:CopyingRecordID
  SET(MG:PrimaryKey,MG:PrimaryKey)
  LOOP UNTIL Access:MatGroup.Next()
      IF ~(MG:MatterID = GLO:CopyingRecordID) THEN BREAK.
      SavPosition = POSITION(MG:PrimaryKey)
      MG:MatterID = MAT:RecordID
      Access:MatGroup.Insert()
      REGET(MG:PrimaryKey,SavPosition)
      SET(MG:PrimaryKey,MG:PrimaryKey)
      IF Access:MatGroup.Next() THEN BREAK.
  END
  ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1;DISPLAY

  !***************************************************************
  ! COLDATA
  !***************************************************************
  CLEAR(COL:Record)
  COL:MatterID = GLO:CopyingRecordID
  SET(COL:MatterKey,COL:MatterKey)
  LOOP UNTIL Access:ColData.Next()
      IF ~(COL:MatterID = GLO:CopyingRecordID) THEN BREAK.
      SavPosition = POSITION(COL:MatterKey)
      COL:MatterID = MAT:RecordID
      Access:ColData.Insert()
      REGET(COL:MatterKey,SavPosition)
      SET(COL:MatterKey,COL:MatterKey)
      IF Access:ColData.Next() THEN BREAK.
  END
  ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1;DISPLAY

  !***************************************************************
  ! ColDebit
  !***************************************************************
  CLEAR(CD:Record)
  CD:MatterID = GLO:CopyingRecordID
  SET(CD:MatterKey,CD:MatterKey)
  LOOP UNTIL Access:ColDebit.Next()
      IF ~(CD:MatterID = GLO:CopyingRecordID) THEN BREAK.
      SavPosition = POSITION(CD:MatterKey)
      CD:MatterID = MAT:RecordID
      Access:ColDebit.Insert()
      REGET(CD:MatterKey,SavPosition)
      SET(CD:MatterKey,CD:MatterKey)
      IF Access:ColDebit.Next() THEN BREAK.
  END
  ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1;DISPLAY

  !***************************************************************
  ! BondData
  !***************************************************************
  CLEAR(BON:Record)
  BON:MatterID = GLO:CopyingRecordID
  SET(BON:PrimaryKey,BON:PrimaryKey)
  LOOP UNTIL Access:BondData.Next()
      IF ~(BON:MatterID = GLO:CopyingRecordID) THEN BREAK.
      SavPosition = POSITION(BON:PrimaryKey)
      BON:MatterID = MAT:RecordID
      Access:BondData.Insert()
      REGET(BON:PrimaryKey,SavPosition)
      SET(BON:PrimaryKey,BON:PrimaryKey)
      IF Access:BondData.Next() THEN BREAK.
  END
  ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1;DISPLAY

  !***************************************************************
  ! ConveyData
  !***************************************************************
  CLEAR(CONV:Record)
  CONV:MatterID = GLO:CopyingRecordID
  SET(CONV:PrimaryKey,CONV:PrimaryKey)
  LOOP UNTIL Access:ConveyData.Next()
      IF ~(CONV:MatterID = GLO:CopyingRecordID) THEN BREAK.
      SavPosition = POSITION(CONV:PrimaryKey)
      CONV:MatterID = MAT:RecordID
      Access:ConveyData.Insert()
      REGET(CONV:PrimaryKey,SavPosition)
      SET(CONV:PrimaryKey,CONV:PrimaryKey)
      IF Access:ConveyData.Next() THEN BREAK.
  END
  ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1;DISPLAY


  !***************************************************************
  ! TownshipData
  !***************************************************************
  CLEAR(TOWN:Record)
  TOWN:MatterID = GLO:CopyingRecordID
  SET(TOWN:PrimaryKey,TOWN:PrimaryKey)
  LOOP UNTIL Access:TownshipData.Next()
      IF ~(TOWN:MatterID = GLO:CopyingRecordID) THEN BREAK.
      SavPosition = POSITION(TOWN:PrimaryKey)
      TOWN:MatterID = MAT:RecordID
      Access:TownshipData.Insert()
      REGET(TOWN:PrimaryKey,SavPosition)
      SET(TOWN:PrimaryKey,TOWN:PrimaryKey)
      IF Access:TownshipData.Next() THEN BREAK.
  END
  ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1;DISPLAY


  !***************************************************************
  ! FNB Data
  !***************************************************************
  CLEAR(FNB:Record)
  FNB:MatterID = GLO:CopyingRecordID
  SET(FNB:PrimaryKey,FNB:PrimaryKey)
  LOOP UNTIL Access:BondFNB.Next()
      IF ~(FNB:MatterID = GLO:CopyingRecordID) THEN BREAK.
      SavPosition = POSITION(FNB:PrimaryKey)
      FNB:MatterID = MAT:RecordID
      Access:BondFNB.Insert()
      REGET(FNB:PrimaryKey,SavPosition)
      SET(FNB:PrimaryKey,FNB:PrimaryKey)
      IF Access:BondFNB.Next() THEN BREAK.
  END
  ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1;DISPLAY


  !***************************************************************
  ! ABSA Data
  !***************************************************************
  CLEAR(ABSA:Record)
  ABSA:MatterID = GLO:CopyingRecordID
  SET(ABSA:PrimaryKey,ABSA:PrimaryKey)
  LOOP UNTIL Access:BondABSA.Next()
      IF ~(ABSA:MatterID = GLO:CopyingRecordID) THEN BREAK.
      SavPosition = POSITION(ABSA:PrimaryKey)
      ABSA:MatterID = MAT:RecordID
      Access:BondABSA.Insert()
      REGET(ABSA:PrimaryKey,SavPosition)
      SET(ABSA:PrimaryKey,ABSA:PrimaryKey)
      IF Access:BondABSA.Next() THEN BREAK.
  END
  ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1;DISPLAY


  !***************************************************************
  ! BondGuar
  !***************************************************************
  CLEAR(BG:Record)
  BG:MatterID = GLO:CopyingRecordID
  SET(BG:MatterKey,BG:MatterKey)
  LOOP UNTIL Access:BondGuar.Next()
      IF ~(BG:MatterID = GLO:CopyingRecordID) THEN BREAK.
      SavPosition = POSITION(BG:MatterKey)
      BG:MatterID = MAT:RecordID
      Access:BondGuar.Insert()
      REGET(BG:MatterKey,SavPosition)
      SET(BG:MatterKey,BG:MatterKey)
      IF Access:BondGuar.Next() THEN BREAK.
  END
  ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1;DISPLAY

  !***************************************************************
  ! BondSure
  !***************************************************************
  CLEAR(BS:Record)
  BS:MatterID = GLO:CopyingRecordID
  SET(BS:MatterKey,BS:MatterKey)
  LOOP UNTIL Access:BondSure.Next()
      IF ~(BS:MatterID = GLO:CopyingRecordID) THEN BREAK.
      SavPosition = POSITION(BS:MatterKey)
      BS:MatterID = MAT:RecordID
      Access:BondSure.Insert()
      REGET(BS:MatterKey,SavPosition)
      SET(BS:MatterKey,BS:MatterKey)
      IF Access:BondSure.Next() THEN BREAK.
  END
  ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1;DISPLAY

  !***************************************************************
  ! BondCanc
  !***************************************************************
  CLEAR(BC:Record)
  BC:MatterID = GLO:CopyingRecordID
  SET(BC:MatterKey,BC:MatterKey)
  LOOP UNTIL Access:BondCanc.Next()
      IF ~(BC:MatterID = GLO:CopyingRecordID) THEN BREAK.
      SavPosition = POSITION(BC:MatterKey)
      BC:MatterID = MAT:RecordID
      Access:BondCanc.Insert()
      REGET(BC:MatterKey,SavPosition)
      SET(BC:MatterKey,BC:MatterKey)
      IF Access:BondCanc.Next() THEN BREAK.
  END
  ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1;DISPLAY

  !***************************************************************
  ! BondProp
  !***************************************************************
  CLEAR(BP:Record)
  BP:MatterID = GLO:CopyingRecordID
  SET(BP:MatterKey,BP:MatterKey)
  LOOP UNTIL Access:BondProp.Next()
      IF ~(BP:MatterID = GLO:CopyingRecordID) THEN BREAK.
      LOC:CopyingBondPropID = BP:RecordID
      SavPosition = POSITION(BP:MatterKey)
      BP:MatterID = MAT:RecordID
      IF ~Access:BondProp.Insert()
          CLEAR(BA:Record)
          BA:BondPropID = LOC:CopyingBondPropID
          SET(BA:BondPropKey,BA:BondPropKey)
          LOOP UNTIL Access:BondArea.Next()
                IF ~(BA:BondPropID = LOC:CopyingBondPropID) THEN BREAK.
                BA:BondPropID = BP:RecordID
                BA:RatedFlag = 1
                Access:BondArea.Insert
          END
      END
      REGET(BP:MatterKey,SavPosition)
      SET(BP:MatterKey,BP:MatterKey)
      IF Access:BondProp.Next() THEN BREAK.
  END
  ?ProgressBar{PROP:progress} = ?ProgressBar{PROP:progress} + 1;DISPLAY


  CLOSE(ProgressWindow)
  SETCURSOR


CheckLastAchiveNo      Routine
  If SAV:ArchiveNo = MAT:ArchiveNo Then Exit.
  If CTL:LastArchiveId = 0 Then Exit.
  If MAT:ArchiveNo <= 0 Then Exit.
  RowCounter{PROP:SQL} = 'select recordid, FileRef from matter where archiveno = ' & MAT:ArchiveNo
  Next(RowCounter)
  If ROW:Counter and ROW:Counter <> MAT:RecordId
    Message('This number has already been used by another matter|FileRef: ' & ROW:Description & 'Setting archive number to next available number',ICON:Asterisk)
    MAT:ArchiveNo = GetNextArchiveNo()
  .
SetInvoiceOption        Routine
  If LOC:FeeOption = 2
    MAT:InvoiceFeeOption = 6
  ElsIf LOC:FeeOption = 1 and LOC:FeeSeparatorOption = 0 and LOC:FeeSummarizeFlag = 0
    MAT:InvoiceFeeOption = 1
  ElsIf LOC:FeeOption = 1 and LOC:FeeSeparatorOption = 1 and LOC:FeeSummarizeFlag = 0
    MAT:InvoiceFeeOption = 2
  ElsIf LOC:FeeOption = 1 and LOC:FeeSeparatorOption = 0 and LOC:FeeSummarizeFlag = 1
    MAT:InvoiceFeeOption = 3
  ElsIf LOC:FeeOption = 1 and LOC:FeeSeparatorOption = 1 and LOC:FeeSummarizeFlag = 1
    MAT:InvoiceFeeOption = 4
  ElsIf LOC:FeeOption = 0 and LOC:FeeSummarizeFlag = 1
    MAT:InvoiceFeeOption = 5
  Else
    MAT:InvoiceFeeOption = 0
  .
  If LOC:DisbursementOption = 2 ! Total Business and Creditor Disbursements

    IF LOC:SeparateCreditorDisbursementOption
        MAT:InvoiceDisbursementOption = 11
    ELSE
        MAT:InvoiceDisbursementOption = 6
    END

  ELSIF LOC:DisbursementOption = 3 ! Total Business but itmeise Creditor Disbursements

        MAT:InvoiceDisbursementOption = 12

  ElsIf LOC:DisbursementOption = 1 and LOC:DisbursementSeparatorOption = 0 and LOC:DisbursementSummarizeFlag = 0 and LOC:ItemiseCreditorDisbursementOption = 0
    MAT:InvoiceDisbursementOption = 1
  ElsIf LOC:DisbursementOption = 1 and LOC:DisbursementSeparatorOption = 1 and LOC:DisbursementSummarizeFlag = 0 and LOC:ItemiseCreditorDisbursementOption = 0
    MAT:InvoiceDisbursementOption = 2
  ElsIf LOC:DisbursementOption = 1 and LOC:DisbursementSeparatorOption = 0 and LOC:DisbursementSummarizeFlag = 1 and LOC:ItemiseCreditorDisbursementOption = 0
    MAT:InvoiceDisbursementOption = 3
  ElsIf LOC:DisbursementOption = 1 and LOC:DisbursementSeparatorOption = 1 and LOC:DisbursementSummarizeFlag = 1 and LOC:ItemiseCreditorDisbursementOption = 0
    MAT:InvoiceDisbursementOption = 4
  ElsIf LOC:DisbursementOption = 0 and LOC:DisbursementSummarizeFlag = 1
    MAT:InvoiceDisbursementOption = 5
  ElsIf LOC:DisbursementOption = 1 and LOC:DisbursementSeparatorOption = 0 and LOC:DisbursementSummarizeFlag = 0 and LOC:ItemiseCreditorDisbursementOption = 1
    MAT:InvoiceDisbursementOption = 7
  ElsIf LOC:DisbursementOption = 1 and LOC:DisbursementSeparatorOption = 1 and LOC:DisbursementSummarizeFlag = 0 and LOC:ItemiseCreditorDisbursementOption = 1
    MAT:InvoiceDisbursementOption = 8
  ElsIf LOC:DisbursementOption = 1 and LOC:DisbursementSeparatorOption = 0 and LOC:DisbursementSummarizeFlag = 1 and LOC:ItemiseCreditorDisbursementOption = 1
    MAT:InvoiceDisbursementOption = 9
  ElsIf LOC:DisbursementOption = 1 and LOC:DisbursementSeparatorOption = 1 and LOC:DisbursementSummarizeFlag = 1 and LOC:ItemiseCreditorDisbursementOption = 1
    MAT:InvoiceDisbursementOption = 10
  Else
    MAT:InvoiceDisbursementOption = 0
  .

ThisWindow.Ask PROCEDURE

  CODE
  OMIT('***omit this***')
  CASE SELF.Request
  OF ViewRecord
    ActionMessage = 'View Record'
  OF InsertRecord
    ActionMessage = 'Adding a Matter Record'
  OF ChangeRecord
    ActionMessage = 'Changing a Matter Record'
  END
  QuickWindow{Prop:Text} = ActionMessage
  ***omit this***
    CASE SELF.Request
        OF InsertRecord
          IF GLO:CopyingRecordFlag AND GLO:CopyingRecordID
              QuickWindow{PROP:Text} = 'Copying a Matter (' & CLIP(LEFT(FORMAT(MAT:RecordID,@n_12))) & ')'
          ELSE
              QuickWindow{PROP:Text} = 'Inserting a Matter (' & CLIP(LEFT(FORMAT(MAT:RecordID,@n_12))) & ')'
          END
        OF ChangeRecord
          QuickWindow{PROP:Text} = 'Changing Matter - ' & MAT:FileRef & ' (' & CLIP(LEFT(FORMAT(MAT:RecordID,@n_12))) & ')'
    END
  
  
  If Self.Request = ChangeRecord
  
    ! VIEW ONLY
!    If ~CheckEmployeeAllowed(MAT:EmployeeID) OR |
!      (MAT:Access = 'V' AND ~(GLO:EmployeeID = MAT:EmployeeID) AND ~GLO:SupervisorFlag) OR |
!      (MAT:ArchiveFlag = True and GLO:SecMatterArchivedFlag = False and ~GLO:SupervisorFlag)

    IF CheckMatterAccess(MAT:RecordID)  ! ADDED 8/11/2010

        QuickWindow{PROP:Text} = 'Matter - ' & MAT:FileRef & ' (' & CLIP(LEFT(FORMAT(MAT:RecordID,@n_12))) & ') [View Only]'
        ?OK{PROP:Disable} = True
        ?Insert:2{PROP:Disable} = True
        ?Delete:2{PROP:Disable} = True

    END
  
  
    If ~GLO:SupervisorFlag and ~GLO:SecMatterFileRefFlag
      ?MAT:FileRef{Prop:Disable} = True
      ?MAT:FileRef{Prop:Background} = COLOR:BTNFACE
    .
  
  .

  If Self.Request = ViewRecord Then ?OK{PROP:Disable} = True.

  
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ThisSecProc.Init()
  GlobalErrors.SetProcedureName('UpdateMatter')
  
  SAV:MAT:ArchiveFlag = MAT:ArchiveFlag
  If Self.Request = InsertRecord
    If CTL:LicenceValidUntil >=  90000! 80000 KDS 25 Feb 2019 - changings this to 90000
      Message('You are not licenced to insert Matters|Please contact LegalSuite Support| to licence your software','Read Only Licence',ICON:Asterisk)
      Return Level:Notify
    .
  .
  BRW20.Init(?GroupList,Queue:Browse:1.ViewPosition,BRW20::View:Browse,Queue:Browse:1,Relate:MatGroup,SELF)
  IF GetControlFile().

  If MAT:ArchiveNo < 0 Then MAT:ArchiveNo = 0.
  LOC:NextDistributionNo = MAT:LastDistributionNo + 1


  CLEAR(CONV:Record)
  CONV:MatterID = MAT:RecordID
  IF Access:ConveyData.TryFetch(CONV:PrimaryKey)

      CLEAR(CONV:Record)
      CONV:MatterID = MAT:RecordID
      ! 30/01/2015 Sameer: Prime CONV:SBSA_PRODUCE_NEW_CLF_DOCS field when creating a matter
      CONV:SBSA_PRODUCE_NEW_CLF_DOCS = 'N'
      IF Access:ConveyData.TryInsert()
        MESSAGE('Error encountered adding ConveyData.||Error = ' & ERROR(),'Adding ConveyData',ICON:Exclamation)
      ELSE
        LOC:ConveyDataExistsFlag = 1
      END

  ELSE
      LOC:ConveyDataExistsFlag = 1
  END


  IF MAT:UpdatedById
      IF MAT:UpdatedByDate
        LOC:LastUpdatedBy = GetDescription('EMPLOYEE',MAT:UpdatedById) & ' on ' & FORMAT(MAT:UpdatedByDate,@D17B) & ' at ' & FORMAT(MAT:UpdatedByTime,@T3)
      ELSE
        LOC:LastUpdatedBy = GetDescription('EMPLOYEE',MAT:UpdatedById)
      END
  ELSE
      LOC:LastUpdatedBy = 'Not recorded'
  END


  Do CheckFields


  OPEN(QuickWindow)
  SELF.Opened=True
    If Self.Request = InsertRecord


        EMP:RecordID = GLO:EmployeeID
        Access:Employee.Fetch(EMP:PrimaryKey)
        IF EMP:DefaultClientID
          CLEAR(PAR:Record)
          PAR:RecordID = EMP:DefaultClientID
          IF ~Access:Party.TryFetch(PAR:PrimaryKey)
              MAT:ClientID     = PAR:RecordID
              LOC:ClientName   = PAR:Name
              LOC:MatterPrefix = PAR:MatterPrefix
              MAT:FileRef = AssignFileRef(PAR:MatterPrefix)
          END
        END

        DO SetDefaults         ! ASSIGNING MATTER DEFAULTS HERE


   ELSE

    ! NEED THESE RECORDS BECAUSE THEY COULD BE USED IN THE MATTER EXTRA SCREEN


      IF CONV:BondCauseID
         PROPSQLNext('SELECT 0,Description FROM BondCause WHERE RecordID = ' & CONV:BondCauseID)
         LOC:CauseOfAction = ROW:Description
      END

      COL:MatterID = MAT:RecordID
      Access:ColData.TryFetch(COL:MatterKey)
      
      BON:MatterID = MAT:RecordID
      Access:BondData.TryFetch(BON:PrimaryKey)
      
      TOWN:MatterID = MAT:RecordID
      Access:TownshipData.TryFetch(CONV:PrimaryKey)

   END

    DO SetEmployeeDropDown

    IF ~MAT:DebtorPaymentFrequency
        MAT:DebtorPaymentFrequency = 1
    END
    SAV:MAT:DebtorPaymentFrequency = MAT:DebtorPaymentFrequency
    EXECUTE MAT:DebtorPaymentFrequency
       ?MAT:DebtorPaymentFrequency{PROP:Selected} = 1
       ?MAT:DebtorPaymentFrequency{PROP:Selected} = 3
       ?MAT:DebtorPaymentFrequency{PROP:Selected} = 2
       ?MAT:DebtorPaymentFrequency{PROP:Selected} = 4
       ?MAT:DebtorPaymentFrequency{PROP:Selected} = 5
    END


    DO MoveSettingsFields

    SAV:MAT:DocgenID = MAT:DocgenID


    SAV:ConsolidateId = MAT:ConsolidateId


    IF MAT:LawRef
      LOC:LawRef = MAT:LawRef
      ?LOC:LawRef:Prompt{PROP:Hide} = False
      ?LOC:LawRef{PROP:Hide} = False
    END

    SAV:MAT:FileRef = MAT:FileRef !FB 2134

  ?CollCommOption{PROP:Selected} = Inlist(MAT:CollCommOption,'N','U','C','I')
  ?DebtorCollCommOption{PROP:Selected} = Inlist(MAT:DebtorCollCommOption,'N','U','C','I','S')
  
  
  SAV:ArchiveStatus = MAT:ArchiveStatus
  DO HideArchiveNumber
  
  
  SAV:ClaimAmount = MAT:ClaimAmount
  SAV:ToDoNoteDocgenID = MAT:DocgenID
  SAV:DefaultClientID = MAT:ClientID
  SAV:MatterTypeID = MAT:MatterTypeID
  SAV:ArchiveFlag = MAT:ArchiveFlag
  
  Do SetScreenFields

    IF MAT:BranchID = 0  
       MAT:BranchFlag = 0
    END

    IF MAT:BranchFlag = 0
       MAT:BranchID = 0
    END



    IF MAT:ExtraScreenID = 0
       SETNULL(MAT:ExtraScreenID)
    END


  
  If 1
    MAT1:RecordID = MAT:LinkedMatterID
    If MAT1:RecordID
      Access:MatterAlias.Fetch(MAT1:PrimaryKey)
      Change(?LOC:FileRef,MAT1:FileRef)
    .
  .
    Clear(Row:Record)
    RowCounter{PROP:SQL} = 'Select top 1 Party.RecordId, Party.Name from Party inner join matparty on matparty.partyid = party.recordid where (matparty.matterid = ' & MAT:RecordId & ') and Party.RecordId = ' & MAT:InvoicePartyId
    Next(RowCounter)
    If ~Errorcode()
      Change(?LOC:InvoiceParty,ROW:Description)
    ElsIf Errorcode() <> 33
      Message('Error Initializing Field|Field: ?LOC:InvoiceParty|Error: ' & Clip(Error()) & FileError(),'Error',ICON:Exclamation)
    .
  

    PROPSQLNext('Select Count(1) From SARS_MatterMessage Where MatterID = ' & MAT:RecordID)
    a# = ROW:Counter

    If ~a#
      PROPSQLNext('Select Count(1) From ABSA_MatterMessage Where MatterID = ' & MAT:RecordID)
      a# = ROW:Counter
    End

    If ~a#
      PROPSQLNext('Select Count(1) From AG_MatterMessage Where MatterID = ' & MAT:RecordID)
      a# = ROW:Counter
    End

    If ~a#
      PROPSQLNext('Select Count (1) From Rates_BondpropMessage Where BondPropID = (Select Top 1 RecordID From BondProp Where MatterID = ' & MAT:RecordID & ')')
      a# = ROW:Counter
    End

    

    IF a# Or MAT:FNBMatterState Or MAT:ABSALinkFlag Or MAT:WebLinkBankRef  ! IF A LAW,AG,ABSA,WebLink MATTER

       DISABLE(?MAT:BranchFlag)
       DISABLE(?LOC:Branch)
       SAV:MAT:BranchFlag = MAT:BranchFlag  ! SO IT DOESN'T ENABLE IT AGAIN

    END


    PROPSQLNext('Select 0, fileref from matter where LinkedMatterID = ' & MAT:RecordID)
    If ROW:Description <> '' Then
        UNHIDE(?ParentMatter)
        ?ParentMatter{PROP:Text} = 'Linked to: ' & ROW:Description
        Display(?ParentMatter)
    .

    ThisSecProc.SetFields()
  If MAT:ClientId Then SELF.FirstField = ?MAT:TheirRef.
  
  Post(EVENT:Accepted,?MAT:OverrideIncomeAccFlag)
  
  
  DO TakeFieldEvent
  
  RETURN ReturnValue



ThisWindow.Open PROCEDURE

  CODE
  PARENT.Open
  IF SELF.Request = ChangeRecord
     AddToFavourites(MAT:RecordID)
  END

  IF MAT:DebtorCollCommOption = 'U'
     Change(?MAT:DebtorCollCommPercent,CTL:CollCommPercent)
     Change(?MAT:DebtorCollCommLimit,CTL:CollCommLimit)
  END

  IF MAT:CollCommOption = 'U'
     Change(?MAT:CollCommPercent,CTL:CollCommPercent)
     Change(?MAT:CollCommLimit,CTL:CollCommLimit)
  END


ThisWindow.PrimeFields PROCEDURE

  CODE
    IF ~GLO:CopyingRecordFlag
        MAT:Access = 'O'
        MAT:ArchiveFlag = 0
        MAT:DateInstructed = GLO:TodaysDate
        MAT:EmployeeID = GLO:EmployeeID
        MAT:FeeEstimateWarningFlag = CEM:FeeEstimateWarningFlag
  END
  
  PARENT.PrimeFields


ThisWindow.PrimeUpdate PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    IF GLO:InsertingFromAddressBookFlag = True
      Access:Matter.PrimeRecord(0)
      MAT:ClientID = PAR:RecordID
    END
  ReturnValue = PARENT.PrimeUpdate()
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  IF ~CTL:ClientRoleID OR ~CTL:PlaintiffRoleID
    MESSAGE('The program has not been setup correctly.||Some Party Roles have not been specified.||Go to Setup/Record Identifiers and ensure that all Party Roles are completed.','Incomplete Setup',ICON:Exclamation)
    Return Level:Fatal
  END
  
  IF GlobalRequest = ChangeRecord
      IF RestrictedMatter(MAT:RecordID,0)
        Return RequestCancelled
      END
  END

  ! added manual security Check
  Clear(SP:Record)
  SP:SecGroupId = GLO:SecGroupId
  SP:AccessFlag = GLO:SupervisorFlag
  Case GlobalRequest
  Of InsertRecord
    SP:Description = 'Matters - Update - Insert'
  Of ChangeRecord
    LSF:CheckFieldFlag = True
    SP:Description = 'Matters - Update - Change'
  Of DeleteRecord
    SP:Description = 'Matters - Update - Delete'
  Of ViewRecord
    SP:Description = 'Matters - Update - View'
  Else
    SP:Description = 'Matters - Update'
  .
  IF Access:SecProc.TryFetch(SP:SecGroupKey) Then Access:SecProc.Insert().
  IF SP:DisableOnInsertFlag AND GlobalRequest = InsertRecord
    LSF:CheckFieldFlag = True
  END
  If ~SP:AccessFlag and ~GLO:SupervisorFlag
    IF GlobalRequest <> ChangeRecord
      Message('Access Denied||Your security settings do not allow you access to this area of the program.|',SP:Description,'~lock.ico')
      Return RequestCancelled
    Else
      GlobalRequest = ViewRecord
      If ThisSecProc.CheckAccess() Then Return RequestCancelled.
    .
  .
    Omit('***end***')
    If ThisSecProc.CheckAccess() Then Return RequestCancelled.
  ***end***
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
    OF ?LOC:MatterPrefix
      
        If ~(1) Then Cycle.
        Update(?)
        PAR:MatterPrefix = Contents(?)
        Access:Party.Fetch(PAR:MatterPrefixKey)
        LOC:ClientName = PAR:Name
        MAT:ClientID = PAR:RecordID
        LOC:ClientName = PAR:Name
        If PAR:MatterPrefix <> Contents(?)
          Select(?)
          Cycle
        .
!***********************************************************************************************************************************************************
!        FLUSH(Party)   ! 28/9/2010 IF THIS IS NOT HERE IT GETS THE WRONG PARTY!!!!!
!                         FLUSH HAS BEEN ADDED TO THE Access:Party.Fetch METHOD IN MAIN.DLL
!                         THIS SEEMS TO HAVE RESOLVED THE ISSUE
!***********************************************************************************************************************************************************

      If ~QuickWindow{Prop:AcceptAll} OR ~MAT:FileRef

          If PAR:MatterPrefix
             RowCounter{PROP:SQL} = 'Update Party SET ClientFlag = 1 WHERE RecordID = ' & MAT:ClientID
          END

          If ThisWindow.Request = InsertRecord

            MAT:FileRef = AssignFileRef(PAR:MatterPrefix)

            Do SetDefaults

            Do CheckFields

            Do SetScreenFields

            ThisWindow.Reset(1)

          END
          DISPLAY
      .



    OF ?LOC:Employee
       GET(GEMPQ:EmployeeQueue,CHOICE())
       MAT:EmployeeID = GEMPQ:RecordID
      
      
    OF ?LOC:FileRef
        If ~(1) Then Cycle.
        Update(?)
        MAT1:FileRef = Contents(?)
        Access:MatterAlias.Fetch(MAT1:FileRefKey)
        MAT:LinkedMatterID = MAT1:RecordID
        If MAT1:FileRef <> Contents(?)
          Select(?)
          Cycle
        .
      !validate fileref
          IF (MAT:LinkedMatterId) THEN
                      If ~LOC:FileRef THEN
                          CLEAR(MAT:LinkedMatterId)
                      ELSE
                          !if it's the same matter, stop
                          IF (MAT:LinkedMatterID = MAT:RecordID) THEN
                              Message('The matter cannot be linked to itself','Link Matter',ICON:Exclamation)
                              Select(?)
                              Cycle
                          ELSE
                              !if the linked matter is already linked, stop
                              PROPSQLNext('Select RecordID, fileref from matter where LinkedMatterID = ' & MAT:LinkedMatterId & ' and RecordId <> ' & MAT:RecordID)
                              If ROW:Counter  THEN
                                  Message('The linked matter is already linked to another matter (' & ROW:Description & ')','Link Matter',ICON:Exclamation)
                                  Select(?)
                                  Cycle
                              END
                          END
                      END
            END
    OF ?LOC:TrustBank
        If ~(1) Then Cycle.
        Update(?)
        BLM:Description = Contents(?)
        Access:Business.Fetch(BLM:DescriptionKey)
        MAT:TrustBankId = BLM:RecordId
        If BLM:Description <> Contents(?)
          Select(?)
          Cycle
        .
    OF ?LOC:BusinessBank
        If ~(1) Then Cycle.
        Update(?)
        BLM:Description = Contents(?)
        Access:Business.Fetch(BLM:DescriptionKey)
        MAT:BusinessBankId = BLM:RecordId
        If BLM:Description <> Contents(?)
          Select(?)
          Cycle
        .
    OF ?LOC:IncomeAcc
        If ~(1) Then Cycle.
        Update(?)
        BLM:Description = Contents(?)
        Access:Business.Fetch(BLM:DescriptionKey)
        MAT:IncomeAccId = BLM:RecordId
        If BLM:Description <> Contents(?)
          Select(?)
          Cycle
        .
    OF ?LOC:ConsolidatedDesc
        If ~(1) Then Cycle.
        Update(?)
        MAT1:FileRef = Contents(?)
        Access:MatterAlias.Fetch(MAT1:FileRefKey)
        MAT:ConsolidateId = MAT1:RecordID
        If MAT1:FileRef <> Contents(?)
          Select(?)
          Cycle
        .
      If Inlist(MAT:ConsolidatedFlag,1,2,3)
        If MAT:ConsolidateId = 0
          Select(?)
          Cycle
        .
      Else
        MAT:ConsolidateId = 0
      .
      If MAT:ConsolidateId = MAT:RecordId
        Message('You cannot consolidate this matter to itself!','Consolidate Matter',ICON:Exclamation)
        Select(?)
        Cycle
      .
      If MAT1:ConsolidateId
        Message('You cannot select a matter that is |consolidated to another matter!','Consolidate Matter',ICON:Exclamation)
        Select(?)
        Cycle
      .
      If SAV:ConsolidateId <> MAT:ConsolidateId
        If (MAT:Actual <> 0 or MAT:Reserved <> 0 or MAT:TotalFees <> 0 or MAT:TotalDisbursements <> 0 or MAT:TotalReceipts <> 0 or MAT:TotalPayments <> 0 or MAT:TotalJournal <> 0)
          Message('WARNING: Changing the consolidation settings will affect the Fees Paid Balances','Consolidate Matter',ICON:Asterisk,'&Ok|&Cancel')
        .
        SAV:ConsolidateId = MAT:ConsolidateId
      .
    OF ?LOC:InvoiceParty
      If ~LOC:InvoicePartyFlag Then Cycle.
      Omit('***end***')
        Update(?)
        Clear(Row:Record)
        RowCounter{PROP:SQL} = 'Select top 1 Party.RecordId, Party.Name from Party inner join matparty on matparty.partyid = party.recordid where (matparty.matterid = ' & MAT:RecordId & ') and Party.Name = ''' & Replace(Contents(?),'''','''''') & ''''
        Next(RowCounter)
        If ~Errorcode()
          Change(?LOC:InvoiceParty,ROW:Description)
        ElsIf Errorcode() <> 33
          Message('Error Reading Field Data|Field: ?LOC:InvoiceParty|Error: ' & Clip(Error()) & FileError(),'Error',ICON:Exclamation)
        .
        If ROW:Description <> Contents(?)
          Clear(RowCounter)
          If ?LOC:InvoiceParty{PROP:REQ}
            Select(?)
            Cycle
          .
        .
        MAT:InvoicePartyId = ROW:Counter
      ***end***
      ! Verify AutoComplete
        Update(?)
        Clear(Row:Record)
        RowCounter{PROP:SQL} = 'Select top 1 Party.RecordId, Party.Name from Party inner join matparty on matparty.partyid = party.recordid where (matparty.matterid = ' & MAT:RecordId & ') and Party.Name = ''' & Replace(Contents(?),'''','''''') & ''''
        Next(RowCounter)
        If ~Errorcode()
          Change(?LOC:InvoiceParty,ROW:Description)
        ElsIf Errorcode() <> 33
          Message('Error Reading Field Data|Field: ?LOC:InvoiceParty|Error: ' & Clip(Error()) & FileError(),'Error',ICON:Exclamation)
        .
        If ROW:Description <> Contents(?)
          Clear(RowCounter)
          If ?LOC:InvoiceParty{PROP:REQ}
            Select(?)
            Cycle
          .
        .
        MAT:InvoicePartyId = ROW:Counter
      
    OF ?CreateReminder
                ! 05/07/2017 PK Naidoo - FB Case 857
                SaveGlobalRequest# = GlobalRequest
                GlobalRequest = InsertRecord
                CLEAR(TOD:Record)
            
                TOD:RecordID = 0
                DEBUG('COL:CourtDate = ' & COL:CourtDate)
                IF COL:CourtDate
                    TOD:Date = COL:CourtDate
                END
            
                TOD:Description = 'Court Date'
            
                UpdateToDoNote
            
                GlobalRequest = SaveGlobalRequest#
            
                IF (TOD:RecordID > 0)
            
                    COL:CourtDateReminderID = TOD:RecordID
                    ?CreateReminder{PROP:Hide} = True
                    ?EditReminder{PROP:Hide} = False
            
                END
    OF ?EditReminder
                ! 05/07/2017 PK Naidoo - FB Case 857
                SaveGlobalRequest# = GlobalRequest
                GlobalRequest = ChangeRecord
                CLEAR(TOD:Record)
                TOD:RecordID = COL:CourtDateReminderID !245430 ! Replace with COL:CourtDateReminderID
                Access:ToDoNote.TryFetch(TOD:PrimaryKey)
                UpdateToDoNote
                GlobalRequest = SaveGlobalRequest#    
    OF ?Insert:2
            GlobalRequest = SelectRecord
            !SelectGroup ! 29/01/2019 PK Naidoo - FB Case 2070, use BrowseGroups instead of SelectGroup so we have the Insert, Change & Delete functionality in one place.
            BrowseGroups
            If GlobalResponse = RequestCompleted
               IF FstTag:PtrM(TAG:Group)
                  CLEAR(GRO:Record)
                  GRO:RecordID = FstTag:PtrM(TAG:Group)
                  LOOP
                    IF ~Access:Grouping.TryFetch(GRO:PrimaryKey)
                        GET(MatGroup,0)
                        MG:MatterID = MAT:RecordID
                        MG:GroupID = GRO:RecordID
                        IF ~DUPLICATE(MG:PrimaryKey)
                            Access:MatGroup.Insert
                        END
                        GRO:RecordID = NxtTag:PtrM(TAG:Group)
                        IF ~GRO:RecordID THEN BREAK.
                   END
                  END
                  NewTag:PtrM(TAG:Group)
                  BRW20.ResetFromFile
                  BRW20.PostNewSelection
               ELSE
                  Access:Grouping.TryFetch(GRO:PrimaryKey)
                  GET(MatGroup,0)
                  MG:MatterID = MAT:RecordID
                  MG:GroupID = GRO:RecordID
                  IF ~DUPLICATE(MG:PrimaryKey)
                      IF ~Access:MatGroup.Insert()
                          BRW20.ResetFromFile
                          BRW20.PostNewSelection
                      END
                  END
               END
            END
            
            RETURN LEVEL:Notify
    OF ?OK
      !Checking linked matter
      
      ThisWindow.Update

      If MAT:ConsolidateId
        MAT1:RecordId = MAT:ConsolidateId
        If Access:MatterAlias.Fetch(MAT1:PrimaryKey) = Level:Benign
          If MAT1:ConsolidateId
            Message('You Cannot consolidate a matter that is |consolidated to another matter','Consolidate Matter',ICON:Exclamation)
            Select(?LOC:ConsolidatedDesc)
            Cycle
          .
          If MAT1:ConsolidatedFlag <> 4
            If Message('You have chosen to consolidate this matter to a matter that is not a "Consolidation Account" (FileRef: ' & MAT1:FileRef & ')|Would you like to set this Matter as a "Consolidation Account" now?','Set Consolidation',ICON:Question,'&Ok|&Cancel') = 2
              Select(?LOC:ConsolidatedDesc)
              Cycle
            .
            MAT1:ConsolidatedFlag = 4
            Access:MatterAlias.Update
          .
        .
      .

      IF ~MAT:ClientID
          MESSAGE('You must select a Client for this Matter.||Hint: Click on the Button with the three dots next to the Client Name field to access the Address Book.' &|
                  '||If your Client is not in the Address Book you must add it to the Address Book first and then ''Select'' it.','No Client Selected',ICON:Exclamation)
          CYCLE
      END

      IF ~MAT:FileRef
          POST(EVENT:Accepted,?LOC:MatterPrefix)
      END

      IF ~MAT:FileRef
          MESSAGE('You must give the Matter a File Reference.','No File Reference',ICON:Exclamation)
          CYCLE
      END



      IF SELF.Request = InsertRecord

         IF ~MAT:FileRef
             MAT:FileRef = AssignFileRef(GetDescription('MATTERPREFIX',MAT:ClientID))
         END


         AddMatDefParties(MAT:RecordID,MAT:DocgenID)

         MAT:AddedDefaultPartiesFlag = 1

         DO AddMatterDescription

      END


      IF ~MAT:Description
          MESSAGE('You must give the Matter a description','Description required',ICON:Exclamation)
          SELECT(?MAT:Description)
          CYCLE
      END

      If Inlist(MAT:ConsolidatedFlag,0,4) Then MAT:ConsolidateId = 0.
      
      If ~LOC:AgreedFeeFlag
          MAT:AgreedFeePercent = 0
          MAT:AgreedFeeLimit = 0
      END
      MAT:LastDistributionNo = LOC:NextDistributionNo - 1
      If MAT:LastDistributionNo < 0 Then MAT:LastDistributionNo = 0.
      If ~LOC:InvoicePartyFlag Then MAT:InvoicePartyId = 0.


      IF MAT:ExtraScreenID
         CLEAR(MEF:Record)
         MEF:MatterID = MAT:RecordID
         IF ~Access:MatField.TryFetch(MEF:PrimaryKey)
            DO UpdateMDSRecord
            Access:MatField.TryUpdate
         END

      END


!! **************** CHECK FOR ANY REQUIRED FIELDS ************************

       LOC:NeedEntryFlag = 0

       LOOP FieldLookup# = 1 TO 20

             IF LOC:DS:FieldRequiredFlag[FieldLookup#]

                BIND:FieldRequiredCondition = LOC:DS:FieldRequiredCondition[FieldLookup#]
                IF BIND:FieldRequiredCondition
                   IF EVALUATE(BIND:FieldRequiredCondition) = '0' THEN CYCLE.
                END

                IF ~LOC:MDS:Field[FieldLookup#] OR LOC:MDS:Field[FieldLookup#] = '0'

                    BEEP(BEEP:SystemDefault)
                    BEEP(BEEP:SystemHand)
                    BEEP(BEEP:SystemQuestion)
                    BEEP(BEEP:SystemExclamation)
                    BEEP(BEEP:SystemAsterisk)

                    SELECT(LOC:FieldNumber[FieldLookup#])
                    LOC:NeedEntryFlag = 1
                    BREAK
                END
            END
   
       END
       !IF SELF.Request = InsertRecord  !FB  2094 - only check when inserting, not saving - undoing, because it needs to check both
            SAV:Mat:Record = MAT:Record
            SAV:COL:Record = COL:Record
            IF CheckMatterConditions('M')
             MAT:Record = SAV:Mat:Record
             COL:Record = SAV:COL:Record
             CYCLE
            ELSE
                MAT:Record = SAV:Mat:Record
                COL:Record = SAV:COL:Record
            .!Rick was here
       !END
       IF LOC:NeedEntryFlag = 1 THEN CYCLE.     ! ABORT OK LOOP



       IF MAT:ArchiveFlag <> SAV:MAT:ArchiveFlag AND MAT:ArchiveFlag = true THEN
        
          Access:Matter.Update

          ProcessSystemEvent(EVENT:MatterArchived,MAT:RecordID)

       END


    ELSE
     IF ~0{Prop:AcceptAll}

        IF MAT:ExtraScreenID AND ?CurrentTab{PROP:SELECTED} = 7




           LOOP FieldLookup# = 1 TO 20


                ! PUT THE STAR NEXT THE THE REQUIRED FIELD
                IF LOC:DS:FieldRequiredFlag[FieldLookup#]
                    BIND:FieldRequiredCondition = LOC:DS:FieldRequiredCondition[FieldLookup#]
                    IF BIND:FieldRequiredCondition
                       IF EVALUATE(BIND:FieldRequiredCondition) = '1' THEN UNHIDE(LOC:DS:FieldRequiredStarFieldNumber[FieldLookup#]) ELSE HIDE(LOC:DS:FieldRequiredStarFieldNumber[FieldLookup#]).
                    END
                END


               IF LOC:FieldNumber[FieldLookup#] > 0          ! ADDED THIS BECAUSE IT WAS UNHIDING THE WRONG FIELDS  AUG 2009


                   ! CHECK IF IT NEEDS TO BE DISABLED
                   IF LOC:DS:DisableFlag[FieldLookup#]

                      BIND:DisableCondition = LOC:DS:DisableCondition[FieldLookup#]
                      IF BIND:DisableCondition
                         IF EVALUATE(BIND:DisableCondition) = '1'
                            LOC:FieldNumber[FieldLookup#]{PROP:Disable} = True
                            LOC:PromptNumber[FieldLookup#]{PROP:Disable} = True
                         ELSE
                            LOC:FieldNumber[FieldLookup#]{PROP:Disable} = False
                            LOC:PromptNumber[FieldLookup#]{PROP:Disable} = False
                         END
                      ELSE
                         LOC:FieldNumber[FieldLookup#]{PROP:Disable} = True
                         LOC:PromptNumber[FieldLookup#]{PROP:Disable} = True
                      END

                   ELSE
                      LOC:FieldNumber[FieldLookup#]{PROP:Disable} = False
                      LOC:PromptNumber[FieldLookup#]{PROP:Disable} = False
                   END


                   ! CHECK IF IT NEEDS TO BE HIDDEN
                   IF LOC:DS:HideFlag[FieldLookup#]

                      BIND:HideCondition = LOC:DS:HideCondition[FieldLookup#]

                      IF BIND:HideCondition

                         IF EVALUATE(BIND:HideCondition) = '1'

                            LOC:FieldNumber[FieldLookup#]{PROP:Hide} = True
                            LOC:PromptNumber[FieldLookup#]{PROP:Hide} = True
                         ELSE

                            LOC:FieldNumber[FieldLookup#]{PROP:Hide} = False
                            LOC:PromptNumber[FieldLookup#]{PROP:Hide} = False
                         END
                      ELSE

                         LOC:FieldNumber[FieldLookup#]{PROP:Hide} = True
                         LOC:PromptNumber[FieldLookup#]{PROP:Hide} = True
                      END

                   ELSE

                      LOC:FieldNumber[FieldLookup#]{PROP:Hide} = False
                      LOC:PromptNumber[FieldLookup#]{PROP:Hide} = False
                   END

                END
           END

           DO CalculateAllFields

  
        END

   END

    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?SelectClient
      ThisWindow.Update
       GlobalRequest = SelectRecord
       GLO:ClientFlag = True          ! ONLY DISPLAY PARTIES WHO ARE CLIENTS
       GLO:BrowsePartyMessage = 'Select the Client for this Matter (or Insert a new one)'
      
      
       IF DG:Type = 'TRN' and ThisWindow.Request = InsertRecord           ! IF ADDING A TRANSFERS MATTER, USE QUICKINSERT BECAUSE THE SELLER IS SELDOM IN THE ADDRESS BOOK
          IF ~UpdatePartyMatParty(CTL:ClientRoleID)
              CYCLE
          ELSE
              GlobalResponse = RequestCompleted
          END
       ELSE
          BrowseParty
       END
      
      
      
      
       GLO:ClientFlag = False
       If GlobalResponse = RequestCompleted
           LOC:ClientName = PAR:Name
           MAT:ClientID = PAR:RecordID
           LOC:MatterPrefix = PAR:MatterPrefix
           PAR:RecordID = MAT:ClientID
           IF ~Access:Party.Fetch(PAR:PrimaryKey)
               IF ~PAR:ClientFlag
                   PAR:ClientFlag = True
                   Access:Party.Update()
              END
              If ThisWindow.Request = InsertRecord
                 MAT:FileRef = AssignFileRef(PAR:MatterPrefix)
      
                 IF MAT:ClientID AND ~(SAV:DefaultClientID = MAT:ClientID) 
                    SAV:DefaultClientID = MAT:ClientID             
                    Do SetDefaults
                    Do CheckFields
                    Do SetScreenFields
                    ThisWindow.Reset(1)
      
                 END
      
              END
           ELSE
              MESSAGE(ERROR() & '|Error received fetching Party ' & PAR:Name)
           END
           DISPLAY
       END
    OF ?MAT:AlternateRef
      If MAT:AlternateRef
        CLEAR(ROW:Record)
        RowCounter{PROP:SQL} = 'Select 0,FileRef FROM Matter WHERE AlternateRef = ''' & MAT:AlternateRef & ''' AND RecordID <> ' & MAT:RecordID
        NEXT(RowCounter)
        IF ROW:Description
           MESSAGE('A Matter (' & ROW:Description & ') already has this Alternate Reference.','Duplicate Reference',ICON:Exclamation)
           SELECT(?)
           CYCLE
        END
      .
    OF ?MAT:FileRef
          If MAT:FileRef
            CLEAR(ROW:Record)
            RowCounter{PROP:SQL} = 'Select 0,Description FROM Matter WHERE FileRef = ''' & MAT:FileRef & ''' AND RecordID <> ' & MAT:RecordID
            NEXT(RowCounter)
            IF ROW:Description
               MESSAGE('A Matter with the Description ''' & ROW:Description & ''' already has this File Reference.','Duplicate File Reference',ICON:Exclamation)
               SELECT(?)
               CYCLE
            END
          .
    OF ?MAT:OldCode
          If MAT:OldCode
            CLEAR(ROW:Record)
            RowCounter{PROP:SQL} = 'Select 0,FileRef FROM Matter WHERE OldCode = ''' & MAT:OldCode & ''' AND RecordID <> ' & MAT:RecordID
            NEXT(RowCounter)
            IF ROW:Description
               MESSAGE('A Matter (' & ROW:Description & ') already has this Old Code.','Duplicate Old Code',ICON:Exclamation)
               SELECT(?)
               CYCLE
            END
          .
    OF ?LOC:DocgenModule
      !    If LOC:DocGenType = 'LIT' and ~MAT:DebtorFeeSheetID Then Do GetMagCourtFeeSheet.
    OF ?LOC:ExtraScreen
! jessie

      !DO DisplayExtraScreen
    OF ?LookupMatter
      ThisWindow.Update
       GlobalRequest = SelectRecord                   ! Set Action for Lookup
       SelectMatterAlias                                   ! Call the Lookup Procedure
       If GlobalResponse = RequestCompleted THEN
        If MAT:FileRef   THEN    ! IF Lookup completed
         MAT:LinkedMatterID = MAT1:RecordID
         Change(?LOC:FileRef,MAT1:FileRef)
        END
      END
    OF ?LookupTrustBank
      ThisWindow.Update
       GlobalRequest = SelectRecord                   ! Set Action for Lookup
       GLO:Filter = '14'
       Clear(BLM:Record)
       BLM:RecordId = MAT:TrustBankId
       SelectBusiness
       IF GlobalResponse = RequestCompleted           ! IF Lookup completed
         If BLM:Type = 14
           MAT:TrustBankId=BLM:RecordId
           Change(?LOC:TrustBank,BLM:Description)
         Else
           Message('Invalid Ledger Account','Updating Matter',ICON:Exclamation)
         .
       .
    OF ?LookupBusinessBank
      ThisWindow.Update
       GlobalRequest = SelectRecord                   ! Set Action for Lookup
       GLO:Filter = '13'
       Clear(BLM:Record)
       BLM:RecordId = MAT:BusinessBankId
       SelectBusiness
       IF GlobalResponse = RequestCompleted           ! IF Lookup completed
         If BLM:Type = 13
           MAT:BusinessBankId=BLM:RecordId
           Change(?LOC:BusinessBank,BLM:Description)
         Else
           Message('Invalid Business Ledger Account','Updating Matter',ICON:Exclamation)
         .
       .
    OF ?ReceiptOption
        MAT:ReceiptOption = Choice() -1
        If ~Inlist(MAT:ReceiptOption,2,4) Then Change(?MAT:ReceiptAmount,0).
    OF ?CollCommOption
      MAT:CollCommOption = Choose(Choice(),'N','U','C','I')
      Case MAT:CollCommOption
      Of 'N'
          Change(?MAT:CollCommPercent,0)
          Change(?MAT:CollCommLimit,0)
      Of 'U'
          Change(?MAT:CollCommPercent,CTL:CollCommPercent)
          Change(?MAT:CollCommLimit,CTL:CollCommLimit)
      .
      Display
    OF ?DebtorCollCommOption
      MAT:DebtorCollCommOption = Choose(Choice(),'N','U','C','I','S')
      Case MAT:DebtorCollCommOption
      Of 'N'
          Change(?MAT:DebtorCollCommPercent,0)
          Change(?MAT:DebtorCollCommLimit,0)
      Of 'U'
          Change(?MAT:DebtorCollCommPercent,CTL:CollCommPercent)
          Change(?MAT:DebtorCollCommLimit,CTL:CollCommLimit)
      Of 'S'
          Change(?MAT:DebtorCollCommPercent,GetCollCommPercent(GLO:TodaysDate))
          Change(?MAT:DebtorCollCommLimit,GetCollCommLimit(GLO:TodaysDate))
      .
      Display
    OF ?MAT:AgentFlag
      Case MAT:AgentFlag
      Of 0
          Change(?MAT:AgentPercent,0)
      Of 1
          Change(?MAT:AgentPercent,CTL:AgentPercent)
      .
    OF ?MAT:OverrideIncomeAccFlag
      If MAT:OverrideIncomeAccFlag
        LOC:IncomeAccountDesc = 'Will Always Use The Following Account:'
      Else
        Case CTL:IncomeAccOption
        Of 0
          LOC:IncomeAccountDesc = 'Assigned by the Program''s Setting'
        Of 1
          LOC:IncomeAccountDesc = 'Assigned by the Employee''s Income Account'
        Of 2
          LOC:IncomeAccountDesc = 'Assigned by the Cost Centre''s Income Account'
        Of 3
          LOC:IncomeAccountDesc = 'Assigned by the Matter Type''s Income Account'
        .
        MAT:IncomeAccId = 0
        LOC:IncomeAcc = ''
      .
      Display
    OF ?LookupIncomeAcc
      ThisWindow.Update
       GlobalRequest = SelectRecord                   ! Set Action for Lookup
       GLO:Filter = '01'
       Clear(BLM:Record)
       BLM:RecordId = MAT:IncomeAccId
       SelectBusiness
       IF GlobalResponse = RequestCompleted           ! IF Lookup completed
         If BLM:Type = 1
           MAT:IncomeAccId=BLM:RecordId
           Change(?LOC:IncomeAcc,BLM:Description)
         Else
           Message('Invalid Business Ledger Account!','Update Matter',ICON:Exclamation)
         .
       .
    OF ?SelectConsolidatedMatter
      ThisWindow.Update
      GlobalRequest = SelectRecord
      SelectMatterAlias
      If GlobalResponse = RequestCompleted
        Change(?LOC:ConsolidatedDesc,MAT1:FileRef)
        Post(EVENT:Accepted,?LOC:ConsolidatedDesc)
      .
    OF ?SelectInvoiceParty
      ThisWindow.Update
      GlobalRequest = SelectRecord
      SelectMatPartySelected(MAT:RecordID,,'Select an existing party to invoice or right-click and and click on Insert to select a party from the Address Book.  In order to invoice an alternate party, they must be linked as a Party to the Matter.')
      If GlobalResponse = RequestCompleted
        PAR:RecordId = MP:PartyId
        Access:Party.Fetch(PAR:PrimaryKey)
        LOC:InvoiceParty = PAR:Name
        Display
        Post(EVENT:Accepted,?LOC:InvoiceParty)
      .
      
      
    OF ?LOC:FeeOption
      Display
    OF ?LOC:DisbursementOption
      Display
    OF ?MAT:ClaimAmount
      IF SELF.Request = ChangeRecord
         IF ~(SAV:ClaimAmount = MAT:ClaimAmount)
            IF MESSAGE('Do you want to change the Debtor''s Opening Balance as well?','Claim Amount changed',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:Yes
               MAT:DebtorsOpeningBalance = MAT:ClaimAmount
               IF MAT:InterestOnAmount = SAV:ClaimAmount  ! IF THESE WERE THE SAME THEN CHANGE IT AS WELL
                  MAT:InterestOnAmount = MAT:ClaimAmount  ! OTHERWISE WE PRESUME THE USER CHANGED IT FOR A REASON
                                                          ! AND WANTS IT LEFT LIKE THAT
               END
            END
            SAV:ClaimAmount = MAT:ClaimAmount
         END
      END
    OF ?ArchiveStatus
      If MAT:ArchiveFlag and ~GLO:SupervisorFlag and ~GLO:SecMatterArchivedFlag
        Message('You cannot unarchive this matter|You do not have the correct security rights','Unarchive Matter',ICON:Asterisk)
        ?{PROP:Selected} = MAT:ArchiveStatus + 1
        Select(?)
        Cycle
      .
      
      Do CheckLastAchiveNo
      Case Choice()
      Of 1
        MAT:ArchiveStatus = 0
        MAT:ArchiveFlag   = False
      Of 2
        MAT:ArchiveStatus = 1
        MAT:ArchiveFlag   = False
        If ~MAT:ArchiveNo Then Change(?MAT:ArchiveNo,GetNextArchiveNo()).
      Of 3
        If MAT:Actual or MAT:Reserved or MAT:Invested or MAT:Transfer or MAT:BatchedNormal or MAT:BatchedReserved or MAT:BatchedInvested
          Message('You cannot archive a matter if any of these balances are not zero.|(Actual, Reserved, Invested, Transfer or Batched Balance)||This matter will be set to "Pending"||("Pending" matter are archived at Period-End if all |balances are zero and there is no outstanding invoice).','Update Matter',ICON:Asterisk)
          MAT:ArchiveStatus = 1
          MAT:ArchiveFlag   = False
          ?{PROP:Selected} = MAT:ArchiveStatus + 1
        ElsIf (MAT:ConsolidatedFlag = 1 or MAT:ConsolidatedFlag = 2) and (MAT:Actual <> 0 or MAT:Reserved <> 0 or MAT:TotalFees <> 0 or MAT:TotalDisbursements <> 0 or MAT:TotalReceipts <> 0 or MAT:TotalPayments <> 0 or MAT:TotalJournal <> 0)
          Message('You cannot archive a matter that is marked for consolidation and still has balances||This matter will be set to "Pending"||("Pending" matter are archived at Period-End if all |balances are zero and there is no outstanding invoice).','Update Matter',ICON:Asterisk)
          MAT:ArchiveStatus = 1
          MAT:ArchiveFlag   = False
          ?{PROP:Selected} = MAT:ArchiveStatus + 1
        Elsif MAT:CreateInvoiceFlag and MAT:InvoiceFlag
          Message('You cannot archive a matter if there is an outstanding invoice||Either create an invoice for this matter or |mark this matter as "Do Not Create Invoice"||This matter will be set to "Pending"|("Pending" matter are archived at Period-End if |all balances are zero and there is no outstanding invoice)','Update Matter',ICON:Asterisk)
          MAT:ArchiveStatus = 1
          MAT:ArchiveFlag   = False
          ?{PROP:Selected} = MAT:ArchiveStatus + 1
        Else
          MAT:ArchiveStatus = 2
          MAT:ArchiveFlag   = True
          !FB847 Kelvin 7 6 2017
        .
        If ~MAT:ArchiveNo Then Change(?MAT:ArchiveNo,GetNextArchiveNo()).
      .
      
    OF ?ButtonStorageDetails
      ThisWindow.Update
      GlobalRequest = ViewRecord
      UpdateMatterArchive(1)
      ThisWindow.Reset
    OF ?MAT:ArchiveNo
      If ~Numeric(MAT:ArchiveNo)
        Change(?,0)
        Select(?)
        Cycle
      .
      Do CheckLastAchiveNo
    OF ?MAT:DefaultBillingRateID
      IF MAT:DefaultBillingRateID OR ?MAT:DefaultBillingRateID{Prop:Req}
        BR:RecordID = MAT:DefaultBillingRateID
        IF Access:BillingRate.TryFetch(BR:PrimaryKey)
          IF SELF.Run(1,SelectRecord) = RequestCompleted
            MAT:DefaultBillingRateID = BR:RecordID
            LOC:DefaultBillingRate = BR:Description
          ELSE
            CLEAR(LOC:DefaultBillingRate)
            SELECT(?MAT:DefaultBillingRateID)
            CYCLE
          END
        ELSE
          LOC:DefaultBillingRate = BR:Description
        END
      END
      ThisWindow.Reset()
    OF ?CallLookup
      ThisWindow.Update
      BR:RecordID = MAT:DefaultBillingRateID
      IF SELF.Run(1,SelectRecord) = RequestCompleted
        MAT:DefaultBillingRateID = BR:RecordID
        LOC:DefaultBillingRate = BR:Description
      END
      ThisWindow.Reset(1)
    OF ?LookupLibraryButton
      ThisWindow.Update
      GLO:TooltipCategory = ?MAT:Remarks{PROP:Tooltip}
      IF GLO:TooltipCategory
      
         FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
         IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
      
         SAV:PROP:SelStart# = ?MAT:Remarks{PROP:SelStart}
         GLO:TooltipContents = ?MAT:Remarks{PROP:ScreenText}
         GlobalRequest = SelectRecord
         BrowseLookup
         IF GlobalResponse = RequestCompleted
            LIB:Description = ReplaceTextBoxFields(LIB:Description,0,-1,-1,0)
            IF MAT:Remarks     ! IF THERE ALREADY IS TEXT IN THIS FIELD
               IF SAV:PROP:SelStart#  >= LEN(MAT:Remarks) ! THE CURSOR IS AT THE END
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                     MAT:Remarks = LIB:Description
                     MAT:Remarks =  MAT:Remarks & LIB:Description
                  END
               ELSE
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                     MAT:Remarks = LIB:Description
                     MAT:Remarks =  SUB(Contents(?MAT:Remarks),1,SAV:PROP:SelStart#-1) & LIB:Description & SUB(Contents(?MAT:Remarks),SAV:PROP:SelStart#,1000)
                  END
               END
            ELSE
              MAT:Remarks = LIB:Description
            END
            DISPLAY(?MAT:Remarks)
            SELECT(?MAT:Remarks,SAV:PROP:SelStart# + LEN(LIB:Description))
         END
         CLEAR(GlobalRequest)
      ELSE
         MESSAGE('This Field does not have a Tooltip.||Unable to display the lookup library.','Program Error',ICON:Exclamation)
      END
      
      
      
      
    OF ?AccountingCommentOption
      MAT:CommentOption = Choice() - 1
    OF ?LookupLibraryButton:2
      ThisWindow.Update
      GLO:TooltipCategory = ?MAT:AccountComment{PROP:Tooltip}
      IF GLO:TooltipCategory
      
         FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
         IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
      
         SAV:PROP:SelStart# = ?MAT:AccountComment{PROP:SelStart}
         GLO:TooltipContents = ?MAT:AccountComment{PROP:ScreenText}
         GlobalRequest = SelectRecord
         BrowseLookup
         IF GlobalResponse = RequestCompleted
            LIB:Description = ReplaceTextBoxFields(LIB:Description,0,-1,-1,0)
            IF MAT:AccountComment     ! IF THERE ALREADY IS TEXT IN THIS FIELD
               IF SAV:PROP:SelStart#  >= LEN(MAT:AccountComment) ! THE CURSOR IS AT THE END
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                     MAT:AccountComment = LIB:Description
                     MAT:AccountComment =  MAT:AccountComment & LIB:Description
                  END
               ELSE
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                     MAT:AccountComment = LIB:Description
                     MAT:AccountComment =  SUB(Contents(?MAT:AccountComment),1,SAV:PROP:SelStart#-1) & LIB:Description & SUB(Contents(?MAT:AccountComment),SAV:PROP:SelStart#,1000)
                  END
               END
            ELSE
              MAT:AccountComment = LIB:Description
            END
            DISPLAY(?MAT:AccountComment)
            SELECT(?MAT:AccountComment,SAV:PROP:SelStart# + LEN(LIB:Description))
         END
         CLEAR(GlobalRequest)
      ELSE
         MESSAGE('This Field does not have a Tooltip.||Unable to display the lookup library.','Program Error',ICON:Exclamation)
      END
      
      
      
      
    OF ?InternalCommentOption
        MAT:InternalCommentOption = Choice() - 1
    OF ?LookupLibraryButton:3
      ThisWindow.Update
      GLO:TooltipCategory = ?MAT:InternalComment{PROP:Tooltip}
      IF GLO:TooltipCategory
      
         FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
         IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
      
         SAV:PROP:SelStart# = ?MAT:InternalComment{PROP:SelStart}
         GLO:TooltipContents = ?MAT:InternalComment{PROP:ScreenText}
         GlobalRequest = SelectRecord
         BrowseLookup
         IF GlobalResponse = RequestCompleted
            LIB:Description = ReplaceTextBoxFields(LIB:Description,0,-1,-1,0)
            IF MAT:InternalComment     ! IF THERE ALREADY IS TEXT IN THIS FIELD
               IF SAV:PROP:SelStart#  >= LEN(MAT:InternalComment) ! THE CURSOR IS AT THE END
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                     MAT:InternalComment = LIB:Description
                     MAT:InternalComment =  MAT:InternalComment & LIB:Description
                  END
               ELSE
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                     MAT:InternalComment = LIB:Description
                     MAT:InternalComment =  SUB(Contents(?MAT:InternalComment),1,SAV:PROP:SelStart#-1) & LIB:Description & SUB(Contents(?MAT:InternalComment),SAV:PROP:SelStart#,1000)
                  END
               END
            ELSE
              MAT:InternalComment = LIB:Description
            END
            DISPLAY(?MAT:InternalComment)
            SELECT(?MAT:InternalComment,SAV:PROP:SelStart# + LEN(LIB:Description))
         END
         CLEAR(GlobalRequest)
      ELSE
         MESSAGE('This Field does not have a Tooltip.||Unable to display the lookup library.','Program Error',ICON:Exclamation)
      END
      
      
      
      
    OF ?SetAsDefault
      ThisWindow.Update
      IF MAT:ClientID
         LOC:ExtraLine = 'Note: These defaults will be filled in when taking on Matters for this Client.'
      ELSE
         LOC:ExtraLine = 'Note: You have not selected a Client yet. These defaults will therefore apply to ALL new Matters.'
      END
      IF MESSAGE('Setting this Matter as a default can assist you by pre-filling fields for you everytime you take on a new Matter.||' & LOC:ExtraLine & '||Do you want to use the layout of this Matter as your default?','Setting Matter as Default',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:Yes) = BUTTON:Yes
         Do SaveDefaults
      END
    OF ?VidoeButton
      ThisWindow.Update
      ShowVideo('snapshots_E.exe')
    OF ?OK
      ThisWindow.Update
      IF SELF.Request = ViewRecord
        POST(EVENT:CloseWindow)
      END
    OF ?Cancel
      ThisWindow.Update
      !      MESSAGE('About to delete matparty because Cancel pressed||MAT:RecordID = ' & MAT:RecordID)
      IF SELF.Request = InsertRecord        ! DELETE ANY MATPARTY RECORDS THAT MAY HAVE BEEN CREATED
          CLEAR(MP:Record)
          MP:MatterID = MAT:RecordID
          SET(MP:MatterRoleKey,MP:MatterRoleKey)
      !          MESSAGE('1||MAT:RecordID = ' & MAT:RecordID & '|MP:MatterID = ' & MP:MatterID)
          LOOP UNTIL Access:MatParty.Next()
               IF ~(MP:MatterID = MAT:RecordID) THEN BREAK.
               Delete(MatParty)
      !          MESSAGE('2||MAT:RecordID = ' & MAT:RecordID & '|MP:MatterID = ' & MP:MatterID)
          END
      END
      !      MESSAGE('Finished deleting matparty because Cancel pressed')
      
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeCloseEvent PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    ! ENABLE MAIN TOOLBAR BUTTONS - IN CASE THEY HAD BEEN DISABLED
!    SetTarget(,1)
!    GLO:ToolbarButtons{PROP:Disable} = False
!    SetTarget()
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
      UNBIND('BIND:FieldCalculation')
      UNBIND('BIND:FieldRequiredCondition')
      UNBIND('BIND:DisableCondition')
      UNBIND('BIND:HideCondition')


      If MAT:ArchiveNo > 0
         CLEAR(ROW:Record)
         RowCounter{PROP:SQL} = 'SELECT COUNT(1) FROM Matter WHERE ArchiveNo = ' & MAT:ArchiveNo & ' AND RecordID <> ' & MAT:RecordID
         Next(RowCounter)
         If ROW:Counter
            MAT:ArchiveNo = GetNextArchiveNo()
            If Message('This archive number has been allocated to another matter|This matter''s archive number has been changed to ' & MAT:ArchiveNo,'Duplicate Archive Number',ICON:Exclamation,'&Ok|&Cancel') = 2 Then Return Level:Notify.
         End
      End

      If MAT:ArchiveFlag and ~MAT:ArchiveDate Then MAT:ArchiveDate = GLO:TodaysDate.
      If SAV:ArchiveFlag <> MAT:ArchiveFlag Then MAT:ExportedFlag = False.

      Do SetInvoiceOption


    ! ADD THE EMPLOYEE TO THE MATEMPLOYEE TABLE
      CLEAR(ME:Record)
      ME:MatterID = MAT:RecordID
      ME:EmployeeID = MAT:EmployeeID
      IF Access:MatEmployee.TryFetch(ME:MatterEmployeeKey)
         ME:MatterID = MAT:RecordID
         ME:EmployeeID = MAT:EmployeeID
         Access:MatEmployee.TryInsert

      .

      ! CHECK FOR DUPLICATE FILEREF IN CASE TWO USERS
      ! TAKE ON A MATTER FOR THE SAME CLIENT AT THE SAME TIME
      CLEAR(ROW:Record)
      RowCounter{PROP:SQL} = 'SELECT COUNT(1) FROM Matter WHERE FileRef = ''' & MAT:FileRef & ''' AND RecordID <> ' & MAT:RecordID
      Next(RowCounter)
      IF ROW:Counter
         MAT:FileRef = AssignFileRef(PAR:MatterPrefix)
      END
  
      IF MAT:ExtraScreenID
         IF GLO:CopyingRecordFlag AND GLO:CopyingRecordID
            MEF:MatterID = MAT:RecordID
            Access:MatField.Insert
         END
      END
  
     IF GLO:CopyingRecordFlag AND GLO:CopyingRecordID
        DO CopyOtherFiles
        GLO:CopyingRecordFlag = 0
        GLO:CopyingRecordID = 0
     ELSE
        DO AddClientParty

     END

     ! DOING THIS HERE BECAUSE THERE ARE TOO MANY UPDATES TO THE MATTER BY THE PROGRAM - ONLY WANT USER UPDATES
     IF SELF.Request = ChangeRecord
        IF ~(SAV:MAT:FileRef = MAT:FileRef)
            PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL('File Ref changed "'&SAV:MAT:FileRef&'" from to "'&MAT:FileRef&'"') & ''',0,''Matter'',2,' & CEM:RecordID & ',' & MAT:RecordID & ',''' & MAT:FileRef & ''',''' & GlobalErrors.GetProcedureName() & '''','UpdateMatter')
    
        END
        PROPSQL('INSERT EmployeeLogFile SELECT ' & 
        TODAY() & ',
        ' & CLOCK() & ',
        ''' & StripSQL(MAT:Description) & ''',
        0,
        ''Matter'',
        2,
        ' & CEM:RecordID & ',
        ' & MAT:RecordID & ',
        ''' & MAT:FileRef & ''',
        ''' & GlobalErrors.GetProcedureName() & '''',
        'UpdateMatter')

      1 = ADD 2 = UPDATE 3 = DELETE 4 = ERROR
      "recordid": "93",
      "date": "77506",
      "time": "3173508",
      "description": "Stowell Test",
      "amount": "0.00",
      "tablename": "Matter",
      "action": "1",
      "employeeid": "1001",
      "itemrecordid": "60149",
      "fileref": "TEL2/0055",
      "processname": "UpdateMatter"

     END


     IF SELF.Request = InsertRecord
        MAT:DebtorsBalance = MAT:ClaimAmount
        MAT:InterestOnAmount = MAT:ClaimAmount
        MAT:DebtorsOpeningBalance = MAT:ClaimAmount
     END

     IF SELF.Request = InsertRecord
        EMP:RecordID  = MAT:EmployeeID
        Access:Employee.Fetch(EMP:PrimaryKey)
        IF EMP:TakeOnDebitFlag AND EMP:TakeOnDebitID
           SetTag:PtrM(TAG:FeeCode,EMP:TakeOnDebitID)
           AddFeeNote(GLO:EmployeeId,MAT:CostCentreID)
           NewTag:PtrM(Tag:FeeCode)
        END
     END

     IF SELF.Request = InsertRecord

        DO AddCheckSheetScreens   ! JAN 2010 - ADD THEM NOW BECAUSE SOME EVENTS ETC WRITE TO THEM IMMEDIATELY AND IF THEY DON'T EXIST IT CAUSES PROBLEMA

        DO AddDesktopScreens

     END


     IF ?CollectionsTab{PROP:Hide} <> 1     !THIS IS A COLLECTIONS/LITIGATION MATTER

        IF LOC:ColDataExistsFlag

           IF Access:ColData.TryUpdate()
              MESSAGE('Error encountered updating the ColData record.||Error = ' & ERROR(),'Updating ColData',ICON:Exclamation)
           END

        END

     END

     IF LOC:ConveyDataExistsFlag

        IF Access:ConveyData.TryUpdate()
           MESSAGE('Error encountered updating the ConveyData record.||Error = ' & ERROR(),'Updating ConveyData',ICON:Exclamation)
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
  PDPC:COL:CourtDate.TakeEvent()
  PDPC:COL:PTPStartDate.TakeEvent()
  PDPC:MAT:ArchiveDate.TakeEvent()
  PDPC:MAT:DateInstructed.TakeEvent()
  PDPC:MAT:ImportantDate.TakeEvent()
  PDPC:MAT:InterestFrom.TakeEvent()
  PDPC:MAT:PrescriptionDate.TakeEvent()
  LOOP
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeEvent()
  If Event() = EVENT:Accepted
    ?LOC:SeparateInvoiceStatementFlag{PROP:Disable} = True
    ?LOC:SeparatePagesFlag{PROP:Disable} = True
    ?LOC:ShowVatFlag{PROP:Disable} = True
    If LOC:OverrideInvoiceFormat
      ?LOC:FormatOption{PROP:Disable} = False
      Case LOC:FormatOption
      Of 0
        ?LOC:SeparateInvoiceStatementFlag{PROP:Disable} = False
        If LOC:SeparateInvoiceStatementFlag 
          ?LOC:SeparatePagesFlag{PROP:Disable} = False
          If LOC:SeparatePagesFlag
            MAT:InvoiceFormat = 3
          Else
            MAT:InvoiceFormat = 2
          .
        Else
          MAT:InvoiceFormat = 1
        .
      Of 1
        ?LOC:ShowVatFlag{PROP:Disable} = False
        If LOC:ShowVATFlag
          MAT:InvoiceFormat = 5
         Else
          MAT:InvoiceFormat = 4
        .
      .
    Else
      ?LOC:FormatOption{PROP:Disable} = True
      MAT:InvoiceFormat = 0
    .
  
    If MAT:InvoiceFlag
      ?MAT:InvoiceBFwdOption{PROP:Disable} = False
      ?MAT:InvoiceBFwdOption{PROP:Background} = COLOR:NONE
      ?LOC:FeeOption{PROP:Disable} = False
      ?LOC:FeeOption{PROP:Background} = COLOR:NONE
      ?LOC:FeeSeparatorOption{PROP:Disable} = False
      ?LOC:FeeSeparatorOption{PROP:Background} = COLOR:NONE
      ?LOC:FeeSummarizeFlag{PROP:Disable} = False
      ?LOC:FeeSummarizeFlag{PROP:Background} = COLOR:NONE
      ?LOC:FeeSummarizeFlag:2{PROP:Disable} = False
      ?LOC:FeeSummarizeFlag:2{PROP:Background} = COLOR:NONE
      ?LOC:DisbursementOption{PROP:Disable} = False
      ?LOC:DisbursementOption{PROP:Background} = COLOR:NONE
      ?LOC:DisbursementSeparatorOption{PROP:Disable} = False
      ?LOC:DisbursementSeparatorOption{PROP:Background} = COLOR:NONE
      ?LOC:DisbursementSummarizeFlag{PROP:Disable} = False
      ?LOC:DisbursementSummarizeFlag{PROP:Background} = COLOR:NONE
      ?LOC:DisbursementSummarizeFlag:2{PROP:Disable} = False
      ?LOC:DisbursementSummarizeFlag:2{PROP:Background} = COLOR:NONE
      ?LOC:ItemiseCreditorDisbursementOption{PROP:Disable} = False
      ?LOC:ItemiseCreditorDisbursementOption{PROP:Background} = COLOR:NONE
      ?LOC:SeparateCreditorDisbursementOption{PROP:Disable} = False
      ?LOC:SeparateCreditorDisbursementOption{PROP:Background} = COLOR:NONE
    Else
      ?MAT:InvoiceBFwdOption{PROP:Disable} = True
      ?MAT:InvoiceBFwdOption{PROP:Background} = COLOR:BTNFACE
      ?LOC:FeeOption{PROP:Disable} = True
      ?LOC:FeeOption{PROP:Background} = COLOR:BTNFACE
      ?LOC:FeeSeparatorOption{PROP:Disable} = True
      ?LOC:FeeSeparatorOption{PROP:Background} = COLOR:BTNFACE
      ?LOC:FeeSummarizeFlag{PROP:Disable} = True
      ?LOC:FeeSummarizeFlag{PROP:Background} = COLOR:BTNFACE
      ?LOC:FeeSummarizeFlag:2{PROP:Disable} = True
      ?LOC:FeeSummarizeFlag:2{PROP:Background} = COLOR:BTNFACE
      ?LOC:DisbursementOption{PROP:Disable} = True
      ?LOC:DisbursementOption{PROP:Background} = COLOR:BTNFACE
      ?LOC:DisbursementSeparatorOption{PROP:Disable} = True
      ?LOC:DisbursementSeparatorOption{PROP:Background} = COLOR:BTNFACE
      ?LOC:DisbursementSummarizeFlag{PROP:Disable} = True
      ?LOC:DisbursementSummarizeFlag{PROP:Background} = COLOR:BTNFACE
      ?LOC:DisbursementSummarizeFlag:2{PROP:Disable} = True
      ?LOC:DisbursementSummarizeFlag:2{PROP:Background} = COLOR:BTNFACE
      ?LOC:ItemiseCreditorDisbursementOption{PROP:Disable} = True
      ?LOC:ItemiseCreditorDisbursementOption{PROP:Background} = COLOR:BTNFACE
      ?LOC:SeparateCreditorDisbursementOption{PROP:Disable} = True
      ?LOC:SeparateCreditorDisbursementOption{PROP:Background} = COLOR:BTNFACE
    .
  
  
    If LOC:FeeOption = 1 ! Essay Style
      ?LOC:FeeSeparatorOption{PROP:Hide} = False
      ?LOC:FeeSummarizeFlag{PROP:Hide} = False
      ?LOC:FeeSummarizeFlag:2{PROP:Hide} = True
    ElsIf LOC:FeeOption = 0 ! Itemised
      ?LOC:FeeSeparatorOption{PROP:Hide} = True
      ?LOC:FeeSummarizeFlag{PROP:Hide} = True
      ?LOC:FeeSummarizeFlag:2{PROP:Hide} = False
    Else ! Totals Only
      ?LOC:FeeSeparatorOption{PROP:Hide} = True
      ?LOC:FeeSummarizeFlag{PROP:Hide} = True
      ?LOC:FeeSummarizeFlag:2{PROP:Hide} = True
    .


    If LOC:DisbursementOption = 1 ! Essay Style
      ?LOC:DisbursementSeparatorOption{PROP:Hide} = False
      ?LOC:DisbursementSummarizeFlag{PROP:Hide} = False
      ?LOC:DisbursementSummarizeFlag:2{PROP:Hide} = True
      ?LOC:ItemiseCreditorDisbursementOption{PROP:Hide} = False
      ?LOC:SeparateCreditorDisbursementOption{PROP:Hide} = True
    ElsIf LOC:DisbursementOption = 0 ! Itemised
      ?LOC:DisbursementSeparatorOption{PROP:Hide} = True
      ?LOC:DisbursementSummarizeFlag{PROP:Hide} = True
      ?LOC:DisbursementSummarizeFlag:2{PROP:Hide} = False
      ?LOC:ItemiseCreditorDisbursementOption{PROP:Hide} = True
      ?LOC:SeparateCreditorDisbursementOption{PROP:Hide} = True
    ElsIf LOC:DisbursementOption = 3 ! Creditors Itemised
      ?LOC:DisbursementSeparatorOption{PROP:Hide} = True
      ?LOC:DisbursementSummarizeFlag{PROP:Hide} = True
      ?LOC:DisbursementSummarizeFlag:2{PROP:Hide} = True
      ?LOC:ItemiseCreditorDisbursementOption{PROP:Hide} = True
      ?LOC:SeparateCreditorDisbursementOption{PROP:Hide} = True
    Else ! Totals Only
      ?LOC:DisbursementSeparatorOption{PROP:Hide} = True
      ?LOC:DisbursementSummarizeFlag{PROP:Hide} = True
      ?LOC:DisbursementSummarizeFlag:2{PROP:Hide} = True
      ?LOC:ItemiseCreditorDisbursementOption{PROP:Hide} = True
      ?LOC:SeparateCreditorDisbursementOption{PROP:Hide} = False
    .
  
  .
  
    If Event() = EVENT:Accepted Then ThisSecProc.SetFields().
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
  OF ?LOC:MatterPrefix
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
    END
  OF ?LOC:FileRef
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
    END
  OF ?LOC:TrustBank
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
    END
  OF ?LOC:BusinessBank
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
    END
  OF ?LOC:IncomeAcc
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
    END
  OF ?LOC:ConsolidatedDesc
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
    END
  OF ?LOC:InvoiceParty
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = ShiftDown or Keycode() = ShiftUp Then Post(EVENT:NewSelection,?).
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:Accepted,?SelectInvoiceParty).
    END
  END
  ReturnValue = PARENT.TakeFieldEvent()
  IF FIELD()=?COL:CourtDate
    
  END
  IF FIELD()=?COL:PTPStartDate
    
  END
  IF FIELD()=?MAT:ArchiveDate
    
  END
  IF FIELD()=?MAT:DateInstructed
    
  END
  IF FIELD()=?MAT:ImportantDate
    
  END
  IF FIELD()=?MAT:InterestFrom
    
  END
  IF FIELD()=?MAT:PrescriptionDate
    
  END
     IF QuickWindow{Prop:AcceptAll} THEN RETURN Level:Notify.

     DO TakeFieldEvent


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
    OF ?LOC:MatterPrefix
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        PAR:MatterPrefix = Contents(?)
        Set(PAR:MatterPrefixKey,PAR:MatterPrefixKey)
        If KeyCode() = DownKey Then Next(Party).
        If KeyCode() = UpKey Then Previous(Party).
        Loop
          If KeyCode() = UpKey Then Previous(Party) Else Next(Party).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (Party) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(Upper(Contents(?)) = Upper(Sub(PAR:MatterPrefix,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,PAR:MatterPrefix)
            ?{PROP:SelEnd} = Len(PAR:MatterPrefix)
            ?{PROP:Touched} = True
            MAT:ClientID = PAR:RecordID
            LOC:ClientName = PAR:Name
            Display
      
      
            Break
          .
          SetKeycode(0)
        .
    OF ?LOC:FileRef
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        MAT1:FileRef = Contents(?)
        Set(MAT1:FileRefKey,MAT1:FileRefKey)
        If KeyCode() = DownKey Then Next(MatterAlias).
        If KeyCode() = UpKey Then Previous(MatterAlias).
        Loop
          If KeyCode() = UpKey Then Previous(MatterAlias) Else Next(MatterAlias).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (MatterAlias) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(MAT1:ArchiveFlag = 0 AND MAT1:FileRef <> '') Then Cycle.
          If ~(Upper(Contents(?)) = Upper(Sub(MAT1:FileRef,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,MAT1:FileRef)
            ?{PROP:SelEnd} = Len(MAT1:FileRef)
            ?{PROP:Touched} = True
            Display
      
      
            Post(EVENT:Accepted,?LOC:FileRef)
            Break
          .
          SetKeycode(0)
        .
    OF ?LOC:TrustBank
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        BLM:Description = Contents(?)
        Set(BLM:DescriptionKey,BLM:DescriptionKey)
        If KeyCode() = DownKey Then Next(Business).
        If KeyCode() = UpKey Then Previous(Business).
        Loop
          If KeyCode() = UpKey Then Previous(Business) Else Next(Business).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (Business) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(BLM:Type = 14) Then Cycle.
          If ~(Upper(Contents(?)) = Upper(Sub(BLM:Description,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,BLM:Description)
            ?{PROP:SelEnd} = Len(BLM:Description)
            ?{PROP:Touched} = True
            Display
      
      
            Post(EVENT:Accepted,?LOC:TrustBank)
            Break
          .
          SetKeycode(0)
        .
    OF ?LOC:BusinessBank
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        BLM:Description = Contents(?)
        Set(BLM:DescriptionKey,BLM:DescriptionKey)
        If KeyCode() = DownKey Then Next(Business).
        If KeyCode() = UpKey Then Previous(Business).
        Loop
          If KeyCode() = UpKey Then Previous(Business) Else Next(Business).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (Business) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(BLM:Type = 13) Then Cycle.
          If ~(Upper(Contents(?)) = Upper(Sub(BLM:Description,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,BLM:Description)
            ?{PROP:SelEnd} = Len(BLM:Description)
            ?{PROP:Touched} = True
            Display
      
      
            Post(EVENT:Accepted,?LOC:BusinessBank)
            Break
          .
          SetKeycode(0)
        .
    OF ?LOC:IncomeAcc
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        BLM:Description = Contents(?)
        Set(BLM:DescriptionKey,BLM:DescriptionKey)
        If KeyCode() = DownKey Then Next(Business).
        If KeyCode() = UpKey Then Previous(Business).
        Loop
          If KeyCode() = UpKey Then Previous(Business) Else Next(Business).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (Business) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(BLM:Type = 1) Then Cycle.
          If ~(Upper(Contents(?)) = Upper(Sub(BLM:Description,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,BLM:Description)
            ?{PROP:SelEnd} = Len(BLM:Description)
            ?{PROP:Touched} = True
            Display
      
      
            Post(EVENT:Accepted,?LOC:IncomeAcc)
            Break
          .
          SetKeycode(0)
        .
    OF ?LOC:ConsolidatedDesc
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        MAT1:FileRef = Contents(?)
        Set(MAT1:FileRefKey,MAT1:FileRefKey)
        If KeyCode() = DownKey Then Next(MatterAlias).
        If KeyCode() = UpKey Then Previous(MatterAlias).
        Loop
          If KeyCode() = UpKey Then Previous(MatterAlias) Else Next(MatterAlias).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (MatterAlias) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(Upper(Contents(?)) = Upper(Sub(MAT1:FileRef,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,MAT1:FileRef)
            ?{PROP:SelEnd} = Len(MAT1:FileRef)
            ?{PROP:Touched} = True
            Display
      
      
            Break
          .
          SetKeycode(0)
        .
    OF ?LOC:InvoiceParty
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        Clear(Row:Record)
        Case KeyCode()
        Of UpKey OrOf ShiftUp
          RowCounter{PROP:SQL} = 'Select top 1 Party.RecordId, Party.Name from Party inner join matparty on matparty.partyid = party.recordid where (matparty.matterid = ' & MAT:RecordId & ') and Party.Name < ''' & Replace(Contents(?),'''','''''') & ''' order by Party.Name Desc'
        Of DownKey OrOf ShiftDown
          RowCounter{PROP:SQL} = 'Select top 1 Party.RecordId, Party.Name from Party inner join matparty on matparty.partyid = party.recordid where (matparty.matterid = ' & MAT:RecordId & ') and Party.Name > ''' & Replace(Contents(?),'''','''''') & ''' order by Party.Name'
        Else
          RowCounter{PROP:SQL} = 'Select top 1 Party.RecordId, Party.Name from Party inner join matparty on matparty.partyid = party.recordid where (matparty.matterid = ' & MAT:RecordId & ') and Party.Name like ''' & Replace(Contents(?),'''','''''') & '%'' order by Party.Name'
        .
        Next(RowCounter)
        If Errorcode() = 33 Then Cycle.
        If Errorcode() and Errorcode() <> 33
          Message('Error Reading Field Data|Field: ?LOC:InvoiceParty|Error: ' & Clip(Error()) & FileError(),'Error',ICON:Exclamation)
        .
        Change(?,ROW:Description)
        MAT:InvoicePartyId = ROW:Counter
        ?{PROP:SelEnd} = Len(ROW:Description)
        ?{PROP:Touched} = True
        Display
        SetKeycode(0)
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
    OF ?LOC:DocgenModule
        IF MAT:AG_MatterKref

          IF ~(GLO:AdministratorPassword = GetUserPassword())
            Select(?LOC:DocumentLanguage)
          END

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
        LSFQ:Field = ?MAT:TheirRef
        LSFQ:Description = 'Client Reference'
      End
      Begin
        LSFQ:Field = ?LOC:Employee
        LSFQ:Description = 'Belongs To'
      End
      Begin
        LSFQ:Field = ?MAT:DateInstructed
        LSFQ:Description = 'Instructed Date'
      End
      Begin
        LSFQ:Field = ?ArchiveStatus
        LSFQ:Description = 'Archive Status'
      End
      Begin
        LSFQ:Field = ?MAT:ArchiveDate
        LSFQ:Description = 'Archive Date'
      End
      Begin
        LSFQ:Field = ?MAT:ArchiveNo
        LSFQ:Description = 'Archive No'
      End
      Begin
        LSFQ:Field = ?LOC:ToDoGroup
        LSFQ:Description = 'Plan Of Action'
      End
      Begin
        LSFQ:Field = ?MAT:OldCode
        LSFQ:Description = 'Old Ref'
      End
      Begin
        LSFQ:Field = ?MAT:AlternateRef
        LSFQ:Description = 'Alternate Ref'
      End
      Begin
        LSFQ:Field = ?LOC:MatterType
        LSFQ:Description = 'Matter Type'
      End
      Begin
        LSFQ:Field = ?MAT:InterestRate
        LSFQ:Description = 'Interest Rate'
      End
      Begin
        LSFQ:Field = ?MAT:InterestFrom
        LSFQ:Description = 'Interest From'
      End
      Begin
        LSFQ:Field = ?LOC:ClientFeeSheet
        LSFQ:Description = 'Client Fee Sheet'
      End
      Begin
        LSFQ:Field = ?MAT:Description
        LSFQ:Description = 'Matter Description'
      End
      Begin
        LSFQ:Field = ?MAT:BranchFlag
        LSFQ:Description = 'Branch Flag'
      End
      Begin
        LSFQ:Field = ?LOC:Branch
        LSFQ:Description = 'Branch'
      End
      Begin
        LSFQ:Field = ?LOC:DocgenModule
        LSFQ:Description = 'Document Set'
      End
      Begin
        LSFQ:Field = ?LOC:CauseOfAction
        LSFQ:Description = 'Cause of Action'
      End
      Begin
        LSFQ:Field = ?LOC:DocumentLanguage
        LSFQ:Description = 'Document Language'
      End
      Begin
        LSFQ:Field = ?LOC:ExtraScreen
        LSFQ:Description = 'Extra Screen'
      End
      Begin
        LSFQ:Field = ?LOC:StageGroup
        LSFQ:Description = 'Stages'
      End
      Begin
        LSFQ:Field = ?MAT:Access
        LSFQ:Description = 'Access'
      End
      Begin
        LSFQ:Field = ?MAT:FeeEstimate
        LSFQ:Description = 'Fee Estimate'
      End
      Begin
        LSFQ:Field = ?MAT:FeeEstimateWarningFlag
        LSFQ:Description = 'Fee Estimate Warning'
      End
      Begin
        LSFQ:Field = ?MAT:PrescriptionDate
        LSFQ:Description = 'Prescribes On'
      End
      Begin
        LSFQ:Field = ?MAT:FileCabinet
        LSFQ:Description = 'Filing Cabinet'
      End
      Begin
        LSFQ:Field = ?LookupTrustBank
        LSFQ:Description = 'Trust Bank Lookup Button'
      End
      Begin
        LSFQ:Field = ?LOC:TrustBank
        LSFQ:Description = 'Trust Bank Drop Down'
      End
      Begin
        LSFQ:Field = ?LookupBusinessBank
        LSFQ:Description = 'Business Bank Lookup Button'
      End
      Begin
        LSFQ:Field = ?LOC:BusinessBank
        LSFQ:Description = 'Business Bank Drop Down'
      End
      Begin
        LSFQ:Field = ?LOC:CostCentre
        LSFQ:Description = 'Cost Centre'
      End
      Begin
        LSFQ:Field = ?ButtonStorageDetails
        LSFQ:Description = 'Storage Details'
      End
      Begin
        LSFQ:Field = ?MAT:AgentFlag
        LSFQ:Description = 'Agents Allowance'
      End
      Begin
        LSFQ:Field = ?MAT:AgentPercent
        LSFQ:Description = 'Agents Allowance - Percent'
      End
      Begin
        LSFQ:Field = ?MAT:AdminFeeFlag
        LSFQ:Description = 'Charge Admin Fee'
      End
      Begin
        LSFQ:Field = ?MAT:InterestFlag
        LSFQ:Description = 'Charge Interest'
      End
      Begin
        LSFQ:Field = ?MAT:InvestmentFeeFlag
        LSFQ:Description = 'Investment Fee'
      End
      Begin
        LSFQ:Field = ?LOC:AgreedFeeFlag
        LSFQ:Description = 'Charge an Agreed Fee'
      End
      Begin
        LSFQ:Field = ?MAT:AgreedFeePercent
        LSFQ:Description = 'Charge an Agreed Fee - Percentage'
      End
      Begin
        LSFQ:Field = ?MAT:AgreedFeeLimit
        LSFQ:Description = 'Charge an Agreed Fee - Limit'
      End
      Begin
        LSFQ:Field = ?MAT:VatExemptFlag
        LSFQ:Description = 'Vat Rate'
      End
      Begin
        LSFQ:Field = ?MAT:InvoiceFlag
        LSFQ:Description = 'Create Invoice Flag'
      End
       Break
    .
    If LSF:CheckFieldFlag
      Clear(SF:Record)
      SF:SecGroupId = GLO:SecGroupId
      SF:SecProc    = 'Matters - Update'
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
    SP:Description = 'Matters - Update - Insert'
  Of ChangeRecord
    LSF:CheckFieldFlag = True
    SP:Description = 'Matters - Update - Change'
  Of DeleteRecord
    SP:Description = 'Matters - Update - Delete'
  Of ViewRecord
    SP:Description = 'Matters - Update - View'
  Else
    SP:Description = 'Matters - Update'
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
    BrowseSecProc('Matters - Update',1)
    Return Level:Benign
PDPC:COL:CourtDate.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF COL:CourtDate <> L:Default
    POST(EVENT:Accepted,?COL:CourtDate)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:COL:PTPStartDate.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF COL:PTPStartDate <> L:Default
    POST(EVENT:Accepted,?COL:PTPStartDate)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:MAT:ArchiveDate.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF MAT:ArchiveDate <> L:Default
    POST(EVENT:Accepted,?MAT:ArchiveDate)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:MAT:DateInstructed.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF MAT:DateInstructed <> L:Default
    POST(EVENT:Accepted,?MAT:DateInstructed)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:MAT:ImportantDate.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF MAT:ImportantDate <> L:Default
    POST(EVENT:Accepted,?MAT:ImportantDate)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:MAT:InterestFrom.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF MAT:InterestFrom <> L:Default
    POST(EVENT:Accepted,?MAT:InterestFrom)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:MAT:PrescriptionDate.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF MAT:PrescriptionDate <> L:Default
    POST(EVENT:Accepted,?MAT:PrescriptionDate)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDSC:COL:CourtDate.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV
PDSC:COL:PTPStartDate.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV
PDSC:MAT:ArchiveDate.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV
PDSC:MAT:DateInstructed.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV
PDSC:MAT:ImportantDate.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV
PDSC:MAT:InterestFrom.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV
PDSC:MAT:PrescriptionDate.TakeFieldEvent PROCEDURE
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


FDB6.ValidateRecord PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  IF DS:ScreenType <> 'M' THEN RETURN Record:Filtered.
  ReturnValue = PARENT.ValidateRecord()
  RETURN ReturnValue


FDB2.ValidateRecord PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.ValidateRecord()
  IF DG:RecordID        ! WANT TO DISPLAY (NONE)
     IF ~DG:NoOfUsers OR DG:Type = 'ACC' OR DG:Type = 'DES'  ! DON'T DISPLAY THESE
         IF DG:Type = 'GEN' OR DG:Type = 'CUS' 
         OR (DG:Type = 'BON' AND DG:Code = 'CAN')   ! SHOW GENERAL, CUSTOM & BOND CANCELLATIONS
         ELSE
            ReturnValue = LEVEL:Notify
         END
     END
  END
  
  RETURN ReturnValue


FDB32.TakeAccepted PROCEDURE

  CODE
  PARENT.TakeAccepted
    IF CONV:BondCauseID AND CONV:MatterID THEN Access:ConveyData.TryUpdate.



BRW20.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert:2
    SELF.DeleteControl=?Delete:2
  END

