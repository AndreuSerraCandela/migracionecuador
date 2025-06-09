#pragma implicitwith disable
page 56045 "Hist. Rece. Transf. (Consig.)"
{
    ApplicationArea = all;
    // Documentation()
    // Proyecto: Microsoft Dynamics Nav 2009
    // AMS     : Agustin Mendez
    // ------------------------------------------------------------------------
    // No.     Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // 001     19-Enero-09     AMS           Datos Cliente.

    Caption = 'Posted Transfer Receipt';
    Editable = false;
    InsertAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Transfer Receipt Header";
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE("Pedido Consignacion" = FILTER(true),
                            "Devolucion Consignacion" = FILTER(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("rCliente.Name"; rCliente.Name)
                {
                    Caption = 'Name';
                }
                field("rCliente.Address"; rCliente.Address)
                {
                    Caption = 'Address';
                }
                field("rCliente.City"; rCliente.City)
                {
                    Caption = 'City';
                }
                field("Cod. Contacto"; Rec."Cod. Contacto")
                {
                }
                field("Nombre Contacto"; Rec."Nombre Contacto")
                {
                    Editable = false;
                }
                field("In-Transit Code"; Rec."In-Transit Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Transfer Order No."; Rec."Transfer Order No.")
                {
                    Editable = false;
                    Importance = Promoted;
                    Lookup = false;
                    Visible = false;
                }
                field("Transfer Order Date"; Rec."Transfer Order Date")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Cod. Terminos de Pago"; Rec."Cod. Terminos de Pago")
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                }
                field("Fecha Vencimiento"; Rec."Fecha Vencimiento")
                {
                    Editable = false;
                }
                field("Cod. Vendedor"; Rec."Cod. Vendedor")
                {
                    Caption = 'Salesperson Code';
                }
                field("Importe Consignacion"; Rec."Importe Consignacion")
                {
                    Caption = 'Consignment Amount';
                }
                field("Hora Finalizacion"; Rec."Hora Finalizacion")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                }
                field("No. Comprobante Fiscal"; Rec."No. Comprobante Fiscal")
                {
                    Caption = 'Fiscal Document No.';
                    Editable = false;
                }
            }
            part(TransferReceiptLines; "Posted Transfer Rcpt. Subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group("Transfer-from")
            {
                Caption = 'Transfer-from';
                field("Transfer-from Name"; Rec."Transfer-from Name")
                {
                    Editable = false;
                }
                field("Transfer-from Name 2"; Rec."Transfer-from Name 2")
                {
                    Editable = false;
                }
                field("Transfer-from Address"; Rec."Transfer-from Address")
                {
                    Editable = false;
                }
                field("Transfer-from Address 2"; Rec."Transfer-from Address 2")
                {
                    Editable = false;
                }
                field("Transfer-from City"; Rec."Transfer-from City")
                {
                    Editable = false;
                }
                field("Transfer-from County"; Rec."Transfer-from County")
                {
                    Caption = 'Transfer-from State / ZIP Code';
                    Editable = false;
                }
                field("Transfer-from Post Code"; Rec."Transfer-from Post Code")
                {
                    Editable = false;
                }
                field("Transfer-from Contact"; Rec."Transfer-from Contact")
                {
                    Editable = false;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    Editable = false;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    Editable = false;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    Editable = false;
                    Importance = Promoted;
                }
            }
            group("Transfer-to")
            {
                Caption = 'Transfer-to';
                field("Transfer-to Name"; Rec."Transfer-to Name")
                {
                    Editable = false;
                }
                field("Transfer-to Name 2"; Rec."Transfer-to Name 2")
                {
                    Editable = false;
                }
                field("Transfer-to Address"; Rec."Transfer-to Address")
                {
                    Editable = false;
                }
                field("Transfer-to Address 2"; Rec."Transfer-to Address 2")
                {
                    Editable = false;
                }
                field("Transfer-to City"; Rec."Transfer-to City")
                {
                    Editable = false;
                }
                field("Transfer-to County"; Rec."Transfer-to County")
                {
                    Caption = 'Transfer-to State / ZIP Code';
                    Editable = false;
                }
                field("Transfer-to Post Code"; Rec."Transfer-to Post Code")
                {
                    Editable = false;
                }
                field("Transfer-to Contact"; Rec."Transfer-to Contact")
                {
                    Editable = false;
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                    Editable = false;
                    Importance = Promoted;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                    Editable = false;
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Area"; Rec."Area")
                {
                    Editable = false;
                }
                field("Entry/Exit Point"; Rec."Entry/Exit Point")
                {
                    Editable = false;
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
            group("&Receipt")
            {
                Caption = '&Receipt';
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Transfer Receipt Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Inventory Comment Sheet";
                    RunPageLink = "Document Type" = CONST("Posted Transfer Receipt"),
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
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TransRcptHeader: Record "Transfer Receipt Header";
                begin
                    CurrPage.SetSelectionFilter(TransRcptHeader);
                    TransRcptHeader.PrintRecords(true);
                end;
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //003
        if not rCliente.Get(Rec."Transfer-to Code") then
            Clear(rCliente);
    end;

    trigger OnOpenPage()
    begin
        Rec.CalcFields("Importe Consignacion");
    end;

    var
        "**003**": Integer;
        rCliente: Record Customer;
}

#pragma implicitwith restore

