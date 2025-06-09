/*codeunit 76004 "Control TPV"
{
    // #118629 RRT,  22.02.2018: Si se produce un error en la anulación se estaba grabando un NCR de forma incorrecta.
    // #144756 RRT,  11.09.2018: Error de sincronización con DS-POS.
    // #381937 RRT,  31.05.2021: Convertir la creacion de una devolucion en una transaccion


    trigger OnRun()
    var
        lcFComunes: Codeunit "Funciones DsPOS - Comunes";
    begin
        //+#118629
        //... Aprovechamos esta funcion para mejorar el proceso de anulación. Por lo visto, aun en caso de error en el proceso de anulación. Se estaba realizando un
        //... COMMIT. Debe ser por la interacción con el Add-ins, no lo sé.
        //... Por lo menos de esta forma podemos evitarlo y tenemos el error controlado.

        //+#381397
        //... Permitimos ejecutar otras funciones, aparte de la anulación
        //wRespuesta := lcFComunes.AnularFactura(wcodPrmTienda,wcodPrmTPV,wcodPrmCajero,wcodPrmDoc);
        if wCodFuncion = wCodFuncion::Devolucion then
            wRespuesta := lcFComunes.Crear_Devolucion(wEvento)
        else
            wRespuesta := lcFComunes.AnularFactura(wcodPrmTienda, wcodPrmTPV, wcodPrmCajero, wcodPrmDoc);
        //-#381397
    end;

    var
        wcodPrmTienda: Code[20];
        wcodPrmTPV: Code[20];
        wcodPrmCajero: Code[20];
        wcodPrmDoc: Code[20];
        wRespuesta: Text;
        wCodFuncion: Option NCR,Devolucion;
        wEvento: DotNet ;


    procedure AbrirDia(codPrmTienda: Code[20]; codPrmTPV: Code[20]; datPrmFecha: Date; codPrmUsuario: Code[20])
    var
        Error001: Label 'El día ya está abierto.';
        recControlTPV: Record "Control de TPV";
        recTPV: Record "Configuracion TPV";
        recCajero: Record Cajeros;
        decFondo: Decimal;
        Error002: Label 'Debe cerrar el día %1 antes de abrir el actual.';
        Error003: Label 'El día %1 ya está cerrado. Debe reabrirlo un supervisor.';
        Error004: Label '¿Desea reabrir el día %1?';
        Error005: Label 'Solo se puede reabrir el día una vez.';
        Continuar: Boolean;
        Error006: Label 'Solo se puede reabrir el día %1 veces.';
        text001: Label 'El día que intenta abrir %1 es diferente a la Fecha Actual %2\¿Continuar?';
        recTiendas: Record Tiendas;
    begin

        recTiendas.Get(codPrmTienda);
        recTPV.Get(codPrmTienda, codPrmTPV);
        recCajero.Get(codPrmTienda, codPrmUsuario);

        //Comprueba que no este abierto el día
        if recControlTPV.Get(codPrmTienda, codPrmTPV, datPrmFecha) then
            if recControlTPV.Estado = recControlTPV.Estado::Abierto then
                Error(Error001);

        //Comprueba que no este abierto otro día
        recControlTPV.Reset;
        recControlTPV.SetRange("No. tienda", codPrmTienda);
        recControlTPV.SetRange("No. TPV", codPrmTPV);
        recControlTPV.SetRange(Estado, recControlTPV.Estado::Abierto);
        if recControlTPV.FindFirst then
            Error(Error002, recControlTPV.Fecha);

        //Si el día de trabajo esta cerrado, pide confirmación para abrirlo de nuevo
        if recControlTPV.Get(codPrmTienda, codPrmTPV, datPrmFecha) then begin
            case recCajero.Tipo of
                recCajero.Tipo::Cajero:
                    Error(Error003, datPrmFecha);
                recCajero.Tipo::Supervisor:
                    begin

                        if recTiendas."No. Reaperturas Permitidas" = 0 then begin
                            if recControlTPV."Usuario reapertura" <> '' then
                                Error(Error005);
                        end
                        else
                            if (recControlTPV."No. Reaperturas" + 1) > recTiendas."No. Reaperturas Permitidas" then
                                Error(StrSubstNo(Error006, recTiendas."No. Reaperturas Permitidas"));

                        if Confirm(Error004, false, datPrmFecha) then begin
                            if SolicitarMotivoReapertura(recControlTPV."Motivo reapertura") then begin
                                recControlTPV.Estado := recControlTPV.Estado::Abierto;
                                recControlTPV."Usuario reapertura" := recCajero.ID;
                                recControlTPV."Hora reapertura" := FormatTime(Time);
                                recControlTPV."No. Reaperturas" += 1;
                                recControlTPV.Modify;
                            end;
                        end;
                    end;
            end;
        end
        else begin

            if WorkDate <> Today then
                if not Confirm(StrSubstNo(text001, WorkDate, Today), false) then
                    exit;

            if PedirFondoDeCaja(decFondo) then begin
                recControlTPV.Init;
                recControlTPV."No. tienda" := recTPV.Tienda;
                recControlTPV."No. TPV" := recTPV."Id TPV";
                recControlTPV.Fecha := WorkDate;
                recControlTPV."Hora apertura" := FormatTime(Time);
                recControlTPV."Usuario apertura" := recCajero.ID;
                recControlTPV.Estado := recControlTPV.Estado::Abierto;
                recControlTPV.Insert(true);
                //Se abre el turno automáticamente cuando se abre el día.
                AbrirTurnoAuto(recControlTPV, decFondo);
            end;
        end;
    end;


    procedure CerrarDia(recPrmControl: Record "Control de TPV"; codPrmUsuario: Code[20])
    var
        recControlTPV: Record "Control de TPV";
        recControlTurno: Record "Turnos TPV";
        recDecCaja: Record "Lin. declaracion caja";
        Error001: Label 'El día ya está cerrado.';
        Error002: Label 'El turno %1 está abierto. Debe cerrarlo antes de cerrar el día.';
        recTrans: Record "Transacciones Caja TPV";
        decDescuadre: Decimal;
    begin

        with recPrmControl do begin

            recControlTPV.Reset;
            recControlTPV.SetRange("No. tienda", "No. tienda");
            recControlTPV.SetRange("No. TPV", "No. TPV");
            recControlTPV.SetRange(Fecha, Fecha);
            recControlTPV.SetRange(Estado, recControlTPV.Estado::Abierto);
            if not recControlTPV.FindFirst then
                Error(Error001);

            //Comprueba que no haya ningún turno abierto
            recControlTurno.Reset;
            recControlTurno.SetRange("No. tienda", "No. tienda");
            recControlTurno.SetRange("No. TPV", "No. TPV");
            recControlTurno.SetRange(Fecha, Fecha);
            recControlTurno.SetRange(Estado, recControlTurno.Estado::Abierto);
            if recControlTurno.FindFirst then
                Error(Error002, recControlTurno."No. turno");

            // El ultimo parametro borra
            EliminarBorradores("No. tienda", "No. TPV", true);

            recPrmControl."Hora cierre" := FormatTime(Time);
            recPrmControl."Usuario cierre" := codPrmUsuario;
            recPrmControl.Estado := recPrmControl.Estado::Cerrado;
            recPrmControl.Modify;

        end;
    end;


    procedure AbrirTurnoAuto(recPrmControl: Record "Control de TPV"; decPrmFondo: Decimal)
    var
        Error001: Label 'El día %1 no está abierto.';
        recControlDia: Record "Turnos TPV";
        recControlTurno: Record "Turnos TPV";
        Error002: Label 'El turno ya está abierto.';
    begin
        recControlTurno.Init;
        recControlTurno."No. tienda" := recPrmControl."No. tienda";
        recControlTurno."No. TPV" := recPrmControl."No. TPV";
        recControlTurno.Fecha := recPrmControl.Fecha;
        recControlTurno."Hora apertura" := recPrmControl."Hora apertura";
        recControlTurno."Usuario apertura" := recPrmControl."Usuario apertura";
        recControlTurno.Estado := recControlTurno.Estado::Abierto;
        recControlTurno.Insert(true);
        recControlTurno.ActualizarFondoCaja(recPrmControl."Usuario apertura", decPrmFondo);
    end;


    procedure AbrirTurno(codPrmTienda: Code[20]; codPrmTPV: Code[20]; codPrmFecha: Date; codPrmUsuario: Code[20])
    var
        Error001: Label 'El día %1 no está abierto.';
        recControlDia: Record "Control de TPV";
        recControlTurno: Record "Turnos TPV";
        decFondo: Decimal;
        Error002: Label 'El turno ya está abierto.';
    begin

        //Comprobar que el día esté abierto
        recControlDia.Reset;
        recControlDia.SetRange("No. tienda", codPrmTienda);
        recControlDia.SetRange("No. TPV", codPrmTPV);
        recControlDia.SetRange(Fecha, codPrmFecha);
        if recControlDia.FindFirst then begin
            if recControlDia.Estado <> recControlDia.Estado::Abierto then
                Error(Error001, codPrmFecha);
        end
        else
            Error(Error001, codPrmFecha);

        //comprobar que el turno no esté abierto
        recControlTurno.Reset;
        recControlTurno.SetRange("No. tienda", codPrmTienda);
        recControlTurno.SetRange("No. TPV", codPrmTPV);
        recControlTurno.SetRange(Fecha, codPrmFecha);
        recControlTurno.SetRange(Estado, recControlTurno.Estado::Abierto);
        if recControlTurno.FindFirst then
            Error(Error002);

        if PedirFondoDeCaja(decFondo) then begin
            recControlTurno.Init;
            recControlTurno."No. tienda" := codPrmTienda;
            recControlTurno."No. TPV" := codPrmTPV;
            recControlTurno.Fecha := WorkDate;
            recControlTurno."Hora apertura" := FormatTime(Time);
            recControlTurno."Usuario apertura" := codPrmUsuario;
            recControlTurno.Estado := recControlTurno.Estado::Abierto;
            recControlTurno.Insert(true);
            recControlTurno.ActualizarFondoCaja(codPrmUsuario, decFondo);
        end;
    end;


    procedure CerrarTurno(recPrmTurno: Record "Turnos TPV"; codPrmUsuario: Code[20]): Boolean
    var
        recTPV: Record "Configuracion TPV";
        recTienda: Record Tiendas;
        recDecCaja: Record "Lin. declaracion caja";
        Error001: Label 'El turno ya está cerrado.';
        Error002: Label 'El TPV %1 de la tienda %2 no esta asignado al usuario %3';
        Error003: Label 'El descuadre de la caja es superior al permitido.\Debe realziar la declaración de caja o el turno debe cerrarlo un Supervisor.';
        recTrans: Record "Transacciones Caja TPV";
        Error004: Label 'El usario de cierre no coincide con el usuario de apertura.\Usuario Apertura: %1 - Usuario Actual: %2';
        Text001: Label 'No se introducido fondo de caja ¿Desea continuar?';
        Text002: Label 'No sa ha registrado ninguna venta ¿Desea continuar?';
        recCajero: Record Cajeros;
        decDescuadre: Decimal;
        Text003: Label 'El descuadre de la caja es superior al permitido.\Como Supervisor puede continuar.\¿Desea Continuar?';
        continuar: Boolean;
        text005: Label 'Proceso cancelado';
        rFormPago: Record "Formas de Pago";
    begin

        //Comprueba que el usuario sea el que ha abierto el turno o un supervisor

        with recPrmTurno do begin

            //Comprueba que el turno no este cerrado
            if Estado = Estado::Cerrado then
                Error(Error001);

            recCajero.Get("No. tienda", codPrmUsuario);
            //Comprueba que el usuario de cierre sea el mismo que el usuario de apertura
            if recCajero.Tipo <> recCajero.Tipo::Supervisor then
                if "Usuario apertura" <> codPrmUsuario then
                    Error(Error004, "Usuario apertura", codPrmUsuario);

            //Comprueba que se haya introducido el fondo de caja.
            recTrans.Reset;
            recTrans.SetRange("Cod. tienda", "No. tienda");
            recTrans.SetRange("Cod. TPV", "No. TPV");
            recTrans.SetRange(Fecha, Fecha);
            recTrans.SetRange("No. turno", "No. turno");
            recTrans.SetRange("Tipo transaccion", recTrans."Tipo transaccion"::Fondo);
            if not recTrans.FindFirst then
                if not Confirm(Text001, false) then
                    exit;

            //Comprueba si hay transacciones y si no pide confirmación para cerrar
            recTrans.Reset;
            recTrans.SetRange("Cod. tienda", "No. tienda");
            recTrans.SetRange("Cod. TPV", "No. TPV");
            recTrans.SetRange(Fecha, Fecha);
            recTrans.SetRange("No. turno", "No. turno");
            recTrans.SetFilter("Tipo transaccion", '<>%1', recTrans."Tipo transaccion"::Fondo);
            if not recTrans.FindFirst then
                if not Confirm(Text002, false) then
                    exit;

            //Control de la declación de caja
            recTienda.Get("No. tienda");
            if recTienda."Control de caja" then begin

                recDecCaja.Reset;
                recDecCaja.SetRange("No. tienda", "No. tienda");
                recDecCaja.SetRange("No. TPV", "No. TPV");
                recDecCaja.SetRange(Fecha, Fecha);
                recDecCaja.SetRange("No. turno", "No. turno");
                if recDecCaja.FindSet then
                    repeat
                        rFormPago.Get(recDecCaja."Forma de pago");
                        if rFormPago."Realizar recuento" then
                            decDescuadre += recDecCaja.TraerDiferencia;
                    until recDecCaja.Next = 0;

                if Abs(decDescuadre) > recTienda."Descuadre maximo en caja" then begin
                    case recCajero.Tipo of
                        recCajero.Tipo::Cajero:
                            Error(Error003);
                        recCajero.Tipo::Supervisor:
                            if not Confirm(Text003, false) then
                                exit;
                    end;
                end;
            end;

            "Hora cierre" := FormatTime(Time);
            "Usuario cierre" := codPrmUsuario;
            Estado := Estado::Cerrado;
            Modify;
            exit(true);
        end;
    end;


    procedure ComprobarDeclaracionCaja()
    begin
    end;


    procedure MostrarFicha(recPrmControl: Record "Control de TPV")
    var
        frmFichaControl: Page "Declaracion de caja";
    begin
        frmFichaControl.SetRecord(recPrmControl);
        frmFichaControl.RunModal;
    end;


    procedure BuscarTPVUsuario(var recPrmTPV: Record "Configuracion TPV")
    var
        Error001: Label 'El usuario %1 no tiene asignado un TPV.';
    begin
        recPrmTPV.Reset;
        recPrmTPV.SetRange("Usuario windows", UserId);
        if not recPrmTPV.FindFirst then
            Error(Error001, UserId);
    end;


    procedure FormatTime(timEntrada: Time): Time
    var
        texHora: Text;
        timSalida: Time;
    begin
        texHora := Format(timEntrada);
        Evaluate(timSalida, texHora);
        exit(timSalida);
    end;


    procedure PedirFondoDeCaja(var decPrmFondo: Decimal): Boolean
    var
        frmFondo: Page "Dialogo fondo de caja";
    begin
        if frmFondo.RunModal = ACTION::Yes then begin
            decPrmFondo := frmFondo.TraerFondo;
            exit(true);
        end;
    end;


    procedure LoginCajero(codPrmTienda: Code[20]; var codPrmUsuario: Code[20]): Boolean
    var
        recGrupoCajeros: Record "Grupos Cajeros";
        recCajero: Record Cajeros;
        frmUserPass: Page "Dialogo Login";
        codUser: Code[20];
        texPass: Text[30];
        Error001: Label 'El Cajero %1 no existe para la tienda %2';
        Error002: Label 'La contraseña es incorrecta para el Cajero %1';
        Error003: Label 'El Cajero %1 no tiene configurado un Grupo de Cajero';
        Error004: Label 'El Grupo de Cajero %1 no existe';
        Error005: Label 'Defina un Cliente al Contado para el Grupo de Cajeros %1';
    begin

        if frmUserPass.RunModal = ACTION::Yes then begin

            frmUserPass.TraerDatos(codUser, texPass);

            if not recCajero.Get(codPrmTienda, codUser) then
                Error(Error001, codUser, codPrmTienda);

            if (LowerCase(recCajero.Contrasena) <> LowerCase(texPass)) then
                Error(Error002, codUser);

            if (recCajero."Grupo Cajero" = '') then
                Error(Error003, codUser);

            if not (recGrupoCajeros.Get(codPrmTienda, recCajero."Grupo Cajero")) then
                Error(Error004, recCajero."Grupo Cajero");

            if (recGrupoCajeros."Cliente al contado" = '') then
                Error(Error005, recCajero."Grupo Cajero");

            codPrmUsuario := codUser;

            exit(true);
        end;
    end;


    procedure ComprobarEstadoTPV(recPrmTPV: Record "Configuracion TPV"): Boolean
    var
        Error001: Label 'El día esta cerrado. Debe abrirlo desde control de TPVs.';
        recControlTPV: Record "Control de TPV";
        recControlTurnos: Record "Turnos TPV";
        Error002: Label 'No hay ningún turno abierto. Debe abrirlo desde control de TPVs.';
        Error003: Label 'El día Abierto para el TPV %1 es %2 , la fecha en la que intenta vender es %3\Cierre el día o cambie la fecha de trabajo';
    begin

        //El día debe estar abierto
        recControlTPV.Reset;
        recControlTPV.SetRange("No. tienda", recPrmTPV.Tienda);
        recControlTPV.SetRange("No. TPV", recPrmTPV."Id TPV");
        recControlTPV.SetRange(Fecha, WorkDate);
        recControlTPV.SetRange(Estado, recControlTPV.Estado::Abierto);
        if recControlTPV.FindFirst then begin
            //El turno debe estar abierto
            recControlTurnos.Reset;
            recControlTurnos.SetRange("No. tienda", recControlTPV."No. tienda");
            recControlTurnos.SetRange("No. TPV", recControlTPV."No. TPV");
            recControlTurnos.SetRange(Fecha, recControlTPV.Fecha);
            recControlTurnos.SetRange(Estado, recControlTPV.Estado::Abierto);
            if not recControlTurnos.FindFirst then
                Error(Error002);
        end
        else
            if ((DiaAbierto(recPrmTPV.Tienda, recPrmTPV."Id TPV") <> WorkDate) and
               (DiaAbierto(recPrmTPV.Tienda, recPrmTPV."Id TPV") <> 0D))
             then
                Error(Error003, recPrmTPV."Id TPV", DiaAbierto(recPrmTPV.Tienda, recPrmTPV."Id TPV"), WorkDate)
            else
                Error(Error001);
    end;


    procedure SolicitarMotivoReapertura(var texPrmMotivo: Text[60]): Boolean
    var
        frmMotivo: Page "Dialogo motivo";
        actAccion: Action;
        texMotivo: Text[60];
    begin
        repeat
            Clear(frmMotivo);
            actAccion := frmMotivo.RunModal;
            if actAccion = ACTION::OK then
                texMotivo := frmMotivo.TraerMotivo;
        until (texMotivo <> '') or (actAccion <> ACTION::OK);

        if actAccion = ACTION::OK then begin
            texPrmMotivo := texMotivo;
            exit(true);
        end
        else
            exit(false);
    end;


    procedure TraerTurnoActual(codPrmTienda: Code[20]; codPrmTPV: Code[20]; datPrmFecha: Date): Integer
    var
        recTurnos: Record "Turnos TPV";
    begin
        //Siempre es el turno abierto. Ya que no se puede utilizar otro turno hasta que se cierra.
        recTurnos.Reset;
        recTurnos.SetRange("No. tienda", codPrmTienda);
        recTurnos.SetRange("No. TPV", codPrmTPV);
        recTurnos.SetRange(Fecha, datPrmFecha);
        recTurnos.SetRange(Estado, recTurnos.Estado::Abierto);
        recTurnos.FindFirst;  //Dejo que de error ya que no se debería poder vender si no hay un turno abierto
        exit(recTurnos."No. turno");
    end;


    procedure UsuarioSuper(codPrmTienda: Code[20]; codPrmUsuario: Code[20]): Boolean
    var
        recCajero: Record Cajeros;
    begin
        recCajero.Get(codPrmTienda, codPrmUsuario);
        exit(recCajero.Tipo = recCajero.Tipo::Supervisor);
    end;


    procedure EliminarBorradores(codPrmTienda: Code[20]; codPrmTPV: Code[20]; CierreDia: Boolean)
    var
        recCabVta: Record "Sales Header";
        rec: Integer;
        rPagosTPV: Record "Pagos TPV";
        wDialog: Dialog;
        wNreg: Decimal;
        wTotalRegs: Decimal;
        Text001: Label 'Limpiando registros obsoletos @1@@@@@@@@@@@@';
    begin

        recCabVta.Reset;
        recCabVta.SetRange("Venta TPV", true);
        recCabVta.SetRange(Tienda, codPrmTienda);
        recCabVta.SetRange(TPV, codPrmTPV);
        recCabVta.SetRange("Registrado TPV", false);

        if not (CierreDia) then
            recCabVta.SetRange(Aparcado, false);

        if recCabVta.FindSet then begin
            wTotalRegs := recCabVta.Count;
            wNreg := 0;
            wDialog.Open(Text001);
            repeat
                rPagosTPV.Reset;
                rPagosTPV.SetRange("No. Borrador", recCabVta."No.");
                rPagosTPV.DeleteAll;
                recCabVta."Posting No." := '';
                recCabVta."Posting No. Series" := '';
                recCabVta.Modify(false);
                recCabVta.Delete(true);
                wNreg += 1;
                wDialog.Update(1, Round((wNreg / wTotalRegs) * 10000, 1));
            until recCabVta.Next = 0;
            wDialog.Close;
        end;
    end;


    procedure DiaAbierto(pTienda: Code[20]; pTpv: Code[20]): Date
    var
        recControlTPV: Record "Control de TPV";
    begin

        recControlTPV.Reset;
        recControlTPV.SetRange("No. tienda", pTienda);
        recControlTPV.SetRange("No. TPV", pTpv);
        recControlTPV.SetRange(Estado, recControlTPV.Estado::Abierto);
        if recControlTPV.FindFirst then
            exit(recControlTPV.Fecha)
    end;


    procedure Parametros(codPrmTienda: Code[20]; codPrmTPV: Code[20]; codPrmCajero: Code[20]; codPrmDoc: Code[20])
    begin
        //+#118629
        wcodPrmTienda := codPrmTienda;
        wcodPrmTPV := codPrmTPV;
        wcodPrmCajero := codPrmCajero;
        wcodPrmDoc := codPrmDoc;

        wCodFuncion := wCodFuncion::NCR; //+#381937
    end;


    procedure RetornoValores(var vRespuesta: Text)
    begin
        //+#144756
        vRespuesta := wRespuesta;
    end;


    procedure Parametros_Devolucion(p_Evento: DotNet )
    begin
        //+#381937
        wEvento := p_Evento;
        wCodFuncion := wCodFuncion::Devolucion;
    end;
}*/

