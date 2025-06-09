page 76148 "Colegio - Work Flow Programado"
{
    ApplicationArea = all;
    AutoSplitKey = true;
    Caption = 'School - programming Work flow';
    DelayedInsert = true;
    PageType = ListPlus;
    SourceTable = "Colegio - Work Flow visitas";
    SourceTableView = WHERE(Programado = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Programado; rec.Programado)
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        wEdit: Boolean;
}

