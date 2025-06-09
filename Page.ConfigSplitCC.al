page 76058 "Config. Split CC"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Config. Distrib. CC";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cta. Contable"; rec."Cta. Contable")
                {
                    Visible = false;
                }
                field("Descripcion Cta. Contable"; rec."Descripcion Cta. Contable")
                {
                }
                field("Dimension Code"; rec."Dimension Code")
                {
                }
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("% a distribuir"; rec."% a distribuir")
                {
                }
            }
        }
    }

    actions
    {
    }
}

