xmlport 76013 "Importa Ponches MG"
{
    Direction = Import;
    Format = FixedText;

    schema
    {
        textelement(root)
        {
            tableelement(Integer; Integer)
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'integer';
                SourceTableView = SORTING (Number) WHERE (Number = CONST (1));
                textelement(texto)
                {
                    Width = 250;
                }

                trigger OnBeforeInsertRecord()
                begin
                    //ERROR('%1',COPYSTR(texto,5,5));
                    /*
                    MESSAGE('%1',COPYSTR(texto,11,4));
                    */
                    if CopyStr(texto, 8, 1) = '4' then begin
                        AAAA := CopyStr(texto, 10, 4);
                        MM := CopyStr(texto, 14, 2);
                        DD := CopyStr(texto, 16, 2);
                        Evaluate(iAAAA, AAAA);
                        Evaluate(iMM, MM);
                        Evaluate(iDD, DD);
                    end
                    else
                    //IF COPYSTR(texto,2,1) = '3' THEN
                       begin
                        if Emp.Get(CopyStr(texto, 8, 5)) then begin
                            Clear(LogPonchador);
                            LogPonchador.Validate("Cod. Empleado", CopyStr(texto, 8, 5));
                            AAAA := CopyStr(texto, 13, 4);
                            MM := CopyStr(texto, 17, 2);
                            DD := CopyStr(texto, 19, 2);
                            Evaluate(iAAAA, AAAA);
                            Evaluate(iMM, MM);
                            Evaluate(iDD, DD);
                            LogPonchador."Fecha registro" := DMY2Date(iDD, iMM, iAAAA);
                            Evaluate(LogPonchador."Hora registro", CopyStr(texto, 21, 6));
                            LogPonchador.Procesado := false;
                            if not LogPonchador.Insert then
                                LogPonchador.Modify;
                        end;
                    end;

                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        Emp: Record Employee;
        LogPonchador: Record "Punch log";
        Fecha: Integer;
        AAAA: Text[4];
        MM: Text[2];
        DD: Text[2];
        iAAAA: Integer;
        iMM: Integer;
        iDD: Integer;
}

