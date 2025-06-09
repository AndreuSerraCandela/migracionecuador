table 76042 "Config. Retencion Proveedores"
{
    Caption = 'Setup Vendor Retention';
    DrillDownPageID = "Config. Retencion Proveedores";
    LookupPageID = "Config. Retencion Proveedores";

    fields
    {
        field(1; "Código Retención"; Code[20])
        {
            Caption = 'Retention Code';
            NotBlank = true;
        }
        field(2; "Descripción"; Text[150])
        {
            Caption = 'Description';
        }
        field(3; "Cta. Contable"; Code[20])
        {
            Caption = 'G/L Account';
            TableRelation = "G/L Account";
        }
        field(4; "Base Cálculo"; Option)
        {
            Caption = 'Base';
            OptionCaption = 'IVA,B. Imponible,Total Fra.,Ninguno';
            OptionMembers = IVA,"B. Imponible","Total Fra.",Ninguno;
        }
        field(5; Devengo; Option)
        {
            Caption = 'Accrual';
            OptionMembers = "Facturación",Pago;
        }
        field(6; "Importe Retención"; Decimal)
        {
            Caption = 'Retention Amount';
        }
        field(7; "Tipo Retención"; Option)
        {
            Caption = 'Retention Type';
            OptionMembers = Porcentaje,Importe;
        }
        field(8; "Aplica Productos"; Boolean)
        {
            Caption = 'Apply Items';
        }
        field(9; "Aplica Servicios"; Boolean)
        {
            Caption = 'Apply Service';
        }
        field(10; "Retencion IVA"; Boolean)
        {
            Caption = 'IVA Retention';
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
            TableRelation = "SRI - Tabla Parametros".Code WHERE ("Tipo Registro" = FILTER ("TIPOS AGENTE DE RETENCION"));
        }
        field(50200; "Retencion Defecto Sub-Cont."; Boolean)
        {
            Caption = 'Sub-Contract Default Retention';
        }
        field(55000; "Aplica Caja Chica"; Boolean)
        {
            Caption = 'Apply to Petty Cash';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(76042; "Tipo retencion ISR"; Option)
        {
            OptionCaption = ' ,01 - ALQUILERES,02 - HONORARIOS POR SERVICIOS,03 - OTRAS RENTAS,04 - OTRAS RENTAS (Rentas Presuntas),05 - INTERESES PAGADOS A PERSONAS JURIDICAS RESIDENTES,06 - INTERESES PAGADOS A PERSONAS FISICAS RESIDENTES,07 - RETENCION POR PROVEEDORES DEL ESTADO,08 - JUEGOS TELEFONICOS';
            OptionMembers = " ","01 - ALQUILERES","02 - HONORARIOS POR SERVICIOS","03 - OTRAS RENTAS","04 - OTRAS RENTAS (Rentas Presuntas)","05 - INTERESES PAGADOS A PERSONAS JURIDICAS RESIDENTES","06 - INTERESES PAGADOS A PERSONAS FISICAS RESIDENTES","07 - RETENCION POR PROVEEDORES DEL ESTADO","08 - JUEGOS TELEFONICOS";
        }
    }

    keys
    {
        key(Key1; "Código Retención")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Código Retención", "Descripción", "Base Cálculo", "Importe Retención", "Tipo Retención")
        {
        }
    }
}

