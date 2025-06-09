codeunit 50107 "Procesa datos ponchador CHW"
{

    trigger OnRun()
    var
        FiltroFecha: DateTime;
    begin
        Haydatos := false;

        //DatosPonchador.SETRANGE(IdUser,'139');
        wFecha := CalcDate('-7D', Today);
        FiltroFecha := CreateDateTime(wFecha, 010000T);
        DatosPonchador.SetRange(RecordTime, FiltroFecha, CurrentDateTime);
        DatosPonchador.FindSet;
        repeat
            if Empl.Get(DatosPonchador.CodigoBC) then begin
                Haydatos := true;
                wFecha := DT2Date(DatosPonchador.RecordTime);
                wHora := DT2Time(DatosPonchador.RecordTime);

                tmpLogReloj.Init;
                tmpLogReloj."Cod. Empleado" := Empl."No.";
                tmpLogReloj.Validate("Fecha registro", wFecha);
                tmpLogReloj.Validate("Hora registro", wHora);
                tmpLogReloj."No. tarjeta" := DatosPonchador.ProximityCard;
                tmpLogReloj."ID Equipo" := Format(DatosPonchador.MachineNumber);
                if tmpLogReloj.Insert then;
            end;
        until DatosPonchador.Next = 0;


    end;

    var
        Empl: Record Employee;
        tmpLogReloj: Record "Punch log";
        LogReloj: Record "Punch log";
        Text000: Label 'End of processing';
        Text001: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        DatosPonchador: Record "DatosPonchador HMW";
        wFecha: Date;
        wHora: Time;
        Haydatos: Boolean;
}

