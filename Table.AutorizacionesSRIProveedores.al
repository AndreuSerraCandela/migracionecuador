table 55001 "Autorizaciones SRI Proveedores"
{
    // ATS     24/07/2015      CAT           Se añade el campo "Permitir Comprobante Reembolso"

    Caption = 'Vendors SRI Authorizations';
    LookupPageID = "Autorizaciones SRI Proveedores";

    fields
    {
        field(1; "Cod. Proveedor"; Code[20])
        {
            Caption = 'Vendor Code';
        }
        field(2; Tipo; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Pre-Printed,Auto-Printed';
            OptionMembers = "Pre-Impreso","Auto-Impreso";
        }
        field(3; "No. Solicitud"; Code[30])
        {
            Caption = 'Request No.';
        }
        field(4; Emisor; Text[100])
        {
            Caption = 'Issuing';
        }
        field(5; Estado; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Authorized,Requested';
            OptionMembers = Autorizado,Solicitado;
        }
        field(6; "No. Autorizacion"; Code[49])
        {
            Caption = 'Authorization No.';

            trigger OnValidate()
            begin
                if "No. Autorizacion" <> '' then begin
                    if not "Autorizacion interna" then begin
                        ASP.Reset;
                        ASP.SetRange("No. Autorizacion", "No. Autorizacion");
                        ASP.SetRange("Tipo Documento", "Tipo Documento");
                        ASP.SetRange("Proveedor Informal", false);
                        if ASP.FindFirst then
                            if (ASP."Cod. Proveedor" <> "Cod. Proveedor") or (ASP."No. Solicitud" <> "No. Solicitud") then
                                Error(Error001, ASP."No. Solicitud", ASP."Cod. Proveedor");

                        if StrLen("No. Autorizacion") < 10 then
                            Error(Error002, FieldCaption("No. Autorizacion"));
                    end;
                end;
            end;
        }
        field(7; "Fecha Autorizacion"; Date)
        {
            Caption = 'Authorization Date';
        }
        field(8; "Fecha Caducidad"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(9; "Fecha Registro B. D."; Date)
        {
            Caption = 'DB Posting Date';
        }
        field(10; "Tipo Autorizacion"; Option)
        {
            Caption = 'Authorization Type';
            OptionCaption = 'Temporary,Final';
            OptionMembers = Temporal,Definitiva;
        }
        field(11; Establecimiento; Code[3])
        {
            Caption = 'Location';
            NotBlank = true;
        }
        field(12; "Punto de Emision"; Code[3])
        {
            Caption = 'Issue Point';
            NotBlank = true;
        }
        field(13; "Tipo Comprobante"; Code[10])
        {
            Caption = 'Voucher Type';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("TIPOS COMPROBANTES AUTORIZADOS"));
        }
        field(14; "Rango Inicio"; Code[40])
        {
            Caption = 'From No.';
        }
        field(15; "Rango Fin"; Code[40])
        {
            Caption = 'Rango Fin';
        }
        field(16; "Tipo Documento"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Invoice,Credit Memo';
            OptionMembers = Factura,"Nota de Credito";
        }
        field(17; "Proveedor Informal"; Boolean)
        {
        }
        field(18; Electronica; Boolean)
        {
            Caption = 'Electronic';
        }
        field(20; "Autorizacion interna"; Boolean)
        {
        }
        field(21; "Permitir Comprobante Reembolso"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Proveedor", "No. Autorizacion", Establecimiento, "Punto de Emision", "Tipo Documento")
        {
            Clustered = true;
        }
        key(Key2; "Cod. Proveedor", "Tipo Comprobante", "Fecha Caducidad", Estado, "Punto de Emision", Establecimiento, "No. Autorizacion", "Tipo Documento")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No. Autorizacion", "Fecha Caducidad", Establecimiento, "Punto de Emision", "Rango Inicio", "Rango Fin")
        {
        }
    }

    var
        Error001: Label 'The Request  %1, for Vendor %2,  already has this Auth. Number';
        ASP: Record "Autorizaciones SRI Proveedores";
        Error002: Label '%1 Cannot be less than 10 characters';
}

