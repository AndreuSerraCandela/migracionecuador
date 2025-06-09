page 76044 "Ficha Centros de Trabajo"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Centros de Trabajo";

    layout
    {
        area(content)
        {
            group(Control1)
            {
                Caption = '', Locked = true;
                field("Empresa cotización"; rec."Empresa cotización")
                {
                }
                field("Centro de trabajo"; rec."Centro de trabajo")
                {
                }
                field("Dirección"; rec.Dirección)
                {
                }
                field("C.P."; rec."C.P.")
                {
                    Caption = 'C.P. + Población';
                }
                field("Población"; rec.Población)
                {
                }
                field(Provincia; rec.Provincia)
                {
                }
            }
        }
    }

    actions
    {
    }
}

