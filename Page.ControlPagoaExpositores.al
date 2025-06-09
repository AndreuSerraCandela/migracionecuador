#pragma implicitwith disable
page 76163 "Control Pago a Expositores"
{
    ApplicationArea = all;

    PageType = List;
    SourceTable = "Expositores APS";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; rec."No.")
                {
                }
                field(Name; rec.Name)
                {
                }
                field("Eventos Planif. Pendiente Pago"; rec."Eventos Planif. Pendiente Pago")
                {
                }
                field("Eventos Planif. Pagados"; rec."Eventos Planif. Pagados")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Filters)
            {
                Caption = 'Filters';
                action("pendiente pago")
                {
                    Caption = 'Filtrar los expositores con eventos Pendientes de Pago';
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.SetFilter("Eventos Planif. Pendiente Pago", '>%1', 0);
                    end;
                }
                action(todos)
                {
                    Caption = 'Eliminar Filtro de expositores con eventos Pendientes de Pago';
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.SetRange("Eventos Planif. Pendiente Pago");
                    end;
                }
                action(pagosptes)
                {
                    Caption = 'Ver lista de los pagos pendientes de todos los expositores';
                    Image = VendorLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Estado Pago Expo. Eve. Planif.";
                    RunPageLink = Pagado = CONST(false);
                }
            }
        }
    }
}

#pragma implicitwith restore

