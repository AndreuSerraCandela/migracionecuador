page 76011 "Lista TPVs"
{
    ApplicationArea = all;
    CardPageID = "Ficha TPV";
    Editable = false;
    PageType = List;
    SourceTable = "Configuracion TPV";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Tienda; rec.Tienda)
                {
                }
                field("Id TPV"; rec."Id TPV")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Usuario windows"; rec."Usuario windows")
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

        ;
    end;
}

