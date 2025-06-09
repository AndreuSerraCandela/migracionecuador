tableextension 50056 tableextension50056 extends "Sales & Receivables Setup"
{
    fields
    {
        modify("Posted Credit Memo Nos.")
        {
            Caption = 'Posted Credit Memo Nos.';
        }
        modify("Issued Fin. Chrg. M. Nos.")
        {
            Caption = 'Issued Fin. Chrg. M. Nos.';
        }
        modify("Posted Prepmt. Inv. Nos.")
        {
            Caption = 'Posted Prepmt. Inv. Nos.';
        }
        modify("Posted Prepmt. Cr. Memo Nos.")
        {
            Caption = 'Posted Prepmt. Cr. Memo Nos.';
        }
        modify("Copy Comments Blanket to Order")
        {
            Caption = 'Copy Comments Blanket to Order';
        }
        modify("Copy Comments Order to Invoice")
        {
            Caption = 'Copy Comments Order to Invoice';
        }
        modify("Copy Comments Order to Shpt.")
        {
            Caption = 'Copy Comments Order to Shpt.';
        }
        modify("Calc. Inv. Disc. per VAT ID")
        {
            Caption = 'Calc. Inv. Disc. per Tax ID';
        }
        modify("Logo Position on Documents")
        {
            Caption = 'Logo Position on Documents';
        }
        modify("Check Prepmt. when Posting")
        {
            Caption = 'Check Prepmt. when Posting';
        }
        modify("VAT Bus. Posting Gr. (Price)")
        {
            Caption = 'Tax Bus. Posting Gr. (Price)';
        }
        modify("Direct Debit Mandate Nos.")
        {
            Caption = 'Direct Debit Mandate Nos.';
        }
        modify("Create Item from Description")
        {
            Caption = 'Create Item from Description';
        }
        modify("Posted Return Receipt Nos.")
        {
            Caption = 'Posted Return Receipt Nos.';
        }
        modify("Copy Cmts Ret.Ord. to Ret.Rcpt")
        {
            Caption = 'Copy Cmts Ret.Ord. to Ret.Rcpt';
        }
        modify("Copy Cmts Ret.Ord. to Cr. Memo")
        {
            Caption = 'Copy Cmts Ret.Ord. to Cr. Memo';
        }
        modify("Return Receipt on Credit Memo")
        {
            Caption = 'Return Receipt on Credit Memo';
        }
        modify("Exact Cost Reversing Mandatory")
        {
            Caption = 'Exact Cost Reversing Mandatory';
        }
        field(50000; "Pre Order Nos."; Code[10])
        {
            Caption = 'Pre Order Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50002; "No. Serie Pedidos Consignacion"; Code[20])
        {
            Caption = 'Consignment Series No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50003; "No. Serie Ident. Devolucion"; Code[20])
        {
            Caption = 'Return Identifier Series Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50004; "No. Serie Ident. Dev. Reg."; Code[20])
        {
            Caption = 'Posted Return Identifier Series Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50005; "No. Serie Hoja de Ruta"; Code[20])
        {
            Caption = 'Route Sheet Series No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50006; "No. Serie Hoja de Ruta Reg."; Code[20])
        {
            Caption = 'Posted Route Sheet Series No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}

