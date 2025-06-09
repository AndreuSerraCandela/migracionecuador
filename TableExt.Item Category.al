tableextension 50111 tableextension50111 extends "Item Category"
{
    fields
    {
        field(50001; "Def. Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Def. Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group".Code;
        }
        field(50002; "Def. Inventory Posting Group"; Code[10])
        {
            Caption = 'Def. Inventory Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Inventory Posting Group".Code;
        }
        field(50003; "Def. Tax Group Code"; Code[10])
        {
            Caption = 'Def. Tax Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "Tax Group".Code;
        }
        field(50004; "Def. Costing Method"; Option)
        {
            Caption = 'Def. Costing Method';
            DataClassification = ToBeClassified;
            OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
            OptionMembers = FIFO,LIFO,Specific,"Average",Standard;
        }
        field(50005; "Def. VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'Def. Tax Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(50006; "Interfaz web"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ITPV';
        }
        field(50007; EspecificacionSIC; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ITPV';
        }
        field(75000; Bloqueado; Boolean)
        {
            Caption = 'Bloqueado';
            DataClassification = ToBeClassified;
            Description = 'MdM';
        }
        field(75001; MdM; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'MdM, Bloquea los productos relacioandos con esta marca';
        }
    }
}

