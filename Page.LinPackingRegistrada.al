page 56005 "Lin. Packing Registrada"
{
    ApplicationArea = all;
    Caption = 'Posted Packing Line';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Lin. Packing Registrada";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Caja"; rec."No. Caja")
                {
                }
                field("Fecha Apertura Caja"; rec."Fecha Apertura Caja")
                {
                }
                field("Fecha Cierre Caja"; rec."Fecha Cierre Caja")
                {
                }
                field("Estado Caja"; rec."Estado Caja")
                {
                }
                field("No. Palet"; rec."No. Palet")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000007>")
            {
                Caption = '&Box Content';
                RunObject = Page "Cont. Caja Registrada";
                RunPageLink = "No. Packing" = FIELD("No."),
                              "No. Caja" = FIELD("No. Caja");
                RunPageView = SORTING("No. Packing", "No. Caja", "No. Picking", "No. Producto", "No. Linea")
                              ORDER(Ascending);
            }
            action("Imprimir Etiqueta")
            {
                Caption = '&Print Label';

                trigger OnAction()
                begin
                    ImprimeEtiquetaCaja;
                end;
            }
        }
    }

    var
        ConfSant: Record "Config. Empresa";
        LinPackReg: Record "Lin. Packing Registrada";


    procedure ContenidoCajas()
    begin
        rec.ContenidoCaja;
    end;


    procedure ImprimeEtiquetaCaja()
    begin
        ConfSant.Get;
        ConfSant.TestField("ID Reporte Etiqueta de Caja");
        //CurrPage.SETSELECTIONFILTER(LinPackReg);

        LinPackReg.Reset;
        LinPackReg.SetRange("No.", rec."No.");
        LinPackReg.SetRange("No. Caja", rec."No. Caja");
        if LinPackReg.FindFirst then
            REPORT.RunModal(ConfSant."ID Reporte Etiqueta de Caja", false, false, LinPackReg);
    end;
}

