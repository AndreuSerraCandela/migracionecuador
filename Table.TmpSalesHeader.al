table 80013 "Tmp Sales Header"
{
    // DSLoc1.01   GRN     09/01/2009    Para adicionar funcionalidad de Retenciones y NCF
    //             GRN     04/07/2011    Creacion de un nuevo tipo de documento para localizar Guatemala
    // 001         GRN     13/07/2011    Creacion de Pre pedidos
    // 
    // 002         AMS     18/07/2011    Dimension Almacen en pedidos TPV.
    // 
    // 003         AMS     18/07/2011    No se debe modificar el almacen en caso de que se cambie el cliente en Pedidos TPV.
    // 
    // 004         AMS     27/09/2011    Se Captura el nombre del colegio
    // 
    // 005         AMS     06/11/2011    Se valida el tipo de documento para en No. de Serie de NCF
    // 
    // 006         AMS     22/11/2011    Se eliminan los pagos TPV asociados al pedido TPV.

    Caption = 'Sales Header';
    DataCaptionFields = "No.", "Sell-to Customer Name";
    LookupPageID = "Sales List";

    fields
    {
        field(1; "Document Type"; enum "Sales Document Type")
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
            var
                Opp: Record Opportunity;
            begin
            end;
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

            trigger OnValidate()
            var
            /*     SellToCustTemplate: Record "Customer Template"; */
            begin
            end;
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
            TableRelation = Currency;
        }
        field(33; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
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

            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
                Currency: Record Currency;
                JobPostLine: Codeunit "Job Post-Line";
                RecalculatePrice: Boolean;
            begin
            end;
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
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            var
                ApprovalEntry: Record "Approval Entry";
            begin
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
        field(57; Ship; Boolean)
        {
            Caption = 'Ship';
            Editable = false;
        }
        field(58; Invoice; Boolean)
        {
            Caption = 'Invoice';
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
        field(70; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
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
        }
        field(109; "Shipping No. Series"; Code[10])
        {
            Caption = 'Shipping No. Series';
            TableRelation = "No. Series";
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
        field(117; Reserve; Option)
        {
            Caption = 'Reserve';
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;
        }
        field(118; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            var
                TempCustLedgEntry: Record "Cust. Ledger Entry";
            begin
            end;
        }
        field(119; "VAT Base Discount %"; Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            var
                ChangeLogMgt: Codeunit "Change Log Management";
                RecRef: RecordRef;
                xRecRef: RecordRef;
            begin
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
        }
        field(130; "Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(131; "Prepayment No. Series"; Code[10])
        {
            Caption = 'Prepayment No. Series';
            TableRelation = "No. Series";
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
            end;
        }
        field(140; "Prepmt. Payment Discount %"; Decimal)
        {
            Caption = 'Prepmt. Payment Discount %';
            DecimalPlaces = 0 : 5;
        }
        field(151; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            Editable = false;
        }
        field(825; "Authorization Required"; Boolean)
        {
            Caption = 'Authorization Required';
        }
        field(827; "Credit Card No."; Code[20])
        {
            Caption = 'Credit Card No.';
            //TableRelation = Table827 WHERE (Field6 = FIELD ("Bill-to Customer No."));
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
            var
                ChangeLogMgt: Codeunit "Change Log Management";
                RecRef: RecordRef;
                xRecRef: RecordRef;
            begin
            end;
        }
        field(5051; "Sell-to Customer Template Code"; Code[10])
        {
            Caption = 'Sell-to Customer Template Code';
            /*  TableRelation = "Customer Template";
  */
            trigger OnValidate()
            var
            /*     SellToCustTemplate: Record "Customer Template"; */
            begin
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
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
                Opportunity: Record Opportunity;
                ChangeLogMgt: Codeunit "Change Log Management";
                RecRef: RecordRef;
                xRecRef: RecordRef;
            begin
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
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
            begin
            end;
        }
        field(5054; "Bill-to Customer Template Code"; Code[10])
        {
            Caption = 'Bill-to Customer Template Code';
            /*  TableRelation = "Customer Template"; */

            trigger OnValidate()
            var
            /*   BillToCustTemplate: Record "Customer Template"; */
            begin
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
            var
                Opportunity: Record Opportunity;
                SalesHeader: Record "Sales Header";
            begin
            end;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(5750; "Shipping Advice"; Option)
        {
            Caption = 'Shipping Advice';
            OptionCaption = 'Partial,Complete';
            OptionMembers = Partial,Complete;
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
        }
        field(5791; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(5792; "Shipping Time"; DateFormula)
        {
            Caption = 'Shipping Time';
        }
        field(5793; "Outbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Outbound Whse. Handling Time';
        }
        field(5794; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"));
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
        }
        field(7200; "Get Shipment Used"; Boolean)
        {
            Caption = 'Get Shipment Used';
            Editable = false;
        }
        field(8725; Signature; BLOB)
        {
            Caption = 'Signature';
            SubType = Bitmap;
        }
        field(9000; "Assigned User ID"; Code[50])
        {
            Caption = 'Assigned User ID';
            TableRelation = "User Setup";
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
        }
        field(50010; "Tipo de Venta"; Option)
        {
            OptionCaption = 'Invoice,Consignation,Sample';
            OptionMembers = Factura,Consignacion,Muestra;
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
        field(50014; "PO Box address"; Text[50])
        {
            Caption = 'PO Box address';
        }
        field(53000; "ID Cajero"; Code[20])
        {
            Caption = 'Cashier ID';
        }
        field(53001; "Hora creacion"; Time)
        {
            Caption = 'Creation time';
        }
        field(53002; "Tipo pedido"; Option)
        {
            Caption = 'Order type';
            OptionCaption = 'Order Type';
            OptionMembers = " ",TPV,Fact_comprimida;
        }
        field(53003; TPV; Code[20])
        {
        }
        field(53004; "Factura comprimida"; Code[20])
        {
            Caption = 'Compressed invoice';
        }
        field(53005; "Importe ITBIS Incl."; Decimal)
        {
            /*             CalcFormula = Sum ("Formas de Pago".Field30 WHERE (Field1 = FIELD ("Document Type"),
                                                                          Field3 = FIELD ("No.")));
                        FieldClass = FlowField; */
        }
        field(53006; "Venta a credito"; Boolean)
        {
        }
        field(53007; "Importe a liquidar"; Decimal)
        {
        }
        field(53008; Tienda; Code[20])
        {
            TableRelation = "Bancos tienda";
        }
        field(53009; "Factura en Historico"; Boolean)
        {
            CalcFormula = Exist("Sales Invoice Header" WHERE("No." = FIELD("Posting No.")));
            Caption = 'Invoice Posted';
            FieldClass = FlowField;
        }
        field(56000; "Pedido Consignacion"; Boolean)
        {
        }
        field(56001; "Collector Code"; Code[10])
        {
            Caption = 'Collector code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(56002; "Pre pedido"; Boolean)
        {
            Caption = 'Pre Order';
        }
        field(56003; "Devolucion Consignacion"; Boolean)
        {
        }
        field(56004; "Cod. Cupon"; Code[20])
        {
            Caption = 'Coupon Code';
        }
        field(56005; "Siguiente No."; Code[20])
        {
            CalcFormula = Lookup("No. Series Line"."Last No. Used" WHERE("Series Code" = FIELD("No. Serie NCF Facturas")));
            FieldClass = FlowField;
        }
        field(56006; "Cod. Colegio"; Code[20])
        {
            Caption = 'School Code';
            TableRelation = Contact WHERE(Type = FILTER(Company));
        }
        field(56007; "Nombre Colegio"; Text[120])
        {
            Caption = 'School Name';
        }
        field(56008; "Re facturacion"; Boolean)
        {
        }
        field(76041; "No. Serie NCF Facturas"; Code[10])
        {
            Caption = 'Invoice FDN Serial No.';
            TableRelation = "No. Series";
        }
        field(76079; "No. Comprobante Fiscal"; Code[19])
        {
            Caption = 'Fiscal Document No.';
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
        }
        field(76078; "Cod. Clasificacion Gastos"; Code[2])
        {
            Caption = 'Expense Clasification Code';
        }
        field(99008500; "Date Received"; Date)
        {
            Caption = 'Date Received';
        }
        field(99008501; "Time Received"; Time)
        {
            Caption = 'Time Received';
        }
        field(99008502; "BizTalk Request for Sales Qte."; Boolean)
        {
            Caption = 'BizTalk Request for Sales Qte.';
        }
        field(99008503; "BizTalk Sales Order"; Boolean)
        {
            Caption = 'BizTalk Sales Order';
        }
        field(99008509; "Date Sent"; Date)
        {
            Caption = 'Date Sent';
        }
        field(99008510; "Time Sent"; Time)
        {
            Caption = 'Time Sent';
        }
        field(99008513; "BizTalk Sales Quote"; Boolean)
        {
            Caption = 'BizTalk Sales Quote';
        }
        field(99008514; "BizTalk Sales Order Cnfmn."; Boolean)
        {
            Caption = 'BizTalk Sales Order Cnfmn.';
        }
        field(99008518; "Customer Quote No."; Code[20])
        {
            Caption = 'Customer Quote No.';
        }
        field(99008519; "Customer Order No."; Code[20])
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
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
        key(Key2; "No.", "Document Type")
        {
        }
        key(Key3; "Document Type", "Sell-to Customer No.", "No.")
        {
        }
        key(Key4; "Document Type", "Combine Shipments", "Bill-to Customer No.", "Currency Code")
        {
        }
        key(Key5; "Sell-to Customer No.", "External Document No.")
        {
        }
        key(Key6; "Document Type", "Sell-to Contact No.")
        {
        }
        key(Key7; "Bill-to Contact No.")
        {
        }
        key(Key8; "ID Cajero", "Tipo pedido")
        {
        }
        key(Key9; "External Document No.")
        {
        }
        key(Key10; "Document Type", "Sell-to Customer No.", Status)
        {
        }
        key(Key11; "Posting Date")
        {
        }
        key(Key12; "Requested Delivery Date")
        {
        }
        key(Key13; "Promised Delivery Date")
        {
        }
        key(Key14; "Shipment Date")
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
        Text008: Label 'Deleting this document will cause a gap in the number series for shipments. ';
        Text009: Label 'An empty shipment %1 will be created to fill this gap in the number series.\\';
        Text010: Label 'Do you want to continue?';
        Text011: Label 'Deleting this document will cause a gap in the number series for posted invoices. ';
        Text012: Label 'An empty posted invoice %1 will be created to fill this gap in the number series.\\';
        Text013: Label 'Deleting this document will cause a gap in the number series for posted credit memos. ';
        Text014: Label 'An empty posted credit memo %1 will be created to fill this gap in the number series.\\';
        Text015: Label 'If you change %1, the existing sales lines will be deleted and new sales lines based on the new information on the header will be created.\\';
        Text017: Label 'You must delete the existing sales lines before you can change %1.';
        Text018: Label 'You have changed %1 on the sales header, but it has not been changed on the existing sales lines.\';
        Text019: Label 'You must update the existing sales lines manually.';
        Text020: Label 'The change may affect the exchange rate used in the price calculation of the sales lines.';
        Text021: Label 'Do you want to update the exchange rate?';
        Text022: Label 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
        Text023: Label 'Do you want to print return receipt %1?';
        Text024: Label 'You have modified the %1 field. Note that the recalculation of Tax may cause penny differences, so you must check the amounts afterwards. ';
        Text026: Label 'Do you want to update the %2 field on the lines to reflect the new value of %1?';
        Text027: Label 'Your identification is set up to process from %1 %2 only.';
        Text028: Label 'You cannot change the %1 when the %2 has been filled in.';
        Text029: Label 'Deleting this document will cause a gap in the number series for return receipts. ';
        Text030: Label 'An empty return receipt %1 will be created to fill this gap in the number series.\\';
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
        UserMgt: Codeunit "User Setup Management";
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        SalesPost: Codeunit "Sales-Post";
        CustEntrySetApplID: Codeunit "Cust. Entry-SetAppl.ID";
        DimMgt: Codeunit DimensionManagement;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        WhseSourceHeader: Codeunit "Whse. Validate Source Header";
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        CurrencyDate: Date;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text035: Label 'You cannot Release Quote or Make Order unless you specify a customer on the quote.\\Do you want to create customer(s) now?';
        Text037: Label 'Contact %1 %2 is not related to customer %3.';
        Text038: Label 'Contact %1 %2 is related to a different company than customer %3.';
        Text039: Label 'Contact %1 %2 is not related to a customer.';
        ReservEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
        Text040: Label 'A won opportunity is linked to this order.\';
        Text041: Label 'It has to be changed to status Lost before the Order can be deleted.\';
        Text042: Label 'Do you want to change the status for this opportunity now?';
        Text043: Label 'Wizard Aborted';
        Text044: Label 'The status of the opportunity has not been changed. The program has aborted deleting the order.';
        SkipSellToContact: Boolean;
        SkipBillToContact: Boolean;
        Text045: Label 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.';
        Text047: Label 'You cannot change %1 because reservation, item tracking, or order tracking exists on the sales order.';
        Text048: Label 'Sales quote %1 has already been assigned to opportunity %2. Would you like to reassign this quote?';
        Text049: Label 'The %1 field cannot be blank because this quote is linked to an opportunity.';
        InsertMode: Boolean;
        CompanyInfo: Record "Company Information";
        Text050: Label 'If %1 is %2 in sales order no. %3, then all sales lines where type is %4 must use the same location.';
        HideCreditCheckDialogue: Boolean;
        Text051: Label 'The sales %1 %2 already exists.';
        Text052: Label 'The sales %1 %2 has item tracking. Do you want to delete it anyway?';
        Text053: Label 'You must cancel the approval process if you wish to change the %1.';
        Text054: Label 'The sales %1 %2 has item tracking. Do you want to delete it anyway?';
        Text055: Label 'Deleting this document will cause a gap in the number series for prepayment invoices. ';
        Text056: Label 'An empty prepayment invoice %1 will be created to fill this gap in the number series.\\';
        Text057: Label 'Deleting this document will cause a gap in the number series for prepayment credit memos. ';
        Text058: Label 'An empty prepayment credit memo %1 will be created to fill this gap in the number series.\\';
        Text061: Label '%1 is set up to process from %2 %3 only.';
        Text062: Label 'You cannot change %1 because the corresponding %2 %3 has been assigned to this %4.';
        Text063: Label 'Reservations exist for this order. These reservations will be canceled if a date conflict is caused by this change.\\';
        Text064: Label 'The warehouse shipment was not created because the Shipping Advice field is set to Complete, and item no. %1 is not available in location code %2.\\You can create the warehouse shipment by either changing the Shipping Advice field to Partial in sales order no. %3, or filling in the warehouse shipment document manually.';
        USText001: Label '%1 %2 has an applied payment in journal %3, %4 line %5';
        "*** Santillana ***": Integer;
        SantSetup: Record "Config. Empresa";
        SalesLine1: Record "Sales Line";
        GenBusPostGrp: Record "Gen. Business Posting Group";
        Cliente: Record Customer;
        Error0001: Label 'No puede modificar un pedido tipo TPV o Factura comprimida';
        txt001: Label 'Se eliminaran las líneas de ventas del pedido, confirma que desea continuar';
        Error002: Label 'Existe otro pedido tipo Consignacion para este cliente - No. Pedido %1';
        Error003: Label 'Existe un pedido de Devolucion de consignacion en borrador para este cliente - No. Pedido %1';
        Tienda: Record "Bancos tienda";
        TPV: Record Tiendas;
        TransferHeader: Record "Transfer Header";
        "**002**": Integer;
        rDefDim: Record "Default Dimension";
        rContacto: Record Contact;
        "**005**": Integer;
        rNoSeries: Record "No. Series";
        "**006**": Integer;
        rPagosTPV: Record "Tipos de Tarjeta";
}

