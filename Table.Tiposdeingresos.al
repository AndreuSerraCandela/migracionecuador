table 76090 "Tipos de ingresos"
{
    // Proyecto: Microsoft Dynamics Nav
    // ---------------------------------
    // AMS     : Agustín Méndez
    // GRN     : Guillermo Román
    // ------------------------------------------------------------------------
    // No.         Firma       Fecha            Descripcion
    // ------------------------------------------------------------------------
    // DSLoc1.03   GRN         01/05/2018       Funcionalidad localizado RD

    Caption = 'Income Type';
    DataPerCompany = false;
    DrillDownPageID = "Tipos de ingresos";
    LookupPageID = "Tipos de ingresos";

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

