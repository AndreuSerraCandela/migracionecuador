page 75003 "Imp.MdM Cabecera"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Imp.MdM Cabecera";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Id; rec.Id)
                {
                }
                field(Operacion; rec.Operacion)
                {
                }
                field("Fecha Creacion"; rec."Fecha Creacion")
                {
                }
                field(id_mensaje; rec.id_mensaje)
                {
                }
                field(sistema_origen; rec.sistema_origen)
                {
                }
                field(pais_origen; rec.pais_origen)
                {
                }
                field(fecha_origen; rec.fecha_origen)
                {
                }
                field(fecha; rec.fecha)
                {
                }
                field(tipo; rec.tipo)
                {
                }
                field(Entrada; rec.Entrada)
                {
                }
                field(Traspasado; rec.Traspasado)
                {
                }
                field(Estado; rec.Estado)
                {
                }
                field("Estado Envio"; rec."Estado Envio")
                {
                }
                field(Attempt; rec.Attempt)
                {
                }
                field("Texto Error"; rec."Texto Error")
                {
                    ColumnSpan = 2;
                    RowSpan = 2;
                }
                field("No Tablas"; rec."No Tablas")
                {
                }
                field("No Tablas Procesadas"; rec."No Tablas Procesadas")
                {
                }
            }
            part(Control1000000013; "Lista Imp.Mdm Tabla")
            {
                SubPageLink = "Id Cab." = FIELD (Id);
            }
        }
    }

    actions
    {
    }
}

