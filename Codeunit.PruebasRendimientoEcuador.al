codeunit 56099 "Pruebas Rendimiento Ecuador"
{

    trigger OnRun()
    begin
        intTotal := 100000;


        dlgProgreso.Open(Text001 + Text002 + Text003 + Text004);
        dlgProgreso.Update(4, intTotal);

        timInicio := Time;
        for i := 1 to intTotal do begin

            recDatos.Init;
            recDatos.Clave := i;
            recDatos.Datos1 := CopyStr(Data001, 1, 250);
            recDatos.Datos2 := CopyStr(Data002, 1, 250);
            recDatos.Datos3 := CopyStr(Data003, 1, 250);
            recDatos.Datos4 := CopyStr(Data004, 1, 250);
            recDatos.Insert;

            intProcesados += 1;

            if intProcesados mod 1000 = 0 then begin
                if (((Time - timInicio) / 1000) > 0) then
                    dlgProgreso.Update(1, Round(intProcesados / ((Time - timInicio) / 1000), 1));
                dlgProgreso.Update(3, intProcesados);

            end;
        end;
        intEscritura := Round(intProcesados / ((Time - timInicio) / 1000), 1);


        intProcesados := 0;
        timInicio := Time;
        recDatos.Reset;
        if recDatos.FindSet then
            repeat

                intProcesados += 1;

                if intProcesados mod 1000 = 0 then begin
                    if (((Time - timInicio) / 1000) > 0) then
                        dlgProgreso.Update(2, Round(intProcesados / ((Time - timInicio) / 1000), 1));
                    dlgProgreso.Update(3, intProcesados);
                end;

            until recDatos.Next = 0;
        intLectura := Round(intProcesados / ((Time - timInicio) / 1000), 1);


        intProcesados := 0;
        timInicio := Time;
        recDatos.Reset;
        recDatos.DeleteAll;
        if (((Time - timInicio) / 1000) > 0) then
            intEliminacion := Round(intTotal / ((Time - timInicio) / 1000), 1);

        //dlgProgreso.CLOSE;

        Message(Text005, intEscritura, intLectura, intEliminacion);
    end;

    var
        recDatos: Record "Pruebas Rendimiento Ecuador";
        dlgProgreso: Dialog;
        timInicio: Time;
        intProcesados: Integer;
        intTotal: Integer;
        intEscritura: Integer;
        intLectura: Integer;
        intEliminacion: Integer;
        i: Integer;
        Data001: Label 'fwmedfoiwjèf oiwje`pfoi wqjefo wiejf wqoiefwoeicmk owied wqi cfwmedfoiwjèf oiwje`pfoi wqjefo wiejf wqoiefwoeicmk owied wqi cfwmedfoiwjèf oiwje`pfoi wqjefo wiejf wqoiefwoeicmk owied wqi cfwmedfoiwjèf oiwje`pfoi wqjefo wiejf wqoiefwoeicmk owied wqi cfwmedfoiwjèf oiwje`pfoi wqjefo wiejf wqoiefwoeicmk owied wqi c';
        Data002: Label 'cñlskmdclmklñkmLSDKVCMÑLSDKCMASLÑDCKMASLDKCMSÑLDKCMAS ÑLDALKALCALÑÑLK SDLÑWEIKWÑL IFEJWÑIF AÑLIcñlskmdclmklñkmLSDKVCMÑLSDKCMASLÑDCKMASLDKCMSÑLDKCMAS ÑLDALKALCALÑÑLK SDLÑWEIKWÑL IFEJWÑIF AÑLIcñlskmdclmklñkmLSDKVCMÑLSDKCMASLÑDCKMASLDKCMSÑLDKCMAS ÑLDALKALCALÑÑLK SDLÑWEIKWÑL IFEJWÑIF AÑLI';
        Data003: Label '2R3094R21''0948''0 123948''02 3948''2013 49821''0394 139103922R3094R21''0948''0 123948''02 3948''2013 49821''0394 139103922R3094R21''0948''0 123948''02 3948''2013 49821''0394 139103922R3094R21''0948''0 123948''02 3948''2013 49821''0394 139103922R3094R21''0948''0 123948''02 3948''2013 49821''0394 139103922R3094R21''0948''0 123948''02 3948''2013 49821''0394 13910392';
        Data004: Label 'AFÙCLOMWCOIMOI3J2094209U3R39JG03G9J03F9J32TAFÙCLOMWCOIMOI3J2094209U3R39JG03G9J03F9J32TAFÙCLOMWCOIMOI3J2094209U3R39JG03G9J03F9J32TAFÙCLOMWCOIMOI3J2094209U3R39JG03G9J03F9J32TAFÙCLOMWCOIMOI3J2094209U3R39JG03G9J03F9J32TAFÙCLOMWCOIMOI3J2094209U3R39JG03G9J03F9J32TAFÙCLOMWCOIMOI3J2094209U3R39JG03G9J03F9J32T';
        Text001: Label 'Comprobando rendimiento (registros/seg)\\';
        Text002: Label 'Escritura: #########1\';
        Text003: Label 'Lectura:  #########2\\\';
        Text004: Label 'Procesados #########3 de ##########4';
        Text005: Label 'Resultados (registros/segundo):\\Escritura %1\Lectura %2\Eliminación %3';
}

