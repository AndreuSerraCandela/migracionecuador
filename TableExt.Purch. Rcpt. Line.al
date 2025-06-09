tableextension 50013 tableextension50013 extends "Purch. Rcpt. Line"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 12)".

        modify("Item Rcpt. Entry No.")
        {
            Caption = 'Item Rcpt. Entry No.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Qty. Rcd. Not Invoiced")
        {
            Caption = 'Qty. Rcd. Not Invoiced';
        }
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("Attached to Line No.")
        {
            Caption = 'Attached to Line No.';
        }
        modify("Area")
        {
            Caption = 'Area';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
        modify("VAT Prod. Posting Group")
        {
            Caption = 'VAT Prod. Posting Group';
        }
        modify("Job Line Discount Amount")
        {
            Caption = 'Job Line Discount Amount';
        }
        modify("Job Unit Price (LCY)")
        {
            Caption = 'Job Unit Price ($)';
        }
        modify("Job Total Price (LCY)")
        {
            Caption = 'Job Total Price ($)';
        }
        modify("Job Line Amount (LCY)")
        {
            Caption = 'Job Line Amount ($)';
        }
        modify("Job Line Disc. Amount (LCY)")
        {
            Caption = 'Job Line Disc. Amount ($)';
        }
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        modify("Depr. until FA Posting Date")
        {
            Caption = 'Depr. until FA Posting Date';
        }
        modify("Duplicate in Depreciation Book")
        {
            Caption = 'Duplicate in Depreciation Book';
        }
        field(55012; "Parte del IVA"; Boolean)
        {
            Caption = 'VAT part';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55013; Propina; Boolean)
        {
            Caption = 'Tips';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
    }

    keys
    {
        key(KeyReports; "No.")
        {
        }
    }

    //Unsupported feature: Variable Insertion (Variable: PurchSetup) (VariableCollection) on "InsertInvLineFromRcptLine(PROCEDURE 2)".



    //Unsupported feature: Code Modification on "InsertInvLineFromRcptLine(PROCEDURE 2)".

    //procedure InsertInvLineFromRcptLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetRange("Document No.","Document No.");

    TempPurchLine := PurchLine;
    #4..90
      OnAfterCopyFromPurchRcptLine(PurchLine,Rec);
      if not ExtTextLine then begin
        PurchLine.Validate(Quantity,Quantity - "Quantity Invoiced");
        CalcBaseQuantities(PurchLine,"Quantity (Base)" / Quantity);

        OnInsertInvLineFromRcptLineOnAfterCalcQuantities(PurchLine,PurchOrderLine);

    #98..148
      if "Attached to Line No." = 0 then
        SetRange("Attached to Line No.","Line No.");
    until (Next = 0) or ("Attached to Line No." = 0);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..93
    #95..151
    */
    //end;
}

