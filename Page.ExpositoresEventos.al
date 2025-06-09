#pragma implicitwith disable
page 76210 "Expositores - Eventos"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Expositores - Eventos";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tipo de Expositor"; rec."Tipo de Expositor")
                {
                }
                field("Cod. Expositor"; rec."Cod. Expositor")
                {
                }
                field("Tipo de Evento"; rec."Tipo de Evento")
                {
                    Visible = false;
                }
                field("Cod. Evento"; rec."Cod. Evento")
                {
                }
                field("Nombre Expositor"; rec."Nombre Expositor")
                {
                }
                field("Descripcion Evento"; rec."Descripcion Evento")
                {
                }
                field(Delegacion; rec.Delegacion)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1000000044>")
            {
                Caption = 'Workshop - Event';
                action("<Action1000000047>")
                {
                    Caption = 'Schedule';
                    Image = CalendarChanged;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CabPlanEvent: Record "Cab. Planif. Evento";
                        CabPlanEvent2: Record "Cab. Planif. Evento";
                        PlanEvent: Page "Lista Cab. Planif. Evento";
                    begin
                        PlanEvent.RecibeParametros(Rec."Cod. Expositor", Rec."Tipo de Expositor", Rec."Cod. Evento", CabPlanEvent."Tipo Evento");
                        CabPlanEvent.Reset;
                        CabPlanEvent.SetRange("Cod. Taller - Evento", Rec."Cod. Evento");
                        if CabPlanEvent.FindFirst then
                            PlanEvent.SetRecord(CabPlanEvent);

                        PlanEvent.RunModal;

                        Clear(PlanEvent);
                    end;
                }
            }
        }
    }
}

#pragma implicitwith restore

