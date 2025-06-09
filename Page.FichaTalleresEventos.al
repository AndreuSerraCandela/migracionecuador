#pragma implicitwith disable
page 76226 "Ficha Talleres - Eventos"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = Eventos;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Tipo de Evento"; rec."Tipo de Evento")
                {
                }
                field("Descripcion Tipo Evento"; rec."Descripcion Tipo Evento")
                {
                    Editable = false;
                }
                field("No."; rec."No.")
                {

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field(Delegacion; rec.Delegacion)
                {
                }
                field("Descripcion Delegacion"; rec."Descripcion Delegacion")
                {
                    Editable = false;
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Fecha creacion"; rec."Fecha creacion")
                {
                    Editable = false;
                }
                field("Horas programadas"; rec."Horas programadas")
                {
                }
                field("Capacidad de vacantes"; rec."Capacidad de vacantes")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Event")
            {
                Caption = '&Event';
                action("&Expositores")
                {
                    Caption = '&Expositores';
                    Image = NewResource;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Expositores - Eventos";
                    RunPageLink = "Cod. Evento" = FIELD("No.");
                }
                action("<Action1000000039>")
                {
                    Caption = 'Materiales';
                    Image = CalculateInventory;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Materiales Talleres y Eventos";
                    RunPageLink = "Cod. Taller - Evento" = FIELD("No."),
                                  "Tipo Evento" = FIELD("Tipo de Evento"),
                                  Secuencia = CONST(0);
                }
            }
        }
    }
}

#pragma implicitwith restore

