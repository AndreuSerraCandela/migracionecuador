#pragma implicitwith disable
page 56004 "Cab. Packing Registrado"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    SourceTable = "Cab. Packing Registrado";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; rec."No.")
                {
                }
                field("Cod. Empleado"; rec."Cod. Empleado")
                {
                }
                field("No. Mesa"; rec."No. Mesa")
                {
                }
                field("Picking No."; rec."Picking No.")
                {
                }
                field("Fecha Apertura"; rec."Fecha Apertura")
                {
                }
                field("Fecha Registro"; rec."Fecha Registro")
                {
                }
                field("No. Packing Origen"; rec."No. Packing Origen")
                {
                }
                field("Hora Finalizacion"; rec."Hora Finalizacion")
                {
                }
            }
            part(Control1000000009; "Lin. Packing Registrada")
            {
                SubPageLink = "No." = FIELD("No.");
                SubPageView = SORTING("No.", "No. Caja")
                              ORDER(Ascending);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Imprimir etiquetas")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ConfSant: Record "Config. Empresa";
                    CabPackReg: Record "Cab. Packing Registrado";
                begin
                    ConfSant.Get;
                    ConfSant.TestField("ID Reporte Etiqueta de Caja");

                    CabPackReg.Reset;
                    CabPackReg.SetRange("No.", Rec."No.");
                    if CabPackReg.FindFirst then
                        REPORT.RunModal(ConfSant."ID Reporte Etiqueta de Caja", false, false, CabPackReg);
                end;
            }
        }
    }
}

#pragma implicitwith restore

