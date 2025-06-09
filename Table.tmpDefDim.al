table 59002 "tmp Def Dim"
{

    fields
    {
        field(1; Cta; Code[20])
        {
        }
        field(2; Codigo; Code[20])
        {
        }
        field(3; Valor; Code[20])
        {
        }
        field(5; "Value Posting"; Option)
        {
            Caption = 'Value Posting';
            OptionCaption = ' ,Code Mandatory,Same Code,No Code';
            OptionMembers = " ","Code Mandatory","Same Code","No Code";
        }
    }

    keys
    {
        key(Key1; Cta, Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

