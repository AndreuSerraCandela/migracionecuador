page 55023 "ATS ventas Establecimiento"
{
    ApplicationArea = all;
    Caption = 'ATS Vtas x Establecimiento';
    PageType = ListPart;
    SourceTable = "ATS Ventas x Establecimiento";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod.Establecimiento"; rec."Cod.Establecimiento")
                {
                }
                field("Ventas Establecimiento"; rec."Ventas Establecimiento")
                {
                }
            }
        }
    }

    actions
    {
    }
}

