page 76272 "Lista Cab. Planif. Evento"
{
    ApplicationArea = all;
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Cab. Planif. Evento";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Expositor; rec.Expositor)
                {
                }
                field("Nombre Expositor"; rec."Nombre Expositor")
                {
                }
                field("Cod. Taller - Evento"; rec."Cod. Taller - Evento")
                {
                }
                field("Description Taller"; rec."Description Taller")
                {
                }
                field("Tipo Evento"; rec."Tipo Evento")
                {
                }
                field("Description Tipo evento"; rec."Description Tipo evento")
                {
                }
                field(Secuencia; rec.Secuencia)
                {
                }
                field("Fecha Programada"; rec."Fecha Programada")
                {
                    Editable = false;
                }
                field("Fecha Realizada"; rec."Fecha Realizada")
                {
                    Editable = false;
                }
                field("Fecha Inicio"; rec."Fecha Inicio")
                {
                }
                field("Numero de sesiones"; rec."Numero de sesiones")
                {
                }
                field("No. Solicitud"; rec."No. Solicitud")
                {
                }
                field(Lunes; rec.Lunes)
                {
                }
                field(Martes; rec.Martes)
                {
                }
                field(Miercoles; rec.Miercoles)
                {
                }
                field(Jueves; rec.Jueves)
                {
                }
                field(Viernes; rec.Viernes)
                {
                }
                field(Sabados; rec.Sabados)
                {
                }
                field(Domingos; rec.Domingos)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1000000038>")
            {
                Caption = '&Event';
                action("<Action1000000039>")
                {
                    Caption = 'New';
                    Image = NewDocument;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Evento: Record Eventos;
                        CabPlanEvent: Record "Cab. Planif. Evento";
                        fCabPlanEvent: Page "Cab. Planif. Evento";
                        Seq: Integer;
                        IndSkip: Boolean;
                    begin
                        Clear(CabPlanEvent);

                        Evento.Reset;
                        Evento.SetRange("No.", gCodEvento);
                        Evento.FindFirst;

                        CabPlanEvent.Validate("Tipo Evento", Evento."Tipo de Evento");
                        CabPlanEvent.Validate("Cod. Taller - Evento", gCodEvento);
                        CabPlanEvent."Tipo de Expositor" := gTipoExpositor;
                        CabPlanEvent.Validate(Expositor, rec.Expositor);

                        CabPlanEvent.Insert(true);
                        Commit;

                        fCabPlanEvent.SetRecord(CabPlanEvent);
                        fCabPlanEvent.RunModal;
                        Clear(fCabPlanEvent);
                    end;
                }
                separator(Action1000000015)
                {
                }
                action(Edit)
                {
                    Caption = 'Edit';
                    Image = Edit;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Cab. Planif. Evento";
                    RunPageLink = "Cod. Taller - Evento" = FIELD("Cod. Taller - Evento"),
                                  "Tipo Evento" = FIELD("Tipo Evento"),
                                  Expositor = FIELD(Expositor),
                                  Secuencia = FIELD(Secuencia);
                }
            }
        }
    }

    trigger OnOpenPage()
    begin

        rec.SetRange("No. Solicitud", '');

        if gCodExpositor <> '' then
            rec.SetRange(Expositor, gCodExpositor);

        if gCodEvento <> '' then
            rec.SetRange("Cod. Taller - Evento", gCodEvento);
    end;

    var
        Fecha: Record Date;
        CabPlanEvent: Record "Cab. Planif. Evento";
        gCodExpositor: Code[20];
        gTipoExpositor: Integer;
        gCodEvento: Code[20];
        gTipoEvento: Code[20];


    procedure RecibeParametros(CodExpositor: Code[20]; TipoExpositor: Integer; CodEvento: Code[20]; TipoEvento: Code[20])
    begin
        gCodExpositor := CodExpositor;
        gTipoExpositor := TipoExpositor;
        gCodEvento := CodEvento;
        gTipoEvento := TipoEvento;
    end;
}

