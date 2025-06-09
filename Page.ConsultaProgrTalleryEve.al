#pragma implicitwith disable
page 76159 "Consulta Progr. Taller y Eve."
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Programac. Talleres y Eventos";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fecha programacion"; Rec."Fecha programacion")
                {
                }
                field("FORMAT(""Hora de Inicio"") + ' - ' + FORMAT(""Hora Final"")"; Format(Rec."Hora de Inicio") + ' - ' + Format(Rec."Hora Final"))
                {
                    Caption = 'Horario';
                }
                field("Horas dictadas"; Rec."Horas dictadas")
                {
                }
                field("Cod. Grado"; Rec."Cod. Grado")
                {
                }
            }
        }
    }

    actions
    {
    }
}

#pragma implicitwith restore

