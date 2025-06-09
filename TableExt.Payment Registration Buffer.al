tableextension 50176 tableextension50176 extends "Payment Registration Buffer"
{
    fields
    {
        modify(Name)
        {
            Description = '#56924';
        }
    }

    //Unsupported feature: Code Modification on "PopulateTable(PROCEDURE 1)".

    //procedure PopulateTable();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    PaymentRegistrationSetup.Get(UserId);
    PaymentRegistrationSetup.TestField("Bal. Account No.");

    #4..22
          "Original Remaining Amount" := CustLedgerEntry."Remaining Amount";
          "Pmt. Discount Date" := CustLedgerEntry."Pmt. Discount Date";
          "Rem. Amt. after Discount" := "Remaining Amount" - CustLedgerEntry."Remaining Pmt. Disc. Possible";
          if CustLedgerEntry."Payment Method Code" <> '' then
            "Payment Method Code" := CustLedgerEntry."Payment Method Code"
          else
            "Payment Method Code" := GetO365DefalutPaymentMethodCode;
          "Bal. Account Type" := PaymentRegistrationSetup."Bal. Account Type";
          "Bal. Account No." := PaymentRegistrationSetup."Bal. Account No.";
          Insert;
        end;
      until CustLedgerEntry.Next = 0;
    end;

    if FindSet then;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..25
          "Payment Method Code" := GetO365DefalutPaymentMethodCode;
    #30..37
    */
    //end;
}

