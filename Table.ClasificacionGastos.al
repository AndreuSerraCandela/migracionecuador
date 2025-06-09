table 76003 "Clasificacion Gastos"
{
    Caption = 'Expenses Clasification';
    DataPerCompany = false;
    DrillDownPageID = "Clasificacion Gastos";
    LookupPageID = "Clasificacion Gastos";

    fields
    {
        field(1; Codigo; Code[2])
        {
            NotBlank = true;
        }
        field(2; Descripcion; Text[50])
        {
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
        fieldgroup(DropDown; Codigo, Descripcion)
        {
        }
    }
}

