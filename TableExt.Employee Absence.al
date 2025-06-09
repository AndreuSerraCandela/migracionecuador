tableextension 50099 tableextension50099 extends "Employee Absence"
{
    fields
    {
        modify("Cause of Absence Code")
        {
            Caption = 'Cause of Absence Code';
            trigger OnAfterValidate()
            begin
                ValidarTiempo();
            end;
        }
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }

        modify("From Date")
        {
            trigger OnBeforeValidate()
            begin
                ValidarTiempo();
            end;
        }

        modify("To Date")
        {
            trigger OnBeforeValidate()
            begin
                ValidarTiempo();
            end;
        }

        field(76200; Closed; Boolean)
        {
            Caption = 'Closed';
            DataClassification = ToBeClassified;
        }
        field(76060; "% To deduct"; Decimal)
        {
            Caption = '% To deduct';
            DataClassification = ToBeClassified;
        }
        field(76000; "Full name"; Text[60])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Employee No.")));
            Caption = 'Full name';
            FieldClass = FlowField;
        }
        field(76049; Calculado; Boolean)
        {
            Caption = 'Calculated';
            DataClassification = ToBeClassified;
        }
    }

    local procedure ValidarTiempo()
    var
        DiasFestivos: Record "Dias Festivos";
        Fecha: Record Date;
        CauseOfAbsence: Record "Cause of Absence";
    begin
        if not CauseOfAbsence.Get("Cause of Absence Code") then
            exit;

        if ("From Date" > "To Date") and ("From Date" <> 0D) and ("To Date" <> 0D) then
            Error(StrSubstNo(Err001, FieldCaption("From Date"), FieldCaption("To Date")))
        else
            if ("From Date" = 0D) or ("To Date" = 0D) then
                exit;

        if CauseOfAbsence."Dias laborables" then begin
            Quantity := 0;
            Fecha.Reset;
            Fecha.SetRange("Period Type", 0); //Dia
            Fecha.SetRange("Period Start", "From Date", CalcDate('-1D', "To Date"));
            if Fecha.FindSet then
                repeat
                    case Fecha."Period No." of
                        1 .. 5:
                            begin
                                DiasFestivos.Reset;
                                DiasFestivos.SetRange(Fecha, Fecha."Period Start");
                                if not DiasFestivos.FindFirst then
                                    Quantity += 1;
                            end;
                    end;
                until Fecha.Next = 0;
        end
        else begin
            Quantity := 0;
            Fecha.Reset;
            Fecha.SetRange("Period Type", 0); //Dia
            Fecha.SetRange("Period Start", "From Date", CalcDate('-1D', "To Date"));
            if Fecha.FindSet then
                repeat
                    Quantity += 1;
                until Fecha.Next = 0;
        end;
    end;

    var
        Err001: Label '%1 can not be greather than %2';
}

