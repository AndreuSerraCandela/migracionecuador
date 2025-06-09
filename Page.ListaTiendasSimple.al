page 76312 "Lista Tiendas Simple"
{
    ApplicationArea = all;
    Editable = false;
    PageType = ConfirmationDialog;
    SourceTable = Tiendas;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group("Información :")
            {
                field(text001; text001)
                {
                    Editable = false;
                    MultiLine = false;
                    ShowCaption = false;
                    Style = Attention;
                    StyleExpr = TRUE;
                }
            }
            repeater(Group)
            {
                field("Cod. Tienda"; rec."Cod. Tienda")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        text001: Label 'Seleccione una Tienda para ver sus históricos';
        wText: Integer;


    procedure RecibirTiendas(var pr_TiendasTMP: Record Tiendas temporary)
    begin

        if pr_TiendasTMP.FindSet then
            repeat
                Rec := pr_TiendasTMP;
                Rec.Insert;
            until pr_TiendasTMP.Next = 0;
    end;
}

