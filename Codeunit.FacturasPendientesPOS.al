codeunit 76008 "Facturas Pendientes POS"
{

    trigger OnRun()
    var
        recTPV: Record "Configuracion TPV";
        recTienda: Record Tiendas;
        pagTiendas: Page "Lista Tiendas Simple";
        CduPOS: Codeunit "Funciones Addin DSPos";
        pagFact: Page "Lista Facturas Pendientes POS";
        recFact: Record "Sales Header";
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
                recTiendaTMP."Cod. Tienda" := TxtTodas;
                recTiendaTMP.Descripcion := txtDescri;
                recTiendaTMP.Insert;
            end;

            Clear(pagTiendas);
            pagTiendas.LookupMode(true);
            pagTiendas.RecibirTiendas(recTiendaTMP);

            if pagTiendas.RunModal = ACTION::Yes then begin
                pagTiendas.GetRecord(recTiendaTMP);
                Clear(pagFact);

                recFact.FilterGroup(2);
                recFact.SetCurrentKey("Posting Date", Tienda, "Venta TPV", "Registrado TPV");
                recFact.SetRange("Document Type", recFact."Document Type"::Invoice);
                recFact.SetRange("Venta TPV", true);

                if recTiendaTMP."Cod. Tienda" <> TxtTodas then
                    recFact.SetRange(Tienda, recTiendaTMP."Cod. Tienda");

                recFact.SetRange("Registrado TPV", true);
                recFact.FilterGroup(0);
                pagFact.SetTableView(recFact);
                pagFact.RunModal;
            end;
        end
        else
            Error(Error001);
    end;

    var
        Error001: Label 'Función Sólo Disponible en Servidor Central';
        TxtTodas: Label 'TODAS';
        txtDescri: Label 'MOSTRAR TODAS LAS TIENDAS';
}

