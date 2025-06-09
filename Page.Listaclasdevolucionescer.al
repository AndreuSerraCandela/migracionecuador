page 56028 "Lista clas. devoluciones cer."
{
    ApplicationArea = all;

    Caption = 'Classification Closed Returns';
    Editable = false;
    PageType = List;
    SourceTable = "Cab. clas. devolucion";
    SourceTableView = WHERE(Closed = CONST(true));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                Editable = false;
                ShowCaption = false;
                field("No."; rec."No.")
                {
                }
                field("Customer no."; rec."Customer no.")
                {
                }
                field("Customer name"; rec."Customer name")
                {
                }
                field("Receipt date"; rec."Receipt date")
                {
                }
                field(Procesada; rec.Procesada)
                {
                }
                field("Usuario clasificacion"; rec."Usuario clasificacion")
                {
                }
                field("Fecha hora clasificacion"; rec."Fecha hora clasificacion")
                {
                }
                field("Dev. ventas generadas"; rec."Dev. ventas generadas")
                {
                    DrillDown = false;
                }
                field("Dev. Trans. generadas"; rec."Dev. Trans. generadas")
                {
                    DrillDown = false;
                }
                field(Comentario; rec.Comentario)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000009>")
            {
                Caption = '&Create documents';
                Ellipsis = true;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CR: Record "Cab. clas. devolucion";
                begin
                    CR.SetRange("No.", rec."No.");
                    CR.FindSet();
                    REPORT.RunModal(REPORT::"Clasifica devoluciones", true, false, CR);
                end;
            }
            action("<Action1000000010>")
            {
                Caption = '&Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CR: Record "Cab. clas. devolucion";
                begin
                    CR.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"Listado clas. devoluciones", true, false, CR);
                end;
            }
            action("Imprimir documentos generados")
            {
                Caption = 'Imprimir documentos generados';
                Image = PrintChecklistReport;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CR: Record "Cab. clas. devolucion";
                begin
                    CR.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"Documentos generados clas. dev", true, false, CR);
                end;
            }
        }
    }

    var
        CreaDev: Report "Clasifica devoluciones";
}

