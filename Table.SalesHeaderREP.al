table 50036 "Sales Header REP"
{
    // Proyecto: Implementacion Microsoft Dynamics Nav
    // AMS     : Agustin Mendez
    // GRN     : Guillermo Roman
    // CAT     : Carlos Alonso
    // ------------------------------------------------------------------------
    // No.         Firma   Fecha         Descripcion
    // ------------------------------------------------------------------------
    // DSLoc1.01   GRN     09/01/2009    Para adicionar funcionalidad de Retenciones y NCF
    //             GRN     04/07/2011    Creacion de un nuevo tipo de documento para localizar Guatemala
    // 001         GRN     13/07/2011    Creacion de Pre pedidos
    // 003         AMS     18/07/2011    No se debe modificar el almacen en caso de que se cambie el cliente en Pedidos TPV.
    // 004         AMS     27/09/2011    Se Captura el nombre del colegio
    // 005         AMS     06/11/2011    Se valida el tipo de documento para en No. de Serie de NCF
    // 007         AMS     08/03/2012    Para anular facturas electronicas que no generaron timbre por
    //                                   problemas e NIT y no se pudieron timbrar luego.
    // 008         AMS     02/04/2012    Se llena el campo Aplica para derecho de autor y Promocion desde el grupo
    //                                   contable cliente.
    // 009         AMS     10/07/2012    Se actualiza el Grupo Negocio Cliente de la cabecera y lineas para en caso de que
    //                                   el tipo de venta sea muestra o donaciones
    // 011         AMS     07/01/2012    Datos provenientes de la ficha del cliente
    // 014         AMS     27/10/2012    Se valida campos requeridos
    // 015         AMS     29/10/2012    Anulacion NCF's
    // 016         AMS     15/03/2013    Control de Ruc y Cedula
    // 017         AMS     05/04/2013    Mantiene Cantidad solicitada al modificar  Tipo de Venta
    // 018         AMS     07/04/2013    Control de Establecimiento y Punto de emision
    // 019         AMS     31/01/2014    No. Serie NCR por TPV.
    // #1379       CAT     08/01/2014    Creación campo "Forma de Pago TPV"
    // 
    // #830        CAT     24/04/2014
    // Creación campos:
    //   56300 Venta Call Center Boolean
    //   56301 Pago recibido Boolean
    //   56302 Aprobado cobros Boolean
    // 
    // 020         JML     24/04/2014    Clasificación de devoluciones
    // 
    // 
    // MOI - 09/12/2014 (#7419): Se añaden los campos Fecha Aprobacion, Hora Aprobacion.
    //                           En el OnValidate del campo "% Aprobacion" se añade la asignacion de los campos.

    Caption = 'Sales Header';
    DataCaptionFields = "No.", "Sell-to Customer Name";
    LookupPageID = "Sales List";

    fields
    {
        field(1; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
            //OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            //OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                //014
                ValidaCampos.Maestros(18, "Sell-to Customer No.");
                ValidaCampos.Dimensiones(18, "Sell-to Customer No.", 0, 0);
                //014


                //019
                MktSetUp.Get;
                ContacBusRel.Reset;
                ContacBusRel.SetRange("Business Relation Code", MktSetUp."Bus. Rel. Code for Customers");
                ContacBusRel.SetRange("No.", "Sell-to Customer No.");
                if ContacBusRel.FindFirst then
                    Validate("Cod. Colegio", ContacBusRel."Contact No.");
                //019

                if ("Sell-to Customer No." <> xRec."Sell-to Customer No.") and
                   (xRec."Sell-to Customer No." <> '')
                then begin
                    if ("Opportunity No." <> '') and ("Document Type" in ["Document Type"::Quote, "Document Type"::Order]) then
                        Error(
                          Text062,
                          FieldCaption("Sell-to Customer No."),
                          FieldCaption("Opportunity No."),
                          "Opportunity No.",
                          "Document Type");
                    if HideValidationDialog or not GuiAllowed then
                        Confirmed := true
                    else
                        Confirmed := Confirm(Text004, false, FieldCaption("Sell-to Customer No."));
                    if Confirmed then begin
                        SalesLine.SetRange("Document Type", "Document Type");
                        SalesLine.SetRange("Document No.", "No.");
                        if "Sell-to Customer No." = '' then begin
                            if SalesLine.FindFirst then
                                Error(
                                  Text005,
                                  FieldCaption("Sell-to Customer No."));
                            Init;
                            SalesSetup.Get;
                            "No. Series" := xRec."No. Series";
                            InitRecord;
                            if xRec."Shipping No." <> '' then begin
                                "Shipping No. Series" := xRec."Shipping No. Series";
                                "Shipping No." := xRec."Shipping No.";
                            end;
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            end;
                            if xRec."Return Receipt No." <> '' then begin
                                "Return Receipt No. Series" := xRec."Return Receipt No. Series";
                                "Return Receipt No." := xRec."Return Receipt No.";
                            end;
                            if xRec."Prepayment No." <> '' then begin
                                "Prepayment No. Series" := xRec."Prepayment No. Series";
                                "Prepayment No." := xRec."Prepayment No.";
                            end;
                            if xRec."Prepmt. Cr. Memo No." <> '' then begin
                                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                            end;
                            exit;
                        end;
                        if "Document Type" = "Document Type"::Order then
                            SalesLine.SetFilter("Quantity Shipped", '<>0')
                        else
                            if "Document Type" = "Document Type"::Invoice then begin
                                SalesLine.SetRange("Sell-to Customer No.", xRec."Sell-to Customer No.");
                                SalesLine.SetFilter("Shipment No.", '<>%1', '');
                            end;

                        if SalesLine.FindFirst then
                            if "Document Type" = "Document Type"::Order then
                                SalesLine.TestField("Quantity Shipped", 0)
                            else
                                SalesLine.TestField("Shipment No.", '');
                        SalesLine.SetRange("Shipment No.");
                        SalesLine.SetRange("Quantity Shipped");

                        if "Document Type" = "Document Type"::Order then begin
                            SalesLine.SetFilter("Prepmt. Amt. Inv.", '<>0');
                            if SalesLine.Find('-') then
                                SalesLine.TestField("Prepmt. Amt. Inv.", 0);
                            SalesLine.SetRange("Prepmt. Amt. Inv.");
                        end;

                        if "Document Type" = "Document Type"::"Return Order" then
                            SalesLine.SetFilter("Return Qty. Received", '<>0')
                        else
                            if "Document Type" = "Document Type"::"Credit Memo" then begin
                                SalesLine.SetRange("Sell-to Customer No.", xRec."Sell-to Customer No.");
                                SalesLine.SetFilter("Return Receipt No.", '<>%1', '');
                            end;

                        if SalesLine.FindFirst then
                            if "Document Type" = "Document Type"::"Return Order" then
                                SalesLine.TestField("Return Qty. Received", 0)
                            else
                                SalesLine.TestField("Return Receipt No.", '');
                        SalesLine.Reset
                    end else begin
                        Rec := xRec;
                        exit;
                    end;
                end;

                if ("Document Type" = "Document Type"::Order) and
                   (xRec."Sell-to Customer No." <> "Sell-to Customer No.")
                then begin
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SetRange("Document No.", "No.");
                    SalesLine.SetFilter("Purch. Order Line No.", '<>0');
                    if not SalesLine.IsEmpty then
                        Error(
                          Text006,
                          FieldCaption("Sell-to Customer No."));
                    SalesLine.Reset;
                end;

                GetCust("Sell-to Customer No.");

                Cust.CheckBlockedCustOnDocs(Cust, "Document Type", false, false);
                GLSetup.Get;
                // if GLSetup."VAT in Use" then
                //     Cust.TestField("Gen. Bus. Posting Group");
                "Sell-to Customer Template Code" := '';
                "Sell-to Customer Name" := Cust.Name;
                "Sell-to Customer Name 2" := Cust."Name 2";
                "Sell-to Address" := CopyStr(Cust.Address, 1, 50);
                "Sell-to Address 2" := Cust."Address 2";
                "Sell-to City" := Cust.City;
                "Sell-to Post Code" := Cust."Post Code";
                "Sell-to County" := Cust.County;
                "Sell-to Country/Region Code" := Cust."Country/Region Code";
                "Collector Code" := Cust."Collector Code"; //GRN Para llenar el cobrador

                //011
                "Sell-to Phone" := Cust."Phone No.";
                "Ship-to Phone" := Cust."No. Telefono Envio";
                //011

                if not SkipSellToContact then
                    "Sell-to Contact" := Cust.Contact;
                "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
                "Tax Area Code" := Cust."Tax Area Code";
                "Tax Liable" := Cust."Tax Liable";
                //"Tax Exemption No." := Cust."Tax Exemption No.";
                "VAT Registration No." := Cust."VAT Registration No.";
                "VAT Country/Region Code" := Cust."Country/Region Code";
                "Shipping Advice" := Cust."Shipping Advice";
                "Responsibility Center" := UserSetupMgt.GetRespCenter(0, Cust."Responsibility Center");
                Validate("Location Code", UserSetupMgt.GetLocation(0, Cust."Location Code", "Responsibility Center"));

                if "Sell-to Customer No." = xRec."Sell-to Customer No." then begin
                    /*  if ShippedSalesLinesExist or ReturnReceiptExist then begin
                         TestField("VAT Bus. Posting Group", xRec."VAT Bus. Posting Group");
                         TestField("Gen. Bus. Posting Group", xRec."Gen. Bus. Posting Group");
                     end; */
                end;

                "Sell-to IC Partner Code" := Cust."IC Partner Code";
                "Send IC Document" := ("Sell-to IC Partner Code" <> '') and ("IC Direction" = "IC Direction"::Outgoing);

                if Cust."Bill-to Customer No." <> '' then
                    Validate("Bill-to Customer No.", Cust."Bill-to Customer No.")
                else begin
                    if "Bill-to Customer No." = "Sell-to Customer No." then
                        SkipBillToContact := true;
                    Validate("Bill-to Customer No.", "Sell-to Customer No.");
                    SkipBillToContact := false;
                end;
                Validate("Ship-to Code", '');

                /*  GetShippingTime(FieldNo("Sell-to Customer No."));
  */
                if (xRec."Sell-to Customer No." <> "Sell-to Customer No.") or
                   (xRec."Currency Code" <> "Currency Code") or
                   (xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group") or
                   (xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group")
                then
                    RecreateSalesLines(FieldCaption("Sell-to Customer No."));

                if not SkipSellToContact then
                    /*  UpdateSellToCont("Sell-to Customer No."); */

                    //008
                    CPG.Get(Cust."Customer Posting Group");
                "No aplica Derechos de Autor" := CPG."No aplica Derechos de Autor";
                Promocion := CPG.Promocion;
                //008
            end;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SalesSetup.Get;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                end;
            end;
        }
        field(4; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                //014
                ValidaCampos.Maestros(18, "Bill-to Customer No.");
                ValidaCampos.Dimensiones(18, "Bill-to Customer No.", 0, 0);
                //014
                BilltoCustomerNoChanged := xRec."Bill-to Customer No." <> "Bill-to Customer No.";
                if BilltoCustomerNoChanged and
                   (xRec."Bill-to Customer No." <> '')
                then begin
                    Validate("Credit Card No.", '');
                    if HideValidationDialog or not GuiAllowed then
                        Confirmed := true
                    else
                        Confirmed := Confirm(Text004, false, FieldCaption("Bill-to Customer No."));
                    if Confirmed then begin
                        SalesLine.SetRange("Document Type", "Document Type");
                        SalesLine.SetRange("Document No.", "No.");
                        if "Document Type" = "Document Type"::Order then
                            SalesLine.SetFilter("Quantity Shipped", '<>0')
                        else
                            if "Document Type" = "Document Type"::Invoice then
                                SalesLine.SetFilter("Shipment No.", '<>%1', '');

                        if SalesLine.FindFirst then
                            if "Document Type" = "Document Type"::Order then
                                SalesLine.TestField("Quantity Shipped", 0)
                            else
                                SalesLine.TestField("Shipment No.", '');
                        SalesLine.SetRange("Shipment No.");
                        SalesLine.SetRange("Quantity Shipped");

                        if "Document Type" = "Document Type"::Order then begin
                            SalesLine.SetFilter("Prepmt. Amt. Inv.", '<>0');
                            if SalesLine.Find('-') then
                                SalesLine.TestField("Prepmt. Amt. Inv.", 0);
                            SalesLine.SetRange("Prepmt. Amt. Inv.");
                        end;

                        if "Document Type" = "Document Type"::"Return Order" then
                            SalesLine.SetFilter("Return Qty. Received", '<>0')
                        else
                            if "Document Type" = "Document Type"::"Credit Memo" then
                                SalesLine.SetFilter("Return Receipt No.", '<>%1', '');

                        if SalesLine.FindFirst then
                            if "Document Type" = "Document Type"::"Return Order" then
                                SalesLine.TestField("Return Qty. Received", 0)
                            else
                                SalesLine.TestField("Return Receipt No.", '');
                        SalesLine.Reset
                    end else
                        "Bill-to Customer No." := xRec."Bill-to Customer No.";
                end;

                GetCust("Bill-to Customer No.");
                Cust.CheckBlockedCustOnDocs(Cust, "Document Type", false, false);
                Cust.TestField("Customer Posting Group");
                /*   CheckCrLimit; */
                "Bill-to Customer Template Code" := '';
                "Bill-to Name" := Cust.Name;
                "Bill-to Name 2" := Cust."Name 2";
                "Bill-to Address" := CopyStr(Cust.Address, 1, 50);
                "Bill-to Address 2" := Cust."Address 2";
                "Bill-to City" := Cust.City;
                "Bill-to Post Code" := Cust."Post Code";
                "Bill-to County" := Cust.County;
                "Bill-to Country/Region Code" := Cust."Country/Region Code";
                if not SkipBillToContact then
                    "Bill-to Contact" := Cust.Contact;
                "Payment Terms Code" := Cust."Payment Terms Code";
                "Prepmt. Payment Terms Code" := Cust."Payment Terms Code";

                if "Document Type" = "Document Type"::"Credit Memo" then begin
                    "Payment Method Code" := '';
                    if PaymentTerms.Get("Payment Terms Code") then
                        if PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" then
                            "Payment Method Code" := Cust."Payment Method Code"
                end else
                    "Payment Method Code" := Cust."Payment Method Code";

                GLSetup.Get;
                if GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No." then begin
                    "VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
                    "VAT Country/Region Code" := Cust."Country/Region Code";
                    "VAT Registration No." := Cust."VAT Registration No.";
                    "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
                end;
                "Customer Posting Group" := Cust."Customer Posting Group";
                "Currency Code" := Cust."Currency Code";
                "Customer Price Group" := Cust."Customer Price Group";
                "Prices Including VAT" := Cust."Prices Including VAT";
                "Allow Line Disc." := Cust."Allow Line Disc.";
                "Invoice Disc. Code" := Cust."Invoice Disc. Code";
                "Customer Disc. Group" := Cust."Customer Disc. Group";
                "Language Code" := Cust."Language Code";
                "Salesperson Code" := Cust."Salesperson Code";
                "Combine Shipments" := Cust."Combine Shipments";
                Reserve := Cust.Reserve;
                if "Document Type" = "Document Type"::Order then
                    "Prepayment %" := Cust."Prepayment %";

                if not BilltoCustomerNoChanged then begin
                    /* if ShippedSalesLinesExist then begin
                        TestField("Customer Disc. Group", xRec."Customer Disc. Group");
                        TestField("Currency Code", xRec."Currency Code");
                    end; */
                end;

                /*   CreateDim(
                    DATABASE::Customer, "Bill-to Customer No.",
                    DATABASE::"Salesperson/Purchaser", "Salesperson Code",
                    DATABASE::Campaign, "Campaign No.",
                    DATABASE::"Responsibility Center", "Responsibility Center",
                    DATABASE::"Customer Template", "Bill-to Customer Template Code");
   */
                Validate("Payment Terms Code");
                Validate("Prepmt. Payment Terms Code");
                Validate("Payment Method Code");
                Validate("Currency Code");
                Validate("Prepayment %");

                if (xRec."Sell-to Customer No." = "Sell-to Customer No.") and
                   BilltoCustomerNoChanged
                then begin
                    RecreateSalesLines(FieldCaption("Bill-to Customer No."));
                    BilltoCustomerNoChanged := false;
                end;
                if not SkipBillToContact then
                    /*    UpdateBillToCont("Bill-to Customer No."); */

                "Bill-to IC Partner Code" := Cust."IC Partner Code";
                "Send IC Document" := ("Bill-to IC Partner Code" <> '') and ("IC Direction" = "IC Direction"::Outgoing);
            end;
        }
        field(5; "Bill-to Name"; Text[75])
        {
            Caption = 'Name';
            Description = '#56924';
        }
        field(6; "Bill-to Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(7; "Bill-to Address"; Text[50])
        {
            Caption = 'Address';
        }
        field(8; "Bill-to Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(9; "Bill-to City"; Text[60])
        {
            Caption = 'City';
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(
                  "Bill-to City", "Bill-to Post Code", "Bill-to County", "Bill-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(10; "Bill-to Contact"; Text[50])
        {
            Caption = 'Contact';
        }
        field(11; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
        }
        field(12; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));

            trigger OnValidate()
            var
            /*      SellToCustTemplate: Record "Customer Template"; */
            begin
                if ("Document Type" = "Document Type"::Order) and
                   (xRec."Ship-to Code" <> "Ship-to Code")
                then begin
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SetRange("Document No.", "No.");
                    SalesLine.SetFilter("Purch. Order Line No.", '<>0');
                    if not SalesLine.IsEmpty then
                        Error(
                          Text006,
                          FieldCaption("Ship-to Code"));
                    SalesLine.Reset;
                end;

                if ("Document Type" <> "Document Type"::"Return Order") and
                   ("Document Type" <> "Document Type"::"Credit Memo")
                then begin
                    if "Ship-to Code" <> '' then begin
                        if xRec."Ship-to Code" <> '' then begin
                            GetCust("Sell-to Customer No.");
                            if Cust."Location Code" <> '' then
                                Validate("Location Code", Cust."Location Code");
                            "Tax Area Code" := Cust."Tax Area Code";
                        end;
                        ShipToAddr.Get("Sell-to Customer No.", "Ship-to Code");
                        "Ship-to Name" := ShipToAddr.Name;
                        "Ship-to Name 2" := ShipToAddr."Name 2";
                        "Ship-to Address" := CopyStr(ShipToAddr.Address, 1, 50);
                        "Ship-to Address 2" := ShipToAddr."Address 2";
                        "Ship-to City" := ShipToAddr.City;
                        "Ship-to Post Code" := ShipToAddr."Post Code";
                        "Ship-to County" := ShipToAddr.County;
                        //011
                        "Ship-to Phone" := ShipToAddr."Phone No.";
                        //011
                        Validate("Ship-to Country/Region Code", ShipToAddr."Country/Region Code");
                        "Ship-to Contact" := ShipToAddr.Contact;
                        "Shipment Method Code" := ShipToAddr."Shipment Method Code";
                        if ShipToAddr."Location Code" <> '' then
                            Validate("Location Code", ShipToAddr."Location Code");
                        "Shipping Agent Code" := ShipToAddr."Shipping Agent Code";
                        "Shipping Agent Service Code" := ShipToAddr."Shipping Agent Service Code";
                        if ShipToAddr."Tax Area Code" <> '' then
                            "Tax Area Code" := ShipToAddr."Tax Area Code";
                        "Tax Liable" := ShipToAddr."Tax Liable";
                    end else
                        if "Sell-to Customer No." <> '' then begin
                            GetCust("Sell-to Customer No.");
                            "Ship-to Name" := Cust.Name;
                            "Ship-to Name 2" := Cust."Name 2";
                            "Ship-to Address" := CopyStr(Cust.Address, 1, 50);
                            "Ship-to Address 2" := Cust."Address 2";
                            "Ship-to City" := Cust.City;
                            "Ship-to Post Code" := Cust."Post Code";
                            "Ship-to County" := Cust.County;
                            Validate("Ship-to Country/Region Code", Cust."Country/Region Code");
                            "Ship-to Contact" := Cust.Contact;
                            "Shipment Method Code" := Cust."Shipment Method Code";
                            /* if not SellToCustTemplate.Get("Sell-to Customer Template Code") then begin
                                "Tax Area Code" := Cust."Tax Area Code";
                                "Tax Liable" := Cust."Tax Liable";
                            end; */
                            if Cust."Location Code" <> '' then
                                Validate("Location Code", Cust."Location Code");
                            "Shipping Agent Code" := Cust."Shipping Agent Code";
                            "Shipping Agent Service Code" := Cust."Shipping Agent Service Code";
                        end;
                end;

                /*  GetShippingTime(FieldNo("Ship-to Code"));
  */
                if (xRec."Sell-to Customer No." = "Sell-to Customer No.") and
                   (xRec."Ship-to Code" <> "Ship-to Code")
                then
                    if (xRec."VAT Country/Region Code" <> "VAT Country/Region Code") or
                       (xRec."Tax Area Code" <> "Tax Area Code")
                    then
                        RecreateSalesLines(FieldCaption("Ship-to Code"))
                    else begin
                        if xRec."Shipping Agent Code" <> "Shipping Agent Code" then
                            MessageIfSalesLinesExist(FieldCaption("Shipping Agent Code"));
                        if xRec."Shipping Agent Service Code" <> "Shipping Agent Service Code" then
                            MessageIfSalesLinesExist(FieldCaption("Shipping Agent Service Code"));
                        if xRec."Tax Liable" <> "Tax Liable" then
                            Validate("Tax Liable");
                    end;
            end;
        }
        field(13; "Ship-to Name"; Text[75])
        {
            Caption = 'Ship-to Name';
            Description = '#56924';
        }
        field(14; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(15; "Ship-to Address"; Text[50])
        {
            Caption = 'Ship-to Address';
        }
        field(16; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(17; "Ship-to City"; Text[60])
        {
            Caption = 'Ship-to City';
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(
                  "Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(18; "Ship-to Contact"; Text[50])
        {
            Caption = 'Ship-to Contact';
        }
        field(19; "Order Date"; Date)
        {
            Caption = 'Order Date';

            trigger OnValidate()
            begin
                if ("Document Type" in ["Document Type"::Quote, "Document Type"::Order]) and
                   not ("Order Date" = xRec."Order Date")
                then
                    PriceMessageIfSalesLinesExist(FieldCaption("Order Date"));
            end;
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                TestNoSeriesDate(
                  "Posting No.", "Posting No. Series",
                  FieldCaption("Posting No."), FieldCaption("Posting No. Series"));
                TestNoSeriesDate(
                  "Prepayment No.", "Prepayment No. Series",
                  FieldCaption("Prepayment No."), FieldCaption("Prepayment No. Series"));
                TestNoSeriesDate(
                  "Prepmt. Cr. Memo No.", "Prepmt. Cr. Memo No. Series",
                  FieldCaption("Prepmt. Cr. Memo No."), FieldCaption("Prepmt. Cr. Memo No. Series"));

                Validate("Document Date", "Posting Date");

                if ("Document Type" in ["Document Type"::Invoice, "Document Type"::"Credit Memo"]) and
                   not ("Posting Date" = xRec."Posting Date")
                then
                    PriceMessageIfSalesLinesExist(FieldCaption("Posting Date"));

                if "Currency Code" <> '' then begin
                    UpdateCurrencyFactor;
                    if "Currency Factor" <> xRec."Currency Factor" then
                        ConfirmUpdateCurrencyFactor;
                end;

                /*  SynchronizeAsmHeader; */
            end;
        }
        field(21; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';

            trigger OnValidate()
            begin
                UpdateSalesLines(FieldCaption("Shipment Date"), CurrFieldNo <> 0);
            end;
        }
        field(22; "Posting Description"; Text[60])
        {
            Caption = 'Posting Description';
        }
        field(23; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate()
            begin
                if ("Payment Terms Code" <> '') and ("Document Date" <> 0D) then begin
                    PaymentTerms.Get("Payment Terms Code");
                    if (("Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) and
                        not PaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
                    then begin
                        Validate("Due Date", "Document Date");
                        Validate("Pmt. Discount Date", 0D);
                        Validate("Payment Discount %", 0);
                    end else begin
                        "Due Date" := CalcDate(PaymentTerms."Due Date Calculation", "Document Date");
                        "Pmt. Discount Date" := CalcDate(PaymentTerms."Discount Date Calculation", "Document Date");
                        if not UpdateDocumentDate then
                            Validate("Payment Discount %", PaymentTerms."Discount %")
                    end;
                end else begin
                    Validate("Due Date", "Document Date");
                    if not UpdateDocumentDate then begin
                        Validate("Pmt. Discount Date", 0D);
                        Validate("Payment Discount %", 0);
                    end;
                end;
                if xRec."Payment Terms Code" = "Prepmt. Payment Terms Code" then begin
                    if xRec."Prepayment Due Date" = 0D then
                        "Prepayment Due Date" := CalcDate(PaymentTerms."Due Date Calculation", "Document Date");
                    Validate("Prepmt. Payment Terms Code", "Payment Terms Code");
                end;
            end;
        }
        field(24; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(25; "Payment Discount %"; Decimal)
        {
            Caption = 'Payment Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if not (CurrFieldNo in [0, FieldNo("Posting Date"), FieldNo("Document Date")]) then
                    TestField(Status, Status::Open);
                GLSetup.Get;
                if "Payment Discount %" < GLSetup."VAT Tolerance %" then
                    "VAT Base Discount %" := "Payment Discount %"
                else
                    "VAT Base Discount %" := GLSetup."VAT Tolerance %";
                Validate("VAT Base Discount %");
            end;
        }
        field(26; "Pmt. Discount Date"; Date)
        {
            Caption = 'Pmt. Discount Date';
        }
        field(27; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);

                ValidaCampos.Maestros(14, "Location Code"); //014

                if ("Location Code" <> xRec."Location Code") and
                   (xRec."Sell-to Customer No." = "Sell-to Customer No.")
                then
                    MessageIfSalesLinesExist(FieldCaption("Location Code"));

                ;/* UpdateShipToAddress */

                if "Location Code" <> '' then begin
                    if Location.Get("Location Code") then
                        "Outbound Whse. Handling Time" := Location."Outbound Whse. Handling Time";
                end else begin
                    if InvtSetup.Get then
                        "Outbound Whse. Handling Time" := InvtSetup."Outbound Whse. Handling Time";
                end;
            end;
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                /*   ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code"); */
            end;
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                /*   ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code"); */
            end;
        }
        field(31; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            Editable = false;
            TableRelation = "Customer Posting Group";
        }
        field(32; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                /*IF NOT (CurrFieldNo IN [0,FIELDNO("Posting Date")]) OR ("Currency Code" <> xRec."Currency Code") THEN
                  TESTFIELD(Status,Status::Open);
                IF DOPaymentTransLogEntry.FINDFIRST THEN
                  DOPaymentTransLogMgt.ValidateHasNoValidTransactions("Document Type",FORMAT("Document Type"),"No.");*/ //fes mig
                if (CurrFieldNo <> FieldNo("Currency Code")) and ("Currency Code" = xRec."Currency Code") then
                    UpdateCurrencyFactor
                else begin
                    if "Currency Code" <> xRec."Currency Code" then begin
                        UpdateCurrencyFactor;
                        RecreateSalesLines(FieldCaption("Currency Code"));
                    end else
                        if "Currency Code" <> '' then begin
                            UpdateCurrencyFactor;
                            if "Currency Factor" <> xRec."Currency Factor" then
                                ConfirmUpdateCurrencyFactor;
                        end;
                end;

            end;
        }
        field(33; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Currency Factor" <> xRec."Currency Factor" then
                    UpdateSalesLines(FieldCaption("Currency Factor"), false);
            end;
        }
        field(34; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                MessageIfSalesLinesExist(FieldCaption("Customer Price Group"));
            end;
        }
        field(35; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
                Currency: Record Currency;
                RecalculatePrice: Boolean;
            begin
                TestField(Status, Status::Open);

                if "Prices Including VAT" <> xRec."Prices Including VAT" then begin
                    SalesLine.SetRange("Document Type", "Document Type");
                    SalesLine.SetRange("Document No.", "No.");
                    SalesLine.SetFilter("Job Contract Entry No.", '<>%1', 0);
                    if SalesLine.Find('-') then begin
                        SalesLine.TestField("Job No.", '');
                        SalesLine.TestField("Job Contract Entry No.", 0);
                    end;

                    SalesLine.Reset;
                    SalesLine.SetRange("Document Type", "Document Type");
                    SalesLine.SetRange("Document No.", "No.");
                    SalesLine.SetFilter("Unit Price", '<>%1', 0);
                    SalesLine.SetFilter("VAT %", '<>%1', 0);
                    if SalesLine.FindFirst then begin
                        RecalculatePrice :=
                          Confirm(
                            StrSubstNo(
                              Text024,
                              FieldCaption("Prices Including VAT"), SalesLine.FieldCaption("Unit Price")),
                            true);
                        //fes mig SalesLine.SetSalesHeader(Rec);

                        if RecalculatePrice and "Prices Including VAT" then
                            SalesLine.ModifyAll(Amount, 0, true);

                        if "Currency Code" = '' then
                            Currency.InitRoundingPrecision
                        else
                            Currency.Get("Currency Code");
                        SalesLine.LockTable;
                        LockTable;
                        SalesLine.FindSet;
                        repeat
                            SalesLine.TestField("Quantity Invoiced", 0);
                            SalesLine.TestField("Prepmt. Amt. Inv.", 0);
                            if not RecalculatePrice then begin
                                SalesLine."VAT Difference" := 0;
                                SalesLine.InitOutstandingAmount;
                            end else
                                if "Prices Including VAT" then begin
                                    SalesLine."Unit Price" :=
                                      Round(
                                        SalesLine."Unit Price" * (1 + (SalesLine."VAT %" / 100)),
                                        Currency."Unit-Amount Rounding Precision");
                                    if SalesLine.Quantity <> 0 then begin
                                        SalesLine."Line Discount Amount" :=
                                          Round(
                                            SalesLine.Quantity * SalesLine."Unit Price" * SalesLine."Line Discount %" / 100,
                                            Currency."Amount Rounding Precision");
                                        SalesLine.Validate("Inv. Discount Amount",
                                          Round(
                                            SalesLine."Inv. Discount Amount" * (1 + (SalesLine."VAT %" / 100)),
                                            Currency."Amount Rounding Precision"));
                                    end;
                                end else begin
                                    SalesLine."Unit Price" :=
                                      Round(
                                        SalesLine."Unit Price" / (1 + (SalesLine."VAT %" / 100)),
                                        Currency."Unit-Amount Rounding Precision");
                                    if SalesLine.Quantity <> 0 then begin
                                        SalesLine."Line Discount Amount" :=
                                          Round(
                                            SalesLine.Quantity * SalesLine."Unit Price" * SalesLine."Line Discount %" / 100,
                                            Currency."Amount Rounding Precision");
                                        SalesLine.Validate("Inv. Discount Amount",
                                          Round(
                                            SalesLine."Inv. Discount Amount" / (1 + (SalesLine."VAT %" / 100)),
                                            Currency."Amount Rounding Precision"));
                                    end;
                                end;
                            SalesLine.Modify;
                        until SalesLine.Next = 0;
                    end;
                end;
            end;
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                MessageIfSalesLinesExist(FieldCaption("Invoice Disc. Code"));
            end;
        }
        field(40; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                MessageIfSalesLinesExist(FieldCaption("Customer Disc. Group"));
            end;
        }
        field(41; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;

            trigger OnValidate()
            begin
                MessageIfSalesLinesExist(FieldCaption("Language Code"));
            end;
        }
        field(43; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            var
                ApprovalEntry: Record "Approval Entry";
            begin
                //014
                ValidaCampos.Maestros(13, "Salesperson Code");
                ValidaCampos.Dimensiones(13, "Salesperson Code", 0, 0);
                //014

                ApprovalEntry.SetRange("Table ID", DATABASE::"Sales Header");
                ApprovalEntry.SetRange("Document Type", "Document Type");
                ApprovalEntry.SetRange("Document No.", "No.");
                ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Canceled, ApprovalEntry.Status::Rejected);
                if not ApprovalEntry.IsEmpty then
                    Error(Text053, FieldCaption("Salesperson Code"));

                /*           CreateDim(
                            DATABASE::"Salesperson/Purchaser", "Salesperson Code",
                            DATABASE::Customer, "Bill-to Customer No.",
                            DATABASE::Campaign, "Campaign No.",
                            DATABASE::"Responsibility Center", "Responsibility Center",
                            DATABASE::"Customer Template", "Bill-to Customer Template Code"); */
            end;
        }
        field(45; "Order Class"; Code[10])
        {
            Caption = 'Order Class';
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = Exist("Sales Comment Line" WHERE("Document Type" = FIELD("Document Type"),
                                                            "No." = FIELD("No."),
                                                            "Document Line No." = CONST(0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(47; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(51; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
        field(52; "Applies-to Doc. Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Applies-to Doc. Type';
            //OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            //OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(53; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            begin
                TestField("Bal. Account No.", '');
                CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive, "Due Date");
                CustLedgEntry.SetRange("Customer No.", "Bill-to Customer No.");
                CustLedgEntry.SetRange(Open, true);
                if "Applies-to Doc. No." <> '' then begin
                    CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
                    CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                    if CustLedgEntry.FindFirst then;
                    CustLedgEntry.SetRange("Document Type");
                    CustLedgEntry.SetRange("Document No.");
                end else
                    if "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " then begin
                        CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
                        if CustLedgEntry.FindFirst then;
                        CustLedgEntry.SetRange("Document Type");
                    end else
                        if Amount <> 0 then begin
                            CustLedgEntry.SetRange(Positive, Amount < 0);
                            if CustLedgEntry.FindFirst then;
                            CustLedgEntry.SetRange(Positive);
                        end;

                //fes mig ApplyCustEntries.SetSales(Rec,CustLedgEntry,SalesHeader.FIELDNO("Applies-to Doc. No."));
                ApplyCustEntries.SetTableView(CustLedgEntry);
                ApplyCustEntries.SetRecord(CustLedgEntry);
                ApplyCustEntries.LookupMode(true);
                if ApplyCustEntries.RunModal = ACTION::LookupOK then begin
                    ApplyCustEntries.GetCustLedgEntry(CustLedgEntry);
                    GenJnlApply.CheckAgainstApplnCurrency(
                      "Currency Code", CustLedgEntry."Currency Code", GenJnILine."Account Type"::Customer, true);
                    "Applies-to Doc. Type" := CustLedgEntry."Document Type";
                    "Applies-to Doc. No." := CustLedgEntry."Document No.";
                end;
                Clear(ApplyCustEntries);
            end;

            trigger OnValidate()
            begin

            end;
        }
        field(55; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";

            trigger OnValidate()
            begin
                if "Bal. Account No." <> '' then
                    case "Bal. Account Type" of
                        "Bal. Account Type"::"G/L Account":
                            begin
                                GLAcc.Get("Bal. Account No.");
                                GLAcc.CheckGLAcc;
                                GLAcc.TestField("Direct Posting", true);
                            end;
                        "Bal. Account Type"::"Bank Account":
                            begin
                                BankAcc.Get("Bal. Account No.");
                                BankAcc.TestField(Blocked, false);
                                BankAcc.TestField("Currency Code", "Currency Code");
                            end;
                    end;
            end;
        }
        field(57; Ship; Boolean)
        {
            Caption = 'Ship';
            Editable = false;
        }
        field(58; Invoice; Boolean)
        {
            Caption = 'Invoice';
        }
        field(59; "Print Posted Documents"; Boolean)
        {
            Caption = 'Print Posted Documents';
        }
        field(60; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                         "Document No." = FIELD("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Amount Including VAT" WHERE("Document Type" = FIELD("Document Type"),
                                                                         "Document No." = FIELD("No.")));
            Caption = 'Amount Including Tax';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Shipping No."; Code[20])
        {
            Caption = 'Shipping No.';
        }
        field(63; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
        field(64; "Last Shipping No."; Code[20])
        {
            Caption = 'Last Shipping No.';
            Editable = false;
            TableRelation = "Sales Shipment Header";
        }
        field(65; "Last Posting No."; Code[20])
        {
            Caption = 'Last Posting No.';
            Editable = false;
            TableRelation = "Sales Invoice Header";
        }
        field(66; "Prepayment No."; Code[20])
        {
            Caption = 'Prepayment No.';
        }
        field(67; "Last Prepayment No."; Code[20])
        {
            Caption = 'Last Prepayment No.';
            TableRelation = "Sales Invoice Header";
        }
        field(68; "Prepmt. Cr. Memo No."; Code[20])
        {
            Caption = 'Prepmt. Cr. Memo No.';
        }
        field(69; "Last Prepmt. Cr. Memo No."; Code[20])
        {
            Caption = 'Last Prepmt. Cr. Memo No.';
            TableRelation = "Sales Cr.Memo Header";
        }
        field(70; "VAT Registration No."; Text[30])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            begin
                FuncEcuador.ValidaDigitosRUC("VAT Registration No.", "Tipo Ruc/Cedula", false);//016
            end;
        }
        field(71; "Combine Shipments"; Boolean)
        {
            Caption = 'Combine Shipments';
        }
        field(73; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(74; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then begin
                        "VAT Bus. Posting Group" := GenBusPostingGrp."Def. VAT Bus. Posting Group";
                        RecreateSalesLines(FieldCaption("Gen. Bus. Posting Group"));
                    end;
            end;
        }
        field(75; "EU 3-Party Trade"; Boolean)
        {
            Caption = 'EU 3-Party Trade';
        }
        field(76; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";

            trigger OnValidate()
            begin
                UpdateSalesLines(FieldCaption("Transaction Type"), false);
            end;
        }
        field(77; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";

            trigger OnValidate()
            begin
                UpdateSalesLines(FieldCaption("Transport Method"), false);
            end;
        }
        field(78; "VAT Country/Region Code"; Code[10])
        {
            Caption = 'Tax Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(79; "Sell-to Customer Name"; Text[75])
        {
            Caption = 'Sell-to Customer Name';
            Description = '#56924';
        }
        field(80; "Sell-to Customer Name 2"; Text[50])
        {
            Caption = 'Sell-to Customer Name 2';
        }
        field(81; "Sell-to Address"; Text[50])
        {
            Caption = 'Sell-to Address';
        }
        field(82; "Sell-to Address 2"; Text[50])
        {
            Caption = 'Sell-to Address 2';
        }
        field(83; "Sell-to City"; Text[60])
        {
            Caption = 'Sell-to City';
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(
                  "Sell-to City", "Sell-to Post Code", "Sell-to County", "Sell-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(84; "Sell-to Contact"; Text[50])
        {
            Caption = 'Sell-to Contact';
        }
        field(85; "Bill-to Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(
                  "Bill-to City", "Bill-to Post Code", "Bill-to County", "Bill-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(86; "Bill-to County"; Text[30])
        {
            Caption = 'State';
        }
        field(87; "Bill-to Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(88; "Sell-to Post Code"; Code[20])
        {
            Caption = 'Sell-to ZIP Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(
                  "Sell-to City", "Sell-to Post Code", "Sell-to County", "Sell-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(89; "Sell-to County"; Text[30])
        {
            Caption = 'Sell-to State';
        }
        field(90; "Sell-to Country/Region Code"; Code[10])
        {
            Caption = 'Sell-to Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                Validate("Ship-to Country/Region Code");
            end;
        }
        field(91; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to ZIP Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(
                  "Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(92; "Ship-to County"; Text[30])
        {
            Caption = 'Ship-to State';
        }
        field(93; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(94; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";
        }
        field(97; "Exit Point"; Code[10])
        {
            Caption = 'Exit Point';
            TableRelation = "Entry/Exit Point";

            trigger OnValidate()
            begin
                UpdateSalesLines(FieldCaption("Exit Point"), false);
            end;
        }
        field(98; Correction; Boolean)
        {
            Caption = 'Correction';

            trigger OnValidate()
            begin
                //007 Original de Guatemana adaptado a Ecuador
                if ("Document Type" = "Document Type"::"Credit Memo") or ("Document Type" = "Document Type"::"Return Order") then begin
                    TestField("No. Comprobante Fiscal Rel.");
                    TestField("Applies-to Doc. Type");
                    TestField("Applies-to Doc. No.");

                    //Ecuador, Se valida que la factura pertenezca al cliente
                    SIH.Get("Applies-to Doc. No.");
                    if SIH."Sell-to Customer No." <> "Sell-to Customer No." then
                        Error(Error004, "No. Comprobante Fiscal Rel.", "Sell-to Customer No.");
                    /*
                    //No. de serie debe ser interno. Es decir no debe tener resolución asociada
                    NSL.RESET;
                    NSL.SETRANGE("Series Code","No. Serie NCF Abonos");
                    NSL.SETRANGE(Open,TRUE);
                    NSL.FINDFIRST;
                    IF NSL."No. Resolucion" <> '' THEN
                      BEGIN
                        CLEAR("No. Serie NCF Abonos");
                        MESSAGE(Error005);
                      END;
                    IF NSL."Tipo Generacion" <> NSL."Tipo Generacion"::" " THEN
                      BEGIN
                        CLEAR("No. Serie NCF Abonos");
                        MESSAGE(Error006);
                      END;
                    */
                end;
                //007

            end;
        }
        field(99; "Document Date"; Date)
        {
            Caption = 'Document Date';

            trigger OnValidate()
            begin
                if xRec."Document Date" <> "Document Date" then
                    UpdateDocumentDate := true;
                Validate("Payment Terms Code");
                Validate("Prepmt. Payment Terms Code");
            end;
        }
        field(100; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(101; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;

            trigger OnValidate()
            begin
                UpdateSalesLines(FieldCaption(Area), false);
            end;
        }
        field(102; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";

            trigger OnValidate()
            begin
                UpdateSalesLines(FieldCaption("Transaction Specification"), false);
            end;
        }
        field(104; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";

            trigger OnValidate()
            var
                SEPADirectDebitMandate: Record "SEPA Direct Debit Mandate";
            begin
                /*IF DOPaymentTransLogEntry.FINDFIRST THEN
                  DOPaymentTransLogMgt.ValidateHasNoValidTransactions("Document Type",FORMAT("Document Type"),"No.");
                IF DOPaymentMgt.IsValidPaymentMethod(xRec."Payment Method Code") AND NOT DOPaymentMgt.IsValidPaymentMethod("Payment Method Code")
                THEN
                  TESTFIELD("Credit Card No.",'');
                PaymentMethod.INIT;
                IF "Payment Method Code" <> '' THEN
                  PaymentMethod.GET("Payment Method Code");
                IF PaymentMethod."Direct Debit" THEN BEGIN
                  IF "Direct Debit Mandate ID" = '' THEN
                    "Direct Debit Mandate ID" := SEPADirectDebitMandate.GetDefaultMandate("Bill-to Customer No.","Due Date");
                  IF "Payment Terms Code" = '' THEN
                    "Payment Terms Code" := PaymentMethod."Direct Debit Pmt. Terms Code";
                END;
                "Bal. Account Type" := PaymentMethod."Bal. Account Type";
                "Bal. Account No." := PaymentMethod."Bal. Account No.";
                IF "Bal. Account No." <> '' THEN BEGIN
                  TESTFIELD("Applies-to Doc. No.",'');
                  TESTFIELD("Applies-to ID",'');
                END;*/ //fes mig

            end;
        }
        field(105; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if xRec."Shipping Agent Code" = "Shipping Agent Code" then
                    exit;

                "Shipping Agent Service Code" := '';

                UpdateSalesLines(FieldCaption("Shipping Agent Code"), CurrFieldNo <> 0);
            end;
        }
        field(106; "Package Tracking No."; Text[30])
        {
            Caption = 'Package Tracking No.';
        }
        field(107; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                //fes mig SalesHeader := Rec;
                SalesSetup.Get;
                SalesHeader.TestNoSeries;
                if NoSeriesMgt.LookupRelatedNoSeries(GetPostingNoSeriesCode, SalesHeader."Posting No. Series") then
                    SalesHeader.Validate("Posting No. Series");
                //fes mig Rec := SalesHeader;
            end;

            trigger OnValidate()
            begin
                if "Posting No. Series" <> '' then begin
                    SalesSetup.Get;
                    TestNoSeries;
                    NoSeriesMgt.LookupRelatedNoSeries(GetPostingNoSeriesCode, "Posting No. Series");
                end;
                TestField("Posting No.", '');
            end;
        }
        field(109; "Shipping No. Series"; Code[10])
        {
            Caption = 'Shipping No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                //fes mig SalesHeader := Rec;
                SalesSetup.Get;
                SalesSetup.TestField("Posted Shipment Nos.");
                if NoSeriesMgt.LookupRelatedNoSeries(SalesSetup."Posted Shipment Nos.", SalesHeader."Shipping No. Series") then
                    SalesHeader.Validate("Shipping No. Series");
                //fes mig Rec := SalesHeader;
            end;

            trigger OnValidate()
            begin
                if "Shipping No. Series" <> '' then begin
                    SalesSetup.Get;
                    SalesSetup.TestField("Posted Shipment Nos.");
                    NoSeriesMgt.LookupRelatedNoSeries(SalesSetup."Posted Shipment Nos.", "Shipping No. Series");
                end;
                TestField("Shipping No.", '');
            end;
        }
        field(114; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                MessageIfSalesLinesExist(FieldCaption("Tax Area Code"));
            end;
        }
        field(115; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                UpdateSalesLines(FieldCaption("Tax Liable"), false);
            end;
        }
        field(116; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'Tax Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group" then
                    RecreateSalesLines(FieldCaption("VAT Bus. Posting Group"));
            end;
        }
        field(117; Reserve; enum "Reserve Method")
        {
            Caption = 'Reserve';
            //OptionCaption = 'Never,Optional,Always';
            //OptionMembers = Never,Optional,Always;
        }
        field(118; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            var
                TempCustLedgEntry: Record "Cust. Ledger Entry";
            begin
                if "Applies-to ID" <> '' then
                    TestField("Bal. Account No.", '');
                if ("Applies-to ID" <> xRec."Applies-to ID") and (xRec."Applies-to ID" <> '') then begin
                    CustLedgEntry.SetCurrentKey("Customer No.", Open);
                    CustLedgEntry.SetRange("Customer No.", "Bill-to Customer No.");
                    CustLedgEntry.SetRange(Open, true);
                    CustLedgEntry.SetRange("Applies-to ID", xRec."Applies-to ID");
                    if CustLedgEntry.FindFirst then
                        CustEntrySetApplID.SetApplId(CustLedgEntry, TempCustLedgEntry, '');
                    CustLedgEntry.Reset;
                end;
            end;
        }
        field(119; "VAT Base Discount %"; Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if not (CurrFieldNo in [0, FieldNo("Posting Date"), FieldNo("Document Date")]) then
                    TestField(Status, Status::Open);
                GLSetup.Get;
                if "VAT Base Discount %" > GLSetup."VAT Tolerance %" then
                    Error(
                      Text007,
                      FieldCaption("VAT Base Discount %"),
                      GLSetup.FieldCaption("VAT Tolerance %"),
                      GLSetup.TableCaption);

                if ("VAT Base Discount %" = xRec."VAT Base Discount %") and
                   (CurrFieldNo <> 0)
                then
                    exit;

                SalesLine.SetRange("Document Type", "Document Type");
                SalesLine.SetRange("Document No.", "No.");
                SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
                SalesLine.SetFilter(Quantity, '<>0');
                SalesLine.LockTable;
                LockTable;
                if SalesLine.FindSet then begin
                    Modify;
                    repeat
                        if (SalesLine."Quantity Invoiced" <> SalesLine.Quantity) or
                           ("Shipping Advice" <> "Shipping Advice"::Partial) or
                           (SalesLine.Type <> SalesLine.Type::"Charge (Item)") or
                           (CurrFieldNo <> 0)
                        then begin
                            SalesLine.UpdateAmounts;
                            SalesLine.Modify;
                        end;
                    until SalesLine.Next = 0;
                end;
                SalesLine.Reset;
            end;
        }
        field(120; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(121; "Invoice Discount Calculation"; Option)
        {
            Caption = 'Invoice Discount Calculation';
            Editable = false;
            OptionCaption = 'None,%,Amount';
            OptionMembers = "None","%",Amount;
        }
        field(122; "Invoice Discount Value"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Invoice Discount Value';
            Editable = false;
        }
        field(123; "Send IC Document"; Boolean)
        {
            Caption = 'Send IC Document';

            trigger OnValidate()
            begin
                if "Send IC Document" then begin
                    if "Bill-to IC Partner Code" = '' then
                        TestField("Sell-to IC Partner Code");
                    TestField("IC Direction", "IC Direction"::Outgoing);
                end;
            end;
        }
        field(124; "IC Status"; Option)
        {
            Caption = 'IC Status';
            OptionCaption = 'New,Pending,Sent';
            OptionMembers = New,Pending,Sent;
        }
        field(125; "Sell-to IC Partner Code"; Code[20])
        {
            Caption = 'Sell-to IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(126; "Bill-to IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(129; "IC Direction"; Option)
        {
            Caption = 'IC Direction';
            OptionCaption = 'Outgoing,Incoming';
            OptionMembers = Outgoing,Incoming;

            trigger OnValidate()
            begin
                if "IC Direction" = "IC Direction"::Incoming then
                    "Send IC Document" := false;
            end;
        }
        field(130; "Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if xRec."Prepayment %" <> "Prepayment %" then
                    UpdateSalesLines(FieldCaption("Prepayment %"), CurrFieldNo <> 0);
            end;
        }
        field(131; "Prepayment No. Series"; Code[10])
        {
            Caption = 'Prepayment No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                //fes mig SalesHeader := Rec;
                SalesSetup.Get;
                SalesSetup.TestField("Posted Prepmt. Inv. Nos.");
                if NoSeriesMgt.LookupRelatedNoSeries(GetPostingPrepaymentNoSeriesCode, SalesHeader."Prepayment No. Series") then
                    SalesHeader.Validate("Prepayment No. Series");
                //fes mig Rec := SalesHeader;
            end;

            trigger OnValidate()
            begin
                if "Prepayment No. Series" <> '' then begin
                    SalesSetup.Get;
                    SalesSetup.TestField("Posted Prepmt. Inv. Nos.");
                    NoSeriesMgt.LookupRelatedNoSeries(GetPostingPrepaymentNoSeriesCode, "Prepayment No. Series");
                end;
                TestField("Prepayment No.", '');
            end;
        }
        field(132; "Compress Prepayment"; Boolean)
        {
            Caption = 'Compress Prepayment';
            InitValue = true;
        }
        field(133; "Prepayment Due Date"; Date)
        {
            Caption = 'Prepayment Due Date';
        }
        field(134; "Prepmt. Cr. Memo No. Series"; Code[10])
        {
            Caption = 'Prepmt. Cr. Memo No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                //fes mig SalesHeader := Rec;
                SalesSetup.Get;
                SalesSetup.TestField("Posted Prepmt. Cr. Memo Nos.");
                if NoSeriesMgt.LookupRelatedNoSeries(GetPostingPrepaymentNoSeriesCode, SalesHeader."Prepmt. Cr. Memo No. Series") then
                    SalesHeader.Validate("Prepmt. Cr. Memo No. Series");
                //fes mig Rec := SalesHeader;
            end;

            trigger OnValidate()
            begin
                if "Prepmt. Cr. Memo No." <> '' then begin
                    SalesSetup.Get;
                    SalesSetup.TestField("Posted Prepmt. Cr. Memo Nos.");
                    NoSeriesMgt.LookupRelatedNoSeries(GetPostingPrepaymentNoSeriesCode, "Prepmt. Cr. Memo No. Series");
                end;
                TestField("Prepmt. Cr. Memo No.", '');
            end;
        }
        field(135; "Prepmt. Posting Description"; Text[50])
        {
            Caption = 'Prepmt. Posting Description';
        }
        field(138; "Prepmt. Pmt. Discount Date"; Date)
        {
            Caption = 'Prepmt. Pmt. Discount Date';
        }
        field(139; "Prepmt. Payment Terms Code"; Code[10])
        {
            Caption = 'Prepmt. Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate()
            var
                PaymentTerms: Record "Payment Terms";
            begin
                if ("Prepmt. Payment Terms Code" <> '') and ("Document Date" <> 0D) then begin
                    PaymentTerms.Get("Prepmt. Payment Terms Code");
                    if (("Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) and
                        not PaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
                    then begin
                        Validate("Prepayment Due Date", "Document Date");
                        Validate("Prepmt. Pmt. Discount Date", 0D);
                        Validate("Prepmt. Payment Discount %", 0);
                    end else begin
                        "Prepayment Due Date" := CalcDate(PaymentTerms."Due Date Calculation", "Document Date");
                        "Prepmt. Pmt. Discount Date" := CalcDate(PaymentTerms."Discount Date Calculation", "Document Date");
                        if not UpdateDocumentDate then
                            Validate("Prepmt. Payment Discount %", PaymentTerms."Discount %")
                    end;
                end else begin
                    Validate("Prepayment Due Date", "Document Date");
                    if not UpdateDocumentDate then begin
                        Validate("Prepmt. Pmt. Discount Date", 0D);
                        Validate("Prepmt. Payment Discount %", 0);
                    end;
                end;
            end;
        }
        field(140; "Prepmt. Payment Discount %"; Decimal)
        {
            Caption = 'Prepmt. Payment Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if not (CurrFieldNo in [0, FieldNo("Posting Date"), FieldNo("Document Date")]) then
                    TestField(Status, Status::Open);
                GLSetup.Get;
                if "Payment Discount %" < GLSetup."VAT Tolerance %" then
                    "VAT Base Discount %" := "Payment Discount %"
                else
                    "VAT Base Discount %" := GLSetup."VAT Tolerance %";
                Validate("VAT Base Discount %");
            end;
        }
        field(151; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            Editable = false;
        }
        field(160; "Job Queue Status"; Option)
        {
            Caption = 'Job Queue Status';
            Editable = false;
            OptionCaption = ' ,Scheduled for Posting,Error,Posting';
            OptionMembers = " ","Scheduled for Posting",Error,Posting;

            trigger OnLookup()
            var
                JobQueueEntry: Record "Job Queue Entry";
            begin
                if "Job Queue Status" = "Job Queue Status"::" " then
                    exit;
                JobQueueEntry.ShowStatusMsg("Job Queue Entry ID");
            end;
        }
        field(161; "Job Queue Entry ID"; Guid)
        {
            Caption = 'Job Queue Entry ID';
            Editable = false;
        }
        field(165; "Incoming Document Entry No."; Integer)
        {
            Caption = 'Incoming Document Entry No.';
            TableRelation = "Incoming Document" WHERE(Status = FILTER(New | Released));

            trigger OnValidate()
            var
                IncomingDocument: Record "Incoming Document";
            begin
                //fes mig IncomingDocument.SetSalesDoc(Rec);
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin

            end;
        }
        field(825; "Authorization Required"; Boolean)
        {
            Caption = 'Authorization Required';
        }
        field(827; "Credit Card No."; Code[20])
        {
            /*             Caption = 'Credit Card No.';
                        TableRelation = Table827 WHERE(Field6 = FIELD("Bill-to Customer No.")); */

            trigger OnValidate()
            begin
                /*IF NOT DOPaymentTransLogEntry.ISEMPTY THEN
                  DOPaymentTransLogMgt.ValidateHasNoValidTransactions("Document Type",FORMAT("Document Type"),"No.");
                
                IF "Credit Card No." = '' THEN
                  EXIT;
                
                DOPaymentMgt.CheckCreditCardData("Credit Card No.");
                
                IF NOT DOPaymentMgt.IsValidPaymentMethod("Payment Method Code") THEN
                  FIELDERROR("Payment Method Code");*/ //fes mig

            end;
        }
        field(1200; "Direct Debit Mandate ID"; Code[35])
        {
            Caption = 'Direct Debit Mandate ID';
            TableRelation = "SEPA Direct Debit Mandate" WHERE("Customer No." = FIELD("Bill-to Customer No."),
                                                               Closed = CONST(false),
                                                               Blocked = CONST(false));
        }
        field(1305; "Invoice Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Inv. Discount Amount" WHERE("Document No." = FIELD("No."),
                                                                         "Document Type" = FIELD("Document Type")));
            Caption = 'Invoice Discount Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5043; "No. of Archived Versions"; Integer)
        {
            CalcFormula = Max("Sales Header Archive"."Version No." WHERE("Document Type" = FIELD("Document Type"),
                                                                          "No." = FIELD("No."),
                                                                          "Doc. No. Occurrence" = FIELD("Doc. No. Occurrence")));
            Caption = 'No. of Archived Versions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5048; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
        field(5050; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;

            trigger OnValidate()
            begin
                /*   CreateDim(
                    DATABASE::Campaign, "Campaign No.",
                    DATABASE::Customer, "Bill-to Customer No.",
                    DATABASE::"Salesperson/Purchaser", "Salesperson Code",
                    DATABASE::"Responsibility Center", "Responsibility Center",
                    DATABASE::"Customer Template", "Bill-to Customer Template Code"); */
            end;
        }
        field(5051; "Sell-to Customer Template Code"; Code[10])
        {
            Caption = 'Sell-to Customer Template Code';
            /*   TableRelation = "Customer Template"; */

            trigger OnValidate()
            var
            /*       SellToCustTemplate: Record "Customer Template"; */
            begin
                TestField("Document Type", "Document Type"::Quote);
                TestField(Status, Status::Open);

                if not InsertMode and
                   ("Sell-to Customer Template Code" <> xRec."Sell-to Customer Template Code") and
                   (xRec."Sell-to Customer Template Code" <> '')
                then begin
                    if HideValidationDialog then
                        Confirmed := true
                    else
                        Confirmed := Confirm(Text004, false, FieldCaption("Sell-to Customer Template Code"));
                    if Confirmed then begin
                        SalesLine.Reset;
                        SalesLine.SetRange("Document Type", "Document Type");
                        SalesLine.SetRange("Document No.", "No.");
                        if "Sell-to Customer Template Code" = '' then begin
                            if not SalesLine.IsEmpty then
                                Error(Text005, FieldCaption("Sell-to Customer Template Code"));
                            Init;
                            SalesSetup.Get;
                            InitRecord;
                            "No. Series" := xRec."No. Series";
                            if xRec."Shipping No." <> '' then begin
                                "Shipping No. Series" := xRec."Shipping No. Series";
                                "Shipping No." := xRec."Shipping No.";
                            end;
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            end;
                            if xRec."Return Receipt No." <> '' then begin
                                "Return Receipt No. Series" := xRec."Return Receipt No. Series";
                                "Return Receipt No." := xRec."Return Receipt No.";
                            end;
                            if xRec."Prepayment No." <> '' then begin
                                "Prepayment No. Series" := xRec."Prepayment No. Series";
                                "Prepayment No." := xRec."Prepayment No.";
                            end;
                            if xRec."Prepmt. Cr. Memo No." <> '' then begin
                                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                            end;
                            exit;
                        end;
                    end else begin
                        "Sell-to Customer Template Code" := xRec."Sell-to Customer Template Code";
                        exit;
                    end;
                end;

                /* if SellToCustTemplate.Get("Sell-to Customer Template Code") then begin
                    if GLSetup."VAT in Use" then
                        SellToCustTemplate.TestField("Gen. Bus. Posting Group");
                    "Gen. Bus. Posting Group" := SellToCustTemplate."Gen. Bus. Posting Group";
                    "VAT Bus. Posting Group" := SellToCustTemplate."VAT Bus. Posting Group";
                    if "Bill-to Customer No." = '' then
                        Validate("Bill-to Customer Template Code", "Sell-to Customer Template Code");
                end; */

                if not InsertMode and
                   ((xRec."Sell-to Customer Template Code" <> "Sell-to Customer Template Code") or
                    (xRec."Currency Code" <> "Currency Code"))
                then
                    RecreateSalesLines(FieldCaption("Sell-to Customer Template Code"));
            end;
        }
        field(5052; "Sell-to Contact No."; Code[20])
        {
            Caption = 'Sell-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                if "Sell-to Customer No." <> '' then begin
                    if Cont.Get("Sell-to Contact No.") then
                        Cont.SetRange("Company No.", Cont."Company No.")
                    else begin
                        ContBusinessRelation.Reset;
                        ContBusinessRelation.SetCurrentKey("Link to Table", "No.");
                        ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                        ContBusinessRelation.SetRange("No.", "Sell-to Customer No.");
                        if ContBusinessRelation.FindFirst then
                            Cont.SetRange("Company No.", ContBusinessRelation."Contact No.")
                        else
                            Cont.SetRange("No.", '');
                    end;
                end;

                if "Sell-to Contact No." <> '' then
                    if Cont.Get("Sell-to Contact No.") then;
                if PAGE.RunModal(0, Cont) = ACTION::LookupOK then begin
                    xRec := Rec;
                    Validate("Sell-to Contact No.", Cont."No.");
                end;
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
                Opportunity: Record Opportunity;
            begin
                TestField(Status, Status::Open);

                if ("Sell-to Contact No." <> xRec."Sell-to Contact No.") and
                   (xRec."Sell-to Contact No." <> '')
                then begin
                    if ("Sell-to Contact No." = '') and ("Opportunity No." <> '') then
                        Error(Text049, FieldCaption("Sell-to Contact No."));
                    if HideValidationDialog or not GuiAllowed then
                        Confirmed := true
                    else
                        Confirmed := Confirm(Text004, false, FieldCaption("Sell-to Contact No."));
                    if Confirmed then begin
                        SalesLine.Reset;
                        SalesLine.SetRange("Document Type", "Document Type");
                        SalesLine.SetRange("Document No.", "No.");
                        if ("Sell-to Contact No." = '') and ("Sell-to Customer No." = '') then begin
                            if not SalesLine.IsEmpty then
                                Error(Text005, FieldCaption("Sell-to Contact No."));
                            Init;
                            SalesSetup.Get;
                            InitRecord;
                            "No. Series" := xRec."No. Series";
                            if xRec."Shipping No." <> '' then begin
                                "Shipping No. Series" := xRec."Shipping No. Series";
                                "Shipping No." := xRec."Shipping No.";
                            end;
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            end;
                            if xRec."Return Receipt No." <> '' then begin
                                "Return Receipt No. Series" := xRec."Return Receipt No. Series";
                                "Return Receipt No." := xRec."Return Receipt No.";
                            end;
                            if xRec."Prepayment No." <> '' then begin
                                "Prepayment No. Series" := xRec."Prepayment No. Series";
                                "Prepayment No." := xRec."Prepayment No.";
                            end;
                            if xRec."Prepmt. Cr. Memo No." <> '' then begin
                                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                            end;
                            exit;
                        end;
                        if "Opportunity No." <> '' then begin
                            Opportunity.Get("Opportunity No.");
                            if Opportunity."Contact No." <> "Sell-to Contact No." then begin
                                Modify;
                                Opportunity.Validate("Contact No.", "Sell-to Contact No.");
                                Opportunity.Modify;
                            end
                        end;
                    end else begin
                        Rec := xRec;
                        exit;
                    end;
                end;

                if ("Sell-to Customer No." <> '') and ("Sell-to Contact No." <> '') then begin
                    Cont.Get("Sell-to Contact No.");
                    ContBusinessRelation.Reset;
                    ContBusinessRelation.SetCurrentKey("Link to Table", "No.");
                    ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                    ContBusinessRelation.SetRange("No.", "Sell-to Customer No.");
                    if ContBusinessRelation.FindFirst then
                        if ContBusinessRelation."Contact No." <> Cont."Company No." then
                            Error(Text038, Cont."No.", Cont.Name, "Sell-to Customer No.");
                end;


            end;
        }
        field(5053; "Bill-to Contact No."; Code[20])
        {
            Caption = 'Bill-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                if "Bill-to Customer No." <> '' then begin
                    if Cont.Get("Bill-to Contact No.") then
                        Cont.SetRange("Company No.", Cont."Company No.")
                    else begin
                        ContBusinessRelation.Reset;
                        ContBusinessRelation.SetCurrentKey("Link to Table", "No.");
                        ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                        ContBusinessRelation.SetRange("No.", "Bill-to Customer No.");
                        if ContBusinessRelation.FindFirst then
                            Cont.SetRange("Company No.", ContBusinessRelation."Contact No.")
                        else
                            Cont.SetRange("No.", '');
                    end;
                end;

                if "Bill-to Contact No." <> '' then
                    if Cont.Get("Bill-to Contact No.") then;
                if PAGE.RunModal(0, Cont) = ACTION::LookupOK then begin
                    xRec := Rec;
                    Validate("Bill-to Contact No.", Cont."No.");
                end;
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
            begin
                TestField(Status, Status::Open);

                if ("Bill-to Contact No." <> xRec."Bill-to Contact No.") and
                   (xRec."Bill-to Contact No." <> '')
                then begin
                    if HideValidationDialog then
                        Confirmed := true
                    else
                        Confirmed := Confirm(Text004, false, FieldCaption("Bill-to Contact No."));
                    if Confirmed then begin
                        SalesLine.Reset;
                        SalesLine.SetRange("Document Type", "Document Type");
                        SalesLine.SetRange("Document No.", "No.");
                        if ("Bill-to Contact No." = '') and ("Bill-to Customer No." = '') then begin
                            if not SalesLine.IsEmpty then
                                Error(Text005, FieldCaption("Bill-to Contact No."));
                            Init;
                            SalesSetup.Get;
                            InitRecord;
                            "No. Series" := xRec."No. Series";
                            if xRec."Shipping No." <> '' then begin
                                "Shipping No. Series" := xRec."Shipping No. Series";
                                "Shipping No." := xRec."Shipping No.";
                            end;
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            end;
                            if xRec."Return Receipt No." <> '' then begin
                                "Return Receipt No. Series" := xRec."Return Receipt No. Series";
                                "Return Receipt No." := xRec."Return Receipt No.";
                            end;
                            if xRec."Prepayment No." <> '' then begin
                                "Prepayment No. Series" := xRec."Prepayment No. Series";
                                "Prepayment No." := xRec."Prepayment No.";
                            end;
                            if xRec."Prepmt. Cr. Memo No." <> '' then begin
                                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                            end;
                            exit;
                        end;
                    end else begin
                        "Bill-to Contact No." := xRec."Bill-to Contact No.";
                        exit;
                    end;
                end;

                if ("Bill-to Customer No." <> '') and ("Bill-to Contact No." <> '') then begin
                    Cont.Get("Bill-to Contact No.");
                    ContBusinessRelation.Reset;
                    ContBusinessRelation.SetCurrentKey("Link to Table", "No.");
                    ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                    ContBusinessRelation.SetRange("No.", "Bill-to Customer No.");
                    if ContBusinessRelation.FindFirst then
                        if ContBusinessRelation."Contact No." <> Cont."Company No." then
                            Error(Text038, Cont."No.", Cont.Name, "Bill-to Customer No.");
                end;


            end;
        }
        field(5054; "Bill-to Customer Template Code"; Code[10])
        {
            Caption = 'Bill-to Customer Template Code';
            /*    TableRelation = "Customer Template"; */

            trigger OnValidate()
            var
            /*   BillToCustTemplate: Record "Customer Template"; */
            begin
                TestField("Document Type", "Document Type"::Quote);
                TestField(Status, Status::Open);

                if not InsertMode and
                   ("Bill-to Customer Template Code" <> xRec."Bill-to Customer Template Code") and
                   (xRec."Bill-to Customer Template Code" <> '')
                then begin
                    if HideValidationDialog then
                        Confirmed := true
                    else
                        Confirmed := Confirm(Text004, false, FieldCaption("Bill-to Customer Template Code"));
                    if Confirmed then begin
                        SalesLine.Reset;
                        SalesLine.SetRange("Document Type", "Document Type");
                        SalesLine.SetRange("Document No.", "No.");
                        if "Bill-to Customer Template Code" = '' then begin
                            if not SalesLine.IsEmpty then
                                Error(Text005, FieldCaption("Bill-to Customer Template Code"));
                            Init;
                            SalesSetup.Get;
                            InitRecord;
                            "No. Series" := xRec."No. Series";
                            if xRec."Shipping No." <> '' then begin
                                "Shipping No. Series" := xRec."Shipping No. Series";
                                "Shipping No." := xRec."Shipping No.";
                            end;
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            end;
                            if xRec."Return Receipt No." <> '' then begin
                                "Return Receipt No. Series" := xRec."Return Receipt No. Series";
                                "Return Receipt No." := xRec."Return Receipt No.";
                            end;
                            if xRec."Prepayment No." <> '' then begin
                                "Prepayment No. Series" := xRec."Prepayment No. Series";
                                "Prepayment No." := xRec."Prepayment No.";
                            end;
                            if xRec."Prepmt. Cr. Memo No." <> '' then begin
                                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                            end;
                            exit;
                        end;
                    end else begin
                        "Bill-to Customer Template Code" := xRec."Bill-to Customer Template Code";
                        exit;
                    end;
                end;

                Validate("Ship-to Code", '');
                /* if BillToCustTemplate.Get("Bill-to Customer Template Code") then begin
                    BillToCustTemplate.TestField("Customer Posting Group");
                    "Customer Posting Group" := BillToCustTemplate."Customer Posting Group";
                    "Invoice Disc. Code" := BillToCustTemplate."Invoice Disc. Code";
                    "Customer Price Group" := BillToCustTemplate."Customer Price Group";
                    "Customer Disc. Group" := BillToCustTemplate."Customer Disc. Group";
                    "Allow Line Disc." := BillToCustTemplate."Allow Line Disc.";
                    "Tax Area Code" := BillToCustTemplate."Tax Area Code";
                    "Tax Liable" := BillToCustTemplate."Tax Liable";
                    Validate("Payment Terms Code", BillToCustTemplate."Payment Terms Code");
                    Validate("Payment Method Code", BillToCustTemplate."Payment Method Code");
                    "Shipment Method Code" := BillToCustTemplate."Shipment Method Code";
                end; */

                /*  CreateDim( */
                /*   DATABASE::"Customer Template", "Bill-to Customer Template Code",
                  DATABASE::"Salesperson/Purchaser", "Salesperson Code",
                  DATABASE::Customer, "Bill-to Customer No.",
                  DATABASE::Campaign, "Campaign No.",
                  DATABASE::"Responsibility Center", "Responsibility Center");
 */
                /*  if not InsertMode and
                    (xRec."Sell-to Customer Template Code" = "Sell-to Customer Template Code") and
                    (xRec."Bill-to Customer Template Code" <> "Bill-to Customer Template Code")
                 then
                     RecreateSalesLines(FieldCaption("Bill-to Customer Template Code")); */
            end;
        }
        field(5055; "Opportunity No."; Code[20])
        {
            Caption = 'Opportunity No.';
            TableRelation = IF ("Document Type" = FILTER(<> Order)) Opportunity."No." WHERE("Contact No." = FIELD("Sell-to Contact No."),
                                                                                          Closed = CONST(false))
            ELSE
            IF ("Document Type" = CONST(Order)) Opportunity."No." WHERE("Contact No." = FIELD("Sell-to Contact No."),
                                                                                                                                                          "Sales Document No." = FIELD("No."),
                                                                                                                                                          "Sales Document Type" = CONST(Order));

            trigger OnValidate()
            begin

            end;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if not UserSetupMgt.CheckRespCenter(0, "Responsibility Center") then
                    Error(
                      Text027,
                      RespCenter.TableCaption, UserSetupMgt.GetSalesFilter);

                "Location Code" := UserSetupMgt.GetLocation(0, '', "Responsibility Center");
                if "Location Code" <> '' then begin
                    if Location.Get("Location Code") then
                        "Outbound Whse. Handling Time" := Location."Outbound Whse. Handling Time";
                end else begin
                    if InvtSetup.Get then
                        "Outbound Whse. Handling Time" := InvtSetup."Outbound Whse. Handling Time";
                end;

                /*    UpdateShipToAddress; */

                /*               CreateDim(
                                DATABASE::"Responsibility Center", "Responsibility Center",
                                DATABASE::Customer, "Bill-to Customer No.",
                                DATABASE::"Salesperson/Purchaser", "Salesperson Code",
                                DATABASE::Campaign, "Campaign No.",
                                DATABASE::"Customer Template", "Bill-to Customer Template Code"); */

                if xRec."Responsibility Center" <> "Responsibility Center" then begin
                    RecreateSalesLines(FieldCaption("Responsibility Center"));
                    "Assigned User ID" := '';
                end;
            end;
        }
        field(5750; "Shipping Advice"; Enum "Sales Header Shipping Advice")
        {
            Caption = 'Shipping Advice';
            //OptionCaption = 'Partial,Complete';
            //OptionMembers = Partial,Complete;

            trigger OnValidate()
            begin
                /*                 TestField(Status, Status::Open);
                                if InventoryPickConflict("Document Type", "No.", "Shipping Advice") then
                                    Error(Text066, FieldCaption("Shipping Advice"), Format("Shipping Advice"), TableCaption);
                                if WhseShpmntConflict("Document Type", "No.", "Shipping Advice") then
                                    Error(StrSubstNo(Text070, FieldCaption("Shipping Advice"), Format("Shipping Advice"), TableCaption));
                                //fes mig WhseSourceHeader.SalesHeaderVerifyChange(Rec,xRec); */
            end;
        }
        field(5751; "Shipped Not Invoiced"; Boolean)
        {
            CalcFormula = Exist("Sales Line" WHERE("Document Type" = FIELD("Document Type"),
                                                    "Document No." = FIELD("No."),
                                                    "Qty. Shipped Not Invoiced" = FILTER(<> 0)));
            Caption = 'Shipped Not Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5752; "Completely Shipped"; Boolean)
        {
            CalcFormula = Min("Sales Line"."Completely Shipped" WHERE("Document Type" = FIELD("Document Type"),
                                                                       "Document No." = FIELD("No."),
                                                                       Type = FILTER(<> " "),
                                                                       "Location Code" = FIELD("Location Filter")));
            Caption = 'Completely Shipped';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5753; "Posting from Whse. Ref."; Integer)
        {
            Caption = 'Posting from Whse. Ref.';
        }
        field(5754; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(5790; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Promised Delivery Date" <> 0D then
                    Error(
                      Text028,
                      FieldCaption("Requested Delivery Date"),
                      FieldCaption("Promised Delivery Date"));

                if "Requested Delivery Date" <> xRec."Requested Delivery Date" then
                    UpdateSalesLines(FieldCaption("Requested Delivery Date"), CurrFieldNo <> 0);
            end;
        }
        field(5791; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Promised Delivery Date" <> xRec."Promised Delivery Date" then
                    UpdateSalesLines(FieldCaption("Promised Delivery Date"), CurrFieldNo <> 0);
            end;
        }
        field(5792; "Shipping Time"; DateFormula)
        {
            Caption = 'Shipping Time';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Shipping Time" <> xRec."Shipping Time" then
                    UpdateSalesLines(FieldCaption("Shipping Time"), CurrFieldNo <> 0);
            end;
        }
        field(5793; "Outbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Outbound Whse. Handling Time';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if ("Outbound Whse. Handling Time" <> xRec."Outbound Whse. Handling Time") and
                   (xRec."Sell-to Customer No." = "Sell-to Customer No.")
                then
                    UpdateSalesLines(FieldCaption("Outbound Whse. Handling Time"), CurrFieldNo <> 0);
            end;
        }
        field(5794; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"));

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                /*  GetShippingTime(FieldNo("Shipping Agent Service Code")); */
                UpdateSalesLines(FieldCaption("Shipping Agent Service Code"), CurrFieldNo <> 0);
            end;
        }
        field(5795; "Late Order Shipping"; Boolean)
        {
            CalcFormula = Exist("Sales Line" WHERE("Document Type" = FIELD("Document Type"),
                                                    "Sell-to Customer No." = FIELD("Sell-to Customer No."),
                                                    "Document No." = FIELD("No."),
                                                    "Shipment Date" = FIELD("Date Filter"),
                                                    "Outstanding Quantity" = FILTER(<> 0)));
            Caption = 'Late Order Shipping';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5796; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(5800; Receive; Boolean)
        {
            Caption = 'Receive';
        }
        field(5801; "Return Receipt No."; Code[20])
        {
            Caption = 'Return Receipt No.';
        }
        field(5802; "Return Receipt No. Series"; Code[10])
        {
            Caption = 'Return Receipt No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                //fes mig SalesHeader := Rec;
                SalesSetup.Get;
                SalesSetup.TestField("Posted Return Receipt Nos.");
                if NoSeriesMgt.LookupRelatedNoSeries(SalesSetup."Posted Return Receipt Nos.", SalesHeader."Return Receipt No. Series") then
                    SalesHeader.Validate("Return Receipt No. Series");
                //fes mig Rec := SalesHeader;
            end;

            trigger OnValidate()
            begin
                if "Return Receipt No. Series" <> '' then begin
                    SalesSetup.Get;
                    SalesSetup.TestField("Posted Return Receipt Nos.");
                    NoSeriesMgt.LookupRelatedNoSeries(SalesSetup."Posted Return Receipt Nos.", "Return Receipt No. Series");
                end;
                TestField("Return Receipt No.", '');
            end;
        }
        field(5803; "Last Return Receipt No."; Code[20])
        {
            Caption = 'Last Return Receipt No.';
            Editable = false;
            TableRelation = "Return Receipt Header";
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                MessageIfSalesLinesExist(FieldCaption("Allow Line Disc."));
            end;
        }
        field(7200; "Get Shipment Used"; Boolean)
        {
            Caption = 'Get Shipment Used';
            Editable = false;
        }
        field(9000; "Assigned User ID"; Code[50])
        {
            Caption = 'Assigned User ID';
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                if not UserSetupMgt.CheckRespCenter(0, "Responsibility Center", "Assigned User ID") then
                    Error(
                      Text061, "Assigned User ID",
                      RespCenter.TableCaption, UserSetupMgt.GetSalesFilter("Assigned User ID"));
            end;
        }
        field(10005; "Ship-to UPS Zone"; Code[2])
        {
            Caption = 'Ship-to UPS Zone';
        }
        field(10009; "Outstanding Amount ($)"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Outstanding Amount (LCY)" WHERE("Document Type" = FIELD("Document Type"),
                                                                             "Document No." = FIELD("No.")));
            Caption = 'Outstanding Amount ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10015; "Tax Exemption No."; Text[30])
        {
            Caption = 'Tax Exemption No.';
        }
        field(10018; "STE Transaction ID"; Text[20])
        {
            Caption = 'STE Transaction ID';
            Editable = false;
        }
        field(12600; "Prepmt. Include Tax"; Boolean)
        {
            Caption = 'Prepmt. Include Tax';

            trigger OnValidate()
            var
                GLSetup: Record "General Ledger Setup";
            begin
                /*  if IsPrepmtInvoicePosted then
                     Error(PrepmtInvoiceExistsErr, FieldCaption("Prepmt. Include Tax")); */
                if xRec."Prepmt. Include Tax" = "Prepmt. Include Tax" then
                    exit;
                if not "Prepmt. Include Tax" then
                    exit;
                if "Currency Code" = '' then
                    exit;
                GLSetup.Get;
                if GLSetup."LCY Code" = "Currency Code" then
                    exit;
                Error(PrepmtIncludeTaxErr, FieldCaption("Prepmt. Include Tax"));
            end;
        }
        field(50000; "Estado distribucion"; Option)
        {
            OptionMembers = " ","Para Confirmar","Para empaque","Para despacho",Entregado;
        }
        field(50008; "No. copias Picking"; Integer)
        {
            Caption = 'No. Printed Picking';
            Editable = false;
        }
        field(50009; "Nota de Credito"; Boolean)
        {

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
            OptionCaption = 'Invoice,Consignation,Sample,Donations';
            OptionMembers = Factura,Consignacion,Muestras,Donaciones;

            trigger OnValidate()
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
        }
        field(50012; "Cantidad para devolucion"; Decimal)
        {
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
            Caption = 'Venta a Teléfono';
            Description = 'Ecuador';
        }
        field(55001; "Ship-to Phone"; Code[30])
        {
            Caption = 'Ship-to Phone';
            Description = 'Ecuador';
        }
        field(55002; "No. Correlativo Rem. a Anular"; Code[20])
        {
            Caption = 'Remision Correlative No. to Void';
        }
        field(55003; "No. Correlativo Rem. Anulado"; Code[20])
        {
            Caption = 'Remision Correlative No. Voided';
        }
        field(55004; "No. documento Rem. a Anular"; Code[20])
        {
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
        }
        field(55006; "No. Factura a Anular"; Code[20])
        {
            Caption = 'Invoice No. To Void';
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
        }
        field(55010; "No. Autorizacion Comprobante"; Code[20])
        {
            Caption = 'Authorization Voucher No.';
            Description = 'SRI';
        }
        field(55012; "Tipo de Comprobante"; Code[2])
        {
            Caption = 'Voucher Type';
            Description = 'SRI';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("TIPOS COMPROBANTES AUTORIZADOS"));
        }
        field(55013; "Establecimiento Factura"; Code[3])
        {
            Caption = 'Invoice Location';
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
            Description = 'SRI';
        }
        field(55016; "Punto de Emision Remision"; Code[3])
        {
            Caption = 'Shipment Issue Point';
            Description = 'SRI';
        }
        field(55017; "No. Autorizacion Remision"; Code[20])
        {
            Caption = 'Remission Auth. No.';
            Description = 'SRI';
        }
        field(55018; "Tipo Comprobante Remision"; Code[2])
        {
            Caption = 'Remission Voucher Type';
            Description = 'SRI';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("TIPOS COMPROBANTES AUTORIZADOS"));
        }
        field(55021; "No. Telefono"; Code[13])
        {
            Caption = 'Phone';
            Description = 'Ecuador';
        }
        field(55022; "Tipo Ruc/Cedula"; Option)
        {
            Caption = 'RUC/ID Type';
            Description = 'Ecuador';
            OptionCaption = ' ,R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA,R.U.C. PUBLICOS,RUC PERSONA NATURAL,ID';
            OptionMembers = " ","R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA","R.U.C. PUBLICOS","RUC PERSONA NATURAL",CEDULA;

            trigger OnValidate()
            begin
                Clear("VAT Registration No.");//016
            end;
        }
        field(55023; "No. Validar Comprobante Rel."; Boolean)
        {
            Caption = 'Not validate Rel. Fiscal Document ';
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
            Description = 'Ecuador';
        }
        field(56000; "Pedido Consignacion"; Boolean)
        {

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
            TableRelation = "Salesperson/Purchaser".Code WHERE(Tipo = FILTER(Cobrador));
        }
        field(56002; "Pre pedido"; Boolean)
        {
            Caption = 'Pre Order';
        }
        field(56003; "Devolucion Consignacion"; Boolean)
        {
        }
        field(56004; "Cod. Cupon"; Code[10])
        {
            Caption = 'Coupon Code';
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
            TableRelation = Contact WHERE(Type = FILTER(Company));

            trigger OnValidate()
            begin
                //004
                if Contacto.Get("Cod. Colegio") then
                    "Nombre Colegio" := Contacto.Name;
                //004
            end;
        }
        field(56007; "Nombre Colegio"; Text[60])
        {
            Caption = 'School Name';
        }
        field(56008; "Re facturacion"; Boolean)
        {
        }
        field(56010; CAE; Text[160])
        {
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56011; "Respuesta CAE"; Text[100])
        {
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56012; pIdSat; Text[50])
        {
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56013; "No. Resolucion"; Code[30])
        {
            Caption = 'Resolution No.';
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56014; "Fecha Resolucion"; Date)
        {
            Caption = 'Resolution Date';
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56015; "Serie Desde"; Code[20])
        {
            Caption = 'Series From';
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56016; "Serie hasta"; Code[20])
        {
            Caption = 'Serie To';
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56017; "Serie Resolucion"; Code[20])
        {
            Caption = 'Resolution Serie';
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56018; CAEC; Text[160])
        {
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56020; "No aplica Derechos de Autor"; Boolean)
        {
            Caption = 'Apply Author Copyright';
            Description = 'DerAut 1.0';
        }
        field(56021; Promocion; Boolean)
        {
            Caption = 'Promotion';
        }
        field(56032; "Fecha Recepcion"; Date)
        {
            Caption = 'Reception Date';
        }
        field(56033; "Siguiente No. Nota. Cr."; Code[20])
        {
            CalcFormula = Lookup("No. Series Line"."Last No. Used" WHERE("Series Code" = FIELD("No. Serie NCF Abonos"),
                                                                          Open = FILTER(true)));
            FieldClass = FlowField;
        }
        field(56042; "Creado por usuario"; Code[20])
        {
            TableRelation = User;

        }
        field(56062; "Cantidad de Bultos"; Integer)
        {
            Caption = 'Packages Qty.';
        }
        field(56070; "No. Envio de Almacen"; Code[20])
        {
            Caption = 'Warehouse Shipment No.';
            TableRelation = "Warehouse Shipment Header";
        }
        field(56071; "No. Picking"; Code[20])
        {
            Caption = 'Pciking No.';
            TableRelation = "Warehouse Activity Header";
        }
        field(56072; "No. Picking Reg."; Code[20])
        {
            Caption = 'Posted Picking No.';
            TableRelation = "Registered Whse. Activity Hdr."."No.";
        }
        field(56073; "No. Packing"; Code[20])
        {
            Caption = 'Packing No.';
            TableRelation = "Cab. Packing";
        }
        field(56074; "No. Packing Reg."; Code[20])
        {
            Caption = 'Posted Packing No.';
            TableRelation = "Cab. Packing Registrado"."No.";
        }
        field(56075; "No. Factura"; Code[20])
        {
            Caption = 'Invoice No.';
            TableRelation = "Sales Invoice Header";
        }
        field(56076; "No. Envio"; Code[20])
        {
            Caption = 'Shippment No.';
            TableRelation = "Sales Shipment Header"."No.";
        }
        field(56077; "% de aprobacion"; Decimal)
        {
            Caption = 'Approval %';
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            var
                SalesLineCant: Record "Sales Line";
                CounterTotal: Integer;
                Counter: Integer;
                Window: Dialog;
                Text0001: Label 'Updating  #1########## @2@@@@@@@@@@@@@';
            begin
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
                    if SalesLineCant.FindSet() then begin
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

                //MOI - 09/12/2014 (#7419):Inicio
                if xRec."% de aprobacion" <> "% de aprobacion" then begin
                    "Fecha Aprobacion" := WorkDate;
                    "Hora Aprobacion" := Time;
                end;
                //MOI - 09/12/2014 (#7419):Fin
            end;
        }
        field(56078; "Fecha Lanzado"; Date)
        {
            Caption = 'Released Date';
        }
        field(56079; "Hora Lanzado"; Time)
        {
            Caption = 'Released Time';
        }
        field(56098; "En Hoja de Ruta"; Boolean)
        {
            Caption = 'In Route Sheet';
        }
        field(56100; "Fecha Aprobacion"; Date)
        {
        }
        field(56101; "Hora Aprobacion"; Time)
        {
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
            Description = '#830';
        }
        field(56301; "Pago recibido"; Boolean)
        {
            Description = '#830';
        }
        field(56302; "Aprobado cobros"; Boolean)
        {
            Description = '#830';
            Editable = false;
        }
        field(76046; "ID Cajero"; Code[20])
        {
            Caption = 'Cashier ID';
            Description = 'DsPOS Standard';
            TableRelation = Cajeros.ID WHERE(Tienda = FIELD(Tienda));
        }
        field(76029; "Hora creacion"; Time)
        {
            Caption = 'Creation time';
            Description = 'DsPOS Standard';
        }
        field(76011; "Venta TPV"; Boolean)
        {
            Caption = 'POS Sales';
            Description = 'DsPOS Standard';
        }
        field(76016; TPV; Code[20])
        {
            Caption = 'POS';
            Description = 'DsPOS Standard';
            TableRelation = "Configuracion TPV"."Id TPV" WHERE(Tienda = FIELD(Tienda));
        }
        field(76018; Tienda; Code[20])
        {
            Caption = 'Shop';
            Description = 'DsPOS Standard';
            TableRelation = Tiendas."Cod. Tienda";
        }
        field(76015; "Venta a credito"; Boolean)
        {
            Caption = 'Venta a credito';
            Description = 'DsPOS Standard';
        }
        field(76027; "Registrado TPV"; Boolean)
        {
            Caption = 'Registrado TPV';
            Description = 'DsPOS Standard';
        }
        field(76025; "Anulado TPV"; Boolean)
        {
            Caption = 'Anulado TPV';
            Description = 'DsPOS Standard';
        }
        field(76017; "Nº Fiscal TPV"; Code[40])
        {
            Caption = 'Nº Fiscal TPV';
            Description = 'DsPOS Standard';
        }
        field(76021; Turno; Integer)
        {
            Caption = 'Turno';
            Description = 'DsPOS Standard';
        }
        field(76030; "Anulado por Documento"; Code[20])
        {
            Caption = 'Anulado por Documento';
            Description = 'DsPOS Standard';
        }
        field(76295; "Anula a Documento"; Code[20])
        {
            Caption = 'Anula a Documento';
            Description = 'DsPOS Standard';
        }
        field(76227; Devolucion; Boolean)
        {
            Caption = 'Devolucion';
            Description = 'DsPOS Standard';
        }
        field(76313; "Nº Telefono"; Text[30])
        {
            Caption = 'Nº Telefono';
            Description = 'DsPOS Standard';
        }
        field(76041; "No. Serie NCF Facturas"; Code[10])
        {
            Caption = 'Invoice FDN Serial No.';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                //005
                if NoSeries.Get("No. Serie NCF Facturas") then begin
                    if ("Document Type" = "Document Type"::Order) or ("Document Type" = "Document Type"::Invoice) then
                        NoSeries.TestField("Tipo Documento", NoSeries."Tipo Documento"::Factura);
                    if ("Document Type" = "Document Type"::"Credit Memo") or ("Document Type" = "Document Type"::"Return Order") then
                        NoSeries.TestField("Tipo Documento", NoSeries."Tipo Documento"::"Nota de Crédito");
                end;
                //005
            end;
        }
        field(76079; "No. Comprobante Fiscal"; Code[19])
        {
            Caption = 'Fiscal Document No.';

            trigger OnValidate()
            begin

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
        field(76080; "No. Comprobante Fiscal Rel."; Code[19])
        {
            Caption = 'Related FDN';
        }
        field(76056; "Razon anulacion NCF"; Code[20])
        {
            Caption = 'Reason to void FDN';
            TableRelation = "Razones Anulacion NCF";
        }
        field(76057; "No. Serie NCF Abonos"; Code[10])
        {
            Caption = 'Credit Memo NCF Serial No.';
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
        field(76078; "Cod. Clasificacion Gastos"; Code[2])
        {
            Caption = 'Expense Clasification Code';
        }
        field(76058; "Ultimo. No. NCF"; Code[19])
        {
        }
        field(76006; "No. Serie NCF Remision"; Code[10])
        {
            Caption = 'Remission Series No.';
            TableRelation = "No. Series";
        }
        field(76088; "No. Comprobante Fisc. Remision"; Code[20])
        {
            Caption = 'Remission NCF';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
        key(Key2; "No.", "Document Type")
        {
        }
        key(Key3; "Document Type", "Sell-to Customer No.")
        {
        }
        key(Key4; "Document Type", "Bill-to Customer No.")
        {
        }
        key(Key5; "Document Type", "Combine Shipments", "Bill-to Customer No.", "Currency Code", "EU 3-Party Trade")
        {
        }
        key(Key6; "Sell-to Customer No.", "External Document No.")
        {
        }
        key(Key7; "Document Type", "Sell-to Contact No.")
        {
        }
        key(Key8; "Bill-to Contact No.")
        {
        }
        key(Key9; "Incoming Document Entry No.")
        {
        }
        key(Key10; "External Document No.")
        {
        }
        key(Key11; "Document Type", "Sell-to Customer No.", Status)
        {
        }
        key(Key12; "Posting Date")
        {
        }
        key(Key13; "Requested Delivery Date")
        {
        }
        key(Key14; "Promised Delivery Date")
        {
        }
        key(Key15; "Shipment Date")
        {
        }
        key(Key16; "ID Cajero", "Venta TPV")
        {
        }
        key(Key17; "Venta TPV")
        {
        }
        key(Key18; "Venta TPV", "Nº Fiscal TPV", "Posting Date", TPV, "Sell-to Customer No.", Turno)
        {
        }
        key(Key19; "Posting No.")
        {
        }
        key(Key20; "Posting Date", "Venta TPV", Tienda, "Registrado TPV")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Opp: Record Opportunity;
        TempOpportunityEntry: Record "Opportunity Entry" temporary;
    begin
        /*
        IF DOPaymentTransLogEntry.FINDFIRST THEN
          DOPaymentTransLogMgt.ValidateCanDeleteDocument("Payment Method Code","Document Type",FORMAT("Document Type"),"No.");
        */
        //fes mig

        if not UserSetupMgt.CheckRespCenter(0, "Responsibility Center") then
            Error(
              Text022,
              RespCenter.TableCaption, UserSetupMgt.GetSalesFilter);

        if ("Opportunity No." <> '') and
           ("Document Type" in ["Document Type"::Quote, "Document Type"::Order])
        then begin
            if Opp.Get("Opportunity No.") then begin
                if "Document Type" = "Document Type"::Order then begin
                    if not Confirm(Text040, true) then
                        Error(Text044);
                    TempOpportunityEntry.Init;
                    TempOpportunityEntry.Validate("Opportunity No.", Opp."No.");
                    TempOpportunityEntry."Sales Cycle Code" := Opp."Sales Cycle Code";
                    TempOpportunityEntry."Contact No." := Opp."Contact No.";
                    TempOpportunityEntry."Contact Company No." := Opp."Contact Company No.";
                    TempOpportunityEntry."Salesperson Code" := Opp."Salesperson Code";
                    TempOpportunityEntry."Campaign No." := Opp."Campaign No.";
                    TempOpportunityEntry."Action Taken" := TempOpportunityEntry."Action Taken"::Lost;
                    TempOpportunityEntry.Insert;
                    TempOpportunityEntry.SetRange("Action Taken", TempOpportunityEntry."Action Taken"::Lost);
                    PAGE.RunModal(PAGE::"Close Opportunity", TempOpportunityEntry);
                    if Opp.Get("Opportunity No.") then
                        if Opp.Status <> Opp.Status::Lost then
                            Error(Text043);
                end;
                Opp."Sales Document Type" := Opp."Sales Document Type"::" ";
                Opp."Sales Document No." := '';
                Opp.Modify;
                "Opportunity No." := '';
            end;
        end;

        //fes mig
        /*
        SalesPost.DeleteHeader(
          Rec,SalesShptHeader,SalesInvHeader,SalesCrMemoHeader,ReturnRcptHeader,SalesInvHeaderPrepmt,SalesCrMemoHeaderPrepmt);
        */
        //fes mig
        Validate("Applies-to ID", '');

        /*ApprovalMgt.DeleteApprovalEntry(DATABASE::"Sales Header","Document Type","No.");*/ //fes mig
        SalesLine.Reset;
        SalesLine.LockTable;

        WhseRequest.SetRange("Source Type", DATABASE::"Sales Line");
        WhseRequest.SetRange("Source Subtype", "Document Type");
        WhseRequest.SetRange("Source No.", "No.");
        WhseRequest.DeleteAll(true);

        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        SalesLine.SetRange(Type, SalesLine.Type::"Charge (Item)");

        /*  DeleteSalesLines;
         SalesLine.SetRange(Type);
         DeleteSalesLines;
  */
        SalesCommentLine.SetRange("Document Type", "Document Type");
        SalesCommentLine.SetRange("No.", "No.");
        SalesCommentLine.DeleteAll;

        if "Tax Area Code" <> '' then begin
            //SalesTaxDifference.Reset;
            // SalesTaxDifference.SetRange("Document Product Area", SalesTaxDifference."Document Product Area"::Sales);
            // SalesTaxDifference.SetRange("Document Type", "Document Type");
            // SalesTaxDifference.SetRange("Document No.", "No.");
            //SalesTaxDifference.DeleteAll;
        end;
        if (SalesShptHeader."No." <> '') or
           (SalesInvHeader."No." <> '') or
           (SalesCrMemoHeader."No." <> '') or
           (ReturnRcptHeader."No." <> '') or
           (SalesInvHeaderPrepmt."No." <> '') or
           (SalesCrMemoHeaderPrepmt."No." <> '')
        then begin
            Commit;

            if SalesShptHeader."No." <> '' then
                if Confirm(
                     Text000, true,
                     SalesShptHeader."No.")
                then begin
                    SalesShptHeader.SetRecFilter;
                    SalesShptHeader.PrintRecords(true);
                end;

            if SalesInvHeader."No." <> '' then
                if Confirm(
                     Text001, true,
                     SalesInvHeader."No.")
                then begin
                    SalesInvHeader.SetRecFilter;
                    SalesInvHeader.PrintRecords(true);
                end;

            if SalesCrMemoHeader."No." <> '' then
                if Confirm(
                     Text002, true,
                     SalesCrMemoHeader."No.")
                then begin
                    SalesCrMemoHeader.SetRecFilter;
                    SalesCrMemoHeader.PrintRecords(true);
                end;

            if ReturnRcptHeader."No." <> '' then
                if Confirm(
                     Text023, true,
                     ReturnRcptHeader."No.")
                then begin
                    ReturnRcptHeader.SetRecFilter;
                    ReturnRcptHeader.PrintRecords(true);
                end;

            if SalesInvHeaderPrepmt."No." <> '' then
                if Confirm(
                     Text055, true,
                     SalesInvHeader."No.")
                then begin
                    SalesInvHeaderPrepmt.SetRecFilter;
                    SalesInvHeaderPrepmt.PrintRecords(true);
                end;

            if SalesCrMemoHeaderPrepmt."No." <> '' then
                if Confirm(
                     Text054, true,
                     SalesCrMemoHeaderPrepmt."No.")
                then begin
                    SalesCrMemoHeaderPrepmt.SetRecFilter;
                    SalesCrMemoHeaderPrepmt.PrintRecords(true);
                end;
        end;


        /*         if "Document Type" = "Document Type"::"Return Order" then   //023
                   /*  ControlClasificacionDevolucion;   */                      //

    end;

    trigger OnInsert()
    var
        rConf: Record "Config. Empresa";
    begin
        SalesSetup.Get;

        if "No." = '' then begin
            TestNoSeries;
            //NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");
            Rec."No. series" := GetNoSeriesCode;
            if NoSeriesMgt.AreRelated(GetNoSeriesCode, xRec."No. Series") then
                Rec."No. Series" := xRec."No. Series";
            Rec."No." := NoSeriesMgt.GetNextNo(Rec."No. Series", Rec."Posting Date", true);
        end;

        InitRecord;
        InsertMode := true;

        if GetFilter("Sell-to Customer No.") <> '' then
            if GetRangeMin("Sell-to Customer No.") = GetRangeMax("Sell-to Customer No.") then
                Validate("Sell-to Customer No.", GetRangeMin("Sell-to Customer No."));

        if GetFilter("Sell-to Contact No.") <> '' then
            if GetRangeMin("Sell-to Contact No.") = GetRangeMax("Sell-to Contact No.") then
                Validate("Sell-to Contact No.", GetRangeMin("Sell-to Contact No."));

        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Sales Header", "Document Type".asInteger(), "No.");


        //+#830
        if "Venta Call Center" then begin
            rConf.Get;
            rConf.TestField("Cód Cliente Call Center");
            Validate("Sell-to Customer No.", rConf."Cód Cliente Call Center");
        end;
        //-#830
    end;

    trigger OnRename()
    begin
        Error(Text003, TableCaption);
    end;

    var
        Text000: Label 'Do you want to print shipment %1?';
        Text001: Label 'Do you want to print invoice %1?';
        Text002: Label 'Do you want to print credit memo %1?';
        Text003: Label 'You cannot rename a %1.';
        Text004: Label 'Do you want to change %1?';
        Text005: Label 'You cannot reset %1 because the document still has one or more lines.';
        Text006: Label 'You cannot change %1 because the order is associated with one or more purchase orders.';
        Text007: Label '%1 cannot be greater than %2 in the %3 table.';
        Text009: Label 'Deleting this document will cause a gap in the number series for shipments. An empty shipment %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text012: Label 'Deleting this document will cause a gap in the number series for posted invoices. An empty posted invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text014: Label 'Deleting this document will cause a gap in the number series for posted credit memos. An empty posted credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text015: Label 'If you change %1, the existing sales lines will be deleted and new sales lines based on the new information on the header will be created.\\Do you want to change %1?';
        Text017: Label 'You must delete the existing sales lines before you can change %1.';
        Text018: Label 'You have changed %1 on the sales header, but it has not been changed on the existing sales lines.\';
        Text019: Label 'You must update the existing sales lines manually.';
        Text020: Label 'The change may affect the exchange rate used in the price calculation of the sales lines.';
        Text021: Label 'Do you want to update the exchange rate?';
        Text022: Label 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
        Text023: Label 'Do you want to print return receipt %1?';
        Text024: Label 'You have modified the %1 field. The recalculation of tax may cause penny differences, so you must check the amounts afterward. Do you want to update the %2 field on the lines to reflect the new value of %1?';
        Text027: Label 'Your identification is set up to process from %1 %2 only.';
        Text028: Label 'You cannot change the %1 when the %2 has been filled in.';
        Text030: Label 'Deleting this document will cause a gap in the number series for return receipts. An empty return receipt %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text031: Label 'You have modified %1.\\';
        Text032: Label 'Do you want to update the lines?';
        Text067: Label '%1 %4 with amount of %2 has already been authorized on %3 and is not expired yet. You must void the previous authorization before you can re-authorize this %1.';
        Text068: Label 'There is nothing to void.';
        Text069: Label 'The selected operation cannot complete with the specified %1.';
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        CurrExchRate: Record "Currency Exchange Rate";
        SalesCommentLine: Record "Sales Comment Line";
        ShipToAddr: Record "Ship-to Address";
        PostCode: Record "Post Code";
        BankAcc: Record "Bank Account";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        SalesInvHeaderPrepmt: Record "Sales Invoice Header";
        SalesCrMemoHeaderPrepmt: Record "Sales Cr.Memo Header";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        GenJnILine: Record "Gen. Journal Line";
        RespCenter: Record "Responsibility Center";
        InvtSetup: Record "Inventory Setup";
        Location: Record Location;
        WhseRequest: Record "Warehouse Request";
        ShippingAgentService: Record "Shipping Agent Services";
        TempReqLine: Record "Requisition Line" temporary;
        //SalesTaxDifference: Record "Sales Tax Amount Difference";
        UserSetupMgt: Codeunit "User Setup Management";
        NoSeriesMgt: Codeunit "No. Series";
        /*   CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit"; */
        TransferExtendedText: Codeunit "Transfer Extended Text";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        SalesPost: Codeunit "Sales-Post";
        CustEntrySetApplID: Codeunit "Cust. Entry-SetAppl.ID";
        DimMgt: Codeunit DimensionManagement;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        WhseSourceHeader: Codeunit "Whse. Validate Source Header";
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        ApplyCustEntries: Page "Apply Customer Entries";
        CurrencyDate: Date;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text035: Label 'You cannot Release Quote or Make Order unless you specify a customer on the quote.\\Do you want to create customer(s) now?';
        Text037: Label 'Contact %1 %2 is not related to customer %3.';
        Text038: Label 'Contact %1 %2 is related to a different company than customer %3.';
        Text039: Label 'Contact %1 %2 is not related to a customer.';
        ReservEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
        Text040: Label 'A won opportunity is linked to this order.\It has to be changed to status Lost before the Order can be deleted.\Do you want to change the status for this opportunity now?';
        Text043: Label 'Wizard Aborted';
        Text044: Label 'The status of the opportunity has not been changed. The program has aborted deleting the order.';
        SkipSellToContact: Boolean;
        SkipBillToContact: Boolean;
        Text045: Label 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.';
        Text048: Label 'Sales quote %1 has already been assigned to opportunity %2. Would you like to reassign this quote?';
        Text049: Label 'The %1 field cannot be blank because this quote is linked to an opportunity.';
        InsertMode: Boolean;
        CompanyInfo: Record "Company Information";
        HideCreditCheckDialogue: Boolean;
        Text051: Label 'The sales %1 %2 already exists.';
        Text052: Label 'The sales %1 %2 has item tracking. Do you want to delete it anyway?';
        Text053: Label 'You must cancel the approval process if you wish to change the %1.';
        Text055: Label 'Do you want to print prepayment invoice %1?';
        Text054: Label 'Do you want to print prepayment credit memo %1?';
        Text056: Label 'Deleting this document will cause a gap in the number series for prepayment invoices. An empty prepayment invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text057: Label 'Deleting this document will cause a gap in the number series for prepayment credit memos. An empty prepayment credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text061: Label '%1 is set up to process from %2 %3 only.';
        Text062: Label 'You cannot change %1 because the corresponding %2 %3 has been assigned to this %4.';
        Text063: Label 'Reservations exist for this order. These reservations will be canceled if a date conflict is caused by this change.\\Do you want to continue?';
        Text064: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        UpdateDocumentDate: Boolean;
        Text066: Label 'You cannot change %1 to %2 because an open inventory pick on the %3.';
        Text070: Label 'You cannot change %1  to %2 because an open warehouse shipment exists for the %3.';
        BilltoCustomerNoChanged: Boolean;
        Text071: Label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';
        Text072: Label 'There are unpaid prepayment invoices related to the document of type %1 with the number %2.';
        PrepmtIncludeTaxErr: Label 'You cannot select the %1 field for foreign currencies.', Comment = '%1 is the feildname Prepmt. Include Tax';
        PrepmtInvoiceExistsErr: Label 'You cannot change %1 because there is a posted Prepayment Invoice.';
        SynchronizingMsg: Label 'Synchronizing ...\ from: Sales Header with %1\ to: Assembly Header with %2.';
        ShippingAdviceErr: Label 'This order must be a complete Shipment.';
        "*** Santillana ***": Integer;
        SantSetup: Record "Config. Empresa";
        SalesLine1: Record "Sales Line";
        GenBusPostGrp: Record "Gen. Business Posting Group";
        Cliente: Record Customer;
        Error0001: Label 'No puede modificar un pedido tipo TPV o Factura comprimida';
        txt001: Label 'Se eliminaran las líneas de ventas del pedido, confirma que desea continuar';
        Msg002: Label 'Existe otro pedido tipo Consignación para este Cliente - No. Pedido %1, desea continuar?';
        Msg003: Label 'Existe un pedido de Devolución de consignación en borrador para este cliente - No. Pedido %1, desea continuar?';
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
        Error002: Label 'Existe otro pedido tipo Consignacion para este cliente - No. Pedido %1';
        Error003: Label 'Existe un pedido de Devolucion de consignacion en borrador para este cliente - No. Pedido %1';
        "**007**": Integer;
        SIH: Record "Sales Invoice Header";
        Error004: Label 'The Invoice %1 does not belong to the customer %2';
        NSL: Record "No. Series Line";
        Error005: Label 'The Serial Number must be internal. This has an associated resolution.';
        Error006: Label 'El Número de serie debe ser interno. Este tiene Tipo Generación';
        CPG: Record "Customer Posting Group";
        Item: Record Item;
        UserSetUp: Record "User Setup";
        LoginMgt: Codeunit "User Management";
        SSH: Record "Sales Shipment Header";
        SCMH: Record "Sales Cr.Memo Header";
        NCFAnulados: Record "NCF Anulados";
        Error007: Label 'Correlative No. %1 Is already voided. Check in Voided Correlative Table';
        ValidaCampos: Codeunit "Valida Campos Requeridos";
        NoSeriesLine: Record "No. Series Line";
        FuncEcuador: Codeunit "Funciones Ecuador";
        CantidadSol: Decimal;
        Cantidad: Decimal;
        _TPV: Record Tiendas;
        Text56000: Label 'El documento %1 se generó automáticamente por clasificación de devoluciones. No es posible su modificación manual.';
        ContacBusRel: Record "Contact Business Relation";
        MktSetUp: Record "Marketing Setup";


    procedure InitRecord()
    begin
        SalesSetup.Get;

        case "Document Type" of
            "Document Type"::Quote, "Document Type"::Order:
                begin
                    Rec."Posting No. Series" := SalesSetup."Posted Invoice Nos.";
                    Rec."Shipping No. Series" := SalesSetup."Posted Shipment Nos.";
                    if "Document Type" = "Document Type"::Order then begin
                        Rec."Prepayment No. Series" := SalesSetup."Posted Prepmt. Inv. Nos.";
                        Rec."Prepmt. Cr. Memo No. Series" := SalesSetup."Posted Prepmt. Cr. Memo Nos.";
                    end;
                end;
            "Document Type"::Invoice:
                begin
                    if ("No. Series" <> '') and
                       (SalesSetup."Invoice Nos." = SalesSetup."Posted Invoice Nos.")
                    then
                        "Posting No. Series" := "No. Series"
                    else
                        Rec."Posting No. Series" := SalesSetup."Posted Invoice Nos.";
                    if SalesSetup."Shipment on Invoice" then
                        Rec."Shipping No. Series" := SalesSetup."Posted Shipment Nos.";
                end;
            "Document Type"::"Return Order":
                begin
                    Rec."Posting No. Series" := SalesSetup."Posted Credit Memo Nos.";
                    Rec."Return Receipt No. Series" := SalesSetup."Posted Return Receipt Nos.";
                end;
            "Document Type"::"Credit Memo":
                begin
                    if ("No. Series" <> '') and
                       (SalesSetup."Credit Memo Nos." = SalesSetup."Posted Credit Memo Nos.")
                    then
                        "Posting No. Series" := "No. Series"
                    else
                        Rec."Posting No. Series" := SalesSetup."Posted Credit Memo Nos.";
                    if SalesSetup."Return Receipt on Credit Memo" then
                        Rec."Return Receipt No. Series" := SalesSetup."Posted Return Receipt Nos.";

                end;
        end;

        if "Document Type" in ["Document Type"::Order, "Document Type"::Invoice, "Document Type"::Quote] then begin
            "Shipment Date" := WorkDate;
            "Order Date" := WorkDate;
        end;
        if "Document Type" = "Document Type"::"Return Order" then
            "Order Date" := WorkDate;

        if not ("Document Type" in ["Document Type"::"Blanket Order", "Document Type"::Quote]) and
           ("Posting Date" = 0D)
        then
            "Posting Date" := WorkDate;

        if SalesSetup."Default Posting Date" = SalesSetup."Default Posting Date"::"No Date" then
            "Posting Date" := 0D;

        "Document Date" := WorkDate;

        Validate("Location Code", UserSetupMgt.GetLocation(0, Cust."Location Code", "Responsibility Center"));

        if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then begin
            GLSetup.Get;
            Correction := GLSetup."Mark Cr. Memos as Corrections";
        end;

        "Posting Description" := Format("Document Type") + ' ' + "No.";

        Reserve := Reserve::Optional;

        if InvtSetup.Get then
            Validate("Outbound Whse. Handling Time", InvtSetup."Outbound Whse. Handling Time");

        "Responsibility Center" := UserSetupMgt.GetRespCenter(0, "Responsibility Center");
    end;


    procedure AssistEdit(OldSalesHeader: Record "Sales Header"): Boolean
    var
        SalesHeader2: Record "Sales Header";
        NoSeries: Code[10];
    begin
        SalesSetup.Get;
        TestNoSeries;
        NoSeries := "No. Series";
        if NoSeriesMgt.LookupRelatedNoSeries(GetNoSeriesCode, OldSalesHeader."No. Series", "No. Series") and
           (NoSeries <> "No. Series")
        then begin
            if ("Sell-to Customer No." = '') and ("Sell-to Contact No." = '') then begin
                HideCreditCheckDialogue := false;
                /*        CheckCreditMaxBeforeInsert; */
                HideCreditCheckDialogue := true;
            end;
            NoSeriesMgt.GetNextNo("No.");
            if SalesHeader2.Get("Document Type", "No.") then
                Error(Text051, LowerCase(Format("Document Type")), "No.");
            exit(true);
        end;
    end;

    local procedure TestNoSeries(): Boolean
    begin
        SalesSetup.Get;

        case "Document Type" of
            "Document Type"::Quote:
                SalesSetup.TestField("Quote Nos.");
            "Document Type"::Order:
                begin
                    SalesSetup.TestField("Order Nos.");
                    if "Pre pedido" then //DSLoc1.01 Localizacion Guatemala
                        SalesSetup.TestField("Pre Order Nos.");
                end;
            "Document Type"::Invoice:
                begin
                    SalesSetup.TestField("Invoice Nos.");
                    SalesSetup.TestField("Posted Invoice Nos.");
                end;
            "Document Type"::"Return Order":
                SalesSetup.TestField("Return Order Nos.");
            "Document Type"::"Credit Memo":
                begin
                    SalesSetup.TestField("Credit Memo Nos.");
                    SalesSetup.TestField("Posted Credit Memo Nos.");
                end;
            "Document Type"::"Blanket Order":
                SalesSetup.TestField("Blanket Order Nos.");
        end;
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        case "Document Type" of
            "Document Type"::Quote:
                exit(SalesSetup."Quote Nos.");
            "Document Type"::Order:
                begin
                    if "Pre pedido" then
                        exit(SalesSetup."Pre Order Nos.")//DSLoc1.01 Localizacion Guatemala
                    else
                        exit(SalesSetup."Order Nos.");
                end;
            "Document Type"::Invoice:
                exit(SalesSetup."Invoice Nos.");
            "Document Type"::"Return Order":
                exit(SalesSetup."Return Order Nos.");
            "Document Type"::"Credit Memo":
                exit(SalesSetup."Credit Memo Nos.");
            "Document Type"::"Blanket Order":
                exit(SalesSetup."Blanket Order Nos.");
        end;
    end;

    local procedure GetPostingNoSeriesCode(): Code[10]
    begin
        if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then
            exit(SalesSetup."Posted Credit Memo Nos.");
        exit(SalesSetup."Posted Invoice Nos.");
    end;

    local procedure GetPostingPrepaymentNoSeriesCode(): Code[10]
    begin
        if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then
            exit(SalesSetup."Posted Prepmt. Cr. Memo Nos.");
        exit(SalesSetup."Posted Prepmt. Inv. Nos.");
    end;

    local procedure TestNoSeriesDate(No: Code[20]; NoSeriesCode: Code[10]; NoCapt: Text[1024]; NoSeriesCapt: Text[1024])
    var
        NoSeries: Record "No. Series";
    begin
        if (No <> '') and (NoSeriesCode <> '') then begin
            NoSeries.Get(NoSeriesCode);
            if NoSeries."Date Order" then
                Error(
                  Text045,
                  FieldCaption("Posting Date"), NoSeriesCapt, NoSeriesCode,
                  NoSeries.FieldCaption("Date Order"), NoSeries."Date Order", "Document Type",
                  NoCapt, No);
        end;
    end;


    procedure ConfirmDeletion(): Boolean
    begin
        //fes mig
        /*
        SalesPost.TestDeleteHeader(
          Rec,SalesShptHeader,SalesInvHeader,SalesCrMemoHeader,ReturnRcptHeader,
          SalesInvHeaderPrepmt,SalesCrMemoHeaderPrepmt);
        IF SalesShptHeader."No." <> '' THEN
          IF NOT CONFIRM(
               Text009,TRUE,
               SalesShptHeader."No.")
          THEN
            EXIT;
        IF SalesInvHeader."No." <> '' THEN
          IF NOT CONFIRM(
               Text012,TRUE,
               SalesInvHeader."No.")
          THEN
            EXIT;
        IF SalesCrMemoHeader."No." <> '' THEN
          IF NOT CONFIRM(
               Text014,TRUE,
               SalesCrMemoHeader."No.")
          THEN
            EXIT;
        IF ReturnRcptHeader."No." <> '' THEN
          IF NOT CONFIRM(
               Text030,TRUE,
               ReturnRcptHeader."No.")
          THEN
            EXIT;
        IF "Prepayment No." <> '' THEN
          IF NOT CONFIRM(
               Text056,TRUE,
               SalesInvHeaderPrepmt."No.")
          THEN
            EXIT;
        IF "Prepmt. Cr. Memo No." <> '' THEN
          IF NOT CONFIRM(
               Text057,TRUE,
               SalesCrMemoHeaderPrepmt."No.")
          THEN
            EXIT;
        EXIT(TRUE);
        */
        //fes mig

    end;

    local procedure GetCust(CustNo: Code[20])
    begin
        if not (("Document Type" = "Document Type"::Quote) and (CustNo = '')) then begin
            if CustNo <> Cust."No." then
                Cust.Get(CustNo);
        end else
            Clear(Cust);
    end;


    procedure SalesLinesExist(): Boolean
    begin
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        exit(SalesLine.FindFirst);
    end;


    procedure RecreateSalesLines(ChangedFieldName: Text[100])
    var
        SalesLineTmp: Record "Sales Line" temporary;
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)" temporary;
        TempInteger: Record "Integer" temporary;
        TempATOLink: Record "Assemble-to-Order Link" temporary;
        ATOLink: Record "Assemble-to-Order Link";
        ExtendedTextAdded: Boolean;
    begin
        if SalesLinesExist then begin
            if HideValidationDialog or not GuiAllowed then
                Confirmed := true
            else
                Confirmed :=
                  Confirm(
                    Text015, false, ChangedFieldName);
            if Confirmed then begin
                SalesLine.LockTable;
                ItemChargeAssgntSales.LockTable;
                ReservEntry.LockTable;
                Modify;

                SalesLine.Reset;
                SalesLine.SetRange("Document Type", "Document Type");
                SalesLine.SetRange("Document No.", "No.");
                if SalesLine.FindSet then begin
                    TempReservEntry.DeleteAll;
                    repeat
                        SalesLine.TestField("Job No.", '');
                        SalesLine.TestField("Job Contract Entry No.", 0);
                        SalesLine.TestField("Quantity Shipped", 0);
                        SalesLine.TestField("Quantity Invoiced", 0);
                        SalesLine.TestField("Return Qty. Received", 0);
                        SalesLine.TestField("Shipment No.", '');
                        SalesLine.TestField("Return Receipt No.", '');
                        SalesLine.TestField("Blanket Order No.", '');
                        SalesLine.TestField("Prepmt. Amt. Inv.", 0);
                        //fes mig IF (SalesLine."Location Code" <> "Location Code") AND NOT SalesLine.IsServiceItem THEN
                        //fes mig SalesLine.VALIDATE("Location Code","Location Code");
                        SalesLineTmp := SalesLine;
                        if SalesLine.Nonstock then begin
                            SalesLine.Nonstock := false;
                            SalesLine.Modify;
                        end;

                        if ATOLink.AsmExistsForSalesLine(SalesLineTmp) then begin
                            TempATOLink := ATOLink;
                            TempATOLink.Insert;
                            ATOLink.Delete;
                        end;

                        SalesLineTmp.Insert;
                    /*         RecreateReservEntry(SalesLine, 0, true);
                            RecreateReqLine(SalesLine, 0, true); */
                    until SalesLine.Next = 0;

                    ItemChargeAssgntSales.SetRange("Document Type", "Document Type");
                    ItemChargeAssgntSales.SetRange("Document No.", "No.");
                    if ItemChargeAssgntSales.FindSet then begin
                        repeat
                            TempItemChargeAssgntSales.Init;
                            TempItemChargeAssgntSales := ItemChargeAssgntSales;
                            TempItemChargeAssgntSales.Insert;
                        until ItemChargeAssgntSales.Next = 0;
                        ItemChargeAssgntSales.DeleteAll;
                    end;

                    SalesLine.DeleteAll(true);
                    SalesLine.Init;
                    SalesLine."Line No." := 0;
                    SalesLineTmp.FindSet;
                    ExtendedTextAdded := false;
                    SalesLine.BlockDynamicTracking(true);
                    repeat
                        if SalesLineTmp."Attached to Line No." = 0 then begin
                            SalesLine.Init;
                            SalesLine."Line No." := SalesLine."Line No." + 10000;
                            SalesLine.Validate(Type, SalesLineTmp.Type);
                            if SalesLineTmp."No." = '' then begin
                                SalesLine.Validate(Description, SalesLineTmp.Description);
                                SalesLine.Validate("Description 2", SalesLineTmp."Description 2");
                            end else begin
                                SalesLine.Validate("No.", SalesLineTmp."No.");
                                if SalesLine.Type <> SalesLine.Type::" " then begin
                                    SalesLine.Validate("Unit of Measure Code", SalesLineTmp."Unit of Measure Code");
                                    SalesLine.Validate("Variant Code", SalesLineTmp."Variant Code");
                                    if SalesLineTmp.Quantity <> 0 then begin
                                        SalesLine.Validate(Quantity, SalesLineTmp.Quantity);
                                        SalesLine.Validate("Qty. to Assemble to Order", SalesLineTmp."Qty. to Assemble to Order");
                                    end;
                                    SalesLine."Purchase Order No." := SalesLineTmp."Purchase Order No.";
                                    SalesLine."Purch. Order Line No." := SalesLineTmp."Purch. Order Line No.";
                                    SalesLine."Drop Shipment" := SalesLine."Purch. Order Line No." <> 0;
                                    //017
                                    SalesLine."Cantidad Solicitada" := SalesLineTmp."Cantidad Solicitada";
                                    SalesLine."Cantidad Aprobada" := SalesLineTmp."Cantidad Aprobada";
                                    SalesLine."Cantidad pendiente BO" := SalesLineTmp."Cantidad pendiente BO";
                                    SalesLine."Cantidad a Anular" := SalesLineTmp."Cantidad a Anular";
                                    SalesLine."Cantidad a Ajustar" := SalesLine."Cantidad a Ajustar";
                                    SalesLine."Porcentaje Cant. Aprobada" := SalesLine."Porcentaje Cant. Aprobada";
                                    //017
                                end;
                            end;

                            SalesLine.Insert;
                            ExtendedTextAdded := false;

                            if SalesLine.Type = SalesLine.Type::Item then begin
                                /*   ClearItemAssgntSalesFilter(TempItemChargeAssgntSales); */
                                TempItemChargeAssgntSales.SetRange("Applies-to Doc. Type", SalesLineTmp."Document Type");
                                TempItemChargeAssgntSales.SetRange("Applies-to Doc. No.", SalesLineTmp."Document No.");
                                TempItemChargeAssgntSales.SetRange("Applies-to Doc. Line No.", SalesLineTmp."Line No.");
                                if TempItemChargeAssgntSales.FindSet then
                                    repeat
                                        if not TempItemChargeAssgntSales.Mark then begin
                                            TempItemChargeAssgntSales."Applies-to Doc. Line No." := SalesLine."Line No.";
                                            TempItemChargeAssgntSales.Description := SalesLine.Description;
                                            TempItemChargeAssgntSales.Modify;
                                            TempItemChargeAssgntSales.Mark(true);
                                        end;
                                    until TempItemChargeAssgntSales.Next = 0;
                            end;
                            if SalesLine.Type = SalesLine.Type::"Charge (Item)" then begin
                                TempInteger.Init;
                                TempInteger.Number := SalesLine."Line No.";
                                TempInteger.Insert;
                            end;
                        end else
                            if not ExtendedTextAdded then begin
                                TransferExtendedText.SalesCheckIfAnyExtText(SalesLine, true);
                                TransferExtendedText.InsertSalesExtText(SalesLine);
                                SalesLine.FindLast;
                                ExtendedTextAdded := true;
                            end;
                        /*   RecreateReservEntry(SalesLineTmp, SalesLine."Line No.", false);
                          RecreateReqLine(SalesLineTmp, SalesLine."Line No.", false);
                          SynchronizeForReservations(SalesLine, SalesLineTmp); */

                        if TempATOLink.AsmExistsForSalesLine(SalesLineTmp) then begin
                            ATOLink := TempATOLink;
                            ATOLink.Insert;
                            SalesLine.AutoAsmToOrder;
                            TempATOLink.Delete;
                        end;
                    until SalesLineTmp.Next = 0;

                    /*   ClearItemAssgntSalesFilter(TempItemChargeAssgntSales); */
                    SalesLineTmp.SetRange(Type, SalesLine.Type::"Charge (Item)");
                    if SalesLineTmp.FindSet then
                        repeat
                            TempItemChargeAssgntSales.SetRange("Document Line No.", SalesLineTmp."Line No.");
                            if TempItemChargeAssgntSales.FindSet then begin
                                repeat
                                    TempInteger.FindFirst;
                                    ItemChargeAssgntSales.Init;
                                    ItemChargeAssgntSales := TempItemChargeAssgntSales;
                                    ItemChargeAssgntSales."Document Line No." := TempInteger.Number;
                                    ItemChargeAssgntSales.Validate("Unit Cost", 0);
                                    ItemChargeAssgntSales.Insert;
                                until TempItemChargeAssgntSales.Next = 0;
                                TempInteger.Delete;
                            end;
                        until SalesLineTmp.Next = 0;

                    SalesLineTmp.SetRange(Type);
                    SalesLineTmp.DeleteAll;
                    /*     ClearItemAssgntSalesFilter(TempItemChargeAssgntSales); */
                    TempItemChargeAssgntSales.DeleteAll;
                end;
            end else
                Error(
                  Text017, ChangedFieldName);
        end;
        SalesLine.BlockDynamicTracking(false);
    end;


    procedure MessageIfSalesLinesExist(ChangedFieldName: Text[100])
    begin
        if SalesLinesExist and not HideValidationDialog then
            Message(
              Text018 +
              Text019,
              ChangedFieldName);
    end;


    procedure PriceMessageIfSalesLinesExist(ChangedFieldName: Text[100])
    begin
        if SalesLinesExist and not HideValidationDialog then
            Message(
              Text018 +
              Text020, ChangedFieldName);
    end;

    local procedure UpdateCurrencyFactor()
    begin
        if "Currency Code" <> '' then begin
            if "Posting Date" <> 0D then
                CurrencyDate := "Posting Date"
            else
                CurrencyDate := WorkDate;

            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        end else
            "Currency Factor" := 0;
    end;

    local procedure ConfirmUpdateCurrencyFactor()
    begin
        if HideValidationDialog then
            Confirmed := true
        else
            Confirmed := Confirm(Text021, false);
        if Confirmed then
            Validate("Currency Factor")
        else
            "Currency Factor" := xRec."Currency Factor";
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;


    procedure UpdateSalesLines(ChangedFieldName: Text[100]; AskQuestion: Boolean)
    var
        JobTransferLine: Codeunit "Job Transfer Line";
        Question: Text[250];
    begin
        if not SalesLinesExist then
            exit;

        if AskQuestion then begin
            Question := StrSubstNo(
                Text031 +
                Text032, ChangedFieldName);
            if GuiAllowed then
                if DIALOG.Confirm(Question, true) then
                    case ChangedFieldName of
                        FieldCaption("Shipment Date"),
                      FieldCaption("Shipping Agent Code"),
                      FieldCaption("Shipping Agent Service Code"),
                      FieldCaption("Shipping Time"),
                      FieldCaption("Requested Delivery Date"),
                      FieldCaption("Promised Delivery Date"),
                      FieldCaption("Outbound Whse. Handling Time"):
                            ConfirmResvDateConflict;
                    end
                else
                    exit;
        end;

        SalesLine.LockTable;
        Modify;

        SalesLine.Reset;
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        if SalesLine.FindSet then
            repeat
                case ChangedFieldName of
                    FieldCaption("Shipment Date"):
                        if SalesLine."No." <> '' then
                            SalesLine.Validate("Shipment Date", "Shipment Date");
                    FieldCaption("Currency Factor"):
                        if SalesLine.Type <> SalesLine.Type::" " then begin
                            SalesLine.Validate("Unit Price");
                            SalesLine.Validate("Unit Cost (LCY)");
                            if SalesLine."Job No." <> '' then
                                JobTransferLine.FromSalesHeaderToPlanningLine(SalesLine, "Currency Factor");
                        end;
                    FieldCaption("Transaction Type"):
                        SalesLine.Validate("Transaction Type", "Transaction Type");
                    FieldCaption("Transport Method"):
                        SalesLine.Validate("Transport Method", "Transport Method");
                    FieldCaption("Exit Point"):
                        SalesLine.Validate("Exit Point", "Exit Point");
                    FieldCaption(Area):
                        SalesLine.Validate(Area, Area);
                    FieldCaption("Transaction Specification"):
                        SalesLine.Validate("Transaction Specification", "Transaction Specification");
                    FieldCaption("Shipping Agent Code"):
                        SalesLine.Validate("Shipping Agent Code", "Shipping Agent Code");
                    FieldCaption("Shipping Agent Service Code"):
                        if SalesLine."No." <> '' then
                            SalesLine.Validate("Shipping Agent Service Code", "Shipping Agent Service Code");
                    FieldCaption("Shipping Time"):
                        if SalesLine."No." <> '' then
                            SalesLine.Validate("Shipping Time", "Shipping Time");
                    FieldCaption("Prepayment %"):
                        if SalesLine."No." <> '' then
                            SalesLine.Validate("Prepayment %", "Prepayment %");
                    FieldCaption("Requested Delivery Date"):
                        if SalesLine."No." <> '' then
                            SalesLine.Validate("Requested Delivery Date", "Requested Delivery Date");
                    FieldCaption("Promised Delivery Date"):
                        if SalesLine."No." <> '' then
                            SalesLine.Validate("Promised Delivery Date", "Promised Delivery Date");
                    FieldCaption("Outbound Whse. Handling Time"):
                        if SalesLine."No." <> '' then
                            SalesLine.Validate("Outbound Whse. Handling Time", "Outbound Whse. Handling Time");
                    FieldCaption("Tax Liable"):
                        if SalesLine."No." <> '' then
                            SalesLine.Validate("Tax Liable", "Tax Liable");
                end;
                SalesLineReserve.AssignForPlanning(SalesLine);
                SalesLine.Modify(true);
            until SalesLine.Next = 0;
    end;


    procedure ConfirmResvDateConflict()
    var
        ResvEngMgt: Codeunit "Reservation Engine Mgt.";
    begin
        //fes mig
        /*
        IF ResvEngMgt.ResvExistsForSalesHeader(Rec) THEN
          IF NOT CONFIRM(Text063,FALSE) THEN
            ERROR('');
        */
        //fes mig

    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20]; Type4: Integer; No4: Code[20]; Type5: Integer; No5: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.Get;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        TableID[4] := Type4;
        No[4] := No4;
        TableID[5] := Type5;
        No[5] := No5;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";

    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var
                                                                ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            Modify;

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if SalesLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;


    procedure ShippedSalesLinesExist(): Boolean
    begin
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        SalesLine.SetFilter("Quantity Shipped", '<>0');
        exit(SalesLine.FindFirst);
    end;


    procedure ReturnReceiptExist(): Boolean
    begin
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        SalesLine.SetFilter("Return Qty. Received", '<>0');
        exit(SalesLine.FindFirst);
    end;

    local procedure DeleteSalesLines()
    begin
        if SalesLine.FindSet then begin
            HandleItemTrackingDeletion;
            repeat
                SalesLine.SuspendStatusCheck(true);
                SalesLine.Delete(true);
            until SalesLine.Next = 0;
        end;
    end;


    procedure HandleItemTrackingDeletion()
    var
        ReservEntry2: Record "Reservation Entry";
    begin
        ReservEntry.Reset;
        ReservEntry.SetCurrentKey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line", "Reservation Status");
        ReservEntry.SetRange("Source Type", DATABASE::"Sales Line");
        ReservEntry.SetRange("Source Subtype", "Document Type");
        ReservEntry.SetRange("Source ID", "No.");
        ReservEntry.SetRange("Source Batch Name", '');
        ReservEntry.SetRange("Source Prod. Order Line", 0);
        ReservEntry.SetFilter("Item Tracking", '> %1', ReservEntry."Item Tracking"::None);
        if ReservEntry.IsEmpty then
            exit;

        if HideValidationDialog or not GuiAllowed then
            Confirmed := true
        else
            Confirmed := Confirm(Text052, false, LowerCase(Format("Document Type")), "No.");

        if not Confirmed then
            Error('');

        if FindSet then
            repeat
                ReservEntry2 := ReservEntry;
                ReservEntry2.ClearItemTrackingFields;
                ReservEntry2.Modify;
            until Next = 0;
    end;

    local procedure ClearItemAssgntSalesFilter(var TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)")
    begin
        TempItemChargeAssgntSales.SetRange("Document Line No.");
        TempItemChargeAssgntSales.SetRange("Applies-to Doc. Type");
        TempItemChargeAssgntSales.SetRange("Applies-to Doc. No.");
        TempItemChargeAssgntSales.SetRange("Applies-to Doc. Line No.");
    end;


    procedure CheckCustomerCreated(Prompt: Boolean): Boolean
    var
        Cont: Record Contact;
    begin
        if ("Bill-to Customer No." <> '') and ("Sell-to Customer No." <> '') then
            exit(true);

        if Prompt then
            if not Confirm(Text035, true) then
                exit(false);

        if "Sell-to Customer No." = '' then begin
            TestField("Sell-to Contact No.");
            TestField("Sell-to Customer Template Code");
            Cont.Get("Sell-to Contact No.");
            Cont.CreateCustomer();
            Commit;
            Get("Document Type"::Quote, "No.");
        end;

        if "Bill-to Customer No." = '' then begin
            TestField("Bill-to Contact No.");
            TestField("Bill-to Customer Template Code");
            Cont.Get("Bill-to Contact No.");
            Cont.CreateCustomer();
            Commit;
            Get("Document Type"::Quote, "No.");
        end;

        exit(("Bill-to Customer No." <> '') and ("Sell-to Customer No." <> ''));
    end;


    procedure RecreateReservEntry(OldSalesLine: Record "Sales Line"; NewSourceRefNo: Integer; ToTemp: Boolean)
    begin
        if ToTemp then begin
            Clear(ReservEntry);
            ReservEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
            ReservEntry.SetRange("Source ID", OldSalesLine."Document No.");
            ReservEntry.SetRange("Source Ref. No.", OldSalesLine."Line No.");
            ReservEntry.SetRange("Source Type", DATABASE::"Sales Line");
            ReservEntry.SetRange("Source Subtype", OldSalesLine."Document Type");
            if ReservEntry.FindSet then
                repeat
                    TempReservEntry := ReservEntry;
                    TempReservEntry.Insert;
                until ReservEntry.Next = 0;
            ReservEntry.DeleteAll;
        end else begin
            Clear(TempReservEntry);
            TempReservEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
            TempReservEntry.SetRange("Source Type", DATABASE::"Sales Line");
            TempReservEntry.SetRange("Source Subtype", OldSalesLine."Document Type");
            TempReservEntry.SetRange("Source ID", OldSalesLine."Document No.");
            TempReservEntry.SetRange("Source Ref. No.", OldSalesLine."Line No.");
            if TempReservEntry.FindSet then
                repeat
                    ReservEntry := TempReservEntry;
                    ReservEntry."Source Ref. No." := NewSourceRefNo;
                    ReservEntry.Insert;
                until TempReservEntry.Next = 0;
            TempReservEntry.DeleteAll;
        end;
    end;


    procedure RecreateReqLine(OldSalesLine: Record "Sales Line"; NewSourceRefNo: Integer; ToTemp: Boolean)
    var
        ReqLine: Record "Requisition Line";
    begin
        if ToTemp then begin
            ReqLine.SetCurrentKey("Order Promising ID", "Order Promising Line ID", "Order Promising Line No.");
            ReqLine.SetRange("Order Promising ID", OldSalesLine."Document No.");
            ReqLine.SetRange("Order Promising Line ID", OldSalesLine."Line No.");
            if ReqLine.FindSet then
                repeat
                    TempReqLine := ReqLine;
                    TempReqLine.Insert;
                until ReqLine.Next = 0;
            ReqLine.DeleteAll;
        end else begin
            Clear(TempReqLine);
            TempReqLine.SetCurrentKey("Order Promising ID", "Order Promising Line ID", "Order Promising Line No.");
            TempReqLine.SetRange("Order Promising ID", OldSalesLine."Document No.");
            TempReqLine.SetRange("Order Promising Line ID", OldSalesLine."Line No.");
            if TempReqLine.FindSet then
                repeat
                    ReqLine := TempReqLine;
                    ReqLine."Order Promising Line ID" := NewSourceRefNo;
                    ReqLine.Insert;
                until TempReqLine.Next = 0;
            TempReqLine.DeleteAll;
        end;
    end;


    procedure UpdateSellToCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "Contact Business Relation";
        Cust: Record Customer;
    begin
        if Cust.Get(CustomerNo) then begin
            if Cust."Primary Contact No." <> '' then
                "Sell-to Contact No." := Cust."Primary Contact No."
            else begin
                ContBusRel.Reset;
                ContBusRel.SetCurrentKey("Link to Table", "No.");
                ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
                ContBusRel.SetRange("No.", "Sell-to Customer No.");
                if ContBusRel.FindFirst then
                    "Sell-to Contact No." := ContBusRel."Contact No."
                else
                    "Sell-to Contact No." := '';
            end;
            "Sell-to Contact" := Cust.Contact;
        end;
    end;


    procedure UpdateBillToCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "Contact Business Relation";
        Cust: Record Customer;
    begin
        if Cust.Get(CustomerNo) then begin
            if Cust."Primary Contact No." <> '' then
                "Bill-to Contact No." := Cust."Primary Contact No."
            else begin
                ContBusRel.Reset;
                ContBusRel.SetCurrentKey("Link to Table", "No.");
                ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
                ContBusRel.SetRange("No.", "Bill-to Customer No.");
                if ContBusRel.FindFirst then
                    "Bill-to Contact No." := ContBusRel."Contact No."
                else
                    "Bill-to Contact No." := '';
            end;
            "Bill-to Contact" := Cust.Contact;
        end;
    end;


    procedure UpdateSellToCust(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Customer: Record Customer;
        Cont: Record Contact;
        /* CustTemplate: Record "Customer Template"; */
        ContComp: Record Contact;
    begin
        if Cont.Get(ContactNo) then
            "Sell-to Contact No." := Cont."No."
        else begin
            "Sell-to Contact" := '';
            exit;
        end;

        ContBusinessRelation.Reset;
        ContBusinessRelation.SetCurrentKey("Link to Table", "Contact No.");
        ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."Link to Table"::Customer);
        ContBusinessRelation.SetRange("Contact No.", Cont."Company No.");
        if ContBusinessRelation.FindFirst then begin
            if ("Sell-to Customer No." <> '') and
               ("Sell-to Customer No." <> ContBusinessRelation."No.")
            then
                Error(Text037, Cont."No.", Cont.Name, "Sell-to Customer No.");
            if "Sell-to Customer No." = '' then begin
                SkipSellToContact := true;
                Validate("Sell-to Customer No.", ContBusinessRelation."No.");
                SkipSellToContact := false;
            end;
        end else begin
            if "Document Type" = "Document Type"::Quote then begin
                Cont.TestField("Company No.");
                ContComp.Get(Cont."Company No.");
                "Sell-to Customer Name" := ContComp."Company Name";
                "Sell-to Customer Name 2" := ContComp."Name 2";
                "Ship-to Name" := ContComp."Company Name";
                "Ship-to Name 2" := ContComp."Name 2";
                "Ship-to Address" := CopyStr(ContComp.Address, 1, 50);
                "Ship-to Address 2" := ContComp."Address 2";
                "Ship-to City" := ContComp.City;
                "Ship-to Post Code" := ContComp."Post Code";
                "Ship-to County" := ContComp.County;
                Validate("Ship-to Country/Region Code", ContComp."Country/Region Code");
                /*      if ("Sell-to Customer Template Code" = '') and (not CustTemplate.IsEmpty) then
                         Validate("Sell-to Customer Template Code", Cont.FindNewCustomerTemplate); */
            end else
                Error(Text039, Cont."No.", Cont.Name);
        end;

        if Cont.Type = Cont.Type::Person then
            "Sell-to Contact" := Cont.Name
        else
            if Customer.Get("Sell-to Customer No.") then
                "Sell-to Contact" := Customer.Contact
            else
                "Sell-to Contact" := '';

        if "Document Type" = "Document Type"::Quote then begin
            if Customer.Get("Sell-to Customer No.") or Customer.Get(ContBusinessRelation."No.") then begin
                if Customer."Copy Sell-to Addr. to Qte From" = Customer."Copy Sell-to Addr. to Qte From"::Company then begin
                    Cont.TestField("Company No.");
                    Cont.Get(Cont."Company No.");
                end;
            end else begin
                Cont.TestField("Company No.");
                Cont.Get(Cont."Company No.");
            end;
            "Sell-to Address" := CopyStr(Cont.Address, 1, 50);
            "Sell-to Address 2" := Cont."Address 2";
            "Sell-to City" := Cont.City;
            "Sell-to Post Code" := Cont."Post Code";
            "Sell-to County" := Cont.County;
            "Sell-to Country/Region Code" := Cont."Country/Region Code";
        end;
        if ("Sell-to Customer No." = "Bill-to Customer No.") or
           ("Bill-to Customer No." = '')
        then
            Validate("Bill-to Contact No.", "Sell-to Contact No.");
    end;


    procedure UpdateBillToCust(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Cust: Record Customer;
        Cont: Record Contact;
        /*         CustTemplate: Record "Customer Template"; */
        ContComp: Record Contact;
    begin
        if Cont.Get(ContactNo) then begin
            "Bill-to Contact No." := Cont."No.";
            if Cont.Type = Cont.Type::Person then
                "Bill-to Contact" := Cont.Name
            else
                if Cust.Get("Bill-to Customer No.") then
                    "Bill-to Contact" := Cust.Contact
                else
                    "Bill-to Contact" := '';
        end else begin
            "Bill-to Contact" := '';
            exit;
        end;

        ContBusinessRelation.Reset;
        ContBusinessRelation.SetCurrentKey("Link to Table", "Contact No.");
        ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."Link to Table"::Customer);
        ContBusinessRelation.SetRange("Contact No.", Cont."Company No.");
        if ContBusinessRelation.FindFirst then begin
            if "Bill-to Customer No." = '' then begin
                SkipBillToContact := true;
                Validate("Bill-to Customer No.", ContBusinessRelation."No.");
                SkipBillToContact := false;
                "Bill-to Customer Template Code" := '';
            end else
                if "Bill-to Customer No." <> ContBusinessRelation."No." then
                    Error(Text037, Cont."No.", Cont.Name, "Bill-to Customer No.");
        end else begin
            if "Document Type" = "Document Type"::Quote then begin
                Cont.TestField("Company No.");
                ContComp.Get(Cont."Company No.");
                "Bill-to Name" := ContComp."Company Name";
                "Bill-to Name 2" := ContComp."Name 2";
                "Bill-to Address" := CopyStr(ContComp.Address, 1, 50);
                "Bill-to Address 2" := ContComp."Address 2";
                "Bill-to City" := ContComp.City;
                "Bill-to Post Code" := ContComp."Post Code";
                "Bill-to County" := ContComp.County;
                "Bill-to Country/Region Code" := ContComp."Country/Region Code";
                "VAT Registration No." := ContComp."VAT Registration No.";
                Validate("Currency Code", ContComp."Currency Code");
                "Language Code" := ContComp."Language Code";
                /*      if ("Bill-to Customer Template Code" = '') and (not CustTemplate.IsEmpty) then
                         Validate("Bill-to Customer Template Code", Cont.FindNewCustomerTemplate); */
            end else
                Error(Text039, Cont."No.", Cont.Name);
        end;
    end;


    procedure GetShippingTime(CalledByFieldNo: Integer)
    begin
        if (CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0) then
            exit;

        if ShippingAgentService.Get("Shipping Agent Code", "Shipping Agent Service Code") then
            "Shipping Time" := ShippingAgentService."Shipping Time"
        else begin
            GetCust("Sell-to Customer No.");
            "Shipping Time" := Cust."Shipping Time"
        end;
        if not (CalledByFieldNo in [FieldNo("Shipping Agent Code"), FieldNo("Shipping Agent Service Code")]) then
            Validate("Shipping Time");
    end;


    procedure CheckCreditMaxBeforeInsert()
    var
        SalesHeader: Record "Sales Header";
        ContBusinessRelation: Record "Contact Business Relation";
        Cont: Record Contact;
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
    begin
        if HideCreditCheckDialogue then
            exit;
        if GetFilter("Sell-to Customer No.") <> '' then begin
            if GetRangeMin("Sell-to Customer No.") = GetRangeMax("Sell-to Customer No.") then begin
                Cust.Get(GetRangeMin("Sell-to Customer No."));
                if Cust."Bill-to Customer No." <> '' then
                    SalesHeader."Bill-to Customer No." := Cust."Bill-to Customer No."
                else
                    SalesHeader."Bill-to Customer No." := Cust."No.";
                CustCheckCreditLimit.SalesHeaderCheck(SalesHeader);
            end
        end else
            if GetFilter("Sell-to Contact No.") <> '' then
                if GetRangeMin("Sell-to Contact No.") = GetRangeMax("Sell-to Contact No.") then begin
                    Cont.Get(GetRangeMin("Sell-to Contact No."));
                    ContBusinessRelation.Reset;
                    ContBusinessRelation.SetCurrentKey("Link to Table", "No.");
                    ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                    ContBusinessRelation.SetRange("Contact No.", Cont."Company No.");
                    if ContBusinessRelation.FindFirst then begin
                        Cust.Get(ContBusinessRelation."No.");
                        if Cust."Bill-to Customer No." <> '' then
                            SalesHeader."Bill-to Customer No." := Cust."Bill-to Customer No."
                        else
                            SalesHeader."Bill-to Customer No." := Cust."No.";
                        CustCheckCreditLimit.SalesHeaderCheck(SalesHeader);
                    end;
                end;
    end;


    procedure CreateInvtPutAwayPick()
    var
        WhseRequest: Record "Warehouse Request";
    begin
        TestField(Status, Status::Released);

        WhseRequest.Reset;
        WhseRequest.SetCurrentKey("Source Document", "Source No.");
        case "Document Type" of
            "Document Type"::Order:
                begin
                    if "Shipping Advice" = "Shipping Advice"::Complete then
                        CheckShippingAdvice;
                    WhseRequest.SetRange("Source Document", WhseRequest."Source Document"::"Sales Order");
                end;
            "Document Type"::"Return Order":
                WhseRequest.SetRange("Source Document", WhseRequest."Source Document"::"Sales Return Order");
        end;
        WhseRequest.SetRange("Source No.", "No.");
        REPORT.RunModal(REPORT::"Create Invt Put-away/Pick/Mvmt", true, false, WhseRequest);
    end;


    procedure CreateTodo()
    var
        TempTodo: Record "To-do" temporary;
    begin
        //fes mig
        /*
        TESTFIELD("Sell-to Contact No.");
        TempTodo.CreateToDoFromSalesHeader(Rec);
        */
        //fes mig

    end;

    local procedure UpdateShipToAddress()
    begin
        if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then begin
            if "Location Code" <> '' then begin
                Location.Get("Location Code");
                "Ship-to Name" := Location.Name;
                "Ship-to Name 2" := Location."Name 2";
                "Ship-to Address" := CopyStr(Location.Address, 1, 50);//AMS
                "Ship-to Address 2" := Location."Address 2";
                "Ship-to City" := Location.City;
                "Ship-to Post Code" := Location."Post Code";
                "Ship-to County" := Location.County;
                "Ship-to Country/Region Code" := Location."Country/Region Code";
                "Ship-to Contact" := Location.Contact;
            end else begin
                CompanyInfo.Get;
                "Ship-to Code" := '';
                "Ship-to Name" := CompanyInfo."Ship-to Name";
                "Ship-to Name 2" := CompanyInfo."Ship-to Name 2";
                "Ship-to Address" := CompanyInfo."Ship-to Address";
                "Ship-to Address 2" := CompanyInfo."Ship-to Address 2";
                "Ship-to City" := CompanyInfo."Ship-to City";
                "Ship-to Post Code" := CompanyInfo."Ship-to Post Code";
                "Ship-to County" := CompanyInfo."Ship-to County";
                "Ship-to Country/Region Code" := CompanyInfo."Ship-to Country/Region Code";
                "Ship-to Contact" := CompanyInfo."Ship-to Contact";
            end;
        end;
    end;


    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", StrSubstNo('%1 %2', "Document Type", "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if SalesLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        ATOLink: Record "Assemble-to-Order Link";
        NewDimSetID: Integer;
        SalesLineOldDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not HideValidationDialog or not GuiAllowed then
            if not Confirm(Text064) then
                exit;

        SalesLine.Reset;
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        SalesLine.LockTable;
        if SalesLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(SalesLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if SalesLine."Dimension Set ID" <> NewDimSetID then begin
                    SalesLineOldDimSetID := SalesLine."Dimension Set ID";
                    SalesLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      SalesLine."Dimension Set ID", SalesLine."Shortcut Dimension 1 Code", SalesLine."Shortcut Dimension 2 Code");
                    SalesLine.Modify;
                    ATOLink.UpdateAsmDimFromSalesLine(SalesLine);
                end;
            until SalesLine.Next = 0;
    end;


    procedure SetAmountToApply(AppliesToDocNo: Code[20]; CustomerNo: Code[20])
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.SetCurrentKey("Document No.");
        CustLedgEntry.SetRange("Document No.", AppliesToDocNo);
        CustLedgEntry.SetRange("Customer No.", CustomerNo);
        CustLedgEntry.SetRange(Open, true);
        if CustLedgEntry.FindFirst then begin
            if CustLedgEntry."Amount to Apply" = 0 then begin
                CustLedgEntry.CalcFields("Remaining Amount");
                CustLedgEntry."Amount to Apply" := CustLedgEntry."Remaining Amount";
            end else
                CustLedgEntry."Amount to Apply" := 0;
            CustLedgEntry."Accepted Payment Tolerance" := 0;
            CustLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
            CODEUNIT.Run(CODEUNIT::"Cust. Entry-Edit", CustLedgEntry);
        end;
    end;


    procedure LookupAdjmtValueEntries(QtyType: Option General,Invoicing)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        SalesLine: Record "Sales Line";
        SalesShptLine: Record "Sales Shipment Line";
        ReturnRcptLine: Record "Return Receipt Line";
        TempValueEntry: Record "Value Entry" temporary;
    begin
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        TempValueEntry.Reset;
        TempValueEntry.DeleteAll;

        case "Document Type" of
            "Document Type"::Order, "Document Type"::Invoice:
                begin
                    if SalesLine.FindSet then
                        repeat
                            if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine.Quantity <> 0) then
                                if SalesLine."Shipment No." <> '' then begin
                                    SalesShptLine.SetRange("Document No.", SalesLine."Shipment No.");
                                    SalesShptLine.SetRange("Line No.", SalesLine."Shipment Line No.");
                                end else begin
                                    SalesShptLine.SetCurrentKey("Order No.", "Order Line No.");
                                    SalesShptLine.SetRange("Order No.", SalesLine."Document No.");
                                    SalesShptLine.SetRange("Order Line No.", SalesLine."Line No.");
                                end;
                            SetRange(Correction, false);
                            if QtyType = QtyType::Invoicing then
                                SalesShptLine.SetFilter("Qty. Shipped Not Invoiced", '<>0');

                            if FindSet then
                                repeat
                                    SalesShptLine.FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
                                    if ItemLedgEntry.FindSet then
                                        repeat
                                            CreateTempAdjmtValueEntries(TempValueEntry, ItemLedgEntry."Entry No.");
                                        until ItemLedgEntry.Next = 0;
                                until Next = 0;

                        until SalesLine.Next = 0;
                end;
            "Document Type"::"Return Order", "Document Type"::"Credit Memo":
                begin
                    if SalesLine.FindSet then
                        repeat
                            if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine.Quantity <> 0) then
                                if SalesLine."Return Receipt No." <> '' then begin
                                    ReturnRcptLine.SetRange("Document No.", SalesLine."Return Receipt No.");
                                    ReturnRcptLine.SetRange("Line No.", SalesLine."Return Receipt Line No.");
                                end else begin
                                    ReturnRcptLine.SetCurrentKey("Return Order No.", "Return Order Line No.");
                                    ReturnRcptLine.SetRange("Return Order No.", SalesLine."Document No.");
                                    ReturnRcptLine.SetRange("Return Order Line No.", SalesLine."Line No.");
                                end;
                            SetRange(Correction, false);
                            if QtyType = QtyType::Invoicing then
                                ReturnRcptLine.SetFilter("Return Qty. Rcd. Not Invd.", '<>0');

                            if FindSet then
                                repeat
                                    ReturnRcptLine.FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
                                    if ItemLedgEntry.FindSet then
                                        repeat
                                            CreateTempAdjmtValueEntries(TempValueEntry, ItemLedgEntry."Entry No.");
                                        until ItemLedgEntry.Next = 0;
                                until Next = 0;

                        until SalesLine.Next = 0;
                end;
        end;
        PAGE.RunModal(0, TempValueEntry);
    end;


    procedure CreateTempAdjmtValueEntries(var TempValueEntry: Record "Value Entry" temporary; ItemLedgEntryNo: Integer)
    var
        ValueEntry: Record "Value Entry";
    begin

        ValueEntry.SetCurrentKey("Item Ledger Entry No.");
        ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgEntryNo);
        if FindSet then
            repeat
                if ValueEntry.Adjustment then begin
                    TempValueEntry := ValueEntry;
                    if TempValueEntry.Insert then;
                end;
            until Next = 0;

    end;


    procedure GetPstdDocLinesToRevere()
    var
        SalesPostedDocLines: Page "Posted Sales Document Lines";
    begin
        //fes mig
        /*
        GetCust("Sell-to Customer No.");
        SalesPostedDocLines.SetToSalesHeader(Rec);
        SalesPostedDocLines.SETRECORD(Cust);
        SalesPostedDocLines.LOOKUPMODE := TRUE;
        IF SalesPostedDocLines.RUNMODAL = ACTION::LookupOK THEN
          SalesPostedDocLines.CopyLineToDoc;
        
        CLEAR(SalesPostedDocLines);
        */
        //fes mig

    end;


    procedure CalcInvDiscForHeader()
    var
        SalesInvDisc: Codeunit "Sales-Calc. Discount";
    begin
        //fes mig
        /*
        SalesSetup.GET;
        IF SalesSetup."Calc. Inv. Discount" THEN
          SalesInvDisc.CalculateIncDiscForHeader(Rec);
        */
        //fes mig

    end;


    procedure SetSecurityFilterOnRespCenter()
    begin
        if UserSetupMgt.GetSalesFilter <> '' then begin
            FilterGroup(2);
            SetRange("Responsibility Center", UserSetupMgt.GetSalesFilter);
            FilterGroup(0);
        end;

        SetRange("Date Filter", 0D, WorkDate - 1);
    end;


    procedure Authorize()
    begin
        //fes mig
        /*
        IF NOT DOPaymentMgt.IsValidPaymentMethod("Payment Method Code") THEN
          ERROR(Text069,FIELDCAPTION("Payment Method Code"));
        DOPaymentTransLogMgt.FindValidAuthorizationEntry("Document Type","No.",DOPaymentTransLogEntry);
        IF DOPaymentTransLogEntry."Entry No." = DOPaymentMgt.AuthorizeSalesDoc(Rec,0,TRUE) THEN
          ERROR(Text067,
            DOPaymentTransLogEntry."Document Type",
            DOPaymentTransLogEntry.Amount,
            DOPaymentTransLogEntry."Transaction Date-Time",
            DOPaymentTransLogEntry."Document No.");
        "Authorization Required" := TRUE;
        MODIFY;
        */
        //fes mig

    end;


    procedure Void()
    begin
        //fes mig
        /*
        IF NOT DOPaymentMgt.IsValidPaymentMethod("Payment Method Code") THEN
          ERROR(Text069,FIELDCAPTION("Payment Method Code"));
        CLEAR(DOPaymentMgt);
        DOPaymentMgt.CheckSalesDoc(Rec);
        IF DOPaymentTransLogMgt.FindValidAuthorizationEntry("Document Type","No.",DOPaymentTransLogEntry) THEN
          DOPaymentMgt.VoidSalesDoc(Rec,DOPaymentTransLogEntry)
        ELSE
          MESSAGE(Text068);
        "Authorization Required" := FALSE;
        MODIFY;
        */
        //fes mig

    end;


    procedure GetCreditcardNumber(): Text[20]
    begin
        /*
        IF "Credit Card No." = '' THEN
          EXIT('');
        EXIT(DOPaymentCreditCard.GetCreditCardNumber("Credit Card No."));
        */
        //fes mig

    end;


    procedure SynchronizeForReservations(var NewSalesLine: Record "Sales Line"; OldSalesLine: Record "Sales Line")
    begin
        NewSalesLine.CalcFields("Reserved Quantity");
        if NewSalesLine."Reserved Quantity" = 0 then
            exit;
        if NewSalesLine."Location Code" <> OldSalesLine."Location Code" then
            NewSalesLine.Validate("Location Code", OldSalesLine."Location Code");
        if NewSalesLine."Bin Code" <> OldSalesLine."Bin Code" then
            NewSalesLine.Validate("Bin Code", OldSalesLine."Bin Code");
        if NewSalesLine.Modify then;
    end;


    procedure InventoryPickConflict(DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocNo: Code[20]; ShippingAdvice: Option Partial,Complete): Boolean
    var
        WarehouseActivityLine: Record "Warehouse Activity Line";
        SalesLine: Record "Sales Line";
    begin
        if ShippingAdvice <> ShippingAdvice::Complete then
            exit(false);
        WarehouseActivityLine.SetCurrentKey("Source Type", "Source Subtype", "Source No.");
        WarehouseActivityLine.SetRange("Source Type", DATABASE::"Sales Line");
        WarehouseActivityLine.SetRange("Source Subtype", DocType);
        WarehouseActivityLine.SetRange("Source No.", DocNo);
        if WarehouseActivityLine.IsEmpty then
            exit(false);
        SalesLine.SetRange("Document Type", DocType);
        SalesLine.SetRange("Document No.", DocNo);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.IsEmpty then
            exit(false);
        exit(true);
    end;


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


    procedure CheckCrLimit()
    begin
        //fes mig
        /*
        IF GUIALLOWED AND (CurrFieldNo <> 0) AND ("Document Type" <= "Document Type"::Invoice) THEN BEGIN
          "Amount Including VAT" := 0;
          IF "Document Type" = "Document Type"::Order THEN
            IF BilltoCustomerNoChanged THEN BEGIN
              SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Order);
              SalesLine.SETRANGE("Document No.","No.");
              SalesLine.CALCSUMS("Outstanding Amount","Shipped Not Invoiced");
              "Amount Including VAT" := SalesLine."Outstanding Amount" + SalesLine."Shipped Not Invoiced";
            END;
          CustCheckCreditLimit.SalesHeaderCheck(Rec);
          CALCFIELDS("Amount Including VAT");
        END;
        */
        //fes mig

    end;


    procedure QtyToShipIsZero(): Boolean
    begin
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        SalesLine.SetFilter("Qty. to Ship", '<>0');
        exit(SalesLine.IsEmpty);
    end;


    procedure IsApprovedForPosting(): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        //fes mig
        /*
        PurchaseHeader.INIT;
        IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN BEGIN
          IF ApprovalMgt.TestSalesPrepayment(Rec) THEN
            ERROR(STRSUBSTNO(Text071,"Document Type","No."));
          IF ApprovalMgt.TestSalesPayment(Rec) THEN
            ERROR(STRSUBSTNO(Text072,"Document Type","No."));
          EXIT(TRUE);
        END;
        */
        //fes mig

    end;


    procedure IsApprovedForPostingBatch(): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        //fes mig
        /*
        PurchaseHeader.INIT;
        IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN BEGIN
          IF ApprovalMgt.TestSalesPrepayment(Rec) THEN
            EXIT(FALSE);
          IF ApprovalMgt.TestSalesPayment(Rec) THEN
            EXIT(FALSE);
          EXIT(TRUE);
        END;
        */
        //fes mig

    end;


    procedure SendToPosting(PostingCodeunitID: Integer)
    begin
        if not IsApprovedForPosting then
            exit;
        CODEUNIT.Run(PostingCodeunitID, Rec);
    end;


    procedure CancelBackgroundPosting()
    var
        SalesPostViaJobQueue: Codeunit "Sales Post via Job Queue";
    begin
        //fes mig SalesPostViaJobQueue.CancelQueueEntry(Rec);
    end;


    procedure LinkSalesDocWithOpportunity(OldOpportunityNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        Opportunity: Record Opportunity;
    begin
        if "Opportunity No." <> OldOpportunityNo then begin
            if "Opportunity No." <> '' then
                if Opportunity.Get("Opportunity No.") then begin
                    Opportunity.TestField(Status, Opportunity.Status::"In Progress");
                    if Opportunity."Sales Document No." <> '' then begin
                        if Confirm(Text048, false, Opportunity."Sales Document No.", Opportunity."No.") then begin
                            if SalesHeader.Get("Document Type"::Quote, Opportunity."Sales Document No.") then begin
                                SalesHeader."Opportunity No." := '';
                                SalesHeader.Modify;
                            end;
                            UpdateOpportunityLink(Opportunity, Opportunity."Sales Document Type"::Quote, "No.");
                        end else
                            "Opportunity No." := OldOpportunityNo;
                    end else
                        UpdateOpportunityLink(Opportunity, Opportunity."Sales Document Type"::Quote, "No.");
                end;
            if (OldOpportunityNo <> '') and Opportunity.Get(OldOpportunityNo) then
                UpdateOpportunityLink(Opportunity, Opportunity."Sales Document Type"::" ", '');
        end;
    end;

    local procedure UpdateOpportunityLink(Opportunity: Record Opportunity; SalesDocumentType: Enum "Opportunity Document Type"; SalesHeaderNo: Code[20])
    begin
        Opportunity."Sales Document Type" := SalesDocumentType;
        Opportunity."Sales Document No." := SalesHeaderNo;
        Opportunity.Modify;
    end;

    local procedure IsPrepmtInvoicePosted(): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        SalesLine.SetFilter("Prepmt. Amt. Inv.", '>0');
        exit(not SalesLine.IsEmpty);
    end;


    procedure InvoicedLineExists(): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
        SalesLine.SetFilter("Quantity Invoiced", '<>%1', 0);
        exit(not SalesLine.IsEmpty);
    end;


    procedure SynchronizeAsmHeader()
    var
        AsmHeader: Record "Assembly Header";
        ATOLink: Record "Assemble-to-Order Link";
        Window: Dialog;
    begin
        ATOLink.SetCurrentKey(Type, "Document Type", "Document No.");
        ATOLink.SetRange(Type, ATOLink.Type::Sale);
        ATOLink.SetRange("Document Type", "Document Type");
        ATOLink.SetRange("Document No.", "No.");
        if ATOLink.FindSet then
            repeat
                if AsmHeader.Get(ATOLink."Assembly Document Type", ATOLink."Assembly Document No.") then
                    if "Posting Date" <> AsmHeader."Posting Date" then begin
                        Window.Open(StrSubstNo(SynchronizingMsg, "No.", AsmHeader."No."));
                        AsmHeader.Validate("Posting Date", "Posting Date");
                        AsmHeader.Modify;
                        Window.Close;
                    end;
            until ATOLink.Next = 0;
    end;


    procedure CheckShippingAdvice()
    var
        SalesLine: Record "Sales Line";
        QtyToShipBaseTotal: Decimal;
        Result: Boolean;
    begin
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        SalesLine.SetRange("Drop Shipment", false);
        Result := true;
        if SalesLine.FindSet then
            repeat
                if SalesLine.IsShipment then begin
                    QtyToShipBaseTotal += SalesLine."Qty. to Ship (Base)";
                    if SalesLine."Quantity (Base)" <>
                       SalesLine."Qty. to Ship (Base)" + SalesLine."Qty. Shipped (Base)"
                    then
                        Result := false;
                end;
            until SalesLine.Next = 0;
        if QtyToShipBaseTotal = 0 then
            Result := true;
        if not Result then
            Error(ShippingAdviceErr);
    end;


    procedure ControlClasificacionDevolucion()
    var
        recDocClas: Record "Docs. clas. devoluciones";
    begin

        //020
        recDocClas.Reset;
        recDocClas.SetRange("Tipo documento", recDocClas."Tipo documento"::Venta);
        recDocClas.SetRange("No. documento", "No.");
        if recDocClas.FindFirst then
            Error(Text56000, "No.");
    end;
}

