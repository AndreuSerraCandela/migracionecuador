codeunit 76012 "Funciones APS"
{

    trigger OnRun()
    begin
    end;

    var
        APSSetup: Record "Commercial Setup";
        Colegio: Record Contact;
        Fecha: Record Date;
        FechaInicioMes: Date;
        AnoInicio: Integer;
        MesInicio: Integer;
        "DíaInicio": Integer;
        AnoFin: Integer;
        MesFin: Integer;
        "DíaFin": Integer;
        Text001: Label 'Processing School... \ #1########## @2@@@@@@@@@@@@@';
        Text002: Label 'End of update';
        Text003: Label 'Verificando School... \ #1########## @2@@@@@@@@@@@@@';
        Err001: Label 'Starting date can''t be bigger than Ending date, %1 > %2';
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;


    procedure ColCalculoProf()
    begin
    end;


    procedure ColCalculoCenso()
    begin
    end;


    procedure ColCalculoNiveles()
    begin
    end;


    procedure ColBalCte()
    begin
    end;


    procedure ColCalcCompetencia()
    begin
    end;


    procedure ColCalcProm()
    begin
    end;


    procedure ColCalcInvConsigna()
    begin
    end;


    procedure ColCalcInvMuestras(CodColegio: Code[20]): Decimal
    var
        BC: Record "Bin Content";
        Colegio: Record Contact;
        Inventario: Decimal;
    begin
        Inventario := 0;
        Colegio.Get(CodColegio);

        if Colegio."Samples Location Code" = '' then
            exit;

        BC.Reset;
        BC.SetRange("Location Code", Colegio."Samples Location Code");
        BC.SetRange("Bin Code", CodColegio);
        if BC.FindSet then
            repeat
                BC.CalcFields(Quantity);
                Inventario += BC.Quantity;
            until BC.Next = 0;

        exit(Inventario);
    end;


    procedure ComCalculoZonas()
    begin
    end;


    procedure ComCalculoCol()
    begin
    end;


    procedure ComPptoVta()
    begin
    end;


    procedure ComCalculoVta()
    begin
    end;


    procedure ProfCalculoCol()
    begin
    end;


    procedure ProfCalculoMat()
    begin
    end;


    procedure ProfCalculoCenso()
    begin
    end;


    procedure LlenaPromotorColegios(CodPromotor: Code[20])
    var
        Promotor: Record "Salesperson/Purchaser";
        PromListaCol: Record "Promotor - Lista de Colegios";
        RutaProm: Record "Promotor - Rutas";
        ColegioNivel: Record "Colegio - Nivel";
        Colegio: Record Contact;
    begin
        //Primero se verifican los valores actuales por si han
        //cambiado la ruta del Promotor
        Window.Open(Text003);
        PromListaCol.Reset;
        PromListaCol.SetRange("Cod. Promotor", CodPromotor);
        CounterTotal := PromListaCol.Count;
        Counter := 0;
        if PromListaCol.FindSet then
            repeat
                Counter := Counter + 1;
                Window.Update(1, PromListaCol."Cod. Colegio");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                ColegioNivel.Reset;
                ColegioNivel.SetRange("Cod. Colegio", PromListaCol."Cod. Colegio");
                ColegioNivel.SetRange(Ruta, RutaProm."Cod. Ruta");
                if not ColegioNivel.FindFirst then
                    PromListaCol.Delete;
            until PromListaCol.Next = 0;

        Window.Close;

        //En seleccion de colegios  para visitas,
        //filtrar x ruta que esta amarrado al nivel del colegio
        Window.Open(Text001);
        RutaProm.Reset;
        RutaProm.SetRange("Cod. Promotor", CodPromotor);
        RutaProm.FindSet;
        repeat
            ColegioNivel.Reset;
            ColegioNivel.SetRange(Ruta, RutaProm."Cod. Ruta");
            ColegioNivel.FindSet;
            CounterTotal := ColegioNivel.Count;
            Counter := 0;
            repeat
                Counter := Counter + 1;
                Window.Update(1, ColegioNivel."Cod. Colegio");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                Clear(PromListaCol);
                Colegio.Get(ColegioNivel."Cod. Colegio");

                PromListaCol.Validate("Cod. Promotor", CodPromotor);
                PromListaCol.Validate("Cod. Colegio", ColegioNivel."Cod. Colegio");
                PromListaCol.Validate("Cod. Ruta", ColegioNivel.Ruta);
                //Peru  PromListaCol."Distrito Code" := Colegio.City;
                //  PromListaCol.Distritos := Colegio.Departamento;
                if PromListaCol.Insert(true) then;


            until ColegioNivel.Next = 0;
        until RutaProm.Next = 0;

        Window.Close;
        Message(Text002);
    end;


    procedure InsertaAdopciones(CodCol: Code[20]; CodNivel: Code[20]; CodPromotor: Code[20]; CodTurno: Code[20])
    var
        AdopcionesD: Record "Colegio - Adopciones Detalle";
        HAdopciones: Record "Historico Adopciones";
        Item: Record Item;
        PptoPromotor: Record "Promotor - Ppto Vtas";
        GradosCol: Record "Colegio - Grados";
        Editoriales: Record Editoras;
        Nivel: Record "Nivel Educativo APS";
        DimVal: Record "Dimension Value";
        DefDim: Record "Default Dimension";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Turnos: Page Turnos;
    begin
        //MESSAGE('a%1 b%2 c%3 d%4 e%5',CodCol,CodNivel,CodPromotor,CodTurno);

        Editoriales.SetRange(Santillana, true);
        Editoriales.FindFirst;

        PptoPromotor.Reset;
        PptoPromotor.SetRange("Cod. Promotor", CodPromotor);
        PptoPromotor.FindSet;

        CounterTotal := PptoPromotor.Count;
        Window.Open(Text001);

        repeat
            Counter := Counter + 1;
            Window.Update(1, PptoPromotor."Cod. Producto");
            Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

            Item.Get(PptoPromotor."Cod. Producto");
            Item.TestField("Nivel Educativo");
            Item.TestField("Nivel Escolar (Grado)");
            Item.TestField("Grupo de Negocio");

            if StrPos(CodNivel, Item."Nivel Educativo") <> 0 then begin
                Nivel.Get(Item."Nivel Educativo");
                /*
                     IF Nivel."Verificación cruzada" THEN
                        BEGIN
                          GradosCol.SETRANGE("Cod. Colegio",gCodCol);
                          GradosCol.SETRANGE("Cod. Turno",gCodTurno);
                     //     IF Item.Grado <> '' THEN
                        END
                     ELSE
                */

                Clear(GradosCol);
                GradosCol.SetRange("Cod. Colegio", CodCol);
                GradosCol.SetFilter("Cod. Nivel", Item."Nivel Educativo");
                GradosCol.SetRange("Cod. Turno", CodTurno);
                GradosCol.SetRange("Cod. Grado", Item."Nivel Escolar (Grado)");
                if GradosCol.FindFirst then;
                //      GradosCol.TESTFIELD("Cantidad Alumnos");

                HAdopciones.SetRange(Campana, Format(APSSetup.Campana));
                HAdopciones.SetRange("Cod. Editorial", Editoriales.Code);
                HAdopciones.SetRange("Cod. Colegio", CodCol);
                HAdopciones.SetRange("Cod. Nivel", Item."Nivel Educativo");
                if PptoPromotor."Cod. producto equivalente" <> '' then
                    HAdopciones.SetFilter("Cod. producto", '%1|%2', '', PptoPromotor."Cod. producto equivalente")
                else
                    HAdopciones.SetFilter("Cod. producto", '%1|%2', '', PptoPromotor."Cod. Producto");
                HAdopciones.SetRange(Santillana, true);
                if HAdopciones.FindLast then begin
                    Clear(AdopcionesD);
                    AdopcionesD.Validate("Cod. Colegio", CodCol);
                    //     AdopcionesD.VALIDATE("Cod. Local",CodLocal);
                    AdopcionesD.Validate("Cod. Nivel", Item."Nivel Educativo");
                    AdopcionesD.Validate("Cod. Turno", CodTurno);
                    AdopcionesD.Validate("Cod. Promotor", CodPromotor);
                    AdopcionesD.Validate("Cod. Producto", PptoPromotor."Cod. Producto");
                    AdopcionesD."Cod. Grado" := Item."Nivel Escolar (Grado)";
                    AdopcionesD."Cantidad Alumnos" := GradosCol."Cantidad Alumnos";
                    AdopcionesD.Validate(Seccion, GradosCol.Seccion);
                    AdopcionesD."Adopcion anterior" := HAdopciones.Adopcion;
                    AdopcionesD.Validate("Grupo de Negocio", Item."Grupo de Negocio");
                    AdopcionesD.Validate("Cantidad Alumnos", GradosCol."Cantidad Alumnos");
                    if AdopcionesD.Insert(true) then;
                end
                else begin
                    Clear(AdopcionesD);
                    AdopcionesD.Validate("Cod. Colegio", CodCol);
                    //      AdopcionesD.VALIDATE("Cod. Local",gCodLocal);
                    AdopcionesD.Validate("Cod. Nivel", Item."Nivel Educativo");
                    AdopcionesD.Validate("Cod. Turno", CodTurno);
                    AdopcionesD.Validate("Cod. Promotor", CodPromotor);
                    AdopcionesD.Validate("Cod. Producto", PptoPromotor."Cod. Producto");
                    //           AdopcionesD.VALIDATE("Cod. Editorial",Editoriales.Code);
                    AdopcionesD."Cod. Grado" := Item."Nivel Escolar (Grado)";
                    AdopcionesD."Cantidad Alumnos" := GradosCol."Cantidad Alumnos";
                    AdopcionesD.Validate(Seccion, GradosCol.Seccion);
                    AdopcionesD.Validate("Grupo de Negocio", Item."Grupo de Negocio");
                    AdopcionesD.Validate("Cantidad Alumnos", GradosCol."Cantidad Alumnos");
                    if AdopcionesD.Insert(true) then;
                end;
            end;
        until PptoPromotor.Next = 0;
        Window.Close;

    end;
}

