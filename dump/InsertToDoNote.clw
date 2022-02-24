InsertToDoNote       PROCEDURE  (TheMatterID,TheAction,TheCurrentPartyID,<TheRecurringFlag>) ! Declare Procedure
LOC:FoundEmployeeFlag    BYTE
LOC:DatePosition         LONG
LOC:BaseDate             LONG
LOC:CurrentPartyID       LONG
LOC:Quantity                 LIKE(TOI:Days)
LOC:NextYearMonth        LONG

    MAP
        GetToDoItemDate(LONG,LONG),LONG
    END

  CODE
          GlobalErrors.SetProcedurename('InsertToDoNote')

          Access:ToDoNote.UseFile


          IF TheAction = 1      ! Delete this Reminder


             IF TOD:OutLookAppointmentID

                UpdateOutLookAppointmentFromReminder(3)          ! DELETE THE APPOINTMENT

             END

             IF TOD:OutLookTaskID

                UpdateOutLookTaskFromReminder(3)          ! DELETE THE Task

             END


             IF TheCurrentPartyID   ! ONLY DELETE ANY PERTAINING TO THIS PARTY
                PropSQL('DELETE ToDoNote WHERE MatterID = ' & TheMatterID & ' AND ToDoItemID = ' & TOI:RecordID & ' AND PartyID = ' & TheCurrentPartyID,'InsertToDoNote')
             ELSE
                PropSQL('DELETE ToDoNote WHERE MatterID = ' & TheMatterID & ' AND ToDoItemID = ' & TOI:RecordID,'InsertToDoNote')
             END

          ELSIF TheAction = 3      ! Add this Reminder


             LOC:CurrentPartyID = TheCurrentPartyID

             Access:ToDoText.Open
             Access:ToDoText.UseFile

             TOD:MatterID = TheMatterID

             TOD:ToDoItemID = TOI:RecordID

             TOD:DateDone = 0
             TOD:CompletedFlag = 0
             TOD:CompletedByID = 0
             TOD:CompletedByNotes = ''

             IF TOI:NextDocumentFlag
                TOD:NextDocumentID = TOI:NextDocumentID
             END

             CLEAR(TOT:Record)
             TOT:ToDoItemID = TOI:RecordID
             TOT:LanguageID = GLO:DefaultLanguageID
             IF Access:ToDoText.TryFetch(TOT:ToDoItemKey)
                TOD:Description = TOI:Description
             ELSE
                TOD:Description = TOT:Description
             END

             Access:ToDoText.Close

             LOC:DatePosition = INSTRING('*DATE*',UPPER(TOD:Description),1)
             IF LOC:DatePosition
                TOD:Description = SUB(TOD:Description,1,LOC:DatePosition-1) & FORMAT(GLO:TodaysDate,@d17) & SUB(TOD:Description,LOC:DatePosition + 6,LEN(TOD:Description) - LOC:DatePosition+6)
             END

             IF INSTRING('[[',TOD:Description,1) THEN TOD:Description = ReplaceTextBoxFields(TOD:Description,GLO:DefaultLanguageID,LOC:CurrentPartyID,TheMatterID).

             LOC:BaseDate = 0
             IF TOI:BaseDateOption = 'C'

                IF COL:CourtDate
                   LOC:BaseDate = COL:CourtDate
                ELSE
                   Access:ColData.UseFile
                   COL:MatterID = TheMatterID
                   IF Access:ColData.Fetch(COL:MatterKey)
                      COL:MatterID = TheMatterID
                      COL:Defended = 'D'
                      Access:ColData.Insert
                   END

                   MESSAGE('The date of this Reminder (' & TOD:Description & ')||is based on the Court Date||of the Matter (' & MAT:FileRef & ' - ' & MAT:Description & ').|| Press OK to Specify this date now.','Inserting Reminder',ICON:Exclamation)
                   LOC:BaseDate = GetUserDate(GLO:TodaysDate)
                   COL:CourtDate = LOC:BaseDate
                   Access:ColData.TryUpdate

                END

             ELSIF TOI:BaseDateOption = 'L'

                IF CONV:TargetLodgementDate
                   LOC:BaseDate = CONV:TargetLodgementDate
                ELSE
                   Access:ConveyData.UseFile
                   CONV:MatterID = TheMatterID
                   IF Access:ConveyData.Fetch(CONV:PrimaryKey)
                      CONV:MatterID = TheMatterID
                      Access:ConveyData.Insert
                   END

                   MESSAGE('The date of this Reminder (' & TOD:Description & ')||is based on the Target Lodgement Date||of the Matter (' & MAT:FileRef & ' - ' & MAT:Description & ').|| Press OK to Specify this date now.','Inserting Reminder',ICON:Exclamation)
                   LOC:BaseDate = GetUserDate(GLO:TodaysDate)
                   CONV:TargetLodgementDate = LOC:BaseDate
                   Access:ConveyData.TryUpdate

                END


             ELSIF TOI:BaseDateOption = 'B'     ! BEGINING OF THE MONTH

                IF TheRecurringFlag
                   IF MONTH(TOD:Date) = 12
                      LOC:BaseDate = DATE(1,1,YEAR(TOD:Date)+1)
                   ELSE
                      LOC:BaseDate = DATE(MONTH(TOD:Date)+1,1,YEAR(TOD:Date))
                   END
                ELSE
                   IF MONTH(GLO:ToDaysDate) = 12
                      LOC:BaseDate = DATE(1,1,YEAR(GLO:ToDaysDate)+1)
                   ELSE
                      LOC:BaseDate = DATE(MONTH(GLO:ToDaysDate)+1,1,YEAR(GLO:ToDaysDate))
                   END
                END


             ELSIF TOI:BaseDateOption = 'E'     ! END OF THE YEAR

                IF TheRecurringFlag
                   LOC:BaseDate = DATE(12,31,YEAR(TOD:Date)+1)
                ELSE
                   LOC:BaseDate = DATE(12,31,YEAR(GLO:ToDaysDate))
                END



             ELSIF TOI:BaseDateOption = 'T'
                LOC:BaseDate = GLO:ToDaysDate
             ELSIF TOI:BaseDateOption = 'R'
                LOC:BaseDate = GetToDoItemDate(TheMatterID,TOI:BaseDateOtherID)
             ELSIF TOI:BaseDateOption = 'O'
                LOC:BaseDate = Interpret(TOI:BaseDateOptionOther)
             ELSE
                LOC:BaseDate = MAT:DateInstructed
             END

             IF TOI:BeforeAfterOption = 'B'
                LOC:Quantity = -TOI:Days
             ELSE
                LOC:Quantity = TOI:Days
             END

             IF TOI:BaseDateOption = 'B' AND TOI:Period = 1      ! BEGINING OF THE MONTH
                IF TOI:BeforeAfterOption = 'B'                   ! DOING THIS BECAUSE THE BASE DATE HAS TO START ON THE 1ST DAY OF THE MONTH
                                                                 ! YOU CAN'T SET THE DAY IN DATE(MONTH,DAY,YEAR) TO 0
                                                                 ! SO EFFECTIVELY WE HAVE ALREADY ADDED A DAY TO THE CALCULATION
                                                                 ! SO WE MUST TAKE IT OFF SO IT CALCULATES THE RIGHT NO OF DAYS
                   LOC:Quantity +=1
                ELSE
                   LOC:Quantity -=1
                END
             END





             IF LOC:BaseDate

                CASE TOI:Period

                   OF 1     ! DAYS

                      TOD:Date = FindDate(LOC:BaseDate,LOC:Quantity,TOI:WorkingDaysFlag,TOI:SpecificDayMask,TOI:ExcludeCourtHolidaysFlag,TOI:ExcludeCourtRecessFlag,TOI:WeekendsFlag)

                   OF 2     ! WEEKS

                      LOC:Quantity = LOC:Quantity * 7
                      TOD:Date = FindDate(LOC:BaseDate,LOC:Quantity,TOI:WorkingDaysFlag,TOI:SpecificDayMask,TOI:ExcludeCourtHolidaysFlag,TOI:ExcludeCourtRecessFlag,TOI:WeekendsFlag)

                   OF 3     ! MONTHS

                      IF MONTH(LOC:BaseDate) + LOC:Quantity > 12
                         LOC:NextYearMonth = MONTH(LOC:BaseDate) + LOC:Quantity - 12
                         LOC:BaseDate = DATE(LOC:NextYearMonth,DAY(LOC:BaseDate),YEAR(LOC:BaseDate)+1)
                      ELSE
                         LOC:BaseDate = DATE(MONTH(LOC:BaseDate) + LOC:Quantity,DAY(LOC:BaseDate),YEAR(LOC:BaseDate))
                      END

                      TOD:Date = FindDate(LOC:BaseDate,0,TOI:WorkingDaysFlag,TOI:SpecificDayMask,TOI:ExcludeCourtHolidaysFlag,TOI:ExcludeCourtRecessFlag,TOI:WeekendsFlag)


                   OF 4     ! YEARS

                      LOC:BaseDate = DATE(MONTH(LOC:BaseDate),DAY(LOC:BaseDate),YEAR(LOC:BaseDate)+LOC:Quantity)
                      TOD:Date = FindDate(LOC:BaseDate,0,TOI:WorkingDaysFlag,TOI:SpecificDayMask,TOI:ExcludeCourtHolidaysFlag,TOI:ExcludeCourtRecessFlag,TOI:WeekendsFlag)

                END


             ELSE
                IF TOI:BaseDateOption = 'O'
                   MESSAGE('Could not find the Base Date (' & TOI:BaseDateOptionOther & ') for this Reminder||' & TOD:Description & '||The Reminder will be inserted for tomorrow''s date.','Base Date Not Found',ICON:Exclamation)
                   TOD:Description = 'Date Calculation Error: Could not find the Base Date (' & TOI:BaseDateOptionOther & '): ' & TOD:Description
                ELSE
                   MESSAGE('Could not find the Base Date (' & TOI:BaseDateOption & ') for this Reminder||' & TOD:Description & '||The Reminder will be inserted for tomorrow''s date.','Base Date Not Found',ICON:Exclamation)
                   TOD:Description = 'Date Calculation Error: Could not find the Base Date (' & TOI:BaseDateOption & '): ' & TOD:Description
                END

                TOD:Date = GLO:TodaysDate + 1

             END

             TOD:PartyID = TheCurrentPartyID    ! SAVE WHO THIS REMINDER PERTAINS TO SO WE CAN DELETE IT ABOVE


             IF TOI:AssignFlag AND TOI:EmpRoleID    ! THIS REMINDER MUST BE ASSIGNED TO A SPECIFIC ROLE

                Access:EmpLinkRole.Open
                Access:EmpLinkRole.UseFile

                Access:MatEmployee.Open
                Access:MatEmployee.UseFile

                LOC:FoundEmployeeFlag = 0

                AddMatterEmployees(TheMatterID)    ! Add any Employees who have File Notes, Fee Notes etc for this Matter
                                                    ! to the MatEmployee File so we can try and find the right Employee

                CLEAR(ELR:Record)
                ELR:EmpRoleID = TOI:EmpRoleID
                SET(ELR:EmpRoleKey,ELR:EmpRoleKey)


                LOOP UNTIL Access:EmpLinkRole.Next()    ! FIND ALL THE EMPLOYEES WHO PLAY THIS ROLE

                     IF ~(ELR:EmpRoleID = TOI:EmpRoleID) THEN BREAK.
                                                        ! CHECK IF THIS PERSON IS WORKING ON THIS MATTER
                     ME:EmployeeID = ELR:EmployeeID
                     ME:MatterID = TheMatterID
                     IF ~Access:MatEmployee.TryFetch(ME:MatterEmployeeKey)

                         Access:MatEmployee.TryFetch(ME:MatterEmployeeKey)
                         TOD:EmployeeID = ELR:EmployeeID
                         IF Access:ToDoNote.Insert()    ! ADD A TODONOTE FOR EACH ONE FOUND

                            MESSAGE('An error was encountered while adding a ToDoNote||Error = ' & ERROR(),'Inserting Reminder',ICON:Exclamation)
                            BREAK

                         ELSE


                            IF (CEM:SynchroniseAppointmentsWithRemindersFlag OR TOI:CreateOutLookAppointmentFlag) AND TOD:EmployeeID = CEM:RecordID

                               GLO:CreatingAutomaticAppointmentsFlag = 1  ! DON'T POP UP THE EDIT APPOINTMENT SCREEN EVERY TIME

                               UpdateOutLookAppointmentFromReminder(1)    ! ADD THE APPOINTMENT TO OUTLOOK

                               GLO:CreatingAutomaticAppointmentsFlag = 0


                            END


                         END
                         LOC:FoundEmployeeFlag = 1
                     END

                END


                IF LOC:FoundEmployeeFlag = 0 ! IF COULD NOT FIND AN EMPLOYEE WHO PLAYS THIS ROLE ON THIS MATTER
                                             ! THEN ADD ALL THOSE WHO PLAY THIS ROLE, ADD THEM TO MATEMPLOYEE AND GIVE THEM ALL THE REMINDER

                   CLEAR(ELR:Record)
                   ELR:EmpRoleID = TOI:EmpRoleID
                   SET(ELR:EmpRoleKey,ELR:EmpRoleKey)

                   LOOP UNTIL Access:EmpLinkRole.Next()    ! FIND ALL THE EMPLOYEES WHO PLAY THIS ROLE

                        IF ~(ELR:EmpRoleID = TOI:EmpRoleID) THEN BREAK.

                        CLEAR(ME:Record)
                        ME:EmployeeID = ELR:EmployeeID
                        ME:MatterID = TheMatterID
                        IF ~Access:MatEmployee.Insert()

                            TOD:EmployeeID = ELR:EmployeeID
                            IF Access:ToDoNote.Insert()    ! ADD A TODONOTE FOR EACH ONE FOUND

                               MESSAGE('An error was encountered while adding a ToDoNote||Error = ' & ERROR(),'Inserting Reminder',ICON:Exclamation)
                               BREAK

                            ELSE

                               IF (CEM:SynchroniseAppointmentsWithRemindersFlag OR TOI:CreateOutLookAppointmentFlag) AND TOD:EmployeeID = CEM:RecordID


                                  GLO:CreatingAutomaticAppointmentsFlag = 1  ! DON'T POP UP THE EDIT APPOINTMENT SCREEN EVERY TIME

                                  UpdateOutLookAppointmentFromReminder(1)    ! ADD THE APPOINTMENT TO OUTLOOK

                                  GLO:CreatingAutomaticAppointmentsFlag = 0


                               END

                            END

                            LOC:FoundEmployeeFlag = 1
                        END

                   END

                END



                IF LOC:FoundEmployeeFlag = 0 ! IF COULD NOT FIND AN EMPLOYEE WHO PLAYS THIS ROLE ON THIS MATTER

                   CLEAR(ER:Record)
                   ER:RecordID = TOI:EmpRoleID
                   IF ~Access:EmpRole.TryFetch(ER:PrimaryKey)

                       IF MESSAGE('This Reminder (' & TOD:Description & ') must be assigned to the Employee who is the ''' & ER:Description & ''' for this Matter (' & MAT:FileRef & ' - ' & MAT:Description & ').||Do you want to assign an Employee to this Role now?','No Role exists for the Matter',ICON:Exclamation,BUTTON:Yes+BUTTON:No,BUTTON:No,1) = BUTTON:Yes

                          GlobalRequest = SelectRecord

                          SelectEmployeeRoleAlias(TOI:EmpRoleID)

                          IF GlobalResponse = RequestCompleted
                             TOD:EmployeeID = EMP1:RecordID
                             LOC:FoundEmployeeFlag = 1
                             IF Access:ToDoNote.Insert()

                                MESSAGE('An error was encountered while adding a ToDoNote.||Error = ' & ERROR(),'Inserting Reminder',ICON:Exclamation)
                                RETURN

                              ELSE


                               IF (CEM:SynchroniseAppointmentsWithRemindersFlag OR TOI:CreateOutLookAppointmentFlag) AND TOD:EmployeeID = CEM:RecordID


                                  GLO:CreatingAutomaticAppointmentsFlag = 1  ! DON'T POP UP THE EDIT APPOINTMENT SCREEN EVERY TIME

                                  UpdateOutLookAppointmentFromReminder(1)    ! ADD THE APPOINTMENT TO OUTLOOK

                                  GLO:CreatingAutomaticAppointmentsFlag = 0


                               END


                             END

                             CLEAR(MatEmployee)
                             ME:EmployeeID = EMP1:RecordID
                             ME:MatterID = TheMatterID
                             IF Access:MatEmployee.TryFetch(ME:MatterEmployeeKey)
                                GET(MatEmployee,0)
                                ME:MatterID = TheMatterID
                                ME:EmployeeID = EMP1:RecordID
                                IF Access:MatEmployee.Insert()
                                   MESSAGE('An error was encountered while adding the Employee (' & ELR:EmployeeID & ') to the Matter (' & ME:MatterID & ').||Error = ' & ERROR(),'Inserting Matter Employee',ICON:Exclamation)
                                END
                             END

                             ELR:EmpRoleID = TOI:EmpRoleID      ! AND GIVE HIM THIS ROLE
                             ELR:EmployeeID = EMP1:RecordID
                             IF Access:EmpLinkRole.TryFetch(ELR:PrimaryKey)
                                GET(EmpLinkRole,0)
                                ELR:EmpRoleID = TOI:EmpRoleID
                                ELR:EmployeeID = EMP1:RecordID
                                IF Access:EmpLinkRole.Insert()
                                   MESSAGE('An error was encountered while giving the Employee (' & ELR:EmployeeID & ') this Role (' & TOI:EmpRoleID & ').||Error = ' & ERROR(),'Inserting Employee Role',ICON:Exclamation)
                                END
                             END

                         END

                      END
                   END
                END

                Access:EmpLinkRole.Close
                Access:MatEmployee.Close

                IF LOC:FoundEmployeeFlag = 0 ! IF COULD NOT FIND THE EMPLOYEE WORKING ON THIS MATTER
                   MESSAGE('Note: This Reminder (' & TOD:Description & ') has not been inserted for this Matter (' & MAT:FileRef & ' - ' & MAT:Description & ').|','No Reminder inserted',ICON:Exclamation)
                END

             ELSE

                ! 12 Mar 2020 PK Naidoo - FB Case 2367, the Reminder will be assigned to the logged in user and not the employee on the Matter.
                IF CTL:AssignReminderToCurrentUserFlag OR CEM:AssignReminderToCurrentUserFlag
                    TOD:EmployeeID = CEM:RecordID
                ELSE
                    TOD:EmployeeID = MAT:EmployeeID
                END

                IF Access:ToDoNote.Insert()
                   MESSAGE('An error was encountered while adding a ToDoNote||Error = ' & ERROR(),'Inserting Reminder',ICON:Exclamation)
                   RETURN
                ELSE

                   IF CEM:SynchroniseAppointmentsWithRemindersFlag OR TOI:CreateOutLookAppointmentFlag

                      GLO:CreatingAutomaticAppointmentsFlag = 1  ! DON'T POP UP THE EDIT APPOINTMENT SCREEN EVERY TIME
                      UpdateOutLookAppointmentFromReminder(1)    ! ADD THE APPOINTMENT TO OUTLOOK
                      GLO:CreatingAutomaticAppointmentsFlag = 0

                   END

                END

             END

          ELSIF TheAction = 2      ! Tick this Reminder as "Done"


                 CLEAR(RES:Record)
                 IF TheCurrentPartyID   
                    CLEAR(ROW:Record)
                    RowCounter{PROP:SQL} = 'SELECT RecordID FROM ToDoNote WHERE MatterID = ' & TheMatterID & ' AND ToDoItemID = ' & TOI:RecordID & ' AND PartyID = ' & TheCurrentPartyID
                    NEXT(RowCounter)
                    IF ROW:Counter
                       ResultSet{PROP:SQL} = 'SELECT RecordID FROM ToDoNote WHERE MatterID = ' & TheMatterID & ' AND ToDoItemID = ' & TOI:RecordID & ' AND DateDone = 0 AND PartyID = ' & TheCurrentPartyID
                    ELSE
                       ResultSet{PROP:SQL} = 'SELECT RecordID FROM ToDoNote WHERE MatterID = ' & TheMatterID & ' AND ToDoItemID = ' & TOI:RecordID & ' AND DateDone = 0'
                    END
                 ELSE
                    ResultSet{PROP:SQL} = 'SELECT RecordID FROM ToDoNote WHERE MatterID = ' & TheMatterID & ' AND ToDoItemID = ' & TOI:RecordID & ' AND DateDone = 0'
                 END


                 LOOP
                      NEXT(ResultSet)
                      If Errorcode() Then Break.

                      MarkToDoNote(RES:RecordID)



                 END

          ELSE
                MESSAGE('An error was encountered while adding a ToDoNote||Unknow Action','Inserting Reminder',ICON:Exclamation)

          END




GetToDoItemDate         PROCEDURE(ThisMatterID,ThisToDoItemID)

LOC:ReturnDate      LONG

    CODE
    CLEAR(ROW:Record)
    RowCounter{PROP:SQL} = 'SELECT' &|
                           ' CASE WHEN DateDone > 0 THEN DateDone' &|
                           ' ELSE Date' &|
                           ' END' &|
                           ' FROM ToDoNote WHERE MatterID = ' & ThisMatterID & ' AND ToDoItemID = ' &  ThisToDoItemID

    NEXT(RowCounter)

! MESSAGE('Returning Date = ' & format(ROW:Counter,@d17))

    RETURN ROW:Counter


