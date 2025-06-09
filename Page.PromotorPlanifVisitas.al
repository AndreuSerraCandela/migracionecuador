page 76369 "Promotor - Planif. Visitas"
{
    ApplicationArea = all;
    PageType = ListPart;
    SourceTable = "Promotor - Planif. Visita";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                    Visible = false;
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field(Fecha; rec.Fecha)
                {
                    Editable = false;
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                    Editable = false;
                }
                field(Estado; rec.Estado)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Fecha Visita"; rec."Fecha Visita")
                {
                }
                field("Hora Inicial Visita"; rec."Hora Inicial Visita")
                {
                }
                field("Hora Final Visita"; rec."Hora Final Visita")
                {
                }
                field("Fecha Proxima Visita"; rec."Fecha Proxima Visita")
                {
                }
                field("FuncAPS.ColCalcInvMuestras(""Cod. Colegio"")"; FuncAPS.ColCalcInvMuestras(rec."Cod. Colegio"))
                {
                    Caption = 'Sample Inventory';
                }
                field(Comentario; rec.Comentario)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1906587504>")
            {
                Caption = 'F&unctions';
                action("<Action1905623604>")
                {
                    Caption = '&Edit Line';
                    Ellipsis = true;

                    ShortCutKey = 'Ctrl+E';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #42. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        //ShowPrices

                        if rec.Estado > 0 then
                            AbreVisita;

                    end;
                }
            }
        }
    }

    var
        FuncAPS: Codeunit "Funciones APS";


    procedure CargaEntregaMuestras()
    var
        Promotor: Record "Salesperson/Purchaser";
        Alm: Record Location;
        PromEM: Record "Transfer Header";
        PromEM2: Record "Transfer Header";
        fPromEM: Page "Cab. Muestras";
        Bins: Record Bin;
        Bins2: Record Bin;
        Colegio: Record Contact;
    begin

        Promotor.Get(rec."Cod. Promotor");
        Promotor.TestField("Sample Location code");

        Colegio.Get(rec."Cod. Colegio");
        Colegio.TestField("Samples Location Code");

        //Doy de alta a la Ubicacion del Promotor
        Bins.Reset;
        Bins2.SetRange("Location Code", Promotor."Sample Location code");
        Bins.SetRange(Code, rec."Cod. Promotor");
        if not Bins.FindFirst then begin
            Clear(Bins);
            Bins.Validate("Location Code", Promotor."Sample Location code");
            Bins.Code := rec."Cod. Promotor";
            Bins.Description := CopyStr(Promotor.Name, 1, 50);
            Bins.Default := true;
            if Bins.Insert(true) then
                Commit;
        end;


        //Doy de alta a la Ubicacion del Colegio
        Bins2.Reset;
        Bins2.SetRange("Location Code", Colegio."Samples Location Code");
        Bins2.SetRange(Code, rec."Cod. Colegio");
        if not Bins2.FindFirst then begin
            Clear(Bins2);
            Bins2.Validate("Location Code", Colegio."Samples Location Code");
            Bins2.Code := Colegio."No.";
            Bins2.Description := CopyStr(Colegio.Name, 1, 50);
            Bins2.Default := true;
            if Bins2.Insert(true) then
                Commit;
        end;

        Clear(PromEM);
        PromEM2.Reset;
        PromEM2.SetRange("Transfer-from Code", Promotor."Sample Location code");
        PromEM2.SetRange("Transfer-to Code", Colegio."Samples Location Code");
        PromEM2.SetRange("Cod. Ubicacion Alm. Origen", Promotor.Code);
        PromEM2.SetRange("Cod. Ubicacion Alm. Destino", Colegio."No.");

        if not PromEM2.FindFirst then begin
            PromEM.Insert(true);
            PromEM.SetRange("No.");
            PromEM.Validate("Cod. Vendedor", Promotor.Code);
            PromEM."Pedido Consignacion" := true;
            PromEM."Consignacion Muestras" := true;

            PromEM.Validate("Transfer-from Code", Promotor."Sample Location code");
            PromEM.Validate("Transfer-to Code", Colegio."Samples Location Code");
            //    Colegio.GET("Cod. Colegio");
            PromEM."Transfer-to Name" := Colegio.Name;
            PromEM."Transfer-to Address" := Colegio.Address;
            PromEM2."Transfer-to Address 2" := Colegio."Address 2";
            PromEM2."Transfer-to Post Code" := Colegio."Post Code";
            PromEM2."Transfer-to City" := Colegio.City;
            PromEM."Transfer-to County" := Colegio.County;
            PromEM."Trsf.-to Country/Region Code" := Colegio."Country/Region Code";

            PromEM.Validate("Posting Date", rec.Fecha);
            PromEM.Validate("Cod. Ubicacion Alm. Origen", rec."Cod. Promotor");
            PromEM.Validate("Cod. Ubicacion Alm. Destino", rec."Cod. Colegio");
            PromEM.Modify;
            fPromEM.SetTableView(PromEM);
            fPromEM.SetRecord(PromEM);
            //fPromEM.RecibeParametros(PromEM."Transfer-from Code",PromEM."Transfer-to Code","Cod. Promotor","Cod. Colegio");
            Commit;
        end
        else begin
            fPromEM.SetTableView(PromEM2);
            fPromEM.SetRecord(PromEM2);
        end;

        fPromEM.RunModal;
        Clear(fPromEM);
    end;


    procedure CargaDevolucionMuestras()
    var
        Promotor: Record "Salesperson/Purchaser";
        Alm: Record Location;
        PromEM: Record "Transfer Header";
        PromEM2: Record "Transfer Header";
        fPromEM: Page "Cab. Muestras";
        Bins: Record Bin;
        Bins2: Record Bin;
        Colegio: Record Contact;
    begin

        Promotor.Get(rec."Cod. Promotor");
        Promotor.TestField("Sample Location code");

        Colegio.Get(rec."Cod. Colegio");
        Colegio.TestField("Samples Location Code");

        //Doy de alta a la Ubicacion del Promotor
        Bins.Reset;
        Bins.SetRange("Location Code", Promotor."Sample Location code");
        Bins.SetRange(Code, rec."Cod. Promotor");
        Bins.FindFirst;

        //Doy de alta a la Ubicacion del Colegio
        Bins2.Reset;
        Bins2.SetRange("Location Code", Colegio."Samples Location Code");
        Bins2.SetRange(Code, rec."Cod. Colegio");
        Bins2.FindFirst;

        Clear(PromEM);
        PromEM2.Reset;
        PromEM2.SetRange("Transfer-from Code", Colegio."Samples Location Code");
        PromEM2.SetRange("Transfer-to Code", Promotor."Sample Location code");
        PromEM2.SetRange("Cod. Ubicacion Alm. Origen", Colegio."No.");
        PromEM2.SetRange("Cod. Ubicacion Alm. Destino", Promotor.Code);


        if not PromEM2.FindFirst then begin
            PromEM.Insert(true);
            PromEM.SetRange("No.");
            PromEM.Validate("Cod. Vendedor", Promotor.Code);
            PromEM."Pedido Consignacion" := true;
            PromEM."Consignacion Muestras" := true;
            PromEM.Validate("Transfer-from Code", Colegio."Samples Location Code");
            PromEM.Validate("Transfer-to Code", Promotor."Sample Location code");
            Colegio.Get(rec."Cod. Colegio");
            PromEM."Transfer-to Name" := Colegio.Name;
            PromEM."Transfer-to Address" := Colegio.Address;
            PromEM2."Transfer-to Address 2" := Colegio."Address 2";
            PromEM2."Transfer-to Post Code" := Colegio."Post Code";
            PromEM2."Transfer-to City" := Colegio.City;
            PromEM."Transfer-to County" := Colegio.County;
            PromEM."Trsf.-to Country/Region Code" := Colegio."Country/Region Code";

            PromEM.Validate("Posting Date", rec.Fecha);
            PromEM.Validate("Cod. Ubicacion Alm. Origen", rec."Cod. Colegio");
            PromEM.Validate("Cod. Ubicacion Alm. Destino", rec."Cod. Promotor");
            PromEM.Modify;
            fPromEM.SetTableView(PromEM);
            fPromEM.SetRecord(PromEM);
            //fPromEM.RecibeParametros(PromEM."Transfer-from Code",PromEM."Transfer-to Code","Cod. Promotor","Cod. Colegio");
            Commit;
        end
        else begin
            fPromEM.SetTableView(PromEM2);
            fPromEM.SetRecord(PromEM2);
        end;

        fPromEM.RunModal;
        Clear(fPromEM);
    end;


    procedure AbreVisita()
    var
        PromPV: Record "Promotor - Planif. Visita";
        fPromPV: Page "Ficha Ejecucion Planificacion";
    begin
        CurrPage.SetSelectionFilter(PromPV);
        fPromPV.SetTableView(PromPV);
        fPromPV.SetRecord(PromPV);
        fPromPV.RunModal;
        Clear(fPromPV);
    end;
}

