table 76055 "Comentarios nómina"
{
    Caption = 'Payroll comments';
    LookupPageID = "Bancos Transferencias";

    fields
    {
        field(1; Tipo; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Company,Employee,Agreements';
            OptionMembers = "Empresa cotización",Empleado,Convenios;
        }
        field(2; Codigo; Code[15])
        {
            Caption = 'Code';
        }
        field(3; "No. Orden"; Integer)
        {
            Caption = 'Order no.';
        }
        field(4; Fecha; Date)
        {
            Caption = 'Date';
        }
        field(5; Usuario; Code[60])
        {
            Caption = 'User ID';
        }
        field(6; Texto; Text[80])
        {
            Caption = 'Text';
        }
    }

    keys
    {
        key(Key1; Tipo, Codigo, "No. Orden")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Usuario := UserId;
    end;
}

