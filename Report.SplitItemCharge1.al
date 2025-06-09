report 76042 "Split Item Charge 1"
{
    Caption = 'Split Item Charge';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purchase Line"; "Purchase Line")
        {
            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

            trigger OnPostDataItem()
            begin
                rGenLedgerSetUp.Get();
                Counter += 1;
                Clear(wImporteAsignar);

                ICAPurchase.Reset;
                ICAPurchase.SetRange("Document Type", "Document Type");
                ICAPurchase.SetRange("Document No.", "Document No.");
                ICAPurchase.SetRange("Item Charge No.", "No.");
                if not ICAPurchase.FindFirst then
                    Error(Err001, "No.", FieldCaption("Document Type"), "No.");

                ICAPurchase.Reset;
                ICAPurchase.SetRange("Document Type", "Document Type");
                ICAPurchase.SetRange("Document No.", "Document No.");
                ICAPurchase.SetRange("Item Charge No.", "No.");
                ICAPurchase.SetRange("Amount to Assign", 0);
                if ICAPurchase.FindFirst then
                    Error(Err002, "No.", FieldCaption("Document Type"), "No.");


                case ICAPurchase."Applies-to Doc. Type" of
                    ICAPurchase."Applies-to Doc. Type"::Quote: //quote
                        begin
                        end;
                    ICAPurchase."Applies-to Doc. Type"::Order: //Order
                        begin
                            PurchLine2.Reset;
                            PurchLine2.SetRange("Document Type", "Document Type");
                            PurchLine2.SetRange("Document No.", "Document No.");
                            PurchLine2.SetRange(Type, Type);
                            PurchLine2.SetRange("No.", "No.");
                            PurchLine2.FindFirst;

                            ICAPurchase.Reset;
                            ICAPurchase.SetRange("Document Type", "Document Type");
                            ICAPurchase.SetRange("Document No.", "Document No.");
                            ICAPurchase.SetRange("Item Charge No.", "No.");
                            //AMS Causaba error si se repetia el mismo codigo de cargo en las lineas
                            ICAPurchase.SetRange("Document Line No.", "Line No.");
                            //AMS
                            if ICAPurchase.Find('-') then begin
                                repeat
                                    NoLin += 100;
                                    Window.Update(1, ICAPurchase."Item No.");
                                    PurchLine.TransferFields(PurchLine2);
                                    PurchLine."Line No." := NoLin;
                                    PurchLine.Validate("No.");
                                    PurchLine.Validate(Quantity, 1);

                                    rItemCharge.Get(ICAPurchase."Item Charge No.");
                                    if PuchHeader."Prices Including VAT" then
                                        PurchLine.Validate("Direct Unit Cost", Round(ICAPurchase."Amount to Assign" * (1 + "VAT %" / 100),
                                         rGenLedgerSetUp."Amount Rounding Precision"))
                                    else
                                        PurchLine.Validate("Direct Unit Cost", ICAPurchase."Amount to Assign");

                                    PurchLine.Insert(true);

                                    AssignDimension;

                                    ICAPurchase2.TransferFields(ICAPurchase);
                                    ICAPurchase2."Document Line No." := NoLin;
                                    ICAPurchase2."Qty. to Assign" := 1;
                                    //AMS calcular el selectivo especifco o Advalorem
                                    if wImporteAsignar <> 0 then
                                        ICAPurchase2."Amount to Assign" := wImporteAsignar
                                    else
                                        ICAPurchase2."Amount to Assign" := ICAPurchase2."Amount to Assign";

                                    ICAPurchase2.Insert(true);

                                until ICAPurchase.Next = 0;

                                ICAPurchase.Reset;
                                ICAPurchase.SetRange("Document Type", "Document Type");
                                ICAPurchase.SetRange("Document No.", "Document No.");
                                ICAPurchase.SetRange("Item Charge No.", "No.");
                                //AMS Causaba error si se repetia el mismo codigo de cargo en las lineas
                                ICAPurchase.SetRange("Document Line No.", "Line No.");
                                //AMS

                                if ICAPurchase.Find('-') then
                                    repeat
                                        ICAPurchase3.Get(ICAPurchase."Document Type", ICAPurchase."Document No.", ICAPurchase."Document Line No.",
                                                         ICAPurchase."Line No.");
                                        ICAPurchase3.Delete;
                                    until ICAPurchase.Next = 0;

                                ICAPurchase2.FindSet;
                                repeat
                                    ICAPurchase.Copy(ICAPurchase2);
                                    ICAPurchase.Insert(true);
                                until ICAPurchase2.Next = 0;

                                PurchLine3.Copy("Purchase Line");
                                PurchLine3.Delete(true);
                            end;

                        end;
                    ICAPurchase."Applies-to Doc. Type"::Invoice: //Invoice
                        begin
                            PurchLine2.Reset;
                            PurchLine2.SetRange("Document Type", "Document Type");
                            PurchLine2.SetRange("Document No.", "Document No.");
                            PurchLine2.SetRange(Type, Type);
                            PurchLine2.SetRange("No.", "No.");
                            PurchLine2.FindFirst;

                            ICAPurchase.Reset;
                            ICAPurchase.SetRange("Document Type", "Document Type");
                            ICAPurchase.SetRange("Document No.", "Document No.");
                            ICAPurchase.SetRange("Item Charge No.", "No.");
                            //AMS Causaba error si se repetia el mismo codigo de cargo en las lineas
                            ICAPurchase.SetRange("Document Line No.", "Line No.");
                            //AMS

                            if ICAPurchase.FindSet then begin
                                repeat
                                    NoLin += 100;
                                    Window.Update(1, ICAPurchase."Item No.");
                                    PurchLine.TransferFields(PurchLine2);
                                    PurchLine."Line No." := NoLin;
                                    PurchLine.Validate("No.");
                                    PurchLine.Validate(Quantity, 1);

                                    rItemCharge.Get(ICAPurchase."Item Charge No.");

                                    if PuchHeader."Prices Including VAT" then
                                        PurchLine.Validate("Direct Unit Cost", Round(ICAPurchase."Amount to Assign" * (1 + "VAT %" / 100),
                                         rGenLedgerSetUp."Amount Rounding Precision"))
                                    else
                                        PurchLine.Validate("Direct Unit Cost", ICAPurchase."Amount to Assign");

                                    PurchLine.Insert(true);

                                    AssignDimension;

                                    ICAPurchase2.TransferFields(ICAPurchase);
                                    ICAPurchase2."Document Line No." := NoLin;
                                    ICAPurchase2."Qty. to Assign" := 1;
                                    //AMS calcular el selectivo especifco o Advalorem
                                    if wImporteAsignar <> 0 then
                                        ICAPurchase2."Amount to Assign" := wImporteAsignar
                                    else
                                        ICAPurchase2."Amount to Assign" := ICAPurchase2."Amount to Assign";

                                    ICAPurchase2.Insert(true);

                                until ICAPurchase.Next = 0;

                                ICAPurchase.Reset;
                                ICAPurchase.SetRange("Document Type", "Document Type");
                                ICAPurchase.SetRange("Document No.", "Document No.");
                                ICAPurchase.SetRange("Item Charge No.", "No.");
                                //AMS Causaba error si se repetia el mismo codigo de cargo en las lineas
                                ICAPurchase.SetRange("Document Line No.", "Line No.");
                                //AMS

                                if ICAPurchase.Find('-') then
                                    repeat
                                        ICAPurchase3.Get(ICAPurchase."Document Type", ICAPurchase."Document No.", ICAPurchase."Document Line No.",
                                                         ICAPurchase."Line No.");
                                        ICAPurchase3.Delete;
                                    until ICAPurchase.Next = 0;

                                ICAPurchase2.FindSet;
                                repeat
                                    ICAPurchase.Copy(ICAPurchase2);
                                    ICAPurchase.Insert(true);
                                until ICAPurchase2.Next = 0;

                                PurchLine3.Copy("Purchase Line");
                                PurchLine3.Delete(true);
                            end;
                        end;
                    ICAPurchase."Applies-to Doc. Type"::"Credit Memo": //Credit Memo
                        begin
                            PurchLine2.Reset;
                            PurchLine2.SetRange("Document Type", "Document Type");
                            PurchLine2.SetRange("Document No.", "Document No.");
                            PurchLine2.SetRange(Type, Type);
                            PurchLine2.SetRange("No.", "No.");
                            PurchLine2.FindFirst;

                            ICAPurchase.Reset;
                            ICAPurchase.SetRange("Document Type", "Document Type");
                            ICAPurchase.SetRange("Document No.", "Document No.");
                            ICAPurchase.SetRange("Item Charge No.", "No.");
                            //AMS Causaba error si se repetia el mismo codigo de cargo en las lineas
                            ICAPurchase.SetRange("Document Line No.", "Line No.");
                            //AMS

                            if ICAPurchase.Find('-') then begin
                                repeat
                                    NoLin += 100;
                                    Window.Update(1, ICAPurchase."Item No.");
                                    PurchLine.TransferFields(PurchLine2);
                                    PurchLine."Line No." := NoLin;
                                    PurchLine.Validate("No.");
                                    PurchLine.Validate(Quantity, 1);

                                    //AMS calcular el selectivo especifco o Advalorem
                                    rItemCharge.Get(ICAPurchase."Item Charge No.");

                                    if PuchHeader."Prices Including VAT" then
                                        PurchLine.Validate("Direct Unit Cost", Round(ICAPurchase."Amount to Assign" * (1 + "VAT %" / 100),
                                         rGenLedgerSetUp."Amount Rounding Precision"))
                                    else
                                        PurchLine.Validate("Direct Unit Cost", ICAPurchase."Amount to Assign");

                                    PurchLine.Insert(true);

                                    AssignDimension;

                                    ICAPurchase2.TransferFields(ICAPurchase);
                                    ICAPurchase2."Document Line No." := NoLin;
                                    ICAPurchase2."Qty. to Assign" := 1;
                                    //AMS calcular el selectivo especifco o Advalorem
                                    if wImporteAsignar <> 0 then
                                        ICAPurchase2."Amount to Assign" := wImporteAsignar
                                    else
                                        ICAPurchase2."Amount to Assign" := ICAPurchase2."Amount to Assign";

                                    ICAPurchase2.Insert(true);

                                until ICAPurchase.Next = 0;

                                ICAPurchase.Reset;
                                ICAPurchase.SetRange("Document Type", "Document Type");
                                ICAPurchase.SetRange("Document No.", "Document No.");
                                ICAPurchase.SetRange("Item Charge No.", "No.");
                                //AMS Causaba error si se repetia el mismo codigo de cargo en las lineas
                                ICAPurchase.SetRange("Document Line No.", "Line No.");
                                //AMS

                                if ICAPurchase.Find('-') then
                                    repeat
                                        ICAPurchase3.Get(ICAPurchase."Document Type", ICAPurchase."Document No.", ICAPurchase."Document Line No.",
                                                         ICAPurchase."Line No.");
                                        ICAPurchase3.Delete;
                                    until ICAPurchase.Next = 0;

                                ICAPurchase2.Find('-');
                                repeat
                                    ICAPurchase.Copy(ICAPurchase2);
                                    ICAPurchase.Insert(true);
                                until ICAPurchase2.Next = 0;

                                PurchLine3.Copy("Purchase Line");
                                PurchLine3.Delete(true);
                            end;

                        end;
                    ICAPurchase."Applies-to Doc. Type"::"Blanket Order": //Blanket Order
                        begin
                        end;
                    ICAPurchase."Applies-to Doc. Type"::"Return Order": //Return Order
                        begin
                        end;
                    ICAPurchase."Applies-to Doc. Type"::Receipt: //Receipt
                        begin
                            PurchLine2.Reset;
                            PurchLine2.SetRange("Document Type", "Document Type");
                            PurchLine2.SetRange("Document No.", "Document No.");
                            PurchLine2.SetRange(Type, Type);
                            PurchLine2.SetRange("No.", "No.");
                            PurchLine2.FindFirst;

                            ICAPurchase.Reset;
                            ICAPurchase.SetRange("Document Type", "Document Type");
                            ICAPurchase.SetRange("Document No.", "Document No.");
                            ICAPurchase.SetRange("Item Charge No.", "No.");
                            //AMS Causaba error si se repetia el mismo codigo de cargo en las lineas
                            ICAPurchase.SetRange("Document Line No.", "Line No.");
                            //AMS

                            if ICAPurchase.Find('-') then begin
                                repeat
                                    NoLin += 100;
                                    Window.Update(1, ICAPurchase."Item No.");
                                    PurchLine.TransferFields(PurchLine2);
                                    PurchLine."Line No." := NoLin;
                                    PurchLine.Validate("No.");
                                    PurchLine.Validate(Quantity, 1);

                                    rItemCharge.Get(ICAPurchase."Item Charge No.");

                                    if PuchHeader."Prices Including VAT" then
                                        PurchLine.Validate("Direct Unit Cost", Round(ICAPurchase."Amount to Assign" * (1 + "VAT %" / 100),
                                         rGenLedgerSetUp."Amount Rounding Precision"))
                                    else
                                        PurchLine.Validate("Direct Unit Cost", ICAPurchase."Amount to Assign");


                                    PurchLine.Insert(true);

                                    AssignDimension;

                                    ICAPurchase2.TransferFields(ICAPurchase);
                                    ICAPurchase2."Document Line No." := NoLin;
                                    ICAPurchase2."Qty. to Assign" := 1;
                                    //AMS calcular el selectivo especifco o Advalorem
                                    if wImporteAsignar <> 0 then
                                        ICAPurchase2."Amount to Assign" := wImporteAsignar
                                    else
                                        ICAPurchase2."Amount to Assign" := ICAPurchase2."Amount to Assign";

                                    ICAPurchase2.Insert(true);

                                until ICAPurchase.Next = 0;

                                ICAPurchase.Reset;
                                ICAPurchase.SetRange("Document Type", "Document Type");
                                ICAPurchase.SetRange("Document No.", "Document No.");
                                ICAPurchase.SetRange("Item Charge No.", "No.");
                                //AMS Causaba error si se repetia el mismo codigo de cargo en las lineas
                                ICAPurchase.SetRange("Document Line No.", "Line No.");
                                //AMS
                                if ICAPurchase.Find('-') then
                                    repeat
                                        ICAPurchase3.Get(ICAPurchase."Document Type", ICAPurchase."Document No.", ICAPurchase."Document Line No.",
                                                         ICAPurchase."Line No.");
                                        ICAPurchase3.Delete;
                                    until ICAPurchase.Next = 0;

                                ICAPurchase2.Find('-');
                                repeat
                                    ICAPurchase.Copy(ICAPurchase2);
                                    ICAPurchase.Insert(true);
                                until ICAPurchase2.Next = 0;

                                PurchLine3.Copy("Purchase Line");
                                PurchLine3.Delete(true);
                            end;


                        end;
                    ICAPurchase."Applies-to Doc. Type"::"Transfer Receipt": //Transfer Receipt
                        begin
                            PurchLine2.Reset;
                            PurchLine2.SetRange("Document Type", "Document Type");
                            PurchLine2.SetRange("Document No.", "Document No.");
                            PurchLine2.SetRange(Type, Type);
                            PurchLine2.SetRange("No.", "No.");
                            PurchLine2.FindFirst;

                            ICAPurchase.Reset;
                            ICAPurchase.SetRange("Document Type", "Document Type");
                            ICAPurchase.SetRange("Document No.", "Document No.");
                            ICAPurchase.SetRange("Item Charge No.", "No.");
                            //AMS Causaba error si se repetia el mismo codigo de cargo en las lineas
                            ICAPurchase.SetRange("Document Line No.", "Line No.");
                            //AMS
                            if ICAPurchase.Find('-') then begin
                                repeat
                                    NoLin += 100;
                                    Window.Update(1, ICAPurchase."Item No.");
                                    PurchLine.TransferFields(PurchLine2);
                                    PurchLine."Line No." := NoLin;
                                    PurchLine.Validate("No.");
                                    PurchLine.Validate(Quantity, 1);
                                    //AMS calcular el selectivo especifco o Advalorem
                                    rItemCharge.Get(ICAPurchase."Item Charge No.");

                                    if PuchHeader."Prices Including VAT" then
                                        PurchLine.Validate("Direct Unit Cost", Round(ICAPurchase."Amount to Assign" * (1 + "VAT %" / 100),
                                         rGenLedgerSetUp."Amount Rounding Precision"))
                                    else
                                        PurchLine.Validate("Direct Unit Cost", ICAPurchase."Amount to Assign");

                                    PurchLine.Insert(true);
                                    AssignDimension;
                                    ICAPurchase2.TransferFields(ICAPurchase);
                                    ICAPurchase2."Document Line No." := NoLin;
                                    ICAPurchase2."Qty. to Assign" := 1;
                                    //AMS calcular el selectivo especifco o Advalorem
                                    if wImporteAsignar <> 0 then
                                        ICAPurchase2."Amount to Assign" := wImporteAsignar
                                    else
                                        ICAPurchase2."Amount to Assign" := ICAPurchase2."Amount to Assign";
                                    ICAPurchase2.Insert(true);

                                until ICAPurchase.Next = 0;

                                ICAPurchase.Reset;
                                ICAPurchase.SetRange("Document Type", "Document Type");
                                ICAPurchase.SetRange("Document No.", "Document No.");
                                ICAPurchase.SetRange("Item Charge No.", "No.");
                                //AMS Causaba error si se repetia el mismo codigo de cargo en las lineas
                                ICAPurchase.SetRange("Document Line No.", "Line No.");
                                //AMS

                                if ICAPurchase.Find('-') then
                                    repeat
                                        ICAPurchase3.Get(ICAPurchase."Document Type", ICAPurchase."Document No.", ICAPurchase."Document Line No.",
                                                         ICAPurchase."Line No.");
                                        ICAPurchase3.Delete;
                                    until ICAPurchase.Next = 0;

                                ICAPurchase2.Find('-');
                                repeat
                                    ICAPurchase.Copy(ICAPurchase2);
                                    ICAPurchase.Insert(true);
                                until ICAPurchase2.Next = 0;

                                PurchLine3.Copy("Purchase Line");
                                PurchLine3.Delete(true);
                            end;

                        end;
                    ICAPurchase."Applies-to Doc. Type"::"Return Shipment": //Return Shipment
                        begin
                        end;
                    ICAPurchase."Applies-to Doc. Type"::"Sales Shipment": //Sales Shipment
                        begin
                        end;
                    ICAPurchase."Applies-to Doc. Type"::"Return Receipt": //Return Receipt
                        begin
                        end;
                end;
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
            end;

            trigger OnPreDataItem()
            begin
                PurchLine2.Reset;
                PurchLine2.SetFilter("Document Type", GetFilter("Document Type"));
                PurchLine2.SetFilter("Document No.", GetFilter("Document No."));
                PurchLine2.FindLast;
                NoLin := PurchLine2."Line No.";

                PuchHeader.Get(PurchLine2."Document Type", PurchLine2."Document No.");
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
        ICA: Record "Item Charge Assignment (Purch)";
        ICAPurchase: Record "Item Charge Assignment (Purch)";
        Text001: Label 'Processing  #1########## @2@@@@@@@@@@@@@';
        Err001: Label 'There is not assigment of Item Charge %1 for %2 %3';
        Err002: Label 'There are lines with zero amount in Item Charge %1 for %2 %3';
        ICAPurchase2: Record "Item Charge Assignment (Purch)" temporary;
        ICAPurchase3: Record "Item Charge Assignment (Purch)";
        PuchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchLine2: Record "Purchase Line";
        PurchLine3: Record "Purchase Line";
        NoLin: Integer;
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        TipoDoc: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"Transfer Receipt","Return Shipment","Sales Shipment","Return Receipt";
        rItem: Record Item;
        wImporteAsignar: Decimal;
        rTransfRecpLine: Record "Transfer Receipt Line";
        rItemCharge: Record "Item Charge";
        rPurchReceipt: Record "Purch. Rcpt. Line";
        rGenLedgerSetUp: Record "General Ledger Setup";
        rPurchInvLine: Record "Purch. Inv. Line";
        rPurchHeader: Record "Purchase Header";
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
        rItem2: Record Item;
        QtyBase: Decimal;


    procedure AssignDimension()
    var
        recLinCmpOrigen: Record "Purchase Line";
        recLinCmpDestino: Record "Purchase Line";
        recLinAlbOrigen: Record "Purch. Rcpt. Line";
        recLinTransfOrigen: Record "Transfer Receipt Line";
    begin
        case ICAPurchase."Applies-to Doc. Type" of
            ICAPurchase."Applies-to Doc. Type"::Quote: //quote
                begin
                end;
            ICAPurchase."Applies-to Doc. Type"::Order: //Order
                begin
                    recLinCmpOrigen.Get(ICAPurchase."Applies-to Doc. Type", ICAPurchase."Applies-to Doc. No.", ICAPurchase."Applies-to Doc. Line No.");
                    recLinCmpDestino.Get("Purchase Line"."Document Type", "Purchase Line"."Document No.", NoLin);
                    recLinCmpDestino."Dimension Set ID" := recLinCmpOrigen."Dimension Set ID";
                    recLinCmpDestino.Modify;
                end;
            ICAPurchase."Applies-to Doc. Type"::Invoice: //Invoice
                begin
                    recLinCmpOrigen.Get(ICAPurchase."Applies-to Doc. Type", ICAPurchase."Applies-to Doc. No.", ICAPurchase."Applies-to Doc. Line No.");
                    recLinCmpDestino.Get("Purchase Line"."Document Type", "Purchase Line"."Document No.", NoLin);
                    recLinCmpDestino."Dimension Set ID" := recLinCmpOrigen."Dimension Set ID";
                    recLinCmpDestino.Modify;
                end;
            ICAPurchase."Applies-to Doc. Type"::"Credit Memo": //Credit Memo
                begin
                end;
            ICAPurchase."Applies-to Doc. Type"::"Blanket Order": //Blanket Order
                begin
                end;
            ICAPurchase."Applies-to Doc. Type"::"Return Order": //Return Order
                begin
                end;
            ICAPurchase."Applies-to Doc. Type"::Receipt: //Receipt
                begin
                    recLinAlbOrigen.Get(ICAPurchase."Applies-to Doc. No.", ICAPurchase."Applies-to Doc. Line No.");
                    recLinCmpDestino.Get("Purchase Line"."Document Type", "Purchase Line"."Document No.", NoLin);
                    recLinCmpDestino."Dimension Set ID" := recLinAlbOrigen."Dimension Set ID";
                    recLinCmpDestino.Modify;
                end;
            ICAPurchase."Applies-to Doc. Type"::"Transfer Receipt": //Transfer Receipt
                begin
                    recLinTransfOrigen.Get(ICAPurchase."Applies-to Doc. No.", ICAPurchase."Applies-to Doc. Line No.");
                    recLinCmpDestino.Get("Purchase Line"."Document Type", "Purchase Line"."Document No.", NoLin);
                    recLinCmpDestino."Dimension Set ID" := recLinTransfOrigen."Dimension Set ID";
                    recLinCmpDestino.Modify;
                end;
            ICAPurchase."Applies-to Doc. Type"::"Return Shipment": //Return Shipment
                begin
                end;
            ICAPurchase."Applies-to Doc. Type"::"Sales Shipment": //Sales Shipment
                begin
                end;
            ICAPurchase."Applies-to Doc. Type"::"Return Receipt": //Return Receipt
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
        rItem.GET(ICAPurchase."Item No.");
        rItem.TESTFIELD("Unit Volume");
        //GRN rItem.TESTFIELD("Cod. Procedencia");
        //GRN rDiageoSetUp.TESTFIELD("Netas periodo acumulado");
        
        wLitroXFob          := 0;
        "wFlete/Cajas"      := 0;
        "wSeguro/LitroXFob" := 0;
        wCif                := 0;
        wFlete              := 0;
        wFobUnit            := 0;
        
        rPurchHeader.GET(PurchLine."Document Type",PurchLine."Document No.");
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
                 rItem2.GET(rPurchInvLine."No.");
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
            rPurchInvLine.SETRANGE("No.",ICAPurchase."Item No.");
            IF rPurchInvLine.FINDFIRST THEN
               BEGIN
                rItem.GET(ICAPurchase."Item No.");
        //GRN        wFobUnit   := rItem."costo FOB";
        //GRN        wCostoFobLitros :=  ( rItem."Cod. Procedencia" * 1.30)/rItem."Unit Volume";
                //wLitroXFob := ((rPurchInvLine.Quantity * rItem."Unit Volume") * wFobUnit);
        //GRN        wLitroXFob := ((rPurchInvLine.Quantity * rItem."Unit Volume") * wCostoFobLitros);
        //GRN        wSeguro    := rPurchHeader."Importe Seguro"/ wLitroXFobTotal * wLitroXFob;
        //GRN        wFlete     := rPurchHeader."Importe Flete" / wLitroXFobTotal * wLitroXFob;
        //GRN        wCif       := (wLitroXFob + wSeguro + wFlete) * rPurchHeader."Tasa liquidacion";
        
                wImporteAsignar := wCif;
        //GRN        wImporteAsignar := wImporteAsignar * (rDiageoSetUp."Netas periodo acumulado"/100);
                PurchLine.VALIDATE("Direct Unit Cost",wImporteAsignar);
               END;
           END;
        
        
        */

    end;


    procedure CalculaSelectivoA()
    begin
        /*
        //Calcular el selectivo especifco o Advalorem
        rPurchReceipt.RESET;
        rPurchReceipt.GET(ICAPurchase."Applies-to Doc. No.",ICAPurchase."Applies-to Doc. Line No.");
        rItem.GET(ICAPurchase."Item No.");
        rItem.TESTFIELD("Monto Selectivo Advalorem");
        wImporteAsignar := rItem."Monto Selectivo Advalorem" * rPurchReceipt."Quantity (Base)";
        PurchLine.VALIDATE("Direct Unit Cost",wImporteAsignar);
        */

    end;


    procedure "CalculaSelectivoE(TRL)"()
    var
        rTransferRecLine: Record "Transfer Receipt Line";
    begin
        /*
        rTransferRecLine.GET(ICAPurchase."Applies-to Doc. No.",ICAPurchase."Applies-to Doc. Line No.");
        rItem.GET(ICAPurchase."Item No.");
        wImporteAsignar := rItem."Selectivo Especifico" * rTransferRecLine."Quantity (Base)";
        PurchLine.VALIDATE("Direct Unit Cost",wImporteAsignar);
        */

    end;


    procedure "CalculaSelectivoE(RL)"()
    var
        rTransferRecLine: Record "Transfer Receipt Line";
    begin
        /*
        //Calcular el selectivo especifco o Advalorem
        rPurchReceipt.RESET;
        rPurchReceipt.GET(ICAPurchase."Applies-to Doc. No.",ICAPurchase."Applies-to Doc. Line No.");
        rItem.GET(ICAPurchase."Item No.");
        wImporteAsignar := rItem."Selectivo Especifico" * rPurchReceipt."Quantity (Base)";
        PurchLine.VALIDATE("Direct Unit Cost",wImporteAsignar);
        */

    end;


    procedure "CalculaSelectivoA(TRL)"()
    var
        rTransferRecLine: Record "Transfer Receipt Line";
    begin
        /*
        //Calcular el selectivo especifco o Advalorem
        rTransferRecLine.GET(ICAPurchase."Applies-to Doc. No.",ICAPurchase."Applies-to Doc. Line No.");
        rItem.GET(ICAPurchase."Item No.");
        rItem.TESTFIELD("Monto Selectivo Advalorem");
        wImporteAsignar := rItem."Monto Selectivo Advalorem" * rTransferRecLine."Quantity (Base)";
        PurchLine.VALIDATE("Direct Unit Cost",wImporteAsignar);
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
              PurchLine.GET(ICA."Applies-to Doc. Type",ICA."Applies-to Doc. No.",ICA."Applies-to Doc. Line No.");
              QtyBase := PurchLine."Qty. Received (Base)";
            END;
          ICA."Applies-to Doc. Type"::"Return Order",ICA."Applies-to Doc. Type"::"Credit Memo":
            BEGIN
              PurchLine.GET(ICA."Applies-to Doc. Type",ICA."Applies-to Doc. No.",ICA."Applies-to Doc. Line No.");
              QtyBase := PurchLine."Return Qty. Shipped (Base)";
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

