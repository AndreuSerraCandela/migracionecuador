table 76058 "Retencion Doc. Reg. Prov."
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
            TableRelation = "Proveedor - Retencion"."Código Retención" WHERE ("Cód. Proveedor" = FIELD ("Cód. Proveedor"));

            trigger OnValidate()
            begin
                if ConfRet.Get("Código Retención") then begin
                    Validate("Cta. Contable", ConfRet."Cta. Contable");
                    Validate("Base Cálculo", ConfRet."Base Cálculo");
                    Validate(Devengo, ConfRet.Devengo);
                    Validate("Importe Retención", ConfRet."Importe Retención");
                    Validate("Tipo Retención", ConfRet."Tipo Retención");
                    Validate("Aplica Productos", ConfRet."Aplica Productos");
                    Validate("Aplica Servicios", ConfRet."Aplica Servicios");
                    Validate("Retencion ITBIS", ConfRet."Retencion IVA");
                    Validate(Redondeo, ConfRet.Redondeo);
                end
                else
                    ClearAll;
            end;
        }
        field(3; "Cta. Contable"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(4; "Base Cálculo"; Option)
        {
            OptionMembers = ITBIS,"B. Imponible","Total Fra.",Ninguno;
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
        field(10; "Retencion ITBIS"; Boolean)
        {
        }
        field(11; "Tipo documento"; Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
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
        }
        field(15; NCF; Code[20])
        {
        }
        field(16; "No. Documento Mov. Proveedor"; Code[20])
        {
            Caption = 'Vendor ledger entry no.';
        }
        field(17; Redondeo; Option)
        {
            Caption = 'Rounding Type';
            OptionCaption = 'No one,Up,Down';
            OptionMembers = Ninguno,"Hacia el alza","Hacia la baja";
        }
        field(20; "Importe Base Retencion"; Decimal)
        {
            Caption = 'Base Retention Amount';
        }
        field(22; "Fecha Impresion"; Date)
        {
            Caption = 'Printed Date';
        }
        field(23; "No. autorizacion NCF"; Code[49])
        {
            Caption = 'NCF Authorization No.';
        }
        field(25; "Punto Emision"; Code[3])
        {
        }
        field(26; Establecimiento; Code[3])
        {
        }
        field(55001; "Nombre Proveedor"; Text[100])
        {
            CalcFormula = Lookup (Vendor.Name WHERE ("No." = FIELD ("Cód. Proveedor")));
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

    var
        ConfRet: Record "Config. Retencion Proveedores";
}

