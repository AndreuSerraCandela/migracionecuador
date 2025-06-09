table 76079 "Retencion Doc. Proveedores"
{
    Caption = 'Vendor Document Retention';

    fields
    {
        field(1; "Cód. Proveedor"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(2; "Código Retención"; Code[20])
        {
            TableRelation = "Proveedor - Retencion"."Código Retención" WHERE("Cód. Proveedor" = FIELD("Cód. Proveedor"));

            trigger OnValidate()
            begin

                if ProvRet.Get("Cód. Proveedor", "Código Retención") then begin
                    "Cta. Contable" := ProvRet."Cta. Contable";
                    "Base Cálculo" := ProvRet."Base Cálculo";
                    Devengo := ProvRet.Devengo;
                    "Importe Retención" := ProvRet."Importe Retención";
                    "Tipo Retención" := ProvRet."Tipo Retención";
                end;
            end;
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
        }
        field(11; "Tipo documento"; Enum "Purchase Document Type")
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
            DataClassification = ToBeClassified;
        }
        field(14; "Fecha Registro"; Date)
        {
            DataClassification = ToBeClassified;
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
        field(20; "Importe Base Retencion"; Decimal)
        {
            Caption = 'Base Retention Amount';
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
        key(Key1; "Cód. Proveedor", "Código Retención", "Tipo documento", "No. documento")
        {
            Clustered = true;
        }
        key(Key2; "Cód. Proveedor", "Tipo documento", "No. documento")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //
    end;

    var
        ProvRet: Record "Proveedor - Retencion";
}

