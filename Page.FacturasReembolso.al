page 55020 "Facturas Reembolso"
{
    ApplicationArea = all;

    PageType = List;
    SourceTable = "Facturas de reembolso";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; rec."Line No.")
                {
                }
                field("Tipo ID"; rec."Tipo ID")
                {
                }
                field(RUC; rec.RUC)
                {
                }
                field("Tipo Comprobante"; rec."Tipo Comprobante")
                {
                }
                field("Establecimiento Comprobante"; rec."Establecimiento Comprobante")
                {
                }
                field("Punto Emision Comprobante"; rec."Punto Emision Comprobante")
                {
                }
                field("Numero Secuencial Comprobante"; rec."Numero Secuencial Comprobante")
                {
                }
                field("Fecha Comprobante"; rec."Fecha Comprobante")
                {
                }
                field("No. Autorización Comprobante"; rec."No. Autorización Comprobante")
                {
                }
                field("Base No Objeto IVA"; rec."Base No Objeto IVA")
                {
                }
                field("Base Exenta IVA"; rec."Base Exenta IVA")
                {
                }
                field("Base 0"; rec."Base 0")
                {
                }
                field("Base X"; rec."Base X")
                {
                }
                field("Monto ICE"; rec."Monto ICE")
                {
                }
                field("Monto IVA"; rec."Monto IVA")
                {
                }
                field("Document No."; rec."Document No.")
                {
                }
                field("Tipo Proveedor Reembolso"; rec."Tipo Proveedor Reembolso")
                {
                }
            }
        }
    }

    actions
    {
    }
}

