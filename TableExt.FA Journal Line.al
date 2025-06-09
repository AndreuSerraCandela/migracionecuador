tableextension 50108 tableextension50108 extends "FA Journal Line"
{
    fields
    {
        modify("FA No.")
        {
            TableRelation = "Fixed Asset" WHERE (Inactive = CONST (false));
            Description = '001';
        }
        modify("No. of Depreciation Days")
        {
            Caption = 'No. of Depreciation Days';
        }
        modify("Depr. until FA Posting Date")
        {
            Caption = 'Depr. until FA Posting Date';
        }
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Duplicate in Depreciation Book")
        {
            Caption = 'Duplicate in Depreciation Book';
        }
        modify("FA Error Entry No.")
        {
            Caption = 'FA Error Entry No.';
        }

        //Unsupported feature: Code Modification on "Amount(Field 14).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        Clear(Currency);
        Currency.InitRoundingPrecision;
        Amount := Round(Amount,Currency."Amount Rounding Precision");
        if ((Amount > 0) and (not Correction)) or
           ((Amount < 0) and Correction)
        then begin
        #7..9
          "Debit Amount" := 0;
          "Credit Amount" := -Amount;
        end;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #4..12
        */
        //end;
    }
}

