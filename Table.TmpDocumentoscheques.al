table 80012 "Tmp Documentos cheques"
{
    Caption = 'Check Ledger Entry';
    DrillDownPageID = "Check Ledger Entries";
    LookupPageID = "Check Ledger Entries";

    fields
    {
        field(1; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            TableRelation = "Bank Account";
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(3; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(5; Description; Text[60])
        {
            Caption = 'Description';
        }
        field(6; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(7; "Check Date"; Date)
        {
            Caption = 'Check Date';
        }
        field(8; "Check No."; Code[20])
        {
            Caption = 'Check No.';
        }
        field(9; Beneficiario; Text[250])
        {
            Caption = 'Beneficiary';
        }
        field(10; "Vendor Ledger Entry No."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Bank Account No.", "Document No.", "Posting Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

