table 80003 "Tmp Sales Cr.Memo Header"
{
    // DSLoc1.01   GRN     13/08/2011    Para imprimir formatos de facturas segun Gpo. Contable

    Caption = 'Sales Cr.Memo Header';
    DataCaptionFields = "No.", "Sell-to Customer Name";
    LookupPageID = "Posted Sales Credit Memos";

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
            TableRelation = "Ship-to Address".Code WHERE ("Customer No." = FIELD ("Sell-to Customer No."));
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
            TableRelation = Location WHERE ("Use As In-Transit" = CONST (false));
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2));
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
            TableRelation = "Salesperson/Purchaser";
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = Exist ("Sales Comment Line" WHERE ("Document Type" = CONST ("Posted Credit Memo"),
                                                            "No." = FIELD ("No."),
                                                            "Document Line No." = CONST (0)));
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
            TableRelation = IF ("Bal. Account Type" = CONST ("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST ("Bank Account")) "Bank Account";
        }
        field(60; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum ("Sales Cr.Memo Line".Amount WHERE ("Document No." = FIELD ("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum ("Sales Cr.Memo Line"."Amount Including VAT" WHERE ("Document No." = FIELD ("No.")));
            Caption = 'Amount Including Tax';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "VAT Registration No."; Text[20])
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
        field(111; "Pre-Assigned No."; Code[20])
        {
            Caption = 'Pre-Assigned No.';
        }
        field(112; "User ID"; Code[50])
        {
            Caption = 'User ID';
            //TableRelation = Table2000000002;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserRec: Record User;
            begin
                if Page.RunModal(Page::"User Lookup", UserRec) = Action::LookupOK then
                    "User ID" := UserRec."User Name";
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
        field(134; "Prepmt. Cr. Memo No. Series"; Code[10])
        {
            Caption = 'Prepmt. Cr. Memo No. Series';
            TableRelation = "No. Series";
        }
        field(136; "Prepayment Credit Memo"; Boolean)
        {
            Caption = 'Prepayment Credit Memo';
        }
        field(137; "Prepayment Order No."; Code[20])
        {
            Caption = 'Prepayment Order No.';
        }
        field(827; "Credit Card No."; Code[20])
        {
            Caption = 'Credit Card No.';
            //TableRelation = Table827 WHERE (Field6 = FIELD ("Bill-to Customer No."));
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
        field(6601; "Return Order No."; Code[20])
        {
            Caption = 'Return Order No.';
        }
        field(6602; "Return Order No. Series"; Code[10])
        {
            Caption = 'Return Order No. Series';
            TableRelation = "No. Series";
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
        }
        field(7200; "Get Return Receipt Used"; Boolean)
        {
            Caption = 'Get Return Receipt Used';
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
        field(56006; "Cod. Colegio"; Code[20])
        {
            Caption = 'School Code';
            TableRelation = Contact WHERE (Type = FILTER (Company));
        }
        field(56007; "Nombre Colegio"; Text[120])
        {
            Caption = 'School Name';
        }
        field(56008; "Re facturacion"; Boolean)
        {
        }
        field(76041; "No. Serie NCF Abonos2"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(76079; "No. Comprobante Fiscal"; Code[19])
        {
        }
        field(76080; "No. Comprobante Fiscal Rel."; Code[19])
        {
        }
        field(76056; "Razon anulacion NCF"; Code[20])
        {
            TableRelation = "Razones Anulacion NCF";
        }
        field(76057; "No. Serie NCF Abonos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(99008509; "Date Sent"; Date)
        {
            Caption = 'Date Sent';
        }
        field(99008510; "Time Sent"; Time)
        {
            Caption = 'Time Sent';
        }
        field(99008517; "BizTalk Sales Credit Memo"; Boolean)
        {
            Caption = 'BizTalk Sales Credit Memo';
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
        key(Key2; "Pre-Assigned No.")
        {
        }
        key(Key3; "Sell-to Customer No.", "External Document No.")
        {
        }
        key(Key4; "Return Order No.")
        {
        }
        key(Key5; "Sell-to Customer No.", "No.")
        {
        }
        key(Key6; "Prepayment Order No.")
        {
        }
        key(Key7; "No. Comprobante Fiscal")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Posting Date", "Posting Description")
        {
        }
    }

    trigger OnDelete()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
    end;

    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCommentLine: Record "Sales Comment Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        PostCode: Record "Post Code";
        PostSalesLinesDelete: Codeunit "PostSales-Delete";
        ApprovalsMgt: Codeunit "Approvals Mgmt.";
        "*** DSLoc ***": Integer;
        ConfSantillana: Record "Config. Empresa";
        Localizacion: Record "Parametros Loc. x País";
        GpoContableCte: Record "Customer Posting Group";
}

