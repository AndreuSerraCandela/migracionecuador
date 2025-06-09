codeunit 56050 "Clasificacion devoluciones"
{
    //  YFC :  Yefrecis Francisco Cruz
    //  FES :  Fausto Serrata
    //  JERM: Juan E Rosario
    // 
    // $001 05/May/14 JML : Clasificación devoluciones. Versión inicial.
    // $002 20/May/14 JML : Correcciones varias.
    // $003 26/May/14 JML : Correcciones varias.
    // 
    // 004  02/03/15  CAT: Permitimos realizar las devoluciones sin consignación y al generar la devolución, traemos el descuento de la linea de la venta.
    // 
    // 005  27/04/15 #17852  CAT: Traemos siempre el descuento de la factura aunque sea 0. Con ello, nos aseguramos que el descuento de la devolucion coincide con el
    //                     de la factura, ya que los productos pueden tener descuentos pero no se hayan aplicado a las facturas originales.
    // #26400 21/07/15 JML : Precios de la factura original
    // #22823  24/08/2015  MOI   Se deben tener en cuenta las notas de credito ya registradas  a la hora de guardar las facturas.
    // #36182  20/11/2015  MOI   Se tiene que copiar los nuevos campos creados en la tabla 56025.
    // 
    // Nota: desde el $005 al $0018 pertenecia al WI 48474 y no se incluye en la Estandarizacion (Estaba en Panama)
    // $019 13/11/18    YFC : #175585 Modificacion Clasificacion Devoluciones
    // $020 22/04/2020  YFC : Emitir un solo Documento ClasDEv Santinav-505
    // $021 20/04/2020  YFC : Cantidad - Devuelta (Estandarizacion)
    // $022 17-07-2020  FES : SANTTINAV-1575 - Adicionar filtro para evitar error NCF Relacionado en Blanco
    // $023 01/12/2020  YFC : SANTINAV-1580  Mejoras
    // $024 20/01/2022  JERM:  SANTINAV-2791
    // $025 11/07/2023  LDP   SANTINAV-4735:Lista clasificación devoluciones - cod colegio
    // $026 17/04/2024  LDP   SANTINAV-6183:Clasificación devoluciones - cambio IVA - notas de crédito

    Permissions = TableData "Sales Invoice Line" = rimd;
    TableNo = "Cab. clas. devolucion";

    trigger OnRun()
    begin

        if not rec.Closed then
            Error(Text001, rec."No.");

        intTotal := rec.Count;
        dtClasificacion := CurrentDateTime;

        if not rec.Procesada then begin

            rec.TestField("Customer no.");
            rec.TestField("Cod. Almacen");

            recCfgSantillana.Get;
            recCfgSantillana.TestField("Almacen prod. defectuosos");

            dlgProgeso.Open(Text006 + Text007 + Text008 + Text009 + Text010 + Text011);
            dlgProgeso.Update(1, Text005);
            dlgProgeso.Update(2, rec."No.");
            dlgProgeso.Update(3, rec."Customer no.");


            recCliente.Get(rec."Customer no.");//+004

            recUsuAlm.Reset;
            recUsuAlm.SetRange("User ID", UserId);
            recUsuAlm.SetRange(Default, true);
            recUsuAlm.FindFirst;

            GenerarTablaTempProductos(Rec);

            if recCliente."Cod. Almacen Consignacion" <> '' then //+004
                ClasificarDevConsignacion(Rec);

            // GenerarTablaTempFacturas(Rec);

            //SANTINAV-2791
            if Rec."Ship-to Code" = '' then
                GenerarTablaTempFacturas(Rec)
            else
                GenerarTablaTempFacturas2(Rec);
            //SANTINAV-2791


            if recCfgSantillana."Emitir un Solo Documento" then   // ++ $020
                ClasificarDevVentas_Uno(Rec)
            else // -- $020
                ClasificarDevVentas(Rec);

            //JML Para pruebas. Despues del proceso no deberian quedar productos remanentes
            //recTmpProd.RESET;
            //recTmpProd.SETFILTER(Cantidad, '<>%1', 0);
            //IF recTmpProd.FINDFIRST THEN
            //  ERROR('No se han realizado todas las devoluciones');
            //recTmpProd.RESET;
            //recTmpProd.SETFILTER("Cantidad defectuosa", '<>%1', 0);
            //IF recTmpProd.FINDFIRST THEN
            //  ERROR('No se han realizado todas las devoluciones de defectuosos');
            //

            rec.Procesada := true;
            rec."Usuario clasificacion" := UserId;
            rec."Fecha hora clasificacion" := dtClasificacion;
            rec.Modify;

            if intTotal > 0 then
                dlgProgeso.Update(6, Round(TraerPracesados(Rec) / intTotal * 10000, 1));

        end;
    end;

    var
        Text001: Label 'El documento de devolución %1 debe estar cerrado.';
        Text002: Label 'El documento de devolución %1 no debe estar procesado.';
        recUsuAlm: Record "Warehouse Employee";
        recCfgSantillana: Record "Config. Empresa";
        Text003: Label 'El documento de devolución %1 no contiene líneas.';
        recTmpProd: Record "Tmp productos a devolver" temporary;
        recTmpFact: Record "Tmp facturas a liquidar" temporary;
        recTmpFactProd: Record "Tmp facturas a liquidar" temporary;
        recTmpFactLiquidadas: Record "Tmp facturas a liquidar" temporary;
        recTmpTransfer: Record "Transfer Header" temporary;
        Text004: Label 'Automatic return from customer %1';
        dlgProgeso: Dialog;
        optTipoDoc: Option Transferencia,Venta;
        Text005: Label 'Generando documentos';
        Text006: Label '################################1\\';
        Text007: Label 'Clas. devolución      ##########2\';
        Text008: Label 'Cliente               ##########3\\';
        Text009: Label 'Transfer.  generada   ##########4\';
        Text010: Label 'Dev. venta generada   ##########5\';
        Text011: Label '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@6';
        intTotal: Integer;
        dtClasificacion: DateTime;
        recCliente: Record Customer;
        FiltroDescuento: Decimal;
        lrConfEmpresa: Record "Config. Empresa";
        CantPendientes: Boolean;
        L: Boolean;
        VatProdPostingGroup: Code[20];


    procedure GenerarTablaTempProductos(var recPrmCabDev: Record "Cab. clas. devolucion")
    var
        recLinDev: Record "Lin. clas. devoluciones";
    begin

        //Genera una tabla con los productos y las cantidades totales que se deben devolver

        recLinDev.Reset;
        recLinDev.SetRange("No. Documento", recPrmCabDev."No.");
        recLinDev.SetFilter("Item No.", '<>%1', '');
        recLinDev.SetFilter(Quantity, '<>%1', 0);
        if recLinDev.FindSet then
            repeat

                recLinDev.CalcFields("Inventario en Consignacion");

                recTmpProd.Reset;
                recTmpProd.SetRange("Item No.", recLinDev."Item No.");
                if recTmpProd.FindSet then begin
                    //      IF recLinDev."Con defecto" THEN                                            //$002
                    if (recLinDev."Con defecto" or recLinDev.Recuperable) then                   //
                        recTmpProd."Cantidad defectuosa" += recLinDev.Quantity
                    else
                        recTmpProd.Cantidad += recLinDev.Quantity;
                    recTmpProd.Modify;
                end
                else begin
                    recTmpProd.Init;
                    recTmpProd."Customer No." := recLinDev."Customer No.";
                    recTmpProd."Document No." := recLinDev."No. Documento";
                    recTmpProd."Item No." := recLinDev."Item No.";
                    //      IF recLinDev."Con defecto" THEN                                            //$002
                    if (recLinDev."Con defecto" or recLinDev.Recuperable) then                   //
                        recTmpProd."Cantidad defectuosa" := recLinDev.Quantity
                    else
                        recTmpProd.Cantidad := recLinDev.Quantity;

                    recTmpProd."Inventario en Consignacion" := recLinDev."Inventario en Consignacion";
                    recTmpProd.Insert;
                end;
            until recLinDev.Next = 0;
    end;


    procedure ClasificarDevConsignacion(var recPrmCabDev: Record "Cab. clas. devolucion")
    var
        decCdadADev: Decimal;
    begin

        recTmpProd.Reset;
        if recTmpProd.FindSet then
            repeat

                //Si hay inventario enconsignación se generaran devoluciones de transferencias.

                if recTmpProd."Inventario en Consignacion" <> 0 then begin

                    //Productos sin defectos
                    if recTmpProd.Cantidad <> 0 then begin
                        if recTmpProd."Inventario en Consignacion" > recTmpProd.Cantidad then
                            decCdadADev := recTmpProd.Cantidad
                        else
                            decCdadADev := recTmpProd."Inventario en Consignacion";

                        GenerarTransfer(recPrmCabDev, recPrmCabDev."Cod. Almacen", recTmpProd."Item No.", decCdadADev);
                        recTmpProd."Inventario en Consignacion" -= decCdadADev;
                        recTmpProd.Cantidad -= decCdadADev;
                        recTmpProd.Modify;

                        // ++ $021  Proceso para colocar cantidad devuelta  en ped consignacion
                        ProcesoCantDevueltaConsignacion(decCdadADev, recTmpProd."Item No.", TraerAlmacenConsigna(recPrmCabDev."Customer no."));
                        // --

                    end;

                    //Productos defectuosos
                    if recTmpProd."Inventario en Consignacion" <> 0 then begin
                        if recTmpProd."Cantidad defectuosa" <> 0 then begin
                            if recTmpProd."Inventario en Consignacion" > recTmpProd."Cantidad defectuosa" then
                                decCdadADev := recTmpProd."Cantidad defectuosa"
                            else
                                decCdadADev := recTmpProd."Inventario en Consignacion";
                            if decCdadADev <> 0 then begin
                                GenerarTransfer(recPrmCabDev, recCfgSantillana."Almacen prod. defectuosos", recTmpProd."Item No.", decCdadADev);
                                recTmpProd."Inventario en Consignacion" -= decCdadADev;
                                recTmpProd."Cantidad defectuosa" -= decCdadADev;
                                recTmpProd.Modify;
                                // ++ $021  Proceso para colocar cantidad devuelta en ped consignacion
                                ProcesoCantDevueltaConsignacion(decCdadADev, recTmpProd."Item No.", TraerAlmacenConsigna(recPrmCabDev."Customer no."));
                                // --

                            end;
                        end;
                    end;
                end;

            until recTmpProd.Next = 0;
    end;


    procedure GenerarTransfer(var recPrmCabDev: Record "Cab. clas. devolucion"; codPrmAlmDestino: Code[10]; codPrmProd: Code[20]; decPrmCdad: Decimal)
    var
        recLinDev: Record "Lin. clas. devoluciones";
        codTrans: Code[20];
    begin
        recTmpTransfer.Reset;
        recTmpTransfer.SetRange("Transfer-from Code", TraerAlmacenConsigna(recPrmCabDev."Customer no."));
        recTmpTransfer.SetRange("Transfer-to Code", codPrmAlmDestino);
        if recTmpTransfer.FindFirst then
            codTrans := recTmpTransfer."No."
        else
            codTrans := InsertarCabTrans(recPrmCabDev, codPrmAlmDestino);

        InsertarLinTrans(codTrans, codPrmProd, decPrmCdad);
    end;


    procedure InsertarCabTrans(var recPrmCabDev: Record "Cab. clas. devolucion"; codPrmAlmDestino: Code[10]): Code[20]
    var
        recCabTrans: Record "Transfer Header";
    begin
        recCabTrans.Init;
        recCabTrans."Devolucion Consignacion" := true;
        recCabTrans."Pedido Consignacion" := true;
        recCabTrans.Insert(true);
        recCabTrans.Validate("Transfer-from Code", TraerAlmacenConsigna(recPrmCabDev."Customer no."));
        recCabTrans.Validate("Transfer-to Code", codPrmAlmDestino);
        recCabTrans.Validate("Posting Date", WorkDate);
        recCabTrans."External Document No." := recPrmCabDev."External document no.";
        recCabTrans.Modify(true);

        recTmpTransfer.Init;
        recTmpTransfer."No." := recCabTrans."No.";
        recTmpTransfer."Transfer-from Code" := recCabTrans."Transfer-from Code";
        recTmpTransfer."Transfer-to Code" := recCabTrans."Transfer-to Code";
        recTmpTransfer.Insert;

        InsertarDocRelacionado(recPrmCabDev."No.", optTipoDoc::Transferencia, recCabTrans."No.");

        dlgProgeso.Update(4, recCabTrans."No.");

        exit(recCabTrans."No.");
    end;


    procedure InsertarLinTrans(codPrmTrans: Code[20]; codPrmProd: Code[20]; decPrmCdad: Decimal)
    var
        recLinTrans: Record "Transfer Line";
        intLinea: Integer;
    begin

        recLinTrans.Reset;
        recLinTrans.SetRange("Document No.", codPrmTrans);
        if recLinTrans.FindLast then
            intLinea := recLinTrans."Line No.";

        intLinea += 10000;

        recLinTrans.Init;
        recLinTrans."Document No." := codPrmTrans;
        recLinTrans."Line No." := intLinea;
        recLinTrans.Validate("Item No.", codPrmProd);
        recLinTrans.Validate(Quantity, decPrmCdad);
        recLinTrans.Insert(true);
    end;


    procedure ClasificarDevVentas(var recPrmCabDev: Record "Cab. clas. devolucion")
    var
        decCdadADev: Decimal;
        codCabVta: Code[20];
        decCdadLiq: Decimal;
        blnPrimeraVez: Boolean;
    begin

        //Los productos, para los que no se ha generado transferencia devolución consignación, se inluirán en devoluciones de venta.

        //Los productos, sin defectos, se incluirán en devoluciones que liquidarán facturas de venta
        //Los productos defectuosos se inluirán en una devolución sin liquidar factura de venta
        //Y los productos, sin defectos, que no se pueden liquidar con facturas de venta se incluirán en una devolución sin liquidar factura


        //Devolución de productos sin defectos liquidables :

        //Si quedan algún producto por devolver
        recTmpProd.Reset;
        recTmpProd.SetFilter(Cantidad, '<>%1', 0);
        if recTmpProd.FindFirst then begin
            recTmpFact.Reset;
            if recTmpFact.FindSet then
                repeat
                    recTmpFactProd.Reset;
                    recTmpFactProd.SetRange("No. factura", recTmpFact."No. factura");
                    recTmpFactProd.SetFilter("Cantidad liquidable", '<>%1', 0);
                    if recTmpFactProd.FindSet then begin
                        blnPrimeraVez := true;
                        repeat
                            recTmpProd.Reset;
                            recTmpProd.SetRange("Item No.", recTmpFactProd."No. producto");
                            recTmpProd.SetFilter(Cantidad, '<>%1', 0);
                            if recTmpProd.FindFirst then begin
                                if recTmpProd.Cantidad <= recTmpFactProd."Cantidad liquidable" then
                                    decCdadLiq := recTmpProd.Cantidad
                                else
                                    decCdadLiq := recTmpFactProd."Cantidad liquidable";

                                recTmpProd.Cantidad -= decCdadLiq;
                                recTmpProd.Modify;

                                if blnPrimeraVez then begin
                                    blnPrimeraVez := false;
                                    codCabVta := InsertarCabDev(recPrmCabDev, true,
                                                                recTmpFact."No. factura",
                                                                recTmpFact.Pendiente,
                                                                recPrmCabDev."Cod. Almacen");
                                end;
                                //InsertarLinDev(codCabVta,recTmpFactProd,decCdadLiq,TRUE); // // $021 //026+-

                                // 026+ //22/04/2024
                                Clear(VatProdPostingGroup);
                                VatProdPostingGroup := FindInLineVatPostingGroup(recTmpFact."No. factura", recTmpFactProd."No. producto");
                                InsertarLinDev(codCabVta, recTmpFactProd, decCdadLiq, true, VatProdPostingGroup); // // $021 //$026+ //Se agrega el parametro VatProdPostingGroup //17-04-2024
                                                                                                                  // 026- //22/04/2024

                                recTmpFactProd."Cantidad liquidable" -= decCdadLiq;
                                recTmpFactProd.Modify;
                            end;

                        until recTmpFactProd.Next = 0;
                        LanzarCabDev(codCabVta);
                    end;
                until recTmpFact.Next = 0;
        end;

        //Devolución de productos defectuosos liquidables :

        //Si quedan algún producto defectuoso por devolver
        codCabVta := '';
        recTmpProd.Reset;
        recTmpProd.SetFilter("Cantidad defectuosa", '<>%1', 0);
        if recTmpProd.FindFirst then begin
            recTmpFact.Reset;
            if recTmpFact.FindSet then
                repeat

                    recTmpFactProd.Reset;
                    recTmpFactProd.SetRange("No. factura", recTmpFact."No. factura");
                    recTmpFactProd.SetFilter("Cantidad liquidable", '<>%1', 0);
                    if recTmpFactProd.FindSet then begin
                        blnPrimeraVez := true;
                        repeat

                            recTmpProd.Reset;
                            recTmpProd.SetRange("Item No.", recTmpFactProd."No. producto");
                            recTmpProd.SetFilter("Cantidad defectuosa", '<>%1', 0);
                            if recTmpProd.FindFirst then begin
                                if recTmpProd."Cantidad defectuosa" <= recTmpFactProd."Cantidad liquidable" then
                                    decCdadLiq := recTmpProd."Cantidad defectuosa"
                                else
                                    decCdadLiq := recTmpFactProd."Cantidad liquidable";
                                recTmpProd."Cantidad defectuosa" -= decCdadLiq;
                                recTmpProd.Modify;

                                if blnPrimeraVez then begin
                                    blnPrimeraVez := false;
                                    codCabVta := InsertarCabDev(recPrmCabDev, true,
                                                                recTmpFact."No. factura",
                                                                recTmpFact.Pendiente,
                                                                recCfgSantillana."Almacen prod. defectuosos");
                                end;
                                //InsertarLinDev(codCabVta,recTmpFactProd,decCdadLiq,TRUE);   // $021 //026+-

                                // 026+ //22/04/2024
                                Clear(VatProdPostingGroup);
                                VatProdPostingGroup := FindInLineVatPostingGroup(recTmpFact."No. factura", recTmpFactProd."No. producto");
                                InsertarLinDev(codCabVta, recTmpFactProd, decCdadLiq, true, VatProdPostingGroup); // // $021 //$026+ //Se agrega el parametro VatProdPostingGroup //17-04-2024
                                                                                                                  // 026- //22/04/2024

                                recTmpFactProd."Cantidad liquidable" -= decCdadLiq;
                                recTmpFactProd.Modify;
                            end;

                        until recTmpFactProd.Next = 0;
                        LanzarCabDev(codCabVta);
                    end;
                until recTmpFact.Next = 0;
        end;

        //Devolución del resto de productos sin defectos que no se pueden liquidar :

        codCabVta := '';
        recTmpProd.Reset;
        recTmpProd.SetFilter(Cantidad, '<>%1', 0);
        if recTmpProd.FindFirst then begin
            recTmpFactProd.Reset;
            recTmpFactProd.SetRange("No. factura", '');
            recTmpFactProd.SetFilter("Cantidad liquidable", '<>%1', 0);
            if recTmpFactProd.FindSet then begin
                blnPrimeraVez := true;
                repeat

                    recTmpProd.Reset;
                    recTmpProd.SetRange("Item No.", recTmpFactProd."No. producto");
                    recTmpProd.SetFilter(Cantidad, '<>%1', 0);
                    if recTmpProd.FindFirst then begin

                        if recTmpProd.Cantidad <= recTmpFactProd."Cantidad liquidable" then
                            decCdadLiq := recTmpProd.Cantidad
                        else
                            decCdadLiq := recTmpFactProd."Cantidad liquidable";

                        recTmpProd.Cantidad -= decCdadLiq;
                        recTmpProd.Modify;

                        if blnPrimeraVez then begin
                            blnPrimeraVez := false;
                            codCabVta := InsertarCabDev(recPrmCabDev, false, '', false, recPrmCabDev."Cod. Almacen");
                        end;
                        //InsertarLinDev(codCabVta,recTmpFactProd,recTmpFactProd."Cantidad liquidable",FALSE);  // $021 //026+-

                        // 026+ //22/04/2024
                        Clear(VatProdPostingGroup);
                        VatProdPostingGroup := FindInLineVatPostingGroup(recTmpFact."No. factura", recTmpFactProd."No. producto");
                        InsertarLinDev(codCabVta, recTmpFactProd, recTmpFactProd."Cantidad liquidable", false, VatProdPostingGroup); // // $021 //$026+ //Se agrega el parametro VatProdPostingGroup //17-04-2024
                                                                                                                                     // 026- //22/04/2024

                        recTmpFactProd."Cantidad liquidable" -= decCdadLiq;
                        recTmpFactProd.Modify;
                    end;

                until recTmpFactProd.Next = 0;
                LanzarCabDev(codCabVta);
            end;
        end;

        //Devolución del resto de productos defectuosos que no se pueden liquidar :
        codCabVta := '';
        recTmpProd.Reset;
        recTmpProd.SetFilter("Cantidad defectuosa", '<>%1', 0);
        if recTmpProd.FindFirst then begin
            recTmpFactProd.Reset;
            recTmpFactProd.SetRange("No. factura", '');
            recTmpFactProd.SetFilter("Cantidad liquidable", '<>%1', 0);
            if recTmpFactProd.FindSet then begin
                blnPrimeraVez := true;
                repeat

                    recTmpProd.Reset;
                    recTmpProd.SetRange("Item No.", recTmpFactProd."No. producto");
                    recTmpProd.SetFilter("Cantidad defectuosa", '<>%1', 0);
                    if recTmpProd.FindFirst then begin
                        if recTmpProd."Cantidad defectuosa" <= recTmpFactProd."Cantidad liquidable" then
                            decCdadLiq := recTmpProd."Cantidad defectuosa"
                        else
                            decCdadLiq := recTmpFactProd."Cantidad liquidable";

                        recTmpProd."Cantidad defectuosa" -= decCdadLiq;
                        recTmpProd.Modify;

                        if blnPrimeraVez then begin
                            blnPrimeraVez := false;
                            codCabVta := InsertarCabDev(recPrmCabDev, false, '', false, recCfgSantillana."Almacen prod. defectuosos");
                        end;
                        //InsertarLinDev(codCabVta,recTmpFactProd,recTmpFactProd."Cantidad liquidable",FALSE); // $021 //026+-

                        // 026+ //22/04/2024
                        Clear(VatProdPostingGroup);
                        VatProdPostingGroup := FindInLineVatPostingGroup(recTmpFact."No. factura", recTmpFactProd."No. producto");
                        InsertarLinDev(codCabVta, recTmpFactProd, recTmpFactProd."Cantidad liquidable", false, VatProdPostingGroup); // // $021 //$026+ //Se agrega el parametro VatProdPostingGroup //17-04-2024
                                                                                                                                     // 026- //22/04/2024

                        recTmpFactProd."Cantidad liquidable" -= decCdadLiq;
                        recTmpFactProd.Modify;
                    end;

                until recTmpFactProd.Next = 0;
                LanzarCabDev(codCabVta);
            end;
        end;
    end;


    procedure ClasificarDevVentas_Uno(var recPrmCabDev: Record "Cab. clas. devolucion")
    var
        decCdadADev: Decimal;
        codCabVta: Code[20];
        decCdadLiq: Decimal;
        blnPrimeraVez: Boolean;
    begin
        // Funcion correspondiente a Emitir un Solo Documento Class Dev $020

        //Los productos, para los que no se ha generado transferencia devolución consignación, se inluirán en devoluciones de venta.

        //Los productos, sin defectos, se incluirán en devoluciones que liquidarán facturas de venta
        //Los productos defectuosos se inluirán en una devolución sin liquidar factura de venta
        //Y los productos, sin defectos, que no se pueden liquidar con facturas de venta se incluirán en una devolución sin liquidar factura


        //Devolución de productos sin defectos liquidables :

        //Si quedan algún producto por devolver
        recTmpProd.Reset;
        recTmpProd.SetFilter(Cantidad, '<>%1', 0);
        if recTmpProd.FindFirst then begin
            blnPrimeraVez := true; // $020 linea agregada
            recTmpFact.Reset;
            if recTmpFact.FindSet then
                repeat
                    recTmpFactProd.Reset;
                    recTmpFactProd.SetRange("No. factura", recTmpFact."No. factura");
                    recTmpFactProd.SetFilter("Cantidad liquidable", '<>%1', 0);
                    if recTmpFactProd.FindSet then begin
                        //blnPrimeraVez := TRUE; $020
                        repeat
                            recTmpProd.Reset;
                            recTmpProd.SetRange("Item No.", recTmpFactProd."No. producto");
                            recTmpProd.SetFilter(Cantidad, '<>%1', 0);
                            if recTmpProd.FindFirst then begin
                                if recTmpProd.Cantidad <= recTmpFactProd."Cantidad liquidable" then
                                    decCdadLiq := recTmpProd.Cantidad
                                else
                                    decCdadLiq := recTmpFactProd."Cantidad liquidable";

                                recTmpProd.Cantidad -= decCdadLiq;
                                recTmpProd.Modify;

                                if blnPrimeraVez then begin
                                    blnPrimeraVez := false;
                                    codCabVta := InsertarCabDev(recPrmCabDev, true,
                                                                recTmpFact."No. factura",
                                                                recTmpFact.Pendiente,
                                                                recPrmCabDev."Cod. Almacen");
                                end;
                                //InsertarLinDev(codCabVta,recTmpFactProd,decCdadLiq,TRUE); // $021 //026+-

                                // 026+ //22/04/2024
                                Clear(VatProdPostingGroup);
                                VatProdPostingGroup := FindInLineVatPostingGroup(recTmpFact."No. factura", recTmpFactProd."No. producto");
                                InsertarLinDev(codCabVta, recTmpFactProd, decCdadLiq, true, VatProdPostingGroup); // // $021 //$026+ //Se agrega el parametro VatProdPostingGroup //17-04-2024
                                                                                                                  // 026- //22/04/2024

                                recTmpFactProd."Cantidad liquidable" -= decCdadLiq;
                                recTmpFactProd.Modify;
                            end;

                        until recTmpFactProd.Next = 0;
                        //LanzarCabDev(codCabVta); $020
                    end;
                until recTmpFact.Next = 0;
            //LanzarCabDev(codCabVta); //$020
        end;

        //Devolución de productos defectuosos liquidables :

        //Si quedan algún producto defectuoso por devolver
        //codCabVta := '';
        recTmpProd.Reset;
        recTmpProd.SetFilter("Cantidad defectuosa", '<>%1', 0);
        if recTmpProd.FindFirst then begin
            //blnPrimeraVez   := TRUE; // $020 linea agregada
            recTmpFact.Reset;
            if recTmpFact.FindSet then
                repeat

                    recTmpFactProd.Reset;
                    recTmpFactProd.SetRange("No. factura", recTmpFact."No. factura");
                    recTmpFactProd.SetFilter("Cantidad liquidable", '<>%1', 0);
                    if recTmpFactProd.FindSet then begin
                        // blnPrimeraVez := TRUE;  $020
                        repeat

                            recTmpProd.Reset;
                            recTmpProd.SetRange("Item No.", recTmpFactProd."No. producto");
                            recTmpProd.SetFilter("Cantidad defectuosa", '<>%1', 0);
                            if recTmpProd.FindFirst then begin
                                if recTmpProd."Cantidad defectuosa" <= recTmpFactProd."Cantidad liquidable" then
                                    decCdadLiq := recTmpProd."Cantidad defectuosa"
                                else
                                    decCdadLiq := recTmpFactProd."Cantidad liquidable";
                                recTmpProd."Cantidad defectuosa" -= decCdadLiq;
                                recTmpProd.Modify;

                                if blnPrimeraVez then begin
                                    blnPrimeraVez := false;
                                    codCabVta := InsertarCabDev(recPrmCabDev, true,
                                                                recTmpFact."No. factura",
                                                                recTmpFact.Pendiente,
                                                                recCfgSantillana."Almacen prod. defectuosos");
                                end;
                                //InsertarLinDev(codCabVta,recTmpFactProd,decCdadLiq,TRUE);  // $021 //026+-

                                // 026+ //22/04/2024
                                Clear(VatProdPostingGroup);
                                VatProdPostingGroup := FindInLineVatPostingGroup(recTmpFact."No. factura", recTmpFactProd."No. producto");
                                InsertarLinDev(codCabVta, recTmpFactProd, decCdadLiq, true, VatProdPostingGroup); // // $021 //$026+ //Se agrega el parametro VatProdPostingGroup //17-04-2024
                                                                                                                  // 026- //22/04/2024

                                recTmpFactProd."Cantidad liquidable" -= decCdadLiq;
                                recTmpFactProd.Modify;
                            end;

                        until recTmpFactProd.Next = 0;
                        //LanzarCabDev(codCabVta);   // $020
                    end;
                until recTmpFact.Next = 0;
            //LanzarCabDev(codCabVta);   // $020
        end;

        //Devolución del resto de productos sin defectos que no se pueden liquidar :

        //codCabVta := '';
        recTmpProd.Reset;
        recTmpProd.SetFilter(Cantidad, '<>%1', 0);
        if recTmpProd.FindFirst then begin
            //blnPrimeraVez   := TRUE; // $020 linea agregada
            recTmpFactProd.Reset;
            recTmpFactProd.SetRange("No. factura", '');
            recTmpFactProd.SetFilter("Cantidad liquidable", '<>%1', 0);
            if recTmpFactProd.FindSet then begin
                //blnPrimeraVez := TRUE;
                repeat

                    recTmpProd.Reset;
                    recTmpProd.SetRange("Item No.", recTmpFactProd."No. producto");
                    recTmpProd.SetFilter(Cantidad, '<>%1', 0);
                    if recTmpProd.FindFirst then begin

                        if recTmpProd.Cantidad <= recTmpFactProd."Cantidad liquidable" then
                            decCdadLiq := recTmpProd.Cantidad
                        else
                            decCdadLiq := recTmpFactProd."Cantidad liquidable";

                        recTmpProd.Cantidad -= decCdadLiq;
                        recTmpProd.Modify;

                        if blnPrimeraVez then begin
                            blnPrimeraVez := false;
                            codCabVta := InsertarCabDev(recPrmCabDev, false, '', false, recPrmCabDev."Cod. Almacen");
                        end;
                        //InsertarLinDev(codCabVta,recTmpFactProd,recTmpFactProd."Cantidad liquidable",FALSE);   // $021 //026+-

                        // 026+ //22/04/2024
                        Clear(VatProdPostingGroup);
                        VatProdPostingGroup := FindInLineVatPostingGroup(recTmpFact."No. factura", recTmpFactProd."No. producto");
                        InsertarLinDev(codCabVta, recTmpFactProd, recTmpFactProd."Cantidad liquidable", false, VatProdPostingGroup); // // $021 //$026+ //Se agrega el parametro VatProdPostingGroup //17-04-2024
                                                                                                                                     // 026- //22/04/2024

                        recTmpFactProd."Cantidad liquidable" -= decCdadLiq;
                        recTmpFactProd.Modify;
                    end;

                until recTmpFactProd.Next = 0;
                //LanzarCabDev(codCabVta); // $020
            end;
            //LanzarCabDev(codCabVta); // $020
        end;

        //Devolución del resto de productos defectuosos que no se pueden liquidar :
        //codCabVta := '';
        recTmpProd.Reset;
        recTmpProd.SetFilter("Cantidad defectuosa", '<>%1', 0);
        if recTmpProd.FindFirst then begin
            // blnPrimeraVez   := TRUE; // $020 linea agregada
            recTmpFactProd.Reset;
            recTmpFactProd.SetRange("No. factura", '');
            recTmpFactProd.SetFilter("Cantidad liquidable", '<>%1', 0);
            if recTmpFactProd.FindSet then begin
                //blnPrimeraVez := TRUE;   // $020
                repeat

                    recTmpProd.Reset;
                    recTmpProd.SetRange("Item No.", recTmpFactProd."No. producto");
                    recTmpProd.SetFilter("Cantidad defectuosa", '<>%1', 0);
                    if recTmpProd.FindFirst then begin
                        if recTmpProd."Cantidad defectuosa" <= recTmpFactProd."Cantidad liquidable" then
                            decCdadLiq := recTmpProd."Cantidad defectuosa"
                        else
                            decCdadLiq := recTmpFactProd."Cantidad liquidable";

                        recTmpProd."Cantidad defectuosa" -= decCdadLiq;
                        recTmpProd.Modify;

                        if blnPrimeraVez then begin
                            blnPrimeraVez := false;
                            codCabVta := InsertarCabDev(recPrmCabDev, false, '', false, recCfgSantillana."Almacen prod. defectuosos");
                        end;
                        //InsertarLinDev(codCabVta,recTmpFactProd,recTmpFactProd."Cantidad liquidable",FALSE); // $021 //026+-

                        // 026+ //22/04/2024
                        Clear(VatProdPostingGroup);
                        VatProdPostingGroup := FindInLineVatPostingGroup(recTmpFact."No. factura", recTmpFactProd."No. producto");
                        InsertarLinDev(codCabVta, recTmpFactProd, recTmpFactProd."Cantidad liquidable", false, VatProdPostingGroup); // // $021 //$026+ //Se agrega el parametro VatProdPostingGroup //17-04-2024
                                                                                                                                     // 026- //22/04/2024

                        recTmpFactProd."Cantidad liquidable" -= decCdadLiq;
                        recTmpFactProd.Modify;
                    end;

                until recTmpFactProd.Next = 0;
                //LanzarCabDev(codCabVta); // $020
            end;
            //LanzarCabDev(codCabVta); // $020
        end;

        // ++ $020
        if codCabVta <> '' then
            LanzarCabDev(codCabVta);
        // -- $020
    end;


    procedure InsertarCabDev(var recPrmCabDev: Record "Cab. clas. devolucion"; blmPrmLiquidarCdad: Boolean; codPrmFactOrigen: Code[20]; blnPrmPendiente: Boolean; codPrmAlmacen: Code[10]): Code[20]
    var
        recCabVta: Record "Sales Header";
        recDocDim: Integer;
    begin

        recCabVta.Init;
        recCabVta."Document Type" := recCabVta."Document Type"::"Return Order";
        recCabVta.Insert(true);
        recCabVta.Validate("Sell-to Customer No.", recPrmCabDev."Customer no.");
        recCabVta.Validate("Posting Date", WorkDate);
        recCabVta.Validate("Location Code", codPrmAlmacen);
        recCabVta."Posting Description" := StrSubstNo(Text004, recPrmCabDev."Customer no.");
        recCabVta."External Document No." := recPrmCabDev."External document no.";                //$003

        //#36182:Inicio
        recCabVta."No. Serie NCF Facturas" := recPrmCabDev."No Serie NCF Abono";
        recCabVta."No. Serie NCF Abonos" := recPrmCabDev."No Serie NCF Abono";
        recCabVta."Establecimiento Factura" := recPrmCabDev."Establecimiento Nota Credito";
        recCabVta."Punto de Emision Factura" := recPrmCabDev."Punto Emision Nota Credito";
        //#36182:Fin

        if blmPrmLiquidarCdad then begin
            //Indica la factura original de las cantidades que se estan devolviendo.
            //recCabVta."No. Factura Fiscal Rel." := TraerNumFiscal(codPrmFactOrigen);
            //  recCabVta."No. Comprobante Fiscal Rel." := TraerNumFiscal(codPrmFactOrigen);
            TraerNumFiscal(codPrmFactOrigen, recCabVta."Establecimiento Fact. Rel", recCabVta."Punto de Emision Fact. Rel.", recCabVta."No. Comprobante Fiscal Rel.");
            //Si la factura que devolvemos esta pendiente se liquidan importes pendientes.
            if blnPrmPendiente then begin
                recCabVta.Validate("Applies-to Doc. Type", recCabVta."Applies-to Doc. Type"::Invoice);
                recCabVta.Validate("Applies-to Doc. No.", codPrmFactOrigen);
                TraerVendedor(codPrmFactOrigen, recCabVta);
            end
            else   //Si la factura que devolvemos NO esta pendiente se liquidan importes según configuración.
                LiquidarImportes(recCabVta);
        end
        else
            LiquidarImportes(recCabVta); //Aunque no liquidemos cantidades se debe liquidar los importes según configuración

        recCabVta.Validate("No. Comprobante Fiscal Rel.");
        TraerCodColegio(codPrmFactOrigen, recCabVta);//$025-LDP+-
        recCabVta.Modify(true);

        InsertarDocRelacionado(recPrmCabDev."No.", optTipoDoc::Venta, recCabVta."No.");

        dlgProgeso.Update(5, recCabVta."No.");

        exit(recCabVta."No.");
    end;


    procedure InsertarLinDev(codPrmDoc: Code[20]; var recPrmFacProd: Record "Tmp facturas a liquidar" temporary; decPrmCdad: Decimal; ClasDev: Boolean; VatPostGroupCode: Code[20])
    var
        recLinVta: Record "Sales Line";
        recDocDim: Integer;
        intLinea: Integer;
        recHistLinVenta: Record "Sales Invoice Line";
    begin
        recLinVta.Reset;
        recLinVta.SetRange("Document Type", recLinVta."Document Type"::"Return Order");
        recLinVta.SetRange("Document No.", codPrmDoc);
        if recLinVta.FindLast then
            intLinea := recLinVta."Line No.";

        intLinea += 10000;

        recLinVta.Init;
        recLinVta."Document Type" := recLinVta."Document Type"::"Return Order";
        recLinVta."Document No." := codPrmDoc;
        recLinVta."Line No." := intLinea;
        recLinVta.Validate(Type, recLinVta.Type::Item);
        recLinVta.Validate("No.", recPrmFacProd."No. producto");
        recLinVta.Validate(Quantity, decPrmCdad);
        recLinVta."Clas Dev" := ClasDev;  // $021
        if recPrmFacProd."No. mov. producto" <> 0 then
            recLinVta.Validate("Appl.-from Item Entry", recPrmFacProd."No. mov. producto");
        //+004
        if recHistLinVenta.Get(recPrmFacProd."No. factura", recPrmFacProd."No. linea") then begin
            //+005
            //IF recHistLinVenta."Line Discount %" <> 0 THEN
            //-005
            recLinVta.Validate("Line Discount %", recHistLinVenta."Line Discount %");
            recLinVta.Validate("Unit Price", recHistLinVenta."Unit Price");             //#26400
        end;
        //-004

        //$026+-
        if VatPostGroupCode <> '' then
            recLinVta.Validate("VAT Prod. Posting Group", VatPostGroupCode);
        //$026+-

        recLinVta.Insert(true);
    end;


    procedure GenerarTablaTempFacturas(var recPrmCabDev: Record "Cab. clas. devolucion")
    var
        recMovCli: Record "Cust. Ledger Entry";
        recLinFac: Record "Sales Invoice Line";
        recMovValor: Record "Value Entry";
        recMovProd: Record "Item Ledger Entry";
        decCdadADev: Decimal;
        ldCantidadDevuelta: Decimal;
    begin
        //Genera una tabla temoral con las facturas que podemos liquidar
        //Para cada producto que se debe devolver se comprueba si hay facturas pendientes de liquidar y se guardan en
        //la tabla temporal con las cantidades que se pueden liquidar de cada producto.

        lrConfEmpresa.Get(); //#175585

        recTmpProd.Reset;
        if recTmpProd.FindSet then
            repeat

                decCdadADev := recTmpProd.Cantidad + recTmpProd."Cantidad defectuosa";

                if (decCdadADev <> 0) then begin
                    recMovCli.Reset;
                    recMovCli.SetCurrentKey("Document Type", "Customer No.", "Posting Date");
                    recMovCli.Ascending(false);
                    recMovCli.SetRange("Document Type", recMovCli."Document Type"::Invoice);
                    recMovCli.SetRange("Customer No.", recPrmCabDev."Customer no.");
                    recMovCli.SetFilter("No. Comprobante Fiscal", '<>%1', '');       //022
                                                                                     //      recMovCli.SETRANGE(Open, TRUE);

                    if (lrConfEmpresa."Fecha Inicio Campaña" <> 0D) and (lrConfEmpresa."Fecha Fin Campaña" <> 0D) then // $010 - Restring fecha de campaña a buscar las facturas
                                                                                                                       // ++  #175585
                      begin
                        lrConfEmpresa.TestField(lrConfEmpresa."Fecha Origen");
                        case lrConfEmpresa."Fecha Origen" of
                            lrConfEmpresa."Fecha Origen"::"Fecha Emision":
                                recMovCli.SetRange("Document Date", lrConfEmpresa."Fecha Inicio Campaña", lrConfEmpresa."Fecha Fin Campaña"); // $010 - Restring fecha de campaña a buscar las facturas
                            lrConfEmpresa."Fecha Origen"::"Fecha Registro":
                                recMovCli.SetRange(recMovCli."Posting Date", lrConfEmpresa."Fecha Inicio Campaña", lrConfEmpresa."Fecha Fin Campaña"); //
                        end

                    end;
                    // --  #175585


                    if recMovCli.FindSet then
                        repeat
                            recLinFac.Reset;
                            recLinFac.SetRange("Document No.", recMovCli."Document No.");
                            recLinFac.SetRange(Type, recLinFac.Type::Item);
                            recLinFac.SetRange("No.", recTmpProd."Item No.");
                            if FiltroDescuento <> 0.0 then      //#175585
                                recLinFac.SetRange("Line Discount %", FiltroDescuento);   //#175585

                            if recLinFac.FindSet then
                                repeat
                                    //#22823:Inicio
                                    ldCantidadDevuelta := getCantidadDevuelta(recTmpProd."Item No.", recLinFac."Document No.");
                                    //#22823:Fin

                                    //  IF recLinFac.Quantity > recLinFac."Cantidad Devuelta" THEN BEGIN  // $021  //$023
                                    if (recLinFac.Quantity > recLinFac."Cantidad Devuelta") and (recLinFac.Quantity > ldCantidadDevuelta) then begin   // $021 //$023
                                                                                                                                                       //Guarda las facturas liquidables
                                        if not recTmpFact.Get(recLinFac."Document No.") then begin
                                            recTmpFact.Init;
                                            recTmpFact."No. factura" := recLinFac."Document No.";
                                            recTmpFact.Pendiente := recMovCli.Open;
                                            recTmpFact.Insert;
                                        end;

                                        //Guarda las cantidades liquidables por cada factura
                                        recTmpFactProd.Init;
                                        recTmpFactProd."No. factura" := recLinFac."Document No.";
                                        recTmpFactProd."No. linea" := recLinFac."Line No.";
                                        recTmpFactProd."No. producto" := recTmpProd."Item No.";

                                        //$001  Se guarda el el mov. producto para liquidar en la devolución
                                        recMovValor.Reset;
                                        recMovValor.SetCurrentKey("Document No.");
                                        recMovValor.SetRange("Document No.", recLinFac."Document No.");
                                        recMovValor.SetRange("Document Type", recMovValor."Document Type"::"Sales Invoice");
                                        recMovValor.SetRange("Document Line No.", recLinFac."Line No.");
                                        if recMovValor.FindFirst then begin
                                            recMovProd.Reset;
                                            recMovProd.SetRange("Entry No.", recMovValor."Item Ledger Entry No.");
                                            recMovProd.SetFilter("Shipped Qty. Not Returned", '<>%1', 0);
                                            if recMovProd.FindFirst then begin
                                                recTmpFactProd."No. mov. producto" := recMovProd."Entry No.";
                                                /*
                                                // ++$021
                                               //#22823:Inicio
                                               IF ((-recMovProd."Shipped Qty. Not Returned")-ldCantidadDevuelta) >= decCdadADev THEN
                                               //#22823:Fin
                                                */ // --$021

                                                // ++$021
                                                //IF (ldCantidadDevuelta + recMovProd."Shipped Qty. Not Returned") >= decCdadADev THEN
                                                if (-recMovProd."Shipped Qty. Not Returned") >= decCdadADev then
                                                    // --$021
                                                    recTmpFactProd."Cantidad liquidable" := decCdadADev
                                                else
                                                  /*
                                                  //#22823:Inicio
                                                    BEGIN
                                                      IF ((-recMovProd."Shipped Qty. Not Returned")-ldCantidadDevuelta) >0 THEN // $021
                                                        recTmpFactProd."Cantidad liquidable" := ((-recMovProd."Shipped Qty. Not Returned")-ldCantidadDevuelta);
                                                    END;
                                                  //#22823:Fin
                                                  */
                                                  //++$021
                                                  begin
                                                    //IF (ldCantidadDevuelta + recMovProd."Shipped Qty. Not Returned") > 0 THEN // $021
                                                    if (-recMovProd."Shipped Qty. Not Returned") > 0 then // $021
                                                        recTmpFactProd."Cantidad liquidable" := (-recMovProd."Shipped Qty. Not Returned");
                                                end;

                                                //--$021

                                                if recTmpFactProd."Cantidad liquidable" <> 0 then begin
                                                    // ++ $021
                                                    //IF recTmpFactProd."Cantidad liquidable" <> recLinFac."Cantidad Devuelta" THEN
                                                    //   recTmpFactProd."Cantidad liquidable" := recLinFac.Quantity - recLinFac."Cantidad Devuelta";
                                                    // -- $021
                                                    recTmpFactProd.Insert;
                                                    InsertarFacturaLiquidadas;
                                                    decCdadADev -= recTmpFactProd."Cantidad liquidable";
                                                    //IF recLinFac."Cantidad Devuelta" = 0 THEN
                                                    recLinFac."Cantidad Devuelta" := ldCantidadDevuelta + recTmpFactProd."Cantidad liquidable"; // Guardar cantidad Devuelta linea ped ventas $021
                                                    recLinFac.ClasDev := true; //  $021
                                                    recLinFac.Modify;    //  $021
                                                end;
                                            end;
                                        end;
                                    end; // -- $021  //$023
                                until (recLinFac.Next = 0) or (decCdadADev = 0);
                        until (recMovCli.Next = 0) or (decCdadADev = 0);

                    //Si quedan productos sin liquidar se guardan para generar una devolución sin fact. a liq.
                    if decCdadADev <> 0 then begin
                        recTmpFactProd.Init;
                        recTmpFactProd."No. factura" := '';
                        recTmpFactProd."No. linea" := 0;
                        recTmpFactProd."No. producto" := recTmpProd."Item No.";
                        recTmpFactProd."Cantidad liquidable" := decCdadADev;
                        recTmpFactProd."No. mov. producto" := 0;
                        recTmpFactProd.Insert;
                    end;
                end;

            until recTmpProd.Next = 0;

    end;


    procedure GenerarTablaTempFacturas2(var recPrmCabDev: Record "Cab. clas. devolucion")
    var
        recMovCli: Record "Cust. Ledger Entry";
        recLinFac: Record "Sales Invoice Line";
        recMovValor: Record "Value Entry";
        recMovProd: Record "Item Ledger Entry";
        decCdadADev: Decimal;
        ldCantidadDevuelta: Decimal;
        recCabFac: Record "Sales Invoice Header";
        CavDev: Record "Cab. clas. devolucion";
    begin
        //Genera una tabla temoral con las facturas que podemos liquidar
        //Para cada producto que se debe devolver se comprueba si hay facturas pendientes de liquidar y se guardan en
        //la tabla temporal con las cantidades que se pueden liquidar de cada producto.

        lrConfEmpresa.Get(); //#175585

        recTmpProd.Reset;
        if recTmpProd.FindSet then
            repeat

                decCdadADev := recTmpProd.Cantidad + recTmpProd."Cantidad defectuosa";

                if (decCdadADev <> 0) then begin
                    recMovCli.Reset;
                    recMovCli.SetCurrentKey("Document Type", "Customer No.", "Posting Date");
                    recMovCli.Ascending(false);
                    recMovCli.SetRange("Document Type", recMovCli."Document Type"::Invoice);
                    recMovCli.SetRange("Customer No.", recPrmCabDev."Customer no.");
                    recMovCli.SetFilter("No. Comprobante Fiscal", '<>%1', '');       //022
                                                                                     //      recMovCli.SETRANGE(Open, TRUE);

                    if (lrConfEmpresa."Fecha Inicio Campaña" <> 0D) and (lrConfEmpresa."Fecha Fin Campaña" <> 0D) then // $010 - Restring fecha de campaña a buscar las facturas
                                                                                                                       // ++  #175585
                      begin
                        lrConfEmpresa.TestField(lrConfEmpresa."Fecha Origen");
                        case lrConfEmpresa."Fecha Origen" of
                            lrConfEmpresa."Fecha Origen"::"Fecha Emision":
                                recMovCli.SetRange("Document Date", lrConfEmpresa."Fecha Inicio Campaña", lrConfEmpresa."Fecha Fin Campaña"); // $010 - Restring fecha de campaña a buscar las facturas
                            lrConfEmpresa."Fecha Origen"::"Fecha Registro":
                                recMovCli.SetRange(recMovCli."Posting Date", lrConfEmpresa."Fecha Inicio Campaña", lrConfEmpresa."Fecha Fin Campaña"); //
                        end

                    end;
                    // --  #175585



                    if recMovCli.FindSet then
                        repeat
                            CavDev.Reset;
                            CavDev.SetRange("No.", recPrmCabDev."No.");
                            if CavDev.FindFirst then;
                            L := false;
                            recCabFac.Reset;
                            recCabFac.SetRange("No. Comprobante Fiscal", recMovCli."No. Comprobante Fiscal");
                            recCabFac.SetRange("Ship-to Code", CavDev."Ship-to Code");
                            if recCabFac.FindFirst then begin
                                L := true;
                                //recCabFac.VALIDATE("Ship-to Code", CavDev."Ship-to Code");
                                //recCabFac.MODIFY;
                            end;

                            recLinFac.Reset;
                            recLinFac.SetRange("Document No.", recMovCli."Document No.");
                            recLinFac.SetRange(Type, recLinFac.Type::Item);
                            recLinFac.SetRange("No.", recTmpProd."Item No.");
                            if FiltroDescuento <> 0.0 then      //#175585
                                recLinFac.SetRange("Line Discount %", FiltroDescuento);   //#175585

                            if (recLinFac.FindSet) and (L) then
                                repeat
                                    //#22823:Inicio
                                    ldCantidadDevuelta := getCantidadDevuelta(recTmpProd."Item No.", recLinFac."Document No.");
                                    //#22823:Fin

                                    //  IF recLinFac.Quantity > recLinFac."Cantidad Devuelta" THEN BEGIN  // $021  //$023
                                    if (recLinFac.Quantity > recLinFac."Cantidad Devuelta") and (recLinFac.Quantity > ldCantidadDevuelta) then begin   // $021 //$023
                                                                                                                                                       //Guarda las facturas liquidables
                                        if not recTmpFact.Get(recLinFac."Document No.") then begin
                                            recTmpFact.Init;
                                            recTmpFact."No. factura" := recLinFac."Document No.";
                                            recTmpFact.Pendiente := recMovCli.Open;
                                            recTmpFact.Insert;
                                        end;

                                        //Guarda las cantidades liquidables por cada factura
                                        recTmpFactProd.Init;
                                        recTmpFactProd."No. factura" := recLinFac."Document No.";
                                        recTmpFactProd."No. linea" := recLinFac."Line No.";
                                        recTmpFactProd."No. producto" := recTmpProd."Item No.";

                                        //$001  Se guarda el el mov. producto para liquidar en la devolución
                                        recMovValor.Reset;
                                        recMovValor.SetCurrentKey("Document No.");
                                        recMovValor.SetRange("Document No.", recLinFac."Document No.");
                                        recMovValor.SetRange("Document Type", recMovValor."Document Type"::"Sales Invoice");
                                        recMovValor.SetRange("Document Line No.", recLinFac."Line No.");
                                        if recMovValor.FindFirst then begin
                                            recMovProd.Reset;
                                            recMovProd.SetRange("Entry No.", recMovValor."Item Ledger Entry No.");
                                            recMovProd.SetFilter("Shipped Qty. Not Returned", '<>%1', 0);
                                            if recMovProd.FindFirst then begin
                                                recTmpFactProd."No. mov. producto" := recMovProd."Entry No.";
                                                /*
                                                // ++$021
                                               //#22823:Inicio
                                               IF ((-recMovProd."Shipped Qty. Not Returned")-ldCantidadDevuelta) >= decCdadADev THEN
                                               //#22823:Fin
                                                */ // --$021

                                                // ++$021
                                                //IF (ldCantidadDevuelta + recMovProd."Shipped Qty. Not Returned") >= decCdadADev THEN
                                                if (-recMovProd."Shipped Qty. Not Returned") >= decCdadADev then
                                                    // --$021
                                                    recTmpFactProd."Cantidad liquidable" := decCdadADev
                                                else
                                                  /*
                                                  //#22823:Inicio
                                                    BEGIN
                                                      IF ((-recMovProd."Shipped Qty. Not Returned")-ldCantidadDevuelta) >0 THEN // $021
                                                        recTmpFactProd."Cantidad liquidable" := ((-recMovProd."Shipped Qty. Not Returned")-ldCantidadDevuelta);
                                                    END;
                                                  //#22823:Fin
                                                  */
                                                  //++$021
                                                  begin
                                                    //IF (ldCantidadDevuelta + recMovProd."Shipped Qty. Not Returned") > 0 THEN // $021
                                                    if (-recMovProd."Shipped Qty. Not Returned") > 0 then // $021
                                                        recTmpFactProd."Cantidad liquidable" := (-recMovProd."Shipped Qty. Not Returned");
                                                end;

                                                //--$021

                                                if recTmpFactProd."Cantidad liquidable" <> 0 then begin
                                                    // ++ $021
                                                    //IF recTmpFactProd."Cantidad liquidable" <> recLinFac."Cantidad Devuelta" THEN
                                                    //   recTmpFactProd."Cantidad liquidable" := recLinFac.Quantity - recLinFac."Cantidad Devuelta";
                                                    // -- $021
                                                    recTmpFactProd.Insert;
                                                    InsertarFacturaLiquidadas;
                                                    decCdadADev -= recTmpFactProd."Cantidad liquidable";
                                                    //IF recLinFac."Cantidad Devuelta" = 0 THEN
                                                    recLinFac."Cantidad Devuelta" := ldCantidadDevuelta + recTmpFactProd."Cantidad liquidable"; // Guardar cantidad Devuelta linea ped ventas $021
                                                    recLinFac.ClasDev := true; //  $021
                                                    recLinFac.Modify;    //  $021
                                                                         /*
                                                                           CavDev.RESET; CavDev.SETRANGE("No.",recPrmCabDev."No.");
                                                                           IF CavDev.FINDFIRST THEN;

                                                                           recCabFac.RESET;
                                                                           recCabFac.SETRANGE("No. Comprobante Fiscal",recMovCli."No. Comprobante Fiscal");
                                                                           IF recCabFac.FINDFIRST THEN
                                                                             BEGIN
                                                                               recCabFac.VALIDATE("Ship-to Code", CavDev."Ship-to Code");
                                                                               recCabFac.MODIFY;
                                                                             END;
                                                                          */
                                                end;

                                            end;
                                        end;
                                    end; // -- $021  //$023
                                         /*IF L THEN
                                           decCdadADev := 0; */

                                until (recLinFac.Next = 0) or (decCdadADev = 0);
                        until (recMovCli.Next = 0) or (decCdadADev = 0);

                    //Si quedan productos sin liquidar se guardan para generar una devolución sin fact. a liq.
                    if decCdadADev <> 0 then begin
                        recTmpFactProd.Init;
                        recTmpFactProd."No. factura" := '';
                        recTmpFactProd."No. linea" := 0;
                        recTmpFactProd."No. producto" := recTmpProd."Item No.";
                        recTmpFactProd."Cantidad liquidable" := decCdadADev;
                        recTmpFactProd."No. mov. producto" := 0;
                        recTmpFactProd.Insert;
                    end;
                end;

            until recTmpProd.Next = 0;

    end;


    procedure ActualizarTablaTempFacturas(Devolucion: Record "Sales Header"; FiltroDelDescuento_: Decimal; SL: Record "Sales Line")
    var
        recMovCli: Record "Cust. Ledger Entry";
        recLinFac: Record "Sales Invoice Line";
        recMovValor: Record "Value Entry";
        recMovProd: Record "Item Ledger Entry";
        _decCdadADev: Decimal;
        ldCantidadDevuelta: Decimal;
        SL2: Record "Sales Line";
    begin
        //021 Cuando se eliminar una devolucion hay que actualizar Historico
        // Esta funcion fue creada por YFC
        lrConfEmpresa.Get(); //#175585
                             //message('cd2');
                             // SL."Document Type"::"Return Order"
                             /*
                             SL.reset;
                             SL.SETRANGE("Document Type",Devolucion."Document Type");
                             SL.SETRANGE("Document No.",Devolucion."No.");
                             SL.SETRANGE(SL."Line No.",10000);
                             SL.SETRANGE("Clas Dev",TRUE);
                             IF SL.FINDSET THEN
                               Repeat
                                 message('entro');
                               until SL.next = 0;
                               */

        Clear(_decCdadADev);
        // decCdadADev := SL."Cantidad Devuelta";
        _decCdadADev := SL.Quantity;
        recMovCli.Reset;
        recMovCli.SetCurrentKey("Document Type", "Customer No.", "Posting Date");
        recMovCli.Ascending(false);
        recMovCli.SetRange("Document Type", recMovCli."Document Type"::Invoice);
        recMovCli.SetRange("Customer No.", Devolucion."Sell-to Customer No.");

        if (lrConfEmpresa."Fecha Inicio Campaña" <> 0D) and (lrConfEmpresa."Fecha Fin Campaña" <> 0D) then // $010 - Restring fecha de campaña a buscar las facturas
          begin
            lrConfEmpresa.TestField(lrConfEmpresa."Fecha Origen");
            case lrConfEmpresa."Fecha Origen" of
                lrConfEmpresa."Fecha Origen"::"Fecha Emision":
                    recMovCli.SetRange("Document Date", lrConfEmpresa."Fecha Inicio Campaña", lrConfEmpresa."Fecha Fin Campaña"); // $010 - Restring fecha de campaña a buscar las facturas
                lrConfEmpresa."Fecha Origen"::"Fecha Registro":
                    recMovCli.SetRange(recMovCli."Posting Date", lrConfEmpresa."Fecha Inicio Campaña", lrConfEmpresa."Fecha Fin Campaña"); //
            end

        end;

        if recMovCli.FindSet then
            repeat
                //MESSAGE(recMovCli."Document No.");
                recLinFac.Reset;
                recLinFac.SetRange("Document No.", recMovCli."Document No.");
                recLinFac.SetRange(Type, recLinFac.Type::Item);
                recLinFac.SetRange("No.", SL."No.");
                recLinFac.SetRange(ClasDev, true);
                if FiltroDescuento <> 0.0 then      //#175585
                    recLinFac.SetRange("Line Discount %", FiltroDelDescuento_);   //#175585

                if recLinFac.FindSet then
                    repeat
                        if _decCdadADev <= recLinFac."Cantidad Devuelta" then
                            recLinFac."Cantidad Devuelta" -= _decCdadADev // restar cantidad Devuelta linea Ped Dev $021
                        else begin
                            recLinFac."Cantidad Devuelta" -= recLinFac."Cantidad Devuelta";
                            _decCdadADev -= recLinFac."Cantidad Devuelta";
                        end;
                        if recLinFac."Cantidad Devuelta" = 0 then
                            recLinFac.ClasDev := false;
                        recLinFac.Modify;    //  $021
                    until (recLinFac.Next = 0) or (_decCdadADev = 0);
            until (recMovCli.Next = 0) or (_decCdadADev = 0);

    end;


    procedure InsertarDocRelacionado(codPrmDev: Code[20]; intPrmTipo: Integer; codPrmDoc: Code[20])
    var
        recDocRel: Record "Docs. clas. devoluciones";
    begin
        recDocRel.Init;
        recDocRel."No. clas. devoluciones" := codPrmDev;
        recDocRel."Tipo documento" := intPrmTipo;
        recDocRel."No. documento" := codPrmDoc;
        recDocRel."Filtro Descuento" := FiltroDescuento; //$021
        recDocRel.Insert;
    end;


    procedure LanzarCabDev(codPrmDoc: Code[20])
    var
        recCabVta: Record "Sales Header";
        cduLanzar: Codeunit "Release Sales Document";
    begin
        if codPrmDoc <> '' then begin
            recCabVta.Get(recCabVta."Document Type"::"Return Order", codPrmDoc);
            //cduEvents.SetIgnorarControles(true);
            recCabVta.SetIgnorarControles := true;
            cduLanzar.Run(recCabVta);
        end;
    end;


    procedure TraerPracesados(var recPrmCabPre: Record "Cab. clas. devolucion"): Integer
    var
        recDev: Record "Cab. clas. devolucion";
    begin
        recDev.Reset;
        recDev.CopyFilters(recPrmCabPre);
        recDev.SetRange(recDev.Procesada, true);
        exit(recDev.Count);
    end;


    procedure InsertarFacturaLiquidadas()
    begin
        recTmpFactLiquidadas := recTmpFactProd;
        recTmpFactLiquidadas.Insert;
    end;


    procedure TraerAlmacenConsigna(codPrmCliente: Code[20]): Code[20]
    var
        recCliente: Record Customer;
    begin
        if recCliente.Get(codPrmCliente) then
            exit(recCliente."Cod. Almacen Consignacion");
    end;


    procedure LiquidarImportes(var recPrmCabVta: Record "Sales Header")
    var
        codFactLiq: Code[20];
    begin
        //Si no hay factura original:
        Clear(codFactLiq); // YFC
        case recCfgSantillana."Liquidacion devoluciones" of

            //Si está configurado como liq. manual se deja el campo en blanco
            recCfgSantillana."Liquidacion devoluciones"::Manual:
                begin
                    recPrmCabVta."Applies-to Doc. Type" := recPrmCabVta."Applies-to Doc. Type"::" ";
                    recPrmCabVta."Applies-to Doc. No." := '';
                end;

            //Si está configurado por antigüedad se liquidará la factura más antigua
            recCfgSantillana."Liquidacion devoluciones"::"Por antiguedad":
                begin
                    if recPrmCabVta."No. Comprobante Fiscal Rel." <> '' then// YFC
                        codFactLiq := TraerFacturaAntiguaNoLiquidada(recPrmCabVta."Sell-to Customer No.", recPrmCabVta."No. Comprobante Fiscal Rel.", recPrmCabVta."Establecimiento Factura", recPrmCabVta."Punto de Emision Factura"); // YFC Mejoras
                    if codFactLiq <> '' then begin
                        recPrmCabVta.Validate("Applies-to Doc. Type", recPrmCabVta."Applies-to Doc. Type"::Invoice);
                        recPrmCabVta.Validate("Applies-to Doc. No.", codFactLiq);
                        TraerVendedor(codFactLiq, recPrmCabVta);
                    end;
                end;
        end;
    end;


    procedure TraerFacturaAntiguaNoLiquidada(codPrmCliente: Code[20]; CodNCFR: Code[20]; Establecimiento: Code[20]; PuntoEmision: Code[20]): Code[20]
    var
        recMovCli: Record "Cust. Ledger Entry";
    begin
        //Selecciona la factura mas antigua que no se haya liquidado
        recMovCli.Reset;
        recMovCli.SetCurrentKey("Document Type", "Customer No.", "Posting Date");
        //recMovCli.SETCURRENTKEY(Document No.,Document Type,Customer No.
        recMovCli.SetRange("Document Type", recMovCli."Document Type"::Invoice);
        recMovCli.SetRange("Customer No.", codPrmCliente);
        recMovCli.SetRange(Open, true);
        recMovCli.SetRange(recMovCli."No. Comprobante Fiscal Rel.", CodNCFR); // YFC
        //recMovCli.SETRANGE(, );
        //recMovCli.SETRANGE(, );
        if recMovCli.FindFirst then
            exit(recMovCli."Document No.");

        //IF recMovCli.FINDSET THEN
        //  REPEAT
        //Comprobamos que no se haya utilizado ya para liquidar en este mismo proceso
        //    recTmpFactLiquidadas.RESET;
        //    recTmpFactLiquidadas.SETRANGE("No. factura", recMovCli."Document No.");
        //    IF NOT recTmpFactLiquidadas.FINDFIRST THEN
        //      EXIT(recMovCli."Document No.");
        //  UNTIL recMovCli.NEXT = 0;
    end;


    procedure TraerVendedor(codPrmFacLiq: Code[20]; var recPrmCabVta: Record "Sales Header")
    var
        recFacVta: Record "Sales Invoice Header";
    begin
        if recFacVta.Get(codPrmFacLiq) then
            if recFacVta."Salesperson Code" <> '' then
                recPrmCabVta.Validate("Salesperson Code", recFacVta."Salesperson Code");
    end;


    procedure TraerNumFiscal(codPrmFac: Code[20]; var codPrmEstablecimiento: Code[3]; var codPrmPuntoEmision: Code[3]; var codPrmSecuencial: Code[19]): Code[40]
    var
        recCabFac: Record "Sales Invoice Header";
    begin
        if recCabFac.Get(codPrmFac) then begin
            codPrmEstablecimiento := recCabFac."Establecimiento Factura";
            codPrmPuntoEmision := recCabFac."Punto de Emision Factura";
            codPrmSecuencial := recCabFac."No. Comprobante Fiscal";
        end;
    end;


    procedure getCantidadDevuelta(pProducto: Code[20]; pFactura: Code[20]) rCantidadDevuelta: Decimal
    var
        lrSalesCreditMemoLine: Record "Sales Cr.Memo Line";
        lrSalesCreditMemoHeader: Record "Sales Cr.Memo Header";
        MovClienteConsultar: Record "Cust. Ledger Entry";
        SIHConsultar: Record "Sales Invoice Header";
    begin
        //Para el producto indicado y la factura indicada obtener la cantidad devuelta a traves de las
        //notas de credito relacionadas.

        Clear(rCantidadDevuelta);
        /*
        lrSalesCreditMemoHeader.RESET;
        lrSalesCreditMemoHeader.SETRANGE("No. Factura a Anular",pFactura);
        
        IF lrSalesCreditMemoHeader.FINDSET(FALSE,FALSE) THEN
          REPEAT
            lrSalesCreditMemoLine.RESET;
            lrSalesCreditMemoLine.SETRANGE(lrSalesCreditMemoLine."Document No.",lrSalesCreditMemoHeader."No.");
            lrSalesCreditMemoLine.SETRANGE(lrSalesCreditMemoLine.Type,lrSalesCreditMemoLine.Type::Item);
            lrSalesCreditMemoLine.SETRANGE(lrSalesCreditMemoLine."No.",pProducto);
        
            IF lrSalesCreditMemoLine.FINDSET(FALSE,FALSE) THEN
              REPEAT
                rCantidadDevuelta+=lrSalesCreditMemoLine.Quantity;
              UNTIL lrSalesCreditMemoLine.NEXT=0;
        
          UNTIL lrSalesCreditMemoHeader.NEXT=0
        ELSE
        BEGIN
          lrSalesCreditMemoHeader.SETRANGE("No. Factura a Anular");
          lrSalesCreditMemoHeader.SETRANGE("Applies-to Doc. Type",lrSalesCreditMemoHeader."Applies-to Doc. Type"::Invoice);
          lrSalesCreditMemoHeader.SETRANGE("Applies-to Doc. No.",pFactura);
        
          IF lrSalesCreditMemoHeader.FINDSET(FALSE,FALSE) THEN
            REPEAT
              lrSalesCreditMemoLine.RESET;
              lrSalesCreditMemoLine.SETRANGE(lrSalesCreditMemoLine."Document No.",lrSalesCreditMemoHeader."No.");
              lrSalesCreditMemoLine.SETRANGE(lrSalesCreditMemoLine.Type,lrSalesCreditMemoLine.Type::Item);
              lrSalesCreditMemoLine.SETRANGE(lrSalesCreditMemoLine."No.",pProducto);
        
              IF lrSalesCreditMemoLine.FINDSET(FALSE,FALSE) THEN
                REPEAT
                  rCantidadDevuelta+=lrSalesCreditMemoLine.Quantity;
                UNTIL lrSalesCreditMemoLine.NEXT=0;
        
            UNTIL lrSalesCreditMemoHeader.NEXT=0;
        END;
        */

        // ++ Debo buscar en mov cliente para poder encontrar todas las notas de credito
        SIHConsultar.Get(pFactura);
        MovClienteConsultar.Reset;
        MovClienteConsultar.SetCurrentKey("No. Comprobante Fiscal Rel.");
        MovClienteConsultar.SetRange("No. Comprobante Fiscal Rel.", SIHConsultar."No. Comprobante Fiscal");
        MovClienteConsultar.SetRange("Document Type", MovClienteConsultar."Document Type"::"Credit Memo");
        if MovClienteConsultar.FindSet then
            repeat
                if (MovClienteConsultar."No. Comprobante Fiscal Rel." <> '')
                  and (SIHConsultar."No. Comprobante Fiscal" <> '') then begin  //022 FES
                    lrSalesCreditMemoHeader.Get(MovClienteConsultar."Document No.");
                    // IF (SIHConsultar."Establecimiento Factura" = lrSalesCreditMemoHeader."Establecimiento Factura" ) //$023
                    // AND (SIHConsultar."Punto de Emision Factura" = lrSalesCreditMemoHeader."Punto de Emision Factura"  ) THEN // para validar que pertenezca a esta factura //$023
                    if (SIHConsultar."Establecimiento Factura" = lrSalesCreditMemoHeader."Establecimiento Fact. Rel") //$023
                    and (SIHConsultar."Punto de Emision Factura" = lrSalesCreditMemoHeader."Punto de Emision Fact. Rel.") then // para validar que pertenezca a esta factura     //$023
                      begin
                        lrSalesCreditMemoLine.Reset;
                        lrSalesCreditMemoLine.SetRange(lrSalesCreditMemoLine."Document No.", lrSalesCreditMemoHeader."No.");
                        lrSalesCreditMemoLine.SetRange(lrSalesCreditMemoLine.Type, lrSalesCreditMemoLine.Type::Item);
                        lrSalesCreditMemoLine.SetRange(lrSalesCreditMemoLine."No.", pProducto);

                        if lrSalesCreditMemoLine.FindSet then
                            repeat
                                rCantidadDevuelta += lrSalesCreditMemoLine.Quantity;
                            until lrSalesCreditMemoLine.Next = 0;
                    end;
                end;     //022 FES
            until MovClienteConsultar.Next = 0;
        // --

    end;


    procedure FiltroPorcientoDecimal(Filtro: Decimal)
    begin
        FiltroDescuento := Filtro;   // #175585
    end;


    procedure ProcesoCantDevueltaConsignacion(CantDev: Decimal; Product: Code[20]; Almacen: Code[20])
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        TransferRecLine: Record "Transfer Receipt Line";
        CantDeuelta: Decimal;
    begin
        //  $021

        CantDeuelta := CantDev;
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetCurrentKey("Item No.");
        ItemLedgerEntry.SetRange("Item No.", Product);
        ItemLedgerEntry.SetRange("Location Code", Almacen);
        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Transfer Receipt");
        ItemLedgerEntry.SetRange(Open, true);

        //IF DateFilter <> OD THEN
        // ItemLedgerEntry.SETRANGE("Posting Date",DateFilter);
        if ItemLedgerEntry.FindSet then
            repeat
                // Busco las lineas de la recepcion de transferencia y modifico campo cantidad devuelta
                TransferRecLine.Reset;
                TransferRecLine.SetRange("Document No.", ItemLedgerEntry."Document No.");
                TransferRecLine.SetRange("Item No.", Product);
                if TransferRecLine.FindSet then
                    repeat
                        if TransferRecLine."Cantidad Devuelta" < TransferRecLine.Quantity then begin
                            if TransferRecLine.Quantity > ItemLedgerEntry."Remaining Quantity" then begin
                                TransferRecLine."Cantidad Devuelta" += CantDeuelta;
                                CantDeuelta := 0;
                            end
                            else begin
                                TransferRecLine."Cantidad Devuelta" += TransferRecLine.Quantity;
                                CantDeuelta := CantDeuelta - TransferRecLine.Quantity;
                            end;
                            TransferRecLine.Modify;
                        end
                    until (TransferRecLine.Next = 0) or (CantDeuelta = 0)
            until (ItemLedgerEntry.Next = 0) or (CantDeuelta = 0)

    end;


    procedure TraerCodColegio(codPrmFacLiq: Code[20]; var recPrmCabVta: Record "Sales Header")
    var
        recFacVta: Record "Sales Invoice Header";
    begin
        if recFacVta.Get(codPrmFacLiq) then
            if recFacVta."Cod. Colegio" <> '' then
                recPrmCabVta.Validate("Cod. Colegio", recFacVta."Cod. Colegio");
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
}

