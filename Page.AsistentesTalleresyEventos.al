#pragma implicitwith disable
page 76106 "Asistentes Talleres y Eventos"
{
    ApplicationArea = all;

    Caption = 'Workshop/Event Assistants';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Asistentes Talleres y Eventos";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("No. Solicitud"; rec."No. Solicitud")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Tipo Evento"; rec."Tipo Evento")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Cod. Taller - Evento"; rec."Cod. Taller - Evento")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Secuencia; rec.Secuencia)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Description Tipo evento"; rec."Description Tipo evento")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Description Taller"; rec."Description Taller")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Nombre Promotor"; rec."Nombre Promotor")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Fecha inscripcion"; rec."Fecha inscripcion")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Fecha del Evento"; rec."Fecha del Evento")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Fecha de realizacion"; rec."Fecha de realizacion")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Fecha programacion"; rec."Fecha programacion")
                {
                    Editable = false;
                }
                field("Cod. Docente"; rec."Cod. Docente")
                {
                    Editable = false;
                    TableRelation = Docentes WHERE("Pertenece al CDS" = CONST(true));
                }
                field("Nombre Docente"; rec."Nombre Docente")
                {
                    Editable = false;
                }
                field("Document ID"; rec."Document ID")
                {
                    Editable = false;
                }
                field(Inscrito; rec.Inscrito)
                {
                }
                field(Confirmado; rec.Confirmado)
                {
                }
                field(Asistio; rec.Asistio)
                {

                    trigger OnValidate()
                    begin
                        if Rec.Asistio then
                            wAsistentesAsistieron += 1
                        else
                            wAsistentesAsistieron -= 1;
                    end;
                }
            }
            group(Assistants)
            {
                Caption = 'Assistants';
                field(TotDocentes; TotDocentes)
                {
                    Caption = 'Total Capacity';
                    Editable = false;
                }
                field("COUNT"; rec.Count)
                {
                    Caption = 'Selected Teachers';
                    Editable = false;
                }
                field(wAsistentesAsistieron; wAsistentesAsistieron)
                {
                    Caption = 'Docentes Asistieron';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1000000037>")
            {
                Caption = '&Exhibitor';
                action("<Action1000000040>")
                {
                    Caption = '&Select Teachers';
                    Image = EditList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        SelDoc.RecibeParametros(Rec.GetRangeMin("Cod. Taller - Evento"), Rec.GetRangeMin("Cod. Expositor"), Rec.GetRangeMin(Secuencia), gTipoEvento);
                        SelDoc.RunModal;
                        Clear(SelDoc);

                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        /*"Cod. Taller - Evento" := CabPlanEvento."Cod. Taller - Evento";
        "Cod. Expositor" := CabPlanEvento.Expositor;
        Secuencia :=  CabPlanEvento.Secuencia;
        */
        Rec."Tipo Evento" := CabPlanEvento."Tipo Evento";
        //TotSeleccionados := COUNT;

    end;

    trigger OnOpenPage()
    begin
        if gNoSolicitud <> '' then begin
            Rec.SetRange("Tipo Evento", gTipoEvento);
            Rec.SetRange("Cod. Taller - Evento", gCodTaller);
            Rec.SetRange("Cod. Expositor", gCodExpositor);
            Rec.SetRange("No. Solicitud", gNoSolicitud);
            Rec.SetRange(Secuencia, gSec);
            CabPlanEvento.Reset;
            CabPlanEvento.SetRange("Tipo Evento", gTipoEvento);
            CabPlanEvento.SetRange("Cod. Taller - Evento", gCodTaller);
            CabPlanEvento.SetRange(Expositor, gCodExpositor);
            if gNoSolicitud <> '' then
                CabPlanEvento.SetRange("No. Solicitud", gNoSolicitud);
            if CabPlanEvento.FindFirst then;
        end
        else begin
            CabPlanEvento.Reset;
            CabPlanEvento.SetRange("Tipo Evento", Rec.GetRangeMin("Tipo Evento"));
            CabPlanEvento.SetRange("Cod. Taller - Evento", Rec.GetRangeMin("Cod. Taller - Evento"));
            CabPlanEvento.SetRange(Expositor, Rec.GetRangeMin("Cod. Expositor"));
            CabPlanEvento.SetRange(Secuencia, Rec.GetRangeMin(Secuencia));

            CabPlanEvento.FindFirst;
            gTipoEvento := CabPlanEvento."Tipo Evento";
        end;

        ProgEvento.Reset;
        ProgEvento.SetRange("Cod. Taller - Evento", CabPlanEvento."Cod. Taller - Evento");
        ProgEvento.SetRange("Tipo Evento", CabPlanEvento."Tipo Evento");
        ProgEvento.SetRange("Cod. Taller - Evento", CabPlanEvento."Cod. Taller - Evento");
        ProgEvento.SetRange(Expositor, CabPlanEvento.Expositor);
        ProgEvento.SetRange("No. Linea", gLinProg);
        ProgEvento.FindFirst;

        TotDocentes := ProgEvento."Asistentes esperados";
        Rec.SetRange(Asistio, true);
        wAsistentesAsistieron := Rec.Count;
        Rec.SetRange(Asistio);
    end;

    var
        CabPlanEvento: Record "Cab. Planif. Evento";
        SelDoc: Page "Seleccionar Docentes";
        TotDocentes: Integer;
        gCodTaller: Code[20];
        gCodExpositor: Code[20];
        gSec: Integer;
        gTipoEvento: Code[20];
        gNoSolicitud: Code[20];
        ProgEvento: Record "Programac. Talleres y Eventos";
        gTipoExp: Option Docente,Proveedor;
        gLinProg: Integer;
        wAsistentesAsistieron: Integer;


    procedure RecibeParametros(lCodTaller: Code[20]; lCodExpositor: Code[20]; lSec: Integer; lTipoEvento: Code[10]; lNoSolicitud: Code[20]; lCodColegio: Code[20]; lCodPromotor: Code[20]; lFecha: Date; lTipoExp: Option Docente,Proveedor)
    begin
        gCodTaller := lCodTaller;
        gCodExpositor := lCodExpositor;
        gSec := lSec;
        gTipoEvento := lTipoEvento;
        gNoSolicitud := lNoSolicitud;
        gTipoExp := lTipoExp;

        CabPlanEvento.Reset;
        CabPlanEvento.SetRange("Tipo Evento", gTipoEvento);
        CabPlanEvento.SetRange("Cod. Taller - Evento", gCodTaller);
        CabPlanEvento.SetRange(Expositor, gCodExpositor);
        CabPlanEvento.SetRange("No. Solicitud", gNoSolicitud);
        /*
        IF NOT CabPlanEvento.FINDFIRST THEN
           BEGIN
            CLEAR(CabPlanEvento);
            CabPlanEvento.VALIDATE("Tipo Evento",gTipoEvento);
            CabPlanEvento.VALIDATE("Cod. Taller - Evento",gCodTaller);
            CabPlanEvento.VALIDATE("Tipo de Expositor",gTipoExp);
            CabPlanEvento.VALIDATE(Expositor,gCodExpositor);
            CabPlanEvento.VALIDATE("No. Solicitud",gNoSolicitud);
            CabPlanEvento.VALIDATE("Fecha Inicio",lFecha);
            IF lCodColegio <> '' THEN
               CabPlanEvento.VALIDATE("Cod. Colegio",lCodColegio);
            IF lCodPromotor <> '' THEN
               CabPlanEvento.VALIDATE("Cod. Promotor",lCodPromotor);
            CabPlanEvento.INSERT(TRUE);
            gSec       := 1;
            COMMIT;
           END
        ELSE
        */
        CabPlanEvento.FindFirst;
        gSec := CabPlanEvento.Secuencia;

    end;


    procedure RecibeProgEvento(lLinProg: Integer)
    var
        gProgEvento: Record "Programac. Talleres y Eventos";
    begin

        gLinProg := lLinProg;
    end;
}

#pragma implicitwith restore

