report 56529 "Verifica combinaciones Niveles"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Colegio - Grados"; "Colegio - Grados")
        {
            DataItemTableView = SORTING ("Cod. Colegio", "Cod. Nivel", "Cod. Turno", "Cod. Grado", Seccion) WHERE ("Cod. Nivel" = FILTER ('INI' | 'PRI' | 'SEC'));

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                Window.Update(1, "Cod. Colegio");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                COLNIVEL.TransferFields("Colegio - Grados");
                if (StrPos("Cod. Grado", 'INI') <> 0) and ("Cod. Nivel" <> 'INI') then begin
                    COLNIVEL.Rename("Cod. Colegio", 'INI', "Cod. Turno", "Cod. Grado", Seccion);
                    Commit;
                end
                else
                    if (StrPos("Cod. Grado", 'PRI') <> 0) and ("Cod. Nivel" <> 'PRI') then begin
                        COLNIVEL.Rename("Cod. Colegio", 'PRI', "Cod. Turno", "Cod. Grado", Seccion);
                        Commit;
                    end
                    else
                        if (StrPos("Cod. Grado", 'SEC') <> 0) and ("Cod. Nivel" <> 'SEC') then begin
                            COLNIVEL.Rename("Cod. Colegio", 'SEC', "Cod. Turno", "Cod. Grado", Seccion);
                            Commit;
                        end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                CounterTotal := Count;
                Window.Open(Text001);
            end;
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

    labels
    {
    }

    var
        COLNIVEL: Record "Colegio - Grados";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Text001: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
}

