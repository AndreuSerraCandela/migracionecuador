page 76171 "Dialogo motivo"
{
    ApplicationArea = all;
    Caption = 'Indique el Motivo';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(Motivo; texMotivo)
            {
                Caption = 'Indique el motivo de la reapertura';
            }
        }
    }

    actions
    {
    }

    var
        texMotivo: Text[60];


    procedure TraerMotivo(): Text[60]
    begin
        exit(texMotivo);
    end;
}

