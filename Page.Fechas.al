#pragma implicitwith disable
page 76214 Fechas
{
    ApplicationArea = all;
    Editable = false;
    PageType = ListPlus;
    SourceTable = Date;
    SourceTableView = WHERE("Period Type" = CONST(Week));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Period Type"; Rec."Period Type")
                {
                }
                field("Period Start"; Rec."Period Start")
                {
                }
                field("NORMALDATE(""Period End"")"; NormalDate(Rec."Period End"))
                {
                    Caption = 'Period End';
                }
                field("Period No."; Rec."Period No.")
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

