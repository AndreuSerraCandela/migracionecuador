table 55000 "SRI - Tabla Parametros"
{
    Caption = 'SRI - Parameters';
    LookupPageID = "SRI - Tabla Parametros";

    fields
    {
        field(1; "Tipo Registro"; Option)
        {
            Caption = 'Record Type';
            OptionCaption = 'Voucher Sustention,Authorized Vouchers Types,Retention Agent Type';
            OptionMembers = "SUSTENTO DEL COMPROBANTE","TIPOS COMPROBANTES AUTORIZADOS","TIPOS AGENTE DE RETENCION","DIRECCION ESTABLECIMIENTO";
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(3; Description; Text[170])
        {
            Caption = 'Description';
        }
        field(4; "Tipo Documento"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'VAT,ID,Passport';
            OptionMembers = RUC,Cedula,Pasaporte;
        }
        field(5; "Tipo Ruc/Cedula"; Option)
        {
            Caption = 'RUC/ID Type';
            OptionCaption = ' ,R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA,R.U.C. PUBLICOS,RUC PERSONA NATURAL,ID';
            OptionMembers = " ","R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA","R.U.C. PUBLICOS","RUC PERSONA NATURAL",CEDULA;
        }
        field(6; "No Aplica SRI"; Boolean)
        {
            Caption = 'Do not apply to SRI';
        }
        field(7; "Codigo ATS"; Code[10])
        {
            Caption = 'Código ATS';
        }
    }

    keys
    {
        key(Key1; "Tipo Registro", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description, "Tipo Documento", "Tipo Ruc/Cedula")
        {
        }
    }
}

