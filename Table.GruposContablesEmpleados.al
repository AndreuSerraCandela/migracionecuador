table 76031 "Grupos Contables Empleados"
{
    DataCaptionFields = "Código";
    DrillDownPageID = "Gpo. Contable Empleados";
    LookupPageID = "Gpo. Contable Empleados";

    fields
    {
        field(1; "Código"; Code[10])
        {
        }
        field(2; "Descripción"; Text[50])
        {
        }
        field(3; "Excluir contabilizacion"; Boolean)
        {
            Caption = 'Exclude from G/L Post';
        }
    }

    keys
    {
        key(Key1; "Código")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Código", "Descripción")
        {
        }
    }
}

