codeunit 55000 "Genera Oferta de Promo"
{
    Permissions = TableData "Sales Header" = rimd,
                  TableData "Sales Line" = rimd;
    TableNo = "Sales Header";

    trigger OnRun()
    begin
        //fes mig
        /*
        TESTFIELD("Cód. Oferta promo");
        
        rCte.GET("Sell-to Customer No.");
        rVendedor.GET(rCte."Salesperson Code");
        CantidadPromo := 0;
        ConfVtas.GET();
        rLinVenta.SETRANGE("Document Type","Document Type");
        rLinVenta.SETRANGE("Document No.","No.");
        rLinVenta.SETRANGE(Type,rLinVenta.Type::Item);
        
        IF rLinVenta.FIND('-') THEN
           REPEAT
             IF STRPOS(rLinVenta."No.",'B') = 0 THEN
                CantidadPromo += rLinVenta.Quantity; //Acumulo la cantidad vendida
           UNTIL rLinVenta.NEXT = 0;
        
        //Busco el tipo de Oferta para promocion
        rOfertaPromo.GET("Cód. Oferta promo");
        IF (rOfertaPromo."Fecha Inicial" > WORKDATE) OR
           (rOfertaPromo."Fecha Final" < WORKDATE) THEN
           ERROR('La fecha de trabajo esta fuera del rango para esta Oferta de Promo');
        
        IF (rOfertaPromo."Fecha Final" < WORKDATE) THEN
           BEGIN
             rOfertaPromo."Estado Oferta" := 2;
             rOfertaPromo.MODIFY;
           END;
        
        IF CantidadPromo >= rOfertaPromo."Cantida Mínima" THEN
           BEGIN
             IF rOfertaPromo."Tipo Oferta" = 0 THEN //Para las promos en %
                BEGIN
                  rLinVenta.RESET;
                  rLinVenta.SETRANGE("Document Type",rLinVenta."Document Type");
                  rLinVenta.SETRANGE("Document No.",rLinVenta."Document No.");
                  IF rLinVenta.FIND('-') THEN
                     REPEAT
                       rLinVenta."Line Discount %" := rOfertaPromo."% Descuento";
                       rLinVenta.VALIDATE("Line Discount %");
                       rLinVenta.MODIFY;
                     UNTIL rLinVenta.NEXT = 0;
                  MESSAGE('Se ha concedido un %1 para el documento %2 a nombre de %3,\'+
                          'con el No. %4, favor verificar',rOfertaPromo."% Descuento","No.","Bill-to Name","No.");
        
                END
             ELSE
               BEGIN                                   //Para las promos en Cantidad
                 //Verifico si tiene Promo generada
                 rCabPromo.SETRANGE("Document Type",rCabPromo."Document Type"::"Return Order");
                 rCabPromo.SETRANGE("No. Pedido Venta relacionado","No.");
                 IF NOT rCabPromo.FIND('-') THEN
                    BEGIN
                      rCabPromo."Document Type" := rCabPromo."Document Type"::"Return Order";
                      GestNoSerie.InitSeries(ConfVtas."Nº serie promociones",ConfVtas."Nº serie promoc. registrada",
                                            rCabPromo."Posting Date",rCabPromo."No.",rCabPromo."No. Series");
                      rCabPromo."Sell-to Customer No." := "Sell-to Customer No.";
                      rCabPromo.VALIDATE("Sell-to Customer No.");
                      rCabPromo."No. Pedido Venta relacionado" := "No.";
                      rCabPromo."Order Date"                  := "Order Date";
                      rCabPromo."Posting Date"                := "Posting Date";
                      rCabPromo."Shipment Date"                   := "Shipment Date";
                      rCabPromo."Document Date"       := "Document Date";
                      rCabPromo."Cta. Promoción"                := rOfertaPromo."Cta. Promoción";
                      rCabPromo.VALIDATE("Payment Terms Code");
                      rCabPromo.Actividad                       := rOfertaPromo.Actividad;
                      rCabPromo.Solicita                        := rVendedor.Name;
                      rCabPromo."Cód. Oferta promo"             := "Cód. Oferta promo";
                      rCabPromo."Posting No. Series"             := rOfertaPromo."Nro. Serie registro";
                      rCabPromo.Promoción                       := TRUE;
                      rCabPromo.INSERT;
                    END;
        
                    rLinPromo.SETRANGE("Document Type","Document Type"::"Return Order");
                    rLinPromo.SETRANGE("Document No.",rCabPromo."No.");
                    rLinPromo.SETRANGE(Type,rLinPromo.Type::Item);
             //       rLinPromo.SETRANGE("Nº",rOfertaPromo."Cód. producto");
                    IF rLinPromo.FIND('-') THEN
                       rLinPromo.DELETEALL;
        
                    rLinPromo.RESET;
                    rLinPromo.SETRANGE("Document Type","Document Type"::"Return Order");
                    rLinPromo.SETRANGE("Document No.",rCabPromo."No.");
                    IF rLinPromo.FIND('+') THEN
                       rLinPromo."Line No." := rLinPromo."Line No.";
        
                    rLinPromo.SETRANGE("Document Type","Document Type"::"Return Order");
                    rLinPromo.SETRANGE("Document No.",rCabPromo."No.");
                    rLinPromo."Document Type"     := rLinPromo."Document Type"::"Return Order";
                    rLinPromo."Document No."       := rCabPromo."No.";
                    rLinPromo."Line No."           += 1;
                    rLinPromo."Sell-to Customer No." := "Sell-to Customer No.";
                    rLinPromo.Type                 := rLinPromo.Type::Item;
                    rLinPromo."No."                 := rOfertaPromo."Cód. producto";
                    rLinPromo.VALIDATE("No.");
                    Division := FORMAT(CantidadPromo / rOfertaPromo."Cantida Mínima",0,'<Integer Thousand>');
                    EVALUATE(CantidadPromo,Division);
                    rLinPromo.Quantity             := CantidadPromo * rOfertaPromo."Cantidad en promo";
                    rLinPromo.VALIDATE(Quantity);
                    rLinPromo.INSERT;
                    MESSAGE('Se ha creado/modificado una %1 para el documento %2 a nombre de %3,\'+
                            'con el No. %4, favor verificar',rCabPromo."Document Type","No.",rCabPromo."Bill-to Name",rCabPromo."No.");
               END;
           END
        ELSE
          ERROR('Este documento no llega a la cantidad mínima para esta Oferta de Promo');
        */

    end;

    var
        ConfVtas: Record "Sales & Receivables Setup";
        rCabPromo: Record "Sales Header";
        rLinPromo: Record "Sales Line";
        rLinVenta: Record "Sales Line";
        rCte: Record Customer;
        rVendedor: Record "Salesperson/Purchaser";
        CantidadPromo: Decimal;
        Division: Text[30];
}

