page 76132 "Clientes relacionados"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Clientes Relacionados";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Cliente"; rec."Cod. Cliente")
                {
                }
                field("Cod. Cliente Relacionado"; rec."Cod. Cliente Relacionado")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Descripcion Cte. Relacionado"; rec."Descripcion Cte. Relacionado")
                {
                }
                field(Balance; rec.Balance)
                {
                }
                field("Balance (LCY)"; rec."Balance (LCY)")
                {
                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

