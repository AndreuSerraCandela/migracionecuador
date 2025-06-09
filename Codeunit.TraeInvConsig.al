codeunit 56001 "Trae Inv. Consig"
{
    Permissions = TableData "Item Ledger Entry" = rm;

    trigger OnRun()
    begin
    end;

    var
        SalesLine1: Record "Sales Line";
        SalesLine: Record "Sales Line";
        NoPedidoActual: Code[20];
        CFuncSantillana: Codeunit "Funciones Santillana";
        TransRecLines: Record "Transfer Receipt Line";
        NoLinea: Integer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Text001: Label 'Reading  #1########## @2@@@@@@@@@@@@@';


    procedure CalcInvConsig(CodCliente: Code[20])
    begin
        ClearAll;
        NoPedidoActual := CFuncSantillana.EnviaNoTransferencia;
        Counter := 0;
        CounterTotal := 0;

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

                SalesLine1.Reset;
                SalesLine1.SetRange("Document Type", SalesLine1."Document Type"::Order);
                SalesLine1.SetRange("Document No.", NoPedidoActual);
                if SalesLine1.FindLast then
                    NoLinea := SalesLine1."Line No."
                else
                    NoLinea := 0;

                NoLinea += 10000;
                SalesLine.Init;
                SalesLine."Document Type" := SalesLine."Document Type"::Order;
                SalesLine."Document No." := NoPedidoActual;
                SalesLine."Line No." := NoLinea;
                SalesLine.Validate(Type, SalesLine.Type::Item);
                SalesLine.Validate("No.", TransRecLines."Item No.");

                //Se busca el No. de mov. producto correspondiente a la linea para pasarla a la linea de pedidos
                //de venta
                ItemLedgerEntry.Reset;
                ItemLedgerEntry.SetCurrentKey("Document No.", "Document Type", "Document Line No.");
                ItemLedgerEntry.SetRange("Document No.", TransRecLines."Document No.");
                ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Transfer Receipt");
                ItemLedgerEntry.SetRange("Document Line No.", TransRecLines."Line No.");
                ItemLedgerEntry.SetRange("Location Code", TransRecLines."Transfer-to Code");
                if ItemLedgerEntry.FindFirst then begin
                    SalesLine.Validate("No. Mov. Prod. Cosg. a Liq.", ItemLedgerEntry."Entry No.");

                    //La cantidad que se pasa a las lineas de venta es la pendiente en el
                    //Mov. producto
                    SalesLine.Validate(Quantity, ItemLedgerEntry."Cant. Consignacion Pendiente");

                    SalesLine.Validate("Unit of Measure Code", TransRecLines."Unit of Measure Code");
                    //GRN        SalesLine.VALIDATE("Unit Price",TransRecLines."Precio Venta Consignacion");
                    SalesLine.Validate(SalesLine."Line Discount %", TransRecLines."Descuento % Consignacion");
                    SalesLine.Validate("No. Pedido Consignacion", TransRecLines."Document No.");
                    SalesLine.Validate("No. Linea Pedido Consignacion", TransRecLines."Line No.");

                    //si la cantidad pendiente es 0 no sube la linea al pedido.
                    if SalesLine.Quantity > 0 then
                        SalesLine.Insert(true);
                end;
            until TransRecLines.Next = 0;

        Window.Close;
    end;
}

