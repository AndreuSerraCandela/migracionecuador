table 76272 "Cab. Visita Asesor/Consultor"
{

    fields
    {
        field(1; "No. Visita Asesor/Consultor"; Code[20])
        {
        }
        field(2; "Tipo Asesor/Consultor"; Option)
        {
            Enabled = false;
            OptionCaption = 'Docente,Proveedor';
            OptionMembers = Docente,Proveedor;
        }
        field(3; "Cod. Asesor/Consultor"; Code[20])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate()
            var
                Doc: Record Docentes;
                Prov: Record Vendor;
            begin

                /*
                ///tableRelation: IF (Tipo Asesor/Consultor=CONST(Docente)) Docentes.No. ELSE IF (Tipo Asesor/Consultor=CONST(Proveedor)) Vendor.No.
                IF "Cod. Asesor/Consultor" <> '' THEN BEGIN
                  CASE "Tipo Asesor/Consultor" OF
                    "Tipo Asesor/Consultor"::Docente :
                      BEGIN
                      IF Doc.GET("Cod. Asesor/Consultor") THEN
                        "Nombre Asesor/Consultor"    := Doc."Full Name";
                      END;
                    "Tipo Asesor/Consultor"::Proveedor :
                      BEGIN
                      IF Prov.GET("Cod. Asesor/Consultor") THEN
                        "Nombre Asesor/Consultor"    := Prov.Name;
                      END;
                  END;
                END
                ELSE
                 "Nombre Asesor/Consultor" := '';
                */

                if "Cod. Asesor/Consultor" <> '' then begin
                    if Prov.Get("Cod. Asesor/Consultor") then
                        "Nombre Asesor/Consultor" := Prov.Name;
                end
                else
                    "Nombre Asesor/Consultor" := '';

            end;
        }
        field(4; "Nombre Asesor/Consultor"; Text[100])
        {
            Editable = false;
        }
        field(5; "Delegación"; Code[20])
        {
            Editable = false;
            TableRelation = "Dimension Value".Code;
        }
        field(6; "Grupo Negocio"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Grupo de Negocio"));
        }
        field(7; "Fecha Registro"; Date)
        {
            Editable = false;
        }
        field(8; "Hora Registro"; Time)
        {
            Editable = false;
        }
        field(9; "Tipo Visita"; Option)
        {
            OptionCaption = 'Solicitada,No Solicitada';
            OptionMembers = Solicitada,"No Solicitada";
        }
        field(10; "No. Solicitud"; Code[20])
        {

            trigger OnLookup()
            var
                fSol: Page "Lista Solicitudes T&E";
                rSol: Record "Solicitud de Taller - Evento";
            begin

                if "Tipo Visita" = "Tipo Visita"::Solicitada then begin
                    rSol.FilterGroup(2);
                    //rSol.SETFILTER(rSol.Status,'%1|%2',rSol.Status::Programada,rSol.Status::Realizada);
                    rSol.SetFilter(rSol.Status, '%1', rSol.Status::Programada);
                    if "Cod. Asesor/Consultor" <> '' then
                        rSol.SetRange("Cod. Expositor", "Cod. Asesor/Consultor");
                    rSol.FilterGroup(0);
                    fSol.SetTableView(rSol);
                    fSol.LookupMode(true);
                    fSol.Editable(false);
                    if fSol.RunModal = ACTION::LookupOK then begin
                        fSol.GetRecord(rSol);
                        Validate("No. Solicitud", rSol."No. Solicitud");
                    end;
                end;
            end;

            trigger OnValidate()
            var
                rSol: Record "Solicitud de Taller - Evento";
                Err001: Label 'Solo se permite ingresar el No. Solicitud en una visita de Tipo Solicitada.';
                Err002: Label 'La solicitud seleccionada no es del cod. expositor %1.';
                Err003: Label 'La solicitud ingresada no se encuentra en estado Programada.';
            begin

                if "Tipo Visita" <> "Tipo Visita"::Solicitada then
                    Error(Err001);

                if rSol.Get("No. Solicitud") then begin
                    //IF (rSol.Status <> rSol.Status::Programada) AND (rSol.Status <> rSol.Status::Realizada) THEN
                    if (rSol.Status <> rSol.Status::Programada) then
                        Error(Err003);

                    if "Cod. Asesor/Consultor" <> '' then
                        if rSol."Cod. Expositor" <> "Cod. Asesor/Consultor" then
                            Error(StrSubstNo(Err002, "Cod. Asesor/Consultor"));

                    "No. Solicitud" := rSol."No. Solicitud";
                    "Grupo Negocio" := rSol."Grupo de Negocio";
                    "Tipo Evento" := rSol."Tipo de Evento";
                    "Cod. evento" := rSol."Cod. evento";
                    "Descripción evento" := rSol."Descripcion evento";
                    "Cod. Nivel" := rSol."Cod. Nivel";

                    Validate("Cod. Colegio", rSol."Cod. Colegio");
                    Validate("Cod. promotor", rSol."Cod. promotor");
                    Validate("Tipo Persona Contacto", rSol."Tipo Responsable");

                    "Cod. Persona Contacto" := rSol."Cod. Docente responsable";
                    "Nombre Persona Contacto" := rSol."Nombre responsable";
                    "Teléfono 1 Persona Contacto" := rSol."Telefono Responsable";
                    "Teléfono 2 Persona Contacto" := rSol."No. celular responsable";
                    "Cod. Cargo Persona Contacto" := rSol."Cod. Cargo Responsable";
                    "Desc. Cargo Persona Contacto" := rSol."Descripción Cargo Responsable";
                    "E-mail Persona Contacto" := rSol."E-Mail Docente Responsable";

                    TraerNGyE(rSol."No. Solicitud");

                    TraerProgramac(rSol."No. Solicitud");
                end;
            end;
        }
        field(11; "Cod. Colegio"; Code[20])
        {
            TableRelation = Contact."No." WHERE(Type = CONST(Company));

            trigger OnValidate()
            var
                Colegio: Record Contact;
            begin

                if "Cod. Colegio" <> '' then begin
                    Colegio.Get("Cod. Colegio");
                    Delegación := Colegio.Región;
                    "Nombre Colegio" := Colegio.Name;
                    "Distrito Colegio" := Colegio.Distritos;
                    "Dirección Colegio" := Colegio.Address;
                    "Teléfono 1 Colegio" := Colegio."Phone No.";
                    "Teléfono 2 Colegio" := Colegio."Mobile Phone No.";
                end;
            end;
        }
        field(12; "Nombre Colegio"; Text[100])
        {
            Editable = false;
        }
        field(13; "Dirección Colegio"; Text[100])
        {
            Editable = false;
        }
        field(14; "Distrito Colegio"; Text[30])
        {
            Editable = false;
        }
        field(15; "Teléfono 1 Colegio"; Code[15])
        {
            Editable = false;
        }
        field(16; "Teléfono 2 Colegio"; Code[15])
        {
            Editable = false;
        }
        field(17; "Cod. promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";

            trigger OnLookup()
            var
                ColNivel: Record "Colegio - Nivel";
                pgColNivel: Page "Promotores - Colegio - Nivel";
            begin

                ColNivel.Reset;
                ColNivel.FilterGroup(2);
                ColNivel.SetRange("Cod. Colegio", "Cod. Colegio");
                ColNivel.SetRange("Cod. Nivel", "Cod. Nivel");
                ColNivel.FilterGroup(0);
                pgColNivel.SetTableView(ColNivel);
                pgColNivel.Editable(false);
                pgColNivel.LookupMode(true);
                if pgColNivel.RunModal = ACTION::LookupOK then begin
                    pgColNivel.GetRecord(ColNivel);
                    Validate("Cod. promotor", ColNivel."Cod. Promotor");
                end;
            end;

            trigger OnValidate()
            var
                rVendor: Record Vendor;
            begin
                if "Cod. promotor" <> '' then begin
                    if rVendor.Get("Cod. promotor") then
                        "Nombre promotor" := rVendor.Name;
                end
                else
                    "Nombre promotor" := '';
            end;
        }
        field(18; "Nombre promotor"; Text[100])
        {
            Editable = false;
        }
        field(19; "Cod. Nivel"; Code[20])
        {
            TableRelation = "Colegio - Nivel"."Cod. Nivel" WHERE("Cod. Colegio" = FIELD("Cod. Colegio"),
                                                                  "Cod. Promotor" = FIELD("Cod. promotor"));

            trigger OnValidate()
            var
                ColNivel: Record "Colegio - Nivel";
            begin
                ColNivel.Reset;
                ColNivel.SetRange("Cod. Colegio", "Cod. Colegio");
                ColNivel.SetRange("Cod. Nivel", "Cod. Nivel");
                if ColNivel.FindSet then
                    Validate("Cod. promotor", ColNivel."Cod. Promotor");
            end;
        }
        field(20; "Tipo Evento"; Code[20])
        {
            TableRelation = "Tipos de Eventos";
        }
        field(21; "Tipo Persona Contacto"; Option)
        {
            OptionCaption = 'CDS,Otro';
            OptionMembers = CDS,Otro;

            trigger OnValidate()
            begin
                "Cod. Persona Contacto" := '';
                "Nombre Persona Contacto" := '';
                "Teléfono 1 Persona Contacto" := '';
                "Teléfono 2 Persona Contacto" := '';
                "E-mail Persona Contacto" := '';
                "Cod. Cargo Persona Contacto" := '';
                "Desc. Cargo Persona Contacto" := '';
            end;
        }
        field(22; "Cod. Persona Contacto"; Code[20])
        {
            TableRelation = "Colegio - Docentes"."Cod. Docente" WHERE("Cod. Colegio" = FIELD("Cod. Colegio"),
                                                                       "Pertenece al CDS" = CONST(true));

            trigger OnLookup()
            var
                rColDoc: Record "Colegio - Docentes";
                pColDoc: Page "Lista Colegio - Docentes";
            begin
                if "Tipo Persona Contacto" = "Tipo Persona Contacto"::CDS then begin
                    rColDoc.Reset;
                    rColDoc.SetRange("Cod. Colegio", "Cod. Colegio");
                    rColDoc.SetRange("Pertenece al CDS", true);
                    pColDoc.SetTableView(rColDoc);
                    pColDoc.LookupMode(true);
                    if pColDoc.RunModal = ACTION::LookupOK then begin
                        pColDoc.GetRecord(rColDoc);
                        Validate("Cod. Persona Contacto", rColDoc."Cod. Docente");
                        Validate("Cod. Cargo Persona Contacto", rColDoc."Cod. Cargo");
                    end;
                end;
            end;

            trigger OnValidate()
            var
                Doc: Record Docentes;
                ColDoc: Record "Colegio - Docentes";
            begin
                if "Tipo Persona Contacto" = "Tipo Persona Contacto"::CDS then
                    if Doc.Get("Cod. Persona Contacto") then begin
                        "Nombre Persona Contacto" := Doc."Full Name";
                        "Teléfono 1 Persona Contacto" := Doc."Phone No.";
                        "Teléfono 2 Persona Contacto" := Doc."Mobile Phone No.";
                        "E-mail Persona Contacto" := Doc."E-Mail";
                        ColDoc.SetRange("Cod. Colegio", "Cod. Colegio");
                        ColDoc.SetRange("Cod. Docente", "Cod. Persona Contacto");
                        if ColDoc.FindSet then begin
                            "Cod. Cargo Persona Contacto" := ColDoc."Cod. Cargo";
                            "Desc. Cargo Persona Contacto" := ColDoc."Descripcion Cargo";
                        end;
                    end;
            end;
        }
        field(23; "Nombre Persona Contacto"; Text[100])
        {
        }
        field(24; "Cod. Cargo Persona Contacto"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Puestos de trabajo"));

            trigger OnValidate()
            var
                DA: Record "Datos auxiliares";
            begin
                if "Cod. Cargo Persona Contacto" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::"Puestos de trabajo");
                    DA.SetRange(Codigo, "Cod. Cargo Persona Contacto");
                    DA.FindFirst;
                    "Desc. Cargo Persona Contacto" := DA.Descripcion;
                end
                else
                    "Desc. Cargo Persona Contacto" := '';
            end;
        }
        field(25; "Desc. Cargo Persona Contacto"; Text[100])
        {
            Editable = false;
        }
        field(26; "Teléfono 1 Persona Contacto"; Code[15])
        {
        }
        field(27; "Teléfono 2 Persona Contacto"; Code[15])
        {
        }
        field(28; "E-mail Persona Contacto"; Text[30])
        {
        }
        field(29; "No. Asistentes Esperados"; Integer)
        {
        }
        field(30; "No. Asistentes Reales"; Integer)
        {
            CalcFormula = Count("Asis. Visitas Asesor/Consultor" WHERE("No. Visita" = FIELD("No. Visita Asesor/Consultor")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; Estado; Option)
        {
            OptionMembers = Programada,Ejecutada;
        }
        field(32; "Fecha Próxima Visita"; Date)
        {
        }
        field(33; "Cód. Objetivo Visita"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Objetivos));

            trigger OnValidate()
            var
                DA: Record "Datos auxiliares";
            begin
                if "Cód. Objetivo Visita" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::Objetivos);
                    DA.SetRange(Codigo, "Cód. Objetivo Visita");
                    DA.FindFirst;
                    "Desc. Objetivo Visita" := DA.Descripcion;
                end
                else
                    "Desc. Objetivo Visita" := '';
            end;
        }
        field(34; "Comentarios Visita"; Text[100])
        {
        }
        field(35; "Usuario Registro"; Code[50])
        {
            Editable = false;
        }
        field(36; "No. Series"; Code[20])
        {
        }
        field(37; "Desc. Objetivo Visita"; Text[100])
        {
            Editable = false;
        }
        field(38; "Cod. evento"; Code[20])
        {

            trigger OnLookup()
            var
                rEvExp: Record "Expositores - Eventos";
                pEvExp: Page "Expositores - Eventos";
            begin
                rEvExp.Reset;
                if "Tipo Evento" <> '' then
                    rEvExp.SetRange(rEvExp."Tipo de Evento", "Tipo Evento");
                rEvExp.SetRange(rEvExp.Delegacion, Delegación);
                rEvExp.SetRange(rEvExp."Cod. Expositor", "Cod. Asesor/Consultor");
                pEvExp.SetTableView(rEvExp);
                pEvExp.LookupMode(true);
                if pEvExp.RunModal = ACTION::LookupOK then begin
                    pEvExp.GetRecord(rEvExp);
                    "Cod. evento" := rEvExp."Cod. Evento";
                    "Descripción evento" := rEvExp."Descripcion Evento";
                    "Tipo Evento" := rEvExp."Tipo de Evento";
                end;
            end;

            trigger OnValidate()
            var
                rEvExp: Record "Expositores - Eventos";
                err001: Label 'El cod. evento no está asociado con el consultor %1.';
            begin
                rEvExp.Reset;
                if "Tipo Evento" <> '' then
                    rEvExp.SetRange(rEvExp."Tipo de Evento", "Tipo Evento");
                rEvExp.SetRange(rEvExp.Delegacion, Delegación);
                rEvExp.SetRange(rEvExp."Cod. Expositor", "Cod. Asesor/Consultor");
                rEvExp.SetRange(rEvExp."Cod. Evento", "Cod. evento");
                if rEvExp.FindSet then begin
                    "Descripción evento" := rEvExp."Descripcion Evento";
                    "Tipo Evento" := rEvExp."Tipo de Evento";
                end
                else
                    Error(StrSubstNo(err001, "Cod. Asesor/Consultor"));
            end;
        }
        field(39; "Descripción evento"; Text[100])
        {
            Editable = false;
        }
        field(40; "Programa Seguimiento Uno a Uno"; Boolean)
        {
        }
        field(41; "Fecha programada"; Date)
        {
            CalcFormula = Lookup("Prog. Visitas Asesor/Consultor"."Fecha Programada" WHERE("No. Visita" = FIELD("No. Visita Asesor/Consultor")));
            FieldClass = FlowField;
        }
        field(42; "Fecha realizada"; Date)
        {
            CalcFormula = Lookup("Prog. Visitas Asesor/Consultor"."Fecha Realizada" WHERE("No. Visita" = FIELD("No. Visita Asesor/Consultor")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No. Visita Asesor/Consultor")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Err001: Label 'No se permite eliminar visitas con estado Ejecutada.';
        Text001: Label '¿Está seguro que desea eliminar la visita?';
        rProg: Record "Prog. Visitas Asesor/Consultor";
        rAsis: Record "Asis. Visitas Asesor/Consultor";
        rCC: Record "Visitas A/C-Dis. Centros Costo";
        rDescAsis: Record "Visitas A/C - Descr. Asistente";
    begin


        if Estado = Estado::Ejecutada then
            Error(Err001);

        if Confirm(Text001) then begin
            rProg.SetRange("No. Visita", "No. Visita Asesor/Consultor");
            rProg.DeleteAll;

            rAsis.SetRange("No. Visita", "No. Visita Asesor/Consultor");
            rAsis.DeleteAll;

            rCC.SetRange("No. Visita Consultor/Asesor", "No. Visita Asesor/Consultor");
            rCC.DeleteAll;

            rDescAsis.SetRange(rDescAsis."No. Visita", "No. Visita Asesor/Consultor");
            rDescAsis.DeleteAll;
        end;
    end;

    trigger OnInsert()
    var
        APSSetup: Record "Commercial Setup";
        NoSeriesMgt: Codeunit "No. Series";
        Seg: Record "Seguim.Visita Asesor/Consultor";
    begin

        if "No. Visita Asesor/Consultor" = '' then begin
            APSSetup.Get;
            APSSetup.TestField("No. Serie Visita Asesor/Consu.");
            //NoSeriesMgt.InitSeries(APSSetup."No. Serie Visita Asesor/Consu.", xRec."No. Series", 0D, "No. Visita Asesor/Consultor", "No. Series");
            Rec."No. series" := APSSetup."No. Serie Visita Asesor/Consu.";
            if NoSeriesMgt.AreRelated(APSSetup."No. Serie Visita Asesor/Consu.", xRec."No. Series") then
                Rec."No. Series" := xRec."No. Series";
            Rec."No. Visita Asesor/Consultor" := NoSeriesMgt.GetNextNo(Rec."No. Series");
        end;

        Seg.InsertarSeguimiento(Rec);

        //"Fecha Registro"    := TODAY;
        //"Hora Registro"     := TIME;
        "Usuario Registro" := UserId;
    end;

    trigger OnModify()
    var
        rProg: Record "Prog. Visitas Asesor/Consultor";
        act: Boolean;
        rDoc: Record Docentes;
        Seg: Record "Seguim.Visita Asesor/Consultor";
    begin

        rProg.SetRange("No. Visita", "No. Visita Asesor/Consultor");
        if rProg.FindSet(true) then
            repeat
                //rProg."Tipo Asesor/Consultor"   := "Tipo Asesor/Consultor";
                rProg."Cod. Asesor/Consultor" := "Cod. Asesor/Consultor";
                rProg."Nombre Asesor/Consultor" := "Nombre Asesor/Consultor";
                rProg.Delegación := Delegación;
                rProg."Grupo Negocio" := "Grupo Negocio";
                rProg."Cod. promotor" := "Cod. promotor";
                rProg."Nombre promotor" := "Nombre promotor";
                rProg."Cod. Colegio" := "Cod. Colegio";
                rProg."Nombre Colegio" := "Nombre Colegio";
                rProg.Modify;
            until rProg.Next = 0;

        if "Tipo Persona Contacto" = "Tipo Persona Contacto"::CDS then
            if rDoc.Get("Cod. Persona Contacto") then
                if ("Teléfono 1 Persona Contacto" <> rDoc."Phone No.") or
                   ("Teléfono 2 Persona Contacto" <> rDoc."Mobile Phone No.") or
                   ("E-mail Persona Contacto" <> rDoc."E-Mail") then begin
                    rDoc."Phone No." := "Teléfono 1 Persona Contacto";
                    rDoc."Mobile Phone No." := "Teléfono 2 Persona Contacto";
                    rDoc."E-Mail" := "E-mail Persona Contacto";
                    rDoc.Modify;
                end;

        if xRec.Estado <> Estado then
            Seg.InsertarSeguimiento(Rec);
    end;

    trigger OnRename()
    var
        Text003: Label 'You cannot rename a %1.';
    begin
        Error(Text003, TableCaption);
    end;


    procedure TraerNGyE(parSolicitud: Code[20])
    var
        rNivel: Record "Solicitud -  Nivel Asistente";
        rGrado: Record "Solicitud -  Grado Asistente";
        rEspec: Record "Solicitud -  Especialidad Asi.";
        rNGE: Record "Visitas A/C - Descr. Asistente";
    begin

        if "No. Visita Asesor/Consultor" <> '' then begin
            rNGE.Reset;
            rNGE.SetRange(rNGE."No. Visita", "No. Visita Asesor/Consultor");
            rNGE.DeleteAll;
            rNGE.Reset;

            rNivel.SetRange(rNivel."No. Solicitud", parSolicitud);
            if rNivel.FindSet then
                repeat
                    rNGE.Init;
                    rNGE."No. Visita" := "No. Visita Asesor/Consultor";
                    rNGE.Tipo := rNGE.Tipo::Nivel;
                    rNGE.Codigo := rNivel."Cod. Nivel";
                    rNGE.Descripción := rNivel.Descripción;
                    rNGE.Insert;
                until rNivel.Next = 0;

            rGrado.SetRange(rGrado."No. Solicitud", parSolicitud);
            if rGrado.FindSet then
                repeat
                    rNGE.Init;
                    rNGE."No. Visita" := "No. Visita Asesor/Consultor";
                    rNGE.Tipo := rNGE.Tipo::Grado;
                    rNGE.Codigo := rGrado."Cod. Grado";
                    rNGE.Descripción := rGrado.Descripción;
                    rNGE.Insert;
                until rGrado.Next = 0;

            rEspec.SetRange(rEspec."No. Solicitud", parSolicitud);
            if rEspec.FindSet then
                repeat
                    rNGE.Init;
                    rNGE."No. Visita" := "No. Visita Asesor/Consultor";
                    rNGE.Tipo := rNGE.Tipo::Especialidad;
                    rNGE.Codigo := rEspec."Cod. Especialidad";
                    rNGE.Descripción := rEspec.Descripción;
                    rNGE.Insert;
                until rEspec.Next = 0;
        end;
    end;


    procedure TraerProgramac(parSolicitud: Code[20])
    var
        rProgVisita: Record "Prog. Visitas Asesor/Consultor";
        rProgSolic: Record "Programac. Talleres y Eventos";
        rCabPlanif: Record "Cab. Planif. Evento";
    begin

        if "No. Visita Asesor/Consultor" <> '' then begin
            rCabPlanif.Reset;
            rCabPlanif.SetRange("No. Solicitud", "No. Solicitud");
            if rCabPlanif.FindSet then begin
                rProgSolic.SetRange("Cod. Taller - Evento", rCabPlanif."Cod. Taller - Evento");
                rProgSolic.SetRange("Tipo Evento", rCabPlanif."Tipo Evento");
                rProgSolic.SetRange("Tipo de Expositor", rCabPlanif."Tipo de Expositor");
                rProgSolic.SetRange(Expositor, rCabPlanif.Expositor);
                rProgSolic.SetRange(Secuencia, rCabPlanif.Secuencia);
                if rProgSolic.FindSet then begin
                    rProgVisita.Reset;
                    rProgVisita.SetRange(rProgVisita."No. Visita", "No. Visita Asesor/Consultor");
                    rProgVisita.DeleteAll;
                    rProgVisita.Reset;
                    repeat
                        rProgVisita.Init;
                        rProgVisita."No. Visita" := "No. Visita Asesor/Consultor";
                        rProgVisita."Fecha Programada" := rProgSolic."Fecha programacion";
                        rProgVisita."Hora Inicio Programada" := rProgSolic."Hora de Inicio";
                        rProgVisita."Hora Fin Programada" := rProgSolic."Hora Final";
                        rProgVisita."Cod. Grado" := rProgSolic."Cod. Grado";
                        rProgVisita."No. asistentes" := rProgSolic."Asistentes esperados";
                        rProgVisita.Insert(true);
                    until rProgSolic.Next = 0;
                end;
            end;
        end;
    end;
}

