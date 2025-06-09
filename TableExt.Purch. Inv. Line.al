tableextension 50015 tableextension50015 extends "Purch. Inv. Line"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 12)".

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
        modify("IC Partner Ref. Type")
        {
            Caption = 'IC Partner Ref. Type';
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
        field(55001; "Punto de Emision Reembolso"; Code[3])
        {
            Caption = 'Punto de Emisión Reembolso';
            DataClassification = ToBeClassified;
            Description = '#14564';
        }
        field(55002; "Establecimiento Reembolso"; Code[3])
        {
            Caption = 'Establecimiento Reembolso';
            DataClassification = ToBeClassified;
            Description = '#14564';
        }
        field(55003; "No. Comprobante Reembolso"; Code[30])
        {
            Caption = 'Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = '#14564';
        }
        field(55004; "No. Autorizacion Reembolso"; Code[37])
        {
            Caption = 'Nº Autorización Reembolso';
            DataClassification = ToBeClassified;
            Description = '#14564';
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
    keys
    {
        key(Key8; "Posting Date", Type, "FA Posting Type")
        {
        }
        key(Key9; Type, "No.", "Posting Date")
        {
        }
    }
}

