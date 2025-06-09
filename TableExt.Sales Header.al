tableextension 50067 tableextension50067 extends "Sales Header"
{
    fields
    {
        modify("Sell-to Customer No.")
        {
            TableRelation = Customer WHERE(Inactivo = CONST(false));
            Description = '#34448';
            trigger OnAfterValidate()
            var
                Cust: Record Customer;
                ContacBusRel: Record "Contact Business Relation";
                MktSetUp: Record "Marketing Setup";
            begin
                // Validar que el estado sea "Open"
                TestField(Status, Status::Open);

                // Validar campos maestros y dimensiones
                ValidaCampos.Maestros(18, "Sell-to Customer No.");
                ValidaCampos.Dimensiones(18, "Sell-to Customer No.", 0, 0);

                // Configuración de marketing
                MktSetUp.Get;
                ContacBusRel.Reset;
                ContacBusRel.SetRange("Business Relation Code", MktSetUp."Bus. Rel. Code for Customers");
                ContacBusRel.SetRange("No.", "Sell-to Customer No.");
                if ContacBusRel.FindFirst then
                    Validate("Cod. Colegio", ContacBusRel."Contact No.");

                // Si es "Pre pedido" o "Venta Call Center", asignar valores adicionales
                if ("Pre pedido") or ("Venta Call Center") then begin
                    Cust.Get("Sell-to Customer No.");
                    "Tipo Documento SrI" := Cust."Tipo Documento";
                    "Tipo Ruc/Cedula" := Cust."Tipo Ruc/Cedula";
                end;

                // Si es "Venta Call Center", copiar información adicional
                if "Venta Call Center" then begin
                    "Bill-to Name" := "Sell-to Customer Name";
                    "Bill-to Name 2" := "Sell-to Customer Name 2";
                    "Bill-to Address" := "Sell-to Address";
                    "Bill-to Address 2" := "Sell-to Address 2";
                    "Bill-to City" := "Sell-to City";
                    "Bill-to Post Code" := "Sell-to Post Code";
                    "Bill-to County" := "Sell-to County";
                    "Bill-to Country/Region Code" := "Sell-to Country/Region Code";
                    "Bill-to Contact" := "Sell-to Contact";

                    "Ship-to Name" := "Sell-to Customer Name";
                    "Ship-to Name 2" := "Sell-to Customer Name 2";
                    "Ship-to Address" := "Sell-to Address";
                    "Ship-to Address 2" := "Sell-to Address 2";
                    "Ship-to City" := "Sell-to City";
                    "Ship-to Post Code" := "Sell-to Post Code";
                    "Ship-to County" := "Sell-to County";
                    "Ship-to Country/Region Code" := "Sell-to Country/Region Code";
                    "Ship-to Contact" := "Sell-to Contact";
                end;
            end;
        }
        modify("Bill-to Customer No.")
        {
            TableRelation = Customer WHERE(Inactivo = CONST(false));
            Description = '#34448';
            trigger OnAfterValidate()
            var
                Cust: Record Customer;
            begin
                // Validar que el estado sea "Open"
                TestField(Status, Status::Open);

                // Validar si el número de cliente ha cambiado
                if xRec."Bill-to Customer No." <> "Bill-to Customer No." then begin
                    // Validar que el nuevo valor no esté vacío
                    if "Bill-to Customer No." = '' then
                        Error('El campo "Bill-to Customer No." no puede estar vacío.');

                    // Validar campos maestros y dimensiones
                    ValidaCampos.Maestros(18, "Bill-to Customer No.");
                    ValidaCampos.Dimensiones(18, "Bill-to Customer No.", 0, 0);

                    // Copiar campos relacionados del cliente
                    if Cust.Get("Bill-to Customer No.") then
                        CopyCFDIFieldsFromCustomer;
                end;
            end;
        }
        modify("Bill-to Name")
        {
            Description = '#56924';
        }

        //Unsupported feature: Property Modification (Data type) on ""Bill-to City"(Field 9)".

        modify("Ship-to Name")
        {
            Description = '#34448';
        }

        //Unsupported feature: Property Modification (Data type) on ""Ship-to City"(Field 17)".

        modify("Location Code")
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false),
                                            Inactivo = CONST(false));
            Description = '#34448';
            trigger OnAfterValidate()
            begin
                // Validar que el estado sea "Open"
                TestStatusOpen;

                // Validar campos maestros
                ValidaCampos.Maestros(14, "Location Code"); //014

                // Aquí puedes agregar más lógica si es necesario
            end;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("VAT Registration No.")
        {
            Caption = 'Tax Registration No.';

            trigger OnAfterValidate()
            begin
                // Convertir el valor a mayúsculas
                "VAT Registration No." := UpperCase("VAT Registration No.");

                // Si el valor no ha cambiado, salir
                if "VAT Registration No." = xRec."VAT Registration No." then
                    exit;

                // Eliminar caracteres no deseados si el tipo de documento no es Pasaporte
                if "Tipo Documento SrI" <> "Tipo Documento SrI"::Pasaporte then
                    "VAT Registration No." := DelChr("VAT Registration No.", '=', ' ');

                // Validar RUC/Cédula si es una Venta Call Center y el tipo de documento no es Pasaporte
                if "Venta Call Center" then
                    if "Tipo Documento SrI" <> "Tipo Documento SrI"::Pasaporte then begin
                        TestField("Tipo Ruc/Cedula"); // Validar que el campo "Tipo Ruc/Cedula" no esté vacío
                        FuncEcuador.ValidaDigitosRUC("VAT Registration No.", "Tipo Ruc/Cedula", false); // Validar el RUC/Cédula
                    end;

                // Convertir nuevamente el valor a mayúsculas
                "VAT Registration No." := UpperCase("VAT Registration No.");
            end;
        }
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Sell-to Customer Name")
        {
            Description = '#56924';

            trigger OnAfterValidate()
            var
                Customer: Record Customer;
            begin
                // Si no es una aplicación de identidad y se debe buscar el cliente por nombre
                GetShippingTime(FieldNo("Sell-to Customer Name"));
                // Si es una "Venta Call Center", copiar información adicional
                if "Venta Call Center" then begin
                    "Bill-to Name" := "Sell-to Customer Name";
                    "Ship-to Name" := "Sell-to Customer Name";
                end;
            end;

        }

        //Unsupported feature: Property Modification (Data type) on ""Sell-to City"(Field 83)".

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
        modify("Direct Debit Mandate ID")
        {
            Caption = 'Direct Debit Mandate ID';
        }
        modify("Location Filter")
        {
            TableRelation = Location WHERE(Inactivo = CONST(false));
            Description = '#34448';
        }






        modify("Order Date")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                Validate("Order Time", Time);
            end;
        }

        modify("Posting Date")
        {
            trigger OnAfterValidate()
            begin
                // Validar si el factor de moneda ha cambiado
                if "Currency Factor" <> xRec."Currency Factor" then
                    Error('El factor de moneda ha cambiado. Por favor, revise los valores.');

                // Asignar la hora actual al campo "Posting Time"
                Validate("Posting Time", Time);
            end;
        }

        modify("Shipment Date")
        {
            trigger OnAfterValidate()
            begin
                //#13586:Inicio
                Validate("Shipment Time", Time);
                //#13586:Fin
            end;
        }


        modify("Prices Including VAT")
        {
            trigger OnAfterValidate()
            var
                SalesLine: Record "Sales Line";
                Currency: Record Currency;
                RecalculatePrice: Boolean;
            begin
                // Validar que el estado sea "Open"
                TestStatusOpen;

                // Si el valor de "Prices Including VAT" ha cambiado
                if "Prices Including VAT" <> xRec."Prices Including VAT" then begin
                    // Recalcular los montos en las líneas de venta
                    if SalesLine.FindSet then
                        repeat
                            if "Prices Including VAT" then
                                SalesLine."Line Amount" := SalesLine."Amount Including VAT" + SalesLine."Inv. Discount Amount"
                            else
                                SalesLine."Line Amount" := SalesLine.Amount + SalesLine."Inv. Discount Amount";
                            SalesLine.Modify;
                        until SalesLine.Next = 0;
                end;

                // Llamar al evento posterior al cambio
            end;
        }


        modify("Salesperson Code")
        {
            trigger OnAfterValidate()
            begin
                // Validar campos maestros
                ValidaCampos.Maestros(13, "Salesperson Code");

                // Validar dimensiones
                ValidaCampos.Dimensiones(13, "Salesperson Code", 0, 0);

                // Aquí puedes agregar más lógica si es necesario
            end;
        }




        modify("Sell-to Customer Name 2")
        {
            trigger OnAfterValidate()
            begin
                // Si es una "Venta Call Center", copiar información adicional
                if "Venta Call Center" then begin
                    "Bill-to Name 2" := "Sell-to Customer Name 2";
                    "Ship-to Name 2" := "Sell-to Customer Name 2";
                end;
            end;
        }

        modify("Sell-to Address")
        {
            trigger OnAfterValidate()
            begin
                // Actualizar la dirección de envío desde la dirección de facturación
                UpdateShipToAddressFromSellToAddress(FieldNo("Ship-to Address"));
                ModifyCustomerAddress;

                // Si es una "Venta Call Center", copiar la dirección de facturación y envío
                if "Venta Call Center" then begin
                    "Bill-to Address" := "Sell-to Address";
                    "Ship-to Address" := "Sell-to Address";
                end;
            end;
        }


        modify("Sell-to Address 2")
        {
            trigger OnAfterValidate()
            begin
                // Actualizar la dirección de envío desde la dirección de facturación
                UpdateShipToAddressFromSellToAddress(FieldNo("Ship-to Address 2"));
                ModifyCustomerAddress;

                // Si es una "Venta Call Center", copiar información adicional
                if "Venta Call Center" then begin
                    "Bill-to Address 2" := "Sell-to Address 2";
                    "Ship-to Address 2" := "Sell-to Address 2";
                end;
            end;
        }


        modify("Sell-to City")
        {
            trigger OnAfterValidate()
            var
                postcode: Record "Post Code";
            begin
                // Validar la ciudad utilizando el código postal
                PostCode.ValidateCity(
                    "Sell-to City", "Sell-to Post Code", "Sell-to County", "Sell-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);

                // Actualizar la dirección de envío desde la dirección de facturación
                UpdateShipToAddressFromSellToAddress(FieldNo("Ship-to City"));
                ModifyCustomerAddress;

                // Si es una "Venta Call Center", copiar información adicional
                if "Venta Call Center" then begin
                    "Bill-to City" := "Sell-to City";
                    "Ship-to City" := "Sell-to City";
                    "Bill-to County" := "Sell-to County";
                    "Ship-to County" := "Sell-to County";
                    "Bill-to Post Code" := "Sell-to Post Code";
                    "Ship-to Post Code" := "Sell-to Post Code";
                end;
            end;
        }


        modify("Sell-to Contact")
        {
            trigger OnAfterValidate()
            begin
                // Si el campo está vacío, validar el campo "Sell-to Contact No."
                if "Sell-to Contact" = '' then
                    Validate("Sell-to Contact No.", '');

                // Modificar la dirección del cliente
                ModifyCustomerAddress;

                // Si es una "Venta Call Center", copiar información adicional
                if "Venta Call Center" then begin
                    "Ship-to Contact" := "Sell-to Contact";
                    "Bill-to Contact" := "Sell-to Contact";
                end;
            end;
        }

        modify("Sell-to Post Code")
        {
            trigger OnAfterValidate()
            var
                PostCode: Record "Post Code";
            begin
                // Validar el código postal utilizando la ciudad, el condado y el país/región
                PostCode.ValidatePostCode(
                    "Sell-to City", "Sell-to Post Code", "Sell-to County", "Sell-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);

                // Actualizar la dirección de envío desde la dirección de facturación
                UpdateShipToAddressFromSellToAddress(FieldNo("Ship-to Post Code"));
                ModifyCustomerAddress;

                // Si es una "Venta Call Center", copiar información adicional
                if "Venta Call Center" then begin
                    "Bill-to Post Code" := "Sell-to Post Code";
                    "Ship-to Post Code" := "Sell-to Post Code";
                end;
            end;
        }

        modify("Sell-to County")
        {
            trigger OnAfterValidate()
            begin
                // Actualizar la dirección de envío desde la dirección de facturación
                UpdateShipToAddressFromSellToAddress(FieldNo("Ship-to County"));
                ModifyCustomerAddress;

                // Si es una "Venta Call Center", copiar información adicional
                if "Venta Call Center" then begin
                    "Bill-to County" := "Sell-to County";
                    "Ship-to County" := "Sell-to County";
                end;
            end;
        }


        modify("Sell-to Country/Region Code")
        {
            trigger OnAfterValidate()
            begin
                // Actualizar la dirección de envío desde la dirección de facturación
                UpdateShipToAddressFromSellToAddress(FieldNo("Ship-to Country/Region Code"));
                ModifyCustomerAddress;

                // Validar el campo "Ship-to Country/Region Code"
                Validate("Ship-to Country/Region Code");

                // Si es una "Venta Call Center", copiar información adicional
                if "Venta Call Center" then begin
                    "Bill-to Country/Region Code" := "Sell-to Country/Region Code";
                    "Ship-to Country/Region Code" := "Sell-to Country/Region Code";
                end;
            end;
        }

        modify("Correction")
        {
            trigger OnAfterValidate()
            begin
                // Original de Guatemala adaptado a Ecuador
                if ("Document Type" = "Document Type"::"Credit Memo") or ("Document Type" = "Document Type"::"Return Order") then begin
                    // Validar campos obligatorios
                    TestField("No. Comprobante Fiscal Rel.");
                    TestField("Applies-to Doc. Type");
                    TestField("Applies-to Doc. No.");

                    // Validar que la factura pertenezca al cliente
                    SIH.Get("Applies-to Doc. No.");
                    if SIH."Sell-to Customer No." <> "Sell-to Customer No." then
                        Error(Error004, "No. Comprobante Fiscal Rel.", "Sell-to Customer No.");

                    // Validar que el número de serie sea interno y no tenga resolución asociada
                    NSL.Reset;
                    NSL.SetRange("Series Code", "No. Serie NCF Abonos");
                    NSL.SetRange(Open, true);
                    if NSL.FindFirst then begin
                        if NSL."No. Resolucion" <> '' then begin
                            Clear("No. Serie NCF Abonos");
                            Message(Error005);
                        end;
                        if NSL."Tipo Generacion" <> NSL."Tipo Generacion"::" " then begin
                            Clear("No. Serie NCF Abonos");
                            Message(Error006);
                        end;
                    end;
                end;
            end;
        }


        //Unsupported feature: Code Modification on ""Document Date"(Field 99).OnValidate".
        modify("Document Date")
        {
            trigger OnAfterValidate()
            var
                UpdateDocumentDate: Boolean;
            begin
                // Verificar si la fecha del documento ha cambiado
                if xRec."Document Date" <> "Document Date" then
                    UpdateDocumentDate := true;

                // Validar los términos de pago
                Validate("Payment Terms Code");
                Validate("Prepmt. Payment Terms Code");

                // Calcular la fecha de validez de la cotización si corresponde
                if UpdateDocumentDate and ("Document Type" = "Document Type"::Quote) and ("Document Date" <> 0D) then
                    CalcQuoteValidUntilDate;

                // Asignar la fecha de inicio de transporte
                "Fecha inicio trans." := "Document Date";
            end;
        }


        field(50000; "Estado distribucion"; Option)
        {
            DataClassification = ToBeClassified;
            Enabled = false;
            OptionMembers = " ","Para Confirmar","Para empaque","Para despacho",Entregado;
        }
        field(50008; "No. copias Picking"; Integer)
        {
            Caption = 'No. Printed Picking';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50009; "Nota de Credito"; Boolean)
        {
            DataClassification = ToBeClassified;
            Enabled = false;

            trigger OnValidate()
            begin
                //002
                Cliente.Get("Sell-to Customer No.");
                Validate("Gen. Bus. Posting Group", Cliente."Gen. Bus. Posting Group");
                Correction := false;
                //002
            end;
        }
        field(50010; "Tipo de Venta"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Invoice,Consignation,Sample,Donations';
            OptionMembers = Factura,Consignacion,Muestras,Donaciones;

            trigger OnValidate()
            var
                cust: Record Customer;
                GenBusPostingGrp: Record "Gen. Business Posting Group";
            begin
                //009
                if "Tipo de Venta" = "Tipo de Venta"::Muestras then begin
                    GenBusPostingGrp.Reset;
                    GenBusPostingGrp.SetRange(Muestras, true);
                    if GenBusPostingGrp.FindFirst then begin
                        Validate("Gen. Bus. Posting Group", GenBusPostingGrp.Code);
                        SantSetup.Get;
                        SalesLine.Reset;
                        SalesLine.SetRange("Document Type", "Document Type");
                        SalesLine.SetRange("Document No.", "No.");
                        SalesLine.SetRange(Type, SalesLine.Type::Item);
                        if SalesLine.FindSet then
                            repeat
                                if Item.Get(SalesLine."No.") then begin
                                    CantidadSol := SalesLine."Cantidad Solicitada";
                                    if SantSetup."Precio de Venta Muestras" = SantSetup."Precio de Venta Muestras"::Costo then
                                        SalesLine.Validate("Unit Price", Item."Unit Cost")
                                    else
                                        SalesLine.Validate("Unit Price", 0);

                                    SalesLine.Validate("Cantidad Solicitada", CantidadSol);
                                    SalesLine.Modify;
                                end;
                            until SalesLine.Next = 0;
                    end;
                end;

                //009
                if "Tipo de Venta" = "Tipo de Venta"::Donaciones then begin
                    GenBusPostingGrp.Reset;
                    GenBusPostingGrp.SetRange(Donaciones, true);
                    if GenBusPostingGrp.FindFirst then begin
                        Validate("Gen. Bus. Posting Group", GenBusPostingGrp.Code);
                        SantSetup.Get;
                        SalesLine.Reset;
                        SalesLine.SetRange("Document Type", "Document Type");
                        SalesLine.SetRange("Document No.", "No.");
                        SalesLine.SetRange(Type, SalesLine.Type::Item);
                        if SalesLine.FindSet then
                            repeat
                                if Item.Get(SalesLine."No.") then begin
                                    CantidadSol := SalesLine."Cantidad Solicitada";
                                    if SantSetup."Precio de Venta Donaciones" = SantSetup."Precio de Venta Donaciones"::Costo then
                                        SalesLine.Validate("Unit Price", Item."Unit Cost")
                                    else
                                        SalesLine.Validate("Unit Price", 0);
                                    SalesLine.Validate("Cantidad Solicitada", CantidadSol);
                                    SalesLine.Modify;
                                end;
                            until SalesLine.Next = 0;
                    end;
                end;

                if "Tipo de Venta" = "Tipo de Venta"::Factura then begin
                    CantidadSol := SalesLine."Cantidad Solicitada";
                    if Cust.Get("Sell-to Customer No.") then
                        Validate("Gen. Bus. Posting Group", Cust."Gen. Bus. Posting Group");
                    SalesLine.Validate("Cantidad Solicitada", CantidadSol);
                end;
                //009
            end;
        }
        field(50011; "No. Bultos"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Cantidad para devolucion"; Decimal)
        {
            DataClassification = ToBeClassified;
            Enabled = false;
        }
        field(50013; "Cantidad en lineas"; Decimal)
        {
            CalcFormula = Sum("Sales Line".Quantity WHERE("Document Type" = FIELD("Document Type"),
                                                           "Document No." = FIELD("No."),
                                                           Type = FILTER(Item)));
            FieldClass = FlowField;
        }
        field(50014; "PO Box address"; Text[10])
        {
            Caption = 'PO Box address';
            DataClassification = ToBeClassified;
            Enabled = false;
        }
        field(50110; "No. Documento SIC"; Code[40])
        {
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM';
        }
        field(50111; "Source counter"; BigInteger)
        {
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM';

            trigger OnValidate()
            var
                Item: Record Item;
                "Min": Duration;
                Hora: Time;
            begin
            end;
        }
        field(50112; "Cod. Cajero"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM';
        }
        field(50113; "Cod. Supervisor"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM';
        }
        field(50114; "Error Registro"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM';
        }
        field(53002; "para que compilar pages"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(53005; "Importe ITBIS Incl."; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Amount Including VAT" WHERE("Document Type" = FIELD("Document Type"),
                                                                         "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(53009; "Factura en Historico"; Boolean)
        {
            CalcFormula = Exist("Sales Invoice Header" WHERE("No." = FIELD("Posting No."),
                                                              "No. Comprobante Fiscal" = FIELD("No. Comprobante Fiscal")));
            Caption = 'Invoice Posted';
            FieldClass = FlowField;
        }
        field(55000; "Sell-to Phone"; Code[30])
        {
            Caption = 'Sell-to Phone';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';

            trigger OnValidate()
            begin

                if "Venta Call Center" then  // 022-YFC
                    "Ship-to Phone" := "Sell-to Phone";
            end;
        }
        field(55001; "Ship-to Phone"; Code[30])
        {
            Caption = 'Ship-to Phone';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55002; "No. Correlativo Rem. a Anular"; Code[20])
        {
            Caption = 'Remision Correlative No. to Void';
            DataClassification = ToBeClassified;
        }
        field(55003; "No. Correlativo Rem. Anulado"; Code[20])
        {
            Caption = 'Remision Correlative No. Voided';
            DataClassification = ToBeClassified;
        }
        field(55004; "No. documento Rem. a Anular"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Shipment Header"."No." WHERE("Remision Anulada" = FILTER(false));

            trigger OnValidate()
            begin
                //015
                TestField(Correction);
                if SSH.Get("No. documento Rem. a Anular") then
                    "No. Correlativo Rem. a Anular" := SSH."No. Comprobante Fisc. Remision"
                else
                    "No. Correlativo Rem. a Anular" := '';
                //015
            end;
        }
        field(55005; "No. Correlativo Fact. a Anular"; Code[20])
        {
            Caption = 'Invoice Correlative No. to Void';
            DataClassification = ToBeClassified;
        }
        field(55006; "No. Factura a Anular"; Code[20])
        {
            Caption = 'Invoice No. To Void';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Invoice Header"."No." WHERE("Factura Anulada" = FILTER(false));

            trigger OnValidate()
            begin
                //015
                TestField(Correction);
                if SIH.Get("No. Factura a Anular") then
                    "No. Correlativo Fact. a Anular" := SIH."No. Comprobante Fiscal"
                else
                    "No. Correlativo Fact. a Anular" := '';
                //015
            end;
        }
        field(55007; "Siguiente No. Remision"; Code[20])
        {
            CalcFormula = Lookup("No. Series Line"."Last No. Used" WHERE("Series Code" = FIELD("No. Serie NCF Remision")));
            Caption = 'Next remission No.';
            FieldClass = FlowField;
        }
        field(55008; "No. Nota Credito a Anular"; Code[20])
        {
            Caption = 'Credit Memo to Void';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Cr.Memo Header";

            trigger OnValidate()
            begin
                //015
                if SCMH.Get("No. Nota Credito a Anular") then begin
                    if NCFAnulados.Get("No. Nota Credito a Anular", SCMH."No. Comprobante Fiscal") then
                        Error(Error007, SCMH."No. Comprobante Fiscal");
                    "Correlativo NCR a Anular" := SCMH."No. Comprobante Fiscal"
                end
                else
                    "Correlativo NCR a Anular" := '';
                //015
            end;
        }
        field(55009; "Correlativo NCR a Anular"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(55010; "No. Autorizacion Comprobante"; Code[49])
        {
            Caption = 'Authorization Voucher No.';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55012; "Tipo de Comprobante"; Code[2])
        {
            Caption = 'Voucher Type';
            DataClassification = ToBeClassified;
            Description = 'SRI';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("TIPOS COMPROBANTES AUTORIZADOS"));
        }
        field(55013; "Establecimiento Factura"; Code[3])
        {
            Caption = 'Invoice Location';
            DataClassification = ToBeClassified;
            Description = 'SRI';

            trigger OnValidate()
            begin
                TestField("No. Serie NCF Facturas");
                NoSeriesLine.Reset;
                NoSeriesLine.SetRange("Series Code", "No. Serie NCF Facturas");
                NoSeriesLine.SetRange(Establecimiento, "Establecimiento Factura");
                NoSeriesLine.FindFirst;
            end;
        }
        field(55014; "Punto de Emision Factura"; Code[3])
        {
            Caption = 'Invoice Issue Point';
            DataClassification = ToBeClassified;
            Description = 'SRI';

            trigger OnValidate()
            begin
                //017
                TestField("No. Serie NCF Facturas");
                TestField("Establecimiento Factura");
                NoSeriesLine.Reset;
                NoSeriesLine.SetRange("Series Code", "No. Serie NCF Facturas");
                NoSeriesLine.SetRange(Establecimiento, "Establecimiento Factura");
                NoSeriesLine.SetRange("Punto de Emision", "Punto de Emision Factura");
                NoSeriesLine.FindFirst;
                //017
            end;
        }
        field(55015; "Establecimiento Remision"; Code[3])
        {
            Caption = 'Shipment Location';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55016; "Punto de Emision Remision"; Code[3])
        {
            Caption = 'Shipment Issue Point';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55017; "No. Autorizacion Remision"; Code[49])
        {
            Caption = 'Remission Auth. No.';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55018; "Tipo Comprobante Remision"; Code[2])
        {
            Caption = 'Remission Voucher Type';
            DataClassification = ToBeClassified;
            Description = 'SRI';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("TIPOS COMPROBANTES AUTORIZADOS"));
        }
        field(55021; "No. Telefono (Obsoleto)"; Code[13])
        {
            Caption = 'Phone';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            Enabled = false;
        }
        field(55022; "Tipo Ruc/Cedula"; Option)
        {
            Caption = 'RUC/ID Type';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            OptionCaption = ' ,R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA,R.U.C. PUBLICOS,RUC PERSONA NATURAL,ID';
            OptionMembers = " ","R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA","R.U.C. PUBLICOS","RUC PERSONA NATURAL",CEDULA;

            trigger OnValidate()
            begin
                //CLEAR("VAT Registration No.");//016
                // ++ 022-YFC
                if "Venta Call Center" then begin
                    if Confirm(txt002_SRI, false) then begin
                        //VALIDATE("VAT Registration No.",'');
                        if "Tipo Ruc/Cedula" = "Tipo Ruc/Cedula"::CEDULA then
                            "Tipo Documento SrI" := "Tipo Documento SrI"::Cedula;

                        if ("Tipo Ruc/Cedula" <> "Tipo Ruc/Cedula"::CEDULA) and ("Tipo Ruc/Cedula" <> "Tipo Ruc/Cedula"::" ") then
                            "Tipo Documento SrI" := "Tipo Documento SrI"::RUC;
                    end
                    else
                        "Tipo Ruc/Cedula" := xRec."Tipo Ruc/Cedula";
                end
                // -- 022-YFC
            end;
        }
        field(55023; "No. Validar Comprobante Rel."; Boolean)
        {
            Caption = 'Not validate Rel. Fiscal Document ';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55024; "Nombre Vendedor"; Text[50])
        {
            CalcFormula = Lookup("Salesperson/Purchaser".Name WHERE(Code = FIELD("Salesperson Code")));
            Caption = 'Salesperson Name';
            Description = 'Ecuador';
            FieldClass = FlowField;
        }
        field(55025; "Fecha Caducidad Comprobante"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55026; "Con Refrendo"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ATS';

            trigger OnValidate()
            begin
                ValidaRefrendo;
            end;
        }
        field(55027; "Valor FOB"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ATS';
        }
        field(55028; "Nº Documento Transporte"; Text[17])
        {
            DataClassification = ToBeClassified;
            Description = 'ATS';
        }
        field(55029; "Fecha embarque"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ATS';
        }
        field(55031; "Order Time"; Time)
        {
            Caption = 'Order Time';
            DataClassification = ToBeClassified;
            Description = '#13586';
        }
        field(55032; "Posting Time"; Time)
        {
            Caption = 'Posting Time';
            DataClassification = ToBeClassified;
            Description = '#13586';
        }
        field(55033; "Shipment Time"; Time)
        {
            Caption = 'Shipment Time';
            DataClassification = ToBeClassified;
            Description = '#13586';
        }
        field(55034; "Exportación"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ValidaExportac;
                ValidaRefrendo;
            end;
        }
        field(55035; "No. refrendo - distrito adua."; Code[3])
        {
            DataClassification = ToBeClassified;
            Description = '#45090';
        }
        field(55036; "No. refrendo - Año"; Code[4])
        {
            DataClassification = ToBeClassified;
        }
        field(55037; "No. refrendo - regimen"; Code[2])
        {
            DataClassification = ToBeClassified;
        }
        field(55038; "No. refrendo - Correlativo"; Code[8])
        {
            DataClassification = ToBeClassified;
        }
        field(55039; "Valor FOB Comprobante Local"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55040; "Establecimiento Fact. Rel"; Code[3])
        {
            Caption = 'Establecimiento Factura Relacionada';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55041; "Punto de Emision Fact. Rel."; Code[3])
        {
            Caption = 'Punto de Emisión Factura Relacionda';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55042; "Tipo Exportacion"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ATS';
            OptionCaption = ' ,01,02,03';
            OptionMembers = " ","01","02","03";

            trigger OnValidate()
            begin
                ValidaRefrendo;  //#34853
            end;
        }
        field(55045; "Fecha inicio trans."; Date)
        {
            Caption = 'Fecha inicio transporte';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55046; "Fecha fin trans."; Date)
        {
            Caption = 'Fecha fin transporte';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55047; "Tipo Documento SrI"; Option)
        {
            Caption = 'Document Type Srl';
            DataClassification = ToBeClassified;
            Description = 'SRI-SANTINAV-1392';
            OptionCaption = 'VAT,ID,Passport';
            OptionMembers = RUC,Cedula,Pasaporte;

            trigger OnValidate()
            begin

                // ++ 022 YFC
                if "Venta Call Center" then begin
                    if Confirm(txt001_SRI, false) then begin
                        "VAT Registration No." := '';
                        "Tipo Ruc/Cedula" := 0;
                        if "Tipo Documento SrI" = "Tipo Documento SrI"::Cedula then
                            "Tipo Ruc/Cedula" := 4;
                    end
                    else
                        "Tipo Documento SrI" := xRec."Tipo Documento SrI";
                end
                // -- 022 YFC
            end;
        }
        field(55048; "Numero Guia"; Code[18])
        {
            Caption = 'Número de Guía';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-1401';
        }
        field(55049; "Nombre Guia"; Code[20])
        {
            Caption = 'Nombre de Guía';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-1401';
        }
        field(56000; "Pedido Consignacion"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //005
                SalesHeader.Reset;
                SalesHeader.SetRange("Document Type", "Document Type");
                SalesHeader.SetFilter("No.", '<>%1', "No.");
                SalesHeader.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                SalesHeader.SetRange("Pedido Consignacion", true);
                if (SalesHeader.FindFirst) and ("Pedido Consignacion") then
                    Error(Error002, SalesHeader."No.");
                //005

                //006
                TransferHeader.Reset;
                TransferHeader.SetRange("Transfer-from Code", "Sell-to Customer No.");
                TransferHeader.SetRange("Devolucion Consignacion", true);
                if TransferHeader.FindFirst then
                    Error(Error003, TransferHeader."No.");
                //006

                //001 - Al inidicar que el pedido es de consignacion se eliminan las
                //      las lineas de venta si es que hay. Por control
                if "Pedido Consignacion" then begin
                    SalesLine.Reset;
                    SalesLine.SetRange("Document Type", "Document Type");
                    SalesLine.SetRange("Document No.", "No.");
                    if SalesLine.FindFirst then begin
                        if Confirm(txt001, true, false) then begin
                            SalesLine.Reset;
                            SalesLine.SetRange("Document Type", "Document Type");
                            SalesLine.SetRange("Document No.", "No.");
                            if SalesLine.FindSet then
                                repeat
                                    SalesLine1.Get(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.");
                                    SalesLine1.Delete(true);
                                until SalesLine.Next = 0;
                        end
                        else
                            "Pedido Consignacion" := false;
                    end;
                end;

                //001 - Se cambia el almacen por el del cliente, desde el cual va a salir la mercancia
                if "Pedido Consignacion" then
                    Validate("Location Code", "Sell-to Customer No.")
            end;
        }
        field(56001; "Collector Code"; Code[10])
        {
            Caption = 'Collector code';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code WHERE(Tipo = FILTER(Cobrador));
        }
        field(56002; "Pre pedido"; Boolean)
        {
            Caption = 'Pre Order';
            DataClassification = ToBeClassified;
        }
        field(56003; "Devolucion Consignacion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(56004; "Cod. Cupon"; Code[10])
        {
            Caption = 'Coupon Code';
            DataClassification = ToBeClassified;
        }
        field(56005; "Siguiente No."; Code[20])
        {
            CalcFormula = Lookup("No. Series Line"."Last No. Used" WHERE("Series Code" = FIELD("No. Serie NCF Facturas"),
                                                                          Open = FILTER(true)));
            FieldClass = FlowField;
        }
        field(56006; "Cod. Colegio"; Code[20])
        {
            Caption = 'School Code';
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM:Se quita filtro company:Contact WHERE (Type=FILTER(Company))';
            TableRelation = Contact;

            trigger OnValidate()
            begin
                //004
                if Contacto.Get("Cod. Colegio") then
                    "Nombre Colegio" := Contacto.Name;
                //004
            end;
        }
        field(56007; "Nombre Colegio"; Text[100])
        {
            Caption = 'School Name';
            DataClassification = ToBeClassified;
            Description = '039: Se amplía longitudo al campo de 60 a 100';
        }
        field(56008; "Re facturacion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(56010; CAE; Text[160])
        {
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56011; "Respuesta CAE"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56012; pIdSat; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56013; "No. Resolucion"; Code[30])
        {
            Caption = 'Resolution No.';
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56014; "Fecha Resolucion"; Date)
        {
            Caption = 'Resolution Date';
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56015; "Serie Desde"; Code[20])
        {
            Caption = 'Series From';
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56016; "Serie hasta"; Code[20])
        {
            Caption = 'Serie To';
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56017; "Serie Resolucion"; Code[20])
        {
            Caption = 'Resolution Serie';
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56018; CAEC; Text[160])
        {
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56020; "No aplica Derechos de Autor"; Boolean)
        {
            Caption = 'Apply Author Copyright';
            DataClassification = ToBeClassified;
            Description = 'DerAut 1.0';
        }
        field(56021; Promocion; Boolean)
        {
            Caption = 'Promotion';
            DataClassification = ToBeClassified;
        }
        field(56032; "Fecha Recepcion"; Date)
        {
            Caption = 'Reception Date';
            DataClassification = ToBeClassified;
        }
        field(56033; "Siguiente No. Nota. Cr."; Code[20])
        {
            CalcFormula = Lookup("No. Series Line"."Last No. Used" WHERE("Series Code" = FIELD("No. Serie NCF Abonos"),
                                                                          Open = FILTER(true)));
            FieldClass = FlowField;
        }
        field(56042; "Creado por usuario"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = User;

            trigger OnLookup()
            begin
                //LoginMgt.LookupUserID("Creado por usuario");
            end;
        }
        field(56062; "Cantidad de Bultos"; Integer)
        {
            Caption = 'Packages Qty.';
            DataClassification = ToBeClassified;
            Enabled = false;
        }
        field(56070; "No. Envio de Almacen"; Code[20])
        {
            Caption = 'Warehouse Shipment No.';
            DataClassification = ToBeClassified;
            TableRelation = "Warehouse Shipment Header";
        }
        field(56071; "No. Picking"; Code[20])
        {
            Caption = 'Pciking No.';
            DataClassification = ToBeClassified;
            TableRelation = "Warehouse Activity Header";
        }
        field(56072; "No. Picking Reg."; Code[20])
        {
            Caption = 'Posted Picking No.';
            DataClassification = ToBeClassified;
            TableRelation = "Registered Whse. Activity Hdr."."No.";
        }
        field(56073; "No. Packing"; Code[20])
        {
            Caption = 'Packing No.';
            DataClassification = ToBeClassified;
            TableRelation = "Cab. Packing";
        }
        field(56074; "No. Packing Reg."; Code[20])
        {
            Caption = 'Posted Packing No.';
            DataClassification = ToBeClassified;
            TableRelation = "Cab. Packing Registrado"."No.";
        }
        field(56075; "No. Factura"; Code[20])
        {
            Caption = 'Invoice No.';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Invoice Header";
        }
        field(56076; "No. Envio"; Code[20])
        {
            Caption = 'Shippment No.';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Shipment Header"."No.";
        }
        field(56077; "% de aprobacion"; Decimal)
        {
            Caption = 'Approval %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            var
                SalesLineCant: Record "Sales Line";
                CounterTotal: Integer;
                Counter: Integer;
                Window: Dialog;
                Text0001: Label 'Updating  #1########## @2@@@@@@@@@@@@@';
            begin
                // ++ 032-YFC
                BloqueoFacturacion(Rec, true);
                // -- 032-YFC

                SalesLineCant.Reset;
                SalesLineCant.SetRange("Document Type", "Document Type");
                SalesLineCant.SetRange("Document No.", "No.");
                if SalesLineCant.FindSet(true) then
                    repeat
                        //SalesLineCant.VALIDATE(Quantity,0);
                        SalesLineCant.Validate("Porcentaje Cant. Aprobada", 0);
                        SalesLineCant.Modify;
                    until SalesLineCant.Next = 0;

                begin
                    SalesLineCant.Reset;
                    SalesLineCant.SetRange("Document Type", "Document Type");
                    SalesLineCant.SetRange("Document No.", "No.");
                    //SalesLineCant.SETRANGE("Porcentaje Cant. Aprobada",0);
                    if SalesLineCant.FindSet(true) then begin
                        CounterTotal := Count;
                        Window.Open(Text0001);
                        repeat
                            Counter := Counter + 1;
                            Window.Update(1, SalesLineCant."Line No.");
                            Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                            SalesLineCant.Validate("Porcentaje Cant. Aprobada", "% de aprobacion");
                            SalesLineCant.Modify;
                            Commit;
                        until SalesLineCant.Next = 0;
                    end;
                end;

                //CGA "% de aprobacion" := 0; //037+-

                //MOI - 09/12/2014 (#7419):Inicio
                // <#71176  JPT 29/06/2017>   Comentamos el código

                //IF xRec."% de aprobacion"<>"% de aprobacion" THEN
                //BEGIN
                //  "Fecha Aprobacion":=WORKDATE;
                //  "Hora Aprobacion":=TIME;
                //END;

                // </#71176  JPT 29/06/2017>
                //MOI - 09/12/2014 (#7419):Fin
            end;
        }
        field(56078; "Fecha Lanzado"; Date)
        {
            Caption = 'Released Date';
            DataClassification = ToBeClassified;
        }
        field(56079; "Hora Lanzado"; Time)
        {
            Caption = 'Released Time';
            DataClassification = ToBeClassified;
        }
        field(56098; "En Hoja de Ruta"; Boolean)
        {
            Caption = 'In Route Sheet';
            DataClassification = ToBeClassified;
            Enabled = false;
        }
        field(56100; "Fecha Aprobacion"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(56101; "Hora Aprobacion"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(56102; "Fecha Creacion Pedido"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = '#71176';
            Editable = false;
        }
        field(56200; "NCF en Historico"; Boolean)
        {
            CalcFormula = Exist("Sales Invoice Header" WHERE("No. Comprobante Fiscal" = FIELD("No. Comprobante Fiscal"),
                                                              "No. Autorizacion Comprobante" = FIELD("No. Autorizacion Comprobante"),
                                                              "Punto de Emision Factura" = FIELD("Punto de Emision Factura"),
                                                              "Establecimiento Factura" = FIELD("Establecimiento Factura")));
            FieldClass = FlowField;
        }
        field(56201; "NCF en Historico Notas Cred."; Boolean)
        {
            CalcFormula = Exist("Sales Cr.Memo Header" WHERE("No. Comprobante Fiscal" = FIELD("No. Comprobante Fiscal"),
                                                              "No. Autorizacion Comprobante" = FIELD("No. Autorizacion Comprobante"),
                                                              "Punto de Emision Factura" = FIELD("Punto de Emision Factura"),
                                                              "Establecimiento Factura" = FIELD("Establecimiento Factura")));
            FieldClass = FlowField;
        }
        field(56300; "Venta Call Center"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '#830';
        }
        field(56301; "Pago recibido"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '#830';
        }
        field(56302; "Aprobado cobros"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '#830';
            Editable = false;
        }
        field(56303; "Procesar EAN-Picking Masivo"; Boolean)
        {
            Caption = 'Procesar EAN-Picking Masivo';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-1410';
        }
        field(56304; "Estatus EAN-Picking Masivo"; Option)
        {
            Caption = 'Estatus EAN-Picking Masivo';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-2115';
            OptionCaption = ' ,Procesado';
            OptionMembers = " ",Procesado;
        }
        field(56305; "Grupo de Negocio"; Code[20])
        {
            Caption = 'Business Group';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-2524';

            trigger OnLookup()
            var
                DatosAuxiliares: Record "Datos auxiliares";
                UserSetup: Record "User Setup";
                GrupoNeogocio: Page "Grupo Neogocio auxiliares";
            begin
                /*
                // YFC
                IF UserSetup.GET(USERID) THEN;
                DatosAuxiliares.RESET;
                DatosAuxiliares.SETRANGE("Tipo registro",DatosAuxiliares."Tipo registro"::"Grupo de Negocio");
                IF UserSetup."Filtro Grupo Negocio" THEN
                  DatosAuxiliares.SETRANGE(Mostrar,UserSetup."Filtro Grupo Negocio");
                IF DatosAuxiliares.FINDSET THEN;
                
                  GrupoNeogocio.SETRECORD(DatosAuxiliares);
                  GrupoNeogocio.SETTABLEVIEW(DatosAuxiliares);
                  GrupoNeogocio.LOOKUPMODE(TRUE);
                  IF GrupoNeogocio.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    GrupoNeogocio.GETRECORD(DatosAuxiliares);
                    VALIDATE("Grupo de Negocio",DatosAuxiliares.Codigo);
                  END;
                // YFC
                */

            end;
        }
        field(76046; "ID Cajero"; Code[20])
        {
            Caption = 'Cashier ID';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
            TableRelation = Cajeros.ID WHERE(Tienda = FIELD(Tienda));
        }
        field(76029; "Hora creacion"; Time)
        {
            Caption = 'Creation time';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76011; "Venta TPV"; Boolean)
        {
            Caption = 'POS Sales';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76016; TPV; Code[20])
        {
            Caption = 'POS';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
            TableRelation = "Configuracion TPV"."Id TPV" WHERE(Tienda = FIELD(Tienda));
        }
        field(76018; Tienda; Code[20])
        {
            Caption = 'Shop';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
            TableRelation = Tiendas."Cod. Tienda";
        }
        field(76015; "Venta a credito"; Boolean)
        {
            Caption = 'Venta a credito';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76027; "Registrado TPV"; Boolean)
        {
            Caption = 'Registrado TPV';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76025; "Anulado TPV"; Boolean)
        {
            Caption = 'Anulado TPV';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76017; "No. Fiscal TPV"; Code[25])
        {
            Caption = 'Nº Fiscal TPV';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76021; Turno; Integer)
        {
            Caption = 'Turno';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76030; "Anulado por Documento"; Code[20])
        {
            Caption = 'Anulado por Documento';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76295; "Anula a Documento"; Code[20])
        {
            Caption = 'Anula a Documento';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76227; Devolucion; Boolean)
        {
            Caption = 'Devolucion';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76313; "No. Telefono"; Text[25])
        {
            Caption = 'Nº Telefono';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76228; "Replicado POS"; Boolean)
        {
            Caption = 'Replicado POS';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76315; "E-Mail"; Text[40])
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76019; Aparcado; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76004; "Tipo venta TPV"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Consumidor final","Credito fiscal";
        }
        field(76041; "No. Serie NCF Facturas"; Code[20])
        {
            Caption = 'NCF Invoice Series No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
            TableRelation = IF ("Document Type" = CONST(Quote)) "No. Series" WHERE("Tipo Documento" = CONST(Factura))
            ELSE
            IF ("Document Type" = CONST(Order)) "No. Series" WHERE("Tipo Documento" = CONST(Factura))
            ELSE
            IF ("Document Type" = CONST(Invoice)) "No. Series" WHERE("Tipo Documento" = CONST(Factura))
            ELSE
            IF ("Document Type" = CONST("Credit Memo")) "No. Series" WHERE("Tipo Documento" = CONST("Nota de Crédito"))
            ELSE
            IF ("Document Type" = CONST("Blanket Order")) "No. Series" WHERE("Tipo Documento" = CONST(Factura))
            ELSE
            IF ("Document Type" = CONST("Return Order")) "No. Series" WHERE("Tipo Documento" = CONST("Nota de Crédito"));

            trigger OnValidate()
            begin

                //005
                if NoSeries.Get("No. Serie NCF Facturas") then begin
                    if ("Document Type" = "Document Type"::Order) or ("Document Type" = "Document Type"::Invoice) then
                        NoSeries.TestField("Tipo Documento", NoSeries."Tipo Documento"::Factura);
                    if ("Document Type" = "Document Type"::"Credit Memo") or ("Document Type" = "Document Type"::"Return Order") then
                        NoSeries.TestField("Tipo Documento", NoSeries."Tipo Documento"::"Nota de Crédito");

                    NoSeriesLine.Reset;
                    NoSeriesLine.SetRange("Series Code", "No. Serie NCF Facturas");
                    NoSeriesLine.SetRange(Open, true);
                    NoSeriesLine.FindLast;
                    if not NoSeries."Facturacion electronica" then  //$021
                        NoSeriesLine.TestField("No. Autorizacion");
                    NoSeriesLine.TestField(Establecimiento);
                    NoSeriesLine.TestField("Punto de Emision");
                    "Establecimiento Factura" := NoSeriesLine.Establecimiento;
                    "Punto de Emision Factura" := NoSeriesLine."Punto de Emision";
                    "No. Autorizacion Comprobante" := NoSeriesLine."No. Autorizacion";

                end;
                //005
            end;
        }
        field(76079; "No. Comprobante Fiscal"; Code[40])
        {
            Caption = 'Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01,JERM-SIC';
            Editable = false;

            trigger OnValidate()
            var
                Texto001: Label 'El campo No. Comprobante fiscal debe contener 9 digitos.';
            begin

                //+#43088
                if "No. Comprobante Fiscal" <> '' then
                    if StrLen("No. Comprobante Fiscal") <> 9 then
                        Error(Texto001);
                //-#43088

                //Ecuador
                //Se busca el No. de Autorizacion. Santillana Ecuador
                NoSeriesLine.Reset;
                //NoSeriesLine.SETRANGE("Series Code",NoSerieNCF);
                NoSeriesLine.SetFilter("Starting No.", '<=%1', "No. Comprobante Fiscal");
                NoSeriesLine.SetFilter("Ending No.", '>=%1', "No. Comprobante Fiscal");
                NoSeriesLine.SetRange("No. Autorizacion", "No. Autorizacion Comprobante");
                NoSeriesLine.FindFirst;
                NoSeriesLine.TestField("No. Autorizacion");
                NoSeriesLine.TestField(Establecimiento);
                NoSeriesLine.TestField("Punto de Emision");
                NoSeriesLine.TestField("Tipo Comprobante");
                "No. Autorizacion Comprobante" := NoSeriesLine."No. Autorizacion";
                "Tipo de Comprobante" := NoSeriesLine."Tipo Comprobante";
                "Establecimiento Factura" := NoSeriesLine.Establecimiento;
                "Punto de Emision Factura" := NoSeriesLine."Punto de Emision";
            end;
        }
        field(76080; "No. Comprobante Fiscal Rel."; Code[40])
        {
            Caption = 'Rel. Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01,JERM-SIC';
            Editable = false;

            trigger OnValidate()
            var
                cuLocalizacion: Codeunit "Validaciones Localizacion";
            begin
                //DSLoc2.0
                cuLocalizacion.ValidaNCFRelacionadoVentas(Rec);

                // ++ 031-YFC
                if ("Document Type" = "Document Type"::"Return Order") and ("Applies-to Doc. No." = '') then begin
                    ConsultarSIH.Reset;
                    ConsultarSIH.SetCurrentKey("Sell-to Customer No.", "No. Comprobante Fiscal");
                    ConsultarSIH.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                    ConsultarSIH.SetRange("No. Comprobante Fiscal", "No. Comprobante Fiscal Rel.");
                    if ConsultarSIH.FindFirst then
                        Validate("Salesperson Code", ConsultarSIH."Salesperson Code");
                end;
                // -- 031-YFC
            end;
        }
        field(76056; "Razon anulacion NCF"; Code[20])
        {
            Caption = 'NCF Void Reason';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
            TableRelation = "Razones Anulacion NCF";
        }
        field(76057; "No. Serie NCF Abonos"; Code[20])
        {
            Caption = 'No. Serie NCF Abonos';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin

                //005
                if NoSeries.Get("No. Serie NCF Abonos") then begin
                    if ("Document Type" = "Document Type"::Order) or ("Document Type" = "Document Type"::Invoice) then
                        NoSeries.TestField("Tipo Documento", NoSeries."Tipo Documento"::Factura);
                    if ("Document Type" = "Document Type"::"Credit Memo") or ("Document Type" = "Document Type"::"Return Order") then
                        NoSeries.TestField("Tipo Documento", NoSeries."Tipo Documento"::"Nota de Crédito");
                end;
                //005

                //007
                Correction := false;
                //007
            end;
        }
        field(76078; "Cod. Clasificacion Gasto"; Code[2])
        {
            Caption = 'Expense Clasification Code';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
        }
        field(76058; "Ultimo. No. NCF"; Code[19])
        {
            DataClassification = ToBeClassified;
        }
        field(76007; "Tipo de ingreso"; Code[2])
        {
            Caption = 'Income type';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
            InitValue = '01';
            TableRelation = "Tipos de ingresos";
        }
        field(76003; "Fecha vencimiento NCF"; Date)
        {
            Caption = 'NCF Due date';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
        }
        field(76006; "No. Serie NCF Remision"; Code[10])
        {
            Caption = 'Remission Series No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series" WHERE("Tipo Documento" = CONST(Remision));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                Err100: Label 'La serie Seleccionada no corresponde a Remisiones.';
            begin
            end;
        }
        field(76088; "No. Comprobante Fisc. Remision"; Code[20])
        {
            Caption = 'Remission NCF';
            DataClassification = ToBeClassified;
        }
        field(50001; "Prepmt Sales Tax Round Amt 2"; Decimal)
        {
            Caption = 'Prepayment Sales Tax Rounding Amount';
        }
        field(50002; SetIgnorarControles; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {

        key(Key7; "ID Cajero", "Venta TPV")
        {
        }
        key(Key21; "Venta TPV")
        {
        }
        key(Key9; "Venta TPV", "No. Fiscal TPV")
        {
        }

        key(Key11; "Venta TPV", Tienda, "Registrado TPV")
        {
        }
        key(Key25; "Replicado POS")
        {
        }
        key(Key13; "No. Documento SIC", "Venta TPV")
        {
        }
        key(Key14; "Posting Date")
        {
        }
    }


    trigger OnDelete()
    var
        userSetupMgt: Codeunit "User Setup Management";
        Text022: Label 'No se puede eliminar el pedido porque el centro de responsabilidad no es el mismo que el del usuario.';
    begin
        // Validar el centro de responsabilidad del usuario
        if not UserSetupMgt.CheckRespCenter(0, "Responsibility Center") then
            Error(Text022);

        // Si el tipo de documento es "Return Order", controlar la clasificación de devoluciones
        if "Document Type" = "Document Type"::"Return Order" then
            ControlClasificacionDevolucion(true);

    end;


    trigger OnInsert()
    var
        rConf: Record "Config. Empresa";
    begin


        // Asignar un vendedor predeterminado si no se especifica
        if "Salesperson Code" = '' then
            SetDefaultSalesperson;

        // Si es una "Venta Call Center", asignar valores adicionales
        if "Venta Call Center" then begin
            rConf.Get;
            rConf.TestField("Cód Cliente Call Center");
            Validate("Sell-to Customer No.", rConf."Cód Cliente Call Center");
            "Pago recibido" := true;
        end;

        // Asignar la fecha de creación del pedido si no está definida
        if "Fecha Creacion Pedido" = 0DT then
            "Fecha Creacion Pedido" := RoundDateTime(CreateDateTime(WorkDate, Time), 1000000);

        // Si el tipo de documento es "Order" o "Invoice", habilitar el procesamiento masivo de EAN-Picking
        if "Document Type" in ["Document Type"::Order, "Document Type"::Invoice] then
            "Procesar EAN-Picking Masivo" := true;

        // Eliminar filtros de vista para evitar notificaciones de vistas filtradas
        SetView('');
    end;


    trigger OnModify()
    begin
        // Si el tipo de documento es "Return Order", controlar la clasificación de devoluciones
        if "Document Type" = "Document Type"::"Return Order" then
            ControlClasificacionDevolucion(false);

        // Validar el campo "No. Comprobante Fiscal Rel."
        Validate("No. Comprobante Fiscal Rel.");
        "Posting Time" := Time;
    end;


    procedure CopyCFDIFieldsFromCustomer()
    var
        Customer: Record Customer;
    begin
        // Verificar si el cliente "Bill-to Customer No." existe
        // if Customer.Get("Bill-to Customer No.") then begin
        //     "CFDI Purpose" := Customer."CFDI Purpose";
        //     "CFDI Relation" := Customer."CFDI Relation";
        //     "CFDI Export Code" := Customer."CFDI Export Code";
        // end
        // // Si no, verificar si el cliente "Sell-to Customer No." existe
        // else if Customer.Get("Sell-to Customer No.") then begin
        //     "CFDI Purpose" := Customer."CFDI Purpose";
        //     "CFDI Relation" := Customer."CFDI Relation";
        //     "CFDI Export Code" := Customer."CFDI Export Code";
        // end
        // // Si ninguno de los dos clientes existe, limpiar los campos
        // else begin
        //     "CFDI Purpose" := '';
        //     "CFDI Relation" := '';
        //     "CFDI Export Code" := '';
        // end;
    end;




    // Enviar la notificación

    local procedure ModifyCustomerAddress()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
    begin
        // Obtener la configuración de ventas


        // Si es un documento de crédito, salir
        if IsCreditDocType then
            exit;

    end;

    local procedure CalcQuoteValidUntilDate()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        // Obtener la configuración de ventas
        salesSetup.Get();
        // Calcular la fecha de validez de la cotización si la fórmula no está vacía
        if FORMAT(SalesSetup."Quote Validity Calculation") <> '' then
            "Quote Valid Until Date" := CalcDate(SalesSetup."Quote Validity Calculation", "Document Date");
    end;

    procedure ControlClasificacionDevolucion(Elim: Boolean)
    var
        recDocClas: Record "Docs. clas. devoluciones";
        lrUserSetup: Record "User Setup";
        SalesLine: Record "Sales Line";
        SL: Record "Sales Line";
        text001_local: Label 'No posee permisos para borrar Devoluciones de ClasDev';
        Eliminar: Boolean;
    begin
        // ++ 026
        if not PrimeraVez then begin
            Clear(Eliminar);
            Eliminar := Elim;

            if lrUserSetup.Get(UserId) then;
            //IF (NOT lrUserSetup."Borra Devoluciones venta") AND (Eliminar = TRUE) THEN
            //  ERROR(text001_local);

            recDocClas.Reset;
            recDocClas.SetRange("Tipo documento", recDocClas."Tipo documento"::Venta);
            recDocClas.SetRange("No. documento", "No.");
            if recDocClas.FindFirst then begin
                if Eliminar and (lrUserSetup."Borra Devoluciones venta") then begin
                    SL.Reset;
                    //message('%1',SL.count);
                    SL.SetCurrentKey("Document Type", "Document No.", "Line No.");
                    SL.SetRange(SL."Document Type", Rec."Document Type");
                    SL.SetRange(SL."Document No.", Rec."No.");
                    // SL.SETRANGE(SL."Line No.",10000);//;
                    SL.SetRange(SL."Clas Dev", true);

                    if SL.FindSet then
                        repeat
                            Clasificaciondevoluciones.ActualizarTablaTempFacturas(Rec, recDocClas."Filtro Descuento", SL)
                        until SL.Next = 0;

                end
                else begin
                    if (Eliminar = true) then
                        Error(text001_local)
                    else
                        Error(Text56000, "No.");
                end
            end;
            PrimeraVez := true;
            // -- 026
        end
    end;

    procedure ValidaExportac()
    begin
        if not Exportación then begin
            "Valor FOB" := 0;
            "Valor FOB Comprobante Local" := 0;
            "Fecha embarque" := 0D;
            //#34853
            //VALIDATE("Con Refrendo",FALSE);
            Validate("Tipo Exportacion", 0);
        end;
    end;

    procedure ValidaRefrendo()
    begin

        //#34853
        //IF NOT "Con Refrendo" THEN BEGIN
        if "Tipo Exportacion" <> "Tipo Exportacion"::"01" then begin
            "No. refrendo - distrito adua." := '';
            "No. refrendo - Año" := '';
            "No. refrendo - regimen" := '';
            "No. refrendo - Correlativo" := '';
            "Nº Documento Transporte" := '';
        end;
    end;

    local procedure ShipToAddressEqualsOldSellToAddress(): Boolean
    begin
        exit(IsShipToAddressEqualToSellToAddress(xRec, Rec));
    end;

    local procedure IsShipToAddressEqualToSellToAddress(SalesHeaderWithSellTo: Record "Sales Header"; SalesHeaderWithShipTo: Record "Sales Header"): Boolean
    begin
        exit(
            (SalesHeaderWithSellTo."Sell-to Address" = SalesHeaderWithShipTo."Ship-to Address") and
            (SalesHeaderWithSellTo."Sell-to Address 2" = SalesHeaderWithShipTo."Ship-to Address 2") and
            (SalesHeaderWithSellTo."Sell-to City" = SalesHeaderWithShipTo."Ship-to City") and
            (SalesHeaderWithSellTo."Sell-to County" = SalesHeaderWithShipTo."Ship-to County") and
            (SalesHeaderWithSellTo."Sell-to Post Code" = SalesHeaderWithShipTo."Ship-to Post Code") and
            (SalesHeaderWithSellTo."Sell-to Country/Region Code" = SalesHeaderWithShipTo."Ship-to Country/Region Code") and
            (SalesHeaderWithSellTo."Sell-to Contact" = SalesHeaderWithShipTo."Ship-to Contact")
        );
    end;

    procedure UpdateShipToAddressFromSellToAddress(FieldNumber: Integer)
    begin
        if ("Ship-to Code" = '') and ShipToAddressEqualsOldSellToAddress then
            case FieldNumber of
                FieldNo("Ship-to Address"):
                    "Ship-to Address" := "Sell-to Address";
                FieldNo("Ship-to Address 2"):
                    "Ship-to Address 2" := "Sell-to Address 2";
                FieldNo("Ship-to City"), FieldNo("Ship-to Post Code"):
                    begin
                        "Ship-to City" := "Sell-to City";
                        "Ship-to Post Code" := "Sell-to Post Code";
                        "Ship-to County" := "Sell-to County";
                        "Ship-to Country/Region Code" := "Sell-to Country/Region Code";
                    end;
                FieldNo("Ship-to County"):
                    "Ship-to County" := "Sell-to County";
                FieldNo("Ship-to Country/Region Code"):
                    "Ship-to Country/Region Code" := "Sell-to Country/Region Code";
            end;
    end;

    procedure ConvertFecha(Fecha_: Text; FechaPedido_: Text): Date
    var
        Ano: Integer;
        Mes: Integer;
        Dia: Integer;
        Anotxt: Text[4];
        Mestxt: Text[2];
        Diatxt: Text[2];
        MesActual: Text[20];
    begin
        // ++ 032-YFC
        Anotxt := '20' + CopyStr(FechaPedido_, 7, 2);
        Evaluate(Ano, Anotxt);
        //MesActual := FORMAT(TODAY);
        //Mestxt := COPYSTR(MesActual,4,2);
        //Mestxt := COPYSTR(FechaPedido_ ,4,2); //040-YFC
        Mestxt := CopyStr(FechaPedido_, 1, 2); //040-YFC
        Evaluate(Mes, Mestxt);
        //Diatxt := COPYSTR(Fecha_,1,2); //040-YFC
        Diatxt := CopyStr(Fecha_, 4, 2); //040-YFC
        Evaluate(Dia, Diatxt);
        exit(DMY2Date(Dia, Mes, Ano));
        // -- 032-YFC
    end;

    procedure BloqueoFacturacion(PedidoVenta: Record "Sales Header"; PorcientoAprobacion: Boolean)
    var
        Customer: Record Customer;
        FuncionesEcuador: Codeunit "Funciones Ecuador";
        Text073: Label 'El cliente %1 no se le puede despachar y facturar hasta el primer día del siguiente mes';
        Text074: Label 'El cliente %1 tiene bloqueo de facturación';
        UltimoDiaMes: Date;
        FechaDesde: Date;
    begin
        // ++ 032-YFC

        case PedidoVenta."Document Type" of
            PedidoVenta."Document Type"::Order, PedidoVenta."Document Type"::Invoice:
                begin
                    Customer.Get(PedidoVenta."Sell-to Customer No.");
                    if Customer."Bloqueo de Facturar Desde" <> 0D then begin

                        //UltimoDiaMes := CALCDATE ('<CM>', TODAY);
                        UltimoDiaMes := CalcDate('<CM>', PedidoVenta."Posting Date");
                        FechaDesde := ConvertFecha(Format(Customer."Bloqueo de Facturar Desde"), Format(PedidoVenta."Posting Date"));
                        //IF ( FechaDesde <= PedidoVenta."Posting Date") AND  (UltimoDiaMes  >= PedidoVenta."Posting Date" )  THEN
                        if (FechaDesde <= Today) and (UltimoDiaMes >= Today) then begin
                            if PorcientoAprobacion and "Pre pedido" then
                                Message(Text073, PedidoVenta."Sell-to Customer No.")
                            else
                                Error(Text074, PedidoVenta."Sell-to Customer No.");
                        end
                    end
                end
        end;

        // -- 032-YFC
    end;

    //Unsupported feature: Deletion (VariableCollection) on "RecreateSalesLines(PROCEDURE 4).TempSalesCommentLine(Variable 1011)".


    var
        CustomerPostingGr: Record "Customer Posting Group";

    var
        rConf: Record "Config. Empresa";

    procedure WhseShpmntConflict(DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocNo: Code[20]; ShippingAdvice: Option Partial,Complete): Boolean
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        if ShippingAdvice <> ShippingAdvice::Complete then
            exit(false);
        WarehouseShipmentLine.SetCurrentKey("Source Type", "Source Subtype", "Source No.", "Source Line No.");
        WarehouseShipmentLine.SetRange("Source Type", DATABASE::"Sales Line");
        WarehouseShipmentLine.SetRange("Source Subtype", DocType);
        WarehouseShipmentLine.SetRange("Source No.", DocNo);
        if WarehouseShipmentLine.IsEmpty then
            exit(false);
        exit(true);
    end;


    //>>>> MODIFIED VALUE:
    //ValidVATNoMsg : ENU=The tax registration number is valid.;ESM=El RFC/Curp es válido.;FRC=Le numéro d'identification TVA est valide.;ENC=The GST/HST Registration Number is valid.;
    //Variable type has not been exported.

    //>>>> MODIFIED VALUE:
    //ConfirmEmptyEmailQst : @@@=%1 - Contact No., %2 - Email;ENU=Contact %1 has no email address specified. The value in the Email field on the sales order, %2, will be deleted. Do you want to continue?;ESM=El contacto %1 no tiene una dirección de correo electrónico especificada. Se eliminará el valor del campo Correo electrónico del pedido de venta, %2. ¿Desea continuar?;FRC=Le contact %1 n'a pas d'adresse de courriel spécifiée. La valeur du champ Courriel sur le document de vente, %2, sera supprimée. Souhaitez-vous continuer?;ENC=Contact %1 has no email address specified. The value in the Email field on the sales order, %2, will be deleted. Do you want to continue?;
    //Variable type has not been exported.

    var
        "*** Santillana ***": Integer;
        SantSetup: Record "Config. Empresa";
        SalesLine1: Record "Sales Line";
        GenBusPostGrp: Record "Gen. Business Posting Group";
        Cliente: Record Customer;
        Tienda: Record "Bancos tienda";
        TPV: Record Tiendas;
        TransferHeader: Record "Transfer Header";
        "**002**": Integer;
        DefDim: Record "Default Dimension";
        Contacto: Record Contact;
        "**005**": Integer;
        NoSeries: Record "No. Series";
        "**006**": Integer;
        PagosTPV: Record "Tipos de Tarjeta";
        "**007**": Integer;
        SIH: Record "Sales Invoice Header";
        NSL: Record "No. Series Line";
        CPG: Record "Customer Posting Group";
        Item: Record Item;
        UserSetUp: Record "User Setup";
        LoginMgt: Codeunit "User Management";
        SSH: Record "Sales Shipment Header";
        SCMH: Record "Sales Cr.Memo Header";
        NCFAnulados: Record "NCF Anulados";
        ValidaCampos: Codeunit "Valida Campos Requeridos";
        NoSeriesLine: Record "No. Series Line";
        FuncEcuador: Codeunit "Funciones Ecuador";
        CantidadSol: Decimal;
        Cantidad: Decimal;
        _TPV: Record Tiendas;
        ContacBusRel: Record "Contact Business Relation";
        MktSetUp: Record "Marketing Setup";
        Clasificaciondevoluciones: Codeunit "Clasificacion devoluciones";
        PrimeraVez: Boolean;
        ConsultarSIH: Record "Sales Invoice Header";
        Error0001: Label 'No puede modificar un pedido tipo TPV o Factura comprimida';
        txt001: Label 'Se eliminaran las líneas de ventas del pedido, confirma que desea continuar';
        Msg002: Label 'Existe otro pedido tipo Consignación para este Cliente - No. Pedido %1, desea continuar?';
        Msg003: Label 'Existe un pedido de Devolución de consignación en borrador para este cliente - No. Pedido %1, desea continuar?';
        Error002: Label 'Existe otro pedido tipo Consignacion para este cliente - No. Pedido %1';
        Error003: Label 'Existe un pedido de Devolucion de consignacion en borrador para este cliente - No. Pedido %1';
        Error004: Label 'The Invoice %1 does not belong to the customer %2';
        Error005: Label 'The Serial Number must be internal. This has an associated resolution.';
        Error006: Label 'El Número de serie debe ser interno. Este tiene Tipo Generación';
        Error007: Label 'Correlative No. %1 Is already voided. Check in Voided Correlative Table';
        Text56000: Label 'El documento %1 se generó automáticamente por clasificación de devoluciones. No es posible su modificación manual.';
        txt001_SRI: Label 'If modify Document Type it will delete the RUC/Cedula No. Vat Reg. No., Confirm that you want to proceed';
        txt002_SRI: Label 'Si modifica el Tipo RUC/Cédula No. de RUC/Cédula, Confirma que desea proceder';
}

