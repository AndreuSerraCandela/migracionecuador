tableextension 50130 tableextension50130 extends "Service Invoice Header"
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

        field(76041; "No. Serie NCF Facturas"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
            TableRelation = "No. Series";
        }
        field(76079; "No. Comprobante Fiscal"; Code[19])
        {
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
        }
        field(76058; "Fecha vencimiento NCF"; Date)
        {
            Caption = 'NCF Due date';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
        }
        field(76007; "Tipo de ingreso"; Code[2])
        {
            Caption = 'Income type';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
            InitValue = '02';
            TableRelation = "Tipos de ingresos";
        }
    }
}

