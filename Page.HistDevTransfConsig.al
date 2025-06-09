#pragma implicitwith disable
page 56050 "Hist. Dev. Transf. (Consig.)"
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
                            "Devolucion Consignacion" = FILTER(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; rec."No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Transfer-from Code"; rec."Transfer-from Code")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Transfer-to Code"; rec."Transfer-to Code")
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
                field("In-Transit Code"; rec."In-Transit Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Transfer Order No."; rec."Transfer Order No.")
                {
                    Editable = false;
                    Importance = Promoted;
                    Lookup = false;
                    Visible = false;
                }
                field("Transfer Order Date"; rec."Transfer Order Date")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Posting Date"; rec."Posting Date")
                {
                    Editable = false;
                }
                field("Cod. Contacto"; rec."Cod. Contacto")
                {
                }
                field("Nombre Contacto"; rec."Nombre Contacto")
                {
                }
                field("Cod. Vendedor"; rec."Cod. Vendedor")
                {
                    Caption = 'Salesperson Code';
                }
                field("Importe Consignacion"; rec."Importe Consignacion")
                {
                    Caption = 'Consignment Amount';
                }
                field("Hora Finalizacion"; rec."Hora Finalizacion")
                {
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
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
                field("Transfer-from Name"; rec."Transfer-from Name")
                {
                    Editable = false;
                }
                field("Transfer-from Name 2"; rec."Transfer-from Name 2")
                {
                    Editable = false;
                }
                field("Transfer-from Address"; rec."Transfer-from Address")
                {
                    Editable = false;
                }
                field("Transfer-from Address 2"; rec."Transfer-from Address 2")
                {
                    Editable = false;
                }
                field("Transfer-from City"; rec."Transfer-from City")
                {
                    Editable = false;
                }
                field("Transfer-from County"; rec."Transfer-from County")
                {
                    Caption = 'Transfer-from State / ZIP Code';
                    Editable = false;
                }
                field("Transfer-from Post Code"; rec."Transfer-from Post Code")
                {
                    Editable = false;
                }
                field("Transfer-from Contact"; rec."Transfer-from Contact")
                {
                    Editable = false;
                }
                field("Shipment Date"; rec."Shipment Date")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Shipment Method Code"; rec."Shipment Method Code")
                {
                    Editable = false;
                }
                field("Shipping Agent Code"; rec."Shipping Agent Code")
                {
                    Editable = false;
                }
                field("Shipping Agent Service Code"; rec."Shipping Agent Service Code")
                {
                    Editable = false;
                    Importance = Promoted;
                }
            }
            group("Transfer-to")
            {
                Caption = 'Transfer-to';
                field("Transfer-to Name"; rec."Transfer-to Name")
                {
                    Editable = false;
                }
                field("Transfer-to Name 2"; rec."Transfer-to Name 2")
                {
                    Editable = false;
                }
                field("Transfer-to Address"; rec."Transfer-to Address")
                {
                    Editable = false;
                }
                field("Transfer-to Address 2"; rec."Transfer-to Address 2")
                {
                    Editable = false;
                }
                field("Transfer-to City"; rec."Transfer-to City")
                {
                    Editable = false;
                }
                field("Transfer-to County"; rec."Transfer-to County")
                {
                    Caption = 'Transfer-to State / ZIP Code';
                    Editable = false;
                }
                field("Transfer-to Post Code"; rec."Transfer-to Post Code")
                {
                    Editable = false;
                }
                field("Transfer-to Contact"; rec."Transfer-to Contact")
                {
                    Editable = false;
                }
                field("Receipt Date"; rec."Receipt Date")
                {
                    Editable = false;
                    Importance = Promoted;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Transaction Type"; rec."Transaction Type")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Transaction Specification"; rec."Transaction Specification")
                {
                    Editable = false;
                }
                field("Transport Method"; rec."Transport Method")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Area"; rec.Area)
                {
                    Editable = false;
                }
                field("Entry/Exit Point"; rec."Entry/Exit Point")
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

