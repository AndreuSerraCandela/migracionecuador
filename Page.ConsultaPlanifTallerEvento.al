#pragma implicitwith disable
page 76158 "Consulta Planif. Taller/Evento"
{
    ApplicationArea = all;
    Caption = 'View Assist. Workshop/Events';
    PageType = ListPart;
    SourceTable = "Programac. Talleres y Eventos";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Fecha inscripcion"; Rec."Fecha inscripcion")
                {
                    Visible = false;
                }
                field("Fecha programacion"; Rec."Fecha programacion")
                {
                    Visible = false;
                }
                field("Fecha de realizacion"; Rec."Fecha de realizacion")
                {
                }
                field("Asistentes esperados"; Rec."Asistentes esperados")
                {
                }
                field("Nro. De asistentes reales"; Rec."Nro. De asistentes reales")
                {
                }
                field("Horas dictadas"; Rec."Horas dictadas")
                {
                    Visible = false;
                }
                field(Secuencia; Rec.Secuencia)
                {
                    Visible = false;
                }
                field(Estado; Rec.Estado)
                {
                }
                field("Hora de Inicio"; Rec."Hora de Inicio")
                {
                    Visible = false;
                }
                field("Hora Final"; Rec."Hora Final")
                {
                    Visible = false;
                }
                field("CabPlanEvento.""Total registrados"""; CabPlanEvento."Total registrados")
                {
                    Caption = 'Total registered';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CabPlanEvento.Reset;
        CabPlanEvento.SetRange("Cod. Taller - Evento", Rec."Cod. Taller - Evento");
        CabPlanEvento.SetRange(Expositor, Rec.Expositor);
        CabPlanEvento.SetRange(Secuencia, Rec.Secuencia);
        CabPlanEvento.SetRange("Tipo Evento", Rec."Tipo Evento");
        CabPlanEvento.FindFirst;
        CabPlanEvento.CalcFields("Total registrados");
    end;

    var
        CabPlanEvento: Record "Cab. Planif. Evento";
        SelDoc: Page "Seleccionar Docentes";
        TotDocentes: Integer;
        TotSeleccionados: Integer;
        TotReg: Integer;


    procedure AbrirPagAsistentes()
    var
        ATE: Record "Asistentes Talleres y Eventos";
        ATE2: Record "Asistentes Talleres y Eventos";
        PagATE: Page "Asistentes Talleres y Eventos";
    begin
        //MESSAGE('%1',Rec);
        ATE.Reset;
        ATE.SetRange("Cod. Taller - Evento", Rec."Cod. Taller - Evento");
        ATE.SetRange("Tipo Evento", Rec."Tipo Evento");
        ATE.SetRange(Secuencia, Rec.Secuencia);
        ATE.SetRange("Cod. Expositor", Rec.Expositor);
        ATE.SetRange("Fecha programacion", 0D);
        if ATE.FindSet then begin
            repeat
                Clear(ATE2);
                ATE2.TransferFields(ATE);
                ATE2."Fecha programacion" := Rec."Fecha programacion";
                if ATE2.Insert(true) then;
            until ATE.Next = 0;
            Commit;
        end;

        ATE.Reset;
        ATE.SetRange("Cod. Taller - Evento", Rec."Cod. Taller - Evento");
        ATE.SetRange("Tipo Evento", Rec."Tipo Evento");
        ATE.SetRange(Secuencia, Rec.Secuencia);
        ATE.SetRange("Cod. Expositor", Rec.Expositor);
        ATE.SetRange("Fecha programacion", Rec."Fecha programacion");
        ATE.FindFirst;

        PagATE.SetTableView(ATE);
        PagATE.RunModal;
        Clear(PagATE);
    end;
}

#pragma implicitwith restore

