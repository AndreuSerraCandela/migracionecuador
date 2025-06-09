page 76425 "Visitas A/C - Selec. Docentes"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
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
                        AsistEvento: Record "Asis. Visitas Asesor/Consultor";
                        Err001: Label 'No se permite deseleccionar. Este Docente ya fue inscrito.';
                    begin

                        if Seleccionar then begin
                            AsistEvento.Reset;
                            AsistEvento.SetRange(AsistEvento."No. Visita", gCodVisita);
                            AsistEvento.SetRange("Cod. Docente", rec."Cod. Docente");
                            if not AsistEvento.FindFirst then
                                rec.Mark(Seleccionar);
                        end
                        else begin
                            AsistEvento.Reset;
                            AsistEvento.SetRange(AsistEvento."No. Visita", gCodVisita);
                            AsistEvento.SetRange("Cod. Docente", rec."Cod. Docente");
                            if AsistEvento.FindFirst then
                                Error(Err001);
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
        AsistEvento: Record "Asis. Visitas Asesor/Consultor";
    begin
        Seleccionar := false;
        AsistEvento.Reset;
        AsistEvento.SetRange(AsistEvento."No. Visita", gCodVisita);
        AsistEvento.SetRange("Cod. Docente", rec."Cod. Docente");
        if AsistEvento.FindFirst then
            Seleccionar := true;
    end;

    trigger OnOpenPage()
    var
        rGrupoCOL: Record "Grupo de Colegios";
    begin

        rec.SetRange("Cod. Colegio", gCodCol);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction in [ACTION::OK, ACTION::LookupOK] then
            OKOnPush;
    end;

    var
        gCodVisita: Code[20];
        gCodCol: Code[20];
        gCodLocal: Code[20];
        Seleccionar: Boolean;


    procedure RecibeParametros(CodVisita: Code[20]; CodCol: Code[20]; CodLocal: Code[20])
    begin
        gCodVisita := CodVisita;
        gCodCol := CodCol;
    end;

    local procedure OKOnPush()
    var
        Programacion: Record "Prog. Visitas Asesor/Consultor";
        Asistentes: Record "Asis. Visitas Asesor/Consultor";
    begin

        rec.MarkedOnly(true);
        if rec.FindSet then
            repeat
                Programacion.Reset;
                Programacion.SetRange(Programacion."No. Visita", gCodVisita);
                Programacion.FindSet;
                repeat
                    Asistentes.Init;
                    Asistentes.Validate(Asistentes."No. Visita", Programacion."No. Visita");
                    Asistentes.Validate(Asistentes."No. Linea Progr.", Programacion."No. Linea");
                    Asistentes.Validate("Cod. Docente", rec."Cod. Docente");
                    Asistentes.Insert(true);
                until Programacion.Next = 0;
            until rec.Next = 0;
    end;
}

