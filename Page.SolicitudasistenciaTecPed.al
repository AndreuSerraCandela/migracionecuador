page 76393 "Solicitud asistencia Tec - Ped"
{
    ApplicationArea = all;
    // ,Enviada por promotor
    // ,Aprobada
    // ,Programada
    // ,Cancelada
    // ,Rechazada
    // ,Realizada.

    Caption = 'Solicitud de Asistencia Técnico - Pedagógica';
    PageType = Card;
    PromotedActionCategories = 'Nuevo,Proceso,Reporte,Asistentes';
    SourceTable = "Solicitud de Taller - Evento";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No. Solicitud"; rec."No. Solicitud")
                {

                    trigger OnAssistEdit()
                    begin
                        if rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Cod. promotor"; rec."Cod. promotor")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rVendedor: Record "Salesperson/Purchaser";
                        fVendedor: Page "Salespersons/Purchasers";
                    begin

                        if userPromotor then begin
                            rVendedor.FilterGroup(2);
                            rVendedor.SetRange(rVendedor.Code, UserSetup."Salespers./Purch. Code");
                            rVendedor.FilterGroup(0);
                        end;
                        fVendedor.SetTableView(rVendedor);
                        fVendedor.LookupMode(true);
                        if fVendedor.RunModal = ACTION::LookupOK then begin
                            fVendedor.GetRecord(rVendedor);
                            rec."Cod. promotor" := rVendedor.Code;
                            rec.Validate("Cod. promotor");
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if userPromotor then
                            rec.TestField("Cod. promotor", UserSetup."Salespers./Purch. Code");
                    end;
                }
                field("Nombre promotor"; rec."Nombre promotor")
                {
                    Editable = false;
                }
                field(Delegacion; rec.Delegacion)
                {
                }
                field("Grupo de Negocio"; rec."Grupo de Negocio")
                {
                }
                field("Tipo de Evento"; rec."Tipo de Evento")
                {
                }
                field("Existe evento"; rec."Existe evento")
                {
                    Editable = wEditExisteEvento;

                    trigger OnValidate()
                    begin
                        ExisteEvento;
                    end;
                }
                field("Cod. evento"; rec."Cod. evento")
                {
                    Editable = wExisteEv;

                    trigger OnValidate()
                    begin
                        if rec."Cod. evento" <> '' then begin
                            //    EditaDesc := FALSE;
                            rec."Desc. del Evento no existe" := '';
                        end
                        else begin
                            //    EditaDesc := TRUE;
                            rec."Descripcion evento" := '';
                        end;
                    end;
                }
                field("Descripcion evento"; rec."Descripcion evento")
                {
                    Editable = NOT wExisteEv;
                }
                field("Evento dictado por (tipo)"; rec."Evento dictado por (tipo)")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Evento dictado por (codigo)"; rec."Evento dictado por (codigo)")
                {
                    Editable = false;
                }
                field("Evento dictado por (nombre)"; rec."Evento dictado por (nombre)")
                {
                    Editable = false;
                }
                field("Fecha Solicitud"; rec."Fecha Solicitud")
                {
                }
                field("Cod. evento programado"; rec."Cod. evento programado")
                {
                    Enabled = (NOT userPromotor) AND wEvProg;
                }
                field("Descripción evento programado"; rec."Descripción evento programado")
                {
                    Enabled = NOT userPromotor;
                }
                field("Avisado al expositor"; rec."Avisado al expositor")
                {
                    Editable = wEvProg;
                    Enabled = NOT userPromotor;
                }
                field("Tipo de Expositor"; rec."Tipo de Expositor")
                {
                    Editable = false;
                    Enabled = NOT userPromotor;
                    Visible = false;
                }
                field("Cod. Expositor"; rec."Cod. Expositor")
                {
                    Editable = false;
                    Enabled = NOT userPromotor;
                }
                field("Nombre expositor"; rec."Nombre expositor")
                {
                    Editable = false;
                    Enabled = NOT userPromotor;
                }
                field("Selección Editorial"; rec."Selección Editorial")
                {

                    trigger OnValidate()
                    begin
                        Editorial;
                    end;
                }
                field("Desc.  Competencia"; rec."Desc.  Competencia")
                {
                    Editable = wCompetencia;
                }
                field("Grupo de Colegios"; rec."Grupo de Colegios")
                {

                    trigger OnValidate()
                    begin
                        GrupoColegios;
                    end;
                }
                field("Asociacion/Grupo"; rec."Asociacion/Grupo")
                {
                    Enabled = wAsocGrupo;
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                    Enabled = NOT wAsocGrupo;
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                    Editable = false;
                }
                field("Direccion Colegio"; rec."Direccion Colegio")
                {
                    Editable = false;
                }
                field("Codigo Distrito Colegio"; rec."Codigo Distrito Colegio")
                {
                    Editable = false;
                }
                field("Nombre Distrito Colegio"; rec."Nombre Distrito Colegio")
                {
                    Editable = false;
                }
                field("Telefono 1 Colegio"; rec."Telefono 1 Colegio")
                {
                    Editable = false;
                }
                field("Telefono 2 Colegio"; rec."Telefono 2 Colegio")
                {
                    Editable = false;
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                    Importance = Additional;
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Cod. Turno"; rec."Cod. Turno")
                {
                }
                field("Comentario Aprobado"; rec."Comentario Aprobado")
                {
                    Visible = wApro;
                }
                field("Comentario Programado"; rec."Comentario Programado")
                {
                    Visible = wProg;
                }
                field("Comentario Rechazado"; rec."Comentario Rechazado")
                {
                    Visible = wRech;
                }
                field("Comentario Cancelado"; rec."Comentario Cancelado")
                {
                    Visible = wCanc;
                }
                field(Referencia; rec.Referencia)
                {
                }
                field(Status; rec.Status)
                {
                    Editable = false;
                }
                field("Usuario creación"; rec."Usuario creación")
                {
                }
            }
            group("Aditional Information")
            {
                Caption = 'Aditional Information';
                field("Tipo Responsable"; rec."Tipo Responsable")
                {
                    Caption = 'Type of contact';
                    OptionCaption = 'CDS,Other';

                    trigger OnValidate()
                    begin
                        NoPertenecealCDS := false;
                        EditaDocente := true;

                        if rec."Tipo Responsable" = 1 then begin
                            NoPertenecealCDS := true;
                            EditaDocente := false;
                            rec."Cod. Docente responsable" := '';
                        end;
                    end;
                }
                field("Cod. Docente responsable"; rec."Cod. Docente responsable")
                {
                    Editable = EditaDocente;
                }
                field("Nombre responsable"; rec."Nombre responsable")
                {
                    Editable = NoPertenecealCDS;
                }
                field("Cod. Cargo Responsable"; rec."Cod. Cargo Responsable")
                {
                    Editable = NoPertenecealCDS;
                }
                field("Descripción Cargo Responsable"; rec."Descripción Cargo Responsable")
                {
                    Editable = NoPertenecealCDS;
                }
                field("Telefono Responsable"; rec."Telefono Responsable")
                {
                }
                field("No. celular responsable"; rec."No. celular responsable")
                {
                }
                field("E-Mail Docente Responsable"; rec."E-Mail Docente Responsable")
                {
                }
                field("Col. tiene equipo MM"; rec."Col. tiene equipo MM")
                {
                    Caption = 'Colegio tiene equipo Multimedia';
                }
                field(Refrigerio; rec.Refrigerio)
                {
                    Caption = 'Se requiere Refrigerio';
                    Editable = wSeReq;
                }
                field(Material; rec.Material)
                {
                    Caption = 'Se requiere Material';
                    Editable = wSeReq;
                }
                field(Merchandising; rec.Merchandising)
                {
                    Caption = 'Se requiere Merchandising';
                    Editable = wSeReq;
                }
                field("Cod. objetivo promotor"; rec."Cod. objetivo promotor")
                {
                }
                field("Objetivo promotor"; rec."Objetivo promotor")
                {
                    Editable = false;
                }
                field(Observaciones; rec.Observaciones)
                {
                    Caption = 'Observaciones promotor';
                }
            }
            group(Asistentes)
            {
                Caption = 'Asistentes';
                field("Asistencia promotor"; rec."Asistencia promotor")
                {
                }
                field("Material para revisión"; rec."Material para revisión")
                {
                }
                field("Asistentes Esperados"; rec."Asistentes Esperados")
                {
                }
                field("Asistentes Reales"; rec."Asistentes Reales")
                {
                    Editable = wEditAsisReal;
                }
                field("Nivel Asistente"; rec."Nivel Asistente")
                {
                    Editable = false;
                }
                field("Grado Asistente"; rec."Grado Asistente")
                {
                    Editable = false;
                }
                field("Especialidad Asistente"; rec."Especialidad Asistente")
                {
                    Editable = false;
                }
                group(CDS)
                {
                    Caption = 'CDS';
                    field(INI; rec.INI)
                    {
                        Editable = false;
                    }
                    field(PRI; rec.PRI)
                    {
                        Editable = false;
                    }
                    field(SEC; rec.SEC)
                    {
                        Editable = false;
                    }
                    field(ING; rec.ING)
                    {
                        Editable = false;
                    }
                    field(PLA; rec.PLA)
                    {
                        Editable = false;
                    }
                    field(ESI; rec.ESI)
                    {
                        Editable = false;
                    }
                    field(GEN; rec.GEN)
                    {
                        Editable = false;
                    }
                    field(IPR; rec.IPR)
                    {
                        Editable = false;
                    }
                    field(IPS; rec.IPS)
                    {
                        Editable = false;
                    }
                    field(PSE; rec.PSE)
                    {
                        Editable = false;
                    }
                    field(TOTAL_CDS; rec.INI + rec.PRI + rec.SEC + rec.ING + rec.PLA + rec.ESI + rec.GEN + rec.IPR + rec.IPS + rec.PSE)
                    {
                        Caption = 'TOTAL CDS';
                        Editable = false;
                        Style = Strong;
                        StyleExpr = TRUE;
                    }
                }
            }
            group("Textos uitilizan")
            {
                Caption = 'Textos uitilizan';
                Visible = false;
                group("Grupo Santillana")
                {
                    Caption = 'Grupo Santillana';
                    Visible = false;
                    field("Artículo Grupo Santillana"; rec."Artículo Grupo Santillana")
                    {
                        Editable = wGS;
                        Visible = false;
                    }
                    field("Desc. Artículo Grupo Santillan"; rec."Desc. Artículo Grupo Santillan")
                    {
                        Editable = false;
                        Visible = false;
                    }
                    field("Horas por semana"; rec."Horas por semana")
                    {
                        Editable = wGS;
                    }
                    field("Año Adopción"; rec."Año Adopción")
                    {
                        Editable = false;
                        Visible = false;
                    }
                }
                group(Competencia)
                {
                    Caption = 'Competencia';
                    Visible = false;
                }
                field("Editorial Competencia"; rec."Editorial Competencia")
                {
                    Editable = wCompetencia;
                    Visible = false;
                }
                field("Nombre Editorial Competencia"; rec."Nombre Editorial Competencia")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Artículo Competencia"; rec."Artículo Competencia")
                {
                    Editable = wCompetencia;
                    Visible = false;
                }
                field(DC; rec."Desc.  Competencia")
                {
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Event")
            {
                Caption = '&Event';
                separator(Action1000000080)
                {
                }
                action("<Action1000000104>")
                {
                    Caption = '&Proponer fechas';
                    Image = CalendarChanged;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        pPropFechas: Page "Solicitud - Proposición Fechas";
                        rPropFechas: Record "Solicitud - Proposición Fechas";
                    begin
                        rec.TestField("No. Solicitud");

                        rPropFechas.FilterGroup(2);
                        rPropFechas.SetRange("No. Solicitud", rec."No. Solicitud");
                        rPropFechas.FilterGroup(0);
                        pPropFechas.SetTableView(rPropFechas);
                        pPropFechas.Parametros(rec.Status <= 2);
                        pPropFechas.Run;
                    end;
                }
                action("&Equipments")
                {
                    Caption = '&Equipments';
                    Image = FileContract;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Equipos Talleres y Eventos";
                    RunPageLink = "No. Solicitud" = FIELD("No. Solicitud");
                    Visible = wEquipos;
                }
                action("&Schedule")
                {
                    Caption = '&Schedule';
                    Image = CalendarChanged;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = wProgram;

                    trigger OnAction()
                    var
                        CabPlanEvent: Record "Cab. Planif. Evento";
                        CabPlanEvent2: Record "Cab. Planif. Evento";
                        SolicPlan: Page "Solic. Planif. Taller/Evento";
                        pCabPlan: Page "Solicitud -Cab. Planif. Evento";
                    begin

                        rec.TestField("No. Solicitud");
                        rec.TestField("Tipo de Evento");
                        rec.TestField("Cod. Expositor");
                        rec.TestField("Cod. evento programado");


                        if not rec.Tiene_Planificacion then
                            rec.Crear_Planificacion;

                        CabPlanEvent.SetRange("No. Solicitud", rec."No. Solicitud");
                        pCabPlan.SetTableView(CabPlanEvent);
                        pCabPlan.Run;
                        Clear(pCabPlan);
                        Act_AsistentesReales;
                    end;
                }
                action("&Assistance")
                {
                    Caption = '&Assistance';
                    Image = OpenWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = wAsistentes;

                    trigger OnAction()
                    var
                        pAsistentes: Page "Seleccionar Docentes - Colegio";
                        CabPlanEvent: Record "Cab. Planif. Evento";
                    begin
                        rec.TestField("No. Solicitud");
                        rec.TestField("Tipo de Evento");
                        rec.TestField("Cod. evento programado");
                        rec.TestField("Cod. Expositor");
                        rec.TestField("Cod. Colegio");
                        if rec."Grupo de Colegios" then
                            rec.TestField("Asociacion/Grupo")
                        else
                            rec.TestField("Cod. Colegio");
                        //TESTFIELD("Cod. Local");

                        if not rec.Tiene_Planificacion then
                            rec.Crear_Planificacion;

                        CabPlanEvent.Reset;
                        CabPlanEvent.SetRange("No. Solicitud", rec."No. Solicitud");
                        CabPlanEvent.FindFirst;
                        pAsistentes.RecibeParametros(rec."Cod. evento programado", rec."Cod. Expositor", CabPlanEvent.Secuencia, rec."Tipo de Evento", rec."Cod. Colegio",
                        rec."Cod. Local", rec."Grupo de Colegios", rec."Asociacion/Grupo");
                        pAsistentes.Run;
                        Clear(pAsistentes);
                    end;
                }
                action("&Seguimiento")
                {
                    Caption = '&Seguimiento';
                    Image = Trace;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Seguimiento Solicitud TE";
                    RunPageLink = "No. Solicitud" = FIELD("No. Solicitud");
                }
                action("&Libros a Presentar")
                {
                    Caption = '&Libros a Presentar';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Solicitud - Libros a Presentar";
                    RunPageLink = "Núm. Solicitud" = FIELD("No. Solicitud");
                }
                action("&Competencia")
                {
                    Caption = '&Competencia';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Solicitud - Competencia";
                    RunPageLink = "No. Solicitud" = FIELD("No. Solicitud");
                }
                separator(Action1000000025)
                {
                }
                action("Distribution per Cost Centre")
                {
                    Caption = 'Distribution per Cost Centre';
                    Image = GLAccountBalance;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = wCentros;

                    trigger OnAction()
                    var
                        GpoNegDistrib: Page "Grupos de Negocio - Distrib.";
                        modif: Boolean;
                    begin
                        rec.TestField("No. Solicitud");
                        rec.TestField("Cod. Colegio");

                        if (userPromotor) and (rec.Status > 0) then
                            modif := false
                        else
                            modif := true;

                        if rec.Status <= 1 then
                            GpoNegDistrib.RecibeParametros(rec."Cod. Colegio", rec."No. Solicitud", '', '', '', 0, false, modif, rec."Asociacion/Grupo")
                        else
                            GpoNegDistrib.RecibeParametros(rec."Cod. Colegio", rec."No. Solicitud", '', '', '', 0, rec."Grupo de Colegios", modif, rec."Asociacion/Grupo");
                        GpoNegDistrib.RunModal;
                    end;
                }
                action(Ranking)
                {
                    Caption = 'Ranking';
                    Image = ResourcePrice;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        pgRanking: Page "Ranking CVM";
                    begin
                        rec.TestField("Cod. Colegio");
                        pgRanking.CalcularRanking(rec."Cod. Colegio");
                        pgRanking.Run;
                        Clear(pgRanking);
                    end;
                }
                separator(Action1000000052)
                {
                }
                action("<Action1000000035>")
                {
                    Caption = 'Nivel Asistente';
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Solicitud -  Nivel Asistentes";
                    RunPageLink = "No. Solicitud" = FIELD("No. Solicitud");
                }
                action("<Action1000000036>")
                {
                    Caption = 'Grado Asistente';
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Solicitud - Grado Asistentes";
                    RunPageLink = "No. Solicitud" = FIELD("No. Solicitud");
                }
                action("<Action1000000037>")
                {
                    Caption = 'Especialidad Asistente';
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Solicitud - Especialidad";
                    RunPageLink = "No. Solicitud" = FIELD("No. Solicitud");
                }
                action("&Textos que utilizan")
                {
                    Caption = '&Textos que utilizan';
                    Image = Edit;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunPageMode = View;

                    trigger OnAction()
                    var
                        pTextos: Page "Colegio - Textos que utilizan";
                        rAdop: Record "Historico Adopciones";
                        rGrupoCOL: Record "Grupo de Colegios";
                    begin
                        rec.TestField("No. Solicitud");
                        rec.TestField("Cod. Colegio");
                        if (rec."Grupo de Colegios") and (rec.Status > 1) then begin
                            rGrupoCOL.Get(rec."Asociacion/Grupo");
                            rGrupoCOL.CheckGrupo();
                            rAdop.SetFilter("Cod. Colegio", rGrupoCOL.GetColegios());
                        end
                        else
                            rAdop.SetRange("Cod. Colegio", rec."Cod. Colegio");
                        pTextos.SetTableView(rAdop);
                        pTextos.Run;
                    end;
                }
            }
            group("&Post")
            {
                Caption = '&Post';
                action(Action1000000072)
                {
                    Caption = '&Post';
                    Image = PostDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    Visible = wReg;

                    trigger OnAction()
                    var
                        Selection: Integer;
                        SegSol: Record "Seguimiento Solicitud TE";
                    begin
                        if (userPromotor) and (rec.Status > 0) then
                            exit;

                        case rec.Status of
                            0:
                                begin
                                    rec.Valida_Enviado;
                                    rec.Status := 1;
                                end;
                            1:
                                begin
                                    Selection := StrMenu(Text000, 1, Text003);
                                    if Selection = 2 then begin
                                        rec.Valida_Aprobado;
                                        rec.Status := 2;
                                    end
                                    else
                                        if Selection = 3 then begin
                                            rec.Valida_Rechazado();
                                            rec.Status := 5;
                                        end;
                                end;
                            2:
                                begin
                                    Selection := StrMenu(Text001, 1, Text003);
                                    if Selection = 2 then begin
                                        rec.Valida_Programado;
                                        rec.Status := 3;
                                    end
                                    else
                                        if Selection = 3 then begin
                                            rec.Valida_Cancelado();
                                            rec.Status := 4;
                                        end;
                                end;
                            3:
                                begin
                                    Selection := StrMenu(Text002, 1, Text003);
                                    if Selection = 2 then begin
                                        rec.Valida_Realizado();
                                        rec.Status := 6;
                                    end
                                    else
                                        if Selection = 3 then begin
                                            rec.Valida_Cancelado();
                                            rec.Status := 4;
                                        end;

                                end;
                        end;

                        if xRec.Status <> rec.Status then
                            SegSol.InsertarSeguimiento(Rec);

                        rec.Modify(true);

                        Estado;
                        GrupoColegios;

                        //CurrPage.CLOSE;
                    end;
                }
            }
        }
        area(processing)
        {
            action("<Action1000000024>")
            {
                Caption = 'Generar Solicitud de Asistencia Técnica Pedagógica (Word)';

                trigger OnAction()
                var
                    cduWord: Codeunit "Generacion Words APS";
                begin
                    cduWord.GeneraWordSolicitudAsistencia(rec."No. Solicitud");
                end;
            }
            action("<Action1000000045>")
            {
                Caption = 'Generar Ficha de PP.FF. (Word)';

                trigger OnAction()
                var
                    cduWord: Codeunit "Generacion Words APS";
                begin
                    cduWord.GeneraWordPPFF(rec."No. Solicitud");
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        rec.Status := 0;
    end;

    trigger OnOpenPage()
    begin

        Clear(userPromotor);
        CurrPage.Editable := true;

        UserSetup.Get(UserId);

        if (UserSetup."Salespers./Purch. Code" <> '') and (rec."Cod. promotor" <> '') then begin
            userPromotor := true;
            //SETRANGE("Cod. promotor",UserSetup."Salespers./Purch. Code");
            if (rec.Status <> 0) or (rec."Cod. promotor" <> UserSetup."Salespers./Purch. Code") then
                CurrPage.Editable := false;

        end;

        Estado();
        Editorial();
        ExisteEvento();
        GrupoColegios();


        //IF "Cod. evento" = '' THEN
        //   EditaDesc := TRUE;

        NoPertenecealCDS := false;
        EditaDocente := true;

        if rec."Tipo Responsable" = 1 then begin
            NoPertenecealCDS := true;
            EditaDocente := false;
        end;
    end;

    var
        UserSetup: Record "User Setup";
        SalesPerson: Record "Salesperson/Purchaser";
        CodPromotor: Code[20];
        Text000: Label ',&Approve,&Reject';
        Text001: Label ',&Scheduled,&Rejected';
        Text002: Label ',&Realized,&Canceled';
        Text003: Label 'Change Status to';
        TipoResponsable: Option CDS,Otro;

        NoPertenecealCDS: Boolean;

        EditaDesc: Boolean;

        EditaDocente: Boolean;

        wApro: Boolean;

        wRech: Boolean;

        wProg: Boolean;

        wCanc: Boolean;

        wReal: Boolean;

        wCentros: Boolean;

        wEditAsisReal: Boolean;

        wGS: Boolean;

        wCompetencia: Boolean;

        wProgram: Boolean;

        wProp: Boolean;

        wEquipos: Boolean;

        wSeReq: Boolean;

        wAsistentes: Boolean;

        wExisteEv: Boolean;

        wEvProg: Boolean;

        userPromotor: Boolean;

        wEditExisteEvento: Boolean;

        wReg: Boolean;

        wAsocGrupo: Boolean;

        wElimProg: Boolean;


    procedure RecibeParam(CodProm: Code[20])
    begin
        CodPromotor := CodProm;
        //MESSAGE('%1',CodPromotor);
    end;


    procedure Estado()
    begin

        Clear(wApro);
        Clear(wRech);
        Clear(wProg);
        Clear(wCanc);
        Clear(wReal);
        Clear(wEditAsisReal);
        Clear(wProgram);
        Clear(wProp);
        Clear(wEquipos);
        Clear(wSeReq);
        Clear(wAsistentes);
        Clear(wEvProg);
        Clear(wEditExisteEvento);
        Clear(wElimProg);
        wReg := true;
        if (userPromotor) and (rec.Status > 0) then
            wReg := false;


        case rec.Status of
            rec.Status::" ":
                begin
                    wProp := true;
                    wEditExisteEvento := true;
                end;
            rec.Status::"Enviada por promotor":
                begin
                    wApro := true;
                    wRech := true;
                    wCentros := true;
                    wProp := true;
                    wSeReq := true;
                end;
            rec.Status::Aprobada:
                begin
                    wProg := true;
                    wCanc := true;
                    wCentros := true;
                    wAsistentes := true;
                    wProgram := true;
                    wProp := true;
                    wEquipos := true;
                    wSeReq := true;
                    wEvProg := true;
                end;
            rec.Status::Programada:
                begin
                    wReal := true;
                    wCanc := true;
                    wCentros := true;
                    wEditAsisReal := true;
                    wAsistentes := true;
                    wProgram := true;
                    wEquipos := true;
                    wSeReq := true;
                    wEvProg := true;
                end;

            rec.Status::Realizada:
                begin
                    wReal := true;
                    wCanc := true;
                    wCentros := true;
                    wEditAsisReal := true;
                    wAsistentes := true;
                    wProgram := true;
                    wEquipos := true;
                    wSeReq := true;
                end;

            rec.Status::Cancelada, rec.Status::Rechazada:
                begin
                end;

        end;
    end;


    procedure Editorial()
    begin

        Clear(wGS);
        Clear(wCompetencia);

        case rec."Selección Editorial" of
            rec."Selección Editorial"::Santillana:
                wGS := true;
            rec."Selección Editorial"::Competencia:
                wCompetencia := true;
        end;
    end;


    procedure ExisteEvento()
    begin
        wExisteEv := false;
        if rec."Existe evento" then
            wExisteEv := true;
    end;


    procedure GrupoColegios()
    begin
        wAsocGrupo := false;
        if (rec."Grupo de Colegios") and (rec.Status > 1) then
            wAsocGrupo := true;
    end;


    procedure Act_AsistentesReales()
    var
        CabPlanEvent: Record "Cab. Planif. Evento";
        rProg: Record "Programac. Talleres y Eventos";
        Asist: Integer;
    begin

        Asist := 0;
        if rec."No. Solicitud" <> '' then begin
            CabPlanEvent.SetRange("No. Solicitud", rec."No. Solicitud");
            if CabPlanEvent.FindSet then begin
                rProg.SetRange("Cod. Taller - Evento", CabPlanEvent."Cod. Taller - Evento");
                rProg.SetRange("Tipo Evento", CabPlanEvent."Tipo Evento");
                rProg.SetRange("Tipo de Expositor", CabPlanEvent."Tipo de Expositor");
                rProg.SetRange(rProg.Expositor, CabPlanEvent.Expositor);
                rProg.SetRange(Secuencia, CabPlanEvent.Secuencia);
                if rProg.FindFirst then begin
                    repeat
                        Asist += rProg."Nro. De asistentes reales";
                    until rProg.Next = 0;
                end;
                rec."Asistentes Reales" := Asist;
            end;
        end;
    end;
}

