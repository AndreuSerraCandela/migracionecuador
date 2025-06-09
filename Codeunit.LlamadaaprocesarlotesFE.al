codeunit 55009 "Llamada a procesar lotes FE"
{
    // 001 #35029 RRT, 20.07.17: Mejoras y automatización FE Ecuador V2. Llamada a la codeunit 55005 para que pueda ser llamada desde el planificador de tareas


    trigger OnRun()
    var
        cProcesarLote: Codeunit "Procesar lote FE";
        lrParLoteFE: Record "Parametros lote FE";
        l: Record tabla56000;
    begin
        //+001
        cProcesarLote.Run(lrParLoteFE);
    end;
}

