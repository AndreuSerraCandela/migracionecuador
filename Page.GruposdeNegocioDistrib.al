#pragma implicitwith disable
page 76234 "Grupos de Negocio - Distrib."
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Dis. Centros Costo";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Código"; rec.Código)
                {
                }
                field("Descripción"; rec.Descripción)
                {
                }
                field(Porcentaje; rec.Porcentaje)
                {
                    Caption = '%';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        DistrCentros: Record "Dis. Centros Costo";
        UserSetup: Record "User Setup";
    begin

        CurrPage.Editable := true;
        UserSetup.Get(UserId);
        if UserSetup."Salespers./Purch. Code" <> '' then
            if not gModif then
                CurrPage.Editable := false;


        Rec.FilterGroup(2);
        if gCodSolicitud <> '' then begin
            Rec.SetRange("No. Solicitud", gCodSolicitud);
            Rec.SetRange("Cod. Taller - Evento");
            Rec.SetRange("Tipo Evento");
            Rec.SetRange(Expositor);
            Rec.SetRange(Secuencia);
        end
        else begin
            Rec.SetRange("No. Solicitud");
            Rec.SetRange("Cod. Taller - Evento", gCodEvento);
            Rec.SetRange("Tipo Evento", gTipoEvento);
            Rec.SetRange(Expositor, gExpositor);
            Rec.SetRange(Secuencia, gSecuencia);
        end;
        Rec.FilterGroup(2);

        if not Rec.FindFirst then
            Calcular;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        rDist: Record "Dis. Centros Costo";
        wPorc: Decimal;
        Err001: Label 'El porcentaje de los centros de coste no deben ser mayores de 100.';
        Err002: Label 'El porcentaje de los centros de coste no deben ser menores de 0.';
    begin

        //IF "No. Solicitud" <> '' THEN BEGIN
        rDist.Copy(Rec);
        //rDist.SETRANGE(rDist."No. Solicitud", "No. Solicitud");
        if rDist.FindSet then
            repeat
                wPorc += rDist.Porcentaje;
            until rDist.Next = 0;

        if wPorc > 100 then
            Error(Err001);

        if wPorc < 0 then
            Error(Err002);
        //END;
    end;

    var
        ColAdopciones: Record "Colegio - Adopciones Detalle";
        Editoras: Record Editoras;
        da: Record "Datos auxiliares";
        TotalGen: Decimal;
        Total: Decimal;
        Porciento: Decimal;
        gCodColegio: Code[20];
        gCodSolicitud: Code[20];
        gCodEvento: Code[20];
        gTipoEvento: Code[20];
        gTipoExpositor: Code[20];
        gExpositor: Code[20];
        gSecuencia: Integer;
        gGrupo: Boolean;
        gFiltroColegios: Text[1024];
        gModif: Boolean;
        gCodGrupo: Code[20];


    procedure RecibeParametros(CodCol: Code[20]; CodSol: Code[20]; CodEve: Code[20]; TipoEve: Code[20]; CodExpositor: Code[20]; Sec: Integer; Grupo: Boolean; modif: Boolean; CodGrupo: Code[20])
    var
        rGrupoCOL: Record "Grupo de Colegios";
    begin
        gCodColegio := CodCol;
        gCodSolicitud := CodSol;
        gCodEvento := CodEve;
        gTipoEvento := TipoEve;
        gExpositor := CodExpositor;
        gSecuencia := Sec;
        gGrupo := Grupo;
        gCodGrupo := CodGrupo;
        if gGrupo then begin
            rGrupoCOL.Get(gCodGrupo);
            rGrupoCOL.CheckGrupo();
            gFiltroColegios := rGrupoCOL.GetColegios();
        end
        else
            gFiltroColegios := '';
        gModif := modif;
    end;


    procedure Calcular()
    var
        DistrCentros: Record "Dis. Centros Costo";
    begin

        //IF gCodSolicitud = '' THEN
        //  EXIT;

        Editoras.SetRange(Santillana, true);
        Editoras.FindFirst;
        ColAdopciones.Reset;
        if gCodSolicitud <> '' then begin
            if gGrupo then
                ColAdopciones.SetFilter("Cod. Colegio", gFiltroColegios)
            else
                ColAdopciones.SetRange("Cod. Colegio", gCodColegio);
        end;
        ColAdopciones.SetRange("Cod. Editorial", Editoras.Code);
        if ColAdopciones.FindSet then
            TotalGen := ColAdopciones.Count;

        da.SetRange("Tipo registro", da."Tipo registro"::"Grupo de Negocio");
        if da.FindSet then
            repeat
                Total := 0;
                Porciento := 0;

                DistrCentros.Init;
                DistrCentros."No. Solicitud" := gCodSolicitud;
                DistrCentros."Cod. Taller - Evento" := gCodEvento;
                DistrCentros."Tipo Evento" := gTipoEvento;
                DistrCentros.Expositor := gExpositor;
                DistrCentros.Secuencia := gSecuencia;
                DistrCentros.Código := da.Codigo;
                DistrCentros.Descripción := da.Descripcion;


                ColAdopciones.Reset;
                if gCodSolicitud <> '' then begin
                    if gGrupo then
                        ColAdopciones.SetFilter("Cod. Colegio", gFiltroColegios)
                    else
                        ColAdopciones.SetRange("Cod. Colegio", gCodColegio);
                end;
                ColAdopciones.SetRange("Cod. Editorial", Editoras.Code);
                ColAdopciones.SetRange("Grupo de Negocio", Rec."Código");
                if ColAdopciones.FindSet then
                    Total := ColAdopciones.Count;

                if (Total <> 0) and (TotalGen <> 0) then
                    Porciento := Round(Total / TotalGen, 0.01) * 100;
                //    MESSAGE('%1 %2 %3 %4',TotalGen,Total);
                DistrCentros.Porcentaje := Porciento;
                DistrCentros.Insert;
            until da.Next = 0;
    end;
}

#pragma implicitwith restore

