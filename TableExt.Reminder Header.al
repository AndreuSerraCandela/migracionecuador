tableextension 50049 tableextension50049 extends "Reminder Header"
{
    fields
    {
        modify(Name)
        {
            Description = '#56924';
        }
        modify("Your Reference")
        {
            Caption = 'Customer PO No.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Fin. Charge Terms Code")
        {
            Caption = 'Fin. Charge Terms Code';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
    }

    //Unsupported feature: Code Modification on "GetInvoiceRoundingAmount(PROCEDURE 33)".

    //procedure GetInvoiceRoundingAmount();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GetCurrency;
    if Currency."Invoice Rounding Precision" = 0 then
      exit(0);

    #5..15
          Currency."Invoice Rounding Precision",
          Currency.InvoiceRoundingDirection),
        Currency."Amount Rounding Precision"));
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    GetCurrency(ReminderHeader);
    #2..18
    */
    //end;

    //Unsupported feature: Parameter Insertion (Parameter: ReminderHeader) (ParameterCollection) on "GetCurrency(PROCEDURE 17)".



    //Unsupported feature: Code Modification on "GetCurrency(PROCEDURE 17)".

    //procedure GetCurrency();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if "Currency Code" = '' then
      Currency.InitRoundingPrecision
    else begin
      Currency.Get("Currency Code");
      Currency.TestField("Amount Rounding Precision");
    end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    with ReminderHeader do
      if "Currency Code" = '' then
        Currency.InitRoundingPrecision
      else begin
        Currency.Get("Currency Code");
        Currency.TestField("Amount Rounding Precision");
      end;
    */
    //end;

}

