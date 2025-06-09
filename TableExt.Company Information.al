tableextension 50163 tableextension50163 extends "Company Information"
{
    fields
    {
        field(50000; "City 2"; Text[60])
        {
            Caption = 'City 2';
            DataClassification = ToBeClassified;
            TableRelation = if ("Country/Region Code" = const('')) "Post Code".City
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Country/Region Code"));
            ValidateTableRelation = false;
        }

        field(50001; "Ship-to City 2"; Text[60])
        {
            Caption = 'Ship-to City 2';
            DataClassification = ToBeClassified;
            TableRelation = if ("Country/Region Code" = const('')) "Post Code".City
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Country/Region Code"));
            ValidateTableRelation = false;
        }

        field(55000; "Identificación del Rep. Legal"; Code[30])
        {
            Caption = 'Legal Representative ID';
            DataClassification = ToBeClassified;
            Description = 'SRI/Ecuador';
        }
        field(55001; "RUC del Contador"; Code[30])
        {
            Caption = 'Accountant RUC';
            DataClassification = ToBeClassified;
            Description = 'SRI/Ecuador';
        }
        field(55002; "Cod. contribuyente especial"; Code[5])
        {
            Caption = 'Cód. contribuyente especial';
            DataClassification = ToBeClassified;
            Description = 'SRI/Ecuador';
        }
        field(55003; "Código otorgado por DINARDAP"; Code[7])
        {
            DataClassification = ToBeClassified;
            Description = '#6780';
        }
        field(55004; "No. Establecimientos inscritos"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }
}

