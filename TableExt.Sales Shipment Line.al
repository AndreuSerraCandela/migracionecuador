tableextension 50006 tableextension50006 extends "Sales Shipment Line"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 12)".

        modify("Item Shpt. Entry No.")
        {
            Caption = 'Item Shpt. Entry No.';
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
        modify("Job Contract Entry No.")
        {
            Caption = 'Job Contract Entry No.';
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

        //Unsupported feature: Deletion (FieldCollection) on ""Custom Transit Number"(Field 10003)".

        field(50014; "Cod. Cupon"; Code[20])
        {
            Caption = 'Coupon Code';
            DataClassification = ToBeClassified;
        }
        field(50015; "No. Linea Cupon"; Integer)
        {
            Caption = 'Coupon Line No.';
            DataClassification = ToBeClassified;
        }
        field(50016; "Cantidad Aprobada"; Decimal)
        {
            Caption = 'Approved Qty.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
            begin
            end;
        }
        field(50017; "Cantidad pendiente BO"; Decimal)
        {
            Caption = 'BO Pending Qty.';
            DataClassification = ToBeClassified;
        }
        field(50018; "Cantidad a Anular"; Decimal)
        {
            Caption = 'Qty. to Void';
            DataClassification = ToBeClassified;
        }
        field(50019; "Cantidad Solicitada"; Decimal)
        {
            Caption = 'Requested Qty.';
            DataClassification = ToBeClassified;
        }
        field(50020; Temporal; Boolean)
        {
            Caption = 'Temp';
            DataClassification = ToBeClassified;
        }
        field(50022; "Cantidad Anulada"; Decimal)
        {
            Caption = 'Qty. Canceled';
            DataClassification = ToBeClassified;
        }
        field(50040; "Cantidad a Ajustar"; Decimal)
        {
            Caption = 'Qty. To Adjust';
            DataClassification = ToBeClassified;
        }
        field(50041; "Porcentaje Cant. Aprobada"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Error_L001: Label 'Porcentage must be between 0 and 100';
            begin
            end;
        }
        field(53004; "Cod. Vendedor"; Code[20])
        {
            Caption = 'Salesperson Code';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        field(55012; "Parte del IVA"; Boolean)
        {
            Caption = 'VAT part';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(56001; Disponible; Boolean)
        {
            Caption = 'Available';
            DataClassification = ToBeClassified;
            Description = 'Gestion BackOrder';
        }
    }

    //Unsupported feature: Variable Insertion (Variable: SalesSetup) (VariableCollection) on "InsertInvLineFromShptLine(PROCEDURE 2)".

}

