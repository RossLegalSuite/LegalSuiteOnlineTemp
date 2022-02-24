SetGlobalDefaults    PROCEDURE                        ! Declare Procedure
ezField              LONG
LOC:Path             CSTRING(255)
  CODE
  EMP:RecordID = GLO:EmployeeID
  IF Access:Employee.TryFetch(EMP:PrimaryKey)
     MESSAGE('Error encountered getting default settings for Employee (' & CEM:Name & ')',ERROR(),ICON:Exclamation)
     RETURN
  END


  CEM:Record :=: EMP:Record

  Access:FinYear.Open
  Access:FinYear.UseFile
  GetFinYear(CTL:LastFYrEnd)
  CFY:Record = FY:Record
  Access:FinYear.Close

  ! WORK OUT THE WORKGROUP FOR THIS EMPLOYEE

  GLO:WorkGroupFlag = 0                     
  GLO:WorkGroupList = ''

  Access:EmpWorkGroup.Open
  Access:EmpWorkGroup.UseFile

  CLEAR(EWG:Record)
  EWG:EmployeeID = GLO:EmployeeID
  SET(EWG:PrimaryKey,EWG:PrimaryKey)
  LOOP UNTIL Access:EmpWorkGroup.Next()
       IF ~(EWG:EmployeeID = GLO:EmployeeID) THEN BREAK.
       IF GLO:WorkGroupList
          GLO:WorkGroupList = GLO:WorkGroupList & ',' & EWG:MemberID
       ELSE
          GLO:WorkGroupList = '(' & EWG:MemberID
       END

  END
  Access:EmpWorkGroup.Close

  IF GLO:WorkGroupList
     GLO:WorkGroupList = GLO:WorkGroupList & ')'
     GLO:WorkGroupFlag = 1
  END

  GLO:FileName = ''
  ! DESKTOP FILTERING SETTINGS

  GLO:ConvertToPDFOption = EMP:ConvertToPDFOption
  GLO:SecGroupID = EMP:SecGroupID
  GLO:LOLEnabledFlag = EMP:LOLEnabledFlag

  GLO:SortAddressBookOption = EMP:SortAddressBookOption
  GLO:DebuggingFlag = EMP:DebuggingFlag
  GLO:DebuggingMergeFlag = EMP:DebuggingMergeFlag

  GLO:AssembleLetterFlag            = EMP:AssembleLetterFlag
  GLO:EMailFeeCodeFlag              = EMP:EMailFeeCodeFlag
  GLO:EMailFeeCodeID                = EMP:EMailFeeCodeID

  GLO:SearchWhat  = EMP:SearchWhat
  GLO:SearchBy    = EMP:SearchBy
  GLO:SearchHow   = EMP:SearchHow

  GLO:DesktopBackground = EMP:DesktopBackground
  GLO:Reference  = EMP:Reference
  GLO:EmailEnding  = EMP:EmailEnding
  GLO:MatterHistorySetting  = EMP:MatterHistorySetting

  GLO:AssembleBillHourlyFlag = EMP:AssembleBillHourlyFlag
  GLO:AssembleBillHourlyID = EMP:AssembleBillHourlyID


  GLO:UseRedemptionFlag  = EMP:UseRedemptionFlag
  GLO:SMSFileRefFlag = EMP:SMSFileRefFlag


  GLO:InsertFeeNotesFlag = EMP:InsertFeeNotesFlag
  GLO:InsertFileNotesFlag = EMP:InsertFileNotesFlag
  GLO:InsertToDoNotesFlag = EMP:InsertToDoNotesFlag

  !GLO:DescendingDatesFlag = EMP:DescendingDatesFlag

  GLO:ShowFICACOmplianceFlag = EMP:ShowFICACOmplianceFlag
  GLO:ReportCategory = EMP:ReportCategory

  GLO:FN_Matter     = EMP:FN_Matter
  GLO:FIL_Matter    = EMP:FIL_Matter
  GLO:TOD_Matter    = EMP:TOD_Matter
  GLO:MA_Matter     = EMP:MA_Matter

  GLO:FN_EmployeeID = EMP:FN_EmployeeID
  GLO:FIL_EmployeeID = EMP:FIL_EmployeeID
  GLO:TOD_EmployeeID = EMP:TOD_EmployeeID
  GLO:MA_EmployeeID = EMP:MA_EmployeeID

  GLO:FN_CostCentreID = EMP:FN_CostCentreID
  GLO:MA_CostCentreID = EMP:MA_CostCentreID
  GLO:MA_ActivityID = EMP:MA_ActivityID

  GLO:EmailAttachmentsPath = EMP:EmailAttachmentsPath

  GLO:FN_Period = EMP:FN_Period
  GLO:FIL_Period = EMP:FIL_Period
  GLO:TOD_Period = EMP:TOD_Period
  GLO:MA_Period = EMP:MA_Period

  GLO:FN_FromDate = EMP:FN_FromDate
  GLO:FIL_FromDate = EMP:FIL_FromDate
  GLO:TOD_FromDate = EMP:TOD_FromDate
  GLO:MA_FromDate = EMP:MA_FromDate

  GLO:FN_ToDate = EMP:FN_ToDate
  GLO:FIL_ToDate = EMP:FIL_ToDate
  GLO:TOD_ToDate = EMP:TOD_ToDate
  GLO:MA_ToDate = EMP:MA_ToDate

  GLO:AddressBookView = EMP:AddressBookView
  IF ~GLO:AddressBookView THEN GLO:AddressBookView = 'C'.

  GLO:TOD_Status = EMP:TOD_Status
  GLO:MA_Billable = EMP:MA_Billable
  GLO:PostedOption = EMP:PostedOption

  GLO:FilterDebtLinkCategory      = EMP:FilterDebtLinkCategory
  GLO:FilterDebtLinkFlag          = EMP:FilterDebtLinkFlag


  GLO:FilterConveyancingStatus      = EMP:FilterConveyancingStatus   ! <--Deprecate

  GLO:FilterConveyancingStatusFlag  = EMP:FilterConveyancingStatusFlag
  GLO:RestrictToCriticalStepList = EMP:RestrictToCriticalStepList
  GLO:FilterCriticalStepsNotInList = EMP:FilterCriticalStepsNotInList
  GLO:FilterCriticalStepsNotInListFlag = EMP:FilterCriticalStepsNotInListFlag


  GLO:SMSEnding                   = EMP:SMSEnding
  GLO:SMSFeeCodeFlag              = EMP:SMSFeeCodeFlag
  GLO:SMSFeeCodeID                = EMP:SMSFeeCodeID
  GLO:DefaultPartyExtraScreenID   = EMP:DefaultPartyExtraScreenID
  GLO:ProgressTrackingMethod      = EMP:ProgressTrackingMethod
  GLO:FilterFavouritesFlag        = EMP:FilterFavouritesFlag
  GLO:DoNotSaveDocumentsFlag      = EMP:DoNotSaveDocumentsFlag

  GLO:ShowMatterIDFlag      = EMP:ShowMatterIDFlag
  GLO:EmployeeTypeID        = EMP:EmployeeTypeID
  GLO:TimeRecordingFlag     = EMP:TimeRecordingFlag
  IF GLO:AdministratorFlag
     GLO:UserName              = 'Administrator'
     GLO:LoginId               = 'ADMIN'
  ELSE
     GLO:UserName              = EMP:Name
     GLO:LoginId               = EMP:LoginId
  END
  GLO:Email                  = EMP:Email
  GLO:Fax                    = EMP:Fax
  GLO:Telephone              = EMP:Telephone
  GLO:DefaultLanguageID      = EMP:DefaultLanguageID
  GLO:RestrictToPartyRoleID  = 0
  GLO:RestrictToClientList    = EMP:RestrictToClientList
  GLO:RestrictToClientFlag  = EMP:RestrictToClientFlag
  GLO:FilterMatterTypeFlag  = EMP:FilterMatterTypeFlag
  GLO:FilterMatterTypeID    = 0 ! DEPRECATE THIS
  GLO:FilterCostCentreFlag  = EMP:FilterCostCentreFlag
  GLO:FilterCostCentreID    = 0 ! DEPRECATE THIS
  GLO:FilterBranchFlag  = EMP:FilterBranchFlag
  GLO:FilterBranchID    = 0 !DEPRECATED
  GLO:RestrictToBranchList    = EMP:RestrictToBranchList
  GLO:RestrictToEmployeeList  = EMP:RestrictToEmployeeList
  GLO:RestrictToDocGenList    = EMP:RestrictToDocGenList
  GLO:RestrictToMatterTypeList  = EMP:RestrictToMatterTypeList
  GLO:RestrictToCostCentreList  = EMP:RestrictToCostCentreList
  GLO:FilterDocgenFlag      = EMP:FilterDocgenFlag
  GLO:FilterDocgenID        = 0 ! DEPRECATE THIS
  GLO:FilterStageFlag       = EMP:FilterStageFlag
  GLO:FilterLastStageFlag   = EMP:FilterlastStageFlag
  GLO:FilterStageID         = EMP:FilterStageID
  GLO:FilterSheriffAreaFlag = EMP:FilterSheriffAreaFlag
  GLO:FilterSheriffAreaID   = EMP:FilterSheriffAreaID
  GLO:FilterEmployeeFlag    = EMP:FilterEmployeeFlag
  GLO:FilterEmployeeID      = 0 ! DEPRECATE THIS
  GLO:FilterMattersBy       = EMP:FilterMattersBy
  GLO:FilterDateFlag        = EMP:FilterDateFlag
  GLO:FilterFromDate        = EMP:FilterFromDate
  GLO:FilterToDate          = EMP:FilterToDate
  GLO:FilterArchiveOption   = EMP:FilterArchiveFlag ! No Longer Used
  GLO:FilterStatusLiveFlag    =  EMP:FilterStatusLiveFlag
  GLO:FilterStatusPendingFlag =  EMP:FilterStatusPendingFlag
  GLO:FilterStatusArchiveFlag =  EMP:FilterStatusArchiveFlag
  GLO:FilterBalances        = EMP:FilterBalances
  GLO:FilterAging           = EMP:FilterAging

  GLO:FilterLastInvoiceDate     = EMP:FilterLastInvoiceDate

  GLO:ConsultationFeeCodeID = EMP:ConsultationFeeCodeID
  GLO:TemplateId            = EMP:TemplateId
  GLO:WordprocessorOption     = EMP:WordprocessorOption
  GLO:RemoteUserFlag          = EMP:RemoteUserFlag
  GLO:MergedDocumentLocation  = EMP:MergedDocumentLocation
  GLO:MatterOption            = EMP:MatterOption
  GLO:CreditorOption          = EMP:CreditorOption
  GLO:BusinessOption          = EMP:BusinessOption
  GLO:FilterGroupFlag         = EMP:FilterGroupFlag
  GLO:FilterGroupID           = EMP:FilterGroupID
  GLO:CostCentreID            = EMP:DefaultCostCentreId
  GLO:BackupFlag              = EMP:BackupFlag
  GLO:AutoDescriptionFlag      = EMP:AutoDescriptionFlag
  GLO:AutoDescriptionSeparator = EMP:AutoDescriptionSeparator
  GLO:DefaultBillingRateID     = EMP:DefaultBillingRateID
  GLO:RoundingFlag             = EMP:RoundingFlag
  GLO:RoundingMinutesFlag      = EMP:RoundingMinutesFlag
  GLO:BillPerHourFlag          = EMP:BillPerHourFlag
  GLO:BillPerMinutes           = EMP:BillPerMinutes

  GLO:ReportDestination        = EMP:ReportDestination
  GLO:InterfaceOption          = EMP:InterfaceOption

  GLO:ParticularsPath          = EMP:ParticularsPath
  GLO:ClausePath               = EMP:ClausePath
  GLO:HideInactiveBusinessFlag   = EMP:HideInactiveBusinessFlag
  GLO:HideInactiveMatterFlag     = EMP:HideInactiveMatterFlag
  GLO:HideInactiveCreditorFlag   = EMP:HideInactiveCreditorFlag
  GLO:HideInactiveEmployeeFlag   = EMP:HideInactiveEmployeeFlag
  GLO:HideInactiveCostCentreFlag = EMP:HideInactiveCostCentreFlag
  GLO:VoucherFlag                = EMP:VoucherFlag
  GLO:NoThoughtsFlag             = EMP:NoThoughtsFlag


UpdateParty PROCEDURE                                 !Generated from procedure template - Window

 INCLUDE('UpdateMatterExtraScreenSource','Data')

SAV:PAR:MaritalStatus   LIKE(PAR:MaritalStatus)
LOC:SpouseMatterPrefix  LIKE(PAR:MatterPrefix)
LOC:SpouseInitials      LIKE(PL:Initials)
LOC:SpousePartyName     LIKE(PAR:Name)
LOC:SpousePartyTypeID     LIKE(PAR:PartyTypeID)
LOC:SpousePartyID       LONG
LOC:SpouseSalutation    LIKE(PL:Salutation)
LOC:SpouseTitle         LIKE(PL:Title)
LOC:SpouseLanguageID    LONG
LOC:SpouseParLangID     LONG
LOC:GoAhead             BYTE
LOC:SpouseWork CSTRING(30)
LOC:SpouseHome CSTRING(30)
LOC:SpouseCell CSTRING(30)
LOC:SpouseEmail CSTRING(30)
LOC:SpouseFax CSTRING(30)
LOC:SpouseSQLScript     CSTRING(1000)
LOC:DeceasedSQLScript CSTRING(1000)
LOC:LanguageName CSTRING(200)
LOC:MarDesc CSTRING(2000)
LOC:CheckMarDesc LONG
LOC:PL2:PartyID   LIKE(PL2:PartyID)
LOC:PL2:Salutation      LIKE(PL2:Salutation)
LOC:PL2:ParLangID      LIKE(PL2:LanguageID)
LOC:PL2:LanguageID      LIKE(PL2:LanguageID)
LOC:PL2:Title     LIKE(PL2:Title)
LOC:PL2:Name    LIKE(PL2:Name)
LOC:PL2:FirstName    LIKE(PL2:FirstName)
LOC:PL2:Initials    LIKE(PL2:Initials)
LOC:PL2:IdentityNumber    LIKE(PL2:IdentityNumber)
LOC:PL2:BirthDate    LIKE(PL2:BirthDate)
LOC:PAR2:Name    LIKE(PAR2:Name)
LOC:PAR2:TaxPayer    LIKE(PAR2:TaxPayer)
LOC:PAR2:AnnualIncome    LIKE(PAR2:AnnualIncome)
LOC:PAR2:SAResident    LIKE(PAR2:SAResident)
LOC:PAR2:CountryOfResidence    LIKE(PAR2:CountryOfResidence)
LOC:PAR2:PassportNumber    LIKE(PAR2:PassportNumber)
LOC:PAR2:VatNumber    LIKE(PAR2:VatNumber)
LOC:PAR2:TaxNumber    LIKE(PAR2:TaxNumber)
LOC:PAR2:PhysicalCountryID  LIKE(PAR2:PhysicalCountryID)
LOC:PAR2:PartyTypeID    LIKE(PAR2:PartyTypeID)
LOC:PAR2:MatterPrefix   LIKE(PAR2:MatterPrefix)
LOC:EmployerSQLScript   LIKE(LOC:DeceasedSQLScript)
EmployerPartyID         LIKE(PAR:RecordID)
EmployerParLangID       LIKE(PL:RecordID)
EmployerLanguageID      LIKE(PL:LanguageID)
EmployerMatterPrefix    LIKE(PAR:MatterPrefix)
EmployerSalutation      LIKE(PL:Salutation)
AuditorPartyID         LIKE(PAR:RecordID)
AuditorParLangID       LIKE(PL:RecordID)
AuditorLanguageID      LIKE(PL:LanguageID)
AuditorMatterPrefix    LIKE(PAR:MatterPrefix)
AuditorSalutation      LIKE(PL:Salutation)
LOC:AuditorSQLScript   LIKE(LOC:DeceasedSQLScript)
LOC:ChangeSalutation   BYTE


SpouseContactDetailsScreen WINDOW('Contact Details'),AT(,,185,134),FONT('MS Sans Serif',8,,FONT:regular), |
         CENTER,IMM,SYSTEM,GRAY
       STRING('Enter the spouse''s contact details (optional)'),AT(8,8),USE(?String1),FONT(,,COLOR:Black,FONT:bold,CHARSET:ANSI)
       PROMPT('Phone (Work):'),AT(9,28),USE(?LOC:SpouseWork:Prompt)
       ENTRY(@s30),AT(71,28,79,10),USE(LOC:SpouseWork),TIP('The spouse''s phone number at work')
       PROMPT('Phone (Home):'),AT(9,44),USE(?LOC:SpouseHome:Prompt)
       ENTRY(@s30),AT(71,44,79,10),USE(LOC:SpouseHome),TIP('The spouse''s phone number at Home')
       PROMPT('Cell Phone'),AT(9,60),USE(?LOC:SpouseCell:Prompt)
       ENTRY(@s30),AT(71,60,79,10),USE(LOC:SpouseCell),TIP('The spouse''s cell phone number')
       PROMPT('Email Address'),AT(9,76),USE(?LOC:SpouseEmail:Prompt)
       ENTRY(@s30),AT(71,76,105,10),USE(LOC:SpouseEmail),TIP('The spouse''s email address')
       PROMPT('Fax Number:'),AT(9,92),USE(?LOC:SpouseFax:Prompt)
       ENTRY(@s30),AT(71,92,79,10),USE(LOC:SpouseFax),TIP('The spouse''s fax Number')
       BUTTON('&Ok'),AT(84,114,42,12),USE(?SpouseOKButton),LEFT,ICON('smalltick.ico')
       BUTTON('&Cancel'),AT(132,114,45,12),USE(?SpouseCancelButton),LEFT,ICON('smallcross.ico')
     END


LOC:JumpToQueueRecord        LONG
SAV:PAR:SAResident           LIKE(PAR:SAResident)
SAV:PAR:TaxPayer             LIKE(PAR:TaxPayer)
SAV:LOC:PAR2:SAResident           LIKE(LOC:PAR2:SAResident)
SAV:LOC:PAR2:TaxPayer             LIKE(LOC:PAR2:TaxPayer)

SAV:PAR:SpouseSAResident           LIKE(PAR:SpouseSAResident)
SAV:PAR:SpouseTaxPayer             LIKE(PAR:SpouseTaxPayer)


LOC:PL:Name                  LIKE(PL:Name)
LOC:ResortTheParTeleSorter   BYTE
SAV:TelephoneTypeID          LONG
LOC:Sorter                   LONG
SAV:PartyName                LIKE(PL:Name)
SAV:LanguageID               LONG

SAV:ParLangRecord           LIKE(PL:Record)
SAV:PL:Name                 LIKE(PL:Name)
SAV:PL:AlternativeName      LIKE(PL:AlternativeName)
SAV:PL:FirstName            LIKE(PL:FirstName)
SAV:PL:Title                LIKE(PL:Title)
SAV:PL:Initials             LIKE(PL:Initials)
SAV:PL:IdentityNumber       LIKE(PL:IdentityNumber)
SAV:PL:BirthDate            LIKE(PL:BirthDate)
SAV:PL:Salutation           LIKE(PL:Salutation)
SAV:PL:PhysicalLine1        LIKE(PL:PhysicalLine1)
SAV:PL:PhysicalLine2        LIKE(PL:PhysicalLine2)
SAV:PL:PhysicalLine3        LIKE(PL:PhysicalLine3)
SAV:PL:PhysicalCode         LIKE(PL:PhysicalCode)
SAV:PL:PostalLine1          LIKE(PL:PostalLine1)
SAV:PL:PostalLine2          LIKE(PL:PostalLine2)
SAV:PL:PostalLine3          LIKE(PL:PostalLine3)
SAV:PL:PostalCode           LIKE(PL:PostalCode)
SAV:PL:SpouseName           LIKE(PL:SpouseName)
SAV:PL:SpouseFirstName      LIKE(PL:SpouseFirstName)
SAV:PL:SpouseInitials       LIKE(PL:SpouseInitials)
SAV:PL:SpouseIdentityNumber LIKE(PL:SpouseIdentityNumber)
SAV:PL:SpouseBirthDate      LIKE(PL:SpouseBirthDate)
SAV:PL:DomiciledIn          LIKE(PL:DomiciledIn)
SAV:PL:MaritalDescription   LIKE(PL:MaritalDescription)
SAV:PL:DeedsRegistry        LIKE(PL:DeedsRegistry)
SAV:PL:MarriageDate         LIKE(PL:MarriageDate)
SAV:PL:MarriagePlace        LIKE(PL:MarriagePlace)
SAV:PL:MarriageCountry      LIKE(PL:MarriageCountry)
SAV:PL:ANCNumber            LIKE(PL:ANCNumber)
SAV:PL:SpousePrincipalFlag  LIKE(PL:SpousePrincipalFlag)
SAV:PL:RegistrationNumber   LIKE(PL:RegistrationNumber)
SAV:PL:AuthorityPhrase      LIKE(PL:AuthorityPhrase)
SAV:PL:TrustDate            LIKE(PL:TrustDate)
SAV:PL:TrustDivision        LIKE(PL:TrustDivision)
SAV:PL:DefCitation          LIKE(PL:DefCitation)
SAV:PL:PlaCitation          LIKE(PL:PlaCitation)
SAV:Category                LIKE(ENT1:Category)
SAV:EntityID                LONG
SAV:ParRegionID             LONG
SAV:JuristicFlag            BYTE
SAV:BirthMonth              LIKE(PAR:BirthMonth)
SAVE:MaritalStatus    LIKE(PAR:MaritalStatus)
!Kelvin - 11 - 10 -2016 - adding to i can check other languages at final save and update
SAVED:MaritalStatus    LIKE(PAR:MaritalStatus)

LOC:String1                 CSTRING(6)
LOC:String2                 CSTRING(6)

SAV:PAR:RecordID            LONG
SAV:PAR:DefaultLanguageID   LONG

Matter:Queue   QUEUE,PRE(MATQ)
Description       CSTRING(50)
RecordID          LONG
               END

CurrentTab           STRING(80)
LOC:LockParty        BYTE
LOC:LastUpdatedBy    CSTRING(50)
LOC:FirstCRMField    STRING(1)
LOC:LastCRMField     STRING(1)
LOC:MatterPrefix     CSTRING(20)
LOC:PrefixCounter    SHORT
SAV:PartyTypeID      LONG
FilesOpened          BYTE
ezField              LONG
ActionMessage        CSTRING(40)
LOC:Language         CSTRING(20)
LOC:TeleType         CSTRING(20)
LOC:Status           STRING(1)
LOC:PhysicalAddress  CSTRING(150)
NEW:DefaultLanguageID LONG
SAV:DefaultLanguageID LONG
LOC:PartyType        CSTRING(100)
LOC:PartyStatus      STRING(1)
LOC:Name             CSTRING(50)
LOC:MaritalStatus    CSTRING(50)
LOC:NumberOfColumns  SHORT
LOC:ColumnCounter    BYTE
LOC:ColumnFormat     CSTRING(50)
LOC:FieldFormat      CSTRING(10),DIM(26)
LOC:ColumnHeader     CSTRING(50),DIM(26)
LOC:XLColumnLetter   STRING(1)
XLColumnQueue        QUEUE,PRE(XCQ)
Number               SHORT
Name                 CSTRING(50)
                     END
LOC:XL:QueueCounter  LONG
LOC:XLShadeRow       SHORT
LOC:PostalCountry    CSTRING(50)
LOC:PhysicalCountry  CSTRING(50)
LOC:ExtraScreen      CSTRING(50)
LOC:Matter           CSTRING(100)
LOC:DefaultContact   CSTRING(5)
LOC:AccountCode      CSTRING(30)
LOC:Role             CSTRING(50)
LOC:Entity           CSTRING(100)
LOC:Region           CSTRING(50)
LOC:Category         CSTRING(50)
LOC:Province         CSTRING(30)
LOC:LastStage        CSTRING(50)
LOC:TotalIncome      DECIMAL(11,2)
LOC:BirthMonth       CSTRING(20)
LOC:LookupPropText   STRING(2)
LOC:AutoNotifySMSFlag BYTE
LOC:AutoNotifyEmailFlag BYTE
LOC:AutoNotifyPhoneFlag BYTE
LOC:ParSign          CSTRING(50)
LOC:FicaTick         BYTE
LOC:FicaExpiresDate  CSTRING(20)
LOC:CreatedBy        CSTRING(100)
Sheet1               STRING(20)
SAV:RelID            LONG
FDB36::View:FileDrop VIEW(EntityAlias)
                       PROJECT(ENT1:Description)
                       PROJECT(ENT1:Category)
                       PROJECT(ENT1:JuristicFlag)
                       PROJECT(ENT1:RecordID)
                     END
Queue:FileDrop:7     QUEUE                            !Queue declaration for browse/combo box using ?LOC:Entity
ENT1:Description       LIKE(ENT1:Description)         !List box control field - type derived from field
ENT1:Category          LIKE(ENT1:Category)            !Browse hot field - type derived from field
ENT1:JuristicFlag      LIKE(ENT1:JuristicFlag)        !Browse hot field - type derived from field
ENT1:RecordID          LIKE(ENT1:RecordID)            !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
FDB9::View:FileDrop  VIEW(ParTypeAlias)
                       PROJECT(PT1:Description)
                       PROJECT(PT1:Category)
                       PROJECT(PT1:RecordID)
                     END
Queue:FileDrop       QUEUE                            !Queue declaration for browse/combo box using ?LOC:PartyType
PT1:Description        LIKE(PT1:Description)          !List box control field - type derived from field
PT1:Category           LIKE(PT1:Category)             !Browse hot field - type derived from field
PT1:RecordID           LIKE(PT1:RecordID)             !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
FDB11::View:FileDrop VIEW(Language)
                       PROJECT(LAN:Description)
                       PROJECT(LAN:RecordID)
                     END
Queue:FileDrop:1     QUEUE                            !Queue declaration for browse/combo box using ?LOC:Language
LAN:Description        LIKE(LAN:Description)          !List box control field - type derived from field
LAN:RecordID           LIKE(LAN:RecordID)             !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
FDB37::View:FileDrop VIEW(ParRegion)
                       PROJECT(PREG:Description)
                       PROJECT(PREG:PostalCode)
                       PROJECT(PREG:RecordID)
                       PROJECT(PREG:ProvinceID)
                       JOIN(PROV:PrimaryKey,PREG:ProvinceID)
                         PROJECT(PROV:Description)
                         PROJECT(PROV:RecordID)
                       END
                     END
Queue:FileDrop:8     QUEUE                            !Queue declaration for browse/combo box using ?LOC:Region
PREG:Description       LIKE(PREG:Description)         !List box control field - type derived from field
PREG:PostalCode        LIKE(PREG:PostalCode)          !Browse hot field - type derived from field
PROV:Description       LIKE(PROV:Description)         !Browse hot field - type derived from field
PREG:RecordID          LIKE(PREG:RecordID)            !Primary key field - type derived from field
PROV:RecordID          LIKE(PROV:RecordID)            !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
FDB35::View:FileDrop VIEW(RoleAlias2)
                       PROJECT(ROL2:Description)
                       PROJECT(ROL2:RecordID)
                     END
Queue:FileDrop:6     QUEUE                            !Queue declaration for browse/combo box using ?LOC:Role
ROL2:Description       LIKE(ROL2:Description)         !List box control field - type derived from field
ROL2:RecordID          LIKE(ROL2:RecordID)            !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
FDB39::View:FileDrop VIEW(ParCategory)
                       PROJECT(PCAT:Description)
                       PROJECT(PCAT:RecordID)
                     END
Queue:FileDrop:9     QUEUE                            !Queue declaration for browse/combo box using ?LOC:Category
PCAT:Description       LIKE(PCAT:Description)         !List box control field - type derived from field
PCAT:RecordID          LIKE(PCAT:RecordID)            !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
FDB24::View:FileDrop VIEW(CountryAlias)
                       PROJECT(COU1:Description)
                       PROJECT(COU1:RecordID)
                     END
Queue:FileDrop:3     QUEUE                            !Queue declaration for browse/combo box using ?LOC:PostalCountry
COU1:Description       LIKE(COU1:Description)         !List box control field - type derived from field
COU1:RecordID          LIKE(COU1:RecordID)            !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
FDB25::View:FileDrop VIEW(Country)
                       PROJECT(COU:Description)
                       PROJECT(COU:RecordID)
                     END
Queue:FileDrop:4     QUEUE                            !Queue declaration for browse/combo box using ?LOC:PhysicalCountry
COU:Description        LIKE(COU:Description)          !List box control field - type derived from field
COU:RecordID           LIKE(COU:RecordID)             !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW10::View:Browse   VIEW(ParTele)
                       PROJECT(PTE:Number)
                       PROJECT(PTE:PartyID)
                       PROJECT(PTE:RecordID)
                       PROJECT(PTE:TelephoneTypeID)
                       PROJECT(PTE:Sorter)
                       JOIN(TT:PrimaryKey,PTE:TelephoneTypeID)
                         PROJECT(TT:Description)
                         PROJECT(TT:RecordID)
                       END
                     END
Queue:Browse         QUEUE                            !Queue declaration for browse/combo box using ?TelephoneList
TT:Description         LIKE(TT:Description)           !List box control field - type derived from field
PTE:Number             LIKE(PTE:Number)               !List box control field - type derived from field
PTE:PartyID            LIKE(PTE:PartyID)              !Browse hot field - type derived from field
PTE:RecordID           LIKE(PTE:RecordID)             !Primary key field - type derived from field
PTE:TelephoneTypeID    LIKE(PTE:TelephoneTypeID)      !Browse key field - type derived from field
PTE:Sorter             LIKE(PTE:Sorter)               !Browse key field - type derived from field
TT:RecordID            LIKE(TT:RecordID)              !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW14::View:Browse   VIEW(ParSign)
                       PROJECT(PS:PartyID)
                       PROJECT(PS:FirstName)
                       PROJECT(PS:LastName)
                       PROJECT(PS:Position)
                       PROJECT(PS:Sorter)
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?SignatoriesList
LOC:ParSign            LIKE(LOC:ParSign)              !List box control field - type derived from local data
PS:PartyID             LIKE(PS:PartyID)               !Browse hot field - type derived from field
PS:FirstName           LIKE(PS:FirstName)             !Browse hot field - type derived from field
PS:LastName            LIKE(PS:LastName)              !Browse hot field - type derived from field
PS:Position            LIKE(PS:Position)              !Browse hot field - type derived from field
PS:Sorter              LIKE(PS:Sorter)                !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW31::View:Browse   VIEW(ParRel)
                       PROJECT(PREL:DefaultContactFlag)
                       PROJECT(PREL:RecordID)
                       PROJECT(PREL:PartyID)
                       PROJECT(PREL:OtherPartyID)
                       PROJECT(PREL:RelationshipID)
                       JOIN(DocFoxRelationship,'PREL:PARTYID = DFR:ParentPartyID AND PREL:OtherPartyID = DFR:RelatedPartyID')
                         PROJECT(DFR:DocFoxID)
                       END
                       JOIN(RELAT:PrimaryKey,PREL:RelationshipID)
                         PROJECT(RELAT:Description)
                         PROJECT(RELAT:RecordID)
                       END
                       JOIN(PAR1:PrimaryKey,PREL:OtherPartyID)
                         PROJECT(PAR1:Name)
                         PROJECT(PAR1:RecordID)
                       END
                     END
Queue:Browse:2       QUEUE                            !Queue declaration for browse/combo box using ?List
RELAT:Description      LIKE(RELAT:Description)        !List box control field - type derived from field
PAR1:Name              LIKE(PAR1:Name)                !List box control field - type derived from field
LOC:DefaultContact     LIKE(LOC:DefaultContact)       !List box control field - type derived from local data
PREL:DefaultContactFlag LIKE(PREL:DefaultContactFlag) !Browse hot field - type derived from field
PREL:RecordID          LIKE(PREL:RecordID)            !Browse hot field - type derived from field
DFR:DocFoxID           LIKE(DFR:DocFoxID)             !Browse hot field - type derived from field
PREL:PartyID           LIKE(PREL:PartyID)             !Primary key field - type derived from field
PREL:OtherPartyID      LIKE(PREL:OtherPartyID)        !Primary key field - type derived from field
PREL:RelationshipID    LIKE(PREL:RelationshipID)      !Primary key field - type derived from field
RELAT:RecordID         LIKE(RELAT:RecordID)           !Related join file key field - type derived from field
PAR1:RecordID          LIKE(PAR1:RecordID)            !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW33::View:Browse   VIEW(AccBank)
                       PROJECT(ACB:Description)
                       PROJECT(ACB:AccountName)
                       PROJECT(ACB:AccountNo)
                       PROJECT(ACB:Institution)
                       PROJECT(ACB:Branch)
                       PROJECT(ACB:BranchCode)
                       PROJECT(ACB:RecordId)
                       PROJECT(ACB:AccountId)
                       PROJECT(ACB:AccountCode)
                       PROJECT(ACB:AccountType)
                     END
Queue:Browse:3       QUEUE                            !Queue declaration for browse/combo box using ?List:2
ACB:Description        LIKE(ACB:Description)          !List box control field - type derived from field
ACB:Description_Icon   LONG                           !Entry's icon ID
ACB:AccountName        LIKE(ACB:AccountName)          !List box control field - type derived from field
ACB:AccountNo          LIKE(ACB:AccountNo)            !List box control field - type derived from field
LOC:AccountCode        LIKE(LOC:AccountCode)          !List box control field - type derived from local data
ACB:Institution        LIKE(ACB:Institution)          !List box control field - type derived from field
ACB:Branch             LIKE(ACB:Branch)               !List box control field - type derived from field
ACB:BranchCode         LIKE(ACB:BranchCode)           !List box control field - type derived from field
ACB:RecordId           LIKE(ACB:RecordId)             !Browse hot field - type derived from field
ACB:AccountId          LIKE(ACB:AccountId)            !Browse hot field - type derived from field
ACB:AccountCode        LIKE(ACB:AccountCode)          !Browse hot field - type derived from field
ACB:AccountType        LIKE(ACB:AccountType)          !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW42::View:Browse   VIEW(ParGroup)
                       PROJECT(PG:PartyID)
                       PROJECT(PG:GroupID)
                       JOIN(PGRO:PrimaryKey,PG:GroupID)
                         PROJECT(PGRO:Description)
                         PROJECT(PGRO:RecordID)
                       END
                     END
Queue:Browse:4       QUEUE                            !Queue declaration for browse/combo box using ?List:3
PGRO:Description       LIKE(PGRO:Description)         !List box control field - type derived from field
PG:PartyID             LIKE(PG:PartyID)               !Primary key field - type derived from field
PG:GroupID             LIKE(PG:GroupID)               !Primary key field - type derived from field
PGRO:RecordID          LIKE(PGRO:RecordID)            !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW8::View:Browse    VIEW(ParFileNote)
                       PROJECT(PFN:Date)
                       PROJECT(PFN:Description)
                       PROJECT(PFN:RecordID)
                       PROJECT(PFN:PartyID)
                     END
Queue:Browse:5       QUEUE                            !Queue declaration for browse/combo box using ?List:4
PFN:Date               LIKE(PFN:Date)                 !List box control field - type derived from field
PFN:Description        LIKE(PFN:Description)          !List box control field - type derived from field
PFN:RecordID           LIKE(PFN:RecordID)             !Primary key field - type derived from field
PFN:PartyID            LIKE(PFN:PartyID)              !Browse key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW16::View:Browse   VIEW(ParProduct)
                       PROJECT(PP:Date)
                       PROJECT(PP:Quantity)
                       PROJECT(PP:UnitPrice)
                       PROJECT(PP:Notes)
                       PROJECT(PP:RecordID)
                       PROJECT(PP:PartyID)
                       PROJECT(PP:ProductID)
                       JOIN(PROD:PrimaryKey,PP:ProductID)
                         PROJECT(PROD:Description)
                         PROJECT(PROD:RecordID)
                       END
                     END
Queue:Browse:6       QUEUE                            !Queue declaration for browse/combo box using ?List:5
PP:Date                LIKE(PP:Date)                  !List box control field - type derived from field
PROD:Description       LIKE(PROD:Description)         !List box control field - type derived from field
PP:Quantity            LIKE(PP:Quantity)              !List box control field - type derived from field
PP:UnitPrice           LIKE(PP:UnitPrice)             !List box control field - type derived from field
PP:Notes               LIKE(PP:Notes)                 !List box control field - type derived from field
PP:RecordID            LIKE(PP:RecordID)              !Primary key field - type derived from field
PP:PartyID             LIKE(PP:PartyID)               !Browse key field - type derived from field
PROD:RecordID          LIKE(PROD:RecordID)            !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW41::View:Browse   VIEW(ParShare)
                       PROJECT(PSH:FirstName)
                       PROJECT(PSH:LastName)
                       PROJECT(PSH:PartyID)
                       PROJECT(PSH:Sorter)
                     END
Queue:Browse:7       QUEUE                            !Queue declaration for browse/combo box using ?List:6
PSH:FirstName          LIKE(PSH:FirstName)            !List box control field - type derived from field
PSH:LastName           LIKE(PSH:LastName)             !List box control field - type derived from field
PSH:PartyID            LIKE(PSH:PartyID)              !Primary key field - type derived from field
PSH:Sorter             LIKE(PSH:Sorter)               !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW48::View:Browse   VIEW(ParFica)
                       PROJECT(PARF:Date)
                       PROJECT(PARF:Comments)
                       PROJECT(PARF:PartyID)
                       PROJECT(PARF:FicaItemID)
                       JOIN(FIC:PrimaryKey,PARF:FicaItemID),INNER
                         PROJECT(FIC:Description)
                         PROJECT(FIC:Expiry)
                         PROJECT(FIC:RecordID)
                         JOIN(ENTF:FicaItemKey,FIC:RecordID),INNER
                           PROJECT(ENTF:EntityID)
                         END
                       END
                     END
Queue:Browse:8       QUEUE                            !Queue declaration for browse/combo box using ?List:7
LOC:FicaTick           LIKE(LOC:FicaTick)             !List box control field - type derived from local data
LOC:FicaTick_Icon      LONG                           !Entry's icon ID
FIC:Description        LIKE(FIC:Description)          !List box control field - type derived from field
PARF:Date              LIKE(PARF:Date)                !List box control field - type derived from field
LOC:FicaExpiresDate    LIKE(LOC:FicaExpiresDate)      !List box control field - type derived from local data
PARF:Comments          LIKE(PARF:Comments)            !List box control field - type derived from field
FIC:Expiry             LIKE(FIC:Expiry)               !Browse hot field - type derived from field
PARF:PartyID           LIKE(PARF:PartyID)             !Browse hot field - type derived from field
ENTF:EntityID          LIKE(ENTF:EntityID)            !Browse hot field - type derived from field
PARF:FicaItemID        LIKE(PARF:FicaItemID)          !Primary key field - type derived from field
FIC:RecordID           LIKE(FIC:RecordID)             !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
LOC:PageSetup18   CSTRING(20)
LOC:SSRow:18      Long
LOC:QueueCounter:18 Long
LOC:SSCol:18   Long
LOC:Filename:18    CSTRING(255)
SSQueue:18     Queue,PRE(SSQ:18)
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

SSWindow:18 WINDOW('Print'),AT(,,343,192),FONT('MS Sans Serif',8,,FONT:regular),CENTER,IMM,ICON('Print.ico'), |
         SYSTEM,GRAY,MAX,RESIZE,MODAL
       MENUBAR
         MENU('&File'),USE(?SSFile:18)
           ITEM('Print<9>CtrlP'),USE(?SSFilePrint:18),KEY(CtrlP)
           ITEM,SEPARATOR
           ITEM('&Close<9>CtrlF4'),USE(?SSClose:18),KEY(CtrlF4)
         END
       END
       TOOLBAR,AT(0,0,,18)
         BUTTON,AT(4,3,15,14),USE(?SSPrint:18),FLAT,TIP('Print'),ICON(ICON:Print)
         BUTTON,AT(20,3,15,14),USE(?SSPreview:18),FLAT,TIP('Preview'),ICON('bpreview.ico')
         BUTTON,AT(36,3,15,14),USE(?SSExcel:18),FLAT,TIP('Load Report In Excel'),ICON('excel1.ico')
         BUTTON,AT(52,3,15,14),USE(?SSEdit:18),FLAT,TIP('Edit Spreadsheet'),ICON('pageview.ico')
         GROUP,AT(-6,0,349,2),USE(?SSGroup:18),BOXED,BEVEL(0,0,0600H)
         END
       END
       OLE,AT(0,0,343,176),USE(?SSOle:18),HIDE,COMPATIBILITY(0)
       END
       OLE,AT(0,0,343,176),USE(?OleExcel:18),HIDE,COMPATIBILITY(0)
       END
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
ThisTabTree30  class(TabTree)
TabSelected             Procedure(long p_index),Virtual
OverrideIcon            Procedure,Virtual
             End
SimTreeQueue  Queue
TqData            Long
              End
QuickWindow          WINDOW('Update the Party File'),AT(,,545,266),FONT('Arial',9,,),CENTER,IMM,SYSTEM,GRAY,MDI
                       SHEET,AT(88,3,457,231),USE(Sheet1)
                         TAB('General'),USE(?NameTab)
                           GROUP,AT(97,20,441,24),USE(?PartySettingsGroup),BOXED
                             PROMPT('&Entity:'),AT(100,30),USE(?LOC:Entity:Prompt)
                             LIST,AT(124,30,77,10),USE(LOC:Entity),FONT('MS Sans Serif',,,),TIP('The legal persona of this Party<13,10>PAR:EntityID'),FORMAT('396L(2)|M@s99@'),DROP(30),FROM(Queue:FileDrop:7)
                             BUTTON('...'),AT(204,30,10,10),USE(?SelectEntityButton),SKIP,TIP('Lookup different types of Entities')
                             PROMPT('T&ype:'),AT(220,30),USE(?PartyType:Prompt)
                             LIST,AT(240,30,77,10),USE(LOC:PartyType),FONT('MS Sans Serif',,,),TIP('Specify the type of Entity this Party is<13,10>PAR:PartyTypeID'),FORMAT('200L(2)|M@s99@'),DROP(30),FROM(Queue:FileDrop)
                             BUTTON('...'),AT(320,30,10,10),USE(?SelectPartyTypeButton),SKIP,TIP('Lookup Types of Parties')
                             PROMPT('&Role:'),AT(340,30),USE(?DefaultRole:Prompt)
                             LIST,AT(360,30,77,10),USE(LOC:Role),FONT('MS Sans Serif',,,),TIP('The Role this Party normally plays on a Matter<13,10>PAR:DefaultRoleID'),FORMAT('196L(2)|M@s49@'),DROP(30),FROM(Queue:FileDrop:6)
                             BUTTON('...'),AT(440,30,10,10),USE(?SelectRoleButton),SKIP,TIP('Lookup Roles')
                             PROMPT('Co&de:'),AT(466,30),USE(?PAR:MatterPrefix:Prompt)
                             ENTRY(@s19),AT(487,30,47,10),USE(PAR:MatterPrefix),SKIP,FONT('MS Sans Serif',,,),TIP('The code used to number Matters for this Party<13,10>Automatically created by the pro' &|
   'gram but can be<13,10>overwritten by the user (if required)')
                           END
                           PROMPT('&Surname:'),AT(96,48),USE(?PL:Name:Prompt)
                           ENTRY(@s200),AT(136,49,141,10),USE(PL:Name),IMM,FONT('MS Sans Serif',,,),TIP('Last Name of a Person or Name of a Firm<13,10>PL:Name'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),REQ
                           PROMPT('&First Name:'),AT(96,62),USE(?PL:FirstName:Prompt)
                           ENTRY(@s49),AT(136,62,117,10),USE(PL:FirstName),IMM,FONT('MS Sans Serif',,,),TIP('The Individual''s FirstName<13,10>PL:FirstName'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),OVR,CAP
                           PROMPT('&Title:'),AT(96,76),USE(?PL:Title:Prompt)
                           ENTRY(@s20),AT(136,76,79,10),USE(PL:Title),IMM,FONT('MS Sans Serif',,,),TIP('Client''s title - e.g. Mr, Mrs, Ms<13,10>PL:Title'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),OVR
                           PROMPT('&Initials:'),AT(238,76),USE(?PL:Initials:Prompt)
                           ENTRY(@s19),AT(266,76,39,10),USE(PL:Initials),IMM,FONT('MS Sans Serif',,,),TIP('The Parties initials<13,10>PL:Initials'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                           PROMPT('&Alternative:'),AT(96,91),USE(?PL:AlternativeName:Prompt)
                           ENTRY(@s99),AT(136,91,117,10),USE(PL:AlternativeName),IMM,FONT('MS Sans Serif',,,),TIP('Trading Name or Individual''s Nick Name<13,10>PL:AlternativeName'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                           PROMPT('&ID N&umber:'),AT(96,105),USE(?PL:IdentityNumber:Prompt)
                           ENTRY(@s39),AT(136,105,73,10),USE(PL:IdentityNumber),IMM,FONT('MS Sans Serif',,,),TIP('The ID or Registration Number of the Party<13,10>PL:IdentityNumber'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                           PROMPT('&DOB:'),AT(216,105),USE(?PL:BirthDate:Prompt)
                           SPIN(@d17),AT(236,105,60,10),USE(PL:BirthDate),RIGHT(1),FONT('MS Sans Serif',,,),TIP('If the person does not have an ID you must specify the Date of Birth<13,10>PL:BirthDa' &|
   'te')
                           PROMPT('&Reg Date:'),AT(216,105),USE(?PL:TrustDate:Prompt)
                           SPIN(@d17),AT(253,105,53,10),USE(PL:TrustDate),FONT('MS Sans Serif',,,),TIP('The date the trust/estate was registered<13,10>PL:TrustDate')
                           PROMPT('ID &Type:'),AT(96,119),USE(?PAR:IdentityDocumentType:Prompt)
                           LIST,AT(136,119,170,10),USE(PAR:IdentityDocumentType),IMM,FONT('MS Sans Serif',,,),TIP('The type of identity document used<13,10>PAR:IdentityDocumentType'),DROP(4),FROM('ID Document|#I|Passport|#P|Temporary Residence|#T|Other|#O')
                           PROMPT('&Language:'),AT(96,133),USE(?LOC:Language:Prompt)
                           LIST,AT(136,133,67,10),USE(LOC:Language),SKIP,FONT('MS Sans Serif',,,),TIP('The preferred language of this Party'),FORMAT('76L(2)@s19@'),DROP(3),FROM(Queue:FileDrop:1)
                           GROUP('Postal Address'),AT(324,46,216,92),USE(?PostalAddressGroup),BOXED
                             PROMPT('&Salutation:'),AT(332,59),USE(?PL:Salutation:Prompt)
                             ENTRY(@s49),AT(370,59,165,10),USE(PL:Salutation),IMM,FONT('MS Sans Serif',,,),TIP('Enter the name you would address this client in a letter (E.g. Dear Mr Jones)<13,10>P' &|
   'L:Salutation'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('Line &1:'),AT(332,75),USE(?PL:PostalLine1:Prompt)
                             ENTRY(@s254),AT(370,75,165,10),USE(PL:PostalLine1),IMM,FONT('MS Sans Serif',,,),TIP('First line of the Postal address<13,10>PL:PostalLine1'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('Line &2:'),AT(332,91),USE(?PL:PostalLine2:Prompt)
                             ENTRY(@s49),AT(370,91,165,10),USE(PL:PostalLine2),IMM,FONT('MS Sans Serif',,,),TIP('Second line of the Postal address<13,10>PL:PostalLine2'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('&Town/City:'),AT(332,107),USE(?PL:PostalLine3:Prompt)
                             ENTRY(@s49),AT(370,107,85,10),USE(PL:PostalLine3),IMM,FONT('MS Sans Serif',,,),TIP('Third line of the Postal address<13,10>PL:PostalLine3'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('Postal Co&de:'),AT(462,107),USE(?PL:PostalCode:Prompt)
                             ENTRY(@s19),AT(504,107,29,10),USE(PL:PostalCode),IMM,FONT('MS Sans Serif',,,),TIP('The Postal/Zip code<13,10>PL:PostalCode'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('Country:'),AT(332,123),USE(?Prompt39)
                             LIST,AT(370,123,105,10),USE(LOC:PostalCountry),FONT('MS Sans Serif',,,),TIP('The country (optional)'),FORMAT('196L(2)|M@s49@'),DROP(15),FROM(Queue:FileDrop:3)
                             ENTRY(@n-14),AT(408,123,11,10),USE(PAR:PostalCountryID),HIDE,RIGHT(1)
                             BUTTON('...'),AT(480,123,10,10),USE(?CallLookup),TIP('Lookup a list of countries')
                           END
                           GROUP('Physical Address'),AT(324,144,216,76),USE(?PhysicalAddressGroup),BOXED
                             PROMPT('Line &1:'),AT(334,154),USE(?PL:PhysicalLine1:Prompt)
                             ENTRY(@s254),AT(370,154,165,10),USE(PL:PhysicalLine1),IMM,FONT('MS Sans Serif',,,),TIP('First line of the physical address<13,10>PL:PhysicalLine1'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('Line &2:'),AT(334,170),USE(?PL:PhysicalLine2:Prompt)
                             ENTRY(@s49),AT(370,170,165,10),USE(PL:PhysicalLine2),IMM,FONT('MS Sans Serif',,,),TIP('Second line of the physical address<13,10>PL:PhysicalLine2'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('&Town/City:'),AT(334,186),USE(?PL:PhysicalLine3:Prompt)
                             ENTRY(@s49),AT(370,186,85,10),USE(PL:PhysicalLine3),IMM,FONT('MS Sans Serif',,,),TIP('Third line of the physical address<13,10>PL:PhysicalLine3'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('Postal Co&de:'),AT(462,186),USE(?PL:PhysicalCode:Prompt)
                             ENTRY(@s19),AT(504,186,29,10),USE(PL:PhysicalCode),IMM,FONT('MS Sans Serif',,,),TIP('The Postal/Zip code<13,10>PL:PhysicalCode'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('Country:'),AT(334,202),USE(?Prompt39:2)
                             LIST,AT(370,202,105,10),USE(LOC:PhysicalCountry),FONT('MS Sans Serif',,,),TIP('The country (optional)'),FORMAT('196L(2)|M@s49@'),DROP(15),FROM(Queue:FileDrop:4)
                             ENTRY(@n-14),AT(428,202,13,10),USE(PAR:PhysicalCountryID),HIDE,RIGHT(1)
                             BUTTON('...'),AT(480,202,10,10),USE(?CallLookup:2),TIP('Lookup a list of countries')
                           END
                           GROUP('Contact Details'),AT(96,149,203,70),USE(?Group8),BOXED
                             LIST,AT(104,159,185,50),USE(?TelephoneList),IMM,VSCROLL,FORMAT('65L(2)|M~Type~@s24@96L(2)|M~Number~@s50@'),FROM(Queue:Browse)
                             BUTTON('&Insert'),AT(144,186,42,12),USE(?Insert),HIDE
                             BUTTON('&Change'),AT(184,186,42,12),USE(?Change),HIDE
                             BUTTON('&Delete'),AT(224,186,42,12),USE(?Delete),HIDE
                           END
                           CHECK('Do not send Notifications to this Party'),AT(96,220),USE(PAR:DoNotNotifyFlag),SKIP,TIP('Do not send this Party any automatic notifications created by Events<13,10>PAR:DoNotN' &|
   'otifyFlag')
                         END
                         TAB('Marital'),USE(?MaritalTab)
                           LIST,AT(152,34,201,10),USE(LOC:MaritalStatus),FONT('MS Sans Serif',,,),TIP('The Marital Status<13,10>PAR:MaritalStatus'),DROP(8),FROM('Unmarried|Out of Community|In Community|Foreign|Civil Union In Community|Civil Union Out of Community|Other')
                           PROMPT('&Wording'),AT(100,51),USE(?PL:MaritalDescription:Prompt)
                           ENTRY(@s254),AT(152,51,201,10),USE(PL:MaritalDescription),IMM,SKIP,FONT('MS Sans Serif',,,),TIP('A description of the marital contract<13,10>PL:MaritalDescription'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                           BUTTON,AT(361,51,10,10),USE(?LookupLibraryButton),SKIP,TIP('Lookup and insert text from the Lookup Library (Ctrl L)'),KEY(CtrlL),ICON('Lookup.ico')
                           PROMPT('&Marital Status'),AT(100,34),USE(?PAR:MaritalStatus:Prompt)
                           GROUP('Marriage'),AT(100,71,207,110),USE(?MarriageGroup),BOXED
                             PROMPT('&Date:'),AT(108,85),USE(?PAR:MarriageDate:Prompt)
                             ENTRY(@d17),AT(162,85,60,10),USE(PL:MarriageDate),FONT('MS Sans Serif',,,),TIP('The date of the marriage<13,10>PL:MarriageDate')
                             PROMPT('&Place:'),AT(108,101),USE(?PAR:MarriagePlace:Prompt)
                             ENTRY(@s99),AT(162,101,126,10),USE(PL:MarriagePlace),IMM,FONT('MS Sans Serif',,,),TIP('The Place of the Marriage<13,10>PL:MarriagePlace'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             BUTTON,AT(292,101,10,10),USE(?LookupLibraryButton:5),SKIP,TIP('Lookup and insert text from the Lookup Library (Ctrl L)'),KEY(CtrlL),ICON('Lookup.ico')
                             PROMPT('&Spouse'),AT(108,114),USE(?PL:DomiciledIn:Prompt)
                             STRING('Domiciled In:'),AT(108,122),USE(?String1454)
                             ENTRY(@s34),AT(162,117,126,10),USE(PL:DomiciledIn),IMM,FONT('MS Sans Serif',,,),TIP('The country the spouse was domiciled in at the time of the marriage<13,10>PL:Domicile' &|
   'dIn'),ALRT(CtrlUp),ALRT(CtrlDown),ALRT(UpKey),ALRT(DownKey)
                             BUTTON('...'),AT(292,117,11,11),USE(?DomiciledInButton),SKIP,TIP('Lookup the Country')
                             PROMPT('ANC N&umber:'),AT(108,133),USE(?PL:ANCNumber:Prompt)
                             ENTRY(@s14),AT(162,133,84,10),USE(PL:ANCNumber),IMM,FONT('MS Sans Serif',,,),TIP('The number of the ANC<13,10>PL:ANCNumber'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('&Deeds Office:'),AT(108,149),USE(?PL:DeedsRegistry:Prompt)
                             ENTRY(@s34),AT(162,149,126,10),USE(PL:DeedsRegistry),IMM,FONT('MS Sans Serif',,,),TIP('The Deeds Office the ANC is Registered In<13,10>PL:DeedsRegistry'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             BUTTON,AT(292,149,10,10),USE(?LookupLibraryButton:3),SKIP,TIP('Lookup and insert text from the Lookup Library (Ctrl L)'),KEY(CtrlL),ICON('Lookup.ico')
                             BUTTON('...'),AT(292,164,11,11),USE(?MarriageCountryButton),SKIP,TIP('Lookup the Country')
                             PROMPT('&Foreign Country:'),AT(108,165),USE(?PL:MarriageCountry:Prompt)
                             ENTRY(@s99),AT(162,165,126,10),USE(PL:MarriageCountry),IMM,FONT('MS Sans Serif',,,),TIP('The laws of which Country is the Marriage governed by<13,10>PL:MarriageCountry'),ALRT(CtrlUp),ALRT(CtrlDown),ALRT(UpKey),ALRT(DownKey),REQ
                           END
                           GROUP('Spouse'),AT(324,71,215,110),USE(?SpouseGroup),BOXED
                             CHECK('A&ssisted by Spouse?'),AT(330,80),USE(PL:AssistedFlag),RIGHT(1),TIP('Must the mortgagor be assisted by the spouse?<13,10>PL:AssistedFlag')
                             PROMPT('&Last Name:'),AT(332,91),USE(?PAR:SpouseLastName:Prompt)
                             ENTRY(@s49),AT(380,91,136,10),USE(PL:SpouseName),IMM,FONT('MS Sans Serif',,,),TIP('The last name of the spouse<13,10>PL:SpouseName'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('&First Name(s):'),AT(332,104),USE(?PAR:SpouseFirstNames:Prompt)
                             ENTRY(@s49),AT(380,104,136,10),USE(PL:SpouseFirstName),IMM,FONT('MS Sans Serif',,,),TIP('The first names of the spouse<13,10>PL:SpouseFirstName'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('Initial(s):'),AT(332,117),USE(?PL:SpouseInitials:Prompt)
                             ENTRY(@s19),AT(380,117,93,10),USE(PL:SpouseInitials),FONT('MS Sans Serif',,,),READONLY
                             PROMPT('&ID Number:'),AT(332,130),USE(?PAR:SpouseIdentityNumber:Prompt)
                             ENTRY(@s39),AT(380,130,93,10),USE(PL:SpouseIdentityNumber),IMM,FONT('MS Sans Serif',,,),TIP('The Identity Number of the Spouse<13,10>PL:SpouseIdentityNumber'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),READONLY
                             PROMPT(' or   &DOB:'),AT(332,143),USE(?PAR:SpouseBirthDate:Prompt)
                             ENTRY(@d17),AT(380,143,51,10),USE(PL:SpouseBirthDate),RIGHT(1),FONT('MS Sans Serif',,,),TIP('If the person does not have an ID you must specify the Date of Birth<13,10>PL:SpouseB' &|
   'irthDate'),READONLY
                             BUTTON('  &Edit this Party''s Details'),AT(332,162,117,16),USE(?EditSpousePartyButton),LEFT,TIP('Edit this Party''s details'),ICON('id_cards.ico')
                             BUTTON('&Select a Party'),AT(332,163,71,13),USE(?SelecteSpousePartyButton),LEFT,TIP('Select an existing Party from the Address Book for the Deceased'),ICON(ICON:Copy)
                             BUTTON('C&reate a Party'),AT(462,163,71,13),USE(?CreatePartyButton),LEFT,TIP('Create a Party in the Address Book for the spouse'),ICON(ICON:Copy)
                           END
                           OPTION,AT(358,31,176,16),USE(PAR:UnmarriedStatus),TIP('Give further details why the Party is unmarried<13,10>PAR:UnmarriedStatus<13,10>0 = Never ' &|
   'married<13,10>1 = Divorced<13,10>2 = Widowed')
                             RADIO('Never Married'),AT(362,34),USE(?PAR:UnmarriedStatus:Radio1),TIP('Further details why the Party is unmarried<13,10>PAR:UnmarriedStatus<13,10>0 = Never marri' &|
   'ed<13,10>1 = Divorced<13,10>2 = Widowed'),VALUE('0')
                             RADIO('Divorced'),AT(426,34),USE(?PAR:UnmarriedStatus:Radio2),TIP('Further details why the Party is unmarried<13,10>PAR:UnmarriedStatus<13,10>0 = Never marri' &|
   'ed<13,10>1 = Divorced<13,10>2 = Widowed'),VALUE('1')
                             RADIO('Widowed'),AT(474,34),USE(?PAR:UnmarriedStatus:Radio3),TIP('Further details why the Party is unmarried<13,10>PAR:UnmarriedStatus<13,10>0 = Never marri' &|
   'ed<13,10>1 = Divorced<13,10>2 = Widowed'),VALUE('2')
                           END
                         END
                         TAB('Signatories'),USE(?SignatoriesTab)
                           GROUP('Signatories'),AT(96,27,353,145),USE(?Group6),BOXED
                             PROMPT('&Authorised By:'),AT(102,107),USE(?PL:AuthorityPhrase:Prompt)
                             ENTRY(@s245),AT(186,107,217,9),USE(PL:AuthorityPhrase),IMM,FONT('MS Sans Serif',,,),
                             TIP('The phrase used to describe how the signatories <13,10>were granted the authority to ' &|
   'sign<13,10>Eg: "duly authorised thereto by virtue of a resolution<13,10>taken at Pretoria ' &|
   'on 21 July 2004"<13,10>PL:AuthorityPhrase'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             BUTTON,AT(406,107,10,10),USE(?LookupLibraryButton:6),SKIP,TIP('Lookup and insert text from the Lookup Library (Ctrl L)'),KEY(CtrlL),ICON('Lookup.ico')
                             PROMPT('C&apacity Phrase:'),AT(102,123),USE(?PL:CapacityPhrase:Prompt)
                             ENTRY(@s74),AT(186,123,217,9),USE(PL:CapacityPhrase),IMM,
                             FONT('MS Sans Serif',,,),
                             TIP('The phrase used in Conveyancing documents to descibe the signatory''s capacity<13,10>
                             Eg: "in my capacity as the PASTOR of the"<13,10>PL:CapacityPhrase'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             BUTTON,AT(406,123,10,10),USE(?LookupLibraryButton:7),SKIP,TIP('Lookup and insert text from the Lookup Library (Ctrl L)'),KEY(CtrlL),ICON('Lookup.ico')
                             PROMPT('&High Court Division:'),AT(102,139),USE(?PL:TrustDivision:Prompt)
                             ENTRY(@s255),AT(186,139,217,9),USE(PL:TrustDivision),IMM,FONT('MS Sans Serif',,,),TIP(
                               'The High Court where the Trust/Estate is registered<13,10>PL:TrustDivision'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             BUTTON,AT(406,139,10,10),USE(?LookupLibraryButton:8),SKIP,TIP('Lookup and insert text from the Lookup Library (Ctrl L)'),KEY(CtrlL),ICON('Lookup.ico')
                             PROMPT('Date Resolution Signed:'),AT(102,155),USE(?PAR:DateResolutionSigned:Prompt)
                             ENTRY(@d17b),AT(186,155,58,10),USE(PAR:DateResolutionSigned),LEFT(1),FONT('MS Sans Serif',,,),
                             TIP('Date Resolution Signed<13,10>PAR:DateResolutionSigned')
                             BUTTON('&Insert'),AT(140,73,42,12),USE(?Insert:2),HIDE
                             LIST,AT(106,41,308,55),USE(?SignatoriesList),IMM,FORMAT('196L(2)|M~Signatory~@s49@'),FROM(Queue:Browse:1)
                             BUTTON('&Change'),AT(200,73,42,12),USE(?Change:2),HIDE
                             BUTTON('&Delete'),AT(264,73,42,12),USE(?Delete:2),HIDE
                           END
                         END
                         TAB('Shareholders'),USE(?ShareholdersTab)
                           GROUP('Shareholders'),AT(96,27,241,201),USE(?ShareholdersGroup),BOXED
                             LIST,AT(105,40,224,180),USE(?List:6),IMM,MSG('Browsing Records'),FORMAT('85L(2)|M~First Name~@s49@100L(2)|M~Last Name~@s49@'),FROM(Queue:Browse:7)
                             BUTTON('&Insert'),AT(129,107,42,12),USE(?Insert:8),HIDE
                             BUTTON('&Change'),AT(173,107,42,12),USE(?Change:7),HIDE
                             BUTTON('&Delete'),AT(217,107,42,12),USE(?Delete:8),HIDE
                           END
                         END
                         TAB('Tax Details'),USE(?TaxDetailsTab)
                           GROUP('Party'),AT(96,27,223,97),USE(?PartyTaxGroup),BOXED
                             OPTION('Registered for Income Tax'),AT(180,41,69,18),USE(PAR:TaxPayer),TIP('This Party is Registered for Income Tax<13,10>PAR:TaxPayer')
                               RADIO('Yes'),AT(184,43),USE(?PAR:TaxPayer:Radio1),TIP('This Party is an SA taxpayer<13,10>PAR:TaxPayer = ''Y'''),VALUE('Y')
                               RADIO('No'),AT(216,43),USE(?PAR:TaxPayer:Radio2),TIP('This Party is not an SA taxpayer<13,10>PAR:TaxPayer = ''N'''),VALUE('N')
                             END
                             PROMPT('&Registered Taxpayer:'),AT(104,43),USE(?Prompt5:1)
                             PROMPT('&Tax Number:'),AT(104,59),USE(?PAR:TaxNumber:Prompt)
                             ENTRY(@s29),AT(184,59,115,10),USE(PAR:TaxNumber),IMM,FONT('MS Sans Serif',,,),TIP('The tax reference number<13,10>PAR:TaxNumber')
                             PROMPT('Annual Income:'),AT(104,59),USE(?PAR:AnnualIncome:Prompt)
                             ENTRY(@n15.2),AT(184,59,60,10),USE(PAR:AnnualIncome),DECIMAL(12),FONT('MS Sans Serif',,,),TIP('The gross annual income of this Party<13,10>PAR:AnnualIncome')
                             OPTION('SA Resident'),AT(180,73,69,18),USE(PAR:SAResident),TIP('This Party is a South African resident<13,10>PAR:SAResident')
                               RADIO('Yes'),AT(184,75),USE(?PAR:SAResident:Radio1),TIP('This Party is an SA resident<13,10>PAR:SAResident = ''Y'''),VALUE('Y')
                               RADIO('No'),AT(216,75),USE(?PAR:SAResident:Radio2),TIP('This Party is not an SA resident<13,10>PAR:SAResident = ''N'''),VALUE('N')
                             END
                             PROMPT('SA Resident?'),AT(104,75),USE(?Prompt6:1)
                             PROMPT('Country Of Residence:'),AT(104,91),USE(?PAR:CountryOfResidence:Prompt)
                             ENTRY(@s49),AT(184,91,117,10),USE(PAR:CountryOfResidence),FONT('MS Sans Serif',,,),TIP('The country where this Party is a resident<13,10>PAR:CountryOfResidence')
                             BUTTON('...'),AT(304,91,11,11),USE(?CountryOfResidenceButton),SKIP,TIP('Lookup the Country')
                             PROMPT('Passport Number:'),AT(104,107),USE(?PAR:PassportNumber:Prompt)
                             ENTRY(@s19),AT(184,107,60,10),USE(PAR:PassportNumber),FONT('MS Sans Serif',,,),TIP('The Party''s passport number<13,10>PAR:PassportNumber')
                           END
                           PROMPT('&Vat Number:'),AT(96,135),USE(?PAR:VatNumber:Prompt)
                           ENTRY(@s19),AT(140,135,115,10),USE(PAR:VatNumber),IMM,FONT('MS Sans Serif',,,),TIP('Their VAT Registration Number<13,10>PAR:VatNumber')
                           BUTTON('  &Edit this Party''s Details'),AT(328,132,117,16),USE(?EditSpousePartyButton:2),LEFT,TIP('Edit this Party''s details'),ICON('id_cards.ico')
                           GROUP('Spouse'),AT(328,27,211,97),USE(?SpouseTaxGroup),BOXED,HIDE
                             OPTION('Registered for Income Tax'),AT(404,38,69,18),USE(PAR:SpouseTaxPayer),TIP('This Party''s spouse is Registered for Income Tax<13,10>PAR:SpouseTaxPayer')
                               RADIO('Yes'),AT(412,43),USE(?PAR:SpouseTaxPayer:Radio1),TIP('This Party''s spouse is an SA taxpayer<13,10>PAR:SpouseTaxPayer = ''Y'''),VALUE('Y')
                               RADIO('No'),AT(444,43),USE(?PAR:SpouseTaxPayer:Radio2),TIP('This Party''s spouse is not an SA taxpayer<13,10>PAR:SpouseTaxPayer = ''N'''),VALUE('N')
                             END
                             PROMPT('&Registered Taxpayer:'),AT(336,43),USE(?Prompt5)
                             PROMPT('Tax Number:'),AT(336,59),USE(?PAR:SpouseTaxNumber:Prompt)
                             ENTRY(@s29),AT(412,59,115,10),USE(PAR:SpouseTaxNumber),IMM,FONT('MS Sans Serif',,,),TIP('The Spouse<146>s Income Tax Reference Number, if married in community of property<13,10>P' &|
   'AR:SpouseTaxNumber')
                             PROMPT('Annual Income:'),AT(337,59),USE(?PAR:SpouseAnnualIncome:Prompt)
                             ENTRY(@n15.2),AT(412,59,60,10),USE(PAR:SpouseAnnualIncome),DECIMAL(12),FONT('MS Sans Serif',,,),TIP('The gross annual income of this Party''s spouse<13,10>PAR:SpouseAnnualIncome')
                             OPTION('SA Resident'),AT(408,70,69,18),USE(PAR:SpouseSAResident),TIP('This Party''s spouse is a South African resident<13,10>PAR:SpouseSAResident')
                               RADIO('Yes'),AT(412,75),USE(?PAR:SpouseSAResident:Radio1),TIP('This Party''s spouse is an SA resident<13,10>PAR:SpouseSAResident = ''Y'''),VALUE('Y')
                               RADIO('No'),AT(444,75),USE(?PAR:SpouseSAResident:Radio2),TIP('This Party''s spouse is not an SA resident<13,10>PAR:SpouseSAResident = ''N'''),VALUE('N')
                             END
                             PROMPT('SA Resident?'),AT(336,75),USE(?Prompt6)
                             PROMPT('Country Of Residence:'),AT(336,91),USE(?PAR:SpouseCountryOfResidence:Prompt)
                             ENTRY(@s49),AT(412,91,109,10),USE(PAR:SpouseCountryOfResidence),FONT('MS Sans Serif',,,),TIP('The country where this Party''s spouse is a resident<13,10>PAR:SpouseCountryOfResidenc' &|
   'e')
                             BUTTON('...'),AT(524,91,11,11),USE(?CountryOfResidenceButton:2),SKIP,TIP('Lookup the Country')
                             PROMPT('Passport Number:'),AT(336,107),USE(?PAR:SpousePassportNumber:Prompt)
                             ENTRY(@s19),AT(412,107,60,10),USE(PAR:SpousePassportNumber),FONT('MS Sans Serif',,,),TIP('The Party''s spouse''s passport number<13,10>PAR:SpousePassportNumber')
                           END
                           BUTTON('Update the Spouse''s Tax Details'),AT(433,131,104,26),USE(?UpdateSpouseTaxDetailsButton),HIDE,LEFT,TIP('Update the Spouse''s Tax details you have just createdin the Address Book'),ICON(ICON:Copy)
                         END
                         TAB('Auditors'),USE(?AuditorsTab),FONT('Arial',,,)
                           GROUP('Auditors'),AT(96,31,270,170),USE(?AuditorsGroup),BOXED
                             PROMPT('&Name:'),AT(105,43),USE(?PAR:AuditorName:Prompt)
                             ENTRY(@s99),AT(166,43,166,10),USE(PAR:AuditorName),FONT('MS Sans Serif',,,),TIP('The name of the Auditors<13,10>PAR:AuditorName')
                             PROMPT('&Contact Person:'),AT(105,59),USE(?PAR:AuditorContact:Prompt)
                             ENTRY(@s99),AT(166,59,166,10),USE(PAR:AuditorContact),FONT('MS Sans Serif',,,),TIP('The name of the Auditor''s contact person<13,10>PAR:AuditorContact')
                             PROMPT('&Postal Address:'),AT(105,75),USE(?PAR:AuditorPostal:Prompt)
                             TEXT,AT(166,75,121,38),USE(PAR:AuditorPostal),FONT('MS Sans Serif',,,),TIP('Postal address of the Auditors<13,10>PAR:AuditorPostal')
                             PROMPT('P&hysical Address:'),AT(105,119),USE(?PAR:AuditorPhysical:Prompt)
                             ENTRY(@s99),AT(166,119,166,10),USE(PAR:AuditorPhysical),FONT('MS Sans Serif',,,),TIP('The physical address of the Auditors<13,10>PAR:AuditorPhysical')
                             PROMPT('Ph&one No:'),AT(105,135),USE(?PAR:AuditorPhone:Prompt)
                             ENTRY(@s19),AT(166,135,121,10),USE(PAR:AuditorPhone),FONT('MS Sans Serif',,,),TIP('The phone number of the Auditor<13,10>PAR:AuditorPhone')
                             PROMPT('&Fax No:'),AT(105,151),USE(?PAR:AuditorFax:Prompt)
                             ENTRY(@s19),AT(166,151,121,10),USE(PAR:AuditorFax),FONT('MS Sans Serif',,,),TIP('The Fax number of the Auditor<13,10>PAR:AuditorFax')
                             PROMPT('&Email Address:'),AT(105,167),USE(?PAR:AuditorEmail:Prompt)
                             ENTRY(@s254),AT(166,167,121,10),USE(PAR:AuditorEmail),FONT('MS Sans Serif',,,),TIP('The email address of the Auditor<13,10>PAR:AuditorEmail')
                             BUTTON('&Create a Party'),AT(292,185,71,13),USE(?CreateAuditorPartyButton),LEFT,TIP('Create a new Party in the Address Book for the Deceased'),ICON(ICON:Copy)
                           END
                         END
                         TAB('Banking Details'),USE(?FinancialTab)
                           GROUP('Bank Accounts'),AT(96,27,405,122),USE(?BankAccountGroup),BOXED
                             LIST,AT(104,42,389,82),USE(?List:2),IMM,HVSCROLL,FORMAT('150L(2)|MJ~Description~@s49@120L(2)|M~Name~@s49@80L(2)|M~Number~@s19@78L(2)|M~Ty' &|
   'pe~@s29@76L(2)|M~Institution~@s29@120L(2)|M~Branch~@s49@60L(2)|M~Branch Code~@s1' &|
   '9@'),FROM(Queue:Browse:3)
                             BUTTON('&Insert'),AT(156,74,42,12),USE(?Insert:4),HIDE
                             BUTTON('&Change'),AT(200,74,42,12),USE(?Change:4),HIDE
                             BUTTON('&Delete'),AT(244,74,42,12),USE(?Delete:4),HIDE
                             BUTTON('&Set As Default'),AT(104,129,83,14),USE(?SetDefaultBankButton),LEFT,TIP('Indicate which Bank Account is the one normally used by this Party'),ICON('bok.ico')
                           END
                           CHECK('This Party is paid electronically'),AT(96,152),USE(PAR:ElectronicPaymentFlag),TIP('This party receives payments electronically.<13,10>In Accounting, the Payments batche' &|
   's will default to ''Electronic Payment'' instead <13,10>of ''Cheque'' and the default ban' &|
   'king information will be used.<13,10>This includes batch processes such as the genera' &|
   'ting of payments<13,10>for Administration Orders.<13,10>PAR:ElectronicPaymentFlag')
                         END
                         TAB('CRM'),USE(?CRMTab)
                           PROMPT('Re&gion:'),AT(96,32),USE(?Prompt60)
                           LIST,AT(136,32,129,10),USE(LOC:Region),FONT('MS Sans Serif',,,),TIP('The Region this entry falls under (optional)<13,10>PAR:ParRegionID'),FORMAT('196L(2)|M@s49@'),DROP(15),FROM(Queue:FileDrop:8)
                           ENTRY(@n-14),AT(200,32,11,10),USE(PAR:ParRegionID),HIDE,RIGHT(1),TIP('A region')
                           BUTTON('...'),AT(268,32,10,10),USE(?CallLookup:3),TIP('Lookup a Region')
                           ENTRY(@s1),AT(86,4),USE(LOC:FirstCRMField),HIDE
                           PROMPT('Province:'),AT(96,48),USE(?LOC:Province:Prompt)
                           ENTRY(@s29),AT(136,48,129,10),USE(LOC:Province),IMM,SKIP,FONT('MS Sans Serif',,,FONT:bold,CHARSET:ANSI),COLOR(COLOR:Silver),TIP('The Province the Region falls in<13,10>It is defined in the ParRegion table<13,10>PREG:Pro' &|
   'vinceID'),ALRT(UpKey),ALRT(DownKey),READONLY
                           PROMPT('C&ategory:'),AT(96,64),USE(?LOC:CategoryPrompt)
                           LIST,AT(136,64,129,10),USE(LOC:Category),FONT('MS Sans Serif',,,),TIP('A user-defineable category to group certain Address Book entries together<13,10>PAR:P' &|
   'arCategoryID'),FORMAT('196L(2)|M@s49@'),DROP(15),FROM(Queue:FileDrop:9)
                           ENTRY(@n-14),AT(216,64,11,10),USE(PAR:ParCategoryID),HIDE,RIGHT(1),TIP('A category  - for the CRM')
                           BUTTON('...'),AT(268,64,10,10),USE(?CallLookup:4)
                           GROUP('Birthday'),AT(100,85,175,49),USE(?Group14),BOXED
                             CHECK('Automatically send this Party a Message?'),AT(108,99),USE(PAR:BirthdaySMSFlag),TIP('Automatically send this Party a Message on their birthday?<13,10>The Message is gener' &|
   'ated by an Event setup in Setup | Program Settings | Miscellaneous<13,10>and sent out' &|
   ' by BirthdaysMessages.exe which must run as a Windows Task on the Server<13,10>See th' &|
   'e White Paper on www.LegalSuite.co.za for more information<13,10>PAR:BirthdaySMSFlag')
                             PROMPT('&Day:'),AT(108,117),USE(?PAR:BirthDay:Prompt)
                             SPIN(@n_2b),AT(128,117,25,10),USE(PAR:BirthDay),FONT('MS Sans Serif',,,),TIP('The Day of the Month (1-31)<13,10>PAR:BirthDay'),RANGE(0,31)
                             PROMPT('&Month:'),AT(160,117),USE(?LOC:BirthMonth:Prompt)
                             LIST,AT(184,117,83,10),USE(LOC:BirthMonth),FONT('MS Sans Serif',,,),TIP('The month the birthday falls in<13,10>PAR:BirthMonth'),DROP(12),FROM('January|#1|February|#2|March|#3|April|#4|May|#5|June|#6|July|#7|August|#8|September|#9|October|#10|November|#11|December|#12')
                           END
                           GROUP('User-defineable Groups'),AT(300,29,227,95),USE(?PartyGroupsGroup),BOXED
                             LIST,AT(308,43,211,69),USE(?List:3),IMM,VSCROLL,FORMAT('196L(2)|M~This Party belongs to these Groups~@s49@'),FROM(Queue:Browse:4)
                             BUTTON('&Insert'),AT(318,59,42,12),USE(?Insert:5),HIDE
                             BUTTON('&Delete'),AT(370,59,42,12),USE(?Delete:5),HIDE
                           END
                           GROUP('History'),AT(100,138,145,50),USE(?Group13),BOXED
                             PROMPT('Last Instruction:'),AT(108,154),USE(?PAR:LastInstructedDate:Prompt)
                             ENTRY(@d17b),AT(164,154,60,10),USE(PAR:LastInstructedDate),SKIP,DISABLE,RIGHT(1),FONT('MS Sans Serif',,,FONT:bold,CHARSET:ANSI),COLOR(COLOR:Silver),TIP('The last instruction received from this Client<13,10>PAR:LastInstructedDate'),READONLY
                             PROMPT('Total Income:'),AT(108,170),USE(?PAR:TotalBilled:Prompt)
                             ENTRY(@n-15.2),AT(164,170,61,10),USE(LOC:TotalIncome),SKIP,DECIMAL(12),FONT('MS Sans Serif',,,FONT:bold,CHARSET:ANSI),COLOR(COLOR:Silver),TIP('The total income from this Client (this year plus last year)<13,10>This is a calculat' &|
   'ed field:<13,10>PAR:Income1 + PAR:Income2 . . . PAR:Income12<13,10>+ PAR:LIncome1 + PAR:LI' &|
   'ncome2 . . . PAR:LIncome12<13,10>'),READONLY
                           END
                           ENTRY(@s1),AT(86,4),USE(LOC:LastCRMField),HIDE
                         END
                         TAB('File Notes'),USE(?FileNotesTab)
                           LIST,AT(100,29,437,193),USE(?List:4),IMM,MSG('Browsing Records'),FORMAT('52L|M~Date~L(2)@d17@155L|M~Description~L(2)@s255@'),FROM(Queue:Browse:5)
                           BUTTON('&Insert'),AT(352,98,42,12),USE(?Insert:6),HIDE
                           BUTTON('&Change'),AT(396,98,42,12),USE(?Change:5),HIDE
                           BUTTON('&Delete'),AT(440,98,42,12),USE(?Delete:6),HIDE
                         END
                         TAB('Products'),USE(?ProductsTab)
                           LIST,AT(100,27,437,198),USE(?List:5),IMM,MSG('Browsing Records'),FORMAT('55L|M~Date~L(2)@d17@102L|M~Description~L(2)@s49@20L|M~Qty~L(2)@n_5b@44L|M~Unit P' &|
   'rice~L(2)@n11.2@1016L|M~Notes~L(2)@s254@/'),FROM(Queue:Browse:6)
                           BUTTON('&Insert'),AT(208,125,42,12),USE(?Insert:7),HIDE
                           BUTTON('&Change'),AT(252,125,42,12),USE(?Change:6),HIDE
                           BUTTON('&Delete'),AT(296,125,42,12),USE(?Delete:7),HIDE
                           BUTTON('&Print'),AT(256,147,46,14),USE(?Print),HIDE,TIP('Print This List')
                         END
                         TAB('Miscellaneous'),USE(?MiscTab)
                           GROUP,AT(93,32,281,125),USE(?MiscellaneousGroup)
                             PROMPT('Default Matter:'),AT(96,32),USE(?Prompt63)
                             LIST,AT(168,32,115,10),USE(LOC:Matter),VSCROLL,FONT('MS Sans Serif',,,),TIP('The Matter used to bill this Client for sundry items (e.g. from the TradeMarks module)<13,10>PAR:BillingMatterID'),FORMAT('67L(2)@s49@'),DROP(15),FROM(Matter:Queue)
                             PROMPT('Alternate Reference'),AT(96,48),USE(?Prompt61:2)
                             ENTRY(@s99),AT(168,48,196,10),USE(PAR:AlternateRef),IMM,FONT('MS Sans Serif',,,),TIP('Use this field as a way to store a unique value for this party.<13,10>This then allow' &|
   's other system to reference this party<13,10>using a value other than the parties nam' &|
   'e.<13,10>PAR:AlternateRef'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('Old Code:'),AT(96,64),USE(?Prompt61)
                             ENTRY(@s99),AT(168,64,196,10),USE(PAR:OldCode),IMM,FONT('MS Sans Serif',,,),TIP('The code used by this Party in a previous computer system (optional)<13,10>PAR:OldCod' &|
   'e'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('POA Number:'),AT(96,80),USE(?PAR:POANumber:Prompt)
                             ENTRY(@s29),AT(168,80,101,10),USE(PAR:POANumber),IMM,FONT('MS Sans Serif',,,),TIP('The Power of Attorney number granted by the Registrar<13,10>PAR:POANumber'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('Occ&upation:'),AT(96,96),USE(?PL:Occupation:Prompt)
                             ENTRY(@s74),AT(168,96,141,10),USE(PL:Occupation),IMM,FONT('MS Sans Serif',,,),TIP('A description of the person''s job title (optional)<13,10>PL:Occupation'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('Matter Message:'),AT(96,112),USE(?PAR:MatterTakeOnReminder:Prompt)
                             ENTRY(@s254),AT(168,112,189,10),USE(PAR:MatterTakeOnReminder),IMM,FONT('MS Sans Serif',,,),TIP('A message that will pop-up when a User takes on a new Matter for this Party<13,10>PAR' &|
   ':MatterTakeOnReminder')
                             BUTTON,AT(361,112,10,10),USE(?LookupLibraryButton:2),SKIP,TIP('Lookup and insert text from the Lookup Library (Ctrl L)'),KEY(CtrlL),ICON('Lookup.ico')
                             PROMPT('Docex Address:'),AT(96,128),USE(?PL:Docex:Prompt)
                             TEXT,AT(168,128,141,20),USE(PL:Docex),IMM,FONT('MS Sans Serif',,,),TIP('The Docex address (e.g. Docex 1234 Johannesburg)<13,10>PL:Docex'),ALRT(CtrlUp),ALRT(CtrlDown)
                             CHECK('This Party is Inactive?'),AT(380,28,84,12),USE(PAR:InactiveFlag),SKIP,TIP('This Party is not involved in any Matters and will<13,10>not be displayed among the Active Parties in the Address Book<13,10>PAR:InactiveFlag')
                             CHECK(' &Do not display this Party to remote users'),AT(380,51),USE(PAR:InternalFlag),SKIP,TIP('This party will not appear on the LegalSuite Online website<13,10>PAR:InternalFlag')
                             GROUP('Remote Access (to LegalSuite Online website)'),AT(380,66,158,66),USE(?RemoteAccessGroup),BOXED
                               PROMPT('Password:'),AT(392,82),USE(?PAR:RemoteAccessPassword:Prompt)
                               ENTRY(@s19),AT(432,82,63,10),USE(PAR:RemoteAccessPassword),IMM,FONT('MS Sans Serif',,,),TIP('
                               The password allocated to this Party to access LegalSuite remotely<13,10>PAR:RemoteAc' &|
   'cessPassword'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                               PROMPT('Expiry:'),AT(392,98),USE(?PAR:RemoteAccessExpiry:Prompt)
                               SPIN(@d17b),AT(432,98,60,10),USE(PAR:RemoteAccessExpiry),RIGHT(1),FONT('MS Sans Serif',,,),TIP('The date this Party is no longer allowed remote access<13,10>PAR:RemoteAccessExpiry')
                               CHECK('Do not automatically send login details'),AT(392,114),USE(PAR:NeverLOLNotifyFlag),TIP('Do not automatically send this Party LOL login details<13,10>PAR:NeverLOLNotifyFlag')
                             END
                             GROUP('LegalSuite Community'),AT(380,137,158,46),USE(?Group16),BOXED
                               PROMPT('Their Firm Code:'),AT(388,165),USE(?PAR:LegalsuiteFirmCode:Prompt)
                               ENTRY(@s9),AT(445,165,60,10),USE(PAR:LegalsuiteFirmCode),FONT('MS Sans Serif',,,),TIP('Contact this party to get their "Firm Code".<13,10,13,10>Fill this in if you wish to send your correspondent <13,10>work electronically to this party/agent<13,10,13,10>PAR:LegalsuiteF' &|
   'irmCode')
                               STRING('This Party is a  firm that uses LegalSuite'),AT(388,151),USE(?String4)
                             END
                           END
                           CHECK('Lock this Party'),AT(380,40),USE(PAR:LockParty),SKIP,TIP('Locking the details on this party will only allow Administrators to edit them an' &|
   'd remove the lock.')
                           GROUP('DataLink'),AT(381,189,158,36),USE(?LAWGroup),BOXED
                             PROMPT('LAW Reference:'),AT(389,205),USE(?PAR:LawRef:Prompt)
                             ENTRY(@n_7b),AT(445,205,62,10),USE(PAR:LawRef),RIGHT(1),FONT('MS Sans Serif',,,),TIP('This clients Law Reference<13,10>PAR:LawRef')
                           END
                           GROUP('History'),AT(97,163,250,49),USE(?Group22),BOXED
                             PROMPT('Created By:'),AT(105,178),USE(?Prompt83)
                             STRING(@s99),AT(145,178,196,10),USE(LOC:CreatedBy)
                             PROMPT('Modified By:'),AT(105,194),USE(?Prompt83:2)
                             STRING(@s49),AT(145,194,196,10),USE(LOC:LastUpdatedBy)
                           END
                         END
                         TAB('Citations'),USE(?CitationsTab)
                           GROUP('Descriptions of this Party if acting as a Defendant/Plaintiff'),AT(96,27,443,113),USE(?CitationsGroup),BOXED
                             PROMPT('&Defendant:'),AT(105,43),USE(?Prompt33)
                             TEXT,AT(149,43,372,30),USE(PL:DefCitation),VSCROLL,FONT('MS Sans Serif',,,),TIP('The legal description of the defendant as cited on the summons<13,10>PL:DefCitation'),ALRT(CtrlUp),ALRT(CtrlDown)
                             BUTTON,AT(525,43,10,10),USE(?LookupLibraryButton:9),SKIP,TIP('Lookup and insert text from the Lookup Library (Ctrl L)'),KEY(CtrlL),ICON('Lookup.ico')
                             PROMPT('&Plaintiff:'),AT(105,83),USE(?Prompt34)
                             TEXT,AT(149,83,372,30),USE(PL:PlaCitation),VSCROLL,FONT('MS Sans Serif',,,),TIP('The legal description of the Plaintiff as cited on the summons<13,10>PL:PlaCitation'),ALRT(CtrlUp),ALRT(CtrlDown)
                             BUTTON,AT(525,83,10,10),USE(?LookupLibraryButton:10),SKIP,TIP('Lookup and insert text from the Lookup Library (Ctrl L)'),KEY(CtrlL),ICON('Lookup.ico')
                             CHECK('The Physical Address is the Domicilium Address of this Party'),AT(149,123),USE(PAR:DomiciliumFlag),TIP('The Physical Address is the party''s domicilium (used to modify wording on the Summons)<13,10>PAR:DomiciliumFlag')
                           END
                         END
                         TAB('POA'),USE(?PAOTab)
                           GROUP('Power of Attorney Details'),AT(96,27,408,101),USE(?PowerOfAttorneyGroup),BOXED
                             CHECK('Signed in terms of a'),AT(109,43),USE(PL:GPAFlag),TIP('PL:GPAFlag')
                             COMBO(@s10),AT(189,43,60,10),USE(PL:GPAType),FONT('MS Sans Serif',,,),TIP('PL:GPAType'),DROP(10),FROM('General|#G|Special|#S')
                             PROMPT('Power Of Attorney:'),AT(257,43),USE(?PL:GPAType:Prompt)
                             PROMPT('Signed At:'),AT(109,59),USE(?PL:GPASignedAt:Prompt)
                             ENTRY(@s50),AT(189,59,307,10),USE(PL:GPASignedAt),IMM,FONT('MS Sans Serif',,,),TIP('PL:GPASignedAt'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('Signed In Favour Of:'),AT(109,75),USE(?PL:GPASignedBy:Prompt)
                             ENTRY(@s50),AT(189,75,307,10),USE(PL:GPASignedBy),IMM,FONT('MS Sans Serif',,,),TIP('PL:GPASignedBy'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('Signed On:'),AT(109,91),USE(?PL:GPASignedOn:Prompt)
                             ENTRY(@d17b),AT(189,91,60,10),USE(PL:GPASignedOn),RIGHT(1),FONT('MS Sans Serif',,,),TIP('PL:GPASignedOn')
                             PROMPT('GPA Number:'),AT(109,107),USE(?PL:GPANumber:Prompt)
                             ENTRY(@s50),AT(189,107,141,10),USE(PL:GPANumber),IMM,FONT('MS Sans Serif',,,),TIP('PL:GPANumber'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                           END
                         END
                         TAB('Relationships'),USE(?RelationshipsTab)
                           LIST,AT(100,28,333,175),USE(?List),IMM,MSG('Browsing Records'),FORMAT('125L(2)|M~This Party is a/the~@s49@125L(2)|M~of this Party~@s99@16L(2)|M~Default' &|
   ' Contact~@s4@'),FROM(Queue:Browse:2)
                           BUTTON('Link On DocFOx'),AT(447,76,51,10),USE(?DocFoxLink),HIDE
                           BUTTON('Unlink On DocFox'),AT(449,94,23,10),USE(?DocFoxUnlink),HIDE
                           BUTTON('&Insert'),AT(148,116,42,12),USE(?Insert:3),HIDE
                           BUTTON('&Change'),AT(190,116,42,12),USE(?Change:3),HIDE
                           BUTTON('&Delete'),AT(232,116,42,12),USE(?Delete:3),HIDE
                           BUTTON('Check DocFox Relationships'),AT(226,211,117,16),USE(?DocFoxRelationshipList),HIDE
                           BUTTON('  &Edit this Party''s Details'),AT(100,211,117,16),USE(?EditRelationshipPartyButton),LEFT,TIP('Edit this Party''s details'),ICON('id_cards.ico')
                         END
                         TAB('Notes'),USE(?Notes)
                           TEXT,AT(100,29,441,191),USE(PAR:Notes),VSCROLL,FONT('MS Sans Serif',,,),COLOR(0BDFFFFH),TIP('General notes about this Party<13,10>PAR:Notes'),ALRT(CtrlUp),ALRT(CtrlDown)
                         END
                         TAB('FICA Compliance'),USE(?FICATab)
                           CHECK('This party is exempt from FICA'),AT(105,23),USE(PAR:NoFICAFlag),TIP('This party will not be checked for FICA compliance')
                           GROUP,AT(93,15,451,212),USE(?FICAButtonGroup),TRN
                             STRING('The following Documents are required for this Party ('),AT(105,35,280,10),USE(?FICAString)
                             BUTTON('&Document Log'),AT(385,19,80,21),USE(?DocumentLogButton),LEFT,TIP('View The Document Log for this Party'),ICON('folder_document.ico')
                             BUTTON('FICA Compliant'),AT(469,19,72,21),USE(?FICACompliantButton),HIDE,LEFT,TIP('This Party is FICA compliant'),ICON('check.ico')
                             BUTTON('Not FICA Compliant'),AT(469,19,72,21),USE(?FICANotCompliantButton),HIDE,LEFT,TIP('This Party is not FICA compliant'),ICON('delete.ico')
                             BUTTON('Documents Requested'),AT(469,19,72,21),USE(?FICAPendingButton),HIDE,LEFT,ICON('Document_Warning.ico')
                             LIST,AT(105,47,430,66),USE(?List:7),IMM,HVSCROLL,MSG('Browsing Records'),FORMAT('12L|MI@n3@200L(2)|M~Document~@s250@58L(2)|M~Document Date~@d17b@55L(2)|M~Expires~@s19@996L(2)|M~Comments~@s249@/'),FROM(Queue:Browse:8)
                             BUTTON('&Change'),AT(269,75,42,12),USE(?Change:8),HIDE
                             STRING('Further instructions regarding FICA compliance:'),AT(105,119),USE(?ENT1:FicaComments:Prompt)
                             TEXT,AT(105,131,430,58),USE(ENT1:FicaComments),VSCROLL,TIP('Additional instructions regarding FICA for this Entity.<13,10>This may be included in' &|
   ' the Email/Document sent to the Party<13,10>ENT:FicaComments'),READONLY
                             GROUP('DocFox'),AT(105,193,428,31),USE(?GroupDocFox),BOXED
                               BUTTON('Send To DocFox'),AT(109,201,83,20),USE(?SendToDocFox),LEFT,ICON('docfox.ico')
                               BUTTON('Download Documents from DocFox'),AT(299,201,133,20),USE(?CheckDocFox),TIP('Check DocFox for uploaded Documents')
                               BUTTON('Request FICA Documents'),AT(109,201,121,20),USE(?InviteDocFox),TIP('Invite user to upload documents to DocFox')
                               BUTTON('Cancel Request for FICA Documents'),AT(109,201,187,20),USE(?RevokeDocFox),TIP('Revoke the user''s invitation to upload documents to DocFox')
                             END
                           END
                         END
                         TAB('Employer'),USE(?Employer)
                           GROUP('Employer'),AT(97,31,270,170),USE(?EmployerGroup:2),BOXED
                             PROMPT('&Name:'),AT(105,44),USE(?PAR:EmployerName:Prompt)
                             ENTRY(@s99),AT(169,44,166,10),USE(PAR:EmployerName),FONT('MS Sans Serif',,,),TIP('The name of the Employer<13,10>PAR:EmployerName')
                             PROMPT('&Contact Person:'),AT(105,60),USE(?PAR:EmployerContact:Prompt)
                             ENTRY(@s100),AT(169,60,166,10),USE(PAR:EmployerContact),FONT('MS Sans Serif',,,),TIP('The name of the Employer''s contact person<13,10>PAR:EmployerContact')
                             PROMPT('&Postal Address:'),AT(105,76),USE(?PAR:EmployerPostal:Prompt)
                             TEXT,AT(169,76,121,38),USE(PAR:EmployerPostal),FONT('MS Sans Serif',,,),TIP('Postal address of the Employer<13,10>PAR:EmployerPostal')
                             PROMPT('P&hysical Address:'),AT(105,119),USE(?PAR:EmployerPhysical:Prompt)
                             ENTRY(@s99),AT(169,119,166,10),USE(PAR:EmployerPhysical),FONT('MS Sans Serif',,,),TIP('The physical address of the Employer<13,10>PAR:EmployerPhysical')
                             PROMPT('Ph&one No:'),AT(105,135),USE(?PAR:EmployerPhone:Prompt)
                             ENTRY(@s19),AT(169,135,121,10),USE(PAR:EmployerPhone),FONT('MS Sans Serif',,,),TIP('The phone number of the Employer<13,10>PAR:EmployerPhone')
                             PROMPT('&Fax No:'),AT(105,151),USE(?PAR:EmployerFax:Prompt)
                             ENTRY(@s19),AT(169,151,121,10),USE(PAR:EmployerFax),FONT('MS Sans Serif',,,),TIP('The Fax number of the Employer<13,10>PAR:EmployerFax')
                             PROMPT('&Email Address:'),AT(105,167),USE(?PAR:EmployerEmail:Prompt)
                             ENTRY(@s255),AT(169,167,121,10),USE(PAR:EmployerEmail),FONT('MS Sans Serif',,,),TIP('The email address of the Employer<13,10>PAR:EmployerEmail')
                             BUTTON('&Create a Party'),AT(293,184,71,13),USE(?CreateEmployerPartyButton),LEFT,TIP('Create a new Party in the Address Book for the Employer'),ICON(ICON:Copy)
                           END
                         END
                         TAB('Deceased Party'),USE(?DeceasedTab)
                           PROMPT('&Title:'),AT(102,38),USE(?LOC:PL2:Title:Prompt)
                           ENTRY(@s20),AT(174,38,79,10),USE(LOC:PL2:Title),IMM,FONT('MS Sans Serif',,,),TIP('Client''s title - e.g. Mr, Mrs, Ms<13,10>PL:Title'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),OVR
                           PROMPT('&Last Name:'),AT(102,55),USE(?LOC:PAR2:LastName:Prompt)
                           ENTRY(@s49),AT(174,55,136,10),USE(LOC:PL2:Name),IMM,FONT('MS Sans Serif',,,),TIP('The last name of the spouse<13,10>PL:SpouseName'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                           PROMPT('&First Name(s):'),AT(102,72),USE(?LOC:PAR2:FirstNames:Prompt)
                           ENTRY(@s49),AT(174,72,136,10),USE(LOC:PL2:FirstName),IMM,FONT('MS Sans Serif',,,),TIP('The first names of the spouse<13,10>PL:SpouseFirstName'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                           PROMPT('Initial(s):'),AT(102,89),USE(?LOC:PL2:Initials:Prompt)
                           ENTRY(@s19),AT(174,89,93,10),USE(LOC:PL2:Initials),FONT('MS Sans Serif',,,)
                           BUTTON('&Unlink the Deceased Party'),AT(432,217,109,13),USE(?UnlinkDeceasedPartyButton),HIDE,LEFT,TIP('Create a new Party in the Address Book for the Deceased'),ICON(ICON:Copy)
                           PROMPT('&ID Number:'),AT(102,106),USE(?LOC:PAR2:IdentityNumber:Prompt)
                           ENTRY(@s39),AT(174,106,93,10),USE(LOC:PL2:IdentityNumber),IMM,FONT('MS Sans Serif',,,),TIP('The Identity Number of the Spouse<13,10>PL:SpouseIdentityNumber'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                           ENTRY(@d17),AT(273,106,51,10),USE(LOC:PL2:BirthDate),RIGHT(1),FONT('MS Sans Serif',,,),TIP('If the person does not have an ID you must specify the Date of Birth<13,10>PL:SpouseB' &|
   'irthDate')
                           PROMPT('&Registered Taxpayer:'),AT(102,123),USE(?Prompt5:2)
                           OPTION('Registered for Income Tax'),AT(174,119,69,18),USE(LOC:PAR2:TaxPayer),TIP('This Party is Registered for Income Tax<13,10>PAR:TaxPayer')
                             RADIO('Yes'),AT(174,121),USE(?LOC:PAR2:TaxPayer:Radio1),TIP('This Party is an SA taxpayer<13,10>PAR:TaxPayer = ''Y'''),VALUE('Y')
                             RADIO('No'),AT(210,121),USE(?LOC:PAR2:TaxPayer:Radio2),TIP('This Party is not an SA taxpayer<13,10>PAR:TaxPayer = ''N'''),VALUE('N')
                           END
                           PROMPT('Annual Income:'),AT(103,140),USE(?LOC:PAR2:AnnualIncome:Prompt)
                           ENTRY(@n15.2),AT(174,140,60,10),USE(LOC:PAR2:AnnualIncome),DECIMAL(12),FONT('MS Sans Serif',,,),TIP('The gross annual income of this Party<13,10>PAR:AnnualIncome')
                           PROMPT('SA Resident?'),AT(102,155),USE(?Prompt6:2)
                           OPTION('SA Resident'),AT(174,151,69,18),USE(LOC:PAR2:SAResident),TIP('This Party is a South African resident<13,10>PAR:SAResident')
                             RADIO('Yes'),AT(174,153),USE(?LOC:PAR:SAResident:Radio1:2),TIP('This Party is an SA resident<13,10>PAR:SAResident = ''Y'''),VALUE('Y')
                             RADIO('No'),AT(210,153),USE(?LOC:PAR:SAResident:Radio2:2),TIP('This Party is not an SA resident<13,10>PAR:SAResident = ''N'''),VALUE('N')
                           END
                           PROMPT('Country Of Residence:'),AT(101,174),USE(?LOC:PAR2:CountryOfResidence:Prompt)
                           ENTRY(@s49),AT(174,174,117,10),USE(LOC:PAR2:CountryOfResidence),FONT('MS Sans Serif',,,),TIP('The country where this Party is a resident<13,10>PAR:CountryOfResidence')
                           BUTTON('...'),AT(294,173,11,11),USE(?DeceasedCountryOfResidenceButton),SKIP,TIP('Lookup the Country')
                           PROMPT('Passport Number:'),AT(102,191),USE(?LOC:PAR2:PassportNumber:Prompt)
                           ENTRY(@s19),AT(174,191,60,10),USE(LOC:PAR2:PassportNumber),FONT('MS Sans Serif',,,),TIP('The Party''s passport number<13,10>PAR:PassportNumber')
                           PROMPT('&Vat Number:'),AT(102,208),USE(?LOC:PAR2:VatNumber:Prompt)
                           ENTRY(@s19),AT(174,208,115,10),USE(LOC:PAR2:VatNumber),IMM,FONT('MS Sans Serif',,,),TIP('Their VAT Registration Number<13,10>PAR:VatNumber')
                           PROMPT('&Tax Number:'),AT(103,140),USE(?LOC:PAR2:TaxNumber:Prompt)
                           ENTRY(@s50),AT(174,140,115,10),USE(LOC:PAR2:TaxNumber),IMM,FONT('MS Sans Serif',,,),TIP('The tax reference number<13,10>PAR:TaxNumber')
                           BUTTON('&Create a Party'),AT(470,217,71,13),USE(?CreateDeceasedPartyButton),LEFT,TIP('Create a new Party in the Address Book for the Deceased'),ICON(ICON:Copy)
                           BUTTON('&Select a Party'),AT(396,217,71,13),USE(?SelecteDeceasedPartyButton),LEFT,TIP('Select an existing Party from the Address Book for the Deceased'),ICON(ICON:Copy)
                         END
                       END
                       LIST,AT(4,4,78,100),USE(?TabTree),SKIP,VSCROLL,COLOR(08EFDFDH)
                       STRING('General'),AT(92,7),USE(?TabHeading),FONT('Arial',14,,,CHARSET:ANSI)
                       BUTTON('&OK'),AT(423,241,54,20),USE(?OK),LEFT,FONT(,11,,),ICON('check3.ico'),DEFAULT
                       BUTTON('&Cancel'),AT(481,241,60,20),USE(?Cancel),LEFT,FONT(,11,,),ICON('delete32.ico')
                       BUTTON('&Apply'),AT(357,241,58,20),USE(?ApplyButton),LEFT,FONT(,11,,),TIP('Save the Party''s details for this Language'),ICON('add1.ico')
                       BUTTON('Add a &screen'),AT(84,240,79,22),USE(?AddButton),SKIP,LEFT,TIP('Add an Extra Screen'),ICON('note.gif')
                       BUTTON('&Modify this screen'),AT(167,240,79,22),USE(?ModifyButton),SKIP,HIDE,LEFT,TIP('Change the format and layout of the fields for this screen'),ICON('defaults.ico')
                       BUTTON('&Remove this screen'),AT(250,240,79,22),USE(?DeleteButton),SKIP,HIDE,LEFT,TIP('Remove this Extra Screen (and its data) from this Party<13,10>Note: The Extra Screen ' &|
   'itself will NOT be deleted.'),ICON('docdel.ico')
                     END

PDSC:LOC:PL2:BirthDate CLASS(PDScrollCT)
TakeFieldEvent         PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDSC:PAR:DateResolutionSigned CLASS(PDScrollCT)
TakeFieldEvent         PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDSC:PAR:LastInstructedDate CLASS(PDScrollCT)
TakeFieldEvent         PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDSC:PAR:RemoteAccessExpiry CLASS(PDScrollCT)
TakeFieldEvent         PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDSC:PL:BirthDate    CLASS(PDScrollCT)
TakeFieldEvent         PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDSC:PL:GPASignedOn  CLASS(PDScrollCT)
TakeFieldEvent         PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDSC:PL:MarriageDate CLASS(PDScrollCT)
TakeFieldEvent         PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDSC:PL:SpouseBirthDate CLASS(PDScrollCT)
TakeFieldEvent         PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDSC:PL:TrustDate    CLASS(PDScrollCT)
TakeFieldEvent         PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDPC:LOC:PL2:BirthDate CLASS(PDPopCalBtnCT)
TakeAccepted           PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDPC:PAR:DateResolutionSigned CLASS(PDPopCalBtnCT)
TakeAccepted           PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDPC:PAR:LastInstructedDate CLASS(PDPopCalBtnCT)
TakeAccepted           PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDPC:PAR:RemoteAccessExpiry CLASS(PDPopCalBtnCT)
TakeAccepted           PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDPC:PL:BirthDate    CLASS(PDPopCalBtnCT)
TakeAccepted           PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDPC:PL:GPASignedOn  CLASS(PDPopCalBtnCT)
TakeAccepted           PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDPC:PL:MarriageDate CLASS(PDPopCalBtnCT)
TakeAccepted           PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDPC:PL:SpouseBirthDate CLASS(PDPopCalBtnCT)
TakeAccepted           PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDPC:PL:TrustDate    CLASS(PDPopCalBtnCT)
TakeAccepted           PROCEDURE,BYTE,PROC,VIRTUAL
                     END
ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
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
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END

FDB36                CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:7              !Reference to display queue
TakeNewSelection       PROCEDURE(),DERIVED
                     END

FDB9                 CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop                !Reference to display queue
TakeNewSelection       PROCEDURE(),DERIVED
ValidateRecord         PROCEDURE(),BYTE,DERIVED
                     END

FDB11                CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:1              !Reference to display queue
                     END

FDB37                CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:8              !Reference to display queue
                     END

FDB35                CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:6              !Reference to display queue
                     END

FDB39                CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:9              !Reference to display queue
                     END

FDB24                CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:3              !Reference to display queue
                     END

FDB25                CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:4              !Reference to display queue
                     END

BRW10                CLASS(BrowseClass)               !Browse using ?TelephoneList
Q                      &Queue:Browse                  !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
                     END

BRW14                CLASS(BrowseClass)               !Browse using ?SignatoriesList
Q                      &Queue:Browse:1                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
SetQueueRecord         PROCEDURE(),DERIVED
                     END

BRW14::Sort0:Locator StepLocatorClass                 !Default Locator
BRW31                CLASS(BrowseClass)               !Browse using ?List
Q                      &Queue:Browse:2                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
ResetQueue             PROCEDURE(BYTE ResetMode),DERIVED
SetQueueRecord         PROCEDURE(),DERIVED
                     END

BRW31::Sort0:Locator StepLocatorClass                 !Default Locator
BRW33                CLASS(BrowseClass)               !Browse using ?List:2
Q                      &Queue:Browse:3                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
SetQueueRecord         PROCEDURE(),DERIVED
                     END

BRW33::Sort0:Locator StepLocatorClass                 !Default Locator
BRW42                CLASS(BrowseClass)               !Browse using ?List:3
Q                      &Queue:Browse:4                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
                     END

BRW42::Sort0:Locator StepLocatorClass                 !Default Locator
BRW8                 CLASS(BrowseClass)               !Browse using ?List:4
Q                      &Queue:Browse:5                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
                     END

BRW8::Sort0:Locator  StepLocatorClass                 !Default Locator
BRW16                CLASS(BrowseClass)               !Browse using ?List:5
Q                      &Queue:Browse:6                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
                     END

BRW16::Sort0:Locator StepLocatorClass                 !Default Locator
BRW41                CLASS(BrowseClass)               !Browse using ?List:6
Q                      &Queue:Browse:7                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
                     END

BRW41::Sort0:Locator StepLocatorClass                 !Default Locator
BRW48                CLASS(BrowseClass)               !Browse using ?List:7
Q                      &Queue:Browse:8                !Reference to browse queue
ApplyFilter            PROCEDURE(),DERIVED
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
SetQueueRecord         PROCEDURE(),DERIVED
                     END

BRW48::Sort0:Locator StepLocatorClass                 !Default Locator
CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
                    END
            MAP
               SaveScreenData
            END



  CODE
  GlobalResponse = ThisWindow.Run()

SetDocFoxVisibility Routine
        ?GroupDocFox{PROP:Hide} = false
        CLEAR(ROW:Record)
        PropSqlNext('Select Entity.JuristicFlag,DocFoxID FROM Party INNER JOIN Entity ON Entity.RecordID = Party.EntityID WHERE PArty.RecordID = ' & PAR:RecordID)
        IF  ROW:Description
            ?SendToDocFox{PROP:Hide} = true
            ?CheckDocFox{PROP:Hide} = false
            if ROW:Counter
                ?DocFoxRelationshipList{PROP:Hide} = false
            else
                ?DocFoxRelationshipList{PROP:Hide} = true
            end
            PropSqlNext('Select COUNT(RecordID) FROM DocFoxTokenRequest WHERE PartyID = ' & PAR:RecordID & |
            ' AND ISNULL(Revoked,0) = 0 AND DATEADD(millisecond,ExpiresTime, DateAdd(day,ExpiresDate,''28 Dec 1800'')) > GetDate()')
            IF ROW:Counter
                ?InviteDocFox{PROP:Hide} = true
                ?RevokeDocFox{PROP:Hide} = false
                ?RevokeDocFox{PROP:XPos} = 109! ?CheckDocFox{PROP:XPos} + ?CheckDocFox{PROP:Width} + 5
                 ?CheckDocFox{PROP:XPos} =  ?RevokeDocFox{PROP:XPos} + ?RevokeDocFox{PROP:Width} + 5 !?SendToDocFox{PROP:XPos}
            ELSE
                ?RevokeDocFox{PROP:Hide} = true
                ?InviteDocFox{PROP:Hide} = false
                ?InviteDocFox{PROP:XPos} = 109 !?CheckDocFox{PROP:XPos} + ?CheckDocFox{PROP:Width} + 5
                ?CheckDocFox{PROP:XPos} =  ?InviteDocFox{PROP:XPos} + ?InviteDocFox{PROP:Width} + 5
            END
        ELSE
            ?SendToDocFox{PROP:Hide} = false
            ?CheckDocFox{PROP:Hide} = true
            ?InviteDocFox{PROP:Hide} = true
            ?RevokeDocFox{PROP:Hide} = true
            ?DocFoxRelationshipList{PROP:Hide} = true
        END
! ------------------------------------------------------------------------
RebuildSimtreeQueue                routine        !For backward compatibility from SimTabTree
  do RebuildTabTreeQueue:30
RebuildTabTreeQueue:30     routine
  ThisTabTree30.BuildQueue()

CheckLanguagesForDifferences        ROUTINE
      
      CLEAR(PL:Record)
      PL:LanguageID = PAR:DefaultLanguageID
      PL:PartyID = PAR:RecordID

      IF Access:ParLang.TryFetch(PL:PartyLanguageKey)
         MESSAGE('Unable to retrieve The Party''s details for the ' & GetDescription('LANGUAGE',PAR:DefaultLanguageID) & ' language',ERROR(),ICON:Exclamation)
         EXIT
      END
      Access:ParLangAlias.Open
      Access:ParLangAlias.UseFile
      CLEAR(PL1:Record)
      !Kelvin -11/10/2016 - changing this to use the ID's in the control table.
      IF PAR:DefaultLanguageID = CTL:EnglishID
         PL1:LanguageID = CTL:AfrikaansID
      ELSE
         PL1:LanguageID = CTL:EnglishID
      END
      PL1:PartyID = PAR:RecordID


      IF Access:ParLangAlias.TryFetch(PL1:PartyLanguageKey)
         IF Access:ParLangAlias.Insert() THEN EXIT.
      END

      IF Access:ParLangAlias.TryFetch(PL1:PartyLanguageKey)
         MESSAGE('Unable to retrieve the other Party''s details for the ' & GetDescription('LANGUAGE',PAR:DefaultLanguageID) & ' language',ERROR(),ICON:Exclamation)
         EXIT
      END

      IF PAR:EntityID < 2        ! IF AN ADULT
         PL1:Name = PL:Name
      END

      PL1:FirstName              = PL:FirstName
      PL1:Initials               = PL:Initials
      PL1:IdentityNumber         = PL:IdentityNumber
      PL1:BirthDate              = PL:BirthDate
      PL1:SpouseName             = PL:SpouseName
      PL1:SpouseFirstName        = PL:SpouseFirstName
      PL1:SpouseInitials         = PL:SpouseInitials
      PL1:SpouseIdentityNumber   = PL:SpouseIdentityNumber
      PL1:MarriageDate           = PL:MarriageDate
      PL1:SpouseBirthDate        = PL:SpouseBirthDate
      PL1:AssistedFlag           = PL:AssistedFlag
      PL1:SpouseEmailAddress     = PL:SpouseEmailAddress
      PL1:SpouseMobile           = PL:SpouseMobile
      PL1:SpouseIdentityDocumentType = PL1:SpouseIdentityDocumentType
      !FB 2681 - uncommenting the below becuse it's needed
      !pk here
      IF Access:ParLangAlias.Update()
         MESSAGE('The Party''s details were not copied to the other Language',ERROR(),ICON:Exclamation)
      END
      !FB 2681 END

      Access:ParLangAlias.Close


CheckOtherLanguageMaritalStatus ROUTINE
 LOC:CheckMarDesc = 0
 IF SAVED:MaritalStatus <> PAR:MaritalStatus
    SAVED:MaritalStatus = PAR:MaritalStatus
    IF PAR:DefaultLanguageID = CTL:AfrikaansID
        LOC:LanguageName = 'english'
        LOC:MarDesc = GetMaritalDescription(CTL:EnglishID)
    ELSE
        LOC:LanguageName = 'afrikaans'
        LOC:MarDesc = GetMaritalDescription(CTL:AfrikaansID)
    END
    !CASE MESSAGE('The marital description for ' &LOC:LanguageName&' will be set to ''' & LOC:MarDesc  & '''.' ,'Marital description - ' & LOC:LanguageName,ICON:Question,'&OK|&IGNORE',BUTTON:OK)
        !OF BUTTON:OK
            Access:ParLangAlias.Open
            Access:ParLangAlias.UseFile
            CLEAR(PL1:Record)
            IF PAR:DefaultLanguageID = CTL:EnglishID
                PL1:LanguageID = CTL:AfrikaansID
            ELSE
                PL1:LanguageID = CTL:EnglishID
            END
            PL1:PartyID = PAR:RecordID
            IF Access:ParLangAlias.TryFetch(PL1:PartyLanguageKey)
                MESSAGE('The Party''s details were not found for ' & LOC:LanguageName ,ERROR(),ICON:Exclamation)
            ELSE
                PL1:MaritalDescription = LOC:MarDesc
                IF Access:ParLangAlias.Update()
                    MESSAGE('The Party''s details were not copied to ' & LOC:LanguageName ,ERROR(),ICON:Exclamation)
                END
            END
        !ELSE
        !    MESSAGE('Please don''t forget to edit the marital description in ' & LOC:LanguageName)
    !END
 END
BuildScreenQueue ROUTINE


  ! ADD ANY AUTOMATIC EXTRA SCREENS
  CLEAR(DS:Record)
  SET(DS:PrimaryKey,DS:PrimaryKey)
  LOOP UNTIL Access:DocScrn.Next()
  
      IF ~DS:TrueCondition THEN CYCLE.

      IF ~DS:ScreenType = 'P' THEN CYCLE.    

      IF EVALUATE(DS:TrueCondition) = '0' THEN CYCLE.

      CLEAR(PEF:Record)
      PEF:PartyID = PAR:RecordID
      PEF:DocScreenID = DS:RecordID
      IF Access:ParField.TryFetch(PEF:PrimaryKey)
         PEF:PartyID = PAR:RecordID
         PEF:DocScreenID = DS:RecordID
         Access:ParField.Insert
      END
  
  END




  CLEAR(PEF:Record)
  PEF:PartyID = PAR:RecordID
  SET(PEF:PrimaryKey,PEF:PrimaryKey)
  LOOP UNTIL Access:ParField.Next()
       IF ~(PEF:PartyID = PAR:RecordID) THEN BREAK.
       LOC:ScreenCounter += 1


       CLEAR(DS:Record)
       DS:RecordID = PEF:DocScreenID
       IF Access:DocScrn.Fetch(DS:PrimaryKey) THEN CYCLE.

       IF DS:ScreenType <> 'P' THEN CYCLE.


       SCRQ:DocScrnID = DS:RecordID
       SCRQ:ScreenTitle = DS:ScreenTitle

       ADD(ScreenQueue,+SCRQ:ScreenTitle)   ! DOING THIS TO SORT THE TABS ALPHABETICALLY

       IF GLO:DefaultPartyExtraScreenID = DS:RecordID 
          LOC:DisplayThisScreenID  = DS:RecordID
       END

  END




  IF GLO:DefaultPartyExtraScreenID AND ~LOC:DisplayThisScreenID  ! IF THE DEFAULT SCREEN IS NOT ALREADY LINKED TO THIS MATTER


      CLEAR(DS:Record)
      DS:RecordID = GLO:DefaultPartyExtraScreenID 
      IF ~Access:DocScrn.Fetch(DS:PrimaryKey)

          IF DS:ScreenType = 'R'

             CLEAR(PEF:Record)
             PEF:PartyID = PAR:RecordID
             PEF:DocScreenID = GLO:DefaultPartyExtraScreenID
             IF Access:ParField.TryFetch(PEF:PrimaryKey)
                PEF:PartyID = PAR:RecordID
                PEF:DocScreenID = GLO:DefaultPartyExtraScreenID
                IF ~Access:ParField.Insert()
                    LOC:DisplayThisScreenID  = GLO:DefaultPartyExtraScreenID
                END
             ELSE
                LOC:DisplayThisScreenID  = GLO:DefaultPartyExtraScreenID
             END
             IF LOC:DisplayThisScreenID
                SCRQ:DocScrnID = DS:RecordID
                SCRQ:ScreenTitle = DS:ScreenTitle
                ADD(ScreenQueue,+SCRQ:ScreenTitle)
             END
          END
      END
  END


  LOC:DisplayThisScreenID = 0   ! DON'T JUMP TO A PARTICULAR SCREEN - ONLY USED BY MERGING DOCUMENTS

  INCLUDE('UpdateMatterExtraScreenSource','Routines')

SaveDeceasedParty ROUTINE
    IF (PAR2:RecordID < 1)
        IF Access:PartyAlias2.Insert()  THEN EXIT .
    END
         CLEAR(PL2:Record)
         PL2:LanguageID = PAR:DefaultLanguageID
         PL2:PartyID = PAR2:RecordID
      IF Access:ParLangAlias2.TryFetch(PL2:PartyLanguageKey)
         IF Access:ParLangAlias2.Insert() THEN EXIT.
      END
    
    PL2:Title = LOC:PL2:Title
    PL2:Name = LOC:PL2:Name
    PL2:FirstName = LOC:PL2:FirstName
    IF LOC:PL2:FirstName THEN LOC:PL2:Initials = CreateInitials(LOC:PL2:FirstName).
    LOC:PAR2:Name = LEFT(LOC:PL2:Name & ' ' & LOC:PL2:Initials)
    LOC:PAR2:Name = LOC:PAR2:Name & ' (' & LOC:PL2:FirstName & ')'
    PL2:Initials = LOC:PL2:Initials
    PL2:IdentityNumber = LOC:PL2:IdentityNumber
    PL2:BirthDate = LOC:PL2:BirthDate
    PAR2:TaxPayer = LOC:PAR2:TaxPayer
    PAR2:AnnualIncome = LOC:PAR2:AnnualIncome
    PAR2:SAResident = LOC:PAR2:SAResident
    PAR2:CountryOfResidence = LOC:PAR2:CountryOfResidence
    PAR2:PassportNumber = LOC:PAR2:PassportNumber
    PAR2:VatNumber = LOC:PAR2:VatNumber
    PAR2:TaxNumber = LOC:PAR2:TaxNumber
    PAR2:PhysicalCountryID = LOC:PAR2:PhysicalCountryID
    PAR2:Name = LOC:PAR2:Name
    if ~PAR2:MatterPrefix
        PAR2:MatterPrefix = GetMatterPrefix(PL2:Name)
    end
    PAR2:DefaultLanguageID = PAR:DefaultLanguageID
    Access:ParLangAlias2.Update()
    Access:PartyAlias2.Update()
    
CheckAndLoadDeceasedParty ROUTINE
    CLEAR(PL2:Record)
    CLEAR(PAR2:Record)
    PropSQLNext('Select top 1 ParRel.OtherPartyId from ParRel INNER JOIN Relationship ON Relationship.Description = ''Deceased Estate'' AND Relationship.RecordID = ParRel.RelationshipID WHERE ParRel.PartyID =' & PAR:RecordID)
    IF ROW:Counter > 0
        RecordID# = ROW:Counter
        PropSQLNext('Select top 1 RecordID from Party WHERE RecordID = ' & RecordID#)
        IF (ROW:Counter > 0)
            HIDE(?CreateDeceasedPartyButton)
            HIDE(?SelecteDeceasedPartyButton)
            UNHIDE(?UnlinkDeceasedPartyButton)
            PAR2:RecordID = ROW:Counter
            IF Access:PartyAlias2.TryFetch(PAR2:PrimaryKey)
                IF Access:PartyAlias2.Insert() THEN EXIT.
            END
        PL2:LanguageID = PAR:DefaultLanguageID
        PL2:PartyID = ROW:Counter
        IF Access:ParLangAlias2.TryFetch(PL2:PartyLanguageKey)
            IF Access:ParLangAlias2.Insert() THEN EXIT.
        END
        LOC:PL2:Title = PL2:Title
        LOC:PL2:Name = PL2:Name
        LOC:PL2:FirstName = PL2:FirstName
        LOC:PL2:Initials = PL2:Initials
        LOC:PL2:IdentityNumber = PL2:IdentityNumber
        LOC:PL2:BirthDate = PL2:BirthDate
        LOC:PAR2:TaxPayer = PAR2:TaxPayer
        LOC:PAR2:AnnualIncome = PAR2:AnnualIncome
        LOC:PAR2:SAResident = PAR2:SAResident
        LOC:PAR2:CountryOfResidence = PAR2:CountryOfResidence
        LOC:PAR2:PassportNumber = PAR2:PassportNumber
        LOC:PAR2:VatNumber = PAR2:VatNumber
        LOC:PAR2:TaxNumber = PAR2:TaxNumber
        LOC:PAR2:PhysicalCountryID = PAR2:PhysicalCountryID
        ELSE
            PropSQLNext('Delete FROM ParRel WHERE OtherPartyID = ' & RecordID#)
            ROW:Counter = 0
        END
    END
    IF ~ROW:Counter
        LOC:PL2:Title = 'Mr'
        UNHIDE(?CreateDeceasedPartyButton)
        UNHIDE(?SelecteDeceasedPartyButton)
        HIDE(?UnlinkDeceasedPartyButton)
    END
    IF ~LOC:PAR2:TaxPayer
        LOC:PAR2:TaxPayer = 'Y'
    END
    IF ~LOC:PAR2:SAResident
        LOC:PAR2:SAResident = 'Y'
    END

CheckAndLoadSpouseParty ROUTINE !FB 3258
    HIDE(?EditSpousePartyButton:2)
    CLEAR(PL2:Record)
    CLEAR(PAR2:Record)
    IF PAR:EntityID < 3 OR ENT1:Category = 1
        IF PAR:MaritalStatus AND ~(PAR:MaritalStatus = 'UNM')
            PropSQLNext('Select top 1 ParRel.OtherPartyId from ParRel WHERE ParRel.RelationshipID = 1 AND ParRel.PartyID =' & PAR:RecordID)
            IF ROW:Counter > 0
                RecordID# = ROW:Counter
                PropSQLNext('Select top 1 RecordID from Party WHERE RecordID = ' & RecordID#)
                IF (ROW:Counter > 0)
                    HIDE(?CreatePartyButton)
                    HIDE(?SelecteSpousePartyButton)
                    UNHIDE(?EditSpousePartyButton)
                    PAR2:RecordID = ROW:Counter
                    IF Access:PartyAlias2.TryFetch(PAR2:PrimaryKey)
                        IF Access:PartyAlias2.Insert() THEN EXIT.
                    END
                PL2:LanguageID = PAR:DefaultLanguageID
                PL2:PartyID = ROW:Counter
                IF Access:ParLangAlias2.TryFetch(PL2:PartyLanguageKey)
                    IF Access:ParLangAlias2.Insert() THEN EXIT.
                END
                PL:SpouseName = PL2:Name
                PL:SpouseFirstName = PL2:FirstName
                PL:SpouseInitials = PL2:Initials
                PL:SpouseIdentityNumber = PL2:IdentityNumber
                PL:SpouseBirthDate = PL2:BirthDate
                ?PL:SpouseName{PROP:ReadOnly} = True
                ?PL:SpouseName{PROP:BackGround} = COLOR:Silver
                ?PL:SpouseFirstName{PROP:ReadOnly} = True
                ?PL:SpouseFirstName{PROP:BackGround} = COLOR:Silver
                ?PL:SpouseInitials{PROP:ReadOnly} = True
                ?PL:SpouseInitials{PROP:BackGround} = COLOR:Silver
                ?PL:SpouseIdentityNumber{PROP:ReadOnly} = True
                ?PL:SpouseIdentityNumber{PROP:BackGround} = COLOR:Silver
                ?PL:SpouseBirthDate{PROP:ReadOnly} = True
                ?PL:SpouseBirthDate{PROP:BackGround} = COLOR:Silver
                PAR:SpouseTaxPayer = PAR2:TaxPayer
                ?PAR:SpouseTaxPayer:Radio2{PROP:Enabled} = False
                ?PAR:SpouseTaxPayer:Radio1{PROP:Enabled} = False
                PAR:SpouseAnnualIncome = PAR2:AnnualIncome
                ?PAR:SpouseAnnualIncome{PROP:ReadOnly} = True
                ?PAR:SpouseAnnualIncome{PROP:BackGround} = COLOR:Silver
                PAR:SpouseSAResident = PAR2:SAResident
                ?PAR:SpouseTaxPayer:Radio2{PROP:Enabled} = False
                ?PAR:SpouseTaxPayer:Radio1{PROP:Enabled} = False
                PAR:SpouseCountryOfResidence = PAR2:CountryOfResidence
                ?PAR:SpouseCountryOfResidence{PROP:ReadOnly} = True
                ?PAR:SpouseCountryOfResidence{PROP:BackGround} = COLOR:Silver
                PAR:SpousePassportNumber = PAR2:PassportNumber
                ?PAR:SpousePassportNumber{PROP:ReadOnly} = True
                ?PAR:SpousePassportNumber{PROP:BackGround} = COLOR:Silver
                IF ~PAR:MaritalStatus OR  Inlist(PAR:MaritalStatus,'UNM','OUT','CUO','FOR') !as per FB 1088 this is now hidden for CUO and FOR as well  !FB 3064 catering for blank status
                    HIDE(?SpouseTaxGroup)
                    HIDE(?EditSpousePartyButton:2)
                    ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = True
                    ?PAR:SpouseTaxNumber{PROP:Hide} = True
                ELSE
                    UNHIDE(?SpouseTaxGroup)
                    UNHIDE(?EditSpousePartyButton:2)
                    ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = False
                    ?PAR:SpouseTaxNumber{PROP:Hide} = False
                END



        !        LOC:PAR2:TaxPayer = PAR2:TaxPayer
        !        LOC:PAR2:AnnualIncome = PAR2:AnnualIncome
        !        LOC:PAR2:SAResident = PAR2:SAResident
        !        LOC:PAR2:CountryOfResidence = PAR2:CountryOfResidence
        !        LOC:PAR2:PassportNumber = PAR2:PassportNumber
        !        LOC:PAR2:VatNumber = PAR2:VatNumber
        !        LOC:PAR2:TaxNumber = PAR2:TaxNumber
        !        LOC:PAR2:PhysicalCountryID = PAR2:PhysicalCountryID
                ELSE
                    PropSQLNext('Delete FROM ParRel WHERE OtherPartyID = ' & RecordID#)
                    ROW:Counter = 0
                END
         END
            IF ~ROW:Counter
                LOC:PL2:Title = 'Mr'
                UNHIDE(?CreatePartyButton)
                UNHIDE(?SelecteSpousePartyButton)
                HIDE(?EditSpousePartyButton)
                HIDE(?EditSpousePartyButton:2)
                ?PL:SpouseName{PROP:ReadOnly} = False
                ?PL:SpouseName{PROP:BackGround} = COLOR:None
                ?PL:SpouseFirstName{PROP:ReadOnly} = False
                ?PL:SpouseFirstName{PROP:BackGround} = COLOR:None
                ?PL:SpouseInitials{PROP:ReadOnly} = False
                ?PL:SpouseInitials{PROP:BackGround} = COLOR:None
                ?PL:SpouseIdentityNumber{PROP:ReadOnly} = False
                ?PL:SpouseIdentityNumber{PROP:BackGround} = COLOR:None
                ?PL:SpouseBirthDate{PROP:ReadOnly} = False
                ?PL:SpouseBirthDate{PROP:BackGround} = COLOR:None
                ?PAR:SpouseTaxPayer:Radio2{PROP:Enabled} = False
                ?PAR:SpouseTaxPayer:Radio1{PROP:Enabled} = False
                ?PAR:SpouseAnnualIncome{PROP:ReadOnly} = False
                ?PAR:SpouseAnnualIncome{PROP:BackGround} = COLOR:None
                ?PAR:SpouseTaxPayer:Radio2{PROP:Enabled} = False
                ?PAR:SpouseTaxPayer:Radio1{PROP:Enabled} = False
                ?PAR:SpouseCountryOfResidence{PROP:ReadOnly} = False
                ?PAR:SpouseCountryOfResidence{PROP:BackGround} = COLOR:None
                ?PAR:SpousePassportNumber{PROP:ReadOnly} = False
                ?PAR:SpousePassportNumber{PROP:BackGround} = COLOR:None
            END

    END
    IF ~PAR:MaritalStatus OR  Inlist(PAR:MaritalStatus,'UNM','OUT','CUO','FOR') !as per FB 1088 this is now hidden for CUO and FOR as well  !FB 3064 catering for blank status
        HIDE(?SpouseTaxGroup)
        ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = True
        ?PAR:SpouseTaxNumber{PROP:Hide} = True
    ELSE
        UNHIDE(?SpouseTaxGroup)
        !UNHIDE(?EditSpousePartyButton:2)
        ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = False
        ?PAR:SpouseTaxNumber{PROP:Hide} = False
    END
 ELSE
     ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = True
     ?PAR:SpouseTaxNumber{PROP:Hide} = True
 END

CreateSpouseParty ROUTINE
    ThisWindow.Update

            IF ~PL:SpouseName
                MESSAGE('You must enter the Spouse''s details first.|','Incomplete data',ICON:Exclamation)
            ELSE

                IF PL:SpouseIdentityNumber
                    GLO:RecordID = CheckForDuplicateAddress(PL:SpouseIdentityNumber,2)
                
                
                END
                IF ~GLO:RecordID
                    GLO:RecordID = CheckForDuplicateAddress(PL:SpouseName,1)
                END

                IF GLO:RecordID
                   PROPSQLNext('INSERT ParRel (PartyID,OtherPartyID,RelationshipID) VALUES (' & PAR:RecordID & ',' & GLO:RecordID & ',1)')
                   PROPSQLNext('INSERT ParRel (PartyID,OtherPartyID,RelationshipID) VALUES (' & GLO:RecordID & ',' & PAR:RecordID & ',1)')
                   HIDE(?CreatePartyButton)
                   !FB 3258
!                   IF PAR:EntityID < 3 OR ENT1:Category = 1
!                    IF ~Inlist(PAR:MaritalStatus,'UNM','OUT','CUO','FOR') !as per FB 1088 this is now hidden for CUO and FOR as well
!                        UNHIDE(?UpdateSpouseTaxDetailsButton)
!                    END
!                   END
!FB 3258 END
                   GLO:RecordID = 0
                   ELSE        
                

                    LOC:SpouseMatterPrefix = GetMatterPrefix(PL:SpouseName)
              
                    IF PL:SpouseFirstName THEN LOC:SpouseInitials = CreateInitials(PL:SpouseFirstName).
              
                    LOC:SpousePartyName = LEFT(PL:SpouseName & ' ' & LOC:SpouseInitials)
              
                    LOC:SpousePartyName = LOC:SpousePartyName & ' (' & PL:SpouseFirstName & ')'
              
                    IF PAR:PartyTypeID = 1
                       LOC:SpousePartyTypeID = 2
                    ELSE
                       LOC:SpousePartyTypeID = 1
                    END
              
                    CLEAR(ROW:Record)
                    RowCounter{PROP:SQL} = 'SELECT MAX(RecordID) FROM Party'
                    NEXT(RowCounter)
                    LOC:SpousePartyID = ROW:Counter + 1

                    LOC:SpouseSQLScript = 'INSERT Party' &|
                                    ' (RecordID,MatterPrefix,Name,MaritalStatus,BirthMonth,BirthDay,IdentityNumber,' &|
                                    ' TaxPayer,TaxNumber,AnnualIncome,SAResident,CountryOfResidence,PassportNumber, ' &|
                                    ' InactiveFlag,DefaultRoleID,EntityID,PartyTypeID,DefaultLanguageID,PhysicalCountryID,PostalCountryID,DomiciliumFlag) ' &|
                                    ' VALUES (' &|
                                    LOC:SpousePartyID & ',' &|
                                    '''' & LOC:SpouseMatterPrefix & ''',' &|
                                    '''' & StripSQL(LOC:SpousePartyName) & ''',' &|
                                    '''' & PAR:MaritalStatus & ''',' &|
                                       '0,' &|
                                       '0,' &|
                                    '''' & StripSQL(PL:SpouseIdentityNumber) & ''',' &|
                                    '''' & StripSQL(PAR:SpouseTaxPayer) & ''',' &|
                                    '''' & StripSQL(PAR:SpouseTaxNumber) & ''',' &|
                                    PAR:SpouseAnnualIncome & ',' &|
                                    '''' & StripSQL(PAR:SpouseSAResident) & ''',' &|
                                    '''' & StripSQL(PAR:SpouseCountryOfResidence) & ''',' &|
                                    '''' & StripSQL(PAR:SpousePassportNumber) & ''',' &|
                                    '0,' &|
                                    PAR:DefaultRoleID & ',' &|
                                    PAR:EntityID & ',' &|
                                    LOC:SpousePartyTypeID & ',' &|
                                    PAR:DefaultLanguageID & ',1,1,1)'
                    
              
                    PROPSQL(LOC:SpouseSQLScript)
                    CLEAR(ROW:Record)
                    RowCounter{PROP:SQL} = 'SELECT COUNT(1) FROM PARTY WHERE RecordID = ' & LOC:SpousePartyID
                    NEXT(RowCounter)
                    IF ~ROW:Counter
                        SETCLIPBOARD(LOC:SpouseSQLScript)
                        MESSAGE('An error was encountered adding the Party to the Address Book from the Marital Details tab.Technical Support: Check CB','Error adding Party',ICON:Hand)                        
                    ELSE

                        LOC:GoAhead = 0
                        OPEN(SpouseContactDetailsScreen)
                        SELECT(?LOC:SpouseWork)
                        DISPLAY
                        ACCEPT
                           CASE ACCEPTED()
                           OF ?SpouseOKButton
                             LOC:GoAhead = 1
                             BREAK
                           OF ?SpouseCancelButton
                             BREAK
                           END
                        END

                       CLOSE(SpouseContactDetailsScreen)

                       IF LOC:GoAhead

                          IF LOC:SpouseWork THEN AddParTele(LOC:SpousePartyID,CTL:WorkPhoneID,LOC:SpouseWork).
                          IF LOC:SpouseHome THEN AddParTele(LOC:SpousePartyID,CTL:HomePhoneID,LOC:SpouseHome).
                          IF LOC:SpouseCell THEN AddParTele(LOC:SpousePartyID,CTL:CellPhoneID,LOC:SpouseCell).
                          IF LOC:SpouseEmail THEN AddParTele(LOC:SpousePartyID,CTL:EmailPhoneID,LOC:SpouseEmail).
                          IF LOC:SpouseFax THEN AddParTele(LOC:SpousePartyID,CTL:FaxPhoneID,LOC:SpouseFax).

                       END

              
              
                       IF LOC:SpousePartyTypeID = 1
                          IF PAR:DefaultLanguageID = CTL:AfrikaansID
                             LOC:SpouseTitle = 'Mnr'
                             LOC:SpouseSalutation = 'Geagte ' & LOC:SpouseTitle & ' ' & LOC:Name
                          ELSE
                             LOC:SpouseTitle = 'Mr'
                             LOC:SpouseSalutation = 'Dear ' & LOC:SpouseTitle & ' ' & LOC:Name
                          END
                       ELSIF LOC:SpousePartyTypeID = 2
                          IF PAR:DefaultLanguageID = CTL:AfrikaansID
                             LOC:SpouseTitle = 'Mev'
                             LOC:SpouseSalutation = 'Geagte ' & LOC:SpouseTitle & ' ' & LOC:Name
                          ELSE
                             LOC:SpouseTitle = 'Ms'
                             LOC:SpouseSalutation = 'Dear ' & LOC:SpouseTitle & ' ' & LOC:Name
                          END
                       ELSE
                          IF PAR:DefaultLanguageID = CTL:AfrikaansID
                             LOC:SpouseSalutation = 'Geagte Menere'
                          ELSE
                             LOC:SpouseSalutation = 'Dear Sirs'
                          END
                       END

              
                       CLEAR(ROW:Record)
                       RowCounter{PROP:SQL} = 'SELECT MAX(RecordID) FROM ParLang'
                       NEXT(RowCounter)
                       LOC:SpouseParLangID = ROW:Counter + 1


                       LOC:SpouseLanguageID =  PAR:DefaultLanguageID
              
              
                       LOC:SpouseSQLScript = 'INSERT ParLang' &|
                                       ' (RecordID,PartyID,LanguageID,BirthDate,Initials,Salutation,Title,Name,FirstName,IdentityNumber,PhysicalLine1,PhysicalLine2,PhysicalLine3,PhysicalCode,PostalLine1,PostalLine2,PostalLine3,PostalCode,PlaCitation,DefCitation, ' &|
                                       ' MarriageDate,MarriagePlace,DomiciledIn,MaritalDescription,AssistedFlag,ANCNumber,DeedsRegistry,MarriageCountry, ' &|
                                       ' SpouseName, SpouseFirstName,SpouseIdentityNumber,SpouseBirthDate) ' &|
                                       ' VALUES (' &|
                                       LOC:SpouseParLangID & ',' &|
                                       LOC:SpousePartyID & ',' &|
                                       LOC:SpouseLanguageID & ',' &|
                                       PL:SpouseBirthDate & ',' &|
                                       '''' & StripSQL(LOC:SpouseInitials) & ''',' &|
                                       '''' & StripSQL(LOC:SpouseSalutation) & ''',' &|
                                       '''' & LOC:SpouseTitle & ''',' &|
                                       '''' & StripSQL(PL:SpouseName) & ''',' &|
                                       '''' & StripSQL(PL:SpouseFirstName) & ''',' &|
                                       '''' & StripSQL(PL:SpouseIdentityNumber) & ''',' &|
                                       '''' & StripSQL(PL:PhysicalLine1) & ''',' &|
                                       '''' & StripSQL(PL:PhysicalLine2) & ''',' &|
                                       '''' & StripSQL(PL:PhysicalLine3) & ''',' &|
                                       '''' & StripSQL(PL:PhysicalCode) & ''',' &|
                                       '''' & StripSQL(PL:PostalLine1) & ''',' &|
                                       '''' & StripSQL(PL:PostalLine2) & ''',' &|
                                       '''' & StripSQL(PL:PostalLine3) & ''',' &|
                                       '''' & StripSQL(PL:PostalCode) & ''',' &|
                                       '''' & StripSQL(PL:PlaCitation) & ''',' &|
                                       '''' & StripSQL(PL:DefCitation) & ''',' &|
                                       PL:MarriageDate & ',' &|
                                       '''' & StripSQL(PL:MarriagePlace) & ''',' &|
                                       '''' & StripSQL(PL:DomiciledIn) & ''',' &|
                                       '''' & StripSQL(PL:MaritalDescription) & ''',' &|
                                       PL:AssistedFlag & ',' &|
                                       '''' & StripSQL(PL:ANCNumber) & ''',' &|
                                       '''' & StripSQL(PL:DeedsRegistry) & ''',' &|
                                       '''' & StripSQL(PL:MarriageCountry) & ''',' &|
                                       '''' & StripSQL(PL:SpouseName) & ''',' &|
                                       '''' & StripSQL(PL:FirstName) & ''',' &|
                                       '''' & StripSQL(PL:IdentityNumber) & ''',' &|
                                       PL:BirthDate & ')'
              
              
              
                       PROPSQL(LOC:SpouseSQLScript)
                       PROPSQLNext('SELECT COUNT(1) FROM ParLang WHERE RecordID = ' & LOC:SpouseParLangID)
                       IF ~ROW:Counter
                           SETCLIPBOARD(LOC:SpouseSQLScript)
                           MESSAGE('An error was encountered adding the Party Language (' & LOC:SpousePartyID & ') to the List of Parties from the Quick Insert screen.||Technical Support: Check CB','Error adding Party',ICON:Hand)                            
                       ELSE
                          IF LOC:SpouseLanguageID = 1 THEN LOC:SpouseLanguageID = 2 ELSE LOC:SpouseLanguageID = 1.
                          LOC:SpouseParLangID += 1

                          LOC:SpouseSQLScript = 'INSERT ParLang' &|
                                       ' (RecordID,PartyID,LanguageID,BirthDate,Initials,Salutation,Title,Name,FirstName,IdentityNumber,PhysicalLine1,PhysicalLine2,PhysicalLine3,PhysicalCode,PostalLine1,PostalLine2,PostalLine3,PostalCode,PlaCitation,DefCitation, ' &|
                                       ' MarriageDate,MarriagePlace,DomiciledIn,MaritalDescription,AssistedFlag,ANCNumber,DeedsRegistry,MarriageCountry, ' &|
                                       ' SpouseName, SpouseFirstName,SpouseIdentityNumber,SpouseBirthDate) ' &|
                                       ' VALUES (' &|
                                       LOC:SpouseParLangID & ',' &|
                                       LOC:SpousePartyID & ',' &|
                                       LOC:SpouseLanguageID & ',' &|
                                       PL:SpouseBirthDate & ',' &|
                                       '''' & StripSQL(LOC:SpouseInitials) & ''',' &|
                                       '''' & StripSQL(LOC:SpouseSalutation) & ''',' &|
                                       '''' & LOC:SpouseTitle & ''',' &|
                                       '''' & StripSQL(PL:SpouseName) & ''',' &|
                                       '''' & StripSQL(PL:SpouseFirstName) & ''',' &|
                                       '''' & StripSQL(PL:SpouseIdentityNumber) & ''',' &|
                                       '''' & StripSQL(PL:PhysicalLine1) & ''',' &|
                                       '''' & StripSQL(PL:PhysicalLine2) & ''',' &|
                                       '''' & StripSQL(PL:PhysicalLine3) & ''',' &|
                                       '''' & StripSQL(PL:PhysicalCode) & ''',' &|
                                       '''' & StripSQL(PL:PostalLine1) & ''',' &|
                                       '''' & StripSQL(PL:PostalLine2) & ''',' &|
                                       '''' & StripSQL(PL:PostalLine3) & ''',' &|
                                       '''' & StripSQL(PL:PostalCode) & ''',' &|
                                       '''' & StripSQL(PL:PlaCitation) & ''',' &|
                                       '''' & StripSQL(PL:DefCitation) & ''',' &|
                                       PL:MarriageDate & ',' &|
                                       '''' & StripSQL(PL:MarriagePlace) & ''',' &|
                                       '''' & StripSQL(PL:DomiciledIn) & ''',' &|
                                       '''' & StripSQL(PL:MaritalDescription) & ''',' &|
                                       PL:AssistedFlag & ',' &|
                                       '''' & StripSQL(PL:ANCNumber) & ''',' &|
                                       '''' & StripSQL(PL:DeedsRegistry) & ''',' &|
                                       '''' & StripSQL(PL:MarriageCountry) & ''',' &|
                                       '''' & StripSQL(PL:SpouseName) & ''',' &|
                                       '''' & StripSQL(PL:FirstName) & ''',' &|
                                       '''' & StripSQL(PL:IdentityNumber) & ''',' &|
                                       PL:BirthDate & ')'
              
              
              
                                      PROPSQL(LOC:SpouseSQLScript)

                       

                           ! ADD SPOUSE RELATIONSHIP
                           PROPSQLNext('INSERT ParRel (PartyID,OtherPartyID,RelationshipID) VALUES (' & PAR:RecordID & ',' & LOC:SpousePartyID & ',1)')
                           PROPSQLNext('INSERT ParRel (PartyID,OtherPartyID,RelationshipID) VALUES (' & LOC:SpousePartyID & ',' & PAR:RecordID & ',1)')

                           MESSAGE('Added ' & LOC:SpouseMatterPrefix & ' - ' & LOC:SpousePartyName & ' to the Address Book.|','New Entry',ICON:Exclamation)

                           HIDE(?CreatePartyButton)
                           !FB 3258
!                           IF PAR:EntityID < 3 OR ENT1:Category = 1
!                            !FB 1088
!                            !UNHIDE(?UpdateSpouseTaxDetailsButton)
!                            IF ~Inlist(PAR:MaritalStatus,'UNM','OUT','CUO','FOR') !as per FB 1088 this is now hidden for CUO and FOR as well
!                                UNHIDE(?UpdateSpouseTaxDetailsButton)
!                            END
!                           !FB 1088
!                           END
!FB 3258  END
                        END                        
                    END    
                END    
            END            
            !FB 3258
            DO CheckAndLoadSpouseParty
            !FB 3258 END

UpdateDataRecord     ROUTINE

       ThisWindow.Update

       DO SetDSFVariables


       PEF:Field1 = LOC:ScreenField[SCRQ:RecordID,LOC:Field1]
       PEF:Field2 = LOC:ScreenField[SCRQ:RecordID,LOC:Field2]
       PEF:Field3 = LOC:ScreenField[SCRQ:RecordID,LOC:Field3]
       PEF:Field4 = LOC:ScreenField[SCRQ:RecordID,LOC:Field4]
       PEF:Field5 = LOC:ScreenField[SCRQ:RecordID,LOC:Field5]
       PEF:Field6 = LOC:ScreenField[SCRQ:RecordID,LOC:Field6]
       PEF:Field7 = LOC:ScreenField[SCRQ:RecordID,LOC:Field7]
       PEF:Field8 = LOC:ScreenField[SCRQ:RecordID,LOC:Field8]
       PEF:Field9 = LOC:ScreenField[SCRQ:RecordID,LOC:Field9]
       PEF:Field10 = LOC:ScreenField[SCRQ:RecordID,LOC:Field10]
       PEF:Field11 = LOC:ScreenField[SCRQ:RecordID,LOC:Field11]
       PEF:Field12 = LOC:ScreenField[SCRQ:RecordID,LOC:Field12]
       PEF:Field13 = LOC:ScreenField[SCRQ:RecordID,LOC:Field13]
       PEF:Field14 = LOC:ScreenField[SCRQ:RecordID,LOC:Field14]
       PEF:Field15 = LOC:ScreenField[SCRQ:RecordID,LOC:Field15]
       PEF:Field16 = LOC:ScreenField[SCRQ:RecordID,LOC:Field16]
       PEF:Field17 = LOC:ScreenField[SCRQ:RecordID,LOC:Field17]
       PEF:Field18 = LOC:ScreenField[SCRQ:RecordID,LOC:Field18]
       PEF:Field19 = LOC:ScreenField[SCRQ:RecordID,LOC:Field19]
       PEF:Field20 = LOC:ScreenField[SCRQ:RecordID,LOC:Field20]
       PEF:Field21 = LOC:ScreenField[SCRQ:RecordID,LOC:Field21]
       PEF:Field22 = LOC:ScreenField[SCRQ:RecordID,LOC:Field22]
       PEF:Field23 = LOC:ScreenField[SCRQ:RecordID,LOC:Field23]
       PEF:Field24 = LOC:ScreenField[SCRQ:RecordID,LOC:Field24]
       PEF:Field25 = LOC:ScreenField[SCRQ:RecordID,LOC:Field25]
       PEF:Field26 = LOC:ScreenField[SCRQ:RecordID,LOC:Field26]
       PEF:Field27 = LOC:ScreenField[SCRQ:RecordID,LOC:Field27]
       PEF:Field28 = LOC:ScreenField[SCRQ:RecordID,LOC:Field28]
       PEF:Field29 = LOC:ScreenField[SCRQ:RecordID,LOC:Field29]
       PEF:Field30 = LOC:ScreenField[SCRQ:RecordID,LOC:Field30]




UpdateScreenFields     ROUTINE


       CLEAR(PEF:Record)
       PEF:DocScreenID = SCRQ:DocScrnID
       PEF:PartyID = PAR:RecordID
       IF Access:ParField.Fetch(PEF:PrimaryKey) THEN EXIT.



       LOC:ScreenField[SCRQ:RecordID,LOC:Field1] = PEF:Field1
       LOC:ScreenField[SCRQ:RecordID,LOC:Field2] = PEF:Field2
       LOC:ScreenField[SCRQ:RecordID,LOC:Field3] = PEF:Field3
       LOC:ScreenField[SCRQ:RecordID,LOC:Field4] = PEF:Field4
       LOC:ScreenField[SCRQ:RecordID,LOC:Field5] = PEF:Field5
       LOC:ScreenField[SCRQ:RecordID,LOC:Field6] = PEF:Field6
       LOC:ScreenField[SCRQ:RecordID,LOC:Field7] = PEF:Field7
       LOC:ScreenField[SCRQ:RecordID,LOC:Field8] = PEF:Field8
       LOC:ScreenField[SCRQ:RecordID,LOC:Field9] = PEF:Field9
       LOC:ScreenField[SCRQ:RecordID,LOC:Field10] = PEF:Field10
       LOC:ScreenField[SCRQ:RecordID,LOC:Field11] = PEF:Field11
       LOC:ScreenField[SCRQ:RecordID,LOC:Field12] = PEF:Field12
       LOC:ScreenField[SCRQ:RecordID,LOC:Field13] = PEF:Field13
       LOC:ScreenField[SCRQ:RecordID,LOC:Field14] = PEF:Field14
       LOC:ScreenField[SCRQ:RecordID,LOC:Field15] = PEF:Field15
       LOC:ScreenField[SCRQ:RecordID,LOC:Field16] = PEF:Field16
       LOC:ScreenField[SCRQ:RecordID,LOC:Field17] = PEF:Field17
       LOC:ScreenField[SCRQ:RecordID,LOC:Field18] = PEF:Field18
       LOC:ScreenField[SCRQ:RecordID,LOC:Field19] = PEF:Field19
       LOC:ScreenField[SCRQ:RecordID,LOC:Field20] = PEF:Field20
       LOC:ScreenField[SCRQ:RecordID,LOC:Field21] = PEF:Field21
       LOC:ScreenField[SCRQ:RecordID,LOC:Field22] = PEF:Field22
       LOC:ScreenField[SCRQ:RecordID,LOC:Field23] = PEF:Field23
       LOC:ScreenField[SCRQ:RecordID,LOC:Field24] = PEF:Field24
       LOC:ScreenField[SCRQ:RecordID,LOC:Field25] = PEF:Field25
       LOC:ScreenField[SCRQ:RecordID,LOC:Field26] = PEF:Field26
       LOC:ScreenField[SCRQ:RecordID,LOC:Field27] = PEF:Field27
       LOC:ScreenField[SCRQ:RecordID,LOC:Field28] = PEF:Field28
       LOC:ScreenField[SCRQ:RecordID,LOC:Field29] = PEF:Field29
       LOC:ScreenField[SCRQ:RecordID,LOC:Field30] = PEF:Field30

       DO CheckDefaults


SetScreenPrompts        ROUTINE

 !message('ENT1:RecordID = ' & ENT1:RecordID)


      ?FicaString{PROP:Text} = 'The following Documents are required for this Party (' & ENT1:Description  & ')'

      !Do not do this here, only check when fica tab selected
      !DO SetFICAStatus


     IF ENT1:RecordID > 2 AND ~(ENT1:RecordID = 16)

        ?MaritalTab{PROP:Hide} = True
        ?SignatoriesTab{PROP:Hide} = False

        IF ENT1:RecordID = 5 OR ENT1:RecordID = 6 OR ENT1:RecordID = 7  ! CC / PVT COMPANY / PUBLIC CO
           ?ShareHoldersTab{PROP:Hide} = False
        ELSE
           ?ShareHoldersTab{PROP:Hide} = True
        END
        IF ENT1:RecordID = 10 AND PT1:RecordID = 17
            ?DeceasedTab{PROP:Hide} = False
        ELSE
            ?DeceasedTab{PROP:Hide} = True
        END
     ELSE

        ?MaritalTab{PROP:Hide} = False
        ?SignatoriesTab{PROP:Hide} = True
        ?ShareHoldersTab{PROP:Hide} = True
        ?DeceasedTab{PROP:Hide} = True
     END

     DO RebuildTabTreeQueue:30

     IF ENT1:RecordID > 2 AND ~(ENT1:RecordID = 16)

        ?PL:Name:Prompt{PROP:Text} = 'Name:   '
        ?PL:AlternativeName:Prompt{PROP:Text} = 'Trading as:'
        ?PL:AlternativeName{PROP:Tooltip} = 'The trading or commercial name of this entity (optional)<13,10>PL:AlternativeName'
        ?PL:Name{PROP:Tooltip} = 'The Name of the ' & ENT1:Description & '<13,10>PL:Name'
        ?PL:IdentityNumber:Prompt{PROP:Text} = ''
        ?PL:IdentityNumber:Prompt{PROP:Text} = 'Number:'
        ?PL:IdentityNumber{PROP:Tooltip} = 'The Registration Number of the ' & ENT1:Description & ' (if applicable)<13,10>PAR:IdentityNumber'
        PL:FirstName = ''

        ?PL:FirstName{PROP:Disable} = True
        ?PL:FirstName:Prompt{PROP:Disable} = True
        PL:Title = ''
        ?PL:Title{PROP:Disable} = True
        ?PL:Title:Prompt{PROP:Disable} = True
        PL:Initials = ''
        ?PL:Initials{PROP:Disable} = True
        ?PL:Initials:Prompt{PROP:Disable} = True

        PL:BirthDate = 0
        ?PL:BirthDate{PROP:Hide} = True
        ?PL:BirthDate:Prompt{PROP:Hide} = True

        ?PL:TrustDate{PROP:Hide} = False
        ?PL:TrustDate:Prompt{PROP:Hide} = False
        ?PL:TrustDate{PROP:Tooltip} = 'The date the ' & ENT1:Description & ' was registered<13,10>PL:TrustDate'

        PAR:MaritalStatus = ''
        PL:AssistedFlag = 0

        ?PAR:TaxNumber:Prompt{PROP:Text} = ''
        ?PAR:TaxNumber:Prompt{PROP:Text} = 'Tax Number:'



        IF ENT1:RecordID = 9 OR ENT1:RecordID = 10
           !?Group6{PROP:Height} = 130
           ?PL:TrustDivision{PROP:Hide} = False
           ?PL:TrustDivision:Prompt{PROP:Hide} = False
           ?LookupLibraryButton:8{PROP:Hide} = False

        ELSE
           !?Group6{PROP:Height} = 115
           PL:TrustDivision = ''
           ?PL:TrustDivision{PROP:Hide} = True
           ?PL:TrustDivision:Prompt{PROP:Hide} = True
           ?LookupLibraryButton:8{PROP:Hide} = True
        END


     ELSE

        IF ~PL:Initials
            PL:Initials = CreateInitials(PL:FirstName)
        END

        ?PL:Name:Prompt{PROP:Text} = 'Surname:'
        ?PL:AlternativeName:Prompt{PROP:Text} = 'Known as:'
        ?PL:AlternativeName{PROP:Tooltip} = 'The nickname or common name of the person (optional)<13,10>PL:AlternativeName'
        ?PL:Name{PROP:Tooltip} = 'The surname of the person<13,10>PL:Name'
        ?PL:IdentityNumber:Prompt{PROP:Text} = ''
        ?PL:IdentityNumber:Prompt{PROP:Text} = 'ID Number:'
        ?PL:IdentityNumber{PROP:Tooltip} = 'The person''s Identity Number<13,10>PAR:IdentityNumber'
        ?PL:FirstName{PROP:Disable} = False
        ?PL:FirstName:Prompt{PROP:Disable} = False
        ?PL:Title{PROP:Disable} = False
        ?PL:Title:Prompt{PROP:Disable} = False
        ?PL:Initials{PROP:Disable} = False
        ?PL:Initials:Prompt{PROP:Disable} = False

        ?PL:BirthDate{PROP:Hide} = False
        ?PL:BirthDate:Prompt{PROP:Hide} = False
        
        PL:TrustDate = 0
        ?PL:TrustDate{PROP:Hide} = True
        ?PL:TrustDate:Prompt{PROP:Hide} = True

        PL:TrustDivision = ''
        ?PL:TrustDivision{PROP:Hide} = True
        ?LookupLibraryButton:8{PROP:Hide} = True

        ?PAR:TaxNumber:Prompt{PROP:Text} = ''
        ?PAR:TaxNumber:Prompt{PROP:Text} = 'Income Tax No:'


     END

     DISPLAY

SetFICAStatus       ROUTINE
      IF GetFicaStatus()
          ?FicaCompliantButton{PROP:Hide} = True
          ?FicaNotCompliantButton{PROP:Hide} = False
          ?FicaPendingButton{PROP:Hide} = True
!         ?FicaButton{PROP:Text} = 'Not Compliant'
!         ?FicaButton{PROP:Icon} = 'delete.ico'
!         ?FicaButton{PROP:Tooltip} = 'This Party is not FICA compliant'
      ELSE
          ?FicaCompliantButton{PROP:Hide} = False
          ?FicaNotCompliantButton{PROP:Hide} = True
          ?FicaPendingButton{PROP:Hide} = True
!         ?FicaButton{PROP:Text} = 'FICA Compliant'
!         ?FicaButton{PROP:Icon} = 'check.ico'
!         ?FicaButton{PROP:Tooltip} = 'This Party is FICA compliant'
      END

      IF PAR:FICACompliantFlag = 0      ! CHECK IF ALREADY REQUESTED FICA DOCUMENTS

         IF PAR:FicaRequestDate AND GLO:TodaysDate >= PAR:FicaRequestDate

            IF GLO:TodaysDate - PAR:FicaRequestDate < 30  ! 30 days have NOT passed

               ?FicaCompliantButton{PROP:Hide} = True
               ?FicaNotCompliantButton{PROP:Hide} = True
               ?FicaPendingButton{PROP:Hide} = False
!               ?FicaButton{PROP:Text} = 'Documents Requested'
!               ?FicaButton{PROP:Icon} = 'Document_Warning.ico'
               ?FicaPendingButton{PROP:Tooltip} = 'FICA documents requested on ' & FORMAT(PAR:FicaRequestDate,@D17)

            END

         END

     END




ResortTheParTeleSorter  ROUTINE

   RowCounter{PROP:SQL} = 'CALL SP_ResortParTeleSorter(' & PAR:recordID & ')'


CheckIfDuplicateName   ROUTINE


  IF QuickWindow{Prop:AcceptAll} THEN EXIT.
  ThisWindow.Update
  IF ThisWindow.Request <> InsertRecord THEN EXIT.
  GLO:RecordID = CheckForDuplicateAddress(PL:Name,1)
  IF GLO:RecordID
     POST(EVENT:CloseWindow)
     POST(EVENT:JumpToParty)
  END

CheckIfDuplicateID   ROUTINE


  IF QuickWindow{Prop:AcceptAll} THEN EXIT.
  ThisWindow.Update
  GLO:RecordID = CheckForDuplicateAddress(PL:IdentityNumber,2)
  IF GLO:RecordID
     POST(EVENT:CloseWindow)
     POST(EVENT:JumpToParty)
  END



MakeSalutation  ROUTINE

      IF ~PL:Salutation AND PL:Name
          IF PAR:PartyTypeID = 1
             IF PAR:DefaultLanguageID = CTL:AfrikaansID
                IF ~PL:Title
                    PL:Salutation = 'Geagte Meneer'
                ELSE
                    PL:Salutation = 'Geagte ' & PL:Title & ' ' & PL:Name
                END
             ELSE
                IF ~PL:Title
                    PL:Salutation = 'Dear Sir'
                ELSE
                    PL:Salutation = 'Dear ' & PL:Title & ' ' & PL:Name
                END
             END
          ELSIF PAR:PartyTypeID = 2
             IF PAR:DefaultLanguageID = CTL:AfrikaansID
                IF ~PL:Title
                    PL:Salutation = 'Geagte Dame'
                ELSE
                    PL:Salutation = 'Geagte ' & PL:Title & ' ' & PL:Name
                END
             ELSE
                IF ~PL:Title
                    PL:Salutation = 'Dear Madam'
                ELSE
                    PL:Salutation = 'Dear ' & PL:Title & ' ' & PL:Name
                END
             END
          ELSE
             IF PAR:DefaultLanguageID = CTL:AfrikaansID
                PL:Salutation = 'Geagte Menere'
             ELSE
                PL:Salutation = 'Dear Sirs'
             END
          END
      END
      DISPLAY
AddAutomaticScreens     ROUTINE

  ! ADD ANY AUTOMATIC EXTRA SCREENS

DeleteScreen    ROUTINE

    RowCounter{PROP:SQL} = 'Delete ParField WHERE DocScreenID = ' & SCRQ:DocScrnID & ' AND PartyID = ' & PAR:RecordID
    !setclipboard(RowCounter{PROP:SQL})


CheckCRMBirthDay    ROUTINE

      IF NOT PAR:BirthDay
         IF PL:BirthDate THEN PAR:BirthDay = DAY(PL:BirthDate).
!         message('1 PAR:BirthDay = ' & DAY(PL:BirthDate))
      END

      IF NOT PAR:BirthDay
         IF PAR:IdentityNumber AND PAR:EntityID = 1
            PAR:BirthDay = SUB(PAR:IdentityNumber,5,2)
!            message('2 PAR:BirthDay = ' & SUB(PAR:IdentityNumber,5,2))
         END
      END

      IF NOT PAR:Birthmonth
         IF PL:BirthDate THEN PAR:Birthmonth = MONTH(PL:BirthDate).
!         message('3 PAR:Birthmonth = ' & MONTH(PL:BirthDate))
      END

      IF NOT PAR:Birthmonth
         IF PAR:IdentityNumber AND PAR:EntityID = 1
            PAR:Birthmonth = SUB(PAR:IdentityNumber,3,2)
!            message('4 PAR:Birthmonth = ' & SUB(PAR:IdentityNumber,3,2))
         END
      END


SetMaritalFields    ROUTINE

         
         IF ~PL:MaritalDescription THEN PL:MaritalDescription = GetMaritalDescription(PAR:DefaultLanguageID).

         IF PAR:DefaultLanguageID = CTL:AfrikaansID
            ?LOC:MaritalStatus{PROP:From} = 'Ongetroud|Buite Gemeenskap van Goed|Binne Gemeenskap van Goed|Buitelandse huwelik|Siviele Vennootskap Binne Gemeenskap van Goedere|Siviele Vennootskap Buite Gemeenskap van Goedere|Ander'
         ELSE
            ?LOC:MaritalStatus{PROP:From} = 'Unmarried|Out of Community|In Community|Foreign|Civil Union In Community|Civil Union Out of Community|Other'
         END



          IF PAR:MaritalStatus = 'UNM'
             ?MarriageGroup{PROP:Disable} = True
             ?SpouseGroup{PROP:Disable} = True
             ENABLE(?PAR:UnmarriedStatus)
          ELSE
             ?MarriageGroup{PROP:Disable} = False
             ?SpouseGroup{PROP:Disable} = False

             IF PAR:MaritalStatus = 'OUT' OR PAR:MaritalStatus = 'CUO'
                ?PL:ANCNumber{PROP:Disable} = False
                ?PL:ANCNumber:Prompt{PROP:Disable} = False
                ?PL:DeedsRegistry{PROP:Disable} = False
                ?PL:DeedsRegistry:Prompt{PROP:Disable} = False
             ELSE
                PL:ANCNumber = ''
                PL:DeedsRegistry = ''
                ?PL:ANCNumber{PROP:Disable} = True
                ?PL:ANCNumber:Prompt{PROP:Disable} = True
                ?PL:DeedsRegistry{PROP:Disable} = True
                ?PL:DeedsRegistry:Prompt{PROP:Disable} = True
             END
             IF PAR:MaritalStatus = 'FOR'
                PL:AssistedFlag = 1
                ?PL:MarriageCountry{PROP:Disable} = False
                ?PL:MarriageCountry:Prompt{PROP:Disable} = False
             ELSE
                PL:MarriageCountry = ''
                ?PL:MarriageCountry{PROP:Disable} = True
                ?PL:MarriageCountry:Prompt{PROP:Disable} = True
             END
             DISABLE(?PAR:UnmarriedStatus)


         END


! ------------------------------------------------------------------------
ThisTabTree30.TabSelected       Procedure(long p_index)
  CODE

ThisTabTree30.OverrideIcon            Procedure
  CODE



ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request
  OF ViewRecord
    ActionMessage = 'View Record'
  OF InsertRecord
    ActionMessage = 'Address Will Be Added'
  OF ChangeRecord
    ActionMessage = 'Address Will Be Changed'
  END
  QuickWindow{Prop:Text} = ActionMessage
  IF SELF.Request = ChangeRecord
     QuickWindow{Prop:Text} = ActionMessage & ' (' & CLIP(LEFT(FORMAT(PAR:RecordID,@n_12))) & ') ' & PAR:MatterPrefix & ' ' & PAR:Name   !Changed from @n_6 to @n_12 - FB 1294
  END
  
  LOC:ChangeSalutation = TRUE
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    ThisSecProc.Init()
  GlobalErrors.SetProcedureName('UpdateParty')
  SELF.Request = GlobalRequest
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?LOC:Entity:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors
  SELF.FirstField = ?PL:Name
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)
  CLEAR(GlobalResponse)
  CLEAR(PL:Record)
  SELF.AddUpdateFile(Access:Party)
  SELF.AddItem(?Cancel,RequestCancelled)
  Relate:AccBank.Open
  Relate:Country.Open
  Relate:CountryAlias.Open
  Relate:DeedsOffice.Open
  Relate:DocFoxRelationship.Open
  Relate:DocScrnField.Open
  Relate:Entity.Open
  Relate:EntityAlias.Open
  Relate:EntityLang.Open
  Relate:Language.Open
  Relate:PTypeDef.Open
  Relate:ParCategory.Open
  Relate:ParFica.Open
  Relate:ParField.Open
  Relate:ParFileNote.Open
  Relate:ParGroup.Open
  Relate:ParLang.Open
  Relate:ParProduct.Open
  Relate:ParRegion.Open
  Relate:ParRel.Open
  Relate:ParShare.Open
  Relate:ParSign.Open
  Relate:ParTele.Open
  Relate:ParType.Open
  Relate:ParTypeAlias.Open
  Relate:Party.Open
  Relate:Province.Open
  Relate:RoleAlias2.Open
  Relate:Stage.Open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:Party
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
  ColorText:6#          = GLO:ColorText
  ColorBackground:6#    = GLO:ColorBackground
  ColorSelText:6#       = GLO:ColorSelText
  ColorSelBackground:6# = GLO:ColorSelBackground
  ColorGrid:6#          = GLO:ColorGrid


  BIND('BIND:FieldRequiredCondition',BIND:FieldRequiredCondition)
  BIND('BIND:FieldCalculation',BIND:FieldCalculation)

   IF PAR:UpdatedById
      IF PAR:UpdatedByDate
         LOC:LastUpdatedBy = GetDescription('EMPLOYEE',PAR:UpdatedById) & ' on ' & FORMAT(PAR:UpdatedByDate,@D17B) & ' at ' & FORMAT(PAR:UpdatedByTime,@T3)
      ELSE
         LOC:LastUpdatedBy = GetDescription('EMPLOYEE',PAR:UpdatedById)
      END
   ELSE
      LOC:LastUpdatedBy = 'Not recorded'
   END

   IF PAR:CreatedID
      IF PAR:CreatedDate
         LOC:CreatedBy = GetDescription('EMPLOYEE',PAR:CreatedId) & ' on ' & FORMAT(PAR:CreatedDate,@D17B) & ' at ' & FORMAT(PAR:CreatedTime,@T3)
      ELSE
         LOC:CreatedBy = GetDescription('EMPLOYEE',PAR:CreatedId)
      END
   ELSE
      LOC:CreatedBy = 'Not recorded'
   END

  
! 28/3/2010 - TAKEN OUT BY RICK. NOT SURE WHY IT IS HERE
! 23/4/2010 - PUT BACK BY NICK. - This is to ensure that the correct banking details are displayed
!             If you do not flush the view, for some reason the correct banking details are not displayed
  Flush(BRW33::View:Browse)
  Free(Queue:Browse:3)
  FLUSH(BRW10::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW10::View:Browse,30,2,5,300)
  BRW10.Init(?TelephoneList,Queue:Browse.ViewPosition,BRW10::View:Browse,Queue:Browse,Relate:ParTele,SELF)
  FLUSH(BRW14::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW14::View:Browse,30,2,5,300)
  BRW14.Init(?SignatoriesList,Queue:Browse:1.ViewPosition,BRW14::View:Browse,Queue:Browse:1,Relate:ParSign,SELF)
  FLUSH(BRW31::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW31::View:Browse,30,2,5,300)
  BRW31.Init(?List,Queue:Browse:2.ViewPosition,BRW31::View:Browse,Queue:Browse:2,Relate:ParRel,SELF)
  FLUSH(BRW33::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW33::View:Browse,30,2,5,300)
  BRW33.Init(?List:2,Queue:Browse:3.ViewPosition,BRW33::View:Browse,Queue:Browse:3,Relate:AccBank,SELF)
  FLUSH(BRW42::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW42::View:Browse,30,2,5,300)
  BRW42.Init(?List:3,Queue:Browse:4.ViewPosition,BRW42::View:Browse,Queue:Browse:4,Relate:ParGroup,SELF)
  FLUSH(BRW8::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW8::View:Browse,30,2,5,300)
  BRW8.Init(?List:4,Queue:Browse:5.ViewPosition,BRW8::View:Browse,Queue:Browse:5,Relate:ParFileNote,SELF)
  FLUSH(BRW16::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW16::View:Browse,30,2,5,300)
  BRW16.Init(?List:5,Queue:Browse:6.ViewPosition,BRW16::View:Browse,Queue:Browse:6,Relate:ParProduct,SELF)
  FLUSH(BRW41::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW41::View:Browse,30,2,5,300)
  BRW41.Init(?List:6,Queue:Browse:7.ViewPosition,BRW41::View:Browse,Queue:Browse:7,Relate:ParShare,SELF)
  FLUSH(BRW48::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW48::View:Browse,30,2,5,300)
  BRW48.Init(?List:7,Queue:Browse:8.ViewPosition,BRW48::View:Browse,Queue:Browse:8,Relate:ParFica,SELF)
  ColorText:6#          = GLO:ColorText
  ColorBackground:6#    = GLO:ColorBackground
  ColorSelText:6#       = GLO:ColorSelText
  ColorSelBackground:6# = GLO:ColorSelBackground
  ColorGrid:6#          = GLO:ColorGrid
  
  IF PAR:RecordID
     LOC:JumpToQueueRecord = 0
     CLEAR(ROW:Record)
     RowCounter{PROP:SQL} = 'SELECT RecordID, FileRef + '' - '' + Description FROM Matter WHERE ClientID = ' & PAR:RecordID & ' ORDER BY FileRef'
     LOOP
          NEXT(RowCounter)
          IF ERROR() THEN BREAK.
          MATQ:Description = ROW:Description
          MATQ:RecordID = ROW:Counter
          ADD(Matter:Queue,MATQ:Description)
     
         IF PAR:BillingMatterID AND PAR:BillingMatterID = MATQ:RecordID
            LOC:JumpToQueueRecord = RECORDS(Matter:Queue)
         END
     
     END
     
     IF LOC:JumpToQueueRecord
        ?LOC:Matter{PROP:Selected} = LOC:JumpToQueueRecord
        GET(Matter:Queue,LOC:JumpToQueueRecord)
     ELSE
        ?LOC:Matter{PROP:Selected} = 1
        GET(Matter:Queue,1)
     END
     PAR:BillingMatterID = MATQ:RecordID
     LOC:Matter = MATQ:Description
  ELSE
     ?LOC:Matter{PROP:Disable} = True
  END
  
  
  
  IF ~PAR:TaxPayer THEN PAR:TaxPayer = 'Y'.
  IF ~PAR:SpouseTaxPayer THEN PAR:SpouseTaxPayer = 'Y'.
  
  IF ~PAR:SAResident AND PAR:PostalCountryID AND PAR:PostalCountryID > 1
      PAR:SAResident = 'N'
  END
  
  IF ~PAR:SAResident AND PAR:PhysicalCountryID AND PAR:PhysicalCountryID > 1
      PAR:SAResident = 'N'
  END
  
  IF ~PAR:SAResident THEN PAR:SAResident = 'Y'.
  IF ~PAR:SpouseSAResident THEN PAR:SpouseSAResident = 'Y'.
  
  X# = GetFicaStatus()
  
  OPEN(QuickWindow)
  SELF.Opened=True
! USERS WERE COMPLAINING - IT IS ILLOGICAL ANYWAY
!  IF SELF.Request = InsertRecord
!
!     IF CheckMatterConditions('A',1)  ! CHECK IF THEY ARE ALLOWED TO INSERT A PARTY - CALL IN SILTENT MODE, I.E. NO MESSAGE DISPLAYED
!
!        DISABLE(?LOC:Entity)          ! DOING THIS BECAUSE THEY WERE CHANGING THE DROP DOWNS TO CHANGE THE ROLE SO THE CONDITION WAS FALSE AND THEN CHANGING IT BACK
!        DISABLE(?SelectEntityButton)
!        DISABLE(?LOC:PartyType)
!        DISABLE(?SelectPartyTypeButton)
!        DISABLE(?LOC:Role)
!        DISABLE(?SelectRoleButton)
!
!     END
!
!  END
  
    IF UserLicensed(0,True,'DOCFOX')
        Do SetDocFoxVisibility
    ELSE
        ?SendToDocFox{PROP:Hide} = true
        ?CheckDocFox{PROP:Hide} = true
        ?InviteDocFox{PROP:Hide} = true
        ?RevokeDocFox{PROP:Hide} = true
        ?DocFoxRelationshipList{PROP:Hide} = true
        ?GroupDocFox{PROP:Hide} = true
    END

  IF SELF.Request = ChangeRecord

     ! 19/07/2018 PK Naidoo: FB Case 1683
     IF GLO:SupervisorFlag

        ENABLE(PAR:LockParty)

     ELSE

        ?PAR:LockParty{PROP:Disable} = TRUE

        IF PAR:LockParty
           
           ?OK{PROP:Disable} = TRUE
           ?ApplyButton{PROP:Disable} = TRUE

        ELSE

           ?OK{PROP:Disable} = FALSE
           ?ApplyButton{PROP:Disable} = FALSE

        END

     END

     IF CheckMatterConditions('E',1)  ! CHECK IF THEY ARE ALLOWED TO CHANGE THIS PARTY - CALL IN SILTENT MODE, I.E. NO MESSAGE DISPLAYED

        DISABLE(?OK)
        DISABLE(?ApplyButton)

     END

  ELSE

     !?LOC:LockParty{PROP:Hide} = TRUE

  END

  IF GLO:InterfaceOption = 'C'      !IF CONVEYANCING USER
     ?CitationsTab{PROP:Hide} = True
  END

  IF ~GLO:CRMLicensedFlag
      DISABLE(?LOC:FirstCRMField,?LOC:LastCRMField)
      DISABLE(?FileNotesTab)
      DISABLE(?ProductsTab)
  END


  DO CheckCRMBirthDay
  
  IF ~PAR:DefaultLanguageID
      PAR:DefaultLanguageID = GLO:DefaultLanguageID
  END
  LAN:RecordID = PAR:DefaultLanguageID
  Access:Language.Fetch(LAN:PrimaryKey)
  LOC:Language = LAN:Description

  SAV:LanguageID = PAR:DefaultLanguageID


  CLEAR(ENT1:Record)
  CLEAR(PT1:Record)
  IF PAR:PartyTypeID
     PT1:RecordID = PAR:PartyTypeID
     IF Access:ParTypeAlias.TryFetch(PT1:PrimaryKey) THEN CLEAR(PT1:Record).
  END
  

  IF SELF.Request = InsertRecord
  
     IF GLO:PartyTypeID                   ! THIS IS SOMETIMES SET WHEN ADDING A SPECIFIC TYPE (E.G. ESTATE AGENT)
        PAR:PartyTypeID = GLO:PartyTypeID ! SO IF THE USER IS ADDING A NEW ONE, PRIME THE TYPE BECAUSE WE KNOW IT ALREADY
        PT1:RecordID = GLO:PartyTypeID
        IF ~Access:ParTypeAlias.Fetch(PT1:PrimaryKey)
            LOC:PartyType = PT1:Description
        END
        IF PT1:Category = 1
           PAR:EntityID = 1
        ELSE
           PAR:EntityID = 5     ! IF NOT AN ADULT, DEFAULT TO 'Business'
        END

     ELSE
        PAR:PartyTypeID = 1
        PAR:EntityID = 1

     END
  
  
  END


  IF PAR:EntityID
     ENT1:RecordID = PAR:EntityID
     IF Access:EntityAlias.TryFetch(ENT1:PrimaryKey) THEN CLEAR(ENT1:Record).
  END

  SAV:Category = ENT1:Category

  LOC:Entity = ENT1:Description
  LOC:PartyType = PT1:Description

  DO SetScreenPrompts

  IF SELF.Request = ChangeRecord


     DO CheckLanguagesForDifferences ! PK here

     IF PL:PhysicalCode AND ~PAR:ParRegionID THEN  PAR:ParRegionID = GetParRegionID(PL:PhysicalCode).
     IF PL:PostalCode AND ~PAR:ParRegionID THEN  PAR:ParRegionID = GetParRegionID(PL:PostalCode).

     SAV:PartyName = PL:Name        ! WARN THEM IF THEY CHANGE A NAME OF AN EXISTING CLIENT
                                    ! SOME USERS ARE JSUT USING THE SAME CLLIENT OVER AND OVER
  
     SAV:PartyTypeID = PAR:PartyTypeID   ! DON'T CHANGE THE CITATIONS
     SAV:EntityID = PAR:EntityID


  END
  
  
  
!  IF GLO:InterfaceOption = 'L'      !IF LITIGATION USER
!     ?MaritalTab{PROP:Hide} = True
!     ?SignatoriesTab{PROP:Hide} = True
!  END


  IF ~PAR:PhysicalCountryID THEN PAR:PhysicalCountryID = 1.
  IF ~PAR:PostalCountryID THEN PAR:PostalCountryID = 1.
  
  IF ~PAR:MaritalStatus THEN
    PAR:MaritalStatus = 'UNM'
  END
      
  CASE PAR:MaritalStatus
        OF 'UNM'
            ?LOC:MaritalStatus{PROP:Selected} = 1
        OF 'OUT'
            ?LOC:MaritalStatus{PROP:Selected} = 2
        OF 'INC'
            ?LOC:MaritalStatus{PROP:Selected} = 3
        OF 'FOR'
             ?LOC:MaritalStatus{PROP:Selected} = 4
        OF 'CUI'
            ?LOC:MaritalStatus{PROP:Selected} = 5
        OF 'CUO'
            ?LOC:MaritalStatus{PROP:Selected} = 6
        OF 'OTM'
            ?LOC:MaritalStatus{PROP:Selected} = 7
        ELSE
            ?LOC:MaritalStatus{PROP:Selected} = 0
   END


  DO SetMaritalFields
  SAVE:MaritalStatus = PAR:MaritalStatus
  !Kelvin - 11- 10 -2016 -- adding to set defaults. added the SAV:PAR setting since it wasn't being set.
  SAVED:MaritalStatus = PAR:MaritalStatus
  SAV:PAR:MaritalStatus = PAR:MaritalStatus
  !FB 991 Kelvin 17 08 2017
 !FB 3258
!  IF PAR:EntityID < 3 OR ENT1:Category = 1
!           IF ~PAR:MaritalStatus OR  Inlist(PAR:MaritalStatus,'UNM','OUT','CUO','FOR') !as per FB 1088 this is now hidden for CUO and FOR as well  !FB 3064 catering for blank status
!              HIDE(?SpouseTaxGroup)
!              HIDE(?UpdateSpouseTaxDetailsButton)
!              ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = True
!              ?PAR:SpouseTaxNumber{PROP:Hide} = True
!           ELSE
!              UNHIDE(?SpouseTaxGroup)
!              UNHIDE(?UpdateSpouseTaxDetailsButton)
!              ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = False
!              ?PAR:SpouseTaxNumber{PROP:Hide} = False
!           END
! !FB 3258
!!    PropSQLNext('Select top 1 ParRel.PartyId from ParRel INNER JOIN Relationship ON Relationship.Description = ''Spouse'' AND Relationship.RecordID = ParRel.RelationshipID WHERE ParRel.PartyID =' & PAR:RecordID)
!!    IF ROW:Counter > 0
!!        HIDE(?CreatePartyButton)
!!    ELSE
!!        UNHIDE(?CreatePartyButton)
!!    END
!
!!FB 3258 END
!  ELSE
!    HIDE(?CreatePartyButton)
!    !FB 3064
!     HIDE(?SpouseTaxGroup)
!     HIDE(?UpdateSpouseTaxDetailsButton)
!     ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = True
!     ?PAR:SpouseTaxNumber{PROP:Hide} = True
!     !FB 3064 END
!  END
!FB 3258 END
  Access:ParLangAlias2.Open
  Access:ParLangAlias2.UseFile
  Access:PartyAlias2.Open
  Access:PartyAlias2.UseFile
  DO CheckAndLoadDeceasedParty
  !FB 3258
  DO CheckAndLoadSpouseParty
  !FB 3258 END
  LOC:TotalIncome = PAR:Income1 + PAR:Income2 + PAR:Income3 + PAR:Income4 + PAR:Income5 + PAR:Income6 + PAR:Income7 + PAR:Income8 + PAR:Income9 + PAR:Income10 + PAR:Income11 + PAR:Income12 +|
                    PAR:LIncome1 + PAR:LIncome2 + PAR:LIncome3 + PAR:LIncome4 + PAR:LIncome5 + PAR:LIncome6 + PAR:LIncome7 + PAR:LIncome8 + PAR:LIncome9 + PAR:LIncome10 + PAR:LIncome11 + PAR:LIncome12
  
  
  IF PAR:BirthMonth > 12 THEN PAR:BirthMonth = 0.   ! SOLVE CONVERSION ISSUES
  IF PAR:BirthDay > 31 THEN PAR:BirthDay = 0.

  
  GLO:DocumentLanguageID = PAR:DefaultLanguageID   ! FOR SOME OF THE BINDED FUNCTIONS
  LOC:ExistingTabs = 18     ! SO THE INCLUDE CODE WORKS !FB544 Kelvin 23 2 2016 ! 28/09/2018 PK Naidoo & Kelvin: Deceased Estate Tab Added
  LOC:DisplayHowMany = 30
  LOC:AdjustYPos = 10
  LOC:AdjustXPos = 0

        !FB 1708
        
        IF (~PL:BirthDate OR PL:BirthDate < 1)
            PAR:BirthdaySMSFlag = 0
            ?PAR:BirthdaySMSFlag{PROP:Disable} = True
            ?PAR:BirthDay{PROP:Disable} = True
            ?LOC:BirthMonth{PROP:Disable} = True
            ?Group14{PROP:Disable} = True
        ELSE
            ?Group14{PROP:Disable} = False
            ?PAR:BirthdaySMSFlag{PROP:Disable} = False
            ?PAR:BirthDay{PROP:Disable} = False
            ?LOC:BirthMonth{PROP:Disable} = False
        END

  INCLUDE('UpdateMatterExtraScreenSource','Open Window')
    if ~PAR:IdentityDocumentType
        PAR:IdentityDocumentType = 'I'
    END
    !fb3009
!    if PAR:IdentityDocumentType = 'P'
!        if PAR:PassportNumber AND ~PAR:IdentityNumber
!            PAR:IdentityNumber = PAR:PassportNumber
!        end
!        ?PAR:PassportNumber{PROP:ReadOnly} = True
!        ?PAR:PassportNumber{PROP:BackGround} = COLOR:Silver
!      else
!         ?PAR:PassportNumber{PROP:ReadOnly} = False
!         ?PAR:PassportNumber{PROP:BackGround} = COLOR:None
!      end
!fb3009 END


  POST(EVENT:Accepted)

  
       QuickWindow{Prop:Alrt,254}=1024
       QuickWindow{Prop:Alrt,255}=AltF12
     
  PDPC:LOC:PL2:BirthDate.Init(?LOC:PL2:BirthDate,LOC:PL2:BirthDate,PopCalQ,Def_Config,)
  PDPC:PAR:DateResolutionSigned.Init(?PAR:DateResolutionSigned,PAR:DateResolutionSigned,PopCalQ,Def_Config,)
  PDPC:PAR:LastInstructedDate.Init(?PAR:LastInstructedDate,PAR:LastInstructedDate,PopCalQ,Def_Config,)
  PDPC:PAR:RemoteAccessExpiry.Init(?PAR:RemoteAccessExpiry,PAR:RemoteAccessExpiry,PopCalQ,Def_Config,)
  PDPC:PL:BirthDate.Init(?PL:BirthDate,PL:BirthDate,PopCalQ,Def_Config,)
  PDPC:PL:GPASignedOn.Init(?PL:GPASignedOn,PL:GPASignedOn,PopCalQ,Def_Config,)
  PDPC:PL:MarriageDate.Init(?PL:MarriageDate,PL:MarriageDate,PopCalQ,Def_Config,)
  PDPC:PL:SpouseBirthDate.Init(?PL:SpouseBirthDate,PL:SpouseBirthDate,PopCalQ,Def_Config,)
  PDPC:PL:TrustDate.Init(?PL:TrustDate,PL:TrustDate,PopCalQ,Def_Config,)
  PDSC:LOC:PL2:BirthDate.Init(LOC:PL2:BirthDate,PDSchedC,?LOC:PL2:BirthDate,,,) ! NOTE: Date Scroll and Drop class range limits can be set with Field user options: PDDTRangeLow and PPDTRangeHigh
  PDSC:LOC:PL2:BirthDate.SetAlert(PDDT_eqSemiMonPlus+1,0) ! Disable altdown key so it can be used by button.
  PDSC:LOC:PL2:BirthDate.AddDropID('PDPopCal')
  PDSC:PAR:DateResolutionSigned.Init(PAR:DateResolutionSigned,PDSchedC,?PAR:DateResolutionSigned,,,) ! NOTE: Date Scroll and Drop class range limits can be set with Field user options: PDDTRangeLow and PPDTRangeHigh
  PDSC:PAR:DateResolutionSigned.SetAlert(PDDT_eqSemiMonPlus+1,0) ! Disable altdown key so it can be used by button.
  PDSC:PAR:DateResolutionSigned.AddDropID('PDPopCal')
  PDSC:PAR:LastInstructedDate.Init(PAR:LastInstructedDate,PDSchedC,?PAR:LastInstructedDate,,,) ! NOTE: Date Scroll and Drop class range limits can be set with Field user options: PDDTRangeLow and PPDTRangeHigh
  PDSC:PAR:LastInstructedDate.SetAlert(PDDT_eqSemiMonPlus+1,0) ! Disable altdown key so it can be used by button.
  PDSC:PAR:LastInstructedDate.AddDropID('PDPopCal')
  PDSC:PAR:RemoteAccessExpiry.Init(PAR:RemoteAccessExpiry,PDSchedC,?PAR:RemoteAccessExpiry,,,) ! NOTE: Date Scroll and Drop class range limits can be set with Field user options: PDDTRangeLow and PPDTRangeHigh
  PDSC:PAR:RemoteAccessExpiry.SetAlert(PDDT_eqSemiMonPlus+1,0) ! Disable altdown key so it can be used by button.
  PDSC:PAR:RemoteAccessExpiry.AddDropID('PDPopCal')
  PDSC:PL:BirthDate.Init(PL:BirthDate,PDSchedC,?PL:BirthDate,,,) ! NOTE: Date Scroll and Drop class range limits can be set with Field user options: PDDTRangeLow and PPDTRangeHigh
  PDSC:PL:BirthDate.SetAlert(PDDT_eqSemiMonPlus+1,0)  ! Disable altdown key so it can be used by button.
  PDSC:PL:BirthDate.AddDropID('PDPopCal')
  PDSC:PL:GPASignedOn.Init(PL:GPASignedOn,PDSchedC,?PL:GPASignedOn,,,) ! NOTE: Date Scroll and Drop class range limits can be set with Field user options: PDDTRangeLow and PPDTRangeHigh
  PDSC:PL:GPASignedOn.SetAlert(PDDT_eqSemiMonPlus+1,0) ! Disable altdown key so it can be used by button.
  PDSC:PL:GPASignedOn.AddDropID('PDPopCal')
  PDSC:PL:MarriageDate.Init(PL:MarriageDate,PDSchedC,?PL:MarriageDate,,,) ! NOTE: Date Scroll and Drop class range limits can be set with Field user options: PDDTRangeLow and PPDTRangeHigh
  PDSC:PL:MarriageDate.SetAlert(PDDT_eqSemiMonPlus+1,0) ! Disable altdown key so it can be used by button.
  PDSC:PL:MarriageDate.AddDropID('PDPopCal')
  PDSC:PL:SpouseBirthDate.Init(PL:SpouseBirthDate,PDSchedC,?PL:SpouseBirthDate,,,) ! NOTE: Date Scroll and Drop class range limits can be set with Field user options: PDDTRangeLow and PPDTRangeHigh
  PDSC:PL:SpouseBirthDate.SetAlert(PDDT_eqSemiMonPlus+1,0) ! Disable altdown key so it can be used by button.
  PDSC:PL:SpouseBirthDate.AddDropID('PDPopCal')
  PDSC:PL:TrustDate.Init(PL:TrustDate,PDSchedC,?PL:TrustDate,,,) ! NOTE: Date Scroll and Drop class range limits can be set with Field user options: PDDTRangeLow and PPDTRangeHigh
  PDSC:PL:TrustDate.SetAlert(PDDT_eqSemiMonPlus+1,0)  ! Disable altdown key so it can be used by button.
  PDSC:PL:TrustDate.AddDropID('PDPopCal')
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)
  SELF.AddItem(Resizer)
  BRW10.Q &= Queue:Browse
  BRW10.FileLoaded = 1
  
  BRW10.AddSortOrder(,PTE:PrimaryKey)
  BRW10.AddRange(PTE:PartyID,Relate:ParTele,Relate:Party)
  BRW10.AddField(TT:Description,BRW10.Q.TT:Description)
  BRW10.AddField(PTE:Number,BRW10.Q.PTE:Number)
  BRW10.AddField(PTE:PartyID,BRW10.Q.PTE:PartyID)
  BRW10.AddField(PTE:RecordID,BRW10.Q.PTE:RecordID)
  BRW10.AddField(PTE:TelephoneTypeID,BRW10.Q.PTE:TelephoneTypeID)
  BRW10.AddField(PTE:Sorter,BRW10.Q.PTE:Sorter)
  BRW10.AddField(TT:RecordID,BRW10.Q.TT:RecordID)
  BRW14.Q &= Queue:Browse:1
  BRW14.FileLoaded = 1
  
  BRW14.AddSortOrder(,PS:PrimaryKey)
  BRW14.AddRange(PS:PartyID,Relate:ParSign,Relate:Party)
  BRW14.AddLocator(BRW14::Sort0:Locator)
  BRW14::Sort0:Locator.Init(,PS:Sorter,,BRW14)
  BIND('LOC:ParSign',LOC:ParSign)
  BRW14.AddField(LOC:ParSign,BRW14.Q.LOC:ParSign)
  BRW14.AddField(PS:PartyID,BRW14.Q.PS:PartyID)
  BRW14.AddField(PS:FirstName,BRW14.Q.PS:FirstName)
  BRW14.AddField(PS:LastName,BRW14.Q.PS:LastName)
  BRW14.AddField(PS:Position,BRW14.Q.PS:Position)
  BRW14.AddField(PS:Sorter,BRW14.Q.PS:Sorter)
  BRW31.Q &= Queue:Browse:2
  BRW31.FileLoaded = 1
  
  BRW31.AddSortOrder(,PREL:PrimaryKey)
  BRW31.AddRange(PREL:PartyID,PAR:RecordID)
  BRW31.AddLocator(BRW31::Sort0:Locator)
  BRW31::Sort0:Locator.Init(,PREL:OtherPartyID,,BRW31)
  BIND('LOC:DefaultContact',LOC:DefaultContact)
  BRW31.AddField(RELAT:Description,BRW31.Q.RELAT:Description)
  BRW31.AddField(PAR1:Name,BRW31.Q.PAR1:Name)
  BRW31.AddField(LOC:DefaultContact,BRW31.Q.LOC:DefaultContact)
  BRW31.AddField(PREL:DefaultContactFlag,BRW31.Q.PREL:DefaultContactFlag)
  BRW31.AddField(PREL:RecordID,BRW31.Q.PREL:RecordID)
  BRW31.AddField(DFR:DocFoxID,BRW31.Q.DFR:DocFoxID)
  BRW31.AddField(PREL:PartyID,BRW31.Q.PREL:PartyID)
  BRW31.AddField(PREL:OtherPartyID,BRW31.Q.PREL:OtherPartyID)
  BRW31.AddField(PREL:RelationshipID,BRW31.Q.PREL:RelationshipID)
  BRW31.AddField(RELAT:RecordID,BRW31.Q.RELAT:RecordID)
  BRW31.AddField(PAR1:RecordID,BRW31.Q.PAR1:RecordID)
  BRW33.Q &= Queue:Browse:3
  
  BRW33.AddSortOrder(,ACB:PartyKey)
  BRW33.AddLocator(BRW33::Sort0:Locator)
  BRW33::Sort0:Locator.Init(,ACB:AccountType,,BRW33)
  BRW33.SetFilter('(ACB:AccountId = PAR:RecordID AND ACB:AccountType = ''M'')')
  BIND('LOC:AccountCode',LOC:AccountCode)
  ?List:2{PROP:IconList,1} = '~blank.ico'
  ?List:2{PROP:IconList,2} = '~bok.ico'
  BRW33.AddField(ACB:Description,BRW33.Q.ACB:Description)
  BRW33.AddField(ACB:AccountName,BRW33.Q.ACB:AccountName)
  BRW33.AddField(ACB:AccountNo,BRW33.Q.ACB:AccountNo)
  BRW33.AddField(LOC:AccountCode,BRW33.Q.LOC:AccountCode)
  BRW33.AddField(ACB:Institution,BRW33.Q.ACB:Institution)
  BRW33.AddField(ACB:Branch,BRW33.Q.ACB:Branch)
  BRW33.AddField(ACB:BranchCode,BRW33.Q.ACB:BranchCode)
  BRW33.AddField(ACB:RecordId,BRW33.Q.ACB:RecordId)
  BRW33.AddField(ACB:AccountId,BRW33.Q.ACB:AccountId)
  BRW33.AddField(ACB:AccountCode,BRW33.Q.ACB:AccountCode)
  BRW33.AddField(ACB:AccountType,BRW33.Q.ACB:AccountType)
  BRW42.Q &= Queue:Browse:4
  BRW42.FileLoaded = 1
  
  BRW42.AddSortOrder(,PG:PrimaryKey)
  BRW42.AddRange(PG:PartyID,Relate:ParGroup,Relate:Party)
  BRW42.AddLocator(BRW42::Sort0:Locator)
  BRW42::Sort0:Locator.Init(,PG:GroupID,,BRW42)
  BRW42.AddField(PGRO:Description,BRW42.Q.PGRO:Description)
  BRW42.AddField(PG:PartyID,BRW42.Q.PG:PartyID)
  BRW42.AddField(PG:GroupID,BRW42.Q.PG:GroupID)
  BRW42.AddField(PGRO:RecordID,BRW42.Q.PGRO:RecordID)
  BRW8.Q &= Queue:Browse:5
  BRW8.FileLoaded = 1
  
  BRW8.AddSortOrder(,PFN:PartyDateKey)
  BRW8.AddRange(PFN:PartyID,Relate:ParFileNote,Relate:Party)
  BRW8.AddLocator(BRW8::Sort0:Locator)
  BRW8::Sort0:Locator.Init(,PFN:Date,,BRW8)
  BRW8.AddField(PFN:Date,BRW8.Q.PFN:Date)
  BRW8.AddField(PFN:Description,BRW8.Q.PFN:Description)
  BRW8.AddField(PFN:RecordID,BRW8.Q.PFN:RecordID)
  BRW8.AddField(PFN:PartyID,BRW8.Q.PFN:PartyID)
  BRW16.Q &= Queue:Browse:6
  BRW16.FileLoaded = 1
  
  BRW16.AddSortOrder(,PP:PartyDateKey)
  BRW16.AddRange(PP:PartyID,Relate:ParProduct,Relate:Party)
  BRW16.AddLocator(BRW16::Sort0:Locator)
  BRW16::Sort0:Locator.Init(,PP:Date,,BRW16)
  BRW16.AddField(PP:Date,BRW16.Q.PP:Date)
  BRW16.AddField(PROD:Description,BRW16.Q.PROD:Description)
  BRW16.AddField(PP:Quantity,BRW16.Q.PP:Quantity)
  BRW16.AddField(PP:UnitPrice,BRW16.Q.PP:UnitPrice)
  BRW16.AddField(PP:Notes,BRW16.Q.PP:Notes)
  BRW16.AddField(PP:RecordID,BRW16.Q.PP:RecordID)
  BRW16.AddField(PP:PartyID,BRW16.Q.PP:PartyID)
  BRW16.AddField(PROD:RecordID,BRW16.Q.PROD:RecordID)
  BRW41.Q &= Queue:Browse:7
  BRW41.FileLoaded = 1
  
  BRW41.AddSortOrder(,PSH:PrimaryKey)
  BRW41.AddRange(PSH:PartyID,Relate:ParShare,Relate:Party)
  BRW41.AddLocator(BRW41::Sort0:Locator)
  BRW41::Sort0:Locator.Init(,PSH:Sorter,,BRW41)
  BRW41.AddField(PSH:FirstName,BRW41.Q.PSH:FirstName)
  BRW41.AddField(PSH:LastName,BRW41.Q.PSH:LastName)
  BRW41.AddField(PSH:PartyID,BRW41.Q.PSH:PartyID)
  BRW41.AddField(PSH:Sorter,BRW41.Q.PSH:Sorter)
  BRW48.Q &= Queue:Browse:8
  
  BRW48.AddSortOrder(,PARF:PrimaryKey)
  BRW48.AddLocator(BRW48::Sort0:Locator)
  BRW48::Sort0:Locator.Init(,PARF:PartyID,,BRW48)
  BRW48.SetFilter('(PARF:PartyId = PAR:RecordId and ENTF:EntityID = PAR:EntityId)')
  BIND('LOC:FicaTick',LOC:FicaTick)
  BIND('LOC:FicaExpiresDate',LOC:FicaExpiresDate)
  ?List:7{PROP:IconList,1} = '~smcross.ico'
  ?List:7{PROP:IconList,2} = '~smtick.ico'
  BRW48.AddField(LOC:FicaTick,BRW48.Q.LOC:FicaTick)
  BRW48.AddField(FIC:Description,BRW48.Q.FIC:Description)
  BRW48.AddField(PARF:Date,BRW48.Q.PARF:Date)
  BRW48.AddField(LOC:FicaExpiresDate,BRW48.Q.LOC:FicaExpiresDate)
  BRW48.AddField(PARF:Comments,BRW48.Q.PARF:Comments)
  BRW48.AddField(FIC:Expiry,BRW48.Q.FIC:Expiry)
  BRW48.AddField(PARF:PartyID,BRW48.Q.PARF:PartyID)
  BRW48.AddField(ENTF:EntityID,BRW48.Q.ENTF:EntityID)
  BRW48.AddField(PARF:FicaItemID,BRW48.Q.PARF:FicaItemID)
  BRW48.AddField(FIC:RecordID,BRW48.Q.FIC:RecordID)
  ?List:7{PROP:IconList,3} = '~smquest.ico'
  
     
      ThisTabTree30.Control = ?TabTree
      ThisTabTree30.Control{PROP:Alrt,255} = DownKey
      ThisTabTree30.Control{PROP:Alrt,255} = UpKey
    
      ThisTabTree30.SheetControl = ?Sheet1
    
      ThisTabTree30.Header       = ''
      ThisTabTree30.ColumnHeader = 'Go To'
    
      ThisTabTree30.RemoveHotKey = 1
      ThisTabTree30.RememberTab = 0
      ThisTabTree30.Tips = 0
    
      ThisTabTree30.DisabledTip = 'This option disabled'
    
      ?Sheet1{prop:wizard} = 1
      ThisTabTree30.LineHeight = 10
      ThisTabTree30.HeaderIcon = 'FOLDER.ICO'
      ThisTabTree30.HeaderDisabledIcon = 'FOLDER.ICO'
      ThisTabTree30.BranchIcon = 'SimSarrw.ICO'
      ThisTabTree30.BranchDisabledIcon = 'disabled.ICO'
      ThisTabTree30.SelectedIcon = 'SimPtr.ICO'
      ThisTabTree30.SetList(1)
  IF ?PAR:NoFICAFlag{Prop:Checked} = True
    HIDE(?FICAButtonGroup)
  END
  IF ?PAR:NoFICAFlag{Prop:Checked} = False
    UNHIDE(?FICAButtonGroup)
  END
  FDB36.Init(?LOC:Entity,Queue:FileDrop:7.ViewPosition,FDB36::View:FileDrop,Queue:FileDrop:7,Relate:EntityAlias,ThisWindow)
  FDB36.Q &= Queue:FileDrop:7
  FDB36.AddSortOrder(ENT1:DescriptionKey)
  FDB36.SetFilter('ENT1:RecordID << 18 OR ENT1:RecordID > 20')
  FDB36.AddField(ENT1:Description,FDB36.Q.ENT1:Description)
  FDB36.AddField(ENT1:Category,FDB36.Q.ENT1:Category)
  FDB36.AddField(ENT1:JuristicFlag,FDB36.Q.ENT1:JuristicFlag)
  FDB36.AddField(ENT1:RecordID,FDB36.Q.ENT1:RecordID)
  FDB36.AddUpdateField(ENT1:RecordID,PAR:EntityID)
  ThisWindow.AddItem(FDB36.WindowComponent)
  FDB36.DefaultFill = 0
  FDB9.Init(?LOC:PartyType,Queue:FileDrop.ViewPosition,FDB9::View:FileDrop,Queue:FileDrop,Relate:ParTypeAlias,ThisWindow)
  FDB9.Q &= Queue:FileDrop
  FDB9.AddSortOrder(PT1:DescriptionKey)
  FDB9.AddField(PT1:Description,FDB9.Q.PT1:Description)
  FDB9.AddField(PT1:Category,FDB9.Q.PT1:Category)
  FDB9.AddField(PT1:RecordID,FDB9.Q.PT1:RecordID)
  FDB9.AddUpdateField(PT1:RecordID,PAR:PartyTypeID)
  ThisWindow.AddItem(FDB9.WindowComponent)
  FDB11.Init(?LOC:Language,Queue:FileDrop:1.ViewPosition,FDB11::View:FileDrop,Queue:FileDrop:1,Relate:Language,ThisWindow)
  FDB11.Q &= Queue:FileDrop:1
  FDB11.AddSortOrder(LAN:PrimaryKey)
  FDB11.AddField(LAN:Description,FDB11.Q.LAN:Description)
  FDB11.AddField(LAN:RecordID,FDB11.Q.LAN:RecordID)
  FDB11.AddUpdateField(LAN:RecordID,PAR:DefaultLanguageID)
  ThisWindow.AddItem(FDB11.WindowComponent)
  FDB37.Init(?LOC:Region,Queue:FileDrop:8.ViewPosition,FDB37::View:FileDrop,Queue:FileDrop:8,Relate:ParRegion,ThisWindow)
  FDB37.Q &= Queue:FileDrop:8
  FDB37.AddSortOrder(PREG:DescriptionKey)
  FDB37.AddField(PREG:Description,FDB37.Q.PREG:Description)
  FDB37.AddField(PREG:PostalCode,FDB37.Q.PREG:PostalCode)
  FDB37.AddField(PROV:Description,FDB37.Q.PROV:Description)
  FDB37.AddField(PREG:RecordID,FDB37.Q.PREG:RecordID)
  FDB37.AddField(PROV:RecordID,FDB37.Q.PROV:RecordID)
  FDB37.AddUpdateField(PREG:RecordID,PAR:ParRegionID)
  ThisWindow.AddItem(FDB37.WindowComponent)
  FDB37.DefaultFill = 0
  FDB35.Init(?LOC:Role,Queue:FileDrop:6.ViewPosition,FDB35::View:FileDrop,Queue:FileDrop:6,Relate:RoleAlias2,ThisWindow)
  FDB35.Q &= Queue:FileDrop:6
  FDB35.AddSortOrder(ROL2:DescriptionKey)
  FDB35.AddField(ROL2:Description,FDB35.Q.ROL2:Description)
  FDB35.AddField(ROL2:RecordID,FDB35.Q.ROL2:RecordID)
  FDB35.AddUpdateField(ROL2:RecordID,PAR:DefaultRoleID)
  ThisWindow.AddItem(FDB35.WindowComponent)
  FDB35.DefaultFill = 0
  FDB39.Init(?LOC:Category,Queue:FileDrop:9.ViewPosition,FDB39::View:FileDrop,Queue:FileDrop:9,Relate:ParCategory,ThisWindow)
  FDB39.Q &= Queue:FileDrop:9
  FDB39.AddSortOrder(PCAT:DescriptionKey)
  FDB39.AddField(PCAT:Description,FDB39.Q.PCAT:Description)
  FDB39.AddField(PCAT:RecordID,FDB39.Q.PCAT:RecordID)
  FDB39.AddUpdateField(PCAT:RecordID,PAR:ParCategoryID)
  ThisWindow.AddItem(FDB39.WindowComponent)
  FDB24.Init(?LOC:PostalCountry,Queue:FileDrop:3.ViewPosition,FDB24::View:FileDrop,Queue:FileDrop:3,Relate:CountryAlias,ThisWindow)
  FDB24.Q &= Queue:FileDrop:3
  FDB24.AddSortOrder(COU1:DescriptionKey)
  FDB24.AddField(COU1:Description,FDB24.Q.COU1:Description)
  FDB24.AddField(COU1:RecordID,FDB24.Q.COU1:RecordID)
  FDB24.AddUpdateField(COU1:RecordID,PAR:PostalCountryID)
  ThisWindow.AddItem(FDB24.WindowComponent)
  FDB24.DefaultFill = 0
  FDB25.Init(?LOC:PhysicalCountry,Queue:FileDrop:4.ViewPosition,FDB25::View:FileDrop,Queue:FileDrop:4,Relate:Country,ThisWindow)
  FDB25.Q &= Queue:FileDrop:4
  FDB25.AddSortOrder(COU:DescriptionKey)
  FDB25.AddField(COU:Description,FDB25.Q.COU:Description)
  FDB25.AddField(COU:RecordID,FDB25.Q.COU:RecordID)
  FDB25.AddUpdateField(COU:RecordID,PAR:PhysicalCountryID)
  ThisWindow.AddItem(FDB25.WindowComponent)
  FDB25.DefaultFill = 0
    BRW16.Popup.AddItemMimic('&Print', ?Print)
  BRW10.AskProcedure = 5
  BRW14.AskProcedure = 6
  BRW31.AskProcedure = 7
  BRW33.AskProcedure = 8
  BRW42.AskProcedure = 9
  BRW8.AskProcedure = 10
  BRW16.AskProcedure = 11
  BRW41.AskProcedure = 12
  BRW48.AskProcedure = 13
     ?TabHeading{PROP:Text} = REPLACE(?NameTab{PROP:Text},'&','')
     ?TabTree{PROP:Ypos} = ?Sheet1{PROP:Ypos}
     ?TabTree{PROP:Height} = ?Sheet1{PROP:Height}
  BRW10.AddToolbarTarget(Toolbar)
  BRW14.AddToolbarTarget(Toolbar)
  BRW31.AddToolbarTarget(Toolbar)
  BRW33.AddToolbarTarget(Toolbar)
  BRW42.AddToolbarTarget(Toolbar)
  BRW8.AddToolbarTarget(Toolbar)
  BRW16.AddToolbarTarget(Toolbar)
  BRW41.AddToolbarTarget(Toolbar)
  BRW48.AddToolbarTarget(Toolbar)
  Toolbar.SetTarget(?TelephoneList)
    Do RebuildTabTreeQueue:30
  SELF.SetAlerts()
    ThisSecProc.SetFields()
      ?TelephoneList{PROP:FontColor} = ColorText:6#
      ?TelephoneList{PROP:Background} = ColorBackground:6#
      ?TelephoneList{PROP:SelectedColor} = ColorSelText:6#
      ?TelephoneList{PROP:SelectedFillColor} = ColorSelBackground:6#
      ?TelephoneList{PROPLIST:GRID} = ColorGrid:6#
      ?SignatoriesList{PROP:FontColor} = ColorText:6#
      ?SignatoriesList{PROP:Background} = ColorBackground:6#
      ?SignatoriesList{PROP:SelectedColor} = ColorSelText:6#
      ?SignatoriesList{PROP:SelectedFillColor} = ColorSelBackground:6#
      ?SignatoriesList{PROPLIST:GRID} = ColorGrid:6#
      ?List{PROP:FontColor} = ColorText:6#
      ?List{PROP:Background} = ColorBackground:6#
      ?List{PROP:SelectedColor} = ColorSelText:6#
      ?List{PROP:SelectedFillColor} = ColorSelBackground:6#
      ?List{PROPLIST:GRID} = ColorGrid:6#
      ?List:2{PROP:FontColor} = ColorText:6#
      ?List:2{PROP:Background} = ColorBackground:6#
      ?List:2{PROP:SelectedColor} = ColorSelText:6#
      ?List:2{PROP:SelectedFillColor} = ColorSelBackground:6#
      ?List:2{PROPLIST:GRID} = ColorGrid:6#
      ?List:3{PROP:FontColor} = ColorText:6#
      ?List:3{PROP:Background} = ColorBackground:6#
      ?List:3{PROP:SelectedColor} = ColorSelText:6#
      ?List:3{PROP:SelectedFillColor} = ColorSelBackground:6#
      ?List:3{PROPLIST:GRID} = ColorGrid:6#
      ?List:4{PROP:FontColor} = ColorText:6#
      ?List:4{PROP:Background} = ColorBackground:6#
      ?List:4{PROP:SelectedColor} = ColorSelText:6#
      ?List:4{PROP:SelectedFillColor} = ColorSelBackground:6#
      ?List:4{PROPLIST:GRID} = ColorGrid:6#
      ?List:5{PROP:FontColor} = ColorText:6#
      ?List:5{PROP:Background} = ColorBackground:6#
      ?List:5{PROP:SelectedColor} = ColorSelText:6#
      ?List:5{PROP:SelectedFillColor} = ColorSelBackground:6#
      ?List:5{PROPLIST:GRID} = ColorGrid:6#
      ?List:6{PROP:FontColor} = ColorText:6#
      ?List:6{PROP:Background} = ColorBackground:6#
      ?List:6{PROP:SelectedColor} = ColorSelText:6#
      ?List:6{PROP:SelectedFillColor} = ColorSelBackground:6#
      ?List:6{PROPLIST:GRID} = ColorGrid:6#
      ?List:7{PROP:FontColor} = ColorText:6#
      ?List:7{PROP:Background} = ColorBackground:6#
      ?List:7{PROP:SelectedColor} = ColorSelText:6#
      ?List:7{PROP:SelectedFillColor} = ColorSelBackground:6#
      ?List:7{PROPLIST:GRID} = ColorGrid:6#
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    
  PDSC:LOC:PL2:BirthDate.Kill
  PDSC:PAR:DateResolutionSigned.Kill
  PDSC:PAR:LastInstructedDate.Kill
  PDSC:PAR:RemoteAccessExpiry.Kill
  PDSC:PL:BirthDate.Kill
  PDSC:PL:GPASignedOn.Kill
  PDSC:PL:MarriageDate.Kill
  PDSC:PL:SpouseBirthDate.Kill
  PDSC:PL:TrustDate.Kill
  PDPC:LOC:PL2:BirthDate.Kill
  PDPC:PAR:DateResolutionSigned.Kill
  PDPC:PAR:LastInstructedDate.Kill
  PDPC:PAR:RemoteAccessExpiry.Kill
  PDPC:PL:BirthDate.Kill
  PDPC:PL:GPASignedOn.Kill
  PDPC:PL:MarriageDate.Kill
  PDPC:PL:SpouseBirthDate.Kill
  PDPC:PL:TrustDate.Kill
  ReturnValue = PARENT.Kill()
  
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:AccBank.Close
    Relate:Country.Close
    Relate:CountryAlias.Close
    Relate:DeedsOffice.Close
    Relate:DocFoxRelationship.Close
    Relate:DocScrnField.Close
    Relate:Entity.Close
    Relate:EntityAlias.Close
    Relate:EntityLang.Close
    Relate:Language.Close
    Relate:PTypeDef.Close
    Relate:ParCategory.Close
    Relate:ParFica.Close
    Relate:ParField.Close
    Relate:ParFileNote.Close
    Relate:ParGroup.Close
    Relate:ParLang.Close
    Relate:ParProduct.Close
    Relate:ParRegion.Close
    Relate:ParRel.Close
    Relate:ParShare.Close
    Relate:ParSign.Close
    Relate:ParTele.Close
    Relate:ParType.Close
    Relate:ParTypeAlias.Close
    Relate:Party.Close
    Relate:Province.Close
    Relate:RoleAlias2.Close
    Relate:Stage.Close
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.PrimeFields PROCEDURE

  CODE
    PAR:MaritalStatus = 'UNM'
    LOC:MaritalStatus = 'Unmarried'
    PAR:DefaultRoleID = CTL:ClientRoleID
    PAR:ClientFlag = GLO:ClientFlag
    PAR:InactiveFlag = 0
    PAR:ParCategoryID = 3
    PAR:UnmarriedStatus = 0
    IF GLO:RoleID
       PAR:DefaultRoleID = GLO:RoleID
    ELSE
       PAR:DefaultRoleID = CTL:ClientRoleID
    END
    
  PARENT.PrimeFields


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    If ThisSecProc.CheckAccess() Then Return RequestCancelled.
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled
  END
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
   IF Number = BRW10.AskProcedure
  
      IF CheckMatterConditions('T') THEN Return RequestCancelled.   ! PREVENT THE USER FROM CHANGING A TELEPHONE NUMBER IF THE CONDITION IS TRUE
  
   END
  
   ! 19/07/2018 PK Naidoo: FB Case 1683
   IF Number = BRW10.AskProcedure OR Number = BRW14.AskProcedure OR Number = BRW31.AskProcedure OR Number = BRW33.AskProcedure OR Number = BRW42.AskProcedure OR Number = BRW8.AskProcedure OR Number = BRW16.AskProcedure OR Number = BRW41.AskProcedure OR Number = BRW48.AskProcedure
  
      IF PAR:LockParty AND ~GLO:SupervisorFlag
  
         MESSAGE('This Party is currently locked and can only be edited by a user with Supervisor rights.', 'Party locked for editing', ICON:Exclamation)
         Return RequestCancelled
  
      END
  
   END
  
  
   ! 26/10/2011 - AT LEAST ALLOW THEM TO INSERT RECORDS
   IF Request <> InsertRecord
      IF CheckMatterConditions('A') THEN Return RequestCancelled.   ! PREVENT THE USER FROM CHANGING A TELEPHONE NUMBER IF THE CONDITION IS TRUE
   END
  
  
   ! TO AVOID THREADING ISSUE IN CLARION 5.5 WITH DELETE'S
   IF Request = DeleteRecord
      IF MESSAGE('Are you sure you want to delete this item?','Delete',ICON:Question,BUTTON:OK+BUTTON:Cancel,BUTTON:OK) = BUTTON:Cancel THEN Return RequestCancelled.
   END
  
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled
  ELSE
    GlobalRequest = Request
    EXECUTE Number
      BrowseCountry
      BrowseCountry
      BrowseParRegion
      BrowseParCategory
      UpdateParTele
      UpdateParSign
      UpdateParRel
      UpdateAccBank
      UpdateParGroup
      UpdateParFileNote
      UpdateParProduct
      UpdateParShare
      UpdateParFica
      BrowseLookup
      BrowseLookup
      BrowseLookup
      BrowseLookup
      BrowseLookup
      BrowseLookup
      BrowseLookup
      BrowseLookup
      BrowseLookup
    END
    ReturnValue = GlobalResponse
  END
  IF GlobalResponse=RequestCompleted AND (Request = DeleteRecord OR Request = ChangeRecord) AND Number = BRW10.AskProcedure

     DO ResortTheParTeleSorter

  END

  IF GlobalResponse=RequestCompleted AND Request = ChangeRecord AND Number = BRW48.AskProcedure


     DO SetFICAStatus


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
    OF ?PAR:IdentityDocumentType
!FB 3009
!      if PAR:IdentityDocumentType = 'P'
!        if PAR:PassportNumber AND ~PAR:IdentityNumber
!            PAR:IdentityNumber = PAR:PassportNumber
!        end
!        ?PAR:PassportNumber{PROP:ReadOnly} = True
!        ?PAR:PassportNumber{PROP:BackGround} = COLOR:Silver
!      else
!         ?PAR:PassportNumber{PROP:ReadOnly} = False
!         ?PAR:PassportNumber{PROP:BackGround} = COLOR:None
!      end
!FB 3009 END
    OF ?PL:Salutation
      ! pk here
    OF ?PL:DomiciledIn
        If ~(0) Then Cycle.
        Update(?)
        COU:Description = Contents(?)
        Access:Country.Fetch(COU:DescriptionKey)
        PL:DomiciledIn = COU:Description
        If COU:Description <> Contents(?)
          Select(?)
          Cycle
        .
    OF ?DomiciledInButton
      GlobalRequest = SelectRecord
      BrowseCountry
      IF GlobalResponse = RequestCompleted
         PL:DomiciledIn = COU:Description
         DISPLAY(?PL:DomiciledIn)
      END
    OF ?PL:DeedsRegistry
        If ~(0) Then Cycle.
        Update(?)
        DEO:Name = Contents(?)
        Access:DeedsOffice.Fetch(DEO:NameKey)
        PL:DeedsRegistry = DEO:Name
        If DEO:Name <> Contents(?)
          Select(?)
          Cycle
        .
    OF ?MarriageCountryButton
      GlobalRequest = SelectRecord
      BrowseCountry
      IF GlobalResponse = RequestCompleted
         PL:MarriageCountry= COU:Description
         DISPLAY(?PL:MarriageCountry)
      END
    OF ?PL:MarriageCountry
        If ~(0) Then Cycle.
        Update(?)
        COU:Description = Contents(?)
        Access:Country.Fetch(COU:DescriptionKey)
        PL:MarriageCountry = COU:Description
        If COU:Description <> Contents(?)
          Select(?)
          Cycle
        .
    OF ?PL:SpouseBirthDate
      
    OF ?EditSpousePartyButton
      !FB 3258
      ThisWindow.Update
      PROPSQLNext('Select OtherPartyID FROM ParRel WHERE PartyID='& PAR:RecordID &' AND RelationshipID = 1')
      IF ROW:Counter
         SAV:PAR:RecordID = PAR:RecordID
         SAV:PAR:DefaultLanguageID = PAR:DefaultLanguageID
         CLEAR(PAR:Record)
         PAR:RecordID = ROW:Counter
         IF ~Access:Party.TryFetch(PAR:PrimaryKey)
             GlobalRequest = ChangeRecord
             UpdateParty
         END
         CLEAR(PAR:Record)
         PAR:RecordID = SAV:PAR:RecordID
         IF ~Access:Party.TryFetch(PAR:PrimaryKey)
             PL:PartyID = SAV:PAR:RecordID
             PL:LanguageID = SAV:PAR:DefaultLanguageID
             Access:ParLang.TryFetch(PL:PartyLanguageKey)
         END
         ThisWindow.Reset
      END
!      ThisWindow.Update
!      PROPSQLNext('Select OtherPartyID FROM ParRel WHERE PartyID='& PAR:RecordID &' AND RelationshipID = 1')
!      IF ROW:Counter
!      
!         SAV:PAR:RecordID = PAR:RecordID
!         SAV:PAR:DefaultLanguageID = PAR:DefaultLanguageID
!      
!         CLEAR(PAR:Record)
!         PAR:RecordID = ROW:Counter
!         Set(PAR:PrimaryKey,PAR:PrimaryKey)   
!      
!         IF ~Access:Party.Next()
!             GlobalRequest = ChangeRecord
!             UpdateParty
!         ELSE
!             DEBUG('1 EditSpousePartyButton')
!         END
!      
!         CLEAR(PAR:Record)
!         PAR:RecordID = SAV:PAR:RecordID
!         IF ~Access:Party.TryFetch(PAR:PrimaryKey)
!             PL:PartyID = SAV:PAR:RecordID
!             PL:LanguageID = SAV:PAR:DefaultLanguageID
!             IF Access:ParLang.TryFetch(PL:PartyLanguageKey)
!                DEBUG('2 EditSpousePartyButton')
!             END
!         ELSE
!             DEBUG('3 EditSpousePartyButton')
!         END
!         ThisWindow.Reset
!      END
      !FB 3258 END
    OF ?SelecteSpousePartyButton
      !FB 3258
      ThisWindow.Update
                    GlobalRequest = SelectRecord
                    SelectPartyAlias
                    IF GlobalResponse = RequestCompleted
                     PROPSQL('INSERT ParRel (PartyID,OtherPartyID,RelationshipID) VALUES (' & PAR:RecordID & ',' & PAR1:RecordID & ',1)')
                     PROPSQL('INSERT ParRel (PartyID,OtherPartyID,RelationshipID) VALUES (' & PAR1:RecordID & ',' & PAR:RecordID & ',1)')
                     DO CheckAndLoadSpouseParty
                       BRW31.ResetSort(1)
                       DISPLAY
                    END
                    !FB 3258 END
    OF ?CreatePartyButton
            Do CreateSpouseParty
    OF ?CountryOfResidenceButton
      GlobalRequest = SelectRecord
      BrowseCountry
      IF GlobalResponse = RequestCompleted
         PAR:CountryOfResidence = COU:Description
         DISPLAY(?PAR:CountryOfResidence)
      END
    OF ?EditSpousePartyButton:2
      !Here second click
       !FB 3258
      ThisWindow.Update
      PROPSQLNext('Select OtherPartyID FROM ParRel WHERE PartyID='& PAR:RecordID &' AND RelationshipID = 1')
      IF ROW:Counter
         SAV:PAR:RecordID = PAR:RecordID
         SAV:PAR:DefaultLanguageID = PAR:DefaultLanguageID
         CLEAR(PAR:Record)
         PAR:RecordID = ROW:Counter
         IF ~Access:Party.TryFetch(PAR:PrimaryKey)
             GlobalRequest = ChangeRecord
             UpdateParty
         END
         CLEAR(PAR:Record)
         PAR:RecordID = SAV:PAR:RecordID
         IF ~Access:Party.TryFetch(PAR:PrimaryKey)
             PL:PartyID = SAV:PAR:RecordID
             PL:LanguageID = SAV:PAR:DefaultLanguageID
             Access:ParLang.TryFetch(PL:PartyLanguageKey)
         END
         ThisWindow.Reset
      END
    OF ?UpdateSpouseTaxDetailsButton
            PROPSQL('UPDATE Party SET' &|
                            ' TaxPayer = ''' & StripSQL(PAR:SpouseTaxPayer) & ''',' &|
                            ' TaxNumber = ''' & StripSQL(PAR:SpouseTaxNumber) & ''',' &|
                            ' AnnualIncome = ' & PAR:SpouseAnnualIncome & ',' &|
                            ' SAResident = ''' & StripSQL(PAR:SpouseSAResident) & ''',' &|
                            ' CountryOfResidence = ''' & StripSQL(PAR:SpouseCountryOfResidence) & ''',' &|
                            ' PassportNumber = ''' & StripSQL(PAR:SpousePassportNumber) & '''' &|
                            ' WHERE RecordID = ' & LOC:SpousePartyID)
      
      
               MESSAGE('Updated ' & LOC:SpouseMatterPrefix & ' - ' & LOC:SpousePartyName & '''s Tax Details.|','Tax Details',ICON:Exclamation)
      
               HIDE(?UpdateSpouseTaxDetailsButton)
      
    OF ?CreateAuditorPartyButton
          ThisWindow.Update
      
          IF ~PAR:AuditorName
              MESSAGE('You must enter the Auditor''s details first.|','Incomplete data',ICON:Exclamation)
              CYCLE
          END
          GLO:RecordID = CheckForDuplicateAddress(PAR:AuditorName,1)
          IF GLO:RecordID
             GLO:RecordID = 0
             CYCLE
          END
          CLEAR(ROW:Record)
          PROPSQLNext('SELECT MAX(RecordID) FROM Party')
          AuditorPartyID = ROW:Counter + 1
          AuditorMatterPrefix = GetMatterPrefix(PAR:AuditorName)
          LOC:AuditorSQLScript = 'INSERT Party' &|
                                  ' (RecordID,MatterPrefix,Name,MaritalStatus,BirthMonth,BirthDay,' &|
                                  ' InactiveFlag,DefaultRoleID,EntityID,PartyTypeID,DefaultLanguageID,PhysicalCountryID,PostalCountryID,DomiciliumFlag) ' &|
                                  ' VALUES (' &|
                                  AuditorPartyID & ',' &|
                                  '''' & AuditorMatterPrefix & ''',' &|
                                  '''' & StripSQL(PAR:AuditorName) & ''',' &|
                                  '''UNM'',' &|
                                     '0,' &|
                                     '0,' &|
                                  '0,' &|
                                  CTL:ClientRoleID & ',' &|
                                  CTL:PublicCompanyEntityID & ',' &|
                                  CTL:BusinessTypeID & ',' &|
                                  PAR:DefaultLanguageID & ',1,1,1)'
          PROPSQL(LOC:AuditorSQLScript)
          CLEAR(ROW:Record)
          RowCounter{PROP:SQL} = 'SELECT COUNT(1) FROM PARTY WHERE RecordID = ' & AuditorPartyID
          NEXT(RowCounter)
          IF ~ROW:Counter
             SETCLIPBOARD(LOC:AuditorSQLScript)
             MESSAGE('An error was encountered adding the Party to the Address Book from the Auditor Details tab.','Error adding Party',ICON:Hand)
             CYCLE
          ELSE
             IF PAR:DefaultLanguageID = CTL:AfrikaansID
                 AuditorSalutation = 'Geagte Menere'
             ELSE
                 AuditorSalutation = 'Dear Sirs'
             END
             CLEAR(ROW:Record)
             RowCounter{PROP:SQL} = 'SELECT MAX(RecordID) FROM ParLang'
             NEXT(RowCounter)
             AuditorParLangID = ROW:Counter + 1
             AuditorLanguageID =  PAR:DefaultLanguageID
             LOC:AuditorSQLScript = 'INSERT ParLang' &|
                     ' (RecordID,PartyID,LanguageID,Salutation,Name,PhysicalLine1,PostalLine1) ' &|
                     ' VALUES (' &|
                     AuditorParLangID & ',' &|
                     AuditorPartyID & ',' &|
                     AuditorLanguageID & ',' &|
                     '''' & StripSQL(AuditorSalutation) & ''',' &|
                     '''' & StripSQL(PAR:AuditorName) & ''',' &|
                      '''' & StripSQL(PAR:AuditorPhysical)& ''',' &|
                     '''' & StripSQL(PAR:AuditorPostal)& ''')'
             PROPSQL(LOC:AuditorSQLScript)
             PROPSQLNext('SELECT COUNT(1) FROM ParLang WHERE RecordID = ' & AuditorParLangID)
             IF ~ROW:Counter
                 SETCLIPBOARD(LOC:AuditorSQLScript)
                 MESSAGE('An error was encountered adding the Party Language (' & AuditorPartyID & ') to the List of Parties from the Quick Insert screen.','Error adding Party',ICON:Hand)
                  CYCLE
             ELSE
                IF AuditorLanguageID = CTL:AfrikaansID THEN AuditorLanguageID = CTL:EnglishID ELSE AuditorLanguageID = CTL:AfrikaansID.
                AuditorParLangID += 1
                LOC:AuditorSQLScript = 'INSERT ParLang' &|
                     ' (RecordID,PartyID,LanguageID,Salutation,Name,PhysicalLine1,PostalLine1) ' &|
                     ' VALUES (' &|
                     AuditorParLangID & ',' &|
                     AuditorPartyID & ',' &|
                     AuditorLanguageID & ',' &|
                     '''' & StripSQL(AuditorSalutation) & ''',' &|
                     '''' & StripSQL(PAR:AuditorName) & ''',' &|
                     '''' & StripSQL(PAR:AuditorPhysical)& ''',' &|
                     '''' & StripSQL(PAR:AuditorPostal)& ''')'
                PROPSQL(LOC:AuditorSQLScript)
!                IF PAR:AuditorContact
!                  LOC:AuditorSQLScript = 'insert into ParTele (PartyID,TelephoneTypeID,Number,Sorter,InternalFlag,DefaultEmailFlag) ' & |
!                   'SELECT ' & AuditorPartyID & ' , ' & |
!                   CTL:InvoiceEmailPhoneId & ' , ' & |
!                   '''' & PAR:AuditorContact& ''',' &|
!                   '(SELECT ISNULL((SELECT MAX(ISNULL(Sorter,0)) FROM ParTele WHERE PartyID = '& |
!                    AuditorPartyID & |
!                    ' AND TelephoneTypeID = ' & |
!                    CTL:InvoiceEmailPhoneId & |
!                    '),0)+1),0,1'
!                   PROPSQL(LOC:AuditorSQLScript)
!                END
                IF PAR:AuditorPhone
                   LOC:AuditorSQLScript = 'insert into ParTele (PartyID,TelephoneTypeID,Number,Sorter,InternalFlag,DefaultEmailFlag) ' & |
                   'SELECT ' & AuditorPartyID & ' , ' & |
                   CTL:WorkPhoneID & ' , ' & |
                   '''' & PAR:AuditorPhone& ''',' &|
                   '(SELECT ISNULL((SELECT MAX(ISNULL(Sorter,0)) FROM ParTele WHERE PartyID = '& |
                    AuditorPartyID & |
                    ' AND TelephoneTypeID = ' & |
                    CTL:WorkPhoneID & |
                    '),0)+1),0,0'
                   PROPSQL(LOC:AuditorSQLScript)
                END
                IF PAR:AuditorFax
                   LOC:AuditorSQLScript = 'insert into ParTele (PartyID,TelephoneTypeID,Number,Sorter,InternalFlag,DefaultEmailFlag) ' & |
                   'SELECT ' & AuditorPartyID & ' , ' & |
                   CTL:FaxPhoneID & ' , ' & |
                   '''' & PAR:AuditorFax& ''',' &|
                   '(SELECT ISNULL((SELECT MAX(ISNULL(Sorter,0)) FROM ParTele WHERE PartyID = '& |
                    AuditorPartyID & |
                    ' AND TelephoneTypeID = ' & |
                    CTL:FaxPhoneID & |
                    '),0)+1),0,0'
                   PROPSQL(LOC:AuditorSQLScript)
                END
                IF PAR:AuditorEmail
                   LOC:AuditorSQLScript = 'insert into ParTele (PartyID,TelephoneTypeID,Number,Sorter,InternalFlag,DefaultEmailFlag) ' & |
                   'SELECT ' & AuditorPartyID & ' , ' & |
                   CTL:EmailPhoneID & ' , ' & |
                   '''' & PAR:AuditorEmail& ''',' &|
                   '(SELECT ISNULL((SELECT MAX(ISNULL(Sorter,0)) FROM ParTele WHERE PartyID = '& |
                    AuditorPartyID & |
                    ' AND TelephoneTypeID = ' & |
                    CTL:EmailPhoneID & |
                    '),0)+1),0,1'
                   PROPSQL(LOC:AuditorSQLScript)
                END
                MESSAGE('Auditor successfully added to the address book')
             END
          END
    OF ?Insert:5
                  ! 19/07/2018 PK Naidoo: FB Case 1683
                  IF PAR:LockParty AND ~GLO:SupervisorFlag
      
                     MESSAGE('This Party is currently locked and can only be edited by a user with Supervisor rights.', 'Party locked for editing', ICON:Exclamation)
                     Return RequestCancelled
      
                  END
      
                  GlobalRequest = SelectRecord
                  BrowsePartyGrouping
                  If GlobalResponse = RequestCompleted
                     IF FstTag:PtrM(TAG:Group)
                        CLEAR(PGRO:Record)
                        PGRO:RecordID = FstTag:PtrM(TAG:Group)
                        LOOP
                          IF ~Access:PartyGrouping.TryFetch(PGRO:PrimaryKey)
                              GET(ParGroup,0)
                              PG:PartyID = PAR:RecordID
                              PG:GroupID = PGRO:RecordID
                              IF ~DUPLICATE(PG:PrimaryKey)
                                  Access:ParGroup.Insert
                              END
                              PGRO:RecordID = NxtTag:PtrM(TAG:Group)
                              IF ~PGRO:RecordID THEN BREAK.
                         END
                        END
                        NewTag:PtrM(TAG:Group)
                        BRW42.ResetFromFile
                        BRW42.PostNewSelection
                     ELSE
                        Access:PartyGrouping.TryFetch(PGRO:PrimaryKey)
                        GET(ParGroup,0)
                        PG:PartyID = PAR:RecordID
                        PG:GroupID = PGRO:RecordID
                        IF ~DUPLICATE(PG:PrimaryKey)
                            IF ~Access:ParGroup.Insert()
                                BRW42.ResetFromFile
                                BRW42.PostNewSelection
                            END
                        END
                     END
                  END
                  
                  RETURN LEVEL:Notify
    OF ?Delete:5
            ! 19/07/2018 PK Naidoo: FB Case 1683
            IF PAR:LockParty AND ~GLO:SupervisorFlag
        
               MESSAGE('This Party is currently locked and can only be edited by a user with Supervisor rights.', 'Party locked for editing', ICON:Exclamation)
               Return RequestCancelled
      
            END
    OF ?LOC:Matter
      Get(Matter:Queue,Choice())
      PAR:BillingMatterID = MATQ:RecordID
    OF ?List
      
      IF SAV:RelID <> PREL:RecordID
        SAV:RelID = PREL:RecordID
        PropSqlNext('Select Entity.JuristicFlag,DocFoxID FROM Party INNER JOIN Entity ON ENTITY.RecordID = PARTY.EntityID WHERE Party.RecordID = ' & PAR:RecordID)
        IF  ROW:Counter AND ROW:Description 
            PropSqlNext('Select 0,DocFoxID FROM Party WHERE RecordID = ' & PREL:OtherPartyID)
            IF  ROW:Description
              if DFR:DocFoxID  
               BRW31.Popup.DeleteItem('DocFoxLink')
               BRW31.Popup.AddItemMimic('DocFoxUnlink',?DocFoxUnlink)
              else
                BRW31.Popup.DeleteItem('DocFoxUnlink')
                BRW31.Popup.AddItemMimic('DocFoxLink',?DocFoxLink)
              end
            ELSE
                BRW31.Popup.DeleteItem('DocFoxUnlink')
                BRW31.Popup.DeleteItem('DocFoxLink')
            END
         ELSE
            BRW31.Popup.DeleteItem('DocFoxUnlink')
            BRW31.Popup.DeleteItem('DocFoxLink')
         END
      END
    OF ?DocFoxLink
                 IF EXISTS('DocFox.LegalSuite.exe')
                    RUN('DocFox.LegalSuite.exe "sqllogin='  & GLO:SQLLogin & '" party=' & PAR:RecordID & ' employee=' & CEM:RecordID&' relationship='&PREL:RecordID&' function=Link',1)
                    If ErrorCode()
                      Message(Error() & '||Error running program DocFox.LegalSuite.exe||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                    End
                  Else
                    Message('DocFox.LegalSuite.exe Not Found||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                  End
    OF ?DocFoxUnlink
                 IF EXISTS('DocFox.LegalSuite.exe')
                    RUN('DocFox.LegalSuite.exe "sqllogin='  & GLO:SQLLogin & '" party=' & PAR:RecordID & ' employee=' & CEM:RecordID&' relationship='&PREL:RecordID&' function=Unlink',1)
                    If ErrorCode()
                      Message(Error() & '||Error running program DocFox.LegalSuite.exe||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                    End
                  Else
                    Message('DocFox.LegalSuite.exe Not Found||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                  End
    OF ?DocFoxRelationshipList
        IF EXISTS('DocFox.LegalSuite.exe')
              RUN('DocFox.LegalSuite.exe "sqllogin='  & GLO:SQLLogin & '" party=' & PAR:RecordID & ' employee=' & CEM:RecordID&' function=listrelationships',1)
              If ErrorCode()
                Message(Error() & '||Error running program DocFox.LegalSuite.exe||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
              End
            Else
              Message('DocFox.LegalSuite.exe Not Found||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
            End
    OF ?SendToDocFox
                 IF EXISTS('DocFox.LegalSuite.exe')
                    RUN('DocFox.LegalSuite.exe "sqllogin='  & GLO:SQLLogin & '" party=' & PAR:RecordID & ' employee=' & CEM:RecordID&' function=create',1)
                    If ErrorCode()
                      Message(Error() & '||Error running program DocFox.LegalSuite.exe||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                    
                    
                    End
                        Do SetDocFoxVisibility
                  Else
                    Message('DocFox.LegalSuite.exe Not Found||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                  End
    OF ?CheckDocFox
      !DocFoxDL
                  IF EXISTS('DocFox.LegalSuite.exe')
                    RUN('DocFox.LegalSuite.exe "sqllogin='  & GLO:SQLLogin & '" party=' & PAR:RecordID & ' employee=' & CEM:RecordID&' function=download',1)
                    If ErrorCode()
                      Message(Error() & '||Error running program DocFox.LegalSuite.exe||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                    End
                    BRW48.ResetFromFile
                    BRW48.PostNewSelection
                    !Do SetDocFoxVisibility
                  Else
                    Message('DocFox.LegalSuite.exe Not Found||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                  End
    OF ?InviteDocFox
                 IF EXISTS('DocFox.LegalSuite.exe')
                    RUN('DocFox.LegalSuite.exe "sqllogin='  & GLO:SQLLogin & '" party=' & PAR:RecordID & ' employee=' & CEM:RecordID&' function=invite',1)
                    If ErrorCode()
                      Message(Error() & '||Error running program DocFox.LegalSuite.exe||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                    End
                        Do SetDocFoxVisibility
                  Else
                    Message('DocFox.LegalSuite.exe Not Found||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                  End
    OF ?RevokeDocFox
                 IF EXISTS('DocFox.LegalSuite.exe')
                    RUN('DocFox.LegalSuite.exe "sqllogin='  & GLO:SQLLogin & '" party=' & PAR:RecordID & ' employee=' & CEM:RecordID&' function=revoke',1)
                    If ErrorCode()
                      Message(Error() & '||Error running program DocFox.LegalSuite.exe||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                    End
                        Do SetDocFoxVisibility
                  Else
                    Message('DocFox.LegalSuite.exe Not Found||Phone LegalSuite for Assistance 086 171 1150','Error running program',ICON:Exclamation)
                  End
    OF ?CreateEmployerPartyButton
          ThisWindow.Update
      
          IF ~PAR:EmployerName
              MESSAGE('You must enter the Employer''s details first.|','Incomplete data',ICON:Exclamation)
              CYCLE
          END
          GLO:RecordID = CheckForDuplicateAddress(PAR:EmployerName,1)
          IF GLO:RecordID
             GLO:RecordID = 0
             CYCLE
          END
          CLEAR(ROW:Record)
          PROPSQLNext('SELECT MAX(RecordID) FROM Party')
          EmployerPartyID = ROW:Counter + 1
          EmployerMatterPrefix = GetMatterPrefix(PAR:EmployerName)
          LOC:EmployerSQLScript = 'INSERT Party' &|
                                  ' (RecordID,MatterPrefix,Name,MaritalStatus,BirthMonth,BirthDay,' &|
                                  ' InactiveFlag,DefaultRoleID,EntityID,PartyTypeID,DefaultLanguageID,PhysicalCountryID,PostalCountryID,DomiciliumFlag) ' &|
                                  ' VALUES (' &|
                                  EmployerPartyID & ',' &|
                                  '''' & EmployerMatterPrefix & ''',' &|
                                  '''' & StripSQL(PAR:EmployerName) & ''',' &|
                                  '''UNM'',' &|
                                     '0,' &|
                                     '0,' &|
                                  '0,' &|
                                  CTL:EmployerRoleID & ',' &|
                                  CTL:PublicCompanyEntityID & ',' &|
                                  CTL:BusinessTypeID & ',' &|
                                  PAR:DefaultLanguageID & ',1,1,1)'
          PROPSQL(LOC:EmployerSQLScript)
          CLEAR(ROW:Record)
          RowCounter{PROP:SQL} = 'SELECT COUNT(1) FROM PARTY WHERE RecordID = ' & EmployerPartyID
          NEXT(RowCounter)
          IF ~ROW:Counter
             SETCLIPBOARD(LOC:EmployerSQLScript)
             MESSAGE('An error was encountered adding the Party to the Address Book from the Employer Details tab.','Error adding Party',ICON:Hand)
             CYCLE
          ELSE
             IF PAR:DefaultLanguageID = CTL:AfrikaansID
                 EmployerSalutation = 'Geagte Menere'
             ELSE
                 EmployerSalutation = 'Dear Sirs'
             END
             CLEAR(ROW:Record)
             RowCounter{PROP:SQL} = 'SELECT MAX(RecordID) FROM ParLang'
             NEXT(RowCounter)
             EmployerParLangID = ROW:Counter + 1
             EmployerLanguageID =  PAR:DefaultLanguageID
             LOC:EmployerSQLScript = 'INSERT ParLang' &|
                     ' (RecordID,PartyID,LanguageID,Salutation,Name,PhysicalLine1,PostalLine1) ' &|
                     ' VALUES (' &|
                     EmployerParLangID & ',' &|
                     EmployerPartyID & ',' &|
                     EmployerLanguageID & ',' &|
                     '''' & StripSQL(EmployerSalutation) & ''',' &|
                     '''' & StripSQL(PAR:EmployerName) & ''',' &|
                      '''' & StripSQL(PAR:EmployerPhysical)& ''',' &|
                     '''' & StripSQL(PAR:EmployerPostal)& ''')'
             PROPSQL(LOC:EmployerSQLScript)
             PROPSQLNext('SELECT COUNT(1) FROM ParLang WHERE RecordID = ' & EmployerParLangID)
             IF ~ROW:Counter
                 SETCLIPBOARD(LOC:EmployerSQLScript)
                 MESSAGE('An error was encountered adding the Party Language (' & EmployerPartyID & ') to the List of Parties from the Quick Insert screen.','Error adding Party',ICON:Hand)
                  CYCLE
             ELSE
                IF EmployerLanguageID = CTL:AfrikaansID THEN EmployerLanguageID = CTL:EnglishID ELSE EmployerLanguageID = CTL:AfrikaansID.
                EmployerParLangID += 1
                LOC:EmployerSQLScript = 'INSERT ParLang' &|
                     ' (RecordID,PartyID,LanguageID,Salutation,Name,PhysicalLine1,PostalLine1) ' &|
                     ' VALUES (' &|
                     EmployerParLangID & ',' &|
                     EmployerPartyID & ',' &|
                     EmployerLanguageID & ',' &|
                     '''' & StripSQL(EmployerSalutation) & ''',' &|
                     '''' & StripSQL(PAR:EmployerName) & ''',' &|
                     '''' & StripSQL(PAR:EmployerPhysical)& ''',' &|
                     '''' & StripSQL(PAR:EmployerPostal)& ''')'
                PROPSQL(LOC:EmployerSQLScript)
!                IF PAR:EmployerContact
!                  LOC:EmployerSQLScript = 'insert into ParTele (PartyID,TelephoneTypeID,Number,Sorter,InternalFlag,DefaultEmailFlag) ' & |
!                   'SELECT ' & EmployerPartyID & ' , ' & |
!                   CTL:InvoiceEmailPhoneId & ' , ' & |
!                   '''' & PAR:EmployerContact& ''',' &|
!                   '(SELECT ISNULL((SELECT MAX(ISNULL(Sorter,0)) FROM ParTele WHERE PartyID = '& |
!                    EmployerPartyID & |
!                    ' AND TelephoneTypeID = ' & |
!                    CTL:InvoiceEmailPhoneId & |
!                    '),0)+1),0,1'
!                   PROPSQL(LOC:EmployerSQLScript)
!                END
                IF PAR:EmployerPhone
                   LOC:EmployerSQLScript = 'insert into ParTele (PartyID,TelephoneTypeID,Number,Sorter,InternalFlag,DefaultEmailFlag) ' & |
                   'SELECT ' & EmployerPartyID & ' , ' & |
                   CTL:WorkPhoneID & ' , ' & |
                   '''' & PAR:EmployerPhone& ''',' &|
                   '(SELECT ISNULL((SELECT MAX(ISNULL(Sorter,0)) FROM ParTele WHERE PartyID = '& |
                    EmployerPartyID & |
                    ' AND TelephoneTypeID = ' & |
                    CTL:WorkPhoneID & |
                    '),0)+1),0,0'
                   PROPSQL(LOC:EmployerSQLScript)
                END
                IF PAR:EmployerFax
                   LOC:EmployerSQLScript = 'insert into ParTele (PartyID,TelephoneTypeID,Number,Sorter,InternalFlag,DefaultEmailFlag) ' & |
                   'SELECT ' & EmployerPartyID & ' , ' & |
                   CTL:FaxPhoneID & ' , ' & |
                   '''' & PAR:EmployerFax& ''',' &|
                   '(SELECT ISNULL((SELECT MAX(ISNULL(Sorter,0)) FROM ParTele WHERE PartyID = '& |
                    EmployerPartyID & |
                    ' AND TelephoneTypeID = ' & |
                    CTL:FaxPhoneID & |
                    '),0)+1),0,0'
                   PROPSQL(LOC:EmployerSQLScript)
                END
                IF PAR:EmployerEmail
                   LOC:EmployerSQLScript = 'insert into ParTele (PartyID,TelephoneTypeID,Number,Sorter,InternalFlag,DefaultEmailFlag) ' & |
                   'SELECT ' & EmployerPartyID & ' , ' & |
                   CTL:EmailPhoneID & ' , ' & |
                   '''' & PAR:EmployerEmail& ''',' &|
                   '(SELECT ISNULL((SELECT MAX(ISNULL(Sorter,0)) FROM ParTele WHERE PartyID = '& |
                    EmployerPartyID & |
                    ' AND TelephoneTypeID = ' & |
                    CTL:EmailPhoneID & |
                    '),0)+1),0,1'
                   PROPSQL(LOC:EmployerSQLScript)
                END
                MESSAGE('Employer successfully added to the address book')
             END
          END
      
    OF ?UnlinkDeceasedPartyButton
        ThisWindow.Update
                    IF (PAR2:RecordID > 0)
                        !Change(?AutoComplete,PAR1:MatterPrefix)
                        ! PAR1:RecordID
                        PROPSQLNext('DELETE FROM ParRel WHERE PartyID = '&PAR:RecordID &' AND OtherPartyID = '&PAR2:RecordID&' AND RelationshipID = (Select RecordID from Relationship WHERE Description = ''Deceased Estate'')')
                        PROPSQLNext('DELETE FROM ParRel WHERE PartyID = '&PAR2:RecordID &' AND OtherPartyID = '&PAR:RecordID&' AND RelationshipID = (Select RecordID from Relationship WHERE Description = ''Deceased'')')
                        BRW31.ResetSort(1)
                        DO CheckAndLoadDeceasedParty
                        !HIDE(?CreateDeceasedPartyButton)
                        !Hide(?SelecteDeceasedPartyButton)
                        
                       
                       DISPLAY
                    END
    OF ?CreateDeceasedPartyButton
                  ThisWindow.Update
      
                  IF ~LOC:PL2:Name
                      MESSAGE('You must enter the Deceased''s details first.|','Incomplete data',ICON:Exclamation)
                      CYCLE
                  END
      
      
                  GLO:RecordID = CheckForDuplicateAddress(LOC:PL2:Name,1)
                  IF GLO:RecordID
                     GLO:RecordID = 0
                     CYCLE
                  END
                  IF LOC:PL2:IdentityNumber
                     GLO:RecordID = CheckForDuplicateAddress(LOC:PL2:IdentityNumber,2)
                     IF GLO:RecordID
                        GLO:RecordID = 0
                        CYCLE
                     END
                  END
      
                  
            
                  IF LOC:PL2:FirstName THEN LOC:PL2:Initials = CreateInitials(LOC:PL2:FirstName).
            
                  LOC:PAR2:Name = LEFT(LOC:PL2:Name & ' ' & LOC:PL2:Initials)
            
                  LOC:PAR2:Name = LOC:PAR2:Name & ' (' & LOC:PL2:FirstName & ')'
            
                  CLEAR(ROW:Record)
                  PROPSQLNext('Select RecordID from Role WHERE Description = ''Deceased''')
                  DeceasedID# = ROW:Counter
                  CLEAR(ROW:Record)
                  RowCounter{PROP:SQL} = 'SELECT MAX(RecordID) FROM Party'
                  NEXT(RowCounter)
                  LOC:PL2:PartyID = ROW:Counter + 1
                  PROPSQLNext('Select RecordID from Role WHERE Description = ''Deceased''')
                  !LOC:PL2:PartyTypeID = CTL:MaleTypeID
                  LOC:PAR2:MatterPrefix = GetMatterPrefix(LOC:PL2:Name)
                  LOC:DeceasedSQLScript = 'INSERT Party' &|
                                  ' (RecordID,MatterPrefix,Name,MaritalStatus,BirthMonth,BirthDay,IdentityNumber,' &|
                                  ' TaxPayer,TaxNumber,AnnualIncome,SAResident,CountryOfResidence,PassportNumber, ' &|
                                  ' InactiveFlag,DefaultRoleID,EntityID,PartyTypeID,DefaultLanguageID,PhysicalCountryID,PostalCountryID,DomiciliumFlag) ' &|
                                  ' VALUES (' &|
                                  LOC:PL2:PartyID & ',' &|
                                  '''' & LOC:PAR2:MatterPrefix & ''',' &|
                                  '''' & StripSQL(LOC:PAR2:Name) & ''',' &|
                                  '''UNM'',' &|
                                     '0,' &|
                                     '0,' &|
                                  '''' & StripSQL(LOC:PL2:IdentityNumber) & ''',' &|
                                  '''' & StripSQL(LOC:PAR2:TaxPayer) & ''',' &|
                                  '''' & StripSQL(LOC:PAR2:TaxNumber) & ''',' &|
                                  LOC:PAR2:AnnualIncome & ',' &|
                                  '''' & StripSQL(LOC:PAR2:SAResident) & ''',' &|
                                  '''' & StripSQL(LOC:PAR2:CountryOfResidence) & ''',' &|
                                  '''' & StripSQL(LOC:PAR2:PassportNumber) & ''',' &|
                                  '0,' &|
                                  DeceasedID# & ',' &|
                                  CTL:AdultEntityID & ',' &|
                                  LOC:PAR2:PartyTypeID & ',' &|
                                  PAR:DefaultLanguageID & ',1,1,1)'
                  
            
                  PROPSQL(LOC:DeceasedSQLScript)
            
      
            
            
            
            
                  CLEAR(ROW:Record)
                  RowCounter{PROP:SQL} = 'SELECT COUNT(1) FROM PARTY WHERE RecordID = ' & LOC:PL2:PartyID
                  NEXT(RowCounter)
                  IF ~ROW:Counter
                      SETCLIPBOARD(LOC:DeceasedSQLScript)
                      MESSAGE('An error was encountered adding the Party to the Address Book from the Marital Details tab.Technical Support: Check CB','Error adding Party',ICON:Hand)
                      CYCLE
                  ELSE
                     IF LOC:PAR2:PartyTypeID = 1
                        IF PAR:DefaultLanguageID = CTL:AfrikaansID
                           LOC:PL2:Title = 'Mnr'
                           LOC:PL2:Salutation = 'Geagte ' & LOC:PL2:Title & ' ' & LOC:Name
                        ELSE
                           LOC:PL2:Title = 'Mr'
                           LOC:PL2:Salutation = 'Dear ' & LOC:PL2:Title & ' ' & LOC:Name
                        END
                     ELSIF LOC:PAR2:PartyTypeID = 2
                        IF PAR:DefaultLanguageID = CTL:AfrikaansID
                           LOC:PL2:Title = 'Mev'
                           LOC:PL2:Salutation = 'Geagte ' & LOC:PL2:Title & ' ' & LOC:Name
                        ELSE
                           LOC:PL2:Title = 'Ms'
                           LOC:PL2:Salutation = 'Dear ' & LOC:PL2:Title & ' ' & LOC:Name
                        END
                     ELSE
                        IF PAR:DefaultLanguageID = CTL:AfrikaansID
                           LOC:PL2:Salutation = 'Geagte Menere'
                        ELSE
                           LOC:PL2:Salutation = 'Dear Sirs'
                        END
                     END
      
            
                     CLEAR(ROW:Record)
                     RowCounter{PROP:SQL} = 'SELECT MAX(RecordID) FROM ParLang'
                     NEXT(RowCounter)
                     LOC:PL2:ParLangID = ROW:Counter + 1
      
      
                     LOC:PL2:LanguageID =  PAR:DefaultLanguageID
            
            
                     LOC:DeceasedSQLScript = 'INSERT ParLang' &|
                                     ' (RecordID,PartyID,LanguageID,BirthDate,Initials,Salutation,Title,Name,FirstName,IdentityNumber) ' &|                               
                                     ' VALUES (' &|
                                     LOC:PL2:ParLangID & ',' &|
                                     LOC:PL2:PartyID & ',' &|
                                     LOC:PL2:LanguageID & ',' &|
                                     LOC:PL2:BirthDate & ',' &|
                                     '''' & StripSQL(LOC:PL2:Initials) & ''',' &|
                                     '''' & StripSQL(LOC:PL2:Salutation) & ''',' &|
                                     '''' & LOC:PL2:Title & ''',' &|
                                     '''' & StripSQL(LOC:PL2:Name) & ''',' &|
                                     '''' & StripSQL(LOC:PL2:FirstName) & ''',' &|
                                     '''' & StripSQL(LOC:PL2:IdentityNumber) & ''')'
                     PROPSQL(LOC:DeceasedSQLScript)
                     PROPSQLNext('SELECT COUNT(1) FROM ParLang WHERE RecordID = ' & LOC:PL2:ParLangID)
                     IF ~ROW:Counter
                         SETCLIPBOARD(LOC:DeceasedSQLScript)
                         MESSAGE('An error was encountered adding the Party Language (' & LOC:PL2:PartyID & ') to the List of Parties from the Quick Insert screen.||Technical Support: Check CB','Error adding Party',ICON:Hand)
                          CYCLE
                     ELSE
                        IF LOC:PL2:LanguageID = 1 THEN LOC:PL2:LanguageID = 2 ELSE LOC:PL2:LanguageID = 1.
                        LOC:PL2:ParLangID += 1
      
                        LOC:DeceasedSQLScript = 'INSERT ParLang' &|
                                     ' (RecordID,PartyID,LanguageID,BirthDate,Initials,Salutation,Title,Name,FirstName,IdentityNumber) ' &|                               
                                     ' VALUES (' &|
                                     LOC:PL2:ParLangID & ',' &|
                                     LOC:PL2:PartyID & ',' &|
                                     LOC:PL2:LanguageID & ',' &|
                                     LOC:PL2:BirthDate & ',' &|
                                     '''' & StripSQL(LOC:PL2:Initials) & ''',' &|
                                     '''' & StripSQL(LOC:PL2:Salutation) & ''',' &|
                                     '''' & LOC:PL2:Title & ''',' &|
                                     '''' & StripSQL(LOC:PL2:Name) & ''',' &|
                                     '''' & StripSQL(LOC:PL2:FirstName) & ''',' &|
                                     '''' & StripSQL(LOC:PL2:IdentityNumber) & ''')'
                     PROPSQL(LOC:DeceasedSQLScript)
                     END
      
                     ! ADD PL2: RELATIONSHIP
                     PROPSQLNext('INSERT ParRel (PartyID,OtherPartyID,RelationshipID) VALUES (' & PAR:RecordID & ',' & LOC:PL2:PartyID & ',(Select RecordID from Relationship WHERE Description = ''Deceased Estate''))')
                     PROPSQLNext('INSERT ParRel (PartyID,OtherPartyID,RelationshipID) VALUES (' & LOC:PL2:PartyID & ',' & PAR:RecordID & ',(Select RecordID from Relationship WHERE Description = ''Deceased''))')
      
                     MESSAGE('Added ' & LOC:PAR2:MatterPrefix & ' - ' & LOC:PAR2:Name & ' to the Address Book.|','New Entry',ICON:Exclamation)
                     
                     DO CheckAndLoadDeceasedParty
                     BRW31.ResetSort(1)
                       !Select(?ToDoNoteBrowse)
                     Display
                  END
    OF ?SelecteDeceasedPartyButton
                  ThisWindow.Update
                    GlobalRequest = SelectRecord
                    SelectPartyAlias
                    IF GlobalResponse = RequestCompleted
                       !Change(?AutoComplete,PAR1:MatterPrefix)
                     ! PAR1:RecordID
                     PROPSQLNext('INSERT ParRel (PartyID,OtherPartyID,RelationshipID) VALUES (' & PAR:RecordID & ',' & PAR1:RecordID & ',(Select RecordID from Relationship WHERE Description = ''Deceased Estate''))')
                     PROPSQLNext('INSERT ParRel (PartyID,OtherPartyID,RelationshipID) VALUES (' & PAR1:RecordID & ',' & PAR:RecordID & ',(Select RecordID from Relationship WHERE Description = ''Deceased''))')
                     DO CheckAndLoadDeceasedParty
                     !HIDE(?CreateDeceasedPartyButton)
                     !Hide(?SelecteDeceasedPartyButton)
                       BRW31.ResetSort(1)
                       !Select(?ToDoNoteBrowse)
                       DISPLAY
                    END
    OF ?OK
        IF CheckMatterConditions('A') THEN CYCLE.
      
        IF ThisWindow.Request = InsertRecord THen DO SetFICAStatus.
        
        If PAR:TaxPayer <> 'Y' Then PAR:TaxNumber = ''.
        !FB 3009
        !IF PAR:IdentityDocumentType= 'P'
        !  PAR:PassportNumber = PAR:IdentityNumber
        !END
        !FB 3009 END
        COR# = 10
        If Upper(PAR:CountryOfResidence) = 'NAMIBIA' Then COR# = 12.
        If PAR:TaxNumber
          If Len(PAR:TaxNumber) <> COR#
            Message('According to the Country of residence the Length of the Tax Number has to be exactly ' & COR# & ' characters||Please check the Tax Number','Invalid Tax Number?',ICON:Exclamation)
            Select(?PAR:TaxNumber)
            Cycle
          End
        End
      
        If PAR:SpouseTaxPayer <> 'Y' Then PAR:SpouseTaxNumber = ''.
        If PAR:EntityID < 2 And PAR:MaritalStatus = 'INC'
          SpouseCOR# = 10
          If PAR:SpouseSAResident <> 'Y' AND Upper(PAR:SpouseCountryOfResidence) = 'NAMIBIA' Then SpouseCOR# = 12.
          If PAR:SpouseTaxNumber
            If Len(PAR:SpouseTaxNumber) <> SpouseCOR#
              Message('According to the Country of residence the Length of the Tax Number has to be exactly ' & SpouseCOR# & ' characters||PAR:SpouseTaxPayer','Invalid Tax Number?',ICON:Exclamation)
              Select(?PAR:SpouseTaxNumber)
              Cycle
            End
          End
        End
      
        If PAR:VATNumber
          If Len(PAR:VATNumber) <> COR#
            Message('According to the Country of residence the Length of the VAT Number has to be exactly ' & COR# & ' characters||Please check the VAT Number','Invalid Tax Number?',ICON:Exclamation)
            Select(?PAR:VATNumber)
            Cycle
          End
        End
        IF PAR:EntityID AND PAR:PartyTypeID = 17
            IF ~LOC:PL2:Name
                Message('Please click on the Deceased Party tab and complete the Deceased Party�s details <13,10> -- OR -- <13,10> select the Deceased Party that is linked to this Deceased Estate if the Deceased Party exists in the Address Book','Deceased Party Required',ICON:Exclamation)
                Select(?DeceasedTab)
                    Cycle
            ELSE
                Do SaveDeceasedParty
            END
            !PropSQLNext('Select top 1 ParRel.OtherPartyId from ParRel INNER JOIN Relationship ON Relationship.Description = ''Deceased Estate'' AND Relationship.RecordID = ParRel.RelationshipID WHERE ParRel.PartyID =' & PAR:RecordID)
            !
            !IF ~(ROW:Counter > 0)
            !    Do Save
            !    Message('Please Select a Deceased Party or Complete the Deceased Partys Details before closing','Deceased Party Required',ICON:Exclamation)
            !    Cycle
            !END
        END
        !FB 3477
        IF (PAR:EntityID < 3 OR ENT1:Category = 1) AND ~(PAR:MaritalStatus='UNM') AND PL:SpouseName
          PROPSQLNext('Select OtherPartyID FROM ParRel WHERE PartyID='& PAR:RecordID &' AND RelationshipID = 1')
          IF ~ROW:Counter
              DO CreateSpouseParty
              DEBUG('Checking Party was Created')
              PROPSQLNext('Select OtherPartyID FROM ParRel WHERE PartyID='& PAR:RecordID &' AND RelationshipID = 1')
              IF ~ROW:Counter
                DEBUG('Cycling')
                Cycle
              END
          END
          PROPSQLNext('Select OtherPartyID FROM ParRel WHERE PartyID='& PAR:RecordID &' AND RelationshipID = 1')
          IF ROW:Counter
              PROPSQL('UPDATE Party SET' &|
                                  ' SpouseTaxPayer = ''' & StripSQL(PAR:TaxPayer) & ''',' &|
                                  ' SpouseTaxNumber = ''' & StripSQL(PAR:TaxNumber) & ''',' &|
                                  ' SpouseAnnualIncome = ' & PAR:AnnualIncome & ',' &|
                                  ' SpouseSAResident = ''' & StripSQL(PAR:SAResident) & ''',' &|
                                  ' SpouseCountryOfResidence = ''' & StripSQL(PAR:CountryOfResidence) & ''',' &|
                                  ' SpousePassportNumber = ''' & StripSQL(PAR:PassportNumber) & '''' &|
                                  ' WHERE RecordID = ' & ROW:Counter)
          END
        END
        !FB 3477 END
        
      
      
        
  INCLUDE('UpdateMatterExtraScreenSource','OK Button')


  IF ~PAR:RemoteAccessPassword THEN PAR:RemoteAccessPassword = PAR:RecordID.  ! USE THIS AS THE DEFAULT PASSWORD

  IF ENT1:RecordID > 2 AND ~(ENT1:RecordID = 16)

     IF PL:AlternativeName
        PAR:Name = PL:AlternativeName & ' (' & PL:Name & ')'
     ELSE
        PAR:Name = PL:Name
     END

  ELSE

     PAR:Name = LEFT(PL:Name & ' ' & PL:Initials)

     IF PL:AlternativeName
        PAR:Name = PAR:Name & ' (' & PL:AlternativeName & ')'
     ELSIF PL:FirstName
        PAR:Name = PAR:Name & ' (' & PL:FirstName & ')'
     END
  END

  IF ~PAR:ParBankId AND PAR:RecordID
      CLEAR(ROW:Record)
      RowCounter{PROP:SQL} = 'SELECT RecordID FROM AccBank WHERE AccountID = ' & PAR:RecordID & ' AND AccountType = ''M'''
      NEXT(RowCounter)
      PAR:ParBankId = ROW:Counter
  END

  DO UpdateScreenFields

    OF ?ApplyButton
        IF CheckMatterConditions('A') THEN CYCLE.
      
    OF ?AddButton
                        GlobalRequest = SelectRecord
                        GLO:ExtraScreenType = 'P'
                        SelectDocScrn
                        IF GlobalResponse = RequestCompleted
                           CLEAR(PEF:Record)
                           GET(ParField,0)
                           PEF:DocScreenID = DS:RecordID
                           PEF:PartyID = PAR:RecordID
      
                           IF ~DUPLICATE(PEF:PrimaryKey)
                               CLEAR(PEF:Record)
                               PEF:DocScreenID = DS:RecordID
                               PEF:PartyID = PAR:RecordID
                               IF ~Access:ParField.Insert()
                                   DO DisplayExtraScreens
                               END
      
                               DO RebuildTabTreeQueue:30
      
                           END
      
      
                        END
    ELSE
    INCLUDE('UpdateMatterExtraScreenSource','TakeAccepted')
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?SelectEntityButton
      ThisWindow.Update
       GlobalRequest = SelectRecord                   ! Set Action for Lookup
       BrowseEntity
       IF GlobalResponse = RequestCompleted           ! IF Lookup completed
         PAR:EntityID = ENT:RecordID
      
         FDB36.ResetQueue(True)
         FDB36.TakeNewSelection
      
         Post(EVENT:ACCEPTED,?LOC:Entity)
       .
    OF ?SelectPartyTypeButton
      ThisWindow.Update
       GlobalRequest = SelectRecord                   ! Set Action for Lookup
       BrowsePartyType
       IF GlobalResponse = RequestCompleted           ! IF Lookup completed
         PAR:PartyTypeID=PT:RecordID
         FDB9.ResetQueue(True)
         Post(EVENT:ACCEPTED,?LOC:PartyType)
       .
    OF ?SelectRoleButton
      ThisWindow.Update
       GlobalRequest = SelectRecord                   ! Set Action for Lookup
       BrowseRole
       IF GlobalResponse = RequestCompleted           ! IF Lookup completed
         PAR:DefaultRoleID=ROL:RecordID
         FDB35.ResetQueue(True)
         Post(EVENT:ACCEPTED,?LOC:Role)
       .
      
    OF ?PAR:MatterPrefix
            PAR:MatterPrefix = StripFileRefCharacters(PAR:MatterPrefix)
            DISPLAY(?PAR:MatterPrefix)
      
            CLEAR(ROW:Record)
            RowCounter{PROP:SQL} = 'Select 0,Name FROM Party WHERE MatterPrefix = ''' & PAR:MatterPrefix & ''' AND RecordID <> ' & PAR:RecordID
            NEXT(RowCounter)
            IF ROW:Description
               MESSAGE('An existing entry  (' & ROW:Description & ') already has this Code.','Duplicate Code',ICON:Exclamation)
               SELECT(?)
               CYCLE
            END
    OF ?PL:Name
         IF SAV:PartyName                     ! CHECK IF THE USER IS CHANGING THE NAME FOR AN EXISTING CLIENT AND WARN
            IF ~(SAV:PartyName = PL:Name)
                 SAV:PartyName = ''   ! ONLY WARN ONCE
                 CLEAR(ROW:Record)
                 RowCounter{PROP:SQL} = 'SELECT COUNT(1) FROM Matter WHERE ClientID = ' & PAR:RecordID
                 NEXT(RowCounter)
                 IF ROW:Counter
                     IF MESSAGE('You have changed the details of a Party who is a Client in a number of Matters.||This could confuse other Users and change the Client linked to other Matters.||Are you sure you want to continue?|','Warning',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = Button:No
                        !FB 1735
                        CLEAR(PL:Record)
                        PL:LanguageID = PAR:DefaultLanguageID
                        PL:PartyID = PAR:RecordID
                        Access:ParLang.Fetch(PL:PartyLanguageKey)
                        !FB 1735 END
                        POST(EVENT:Accepted,?Cancel)
                     END
                 END
            END
         END

!jess

         IF ENT1:RecordID < 2 OR ENT1:RecordID = 16
            IF PL:Name AND ~PL:SpouseName AND PAR:MaritalStatus = 'INC'
               PL:SpouseName = PL:Name
            END
         END
      
         DO CheckIfDuplicateName
    OF ?PL:FirstName
      IF ~PL:Initials
          PL:Initials = CreateInitials(PL:FirstName)
          DISPLAY(?PL:Initials)
      END
    OF ?PL:Title
       DO MakeSalutation
    OF ?PL:IdentityNumber
       IF (ENT1:RecordID < 2 OR ENT1:RecordID = 16) AND PL:IdentityNumber
      
          PL:IdentityNumber = StripNumbers(PL:IdentityNumber)
      
          IF ~PL:BirthDate AND LEN(PL:IdentityNumber) = 13
              PL:BirthDate = DATE(SUB(PL:IdentityNumber,3,2),SUB(PL:IdentityNumber,5,2),SUB(PL:IdentityNumber,1,2))
              IF YEAR(PL:BirthDate) >= YEAR(Today())    ! MUST BE 1900'S
                 PL:BirthDate = DATE(SUB(PL:IdentityNumber,3,2),SUB(PL:IdentityNumber,5,2),'19' & SUB(PL:IdentityNumber,1,2))
              END
      
              IF ~PAR:BirthMonth THEN PAR:BirthMonth = MONTH(PL:BirthDate).
              IF ~PAR:BirthDay THEN PAR:BirthDay = DAY(PL:BirthDate).
      
              SELECT(?PL:PostalLine1)
          END
      
          IF LEN(PL:IdentityNumber) <> 13
             IF QuickWindow{Prop:AcceptAll} = False 
                MESSAGE('There are ' & LEN(PL:IdentityNumber)  & ' digits in the Identity Number.||Are you sure this is correct?','Warning',ICON:Exclamation)
             END
          ELSE
             PL:IdentityNumber = FORMAT(PL:IdentityNumber,@P###### #### ## #P)
          END
          DISPLAY
       END
      
       DO CheckIfDuplicateID
    OF ?PL:BirthDate
       IF (ENT1:RecordID < 2 OR ENT1:RecordID = 16)
        IF PL:BirthDate
            IF ~PAR:BirthMonth THEN PAR:BirthMonth = MONTH(PL:BirthDate).
            IF ~PAR:BirthDay THEN PAR:BirthDay = DAY(PL:BirthDate).
            ?Group14{PROP:Disable} = False
            ?PAR:BirthdaySMSFlag{PROP:Disable} = False
            ?PAR:BirthDay{PROP:Disable} = False
            ?LOC:BirthMonth{PROP:Disable} = False
        ELSE
            PAR:BirthdaySMSFlag = 0
            ?PAR:BirthdaySMSFlag{PROP:Disable} = True
            ?PAR:BirthDay{PROP:Disable} = True
            ?LOC:BirthMonth{PROP:Disable} = True
            ?Group14{PROP:Disable} = True
        END
       END
      
    OF ?PL:Salutation
      
    OF ?PL:PostalLine1
      IF QuickWindow{Prop:AcceptAll} = False
         IF ~PL:PhysicalLine1 THEN PL:PhysicalLine1 = PL:PostalLine1;DISPLAY.
      END
    OF ?PL:PostalLine2
      IF QuickWindow{Prop:AcceptAll} = False
         IF ~PL:PhysicalLine2 THEN PL:PhysicalLine2 = PL:PostalLine2;DISPLAY.
      END
    OF ?PL:PostalLine3
      IF QuickWindow{Prop:AcceptAll} = False
         IF ~PL:PhysicalLine3 THEN PL:PhysicalLine3 = PL:PostalLine3;DISPLAY.
      END
    OF ?PL:PostalCode
      IF QuickWindow{Prop:AcceptAll} = False
         IF ~PL:PhysicalCode THEN PL:PhysicalCode = PL:PostalCode;DISPLAY.
         IF PL:PostalCode AND ~PAR:ParRegionID
      
            PAR:ParRegionID = GetParRegionID(PL:PostalCode)
      
            IF PAR:ParRegionID THEN ThisWindow.Reset(1).
      
      
         END
      END
    OF ?PAR:PostalCountryID
      IF QuickWindow{Prop:AcceptAll} = False
        IF PAR:PostalCountryID OR ?PAR:PostalCountryID{Prop:Req}
          COU:RecordID = PAR:PostalCountryID
          IF Access:Country.TryFetch(COU:PrimaryKey)
            IF SELF.Run(1,SelectRecord) = RequestCompleted
              PAR:PostalCountryID = COU:RecordID
            ELSE
              SELECT(?PAR:PostalCountryID)
              CYCLE
            END
          END
        END
      END
      ThisWindow.Reset()
    OF ?CallLookup
      ThisWindow.Update
      COU:RecordID = PAR:PostalCountryID
      IF SELF.Run(1,SelectRecord) = RequestCompleted
        PAR:PostalCountryID = COU:RecordID
      END
      ThisWindow.Reset(1)
    OF ?PL:PhysicalCode
         IF PL:PhysicalCode AND ~PAR:ParRegionID
      
            PAR:ParRegionID = GetParRegionID(PL:PhysicalCode)
      
            IF PAR:ParRegionID THEN ThisWindow.Reset(1).
      
         END
      
    OF ?PAR:PhysicalCountryID
      IF QuickWindow{Prop:AcceptAll} = False
        IF PAR:PhysicalCountryID OR ?PAR:PhysicalCountryID{Prop:Req}
          COU:RecordID = PAR:PhysicalCountryID
          IF Access:Country.TryFetch(COU:PrimaryKey)
            IF SELF.Run(1,SelectRecord) = RequestCompleted
              PAR:PhysicalCountryID = COU:RecordID
            ELSE
              SELECT(?PAR:PhysicalCountryID)
              CYCLE
            END
          END
        END
      END
      ThisWindow.Reset()
    OF ?CallLookup:2
      ThisWindow.Update
      COU:RecordID = PAR:PhysicalCountryID
      IF SELF.Run(1,SelectRecord) = RequestCompleted
        PAR:PhysicalCountryID = COU:RecordID
      END
      ThisWindow.Reset(1)
    OF ?Delete
      ThisWindow.Update
      
      
    OF ?LOC:MaritalStatus
            EXECUTE ?LOC:MaritalStatus{PROP:Selected}
                     PAR:MaritalStatus = 'UNM'
                     PAR:MaritalStatus = 'OUT'
                     PAR:MaritalStatus = 'INC'
                     PAR:MaritalStatus = 'FOR'
                     PAR:MaritalStatus = 'CUI'
                     PAR:MaritalStatus = 'CUO'
                     PAR:MaritalStatus = 'OTM'
                 ELSE
                     PAR:MaritalStatus = 'UNM'
            END
    OF ?LookupLibraryButton
      ThisWindow.Update
      GLO:TooltipCategory = ?PL:MaritalDescription{PROP:Tooltip}
      IF GLO:TooltipCategory
      
         FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
         IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
      
         SAV:PROP:SelStart# = ?PL:MaritalDescription{PROP:SelStart}
         GLO:TooltipContents = ?PL:MaritalDescription{PROP:ScreenText}
         GlobalRequest = SelectRecord
         BrowseLookup
         IF GlobalResponse = RequestCompleted
            LIB:Description = ReplaceTextBoxFields(LIB:Description,0,-1,-1,0)
            IF PL:MaritalDescription     ! IF THERE ALREADY IS TEXT IN THIS FIELD
               IF SAV:PROP:SelStart#  >= LEN(PL:MaritalDescription) ! THE CURSOR IS AT THE END
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                     PL:MaritalDescription = LIB:Description
                     PL:MaritalDescription =  PL:MaritalDescription & LIB:Description
                  END
               ELSE
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                     PL:MaritalDescription = LIB:Description
                     PL:MaritalDescription =  SUB(Contents(?PL:MaritalDescription),1,SAV:PROP:SelStart#-1) & LIB:Description & SUB(Contents(?PL:MaritalDescription),SAV:PROP:SelStart#,1000)
                  END
               END
            ELSE
              PL:MaritalDescription = LIB:Description
            END
            DISPLAY(?PL:MaritalDescription)
            SELECT(?PL:MaritalDescription,SAV:PROP:SelStart# + LEN(LIB:Description))
         END
         CLEAR(GlobalRequest)
      ELSE
         MESSAGE('This Field does not have a Tooltip.||Unable to display the lookup library.','Program Error',ICON:Exclamation)
      END
      
      
      
      
    OF ?LookupLibraryButton:5
      ThisWindow.Update
      GLO:TooltipCategory = ?PL:MarriagePlace{PROP:Tooltip}
      IF GLO:TooltipCategory
      
         FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
         IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
      
         SAV:PROP:SelStart# = ?PL:MarriagePlace{PROP:SelStart}
         GLO:TooltipContents = ?PL:MarriagePlace{PROP:ScreenText}
         GlobalRequest = SelectRecord
         BrowseLookup
         IF GlobalResponse = RequestCompleted
            LIB:Description = ReplaceTextBoxFields(LIB:Description,0,-1,-1,0)
            IF PL:MarriagePlace     ! IF THERE ALREADY IS TEXT IN THIS FIELD
               IF SAV:PROP:SelStart#  >= LEN(PL:MarriagePlace) ! THE CURSOR IS AT THE END
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                     PL:MarriagePlace = LIB:Description
                     PL:MarriagePlace =  PL:MarriagePlace & LIB:Description
                  END
               ELSE
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                     PL:MarriagePlace = LIB:Description
                     PL:MarriagePlace =  SUB(Contents(?PL:MarriagePlace),1,SAV:PROP:SelStart#-1) & LIB:Description & SUB(Contents(?PL:MarriagePlace),SAV:PROP:SelStart#,1000)
                  END
               END
            ELSE
              PL:MarriagePlace = LIB:Description
            END
            DISPLAY(?PL:MarriagePlace)
            SELECT(?PL:MarriagePlace,SAV:PROP:SelStart# + LEN(LIB:Description))
         END
         CLEAR(GlobalRequest)
      ELSE
         MESSAGE('This Field does not have a Tooltip.||Unable to display the lookup library.','Program Error',ICON:Exclamation)
      END
      
      
      
      
    OF ?LookupLibraryButton:3
      ThisWindow.Update
      GLO:TooltipCategory = ?PL:DeedsRegistry{PROP:Tooltip}
      IF GLO:TooltipCategory
      
         FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
         IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
      
         SAV:PROP:SelStart# = ?PL:DeedsRegistry{PROP:SelStart}
         GLO:TooltipContents = ?PL:DeedsRegistry{PROP:ScreenText}
         GlobalRequest = SelectRecord
         BrowseLookup
         IF GlobalResponse = RequestCompleted
            LIB:Description = ReplaceTextBoxFields(LIB:Description,0,-1,-1,0)
            IF PL:DeedsRegistry     ! IF THERE ALREADY IS TEXT IN THIS FIELD
               IF SAV:PROP:SelStart#  >= LEN(PL:DeedsRegistry) ! THE CURSOR IS AT THE END
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                     PL:DeedsRegistry = LIB:Description
                     PL:DeedsRegistry =  PL:DeedsRegistry & LIB:Description
                  END
               ELSE
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                     PL:DeedsRegistry = LIB:Description
                     PL:DeedsRegistry =  SUB(Contents(?PL:DeedsRegistry),1,SAV:PROP:SelStart#-1) & LIB:Description & SUB(Contents(?PL:DeedsRegistry),SAV:PROP:SelStart#,1000)
                  END
               END
            ELSE
              PL:DeedsRegistry = LIB:Description
            END
            DISPLAY(?PL:DeedsRegistry)
            SELECT(?PL:DeedsRegistry,SAV:PROP:SelStart# + LEN(LIB:Description))
         END
         CLEAR(GlobalRequest)
      ELSE
         MESSAGE('This Field does not have a Tooltip.||Unable to display the lookup library.','Program Error',ICON:Exclamation)
      END
      
      
      
      
    OF ?PL:SpouseFirstName
        IF ~PL:SpouseInitials 
            PL:SpouseInitials = CreateInitials(PL:SpouseFirstName)
            DISPLAY(?PL:SpouseInitials )
        END
    OF ?PL:SpouseIdentityNumber
          PL:SpouseIdentityNumber = StripNumbers(PL:SpouseIdentityNumber)
      
          IF ~PL:SpouseBirthDate AND LEN(PL:SpouseIdentityNumber) = 13
              PL:SpouseBirthDate = DATE(SUB(PL:SpouseIdentityNumber,3,2),SUB(PL:SpouseIdentityNumber,5,2),SUB(PL:SpouseIdentityNumber,1,2))
              IF YEAR(PL:SpouseBirthDate) >= YEAR(Today())    ! MUST BE 1900'S
                 PL:SpouseBirthDate = DATE(SUB(PL:SpouseIdentityNumber,3,2),SUB(PL:SpouseIdentityNumber,5,2),'19' & SUB(PL:SpouseIdentityNumber,1,2))
              END
              SELECT(?PL:SpouseBirthDate)
          END
      
          IF LEN(PL:SpouseIdentityNumber) <> 13
             IF QuickWindow{Prop:AcceptAll} = False 
                MESSAGE('There are ' & LEN(PL:SpouseIdentityNumber)  & ' digits in this Identity Number.||Are you sure this is correct?','Warning',ICON:Exclamation)
             END
          ELSE
             PL:SpouseIdentityNumber = FORMAT(PL:SpouseIdentityNumber,@P###### #### ## #P)
          END
          DISPLAY
    OF ?PAR:UnmarriedStatus
      IF LOC:MaritalStatus = 'Unmarried' THEN
      
          EXECUTE PAR:UnmarriedStatus + 1
              PL:MaritalDescription = 'Unmarried'
              PL:MaritalDescription = 'Divorced'
              BEGIN
                  IF PAR:PartyTypeID = 1 THEN ! Male
                      PL:MaritalDescription = 'Widower'
                  ELSE ! Female
                      PL:MaritalDescription = 'Widow'
                  END
              END
          END
          DISPLAY
      
      END
    OF ?LookupLibraryButton:6
      ThisWindow.Update
      GLO:TooltipCategory = ?PL:AuthorityPhrase{PROP:Tooltip}
      IF GLO:TooltipCategory
      
         FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
         IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
      
         SAV:PROP:SelStart# = ?PL:AuthorityPhrase{PROP:SelStart}
         GLO:TooltipContents = ?PL:AuthorityPhrase{PROP:ScreenText}
         GlobalRequest = SelectRecord
         BrowseLookup
         IF GlobalResponse = RequestCompleted
            LIB:Description = ReplaceTextBoxFields(LIB:Description,0,-1,-1,0)
            IF PL:AuthorityPhrase     ! IF THERE ALREADY IS TEXT IN THIS FIELD
               IF SAV:PROP:SelStart#  >= LEN(PL:AuthorityPhrase) ! THE CURSOR IS AT THE END
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                     PL:AuthorityPhrase = LIB:Description
                     PL:AuthorityPhrase =  PL:AuthorityPhrase & LIB:Description
                  END
               ELSE
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                     PL:AuthorityPhrase = LIB:Description
                     PL:AuthorityPhrase =  SUB(Contents(?PL:AuthorityPhrase),1,SAV:PROP:SelStart#-1) & LIB:Description & SUB(Contents(?PL:AuthorityPhrase),SAV:PROP:SelStart#,1000)
                  END
               END
            ELSE
              PL:AuthorityPhrase = LIB:Description
            END
            DISPLAY(?PL:AuthorityPhrase)
            SELECT(?PL:AuthorityPhrase,SAV:PROP:SelStart# + LEN(LIB:Description))
         END
         CLEAR(GlobalRequest)
      ELSE
         MESSAGE('This Field does not have a Tooltip.||Unable to display the lookup library.','Program Error',ICON:Exclamation)
      END
      
      
      
      
    OF ?LookupLibraryButton:7
      ThisWindow.Update
      GLO:TooltipCategory = ?PL:CapacityPhrase{PROP:Tooltip}
      IF GLO:TooltipCategory
      
         FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
         IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
      
         SAV:PROP:SelStart# = ?PL:CapacityPhrase{PROP:SelStart}
         GLO:TooltipContents = ?PL:CapacityPhrase{PROP:ScreenText}
         GlobalRequest = SelectRecord
         BrowseLookup
         IF GlobalResponse = RequestCompleted
            LIB:Description = ReplaceTextBoxFields(LIB:Description,0,-1,-1,0)
            IF PL:CapacityPhrase     ! IF THERE ALREADY IS TEXT IN THIS FIELD
               IF SAV:PROP:SelStart#  >= LEN(PL:CapacityPhrase) ! THE CURSOR IS AT THE END
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                     PL:CapacityPhrase = LIB:Description
                     PL:CapacityPhrase =  PL:CapacityPhrase & LIB:Description
                  END
               ELSE
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                     PL:CapacityPhrase = LIB:Description
                     PL:CapacityPhrase =  SUB(Contents(?PL:CapacityPhrase),1,SAV:PROP:SelStart#-1) & LIB:Description & SUB(Contents(?PL:CapacityPhrase),SAV:PROP:SelStart#,1000)
                  END
               END
            ELSE
              PL:CapacityPhrase = LIB:Description
            END
            DISPLAY(?PL:CapacityPhrase)
            SELECT(?PL:CapacityPhrase,SAV:PROP:SelStart# + LEN(LIB:Description))
         END
         CLEAR(GlobalRequest)
      ELSE
         MESSAGE('This Field does not have a Tooltip.||Unable to display the lookup library.','Program Error',ICON:Exclamation)
      END
      
      
      
      
    OF ?LookupLibraryButton:8
      ThisWindow.Update
      GLO:TooltipCategory = ?PL:TrustDivision{PROP:Tooltip}
      IF GLO:TooltipCategory
      
         FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
         IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
      
         SAV:PROP:SelStart# = ?PL:TrustDivision{PROP:SelStart}
         GLO:TooltipContents = ?PL:TrustDivision{PROP:ScreenText}
         GlobalRequest = SelectRecord
         BrowseLookup
         IF GlobalResponse = RequestCompleted
            LIB:Description = ReplaceTextBoxFields(LIB:Description,0,-1,-1,0)
            IF PL:TrustDivision     ! IF THERE ALREADY IS TEXT IN THIS FIELD
               IF SAV:PROP:SelStart#  >= LEN(PL:TrustDivision) ! THE CURSOR IS AT THE END
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                     PL:TrustDivision = LIB:Description
                     PL:TrustDivision =  PL:TrustDivision & LIB:Description
                  END
               ELSE
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                     PL:TrustDivision = LIB:Description
                     PL:TrustDivision =  SUB(Contents(?PL:TrustDivision),1,SAV:PROP:SelStart#-1) & LIB:Description & SUB(Contents(?PL:TrustDivision),SAV:PROP:SelStart#,1000)
                  END
               END
            ELSE
              PL:TrustDivision = LIB:Description
            END
            DISPLAY(?PL:TrustDivision)
            SELECT(?PL:TrustDivision,SAV:PROP:SelStart# + LEN(LIB:Description))
         END
         CLEAR(GlobalRequest)
      ELSE
         MESSAGE('This Field does not have a Tooltip.||Unable to display the lookup library.','Program Error',ICON:Exclamation)
      END
      
      
      
      
    OF ?Delete:2
      ThisWindow.Update
!/1/2/2011 - THE DELETE BUTTON JUST DOESN'T SEEM TO WORK??????
! KIM
!   IF MESSAGE('Are you sure you want to Delete this Signatory?|','Delete Signatory',ICON:Exclamation,BUTTON:Yes+BUTTON:No,BUTTON:Yes,1) = Button:Yes
!
!
!      PROPSQL('DELETE ParSign WHERE PartyID = ' & PS:PartyID & ' AND Sorter = ' & PS:Sorter)
!      BRW14.ResetFromFile
!      BRW14.PostNewSelection
!
!   END
!
!   RETURN LEVEL:Notify

    OF ?PAR:TaxNumber
      a# = 10
      If Upper(PAR:CountryOfResidence) = 'NAMIBIA' Then a# = 12.
      If PAR:TaxNumber
        If Len(PAR:TaxNumber) <> a#
          Message('According to the Country of residence the Length of the Tax Number has to be exactly ' & a# & ' characters||Please check the Tax Number','Invalid Tax Number?',ICON:Exclamation)
          Select(?PAR:TaxNumber)
        End
      End
    OF ?PAR:VatNumber
      a# = 10
      If Upper(PAR:CountryOfResidence) = 'NAMIBIA' Then a# = 12.
      If PAR:VATNumber
        If Len(PAR:VATNumber) <> a#
          Message('According to the Country of residence the Length of the VAT Number has to be exactly ' & a# & ' characters||Please check the VAT Number','Invalid Tax Number?',ICON:Exclamation)
          Select(?PAR:VATNumber)
        End
      End
      
    OF ?PAR:SpouseTaxNumber
      a# = 10
      If Upper(PAR:SpouseCountryOfResidence) = 'NAMIBIA' Then a# = 12.
      If PAR:SpouseTaxNumber
        If Len(PAR:SpouseTaxNumber) <> a#
          Message('According to the Country of residence the Length of the Tax Number has to be exactly ' & a# & ' characters||Please check the Tax Number','Invalid Tax Number?',ICON:Exclamation)
          Select(?PAR:SpouseTaxNumber)
        End
      End
    OF ?CountryOfResidenceButton:2
      ThisWindow.Update
      GlobalRequest = SelectRecord
      BrowseCountry
      IF GlobalResponse = RequestCompleted
         PAR:SpouseCountryOfResidence = COU:Description
         DISPLAY(?PAR:SpouseCountryOfResidence)
      END
    OF ?SetDefaultBankButton
      ThisWindow.Update
              IF ACB:RecordID
                 PAR:ParBankId = ACB:RecordId
                 BRW33.ResetFromBuffer
!                 FLUSH(BRW33::View:Browse)
!                 ThisWindow.Reset(1)
! rick
              END
    OF ?PAR:ParRegionID
      IF PAR:ParRegionID OR ?PAR:ParRegionID{Prop:Req}
        PREG:RecordID = PAR:ParRegionID
        IF Access:ParRegion.TryFetch(PREG:PrimaryKey)
          IF SELF.Run(3,SelectRecord) = RequestCompleted
            PAR:ParRegionID = PREG:RecordID
          ELSE
            SELECT(?PAR:ParRegionID)
            CYCLE
          END
        END
      END
      ThisWindow.Reset()
    OF ?CallLookup:3
      ThisWindow.Update
      PREG:RecordID = PAR:ParRegionID
      IF SELF.Run(3,SelectRecord) = RequestCompleted
        PAR:ParRegionID = PREG:RecordID
      END
      ThisWindow.Reset(1)
    OF ?PAR:ParCategoryID
      IF PAR:ParCategoryID OR ?PAR:ParCategoryID{Prop:Req}
        PCAT:RecordID = PAR:ParCategoryID
        IF Access:ParCategory.TryFetch(PCAT:PrimaryKey)
          IF SELF.Run(4,SelectRecord) = RequestCompleted
            PAR:ParCategoryID = PCAT:RecordID
          ELSE
            SELECT(?PAR:ParCategoryID)
            CYCLE
          END
        END
      END
      ThisWindow.Reset()
    OF ?CallLookup:4
      ThisWindow.Update
      PCAT:RecordID = PAR:ParCategoryID
      IF SELF.Run(4,SelectRecord) = RequestCompleted
        PAR:ParCategoryID = PCAT:RecordID
      END
      ThisWindow.Reset(1)
    OF ?Print
      ThisWindow.Update
      SetCursor(CURSOR:Wait)
      PUSHBIND
      BIND('PP:Date',PP:Date)
      BIND('PROD:Description',PROD:Description)
      BIND('PP:Quantity',PP:Quantity)
      BIND('PP:UnitPrice',PP:UnitPrice)
      BIND('PP:Notes',PP:Notes)
      If CEM:PrintXMLFlag
        PrintXMLInit(QuickWindow{PROP:Text})
      
        PrintXMLAddField('Date','PP:Date',0,0,0,'@d17',0,'')
        PrintXMLAddField('Description','PROD:Description',0,0,0,'@s49',0,'')
        PrintXMLAddField('Qty','PP:Quantity',0,0,0,'@n_5b',0,'')
        PrintXMLAddField('Unit Price','PP:UnitPrice',3,0,1,'@n11.2',3,'')
        PrintXMLAddField('Notes','PP:Notes',0,0,0,'@s254',0,'')
      Else
        Free(SSQueue:18)
        a# = 1
        Loop
          Clear(SSQueue:18)
          Execute a#
            Begin
              SkipThisColumn# = False
              SSQ:18:FieldName    = 'PP:Date'
              SSQ:18:Heading      = 'Date'
              SSQ:18:Picture      = '@d17'
            .
            Begin
              SkipThisColumn# = False
              SSQ:18:FieldName    = 'PROD:Description'
              SSQ:18:Heading      = 'Description'
              SSQ:18:Picture      = '@s49'
            .
            Begin
              SkipThisColumn# = False
              SSQ:18:FieldName    = 'PP:Quantity'
              SSQ:18:Heading      = 'Qty'
              SSQ:18:Picture      = '@n_5b'
            .
            Begin
              SkipThisColumn# = False
              SSQ:18:FieldName    = 'PP:UnitPrice'
              SSQ:18:Heading      = 'Unit Price'
              SSQ:18:Picture      = '@n11.2'
              SSQ:18:FormatType   = 4
            .
            Begin
              SkipThisColumn# = False
              SSQ:18:FieldName    = 'PP:Notes'
              SSQ:18:Heading      = 'Notes'
              SSQ:18:Picture      = '@s254'
            .
          .
          SSQ:18:FieldNo = a#
          If ~SkipThisColumn# Then Add(SSQueue:18,SSQ:18:FieldNo).
          If a# = 5 Then Break.
          a# +=1
        .
        Open(SSWindow:18)
        SSWindow:18{PROP:Text} = 'Print ' & QuickWindow{PROP:Text}
        SSWindow:18{PROP:Maximize} = True
        ?SSOle:18{PROP:Create} = 'TTF161.TTF1.6'
        If ~?SSOle:18{PROP:Ole}
          Message('Spreadsheet OCX Not Registered, Press OK To Register','',ICON:Asterisk)
          RUN('regsvr32 ttf16.ocx')
          ?SSOle:18{PROP:Create} = 'TTF161.TTF1.6'
          If ~?SSOle:18{PROP:Ole}
            Close(SSWindow:18)
            Message('The Spreadsheet OCX cannot be registered, try registering it at the DOS prompt by typing "regsvr32 ttf16.ocx"','',ICON:Hand)
            SetCursor
            Cycle
          .
        .
      
        ?SSOle:18{'Row'} = 1
        Loop a# = 1 to Records(SSQueue:18)
          Get(SSQueue:18,a#)
          ?SSOle:18{'Col'} = a#
          ?SSOle:18{'Entry'} = SSQ:18:Heading
          ?SSOle:18{'FontBold'} = 1
          ?SSOle:18{'FontUnderline'} = 1
          If SSQ:18:AlignH Then ?SSOle:18{'HAlign'} = SSQ:18:AlignH-1.
          If SSQ:18:AlignV Then ?SSOle:18{'HAlign'} = SSQ:18:AlignV-1.
        .
      
        LOC:SSRow:18 = 2
      .
      Set(BRW16::View:Browse)
      Loop
        Next(BRW16::View:Browse)
        If Errorcode() = 33 Then Break.
        If Errorcode()
          Message('Error Reading Data|Error :' & Error(),'Print',ICON:Exclamation)
          Break
        .
        If BRW16.ValidateRecord() Then Cycle.
        BRW16.SetQueueRecord
        If CEM:PrintXMLFlag
          PrintXMLAddData
        Else
          LOC:SSRow:18 += 1
          ?SSOle:18{'Row'} = LOC:SSRow:18
          Loop a# = 1 to Records(SSQueue:18)
            Get(SSQueue:18,a#)
            ?SSOle:18{'Col'} = a#
            ?SSOle:18{'Entry'} = Clip(Left(Format(Evaluate(SSQ:18:FieldName),SSQ:18:Picture)))
            Execute SSQ:18:FormatType - 1
              ?SSOle:18{'FormatCurrency2'}
              ?SSOle:18{'FormatCurrency'}
              ?SSOle:18{'FormatFixed2'}
              ?SSOle:18{'FormatFixed'}
              ?SSOle:18{'FormatPercent'}
              ?SSOle:18{'Entry'} = Format(?SSOle:18{'Entry'},@d17b)
              ?SSOle:18{'Entry'} = Format(?SSOle:18{'Entry'},@t7b)
              ?SSOle:18{'NumberFormat'} = '@'
              ?SSOle:18{'NumberFormat'} = SSQ:18:FormatString
            .
            If SSQ:18:AlignH Then ?SSOle:18{'HAlign'} = SSQ:18:AlignH-1.
            If SSQ:18:AlignV Then ?SSOle:18{'HAlign'} = SSQ:18:AlignV-1.
            ?SSOle:18{'WordWrap'} = 1
          .
        .
      End
      If CEM:PrintXMLFlag
        PrintXMLRun
        POPBIND
        SetCursor
      Else
        LOOP LOC:SSCol:18 = 1 TO RECORDS(SSQueue:18)
          Get(SSQueue:18,LOC:SSCol:18)
          If SSQ:18:ColumnWidth
            ?SSOle:18{'ColWidth(' & LOC:SSCol:18 & ')'} = SSQ:18:ColumnWidth * 256
          Else
            ?SSOle:18{'SetColWidthAuto(1,' & LOC:SSCol:18 & ',' & LOC:SSRow:18 & ',' & LOC:SSCol:18 & ',0)'}
          .
          If SSQ:18:TotalOption > 1
            ?SSOle:18{'Row'} = LOC:SSRow:18 + 1
            ?SSOle:18{'Col'} = LOC:SSCol:18
            ?SSOle:18{'SetBorder(-1,-1,-1,1,6,0,0,0,0,0,0)'}
            Execute SSQ:18:TotalOption - 1
              ?SSOle:18{'Entry'} = '=Sum(' & Chr(64 + LOC:SSCol:18) & '2:' & Chr(64 + LOC:SSCol:18) & LOC:SSRow:18 & ')'
              ?SSOle:18{'Entry'} = '=CountA(' & Chr(64 + LOC:SSCol:18) & '2:' & Chr(64 + LOC:SSCol:18) & LOC:SSRow:18 & ')'
              ?SSOle:18{'Entry'} = '=Average(' & Chr(64 + LOC:SSCol:18) & '2:' & Chr(64 + LOC:SSCol:18) & LOC:SSRow:18 & ')'
            .
            Execute SSQ:18:FormatType - 1
              ?SSOle:18{'FormatCurrency2'}
              ?SSOle:18{'FormatCurrency'}
              ?SSOle:18{'FormatFixed2'}
              ?SSOle:18{'FormatFixed'}
              ?SSOle:18{'FormatPercent'}
              ?SSOle:18{'Entry'} = Format(?SSOle:18{'Entry'},@d17b)
              ?SSOle:18{'Entry'} = Format(?SSOle:18{'Entry'},@t7b)
              z# = 1 ! Dummy Filler
              ?SSOle:18{'NumberFormat'} = SSQ:18:FormatString
            .
            If SSQ:18:AlignH Then ?SSOle:18{'HAlign'} = SSQ:18:AlignH-1.
            If SSQ:18:AlignV Then ?SSOle:18{'HAlign'} = SSQ:18:AlignV-1.
          .
        .
        LOC:PageSetup18 = ?SSOle:18{'GetPageSetup'}
        ?SSOle:18{LOC:PageSetup18 & '.PaperSize'} = 9
        ?SSOle:18{'SetPageSetup(' & LOC:PageSetup18 & ')'}
        ?SSOle:18{'PrintScaleFitToPage'} = True
        ?SSOle:18{'PrintScaleFitHPages'} = 1
        ?SSOle:18{'PrintScaleFitVPages'} = 16384
        ?SSOle:18{'PrintLandscape'} = 0
        ?SSOle:18{'PrintHeader'} = '&C&B&U' & QuickWindow{PROP:Text}
        ?SSOle:18{'PrintGridLines'} = 0
        ?SSOle:18{'ShowVScrollBar'} = 1
        ?SSOle:18{'ShowHScrollBar'} = 1
        ?SSOle:18{PROP:Hide} = False
        ?SSOle:18{'Col'} = 1
        ?SSOle:18{'Row'} = 1
        SetCursor
        Accept
          Case Event()
          Of EVENT:Sized
            ?SSOle:18{PROP:Width}  = SSWindow:18{PROP:Width}
            ?SSOle:18{PROP:Height} = SSWindow:18{PROP:Height} - 19
            ?SSGroup:18{PROP:Width}  = SSWindow:18{PROP:Width} + 5
          Of EVENT:Accepted
            Case Field()
            Of ?SSClose:18
              Break
            Of ?SSExcel:18
              SetCursor(Cursor:Wait)
              LOC:Filename:18 = Path()
              If Sub(LOC:Filename:18,Len(LOC:Filename:18),1) <> '\' Then LOC:Filename:18 = LOC:Filename:18 & '\'.
              LOC:Filename:18 = LOC:Filename:18 & 'Temp\'
              LOC:Filename:18 = LOC:Filename:18 & GLO:LoginId & '.xls'
              ?SSOle:18{'WriteEx("' & LOC:Filename:18 & '",11)'}
              ?OleExcel:18{PROP:Hide} = False
              ExcelObj" = ?OleExcel:18{'Application'}
              If ~ExcelObj" OR ExcelObj" = 'GetPropertyFailed' OR ExcelObj" = 'No ole automation interface'
                ?OleExcel:18{PROP:Create} = 'Excel.Application'
                ExcelObj" = ?OleExcel:18{'Application'}
                If ~ExcelObj"
                  SetCursor
                  Message('Unable to establish an OLE link with the Microsoft Excel program.||Is Excell Installed correctly?','Printing Report',ICON:Exclamation)
                  Cycle
                .
              .
      
              ?OleExcel:18{'ScreenUpdating'} = False
              ?OleExcel:18{'Workbooks.Open(Filename="' & LOC:Filename:18 & '")'}
              If Errorcode()
                SetCursor
                Message('Unable to open file|Filename: ' & LOC:Filename:18 & GLO:LoginId & '.xls' & '|Error: ' & Error(),'Printing Report',ICON:Exclamation)
                Cycle
              .
              ?OleExcel:18{'ActiveSheet.PageSetup.Orientation'} = 2  ! SET TO LANDSCAPE
      
      
      
              ?OleExcel:18{'ScreenUpdating'} = True
              ?OleExcel:18{'Visible'} = -1
              ?OleExcel:18{PROP:Release} = ExcelObj"
              ?OleExcel:18{PROP:Deactivate} = ExcelObj"
              Post(EVENT:Accepted,?SSClose:18)
            Of ?SSPrint:18
              ?SSOle:18{'FilePrint(0)'}
            Of ?SSPreview:18
              ?SSOle:18{'FilePrintPreview'}
            Of ?SSFilePrint:18
              ?SSOle:18{'FilePrint(1)'}
            Of ?SSEdit:18
              SSWindow:18{PROP:Maximize} = True
              ?SSOle:18{'LaunchDesigner'}
              Break
            .
          .
        End
        ?SSOle:18{PROP:Release} = ?SSOle:18{'Application'}
        ?SSOle:18{PROP:Deactivate} = ?SSOle:18{'Application'}
        Destroy(?SSOle:18)
        Destroy(?OleExcel:18)
        Close(SSWindow:18)
        POPBIND
      .
    OF ?LookupLibraryButton:2
      ThisWindow.Update
      GLO:TooltipCategory = ?PAR:MatterTakeOnReminder{PROP:Tooltip}
      IF GLO:TooltipCategory
      
         FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
         IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
      
         SAV:PROP:SelStart# = ?PAR:MatterTakeOnReminder{PROP:SelStart}
         GLO:TooltipContents = ?PAR:MatterTakeOnReminder{PROP:ScreenText}
         GlobalRequest = SelectRecord
         BrowseLookup
         IF GlobalResponse = RequestCompleted
            LIB:Description = ReplaceTextBoxFields(LIB:Description,0,-1,-1,0)
            IF PAR:MatterTakeOnReminder     ! IF THERE ALREADY IS TEXT IN THIS FIELD
               IF SAV:PROP:SelStart#  >= LEN(PAR:MatterTakeOnReminder) ! THE CURSOR IS AT THE END
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                     PAR:MatterTakeOnReminder = LIB:Description
                     PAR:MatterTakeOnReminder =  PAR:MatterTakeOnReminder & LIB:Description
                  END
               ELSE
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                     PAR:MatterTakeOnReminder = LIB:Description
                     PAR:MatterTakeOnReminder =  SUB(Contents(?PAR:MatterTakeOnReminder),1,SAV:PROP:SelStart#-1) & LIB:Description & SUB(Contents(?PAR:MatterTakeOnReminder),SAV:PROP:SelStart#,1000)
                  END
               END
            ELSE
              PAR:MatterTakeOnReminder = LIB:Description
            END
            DISPLAY(?PAR:MatterTakeOnReminder)
            SELECT(?PAR:MatterTakeOnReminder,SAV:PROP:SelStart# + LEN(LIB:Description))
         END
         CLEAR(GlobalRequest)
      ELSE
         MESSAGE('This Field does not have a Tooltip.||Unable to display the lookup library.','Program Error',ICON:Exclamation)
      END
      
      
      
      
    OF ?LookupLibraryButton:9
      ThisWindow.Update
      GLO:TooltipCategory = ?PL:DefCitation{PROP:Tooltip}
      IF GLO:TooltipCategory
      
         FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
         IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
      
         SAV:PROP:SelStart# = ?PL:DefCitation{PROP:SelStart}
         GLO:TooltipContents = ?PL:DefCitation{PROP:ScreenText}
         GlobalRequest = SelectRecord
         BrowseLookup
         IF GlobalResponse = RequestCompleted
            LIB:Description = ReplaceTextBoxFields(LIB:Description,0,-1,-1,0)
            IF PL:DefCitation     ! IF THERE ALREADY IS TEXT IN THIS FIELD
               IF SAV:PROP:SelStart#  >= LEN(PL:DefCitation) ! THE CURSOR IS AT THE END
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                     PL:DefCitation = LIB:Description
                     PL:DefCitation =  PL:DefCitation & LIB:Description
                  END
               ELSE
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                     PL:DefCitation = LIB:Description
                     PL:DefCitation =  SUB(Contents(?PL:DefCitation),1,SAV:PROP:SelStart#-1) & LIB:Description & SUB(Contents(?PL:DefCitation),SAV:PROP:SelStart#,1000)
                  END
               END
            ELSE
              PL:DefCitation = LIB:Description
            END
            DISPLAY(?PL:DefCitation)
            SELECT(?PL:DefCitation,SAV:PROP:SelStart# + LEN(LIB:Description))
         END
         CLEAR(GlobalRequest)
      ELSE
         MESSAGE('This Field does not have a Tooltip.||Unable to display the lookup library.','Program Error',ICON:Exclamation)
      END
      
      
      
      
    OF ?LookupLibraryButton:10
      ThisWindow.Update
      GLO:TooltipCategory = ?PL:PlaCitation{PROP:Tooltip}
      IF GLO:TooltipCategory
      
         FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
         IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
      
         SAV:PROP:SelStart# = ?PL:PlaCitation{PROP:SelStart}
         GLO:TooltipContents = ?PL:PlaCitation{PROP:ScreenText}
         GlobalRequest = SelectRecord
         BrowseLookup
         IF GlobalResponse = RequestCompleted
            LIB:Description = ReplaceTextBoxFields(LIB:Description,0,-1,-1,0)
            IF PL:PlaCitation     ! IF THERE ALREADY IS TEXT IN THIS FIELD
               IF SAV:PROP:SelStart#  >= LEN(PL:PlaCitation) ! THE CURSOR IS AT THE END
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                     PL:PlaCitation = LIB:Description
                     PL:PlaCitation =  PL:PlaCitation & LIB:Description
                  END
               ELSE
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                     PL:PlaCitation = LIB:Description
                     PL:PlaCitation =  SUB(Contents(?PL:PlaCitation),1,SAV:PROP:SelStart#-1) & LIB:Description & SUB(Contents(?PL:PlaCitation),SAV:PROP:SelStart#,1000)
                  END
               END
            ELSE
              PL:PlaCitation = LIB:Description
            END
            DISPLAY(?PL:PlaCitation)
            SELECT(?PL:PlaCitation,SAV:PROP:SelStart# + LEN(LIB:Description))
         END
         CLEAR(GlobalRequest)
      ELSE
         MESSAGE('This Field does not have a Tooltip.||Unable to display the lookup library.','Program Error',ICON:Exclamation)
      END
      
      
      
      
    OF ?EditRelationshipPartyButton
      ThisWindow.Update
      IF PREL:OtherPartyID

         SAV:PAR:RecordID = PAR:RecordID
         SAV:PAR:DefaultLanguageID = PAR:DefaultLanguageID

         CLEAR(PAR:Record)
         PAR:RecordID = PREL:OtherPartyID
         Set(PAR:PrimaryKey,PAR:PrimaryKey)   

         IF ~Access:Party.Next()              

             GlobalRequest = ChangeRecord
             UpdateParty

         ELSE
             MESSAGE(ERROR(),'1 EditRelationshipPartyButton')
         END

         CLEAR(PAR:Record)
         PAR:RecordID = SAV:PAR:RecordID
         IF ~Access:Party.TryFetch(PAR:PrimaryKey)
             PL:PartyID = SAV:PAR:RecordID
             PL:LanguageID = SAV:PAR:DefaultLanguageID
             IF Access:ParLang.TryFetch(PL:PartyLanguageKey)
                MESSAGE(ERROR(),'2 EditRelationshipPartyButton')
             END
         ELSE
             MESSAGE(ERROR(),'3 EditRelationshipPartyButton')
         END
         ThisWindow.Reset

      END
    OF ?PAR:NoFICAFlag
      IF ?PAR:NoFICAFlag{Prop:Checked} = True
        HIDE(?FICAButtonGroup)
      END
      IF ?PAR:NoFICAFlag{Prop:Checked} = False
        UNHIDE(?FICAButtonGroup)
      END
      ThisWindow.Reset
    OF ?DocumentLogButton
      ThisWindow.Update
            GLO:PartyID = PAR:RecordID
            BrowseDocLog
            GLO:PartyID = 0
    OF ?LOC:PL2:FirstName
      IF ~LOC:PL2:Initials
          LOC:PL2:Initials = CreateInitials(LOC:PL2:FirstName)
          DISPLAY(?LOC:PL2:Initials)
      END
    OF ?LOC:PL2:IdentityNumber
      IF ( LOC:PL2:IdentityNumber)
          LOC:PL2:IdentityNumber = StripNumbers(LOC:PL2:IdentityNumber)
      
          IF ~LOC:PL2:BirthDate AND LEN(LOC:PL2:IdentityNumber) = 13
              LOC:PL2:BirthDate = DATE(SUB(LOC:PL2:IdentityNumber,3,2),SUB(LOC:PL2:IdentityNumber,5,2),SUB(LOC:PL2:IdentityNumber,1,2))
              IF YEAR(LOC:PL2:BirthDate) >= YEAR(Today())    ! MUST BE 1900'S
                 LOC:PL2:BirthDate = DATE(SUB(LOC:PL2:IdentityNumber,3,2),SUB(LOC:PL2:IdentityNumber,5,2),'19' & SUB(LOC:PL2:IdentityNumber,1,2))
              END
      
              
      
              
          END
      
          IF LEN(LOC:PL2:IdentityNumber) <> 13
             IF QuickWindow{Prop:AcceptAll} = False 
                MESSAGE('There are ' & LEN(LOC:PL2:IdentityNumber)  & ' digits in the Identity Number.||Are you sure this is correct?','Warning',ICON:Exclamation)
             END
          ELSE
             LOC:PL2:IdentityNumber = FORMAT(LOC:PL2:IdentityNumber,@P###### #### ## #P)
          END
          DISPLAY
       END
    OF ?DeceasedCountryOfResidenceButton
      ThisWindow.Update
      GlobalRequest = SelectRecord
      BrowseCountry
      IF GlobalResponse = RequestCompleted
         LOC:PAR2:CountryOfResidence = COU:Description
         DISPLAY(?LOC:PAR2:CountryOfResidence)
      END
    OF ?OK
      ThisWindow.Update
      IF SELF.Request = ViewRecord
        POST(EVENT:CloseWindow)
      END
      
    OF ?ApplyButton
      ThisWindow.Update
      SAV:ParLangRecord :=: PL:Record
      PL:LanguageID = PAR:DefaultLanguageID
      PL:PartyID = PAR:RecordID
      IF ~Access:ParLang.TryFetch(PL:PARTYLANGUAGEKEY)
          PL:Record :=: SAV:ParLangRecord
          IF ~Access:ParLang.Update()
              BEEP
              MESSAGE('Party''s details for the ' & LOC:Language & ' language saved','Saved ' & LOC:Language & ' details',ICON:Exclamation)
              LOC:CheckMarDesc = 1
      
           END
      ELSE
          IF PL:LanguageID AND PL:PartyID
             IF ~Access:ParLang.Insert()
                 BEEP
                 MESSAGE('Party''s details for the ' & LOC:Language & ' language saved','Saved ' & LOC:Language & ' details',ICON:Exclamation)
                 SAVED:MaritalStatus = ''
                 LOC:CheckMarDesc = 1
             ELSE
                 MESSAGE('Party''s details were NOT saved.',LOC:Language,ICON:Exclamation)
             END
          ELSE
             MESSAGE('Party''s details NOT saved.||You must specify a Language and a Type.',LOC:Language,ICON:Exclamation)
          END
      END
      
      DO CheckLanguagesForDifferences
      IF LOC:CheckMarDesc = 1
        DO CheckOtherLanguageMaritalStatus  !pk here
      END
      
    OF ?ModifyButton
      ThisWindow.Update
      INCLUDE('UpdateMatterExtraScreenSource','Modify Button')
    OF ?DeleteButton
      ThisWindow.Update
      INCLUDE('UpdateMatterExtraScreenSource','Delete Button')
      
      DO RebuildTabTreeQueue:30
      
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeCloseEvent PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.TakeCloseEvent()
  INCLUDE('UpdateMatterExtraScreenSource','TakeCloseEvent')
  
  UNBIND('BIND:FieldRequiredCondition')
  UNBIND('BIND:FieldCalculation')
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
      IF ~PAR:MatterPrefix
          PAR:MatterPrefix = GetMatterPrefix(PL:Name)
      END
      
      IF ENT1:RecordID > 2 AND ~(ENT1:RecordID = 16)
         PL:SpouseName = ''
         PL:SpouseFirstName = ''
         PL:SpouseIdentityNumber = ''
         PL:SpouseBirthDate = ''
         PL:DomiciledIn = ''
         PL:MaritalDescription = ''
         PL:DeedsRegistry = ''
         PL:MarriageDate = 0
         PL:MarriagePlace = ''
         PL:MarriageCountry = ''
         PL:ANCNumber = ''
         PL:SpousePrincipalFlag = False
         PAR:MaritalStatus = ''
      ELSE
        LOC:CheckMarDesc = 1
      END
  
      SAV:ParLangRecord :=: PL:Record

      PL:LanguageID = PAR:DefaultLanguageID
      PL:PartyID = PAR:RecordID
      IF ~Access:ParLang.TryFetch(PL:PARTYLANGUAGEKEY) !pk here
          PL:Record :=: SAV:ParLangRecord
          Access:ParLang.Update
      ELSE
          IF PL:LanguageID AND PL:PartyID
             Access:ParLang.Insert
          END
      END

      PAR:IdentityNumber = PL:IdentityNumber

      IF SELF.Request = ChangeRecord
         ! DOING THIS HERE BECAUSE THERE ARE TOO MANY UPDATES TO THE PARTY BY THE PROGRAM - ONLY WANT USER UPDATES
         PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL(PAR:Name) & ''',0,''Party'',2,' & CEM:RecordID & ',' & PAR:RecordID & ',''' & StripSQL(PAR:MatterPrefix) & ''',''' & GlobalErrors.GetProcedureName() & '''','FileManager - Update Tagged Parties')
      END

      IF SELF.Request = DeleteRecord
         ! DOING THIS HERE BECAUSE THERE ARE TOO MANY UPDATES TO THE PARTY BY THE PROGRAM - ONLY WANT USER UPDATES
         PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''' & StripSQL(PAR:Name) & ''',0,''Party'',2,' & CEM:RecordID & ',' & PAR:RecordID & ',''' & StripSQL(PAR:MatterPrefix) & ''',''' & GlobalErrors.GetProcedureName() & '''','FileManager - Update Tagged Parties')
      END


      IF SELF.Request = InsertRecord
         ! ADD THE OTHER LANGUAGE'S RECORD
         IF PL:LanguageID <> CTL:EnglishID
            PL:LanguageID = CTL:EnglishID
         ELSIF PL:LanguageID <> CTL:AfrikaansID
            PL:LanguageID = CTL:AfrikaansID
         END
         IF Access:ParLang.TryFetch(PL:PARTYLANGUAGEKEY)
            IF PL:LanguageID AND PL:PartyID
               Access:ParLang.Insert
               SAVED:MaritalStatus = ''
            END
         END
      END

      PAR:BirthMonth = ?LOC:BirthMonth{PROP:Selected}
      DO CheckLanguagesForDifferences
      IF LOC:CheckMarDesc = 1
        DO CheckOtherLanguageMaritalStatus !pk here
      END
      DO CheckCRMBirthDay

  ReturnValue = PARENT.TakeCompleted()
   INCLUDE('UpdateMatterExtraScreenSource','TakeCompleted')
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  PDPC:LOC:PL2:BirthDate.TakeEvent()
  PDPC:PAR:DateResolutionSigned.TakeEvent()
  PDPC:PAR:LastInstructedDate.TakeEvent()
  PDPC:PAR:RemoteAccessExpiry.TakeEvent()
  PDPC:PL:BirthDate.TakeEvent()
  PDPC:PL:GPASignedOn.TakeEvent()
  PDPC:PL:MarriageDate.TakeEvent()
  PDPC:PL:SpouseBirthDate.TakeEvent()
  PDPC:PL:TrustDate.TakeEvent()
  LOOP
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
      ThisTabTree30.TakeEvent()
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
  CASE FIELD()
  OF ?Sheet1
    CASE EVENT()
    OF EVENT:TabChanging
       IF CHOICE(?Sheet1) > LOC:ExistingTabs
          GET(ScreenQueue,CHOICE(?Sheet1) - LOC:ExistingTabs)
          SaveScreenData
       END
    END
  OF ?PL:DomiciledIn
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
    END
  OF ?PL:DeedsRegistry
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
    END
  OF ?PL:MarriageCountry
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
    END
  OF ?CRMTab
    
  END
!RICK
     IF QuickWindow{Prop:AcceptAll} THEN RETURN Level:Notify.

     IF RECORDS(ScreenQueue)
        ?ModifyButton{PROP:Disable} = False
        ?DeleteButton{PROP:Disable} = False
     ELSE
        ?ModifyButton{PROP:Disable} = True
        ?DeleteButton{PROP:Disable} = True
     END


     If PAR:ParBankId
       ?PAR:ElectronicPaymentFlag{PROP:Disable} = False
     Else
       ?PAR:ElectronicPaymentFlag{PROP:Disable} = True
       PAR:ElectronicPaymentFlag = 0
     .





     IF ~(SAVE:MaritalStatus = PAR:MaritalStatus) AND PAR:MaritalStatus
          SAVE:MaritalStatus = PAR:MaritalStatus
          ThisWindow.Update

          PL:MaritalDescription = GetMaritalDescription(PAR:DefaultLanguageID)
          DISPLAY(?PL:MaritalDescription)
          DO SetMaritalFields
          IF Inlist(PAR:MaritalStatus,'UNM','OUT')
             ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = True
             ?PAR:SpouseTaxNumber{PROP:Hide} = True
          ELSE
             ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = False
             ?PAR:SpouseTaxNumber{PROP:Hide} = False
          END


     END

     IF ~(SAV:PAR:MaritalStatus = PAR:MaritalStatus)
           SAV:PAR:MaritalStatus = PAR:MaritalStatus
           !FB 3258
           DO CheckAndLoadSpouseParty

!           IF PAR:EntityID < 3 OR ENT1:Category = 1   !FB 3064
!               IF ~PAR:MaritalStatus OR  Inlist(PAR:MaritalStatus,'UNM','OUT','CUO','FOR') !as per FB 1088 AND FB 1099 this is now hidden for CUO and FOR as well  !FB3064 catering for blank status as well
!                  HIDE(?SpouseTaxGroup)
!                  HIDE(?UpdateSpouseTaxDetailsButton)
!                  ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = True
!                  ?PAR:SpouseTaxNumber{PROP:Hide} = True
!               ELSE
!                  UNHIDE(?SpouseTaxGroup)
!                  UNHIDE(?UpdateSpouseTaxDetailsButton)
!                  ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = False
!                  ?PAR:SpouseTaxNumber{PROP:Hide} = False
!               END
!           ELSE   !FB 3064
!                HIDE(?SpouseTaxGroup)
!              HIDE(?UpdateSpouseTaxDetailsButton)
!              ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = True
!              ?PAR:SpouseTaxNumber{PROP:Hide} = True
!           END
!FB 3258 END
      END


     IF ~(SAV:EntityID = ENT1:RecordID) AND ENT1:RecordID

         SAV:EntityID = ENT1:RecordID

         IF ENT1:Category = 1
            ?LOC:PartyType{PROP:Tooltip} = 'The Gender of the ' & ENT1:Description
         ELSE
            ?LOC:PartyType{PROP:Tooltip} = 'The Type of ' & ENT1:Description
         END







!FB 3258
! RICK - 21/10/2014
!        IF PAR:EntityID < 3 OR ENT1:Category = 1  !FB 3064
!               IF ~PAR:MaritalStatus OR Inlist(PAR:MaritalStatus,'UNM','OUT','CUO','FOR') !as per FB 1088 AND FB 1099 this is now hidden for CUO and FOR as well  !FB3064 catering for blank status as well
!                  HIDE(?SpouseTaxGroup)
!                  HIDE(?UpdateSpouseTaxDetailsButton)
!                  ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = True
!                  ?PAR:SpouseTaxNumber{PROP:Hide} = True
!               ELSE
!                  UNHIDE(?SpouseTaxGroup)
!                  UNHIDE(?UpdateSpouseTaxDetailsButton)
!                  ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = False
!                  ?PAR:SpouseTaxNumber{PROP:Hide} = False
!               END
!           ELSE
!                HIDE(?SpouseTaxGroup)
!              HIDE(?UpdateSpouseTaxDetailsButton)
!              ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = True
!              ?PAR:SpouseTaxNumber{PROP:Hide} = True
!           END
!FB 3258 END

 












         CLEAR(PTD:Record)
         PTD:EntityID = PAR:EntityID
         PTD:PartyTypeID = PAR:PartyTypeID
         PTD:LanguageID = PAR:DefaultLanguageID
         IF ~Access:PTypeDef.TryFetch(PTD:PrimaryKey)
             PL:DefCitation = PTD:DefCitation
             PL:PlaCitation = PTD:PlaCitation
         ELSE
             CLEAR(PTD:Record)
             PTD:EntityID = -1
             PTD:PartyTypeID = PAR:PartyTypeID
             PTD:LanguageID = PAR:DefaultLanguageID
             IF ~Access:PTypeDef.TryFetch(PTD:PrimaryKey)
                 PL:DefCitation = PTD:DefCitation
                 PL:PlaCitation = PTD:PlaCitation
             END
         END


         DISPLAY

    END



     IF ~(SAV:PartyTypeID = PAR:PartyTypeID) AND PAR:PartyTypeID

         SAV:PartyTypeID = PAR:PartyTypeID

         CLEAR(PTD:Record)
         PTD:EntityID = PAR:EntityID
         PTD:PartyTypeID = PAR:PartyTypeID
         PTD:LanguageID = PAR:DefaultLanguageID
         IF ~Access:PTypeDef.TryFetch(PTD:PrimaryKey)
             PL:DefCitation = PTD:DefCitation
             PL:PlaCitation = PTD:PlaCitation
         ELSE
             CLEAR(PTD:Record)
             PTD:EntityID = PAR:EntityID
             PTD:PartyTypeID = -1
             PTD:LanguageID = PAR:DefaultLanguageID
             IF ~Access:PTypeDef.TryFetch(PTD:PrimaryKey)
                 PL:DefCitation = PTD:DefCitation
                 PL:PlaCitation = PTD:PlaCitation
             END
         END
         DISPLAY

     END



    IF ~(SAV:LanguageID = PAR:DefaultLanguageID)

         IF PL:Name                                 ! EITHER ADD OR UPDATE THE CURRENT RECORD
            PL:LanguageID = SAV:LanguageID
            PL:PartyID = PAR:RecordID
            IF Access:ParLang.TryFetch(PL:PARTYLANGUAGEKEY)
               Access:ParLang.Insert
            ELSE
               Access:ParLang.Update   !pk here
            END

            SAV:PartyName = PL:Name

            SAV:ParLangRecord :=: PL:Record
            SAV:PL:Name = PL:Name
            SAV:PL:AlternativeName = PL:AlternativeName
            SAV:PL:FirstName = PL:FirstName
            SAV:PL:Title = PL:Title
            SAV:PL:Initials = PL:Initials
            SAV:PL:IdentityNumber = PL:IdentityNumber
            SAV:PL:BirthDate = PL:BirthDate
            SAV:PL:Salutation = PL:Salutation
            SAV:PL:PhysicalLine1 = PL:PhysicalLine1
            SAV:PL:PhysicalLine2 = PL:PhysicalLine2
            SAV:PL:PhysicalLine3 = PL:PhysicalLine3
            SAV:PL:PhysicalCode = PL:PhysicalCode
            SAV:PL:PostalLine1 = PL:PostalLine1
            SAV:PL:PostalLine2 = PL:PostalLine2
            SAV:PL:PostalLine3 = PL:PostalLine3
            SAV:PL:PostalCode = PL:PostalCode
            SAV:PL:SpouseName = PL:SpouseName
            SAV:PL:SpouseFirstName = PL:SpouseFirstName
            SAV:PL:SpouseInitials = PL:SpouseInitials
            SAV:PL:SpouseIdentityNumber = PL:SpouseIdentityNumber
            SAV:PL:SpouseBirthDate = PL:SpouseBirthDate
            SAV:PL:DomiciledIn = PL:DomiciledIn
            SAV:PL:MaritalDescription = PL:MaritalDescription
            SAV:PL:DeedsRegistry = PL:DeedsRegistry
            SAV:PL:MarriageDate = PL:MarriageDate
            SAV:PL:MarriagePlace = PL:MarriagePlace
            SAV:PL:MarriageCountry = PL:MarriageCountry
            SAV:PL:ANCNumber = PL:ANCNumber
            SAV:PL:SpousePrincipalFlag = PL:SpousePrincipalFlag
            SAV:PL:RegistrationNumber = PL:RegistrationNumber
            SAV:PL:AuthorityPhrase = PL:AuthorityPhrase
            SAV:PL:TrustDate = PL:TrustDate
            SAV:PL:TrustDivision = PL:TrustDivision
            SAV:PL:DefCitation = PL:DefCitation
            SAV:PL:PlaCitation = PL:PlaCitation
  
         END


         PL:LanguageID = PAR:DefaultLanguageID      ! PRIME THE NEW ONE
         PL:PartyID = PAR:RecordID
         IF Access:ParLang.TryFetch(PL:PartyLanguageKey)
            PL:Record :=: SAV:ParLangRecord         ! IF IT DOESN'T EXIST COPY THE CURRENT CONTENTS TO THE NEW ONE
            PL:Salutation = ''
            DO MakeSalutation !pk here
            PL:LanguageID = PAR:DefaultLanguageID

            PL:MaritalDescription = GetMaritalDescription(PAR:DefaultLanguageID)

         ELSE
            IF ~PL:Name THEN PL:Name = SAV:PL:Name.
            IF ~PL:AlternativeName THEN PL:AlternativeName = SAV:PL:AlternativeName.
            IF ~PL:FirstName THEN PL:FirstName = SAV:PL:FirstName.
            IF ~PL:Title THEN PL:Title = SAV:PL:Title.
            IF ~PL:Initials THEN PL:Initials = SAV:PL:Initials.
            IF ~PL:IdentityNumber THEN PL:IdentityNumber = SAV:PL:IdentityNumber.
            IF ~PL:BirthDate THEN PL:BirthDate = SAV:PL:BirthDate.
            DO MakeSalutation ! pk here
            IF ~PL:PhysicalLine1 THEN PL:PhysicalLine1 = SAV:PL:PhysicalLine1.
            IF ~PL:PhysicalLine2 THEN PL:PhysicalLine2 = SAV:PL:PhysicalLine2.
            IF ~PL:PhysicalLine3 THEN PL:PhysicalLine3 = SAV:PL:PhysicalLine3.
            IF ~PL:PhysicalCode THEN PL:PhysicalCode = SAV:PL:PhysicalCode.
            IF ~PL:PostalLine1 THEN PL:PostalLine1 = SAV:PL:PostalLine1.
            IF ~PL:PostalLine2 THEN PL:PostalLine2 = SAV:PL:PostalLine2.
            IF ~PL:PostalLine3 THEN PL:PostalLine3 = SAV:PL:PostalLine3.
            IF ~PL:PostalCode THEN PL:PostalCode = SAV:PL:PostalCode.
            IF ~PL:SpouseName THEN PL:SpouseName = SAV:PL:SpouseName.
            IF ~PL:SpouseFirstName THEN PL:SpouseFirstName = SAV:PL:SpouseFirstName.
            IF ~PL:SpouseInitials THEN PL:SpouseInitials = SAV:PL:SpouseInitials.
            IF ~PL:SpouseIdentityNumber THEN PL:SpouseIdentityNumber = SAV:PL:SpouseIdentityNumber.
            IF ~PL:SpouseBirthDate THEN PL:SpouseBirthDate = SAV:PL:SpouseBirthDate.
            IF ~PL:DomiciledIn THEN PL:DomiciledIn = SAV:PL:DomiciledIn.

            IF ~PL:MaritalDescription THEN PL:MaritalDescription = GetMaritalDescription(PAR:DefaultLanguageID).

            IF ~PL:DeedsRegistry THEN PL:DeedsRegistry = SAV:PL:DeedsRegistry.
            IF ~PL:MarriageDate THEN PL:MarriageDate = SAV:PL:MarriageDate.
            IF ~PL:MarriagePlace THEN PL:MarriagePlace = SAV:PL:MarriagePlace.
            IF ~PL:MarriageCountry THEN PL:MarriageCountry = SAV:PL:MarriageCountry.
            IF ~PL:ANCNumber THEN PL:ANCNumber = SAV:PL:ANCNumber.
            IF ~PL:SpousePrincipalFlag THEN PL:SpousePrincipalFlag = SAV:PL:SpousePrincipalFlag.
            IF ~PL:RegistrationNumber THEN PL:RegistrationNumber = SAV:PL:RegistrationNumber.
            IF ~PL:AuthorityPhrase THEN PL:AuthorityPhrase = SAV:PL:AuthorityPhrase.
            IF ~PL:TrustDate THEN PL:TrustDate = SAV:PL:TrustDate.
            IF ~PL:TrustDivision THEN PL:TrustDivision = SAV:PL:TrustDivision.
            IF ~PL:DefCitation THEN PL:DefCitation = SAV:PL:DefCitation.
            IF ~PL:PlaCitation THEN PL:PlaCitation = SAV:PL:PlaCitation.
         END
         SAV:LanguageID = PAR:DefaultLanguageID
         ThisWindow.Update
         DO SetMaritalFields
         DISPLAY
     END

     IF ~(SAV:ParRegionID = PAR:ParRegionID) AND PAR:ParRegionID
          SAV:ParRegionID = PAR:ParRegionID
          LOC:Province = PROV:Description
          DISPLAY(?LOC:Province)
          IF ~PL:PostalCode
              PL:PostalCode = PREG:PostalCode
              DISPLAY(?PL:PostalCode)
          END
     END

      IF ~(SAV:BirthMonth = PAR:BirthMonth)
           SAV:BirthMonth = PAR:BirthMonth
           ?LOC:BirthMonth{PROP:Selected} = PAR:BirthMonth
      END




      IF ~(SAV:PAR:TaxPayer = PAR:TaxPayer)
           SAV:PAR:TaxPayer = PAR:TaxPayer
     
           IF PAR:TaxPayer = 'Y'
              ?PAR:TaxNumber:Prompt{PROP:Hide} = False
              ?PAR:TaxNumber{PROP:Hide} = False
              ?PAR:AnnualIncome:Prompt{PROP:Hide} = True
              ?PAR:AnnualIncome{PROP:Hide} = True

           ELSE

              ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = True
              ?PAR:SpouseTaxNumber{PROP:Hide} = True
              ?PAR:TaxNumber:Prompt{PROP:Hide} = True
              ?PAR:TaxNumber{PROP:Hide} = True
              ?PAR:AnnualIncome:Prompt{PROP:Hide} = False
              ?PAR:AnnualIncome{PROP:Hide} = False
           END
      END
     
     
      IF ~(SAV:PAR:SAResident = PAR:SAResident)
           SAV:PAR:SAResident = PAR:SAResident
     
           IF PAR:SAResident = 'Y'
     
              ?PAR:CountryOfResidence:Prompt{PROP:Hide} = True
              ?PAR:CountryOfResidence{PROP:Hide} = True
              ?PAR:PassportNumber:Prompt{PROP:Hide} = True
              ?PAR:PassportNumber{PROP:Hide} = True
              ?CountryOfResidenceButton{PROP:Hide} = True
     
           ELSE
     
     
              IF ~PAR:CountryOfResidence AND PAR:PhysicalCountryID
                  PROPSQLNext('SELECT 0,Description FROM Country WHERE RecordID = ' & PAR:PhysicalCountryID)
                  PAR:CountryOfResidence = ROW:Description
              END
     
              IF ~PAR:CountryOfResidence AND PAR:PostalCountryID
                  PROPSQLNext('SELECT 0,Description FROM Country WHERE RecordID = ' & PAR:PostalCountryID)
                  PAR:CountryOfResidence = ROW:Description
              END
     
              ?PAR:CountryOfResidence:Prompt{PROP:Hide} = False
              ?PAR:CountryOfResidence{PROP:Hide} = False
              ?PAR:PassportNumber:Prompt{PROP:Hide} = False
              ?PAR:PassportNumber{PROP:Hide} = False
              ?CountryOfResidenceButton{PROP:Hide} = False
     
           END
      END
  


      IF ~(SAV:PAR:SpouseTaxPayer = PAR:SpouseTaxPayer)
           SAV:PAR:SpouseTaxPayer = PAR:SpouseTaxPayer
     
           IF PAR:SpouseTaxPayer = 'Y'
              ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = False
              ?PAR:SpouseTaxNumber{PROP:Hide} = False
              ?PAR:SpouseAnnualIncome:Prompt{PROP:Hide} = True
              ?PAR:SpouseAnnualIncome{PROP:Hide} = True

           ELSE

              ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = True
              ?PAR:SpouseTaxNumber{PROP:Hide} = True
              ?PAR:SpouseTaxNumber:Prompt{PROP:Hide} = True
              ?PAR:SpouseTaxNumber{PROP:Hide} = True
              ?PAR:SpouseAnnualIncome:Prompt{PROP:Hide} = False
              ?PAR:SpouseAnnualIncome{PROP:Hide} = False
           END
      END
     
     
      IF ~(SAV:PAR:SpouseSAResident = PAR:SpouseSAResident)
           SAV:PAR:SpouseSAResident = PAR:SpouseSAResident
     
           IF PAR:SpouseSAResident = 'Y'
     
              ?PAR:SpouseCountryOfResidence:Prompt{PROP:Hide} = True
              ?PAR:SpouseCountryOfResidence{PROP:Hide} = True
              ?PAR:SpousePassportNumber:Prompt{PROP:Hide} = True
              ?PAR:SpousePassportNumber{PROP:Hide} = True
              ?CountryOfResidenceButton:2{PROP:Hide} = True
     
           ELSE
     

              IF ~PAR:SpouseCountryOfResidence AND PAR:PhysicalCountryID
                  PROPSQLNext('SELECT 0,Description FROM Country WHERE RecordID = ' & PAR:PhysicalCountryID)
                  PAR:SpouseCountryOfResidence = ROW:Description
              END
     
              IF ~PAR:SpouseCountryOfResidence AND PAR:PostalCountryID
                  PROPSQLNext('SELECT 0,Description FROM Country WHERE RecordID = ' & PAR:PostalCountryID)
                  PAR:SpouseCountryOfResidence = ROW:Description
              END
     

              ?PAR:SpouseCountryOfResidence:Prompt{PROP:Hide} = False
              ?PAR:SpouseCountryOfResidence{PROP:Hide} = False
              ?PAR:SpousePassportNumber:Prompt{PROP:Hide} = False
              ?PAR:SpousePassportNumber{PROP:Hide} = False
              ?CountryOfResidenceButton:2{PROP:Hide} = False
     
           END
      END
     !deceased party
    IF ~(SAV:LOC:PAR2:TaxPayer = LOC:PAR2:TaxPayer)
           SAV:LOC:PAR2:TaxPayer = LOC:PAR2:TaxPayer
     
           IF LOC:PAR2:TaxPayer = 'Y'
              ?LOC:PAR2:TaxNumber:Prompt{PROP:Hide} = False
              ?LOC:PAR2:TaxNumber{PROP:Hide} = False
              ?LOC:PAR2:AnnualIncome:Prompt{PROP:Hide} = True
              ?LOC:PAR2:AnnualIncome{PROP:Hide} = True

           ELSE

              
              ?LOC:PAR2:TaxNumber:Prompt{PROP:Hide} = True
              ?LOC:PAR2:TaxNumber{PROP:Hide} = True
              ?LOC:PAR2:AnnualIncome:Prompt{PROP:Hide} = False
              ?LOC:PAR2:AnnualIncome{PROP:Hide} = False
           END
      END
      IF ~(SAV:LOC:PAR2:SAResident = LOC:PAR2:SAResident)
           SAV:LOC:PAR2:SAResident = LOC:PAR2:SAResident
     
           IF LOC:PAR2:SAResident = 'Y'
     
              ?LOC:PAR2:CountryOfResidence:Prompt{PROP:Hide} = True
              ?LOC:PAR2:CountryOfResidence{PROP:Hide} = True
              ?LOC:PAR2:PassportNumber:Prompt{PROP:Hide} = True
              ?LOC:PAR2:PassportNumber{PROP:Hide} = True
              ?DeceasedCountryOfResidenceButton{PROP:Hide} = True
     
           ELSE
     
     
              IF ~LOC:PAR2:CountryOfResidence AND LOC:PAR2:PhysicalCountryID
                  PROPSQLNext('SELECT 0,Description FROM Country WHERE RecordID = ' & LOC:PAR2:PhysicalCountryID)
                  LOC:PAR2:CountryOfResidence = ROW:Description
              END
     
              
     
              ?LOC:PAR2:CountryOfResidence:Prompt{PROP:Hide} = False
              ?LOC:PAR2:CountryOfResidence{PROP:Hide} = False
              ?LOC:PAR2:PassportNumber:Prompt{PROP:Hide} = False
              ?LOC:PAR2:PassportNumber{PROP:Hide} = False
              ?DeceasedCountryOfResidenceButton{PROP:Hide} = False
     
           END
      END


  ! ADDED BY RICK 23/11/2010


  ReturnValue = PARENT.TakeFieldEvent()
  IF FIELD()=?LOC:PL2:BirthDate
    
  END
  IF FIELD()=?PAR:DateResolutionSigned
    
  END
  IF FIELD()=?PAR:LastInstructedDate
    
  END
  IF FIELD()=?PAR:RemoteAccessExpiry
    
  END
  IF FIELD()=?PL:BirthDate
    
  END
  IF FIELD()=?PL:GPASignedOn
    
  END
  IF FIELD()=?PL:MarriageDate
    
  END
  IF FIELD()=?PL:SpouseBirthDate
    
  END
  IF FIELD()=?PL:TrustDate
    
  END
  CASE FIELD()
  OF ?CRMTab
    
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
    OF ?Sheet1
      IF CHOICE(?Sheet1) > LOC:ExistingTabs    ! THESE ARE THE EXTRA SCREENS

         UNHIDE(?ModifyButton)
         UNHIDE(?DeleteButton)
      
         DO CalculateAllFields
      
      ELSE

         HIDE(?ModifyButton)
         HIDE(?DeleteButton)

      END
      
      If Sheet1 = 'FICA Compliance'
        DO SetFICAStatus
        FLUSH(BRW48::View:Browse)
        ThisWindow.Reset(1)
      .
    OF ?PL:Salutation
                           !pk here
    OF ?PL:DomiciledIn
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        COU:Description = Contents(?)
        Set(COU:DescriptionKey,COU:DescriptionKey)
        If KeyCode() = DownKey Then Next(Country).
        If KeyCode() = UpKey Then Previous(Country).
        Loop
          If KeyCode() = UpKey Then Previous(Country) Else Next(Country).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (Country) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(Upper(Contents(?)) = Upper(Sub(COU:Description,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,COU:Description)
            ?{PROP:SelEnd} = Len(COU:Description)
            ?{PROP:Touched} = True
            Display
      
      
            Post(EVENT:Accepted,?PL:DomiciledIn)
            Break
          .
          SetKeycode(0)
        .
    OF ?PL:DeedsRegistry
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        DEO:Name = Contents(?)
        Set(DEO:NameKey,DEO:NameKey)
        If KeyCode() = DownKey Then Next(DeedsOffice).
        If KeyCode() = UpKey Then Previous(DeedsOffice).
        Loop
          If KeyCode() = UpKey Then Previous(DeedsOffice) Else Next(DeedsOffice).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (DeedsOffice) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(Upper(Contents(?)) = Upper(Sub(DEO:Name,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,DEO:Name)
            ?{PROP:SelEnd} = Len(DEO:Name)
            ?{PROP:Touched} = True
            Display
      
      
            Post(EVENT:Accepted,?PL:DeedsRegistry)
            Break
          .
          SetKeycode(0)
        .
    OF ?PL:MarriageCountry
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        COU:Description = Contents(?)
        Set(COU:DescriptionKey,COU:DescriptionKey)
        If KeyCode() = DownKey Then Next(Country).
        If KeyCode() = UpKey Then Previous(Country).
        Loop
          If KeyCode() = UpKey Then Previous(Country) Else Next(Country).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (Country) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(Upper(Contents(?)) = Upper(Sub(COU:Description,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,COU:Description)
            ?{PROP:SelEnd} = Len(COU:Description)
            ?{PROP:Touched} = True
            Display
      
      
            Post(EVENT:Accepted,?PL:MarriageCountry)
            Break
          .
          SetKeycode(0)
        .
    END
  ReturnValue = PARENT.TakeNewSelection()
    IF FIELD() = ?Sheet1
       CASE CHOICE(?Sheet1)
         OF 1
            ?TabHeading{PROP:Text} = REPLACE(?NameTab{PROP:Text},'&','')
         OF 2
            ?TabHeading{PROP:Text} = REPLACE(?MaritalTab{PROP:Text},'&','')
         OF 3
            ?TabHeading{PROP:Text} = REPLACE(?SignatoriesTab{PROP:Text},'&','')
         OF 4
            ?TabHeading{PROP:Text} = REPLACE(?ShareholdersTab{PROP:Text},'&','')
         OF 5
            ?TabHeading{PROP:Text} = REPLACE(?TaxDetailsTab{PROP:Text},'&','')
         OF 6
            ?TabHeading{PROP:Text} = REPLACE(?AuditorsTab{PROP:Text},'&','')
         OF 7
            ?TabHeading{PROP:Text} = REPLACE(?FinancialTab{PROP:Text},'&','')
         OF 8
            ?TabHeading{PROP:Text} = REPLACE(?CRMTab{PROP:Text},'&','')
         OF 9
            ?TabHeading{PROP:Text} = REPLACE(?FileNotesTab{PROP:Text},'&','')
         OF 10
            ?TabHeading{PROP:Text} = REPLACE(?ProductsTab{PROP:Text},'&','')
         OF 11
            ?TabHeading{PROP:Text} = REPLACE(?MiscTab{PROP:Text},'&','')
         OF 12
            ?TabHeading{PROP:Text} = REPLACE(?CitationsTab{PROP:Text},'&','')
         OF 13
            ?TabHeading{PROP:Text} = REPLACE(?PAOTab{PROP:Text},'&','')
         OF 14
            ?TabHeading{PROP:Text} = REPLACE(?RelationshipsTab{PROP:Text},'&','')
         OF 15
            ?TabHeading{PROP:Text} = REPLACE(?Notes{PROP:Text},'&','')
         OF 16
            ?TabHeading{PROP:Text} = REPLACE(?FICATab{PROP:Text},'&','')
         OF 17
            ?TabHeading{PROP:Text} = REPLACE(?Employer{PROP:Text},'&','')
         OF 18
            ?TabHeading{PROP:Text} = REPLACE(?DeceasedTab{PROP:Text},'&','')
         ELSE
            ?TabHeading{PROP:Text} = ''
        END
     END
    IF ?TabHeading{PROP:Text} = ''
       GET(ScreenQueue,CHOICE(?Sheet1) - LOC:ExistingTabs)
       IF ~ERROR()
           ?TabHeading{PROP:Text} = SCRQ:ScreenTitle
       ELSE
           ?TabHeading{PROP:Text} = ''
       END
    END
!    IF ?TabHeading{PROP:Text} = 'Relationships'
!        BRW31.ResetSort(1)
!        Display
!    END
    
  
  
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
    OF ?PL:Title
      ! pk here - leave this commented out
      !DO MakeSalutation
    OF ?PL:Salutation
      ! pk here
!      IF LOC:ChangeSalutation AND PL:Salutation = ''
!      
!         IF MESSAGE('Do you want to automatically generate a Salutation for this Party?','Salutation',ICON:Question,BUTTON:OK+BUTTON:Cancel,BUTTON:OK) = BUTTON:OK THEN DO MakeSalutation.
!         LOC:ChangeSalutation = FALSE
!      
!      END


!      IF PL:Salutation = ''
!         DO MakeSalutation
!      END
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
        LSFQ:Field = ?LOC:Entity
        LSFQ:Description = 'Entity (Dropdown)'
      End
      Begin
        LSFQ:Field = ?LOC:PartyType
        LSFQ:Description = 'Type (Dropdown)'
      End
      Begin
        LSFQ:Field = ?LOC:Role
        LSFQ:Description = 'Role (Dropdown)'
      End
      Begin
        LSFQ:Field = ?PAR:MatterPrefix
        LSFQ:Description = 'Code'
      End
      Begin
        LSFQ:Field = ?PL:Name
        LSFQ:Description = 'Name'
      End
      Begin
        LSFQ:Field = ?PL:FirstName
        LSFQ:Description = 'First Name'
      End
      Begin
        LSFQ:Field = ?PL:Title
        LSFQ:Description = 'Title'
      End
      Begin
        LSFQ:Field = ?PL:Initials
        LSFQ:Description = 'Initials'
      End
      Begin
        LSFQ:Field = ?PL:AlternativeName
        LSFQ:Description = 'Alternative Name'
      End
      Begin
        LSFQ:Field = ?PL:IdentityNumber
        LSFQ:Description = 'ID Number/Reg No'
      End
      Begin
        LSFQ:Field = ?PL:BirthDate
        LSFQ:Description = 'Date of Birth'
      End
      Begin
        LSFQ:Field = ?LOC:Language
        LSFQ:Description = 'Language'
      End
      Begin
        LSFQ:Field = ?PL:Salutation
        LSFQ:Description = 'Salutation'
      End
      Begin
        LSFQ:Field = ?PL:PostalLine1
        LSFQ:Description = 'Postal Line 1'
      End
      Begin
        LSFQ:Field = ?PL:PostalLine2
        LSFQ:Description = 'Postal Line 2'
      End
      Begin
        LSFQ:Field = ?PL:PostalLine3
        LSFQ:Description = 'Postal Line 3'
      End
      Begin
        LSFQ:Field = ?PL:PostalCode
        LSFQ:Description = 'Postal Code'
      End
      Begin
        LSFQ:Field = ?LOC:PostalCountry
        LSFQ:Description = 'Postal Country (Dropdown)'
      End
      Begin
        LSFQ:Field = ?CallLookup
        LSFQ:Description = 'Postal Country (Lookup)'
      End
      Begin
        LSFQ:Field = ?PL:PhysicalLine1
        LSFQ:Description = 'Physical Line 1'
      End
      Begin
        LSFQ:Field = ?PL:PhysicalLine2
        LSFQ:Description = 'Physical Line 2'
      End
      Begin
        LSFQ:Field = ?PL:PhysicalLine3
        LSFQ:Description = 'Physical Line 3'
      End
      Begin
        LSFQ:Field = ?PL:PhysicalCode
        LSFQ:Description = 'Physical Code'
      End
      Begin
        LSFQ:Field = ?LOC:PhysicalCountry
        LSFQ:Description = 'Physical Country (Dropdown)'
      End
      Begin
        LSFQ:Field = ?CallLookup:2
        LSFQ:Description = 'Physical Country (Lookup)'
      End
      Begin
        LSFQ:Field = ?PL:TrustDate
        LSFQ:Description = 'Reg Date'
      End
      Begin
        LSFQ:Field = ?TelephoneList
        LSFQ:Description = 'Contact Details'
      End
      Begin
        LSFQ:Field = ?LOC:MaritalStatus
        LSFQ:Description = 'Marital Status'
      End
      Begin
        LSFQ:Field = ?SelectEntityButton
        LSFQ:Description = 'Entity (Lookup)'
      End
      Begin
        LSFQ:Field = ?SelectPartyTypeButton
        LSFQ:Description = 'Type (Lookup)'
      End
      Begin
        LSFQ:Field = ?SelectRoleButton
        LSFQ:Description = 'Role (Lookup)'
      End
      Begin
        LSFQ:Field = ?PL:MaritalDescription
        LSFQ:Description = 'Marital Wording'
      End
      Begin
        LSFQ:Field = ?MarriageGroup
        LSFQ:Description = 'Marriage Details'
      End
      Begin
        LSFQ:Field = ?SpouseGroup
        LSFQ:Description = 'Marriage Details (Spouse)'
      End
      Begin
        LSFQ:Field = ?Group6
        LSFQ:Description = 'Signatories'
      End
      Begin
        LSFQ:Field = ?ShareholdersGroup
        LSFQ:Description = 'Shareholders'
      End
      Begin
        LSFQ:Field = ?PartyTaxGroup
        LSFQ:Description = 'Tax Details'
      End
      Begin
        LSFQ:Field = ?AuditorsGroup
        LSFQ:Description = 'Auditors'
      End
      Begin
        LSFQ:Field = ?SpouseTaxGroup
        LSFQ:Description = 'Tax Details (Spouse)'
      End
      Begin
        LSFQ:Field = ?BankAccountGroup
        LSFQ:Description = 'Bank Accounts'
      End
      Begin
        LSFQ:Field = ?RemoteAccessGroup
        LSFQ:Description = 'Remote Access Details'
      End
      Begin
        LSFQ:Field = ?MiscellaneousGroup
        LSFQ:Description = 'Miscellaneous Settings'
      End
      Begin
        LSFQ:Field = ?PowerOfAttorneyGroup
        LSFQ:Description = 'Power of Attorney Details'
      End
      Begin
        LSFQ:Field = ?PAR:RemoteAccessPassword
        LSFQ:Description = 'Remote Access Password'
      End
      Begin
        LSFQ:Field = ?PAR:RemoteAccessExpiry
        LSFQ:Description = 'Remote Access Expiry Date'
      End
      Begin
        LSFQ:Field = ?PAR:NoFICAFlag
        LSFQ:Description = 'Fica Exempt'
      End
       Break
    .
    If LSF:CheckFieldFlag
      Clear(SF:Record)
      SF:SecGroupId = GLO:SecGroupId
      SF:SecProc    = 'Browse - Address Book'
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
    SP:Description = 'Browse - Address Book - Insert'
  Of ChangeRecord
    LSF:CheckFieldFlag = True
    SP:Description = 'Browse - Address Book - Change'
  Of DeleteRecord
    SP:Description = 'Browse - Address Book - Delete'
  Of ViewRecord
    SP:Description = 'Browse - Address Book - View'
  Else
    SP:Description = 'Browse - Address Book'
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
    BrowseSecProc('Browse - Address Book',1)
    Return Level:Benign
PDPC:LOC:PL2:BirthDate.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF LOC:PL2:BirthDate <> L:Default
    POST(EVENT:Accepted,?LOC:PL2:BirthDate)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:PAR:DateResolutionSigned.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF PAR:DateResolutionSigned <> L:Default
    POST(EVENT:Accepted,?PAR:DateResolutionSigned)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:PAR:LastInstructedDate.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF PAR:LastInstructedDate <> L:Default
    POST(EVENT:Accepted,?PAR:LastInstructedDate)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:PAR:RemoteAccessExpiry.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF PAR:RemoteAccessExpiry <> L:Default
    POST(EVENT:Accepted,?PAR:RemoteAccessExpiry)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:PL:BirthDate.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF PL:BirthDate <> L:Default
    POST(EVENT:Accepted,?PL:BirthDate)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:PL:GPASignedOn.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF PL:GPASignedOn <> L:Default
    POST(EVENT:Accepted,?PL:GPASignedOn)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:PL:MarriageDate.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF PL:MarriageDate <> L:Default
    POST(EVENT:Accepted,?PL:MarriageDate)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:PL:SpouseBirthDate.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF PL:SpouseBirthDate <> L:Default
    POST(EVENT:Accepted,?PL:SpouseBirthDate)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:PL:TrustDate.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF PL:TrustDate <> L:Default
    POST(EVENT:Accepted,?PL:TrustDate)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDSC:LOC:PL2:BirthDate.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV
PDSC:PAR:DateResolutionSigned.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV
PDSC:PAR:LastInstructedDate.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV
PDSC:PAR:RemoteAccessExpiry.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV
PDSC:PL:BirthDate.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV
PDSC:PL:GPASignedOn.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV
PDSC:PL:MarriageDate.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV
PDSC:PL:SpouseBirthDate.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV
PDSC:PL:TrustDate.TakeFieldEvent PROCEDURE
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


FDB36.TakeNewSelection PROCEDURE

  CODE
  PARENT.TakeNewSelection
     IF ~(SAV:Category = ENT1:Category) AND ENT1:Category ! WILL DO THIS EVERYTIME ON SCREEN LOAD OR WHEN THE ENTITY CHANGES

         SAV:Category = ENT1:Category

         IF ENT1:Category = 1
            PAR:PartyTypeID = 1 ! DISPLAY "MALE"
         ELSIF ENT1:Category = 2
            PAR:PartyTypeID = 3 ! DISPLAY "Business"

         ! Rick & Kelvin FB#1775
         ELSIF ENT1:Category = 4
            PAR:PartyTypeID = 17 ! DISPLAY "Deceased Estates as Default"

         ELSE
             PAR:PartyTypeID = 0 ! DISPLAY THE TOP ONE OF THE NEW CATEGORY
         END

         FDB9.ResetQueue(1)      ! RESET THE PARTY TYPE DROP DOWN LIST


! 11/6/2014 - REMOVED BY RICK. NOT SURE WHY IT WAS HERE IN THE FIRST PLACE - LET THE USER DELETE THE SIGNATORIES IF THEY THINK IT IS APPROPRIATE!!
         !PROPSQL('DELETE ParSign WHERE PartyID = ' & PAR:RecordID)
         !BRW48.ResetQueue(1)

         DO SetScreenPrompts

     END


FDB9.TakeNewSelection PROCEDURE

  CODE
  PARENT.TakeNewSelection
         ! Rick & Kelvin FB#1775
         IF ENT1:Category = 4
            DO SetScreenPrompts
         END
            
  


FDB9.ValidateRecord PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.ValidateRecord()
  IF ENT1:Category
     IF ENT1:Category = 10  ! UNKNOWN
        ! SHOW ALL TYPES
     ELSE
        IF ~(PT1:Category = ENT1:Category) THEN RETURN Record:Filtered.
     END
  END
  
  
  
  
  RETURN ReturnValue


BRW10.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert
    SELF.ChangeControl=?Change
    SELF.DeleteControl=?Delete
  END


BRW14.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert:2
    SELF.ChangeControl=?Change:2
    SELF.DeleteControl=?Delete:2
  END


BRW14.SetQueueRecord PROCEDURE

  CODE
  IF PS:FirstName
     LOC:ParSign = PS:FirstName & ' ' & PS:LastName
     IF PS:Position
        LOC:ParSign = LOC:ParSign & ' (' & PS:Position & ')'
     END
  ELSE
     LOC:ParSign = PS:LastName
  END
  
  
  PARENT.SetQueueRecord


BRW31.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert:3
    SELF.ChangeControl=?Change:3
    SELF.DeleteControl=?Delete:3
  END


BRW31.ResetQueue PROCEDURE(BYTE ResetMode)

  CODE
  PARENT.ResetQueue(ResetMode)
  IF RECORDS(SELF.ListQueue)
     ?EditRelationshipPartyButton{PROP:Disable} = False
  ELSE
     ?EditRelationshipPartyButton{PROP:Disable} = True
  END


BRW31.SetQueueRecord PROCEDURE

  CODE
  IF PREL:DefaultContactFlag
     LOC:DefaultContact = 'Yes'
  ELSE
     LOC:DefaultContact = ''
  END
  PARENT.SetQueueRecord


BRW33.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert:4
    SELF.ChangeControl=?Change:4
    SELF.DeleteControl=?Delete:4
  END


BRW33.SetQueueRecord PROCEDURE

  CODE
  LOC:AccountCode = Choose(ACB:AccountCode,'Current (cheque)','Savings account','Transmission account','Bond account','Other')
  If ~PAR:ParBankId Then PAR:ParBankId = ACB:RecordId.
                  
  
  PARENT.SetQueueRecord
  IF (PAR:ParBankId = ACB:RecordId)
    SELF.Q.ACB:Description_Icon = 2
  ELSE
    SELF.Q.ACB:Description_Icon = 1
  END


BRW42.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
    OMIT('***** FB1683 *****')
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert:5
    SELF.DeleteControl=?Delete:5
  END
  !***** FB1683 *****
  
  IF WM.Request <> ViewRecord
  
     !IF PAR:LockParty AND ~GLO:SupervisorFlag
  
         !MESSAGE('This Party is currently locked and can only be edited by a user with Supervisor rights.', 'Party locked for editing', ICON:Exclamation)
         !Return RequestCancelled
  
     !ELSE
  
         SELF.InsertControl=?Insert:5
         SELF.DeleteControl=?Delete:5
  
     !END
  
  END
  


BRW8.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert:6
    SELF.ChangeControl=?Change:5
    SELF.DeleteControl=?Delete:6
  END


BRW16.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert:7
    SELF.ChangeControl=?Change:6
    SELF.DeleteControl=?Delete:7
  END


BRW41.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert:8
    SELF.ChangeControl=?Change:7
    SELF.DeleteControl=?Delete:8
  END


BRW48.ApplyFilter PROCEDURE

  CODE
  !BRW48::View:Browse{PROP:SQLFilter} = 'a.partyid = ' & PAR:RecordId & ' and c.EntityID = ' & PAR:EntityId
  PARENT.ApplyFilter


BRW48.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord
    SELF.ChangeControl=?Change:8
  END


BRW48.SetQueueRecord PROCEDURE

  CODE
  IF FIC:Expiry
     IF PARF:Date
        LOC:FicaExpiresDate = CLIP(LEFT(FORMAT(GetFicaExpiryDate(PARF:Date,FIC:Expiry),@D17)))
     ELSE
        LOC:FicaExpiresDate = CLIP(LEFT(FORMAT(FIC:Expiry,@N_5))) & ' months'
     END
  ELSE
     LOC:FicaExpiresDate = 'Never'
  END
  PARENT.SetQueueRecord
  IF (0)
    SELF.Q.LOC:FicaTick_Icon = 1
  ELSE
    SELF.Q.LOC:FicaTick_Icon = 2
  END
  
  
  IF SELF.Q.PARF:Date    ! IF THE FICA DOCUMENT HAS BEEN CHECKED - CHECK IF IT HAS EXPIRED
     IF SELF.Q.FIC:Expiry
        IF GLO:TodaysDate  > GetFicaExpiryDate(SELF.Q.PARF:Date,SELF.Q.FIC:Expiry)
           SELF.Q.LOC:FicaTick_Icon = 1     ! OUT OF DATE
        ELSE
           SELF.Q.LOC:FicaTick_Icon = 2     ! OK
        END
     ELSE
        SELF.Q.LOC:FicaTick_Icon = 2        ! OK
     END
  ELSE
     SELF.Q.LOC:FicaTick_Icon = 1           ! HAS NOT BEEN CHECKED
  END
!JESS2
  IF SELF.Q.LOC:FicaTick_Icon = 1
     IF PAR:FicaRequestDate AND GLO:TodaysDate >= PAR:FicaRequestDate
        IF GLO:TodaysDate - PAR:FicaRequestDate < 30  ! 30 days have NOT passed
           SELF.Q.LOC:FicaTick_Icon = 3     ! QUESTION MARK
        END
     END
  END
  
  

SaveScreenData      PROCEDURE

   CODE

       IF CHOICE(?Sheet1) < LOC:ExistingTabs THEN RETURN.

        CLEAR(PEF:Record)
        PEF:DocScreenID = SCRQ:DocScrnID
        PEF:PartyID = PAR:RecordID
        IF ~Access:ParField.Fetch(PEF:PrimaryKey)

            DO UpdateDataRecord

            Access:ParField.TryUpdate

        END


GetMatterPrefix      PROCEDURE  (TheName)             ! Declare Procedure
=========================================================
LOC:ReturnString        LIKE(PAR:MatterPrefix)
LOC:MatterPrefix        LIKE(PAR:MatterPrefix)
LOC:PrefixCounter       LONG

  CODE
      LOC:PrefixCounter = 1
      LOC:MatterPrefix = UPPER(SUB(TheName,1,20))

      If CTL:MatterPrefixOption = 1

         LOC:MatterPrefix = Left(LOC:MatterPrefix,1)

         CLEAR(ROW:Record)
         RowCounter{PROP:SQL} = 'SELECT COUNT(1) FROM Party WHERE MatterPrefix LIKE ''' & LOC:MatterPrefix & '%'''
         NEXT(RowCounter)
         LOC:PrefixCounter += ROW:Counter


        LOOP

            IF LOC:PrefixCounter > 9999999
               LOC:ReturnString = CLIP(LOC:MatterPrefix) & CLIP(LEFT(FORMAT(LOC:PrefixCounter,@n09)))
            ELSIF LOC:PrefixCounter > 999999
               LOC:ReturnString = CLIP(LOC:MatterPrefix) & CLIP(LEFT(FORMAT(LOC:PrefixCounter,@n07)))
            ELSIF LOC:PrefixCounter > 99999
               LOC:ReturnString = CLIP(LOC:MatterPrefix) & CLIP(LEFT(FORMAT(LOC:PrefixCounter,@n06)))
            ELSIF LOC:PrefixCounter > 9999
               LOC:ReturnString = CLIP(LOC:MatterPrefix) & CLIP(LEFT(FORMAT(LOC:PrefixCounter,@n05)))
            ELSE
               LOC:ReturnString = CLIP(LOC:MatterPrefix) & CLIP(LEFT(FORMAT(LOC:PrefixCounter,@n04)))
            END

            IF ~CheckDuplicateMatterPrefix(LOC:ReturnString) THEN BREAK.

            LOC:PrefixCounter += 1

        END

     ELSE

        LOC:MatterPrefix = StripFileRefCharacters(LOC:MatterPrefix)

        LOC:MatterPrefix = Left(LOC:MatterPrefix,3)

        LOOP

             LOC:ReturnString = CLIP(LOC:MatterPrefix) & LOC:PrefixCounter

             IF ~CheckDuplicateMatterPrefix(LOC:ReturnString) THEN BREAK.

             LOC:PrefixCounter += 1
        END

      END

      RETURN LOC:ReturnString



CheckDuplicateMatterPrefix PROCEDURE  (TheMatterPrefix)
=========================================================
LOC:ReturnValue     BYTE

  CODE
  CLEAR(ROW:Record)
  RowCounter{PROP:SQL} = 'SELECT COUNT(1) FROM Party WHERE MatterPrefix = ''' & TheMatterPrefix & ''''

  NEXT(RowCounter)
  IF ROW:Counter
     LOC:ReturnValue = 1

  ELSE
     LOC:ReturnValue = 0

  END




GetFicaStatus        PROCEDURE                        ! Declare Procedure
================================
LOC:Script           CSTRING(255)
LOC:ReturnValue     BYTE
LOC:Date            LONG
  CODE
! PRESUMES PAR:EntityID AND PAR:RecordID ARE IN MEMORY
  CLEAR(ENTF:Record)
  ENTF:EntityID = PAR:EntityID
  SET(ENTF:PrimaryKey,ENTF:PrimaryKey)
  LOOP UNTIL Access:EntityFica.Next()
       IF ~(ENTF:EntityID = PAR:EntityID) THEN BREAK.

       LOC:Script = 'SELECT PartyID,'''',Date FROM ParFica WHERE PartyID = ' & PAR:RecordID & ' AND FicaItemID = ' & ENTF:FicaItemID
       PROPSQLNext(LOC:Script,'SetFicaStatus')

       IF ROW:Counter       ! IF A RECORD EXISTS

          IF ROW:Amount1    ! IF THE FICA DOCUMENT HAS BEEN CHECKED - CHECK IF IT HAS EXPIRED

             LOC:Date = ROW:Amount1

             PROPSQLNext('SELECT Expiry FROM FicaItem WHERE RecordID = ' & ENTF:FicaItemID,'SetFicaStatus')

             IF ROW:Counter

                IF GLO:TodaysDate > GetFicaExpiryDate(LOC:Date,ROW:Counter)

                   LOC:ReturnValue = 1     ! OUT OF DATE

                END

             END

          ELSE

             LOC:ReturnValue = 1     ! HAS NOT BEEN CHECKED

          END

       ELSE         ! NO PARFICA RECORD EXISTS

         CLEAR(PARF:Record)
         PARF:PartyID = PAR:RecordID
         PARF:FicaItemID = ENTF:FicaItemID

         IF Access:ParFica.Insert()
            MESSAGE('Error encountered adding a record to the Party Fica table.||Error:' & ERROR(),'Error',ICON:Exclamation)

         .

         LOC:ReturnValue = 1     ! DID NOT EXIST


       END

  END


  PAR:FicaCompliantFlag = Choose( LOC:ReturnValue = 0,1,0)

  RETURN LOC:ReturnValue




GetMaritalDescription
====================
  DES:LanguageID = TheLanguageID
  IF ~Access:Descript.TryFetch(DES:PrimaryKey)
      CASE PAR:MaritalStatus
           OF 'UNM'
              EXECUTE PAR:UnmarriedStatus
                 LOC:MaritalDescription = DES:UNMaritalDescription  ! Never Married
                 LOC:MaritalDescription = DES:DIVMaritalDescription ! Divorced
                 LOC:MaritalDescription = DES:WIDMaritalDescription ! Widowed
              ELSE
                 LOC:MaritalDescription = DES:UNMaritalDescription
              END
           OF 'INC'
              LOC:MaritalDescription = DES:INMaritalDescription
           OF 'OUT'
              LOC:MaritalDescription = DES:OUMaritalDescription
           OF 'FOR'
              LOC:MaritalDescription = DES:FOMaritalDescription
           OF 'OTM'
              LOC:MaritalDescription = DES:OTMaritalDescription
           OF 'CUI'
              LOC:MaritalDescription = DES:CUIMaritalDescription
           OF 'CUO'
              LOC:MaritalDescription = DES:CUOMaritalDescription
           ELSE
              LOC:MaritalDescription = '*** Unknown (' & PAR:MaritalStatus & ') ***'
      END
  ELSE
      LOC:MaritalDescription = '*** Unknown (' & PAR:MaritalStatus & ') ***'
  END
  Access:Descript.Close

  RETURN LOC:MaritalDescription



CheckMatterAccess    PROCEDURE  (TheMatterID)         ! Declare Procedure
LOC:ReturnValue  BYTE(0)
LOC:ArchiveFlag  BYTE
LOC:Access       STRING(1)
LOC:EmployeeID   LONG

  CODE
    IF GLO:SupervisorFlag THEN RETURN 0.    ! SUPERVISOR IS ALLOWED FULL ACCESS

    PROPSQLNext('SELECT ArchiveFlag, Access, EmployeeID FROM Matter WHERE RecordID = ' & TheMatterID,'CheckMatterAccess')
    LOC:ArchiveFlag = ROW:Counter
    LOC:Access = ROW:Description
    LOC:EmployeeID = ROW:Amount1

    IF (LOC:Access = 'R' OR LOC:Access = 'V') AND ~(GLO:EmployeeID = LOC:EmployeeID)
       If ~CheckEmployeeAllowed(LOC:EmployeeID)
           LOC:ReturnValue = 1  !RESTRICT ACCESS TO THIS MATTER
       END
    END

    IF LOC:ArchiveFlag = True and GLO:SecMatterArchivedFlag = False
       LOC:ReturnValue = 1  !RESTRICT ACCESS TO THIS MATTER
    END

    RETURN LOC:ReturnValue

CheckMatterConditions PROCEDURE  (TheProgramLocation,<LOC:SilentMode>) ! Declare Procedure
LOC:ReturnValue     BYTE
LOC:Data            LIKE(MC:TrueCondition)


OPTION('Apply'),AT(40,52,295,137),USE(MC:ProgramLocation),TIP('Where must it be applied?')
  RADIO('Take on a Matter'),AT(56,68),USE(?MC:ProgramLocation:Radio1),TIP('Check the Condition when the User presses OK in the Matter Take On screen'),
  VALUE('M')
  RADIO('Save the Document Database (F3)'),AT(132,68),USE(?MC:ProgramLocation:Radio2),TIP('Check the Condition when the User tries to save a Matter in the Document Database screen'),
  VALUE('D')
  RADIO('Both'),AT(264,68),USE(?MC:ProgramLocation:Radio3),TIP('Check the Condition in both the Matter Take On Screen or the Document Database'),
  VALUE('B')
  RADIO('Add a Party to the Address Book'),AT(56,100),USE(?MC:ProgramLocation:Radio1:2),TIP('Check the Condition when the User adds a Party in the Address Book'),
  VALUE('A')
  RADIO('Add a Party using Quick Insert'),AT(180,100),USE(?MC:ProgramLocation:Radio1:4),TIP('Check the Condition when the User adds a Party using the Quick Party Insert screen'),
  VALUE('Q')
  RADIO('Both'),AT(296,100),USE(?MC:ProgramLocation:Radio1:5),TIP('Check the Condition when the User adds a Party'),
  VALUE('P')
  RADIO('Modify a Party in the Address Book or when assigning the Party to a Matter'),AT(56,116),USE(?MC:ProgramLocation:Radio1:7),TIP('Check the Condition when the User edits a Party or a MatParty record'),
  VALUE('E')
  RADIO('Modify a Telephone Number in the Address Book'),AT(56,132),USE(?MC:ProgramLocation:Radio1:6),TIP('Check the Condition when the User changes a telephone number'),
  VALUE('T')
  RADIO('Create a File Note with a Stage Code'),AT(56,164),USE(?MC:ProgramLocation:Radio1:3),TIP('Check the Condition when the User tries to create a Stage'),
  VALUE('F')
END

  CODE
  LOC:ReturnValue = 0

  Access:MatterCondition.Open
  Access:MatterCondition.Usefile

  Clear(MC:Record)
  SET(MC:PrimaryKey,MC:PrimaryKey)
  LOOP UNTIL Access:MatterCondition.Next()

       IF MC:ProgramLocation = 'B'  ! BOTH SCREENS
          IF ~(TheProgramLocation = 'M' OR TheProgramLocation = 'D') ! IF BOTH AND NOT MATTER OR DOCGEN THEN CYCLE
              CYCLE
          END
       END

       IF MC:ProgramLocation = 'P'  ! BOTH SCREENS
          IF ~(TheProgramLocation = 'A' OR TheProgramLocation = 'Q') ! IF BOTH AND NOT PARTY OR QUICK PARTY INSERT THEN CYCLE
               CYCLE
          END
       END

       IF MC:ProgramLocation = 'B' OR MC:ProgramLocation = 'P'
          ! HANDLED ABOVE
       ELSIF ~(MC:ProgramLocation = TheProgramLocation)
          CYCLE
       END

 IF GLO:DebuggingFlag
  message('TheProgramLocation = ' & TheProgramLocation &|
          '|MC:TrueCondition = ' & MC:TrueCondition &|
          '|GLO:SecGroupID = ' & GLO:SecGroupID &|
          '|GLO:SupervisorFlag = ' & GLO:SupervisorFlag &|
          '|EVALUATE(MC:TrueCondition) = ' & EVALUATE(MC:TrueCondition),'Debugging Data Capture Conditions')
  END
       
       
       LOC:Data = ReplaceTextBoxFields(MC:TrueCondition,0,-1,-1,-1)
       IF EVALUATE(LOC:Data) = 0

          CYCLE

       ELSE

          IF LOC:SilentMode
          ELSE
             MESSAGE(MC:Message &'|','Message',ICON:Exclamation)
          END

          LOC:ReturnValue = 1
          BREAK
       END

  END

  Access:MatterCondition.Close

  RETURN LOC:ReturnValue

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
 RETURN(LOC:TextFiel
