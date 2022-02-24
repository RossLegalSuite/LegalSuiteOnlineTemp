Search & Replace
----------------
IF (.*?)\n
if ($1) {\n



FindDate             PROCEDURE  (TheDate,DaysTime,WorkingDaysFlag,SpecificDayMask,<ExcludeCourtHolidaysFlag>,<ExcludeCourtRecessFlag>,<AllowWeekendsAndHolidays>) ! Declare Procedure
ezField              LONG
LOC:WorkingDaysFlag    LONG
LOC:SpecificDayMask    LONG
LOC:ExcludeCourtHolidaysFlag    LONG
LOC:DaysTime           LONG
LOC:DayOption          LONG
LOC:DayCounter      LONG
LOC:Date            LONG
LOC:CurrentDate     LONG
LOC:Sunday          EQUATE(1000000b)
LOC:Monday          EQUATE(0100000b)
LOC:Tuesday         EQUATE(0010000b)
LOC:Wednesday       EQUATE(0001000b)
LOC:Thursday        EQUATE(0000100b)
LOC:Friday          EQUATE(0000010b)
LOC:Saturday        EQUATE(0000001b)
  CODE
        LOC:Date = TheDate
        IF ~LOC:Date THEN LOC:Date = GLO:TodaysDate.

        LOC:WorkingDaysFlag          = WorkingDaysFlag
        LOC:ExcludeCourtHolidaysFlag = ExcludeCourtHolidaysFlag
        LOC:SpecificDayMask          = SpecificDayMask
        LOC:DaysTime                 = DaysTime

        IF LOC:DaysTime > 1000 THEN DO ReturnProcedure.

        IF LOC:DaysTime = 0
           IF LOC:SpecificDayMask       ! THE USER WANTS TO FIND THE NEXT THRUSDAY, FOR EXAMPLE.
              DO GetNextSpecificDate
              DO ReturnProcedure
           ELSE
              DO ReturnProcedure
           END
        END
        

        DO CalculateDays


        DO GetSpecificDay

        DO ReturnProcedure


CalculateDays    ROUTINE

        IF LOC:WorkingDaysFlag

           LOC:DayCounter = 0

           IF LOC:DaysTime > 0
              LOC:CurrentDate = LOC:Date + 1       ! NOTE: START COUNTING FROM THE NEXT DAY
           ELSE
              LOC:CurrentDate = LOC:Date - 1       ! NOTE: START COUNTING FROM THE PREVIOUS DAY
           END

           LOOP
               ! 09/10/2017 PK Naidoo: FB Case 1097
               IF LOC:ExcludeCourtHolidaysFlag = 1                                     ! AVOID COURT HOLIDAYS
                  IF LOC:DaysTime > 0
                     IF MONTH(LOC:CurrentDate) = 12 AND DAY(LOC:CurrentDate) >= 16
                        LOC:CurrentDate = DATE(1,16,YEAR(LOC:Date)+1)
                     ELSIF MONTH(LOC:CurrentDate) = 1 AND DAY(LOC:CurrentDate) <= 15
                        LOC:CurrentDate = DATE(1,16,YEAR(LOC:Date))
                     END
                  ELSE
                     IF MONTH(LOC:CurrentDate) = 1 AND DAY(LOC:CurrentDate) <= 15
                        LOC:CurrentDate = DATE(12,15,YEAR(LOC:Date)-1)
                     ELSIF MONTH(LOC:CurrentDate) = 12 AND DAY(LOC:CurrentDate) >= 16
                        LOC:CurrentDate = DATE(12,15,YEAR(LOC:Date))
                     END
                  END
               ! 09/10/2017 PK Naidoo: FB Case 1097
               ELSIF LOC:ExcludeCourtHolidaysFlag = 2                                     ! AVOID NEW COURT HOLIDAYS AS PER FOGBUGZ #1097

                  IF LOC:DaysTime > 0
                     IF MONTH(LOC:CurrentDate) = 12 AND DAY(LOC:CurrentDate) >= 21
                        LOC:CurrentDate = DATE(1,8,YEAR(LOC:Date)+1)
                     ELSIF MONTH(LOC:CurrentDate) = 1 AND DAY(LOC:CurrentDate) <= 7
                        LOC:CurrentDate = DATE(1,8,YEAR(LOC:Date))
                     END
                  ELSE
                     IF MONTH(LOC:CurrentDate) = 1 AND DAY(LOC:CurrentDate) <= 7
                        LOC:CurrentDate = DATE(12,20,YEAR(LOC:Date)-1)
                     ELSIF MONTH(LOC:CurrentDate) = 12 AND DAY(LOC:CurrentDate) >= 21
                        LOC:CurrentDate = DATE(12,20,YEAR(LOC:Date))
                     END
                  END

               END

               IF AllowWeekendsAndHolidays   !Inside Working Days
               ELSE
                  GHOLQ:Date = LOC:CurrentDate
                  GET(GHOLQ:HolidayQueue,GHOLQ:Date)

                  IF ~ERRORCODE() OR LOC:CurrentDate%7 = 0 OR LOC:CurrentDate%7 = 6 ! IT IS A HOLIDAY OR A SATURDAY OR SUNDAY

                  ELSE
                     ! FOUND A WORKING DAY
                     IF LOC:DaysTime > 0
                        LOC:DayCounter += 1
                     ELSE
                        LOC:DayCounter -= 1  ! GO BACKWARDS
                     END

                  END
               END

               IF LOC:DaysTime > 0
                  IF LOC:DayCounter >= LOC:DaysTime THEN BREAK.
               ELSE
                  IF LOC:DayCounter <= LOC:DaysTime THEN BREAK.
               END

               IF LOC:DaysTime > 0
                  LOC:CurrentDate += 1
               ELSE
                  LOC:CurrentDate -= 1
               END

           END

           LOC:Date = LOC:CurrentDate


        ELSE

           LOC:Date += LOC:DaysTime
           IF AllowWeekendsAndHolidays        !Not working days
           ELSE
              IF LOC:DaysTime > 0
                 LOC:Date = CheckHoliday(LOC:Date)
              ELSE
                 LOC:Date = CheckHoliday(LOC:Date,1)   ! REVERSE ORDER
              END
           END

        END


GetSpecificDay  ROUTINE


        IF LOC:SpecificDayMask ! THE DATE MUST FALL ON A SPECIFIC DAY
                           ! E.G. IF USER WANTS A DATE THAT MUST FALL ON A TUESDAY OR THURSDAY (0010100)


           ! ADDED THIS BECAUSE, APPARENTLY, IT MUST FIND THE next FIRDAY, FOR EXAMPLE, IF THIS FIRST DAY IS A FRIDAY
           ! SEE NOTES BELOW
           IF (LOC:Date%7 = 0 AND BAND(LOC:Sunday,LOC:SpecificDayMask)) OR |
              (LOC:Date%7 = 1 AND BAND(LOC:Monday,LOC:SpecificDayMask)) OR |
              (LOC:Date%7 = 2 AND BAND(LOC:Tuesday,LOC:SpecificDayMask)) OR |
              (LOC:Date%7 = 3 AND BAND(LOC:Wednesday,LOC:SpecificDayMask)) OR |
              (LOC:Date%7 = 4 AND BAND(LOC:Thursday,LOC:SpecificDayMask)) OR |
              (LOC:Date%7 = 5 AND BAND(LOC:Friday,LOC:SpecificDayMask)) OR |
              (LOC:Date%7 = 6 AND BAND(LOC:Saturday,LOC:SpecificDayMask))

              IF LOC:DaysTime > 0     
                 LOC:Date += 1
              ELSE
                 LOC:Date -= 1    
              END

           END

           LOOP
              IF (LOC:Date%7 = 0 AND BAND(LOC:Sunday,LOC:SpecificDayMask)) OR |
                 (LOC:Date%7 = 1 AND BAND(LOC:Monday,LOC:SpecificDayMask)) OR |
                 (LOC:Date%7 = 2 AND BAND(LOC:Tuesday,LOC:SpecificDayMask)) OR |
                 (LOC:Date%7 = 3 AND BAND(LOC:Wednesday,LOC:SpecificDayMask)) OR |
                 (LOC:Date%7 = 4 AND BAND(LOC:Thursday,LOC:SpecificDayMask)) OR |
                 (LOC:Date%7 = 5 AND BAND(LOC:Friday,LOC:SpecificDayMask)) OR |
                 (LOC:Date%7 = 6 AND BAND(LOC:Saturday,LOC:SpecificDayMask))

                IF AllowWeekendsAndHolidays   !Inside Specific day

                ELSE


                   GHOLQ:Date = LOC:Date
                   GET(GHOLQ:HolidayQueue,GHOLQ:Date)

                   IF ~ERRORCODE()                    ! NEVER WANT PUBLIC HOLIDAYS
                      IF LOC:DaysTime > 0            ! IF LOOKING FOR A FUTURE DATE THEN TRY THE NEXT DAY
                         LOC:Date += 1
                      ELSE
                         LOC:Date -= 1               ! IF LOOKING FOR A PASTDATE THEN TRY THE PREVIOUS DAY
                      END
                   ELSE
                      BREAK                      ! FOUND THE SPECIFIC DAY THE USER WANTS
                   END
                END

              ELSE
                 IF LOC:DaysTime > 0            ! IF LOOKING FOR A FUTURE DATE THEN TRY THE NEXT DAY
                    LOC:Date += 1
                 ELSE
                    LOC:Date -= 1    ! IF LOOKING FOR A PASTDATE THEN TRY THE PREVIOUS DAY
                 END
              END
           END
        END


GetNextSpecificDate     ROUTINE

           LOOP
              IF (LOC:Date%7 = 0 AND BAND(LOC:Sunday,LOC:SpecificDayMask)) OR |
                 (LOC:Date%7 = 1 AND BAND(LOC:Monday,LOC:SpecificDayMask)) OR |
                 (LOC:Date%7 = 2 AND BAND(LOC:Tuesday,LOC:SpecificDayMask)) OR |
                 (LOC:Date%7 = 3 AND BAND(LOC:Wednesday,LOC:SpecificDayMask)) OR |
                 (LOC:Date%7 = 4 AND BAND(LOC:Thursday,LOC:SpecificDayMask)) OR |
                 (LOC:Date%7 = 5 AND BAND(LOC:Friday,LOC:SpecificDayMask)) OR |
                 (LOC:Date%7 = 6 AND BAND(LOC:Saturday,LOC:SpecificDayMask))

                 IF AllowWeekendsAndHolidays !Next Specific Date
                 ELSE

                   GHOLQ:Date = LOC:Date
                   GET(GHOLQ:HolidayQueue,GHOLQ:Date)

                   IF ~ERRORCODE()                    ! NEVER WANT PUBLIC HOLIDAYS
                        LOC:Date += 1
                     ELSE
                        BREAK                      ! FOUND THE SPECIFIC DAY THE USER WANTS
                     END
                 END

              ELSE
                 LOC:Date += 1
              END
           END
