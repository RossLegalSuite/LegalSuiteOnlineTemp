GetCollCommAmount    PROCEDURE  (LOC:MatterID,LOC:Amount,LOC:VatRate,<LOC:Date>) ! Declare Procedure

    LOC:ReturnValue           DECIMAL(13,5)
    LOC:VatAmount             DECIMAL(13,5)
    LOC:CommissionPercent     DECIMAL(13,2)
    LOC:CommissionLimit       DECIMAL(13,2)
    LOC:DebtorCollCommOption  STRING(1)
    CODE
    IF ~LOC:Amount THEN RETURN LOC:ReturnValue.
    IF ~LOC:MatterID THEN RETURN LOC:ReturnValue.

    IF OMITTED(4) THEN LOC:Date = GLO:TodaysDate.

    PROPSQLNext('SELECT 0,DebtorCollCommOption, DebtorCollCommPercent, DebtorCollCommLimit FROM Matter WHERE RecordID = ' & LOC:MatterID,'GetCollCommAmount')

    LOC:DebtorCollCommOption = ROW:Description

    CASE LOC:DebtorCollCommOption
        OF 'N' ! NONE
            RETURN LOC:ReturnValue
        OF 'U' ! DEFAULT
            LOC:CommissionPercent = CTL:CollCommPercent
            LOC:CommissionLimit = CTL:CollCommLimit
        OF 'S' ! SCHEDULE
            LOC:CommissionPercent = GetCollCommPercent(LOC:Date)
            LOC:CommissionLimit = GetCollCommLimit(LOC:Date)
        ELSE   ! CUSTOM
            LOC:CommissionPercent = ROW:Amount1
            LOC:CommissionLimit = ROW:Amount2
    END

    !RICK FB# 1521 -ROUNDING ISSUE WHEN SUBTRACTING THE VAT AND THEN ADDING IT AGAIN IN SETCOLDEBITTOTALS

    !LOC:ReturnValue = Round(LOC:CommissionPercent * LOC:Amount / 100,.01)
    LOC:ReturnValue = LOC:CommissionPercent * LOC:Amount / 100

    IF ABS(LOC:ReturnValue) > ABS(LOC:CommissionLimit) AND LOC:CommissionLimit THEN LOC:ReturnValue = LOC:CommissionLimit.

    IF LOC:DebtorCollCommOption = 'I'


    !RICK FB# 1521 -ROUNDING ISSUE WHEN SUBTRACTING THE VAT AND THEN ADDING IT AGAIN IN SETCOLDEBITTOTALS
    !LOC:ReturnValue = GetVatExcl(LOC:ReturnValue,LOC:VatRate)

    LOC:VatAmount = LOC:ReturnValue * (LOC:VatRate / (100 + LOC:VatRate))

    LOC:ReturnValue -= LOC:VatAmount


    END


    ! message('2 GetCollCommAmount' &|
    !         '|LOC:VatAmount = ' & LOC:VatAmount &|
    !         '|LOC:ReturnValue = ' & LOC:ReturnValue)


    RETURN LOC:ReturnValue
