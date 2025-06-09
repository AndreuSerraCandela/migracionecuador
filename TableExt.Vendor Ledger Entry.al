tableextension 50036 tableextension50036 extends "Vendor Ledger Entry"
{
    fields
    {
        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        modify("Closed by Entry No.")
        {
            Caption = 'Closed by Entry No.';
        }
        modify("Closed by Amount (LCY)")
        {
            Caption = 'Closed by Amount ($)';
        }
        modify("Remaining Pmt. Disc. Possible")
        {
            Caption = 'Remaining Pmt. Disc. Possible';
        }
        modify("Reversed by Entry No.")
        {
            Caption = 'Reversed by Entry No.';
        }
        modify("Applies-to Ext. Doc. No.")
        {
            Caption = 'Applies-to Ext. Doc. No.';
        }
        field(55005; "RUC/Cedula"; Code[30])
        {
            Caption = 'Vat Reg. Number';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55006; "Tipo de Comprobante"; Code[2])
        {
            Caption = 'NCF Type';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            TableRelation = "SRI - Tabla Parametros".Code WHERE ("Tipo Registro" = FILTER ("TIPOS COMPROBANTES AUTORIZADOS"));
        }
        field(55007; "Sustento del Comprobante"; Code[2])
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            TableRelation = "SRI - Tabla Parametros".Code WHERE ("Tipo Registro" = FILTER ("SUSTENTO DEL COMPROBANTE"));
        }
        field(55008; "No. Autorizacion Comprobante"; Code[40])
        {
            Caption = 'Authorization Voucher No.';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';

            trigger OnValidate()
            begin
                /*
                IF AutSRIProv.GET("Buy-from Vendor No.","No. Autorizacion Comprobante") THEN
                  BEGIN
                    IF "Posting Date" >= AutSRIProv."Fecha Caducidad" THEN
                      ERROR(Error002,FIELDCAPTION("Posting Date"),AutSRIProv."Fecha Caducidad",AutSRIProv.FIELDCAPTION("No. Autorizacion"),
                           AutSRIProv."No. Autorizacion");
                    AutSRIProv.TESTFIELD("Fecha Autorizacion");
                    AutSRIProv.TESTFIELD(Establecimiento);
                    AutSRIProv.TESTFIELD("Punto de Emision");
                    AutSRIProv.TESTFIELD("Tipo Comprobante");
                    Establecimiento := AutSRIProv.Establecimiento;
                    "Fecha Caducidad" := AutSRIProv."Fecha Caducidad";
                    "Punto de Emision" := AutSRIProv."Punto de Emision";
                  END;
                */

            end;
        }
        field(55009; Establecimiento; Code[3])
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55010; "Punto de Emision"; Code[3])
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55011; "Fecha Caducidad"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55012; "Cod. Retencion"; Code[10])
        {
            Caption = 'Retention Code';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            TableRelation = "Config. Retencion Proveedores"."Código Retención" WHERE ("Aplica Caja Chica" = FILTER (true));
        }
        field(55013; "Caja Chica"; Boolean)
        {
            Caption = 'Petty Cash';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55015; "Excluir Informe ATS"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ATS';
        }
        field(76041; "No. Comprobante Fiscal"; Code[30])
        {
            Caption = 'Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
        }
    }
}

