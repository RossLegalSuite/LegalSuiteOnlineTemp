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


UpdateMatParty PROCEDURE                              !Generated from procedure template - Window

 INCLUDE('UpdateMatterExtraScreenSource','Data')

ActionMessage        CSTRING(40)
LOC:DefaultScreenID  LONG
LOC:Role             CSTRING(50)
LOC:Attorney         CSTRING(100)
LOC:Option           BYTE
LOC:Contact          CSTRING(50)
LOC:LookupPropText   STRING(2)
LOC:Language         CSTRING(20)
RatesCustomerRoleQueue QUEUE,PRE(RCRQ)
Description          CSTRING(50)
                     END
LOC:Name             CSTRING(100)
SAV:MatterId         LONG
SAV:RoleId            Like(MP:RoleID)
ORIG:RoleId           Like(MP:RoleID)
SaveMatPartyAlias     Like(MP:Record),Pre(SAV:MP)
SAV:LOC:DefaultScreenID  LIKE(LOC:DefaultScreenID)

FDB5::View:FileDrop  VIEW(Role)
                       PROJECT(ROL:Description)
                       PROJECT(ROL:RoleScrnID)
                       PROJECT(ROL:RecordID)
                     END
Queue:FileDrop       QUEUE                            !Queue declaration for browse/combo box using ?LOC:Role
ROL:Description        LIKE(ROL:Description)          !List box control field - type derived from field
ROL:RoleScrnID         LIKE(ROL:RoleScrnID)           !Browse hot field - type derived from field
ROL:RecordID           LIKE(ROL:RecordID)             !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
FDB6::View:FileDrop  VIEW(LanguageAlias)
                       PROJECT(LAN1:Description)
                       PROJECT(LAN1:RecordID)
                     END
Queue:FileDrop:1     QUEUE                            !Queue declaration for browse/combo box using ?LOC:Language
LAN1:Description       LIKE(LAN1:Description)         !List box control field - type derived from field
LAN1:RecordID          LIKE(LAN1:RecordID)            !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
Window               WINDOW('Caption'),AT(,,469,259),FONT('Arial',9,,FONT:regular),CENTER,SYSTEM,GRAY,DOUBLE,MDI
                       SHEET,AT(4,7,460,214),USE(?Sheet1),HSCROLL
                         TAB('&Assignment'),USE(?AssignmentTab)
                           BUTTON('...'),AT(270,28,10,10),USE(?SelectParty),TIP('Change the Party')
                           PROMPT('Contact Person:'),AT(14,42),USE(?LOC:Contact:Prompt)
                           PROMPT('&Party'),AT(14,28),USE(?LOC:Name:Prompt)
                           ENTRY(@s99),AT(82,28,183,10),USE(LOC:Name),IMM,SKIP,FONT('MS Sans Serif',,,),COLOR(COLOR:BTNFACE),TIP('Name of party involved in this matter<13,10>MP:PartyID'),REQ,READONLY
                           PROMPT('&Role:'),AT(14,61),USE(?Prompt3)
                           LIST,AT(82,61,183,10),USE(LOC:Role),FONT('MS Sans Serif',,,),TIP('The Role this Party plays in this Matter<13,10>MP:RoleID'),FORMAT('196L(2)|M@s49@'),DROP(15),FROM(Queue:FileDrop)
                           BUTTON('...'),AT(270,61,10,10),USE(?SelectRole),SKIP,TIP('Lookup the role')
                           ENTRY(@s49),AT(82,44,183,10),USE(LOC:Contact),IMM,SKIP,FONT('MS Sans Serif',,,),COLOR(COLOR:BTNFACE),TIP('The Contact Person of the Party<13,10>Can be used to address letters to a specific pe' &|
   'rson within a large company<13,10>MP:ContactID'),READONLY
                           BUTTON('...'),AT(270,44,10,10),USE(?SelectContact),SKIP,TIP('Change the Contact Person')
                           STRING('(optional)'),AT(14,50),USE(?String3),FONT(,,,,CHARSET:ANSI)
                           PROMPT('R&eference:'),AT(14,77),USE(?MP:Reference:Prompt)
                           ENTRY(@s100),AT(82,77,95,10),USE(MP:Reference),IMM,FONT('MS Sans Serif',,,),TIP('The Party''s reference for this Matter<13,10>MP:Reference'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                           PROMPT('&Matter Description:'),AT(14,94),USE(?MP:MatterDescription:Prompt)
                           ENTRY(@s99),AT(82,94,199,10),USE(MP:MatterDescription),IMM,FONT('MS Sans Serif',,,),TIP('A description of the Matter (For this Party)<13,10>MP:MatterDescription'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                           PROMPT('&Language'),AT(14,112),USE(?MP:Language:Prompt)
                           LIST,AT(82,112,95,10),USE(LOC:Language),FONT('MS Sans Serif',,,),TIP('The Default Language of this Party for this Matter<13,10>MP:LanguageID'),FORMAT('76L(2)|M@s19@'),DROP(5),FROM(Queue:FileDrop:1)
                           PROMPT('Compliance Status:'),AT(14,128),USE(?MP:ComplianceStatus:Prompt),HIDE
                           LIST,AT(82,127,95,10),USE(MP:ComplianceStatus),HIDE,FONT('MS Sans Serif',,,),DROP(5),FROM('Standard|#0|Full CPA|#1|Limited CPA|#2|NCA|#3|Unspecified|#4')
                           PROMPT('Include In Life Assurance (Y/N):'),AT(190,112),USE(?MP:IncludeInLifeAssurance:Prompt),HIDE
                           LIST,AT(298,112,31,10),USE(MP:IncludeInLifeAssurance),HIDE,FONT('MS Sans Serif',,,),DROP(5),FROM('Yes|#Y|No|#N')
                           GROUP('Nomine Officio (Litigation Only)'),AT(12,144,269,60),USE(?NOGroup),BOXED,HIDE
                             CHECK('&Nomine Officio?'),AT(21,154),USE(MP:NOFlag),TIP('This Party is representing another legal entity or person, i.e they are not acti' &|
   'ng in their personal capacity<13,10>MP:NOFlag')
                             PROMPT('Capac&ity:'),AT(21,170),USE(?MP:NOCapacity:Prompt)
                             ENTRY(@s99),AT(76,170,199,10),USE(MP:NOCapacity),IMM,FONT('MS Sans Serif',,,),TIP('The capacity they are acting as (e.g. Trustee/ Curator)<13,10>MP:NOCapacity'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('&Principal:'),AT(21,186),USE(?MP:NOPrincipal:Prompt)
                             ENTRY(@s149),AT(76,186,199,10),USE(MP:NOPrincipal),IMM,FONT('MS Sans Serif',,,),TIP('The Principal they are acting on behalf of (e.g. The ABC Trust)<13,10>MP:NOPrincipal'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                           END
                           GROUP('Surety Details'),AT(12,142,285,70),USE(?SuretyGroup),BOXED,HIDE
                             PROMPT('&Amount:'),AT(72,155),USE(?MP:SuretyAmount:Prompt)
                             ENTRY(@N15.2B),AT(104,155,60,10),USE(MP:SuretyAmount),DECIMAL(12),FONT('MS Sans Serif',,,),TIP('The amount of the surety<13,10>MP:SuretyAmount')
                             CHECK('Unlimited?'),AT(20,155),USE(MP:SuretyUnlimitedFlag),TIP('The Surety is not limited to a specific amount<13,10>MP:SuretyUnlimitedFlag')
                             PROMPT('&Security:'),AT(20,171),USE(?MP:SuretySecurity:Prompt)
                             TEXT,AT(56,171,218,33),USE(MP:SuretySecurity),VSCROLL,FONT('MS Sans Serif',,,),TIP('A description of any security linked to this suretyship<13,10>MP:SuretySecurity')
                             BUTTON,AT(278,171,10,10),USE(?LookupLibraryButton),SKIP,TIP('Lookup and insert text from the Lookup Library (Ctrl L)'),KEY(CtrlL),ICON('Lookup.ico')
                           END
                         END
                         TAB('&Rates Clearance Cert'),USE(?RCCTab),HIDE
                           PROMPT('Surety Indicator:'),AT(324,28),USE(?MP:RateSurityIndicator:Prompt),HIDE
                           LIST,AT(396,28,49,11),USE(MP:RateSurityIndicator),HIDE,FONT('MS Sans Serif',,,),TIP('MP:RateSurityIndicator'),DROP(5),FROM('Yes|#Y|No|#N')
                           PROMPT('Primary Applicant:'),AT(13,24),USE(?MP:RatePrimaryApplicant:Prompt)
                           LIST,AT(84,24,49,11),USE(MP:RatePrimaryApplicant),FONT('MS Sans Serif',,,),TIP('MP:RatePrimaryApplicant'),DROP(5),FROM('Yes|#Y|No|#N')
                           PROMPT('Permanent Resident:'),AT(324,44),USE(?MP:RatePerminantResident:Prompt),HIDE
                           LIST,AT(396,44,49,11),USE(MP:RatePerminantResident),HIDE,FONT('MS Sans Serif',,,),TIP('MP:RatePerminantResident'),DROP(5),FROM('Yes|#Y|No|#N')
                           PROMPT('Estate Type:'),AT(13,72),USE(?MP:RateEstateType:Prompt)
                           LIST,AT(84,72,73,10),USE(MP:RateEstateType),FONT('MS Sans Serif',,,),TIP('Select the estate type if any for the RCC<13,10>MP:RateEstateType'),DROP(5),FROM('Not Applicable|#Not Applicable|Insolvent Estate|#Insolvent Estate|Deceased Estate|#Deceased Estate')
                           GROUP('Only Used for Hibiscus Coast and Ugu'),AT(16,88,435,128),USE(?Group7),BOXED
                             PROMPT('Employment Status:'),AT(24,104),USE(?MP:EmploymentStatus:Prompt)
                             LIST,AT(92,104,73,10),USE(MP:EmploymentStatus),FONT('MS Sans Serif',,,),DROP(5),FROM('Employed|#Employed|Unemployed|#Unemployed|Retired|#Retired')
                             PROMPT('Employer Name:'),AT(24,120),USE(?MP:EmployerName:Prompt)
                             ENTRY(@s50),AT(92,120,174,11),USE(MP:EmployerName),FONT('MS Sans Serif',,,)
                             PROMPT('Employer Address:'),AT(24,136),USE(?MP:EmployerAddress:Prompt)
                             ENTRY(@s200),AT(92,136,353,10),USE(MP:EmployerAddress),FONT('MS Sans Serif',,,)
                             PROMPT('Employer Tele:'),AT(24,152),USE(?MP:EmployerTele:Prompt)
                             ENTRY(@s30),AT(92,152,60,10),USE(MP:EmployerTele),FONT('MS Sans Serif',,,)
                             PROMPT('Relative Full Name:'),AT(24,168),USE(?MP:RelativeFullName:Prompt)
                             ENTRY(@s50),AT(92,168,174,11),USE(MP:RelativeFullName),FONT('MS Sans Serif',,,)
                             PROMPT('Relative Address:'),AT(24,184),USE(?MP:RelativeAddress:Prompt)
                             ENTRY(@s200),AT(92,184,353,10),USE(MP:RelativeAddress),FONT('MS Sans Serif',,,)
                             PROMPT('Relative Tele:'),AT(24,200),USE(?MP:RelativeTele:Prompt)
                             ENTRY(@s30),AT(92,200,60,10),USE(MP:RelativeTele),FONT('MS Sans Serif',,,)
                           END
                           PROMPT('Customer Role:'),AT(13,40),USE(?MP:RateCustomerRole:Prompt)
                           LIST,AT(84,40,174,11),USE(MP:RateCustomerRole),SCROLL,FONT('MS Sans Serif',,,),TIP('MP:RateCustomerRole'),DROP(20),FROM(RatesCustomerRoleQueue)
                           PROMPT('Portion Share %:'),AT(13,56),USE(?MP:RatePORTION_SHARE_P:Prompt)
                           ENTRY(@n-10.3),AT(84,56,73,10),USE(MP:RatePORTION_SHARE_P),RIGHT(1),FONT('MS Sans Serif',,,),TIP('MP:RatePORTION_SHARE_P')
                         END
                         TAB('A&dmin Orders'),USE(?AOTab1),HIDE
                           GROUP('Distribution'),AT(12,28,247,66),USE(?Group2),BOXED
                             PROMPT('Claim Amount:'),AT(20,44),USE(?MP:ClaimAmount:Prompt)
                             ENTRY(@n-15.2),AT(72,44,60,10),USE(MP:ClaimAmount),DECIMAL(12),FONT('MS Sans Serif',,,),TIP('MP:ClaimAmount')
                             PROMPT('Distribute'),AT(20,60),USE(?Prompt18)
                             OPTION,AT(72,60,84,10),USE(LOC:Option)
                               RADIO('Pro rata'),AT(72,60),USE(?Option2:Radio3),VALUE('0')
                               RADIO('Fixed %'),AT(116,60),USE(?Option2:Radio4),VALUE('1')
                             END
                             ENTRY(@n7.2~%~),AT(160,60,40,9),USE(MP:DistributionPercent),RIGHT(2),FONT('MS Sans Serif',,,),TIP('Percentage To Distribute To This Creditor<13,10>MP:DistributionPercent')
                             PROMPT('Maximum Recoverable:'),AT(20,76),USE(?MP:MaxClaimAmount:Prompt)
                             ENTRY(@n-15.2),AT(97,76,60,10),USE(MP:MaxClaimAmount),DECIMAL(12),FONT('MS Sans Serif',,,),TIP('The maximum that can be recovered<13,10>MP:MaxClaimAmount')
                           END
                           GROUP('Attorney'),AT(12,99,247,59),USE(?Group2:2),BOXED
                             BUTTON('...'),AT(238,115,10,10),USE(?SelectAttorney)
                             PROMPT('Name'),AT(20,115),USE(?Prompt19)
                             ENTRY(@s99),AT(44,115,187,10),USE(LOC:Attorney),IMM,SKIP,FONT('MS Sans Serif',,,),COLOR(COLOR:BTNFACE),READONLY
                             STRING('If an attorney collects money on behalf of a creditor, enter the Attorney''s'),AT(20,131),USE(?String1)
                             STRING('name here. Cheques will then be made payable to the attorney'),AT(20,142),USE(?String1:2)
                           END
                         END
                         TAB('Ad&min Orders Contd.'),USE(?AOTab2),HIDE
                           GROUP,AT(12,20,265,128),USE(?Group1),BOXED
                             PROMPT('Nature of Claim'),AT(17,32),USE(?MP:ClaimDescription:Prompt)
                             ENTRY(@s254),AT(94,32,143,10),USE(MP:ClaimDescription),IMM,FONT('MS Sans Serif',,,),TIP('Nature Of Claim<13,10>MP:ClaimDescription'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                             PROMPT('Instalment Amount:'),AT(17,48),USE(?MP:InstalmentAmount:Prompt)
                             ENTRY(@n-15.2),AT(94,48,60,10),USE(MP:InstalmentAmount),DECIMAL(12),FONT('MS Sans Serif',,,),TIP('MP:InstalmentAmount')
                             LIST,AT(175,48,61,11),USE(MP:InstalmentFrequency),FONT('MS Sans Serif',,,),TIP('The frequency the client paid this creditor<13,10>MP:InstalmentFrequency'),DROP(10),FROM('Weekly|#W|Monthly|#M')
                             PROMPT('Payable From:'),AT(17,64),USE(?MP:PayableFrom:Prompt)
                             ENTRY(@d17),AT(94,64,60,10),USE(MP:PayableFrom),RIGHT(1),FONT('MS Sans Serif',,,),TIP('MP:PayableFrom')
                             PROMPT('To:'),AT(159,64),USE(?MP:PayableTo:Prompt)
                             ENTRY(@d17),AT(175,64,60,10),USE(MP:PayableTo),RIGHT(1),FONT('MS Sans Serif',,,),TIP('MP:PayableTo')
                           END
                           PROMPT('District:'),AT(17,80),USE(?MP:District:Prompt)
                           ENTRY(@s49),AT(94,80,80,10),USE(MP:District),IMM,FONT('MS Sans Serif',,,),TIP('Court District<13,10>MP:District'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                           PROMPT('Case No:'),AT(17,96),USE(?MP:CaseNo:Prompt)
                           ENTRY(@s19),AT(94,96,80,10),USE(MP:CaseNo),IMM,FONT('MS Sans Serif',,,),TIP('MP:CaseNo'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                           PROMPT('Court Order Details'),AT(17,112),USE(?Prompt17)
                           TEXT,AT(94,112,176,28),USE(MP:CourtOrderDetails),FONT('MS Sans Serif',,,),TIP('MP:CourtOrderDetails')
                           GROUP,AT(12,148,265,24),USE(?Group5),BOXED
                             PROMPT('Paid Out Brought Forward:'),AT(17,158),USE(?MP:District:Prompt:2)
                             ENTRY(@n-15.2),AT(108,158,60,10),USE(MP:PaidOutBFwd),IMM,FONT('MS Sans Serif',,,),TIP('Record the payments to this creditor that were made<13,10>prior to taking on this cre' &|
   'ditor<13,10>MP:PaidOutBFwd'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlUp),ALRT(CtrlDown)
                           END
                         END
                         TAB('Estate Agent'),USE(?EstateAgentTab),HIDE
                           PROMPT('Purchase Price:'),AT(19,33),USE(?BON:SalePrice:Prompt)
                           ENTRY(@n-15.2),AT(79,33,60,10),USE(BON:SalePrice),SKIP,DECIMAL(12),FONT('MS Sans Serif',,,),COLOR(COLOR:Silver),READONLY
                           PROMPT('Commission @'),AT(163,33),USE(?MP:CommissionPercent:Prompt)
                           ENTRY(@n-10.3),AT(212,33,35,10),USE(MP:CommissionPercent),DECIMAL(16),FONT('MS Sans Serif',,,),TIP('Commission Percentage')
                           STRING('% = R'),AT(252,33),USE(?String4)
                           ENTRY(@n-15.2),AT(276,33,60,10),USE(MP:CommissionAmount),DECIMAL(12),FONT('MS Sans Serif',,,),TIP('Commission Amount')
                           LIST,AT(340,33,69,10),USE(MP:CommissionExcludesVATFlag),FONT('MS Sans Serif',,,),TIP('Commission Excludes VAT'),DROP(5),FROM('Vat Inclusive|#0|Vat Exclusive|#1|No Vat|#2')
                         END
                       END
                       BUTTON('&OK'),AT(335,233,60,20),USE(?OK),LEFT,FONT(,11,,),ICON('check3.ico'),DEFAULT,REQ
                       BUTTON('&Cancel'),AT(403,233,60,20),USE(?Cancel),LEFT,FONT(,11,,),TIP('Cancel this screen'),ICON('delete32.ico')
                       BUTTON('Add a &screen'),AT(8,228,79,24),USE(?AddButton),SKIP,LEFT,TIP('Add an Extra Screen'),ICON('note.gif')
                       BUTTON('&Modify this screen'),AT(96,228,79,24),USE(?ModifyButton),SKIP,HIDE,LEFT,TIP('Change the format and layout of the fields for this screen'),ICON('defaults.ico')
                       BUTTON('&Remove this screen'),AT(184,228,79,24),USE(?DeleteButton),SKIP,HIDE,LEFT,TIP('Remove this Extra Screen (and its data) from this Party<13,10>Note: The Extra Screen ' &|
   'itself will NOT be deleted.'),ICON('docdel.ico')
                     END

PDSC:MP:PayableFrom  CLASS(PDScrollCT)
TakeFieldEvent         PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDSC:MP:PayableTo    CLASS(PDScrollCT)
TakeFieldEvent         PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDPC:MP:PayableFrom  CLASS(PDPopCalBtnCT)
TakeAccepted           PROCEDURE,BYTE,PROC,VIRTUAL
                     END
PDPC:MP:PayableTo    CLASS(PDPopCalBtnCT)
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
                     END

Toolbar              ToolbarClass
ToolbarForm          ToolbarUpdateClass               !Form Toolbar Manager
FDB5                 CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop                !Reference to display queue
ApplyFilter            PROCEDURE(),DERIVED
                     END

FDB6                 CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:1              !Reference to display queue
                     END

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

SetContactRelationshipID    ROUTINE

  IF MP:PartyID AND MP:ContactID
     CLEAR(RES:Record)
     ResultSet{PROP:SQL} = 'Select RelationShipID From ParRel WHERE PartyID = ' & MP:PartyID & ' AND OtherPartyID = ' & MP:ContactID
     NEXT(ResultSet)
     MP:PartyRelationshipID = RES:RecordId

     CLEAR(RES:Record)
     ResultSet{PROP:SQL} = 'Select RelationShipID From ParRel WHERE PartyID = ' & MP:ContactID & ' AND OtherPartyID = ' & MP:PartyID
     NEXT(ResultSet)
     MP:ContactRelationshipID = RES:RecordId

  END


GetThePartyFromTheAddressBook   ROUTINE

     ! 26/9/2010 - MOVED THIS TO ThisWindow.Open HOPING TO AVOID GPF'S AND THE BLANK RECORDS

     GlobalRequest = SelectRecord

     BrowseParty
  
  
     ! 16/3/2010 CAN'T WORK THIS OUT - CREATES A BLANK RECORD IF ABORTING - MUST BE THE AUTO-INCREMENT

     MP:PartyId = PAR:RecordId                    ! AT LEAST NOW WE WONT HAVE A BLANK RECORD - THEY MUST JUST CANCEL ON THE FORM IF THEY WANT TO ABORT THE INSERT

     LOC:Name = GetDescription('PARTY NAME',MP:PartyId)

       IF ~MP:ContactID
           MP:ContactID = GetDefaultContact(MP:PartyID)
           LOC:Contact = GetDescription('PARTY NAME',MP:ContactID)
           DO SetContactRelationshipID
       END

       IF PAR:DefaultRoleID AND PAR:DefaultRoleID <> CTL:ClientRoleID
          MP:RoleID = PAR:DefaultRoleID

       ELSE  ! TRY AND GET THE MOST LOGICAL ROLE - SPEEDS UP DATA CAPTURE

         PROPSQLNext('SELECT 0,Type FROM DocGen WHERE RecordID = ' & MAT:DocGenID)
         CASE ROW:Description
              OF 'BON'
                 MP:RoleID = CTL:MortgagorRoleID
              OF 'TRN' OROF 'STR' OROF 'DEV'
                 MP:RoleID = CTL:BuyerRoleID
              OF 'LIT'
                 MP:RoleID = CTL:DefendantRoleID

         END
       END

       DO DisplayLanguage

DisplayLanguage ROUTINE

      DEBUG('1. PAR:DefaultLanguageID = ' & PAR:DefaultLanguageID)
      IF MP:LanguageID = PAR:DefaultLanguageID THEN EXIT.
      MP:LanguageID = PAR:DefaultLanguageID

      CLEAR(LAN:Record)
      LAN:RecordID = MP:LanguageID
      IF ~Access:Language.TryFetch(LAN:PrimaryKey)
          LOC:Language = LAN:Description
          DISPLAY(?LOC:Language)
      END


GetNewSorter    ROUTINE

       CLEAR(ROW:Record)
       RowCounter{PROP:SQL} = 'Select Max(Sorter) From MatParty where MatterID = ' & MP:MatterId & ' AND RoleID = ' & MP:RoleId
       Next(RowCounter)
       If Errorcode()
          Message('Error Getting Next Matter Party Number|Error: ' & Error() & ' ' & FileError() ,'Update Matter Party',ICON:Exclamation)
       ELSE
          MP:Sorter = ROW:Counter + 1
       END

RoleChanged     ROUTINE

!     IF FOCUS() = ?LOC:Role AND KEYCODE() >= 65 AND KEYCODE() <= 90
!        MESSAGE('Exiting because USER IS PRESSING KEYS TO JUMP TO THE ROLES IN THE DROPDOWN AND THIS IS CAUSING AN ACCEPT LOOP TO FIRE WHICH CAUSES AN EXTRA SCREEN TO BE ADDED')
!        EXIT
!     END

     IF ~(SAV:RoleId = MP:RoleID)

         SAV:RoleId = MP:RoleID


         IF MP:RoleID = CTL:DefendantRoleID OR MP:RoleID = CTL:PlaintiffRoleID
            ?NOGroup{PROP:Hide} = False
         ELSE
            ?NOGroup{PROP:Hide} = True
            MP:NOFlag = 0
         END

         IF MP:RoleID = CTL:SuretyRoleID
            ?SuretyGroup{PROP:Hide} = False
         ELSE
            ?SuretyGroup{PROP:Hide} = True
         END

  
         IF SAV:RoleID = CTL:BuyerRoleID OR SAV:RoleID = CTL:SellerRoleID OR SAV:RoleID = CTL:DeveloperRoleID
           ?RCCTab{PROP:Hide} = False

           If ~MP:RatePrimaryApplicant Then MP:RatePrimaryApplicant = 'Y'.
           If ~MP:RateSurityIndicator Then MP:RateSurityIndicator = 'Y'.
           If ~MP:RatePerminantResident Then MP:RatePerminantResident = 'Y'.
       
           If ~MP:RateCustomerRole
             If PAR:EntityID = 1 Then MP:RateCustomerRole = 'PRIVATE INDIVIDUAL'.
             If PAR:EntityID = 5 Then MP:RateCustomerRole = 'CLOSE CORPORATION'.
             If Inlist(PAR:EntityID,6,7) Then MP:RateCustomerRole = 'COMPANY'.
             If PAR:EntityID = 4 Then MP:RateCustomerRole = 'PARTNERSHIP'.
             If PAR:EntityID = 9 Then MP:RateCustomerRole = 'TRUST'.
             If PAR:PartyTypeID = 24 Then MP:RateCustomerRole = 'CHURCH'.
             If PAR:PartyTypeID = 17 Then MP:RateCustomerRole = 'DECEASED ESTATE'.
             If PAR:PartyTypeID = 18 Then MP:RateCustomerRole = 'INSOLVENT ESTATE'.
             If PAR:PartyTypeID = 43 Then MP:RateCustomerRole = 'NON-PROFIT ORGANISATION'.
             If PAR:EntityID = 11 And PAR:PartyTypeID = 20 Then MP:RateCustomerRole = 'LOCAL COUNCIL'.
           End
           If ~MP:RateEstateType
             If PAR:EntityID = 10
               If PAR:PartyTypeID = 17 Then MP:RateEstateType = 'Deceased Estate'.
               If PAR:PartyTypeID = 18 Then MP:RateEstateType = 'Insolvent Estate'.
             Else
               MP:RateEstateType = 'Not Applicable'
             End
           End
         ELSE
           ?RCCTab{PROP:Hide} = True
         END
   END


   DO DisplayAdminTabs


   IF ~(SAV:LOC:DefaultScreenID = LOC:DefaultScreenID)

       IF SAV:LOC:DefaultScreenID

           RowCounter{PROP:SQL} = 'Delete ParRolSc WHERE RoleScreenID = ' & SAV:LOC:DefaultScreenID & ' AND MatPartyID = ' & MP:RecordID

           SORT(ScreenQueue,+SCRQ:DocScrnID)
           If ErrorCode() Then Message('ERROR: ' & ErrorCode() & ' ' & Error()).
           SCRQ:DocScrnID = SAV:LOC:DefaultScreenID
           GET(ScreenQueue,SCRQ:DocScrnID)
           IF ~ERROR()

              DO DeleteScreen

              DESTROY(SCRQ:TabEquate)

              DELETE(ScreenQueue)   ! REMOVE IT FROM THE SCREEN QUEUE

              DO HideUnHideButtons

!      IF RECORDS(ScreenQueue)
!      ?ModifyButton{PROP:Disable} = False
!      ?DeleteButton{PROP:Disable} = False
!      ELSE
!      ?ModifyButton{PROP:Disable} = True
!      ?DeleteButton{PROP:Disable} = True
!      END


           END

       END


       SAV:LOC:DefaultScreenID = LOC:DefaultScreenID

       DO DisplayExtraScreens

       SELECT(?LOC:Role)

   END

DisplayAdminTabs    ROUTINE

  ! Display Admin Order Tabs
  If MP:RoleID = CTL:CreditorAdminRoleID
    ?AOTab1{PROP:Hide} = False
    ?AOTab2{PROP:Hide} = False
    If Event() = EVENT:Accepted
      If LOC:Option
        ?MP:DistributionPercent{PROP:ReadOnly} = False
        ?MP:DistributionPercent{PROP:Skip} = False
        ?MP:DistributionPercent{PROP:Background} = COLOR:None
      Else
        ?MP:DistributionPercent{PROP:ReadOnly} = True
        ?MP:DistributionPercent{PROP:Skip} = True
        ?MP:DistributionPercent{PROP:Background} = COLOR:BtnFace
      .
   .
  Else
    ?AOTab1{PROP:Hide} = True
    ?AOTab2{PROP:Hide} = True
  .



AddAutomaticScreens     ROUTINE

  ! ADD ANY AUTOMATIC EXTRA SCREENS

DeleteScreen    ROUTINE

    PROPSQL('Delete ParRolSc WHERE RoleScreenID = ' & SCRQ:DocScrnID & ' AND MatPartyID = ' & MP:RecordID)
    !setclipboard(RowCounter{PROP:SQL})


BuildScreenQueue ROUTINE


  IF ~MP:RecordID then exit.
  CLEAR(REXTS:Record)
  REXTS:RoleID = MP:RoleID
  REXTS:Sorter = 1
  SET(REXTS:RoleSorterKey,REXTS:RoleSorterKey)
  LOOP UNTIL Access:RoleExtraScreens.Next()
       IF ~(REXTS:RoleID = MP:RoleID) THEN BREAK.
       CLEAR(DS:Record)
       DS:RecordID = REXTS:ExtraScreenID
      IF ~Access:DocScrn.Fetch(DS:PrimaryKey)
         IF DS:ScreenType <> 'R' THEN CYCLE.    ! ONLY LOOK AT ROLE SCREENS
         IF DS:TrueCondition AND EVALUATE(DS:TrueCondition) = '0'
               CYCLE
         END
         IF DS:RemoveCondition AND ~(EVALUATE(DS:TrueCondition) = '0')
               CYCLE
         END
          CLEAR(PRS:Record)
          PRS:MatPartyID = MP:RecordID
          PRS:RoleScreenID = REXTS:ExtraScreenID
          IF Access:ParRolSc.TryFetch(PRS:PrimaryKey)
             PRS:MatPartyID = MP:RecordID
             PRS:RoleScreenID = REXTS:ExtraScreenID
             Access:ParRolSc.Insert()
          END
      END
  END
  LOC:DefaultScreenID = 0
  IF ROL:RoleScrnID THEN LOC:DefaultScreenID = ROL:RoleScrnID ELSE LOC:DefaultScreenID = 0.

  CLEAR(PRS:Record)
  PRS:MatPartyID = MP:RecordID
  SET(PRS:PrimaryKey,PRS:PrimaryKey)
  LOOP UNTIL Access:ParRolSc.Next()
       IF ~(PRS:MatPartyID = MP:RecordID) THEN BREAK.
       LOC:ScreenCounter += 1
       CLEAR(DS:Record)
       DS:RecordID = PRS:RoleScreenID
       IF Access:DocScrn.Fetch(DS:PrimaryKey) THEN CYCLE.
       IF DS:ScreenType <> 'R' THEN CYCLE.
       IF DS:RemoveCondition AND ~(EVALUATE(DS:TrueCondition) = '0')
               CYCLE
       END
       SCRQ:DocScrnID = DS:RecordID
       SCRQ:ScreenTitle = ReplaceTextBoxFields(DS:ScreenTitle,MP:LanguageID,MP:PartyID,MP:MatterID,MP:RoleID)
                                                !TheString,TheLanguageID,<TheCurrentPartyID>,<TheCurrentMatterID>,<TheCurrentRoleID>)
       ADD(ScreenQueue,+SCRQ:ScreenTitle)   ! DOING THIS TO SORT THE TABS ALPHABETICALLY
       IF LOC:DefaultScreenID = DS:RecordID 
          LOC:DisplayThisScreenID  = DS:RecordID
       END
  END


  IF LOC:DefaultScreenID AND ~LOC:DisplayThisScreenID  ! IF THE DEFAULT SCREEN IS NOT ALREADY LINKED TO THIS MATTER
      CLEAR(DS:Record)
      DS:RecordID = LOC:DefaultScreenID
      IF ~Access:DocScrn.Fetch(DS:PrimaryKey)
          IF DS:ScreenType = 'R' AND (~DS:TrueCondition OR ~(EVALUATE(DS:TrueCondition) = '0')) AND (~DS:RemoveCondition OR (EVALUATE(DS:TrueCondition) = '0'))
              CLEAR(PRS:Record)
              PRS:MatPartyID = MP:RecordID
              PRS:RoleScreenID = LOC:DefaultScreenID
              IF Access:ParRolSc.TryFetch(PRS:PrimaryKey)
                 PRS:MatPartyID = MP:RecordID
                 PRS:RoleScreenID = LOC:DefaultScreenID
                 IF ~Access:ParRolSc.Insert()
                     LOC:DisplayThisScreenID  = LOC:DefaultScreenID
                 END
              ELSE
                 LOC:DisplayThisScreenID  = LOC:DefaultScreenID
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

 ! If need be, talk to Rick about this, as it doesn't return from this until you click ok
 INCLUDE('UpdateMatterExtraScreenSource','Routines')



UpdateDataRecord     ROUTINE

       ThisWindow.Update

       DO SetDSFVariables

  !message('CHOICE(?Sheet1) = ' & CHOICE(?Sheet1) & '|LOC:ScreenField[CHOICE(?Sheet1),LOC:Field1] = ' & LOC:ScreenField[CHOICE(?Sheet1),LOC:Field1])

       PRS:Field1 = LOC:ScreenField[SCRQ:RecordID,LOC:Field1]
       PRS:Field2 = LOC:ScreenField[SCRQ:RecordID,LOC:Field2]
       PRS:Field3 = LOC:ScreenField[SCRQ:RecordID,LOC:Field3]
       PRS:Field4 = LOC:ScreenField[SCRQ:RecordID,LOC:Field4]
       PRS:Field5 = LOC:ScreenField[SCRQ:RecordID,LOC:Field5]
       PRS:Field6 = LOC:ScreenField[SCRQ:RecordID,LOC:Field6]
       PRS:Field7 = LOC:ScreenField[SCRQ:RecordID,LOC:Field7]
       PRS:Field8 = LOC:ScreenField[SCRQ:RecordID,LOC:Field8]
       PRS:Field9 = LOC:ScreenField[SCRQ:RecordID,LOC:Field9]
       PRS:Field10 = LOC:ScreenField[SCRQ:RecordID,LOC:Field10]
       PRS:Field11 = LOC:ScreenField[SCRQ:RecordID,LOC:Field11]
       PRS:Field12 = LOC:ScreenField[SCRQ:RecordID,LOC:Field12]
       PRS:Field13 = LOC:ScreenField[SCRQ:RecordID,LOC:Field13]
       PRS:Field14 = LOC:ScreenField[SCRQ:RecordID,LOC:Field14]
       PRS:Field15 = LOC:ScreenField[SCRQ:RecordID,LOC:Field15]
       PRS:Field16 = LOC:ScreenField[SCRQ:RecordID,LOC:Field16]
       PRS:Field17 = LOC:ScreenField[SCRQ:RecordID,LOC:Field17]
       PRS:Field18 = LOC:ScreenField[SCRQ:RecordID,LOC:Field18]
       PRS:Field19 = LOC:ScreenField[SCRQ:RecordID,LOC:Field19]
       PRS:Field20 = LOC:ScreenField[SCRQ:RecordID,LOC:Field20]
       PRS:Field21 = LOC:ScreenField[SCRQ:RecordID,LOC:Field21]
       PRS:Field22 = LOC:ScreenField[SCRQ:RecordID,LOC:Field22]
       PRS:Field23 = LOC:ScreenField[SCRQ:RecordID,LOC:Field23]
       PRS:Field24 = LOC:ScreenField[SCRQ:RecordID,LOC:Field24]
       PRS:Field25 = LOC:ScreenField[SCRQ:RecordID,LOC:Field25]
       PRS:Field26 = LOC:ScreenField[SCRQ:RecordID,LOC:Field26]
       PRS:Field27 = LOC:ScreenField[SCRQ:RecordID,LOC:Field27]
       PRS:Field28 = LOC:ScreenField[SCRQ:RecordID,LOC:Field28]
       PRS:Field29 = LOC:ScreenField[SCRQ:RecordID,LOC:Field29]
       PRS:Field30 = LOC:ScreenField[SCRQ:RecordID,LOC:Field30]




UpdateScreenFields     ROUTINE


       CLEAR(PRS:Record)
       PRS:RoleScreenID = SCRQ:DocScrnID
       PRS:MatPartyID = MP:RecordID
       IF Access:ParRolSc.Fetch(PRS:PrimaryKey) THEN EXIT.



       LOC:ScreenField[SCRQ:RecordID,LOC:Field1] = PRS:Field1
       LOC:ScreenField[SCRQ:RecordID,LOC:Field2] = PRS:Field2
       LOC:ScreenField[SCRQ:RecordID,LOC:Field3] = PRS:Field3
       LOC:ScreenField[SCRQ:RecordID,LOC:Field4] = PRS:Field4
       LOC:ScreenField[SCRQ:RecordID,LOC:Field5] = PRS:Field5
       LOC:ScreenField[SCRQ:RecordID,LOC:Field6] = PRS:Field6
       LOC:ScreenField[SCRQ:RecordID,LOC:Field7] = PRS:Field7
       LOC:ScreenField[SCRQ:RecordID,LOC:Field8] = PRS:Field8
       LOC:ScreenField[SCRQ:RecordID,LOC:Field9] = PRS:Field9
       LOC:ScreenField[SCRQ:RecordID,LOC:Field10] = PRS:Field10
       LOC:ScreenField[SCRQ:RecordID,LOC:Field11] = PRS:Field11
       LOC:ScreenField[SCRQ:RecordID,LOC:Field12] = PRS:Field12
       LOC:ScreenField[SCRQ:RecordID,LOC:Field13] = PRS:Field13
       LOC:ScreenField[SCRQ:RecordID,LOC:Field14] = PRS:Field14
       LOC:ScreenField[SCRQ:RecordID,LOC:Field15] = PRS:Field15
       LOC:ScreenField[SCRQ:RecordID,LOC:Field16] = PRS:Field16
       LOC:ScreenField[SCRQ:RecordID,LOC:Field17] = PRS:Field17
       LOC:ScreenField[SCRQ:RecordID,LOC:Field18] = PRS:Field18
       LOC:ScreenField[SCRQ:RecordID,LOC:Field19] = PRS:Field19
       LOC:ScreenField[SCRQ:RecordID,LOC:Field20] = PRS:Field20
       LOC:ScreenField[SCRQ:RecordID,LOC:Field21] = PRS:Field21
       LOC:ScreenField[SCRQ:RecordID,LOC:Field22] = PRS:Field22
       LOC:ScreenField[SCRQ:RecordID,LOC:Field23] = PRS:Field23
       LOC:ScreenField[SCRQ:RecordID,LOC:Field24] = PRS:Field24
       LOC:ScreenField[SCRQ:RecordID,LOC:Field25] = PRS:Field25
       LOC:ScreenField[SCRQ:RecordID,LOC:Field26] = PRS:Field26
       LOC:ScreenField[SCRQ:RecordID,LOC:Field27] = PRS:Field27
       LOC:ScreenField[SCRQ:RecordID,LOC:Field28] = PRS:Field28
       LOC:ScreenField[SCRQ:RecordID,LOC:Field29] = PRS:Field29
       LOC:ScreenField[SCRQ:RecordID,LOC:Field30] = PRS:Field30

       DO CheckDefaults

EstateCommissionChange        Routine

  IF SAV:MP:CommissionPercent <> MP:CommissionPercent
    IF MP:CommissionPercent AND BON:SalePrice
      MP:CommissionAmount = BON:SalePrice * MP:CommissionPercent /100
      SAV:MP:CommissionAmount = MP:CommissionAmount
    END
  End
  IF SAV:MP:CommissionAmount <> MP:CommissionAmount OR SAV:MP:CommissionExcludesVATFlag <> MP:CommissionExcludesVATFlag
    If MP:CommissionAmount
       MP:CommissionPercent = ROUND(MP:CommissionAmount / BON:SalePrice * 100,.01)
       SAV:MP:CommissionPercent = MP:CommissionPercent
    End
  End
  Display

ThisWindow.Ask PROCEDURE

  CODE
  
  CASE SELF.Request
  OF ViewRecord
    ActionMessage = 'View Record'
  OF InsertRecord
    ActionMessage = 'Record will be Added'
  OF ChangeRecord
    ActionMessage = 'Record will be Changed'
  END
  CASE SELF.Request
  OF InsertRecord
    ActionMessage = 'Party will be Assigned'
  OF ChangeRecord
    ActionMessage = 'Party''s role will be Changed'
  END
  Window{Prop:Text} = ActionMessage
  IF MP:RecordID THEN 0{PROP:Text} = 0{PROP:Text} & ' (' & MP:RecordID & ')'.
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('UpdateMatParty')
  SELF.Request = GlobalRequest
  If GlobalRequest = DeleteRecord and MP:RoleID = CTL:ClientRoleID AND MP:Sorter = 1
    Message('You cannot delete the Client.||Every Matter must have a Client associated with it.|','Action Denied',ICON:Exclamation)
    Return Level:Notify
  .
  
  
  ReturnValue = PARENT.Init()
  
  
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?SelectParty
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors
  IF MP:RoleID = CTL:ClientRoleID
     SELF.FirstField = ?MP:Reference
  ELSE
     SELF.FirstField = ?LOC:Role
  END
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)
  CLEAR(GlobalResponse)
  SELF.AddUpdateFile(Access:MatParty)
  SELF.AddItem(?Cancel,RequestCancelled)
  Relate:BondData.Open
  Relate:Control.Open
  Relate:ConveyData.Open
  Relate:DocScrn.Open
  Relate:DocScrnField.Open
  Relate:LanguageAlias.Open
  Relate:MatParty.Open
  Relate:ParRolSc.Open
  Relate:Role.Open
  Relate:RoleExtraScreens.Open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:MatParty
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
  IF MP:PartyID
     CLEAR(PAR:Record)
     PAR:RecordID = MP:PartyID
     Access:Party.TryFetch(PAR:PrimaryKey)
  END

  IF MP:PartyID
     LOC:Name = GetDescription('Party Name',MP:PartyID)
  END

  IF MP:ContactID
     LOC:Contact = GetDescription('Party Name',MP:ContactID)
  END

  IF MP:AttorneyID
     LOC:Attorney = GetDescription('Party Name',MP:AttorneyID)
  END

  ORIG:RoleId = MP:RoleId
  If MP:DistributionPercent Then LOC:Option = 1.

  IF ~MP:LanguageID
    CLEAR(LAN:Record)
    DEBUG('PAR:DefaultLanguageID = ' & PAR:DefaultLanguageID)
    MP:LanguageID = PAR:DefaultLanguageID
    LAN:RecordID = MP:LanguageID
    IF ~Access:Language.TryFetch(LAN:PrimaryKey)
        LOC:Language = LAN:Description
    END
  END

  OPEN(Window)
  SELF.Opened=True
  IF SELF.Request = InsertRecord
    0{PROP:Hide} = 1
  END

  LOOP X# = 1 TO ?OK
       IF X#{PROP:Tooltip} AND X#{PROP:Msg} THEN X#{PROP:Tooltip} = X#{PROP:Tooltip} & ' [' & X#{PROP:Msg} & ']'.
  END

  If MP:RoleID = CTL:BuyerRoleID OR MP:RoleID = CTL:SellerRoleID OR MP:RoleID = CTL:DeveloperRoleID
    ?RCCTab{PROP:Hide} = False

    If ~MP:RatePrimaryApplicant Then MP:RatePrimaryApplicant = 'Y'.
    If ~MP:RateSurityIndicator Then MP:RateSurityIndicator = 'Y'.
    If ~MP:RatePerminantResident Then MP:RatePerminantResident = 'Y'.

    If ~MP:RateCustomerRole
      If PAR:EntityID = 1 Then MP:RateCustomerRole = 'PRIVATE INDIVIDUAL'.
      If PAR:EntityID = 5 Then MP:RateCustomerRole = 'CLOSE CORPORATION'.
      If Inlist(PAR:EntityID,6,7) Then MP:RateCustomerRole = 'COMPANY'.
      If PAR:EntityID = 4 Then MP:RateCustomerRole = 'PARTNERSHIP'.
      If PAR:EntityID = 9 Then MP:RateCustomerRole = 'TRUST'.
      If PAR:PartyTypeID = 24 Then MP:RateCustomerRole = 'CHURCH'.
      If PAR:PartyTypeID = 17 Then MP:RateCustomerRole = 'DECEASED ESTATE'.
      If PAR:PartyTypeID = 18 Then MP:RateCustomerRole = 'INSOLVENT ESTATE'.
      If PAR:PartyTypeID = 43 Then MP:RateCustomerRole = 'NON-PROFIT ORGANISATION'.
      If PAR:EntityID = 11 And PAR:PartyTypeID = 20 Then MP:RateCustomerRole = 'LOCAL COUNCIL'.
    End
    If ~MP:RateEstateType
      If PAR:EntityID = 10
        If PAR:PartyTypeID = 17 Then MP:RateEstateType = 'Deceased Estate'.
        If PAR:PartyTypeID = 18 Then MP:RateEstateType = 'Insolvent Estate'.
      Else
        MP:RateEstateType = 'Not Applicable'
      End
    End
  Else
    ?RCCTab{PROP:Hide} = True
  End

  PropSQLNext('Select RecordId,Code From DocGen Where RecordId = ' & MAT:DocGenId)
  Case ROW:Description
  Of 'FNBH'
    ?MP:IncludeInLifeAssurance:Prompt{PROP:Hide} = False
    ?MP:IncludeInLifeAssurance{PROP:Hide} = False
  Of 'ABC'
    ?MP:ComplianceStatus:Prompt{PROP:Hide} = False
    ?MP:ComplianceStatus{PROP:Hide} = False
  End

  RCRQ:Description = 'COMPANY'
  ADD(RatesCustomerRoleQueue,+RCRQ:Description)
  RCRQ:Description = 'CLOSE CORPORATION'
  ADD(RatesCustomerRoleQueue,+RCRQ:Description)
  RCRQ:Description = 'PRIVATE INDIVIDUAL'
  ADD(RatesCustomerRoleQueue,+RCRQ:Description)
  RCRQ:Description = 'JOINT ACCOUNT'
  ADD(RatesCustomerRoleQueue,+RCRQ:Description)
  RCRQ:Description = 'TRUST'
  ADD(RatesCustomerRoleQueue,+RCRQ:Description)
  RCRQ:Description = 'PARTNERSHIP'
  ADD(RatesCustomerRoleQueue,+RCRQ:Description)
  RCRQ:Description = 'DECEASED ESTATE'
  ADD(RatesCustomerRoleQueue,+RCRQ:Description)
  RCRQ:Description = 'INSOLVENT ESTATE'
  ADD(RatesCustomerRoleQueue,+RCRQ:Description)
  RCRQ:Description = 'NON-PROFIT ORGANISATION'
  ADD(RatesCustomerRoleQueue,+RCRQ:Description)
  RCRQ:Description = 'LOCAL COUNCIL'
  ADD(RatesCustomerRoleQueue,+RCRQ:Description)
  RCRQ:Description = 'CHURCH'
  ADD(RatesCustomerRoleQueue,+RCRQ:Description)

  RCRQ:Description = MP:RateCustomerRole
  GET(RatesCustomerRoleQueue,RCRQ:Description)
  IF ~ERROR() THEN ?MP:RateCustomerRole{PROP:Selected} = POSITION(RatesCustomerRoleQueue).


!  Clear(ROW:Record)
!  RowCounter{PROP:SQL} = 'Select RecordId FROM LAW_Mattr WHERE Matterid = ' & MP:MatterID
!  Next(RowCounter)
!  If ROW:Counter
!    ?MP:Notification_Method_X:Prompt{PROP:Hide} = False
!    ?MP:Notification_Method_X{PROP:Hide} = False
!  End

  IF ~MP:MatterDescription Then MP:MatterDescription = MAT:Description.

  IF Inlist(MP:RoleID,CTL:SellingAgencyRoleID,CTL:ListingAgencyRoleID,CTL:EstateAgentRoleID,CTL:ListingAgentRoleID)
    If MP:Sorter = 1
      IF BON:MatterID <> MP:MatterId
        BON:MatterID = MP:MatterId !Was NOT set before 24 Nov 2020
        IF Access:BondData.TryFetch(BON:PrimaryKey)
          Message('Error Reading BondData with MP:MatterId:' & MP:MatterId & '|BON:MatterID:'&BON:MatterID&'|Error: ' & Error(),'Error Should not occur',ICON:Exclamation)
        End
      End
      IF CONV:MatterID <> MP:MatterId
        CONV:MatterID = MP:MatterId !Was NOT set before 24 Nov 2020
        IF Access:ConveyData.TryFetch(CONV:PrimaryKey)
          Message('Error Reading ConveyData with MP:MatterId:' & MP:MatterId & '|Error: ' & Error(),'Error Should not occur',ICON:Exclamation)
        End
      End
      DEBUG('MP:RoleID = ' & MP:RoleID)
      Case MP:RoleID
      Of CTL:SellingAgencyRoleID
        DEBUG('CTL:SellingAgencyRoleID = ' & CTL:SellingAgencyRoleID)
        MP:CommissionPercent = BON:CommissionPercent
        MP:CommissionAmount  = BON:CommissionAmount
        MP:CommissionExcludesVATFlag = CONV:CommissionExcludesVATFlag
      Of CTL:ListingAgencyRoleID
        DEBUG('CTL:ListingAgencyRoleID = ' & CTL:ListingAgencyRoleID)
        MP:CommissionPercent = CONV:ListingAgentCommissionPercent
        MP:CommissionAmount  = CONV:ListingAgentCommissionAmount
        MP:CommissionExcludesVATFlag = CONV:ListingAgentCommissionExcludesVATFlag
      End
!      IF ~MP:CommissionPercent THEN MP:CommissionPercent = TDE:CommissionPercent.
!      IF MP:CommissionPercent AND BON:SalePrice AND NOT MP:CommissionAmount
!         MP:CommissionAmount = BON:SalePrice * MP:CommissionPercent /100
!      END
    End

    Unhide(?EstateAgentTab)
  Else
    MP:CommissionPercent = 0
    MP:CommissionAmount = 0
    Hide(?EstateAgentTab)
  End

  SAV:MP:CommissionPercent = MP:CommissionPercent
  SAV:MP:CommissionAmount  = MP:CommissionAmount

       Window{Prop:Alrt,254}=1024
       Window{Prop:Alrt,255}=AltF12
  PDPC:MP:PayableFrom.Init(?MP:PayableFrom,MP:PayableFrom,PopCalQ,Def_Config,)
  PDPC:MP:PayableTo.Init(?MP:PayableTo,MP:PayableTo,PopCalQ,Def_Config,)
  PDSC:MP:PayableFrom.Init(MP:PayableFrom,PDSchedC,?MP:PayableFrom,,,) ! NOTE: Date Scroll and Drop class range limits can be set with Field user options: PDDTRangeLow and PPDTRangeHigh
  PDSC:MP:PayableFrom.SetAlert(PDDT_eqSemiMonPlus+1,0) ! Disable altdown key so it can be used by button.
  PDSC:MP:PayableFrom.AddDropID('PDPopCal')
  PDSC:MP:PayableTo.Init(MP:PayableTo,PDSchedC,?MP:PayableTo,,,) ! NOTE: Date Scroll and Drop class range limits can be set with Field user options: PDDTRangeLow and PPDTRangeHigh
  PDSC:MP:PayableTo.SetAlert(PDDT_eqSemiMonPlus+1,0)  ! Disable altdown key so it can be used by button.
  PDSC:MP:PayableTo.AddDropID('PDPopCal')
  SAV:RoleId = MP:RoleID


  IF MP:RoleID = CTL:DefendantRoleID OR MP:RoleID = CTL:PlaintiffRoleID
     ?NOGroup{PROP:Hide} = False
  ELSE
     ?NOGroup{PROP:Hide} = True
     MP:NOFlag = 0
  END


  IF MP:RoleID = CTL:SuretyRoleID
     ?SuretyGroup{PROP:Hide} = False
  ELSE
     ?SuretyGroup{PROP:Hide} = True
  END


  DO DisplayAdminTabs    

  LOC:ExistingTabs = 5
  LOC:DisplayHowMany = 30
  LOC:ScreenType = 'R'
  LOC:AdjustYPos = 5  ! MOVE THE FIELDS DOWN A BIT

  GetAllTables(MP:MatterID)


!  MESSAGE('1 MP:RecordID = ' & MP:RecordID &|
!          '|MP:RoleID = ' & MP:RoleID &|
!          '|SAV:RoleId = ' & SAV:RoleId)

  GLO:DocumentLanguageID = MAT:DocumentLanguageID   ! FOR SOME OF THE BINDED FUNCTIONS

  IF CheckMatterConditions('E',1)  ! CHECK IF THEY ARE ALLOWED TO CHANGE THIS PARTY - CALL IN SILTENT MODE, I.E. NO MESSAGE DISPLAYED

        IF SELF.Request = ChangeRecord
           DISABLE(?OK)
        ELSIF SELF.Request = InsertRecord
           DISABLE(?LOC:Role)
           DISABLE(?SelectRole)
           IF SELF.FirstField = ?LOC:Role
              SELF.FirstField = ?MP:Reference
           END
        END
  END

  SELF.AddItem(ToolbarForm)
  FDB5.Init(?LOC:Role,Queue:FileDrop.ViewPosition,FDB5::View:FileDrop,Queue:FileDrop,Relate:Role,ThisWindow)
  FDB5.Q &= Queue:FileDrop
  FDB5.AddSortOrder(ROL:DescriptionKey)
  FDB5.AddField(ROL:Description,FDB5.Q.ROL:Description)
  FDB5.AddField(ROL:RoleScrnID,FDB5.Q.ROL:RoleScrnID)
  FDB5.AddField(ROL:RecordID,FDB5.Q.ROL:RecordID)
  FDB5.AddUpdateField(ROL:RecordID,MP:RoleID)
  FDB5.AddUpdateField(ROL:RoleScrnID,LOC:DefaultScreenID)
  ThisWindow.AddItem(FDB5.WindowComponent)
  FDB6.Init(?LOC:Language,Queue:FileDrop:1.ViewPosition,FDB6::View:FileDrop,Queue:FileDrop:1,Relate:LanguageAlias,ThisWindow)
  FDB6.Q &= Queue:FileDrop:1
  FDB6.AddSortOrder(LAN1:DescriptionKey)
  FDB6.AddField(LAN1:Description,FDB6.Q.LAN1:Description)
  FDB6.AddField(LAN1:RecordID,FDB6.Q.LAN1:RecordID)
  FDB6.AddUpdateField(LAN1:RecordID,MP:LanguageID)
  ThisWindow.AddItem(FDB6.WindowComponent)
  FDB6.DefaultFill = 0
  
  SELF.SetAlerts()
  
  INCLUDE('UpdateMatterExtraScreenSource','Open Window')
  
  
  
  
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  PDSC:MP:PayableFrom.Kill
  PDSC:MP:PayableTo.Kill
  PDPC:MP:PayableFrom.Kill
  PDPC:MP:PayableTo.Kill
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:BondData.Close
    Relate:Control.Close
    Relate:ConveyData.Close
    Relate:DocScrn.Close
    Relate:DocScrnField.Close
    Relate:LanguageAlias.Close
    Relate:MatParty.Close
    Relate:ParRolSc.Close
    Relate:Role.Close
    Relate:RoleExtraScreens.Close
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Open PROCEDURE

  CODE
  PARENT.Open
  ! THIS CODE SELECTS A PARTY FROM BROWSEPARTY IF INSERTING A RECORD
  
  IF SELF.Request = InsertRecord
!jess

     DO GetThePartyFromTheAddressBook

     IF GlobalResponse = RequestCancelled

        POST(EVENT:Accepted,?Cancel)

     ELSE


       DO RoleChanged

       0{PROP:Hide} = 0

     ! DISPLAY THE REMINDER MESSAGE FOR THIS PARTY
       IF PAR:MatterTakeOnReminder
          MESSAGE(PAR:MatterTakeOnReminder,'Reminder',ICON:Exclamation)
       END


     END

  END


      IF MP:RoleId = CTL:ClientRoleID
         ?LOC:Role{PROP:Disable} = True
         ?SelectRole{PROP:Disable} = True
      END





ThisWindow.PrimeFields PROCEDURE

  CODE
    MP:RateSurityIndicator = 'Y'
    MP:RatePrimaryApplicant = 'Y'
    MP:RatePerminantResident = 'Y'
    IF ~MP:IncludeInLifeAssurance Then MP:IncludeInLifeAssurance = 'Y'.
  
  PARENT.PrimeFields
!  ! THIS CODE SELECTS A PARTY FROM BROWSEPARTY IF INSERTING A RECORD
!  
!  IF SELF.Request = InsertRecord
!
!     DO GetThePartyFromTheAddressBook
!
!  END

  MP:MatterID = MAT:RecordID
    



ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled
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
    OF ?MP:RateCustomerRole
      GET(RatesCustomerRoleQueue,CHOICE())
      MP:RateCustomerRole = RCRQ:Description
      
    OF ?MP:CommissionPercent
        Do EstateCommissionChange
    OF ?MP:CommissionAmount
        Do EstateCommissionChange
    OF ?OK
    PropSQLNext('Select top 1 ISNULL(INACTIVEFlag,0) FROM PArty WHERE RecordID = ' & MP:PartyID)
    IF ROW:Counter
        CASE MESSAGE('The Party you have selected is inactive.||Are you sure you want to add them to this matter?','Warning',ICON:Exclamation,BUTTON:Yes+BUTTON:No,BUTTON:No,1)                                            
            OF BUTTON:No                            
            CYCLE
        END
    END

  Do EstateCommissionChange
  IF SELF.Request = InsertRecord and MP:RoleID <> CTL:CreditorAdminRoleId  ! There can be duplicate parties for Admin Orders
     CLEAR(ROW:Record)
     RowCounter{PROP:SQL} = 'SELECT COUNT(1) FROM MatParty WHERE MatterID = ' & MP:MatterID & ' AND PartyID = ' & MP:PartyID & ' AND RoleID = ' & MP:RoleID
     NEXT(RowCounter)
     IF ROW:Counter
        MESSAGE('This Party is already a ' & LOC:Role & ' in this Matter','Party Exists',ICON:Exclamation)
        SELECT(?Cancel)
        CYCLE
     END

     DO GetNewSorter

  ELSE

    If ORIG:RoleId <> MP:RoleId or ~MP:Sorter
       DO GetNewSorter
    .

  END

  If ~LOC:Option Then MP:DistributionPercent = 0.
  Clear(ROW:Record)
  RowCounter{PROP:SQL} = 'Select 0,Type FROM Bonddata WHERE Matterid = ' & MP:MatterID
  Next(RowCounter)
  If Instring(ROW:Description,'CL',1,1)
    If SAV:RoleID = CTL:BuyerRoleID OR SAV:RoleID = CTL:SellerRoleID OR SAV:RoleID = CTL:DeveloperRoleID
      Clear(ROW:Record)
      RowCounter{PROP:SQL} = 'Select EntityID From Party Where RecordId = ' & MP:PartyID
      Next(RowCounter)
      If ROW:Counter
        PAR:EntityID = ROW:Counter
        Clear(ROW:Record)
        RowCounter{PROP:SQL} = 'Select RecordId,'''',JuristicFlag From Entity Where RecordId = ' & PAR:EntityID
        Next(RowCounter)
        If ROW:Amount1 = 1 And MP:RateCustomerRole = 'PRIVATE INDIVIDUAL'
          Message('This is a Juristic Person but your customer role is ''PRIVATE INDIVIDUAL''|||Please select the "Rates Clearance Cert" TAB|and change the Customer Role.','RCC Selection Error',ICON:Exclamation)
          Select(?MP:RateCustomerRole)
          Cycle
        End
      End
    End
  End

  If MP:RoleID = CTL:BuyerRoleID OR MP:RoleID = CTL:SellerRoleID OR MP:RoleID = CTL:DeveloperRoleID
    If ~MP:RateCustomerRole Then MP:RateCustomerRole = 'PRIVATE INDIVIDUAL'.
    PropSQLNext('Select Category, Description From ParType Where RecordId = ' & PAR:PartyTypeID)
    a# = 0
    If PAR:EntityID = 1 And ~InList(MP:RateCustomerRole,'PRIVATE INDIVIDUAL','JOINT ACCOUNT') Then a# = 1.
    If PAR:EntityID = 5 And MP:RateCustomerRole <> 'CLOSE CORPORATION' Then a# = 1.
    If Inlist(PAR:EntityID,6,7) And MP:RateCustomerRole <> 'COMPANY' Then a# = 1.
    If PAR:EntityID = 4 And MP:RateCustomerRole <> 'PARTNERSHIP' Then a# = 1.
    If PAR:EntityID = 9 And MP:RateCustomerRole <> 'TRUST' Then a# = 1.
    If PAR:PartyTypeID = 24 And MP:RateCustomerRole <> 'CHURCH' Then a# = 1.
    If PAR:PartyTypeID = 17 And MP:RateCustomerRole <> 'DECEASED ESTATE' Then a# = 1.
    If PAR:PartyTypeID = 18 And MP:RateCustomerRole <> 'INSOLVENT ESTATE' Then a# = 1.
    If PAR:PartyTypeID = 43 And MP:RateCustomerRole <> 'NON-PROFIT ORGANISATION' Then a# = 1.
    If PAR:EntityID = 11 And PAR:PartyTypeID = 20 And MP:RateCustomerRole <> 'LOCAL COUNCIL' Then a# = 1.
    If a#
      Message('This Party is ' & Clip(ROW:Description) & ' but your customer role is ' & MP:RateCustomerRole & '|The Party Name is ' & PAR:Name & '||Please select this Matters Party, then select the "Rates Clearance Cert" TAB|and change the Customer Role.','RCC Selection Error',ICON:Exclamation)
      Select(?MP:RateCustomerRole)
      Cycle
    End
  End

  IF MP:NOFlag
     IF ~MP:NOCapacity
         SELECT(?MP:NOCapacity)
         CYCLE
     ELSIF ~MP:NOPrincipal
         SELECT(?MP:NOPrincipal)
         CYCLE
     END
  END

  IF Inlist(MP:RoleID,CTL:SellingAgencyRoleID,CTL:ListingAgencyRoleID,CTL:EstateAgentRoleID,CTL:ListingAgentRoleID)
    If MP:Sorter = 1
      IF BON:MatterID <> MP:MatterId
        BON:MatterID = MP:MatterId !Was NOT set before 24 Nov 2020
        IF Access:BondData.TryFetch(BON:PrimaryKey)
          Message('Error Reading BondData with MP:MatterId:' & MP:MatterId & '|Error: ' & Error(),'Error Should not occur',ICON:Exclamation)
        End
      End
      IF CONV:MatterID <> MP:MatterId
        CONV:MatterID = MP:MatterId !Was NOT set before 24 Nov 2020
        IF Access:ConveyData.TryFetch(CONV:PrimaryKey)
          Message('Error Reading ConveyData with MP:MatterId:' & MP:MatterId & '|Error: ' & Error(),'Error Should not occur',ICON:Exclamation)
        End
      End
      DEBUG('MP:RoleID = ' & MP:RoleID)
      Case MP:RoleID
      Of CTL:SellingAgencyRoleID
        DEBUG('CTL:SellingAgencyRoleID = ' & CTL:SellingAgencyRoleID)
        BON:CommissionPercent = MP:CommissionPercent
        BON:CommissionAmount  = MP:CommissionAmount
        CONV:CommissionExcludesVATFlag = MP:CommissionExcludesVATFlag
      Of CTL:ListingAgencyRoleID
        DEBUG('CTL:ListingAgencyRoleID = ' & CTL:ListingAgencyRoleID)
        CONV:ListingAgentCommissionPercent = MP:CommissionPercent
        CONV:ListingAgentCommissionAmount  = MP:CommissionAmount
        CONV:ListingAgentCommissionExcludesVATFlag = MP:CommissionExcludesVATFlag
      End

      IF BON:MatterID = MP:MatterId
        Access:BondData.TryUpdate
      End
      IF CONV:MatterID = MP:MatterId
        Access:ConveyData.TryUpdate
      End
    End
  Else
    MP:CommissionPercent = 0
    MP:CommissionAmount = 0
  End
  !Deceased Estate
  
      PropSQLNext('Select top 10 P.RecordID,Convert(varchar(255),MP.RecordID),RE.RecordID from ParRel PR <13,10> ' & |
                  'INNER JOIN Party PP ON PP.RecordID = PR.PartyID AND PP.EntityID =10 AND PP.PartyTypeID = (Select top 1 RecordID from ParType WHERE Description = ''Deceased Estate'') AND PP.RecordID = '& MP:PartyID & '  <13,10> ' & |
                  'INNER JOIN Party P ON P.RecordID = PR.OtherPartyID<13,10> ' & |
                  'INNER JOIN Role RE ON RE.Description = ''Deceased''<13,10> ' & |
                  'INNER JOIN Relationship R ON R.RecordID = PR.RelationshipID AND R.Description = ''Deceased Estate''<13,10> ' & |
                  'LEFT JOIN MatParty MP ON MP.PartyID = PR.OtherPartyID AND MP.RoleID =  RE.RecordID AND MP.MatterID = ' & MP:MatterID)
        IF ROW:Counter > 1 AND ROW:Amount1 > 1 AND ~ROW:Description

            PropSQLNext('INSERT MatParty ' &|
                          ' (RecordID,MatterID,PartyID,RoleID,LanguageId,Sorter) ' &|
                      ' VALUES ((Select MAX(ISNULL(RecordID,0))+1 FROM MatParty),' &|
                      MP:MatterID & ',' &|
                      ROW:Counter & ',' &|
                      ROW:Amount1 & ',' &|
                      MP:LanguageID & ',' &|
                       'ISNULL((SELECT MAX(ISNULL(Sorter,0))+1 FROM MatParty WHERE MatterID = ' & MP:MatterID & ' AND RoleID = ' & ROW:Amount1 & '),1))')
        END
      
  INCLUDE('UpdateMatterExtraScreenSource','OK Button')


    OF ?AddButton
                  GlobalRequest = SelectRecord
                  GLO:ExtraScreenType = 'R'
                  SelectDocScrn
                  IF GlobalResponse = RequestCompleted
                     CLEAR(PRS:Record)
                     GET(ParRolSc,0)
                     PRS:RoleScreenID = DS:RecordID
                     PRS:MatPartyID = MP:RecordID


                     IF ~DUPLICATE(PRS:PrimaryKey)
                         CLEAR(PRS:Record)
                         PRS:RoleScreenID = DS:RecordID
                         PRS:MatPartyID = MP:RecordID


                         IF ~Access:ParRolSc.Insert()
                             DO DisplayExtraScreens
                         END
                     END
                  END
    ELSE
    INCLUDE('UpdateMatterExtraScreenSource','TakeAccepted')
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?SelectParty
      ThisWindow.Update
      GlobalRequest = SelectRecord
      BrowseParty
      If GlobalResponse = RequestCompleted           ! IF Lookup completed
         MP:PartyId = PAR:RecordId
         LOC:Name = GetDescription('PARTY NAME',MP:PartyId)

        ! DISPLAY THE REMINDER MESSAGE FOR THIS CLIENT
          IF PAR:MatterTakeOnReminder
             MESSAGE(PAR:MatterTakeOnReminder,'Reminder',ICON:Exclamation)
          END

         DEBUG('Do DisplayLanguage')
         DO DisplayLanguage

      
         IF ~MP:ContactID
             MP:ContactID = GetDefaultContact(MP:PartyID)
             LOC:Contact = GetDescription('PARTY NAME',MP:ContactID)
             DO SetContactRelationshipID
         END
      
      
         ! IF THIS PARTY IS THE CLIENT - CHANGE IT IN THE MATTER
         IF MP:RoleId = CTL:ClientRoleID
            RowCounter{PROP:SQL} = 'Update Matter SET ClientID = ' & MP:PartyID & ' WHERE RecordID = ' & MP:MatterID
         END
      
         IF PAR:DefaultRoleID AND PAR:DefaultRoleID <> CTL:ClientRoleID
            IF SELF.Request = ChangeRecord AND MP:RoleID   ! IF CHANGING AN EXISTING ENTRY
               ! DO NOTHING
            ELSE
               MP:RoleID = PAR:DefaultRoleID
               FDB5.ResetQueue(True)
               Post(EVENT:ACCEPTED,?LOC:Role)
            END
         END

         DISPLAY
      .
    OF ?LOC:Role
      ThisWindow.Update
      
!      MESSAGE('Window.Takeaccepted||RoleChanged||MP:RoleID = ' & MP:RoleID &|
!          '|SAV:RoleID = ' & SAV:RoleID)
      
      DO RoleChanged
      
      
      
    OF ?SelectRole
      ThisWindow.Update
        GlobalRequest = SelectRecord
        BrowseRole
        IF GlobalResponse = RequestCompleted           ! IF Lookup completed
           MP:RoleId = ROL:RecordId
           LOC:DefaultScreenID = ROL:RoleScrnID
           DO GetNewSorter
           FDB5.ResetQueue(True)
           Post(EVENT:ACCEPTED,?LOC:Role)
        .
      
    OF ?SelectContact
      ThisWindow.Update
      GlobalRequest = SelectRecord
      BrowseParRel(MP:PartyID)
      If GlobalResponse = RequestCompleted
         MP:ContactID = PAR1:RecordId
         LOC:Contact = GetDescription('PARTY NAME',MP:ContactID)
         DO SetContactRelationshipID
         DISPLAY
      ELSE
        IF MP:ContactID
           IF MESSAGE('Do you want to remove the existing Contact linked to this Party?','Delete Contact?',ICON:Exclamation,BUTTON:Yes+BUTTON:No,BUTTON:No) = BUTTON:Yes
              MP:ContactID = 0
              LOC:Contact = ''
              DISPLAY(?LOC:Contact)
           END
        END

      END
    OF ?LookupLibraryButton
      ThisWindow.Update
      GLO:TooltipCategory = ?MP:SuretySecurity{PROP:Tooltip}
      IF GLO:TooltipCategory
      
         FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
         IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
      
         SAV:PROP:SelStart# = ?MP:SuretySecurity{PROP:SelStart}
         GLO:TooltipContents = ?MP:SuretySecurity{PROP:ScreenText}
         GlobalRequest = SelectRecord
         BrowseLookup
         IF GlobalResponse = RequestCompleted
            LIB:Description = ReplaceTextBoxFields(LIB:Description,0,-1,-1,0)
            IF MP:SuretySecurity     ! IF THERE ALREADY IS TEXT IN THIS FIELD
               IF SAV:PROP:SelStart#  >= LEN(MP:SuretySecurity) ! THE CURSOR IS AT THE END
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                     MP:SuretySecurity = LIB:Description
                     MP:SuretySecurity =  MP:SuretySecurity & LIB:Description
                  END
               ELSE
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                     MP:SuretySecurity = LIB:Description
                     MP:SuretySecurity =  SUB(Contents(?MP:SuretySecurity),1,SAV:PROP:SelStart#-1) & LIB:Description & SUB(Contents(?MP:SuretySecurity),SAV:PROP:SelStart#,1000)
                  END
               END
            ELSE
              MP:SuretySecurity = LIB:Description
            END
            DISPLAY(?MP:SuretySecurity)
            SELECT(?MP:SuretySecurity,SAV:PROP:SelStart# + LEN(LIB:Description))
         END
         CLEAR(GlobalRequest)
      ELSE
         MESSAGE('This Field does not have a Tooltip.||Unable to display the lookup library.','Program Error',ICON:Exclamation)
      END
      
      
      
      
    OF ?SelectAttorney
      ThisWindow.Update
      SaveMatPartyAlias = MP:Record

      GLO:PartyTypeID = CTL:AttorneyTypeID
      PAR:RecordID = MP:AttorneyID

      GlobalRequest = SelectRecord
      BrowseParty

      GLO:PartyTypeID = 0

      If ThisWindow.Request = ChangeRecord
        MP:RecordId = SAV:MP:RecordId
        Access:MatParty.Fetch(MP:PrimaryKey)
      .
      MP:Record = SaveMatPartyAlias
      If GlobalResponse = RequestCompleted


        PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''Assigned Attorney: ' & StripSQL(PAR:Name) & ''',0,''MatParty'',2,' & CEM:RecordID & ',' & MP:RecordID & ',''' & MAT:FileRef & ''',''' & GlobalErrors.GetProcedureName() & '''','UpdateMatParty')


        MP:AttorneyId = PAR:RecordId
        Change(?LOC:Attorney,PAR:Name)

      ELSE

        IF MP:AttorneyID
           IF MESSAGE('Do you want to remove the existing Attorney linked to this Party?','Delete Attorney?',ICON:Exclamation,BUTTON:Yes+BUTTON:No,BUTTON:No) = BUTTON:Yes
              MP:AttorneyID = 0
              LOC:Attorney = ''

              PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',''Removed Attorney: ' & StripSQL(PAR:Name) & ''',0,''MatParty'',2,' & CEM:RecordID & ',' & MP:RecordID & ',''' & MAT:FileRef & ''',''' & GlobalErrors.GetProcedureName() & '''','UpdateMatPartyAdmin')


              DISPLAY(?LOC:Attorney)
           END
        END
      .
    OF ?OK
      ThisWindow.Update
      IF SELF.Request = ViewRecord
        POST(EVENT:CloseWindow)
      END
    OF ?ModifyButton
      ThisWindow.Update
      INCLUDE('UpdateMatterExtraScreenSource','Modify Button')
    OF ?DeleteButton
      ThisWindow.Update
      INCLUDE('UpdateMatterExtraScreenSource','Delete Button')
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeCloseEvent PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    INCLUDE('UpdateMatterExtraScreenSource','TakeCloseEvent')
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
    IF MP:RoleID = CTL:ClientRoleID
       RowCounter{PROP:SQL} = 'Update Matter SET TheirRef = ' & MP:Reference & ' WHERE RecordID = ' & MP:MatterID
    END
  
    IF SELF.Request = InsertRecord
       IF ~MP:ContactID
           MP:ContactID = GetDefaultContact(MP:PartyID)
           DO SetContactRelationshipID
       END
    END

    IF SELF.Request = ChangeRecord
       PROPSQL('INSERT EmployeeLogFile SELECT ' & TODAY() & ',' & CLOCK() & ',(SELECT Name FROM Party WHERE RecordID = ' & MP:PartyID & '),0,''MatParty'',2,' & CEM:RecordID & ',' & MP:RecordID & ',(SELECT FileRef FROM Matter WHERE RecordID = ' & MP:MatterID & '),''' & GlobalErrors.GetProcedureName() & '''','FileManager - Update MatParty')
    END
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
  PDPC:MP:PayableFrom.TakeEvent()
  PDPC:MP:PayableTo.TakeEvent()
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
  CASE FIELD()
  OF ?Sheet1
    CASE EVENT()
    OF EVENT:TabChanging
       IF CHOICE(?Sheet1) > LOC:ExistingTabs
          GET(ScreenQueue,CHOICE(?Sheet1) - LOC:ExistingTabs)
          SaveScreenData
       END
      
    END
  END
!  DO RoleChanged
!
!  IF RECORDS(ScreenQueue)
!     ?ModifyButton{PROP:Disable} = False
!     ?DeleteButton{PROP:Disable} = False
!  ELSE
!     ?ModifyButton{PROP:Disable} = True
!     ?DeleteButton{PROP:Disable} = True
!  END


   IF ~(SAV:MP:SuretyUnlimitedFlag = MP:SuretyUnlimitedFlag)
        SAV:MP:SuretyUnlimitedFlag = MP:SuretyUnlimitedFlag
        IF MP:SuretyUnlimitedFlag
           MP:SuretyAmount = 0
           DISABLE(?MP:SuretyAmount)
           DISABLE(?MP:SuretyAmount:Prompt)
        ELSE
           ENABLE(?MP:SuretyAmount)
           ENABLE(?MP:SuretyAmount:Prompt)
        END
   END


  ReturnValue = PARENT.TakeFieldEvent()
  IF FIELD()=?MP:PayableFrom
    
  END
  IF FIELD()=?MP:PayableTo
    
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


    OF ?LOC:Attorney
      
    END
  ReturnValue = PARENT.TakeNewSelection()
  
  ! REMOVED PREEMPTIVE LIBRARY LOOKUPS FROM TEMPLATE ON 27/5/2009
  ! SUSPECT IT WAS CAUSING PERFORMANCE ISSUES AND POSSIBLY EXITING WITHOUT ERRORS (BECAUSE IT WAS DOING THIS INTERMTTENTLY WHEN TESTING TODAY)
  
  
  
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

PDPC:MP:PayableFrom.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF MP:PayableFrom <> L:Default
    POST(EVENT:Accepted,?MP:PayableFrom)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDPC:MP:PayableTo.TakeAccepted PROCEDURE
RV  BYTE
L:Default  LONG
  CODE
  L:Default=PopCalQ.PassDate
  PDDT_PopCal()
  IF MP:PayableTo <> L:Default
    POST(EVENT:Accepted,?MP:PayableTo)
  END
  IF KEYCODE()= EscKey
    PopCalQ.PassDate=L:Default
  END
  DISPLAY()
  RETURN RV
PDSC:MP:PayableFrom.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV
PDSC:MP:PayableTo.TakeFieldEvent PROCEDURE
RV BYTE
  CODE
  IF EVENT()=EVENT:AlertKey
    IF Keycode() = AltDown
      RETURN 0
    END
  END
  RV=PARENT.TakeFieldEvent()
  RETURN RV

FDB5.ApplyFilter PROCEDURE

  CODE
  IF MP:RoleID <> CTL:ClientRoleID
     FDB5::View:FileDrop{PROP:SQLFilter} = 'RecordID <> ' & CTL:ClientRoleID
  END
  PARENT.ApplyFilter

SaveScreenData      PROCEDURE

   CODE

       IF CHOICE(?Sheet1) < LOC:ExistingTabs THEN RETURN.

       CLEAR(PRS:Record)
       PRS:RoleScreenID = SCRQ:DocScrnID
       PRS:MatPartyID = MP:RecordID
       IF ~Access:ParRolSc.Fetch(PRS:PrimaryKey)

           DO UpdateDataRecord

           Access:ParRolSc.TryUpdate

       END

GetDefaultContact    PROCEDURE  (ThePartyID)          ! Declare Procedure
LOC:ReturnValue     LONG
  CODE
  CLEAR(RES:Record)
  ResultSet{PROP:SQL} = 'Select OtherPartyID From ParRel WHERE PartyID = ' & ThePartyID & ' AND DefaultContactFlag = 1'
  NEXT(ResultSet)
  LOC:ReturnValue = RES:RecordId
  RETURN(LOC:ReturnValue)


SelectMatPartySelected PROCEDURE (TheMatterID,<ThePartyRole>,<TheMessage>) !Generated from procedure template - Window

SAV::MatterID  LONG
SAV::RoleID    LONG
SAV:PartyID    LONG
LOC:Sorter     SHORT
SAV::RecordID  LONG
LOC:RoleID     LONG
LOC:ActingFor  LIKE(COL:ActingFor)
LOC:String     CSTRING(255)
CurrentTab           STRING(80)
SAV:RoleID           LONG
FilesOpened          BYTE
ezField              LONG
LOC:PartyName        CSTRING(50)
LOC:Role             CSTRING(50)
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
LOC:Description      CSTRING(60)
LOC:Party            CSTRING(50)
LOC:Email            CSTRING(100)
Tag                  STRING(10)
LOC:Recipient        CSTRING(350)
LOC:MatterID         LONG
BRW1::View:Browse    VIEW(MatParty)
                       PROJECT(MP:Sorter)
                       PROJECT(MP:PartyID)
                       PROJECT(MP:RoleID)
                       PROJECT(MP:RecordID)
                       PROJECT(MP:MatterID)
                       JOIN(ROL:PrimaryKey,MP:RoleID)
                         PROJECT(ROL:Color1)
                         PROJECT(ROL:Description)
                         PROJECT(ROL:RecordID)
                       END
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?Browse:1
LOC:Party              LIKE(LOC:Party)                !List box control field - type derived from local data
LOC:Party_NormalFG     LONG                           !Normal forground color
LOC:Party_NormalBG     LONG                           !Normal background color
LOC:Party_SelectedFG   LONG                           !Selected forground color
LOC:Party_SelectedBG   LONG                           !Selected background color
LOC:Description        LIKE(LOC:Description)          !List box control field - type derived from local data
LOC:Description_NormalFG LONG                         !Normal forground color
LOC:Description_NormalBG LONG                         !Normal background color
LOC:Description_SelectedFG LONG                       !Selected forground color
LOC:Description_SelectedBG LONG                       !Selected background color
MP:Sorter              LIKE(MP:Sorter)                !Browse hot field - type derived from field
MP:PartyID             LIKE(MP:PartyID)               !Browse hot field - type derived from field
MP:RoleID              LIKE(MP:RoleID)                !Browse hot field - type derived from field
MP:RecordID            LIKE(MP:RecordID)              !Browse hot field - type derived from field
ROL:Color1             LIKE(ROL:Color1)               !Browse hot field - type derived from field
ROL:Description        LIKE(ROL:Description)          !Browse hot field - type derived from field
MP:MatterID            LIKE(MP:MatterID)              !Browse key field - type derived from field
ROL:RecordID           LIKE(ROL:RecordID)             !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
ThisSecProc    Class()
CheckAccess       PROCEDURE(),BYTE,PROC
Update            PROCEDURE(),BYTE,PROC
                End
QuickWindow          WINDOW('Select the Party'),AT(,,391,280),FONT('Arial',9,,),CENTER,IMM,SYSTEM,GRAY,DOUBLE,MDI
                       LIST,AT(8,34,367,168),USE(?Browse:1),IMM,HVSCROLL,FORMAT('155L(2)|M*~Party~@s49@236L(2)|M*~Role~@s59@'),FROM(Queue:Browse:1)
                       BUTTON('&Insert'),AT(102,111,42,12),USE(?Insert),HIDE
                       BUTTON('&Change'),AT(146,111,42,12),USE(?Change),HIDE
                       BUTTON('&Delete'),AT(190,111,42,12),USE(?Delete),HIDE
                       TEXT,AT(10,208,367,40),USE(LOC:String),SKIP,FONT(,,,FONT:bold,CHARSET:ANSI),COLOR(080FFFFH),READONLY
                       BUTTON('&Select'),AT(324,255,60,20),USE(?ContinueButton),LEFT,FONT(,11,,,CHARSET:ANSI),TIP('Select this Party and continue assembling the Document'),KEY(EnterKey),ICON('check3.ico'),DEFAULT
                       BUTTON,AT(8,4,28,24),USE(?GoToButton),LEFT,TIP('Edit this Party''s details in the Address Book'),ICON('id_card_ok.ico')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeFieldEvent         PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)               !Browse using ?Browse:1
Q                      &Queue:Browse:1                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
SetQueueRecord         PROCEDURE(),DERIVED
                     END

Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


  CODE
  GlobalResponse = ThisWindow.Run()

DisplayMessage      ROUTINE

     IF RECORDS(Queue:Browse:1) > 0
        IF TheMessage
           LOC:String = TheMessage
        ELSE
           LOC:String = 'The document currently being assembled (' & DOC:DisplayName & ') refers to a specific Party.' &|
                        '<13,10>Please select this Party now or press INSERT to add a Party and then SELECT it.'
        END
     ELSE
        IF ThePartyRole
           LOC:String = 'The Document currently being assembled (' & DOC:DisplayName & ') refers to a ' & ThePartyRole & '.' &|
                        '<13,10>No ' & ThePartyRole & 's could be found for this Matter.' &|
                        '<13,10>Press INSERT to allocate a ' & ThePartyRole & ' to this Matter.'
           ELSE
           LOC:String = 'The document currently being assembled (' & DOC:DisplayName & ') refers to a specific Party.' &|
                        '<13,10>No Parties could be found for this Matter.' &|
                        '<13,10>Press INSERT to add a Party to this Matter.'
           END
      END
      DISPLAY(?LOC:String)


ResortTheSorter     ROUTINE

   RowCounter{PROP:SQL} = 'CALL SP_ResortMatPartySorter(' & SAV::MatterID & ')'


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('SelectMatPartySelected')
  CLEAR(MP:Record)
  SELF.Request = GlobalRequest
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Browse:1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors
  SELF.FirstField = ?Browse:1
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)
  CLEAR(GlobalResponse)
  LOC:MatterID = TheMatterID
  NewTag:Ptrm(TAG:SelectedMatterParty)
  Relate:MatParty.Open
  Relate:Matter.Open
  SELF.FilesOpened = True
  Access:Role.UseFile
  
  FLUSH(BRW1::View:Browse) !Added by nicole 2016/5/30 to fix views persisting and not refreshing correctly
  !BUFFER(BRW1::View:Browse,30,2,5,300)
  BRW1.Init(?Browse:1,Queue:Browse:1.ViewPosition,BRW1::View:Browse,Queue:Browse:1,Relate:MatParty,SELF)
  ColorText:8#          = GLO:ColorText
  ColorBackground:8#    = GLO:ColorBackground
  ColorSelText:8#       = GLO:ColorSelText
  ColorSelBackground:8# = GLO:ColorSelBackground
  ColorGrid:8#          = GLO:ColorGrid
  OPEN(QuickWindow)
  SELF.Opened=True
  0{PROP:Text} = 'Select the Party (' & MAT:FileRef & ' - ' & MAT:Description & ')'
       QuickWindow{Prop:Alrt,254}=1024
       QuickWindow{Prop:Alrt,255}=AltF12
  BRW1.Q &= Queue:Browse:1
  BRW1.FileLoaded = 1
  
  BRW1.AddSortOrder(,MP:MatterRoleKey)
  BRW1.AddRange(MP:MatterID,Relate:MatParty,Relate:Matter)
  BIND('LOC:Party',LOC:Party)
  BIND('LOC:Description',LOC:Description)
  BRW1.AddField(LOC:Party,BRW1.Q.LOC:Party)
  BRW1.AddField(LOC:Description,BRW1.Q.LOC:Description)
  BRW1.AddField(MP:Sorter,BRW1.Q.MP:Sorter)
  BRW1.AddField(MP:PartyID,BRW1.Q.MP:PartyID)
  BRW1.AddField(MP:RoleID,BRW1.Q.MP:RoleID)
  BRW1.AddField(MP:RecordID,BRW1.Q.MP:RecordID)
  BRW1.AddField(ROL:Color1,BRW1.Q.ROL:Color1)
  BRW1.AddField(ROL:Description,BRW1.Q.ROL:Description)
  BRW1.AddField(MP:MatterID,BRW1.Q.MP:MatterID)
  BRW1.AddField(ROL:RecordID,BRW1.Q.ROL:RecordID)
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)
  SELF.AddItem(Resizer)
  
   BIND('LOC:RoleID',LOC:RoleID)
  
  
  
  IF LOC:RoleID
     BRW1.SetFilter('(MP:RoleID = LOC:RoleID)')
  END
  
  BRW1.AskProcedure = 1
  BRW1.AddToolbarTarget(Toolbar)
  SELF.SetAlerts()
      ?Browse:1{PROP:FontColor} = ColorText:8#
      ?Browse:1{PROP:Background} = ColorBackground:8#
      ?Browse:1{PROP:SelectedColor} = ColorSelText:8#
      ?Browse:1{PROP:SelectedFillColor} = ColorSelBackground:8#
      ?Browse:1{PROPLIST:GRID} = ColorGrid:8#
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:MatParty.Close
    Relate:Matter.Close
  END
        UNBIND('LOC:RoleID')
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    If ThisSecProc.CheckAccess() Then Return RequestCancelled.
  ! CHANGED BY RICK 3/6/2016 - CLIENT HAD A ROLE CALLED "PARTY" FOR SOME REASON WHICH WAS CAUSING THE CODE BELOW TO TRY AND FILTER BY "PARTY"
  !IF ThePartyRole
  IF UPPER(ThePartyRole) <> 'PARTY'
  
     CLEAR(ROW:Record)
  
     IF UPPER(ThePartyRole) = 'OURPARTY'
           RowCounter{PROP:SQL} = 'SELECT 0,ActingFor FROM ColData WHERE MatterID = ' & MAT:RecordID
           NEXT(RowCounter)
           LOC:ActingFor = ROW:Description
           IF LOC:ActingFor = 'P'                   ! ACTING FOR THE PLAINTIFF
              LOC:RoleID = CTL:PlaintiffRoleID
           ELSIF LOC:ActingFor = 'D'                ! ACTING FOR THE DEFENDANT
              LOC:RoleID = CTL:DefendantRoleID
           END
  
     ELSIF UPPER(ThePartyRole) = 'THEIRPARTY'
  
           RowCounter{PROP:SQL} = 'SELECT 0,ActingFor FROM ColData WHERE MatterID = ' & MAT:RecordID
           NEXT(RowCounter)
           LOC:ActingFor = ROW:Description
           IF LOC:ActingFor = 'P'                   ! ACTING FOR THE PLAINTIFF
              LOC:RoleID = CTL:DefendantRoleID
           ELSIF LOC:ActingFor = 'D'                ! ACTING FOR THE DEFENDANT
              LOC:RoleID = CTL:PlaintiffRoleID
           END
  
     ELSE
  
        RowCounter{PROP:SQL} = 'SELECT RecordID FROM Role WHERE Description = ''' & CLIP(ThePartyRole) & ''''
        NEXT(RowCounter)
        LOC:RoleID = ROW:Counter
  
     END
  
  END
  
  
  ! IF THERE IS ONLY ONE OF THEM THEN SELECT IT AUTOMATICALLY FOR THEM
  
  IF LOC:RoleID
     RowCounter{PROP:SQL} = 'SELECT COUNT(1) FROM MatParty WHERE MatterID = ' & TheMatterID & ' AND RoleID = ' & LOC:RoleID
     NEXT(RowCounter)
     IF ROW:Counter = 1   
        RowCounter{PROP:SQL} = 'SELECT RecordID FROM MatParty WHERE MatterID = ' & TheMatterID & ' AND RoleID = ' & LOC:RoleID & ' AND Sorter = 1'
        NEXT(RowCounter)
        IF ROW:Counter
           SetTag:Ptrm(TAG:SelectedMatterParty,ROW:Counter)
           RETURN RequestCompleted
        END
     END
  END
  
  
  
  ReturnValue = PARENT.Run()
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled
  ELSE
    GlobalRequest = Request
    UpdateMatParty
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
    OF ?Change
      ThisWindow.Update
      SAV::RecordID = MP:RecordID
      SAV::MatterID = MP:MatterID
      SAV::RoleID   = MP:RoleID
      
      GlobalRequest = ChangeRecord
      UpdateMatParty
      IF GlobalResponse = RequestCompleted
         DO ResortTheSorter
         MP:RecordID = SAV::RecordID
         Access:MatParty.TryFetch(MP:PrimaryKey)
         BRW1.ResetFromBuffer
         BRW1.PostNewSelection
      END
      
      SELECT(?Browse:1)
      RETURN(LEVEL:Notify)
      
      
    OF ?Delete
          ThisWindow.Update
          IF MP:RoleID = CTL:ClientRoleID AND MP:Sorter = 1
             MESSAGE('You cannot delete the Client From a Matter. Every Matter must have a Client.||If you wish to change the Client, edit the Matter itself and change the Client there.','Access Denied',ICON:Exclamation)
             SELECT(?Browse:1,CHOICE(?Browse:1))
                RETURN(LEVEL:Notify)
          ELSE
             IF MESSAGE('Are you sure you want to delete the highlighted Party?','Deleting a Party',ICON:Question,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:Yes
                SAV::MatterID = MP:MatterID
                SAV::RoleID = MP:RoleID
                Relate:MatParty.Delete(0)
!                DELETE(MatParty)
                DO ResortTheSorter

                FLUSH(BRW1::View:Browse)
                BRW1.ResetQueue(Reset:Queue)
                SELECT(?Browse:1,CHOICE(?Browse:1)-1)
                RETURN(LEVEL:Notify)
             ELSE
                SELECT(?Browse:1,CHOICE(?Browse:1))
                RETURN(LEVEL:Notify)
             END
          END

    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?ContinueButton
      ThisWindow.Update
      
      BRW1.UpdateBuffer
      
      SetTag:Ptrm(TAG:SelectedMatterParty,MP:RecordID)
      
      
      IF GLO:DebuggingFlag
      
         LOC:Party = GetDescription('PARTY NAME',MP:PartyID)
      
      
       MESSAGE('SELECTED ' & LOC:Party & '||MP:RecordID = ' & MP:RecordID & '|FstTag:Ptrm(TAG:SelectedMatterParty) = ' & FstTag:Ptrm(TAG:SelectedMatterParty) & '|CnTag:Ptrm(TAG:SelectedMatterParty) = ' & CntTag:Ptrm(TAG:SelectedMatterParty),'Debugging SelectMatPartySelected',ICON:Exclamation)
      
      END
      
      
      POST(EVENT:CloseWindow)
      
    OF ?GoToButton
      ThisWindow.Update
      BRW1.UpdateBuffer
      
      
            CLEAR(PAR:Record)
            PAR:RecordID = MP:PartyID
            IF ~Access:Party.Fetch(PAR:PrimaryKey)
                Set(PAR:PrimaryKey,PAR:PrimaryKey)   ! DOING THIS SO DOESN'T GIVE AN ERROR
                Next(Party)                          ! WHEN CALLING THIS FORM FROM BrowseMatParty
                GlobalRequest = ChangeRecord
                UpdateParty
                IF GlobalResponse = RequestCompleted
                   BRW1.ResetFromFile
                   BRW1.PostNewSelection
                END
            END
            SELECT(?Browse:1)
      
    END
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
  DO DisplayMessage
  ReturnValue = PARENT.TakeFieldEvent()
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
  SP:Description = 'Matters - Matter Party'
  IF Access:SecProc.TryFetch(SP:SecGroupKey) Then Access:SecProc.Insert().
  If ~SP:AccessFlag and ~GLO:SupervisorFlag
    Message('Access Denied||Your security settings do not allow you access to this area of the program.|',SP:Description,'~lock.ico')
    Return Level:Notify
  .
  Return Level:Benign

ThisSecProc.Update  PROCEDURE()
  Code
    Free(GFQ:FieldQueue)
    BrowseSecProc('Matters - Matter Party',0)
    Return Level:Benign

BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  SELF.SelectControl = ?ContinueButton
  IF WM.Request <> ViewRecord
    SELF.InsertControl=?Insert
    SELF.ChangeControl=?Change
    SELF.DeleteControl=?Delete
  END


BRW1.SetQueueRecord PROCEDURE

  CODE
  LOC:Description = ROL:Description
  If MP:Sorter <> 1 Then LOC:Description = LOC:Description & ' (' & MP:Sorter & ')'.
  LOC:Party = GetDescription('PARTY NAME',MP:PartyID)
  
  PARENT.SetQueueRecord
  SELF.Q.LOC:Party_NormalFG = -1
  SELF.Q.LOC:Party_NormalBG = -1
  SELF.Q.LOC:Party_SelectedFG = -1
  SELF.Q.LOC:Party_SelectedBG = -1
  SELF.Q.LOC:Description_NormalFG = -1
  SELF.Q.LOC:Description_NormalBG = -1
  SELF.Q.LOC:Description_SelectedFG = -1
  SELF.Q.LOC:Description_SelectedBG = -1
      SELF.Q.LOC:Party_NormalFG   = ROL:Color1
      SELF.Q.LOC:Party_NormalBG   = -1
      SELF.Q.LOC:Party_SelectedFG = -1
      SELF.Q.LOC:Party_SelectedBG = ROL:Color1
      SELF.Q.LOC:Description_NormalFG   = ROL:Color1
      SELF.Q.LOC:Description_NormalBG   = -1
      SELF.Q.LOC:Description_SelectedFG = -1
      SELF.Q.LOC:Description_SelectedBG = ROL:Color1


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults

