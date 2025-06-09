page 76373 "Registrar Asistencias"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
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
                    Editable = false;
                }
                field("Nombre Expositor"; rec."Nombre Expositor")
                {
                    Editable = false;
                }
                field("Cod. Taller - Evento"; rec."Cod. Taller - Evento")
                {
                    Editable = false;
                }
                field("Description Taller"; rec."Description Taller")
                {
                    Editable = false;
                }
                field("Tipo Evento"; rec."Tipo Evento")
                {
                    Editable = false;
                }
                field("Description Tipo evento"; rec."Description Tipo evento")
                {
                    Editable = false;
                }
                field(Secuencia; rec.Secuencia)
                {
                    Editable = false;
                }
                field("Fecha Inicio"; rec."Fecha Inicio")
                {
                    Editable = false;
                }
                field("No. Solicitud"; rec."No. Solicitud")
                {
                }
                field("Numero de sesiones"; rec."Numero de sesiones")
                {
                    Editable = false;
                }
                field(Lunes; rec.Lunes)
                {
                    Editable = false;
                }
                field(Martes; rec.Martes)
                {
                    Editable = false;
                }
                field(Miercoles; rec.Miercoles)
                {
                    Editable = false;
                }
                field(Jueves; rec.Jueves)
                {
                    Editable = false;
                }
                field(Viernes; rec.Viernes)
                {
                    Editable = false;
                }
                field(Sabados; rec.Sabados)
                {
                    Editable = false;
                }
                field(Domingos; rec.Domingos)
                {
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            part(ConsultaPLanTyE; "Consulta Planif. Taller/Evento")
            {
                Editable = false;
                ShowFilter = false;
                SubPageLink = "Cod. Taller - Evento" = FIELD("Cod. Taller - Evento"),
                              "Tipo Evento" = FIELD("Tipo Evento"),
                              Expositor = FIELD(Expositor),
                              Secuencia = FIELD(Secuencia);
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
                action("<Action1000000022>")
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
                action("Register Assistants")
                {
                    Caption = 'Register Assistants';
                    Image = OpenWorksheet;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        "ProgT&E": Record "Programac. Talleres y Eventos";
                    begin
                        CurrPage.ConsultaPLanTyE.PAGE.AbrirPagAsistentes;

                        //CurrPage.ConsultaPLanTyE.FORM.GETRECORD("ProgT&E");
                        //MESSAGE('%1',aa);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        rec.SetRange("No. Solicitud", '');

        if gCodExpositor <> '' then
            rec.SetRange(Expositor, gCodExpositor);
    end;

    var
        PagAsistentes: Page "Consulta Planif. Taller/Evento";
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

