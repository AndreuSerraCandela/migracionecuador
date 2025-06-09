tableextension 50131 tableextension50131 extends "Service Cr.Memo Header"
{
    fields
    {
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
        modify("Area")
        {
            Caption = 'Area';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
        // modify("No. of E-Documents Sent")
        // {
        //     Caption = 'No. of E-Documents Sent';
        // }
        // modify("PAC Web Service Name")
        // {
        //     Caption = 'PAC Web Service Name';
        // }
        // modify("Fiscal Invoice Number PAC")
        // {
        //     Caption = 'Fiscal Invoice Number PAC';
        // }
        // modify("Date/Time First Req. Sent")
        // {
        //     Caption = 'Date/Time First Req. Sent';
        // }

        //Unsupported feature: Deletion (FieldCollection) on ""CFDI Cancellation Reason Code"(Field 27002)".


        //Unsupported feature: Deletion (FieldCollection) on ""Substitution Document No."(Field 27003)".


        //Unsupported feature: Deletion (FieldCollection) on ""CFDI Export Code"(Field 27004)".

        field(76041; "No. Serie NCF Abonos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(76079; "No. Comprobante Fiscal"; Code[19])
        {
            DataClassification = ToBeClassified;
        }
        field(76080; "No. Comprobante Fiscal Rel."; Code[19])
        {
            DataClassification = ToBeClassified;
        }
        field(76056; "Razon anulacion NCF"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}

