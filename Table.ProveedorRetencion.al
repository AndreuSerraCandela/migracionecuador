table 76041 "Proveedor - Retencion"
{
    Caption = 'Vendor - Retention';
    DrillDownPageID = "Proveedor - Retencion";
    LookupPageID = "Proveedor - Retencion";

    fields
    {
        field(1; "Cód. Proveedor"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(2; "Código Retención"; Code[20])
        {
            TableRelation = "Config. Retencion Proveedores";

            trigger OnValidate()
            begin

                MaestroRet.Reset;
                MaestroRet.SetRange("Código Retención", "Código Retención");
                if MaestroRet.Find('-') then begin
                    Vend.Get("Cód. Proveedor");
                    if not TipoContRet.Get("Código Retención", Vend."Tipo Contribuyente") then
                        Error(Error001, Vend.FieldCaption(Vend."Tipo Contribuyente"), Vend."Tipo Contribuyente");

                    //MaestroRet.TESTFIELD("Tipo Contribuyente",Vend."Tipo Contribuyente");
                    "Cta. Contable" := MaestroRet."Cta. Contable";
                    "Base Cálculo" := MaestroRet."Base Cálculo";
                    Devengo := MaestroRet.Devengo;
                    "Importe Retención" := MaestroRet."Importe Retención";
                    "Tipo Retención" := MaestroRet."Tipo Retención";
                    "Aplica Productos" := MaestroRet."Aplica Productos";
                    "Retencion IVA" := MaestroRet."Retencion IVA";
                    "Aplica Servicios" := MaestroRet."Aplica Servicios";
                    "Tipo Contribuyente" := MaestroRet."Tipo Contribuyente";
                end;
            end;
        }
        field(3; "Cta. Contable"; Code[20])
        {
            Editable = false;
            TableRelation = "G/L Account";
        }
        field(4; "Base Cálculo"; Option)
        {
            Editable = false;
            OptionCaption = 'IVA,B. Imponible,Total Fra.,Ninguno';
            OptionMembers = IVA,"B. Imponible","Total Fra.",Ninguno;
        }
        field(5; Devengo; Option)
        {
            Editable = false;
            OptionMembers = "Facturación",Pago;
        }
        field(6; "Importe Retención"; Decimal)
        {
            Editable = false;
        }
        field(7; "Tipo Retención"; Option)
        {
            Editable = false;
            OptionMembers = Porcentaje,Importe;
        }
        field(8; "Aplica Productos"; Boolean)
        {
            Editable = false;
        }
        field(9; "Aplica Servicios"; Boolean)
        {
            Editable = false;
        }
        field(10; "Retencion IVA"; Boolean)
        {
            Caption = 'Retencion IVA';
            Editable = false;
        }
        field(11; "Mayor de"; Decimal)
        {
            Caption = 'Grater Than';
            DataClassification = ToBeClassified;
        }
        field(12; "No. Serie NCF"; Code[20])
        {
            Caption = 'NCF Series No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(17; Redondeo; Option)
        {
            Caption = 'Rounding Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'No one,Up,Down';
            OptionMembers = Ninguno,"Hacia el alza","Hacia la baja";
        }
        field(18; "Tipo Contribuyente"; Code[20])
        {
            Caption = 'Contributor Type';
            DataClassification = ToBeClassified;
            TableRelation = "SRI - Tabla Parametros".Code WHERE ("Tipo Registro" = CONST ("TIPOS AGENTE DE RETENCION"));
        }
        field(55000; "Aplica Caja Chica"; Boolean)
        {
            Caption = 'Apply to Petty Cash';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
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
        key(Key1; "Cód. Proveedor", "Código Retención")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Código Retención", "Tipo Retención", "Base Cálculo", "Importe Retención")
        {
        }
    }

    var
        MaestroRet: Record "Config. Retencion Proveedores";
        Vend: Record Vendor;
        TipoContRet: Record "Tipo Contribuyente - Retencion";
        Error001: Label 'The Retention must apply for %1 %2';
}

