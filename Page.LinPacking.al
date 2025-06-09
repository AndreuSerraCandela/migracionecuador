page 56001 "Lin. Packing"
{
    ApplicationArea = all;
    // #4191  PLB  30/09/2014  Añadido atajo de teclado a "Contenido caja" -> Mayús+Ctrl+D

    Caption = 'Packing Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Lin. Packing";
    SourceTableView = SORTING("No.", "No. Caja")
                      ORDER(Ascending);

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
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000008>")
            {
                Caption = '&Eliminar Caja';

                trigger OnAction()
                begin
                    if Confirm(txt0001, false) then begin
                        rec.Delete;
                    end;
                end;
            }
            separator(Action1000000009)
            {
            }
            action("<Action1000000011>")
            {
                Caption = '&Box Content';
                InFooterBar = true;

                RunObject = Page "Cajas Packing";
                RunPageLink = "No. Packing" = FIELD("No."),
                              "No. Caja" = FIELD("No. Caja"),
                              "No. Picking" = FIELD("No. Picking");
                RunPageView = SORTING("No. Packing", "No. Caja", "No. Picking", "No. Producto", "No. Linea")
                              ORDER(Ascending);
                ShortCutKey = 'Shift+Ctrl+D';
            }
            separator(Action1000000012)
            {
            }
            action("&Reabrir Caja")
            {
                Caption = '&Reabrir Caja';

                trigger OnAction()
                begin
                    if Confirm(txt005, false) then
                        ReabrirCaja;
                end;
            }
            group("<Action1000000010>")
            {
                Caption = '&Imprimir';
                action("<Action1000000006>")
                {
                    Caption = '&Print Box Tag';

                    trigger OnAction()
                    begin
                        ConfSant.Get;
                        ConfSant.TestField("ID Reporte Etiqueta de Caja");
                        CurrPage.SetSelectionFilter(LinPack);
                        REPORT.RunModal(56019, true, true, LinPack);
                    end;
                }
            }
        }
    }

    var
        txt0001: Label 'Confirm that you want to delete the selected box';
        LinPack: Record "Lin. Packing";
        ConfSant: Record "Config. Empresa";
        txt005: Label 'Confirm that you want to open the box';


    procedure ReabrirCaja()
    var
        FuncSant: Codeunit "Funciones Santillana";
    begin
        FuncSant.ReabrirCajaPacking(Rec);
    end;
}

