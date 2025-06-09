page 76006 "Tipos de ingresos"
{
    ApplicationArea = all;
    // Proyecto: Microsoft Dynamics Nav
    // ---------------------------------
    // AMS     : Agustín Méndez
    // GRN     : Guillermo Román
    // ------------------------------------------------------------------------
    // No.         Firma       Fecha            Descripcion
    // ------------------------------------------------------------------------
    // DSLoc1.03   GRN         01/05/2018       Funcionalidad localizado RD

    Caption = 'Income Type';
    PageType = List;
    SourceTable = "Tipos de ingresos";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
            }
        }
    }

    actions
    {
    }
}

