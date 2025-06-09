codeunit 76052 "Notas Crédito Regis POS"
{

    trigger OnRun()
    var
        recTPV: Record "Configuracion TPV";
        recTienda: Record Tiendas;
        pagTiendas: Page "Lista Tiendas Simple";
        CduPOS: Codeunit "Funciones Addin DSPos";
        pagHistNC: Page "Notas Credito Venta Regis POS";
        recHistNC: Record "Sales Cr.Memo Header";
        recTiendaTMP: Record Tiendas temporary;
        txtTodas: Label 'TODAS';
        txtDescri: Label 'MOSTRAR TODAS LAS TIENDAS';
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
                recTiendaTMP.Descripcion := txtDescri;
                recTiendaTMP.Insert;
            end;

            Clear(pagTiendas);
            pagTiendas.LookupMode(true);
            pagTiendas.RecibirTiendas(recTiendaTMP);

            if pagTiendas.RunModal = ACTION::Yes then begin
                pagTiendas.GetRecord(recTiendaTMP);
                Clear(pagHistNC);
                recHistNC.FilterGroup(2);
                recHistNC.SetCurrentKey("Posting Date", Tienda, "Venta TPV");
                recHistNC.SetRange("Venta TPV", true);

                if recTiendaTMP."Cod. Tienda" <> txtTodas then
                    recHistNC.SetRange(Tienda, recTiendaTMP."Cod. Tienda");

                recHistNC.FilterGroup(0);
                pagHistNC.SetTableView(recHistNC);
                pagHistNC.RunModal;
            end;
        end
        else
            Error(Error001);
    end;

    var
        Error001: Label 'Función Sólo disponible en Servidor Central';
}

