table 76437 "Sales Header X"
{

    fields
    {
        field(1; "Document Type"; Enum "Sales Comment Document Type")
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
            //OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            //OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            DataClassification = ToBeClassified;
            Description = '#34448';
            TableRelation = Customer WHERE(Inactivo = CONST(false));

            trigger OnValidate()
            var
                StandardCodesMgt: Codeunit "Standard Codes Mgt.";
                CustomerPostingGr: Record "Customer Posting Group";
            begin
            end;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(4; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            DataClassification = ToBeClassified;
            Description = '#34448';
            NotBlank = true;
            TableRelation = Customer WHERE(Inactivo = CONST(false));
        }
        field(5; "Bill-to Name"; Text[100])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
            Description = '#56924';
            TableRelation = Customer.Name;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                Customer: Record Customer;
            begin
            end;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
            end;
        }
        field(6; "Bill-to Name 2"; Text[50])
        {
            Caption = 'Name 2';
            DataClassification = ToBeClassified;
        }
        field(7; "Bill-to Address"; Text[100])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(8; "Bill-to Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;
        }
        field(9; "Bill-to City"; Text[50])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Bill-to Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Bill-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Bill-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(10; "Bill-to Contact"; Text[100])
        {
            Caption = 'Contact';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                Contact: Record Contact;
            begin
            end;
        }
        field(11; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
            DataClassification = ToBeClassified;
        }
        field(12; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            DataClassification = ToBeClassified;
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));

            trigger OnValidate()
            var
                ShipToAddr: Record "Ship-to Address";
            begin
            end;
        }
        field(13; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
            DataClassification = ToBeClassified;
            Description = '#34448';
        }
        field(14; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
            DataClassification = ToBeClassified;
        }
        field(15; "Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
            DataClassification = ToBeClassified;
        }
        field(16; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
            DataClassification = ToBeClassified;
        }
        field(17; "Ship-to City"; Text[50])
        {
            Caption = 'Ship-to City';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Ship-to Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(18; "Ship-to Contact"; Text[100])
        {
            Caption = 'Ship-to Contact';
            DataClassification = ToBeClassified;
        }
        field(19; "Order Date"; Date)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Order Date';
            DataClassification = ToBeClassified;
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
            end;
        }
        field(21; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
            DataClassification = ToBeClassified;
        }
        field(22; "Posting Description"; Text[100])
        {
            Caption = 'Posting Description';
            DataClassification = ToBeClassified;
        }
        field(23; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            DataClassification = ToBeClassified;
            TableRelation = "Payment Terms";

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
            end;
        }
        field(24; "Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = ToBeClassified;
        }
        field(25; "Payment Discount %"; Decimal)
        {
            Caption = 'Payment Discount %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(26; "Pmt. Discount Date"; Date)
        {
            Caption = 'Pmt. Discount Date';
            DataClassification = ToBeClassified;
        }
        field(27; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            DataClassification = ToBeClassified;
            TableRelation = "Shipment Method";
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            Description = '#34448';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false),
                                            Inactivo = CONST(false));
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
        }
        field(31; "Customer Posting Group"; Code[20])
        {
            Caption = 'Customer Posting Group';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Customer Posting Group";
        }
        field(32; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(33; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(34; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            DataClassification = ToBeClassified;
            TableRelation = "Customer Price Group";
        }
        field(35; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including Tax';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
                Currency: Record Currency;
                ConfirmManagement: Codeunit "Confirm Management";
                RecalculatePrice: Boolean;
                VatFactor: Decimal;
                LineInvDiscAmt: Decimal;
                InvDiscRounding: Decimal;
            begin
            end;
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            AccessByPermission = TableData "Cust. Invoice Disc." = R;
            Caption = 'Invoice Disc. Code';
            DataClassification = ToBeClassified;
        }
        field(40; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            DataClassification = ToBeClassified;
            TableRelation = "Customer Discount Group";
        }
        field(41; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            DataClassification = ToBeClassified;
            TableRelation = Language;
        }
        field(43; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            DataClassification = ToBeClassified;
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
            DataClassification = ToBeClassified;
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
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
            DataClassification = ToBeClassified;
        }
        field(52; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(53; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                GenJnlLine: Record "Gen. Journal Line";
                GenJnlApply: Codeunit "Gen. Jnl.-Apply";
                ApplyCustEntries: Page "Apply Customer Entries";
            begin
            end;
        }
        field(55; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(56; "Recalculate Invoice Disc."; Boolean)
        {
            CalcFormula = Exist("Sales Line" WHERE("Document Type" = FIELD("Document Type"),
                                                    "Document No." = FIELD("No."),
                                                    "Recalculate Invoice Disc." = CONST(true)));
            Caption = 'Recalculate Invoice Disc.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(57; Ship; Boolean)
        {
            Caption = 'Ship';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(58; Invoice; Boolean)
        {
            Caption = 'Invoice';
            DataClassification = ToBeClassified;
        }
        field(59; "Print Posted Documents"; Boolean)
        {
            Caption = 'Print Posted Documents';
            DataClassification = ToBeClassified;
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
            DataClassification = ToBeClassified;
        }
        field(63; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
            DataClassification = ToBeClassified;
        }
        field(64; "Last Shipping No."; Code[20])
        {
            Caption = 'Last Shipping No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Sales Shipment Header";
        }
        field(65; "Last Posting No."; Code[20])
        {
            Caption = 'Last Posting No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Sales Invoice Header";
        }
        field(66; "Prepayment No."; Code[20])
        {
            Caption = 'Prepayment No.';
            DataClassification = ToBeClassified;
        }
        field(67; "Last Prepayment No."; Code[20])
        {
            Caption = 'Last Prepayment No.';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Invoice Header";
        }
        field(68; "Prepmt. Cr. Memo No."; Code[20])
        {
            Caption = 'Prepmt. Cr. Memo No.';
            DataClassification = ToBeClassified;
        }
        field(69; "Last Prepmt. Cr. Memo No."; Code[20])
        {
            Caption = 'Last Prepmt. Cr. Memo No.';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Cr.Memo Header";
        }
        field(70; "VAT Registration No."; Text[30])
        {
            Caption = 'Tax Registration No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Customer: Record Customer;
                VATRegistrationLog: Record "VAT Registration Log";
                VATRegistrationNoFormat: Record "VAT Registration No. Format";
                VATRegNoSrvConfig: Record "VAT Reg. No. Srv Config";
                VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
                ResultRecRef: RecordRef;
                ApplicableCountryCode: Code[10];
            begin
            end;
        }
        field(71; "Combine Shipments"; Boolean)
        {
            Caption = 'Combine Shipments';
            DataClassification = ToBeClassified;
        }
        field(73; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = ToBeClassified;
            TableRelation = "Reason Code";
        }
        field(74; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Business Posting Group";
        }
        field(75; "EU 3-Party Trade"; Boolean)
        {
            Caption = 'EU 3-Party Trade';
            DataClassification = ToBeClassified;
        }
        field(76; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            DataClassification = ToBeClassified;
            TableRelation = "Transaction Type";
        }
        field(77; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            DataClassification = ToBeClassified;
            TableRelation = "Transport Method";
        }
        field(78; "VAT Country/Region Code"; Code[10])
        {
            Caption = 'Tax Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(79; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
            DataClassification = ToBeClassified;
            Description = '#56924';
            TableRelation = Customer.Name;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                Customer: Record Customer;
            begin
            end;

            trigger OnValidate()
            var
                Customer: Record Customer;
                IdentityManagement: Codeunit "Identity Management";
            begin
            end;
        }
        field(80; "Sell-to Customer Name 2"; Text[50])
        {
            Caption = 'Sell-to Customer Name 2';
            DataClassification = ToBeClassified;
        }
        field(81; "Sell-to Address"; Text[100])
        {
            Caption = 'Sell-to Address';
            DataClassification = ToBeClassified;
        }
        field(82; "Sell-to Address 2"; Text[50])
        {
            Caption = 'Sell-to Address 2';
            DataClassification = ToBeClassified;
        }
        field(83; "Sell-to City"; Text[50])
        {
            Caption = 'Sell-to City';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Sell-to Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Sell-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Sell-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(84; "Sell-to Contact"; Text[100])
        {
            Caption = 'Sell-to Contact';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                Contact: Record Contact;
            begin
            end;
        }
        field(85; "Bill-to Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(86; "Bill-to County"; Text[30])
        {
            CaptionClass = '5,1,' + "Bill-to Country/Region Code";
            Caption = 'State';
            DataClassification = ToBeClassified;
        }
        field(87; "Bill-to Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(88; "Sell-to Post Code"; Code[20])
        {
            Caption = 'Sell-to ZIP Code';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Sell-to Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Sell-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Sell-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(89; "Sell-to County"; Text[30])
        {
            CaptionClass = '5,1,' + "Sell-to Country/Region Code";
            Caption = 'Sell-to State';
            DataClassification = ToBeClassified;
        }
        field(90; "Sell-to Country/Region Code"; Code[10])
        {
            Caption = 'Sell-to Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(91; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to ZIP Code';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Ship-to Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(92; "Ship-to County"; Text[30])
        {
            CaptionClass = '5,1,' + "Ship-to Country/Region Code";
            Caption = 'Ship-to State';
            DataClassification = ToBeClassified;
        }
        field(93; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(94; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";
        }
        field(97; "Exit Point"; Code[10])
        {
            Caption = 'Exit Point';
            DataClassification = ToBeClassified;
            TableRelation = "Entry/Exit Point";
        }
        field(98; Correction; Boolean)
        {
            Caption = 'Correction';
            DataClassification = ToBeClassified;
        }
        field(99; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;
        }
        field(100; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                WhseSalesRelease: Codeunit "Whse.-Sales Release";
            begin
            end;
        }
        field(101; "Area"; Code[10])
        {
            Caption = 'Area';
            DataClassification = ToBeClassified;
            TableRelation = Area;
        }
        field(102; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            DataClassification = ToBeClassified;
            TableRelation = "Transaction Specification";
        }
        field(104; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";

            trigger OnValidate()
            var
                SEPADirectDebitMandate: Record "SEPA Direct Debit Mandate";
            begin
            end;
        }
        field(105; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code';
            DataClassification = ToBeClassified;
            TableRelation = "Shipping Agent";
        }
        field(106; "Package Tracking No."; Text[30])
        {
            Caption = 'Package Tracking No.';
            DataClassification = ToBeClassified;
        }
        field(107; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(109; "Shipping No. Series"; Code[20])
        {
            Caption = 'Shipping No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(114; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            DataClassification = ToBeClassified;
            TableRelation = "Tax Area";
            ValidateTableRelation = false;
        }
        field(115; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
            DataClassification = ToBeClassified;
        }
        field(116; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Business Posting Group";
        }
        field(117; Reserve; Option)
        {
            AccessByPermission = TableData Item = R;
            Caption = 'Reserve';
            DataClassification = ToBeClassified;
            InitValue = Optional;
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;
        }
        field(118; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
                CustEntrySetApplID: Codeunit "Cust. Entry-SetAppl.ID";
            begin
            end;
        }
        field(119; "VAT Base Discount %"; Decimal)
        {
            Caption = 'VAT Base Discount %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(120; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(121; "Invoice Discount Calculation"; Option)
        {
            Caption = 'Invoice Discount Calculation';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'None,%,Amount';
            OptionMembers = "None","%",Amount;
        }
        field(122; "Invoice Discount Value"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Invoice Discount Value';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(123; "Send IC Document"; Boolean)
        {
            Caption = 'Send IC Document';
            DataClassification = ToBeClassified;
        }
        field(124; "IC Status"; Option)
        {
            Caption = 'IC Status';
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Pending,Sent';
            OptionMembers = New,Pending,Sent;
        }
        field(125; "Sell-to IC Partner Code"; Code[20])
        {
            Caption = 'Sell-to IC Partner Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(126; "Bill-to IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(129; "IC Direction"; Option)
        {
            Caption = 'IC Direction';
            DataClassification = ToBeClassified;
            OptionCaption = 'Outgoing,Incoming';
            OptionMembers = Outgoing,Incoming;
        }
        field(130; "Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(131; "Prepayment No. Series"; Code[20])
        {
            Caption = 'Prepayment No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(132; "Compress Prepayment"; Boolean)
        {
            Caption = 'Compress Prepayment';
            DataClassification = ToBeClassified;
            InitValue = true;
        }
        field(133; "Prepayment Due Date"; Date)
        {
            Caption = 'Prepayment Due Date';
            DataClassification = ToBeClassified;
        }
        field(134; "Prepmt. Cr. Memo No. Series"; Code[20])
        {
            Caption = 'Prepmt. Cr. Memo No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(135; "Prepmt. Posting Description"; Text[100])
        {
            Caption = 'Prepmt. Posting Description';
            DataClassification = ToBeClassified;
        }
        field(138; "Prepmt. Pmt. Discount Date"; Date)
        {
            Caption = 'Prepmt. Pmt. Discount Date';
            DataClassification = ToBeClassified;
        }
        field(139; "Prepmt. Payment Terms Code"; Code[10])
        {
            Caption = 'Prepmt. Payment Terms Code';
            DataClassification = ToBeClassified;
            TableRelation = "Payment Terms";

            trigger OnValidate()
            var
                PaymentTerms: Record "Payment Terms";
                IsHandled: Boolean;
            begin
            end;
        }
        field(140; "Prepmt. Payment Discount %"; Decimal)
        {
            Caption = 'Prepmt. Payment Discount %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(151; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(152; "Quote Valid Until Date"; Date)
        {
            Caption = 'Quote Valid To Date';
            DataClassification = ToBeClassified;
        }
        field(153; "Quote Sent to Customer"; DateTime)
        {
            Caption = 'Quote Sent to Customer';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(154; "Quote Accepted"; Boolean)
        {
            Caption = 'Quote Accepted';
            DataClassification = ToBeClassified;
        }
        field(155; "Quote Accepted Date"; Date)
        {
            Caption = 'Quote Accepted Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(160; "Job Queue Status"; Option)
        {
            Caption = 'Job Queue Status';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Scheduled for Posting,Error,Posting';
            OptionMembers = " ","Scheduled for Posting",Error,Posting;

            trigger OnLookup()
            var
                JobQueueEntry: Record "Job Queue Entry";
            begin
            end;
        }
        field(161; "Job Queue Entry ID"; Guid)
        {
            Caption = 'Job Queue Entry ID';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(165; "Incoming Document Entry No."; Integer)
        {
            Caption = 'Incoming Document Entry No.';
            DataClassification = ToBeClassified;
            TableRelation = "Incoming Document";

            trigger OnValidate()
            var
                IncomingDocument: Record "Incoming Document";
            begin
            end;
        }
        field(166; "Last Email Sent Time"; DateTime)
        {
            /*  CalcFormula = Max ("O365 Document Sent History"."Created Date-Time" WHERE ("Document Type" = FIELD ("Document Type"),
                                                                                       "Document No." = FIELD ("No."),
                                                                                       Posted = CONST (false))); */
            Caption = 'Last Email Sent Time';
            /*       FieldClass = FlowField; */
        }
        field(167; "Last Email Sent Status"; Option)
        {
            /*   CalcFormula = Lookup ("O365 Document Sent History"."Job Last Status" WHERE ("Document Type" = FIELD ("Document Type"),
                                                                                         "Document No." = FIELD ("No."),
                                                                                         Posted = CONST (false),
                                                                                         "Created Date-Time" = FIELD ("Last Email Sent Time"))); */
            Caption = 'Last Email Sent Status';
            /*         FieldClass = FlowField; */
            OptionCaption = 'Not Sent,In Process,Finished,Error';
            OptionMembers = "Not Sent","In Process",Finished,Error;
        }
        field(168; "Sent as Email"; Boolean)
        {
            /* CalcFormula = Exist ("O365 Document Sent History" WHERE ("Document Type" = FIELD ("Document Type"),
                                                                    "Document No." = FIELD ("No."),
                                                                    Posted = CONST (false),
                                                                    "Job Last Status" = CONST (Finished)));
            Caption = 'Sent as Email';
            FieldClass = FlowField; */
        }
        field(169; "Last Email Notif Cleared"; Boolean)
        {
            /*  CalcFormula = Lookup ("O365 Document Sent History".NotificationCleared WHERE ("Document Type" = FIELD ("Document Type"),
                                                                                          "Document No." = FIELD ("No."),
                                                                                          Posted = CONST (false),
                                                                                          "Created Date-Time" = FIELD ("Last Email Sent Time")));
             Caption = 'Last Email Notif Cleared';
             FieldClass = FlowField; */
        }
        field(170; IsTest; Boolean)
        {
            Caption = 'IsTest';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(171; "Sell-to Phone No."; Text[30])
        {
            Caption = 'Sell-to Phone No.';
            DataClassification = ToBeClassified;
            ExtendedDatatype = PhoneNo;

            trigger OnValidate()
            var
                i: Integer;
            begin
            end;
        }
        field(172; "Sell-to E-Mail"; Text[80])
        {
            Caption = 'Email';
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
            end;
        }
        field(175; "Payment Instructions Id"; Integer)
        {
            Caption = 'Payment Instructions Id';
            DataClassification = ToBeClassified;
            /* TableRelation = "O365 Payment Instructions"; */
        }
        field(200; "Work Description"; BLOB)
        {
            Caption = 'Work Description';
            DataClassification = ToBeClassified;
        }
        field(300; "Amt. Ship. Not Inv. (LCY)"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Shipped Not Invoiced (LCY)" WHERE("Document Type" = FIELD("Document Type"),
                                                                               "Document No." = FIELD("No.")));
            Caption = 'Amount Shipped Not Invoiced ($) Incl. Tax';
            Editable = false;
            FieldClass = FlowField;
        }
        field(301; "Amt. Ship. Not Inv. (LCY) Base"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Shipped Not Inv. (LCY) No VAT" WHERE("Document Type" = FIELD("Document Type"),
                                                                                  "Document No." = FIELD("No.")));
            Caption = 'Amount Shipped Not Invoiced ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(600; "Payment Service Set ID"; Integer)
        {
            Caption = 'Payment Service Set ID';
            DataClassification = ToBeClassified;
        }
        field(1200; "Direct Debit Mandate ID"; Code[35])
        {
            Caption = 'Direct Debit Mandate ID';
            DataClassification = ToBeClassified;
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
            DataClassification = ToBeClassified;
        }
        field(5050; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            DataClassification = ToBeClassified;
            TableRelation = Campaign;
        }
        field(5051; "Sell-to Customer Template Code"; Code[10])
        {
            Caption = 'Sell-to Customer Template Code';
            DataClassification = ToBeClassified;
            /*  TableRelation = "Customer Template";
  */
            trigger OnValidate()
            var
            /*               SellToCustTemplate: Record "Customer Template"; */
            begin
            end;
        }
        field(5052; "Sell-to Contact No."; Code[20])
        {
            Caption = 'Sell-to Contact No.';
            DataClassification = ToBeClassified;
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
            begin
            end;
        }
        field(5053; "Bill-to Contact No."; Code[20])
        {
            Caption = 'Bill-to Contact No.';
            DataClassification = ToBeClassified;
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
                IsHandled: Boolean;
            begin
            end;
        }
        field(5054; "Bill-to Customer Template Code"; Code[10])
        {
            Caption = 'Bill-to Customer Template Code';
            DataClassification = ToBeClassified;
            /*      TableRelation = "Customer Template"; */

            trigger OnValidate()
            var
            /*       BillToCustTemplate: Record "Customer Template"; */
            begin
            end;
        }
        field(5055; "Opportunity No."; Code[20])
        {
            Caption = 'Opportunity No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Document Type" = FILTER(<> Order)) Opportunity."No." WHERE("Contact No." = FIELD("Sell-to Contact No."),
                                                                                          Closed = CONST(false))
            ELSE
            IF ("Document Type" = CONST(Order)) Opportunity."No." WHERE("Contact No." = FIELD("Sell-to Contact No."),
                                                                                                                                                          "Sales Document No." = FIELD("No."),
                                                                                                                                                          "Sales Document Type" = CONST(Order));
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center";
        }
        field(5750; "Shipping Advice"; Option)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Shipping Advice';
            DataClassification = ToBeClassified;
            OptionCaption = 'Partial,Complete';
            OptionMembers = Partial,Complete;
        }
        field(5751; "Shipped Not Invoiced"; Boolean)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
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
            AccessByPermission = TableData Location = R;
            Caption = 'Posting from Whse. Ref.';
            DataClassification = ToBeClassified;
        }
        field(5754; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            Description = '#34448';
            FieldClass = FlowFilter;
            TableRelation = Location WHERE(Inactivo = CONST(false));
        }
        field(5755; Shipped; Boolean)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Exist("Sales Line" WHERE("Document Type" = FIELD("Document Type"),
                                                    "Document No." = FIELD("No."),
                                                    "Qty. Shipped (Base)" = FILTER(<> 0)));
            Caption = 'Shipped';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5756; "Last Shipment Date"; Date)
        {
            CalcFormula = Lookup("Sales Shipment Header"."Shipment Date" WHERE("No." = FIELD("Last Shipping No.")));
            Caption = 'Last Shipment Date';
            FieldClass = FlowField;
        }
        field(5790; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            DataClassification = ToBeClassified;
        }
        field(5791; "Promised Delivery Date"; Date)
        {
            AccessByPermission = TableData "Order Promising Line" = R;
            Caption = 'Promised Delivery Date';
            DataClassification = ToBeClassified;
        }
        field(5792; "Shipping Time"; DateFormula)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Shipping Time';
            DataClassification = ToBeClassified;
        }
        field(5793; "Outbound Whse. Handling Time"; DateFormula)
        {
            AccessByPermission = TableData "Warehouse Shipment Header" = R;
            Caption = 'Outbound Whse. Handling Time';
            DataClassification = ToBeClassified;
        }
        field(5794; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            DataClassification = ToBeClassified;
            TableRelation = "Shipping Agent Services".Code WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"));
        }
        field(5795; "Late Order Shipping"; Boolean)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
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
            DataClassification = ToBeClassified;
        }
        field(5801; "Return Receipt No."; Code[20])
        {
            Caption = 'Return Receipt No.';
            DataClassification = ToBeClassified;
        }
        field(5802; "Return Receipt No. Series"; Code[20])
        {
            Caption = 'Return Receipt No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(5803; "Last Return Receipt No."; Code[20])
        {
            Caption = 'Last Return Receipt No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Return Receipt Header";
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            DataClassification = ToBeClassified;
        }
        field(7200; "Get Shipment Used"; Boolean)
        {
            Caption = 'Get Shipment Used';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8000; Id; Guid)
        {
            Caption = 'Id';
            DataClassification = ToBeClassified;
        }
        field(9000; "Assigned User ID"; Code[50])
        {
            Caption = 'Assigned User ID';
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(10005; "Ship-to UPS Zone"; Code[2])
        {
            Caption = 'Ship-to UPS Zone';
            DataClassification = ToBeClassified;
            Enabled = false;
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
            DataClassification = ToBeClassified;
            Enabled = false;
        }
        field(10018; "STE Transaction ID"; Text[20])
        {
            Caption = 'STE Transaction ID';
            DataClassification = ToBeClassified;
            Editable = false;
            Enabled = false;
        }
        field(12600; "Prepmt. Include Tax"; Boolean)
        {
            Caption = 'Prepmt. Include Tax';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                GLSetup: Record "General Ledger Setup";
            begin
            end;
        }
        field(27000; "CFDI Purpose"; Code[10])
        {
            Caption = 'CFDI Purpose';
            DataClassification = ToBeClassified;
            // TableRelation = "SAT Use Code";
        }
        field(27001; "CFDI Relation"; Code[10])
        {
            Caption = 'CFDI Relation';
            DataClassification = ToBeClassified;
            //  TableRelation = "SAT Relationship Type";
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
        }
        field(50010; "Tipo de Venta"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Invoice,Consignation,Sample,Donations';
            OptionMembers = Factura,Consignacion,Muestras,Donaciones;
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
        }
        field(55014; "Punto de Emision Factura"; Code[3])
        {
            Caption = 'Invoice Issue Point';
            DataClassification = ToBeClassified;
            Description = 'SRI';
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
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
            Description = 'SRI-SANTINAV-1392';
            OptionCaption = 'VAT,ID,Passport';
            OptionMembers = RUC,Cedula,Pasaporte;
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
            TableRelation = Contact WHERE(Type = FILTER(Company));
        }
        field(56007; "Nombre Colegio"; Text[60])
        {
            Caption = 'School Name';
            DataClassification = ToBeClassified;
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
            end;
        }
        field(76079; "No. Comprobante Fiscal"; Code[19])
        {
            Caption = 'Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';

            trigger OnValidate()
            var
                Texto001: Label 'El campo No. Comprobante fiscal debe contener 9 digitos.';
            begin
            end;
        }
        field(76080; "No. Comprobante Fiscal Rel."; Code[19])
        {
            Caption = 'Rel. Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';

            trigger OnValidate()
            var
                cuLocalizacion: Codeunit "Validaciones Localizacion";
            begin
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
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

