table 50040 TmpGUASalesBook
{
    // YYYYMMDD Version        Sign Proj.Ref. Description
    // -------------------------------------------------------------------------
    // 20090709 COL5.0.001     JPA  950       Temporary table to be loaded with information for the sales book.


    fields
    {
        field(1; Date; Date)
        {
            Caption = 'Date';
            Description = 'COL5.0.001';
        }
        field(2; FromNo; Code[20])
        {
            Caption = 'From No.';
            Description = 'COL5.0.001';
            TableRelation = "Sales Header"."No.";
        }
        field(4; "Total Sales"; Decimal)
        {
            Caption = 'Total Sales';
            Description = 'COL5.0.001';
        }
        field(6; "Total service"; Decimal)
        {
            Caption = 'Total Service';
            Description = 'COL5.0.001';
        }
        field(8; VAT; Decimal)
        {
            Caption = 'VAT';
            Description = 'COL5.0.001';
        }
        field(9; "Total invoice"; Decimal)
        {
            Caption = 'Total invoice';
            Description = 'COL5.0.001';
        }
        field(10; GoodsExent; Decimal)
        {
            Caption = 'Export';
            Description = 'COL5.0.001';
        }
        field(11; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Description = 'COL5.0.001';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(12; Customer; Text[50])
        {
            Caption = 'Customer';
            Description = 'COL5.0.001';
        }
        field(13; Identification; Text[20])
        {
            Caption = 'Identification';
            Description = 'COL5.0.001';
        }
        field(14; ServicesExent; Decimal)
        {
            Caption = 'Exent Services';
            Description = 'COL5.0.001';
        }
        field(15; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'Tax Bus. Posting Group';
            Description = 'COL5.0.001';
        }
        field(16; No; Integer)
        {
            Caption = 'No.';
            Description = 'COL5.0.001';
        }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
        key(Key2; Date)
        {
        }
    }

    fieldgroups
    {
    }
}

