page 76327 "Mov. Novedades"
{
    ApplicationArea = all;
    DataCaptionFields = "Tipo de accion", "Emitir documento";
    Editable = false;
    PageType = List;
    SourceTable = "Tipos de acciones personal";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Editar salario"; rec."Editar salario")
                {
                }
                field("Tipo de accion"; rec."Tipo de accion")
                {
                    Visible = false;
                }
                field(Codigo; rec.Codigo)
                {
                    Visible = false;
                }
                field("Emitir documento"; rec."Emitir documento")
                {
                    Visible = false;
                }
                field("ID Documento"; rec."ID Documento")
                {
                }
                field("Editar cargo"; rec."Editar cargo")
                {
                }
                field("Transferir entre empresas"; rec."Transferir entre empresas")
                {
                }
                field("Pagar preaviso"; rec."Pagar preaviso")
                {
                }
                field("Pagar cesantia"; rec."Pagar cesantia")
                {
                }
            }
        }
    }

    actions
    {
    }
}

