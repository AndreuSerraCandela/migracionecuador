tableextension 50174 tableextension50174 extends "Vendor Posting Group"
{
    fields
    {
        modify("Payment Disc. Debit Acc.")
        {
            Caption = 'Payment Disc. Debit Acc.';
        }
        field(76080; "Permite Emitir NCF"; Boolean)
        {
            Caption = 'Allow to Issue NCF';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';

            trigger OnValidate()
            begin
                if "Permite Emitir NCF" then
                    "NCF Obligatorio" := false;
            end;
        }
        field(76056; "NCF Obligatorio"; Boolean)
        {
            Caption = 'NCF Mandatory';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';

            trigger OnValidate()
            begin
                if "NCF Obligatorio" then
                    "Permite Emitir NCF" := false;
            end;
        }
        field(76057; "No. Serie NCF Factura Compra"; Code[20])
        {
            Caption = 'Purch. Inv. NCF Serial No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
            TableRelation = "No. Series";
        }
        field(76078; "No. Serie NCF Abonos Compra"; Code[20])
        {
            Caption = 'Purch. Credit memo NCF Serial No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
            TableRelation = "No. Series";
        }
        field(76058; Internacional; Boolean)
        {
            Caption = 'International';
            DataClassification = ToBeClassified;
        }
    }


    //Unsupported feature: Code Modification on "GetInvRoundingAccount(PROCEDURE 9)".

    //procedure GetInvRoundingAccount();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if "Invoice Rounding Account" <> '' then begin
      GLAccount.Get("Invoice Rounding Account");
      GLAccount.CheckGenProdPostingGroup;
    end else
      PostingSetupMgt.SendVendPostingGroupNotification(Rec,FieldCaption("Invoice Rounding Account"));
    TestField("Invoice Rounding Account");
    exit("Invoice Rounding Account");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    if "Invoice Rounding Account" = '' then
    #5..7
    */
    //end;

    //Unsupported feature: Deletion (VariableCollection) on "GetInvRoundingAccount(PROCEDURE 9).GLAccount(Variable 1000)".

}

