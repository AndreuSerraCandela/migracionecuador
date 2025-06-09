table 80009 "Tmp Posted Deposit Header"
{
    Caption = 'Posted Deposit Header';
    DataCaptionFields = "No.";
    //LookupPageID = "Posted Deposit List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            TableRelation = "Bank Account";
        }
        field(3; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(4; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Total Deposit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Total Deposit Amount';
        }
        field(7; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(8; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(9; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(10; "Bank Acc. Posting Group"; Code[10])
        {
            Caption = 'Bank Acc. Posting Group';
            TableRelation = "Bank Account Posting Group";
        }
        field(11; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(12; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(13; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(14; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(15; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(16; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
        }
        // field(21; Comment; Boolean)
        // {
        //     CalcFormula = Exist ("Bank Comment Line" WHERE ("Table Name" = CONST ("Posted Deposit"),
        //                                                    "Bank Account No." = FIELD ("Bank Account No."),
        //                                                    "No." = FIELD ("No.")));
        //     Caption = 'Comment';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(22; "Total Deposit Lines"; Decimal)
        // {
        //     AutoFormatExpression = "Currency Code";
        //     AutoFormatType = 1;
        //     CalcFormula = Sum ("Posted Deposit Line".Amount WHERE ("Deposit No." = FIELD ("No.")));
        //     Caption = 'Total Deposit Lines';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Bank Account No.")
        {
        }
    }

    fieldgroups
    {
    }

    // var
    //     BankCommentLine: Record "Bank Comment Line";
    //     PostedDepositDelete: Codeunit "Posted Deposit-Delete";
}

