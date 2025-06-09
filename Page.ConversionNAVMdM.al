#pragma implicitwith disable
page 75007 "Conversion NAV MdM"
{
    ApplicationArea = all;
    //ApplicationArea = Basic, Suite, Service;
    Caption = 'MdM Conversion';
    DelayedInsert = true;
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "Conversion NAV MdM";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tipo Registro"; rec."Tipo Registro")
                {
                }
                field("Codigo MdM"; rec."Codigo MdM")
                {
                }
                field("Codigo NAV"; rec."Codigo NAV")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.SetDimFilter;
    end;
}

#pragma implicitwith restore

