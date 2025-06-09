tableextension 50048 tableextension50048 extends "Shipping Agent"
{
    fields
    {
        field(56000; "No. Serie Guias"; Code[20])
        {
            Caption = 'Guide Series No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(56001; "ID Reporte Guia"; Integer)
        {
            Caption = 'Guide Report ID';
            DataClassification = ToBeClassified;
            /*          TableRelation = Object.ID WHERE (Type = CONST (Report)); */
        }
        field(56002; "No. Cliente Santillana"; Code[20])
        {
            Caption = 'Santillana Customer No.';
            DataClassification = ToBeClassified;
        }
        field(56003; Address; Text[100])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(56004; "VAT Registration No."; Text[30])
        {
            Caption = 'VAT Registration No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                //VATRegNoFormat.Test("VAT Registration No.","Country/Region Code","No.",DATABASE::Customer);
            end;
        }
        field(56005; Placa; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'CompElec';
        }
        field(56006; "Tipo id."; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,RUC,Cédula,Pasaporte';
            OptionMembers = " ",RUC,Cedula,Pasaporte;
        }
    }
}

