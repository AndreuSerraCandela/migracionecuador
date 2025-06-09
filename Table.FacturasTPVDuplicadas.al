table 50512 "Facturas TPV Duplicadas"
{
    Caption = 'Sales Invoice Header';
    DataCaptionFields = "No.", "Sell-to Customer Name";
    DrillDownPageID = "Posted Sales Invoices";
    LookupPageID = "Posted Sales Invoices";

    fields
    {
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(4; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(5; "Bill-to Name"; Text[50])
        {
            Caption = 'Name';
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
        }
        field(10; "Bill-to Contact"; Text[50])
        {
            Caption = 'Contact';
        }
        field(11; "Your Reference"; Text[30])
        {
            Caption = 'Customer PO No.';
        }
        field(12; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));
        }
        field(13; "Ship-to Name"; Text[50])
        {
            Caption = 'Ship-to Name';
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
        }
        field(18; "Ship-to Contact"; Text[50])
        {
            Caption = 'Ship-to Contact';
        }
        field(19; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(21; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(22; "Posting Description"; Text[60])
        {
            Caption = 'Posting Description';
        }
        field(23; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(24; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(25; "Payment Discount %"; Decimal)
        {
            Caption = 'Payment Discount %';
            DecimalPlaces = 0 : 5;
        }
        field(26; "Pmt. Discount Date"; Date)
        {
            Caption = 'Pmt. Discount Date';
        }
        field(27; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
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
            Editable = false;
            TableRelation = Currency;
        }
        field(33; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
        }
        field(34; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(35; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';
        }
        field(40; "Customer Disc. Group"; Code[10])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(41; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(43; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser".Tipo WHERE(Tipo = FILTER(Vendedor));
        }
        field(44; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = Exist("Sales Comment Line" WHERE("Document Type" = CONST("Posted Invoice"),
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
        field(52; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(53; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
        }
        field(55; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(60; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Invoice Line".Amount WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Invoice Line"."Amount Including VAT" WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount Including Tax';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "VAT Registration No."; Text[30])
        {
            Caption = 'VAT Registration No.';
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
        }
        field(75; "EU 3-Party Trade"; Boolean)
        {
            Caption = 'EU 3-Party Trade';
        }
        field(76; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(77; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(78; "VAT Country/Region Code"; Code[10])
        {
            Caption = 'VAT Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(79; "Sell-to Customer Name"; Text[50])
        {
            Caption = 'Sell-to Customer Name';
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
        }
        field(89; "Sell-to County"; Text[30])
        {
            Caption = 'Sell-to State';
        }
        field(90; "Sell-to Country/Region Code"; Code[10])
        {
            Caption = 'Sell-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(91; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to ZIP Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
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
        }
        field(98; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(99; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(100; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(101; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(102; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(104; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(105; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(106; "Package Tracking No."; Text[30])
        {
            Caption = 'Package Tracking No.';
        }
        field(107; "Pre-Assigned No. Series"; Code[10])
        {
            Caption = 'Pre-Assigned No. Series';
            TableRelation = "No. Series";
        }
        field(108; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(110; "Order No. Series"; Code[10])
        {
            Caption = 'Order No. Series';
            TableRelation = "No. Series";
        }
        field(111; "Pre-Assigned No."; Code[20])
        {
            Caption = 'Pre-Assigned No.';
        }
        field(112; "User ID"; Code[20])
        {
            Caption = 'User ID';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
            end;
        }
        field(113; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(114; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(115; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(116; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'Tax Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(119; "VAT Base Discount %"; Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(131; "Prepayment No. Series"; Code[10])
        {
            Caption = 'Prepayment No. Series';
            TableRelation = "No. Series";
        }
        field(136; "Prepayment Invoice"; Boolean)
        {
            Caption = 'Prepayment Invoice';
        }
        field(137; "Prepayment Order No."; Code[20])
        {
            Caption = 'Prepayment Order No.';
        }
        field(151; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            Editable = false;
        }
        field(827; "Credit Card No."; Code[20])
        {
            Caption = 'Credit Card No.';            
        }
        field(5050; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
        }
        field(5052; "Sell-to Contact No."; Code[20])
        {
            Caption = 'Sell-to Contact No.';
            TableRelation = Contact;
        }
        field(5053; "Bill-to Contact No."; Code[20])
        {
            Caption = 'Bill-to Contact No.';
            TableRelation = Contact;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(5900; "Service Mgt. Document"; Boolean)
        {
            Caption = 'Service Mgt. Document';
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
        }
        field(7200; "Get Shipment Used"; Boolean)
        {
            Caption = 'Get Shipment Used';
        }
        field(10005; "Ship-to UPS Zone"; Code[2])
        {
            Caption = 'Ship-to UPS Zone';
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
        field(50010; "Tipo de Venta"; Option)
        {
            OptionCaption = 'Invoice,Consignation,Sample,Donations';
            OptionMembers = Factura,Consignacion,Muestras,Donaciones;
        }
        field(53008; Tienda; Code[20])
        {
            TableRelation = "Bancos tienda";
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
            Description = 'Ecuador';
        }
        field(55003; "No. Correlativo Rem. Anulado"; Code[20])
        {
            Caption = 'Remision Correlative No. Voided';
            Description = 'Ecuador';
        }
        field(55004; "No. documento Rem. a Anular"; Code[20])
        {
            Description = 'Ecuador';
            TableRelation = "Sales Shipment Header"."No." WHERE("Remision Anulada" = FILTER(false));
        }
        field(55005; "No. Correlativo Fact. a Anular"; Code[20])
        {
            Caption = 'Invoice Correlative No. to Void';
            Description = 'Ecuador';
        }
        field(55006; "No. Factura a Anular"; Code[20])
        {
            Caption = 'Invoice No. To Void';
            Description = 'Ecuador';
            TableRelation = "Sales Invoice Header"."No." WHERE("Factura Anulada" = FILTER(false));
        }
        field(55007; "Siguiente No. Remision"; Code[20])
        {
            Caption = 'Next remission No.';
            Description = 'Ecuador';
        }
        field(55008; "No. Nota Credito a Anular"; Code[20])
        {
            Caption = 'Credit Memo to Void';
            Description = 'Ecuador';
            TableRelation = "Sales Cr.Memo Header";
        }
        field(55009; "Correlativo NCR a Anular"; Code[30])
        {
            Description = 'Ecuador';
        }
        field(55010; "No. Autorizacion Comprobante"; Code[37])
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
        }
        field(55014; "Punto de Emision Factura"; Code[3])
        {
            Caption = 'Invoice Issue Point';
            Description = 'SRI';
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
        field(55017; "No. Autorizacion Remision"; Code[37])
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
        field(55019; "ID Retencion Venta"; Code[30])
        {
            Caption = 'Sales Retention ID';
            Description = 'Ecuador';
        }
        field(55020; "Importe Retencion Venta"; Decimal)
        {
            Caption = 'Sales Retention Amount';
            Description = 'Ecuador';
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
        field(55030; "Cliente Existente"; Boolean)
        {
            CalcFormula = Exist(Customer WHERE("VAT Registration No." = FIELD("VAT Registration No.")));
            Description = 'Ecuador. Campo para utilziarlo en la generacion del reporte ATS';
            FieldClass = FlowField;
        }
        field(55051; "Factura Anulada"; Boolean)
        {
            Caption = 'Voided Invoice';
        }
        field(55090; "RNC Corregido"; Code[30])
        {
            Description = 'Temporal para corregir RNC''s cargados erroneamente';
        }
        field(56000; "Pedido Consignacion"; Boolean)
        {
        }
        field(56001; "Collector Code"; Code[10])
        {
            Caption = 'Collector code';
            TableRelation = "Salesperson/Purchaser".Tipo WHERE(Tipo = FILTER(Cobrador));
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
        field(56006; "Cod. Colegio"; Code[20])
        {
            Caption = 'School Code';
            TableRelation = Contact WHERE(Type = FILTER(Company));
        }
        field(56007; "Nombre Colegio"; Text[60])
        {
            Caption = 'School Name';
        }
        field(56008; Refacturar; Boolean)
        {
        }
        field(56010; CAE; Text[160])
        {
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56011; "Respuesta CAE/CAEC"; Text[100])
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
        field(56019; "Folio Anulado en Ifacere"; Boolean)
        {
            Caption = 'Folio voided at Ifacere';
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
        field(56022; "Fecha entrega requerida"; Date)
        {
            Caption = 'Requested Delivery Date';
        }
        field(56023; "Fecha Recepcion Documento"; Date)
        {
            Caption = 'Reception Document Date';
        }
        field(56024; "Hora Creacion Imp. Fiscal"; Time)
        {
            Caption = 'Fiscal Printer Creation Time';
            Description = 'Santillana Panama';
        }
        field(56032; "Fecha Recepcion"; Date)
        {
            Caption = 'Reception Date';
        }
        field(56033; "Siguiente No. Nota. Cr."; Code[20])
        {
        }
        field(56042; "Creado por usuario"; Code[20])
        {
            TableRelation = User;
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
        field(76046; "ID Cajero"; Code[20])
        {
            Caption = 'Cashier ID';
        }
        field(76029; "Hora creacion"; Time)
        {
            Caption = 'Creation time';
        }
        field(76011; "Tipo pedido"; Option)
        {
            Caption = 'Order type';
            OptionCaption = ' ,TPV,Mobile';
            OptionMembers = " ",TPV,Movilidad;
        }
        field(76016; TPV; Code[20])
        {
        }
        field(76018; "Factura comprimida"; Code[20])
        {
            Caption = 'Compressed invoice';
        }
        field(76015; "Importe ITBIS Incl."; Decimal)
        {
        }
        field(76026; "Venta a credito"; Boolean)
        {
        }
        field(76020; "Importe a liquidar"; Decimal)
        {
        }
        field(76022; "Tipo Documento Replicador"; Option)
        {
            Caption = 'Document Type';
            Description = 'Utilizado para Replicar del historico de facturas a borrador';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(76027; "No. Serie Envio Replicador"; Code[10])
        {
            Caption = 'Replicator Shipment No. Series';
            Description = 'Utilizado para Replicar del historico de facturas a borrador';
        }
        field(76041; "No. Serie NCF Facturas"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(76079; "No. Comprobante Fiscal"; Code[19])
        {
        }
        field(76080; "No. Comprobante Fiscal Rel."; Code[19])
        {
        }
        field(76058; "Ultimo. No. NCF"; Code[19])
        {
        }
        field(99008509; "Date Sent"; Date)
        {
            Caption = 'Date Sent';
        }
        field(99008510; "Time Sent"; Time)
        {
            Caption = 'Time Sent';
        }
        field(99008516; "BizTalk Sales Invoice"; Boolean)
        {
            Caption = 'BizTalk Sales Invoice';
        }
        field(99008519; "Customer Order No."; Code[5])
        {
            Caption = 'Customer Order No.';
        }
        field(99008521; "BizTalk Document Sent"; Boolean)
        {
            Caption = 'BizTalk Document Sent';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Order No.")
        {
        }
        key(Key3; "Pre-Assigned No.")
        {
        }
        key(Key4; "Sell-to Customer No.", "External Document No.")
        {
        }
        key(Key5; "Sell-to Customer No.", "Order Date")
        {
        }
        key(Key6; "Sell-to Customer No.", "No.")
        {
        }
        key(Key7; "Prepayment Order No.", "Prepayment Invoice")
        {
        }
        key(Key8; "No. Comprobante Fiscal")
        {
        }
        key(Key9; "Cod. Cupon", "Cod. Colegio", "Posting Date")
        {
        }
        key(Key10; "Posting Date", "VAT Registration No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Posting Date", "Posting Description")
        {
        }
    }

    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCommentLine: Record "Sales Comment Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        PostCode: Record "Post Code";
        PostSalesLinesDelete: Codeunit "PostSales-Delete";
        DimMgt: Codeunit DimensionManagement;
        ApprovalsMgt: Codeunit "Approvals Mgmt.";
        "*** DSLoc ***": Integer;
        ConfSantillana: Record "Config. Empresa";
        Localizacion: Record "Parametros Loc. x País";
        GpoContableCte: Record "Customer Posting Group";
        UserSetUp: Record "User Setup";
        Error001: Label 'User cannot modify %1';


    procedure PrintRecords(ShowRequestForm: Boolean)
    var
        ReportSelection: Record "Report Selections";
    begin
    end;


    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
    end;


    procedure GetCreditcardNumber(): Text[20]
    begin
    end;


    procedure LookupAdjmtValueEntries()
    var
        ValueEntry: Record "Value Entry";
    begin
    end;
}

