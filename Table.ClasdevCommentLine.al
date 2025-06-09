table 56028 "Clas. dev. Comment Line"
{
    Caption = 'Returns clas. comment Line';
    DrillDownPageID = "Sales Comment List";
    LookupPageID = "Sales Comment List";

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Shipment,Posted Invoice,Posted Credit Memo,Posted Return Receipt';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Shipment,"Posted Invoice","Posted Credit Memo","Posted Return Receipt";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(7; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(10000; "Print On Quote"; Boolean)
        {
            Caption = 'Print On Quote';
        }
        field(10001; "Print On Pick Ticket"; Boolean)
        {
            Caption = 'Print On Pick Ticket';
        }
        field(10002; "Print On Order Confirmation"; Boolean)
        {
            Caption = 'Print On Order Confirmation';
        }
        field(10003; "Print On Shipment"; Boolean)
        {
            Caption = 'Print On Shipment';
        }
        field(10004; "Print On Invoice"; Boolean)
        {
            Caption = 'Print On Invoice';
        }
        field(10005; "Print On Credit Memo"; Boolean)
        {
            Caption = 'Print On Credit Memo';
        }
        field(10006; "Print On Return Authorization"; Boolean)
        {
            Caption = 'Print On Return Authorization';
        }
        field(10007; "Print On Return Receipt"; Boolean)
        {
            Caption = 'Print On Return Receipt';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure SetUpNewLine()
    var
        SalesCommentLine: Record "Sales Comment Line";
    begin
        SalesCommentLine.SetRange("Document Type", "Document Type");
        SalesCommentLine.SetRange("No.", "No.");
        SalesCommentLine.SetRange("Document Line No.", "Document Line No.");
        SalesCommentLine.SetRange(Date, WorkDate);
        if not SalesCommentLine.Find('-') then
            Date := WorkDate;
    end;
}

