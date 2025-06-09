table 76001 "Parametros Calculo Dias"
{
    Caption = 'Days Calculation Parameter';
    DataPerCompany = false;
    DrillDownPageID = "Parametros Calculo Dias";
    LookupPageID = "Parametros Calculo Dias";

    fields
    {
        field(1; Codigo; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Descripcion; Text[30])
        {
            Caption = 'Description';
        }
        field(3; Valor; Decimal)
        {
            Caption = 'Value';
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Codigo, Descripcion, Valor)
        {
        }
    }
}

