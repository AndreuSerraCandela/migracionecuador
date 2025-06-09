tableextension 50012 tableextension50012 extends "Purch. Rcpt. Header"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Pay-to Name 2"(Field 6)".


        //Unsupported feature: Property Modification (Data type) on ""Pay-to Address 2"(Field 8)".


        //Unsupported feature: Property Modification (Data type) on ""Pay-to City"(Field 9)".


        //Unsupported feature: Property Modification (Data type) on ""Ship-to Name 2"(Field 14)".


        //Unsupported feature: Property Modification (Data type) on ""Ship-to Address 2"(Field 16)".


        //Unsupported feature: Property Modification (Data type) on ""Ship-to City"(Field 17)".

        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }

        //Unsupported feature: Property Modification (Data type) on ""Buy-from Vendor Name 2"(Field 80)".


        //Unsupported feature: Property Modification (Data type) on ""Buy-from Address 2"(Field 82)".


        //Unsupported feature: Property Modification (Data type) on ""Buy-from City"(Field 83)".

        modify("Area")
        {
            Caption = 'Area';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
        field(55000; "Sustento del Comprobante"; Code[10])
        {
            Caption = 'Voucher Sustentation';
            DataClassification = ToBeClassified;
            Description = 'SRI';
            TableRelation = "SRI - Tabla Parametros".Code WHERE ("Tipo Registro" = FILTER ("SUSTENTO DEL COMPROBANTE"));
        }
        field(55001; "Tipo de Comprobante"; Code[10])
        {
            Caption = 'Voucher Type';
            DataClassification = ToBeClassified;
            Description = 'SRI';
            TableRelation = "SRI - Tabla Parametros".Code WHERE ("Tipo Registro" = FILTER ("TIPOS COMPROBANTES AUTORIZADOS"));
        }
        field(55002; "No. Autorizacion Comprobante"; Code[49])
        {
            Caption = 'Authorization Voucher No.';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55006; "Desc. Tipo de Comprobante"; Text[50])
        {
            Caption = 'Voucher Type Description';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55007; "Desc. Sustento Comprobante"; Text[50])
        {
            Caption = 'Voucher Support Description';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55008; "Base Retencion Indefinida"; Decimal)
        {
            Caption = 'Retention Base not defined';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55009; "Punto de Emision Fact. Rel."; Code[3])
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55010; "Establecimiento Fact. Rel"; Code[3])
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55011; "No. Autorizacion Fact. Rel."; Code[49])
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador #118543';
        }
        field(55012; "Tipo de Comprobante Fact. Rel."; Code[2])
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55023; "No. Validar Comprobante Rel."; Boolean)
        {
            Caption = 'Not validate Rel. Fiscal Document ';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
    }
}

