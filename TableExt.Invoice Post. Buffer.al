tableextension 50088 tableextension50088 extends "Invoice Posting Buffer"
{
    fields
    {
        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
        modify("VAT Prod. Posting Group")
        {
            Caption = 'VAT Prod. Posting Group';
        }
        modify("Depr. until FA Posting Date")
        {
            Caption = 'Depr. until FA Posting Date';
        }
        modify("Duplicate in Depreciation Book")
        {
            Caption = 'Duplicate in Depreciation Book';
        }
        field(76014; "Cod. Colegio"; Code[20])
        {
            Caption = 'School Code';
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = Contact WHERE(Type = FILTER(Company));
        }
        field(76422; "Cod. Vendedor"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = "Salesperson/Purchaser";
        }
    }


    //Unsupported feature: Code Modification on "AdjustRoundingForUpdate(PROCEDURE 20)".

    //procedure AdjustRoundingForUpdate();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    AdjustRoundingFieldsPair(TempInvoicePostBufferRounding.Amount,Amount,"Amount (ACY)");
    AdjustRoundingFieldsPair(TempInvoicePostBufferRounding."VAT Amount","VAT Amount","VAT Amount (ACY)");
    AdjustRoundingFieldsPair(TempInvoicePostBufferRounding."VAT Base Amount","VAT Base Amount","VAT Base Amount (ACY)");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    AdjustRoundingFieldsPair(Amount,"Amount (ACY)");
    AdjustRoundingFieldsPair("VAT Amount","VAT Amount (ACY)");
    AdjustRoundingFieldsPair("VAT Base Amount","VAT Base Amount (ACY)");
    */
    //end;


    //Unsupported feature: Code Modification on "AdjustRoundingFieldsPair(PROCEDURE 21)".

    //procedure AdjustRoundingFieldsPair();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if (AmountLCY <> 0) and (AmountFCY = 0) then begin
      TotalRoundingAmount += AmountLCY;
      AmountLCY := 0;
    end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    if (Value1 = 0) and (Value2 <> 0) then
      Value2 := 0;
    if (Value1 <> 0) and (Value2 = 0) then
      Value1 := 0;
    */
    //end;

    //Unsupported feature: Deletion (ParameterCollection) on "AdjustRoundingFieldsPair(PROCEDURE 21).TotalRoundingAmount(Parameter 1002)".


    //Unsupported feature: Property Modification (Name) on "AdjustRoundingFieldsPair(PROCEDURE 21).AmountLCY(Parameter 1000)".


    //Unsupported feature: Property Modification (Name) on "AdjustRoundingFieldsPair(PROCEDURE 21).AmountFCY(Parameter 1001)".


    //Unsupported feature: Property Insertion (AsVar) on "AdjustRoundingFieldsPair(PROCEDURE 21).AmountFCY(Parameter 1001)".

}

