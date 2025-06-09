page 76310 "Lista Seleccion eventos"
{
    ApplicationArea = all;
    Caption = 'Selection of Events';
    PageType = List;
    SourceTable = "Cab. Planif. Evento";
    SourceTableView = WHERE(Estado = CONST(" "));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Seleccionado; Seleccionado)
                {
                    Caption = 'Select';

                    trigger OnValidate()
                    var
                        rProgEv: Record "Programac. Talleres y Eventos";
                    begin
                        if Seleccionado then begin
                            rProgEv.Reset;
                            rProgEv.SetRange(rProgEv."Cod. Taller - Evento", rec."Cod. Taller - Evento");
                            rProgEv.SetRange(rProgEv.Expositor, rec.Expositor);
                            rProgEv.SetRange(rProgEv.Secuencia, rec.Secuencia);
                            rProgEv.SetRange(rProgEv."Tipo Evento", rec."Tipo Evento");
                            if rProgEv.FindFirst then
                                repeat
                                    AsistEvento.Reset;
                                    AsistEvento.Validate("Tipo Evento", rec."Tipo Evento");
                                    AsistEvento.Validate("Cod. Taller - Evento", rec."Cod. Taller - Evento");
                                    AsistEvento."Tipo de Expositor" := rec."Tipo de Expositor";
                                    AsistEvento.Validate("Cod. Expositor", rec.Expositor);
                                    AsistEvento.Validate("No Linea Programac.", rProgEv."No. Linea");
                                    AsistEvento.Validate(Secuencia, rec.Secuencia);
                                    AsistEvento.Validate("Cod. Docente", gCodDocente);
                                    if AsistEvento.Insert(true) then;
                                until rProgEv.Next = 0;
                        end
                        else begin
                            AsistEvento.Reset;
                            AsistEvento.SetRange("Cod. Taller - Evento", rec."Cod. Taller - Evento");
                            AsistEvento.SetRange("Cod. Expositor", rec.Expositor);
                            AsistEvento.SetRange(Secuencia, rec.Secuencia);
                            AsistEvento.SetRange("Tipo Evento", rec."Tipo Evento");
                            AsistEvento.SetRange("Cod. Docente", gCodDocente);
                            if AsistEvento.FindFirst then
                                repeat
                                    AsistEvento.Delete(true);
                                until AsistEvento.Next = 0;
                        end
                    end;
                }
                field("Tipo Evento"; rec."Tipo Evento")
                {
                    Editable = false;
                }
                field("Cod. Taller - Evento"; rec."Cod. Taller - Evento")
                {
                    Editable = false;
                }
                field(Expositor; rec.Expositor)
                {
                    Editable = false;
                }
                field(Secuencia; rec.Secuencia)
                {
                    Editable = false;
                }
                field("No. Solicitud"; rec."No. Solicitud")
                {
                    Editable = false;
                }
                field("Fecha Inicio"; rec."Fecha Inicio")
                {
                }
                field("Numero de sesiones"; rec."Numero de sesiones")
                {
                }
                field("Fecha Programada"; rec."Fecha Programada")
                {
                }
                field("Fecha Realizada"; rec."Fecha Realizada")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Description Tipo evento"; rec."Description Tipo evento")
                {
                    Editable = false;
                }
                field("Description Taller"; rec."Description Taller")
                {
                    Editable = false;
                }
                field("Nombre Expositor"; rec."Nombre Expositor")
                {
                    Editable = false;
                }
                field("Asistentes esperados"; rec."Asistentes esperados")
                {
                    Editable = false;
                }
                field("Total registrados"; rec."Total registrados")
                {
                }
                field(Delegacion; rec.Delegacion)
                {
                }
                field("Descripcion Delegacion"; rec."Descripcion Delegacion")
                {
                }
                field(Estado; rec.Estado)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Seleccionado := false;
        AsistEvento.Reset;
        AsistEvento.SetRange("Cod. Taller - Evento", rec."Cod. Taller - Evento");
        AsistEvento.SetRange("Cod. Expositor", rec.Expositor);
        AsistEvento.SetRange(Secuencia, rec.Secuencia);
        AsistEvento.SetRange("Tipo Evento", rec."Tipo Evento");
        AsistEvento.SetRange("Cod. Docente", gCodDocente);
        if AsistEvento.FindFirst then
            Seleccionado := true;
    end;

    trigger OnOpenPage()
    begin
        rec.SetRange("No. Solicitud", '');
    end;

    var
        AsistEvento: Record "Asistentes Talleres y Eventos";
        Seleccionado: Boolean;
        gCodDocente: Code[20];


    procedure RecibeParametro(CodDocente: Code[20])
    begin
        gCodDocente := CodDocente;
    end;
}

