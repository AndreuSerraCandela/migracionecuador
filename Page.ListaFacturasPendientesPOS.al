page 76293 "Lista Facturas Pendientes POS"
{
    ApplicationArea = all;
    //  Proyecto: Implementacion Business Central
    // 
    //  LDP: Luis Jose De La Cruz Paredes
    //  ------------------------------------------------------------------------
    //  No.        Fecha           Firma    Descripcion
    //  ------------------------------------------------------------------------
    //  001     25-05-2023       LDP      Integracion Ds-Pos: Se coloca boton para registro por lote.

    Caption = 'Sales Invoices';
    CardPageID = "Ficha Facturas Pdtes POS";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = SORTING("Posting Date", "Venta TPV", Tienda, "Registrado TPV")
                      ORDER(Ascending)
                      WHERE("Document Type" = FILTER(Order | Invoice),
                            "Venta TPV" = CONST(true),
                            "Registrado TPV" = CONST(true),
                            "No. Documento SIC" = CONST('<>'''));

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
                field("No. Fiscal TPV"; rec."No. Fiscal TPV")
                {
                }
                field("No."; rec."No.")
                {
                }
                field("Posting No."; rec."Posting No.")
                {
                }
                field("Sell-to Customer No."; rec."Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; rec."Sell-to Customer Name")
                {
                }
                field("External Document No."; rec."External Document No.")
                {
                }
                field("Sell-to Post Code"; rec."Sell-to Post Code")
                {
                    Visible = false;
                }
                field("Sell-to Country/Region Code"; rec."Sell-to Country/Region Code")
                {
                    Visible = false;
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
                field("Ship-to Code"; rec."Ship-to Code")
                {
                    Visible = false;
                }
                field("Ship-to Name"; rec."Ship-to Name")
                {
                    Visible = false;
                }
                field("Ship-to Post Code"; rec."Ship-to Post Code")
                {
                    Visible = false;
                }
                field("Ship-to Country/Region Code"; rec."Ship-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Ship-to Contact"; rec."Ship-to Contact")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Location Code"; rec."Location Code")
                {
                    Visible = true;
                }
                field("No. Documento SIC"; rec."No. Documento SIC")
                {
                }
                field("Error Registro"; rec."Error Registro")
                {
                }
                field(Amount; rec.Amount)
                {
                }
                field("Amount Including VAT"; rec."Amount Including VAT")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control1902018507; "Customer Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = true;
            }
            part(Control1900316107; "Customer Details FactBox")
            {
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = true;
            }
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
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        rec.CalcInvDiscForHeader;
                        Commit;
                        if rec."Tax Area Code" = '' then
                            PAGE.RunModal(PAGE::"Sales Statistics", Rec);
                        // else
                        //     PAGE.RunModal(PAGE::"Sales Order Stats.", Rec)
                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        rec.ShowDocDim;
                    end;
                }
                action("Convertir Pedidos DSPOS")
                {
                    ApplicationArea = Suite, Basic;
                    Image = Process;

                    trigger OnAction()
                    begin
                        Transfer_SIC.Run();//LDP-001+-//001
                    end;
                }
                action("Registrar Ventas en Lote DSPOS")
                {
                    ApplicationArea = Suite, Basic;
                    Image = Process;

                    trigger OnAction()
                    begin
                        //LDP-001+-
                        Registrar.RegistraFacturaManual();
                        //LDP-001+-
                    end;
                }
                action("Recalcular Importe Linea")
                {
                    Caption = 'Recalcular Importe Linea';
                    Image = Process;

                    trigger OnAction()
                    var
                        SalesLine: Record "Sales Line";
                        ImporteLinSIC: Decimal;
                        ImporteMPSIC: Decimal;
                        ImporteSalesLine: Decimal;
                        CabVentasSIC: Record "Cab. Ventas SIC";
                        LineasVentasSIC: Record "Lineas Ventas SIC";
                        MediosdePagoSIC: Record "Medios de Pago SIC";
                        SalesHeader: Record "Sales Header";
                    begin
                        Transfer_SIC.RecalclularImporteLineas;
                        /*
                        SalesHeader.RESET;
                        //001+
                        CLEAR(Transfer_SIC);
                        //IF (Rec."Venta TPV" = TRUE) AND (Rec."Error Registro" = 'Error entre el importe de las lineas y la cabecera') THEN
                        SalesHeader.SETRANGE("Venta TPV",TRUE);
                        SalesHeader.SETRANGE(SalesHeader."Document Type",SalesHeader."Document Type"::Invoice,SalesHeader."Document Type"::Order);
                        //SalesHeader.SETRANGE("No.",'NCY1-000010');
                        //Rec.SETRANGE("Error Registro",'Error entre el importe de las lineas y la cabecera');
                        IF SalesHeader.FINDSET THEN
                         BEGIN
                          REPEAT
                            SalesHeader.Status:= SalesHeader.Status::Open;
                            SalesHeader.MODIFY;
                        
                            CabVentasSIC.RESET;
                            LineasVentasSIC.RESET;
                            MediosdePagoSIC.RESET;
                            CLEAR(ImporteLinSIC);
                            CLEAR(ImporteMPSIC);
                        
                            ImporteLinSIC:=0;
                            ImporteMPSIC:=0;
                        
                            CabVentasSIC.SETRANGE("No. documento",SalesHeader."No.");
                            CabVentasSIC.SETRANGE("No. documento SIC",SalesHeader."No. Documento SIC");
                            IF CabVentasSIC.FINDFIRST THEN;
                        
                            LineasVentasSIC.SETRANGE("No. documento",SalesHeader."No.");
                            LineasVentasSIC.SETRANGE("No. documento SIC",SalesHeader."No. Documento SIC");
                            IF LineasVentasSIC.FINDSET THEN
                              REPEAT
                               ImporteLinSIC := LineasVentasSIC.Importe;
                              UNTIL LineasVentasSIC.NEXT = 0;
                        
                            MediosdePagoSIC.SETRANGE("No. documento",SalesHeader."No.");
                            MediosdePagoSIC.SETRANGE("No. documento SIC",SalesHeader."No. Documento SIC");
                            IF MediosdePagoSIC.FINDSET THEN
                              REPEAT
                               ImporteMPSIC := MediosdePagoSIC.Importe;
                              UNTIL MediosdePagoSIC.NEXT = 0;
                        
                            SalesLine.RESET();
                            SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
                            SalesLine.SETRANGE("Document No.",SalesHeader."No.");
                            SalesLine.CALCSUMS("Amount Including VAT");
                            IF SalesLine.FINDSET THEN
                              REPEAT
                                SalesLine.DELETE;
                              UNTIL SalesLine.NEXT = 0;
                            Transfer_SIC.RecalcularLineas(CabVentasSIC."No. documento",CabVentasSIC."Tipo documento",SalesHeader."Sell-to Customer No.",SalesHeader."No.",CabVentasSIC."Cod. Almacen",CabVentasSIC."No. documento SIC");
                            SalesHeader."Error Registro" := '';
                            SalesHeader.MODIFY;
                          UNTIL SalesHeader.NEXT = 0;
                          MESSAGE('Actualizacion de importe en línea satisfactoria');
                          SalesHeader.Status:= SalesHeader.Status::Released;
                          SalesHeader.MODIFY;
                         END ELSE
                          MESSAGE('No hay registros con errores de importe en línea');
                        
                        //SalesHeader.Status:= SalesHeader.Status::Released;
                        //SalesHeader.MODIFY;
                        //001-
                        */

                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        rec.SetSecurityFilterOnRespCenter;
        JobQueueActive := SalesSetup.JobQueueActive;
    end;

    var
        ReportPrint: Codeunit "Test Report-Print";
        JobQueueActive: Boolean;
        Transfer_SIC: Codeunit Transfer_SIC;
        Registrar: Codeunit "Registra Pedidos Vta. SIC_BC";
}

