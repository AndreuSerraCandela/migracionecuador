page 76077 "Datos Ponchador"
{
    ApplicationArea = all;
    Caption = 'T&A log';
    PageType = List;
    SourceTable = "Punch log";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Empleado"; rec."Cod. Empleado")
                {
                }
                field("Full name"; rec."Full name")
                {
                }
                field("Job Title"; rec."Job Title")
                {
                }
                field("Fecha registro"; rec."Fecha registro")
                {
                }
                field("Hora registro"; rec."Hora registro")
                {
                }
                field("No. tarjeta"; rec."No. tarjeta")
                {
                }
                field("ID Equipo"; rec."ID Equipo")
                {
                }
                field(Procesado; rec.Procesado)
                {
                }
                field("Job No."; rec."Job No.")
                {
                }
                field("Job Task No."; rec."Job Task No.")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Actions")
            {
                Caption = 'Actions';
                Image = LinesFromTimesheet;
                action("Import data from T&A Clock")
                {
                    Caption = 'Import data from T&A Clock';
                    Image = LinesFromTimesheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var

                    begin

                    end;
                }
            }
        }
    }
}

