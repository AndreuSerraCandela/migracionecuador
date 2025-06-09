codeunit 76009 "Facturas Registradas POS"
{

    trigger OnRun()
    var
        recTPV: Record "Configuracion TPV";
        recTienda: Record Tiendas;
        recTiendaTMP: Record Tiendas temporary;
        pagTiendas: Page "Lista Tiendas Simple";
        CduPOS: Codeunit "Funciones Addin DSPos";
        pagHistFact: Page "Facturas Venta Regis POS";
        recHistFact: Record "Sales Invoice Header";
    begin

        recTPV.Reset;
        recTPV.SetCurrentKey("Usuario windows");
        recTPV.SetRange("Usuario windows", CduPOS.TraerUsuarioWindows);
        if not recTPV.FindFirst then begin

            if recTienda.FindSet then begin
                repeat
                    recTiendaTMP := recTienda;
                    recTiendaTMP.Insert;
                until recTienda.Next = 0;
                recTiendaTMP.Init;
                recTiendaTMP."Cod. Tienda" := txtTodas;
                recTiendaTMP.Descripcion := TxtDescri;
                recTiendaTMP.Insert;
            end;

            Clear(pagTiendas);
            pagTiendas.LookupMode(true);
            pagTiendas.RecibirTiendas(recTiendaTMP);
            if pagTiendas.RunModal = ACTION::Yes then begin
                pagTiendas.GetRecord(recTiendaTMP);
                Clear(pagHistFact);
                recHistFact.FilterGroup(2);
                recHistFact.SetCurrentKey("Posting Date", Tienda, "Venta TPV");
                recHistFact.SetRange("Venta TPV", true);
                if recTiendaTMP."Cod. Tienda" <> txtTodas then
                    recHistFact.SetRange(Tienda, recTiendaTMP."Cod. Tienda");
                recHistFact.FilterGroup(0);
                pagHistFact.SetTableView(recHistFact);
                pagHistFact.RunModal;
            end;
        end
        else
            Error(Error001);
    end;

    var
        Error001: Label 'Función Sólo Disponible en Servidor Central';
        txtTodas: Label 'TODAS';
        TxtDescri: Label 'MOSTRAR TODAS LAS TIENDAS';
}

