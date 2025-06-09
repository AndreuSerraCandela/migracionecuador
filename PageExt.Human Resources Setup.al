pageextension 50087 pageextension50087 extends "Human Resources Setup"
{
    layout
    {
        modify("Automatically Create Resource")
        {
            Visible = false;
        }
        addafter("Automatically Create Resource")
        {
            field("Candidate Nos."; rec."Candidate Nos.")
            {
            ApplicationArea = All;
            }
            field("No. serie acciones personal"; rec."No. serie acciones personal")
            {
            ApplicationArea = All;
            }
            field("No. serie entrenamientos"; rec."No. serie entrenamientos")
            {
            ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify("Human Res. Units of Measure")
        {
            Caption = 'Human Res. Units of Measure';
        }
    }
}

