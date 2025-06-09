table 76392 "Hist. Lin. Prest. cooperativa"
{
    DrillDownPageID = "Subform Hist. Préstamo";
    LookupPageID = "Subform Hist. Préstamo";

    fields
    {
        field(1; "No. Prestamo"; Code[20])
        {
            Caption = 'Loan no.';
        }
        field(2; "No. Cuota"; Integer)
        {
            Caption = 'Quote no.';
        }
        field(3; "Tipo prestamo"; Code[20])
        {
            Caption = 'Loan type';
            DataClassification = ToBeClassified;
            TableRelation = "Datos adicionales RRHH".Code WHERE ("Tipo registro" = CONST ("Tipo de préstamo"));
        }
        field(5; "Fecha Transaccion"; Date)
        {
            Caption = 'Transaction date';
        }
        field(6; "Código Empleado"; Code[20])
        {
            TableRelation = Employee;
        }
        field(7; "Saldo inicial"; Decimal)
        {
            Caption = 'Initial balance';

            trigger OnValidate()
            begin
                if "Saldo inicial" > 0 then begin
                    Interes := "Saldo inicial";
                    Clear("Importe cuota");
                end
                else begin
                    "Importe cuota" := "Saldo inicial" * -1;
                    Clear(Interes);
                end;
            end;
        }
        field(8; Interes; Decimal)
        {
            Caption = 'Interest';

            trigger OnValidate()
            begin
                "Saldo inicial" := Interes;
            end;
        }
        field(9; "Importe cuota"; Decimal)
        {
            Caption = 'Fee amount';

            trigger OnValidate()
            begin
                "Saldo inicial" := -"Importe cuota";
            end;
        }
        field(10; Amortizacion; Decimal)
        {
            Caption = 'Amortization';
        }
        field(11; "Saldo final"; Decimal)
        {
            Caption = 'Final balance';
            DataClassification = ToBeClassified;
        }
        field(12; "Importe mora"; Decimal)
        {
            Caption = 'Charge amount';
            DataClassification = ToBeClassified;
        }
        field(13; "Fecha mora"; Date)
        {
            Caption = 'Charge date';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No. Prestamo", "No. Cuota")
        {
            Clustered = true;
            SumIndexFields = "Saldo inicial", Interes, "Importe cuota";
        }
    }

    fieldgroups
    {
    }

    var
        HistLinPre: Record "Histórico Lín. Préstamo";
}

