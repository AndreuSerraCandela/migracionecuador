page 76391 Shift
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = Shift;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Incluir Hora de almuerzo"; rec."Incluir Hora de almuerzo")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Shift)
            {
                Caption = 'Shift';
                action(Calendar)
                {
                    Caption = 'Calendar';
                    Image = ProfileCalendar;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Shift schedule";
                    RunPageLink = "Codigo turno" = FIELD (Codigo);
                }
            }
        }
    }
}

