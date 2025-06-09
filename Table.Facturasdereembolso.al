table 55016 "Facturas de reembolso"
{
    // #34829 CAT  Nuevo campo  "Base Exenta IVA"
    // #45384 MOI  Se amplia el tamaño del campo No Documento de 20 a 30 para igualarlo con el campo No Documento de la tabla ATS Compras/Ventas


    fields
    {
        field(1; "Document No."; Code[30])
        {
            Caption = 'Nº Documento';
            Description = '#45384';
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Nº Línea';
            Editable = false;
        }
        field(3; "Tipo ID"; Code[10])
        {
            Editable = true;
        }
        field(4; RUC; Code[20])
        {
        }
        field(5; "Tipo Comprobante"; Code[10])
        {
        }
        field(6; "Establecimiento Comprobante"; Code[10])
        {
        }
        field(7; "Punto Emision Comprobante"; Code[10])
        {
        }
        field(8; "Numero Secuencial Comprobante"; Code[20])
        {
        }
        field(9; "Fecha Comprobante"; Date)
        {
        }
        field(10; "No. Autorización Comprobante"; Code[50])
        {
        }
        field(11; "Base No Objeto IVA"; Decimal)
        {
        }
        field(12; "Base 0"; Decimal)
        {
        }
        field(13; "Base X"; Decimal)
        {
        }
        field(14; "Monto ICE"; Decimal)
        {
        }
        field(15; "Monto IVA"; Decimal)
        {
        }
        field(16; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(17; "Base Exenta IVA"; Decimal)
        {
            Description = '#34829';
        }
        field(18; "Tipo Proveedor Reembolso"; Code[2])
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        rRec: Record "Facturas de reembolso";
    begin
        rRec.SetRange("Document Type", "Document Type");
        rRec.SetRange("Document No.", "Document No.");
        if rRec.FindLast then
            "Line No." := rRec."Line No." + 1
        else
            "Line No." := 1;
    end;
}

