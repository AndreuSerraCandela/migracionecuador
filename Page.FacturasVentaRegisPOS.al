#pragma implicitwith disable
page 76213 "Facturas Venta Regis POS"
{
    ApplicationArea = all;
    // #21038  29/05/2015  MOI   Se añaden los campos "CAE" "CAEC" y "respuesta CAE/CAEC".
    //  Proyecto: Implementacion Business Central
    // 
    //  LDP: Luis Jose De La Cruz Paredes
    //  ------------------------------------------------------------------------
    //  No.        Fecha           Firma    Descripcion
    //  ------------------------------------------------------------------------
    //  001        30/11/2023     LDP      Para que se liquiden los documentos SIC.

    Caption = 'POS Posted Sales Invoices';
    CardPageID = "Posted Sales Invoice";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Sales Invoice Header";
    SourceTableView = SORTING("Posting Date", Tienda, "Venta TPV")
                      ORDER(Ascending)
                      WHERE("Venta TPV" = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; rec."Posting Date")
                {
                    Visible = true;
                }
                field("No."; rec."No.")
                {
                }
                field("No. Documento SIC"; rec."No. Documento SIC")
                {
                }
                field("No. Fiscal TPV"; rec."No. Fiscal TPV")
                {
                }
                field("External Document No."; rec."External Document No.")
                {
                }
                field(Liquidado; rec."Liquidado TPV")
                {
                }
                field("Establecimiento Factura"; rec."Establecimiento Factura")
                {
                }
                field("Punto de Emision Factura"; rec."Punto de Emision Factura")
                {
                }
                field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field(Tienda; rec.Tienda)
                {
                }
                field(TPV; rec.TPV)
                {
                }
                field("ID Cajero"; rec."ID Cajero")
                {
                }
                field(Turno; rec.Turno)
                {
                }
                field("Hora creacion"; rec."Hora creacion")
                {
                }
                field("Sell-to Customer No."; rec."Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; rec."Sell-to Customer Name")
                {
                }
                field("Currency Code"; rec."Currency Code")
                {
                }
                field(Amount; rec.Amount)
                {

                    trigger OnDrillDown()
                    begin
                        Rec.SetRange("No.");
                        PAGE.RunModal(PAGE::"Posted Sales Invoice", Rec)
                    end;
                }
                field("Amount Including VAT"; rec."Amount Including VAT")
                {

                    trigger OnDrillDown()
                    begin
                        Rec.SetRange("No.");
                        PAGE.RunModal(PAGE::"Posted Sales Invoice", Rec)
                    end;
                }
                field("VAT Registration No."; rec."VAT Registration No.")
                {
                }
                field("Salesperson Code"; rec."Salesperson Code")
                {
                }
                field("Location Code"; rec."Location Code")
                {
                    Visible = true;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Invoice")
            {
                Caption = '&Invoice';
                Image = Invoice;
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        PAGE.Run(PAGE::"Posted Sales Invoice", Rec)
                    end;
                }
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        if Rec."Tax Area Code" = '' then
                            PAGE.RunModal(PAGE::"Sales Invoice Statistics", Rec, Rec."No.")
                        // else
                        //     PAGE.RunModal(PAGE::"Sales Invoice Stats.", Rec, Rec."No.");
                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = CONST("Posted Invoice"),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
            }
        }
        area(processing)
        {
            action("Liquidar Contra Pagos TPV")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    rParam: Record "Param. CDU DsPOS";
                begin
                    //SalesPost.RegistrarCobrosTPVManual(Rec."No.");//001+-
                    ValidacionesdeErrores.RegistrarCobrosFacturaTPVManual(Rec);//SIC#
                    /*
                    rParam.INIT;
                    rParam.Accion    := rParam.Accion::LiquidarFactura;
                    rParam.Documento := "No.";
                    rParam.Manual    := TRUE;
                    CODEUNIT.RUN(CODEUNIT::"Funciones DsPOS - Comunes",rParam);
                    */

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetSecurityFilterOnRespCenter;
    end;

    var
        ConfigSantillana: Record "Config. Empresa";
        SalesInvHeader: Record "Sales Invoice Header";
        gtCAE: Text[160];
        gtCAEC: Text[160];
        gtRespuesta: Text[100];
        SalesPost: Codeunit "Sales-Post";
        ValidacionesdeErrores: Codeunit "Validaciones de  Errores";
}

#pragma implicitwith restore

