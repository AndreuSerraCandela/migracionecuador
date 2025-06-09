page 76212 "FactBox total ventas"
{
    ApplicationArea = all;
    PageType = ListPart;
    SourceTable = "Configuracion TPV";

    layout
    {
        area(content)
        {
            repeater(Control1000000003)
            {
                ShowCaption = false;
                field("Id TPV"; rec."Id TPV")
                {
                    Caption = 'TPV';
                    Importance = Promoted;
                }
                field("Importe ventas"; rec."Importe ventas")
                {
                    Caption = 'Ventas';
                }
                field("Importe cobros"; rec."Importe cobros")
                {
                    Caption = 'Cobros';
                }
            }
            grid(Control1000000001)
            {
                ShowCaption = false;
                group(Control1000000002)
                {
                    ShowCaption = false;
                    field(Tienda; rec.Tienda)
                    {
                        Caption = 'Store';
                    }
                    field("Importe ventas tienda"; rec."Importe ventas Tienda")
                    {
                        Caption = 'Ventas';
                    }
                    field("Importe cobros tienda"; rec."Importe cobros Tienda")
                    {
                        Caption = 'Cobros';
                    }
                }
            }
        }
    }

    actions
    {
    }

    var
        decTienda: Decimal;
        decTPV: Decimal;
}

