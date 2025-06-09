#pragma implicitwith disable
page 76155 "Consulta Asist. Taller/Evento"
{
    ApplicationArea = all;
    Caption = 'View Assist. Workshop/Events';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Asistentes Talleres y Eventos";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("No. Solicitud"; Rec."No. Solicitud")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Tipo Evento"; Rec."Tipo Evento")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Cod. Taller - Evento"; Rec."Cod. Taller - Evento")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Secuencia; Rec.Secuencia)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Cod. Colegio"; Rec."Cod. Colegio")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Cod. Promotor"; Rec."Cod. Promotor")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Description Tipo evento"; Rec."Description Tipo evento")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Description Taller"; Rec."Description Taller")
                {
                    Editable = false;
                }
                field("Nombre Colegio"; Rec."Nombre Colegio")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Nombre Promotor"; Rec."Nombre Promotor")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Fecha inscripcion"; Rec."Fecha inscripcion")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Fecha del Evento"; Rec."Fecha del Evento")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Fecha de realizacion"; Rec."Fecha de realizacion")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Cod. Docente"; Rec."Cod. Docente")
                {
                    Editable = false;
                    TableRelation = Docentes WHERE("Pertenece al CDS" = CONST(true));
                    Visible = false;
                }
                field("Nombre Docente"; Rec."Nombre Docente")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Confirmado; texConfirmado)
                {
                    Caption = 'Confirmado';
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.Confirmado := not Rec.Confirmado;
                        Rec.Modify;

                        FormatBooleanos;
                    end;
                }
                field(Asistio; texAsistio)
                {
                    Caption = 'Attended';
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.Asistio := not Rec.Asistio;
                        Rec.Modify;

                        FormatBooleanos;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        FormatBooleanos;
    end;

    var
        CabPlanEvento: Record "Cab. Planif. Evento";
        SelDoc: Page "Seleccionar Docentes";
        TotDocentes: Integer;
        TotSeleccionados: Integer;
        texAsistio: Text[30];
        texConfirmado: Text[30];


    procedure FormatBooleanos()
    begin
        Clear(texAsistio);
        Clear(texConfirmado);
        if Rec.Asistio then
            texAsistio := Format(Rec.Asistio);
        if Rec.Confirmado then
            texConfirmado := Format(Rec.Confirmado);
    end;
}

#pragma implicitwith restore

