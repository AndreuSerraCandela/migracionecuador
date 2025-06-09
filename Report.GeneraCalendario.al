report 76381 "Genera Calendario"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));

            trigger OnAfterGetRecord()
            begin
                Date.Reset;
                Date.SetRange("Period Type", Date."Period Type"::Date);
                Date.SetRange("Period Start", DMY2Date(1, 1, Ano), DMY2Date(31, 12, Ano));
                //Date.SETRANGE("Period End",DMY2DATE(31,12,Ano));
                Date.FindSet;
                repeat
                    Calend.Init;
                    Calend.Fecha := Date."Period Start";
                    //  Calend.Texto
                    if Date."Period No." = 7 then
                        Calend."No laborable" := true
                    else
                        if (Date."Period No." = 6) and (SabadosNoLaborables) then
                            Calend."No laborable" := true;

                    Calend."Día de la semana" := Date."Period No.";
                    Calend.Semana := Date2DWY(Date."Period Start", 2);
                    Calend.Período := Date2DMY(Date."Period Start", 2);
                    Calend.Ano := Ano;
                    Calend.Mes := Date2DMY(Date."Period Start", 2);
                    if Calend.Insert then;
                    Cont += 1;
                    if Cont > 366 then
                        exit;
                until Date.Next = 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(Ano; Ano)
                {
                ApplicationArea = All;
                    Caption = 'Year to generate';
                }
                field(SabadosNoLaborables; SabadosNoLaborables)
                {
                ApplicationArea = All;
                    Caption = 'Saturdays are not working days';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Date: Record Date;
        Date2: Record Date;
        Calend: Record Calendario;
        Ano: Integer;
        SabadosNoLaborables: Boolean;
        Cont: Integer;
}

