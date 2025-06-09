page 76021 "Lista Acciones"
{
    ApplicationArea = all;
    CardPageID = "Ficha Acciones";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Acciones;

    layout
    {
        area(content)
        {
            repeater(Group)
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
                }
                field("Tipo Datos"; rec."Tipo Datos")
                {
                    BlankZero = true;
                }
                field("Literal Pedir Datos"; rec."Literal Pedir Datos")
                {
                    //The property BlankZero is only supported on fields of type BigInteger, Boolean, Integer, Decimal, Duration, Enum, and Option.
                    //BlankZero = true;
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
    /*        cfComunes: Codeunit "Funciones DsPOS - Comunes"; */
    begin

        /*     if not (cfComunes.EsCentral) then
                Error(Error001); */
    end;
}

