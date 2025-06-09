page 76340 "Param. Income tax - Empleado"
{
    ApplicationArea = all;
    Caption = 'Employee - Income tax exceptions';
    PageType = List;
    SourceTable = "Income tax Employee parameters";

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
                field("Exemption code"; rec."Exemption code")
                {
                }
                field("Wedge Code"; rec."Wedge Code")
                {
                }
                field(Status; rec.Status)
                {
                }
                field("Exemption type"; rec."Exemption type")
                {
                }
                field("Personal Exemption"; rec."Personal Exemption")
                {
                }
                field("Importe fijo"; rec."Importe fijo")
                {
                }
                field("Exeption for Dependents"; rec."Exeption for Dependents")
                {
                }
            }
        }
    }

    actions
    {
    }
}

