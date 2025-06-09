page 55007 "Grupo Cont. Consig. Por Def."
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Grpo. Exist. Consig. Defecto";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Grupo Contable Exist."; rec."Grupo Contable Exist.")
                {
                    Caption = 'Inventory Posting Group';
                }
                field("Cod. Cuenta"; rec."Cod. Cuenta")
                {
                }
            }
        }
    }

    actions
    {
    }
}

