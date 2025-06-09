tableextension 50016 tableextension50016 extends "Purch. Cr. Memo Hdr."
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
        modify("Vendor Cr. Memo No.")
        {
            Caption = 'Vendor Cr. Memo No.';
        }

        //Unsupported feature: Property Modification (Data type) on ""VAT Registration No."(Field 70)".

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
        modify("Vendor Ledger Entry No.")
        {
            Caption = 'Vendor Ledger Entry No.';
        }
        // modify("Fiscal Invoice Number PAC")
        // {
        //     Caption = 'Fiscal Invoice Number PAC';
        // }
        field(55000; "Sustento del Comprobante"; Code[10])
        {
            Caption = 'Voucher Sustentation';
            DataClassification = ToBeClassified;
            Description = 'SRI';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("SUSTENTO DEL COMPROBANTE"));
        }
        field(55001; "Tipo de Comprobante"; Code[10])
        {
            Caption = 'Voucher Type';
            DataClassification = ToBeClassified;
            Description = 'SRI';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("TIPOS COMPROBANTES AUTORIZADOS"));
        }
        field(55002; "No. Autorizacion Comprobante"; Code[49])
        {
            Caption = 'Authorization Voucher No.';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55003; Establecimiento; Code[3])
        {
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55004; "Fecha Caducidad"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55005; "Punto de Emision"; Code[3])
        {
            DataClassification = ToBeClassified;
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
        field(55025; "No. Serie NCF Retencion"; Code[10])
        {
            Caption = 'Nº Serie NCF Retención';
            DataClassification = ToBeClassified;
            Description = 'CompElec';
            TableRelation = "No. Series";

            trigger OnValidate()
            var
                recLinSerie: Record "No. Series Line";
                cduNoSeriesMgt: Codeunit "No. Series";
            begin
            end;
        }
        field(55026; "Establecimiento NCF Retencion"; Code[3])
        {
            DataClassification = ToBeClassified;
            Description = 'CompElec';
        }
        field(55027; "Puno emision NCF Retencion"; Code[3])
        {
            DataClassification = ToBeClassified;
            Description = 'CompElec';
        }
        field(55060; "Facturacion electronica Ret."; Boolean)
        {
            CalcFormula = Lookup("No. Series"."Facturacion electronica" WHERE(Code = FIELD("No. Serie NCF Retencion")));
            Caption = 'Facturación electrónica';
            Description = 'CompElec,#35029';
            FieldClass = FlowField;
        }
        field(55061; "Estado envio FE Ret."; Option)
        {
            CalcFormula = Lookup("Documento FE"."Estado envio" WHERE("No. documento" = FIELD("No.")));
            Caption = 'Estado envío FE Retención';
            Description = 'CompElec,#35029';
            FieldClass = FlowField;
            OptionCaption = 'Pendiente,Enviado,Rechazado';
            OptionMembers = Pendiente,Enviado,Rechazado;
        }
        field(55062; "Estado autorizacion FE Ret."; Option)
        {
            CalcFormula = Lookup("Documento FE"."Estado envio" WHERE("No. documento" = FIELD("No.")));
            Caption = 'Estado autorizacion FE Retención';
            Description = 'CompElec,#35029';
            FieldClass = FlowField;
            OptionCaption = 'Pendiente,Autorizado,No autorizado';
            OptionMembers = Pendiente,Autorizado,"No autorizado";
        }
        field(56006; "Cod. Colegio"; Code[20])
        {
            Caption = 'School Code';
            DataClassification = ToBeClassified;
            TableRelation = Contact WHERE(Type = FILTER(Company));
        }
        field(56007; "Nombre Colegio"; Text[60])
        {
            Caption = 'School Name';
            DataClassification = ToBeClassified;
        }
        field(76041; "Tipo Retencion"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
            OptionMembers = "  ",Productos,Servicios;
        }
        field(76079; "No. Comprobante Fiscal"; Code[19])
        {
            Caption = 'Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
        }
        field(76080; "No. Comprobante Fiscal Rel."; Code[19])
        {
            Caption = 'Rel. Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
        }
        field(76056; "Correccion Doc. NCF"; Boolean)
        {
            Caption = 'NCF Doc. Correction';
            DataClassification = ToBeClassified;
        }
        field(76078; "No. Serie NCF Abonos"; Code[10])
        {
            Caption = 'NCF Credit Memo Series No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
        }
        field(76058; "Cod. Clasificacion Gasto"; Code[2])
        {
            Caption = 'Expense Class. Code';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
            TableRelation = "Clasificacion Gastos";
        }
        field(76007; "Aplica Retención"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ATS';
        }
        field(76003; "Fecha vencimiento NCF"; Date)
        {
            Caption = 'NCF Due date';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
            TableRelation = "Tipos de ingresos";
        }
        field(76006; "Tipo de ingreso"; Code[2])
        {
            Caption = 'Income type';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
            TableRelation = "Tipos de ingresos";
        }
        field(76088; "Razon anulacion NCF"; Code[20])
        {
            Caption = 'NCF Void Reason';
            DataClassification = ToBeClassified;
            Description = 'DSLoc3.0';
            TableRelation = "Razones Anulacion NCF";
        }
        field(76091; "Tipo ITBIS"; Option)
        {
            Caption = 'Tipo de ITBIS';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,ITBIS Adelantado,ITBIS al costo,ITBIS sujeto a prop.';
            OptionMembers = " ","ITBIS Adelantado","ITBIS al costo","ITBIS sujeto a prop.";

            trigger OnValidate()
            var
                VATPS: Record "VAT Posting Setup";
            begin
                /*
                ConfCitricola.GET();
                {
                IF ConfCitricola."Sumar ITBIS a Costo compras" THEN
                   EXIT;
                }
                UserSetup.GET(USERID);
                IF UserSetup."Tipo ITBIS" <> 0 THEN
                   BEGIN
                    IF UserSetup."Tipo ITBIS" <> "Tipo ITBIS" THEN
                       ERROR(STRSUBSTNO(Err007,UserSetup."Tipo ITBIS",FIELDCAPTION("Tipo ITBIS")));
                   END;
                
                IF "Tipo ITBIS" = "Tipo ITBIS"::"ITBIS al costo" THEN
                   BEGIN
                    ConfCitricola.GET();
                    ConfCitricola.TESTFIELD("Gpo. cont. ITBIS Prod. a Costo");
                    PurchLine.RESET;
                    PurchLine.SETRANGE("Document Type","Document Type");
                    PurchLine.SETRANGE("Document No.","No.");
                //    PurchLine.SETFILTER(Type,'<>%1&<>%2',PurchLine.Type::" ",PurchLine.Type::"Charge (Item)");
                    PurchLine.SETRANGE(Type,PurchLine.Type::"Fixed Asset");
                    IF PurchLine.FINDSET(TRUE,FALSE) THEN
                       REPEAT
                        IF PurchLine.Type = PurchLine.Type::Item THEN
                           PurchLine.VALIDATE("VAT Prod. Posting Group", ConfCitricola."Gpo. cont. ITBIS Prod. a Costo")
                        ELSE
                           BEGIN
                            VATPS.RESET;
                            VATPS.SETRANGE("VAT Bus. Posting Group","VAT Bus. Posting Group");
                            VATPS.SETRANGE("Purchase VAT Account",PurchLine."No.");
                            VATPS.FINDFIRST;
                            PurchLine.VALIDATE("VAT Prod. Posting Group", VATPS."VAT Prod. Posting Group");
                           END;
                        PurchLine.MODIFY;
                       UNTIL PurchLine.NEXT = 0;
                   END
                ELSE
                IF "Tipo ITBIS" = "Tipo ITBIS"::"ITBIS sujeto a prop." THEN
                   BEGIN
                    ConfCitricola.GET();
                    ConfCitricola.TESTFIELD("Gpo. cont. ITBIS sujeto a prop");
                    PurchLine.RESET;
                    PurchLine.SETRANGE("Document Type","Document Type");
                    PurchLine.SETRANGE("Document No.","No.");
                    PurchLine.SETRANGE(Type,PurchLine.Type::"Fixed Asset");
                    IF PurchLine.FINDSET(TRUE,FALSE) THEN
                       REPEAT
                        PurchLine.VALIDATE("VAT Prod. Posting Group",ConfCitricola."Gpo. cont. ITBIS sujeto a prop");
                        PurchLine.MODIFY;
                       UNTIL PurchLine.NEXT = 0;
                   END
                   */

            end;
        }
        field(76460; Proporcionalidad; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,100% Admitido,% Admitido,0% Admitido,No Aplica';
            OptionMembers = " ","100% Admitido","% Admitido","0% Admitido","No Aplica";
        }
    }
    keys
    {
        key(Key1; "No. Comprobante Fiscal")
        {
        }
    }
}

