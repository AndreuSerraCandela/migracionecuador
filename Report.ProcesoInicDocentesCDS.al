report 76417 "Proceso Inic. Docentes -  CDS"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Docentes; Docentes)
        {
            DataItemTableView = SORTING ("No.");
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                "intCampaña": Integer;
            begin
                Counter := Counter + 1;
                Window.Update(1, "No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                ColDoc.Reset;
                ColDoc.SetRange("Cod. Docente", "No.");
                ColDoc.SetRange(Principal, true);
                if not ColDoc.FindFirst then
                    ColDoc.Init;


                Clear(HistCDS);

                //HistCDS.Campana := ConfAPS.Campana - 1;

                if ConfAPS.Campana <> '' then
                    if Evaluate(intCampaña, ConfAPS.Campana) then
                        HistCDS.Campana := Format(intCampaña - 1);

                HistCDS."Cod. Docente" := "No.";
                HistCDS."Pertenece al CDS" := "Pertenece al CDS";
                HistCDS."Cod. CDS" := "Cod. CDS";
                HistCDS."Ult. fecha activacion" := "Ult. fecha activacion";
                HistCDS."Cod. Colegio" := ColDoc."Cod. Colegio";
                HistCDS."Cod. Nivel" := ColDoc."Cod. Nivel";
                if HistCDS.Insert then;

                "Pertenece al CDS" := false;
                "Ult. fecha activacion" := 0D;
                Modify;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message(Msg001);
            end;

            trigger OnPreDataItem()
            begin
                ConfAPS.Get();
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
        ConfAPS: Record "Commercial Setup";
        HistCDS: Record "Historico Docentes - CDS";
        ColDoc: Record "Colegio - Docentes";
        CounterTotal: Integer;
        Counter: Integer;
        Window: Dialog;
        Text001: Label 'Processing  #1########## @2@@@@@@@@@@@@@';
        Msg001: Label 'All the teachers has been processed, please check the updates';
}

