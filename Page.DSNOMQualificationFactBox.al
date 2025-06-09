#pragma implicitwith disable
page 76191 "DSNOM Qualification FactBox"
{
    ApplicationArea = all;
    Caption = 'Training agreements';
    PageType = CardPart;
    SourceTable = "Employee Qualification";
    SourceTableView = WHERE("Acuerdo de permanencia" = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Control1000000004)
            {
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                ShowCaption = false;
                field("FORMAT(Description)"; Format(Rec.Description))
                {
                }
                field("Expiration Date"; Rec."Expiration Date")
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

