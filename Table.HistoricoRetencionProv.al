table 76080 "Historico Retencion Prov."
{
    Caption = 'Posted Vendor Rentention';
    DrillDownPageID = "Historico Retencion Prov.";
    LookupPageID = "Historico Retencion Prov.";

    fields
    {
        field(1; "Cód. Proveedor"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(2; "Código Retención"; Code[20])
        {
            TableRelation = "Config. Retencion Proveedores";
        }
        field(3; "Cta. Contable"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(4; "Base Cálculo"; Option)
        {
            OptionCaption = 'IVA,B. Imponible,Total Fra.,Ninguno';
            OptionMembers = IVA,"B. Imponible","Total Fra.",Ninguno;
        }
        field(5; Devengo; Option)
        {
            OptionMembers = "Facturación",Pago;
        }
        field(6; "Importe Retención"; Decimal)
        {
        }
        field(7; "Tipo Retención"; Option)
        {
            OptionMembers = Porcentaje,Importe;
        }
        field(8; "Aplica Productos"; Boolean)
        {
        }
        field(9; "Aplica Servicios"; Boolean)
        {
        }
        field(10; "Retencion IVA"; Boolean)
        {
            CalcFormula = Exist("Config. Retencion Proveedores" WHERE("Código Retención" = FIELD("Código Retención"),
                                                                       "Retencion IVA" = FILTER(true)));
            FieldClass = FlowField;
        }
        field(11; "Tipo documento"; Enum "Sales Document Type") //"Gen. Journal Document Type") // "Sales Document Type"
        {
            //OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            //OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(12; "No. documento"; Code[20])
        {
        }
        field(13; "Importe Retenido"; Decimal)
        {
            Caption = 'Retained Amount';
        }
        field(14; "Fecha Registro"; Date)
        {
            CalcFormula = Lookup("Vendor Ledger Entry"."Posting Date" WHERE("Document Type" = FIELD("Tipo documento"),
                                                                             "Document No." = FIELD("No. documento")));
            Caption = 'Posting date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; NCF; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "No. Documento Mov. Proveedor"; Code[20])
        {
            Caption = 'Vendor ledger entry no.';
            DataClassification = ToBeClassified;
        }
        field(17; Redondeo; Option)
        {
            Caption = 'Rounding Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'No one,Up,Down';
            OptionMembers = Ninguno,"Hacia el alza","Hacia la baja";
        }
        field(18; "Cod. Divisa"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(19; "Importe Retenido DL"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Importe Base Retencion"; Decimal)
        {
            Caption = 'Base Retention Amount';
            DataClassification = ToBeClassified;
        }
        field(21; Anulada; Boolean)
        {
            Caption = 'Voided';
            DataClassification = ToBeClassified;
        }
        field(22; "Fecha Impresion"; Date)
        {
            Caption = 'Printed Date';
            DataClassification = ToBeClassified;
        }
        field(23; "No. autorizacion NCF"; Code[49])
        {
            Caption = 'NCF Authorization No.';
            DataClassification = ToBeClassified;
        }
        field(25; "Punto Emision"; Code[3])
        {
            DataClassification = ToBeClassified;
        }
        field(26; Establecimiento; Code[3])
        {
            DataClassification = ToBeClassified;
        }
        field(27; ImporteDivisaLocal; Decimal)
        {
            CalcFormula = - Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("Cta. Contable"),
                                                         "Posting Date" = FIELD("Fecha Registro"),
                                                         "Document Type" = CONST(Payment),
                                                         "Document No." = FIELD("No. documento")));
            Caption = 'Local Currency Amount ';
            FieldClass = FlowField;
        }
        field(28; ImporteDivisaAdicional; Decimal)
        {
            CalcFormula = - Sum("G/L Entry"."Additional-Currency Amount" WHERE("G/L Account No." = FIELD("Cta. Contable"),
                                                                               "Posting Date" = FIELD("Fecha Registro"),
                                                                               "Document Type" = CONST(Payment),
                                                                               "Document No." = FIELD("No. documento")));
            Caption = 'Additional Currency Amount';
            FieldClass = FlowField;
        }
        field(30; "No. serie NCF"; Code[10])
        {
            Caption = 'Nº serie NCF';
            DataClassification = ToBeClassified;
            Description = '$001';
            TableRelation = "No. Series";
        }
        field(40; "Facturacion electronica"; Boolean)
        {
            CalcFormula = Lookup("No. Series"."Facturacion electronica" WHERE(Code = FIELD("No. serie NCF")));
            Caption = 'Facturación electrónica';
            Description = '$001';
            FieldClass = FlowField;
        }
        field(55000; "Aplica Caja Chica"; Boolean)
        {
            Caption = 'Apply to Petty Cash';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55001; "Nombre Proveedor"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Cód. Proveedor")));
            Caption = 'Vendor Name';
            Description = 'Ecuador';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Tipo documento", "No. documento", "Código Retención")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

