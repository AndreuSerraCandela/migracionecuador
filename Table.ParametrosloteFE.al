table 86002 "Parametros lote FE"
{

    fields
    {
        field(10; "Tipo comprobante"; Option)
        {
            OptionCaption = ' ,Factura,NotaCredito,RemisionVta,RemisionTrans,RetencionFac,RetencionNC';
            OptionMembers = " ",Factura,NotaCredito,RemisionVta,RemisionTrans,RetencionFac,RetencionNC;
        }
        field(20; "No. comprobante"; Code[20])
        {
        }
        field(30; Accion; Option)
        {
            OptionCaption = 'Enviar,Autorizar';
            OptionMembers = Enviar,Autorizar;
        }
        field(40; "Tipo comprobante Manual"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-6369';
            OptionCaption = ' ,Factura Venta,Nota Credito,Remision Venta,Remision Transferencia,Retencion Factura,Retencion Nota Credito';
            OptionMembers = " ","Factura Venta","Nota Credito","Remision Venta","Remision Transferencia","Retencion Factura","Retencion Nota Credito";
        }
    }

    keys
    {
        key(Key1; "Tipo comprobante", "No. comprobante")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

