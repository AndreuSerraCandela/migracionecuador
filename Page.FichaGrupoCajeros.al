page 76020 "Ficha Grupo Cajeros"
{
    ApplicationArea = all;
    DelayedInsert = true;
    Editable = true;
    PageType = Card;
    SourceTable = "Grupos Cajeros";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Tienda; rec.Tienda)
                {
                }
                field(Grupo; rec.Grupo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Cliente al contado"; rec."Cliente al contado")
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
        Error001: Label 'Función Sólo Disponible en Servidor Central';
    begin


    end;

    var

}

