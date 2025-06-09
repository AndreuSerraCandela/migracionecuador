#pragma implicitwith disable
page 76220 "Ficha Ejecucion Planificacion"
{
    ApplicationArea = all;
    DataCaptionFields = "Nombre Colegio";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Samples';
    SourceTable = "Promotor - Planif. Visita";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = page_editable;
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                    Editable = false;
                }
                field("Nombre Promotor"; rec."Nombre Promotor")
                {
                    Editable = false;
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Local"; rec."Local")
                {
                }
                field(Fecha; rec.Fecha)
                {
                    Editable = false;
                }
            }
            group(Visit)
            {
                Caption = 'Visit';
                Editable = page_editable;
                field(Turno; rec.Turno)
                {
                }
                field(Nivel; rec.Nivel)
                {
                }
                field(Tipo; rec.Tipo)
                {

                    trigger OnValidate()
                    begin
                        TipoCDS := false;
                        TipoCDS_2 := true;
                        if Rec.Tipo = 1 then begin
                            TipoCDS_2 := false;
                            TipoCDS := true;
                        end;
                    end;
                }
                field("Persona atendio"; rec."Persona atendio")
                {
                    Editable = TipoCDS;
                }
                field("Nombre persona atendio"; rec."Nombre persona atendio")
                {
                    Editable = TipoCDS_2;
                }
                field(Cargo; rec.Cargo)
                {
                }
                field("Descripcion Cargo"; rec."Descripcion Cargo")
                {
                    Editable = false;
                }
                field(Objetivo; rec.Objetivo)
                {
                }
                field("Descripcion Objetivo"; rec."Descripcion Objetivo")
                {
                    Editable = false;
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
                field(Calificacion; rec.Calificacion)
                {
                }
                field(Comentario; rec.Comentario)
                {
                    MultiLine = true;
                    StyleExpr = TRUE;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Planning")
            {
                Caption = '&Planning';
                group("<Action1000000026>")
                {
                    Caption = '&Samples';
                    action(Delivery)
                    {
                        Caption = 'Delivery';
                        Image = NewWarehouseShipment;
                        Promoted = true;
                        PromotedCategory = Category4;
                        PromotedIsBig = true;

                        trigger OnAction()
                        begin
                            Muestras.SetRecord(Rec);
                            Muestras.CargaEntregaMuestras;
                        end;
                    }
                    action(Return)
                    {
                        Caption = 'Return';
                        Image = NewWarehouseReceipt;
                        Promoted = true;
                        PromotedCategory = Category4;
                        PromotedIsBig = true;

                        trigger OnAction()
                        begin
                            Muestras.SetRecord(Rec);
                            Muestras.CargaDevolucionMuestras;
                        end;
                    }
                }
                action("&Post")
                {
                    Caption = '&Post';
                    Enabled = Page_Editable;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        Planif: Record "Promotor - Planif. Visita";
                        Planif2: Record "Promotor - Planif. Visita";
                        CabPlanifReg: Record "TMP Reportes APS";
                        recWFprog: Record "Colegio - Work Flow visitas";
                        Texto001: Label '¿Desea cerrar la visita sin programar?';
                        Error001: Label 'Proceso cancelado por el usuario.';
                    begin
                        Rec.TestField(Turno);
                        Rec.TestField(Nivel);
                        Rec.TestField(Turno);
                        if Rec.Tipo = 0 then
                            Error(Err001);

                        Rec.TestField(Objetivo);

                        Rec.TestField("Hora Inicial Visita");
                        Rec.TestField("Hora Final Visita");
                        Rec.TestField("Fecha Proxima Visita");
                        Rec.TestField(Comentario);

                        recWFprog.SetRange("Cod. Promotor", Rec."Cod. Promotor");
                        recWFprog.SetRange("Cod. Colegio", Rec."Cod. Colegio");
                        recWFprog.SetRange(Programado, true);
                        if not recWFprog.FindFirst then
                            if not Confirm(Texto001) then
                                Error(Error001);

                        ValidaObjetivos(Accion::Registrar);
                        ValidaPasos(Accion::Registrar);

                        Rec.Validate(Estado, Rec.Estado::Completado);
                        Rec.Modify;

                        CurrPage.Close;
                        Message(Text001);
                    end;
                }
                action(Programmed)
                {
                    Caption = 'Programmed';
                    Image = Replan;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        WF: Record "Colegio - Work Flow visitas";
                        Texto001: Label 'Ya está marcado como programado. ¿Desea quitar la marca?';
                        Texto002: Label '¿Desea marcar como programado?';
                        Error001: Label 'No se permite realizar esta acción. La visita está registrada.';
                        Texto003: Label 'La acción se ha realizado con éxito.';
                        Texto004: Label 'Ya está marcado como programado.';
                    begin
                        if Rec.Estado = Rec.Estado::Completado then
                            Error(Error001);

                        WF.Reset;
                        WF.SetRange("Cod. Promotor", Rec."Cod. Promotor");
                        WF.SetRange("Cod. Colegio", Rec."Cod. Colegio");
                        WF.SetRange(Programado, true);
                        if WF.FindFirst then begin
                            //IF CONFIRM(Texto001) THEN BEGIN
                            //  WF.DELETE;
                            //  MESSAGE(Texto003);
                            //END;
                            Error(Texto004);
                        end
                        else begin
                            WF.Reset;
                            if Confirm(Texto002) then begin
                                WF.Init;
                                WF."Cod. Promotor" := Rec."Cod. Promotor";
                                WF."Cod. Colegio" := Rec."Cod. Colegio";
                                WF.Programado := true;
                                WF.Insert(true);
                                Message(Texto003);
                            end;
                        end;
                    end;
                }
                action(Objectives)
                {
                    Caption = 'Objectives';
                    Image = AdjustEntries;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Colegio - Work Flow Objetivos";
                    RunPageLink = "Cod. Promotor" = FIELD("Cod. Promotor"),
                                  "Cod. Colegio" = FIELD("Cod. Colegio"),
                                  Area = CONST(true);
                }
                action(Steps)
                {
                    Caption = 'Steps';
                    Image = ImplementPriceChange;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Colegio - Work Flow Pasos";
                    RunPageLink = "Cod. Promotor" = FIELD("Cod. Promotor"),
                                  "Cod. Colegio" = FIELD("Cod. Colegio"),
                                  Paso = CONST(true);
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Page_Editable := Rec.Estado <> Rec.Estado::Completado;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin

        ValidaObjetivos(Accion::Salir);
        ValidaPasos(Accion::Salir);
    end;

    var
        Text001: Label 'The planning has been posted';
        Muestras: Page "Promotor - Planif. Visitas";
        TipoCDS: Boolean;
        TipoCDS_2: Boolean;
        Page_Editable: Boolean;
        Err001: Label 'Type must be CDS or Other';
        Accion: Option Registrar,Salir;


    procedure ValidaObjetivos(pAccion: Option Registrar,Salir)
    var
        recWFobj: Record "Colegio - Work Flow visitas";
        Texto001: Label '¿Desea %1 sin marcar objetivos?';
        Error001: Label 'Acción cancelada por el usuario.';
        recWFprog: Record "Colegio - Work Flow visitas";
    begin

        recWFprog.Reset;
        recWFprog.SetRange("Cod. Promotor", Rec."Cod. Promotor");
        recWFprog.SetRange("Cod. Colegio", Rec."Cod. Colegio");
        recWFprog.SetRange(Programado, true);
        if recWFprog.FindFirst then begin
            recWFobj.Reset;
            recWFobj.SetRange("Cod. Promotor", Rec."Cod. Promotor");
            recWFobj.SetRange("Cod. Colegio", Rec."Cod. Colegio");
            recWFobj.SetRange(Area, true);
            recWFobj.SetRange(Mantenimiento, true);
            if not recWFobj.FindFirst then begin
                recWFobj.SetRange(Mantenimiento);
                recWFobj.SetRange(Conquista, true);
                if not recWFobj.FindFirst then
                    if not Confirm(StrSubstNo(Texto001, pAccion)) then
                        Error(Error001);
            end;
        end;
    end;


    procedure ValidaPasos(pAccion: Option Registrar,Salir)
    var
        Texto001: Label '¿Desea %1 sin marcar pasos?';
        Error001: Label 'Acción cancelada por el usuario.';
        recWFobj: Record "Colegio - Work Flow visitas";
        recWFpasos: Record "Colegio - Work Flow visitas";
        Texto002: Label '¿Desea %1 sin marcar algún paso más?';
    begin

        recWFobj.Reset;
        recWFobj.SetRange("Cod. Promotor", Rec."Cod. Promotor");
        recWFobj.SetRange("Cod. Colegio", Rec."Cod. Colegio");
        recWFobj.SetRange(Area, true);
        recWFobj.SetRange(Mantenimiento, true);
        if not recWFobj.FindFirst then begin
            recWFobj.SetRange(Mantenimiento);
            recWFobj.SetRange(Conquista, true);
        end;
        if recWFobj.FindFirst then begin
            recWFpasos.Reset;
            recWFpasos.SetRange("Cod. Promotor", Rec."Cod. Promotor");
            recWFpasos.SetRange("Cod. Colegio", Rec."Cod. Colegio");
            recWFpasos.SetRange(Paso, true);
            recWFpasos.SetRange(Resultado, true);
            if not recWFpasos.FindFirst then
                if not Confirm(StrSubstNo(Texto001, pAccion)) then
                    Error(Error001);
            recWFpasos.SetRange(Resultado, false);
            if recWFpasos.FindFirst then
                if not Confirm(StrSubstNo(Texto002, pAccion)) then
                    Error(Error001);

        end;
    end;
}

#pragma implicitwith restore

