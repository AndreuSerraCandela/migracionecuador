page 76215 "Ficha Acciones"
{
    ApplicationArea = all;
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    SourceTable = Acciones;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("ID Accion"; rec."ID Accion")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Tipo Accion"; rec."Tipo Accion")
                {
                }
                field("Necesita Datos"; rec."Necesita Datos")
                {
                    Editable = false;
                }
                field("Tipo Datos"; rec."Tipo Datos")
                {
                    BlankZero = true;
                }
                field("Literal Pedir Datos"; rec."Literal Pedir Datos")
                {
                    Editable = true;
                }
            }
        }
    }

    actions
    {
    }
}

