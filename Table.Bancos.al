table 76279 Bancos
{
    Caption = 'Banks';
    LookupPageID = Bancos;

    fields
    {
        field(1; Codigo; Code[20])
        {
            Caption = 'Code';
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                if Bco.Get(Codigo) then begin
                    "Nombre banco" := Bco.Name;
                    "Cuenta Banco" := Bco."Bank Account No.";
                end;
            end;
        }
        field(2; "Nombre banco"; Text[60])
        {
            Caption = 'Bank''s name';
        }
        field(3; "ID Banco"; Code[4])
        {
            Caption = 'Bank ID';
            Numeric = true;
        }
        field(4; "Cuenta Banco"; Code[22])
        {
            Caption = 'Bank account';
        }
        field(5; Formato; Text[30])
        {
            Caption = 'Format';
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Bco: Record "Bank Account";
}

