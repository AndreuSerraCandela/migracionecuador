page 76015 "Ficha Cajero"
{
    ApplicationArea = all;
    DelayedInsert = true;
    PageType = Card;
    SourceTable = Cajeros;

    layout
    {
        area(content)
        {
            group(General)
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
                field(Contrasena; rec.Contrasena)
                {
                    ExtendedDatatype = Masked;
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
        Error001: Label 'Función Sólo Disponible en Servidor Central';

    begin


    end;
}

