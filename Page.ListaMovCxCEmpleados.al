page 76301 "Lista Mov. CxC Empleados"
{
    ApplicationArea = all;
    CardPageID = "Histórico Préstamos";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Histórico Cab. Préstamo";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
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
                    Visible = false;
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
                    Visible = false;
                }
                field("Motivo Prestamos"; rec."Motivo Prestamos")
                {
                }
                field(Correccion; rec.Correccion)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Employee")
            {
                Caption = '&Employee';
                action("Close Loan")
                {
                    Caption = 'Close Loan';
                    Image = AdjustItemCost;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CierraPrestamo: Report "Cierra Prestamos";
                        HCP: Record "Histórico Cab. Préstamo";
                    begin
                        CurrPage.SetSelectionFilter(HCP);
                        REPORT.Run(REPORT::"Cierra Prestamos", true, false, HCP);
                    end;
                }
            }
        }
    }
}

