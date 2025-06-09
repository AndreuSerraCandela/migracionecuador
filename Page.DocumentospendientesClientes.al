page 56019 "Documentos pendientes Clientes"
{
    ApplicationArea = all;
    Editable = false;
    PageType = List;
    SourceTable = "Doc. pendientes Cliente Movil.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Cliente"; rec."Cod. Cliente")
                {
                }
                field(Nombre; rec.Nombre)
                {
                }
                field("Tipo Documento"; rec."Tipo Documento")
                {
                }
                field("No. Documento"; rec."No. Documento")
                {
                }
                field("Fecha Registro"; rec."Fecha Registro")
                {
                }
                field("Fecha Vencimiento"; rec."Fecha Vencimiento")
                {
                }
                field("Importe inicial"; rec."Importe inicial")
                {
                }
                field("Importe Pendiente"; rec."Importe Pendiente")
                {
                }
                field("Cod. Divisa"; rec."Cod. Divisa")
                {
                }
                field("Fecha Ult. Actualizacion"; rec."Fecha Ult. Actualizacion")
                {
                }
                field("No. Doc. Externo"; rec."No. Doc. Externo")
                {
                }
                field("Importe inicial ($)"; rec."Importe inicial ($)")
                {
                }
                field("Importe Pendiente ($)"; rec."Importe Pendiente ($)")
                {
                }
            }
        }
    }

    actions
    {
    }
}

