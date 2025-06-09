page 55011 "Detalle Datos ATS"
{
    ApplicationArea = all;
    Caption = 'Detalle Datos ATS Compras';
    Editable = false;
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
                field("Fecha Emicion Doc"; rec."Fecha Emicion Doc")
                {
                }
                field("Numero Comprobante Fiscal"; rec."Numero Comprobante Fiscal")
                {
                }
                field("Sustento del Comprobante"; rec."Sustento del Comprobante")
                {
                }
                field("Desc. Sustento Comprobante"; rec."Desc. Sustento Comprobante")
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field("Base 0%"; rec."Base 0%")
                {
                }
                field("Base 12%"; rec."Base 12%")
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
                field("Nombre Proveedor"; rec."Nombre Proveedor")
                {
                }
                field("Tipo de Identificador"; rec."Tipo de Identificador")
                {
                }
                field("Tipo Contribuyente"; rec."Tipo Contribuyente")
                {
                }
                field("Parte Relacionada"; rec."Parte Relacionada")
                {
                    DrillDown = true;
                }
                field("Cod. Retencion 1"; rec."Cod. Retencion 1")
                {
                }
                field("No. Comprobante Retencion 1"; rec."No. Comprobante Retencion 1")
                {
                }
                field("Importe Retencion 1"; rec."Importe Retencion 1")
                {
                }
                field("Base Retencion 1"; rec."Base Retencion 1")
                {
                }
                field("Porcentaje Retencion 1"; rec."Porcentaje Retencion 1")
                {
                }
                field("No. Autorizacion Retencion 1"; rec."No. Autorizacion Retencion 1")
                {
                }
                field("Punto Emision Retencion 1"; rec."Punto Emision Retencion 1")
                {
                }
                field("Establecimiento Retencion 1"; rec."Establecimiento Retencion 1")
                {
                }
                field("Fecha Caducidad Retencion 1"; rec."Fecha Caducidad Retencion 1")
                {
                }
                field("Cod. Retencion 2"; rec."Cod. Retencion 2")
                {
                    Caption = 'Cód. Retención 2';
                }
                field("No. Comprobante Retencion 2"; rec."No. Comprobante Retencion 2")
                {
                }
                field("Base Retencion 2"; rec."Base Retencion 2")
                {
                }
                field("Importe Retencion 2"; rec."Importe Retencion 2")
                {
                    Caption = '<Importe Retención 2>';
                }
                field("Porcentaje Retencion 2"; rec."Porcentaje Retencion 2")
                {
                }
                field("No. Autorizacion Retencion 2"; rec."No. Autorizacion Retencion 2")
                {
                }
                field("Punto Emision Retencion 2"; rec."Punto Emision Retencion 2")
                {
                }
                field("Establecimiento Retencion 2"; rec."Establecimiento Retencion 2")
                {
                }
                field("Fecha Caducidad Retencion 2"; rec."Fecha Caducidad Retencion 2")
                {
                }
                field("Cod. Retencion 3"; rec."Cod. Retencion 3")
                {
                    Caption = 'Cód. Retención 3';
                }
                field("No. Comprobante Retencion 3"; rec."No. Comprobante Retencion 3")
                {
                }
                field("Importe Retencion 3"; rec."Importe Retencion 3")
                {
                    Caption = '<Importe Retención 3>';
                }
                field("Base Retencion 3"; rec."Base Retencion 3")
                {
                }
                field("Porcentaje Retencion 3"; rec."Porcentaje Retencion 3")
                {
                }
                field("No. Autorizacion Retencion 3"; rec."No. Autorizacion Retencion 3")
                {
                }
                field("Punto Emision Retencion 3"; rec."Punto Emision Retencion 3")
                {
                }
                field("Establecimiento Retencion 3"; rec."Establecimiento Retencion 3")
                {
                }
                field("Fecha Caducidad Retencion 3"; rec."Fecha Caducidad Retencion 3")
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
                field("Secuencial de la Fatura"; rec."No. Comprobante Fiscal Rel.")
                {
                    Caption = 'Secuencial de la Fatura Rel.';
                }
                field("Punto Emision Factura Rel."; rec."Punto Emision Factura Rel.")
                {
                }
                field("Establecimiento Factura Rel."; rec."Establecimiento Factura Rel.")
                {
                }
                field("No.Autorizacion Factura Rel."; rec."No.Autorizacion Factura Rel.")
                {
                }
                field("Tipo Comprobante Factura Rel."; rec."Tipo Comprobante Factura Rel.")
                {
                }
                field("No. Pedido"; rec."No. Pedido")
                {
                }
                field("Comprobante Egreso"; rec."Comprobante Egreso")
                {
                }
                field("12% IVA"; rec."12% IVA")
                {
                }
                field("Tipo Retencion"; rec."Tipo Retencion")
                {
                }
                field("Fecha Caducidad"; rec."Fecha Caducidad")
                {
                }
                field("% Retencion"; rec."% Retencion")
                {
                }
                field("Retencion IVA"; rec."Retencion IVA")
                {
                }
                field("Tipo Comprobante"; rec."Tipo Comprobante")
                {
                }
                field("Importe Base Retencion"; rec."Importe Base Retencion")
                {
                }
                field("Secuencia Contabilidad"; rec."Secuencia Contabilidad")
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
                field("Forma de Pago"; rec."Forma de Pago")
                {
                }
                field("Fecha Emision Retencion"; rec."Fecha Emision Retencion")
                {
                    Caption = '<Fecha Emisión Retención>';
                }
                field("Pago a residente"; rec."Pago a residente")
                {
                    Caption = 'Pago a residente o no residente';
                }
                field("Codigo de Pais"; rec."Codigo de Pais")
                {
                }
                field("Tiene Convenio"; rec."Tiene Convenio")
                {
                    DrillDown = true;
                }
                field("Sujeto a Retencion"; rec."Sujeto a Retencion")
                {
                    Caption = '<Sujeto a Retención>';
                    DrillDown = true;
                }
                field("Reg. Fiscal preferente/Paraiso"; rec."Reg. Fiscal preferente/Paraiso")
                {
                }
                field("Caja Chica"; rec."Caja Chica")
                {
                }
            }
        }
    }

    actions
    {
    }
}

