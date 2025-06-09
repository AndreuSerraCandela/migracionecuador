page 76192 "DSNOM Tools FactBox"
{
    ApplicationArea = all;
    Caption = 'Tools in use';
    PageType = CardPart;
    SourceTable = "Misc. Article Information";
    SourceTableView = WHERE ("In Use" = CONST (true));

    layout
    {
        area(content)
        {
            repeater(Control1000000004)
            {
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                ShowCaption = false;
                field(Description; rec.Description)
                {
                }
                field("From Date"; rec."From Date")
                {
                }
                field("Serial No."; rec."Serial No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

