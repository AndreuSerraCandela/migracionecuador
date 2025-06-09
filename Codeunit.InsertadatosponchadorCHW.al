codeunit 50109 "Inserta datos ponchador CHW"
{
    TableNo = Employee;

    trigger OnRun()
    begin

        if Rec."No." <> '' then
            InsertarEmpleados(Rec);

        LeerDatosPonchador;
    end;

    var
        ParamRelojControlAsist: Record "Parametros Reloj Control Asist";
        tmpLogReloj: Record "Punch log";
        LogReloj: Record "Punch log";
        Text000: Label 'End of processing';
        Text001: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        DatosPonchador: Record "DatosPonchador HMW";
        //FuncionesNom: Codeunit "Funciones Nomina";
        wFecha: Date;
        wHora: Time;
        Haydatos: Boolean;
        Text002: Label 'This employee does not exist in the time attendancee database, do you wish to create it?';
        DatabaseName: Text;
        DatabaseConnectionString: Text;

    local procedure InsertarEmpleados(var Empl: Record Employee)
    var
        UsuariosPonchadorHMW: Record "Usuarios Ponchador HMW";
        UsuariosPonchadorHMW2: Record "Usuarios Ponchador HMW";
        IDPonchador: Integer;
    begin
        //Empl.SETRANGE("No.",'3018');
        //Empl.FIND('-');
        DatosConexion;

        if Empl."No." = '' then
            exit;

        Evaluate(IDPonchador, Empl."No.");

        UsuariosPonchadorHMW2.Reset;
        if not UsuariosPonchadorHMW2.FindLast then
            UsuariosPonchadorHMW2.Init;

        UsuariosPonchadorHMW.Reset;
        UsuariosPonchadorHMW.SetRange(CodigoBC, IDPonchador);
        if not UsuariosPonchadorHMW.FindFirst then begin
            if not Confirm(Text002) then
                exit;
            UsuariosPonchadorHMW.Init;
            UsuariosPonchadorHMW.IdUser := UsuariosPonchadorHMW2.IdUser + 1;
            UsuariosPonchadorHMW.Name := Empl."Full Name";
            UsuariosPonchadorHMW.Birthday := CreateDateTime(Empl."Birth Date", 0T);
            UsuariosPonchadorHMW.PhoneNumber := Empl."Phone No.";
            UsuariosPonchadorHMW.MobileNumber := Empl."Mobile Phone No.";
            UsuariosPonchadorHMW.Address := Empl.Address;
            UsuariosPonchadorHMW.Position := Empl."Job Title";
            UsuariosPonchadorHMW.Email := Empl."E-Mail";
            UsuariosPonchadorHMW.Comment := 'Creado desde BC';
            UsuariosPonchadorHMW.CodigoBC := IDPonchador;
            UsuariosPonchadorHMW.Active := 1;
            UsuariosPonchadorHMW.UseShift := 1;
            UsuariosPonchadorHMW.CreatedDatetime := CurrentDateTime;
            UsuariosPonchadorHMW.Insert(true);

            Empl."ID Control de asistencia" := Format(UsuariosPonchadorHMW.IdUser);
            Empl.Modify;
            Commit;
        end
        else
            if Empl."ID Control de asistencia" = '' then begin
                Empl."ID Control de asistencia" := Format(UsuariosPonchadorHMW.IdUser);
                Empl.Modify;
            end;
    end;

    local procedure LeerDatosPonchador()
    var
        Empl: Record Employee;
    begin
        Haydatos := false;

        //DatosPonchador.SETRANGE(IdUser,'139');
        DatosPonchador.Find('-');
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

        if Haydatos then
            //FuncionesNom.ProcesaDatosPonchador;
        ;
    end;

    local procedure CrearEmplLotes()
    var
        Empl: Record Employee;
        UsuariosPonchadorHMW: Record "Usuarios Ponchador HMW";
        IDPonchador: Integer;
    begin
        Empl.Find('-');
        repeat
            Evaluate(IDPonchador, Empl."No.");

            UsuariosPonchadorHMW.Reset;
            UsuariosPonchadorHMW.SetRange(CodigoBC, IDPonchador);
            if not UsuariosPonchadorHMW.FindFirst then begin
                UsuariosPonchadorHMW.Init;
                UsuariosPonchadorHMW.Name := Empl."Full Name";
                UsuariosPonchadorHMW.Birthday := CreateDateTime(Empl."Birth Date", 0T);
                UsuariosPonchadorHMW.PhoneNumber := Empl."Phone No.";
                UsuariosPonchadorHMW.MobileNumber := Empl."Mobile Phone No.";
                UsuariosPonchadorHMW.Address := Empl.Address;
                UsuariosPonchadorHMW.Position := Empl."Job Title";
                UsuariosPonchadorHMW.Email := Empl."E-Mail";
                UsuariosPonchadorHMW.Comment := 'Creado desde BC';
                UsuariosPonchadorHMW.CodigoBC := IDPonchador;
                //      UsuariosPonchadorHMW.Active := 0;
                UsuariosPonchadorHMW.Insert(true);
            end;
            Empl."ID Control de asistencia" := Format(UsuariosPonchadorHMW.IdUser);
            Empl.Modify;
        until Empl.Next = 0;
    end;

    local procedure DatosConexion()
    begin
        ParamRelojControlAsist.FindFirst;

        DatabaseName := ParamRelojControlAsist."Initial Catalog";
        if HasTableConnection(TABLECONNECTIONTYPE::ExternalSQL, DatabaseName) then
            UnregisterTableConnection(TABLECONNECTIONTYPE::ExternalSQL, DatabaseName);

        DatabaseConnectionString := 'Data Source=' + ParamRelojControlAsist."Data Source" + ';Initial Catalog=' + ParamRelojControlAsist."Initial Catalog" +
                                    ';User Id=' + ParamRelojControlAsist.User + ';Password=' + ParamRelojControlAsist.Password;
        RegisterTableConnection(TABLECONNECTIONTYPE::ExternalSQL, DatabaseName, DatabaseConnectionString);
        SetDefaultTableConnection(TABLECONNECTIONTYPE::ExternalSQL, DatabaseName);
    end;
}

