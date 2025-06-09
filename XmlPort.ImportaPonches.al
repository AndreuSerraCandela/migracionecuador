xmlport 76000 "Importa Ponches"
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
                    /*MESSAGE('%1',COPYSTR(texto,8,1));
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
                        if CopyStr(texto, 8, 1) = '3' then begin
                            if Emp.Get(CopyStr(texto, 11, 4)) then begin
                                Clear(LogPonchador);
                                LogPonchador.Validate("Cod. Empleado", CopyStr(texto, 11, 4));
                                LogPonchador."Fecha registro" := DMY2Date(iDD, iMM, iAAAA);
                                Evaluate(LogPonchador."Hora registro", CopyStr(texto, 1, 6));
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

