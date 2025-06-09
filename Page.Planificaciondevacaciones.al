page 76349 "Planificacion de vacaciones"
{
    ApplicationArea = all;
    Caption = 'Vacation planning';
    PageType = List;
    SourceTable = "Planificacion de vacaciones";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. empleado"; rec."No. empleado")
                {
                }
                field("Fecha inicio planificada"; rec."Fecha inicio planificada")
                {
                }
                field("Fecha fin planificada"; rec."Fecha fin planificada")
                {
                }
                field("Dias acumulados actual"; rec."Dias acumulados actual")
                {
                }
                field("Dias acumulados estimados"; rec."Dias acumulados estimados")
                {
                }
                field(Status; rec.Status)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Calendar")
            {
                Caption = '&Calendar';
                action("Suggest vacation")
                {
                    Caption = 'Suggest vacation';
                    Image = AbsenceCalendar;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        REPORT.RunModal(REPORT::"Proceso proponer vacaciones", true, false);
                    end;
                }
            }
        }
    }
}

