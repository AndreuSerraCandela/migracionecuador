table 76089 "NCF Anulados"
{
    Caption = 'VOID NCF';
    DrillDownPageID = "Archivo Transf. ITBIS 607";
    LookupPageID = "Archivo Transf. ITBIS 607";

    fields
    {
        field(1; "No. documento"; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "No. Serie NCF Facturas"; Code[10])
        {
            Caption = 'Invoice FDN Serial No.';
            TableRelation = "No. Series";
        }
        field(3; "No. Comprobante Fiscal"; Code[19])
        {
            Caption = 'Fiscal Document No.';
        }
        field(6; "No. Serie NCF Abonos"; Code[10])
        {
            Caption = 'Credit Memo NCF Serial No.';
            TableRelation = "No. Series";
        }
        field(7; "Fecha anulacion"; Date)
        {
            Caption = 'Void date';
        }
        field(8; "Tipo Documento"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Sales Shippment,Transfer Shippment,Retention';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Remision Ventas","Remision Transferencia",Retencion;
        }
        field(55001; "No. Autorizacion"; Code[49])
        {
            Caption = 'Aut. No.';
        }
        field(55002; "Punto Emision"; Code[3])
        {
        }
        field(55003; Establecimiento; Code[3])
        {
        }
        field(55004; "Fecha Caducidad"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "No. documento", "No. Comprobante Fiscal")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Err001: Label 'The percent total is higher than 100%';
}

