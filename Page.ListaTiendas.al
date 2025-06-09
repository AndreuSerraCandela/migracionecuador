page 76018 "Lista Tiendas"
{
    ApplicationArea = all;
    CardPageID = "Ficha Tienda";
    Editable = false;
    PageType = List;
    SourceTable = Tiendas;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Tienda"; rec."Cod. Tienda")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Registro En Linea"; rec."Registro En Linea")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    var

    begin


    end;
}

