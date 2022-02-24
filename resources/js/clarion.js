
//GPV('Defendant.1.parlang.firstname')
GetPartyVariable = GPV = function( value ) {

    return ('GetPartyVariable To Do: ' + replaceClarionEvaluates(value));
}

//GWD(GetStageDate('0000'),MAT:DateInstructed)
GetWorkingDays = GWD = function( value ) {

    return ('GetWorkingDays To Do: ' + replaceClarionEvaluates(value));

} 

GetStageDate = GSD = function( value ) {

    return ('GetStageDate To Do: ' + replaceClarionEvaluates(value));

} 
//(GDF('File References',8))
GetDocumentField = GDF = function( value ) {

    return ('GetDocumentField To Do: ' + replaceClarionEvaluates(value));

} 

function FindDate(TheDate, DaysTime, WorkingDaysFlag = 0, SpecificDayMask = null, ExcludeCourtHolidaysFlag = false, ExcludeCourtRecessFlag = false, AllowWeekendsAndHolidays = false ) {

    // For testing in console.log
    //let initialDate = moment.unix((root.global.todaysdate - 61730) * 86400)

    if (!TheDate) TheDate = root.global.todaysdate;

    if (DaysTime > 1000) return TheDate;

    let initialDate = convertFromClarionDate(TheDate, false);

    if (DaysTime == 0) {
        
        //THE USER WANTS TO FIND THE NEXT THURSDAY, FOR EXAMPLE.
        if (SpecificDayMask) {

            let returnDate = GetNextSpecificDate( initialDate, SpecificDayMask);

            return convertToClarionDate(returnDate);

        } else {

            return convertToClarionDate(initialDate);
        }
    }

    let returnDate = initialDate;

    let DayCounter = 0;
    let order = 'forward';

    if (DaysTime < 0) order = 'backwards';

    if (WorkingDaysFlag) {

        while (order == 'forward' ? DayCounter < DaysTime : DayCounter > DaysTime) {

            if (order == 'forward') {
                returnDate.add(1,'days');
            } else {
                returnDate.subtract(1,'days');
            }


            if (ExcludeCourtHolidaysFlag == 1) {
                
                if (order == 'forward') {
                    
                    if (returnDate.month() == 12 && returnDate.day() >= 16) {
                        returnDate = moment([returnDate.year() + 1, 1, 16]);
                    } else if (returnDate.month() == 1 && returnDate.day() <= 15) {
                        returnDate = moment([returnDate.year(), 1, 16]);
                    }
                    
                } else {
                    
                    if (returnDate.month() == 1 && returnDate.day() <= 15) {
                        returnDate = moment([returnDate.year() - 1, 12, 15]);
                    } else if (returnDate.month() == 12 && returnDate.day() >= 16) {
                        returnDate = moment([returnDate.year(), 12, 15]);
                    }
                }
                
            } else if (ExcludeCourtHolidaysFlag == 2) {
                
                if (order == 'forward') {
                    
                    if (returnDate.month() == 12 && returnDate.day() >= 21) {
                        returnDate = moment([returnDate.year() + 1, 1, 8]);
                    } else if (returnDate.month() == 1 && returnDate.day() <= 7) {
                        returnDate = moment([returnDate.year(), 1, 8]);
                    }
                    
                } else {

                    if (returnDate.month() == 1 && returnDate.day() <= 7) {
                        returnDate = moment([returnDate.year() - 1, 12, 20]);
                    } else if (returnDate.month() == 12 && returnDate.day() >= 21) {
                        returnDate = moment([returnDate.year(), 12, 20]);
                    }
                }
                
            }
            
            if (!AllowWeekendsAndHolidays) {

                if ( isWorkingDay(returnDate) ) {
                    
                    if (order == 'forward') {
                        DayCounter += 1;
                    } else {
                        DayCounter -= 1;
                    }

                }

            } else {

                if (order == 'forward') {
                    DayCounter += 1;
                } else {
                    DayCounter -= 1;
                }

            }

        }

    } else {

        console.log("3 WorkingDaysFlag",WorkingDaysFlag);

        if (order == 'forward') {
            returnDate.add(DaysTime,'days');
        } else {
            returnDate.subtract(DaysTime,'days');
        }
        
        if (!AllowWeekendsAndHolidays) {

            while (!isWorkingDay(returnDate)) {

                if (order == 'forward') {
                    returnDate.add(1,'days');
                } else {
                    returnDate.subtract(1,'days');
                }

            }
        }

    }
    
    if (SpecificDayMask) {
        
        returnDate = GetNextSpecificDate( returnDate, SpecificDayMask, order);
        
        return convertToClarionDate(returnDate);
        
    } else {
        
        return convertToClarionDate(returnDate);
    }

    
}

function GetNextSpecificDate( date, specificDayMask, order = 'forward') {

    let foundDate = false;

    while (!foundDate) {

        if  ( date.day() == specificDayMask) {

            // Do not return the day if it is a holiday
            if ( isHoliday( date ) ) {

                if ( order == 'forward') {
                    date.add(6,'days'); // Try next week
                } else {
                    date.subtract(6,'days'); // Try previous week
                }

            } else { 

                foundDate = true;
            }

        } else { 

            if ( order == 'forward') {
                date.add(1,'days');
            } else {
                date.subtract(1,'days');
            }
        }
    }

    return date;

}

function isHoliday(date) {

    return root.holidays.filter(holiday => holiday.date == convertToClarionDate(date)).length;

}

function isWorkingDay(date) {

    let returnValue = true;

    let holidayFlag = root.holidays.filter(holiday => holiday.date == convertToClarionDate(date)).length;

    let weekendFlag = (date.day() == 6 || date.day() == 0);

    if ( holidayFlag || weekendFlag) returnValue = false;

    return returnValue;

}

function CHOOSE(condition, returnTrue, returnFalse ) {

    try {

        let result = eval(condition);

        return result ? returnTrue : returnFalse;

    } catch( error ) {
        return error;
    }

}

function convertToClarionDate( date, format = 'DD MMM YYYY') {
    
    //For consistent results parsing anything other than ISO 8601 strings, you should use String + Format.
    //https://stackoverflow.com/questions/39969570/deprecation-warning-in-moment-js-not-in-a-recognized-iso-format

    return Math.ceil((moment(date, format).unix()/86400)) + 61730;
    
}

function nowToClarionTime() {
    //https://www.nettalkcentral.com/forum/index.php?topic=8225.0
    let time = Date.now()/10;
    let d = new Date();
    time -= d.getTimezoneOffset()*6000
    return (parseInt(1+(time % 8640000)))
}

function convertFromClarionDate( date, formatFlag = true,  format = '') {

    let unixDate = (date - 61730) * 86400; //24 * 60 * 60

    if ( date > 0 ) {
        return formatFlag ? moment.unix(unixDate).format(format ? format : root.control.dateformat) : moment.unix(unixDate);
    } else {
        return '';
    }
}

function convertFromClarionTime( time ) {

    //A Clarion standard time is the number of hundredths of a second that have elapsed since midnight, plus one (1)
    // Test in console.log
    // let time = 1317700;
    // moment([2010, 1, 1, 0, 0, 0, 0]).add(time/100,'seconds').format('hh:mm:ss');

    if ( time > 100 ) {
        return moment([2020, 1, 1, 0, 0, 0, 0]).add(time/100,'seconds').format('hh:mm:ss');
    } else {
        return '';
    }

}

function getFicaExpiryDate(documentDate, monthsToExpiry, format = true ) {

    let ficaDate = parseInt(documentDate) - 1;  //! EXPIRES THE DAY BEFORE

    // Convert Clarion date to Unix timestamp
    let unixDate = (ficaDate - 61730) * 86400; //24 * 60 * 60

    if ( format ) {
        return moment.unix(unixDate).add(monthsToExpiry, 'months').format(root.control.dateformat);
    } else {
        return moment.unix(unixDate).add(monthsToExpiry, 'months');
    }

}


function stripCharacters( sentString ) {


    /*StripFileRefCharacters PROCEDURE  (TheSentString)     ! Declare Procedure
    LOC:SentString       CSTRING(1000)
    LOC:ReturnString     CSTRING(20)
    LOC:ValidCharacters  STRING(41)
    
      CODE
     LOC:SentString = TheSentString
     LOOP X# = 1 TO LEN(LOC:SentString)
          IF INSTRING(UPPER(CLIP(LOC:SentString[X#])),'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890@&:-',1)
             LOC:ReturnString = LOC:ReturnString & LOC:SentString[X#]
          END
     END
     
     RETURN(LOC:ReturnString)*/
     
    //https://stackoverflow.com/questions/4374822/remove-all-special-characters-with-regexp
    return sentString.replace(/[^\w\s]/gi, '');

}

function replaceClarionPrefixes(evaluateString) {

    evaluateString = replaceClarionMatterPrefixes(evaluateString);
    evaluateString = replaceClarionPartyPrefixes(evaluateString);
    return evaluateString;
}

function replaceClarionMatterPrefixes(evaluateString) {


    evaluateString = evaluateString.replace(/mat\:/gi, "matter.");
    evaluateString = evaluateString.replace(/dg\:/gi, "docgen.");
    evaluateString = evaluateString.replace(/mt\:/gi, "mattype.");
    evaluateString = evaluateString.replace(/bon\:/gi, "bonddata.");
    evaluateString = evaluateString.replace(/conv\:/gi, "conveydata.");
    evaluateString = evaluateString.replace(/col\:/gi, "coldata.");

    return evaluateString;

}

function replaceClarionPartyPrefixes(evaluateString) {

    evaluateString = evaluateString.replace(/par\:/gi, "party.");
    evaluateString = evaluateString.replace(/pl\:/gi, "parlang.");
    evaluateString = evaluateString.replace(/mp\:/gi, "matparty.");

    return evaluateString;

}

function replaceClarionEvaluates(evaluateString) {

    evaluateString = evaluateString.replace(/&/g, "+");
    evaluateString = evaluateString.replace(/=/g, "==");
    evaluateString = evaluateString.replace(/<>/g, "!=");
    evaluateString = evaluateString.replace(/\bor\b/gi, "||");
    evaluateString = evaluateString.replace(/\band\b/gi, "&&");

    // Replace global prefixes
    evaluateString = evaluateString.replace(/ctl\:/gi, "root.control.");
    evaluateString = evaluateString.replace(/glo\:/gi, "root.global.");
    evaluateString = evaluateString.replace(/cem\:/gi, "root.currentEmployee.");

    // Change global names to lowercase
    evaluateString = evaluateString.replace(/root.control\.[a-zA-Z0-9]\w+/g, function(v) { return v.toLowerCase(); });
    evaluateString = evaluateString.replace(/root.global\.[a-zA-Z0-9]\w+/g, function(v) { return v.toLowerCase(); });
    evaluateString = evaluateString.replace(/root.currentEmployee\.[a-zA-Z0-9]\w+/g, function(v) { return v.toLowerCase(); });
        

    // Replace [[IF()]] . . . [[ENDIF]]
    evaluateString = evaluateString.replace(/\]\](.*?)\[\[/g, " { '$1' }");
    evaluateString = evaluateString.replace(/ELSE/g, " else ");
    evaluateString = evaluateString.replace(/ELSIF/g, " else if ");
    evaluateString = evaluateString.replace(/\[\[IF\(/g, "if (");
    evaluateString = evaluateString.replace(/ENDIF\]\]/g, "");

    return evaluateString;
}

/*
Examples (taken form FieldCalculation in DocScrnField)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CHOOSE(MAT:DocumentLanguageID = 1,'Clerk of the Court','HofKlerk')
[[IF(MDS:Field1<1000)]]0[[ELSIF(MDS:Field1>= 1000 AND MDS:Field1<20000)]]5000[[ELSIF(MDS:Field1>= 20000 AND MDS:Field1<50000)]]7500[[ELSIF(MDS:Field1>= 50000 AND MDS:Field1<75000)]]10000[[ELSIF(MDS:Field1>= 7500 AND MDS:Field1<100000)]]12500[[ELSIF(MDS:Fie
(MAT:PrescriptionDate - GLO:TodaysDate)
MAT:Actual-(MAT:Actual*MDS:Field4/100)
(COL:EMOSubTotal) - (COL:EMOInterest) - (COL:JudgmentDebt+COL:JudgmentCosts)
CHOOSE(MDS:Field2='0.5%',(MDS:Field1/0.9943),CHOOSE(MDS:Field2='2.5%',(MDS:Field1/0.9715),CHOOSE(MDS:Field2='5.0%',(MDS:Field1/0.943))))

FindDate(GLO:TodaysDate,1,0,0,0,0,1)
FindDate(GetStageDate('SUM1'),10,1,0)
FindDate(MAT:DateInstructed,30,1,0)
FindDate(GLO:TodaysDate,1,1,0)
FindDate(GLO:TodaysDate,3,0,0)
FindDate(GLO:TodaysDate,3,1,0)
FindDate(GLO:TodaysDate,100,0,0)

FindDates(DATE(8,10,2011),5,1,26)
FindDate(GDF('Michele',5),60,1,0)
FindDateByMonth(MDS:Field1,1,1)



GetWorkingDays(MAT:DateInstructed,(GetStageDate('0000')))
GetWorkingDays(MAT:DateInstructed, GLO:TodaysDate)
GWD(GetStageDate('0000'),MAT:DateInstructed)


GetStageDate('SUM2')
GetStageDate('TES1')+13
GetLastStageCode()
GetLastStageDate()
GetLastStageDescription()

GPV('Applicant (Admin),1,PAR:MaritalStatus') <> 'UNM'
(GDF('Test123',1)-GDF('Test123',2))
(GDF('Insurance',3)) * 10/100
GPRPF(380,180,1,1)

CHOOSE((GetLastStageCode('0000')),A,CHOOSE(GetLastStageCode('0010')),B,CHOOSE(GetLastStageCode('0012')),C,CHOOSE((GetLastStageCode('0016')),D)


*/