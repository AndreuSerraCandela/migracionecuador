codeunit 76051 "Notas Crédito Pdtes POS"
{

    trigger OnRun()
    var
        recTPV: Record "Configuracion TPV";
        recTienda: Record Tiendas;
        pagTiendas: Page "Lista Tiendas Simple";
        CduPOS: Codeunit "Funciones Addin DSPos";
        pagNC: Page "Lista Notas Credito Pdtes POS";
        rNC: Record "Sales Header";
        recTiendaTMP: Record Tiendas temporary;
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
                Clear(pagNC);
                rNC.FilterGroup(2);
                rNC.SetCurrentKey("Posting Date", Tienda, "Venta TPV", "Registrado TPV");
                rNC.SetRange("Document Type", rNC."Document Type"::"Credit Memo");
                rNC.SetRange("Venta TPV", true);
                if recTiendaTMP."Cod. Tienda" <> txtTodas then
                    rNC.SetRange(Tienda, recTiendaTMP."Cod. Tienda");
                rNC.FilterGroup(0);
                pagNC.SetTableView(rNC);
                pagNC.RunModal;
            end;
        end
        else
            Error(Error001);
    end;

    var
        Error001: Label 'Función Sólo disponible en Servidor Central';
        txtTodas: Label 'TODAS';
        TxtDescri: Label 'MOSTRAR TODAS LAS TIENDAS';
}

