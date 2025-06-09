page 55005 "XML SRI"
{
    ApplicationArea = all;

    layout
    {
        area(content)
        {
        }
    }

    actions
    {
        area(processing)
        {
            action(ATS)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    XMLPORT.Run(55008, true, false);
                end;
            }
            action("FORMULARIO 101")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    XMLPORT.Run(55001, true, false);
                end;
            }
            action("FORMULARIO 103")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    XMLPORT.Run(55002, true, false);
                end;
            }
            action("FORMULARIO 104")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    XMLPORT.Run(55003, true, false);
                end;
            }
        }
    }

    var
        XML_SRI: Codeunit "Genera Oferta de Promo";
}

