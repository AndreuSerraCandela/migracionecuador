#pragma implicitwith disable
page 76102 "Asistencia Docentes x Colegio"
{
    ApplicationArea = all;
    CardPageID = "Solicitud asistencia Tec - Ped";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Solicitud de Taller - Evento";
    SourceTableView = SORTING("No. Solicitud")
                      WHERE(Status = CONST(Realizada));

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
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
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
                field("Cod. evento programado"; rec."Cod. evento programado")
                {
                }
                field("Descripción evento programado"; rec."Descripción evento programado")
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
                action("<Action1000000025>")
                {
                    Caption = '&Asistencia';
                    Image = OpenWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Cab. Planif. Evento";
                    RunPageLink = "No. Solicitud" = FIELD("No. Solicitud");
                    ShortCutKey = 'Shift+F5';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if CodPromotor <> '' then begin
            Rec.SetRange("Cod. promotor", CodPromotor);
        end;
    end;

    var
        CodPromotor: Code[20];


    procedure RecibeParam(CodProm: Code[20])
    begin
        CodPromotor := CodProm;
    end;
}

#pragma implicitwith restore

