tableextension 50071 tableextension50071 extends "Purchase Header"
{
    fields
    {
        modify("Buy-from Vendor No.")
        {
            TableRelation = Vendor WHERE(Inactivo = CONST(false));
            Description = '#34448';
            trigger OnAfterValidate()
            begin
                if "No." <> '' then //validar que el pedido ya tenga NO.
                    InsertaRetenciones;//DSLoc1.02
            end;
        }
        modify("Pay-to Vendor No.")
        {
            TableRelation = Vendor WHERE(Inactivo = CONST(false));
            Description = '#34448';

            trigger OnAfterValidate()
            begin
                //DSLoc1.01 To generate NCF to informal Vendor's
                VendorPostingGr.Get("Vendor Posting Group");
                if ("No. Comprobante Fiscal" = '') and (VendorPostingGr."Permite Emitir NCF") then
                    if "Document Type" in ["Document Type"::Invoice, "Document Type"::Order] then begin
                        "No. Serie NCF Facturas" := VendorPostingGr."No. Serie NCF Factura Compra";
                    end;

                if ("No. Comprobante Fiscal" = '') and (VendorPostingGr."Permite Emitir NCF") then
                    if "Document Type" in ["Document Type"::"Credit Memo", "Document Type"::"Return Order"] then begin
                        "No. Serie NCF Abonos" := VendorPostingGr."No. Serie NCF Abonos Compra";
                    end
            end;
        }

        //Unsupported feature: Property Modification (Data type) on ""Pay-to Name 2"(Field 6)".


        //Unsupported feature: Property Modification (Data type) on ""Pay-to Address 2"(Field 8)".


        //Unsupported feature: Property Modification (Data type) on ""Pay-to City"(Field 9)".


        //Unsupported feature: Property Modification (Data type) on ""Ship-to Name 2"(Field 14)".


        //Unsupported feature: Property Modification (Data type) on ""Ship-to Address 2"(Field 16)".


        //Unsupported feature: Property Modification (Data type) on ""Ship-to City"(Field 17)".

        modify("Location Code")
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false),
                                            Inactivo = CONST(false));
            Description = '#34448';
        }
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
        modify("VAT Registration No.")
        {

            //Unsupported feature: Property Modification (Data type) on ""VAT Registration No."(Field 70)".

            Caption = 'Tax Registration No.';
        }
        modify("Sell-to Customer No.")
        {
            TableRelation = Customer WHERE(Inactivo = CONST(false));
            Description = '#34448';
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
        modify("Prepmt. Pmt. Discount Date")
        {
            Caption = 'Prepmt. Pmt. Discount Date';
        }
        modify("Location Filter")
        {
            TableRelation = Location WHERE(Inactivo = CONST(false));
            Description = '#34448';
        }
        // modify("Fiscal Invoice Number PAC")
        // {
        //     Caption = 'Fiscal Invoice Number PAC';
        // }
        modify("Posting Date")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                //+#20150
                //Si es una factura electronica de compra no se tiene que validar el No.Autorizacion
                if not "Factura eletrónica" then
                    //001
                    if AutSRIProv.Get("Buy-from Vendor No.", "No. Autorizacion Comprobante") then begin
                        if "Posting Date" >= AutSRIProv."Fecha Caducidad" then
                            Error(Error002, FieldCaption("Posting Date"), AutSRIProv.FieldCaption("Fecha Caducidad"),
                             AutSRIProv.FieldCaption("No. Autorizacion"),
                                 AutSRIProv."No. Autorizacion");
                    end;
                //001
            end;
        }


        //Unsupported feature: Code Modification on ""Prices Including VAT"(Field 35).OnValidate".
        //Quitar metodo UpdatePrepmtAmounts
        field(55000; "Sustento del Comprobante"; Code[10])
        {
            Caption = 'Voucher Sustentation';
            DataClassification = ToBeClassified;
            Description = 'SRI';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("SUSTENTO DEL COMPROBANTE"));

            trigger OnValidate()
            begin
                if SRI.Get(0, "Sustento del Comprobante") then
                    "Desc. Sustento Comprobante" := CopyStr(SRI.Description, 1, 50)
                else
                    Clear("Desc. Sustento Comprobante");
            end;
        }
        field(55001; "Tipo de Comprobante"; Code[10])
        {
            Caption = 'Voucher Type';
            DataClassification = ToBeClassified;
            Description = 'SRI';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("TIPOS COMPROBANTES AUTORIZADOS"));

            trigger OnValidate()
            var
                Err001: Label 'Se requiere eliminar las lineas de reembolso.';
                recFactRespaldo: Record "Facturas de reembolso";
            begin
                Clear("No. Comprobante Fiscal");//001

                if SRI.Get(1, "Tipo de Comprobante") then
                    "Desc. Tipo de Comprobante" := CopyStr(SRI.Description, 1, 50)
                else
                    Clear("Desc. Tipo de Comprobante");

                //+ats
                if "Tipo de Comprobante" <> '41' then begin
                    recFactRespaldo.Reset;
                    recFactRespaldo.SetRange("Document Type", "Document Type");
                    recFactRespaldo.SetRange("Document No.", "No.");
                    if recFactRespaldo.FindSet then
                        Error(Err001);
                end;

                //-ats
            end;
        }
        field(55002; "No. Autorizacion Comprobante"; Code[49])
        {
            Caption = 'Authorization Voucher No.';
            DataClassification = ToBeClassified;
            Description = 'SRI';
            TableRelation = IF ("Document Type" = FILTER(Invoice | Order),
                                "Factura eletrónica" = CONST(false)) "Autorizaciones SRI Proveedores"."No. Autorizacion" WHERE("Cod. Proveedor" = FIELD("Buy-from Vendor No."),
                                                                                                                              "Tipo Documento" = FILTER(Factura))
            ELSE
            IF ("Document Type" = FILTER("Credit Memo" | "Return Order"),
                                                                                                                                       "Factura eletrónica" = CONST(false)) "Autorizaciones SRI Proveedores"."No. Autorizacion" WHERE("Cod. Proveedor" = FIELD("Buy-from Vendor No."),
                                                                                                                                                                                                                                     "Tipo Documento" = FILTER("Nota de Credito"));

            trigger OnValidate()
            begin

                //+#34829
                ValidaAutorizacion("No. Autorizacion Comprobante");


                //+#20150
                //Si es una factura electronica de compra no se tiene que validar el No.Autorizacion
                if "Factura eletrónica" then
                    exit;
                //-#20150

                TestField("Tipo de Comprobante");
                if ("Tipo de Comprobante" <> '00') and ("Tipo de Comprobante" <> '08') and ("Tipo de Comprobante" <> '11')
                  and ("Tipo de Comprobante" <> '13') and ("Tipo de Comprobante" <> '15') and ("Tipo de Comprobante" <> '16')
                  and ("Tipo de Comprobante" <> '17') and ("Tipo de Comprobante" <> '19') and ("Tipo de Comprobante" <> '20')
                  and ("Tipo de Comprobante" <> '21') then begin
                    if AutSRIProv.Get("Buy-from Vendor No.", "No. Autorizacion Comprobante") then begin
                        if "Posting Date" >= AutSRIProv."Fecha Caducidad" then
                            Error(Error002, FieldCaption("Posting Date"), AutSRIProv."Fecha Caducidad", AutSRIProv.FieldCaption("No. Autorizacion"),
                                 AutSRIProv."No. Autorizacion");
                        AutSRIProv.TestField("Fecha Autorizacion");
                        AutSRIProv.TestField(Establecimiento);
                        AutSRIProv.TestField("Punto de Emision");
                        AutSRIProv.TestField("Tipo Comprobante");
                        Establecimiento := AutSRIProv.Establecimiento;
                        "Fecha Caducidad" := AutSRIProv."Fecha Caducidad";
                        "Punto de Emision" := AutSRIProv."Punto de Emision";
                    end;
                end
                else
                    TestField("No. Autorizacion Comprobante", '9999999999');

                //ATS
                //#34829ValidaAutorizacion("No. Autorizacion Comprobante");
            end;
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

            trigger OnValidate()
            begin
                //002
                RetDoc.Reset;
                RetDoc.SetRange("Cód. Proveedor", "Buy-from Vendor No.");
                RetDoc.SetRange("Base Cálculo", RetDoc."Base Cálculo"::Ninguno);
                RetDoc.SetRange("No. documento", "No."); //005+- SSM
                if not RetDoc.FindFirst then
                    Error(Error005);
                //002
            end;
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
            Description = 'Ecuador';
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
        field(56006; "Cod. Colegio"; Code[20])
        {
            Caption = 'School Code';
            DataClassification = ToBeClassified;
            TableRelation = Contact WHERE(Type = FILTER(Company));

            trigger OnValidate()
            begin
                //004
                if Contacto.Get("Cod. Colegio") then
                    "Nombre Colegio" := Contacto.Name;
                //004

                PurchLine.Reset;
                PurchLine.SetRange("Document Type", "Document Type");
                PurchLine.SetRange("Document No.", "No.");
                if PurchLine.FindSet(true) then
                    repeat
                        PurchLine."Cod. Colegio" := "Cod. Colegio";
                        PurchLine.Modify;
                    until PurchLine.Next = 0;
            end;
        }
        field(56007; "Nombre Colegio"; Text[60])
        {
            Caption = 'School Name';
            DataClassification = ToBeClassified;
        }
        field(56008; "Cod. Taller"; Code[20])
        {
            Caption = 'Workshop code';
            DataClassification = ToBeClassified;
            TableRelation = Talleres.Codigo;
        }
        field(56009; "Factura eletrónica"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '#20150';
        }
        field(76422; "Cod. Vendedor"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = "Salesperson/Purchaser";
        }
        field(76127; Rappel; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(76357; Taller; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(76041; "Tipo Retencion"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
            OptionMembers = "  ",Productos,Servicios;

            trigger OnValidate()
            begin
                //DSLoc1.02 001
                TestField(Status, 0);

                InsertaRetenciones;
                //DSLoc1.02 001
            end;
        }
        field(76079; "No. Comprobante Fiscal"; Code[30])
        {
            Caption = 'Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';

            trigger OnValidate()
            var
                rVendorPostingGr: Record "Vendor Posting Group";
                Vend: Record Vendor;
            begin
                //003+
                /*//fes mig
                //DSLoc1.02 Para validar estructura NCF
                //AMS Esta validacion no puede estar en la codeunit
                //debido a que si el sistema generó el NCF para consumidor final y luego dio un error
                //esta validación en la codeunit está obligando a que se borre el NCF de la cab. de compra
                Vend.GET("Buy-from Vendor No.");
                VendorPostingGr.GET(Vend."Vendor Posting Group");
                IF NOT VendorPostingGr."NCF Obligatorio" THEN
                  TESTFIELD("No. Comprobante Fiscal",'');
                
                IF (NOT VendorPostingGr."NCF Obligatorio") AND ("No. Comprobante Fiscal" = '') THEN
                  ERROR(Error0001);
                
                IF ("No. Comprobante Fiscal" <> '') THEN BEGIN  //jpg 29-04-2021 permitir borrar ya que no es generado ya la validacion anterior validaron
                  cuLocalizacion.ValidaNCFCompras(Rec);
                
                IF CURRENTCLIENTTYPE = CLIENTTYPE::Windows THEN//AMS - 22/Jul/2021 Esta función no es compatible con el cliente Web
                  IF NOT Correction THEN
                  ConsultaNCF.ValidarRNC_NCF("VAT Registration No.","No. Comprobante Fiscal",Mensaje);
                END;
                */
                //003-


                //001
                Vend.Get("Buy-from Vendor No.");
                VendorPostingGr.Get(Vend."Vendor Posting Group");

                //Comentado mientras digitan las facturas de enero y febrero
                /*
                IF NOT VendorPostingGr."NCF Obligatorio" THEN
                  TESTFIELD("No. Comprobante Fiscal",'');
                
                IF (NOT VendorPostingGr."NCF Obligatorio") AND ("No. Comprobante Fiscal" = '') THEN
                  ERROR(Error001);
                */

                if ("Tipo de Comprobante" <> '00') and ("Tipo de Comprobante" <> '08') and ("Tipo de Comprobante" <> '11')
                  and ("Tipo de Comprobante" <> '13') and ("Tipo de Comprobante" <> '15') and ("Tipo de Comprobante" <> '16')
                  and ("Tipo de Comprobante" <> '17') and ("Tipo de Comprobante" <> '19') and ("Tipo de Comprobante" <> '20')
                  and ("Tipo de Comprobante" <> '21') then begin

                    //+#20150
                    //Si es una factura electronica de compra no se tiene que validar el No.Autorizacion
                    if "Factura eletrónica" then
                        exit;
                    //-#20150

                    //ESTA CONDICION ES OPCIONAL MIENTRAS DIGITAL LAS FACTURAS DE ENERO Y FEBRERO
                    if not VendorPostingGr."NCF Obligatorio" and rVendorPostingGr."Permite Emitir NCF" then
                        TestField("No. Autorizacion Comprobante");

                    //  TESTFIELD("No. Autorizacion Comprobante"); ESTE ES EL CONTROL ORIGINAL

                    Clear(AutSRIProv);
                    if ("No. Comprobante Fiscal" <> '') and (VendorPostingGr."NCF Obligatorio") then begin
                        Evaluate(wNCF, "No. Comprobante Fiscal");
                        AutSRIProv.Reset;
                        AutSRIProv.SetCurrentKey("Cod. Proveedor", "Tipo Comprobante", "Fecha Caducidad", Estado, "Punto de Emision", Establecimiento,
                                                 "No. Autorizacion", "Tipo Documento");
                        AutSRIProv.SetRange("Cod. Proveedor", "Buy-from Vendor No.");

                        //ATS REEMBOLSO
                        //AutSRIProv.SETRANGE("Tipo Comprobante","Tipo de Comprobante");
                        if "Tipo de Comprobante" = '41' then
                            AutSRIProv.SetRange("Permitir Comprobante Reembolso", true)
                        else
                            AutSRIProv.SetRange("Tipo Comprobante", "Tipo de Comprobante");
                        //ATS REEMBOLSO
                        //AutSRIProv.SETFILTER("Fecha Caducidad",'>%1',"Posting Date");
                        AutSRIProv.SetRange(Estado, AutSRIProv.Estado::Autorizado);
                        AutSRIProv.SetRange("Punto de Emision", "Punto de Emision");
                        AutSRIProv.SetRange(Establecimiento, Establecimiento);
                        AutSRIProv.SetRange("No. Autorizacion", "No. Autorizacion Comprobante");
                        if ("Document Type" = "Document Type"::Invoice) or ("Document Type" = "Document Type"::Order) then
                            AutSRIProv.SetRange(AutSRIProv."Tipo Documento", AutSRIProv."Tipo Documento"::Factura)
                        else
                            AutSRIProv.SetRange(AutSRIProv."Tipo Documento", AutSRIProv."Tipo Documento"::"Nota de Credito");
                        AutSRIProv.FindFirst;

                        if AutSRIProv.Electronica = false then
                            AutSRIProv.SetFilter("Fecha Caducidad", '>%1', "Posting Date");
                        AutSRIProv.FindFirst;

                        if AutSRIProv."Rango Inicio" <> '' then
                            Evaluate(Inicial, AutSRIProv."Rango Inicio");
                        if AutSRIProv."Rango Fin" <> '' then
                            Evaluate(Final, AutSRIProv."Rango Fin");

                        if (Inicial <= wNCF) and (Final >= wNCF) then
                            OK := true
                        else
                            Error(Error004, "No. Comprobante Fiscal", AutSRIProv.GetFilters);
                    end;
                end
                else
                    TestField("No. Comprobante Fiscal");

            end;
        }
        field(76080; "No. Comprobante Fiscal Rel."; Code[30])
        {
            Caption = 'Rel. Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';

            trigger OnValidate()
            begin
                //DSLoc2.0
                cuLocalizacion.ValidaNCFRelacionadoCompras(Rec);
            end;
        }
        field(76056; "Correccion Doc. NCF"; Boolean)
        {
            Caption = 'NCF Doc. Correction';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
        }
        field(76057; "No. Serie NCF Facturas"; Code[10])
        {
            Caption = 'Invoice NCF Series No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
            TableRelation = "No. Series";

            trigger OnValidate()
            var
                NoSeries: Record "No. Series";
                NoSeriesLine: Record "No. Series Line";
            begin

                TestField("Tipo de Comprobante");
                if NoSeries.Get("No. Serie NCF Facturas") then begin
                    NoSeriesLine.Reset;
                    NoSeriesLine.SetRange("Series Code", "No. Serie NCF Facturas");
                    NoSeriesLine.SetRange(Open, true);
                    NoSeriesLine.FindLast;

                    //ATS REEMBOLSO
                    //NoSeriesLine.TESTFIELD("Tipo Comprobante", "Tipo de Comprobante");
                    if "Tipo de Comprobante" = '41' then
                        NoSeriesLine.TestField("Permitir Comprobante Reembolso", true)
                    else
                        NoSeriesLine.TestField("Tipo Comprobante", "Tipo de Comprobante");
                    //ATS REEMBOLSO
                    if ("Tipo de Comprobante" <> '03') and ("Tipo de Comprobante" <> '41') then
                        NoSeriesLine.TestField("No. Autorizacion");
                    NoSeriesLine.TestField(Establecimiento);
                    NoSeriesLine.TestField("Punto de Emision");

                    Establecimiento := NoSeriesLine.Establecimiento;
                    "Punto de Emision" := NoSeriesLine."Punto de Emision";
                    "No. Autorizacion Comprobante" := NoSeriesLine."No. Autorizacion";

                end;
            end;
        }
        field(76078; "No. Serie NCF Abonos"; Code[10])
        {
            Caption = 'NCF Credit Memo Series No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
            TableRelation = "No. Series";
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

            trigger OnValidate()
            var
                recCountry: Record "Country/Region";
                Err001: Label 'No puede completarse este valor, existe convenio de doble tributación.';
                recProv: Record Vendor;
            begin
                //ATS170915
                if "Aplica Retención" then begin
                    recProv.Get("Buy-from Vendor No.");
                    recCountry.SetRange(Code, recProv."Country/Region Code");
                    if recCountry.FindSet then
                        if recCountry."Tiene Convenio" then
                            Error(Err001);
                end;
            end;
        }
        field(76003; "Fecha vencimiento NCF"; Date)
        {
            Caption = 'NCF Due date';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
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
        field(76090; "Total Retencion"; Decimal)
        {
            CalcFormula = Sum("Retencion Doc. Proveedores"."Importe Retención" WHERE("Tipo documento" = FIELD("Document Type"),
                                                                                      "No. documento" = FIELD("No.")));
            Description = 'DSLoc1.03';
            Editable = false;
            FieldClass = FlowField;
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
                GLSetup: Record "General Ledger Setup";
            begin
                //002 JPG  config. de ITBIS Activa y cambiar el Gpo. Contable ++

                GLSetup.Get;
                if not GLSetup."ITBIS al costo activo" then
                    exit;

                Modify;

                PurchLine.Reset;
                PurchLine.SetRange("Document Type", "Document Type");
                PurchLine.SetRange("Document No.", "No.");
                // PurchLine.SETRANGE(Type,PurchLine.Type::Item);
                PurchLine.SetFilter(Type, '=%1|=%2', PurchLine.Type::"G/L Account", PurchLine.Type::Item);
                PurchLine.SetFilter("No.", '<>%1', '');
                if PurchLine.FindSet(true) then
                    repeat
                        // PurchLine.VALIDATE("VAT Prod. Posting Group");
                        PurchLine.ActualizarITBIS;
                        PurchLine.Modify;

                    until PurchLine.Next = 0;
                //002 JPG  config. de ITBIS Activa y cambiar el Gpo. Contable --
            end;
        }
        field(76355; "No. autorizacion de pago"; Code[30])
        {
            Caption = 'Payment authorization code';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.02';
        }
        field(76460; Proporcionalidad; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,100% Admitido,% Admitido,0% Admitido,No Aplica';
            OptionMembers = " ","100% Admitido","% Admitido","0% Admitido","No Aplica";
        }
    }

    trigger OnAfterInsert()
    var
        myInt: Integer;
    begin
        if "Buy-from Vendor No." <> '' then //para insertar retencion nuevamente por si se uso nombre vendedor el cual no inserta el no de pedido
            InsertaRetenciones;//DSLoc1.02
    end;


    //Unsupported feature: Code Modification on "RecreatePurchLines(PROCEDURE 4)".
    //Quitar metodo RestorePurchCommentLine

    procedure InsertaRetenciones()
    var
        ProvRetencion: Record "Proveedor - Retencion";
        RetencionDoc: Record "Retencion Doc. Proveedores";
    begin
        //Versión Ecuador
        //Eliminamos Retenciones creadas para el pedido actual
        RetencionDoc.Reset;
        RetencionDoc.SetRange("No. documento", "No.");
        if RetencionDoc.FindSet(true) then
            RetencionDoc.DeleteAll;

        ProvRetencion.Reset;
        ProvRetencion.SetRange("Cód. Proveedor", "Buy-from Vendor No.");
        if ProvRetencion.FindFirst then begin
            RetencionDoc."Cód. Proveedor" := ProvRetencion."Cód. Proveedor";
            RetencionDoc."Código Retención" := ProvRetencion."Código Retención";
            RetencionDoc."Cta. Contable" := ProvRetencion."Cta. Contable";
            RetencionDoc."Base Cálculo" := ProvRetencion."Base Cálculo";
            RetencionDoc.Devengo := ProvRetencion.Devengo;
            RetencionDoc."Importe Retención" := ProvRetencion."Importe Retención";
            RetencionDoc."Retencion IVA" := ProvRetencion."Retencion IVA";
            RetencionDoc."Tipo Retención" := ProvRetencion."Tipo Retención";
            RetencionDoc."Tipo documento" := "Document Type";
            RetencionDoc."No. documento" := "No.";
            if not RetencionDoc.Insert then
                RetencionDoc.Modify;
        end;


        //fes mig versión actualizada localizado rd
        /*
        //Eliminamos Retenciones creadas para el pedido actual
        ProvRetencionDoc.RESET;
        ProvRetencionDoc.SETRANGE("No. documento","No.");
        IF ProvRetencionDoc.FINDSET(TRUE,FALSE) THEN
          REPEAT
            ProvRetencionDoc.DELETE;
          UNTIL ProvRetencionDoc.NEXT = 0;
        
        ProvRetencion.RESET;
        ProvRetencion.SETRANGE("Cód. Proveedor","Buy-from Vendor No.");
        IF "Tipo Retencion" = "Tipo Retencion"::Productos THEN
           ProvRetencion.SETRANGE(ProvRetencion."Aplica Productos",TRUE);
        IF "Tipo Retencion" = "Tipo Retencion"::Servicios THEN
           ProvRetencion.SETRANGE("Aplica Servicios",TRUE);
        
        IF ProvRetencion.FINDSET THEN
          REPEAT
            ProvRetencionDoc.TRANSFERFIELDS(ProvRetencion);
            ProvRetencionDoc."Tipo documento" := "Document Type";
            ProvRetencionDoc."No. documento"  := "No.";
            IF NOT ProvRetencionDoc.INSERT THEN
               ProvRetencionDoc.MODIFY;
          UNTIL ProvRetencion.NEXT = 0;
        *///fes mig versión actualizada localizado rd

    end;

    procedure ValidaAutorizacion(pNum: Code[49])
    var
        Err001: Label 'Solo se permite que el Numero de Autorización tenga 10, 37, 49 digitos.';
    begin

        if pNum <> '' then begin
            if (StrLen(pNum) <> 37) and (StrLen(pNum) <> 49) and (StrLen(pNum) <> 10) then
                Error(Err001);
        end;
    end;

    //Unsupported feature: Deletion (VariableCollection) on "RecreatePurchLines(PROCEDURE 4).TempPurchCommentLine(Variable 1011)".


    var
        "***DSLoc***": Integer;
        cuLocalizacion: Codeunit "Validaciones Localizacion";
        VendorPostingGr: Record "Vendor Posting Group";
        ProvRetencion: Record "Proveedor - Retencion";
        ProvRetencionDoc: Record "Retencion Doc. Proveedores";
        ConsultaNCF: Codeunit "Validaciones Loc. Guatemala";
        Mensaje: array[6] of Text[1000];
        Error0001: Label 'You cannot delete a NCF generated by the system';
        "**001**": Integer;
        AutSRIProv: Record "Autorizaciones SRI Proveedores";
        PostedPurchInvHdr: Record "Purch. Inv. Header";
        PostedPurchCMHdr: Record "Purch. Cr. Memo Hdr.";
        SRI: Record "SRI - Tabla Parametros";
        wNCF: Decimal;
        Inicial: Decimal;
        Final: Decimal;
        OK: Boolean;
        Contacto: Record Contact;
        RetDoc: Record "Retencion Doc. Proveedores";
        Error001: Label 'El número de Autorizacion SRI no es válido para el proveedor %1';
        Error002: Label '%1 debe ser menor a %2 del %3 %4';
        Error003: Label 'No puede eliminar un NCF generado por el sistema, crearía una discontinuidad en el numerador';
        Error004: Label 'El %1 no existe para %2';
        Error005: Label 'To introduce Insurance Retention Base you must select at least one retention with base calculation Ninguno';
}

