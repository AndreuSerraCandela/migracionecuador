page 53000 "Tareas Impresora Fiscal"
{
    ApplicationArea = all;
    Caption = 'Fiscal Printer Tasks';

    layout
    {
        area(content)
        {
            group("Para Reporte de cierres por fechas")
            {
                Caption = 'Para Reporte de cierres por fechas';
                Visible = false;
                field(FechaDesde; FechaDesde)
                {
                    ShowCaption = false;
                }
                field(FechaHasta; FechaHasta)
                {
                    ShowCaption = false;
                }
                field(Detallado; Detallado)
                {
                    Caption = 'Detallado';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("<Action1000000004>")
            {
                Caption = '&Printed';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    cuImpFisc.AbrePuerto;
                    cuImpFisc.CierreZ('P');
                    cuImpFisc.CerrarPrinter;
                end;
            }
            action("&Cierre X")
            {
                Caption = '&Cierre X';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    cuImpFisc.AbrePuerto;
                    cuImpFisc.CierreX('P');
                    cuImpFisc.CerrarPrinter;
                end;
            }
            separator(Action1000000003)
            {
            }
            action("<Action1000000005>")
            {
                Caption = '&Daily Close by date';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    cuImpFisc.AbrePuerto;
                    if Detallado then
                        cuImpFisc.RepAuditPorFecha(FechaDesde, FechaHasta, 'O')
                    else
                        cuImpFisc.RepAuditPorFecha(FechaDesde, FechaHasta, 'G');
                    cuImpFisc.CerrarPrinter;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ConfSant.Get;
        ConfSant.TestField("Funcionalidad Imp. Fiscal Act.");
    end;

    var
        UserSetUp: Record "User Setup";
        ConfSant: Record "Config. Empresa";
        cuImpFisc: Codeunit "Imp. Fisc. Panama";
        FechaDesde: Date;
        FechaHasta: Date;
        Detallado: Boolean;
}

