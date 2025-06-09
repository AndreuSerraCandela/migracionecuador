page 55026 "Detalle ATS Ventas"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "ATS Compras/Ventas";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tipo Documento"; rec."Tipo Documento")
                {
                }
                field("No. Documento"; rec."No. Documento")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Fecha Registro"; rec."Fecha Registro")
                {
                }
                field("Numero Comprobante Fiscal"; rec."Numero Comprobante Fiscal")
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field("Importe IVA"; rec."Importe IVA")
                {
                }
                field("Importe IVA Incl."; rec."Importe IVA Incl.")
                {
                }
                field("Source Type"; rec."Source Type")
                {
                }
                field("Source No."; rec."Source No.")
                {
                }
                field("RUC/Cedula"; rec."RUC/Cedula")
                {
                }
                field("No. Autorizacion Documento"; rec."No. Autorizacion Documento")
                {
                }
                field("Punto Emision Documento"; rec."Punto Emision Documento")
                {
                }
                field("Establecimiento Documento"; rec."Establecimiento Documento")
                {
                }
                field("Fecha Caducidad"; rec."Fecha Caducidad")
                {
                }
                field("No. Pedido"; rec."No. Pedido")
                {
                }
                field("12% IVA"; rec."12% IVA")
                {
                }
                field("Tipo Comprobante"; rec."Tipo Comprobante")
                {
                }
                field(_EXENTO; rec._EXENTO)
                {
                }
                field(_GR_0; rec._GR_0)
                {
                }
                field(_GR_12; rec._GR_12)
                {
                }
                field("10_SERVIC"; rec."10_SERVIC")
                {
                }
                field(Exportacion; rec.Exportacion)
                {
                    Caption = '<Exportación>';
                }
            }
        }
    }

    actions
    {
    }
}

