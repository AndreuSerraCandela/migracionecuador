page 76258 "Informacion del empleado"
{
    ApplicationArea = all;
    Caption = 'Información del empleado';
    PageType = CardPart;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            field(Picture; rec.Image)
            {
                Caption = 'Picture';
                ShowCaption = false;
            }
           /*  field(Novedades; rec.StrSubstNo('(%1)', CUNomina.BuscaNovedades(Rec)))
            {
                Caption = 'Customer No.';
            }
            field(Cualificaciones; rec.StrSubstNo('(%1)', CUNomina.BuscaCualificaciones("No.")))
            {
                Caption = 'Quotes';
                DrillDownPageID = "Sales Quotes";
            }
            field(Dimensiones; rec.StrSubstNo('(%1)', CUNomina.BuscaDimensiones("No.")))
            {
                Caption = 'Blanket Orders';
                DrillDownPageID = "Blanket Sales Orders";
            } */
        }
    }

    actions
    {
    }

    var
       /*  CUNomina: Codeunit "Funciones Nomina"; */
}

