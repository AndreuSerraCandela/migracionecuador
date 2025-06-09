codeunit 56000 "Funciones Santillana"
{
    // Proyecto: Microsoft Dynamics Nav 2009 - Santillana
    // AMS     : Agustin Mendez
    // GRN     : Guillermo Roamn
    // --------------------------------------------------------------------------
    // No.     Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // 001     04-Junio-09     AMS           Pasamos los campos Precio venta, Descuento
    //                                       e Importe.
    // #842   CAT Actualización de la linea del packing con los datos requeridos del transportista (llamada a codenit externa)
    // 
    // #51496  27/04/2016  JMB   Se añade el campo Cantidad de Cajas, proveniente de la tabla 56020 Cab. Hoja de Ruta
    // 
    // 002     05/03/2024     LDP            SANTINAV-5638:Notas de crédito cargadas en diciembre putno de venta LA Y no se autorizan
    // 003     23/06/2024     LDP            SANTINAV-6431

    Permissions = TableData "Item Ledger Entry" = rm,
                  TableData "Sales Cr.Memo Header" = rm,
                  TableData "Transfer Receipt Header" = rm,
                  TableData "Transfer Receipt Line" = rm,
                  TableData "Registered Whse. Activity Line" = rimd;
    SingleInstance = true;

    trigger OnRun()
    begin

        //ColocarSerieNcfNrcPOS//002+-
    end;

    var
        Error001: Label 'Debe especificar Tarifa de venta para el producto %1';
        NoPedidoTransferencia: Code[20];
        Cliente: Record Customer;
        NoLinea: Integer;
        ConfSantillana: Record "Config. Empresa";
        txt001: Label 'From Customer:';
        Cantidad: Integer;
        TransferReceiptHeader: Record "Transfer Receipt Header";
        TransferReceiptLine: Record "Transfer Receipt Line";
        ItemLedgerEntryCons: Record "Item Ledger Entry";
        MailSetup: Record "Email Account";
        SMTP: Codeunit Email;
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Text001: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        rSalesLines: Record "Sales Line";
        UltimoLote: Integer;
        rConfTPV: Record "Configuracion General DsPOS";
        rGenJournalLine: Record "Gen. Journal Line";
        rCustLedgerEntry: Record "Cust. Ledger Entry";
        rItem: Record Item;
        rICR: Record "Item Reference";
        wDesc: Decimal;
        NoSerMang: Codeunit "No. Series";
        Error002: Label 'Qty. Packed is greater than Qty. in Picking %1 for item %2';
        ValidaReq: Codeunit "Valida Campos Requeridos";
        TransHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        NoLin: Integer;
        NewTransLine: Record "Transfer Line";
        DocDim: Codeunit DimensionManagement;
        Prueba: Record "Sello/Marca";


    procedure CalcrPrecio(ItemNo: Code[20]; CodCliente: Code[20]; CodUndMed: Code[20]; Fecha: Date): Decimal
    var
        wPrecio_Loc: Decimal;
    begin
        BuscaTarifa(ItemNo, CodCliente, wDesc, wPrecio_Loc);
        exit(wPrecio_Loc);
    end;


    procedure CalcDesc(ItemNo: Code[20]; CodCliente: Code[20]; CodUndMed: Code[20]; Fecha: Date): Decimal
    var
        Item: Record Item;
        wDesc_Loc: Decimal;
        wPrecio_Loc: Decimal;
    begin
        BuscaTarifa(ItemNo, CodCliente, wDesc_Loc, wPrecio_Loc);
        exit(wDesc_Loc);
    end;


    procedure InsertaInvConsig(SalesHeader: Record "Sales Header")
    var
        SalesLines: Record "Sales Line";
        SalesLine1: Record "Sales Line";
        Item: Record Item;
        Item1: Record Item;
        Cliente: Record Customer;
        NoLinea: Integer;
    begin
        SalesHeader.TestField("Location Code");
        Cliente.Get(SalesHeader."Sell-to Customer No.");
        SalesHeader.TestField("Location Code", Cliente."Cod. Almacen Consignacion");

        Item.Reset;
        if Item.FindFirst then
            repeat
                Item1.Reset;
                Item1.Get(Item."No.");
                Item1.SetFilter("Location Filter", SalesHeader."Location Code");
                Item1.CalcFields(Item1.Inventory);
                if Item1.Inventory <> 0 then begin
                    //Insertamos la linea en el pedido de venta
                    SalesLines.Reset;
                    SalesLines.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLines.SetRange("Document No.", SalesHeader."No.");
                    if SalesLines.FindLast then
                        NoLinea := SalesLines."Line No."
                    else
                        NoLinea := 0;

                    NoLinea += 10000;
                    SalesLine1.Init;
                    SalesLine1.Validate("Document Type", SalesHeader."Document Type");
                    SalesLine1.Validate("Document No.", SalesHeader."No.");
                    SalesLine1."Line No." := NoLinea;
                    SalesLine1.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
                    SalesLine1.Validate(Type, SalesLine1.Type::Item);
                    SalesLine1.Validate("No.", Item1."No.");
                    SalesLine1.Validate("Location Code", SalesHeader."Location Code");
                    SalesLine1.Validate(Quantity, Item1.Inventory);
                    SalesLine1.Insert(true);
                end;
            until Item.Next = 0;
    end;


    procedure BuscaLineasPendientesEntrega(TransferHeader: Record "Transfer Header"): Boolean
    var
        TransferLine: Record "Transfer Line";
        TransferLine1: Record "Transfer Line";
        txt001: Label 'Existen lineas de pedidos pendientes de entrega para Cod. producto %1 Almacen %2 en el pedido %3';
    begin
        //Entramos en el bucle de las lineas de la transferencia actual
        TransferLine.Reset;
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        if TransferLine.FindFirst then
            repeat
                TransferLine1.Reset;
                TransferLine1.SetRange("Item No.", TransferLine."Item No.");
                TransferLine1.SetRange("Transfer-to Code", TransferLine."Transfer-to Code");
                TransferLine1.SetFilter("Quantity Shipped", '<>0');
                TransferLine1.SetFilter("Qty. to Receive", '<>0');
                if TransferLine1.FindFirst then
                    if not Confirm(txt001, false, TransferLine1."Item No.", TransferLine1."Transfer-to Code", TransferLine1."Document No.") then
                        exit(false);
                exit(true);
            until TransferLine.Next = 0;
    end;


    procedure BuscaLineasPendEntregaVenta(SalesHeader: Record "Sales Header"): Boolean
    var
        SalesLine: Record "Sales Line";
        TransferLine1: Record "Transfer Line";
        txt001: Label 'Existen lineas de pedidos pendientes de entrega para Cod. producto %1 Almacen %2 en el pedido %3';
    begin
        //Entramos en el bucle de las lineas de la transferencia actual
        SalesLine.Reset;
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("No.", '<>''');
        if SalesLine.FindSet then
            repeat
                TransferLine1.Reset;
                TransferLine1.SetRange("Item No.", SalesLine."No.");
                TransferLine1.SetRange("Transfer-to Code", SalesLine."Location Code");
                TransferLine1.SetFilter("Quantity Shipped", '<>0');
                TransferLine1.SetFilter("Qty. to Receive", '<>0');
                if TransferLine1.FindFirst then
                    if not Confirm(txt001, false, TransferLine1."Item No.", TransferLine1."Transfer-to Code", TransferLine1."Document No.") then
                        exit(false);
                exit(true);
            until SalesLine.Next = 0;
    end;


    procedure RecibeNoDoc(NoDocumento: Code[20])
    begin
        NoPedidoTransferencia := NoDocumento;
    end;


    procedure EnviaNoTransferencia(): Code[20]
    begin
        exit(NoPedidoTransferencia);
    end;


    procedure InsertaInvConsigTransfer(TransHeader: Record "Transfer Header")
    var
        Item: Record Item;
        TransferLine: Record "Transfer Line";
        TransferLine1: Record "Transfer Line";
        Item1: Record Item;
    begin
        TransHeader.TestField("Transfer-from Code");
        Cliente.Get(TransHeader."Transfer-from Code");

        Item.Reset;
        if Item.Find('-') then
            repeat
                Item1.Reset;
                Item1.SetRange("No.", Item."No.");
                Item1.SetFilter("Location Filter", TransHeader."Transfer-from Code");
                if Item1.FindFirst then begin
                    Item1.CalcFields(Item1.Inventory);
                    if Item1.Inventory <> 0 then begin
                        //Insertamos la linea en el pedido de Transferencia
                        TransferLine.Reset;
                        TransferLine.SetRange("Document No.", TransHeader."No.");
                        TransferLine.SetRange(TransferLine."Derived From Line No.", 0);
                        if TransferLine.FindLast then
                            NoLinea := TransferLine."Line No."
                        else
                            NoLinea := 0;
                        NoLinea += 10000;
                        TransferLine1.Init;
                        TransferLine1.Validate("Document No.", TransHeader."No.");
                        TransferLine1."Line No." := NoLinea;
                        TransferLine1.Validate("Item No.", Item1."No.");
                        TransferLine1.Validate(Quantity, Item1.Inventory);
                        TransferLine1."Precio Venta Consignacion" := CalcrPrecio(Item1."No.", TransHeader."Transfer-from Code",
                        TransferLine1."Unit of Measure Code", TransHeader."Posting Date");
                        TransferLine1."Descuento % Consignacion" := CalcDesc(Item1."No.", TransHeader."Transfer-from Code",
                                                                       TransferLine1."Unit of Measure Code", TransHeader."Posting Date");
                        TransferLine1.Validate(Quantity);
                        TransferLine1.Validate("Qty. to Ship", 0);
                        TransferLine1.Insert(true);
                    end;
                end;
            until Item.Next = 0;
    end;


    procedure CreaEmailPedidoVenta(SalesHeader: Record "Sales Header")
    var
        SenderName: Text[100];
        SenderAddress: Text[100];
        Recipient: Text[1024];
        Subject: Text[100];
        Body: Text[1024];
        SalesHeader1: Record "Sales Header";
    begin
        /*
        ConfSantillana.GET;
        ConfSantillana.TESTFIELD("Ubicacion Temp. Reportes HTML");
        MailSetup.GET;
        Recipient := '';
        
        UserSetup.GET(USERID);
        IF UserSetup."Envia E-mail pedido venta" THEN
          BEGIN
            Subject       := ConfSantillana."Titulo E-mail Pedido de Venta" + ' ' +SalesHeader."No." + ' '+txt001 +
                             SalesHeader."Sell-to Customer No." + '-'+SalesHeader."Bill-to Name";
            SenderName    := COMPANYNAME;
            SenderAddress := MailSetup."User ID";
            //Correos de usuario(s) destino
            UserSetUp1.RESET;
            UserSetUp1.SETRANGE("Recibe E-mail pedido venta",TRUE);
            IF UserSetUp1.FINDSET(FALSE,FALSE) THEN
              REPEAT
                UserSetUp1.TESTFIELD("E-Mail");
                Recipient += UserSetUp1."E-Mail"+';';
              UNTIL UserSetUp1.NEXT = 0;
        
            //Se quita el signo ultimo ;
            Recipient := COPYSTR(Recipient,1,(STRLEN(Recipient)-1));
        
            SMTP.CreateMessage(SenderName,SenderAddress,Recipient,Subject,Body,TRUE);
            Body := '';
            SMTP.AppendBody(Body);
            SalesHeader1.RESET;
            SalesHeader1.SETRANGE("Document Type",SalesHeader."Document Type");
            SalesHeader1.SETRANGE("No.",SalesHeader."No.");
            REPORT.SAVEASHTML(50014,ConfSantillana."Ubicacion Temp. Reportes HTML"+'REP25001.html',FALSE,SalesHeader1);
            SMTP.AddAttachment(ConfSantillana."Ubicacion Temp. Reportes HTML"+'REP25001.html');
            SMTP.Send;
            ERASE(ConfSantillana."Ubicacion Temp. Reportes HTML"+'REP25001.html');
        
            SalesHeader."Estado distribucion" := SalesHeader."Estado distribucion"::"Para Confirmar";
            SalesHeader.MODIFY;
          END;
         */

    end;


    procedure CreaEmailPedidoConsg(TransferHeader: Record "Transfer Header")
    var
        SenderName: Text[100];
        SenderAddress: Text[100];
        Recipient: Text[1024];
        Subject: Text[100];
        Body: Text[1024];
        TransferHeader1: Record "Transfer Header";
    begin
        /*
        ConfSantillana.GET;
        ConfSantillana.TESTFIELD("Ubicacion Temp. Reportes HTML");
        MailSetup.GET;
        Recipient := '';
        
        UserSetup.GET(USERID);
        IF UserSetup."Envia E-mail pedido venta" THEN
          BEGIN
            Cliente.GET(TransferHeader."Transfer-to Code");
            Subject       := ConfSantillana."Titulo E-mail Pedido de Venta" + ' ' +TransferHeader."No."+ ' '+txt001 +
                             Cliente."No." + '-'+Cliente.Name;
            SenderName    := COMPANYNAME;
            SenderAddress := MailSetup."User ID";
            //Correos de usuario(s) destino
            UserSetUp1.RESET;
            UserSetUp1.SETRANGE(UserSetUp1."Recibe E-mail pedido venta",TRUE);
            IF UserSetUp1.FINDSET(FALSE,FALSE) THEN
              REPEAT
                UserSetUp1.TESTFIELD("E-Mail");
                Recipient += UserSetUp1."E-Mail"+';';
              UNTIL UserSetUp1.NEXT = 0;
        
            //Se quita el signo ultimo ;
            Recipient := COPYSTR(Recipient,1,(STRLEN(Recipient)-1));
        
            SMTP.CreateMessage(SenderName,SenderAddress,Recipient,Subject,Body,TRUE);
            Body := '';
            SMTP.AppendBody(Body);
            TransferHeader1.GET(TransferHeader."No.");
            REPORT.SAVEASHTML(50018,ConfSantillana."Ubicacion Temp. Reportes HTML"+'REP5703.html',FALSE,TransferHeader1);
            SMTP.AddAttachment(ConfSantillana."Ubicacion Temp. Reportes HTML"+'REP5703.html');
            SMTP.Send;
            ERASE(ConfSantillana."Ubicacion Temp. Reportes HTML"+'REP5703.html');
        
            TransferHeader."Estado distribucion" := TransferHeader."Estado distribucion"::"Para Confirmar";
            TransferHeader.MODIFY;
          END;
         */

    end;


    procedure ControlNoCopias(SalesHeader: Record "Sales Header"; DocumentoImpreso: Option Picking)
    begin
        if DocumentoImpreso = 0 then
            SalesHeader."No. copias Picking" := SalesHeader."No. copias Picking" + 1;
        SalesHeader.Modify;
        Commit;
    end;


    procedure ControlNoCopiasConsignacion(TransferHeader: Record "Transfer Header")
    begin
        TransferHeader."No. Copias impresas" := TransferHeader."No. Copias impresas" + 1;
        TransferHeader.Modify;
        Commit;
    end;


    procedure ControlNoCopiasCosngRecepcion(TransferRecHeader: Record "Transfer Receipt Header")
    begin
        TransferRecHeader."No. Copias imp. Recep." := TransferRecHeader."No. Copias imp. Recep." + 1;
        TransferRecHeader.Modify;
        Commit;
    end;


    procedure InvConsPedidoVenta(CodCliente: Code[20])
    var
        NoRecepcion: Code[20];
        CFuncSantillana: Codeunit "Funciones Santillana";
        NoPedidoActual: Code[20];
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        TransHeader1: Record "Transfer Header";
        SalesLine1: Record "Sales Line";
        TransRecHeader: Record "Transfer Receipt Header";
        TransRecLines: Record "Transfer Receipt Line";
        TransRecHeader1: Record "Transfer Receipt Header";
        TransRecLines1: Record "Transfer Receipt Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        rLinCons: Record "Lin. Consignacion a Facturar";
        rLinCons1: Record "Lin. Consignacion a Facturar";
        frmLinConsig: Page "Lin. Consignacion a Facturar";
    begin
        NoPedidoActual := CFuncSantillana.EnviaNoTransferencia;
        Counter := 0;
        CounterTotal := 0;

        rLinCons.Reset;
        rLinCons.SetRange("Document Type", rLinCons."Document Type"::Order);
        rLinCons.SetRange("Document No.", NoPedidoActual);
        rLinCons.SetRange("ID Usuario", UserId);
        rLinCons.DeleteAll;

        //Buscamos lineas pedido de venta a consignacion
        TransRecLines.Reset;
        TransRecLines.SetCurrentKey("Transfer-to Code");
        TransRecLines.SetRange("Transfer-to Code", CodCliente);
        CounterTotal := TransRecLines.Count;
        Window.Open(Text001);
        if TransRecLines.FindSet then
            repeat
                Counter := Counter + 1;
                Window.Update(1, TransRecLines."Document No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                //Se busca el No. de mov. producto correspondiente a la linea para pasarla a la linea de pedidos
                //de venta
                ItemLedgerEntry.Reset;
                ItemLedgerEntry.SetCurrentKey("Document No.", "Document Type", "Document Line No.");
                ItemLedgerEntry.SetRange("Document No.", TransRecLines."Document No.");
                ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Transfer Receipt");
                ItemLedgerEntry.SetRange("Document Line No.", TransRecLines."Line No.");
                ItemLedgerEntry.SetRange("Location Code", TransRecLines."Transfer-to Code");
                if ItemLedgerEntry.FindFirst then begin
                    //   itemledgerentry.calcfields("remaining quantity"); //GRN
                    ItemLedgerEntry."Cant. Consignacion Pendiente" := ItemLedgerEntry."Remaining Quantity"; //GRN
                    if ItemLedgerEntry."Cant. Consignacion Pendiente" > 0 then begin
                        rLinCons1.Reset;
                        rLinCons1.SetRange("Document Type", rLinCons1."Document Type"::Order);
                        rLinCons1.SetRange("Document No.", NoPedidoActual);
                        rLinCons1.SetRange("ID Usuario", UserId);
                        if rLinCons1.FindLast then
                            NoLinea := rLinCons1."Line No."
                        else
                            NoLinea := 0;

                        NoLinea := NoLinea + 10000;
                        rLinCons.Init;
                        rLinCons.Validate("Document Type", rLinCons."Document Type"::Order);
                        rLinCons.Validate("Document No.", NoPedidoActual);
                        rLinCons.Validate("Line No.", NoLinea);
                        rLinCons.Validate(Type, rLinCons.Type::Item);
                        rLinCons.Validate("No.", TransRecLines."Item No.");
                        rLinCons.Validate("No. Mov. Prod. Cosg. a Liq.", ItemLedgerEntry."Entry No.");
                        rLinCons.Validate("ID Usuario", UserId);

                        //La cantidad que se pasa a las lineas de venta es la pendiente en el
                        //Mov. producto
                        rLinCons.Validate(Quantity, ItemLedgerEntry."Cant. Consignacion Pendiente");
                        rLinCons.Validate("Cantidad a Facturar", ItemLedgerEntry."Cant. Consignacion Pendiente");

                        rLinCons.Validate("Unit of Measure Code", TransRecLines."Unit of Measure Code");

                        //el precio de venta es el actual. confirmado por Robert Molina el 22 Julio 2011
                        /*
                        SalesLine.VALIDATE("Unit Price",TransRecLines."Precio Venta Consignacion");
                        SalesLine.VALIDATE(SalesLine."Line Discount %",TransRecLines."Descuento % Consignacion");
                        */
                        /* //GRN 25/01/2012 Para buscar el ultimo precio de venta
                         SalesLine1.RESET;
                         SalesLine1.SETRANGE(SalesLine1."Document Type",SalesLine1."Document Type"::Order);
                         SalesLine1.SETRANGE(SalesLine1."Document No.",NoPedidoActual);
                         IF SalesLine1.FINDLAST THEN
                           NoLinea := SalesLine1."Line No."
                         ELSE
                           NoLinea := 0;

                         NoLinea += 10000;
                         SalesLine.INIT;
                         SalesLine.VALIDATE("Document Type",SalesLine."Document Type"::Order);
                         SalesLine.VALIDATE("Document No.",NoPedidoActual);
                         SalesLine.VALIDATE("Line No.",NoLinea);
                         SalesLine.VALIDATE(Type,SalesLine.Type::Item);
                         SalesLine.VALIDATE("No.",TransRecLines."Item No.");
                         rLinCons."Unit Price" := SalesLine."Unit Price";
                         */
                        //GRN Hasta aqui
                        rLinCons.Validate("No. Pedido Consignacion", TransRecLines."Document No.");
                        rLinCons.Validate("No. Linea Pedido Consignacion", TransRecLines."Line No.");
                        rLinCons.Validate(Description, TransRecLines.Description);

                        rLinCons.Insert(true);
                    end;
                end;
            until TransRecLines.Next = 0;
        Window.Close;

        Commit;
        rLinCons.Reset;
        rLinCons.SetRange("Document Type", rLinCons."Document Type"::Order);
        rLinCons.SetRange("Document No.", NoPedidoActual);
        rLinCons.SetRange("ID Usuario", UserId);
        frmLinConsig.SetTableView(rLinCons);
        frmLinConsig.RecibeNoPedido(NoPedidoActual);
        frmLinConsig.RunModal;
        Clear(frmLinConsig);

    end;


    procedure ActualizaCantPendCons(ItemLedgerEntryFromJournal: Record "Item Ledger Entry")
    var
        ItemLedgerEntry1: Record "Item Ledger Entry";
    begin
        TransferReceiptHeader.Reset;
        TransferReceiptHeader.SetRange(TransferReceiptHeader."No.", ItemLedgerEntryFromJournal."Document No.");
        TransferReceiptHeader.FindFirst;

        TransferReceiptLine.Reset;
        TransferReceiptLine.SetRange("Document No.", ItemLedgerEntryFromJournal."Document No.");
        TransferReceiptLine.SetRange("Line No.", ItemLedgerEntryFromJournal."Document Line No.");
        TransferReceiptLine.SetRange("Cantidad Consg. Aplicada", false);
        if TransferReceiptLine.FindFirst then begin
            ItemLedgerEntry1.Get(TransferReceiptLine."No. Mov. Prod. Cosg. a Liq.");
            ItemLedgerEntry1."Cant. Consignacion Pendiente" := ItemLedgerEntry1."Cant. Consignacion Pendiente" -
                                                                TransferReceiptLine.Quantity;
            TransferReceiptLine."Cantidad Consg. Aplicada" := true;
            TransferReceiptLine.Modify;
            ItemLedgerEntry1.Modify;
        end;
    end;


    procedure ControlNoCopiasNotaCredito(SalesCreditMemoHeader: Record "Sales Cr.Memo Header")
    begin
        SalesCreditMemoHeader."No. Printed" := SalesCreditMemoHeader."No. Printed" + 1;
        SalesCreditMemoHeader.Modify;
        Commit;
    end;


    procedure EnviaAConfirmarConsignacion(TransferHeader: Record "Transfer Header")
    var
        SenderName: Text[100];
        SenderAddress: Text[100];
        Recipient: Text[1024];
        Subject: Text[100];
        Body: Text[1024];
        TransferHeader1: Record "Transfer Header";
    begin
        /*
        ConfSantillana.GET;
        MailSetup.GET;
        Recipient := '';
        
        UserSetup.GET(USERID);
        IF UserSetup."Envia E-mail Confirmacion Ped." THEN
          BEGIN
            Cliente.GET(TransferHeader."Transfer-to Code");
            Subject       := ConfSantillana."Titulo E-mail Confirm. Pedido" + ' ' +TransferHeader."No."+ ' '+txt001 +
                             Cliente."No." + '-'+Cliente.Name;
            SenderName    := COMPANYNAME;
            SenderAddress := MailSetup."User ID";
            //Correos de usuario(s) destino
            UserSetUp1.RESET;
            UserSetUp1.SETRANGE("Recibe E-mail Confirmacion Ped",TRUE);
            IF UserSetUp1.FINDSET(FALSE,FALSE) THEN
              REPEAT
                UserSetUp1.TESTFIELD("E-Mail");
                Recipient += UserSetUp1."E-Mail"+';';
              UNTIL UserSetUp1.NEXT = 0;
        
            //Se quita el signo ultimo ;
            Recipient := COPYSTR(Recipient,1,(STRLEN(Recipient)-1));
        
            SMTP.CreateMessage(SenderName,SenderAddress,Recipient,Subject,Body,TRUE);
            Body := '';
            SMTP.AppendBody(Body);
            SMTP.Send;
        
            TransferHeader."Estado distribucion" := TransferHeader."Estado distribucion"::"Para Confirmar";
            TransferHeader.MODIFY;
          END;
          */

    end;


    procedure EnviaAConfirmarPedidoVenta(SalesHeader: Record "Sales Header")
    var
        SenderName: Text[100];
        SenderAddress: Text[100];
        Recipient: Text[1024];
        Subject: Text[100];
        Body: Text[1024];
        SalesHeader1: Record "Sales Header";
    begin
        /*
        
        ConfSantillana.GET;
        MailSetup.GET;
        Recipient := '';
        
        UserSetup.GET(USERID);
        
        IF UserSetup."Envia E-mail Confirmacion Ped." THEN
          BEGIN
            Subject       := ConfSantillana."Titulo E-mail Confirm. Pedido" + ' ' +SalesHeader."No." + ' '+txt001 +
                             SalesHeader."Sell-to Customer No." + '-'+SalesHeader."Bill-to Name";
            SenderName    := COMPANYNAME;
            SenderAddress := MailSetup."User ID";
            //Correos de usuario(s) destino
            UserSetUp1.RESET;
            UserSetUp1.SETRANGE("Recibe E-mail Confirmacion Ped",TRUE);
            IF UserSetUp1.FINDSET(FALSE,FALSE) THEN
              REPEAT
                UserSetUp1.TESTFIELD("E-Mail");
                Recipient += UserSetUp1."E-Mail"+';';
              UNTIL UserSetUp1.NEXT = 0;
        
            //Se quita el signo ultimo ;
            Recipient := COPYSTR(Recipient,1,(STRLEN(Recipient)-1));
        
            SMTP.CreateMessage(SenderName,SenderAddress,Recipient,Subject,Body,TRUE);
            Body := '';
        
            SMTP.AppendBody(Body);
            SMTP.Send;
            SalesHeader."Estado distribucion" := SalesHeader."Estado distribucion"::"Para Confirmar";
            SalesHeader.MODIFY;
          END;
         */

    end;


    procedure CalcAvailableCredit(CustNo: Code[20]; SalesHeaderActual: Record "Sales Header"): Decimal
    var
        TotalAmountLCY: Decimal;
        Cliente: Record Customer;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        wPendiente: Decimal;
        wCreditoDisponible: Decimal;
        wPendienteActual: Decimal;
        wBalanceConsignacion: Decimal;
    begin
        ConfSantillana.Get;
        Clear(wPendiente);
        Clear(wBalanceConsignacion);
        Cliente.Get(CustNo);
        Cliente.SetRange("Date Filter", 0D, WorkDate);
        Cliente.CalcFields("Balance (LCY)");

        //Calculo el importe pendiente del pedido actual
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesHeaderActual."Document Type");
        SalesLine.SetRange("Document No.", SalesHeaderActual."No.");
        if SalesLine.FindSet then
            repeat
                wPendienteActual += SalesLine."Outstanding Amount (LCY)";
            until SalesLine.Next = 0;

        SalesHeader.Reset;
        SalesHeader.SetCurrentKey("Document Type", "Sell-to Customer No.", Status);
        SalesHeader.SetFilter("Document Type", '%1|%2', SalesHeader."Document Type"::Order,
                                SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("Sell-to Customer No.", CustNo);
        SalesHeader.SetRange(Status, SalesHeader.Status::Released);
        if SalesHeader.FindSet then
            repeat
                SalesLine.Reset;
                SalesLine.SetRange(SalesLine."Document Type", SalesHeader."Document Type");
                SalesLine.SetRange(SalesLine."Document No.", SalesHeader."No.");
                if SalesLine.FindSet then
                    repeat
                        wPendiente += SalesLine."Outstanding Amount (LCY)"
                    until SalesLine.Next = 0;

            until SalesHeader.Next = 0;

        TotalAmountLCY := Cliente."Balance (LCY)" + wPendiente + wPendienteActual;

        //Se toma en cuenta el balance en consignacion que tiene el cliente
        //para el limite de credito
        Cliente.CalcFields("Balance en Consignacion");
        wBalanceConsignacion := Cliente."Balance en Consignacion";

        TotalAmountLCY += wBalanceConsignacion;

        if Cliente."Credit Limit (LCY)" <> 0 then begin
            if ConfSantillana."Credito excedido %" <> 0 then begin
                wCreditoDisponible := (Cliente."Credit Limit (LCY)" * ConfSantillana."Credito excedido %") / 100;
                wCreditoDisponible := Cliente."Credit Limit (LCY)" + wCreditoDisponible;
            end
            else
                wCreditoDisponible := Cliente."Credit Limit (LCY)";


            exit(wCreditoDisponible - TotalAmountLCY);
        end;
    end;


    procedure cuCreaCupones(CodColegio: Code[20]; CodVendedor: Code[20]; NombreVendedor: Text[100]; ValidaDesde: Date; ValidaHasta: Date; GradoAlumno: Text[30]; DescuentoAColegio: Decimal; DescAPadre: Decimal; AnoEscolar: Text[30]; NombreColegio: Text[100]; txtDescripcion: Text[250]; CantidadCupones: Integer; Nivelalum: Code[20]; DescGrado: Text[50])
    var
        rSalesperson: Record "Salesperson/Purchaser";
        rContacto: Record Contact;
        I: Integer;
        rCabCupon: Record "Cab. Cupon.";
        rLinCupon: Record "Lin. Cupon.";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        CounterOK: Integer;
        rConfEmpresa: Record "Config. Empresa";
        cuNoSerMangm: Codeunit "No. Series";
        rCreaCupLot: Record "Crear Cupon por Lote.";
        rCabCupon1: Record "Cab. Cupon.";
        rAnoEscolar: Record "Año Escolar.";
        rCrearCuponPorLote: Record "Crear Cupon por Lote.";
        NoSeries: Code[20];
        rVendPorColegio: Record "Vendedores por Colegio";
        Error001: Label 'You Must complete Salesperson Code';
        Error002: Label 'You must complete School Code';
        Error003: Label 'You must complete Valid From';
        Error004: Label 'You must complete Valid to';
        Error008: Label 'Family Discount Must be completed';
        Text001: Label 'Creating Coupons   #1########## @2@@@@@@@@@@@@@';
        Text002: Label '%1 Coupons out of a total of %2 have now been created.';
        Error005: Label 'You must complete Coupons Qty.';
        Error006: Label 'You must indicate No. Series No.';
        Error007: Label 'The Salesperson %1 is not included in School - Salespersons %2';
        txt001: Label 'Confirm that you want generate the coupons';
    begin
        UltimoLote := UltLoteCupon + 1;

        /*rVendPorColegio.RESET;
        rVendPorColegio.SETRANGE("Cod. Colegio",CodColegio);
        rVendPorColegio.SETRANGE("Cod. Vendedor",CodVendedor);
        IF NOT rVendPorColegio.FINDFIRST THEN
          ERROR(Error007);
        */
        if CodVendedor = '' then
            Error(Error001);
        if CodColegio = '' then
            Error(Error002);
        if ValidaDesde = 0D then
            Error(Error003);
        if ValidaHasta = 0D then
            Error(Error004);

        if CantidadCupones = 0 then
            Error(Error005);

        /*
        Deshabilitado por solicitud 26-10-11
        IF DescAPadre = 0 THEN
          ERROR(Error008);
        */

        rConfEmpresa.Get;
        rConfEmpresa.TestField("No. serie Cupon");

        CounterTotal := CantidadCupones;
        Window.Open(Text001);

        repeat

            rCabCupon."No. Cupon" := cuNoSerMangm.GetNextNo(rConfEmpresa."No. serie Cupon", WorkDate, true);
            Counter := Counter + 1;
            Window.Update(1, rCabCupon."No. Cupon");
            Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

            I += 1;
            rCabCupon.Validate("Valido Desde", ValidaDesde);
            rCabCupon.Validate("Valido Hasta", ValidaHasta);
            rCabCupon.Validate("Cod. Colegio", CodColegio);
            rCabCupon.Validate("Cod. Nivel", Nivelalum);
            rCabCupon.Validate("Descuento a Colegio", DescuentoAColegio);
            rCabCupon.Validate("Descuento a Padres de Familia", DescAPadre);
            rCabCupon.Validate("Cod. Promotor", CodVendedor);
            rCabCupon.Validate(Descripcion, txtDescripcion);
            rCabCupon."No. Lote" := UltimoLote;
            rCabCupon.Validate("Fecha Creacion", WorkDate);
            rCabCupon.Validate("Hora Creacion", Time);
            rCabCupon.Validate("Creado por Usuario", UserId);
            rCabCupon.Validate("Cod. Grado", GradoAlumno);
            rCabCupon.Validate("Descripcion Grado", DescGrado);
            rCabCupon.Insert(true);

            rCreaCupLot.Reset;
            if rCreaCupLot.FindSet then
                repeat
                    if rCreaCupLot."Cod. Producto" <> '' then begin
                        rLinCupon.Init;
                        rLinCupon.Validate("No. Cupon", rCabCupon."No. Cupon");
                        rLinCupon.Validate("Cod. Producto", rCreaCupLot."Cod. Producto");
                        rLinCupon.Validate("Precio Venta", rCreaCupLot."Precio Venta");
                        rLinCupon.Validate("% Descuento", rCreaCupLot."% Descuento Padre");
                        rLinCupon.Validate(Cantidad, 1);
                        rLinCupon.Insert;
                    end;
                until rCreaCupLot.Next = 0;

        until I = CantidadCupones;

        Window.Close;
        Message(Text002, I, CounterTotal);

        rCreaCupLot.Reset;
        rCreaCupLot.DeleteAll;

    end;


    procedure UltLoteCupon(): Integer
    var
        rCabCupon: Record "Cab. Cupon.";
    begin
        rCabCupon.SetCurrentKey("No. Lote");
        if rCabCupon.FindLast then
            exit(rCabCupon."No. Lote")
        else
            exit(0);
    end;


    procedure AddProdCupon(CodCuponDesde: Code[20]; CodCuponHasta: Code[20]; CodProd: Code[20])
    var
        rCabCupon: Record "Cab. Cupon.";
        rLinCupon: Record "Lin. Cupon.";
        rCabCupon1: Record "Cab. Cupon.";
    begin
        Counter := 0;
        CounterTotal := 0;


        Window.Open(Text001);

        rCabCupon1.Reset;
        rCabCupon1.SetRange("No. Cupon", CodCuponDesde, CodCuponHasta);
        CounterTotal := rCabCupon1.Count;
        if rCabCupon1.FindSet then
            repeat
                Counter := Counter + 1;
                Window.Update(1, rCabCupon."No. Cupon");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                rCabCupon.Get(rCabCupon1."No. Cupon");
                rLinCupon.Reset;
                rLinCupon.Init;
                rLinCupon.Validate("No. Cupon", rCabCupon."No. Cupon");
                rLinCupon.Validate("Cod. Producto", CodProd);
                rLinCupon.Validate("% Descuento", rCabCupon."Descuento a Padres de Familia");
                rLinCupon.Validate(Cantidad, 1);
                rLinCupon.Insert;
            until rCabCupon1.Next = 0;
    end;


    procedure BuscaTarifa(CodProducto: Code[20]; CodCliente: Code[20]; var wDesc_Loc: Decimal; var wPrecio_Loc: Decimal)
    var
        rSalesHeader_Loc: Record "Sales Header";
        rSalesLines_Loc: Record "Sales Line";
    begin
        if rItem.Get(CodProducto) then begin
            rSalesHeader_Loc.Reset;
            rSalesHeader_Loc.Init;
            rSalesHeader_Loc.Validate("Document Type", 1);
            rSalesHeader_Loc."No." := txt001;
            rSalesHeader_Loc.Validate("Posting Date", WorkDate);
            rSalesHeader_Loc.Validate("Document Date", WorkDate);
            rSalesHeader_Loc.Validate("Sell-to Customer No.", CodCliente);
            rSalesHeader_Loc.Insert(true);

            rSalesLines_Loc.Init;
            rSalesLines_Loc.Temporal := true;
            rSalesLines_Loc.Validate("Document Type", 1);
            rSalesLines_Loc."Document No." := txt001;
            rSalesLines_Loc."Line No." := 1000;
            rSalesLines_Loc.Validate(Type, rSalesLines_Loc.Type::Item);
            rSalesLines_Loc.Validate("No.", CodProducto);
            rSalesLines_Loc.Validate(Quantity, 1);
            rSalesLines_Loc.Insert(true);
            wPrecio_Loc := rSalesLines_Loc."Unit Price";
            wDesc_Loc := rSalesLines_Loc."Line Discount %";

            if rSalesHeader_Loc.Delete(true) then;

        end
        else begin
            rICR.Reset;
            rICR.SetRange("Reference Type", rICR."Reference Type"::"Bar Code");
            rICR.SetRange("Item No.", CodProducto);
            if rICR.FindFirst then begin
                rSalesHeader_Loc.Reset;
                rSalesHeader_Loc.Init;
                rSalesHeader_Loc.Validate("Document Type", 1);
                rSalesHeader_Loc."No." := txt001;
                rSalesHeader_Loc.Validate("Posting Date", WorkDate);
                rSalesHeader_Loc.Validate("Sell-to Customer No.", CodCliente);
                rSalesHeader_Loc.Insert(true);

                rSalesLines_Loc.Init;
                rSalesLines_Loc.Validate("Document Type", 1);
                rSalesLines_Loc.Temporal := true;
                rSalesLines_Loc."Document No." := txt001;
                rSalesLines_Loc."Line No." := 1000;
                rSalesLines_Loc.Validate(Type, rSalesLines_Loc.Type::Item);
                rSalesLines_Loc.Validate("No.", rICR."Item No.");
                rSalesLines_Loc.Validate(Quantity, 1);
                rSalesLines_Loc.Insert(true);
                wPrecio_Loc := rSalesLines_Loc."Unit Price";
                wDesc_Loc := rSalesLines_Loc."Line Discount %";

                if rSalesHeader_Loc.Delete(true) then;

            end;
        end;
    end;


    procedure RegistraPacking(CabPack: Record "Cab. Packing")
    var
        linPack: Record "Lin. Packing";
        CCP: Record "Contenido Cajas Packing";
        txt001: Label 'There is nothing to post';
        CabPackReg: Record "Cab. Packing Registrado";
        LinPackReg: Record "Lin. Packing Registrada";
        CCPR: Record "Contenido Cajas Packing Reg.";
        RWhseActLine: Record "Registered Whse. Activity Line";
        CantBultos: Integer;
        CantAEmpac: Decimal;
        CantPenEmpac: Decimal;
        NoPacking: Code[20];
        NoPick: Code[20];
        WSH: Record "Warehouse Shipment Header";
        PackCompleto: Boolean;
        RWhseActLine1: Record "Registered Whse. Activity Line";
    begin
        ConfSantillana.Get;
        ConfSantillana.TestField("No. Serie Packing Reg.");

        //Se valida que todas las cajas estén cerradas
        linPack.Reset;
        linPack.SetRange("No.", CabPack."No.");
        if linPack.FindSet then
            repeat
                linPack.TestField("Estado Caja", linPack."Estado Caja"::Cerrada);
            until linPack.Next = 0
        else
            Error(txt001);

        CabPack.CalcFields("Cantidad de Bultos");
        CantBultos := CabPack."Cantidad de Bultos";

        //Cabecera de Packing
        CabPackReg.Init;
        CabPackReg.TransferFields(CabPack);
        CabPackReg."No." := NoSerMang.GetNextNo(ConfSantillana."No. Serie Packing Reg.", WorkDate, true);
        CabPackReg."No. Packing Origen" := CabPack."No.";
        CabPackReg."Fecha Registro" := WorkDate;
        CabPackReg.Insert;

        //Lineas de Packing
        linPack.Reset;
        linPack.SetRange("No.", CabPack."No.");
        if linPack.FindSet then
            repeat
                LinPackReg.Init;
                LinPackReg.TransferFields(linPack);
                LinPackReg.Validate("No.", CabPackReg."No.");
                LinPackReg.Insert;
            until linPack.Next = 0;

        //+#842
        if ConfSantillana."ID Codeunit fic. transportista" <> 0 then
            CODEUNIT.Run(ConfSantillana."ID Codeunit fic. transportista", CabPackReg);
        //-#842

        //Contenido Cajas
        CCP.Reset;
        CCP.SetRange(CCP."No. Packing", CabPack."No.");
        if CCP.FindSet then
            repeat
                CCPR.Init;
                CCPR.TransferFields(CCP);
                CCPR.Validate("No. Packing", CabPackReg."No.");
                CCPR.Insert;

                //Se actualizan las lineas de Picking registrados
                RWhseActLine.Reset;
                RWhseActLine.SetRange("Activity Type", RWhseActLine."Activity Type"::Pick);
                RWhseActLine.SetRange("No.", CCPR."No. Picking");
                RWhseActLine.SetRange("Action Type", RWhseActLine."Action Type"::Take);
                RWhseActLine.SetRange(RWhseActLine."Item No.", CCPR."No. Producto");
                if RWhseActLine.FindSet then begin
                    CantAEmpac := CCP.Cantidad;
                    repeat
                        if RWhseActLine.Quantity > RWhseActLine."Cantidad Empacada" then begin
                            CantPenEmpac := RWhseActLine.Quantity - RWhseActLine."Cantidad Empacada";
                            if CantPenEmpac <= CantAEmpac then begin
                                RWhseActLine."Cantidad Empacada" += CantPenEmpac;
                                CantAEmpac := CantAEmpac - CantPenEmpac;
                            end
                            else begin
                                RWhseActLine."Cantidad Empacada" += CantAEmpac;
                                CantAEmpac := 0;
                            end;
                            if RWhseActLine."Cantidad Empacada" > RWhseActLine.Quantity then
                                Error(Error002, RWhseActLine."No.", RWhseActLine."Item No.");

                            RWhseActLine.Validate("No. Packing", CabPack."No.");
                            RWhseActLine.Validate("No. Caja", CCPR."No. Caja");
                            RWhseActLine.Validate("No. Packing Registrado", CCPR."No. Packing");
                            RWhseActLine.Validate("No. Linea Packing", CCPR."No. Linea");
                            if RWhseActLine."Cantidad Empacada" >= RWhseActLine.Quantity then
                                RWhseActLine."Packing Completado" := true;
                            RWhseActLine.Modify;
                        end;
                    until (RWhseActLine.Next = 0) or (CantAEmpac = 0);
                end;
                if CantAEmpac > 0 then
                    Error(Error002, RWhseActLine."No.", RWhseActLine."Item No.");

            until CCP.Next = 0;

        NoPick := CabPack."Picking No.";

        //Se elimina el borrador de Packing
        //Lineas
        linPack.Reset;
        linPack.SetRange("No.", CabPack."No.");
        linPack.DeleteAll;

        //Contenido Cajas
        CCP.Reset;
        CCP.SetRange(CCP."No. Packing", CabPack."No.");
        CCP.DeleteAll;

        //Cabecera
        CabPack.Delete;

        RWhseActLine.Reset;
        RWhseActLine.SetCurrentKey("No. Packing");
        RWhseActLine.SetRange("Activity Type", RWhseActLine."Activity Type"::Pick);
        RWhseActLine.SetRange("No.", NoPick);
        if RWhseActLine.FindFirst then begin
            if WSH.Get(RWhseActLine."Whse. Document No.") then begin
                PackCompleto := true;
                RWhseActLine1.Reset;
                RWhseActLine1.SetRange("Activity Type", RWhseActLine1."Activity Type"::Pick);
                RWhseActLine1.SetRange("Whse. Document No.", WSH."No.");
                RWhseActLine1.SetRange("Action Type", RWhseActLine1."Action Type"::Take);
                if RWhseActLine1.FindSet then
                    repeat
                        if not RWhseActLine1."Packing Completado" then
                            PackCompleto := false
                    until (RWhseActLine1.Next = 0) or (PackCompleto = false);

                WSH."Packing Completo" := PackCompleto;

                WSH."Cantidad de Bultos" := CantBultos;
                WSH.Modify;
            end;
        end;
    end;


    procedure ReabrirCajaPacking(LinPacking: Record "Lin. Packing")
    begin
        LinPacking."Estado Caja" := LinPacking."Estado Caja"::Abierta;
        LinPacking.Modify;
    end;


    procedure RegHojaEnv(CHR: Record "Cab. Hoja de Ruta"; Imprime: Boolean)
    var
        LHR: Record "Lin. Hoja de Ruta";
        CHRR: Record "Cab. Hoja de Ruta Reg.";
        LHRR: Record "Lin. Hoja de Ruta Reg.";
        NoSeriesMngm: Codeunit "No. Series";
        SRS: Record "Sales & Receivables Setup";
        LHRR2: Record "Lin. Hoja de Ruta Reg.";
    begin
        SRS.Get;
        SRS.TestField("No. Serie Hoja de Ruta Reg.");
        //#51496:Inicio
        CHR.TestField("Cantidad de cajas");
        //#51496:Fin
        CHRR.Init;
        CHRR.TransferFields(CHR);
        CHRR."No. Hoja Ruta" := NoSeriesMngm.GetNextNo(SRS."No. Serie Hoja de Ruta Reg.", WorkDate, true);
        CHRR.Hora := Time;
        CHRR."Fecha Registro" := WorkDate;
        CHRR.Insert;

        LHR.Reset;
        LHR.SetRange(LHR."No. Hoja Ruta", CHR."No. Hoja Ruta");
        if LHR.FindSet then
            repeat
                LHRR.Init;
                LHRR.TransferFields(LHR);
                LHRR."No. Hoja Ruta" := CHRR."No. Hoja Ruta";
                LHRR."Ship-to City" := LHR."Ship-to City";//003+-
                LHRR.Insert;
            until LHR.Next = 0;
        CHR.Delete(true);

        if Imprime then begin
            CHRR.Get(CHRR."No. Hoja Ruta");
            CHRR.SetRecFilter;
            REPORT.Run(56024, false, false, CHRR);
        end;
    end;


    procedure Etiqueta(RTC: Boolean; Comando: Text[1024])
    var
        // wSHShell: Automation;
        _commandLine: Text[100];
        _runModally: Boolean;
        dummyInt: Integer;
    begin
        //CommandProcessor := FORMAT(ToFile);
        Message(Comando);
        // wSHShell.Run(Comando, dummyInt, _runModally);
        // Clear(wSHShell);
    end;


    procedure PrepedidoAPedidoTrans(TH: Record "Transfer Header")
    var
        Seq: Integer;
    begin
        TH.TestField("Pre pedido");
        ConfSantillana.Get;

        ValidaReq.Maestros(5740, TH."No.");
        ValidaReq.Dimensiones(5740, TH."No.", 0, 0);

        //Crear Cabecera(s)
        //Pasar dimensiones
        //CrearLineas
        //Pasar lineas
    end;


    procedure CrearCabTrans(PrePed: Record "Transfer Header")
    var
        CantLin: Integer;
        Seq: Integer;
        NoDoc: Code[20];
    begin
        Seq += 1;
        CantLin := 0;
        TransHeader.Status := TransHeader.Status::Open;
        NoDoc := TransHeader."No." + '-' + Format(Seq);
        Clear(TransHeader."Pre pedido");
        TransferLine.LockTable;
        TransHeader.Insert(true);
        //Aqui deben ir las dimensiones

        TransHeader."Dimension Set ID" := PrePed."Dimension Set ID";
        TransHeader.TransferFields(PrePed);
        TransHeader."No." := NoDoc;
        TransHeader.Modify;

        //Lineas
        TransferLine.Reset;
        TransferLine.SetRange("Document No.", PrePed."No.");
        if NoLin <> 0 then
            TransferLine.SetFilter("Line No.", '%1..', NoLin);

        //Aqui Dimensiones lineas
        if TransferLine.FindSet then
            repeat
                CantLin += 1;
                NoLin := TransferLine."Line No.";
                if CantLin > ConfSantillana."Cantidad Lin. por factura" then
                    exit;

                NewTransLine.Init;
                NewTransLine := TransferLine;
                NewTransLine."Document No." := NoDoc;
                NewTransLine.Insert;

            until TransferLine.Next = 0;
        TransHeader.CopyLinks(PrePed);
        //Lineas de comentarios
    end;


    procedure BuscaCtes(Cte: Record Customer): Integer
    var
        ListaCte: Record Customer;
    begin
        if Cte."Primary Contact No." <> '' then begin
            ListaCte.Reset;
            ListaCte.SetCurrentKey("Primary Contact No.");
            ListaCte.SetRange("Primary Contact No.", Cte."Primary Contact No.");
        end;
        exit(ListaCte.Count);
    end;


    procedure MuestraCtes(Cte: Record Customer)
    var
        ListaCtes: Record Customer;
        frmListaCtes: Page "Customer List";
    begin
        ListaCtes.Reset;
        ListaCtes.SetCurrentKey("Primary Contact No.");
        ListaCtes.SetRange("Primary Contact No.", Cte."Primary Contact No.");

        frmListaCtes.SetTableView(ListaCtes);
        frmListaCtes.RunModal;
        Clear(frmListaCtes);
    end;


    procedure InvConsTransf(CodCliente: Code[20])
    var
        NoRecepcion: Code[20];
        CFuncSantillana: Codeunit "Funciones Santillana";
        NoPedidoActual: Code[20];
        SalesHeader: Record "Sales Header";
        TransferLines: Record "Transfer Line";
        TransHeader1: Record "Transfer Header";
        TransferLine1: Record "Transfer Line";
        TransRecHeader: Record "Transfer Receipt Header";
        TransRecLines: Record "Transfer Receipt Line";
        TransRecHeader1: Record "Transfer Receipt Header";
        TransRecLines1: Record "Transfer Receipt Line";
        NoLinea: Integer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        rLinCons: Record "Lin. Consig. Dev.Transfer Line";
        rLinCons1: Record "Lin. Consig. Dev.Transfer Line";
        rLinCons2: Record "Lin. Consig. Dev.Transfer Line";
        PagConsig: Page "Consignacion a Facturar";
    begin

        NoPedidoActual := CFuncSantillana.EnviaNoTransferencia;
        rLinCons.Reset;
        rLinCons.SetRange("Document No.", NoPedidoActual);
        rLinCons.SetRange("ID Usuario", UserId);
        rLinCons.DeleteAll;

        Counter := 0;
        CounterTotal := 0;

        Window.Open(Text001);

        TransHeader1.Get(NoPedidoActual);

        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetCurrentKey("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
        ItemLedgerEntry.SetRange(Open, true);
        ItemLedgerEntry.SetRange("Location Code", CodCliente);
        if ItemLedgerEntry.FindFirst then begin
            CounterTotal := ItemLedgerEntry.Count;
            repeat
                Counter := Counter + 1;
                Window.Update(1, ItemLedgerEntry."Document No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                rLinCons2.Reset;
                rLinCons2.SetRange(rLinCons2."Document No.", NoPedidoActual);
                rLinCons2.SetRange(rLinCons2."Item No.", ItemLedgerEntry."Item No.");
                rLinCons2.SetRange(rLinCons2."ID Usuario", UserId);
                if rLinCons2.FindFirst then begin
                    rLinCons2.Quantity += ItemLedgerEntry."Remaining Quantity";
                    rLinCons2.Modify;
                end
                else begin
                    if ItemLedgerEntry."Remaining Quantity" <> 0 then begin
                        rLinCons1.Reset;
                        rLinCons1.SetRange("Document No.", NoPedidoActual);
                        if rLinCons1.FindLast then
                            NoLinea := rLinCons1."Line No."
                        else
                            NoLinea := 0;

                        NoLinea += 10000;
                        rLinCons.Init;
                        rLinCons.Validate("Document No.", NoPedidoActual);
                        rLinCons.Validate("Line No.", NoLinea);
                        rLinCons.Validate("Item No.", ItemLedgerEntry."Item No.");
                        rLinCons.Validate(Quantity, ItemLedgerEntry."Remaining Quantity");
                        rLinCons.Validate("Unit of Measure Code", ItemLedgerEntry."Unit of Measure Code");
                        rLinCons.Validate(Quantity, ItemLedgerEntry."Remaining Quantity");
                        rLinCons.Validate("Qty. to Ship", 0);
                        rLinCons.Validate("ID Usuario", UserId);
                        rItem.Get(ItemLedgerEntry."Item No.");
                        rLinCons.Validate(Description, rItem.Description);
                        //rLinCons."Precio Venta Consignacion" := CalcrPrecio(ItemLedgerEntry."Item No.",
                        //          TransHeader1."Transfer-from Code",ItemLedgerEntry."Unit of Measure Code",TransHeader1."Posting Date");
                        //rLinCons."Descuento % Consignacion"  :=CalcDesc(ItemLedgerEntry."Item No.",
                        //          TransHeader1."Transfer-from Code",ItemLedgerEntry."Unit of Measure Code",TransHeader1."Posting Date");
                        //rLinCons.VALIDATE(Quantity,ItemLedgerEntry."Remaining Quantity");
                        rLinCons.Insert(true);
                    end;
                end;
            until ItemLedgerEntry.Next = 0;
        end;

        Window.Close;

        Commit;

        Clear(PagConsig);
        rLinCons.Reset;
        rLinCons.SetRange("Document No.", NoPedidoActual);
        rLinCons.SetRange("ID Usuario", UserId);
        PagConsig.SetTableView(rLinCons);
        PagConsig.RecibeNoPedido(NoPedidoActual);
        PagConsig.Run;
        Clear(PagConsig);
    end;

    local procedure ColocarSerieNcfNrcPOS()
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SCrM: Record "Sales Cr.Memo Header";
        CantidadModificados: Integer;
    begin
        //005+
        CantidadModificados := 0;
        SalesCrMemoHeader.Reset;
        SalesCrMemoHeader.SetRange("Venta TPV", true);
        SalesCrMemoHeader.SetRange("No. Serie NCF Abonos", '');
        SalesCrMemoHeader.SetFilter("No. Serie NCF Abonos2", '<>%1', '');
        SalesCrMemoHeader.SetFilter("Posting Date", '>=%1&<=%2', 20231201D, 20231231D);
        SalesCrMemoHeader.SetFilter("No. Documento SIC", '<>%1', '');
        if SalesCrMemoHeader.FindSet then
            repeat
                SCrM.Reset;
                SCrM.SetRange("No.", SalesCrMemoHeader."No.");
                if SCrM.FindFirst then begin
                    SCrM."No. Serie NCF Abonos" := SalesCrMemoHeader."No. Serie NCF Abonos2";
                    SCrM.Modify;
                    CantidadModificados += 1;
                end;
            until SalesCrMemoHeader.Next = 0;
        Message(Format(CantidadModificados));
        //005-
    end;
}

