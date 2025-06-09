codeunit 76075 Scanner
{
    TableNo = "Conceptos formula";

    trigger OnRun()
    begin
        GlobalRec.Copy(Rec);
        Reg_Tokens.Init;
        Clear(Reg_Tokens);
        Posicion := 0;
        Token := '';
        Car := '';
        Puntero := 0;
        i := 0;
        GlobalRec.Formula := DelChr(GlobalRec.Formula, '=', ' ');

        Scan;

        while Car <> '' do begin
            Token := '';
            if (StrPos('abcdefghijklmnopqrstuvwxyZABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_.', Car) <> 0) then begin
                repeat
                    Token := Token + Car;
                    Scan;
                until (StrPos('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_.', Car) = 0);
                Reconceptos.SetRange(Codigo, Token);
                if not Reconceptos.FindFirst then;
            end
            else
                if (StrPos('+-*/()#', Car) = 0) then
                    Error('Carácter inesperado  %1', Car)
                else begin
                    Token := Token + Car;
                    Scan;
                    if Token = '#' then begin
                        Token := Token + Car;
                        Scan;
                    end;
                end;
            if Token <> '' then
                Apilar;
        end;

        Token := '$';
        Apilar;
        Rec.Copy(GlobalRec);
    end;

    var
        Posicion: Integer;
        Car: Text[1];
        Token: Text[30];
        i: Integer;
        Reg_Tokens: Record Tokens;
        Puntero: Integer;
        Reconceptos: Record "Conceptos salariales";
        GlobalRec: Record "Conceptos formula";


    procedure Scan()
    begin
        i := i + 1;
        Car := CopyStr(GlobalRec.Formula, i, 1);
    end;


    procedure Apilar()
    begin
        Puntero := Puntero + 1;
        Reg_Tokens.Formula := GlobalRec.Formula;
        Reg_Tokens.Puntero := Puntero;
        Reg_Tokens.Token := Token;
        if not Reg_Tokens.Insert then
            Reg_Tokens.Modify;
    end;
}

