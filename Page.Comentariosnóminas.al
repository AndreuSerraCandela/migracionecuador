page 76149 "Comentarios nóminas"
{
    ApplicationArea = all;
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Comentarios nómina";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Fecha; rec.Fecha)
                {
                }
                field(Texto; rec.Texto)
                {
                }
            }
        }
    }

    actions
    {
    }
}

