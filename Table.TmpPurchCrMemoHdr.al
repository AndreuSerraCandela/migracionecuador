table 80007 "Tmp Purch. Cr. Memo Hdr."
{
    Caption = 'Purch. Cr. Memo Hdr.';
    DataCaptionFields = "No.", "Buy-from Vendor Name";
    LookupPageID = "Posted Purchase Credit Memos";

    fields
    {
        field(2; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(4; "Pay-to Vendor No."; Code[20])
        {
            Caption = 'Pay-to Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;
        }
        field(5; "Pay-to Name"; Text[50])
        {
            Caption = 'Name';
        }
        field(6; "Pay-to Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(7; "Pay-to Address"; Text[50])
        {
            Caption = 'Address';
        }
        field(8; "Pay-to Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(9; "Pay-to City"; Text[60])
        {
            Caption = 'City';
        }
        field(10; "Pay-to Contact"; Text[50])
        {
            Caption = 'Contact';
        }
        field(11; "Your Reference"; Text[30])
        {
            Caption = 'Your Reference';
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
        field(21; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
        }
        field(22; "Posting Description"; Text[50])
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
        field(31; "Vendor Posting Group"; Code[10])
        {
            Caption = 'Vendor Posting Group';
            Editable = false;
            TableRelation = "Vendor Posting Group";
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
        field(35; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';
        }
        field(41; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(43; "Purchaser Code"; Code[10])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = Exist ("Purch. Comment Line" WHERE ("Document Type" = CONST ("Posted Credit Memo"),
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
            CalcFormula = Sum ("Purch. Cr. Memo Line".Amount WHERE ("Document No." = FIELD ("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum ("Purch. Cr. Memo Line"."Amount Including VAT" WHERE ("Document No." = FIELD ("No.")));
            Caption = 'Amount Including Tax';
            Editable = false;
            FieldClass = FlowField;
        }
        field(69; "Vendor Cr. Memo No."; Code[20])
        {
            Caption = 'Vendor Cr. Memo No.';
        }
        field(70; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(72; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
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
        field(79; "Buy-from Vendor Name"; Text[50])
        {
            Caption = 'Buy-from Vendor Name';
        }
        field(80; "Buy-from Vendor Name 2"; Text[50])
        {
            Caption = 'Buy-from Vendor Name 2';
        }
        field(81; "Buy-from Address"; Text[50])
        {
            Caption = 'Buy-from Address';
        }
        field(82; "Buy-from Address 2"; Text[50])
        {
            Caption = 'Buy-from Address 2';
        }
        field(83; "Buy-from City"; Text[60])
        {
            Caption = 'Buy-from City';
        }
        field(84; "Buy-from Contact"; Text[50])
        {
            Caption = 'Buy-from Contact';
        }
        field(85; "Pay-to Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(86; "Pay-to County"; Text[30])
        {
            Caption = 'State';
        }
        field(87; "Pay-to Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(88; "Buy-from Post Code"; Code[20])
        {
            Caption = 'Buy-from ZIP Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(89; "Buy-from County"; Text[30])
        {
            Caption = 'Buy-from State';
        }
        field(90; "Buy-from Country/Region Code"; Code[10])
        {
            Caption = 'Buy-from Country/Region Code';
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
        field(95; "Order Address Code"; Code[10])
        {
            Caption = 'Order Address Code';
            TableRelation = "Order Address".Code WHERE ("Vendor No." = FIELD ("Buy-from Vendor No."));
        }
        field(97; "Entry Point"; Code[10])
        {
            Caption = 'Entry Point';
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
        field(138; "Prepmt. Cr. Memo No. Series"; Code[10])
        {
            Caption = 'Prepmt. Cr. Memo No. Series';
            TableRelation = "No. Series";
        }
        field(140; "Prepayment Credit Memo"; Boolean)
        {
            Caption = 'Prepayment Credit Memo';
        }
        field(141; "Prepayment Order No."; Code[20])
        {
            Caption = 'Prepayment Order No.';
        }
        field(5050; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
        }
        field(5052; "Buy-from Contact No."; Code[20])
        {
            Caption = 'Buy-from Contact No.';
            TableRelation = Contact;
        }
        field(5053; "Pay-to Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
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
        field(10005; "Ship-to UPS Zone"; Code[2])
        {
            Caption = 'Ship-to UPS Zone';
        }
        field(10015; "Tax Exemption No."; Text[30])
        {
            Caption = 'Tax Exemption No.';
        }
        field(10017; "Provincial Tax Area Code"; Code[20])
        {
            Caption = 'Provincial Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(10018; "STE Transaction ID"; Text[20])
        {
            Caption = 'STE Transaction ID';
            Editable = false;
        }
        field(10020; "1099 Code"; Code[10])
        {
            Caption = '1099 Code';
            //TableRelation = "IRS 1099 Form-Box";
        }
        field(76041; "Tipo Retencion"; Option)
        {
            Caption = 'Retention type';
            Description = ',Productos,Servicios   (AMS-RETENCION1.0)';
            OptionCaption = ',Item,Service';
            OptionMembers = ,Productos,Servicios;
        }
        field(76079; "No. Comprobante Fiscal"; Code[19])
        {
            Caption = 'No. Comprobante Fiscal';

            trigger OnValidate()
            var
                rVendorPostingGr: Record "Vendor Posting Group";
            begin
            end;
        }
        field(76080; "No. Comprobante Fiscal Rel."; Code[19])
        {
            Caption = 'No. Comprobante Fiscal Rel.';
        }
        field(76056; "Correccion Doc. NCF"; Boolean)
        {
        }
        field(76057; "No. Serie NCF Abonos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(76058; "Cod. Clasificacion Gasto"; Code[2])
        {
            TableRelation = "Clasificacion Gastos";
        }
        field(99008500; "Date Received"; Date)
        {
            Caption = 'Date Received';
        }
        field(99008501; "Time Received"; Time)
        {
            Caption = 'Time Received';
        }
        field(99008508; "BizTalk Purchase Credit Memo"; Boolean)
        {
            Caption = 'BizTalk Purchase Credit Memo';
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
        key(Key3; "Vendor Cr. Memo No.", "Posting Date")
        {
        }
        key(Key4; "Return Order No.")
        {
        }
        key(Key5; "Buy-from Vendor No.")
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
        fieldgroup(DropDown; "No.", "Buy-from Vendor No.", "Pay-to Vendor No.", "Posting Date", "Posting Description")
        {
        }
    }

    trigger OnDelete()
    begin
        LockTable;
    end;

    var
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchCommentLine: Record "Purch. Comment Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        PostCode: Record "Post Code";
        PostPurchLinesDelete: Codeunit "PostPurch-Delete";
        DimMgt: Codeunit DimensionManagement;
        ApprovalsMgt: Codeunit "Approvals Mgmt.";
}

