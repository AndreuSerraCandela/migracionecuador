report 55014 "Respaldo Reembolsos ingresados"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RespaldoReembolsosingresados.rdlc';

    dataset
    {
        dataitem("Facturas de reembolso"; "Facturas de reembolso")
        {
            DataItemTableView = SORTING ("Document Type", "Document No.", "Line No.");
            RequestFilterFields = "Document No.";
            column(DocumentNo_Facturasdereembolso; "Facturas de reembolso"."Document No.")
            {
            }
            column(LineNo_Facturasdereembolso; "Facturas de reembolso"."Line No.")
            {
            }
            column(TipoID_Facturasdereembolso; "Facturas de reembolso"."Tipo ID")
            {
            }
            column(RUC_Facturasdereembolso; "Facturas de reembolso".RUC)
            {
            }
            column(TipoComprobante_Facturasdereembolso; "Facturas de reembolso"."Tipo Comprobante")
            {
            }
            column(EstablecimientoComprobante_Facturasdereembolso; "Facturas de reembolso"."Establecimiento Comprobante")
            {
            }
            column(PuntoEmisionComprobante_Facturasdereembolso; "Facturas de reembolso"."Punto Emision Comprobante")
            {
            }
            column(NumeroSecuencialComprobante_Facturasdereembolso; "Facturas de reembolso"."Numero Secuencial Comprobante")
            {
            }
            column(FechaComprobante_Facturasdereembolso; "Facturas de reembolso"."Fecha Comprobante")
            {
            }
            column("NoAutorizaciónComprobante_Facturasdereembolso"; "Facturas de reembolso"."No. Autorización Comprobante")
            {
            }
            column(BaseNoObjetoIVA_Facturasdereembolso; "Facturas de reembolso"."Base No Objeto IVA")
            {
            }
            column(Base0_Facturasdereembolso; "Facturas de reembolso"."Base 0")
            {
            }
            column(BaseX_Facturasdereembolso; "Facturas de reembolso"."Base X")
            {
            }
            column(MontoICE_Facturasdereembolso; "Facturas de reembolso"."Monto ICE")
            {
            }
            column(MontoIVA_Facturasdereembolso; "Facturas de reembolso"."Monto IVA")
            {
            }
            column(DocumentType_Facturasdereembolso; "Facturas de reembolso"."Document Type")
            {
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
}

