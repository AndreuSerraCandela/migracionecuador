page 76331 "Notas Credito Venta Regis POS"
{
    ApplicationArea = all;
    // #21038  29/05/2015  MOI   Se añaden los campos "CAE" "CAEC" y "Respuesta CAE/CAEC".

    Caption = 'POS Posted Sales Credit Memos';
    CardPageID = "Posted Sales Credit Memo";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Cr.Memo Header";
    SourceTableView = SORTING("Posting Date")
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
                field("Establecimiento Factura"; rec."Establecimiento Factura")
                {
                }
                field("Punto de Emision Factura"; rec."Punto de Emision Factura")
                {
                }
                field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
                {
                }
                field("No. Fiscal TPV"; rec."No. Fiscal TPV")
                {
                }
                field(Liquidado; rec."Liquidado TPV")
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field("No. Serie NCF Abonos"; rec."No. Serie NCF Abonos")
                {
                }
                field("No. Serie NCF Abonos2"; rec."No. Serie NCF Abonos2")
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
                field("No. Comprobante Fiscal Rel."; rec."No. Comprobante Fiscal Rel.")
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
                        rec.SetRange("No.");
                        PAGE.RunModal(PAGE::"Posted Sales Credit Memo", Rec)
                    end;
                }
                field("Amount Including VAT"; rec."Amount Including VAT")
                {

                    trigger OnDrillDown()
                    begin
                        rec.SetRange("No.");
                        PAGE.RunModal(PAGE::"Posted Sales Credit Memo", Rec)
                    end;
                }
                field("Sell-to Post Code"; rec."Sell-to Post Code")
                {
                    Visible = false;
                }
                field("Sell-to Country/Region Code"; rec."Sell-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Sell-to Contact"; rec."Sell-to Contact")
                {
                    Visible = false;
                }
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {
                    Visible = false;
                }
                field("Bill-to Name"; rec."Bill-to Name")
                {
                    Visible = false;
                }
                field("Bill-to Post Code"; rec."Bill-to Post Code")
                {
                    Visible = false;
                }
                field("Bill-to Country/Region Code"; rec."Bill-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Bill-to Contact"; rec."Bill-to Contact")
                {
                    Visible = false;
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
            group("&Cr. Memo")
            {
                Caption = '&Cr. Memo';
                Image = CreditMemo;
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        PAGE.Run(PAGE::"Posted Sales Credit Memo", Rec)
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
                        if rec."Tax Area Code" = '' then
                            PAGE.RunModal(PAGE::"Sales Credit Memo Statistics", Rec, rec."No.");
                        // else
                        //     PAGE.RunModal(PAGE::"Sales Credit Memo Stats.", Rec, rec."No.");
                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = CONST("Posted Credit Memo"),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        rec.ShowDimensions;
                    end;
                }
            }
        }
        area(processing)
        {
            action("Liquidar contra Pagos TPV")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    rParam: Record "Param. CDU DsPOS";
                    SalesPost: Codeunit "Sales-Post";
                begin
                    //SalesPost.RegistrarCobrosTPVManual(Rec."No.");//001+-
                    ValidacionesdeErrores.RegistrarCobrosNotaCreditoTPVManual(Rec);
                    /*
                    rParam.INIT;
                    rParam.Accion    := rParam.Accion::LiquidarNotaCredito;
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
        rec.SetSecurityFilterOnRespCenter;
    end;

    var
        gtCAE: Text[160];
        gtCAEC: Text[160];
        gtRespuesta: Text[100];
        ValidacionesdeErrores: Codeunit "Validaciones de  Errores";
}

