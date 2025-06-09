tableextension 50038 tableextension50038 extends "VAT Entry"
{
    fields
    {
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("Closed by Entry No.")
        {
            Caption = 'Closed by Entry No.';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
        modify("VAT Prod. Posting Group")
        {
            Caption = 'VAT Prod. Posting Group';
        }

        //Unsupported feature: Property Modification (Data type) on ""VAT Registration No."(Field 55)".

        modify("Reversed by Entry No.")
        {
            Caption = 'Reversed by Entry No.';
        }

        //Unsupported feature: Deletion (FieldCollection) on ""G/L Acc. No."(Field 85)".

    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on ""Type,Closed,""VAT Bus. Posting Group"",""VAT Prod. Posting Group"",""Posting Date"",""G/L Acc. No."",""Tax Jurisdiction Code"",""Use Tax"""(Key)".


        //Unsupported feature: Deletion (KeyCollection) on ""Type,Closed,""VAT Bus. Posting Group"",""VAT Prod. Posting Group"",""Tax Jurisdiction Code"",""Use Tax"",""Posting Date"",""G/L Acc. No."""(Key)".


        //Unsupported feature: Deletion (KeyCollection) on ""Posting Date",Type,Closed,"VAT Bus. Posting Group","VAT Prod. Posting Group",Reversed,"G/L Acc. No."(Key)".


        //Unsupported feature: Deletion (KeyCollection) on ""G/L Acc. No."(Key)".

        /*  key(Key13; Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Posting Date", "Tax Jurisdiction Code", "Use Tax")
         {
             SumIndexFields = Base, Amount, "Additional-Currency Base", "Additional-Currency Amount", "Remaining Unrealized Amount", "Remaining Unrealized Base", "Add.-Curr. Rem. Unreal. Amount", "Add.-Curr. Rem. Unreal. Base";
         } */
        // key(Key14; Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Tax Jurisdiction Code", "Use Tax", "Posting Date")
        // {
        //     SumIndexFields = Base, Amount, "Unrealized Amount", "Unrealized Base", "Additional-Currency Base", "Additional-Currency Amount", "Add.-Currency Unrealized Amt.", "Add.-Currency Unrealized Base", "Remaining Unrealized Amount";
        // }
        // key(Key15; "Posting Date", Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group", Reversed)
        // {
        //     SumIndexFields = Base, Amount, "Unrealized Amount", "Unrealized Base", "Additional-Currency Base", "Additional-Currency Amount", "Add.-Currency Unrealized Amt.", "Add.-Currency Unrealized Base", "Remaining Unrealized Amount";
        // }
    }
}

