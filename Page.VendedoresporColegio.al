page 51010 "Vendedores por Colegio"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Vendedores por Colegio";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Vendedor"; rec."Cod. Vendedor")
                {
                }
                field("Nombre Vendedor"; rec."Nombre Vendedor")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

