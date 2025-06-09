codeunit 50116 Transfer_SIC
{
    //  Proyecto: Implementacion Business Central.
    // 
    //  LDP: Luis Jose De La Cruz Paredes
    //  ------------------------------------------------------------------------
    //  No.        Fecha           Firma    Descripcion
    //  ------------------------------------------------------------------------
    //  001     04-05-2023       LDP      Integracion DSPOS
    //  002       11-05-2023       LDP      Integracion DSPOS: Se crean y mapean los campos PuntoEmision y Establemiento factura en tabla intermedia
    //  003       19-05-2023       LDP      Integracion DsPOS:Se colocan los datos de la factura liquidada, campos:"Anula a Documento"
    //                                      "Applies-to Doc. No.","Applies-to Doc. Type",en notas de creditos.
    //  004        25-05-2023      LDP      Se asigna el tipo comprobante a los documentos
    //  005        25-25-2023      LDP      Validamos el tipo de documento SRI por su longitud
    //  006        28-08-2023      LDP      Ajsutes y mejoras integracion.
    //  007        22-09-2023      LDP      Se inserta la serie a documentos desde la configuracion TPV.
    //  008        29-09-2023      LDP      Para evitar el error en importe en línea.
    //  009        16-01-2024      LDP      SANTINAV-4730:Realizar notas de crédito desde cualquier caja DS-POS
    //  010        17-01-2024      LDP      SANTINAV-5132:Facturas no cargadas en BC - SEE - punto de venta LA Y
    //  011        26-01-2024      LDP      SANTINAV-5662:Secuencial no vinculados BC vs DS POS
    //  012        30/01/2024      LDP      Para que no se desliquide la factura en notas de credito,mov contables, serán: Pago contra factura, reembolso contra ncr.
    //  013        01/05/2024      LDP      SANTINAV-6192: Nota de crédito SEE. con error de devolución - IVA
    //  014        12/02/2024      LDP      SANTINAV-7367: Factura con error 2183
    //  015        19/12/2024      LDP      SANTINAV-7446: Notas de crédito sin Autorización SRI
    //  016        23/12/2024      LDP      SANTINAV-7490
    //  017        10/01/2024      LDP      SANTINAV-6949


    trigger OnRun()
    begin

        RecalclularImporteLineas();//014+-
        TransferCabecera();
    end;

    var
        CabVentasSIC: Record "Cab. Ventas SIC";
        CabVentasSIC_2: Record "Cab. Ventas SIC";
        LineasVentasSIC: Record "Lineas Ventas SIC";
        LineasVentasSIC_2: Record "Lineas Ventas SIC";
        LineasVentasSIC_3: Record "Lineas Ventas SIC";
        MediosdePagoSIC: Record "Medios de Pago SIC";
        SalesHeader: Record "Sales Header";
        SalesHeader2: Record "Sales Header";
        SH: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesLine2: Record "Sales Line";
        SalesLine4: Record "Sales Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlLine: Record "Gen. Journal Line";
        PaymentMethod: Record "Payment Method";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        Item: Record Item;
        ConvertImporte: Decimal;
        ConverDimension: Code[10];
        DimensionSetEntry: Record "Dimension Set Entry";
        FechaVencimiento: Date;
        NCF: Code[19];
        NCFR: Code[19];
        ValidarCabecera: Boolean;
        ValidarCabecera_GR: Boolean;
        ValidarLineas: Boolean;
        ValidarMediosPago: Boolean;
        ValidacionesErrores: Codeunit "Validaciones de  Errores";
        Customer: Record Customer;
        NoEmpleadoAfiliado: Code[20];
        TipoBloqueo: Enum "Customer Blocked";
        IUM_: Record "Item Unit of Measure";
        UnitofMeasure: Record "Unit of Measure";
        Contador: Integer;
        TotContador: Integer;
        Ventana: Dialog;
        ContadorPrueba: Integer;
        findline: Boolean;
        Text001: Label 'Processing  #1########## @2@@@@@@@@@@@@@';
        GLAccount: Record "G/L Account";
        ConfigEmpresa: Record "Flash ventas (TMP)";
        codproducto: Code[20];
        NegativeInt: Option Default,No,Yes;
        Turno: Integer;
        Nos: Label 'VNR14-000027|VNR14-000027|VNR14-000027|VNR14-000028|VNR14-000028|VNR15-000026|VNR15-000027|VNR15-000027|VNR15-000027|VNR15-000028|VNR15-000028|VNR18-000015|VNR19-000015|VNR19-000016|VNR19-000016|VNR20-000023|VNR20-000024|VNR6-000016|VNR6-000017|VNR7-000016|VNR7-000017|VNR8-000028|VNR8-000028|VNR8-000028|VNR8-000029|VNR8-000030';
        Itembloq: Boolean;
        Insertar: Boolean;
        ConfigCajaElectronica: Record "Config. Caja Electronica";
        RegistraPedidosVtaSIC_BC: Codeunit "Validaciones de  Errores";
        Cust: Record Customer;
        NoSeriesManagement: Codeunit "No. Series";
        Contact: Record Contact;
        ConfiguracionTPV: Record "Configuracion TPV";
        NumSIC: Text;
        CabVentasSIC_: Record "Cab. Ventas SIC";
        ConfTPV: Record "Configuracion TPV";
        Text: Text[10];
        Text1: Text[10];
        Text2: Text[10];
        SIH: Record "Sales Invoice Header";
        CodCajeroPos: Label 'DSPOS';
        ErrorCaja: Label 'No existe caja';
        CajaId: Text;
        FacturaLiquidar: Record "Sales Invoice Header";
        DocumentoLiquidar: Record "Sales Header";
        LongitudRuc: Integer;
        NoSeriesLine: Record "No. Series Line";
        GenLedSetup: Record "General Ledger Setup";
        rSH: Record "Sales Header";
        rSIH: Record "Sales Invoice Header";
        rNoFactura: Code[20];
        rVatPostGroup: Code[20];
        xrSalesHeader: Record "Sales Header";

    local procedure TransferCabecera()
    var
        ConvertFecha: Date;
        ConvertTasaCambio: Decimal;
        ConvertFecha1: Date;
        MPSIC_: Record "Medios de Pago SIC";
        ConfMedPagICG_: Record "Conf. Medios de pago";
        ConfigCajaElectronica: Record "Config. Caja Electronica";
        MPSIC_2: Record "Medios de Pago SIC";
        TempLinVentSIC: Record "Lineas Ventas SIC";
        TempLinVentSIC_2: Record "Lineas Ventas SIC";
        TempMedPagSIC: Record "Medios de Pago SIC";
        TempMedPagSIC_2: Record "Medios de Pago SIC";
    begin

        CabVentasSIC.Reset;
        CabVentasSIC_2.Reset;
        if ConfigEmpresa.Get then;

        CabVentasSIC.SetCurrentKey(Transferido);  //JERM-SIC
        CabVentasSIC.SetRange(Transferido, false);//JERM-SIC
        CabVentasSIC.SetRange(ErroresLineas, false);//JERM-SIC
        //CabVentasSIC.SETRANGE("Tipo documento",2);//009+ Se comenta ya qu se debe enviar infromacion desde el punto de venta, por jira SANTINAV-4730.
        //CabVentasSIC.SETRANGE("No. documento",'NCY3-000060');//009+ Prueba
        TotContador := CabVentasSIC.Count;
        Contador := 0;//006+-
        Ventana.Open(Text001);//006+-
                              //IF CabVentasSIC.FINDSET THEN IF CabVentasSIC.FIND('-') THEN
        CabVentasSIC.LockTable;
        if CabVentasSIC.FindSet then
            repeat
                if TotContador = 0 then TotContador := 1;
                if GuiAllowed then begin
                    Contador := Contador + 1;
                    Ventana.Update(1, CabVentasSIC."No. documento");
                    Ventana.Update(2, Round(Contador / TotContador * 10000, 1));
                    //Ventana.UPDATE(3,'PROCESANDO CABECERAS Y LINEAS');
                end;

                findline := false;
                CabVentasSIC_2.Get(CabVentasSIC."Tipo documento", CabVentasSIC."No. documento", CabVentasSIC.Caja, CabVentasSIC."No. documento SIC"); //LDP-001+- Agrego Campo "No. documento SIC" a clave primaria y validacion.
                ContadorPrueba += 1;
                //ValidarCabecera_GR := VerificaVtasDuplicadas(CabVentasSIC."No. documento",CabVentasSIC."Tipo documento"); //LDP-001+-
                ValidarCabecera_GR := VerificaVtasDuplicadas(CabVentasSIC."No. documento", CabVentasSIC."Tipo documento", CabVentasSIC."No. documento SIC"); //LDP-001+- Valido duplicado por "No. documento SIC"
                                                                                                                                                             ///ValidarCabecera_GR := FALSE;
                if ValidarCabecera_GR then begin
                    //CabVentasSIC_2.GET(CabVentasSIC."Tipo documento",CabVentasSIC."No. documento",CabVentasSIC.Caja);//LDP-001+-
                    CabVentasSIC_2.Get(CabVentasSIC."Tipo documento", CabVentasSIC."No. documento", CabVentasSIC.Caja, CabVentasSIC."No. documento SIC");//LDP-001+- Valido duplicado por "No. documento SIC"
                    CabVentasSIC_2.Transferido := true;
                    CabVentasSIC_2.Modify(true);

                    // LDP+ 02/01/2023 Marcar líneas medios de pagos y líneas en tablas intermedias como transferido.
                    TempLinVentSIC.Reset;
                    TempLinVentSIC.SetCurrentKey("No. documento", "No. documento SIC");
                    TempLinVentSIC.SetRange("No. documento", CabVentasSIC_2."No. documento");
                    TempLinVentSIC.SetRange("No. documento SIC", CabVentasSIC_2."No. documento SIC");
                    if TempLinVentSIC.FindSet then
                        repeat
                            TempLinVentSIC_2.Get(TempLinVentSIC."Tipo documento", TempLinVentSIC."No. documento", TempLinVentSIC."No. linea", TempLinVentSIC."Location Code");
                            TempLinVentSIC_2.Transferido := true;
                            TempLinVentSIC_2.Modify(true);
                        until TempLinVentSIC.Next = 0;

                    TempMedPagSIC.Reset;
                    TempMedPagSIC.SetCurrentKey("No. documento", "No. documento SIC");
                    TempMedPagSIC.SetRange("No. documento", CabVentasSIC_2."No. documento");
                    TempMedPagSIC.SetRange("No. documento SIC", CabVentasSIC_2."No. documento SIC");
                    if TempMedPagSIC.FindSet then
                        repeat
                            TempMedPagSIC_2.Get(TempMedPagSIC."Tipo documento", TempMedPagSIC."No. documento", TempMedPagSIC."No. linea", TempMedPagSIC."Location Code", TempMedPagSIC."No. documento SIC");
                            TempMedPagSIC_2.Transferido := true;
                            TempMedPagSIC_2.Modify(true);
                        until TempMedPagSIC.Next = 0;
                    // LDP- 02/01/2023 Marcar líneas medios de pagos y líneas en tablas intermedias como transferido.

                end;
                // IF NOT ValidarCabecera THEN
                //   BEGIN
                Clear(TipoBloqueo);
                Clear(NCF);
                Clear(NCFR);
                //Validar si hay campos vacios o errores en el registro
                ValidarCabecera := false;
                if CabVentasSIC.Origen = CabVentasSIC.Origen::"Punto de Venta" then
                    ValidarCabecera := ValidacionesErrores.ValidacionesCabeceraSIC(CabVentasSIC_2);
                //ValidarCabecera := FALSE;
                // Validar si hay lineas para la cabeceras
                LineasVentasSIC.Reset;
                LineasVentasSIC.SetRange("No. documento", CabVentasSIC."No. documento");
                LineasVentasSIC.SetRange("Tipo documento", CabVentasSIC."Tipo documento");
                LineasVentasSIC.SetRange("Location Code", CabVentasSIC."Cod. Almacen");
                LineasVentasSIC.SetRange("No. documento SIC", CabVentasSIC."No. documento SIC");//LDP-001+-
                                                                                                //MESSAGE(FORMAT(LineasVentasSIC.COUNT))
                if LineasVentasSIC.FindSet then;
                if LineasVentasSIC.Count > 0 then
                    findline := true;

                LineasVentasSIC.Reset;
                LineasVentasSIC.SetRange("No. documento", CabVentasSIC."No. documento");
                LineasVentasSIC.SetRange("Tipo documento", CabVentasSIC."Tipo documento");
                LineasVentasSIC.SetRange("Location Code", CabVentasSIC."Cod. Almacen");
                LineasVentasSIC.SetRange("No. documento SIC", CabVentasSIC."No. documento SIC");//LDP-001+-
                LineasVentasSIC.CalcSums(Importe);
                LineasVentasSIC.CalcSums("Importe descuento");
                LineasVentasSIC.CalcSums("Importe ITBIS Incluido");

                //        IF LineasVentasSIC."Importe descuento" > LineasVentasSIC."Importe ITBIS Incluido" THEN BEGIN
                //          CabVentasSIC.ErroresLineas:=TRUE;
                //          CabVentasSIC.MODIFY;
                //          findline := FALSE;
                //        END;

                if (not ValidarCabecera) and (not ValidarCabecera_GR) and (findline) then begin //INICIO

                    Cust.Reset;
                    //Cust.SETRANGE("No_ Cliente SIC",CabVentasSIC."Cod. Cliente");//LDP-001+-
                    Cust.SetRange("No.", CabVentasSIC."Cod. Cliente");//LDP-001+- Filtra en campo No.
                    if Cust.FindFirst then;

                    //Actualiza la configuracion del cliente de acuerdo al tipo de comprobante que llega desde SICs
                    //IF Customer.GET(Cust."No.") THEN BEGIN //LDP-001 COMENTO EL GET, Ubico SetRange para filtro.
                    //Cust.SETRANGE("No.",CabVentasSIC."Cod. Cliente");//LDP-001+- Filtra en campo No.
                    //IF Cust.FINDFIRST THEN; //BEGIN //LDP-001+- Filtra en campo No.
                    //END;LDP-001+-

                    if Customer.Get(CabVentasSIC."Cod. Cliente") then;
                    if Customer.Blocked <> Customer.Blocked::" " then begin
                        TipoBloqueo := Customer.Blocked;
                        Customer.Blocked := Customer.Blocked::" ";

                        Customer.Modify;
                    end;

                    //009+ Se comenta, ya que la data se tomará de la tabla intermedia.
                    /*
                    //CLEAR(CajaId);//LDP-001+
                    //CajaId:='0000'+CabVentasSIC.Caja;//LDP-001+ Prueba-
                    ConfigCajaElectronica.RESET;
                    //ConfigCajaElectronica.SETCURRENTKEY("Caja ID",Sucursal);//LDP-001+-//
                    ConfigCajaElectronica.SETCURRENTKEY("Tienda ID","Caja ID",Sucursal);//LDP-001+
                    ConfigCajaElectronica.SETRANGE("Caja ID",CabVentasSIC.Caja);//LDP-001+-
                    //ConfigCajaElectronica.SETRANGE("Caja ID",CajaId);//LDP-001+- Prueba
                    ConfigCajaElectronica.SETRANGE("Tienda ID",CabVentasSIC.Tienda);//LDP-001+-
                    //ConfigCajaElectronica.SETRANGE(Sucursal,CabVentasSIC.Tienda);//LDP-001+-//
                    IF NOT ConfigCajaElectronica.FINDFIRST THEN
                        EXIT;
                    //LDP-001+-
                    */
                    //009- Se comenta, ya que la data se tomará de la tabla intermedia.

                    //007+
                    ConfTPV.Reset;
                    ConfTPV.SetRange(Tienda, CabVentasSIC.Tienda);
                    //ConfTPV.SETRANGE("Id TPV",ConfigCajaElectronica.TPV);//009+ //Se comenta, se toma de la tabla intermedia. //24/01/2024
                    ConfTPV.SetRange("Id TPV", CabVentasSIC."Id. TPV");
                    if ConfTPV.FindFirst then;
                    //SalesHeader.VALIDATE(TPV,ConfTPV."Id TPV");
                    //007-
                    //LDP-001+-
                    /*
                       Customer.RESET;
                       Customer.SETCURRENTKEY("No_ Cliente SIC");
                       Customer.SETRANGE("No_ Cliente SIC",ConfigCajaElectronica."Cliente SIC");
                    */
                    //LDP-001+-
                    //IF Customer.FINDFIRST THEN BEGIN //LDP-001+-
                    //LDP+- Se asigna el codigo de cliente desde CabVentasSic
                    //Customer."No_ Cliente SIC" := CabVentasSIC."Cod. Cliente";
                    //Customer.MODIFY;
                    //LDP+- Se asigna el codigo de cliente desde CabVentasSic
                    //END; //LDP-001+-
                    SalesHeader.Init;
                    case CabVentasSIC."Tipo documento" of
                        1:
                            //SalesHeader.VALIDATE("Document Type", SalesHeader."Document Type"::Order); //LDP-001+- Se cambia a tipo Invoice//
                            SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);//LDP-001+- Se cambia a tipo Invoice
                        2:
                            SalesHeader.Validate("Document Type", SalesHeader."Document Type"::"Credit Memo");
                    end;
                    //IF CabVentasSIC.Origen = CabVentasSIC.Origen::"From Hotel" THEN

                    SalesHeader."No." := CabVentasSIC."No. documento"; //LDP-001+-
                                                                       /*
                                                                       CASE CabVentasSIC."Tipo documento" OF
                                                                         1:
                                                                           BEGIN
                                                                             //SalesHeader."No." := ConfigCajaElectronica."No. Serie Pedido" +'-'+ CabVentasSIC."No. documento";
                                                                             //IF "No. Cliente SIC" = '' THEN BEGIN
                                                                               //SalesHeader."No.":=NoSeriesManagement.GetNextNo(ConfigCajaElectronica."No. Serie Pedido",WORKDATE,TRUE);
                                                                             //END;
                                                                             //SalesHeader.VALIDATE("No. Series",ConfigCajaElectronica."No. Serie Pedido");
                                                                             //SalesHeader."Posting No. Series":=ConfigCajaElectronica."No. Serie Registro";

                                                                             //SalesHeader."No.":=CabVentasSIC."No. documento"; //LDP-001+-
                                                                             //LDP-001+-Se coloca la serie del pedido + Se concatena el campo "No. Comprobante" ya que es consecutivo.
                                                                             //SalesHeader."No.":= ConfigCajaElectronica."No. Serie Pedido" +'-'+ CabVentasSIC.Consecutivo; //LDP-001+-
                                                                             SalesHeader."No.":=CabVentasSIC."No. documento"; //LDP-001+-
                                                                             //LDP-001--Se coloca la serie del pedido + Se concatena el campo "No. Comprobante" ya que es consecutivo.
                                                                           END;
                                                                         2:
                                                                             //SalesHeader."No." := ConfigCajaElectronica."Serie Nota de credito" +'-'+ CabVentasSIC."No. documento";
                                                                             //LDP-001--Se coloca la serie de la nota + Se concatena el campo "No. Comprobante" ya que es consecutivo.
                                                                             //SalesHeader."No.":= ConfigCajaElectronica."No. Serie Nota Credito Pos"+'-'+ CabVentasSIC.Consecutivo; //LDP-001+-
                                                                             SalesHeader."No.":=CabVentasSIC."No. documento"; //LDP-001+-
                                                                             //LDP-001--Se coloca la serie de la nota + Se concatena el campo "No. Comprobante" ya que es consecutivo.
                                                                       END;
                                                                       */

                    //        IF CabVentasSIC.Origen = CabVentasSIC.Origen::"From Hotel" THEN BEGIN
                    //            SalesHeader.Origen := SalesHeader.Origen::"From Hotel";
                    //        END ELSE BEGIN
                    //            SalesHeader.Origen := SalesHeader.Origen::"Punto de Venta";
                    //        END;

                    if SalesHeader.Insert(true) then;//JERM-SIC
                    begin

                        SalesHeader.SetHideValidationDialog(true);
                        //SalesHeader.VALIDATE("Customer Price Group",EquiClienteFromHotel."Codigo NCF");

                        //        IF CabVentasSIC.Origen = CabVentasSIC.Origen::"From Hotel" THEN
                        //            SalesHeader.VALIDATE("Sell-to Customer No.",CabVentasSIC."Cod. Cliente")
                        //        ELSE
                        SalesHeader.Validate("Sell-to Customer No.", Customer."No.");

                        // Colocar el cliente con el bloqueo que tenia
                        if TipoBloqueo <> TipoBloqueo::" " then begin
                            Customer.Blocked := TipoBloqueo;
                            Customer.Modify;
                        end;

                        //IF (CabVentasSIC."Cod. Cliente" = 'CTE-000001') AND (CabVentasSIC."Nombre Cliente" <> '')THEN
                        if StrLen(CabVentasSIC."Nombre Cliente") = 0 then
                            //SalesHeader."Sell-to Customer Name" := Customer.Name
                            SalesHeader."Sell-to Customer Name" := RemoveExtraWhiteSpaces(Customer.Name)//015+-
                        else
                            //SalesHeader."Sell-to Customer Name" := CabVentasSIC."Nombre Cliente";
                            SalesHeader."Sell-to Customer Name" := RemoveExtraWhiteSpaces(CabVentasSIC."Nombre Cliente");//015+-

                        //SalesHeader."Sell-to Customer Name" := CabVentasSIC."Nombre Cliente";

                        if CabVentasSIC.Origen = CabVentasSIC.Origen::"From Hotel" then begin
                            CabVentasSIC."Cod. Moneda" := '2';
                        end else begin
                            CabVentasSIC."Cod. Moneda" := '1';
                        end;

                        case CabVentasSIC."Cod. Moneda" of
                            '1':
                                SalesHeader.Validate("Currency Code", ''); //DOP
                            '2':
                                SalesHeader.Validate("Currency Code", 'USD');
                            '3':
                                SalesHeader.Validate("Currency Code", 'EUR');
                        end;

                        Evaluate(ConvertTasaCambio, Format(CabVentasSIC."Tasa de cambio"));
                        SalesHeader.Validate("Currency Factor", (1 / ConvertTasaCambio));
                        ConvertFecha := CabVentasSIC.Fecha;//ConvertFechaFunct(CabVentasSIC.Fecha);      /////////////////////////PRUEBA NC///////
                        SalesHeader.Validate("Posting Date", ConvertFecha);
                        SalesHeader."Establecimiento Factura" := CabVentasSIC.Establecimiento; //LDP-002+-
                        SalesHeader."Punto de Emision Factura" := CabVentasSIC.PuntoEmision; //LDP-002+-

                        //009+ //Se llena desde tabla intermedia.
                        SalesHeader."Establecimiento Fact. Rel" := CabVentasSIC."Establecimiento Rel";
                        SalesHeader."Punto de Emision Fact. Rel." := CabVentasSIC."Establecimiento Rel";
                        //009-//Se llena desde tabla intermedia.

                        NCF := CabVentasSIC.Consecutivo; //LDP-001 Hamlet/Ramon indcan que el NCF es el campo consecutivo de tabla intermedia.
                                                         //NCF := (CabVentasSIC."No. COmprobante"); //LDP-001+-//Hamlet/Ramon indcan que el NCF es el campo consecutivo de tabla intermedia.
                        NCFR := CabVentasSIC."NCF Afectado";//COPYSTR(CabVentasSIC."NCF Afectado",9,19);
                        Clear(rNoFactura);//016+-
                        if CabVentasSIC."Tipo documento" = 2 then begin
                            SalesHeader."No. Comprobante Fiscal Rel." := NCFR;
                            SalesHeader."No. Comprobante Fiscal" := NCF;
                            SalesHeader."No. Serie NCF Facturas" := ConfTPV."NCF Credito fiscal NCR";//007+-
                            SalesHeader."No. Serie NCF Abonos" := ConfTPV."NCF Credito fiscal NCR"; //010+-Se llena para que pueda firmar electrónicamente.
                                                                                                    //LDP-003+- Se busca en el historico fact ventas y coloca la factura a liquidar en nota de credito.
                            FacturaLiquidar.Reset;
                            //FacturaLiquidar.SETRANGE("Venta TPV",TRUE); //009+ //24/01/2024
                            //FacturaLiquidar.SETRANGE("No. Comprobante Fiscal",SalesHeader."No. Comprobante Fiscal Rel.");//009+- //LDP+- //24/01/2024+-
                            FacturaLiquidar.SetCurrentKey("No. Documento SIC");//009+- //24/01/2024
                            FacturaLiquidar.SetRange("No. Documento SIC", CabVentasSIC."No. poliza");//009+- //LDP+- //Se busca por el no Documento sic de la factura afectada //24/01/2024
                                                                                                     //FacturaLiquidar.SETRANGE("Punto de Emision Factura",SalesHeader."Punto de Emision Factura");//009+- Viene de data en campo de intermedia.
                                                                                                     //FacturaLiquidar.SETRANGE("Establecimiento Factura",SalesHeader."Establecimiento Factura");//009+- Viene de data en campo de tabla intermedia.
                            if FacturaLiquidar.FindFirst then begin
                                //SalesHeader."Applies-to Doc. Type":= SalesHeader."Applies-to Doc. Type"::Invoice; //012+
                                //SalesHeader."Applies-to Doc. No.":= FacturaLiquidar."No.";//012+
                                rNoFactura := FacturaLiquidar."No.";//016+-
                                SalesHeader."No. Factura a Anular" := FacturaLiquidar."No.";//006+- Se agrega la factura a anular.
                                SalesHeader."Anula a Documento" := FacturaLiquidar."No.";
                                SalesHeader."Establecimiento Fact. Rel" := FacturaLiquidar."Establecimiento Factura";
                                SalesHeader."Punto de Emision Fact. Rel." := FacturaLiquidar."Punto de Emision Factura";
                            end else begin
                                DocumentoLiquidar.Reset;
                                DocumentoLiquidar.SetCurrentKey("Document Type", "No. Documento SIC", "Venta TPV");//009+- //24/01/2024
                                DocumentoLiquidar.SetRange("Document Type", DocumentoLiquidar."Document Type"::Invoice);
                                DocumentoLiquidar.SetRange("No. Documento SIC", CabVentasSIC."No. poliza");//009+- //LDP+- //Se busca por el no Documento sic de la factura afectada //24/01/2024
                                DocumentoLiquidar.SetRange("Venta TPV", true);
                                //DocumentoLiquidar.SETRANGE("No. Comprobante Fiscal",NCFR); //009+- //24/01/2024
                                //DocumentoLiquidar.SETRANGE("Punto de Emision Factura",SalesHeader."Punto de Emision Factura");//009+- //24/01/2024
                                //DocumentoLiquidar.SETRANGE("Establecimiento Factura",SalesHeader."Establecimiento Factura");//009+- //24/01/2024
                                if DocumentoLiquidar.FindFirst then begin
                                    //SalesHeader."Applies-to Doc. Type":= DocumentoLiquidar."Applies-to Doc. Type"::Invoice; //012+
                                    //SalesHeader."Applies-to Doc. No.":= DocumentoLiquidar."Posting No.";//006+- //012+
                                    SalesHeader."No. Factura a Anular" := DocumentoLiquidar."Posting No.";
                                    SalesHeader."Anula a Documento" := DocumentoLiquidar."Posting No.";
                                    SalesHeader."Establecimiento Fact. Rel" := DocumentoLiquidar."Establecimiento Factura";//LDP-DsPos-Filtro
                                    SalesHeader."Punto de Emision Fact. Rel." := DocumentoLiquidar."Punto de Emision Factura";
                                    //rNoFactura:=DocumentoLiquidar."No.";//016+-
                                end
                            end;
                            //LDP-003+- Se coloca la factura a liquidar en nota de credito
                            /*
                            //LDP-001+- Se busca el documento Relacionado en el historico de factura.
                            SIH.RESET;
                            SIH.SETRANGE("No. Documento SIC",CabVentasSIC."No. documento SIC");
                            IF SIH.FINDFIRST THEN BEGIN
                              SalesHeader."No. Comprobante Fiscal Rel." := SIH."Order No.";
                            END;
                            //LDP-001+- Se busca el documento Relacionado en el historico de factura.

                            END;
                            //LDP-001+- Se busca el documento Relacionado en la cabecera de venta.
                            SH.RESET;
                            SH.SETRANGE("No. Documento SIC",CabVentasSIC."No. documento SIC");
                            IF SH.FINDFIRST THEN BEGIN
                               SalesHeader."No. Comprobante Fiscal Rel." := SalesHeader."No.";
                            //LDP-001+- Se busca el documento Relacionado en la cabecera de venta.

                            //SalesHeader."Tipo Doc. Ref NC":=SalesHeader."Tipo Doc. Ref NC"::"Tiquete Electronico";
                            */
                        end else begin
                            SalesHeader."No. Comprobante Fiscal" := NCF;
                            //SalesHeader."No. Serie NCF Facturas" := ConfigCajaElectronica."Serie Factura";//LDP-002+- - Se agrega campo serie factura de caja electronica.
                            SalesHeader."No. Serie NCF Facturas" := ConfTPV."NCF Credito fiscal";//007+-
                            SalesHeader."No. Serie NCF Abonos" := ConfTPV."NCF Credito fiscal"; //010+- Se llena para que pueda firmar.
                        end;

                        //SalesHeader.Origen:=CabVentasSIC.Origen;
                        //SalesHeader.VALIDATE("No. Documento SIC",CabVentasSIC."No. documento");//LDP-001+- Este Validate se corrige a campo abVentasSIC."No. documento SIC"
                        SalesHeader.Validate("No.", SalesHeader."No.");//LDP-001- Se valida el numero de documento.
                                                                       //SalesHeader.VALIDATE("No. Documento SIC",CabVentasSIC."No. documento SIC");//LDP-001+- Este Validate se corrige a campo abVentasSIC."No. documento SIC"
                        SalesHeader."ID Cajero" := CodCajeroPos;//LDP-001+- Excepcion para cajero POS
                                                                //SalesHeader."ID Cajero":= CabVentasSIC.Caja;//LDP+-001 - Se toma el dato directamente de la cabecera del campo Tienda.
                                                                //SalesHeader.VALIDATE(Tienda, ConfigCajaElectronica."Tienda ID");//LDP+- Se valida con la cabecera
                                                                //SalesHeader.VALIDATE(TPV,ConfigCajaElectronica.TPV);//LDP-001+-
                                                                //SalesHeader.VALIDATE(TPV,ConfiguracionTPV."Id TPV");//LDP-001+- Se valida directamente con la configuracion TPV. //009+- Se comenta ya que viene dato de tabla intermedia.
                        SalesHeader.Validate(Tienda, CabVentasSIC.Tienda);//009+- Se valida con la cabecera
                        SalesHeader.Validate(TPV, CabVentasSIC."Id. TPV");//009+- //Se insterta directamente el datoq eu viene del punto de venta. //24//01/2024
                        SalesHeader.Validate("Venta TPV", true);
                        SalesHeader.Validate("Registrado TPV", true);
                        SalesHeader.Validate("Replicado POS", true);
                        SalesHeader.Validate("No. Fiscal TPV", NCF);
                        Evaluate(Turno, CabVentasSIC.Turno);
                        SalesHeader.Validate(Turno, Turno);
                        SalesHeader.Validate("Hora creacion", CabVentasSIC.Hora);
                        //017+ //Al campo obersacion llega el campo correo desde dspos+
                        SalesHeader."E-Mail" := CabVentasSIC.Observacion;
                        SalesHeader."Sell-to E-Mail" := CabVentasSIC.Observacion;
                        //017-//Al campo obersacion llega el campo correo desde dspos-

                        //SalesHeader.VALIDATE(Clave,CabVentasSIC.Clave);
                        //SalesHeader.VALIDATE(Consecutivo,CabVentasSIC.Consecutivo);
                        //SalesHeader.VALIDATE("Numero Referencia FE",CabVentasSIC.Consecutivo);
                        //SalesHeader.VALIDATE("Tipo de Venta",SalesHeader."Tipo de Venta"::Factura);

                        //IF STRLEN(CabVentasSIC.Colegio) = 2 THEN BEGIN
                        Contact.Reset;
                        Contact.SetCurrentKey("Colegio SIC");
                        Contact.SetRange("Colegio SIC", CabVentasSIC.Colegio);
                        if Contact.FindFirst then;
                        SalesHeader.Validate("Cod. Colegio", Contact."No.");//006+-
                                                                            //SalesHeader."Cod. Colegio":= Contact."No.";//006+-
                                                                            //END;
                                                                            /*ELSE
                                                                              SalesHeader.VALIDATE("Cod. Colegio",CabVentasSIC.Colegio);*/

                        /*SalesInvoiceLine.RESET;
                        SalesInvoiceLine.SETRANGE("Document No.",ConfigCajaElectronica."Serie Factura" +'-'+ CabVentasSIC."NCF Afectado");
                        SalesInvoiceLine.CALCSUMS(Amount);
                        SalesInvoiceLine.CALCSUMS("Amount Including VAT");

                       LineasVentasSIC.RESET;
                       LineasVentasSIC.SETRANGE("No. documento",CabVentasSIC."No. documento");
                       LineasVentasSIC.SETRANGE("Tipo documento",CabVentasSIC."Tipo documento");
                       LineasVentasSIC.SETRANGE("Location Code",CabVentasSIC."Cod. Almacen");
                       LineasVentasSIC.CALCSUMS(Importe);
                       LineasVentasSIC.CALCSUMS("Importe descuento");
                       LineasVentasSIC.CALCSUMS("Importe ITBIS Incluido");*/


                        /*IF SalesInvoiceLine.Amount=LineasVentasSIC.Importe THEN
                          SalesHeader."Codigo Referencia":= SalesHeader."Codigo Referencia"::"Devolucion Total"
                        ELSE
                          SalesHeader."Codigo Referencia":= SalesHeader."Codigo Referencia"::"Devolucion Parcial";*/


                        //SalesHeader."Sincronizado con errores" := TRUE;
                        if (SalesHeader."VAT Registration No." <> CabVentasSIC.RNC) and (CabVentasSIC.RNC <> '') then
                            //SalesHeader.VALIDATE("VAT Registration No.", CabVentasSIC.RNC);
                            SalesHeader."VAT Registration No." := CabVentasSIC.RNC;

                        SalesHeader."Source counter" := CabVentasSIC."Source Counter";

                        //SalesHeader.VALIDATE("Posting No.",SalesHeader."No.");
                        //NumSIC:=CONVERTSTR(CabVentasSIC."No. documento",'-',',');//LDP-001+-

                        //009+ //Se comenta 'CASE' ya que la serie nos llega desde la tabla intermedia en campo "Serie Documento".
                        //SalesHeader."Posting No.":= CabVentasSIC."Serie Documento" +'-'+ CabVentasSIC.Consecutivo;//009+- //24/01/2024
                        SalesHeader."Posting No." := CabVentasSIC."No. comprobante";//009+- //05/03/2024 //El numero de comprobante es posting No.
                                                                                    /*
                                                                                    CASE CabVentasSIC."Tipo documento" OF
                                                                                      1:
                                                                                          //SalesHeader."Posting No.":= ConfigCajaElectronica."Serie Factura" +'-'+ CabVentasSIC."No. documento";
                                                                                          //SalesHeader."No. Doc Historico" := ConfigCajaElectronica."Serie Factura" +'-'+ CabVentasSIC."No. documento";
                                                                                          //SalesHeader."Posting No.":=  ConfigCajaElectronica."Serie Factura"+'-'+SELECTSTR(2,NumSIC);//LDP-001+- De deja de buscar en la tabla ConfigCajaElectronica
                                                                                          //SalesHeader."Posting No.":= CabVentasSIC."No. documento";//LDP+- Se le asigna desde CabVentaSig, Ya que se incluye el numero de documento como serie en este campo.//LDP-001+-
                                                                                          //SalesHeader."Posting No.":= NoSeriesManagement.GetNextNo(ConfigCajaElectronica."No. Serie Pedido",WORKDATE,TRUE) + CabVentasSIC."No. comprobante"; //LDP-001+- //LDP+-
                                                                                          //SalesHeader."Posting No.":=SalesHeader."No.";
                                                                                          SalesHeader."Posting No.":= ConfigCajaElectronica."No. Serie Registro Factura Pos" +'-'+ CabVentasSIC.Consecutivo;//001+- //009+- //24/01/2024 //
                                                                                      2:
                                                                                          //SalesHeader."Posting No.":= ConfigCajaElectronica."No. Serie Registro Nota C." +'-'+ CabVentasSIC."No. documento";
                                                                                          //SalesHeader."No. Comprobante Fiscal Rel." := ConfigCajaElectronica."Serie Factura" +'-'+ CabVentasSIC."NCF Afectado";
                                                                                          //SalesHeader."Posting No.":= ConfigCajaElectronica."Serie Nota de credito"+'-'+ SELECTSTR(2,NumSIC);//LDP-001+- De deja de buscar en la tabla ConfigCajaElectronica
                                                                                          //SalesHeader."Posting No.":= CabVentasSIC."No. documento";//LDP+- Se le asigna desde CabVentaSig,Ya que se incluye el numero de documento como serie en este campo.//LDP-001+-
                                                                                          //SalesHeader."Posting No.":= NoSeriesManagement.GetNextNo(ConfigCajaElectronica."Serie Nota de credito",WORKDATE,TRUE) + CabVentasSIC."No. comprobante"; //LDP-001+-
                                                                                          //SalesHeader."Posting No.":=SalesHeader."No."
                                                                                          //SalesHeader."Posting No.":= ConfigCajaElectronica."No. Serie Registro Nota C." +'-'+ CabVentasSIC.Consecutivo;//001+-
                                                                                          SalesHeader."Posting No.":= ConfigCajaElectronica."No. Serie Registro Nota C." +'-'+ CabVentasSIC.Consecutivo;//001+
                                                                                    END;
                                                                                    //SalesHeader."Posting No.":= NoSeriesManagement.GetNextNo(ConfigCajaElectronica."No. Serie Registro",WORKDATE,TRUE);
                                                                                    //SalesHeader."Shipping No." := SalesHeader."No.";
                                                                                    */
                                                                                    //009+ //Se comenta 'CASE' ya que la serie nos llega desde la tabla intermedia en campo "Serie Documento".

                        //LDP-001+- Se comenta ya que este campo viene en tabla intermedia desde SICPOS.
                        /*
                        ConfiguracionTPV.RESET;
                        ConfiguracionTPV.SETRANGE(Tienda,ConfigCajaElectronica."Tienda POS");//LDP-001+-Se deja de buscar en la tabla ConfigCajaElectronica
                        ConfiguracionTPV.SETRANGE(Tienda,CabVentasSIC.Tienda)//LDP-001+-
                        ConfiguracionTPV.SETRANGE("Id TPV",ConfigCajaElectronica.TPV);
                        ConfiguracionTPV.SETRANGE("Venta Movil",TRUE);
                        IF ConfiguracionTPV.FINDFIRST THEN BEGIN
                          Contact.RESET;
                          Contact.SETCURRENTKEY("Colegio SIC");
                          Contact.SETRANGE("Colegio SIC",CabVentasSIC.Colegio);
                          IF Contact.FINDFIRST THEN
                            SalesHeader.VALIDATE("Location Code" ,Contact."Cod. Almacen");
                        END ELSE
                          SalesHeader.VALIDATE("Location Code" ,ConfigCajaElectronica.Location);
                          SalesHeader.VALIDATE("No. Documento SIC",SELECTSTR(2,NumSIC));
                          */
                        //LDP-001+- Se comenta ya que este campo Ramon lo trae a la tabla Cabecera Venta SIC.

                        //SalesHeader.VALIDATE("Nombre Empleado Cte.",COPYSTR(CabVentasSIC."Nombre asegurado",1,50)); //50003
                        //SalesHeader.VALIDATE("No. Autorizacion Seguro",CabVentasSIC."No. orden");//50005 GRN Dejar asi para el seguro
                        SalesHeader.Validate("Location Code", CabVentasSIC."Cod. Almacen");//LDP-001+-
                        SalesHeader.Validate("No. Documento SIC", CabVentasSIC."No. documento SIC");//LDP-001+-
                        NoEmpleadoAfiliado := CabVentasSIC."No. poliza";
                        //SalesHeader.VALIDATE("No. Empleado/Afiliado",NoEmpleadoAfiliado);//50002
                        SalesHeader.Validate("Cod. Cajero", CabVentasSIC."Cod. Cajero");
                        SalesHeader.Validate(SalesHeader."Cod. Supervisor", CabVentasSIC."Cod. supervisor");
                        ConvertFecha1 := CabVentasSIC."Fecha Venc. NCF";//ConvertFechaFunct(CabVentasSIC."Fecha Venc. NCF"); ////////////////////////////prueba
                        SalesHeader.Validate("Fecha vencimiento NCF", ConvertFecha1);
                        SalesHeader."External Document No." := CabVentasSIC."No. documento";
                        SalesHeader."Establecimiento Factura" := CabVentasSIC.Establecimiento; //LDP-002+-
                        SalesHeader."Punto de Emision Factura" := CabVentasSIC.PuntoEmision; //LDP-002+-
                                                                                             //LDP-005+- Validamos el tipo de documento SRI.
                        Clear(LongitudRuc);
                        LongitudRuc := StrLen(CabVentasSIC.RNC);
                        if LongitudRuc = 13 then begin
                            SalesHeader."Tipo Documento SrI" := SalesHeader."Tipo Documento SrI"::RUC
                        end else
                            if LongitudRuc = 10 then begin
                                SalesHeader."Tipo Documento SrI" := SalesHeader."Tipo Documento SrI"::Cedula
                            end else
                                if (LongitudRuc >= 5) and (LongitudRuc <= 9) then begin
                                    SalesHeader."Tipo Documento SrI" := SalesHeader."Tipo Documento SrI"::Pasaporte
                                end;
                        //LDP-005+- Validamos el tipo de documento SRI

                        //004+- Se asigna el tipo comprobante a los documentos.
                        NoSeriesLine.Reset;
                        NoSeriesLine.SetRange("Series Code", SalesHeader."No. Serie NCF Facturas");
                        if NoSeriesLine.FindFirst then
                            SalesHeader."Tipo de Comprobante" := NoSeriesLine."Tipo Comprobante";

                    end;
                    //004+- Se asigna el tipo comprobante a los documentos.

                    //SalesHeader."Tipo de Comprobante" :=  NoSeriesManagement.GetNextNo(SalesHeader."No. Serie NCF Facturas",WORKDATE,TRUE);//011+-

                    //        MPSIC_.RESET;
                    //        MPSIC_.SETRANGE("No. documento Pos",CabVentasSIC."No. documento");
                    //        MPSIC_.SETRANGE("Tipo documento",CabVentasSIC."Tipo documento");
                    //        IF MPSIC_.FINDSET THEN BEGIN
                    //          REPEAT
                    //            MPSIC_2.RESET;
                    //            //MPSIC_2.SETCURRENTKEY("No. documento","No. linea","Tipo documento");
                    //            MPSIC_2.SETRANGE("No. documento Pos",CabVentasSIC."No. documento");
                    //            MPSIC_2.SETRANGE("Tipo documento",CabVentasSIC."Tipo documento");
                    //            MPSIC_2.SETRANGE("No. linea",MPSIC_."No. linea");
                    //            IF MPSIC_2.FINDFIRST THEN BEGIN
                    //              MPSIC_2."No. Serie Pos":=SalesHeader."No.";
                    //              MPSIC_2.MODIFY;
                    //            END;
                    //
                    //          UNTIL MPSIC_.NEXT=0;
                    //        END;


                    //AMS - Para actualizar la forma de pago
                    MPSIC_.Reset;
                    //MPSIC_.SETRANGE("No. documento Pos",CabVentasSIC."No. documento");//LDP-001+-//
                    MPSIC_.SetRange("No. documento", CabVentasSIC."No. documento");//LDP-001+-
                    MPSIC_.SetRange("No. documento SIC", CabVentasSIC."No. documento SIC");//LDP-001+-
                                                                                           //MPSIC_.SETRANGE("No. documento Pos",CabVentasSIC.Consecutivo);//LDP-001+-
                    if MPSIC_.FindFirst then begin
                        if ConfMedPagICG_.Get(MPSIC_."Cod. medio de pago") then begin
                            if ConfMedPagICG_."Cod. med. pago" <> '' then begin
                                SalesHeader.Validate("Payment Method Code", ConfMedPagICG_."Cod. Forma Pago");
                            end;
                        end;
                    end;
                    SalesHeader."Sell-to Customer Name" := RemoveExtraWhiteSpaces(CabVentasSIC."Nombre Cliente");//015+-
                                                                                                                 //SalesHeader."Sell-to Customer Name" := CabVentasSIC."Nombre Cliente";
                                                                                                                 //015+
                    SalesHeader."Ship-to Name" := RemoveExtraWhiteSpaces(CabVentasSIC."Nombre Cliente");
                    SalesHeader."Bill-to Name" := RemoveExtraWhiteSpaces(CabVentasSIC."Nombre Cliente");
                    //SalesHeader."Ship-to Name" := CabVentasSIC."Nombre Cliente";
                    //SalesHeader."Bill-to Name" := CabVentasSIC."Nombre Cliente";
                    //015-
                    SalesHeader."Shipping No." := '';
                    SalesHeader.Modify(true);

                    //Colocar como transferido - LDP-001+-
                    //MPSIC_.GET(CabVentasSIC."Tipo documento",CabVentasSIC."No. documento",CabVentasSIC."No. documento SIC");//LDP-001+- Solo marcaba una linea como transferido.
                    //MPSIC_.MODIFY(TRUE);//LDP-001+- Solo marcaba una linea como transferido.
                    MPSIC_.Reset;
                    MPSIC_.SetCurrentKey("Tipo documento", "No. documento", "No. documento SIC");
                    MPSIC_.SetRange("Tipo documento", CabVentasSIC."Tipo documento");
                    MPSIC_.SetRange("No. documento", CabVentasSIC."No. documento");
                    MPSIC_.SetRange("No. documento SIC", CabVentasSIC."No. documento SIC");
                    if MPSIC_.FindSet then begin
                        repeat
                            MPSIC_.Transferido := true;
                            MPSIC_.Modify(true);
                        until MPSIC_.Next = 0;
                    end;
                    //Colocar como transferido - LDP-001+-

                    //Colocarlo como transferido
                    //CabVentasSIC_2.GET(CabVentasSIC."Tipo documento",CabVentasSIC."No. documento",CabVentasSIC.Caja);//LDP-001+-
                    CabVentasSIC_2.Get(CabVentasSIC."Tipo documento", CabVentasSIC."No. documento", CabVentasSIC.Caja, CabVentasSIC."No. documento SIC");//LDP-001+-
                    CabVentasSIC_2.Transferido := true;
                    CabVentasSIC_2.Modify(true);

                    //013+ Buscamos la factura a facturar a anular en historicos o factura pendiente
                    /*
                    CLEAR(rNoFactura);
                    IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN
                      BEGIN
                       rSH.RESET;
                       rSH.SETRANGE("Document Type",DocumentoLiquidar."Document Type"::Invoice);
                       rSH.SETRANGE("No. Documento SIC",CabVentasSIC."No. poliza");//
                       rSH.SETRANGE("Venta TPV",TRUE);
                       //rSH.SETRANGE("Punto de Emision Factura",SalesHeader."Punto de Emision Fact. Rel.");
                       //rSH.SETRANGE("Establecimiento Factura",SalesHeader."Establecimiento Fact. Rel");
                       //rSH.SETRANGE("No. Comprobante Fiscal", SalesHeader."No. Comprobante Fiscal Rel.");
                       IF rSH.FINDFIRST THEN
                        BEGIN
                          rNoFactura := rSH."No.";
                        END ELSE
                         BEGIN
                           rSIH.RESET;
                           rSIH.SETCURRENTKEY("No. Documento SIC");//009+- //24/01/2024
                           rSIH.SETRANGE("No. Documento SIC",CabVentasSIC."No. poliza");
                           //rSIH.SETRANGE("Punto de Emision Factura",SalesHeader."Punto de Emision Fact. Rel.");
                           //rSIH.SETRANGE("Establecimiento Factura",SalesHeader."Establecimiento Fact. Rel");
                           //rSIH.SETRANGE("No. Comprobante Fiscal", SalesHeader."No. Comprobante Fiscal Rel.");
                           IF rSIH.FINDFIRST THEN
                            BEGIN
                              rNoFactura := rSIH."No.";
                            END
                         END;
                      END;
                      */
                    //013- Buscamos la factura a facturar a anular en historicos o factura pendiente

                    //JERM-SIC Se envian a crear las lineas de la cabecera actual
                    //TransferLineaActualizada(CabVentasSIC."No. documento",CabVentasSIC."Tipo documento",CabVentasSIC."Cod. Cliente",SalesHeader."No.",CabVentasSIC."Cod. Almacen");//JERM-SIC Se envian a crear las lineas de la cabecera actual //LDP-001+- Agrego Filtrar por No. Documento Sic
                    TransferLineaActualizada(CabVentasSIC."No. documento", CabVentasSIC."Tipo documento", CabVentasSIC."Cod. Cliente", SalesHeader."No.", CabVentasSIC."Cod. Almacen", CabVentasSIC."No. documento SIC");//LDP-001+- Agrego Filtrar por No. Documento Sic
                    SalesHeader.Status := SalesHeader.Status::Released;
                    SalesHeader.Modify(true);
                    Commit;
                end;

            //END;   //FIN

            until CabVentasSIC.Next = 0;
        Commit;

    end;

    local procedure TransferLineaActualizada(NumDoc: Code[40]; tipodoc: Integer; codcliente: Code[20]; SLCode: Code[20]; Lcode: Code[40]; NoDocSic: Code[40])
    var
        ConvertLinea: Integer;
        ConvertCantidad: Decimal;
        ConvertImporte2: Decimal;
        ConvertPrecio: Decimal;
    begin
        GenLedSetup.Get;//008+-

        if ConfigEmpresa.Get then;
        LineasVentasSIC.Reset;
        LineasVentasSIC.SetCurrentKey("No. documento", "No. linea");
        LineasVentasSIC.SetRange("No. documento", NumDoc);
        LineasVentasSIC.SetRange("Location Code", Lcode);
        LineasVentasSIC.SetRange(Transferido, false);
        LineasVentasSIC.SetRange("No. documento SIC", NoDocSic); //LDP-001+- Se agrega No. Doc Sic a filtro.
        //LinVentasIcg.SETFILTER(Errores,'=%1','');
        if LineasVentasSIC.FindSet then
            repeat
                /*IF GUIALLOWED THEN
                  BEGIN
                   Contador := Contador + 1;
                   Ventana.UPDATE(1,LineasVentasSIC."No. documento");
                   Ventana.UPDATE(2,ROUND(Contador / TotContador * 10000,1));
                   //Ventana.UPDATE(3,'PROCESANDO CABECERAS Y LINEAS');
                  END;*/
                Evaluate(codproducto, LineasVentasSIC.codproducto);
                Insertar := true;
                if not Item.Get(codproducto) then
                    Insertar := false;
                if Insertar then begin
                    SalesLine.Init;
                    case tipodoc of
                        1:
                            //SalesLine.VALIDATE("Document Type", SalesLine."Document Type"::Order);//LDP-001+-
                            SalesLine.Validate("Document Type", SalesLine."Document Type"::Invoice);
                        2:
                            SalesLine.Validate("Document Type", SalesLine."Document Type"::"Credit Memo");
                    end;

                    SalesLine.SetHideValidationDialog(true);
                    SalesLine.Validate("Document No.", SLCode);
                    Evaluate(ConvertLinea, Format(LineasVentasSIC."No. linea"));
                    SalesLine.Validate("Line No.", ConvertLinea);
                    SalesLine."No. Documento SIC" := NoDocSic;//LDP-001+-
                    SalesLine.Quantity := 0;
                    //    IF LineasVentasSIC.Origen = LineasVentasSIC.Origen::"From Hotel" THEN BEGIN
                    //      IF LineasVentasSIC.Importe <> 0 THEN BEGIN
                    //        SalesLine.VALIDATE(Type,SalesLine.Type::"G/L Account");
                    //        SalesLine.VALIDATE("No.", ConfigEmpresa.CuentaFromHotel);
                    //        SalesLine.VALIDATE("Shortcut Dimension 1 Code",ConfigEmpresa."Dimension FromHotel");
                    //        SalesLine.VALIDATE("Shortcut Dimension 2 Code",StrposDimension(LineasVentasSIC.Descripcion));
                    //        EVALUATE(ConvertCantidad,FORMAT(ABS(LineasVentasSIC.Cantidad)));
                    //        SalesLine.VALIDATE(Quantity,ConvertCantidad);
                    //        SalesLine.IDRESERVA := LineasVentasSIC.IDRESERVA;
                    //        SalesLine.LOCALIZADOR:= LineasVentasSIC.LOCALIZADOR;
                    //        SalesLine.FECHAENTRADA:= LineasVentasSIC.FECHAENTRADA;
                    //        SalesLine.FECHASALIDA:= LineasVentasSIC.FECHASALIDA;
                    //        SalesLine.CAPTIONHABITACION:= LineasVentasSIC.CAPTIONHABITACION;
                    //      END;
                    //      SalesLine.Description := LineasVentasSIC.Descripcion;
                    //      LineasVentasSIC.VALIDATE("Unidad de medida",'UD');
                    //    END ELSE BEGIN
                    SalesLine.Validate(Type, SalesLine.Type::Item);
                    if UnitofMeasure.Get(LineasVentasSIC."Unidad de medida") then;
                    Evaluate(codproducto, LineasVentasSIC.codproducto);
                    if Item.Get(codproducto) then;

                    if Item.Blocked = true then begin
                        NegativeInt := Item."Prevent Negative Inventory";
                        Itembloq := Item.Blocked;
                        Item."Prevent Negative Inventory" := Item."Prevent Negative Inventory"::No;
                        Item.Blocked := false;
                        Item.Modify;
                    end;



                    LineasVentasSIC.Validate("Unidad de medida", 'UD');
                    if (Item."Base Unit of Measure" <> LineasVentasSIC."Unidad de medida") then
                        LineasVentasSIC.Validate("Unidad de medida", Item."Base Unit of Measure");


                    SalesLine.Validate("No.", codproducto);
                    SalesLine.Validate("Location Code", LineasVentasSIC."Location Code");
                    Evaluate(ConvertCantidad, Format(Abs(LineasVentasSIC.Cantidad)));
                    SalesLine.Validate(Quantity, ConvertCantidad);
                    //SalesLine.VALIDATE("Line Discount Amount",LineasVentasSIC."Importe descuento");
                    //    END;
                    //    SalesLine.Origen:=LineasVentasSIC.Origen;

                    //IF (LineasVentasSIC.ITBIS = 0) AND (LineasVentasSIC.Origen = LineasVentasSIC.Origen::"Punto de Venta") THEN
                    // SalesLine.VALIDATE("VAT Prod. Posting Group", 'BIENEXTO');

                    if LineasVentasSIC."Precio de venta" > 0 then begin
                        //008+ Se comenta porque el calcula da error en importes.
                        /*
                        EVALUATE(ConvertPrecio,FORMAT((LineasVentasSIC.Importe/LineasVentasSIC.Cantidad)) );
                        SalesLine.VALIDATE("Unit Price",ABS(ConvertPrecio));
                        SalesLine.VALIDATE(Amount,ABS(LineasVentasSIC.Importe));
                        SalesLine.VALIDATE("Amount Including VAT",LineasVentasSIC."Importe ITBIS Incluido");//006+- Se agrega valida a campo "Amount Incluiding VAT" 30/08/2023
                        EVALUATE(ConvertImporte2,FORMAT(ABS(LineasVentasSIC."Importe descuento")));
                        SalesLine.VALIDATE("Line Discount Amount",ABS(LineasVentasSIC."Importe descuento"));
                        */
                        //008-
                        //008+
                        //EVALUATE(ConvertPrecio,FORMAT((LineasVentasSIC."Importe ITBIS Incluido"/LineasVentasSIC.Cantidad)+(LineasVentasSIC."Importe descuento")/(LineasVentasSIC.Cantidad)));
                        Evaluate(ConvertPrecio, Format((LineasVentasSIC.Importe / LineasVentasSIC.Cantidad)));
                        SalesLine.Validate("Unit Price", Round((Abs(ConvertPrecio)), GenLedSetup."Unit-Amount Rounding Precision"));
                        //EVALUATE(ConvertImporte2,FORMAT(ABS(LineasVentasSIC."Importe descuento")));
                        SalesLine.Validate("Line Discount Amount", Round((Abs(LineasVentasSIC."Importe descuento")), GenLedSetup."Unit-Amount Rounding Precision"));
                        //008-
                    end;

                    //fes mig SalesLine.VALIDATE(SIC,TRUE);
                    //SalesLine.VALIDATE("Source Counter",LineasVentasSIC."Source Counter");

                    //013+ Se busca el VatProdPostinGroup en la línea de la factura.
                    //016+
                    if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then begin
                        Clear(rVatPostGroup);
                        rVatPostGroup := FindInLineVatPostingGroup(rNoFactura, codproducto);
                        SalesLine.Validate("VAT Prod. Posting Group", rVatPostGroup);
                    end;

                    //016-
                    //013- Se busca el VatProdPostinGroup en la línea de la factura.

                    SalesLine."No. Documento SIC" := SalesHeader."No. Documento SIC";//LDP-001+-
                    if SalesLine.Insert(true) then;
                    Commit;

                    if Item.Get(codproducto) then begin
                        Item."Prevent Negative Inventory" := NegativeInt;
                        Item.Blocked := Itembloq;
                        Item.Modify;
                    end;
                end;
                //Colocarlo como transferido
                LineasVentasSIC_2.Reset;
                LineasVentasSIC_2.SetRange("No. documento", LineasVentasSIC."No. documento");
                LineasVentasSIC_2.SetRange("No. linea", LineasVentasSIC."No. linea");
                LineasVentasSIC_2.SetRange("No. documento SIC", NoDocSic); //LDP-001+- Se agrega No. Doc Sic a filtro.
                if LineasVentasSIC_2.FindFirst then begin
                    LineasVentasSIC_2.Transferido := true;
                    LineasVentasSIC_2.Modify(true);
                end;

            until LineasVentasSIC.Next = 0;
        //InsertLineaPropina(NumDoc,tipodoc);

        //        SalesHeader2.RESET;
        //        SalesHeader2.SETRANGE("No.",SLCode);
        //
        //        IF SalesHeader2.FINDFIRST THEN BEGIN
        //          SalesHeader2.VALIDATE(Status,SalesHeader2.Status::Released);
        //          SalesHeader2.MODIFY;
        //        END;

    end;

    local procedure VerificaVtasDuplicadas(NoDoc: Code[20]; TipoDoc: Integer; NoDocSic_: Code[40]): Boolean
    var
        SH: Record "Sales Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        Txt001: Label 'Deleting Ticket    #1########## @2@@@@@@@@@@@@@\Deleting Ticket    #3########## @4@@@@@@@@@@@@@\Compressing NCr    #5########## @6@@@@@@@@@@@@@\Deleting NCr    #7########## @8@@@@@@@@@@@@@';
        DocumentoExiste: Boolean;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        DocumentoExiste := false;

        SalesHeader.Reset;

        case TipoDoc of // JERM-SIC
            1:
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);//LDP-001+-
            2:
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
        end; // JERM-SIC

        SalesHeader.SetRange("No.", NoDoc);
        SalesHeader.SetRange("No. Documento SIC", NoDocSic_); //LDP-001+-Se valida que no exista "No. Documento SIC"
        if SalesHeader.FindFirst then
            DocumentoExiste := true
        else begin
            //001+  Busca documento en Historico de ventas y nota de creditos
            case TipoDoc of
                1:
                    begin
                        SalesInvoiceHeader.Reset;
                        SalesInvoiceHeader.SetCurrentKey("Order No.", "No. Documento SIC");
                        SalesInvoiceHeader.SetRange("Order No.", NoDoc);
                        SalesInvoiceHeader.SetRange("No. Documento SIC", NoDocSic_);
                        if SalesInvoiceHeader.FindFirst then
                            DocumentoExiste := true
                        else
                            SalesShipmentHeader.Reset;
                        SalesShipmentHeader.SetCurrentKey("Order No.");
                        SalesShipmentHeader.SetRange("Order No.", NoDoc);
                        SalesShipmentHeader.SetRange("No. Documento SIC", NoDocSic_); //LDP-001+-Se valida que no exista "No. Documento SIC"
                        if SalesShipmentHeader.FindFirst then
                            DocumentoExiste := true;
                    end else begin
                    SalesCrMemoHeader.Reset;
                    SalesCrMemoHeader.SetCurrentKey("Pre-Assigned No.", "No. Documento SIC");
                    SalesCrMemoHeader.SetRange("Pre-Assigned No.", NoDoc);
                    SalesCrMemoHeader.SetRange("No. Documento SIC", NoDocSic_);
                    if SalesCrMemoHeader.FindFirst then
                        DocumentoExiste := true;
                end;
            end;
        end;
        //001-  Busca documento en Historico de ventas y nota de creditos

        exit(DocumentoExiste);
    end;

    local procedure ConvertFechaFunct(Fecha_: Text): Date
    var
        Ano: Integer;
        Mes: Integer;
        Dia: Integer;
        Anotxt: Text[4];
        Mestxt: Text[2];
        Diatxt: Text[2];
    begin
        /*ConvertFechaFunctPP(Fecha_);
        EXIT;
        */
        /*
          Anotxt := COPYSTR(Fecha_,1,4);
          EVALUATE(Ano, Anotxt);
          Mestxt := COPYSTR(Fecha_, 6,2);
          EVALUATE(Mes,Mestxt );
          Diatxt := COPYSTR(Fecha_, 9,2);
          EVALUATE(Dia, Diatxt );
          */

        if StrPos(Fecha_, 'ABCDEFGHIJKLMNOPQRSTUVWXYX') <> 0 then begin
            exit(ConvertFechaFunctPP(Fecha_));
        end;

        Anotxt := CopyStr(Fecha_, 7, 4);
        Evaluate(Ano, Anotxt);
        Mestxt := CopyStr(Fecha_, 4, 2);
        Evaluate(Mes, Mestxt);
        Diatxt := CopyStr(Fecha_, 1, 2);
        Evaluate(Dia, Diatxt);

        exit(DMY2Date(Dia, Mes, Ano));

    end;

    local procedure ConvertFechaFunctPP(Fecha_: Text): Date
    var
        Ano: Integer;
        Mes: Integer;
        Dia: Integer;
        Anotxt: Text[4];
        Mestxt: Text[2];
        Diatxt: Text[2];
    begin

        //Anotxt := '2019';
        Anotxt := CopyStr(Fecha_, 8, 4);
        Evaluate(Ano, Anotxt);
        case CopyStr(Fecha_, 1, 3) of
            'Mar':
                Mestxt := '03';
            'Apr':
                Mestxt := '04';
            'May':
                Mestxt := '05';
            'Jun':
                Mestxt := '06';
            'Jul':
                Mestxt := '07';
            'Ago':
                Mestxt := '08';
            'Sep':
                Mestxt := '09';
            'Oct':
                Mestxt := '10';
            'Nov':
                Mestxt := '11';
            'Dec':
                Mestxt := '12';
            'Dic':
                Mestxt := '12';
        end;
        Evaluate(Mes, Mestxt);
        Diatxt := CopyStr(Fecha_, 5, 2);
        Evaluate(Dia, Diatxt);
        exit(DMY2Date(Dia, Mes, Ano));
    end;

    local procedure TransferLineaActualizada2()
    var
        ConvertLinea: Integer;
        ConvertCantidad: Decimal;
        ConvertImporte2: Decimal;
        ConvertPrecio: Decimal;
        Totales: Integer;
    begin
        // IF GUIALLOWED THEN
        //   Ventana.OPEN(Text001);

        LineasVentasSIC.Reset;
        LineasVentasSIC.SetCurrentKey(Transferido);
        LineasVentasSIC.SetFilter("No. documento", '=%1', '18349');//JERM-SIC
        LineasVentasSIC.SetRange("Location Code", 'CTE-003799');
        LineasVentasSIC.SetRange(Transferido, false);
        //LineasVentasSIC.SETFILTER(Errores,'=%1','');
        //LineasVentasSIC.SETRANGE(Fecha,DMY2DATE(1,8,2019),DMY2DATE(30,8,2019));
        //LinVentasIcg.SETRANGE("Caja",'BV01-21111');
        TotContador := LineasVentasSIC.Count;
        if LineasVentasSIC.FindSet then
            repeat

                Evaluate(codproducto, LineasVentasSIC.codproducto);
                Insertar := true;
                if not Item.Get(codproducto) then
                    Insertar := false;
                if Insertar then begin
                    SalesHeader.Reset;
                    SalesHeader.SetCurrentKey("No.", "Document Type");
                    CabVentasSIC.Reset;
                    CabVentasSIC.SetRange("No. documento", LineasVentasSIC."No. documento");
                    CabVentasSIC.SetRange("Cod. Almacen", LineasVentasSIC."Location Code");
                    if CabVentasSIC.FindFirst then;
                    //SalesHeader.SETRANGE("No.",LineasVentasSIC."No. documento");

                    //LDP-001+- Se excluye la tabla ConfigCajaElectronica

                    //009+ Se comenta ya que los datos vienen de las tablas intermedias.
                    /*
                    ConfigCajaElectronica.RESET;
                    ConfigCajaElectronica.SETCURRENTKEY("Caja ID",Sucursal);
                    ConfigCajaElectronica.SETRANGE("Caja ID",CabVentasSIC.Caja);
                    ConfigCajaElectronica.SETRANGE( Sucursal,CabVentasSIC.Tienda);
                    IF NOT ConfigCajaElectronica.FINDFIRST THEN
                      EXIT;
                    */
                    //009- Se comenta ya que los datos vienen de las tablas intermedias.

                    //
                    //LDP-001+- Se excluye la tabla ConfigCajaElectronica

                    case LineasVentasSIC."Tipo documento" of
                        1:
                            //SalesHeader.SETRANGE("No.", ConfigCajaElectronica."Serie Factura" +'-'+ CabVentasSIC."No. documento");//LDP-001+-//
                            //SalesHeader.SETRANGE("No.", NoSeriesManagement.GetNextNo(ConfigCajaElectronica."No. Serie Pedido",WORKDATE,TRUE) +'-'+ CabVentasSIC."No. comprobante"); //LDP-001+-
                            SalesHeader.SetRange("No.", CabVentasSIC."No. documento");//LDP-001+-
                        2:
                            //SalesHeader.SETRANGE("No." , ConfigCajaElectronica."Serie Nota de credito" +'-'+ CabVentasSIC."No. documento");//LDP-001+-//
                            //SalesHeader.SETRANGE("No.", NoSeriesManagement.GetNextNo(ConfigCajaElectronica."Serie Nota de credito",WORKDATE,TRUE) +'-'+ CabVentasSIC."No. comprobante"); //LDP-001+-
                            SalesHeader.SetRange("No.", CabVentasSIC."No. documento");
                    end;
                    if LineasVentasSIC."Tipo documento" = 2 then begin
                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
                    end else begin
                        //SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Order);//LDP-001+-//
                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice); //LDP-001+-
                    end;
                    //LDP+-// No hay tipo documento 3 en tabla intermedia.
                    /*
                    IF LineasVentasSIC."Tipo documento" = 3 THEN BEGIN
                      SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Invoice);

                    END;
                    */
                    //LDP+-//

                    Totales := SalesHeader.Count;
                    if SalesHeader.FindFirst then begin
                        findline := false;

                        SalesLine2.Reset;
                        SalesLine2.SetRange("Document No.", LineasVentasSIC."No. documento");
                        SalesLine2.SetRange("Document Type", SalesHeader."Document Type");
                        SalesLine2.SetRange("Line No.", LineasVentasSIC."No. linea");
                        SalesLine2.SetRange("No.", LineasVentasSIC.codproducto);
                        SalesLine2.SetRange("No. Documento SIC", LineasVentasSIC."No. documento SIC");//LDP-001+-
                        if SalesLine2.Count > 0 then
                            findline := true;

                        if CabVentasSIC.FindSet then begin
                            if (findline = false) then begin

                                case CabVentasSIC."Tipo documento" of
                                    1:
                                        //SalesLine.VALIDATE("Document Type", SalesLine."Document Type"::Order);//LDP-001+-//
                                        SalesLine.Validate("Document Type", SalesLine."Document Type"::Invoice);//LDP-001+-
                                    2:
                                        SalesLine.Validate("Document Type", SalesLine."Document Type"::"Credit Memo");
                                // 3://LDP-001+-//
                                //  SalesLine.VALIDATE("Document Type", SalesLine."Document Type"::Invoice);//LDP-001+-//
                                end;

                                SalesLine.Validate("Document Type", SalesHeader."Document Type");
                                SalesLine.Validate("Document No.", SalesHeader."No.");
                                SalesLine."No. Documento SIC" := SalesHeader."No. Documento SIC"; //LDP-001+-
                                Evaluate(ConvertLinea, Format(LineasVentasSIC."No. linea"));
                                SalesLine.Validate("Line No.", ConvertLinea);
                                SalesLine.Quantity := 0;
                                SalesLine.Validate(Type, SalesLine.Type::Item);
                                if UnitofMeasure.Get(LineasVentasSIC."Unidad de medida") then;
                                Evaluate(codproducto, LineasVentasSIC.codproducto);
                                if Item.Get(codproducto) then;

                                if Item.Blocked = true then begin
                                    NegativeInt := Item."Prevent Negative Inventory";
                                    Itembloq := Item.Blocked;
                                    Item."Prevent Negative Inventory" := Item."Prevent Negative Inventory"::No;
                                    Item.Blocked := false;
                                    Item.Modify;
                                end;

                                LineasVentasSIC.Validate("Unidad de medida", 'UD');
                                if (Item."Base Unit of Measure" <> LineasVentasSIC."Unidad de medida") then
                                    LineasVentasSIC.Validate("Unidad de medida", Item."Base Unit of Measure");


                                SalesLine.Validate("No.", codproducto);
                                SalesLine.Validate("Location Code", LineasVentasSIC."Location Code");
                                Evaluate(ConvertCantidad, Format(Abs(LineasVentasSIC.Cantidad)));
                                SalesLine.Validate(Quantity, ConvertCantidad);
                                //SalesLine.VALIDATE("Line Discount Amount",LineasVentasSIC."Importe descuento");

                                //                      END;

                                //                      SalesLine.Origen:=LineasVentasSIC.Origen;
                                //                      IF (LineasVentasSIC.ITBIS = 0) AND (LineasVentasSIC.Origen = LineasVentasSIC.Origen::"Punto de Venta") THEN
                                //                        SalesLine.VALIDATE("VAT Prod. Posting Group", 'BIENEXTO');

                                if LineasVentasSIC."Precio de venta" > 0 then begin
                                    /*//008+
                                    EVALUATE(ConvertPrecio,FORMAT(LineasVentasSIC.Importe / LineasVentasSIC.Cantidad) );
                                    SalesLine.VALIDATE("Unit Price",ABS(ConvertPrecio));
                                    SalesLine.VALIDATE(Amount,ABS(LineasVentasSIC.Importe));
                                    SalesLine.VALIDATE("Amount Including VAT",LineasVentasSIC."Importe ITBIS Incluido");//006+- Se agrega valida a campo "Amount Incluiding VAT" 30/08/2023
                                    EVALUATE(ConvertImporte2,FORMAT(ABS(LineasVentasSIC."Importe descuento")));
                                    SalesLine.VALIDATE("Line Discount Amount",ABS(LineasVentasSIC."Importe descuento"));
                                    *///008-
                                      //008+
                                      //EVALUATE(ConvertPrecio,FORMAT((LineasVentasSIC."Importe ITBIS Incluido"/LineasVentasSIC.Cantidad)+(LineasVentasSIC."Importe descuento")/(LineasVentasSIC.Cantidad)));
                                    Evaluate(ConvertPrecio, Format((LineasVentasSIC.Importe / LineasVentasSIC.Cantidad)));
                                    SalesLine.Validate("Unit Price", Round((Abs(ConvertPrecio)), GenLedSetup."Unit-Amount Rounding Precision"));
                                    //EVALUATE(ConvertImporte2,FORMAT(ABS(LineasVentasSIC."Importe descuento")));
                                    SalesLine.Validate("Line Discount Amount", Round((Abs(LineasVentasSIC."Importe descuento")), GenLedSetup."Unit-Amount Rounding Precision"));
                                    //008-
                                end;

                                //fes mig SalesLine.VALIDATE(SIC,TRUE);
                                //SalesLine.VALIDATE("Source Counter",LineasVentasSIC."Source Counter");
                                SalesLine."No. Documento SIC" := SalesHeader."No. Documento SIC";//LDP-001+-
                                if SalesLine.Insert(true) then;
                                Commit;


                                if Item.Get(codproducto) then begin
                                    Item."Prevent Negative Inventory" := NegativeInt;
                                    Item.Blocked := Itembloq;
                                    Item.Modify;
                                end;
                                //Colocarlo como transferido
                                LineasVentasSIC_2.Reset;
                                LineasVentasSIC_2.SetRange("No. documento", LineasVentasSIC."No. documento");
                                LineasVentasSIC_2.SetRange("No. linea", LineasVentasSIC."No. linea");
                                LineasVentasSIC_2.SetRange("No. documento SIC", SalesHeader."No. Documento SIC");//LDP-001+-
                                if LineasVentasSIC_2.FindFirst then begin
                                    LineasVentasSIC_2.Transferido := true;
                                    if LineasVentasSIC_2.Modify(true) then;
                                end;

                            end else begin
                                LineasVentasSIC.Transferido := true;
                                if LineasVentasSIC.Modify(true) then;
                            end;
                        end;
                    end;
                end;
                Commit;
            until LineasVentasSIC.Next = 0;

    end;

    local procedure StrposDimension(Descripcion: Text[100]): Code[20]
    var
        String: Text;
        SubStr: Text;
        Pos: Integer;
    begin


        // String := Descripcion;
        // SubStr := Concepto;
        // Pos := STRPOS(String, SubStr);
        //MESSAGE( FORMAT(Pos));
        // EquiaConeptosFromHote.RESET;
        // IF EquiaConeptosFromHote.FINDSET THEN BEGIN
        //  REPEAT
        //        String := Descripcion;
        //        SubStr := EquiaConeptosFromHote.Conceptos;
        //        Pos := STRPOS(String, SubStr);
        //        IF Pos > 0 THEN
        //          EXIT(EquiaConeptosFromHote."Valor Dimension BC");
        //  UNTIL EquiaConeptosFromHote.NEXT=0;
        // END;
    end;


    procedure InsertLineaPropina(NoDoc: Code[20]; Doctype: Enum "Sales Document Type")
    var
        NoLinea: Integer;
        SalesLine: Record "Sales Line";
        SalesLine2: Record "Sales Line";
        SalesLine3: Record "Sales Line";
        Monto: Decimal;
        Propina: Decimal;
        SL: Record "Sales Header";
    begin

        if ConfigEmpresa.Get then;

        SL.Reset;
        //SL.SETRANGE("Posting Date",DMY2DATE(1,8,2021));
        //SL.SETRANGE(Origen,SL.Origen::"From Hotel");
        SL.SetRange("No.", NoDoc);
        SL.SetRange("Document Type", Doctype);
        if SL.FindSet then begin
            repeat
                NoDoc := SL."No.";

                SalesLine4.Reset;
                SalesLine4.SetRange("Document No.", NoDoc);
                SalesLine4.SetRange("Document Type", Doctype);
                SalesLine4.SetRange(Type, SalesLine4.Type::"G/L Account");
                //        SalesLine4.SETRANGE(Origen,SalesLine4.Origen::"Punto de Venta");
                if SalesLine4.FindFirst then begin
                    //SalesLine4.DELETE(TRUE);
                end;

                SalesLine.Reset;
                SalesLine.SetRange("Document No.", NoDoc);
                SalesLine.SetRange("Document Type", Doctype);
                //SalesLine.SETRANGE(Origen,SalesLine.Origen::"From Hotel");

                if SalesLine.FindLast then
                    NoLinea := SalesLine."Line No." + 1;

                SalesLine3.Reset;
                SalesLine3.SetRange("Document No.", NoDoc);
                SalesLine3.SetFilter("Shortcut Dimension 2 Code", '<>%1', 'OPER_08');
                SalesLine3.SetRange("Document Type", Doctype);
                SalesLine3.CalcSums(Amount);

                Monto := SalesLine3.Amount;
                Propina := Monto * 0.1;
            // IF SalesLine.Origen= SalesLine.Origen::"From Hotel" THEN BEGIN

            //                SalesLine2.INIT;
            //
            //
            //                SalesLine2."Document No.":=NoDoc;
            //                SalesLine2."Document Type":=SalesLine."Document Type";
            //
            //
            //
            //                //IF Salesline2.INSERT(TRUE) THEN BEGIN
            //                  SalesLine2."Line No." := NoLinea;
            //                  SalesLine2.Type:= SalesLine2.Type::"G/L Account";
            //                  SalesLine2.VALIDATE("No.", ConfigEmpresa."Cuenta Propina");
            //                  SalesLine2.VALIDATE(Quantity,1);
            //                  SalesLine2.VALIDATE("Unit Price",Propina);
            //                  SalesLine2."VAT Prod. Posting Group":= ConfigEmpresa."Grupo Reg. IVA Propina";
            //                  SalesLine2."Shortcut Dimension 2 Code":= SalesLine."Shortcut Dimension 2 Code";
            //
            //
            //                  SalesLine2.INSERT(TRUE);

            //END;
            until SL.Next = 0;
        end;

        //END;
    end;

    local procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text
    var
        FindPos: Integer;
    begin
        FindPos := StrPos(String, FindWhat);
        while FindPos > 0 do begin
            NewString += DelStr(String, FindPos) + ReplaceWith;
            String := CopyStr(String, FindPos + StrLen(FindWhat));
            FindPos := StrPos(String, FindWhat);
        end;
        NewString += String;
    end;

    local procedure EliminarDocumento()
    var
        SH: Record "Sales Header";
        SH2: Record "Sales Header";
        SL: Record "Sales Line";
        EquivalenciaClienteFromHotel2: Record Vendor2;
    begin


        SH.Reset;
        //SH.SETRANGE(Origen,SH.Origen::"Punto de Venta");
        //SH.SETFILTER("No.",'%1|%2','101010000065','101010000025');//JERM-SIC
        //SH.SETRANGE("No.",'401010000049');
        if SH.FindSet then begin
            repeat
                //    SH2.RESET;
                //    SH.SETCURRENTKEY("No.","Document Type");
                //    SH2.SETRANGE("No.",SH."No.");
                //    SH2.SETRANGE("Document Type",SH."Document Type");
                //    IF SH2.FINDFIRST THEN BEGIN
                // //          EquivalenciaClienteFromHotel2.RESET;
                // //          EquivalenciaClienteFromHotel2.SETRANGE("Codigo NCF",SH."Location Code");
                // //          EquivalenciaClienteFromHotel2.SETRANGE(Tipo,EquivalenciaClienteFromHotel2.Tipo::DimResturante);
                // //          IF  EquivalenciaClienteFromHotel2.FINDFIRST THEN;
                // //      SH2.VALIDATE("Shortcut Dimension 2 Code",EquivalenciaClienteFromHotel2."Tipo NCF");
                //      SH2.VALIDATE("Posting No.",'');
                //      SH2.MODIFY(TRUE);
                //    END;

                SL.Reset;
                SL.SetRange("Document No.", SH."No.");
                SL.SetRange("Document Type", SH."Document Type");
                if SL.FindSet then begin
                    //SL.DELETEALL(TRUE);
                end;

            //SH.DELETE(TRUE);
            until SH.Next = 0;
        end;
    end;

    local procedure ActivarTransferido()
    begin
        CabVentasSIC.Reset;
        CabVentasSIC.SetFilter("No. documento", '%1|%2', '101010000065', '101010000025');
        if CabVentasSIC.FindSet then begin
            repeat
                CabVentasSIC.Validate(Transferido, false);

            until CabVentasSIC.Next = 0;
        end;

        LineasVentasSIC.Reset;
        LineasVentasSIC.SetFilter("No. documento", '%1|%2', '101010000065', '101010000025');
        if LineasVentasSIC.FindSet then begin
            repeat
                LineasVentasSIC.Validate(Transferido, false);
            until LineasVentasSIC.Next = 0;
        end;
    end;


    procedure ActualizarMediodepago()
    var
        MPSIC_: Record "Medios de Pago SIC";
        ConfMedPagICG_: Record "Conf. Medios de pago";
        SL: Record "Sales Header";
        SIH: Record "Sales Invoice Header";
    begin

        SL.Reset;
        SL.SetFilter("Payment Method Code", '=%1', '');
        //SL.SETFILTER("Document Type",'%1|%2',SL."Document Type"::Order,SL."Document Type"::"Credit Memo");//LDP-001+-//
        SL.SetFilter("Document Type", '%1|%2', SL."Document Type"::Invoice, SL."Document Type"::"Credit Memo");//LDP-001+- De tipo de documento "Order" a "Invoice"
        SL.SetRange("Venta TPV", true);
        if SL.FindSet then begin
            repeat
                //AMS - Para actualizar la forma de pago
                MPSIC_.Reset;
                SalesHeader.Reset;
                SalesHeader.SetCurrentKey("No.", "Document Type");
                SalesHeader.SetRange("No.", SL."No.");
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
                if SalesHeader.FindFirst then
                    //MPSIC_.SETRANGE("No. documento",SalesHeader."No. Comprobante Fiscal Rel.")//LDP-001+-
                    MPSIC_.SetRange("No. documento SIC", SalesHeader."No. Documento SIC")//LDP-001+- Filtrando por SIC.
                else
                    MPSIC_.SetRange("No. documento", SalesHeader."No.");

                if MPSIC_.FindFirst then begin
                    if ConfMedPagICG_.Get(MPSIC_."Cod. medio de pago") then begin
                        if ConfMedPagICG_."Cod. med. pago" <> '' then begin
                            //                        SalesHeader.RESET;
                            //                        SalesHeader.SETCURRENTKEY("No.","Document Type");
                            //                        SalesHeader.SETRANGE("No.",SL."No.");
                            //                        SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Order);
                            SL.Validate("Payment Method Code", ConfMedPagICG_."Cod. Forma Pago");
                            SL.Modify(true);
                        end;
                    end;

                end else begin
                    SIH.Reset;
                    //SIH.SETRANGE("No. Documento SIC",SalesHeader."No. Comprobante Fiscal Rel.");//LDP-001+-
                    SIH.SetRange("Order No.", SalesHeader."No.");//LDP-001+-
                    SIH.SetRange("No. Documento SIC", SalesHeader."No. Documento SIC");//LDP-001+-Se filtra por No. Documento Sic.
                    SIH.SetRange("Location Code", SalesHeader."Location Code");
                    if SIH.FindFirst then
                        //MPSIC_.SETRANGE("No. documento",SIH."No. Documento SIC")//LDP-001+-
                        MPSIC_.SetRange("No. documento SIC", SIH."No. Documento SIC")//LDP-001+-Se filtra por No. Documento Sic.
                    else
                        MPSIC_.SetRange("No. documento", SL."No.");

                    if MPSIC_.FindFirst then begin
                        if ConfMedPagICG_.Get(MPSIC_."Cod. medio de pago") then begin
                            if ConfMedPagICG_."Cod. med. pago" <> '' then begin
                                SL.Validate("Payment Method Code", ConfMedPagICG_."Cod. Forma Pago");
                                SL.Modify(true);
                            end;
                        end;

                    end;
                    //SalesHeader.VALIDATE("Payment Method Code",SIH."Payment Method Code");

                    //                        SalesHeader.RESET;
                    //                        SalesHeader.SETCURRENTKEY("No.","Document Type");
                    //                        SalesHeader.SETRANGE("No.",SL."No.");
                    //                        SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Order);
                    //SL.VALIDATE("Payment Method Code",'CREDITO');
                    //SL.MODIFY(TRUE);
                end;
            until SL.Next = 0;
        end;
    end;

    local procedure CorregirDocumeto()
    begin


        SalesLine.Reset;
        //SalesLine.SETRANGE(Origen,SalesLine.Origen::"Punto de Venta");

        if SalesLine.FindSet then begin
            repeat

                SalesLine2.Reset;
                SalesLine2.SetRange("Document No.", SalesLine."Document No.");
                SalesLine2.SetRange("Document Type", SalesLine."Document Type");
                SalesLine2.SetRange(Type, SalesLine2.Type::"G/L Account");
                SalesLine2.SetRange("No. Documento SIC", SalesLine."No. Documento SIC");//LDP-001+-
                if not SalesLine2.FindFirst then begin
                    InsertLineaPropina(SalesLine."Document No.", SalesLine."Document Type");
                end;

            until SalesLine.Next = 0;
        end;
    end;

    local procedure ActializarFecha()
    begin

        SalesHeader.Reset;
        SalesHeader.SetRange("Venta TPV", true);
        //SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::"Credit Memo");
        //SalesHeader.SETFILTER("No.",Nos);
        SalesHeader.SetRange("Posting Date", 20221025D, 20221027D);
        if SalesHeader.FindSet then
            repeat
                /*
                CabVentasSIC.RESET;
                CabVentasSIC.SETRANGE("No. documento", SalesHeader."No. Documento SIC");
                CabVentasSIC.SETRANGE("Tipo documento",2);
                CabVentasSIC.SETRANGE("Cod. Almacen",SalesHeader."Location Code");
                IF CabVentasSIC.FINDFIRST THEN BEGIN
                */
                /*SalesHeader2.RESET;
                SalesHeader2.SETRANGE("No.",SalesHeader."No.");
                //SalesHeader2.SETRANGE("Document Type",SalesHeader2."Document Type"::"Credit Memo");
                SalesHeader2.SETRANGE("Location Code",CabVentasSIC."Cod. Almacen");
                SalesHeader2.SETRANGE("Venta TPV", TRUE);
                IF SalesHeader2.FINDFIRST THEN;
                */
                if SalesHeader2.Get(SalesHeader."Document Type", SalesHeader."No.") then begin
                    SalesHeader2.SetHideValidationDialog(true);
                    SalesHeader2.Validate("Posting Date", 20221101D);
                    SalesHeader2.Validate("Order Date", 20221101D);
                    SalesHeader2.Validate(Status, SalesHeader2.Status::Open);
                    SalesHeader2.Validate("Shipment Date", 20221101D);
                    SalesHeader2.Modify(true);
                end;
            /*
            SalesHeader2.VALIDATE("Posting Date",CabVentasSIC.Fecha);
            SalesHeader2.VALIDATE("Order Date",CabVentasSIC.Fecha);
            SalesHeader2.VALIDATE(Status,SalesHeader2.Status::Open);
            SalesHeader2.VALIDATE("Shipment Date",CabVentasSIC.Fecha);
            SalesHeader2.MODIFY(TRUE);
            */
            //END;
            //    SalesLine.RESET;
            //    SalesLine.SETRANGE("Document No.",SalesHeader."No.");
            //    SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
            //    IF SalesLine.FINDSET THEN BEGIN
            //      REPEAT
            //        SalesLine.VALIDATE("Posting Date",CabVentasSIC.Fecha);
            //        SalesLine.MODIFY(TRUE);
            //      UNTIL SalesLine.NEXT=0;
            //    END;

            until SalesHeader.Next = 0;
        //END;

    end;

    local procedure ActualizarLocation()
    begin
        SalesHeader.Reset;
        SalesHeader.SetCurrentKey("No.", "Venta TPV", "Location Code");
        SalesHeader.SetRange("Venta TPV", true);
        SalesHeader.SetFilter("Location Code", '=%1', '');//
        SalesHeader.SetRange("No.", 'VFACPM2-18357');
        if SalesHeader.FindSet then begin
            repeat


                SalesLine.Reset;
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("No. Documento SIC", SalesHeader."No. Documento SIC");//LDP-001+-
                if SalesLine.FindSet then begin
                    repeat
                        SalesLine2.SetRange("Document No.", SalesHeader."No.");
                        SalesLine2.SetRange("Document Type", SalesHeader."Document Type");
                        SalesLine2.SetRange("Line No.", SalesLine."Line No.");
                        SalesLine2.SetRange("No. Documento SIC", SalesLine."No. Documento SIC");//LDP-001+-
                        SalesLine2.SetFilter("Location Code", '=%1', '');
                        if SalesLine2.FindFirst then begin
                            SalesHeader2.Reset;
                            SalesHeader2.SetRange("No.", SalesHeader."No.");
                            SalesHeader2.SetRange("Document Type", SalesHeader."Document Type");
                            SalesHeader2.FindFirst;
                            SalesHeader2.Validate(Status, SalesHeader2.Status::Open);
                            SalesHeader2.Validate("Location Code", 'CTE-003799');
                            SalesHeader2.Modify;
                            SalesLine2.Validate("Location Code", 'CTE-003799');
                            SalesLine2.Modify;
                        end;
                    until SalesLine.Next = 0;
                end;
            until SalesHeader.Next = 0;
        end;
    end;


    procedure CambiaNoBorrador()
    var
        MovCont: Record "G/L Entry";
        MovCont_Out: Record "G/L Entry";
        MovITBIS: Record "VAT Entry";
        MovProd: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        MovCte: Record "Cust. Ledger Entry";
        MovCteDet: Record "Detailed Cust. Ledg. Entry";
        MovContout: Record "G/L Entry";
        MovITBISout: Record "VAT Entry";
        MovProdout: Record "Item Ledger Entry";
        ValueEntryout: Record "Value Entry";
        MovCteout: Record "Cust. Ledger Entry";
        MovCteDetout: Record "Detailed Cust. Ledg. Entry";
        SIH: Record "Sales Invoice Header";
        SIL: Record "Sales Invoice Line";
        SIL_Out: Record "Sales Invoice Line";
        SIH_out: Record "Sales Invoice Header";
        Fecha: Date;
        SIH_outNo: Code[20];
        SIH_outOrderNo: Code[20];
        ConfigCajaElectronica: Record "Config. Caja Electronica";
        CabVentasSIC: Record "Cab. Ventas SIC";
        BankALE: Record "Bank Account Ledger Entry";
        BankALE_Out: Record "Bank Account Ledger Entry";
        SH_: Record "Sales Header";
        SL: Record "Sales Line";
        SL_Out: Record "Sales Line";
        SH_out: Record "Sales Header";
    begin
        SH_.Reset;
        SH_.SetRange("No.", '-1030');
        //SH_.SETRANGE("Document Type",SH_."Document Type"::Order);//LDP-001+-
        SH_.SetRange("Document Type", SH_."Document Type"::Invoice);//LDP-001+-
        if SH_.FindFirst then;

        CabVentasSIC.Reset;
        CabVentasSIC.SetRange("No. documento", SH_."No.");
        CabVentasSIC.SetRange("Cod. Almacen", SH_."Location Code");
        CabVentasSIC.SetRange("No. documento SIC", SH_."No. Documento SIC");//LDP-001+-
        //CabVentasSIC.SETRANGE(Clave,SH_."Transaction Id");

        if CabVentasSIC.FindFirst then;

        ConfigCajaElectronica.Reset;
        ConfigCajaElectronica.SetCurrentKey("Caja ID", Sucursal);
        ConfigCajaElectronica.SetRange("Caja ID", CabVentasSIC.Caja);
        ConfigCajaElectronica.SetRange(Sucursal, CabVentasSIC.Tienda);
        if ConfigCajaElectronica.FindFirst then;

        // SIH_outOrderNo:= ConfigCajaElectronica."No. Serie Pedido"+'-'+CabVentasSIC."No. documento";
        // SIH_outNo:=ConfigCajaElectronica."Serie Factura"+'-'+CabVentasSIC."No. documento";

        SIH_outOrderNo := ConfigCajaElectronica."No. Serie Pedido" + 'VPEDC03C2-1030';
        SIH_outNo := ConfigCajaElectronica."Serie Factura" + 'VFACTRC2-1030';


        SH_out.TransferFields(SH_);
        SH_out."No." := SIH_outOrderNo;
        //SH_out."Order No.":=SIH_outOrderNo;
        SH_out."No. Comprobante Fiscal" := SIH_outNo;
        SH_out."No. Fiscal TPV" := SIH_outNo;
        SH_out."Posting No." := SIH_outNo;
        SH_out."Posting Description" := ReplaceString(SH_out."Posting Description", SH_."No.", SIH_outOrderNo);
        SH_out."External Document No." := SIH_outOrderNo;
        SH_out.Insert;

        SL.SetRange("Document No.", SH_."No.");
        SL.FindSet;
        repeat
            SL_Out.TransferFields(SL);
            SL_Out."Document No." := SIH_outOrderNo;
            //SL_Out."Order No.":=SIH_outOrderNo;
            SL_Out.Insert;
        until SL.Next = 0;


        // LogTran.RESET;
        // LogTran.SETRANGE("Process Code",SH_."No.");
        // IF LogTran.FINDSET THEN BEGIN
        //  REPEAT
        //    LogTranOut.GET(LogTran."Process Code");
        //    LogTranOut."Process Code":=SIH_outOrderNo;
        //    LogTranOut.MODIFY;
        //  UNTIL LogTran.NEXT=0;
        // END;


        SL.SetRange("Document No.", SH_."No.");
        SL.FindSet();
        repeat
        //SL.DELETE;
        until SL.Next = 0;

        //SH_.DELETE;
    end;

    procedure TransferLineaActualizada3(DocNum: Code[20]; Doctype: Enum "Sales Document Type"; DocLocation: Code[20]; DocNoSic: Code[40])
    var
        ConvertLinea: Integer;
        ConvertCantidad: Decimal;
        ConvertImporte2: Decimal;
        ConvertPrecio: Decimal;
        Totales: Integer;
    begin
        // IF GUIALLOWED THEN
        //   Ventana.OPEN(Text001);

        LineasVentasSIC.Reset;
        LineasVentasSIC.SetCurrentKey(Transferido, "No. documento", "Location Code");
        LineasVentasSIC.SetFilter("No. documento", '=%1', DocNum);//JERM-SIC
        LineasVentasSIC.SetRange("Location Code", DocLocation);
        LineasVentasSIC.SetRange("No. documento SIC", DocNoSic);//LDP-001+-
                                                                //LineasVentasSIC.SETRANGE(Transferido, FALSE);
                                                                //LineasVentasSIC.SETFILTER(Errores,'=%1','');
                                                                //LineasVentasSIC.SETRANGE(Fecha,DMY2DATE(1,8,2019),DMY2DATE(30,8,2019));
                                                                //LinVentasIcg.SETRANGE("Caja",'BV01-21111');
        TotContador := LineasVentasSIC.Count;
        if LineasVentasSIC.FindSet then
            repeat

                Evaluate(codproducto, LineasVentasSIC.codproducto);
                Insertar := true;
                if not Item.Get(codproducto) then
                    Insertar := false;
                if Insertar then begin
                    SalesHeader.Reset;
                    SalesHeader.SetCurrentKey("No.", "Document Type");
                    CabVentasSIC.Reset;
                    CabVentasSIC.SetRange("No. documento", LineasVentasSIC."No. documento");
                    CabVentasSIC.SetRange("Cod. Almacen", LineasVentasSIC."Location Code");
                    CabVentasSIC.SetRange("No. documento SIC", LineasVentasSIC."No. documento SIC");//LDP-001+-
                    if CabVentasSIC.FindFirst then;
                    //SalesHeader.SETRANGE("No.",LineasVentasSIC."No. documento");
                    ConfigCajaElectronica.Reset;
                    ConfigCajaElectronica.SetCurrentKey("Caja ID", Sucursal);
                    ConfigCajaElectronica.SetRange("Caja ID", CabVentasSIC.Caja);
                    ConfigCajaElectronica.SetRange(Sucursal, CabVentasSIC.Tienda);
                    if not ConfigCajaElectronica.FindFirst then
                        exit;

                    case LineasVentasSIC."Tipo documento" of
                        1:
                            //SalesHeader.SETRANGE("No.", ConfigCajaElectronica."Serie Factura" +'-'+ CabVentasSIC."No. documento");//LDP-001+-//
                            //SalesHeader.SETRANGE("No.", NoSeriesManagement.GetNextNo(ConfigCajaElectronica."No. Serie Pedido",WORKDATE,TRUE) +'-'+ CabVentasSIC."No. comprobante"); //LDP-001+-
                            SalesHeader.SetRange("No.", CabVentasSIC."No. documento");//LDP-001+-
                        2:
                            //SalesHeader.SETRANGE("No." , ConfigCajaElectronica."Serie Nota de credito" +'-'+ CabVentasSIC."No. documento");//LDP-001+-//
                            //SalesHeader.SETRANGE("No.", NoSeriesManagement.GetNextNo(ConfigCajaElectronica."Serie Nota de credito",WORKDATE,TRUE) +'-'+ CabVentasSIC."No. comprobante"); //LDP-001+-
                            SalesHeader.SetRange("No.", CabVentasSIC."No. documento");
                    end;
                    if LineasVentasSIC."Tipo documento" = 2 then begin
                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
                    end else begin
                        //SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Order);//LDP-001+-//
                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice); //LDP-001+-
                    end;
                    //LDP+-// No hay tipo documento 3 en tabla intermedia.
                    /*
                    IF LineasVentasSIC."Tipo documento" = 3 THEN BEGIN
                      SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Invoice);

                    END;
                    */
                    //END;

                    Totales := SalesHeader.Count;
                    if SalesHeader.FindFirst then begin
                        findline := false;
                        if SalesHeader.Status = SalesHeader.Status::Released then begin
                            SalesHeader.Validate(Status, SalesHeader.Status::Open);
                            SalesHeader.Modify;
                        end;

                        SalesLine2.Reset;
                        SalesLine2.SetRange("Document No.", SalesHeader."No.");
                        SalesLine2.SetRange("Location Code", SalesHeader."Location Code");
                        SalesLine2.SetRange("Document Type", SalesHeader."Document Type");
                        SalesLine2.SetRange("Line No.", LineasVentasSIC."No. linea");
                        SalesLine2.SetRange("No.", LineasVentasSIC.codproducto);
                        if SalesLine2.Count > 0 then
                            findline := true;

                        if CabVentasSIC.FindSet then begin
                            if (findline = false) then begin

                                case CabVentasSIC."Tipo documento" of
                                    1:
                                        SalesLine.Validate("Document Type", SalesLine."Document Type"::Invoice);//LDP-001+- Cambio de order a invoice
                                    2:
                                        SalesLine.Validate("Document Type", SalesLine."Document Type"::"Credit Memo");
                                //LDP-001+- Cambio de order a invoice
                                /*
                                3:
                                 s   SalesLine.VALIDATE("Document Type", SalesLine."Document Type"::Invoice);
                                */
                                //LDP-001+- Cambio de order a invoice
                                end;

                                SalesLine.Validate("Document Type", SalesHeader."Document Type");
                                SalesLine.Validate("Document No.", SalesHeader."No.");
                                Evaluate(ConvertLinea, Format(LineasVentasSIC."No. linea"));
                                SalesLine.Validate("Line No.", ConvertLinea);
                                SalesLine.Quantity := 0;
                                SalesLine.Validate(Type, SalesLine.Type::Item);
                                if UnitofMeasure.Get(LineasVentasSIC."Unidad de medida") then;
                                Evaluate(codproducto, LineasVentasSIC.codproducto);
                                if Item.Get(codproducto) then;

                                if Item.Blocked = true then begin
                                    NegativeInt := Item."Prevent Negative Inventory";
                                    Itembloq := Item.Blocked;
                                    Item."Prevent Negative Inventory" := Item."Prevent Negative Inventory"::No;
                                    Item.Blocked := false;
                                    Item.Modify;
                                end;

                                LineasVentasSIC.Validate("Unidad de medida", 'UD');
                                if (Item."Base Unit of Measure" <> LineasVentasSIC."Unidad de medida") then
                                    LineasVentasSIC.Validate("Unidad de medida", Item."Base Unit of Measure");


                                SalesLine.Validate("No.", codproducto);
                                SalesLine.Validate("Location Code", LineasVentasSIC."Location Code");
                                Evaluate(ConvertCantidad, Format(Abs(LineasVentasSIC.Cantidad)));
                                SalesLine.Validate(Quantity, ConvertCantidad);
                                SalesLine.Validate("Cod. Cupon", LineasVentasSIC.Cupon);
                                //SalesLine.VALIDATE("Line Discount Amount",LineasVentasSIC."Importe descuento");




                                //                      END;



                                //                      SalesLine.Origen:=LineasVentasSIC.Origen;
                                //                      IF (LineasVentasSIC.ITBIS = 0) AND (LineasVentasSIC.Origen = LineasVentasSIC.Origen::"Punto de Venta") THEN
                                //                        SalesLine.VALIDATE("VAT Prod. Posting Group", 'BIENEXTO');



                                if LineasVentasSIC."Precio de venta" > 0 then begin
                                    /*//008+
                                    EVALUATE(ConvertPrecio,FORMAT(LineasVentasSIC.Importe / LineasVentasSIC.Cantidad) );
                                    SalesLine.VALIDATE("Unit Price",ABS(ConvertPrecio));
                                    SalesLine.VALIDATE(Amount,ABS(LineasVentasSIC.Importe));
                                    SalesLine.VALIDATE("Amount Including VAT",LineasVentasSIC."Importe ITBIS Incluido");//006+- Se agrega valida a campo "Amount Incluiding VAT" 30/08/2023
                                    EVALUATE(ConvertImporte2,FORMAT(ABS(LineasVentasSIC."Importe descuento")));
                                    SalesLine.VALIDATE("Line Discount Amount",ABS(LineasVentasSIC."Importe descuento"));
                                    *///008-

                                    //008+
                                    //EVALUATE(ConvertPrecio,FORMAT((LineasVentasSIC."Importe ITBIS Incluido"/LineasVentasSIC.Cantidad)+(LineasVentasSIC."Importe descuento")/(LineasVentasSIC.Cantidad)));
                                    Evaluate(ConvertPrecio, Format((LineasVentasSIC.Importe / LineasVentasSIC.Cantidad)));
                                    SalesLine.Validate("Unit Price", Round((Abs(ConvertPrecio)), GenLedSetup."Unit-Amount Rounding Precision"));
                                    //EVALUATE(ConvertImporte2,FORMAT(ABS(LineasVentasSIC."Importe descuento")));
                                    SalesLine.Validate("Line Discount Amount", Round((Abs(LineasVentasSIC."Importe descuento")), GenLedSetup."Unit-Amount Rounding Precision"));
                                    //008-
                                end;

                                //SalesLine.VALIDATE(SIC,TRUE);
                                //SalesLine.VALIDATE("Source Counter",LineasVentasSIC."Source Counter");

                                if SalesLine.Insert(true) then;
                                Commit;


                                if Item.Get(codproducto) then begin
                                    Item."Prevent Negative Inventory" := NegativeInt;
                                    Item.Blocked := Itembloq;
                                    Item.Modify;
                                end;
                                //Colocarlo como transferido
                                LineasVentasSIC_2.Reset;
                                LineasVentasSIC_2.SetRange("No. documento", LineasVentasSIC."No. documento");
                                LineasVentasSIC_2.SetRange("No. linea", LineasVentasSIC."No. linea");
                                LineasVentasSIC_2.SetRange("No. documento SIC", LineasVentasSIC."No. documento SIC");//LDP-001+-
                                if LineasVentasSIC_2.FindFirst then begin
                                    LineasVentasSIC_2.Transferido := true;
                                    if LineasVentasSIC_2.Modify(true) then;
                                end;

                            end else begin
                                LineasVentasSIC.Transferido := true;
                                if LineasVentasSIC.Modify(true) then;
                            end;
                        end;
                    end;
                end;
                Commit;
            until LineasVentasSIC.Next = 0;

    end;

    local procedure TransferLineaActualizadaManual(NumDoc: Code[40]; tipodoc: Integer; codcliente: Code[20]; SLCode: Code[20]; Lcode: Code[40]; NoDocSic: Code[40])
    var
        ConvertLinea: Integer;
        ConvertCantidad: Decimal;
        ConvertImporte2: Decimal;
        ConvertPrecio: Decimal;
    begin
        GenLedSetup.Get;//008+-

        if ConfigEmpresa.Get then;
        LineasVentasSIC.Reset;
        LineasVentasSIC.SetCurrentKey("No. documento", "No. linea");
        LineasVentasSIC.SetRange("No. documento", NumDoc);
        LineasVentasSIC.SetRange("Location Code", Lcode);
        LineasVentasSIC.SetRange(Transferido, false);
        LineasVentasSIC.SetRange("No. documento SIC", NoDocSic); //LDP-001+- Se agrega No. Doc Sic a filtro.
        //LinVentasIcg.SETFILTER(Errores,'=%1','');
        if LineasVentasSIC.FindSet then
            repeat
                /*IF GUIALLOWED THEN
                  BEGIN
                   Contador := Contador + 1;
                   Ventana.UPDATE(1,LineasVentasSIC."No. documento");
                   Ventana.UPDATE(2,ROUND(Contador / TotContador * 10000,1));
                   //Ventana.UPDATE(3,'PROCESANDO CABECERAS Y LINEAS');
                  END;*/
                Evaluate(codproducto, LineasVentasSIC.codproducto);
                Insertar := true;
                if not Item.Get(codproducto) then
                    Insertar := false;
                if Insertar then begin
                    SalesLine.Init;
                    case tipodoc of
                        1:
                            //SalesLine.VALIDATE("Document Type", SalesLine."Document Type"::Order);//LDP-001+-
                            SalesLine.Validate("Document Type", SalesLine."Document Type"::Invoice);
                        2:
                            SalesLine.Validate("Document Type", SalesLine."Document Type"::"Credit Memo");
                    end;

                    SalesLine.SetHideValidationDialog(true);
                    SalesLine.Validate("Document No.", SLCode);
                    Evaluate(ConvertLinea, Format(LineasVentasSIC."No. linea"));
                    SalesLine.Validate("Line No.", ConvertLinea);
                    SalesLine."No. Documento SIC" := NoDocSic;//LDP-001+-
                    SalesLine.Quantity := 0;
                    //    IF LineasVentasSIC.Origen = LineasVentasSIC.Origen::"From Hotel" THEN BEGIN
                    //      IF LineasVentasSIC.Importe <> 0 THEN BEGIN
                    //        SalesLine.VALIDATE(Type,SalesLine.Type::"G/L Account");
                    //        SalesLine.VALIDATE("No.", ConfigEmpresa.CuentaFromHotel);
                    //        SalesLine.VALIDATE("Shortcut Dimension 1 Code",ConfigEmpresa."Dimension FromHotel");
                    //        SalesLine.VALIDATE("Shortcut Dimension 2 Code",StrposDimension(LineasVentasSIC.Descripcion));
                    //        EVALUATE(ConvertCantidad,FORMAT(ABS(LineasVentasSIC.Cantidad)));
                    //        SalesLine.VALIDATE(Quantity,ConvertCantidad);
                    //        SalesLine.IDRESERVA := LineasVentasSIC.IDRESERVA;
                    //        SalesLine.LOCALIZADOR:= LineasVentasSIC.LOCALIZADOR;
                    //        SalesLine.FECHAENTRADA:= LineasVentasSIC.FECHAENTRADA;
                    //        SalesLine.FECHASALIDA:= LineasVentasSIC.FECHASALIDA;
                    //        SalesLine.CAPTIONHABITACION:= LineasVentasSIC.CAPTIONHABITACION;
                    //      END;
                    //      SalesLine.Description := LineasVentasSIC.Descripcion;
                    //      LineasVentasSIC.VALIDATE("Unidad de medida",'UD');
                    //    END ELSE BEGIN
                    SalesLine.Validate(Type, SalesLine.Type::Item);
                    if UnitofMeasure.Get(LineasVentasSIC."Unidad de medida") then;
                    Evaluate(codproducto, LineasVentasSIC.codproducto);
                    if Item.Get(codproducto) then;

                    if Item.Blocked = true then begin
                        NegativeInt := Item."Prevent Negative Inventory";
                        Itembloq := Item.Blocked;
                        Item."Prevent Negative Inventory" := Item."Prevent Negative Inventory"::No;
                        Item.Blocked := false;
                        Item.Modify;
                    end;



                    LineasVentasSIC.Validate("Unidad de medida", 'UD');
                    if (Item."Base Unit of Measure" <> LineasVentasSIC."Unidad de medida") then
                        LineasVentasSIC.Validate("Unidad de medida", Item."Base Unit of Measure");


                    SalesLine.Validate("No.", codproducto);
                    SalesLine.Validate("Location Code", LineasVentasSIC."Location Code");
                    Evaluate(ConvertCantidad, Format(Abs(LineasVentasSIC.Cantidad)));
                    SalesLine.Validate(Quantity, ConvertCantidad);
                    //SalesLine.VALIDATE("Line Discount Amount",LineasVentasSIC."Importe descuento");
                    //    END;
                    //    SalesLine.Origen:=LineasVentasSIC.Origen;

                    //IF (LineasVentasSIC.ITBIS = 0) AND (LineasVentasSIC.Origen = LineasVentasSIC.Origen::"Punto de Venta") THEN
                    // SalesLine.VALIDATE("VAT Prod. Posting Group", 'BIENEXTO');

                    if LineasVentasSIC."Precio de venta" > 0 then begin
                        //008+ Se comenta porque el calcula da error en importes.
                        /*
                        EVALUATE(ConvertPrecio,FORMAT((LineasVentasSIC.Importe/LineasVentasSIC.Cantidad)) );
                        SalesLine.VALIDATE("Unit Price",ABS(ConvertPrecio));
                        SalesLine.VALIDATE(Amount,ABS(LineasVentasSIC.Importe));
                        SalesLine.VALIDATE("Amount Including VAT",LineasVentasSIC."Importe ITBIS Incluido");//006+- Se agrega valida a campo "Amount Incluiding VAT" 30/08/2023
                        EVALUATE(ConvertImporte2,FORMAT(ABS(LineasVentasSIC."Importe descuento")));
                        SalesLine.VALIDATE("Line Discount Amount",ABS(LineasVentasSIC."Importe descuento"));
                        */
                        //008-
                        //008+
                        //EVALUATE(ConvertPrecio,FORMAT((LineasVentasSIC."Importe ITBIS Incluido"/LineasVentasSIC.Cantidad)+(LineasVentasSIC."Importe descuento")/(LineasVentasSIC.Cantidad)));
                        Evaluate(ConvertPrecio, Format((LineasVentasSIC.Importe / LineasVentasSIC.Cantidad)));
                        SalesLine.Validate("Unit Price", Round((Abs(ConvertPrecio)), GenLedSetup."Unit-Amount Rounding Precision"));
                        //EVALUATE(ConvertImporte2,FORMAT(ABS(LineasVentasSIC."Importe descuento")));
                        SalesLine.Validate("Line Discount Amount", Round((Abs(LineasVentasSIC."Importe descuento")), GenLedSetup."Unit-Amount Rounding Precision"));
                        //008-
                    end;

                    //fes mig SalesLine.VALIDATE(SIC,TRUE);
                    //SalesLine.VALIDATE("Source Counter",LineasVentasSIC."Source Counter");

                    SalesLine."No. Documento SIC" := SalesHeader."No. Documento SIC";//LDP-001+-
                    if SalesLine.Insert(true) then;
                    Commit;

                    if Item.Get(codproducto) then begin
                        Item."Prevent Negative Inventory" := NegativeInt;
                        Item.Blocked := Itembloq;
                        Item.Modify;
                    end;
                end;
                //Colocarlo como transferido
                LineasVentasSIC_2.Reset;
                LineasVentasSIC_2.SetRange("No. documento", LineasVentasSIC."No. documento");
                LineasVentasSIC_2.SetRange("No. linea", LineasVentasSIC."No. linea");
                LineasVentasSIC_2.SetRange("No. documento SIC", NoDocSic); //LDP-001+- Se agrega No. Doc Sic a filtro.
                if LineasVentasSIC_2.FindFirst then begin
                    LineasVentasSIC_2.Transferido := true;
                    LineasVentasSIC_2.Modify(true);
                end;

            until LineasVentasSIC.Next = 0;
        //InsertLineaPropina(NumDoc,tipodoc);

        //        SalesHeader2.RESET;
        //        SalesHeader2.SETRANGE("No.",SLCode);
        //
        //        IF SalesHeader2.FINDFIRST THEN BEGIN
        //          SalesHeader2.VALIDATE(Status,SalesHeader2.Status::Released);
        //          SalesHeader2.MODIFY;
        //        END;

    end;

    procedure RecalcularLineas(NumDoc: Code[40]; tipodoc: Integer; codcliente: Code[20]; SLCode: Code[20]; Lcode: Code[40]; NoDocSic: Code[40])
    var
        ConvertLinea: Integer;
        ConvertCantidad: Decimal;
        ConvertImporte2: Decimal;
        ConvertPrecio: Decimal;
        NoFactaAnulada: Code[20];
    begin
        GenLedSetup.Get;//008+-

        if ConfigEmpresa.Get then;

        //016+
        if tipodoc = 2 then begin
            Clear(NoFactaAnulada);
            xrSalesHeader.Reset;
            xrSalesHeader.SetRange("No.", NumDoc);
            xrSalesHeader.SetRange("Document Type", xrSalesHeader."Document Type"::"Credit Memo");
            if xrSalesHeader.FindFirst then
                NoFactaAnulada := xrSalesHeader."Anula a Documento";
        end;
        //016-

        LineasVentasSIC.Reset;
        LineasVentasSIC.SetCurrentKey("No. documento", "No. linea");
        LineasVentasSIC.SetRange("No. documento", NumDoc);
        LineasVentasSIC.SetRange("Location Code", Lcode);
        //LineasVentasSIC.SETRANGE(Transferido,FALSE);
        LineasVentasSIC.SetRange("No. documento SIC", NoDocSic); //LDP-001+- Se agrega No. Doc Sic a filtro.
        //LinVentasIcg.SETFILTER(Errores,'=%1','');
        if LineasVentasSIC.FindSet then
            repeat
                /*IF GUIALLOWED THEN
                  BEGIN
                   Contador := Contador + 1;
                   Ventana.UPDATE(1,LineasVentasSIC."No. documento");
                   Ventana.UPDATE(2,ROUND(Contador / TotContador * 10000,1));
                   //Ventana.UPDATE(3,'PROCESANDO CABECERAS Y LINEAS');
                  END;*/
                Evaluate(codproducto, LineasVentasSIC.codproducto);
                Insertar := true;
                if not Item.Get(codproducto) then
                    Insertar := false;
                if Insertar then begin
                    SalesLine.Init;
                    case tipodoc of
                        1:
                            //SalesLine.VALIDATE("Document Type", SalesLine."Document Type"::Order);//LDP-001+-
                            SalesLine.Validate("Document Type", SalesLine."Document Type"::Invoice);
                        2:
                            SalesLine.Validate("Document Type", SalesLine."Document Type"::"Credit Memo");
                    end;

                    SalesLine.SetHideValidationDialog(true);
                    SalesLine.Validate("Document No.", SLCode);
                    Evaluate(ConvertLinea, Format(LineasVentasSIC."No. linea"));
                    SalesLine.Validate("Line No.", ConvertLinea);
                    SalesLine."No. Documento SIC" := NoDocSic;//LDP-001+-
                    SalesLine.Quantity := 0;
                    //    IF LineasVentasSIC.Origen = LineasVentasSIC.Origen::"From Hotel" THEN BEGIN
                    //      IF LineasVentasSIC.Importe <> 0 THEN BEGIN
                    //        SalesLine.VALIDATE(Type,SalesLine.Type::"G/L Account");
                    //        SalesLine.VALIDATE("No.", ConfigEmpresa.CuentaFromHotel);
                    //        SalesLine.VALIDATE("Shortcut Dimension 1 Code",ConfigEmpresa."Dimension FromHotel");
                    //        SalesLine.VALIDATE("Shortcut Dimension 2 Code",StrposDimension(LineasVentasSIC.Descripcion));
                    //        EVALUATE(ConvertCantidad,FORMAT(ABS(LineasVentasSIC.Cantidad)));
                    //        SalesLine.VALIDATE(Quantity,ConvertCantidad);
                    //        SalesLine.IDRESERVA := LineasVentasSIC.IDRESERVA;
                    //        SalesLine.LOCALIZADOR:= LineasVentasSIC.LOCALIZADOR;
                    //        SalesLine.FECHAENTRADA:= LineasVentasSIC.FECHAENTRADA;
                    //        SalesLine.FECHASALIDA:= LineasVentasSIC.FECHASALIDA;
                    //        SalesLine.CAPTIONHABITACION:= LineasVentasSIC.CAPTIONHABITACION;
                    //      END;
                    //      SalesLine.Description := LineasVentasSIC.Descripcion;
                    //      LineasVentasSIC.VALIDATE("Unidad de medida",'UD');
                    //    END ELSE BEGIN
                    SalesLine.Validate(Type, SalesLine.Type::Item);
                    if UnitofMeasure.Get(LineasVentasSIC."Unidad de medida") then;
                    Evaluate(codproducto, LineasVentasSIC.codproducto);
                    if Item.Get(codproducto) then;

                    if Item.Blocked = true then begin
                        NegativeInt := Item."Prevent Negative Inventory";
                        Itembloq := Item.Blocked;
                        Item."Prevent Negative Inventory" := Item."Prevent Negative Inventory"::No;
                        Item.Blocked := false;
                        Item.Modify;
                    end;



                    LineasVentasSIC.Validate("Unidad de medida", 'UD');
                    if (Item."Base Unit of Measure" <> LineasVentasSIC."Unidad de medida") then
                        LineasVentasSIC.Validate("Unidad de medida", Item."Base Unit of Measure");


                    SalesLine.Validate("No.", codproducto);
                    SalesLine.Validate("Location Code", LineasVentasSIC."Location Code");
                    Evaluate(ConvertCantidad, Format(Abs(LineasVentasSIC.Cantidad)));
                    SalesLine.Validate(Quantity, ConvertCantidad);
                    //SalesLine.VALIDATE("Line Discount Amount",LineasVentasSIC."Importe descuento");
                    //    END;
                    //    SalesLine.Origen:=LineasVentasSIC.Origen;

                    //IF (LineasVentasSIC.ITBIS = 0) AND (LineasVentasSIC.Origen = LineasVentasSIC.Origen::"Punto de Venta") THEN
                    // SalesLine.VALIDATE("VAT Prod. Posting Group", 'BIENEXTO');

                    if LineasVentasSIC."Precio de venta" > 0 then begin
                        //008+ Se comenta porque el calcula da error en importes.
                        /*
                        EVALUATE(ConvertPrecio,FORMAT((LineasVentasSIC.Importe/LineasVentasSIC.Cantidad)) );
                        SalesLine.VALIDATE("Unit Price",ABS(ConvertPrecio));
                        SalesLine.VALIDATE(Amount,ABS(LineasVentasSIC.Importe));
                        SalesLine.VALIDATE("Amount Including VAT",LineasVentasSIC."Importe ITBIS Incluido");//006+- Se agrega valida a campo "Amount Incluiding VAT" 30/08/2023
                        EVALUATE(ConvertImporte2,FORMAT(ABS(LineasVentasSIC."Importe descuento")));
                        SalesLine.VALIDATE("Line Discount Amount",ABS(LineasVentasSIC."Importe descuento"));
                        */
                        //008-
                        //008+
                        //EVALUATE(ConvertPrecio,FORMAT((LineasVentasSIC."Importe ITBIS Incluido"/LineasVentasSIC.Cantidad)+(LineasVentasSIC."Importe descuento")/(LineasVentasSIC.Cantidad)));
                        Evaluate(ConvertPrecio, Format((LineasVentasSIC.Importe / LineasVentasSIC.Cantidad)));
                        SalesLine.Validate("Unit Price", Round((Abs(ConvertPrecio)), GenLedSetup."Unit-Amount Rounding Precision"));
                        //EVALUATE(ConvertImporte2,FORMAT(ABS(LineasVentasSIC."Importe descuento")));
                        SalesLine.Validate("Line Discount Amount", Round((Abs(LineasVentasSIC."Importe descuento")), GenLedSetup."Unit-Amount Rounding Precision"));
                        //008-
                    end;

                    //fes mig SalesLine.VALIDATE(SIC,TRUE);
                    //SalesLine.VALIDATE("Source Counter",LineasVentasSIC."Source Counter");

                    //016+
                    if tipodoc = 2 then begin
                        Clear(rVatPostGroup);
                        rVatPostGroup := FindInLineVatPostingGroup(NoFactaAnulada, codproducto);
                        SalesLine.Validate("VAT Prod. Posting Group", rVatPostGroup);
                    end;
                    //016-

                    //SalesLine."No. Documento SIC" := SalesHeader."No. Documento SIC";//LDP-001+-
                    if SalesLine.Insert(true) then;
                    Commit;

                    if Item.Get(codproducto) then begin
                        Item."Prevent Negative Inventory" := NegativeInt;
                        Item.Blocked := Itembloq;
                        Item.Modify;
                    end;
                end;
                //Colocarlo como transferido
                LineasVentasSIC_2.Reset;
                LineasVentasSIC_2.SetRange("No. documento", LineasVentasSIC."No. documento");
                LineasVentasSIC_2.SetRange("No. linea", LineasVentasSIC."No. linea");
                LineasVentasSIC_2.SetRange("No. documento SIC", NoDocSic); //LDP-001+- Se agrega No. Doc Sic a filtro.
                if LineasVentasSIC_2.FindFirst then begin
                    LineasVentasSIC_2.Transferido := true;
                    LineasVentasSIC_2.Modify;
                end;

            until LineasVentasSIC.Next = 0;
        //InsertLineaPropina(NumDoc,tipodoc);

        //        SalesHeader2.RESET;
        //        SalesHeader2.SETRANGE("No.",SLCode);
        //
        //        IF SalesHeader2.FINDFIRST THEN BEGIN
        //          SalesHeader2.VALIDATE(Status,SalesHeader2.Status::Released);
        //          SalesHeader2.MODIFY;
        //        END;

    end;

    procedure RecalclularImporteLineas()
    var
        SalesLine: Record "Sales Line";
        ImporteLinSIC: Decimal;
        ImporteMPSIC: Decimal;
        ImporteSalesLine: Decimal;
        CabVentasSIC: Record "Cab. Ventas SIC";
        LineasVentasSIC: Record "Lineas Ventas SIC";
        MediosdePagoSIC: Record "Medios de Pago SIC";
        SalesHeader: Record "Sales Header";
        Transfer_SIC: Codeunit Transfer_SIC;
        SalesLine_: Record "Sales Line";
    begin
        SalesHeader.Reset;
        SalesHeader.SetRange("Venta TPV", true);
        SalesHeader.SetRange(SalesHeader."Document Type", SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo");
        SalesHeader.SetFilter("No. Documento SIC", '<>1%', '');
        //SalesHeader.SETFILTER("Error Registro",'<>%1','');
        //SalesHeader.SETRANGE("No.",'NCY3-000130');
        //Rec.SETRANGE("Error Registro",'Error entre el importe de las lineas y la cabecera');
        if SalesHeader.FindSet then begin
            repeat
                SalesHeader.Status := SalesHeader.Status::Open;
                SalesHeader.Modify;

                CabVentasSIC.Reset;
                LineasVentasSIC.Reset;
                MediosdePagoSIC.Reset;
                Clear(ImporteLinSIC);
                Clear(ImporteMPSIC);
                Clear(ImporteSalesLine);

                ImporteLinSIC := 0;
                ImporteMPSIC := 0;

                CabVentasSIC.SetRange("No. documento", SalesHeader."No.");
                CabVentasSIC.SetRange("No. documento SIC", SalesHeader."No. Documento SIC");
                if CabVentasSIC.FindFirst then;

                LineasVentasSIC.SetRange("No. documento", SalesHeader."No.");
                LineasVentasSIC.SetRange("No. documento SIC", SalesHeader."No. Documento SIC");
                if LineasVentasSIC.FindSet then
                    repeat
                        ImporteLinSIC += LineasVentasSIC."Importe ITBIS Incluido";
                    until LineasVentasSIC.Next = 0;

                MediosdePagoSIC.SetRange("No. documento", SalesHeader."No.");
                MediosdePagoSIC.SetRange("No. documento SIC", SalesHeader."No. Documento SIC");
                if MediosdePagoSIC.FindSet then
                    repeat
                        ImporteMPSIC += MediosdePagoSIC.Importe;
                    until MediosdePagoSIC.Next = 0;

                SalesLine.Reset();
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.CalcSums("Amount Including VAT");
                if SalesLine.FindSet then
                    repeat
                        ImporteSalesLine += SalesLine."Amount Including VAT";
                    //SalesLine.DELETE;
                    until SalesLine.Next = 0;

                if (((ImporteLinSIC - ImporteSalesLine) < -1) or ((ImporteLinSIC - ImporteSalesLine) > 1)) or
                  (((ImporteMPSIC - ImporteSalesLine) < -1) or ((ImporteMPSIC - ImporteSalesLine) > 1)) then begin
                    //02/06/2024+
                    SalesLine_.Reset();
                    SalesLine_.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLine_.SetRange("Document No.", SalesHeader."No.");
                    //SalesLine_.CALCSUMS("Amount Including VAT");
                    if SalesLine_.FindSet then
                        repeat
                            //ImporteSalesLine += SalesLine."Amount Including VAT";
                            SalesLine_.Delete;
                        until SalesLine_.Next = 0;
                    //02/06/2024-

                    Transfer_SIC.RecalcularLineas(CabVentasSIC."No. documento", CabVentasSIC."Tipo documento", SalesHeader."Sell-to Customer No.", SalesHeader."No.", CabVentasSIC."Cod. Almacen", CabVentasSIC."No. documento SIC");
                    SalesHeader."Error Registro" := '';
                    SalesHeader.Modify;
                end;
            until SalesHeader.Next = 0;
            Message('Actualizacion de importe en línea satisfactoria');
            SalesHeader.Status := SalesHeader.Status::Open;
            SalesHeader.Modify;
            Commit;
        end else
            Message('No hay registros con errores de importe en línea');
    end;

    local procedure FindInLineVatPostingGroup(InvoiceNo: Code[20]; ItemNo: Code[20]): Code[20]
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.Reset;
        SalesInvoiceLine.SetCurrentKey("Document No.", "No.");
        SalesInvoiceLine.SetRange("Document No.", InvoiceNo);
        SalesInvoiceLine.SetRange("No.", ItemNo);
        if SalesInvoiceLine.FindFirst then
            exit(SalesInvoiceLine."VAT Prod. Posting Group");
    end;


    procedure RemoveExtraWhiteSpaces(StrParam: Text[1024]) StrReturn: Text[1024]
    var
        Cntr1: Integer;
        Cntr2: Integer;
        WhiteSpaceFound: Boolean;
    begin
        StrParam := DelChr(StrParam, '<>', ' ');
        //LDP-010+-
        //Se aplica control para que remplace espacio
        //doble por espacio simple, que generaba error 008.
        StrParam := ConvertStr(StrParam, '', ' ');
        //LDP-010+-
        WhiteSpaceFound := false;
        Cntr2 := 1;
        for Cntr1 := 1 to StrLen(StrParam) do begin
            if StrParam[Cntr1] <> ' ' then begin
                WhiteSpaceFound := false;
                StrReturn[Cntr2] := StrParam[Cntr1];
                Cntr2 += 1;
            end else begin
                if not WhiteSpaceFound then begin
                    WhiteSpaceFound := true;
                    StrReturn[Cntr2] := StrParam[Cntr1];
                    Cntr2 += 1;
                end;
            end;
        end;
    end;

    local procedure FindFactGrupRegIvaProd()
    begin
    end;
}

