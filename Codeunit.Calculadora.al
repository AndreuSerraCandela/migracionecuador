codeunit 76001 Calculadora
{
    // Calcula el valor de una fórmula en notación polaca inversa del fichero POLACA
    // y lo almacena en la variable resultado del fichero CONCEPTOS
    // El signo menos unario en polaca se representará por el signo '&'


    trigger OnRun()
    begin
        i := 0;
        Reg_Conceptos.Get('resultado');
        Reg_Polaca.SetRange(Formula, Reg_Conceptos.Formula);

        Reg_Polaca.Find('-');

        //Reg_Conceptos.GET(Reg_Polaca.Token);

        repeat
            case Reg_Polaca.Token of
                '+':
                    begin
                        i := i - 1;
                        Pila[i] := Pila[i] + Pila[i + 1];
                    end;
                '-':
                    begin
                        i := i - 1;
                        Pila[i] := Pila[i] - Pila[i + 1];
                    end;
                '*':
                    begin
                        i := i - 1;
                        Pila[i] := Pila[i] * Pila[i + 1];
                    end;
                '/':
                    begin
                        i := i - 1;
                        Pila[i] := Pila[i] / Pila[i + 1];
                    end;
                '&':
                    Pila[i] := -Pila[i];
                else begin
                        Reg_Conceptos.Reset;
                        Reg_Conceptos.SetRange(Concepto, Reg_Polaca.Token);
                        //      IF Reg_Conceptos.GET(Reg_Polaca.Token) THEN {variable}
                        if Reg_Conceptos.FindFirst then /*variable*/
                           begin
                            i := i + 1;
                            Pila[i] := Reg_Conceptos.Valor;
                        end
                        else begin
                            i := i + 1;
                            if not Conceptossalariales.Get(Reg_Polaca.Token) then
                                Evaluate(Pila[i], Reg_Polaca.Token);      /*constante*/
                        end;
                    end;
            end;

        until Reg_Polaca.Find('>') = false;

        Reg_Conceptos.Get('resultado');
        Reg_Conceptos.Valor := Pila[i];
        Reg_Conceptos.Modify;

        Reg_tokens.Reset;
        Reg_tokens.DeleteAll;
        Reg_Polaca.Reset;
        Reg_Polaca.DeleteAll;

    end;

    var
        Reg_tokens: Record Tokens;
        Reg_Polaca: Record Polaca;
        Reg_Conceptos: Record "Conceptos formula";
        Conceptossalariales: Record "Conceptos salariales";
        Pila: array[10] of Decimal;
        i: Integer;
}

