table 75002 "Estructura Analitica"
{
    DrillDownPageID = "Estructura Analitica";
    LookupPageID = "Estructura Analitica";

    fields
    {
        field(1; Codigo; Code[21])
        {

            trigger OnValidate()
            begin
                SetNivel;
            end;
        }
        field(10; Nivel; Integer)
        {
        }
        field(11; Descripcion; Text[100])
        {
        }
        field(50; Blocked; Boolean)
        {
            Caption = 'Blocked';

            trigger OnValidate()
            var
                EstrAna: Record "Estructura Analitica";
                i: Integer;
                NuevoCodigo: Code[21];
                EndLoop: Boolean;
            begin
                // Si el nivel está bloqueado y cambia, hay que verificar que el nivel menor no está bloqueado
                if Blocked <> xRec.Blocked then begin
                    if not Blocked and (Nivel > 1) then begin
                        EstrAna.SetRange(Nivel, Nivel - 1);
                        i := StrLen(Codigo);
                        repeat
                            i := i - 1;

                            NuevoCodigo := CopyStr(Codigo, 1, i);

                            EstrAna.SetRange(Codigo, NuevoCodigo);
                            if EstrAna.FindFirst then begin
                                if EstrAna.Blocked then
                                    Error(Text002, NuevoCodigo)
                                else
                                    EndLoop := true;
                            end;
                        until (i = 1) or EndLoop;
                    end;
                end;
            end;
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
        fieldgroup(DropDown; Codigo, Descripcion)
        {
        }
    }

    trigger OnDelete()
    var
        EstrAna: Record "Estructura Analitica";
    begin
        EstrAna.SetFilter(Codigo, Codigo + '*');
        EstrAna.SetFilter(Nivel, '>%1', Nivel);
        EstrAna.DeleteAll;
    end;

    trigger OnInsert()
    begin
        SetNivel;
    end;

    trigger OnModify()
    var
        EstrAna: Record "Estructura Analitica";
        UnBlock: Boolean;
    begin
        // Si se modifica el bloqueo, hay que actualizar los bloqueos de los niveles mayores
        if Blocked <> xRec.Blocked then begin
            EstrAna.SetFilter(Codigo, Codigo + '*');
            EstrAna.SetFilter(Nivel, '>%1', Nivel);
            if EstrAna.FindFirst then begin
                if Blocked then
                    EstrAna.ModifyAll(Blocked, true)
                else begin
                    if HideWindow then
                        UnBlock := true
                    else
                        UnBlock := Confirm(Text001, false);
                    if UnBlock then
                        EstrAna.ModifyAll(Blocked, false);
                end;
            end;
        end;
    end;

    var
        Text001: Label '¿Quieres desbloquear los niveles dependientes de este nivel?';
        HideWindow: Boolean;
        Text002: Label 'No se puede desbloquear, el nivel superior (%1) está bloqueado.';


    procedure SetNivel()
    var
        lwCode: Code[21];
        lwOk: Boolean;
        lrEA: Record "Estructura Analitica";
    begin
        // SetNivel
        // Automatiza el nivel

        // Una manera mejor de determinar el nivel
        Nivel := StrLen(Codigo) div 3;
        /*
        Nivel := 0;
        lwCode := Codigo;
        IF lwCode = '' THEN
          EXIT;
        
        lwOk := FALSE;
        
        CLEAR(lrEA);
        WHILE NOT lwOk DO BEGIN
          lwCode := COPYSTR(lwCode,1,STRLEN(lwCode)-1);
          lwOk := lwCode = '';
          IF lwOk THEN
            Nivel := 1
          ELSE BEGIN
            lwOk := lrEA.GET(lwCode);
            IF lwOk THEN
              Nivel := lrEA.Nivel +1;
          END;
        END;
        */

    end;


    procedure SetHideWindow(NewHideWindow: Boolean)
    begin
        HideWindow := NewHideWindow;
    end;
}

