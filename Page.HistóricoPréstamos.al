page 76255 "Histórico Préstamos"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    PageType = Document;
    SourceTable = "Histórico Cab. Préstamo";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("No. Préstamo"; rec."No. Préstamo")
                {
                }
                field("Employee No."; rec."Employee No.")
                {
                }
                field("Fecha Registro CxC"; rec."Fecha Registro CxC")
                {
                }
                field("Tipo CxC"; rec."Tipo CxC")
                {
                }
                field("Importe Original"; rec."Importe Original")
                {
                }
                field(Cuotas; rec.Cuotas)
                {
                }
                field("No. Documento"; rec."No. Documento")
                {
                }
                field(Pendiente; rec.Pendiente)
                {
                }
                field("Tipo Contrapartida"; rec."Tipo Contrapartida")
                {
                }
                field("Cta. Contrapartida"; rec."Cta. Contrapartida")
                {
                }
                field("Fecha Inicio Deducción"; rec."Fecha Inicio Deducción")
                {
                }
                field("Nro. Solicitud CK"; rec."Nro. Solicitud CK")
                {
                }
                field("Importe Pendiente Cte."; rec."Importe Pendiente Cte.")
                {
                }
                field("% Cuota"; rec."% Cuota")
                {
                }
                field("No. Mov. Cliente"; rec."No. Mov. Cliente")
                {
                }
                field("Importe Pendiente"; rec."Importe Pendiente")
                {
                }
                field("1ra Quincena"; rec."1ra Quincena")
                {
                }
                field("2da Quincena"; rec."2da Quincena")
                {
                }
                field("Importe Cuota"; rec."Importe Cuota")
                {
                }
                field("Concepto Salarial"; rec."Concepto Salarial")
                {
                }
                field("Motivo Prestamos"; rec."Motivo Prestamos")
                {
                }
                field(Correccion; rec.Correccion)
                {
                }
            }
            part(Control13; "Subform Hist. Préstamo")
            {
                SubPageLink = "No. Préstamo" = FIELD ("No. Préstamo");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Imprimir")
            {
                Caption = '&Imprimir';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(rPrestamo);
                    REPORT.Run(REPORT::"Lista Mov. CxC Empl.", true, true, rPrestamo);
                end;
            }
        }
    }

    var
        rPrestamo: Record "Histórico Cab. Préstamo";
        ImprInfor: Codeunit "Test Report-Print";
}

