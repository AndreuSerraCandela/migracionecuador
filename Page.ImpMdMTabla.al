page 75004 "Imp.MdM Tabla"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Imp.MdM Tabla";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Id; rec.Id)
                {
                }
                field("Id Cab."; rec."Id Cab.")
                {
                }
                field(Operacion; rec.Operacion)
                {
                }
                field("Id Tabla"; rec."Id Tabla")
                {
                }
                field("Code"; rec.Code)
                {
                }
                field("Code MdM"; rec."Code MdM")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field(Tipo; rec.Tipo)
                {
                }
                field("Nombre Elemento"; rec."Nombre Elemento")
                {
                }
                field(Visible; rec.Visible)
                {
                }
                field(Procesado; rec.Procesado)
                {
                }
            }
            part(Control1000000011; "Imp.MdM Campos")
            {
                Caption = 'Campos';
                SubPageLink = "Id Rel" = FIELD (Id);
            }
        }
    }

    actions
    {
    }
}

