table 76002 "Historico Vacaciones"
{
    Caption = 'Vacation''s History';
    DrillDownPageID = "Historico de Vacaciones";
    LookupPageID = "Historico de Vacaciones";

    fields
    {
        field(1; "No. empleado"; Code[20])
        {
            Caption = 'Employee no.';
            TableRelation = Employee;
        }
        field(2; "Fecha Inicio"; Date)
        {
            Caption = 'Starting date';
        }
        field(3; "Fecha Fin"; Date)
        {
            Caption = 'Ending date';

            trigger OnValidate()
            var

                AnoCalculado: Integer;
                MesCalculado: Integer;
                DiaCalculado: Integer;
            begin
                /*
                FuncNomina.CálculoEntreFechas("Fecha Inicio","Fecha Fin",AnoCalculado,MesCalculado,DiaCalculado);
                
                Dias := DiaCalculado * Tipo;
                */

            end;
        }
        field(4; Dias; Decimal)
        {
            Caption = 'Days';
        }
        field(5; "Tipo calculo"; Option)
        {
            Caption = 'Calculation type';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'By law,Additional';
            OptionMembers = "De ley",Adicional;
        }
    }

    keys
    {
        key(Key1; "No. empleado", "Fecha Inicio", "Tipo calculo")
        {
            Clustered = true;
            SumIndexFields = Dias;
        }
    }

    fieldgroups
    {
    }

    var

}

