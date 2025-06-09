page 76311 "Lista Solicitudes T&E"
{
    ApplicationArea = all;

    Caption = 'T&E Request List';
    CardPageID = "Solicitud asistencia Tec - Ped";
    Editable = false;
    PageType = List;
    SourceTable = "Solicitud de Taller - Evento";
    SourceTableView = SORTING("Fecha Propuesta");
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("No. Solicitud"; rec."No. Solicitud")
                {
                }
                field("Cod. promotor"; rec."Cod. promotor")
                {
                }
                field("Nombre promotor"; rec."Nombre promotor")
                {
                }
                field("Grupo de Negocio"; rec."Grupo de Negocio")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Tipo de Evento"; rec."Tipo de Evento")
                {
                }
                field("Existe evento"; rec."Existe evento")
                {
                }
                field("Cod. evento"; rec."Cod. evento")
                {
                    Editable = false;
                }
                field("Descripcion evento"; rec."Descripcion evento")
                {
                }
                field("Evento dictado por (tipo)"; rec."Evento dictado por (tipo)")
                {
                }
                field("Evento dictado por (codigo)"; rec."Evento dictado por (codigo)")
                {
                }
                field("Evento dictado por (nombre)"; rec."Evento dictado por (nombre)")
                {
                }
                field("Grupo de Colegios"; rec."Grupo de Colegios")
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field("Direccion Colegio"; rec."Direccion Colegio")
                {
                }
                field(Referencia; rec.Referencia)
                {
                }
                field("Codigo Distrito Colegio"; rec."Codigo Distrito Colegio")
                {
                }
                field("Nombre Distrito Colegio"; rec."Nombre Distrito Colegio")
                {
                }
                field("KPI Status"; rec."KPI Status")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field(Status; rec.Status)
                {
                }
                field("Fecha Solicitud"; rec."Fecha Solicitud")
                {
                }
                field("Fecha Propuesta"; rec."Fecha Propuesta")
                {
                    Caption = 'Fecha Propuesta';
                }
                field("Fecha programada"; rec."Fecha programada")
                {
                    Caption = 'Fecha Programada';
                }
                field(Delegacion; rec.Delegacion)
                {
                }
                field("Cod. evento programado"; rec."Cod. evento programado")
                {
                }
                field("Descripción evento programado"; rec."Descripción evento programado")
                {
                }
                field("Tipo de Expositor"; rec."Tipo de Expositor")
                {
                }
                field("Cod. Expositor"; rec."Cod. Expositor")
                {
                }
                field("Nombre expositor"; rec."Nombre expositor")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Request")
            {
                Caption = '&Request';
                action("&Card")
                {
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "Solicitud asistencia Tec - Ped";
                    RunPageLink = "No. Solicitud" = FIELD("No. Solicitud");
                    ShortCutKey = 'Shift+F5';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        wFechaProp := rec.GetFechaPropuesta();
        wFechaProg := rec.GetFechaProgramada();
    end;

    trigger OnOpenPage()
    begin
        if CodPromotor <> '' then begin
            rec.SetRange("Cod. promotor", CodPromotor);
        end;

        if (CodPromotor = '') and (recUsuario.Get(UserId)) then
            if recUsuario."Salespers./Purch. Code" <> '' then
                rec.SetRange("Cod. promotor", recUsuario."Salespers./Purch. Code");
    end;

    var
        CodPromotor: Code[20];
        wFechaProp: Date;
        wFechaProg: Date;
        recUsuario: Record "User Setup";


    procedure RecibeParam(CodProm: Code[20])
    begin
        CodPromotor := CodProm;
    end;
}

