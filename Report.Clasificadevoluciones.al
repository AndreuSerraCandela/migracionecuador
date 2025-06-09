report 56000 "Clasifica devoluciones"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Classify Returns';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(PreDev; "Cab. clas. devolucion")
        {
            DataItemTableView = SORTING("No.") WHERE(Closed = CONST(true));
            RequestFilterFields = "No.", "Customer no.", "Receipt date";

            trigger OnAfterGetRecord()
            begin
                if not Procesada then begin
                    recTmpPreDev.Init;
                    recTmpPreDev := PreDev;
                    recTmpPreDev.Insert;
                end;

                //CODEUNIT.RUN(recCfgSant."Codeunit clas. devoluciones",PreDev);

                // ++ #175585
                ClasificacionDevoluciones.FiltroPorcientoDecimal(FiltroDescuento);   //#175585
                ClasificacionDevoluciones.Run(PreDev);                               //#175585
                // -- #175585
            end;

            trigger OnPreDataItem()
            begin
                recCfgSant.Get;
                recCfgSant.TestField("Codeunit clas. devoluciones");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control100000001)
                {
                    ShowCaption = false;
                    field(FiltroDescuento; FiltroDescuento)
                    {
                    ApplicationArea = All;
                        Caption = 'Filtro % Descuento';
                    }
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

    trigger OnPostReport()
    begin
        Commit;

        if recTmpPreDev.Count > 0 then begin
            Clear(repDocsGen);
            repDocsGen.PasarPreDev(recTmpPreDev);
            repDocsGen.UseRequestPage := true;
            repDocsGen.RunModal;
        end
        else
            Message(Text001);
    end;

    trigger OnPreReport()
    begin
        if PreDev.GetFilters = '' then
            if not Confirm(Text002, false) then
                CurrReport.Quit;
    end;

    var
        recCfgSant: Record "Config. Empresa";
        recPreDev: Record "Cab. clas. devolucion";
        recTmpPreDev: Record "Cab. clas. devolucion" temporary;
        repDocsGen: Report "Documentos generados clas. dev";
        Text001: Label 'No se han encontrado devoluciones pendientes de clasificar.';
        Text002: Label 'No ha seleccionado ningún filtro ¿Desea clasificar todas las devoluciones pendientes?';
        ClasificacionDevoluciones: Codeunit "Clasificacion devoluciones";
        FiltroDescuento: Decimal;
}

