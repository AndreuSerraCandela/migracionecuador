table 76044 "Distrib. Ingreso Pagos Elect."
{

    fields
    {
        field(1; "No. empleado"; Code[15])
        {
            TableRelation = Employee;
        }
        field(2; "Cod. Banco"; Code[10])
        {
            TableRelation = "Bancos ACH Nomina";
        }
        field(3; "Tipo Cuenta"; Option)
        {
            Description = 'Saving,Credit,Check';
            OptionCaption = 'Saving,Credit,Check';
            OptionMembers = Saving,Credit,Check;
        }
        field(4; "Numero Cuenta"; Code[22])
        {
        }
        field(5; "Nro. tarjeta"; Code[20])
        {
            Caption = 'Card number';
        }
        field(6; Importe; Decimal)
        {
        }
        field(7; "Tipo Importe"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Percent,Fix';
            OptionMembers = " ",Porciento,Fijo;
        }
        field(8; "Fecha vencimiento"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No. empleado", "Cod. Banco")
        {
            Clustered = true;
        }
        key(Key2; "No. empleado", Importe)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Emp.Get("No. empleado");
        if Emp."Forma de Cobro" <> 3 then begin
            Emp."Forma de Cobro" := 3;
            Emp.Modify;
        end;
    end;

    var
        Emp: Record Employee;
        ok: Boolean;
        "año": Integer;
        edad: Integer;
}

