report 56026 "Split Sales Item Charge"
{
    Caption = 'Split Sales Item Charge';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

            trigger OnPostDataItem()
            begin
                GenLedgerSetUp.Get();
                Counter += 1;
                Clear(wImporteAsignar);

                ICASales.Reset;
                ICASales.SetRange("Document Type", "Document Type");
                ICASales.SetRange("Document No.", "Document No.");
                ICASales.SetRange("Item Charge No.", "No.");
                if not ICASales.FindFirst then
                    Error(Err001, "No.", FieldCaption("Document Type"), "No.");

                ICASales.Reset;
                ICASales.SetRange("Document Type", "Document Type");
                ICASales.SetRange("Document No.", "Document No.");
                ICASales.SetRange("Item Charge No.", "No.");
                ICASales.SetRange("Amount to Assign", 0);
                if ICASales.FindFirst then
                    Error(Err002, "No.", FieldCaption("Document Type"), "No.");


                case ICASales."Applies-to Doc. Type" of
                    ICASales."Applies-to Doc. Type"::Quote: //quote
                        begin
                        end;
                    ICASales."Applies-to Doc. Type"::Order: //Order
                        begin
                            SalesLine2.Reset;
                            SalesLine2.SetRange("Document Type", "Document Type");
                            SalesLine2.SetRange("Document No.", "Document No.");
                            SalesLine2.SetRange(Type, Type);
                            SalesLine2.SetRange("No.", "No.");
                            SalesLine2.FindFirst;

                            ICASales.Reset;
                            ICASales.SetRange("Document Type", "Document Type");
                            ICASales.SetRange("Document No.", "Document No.");
                            ICASales.SetRange("Item Charge No.", "No.");
                            if ICASales.Find('-') then begin
                                repeat
                                    NoLin += 100;
                                    Window.Update(1, ICASales."Item No.");
                                    SalesLine.TransferFields(SalesLine2);
                                    SalesLine."Line No." := NoLin;
                                    SalesLine.Validate("No.");
                                    SalesLine.Validate(Quantity, 1);
                                    SalesLine.Validate("Qty. to Ship", 1);

                                    ItemCharge.Get(ICASales."Item Charge No.");
                                    if SalesHeader."Prices Including VAT" then
                                        SalesLine.Validate("Unit Price", Round(ICASales."Amount to Assign" * (1 + "VAT %" / 100),
                                         GenLedgerSetUp."Amount Rounding Precision"))
                                    else
                                        SalesLine.Validate("Unit Price", ICASales."Amount to Assign");

                                    SalesLine.Insert(true);

                                    AssignDimension;

                                    ICASales2.TransferFields(ICASales);
                                    ICASales2."Document Line No." := NoLin;
                                    ICASales2."Qty. to Assign" := 1;
                                    //AMS calcular el selectivo especifco o Advalorem
                                    if wImporteAsignar <> 0 then
                                        ICASales2."Amount to Assign" := wImporteAsignar
                                    else
                                        ICASales2."Amount to Assign" := ICASales2."Amount to Assign";

                                    if ICASales2."Qty. to Assign" <> 0 then
                                        ICASales2.Insert(true);

                                until ICASales.Next = 0;

                                ICASales.Reset;
                                ICASales.SetRange("Document Type", "Document Type");
                                ICASales.SetRange("Document No.", "Document No.");
                                ICASales.SetRange("Item Charge No.", "No.");
                                if ICASales.Find('-') then
                                    repeat
                                        ICASales3.Get(ICASales."Document Type", ICASales."Document No.", ICASales."Document Line No.",
                                                         ICASales."Line No.");
                                        ICASales3.Delete;
                                    until ICASales.Next = 0;

                                ICASales2.FindSet;
                                repeat
                                    ICASales.Copy(ICASales2);
                                    ICASales.Insert(true);
                                until ICASales2.Next = 0;

                                SalesLine3.Copy("Sales Line");
                                SalesLine3.Delete(true);
                            end;

                        end;
                    ICASales."Applies-to Doc. Type"::Invoice: //Invoice
                        begin
                            SalesLine2.Reset;
                            SalesLine2.SetRange("Document Type", "Document Type");
                            SalesLine2.SetRange("Document No.", "Document No.");
                            SalesLine2.SetRange(Type, Type);
                            SalesLine2.SetRange("No.", "No.");
                            SalesLine2.FindFirst;

                            ICASales.Reset;
                            ICASales.SetRange("Document Type", "Document Type");
                            ICASales.SetRange("Document No.", "Document No.");
                            ICASales.SetRange("Item Charge No.", "No.");
                            if ICASales.FindSet then begin
                                repeat
                                    NoLin += 100;
                                    Window.Update(1, ICASales."Item No.");
                                    SalesLine.TransferFields(SalesLine2);
                                    SalesLine."Line No." := NoLin;
                                    SalesLine.Validate("No.");
                                    SalesLine.Validate(Quantity, 1);
                                    SalesLine.Validate("Qty. to Ship", 1);

                                    ItemCharge.Get(ICASales."Item Charge No.");

                                    if SalesHeader."Prices Including VAT" then
                                        SalesLine.Validate("Unit Price", Round(ICASales."Amount to Assign" * (1 + "VAT %" / 100),
                                         GenLedgerSetUp."Amount Rounding Precision"))
                                    else
                                        SalesLine.Validate("Unit Price", ICASales."Amount to Assign");

                                    SalesLine.Insert(true);

                                    AssignDimension;

                                    ICASales2.TransferFields(ICASales);
                                    ICASales2."Document Line No." := NoLin;
                                    ICASales2."Qty. to Assign" := 1;
                                    //AMS calcular el selectivo especifco o Advalorem
                                    if wImporteAsignar <> 0 then
                                        ICASales2."Amount to Assign" := wImporteAsignar
                                    else
                                        ICASales2."Amount to Assign" := ICASales2."Amount to Assign";

                                    ICASales2.Insert(true);

                                until ICASales.Next = 0;

                                ICASales.Reset;
                                ICASales.SetRange("Document Type", "Document Type");
                                ICASales.SetRange("Document No.", "Document No.");
                                ICASales.SetRange("Item Charge No.", "No.");
                                if ICASales.Find('-') then
                                    repeat
                                        ICASales3.Get(ICASales."Document Type", ICASales."Document No.", ICASales."Document Line No.",
                                                         ICASales."Line No.");
                                        ICASales3.Delete;
                                    until ICASales.Next = 0;

                                ICASales2.FindSet;
                                repeat
                                    ICASales.Copy(ICASales2);
                                    ICASales.Insert(true);
                                until ICASales2.Next = 0;

                                SalesLine3.Copy("Sales Line");
                                SalesLine3.Delete(true);
                            end;
                        end;
                    ICASales."Applies-to Doc. Type"::"Credit Memo": //Credit Memo
                        begin
                            SalesLine2.Reset;
                            SalesLine2.SetRange("Document Type", "Document Type");
                            SalesLine2.SetRange("Document No.", "Document No.");
                            SalesLine2.SetRange(Type, Type);
                            SalesLine2.SetRange("No.", "No.");
                            SalesLine2.FindFirst;

                            ICASales.Reset;
                            ICASales.SetRange("Document Type", "Document Type");
                            ICASales.SetRange("Document No.", "Document No.");
                            ICASales.SetRange("Item Charge No.", "No.");
                            if ICASales.FindSet then begin
                                repeat
                                    NoLin += 100;
                                    Window.Update(1, ICASales."Item No.");
                                    SalesLine.TransferFields(SalesLine2);
                                    SalesLine."Line No." := NoLin;
                                    SalesLine.Validate("No.");
                                    SalesLine.Validate(Quantity, 1);
                                    SalesLine.Validate("Qty. to Ship", 1);

                                    ItemCharge.Get(ICASales."Item Charge No.");

                                    if SalesHeader."Prices Including VAT" then
                                        SalesLine.Validate("Unit Price", Round(ICASales."Amount to Assign" * (1 + "VAT %" / 100),
                                         GenLedgerSetUp."Amount Rounding Precision"))
                                    else
                                        SalesLine.Validate("Unit Price", ICASales."Amount to Assign");

                                    SalesLine.Insert(true);

                                    AssignDimension;

                                    ICASales2.TransferFields(ICASales);
                                    ICASales2."Document Line No." := NoLin;
                                    ICASales2."Qty. to Assign" := 1;
                                    //AMS calcular el selectivo especifco o Advalorem
                                    if wImporteAsignar <> 0 then
                                        ICASales2."Amount to Assign" := wImporteAsignar
                                    else
                                        ICASales2."Amount to Assign" := ICASales2."Amount to Assign";

                                    ICASales2.Insert(true);

                                until ICASales.Next = 0;

                                ICASales.Reset;
                                ICASales.SetRange("Document Type", "Document Type");
                                ICASales.SetRange("Document No.", "Document No.");
                                ICASales.SetRange("Item Charge No.", "No.");
                                if ICASales.Find('-') then
                                    repeat
                                        ICASales3.Get(ICASales."Document Type", ICASales."Document No.", ICASales."Document Line No.",
                                                         ICASales."Line No.");
                                        ICASales3.Delete;
                                    until ICASales.Next = 0;

                                ICASales2.FindSet;
                                repeat
                                    ICASales.Copy(ICASales2);
                                    ICASales.Insert(true);
                                until ICASales2.Next = 0;

                                SalesLine3.Copy("Sales Line");
                                SalesLine3.Delete(true);
                            end;
                        end;
                    ICASales."Applies-to Doc. Type"::"Blanket Order": //Blanket Order
                        begin
                        end;
                    ICASales."Applies-to Doc. Type"::"Return Order": //Return Order
                        begin
                        end;
                    ICASales."Applies-to Doc. Type"::Shipment: //Shipment
                        begin
                            SalesLine2.Reset;
                            SalesLine2.SetRange("Document Type", "Document Type");
                            SalesLine2.SetRange("Document No.", "Document No.");
                            SalesLine2.SetRange(Type, Type);
                            SalesLine2.SetRange("No.", "No.");
                            SalesLine2.FindFirst;

                            ICASales.Reset;
                            ICASales.SetRange("Document Type", "Document Type");
                            ICASales.SetRange("Document No.", "Document No.");
                            ICASales.SetRange("Item Charge No.", "No.");
                            if ICASales.Find('-') then begin
                                repeat
                                    NoLin += 100;
                                    Window.Update(1, ICASales."Item No.");
                                    SalesLine.TransferFields(SalesLine2);
                                    SalesLine."Line No." := NoLin;
                                    SalesLine.Validate("No.");
                                    SalesLine.Validate(Quantity, 1);
                                    SalesLine.Validate("Qty. to Ship", 1);

                                    ItemCharge.Get(ICASales."Item Charge No.");

                                    if SalesHeader."Prices Including VAT" then
                                        SalesLine.Validate("Unit Price", Round(ICASales."Amount to Assign" * (1 + "VAT %" / 100),
                                         GenLedgerSetUp."Amount Rounding Precision"))
                                    else
                                        SalesLine.Validate("Unit Price", ICASales."Amount to Assign");


                                    SalesLine.Insert(true);

                                    AssignDimension;

                                    ICASales2.TransferFields(ICASales);
                                    ICASales2."Document Line No." := NoLin;
                                    ICASales2."Qty. to Assign" := 1;
                                    //AMS calcular el selectivo especifco o Advalorem
                                    if wImporteAsignar <> 0 then
                                        ICASales2."Amount to Assign" := wImporteAsignar
                                    else
                                        ICASales2."Amount to Assign" := ICASales2."Amount to Assign";

                                    ICASales2.Insert(true);

                                until ICASales.Next = 0;

                                ICASales.Reset;
                                ICASales.SetRange("Document Type", "Document Type");
                                ICASales.SetRange("Document No.", "Document No.");
                                ICASales.SetRange("Item Charge No.", "No.");
                                if ICASales.Find('-') then
                                    repeat
                                        ICASales3.Get(ICASales."Document Type", ICASales."Document No.", ICASales."Document Line No.",
                                                         ICASales."Line No.");
                                        ICASales3.Delete;
                                    until ICASales.Next = 0;

                                ICASales2.Find('-');
                                repeat
                                    ICASales.Copy(ICASales2);
                                    ICASales.Insert(true);
                                until ICASales2.Next = 0;

                                SalesLine3.Copy("Sales Line");
                                SalesLine3.Delete(true);
                            end;


                        end;
                    ICASales."Applies-to Doc. Type"::"Transfer Receipt": //Transfer Receipt
                        begin
                            SalesLine2.Reset;
                            SalesLine2.SetRange("Document Type", "Document Type");
                            SalesLine2.SetRange("Document No.", "Document No.");
                            SalesLine2.SetRange(Type, Type);
                            SalesLine2.SetRange("No.", "No.");
                            SalesLine2.FindFirst;

                            ICASales.Reset;
                            ICASales.SetRange("Document Type", "Document Type");
                            ICASales.SetRange("Document No.", "Document No.");
                            ICASales.SetRange("Item Charge No.", "No.");
                            if ICASales.Find('-') then begin
                                repeat
                                    NoLin += 100;
                                    Window.Update(1, ICASales."Item No.");
                                    SalesLine.TransferFields(SalesLine2);
                                    SalesLine."Line No." := NoLin;
                                    SalesLine.Validate("No.");
                                    SalesLine.Validate(Quantity, 1);
                                    SalesLine.Validate("Qty. to Ship", 1);
                                    //AMS calcular el selectivo especifco o Advalorem
                                    ItemCharge.Get(ICASales."Item Charge No.");

                                    if SalesHeader."Prices Including VAT" then
                                        SalesLine.Validate("Unit Price", Round(ICASales."Amount to Assign" * (1 + "VAT %" / 100),
                                         GenLedgerSetUp."Amount Rounding Precision"))
                                    else
                                        SalesLine.Validate("Unit Price", ICASales."Amount to Assign");

                                    SalesLine.Insert(true);
                                    AssignDimension;
                                    ICASales2.TransferFields(ICASales);
                                    ICASales2."Document Line No." := NoLin;
                                    ICASales2."Qty. to Assign" := 1;
                                    //AMS calcular el selectivo especifco o Advalorem
                                    if wImporteAsignar <> 0 then
                                        ICASales2."Amount to Assign" := wImporteAsignar
                                    else
                                        ICASales2."Amount to Assign" := ICASales2."Amount to Assign";
                                    ICASales2.Insert(true);

                                until ICASales.Next = 0;

                                ICASales.Reset;
                                ICASales.SetRange("Document Type", "Document Type");
                                ICASales.SetRange("Document No.", "Document No.");
                                ICASales.SetRange("Item Charge No.", "No.");
                                if ICASales.Find('-') then
                                    repeat
                                        ICASales3.Get(ICASales."Document Type", ICASales."Document No.", ICASales."Document Line No.",
                                                         ICASales."Line No.");
                                        ICASales3.Delete;
                                    until ICASales.Next = 0;

                                ICASales2.Find('-');
                                repeat
                                    ICASales.Copy(ICASales2);
                                    ICASales.Insert(true);
                                until ICASales2.Next = 0;

                                SalesLine3.Copy("Sales Line");
                                SalesLine3.Delete(true);
                            end;

                        end;
                    ICASales."Applies-to Doc. Type"::"Return Shipment": //Return Shipment
                        begin
                        end;
                    ICASales."Applies-to Doc. Type"::"Sales Shipment": //Sales Shipment
                        begin
                        end;
                    ICASales."Applies-to Doc. Type"::"Return Receipt": //Return Receipt
                        begin
                        end;
                end;

                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
            end;

            trigger OnPreDataItem()
            begin
                SalesLine2.Reset;
                SalesLine2.SetFilter("Document Type", GetFilter("Document Type"));
                SalesLine2.SetFilter("Document No.", GetFilter("Document No."));
                SalesLine2.FindLast;
                NoLin := SalesLine2."Line No.";

                SalesHeader.Get(SalesLine2."Document Type", SalesLine2."Document No.");
                CounterTotal := Count;
                Window.Open(Text001);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ICA: Record "Item Charge Assignment (Sales)";
        ICASales: Record "Item Charge Assignment (Sales)";
        Text001: Label 'Processing  #1########## @2@@@@@@@@@@@@@';
        Err001: Label 'There is not assigment of Item Charge %1 for %2 %3';
        Err002: Label 'There are lines with zero amount in Item Charge %1 for %2 %3';
        ICASales2: Record "Item Charge Assignment (Sales)" temporary;
        ICASales3: Record "Item Charge Assignment (Sales)";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesLine2: Record "Sales Line";
        SalesLine3: Record "Sales Line";
        NoLin: Integer;
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        TipoDoc: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"Transfer Receipt","Return Shipment","Sales Shipment","Return Receipt";
        Item: Record Item;
        wImporteAsignar: Decimal;
        TransfShipLine: Record "Transfer Shipment Line";
        ItemCharge: Record "Item Charge";
        SalesShipment: Record "Sales Shipment Line";
        GenLedgerSetUp: Record "General Ledger Setup";
        SalesInvLine: Record "Sales Invoice Line";
        wCantTotalCajas: Decimal;
        wCantTotalLitros: Decimal;
        "wFlete/Cajas": Decimal;
        wLitroXFobTotal: Decimal;
        "wSeguro/LitroXFob": Decimal;
        wSeguro: Decimal;
        wFlete: Decimal;
        wLitroXFob: Decimal;
        wCif: Decimal;
        wFobUnit: Decimal;
        Cont: Boolean;
        wAcum: Decimal;
        QtyBase: Decimal;


    procedure AssignDimension()
    var
        T37: Record "Sales Line";
        T111: Record "Sales Shipment Line";
        T5745: Record "Transfer Shipment Line";
    begin
        case ICASales."Applies-to Doc. Type" of
            ICASales."Applies-to Doc. Type"::Quote: //quote
                begin
                end;
            ICASales."Applies-to Doc. Type"::Order: //Order
                begin
                    if T37.Get(T37."Document Type"::Order, ICASales."Applies-to Doc. No.", ICASales."Applies-to Doc. Line No.") then begin
                        SalesLine."Dimension Set ID" := T37."Dimension Set ID";
                        SalesLine.Modify;
                    end;
                end;
            ICASales."Applies-to Doc. Type"::Invoice: //Invoice
                begin
                    if T37.Get(T37."Document Type"::Invoice, ICASales."Applies-to Doc. No.", ICASales."Applies-to Doc. Line No.") then begin
                        SalesLine."Dimension Set ID" := T37."Dimension Set ID";
                        SalesLine.Modify;
                    end;
                end;
            ICASales."Applies-to Doc. Type"::"Credit Memo": //Credit Memo
                begin
                    if T37.Get(T37."Document Type"::"Credit Memo", ICASales."Applies-to Doc. No.", ICASales."Applies-to Doc. Line No.") then begin
                        SalesLine."Dimension Set ID" := T37."Dimension Set ID";
                        SalesLine.Modify;
                    end;
                end;
            ICASales."Applies-to Doc. Type"::"Blanket Order": //Blanket Order
                begin
                end;
            ICASales."Applies-to Doc. Type"::"Return Order": //Return Order
                begin
                end;
            ICASales."Applies-to Doc. Type"::"Receipt": //Receipt
                begin
                    if T111.Get(ICASales."Applies-to Doc. No.", ICASales."Applies-to Doc. Line No.") then begin
                        SalesLine."Dimension Set ID" := T111."Dimension Set ID";
                        SalesLine.Modify;
                    end;
                end;
            ICASales."Applies-to Doc. Type"::"Transfer Receipt": //Transfer Receipt
                begin
                    if T5745.Get(ICASales."Applies-to Doc. No.", ICASales."Applies-to Doc. Line No.") then begin
                        SalesLine."Dimension Set ID" := T5745."Dimension Set ID";
                        SalesLine.Modify;
                    end;
                end;
            ICASales."Applies-to Doc. Type"::"Return Shipment": //Return Shipment
                begin
                end;
            ICASales."Applies-to Doc. Type"::"Sales Shipment": //Sales Shipment
                begin
                end;
            ICASales."Applies-to Doc. Type"::"Return Receipt": //Return Receipt
                begin
                end;
        end;
    end;


    procedure CalculaArancel()
    var
        wCostoFobLitros: Decimal;
    begin
        /*
        //AMS calcular el selectivo especifco o Advalorem
        rItem.GET(ICASales."Item No.");
        rItem.TESTFIELD("Unit Volume");
        //GRN rItem.TESTFIELD("Cod. Procedencia");
        //GRN rDiageoSetUp.TESTFIELD("Netas periodo acumulado");
        
        wLitroXFob          := 0;
        "wFlete/Cajas"      := 0;
        "wSeguro/LitroXFob" := 0;
        wCif                := 0;
        wFlete              := 0;
        wFobUnit            := 0;
        
        rPurchHeader.GET(SalesLine."Document Type",SalesLine."Document No.");
        //rPurchHeader.TESTFIELD("No. Fact. Liquidacion");
        //rPurchHeader.TESTFIELD("Tasa liquidacion");
        
        
        //Buscamos Cantidad total de la factura que se esta liquidando
        rPurchInvLine.RESET;
        rPurchInvLine.SETCURRENTKEY("Document No.",Type);
        //rPurchInvLine.SETRANGE(rPurchInvLine."Document No.",rPurchHeader."No. Fact. Liquidacion");
        rPurchInvLine.SETRANGE(rPurchInvLine.Type,rPurchInvLine.Type::Item);
        IF rPurchInvLine.FIND('-') THEN
           BEGIN
            IF NOT Cont THEN
               BEGIN
                wCantTotalCajas     := 0;
                wCantTotalLitros    := 0;
                REPEAT
                 rItem.GET(rPurchInvLine."No.");
                 Cont := TRUE;
                 wCantTotalCajas  +=  rPurchInvLine.Quantity;
        //GRN         wCantTotalLitros += (rPurchInvLine.Quantity * rItem2."Unit Volume");
                 //Llevamos el costo Fob a Litros
        //GRN         wCostoFobLitros :=  (rItem2."Cod. Procedencia" * 1.30)/rItem2."Unit Volume";
                 //wAcum := ((rPurchInvLine.Quantity * rItem2."Unit Volume") * rItem2."Costo FOB");
        //GRN         wAcum := ((rPurchInvLine.Quantity * rItem2."Unit Volume") * wCostoFobLitros);
                 //wLitroXFobTotal  += ((rPurchInvLine.Quantity * rItem2."Unit Volume") * rItem2."Costo FOB");
        //GRN         wLitroXFobTotal  += ((rPurchInvLine.Quantity * rItem2."Unit Volume") * wCostoFobLitros);
                UNTIL rPurchInvLine.NEXT = 0;
               END;
        
        //GRN    "wSeguro/LitroXFob"  := rPurchHeader."Importe Seguro"/wLitroXFobTotal;
        //GRN    "wFlete/Cajas"       := rPurchHeader."Importe Flete"/wCantTotalCajas;
        
            //Buscamos Cantidad de la linea de factura que se esta liquidando
            rPurchInvLine.RESET;
        //GRN    rPurchInvLine.SETRANGE("Document No.",rPurchHeader."No. Fact. Liquidacion");
            rPurchInvLine.SETRANGE(Type,rPurchInvLine.Type::Item);
            rPurchInvLine.SETRANGE("No.",ICASales."Item No.");
            IF rPurchInvLine.FINDFIRST THEN
               BEGIN
                rItem.GET(ICASales."Item No.");
        //GRN        wFobUnit   := rItem."costo FOB";
        //GRN        wCostoFobLitros :=  ( rItem."Cod. Procedencia" * 1.30)/rItem."Unit Volume";
                //wLitroXFob := ((rPurchInvLine.Quantity * rItem."Unit Volume") * wFobUnit);
        //GRN        wLitroXFob := ((rPurchInvLine.Quantity * rItem."Unit Volume") * wCostoFobLitros);
        //GRN        wSeguro    := rPurchHeader."Importe Seguro"/ wLitroXFobTotal * wLitroXFob;
        //GRN        wFlete     := rPurchHeader."Importe Flete" / wLitroXFobTotal * wLitroXFob;
        //GRN        wCif       := (wLitroXFob + wSeguro + wFlete) * rPurchHeader."Tasa liquidacion";
        
                wImporteAsignar := wCif;
        //GRN        wImporteAsignar := wImporteAsignar * (rDiageoSetUp."Netas periodo acumulado"/100);
                SalesLine.VALIDATE("unit price",wImporteAsignar);
               END;
           END;
        
        
        */

    end;


    procedure CalculaSelectivoA()
    begin
        /*
        //Calcular el selectivo especifco o Advalorem
        rPurchReceipt.RESET;
        rPurchReceipt.GET(ICASales."Applies-to Doc. No.",ICASales."Applies-to Doc. Line No.");
        rItem.GET(ICASales."Item No.");
        rItem.TESTFIELD("Monto Selectivo Advalorem");
        wImporteAsignar := rItem."Monto Selectivo Advalorem" * rPurchReceipt."Quantity (Base)";
        SalesLine.VALIDATE("unit price",wImporteAsignar);
        */

    end;


    procedure "CalculaSelectivoE(TRL)"()
    var
        rTransferRecLine: Record "Transfer Receipt Line";
    begin
        /*
        rTransferRecLine.GET(ICASales."Applies-to Doc. No.",ICASales."Applies-to Doc. Line No.");
        rItem.GET(ICASales."Item No.");
        wImporteAsignar := rItem."Selectivo Especifico" * rTransferRecLine."Quantity (Base)";
        SalesLine.VALIDATE("unit price",wImporteAsignar);
        */

    end;


    procedure "CalculaSelectivoE(RL)"()
    var
        rTransferRecLine: Record "Transfer Receipt Line";
    begin
        /*
        //Calcular el selectivo especifco o Advalorem
        rPurchReceipt.RESET;
        rPurchReceipt.GET(ICASales."Applies-to Doc. No.",ICASales."Applies-to Doc. Line No.");
        rItem.GET(ICASales."Item No.");
        wImporteAsignar := rItem."Selectivo Especifico" * rPurchReceipt."Quantity (Base)";
        SalesLine.VALIDATE("unit price",wImporteAsignar);
        */

    end;


    procedure "CalculaSelectivoA(TRL)"()
    var
        rTransferRecLine: Record "Transfer Receipt Line";
    begin
        /*
        //Calcular el selectivo especifco o Advalorem
        rTransferRecLine.GET(ICASales."Applies-to Doc. No.",ICASales."Applies-to Doc. Line No.");
        rItem.GET(ICASales."Item No.");
        rItem.TESTFIELD("Monto Selectivo Advalorem");
        wImporteAsignar := rItem."Monto Selectivo Advalorem" * rTransferRecLine."Quantity (Base)";
        SalesLine.VALIDATE("unit price",wImporteAsignar);
        */

    end;

    local procedure UpdateQty()
    var
        PurchLine: Record "Purchase Line";
        PurchLine2: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ReturnShptLine: Record "Return Shipment Line";
        TransferRcptLine: Record "Transfer Receipt Line";
        SalesShptLine: Record "Sales Shipment Line";
        ReturnRcptLine: Record "Return Receipt Line";
        AssignableQty: Decimal;
        TotalQtyToAssign: Decimal;
        RemQtyToAssign: Decimal;
        AssgntAmount: Decimal;
        TotalAmountToAssign: Decimal;
        RemAmountToAssign: Decimal;
        UnitCost: Decimal;
    begin
        /*
        QtyBase := 0;
        CASE ICA."Applies-to Doc. Type" OF
          ICA."Applies-to Doc. Type"::Order,ICA."Applies-to Doc. Type"::Invoice:
            BEGIN
              SalesLine.GET(ICA."Applies-to Doc. Type",ICA."Applies-to Doc. No.",ICA."Applies-to Doc. Line No.");
              QtyBase := SalesLine."Qty. Received (Base)";
            END;
          ICA."Applies-to Doc. Type"::"Return Order",ICA."Applies-to Doc. Type"::"Credit Memo":
            BEGIN
              SalesLine.GET(ICA."Applies-to Doc. Type",ICA."Applies-to Doc. No.",ICA."Applies-to Doc. Line No.");
              QtyBase := SalesLine."Return Qty. Shipped (Base)";
            END;
          ICA."Applies-to Doc. Type"::Receipt:
            BEGIN
              PurchRcptLine.GET(ICA."Applies-to Doc. No.",ICA."Applies-to Doc. Line No.");
              QtyBase := PurchRcptLine."Quantity (Base)";
            END;
          ICA."Applies-to Doc. Type"::"Return Shipment":
            BEGIN
              ReturnShptLine.GET(ICA."Applies-to Doc. No.",ICA."Applies-to Doc. Line No.");
              QtyBase := ReturnShptLine."Quantity (Base)";
            END;
          ICA."Applies-to Doc. Type"::"Transfer Receipt":
            BEGIN
              TransferRcptLine.GET(ICA."Applies-to Doc. No.",ICA."Applies-to Doc. Line No.");
              QtyBase := TransferRcptLine.Quantity;
            END;
          ICA."Applies-to Doc. Type"::"Sales Shipment":
            BEGIN
              SalesShptLine.GET(ICA."Applies-to Doc. No.",ICA."Applies-to Doc. Line No.");
              QtyBase := SalesShptLine."Quantity (Base)";
            END;
          ICA."Applies-to Doc. Type"::"Return Receipt":
            BEGIN
              ReturnRcptLine.GET(ICA."Applies-to Doc. No.",ICA."Applies-to Doc. Line No.");
              QtyBase := ReturnRcptLine."Quantity (Base)";
            END;
        END;
        */

    end;
}

