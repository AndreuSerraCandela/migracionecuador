tableextension 50165 tableextension50165 extends "Gen. Journal Line"
{
    fields
    {
        /*modify("Account Type") se modifico el enum directamente
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee,,,Provisión Insolvencias,Cancelar Prov. Insol.';

            //Unsupported feature: Property Modification (OptionString) on ""Account Type"(Field 3)".

        }*/
        modify("Account No.")
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer WHERE(Inactivo = CONST(false))
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor WHERE(Inactivo = CONST(false))
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset" WHERE(Inactive = CONST(false))
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Account Type" = CONST(Employee)) Employee;
            Description = '007';
        }

        //Unsupported feature: Property Modification (Data type) on "Description(Field 8)".

        modify("Bal. Account No.")
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                               Blocked = CONST(false))
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer WHERE(Inactivo = CONST(false))
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor WHERE(Inactivo = CONST(false))
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset" WHERE(Inactive = CONST(false))
            ELSE
            IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Bal. Account Type" = CONST(Employee)) Employee;
            Description = '007';
        }
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
        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("Bal. Gen. Posting Type")
        {
            Caption = 'Bal. Gen. Posting Type';
        }
        modify("Bal. Gen. Bus. Posting Group")
        {
            Caption = 'Bal. Gen. Bus. Posting Group';
        }
        modify("Bal. Gen. Prod. Posting Group")
        {
            Caption = 'Bal. Gen. Prod. Posting Group';
        }
        modify("Bal. VAT Calculation Type")
        {
            Caption = 'Bal. VAT Calculation Type';
        }
        modify("Bal. VAT Base Amount")
        {
            Caption = 'Bal. Tax Base Amount';
        }
        modify("Bal. Tax Area Code")
        {
            Caption = 'Bal. Tax Area Code';
        }
        modify("Bal. Tax Group Code")
        {
            Caption = 'Bal. Tax Group Code';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
        modify("VAT Prod. Posting Group")
        {
            Caption = 'VAT Prod. Posting Group';
        }
        modify("Bal. VAT Bus. Posting Group")
        {
            Caption = 'Bal. VAT Bus. Posting Group';
        }
        modify("Bal. VAT Prod. Posting Group")
        {
            Caption = 'Bal. VAT Prod. Posting Group';
        }
        modify("Source Curr. VAT Base Amount")
        {
            Caption = 'Source Curr. Tax Base Amount';
        }
        modify("Source Curr. VAT Amount")
        {
            Caption = 'Source Curr. Tax Amount';
        }
        modify("VAT Base Amount (LCY)")
        {
            Caption = 'Tax Base Amount ($)';
        }
        modify("Bal. VAT Amount (LCY)")
        {
            Caption = 'Bal. Tax Amount ($)';
        }
        modify("Bal. VAT Base Amount (LCY)")
        {
            Caption = 'Bal. Tax Base Amount ($)';
        }
        modify("IC Account No.")//modify("IC Partner G/L Acc. No.")
        {
            Caption = 'IC Partner G/L Acc. No.';
        }
        modify("IC Partner Transaction No.")
        {
            Caption = 'IC Partner Transaction No.';
        }
        modify("Copy VAT Setup to Jnl. Lines")
        {
            Caption = 'Copy Tax Setup to Jnl. Lines';
        }
        modify("Applies-to Ext. Doc. No.")
        {
            Caption = 'Applies-to Ext. Doc. No.';
        }
        modify("Job Unit Price (LCY)")
        {
            Caption = 'Job Unit Price ($)';
        }
        modify("Job Total Price (LCY)")
        {
            Caption = 'Job Total Price ($)';
        }
        modify("Job Line Disc. Amount (LCY)")
        {
            Caption = 'Job Line Disc. Amount ($)';
        }
        modify("Job Line Discount Amount")
        {
            Caption = 'Job Line Discount Amount';
        }
        modify("Job Line Amount (LCY)")
        {
            Caption = 'Job Line Amount ($)';
        }
        modify("Job Planning Line No.")
        {
            Caption = 'Job Planning Line No.';
        }
        modify("Direct Debit Mandate ID")
        {
            Caption = 'Direct Debit Mandate ID';
        }
        modify("No. of Depreciation Days")
        {
            Caption = 'No. of Depreciation Days';
        }
        modify("Depr. until FA Posting Date")
        {
            Caption = 'Depr. until FA Posting Date';
        }
        modify("Duplicate in Depreciation Book")
        {
            Caption = 'Duplicate in Depreciation Book';
        }
        modify("FA Error Entry No.")
        {
            Caption = 'FA Error Entry No.';
        }

        //Unsupported feature: Property Modification (Editable) on ""Export File Name"(Field 10006)".

        // modify("Gateway Operator OFAC Scr.Inc")
        // {
        //     Caption = 'Gateway Operator OFAC Scr.Inc';
        // }
        // modify("Origin. DFI ID Qualifier")
        // {
        //     Caption = 'Origin. DFI ID Qualifier';
        // }
        // modify("Receiv. DFI ID Qualifier")
        // {
        //     Caption = 'Receiv. DFI ID Qualifier';
        // }

        //Unsupported feature: Code Modification on ""Account Type"(Field 3).OnValidate".
        modify("Account Type")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
            begin
                //+#144
                if (("Account Type" = "Account Type"::"Provisión Insolvencias") or
                   ("Account Type" = "Account Type"::"Cancelar Prov. Insol.")) and
                   ("Bal. Account Type" = "Bal. Account Type"::Customer) then
                    Error(Error006, Format("Account Type"));
                //-#144
                //CGA
                "Account Type Modified" := "Account Type";
            end;
        }

        //Unsupported feature: Code Modification on "Amount(Field 13).OnValidate".
        //Se agrego la validacion por el numero de campo desde donde se llama el metodo
        //trigger OnValidate()
        //ValidateAmount(true);

        //Unsupported feature: Deletion (FieldCollection) on ""Pending Approval"(Field 28)".

        //Unsupported feature: Code Modification on ""Applies-to Doc. Type"(Field 35).OnValidate".
        modify("Applies-to Doc. Type")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
            begin
                if "Applies-to Doc. Type" <> xRec."Applies-to Doc. Type" then
                    if (("Account Type" = "Account Type"::"Provisión Insolvencias") or
                       ("Account Type" = "Account Type"::"Cancelar Prov. Insol.")) and ("Applies-to Doc. Type" <> "Applies-to Doc. Type"::Invoice)
                    then
                        Error(Error007);
                //-#144
            end;
        }

        //Unsupported feature: Code Insertion on ""Due Date"(Field 38)".
        modify("Due Date")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
            begin
                //002 //Tenía una variable GenJnlLine pero no estaba inicializada por lo que deje Rec
                if "Cheque Posfechado" then begin
                    if "Posting Date" > "Due Date" then
                        Error(Error001);
                end;
                //002
            end;
        }


        //Unsupported feature: Code Modification on ""VAT Amount"(Field 44).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        GenJnlBatch.Get("Journal Template Name","Journal Batch Name");
        GenJnlBatch.TestField("Allow VAT Difference",true);
        if not ("VAT Calculation Type" in
        #4..29
        if Abs("VAT Difference") > Currency."Max. VAT Difference Allowed" then
          Error(Text013,FieldCaption("VAT Difference"),Currency."Max. VAT Difference Allowed");

        "VAT Amount (LCY)" := CalcVATAmountLCY;
        "VAT Base Amount (LCY)" := "Amount (LCY)" - "VAT Amount (LCY)";

        UpdateSalesPurchLCY;
        #37..41

        if "Deferral Code" <> '' then
          Validate("Deferral Code");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..32
        if "Currency Code" = '' then
          "VAT Amount (LCY)" := "VAT Amount"
        else
          "VAT Amount (LCY)" :=
            Round(
              CurrExchRate.ExchangeAmtFCYToLCY(
                "Posting Date","Currency Code",
                "VAT Amount","Currency Factor"));
        #34..44
        */
        //end;


        //Unsupported feature: Code Modification on ""Bal. Account Type"(Field 63).OnValidate".
        modify("Bal. Account Type")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
            begin
                //+#144
                if (("Account Type" = "Account Type"::"Provisión Insolvencias") or
                   ("Account Type" = "Account Type"::"Cancelar Prov. Insol.")) and
                   ("Bal. Account Type" = "Bal. Account Type"::Customer) then
                    Error(Error006, Format("Account Type"));
                //-#144
            end;
        }
        field(50000; "No. Paginas"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Componentes Producto"; Text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Componentes Prod.";
        }
        field(50002; ISBN; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Cod. Procedencia"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Procedencia;
        }
        field(50004; "Cod. Edición"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Edicion;//Table50131; Validar Tabla
        }
        field(50005; Areas; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Area"; //Table50132 Validar Tabla
        }
        field(50006; "Nivel Educativo"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Nivel Educativo";//Table50133; Validar Tabla
        }
        field(50007; Cursos; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Cursos;
        }
        field(50009; "No. Talonario"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "No. Serie Talonario"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; Aprobado; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Fecha Talonario"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Forma de Pago"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";
        }
        field(50014; "No. Recibo a depositar"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "No. Talonario a depositar"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Tipo Ingreso"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Recibo,Deposito;
        }
        field(53000; "Tipo pedido"; Option)
        {
            Caption = 'Order type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Order Type';
            OptionMembers = " ",TPV;
        }
        field(53001; "Importe a liquidar"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(53002; "Venta a credito"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55000; "ID Retencion Venta"; Code[30])
        {
            Caption = 'Sales Retention ID';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55001; "Cheque Posfechado"; Boolean)
        {
            Caption = 'Future Check';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55002; "Cheque Protestado"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55003; Agencia; Code[20])
        {
            Caption = 'Agency';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55004; "Retencion Venta"; Boolean)
        {
            Caption = 'Sales Retention';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55005; "RUC/Cedula"; Code[30])
        {
            Caption = 'Vat Reg. Number';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';

            trigger OnValidate()
            begin
                //004
                TestField("Tipo de Comprobante");
                SRIParam.Reset;
                SRIParam.Get(1, "Tipo de Comprobante");
                if not SRIParam."No Aplica SRI" then
                    FuncEcuador.ValidaDigitosRUCCajaChica("RUC/Cedula");
                //004
            end;
        }
        field(55006; "Tipo de Comprobante"; Code[2])
        {
            Caption = 'NCF Type';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("TIPOS COMPROBANTES AUTORIZADOS"));

            trigger OnValidate()
            begin
                Clear("RUC/Cedula");//004
            end;
        }
        field(55007; "Sustento del Comprobante"; Code[2])
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("SUSTENTO DEL COMPROBANTE"));
        }
        field(55008; "No. Autorizacion Comprobante"; Code[37])
        {
            Caption = 'Authorization Voucher No.';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';

            trigger OnValidate()
            begin
                //004
                //IF STRLEN("No. Autorizacion Comprobante") <> 10 THEN                       //$005
                //  ERROR(Error002,FIELDCAPTION("No. Autorizacion Comprobante"));            //
                //004
            end;
        }
        field(55009; Establecimiento; Code[3])
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';

            trigger OnValidate()
            begin
                if StrLen(Establecimiento) <> 3 then
                    Error(Error003, FieldCaption(Establecimiento));
            end;
        }
        field(55010; "Punto de Emision"; Code[3])
        {
            Caption = 'Issue date';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';

            trigger OnValidate()
            begin
                if StrLen("Punto de Emision") <> 3 then
                    Error(Error003, FieldCaption("Punto de Emision"));
            end;
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
        field(55014; "No. serie NCF"; Code[10])
        {
            Caption = 'Nº serie NCF';
            DataClassification = ToBeClassified;
            Description = '$006';
            TableRelation = "No. Series";
        }
        field(55015; "Excluir Informe ATS"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ATS';
        }
        field(55016; "Tipo Retención"; Option)
        {
            DataClassification = ToBeClassified;
            Description = '#34822';
            OptionCaption = ' ,Renta,IVA';
            OptionMembers = " ",Renta,IVA;

            trigger OnValidate()
            var
                ConfSant: Record "Config. Empresa";
                Error001: Label 'Sólo se permite ingresar este campo en las secciones definidas como retención ventas.';
                GJB: Record "Gen. Journal Batch";
            begin


                //+#34822

                if "Tipo Retención" <> "Tipo Retención"::" " then begin
                    GJB.Get("Journal Template Name", "Journal Batch Name");
                    GJB.TestField(GJB."Seccion Retencion Venta", true);
                    //IF NOT GJB."Seccion Retencion Venta" THEN
                    //ERROR(Error001);
                end;

                case "Tipo Retención" of
                    "Tipo Retención"::Renta:
                        begin
                            ConfSant.Get;
                            ConfSant.TestField("Cta. Retencion Vta.");
                            Validate("Bal. Account Type", "Bal. Account Type"::"G/L Account");
                            Validate("Bal. Account No.", ConfSant."Cta. Retencion Vta.");
                        end;
                    "Tipo Retención"::IVA:
                        begin
                            ConfSant.Get;
                            ConfSant.TestField("Cta. Retención Vta. IVA");
                            Validate("Bal. Account Type", "Bal. Account Type"::"G/L Account");
                            Validate("Bal. Account No.", ConfSant."Cta. Retención Vta. IVA");
                        end;
                end;

                //-#34822
            end;
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
        field(55019; "Account Type Modified"; enum "Gen. Journal Account Type")
        {
            DataClassification = ToBeClassified;
        }
        field(56000; "Collector Code"; Code[10])
        {
            Caption = 'Collector code';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        field(56022; "Cod. Colegio"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = Contact;
        }
        field(56030; "No. Comprobante Fiscal Rel."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = '#30531';
        }
        field(76041; "Importe Retenido"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AMS - RETENCIONES1.0';
        }
        field(76079; "Retencion ITBIS"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AMS - RETENCIONES1.0';
        }
        field(76080; "No. Comprobante Fiscal"; Code[49])
        {
            DataClassification = ToBeClassified;
        }
        field(76058; "Cod. Clasificacion Gasto"; Code[2])
        {
            DataClassification = ToBeClassified;
        }
        field(76007; Beneficiario; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = '#56924';
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
        /*         key(Key11; "Journal Template Name", "Journal Batch Name", "Posting Date", "Account No.")
                {
                } */
    }

    //Unsupported feature: Code Modification on ""Account No."(Field 4).OnValidate".
    //[EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnValidateAccountNoOnBeforeAssignValue', '', false, false)] llevarlo a un Codeunit
    local procedure OnValidateAccountNoOnBeforeAssignValue(var GenJournalLine: Record "Gen. Journal Line"; var xGenJournalLine: Record "Gen. Journal Line")
    var
        CustPostingGr: Record "Customer Posting Group";
    begin
        if xGenJournalLine."Account Type" in ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"IC Partner",
                              "Account Type"::"Provisión Insolvencias", "Account Type"::"Cancelar Prov. Insol."] then
            "IC Partner Code" := '';

        if GenJournalLine."Account Type" in ["Account Type"::Customer, "Account Type"::"Provisión Insolvencias", "Account Type"::"Cancelar Prov. Insol."] then
            GetCustomerAccount;
    end;

    local procedure GetCustomerAccount()
    var
        Cust: Record Customer;
    begin
        Cust.Get("Account No.");
        Cust.CheckBlockedCustOnJnls(Cust, "Document Type", false);
        CheckICPartner(Cust."IC Partner Code", "Account Type", "Account No.");
        UpdateDescription(Cust.Name);
        "Payment Method Code" := Cust."Payment Method Code";
        Validate("Recipient Bank Account", Cust."Preferred Bank Account Code");
        "Posting Group" := Cust."Customer Posting Group";
        SetSalespersonPurchaserCode(Cust."Salesperson Code", "Salespers./Purch. Code");
        "Payment Terms Code" := Cust."Payment Terms Code";
        Validate("Bill-to/Pay-to No.", "Account No.");
        Validate("Sell-to/Buy-from No.", "Account No.");
        if not SetCurrencyCode("Bal. Account Type", "Bal. Account No.") then
            "Currency Code" := Cust."Currency Code";
        ClearPostingGroups();
        CheckConfirmDifferentCustomerAndBillToCustomer(Cust, "Account No.");
        Validate("Payment Terms Code");
        CheckPaymentTolerance();
    end;

    local procedure SetSalespersonPurchaserCode(SalesperPurchCodeToCheck: Code[20]; var SalesperPuchCodeToAssign: Code[20])
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
    begin
        if SalesperPurchCodeToCheck <> '' then
            if SalespersonPurchaser.Get(SalesperPurchCodeToCheck) then
                if SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) then
                    SalesperPuchCodeToAssign := ''
                else
                    SalesperPuchCodeToAssign := SalesperPurchCodeToCheck;
    end;

    local procedure CheckConfirmDifferentCustomerAndBillToCustomer(Cust: Record Customer; AccountNo: Code[20])
    var
        ConfirmManagement: Codeunit "Confirm Management";
        Text014: Label 'The %1 %2 has a %3 %4.\\Do you still want to use %1 %2 in this journal line?', Comment = '%1=Caption of Table Customer, %2=Customer No, %3=Caption of field Bill-to Customer No, %4=Value of Bill-to customer no.';
    begin
        if (Cust."Bill-to Customer No." <> '') and (Cust."Bill-to Customer No." <> AccountNo) and not HideValidationDialog then
            if not ConfirmManagement.GetResponseOrDefault(
                 StrSubstNo(
                   Text014, Cust.TableCaption(), Cust."No.", Cust.FieldCaption("Bill-to Customer No."),
                   Cust."Bill-to Customer No."), true)
            then
                Error('');
    end;

    //Unsupported feature: Code Modification on ""VAT %"(Field 10).OnValidate".
    //[EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnValidateVATPctOnBeforeUpdateSalesPurchLCY', '', false, false)] llevarlo a un Codeunit
    local procedure OnValidateVATPctOnBeforeUpdateSalesPurchLCY(GenJournalLine: Record "Gen. Journal Line"; Currency: Record Currency)
    var
        NonDeductibleVAT: Codeunit "Non-Deductible VAT";
    begin
        if GenJournalLine."Currency Code" = '' then
            GenJournalLine."VAT Amount (LCY)" := GenJournalLine."VAT Amount"
        else
            GenJournalLine."VAT Amount (LCY)" :=
              Round(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  GenJournalLine."Posting Date", GenJournalLine."Currency Code",
                  GenJournalLine."VAT Amount", GenJournalLine."Currency Factor"));

        "VAT Base Amount (LCY)" := "Amount (LCY)" - "VAT Amount (LCY)";
        NonDeductibleVAT.ValidateNonDedVATPctInGenJnlLine(Rec);
    end;

    //Unsupported feature: Code Modification on ""Applies-to Doc. No."(Field 36).OnLookup".
    //[EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnLookupAppliestoDocNoOnAfterSetJournalLineFieldsFromApplication', '', false, false)] llevarlo a un Codeunit
    local procedure OnLookupAppliestoDocNoOnAfterSetJournalLineFieldsFromApplication(var GenJournalLine: Record "Gen. Journal Line")
    var
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        GenJnlLine: Record "Gen. Journal Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        AccountType: Enum "Gen. Journal Account Type";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        AccountNo: Code[20];
    begin
        //+#144
        GetAccTypeAndNo(GenJournalLine, AccountType, AccountNo);
        if AccountType = AccountType::"Cancelar Prov. Insol." then begin
            CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive, "Due Date");
            CustLedgEntry.SetRange("Customer No.", AccountNo);
            CustLedgEntry.SetRange(Open);
            CustLedgEntry.SetRange(CustLedgEntry."Document Type", CustLedgEntry."Document Type"::Invoice);
            CustLedgEntry.SetFilter("Importe provisionado", '<>%1', 0);
            if "Applies-to Doc. No." <> '' then begin
                CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
                CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                if not CustLedgEntry.Find('-') then begin
                    CustLedgEntry.SetRange("Document Type");
                    CustLedgEntry.SetRange("Document No.");
                end;
            end;
            if "Applies-to ID" <> '' then begin
                CustLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                if not CustLedgEntry.Find('-') then
                    CustLedgEntry.SetRange("Applies-to ID");
            end;
            if "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " then begin
                CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
                if not CustLedgEntry.Find('-') then
                    CustLedgEntry.SetRange("Document Type");
            end;
            if "Applies-to Doc. No." <> '' then begin
                CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                if not CustLedgEntry.Find('-') then
                    CustLedgEntry.SetRange("Document No.");
            end;
            ApplyCustEntries.SetGenJnlLine(Rec, GenJnlLine.FieldNo("Applies-to Doc. No."));
            ApplyCustEntries.SetTableView(CustLedgEntry);
            ApplyCustEntries.SetRecord(CustLedgEntry);
            ApplyCustEntries.LookupMode(true);
            if ApplyCustEntries.RunModal = ACTION::LookupOK then begin
                ApplyCustEntries.GetRecord(CustLedgEntry);
                Clear(ApplyCustEntries);
                Validate("Currency Code");
                CustLedgEntry.CalcFields("Importe provisionado");
                Validate(Amount, CustLedgEntry."Importe provisionado");
                Description := Text021;
                GetDimCustLedgEntry(CustLedgEntry);
                "External Document No." := CustLedgEntry."Document No.";
                "Applies-to Doc. Type" := CustLedgEntry."Document Type";
                "Applies-to Doc. No." := CustLedgEntry."Document No.";
                "Applies-to ID" := '';
            end else begin
                "Applies-to Doc. No." := OldAppliesToDocNo;
                Clear(ApplyCustEntries);
            end;
        end;
        if AccountType = AccountType::"Provisión insolvencias" then begin
            CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive, "Due Date");
            CustLedgEntry.SetRange("Customer No.", AccountNo);
            CustLedgEntry.SetRange(Open, true);
            //+#144
            if AccountType = AccountType::"Provisión insolvencias" then
                CustLedgEntry.SetRange(CustLedgEntry."Document Type", CustLedgEntry."Document Type"::Invoice);
            //-#144
            if "Applies-to Doc. No." <> '' then begin
                CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
                CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                if not CustLedgEntry.Find('-') then begin
                    CustLedgEntry.SetRange("Document Type");
                    CustLedgEntry.SetRange("Document No.");
                end;
            end;
            if "Applies-to ID" <> '' then begin
                CustLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                if not CustLedgEntry.Find('-') then
                    CustLedgEntry.SetRange("Applies-to ID");
            end;
            if "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " then begin
                CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
                if not CustLedgEntry.Find('-') then
                    CustLedgEntry.SetRange("Document Type");
            end;
            if "Applies-to Doc. No." <> '' then begin
                CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                if not CustLedgEntry.Find('-') then
                    CustLedgEntry.SetRange("Document No.");
            end;
            if Amount <> 0 then begin
                CustLedgEntry.SetRange(Positive, Amount < 0);
                if CustLedgEntry.Find('-') then;
                CustLedgEntry.SetRange(Positive);
            end;
            ApplyCustEntries.SetGenJnlLine(Rec, GenJnlLine.FieldNo("Applies-to Doc. No."));
            ApplyCustEntries.SetTableView(CustLedgEntry);
            ApplyCustEntries.SetRecord(CustLedgEntry);
            ApplyCustEntries.LookupMode(true);
            if ApplyCustEntries.RunModal = ACTION::LookupOK then begin
                ApplyCustEntries.GetRecord(CustLedgEntry);
                Clear(ApplyCustEntries);
                if "Currency Code" <> CustLedgEntry."Currency Code" then
                    if Amount = 0 then begin
                        FromCurrencyCode := GetShowCurrencyCode("Currency Code");
                        ToCurrencyCode := GetShowCurrencyCode(CustLedgEntry."Currency Code");
                        if not
                           Confirm(
                             Text003 +
                             Text004, true,
                             FieldCaption("Currency Code"), TableCaption, FromCurrencyCode,
                             ToCurrencyCode)
                        then
                            Error(Text005);
                        Validate("Currency Code", CustLedgEntry."Currency Code");
                    end else
                        GenJnlApply.CheckAgainstApplnCurrency(
                          "Currency Code", CustLedgEntry."Currency Code",
                          GenJnlLine."Account Type"::Customer, true);
                if Amount = 0 then begin
                    //+#144
                    if AccountType = AccountType::"Provisión insolvencias" then begin
                        CustLedgEntry.CalcFields("Importe provisionado");
                        Validate(Amount, -CustLedgEntry.ImporteaAprovisionar("Posting Date", PorcProvisionar) +
                        CustLedgEntry."Importe provisionado");
                        Description := StrSubstNo(Text020, PorcProvisionar);
                        GetDimCustLedgEntry(CustLedgEntry);
                        "External Document No." := CustLedgEntry."Document No.";
                    end
                    else begin
                        //-#144
                        CustLedgEntry.CalcFields("Remaining Amount");
                        if CustLedgEntry."Amount to Apply" <> 0 then begin
                            if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(Rec, CustLedgEntry, 0, false)
                            then begin
                                if Abs(CustLedgEntry."Amount to Apply") >=
                                  Abs(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible")
                                then
                                    Amount := -(CustLedgEntry."Remaining Amount" -
                                      CustLedgEntry."Remaining Pmt. Disc. Possible")
                                else
                                    Amount := -CustLedgEntry."Amount to Apply";
                            end else
                                Amount := -CustLedgEntry."Amount to Apply";
                        end else begin
                            if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(Rec, CustLedgEntry, 0, false)
                            then
                                Amount := -(CustLedgEntry."Remaining Amount" -
                                  CustLedgEntry."Remaining Pmt. Disc. Possible")
                            else
                                Amount := -CustLedgEntry."Remaining Amount";
                        end;
                        if "Bal. Account Type" in
                          ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor]
                        then
                            Amount := -Amount;
                        Validate(Amount);
                        //+#144
                    end;
                    //-#144
                end;
                "Applies-to Doc. Type" := CustLedgEntry."Document Type";
                "Applies-to Doc. No." := CustLedgEntry."Document No.";
                "Applies-to ID" := '';
                //ADD-ON.GRG.10.11.12
                //TipoDoc:=CustLedgEntry.TipoDoc;
                //ADD-ON.GRG.10.11.12
            end else begin
                "Applies-to Doc. No." := OldAppliesToDocNo;
                Clear(ApplyCustEntries);
            end;
            //++ZZ GE::REG 25-09-13
            "Posting Group" := CustLedgEntry."Customer Posting Group";
            //++ZZ GE::REG 25-09-13
        end;
        //-#144
    end;

    //Unsupported feature: Code Modification on ""Applies-to Doc. No."(Field 36).OnValidate".
    //[EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAppliesToDocNoOnValidateOnBeforeUpdAmtToEntries', '', false, false)] llevarlo a un Codeunit
    local procedure OnAppliesToDocNoOnValidateOnBeforeUpdAmtToEntries(var GenJournalLine: Record "Gen. Journal Line"; var TempGenJnlLine: Record "Gen. Journal Line")
    begin
        if GenJournalLine."Account Type" = "Account Type"::"Cancelar Prov. Insol." then
            TempGenJnlLine."Account Type" := TempGenJnlLine."Account Type"::Customer //para que entre en el mismo proceso del cliente 
    end;

    //[EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAppliesToDocNoOnValidateOnAfterUpdAmtToEntries', '', false, false)] llevarlo a un Codeunit
    local procedure OnAppliesToDocNoOnValidateOnAfterUpdAmtToEntries(var GenJournalLine: Record "Gen. Journal Line"; var TempGenJnlLine: Record "Gen. Journal Line")
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        if GenJournalLine."Account Type" = "Account Type"::"Cancelar Prov. Insol." then
            TempGenJnlLine."Account Type" := TempGenJnlLine."Account Type"::"Cancelar Prov. Insol."; //le regresa el valor para hacer las operaciones propias de este tipo de cuenta 
        //+#144
        if "Account Type" = "Account Type"::"Cancelar Prov. Insol." then begin
            if "Applies-to Doc. No." <> '' then begin
                CustLedgEntry.SetCurrentKey("Document No.");
                CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                CustLedgEntry.SetRange("Customer No.", "Account No.");
                CustLedgEntry.SetRange(Open);
                CustLedgEntry.SetRange(CustLedgEntry."Document Type", CustLedgEntry."Document Type"::Invoice);
                CustLedgEntry.SetFilter("Importe provisionado", '<>%1', 0);
                if CustLedgEntry.Find('-') then begin
                    "Currency Code" := '';
                    CustLedgEntry.CalcFields("Importe provisionado");
                    Validate(Amount, CustLedgEntry."Importe provisionado");
                    Description := Text021;
                    GetDimCustLedgEntry(CustLedgEntry);
                    "External Document No." := CustLedgEntry."Document No.";
                end;
            end;
        end;

        if "Account Type" = "Account Type"::"Provisión Insolvencias" then begin
            if "Applies-to Doc. No." <> '' then begin
                CustLedgEntry.SetCurrentKey("Document No.");
                CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                CustLedgEntry.SetRange("Customer No.", "Account No.");
                CustLedgEntry.SetRange(Open, true);
                CustLedgEntry.SetRange(CustLedgEntry."Document Type", CustLedgEntry."Document Type"::Invoice);
                if CustLedgEntry.Find('-') then begin
                    "Currency Code" := '';
                    Clear(PorcProvisionar);
                    CustLedgEntry.CalcFields("Importe provisionado");
                    Validate(Amount, -CustLedgEntry.ImporteaAprovisionar("Posting Date", PorcProvisionar) + CustLedgEntry."Importe provisionado");
                    Description := StrSubstNo(Text020, PorcProvisionar);
                    GetDimCustLedgEntry(CustLedgEntry);
                    "External Document No." := CustLedgEntry."Document No.";
                end;
            end;
        end;
        //-#144
    end;

    //Unsupported feature: Code Modification on "OnInsert".
    trigger OnAfterInsert()
    var
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        //002
        if GenJnlBatch."Seccion Cheques Protestado" then
            "Cheque Protestado" := true;
        //002

        //004
        if GenJnlBatch."Seccion Caja Chica" then begin
            "Caja Chica" := true;
            if UserSetUp.Get(UserId) then begin
                if not UserSetUp."Ingresa Diario Caja Chica" then
                    Error(Error004);
            end
            else
                Error(Error004);
        end;
        //004
    end;

    //Unsupported feature: Code Modification on "CheckDocNoBasedOnNoSeries(PROCEDURE 74)".

    //procedure CheckDocNoBasedOnNoSeries();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IsHandled := false;
    OnBeforeCheckDocNoBasedOnNoSeries(Rec,LastDocNo,NoSeriesCode,NoSeriesMgtInstance,IsHandled);
    if IsHandled then
    #4..6
      exit;

    if (LastDocNo = '') or ("Document No." <> LastDocNo) then
      if "Document No." <> NoSeriesMgtInstance.GetNextNo(NoSeriesCode,"Posting Date",false) then begin
        NoSeriesMgtInstance.TestManualWithDocumentNo(NoSeriesCode,"Document No.");  // allow use of manual document numbers.
        NoSeriesMgtInstance.ClearNoSeriesLine;
      end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..9
      if "Document No." <> NoSeriesMgtInstance.GetNextNo(NoSeriesCode,"Posting Date",false) then
        NoSeriesMgtInstance.TestManualWithDocumentNo(NoSeriesCode,"Document No.");  // allow use of manual document numbers.
    */
    //end;

    //Unsupported feature: Parameter Insertion (Parameter: ShouldCheckPaymentTolerance) (ParameterCollection) on "ValidateAmount(PROCEDURE 223)".



    //Unsupported feature: Code Modification on "ValidateAmount(PROCEDURE 223)".
    //El metodo se llama desde los campos Amount y "Applies-to Doc. No." solo se calcula el ultimo metodo si proviene del campo amount
    //[EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeUpdateApplyToAmount', '', false, false)] llevarlo a un Codeunit
    local procedure OnBeforeUpdateApplyToAmount(var GenJournalLine: Record "Gen. Journal Line"; xGenJournalLine: Record "Gen. Journal Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    var
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
    begin
        if (GenJournalLine.Amount <> xGenJournalLine.Amount) and (CurrFieldNo <> 0) then begin
            if (GenJournalLine."Applies-to Doc. No." <> '') or (GenJournalLine."Applies-to ID" <> '') then
                SetApplyToAmount();
            if not (CurrentFieldNo = 36) then //si no proviene del campo "Applies-to Doc. No."
                if (xGenJournalLine.Amount <> 0) or (xGenJournalLine."Applies-to Doc. No." <> '') or (xGenJournalLine."Applies-to ID" <> '') then
                    PaymentToleranceMgt.PmtTolGenJnl(Rec);
        end;
    end;


    //Unsupported feature: Code Modification on "GetCustLedgerEntry(PROCEDURE 33)".

    //procedure GetCustLedgerEntry();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if ("Account Type" = "Account Type"::Customer) and ("Account No." = '') and
       ("Applies-to Doc. No." <> '')
    then begin
      CustLedgEntry.Reset;
      CustLedgEntry.SetRange("Document No.","Applies-to Doc. No.");
      CustLedgEntry.SetRange(Open,true);
      if not CustLedgEntry.FindFirst then
        Error(NotExistErr,"Applies-to Doc. No.");

      Validate("Account No.",CustLedgEntry."Customer No.");
      OnGetCustLedgerEntryOnAfterAssignCustomerNo(Rec,CustLedgEntry);
      if Amount = 0 then begin
        CustLedgEntry.CalcFields("Remaining Amount");

        if "Posting Date" <= CustLedgEntry."Pmt. Discount Date" then
          Amount := -(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible")
        else
          Amount := -CustLedgEntry."Remaining Amount";

        if "Currency Code" <> CustLedgEntry."Currency Code" then
          UpdateCurrencyCode(CustLedgEntry."Currency Code");

        SetAppliesToFields(
          CustLedgEntry."Document Type",CustLedgEntry."Document No.",CustLedgEntry."External Document No.");

        GenJnlBatch.Get("Journal Template Name","Journal Batch Name");
        if GenJnlBatch."Bal. Account No." <> '' then begin
          "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
          Validate("Bal. Account No.",GenJnlBatch."Bal. Account No.");
        end else
          Validate(Amount);

        OnAfterGetCustLedgerEntry(Rec,CustLedgEntry);
      end;
    end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    if ("Account Type" = "Account Type"::Customer) and ("Account No." = '') and
       ("Applies-to Doc. No." <> '') and (Amount = 0)
    #3..11

      CustLedgEntry.CalcFields("Remaining Amount");

      if "Posting Date" <= CustLedgEntry."Pmt. Discount Date" then
        Amount := -(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible")
      else
        Amount := -CustLedgEntry."Remaining Amount";

      if "Currency Code" <> CustLedgEntry."Currency Code" then
        UpdateCurrencyCode(CustLedgEntry."Currency Code");

      SetAppliesToFields(
        CustLedgEntry."Document Type",CustLedgEntry."Document No.",CustLedgEntry."External Document No.");

      GenJnlBatch.Get("Journal Template Name","Journal Batch Name");
      if GenJnlBatch."Bal. Account No." <> '' then begin
        "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
        Validate("Bal. Account No.",GenJnlBatch."Bal. Account No.");
      end else
        Validate(Amount);

      OnAfterGetCustLedgerEntry(Rec,CustLedgEntry);
    end;
    */
    //end;


    //Unsupported feature: Code Modification on "GetVendLedgerEntry(PROCEDURE 37)".

    //procedure GetVendLedgerEntry();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if ("Account Type" = "Account Type"::Vendor) and ("Account No." = '') and
       ("Applies-to Doc. No." <> '')
    then begin
      VendLedgEntry.Reset;
      VendLedgEntry.SetRange("Document No.","Applies-to Doc. No.");
      VendLedgEntry.SetRange(Open,true);
      if not VendLedgEntry.FindFirst then
        Error(NotExistErr,"Applies-to Doc. No.");

      Validate("Account No.",VendLedgEntry."Vendor No.");
      OnGetVendLedgerEntryOnAfterAssignVendorNo(Rec,VendLedgEntry);
      if Amount = 0 then begin
        VendLedgEntry.CalcFields("Remaining Amount");

        if "Posting Date" <= VendLedgEntry."Pmt. Discount Date" then
          Amount := -(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible")
        else
          Amount := -VendLedgEntry."Remaining Amount";

        if "Currency Code" <> VendLedgEntry."Currency Code" then
          UpdateCurrencyCode(VendLedgEntry."Currency Code");

        SetAppliesToFields(
          VendLedgEntry."Document Type",VendLedgEntry."Document No.",VendLedgEntry."External Document No.");

        GenJnlBatch.Get("Journal Template Name","Journal Batch Name");
        if GenJnlBatch."Bal. Account No." <> '' then begin
          "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
          Validate("Bal. Account No.",GenJnlBatch."Bal. Account No.");
        end else
          Validate(Amount);

        OnAfterGetVendLedgerEntry(Rec,VendLedgEntry);
      end;
    end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    if ("Account Type" = "Account Type"::Vendor) and ("Account No." = '') and
       ("Applies-to Doc. No." <> '') and (Amount = 0)
    #3..11

      VendLedgEntry.CalcFields("Remaining Amount");

      if "Posting Date" <= VendLedgEntry."Pmt. Discount Date" then
        Amount := -(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible")
      else
        Amount := -VendLedgEntry."Remaining Amount";

      if "Currency Code" <> VendLedgEntry."Currency Code" then
        UpdateCurrencyCode(VendLedgEntry."Currency Code");

      SetAppliesToFields(
        VendLedgEntry."Document Type",VendLedgEntry."Document No.",VendLedgEntry."External Document No.");

      GenJnlBatch.Get("Journal Template Name","Journal Batch Name");
      if GenJnlBatch."Bal. Account No." <> '' then begin
        "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
        Validate("Bal. Account No.",GenJnlBatch."Bal. Account No.");
      end else
        Validate(Amount);

      OnAfterGetVendLedgerEntry(Rec,VendLedgEntry);
    end;
    */
    //end;


    //Unsupported feature: Code Modification on "GetEmplLedgerEntry(PROCEDURE 183)".

    //procedure GetEmplLedgerEntry();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if ("Account Type" = "Account Type"::Employee) and ("Account No." = '') and
       ("Applies-to Doc. No." <> '')
    then begin
      EmplLedgEntry.Reset;
      EmplLedgEntry.SetRange("Document No.","Applies-to Doc. No.");
      EmplLedgEntry.SetRange(Open,true);
      if not EmplLedgEntry.FindFirst then
        Error(NotExistErr,"Applies-to Doc. No.");

      Validate("Account No.",EmplLedgEntry."Employee No.");
      if Amount = 0 then begin
        EmplLedgEntry.CalcFields("Remaining Amount");

        Amount := -EmplLedgEntry."Remaining Amount";

        SetAppliesToFields(EmplLedgEntry."Document Type",EmplLedgEntry."Document No.",'');

        GenJnlBatch.Get("Journal Template Name","Journal Batch Name");
        if GenJnlBatch."Bal. Account No." <> '' then begin
          "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
          Validate("Bal. Account No.",GenJnlBatch."Bal. Account No.");
        end else
          Validate(Amount);

        OnAfterGetEmplLedgerEntry(Rec,EmplLedgEntry);
      end;
    end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    if ("Account Type" = "Account Type"::Employee) and ("Account No." = '') and
       ("Applies-to Doc. No." <> '') and (Amount = 0)
    #3..10
      EmplLedgEntry.CalcFields("Remaining Amount");

      Amount := -EmplLedgEntry."Remaining Amount";

      SetAppliesToFields(EmplLedgEntry."Document Type",EmplLedgEntry."Document No.",'');

      GenJnlBatch.Get("Journal Template Name","Journal Batch Name");
      if GenJnlBatch."Bal. Account No." <> '' then begin
        "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
        Validate("Bal. Account No.",GenJnlBatch."Bal. Account No.");
      end else
        Validate(Amount);

      OnAfterGetEmplLedgerEntry(Rec,EmplLedgEntry);
    end;
    */
    //end;


    //Unsupported feature: Code Modification on "CopyFromInvoicePostBuffer(PROCEDURE 112)".

    //procedure CopyFromInvoicePostBuffer();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Account No." := InvoicePostBuffer."G/L Account";
    "System-Created Entry" := InvoicePostBuffer."System-Created Entry";
    "Gen. Bus. Posting Group" := InvoicePostBuffer."Gen. Bus. Posting Group";
    #4..23
    "VAT Difference" := InvoicePostBuffer."VAT Difference";
    "VAT Base Before Pmt. Disc." := InvoicePostBuffer."VAT Base Before Pmt. Disc.";

    OnAfterCopyGenJnlLineFromInvPostBuffer(InvoicePostBuffer,Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..26
    "Cod. Colegio"           := InvoicePostBuffer."Cod. Colegio"; //APS
    "Salespers./Purch. Code" := InvoicePostBuffer."Cod. Vendedor"; //APS

    OnAfterCopyGenJnlLineFromInvPostBuffer(InvoicePostBuffer,Rec);
    */
    //end;


    //Unsupported feature: Code Modification on "CopyFromPurchHeader(PROCEDURE 109)".

    //procedure CopyFromPurchHeader();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Source Currency Code" := PurchHeader."Currency Code";
    "Currency Factor" := PurchHeader."Currency Factor";
    Correction := PurchHeader.Correction;
    #4..15
    if "Account Type" = "Account Type"::Vendor then
      "Posting Group" := PurchHeader."Vendor Posting Group";

    OnAfterCopyGenJnlLineFromPurchHeader(PurchHeader,Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..18
    "No. Comprobante Fiscal" := PurchHeader."No. Comprobante Fiscal"; //NCF

    OnAfterCopyGenJnlLineFromPurchHeader(PurchHeader,Rec);
    */
    //end;


    //Unsupported feature: Code Modification on "CopyFromSalesHeader(PROCEDURE 103)".

    //procedure CopyFromSalesHeader();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Source Currency Code" := SalesHeader."Currency Code";
    "Currency Factor" := SalesHeader."Currency Factor";
    "VAT Base Discount %" := SalesHeader."VAT Base Discount %";
    #4..16
    if "Account Type" = "Account Type"::Customer then
      "Posting Group" := SalesHeader."Customer Posting Group";

    OnAfterCopyGenJnlLineFromSalesHeader(SalesHeader,Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..19
    "No. Comprobante Fiscal" := SalesHeader."No. Comprobante Fiscal"; //NCF
    "Cod. Colegio"           := SalesHeader."Cod. Colegio"; //APS
    "No. Comprobante Fiscal Rel." := SalesHeader."No. Comprobante Fiscal Rel.";    //#30531

    //017
    "Collector Code" := SalesHeader."Collector Code";
    //017

    {
    //fes mig
    //No aplica en Santillana Ecuador - Migracion a BC
    ////DSLoc1.04
    "No. Comprobante Fiscal" := SalesHeader."No. Comprobante Fiscal";
    "Cod. Clasificacion Gasto" := SalesHeader."Cod. Clasificacion Gasto";
    "Fecha vencimiento NCF" := SalesHeader."Ultimo. No. NCF";
    "Tipo de ingreso" := SalesHeader."Tipo de ingreso";
    }

    OnAfterCopyGenJnlLineFromSalesHeader(SalesHeader,Rec);
    */
    //end;


    //Unsupported feature: Code Modification on "SetAmountWithRemaining(PROCEDURE 101)".

    //procedure SetAmountWithRemaining();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if AmountToApply <> 0 then
      if CalcPmtDisc and (Abs(AmountToApply) >= Abs(RemainingAmount - RemainingPmtDiscPossible)) then
        Amount := -(RemainingAmount - RemainingPmtDiscPossible)
    #4..11
      Amount := -Amount;

    OnAfterSetAmountWithRemaining(Rec);
    ValidateAmount;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..14
    ValidateAmount(false);
    */
    //end;


    //Unsupported feature: Code Modification on "GetCustomerAccount(PROCEDURE 47)".

    //procedure GetCustomerAccount();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    Cust.Get("Account No.");
    Cust.CheckBlockedCustOnJnls(Cust,"Document Type",false);
    CheckICPartner(Cust."IC Partner Code","Account Type","Account No.");
    UpdateDescription(Cust.Name);
    "Payment Method Code" := Cust."Payment Method Code";
    Validate("Recipient Bank Account",Cust."Preferred Bank Account Code");
    "Posting Group" := Cust."Customer Posting Group";
    SetSalespersonPurchaserCode(Cust."Salesperson Code","Salespers./Purch. Code");
    "Payment Terms Code" := Cust."Payment Terms Code";
    Validate("Bill-to/Pay-to No.","Account No.");
    Validate("Sell-to/Buy-from No.","Account No.");
    if not SetCurrencyCode("Bal. Account Type","Bal. Account No.") then
    #13..24
    CheckPaymentTolerance;

    OnAfterAccountNoOnValidateGetCustomerAccount(Rec,Cust,CurrFieldNo);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    Cust.Get("Account No.");
    if "Account Type" = "Account Type"::Customer then  //+#29271
      Cust.CheckBlockedCustOnJnls(Cust,"Document Type",false);
    #3..8

    "Collector Code" := Cust."Collector Code"; //003

    "Payment Terms Code" := Cust."Payment Terms Code";

    Beneficiario         := Cust.Name; //GRN Para los cheques

    #10..27
    */
    //end;


    //Unsupported feature: Code Modification on "GetVendorAccount(PROCEDURE 115)".

    //procedure GetVendorAccount();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    Vend.Get("Account No.");
    Vend.CheckBlockedVendOnJnls(Vend,"Document Type",false);
    CheckICPartner(Vend."IC Partner Code","Account Type","Account No.");
    UpdateDescription(Vend.Name);
    "Payment Method Code" := Vend."Payment Method Code";
    "Creditor No." := Vend."Creditor No.";

    OnGenJnlLineGetVendorAccount(Vend);
    #9..30
    CheckPaymentTolerance;

    OnAfterAccountNoOnValidateGetVendorAccount(Rec,Vend,CurrFieldNo);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5

    //+
    Beneficiario         := Vend.Name;
    //-

    #6..33
    */
    //end;


    //Unsupported feature: Code Modification on "CreateFAAcquisitionLines(PROCEDURE 131)".

    //procedure CreateFAAcquisitionLines();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TestField("Journal Template Name");
    TestField("Journal Batch Name");
    TestField("Posting Date");
    #4..14
    FAGenJournalLine.Validate("Account Type","Account Type");
    FAGenJournalLine.Validate("Account No.","Account No.");
    FAGenJournalLine.Validate(Amount,Amount);
    FAGenJournalLine.Validate("Currency Code","Currency Code");
    FAGenJournalLine.Validate("Posting Date","Posting Date");
    FAGenJournalLine.Validate("FA Posting Type","FA Posting Type"::"Acquisition Cost");
    FAGenJournalLine.Validate("External Document No.","External Document No.");
    #22..54
      BalancingGenJnlLine.Validate("Source Code",GenJnlTemplate."Source Code");
      BalancingGenJnlLine.Modify(true);
    end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..17
    #19..57
    */
    //end;

    procedure GetDimCustLedgEntry(parCustLedgEntry: Record "Cust. Ledger Entry")
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        TempDimSetEntry2: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
    begin
        //+#144
        DimMgt.GetDimensionSet(TempDimSetEntry2, parCustLedgEntry."Dimension Set ID");
        if TempDimSetEntry2.FindSet then begin
            DimMgt.GetDimensionSet(TempDimSetEntry, "Dimension Set ID");
            repeat
                UpdateDimSet(TempDimSetEntry, TempDimSetEntry2."Dimension Code", TempDimSetEntry2."Dimension Value Code");
            until TempDimSetEntry2.Next = 0;
            "Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
        end;
        //-#144
    end;

    procedure UpdateDimSet(var TempDimSetEntry: Record "Dimension Set Entry" temporary; DimCode: Code[20]; DimValueCode: Code[20])
    var
        DimVal: Record "Dimension Value";
    begin
        if DimCode = '' then
            exit;
        if TempDimSetEntry.Get("Dimension Set ID", DimCode) then
            TempDimSetEntry.Delete;
        if DimValueCode <> '' then begin
            DimVal.Get(DimCode, DimValueCode);
            TempDimSetEntry.Init;
            TempDimSetEntry."Dimension Set ID" := "Dimension Set ID";
            TempDimSetEntry."Dimension Code" := DimCode;
            TempDimSetEntry."Dimension Value Code" := DimValueCode;
            TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
            TempDimSetEntry.Insert;
        end;
    end;


    //Unsupported feature: Property Modification (OptionString) on ""Applies-to Doc. No."(Field 36).OnLookup.AccType(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //"Applies-to Doc. No." : "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //"Applies-to Doc. No." : "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee,,,"Provisión insolvencias","Cancelar provisión insol.";
    //Variable type has not been exported.

    var
        OldAppliesToDocNo: Code[20];
        ApplyCustEntries: Page "Apply Customer Entries";

    var
        "***Santillana**": Integer;
        PorcProvisionar: Decimal;
        VATRegNoFormat: Record "VAT Registration No. Format";
        FuncEcuador: Codeunit "Funciones Ecuador";
        SRIParam: Record "SRI - Tabla Parametros";
        UserSetUp: Record "User Setup";
        Text020: Label 'Provisión Insolvencias %1%';
        Text021: Label 'Reversión provisión';
        Error006: Label 'No se puede especificar el tipo cuenta "%1" y el tipo contrapartida "Cliente".';
        Error007: Label 'Solo se permite seleccionar facturas.';
        Error001: Label 'Due Date cannot be lower than Posting Date in a Future Checks Batch';
        Error002: Label 'the leng of the field %1 must be of 10 digits';
        Error003: Label 'La longitud del campo %1 debe ser de 3 dígitos';
        Error004: Label 'User cannot insert Pretty Cash Section';
        Text004: Label 'Do you wish to continue?';
        FromCurrencyCode: Code[10];
        ToCurrencyCode: Code[10];
        Text003: Label 'The %1 in the %2 will be changed from %3 to %4.\Do you want to continue?';
        Text005: Label 'The update has been interrupted to respect the warning.';
}

