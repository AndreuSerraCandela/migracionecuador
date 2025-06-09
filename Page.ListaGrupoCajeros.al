page 76022 "Lista Grupo Cajeros"
{
    ApplicationArea = all;
    CardPageID = "Ficha Grupo Cajeros";
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = "Grupos Cajeros";

    layout
    {
        area(content)
        {
            repeater(Group)
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
}

