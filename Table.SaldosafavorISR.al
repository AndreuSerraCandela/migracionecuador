table 76254 "Saldos a favor ISR"
{

    fields
    {
        field(1; "Cód. Empleado"; Code[15])
        {
            TableRelation = Employee;
        }
        field(2; Ano; Integer)
        {
        }
        field(3; "Saldo a favor"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Importe Pendiente" = 0 then
                    "Importe Pendiente" := "Saldo a favor";
            end;
        }
        field(4; "Importe Pendiente"; Decimal)
        {
        }
        field(5; "Full Name"; Text[50])
        {
            CalcFormula = Lookup (Employee."Full Name" WHERE ("No." = FIELD ("Cód. Empleado")));
            Caption = 'Full Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Cód. Empleado", Ano)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        BKISR.TransferFields(Rec);
        if not BKISR.Insert then
            BKISR.Modify;
    end;

    var
        BKISR: Record "Prestaciones masivas";
}

