page 76269 "Lista Acciones personal arch."
{
    ApplicationArea = all;
    Caption = 'Archived Personal Actions List';
    CardPageID = "Lista Cab. planific.  entrenam";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Arch. Acciones de personal";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tipo de accion"; rec."Tipo de accion")
                {
                }
                field("Cod. accion"; rec."Cod. accion")
                {
                }
                field("No. empleado"; rec."No. empleado")
                {
                }
                field("Nombre completo"; rec."Nombre completo")
                {
                }
                field("ID Documento"; rec."ID Documento")
                {
                }
                field("Descripcion accion"; rec."Descripcion accion")
                {
                }
                field("Fecha accion"; rec."Fecha accion")
                {
                }
                field("Fecha efectividad"; rec."Fecha efectividad")
                {
                }
                field(Comentario; rec.Comentario)
                {
                }
            }
        }
    }

    actions
    {
    }
}

