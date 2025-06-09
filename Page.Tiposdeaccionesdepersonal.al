page 76412 "Tipos de acciones de personal"
{
    ApplicationArea = all;
    Caption = 'Actions Human resources';
    PageType = List;
    SourceTable = "Tipos de acciones personal";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Tipo de accion"; rec."Tipo de accion")
                {
                    Editable = false;
                }
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Editar salario"; rec."Editar salario")
                {
                }
                field("Editar cargo"; rec."Editar cargo")
                {
                }
                field("Emitir documento"; rec."Emitir documento")
                {
                    Editable = false;
                }
                field("Transferir entre empresas"; rec."Transferir entre empresas")
                {
                }
                field("ID Documento"; rec."ID Documento")
                {
                    Visible = false;
                }
                field(Suspension; rec.Suspension)
                {
                }
            }
        }
    }

    actions
    {
    }
}

