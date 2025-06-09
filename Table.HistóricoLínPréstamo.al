table 76412 "Histórico Lín. Préstamo"
{
    DrillDownPageID = "Subform Hist. Préstamo";
    LookupPageID = "Subform Hist. Préstamo";

    fields
    {
        field(1; "No. Préstamo"; Code[20])
        {
        }
        field(2; "No. Línea"; Integer)
        {
        }
        field(3; "Tipo CxC"; Option)
        {
            Description = ',Préstamo,Factura';
            OptionMembers = " ","Préstamo",Factura;
        }
        field(4; "No. Cuota"; Integer)
        {
        }
        field(5; "Fecha Transacción"; Date)
        {
        }
        field(6; "Código Empleado"; Code[20])
        {
            TableRelation = Employee;
        }
        field(7; Importe; Decimal)
        {

            trigger OnValidate()
            begin
                if Importe > 0 then begin
                    Débito := Importe;
                    Clear(Crédito);
                end
                else begin
                    Crédito := Importe * -1;
                    Clear(Débito);
                end;
            end;
        }
        field(8; "Débito"; Decimal)
        {

            trigger OnValidate()
            begin
                Importe := Débito;
            end;
        }
        field(9; "Crédito"; Decimal)
        {

            trigger OnValidate()
            begin
                Importe := -Crédito;
            end;
        }
        field(10; Correccion; Boolean)
        {
            Caption = 'Correction';
        }
    }

    keys
    {
        key(Key1; "No. Préstamo", "No. Línea")
        {
            Clustered = true;
            SumIndexFields = Importe, "Débito", "Crédito";
        }
    }

    fieldgroups
    {
    }

    var
        HistLinPre: Record "Histórico Lín. Préstamo";
}

