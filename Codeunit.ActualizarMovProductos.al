codeunit 56012 ActualizarMovProductos
{
    // #16786  FAA   Para Actualizar las cantidades pendientes de Movimientos productos Ecuador

    Permissions = TableData "Item Ledger Entry" = rm;

    trigger OnRun()
    begin
        if not Confirm(CompanyName) then
            Error('PROCESO CANCELADO POR EL USUARIO');

        vrMovProductos.Reset;
        vrMovProductos.SetRange(vrMovProductos."Item No.", vProd3011);
        ActualizaMovimiento(1591271, 9);
        ActualizaMovimiento(1591735, 39);
        ActualizaMovimiento(1605215, 16);
        ActualizaMovimiento(1607591, 1);
        ActualizaMovimiento(1610815, 7);
        ActualizaMovimiento(1619730, 3);
        ActualizaMovimiento(1619860, 8);
        ActualizaMovimiento(1638238, 40);
        ActualizaMovimiento(1644127, 17);
        ActualizaMovimiento(1680433, 8);
        ActualizaMovimiento(1680598, 1);
        ActualizaMovimiento(1681290, 1);

        vrMovProductos.SetRange(vrMovProductos."Item No.", vProd3001);
        ActualizaMovimiento(1578721, 2);
        ActualizaMovimiento(1591265, 40);
        ActualizaMovimiento(1591732, 15);
        ActualizaMovimiento(1592424, 20);
        ActualizaMovimiento(1605183, 16);
        ActualizaMovimiento(1610811, 7);
        ActualizaMovimiento(1619729, 3);
        ActualizaMovimiento(1619859, 8);
        ActualizaMovimiento(1634645, 3);
        ActualizaMovimiento(1638233, 26);
        ActualizaMovimiento(1680427, 8);
        ActualizaMovimiento(1680596, 1);
        ActualizaMovimiento(1681284, 1);
    end;

    var
        vrMovProductos: Record "Item Ledger Entry";
        vProd3011: Label '101153011';
        vProd3001: Label '101153001';


    procedure ActualizaMovimiento(vMovimiento: Integer; vCantidad: Decimal)
    begin

        vrMovProductos.SetRange(vrMovProductos."Entry No.", vMovimiento);

        if vrMovProductos.FindSet then begin
            vrMovProductos.Open := true;
            vrMovProductos."Remaining Quantity" := vCantidad;
            vrMovProductos.Modify;
        end
        else
            Message(vrMovProductos.GetFilters);
    end;
}

