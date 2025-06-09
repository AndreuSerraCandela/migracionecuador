table 76040 "Motivos acciones personal"
{
    Caption = 'Reason personnel action';
    DataPerCompany = false;

    fields
    {
        field(1; "Tipo de accion"; Option)
        {
            Caption = 'Action type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Hiring,Change,Quit';
            OptionMembers = " ",Ingreso,Cambio,Salida;
        }
        field(2; Codigo; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Descripcion; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Emitir documento"; Boolean)
        {
            Caption = 'Print document';
            DataClassification = ToBeClassified;
        }
        field(5; "ID Documento"; Integer)
        {
            Caption = 'Document ID';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Tipo de accion", Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Incentivo: Record "Incentivos/Propinas";
}

