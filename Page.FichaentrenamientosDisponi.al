#pragma implicitwith disable
page 76221 "Ficha entrenamientos - Disponi"
{
    ApplicationArea = all;
    Caption = 'Training Card';
    PageType = Card;
    SourceTable = "ent - aaa - Disponible";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Codigo; rec.Codigo)
                {

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit() then
                            CurrPage.Update;
                    end;
                }
                field("Tipo entrenamiento"; rec."Tipo entrenamiento")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field(Tipo; rec.Tipo)
                {
                }
                field("Fecha creacion"; rec."Fecha creacion")
                {
                }
                field("Horas estimadas"; rec."Horas estimadas")
                {
                }
                field("Capacidad de asistentes"; rec."Capacidad de asistentes")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Schedule)
            {
                Caption = 'Schedule';
                action(Action1000000017)
                {
                    Caption = 'Schedule';
                    Image = Timesheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Lin. Entrenamientos";
                    RunPageLink = "Tipo entrenamiento" = FIELD("Tipo entrenamiento"),
                                  Disponible = FIELD(Codigo);
                }
            }
        }
    }
}

#pragma implicitwith restore

