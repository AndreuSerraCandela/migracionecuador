page 76302 "Lista Notas Credito Pdtes POS"
{
    ApplicationArea = all;
    Caption = 'Sales Credit Memos';
    CardPageID = "Ficha Notas Crédito Pdtes POS";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = SORTING("Posting Date", "Venta TPV", Tienda, "Registrado TPV")
                      ORDER(Ascending)
                      WHERE("Document Type" = CONST("Credit Memo"),
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
                    Editable = ESACC_F20_Editable;
                    HideValue = ESACC_F20_HideValue;
                    Visible = true;
                }
                field(Tienda; rec.Tienda)
                {
                    Editable = ESACC_F34002504_Editable;
                    HideValue = ESACC_F34002504_HideValue;
                    Visible = true;
                }
                field(TPV; rec.TPV)
                {
                    Editable = ESACC_F34002503_Editable;
                    HideValue = ESACC_F34002503_HideValue;
                    Visible = ESACC_F34002503_Visible;
                }
                field("ID Cajero"; rec."ID Cajero")
                {
                    Editable = ESACC_F34002500_Editable;
                    HideValue = ESACC_F34002500_HideValue;
                    Visible = true;
                }
                field(Turno; rec.Turno)
                {
                    Editable = ESACC_F34002512_Editable;
                    HideValue = ESACC_F34002512_HideValue;
                    Visible = ESACC_F34002512_Visible;
                }
                field("Hora creacion"; rec."Hora creacion")
                {
                    Editable = ESACC_F34002501_Editable;
                    HideValue = ESACC_F34002501_HideValue;
                    Visible = ESACC_F34002501_Visible;
                }
                field("No. Fiscal TPV"; rec."No. Fiscal TPV")
                {
                    Editable = ESACC_F34002511_Editable;
                    HideValue = ESACC_F34002511_HideValue;
                    Visible = true;
                }
                field("No."; rec."No.")
                {
                    Editable = ESACC_F3_Editable;
                    HideValue = ESACC_F3_HideValue;
                    Visible = true;
                }
                field("Sell-to Customer No."; rec."Sell-to Customer No.")
                {
                    Editable = ESACC_F2_Editable;
                    HideValue = ESACC_F2_HideValue;
                    Visible = ESACC_F2_Visible;
                }
                field("Sell-to Customer Name"; rec."Sell-to Customer Name")
                {
                    Editable = ESACC_F79_Editable;
                    HideValue = ESACC_F79_HideValue;
                    Visible = ESACC_F79_Visible;
                }
                field("External Document No."; rec."External Document No.")
                {
                    Editable = ESACC_F100_Editable;
                    HideValue = ESACC_F100_HideValue;
                    Visible = ESACC_F100_Visible;
                }
                field("Sell-to Post Code"; rec."Sell-to Post Code")
                {
                    Editable = ESACC_F88_Editable;
                    HideValue = ESACC_F88_HideValue;
                    Visible = false;
                }
                field("Sell-to Country/Region Code"; rec."Sell-to Country/Region Code")
                {
                    Editable = ESACC_F90_Editable;
                    HideValue = ESACC_F90_HideValue;
                    Visible = false;
                }
                field("Sell-to Contact"; rec."Sell-to Contact")
                {
                    Editable = ESACC_F84_Editable;
                    HideValue = ESACC_F84_HideValue;
                    Visible = false;
                }
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {
                    Editable = ESACC_F4_Editable;
                    HideValue = ESACC_F4_HideValue;
                    Visible = false;
                }
                field("Bill-to Name"; rec."Bill-to Name")
                {
                    Editable = ESACC_F5_Editable;
                    HideValue = ESACC_F5_HideValue;
                    Visible = false;
                }
                field("Bill-to Post Code"; rec."Bill-to Post Code")
                {
                    Editable = ESACC_F85_Editable;
                    HideValue = ESACC_F85_HideValue;
                    Visible = false;
                }
                field("Bill-to Country/Region Code"; rec."Bill-to Country/Region Code")
                {
                    Editable = ESACC_F87_Editable;
                    HideValue = ESACC_F87_HideValue;
                    Visible = false;
                }
                field("Bill-to Contact"; rec."Bill-to Contact")
                {
                    Editable = ESACC_F10_Editable;
                    HideValue = ESACC_F10_HideValue;
                    Visible = false;
                }
                field("Ship-to Code"; rec."Ship-to Code")
                {
                    Editable = ESACC_F12_Editable;
                    HideValue = ESACC_F12_HideValue;
                    Visible = false;
                }
                field("Ship-to Name"; rec."Ship-to Name")
                {
                    Editable = ESACC_F13_Editable;
                    HideValue = ESACC_F13_HideValue;
                    Visible = false;
                }
                field("Ship-to Post Code"; rec."Ship-to Post Code")
                {
                    Editable = ESACC_F91_Editable;
                    HideValue = ESACC_F91_HideValue;
                    Visible = false;
                }
                field("Ship-to Country/Region Code"; rec."Ship-to Country/Region Code")
                {
                    Editable = ESACC_F93_Editable;
                    HideValue = ESACC_F93_HideValue;
                    Visible = false;
                }
                field("Ship-to Contact"; rec."Ship-to Contact")
                {
                    Editable = ESACC_F18_Editable;
                    HideValue = ESACC_F18_HideValue;
                    Visible = false;
                }
                field("Location Code"; rec."Location Code")
                {
                    Editable = ESACC_F28_Editable;
                    HideValue = ESACC_F28_HideValue;
                    Visible = true;
                }
                field("Salesperson Code"; rec."Salesperson Code")
                {
                    Editable = ESACC_F43_Editable;
                    HideValue = ESACC_F43_HideValue;
                    Visible = false;
                }
                field("Posting No."; rec."Posting No.")
                {
                }
                field("No. Documento SIC"; rec."No. Documento SIC")
                {
                    Editable = false;
                }
                field("Establecimiento Factura"; rec."Establecimiento Factura")
                {
                }
                field("Punto de Emision Factura"; rec."Punto de Emision Factura")
                {
                }
                field("Establecimiento Fact. Rel"; rec."Establecimiento Fact. Rel")
                {
                }
                field("Punto de Emision Fact. Rel."; rec."Punto de Emision Fact. Rel.")
                {
                }
                field("Error Registro"; rec."Error Registro")
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
            group("&Cr. Memo")
            {
                Caption = '&Cr. Memo';
                Image = CreditMemo;
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Enabled = ESACC_C1102601021_Enabled;
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';
                    Visible = ESACC_C1102601021_Visible;

                    trigger OnAction()
                    begin
                        rec.CalcInvDiscForHeader;
                        Commit;
                        if rec."Tax Area Code" = '' then
                            PAGE.RunModal(PAGE::"Sales Statistics", rec);
                        // else
                        //     PAGE.RunModal(PAGE::"Sales Order Stats.", rec)
                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Enabled = ESACC_C1102601023_Enabled;
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                    Visible = ESACC_C1102601023_Visible;
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Enabled = ESACC_C1102601024_Enabled;
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    Visible = ESACC_C1102601024_Visible;

                    trigger OnAction()
                    begin
                        rec.ShowDocDim;
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Enabled = ESACC_C1102601025_Enabled;
                    Image = Approvals;
                    Visible = ESACC_C1102601025_Visible;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.Setfilters(DATABASE::"Sales Header", rec."Document Type", rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
            }
        }
        area(processing)
        {
            group(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Enabled = ESACC_C1102601017_Enabled;
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    Visible = ESACC_C1102601017_Visible;

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Enabled = ESACC_C1102601018_Enabled;
                    Image = ReOpen;
                    Visible = ESACC_C1102601018_Visible;

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Send A&pproval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = ESACC_C1102601014_Enabled;
                    Image = SendApprovalRequest;
                    Visible = ESACC_C1102601014_Visible;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        //IF ApprovalMgt.SendSalesApprovalRequest(Rec) THEN; //MIGEC
                        if ApprovalMgt.CheckSalesApprovalPossible(Rec) then
                            ApprovalMgt.OnSendSalesDocForApproval(Rec);
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = ESACC_C1102601015_Enabled;
                    Image = Cancel;
                    Visible = ESACC_C1102601015_Visible;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                    begin
                        //IF ApprovalMgt.CancelSalesApprovalRequest(Rec,TRUE,TRUE) THEN; //MIGEC
                        ApprovalMgt.OnCancelSalesApprovalRequest(Rec);
                        WorkflowWebhookMgt.FindAndCancel(rec.RecordId);
                    end;
                }
                separator(Action1102601016)
                {
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Enabled = ESACC_C51_Enabled;
                    Image = TestReport;
                    Visible = ESACC_C51_Visible;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintSalesHeader(Rec);
                    end;
                }
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Enabled = ESACC_C52_Enabled;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    Visible = ESACC_C52_Visible;

                    trigger OnAction()
                    begin
                        rec.SendToPosting(CODEUNIT::"Sales-Post (Yes/No)");
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Enabled = ESACC_C53_Enabled;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    Visible = ESACC_C53_Visible;

                    trigger OnAction()
                    begin
                        rec.SendToPosting(CODEUNIT::"Sales-Post + Print");
                    end;
                }
                action("Post &Batch")
                {
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Enabled = ESACC_C54_Enabled;
                    Image = PostBatch;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    Visible = ESACC_C54_Visible;

                    trigger OnAction()
                    begin
                        REPORT.RunModal(REPORT::"Batch Post Sales Credit Memos", true, true, Rec);
                        CurrPage.Update(false);
                    end;
                }
                action("Remove From Job Queue")
                {
                    Caption = 'Remove From Job Queue';
                    Enabled = ESACC_C3_Enabled;
                    Image = RemoveLine;
                    Visible = JobQueueActive;

                    trigger OnAction()
                    begin
                        rec.CancelBackgroundPosting;
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
                        SalesHeader.SETRANGE(SalesHeader."Document Type",SalesHeader."Document Type"::"Credit Memo");
                        //SalesHeader.SETRANGE("No.",'NCY1-000038');
                        //Rec.SETRANGE("Error Registro",'Error entre el importe de las lineas y la cabecera');
                        IF SalesHeader.FINDSET THEN
                         BEGIN
                          REPEAT
                            SalesHeader.Status := SalesHeader.Status::Open;
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


        ESACC_C3_Visible: Boolean;

        ESACC_C3_Enabled: Boolean;

        ESACC_C51_Visible: Boolean;

        ESACC_C51_Enabled: Boolean;

        ESACC_C52_Visible: Boolean;

        ESACC_C52_Enabled: Boolean;

        ESACC_C53_Visible: Boolean;

        ESACC_C53_Enabled: Boolean;

        ESACC_C54_Visible: Boolean;

        ESACC_C54_Enabled: Boolean;

        ESACC_C1102601014_Visible: Boolean;

        ESACC_C1102601014_Enabled: Boolean;

        ESACC_C1102601015_Visible: Boolean;

        ESACC_C1102601015_Enabled: Boolean;

        ESACC_C1102601017_Visible: Boolean;

        ESACC_C1102601017_Enabled: Boolean;

        ESACC_C1102601018_Visible: Boolean;

        ESACC_C1102601018_Enabled: Boolean;

        ESACC_C1102601021_Visible: Boolean;

        ESACC_C1102601021_Enabled: Boolean;

        ESACC_C1102601023_Visible: Boolean;

        ESACC_C1102601023_Enabled: Boolean;

        ESACC_C1102601024_Visible: Boolean;

        ESACC_C1102601024_Enabled: Boolean;

        ESACC_C1102601025_Visible: Boolean;

        ESACC_C1102601025_Enabled: Boolean;

        ESACC_F2_Visible: Boolean;

        ESACC_F2_Editable: Boolean;

        ESACC_F2_HideValue: Boolean;

        ESACC_F3_Visible: Boolean;

        ESACC_F3_Editable: Boolean;

        ESACC_F3_HideValue: Boolean;

        ESACC_F4_Visible: Boolean;

        ESACC_F4_Editable: Boolean;

        ESACC_F4_HideValue: Boolean;

        ESACC_F5_Visible: Boolean;

        ESACC_F5_Editable: Boolean;

        ESACC_F5_HideValue: Boolean;

        ESACC_F10_Visible: Boolean;

        ESACC_F10_Editable: Boolean;

        ESACC_F10_HideValue: Boolean;

        ESACC_F12_Visible: Boolean;

        ESACC_F12_Editable: Boolean;

        ESACC_F12_HideValue: Boolean;

        ESACC_F13_Visible: Boolean;

        ESACC_F13_Editable: Boolean;

        ESACC_F13_HideValue: Boolean;

        ESACC_F18_Visible: Boolean;

        ESACC_F18_Editable: Boolean;

        ESACC_F18_HideValue: Boolean;

        ESACC_F20_Visible: Boolean;

        ESACC_F20_Editable: Boolean;

        ESACC_F20_HideValue: Boolean;

        ESACC_F28_Visible: Boolean;

        ESACC_F28_Editable: Boolean;

        ESACC_F28_HideValue: Boolean;

        ESACC_F43_Visible: Boolean;

        ESACC_F43_Editable: Boolean;

        ESACC_F43_HideValue: Boolean;

        ESACC_F79_Visible: Boolean;

        ESACC_F79_Editable: Boolean;

        ESACC_F79_HideValue: Boolean;

        ESACC_F84_Visible: Boolean;

        ESACC_F84_Editable: Boolean;

        ESACC_F84_HideValue: Boolean;

        ESACC_F85_Visible: Boolean;

        ESACC_F85_Editable: Boolean;

        ESACC_F85_HideValue: Boolean;

        ESACC_F87_Visible: Boolean;

        ESACC_F87_Editable: Boolean;

        ESACC_F87_HideValue: Boolean;

        ESACC_F88_Visible: Boolean;

        ESACC_F88_Editable: Boolean;

        ESACC_F88_HideValue: Boolean;

        ESACC_F90_Visible: Boolean;

        ESACC_F90_Editable: Boolean;

        ESACC_F90_HideValue: Boolean;

        ESACC_F91_Visible: Boolean;

        ESACC_F91_Editable: Boolean;

        ESACC_F91_HideValue: Boolean;

        ESACC_F93_Visible: Boolean;

        ESACC_F93_Editable: Boolean;

        ESACC_F93_HideValue: Boolean;

        ESACC_F100_Visible: Boolean;

        ESACC_F100_Editable: Boolean;

        ESACC_F100_HideValue: Boolean;

        ESACC_F34002500_Visible: Boolean;

        ESACC_F34002500_Editable: Boolean;

        ESACC_F34002500_HideValue: Boolean;

        ESACC_F34002501_Visible: Boolean;

        ESACC_F34002501_Editable: Boolean;

        ESACC_F34002501_HideValue: Boolean;

        ESACC_F34002503_Visible: Boolean;

        ESACC_F34002503_Editable: Boolean;

        ESACC_F34002503_HideValue: Boolean;

        ESACC_F34002504_Visible: Boolean;

        ESACC_F34002504_Editable: Boolean;

        ESACC_F34002504_HideValue: Boolean;

        ESACC_F34002511_Visible: Boolean;

        ESACC_F34002511_Editable: Boolean;

        ESACC_F34002511_HideValue: Boolean;

        ESACC_F34002512_Visible: Boolean;

        ESACC_F34002512_Editable: Boolean;

        ESACC_F34002512_HideValue: Boolean;
        ReportPrint: Codeunit "Test Report-Print";

        JobQueueActive: Boolean;
        Transfer_SIC: Codeunit Transfer_SIC;
        Registrar: Codeunit "Registra Pedidos Vta. SIC_BC";
}

