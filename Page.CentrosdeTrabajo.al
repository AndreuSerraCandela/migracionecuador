page 76060 "Centros de Trabajo"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Centros de Trabajo";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Centro de trabajo"; rec."Centro de trabajo")
                {
                }
                field(Nombre; rec.Nombre)
                {
                }
                field("Empresa cotización"; rec."Empresa cotización")
                {
                }
                field("Dirección"; rec.Dirección)
                {
                }
                field("C.P."; rec."C.P.")
                {
                }
                field("Población"; rec.Población)
                {
                }
                field(Provincia; rec.Provincia)
                {
                }
                field("Fecha de Cierre Nomina"; rec."Fecha de Cierre Nomina")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Libro matrícula")
            {
                Caption = '&Libro matrícula';
                Promoted = true;
                PromotedCategory = Process;
/*                 RunObject = Page Page71107;
                RunPageLink = Field2 = FIELD ("Centro de trabajo"); */
                Visible = false;
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

