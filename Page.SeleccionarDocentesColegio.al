page 76387 "Seleccionar Docentes - Colegio"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Colegio - Docentes";
    SourceTableView = WHERE("Pertenece al CDS" = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Seleccionar; Seleccionar)
                {
                    Caption = 'Select';

                    trigger OnValidate()
                    var
                        AsistEvento: Record "Asistentes Talleres y Eventos";
                    begin

                        if Seleccionar then begin
                            AsistEvento.Reset;
                            AsistEvento.SetRange("Cod. Taller - Evento", gCodEvento);
                            AsistEvento.SetRange("Cod. Expositor", gCodExpositor);
                            AsistEvento.SetRange(Secuencia, Sec);
                            AsistEvento.SetRange("Tipo Evento", gTipoEvento);
                            AsistEvento.SetRange("Cod. Docente", rec."Cod. Docente");
                            if not AsistEvento.FindFirst then
                                rec.Mark(Seleccionar);
                        end;
                    end;
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Cod. Docente"; rec."Cod. Docente")
                {
                }
                field("Nombre docente"; rec."Nombre docente")
                {
                }
                field("Cod. Cargo"; rec."Cod. Cargo")
                {
                }
                field("Docente - Phone No."; rec."Docente - Phone No.")
                {
                }
                field("Docente - Document ID"; rec."Docente - Document ID")
                {
                }
                field("Docente - E-Mail"; rec."Docente - E-Mail")
                {
                }
                field("Pertenece al CDS"; rec."Pertenece al CDS")
                {
                    Editable = false;
                }
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                }
                field("Nombre Promotor"; rec."Nombre Promotor")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Action1000000004)
            {
                action(Action1000000005)
                {

                    trigger OnAction()
                    begin
                        /*
                        TH.GET(NoDocumento);
                        SETRANGE("Location Code",TH."Transfer-from Code");
                        SETRANGE("Bin Code",TH."Cod. Ubicacion Alm. Origen");

                        MARKEDONLY(TRUE);
                        IF FINDSET THEN
                            REPEAT
                             NoLin += 1000;
                             TL.INIT;
                             TL."Document No." := TH."No.";
                             TL."Line No."     := NoLin;
                             TL.VALIDATE("Transfer-from Code",TH."Transfer-from Code");
                             TL.VALIDATE("Transfer-to Code",TH."Transfer-to Code");
                             TL.VALIDATE("Item No.","Item No.");
                        //     TL.VALIDATE(Quantity,1);
                             IF TH."Cod. Ubicacion Alm. Origen" <> '' THEN
                                TL.VALIDATE("Transfer-from Bin Code",TH."Cod. Ubicacion Alm. Origen");
                             IF TH."Cod. Ubicacion Alm. Destino" <> '' THEN
                                TL.VALIDATE("Transfer-To Bin Code",TH."Cod. Ubicacion Alm. Destino");
                             IF NOT TL.INSERT(TRUE) THEN
                                TL.MODIFY(TRUE);
                            UNTIL NEXT = 0;
                        */

                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        AsistEvento: Record "Asistentes Talleres y Eventos";
    begin
        Seleccionar := false;
        AsistEvento.Reset;
        AsistEvento.SetRange("Cod. Taller - Evento", gCodEvento);
        AsistEvento.SetRange("Cod. Expositor", gCodExpositor);
        AsistEvento.SetRange(Secuencia, Sec);
        AsistEvento.SetRange("Tipo Evento", gTipoEvento);
        AsistEvento.SetRange("Cod. Docente", rec."Cod. Docente");
        if AsistEvento.FindFirst then
            Seleccionar := true;
    end;

    trigger OnOpenPage()
    var
        rGrupoCOL: Record "Grupo de Colegios";
    begin
        if gGrupo then begin
            rGrupoCOL.Get(gCodGrupo);
            rGrupoCOL.CheckGrupo();
            rec.SetFilter("Cod. Colegio", rGrupoCOL.GetColegios());
        end
        else begin
            rec.SetRange("Cod. Colegio", gCodCol);
            rec.SetRange("Cod. Local", gCodLocal);
        end;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction in [ACTION::OK, ACTION::LookupOK] then
            OKOnPush;
    end;

    var
        Asistentes: Record "Asistentes Talleres y Eventos";
        CabPlanifEvento: Record "Cab. Planif. Evento";
        gCodEvento: Code[20];
        gCodExpositor: Code[20];
        gTipoEvento: Code[20];
        Sec: Integer;
        Seleccionar: Boolean;
        gCodCol: Code[20];
        gCodLocal: Code[20];
        gGrupo: Boolean;
        gCodGrupo: Code[20];


    procedure RecibeParametros(CodEvento: Code[20]; CodExpositor: Code[20]; Secuencia: Integer; TipoEvento: Code[20]; CodCol: Code[20]; CodLocal: Code[20]; Grupo: Boolean; CodGrupo: Code[20])
    begin
        gCodEvento := CodEvento;
        Sec := Secuencia;
        gCodExpositor := CodExpositor;
        gTipoEvento := TipoEvento;
        gCodCol := CodCol;
        gCodLocal := CodLocal;
        gGrupo := Grupo;
        gCodGrupo := CodGrupo;
    end;

    local procedure OKOnPush()
    var
        Programacion: Record "Programac. Talleres y Eventos";
    begin
        CabPlanifEvento.Reset;
        CabPlanifEvento.SetRange("Tipo Evento", gTipoEvento);
        CabPlanifEvento.SetRange("Cod. Taller - Evento", gCodEvento);
        CabPlanifEvento.SetRange(Expositor, gCodExpositor);
        CabPlanifEvento.SetRange(Secuencia, Sec);
        CabPlanifEvento.FindFirst;

        rec.MarkedOnly(true);
        if rec.FindSet then
            repeat
                Programacion.Reset;
                Programacion.SetRange("Cod. Taller - Evento", CabPlanifEvento."Cod. Taller - Evento");
                Programacion.SetRange("Tipo Evento", CabPlanifEvento."Tipo Evento");
                Programacion.SetRange(Expositor, CabPlanifEvento.Expositor);
                Programacion.SetRange(Secuencia, CabPlanifEvento.Secuencia);
                Programacion.FindSet;
                repeat
                    Asistentes.Init;
                    Asistentes.Validate("Tipo Evento", gTipoEvento);
                    Asistentes.Validate("Cod. Taller - Evento", CabPlanifEvento."Cod. Taller - Evento");
                    Asistentes.Validate("Tipo de Expositor", Programacion."Tipo de Expositor");
                    Asistentes.Validate("Cod. Expositor", gCodExpositor);
                    Asistentes.Secuencia := Sec;
                    Asistentes.Validate("Cod. Docente", rec."Cod. Docente");
                    Asistentes."No Linea Programac." := Programacion."No. Linea";
                    Asistentes."Fecha programacion" := Programacion."Fecha programacion";
                    Asistentes."No. Solicitud" := CabPlanifEvento."No. Solicitud";
                    Asistentes.Insert(true);
                until Programacion.Next = 0;
            until rec.Next = 0;
    end;
}

