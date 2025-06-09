codeunit 76011 "Funciones Addin DSPos"
{
    // #118629 RRT,  22.02.2018: Si se produce un error en la anulación se estaba grabando un NCR de forma incorrecta.
    // #144756 RRT,  11.09.2018: Mejora en el cambio anterior para que la anulación se sincronice correctamente con DS-POS.
    // #116527 RRT,  07/11/2018: Adaptaciones para unificación de los objetos en todos los paises
    // #184407 RRT,  04.12.18: Actualización DS-POS. Se han renumerado varios campos que estaban en el rango de objetos comunes DS-POS
    // #70132  RRT,  10.07.2018: Permitir realizar pagos con NCR.
    // #232158 RRT,  12.06.2019: Actualización DS-POS..
    // #355717 RRT,  10.02.2021: Error detectado que impedia poder seleccionar un TPV.
    // #381937 RRT,  31.05.2021: Correcciones.
    // #373762 RRT,  27.05.2021: Llamada a la función de aplicación de descuentos por forma de pago.


    trigger OnRun()
    var

    begin
        //+#121213
        //... Aprovechamos que el evento OnRun() no estaba "ocupado", para tener controlado el registro.
        w_OkRegistro := false;
        /*     if lcFuncComunes.Registrar(w_Evento, w_Resultado) then
                w_OkRegistro := true; */
        //-#121213
    end;

    var
        /*  cDominicana: Codeunit "Funciones DsPOS - Dominicana";
         cBolivia: Codeunit "Funciones DsPOS - Bolivia";
         cEcuador: Codeunit "Funciones DsPOS - Ecuador";
         cParaguay: Codeunit "Funciones DsPOS - Paraguay";
         cGuatemala: Codeunit "Funciones DsPOS - Guatemala";
         cSalvador: Codeunit "Funciones DsPOS - Salvador";
         cHonduras: Codeunit "Funciones DsPOS - Honduras";
         cCostaRica: Codeunit "Funciones DsPOS - Costa Rica";
         /*    w_Evento: DotNet ;
            w_Resultado: DotNet ; */
        w_OkRegistro: Boolean;


    procedure Comprobaciones_Iniciales()
    var
        rConfGeneral: Record "Configuracion General DsPOS";
        rTiendas: Record Tiendas;
        rConfTPV: Record "Configuracion TPV";
        //dsFunciones: DotNet ;
        Respuesta: Text;
        Resultado: Integer;
        rMenu: Record "Menus TPV";
        Error001: Label 'No existe Configuración General DSPoS.';
        Error002: Label 'Proceso cancelado a petición del usuario.';
        Error003: Label 'Debe Asignar un TPV a este equipo.\Imposible Continuar';
        Error005: Label 'Debe Especificar País en Configuración General DSPoS';
        Error006: Label 'Debe Registrar el Addin (Importarlo desde navision)';
        Error007: Label 'El día abierto para el TPV es %1\Debe cerrarlo o cambiar la fecha de trabajo del sistema';
        Text001: Label 'Es la primera vez que ejecuta DSPoS con este usuario\Debe seleccionar un TPV\A continuación se mostrará una lista de TPVs\\¿Continuar?';

    begin

        RegistrarAddin;
        CrearAcciones;

        if not rConfGeneral.Get() then
            Error(Error001);

        rConfGeneral.TestField(Pais);

        rConfTPV.Reset;
        rConfTPV.SetCurrentKey("Usuario windows");
        rConfTPV.SetRange("Usuario windows", TraerUsuarioWindows);
        if not rConfTPV.FindSet then begin
            if not Confirm(Text001, false) then
                Error(Error002);

            /*   if IsNull(dsFunciones) then
                  dsFunciones := dsFunciones.Funciones;

              dsFunciones.RecibirDatosBD(ServidorBBDD(1), ServidorBBDD(0), CompanyName);
              Respuesta := dsFunciones.SeleccionTPV();

              if Respuesta = '' then
                  Error(Error003);

              LeerRespuesta(Respuesta);
              Clear(dsFunciones); */
        end;

        rTiendas.Get(TiendaActual);
        rTiendas.TestField("Cod. Almacen");
        rTiendas.TestField("ID Reporte contado");
        rTiendas.TestField("Cantidad de Copias Contado");

        rConfGeneral.TestField("Nombre Divisa Local");
        rConfTPV.Get(TiendaActual, TpvActual);
        rConfTPV.TestField("Menu de acciones");
        rConfTPV.TestField("Menu de Formas de Pago");
        rConfTPV.TestField("No. serie Facturas");
        rConfTPV.TestField("No. serie facturas Reg.");

        if rTiendas."Permite Anulaciones en POS" then begin
            rTiendas.TestField("ID Reporte nota credito");
            rTiendas.TestField("Cantidad de Copias Credito");
            rConfTPV.TestField("No. serie notas credito");
            rConfTPV.TestField("No. serie notas credito reg.");
        end;

        Comprobar_Estado(rConfTPV);
        Comprobar_FormPagos(rConfTPV);
        Comprobar_Botones(rConfTPV."Menu de Formas de Pago", rConfTPV."Menu de acciones");
        Comprobar_Minimos(rConfTPV."Menu de acciones");
        Comprobar_Bancos(rConfTPV);

        /*  case rConfGeneral.Pais of
             rConfGeneral.Pais::"Republica Dominicana":
                 cDominicana.Comprobaciones_Iniciales(TiendaActual, TpvActual);
             rConfGeneral.Pais::Bolivia:
                 cBolivia.Comprobaciones_Iniciales(TiendaActual, TpvActual);
             rConfGeneral.Pais::Paraguay:
                 cParaguay.Comprobaciones_Iniciales(TiendaActual, TpvActual);
             rConfGeneral.Pais::Ecuador:
                 cEcuador.Comprobaciones_Iniciales(TiendaActual, TpvActual);
             rConfGeneral.Pais::Guatemala:
                 cGuatemala.Comprobaciones_Iniciales(TiendaActual, TpvActual);
             rConfGeneral.Pais::Salvador:
                 cSalvador.Comprobaciones_Iniciales(TiendaActual, TpvActual);
             rConfGeneral.Pais::Honduras:
                 cHonduras.Comprobaciones_Iniciales(TiendaActual, TpvActual);
             rConfGeneral.Pais::"Costa Rica":
                 cCostaRica.Comprobaciones_Iniciales(TiendaActual, TpvActual);  //+#148807
         end; */

        /*   if cControl.DiaAbierto(rTiendas."Cod. Tienda", rConfTPV."Id TPV") <> WorkDate then
              Error(Error007, cControl.DiaAbierto(rTiendas."Cod. Tienda", rConfTPV."Id TPV")); */
    end;


    procedure Comprobar_FormPagos(prConfTPV: Record "Configuracion TPV")
    var
        rFormPago: Record "Formas de Pago";
        wLocal: Boolean;
        Error001: Label 'Debe Definir una forma de Pago Cash para Divisa Local';
        Error002: Label 'Debe Definir un Icono para la forma de pago %1';
        rTarj: Record "Tipos de Tarjeta";
        Error003: Label 'Debe Definir un Icono para el tipo Tarjeta %1';
        lrConf: Record "Configuracion General DsPOS";
        lComprobarIdPago: Boolean;
    begin

        rFormPago.Reset;
        rFormPago.SetRange("Efectivo Local", true);
        if not rFormPago.FindFirst then
            Error(Error001);

        //Actualizamos los iconos replicados
        rFormPago.Reset;
        if rFormPago.FindSet then
            repeat
                rFormPago.CalcFields("Icono Nav");
                if rFormPago."Icono Nav".HasValue then begin
                    rFormPago.Icono := rFormPago."Icono Nav";
                    rFormPago.Modify;
                end;
            until rFormPago.Next = 0;

        //+#116527
        lComprobarIdPago := false;
        if lrConf.FindFirst then
            lComprobarIdPago := (lrConf.Pais = lrConf.Pais::Honduras) or (lrConf.Pais = lrConf.Pais::Guatemala);
        //-#116527

        rFormPago.Reset;
        if rFormPago.FindSet then
            repeat
                rFormPago.CalcFields(Icono);
                if not rFormPago.Icono.HasValue then
                    if (not lComprobarIdPago) or (rFormPago."ID Pago" <> 'EXIVA') then   //#116527
                        if PagoEstaActivo(prConfTPV."Menu de Formas de Pago", rFormPago."ID Pago") or
                           (rFormPago."Efectivo Local") or (rFormPago."Tipo Tarjeta" <> '') then
                            Error(StrSubstNo(Error002, rFormPago."ID Pago"));
            until rFormPago.Next = 0;
    end;


    procedure Comprobar_Botones(MenuPagos: Code[10]; MenuAcciones: Code[10])
    var
        rBotones: Record Botones;
    begin

        rBotones.Reset;
        rBotones.SetFilter("ID Menu", MenuPagos + '|' + MenuAcciones);
        if rBotones.FindSet then
            repeat
                if rBotones.Activo then begin
                    rBotones.TestField(Etiqueta);
                    if rBotones."ID Menu" = MenuPagos then
                        rBotones.TestField(Pago)
                    else
                        rBotones.TestField(Accion);
                end;
            until rBotones.Next = 0;
    end;


    procedure Comprobar_Minimos(IdMenu: Code[10])
    var
        rAcciones: Record Acciones;
        rBotones: Record Botones;
        Error001: Label 'La accion obligatoria %1 no se encuentra en el menu acciones %2 ó no esta marcada como Activa';
        lwError: Boolean;
    begin

        rAcciones.Reset;
        rAcciones.SetCurrentKey("Tipo Accion");
        rAcciones.SetRange("Tipo Accion", rAcciones."Tipo Accion"::Obligatoria);
        if rAcciones.FindSet then begin
            rBotones.SetCurrentKey(Accion);
            repeat
                rBotones.SetRange("ID Menu", IdMenu);
                rBotones.SetRange(Accion, rAcciones."ID Accion");
                if not rBotones.FindFirst then begin

                    rBotones.Init;
                    rBotones."ID Menu" := IdMenu;
                    rBotones.Descripcion := rAcciones.Descripcion;
                    rBotones.Accion := rAcciones."ID Accion";
                    rBotones.Etiqueta := UpperCase(rAcciones.Descripcion);
                    rBotones.Color := 0;
                    rBotones.Activo := true;
                    rBotones."Descuento %" := 0;
                    rBotones.Seguridad := rBotones.Seguridad::" ";
                    rBotones.Pago := '';
                    rBotones.Tipo := rBotones.Tipo::" ";
                    rBotones."No." := '';
                    rBotones."Tipo Accion" := rAcciones."Tipo Accion"::Obligatoria;
                    rBotones.Orden := 0;

                    rBotones.Insert(true);

                end
            until rAcciones.Next = 0;
        end;
    end;


    procedure PagoEstaActivo(pMenu: Code[10]; pFPago: Code[20]): Boolean
    var
        rBotones: Record Botones;
    begin

        rBotones.Reset;
        rBotones.SetRange(Pago, pFPago);
        rBotones.SetRange("ID Menu", pMenu);
        if not rBotones.FindFirst then
            exit(false)
        else
            exit(rBotones.Activo);
    end;


    procedure Comprobar_Bancos(recPrmCfgTPV: Record "Configuracion TPV")
    var
        recBotones: Record Botones;
        recFormPago: Record "Formas de Pago";
        recBancosTienda: Record "Bancos tienda";
        Error001: Label 'Debe configurar una cuenta de banco para la tienda %1 con divisa local';
        Error002: Label 'Debe configurar una cuenta de banco para la tienda %1 con divisa %2';
    begin

        recBancosTienda.Reset;
        recBancosTienda.SetRange("Cod. Tienda", recPrmCfgTPV.Tienda);
        recBancosTienda.SetRange("Cod. Divisa", '');
        if not recBancosTienda.FindFirst then
            Error(Error001, recPrmCfgTPV.Tienda);

        recBotones.Reset;
        recBotones.SetRange("ID Menu", recPrmCfgTPV."Menu de Formas de Pago");
        recBotones.SetRange(Activo, true);
        recBotones.SetFilter(Pago, '<>%1', '');
        if recBotones.FindSet then
            repeat
                recFormPago.Get(recBotones.Pago);
                if recFormPago."Cod. divisa" <> '' then begin
                    recBancosTienda.Reset;
                    recBancosTienda.SetRange("Cod. Tienda", recPrmCfgTPV.Tienda);
                    recBancosTienda.SetRange("Cod. Divisa", recFormPago."Cod. divisa");
                    if not recBancosTienda.FindFirst then
                        Error(Error002, recPrmCfgTPV.Tienda, recFormPago."Cod. divisa");
                end;
            until recBotones.Next = 0;
    end;


    procedure ServidorBBDD(pOpcion: Integer): Text[100]
    var
        /*        rDataBase: Record Database;
               rServer: Record "Server Instance"; */
        rSession: Record Session;
        rConfTPV: Record "Configuracion TPV";
        rTiendas: Record Tiendas;
        lValor: Text[250];
    begin


        case pOpcion of
            0:
                begin

                    rConfTPV.Reset;
                    rConfTPV.SetCurrentKey("Usuario windows");
                    rConfTPV.SetRange("Usuario windows", TraerUsuarioWindows);
                    if rConfTPV.FindSet() then begin
                        rTiendas.Get(rConfTPV.Tienda);
                        if rTiendas."Instancia Completa SQL" <> '' then
                            exit(rTiendas."Instancia Completa SQL")
                    end;

                    /* rServer.Reset;
                    rServer.FindFirst;
                    //+#355717
                    //... Este valor puede no ser adecuado. Intentaremos obtenerlo de otra forma.
                    //... (Caso en que instancia es DESKTOP-INFLQHN\SQLEXPRESS y en cambio el nombre del equipo es DESKTOP-INFLQHN)
                    //EXIT(rServer."Server Computer Name");
                    lValor := CopyStr(rServer."Server Computer Name", 1, StrLen(rServer."Server Computer Name") - 1); */
                    rTiendas.Reset;
                    rTiendas.SetFilter("Instancia Completa SQL", lValor + '*');
                    if rTiendas.FindFirst then
                        exit(rTiendas."Instancia Completa SQL")
                    else
                        exit(lValor);
                    //-#355717

                end;
            1:
                begin
                    /*          rDataBase.Reset;
                             rDataBase.SetRange("My Database", true);
                             rDataBase.FindFirst;
                             exit(rDataBase."Database Name"); */
                end;
        end;
    end;


    procedure LeerRespuesta(pRespuesta: Text) Resultado: Text
    var
        /*  ConstructorEventos: DotNet ;
         Evento: DotNet ; */
        /*   cFuncComunes: Codeunit "Funciones DsPOS - Comunes";
          lcAnular: Codeunit "Control TPV"; */
        TextL001: Label 'No se ha podido realizar la anulación. Salga de la pantalla de anulación e intentélo en unos segundos';
        lOk: Boolean;
        /*  EventoError: DotNet ; */
        TextL002: Label 'No se ha podido realizar la devolución debido al error indicado. Al volver a la pantalla de ventas hay que pulsar la opción NUEVA VENTA,  para poder iniciar una nueva venta.';
    begin

        Resultado := '';

        if pRespuesta = '' then
            exit;

        //MESSAGE(pRespuesta);

        /*   if IsNull(ConstructorEventos) then
              ConstructorEventos := ConstructorEventos.Evento();

          Evento := ConstructorEventos.deXML(pRespuesta);

          case Evento.TipoEvento of
              0:
                  ;
              1:
                  AsignarTPV(Evento.TextoDato, Evento.TextoDato2);
              2:
                  Resultado := ComprobarLogin(Evento.TextoDato, Evento.TextoDato2);
              6:
                  Resultado := cFuncComunes.Nueva_Venta(Evento.TextoDato, Evento.TextoDato2, Evento.TextoDato3, false);
              7:
                  Resultado := cFuncComunes.Insertar_Producto(Evento.TextoDato4, Evento.TextoDato, Evento.TextoDato2, Evento.TextoDato3, Evento.DatoDecimal);
              8:
                  Resultado := cFuncComunes.Ejecutar_Accion(Evento);
              9:
                  Resultado := cFuncComunes.Insertar_Pago(Evento);

              //+#118629
              //10: Resultado := cFuncComunes.AnularFactura(Evento.TextoDato,Evento.TextoDato2,Evento.TextoDato5,Evento.TextoDato3);
              10:
                  begin
                      ClearLastError;

                      Commit;  //+#148807

                      lcAnular.Parametros(Evento.TextoDato, Evento.TextoDato2, Evento.TextoDato5, Evento.TextoDato3);

                      //+#144756
                      lOk := lcAnular.Run;
                      lcAnular.RetornoValores(Resultado);
                      //IF NOT lcAnular.RUN THEN BEGIN
                      if not lOk then begin
                          //-#144756


                          //+#381937
                          if IsNull(EventoError) then
                              EventoError := EventoError.Evento();

                          EventoError.AccionRespuesta := 'ERROR';
                          EventoError.TextoRespuesta := GetLastErrorText;
                          Resultado := EventoError.aXml();
                          //-#391937

                          //+#121213
                          //... Registramos el error.
                          cFuncComunes.RegistrarError(2, Evento.TextoDato, Evento.TextoDato2, Evento.TextoDato3, GetLastErrorText);
                          //-#121213

                          //+#RRT
                          //... Se notifica el error via DsPos.
                          //MESSAGE(GETLASTERRORTEXT);
                          //-#RRT



                          //+#144756
                          //EXIT;
                          //EXIT(Resultado);  //#RRT
                          //-#144756

                      end;
                  end;
              //-#118629

              12:
                  Resultado := cFuncComunes.Eliminar_Pago(Evento);
              13:
                  Resultado := cFuncComunes.Nueva_Venta(Evento.TextoDato, Evento.TextoDato2, Evento.TextoDato3, true);
              14:
                  Resultado := cFuncComunes.ActualizarDivisas(Evento.TextoDato, Evento.TextoDato2);
              15:
                  Resultado := cFuncComunes.PrecioDisponibilidad(Evento);

              //+#381937
              //16: Resultado := cFuncComunes.Crear_Devolucion(Evento);
              16:
                  begin
                      ClearLastError;
                      Commit;
                      lcAnular.Parametros_Devolucion(Evento);
                      lOk := lcAnular.Run;
                      lcAnular.RetornoValores(Resultado);
                      if not lOk then begin
                          if IsNull(EventoError) then
                              EventoError := EventoError.Evento();

                          EventoError.AccionRespuesta := 'ERROR';
                          EventoError.TextoRespuesta := GetLastErrorText + ' ' + TextL002;
                          Resultado := EventoError.aXml();

                          //... Registramos el error.
                          cFuncComunes.RegistrarError(8, Evento.TextoDato, Evento.TextoDato2, Evento.TextoDato3, GetLastErrorText);
                      end;
                  end;
              //-#381937


              17:
                  Resultado := cFuncComunes.Imprimir(Evento.TextoDato, Evento.TextoDato3);
              18:
                  Resultado := cFuncComunes.ValidaIDCliente(Evento.TextoDato6, Evento.IntDato1);
              19:
                  Resultado := ComprobarSupervisor(Evento.TextoDato);
              20:
                  Resultado := cFuncComunes.Devolver_Datos_Localizados(Evento);
              21:
                  Resultado := cFuncComunes.Desaparcar_Pedido(Evento.TextoDato5);
              22:
                  Resultado := cFuncComunes.ImportePropuestoPagoNCR(Evento); //+#70132
              23:
                  Resultado := cFuncComunes.Actualiza_Venta_Contacto(Evento.TextoDato3, Evento.TextoDato4);


              //+#373762
              //... Usado en Ecuador para aplicar o retroceder los descuentos programados por forma de pago.
              25:
                  Resultado := cFuncComunes.RevisarAplicacionDescuentos(Evento);
              26:
                  Resultado := cFuncComunes.RetrocederAplicacionDescuentos(Evento);
          //-#373762


          end;
   */
        Commit;
        exit(Resultado);
    end;


    procedure AsignarTPV(pTPV: Code[20]; pTienda: Code[20])
    var
        rConfTPV: Record "Configuracion TPV";
    begin

        rConfTPV.Get(pTienda, pTPV);
        rConfTPV."Usuario windows" := TraerUsuarioWindows;
        rConfTPV.Modify;
    end;


    procedure ComprobarLogin(pUsuario: Code[20]; pPassword: Text[30]): Text
    var
        rCaj: Record Cajeros;
        rTie: Record Tiendas;
        rConf: Record "Configuracion General DsPOS";
        Error001: Label 'El Cajero %1 no existe para la tienda %2';
        Error002: Label 'La clave es incorrecta para el Cajero %1';
        /*         ConstructorEventos: DotNet ;
                Evento: DotNet ; */
        NumError: Integer;
        Error003: Label 'El Cajero %1 no tiene configurado un Grupo de Cajero';
        rGrupoCaj: Record "Grupos Cajeros";
        Error004: Label 'El Grupo de Cajero %1 no existe';
        Error005: Label 'Defina un Cliente al Contado para el Grupo de Cajeros %1';
    begin

        /*   NumError := 0;
          case true of
              not rCaj.Get(TiendaActual, pUsuario):
                  NumError := 1;
              (LowerCase(rCaj.Contrasena) <> LowerCase(pPassword)) and (NumError = 0):
                  NumError := 2;
              (rCaj."Grupo Cajero" = '') and (NumError = 0):
                  NumError := 3;
              not (rGrupoCaj.Get(TiendaActual, rCaj."Grupo Cajero")) and (NumError = 0):
                  NumError := 4;
              (rGrupoCaj."Cliente al contado" = '') and (NumError = 0):
                  NumError := 5;
          end;

          if IsNull(Evento) then
              Evento := Evento.Evento;

          Evento.TipoEvento := 2;
          if NumError <> 0 then
              Evento.AccionRespuesta := 'ERROR';

          case NumError of
              1:
                  Evento.TextoRespuesta := StrSubstNo(Error001, pUsuario, TiendaActual);
              2:
                  Evento.TextoRespuesta := StrSubstNo(Error002, pUsuario);
              3:
                  Evento.TextoRespuesta := StrSubstNo(Error003, pUsuario);
              4:
                  Evento.TextoRespuesta := StrSubstNo(Error004, rCaj."Grupo Cajero");
              5:
                  Evento.TextoRespuesta := StrSubstNo(Error005, rCaj."Grupo Cajero");
          end;

          if NumError = 0 then begin
              Evento.TextoDato := TpvActual;
              Evento.TextoDato2 := rGrupoCaj."Cliente al contado";
              Evento.TextoDato3 := pUsuario;
              Evento.TextoDato4 := TiendaActual;
              Evento.IntDato1 := cfComunes.Pais();
              Evento.IntDato2 := cControl.TraerTurnoActual(Evento.TextoDato4, Evento.TextoDato, WorkDate);

              //+#232158
              //... Las series NCF dejan de usarse en Guatemala.
              /*
              //... Al volver a entrar en el TPV, hay que actualizar las series NCF para su correcta visualización en la pantalla.
              CASE Evento.IntDato1 OF
                5: lcGuatemala.GestionSeriesNCF_TPV(TiendaActual,TpvActual);
              END;

              //-#232158


          end;
          */

        //exit(Evento.aXml());

    end;


    procedure TiendaActual(): Code[20]
    var
        rConf: Record "Configuracion General DsPOS";
        rTPV: Record "Configuracion TPV";
    begin

        rTPV.Reset;
        rTPV.SetCurrentKey(Tienda, "Usuario windows");
        rTPV.SetRange("Usuario windows", TraerUsuarioWindows);
        rTPV.FindFirst;
        exit(rTPV.Tienda);
    end;


    procedure TpvActual(): Code[20]
    var
        rConf: Record "Configuracion General DsPOS";
        rTiendas: Record Tiendas;

        Equipo: Text;
        rTPV: Record "Configuracion TPV";
    begin

        rTPV.Reset;
        rTPV.SetCurrentKey(Tienda, "Usuario windows");
        rTPV.SetRange("Usuario windows", TraerUsuarioWindows);
        rTPV.FindFirst;
        exit(rTPV."Id TPV");
    end;


    procedure CrearAcciones()
    var
        accion1: Label 'CAMBCANT|Cambiar Cantidad';
        accion2: Label 'CAMBPREC|Cambiar Precio';
        accion3: Label 'DTOGENERAL|Descuento General Pedido';
        accion4: Label 'ANULARLINEA|Anular Linea';
        accion5: Label 'NUEVOPEDIDO|Nuevo Pedido';
        accion6: Label 'ANULARPEDIDO|Anular Pedido';
        accion7: Label 'REGISTRAR|Registrar Pedido';
        rAcciones: Record Acciones;
        Pos: Integer;
        accion8: Label 'DTOLINEA|Descuento Linea';
        accion9: Label 'CUPON|Insertar Cupon';
        accion10: Label 'APARCARPEDIDO|Aparcar pedido';
        accion11: Label 'ELIMINARCUPON|Eliminar Cupon';
        accion12: Label 'REIMPRIMIR|Reimprimir Históricos';
        accion13: Label 'EXIVA|Exención de IVA';
        Text001: Label 'Indique la Cantidad:';
        Text002: Label 'Indique el Precio:';
        Text003: Label 'Indique el % de Descuento:';
        rConf: Record "Configuracion General DsPOS";
        text004: Label 'Indique el Nº de Cupón';
        text005: Label 'Eliminar el cupón actual';
        text006: Label 'Introduzca Nº Exención IVA';
    begin

        rConf.Get;
        rConf.TestField(Pais);

        Pos := StrPos(accion1, '|');
        rAcciones.Reset;
        rAcciones.Init;
        rAcciones."ID Accion" := CopyStr(accion1, 1, Pos - 1);
        rAcciones.Descripcion := CopyStr(accion1, Pos + 1);
        rAcciones."Tipo Accion" := rAcciones."Tipo Accion"::"Acción Línea";
        rAcciones."Necesita Datos" := true;
        rAcciones."Tipo Datos" := rAcciones."Tipo Datos"::Numerico;
        rAcciones."Literal Pedir Datos" := Text001;
        if rAcciones.Insert then;

        Pos := StrPos(accion2, '|');
        rAcciones.Reset;
        rAcciones.Init;
        rAcciones."ID Accion" := CopyStr(accion2, 1, Pos - 1);
        rAcciones.Descripcion := CopyStr(accion2, Pos + 1);
        rAcciones."Tipo Accion" := rAcciones."Tipo Accion"::"Acción Línea";
        rAcciones."Necesita Datos" := true;
        rAcciones."Tipo Datos" := rAcciones."Tipo Datos"::Numerico;
        rAcciones."Literal Pedir Datos" := Text002;
        if rAcciones.Insert then;

        Pos := StrPos(accion3, '|');
        rAcciones.Reset;
        rAcciones.Init;
        rAcciones."ID Accion" := CopyStr(accion3, 1, Pos - 1);
        rAcciones.Descripcion := CopyStr(accion3, Pos + 1);
        rAcciones."Tipo Accion" := rAcciones."Tipo Accion"::"Acción";
        rAcciones."Necesita Datos" := true;
        rAcciones."Tipo Datos" := rAcciones."Tipo Datos"::Numerico;
        rAcciones."Literal Pedir Datos" := Text003;
        if rAcciones.Insert then;

        Pos := StrPos(accion4, '|');
        rAcciones.Reset;
        rAcciones.Init;
        rAcciones."ID Accion" := CopyStr(accion4, 1, Pos - 1);
        rAcciones.Descripcion := CopyStr(accion4, Pos + 1);
        rAcciones."Tipo Accion" := rAcciones."Tipo Accion"::"Acción Línea";
        if rAcciones.Insert then;

        Pos := StrPos(accion5, '|');
        rAcciones.Reset;
        rAcciones.Init;
        rAcciones."ID Accion" := CopyStr(accion5, 1, Pos - 1);
        rAcciones.Descripcion := CopyStr(accion5, Pos + 1);
        rAcciones."Tipo Accion" := rAcciones."Tipo Accion"::Obligatoria;
        if rAcciones.Insert then;

        Pos := StrPos(accion6, '|');
        rAcciones.Reset;
        rAcciones.Init;
        rAcciones."ID Accion" := CopyStr(accion6, 1, Pos - 1);
        rAcciones.Descripcion := CopyStr(accion6, Pos + 1);
        rAcciones."Tipo Accion" := rAcciones."Tipo Accion"::"Acción";
        if rAcciones.Insert then;

        Pos := StrPos(accion7, '|');
        rAcciones.Reset;
        rAcciones.Init;
        rAcciones."ID Accion" := CopyStr(accion7, 1, Pos - 1);
        rAcciones.Descripcion := CopyStr(accion7, Pos + 1);
        rAcciones."Tipo Accion" := rAcciones."Tipo Accion"::Obligatoria;
        if rAcciones.Insert then;

        Pos := StrPos(accion8, '|');
        rAcciones.Reset;
        rAcciones.Init;
        rAcciones."ID Accion" := CopyStr(accion8, 1, Pos - 1);
        rAcciones.Descripcion := CopyStr(accion8, Pos + 1);
        rAcciones."Tipo Accion" := rAcciones."Tipo Accion"::"Acción Línea";
        rAcciones."Necesita Datos" := true;
        rAcciones."Tipo Datos" := rAcciones."Tipo Datos"::Numerico;
        rAcciones."Literal Pedir Datos" := Text003;
        if rAcciones.Insert then;

        Pos := StrPos(accion10, '|');
        rAcciones.Reset;
        rAcciones.Init;
        rAcciones."ID Accion" := CopyStr(accion10, 1, Pos - 1);
        rAcciones.Descripcion := CopyStr(accion10, Pos + 1);
        rAcciones."Tipo Accion" := rAcciones."Tipo Accion"::Obligatoria;
        if rAcciones.Insert then;

        Pos := StrPos(accion12, '|');
        rAcciones.Reset;
        rAcciones.Init;
        rAcciones."ID Accion" := CopyStr(accion12, 1, Pos - 1);
        rAcciones.Descripcion := CopyStr(accion12, Pos + 1);
        rAcciones."Tipo Accion" := rAcciones."Tipo Accion"::"Acción";
        if rAcciones.Insert then;

        case rConf.Pais of
            rConf.Pais::Bolivia,
            rConf.Pais::Guatemala,
            rConf.Pais::Salvador:
                begin

                    Pos := StrPos(accion9, '|');
                    rAcciones.Reset;
                    rAcciones.Init;
                    rAcciones."ID Accion" := CopyStr(accion9, 1, Pos - 1);
                    rAcciones.Descripcion := CopyStr(accion9, Pos + 1);
                    rAcciones."Tipo Accion" := rAcciones."Tipo Accion"::"Acción";
                    rAcciones."Necesita Datos" := true;
                    rAcciones."Tipo Datos" := rAcciones."Tipo Datos"::Texto;
                    rAcciones."Literal Pedir Datos" := text004;
                    if rAcciones.Insert then;

                    Pos := StrPos(accion11, '|');
                    rAcciones.Reset;
                    rAcciones.Init;
                    rAcciones."ID Accion" := CopyStr(accion11, 1, Pos - 1);
                    rAcciones.Descripcion := CopyStr(accion11, Pos + 1);
                    rAcciones."Tipo Accion" := rAcciones."Tipo Accion"::"Acción";
                    rAcciones."Necesita Datos" := true;
                    rAcciones."Tipo Datos" := rAcciones."Tipo Datos"::Texto;
                    rAcciones."Literal Pedir Datos" := text005;
                    if rAcciones.Insert then;

                    //+#232158
                    if rConf.Pais = rConf.Pais::Guatemala then begin

                        Pos := StrPos(accion13, '|');
                        rAcciones.Reset;
                        rAcciones.Init;
                        rAcciones."ID Accion" := CopyStr(accion13, 1, Pos - 1);
                        rAcciones.Descripcion := CopyStr(accion13, Pos + 1);
                        rAcciones."Tipo Accion" := rAcciones."Tipo Accion"::"Acción";
                        rAcciones."Necesita Datos" := true;
                        rAcciones."Tipo Datos" := rAcciones."Tipo Datos"::Texto;
                        rAcciones."Literal Pedir Datos" := text006;
                        if rAcciones.Insert then;

                    end;
                    //-#232158

                end;
        end;
    end;


    procedure TraerUsuarioWindows(): Text[64]
    var
        recSesion: Record Session;
    begin

        recSesion.Reset;
        recSesion.SetRange("My Session", true);
        recSesion.FindFirst;
        exit(recSesion."User ID");
    end;


    procedure Comprobar_Estado(recPrmTPV: Record "Configuracion TPV")
    var
    /*         cduControl: Codeunit "Control TPV"; */
    begin
        /*     cduControl.ComprobarEstadoTPV(recPrmTPV); */
    end;


    procedure RegistrarAddin()
    var
        rAddin: Record "Add-in";
        text001: Label 'Se ha registrado el ADD-in por favor reinicie el servicio';
    begin

        rAddin.SetFilter("Add-in Name", 'DSPoS');
        if not rAddin.FindFirst then begin
            rAddin."Add-in Name" := 'DSPoS';
            rAddin."Public Key Token" := 'b16b5ef9ed5820f6';
            rAddin.Description := 'DynaSoft DSPoS';
            rAddin.Insert(true);
            Commit;
        end;
    end;


    procedure ComprobarSupervisor(pPassword: Text[30]): Text
    var
        Error001: Label 'La contraseña introducida no es correcta.';

        rCaj: Record Cajeros;
    begin

        // Inicializar Objeto Navision
        /*      if IsNull(Evento) then
                 Evento := Evento.Evento;

             // Tipo Evento .NET
             Evento.TipoEvento := 19;

             // Obtener el supervisor con el password introducido
             rCaj.Reset;
             rCaj.SetRange(Tienda, TiendaActual());
             rCaj.SetRange(Tipo, 2);
             rCaj.SetRange(Contrasena, pPassword);

             // Si la constraseña se ha encontrado
             if not rCaj.FindFirst then begin
                 Evento.TextoRespuesta := StrSubstNo(Error001);
                 Evento.AccionRespuesta := 'ERROR';
             end;

             // Devolvemos el evento a DsPOS
             exit(Evento.aXml()); */
    end;


    procedure SetParameters(p_Evento: text; p_Resultado: text)
    begin
        //+#121213
        /*         w_Evento := p_Evento;
                w_Resultado := p_Resultado; */
    end;


    procedure GetParameters(var v_Evento: Text; var v_Resultado: Text; var v_OkRegistro: Boolean)
    begin
        //+#121213
        /*         v_Evento := w_Evento;
                v_Resultado := w_Resultado;
                v_OkRegistro := w_OkRegistro; */
    end;
}

