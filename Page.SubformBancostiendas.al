page 76405 "Subform Bancos tiendas"
{
    ApplicationArea = all;
    PageType = ListPart;
    SourceTable = "Bancos tienda";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Divisa"; rec."Cod. Divisa")
                {
                }
                field("Cod. Banco"; rec."Cod. Banco")
                {
                }
                field("Nombre Banco"; rec."Nombre Banco")
                {
                }
            }
        }
    }

    actions
    {
    }
}

