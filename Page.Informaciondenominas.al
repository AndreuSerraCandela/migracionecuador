page 76259 "Informacion de nominas"
{
    ApplicationArea = all;
    Caption = 'Información del empleado';
    PageType = CardPart;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            /*             field(Novedades; rec.StrSubstNo('(%1)', CUNomina.BuscaNominas(Rec)))
                        {
                            Caption = 'Customer No.';
                        } */
        }
    }

    actions
    {
    }

    var
    /*   CUNomina: Codeunit "Funciones Nomina"; */
}

