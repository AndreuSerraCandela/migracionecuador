codeunit 76053 Parser
{
    // Analizador sintáctico basado en el algoritmo 'Descenso recursivo' con
    // generación de código en polaca inversa para la gramática:
    // E -> E + T, E - T
    // E -> T, -T
    // T -> T * F, T / F
    // T -> F
    // F -> i
    // F -> (E), -(E)
    // El código generado se almacena en la tabla POLACA

    TableNo = "Conceptos formula";

    trigger OnRun()
    begin
        GlobalRec.Copy(Rec);
        GlobalRec.Formula := DelChr(GlobalRec.Formula, '=', ' ');

        Regtoken.SetRange(Formula, GlobalRec.Formula);
        Regtoken.FindFirst;

        E(Regpolaca);
        if Regtoken.Token <> '$' then begin
            Eliminar;
            Error('Carácter inesperado %1  ' +
                  '%2', Regtoken.Token, Regtoken.Formula);
        end;
        Rec.Copy(GlobalRec);
    end;

    var
        Puntero: Integer;
        Regtoken: Record Tokens;
        Regpolaca: Record Polaca;
        Regconceptos: Record "Conceptos formula";
        GlobalRec: Record "Conceptos formula";


    procedure F(Reg: Record Polaca)
    begin
        if (Regtoken.Token >= 'a') and (Regtoken.Token < 'z') or
           (Regtoken.Token >= 'A') and (Regtoken.Token < 'Z') or
           (Regtoken.Token >= '0') and (Regtoken.Token <= '9') or
           (CopyStr(Regtoken.Token, 1, 1) = '#') then begin
            Reg.Token := Regtoken.Token;
            Apilar(Reg);
            Regtoken.Next;
        end
        else
            if Regtoken.Token <> '(' then begin
                Eliminar;
                Error('Se esperaba paréntesis de apertura (  ' +
                      '%1', Regtoken.Formula);
            end
            else begin
                Regtoken.Next;
                E(Reg);
                if Regtoken.Token <> ')' then begin
                    Eliminar;
                    Error('Se esperaba paréntesis de cierre )  ' + '%1', Regtoken.Formula);
                end
                else
                    Regtoken.Next;
            end;
    end;


    procedure T(Reg: Record Polaca)
    begin
        F(Reg);
        while (Regtoken.Token = '*') or (Regtoken.Token = '/') do begin
            Reg.Token := Regtoken.Token;
            Regtoken.Next;
            F(Reg);
            Apilar(Reg);
        end;
    end;


    procedure E(Reg: Record Polaca)
    begin
        if Regtoken.Token = '-' then begin
            Reg.Token := '&';
            Regtoken.Next;
            T(Reg);
            Apilar(Reg);
        end
        else
            T(Reg);
        while (Regtoken.Token = '+') or (Regtoken.Token = '-') do begin
            Reg.Token := Regtoken.Token;
            Regtoken.Next;
            T(Reg);
            Apilar(Reg);
        end;
    end;


    procedure Apilar(Reg: Record Polaca)
    begin
        Puntero := Puntero + 1;
        Reg.Formula := Regtoken.Formula;
        Reg.Puntero := Puntero;
        if not Reg.Insert then
            Reg.Modify;
    end;


    procedure Eliminar()
    begin
        Regtoken.DeleteAll;
        Regpolaca.DeleteAll;
        Commit;
    end;
}

