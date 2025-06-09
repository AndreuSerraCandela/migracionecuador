#pragma implicitwith disable
page 76111 "Atenciones - Grupos de Negocio"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Atenciones -Dis. Centros Costo";

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


        if not Rec.FindFirst then
            Calcular;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        rDist: Record "Atenciones -Dis. Centros Costo";
        wPorc: Decimal;
        Err001: Label 'El porcentaje de los centros de coste no deben ser mayores de 100.';
        Err002: Label 'El porcentaje de los centros de coste no deben ser menores de 0.';
    begin

        rDist.Copy(Rec);
        if rDist.FindSet then
            repeat
                wPorc += rDist.Porcentaje;
            until rDist.Next = 0;

        if wPorc > 100 then
            Error(Err001);

        if wPorc < 0 then
            Error(Err002);
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
    end;


    procedure Calcular()
    var
        DistrCentros: Record "Atenciones -Dis. Centros Costo";
    begin



        da.SetRange("Tipo registro", da."Tipo registro"::"Grupo de Negocio");
        if da.FindSet then
            repeat
                Total := 0;
                Porciento := 0;

                DistrCentros.Init;
                DistrCentros."No. Atención" := Rec."No. Atención";
                DistrCentros.Código := da.Codigo;
                DistrCentros.Descripción := da.Descripcion;
                DistrCentros.Porcentaje := Porciento;
                DistrCentros.Insert;
            until da.Next = 0;
    end;
}

#pragma implicitwith restore

