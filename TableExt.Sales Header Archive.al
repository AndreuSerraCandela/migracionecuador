tableextension 50092 tableextension50092 extends "Sales Header Archive"
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

        //Unsupported feature: Property Modification (Data type) on ""VAT Registration No."(Field 70)".

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
        modify("Prepmt. Pmt. Discount Date")
        {
            Caption = 'Prepmt. Pmt. Discount Date';
        }
        field(76041; "No. Serie NCF Facturas"; Code[10])
        {
            Caption = 'NCF Invoice Series No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
            TableRelation = "No. Series" WHERE ("Descripcion NCF" = FILTER (<> ''));
        }
        field(76079; "No. Comprobante Fiscal"; Code[19])
        {
            Caption = 'Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
        }
        field(76080; "No. Comprobante Fiscal Rel."; Code[19])
        {
            Caption = 'Rel. Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
        }
        field(76056; "Razon anulacion NCF"; Code[20])
        {
            Caption = 'NCF Void Reason';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
            TableRelation = "Razones Anulacion NCF";
        }
        field(76057; "No. Serie NCF Abonos"; Code[10])
        {
            Caption = 'No. Serie NCF Abonos';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
            TableRelation = "No. Series";
        }
        field(76078; "Cod. Clasificacion Gasto"; Code[2])
        {
            Caption = 'Expense Clasification Code';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
        }
        field(76007; "Tipo de ingreso"; Code[2])
        {
            Caption = 'Income type';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
            TableRelation = "Tipos de ingresos";
        }
        field(76003; "Fecha vencimiento NCF"; Date)
        {
            Caption = 'NCF Due date';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
            TableRelation = "Tipos de ingresos";
        }
    }
}

