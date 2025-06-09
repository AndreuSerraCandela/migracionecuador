page 76026 "Lista Cajeros"
{
    ApplicationArea = all;
    CardPageID = "Ficha Cajero";
    Editable = false;
    PageType = List;
    SourceTable = Cajeros;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Tienda; rec.Tienda)
                {
                }
                field(ID; rec.ID)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Grupo Cajero"; rec."Grupo Cajero")
                {
                }
                field(Tipo; rec.Tipo)
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
    /*         cfComunes: Codeunit "Funciones DsPOS - Comunes";
            Error001: Label 'Función Sólo Disponible en Servidor Central'; */
    begin

        /*        if not (cfComunes.EsCentral) then
                   Error(Error001); */
    end;
}

