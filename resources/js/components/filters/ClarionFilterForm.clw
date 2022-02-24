FilterMatters PROCEDURE                               !Generated from procedure template - Window



LOC:Counter             LONG
LOC:CheckIfInactivitySet       BYTE
SAV:FilterStagesInListFlag     BYTE
SAV:FilterStagesNotInListFlag  BYTE
LOC:StageID              LONG
LOC:StageInList          CSTRING(100)
LOC:StagesInListID       LONG
LOC:StageNotInList       CSTRING(100)
LOC:StagesNotInListID    LONG
LOC:ClientID             LONG
LOC:BranchID             LONG
LOC:DocGenID             LONG
LOC:MatterTypeID         LONG
LOC:CostCentreID         LONG
LOC:EmployeeID           LONG
LOC:CriticalStepID       LONG
LOC:TaggedEmployeeID     LONG
LOC:QueueCounter         LONG
SAV:RestrictToClientID   LONG
SAV:FilterBranchFlag     LONG
SAV:FilterDateFlag       BYTE
LOC:RecordNumber         CSTRING(10)
LOC:TempString          CSTRING(255)
SAV:LOC:FilterByStageFlag BYTE(255)

SAV:EMP2:FilterStageID  LONG
!FB1981
SAV:FilterPartyRoleFlag  LIKE(EMP2:FilterPartyRoleFlag)
SAV:FilterParty1ID       LIKE(EMP2:FilterParty1ID)
SAV:FilterRole1ID        LIKE(EMP2:FilterRole1ID)
SAV:FilterParty2ID       LIKE(EMP2:FilterParty2ID)
SAV:FilterRole2ID        LIKE(EMP2:FilterRole2ID)
SAV:FilterParty3ID       LIKE(EMP2:FilterParty3ID)
SAV:FilterRole3ID        LIKE(EMP2:FilterRole3ID)
!FB1981   END
SAV:FilterInactiveMattersFlag  BYTE(255)
SAV:FilterDocgenFlag         BYTE(255)
SAV:FilterMatterTypeFlag     BYTE(255)
SAV:RestrictToClientFlag     BYTE(255)
SAV:FilterEmployeeFlag       BYTE(255)
SAV:FilterCostCentreFlag     BYTE(255)
SAV:FilterDateOption         LIKE(EMP2:FilterDateOption)
SAV:FilterConveyancingStatusFlag   LIKE(EMP2:FilterConveyancingStatusFlag)
SAV:FilterCriticalStepsNotInListFlag    LIKE(EMP2:FilterCriticalStepsNotInListFlag )
SAV:FilterCriticalStepsInListFlag    LIKE(EMP2:FilterCriticalStepsInListFlag )
SAV:EMP2:FilterDateType LIKE(EMP2:FilterDateType)
LOC:WorkingString       like(EMP2:FilterCriticalStepsNotInList)
TMP:String       like(LOC:WorkingString)
DisplayStageNotInListSet byte
DisplayStageInListSet byte

CurrentTab           STRING(80)
LOC:FilterByStageFlag BYTE
FilesOpened          BYTE
ezField              LONG
ActionMessage        CSTRING(40)
LOC:MatterType       CSTRING(50)
LOC:Party            CSTRING(1000)
LOC:CostCentre       CSTRING(50)
LOC:Group            CSTRING(50)
LOC:Docgen           CSTRING(50)
LOC:SheriffArea      CSTRING(75)
LOC:Employee         CSTRING(30)
LOC:PartyRole        CSTRING(50)
LOC:LiveFlag         BYTE
LOC:PendingFlag      BYTE
LOC:ArchivedFlag     BYTE
LOC:Stage            CSTRING(150)
LOC:Branch           CSTRING(50)
LOC:LookupPropText   STRING(2)
LOC:StageOption      STRING(1)
LOC:ConveyancingStatus CSTRING(50)
LOC:CriticalStep     CSTRING(50)
LOC:CriticalStepNotIn CSTRING(50)
LOC:InactiveMatters  CSTRING(100)
LOC:PartyTypes       CSTRING(100)
FDB12::View:FileDrop VIEW(SheriffArea)
                       PROJECT(SHE:Description)
                       PROJECT(SHE:RecordID)
                     END
Queue:FileDrop:3     QUEUE                            !Queue declaration for browse/combo box using ?LOC:SheriffArea
SHE:Description        LIKE(SHE:Description)          !List box control field - type derived from field
SHE:RecordID           LIKE(SHE:RecordID)             !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
FDB5::View:FileDrop  VIEW(Grouping)
                       PROJECT(GRO:Description)
                       PROJECT(GRO:RecordID)
                     END
Queue:FileDrop:5     QUEUE                            !Queue declaration for browse/combo box using ?LOC:Group
GRO:Description        LIKE(GRO:Description)          !List box control field - type derived from field
GRO:RecordID           LIKE(GRO:RecordID)             !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
ThisSecProc    Class()
CheckAccess       PROCEDURE(),BYTE,PROC
Update            PROCEDURE(),BYTE,PROC
                End
QuickWindow          WINDOW('Filter Matters'),AT(,,477,304),FONT('Arial',9,,),CENTER,IMM,ICON('funnel.ico'),HLP('FilterMatters'),CENTERED,SYSTEM,GRAY,DOUBLE,MDI
                       SHEET,AT(4,4,469,271),USE(?CurrentTab),WIZARD
                         TAB('Dummy'),USE(?Tab1)
                           GROUP('General'),AT(8,8,215,158),USE(?Group2),BOXED
                             CHECK('Employee:'),AT(20,19,47,10),USE(EMP2:FilterEmployeeFlag),TIP('Display Matters that belong to a certain user?')
                             ENTRY(@s49),AT(84,19,113,10),USE(LOC:Employee),IMM,FONT('MS Sans Serif',,,),TIP('Type in the name of an Employee or use the lookup button <13,10>to Select an Employee' &|
   ' or Tag multiple Employees'),ALRT(UpKey),ALRT(DownKey)
                             BUTTON('...'),AT(204,19,10,10),USE(?LookupEmployeeButton),TIP('Lookup a list of Employees<13,10>Note: You can Tag multiple Employees to filter by a ' &|
   'number of <13,10>Employees at the same time')
                             CHECK('Matter Type:'),AT(20,35,57,10),USE(EMP2:FilterMatterTypeFlag),TIP('Display Matters of  a specific Type?')
                             ENTRY(@s49),AT(84,35,113,10),USE(LOC:MatterType),IMM,FONT('MS Sans Serif',,,),TIP('Type in the Description of a Matter Type or use the lookup button <13,10>to Select a ' &|
   'Matter Type or Tag multiple Matter Types'),ALRT(UpKey),ALRT(DownKey)
                             BUTTON('...'),AT(204,35,10,10),USE(?LookupMatterTypeButton),TIP('Lookup a list of Employees<13,10>Note: You can Tag multiple Employees to filter by a ' &|
   'number of <13,10>Employees at the same time')
                             CHECK('Document Set:'),AT(20,51),USE(EMP2:FilterDocgenFlag),TIP('Filter by document set?')
                             ENTRY(@s49),AT(84,51,113,10),USE(LOC:Docgen),IMM,FONT('MS Sans Serif',,,),TIP('Type in the Description of a Document Set or use the lookup button <13,10>to Select a' &|
   ' Document Set or Tag multiple Document Sets'),ALRT(UpKey),ALRT(DownKey)
                             BUTTON('...'),AT(204,51,10,10),USE(?LookupDocgenButton),TIP('Lookup a list of Employees<13,10>Note: You can Tag multiple Employees to filter by a ' &|
   'number of <13,10>Employees at the same time')
                             CHECK('Client:'),AT(20,67,37,10),USE(EMP2:RestrictToClientFlag),TIP('Display Matters for a specific Role?')
                             ENTRY(@s255),AT(84,67,113,10),USE(LOC:Party),IMM,FONT('MS Sans Serif',,,),TIP('Type in the Clients name to find the Client <13,10>or use the lookup button to displa' &|
   'y a complete list<13,10>Note: Use your up and down arrows to scroll through the list'),ALRT(UpKey),ALRT(DownKey)
                             BUTTON('...'),AT(204,67,10,10),USE(?LookupPartyButton),TIP('Lookup a list of Parties<13,10>Note: You can Tag multiple Parties to filter by a numb' &|
   'er of <13,10>Clients at the same time')
                             CHECK('Cost Centre:'),AT(20,83,52,10),USE(EMP2:FilterCostCentreFlag),TIP('Filter Matters by Cost Centre?')
                             ENTRY(@s49),AT(84,83,113,10),USE(LOC:CostCentre),IMM,FONT('MS Sans Serif',,,),TIP('Type in the Description of a Cost Centre or use the lookup button <13,10>to Select a ' &|
   'Cost Centre or Tag multiple Cost Centres'),ALRT(UpKey),ALRT(DownKey)
                             BUTTON('...'),AT(204,83,10,10),USE(?LookupCostCentreButton),TIP('Lookup a list of Employees<13,10>Note: You can Tag multiple Employees to filter by a ' &|
   'number of <13,10>Employees at the same time')
                             CHECK('Branch:'),AT(20,99,39,10),USE(EMP2:FilterBranchFlag),TIP('Only show Matters belonging to a certain Branch?')
                             ENTRY(@s49),AT(84,99,113,10),USE(LOC:Branch),IMM,FONT('MS Sans Serif',,,),TIP('Type in the name of a Branch or use the lookup button <13,10>to Select a Branch or Ta' &|
   'g multiple Branches'),ALRT(UpKey),ALRT(DownKey)
                             BUTTON('...'),AT(204,99,10,10),USE(?LookupBranchButton),TIP('Lookup a list of Branches<13,10>Note: You can Tag multiple Branches to filter by a nu' &|
   'mber of <13,10>Branches at the same time')
                             CHECK('Group?'),AT(20,116,43,10),USE(EMP2:FilterGroupFlag),TIP('Filter Matters by the Groups they belong to?')
                             LIST,AT(84,115,113,10),USE(LOC:Group),FONT('MS Sans Serif',,,),FORMAT('196L(2)@s49@'),DROP(15),FROM(Queue:FileDrop:5)
                             CHECK('Sheriff Area:'),AT(20,134),USE(EMP2:FilterSheriffAreaFlag),TIP('Filter by Sheriff Area?')
                             LIST,AT(84,131,113,10),USE(LOC:SheriffArea),VSCROLL,FONT('MS Sans Serif',,,),FORMAT('396L(2)@s99@'),DROP(10),FROM(Queue:FileDrop:3)
                             ENTRY(@n13),AT(152,131,11,10),USE(EMP2:FilterSheriffAreaID),HIDE,TIP('Filter by document set?')
                             BUTTON('...'),AT(204,131,10,10),USE(?LookupSheriffAreaButton),TIP('Lookup Sheriff Areas')
                             GROUP,AT(80,143,137,17),USE(?Group1)
                               CHECK('Live'),AT(84,148),USE(EMP2:FilterStatusLiveFlag)
                               CHECK('Pending'),AT(120,148),USE(EMP2:FilterStatusPendingFlag)
                               CHECK('Archived'),AT(168,148),USE(EMP2:FilterStatusArchiveFlag)
                             END
                             PROMPT('Archive Status:'),AT(20,148),USE(?Prompt4)
                           END
                           GROUP('Stages'),AT(236,72,232,82),USE(?Group3),BOXED
                             CHECK('Last Stage reached:'),AT(244,88,78,10),USE(LOC:FilterByStageFlag),TIP('Show Matters where this is their last Stage')
                             ENTRY(@s149),AT(334,88,113,10),USE(LOC:Stage),SKIP,FONT('MS Sans Serif',,,FONT:bold,CHARSET:ANSI),COLOR(COLOR:Silver),TIP('Choose a stage from the lookup button on the right'),CAP,READONLY
                             PROMPT('more than'),AT(332,100),USE(?EMP2:LastStageDays:Prompt)
                             SPIN(@n-14),AT(368,100,32,10),USE(EMP2:LastStageDays),FONT('MS Sans Serif',,,)
                             PROMPT('days ago'),AT(404,100),USE(?EMP2:LastStageDays:Suffix)
                             BUTTON('...'),AT(449,88,10,10),USE(?LookupStage),TIP('Lookup a list of Stages<13,10>Note: Tag more than one Stage to filter by a multiple S' &|
   'tages')
                             CHECK('Stage(s) reached:'),AT(244,120),USE(EMP2:FilterStagesInListFlag),TIP('Show Matters which have reached a certain Stage or Stages?<13,10>EMP:FilterStagesInLi' &|
   'stFlag')
                             ENTRY(@s49),AT(334,120,113,10),USE(LOC:StageInList),IMM,FONT('MS Sans Serif',,,),ALRT(UpKey),ALRT(DownKey)
                             BUTTON('...'),AT(452,120,10,10),USE(?LookupStageInListButton),TIP('Lookup a list of Stages<13,10>Note: Tag more than one Stage to filter by a multiple S' &|
   'tages')
                             CHECK('Stage(s) NOT reached:'),AT(244,136),USE(EMP2:FilterStagesNotInListFlag),TIP('Show Matters which have never reached a certain Stage or Stages?<13,10>EMP:FilterStag' &|
   'esNotInListFlag')
                             ENTRY(@s49),AT(334,136,113,10),USE(LOC:StageNotInList),IMM,FONT('MS Sans Serif',,,),ALRT(UpKey),ALRT(DownKey)
                             BUTTON('...'),AT(452,136,10,10),USE(?LookupStageNotInListButton),TIP('Lookup a list of Stages<13,10>Note: Tag more than one Stage to filter by a multiple S' &|
   'tages')
                           END
                           GROUP('Critical Steps'),AT(236,12,232,52),USE(?Group4),BOXED
                             CHECK('Step reached:'),AT(244,28),USE(EMP2:FilterCriticalStepsInListFlag),TIP('Filter the Matters by the Critical Steps it has reached')
                             ENTRY(@s49),AT(324,28,124,10),USE(LOC:CriticalStep),IMM,FONT('MS Sans Serif',,,),TIP('Type in the description of a Critical Step or use the lookup button <13,10>to Select ' &|
   'a Critical Step or Tag multiple Critical Steps'),ALRT(UpKey),ALRT(DownKey)
                             BUTTON('...'),AT(452,28,10,10),USE(?LookupCriticalStepButton),TIP('Lookup a list of Critical Steps<13,10>Note: You can Tag multiple Critical Steps to fi' &|
   'lter by a number of <13,10>Steps at the same time')
                             CHECK('Step NOT reached:'),AT(244,44,75,10),USE(EMP2:FilterCriticalStepsNotInListFlag),TIP('Filter the Matters by the Critical Steps it has NOT reached')
                             ENTRY(@s49),AT(324,44,124,10),USE(LOC:CriticalStepNotIn),IMM,FONT('MS Sans Serif',,,),ALRT(UpKey),ALRT(DownKey)
                             BUTTON('...'),AT(452,44,10,10),USE(?LookupCriticalStepButton:2),TIP('Lookup a list of Critical Steps<13,10>Note: You can Tag multiple Critical Steps to fi' &|
   'lter by a number of <13,10>Steps at the same time')
                           END
                           GROUP('Miscellaneous'),AT(8,166,339,104),USE(?Group5),BOXED
                             CHECK('Filter by Date'),AT(16,176),USE(EMP2:FilterDateFlag),TIP('Filter Matters by the Date Instructed?')
                             LIST,AT(104,176,75,10),USE(EMP2:FilterDateType),FONT('MS Sans Serif',,,),TIP('Filter by which Date'),DROP(7),FROM('Instructed|#I|Lodged|#L|Registered|#R|Court Date|#C|Prescription|#P|Important Date|#M|Stages|#S')
                             LIST,AT(184,176,59,10),USE(EMP2:FilterDateOption),FONT('MS Sans Serif',,,),TIP('Filter Matters by these date ranges'),DROP(5),FROM('Today|#Today|This Week|#This Week|This Month|#This Month|This Year|#This Year|Custom|#Custom')
                             BUTTON('C&ustom Date Range'),AT(249,174,73,14),USE(?CustomDateButton),TIP('Select a custom range of dates')
                             CHECK('Inactive Matters'),AT(16,191),USE(EMP2:FilterInactiveMattersFlag),TIP('Show Matters that have had no Activity for a certain period<13,10>EMP:FilterInactiveM' &|
   'attersFlag')
                             ENTRY(@s99),AT(104,191,219,10),USE(LOC:InactiveMatters),FONT('MS Sans Serif',,,)
                             BUTTON('...'),AT(328,191,10,10),USE(?LookupInactiveMattersButton),TIP('Define inactive Matters')
                             BUTTON('...'),AT(328,236,10,10),USE(?LookupPartyTypesButton),DISABLE,TIP('Define Party/Role combinations')
                             ENTRY(@s99),AT(104,236,219,10),USE(LOC:PartyTypes),DISABLE,FONT('MS Sans Serif',,,),READONLY
                             CHECK('Party Roles'),AT(16,236),USE(EMP2:FilterPartyRoleFlag),TIP('Show Matters that have specific parties in specific roles<13,10>EMP:FilterPartyTypesF' &|
   'lag')
                             CHECK('Conveyancing Status:'),AT(16,206,83,10),USE(EMP2:FilterConveyancingStatusFlag),TIP('Filter the Matters by their Conveyancing status')
                             LIST,AT(104,206,102,10),USE(EMP2:FilterConveyancingStatus),FONT('MS Sans Serif',,,),TIP('Filter the Matters by their Conveyancing status<13,10>EMP:FilterConveyancingStatus<13,10>1' &|
   ' = New Instruction; 2 = Amended Instruction<13,10>NTU = 5;Cancel to Re-assign = 7;Mes' &|
   'sages Waiting = 9'),DROP(7),FROM('New Instruction|#1|Amended Instruction|#2|NTU|#5|Cancelled to Re-Assign|#7|Messages Waiting|#9')
                             CHECK('Electronic Instructions'),AT(16,221,83,10),USE(EMP2:FilterDebtLinkFlag),TIP('Display Matters received electronically')
                             LIST,AT(104,221,102,9),USE(EMP2:FilterDebtLinkCategory),VSCROLL,FONT('MS Sans Serif',,,),TIP('Which electronically received Matters to display<13,10>EMP:FilterDebtLinkCategory'),FORMAT('76L(2)@s29@'),DROP(15),FROM('ABSA Bonds|#1|AG Bonds|#4|Cancellation Rejections|#11|Cancellation Requests|#10|DataLink|#3|FNB Cancellations|#5|FNB Transfers|#6|SBSA Bonds|#7|e4 Transfers|#8|Rates Applications|#2|WebLink|#9|REASA Transfers|#12')
                             PROMPT('C&ustom SQL Filter:'),AT(17,251),USE(?EMP2:FilterMattersBy:Prompt)
                             ENTRY(@S255),AT(104,251,219,10),USE(EMP2:FilterMattersBy),IMM,FONT('MS Sans Serif',,,),TIP('Custom string to filter matters by (e.g. ClaimAmount >= 0)<13,10>More examples:<13,10>ArchiveDate <<= DATE(12,21,2010)<13,10>Step6Completed > DATE(1,31,2011)<13,10>StageGroupID = 12 OR StageGroupID = 13<13,10>ToDoGroupID IN (SELECT RecordID FROM PlanOfAction WHERE Description = ''''Bonds'''')<13,10>EMP:FilterMattersBy'),ALRT(UpKey),ALRT(DownKey),ALRT(CtrlDown),ALRT(CtrlUp)
                             BUTTON,AT(328,251,10,10),USE(?LookupLibraryButton),SKIP,TIP('Lookup and insert text from the Lookup Library (Ctrl L)'),KEY(CtrlL),ICON('Lookup.ico')
                           END
                           CHECK('Recently Used?'),AT(363,199),USE(EMP2:FilterFavouritesFlag),HIDE,TIP('Display the Matters accessed recently')
                           BUTTON('...'),AT(427,198,11,11),USE(?FavouritesButton),HIDE,TIP('View/Manage the List of Favourite Matters')
                         END
                       END
                       BUTTON('F&inancial'),AT(8,279,61,18),USE(?FinancialButton),LEFT,TIP('Filter the Matters using Financial Indicators'),ICON('money2.ico')
                       BUTTON('&Snapshot'),AT(77,279,61,18),USE(?SetAsDefault),SKIP,LEFT,TIP('Use these Settings as a ''Default Filter''which can be activated from the Desktop ' &|
   'by ALT-F8<13,10>Note: You can also clear the filtering by pressing ALT-F9 (from the D' &|
   'esktop).'),ICON('camera.ico')
                       BUTTON('&Reset'),AT(146,279,49,18),USE(?ResetButton),HIDE,LEFT,TIP('Reset your Filter to the last one used<13,10>This is useful if your filtering was cle' &|
   'ared by the<13,10>QBE procedure'),ICON('funnel_delete.ico')
                       BUTTON('&OK'),AT(347,279,60,20),USE(?OK),LEFT,FONT(,11,,),ICON('check3.ico'),DEFAULT
                       BUTTON('&Cancel'),AT(413,279,60,20),USE(?Cancel),LEFT,FONT(,11,,),ICON('delete32.ico')
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeCompleted          PROCEDURE(),BYTE,PROC,DERIVED
TakeFieldEvent         PROCEDURE(),BYTE,PROC,DERIVED
TakeNewSelection       PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
FDB12                CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:3              !Reference to display queue
                     END

FDB5                 CLASS(FileDropClass)             !File drop manager
Q                      &Queue:FileDrop:5              !Reference to display queue
                     END


  CODE
  GlobalResponse = ThisWindow.Run()

DisplayPartyTypes ROUTINE
!FB1981
    IF ~EMP2:FilterPartyRoleFlag OR (~EMP2:FilterParty1ID AND ~EMP2:FilterRole1ID AND ~EMP2:FilterParty2ID AND ~EMP2:FilterRole2ID AND ~EMP2:FilterParty3ID AND ~EMP2:FilterRole3ID)
        LOC:PartyTypes = ''
        Display
    ELSE
        n# = 0
        IF EMP2:FilterParty1ID THEN n# += 1 .
        IF EMP2:FilterParty2ID THEN n# += 1 .
        IF EMP2:FilterParty3ID THEN n# += 1 .
        IF n# > 1
            LOC:PartyTypes = ''& n#  &' Party/Role filters set'
        ELSE
            Party# = 0
            Role# = 0
            IF EMP2:FilterParty1ID
                Party# = EMP2:FilterParty1ID
                Role# = EMP2:FilterRole1ID
            ELSIF EMP2:FilterParty2ID
                Party# = EMP2:FilterParty2ID
                Role# =EMP2:FilterRole2ID
            ELSIF EMP2:FilterParty3ID
                Party# = EMP2:FilterParty3ID
                Role# =EMP2:FilterRole3ID
            END
            IF Party# AND Role#
                PropSQLNext('Select TOP 1 0, ISNULL(Party.Name,'''') + '' AS '' + ISNULL(Role.Description,'''') FROM  Party LEFT JOIN ROle ON ROle.RecordID = '&Role#&' WHERE Party.RecordID = '& Party#)
                LOC:PartyTypes = ROW:Description
                Display
            END
        END
        
        !LOOP a# = 1 to LEN(EMP2:FilterPartyTypesList) by 1
        !    IF EMP2:FilterPartyTypesList[a#] = ','
        !        n# += 1
        !    END
        !END
        !  LOC:PartyTypes = ''& ((n# + 1)/2) &' Party/Role filters set'
    END
   !FB1981 END
ResetTheScreen      ROUTINE

    IF QuickWindow{Prop:AcceptAll} THEN EXIT.

    IF ~(SAV:RestrictToClientFlag = EMP2:RestrictToClientFlag)
        SAV:RestrictToClientFlag = EMP2:RestrictToClientFlag
        IF EMP2:RestrictToClientFlag
           ?LookupPartyButton{PROP:Disable} = False
           ?LOC:Party{PROP:Disable} = False
!           IF ~EMP2:RestrictToClientList THEN EMP2:RestrictToClientList = MAT:ClientID.
           SELECT(?LOC:Party)
           IF EMP2:RestrictToClientList
              DO DisplayClients
           END
           DISPLAY
        ELSE
           LOC:Party = ''
           DISPLAY
           EMP2:RestrictToClientList = ''
           ?LookupPartyButton{PROP:Disable} = True
           ?LOC:Party{PROP:Disable} = True
        END
    END

    ! 01 Jun 2020 PK Naidoo - FB Case 2994
    IF ~(SAV:EMP2:FilterDateType = EMP2:FilterDateType)
        SAV:EMP2:FilterDateType = EMP2:FilterDateType
    END

    IF ~(SAV:FilterBranchFlag = EMP2:FilterBranchFlag)
        SAV:FilterBranchFlag = EMP2:FilterBranchFlag
        IF EMP2:FilterBranchFlag
           ?LookupBranchButton{PROP:Disable} = False
           ?LOC:Branch{PROP:Disable} = False
           SELECT(?LOC:Branch)
           IF EMP2:RestrictToBranchList
              DO DisplayBranches
           END
           DISPLAY
        ELSE
           LOC:Branch = ''
           DISPLAY
           EMP2:RestrictToBranchList = ''
           ?LookupBranchButton{PROP:Disable} = True
           ?LOC:Branch{PROP:Disable} = True
        END
    END



    IF EMP2:FilterConveyancingStatusFlag
       ?EMP2:FilterConveyancingStatus{PROP:Disable} = False
    ELSE
       EMP2:FilterConveyancingStatus = ''
       ?EMP2:FilterConveyancingStatus{PROP:Disable} = True
    END



    IF ~(SAV:FilterCriticalStepsInListFlag = EMP2:FilterCriticalStepsInListFlag)
        SAV:FilterCriticalStepsInListFlag = EMP2:FilterCriticalStepsInListFlag
        IF EMP2:FilterCriticalStepsInListFlag
           ?LookupCriticalStepButton{PROP:Disable} = False
           ?LOC:CriticalStep{PROP:Disable} = False
           SELECT(?LOC:CriticalStep)
           IF EMP2:RestrictToCriticalStepList
              DO DisplayCriticalSteps
           END
           DISPLAY
        ELSE
           LOC:CriticalStep = ''
           DISPLAY
           EMP2:RestrictToCriticalStepList = ''
           ?LookupCriticalStepButton{PROP:Disable} = True
           ?LOC:CriticalStep{PROP:Disable} = True
        END

    END



    IF ~(SAV:FilterCriticalStepsNotInListFlag  = EMP2:FilterCriticalStepsNotInListFlag)
        SAV:FilterCriticalStepsNotInListFlag  = EMP2:FilterCriticalStepsNotInListFlag
        IF EMP2:FilterCriticalStepsNotInListFlag
           ?LookupCriticalStepButton:2{PROP:Disable} = False
           ?LOC:CriticalStepNotIn{PROP:Disable} = False
           SELECT(?LOC:CriticalStepNotIn)
           IF EMP2:FilterCriticalStepsNotInList
              DO DisplayCriticalStepsNotIn
           END
           DISPLAY
        ELSE
           LOC:CriticalStepNotIn = ''
           DISPLAY
           EMP2:FilterCriticalStepsNotInList = ''
           ?LookupCriticalStepButton:2{PROP:Disable} = True
           ?LOC:CriticalStepNotIn{PROP:Disable} = True
        END

    END


    IF ~(SAV:FilterEmployeeFlag = EMP2:FilterEmployeeFlag)

        SAV:FilterEmployeeFlag = EMP2:FilterEmployeeFlag

        IF EMP2:FilterEmployeeFlag

           ?LookupEmployeeButton{PROP:Disable} = False
           ?LOC:Employee{PROP:Disable} = False
!           IF ~EMP2:RestrictToEmployeeList THEN EMP2:RestrictToEmployeeList = CEM:RecordID.
           SELECT(?LOC:Employee)
           IF EMP2:RestrictToEmployeeList
              DO DisplayEmployees
           END
           DISPLAY

        ELSE

           LOC:Employee = ''
           DISPLAY
           EMP2:RestrictToEmployeeList = ''
           ?LookupEmployeeButton{PROP:Disable} = True
           ?LOC:Employee{PROP:Disable} = True

        END

    END


    IF ~(SAV:FilterDocGenFlag = EMP2:FilterDocGenFlag)

        SAV:FilterDocGenFlag = EMP2:FilterDocGenFlag

        IF EMP2:FilterDocGenFlag

           ?LookupDocGenButton{PROP:Disable} = False
           ?LOC:DocGen{PROP:Disable} = False
! rick::           IF ~EMP2:RestrictToDocGenList AND MAT:DocGenID THEN EMP2:RestrictToDocGenList = MAT:DocGenID.
           SELECT(?LOC:DocGen)
           IF EMP2:RestrictToDocGenList
              DO DisplayDocGens
           END
           DISPLAY

        ELSE

           LOC:DocGen = ''
           DISPLAY
           EMP2:RestrictToDocGenList = ''
           ?LookupDocGenButton{PROP:Disable} = True
           ?LOC:DocGen{PROP:Disable} = True

        END

    END


    IF ~(SAV:FilterInactiveMattersFlag = EMP2:FilterInactiveMattersFlag)
        SAV:FilterInactiveMattersFlag = EMP2:FilterInactiveMattersFlag

        IF EMP2:FilterInactiveMattersFlag

           DO DisplayInactiveMatters

           ENABLE(?LOC:InactiveMatters)
           ENABLE(?LookupInactiveMattersButton)
        ELSE

           LOC:InactiveMatters = ''
           EMP2:FilterInactiveDays = 30
           EMP2:FilterInactiveFileNotesFlag = 0
           EMP2:FilterFileNotesOption = 'A'
           EMP2:FilterInactiveFeeNotesFlag = 0
           EMP2:FilterInactiveToDoNotesFlag = 0
           EMP2:FilterInactiveColDebitFlag = 0
           EMP2:FilterInactiveMatTranFlag = 0

           DISABLE(?LOC:InactiveMatters)
           DISABLE(?LookupInactiveMattersButton)
           DISPLAY
        END
    END
     !FB1981
    IF ~(SAV:FilterPartyRoleFlag = EMP2:FilterPartyRoleFlag)
        SAV:FilterPartyRoleFlag = EMP2:FilterPartyRoleFlag
        IF EMP2:FilterPartyRoleFlag
           DO DisplayPartyTypes
           ENABLE(?LOC:PartyTypes)
           ENABLE(?LookupPartyTypesButton)
        ELSE
           EMP2:FilterParty1ID = 0
           EMP2:FilterRole1ID = 0
           EMP2:FilterParty2ID = 0
           EMP2:FilterRole2ID = 0
           EMP2:FilterParty3ID = 0
           EMP2:FilterRole3ID = 0
           LOC:PartyTypes = ''
           DISABLE(?LOC:PartyTypes)
           DISABLE(?LookupPartyTypesButton)
           DISPLAY
        END
    END
    !FB1981 END
    IF ~(SAV:FilterMatterTypeFlag = EMP2:FilterMatterTypeFlag)

        SAV:FilterMatterTypeFlag = EMP2:FilterMatterTypeFlag

        IF EMP2:FilterMatterTypeFlag

           ?LookupMatterTypeButton{PROP:Disable} = False
           ?LOC:MatterType{PROP:Disable} = False
!           IF ~EMP2:RestrictToMatterTypeList AND MAT:MatterTypeID THEN EMP2:RestrictToMatterTypeList = MAT:MatterTypeID.
           SELECT(?LOC:MatterType)
           IF EMP2:RestrictToMatterTypeList
              DO DisplayMatterTypes
           END
           DISPLAY

        ELSE

           LOC:MatterType = ''
           DISPLAY
           EMP2:RestrictToMatterTypeList = ''
           ?LookupMatterTypeButton{PROP:Disable} = True
           ?LOC:MatterType{PROP:Disable} = True

        END

    END

    IF ~(SAV:FilterCostCentreFlag = EMP2:FilterCostCentreFlag)

        SAV:FilterCostCentreFlag = EMP2:FilterCostCentreFlag

        IF EMP2:FilterCostCentreFlag

           ?LookupCostCentreButton{PROP:Disable} = False
           ?LOC:CostCentre{PROP:Disable} = False
!           IF ~EMP2:RestrictToCostCentreList AND MAT:CostCentreID THEN EMP2:RestrictToCostCentreList = MAT:CostCentreID.
           SELECT(?LOC:CostCentre)
           IF EMP2:RestrictToCostCentreList
              DO DisplayCostCentres
           END
           DISPLAY

        ELSE

           LOC:CostCentre = ''
           DISPLAY
           EMP2:RestrictToCostCentreList = ''
           ?LookupCostCentreButton{PROP:Disable} = True
           ?LOC:CostCentre{PROP:Disable} = True

        END

    END




    IF EMP2:FilterDebtLinkFlag
       ?EMP2:FilterDebtLinkCategory{PROP:Disable} = False
    ELSE
       EMP2:FilterDebtLinkCategory = ''
       ?EMP2:FilterDebtLinkCategory{PROP:Disable} = True
    END


   IF ~(SAV:FilterDateOption = EMP2:FilterDateOption)
        SAV:FilterDateOption = EMP2:FilterDateOption
        IF EMP2:FilterDateOption = 'Today'
            EMP2:FilterToDate = GLO:TodaysDate
            EMP2:FilterFromDate = GLO:TodaysDate

        ELSIF EMP2:FilterDateOption = 'This Week'
            IF GLO:TodaysDate%7 = 0  ! IF SUNDAY
               EMP2:FilterFromDate = GLO:TodaysDate - 6
            ELSE
               EMP2:FilterFromDate = GLO:TodaysDate - GLO:TodaysDate%7 + 1
            END
            EMP2:FilterToDate = EMP2:FilterFromDate + 6

        ELSIF EMP2:FilterDateOption = 'This Month'
             EMP2:FilterFromDate = DATE(MONTH(GLO:TodaysDate),1,YEAR(GLO:TodaysDate))
             IF MONTH(GLO:TodaysDate) = 12
                EMP2:FilterToDate = DATE(12,31,YEAR(GLO:TodaysDate))
             ELSE
                EMP2:FilterToDate = DATE(MONTH(GLO:TodaysDate)+1,1,YEAR(GLO:TodaysDate))-1
             END
        ELSIF EMP2:FilterDateOption = 'This Year'
             EMP2:FilterFromDate = DATE(1,1,YEAR(GLO:TodaysDate))
             EMP2:FilterToDate = DATE(12,31,YEAR(GLO:TodaysDate))
        ELSIF EMP2:FilterDateOption = 'Custom'
             IF ~EMP2:FilterToDate THEN EMP2:FilterToDate = GLO:TodaysDate.
             IF ~EMP2:FilterFromDate THEN EMP2:FilterFromDate = GLO:TodaysDate.
        END

        IF EMP2:FilterFromDate AND EMP2:FiltertoDate
           ?CustomDateButton{PROP:Tooltip} = 'Specify a Date Range<13,10>Current range: ' & FORMAT(EMP2:FilterFromDate,@D17) & ' to ' & FORMAT(EMP2:FilterToDate,@D17)
        ELSE
           ?CustomDateButton{PROP:Tooltip} = 'Specify a user-defined range of dates'
        END

    END


    IF ~(SAV:LOC:FilterByStageFlag = LOC:FilterByStageFlag)
        SAV:LOC:FilterByStageFlag = LOC:FilterByStageFlag

        IF LOC:FilterByStageFlag

           EMP2:FilterStagesInListFlag = False
           EMP2:FilterStagesNotInListFlag = False

           ?LookupStage{PROP:Disable} = False

           IF ~EMP2:FilterStageID
              CLEAR(ROW:Record)
              RowCounter{PROP:SQL} = 'Select TOP 1 StageID FROM FileNote where MatterID in (SELECT MatterID FROM Favourites WHERE EmployeeID = ' & GLO:EmployeeID & ') AND StageID > 0 ORDER BY RecordID desc'
              NEXT(RowCounter)
              IF ROW:Counter
                 EMP2:FilterStageID = ROW:Counter
                 LOC:Stage = GetDescription('Stage',EMP2:FilterStageID)
              END
           END


        ELSE
           LOC:Stage = ''
           DISPLAY
           EMP2:FilterStageID = 0
           ?LookupStage{PROP:Disable} = True


        END

    END

    IF EMP2:FilterStageID OR LOC:FilterByStageFlag OR EMP2:FilterStagesInListFlag OR EMP2:FilterStagesNotInListFlag

        ?EMP2:FilterDateType{PROP:From} = 'Instructed|#I|Lodged|#L|Registered|#R|Prescription|#P|Important Date|#M|Stages|#S'

    ELSE

        IF EMP2:FilterDateType = 'S'  ! DATE DROP DOWN CLEARED JUST BELOW THIS
           EMP2:FilterDateType = ''
           EMP2:FilterDateFlag = 0
        END
        ?EMP2:FilterDateType{PROP:From} = 'Instructed|#I|Lodged|#L|Registered|#R|Prescription|#P|Important Date|#M'

    END

    EMP2:FilterDateType = SAV:EMP2:FilterDateType
    
    ! DATE DROP DOWN CLEARED


    IF ~(SAV:FilterDateFlag = EMP2:FilterDateFlag)
         SAV:FilterDateFlag = EMP2:FilterDateFlag
         IF EMP2:FilterDateFlag

            EMP2:FilterDateType{PROP:Selected} = 1
            EMP2:FilterDateOption{PROP:Selected} = 1
            EMP2:FilterDateType = 'Instructed'
            EMP2:FilterDateOption = 'Today'

            EMP2:FilterToDate = GLO:TodaysDate
            EMP2:FilterFromDate = GLO:TodaysDate

            ?EMP2:FilterDateType{PROP:Disable} = False
            ?EMP2:FilterDateOption{PROP:Disable} = False
            ?CustomDateButton{PROP:Disable} = False

            IF EMP2:FilterFromDate AND EMP2:FiltertoDate
               ?CustomDateButton{PROP:Tooltip} = 'Specify a Date Range<13,10>Current range: ' & FORMAT(EMP2:FilterFromDate,@D17) & ' to ' & FORMAT(EMP2:FilterToDate,@D17)
            ELSE
               ?CustomDateButton{PROP:Tooltip} = 'Specify a user-defined range of dates'
            END

        ELSE

            EMP2:FilterDateType{PROP:Selected} = 0
            EMP2:FilterDateOption{PROP:Selected} = 0
            EMP2:FilterDateType = ''
            EMP2:FilterDateOption = ''
            EMP2:FilterToDate = 0
            EMP2:FilterFromDate = 0
            DISPLAY
            ?EMP2:FilterDateType{PROP:Disable} = True
            ?EMP2:FilterDateOption{PROP:Disable} = True
            ?CustomDateButton{PROP:Disable} = True

         END
    END


  


    IF EMP2:FilterGroupFlag
       ?LOC:Group{PROP:Disable} = False
    ELSE
       LOC:Group = ''
       DISPLAY
       EMP2:FilterGroupID = 0
       ?LOC:Group{PROP:Disable} = True
    END




  IF ~(SAV:FilterStagesInListFlag = EMP2:FilterStagesInListFlag)
      SAV:FilterStagesInListFlag = EMP2:FilterStagesInListFlag

      IF EMP2:FilterStagesInListFlag = 1

!           LOC:FilterByStageFlag = False
!           EMP2:FilterStagesNotInListFlag = False
         ! 04 Mar 2021 PK Naidoo - FB Case 2957
         !IF EMP2:FilterStagesInList
         !   DO DisplayStageInList
         !END

         ?LookupStageInListButton{PROP:Disable} = False

      ELSE

         PROPSQL('DELETE FilterStages WHERE EmployeeID = ' & CEM:RecordID)
         PROPSQL('DELETE TaggedStage WHERE EmployeeID = ' & CEM:RecordID)

         ! 04 Mar 2021 PK Naidoo - FB Case 2957
         LOC:StageInList = ''
         !DISPLAY
         !EMP2:FilterStagesInList = ''

         ?LookupStageInListButton{PROP:Disable} = True

      END

   END

  IF ~(SAV:FilterStagesNotInListFlag = EMP2:FilterStagesNotInListFlag)
      SAV:FilterStagesNotInListFlag = EMP2:FilterStagesNotInListFlag

      IF EMP2:FilterStagesNotInListFlag = 1

 !          LOC:FilterByStageFlag = False
 !          EMP2:FilterStagesInListFlag = False


         ?LookupStageNotInListButton{PROP:Disable} = False
         ! 04 Mar 2021 PK Naidoo - FB Case 2957
         !IF EMP2:FilterStagesNotInList
         !   DO DisplayStageNotInList
         !END

         !DISPLAY
         

      ELSE

         PROPSQL('DELETE FilterNonStages WHERE EmployeeID = ' & CEM:RecordID)
         PROPSQL('DELETE TaggedStage WHERE EmployeeID = ' & CEM:RecordID)

         ! 04 Mar 2021 PK Naidoo - FB Case 2957
         LOC:StageNotInList = ''
         !DISPLAY
         !EMP2:FilterStagesNotInList = ''
         ?LookupStageNotInListButton{PROP:Disable} = True

      END

   END

  
    IF EMP2:FilterSheriffAreaFlag
       ?LOC:SheriffArea{PROP:Disable} = False
       ?LookupSheriffAreaButton{PROP:Disable} = False
       IF ~EMP2:FilterSheriffAreaID
           FDB12.ResetQueue(1)
       END
    ELSE
       LOC:SheriffArea = ''
       DISPLAY
       EMP2:FilterSheriffAreaID = 0
       ?LOC:SheriffArea{PROP:Disable} = True
       ?LookupSheriffAreaButton{PROP:Disable} = True
    END
  
  

    If EMP2:FilterBalances OR EMP2:FilterAging OR EMP2:FilterLastInvoiceDate
       ?FinancialButton{PROP:Icon} = '~bok.ico'
    Else
       ?FinancialButton{PROP:Icon} = '~smmoney.ico'
    .
    DISPLAY


DisplayInactiveMatters      ROUTINE


  LOC:InactiveMatters = ''
  LOC:CheckIfInactivitySet = EMP2:FilterInactiveFileNotesFlag + EMP2:FilterInactiveFeeNotesFlag + EMP2:FilterInactiveToDoNotesFlag + EMP2:FilterInactiveColDebitFlag + EMP2:FilterInactiveMatTranFlag
  IF ~LOC:CheckIfInactivitySet
      LOC:InactiveMatters = 'Define Inactive Matters ...'
  ELSE
      IF EMP2:FilterInactiveFileNotesFlag
         CASE EMP2:FilterFileNotesOption
         OF 'I'
           LOC:InactiveMatters = 'No Internal File Notes'
         OF 'A'
           LOC:InactiveMatters = 'No External File Notes'
         ELSE
           LOC:InactiveMatters = 'No File Notes'
         END
      END
      IF EMP2:FilterInactiveFeeNotesFlag
         IF LOC:InactiveMatters
            LOC:InactiveMatters = LOC:InactiveMatters & '; No Fee Notes'
         ELSE
            LOC:InactiveMatters = 'No Fee Notes'
         END
      END
      IF EMP2:FilterInactiveToDoNotesFlag
         IF LOC:InactiveMatters
            LOC:InactiveMatters = LOC:InactiveMatters & '; No Reminders'
         ELSE
            LOC:InactiveMatters = 'No Reminders'
         END
      END
      IF EMP2:FilterInactiveColDebitFlag
         IF LOC:InactiveMatters
            LOC:InactiveMatters = LOC:InactiveMatters & '; No Debtor Transactions'
         ELSE
            LOC:InactiveMatters = 'No Debtor Transactions'
         END
      END
      IF EMP2:FilterInactiveMatTranFlag
         IF LOC:InactiveMatters
            LOC:InactiveMatters = LOC:InactiveMatters & '; No Accounting Transactions'
         ELSE
            LOC:InactiveMatters = 'No Accounting Transactions'
         END
      END
      LOC:InactiveMatters = LOC:InactiveMatters & ' for ' & CLIP(LEFT(FORMAT(EMP2:FilterInactiveDays,@N_5))) & ' days'
  END


DisplayClients      ROUTINE

     LOC:Counter = 0
     LOC:RecordNumber = ''
     NewTag:PtrM(TAG:PartyAlias)

     IF INSTRING(',',EMP2:RestrictToClientList,1)
  
        LOOP X# = 1 TO LEN(EMP2:RestrictToClientList)
  
             IF EMP2:RestrictToClientList[X#] = ',' 
                SetTag:PtrM(TAG:PartyAlias,LOC:RecordNumber)
                LOC:RecordNumber = ''
                LOC:Counter += 1
             ELSIF X# = LEN(EMP2:RestrictToClientList)
                LOC:RecordNumber = LOC:RecordNumber & EMP2:RestrictToClientList[X#]
                SetTag:PtrM(TAG:PartyAlias,LOC:RecordNumber)
                LOC:RecordNumber = ''
                LOC:Counter += 1
             ELSE
                LOC:RecordNumber = LOC:RecordNumber & EMP2:RestrictToClientList[X#]
             END
  
        END
  
        LOC:Party = 'Selected Clients (' & CLIP(LEFT(FORMAT(LOC:Counter,@N_5))) & ')'
  
     ELSE

        IF NUMERIC(EMP2:RestrictToClientList)

           LOC:Party = GetDescription('PARTY',EMP2:RestrictToClientList)

           SetTag:PtrM(TAG:PartyAlias,EMP2:RestrictToClientList)

        ELSE

           LOC:Party = ''

        END
  
     END


DisplayBranches      ROUTINE

     LOC:Counter = 0
     LOC:RecordNumber = ''
     NewTag:PtrM(TAG:Branch)

     IF INSTRING(',',EMP2:RestrictToBranchList,1)
  
        LOOP X# = 1 TO LEN(EMP2:RestrictToBranchList)
  
             IF EMP2:RestrictToBranchList[X#] = ',' 
                SetTag:PtrM(TAG:Branch,LOC:RecordNumber)
                LOC:RecordNumber = ''
                LOC:Counter += 1
             ELSIF X# = LEN(EMP2:RestrictToBranchList)
                LOC:RecordNumber = LOC:RecordNumber & EMP2:RestrictToBranchList[X#]
                SetTag:PtrM(TAG:Branch,LOC:RecordNumber)
                LOC:RecordNumber = ''
                LOC:Counter += 1
             ELSE
                LOC:RecordNumber = LOC:RecordNumber & EMP2:RestrictToBranchList[X#]
             END
  
        END
  
        LOC:Branch = 'Selected Branches (' & CLIP(LEFT(FORMAT(LOC:Counter,@N_5))) & ')'
  
     ELSE

        IF NUMERIC(EMP2:RestrictToBranchList)

           LOC:Branch = GetDescription('Branch',EMP2:RestrictToBranchList)

           SetTag:PtrM(TAG:Branch,EMP2:RestrictToBranchList)

        ELSE

           LOC:Branch = ''

        END
  
     END



DisplayCriticalSteps      ROUTINE

     LOC:Counter = 0
     LOC:RecordNumber = ''
     NewTag:PtrM(TAG:CriticalStep)

     IF INSTRING(',',EMP2:RestrictToCriticalStepList,1)
  
        LOOP X# = 1 TO LEN(EMP2:RestrictToCriticalStepList)
  
             IF EMP2:RestrictToCriticalStepList[X#] = ',' 
                SetTag:PtrM(TAG:CriticalStep,LOC:RecordNumber)
                LOC:RecordNumber = ''
                LOC:Counter += 1
             ELSIF X# = LEN(EMP2:RestrictToCriticalStepList)
                LOC:RecordNumber = LOC:RecordNumber & EMP2:RestrictToCriticalStepList[X#]
                SetTag:PtrM(TAG:CriticalStep,LOC:RecordNumber)
                LOC:RecordNumber = ''
                LOC:Counter += 1
             ELSE
                LOC:RecordNumber = LOC:RecordNumber & EMP2:RestrictToCriticalStepList[X#]
             END
  
        END
  
        LOC:CriticalStep = 'Selected Critical Steps (' & CLIP(LEFT(FORMAT(LOC:Counter,@N_5))) & ')'
  
     ELSE

        IF NUMERIC(EMP2:RestrictToCriticalStepList)

           LOC:CriticalStep = GetDescription('CriticalStep',EMP2:RestrictToCriticalStepList)

           SetTag:PtrM(TAG:CriticalStep,EMP2:RestrictToCriticalStepList)

        ELSE

           LOC:CriticalStep = ''

        END
  
     END



DisplayCriticalStepsNotIn      ROUTINE

     LOC:Counter = 0
     LOC:RecordNumber = ''
     NewTag:PtrM(TAG:CriticalStep)

     IF INSTRING(',',EMP2:FilterCriticalStepsNotInList,1)
  
        LOOP X# = 1 TO LEN(EMP2:FilterCriticalStepsNotInList)
  
             IF EMP2:FilterCriticalStepsNotInList[X#] = ',' 
                SetTag:PtrM(TAG:CriticalStep,LOC:RecordNumber)
                LOC:RecordNumber = ''
                LOC:Counter += 1
             ELSIF X# = LEN(EMP2:FilterCriticalStepsNotInList)
                LOC:RecordNumber = LOC:RecordNumber & EMP2:FilterCriticalStepsNotInList[X#]
                SetTag:PtrM(TAG:CriticalStep,LOC:RecordNumber)
                LOC:RecordNumber = ''
                LOC:Counter += 1
             ELSE
                LOC:RecordNumber = LOC:RecordNumber & EMP2:FilterCriticalStepsNotInList[X#]
             END
  
        END
  
        LOC:CriticalStepNotIn = 'Selected Critical Steps (' & CLIP(LEFT(FORMAT(LOC:Counter,@N_5))) & ')'
  
     ELSE

        IF NUMERIC(EMP2:FilterCriticalStepsNotInList)

           LOC:CriticalStepNotIn = GetDescription('CriticalStep',EMP2:FilterCriticalStepsNotInList)

           SetTag:PtrM(TAG:CriticalStep,EMP2:FilterCriticalStepsNotInList)

        ELSE

           LOC:CriticalStepNotIn = ''

        END
  
     END


DisplayEmployees      ROUTINE

     LOC:Counter = 0
     LOC:RecordNumber = ''

     NewTag:PtrM(TAG:Employee)

     IF INSTRING(',',EMP2:RestrictToEmployeeList,1)
  
        LOOP X# = 1 TO LEN(EMP2:RestrictToEmployeeList)
  
             IF EMP2:RestrictToEmployeeList[X#] = ',' 

                SetTag:PtrM(TAG:Employee,LOC:RecordNumber)
                LOC:RecordNumber = ''
                LOC:Counter += 1


             ELSIF X# = LEN(EMP2:RestrictToEmployeeList)

                LOC:RecordNumber = LOC:RecordNumber & EMP2:RestrictToEmployeeList[X#]

                SetTag:PtrM(TAG:Employee,LOC:RecordNumber)
                LOC:RecordNumber = ''
                LOC:Counter += 1

             ELSE
                LOC:RecordNumber = LOC:RecordNumber & EMP2:RestrictToEmployeeList[X#]
             END
  
        END
  
        LOC:Employee = 'Selected Employees (' & CLIP(LEFT(FORMAT(LOC:Counter,@N_5))) & ')'
  
     ELSE

        IF NUMERIC(EMP2:RestrictToEmployeeList)

           LOC:Employee = GetDescription('Employee',EMP2:RestrictToEmployeeList)

           SetTag:PtrM(TAG:Employee,EMP2:RestrictToEmployeeList)

        ELSE

           LOC:Employee = ''

        END
  
     END


DisplayDocGens      ROUTINE

     LOC:Counter = 0
     LOC:RecordNumber = ''
     NewTag:PtrM(TAG:DocGen)

     IF INSTRING(',',EMP2:RestrictToDocGenList,1)
  
        LOOP X# = 1 TO LEN(EMP2:RestrictToDocGenList)
  
             IF EMP2:RestrictToDocGenList[X#] = ',' 

                SetTag:PtrM(TAG:DocGen,LOC:RecordNumber)
                LOC:RecordNumber = ''
                LOC:Counter += 1


             ELSIF X# = LEN(EMP2:RestrictToDocGenList)

                LOC:RecordNumber = LOC:RecordNumber & EMP2:RestrictToDocGenList[X#]

                SetTag:PtrM(TAG:DocGen,LOC:RecordNumber)
                LOC:RecordNumber = ''
                LOC:Counter += 1

             ELSE
                LOC:RecordNumber = LOC:RecordNumber & EMP2:RestrictToDocGenList[X#]
             END
  
        END
  
        LOC:DocGen = 'Selected Document Sets (' & CLIP(LEFT(FORMAT(LOC:Counter,@N_5))) & ')'
  
     ELSE

        IF NUMERIC(EMP2:RestrictToDocGenList)

           LOC:DocGen = GetDescription('DocGen',EMP2:RestrictToDocGenList)

           SetTag:PtrM(TAG:DocGen,EMP2:RestrictToDocGenList)

        ELSE

           LOC:DocGen = ''

        END
  
     END

DisplayMatterTypes      ROUTINE

     LOC:Counter = 0
     LOC:RecordNumber = ''
     NewTag:PtrM(TAG:MatterType)

     IF INSTRING(',',EMP2:RestrictToMatterTypeList,1)
  
        LOOP X# = 1 TO LEN(EMP2:RestrictToMatterTypeList)
  
             IF EMP2:RestrictToMatterTypeList[X#] = ',' 

                SetTag:PtrM(TAG:MatterType,LOC:RecordNumber)
                LOC:RecordNumber = ''
                LOC:Counter += 1


             ELSIF X# = LEN(EMP2:RestrictToMatterTypeList)

                LOC:RecordNumber = LOC:RecordNumber & EMP2:RestrictToMatterTypeList[X#]

                SetTag:PtrM(TAG:MatterType,LOC:RecordNumber)
                LOC:RecordNumber = ''
                LOC:Counter += 1

             ELSE
                LOC:RecordNumber = LOC:RecordNumber & EMP2:RestrictToMatterTypeList[X#]
             END
  
        END
  
        LOC:MatterType = 'Selected Matter Types (' & CLIP(LEFT(FORMAT(LOC:Counter,@N_5))) & ')'
  
     ELSE

        IF NUMERIC(EMP2:RestrictToMatterTypeList)

           LOC:MatterType = GetDescription('MatterType',EMP2:RestrictToMatterTypeList)

           SetTag:PtrM(TAG:MatterType,EMP2:RestrictToMatterTypeList)

        ELSE

           LOC:MatterType = ''

        END
  
     END

DisplayCostCentres      ROUTINE

     LOC:Counter = 0
     LOC:RecordNumber = ''
     NewTag:PtrM(TAG:CostCentre)

     IF INSTRING(',',EMP2:RestrictToCostCentreList,1)
  
        LOOP X# = 1 TO LEN(EMP2:RestrictToCostCentreList)
  
             IF EMP2:RestrictToCostCentreList[X#] = ',' 

                SetTag:PtrM(TAG:CostCentre,LOC:RecordNumber)
                LOC:RecordNumber = ''
                LOC:Counter += 1


             ELSIF X# = LEN(EMP2:RestrictToCostCentreList)

                LOC:RecordNumber = LOC:RecordNumber & EMP2:RestrictToCostCentreList[X#]

                SetTag:PtrM(TAG:CostCentre,LOC:RecordNumber)
                LOC:RecordNumber = ''
                LOC:Counter += 1

             ELSE
                LOC:RecordNumber = LOC:RecordNumber & EMP2:RestrictToCostCentreList[X#]
             END
  
        END
  
        LOC:CostCentre = 'Selected Cost Centres (' & CLIP(LEFT(FORMAT(LOC:Counter,@N_5))) & ')'
  
     ELSE

        IF NUMERIC(EMP2:RestrictToCostCentreList)

           LOC:CostCentre = GetDescription('CostCentre',EMP2:RestrictToCostCentreList)

           SetTag:PtrM(TAG:CostCentre,EMP2:RestrictToCostCentreList)

        ELSE

           LOC:CostCentre = ''

        END
  
     END


ResetStageInList  ROUTINE

      
               PROPSQL('DELETE TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
               PROPSQL('INSERT TaggedStage SELECT * FROM FilterStages WHERE EmployeeID = ' & CEM:RecordID)

ResetStageNotInList  ROUTINE

      
               PROPSQL('DELETE TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
               PROPSQL('INSERT TaggedStage SELECT * FROM FilterNonStages WHERE EmployeeID = ' & CEM:RecordID)



DisplayStageInList  ROUTINE
               PROPSQLNext('SELECT COUNT(1) FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
               IF ROW:Counter = 1
                  PROPSQLNext('SELECT StageID FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
                  STA:RecordID = ROW:Counter
                  IF ~Access:Stage.TryFetch(STA:PrimaryKey)
                      LOC:StageInList = STA:Description
                  END
               ELSIF ROW:Counter > 1
                  PROPSQLNext('SELECT COUNT(1) FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
                  LOC:StageInList = 'Selected Stages (' & CLIP(LEFT(FORMAT(ROW:Counter,@N_5))) & ')'
               END
      
               PROPSQL('DELETE FilterStages WHERE EmployeeID = ' & CEM:RecordID)
               PROPSQL('INSERT FilterStages SELECT * FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
      
               DISPLAY

!               if DisplayStageInListSet
!                    DisplayStageInListSet = 0
!                    !Do DisplayStageInList_2957
!               ELSE
!                    EMP2:FilterStagesNotInList=''
!                   PROPSQLNext('SELECT COUNT(1) FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
!                   IF ROW:Counter = 1
!                      PROPSQLNext('SELECT StageID FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
!                      STA:RecordID = ROW:Counter
!                      IF ~Access:Stage.TryFetch(STA:PrimaryKey)
!                          EMP2:FilterStagesNotInList = ROW:Counter
!                          LOC:StageInList = STA:Description
!                      END
!                   ELSIF ROW:Counter > 1
!                      PROPSQLNext('SELECT COUNT(1) FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
!                      LOC:StageInList = 'Selected Stages (' & CLIP(LEFT(FORMAT(ROW:Counter,@N_5))) & ')'
!                      PROPSQL('SELECT StageID FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
!                      LOOP
!                        NEXT(RowCounter)
!                        IF ERROR() THEN BREAK.
!                        IF ~EMP2:FilterStagesNotInList
!                            EMP2:FilterStagesNotInList = ROW:Counter
!                        ELSE
!                            EMP2:FilterStagesNotInList = EMP2:FilterStagesNotInList&','&ROW:Counter
!                        END
!                      END
!                   END
!          
!                   PROPSQL('DELETE FilterStages WHERE EmployeeID = ' & CEM:RecordID)
!                   PROPSQL('INSERT FilterStages SELECT * FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
!               END
!               DISPLAY

DisplayStageNotInList  ROUTINE
                PROPSQLNext('SELECT COUNT(1) AS ID FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)

               IF ROW:Counter = 1
                  PROPSQLNext('SELECT StageID FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)

                  STA:RecordID = ROW:Counter
                  IF ~Access:Stage.Fetch(STA:PrimaryKey)
                      LOC:StageNotInList = STA:Description
                  END
               ELSIF ROW:Counter > 1
                  PROPSQLNext('SELECT COUNT(1) FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
                  LOC:StageNotInList = 'Selected Stages (' & CLIP(LEFT(FORMAT(ROW:Counter,@N_5))) & ')'
               END
      
               PROPSQL('DELETE FilterNonStages WHERE EmployeeID = ' & CEM:RecordID)
               PROPSQL('INSERT FilterNonStages SELECT * FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
      
               DISPLAY
!               if DisplayStageNotInListSet
!                    DisplayStageNotInListSet = 0
!                    !Do DisplayStageNotInList_2957
!               ELSE
!                   EMP2:FilterStagesInList=''
!                   PROPSQLNext('SELECT COUNT(1) AS ID FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
!
!                   IF ROW:Counter = 1
!                      PROPSQLNext('SELECT StageID FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
!
!                      STA:RecordID = ROW:Counter
!                      IF ~Access:Stage.Fetch(STA:PrimaryKey)
!                          LOC:StageNotInList = STA:Description
!                          EMP2:FilterStagesInList = ROW:Counter
!                      END
!                   ELSIF ROW:Counter > 1
!                      PROPSQLNext('SELECT COUNT(1) FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
!                      LOC:StageNotInList = 'Selected Stages (' & CLIP(LEFT(FORMAT(ROW:Counter,@N_5))) & ')'
!                      PROPSQL('SELECT StageID FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
!                      LOOP
!                        NEXT(RowCounter)
!                        IF ERROR() THEN BREAK.
!                        IF ~EMP2:FilterStagesInList
!                            EMP2:FilterStagesInList = ROW:Counter
!                        ELSE
!                            EMP2:FilterStagesInList = EMP2:FilterStagesInList&','&ROW:Counter
!                        END
!                      END
!                   END
!          
!                   PROPSQL('DELETE FilterNonStages WHERE EmployeeID = ' & CEM:RecordID)
!                   PROPSQL('INSERT FilterNonStages SELECT * FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
!               END
!               DISPLAY

DisplayStageNotInList_2957      ROUTINE
! 04 Mar 2021 PK Naidoo - FB Case 2957

     LOC:Counter = 0

     PROPSQL('DELETE FilterNonStages WHERE EmployeeID = ' & CEM:RecordID)

     IF INSTRING(',',EMP2:FilterStagesNotInList,1)

        !FB 3505
        TMP:String = EMP2:FilterStagesNotInList
        LOOP
            
            a# = Instring(',',TMP:String)
            if ~a#
                a# = LEN(TMP:String)+1
            end
            LOC:WorkingString = Left(TMP:String,a#-1)
            Stop('x'+LOC:WorkingString)
            IF NUMERIC(LOC:WorkingString)
                 LOC:Counter +=1
                 Stop('z'+LOC:WorkingString)
                 PROPSQL('INSERT INTO FilterNonStages VALUES(' & CEM:RecordID & ', ' & LOC:WorkingString & ')')
            END
            If a# > Len(TMP:String) Then Break.
            TMP:String = Sub(TMP:String,a#+1,255)
            
!            LOC:WorkingString = SUB(EMP2:FilterStagesNotInList,A#,X#)
!              Stop('z'+LOC:WorkingString)
!            IF NUMERIC(LOC:WorkingString)
!                 LOC:Counter +=1
!                 Stop('z'+LOC:WorkingString)
!                 PROPSQL('INSERT INTO FilterNonStages VALUES(' & CEM:RecordID & ', ' & LOC:WorkingString & ')')
!            END
!             A# = X#+1
!             X# = INSTRING(',',EMP2:FilterStagesNotInList,1,A#)


        END
!        LOOP X# = 1 TO LEN(EMP2:FilterStagesNotInList)
!  
!             IF EMP2:FilterStagesNotInList[X#] = ','
!
!                LOC:Counter += 1
!             ELSIF X# = LEN(EMP2:FilterStagesNotInList)
!
!                LOC:Counter += 1
!
!                PROPSQL('INSERT INTO FilterNonStages VALUES(' & CEM:RecordID & ', ' & EMP2:FilterStagesNotInList & ')')
!
!             END
!  
!        END
!FB 3505 END
        LOC:StageNotInList = 'Selected Stages (' & CLIP(LEFT(FORMAT(LOC:Counter,@N_5))) & ')'
  
     ELSE

        IF NUMERIC(EMP2:FilterStagesNotInList)

           STA:RecordID = EMP2:FilterStagesNotInList
           IF ~Access:Stage.Fetch(STA:PrimaryKey)
               LOC:StageNotInList = STA:Description

               PROPSQL('INSERT INTO FilterNonStages VALUES(' & CEM:RecordID & ', ' & EMP2:FilterStagesNotInList & ')')
           END

        ELSE

           LOC:StageNotInList = ''

        END
  
     END

DisplayStageInList_2957      ROUTINE
! 04 Mar 2021 PK Naidoo - FB Case 2957

     LOC:Counter = 0

     PROPSQL('DELETE FilterStages WHERE EmployeeID = ' & CEM:RecordID)

     IF INSTRING(',',EMP2:FilterStagesInList,1)
     !FB 3505
        A# = 1
        X# = INSTRING(',',EMP2:FilterStagesInList,1)
        LOOP
            IF X# = 0 THEN BREAK.
            LOC:WorkingString = SUB(EMP2:FilterStagesInList,A#,X#)
            IF NUMERIC(LOC:WorkingString)
                LOC:Counter += 1
                PROPSQL('INSERT INTO FilterStages VALUES(' & CEM:RecordID & ', ' & LOC:WorkingString & ')')
            END
             A# = X#+1
             X# = INSTRING(',',EMP2:FilterStagesInList,1,A#)


        END
!        LOOP X# = 1 TO LEN(EMP2:FilterStagesInList)
!  
!             IF EMP2:FilterStagesInList[X#] = ','
!                LOC:Counter += 1
!             ELSIF X# = LEN(EMP2:FilterStagesInList)
!
!                LOC:Counter += 1
!
!                PROPSQL('INSERT INTO FilterStages VALUES(' & CEM:RecordID & ', ' & EMP2:FilterStagesInList & ')')
!
!             END
!  
!        END
!FB 3505 END
  
        LOC:StageInList = 'Selected Stages (' & CLIP(LEFT(FORMAT(LOC:Counter,@N_5))) & ')'
  
     ELSE

        IF NUMERIC(EMP2:FilterStagesInList)

           STA:RecordID = EMP2:FilterStagesInList
           IF ~Access:Stage.Fetch(STA:PrimaryKey)
               LOC:StageInList = STA:Description
               
               PROPSQL('INSERT INTO FilterStages VALUES(' & CEM:RecordID & ', ' & EMP2:FilterStagesInList & ')')

           END

        ELSE

           LOC:StageInList = ''

        END
  
     END

     !PROPSQL('DELETE FilterStages WHERE EmployeeID = ' & CEM:RecordID)
     !PROPSQL('INSERT FilterStages SELECT * FROM TaggedStage WHERE EmployeeID = ' & CEM:RecordID)


ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request
  OF ViewRecord
    ActionMessage = 'View Record'
  OF InsertRecord
    ActionMessage = 'Record Will Be Added'
  OF ChangeRecord
    ActionMessage = 'Record Will Be Changed'
  END
  QuickWindow{Prop:Text} = ActionMessage
  QuickWindow{Prop:Text} = 'Filter Matters'
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('FilterMatters')
  GlobalRequest = ChangeRecord
  SELF.Request = GlobalRequest
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?EMP2:FilterEmployeeFlag
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)
  CLEAR(GlobalResponse)
  
  SELF.AddUpdateFile(Access:EmployeeAlias2)
  SELF.AddItem(?Cancel,RequestCancelled)
  Relate:Branch.Open
  Relate:CostCentre.Open
  Relate:CriticalStep.Open
  Relate:Docgen.Open
  Relate:EmpDefaultFilter.Open
  Relate:Employee.Open
  Relate:EmployeeAlias2.Open
  Relate:EmployeeAlias3.Open
  Relate:Grouping.Open
  Relate:MatDef.Open
  Relate:MatType.Open
  Relate:Party.Open
  Relate:SheriffArea.Open
  Relate:Stage.Open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:EmployeeAlias2
  IF SELF.Request = ViewRecord
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = 0
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
!  !FilesOpened WITH ACCESS:
!  
!  Access:Branch.Open
!  Access:CostCentreAlias.Open
!  Access:Docgen.Open
!  Access:EmpDefaultFilter.Open
!  Access:EmployeeAlias.Open
!  Access:EmployeeAlias2.Open
!  Access:Grouping.Open
!  Access:MatDef.Open
!  Access:MatType.Open
!  Access:Party.Open
!  Access:SheriffArea.Open
!  Access:Stage.Open
!  
!  
!  Access:Branch.UseFile
!  Access:CostCentreAlias.UseFile
!  Access:Docgen.UseFile
!  Access:EmpDefaultFilter.UseFile
!  Access:EmployeeAlias.UseFile
!  Access:EmployeeAlias2.UseFile
!  Access:Grouping.UseFile
!  Access:MatDef.UseFile
!  Access:MatType.UseFile
!  Access:Party.UseFile
!  Access:SheriffArea.UseFile
!  Access:Stage.UseFile
  
  
  SELF.Primary &= Relate:EmployeeAlias2
  IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  SELF.CancelAction = Cancel:Cancel
  SELF.OkControl = ?OK
  
  
  EMP2:RecordID = GLO:RecordID
  Access:EmployeeAlias2.Fetch(EMP2:PrimaryKey)
  
  SAV:FilterDateFlag = EMP2:FilterDateFlag
  OPEN(QuickWindow)
  SELF.Opened=True
   IF SAV:GLO:FilterConveyancingStatusFlag OR SAV:GLO:FilterDebtLinkFlag OR SAV:GLO:FilterMatterTypeFlag OR SAV:GLO:FilterMatterTypeID OR SAV:GLO:RestrictToClientFlag OR SAV:GLO:RestrictToClientList OR SAV:GLO:RestrictToPartyRoleID OR|
      SAV:GLO:FilterEmployeeFlag OR SAV:GLO:FilterEmployeeID OR SAV:GLO:FilterStageFlag OR SAV:GLO:FilterStageID OR SAV:GLO:FilterDateFlag OR SAV:GLO:FilterToDate OR|
      SAV:GLO:FilterCostCentreFlag OR SAV:GLO:FilterCostCentreID OR SAV:GLO:FilterMattersBy OR SAV:GLO:FilterSheriffAreaFlag OR SAV:GLO:FilterSheriffAreaID OR SAV:GLO:FilterDocgenFlag OR|
      SAV:GLO:FilterDocgenID OR SAV:GLO:FilterStatusLiveFlag OR SAV:GLO:FilterStatusPendingFlag OR SAV:GLO:FilterStatusArchiveFlag OR SAV:GLO:FilterBalances OR SAV:GLO:FilterAging OR SAV:GLO:FilterLastInvoiceDate OR |
      SAV:GLO:FilterFavouritesFlag OR SAV:GLO:FilterGroupFlag OR SAV:GLO:FilterGroupID OR|
      SAV:GLO:FilterBranchFlag OR SAV:GLO:RestrictToBranchList OR SAV:GLO:RestrictToEmployeeList OR|
      SAV:GLO:RestrictToDocgenList OR SAV:GLO:RestrictToMatterTypeList OR SAV:GLO:RestrictToCostCentreList OR|
      SAV:GLO:FilterCriticalStepsInListFlag
  
      ?ResetButton{PROP:Hide} = False
  
  ELSE
      ?ResetButton{PROP:Hide} = True
  END


  LOC:QueueCounter = 0

  IF EMP2:FilterStageID

     LOC:FilterByStageFlag = 1
     LOC:Stage = GetDescription('Stage',EMP2:FilterStageID)

  END


  PROPSQLNext('SELECT COUNT(1) FROM FilterStages WHERE EmployeeID = ' & CEM:RecordID)
  IF ROW:Counter
     EMP2:FilterStagesInListFlag = 1
     SAV:FilterStagesInListFlag = EMP2:FilterStagesInListFlag
     DO ResetStageInList
     DO DisplayStageInList
  END

  PROPSQLNext('SELECT COUNT(1) FROM FilterNonStages WHERE EmployeeID = ' & CEM:RecordID)
  IF ROW:Counter
     EMP2:FilterStagesNotInListFlag = 1
     SAV:FilterStagesNotInListFlag = EMP2:FilterStagesNotInListFlag
     DO ResetStageNotInList
     DO DisplayStageNotInList
  END


  LOC:Stage = GetDescription('STAGE',EMP2:FilterStageID)
  
  CLEAR(MDF:Record)
  MDF:EmployeeID = GLO:EmployeeId
  SET(MDF:EmployeeClientKey,MDF:EmployeeClientKey)
  IF Access:MatDef.Next() THEN CLEAR(MDF:Record).
  
!  If CTL:FirmCode <> 'ACME01'
!      EMP2:LastStageDays = 0
!      Hide(?EMP2:LastStageDays:Prompt,?EMP2:LastStageDays:Suffix)
!  .
       QuickWindow{Prop:Alrt,254}=1024
       QuickWindow{Prop:Alrt,255}=AltF12
  FDB12.Init(?LOC:SheriffArea,Queue:FileDrop:3.ViewPosition,FDB12::View:FileDrop,Queue:FileDrop:3,Relate:SheriffArea,ThisWindow)
  FDB12.Q &= Queue:FileDrop:3
  FDB12.AddSortOrder(SHE:DescriptionKey)
  FDB12.AddField(SHE:Description,FDB12.Q.SHE:Description)
  FDB12.AddField(SHE:RecordID,FDB12.Q.SHE:RecordID)
  FDB12.AddUpdateField(SHE:RecordID,EMP2:FilterSheriffAreaID)
  ThisWindow.AddItem(FDB12.WindowComponent)
  FDB5.Init(?LOC:Group,Queue:FileDrop:5.ViewPosition,FDB5::View:FileDrop,Queue:FileDrop:5,Relate:Grouping,ThisWindow)
  FDB5.Q &= Queue:FileDrop:5
  FDB5.AddSortOrder(GRO:DescriptionKey)
  FDB5.AddField(GRO:Description,FDB5.Q.GRO:Description)
  FDB5.AddField(GRO:RecordID,FDB5.Q.GRO:RecordID)
  FDB5.AddUpdateField(GRO:RecordID,EMP2:FilterGroupID)
  ThisWindow.AddItem(FDB5.WindowComponent)
  FDB5.DefaultFill = 0
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Branch.Close
    Relate:CostCentre.Close
    Relate:CriticalStep.Close
    Relate:Docgen.Close
    Relate:EmpDefaultFilter.Close
    Relate:Employee.Close
    Relate:EmployeeAlias2.Close
    Relate:EmployeeAlias3.Close
    Relate:Grouping.Close
    Relate:MatDef.Close
    Relate:MatType.Close
    Relate:Party.Close
    Relate:SheriffArea.Close
    Relate:Stage.Close
  END
!  Access:Branch.Close
!  Access:CostCentreAlias.Close
!  Access:Docgen.Close
!  Access:EmpDefaultFilter.Close
!  Access:EmployeeAlias.Close
!  Access:EmployeeAlias2.Close
!  Access:Grouping.Close
!  Access:MatDef.Close
!  Access:MatType.Close
!  Access:Party.Close
!  Access:SheriffArea.Close
!  Access:Stage.Close
  
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


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
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled
  ELSE
    GlobalRequest = Request
    EXECUTE Number
      BrowseSheriffArea
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
        If ~(0) Then Cycle.
        Update(?)
        EMP:Name = Contents(?)
        Access:Employee.Fetch(EMP:NameKey)
        EMP2:RestrictToEmployeeList = EMP:RecordID
        LOC:Employee = EMP:Name
        If EMP:Name <> Contents(?)
          Select(?)
          Cycle
        .
    OF ?LookupEmployeeButton
            GlobalRequest = SelectRecord
      
            DO DisplayEmployees   ! THIS SETS THE TAGS AS WELL
      
            SelectEmployee
      
      
      
            If GlobalResponse = RequestCompleted
      
               EMP2:RestrictToEmployeeList = ''
               LOC:Employee = ''
      
               IF CntTag:PtrM(TAG:Employee) = 1
      
                  EMP:RecordID = FstTag:PtrM(TAG:Employee)
                  IF ~Access:Employee.TryFetch(EMP:PrimaryKey)
                      EMP2:RestrictToEmployeeList = EMP:RecordID
                      LOC:Employee = EMP:Name
                  END
            
               ELSIF CntTag:PtrM(TAG:Employee) > 1
      
                  LOOP X# = 1 TO CntTag:PtrM(TAG:Employee)
      
                        IF EMP2:RestrictToEmployeeList
                           LOC:EmployeeID = NxtTag:PtrM(TAG:Employee)
                           IF LOC:EmployeeID
                              EMP2:RestrictToEmployeeList = EMP2:RestrictToEmployeeList & ',' & LOC:EmployeeID
                           END
      
                        ELSE
                           EMP2:RestrictToEmployeeList = FstTag:PtrM(TAG:Employee)
                        END
            
                   END
                  LOC:Employee = 'Selected Employees (' & CLIP(LEFT(FORMAT(CntTag:PtrM(TAG:Employee),@N_5))) & ')'
      
               ELSE
      
                  EMP2:RestrictToEmployeeList = EMP:RecordID
                  LOC:Employee = EMP:Name
      
      
               END
               DISPLAY
            END
      
      
      
    OF ?LookupMatterTypeButton
            GlobalRequest = SelectRecord
      
            DO DisplayMatterTypes   ! THIS SETS THE TAGS AS WELL
      
            SelectMatType
      
            If GlobalResponse = RequestCompleted
      
               EMP2:RestrictToMatterTypeList = ''
               LOC:MatterType = ''
      
               IF CntTag:PtrM(TAG:MatterType) = 1
      
                  EMP:RecordID = FstTag:PtrM(TAG:MatterType)
                  IF ~Access:MatType.TryFetch(MT:PrimaryKey)
                      EMP2:RestrictToMatterTypeList = MT:RecordID
                      LOC:MatterType = MT:Description
                  END
            
               ELSIF CntTag:PtrM(TAG:MatterType) > 1
      
                  LOOP X# = 1 TO CntTag:PtrM(TAG:MatterType)
      
                        IF EMP2:RestrictToMatterTypeList
      
                           LOC:MatterTypeID = NxtTag:PtrM(TAG:MatterType)
      
                           IF LOC:MatterTypeID
                              EMP2:RestrictToMatterTypeList = EMP2:RestrictToMatterTypeList & ',' & LOC:MatterTypeID
                           END
      
                        ELSE
                           EMP2:RestrictToMatterTypeList = FstTag:PtrM(TAG:MatterType)
                        END
            
                   END
                  LOC:MatterType = 'Selected Matter Types (' & CLIP(LEFT(FORMAT(CntTag:PtrM(TAG:MatterType),@N_5))) & ')'
      
               ELSE
      
                  EMP2:RestrictToMatterTypeList = MT:RecordID
                  LOC:MatterType = MT:Description
      
      
               END
               DISPLAY
            END
      
    OF ?LOC:Docgen
        If ~(0) Then Cycle.
        Update(?)
        DG:Description = Contents(?)
        Access:Docgen.Fetch(DG:DescriptionKey)
        EMP2:RestrictToDocgenList = DG:RecordID
        LOC:Docgen = DG:Description
        If DG:Description <> Contents(?)
          Select(?)
          Cycle
        .
    OF ?LookupDocgenButton
            GlobalRequest = SelectRecord
      
            DO DisplayDocGens   ! THIS SETS THE TAGS AS WELL
      
            SelectDocGen
      
            If GlobalResponse = RequestCompleted
      
               EMP2:RestrictToDocGenList = ''
               LOC:DocGen = ''
      
      
          IF GLO:DebuggingFlag
      
             MESSAGE('CntTag:PtrM(TAG:DocGen) = ' & CntTag:PtrM(TAG:DocGen))
      
          END
      
               IF CntTag:PtrM(TAG:DocGen) = 1
      
                  EMP:RecordID = FstTag:PtrM(TAG:DocGen)
                  IF ~Access:DocGen.TryFetch(DG:PrimaryKey)
                      EMP2:RestrictToDocGenList = DG:RecordID
                      LOC:DocGen = DG:Description
                  END
            
               ELSIF CntTag:PtrM(TAG:DocGen) > 1
      
                  LOOP X# = 1 TO CntTag:PtrM(TAG:DocGen)
      
                        IF EMP2:RestrictToDocGenList
      
                           LOC:DocGenID = NxtTag:PtrM(TAG:DocGen)
      
                           IF LOC:DocGenID
                              EMP2:RestrictToDocGenList = EMP2:RestrictToDocGenList & ',' & LOC:DocGenID
                           END
      
                        ELSE
                           EMP2:RestrictToDocGenList = FstTag:PtrM(TAG:DocGen)
                        END
            
                   END
                  LOC:DocGen = 'Selected Document Sets (' & CLIP(LEFT(FORMAT(CntTag:PtrM(TAG:DocGen),@N_5))) & ')'
      
               ELSE
      
                  EMP2:RestrictToDocGenList = DG:RecordID
                  LOC:DocGen = DG:Description
      
      
               END
               DISPLAY
            END
      
    OF ?LOC:Party
        If ~(0) Then Cycle.
        Update(?)
        PAR:Name = Contents(?)
        Access:Party.Fetch(PAR:NameKey)
        EMP2:RestrictToClientList = PAR:RecordID
        LOC:Party = PAR:Name
        If PAR:Name <> Contents(?)
          Select(?)
          Cycle
        .
    OF ?LookupPartyButton
      GlobalRequest = SelectRecord

      DO DisplayClients   ! THIS SETS THE TAGS AS WELL

      SelectPartyAlias

      If GlobalResponse = RequestCompleted
         EMP2:RestrictToClientList = ''
         LOC:Party = ''
         IF CntTag:PtrM(TAG:PartyAlias) = 1
            PAR1:RecordID = FstTag:PtrM(TAG:PartyAlias)
            IF ~Access:PartyAlias.TryFetch(PAR1:PrimaryKey)
                EMP2:RestrictToClientList = PAR1:RecordID
                LOC:Party = PAR1:Name
            END
      
         ELSIF CntTag:PtrM(TAG:PartyAlias) > 1
            LOOP X# = 1 TO CntTag:PtrM(TAG:PartyAlias)

                  IF EMP2:RestrictToClientList
                     LOC:ClientID = NxtTag:PtrM(TAG:PartyAlias)
                     IF LOC:ClientID
                        EMP2:RestrictToClientList = EMP2:RestrictToClientList & ',' & LOC:ClientID
                     END

                  ELSE
                     EMP2:RestrictToClientList = FstTag:PtrM(TAG:PartyAlias)
                  END
      
             END
            LOC:Party = 'Selected Clients (' & CLIP(LEFT(FORMAT(CntTag:PtrM(TAG:PartyAlias),@N_5))) & ')'
         ELSE
            EMP2:RestrictToClientList = PAR1:RecordID
            LOC:Party = PAR1:Name
         END
         DISPLAY
      END

!            message('EMP2:RestrictToClientList = ' & EMP2:RestrictToClientList &|
!                    '|LOC:Party = ' & LOC:Party)
    OF ?LOC:CostCentre
        If ~(0) Then Cycle.
        Update(?)
        COS:Description = Contents(?)
        Access:CostCentre.Fetch(COS:DescriptionKey)
        EMP:RestrictToCostCentreList = COS:RecordID
        LOC:CostCentre = COS:Description
        If COS:Description <> Contents(?)
          Select(?)
          Cycle
        .
    OF ?LookupCostCentreButton
            GlobalRequest = SelectRecord
      
            DO DisplayCostCentres   ! THIS SETS THE TAGS AS WELL
      
            SelectCostCentre
      
            If GlobalResponse = RequestCompleted
      
               EMP2:RestrictToCostCentreList = ''
               LOC:CostCentre = ''
      
               IF CntTag:PtrM(TAG:CostCentre) = 1
      
                  EMP:RecordID = FstTag:PtrM(TAG:CostCentre)
                  IF ~Access:CostCentre.TryFetch(COS:PrimaryKey)
                      EMP2:RestrictToCostCentreList = COS:RecordID
                      LOC:CostCentre = COS:Description
                  END
            
               ELSIF CntTag:PtrM(TAG:CostCentre) > 1
      
                  LOOP X# = 1 TO CntTag:PtrM(TAG:CostCentre)
      
                        IF EMP2:RestrictToCostCentreList
      
                           LOC:CostCentreID = NxtTag:PtrM(TAG:CostCentre)
      
                           IF LOC:CostCentreID
                              EMP2:RestrictToCostCentreList = EMP2:RestrictToCostCentreList & ',' & LOC:CostCentreID
                           END
      
                        ELSE
                           EMP2:RestrictToCostCentreList = FstTag:PtrM(TAG:CostCentre)
                        END
            
                   END
                  LOC:CostCentre = 'Selected Cost Centres (' & CLIP(LEFT(FORMAT(CntTag:PtrM(TAG:CostCentre),@N_5))) & ')'
      
               ELSE
      
                  EMP2:RestrictToCostCentreList = COS:RecordID
                  LOC:CostCentre = COS:Description
      
      
               END
               DISPLAY
            END
      
    OF ?LOC:Branch
        If ~(0) Then Cycle.
        Update(?)
        BRA:Description = Contents(?)
        Access:Branch.Fetch(BRA:DescriptionKey)
        EMP2:RestrictToBranchList = BRA:RecordID
        LOC:Branch = BRA:Description
        If BRA:Description <> Contents(?)
          Select(?)
          Cycle
        .
      
    OF ?LookupBranchButton
            GlobalRequest = SelectRecord
      
            DO DisplayBranches   ! THIS SETS THE TAGS AS WELL
      
            SelectBranchTagged
      
      
            If GlobalResponse = RequestCompleted
               EMP2:RestrictToBranchList = ''
               LOC:Branch = ''
               IF CntTag:PtrM(TAG:Branch) = 1
                  BRA:RecordID = FstTag:PtrM(TAG:Branch)
                  IF ~Access:Branch.TryFetch(BRA:PrimaryKey)
                      EMP2:RestrictToBranchList = BRA:RecordID
                      LOC:Branch = BRA:Description
                  END
            
               ELSIF CntTag:PtrM(TAG:Branch) > 1
                  LOOP X# = 1 TO CntTag:PtrM(TAG:Branch)
      
                        IF EMP2:RestrictToBranchList
                           LOC:BranchID = NxtTag:PtrM(TAG:Branch)
                           IF LOC:BranchID
                              EMP2:RestrictToBranchList = EMP2:RestrictToBranchList & ',' & LOC:BranchID
                           END
      
                        ELSE
                           EMP2:RestrictToBranchList = FstTag:PtrM(TAG:Branch)
                        END
            
                   END
                  LOC:Branch = 'Selected Branches (' & CLIP(LEFT(FORMAT(CntTag:PtrM(TAG:Branch),@N_5))) & ')'
               ELSE
                  EMP2:RestrictToBranchList = BRA:RecordID
                  LOC:Branch = BRA:Description
               END
               DISPLAY
            END
      
    OF ?LookupStageInListButton
            GlobalRequest = SelectRecord

            DO ResetStageInList

            SelectStage

            ! 04 Mar 2021 PK Naidoo - FB Case 2957 Begin
!            If GlobalResponse = RequestCompleted
!               EMP2:FilterStagesInList = ''
!               LOC:StageInList = ''
!               IF CntTag:PtrM(TAG:Stage) = 1
!                  STA:RecordID = FstTag:PtrM(TAG:Stage)
!                  IF ~Access:Stage.TryFetch(STA:PrimaryKey)
!                      EMP2:FilterStagesInList = STA:RecordID
!                      LOC:StageInList = STA:Description
!                  END
!
!               ELSIF CntTag:PtrM(TAG:Stage) > 1
!                  LOOP X# = 1 TO CntTag:PtrM(TAG:Stage)
!
!                        IF EMP2:FilterStagesInList
!                           LOC:StagesInListID = NxtTag:PtrM(TAG:Stage)
!                           IF LOC:StagesInListID
!                              EMP2:FilterStagesInList = EMP2:FilterStagesInList & ',' & LOC:StagesInListID
!                           END
!
!                        ELSE
!                           EMP2:FilterStagesInList = FstTag:PtrM(TAG:Stage)
!                        END
!
!                   END
!                  LOC:StageInList = 'Selected Stages (' & CLIP(LEFT(FORMAT(CntTag:PtrM(TAG:Stage),@N_5))) & ')'
!               ELSE
!                  EMP2:FilterStagesInList = STA:RecordID
!                  LOC:StagesInListID = STA:Description
!               END
!               DISPLAY
!            END
            ! 04 Mar 2021 PK Naidoo - FB Case 2957 End

            DO DisplayStageInList


    OF ?LookupStageNotInListButton
            GlobalRequest = SelectRecord
      
            DO ResetStageNotInList
      
            SelectStage
      
            ! 04 Mar 2021 PK Naidoo - FB Case 2957 Begin
!            If GlobalResponse = RequestCompleted
!               EMP2:FilterStagesNotInList = ''
!               LOC:StageNotInList = ''
!               IF CntTag:PtrM(TAG:Stage) = 1
!                  STA:RecordID = FstTag:PtrM(TAG:Stage)
!                  IF ~Access:Stage.TryFetch(STA:PrimaryKey)
!                      EMP2:FilterStagesNotInList = STA:RecordID
!                      LOC:StageNotInList = STA:Description
!                  END
!      
!               ELSIF CntTag:PtrM(TAG:Stage) > 1
!                  LOOP X# = 1 TO CntTag:PtrM(TAG:Stage)
!      
!                        IF EMP2:FilterStagesNotInList
!                           LOC:StagesNotInListID = NxtTag:PtrM(TAG:Stage)
!                           IF LOC:StagesNotInListID
!                              EMP2:FilterStagesNotInList = EMP2:FilterStagesNotInList & ',' & LOC:StagesNotInListID
!                           END
!      
!                        ELSE
!                           EMP2:FilterStagesNotInList = FstTag:PtrM(TAG:Stage)
!                        END
!      
!                   END
!                  LOC:StageNotInList = 'Selected Stages (' & CLIP(LEFT(FORMAT(CntTag:PtrM(TAG:Stage),@N_5))) & ')'
!               ELSE
!                  EMP2:FilterStagesNotInList = STA:RecordID
!                  LOC:StagesNotInListID = STA:Description
!               END
!               DISPLAY
!            END
            ! 04 Mar 2021 PK Naidoo - FB Case 2957 End
      
            DO DisplayStageNotInList
      
    OF ?LOC:CriticalStep
        If ~(0) Then Cycle.
        Update(?)
        CRI:Description = Contents(?)
        Access:CriticalStep.Fetch(CRI:DescriptionKey)
        EMP2:FilterConveyancingStatus = CRI:RecordID
        If CRI:Description <> Contents(?)
          Select(?)
          Cycle
        .
    OF ?LookupCriticalStepButton
            GlobalRequest = SelectRecord
      
            DO DisplayCriticalSteps   ! THIS SETS THE TAGS AS WELL
      
            SelectCriticalStepTagged
      
      
            If GlobalResponse = RequestCompleted
               EMP2:RestrictToCriticalStepList = ''
               LOC:CriticalStep = ''
               IF CntTag:PtrM(TAG:CriticalStep) = 1
                  CRI:RecordID = FstTag:PtrM(TAG:CriticalStep)
                  IF ~Access:CriticalStep.TryFetch(CRI:PrimaryKey)
                      EMP2:RestrictToCriticalStepList = CRI:RecordID
                      LOC:CriticalStep = CRI:Description
                  END
            
               ELSIF CntTag:PtrM(TAG:CriticalStep) > 1
                  LOOP X# = 1 TO CntTag:PtrM(TAG:CriticalStep)
      
                        IF EMP2:RestrictToCriticalStepList
                           LOC:CriticalStepID = NxtTag:PtrM(TAG:CriticalStep)
                           IF LOC:CriticalStepID
                              EMP2:RestrictToCriticalStepList = EMP2:RestrictToCriticalStepList & ',' & LOC:CriticalStepID
                           END
      
                        ELSE
                           EMP2:RestrictToCriticalStepList = FstTag:PtrM(TAG:CriticalStep)
                        END
            
                   END
                  LOC:CriticalStep = 'Selected Critical Steps (' & CLIP(LEFT(FORMAT(CntTag:PtrM(TAG:CriticalStep),@N_5))) & ')'
               ELSE
                  EMP2:RestrictToCriticalStepList = CRI:RecordID
                  LOC:CriticalStep = CRI:Description
               END
               DISPLAY
            END
    OF ?LOC:CriticalStepNotIn
        If ~(0) Then Cycle.
        Update(?)
        CRI:Description = Contents(?)
        Access:CriticalStep.Fetch(CRI:DescriptionKey)
        EMP2:FilterCriticalStepsNotInList = CRI:RecordID
        If CRI:Description <> Contents(?)
          Select(?)
          Cycle
        .
    OF ?LookupCriticalStepButton:2
            GlobalRequest = SelectRecord
      
            DO DisplayCriticalStepsNotIn   ! THIS SETS THE TAGS AS WELL
      
            SelectCriticalStepTagged
      
            If GlobalResponse = RequestCompleted
               EMP2:FilterCriticalStepsNotInList = ''
               LOC:CriticalStepNotIn = ''
               IF CntTag:PtrM(TAG:CriticalStep) = 1
                  CRI:RecordID = FstTag:PtrM(TAG:CriticalStep)
                  IF ~Access:CriticalStep.TryFetch(CRI:PrimaryKey)
                      EMP2:FilterCriticalStepsNotInList = CRI:RecordID
                      LOC:CriticalStepNotIn = CRI:Description
                  END
            
               ELSIF CntTag:PtrM(TAG:CriticalStep) > 1
                  LOOP X# = 1 TO CntTag:PtrM(TAG:CriticalStep)
      
                        IF EMP2:FilterCriticalStepsNotInList
                           LOC:CriticalStepID = NxtTag:PtrM(TAG:CriticalStep)
                           IF LOC:CriticalStepID
                              EMP2:FilterCriticalStepsNotInList = EMP2:FilterCriticalStepsNotInList & ',' & LOC:CriticalStepID
                           END
      
                        ELSE
                           EMP2:FilterCriticalStepsNotInList = FstTag:PtrM(TAG:CriticalStep)
                        END
            
                   END
                  LOC:CriticalStepNotIn = 'Selected Critical Steps (' & CLIP(LEFT(FORMAT(CntTag:PtrM(TAG:CriticalStep),@N_5))) & ')'
               ELSE
                  EMP2:FilterCriticalStepsNotInList = CRI:RecordID
                  LOC:CriticalStepNotIn = CRI:Description
               END
               DISPLAY
            END
    OF ?CustomDateButton
        GetDateRange(EMP2:FilterFromDate,EMP2:FilterToDate)
        ?CustomDateButton{PROP:Tooltip} = 'Specify a Date Range<13,10>Current range: ' & FORMAT(EMP2:FilterFromDate,@D17) & ' to ' & FORMAT(EMP2:FilterToDate,@D17)
        EMP2:FilterDateOption{PROP:Selected} = 5
        EMP2:FilterDateOption = 'Custom'
      
    OF ?LookupInactiveMattersButton
       FilterInactiveMatters
       DO DisplayInactiveMatters
      
    OF ?LookupPartyTypesButton
       !FB1981
       FilterPartyRoles
       
       DO DisplayPartyTypes
       !FB1981 END
    OF ?ResetButton
        EMP2:FilterMatterTypeID = 0 ! DEPRECATE THIS
        EMP2:FilterEmployeeID = 0 ! DEPRECATE THIS
        EMP2:FilterCostCentreID = 0 ! DEPRECATE THIS
        EMP2:FilterBranchID = 0 ! DEPRECATE THIS
        EMP2:FilterDocgenID = 0 ! DEPRECATE THIS


        EMP2:FilterConveyancingStatusFlag = SAV:GLO:FilterConveyancingStatusFlag
        EMP2:FilterDebtLinkFlag = SAV:GLO:FilterDebtLinkFlag
        EMP2:FilterMatterTypeFlag = SAV:GLO:FilterMatterTypeFlag
        EMP2:RestrictToClientFlag = SAV:GLO:RestrictToClientFlag
        EMP2:RestrictToClientList = SAV:GLO:RestrictToClientList
        EMP2:RestrictToPartyRoleID = SAV:GLO:RestrictToPartyRoleID
        EMP2:FilterEmployeeFlag = SAV:GLO:FilterEmployeeFlag
        EMP2:FilterStageFlag = SAV:GLO:FilterStageFlag
        EMP2:FilterStageID = SAV:GLO:FilterStageID
        EMP2:FilterDateFlag = SAV:GLO:FilterDateFlag
        EMP2:FilterToDate = SAV:GLO:FilterToDate
        EMP2:FilterCostCentreFlag = SAV:GLO:FilterCostCentreFlag
        EMP2:FilterBranchFlag = SAV:GLO:FilterBranchFlag
        EMP2:RestrictToBranchList = SAV:GLO:RestrictToBranchList

        EMP2:RestrictToCriticalStepList = SAV:GLO:RestrictToCriticalStepList
        EMP2:FilterConveyancingStatus = SAV:GLO:FilterConveyancingStatus


        EMP2:FilterCriticalStepsNotInList = SAV:GLO:FilterCriticalStepsNotInList
        EMP2:FilterCriticalStepsNotInListFlag = SAV:GLO:FilterCriticalStepsNotInListFlag
        EMP2:FilterCriticalStepsInListFlag = SAV:GLO:FilterCriticalStepsInListFlag

        EMP2:FilterMattersBy = SAV:GLO:FilterMattersBy
        EMP2:FilterSheriffAreaFlag = SAV:GLO:FilterSheriffAreaFlag
        EMP2:FilterSheriffAreaID = SAV:GLO:FilterSheriffAreaID
        EMP2:FilterDocgenFlag = SAV:GLO:FilterDocgenFlag
        EMP2:FilterStatusLiveFlag = SAV:GLO:FilterStatusLiveFlag
        EMP2:FilterStatusPendingFlag = SAV:GLO:FilterStatusPendingFlag
        EMP2:FilterStatusArchiveFlag = SAV:GLO:FilterStatusArchiveFlag
        EMP2:FilterBalances = SAV:GLO:FilterBalances
        EMP2:FilterAging = SAV:GLO:FilterAging
        EMP2:FilterLastInvoiceDate = SAV:GLO:FilterLastInvoiceDate
        
        EMP2:FilterFavouritesFlag = SAV:GLO:FilterFavouritesFlag
        EMP2:FilterGroupFlag = SAV:GLO:FilterGroupFlag
        EMP2:FilterGroupID = SAV:GLO:FilterGroupID
      
        GLO:FilterConveyancingStatusFlag = SAV:GLO:FilterConveyancingStatusFlag
        GLO:FilterDebtLinkFlag = SAV:GLO:FilterDebtLinkFlag
        GLO:FilterMatterTypeFlag = SAV:GLO:FilterMatterTypeFlag
        GLO:FilterMatterTypeID = SAV:GLO:FilterMatterTypeID
        GLO:RestrictToClientFlag = SAV:GLO:RestrictToClientFlag
        GLO:RestrictToClientList = SAV:GLO:RestrictToClientList
        GLO:RestrictToPartyRoleID = SAV:GLO:RestrictToPartyRoleID
        GLO:FilterEmployeeFlag = SAV:GLO:FilterEmployeeFlag
        GLO:FilterEmployeeID = SAV:GLO:FilterEmployeeID
        GLO:FilterStageFlag = SAV:GLO:FilterStageFlag
        GLO:FilterStageID = SAV:GLO:FilterStageID
        GLO:FilterDateFlag = SAV:GLO:FilterDateFlag
        GLO:FilterToDate = SAV:GLO:FilterToDate
        GLO:FilterCostCentreFlag = SAV:GLO:FilterCostCentreFlag
        GLO:FilterCostCentreID = SAV:GLO:FilterCostCentreID
        GLO:FilterBranchFlag = SAV:GLO:FilterBranchFlag
        GLO:RestrictToBranchList = SAV:GLO:RestrictToBranchList

        GLO:RestrictToCriticalStepList = SAV:GLO:RestrictToCriticalStepList
        GLO:FilterConveyancingStatus = SAV:GLO:FilterConveyancingStatus

        GLO:FilterCriticalStepsNotInList = SAV:GLO:FilterCriticalStepsNotInList
        GLO:FilterCriticalStepsNotInListFlag = SAV:GLO:FilterCriticalStepsNotInListFlag
        GLO:FilterCriticalStepsInListFlag = SAV:GLO:FilterCriticalStepsInListFlag

        GLO:FilterMattersBy = SAV:GLO:FilterMattersBy
        GLO:FilterSheriffAreaFlag = SAV:GLO:FilterSheriffAreaFlag
        GLO:FilterSheriffAreaID = SAV:GLO:FilterSheriffAreaID
        GLO:FilterDocgenFlag = SAV:GLO:FilterDocgenFlag
        GLO:FilterDocgenID = SAV:GLO:FilterDocgenID
        GLO:FilterStatusLiveFlag = SAV:GLO:FilterStatusLiveFlag
        GLO:FilterStatusPendingFlag = SAV:GLO:FilterStatusPendingFlag
        GLO:FilterStatusArchiveFlag = SAV:GLO:FilterStatusArchiveFlag
        GLO:FilterBalances = SAV:GLO:FilterBalances

        GLO:FilterAging = SAV:GLO:FilterAging
        GLO:FilterLastInvoiceDate = SAV:GLO:FilterLastInvoiceDate


        GLO:FilterFavouritesFlag = SAV:GLO:FilterFavouritesFlag
        GLO:FilterGroupFlag = SAV:GLO:FilterGroupFlag
        GLO:FilterGroupID = SAV:GLO:FilterGroupID
      
        Access:EmployeeAlias2.Update
      
        CLEAR(PreviousMatterFilter)


        IF GLO:FilterSheriffAreaFlag AND GLO:FilterSheriffAreaID
           SHE:RecordID = GLO:FilterSheriffAreaID
           Access:SheriffArea.TryFetch(SHE:PrimaryKey)
           LOC:SheriffArea = SHE:Description
           FDB12.TakeNewSelection
        END
        IF GLO:FilterGroupFlag AND GLO:FilterGroupID
           GRO:RecordID = GLO:FilterGroupID
           Access:Grouping.TryFetch(GRO:PrimaryKey)
           LOC:Group = GRO:Description
           FDB5.TakeNewSelection
        END
        IF GLO:FilterStageID
           LOC:Stage = GetDescription('Stage',GLO:FilterStageID)
        END
      
        IF EMP2:RestrictToClientList
           DO DisplayClients
        END

        IF EMP2:FilterStagesInListFlag
           DO DisplayStageInList
        END

        IF EMP2:FilterStagesNotInListFlag
           DO DisplayStageNotInList
        END


        IF EMP2:RestrictToBranchList
           DO DisplayBranches
        END

        IF EMP2:RestrictToCriticalStepList
           DO DisplayCriticalSteps
        END


        IF EMP2:FilterCriticalStepsNotInList
           DO DisplayCriticalStepsNotIn
        END



        IF EMP2:RestrictToEmployeeList
           DO DisplayEmployees
        END

        IF EMP2:RestrictToDocGenList
           DO DisplayDocGens
        END

        IF EMP2:RestrictToMatterTypeList
           DO DisplayMatterTypes
        END

        IF EMP2:RestrictToCostCentreList
           DO DisplayCostCentres
        END


        ?ResetButton{PROP:Hide} = True
        DISPLAY
      
      
    OF ?OK
      IF EMP2:FilterSheriffAreaFlag AND ~EMP2:FilterSheriffAreaID THEN EMP2:FilterSheriffAreaFlag = False.
      IF EMP2:RestrictToClientFlag AND ~EMP2:RestrictToClientList THEN EMP2:RestrictToClientFlag = False.
      IF EMP2:FilterGroupFlag AND ~EMP2:FilterGroupID THEN EMP2:FilterGroupFlag = False.
      IF EMP2:FilterDateFlag AND ~EMP2:FilterToDate THEN EMP2:FilterDateFlag = False.
      
      IF EMP2:FilterStagesInListFlag AND ~LOC:StageInList
         EMP2:FilterStagesInListFlag = 0
         PROPSQL('DELETE FilterStages WHERE EmployeeID = ' & GLO:EmployeeID,'ClearDesktopFilter')
      END
      
      IF EMP2:FilterStagesNotInListFlag AND ~LOC:StageNotInList
         EMP2:FilterStagesNotInListFlag = 0
         PROPSQL('DELETE FilterNonStages WHERE EmployeeID = ' & GLO:EmployeeID,'ClearDesktopFilter')
      END
      
      IF ~EMP2:FilterInactiveMattersFlag
         EMP2:FilterInactiveDays = 30
         EMP2:FilterInactiveFileNotesFlag = 0
         EMP2:FilterFileNotesOption = 'A'
         EMP2:FilterInactiveFeeNotesFlag = 0
         EMP2:FilterInactiveToDoNotesFlag = 0
         EMP2:FilterInactiveColDebitFlag = 0
         EMP2:FilterInactiveMatTranFlag = 0
      ELSE
      
         LOC:CheckIfInactivitySet = EMP2:FilterInactiveFileNotesFlag + EMP2:FilterInactiveFeeNotesFlag + EMP2:FilterInactiveToDoNotesFlag + EMP2:FilterInactiveColDebitFlag + EMP2:FilterInactiveMatTranFlag
         IF ~LOC:CheckIfInactivitySet
             EMP2:FilterInactiveMattersFlag = 0
         END
      
      END
      !FB1981
      IF ~EMP2:FilterPartyRoleFlag OR (~EMP2:FilterParty1ID AND ~EMP2:FilterRole1ID AND ~EMP2:FilterParty2ID AND ~EMP2:FilterRole2ID AND ~EMP2:FilterParty3ID AND ~EMP2:FilterRole3ID) THEN EMP2:FilterPartyRoleFlag = 0.
       !FB1981 END
      IF ~EMP2:FilterConveyancingStatusFlag THEN EMP2:FilterConveyancingStatus = 0.
      IF ~EMP2:RestrictToClientList THEN EMP2:RestrictToClientFlag = 0.
      IF ~EMP2:RestrictToEmployeeList THEN EMP2:FilterEmployeeFlag = 0.
      IF ~EMP2:RestrictToBranchList THEN EMP2:FilterBranchFlag = 0.
      IF ~EMP2:RestrictToCriticalStepList THEN EMP2:FilterCriticalStepsInListFlag = 0.
      IF ~EMP2:FilterCriticalStepsNotInList THEN EMP2:FilterCriticalStepsNotInListFlag  = 0.
      IF ~EMP2:RestrictToDocGenList THEN EMP2:FilterDocGenFlag = 0.
      IF ~EMP2:RestrictToMatterTypeList THEN EMP2:FilterMatterTypeFlag = 0.
      IF ~EMP2:RestrictToCostCentreList THEN EMP2:FilterCostCentreFlag = 0.
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?EMP2:FilterSheriffAreaID
      IF EMP2:FilterSheriffAreaID OR ?EMP2:FilterSheriffAreaID{Prop:Req}
        SHE:RecordID = EMP2:FilterSheriffAreaID
        IF Access:SheriffArea.TryFetch(SHE:PrimaryKey)
          IF SELF.Run(1,SelectRecord) = RequestCompleted
            EMP2:FilterSheriffAreaID = SHE:RecordID
          ELSE
            SELECT(?EMP2:FilterSheriffAreaID)
            CYCLE
          END
        END
      END
      ThisWindow.Reset()
    OF ?LookupSheriffAreaButton
      ThisWindow.Update
      SHE:RecordID = EMP2:FilterSheriffAreaID
      IF SELF.Run(1,SelectRecord) = RequestCompleted
        EMP2:FilterSheriffAreaID = SHE:RecordID
      END
      ThisWindow.Reset(1)
    OF ?LookupStage
      ThisWindow.Update
      PROPSQL('DELETE TaggedStage WHERE EmployeeID = ' & CEM:RecordID)
      
      GlobalRequest = SelectRecord
      SelectStage
      
      !IF ~Access:Stage.TryFetch(STA:PrimaryKey)
        EMP2:FilterStageID = STA:RecordID
        LOC:Stage = STA:Description
      !END
      DISPLAY
      
    OF ?LookupLibraryButton
      ThisWindow.Update
      GLO:TooltipCategory = ?EMP2:FilterMattersBy{PROP:Tooltip}
      IF GLO:TooltipCategory
      
         FoundHrt# = INSTRING('<13,10>',GLO:TooltipCategory,1)
         IF FoundHrt# THEN GLO:TooltipCategory = GLO:TooltipCategory[1:FoundHrt#-1].
      
         SAV:PROP:SelStart# = ?EMP2:FilterMattersBy{PROP:SelStart}
         GLO:TooltipContents = ?EMP2:FilterMattersBy{PROP:ScreenText}
         GlobalRequest = SelectRecord
         BrowseLookup
         IF GlobalResponse = RequestCompleted
            LIB:Description = ReplaceTextBoxFields(LIB:Description,0,-1,-1,0)
            IF EMP2:FilterMattersBy     ! IF THERE ALREADY IS TEXT IN THIS FIELD
               IF SAV:PROP:SelStart#  >= LEN(EMP2:FilterMattersBy) ! THE CURSOR IS AT THE END
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Add the new text at the end?','Confirm Action',ICON:Question,'&Replace|&Add|&Quit',1)
                     EMP2:FilterMattersBy = LIB:Description
                     EMP2:FilterMattersBy =  EMP2:FilterMattersBy & LIB:Description
                  END
               ELSE
                  EXECUTE MESSAGE('This Field already contains some text.||Do you want to Replace the contents of this Field or Insert the new text at the cursor position?','Confirm Action',ICON:Question,'&Replace|&Insert|&Quit',1)
                     EMP2:FilterMattersBy = LIB:Description
                     EMP2:FilterMattersBy =  SUB(Contents(?EMP2:FilterMattersBy),1,SAV:PROP:SelStart#-1) & LIB:Description & SUB(Contents(?EMP2:FilterMattersBy),SAV:PROP:SelStart#,1000)
                  END
               END
            ELSE
              EMP2:FilterMattersBy = LIB:Description
            END
            DISPLAY(?EMP2:FilterMattersBy)
            SELECT(?EMP2:FilterMattersBy,SAV:PROP:SelStart# + LEN(LIB:Description))
         END
         CLEAR(GlobalRequest)
      ELSE
         MESSAGE('This Field does not have a Tooltip.||Unable to display the lookup library.','Program Error',ICON:Exclamation)
      END
      
      
      
      
    OF ?FavouritesButton
      ThisWindow.Update
      BrowseEmployeeFavourites
      ThisWindow.Reset
    OF ?FinancialButton
      ThisWindow.Update
      FilterFinancial
      ThisWindow.Reset
    OF ?SetAsDefault
      ThisWindow.Update
      GlobalRequest = SelectRecord
      BrowseEmpDefaultFilter
      IF GlobalResponse = RequestCompleted
      
      
             EMP2:FilterMatterTypeID = 0 ! DEPRECATE THIS
             EMP2:FilterMatterTypeFlag = EDF:FilterMatterTypeFlag
             EMP2:FilterGroupFlag  = EDF:FilterGroupFlag
             EMP2:FilterCostCentreFlag = EDF:FilterCostCentreFlag
             EMP2:FilterCostCentreID = 0 ! DEPRECATE THIS
             EMP2:FilterBranchFlag = EDF:FilterBranchFlag
             EMP2:FilterBranchID = 0 ! DEPRECATE THIS
             EMP2:RestrictToBranchList = EDF:RestrictToBranchList
      
      
             EMP2:FilterInactiveMattersFlag = EDF:FilterInactiveMattersFlag
             EMP2:FilterInactiveFileNotesFlag = EDF:FilterInactiveFileNotesFlag
             EMP2:FilterFileNotesOption = EDF:FilterFileNotesOption
             EMP2:FilterInactiveFeeNotesFlag = EDF:FilterInactiveFeeNotesFlag
             EMP2:FilterInactiveToDoNotesFlag = EDF:FilterInactiveToDoNotesFlag
             EMP2:FilterInactiveColDebitFlag = EDF:FilterInactiveColDebitFlag
             EMP2:FilterInactiveMatTranFlag = EDF:FilterInactiveMatTranFlag
             EMP2:FilterInactiveDays = EDF:FilterInactiveDays
      
             !FB1981
             EMP2:FilterPartyRoleFlag= EDF:FilterPartyRoleFlag   
             EMP2:FilterParty1ID= EDF:FilterParty1ID        
             EMP2:FilterRole1ID = EDF:FilterRole1ID         
             EMP2:FilterParty2ID= EDF:FilterParty2ID        
             EMP2:FilterRole2ID = EDF:FilterRole2ID         
             EMP2:FilterParty3ID= EDF:FilterParty3ID        
             EMP2:FilterRole3ID = EDF:FilterRole3ID   
             !END FB1981
      
             EMP2:FilterCriticalStepsInListFlag = EDF:FilterCriticalStepsInListFlag
             EMP2:RestrictToCriticalStepList = EDF:RestrictToCriticalStepList
      
             EMP2:FilterCriticalStepsNotInListFlag = EDF:FilterCriticalStepsNotInListFlag
             EMP2:FilterCriticalStepsNotInList = EDF:FilterCriticalStepsNotInList
      
             ! 04 Mar 2021 PK Naidoo - FB Case 2957
             EMP2:FilterStagesInListFlag = EDF:FilterStagesInListFlag
             !DisplayStageInListSet = 1
             !EMP2:FilterStagesInList = EDF:FilterStagesInList
             EMP2:FilterStagesNotInListFlag = EDF:FilterStagesNotInListFlag
             !EMP2:FilterStagesNotInList = EDF:FilterStagesNotInList
             !DisplayStageNotInListSet = 1
             EMP2:RestrictToEmployeeList = EDF:RestrictToEmployeeList
             EMP2:RestrictToDocGenList = EDF:RestrictToDocGenList
             EMP2:RestrictToMatterTypeList = EDF:RestrictToMatterTypeList
             EMP2:RestrictToCostCentreList = EDF:RestrictToCostCentreList
             EMP2:FilterGroupID  = EDF:FilterGroupID
             EMP2:FilterEmployeeFlag  = EDF:FilterEmployeeFlag
             EMP2:FilterDateFlag  = EDF:FilterDateFlag
             EMP2:FilterFromDate  = EDF:FilterFromDate
             EMP2:FilterDateOption = EDF:FilterDateOption
             EMP2:FilterToDate  = EDF:FilterToDate
             EMP2:FilterDocgenFlag  = EDF:FilterDocgenFlag
             EMP2:FilterDocgenID  = 0 ! DEPRECATE THIS
             EMP2:FilterSheriffAreaFlag  = EDF:FilterSheriffAreaFlag
             EMP2:FilterSheriffAreaID  = EDF:FilterSheriffAreaID 
             EMP2:FilterEmployeeID  = 0 ! DEPRECATE THIS
             EMP2:FilterMattersBy = EDF:FilterMattersBy
             EMP2:FilterBalances  = EDF:FilterBalances
      
             EMP2:FilterAging  = EDF:FilterAging
             EMP2:FilterLastInvoiceDate = EDF:FilterLastInvoiceDate
      
      
             EMP2:FilterFavouritesFlag  = EDF:FilterFavouritesFlag
             EMP2:FilterDebtLinkFlag  = EDF:FilterDebtLinkFlag
             EMP2:FilterDebtLinkCategory  = EDF:FilterDebtLinkCategory
             EMP2:FilterDebtLinkFlag  = EDF:FilterDebtLinkFlag
             EMP2:FilterConveyancingStatusFlag  = EDF:FilterConveyancingStatusFlag
             EMP2:FilterConveyancingStatus  = EDF:FilterConveyancingStatus
      
             EMP2:FilterStatusArchiveFlag  = EDF:FilterStatusArchiveFlag
             EMP2:FilterStatusPendingFlag  = EDF:FilterStatusPendingFlag
             EMP2:FilterStatusLiveFlag  = EDF:FilterStatusLiveFlag
             EMP2:FilterStageFlag  = EDF:FilterStageFlag
             EMP2:FilterStageID  = EDF:FilterStageID
             EMP2:FilterParGroupFlag  = EDF:FilterParGroupFlag
             EMP2:FilterParGroupID  = EDF:FilterParGroupID
             EMP2:FilterParRegionFlag  = EDF:FilterParRegionFlag
             EMP2:FilterParCategoryFlag  = EDF:FilterParCategoryFlag
             EMP2:FilterParAnyStageFlag  = EDF:FilterParAnyStageFlag
             EMP2:FilterParLastStageFlag  = EDF:FilterParLastStageFlag
             EMP2:FilterParRegionID  = EDF:FilterParRegionID
             EMP2:FilterParCategoryID  = EDF:FilterParCategoryID
             EMP2:FilterParAnyStageID  = EDF:FilterParAnyStageID
             EMP2:FilterParLastStageID = EDF:FilterParLastStageID
             EMP2:RestrictToClientList = EDF:RestrictToClientList
             IF EMP2:RestrictToClientList
                EMP2:RestrictToClientFlag = 1
             ELSE
                EMP2:RestrictToClientFlag = 0
             END
      
             EMP2:EmpDefaultFilterID = EDF:RecordID
             CEM:EmpDefaultFilterID = EDF:RecordID
      
             DO ResetTheScreen
      
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
  NewTag:PtrM(TAG:PartyAlias)       ! CLEAR WHEN EXITING
  
  
  GLO:FilterConveyancingStatus = EMP2:FilterConveyancingStatus
  GLO:FilterConveyancingStatusFlag = EMP2:FilterConveyancingStatusFlag
  GLO:FilterDebtLinkCategory = EMP2:FilterDebtLinkCategory
  GLO:FilterDebtLinkFlag = EMP2:FilterDebtLinkFlag
  GLO:FilterFavouritesFlag = EMP2:FilterFavouritesFlag
  GLO:RestrictToClientList = EMP2:RestrictToClientList
  GLO:RestrictToPartyRoleID = 0
  GLO:RestrictToClientFlag = EMP2:RestrictToClientFlag
  GLO:FilterMatterTypeFlag = EMP2:FilterMatterTypeFlag
  GLO:FilterMatterTypeID = EMP2:FilterMatterTypeID
  GLO:FilterEmployeeFlag = EMP2:FilterEmployeeFlag
  GLO:FilterEmployeeID = EMP2:FilterEmployeeID
  
  GLO:FilterStageFlag = EMP2:FilterStageFlag
  GLO:FilterStageID = EMP2:FilterStageID
  CEM:FilterStagesInListFlag = EMP2:FilterStagesInListFlag
  CEM:FilterStagesNotInListFlag = EMP2:FilterStagesNotInListFlag
  
  
  GLO:FilterCostCentreFlag = EMP2:FilterCostCentreFlag
  GLO:FilterCostCentreID = EMP2:FilterCostCentreID
  GLO:FilterBranchFlag = EMP2:FilterBranchFlag
  GLO:RestrictToBranchList = EMP2:RestrictToBranchList
  GLO:RestrictToCriticalStepList = EMP2:RestrictToCriticalStepList
  GLO:FilterCriticalStepsNotInList = EMP2:FilterCriticalStepsNotInList
  GLO:FilterCriticalStepsNotInListFlag = EMP2:FilterCriticalStepsNotInListFlag


  GLO:RestrictToEmployeeList = EMP2:RestrictToEmployeeList
  GLO:RestrictToDocGenList = EMP2:RestrictToDocGenList
  GLO:RestrictToMatterTypeList = EMP2:RestrictToMatterTypeList
  GLO:RestrictToCostCentreList = EMP2:RestrictToCostCentreList
  GLO:FilterDocgenFlag      = EMP2:FilterDocgenFlag
  GLO:FilterDocgenID        = EMP2:FilterDocgenID
  GLO:FilterSheriffAreaFlag      = EMP2:FilterSheriffAreaFlag
  GLO:FilterSheriffAreaID        = EMP2:FilterSheriffAreaID
  GLO:FilterDateFlag = EMP2:FilterDateFlag
  GLO:FilterFromDate = EMP2:FilterFromDate
  GLO:FilterToDate = EMP2:FilterToDate
  GLO:FilterGroupFlag = EMP2:FilterGroupFlag
  GLO:FilterGroupID = EMP2:FilterGroupID
  GLO:FilterStatusLiveFlag    =  EMP2:FilterStatusLiveFlag
  GLO:FilterStatusPendingFlag =  EMP2:FilterStatusPendingFlag
  GLO:FilterStatusArchiveFlag =  EMP2:FilterStatusArchiveFlag
  GLO:FilterMattersBy = EMP2:FilterMattersBy
  GLO:FilterBalances = EMP2:FilterBalances

  GLO:FilterAging    = EMP2:FilterAging
  GLO:FilterLastInvoiceDate    = EMP2:FilterLastInvoiceDate

  CEM:FilterDateOption = EMP2:FilterDateOption
  CEM:FilterDateType = EMP2:FilterDateType
  !FB1981
  CEM:FilterPartyRoleFlag =  EMP2:FilterPartyRoleFlag
  CEM:FilterParty1ID      =  EMP2:FilterParty1ID
  CEM:FilterRole1ID       =  EMP2:FilterRole1ID 
  CEM:FilterParty2ID      =  EMP2:FilterParty2ID
  CEM:FilterRole2ID       =  EMP2:FilterRole2ID 
  CEM:FilterParty3ID      =  EMP2:FilterParty3ID
  CEM:FilterRole3ID       =  EMP2:FilterRole3ID 
  !END FB1981
  CEM:FilterInactiveMattersFlag = EMP2:FilterInactiveMattersFlag
  CEM:FilterInactiveFileNotesFlag = EMP2:FilterInactiveFileNotesFlag
  CEM:FilterFileNotesOption = EMP2:FilterFileNotesOption
  CEM:FilterInactiveFeeNotesFlag = EMP2:FilterInactiveFeeNotesFlag
  CEM:FilterInactiveToDoNotesFlag = EMP2:FilterInactiveToDoNotesFlag
  CEM:FilterInactiveColDebitFlag = EMP2:FilterInactiveColDebitFlag
  CEM:FilterInactiveMatTranFlag = EMP2:FilterInactiveMatTranFlag
  CEM:FilterInactiveDays = EMP2:FilterInactiveDays

  CEM:LastStageDays = EMP2:LastStageDays

  ReturnValue = PARENT.TakeCompleted()
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
  OF ?LOC:Employee
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
    END
  OF ?LOC:Docgen
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
    END
  OF ?LOC:Party
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
    END
  OF ?LOC:CostCentre
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
    END
  OF ?LOC:Branch
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
    END
  OF ?LOC:CriticalStep
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
    END
  OF ?LOC:CriticalStepNotIn
    CASE EVENT()
    OF EVENT:AlertKey
          If Keycode() = DownKey or Keycode() = UpKey Then Post(EVENT:NewSelection,?).
    END
  END
  DO ResetTheScreen

  ReturnValue = PARENT.TakeFieldEvent()
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
    OF ?LOC:Employee
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        EMP:Name = Contents(?)
        Set(EMP:NameKey,EMP:NameKey)
        If KeyCode() = DownKey Then Next(Employee).
        If KeyCode() = UpKey Then Previous(Employee).
        Loop
          If KeyCode() = UpKey Then Previous(Employee) Else Next(Employee).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (Employee) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(EMP:SuspendedFlag <> 1) Then Cycle.
          If ~(Upper(Contents(?)) = Upper(Sub(EMP:Name,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,EMP:Name)
            ?{PROP:SelEnd} = Len(EMP:Name)
            ?{PROP:Touched} = True
            LOC:Employee = EMP:Name
            EMP2:RestrictToEmployeeList = EMP:RecordID
      
            Display
      
      
            Break
          .
          SetKeycode(0)
        .
    OF ?LOC:MatterType
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        MT:Description = Contents(?)
        Set(MT:DescriptionKey,MT:DescriptionKey)
        If KeyCode() = DownKey Then Next(MatType).
        If KeyCode() = UpKey Then Previous(MatType).
        Loop
          If KeyCode() = UpKey Then Previous(MatType) Else Next(MatType).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (MatType) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
      
          If ~(Upper(Contents(?)) = Upper(Sub(MT:Description,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,MT:Description)
            ?{PROP:SelEnd} = Len(MT:Description)
            ?{PROP:Touched} = True
            LOC:MatterType = MT:Description
            EMP2:RestrictToMatterTypeList = MT:RecordID
      
            Display
      
      
            Break
          .
          SetKeycode(0)
        .
    OF ?LOC:Docgen
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        DG:Description = Contents(?)
        Set(DG:DescriptionKey,DG:DescriptionKey)
        If KeyCode() = DownKey Then Next(Docgen).
        If KeyCode() = UpKey Then Previous(Docgen).
        Loop
          If KeyCode() = UpKey Then Previous(Docgen) Else Next(Docgen).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (Docgen) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(Upper(Contents(?)) = Upper(Sub(DG:Description,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,DG:Description)
            ?{PROP:SelEnd} = Len(DG:Description)
            ?{PROP:Touched} = True
            LOC:Docgen = DG:Description
            EMP2:RestrictToDocGenList = DG:RecordID
      
            Display
      
      
            Break
          .
          SetKeycode(0)
        .
    OF ?LOC:Party
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        PAR:Name = Contents(?)
        Set(PAR:NameKey,PAR:NameKey)
        If KeyCode() = DownKey Then Next(Party).
        If KeyCode() = UpKey Then Previous(Party).
        Loop
          If KeyCode() = UpKey Then Previous(Party) Else Next(Party).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (Party) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(Upper(Contents(?)) = Upper(Sub(PAR:Name,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,PAR:Name)
            ?{PROP:SelEnd} = Len(PAR:Name)
            ?{PROP:Touched} = True
            LOC:Party = PAR:Name
            EMP2:RestrictToClientList = PAR:RecordID
            Display
      
      
            Break
          .
          SetKeycode(0)
        .
    OF ?LOC:CostCentre
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        COS:Description = Contents(?)
        Set(COS:DescriptionKey,COS:DescriptionKey)
        If KeyCode() = DownKey Then Next(CostCentre).
        If KeyCode() = UpKey Then Previous(CostCentre).
        Loop
          If KeyCode() = UpKey Then Previous(CostCentre) Else Next(CostCentre).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (CostCentre) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(Upper(Contents(?)) = Upper(Sub(COS:Description,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,COS:Description)
            ?{PROP:SelEnd} = Len(COS:Description)
            ?{PROP:Touched} = True
            LOC:CostCentre = COS:Description
            EMP2:RestrictToCostCentreList = COS:RecordID
      
            Display
      
      
            Break
          .
          SetKeycode(0)
        .
    OF ?LOC:Branch
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        BRA:Description = Contents(?)
        Set(BRA:DescriptionKey,BRA:DescriptionKey)
        If KeyCode() = DownKey Then Next(Branch).
        If KeyCode() = UpKey Then Previous(Branch).
        Loop
          If KeyCode() = UpKey Then Previous(Branch) Else Next(Branch).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (Branch) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(Upper(Contents(?)) = Upper(Sub(BRA:Description,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,BRA:Description)
            ?{PROP:SelEnd} = Len(BRA:Description)
            ?{PROP:Touched} = True
            LOC:Branch = BRA:Description
            EMP2:RestrictToBranchList = BRA:RecordID
      
      
      
            Display
      
      
            Break
          .
          SetKeycode(0)
        .
    OF ?LOC:CriticalStep
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        CRI:Description = Contents(?)
        Set(CRI:DescriptionKey,CRI:DescriptionKey)
        If KeyCode() = DownKey Then Next(CriticalStep).
        If KeyCode() = UpKey Then Previous(CriticalStep).
        Loop
          If KeyCode() = UpKey Then Previous(CriticalStep) Else Next(CriticalStep).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (CriticalStep) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(Upper(Contents(?)) = Upper(Sub(CRI:Description,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,CRI:Description)
            ?{PROP:SelEnd} = Len(CRI:Description)
            ?{PROP:Touched} = True
            EMP2:RestrictToCriticalStepList = CRI:RecordID
      
            Display
      
      
            Post(EVENT:Accepted,?LOC:CriticalStep)
            Break
          .
          SetKeycode(0)
        .
    OF ?LOC:CriticalStepNotIn
        Update(?)
        ?{PROP:Touched} = True
        If Keycode() = DeleteKey or Keycode() = BSKey Then Cycle.
        a# = Len(Clip(Contents(?)))
        b# = ?{PROP:SelStart}
        If a# = b# - 1 or Keycode() = UpKey or Keycode() = DownKey
        CRI:Description = Contents(?)
        Set(CRI:DescriptionKey,CRI:DescriptionKey)
        If KeyCode() = DownKey Then Next(CriticalStep).
        If KeyCode() = UpKey Then Previous(CriticalStep).
        Loop
          If KeyCode() = UpKey Then Previous(CriticalStep) Else Next(CriticalStep).
          If Errorcode() = 33 Then Break.
          If Errorcode()
            Message('Error Reading File (CriticalStep) |Error :' & Error(),'Auto Complete Error','ICON:Exclamation')
            Break
          .
          If ~(Upper(Contents(?)) = Upper(Sub(CRI:Description,1,a#)) or Keycode() = UpKey or Keycode() = DownKey) Then Break.
            Change(?,CRI:Description)
            ?{PROP:SelEnd} = Len(CRI:Description)
            ?{PROP:Touched} = True
            EMP2:FilterCriticalStepsNotInList = CRI:RecordID
            Display
      
      
            Post(EVENT:Accepted,?LOC:CriticalStepNotIn)
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
  SP:Description = 'Matters - Filter Screen'
  IF Access:SecProc.TryFetch(SP:SecGroupKey) Then Access:SecProc.Insert().
  If ~SP:AccessFlag and ~GLO:SupervisorFlag
    Message('Access Denied||Your security settings do not allow you access to this area of the program.|',SP:Description,'~lock.ico')
    Return Level:Notify
  .
  Return Level:Benign

ThisSecProc.Update  PROCEDURE()
  Code
    Free(GFQ:FieldQueue)
    BrowseSecProc('Matters - Filter Screen',0)
    Return Level:Benign
UpdateEmpDefaultFilter PROCEDURE                      !Generated from procedure template - Window

CurrentTab           STRING(80)
LOC:Language         CSTRING(20)
FilesOpened          BYTE
ezField              LONG
ActionMessage        CSTRING(40)
LOC:LookupPropText   STRING(2)
QuickWindow          WINDOW('Matter Filter'),AT(,,281,53),FONT('Arial',9,,),CENTER,IMM,HLP('UpdateFeeDesc'),SYSTEM,GRAY,RESIZE,MDI
                       PROMPT('&Description:'),AT(8,12),USE(?FD:Description:Prompt)
                       TEXT,AT(52,12,217,10),USE(EDF:Description),TIP('The wording for this language<13,10>FT:Description'),SINGLE
                       BUTTON('&OK'),AT(149,29,60,20),USE(?OK),LEFT,FONT(,11,,),ICON('check3.ico'),DEFAULT
                       BUTTON('&Cancel'),AT(215,29,60,20),USE(?Cancel),LEFT,FONT(,11,,),ICON('delete32.ico')
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
ToolbarForm          ToolbarUpdateClass               !Form Toolbar Manager
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
    ActionMessage = 'Adding a Filter'
  OF ChangeRecord
    ActionMessage = 'Changing a Filter'
  END
  QuickWindow{Prop:Text} = ActionMessage
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('UpdateEmpDefaultFilter')
  SELF.Request = GlobalRequest
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?FD:Description:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)
  CLEAR(GlobalResponse)
  SELF.AddUpdateFile(Access:EmpDefaultFilter)
  SELF.AddItem(?Cancel,RequestCancelled)
  Relate:EmpDefaultFilter.Open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:EmpDefaultFilter
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
  IF SELF.Request = InsertRecord

     EDF:EmployeeID = CEM:RecordID
     !IF Access:EmpDefaultFilter.Fetch(EDF:PrimaryKey)
     !   EDF:EmployeeID = EMP2:RecordID
     !   Access:EmpDefaultFilter.Insert
     !END

     EDF:FilterInactiveMattersFlag = EMP2:FilterInactiveMattersFlag
     EDF:FilterInactiveFileNotesFlag = EMP2:FilterInactiveFileNotesFlag
     EDF:FilterFileNotesOption = EMP2:FilterFileNotesOption
     EDF:FilterInactiveFeeNotesFlag = EMP2:FilterInactiveFeeNotesFlag
     EDF:FilterInactiveToDoNotesFlag = EMP2:FilterInactiveToDoNotesFlag
     EDF:FilterInactiveColDebitFlag = EMP2:FilterInactiveColDebitFlag
     EDF:FilterInactiveMatTranFlag = EMP2:FilterInactiveMatTranFlag
     EDF:FilterInactiveDays = EMP2:FilterInactiveDays




     EDF:FilterMatterTypeID = 0 ! DEPRECATE THIS
     EDF:FilterEmployeeID = 0 ! DEPRECATE THIS
     EDF:FilterCostCentreID = 0 ! DEPRECATE THIS
     EDF:FilterBranchID = 0 ! DEPRECATE THIS
     EDF:FilterDocgenID = 0 ! DEPRECATE THIS


     EDF:FilterMatterTypeFlag = EMP2:FilterMatterTypeFlag
     EDF:FilterBranchFlag = EMP2:FilterBranchFlag
     EDF:RestrictToBranchList = EMP2:RestrictToBranchList
     EDF:RestrictToCriticalStepList = EMP2:RestrictToCriticalStepList


     EDF:FilterConveyancingStatusFlag  = EMP2:FilterConveyancingStatusFlag
     EDF:FilterConveyancingStatus  = EMP2:FilterConveyancingStatus


     EDF:FilterCriticalStepsNotInList = EMP2:FilterCriticalStepsNotInList
     EDF:FilterCriticalStepsNotInListFlag = EMP2:FilterCriticalStepsNotInListFlag
     EDF:FilterCriticalStepsInListFlag = EMP2:FilterCriticalStepsInListFlag

     EDF:RestrictToEmployeeList = EMP2:RestrictToEmployeeList
     EDF:RestrictToDocGenList = EMP2:RestrictToDocGenList
     EDF:RestrictToMatterTypeList = EMP2:RestrictToMatterTypeList
     EDF:RestrictToCostCentreList = EMP2:RestrictToCostCentreList
     EDF:FilterCostCentreFlag = EMP2:FilterCostCentreFlag
     EDF:FilterGroupFlag  = EMP2:FilterGroupFlag
     EDF:FilterGroupID  = EMP2:FilterGroupID
     EDF:FilterEmployeeFlag  = EMP2:FilterEmployeeFlag
     EDF:FilterDateFlag  = EMP2:FilterDateFlag
     EDF:FilterDateOption = EMP2:FilterDateOption
     EDF:FilterFromDate  = EMP2:FilterFromDate
     EDF:FilterToDate  = EMP2:FilterToDate
     EDF:FilterDocgenFlag  = EMP2:FilterDocgenFlag
     EDF:FilterSheriffAreaFlag  = EMP2:FilterSheriffAreaFlag
     EDF:FilterSheriffAreaID  = EMP2:FilterSheriffAreaID 
     EDF:FilterEmployeeID  = EMP2:FilterEmployeeID
     EDF:FilterMattersBy = EMP2:FilterMattersBy
     EDF:FilterBalances  = EMP2:FilterBalances
     EDF:FilterAging  = EMP2:FilterAging
     EDF:FilterFavouritesFlag  = EMP2:FilterFavouritesFlag
     EDF:FilterDebtLinkFlag  = EMP2:FilterDebtLinkFlag
     EDF:FilterDebtLinkCategory  = EMP2:FilterDebtLinkCategory
     EDF:FilterStatusArchiveFlag  = EMP2:FilterStatusArchiveFlag
     EDF:FilterStatusPendingFlag  = EMP2:FilterStatusPendingFlag
     EDF:FilterStatusLiveFlag  = EMP2:FilterStatusLiveFlag
     EDF:FilterStageFlag  = EMP2:FilterStageFlag
     EDF:FilterStageID  = EMP2:FilterStageID
     EDF:FilterParGroupFlag  = EMP2:FilterParGroupFlag
     EDF:FilterParGroupID  = EMP2:FilterParGroupID
     EDF:FilterParRegionFlag  = EMP2:FilterParRegionFlag
     EDF:FilterParCategoryFlag  = EMP2:FilterParCategoryFlag
     EDF:FilterParAnyStageFlag  = EMP2:FilterParAnyStageFlag
     EDF:FilterParLastStageFlag  = EMP2:FilterParLastStageFlag
     EDF:FilterParRegionID  = EMP2:FilterParRegionID
     EDF:FilterParCategoryID  = EMP2:FilterParCategoryID
     EDF:FilterParAnyStageID  = EMP2:FilterParAnyStageID
     EDF:FilterParLastStageID = EMP2:FilterParLastStageID
     EDF:RestrictToClientList = EMP2:RestrictToClientList
     EDF:FilterStagesInListFlag = EMP2:FilterStagesInListFlag
     EDF:FilterStagesNotInListFlag = EMP2:FilterStagesNotInListFlag
     EDF:FilterStagesInList = EMP2:FilterStagesInList
     EDF:FilterStagesNotInList = EMP2:FilterStagesNotInList
  END

!Access:EmpDefaultFilter.TryUpdate
!MESSAGE('Default filtering options were saved succesfully.||You can invoke these Filter settings at any time by pressing ALT-F8 from the Desktop.||Note: You can also clear the Matter filter at any time by pressing ALT-F9.','Default Filter Updated',ICON:Exclamation)


  OPEN(QuickWindow)
  SELF.Opened=True
       QuickWindow{Prop:Alrt,254}=1024
       QuickWindow{Prop:Alrt,255}=AltF12
  SELF.AddItem(ToolbarForm)
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:EmpDefaultFilter.Close
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
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
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
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

FilterPartyRoles PROCEDURE                            !Generated from procedure template - Window

LOC:FirstPartyID     LONG
LOC:Result           CSTRING(255)
LOC:FirstPartyName   CSTRING(255)
LOC:FirstPartyRoleID LONG
LOC:FirstPartyRoleName CSTRING(255)
LOC:SecondPartyID    LONG
LOC:SecondPartyName  CSTRING(255)
LOC:SecondPartyRoleID LONG
LOC:SecondPartyRoleName CSTRING(255)
LOC:ThirdPartyID     LONG
LOC:ThirdPartyName   CSTRING(255)
LOC:ThirdPartyRoleID LONG
LOC:ThirdPartyRoleName CSTRING(255)
Window               WINDOW('Filter by Party and Role'),AT(,,198,260),FONT('Arial',9,,FONT:regular),CENTER,SYSTEM,GRAY,DOUBLE,MDI,MODAL
                       STRING('Display Matters where a Party plays a specific Role'),AT(6,4),USE(?String3)
                       GROUP('First Party'),AT(5,17,187,68),USE(?Group1),BOXED
                         STRING('Party'),AT(11,31,25,11),USE(?String1)
                         TEXT,AT(43,30,130,12),USE(LOC:FirstPartyName),DISABLE
                         BUTTON('...'),AT(177,31,10,10),USE(?SelectFirstParty),TIP('Select a Party for this Party/Role Combination')
                         STRING('Role'),AT(11,47,25,11),USE(?String2)
                         ENTRY(@s254),AT(43,47,130,12),USE(LOC:FirstPartyRoleName),DISABLE
                         BUTTON('...'),AT(177,48,10,10),USE(?SelectFirstPartyRole),TIP('Select a Role for this Party/Role Combination')
                         BUTTON('C&lear'),AT(141,66,45,14),USE(?ClearFirstGroup),LEFT,TIP('Clear this Party/Role Combination'),ICON('smcross.ico')
                       END
                       GROUP('Second Party'),AT(5,89,187,68),USE(?Group2),BOXED
                         STRING('Party'),AT(11,103,25,11),USE(?String1:2)
                         TEXT,AT(43,102,130,12),USE(LOC:SecondPartyName),DISABLE
                         BUTTON('...'),AT(177,103,10,10),USE(?SelectSecondParty),TIP('Select a Party for this Party/Role Combination')
                         STRING('Role'),AT(11,119,25,11),USE(?String2:2)
                         ENTRY(@s254),AT(43,119,130,12),USE(LOC:SecondPartyRoleName),DISABLE
                         BUTTON('...'),AT(177,121,10,10),USE(?SelectSecondPartyRole),TIP('Select a Role for this Party/Role Combination')
                         BUTTON('Clear'),AT(141,138,45,14),USE(?ClearSecondGroup),LEFT,TIP('Clear this Party/Role Combination'),ICON('smcross.ico')
                       END
                       GROUP('Third Party'),AT(5,161,187,68),USE(?Group3),BOXED
                         STRING('Party'),AT(12,175,25,11),USE(?String1:3)
                         TEXT,AT(44,175,130,12),USE(LOC:ThirdPartyName),DISABLE
                         BUTTON('...'),AT(177,175,10,10),USE(?SelectThirdParty),TIP('Select a Party for this Party/Role Combination')
                         STRING('Role'),AT(12,191,25,11),USE(?String2:3)
                         ENTRY(@s254),AT(44,191,130,12),USE(LOC:ThirdPartyRoleName),DISABLE
                         BUTTON('...'),AT(177,193,10,10),USE(?SelectThirdPartyRole),TIP('Select a Role for this Party/Role Combination')
                         BUTTON('Clear'),AT(141,210,45,14),USE(?ClearThirdGroup),LEFT,TIP('Clear this Party/Role Combination'),ICON('smcross.ico')
                       END
                       BUTTON('&OK'),AT(70,234,60,22),USE(?OkButton),LEFT,FONT(,11,,),ICON('check3.ico'),DEFAULT
                       BUTTON('&Cancel'),AT(134,234,60,22),USE(?CancelButton),LEFT,FONT(,11,,),ICON('delete32.ico')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Open                   PROCEDURE(),DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeCloseEvent         PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass

  CODE
  GlobalResponse = ThisWindow.Run()

DisplayNames Routine
    if LOC:FirstPartyID
        PROPSQLNext('SELECT 0,Name FROM Party WHERE RecordID = ' & LOC:FirstPartyID)
        LOC:FirstPartyName = ROW:Description
        DISPLAY
    end
    if LOC:FirstPartyRoleID
        PROPSQLNext('SELECT 0,Description FROM ROLE WHERE RecordID = ' & LOC:FirstPartyRoleID)
        LOC:FirstPartyRoleName = ROW:Description
        DISPLAY
    end
    if LOC:SecondPartyID 
        PROPSQLNext('SELECT 0,Name FROM Party WHERE RecordID = ' & LOC:SecondPartyID)
        LOC:SecondPartyName = ROW:Description
        DISPLAY
    end
    if LOC:SecondPartyRoleID
        PROPSQLNext('SELECT 0,Description FROM ROLE WHERE RecordID = ' & LOC:SecondPartyRoleID)
        LOC:SecondPartyRoleName = ROW:Description
        DISPLAY
    end
    if LOC:ThirdPartyID 
        PROPSQLNext('SELECT 0,Name FROM Party WHERE RecordID = ' & LOC:ThirdPartyID)
        LOC:ThirdPartyName = ROW:Description
        DISPLAY
    end
    if LOC:ThirdPartyRoleID
        PROPSQLNext('SELECT 0,Description FROM ROLE WHERE RecordID = ' & LOC:ThirdPartyRoleID)
        LOC:ThirdPartyRoleName = ROW:Description
        DISPLAY
    end

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('FilterPartyRoles')
  SELF.Request = GlobalRequest
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?String3
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)
  CLEAR(GlobalResponse)
  SELF.AddItem(?OkButton,RequestCompleted)
  SELF.AddItem(?CancelButton,RequestCancelled)
  OPEN(Window)
  SELF.Opened=True
       Window{Prop:Alrt,254}=1024
       Window{Prop:Alrt,255}=AltF12
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Open PROCEDURE

  CODE
  PARENT.Open
    IF EMP2:FilterParty1ID THEN LOC:FirstPartyID =EMP2:FilterParty1ID .
    IF EMP2:FilterRole1ID THEN LOC:FirstPartyRoleID =EMP2:FilterRole1ID .
    IF EMP2:FilterParty2ID THEN LOC:SecondPartyID =EMP2:FilterParty2ID .
    IF EMP2:FilterRole2ID THEN LOC:SecondPartyRoleID =EMP2:FilterRole2ID .
    IF EMP2:FilterParty3ID THEN LOC:ThirdPartyID =EMP2:FilterParty3ID .
    IF EMP2:FilterRole3ID THEN LOC:ThirdPartyRoleID =EMP2:FilterRole3ID .
    Do DisplayNames


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
    OF ?SelectFirstParty
       GlobalRequest = SelectRecord
             BrowseParty
             If GlobalResponse = RequestCompleted
               LOC:FirstPartyName = PAR:Name
               LOC:FirstPartyID = PAR:RecordID
               Display
             End
             
              
    OF ?SelectFirstPartyRole
         GlobalRequest = SelectRecord
              BrowseRole
              IF GlobalResponse = RequestCompleted           ! IF Lookup completed
                 LOC:FirstPartyRoleID = ROL:RecordId
                 LOC:FirstPartyRoleName = ROL:Description
                 Display
              end
    OF ?ClearFirstGroup
       LOC:FirstPartyID = 0
        LOC:FirstPartyName = ''
        LOC:FirstPartyRoleID = 0
        LOC:FirstPartyRoleName = ''
        Display
    OF ?SelectSecondParty
       GlobalRequest = SelectRecord
             BrowseParty
             If GlobalResponse = RequestCompleted
               LOC:SecondPartyName = PAR:Name
               LOC:SecondPartyID = PAR:RecordID
               Display
             End
    OF ?SelectSecondPartyRole
         GlobalRequest = SelectRecord
              BrowseRole
              IF GlobalResponse = RequestCompleted           ! IF Lookup completed
                 LOC:SecondPartyRoleID = ROL:RecordId
                 LOC:SecondPartyRoleName = ROL:Description
                 Display
              end
    OF ?ClearSecondGroup
       LOC:SecondPartyID = 0
        LOC:SecondPartyName = ''
        LOC:SecondPartyRoleID = 0
        LOC:SecondPartyRoleName = ''
        Display
    OF ?SelectThirdParty
       GlobalRequest = SelectRecord
             BrowseParty
             If GlobalResponse = RequestCompleted
               LOC:ThirdPartyName = PAR:Name
               LOC:ThirdPartyID = PAR:RecordID
               Display
             End
    OF ?SelectThirdPartyRole
         GlobalRequest = SelectRecord
              BrowseRole
              IF GlobalResponse = RequestCompleted           ! IF Lookup completed
                 LOC:ThirdPartyRoleID = ROL:RecordId
                 LOC:ThirdPartyRoleName = ROL:Description
                 Display
              end
    OF ?ClearThirdGroup
        LOC:ThirdPartyID = 0
        LOC:ThirdPartyName = ''
        LOC:ThirdPartyRoleID = 0
        LOC:ThirdPartyRoleName = ''
        Display
           
    OF ?OkButton
      LOC:Result = ''
      !IF LOC:FirstPartyID AND LOC:FirstPartyRoleID
        EMP2:FilterParty1ID = LOC:FirstPartyID
        EMP2:FilterRole1ID = LOC:FirstPartyRoleID
      !END
      !IF LOC:SecondPartyID AND LOC:SecondPartyRoleID
        EMP2:FilterParty2ID = LOC:SecondPartyID
        EMP2:FilterRole2ID = LOC:SecondPartyRoleID
      !END
      !IF LOC:ThirdPartyID AND LOC:ThirdPartyRoleID
        EMP2:FilterParty3ID = LOC:ThirdPartyID
        EMP2:FilterRole3ID = LOC:ThirdPartyRoleID
      !END
    END
  ReturnValue = PARENT.TakeAccepted()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeCloseEvent PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
   
  ReturnValue = PARENT.TakeCloseEvent()
  RETURN ReturnValue

