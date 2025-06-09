codeunit 56200 "Web Service MdE"
{

    trigger OnRun()
    begin
    end;

    var

    procedure Empleado(mae: XMLport "Web Service MdE"; var result: XMLport "Resp. Web Service MdE")
    var
        IsOk: Boolean;
        id_mensaje: Text[36];
        Tipo: Text[20];
        FechaOrigen: Text[30];
        PaisOrigen: Text[20];
        DescErrorArray: array[10] of Text;
        TipoErrorArray: array[10] of Text;
        OutStrm: OutStream;
    begin
        mae.Import;
        mae.GetInfo(IsOk, id_mensaje, Tipo, FechaOrigen, PaisOrigen, DescErrorArray, TipoErrorArray);

        //+#101415
        mae.GetOutStrm(OutStrm);
        mae.SetDestination(OutStrm);
        mae.Export;
        mae.SendAsyncResponse();
        //-#101415

        result.SetInfo(id_mensaje, Tipo, FechaOrigen, PaisOrigen);
    end;
}

