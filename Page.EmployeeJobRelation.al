page 76198 "Employee - Job Relation"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Relacion Empleados - Proyectos";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; rec."Employee No.")
                {
                    Visible = false;
                }
                field("Job No."; rec."Job No.")
                {
                }
                field("Job Task No."; rec."Job Task No.")
                {
                }
                field("Job Line Type"; rec."Job Line Type")
                {
                }
                field("Job Unit Price"; rec."Job Unit Price")
                {
                    Visible = false;
                }
                field("Job Description"; rec."Job Description")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Job Task Name"; rec."Job Task Name")
                {
                    Caption = 'Job Task Name';
                    Editable = false;
                    Visible = false;
                }
                field("% to distribute"; rec."% to distribute")
                {
                }
            }
        }
    }

    actions
    {
    }
}

