pageextension 50082 pageextension50082 extends "Employee Qualifications"
{
    layout
    {
        addafter("Course Grade")
        {
            field("Acuerdo de permanencia"; rec."Acuerdo de permanencia")
            {
            ApplicationArea = All;
            }
        }
    }
}

