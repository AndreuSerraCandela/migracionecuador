tableextension 50020 tableextension50020 extends "G/L Account"
{
    fields
    {
        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
        modify("VAT Prod. Posting Group")
        {
            Caption = 'VAT Prod. Posting Group';
        }
        //Quitar OnValidate Gen. Prod. Posting Group y VAT Prod. Posting Group
        //Unsupported feature: Code Modification on ""Gen. Prod. Posting Group"(Field 45).OnValidate".
        field(50001; "Gen. Prod. Posting Group 2"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            var
                GenProdPostingGrp: Record "Gen. Product Posting Group";
            begin
                //Recibe el dato y lo agrega en el campo standar sin realizar la validacion
                Rec."Gen. Prod. Posting Group" := Rec."Gen. Prod. Posting Group 2";
            end;
        }

        //Unsupported feature: Deletion on ""VAT Prod. Posting Group"(Field 58).OnValidate".
        field(50002; "VAT Prod. Posting Group 2"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
            trigger OnValidate()
            begin
                //Recibe el dato y lo agrega en el campo standar sin realizar la validacion
                Rec."VAT Prod. Posting Group" := Rec."VAT Prod. Posting Group 2";
            end;
        }

        field(50000; "VAT Prod. Posting G. TipoITBIS"; Code[20])
        {
            Caption = 'Tax Prod. Posting Group to Cost';
            DataClassification = ToBeClassified;
            Description = 'ITBISCOSTO';
            TableRelation = "VAT Product Posting Group";
        }
        field(76041; "NCF Obligatorio"; Boolean)
        {
            Caption = 'NCF Requested';
            DataClassification = ToBeClassified;
        }
        field(76058; "Cod. Clasificacion Gasto"; Code[2])
        {
            Caption = 'Expense Clasification Code';
            DataClassification = ToBeClassified;
            TableRelation = "Clasificacion Gastos";
        }
        field(76007; "Tipo ingreso admitido"; Code[2])
        {
            Caption = 'Type of admitted income';
            DataClassification = ToBeClassified;
            TableRelation = "Tipos de ingresos";
        }
    }
}

