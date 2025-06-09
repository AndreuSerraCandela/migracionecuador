table 76201 "Grupo de Colegios"
{

    fields
    {
        field(1; "Cod. Grupo"; Code[20])
        {
        }
        field(2; "Descripción"; Text[80])
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Grupo")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure GetColegios() rtn: Text[1024]
    var
        ColGrupo: Record "Grupo - Colegios";
    begin
        ColGrupo.SetRange(ColGrupo."Cod. grupo", "Cod. Grupo");
        if ColGrupo.FindSet then
            repeat
                if rtn = '' then
                    rtn := ColGrupo."Cod. Colegio"
                else
                    rtn := rtn + '|' + ColGrupo."Cod. Colegio";
            until ColGrupo.Next = 0;
    end;


    procedure CheckGrupo()
    var
        ColGrupo: Record "Grupo - Colegios";
        Err001: Label 'El grupo %1 no tiene colegios asociados';
    begin
        ColGrupo.SetRange(ColGrupo."Cod. grupo", "Cod. Grupo");
        if not ColGrupo.FindFirst then
            Error(Err001, "Cod. Grupo");
    end;
}

