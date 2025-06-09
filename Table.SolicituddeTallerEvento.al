table 76333 "Solicitud de Taller - Evento"
{

    fields
    {
        field(1; "Tipo de Evento"; Code[20])
        {
            TableRelation = "Tipos de Eventos";

            trigger OnValidate()
            begin
                /*
                IF TipoEvento.GET("Tipo de Evento") THEN
                   "Descripcion evento" := TipoEvento.Descripcion;
                */

            end;
        }
        field(2; "No. Solicitud"; Code[20])
        {
        }
        field(3; "Cod. evento"; Code[20])
        {
            TableRelation = Eventos."No." WHERE("Tipo de Evento" = FIELD("Tipo de Evento"));

            trigger OnLookup()
            var
                rEvExp: Record "Expositores - Eventos";
                pEvExp: Page "Expositores - Eventos";
            begin

                if "Existe evento" then begin
                    rEvExp.Reset;
                    rEvExp.SetRange(rEvExp."Tipo de Evento", "Tipo de Evento");
                    rEvExp.SetRange(rEvExp.Delegacion, Delegacion);
                    pEvExp.SetTableView(rEvExp);
                    pEvExp.LookupMode(true);
                    if pEvExp.RunModal = ACTION::LookupOK then begin
                        pEvExp.GetRecord(rEvExp);
                        "Cod. evento" := rEvExp."Cod. Evento";
                        "Descripcion evento" := rEvExp."Descripcion Evento";
                        "Evento dictado por (tipo)" := rEvExp."Tipo de Expositor";
                        "Evento dictado por (codigo)" := rEvExp."Cod. Expositor";
                        "Evento dictado por (nombre)" := rEvExp."Nombre Expositor";
                    end;
                end;
            end;

            trigger OnValidate()
            var
                ExpositorEvento: Record "Expositores - Eventos";
                rEvExp: Record "Expositores - Eventos";
                pEvExp: Page "Expositores - Eventos";
            begin
                if "Cod. evento" <> '' then begin
                    Evento.Get("Tipo de Evento", "Cod. evento");
                    "Descripcion evento" := Evento.Descripcion;
                    Validate("Tipo de Evento", Evento."Tipo de Evento");

                    if "Cod. evento" <> '' then begin
                        rEvExp.Reset;
                        rEvExp.SetRange(rEvExp."Cod. Evento", "Cod. evento");
                        rEvExp.SetRange(rEvExp."Tipo de Evento", "Tipo de Evento");
                        rEvExp.SetRange(rEvExp.Delegacion, Delegacion);
                        pEvExp.SetTableView(rEvExp);
                        pEvExp.LookupMode(true);
                        if pEvExp.RunModal = ACTION::LookupOK then begin
                            pEvExp.GetRecord(rEvExp);
                            "Cod. evento" := rEvExp."Cod. Evento";
                            "Descripcion evento" := rEvExp."Descripcion Evento";
                            "Evento dictado por (tipo)" := rEvExp."Tipo de Expositor";
                            "Evento dictado por (codigo)" := rEvExp."Cod. Expositor";
                            "Evento dictado por (nombre)" := rEvExp."Nombre Expositor";
                        end;
                    end;


                    /*ExpositorEvento.RESET;
                    ExpositorEvento.SETRANGE("Cod. Evento","Cod. evento");
                    ExpositorEvento.SETRANGE(Delegacion,Delegacion);
                    ExpositorEvento.FINDFIRST;
                    "Cod. Expositor"    := ExpositorEvento."Cod. Expositor";
                    "Tipo de Expositor" := ExpositorEvento."Tipo de Expositor";
                    "Nombre expositor"  := ExpositorEvento."Nombre Expositor";*/
                end

            end;
        }
        field(4; Descripcion; Text[80])
        {
        }
        field(5; Delegacion; Code[20])
        {
            TableRelation = "Dimension Value".Code;

            trigger OnLookup()
            begin
                /*
                APSSetup.GET();
                APSSetup.TESTFIELD(APSSetup."Cod. Dimension Delegacion");
                DimVal.RESET;
                DimVal.SETRANGE("Dimension Code",APSSetup."Cod. Dimension Delegacion");
                DimVal.SETRANGE("Dimension Value Type",DimVal."Dimension Value Type"::Standard);
                DimForm.SETTABLEVIEW(DimVal);
                DimForm.SETRECORD(DimVal);
                DimForm.LOOKUPMODE(TRUE);
                IF DimForm.RUNMODAL = ACTION::LookupOK THEN
                   BEGIN
                    DimForm.GETRECORD(DimVal);
                    VALIDATE(Delegacion,DimVal.Code);
                   END;
                
                CLEAR(DimForm);
                */

            end;

            trigger OnValidate()
            begin
                /*
                APSSetup.GET();
                APSSetup.TESTFIELD(APSSetup."Cod. Dimension Delegacion");
                
                IF Delegacion <> '' THEN
                   BEGIN
                    DimVal.RESET;
                    DimVal.SETRANGE("Dimension Code",APSSetup."Cod. Dimension Delegacion");
                    DimVal.SETRANGE("Dimension Value Type",DimVal."Dimension Value Type"::Standard);
                    DimVal.SETRANGE(Code,Delegacion);
                    DimVal.FINDFIRST;
                   END;
                */

            end;
        }
        field(7; "Cod. Nivel"; Code[20])
        {
            TableRelation = "Colegio - Nivel"."Cod. Nivel" WHERE("Cod. Colegio" = FIELD("Cod. Colegio"),
                                                                  "Cod. Promotor" = FIELD("Cod. promotor"));
        }
        field(8; "Cod. Expositor"; Code[20])
        {

            trigger OnValidate()
            begin
                if ExpositorDoc.Get("Cod. Expositor") then begin
                    "Nombre expositor" := ExpositorDoc."Full Name";
                    "Tipo de Expositor" := 0;
                end
                else
                    if ExpositorProv.Get("Cod. Expositor") then begin
                        "Nombre expositor" := ExpositorProv.Name;
                        "Tipo de Expositor" := 0;
                    end
                    else
                        Error(Err001);
            end;
        }
        field(9; Sala; Code[10])
        {
        }
        field(10; "Cod. Colegio"; Code[20])
        {
            TableRelation = "Promotor - Lista de Colegios"."Cod. Colegio" WHERE("Cod. Promotor" = FIELD("Cod. promotor"));

            trigger OnValidate()
            var
                PromotorRutas: Record "Promotor - Rutas";
                ColegioNivel: Record "Colegio - Nivel";
                Docente: Record Docentes;
                wINI: Integer;
                wPRI: Integer;
                wSEC: Integer;
                wING: Integer;
                wPLA: Integer;
                wESI: Integer;
                wGEN: Integer;
                wPSE: Integer;
                wIPR: Integer;
                wIPS: Integer;
                rGrupoCOL: Record "Grupo de Colegios";
                wFiltroColegio: Text[1024];
            begin

                //inicializamos los valores del responsable
                "Tipo Responsable" := 0;
                "Cod. Docente responsable" := '';
                "Nombre responsable" := '';
                "Cod. Cargo Responsable" := '';
                "Descripción Cargo Responsable" := '';
                "Telefono Responsable" := '';
                "No. celular responsable" := '';
                "E-Mail Docente Responsable" := '';

                if "Cod. Colegio" <> '' then begin
                    wFiltroColegio := "Cod. Colegio";
                    Colegio.Get("Cod. Colegio");
                    //Peru  Delegacion       := Colegio.Delegacion;
                    "Nombre Colegio" := Colegio.Name;
                    "Codigo Distrito Colegio" := Colegio.City;
                    //Peru  Departamento     := Colegio.Departamento;
                    //Peru  "Nombre Distrito Colegio"        := Colegio.Distritos;
                    //Peru  Provincia        := Colegio.Provincia;
                    "Territory Code" := Colegio."Territory Code";
                    "Country/Region Code" := Colegio."Country/Region Code";
                    //Peru  "Codigo Postal" := Colegio."Codigo Postal";
                    "Post Code" := Colegio."Post Code";
                    City := Colegio.City;
                    County := Colegio.County;
                    "Direccion Colegio" := Colegio.Address;
                    Referencia := Colegio."Address 2";
                    "Telefono 1 Colegio" := Colegio."Phone No.";
                    "Telefono 2 Colegio" := Colegio."Mobile Phone No.";

                    // Buscamos el nivel

                    "Cod. Nivel" := '';
                    "Cod. Turno" := '';
                    "Cod. Local" := '';
                    PromotorRutas.Reset;
                    PromotorRutas.SetRange("Cod. Promotor", "Cod. promotor");
                    if PromotorRutas.FindSet then begin
                        ColegioNivel.Reset;
                        ColegioNivel.SetRange("Cod. Colegio", "Cod. Colegio");
                        ColegioNivel.SetRange(Ruta, PromotorRutas."Cod. Ruta");
                        if ColegioNivel.FindSet then begin
                            "Cod. Nivel" := ColegioNivel."Cod. Nivel";
                            "Cod. Turno" := ColegioNivel.Turno;
                            "Cod. Local" := ColegioNivel."Cod. Local";
                        end;
                    end;
                    //Busco los Docentes del Colegio
                    CDS(wFiltroColegio);
                end;
            end;
        }
        field(11; "Nombre Colegio"; Text[60])
        {
        }
        field(12; "Cod. Local"; Code[20])
        {
            TableRelation = IF ("Grupo de Colegios" = CONST(false)) "Contact Alt. Address".Code WHERE("Contact No." = FIELD("Cod. Colegio"));
        }
        field(13; "Cod. Turno"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Turnos));
        }
        field(14; "Fecha Solicitud"; Date)
        {
            Editable = false;
        }
        field(15; "Cod. promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            var
                "P-R": Record "Promotor - Rutas";
            begin
                if "Cod. promotor" <> '' then begin
                    Promotor.Get("Cod. promotor");
                    "Nombre promotor" := Promotor.Name;
                    "Tipo Solicitud" := 1;

                    "P-R".Reset;
                    "P-R".SetRange("Cod. Promotor", "Cod. promotor");
                    "P-R".FindFirst;
                    Ruta := "P-R"."Cod. Ruta";
                    APSSetup.Get();
                    if APSSetup."Cod. Dimension Delegacion" <> '' then begin
                        DefDim.Reset;
                        DefDim.SetRange("Table ID", 13);
                        DefDim.SetRange("No.", "Cod. promotor");
                        DefDim.SetRange("Dimension Code", APSSetup."Cod. Dimension Delegacion");
                        DefDim.FindFirst;

                        DimVal.Reset;
                        DimVal.SetRange("Dimension Code", APSSetup."Cod. Dimension Delegacion");
                        DimVal.SetRange(Code, DefDim."Dimension Value Code");
                        DimVal.FindFirst;
                        Delegacion := DimVal.Code;
                    end;
                end;
            end;
        }
        field(16; "Nombre promotor"; Text[60])
        {
        }
        field(17; "Telefono 1 Colegio"; Text[30])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(18; Status; Option)
        {
            OptionCaption = ' ,Sent by salesperson,Approved,Programmed,Voided,Rejected,Done';
            OptionMembers = " ","Enviada por promotor",Aprobada,Programada,Cancelada,Rechazada,Realizada;
        }
        field(19; "Asistentes Esperados"; Integer)
        {

            trigger OnValidate()
            begin
                Actualiza_AsistEsperados;
            end;
        }
        field(20; Observaciones; Text[200])
        {
        }
        field(21; "Cod. Docente responsable"; Code[20])
        {
            TableRelation = "Colegio - Docentes"."Cod. Docente" WHERE("Cod. Colegio" = FIELD("Cod. Colegio"),
                                                                       "Pertenece al CDS" = CONST(true));

            trigger OnLookup()
            var
                rColDoc: Record "Colegio - Docentes";
                pColDoc: Page "Lista Colegio - Docentes";
            begin

                //"Colegio - Docentes"."Cod. Docente" WHERE (Cod. Colegio=FIELD(Cod. Colegio),Pertenece al CDS=CONST(Yes))
                if "Tipo Responsable" = "Tipo Responsable"::CDS then begin
                    rColDoc.Reset;
                    rColDoc.SetRange("Cod. Colegio", "Cod. Colegio");
                    rColDoc.SetRange("Pertenece al CDS", true);
                    pColDoc.SetTableView(rColDoc);
                    pColDoc.LookupMode(true);
                    if pColDoc.RunModal = ACTION::LookupOK then begin
                        pColDoc.GetRecord(rColDoc);
                        Validate("Cod. Docente responsable", rColDoc."Cod. Docente");
                    end;
                end;
            end;

            trigger OnValidate()
            var
                ColDoc: Record "Colegio - Docentes";
            begin
                if ExpositorDoc.Get("Cod. Docente responsable") then begin
                    "Nombre responsable" := ExpositorDoc."Full Name";
                    "Telefono Responsable" := ExpositorDoc."Phone No.";
                    "No. celular responsable" := ExpositorDoc."Mobile Phone No.";
                    "E-Mail Docente Responsable" := ExpositorDoc."E-Mail";
                    ColDoc.SetRange("Cod. Colegio", "Cod. Colegio");
                    ColDoc.SetRange("Cod. Docente", "Cod. Docente responsable");
                    if ColDoc.FindSet then begin
                        "Cod. Cargo Responsable" := ColDoc."Cod. Cargo";
                        "Descripción Cargo Responsable" := ColDoc."Descripcion Cargo";
                    end;
                end;
            end;
        }
        field(22; "Nombre responsable"; Text[80])
        {
        }
        field(23; "No. celular responsable"; Text[30])
        {
        }
        field(24; "Objetivo promotor"; Text[200])
        {
        }
        field(25; "Descripcion evento"; Text[100])
        {
        }
        field(26; "Evento programado"; Boolean)
        {
        }
        field(27; "Fecha invitacion"; Date)
        {
        }
        field(28; "Horas programadas"; Decimal)
        {
        }
        field(29; "Asistentes Reales"; Integer)
        {
        }
        field(30; "Eventos programados"; Integer)
        {
        }
        field(31; "Importe Gasto Expositor"; Decimal)
        {
        }
        field(32; "Importe Gasto mensajeria"; Decimal)
        {
        }
        field(33; "ImporteGastos Impresion"; Decimal)
        {
        }
        field(34; "Importe Utiles"; Decimal)
        {
        }
        field(35; "Importe Atenciones"; Decimal)
        {
        }
        field(36; "Otros Importes"; Decimal)
        {
        }
        field(37; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(38; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(39; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(40; "Filtro Promotor"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Salesperson/Purchaser" WHERE(Tipo = FILTER(Vendedor));
        }
        field(41; "Filtro Colegio"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Contact;
        }
        field(42; "Nombre expositor"; Text[60])
        {
        }
        field(43; "KPI Status"; BLOB)
        {
            Caption = 'Status';
            SubType = Bitmap;
        }
        field(44; "Cod. objetivo promotor"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Objetivos));

            trigger OnValidate()
            begin
                if "Cod. objetivo promotor" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::Objetivos);
                    DA.SetRange(Codigo, "Cod. objetivo promotor");
                    DA.FindFirst;
                    "Objetivo promotor" := DA.Descripcion;
                end;
            end;
        }
        field(45; "Comentario Aprobado"; Text[200])
        {
        }
        field(46; "Comentario Programado"; Text[200])
        {
        }
        field(47; "Comentario Rechazado"; Text[200])
        {
        }
        field(48; "Comentario Cancelado"; Text[200])
        {
        }
        field(49; "Grupo de Negocio"; Code[20])
        {
            Caption = 'Business Group';
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Grupo de Negocio"));
        }
        field(50; Referencia; Text[60])
        {
        }
        field(51; "Telefono Responsable"; Text[30])
        {
        }
        field(52; "Celular Responsable"; Text[30])
        {
        }
        field(53; "Col. tiene equipo MM"; Boolean)
        {
        }
        field(54; Refrigerio; Boolean)
        {
        }
        field(55; Material; Boolean)
        {
        }
        field(56; Merchandising; Boolean)
        {
        }
        field(57; "Desc. del Evento no existe"; Text[100])
        {
            Caption = 'Non exist Event name';
        }
        field(58; "Tipo de Expositor"; Option)
        {
            OptionCaption = 'Teacher,Vendor';
            OptionMembers = Docente,Proveedor;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;
        }
        field(53501; "Codigo Distrito Colegio"; Code[10])
        {
            Caption = 'Codigo Distrito Colegio';
            Description = 'Peru';
            Enabled = false;
        }
        field(53502; Departamento; Text[30])
        {
            Caption = 'District';
            Description = 'Peru';
            Enabled = false;
        }
        field(53503; "Nombre Distrito Colegio"; Text[30])
        {
            Description = 'Peru';
            Enabled = false;
        }
        field(53504; Provincia; Text[30])
        {
            Description = 'Peru';
            Enabled = false;
        }
        field(53505; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            Description = 'Peru';
            Enabled = false;
            TableRelation = Territory;
        }
        field(53506; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            Description = 'Peru';
            Enabled = false;
            TableRelation = "Country/Region";
        }
        field(76012; "Codigo Postal"; Code[10])
        {
        }
        field(76034; "Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            TableRelation = Contact."Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(76014; City; Text[30])
        {
            Caption = 'City';
            TableRelation = Contact.City;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(76422; County; Text[30])
        {
            Caption = 'State';
        }
        field(76127; "Direccion Colegio"; Text[100])
        {
        }
        field(76357; "Tipo Solicitud"; Option)
        {
            OptionCaption = 'School,Salesperson';
            OptionMembers = Colegio,Promotor;
        }
        field(76230; Ruta; Code[20])
        {
        }
        field(76101; "Asistencia promotor"; Boolean)
        {
        }
        field(76379; "Material para revisión"; Boolean)
        {
        }
        field(76380; "Editorial Competencia"; Code[20])
        {
            TableRelation = Editoras.Code;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                ED: Record Editoras;
            begin
                "Nombre Editorial Competencia" := '';
                if ED.Get("Editorial Competencia") then
                    "Nombre Editorial Competencia" := ED.Description;
            end;
        }
        field(76417; "Nombre Editorial Competencia"; Text[80])
        {
        }
        field(76291; "Artículo Competencia"; Code[10])
        {
            TableRelation = "Libros Competencia"."Cod. Libro" WHERE("Cod. Editorial" = FIELD("Editorial Competencia"));

            trigger OnValidate()
            var
                Lib: Record "Libros Competencia";
            begin
                "Desc.  Competencia" := '';
                Lib.SetRange(Lib."Cod. Editorial", "Editorial Competencia");
                Lib.SetRange(Lib."Cod. Libro", "Artículo Competencia");
                if Lib.FindSet then
                    "Desc.  Competencia" := Lib.Description;
            end;
        }
        field(76226; "Desc.  Competencia"; Text[120])
        {
        }
        field(76321; "E-Mail Docente Responsable"; Text[40])
        {
        }
        field(76322; INI; Integer)
        {
        }
        field(76359; PRI; Integer)
        {
        }
        field(76106; SEC; Integer)
        {
        }
        field(76225; ING; Integer)
        {
        }
        field(76096; PLA; Integer)
        {
        }
        field(76097; "Nivel Asistente"; Integer)
        {
            CalcFormula = Count("Solicitud -  Nivel Asistente" WHERE("No. Solicitud" = FIELD("No. Solicitud")));
            FieldClass = FlowField;
        }
        field(76086; "Grado Asistente"; Integer)
        {
            CalcFormula = Count("Solicitud -  Grado Asistente" WHERE("No. Solicitud" = FIELD("No. Solicitud")));
            FieldClass = FlowField;
        }
        field(76209; "Especialidad Asistente"; Integer)
        {
            CalcFormula = Count("Solicitud -  Especialidad Asi." WHERE("No. Solicitud" = FIELD("No. Solicitud")));
            FieldClass = FlowField;
        }
        field(76426; "Selección Editorial"; Option)
        {
            OptionCaption = 'Santillana,Competencia';
            OptionMembers = Santillana,Competencia;
        }
        field(76290; "Artículo Grupo Santillana"; Code[20])
        {
            TableRelation = "Historico Adopciones"."Cod. producto" WHERE("Cod. Colegio" = FIELD("Cod. Colegio"));

            trigger OnLookup()
            var
                Adop: Record "Historico Adopciones";
                fAdop: Page "Colegio - Historico adopciones";
            begin

                Adop.FilterGroup(2);
                Adop.SetRange("Cod. Colegio", "Cod. Colegio");
                Adop.FilterGroup(0);
                fAdop.SetTableView(Adop);
                fAdop.LookupMode(true);
                if fAdop.RunModal = ACTION::LookupOK then begin
                    fAdop.GetRecord(Adop);
                    "Desc. Artículo Grupo Santillan" := Adop."Nombre Libro";
                    "Año Adopción" := Adop.Campana;
                end;
            end;
        }
        field(76219; "Desc. Artículo Grupo Santillan"; Text[80])
        {
        }
        field(76262; "Horas por semana"; Decimal)
        {
        }
        field(76133; "Año Adopción"; Code[4])
        {
        }
        field(76366; ESI; Integer)
        {
        }
        field(76365; GEN; Integer)
        {
        }
        field(76109; IPR; Integer)
        {
        }
        field(76110; IPS; Integer)
        {
        }
        field(76129; PSE; Integer)
        {
        }
        field(76411; "Tipo Responsable"; Option)
        {
            OptionCaption = 'CDS,Otro';
            OptionMembers = CDS,Otro;

            trigger OnValidate()
            begin
                "Cod. Docente responsable" := '';
                "Nombre responsable" := '';
                "Cod. Cargo Responsable" := '';
                "Descripción Cargo Responsable" := '';
                "Telefono Responsable" := '';
                "No. celular responsable" := '';
                "E-Mail Docente Responsable" := '';
            end;
        }
        field(76308; "Telefono 2 Colegio"; Text[30])
        {
        }
        field(76276; "Avisado al expositor"; Boolean)
        {
        }
        field(76139; "Cod. Cargo Responsable"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Puestos de trabajo"));

            trigger OnValidate()
            begin
                if "Cod. Cargo Responsable" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::"Puestos de trabajo");
                    DA.SetRange(Codigo, "Cod. Cargo Responsable");
                    DA.FindFirst;
                    "Descripción Cargo Responsable" := DA.Descripcion;
                end;
            end;
        }
        field(76140; "Descripción Cargo Responsable"; Text[60])
        {
            Editable = false;
        }
        field(76138; "Cod. evento programado"; Code[20])
        {
            TableRelation = Eventos."No." WHERE("Tipo de Evento" = FIELD("Tipo de Evento"));

            trigger OnLookup()
            var
                rEvExp: Record "Expositores - Eventos";
                pEvExp: Page "Expositores - Eventos";
                NewSecEvProg: Integer;
            begin

                rEvExp.Reset;
                rEvExp.SetRange(rEvExp."Tipo de Evento", "Tipo de Evento");
                rEvExp.SetRange(rEvExp.Delegacion, Delegacion);
                pEvExp.SetTableView(rEvExp);
                pEvExp.LookupMode(true);
                if pEvExp.RunModal = ACTION::LookupOK then begin
                    pEvExp.GetRecord(rEvExp);

                    if ("Cod. evento programado" <> rEvExp."Cod. Evento") or
                       ("Cod. Expositor" <> rEvExp."Cod. Expositor") or
                       ("Tipo de Expositor" <> rEvExp."Tipo de Expositor") then
                        NewSecEvProg := ActualizaPlanif(rEvExp);

                    "Cod. evento programado" := rEvExp."Cod. Evento";
                    "Descripción evento programado" := rEvExp."Descripcion Evento";
                    "Tipo de Expositor" := rEvExp."Tipo de Expositor";
                    "Cod. Expositor" := rEvExp."Cod. Expositor";
                    "Nombre expositor" := rEvExp."Nombre Expositor";

                    if NewSecEvProg <> 0 then
                        "Secuencia Cod. Evento Progr." := NewSecEvProg;
                    Modify;

                end;
            end;

            trigger OnValidate()
            var
                ExpositorEvento: Record "Expositores - Eventos";
                rEvExp: Record "Expositores - Eventos";
                pEvExp: Page "Expositores - Eventos";
                Err0001: Label 'No existe ningún expositor para el evento programado %1.';
                CabPlanEvento: Record "Cab. Planif. Evento";
                Err002: Label 'Esta solicitud ya está programada para el Evento: %1 Expositor: %2 (%3) Secuencia: %4';
                NewSecEvProg: Integer;
            begin
                if "Cod. evento programado" <> '' then begin
                    //CabPlanEvento.RESET;
                    //CabPlanEvento.SETRANGE("No. Solicitud","No. Solicitud");
                    //IF CabPlanEvento.FINDSET THEN
                    //  ERROR(Err002, CabPlanEvento."Cod. Taller - Evento",CabPlanEvento.Expositor,CabPlanEvento."Tipo de Expositor",
                    //       CabPlanEvento.Secuencia);

                    Evento.Get("Tipo de Evento", "Cod. evento programado");
                    "Descripción evento programado" := Evento.Descripcion;
                    Validate("Tipo de Evento", Evento."Tipo de Evento");

                    rEvExp.Reset;
                    rEvExp.SetRange(rEvExp."Cod. Evento", "Cod. evento programado");
                    rEvExp.SetRange(rEvExp."Tipo de Evento", "Tipo de Evento");
                    rEvExp.SetRange(rEvExp.Delegacion, Delegacion);
                    if not rEvExp.FindSet then
                        Error(Err0001, "Cod. evento programado");
                    pEvExp.SetTableView(rEvExp);
                    pEvExp.LookupMode(true);
                    if pEvExp.RunModal = ACTION::LookupOK then begin
                        pEvExp.GetRecord(rEvExp);

                        if ("Cod. evento programado" <> rEvExp."Cod. Evento") or
                           ("Cod. Expositor" <> rEvExp."Cod. Expositor") or
                           ("Tipo de Expositor" <> rEvExp."Tipo de Expositor") then
                            NewSecEvProg := ActualizaPlanif(rEvExp);

                        "Cod. evento programado" := rEvExp."Cod. Evento";
                        "Descripción evento programado" := rEvExp."Descripcion Evento";
                        "Tipo de Expositor" := rEvExp."Tipo de Expositor";
                        "Cod. Expositor" := rEvExp."Cod. Expositor";
                        "Nombre expositor" := rEvExp."Nombre Expositor";
                        if NewSecEvProg <> 0 then
                            "Secuencia Cod. Evento Progr." := NewSecEvProg;
                        Modify;
                    end;

                end
                // else
            end;
        }
        field(76369; "Descripción evento programado"; Text[100])
        {
            Editable = false;
        }
        field(76361; "Evento dictado por (codigo)"; Code[20])
        {
            TableRelation = IF ("Evento dictado por (tipo)" = CONST(Docente)) Docentes WHERE(Expositor = CONST(true))
            ELSE
            IF ("Evento dictado por (tipo)" = CONST(Proveedor)) Vendor;
        }
        field(76281; "Evento dictado por (nombre)"; Text[80])
        {
        }
        field(76286; "Existe evento"; Boolean)
        {
            InitValue = true;

            trigger OnValidate()
            begin
                "Cod. evento" := '';
                "Descripcion evento" := '';
                "Evento dictado por (tipo)" := 0;
                "Evento dictado por (codigo)" := '';
                "Evento dictado por (nombre)" := '';
            end;
        }
        field(76287; "Evento dictado por (tipo)"; Option)
        {
            OptionCaption = 'Teacher,Vendor';
            OptionMembers = Docente,Proveedor;
        }
        field(76292; "Grupo de Colegios"; Boolean)
        {

            trigger OnValidate()
            begin
                /*"Cod. Colegio/Grupo"             := '';
                "Nombre Colegio"           := '';
                "Direccion Colegio"        := '';
                "Codigo Distrito Colegio"  := '';
                "Nombre Distrito Colegio"  := '';
                "Telefono 1 Colegio"       := '';
                "Telefono 2 Colegio"       := '';
                */

            end;
        }
        field(76299; "Asociacion/Grupo"; Code[20])
        {
            TableRelation = IF ("Cod. Colegio" = FILTER(<> '')) "Grupo - Colegios"."Cod. grupo" WHERE("Cod. Colegio" = FIELD("Cod. Colegio"));

            trigger OnValidate()
            var
                rGrupoCOL: Record "Grupo de Colegios";
                wFiltroColegio: Text[1024];
            begin
                //Busco los Docentes del Colegio
                if ("Asociacion/Grupo" <> '') then begin
                    rGrupoCOL.Get("Asociacion/Grupo");
                    rGrupoCOL.CheckGrupo();
                    wFiltroColegio := rGrupoCOL.GetColegios();
                    CDS(wFiltroColegio);
                end;
            end;
        }
        field(76277; "Usuario creación"; Code[50])
        {
            Editable = false;
        }
        field(76275; "Fecha Propuesta"; Date)
        {
        }
        field(76216; "Fecha programada"; Date)
        {
            CalcFormula = Lookup("Programac. Talleres y Eventos"."Fecha programacion" WHERE("Cod. Taller - Evento" = FIELD("Cod. evento programado"),
                                                                                             "Tipo de Expositor" = FIELD("Tipo de Expositor"),
                                                                                             Expositor = FIELD("Cod. Expositor"),
                                                                                             Secuencia = FIELD("Secuencia Cod. Evento Progr.")));
            FieldClass = FlowField;
        }
        field(76370; "Secuencia Cod. Evento Progr."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "No. Solicitud")
        {
            Clustered = true;
        }
        key(Key2; "Cod. promotor", "No. Solicitud")
        {
        }
        key(Key3; "Nombre promotor")
        {
        }
        key(Key4; "Cod. Expositor")
        {
        }
        key(Key5; "Nombre expositor")
        {
        }
        key(Key6; "Fecha Propuesta")
        {
        }
        key(Key7; "Grupo de Negocio")
        {
        }
        key(Key8; "Cod. Colegio")
        {
        }
        key(Key9; "Cod. promotor", "Cod. Colegio")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No. Solicitud" = '' then begin
            APSSetup.Get;
            APSSetup.TestField("No. Serie Solic. T-E");
            //NoSeriesMgt.InitSeries(APSSetup."No. Serie Solic. T-E", xRec."No. Series", 0D, "No. Solicitud", "No. Series");
            Rec."No. series" := APSSetup."No. Serie Solic. T-E";
            if NoSeriesMgt.AreRelated(APSSetup."No. Serie Solic. T-E", xRec."No. Series") then
                Rec."No. Series" := xRec."No. Series";
            Rec."No. Solicitud" := NoSeriesMgt.GetNextNo(Rec."No. Series");
        end;

        "Fecha Solicitud" := Today;
        "Usuario creación" := UserId;

        if User.Get(UserId) then
            if User."Salespers./Purch. Code" <> '' then
                Validate("Cod. promotor", User."Salespers./Purch. Code");
    end;

    trigger OnModify()
    var
        rCabPlan: Record "Cab. Planif. Evento";
    begin
        if FRBitMap.Get(Status) then begin
            FRBitMap.CalcFields(Bitmap);
            "KPI Status" := FRBitMap.Bitmap;
        end;

        if (Status = Status::Realizada) then begin
            if rCabPlan.Get("No. Solicitud") then begin
                rCabPlan.Estado := rCabPlan.Estado::Realizado;
                rCabPlan.Modify;
            end;
        end;

        if (Status = Status::Cancelada) or (Status = Status::Rechazada) then begin
            if rCabPlan.Get("No. Solicitud") then begin
                rCabPlan.Estado := rCabPlan.Estado::Anulado;
                rCabPlan.Modify;
            end;
        end;
    end;

    var
        SolEvento: Record "Solicitud de Taller - Evento";
        User: Record "User Setup";
        Evento: Record Eventos;
        APSSetup: Record "Commercial Setup";
        TipoEvento: Record "Tipos de Eventos";
        ExpositorDoc: Record Docentes;
        ExpositorProv: Record Vendor;
        Colegio: Record Contact;
        Promotor: Record "Salesperson/Purchaser";
        FRBitMap: Record "FlagsInRepeater Bitmaps";
        DA: Record "Datos auxiliares";
        ColDocentes: Record "Colegio - Docentes";
        ATE: Record "Asistentes Talleres y Eventos";
        DefDim: Record "Default Dimension";
        DimVal: Record "Dimension Value";
        PostCode: Record "Post Code";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        Err001: Label 'The Exponent doesn''t exist either as Teacher or Vendor';
        DimForm: Page "Dimension Value List";


    procedure AssistEdit(OldEvent: Record "Solicitud de Taller - Evento"): Boolean
    var
        WorkShop: Record Talleres;
    begin
        SolEvento := Rec;
        APSSetup.Get;
        APSSetup.TestField("No. Serie Solic. T-E");
        if NoSeriesMgt.LookupRelatedNoSeries(APSSetup."No. Serie Solic. T-E", OldEvent."No. Series", SolEvento."No. Series") then begin
            APSSetup.Get;
            APSSetup.TestField("No. Serie Solic. T-E");
            NoSeriesMgt.GetNextNo(SolEvento."No. Solicitud");
            Rec := SolEvento;
            exit(true);
        end;
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20]; Type4: Integer; No4: Code[20]; Type5: Integer; No5: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.Get;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        TableID[4] := Type4;
        No[4] := No4;
        TableID[5] := Type5;
        No[5] := No5;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        //DimMgt.GetDefaultDim(
        //  TableID,No,SourceCodeSetup.Sales,
        //  "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        //IF "No. Solicitud" <> '' THEN
        //  DimMgt.UpdateDocDefaultDim(
        //    DATABASE::"Solicitud de Taller - Evento",0,"No. Solicitud",0,
        //    "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");

        OldDimSetID := "Dimension Set ID";
        /*  "Dimension Set ID" :=
           DimMgt.GetDefaultDimID(TableID, No, SourceCodeSetup.Sales, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0); */
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        ChangeLogMgt: Codeunit "Change Log Management";
        RecRef: RecordRef;
        xRecRef: RecordRef;
        OldDimSetID: Integer;
    begin
        //DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        //IF "No. Solicitud" <> '' THEN BEGIN
        //  DimMgt.SaveDocDim(
        //    DATABASE::"Solicitud de Taller - Evento",0,"No. Solicitud",0,FieldNumber,ShortcutDimCode);
        //  xRecRef.GETTABLE(xRec);
        //  MODIFY;
        //  RecRef.GETTABLE(Rec);
        //  ChangeLogMgt.LogModification(RecRef,xRecRef);
        //END ELSE
        //  DimMgt.SaveTempDim(FieldNumber,ShortcutDimCode);

        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No. Solicitud" <> '' then
            Modify;
    end;


    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        //DocDim.SETRANGE("Table ID",DATABASE::"Solicitud de Taller - Evento");
        //DocDim.SETRANGE("Document Type",0);
        //DocDim.SETRANGE("Document No.","No. Solicitud");
        //DocDim.SETRANGE("Line No.",0);
        //DocDims.SETTABLEVIEW(DocDim);
        //DocDims.RUNMODAL;
        //GET("No. Solicitud");


        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", StrSubstNo('%1 %2', 0, "No. Solicitud"),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then
            Modify;
    end;


    procedure Valida_Programado()
    var
        Err001: Label 'Debe asignar un evento programado.';
        Err002: Label 'El evento programado no existe.';
        Ev: Record "Cab. Planif. Evento";
        rProgramac: Record "Programac. Talleres y Eventos";
        Error004: Label 'No ha realizado la programación de fechas.';
        Error005: Label 'En la programación de fechas es obligatorio indicar los siguientes campos: Fecha programación, Hora de Inicio y Hora Final.';
        rCab: Record "Cab. Planif. Evento";
        rGrupo: Record "Grupo de Colegios";
        Err003: Label 'No existe el grupo de colegio %1';
        Err006: Label 'No existe el colegio %1';
        rCol: Record Contact;
    begin

        //VALIDAMOS QUE EXISTA EL GRUPO O EL COLEGIO
        if "Grupo de Colegios" then begin
            if not rGrupo.Get("Asociacion/Grupo") then
                Error(Err003, "Asociacion/Grupo");
        end
        else
            if not rCol.Get("Cod. Colegio") then
                Error(Err006, "Cod. Colegio");



        //Evento
        TestField("Tipo de Evento");
        TestField("Cod. evento programado");
        Ev.Reset;
        Ev.SetRange("Cod. Taller - Evento", "Cod. evento programado");
        if not Ev.FindFirst then
            Error(Err002);
        TestField("Cod. Expositor");

        rCab.Reset;
        rCab.SetRange("No. Solicitud", "No. Solicitud");
        rCab.FindFirst;

        rProgramac.SetRange("Tipo Evento", "Tipo de Evento");
        rProgramac.SetRange(rProgramac."Cod. Taller - Evento", "Cod. evento programado");
        rProgramac.SetRange("Tipo de Expositor", "Tipo de Expositor");
        rProgramac.SetRange(Expositor, "Cod. Expositor");
        rProgramac.SetRange(Secuencia, rCab.Secuencia);
        if not rProgramac.FindSet then
            Error(Error004);
        repeat
            if (rProgramac."Fecha programacion" = 0D) or (rProgramac."Hora de Inicio" = 0T) or (rProgramac."Hora Final" = 0T) then
                Error(Error005);
        until rProgramac.Next = 0;
    end;


    procedure Valida_Aprobado()
    var
        Distr: Record "Dis. Centros Costo";
        Porc: Decimal;
        Err001: Label 'Debe realizar la distribución de los centros de costo';
        Err002: Label 'No se han realizado la distribución de los centros de costo correctamente';
    begin

        Valida_Enviado;

        TestField("Cod. Colegio");

        Distr.SetRange("No. Solicitud", "No. Solicitud");
        if not Distr.FindSet then
            Error(Err001);

        repeat
            Porc += Distr.Porcentaje;
        until Distr.Next = 0;

        if Porc <> 100 then
            Error(Err002);
    end;


    procedure Valida_Enviado()
    var
        rNiveles: Record "Solicitud -  Nivel Asistente";
        rGrados: Record "Solicitud -  Grado Asistente";
        rEsp: Record "Solicitud -  Especialidad Asi.";
        Error001: Label 'No ha indicado los Niveles de los asistentes.';
        Error002: Label 'No ha indicado los Grados de los asistentes.';
        Error003: Label 'No ha indicado las especialidades de los asistentes.';
        rFechasProp: Record "Solicitud - Proposición Fechas";
        Error004: Label 'No ha realizado la proposición de fechas.';
        Error005: Label 'En la proposicion de fechas es obligatorio indicar los siguientes campos: fecha, hora de inicio y hora fin';
        rTipoEve: Record "Tipos de Eventos";
        rLibrosPres: Record "Solicitud - Libros presentar";
        Error006: Label 'Es obligatorio ingresar los libros a presentar.';
        wFec: Date;
        Error007: Label 'Se ha ingresado más de una fecha diferente. ';
    begin

        TestField("No. Solicitud");
        TestField(Delegacion);
        TestField("Cod. promotor");
        TestField("Grupo de Negocio");
        TestField("Cod. Colegio");
        //TESTFIELD("Cod. Local");
        TestField("Tipo de Evento");
        if "Cod. evento" = '' then
            TestField("Descripcion evento");

        case "Tipo Responsable" of
            "Tipo Responsable"::CDS:
                begin
                    TestField("Cod. Cargo Responsable");
                end;
            "Tipo Responsable"::Otro:
                begin
                    TestField("Nombre responsable");
                    TestField("Cod. Cargo Responsable");
                end
        end;

        TestField("Telefono Responsable");
        TestField("No. celular responsable");
        TestField("E-Mail Docente Responsable");
        TestField("Cod. objetivo promotor");

        rNiveles.SetRange(rNiveles."No. Solicitud", "No. Solicitud");
        if not rNiveles.FindFirst then
            Error(Error001);
        //rGrados.SETRANGE(rGrados."No. Solicitud", "No. Solicitud");
        //IF NOT rGrados.FINDFIRST THEN
        // ERROR(Error002);

        //rEsp.SETRANGE(rEsp."No. Solicitud", "No. Solicitud");
        //IF NOT rEsp.FINDFIRST THEN
        //  ERROR(Error003);
        TestField("Asistentes Esperados");

        Clear(wFec);
        rFechasProp.SetRange(rFechasProp."No. Solicitud", "No. Solicitud");
        if not rFechasProp.FindSet then
            Error(Error004);
        repeat
            if (rFechasProp."Fecha propuesta" = 0D) or (rFechasProp."Hora Inicio" = 0T) or (rFechasProp."Hora Fin" = 0T) then
                Error(Error005);
            if wFec = 0D then
                wFec := rFechasProp."Fecha propuesta"
            else begin
                if wFec <> rFechasProp."Fecha propuesta" then
                    Error(Error007);
            end;

            if ("Tipo de Evento" <> '') and (rTipoEve.Get("Tipo de Evento")) then
                if rTipoEve."Ingresar grados" then begin
                    rFechasProp.TestField("Cod. Grado");
                    rFechasProp.TestField("No. asistentes");
                end;
        until rFechasProp.Next = 0;

        if ("Tipo de Evento" <> '') and (rTipoEve.Get("Tipo de Evento")) then
            if (rTipoEve."Ingresar libros a presentar") and ("Material para revisión") then begin
                rLibrosPres.Reset;
                rLibrosPres.SetRange("Núm. Solicitud", "No. Solicitud");
                if not rLibrosPres.FindSet then
                    Error(Error006);
            end;
    end;


    procedure Crear_Planificacion()
    var
        CabPlanEvento: Record "Cab. Planif. Evento";
        FechasProp: Record "Solicitud - Proposición Fechas";
        ProgTyE: Record "Programac. Talleres y Eventos";
    begin

        CabPlanEvento.Reset;
        CabPlanEvento.Validate("Tipo Evento", "Tipo de Evento");
        CabPlanEvento.Validate("Cod. Taller - Evento", "Cod. evento programado");
        CabPlanEvento.Validate("Tipo de Expositor", "Tipo de Expositor");
        CabPlanEvento.Validate(Expositor, "Cod. Expositor");
        CabPlanEvento."Nombre Expositor" := "Nombre expositor";
        CabPlanEvento.Validate("No. Solicitud", "No. Solicitud");
        if "Cod. Colegio" <> '' then
            CabPlanEvento.Validate("Cod. Colegio", "Cod. Colegio");
        if "Cod. promotor" <> '' then
            CabPlanEvento.Validate("Cod. Promotor", "Cod. promotor");
        CabPlanEvento."Asistentes esperados" := "Asistentes Esperados";
        CabPlanEvento.Insert(true);
        FechasProp.Reset;
        FechasProp.SetRange("No. Solicitud", "No. Solicitud");
        FechasProp.FindSet;
        repeat
            Clear(ProgTyE);
            ProgTyE.Validate("Cod. Taller - Evento", "Cod. evento programado");
            ProgTyE.Validate("Tipo Evento", "Tipo de Evento");
            ProgTyE.Validate("Tipo de Expositor", "Tipo de Expositor");
            ProgTyE.Validate(Expositor, "Cod. Expositor");
            ProgTyE."Nombre Expositor" := CabPlanEvento."Nombre Expositor";
            ProgTyE.Validate("Cod. Colegio", CabPlanEvento."Cod. Colegio");
            ProgTyE.Validate("Cod. Promotor", CabPlanEvento."Cod. Promotor");
            ProgTyE."Fecha propuesta" := FechasProp."Fecha propuesta";
            ProgTyE."Hora Inicio Propuesta" := FechasProp."Hora Inicio";
            ProgTyE."Hora Fin Propuesta" := FechasProp."Hora Fin";
            ProgTyE.Secuencia := CabPlanEvento.Secuencia;
            ProgTyE."Cod. Grado" := FechasProp."Cod. Grado";
            if FechasProp."Cod. Grado" <> '' then
                ProgTyE."Asistentes esperados" := FechasProp."No. asistentes"
            else
                ProgTyE."Asistentes esperados" := "Asistentes Esperados";

            ProgTyE.Insert(true);
        until (FechasProp.Next = 0);

        "Secuencia Cod. Evento Progr." := CabPlanEvento.Secuencia;
        Modify;
    end;


    procedure Tiene_Planificacion(): Boolean
    var
        CabPlanEvento: Record "Cab. Planif. Evento";
    begin
        CabPlanEvento.Reset;
        CabPlanEvento.SetRange("No. Solicitud", "No. Solicitud");
        exit(CabPlanEvento.FindFirst);
    end;


    procedure Valida_Realizado()
    var
        rProgramac: Record "Programac. Talleres y Eventos";
        rCab: Record "Cab. Planif. Evento";
        Error004: Label 'No ha realizado la programación de fechas.';
        Error005: Label 'En la programación, no se ha indicado las horas dictadas ';
    begin

        TestField("Asistentes Reales");

        rCab.Reset;
        rCab.SetRange("No. Solicitud", "No. Solicitud");
        rCab.FindFirst;

        rProgramac.SetRange("Tipo Evento", "Tipo de Evento");
        rProgramac.SetRange(rProgramac."Cod. Taller - Evento", "Cod. evento programado");
        rProgramac.SetRange("Tipo de Expositor", "Tipo de Expositor");
        rProgramac.SetRange(Expositor, "Cod. Expositor");
        rProgramac.SetRange(Secuencia, rCab.Secuencia);
        if not rProgramac.FindSet then
            Error(Error004);
        repeat
            if (rProgramac."Horas dictadas" = 0) then
                Error(Error005);
        until rProgramac.Next = 0;
    end;


    procedure Actualiza_AsistEsperados()
    var
        CabPlanEvento: Record "Cab. Planif. Evento";
        ProgTyE: Record "Programac. Talleres y Eventos";
    begin
        CabPlanEvento.Reset;
        CabPlanEvento.SetRange("Tipo Evento", "Tipo de Evento");
        CabPlanEvento.SetRange("Cod. Taller - Evento", "Cod. evento programado");
        CabPlanEvento.SetRange("Tipo de Expositor", "Tipo de Expositor");
        CabPlanEvento.SetRange(Expositor, "Cod. Expositor");
        CabPlanEvento.SetRange("No. Solicitud", "No. Solicitud");
        if CabPlanEvento.FindSet() then begin
            CabPlanEvento."Asistentes esperados" := "Asistentes Esperados";
            CabPlanEvento.Modify;
            ProgTyE.Reset;
            ProgTyE.SetRange("Cod. Taller - Evento", "Cod. evento programado");
            ProgTyE.SetRange("Tipo Evento", "Tipo de Evento");
            ProgTyE.SetRange("Tipo de Expositor", "Tipo de Expositor");
            ProgTyE.SetRange(Expositor, "Cod. Expositor");
            ProgTyE.SetRange(Secuencia, CabPlanEvento.Secuencia);
            ProgTyE.SetFilter("Cod. Grado", '<>%1', '');
            if ProgTyE.FindSet() then
                repeat
                    ProgTyE."Asistentes esperados" := "Asistentes Esperados";
                    ProgTyE.Modify;
                until (ProgTyE.Next = 0);
        end;
    end;


    procedure GetFechaPropuesta() rtnFecha: Date
    var
        PropFechas: Record "Solicitud - Proposición Fechas";
    begin

        Clear(rtnFecha);
        PropFechas.Reset;
        PropFechas.SetRange("No. Solicitud", "No. Solicitud");
        if PropFechas.FindFirst then
            rtnFecha := PropFechas."Fecha propuesta";
    end;


    procedure GetFechaProgramada() rtnFecha: Date
    var
        recCabPlan: Record "Cab. Planif. Evento";
        recProgramacion: Record "Programac. Talleres y Eventos";
    begin
        Clear(rtnFecha);
        recCabPlan.Reset;
        recCabPlan.SetRange(recCabPlan."No. Solicitud", "No. Solicitud");
        if recCabPlan.FindSet then begin
            recProgramacion.Reset;
            recProgramacion.SetRange("Cod. Taller - Evento", recCabPlan."Cod. Taller - Evento");
            recProgramacion.SetRange("Tipo Evento", recCabPlan."Tipo Evento");
            recProgramacion.SetRange("Tipo de Expositor", recCabPlan."Tipo de Expositor");
            recProgramacion.SetRange(Expositor, recCabPlan.Expositor);
            recProgramacion.SetRange(Secuencia, recCabPlan.Secuencia);
            if recProgramacion.FindFirst then
                rtnFecha := recProgramacion."Fecha programacion";
        end;
    end;


    procedure CDS(FiltroColegio: Text[1024])
    var
        Docente: Record Docentes;
        ColDocentes: Record "Colegio - Docentes";
        wINI: Integer;
        wPRI: Integer;
        wSEC: Integer;
        wING: Integer;
        wPLA: Integer;
        wESI: Integer;
        wGEN: Integer;
        wPSE: Integer;
        wIPR: Integer;
        wIPS: Integer;
    begin

        //Busco los Docentes del Colegio
        ColDocentes.Reset;
        ColDocentes.SetFilter("Cod. Colegio", FiltroColegio);
        if ColDocentes.FindSet then begin
            repeat
                Docente.Get(ColDocentes."Cod. Docente");
                if Docente."Pertenece al CDS" then begin
                    case Docente."Nivel Docente" of
                        'INI':
                            wINI += 1;
                        'PRI':
                            wPRI += 1;
                        'SEC':
                            wSEC += 1;
                        'ING':
                            wING += 1;
                        'PLA':
                            wPLA += 1;
                        'ESI':
                            wESI += 1;
                        'GEN':
                            wGEN += 1;
                        'PSE':
                            wPSE += 1;
                        'IPR':
                            wIPR += 1;
                        'IPS':
                            wIPS += 1;
                    end;
                end;
            until ColDocentes.Next = 0;
            INI := wINI;
            PRI := wPRI;
            SEC := wSEC;
            ING := wING;
            PLA := wPLA;
            ESI := wESI;
            GEN := wGEN;
            PSE := wPSE;
            IPR := wIPR;
            IPS := wIPS;
        end;
    end;


    procedure Valida_Cancelado()
    begin
        TestField("Comentario Cancelado");
    end;


    procedure Valida_Rechazado()
    begin
        TestField("Comentario Rechazado");
    end;


    procedure Eliminar_Planificacion()
    var
        Text001: Label 'Esta acción provocará la eliminación de la programación del evento y de sus asistentes. \¿Desea continuar?';
    begin
    end;


    procedure ActualizaPlanif(parExpEv: Record "Expositores - Eventos") rtnSec: Integer
    var
        CabPlanEvento: Record "Cab. Planif. Evento";
        ProgTyE: Record "Programac. Talleres y Eventos";
        Asistentes: Record "Asistentes Talleres y Eventos";
        CabPlanEventoNEW: Record "Cab. Planif. Evento";
        ProgTyENEW: Record "Programac. Talleres y Eventos";
        AsistentesNEW: Record "Asistentes Talleres y Eventos";
        MatTallerEvento: Record "Materiales Talleres y Eventos";
        MatTallerEventoNEW: Record "Materiales Talleres y Eventos";
    begin

        rtnSec := 0;
        //Cod. Taller - Evento,Expositor,Secuencia
        CabPlanEvento.Reset;
        CabPlanEvento.SetRange("No. Solicitud", "No. Solicitud");
        if CabPlanEvento.FindSet() then begin

            CabPlanEventoNEW := CabPlanEvento;
            CabPlanEventoNEW.Validate("Tipo Evento", "Tipo de Evento");
            CabPlanEventoNEW.Validate("Cod. Taller - Evento", parExpEv."Cod. Evento");
            CabPlanEventoNEW.Validate("Tipo de Expositor", parExpEv."Tipo de Expositor");
            CabPlanEventoNEW.Validate(Expositor, parExpEv."Cod. Expositor");
            CabPlanEventoNEW."Nombre Expositor" := parExpEv."Nombre Expositor";
            CabPlanEventoNEW.Insert(true);

            rtnSec := CabPlanEventoNEW.Secuencia;

            Asistentes.Reset;
            Asistentes.SetRange("Cod. Taller - Evento", CabPlanEvento."Cod. Taller - Evento");
            Asistentes.SetRange("Tipo de Expositor", CabPlanEvento."Tipo de Expositor");
            Asistentes.SetRange("Cod. Expositor", CabPlanEvento.Expositor);
            Asistentes.SetRange(Secuencia, CabPlanEvento.Secuencia);
            if Asistentes.FindSet() then
                repeat
                    AsistentesNEW := Asistentes;
                    AsistentesNEW."Cod. Taller - Evento" := CabPlanEventoNEW."Cod. Taller - Evento";
                    AsistentesNEW."Tipo Evento" := "Tipo de Evento";
                    AsistentesNEW."Tipo de Expositor" := CabPlanEventoNEW."Tipo de Expositor";
                    AsistentesNEW."Cod. Expositor" := CabPlanEventoNEW.Expositor;
                    AsistentesNEW."Nombre Expositor" := CabPlanEventoNEW."Nombre Expositor";
                    AsistentesNEW.Secuencia := CabPlanEventoNEW.Secuencia;
                    AsistentesNEW."Description Tipo evento" := CabPlanEventoNEW."Description Tipo evento";
                    AsistentesNEW."Description Taller" := CabPlanEventoNEW."Description Taller";
                    AsistentesNEW.Insert;
                    Asistentes.Delete;
                until Asistentes.Next = 0;

            ProgTyE.Reset;
            ProgTyE.SetRange("Cod. Taller - Evento", CabPlanEvento."Cod. Taller - Evento");
            ProgTyE.SetRange("Tipo de Expositor", CabPlanEvento."Tipo de Expositor");
            ProgTyE.SetRange(Expositor, CabPlanEvento.Expositor);
            ProgTyE.SetRange(Secuencia, CabPlanEvento.Secuencia);
            if ProgTyE.FindSet() then
                repeat
                    ProgTyENEW := ProgTyE;
                    ProgTyENEW.Validate("Cod. Taller - Evento", CabPlanEventoNEW."Cod. Taller - Evento");
                    ProgTyENEW.Validate("Tipo Evento", "Tipo de Evento");
                    ProgTyENEW.Validate("Tipo de Expositor", CabPlanEventoNEW."Tipo de Expositor");
                    ProgTyENEW.Validate(Expositor, CabPlanEventoNEW.Expositor);
                    ProgTyENEW."Nombre Expositor" := CabPlanEvento."Nombre Expositor";
                    ProgTyENEW.Secuencia := CabPlanEventoNEW.Secuencia;
                    ProgTyENEW.Insert;
                    ProgTyE.Delete;
                until ProgTyE.Next = 0;

            MatTallerEvento.Reset;
            MatTallerEvento.SetRange("Cod. Taller - Evento", CabPlanEvento."Cod. Taller - Evento");
            MatTallerEvento.SetRange(Expositor, CabPlanEvento.Expositor);
            MatTallerEvento.SetRange(Secuencia, CabPlanEvento.Secuencia);
            if MatTallerEvento.FindSet() then
                repeat
                    MatTallerEventoNEW := MatTallerEvento;
                    MatTallerEventoNEW."Cod. Taller - Evento" := CabPlanEventoNEW."Cod. Taller - Evento";
                    MatTallerEventoNEW."Tipo Evento" := "Tipo de Evento";
                    MatTallerEventoNEW.Expositor := CabPlanEventoNEW.Expositor;
                    MatTallerEventoNEW.Secuencia := CabPlanEventoNEW.Secuencia;
                    MatTallerEventoNEW."Tipo de Expositor" := CabPlanEventoNEW."Tipo de Expositor";
                    MatTallerEventoNEW.Insert;
                    MatTallerEvento.Delete;
                until MatTallerEvento.Next = 0;

            CabPlanEvento.Delete;

        end;
    end;
}

