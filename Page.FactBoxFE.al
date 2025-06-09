page 55019 "FactBox FE"
{
    ApplicationArea = all;
    Caption = 'Comprobantes electrónicos';
    PageType = CardPart;
    SourceTable = "Documento FE";
    SourceTableView = SORTING ("No. documento");

    layout
    {
        area(content)
        {
            field(Ambiente; rec.Ambiente)
            {
            }
            field("Tipo emision"; rec."Tipo emision")
            {
            }
            field("Estado envio"; rec."Estado envio")
            {
                Caption = 'Envío';
                StyleExpr = TRUE;
                ToolTip = 'Foto del Empleado. 2.9 x 2.9 cm';
            }
            field("Estado autorizacion"; rec."Estado autorizacion")
            {
                Caption = 'Absenses';
                Editable = false;
            }
            field("No. autorizacion"; rec."No. autorizacion")
            {
            }
            field("Fecha hora autorizacion"; rec."Fecha hora autorizacion")
            {
            }
        }
    }

    actions
    {
    }

    var
        Text001: Label 'No. autorización';
        Text002: Label 'Fecha/hora autorización';
}

