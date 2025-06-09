table 56100 "Provisiones nominas11"
{
    Caption = 'Provisiones nominas';

    fields
    {
        field(1; "Cod. Empleado"; Code[20])
        {
            Caption = 'Code';
            TableRelation = Employee;
        }
        field(2; Periodo; Date)
        {
        }
        field(3; "Concepto Salarial"; Code[20])
        {
            TableRelation = "Conceptos salariales";
        }
        field(4; "Importe provisionado"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Empleado", Periodo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cod. Empleado", Periodo)
        {
        }
    }
}

