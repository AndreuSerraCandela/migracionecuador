table 76283 "Planificacion de vacaciones"
{
    Caption = 'Vacation planning';

    fields
    {
        field(1; "No. empleado"; Code[20])
        {
            Caption = 'Employee no.';
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if "No. empleado" <> '' then begin
                    Empl.Get("No. empleado");
                    "Fecha inicio planificada" := DMY2Date(Date2DMY(Empl."Employment Date", 1), Date2DMY(Empl."Employment Date", 2), Date2DMY(Today, 3));
                    Empl.CalcFields("Dias Vacaciones");
                    "Dias acumulados actual" := Empl."Dias Vacaciones";
                    Fecha.Reset;
                    Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                    Fecha.SetRange("Period Start", DMY2Date(1, Date2DMY(Empl."Employment Date", 2), Date2DMY(Today, 3)));
                    Fecha.FindFirst;

                    /*  "Dias acumulados estimados" := FuncNom.CalculoDiaVacaciones("No. empleado", Date2DMY(Empl."Employment Date", 2), Date2DMY(Today, 3), Monto, Empl."Employment Date", Fecha."Period End");
                     "Fecha fin planificada" := DMY2Date(Date2DMY(Empl."Employment Date", 1), Date2DMY(Empl."Employment Date", 2), Date2DMY(Today, 3));
                     "Employment Date" := Empl."Employment Date"; */
                end;
            end;
        }
        field(2; "Fecha inicio planificada"; Date)
        {
            Caption = 'Fecha inicio planificada';
            DataClassification = ToBeClassified;
        }
        field(3; "Fecha fin planificada"; Date)
        {
            Caption = 'Planned end date';
            DataClassification = ToBeClassified;
        }
        field(4; "Dias acumulados actual"; Decimal)
        {
            CalcFormula = Sum("Historico Vacaciones".Dias WHERE("No. empleado" = FIELD("No. empleado")));
            Caption = 'Current accumulated days';
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                ValidarTiempo
            end;
        }
        field(5; "Dias acumulados estimados"; Decimal)
        {
            Caption = 'Estimated accumulated days';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ValidarTiempo
            end;
        }
        field(6; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionCaption = ', Requested, Approved';
            OptionMembers = " ",Solicitada,Aprobada;
        }
        field(7; "Employment Date"; Date)
        {
            Caption = 'Employment Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Full name"; Text[60])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("No. empleado")));
            Caption = 'Full name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No. empleado", "Fecha inicio planificada")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Empl: Record Employee;
        Fecha: Record Date;

        Monto: Decimal;
        Err001: Label '%1 can not be greather than %2';

    local procedure ValidarTiempo()
    var
        DiasFestivos: Record "Dias Festivos";
        Fecha: Record Date;
    begin
        if ("Fecha inicio planificada" > "Fecha fin planificada") and ("Fecha inicio planificada" <> 0D) and ("Fecha fin planificada" <> 0D) then
            Error(StrSubstNo(Err001, FieldCaption("Fecha fin planificada"), FieldCaption("Fecha fin planificada")))
        else
            if ("Fecha inicio planificada" = 0D) or ("Fecha fin planificada" = 0D) then
                exit;
        "Dias acumulados estimados" := 0;
        Fecha.Reset;
        Fecha.SetRange("Period Type", 0); //Dia
        Fecha.SetRange("Period Start", "Fecha inicio planificada", CalcDate('-1D', "Fecha fin planificada"));
        if Fecha.FindSet then
            repeat
                case Fecha."Period No." of
                    1 .. 5:
                        begin
                            DiasFestivos.Reset;
                            DiasFestivos.SetRange(Fecha, Fecha."Period Start");
                            if not DiasFestivos.FindFirst then
                                "Dias acumulados estimados" += 1;
                        end;
                end;
            until Fecha.Next = 0;
    end;
}

