table 80010 "Tmp Posted Deposit Line"
{
    Caption = 'Posted Deposit Line';
    //ookupPageID = "Posted Deposit Lines";

    fields
    {
        field(1; "Deposit No."; Code[20])
        {
            Caption = 'Deposit No.';
            //  TableRelation = "Posted Deposit Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Account Type"; Option)
        {
            Caption = 'Account Type';
            InitValue = Customer;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account",,"IC Partner";
        }
        field(4; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(6; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,,,,,Refund';
            OptionMembers = " ",Payment,,,,,Refund;
        }
        field(7; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(8; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(9; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(10; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            MinValue = 0;
        }
        field(11; "Posting Group"; Code[10])
        {
            Caption = 'Posting Group';
            Editable = false;
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Posting Group"
            ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Posting Group";
        }
        field(12; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(13; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(14; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(15; "Bank Account Ledger Entry No."; Integer)
        {
            Caption = 'Bank Account Ledger Entry No.';
            TableRelation = "Bank Account Ledger Entry";
        }
        field(16; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Entry"
            ELSE
            IF ("Account Type" = CONST(Customer)) "Cust. Ledger Entry"
            ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Ledger Entry"
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account Ledger Entry";
        }
    }

    keys
    {
        key(Key1; "Deposit No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
        key(Key2; "Account Type", "Account No.")
        {
        }
        key(Key3; "Document No.", "Posting Date")
        {
        }
        key(Key4; "Bank Account Ledger Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

