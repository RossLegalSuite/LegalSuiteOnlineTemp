



DisplayExtraScreens     ROUTINE


  Access:DocScrn.UseFile
  Access:DocScrnEvent.UseFile
  Access:DocScrnField.UseFile
  Access:.UseFile

  CLEAR(LOC:ScreenField)
  CLEAR(LOC:FieldNumber)

  CLEAR(LOC:DS:FieldDropDownOptions)
  CLEAR(LOC:DS:RefreshScreenFlag)
  CLEAR(LOC:DS:FieldEquate)
  CLEAR(LOC:DS:FieldCalculation)
  CLEAR(LOC:DS:FieldType)
  CLEAR(LOC:DS:FieldRequiredFlag)
  CLEAR(LOC:DS:FieldRequiredCondition)
  CLEAR(LOC:DS:HideFlag)
  CLEAR(LOC:DS:HideCondition)
  CLEAR(LOC:DS:DisableFlag)
  CLEAR(LOC:DS:DisableCondition)
  CLEAR(LOC:DS:WriteBackCondition)
  CLEAR(LOC:DS:FieldHelp)
  CLEAR(LOC:DS:Field)
  CLEAR(LOC:DS:Color1Condition)
  CLEAR(LOC:DS:Color1)
  CLEAR(LOC:DS:WriteBackFlag)
  CLEAR(LOC:DS:WriteBackTable)
  CLEAR(LOC:DS:WriteBackColumn)
  CLEAR(LOC:DS:WriteBackRoleID)
  CLEAR(LOC:DS:LookupScript)
  
  LOOP LOC:ScreenCounter = 1 TO RECORDS(ScreenQueue)

       GET(ScreenQueue,LOC:ScreenCounter)
       IF ERROR() THEN EXIT.

       DESTROY(SCRQ:TabEquate)

  END
  

  CLEAR(ScreenQueue)
  FREE(ScreenQueue)

  LOC:DisplayThisTab = 0
  LOC:FieldEquate = 10000        ! NEED THIS TO OVERCOME BUG IF "CREATING" FIELDS ON A "FORM" (AS OPPOSED TO A WINDOW)
  
  DO BuildScreenQueue    ! THIS MUST BE IN THE PARENT .CLW
  

  IF ~RECORDS(ScreenQueue) THEN EXIT.

  LOC:LettersUsed = 'OC'     ! Screen OK Cancel

  LOC:TabControlEquate = 9000
  
  LOOP LOC:QueuePointer = 1 TO RECORDS(ScreenQueue)

       GET(ScreenQueue,LOC:QueuePointer)
       IF ERROR() THEN EXIT.


       LOC:TabControlEquate += 1
       SCRQ:TabEquate = CREATE(LOC:TabControlEquate,CREATE:Tab,?Sheet1)

       IF ~SCRQ:TabEquate
           MESSAGE('Extra Screen Creation Error||Failed to add ' & SCRQ:ScreenTitle,'Error',ICON:Exclamation)
           EXIT
        ELSE
           SCRQ:RecordID = LOC:QueuePointer   
           PUT(ScreenQueue)
       END


       CLEAR(DS:Record)
       DS:RecordID = SCRQ:DocScrnID
       IF Access:DocScrn.Fetch(DS:PrimaryKey) THEN BREAK.

       IF LOC:DisplayThisScreenID  = DS:RecordID    ! CURRENTLY MERGING A DOCUMENT THAT WANT INPUT INTO THIS SCREEN
          LOC:DisplayThisTab = LOC:QueuePointer + LOC:ExistingTabs



       END


       DO AssignArrays

       LOOP Y# = 1 TO LEN(DS:ScreenTitle)           ! PUT THE AMPERSAND AT A UNIQUE LETTER
            IF ~INSTRING(UPPER(DS:ScreenTitle[Y#]),LOC:LettersUsed,1) AND INSTRING(UPPER(DS:ScreenTitle[Y#]),'ABCDEFGHIJKLMNOPQRSTUVWXY1234567890',1)
                 LOC:LettersUsed = LOC:LettersUsed & UPPER(DS:ScreenTitle[Y#])
                 BREAK
            END
       END

       IF Y# > LEN(DS:ScreenTitle) THEN Y# = 1.

       SCRQ:TabEquate{PROP:Text} = SUB(DS:ScreenTitle,1,Y#-1) & '&' & SUB(DS:ScreenTitle,Y#,90)

       ?Sheet1{PROP:Selected} = LOC:QueuePointer + LOC:ExistingTabs

       DO UpdateScreenFields

       DO ConstructTheScreen

  END
  
  DO CalculateAllFields

  DO CheckBackgroundColours

  DO HideUnHideButtons


  IF LOC:DisplayThisTab

     ?Sheet1{PROP:SELECTED} = LOC:DisplayThisTab

  ELSIF LOC:ModifiedTab

     ?Sheet1{PROP:SELECTED} = LOC:ModifiedTab

  ELSE

     ?Sheet1{PROP:SELECTED} = 1

  END




  LOC:ModifiedTab         = 0
  LOC:DisplayThisScreenID = 0

  DISPLAY

SetDSFVariables     ROUTINE


           DSF:FieldPrompt = LOC:DS:Field[SCRQ:RecordID,LOC:ThisField]
           DSF:RefreshScreenFlag = LOC:DS:RefreshScreenFlag[SCRQ:RecordID,LOC:ThisField]
           DSF:FieldCalculation = LOC:DS:FieldCalculation[SCRQ:RecordID,LOC:ThisField]
           DSF:FieldDropDownOptions = LOC:DS:FieldDropDownOptions[SCRQ:RecordID,LOC:ThisField]
           DSF:FieldType = LOC:DS:FieldType[SCRQ:RecordID,LOC:ThisField]
           DSF:FieldRequiredFlag = LOC:DS:FieldRequiredFlag[SCRQ:RecordID,LOC:ThisField]
           DSF:FieldHelp = LOC:DS:FieldHelp[SCRQ:RecordID,LOC:ThisField]
           DSF:FieldRequiredFlag = LOC:DS:FieldRequiredFlag[SCRQ:RecordID,LOC:ThisField]
           DSF:FieldRequiredCondition = LOC:DS:FieldRequiredCondition[SCRQ:RecordID,LOC:ThisField]

           DSF:DisableFlag = LOC:DS:DisableFlag[SCRQ:RecordID,LOC:ThisField]
           DSF:DisableCondition = LOC:DS:DisableCondition[SCRQ:RecordID,LOC:ThisField]
           DSF:WriteBackCondition = LOC:DS:WriteBackCondition[SCRQ:RecordID,LOC:ThisField]

           DSF:HideFlag = LOC:DS:HideFlag[SCRQ:RecordID,LOC:ThisField]
           DSF:HideCondition = LOC:DS:HideCondition[SCRQ:RecordID,LOC:ThisField]

           DSF:Color1Condition = LOC:DS:Color1Condition[SCRQ:RecordID,LOC:ThisField]
           DSF:WriteBackFlag = LOC:DS:WriteBackFlag[SCRQ:RecordID,LOC:ThisField]
           DSF:WriteBackTable = LOC:DS:WriteBackTable[SCRQ:RecordID,LOC:ThisField]
           DSF:WriteBackColumn = LOC:DS:WriteBackColumn[SCRQ:RecordID,LOC:ThisField]
           DSF:WriteBackRoleID = LOC:DS:WriteBackRoleID[SCRQ:RecordID,LOC:ThisField]
           DSF:LookupScript = LOC:DS:LookupScript[SCRQ:RecordID,LOC:ThisField]

           DSF:Color1 = LOC:DS:Color1[SCRQ:RecordID,LOC:ThisField]
           DSF:DefaultValue = LOC:DS:FieldDefaultValue[SCRQ:RecordID,LOC:ThisField]




SetupCalculationFields     ROUTINE


       LOC:ThisField = LOC:FieldCounter

       IF LOC:DS:Field[SCRQ:RecordID,LOC:ThisField]

          IF LOC:DS:FieldCalculation[SCRQ:RecordID,LOC:ThisField] 

             LOC:FieldNumber[SCRQ:RecordID,LOC:ThisField]{PROP:ReadOnly} = True
             LOC:FieldNumber[SCRQ:RecordID,LOC:ThisField]{PROP:Skip} = True
             IF LOC:DS:FieldType[SCRQ:RecordID,LOC:ThisField] <> 'Y' THEN LOC:FieldNumber[SCRQ:RecordID,LOC:ThisField]{PROP:BackGround} = 0E3E3E3H.

          ELSE

             LOC:FieldNumber[SCRQ:RecordID,LOC:ThisField]{PROP:ReadOnly} = False
             LOC:FieldNumber[SCRQ:RecordID,LOC:ThisField]{PROP:Skip} = False
             IF LOC:DS:FieldType[SCRQ:RecordID,LOC:ThisField] <> 'Y' THEN LOC:FieldNumber[SCRQ:RecordID,LOC:ThisField]{PROP:BackGround} = COLOR:White.

          END

       END


CalculateAllFields      ROUTINE


       IF ~RECORDS(ScreenQueue) THEN EXIT.


       LOOP LOC:ScreenCounter = 1 TO RECORDS(ScreenQueue)


          GET(ScreenQueue,LOC:ScreenCounter)
          IF ERROR() THEN EXIT.


          LOC:ThisField = 1
          LOC:SafetyValve = 1


          LOOP UNTIL LOC:ThisField > 30




               IF LOC:DS:FieldCalculation[SCRQ:RecordID,LOC:ThisField]

                  LOC:SafetyValve += 1                     ! JUST IN CASE THE ONE FIELD CALLS THE OTHER AND VICE VERSA - I.E. DEADLY EMBRACE
                  IF LOC:SafetyValve > 200 THEN BREAK.

                  BIND:FieldCalculation = LOC:DS:FieldCalculation[SCRQ:RecordID,LOC:ThisField]



                  IF INSTRING('[[',BIND:FieldCalculation,1)




                     IF GlobalErrors.GetProcedureName() = 'UpdateMatParty'

                        ORIG:MP:RecordID = MP:RecordID  ! ADDED BY RICK 21/11/2012 - THERE WAS A PROBLEM IF A PARTY FIELD WAS USED AND IT LOOPED THRU THE MATPARTIES
                                                        ! E.G. [[CREDITOR.ALL.FIELD.CLAIM AMOUNT.TOTAL]]


                        BIND:FieldCalculation = ReplaceTextBoxFields(BIND:FieldCalculation,MP:LanguageID,MP:PartyID,MP:MatterID)

                        GlobalErrors.SetProcedureName('UpdateMatParty')

                        IF ~(ORIG:MP:RecordID = MP:RecordID)
                             MP:RecordID = ORIG:MP:RecordID
                             Access:MatParty.TryFetch(MP:PrimaryKey)

                        END

                     ELSIF GlobalErrors.GetProcedureName() = 'UpdateParty'  
                        BIND:FieldCalculation = ReplaceTextBoxFields(BIND:FieldCalculation,PAR:DefaultLanguageID,PAR:RecordID,0)
                        GlobalErrors.SetProcedureName('UpdateParty')
                     ELSE
                        BIND:FieldCalculation = ReplaceTextBoxFields(BIND:FieldCalculation,MAT:DocumentLanguageID,0,MAT:RecordID)
                     END


                     IF NUMERIC(BIND:FieldCalculation)
                        THIS:Calculation = EVALUATE('''' & BIND:FieldCalculation & '''')  ! EVALUATE(0831234567) = 8231234567 , I.E. IT DROPS THE LEADING ZERO
                     ELSE
                        THIS:Calculation = EVALUATE(BIND:FieldCalculation)
                        IF ~THIS:Calculation                                                      ! 25/2/2010 WAS RETURNING BLANKS FOR PARTY FIELDS?????
                            THIS:Calculation = EVALUATE('''' & BIND:FieldCalculation & '''')
                        END
                     END

                  ELSE

                      THIS:Calculation = EVALUATE(BIND:FieldCalculation)

                  END



                  IF LOC:ScreenField[SCRQ:RecordID,LOC:ThisField] = THIS:Calculation



                     ! NO CHANGE
                     LOC:ThisField += 1

                  ELSE
                     LOC:ScreenField[SCRQ:RecordID,LOC:ThisField] = THIS:Calculation

                     DISPLAY(LOC:FieldNumber[SCRQ:RecordID,LOC:ThisField])

!  message('ABOUT TO SaveScreenData||SCRQ:RecordID = ' & SCRQ:RecordID & '|LOC:ThisField = ' & LOC:ThisField & '|New Amount = ' & LOC:ScreenField[SCRQ:RecordID,LOC:ThisField])


                     SaveScreenData

                     ! CHANGED - START FROM BEGINING AGAIN
                     LOC:ThisField = 1

                  END

               ELSE

                  LOC:ThisField += 1

               END

          END

      END



CheckDefaults   ROUTINE
       IF RECORDS(ScreenQueue)

           LOOP FieldDefault# = 1 TO 30

                 IF LOC:DS:FieldDefaultValue[SCRQ:RecordID,FieldDefault#]

       
                    IF ~LOC:ScreenField[SCRQ:RecordID,FieldDefault#]     ! IF THIS FIELD IS EMPTY
       
                        BIND:FieldDefaultValue = LOC:DS:FieldDefaultValue[SCRQ:RecordID,FieldDefault#]

                        IF INSTRING('[[',BIND:FieldDefaultValue,1)

                           IF GlobalErrors.GetProcedureName() = 'UpdateMatParty'  


                              ORIG:MP:RecordID = MP:RecordID  ! ADDED BY RICK 21/11/2012 - THERE WAS A PROBLEM IF A PARTY FIELD WAS USED AND IT LOOPED THRU THE MATPARTIES
                                                              ! E.G. [[CREDITOR.ALL.FIELD.CLAIM AMOUNT.TOTAL]]


                              BIND:FieldDefaultValue = ReplaceTextBoxFields(BIND:FieldDefaultValue,MP:LanguageID,MP:PartyID,MP:MatterID)
                              GlobalErrors.SetProcedureName('UpdateMatParty')


                              IF ~(ORIG:MP:RecordID = MP:RecordID)
                                   MP:RecordID = ORIG:MP:RecordID
                                   Access:MatParty.TryFetch(MP:PrimaryKey)
                              END


                           ELSIF GlobalErrors.GetProcedureName() = 'UpdateParty'
                              BIND:FieldDefaultValue = ReplaceTextBoxFields(BIND:FieldDefaultValue,PAR:DefaultLanguageID,PAR:RecordID,0)
                              GlobalErrors.SetProcedureName('UpdateParty')
                           ELSE
                              BIND:FieldDefaultValue = ReplaceTextBoxFields(BIND:FieldDefaultValue,MAT:DocumentLanguageID,0,MAT:RecordID)
                           END

                           IF ~BIND:FieldDefaultValue THEN BIND:FieldDefaultValue = 'Default Error: ' & LOC:DS:FieldDefaultValue[SCRQ:RecordID,LOC:ThisField].

                        END


                        LOC:ScreenField[SCRQ:RecordID,FieldDefault#] = EVALUATE(BIND:FieldDefaultValue)


    !                    MESSAGE('LOC:ScreenField[SCRQ:RecordID,FieldDefault#] = ' & LOC:ScreenField[SCRQ:RecordID,FieldDefault#] &|
    !                            '|EVALUATE(BIND:FieldDefaultValue) = ' & EVALUATE(BIND:FieldDefaultValue))


    !                    ! THE USE CAN PUT A FIELD HERE - LIKE GLO:TodaysDate
    !                    IF ~LOC:ScreenField[SCRQ:RecordID,FieldDefault#]
    !
    !
    !                        LOC:ScreenField[SCRQ:RecordID,FieldDefault#] = EVALUATE(LOC:DS:FieldDefaultValue[SCRQ:RecordID,FieldDefault#])
    !                    END
                    END
                 END

           END
       END


AssignArrays      ROUTINE

     LOOP X# = 1 TO 30
           LOC:DS:Field[SCRQ:RecordID,X#]                = ''
           LOC:DS:RefreshScreenFlag[SCRQ:RecordID,X#] = 0
           LOC:DS:FieldEquate[SCRQ:RecordID,X#]          = 0
           LOC:DS:FieldCalculation[SCRQ:RecordID,X#]     = ''
           LOC:DS:FieldDropDownOptions[SCRQ:RecordID,X#] = ''
           LOC:DS:FieldType[SCRQ:RecordID,X#]            = ''
           LOC:DS:FieldHelp[SCRQ:RecordID,X#]            = ''
           LOC:DS:FieldRequiredFlag[SCRQ:RecordID,X#]    = 0
           LOC:DS:FieldRequiredCondition[SCRQ:RecordID,X#] = ''
           LOC:DS:DisableFlag[SCRQ:RecordID,X#]    = 0
           LOC:DS:DisableCondition[SCRQ:RecordID,X#] = ''
           LOC:DS:WriteBackCondition[SCRQ:RecordID,X#] = ''
           LOC:DS:HideFlag[SCRQ:RecordID,X#]    = 0
           LOC:DS:HideCondition[SCRQ:RecordID,X#] = ''
           LOC:DS:Color1Condition[SCRQ:RecordID,X#] = ''
           LOC:DS:Color1[SCRQ:RecordID,X#] = ''
           LOC:DS:WriteBackFlag[SCRQ:RecordID,X#] = ''
           LOC:DS:WriteBackTable[SCRQ:RecordID,X#] = ''
           LOC:DS:WriteBackColumn[SCRQ:RecordID,X#] = ''
           LOC:DS:WriteBackRoleID[SCRQ:RecordID,X#] = ''
           LOC:DS:LookupScript[SCRQ:RecordID,X#] = ''
     END

     FREE(LookupQueue1)
     FREE(LookupQueue2)
     FREE(LookupQueue3)
     FREE(LookupQueue4)
     FREE(LookupQueue5)
     FREE(LookupQueue6)
     FREE(LookupQueue7)
     FREE(LookupQueue8)
     FREE(LookupQueue9)
     FREE(LookupQueue10)
     FREE(LookupQueue11)
     FREE(LookupQueue12)
     FREE(LookupQueue13)
     FREE(LookupQueue14)
     FREE(LookupQueue15)
     FREE(LookupQueue16)
     FREE(LookupQueue17)
     FREE(LookupQueue18)
     FREE(LookupQueue19)
     FREE(LookupQueue20)
     FREE(LookupQueue21)
     FREE(LookupQueue22)
     FREE(LookupQueue23)
     FREE(LookupQueue24)
     FREE(LookupQueue25)
     FREE(LookupQueue26)
     FREE(LookupQueue27)
     FREE(LookupQueue28)
     FREE(LookupQueue29)
     FREE(LookupQueue30)

      CLEAR(DSF:Record)
      DSF:DocScrnID = DS:RecordID
      SET(DSF:DocScrnKey,DSF:DocScrnKey)
      LOOP UNTIL Access:DocScrnField.Next()
           IF ~(DSF:DocScrnID = DS:RecordID) THEN BREAK.

!            MESSAGE('DSF:FieldNumber = ' & DSF:FieldNumber)
           IF DSF:FieldNumber > 30 THEN BREAK.  ! ONLY ALLOWED 20 FIELDS
                                                ! FIELDS 21-30 ARE USED FOR STORAGE AND CALCULATIONS

           LOC:DS:Field[SCRQ:RecordID,DSF:FieldNumber]                = DSF:FieldPrompt
           LOC:DS:RefreshScreenFlag[SCRQ:RecordID,DSF:FieldNumber]    = DSF:RefreshScreenFlag
           LOC:DS:FieldCalculation[SCRQ:RecordID,DSF:FieldNumber]     = DSF:FieldCalculation
           LOC:DS:FieldDropDownOptions[SCRQ:RecordID,DSF:FieldNumber] = DSF:FieldDropDownOptions
           LOC:DS:FieldType[SCRQ:RecordID,DSF:FieldNumber]            = DSF:FieldType
           LOC:DS:FieldRequiredFlag[SCRQ:RecordID,DSF:FieldNumber]    = DSF:FieldRequiredFlag
           LOC:DS:FieldHelp[SCRQ:RecordID,DSF:FieldNumber]            = DSF:FieldHelp
           LOC:DS:FieldRequiredFlag[SCRQ:RecordID,DSF:FieldNumber]    = DSF:FieldRequiredFlag
           LOC:DS:FieldRequiredCondition[SCRQ:RecordID,DSF:FieldNumber]  = DSF:FieldRequiredCondition
           LOC:DS:DisableFlag[SCRQ:RecordID,DSF:FieldNumber]    = DSF:DisableFlag
           LOC:DS:DisableCondition[SCRQ:RecordID,DSF:FieldNumber]  = DSF:DisableCondition
           LOC:DS:WriteBackCondition[SCRQ:RecordID,DSF:FieldNumber]  = DSF:WriteBackCondition
           LOC:DS:HideFlag[SCRQ:RecordID,DSF:FieldNumber]    = DSF:HideFlag
           LOC:DS:HideCondition[SCRQ:RecordID,DSF:FieldNumber]  = DSF:HideCondition
           LOC:DS:Color1Condition[SCRQ:RecordID,DSF:FieldNumber]        = DSF:Color1Condition
           LOC:DS:Color1[SCRQ:RecordID,DSF:FieldNumber]                 = DSF:Color1
           LOC:DS:FieldDefaultValue[SCRQ:RecordID,DSF:FieldNumber]      = DSF:DefaultValue
           LOC:DS:WriteBackFlag[SCRQ:RecordID,DSF:FieldNumber]          = DSF:WriteBackFlag
           LOC:DS:WriteBackTable[SCRQ:RecordID,DSF:FieldNumber]         = DSF:WriteBackTable
           LOC:DS:WriteBackColumn[SCRQ:RecordID,DSF:FieldNumber]        = DSF:WriteBackColumn
           LOC:DS:WriteBackRoleID[SCRQ:RecordID,DSF:FieldNumber]        = DSF:WriteBackRoleID
           LOC:DS:LookupScript[SCRQ:RecordID,DSF:FieldNumber]           = DSF:LookupScript

           IF DSF:FieldNumber <= 20        ! ONLY 20 LOOKUP DROP DOWNS

              IF DSF:FieldType = 'L' AND DSF:LookupTable AND DSF:LookupColumn

                 CLEAR(ROW:Record)
                 LOC:SQLString = 'SELECT RecordID, ' & DSF:LookupColumn & ' FROM ' & DSF:LookupTable
                 IF DSF:LookupScript
                    LOC:SQLString = LOC:SQLString & ' WHERE ' & DSF:LookupScript
                 END
                 LOC:SQLString = LOC:SQLString & ' ORDER BY ' & DSF:LookupColumn


                 
                 RowCounter{PROP:SQL} = LOC:SQLString

                 LOOP
                 
                      NEXT(RowCounter)
                      IF ERROR() THEN BREAK.
                      EXECUTE DSF:FieldNumber
                         BEGIN;LQ1:RecordID = ROW:Counter;LQ1:Description = ROW:Description;
                         ADD(LookupQueue1,LQ1:Description);END
                         BEGIN;LQ2:RecordID = ROW:Counter;LQ2:Description = ROW:Description;ADD(LookupQueue2,LQ2:Description);END
                         BEGIN;LQ3:RecordID = ROW:Counter;LQ3:Description = ROW:Description;ADD(LookupQueue3,LQ3:Description);END
                         BEGIN;LQ4:RecordID = ROW:Counter;LQ4:Description = ROW:Description;ADD(LookupQueue4,LQ4:Description);END
                         BEGIN;LQ5:RecordID = ROW:Counter;LQ5:Description = ROW:Description;ADD(LookupQueue5,LQ5:Description);END
                         BEGIN;LQ6:RecordID = ROW:Counter;LQ6:Description = ROW:Description;ADD(LookupQueue6,LQ6:Description);END
                         BEGIN;LQ7:RecordID = ROW:Counter;LQ7:Description = ROW:Description;ADD(LookupQueue7,LQ7:Description);END
                         BEGIN;LQ8:RecordID = ROW:Counter;LQ8:Description = ROW:Description;ADD(LookupQueue8,LQ8:Description);END
                         BEGIN;LQ9:RecordID = ROW:Counter;LQ9:Description = ROW:Description;ADD(LookupQueue9,LQ9:Description);END
                         BEGIN;LQ10:RecordID = ROW:Counter;LQ10:Description = ROW:Description;ADD(LookupQueue10,LQ10:Description);END
                         BEGIN;LQ11:RecordID = ROW:Counter;LQ11:Description = ROW:Description;ADD(LookupQueue11,LQ11:Description);END
                         BEGIN;LQ12:RecordID = ROW:Counter;LQ12:Description = ROW:Description;ADD(LookupQueue12,LQ12:Description);END
                         BEGIN;LQ13:RecordID = ROW:Counter;LQ13:Description = ROW:Description;ADD(LookupQueue13,LQ13:Description);END
                         BEGIN;LQ14:RecordID = ROW:Counter;LQ14:Description = ROW:Description;ADD(LookupQueue14,LQ14:Description);END
                         BEGIN;LQ15:RecordID = ROW:Counter;LQ15:Description = ROW:Description;ADD(LookupQueue15,LQ15:Description);END
                         BEGIN;LQ16:RecordID = ROW:Counter;LQ16:Description = ROW:Description;ADD(LookupQueue16,LQ16:Description);END
                         BEGIN;LQ17:RecordID = ROW:Counter;LQ17:Description = ROW:Description;ADD(LookupQueue17,LQ17:Description);END
                         BEGIN;LQ18:RecordID = ROW:Counter;LQ18:Description = ROW:Description;ADD(LookupQueue18,LQ18:Description);END
                         BEGIN;LQ19:RecordID = ROW:Counter;LQ19:Description = ROW:Description;ADD(LookupQueue19,LQ19:Description);END
                         BEGIN;LQ20:RecordID = ROW:Counter;LQ20:Description = ROW:Description;ADD(LookupQueue20,LQ20:Description);END
                         BEGIN;LQ21:RecordID = ROW:Counter;LQ21:Description = ROW:Description;ADD(LookupQueue21,LQ21:Description);END
                         BEGIN;LQ22:RecordID = ROW:Counter;LQ22:Description = ROW:Description;ADD(LookupQueue22,LQ22:Description);END
                         BEGIN;LQ23:RecordID = ROW:Counter;LQ23:Description = ROW:Description;ADD(LookupQueue23,LQ23:Description);END
                         BEGIN;LQ24:RecordID = ROW:Counter;LQ24:Description = ROW:Description;ADD(LookupQueue24,LQ24:Description);END
                         BEGIN;LQ25:RecordID = ROW:Counter;LQ25:Description = ROW:Description;ADD(LookupQueue25,LQ25:Description);END
                         BEGIN;LQ26:RecordID = ROW:Counter;LQ26:Description = ROW:Description;ADD(LookupQueue26,LQ26:Description);END
                         BEGIN;LQ27:RecordID = ROW:Counter;LQ27:Description = ROW:Description;ADD(LookupQueue27,LQ27:Description);END
                         BEGIN;LQ28:RecordID = ROW:Counter;LQ28:Description = ROW:Description;ADD(LookupQueue28,LQ28:Description);END
                         BEGIN;LQ29:RecordID = ROW:Counter;LQ29:Description = ROW:Description;ADD(LookupQueue29,LQ29:Description);END
                         BEGIN;LQ30:RecordID = ROW:Counter;LQ30:Description = ROW:Description;ADD(LookupQueue30,LQ30:Description);END
                      END

                 END
              END
           END

      END

HideUnHideButtons   ROUTINE

  IF LOC:ScreenType = 'D' 
     IF GLO:SupervisorFlag
        IF RECORDS(ScreenQueue)
           UNHIDE(?ModifyButton)
           UNHIDE(?DeleteButton)
        ELSE
           HIDE(?ModifyButton)
           HIDE(?DeleteButton)
        END
     ELSE
        HIDE(?ModifyButton)
        HIDE(?DeleteButton)
     END
  END


WriteBackData       ROUTINE

       ! CHECK FOR ANY DATA TO WRITE BACK

       LOOP LOC:ScreenCounter = 1 TO RECORDS(ScreenQueue)

          GET(ScreenQueue,LOC:ScreenCounter)

            LOOP FieldLookup# = 1 TO 30

                 IF  LOC:DS:WriteBackFlag[SCRQ:RecordID,FieldLookup#] AND LOC:DS:WriteBackTable[SCRQ:RecordID,FieldLookup#] |
                 AND LOC:DS:WriteBackColumn[SCRQ:RecordID,FieldLookup#] AND LOC:ScreenField[SCRQ:RecordID,FieldLookup#]


                    BIND:WriteBackCondition = LOC:DS:WriteBackCondition[SCRQ:RecordID,FieldLookup#]
                    IF BIND:WriteBackCondition

                       IF EVALUATE(BIND:WriteBackCondition) = '1'

                          ModifyViaPropSQL(LOC:DS:WriteBackTable[SCRQ:RecordID,FieldLookup#],LOC:DS:WriteBackColumn[SCRQ:RecordID,FieldLookup#],LOC:ScreenField[SCRQ:RecordID,FieldLookup#],LOC:DS:WriteBackRoleID[SCRQ:RecordID,FieldLookup#])
                          LOC:DataWrittenBackFlag = True   ! CAN USE THIS TO REFRESH MATTER BROWSE OR PARTY BROWSE OR WHATEVER IF DATA HAS BEEN CHANGED

                       END

                    ELSE

                       ModifyViaPropSQL(LOC:DS:WriteBackTable[SCRQ:RecordID,FieldLookup#],LOC:DS:WriteBackColumn[SCRQ:RecordID,FieldLookup#],LOC:ScreenField[SCRQ:RecordID,FieldLookup#],LOC:DS:WriteBackRoleID[SCRQ:RecordID,FieldLookup#])
                       LOC:DataWrittenBackFlag = True   ! CAN USE THIS TO REFRESH MATTER BROWSE OR PARTY BROWSE OR WHATEVER IF DATA HAS BEEN CHANGED

                    END

                       IF GLO:DebuggingFlag
                           MESSAGE('LOC:DataWrittenBackFlag = ' & LOC:DataWrittenBackFlag,'Debugging')
                       END


                 END

            END

       END

       IF LOC:DataWrittenBackFlag
          LOC:DataWrittenBackFlag = 0

         IF DS:ScreenType = 'D'
            Access:Matter.TryFetch(MAT:PrimaryKey) ! REGET THE RECORD SO IT REFLECTS THE UPDATED CONTENTS
         ELSIF DS:ScreenType = 'P'
            Access:Party.TryFetch(PAR:PrimaryKey) ! REGET THE RECORD SO IT REFLECTS THE UPDATED CONTENTS
         ELSIF DS:ScreenType = 'R'
            Access:MatParty.TryFetch(MP:PrimaryKey) ! REGET THE RECORD SO IT REFLECTS THE UPDATED CONTENTS
         END
      END



ConstructTheScreen   ROUTINE

      LOC:XPos = X + 10
      LOC:Longest1 = 0      ! PROMPT SPACING 1-15
      LOC:Longest2 = 0      ! PROMPT SPACING 16-30

      LOC:Column2PromptPos = ?Sheet1{PROP:XPos} + (?Sheet1{PROP:Width}/2)  + 10

      LOC:TabEquate = SCRQ:TabEquate

      UNHIDE(LOC:TabEquate)

      LOC:LineSpacing = 15

      ! REDUCE LINE SPACING FOR THE ADDRESS BOOK IF MORE THAN 20 FIELDS
      IF DS:ScreenType = 'P'
         IF LOC:DS:Field[SCRQ:RecordID,21] OR LOC:DS:Field[SCRQ:RecordID,22] OR LOC:DS:Field[SCRQ:RecordID,23] OR LOC:DS:Field[SCRQ:RecordID,24] OR LOC:DS:Field[SCRQ:RecordID,25]
            LOC:LineSpacing = 13
         END
      END
      ! REDUCE LINE SPACING FOR THE MATPARTY SCREEN IF MORE THAN 20 FIELDS
      IF DS:ScreenType = 'R'
         IF LOC:DS:Field[SCRQ:RecordID,21] OR LOC:DS:Field[SCRQ:RecordID,22] OR LOC:DS:Field[SCRQ:RecordID,23] OR LOC:DS:Field[SCRQ:RecordID,24] OR LOC:DS:Field[SCRQ:RecordID,25]
            LOC:LineSpacing = 12
         END
      END

      LOOP LOC:FieldCounter = 1 TO LOC:DisplayHowMany  ! DO THE LONGEST PROMPTS FIRST SO WE CAN WORK OUT THE SPACING


           IF LOC:DisplayHowMany = 30

              IF LOC:FieldCounter = 21
                 LOC:XPos = X + 10


              END
           END

           IF LOC:FieldCounter = LOC:SecondColumnBegin OR LOC:FieldCounter = 26

               LOC:Xpos = LOC:Column2PromptPos

           END

           IF LOC:FieldCounter = LOC:SecondColumnBegin OR LOC:FieldCounter = 1
              LOC:YPos = Y + 15                                 ! RESET THE Y POS TO THE TOP OF THE SCREEN
           ELSE
              LOC:YPos += LOC:LineSpacing                       ! MOVE DOWN 
           END

           IF LOC:FieldCounter = 21
              SAV:Field21YPos = LOC:Ypos
           END

           IF LOC:FieldCounter = 26
              LOC:Ypos = SAV:Field21YPos                        ! RESET THE Y POS TO THE YPOS OF FIELD 21
           END


           IF LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter]

              LOC:FieldEquate += 1
              LOC:Field = CREATE(LOC:FieldEquate,CREATE:Prompt,LOC:TabEquate)

              LOC:PromptNumber[SCRQ:RecordID,LOC:FieldCounter] = LOC:Field

              IF INSTRING('[[',LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter],1)

                 IF GlobalErrors.GetProcedureName() = 'UpdateMatParty'  

                        ORIG:MP:RecordID = MP:RecordID  ! ADDED BY RICK 21/11/2012 - THERE WAS A PROBLEM IF A PARTY FIELD WAS USED AND IT LOOPED THRU THE MATPARTIES
                                                        ! E.G. [[CREDITOR.ALL.FIELD.CLAIM AMOUNT.TOTAL]]

                        LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter] = ReplaceTextBoxFields(LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter],MP:LanguageID,MP:PartyID,MP:MatterID)

                        GlobalErrors.SetProcedureName('UpdateMatParty')
                        

                        IF ~(ORIG:MP:RecordID = MP:RecordID)
                             MP:RecordID = ORIG:MP:RecordID
                             Access:MatParty.TryFetch(MP:PrimaryKey)
                        END

                 ELSIF GlobalErrors.GetProcedureName() = 'UpdateParty'
                    LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter] = ReplaceTextBoxFields(LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter],PAR:DefaultLanguageID,PAR:RecordID,0)
                    GlobalErrors.SetProcedureName('UpdateParty')

                 ELSE
                    LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter] = ReplaceTextBoxFields(LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter],MAT:DocumentLanguageID,0,MAT:RecordID)
                 END

                 IF ~LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter] THEN LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter] = '* Error *'.

              END

              IF EVALUATE(LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter])
                 LOC:Field{PROP:Text} = EVALUATE(LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter]) & ':'
              ELSE
                 LOC:Field{PROP:Text} = LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter] & ':'
              END

              LOC:Field{PROP:Xpos} = LOC:XPos
              LOC:Field{PROP:Ypos} = LOC:Ypos

              IF LOC:Field{PROP:Width} > 150 THEN LOC:Field{PROP:Width} = 150.  ! MAXIMUM PROMPT LENGTH

              IF LOC:FieldCounter >= LOC:SecondColumnBegin
                 IF LOC:Field{PROP:Width} > LOC:Longest2
                    LOC:Longest2 = LOC:Field{PROP:Width}
                 END
              ELSE
                 IF LOC:Field{PROP:Width} > LOC:Longest1
                    LOC:Longest1 = LOC:Field{PROP:Width}
                 END
              END

              UNHIDE(LOC:Field)

              IF LOC:DS:DisableFlag[SCRQ:RecordID,LOC:FieldCounter]

                 BIND:DisableCondition = LOC:DS:DisableCondition[SCRQ:RecordID,LOC:FieldCounter]
                 IF BIND:DisableCondition
                    IF EVALUATE(BIND:DisableCondition) = '1'
                       LOC:Field{PROP:Disable} = True
                    ELSE
                       LOC:Field{PROP:Disable} = False
                    END
                 ELSE
                    LOC:Field{PROP:Disable} = True
                 END

              ELSE
                 LOC:Field{PROP:Disable} = False
              END


              IF LOC:DS:HideFlag[SCRQ:RecordID,LOC:FieldCounter]

                 BIND:HideCondition = LOC:DS:HideCondition[SCRQ:RecordID,LOC:FieldCounter]
                 IF BIND:HideCondition
                    IF EVALUATE(BIND:HideCondition) = '1'
                       LOC:Field{PROP:Hide} = True
                    ELSE
                       LOC:Field{PROP:Hide} = False
                    END
                 ELSE
                    LOC:Field{PROP:Hide} = True
                 END

              ELSE
                 LOC:Field{PROP:Hide} = False
              END


           END
      END



      LOC:XPos = X + LOC:Longest1 + 15

      LOC:Wide = ?Sheet1{PROP:Width} - (LOC:XPos - ?Sheet1{PROP:Xpos}) - 10

      LOC:Medium = LOC:Wide - 200


      LOC:Narrow1 = LOC:Column2PromptPos - LOC:XPos - 20


      LOOP LOC:FieldCounter = 1 TO LOC:DisplayHowMany


           IF LOC:DisplayHowMany = 30
              IF LOC:FieldCounter = 21

                 LOC:XPos = X + LOC:Longest1 + 15

              END

           END


           IF LOC:FieldCounter = LOC:SecondColumnBegin OR LOC:FieldCounter = 26

               LOC:XPos = LOC:Column2PromptPos +  LOC:Longest2 + 5

               LOC:Narrow2 = ?Sheet1{PROP:Xpos} + ?Sheet1{PROP:Width} - LOC:XPos - 10

           END


           IF LOC:FieldCounter = LOC:SecondColumnBegin OR LOC:FieldCounter = 1
              LOC:YPos = Y + 15                                 ! RESET THE Y POS
           ELSE
              LOC:YPos += LOC:LineSpacing                       ! MOVE DOWN 
           END

           IF LOC:FieldCounter = 26
              LOC:Ypos = SAV:Field21YPos

           END

           IF LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter]

              IF LOC:DS:FieldRequiredFlag[SCRQ:RecordID,LOC:FieldCounter]

                    LOC:FieldEquate += 1

                    LOC:Field = CREATE(LOC:FieldEquate,CREATE:String,LOC:TabEquate)

                    LOC:Field{PROP:Text} = '*'
                    LOC:Field{PROP:Xpos} = LOC:Xpos-5;LOC:Field{PROP:Ypos} = LOC:Ypos + 2
                    LOC:DS:FieldRequiredStarFieldNumber[SCRQ:RecordID,LOC:FieldCounter] = LOC:Field

                    BIND:FieldRequiredCondition = LOC:DS:FieldRequiredCondition[SCRQ:RecordID,LOC:FieldCounter]
                    IF BIND:FieldRequiredCondition
                       IF EVALUATE(BIND:FieldRequiredCondition) = '1' THEN UNHIDE(LOC:DS:FieldRequiredStarFieldNumber[SCRQ:RecordID,LOC:FieldCounter]).
                    ELSE
                       UNHIDE(LOC:DS:FieldRequiredStarFieldNumber[SCRQ:RecordID,LOC:FieldCounter])
                    END

              END

              LOC:FieldEquate += 1

              LOC:DS:FieldEquate[SCRQ:RecordID,LOC:FieldCounter] = LOC:FieldEquate

              IF LOC:DS:FieldType[SCRQ:RecordID,LOC:FieldCounter] = 'N'
                  LOC:Field = CREATE(LOC:FieldEquate,CREATE:Entry,LOC:TabEquate)
                  LOC:Field{PROP:Text} = '@N-15.2B';LOC:Field{PROP:Right} = True
              ELSIF LOC:DS:FieldType[SCRQ:RecordID,LOC:FieldCounter] = 'D'
                  LOC:Field = CREATE(LOC:FieldEquate,CREATE:Entry,LOC:TabEquate)
                  LOC:Field{PROP:Text} = '@d17b'
              ELSIF LOC:DS:FieldType[SCRQ:RecordID,LOC:FieldCounter] = 'R'
                  LOC:Field = CREATE(LOC:FieldEquate,CREATE:DropList,LOC:TabEquate)
                  LOC:Field{PROP:From} = LOC:DS:FieldDropDownOptions[SCRQ:RecordID,LOC:FieldCounter]
                  LOC:Field{PROP:Drop} = 15
              ELSIF LOC:DS:FieldType[SCRQ:RecordID,LOC:FieldCounter] = 'L'
                  LOC:Field = CREATE(LOC:FieldEquate,CREATE:DropList,LOC:TabEquate)
                  EXECUTE LOC:FieldCounter
                    LOC:Field{PROP:From} = LookupQueue1
                    LOC:Field{PROP:From} = LookupQueue2
                    LOC:Field{PROP:From} = LookupQueue3
                    LOC:Field{PROP:From} = LookupQueue4
                    LOC:Field{PROP:From} = LookupQueue5
                    LOC:Field{PROP:From} = LookupQueue6
                    LOC:Field{PROP:From} = LookupQueue7
                    LOC:Field{PROP:From} = LookupQueue8
                    LOC:Field{PROP:From} = LookupQueue9
                    LOC:Field{PROP:From} = LookupQueue10
                    LOC:Field{PROP:From} = LookupQueue11
                    LOC:Field{PROP:From} = LookupQueue12
                    LOC:Field{PROP:From} = LookupQueue13
                    LOC:Field{PROP:From} = LookupQueue14
                    LOC:Field{PROP:From} = LookupQueue15
                    LOC:Field{PROP:From} = LookupQueue16
                    LOC:Field{PROP:From} = LookupQueue17
                    LOC:Field{PROP:From} = LookupQueue18
                    LOC:Field{PROP:From} = LookupQueue19
                    LOC:Field{PROP:From} = LookupQueue20
                    LOC:Field{PROP:From} = LookupQueue21
                    LOC:Field{PROP:From} = LookupQueue22
                    LOC:Field{PROP:From} = LookupQueue23
                    LOC:Field{PROP:From} = LookupQueue24
                    LOC:Field{PROP:From} = LookupQueue25
                    LOC:Field{PROP:From} = LookupQueue26
                    LOC:Field{PROP:From} = LookupQueue27
                    LOC:Field{PROP:From} = LookupQueue28
                    LOC:Field{PROP:From} = LookupQueue29
                    LOC:Field{PROP:From} = LookupQueue30
                  ELSE
                    LOC:Field{PROP:From} = 'Invalid|#I'
                  END
                  LOC:Field{PROP:Format} = '100L(2)@s254@'
                  LOC:Field{PROP:Drop} = 25
                  LOC:Field{PROP:VScroll} = 1
              ELSIF LOC:DS:FieldType[SCRQ:RecordID,LOC:FieldCounter] = 'Y'
                  LOC:Field = CREATE(LOC:FieldEquate,CREATE:Option,LOC:TabEquate)
                  LOC:Field{PROP:Xpos} = LOC:XPos;LOC:Field{PROP:Ypos} = LOC:Ypos; 
                  LOC:ParentField = LOC:Field
              ELSE
                  LOC:Field = CREATE(LOC:FieldEquate,CREATE:Entry,LOC:TabEquate)
                  LOC:Field{PROP:Text} = 's254'
                  LOC:Field{PROP:IMM} = True
                  LOC:Field{PROP:ALRT,255} = UpKey
                  LOC:Field{PROP:ALRT,255} = DownKey
                  LOC:Field{PROP:ALRT,255} = CtrlUp
                  LOC:Field{PROP:ALRT,255} = CtrlDown
              END


              ! Rick & PK 14/4/2018
              LOC:Field{PROP:FontName} = 'MS Sans Serif'


              LOC:FieldNumber[SCRQ:RecordID,LOC:FieldCounter] = LOC:Field
              LOC:Field{PROP:Use} = LOC:ScreenField[SCRQ:RecordID,LOC:FieldCounter]
              LOC:Field{PROP:Xpos} = LOC:XPos;LOC:Field{PROP:Ypos} = LOC:Ypos; LOC:Field{PROP:Height} = 10
              IF LOC:DS:FieldHelp[SCRQ:RecordID,LOC:FieldCounter] THEN LOC:Field{PROP:Tooltip} = LOC:DS:FieldHelp[SCRQ:RecordID,LOC:FieldCounter].
              UNHIDE(LOC:Field)

              IF LOC:DS:DisableFlag[SCRQ:RecordID,LOC:FieldCounter]

                 BIND:DisableCondition = LOC:DS:DisableCondition[SCRQ:RecordID,LOC:FieldCounter]
                 IF BIND:DisableCondition
                    IF EVALUATE(BIND:DisableCondition) = '1'
                       LOC:Field{PROP:Disable} = True
                    ELSE
                       LOC:Field{PROP:Disable} = False
                    END
                 ELSE
                    LOC:Field{PROP:Disable} = True
                 END

              ELSE
                 LOC:Field{PROP:Disable} = False
              END


              IF LOC:DS:HideFlag[SCRQ:RecordID,LOC:FieldCounter]

                 BIND:HideCondition = LOC:DS:HideCondition[SCRQ:RecordID,LOC:FieldCounter]
                 IF BIND:HideCondition
                    IF EVALUATE(BIND:HideCondition) = '1'
                       LOC:Field{PROP:Hide} = True
                    ELSE
                       LOC:Field{PROP:Hide} = False
                    END
                 ELSE
                    LOC:Field{PROP:Hide} = True
                 END

              ELSE
                 LOC:Field{PROP:Hide} = False
              END



              IF LOC:DS:FieldType[SCRQ:RecordID,LOC:FieldCounter] = 'Y'  ! ADD Radio Buttons
                  LOC:FieldEquate += 1
                  LOC:Field = CREATE(LOC:FieldEquate,CREATE:Radio,LOC:ParentField)
                  LOC:Field{PROP:Text} = '&Yes'
                  LOC:Field{PROP:Value} = 'Y'
                  LOC:Field{PROP:Xpos} = LOC:XPos;LOC:Field{PROP:Ypos} = LOC:Ypos; LOC:Field{PROP:Height} = 10
                  UNHIDE(LOC:Field)
                  LOC:FieldEquate += 1
                  LOC:Field = CREATE(LOC:FieldEquate,CREATE:Radio,LOC:ParentField)
                  LOC:Field{PROP:Text} = '&No';LOC:Field{PROP:Value} = 'N'
                  LOC:Field{PROP:Xpos} = LOC:XPos + 35;LOC:Field{PROP:Ypos} = LOC:Ypos; LOC:Field{PROP:Height} = 10
                  UNHIDE(LOC:Field)
              END

              !  SET FIELD WIDTHS

              IF LOC:DS:FieldType[SCRQ:RecordID,LOC:FieldCounter] = 'S'  ! CHANGE THE LENGTH OF THE STRING FIELDS (NOT IN 11-20)

                 IF (LOC:FieldCounter >= 11 AND LOC:FieldCounter <= 20) OR LOC:FieldCounter >= 26
                     LOC:Field{PROP:Width} = LOC:Narrow2
                 ELSIF LOC:FieldCounter <= 10 AND LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter+10]
                     LOC:Field{PROP:Width} = LOC:Narrow1
                 ELSIF LOC:FieldCounter >= 21 AND LOC:FieldCounter <= 25 AND LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter+5]
                     LOC:Field{PROP:Width} = LOC:Narrow1
                 ELSE
                     LOC:Field{PROP:Width} = LOC:Wide
                 END

              ELSIF LOC:DS:FieldType[SCRQ:RecordID,LOC:FieldCounter] = 'D' OR LOC:DS:FieldType[SCRQ:RecordID,LOC:FieldCounter] = 'N'

                 LOC:Field{PROP:Width} = 60

              ELSIF LOC:DS:FieldType[SCRQ:RecordID,LOC:FieldCounter] = 'R' OR LOC:DS:FieldType[SCRQ:RecordID,LOC:FieldCounter] = 'L'

                 IF (LOC:FieldCounter >= 11 AND LOC:FieldCounter <= 20) OR LOC:FieldCounter >= 26
                     LOC:Field{PROP:Width} = LOC:Narrow2
                 ELSIF LOC:FieldCounter <= 10 AND LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter+10]
                     LOC:Field{PROP:Width} = LOC:Narrow1
                 ELSIF LOC:FieldCounter >= 21 AND LOC:FieldCounter <= 25 AND LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter+5]
                     LOC:Field{PROP:Width} = LOC:Narrow1
                 ELSE
                     LOC:Field{PROP:Width} = LOC:Medium
                 END

              ELSIF LOC:DS:FieldType[SCRQ:RecordID,LOC:FieldCounter] <> 'Y'

                 IF (LOC:FieldCounter >= 11 AND LOC:FieldCounter <= 20) OR LOC:FieldCounter >= 26
                     IF LOC:Narrow2 < 90 THEN LOC:Field{PROP:Width} = LOC:Narrow2 ELSE LOC:Field{PROP:Width} = 90.
                 ELSIF LOC:FieldCounter <= 10 AND LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter+10]
                     IF LOC:Narrow1 < 90 THEN LOC:Field{PROP:Width} = LOC:Narrow1 ELSE LOC:Field{PROP:Width} = 90.
                 ELSIF LOC:FieldCounter >= 21 AND LOC:FieldCounter <= 25 AND LOC:DS:Field[SCRQ:RecordID,LOC:FieldCounter+5]
                     IF LOC:Narrow1 < 90 THEN LOC:Field{PROP:Width} = LOC:Narrow1 ELSE LOC:Field{PROP:Width} = 90.
                 ELSE
                     LOC:Field{PROP:Width} = 90
                 END

              END

              DO SetupCalculationFields

           ELSE
!              BREAK
           END

      END

SECTION('OK Button')

       ! CHECK FOR ANY REQUIRED FIELDS

       LOC:NeedEntryFlag = 0


       LOOP LOC:ScreenCounter = 1 TO RECORDS(ScreenQueue)

          GET(ScreenQueue,LOC:ScreenCounter)

          IF SCRQ:DoNotCheckThisScreen THEN CYCLE.  ! ONLY CHECK THIS SCREEN IF MERGING
      
          LOOP FieldLookup# = 1 TO LOC:DisplayHowMany

             IF LOC:DS:FieldRequiredFlag[SCRQ:RecordID,FieldLookup#]


!  message('FieldLookup# = ' & FieldLookup# &|
!          '|BIND:FieldRequiredCondition = ' & BIND:FieldRequiredCondition)

                BIND:FieldRequiredCondition = LOC:DS:FieldRequiredCondition[SCRQ:RecordID,FieldLookup#]
                IF BIND:FieldRequiredCondition
                   IF EVALUATE(BIND:FieldRequiredCondition) = '0' THEN CYCLE.
                END
                                                                 
                IF ~LOC:ScreenField[SCRQ:RecordID,FieldLookup#] OR (LOC:DS:FieldType[SCRQ:RecordID,FieldLookup#] = 'N' AND LOC:ScreenField[SCRQ:RecordID,FieldLookup#] = '0') OR (LOC:DS:FieldType[SCRQ:RecordID,FieldLookup#] = 'D' AND LOC:ScreenField[SCRQ:RecordID,FieldLookup#] = '0')

                    BEEP(BEEP:SystemDefault)
                    BEEP(BEEP:SystemHand)
                    BEEP(BEEP:SystemQuestion)
                    BEEP(BEEP:SystemExclamation)
                    BEEP(BEEP:SystemAsterisk)

                    SELECT(LOC:FieldNumber[SCRQ:RecordID,FieldLookup#])
                    LOC:NeedEntryFlag = 1
                    BREAK
                END
             END

          END
          IF LOC:NeedEntryFlag = 1 THEN BREAK.

       END
       IF LOC:NeedEntryFlag = 1 THEN CYCLE.     ! ABORT OK LOOP

       DO WriteBackData

       GlobalResponse = RequestCompleted



