page 76400 "Solicitud - Proposición Fechas"
{
    ApplicationArea = all;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Solicitud - Proposición Fechas";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fecha propuesta"; rec."Fecha propuesta")
                {
                }
                field("Hora Inicio"; rec."Hora Inicio")
                {
                }
                field("Hora Fin"; rec."Hora Fin")
                {
                }
                field("Cod. Grado"; rec."Cod. Grado")
                {
                }
                field("No. asistentes"; rec."No. asistentes")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        rProp: Record "Solicitud - Proposición Fechas";
        rSol: Record "Solicitud de Taller - Evento";
        TieneGrado: Boolean;
        wAsis: Integer;
        Err001: Label 'El número de asistentes definidos supera al número de asistentes esperados de la solicitud';
    begin
        rProp.Copy(Rec);
        rProp.SetRange(rProp."No. Solicitud", rec."No. Solicitud");
        if rProp.FindSet then
            repeat
                if rProp."Cod. Grado" <> '' then
                    TieneGrado := true;
                wAsis += rProp."No. asistentes"
            until rProp.Next = 0;

        if TieneGrado then begin

            rSol.Get(rec."No. Solicitud");

            if wAsis > rSol."Asistentes Esperados" then
                Error(Err001);

        end;
    end;

    var

        wAceptar: Boolean;


    procedure Aceptar(pAcp: Boolean)
    begin
        wAceptar := pAcp
    end;


    procedure Parametros(par_Editable: Boolean)
    begin
        CurrPage.Editable(par_Editable);
    end;
}

