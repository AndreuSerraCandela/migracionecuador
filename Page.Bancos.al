page 76112 Bancos
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = Bancos;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Codigo; rec.Codigo)
                {
                }
                field("Nombre banco"; rec."Nombre banco")
                {
                }
                field("ID Banco"; rec."ID Banco")
                {
                }
                field(Formato; rec.Formato)
                {
                }
            }
        }
    }

    actions
    {
    }
}

