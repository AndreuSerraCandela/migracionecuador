report 76133 "Conversion Horas"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Programac. Talleres y Eventos"; "Programac. Talleres y Eventos")
        {
            DataItemTableView = SORTING ("Cod. Taller - Evento", "Tipo Evento", "Tipo de Expositor", Expositor, "Fecha programacion", Secuencia);

            trigger OnAfterGetRecord()
            begin
                "Horas Pedagógicas" := Round("Horas dictadas" * 60 / 40, 1);
                Modify;
            end;

            trigger OnPostDataItem()
            begin
                Message('Proceso finalizado');
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

    trigger OnPreReport()
    var
        Text001: Label 'Se realizará una conversión de horas programadas a horas pedagógicas. ¿Desea continuar?';
    begin
        if not Confirm(Text001) then
            CurrReport.Quit;
    end;
}

