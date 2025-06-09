page 76386 "Seleccionar Docentes"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = Docentes;

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
                            AsistEvento.SetRange("Cod. Docente", rec."No.");
                            if not AsistEvento.FindFirst then
                                rec.Mark(Seleccionar);
                        end;
                    end;
                }
                field("No."; rec."No.")
                {
                }
                field("First Name"; rec."First Name")
                {
                }
                field("Middle Name"; rec."Middle Name")
                {
                }
                field("Last Name"; rec."Last Name")
                {
                }
                field("Second Last Name"; rec."Second Last Name")
                {
                }
                field("Full Name"; rec."Full Name")
                {
                }
                field("Tipo documento"; rec."Tipo documento")
                {
                }
                field("Document ID"; rec."Document ID")
                {
                }
                field("Pertenece al CDS"; rec."Pertenece al CDS")
                {
                }
                field("Cod. CDS"; rec."Cod. CDS")
                {
                }
                field("Ano inscripcion CDS"; rec."Ano inscripcion CDS")
                {
                }
                field(Status; rec.Status)
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000016; "Colegios -  Docentes ListPart")
            {
                SubPageLink = "Cod. Docente" = FIELD("No.");
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
        AsistEvento.SetRange("Cod. Docente", rec."No.");
        if AsistEvento.FindFirst then
            Seleccionar := true;
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


    procedure RecibeParametros(CodEvento: Code[20]; CodExpositor: Code[20]; Secuencia: Integer; TipoEvento: Code[20])
    begin
        gCodEvento := CodEvento;
        Sec := Secuencia;
        gCodExpositor := CodExpositor;
        gTipoEvento := TipoEvento;
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
                    Asistentes.Validate("Cod. Docente", rec."No.");
                    Asistentes."No Linea Programac." := Programacion."No. Linea";
                    Asistentes."Fecha programacion" := Programacion."Fecha programacion";
                    Asistentes."No. Solicitud" := CabPlanifEvento."No. Solicitud";
                    Asistentes.Insert(true);
                until Programacion.Next = 0;
            until rec.Next = 0;
    end;
}

