codeunit 56051 "Cancelar reservas Call Center"
{

    trigger OnRun()
    begin
        CancelarReservaCallCenter;
    end;


    procedure CancelarReservaCallCenter()
    var
        rConf: Record "Config. Empresa";
        rSalesHeader: Record "Sales Header";
        rSalesLine: Record "Sales Line";
        lText001: Label 'Se borrarán las reservas de los pedidos de Call Center con fecha hasta día %1 (incluido). ¿Desea continuar?';
        wFecha: Date;
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReservEntry: Record "Reservation Entry";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        lText002: Label 'Proceso finalizado';
    begin
        //+#830

        rConf.Get;
        rConf.TestField("Días Borrado Rvas. Call Center");
        wFecha := WorkDate - rConf."Días Borrado Rvas. Call Center";
        if Confirm(StrSubstNo(lText001, wFecha)) then begin
            rSalesHeader.Reset;
            rSalesHeader.SetRange("Document Type", rSalesHeader."Document Type"::Order);
            rSalesHeader.SetRange("Document Date", 0D, wFecha);
            rSalesHeader.SetRange("Venta Call Center", true);
            rSalesHeader.SetRange("Pago recibido", false);
            if rSalesHeader.FindSet then
                repeat
                    rSalesLine.Reset;
                    rSalesLine.SetRange(rSalesLine."Document Type", rSalesHeader."Document Type");
                    rSalesLine.SetRange(rSalesLine."Document No.", rSalesHeader."No.");
                    if rSalesLine.FindSet then
                        repeat
                            if (rSalesLine.Type = rSalesLine.Type::Item) and (rSalesLine."No." <> '') then begin
                                ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, true);
                                //ReserveSalesLine.FilterReservFor(ReservEntry, rSalesLine);
                                FilterReservFor(ReservEntry, rSalesLine);
                                if ReservEntry.FindFirst then
                                    repeat
                                        ReservEngineMgt.CloseReservEntry(ReservEntry, false, false);
                                    until ReservEntry.Next = 0;
                            end;
                        until rSalesLine.Next = 0;
                until rSalesHeader.Next = 0;
        end;
        Message(lText002);
    end;

    local procedure FilterReservFor(VAR FilterReservEntry: Record "Reservation Entry"; SalesLine: Record "Sales Line")
    var
        myInt: Integer;
    begin
        FilterReservEntry.SetSourceFilter(DATABASE::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.", SalesLine."Line No.", FALSE);
        FilterReservEntry.SETRANGE("Source Batch Name", '');
        FilterReservEntry.SETRANGE("Source Prod. Order Line", 0);
    end;
}

