report 56200 "Enviar IRM"
{
    // #72814 27/06/2017 PLB: Posibilidad de exportar el IRM a Excel

    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING ("No.");
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                if Envio = Envio::"Envio directo" then begin //+#72814
                    i += 1;
                    Window.Update(1, Round((i / nRegs) * 10000, 1));

                    //+#72814
                    //  InfComp.IRM(FechaIni, FechaFin, Employee."No.");
                    InfComp.IRM(FechaIni, FechaFin, Employee."No.", false);
                end
                else begin
                    InfComp.IRM(FechaIni, FechaFin, Employee.GetFilter("No."), true);
                    CurrReport.Break;
                end;
                //-#72814
            end;

            trigger OnPostDataItem()
            begin
                if Envio = Envio::"Envio directo" then //+#72814
                    Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                if Envio = Envio::"Envio directo" then begin //+#72814
                    nRegs := Count;
                    i := 0;

                    Window.Open(Text001);
                end; //+#72814
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Envío")
                {
                    Caption = 'Envío';
                    field(Envio; Envio)
                    {
                    ApplicationArea = All;
                        Caption = 'Tipo';
                    }
                }
                group(Periodo)
                {
                    Caption = 'Periodo';
                    field(FechaIni; FechaIni)
                    {
                    ApplicationArea = All;
                        Caption = 'Fecha inicio';

                        trigger OnValidate()
                        begin
                            if FechaIni <> 0D then
                                FechaFin := CalcDate('<CM>', FechaIni);
                        end;
                    }
                    field(FechaFin; FechaFin)
                    {
                    ApplicationArea = All;
                        Caption = 'Fecha fin';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if FechaIni = 0D then begin
                FechaIni := CalcDate('<-1M-CM>', Today);
                FechaFin := CalcDate('<CM>', FechaIni);
            end;
        end;
    }

    labels
    {
    }

    var
        InfComp: Codeunit "Informacion Complementaria MDE";
        FechaIni: Date;
        FechaFin: Date;
        Window: Dialog;
        Text001: Label 'Enviando @1@@@@@';
        i: Integer;
        nRegs: Integer;
        Envio: Option "Envio directo","Generar Excel";
}

