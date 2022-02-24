

   MEMBER('MASTER.clw')                               ! This is a MEMBER module

                     MAP
                       INCLUDE('MASTE203.INC'),ONCE        !Local module procedure declarations
                     END


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
GetMatterFilterString PROCEDURE                       ! Declare Procedure
LOC:ReturnString           CSTRING(10000)
TMP:FilterString           CSTRING(255)
LOC:InactiveFromDate       LONG
LOC:ActiveMattersSQLString CSTRING(300)

  CODE
  IF GLO:FilterDateFlag AND GLO:FilterToDate AND CEM:FilterDateType

     IF LOC:ReturnString Then LOC:ReturnString = Clip(LOC:ReturnString) & ' AND '.

     IF CEM:FilterDateType = 'I'  ! INSTRUCTED
         LOC:ReturnString = LOC:ReturnString & 'Matter.DateInstructed >= ' & GLO:FilterFromDate & ' AND Matter.DateInstructed <<= ' & GLO:FilterToDate
     ELSIF CEM:FilterDateType = 'L'  ! LODGED
         LOC:ReturnString = LOC:ReturnString & 'ConveyData.Step4Completed >= ' & GLO:FilterFromDate & ' AND ConveyData.Step4Completed <<= ' & GLO:FilterToDate
     ELSIF CEM:FilterDateType = 'R'  ! REGISTERED
         LOC:ReturnString = LOC:ReturnString & 'ConveyData.Step6Completed >= ' & GLO:FilterFromDate & ' AND ConveyData.Step6Completed <<= ' & GLO:FilterToDate
     ELSIF CEM:FilterDateType = 'M'  ! IMPORTANT DATE
         LOC:ReturnString = LOC:ReturnString & 'Matter.ImportantDate >= ' & GLO:FilterFromDate & ' AND Matter.ImportantDate <<= ' & GLO:FilterToDate
     ELSIF CEM:FilterDateType = 'P'  ! PRESCRIPTION DATE
         LOC:ReturnString = LOC:ReturnString & 'Matter.PrescriptionDate >= ' & GLO:FilterFromDate & ' AND Matter.PrescriptionDate <<= ' & GLO:FilterToDate
     END

  END

  IF GLO:RestrictToBranchList AND GLO:FilterBranchFlag
     IF LOC:ReturnString 
        LOC:ReturnString = LOC:ReturnString & ' AND Matter.BranchID IN (' & GLO:RestrictToBranchList & ')'
     ELSE
        LOC:ReturnString = 'Matter.BranchID IN (' & GLO:RestrictToBranchList & ')'
     END
  END

  IF GLO:RestrictToCriticalStepList 

     IF LOC:ReturnString
        LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.RecordID IN (SELECT DISTINCT MatterID FROM ToDoNote JOIN ToDoItem ON ToDoItem.RecordID = ToDoNote.ToDoItemID WHERE CriticalStep IN (' & GLO:RestrictToCriticalStepList & ') AND DateDone > 0)'
     ELSE
        LOC:ReturnString = 'Matter.RecordID IN (SELECT DISTINCT MatterID FROM ToDoNote JOIN ToDoItem ON ToDoItem.RecordID = ToDoNote.ToDoItemID WHERE CriticalStep IN (' & GLO:RestrictToCriticalStepList & ') AND DateDone > 0) '
     END

  END


  IF GLO:FilterCriticalStepsNotInListFlag 

     IF LOC:ReturnString
        LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.RecordID IN (SELECT DISTINCT MatterID FROM ToDoNote JOIN ToDoItem ON ToDoItem.RecordID = ToDoNote.ToDoItemID WHERE CriticalStep IN (' & GLO:FilterCriticalStepsNotInList & ') AND DateDone = 0)'
     ELSE
        LOC:ReturnString = 'Matter.RecordID IN (SELECT DISTINCT MatterID FROM ToDoNote JOIN ToDoItem ON ToDoItem.RecordID = ToDoNote.ToDoItemID WHERE CriticalStep IN (' & GLO:FilterCriticalStepsNotInList & ') AND DateDone = 0)'
     END

  END



  IF GLO:RestrictToEmployeeList AND GLO:FilterEmployeeFlag
     IF LOC:ReturnString 
        LOC:ReturnString = LOC:ReturnString & ' AND Matter.EmployeeID IN (' & GLO:RestrictToEmployeeList & ')'
     ELSE
        LOC:ReturnString = 'Matter.EmployeeID IN (' & GLO:RestrictToEmployeeList & ')'
     END
  END

  IF GLO:RestrictToDocGenList AND GLO:FilterDocGenFlag
     IF LOC:ReturnString 
        LOC:ReturnString = LOC:ReturnString & ' AND Matter.DocGenID IN (' & GLO:RestrictToDocGenList & ')'
     ELSE
        LOC:ReturnString = 'Matter.DocGenID IN (' & GLO:RestrictToDocGenList & ')'
     END
  END

  IF GLO:RestrictToMatterTypeList AND GLO:FilterMatterTypeFlag
     IF LOC:ReturnString 
        LOC:ReturnString = LOC:ReturnString & ' AND Matter.MatterTypeID IN (' & GLO:RestrictToMatterTypeList & ')'
     ELSE
        LOC:ReturnString = 'Matter.MatterTypeID IN (' & GLO:RestrictToMatterTypeList & ')'
     END
  END

  IF GLO:RestrictToCostCentreList AND GLO:FilterCostCentreFlag
     IF LOC:ReturnString 
        LOC:ReturnString = LOC:ReturnString & ' AND Matter.CostCentreID IN (' & GLO:RestrictToCostCentreList & ')'
     ELSE
        LOC:ReturnString = 'Matter.CostCentreID IN (' & GLO:RestrictToCostCentreList & ')'
     END
  END

  IF GLO:FilterSheriffAreaFlag
    IF LOC:ReturnString Then LOC:ReturnString = Clip(LOC:ReturnString) & ' and '.
    LOC:ReturnString = LOC:ReturnString & 'Matter.SheriffAreaID = ' & GLO:FilterSheriffAreaID
  END
  


  IF GLO:FilterMattersBy

!      GLO:FilterMattersBy = Replace(GLO:FilterMattersBy,'Matter.','A.')
!      GLO:FilterMattersBy = Replace(GLO:FilterMattersBy,'ConveyData.','B.')
!      GLO:FilterMattersBy = Replace(GLO:FilterMattersBy,'MatType.','C.')
!      GLO:FilterMattersBy = Replace(GLO:FilterMattersBy,'Docgen.','D.')
!      GLO:FilterMattersBy = Replace(GLO:FilterMattersBy,'Party.','E.')

      GLO:FilterMattersBy = Replace(GLO:FilterMattersBy,'MAT:','Matter.')
      GLO:FilterMattersBy = Replace(GLO:FilterMattersBy,'CONV:','ConveyData.')
      GLO:FilterMattersBy = Replace(GLO:FilterMattersBy,'MT:','MatType.')
      GLO:FilterMattersBy = Replace(GLO:FilterMattersBy,'DG:','Docgen.')
      GLO:FilterMattersBy = Replace(GLO:FilterMattersBy,'PAR:','Party.')

      IF LOC:ReturnString Then LOC:ReturnString = Clip(LOC:ReturnString) & ' AND '.

      LOC:ReturnString = LOC:ReturnString & GLO:FilterMattersBy

  END


  ! Filter Matter Status (Live,Pending, Archived)
  Case GLO:FilterStatusLiveFlag + GLO:FilterStatusPendingFlag + GLO:FilterStatusArchiveFlag
  Of 1
    If LOC:ReturnString Then LOC:ReturnString = Clip(LOC:ReturnString) & ' and '.
    If GLO:FilterStatusLiveFlag Then LOC:ReturnString = LOC:ReturnString & '(Matter.ArchiveStatus = 0 OR Matter.ArchiveStatus IS NULL)'.
    If GLO:FilterStatusPendingFlag Then LOC:ReturnString = LOC:ReturnString & 'Matter.ArchiveStatus = 1'.
    If GLO:FilterStatusArchiveFlag Then LOC:ReturnString = LOC:ReturnString & 'Matter.ArchiveStatus = 2'.
  Of 2
    If LOC:ReturnString Then LOC:ReturnString = Clip(LOC:ReturnString) & ' and '.
    If GLO:FilterStatusLiveFlag and GLO:FilterStatusPendingFlag
      LOC:ReturnString = LOC:ReturnString & 'Matter.ArchiveStatus <> 2'
    ElsIf GLO:FilterStatusLiveFlag and GLO:FilterStatusArchiveFlag
      LOC:ReturnString = LOC:ReturnString & 'Matter.ArchiveStatus <> 1'
    Else
      LOC:ReturnString = LOC:ReturnString & 'Matter.ArchiveStatus <> 0'
    .
  .
  
  ! Financial Settings
  IF Band(GLO:FilterBalances,2^0+2^1+2^2) !  Normal
    TMP:FilterString = ''
    IF Band(GLO:FilterBalances,2^0)
      TMP:FilterString = TMP:FilterString & 'Matter.Actual > 0'
    .
    IF Band(GLO:FilterBalances,2^1)
      IF TMP:FilterString Then TMP:FilterString = Clip(TMP:FilterString) & ' or '.
      TMP:FilterString = TMP:FilterString & 'Matter.Actual < 0'
    .
    IF Band(GLO:FilterBalances,2^2)
      IF TMP:FilterString Then TMP:FilterString = Clip(TMP:FilterString) & ' or '.
      TMP:FilterString = TMP:FilterString & 'Matter.Actual = 0'
    .
    IF LOC:ReturnString Then LOC:ReturnString = Clip(LOC:ReturnString) & ' and '.
    LOC:ReturnString = LOC:ReturnString & '(' & TMP:FilterString & ')'
  .

  IF Band(GLO:FilterBalances,2^3+2^4+2^5) ! Invested
    TMP:FilterString = ''
    IF Band(GLO:FilterBalances,2^3)
      TMP:FilterString = TMP:FilterString & 'Matter.Invested > 0'
    .
    IF Band(GLO:FilterBalances,2^4)
      IF TMP:FilterString Then TMP:FilterString = Clip(TMP:FilterString) & ' or '.
      TMP:FilterString = TMP:FilterString & 'Matter.Invested < 0'
    .
    IF Band(GLO:FilterBalances,2^5)
      IF TMP:FilterString Then TMP:FilterString = Clip(TMP:FilterString) & ' or '.
      TMP:FilterString = TMP:FilterString & 'Matter.Invested = 0'
    .
    IF LOC:ReturnString Then LOC:ReturnString = Clip(LOC:ReturnString) & ' and '.
    LOC:ReturnString = LOC:ReturnString & '(' & TMP:FilterString & ')'
  .

  IF Band(GLO:FilterBalances,2^6+2^7+2^8) ! Reserved
    TMP:FilterString = ''
    IF Band(GLO:FilterBalances,2^6) Then TMP:FilterString = TMP:FilterString & 'Matter.Reserved > 0'.
    IF Band(GLO:FilterBalances,2^7)
      IF TMP:FilterString Then TMP:FilterString = Clip(TMP:FilterString) & ' or '.
      TMP:FilterString = TMP:FilterString & 'Matter.Reserved < 0'
    .
    IF Band(GLO:FilterBalances,2^8)
      IF TMP:FilterString Then TMP:FilterString = Clip(TMP:FilterString) & ' or '.
      TMP:FilterString = TMP:FilterString & 'Matter.Reserved = 0'
    .
    IF LOC:ReturnString Then LOC:ReturnString = Clip(LOC:ReturnString) & ' and '.
    LOC:ReturnString = LOC:ReturnString & '(' & TMP:FilterString & ')'
  .
  IF Band(GLO:FilterBalances,2^9+2^10+2^11) ! Transfer
    TMP:FilterString = ''
    IF Band(GLO:FilterBalances,2^9) Then TMP:FilterString = TMP:FilterString & 'Matter.Transfer > 0'.
    IF Band(GLO:FilterBalances,2^10)
      IF TMP:FilterString Then TMP:FilterString = Clip(TMP:FilterString) & ' or '.
      TMP:FilterString = TMP:FilterString & 'Matter.Transfer < 0'
    .
    IF Band(GLO:FilterBalances,2^11)
      IF TMP:FilterString Then TMP:FilterString = Clip(TMP:FilterString) & ' or '.
      TMP:FilterString = TMP:FilterString & 'Matter.Transfer = 0'
    .
    IF LOC:ReturnString Then LOC:ReturnString = Clip(LOC:ReturnString) & ' and '.
    LOC:ReturnString = LOC:ReturnString & '(' & TMP:FilterString & ')'
  .

  If GLO:FilterAging
    TMP:FilterString = ''
    Execute GLO:FilterAging
      TMP:FilterString = 'Matter.Age30Day > 0 or Matter.Age60Day > 0 or Matter.Age90Day > 0 or Matter.Age120Day > 0 or Matter.Age150Day > 0 or Matter.Age180Day > 0'
      TMP:FilterString = 'Matter.Age60Day > 0 or Matter.Age90Day > 0 or Matter.Age120Day > 0 or Matter.Age150Day > 0 or Matter.Age180Day > 0'
      TMP:FilterString = 'Matter.Age90Day > 0 or Matter.Age120Day > 0 or Matter.Age150Day > 0 or Matter.Age180Day > 0'
      TMP:FilterString = 'Matter.Age120Day > 0 or Matter.Age150Day > 0 or Matter.Age180Day > 0'
      TMP:FilterString = 'Matter.Age150Day > 0 or Matter.Age180Day > 0'
      TMP:FilterString = 'Matter.Age180Day > 0'
    .
    IF LOC:ReturnString Then LOC:ReturnString = Clip(LOC:ReturnString) & ' and '.
    LOC:ReturnString = LOC:ReturnString & '(' & TMP:FilterString & ')'
  .



     ! FB# 1564
     IF GLO:FilterLastInvoiceDate
        IF LOC:ReturnString
           LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.LastInvoiceDate <= ' & GLO:FilterLastInvoiceDate
        ELSE
           LOC:ReturnString = 'Matter.LastInvoiceDate <= ' & GLO:FilterLastInvoiceDate
        END
     END



    !RJ
    IF CEM:FilterInactiveMattersFlag

         LOC:InactiveFromDate = GLO:TodaysDate - CEM:FilterInactiveDays
         LOC:ActiveMattersSQLString = ''

         IF CEM:FilterInactiveFileNotesFlag
            IF LOC:ActiveMattersSQLString THEN LOC:ActiveMattersSQLString = LOC:ActiveMattersSQLString & ' UNION'.
            LOC:ActiveMattersSQLString = LOC:ActiveMattersSQLString & ' SELECT MatterID FROM FileNote WHERE Date > ' &  LOC:InactiveFromDate
            IF CEM:FilterFileNotesOption = 'I'
               LOC:ActiveMattersSQLString = LOC:ActiveMattersSQLString & ' AND InternalFlag = 1'
            ELSIF CEM:FilterFileNotesOption = 'E'
               LOC:ActiveMattersSQLString = LOC:ActiveMattersSQLString & ' AND (InternalFlag = 0 OR InternalFlag IS NULL)'
            END
          END

         IF CEM:FilterInactiveFeeNotesFlag
            IF LOC:ActiveMattersSQLString THEN LOC:ActiveMattersSQLString = LOC:ActiveMattersSQLString & ' UNION'.
            LOC:ActiveMattersSQLString = LOC:ActiveMattersSQLString & ' SELECT MatterID FROM FeeNote WHERE Date > ' & LOC:InactiveFromDate
         END

         IF CEM:FilterInactiveToDoNotesFlag
            IF LOC:ActiveMattersSQLString THEN LOC:ActiveMattersSQLString = LOC:ActiveMattersSQLString & ' UNION'.
            LOC:ActiveMattersSQLString = LOC:ActiveMattersSQLString & ' SELECT MatterID FROM ToDoNote WHERE Date > ' & LOC:InactiveFromDate
         END

         IF CEM:FilterInactiveColDebitFlag
            IF LOC:ActiveMattersSQLString THEN LOC:ActiveMattersSQLString = LOC:ActiveMattersSQLString & ' UNION'.
            LOC:ActiveMattersSQLString = LOC:ActiveMattersSQLString & ' SELECT MatterID FROM ColDebit WHERE Date > ' & LOC:InactiveFromDate
         END

         IF CEM:FilterInactiveMatTranFlag
            IF LOC:ActiveMattersSQLString THEN LOC:ActiveMattersSQLString = LOC:ActiveMattersSQLString & ' UNION'.
            LOC:ActiveMattersSQLString = LOC:ActiveMattersSQLString & ' SELECT MatterID FROM MatTran WHERE BookType <<> ''E'' AND Date > ' & LOC:InactiveFromDate ! DON'T INCLUDE INTEREST TRANSACTIONS
         END



         IF LOC:ActiveMattersSQLString

            IF LOC:ReturnString
               LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.RecordID NOT IN (' & LOC:ActiveMattersSQLString & ')'
            ELSE
               LOC:ReturnString = 'Matter.RecordID NOT IN (' & LOC:ActiveMattersSQLString & ')'
            END
         END

    END


! DEPRECATED 14/8/2010
!  IF GLO:FilterFavouritesFlag
!     IF LOC:ReturnString
!        LOC:ReturnString = Clip(LOC:ReturnString) & ' and Matter.RecordID IN (SELECT MatterID FROM Favourites WHERE EmployeeID = ' & CEM:RecordID & ')'
!     ELSE
!        LOC:ReturnString = 'Matter.RecordID IN (SELECT MatterID FROM Favourites WHERE EmployeeID = ' & CEM:RecordID & ')'
!     END
!  END


  IF GLO:FilterConveyancingStatus AND GLO:FilterConveyancingStatusFlag
     CASE GLO:FilterConveyancingStatus
          OF 9
             IF LOC:ReturnString
                LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.MessageWaitingFlag = 1'
             ELSE
                LOC:ReturnString = 'Matter.MessageWaitingFlag = 1'
             END
          ELSE
             IF LOC:ReturnString
                LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.ConveyancingStatusFlag = ' &  GLO:FilterConveyancingStatus
             ELSE
                LOC:ReturnString = 'Matter.ConveyancingStatusFlag = ' &  GLO:FilterConveyancingStatus
             END
     END
  END

!AbsaLink|#1
!|AG Rates|#2
!|DataLink|#3
!|FNB Bonds|#4
!|FNB Cancellations|#5
!|FNB Transfers|#6
!|LAW Bonds|#7
!|LAW Transfers|#8
!|LAW Rates|#9
!|WebLink|#10


  IF GLO:FilterDebtLinkFlag AND GLO:FilterDebtLinkCategory
     CASE GLO:FilterDebtLinkCategory
          OF 1  ! ABSALINK
             IF LOC:ReturnString
                LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.ABSALinkFlag = 1'
             ELSE
                LOC:ReturnString = 'Matter.ABSALinkFlag = 1'
             END
          OF 2  ! ALL RATES
             IF LOC:ReturnString
                LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.RatesInstructionSource > 0'
             ELSE
                LOC:ReturnString = 'Matter.RatesInstructionSource > 0'
             END
          OF 3  ! DATALINK
             IF LOC:ReturnString
                LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.DataLinkSuite > 0'
             ELSE
                LOC:ReturnString = 'Matter.DataLinkSuite > 0'
             END
                                                                     
          OF 4  ! FNB BONDS
             IF LOC:ReturnString
                LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.FNBMatterState > 0 AND Matter.LawSuite in (17,18,19,20,23,24,25,124,125,126,127,294.295,311,312)'
             ELSE
                LOC:ReturnString = 'Matter.FNBMatterState > 0 AND Matter.LawSuite in (17,18,19,20,23,24,25,124,125,126,127,294.295,311,312)'
             END
          OF 5  ! FNB CANCELLATIONS
             IF LOC:ReturnString
                LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.FNBMatterState > 0 AND Matter.LawSuite in (75,76,77,78,79,97,209,210)'
             ELSE
                LOC:ReturnString = 'Matter.FNBMatterState > 0 AND Matter.LawSuite in (75,76,77,78,79,97,209,210)'
             END
          OF 6  ! FNB TRANSFERS
             IF LOC:ReturnString
                LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.FNBMatterState > 0 AND Matter.LawSuite in (144,145)'
             ELSE
                LOC:ReturnString = 'Matter.FNBMatterState > 0 AND Matter.LawSuite in (144,145)'
             END
          OF 7  ! LAW Bonds
             IF LOC:ReturnString
                LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.LawRef > 0 AND Matter.LawSuite in (10,12,64,65)'
             ELSE
                LOC:ReturnString = 'Matter.LawRef > 0 AND Matter.LawSuite in (10,12,64,65)'
             END
          OF 8  ! LAW Transfers
             IF LOC:ReturnString
                LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.LawRef > 0 AND Matter.LawSuite in (33,34,35,36,55,56,57,58,60,61,70,71,72,73,80,81,151,152,153,154,155,156,157,158,159,160,173,174,175,176,181,182)'
             ELSE
                LOC:ReturnString = 'Matter.LawRef > 0 AND Matter.LawSuite in (33,34,35,36,55,56,57,58,60,61,70,71,72,73,80,81,151,152,153,154,155,156,157,158,159,160,173,174,175,176,181,182)'
             END
!          OF 9  ! LAW RATES
!             IF LOC:ReturnString
!                LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.RatesInstructionSource = 2'
!             ELSE
!                LOC:ReturnString = 'Matter.RatesInstructionSource = 2'
!             END
          OF 9  ! WEBLINK
             IF LOC:ReturnString
                LOC:ReturnString = Clip(LOC:ReturnString) & ' and Matter.WebLinkBankRef <> '''''
             ELSE
                LOC:ReturnString = 'Matter.WebLinkBankRef <> '''''
             END
          OF 10  ! CANCELLATION REQUESTS
             IF LOC:ReturnString
                LOC:ReturnString = Clip(LOC:ReturnString) & ' and Matter.RecordID IN (SELECT MatterID FROM CANC_MatterMessage WHERE MessageID in (SELECT RecordID FROM AG_Message where MessageType = ''initialRequest''))'
             ELSE
                LOC:ReturnString = 'Matter.RecordID IN (SELECT MatterID FROM CANC_MatterMessage WHERE MessageID in (SELECT RecordID FROM AG_Message where MessageType = ''initialRequest''))'
             END
          OF 11  ! CANCELLATION REJECTIONS
             IF LOC:ReturnString
                LOC:ReturnString = Clip(LOC:ReturnString) & ' and Matter.RecordID IN (SELECT MatterID FROM CANC_MatterMessage WHERE MessageID in (SELECT RecordID FROM AG_Message where MessageType = ''reject''))'
             ELSE
                LOC:ReturnString = 'Matter.RecordID IN (SELECT MatterID FROM CANC_MatterMessage WHERE MessageID in (SELECT RecordID FROM AG_Message where MessageType = ''reject''))'
             END
          OF 12  ! REASA TRANSFERS
             IF LOC:ReturnString
                LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.FNBMatterState > 0 AND Matter.LawSuite in (142,143,144,145,146,147,149,150)'
             ELSE
                LOC:ReturnString = 'Matter.FNBMatterState > 0 AND Matter.LawSuite in (142,143,144,145,146,147,149,150)'
             END

     END
  END


  IF GLO:FilterStageID 
     IF CEM:FilterDateType = 'S'  ! CHECK STAGES IN A CERTAIN RANGE
        IF LOC:ReturnString
           LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.RecordID IN (SELECT DISTINCT MatterStages.MatterID FROM MatterStages JOIN FileNote ON FileNote.RecordID = MatterStages.FileNoteID' &|
                                                     ' WHERE MatterStages.StageID = ' & GLO:FilterStageID & ' AND FileNote.Date >= ' & GLO:FilterFromDate & ' AND FileNote.Date <<= ' & GLO:FilterToDate & ')'
        ELSE
           LOC:ReturnString = 'Matter.RecordID IN (SELECT DISTINCT MatterStages.MatterID FROM MatterStages JOIN FileNote ON FileNote.RecordID = MatterStages.FileNoteID' &|
                                                     ' WHERE MatterStages.StageID = ' & GLO:FilterStageID & ' AND FileNote.Date >= ' & GLO:FilterFromDate & ' AND FileNote.Date <<= ' & GLO:FilterToDate & ')'
        END
     ELSIF CEM:LastStageDays > 0

        IF LOC:ReturnString Then LOC:ReturnString = Clip(LOC:ReturnString) & ' AND'.
        LOC:ReturnString = LOC:ReturnString & ' Matter.LastStageID = '& GLO:FilterStageID &' AND Matter.LastStageDate < ' & (GLO:TodaysDate  - CEM:LastStageDays)               !Kelvin was here
!        LOC:ReturnString = LOC:ReturnString & ' Matter.RecordId in (' & |               !Kelvin was here
!                                               'select MatterId ' & |
!                                               'From filenote ' & |
!                                               'inner join (select max(recordid) recordid ' & |
!                                               'from filenote ' & |
!                                               'where stageid <> 0 ' & |
!                                               'group by matterid) fn on fn.recordid = filenote.RecordId ' & |
!                                               'where filenote.StageID = ' & GLO:FilterStageID & ' and ' & |
!                                               '(convert(int,getdate()+36163) - filenote.Date) >= ' & CEM:LastStageDays & |
!                                              ' )'
!!        LOC:ReturnString = LOC:ReturnString & ' Matter.RecordId in (Select MatterID FROM (' & |
!!                                              ' Select MAX(FileNote.RecordID) as RID FROM FileNote where stageid <> 0 GROUP BY MatterID) X' & |
!!                                              ' INNER JOIN FileNote FX ON FX.RecordId = RID AND StageID = ' & GLO:FilterStageID & |
!!                                              ' WHERE date <  ' & (GLO:TodaysDate  - CEM:LastStageDays) & ')'
       
      ELSE
        IF LOC:ReturnString
           LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.LastStageID = ' & GLO:FilterStageID
        ELSE
           LOC:ReturnString = 'Matter.LastStageID = ' & GLO:FilterStageID
        END
     END
  END

  IF CEM:FilterStagesInListFlag


     IF CEM:FilterDateType = 'S'  ! CHECK STAGES IN A CERTAIN RANGE

        IF LOC:ReturnString
           LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.RecordID IN (SELECT DISTINCT MatterStages.MatterID FROM MatterStages JOIN FileNote ON FileNote.RecordID = MatterStages.FileNoteID' &|
                                                     ' WHERE MatterStages.StageID IN (SELECT StageID FROM FilterStages WHERE EmployeeID = ' & CEM:RecordID & ') '  & ' AND FileNote.Date >= ' & GLO:FilterFromDate & ' AND FileNote.Date <<= ' & GLO:FilterToDate & ')'
        ELSE
           LOC:ReturnString = 'Matter.RecordID IN (SELECT DISTINCT MatterStages.MatterID FROM MatterStages JOIN FileNote ON FileNote.RecordID = MatterStages.FileNoteID' &|
                                                     ' WHERE MatterStages.StageID IN (SELECT StageID FROM FilterStages WHERE EmployeeID = ' & CEM:RecordID & ') ' & ' AND FileNote.Date >= ' & GLO:FilterFromDate & ' AND FileNote.Date <<= ' & GLO:FilterToDate & ')'
        END

    ELSE
        IF LOC:ReturnString
           LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.RecordID IN (SELECT DISTINCT MatterID FROM MatterStages WHERE StageID IN (SELECT StageID FROM FilterStages WHERE EmployeeID = ' & CEM:RecordID & '))'
        ELSE
           LOC:ReturnString = 'Matter.RecordID IN (SELECT DISTINCT MatterID FROM MatterStages WHERE StageID IN (SELECT StageID FROM FilterStages WHERE EmployeeID = ' & CEM:RecordID & '))'
        END

    END

  END

  IF CEM:FilterStagesNotInListFlag


     IF CEM:FilterDateType = 'S'  ! CHECK STAGES IN A CERTAIN RANGE

        IF LOC:ReturnString
           LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.RecordID IN (SELECT DISTINCT MatterStages.MatterID FROM MatterStages JOIN FileNote ON FileNote.RecordID = MatterStages.FileNoteID' &|
                                                     ' WHERE MatterStages.StageID NOT IN (SELECT StageID FROM FilterNonStages WHERE EmployeeID = ' & CEM:RecordID & ') '  & ' AND FileNote.Date >= ' & GLO:FilterFromDate & ' AND FileNote.Date <<= ' & GLO:FilterToDate & ')'
        ELSE
           LOC:ReturnString = 'Matter.RecordID IN (SELECT DISTINCT MatterStages.MatterID FROM MatterStages JOIN FileNote ON FileNote.RecordID = MatterStages.FileNoteID' &|
                                                     ' WHERE MatterStages.StageID NOT IN (SELECT StageID FROM FilterNonStages WHERE EmployeeID = ' & CEM:RecordID & ') ' & ' AND FileNote.Date >= ' & GLO:FilterFromDate & ' AND FileNote.Date <<= ' & GLO:FilterToDate & ')'
        END

     ELSE

        IF LOC:ReturnString
           LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.RecordID NOT IN (SELECT DISTINCT MatterID FROM MatterStages WHERE StageID IN (SELECT StageID FROM FilterNonStages WHERE EmployeeID = ' & CEM:RecordID & '))'
        ELSE
           LOC:ReturnString = 'Matter.RecordID NOT IN (SELECT DISTINCT MatterID FROM MatterStages WHERE StageID IN (SELECT StageID FROM FilterNonStages WHERE EmployeeID = ' & CEM:RecordID & '))'
        END

     END

!     IF LOC:ReturnString
!        LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.RecordID NOT IN (SELECT DISTINCT MatterID FROM MatterStages WHERE StageID IN (SELECT StageID FROM FilterNonStages WHERE EmployeeID = ' & CEM:RecordID & '))'
!     ELSE
!        LOC:ReturnString = 'Matter.RecordID NOT IN (SELECT DISTINCT MatterID FROM MatterStages WHERE StageID IN (SELECT StageID FROM FilterNonStages WHERE EmployeeID = ' & CEM:RecordID & '))'
!     END

  END

  IF GLO:FilterGroupFlag
     IF LOC:ReturnString
        LOC:ReturnString = Clip(LOC:ReturnString) & ' AND Matter.RecordID IN (SELECT MatterID FROM MatGroup WHERE GroupID = ' & GLO:FilterGroupID & ')'
     ELSE
        LOC:ReturnString = 'Matter.RecordID IN (SELECT MatterID FROM MatGroup WHERE GroupID = ' & GLO:FilterGroupID & ')'
     END
  END

  IF GLO:RestrictToClientList
     IF LOC:ReturnString 
        LOC:ReturnString = LOC:ReturnString & ' AND Matter.ClientID IN (' & GLO:RestrictToClientList & ')'
     ELSE
        LOC:ReturnString = 'Matter.ClientID IN (' & GLO:RestrictToClientList & ')'
     END
  END

  IF ~GLO:SupervisorFlag
      IF LOC:ReturnString
         LOC:ReturnString = LOC:ReturnString & ' AND ((Matter.Access = ''R'' AND Matter.EmployeeID = ' & CEM:RecordID & ') OR Matter.Access <> ''R'')'
      ELSE
         LOC:ReturnString = '((Matter.Access = ''R'' AND Matter.EmployeeID = ' & CEM:RecordID & ') OR Matter.Access <> ''R'')'
      END
  END
  !FB1981
  IF EMP2:FilterPartyRoleFlag
    IF EMP2:FilterParty1ID AND EMP2:FilterRole1ID
        IF LOC:ReturnString
            LOC:ReturnString = LOC:ReturnString & ' AND Matter.RecordID in (Select MatterID FROM MatParty FJ WHERE FJ.PartyID = '&EMP2:FilterParty1ID&' AND FJ.RoleID = '&EMP2:FilterRole1ID&')'
        ELSE
            LOC:ReturnString = 'Matter.RecordID in (Select MatterID FROM MatParty FJ WHERE FJ.PartyID = '&EMP2:FilterParty1ID&' AND FJ.RoleID = '&EMP2:FilterRole1ID&')'
        END
    END
    IF EMP2:FilterParty2ID AND EMP2:FilterRole2ID
        IF LOC:ReturnString
            LOC:ReturnString = LOC:ReturnString & ' AND Matter.RecordID in (Select MatterID FROM MatParty FJ WHERE FJ.PartyID = '&EMP2:FilterParty2ID&' AND FJ.RoleID = '&EMP2:FilterRole2ID&')'
        ELSE
            LOC:ReturnString = 'Matter.RecordID in (Select MatterID FROM MatParty FJ WHERE FJ.PartyID = '&EMP2:FilterParty2ID&' AND FJ.RoleID = '&EMP2:FilterRole2ID&')'
        END
    END
    IF EMP2:FilterParty3ID AND EMP2:FilterRole3ID
        IF LOC:ReturnString
            LOC:ReturnString = LOC:ReturnString & ' AND Matter.RecordID in (Select MatterID FROM MatParty FJ WHERE FJ.PartyID = '&EMP2:FilterParty3ID&' AND FJ.RoleID = '&EMP2:FilterRole3ID&')'
        ELSE
            LOC:ReturnString = 'Matter.RecordID in (Select MatterID FROM MatParty FJ WHERE FJ.PartyID = '&EMP2:FilterParty3ID&' AND FJ.RoleID = '&EMP2:FilterRole3ID&')'
        END
    END

  END
  !END FB1981
  debug(LOC:ReturnString)

  RETURN LOC:ReturnString
GetMatterFilterHeading PROCEDURE                      ! Declare Procedure
LOC:WindowHeading               CSTRING(300)
LOC:MatterWord                  CSTRING(50)
LOC:InactiveMatters             CSTRING(200)
LOC:RecordNumber        CSTRING(200)
LOC:CriticalSteps       CSTRING(200)
LOC:Counter             LONG

  CODE
    IF GLO:FilterFavouritesFlag
       LOC:MatterWord = 'Recently Used Matters'
    ELSE
       IF GLO:FilterStatusLiveFlag
          LOC:MatterWord = 'Live Matters'
       ELSE
          LOC:MatterWord = 'Matters'
       END
    END


    LOC:WindowHeading =  'All ' & LOC:MatterWord

!1 = NEW
!2 = AMENDED
!3 = LODGED
!4 = REGISTERED
!5 = NTU
!6 = WITHDRAWN FROM DEEDS OFFICE
!7 = Cancel to Re-assign


  IF GLO:FilterConveyancingStatus AND GLO:FilterConveyancingStatusFlag
     CASE GLO:FilterConveyancingStatus
          OF 1
             LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [New Instruction]'
          OF 2
             LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Amended Instruction]'
          OF 5
             LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [NTU]'
          OF 7
             LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Cancelled to Re-Assign]'
          OF 9
             LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Messages Waiting]'
          ELSE
             LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Unkown Conveyancing Status]'
     END
  END


    IF GLO:RestrictToClientList
       IF INSTRING(',',GLO:RestrictToClientList,1)      ! THERE ARE MORE THAN ONE CLIENT SELECTED
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Selected Clients]'
       ELSE
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [' &  GetDescription('Party Name',GLO:RestrictToClientList) & ']'
       END
    END

    IF GLO:RestrictToDocGenList
       IF INSTRING(',',GLO:RestrictToDocGenList,1)      ! THERE ARE MORE THAN ONE DocGen SELECTED
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Selected Document Sets]'
       ELSE
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [' &  GetDescription('DocGen',GLO:RestrictToDocGenList) & ']'
       END
    END

    IF GLO:RestrictToMatterTypeList
       IF INSTRING(',',GLO:RestrictToMatterTypeList,1)      ! THERE ARE MORE THAN ONE MatterType SELECTED
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Selected Matter Types]'
       ELSE
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [' &  GetDescription('MatterType',GLO:RestrictToMatterTypeList) & ']'
       END
    END

    IF GLO:RestrictToBranchList
       IF INSTRING(',',GLO:RestrictToBranchList,1)      ! THERE ARE MORE THAN ONE Branch SELECTED
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Selected Branches]'
       ELSE
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [' &  GetDescription('Branch',GLO:RestrictToBranchList) & ']'
       END
    END


   IF CEM:FilterInactiveMattersFlag

      LOC:InactiveMatters = ''

      IF CEM:FilterInactiveFileNotesFlag
         CASE CEM:FilterFileNotesOption
         OF 'I'
           LOC:InactiveMatters = 'No Internal File Notes'
         OF 'A'
           LOC:InactiveMatters = 'No External File Notes'
         ELSE
           LOC:InactiveMatters = 'No File Notes'
         END
      END
      IF CEM:FilterInactiveFeeNotesFlag
         IF LOC:InactiveMatters
            LOC:InactiveMatters = LOC:InactiveMatters & '; No Fee Notes'
         ELSE
            LOC:InactiveMatters = 'No Fee Notes'
         END
      END
      IF CEM:FilterInactiveToDoNotesFlag
         IF LOC:InactiveMatters
            LOC:InactiveMatters = LOC:InactiveMatters & '; No Reminders'
         ELSE
            LOC:InactiveMatters = 'No Reminders'
         END
      END
      IF CEM:FilterInactiveColDebitFlag
         IF LOC:InactiveMatters
            LOC:InactiveMatters = LOC:InactiveMatters & '; No Debtor Transactions'
         ELSE
            LOC:InactiveMatters = 'No Debtor Transactions'
         END
      END
      IF CEM:FilterInactiveMatTranFlag
         IF LOC:InactiveMatters
            LOC:InactiveMatters = LOC:InactiveMatters & '; No Accounting Transactions'
         ELSE
            LOC:InactiveMatters = 'No Accounting Transactions'
         END
      END
      LOC:InactiveMatters = LOC:InactiveMatters & ' for ' & CLIP(LEFT(FORMAT(CEM:FilterInactiveDays,@N_5))) & ' days'


      IF LOC:InactiveMatters THEN LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [' & LOC:InactiveMatters & ']'.


    END

    IF GLO:RestrictToCriticalStepList

       LOC:RecordNumber = ''
       LOC:CriticalSteps = ''
       LOC:Counter = 0

       IF INSTRING(',',GLO:RestrictToCriticalStepList,1)
    
          LOOP X# = 1 TO LEN(GLO:RestrictToCriticalStepList)
    
               IF GLO:RestrictToCriticalStepList[X#] = ',' 
                  IF LOC:CriticalSteps 
                     LOC:CriticalSteps = LOC:CriticalSteps & ', ' & GetDescription('CriticalStep',LOC:RecordNumber)
                  ELSE
                     LOC:CriticalSteps = GetDescription('CriticalStep',LOC:RecordNumber)
                  END
                  LOC:RecordNumber = ''
                  LOC:Counter += 1
               ELSIF X# = LEN(GLO:RestrictToCriticalStepList)
                  LOC:RecordNumber = LOC:RecordNumber & GLO:RestrictToCriticalStepList[X#]
                  IF LOC:CriticalSteps 
                     LOC:CriticalSteps = LOC:CriticalSteps & ', ' & GetDescription('CriticalStep',LOC:RecordNumber)
                  ELSE
                     LOC:CriticalSteps = GetDescription('CriticalStep',LOC:RecordNumber)
                  END
                  LOC:RecordNumber = ''
                  LOC:Counter += 1
               ELSE
                  LOC:RecordNumber = LOC:RecordNumber & GLO:RestrictToCriticalStepList[X#]
               END
    
          END
          IF LOC:Counter > 3
             LOC:CriticalSteps = 'Selected Critical Steps (' & CLIP(LEFT(FORMAT(LOC:Counter,@N_5))) & ')'
          END

       ELSE

          IF NUMERIC(GLO:RestrictToCriticalStepList)

             LOC:CriticalSteps = GetDescription('CriticalStep',GLO:RestrictToCriticalStepList)

             SetTag:PtrM(TAG:CriticalStep,GLO:RestrictToCriticalStepList)

          ELSE

             LOC:CriticalSteps = 'Unknown Critical Step'

          END
    
       END

        LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [' & LOC:CriticalSteps & ']'

    END


    IF GLO:FilterCriticalStepsNotInList


       LOC:RecordNumber = ''
       LOC:CriticalSteps = ''
       LOC:Counter = 0

       IF INSTRING(',',GLO:FilterCriticalStepsNotInList,1)
    
          LOOP X# = 1 TO LEN(GLO:FilterCriticalStepsNotInList)
    
               IF GLO:FilterCriticalStepsNotInList[X#] = ',' 
                  IF LOC:CriticalSteps 
                     LOC:CriticalSteps = LOC:CriticalSteps & ', ' & GetDescription('CriticalStep',LOC:RecordNumber)
                  ELSE
                     LOC:CriticalSteps = GetDescription('CriticalStep',LOC:RecordNumber)
                  END
                  LOC:RecordNumber = ''
                  LOC:Counter += 1
               ELSIF X# = LEN(GLO:FilterCriticalStepsNotInList)
                  LOC:RecordNumber = LOC:RecordNumber & GLO:FilterCriticalStepsNotInList[X#]
                  IF LOC:CriticalSteps 
                     LOC:CriticalSteps = LOC:CriticalSteps & ', ' & GetDescription('CriticalStep',LOC:RecordNumber)
                  ELSE
                     LOC:CriticalSteps = GetDescription('CriticalStep',LOC:RecordNumber)
                  END
                  LOC:RecordNumber = ''
                  LOC:Counter += 1
               ELSE
                  LOC:RecordNumber = LOC:RecordNumber & GLO:FilterCriticalStepsNotInList[X#]
               END
    
          END
          IF LOC:Counter > 3
             LOC:CriticalSteps = 'Not in Selected Critical Steps (' & CLIP(LEFT(FORMAT(LOC:Counter,@N_5))) & ')'
          END

       ELSE

          IF NUMERIC(GLO:FilterCriticalStepsNotInList)

             LOC:CriticalSteps = GetDescription('CriticalStep',GLO:FilterCriticalStepsNotInList)

             SetTag:PtrM(TAG:CriticalStep,GLO:FilterCriticalStepsNotInList)

          ELSE

             LOC:CriticalSteps = 'Unknown Critical Step'

          END
    
       END

       LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Not ' & LOC:CriticalSteps & ']'

    END




    IF GLO:RestrictToEmployeeList
       IF INSTRING(',',GLO:RestrictToEmployeeList,1)      ! THERE ARE MORE THAN ONE Employee SELECTED
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Selected Employees]'
       ELSE
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Employee: ' &  GetDescription('Employee',GLO:RestrictToEmployeeList) & ']'
       END
    END


    IF GLO:RestrictToCostCentreList
       IF INSTRING(',',GLO:RestrictToCostCentreList,1)      ! THERE ARE MORE THAN ONE CostCentre SELECTED
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Selected Cost Centres]'
       ELSE
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Cost Centre: ' &  GetDescription('CostCentre',GLO:RestrictToCostCentreList) & ']'
       END
    END

!    IF GLO:FilterCostCentreFlag AND GLO:FilterCostCentreID THEN LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [' & GetDescription('Cost Centre',GLO:FilterCostCentreID) & ']'.



    IF GLO:FilterStageID THEN LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Last Stage: ' & GetDescription('Stage',GLO:FilterStageID) & ']'.
    IF CEM:FilterStagesInListFlag THEN LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Selected Stages]'.
    IF CEM:FilterStagesNotInListFlag THEN LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Not In Some Stages]'.
    IF GLO:FilterGroupFlag AND GLO:FilterGroupID THEN LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Group: ' & GetDescription('Group',GLO:FilterGroupID) & ']'.
    IF GLO:FilterSheriffAreaFlag AND GLO:FilterSheriffAreaID THEN LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Sheriff: ' & GetDescription('Sheriff Area',GLO:FilterSheriffAreaID) & ']'.

    IF GLO:FilterDateFlag AND GLO:FilterFromDate AND GLO:FilterToDate
       IF CEM:FilterDateOption = 'Custom' OR ~CEM:FilterDateOption 

          IF CEM:FilterDateType = 'I'  ! INSTRUCTED
             LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Instructed: From ' & FORMAT(GLO:FilterFromDate,@d17) & ' to ' & FORMAT(GLO:FilterToDate,@d17) & ']'
          ELSIF CEM:FilterDateType = 'L'  ! LODGED
             LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Lodged: From ' & FORMAT(GLO:FilterFromDate,@d17) & ' to ' & FORMAT(GLO:FilterToDate,@d17) & ']'
          ELSIF CEM:FilterDateType = 'R'  ! REGISTERED
             LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Registered: From ' & FORMAT(GLO:FilterFromDate,@d17) & ' to ' & FORMAT(GLO:FilterToDate,@d17) & ']'
          ELSIF CEM:FilterDateType = 'M'  ! IMPORTANT DATE
             LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Important Date: From ' & FORMAT(GLO:FilterFromDate,@d17) & ' to ' & FORMAT(GLO:FilterToDate,@d17) & ']'
          ELSIF CEM:FilterDateType = 'P'  ! PRESCRIPTION DATE
             LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Prescribes: From ' & FORMAT(GLO:FilterFromDate,@d17) & ' to ' & FORMAT(GLO:FilterToDate,@d17) & ']'
          ELSIF CEM:FilterDateType = 'S'  ! Stage DATE
             LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Stages: From ' & FORMAT(GLO:FilterFromDate,@d17) & ' to ' & FORMAT(GLO:FilterToDate,@d17) & ']'
          ELSE
             LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Unknown: From ' & FORMAT(GLO:FilterFromDate,@d17) & ' to ' & FORMAT(GLO:FilterToDate,@d17) & ']'
          END


       ELSE

          IF CEM:FilterDateType = 'I'  ! INSTRUCTED
               LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Instructed: ' & CEM:FilterDateOption & ']'
          ELSIF CEM:FilterDateType = 'L'  ! LODGED
               LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Lodged: ' & CEM:FilterDateOption & ']'
          ELSIF CEM:FilterDateType = 'R'  ! REGISTERED
               LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Registered: ' & CEM:FilterDateOption & ']'
          ELSIF CEM:FilterDateType = 'M'  ! IMPORTANT DATE
               LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Important Date: ' & CEM:FilterDateOption & ']'
          ELSIF CEM:FilterDateType = 'P'  ! PRESCRIPTION DATE
               LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Prescribes: ' & CEM:FilterDateOption & ']'
          ELSIF CEM:FilterDateType = 'S'  ! STAGES DATE
               LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Stages: ' & CEM:FilterDateOption & ']'
          ELSE
               LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Unknown: ' & CEM:FilterDateOption & ']'
          END

       END
    END


    IF GLO:FilterStatusArchiveFlag THEN LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Archived]'.
    IF GLO:FilterStatusPendingFlag THEN LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Pending]'.

    IF GLO:FilterDebtLinkFlag AND GLO:FilterDebtLinkCategory
       EXECUTE GLO:FilterDebtLinkCategory
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [AbsaLink]'
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Rates Applications]'
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [DataLink]'
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [FNB Bonds]'
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [FNB Cancellations]'
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [FNB Transfers]'
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [LAW Bonds]'
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [LAW Transfers]'
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [WebLink]'
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Cancellation Requests]'
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Cancellation Rejections]'
          LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [REASA Transfers]'
       END
    END
    IF GLO:FilterMattersBy THEN LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [' & GLO:FilterMattersBy & ']'.
    IF GLO:FilterBalances or GLO:FilterAging OR GLO:FilterLastInvoiceDate THEN LOC:WindowHeading = CLIP(LOC:WindowHeading) & ' [Financial]'.

    RETURN LOC:WindowHeading
