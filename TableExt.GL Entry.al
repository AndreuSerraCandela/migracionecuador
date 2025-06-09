tableextension 50022 tableextension50022 extends "G/L Entry"
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
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
        modify("VAT Prod. Posting Group")
        {
            Caption = 'VAT Prod. Posting Group';
        }
        modify("Reversed by Entry No.")
        {
            Caption = 'Reversed by Entry No.';
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
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("TIPOS COMPROBANTES AUTORIZADOS"));
        }
        field(55007; "Sustento del Comprobante"; Code[2])
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("SUSTENTO DEL COMPROBANTE"));
        }
        field(55008; "No. Autorizacion Comprobante"; Code[49])
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
            TableRelation = "Config. Retencion Proveedores"."Código Retención" WHERE("Aplica Caja Chica" = FILTER(true));
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
        field(55017; "Tipo de Identificador"; Option)
        {
            DataClassification = ToBeClassified;
            Description = '#43088';
            OptionCaption = ' ,RUC,Cedula,Pasaporte';
            OptionMembers = " ",RUC,Cedula,Pasaporte;
        }
        field(55018; "Pago a"; Option)
        {
            DataClassification = ToBeClassified;
            Description = '#43088';
            OptionCaption = ' ,Residente,No Residente';
            OptionMembers = " ",Residente,"No Residente";
        }
        field(55500; "No. Cuenta Original"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Campo temporal para proceso Reconstrucción del crédito tributario por IVA. ver email Javier del 19 de marzo 2013 Santillana Ecuador';
        }
        field(56000; "ID Retencion"; Code[20])
        {
            Caption = 'ID Retencion';
            DataClassification = ToBeClassified;
        }
        field(56015; Beneficiario; Text[150])
        {
            Caption = 'Beneficiary';
            DataClassification = ToBeClassified;
        }
        field(56045; "No. Mov. cliente provisionado"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = '#144';
            Editable = false;
        }
        field(76014; "Cod. Colegio"; Code[20])
        {
            Caption = 'School Code';
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = Contact WHERE(Type = FILTER(Company));
        }
        field(76422; "Cod. Vendedor"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = "Salesperson/Purchaser";
        }
        field(76041; "No. Comprobante Fiscal"; Code[30])
        {
            Caption = 'Fiscal Document No.';
            DataClassification = ToBeClassified;
        }
        field(76058; "Cod. Clasificacion Gasto"; Code[2])
        {
            Caption = 'Expense Class. Code';
            DataClassification = ToBeClassified;
            TableRelation = "Clasificacion Gastos";
        }
        field(76007; RNC; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(76006; "Fecha vencimiento NCF"; Date)
        {
            Caption = 'NCF Due date';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
        }
        field(76088; "Tipo de ingreso"; Code[2])
        {
            Caption = 'Income type';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
            InitValue = '02';
            TableRelation = "Tipos de ingresos";
        }
    }
    keys
    {

        key(Key17; "No. Mov. cliente provisionado")
        {
        }

    }


    //Unsupported feature: Code Modification on "CopyFromGenJnlLine(PROCEDURE 4)".
    //[EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)] llevarlo a un Codeunit
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        //+#43088
        GLEntry."Tipo de Identificador" := GenJournalLine."Tipo de Identificador";
        GLEntry."Pago a" := GenJournalLine."Pago a";
        //-#43088
    end;
}

