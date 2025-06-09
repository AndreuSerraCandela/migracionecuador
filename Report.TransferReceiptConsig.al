report 51007 "Transfer Receipt (Consig)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './TransferReceiptConsig.rdlc';
    Caption = 'Transfer Receipt';

    dataset
    {
        dataitem("Transfer Receipt Header"; "Transfer Receipt Header")
        {
            DataItemTableView = SORTING ("No.");
            RequestFilterFields = "No.", "Transfer-from Code";
            RequestFilterHeading = 'Posted Transfer Receipt';
            column(Transfer_Receipt_Header_No_; "No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING (Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));
                    column(CompanyInfo_Picture; CompanyInfo.Picture)
                    {
                    }
                    column(CompanyInfo_Address______CompanyInfo__Address_2________CompanyInfo__Country_Region_Code_; CompanyInfo.Address + ',' + CompanyInfo."Address 2" + ' ' + CompanyInfo."Country/Region Code")
                    {
                    }
                    column(Conmutador___CompanyInfo__Phone_No_______Fax___CompanyInfo__Fax_No__; 'Conmutador ' + CompanyInfo."Phone No." + ', Fax ' + CompanyInfo."Fax No.")
                    {
                    }
                    column(rCliente__No_________rCliente_Name; rCliente."No." + ' - ' + rCliente.Name)
                    {
                    }
                    column(rCliente_Address; rCliente.Address)
                    {
                    }
                    column(rCliente__Address_2_; rCliente."Address 2")
                    {
                    }
                    column(rCliente_City; rCliente.City)
                    {
                    }
                    column(rCliente_Contact_____Tel___rCliente__Phone_No__; rCliente.Contact + ' Tel:' + rCliente."Phone No.")
                    {
                    }
                    column(rCliente__VAT_Registration_No__; rCliente."VAT Registration No.")
                    {
                    }
                    column(rContacto__Country_Region_Code__________Tel___rContacto__Phone_No__; rContacto."Country/Region Code" + ', ' + 'Tel:' + rContacto."Phone No.")
                    {
                    }
                    column(rCliente_Contact_____Tel___rCliente__Phone_No___Control1000000020; rCliente.Contact + ' Tel:' + rCliente."Phone No.")
                    {
                    }
                    column(rContacto__Address_2_; rContacto."Address 2")
                    {
                    }
                    column(rContacto_City; rContacto.City)
                    {
                    }
                    column(rContacto_Address; rContacto.Address)
                    {
                    }
                    column(rContacto_Name; rContacto.Name)
                    {
                    }
                    column(Transfer_Receipt_Header___No__; "Transfer Receipt Header"."No.")
                    {
                    }
                    column(Transfer_Receipt_Header___Posting_Date_; "Transfer Receipt Header"."Posting Date")
                    {
                    }
                    column(Transfer_Receipt_Header___Cod__Vendedor_; "Transfer Receipt Header"."Cod. Vendedor")
                    {
                    }
                    column(Transfer_Receipt_Header___Transfer_from_Code_; "Transfer Receipt Header"."Transfer-from Code")
                    {
                    }
                    column(FORMAT_WORKDATE_________FORMAT_TIME_; Format(WorkDate) + '  ' + Format(Time))
                    {
                    }
                    column(Transfer_Receipt_Header___External_Document_No__; "Transfer Receipt Header"."External Document No.")
                    {
                    }
                    column(Transfer_Receipt_Header___Transfer_Order_No__; "Transfer Receipt Header"."Transfer Order No.")
                    {
                    }
                    column(Cliente_Caption; Cliente_CaptionLbl)
                    {
                    }
                    column(NIT_Caption; NIT_CaptionLbl)
                    {
                    }
                    column(Domicilio_Caption; Domicilio_CaptionLbl)
                    {
                    }
                    column(Entregar_en_Caption; Entregar_en_CaptionLbl)
                    {
                    }
                    column(Ruta_de_Embarque_Caption; Ruta_de_Embarque_CaptionLbl)
                    {
                    }
                    column(NOTA_DE_REMISIONCaption; NOTA_DE_REMISIÓNCaptionLbl)
                    {
                    }
                    column(Pedido_Caption; Pedido_CaptionLbl)
                    {
                    }
                    column(Fecha_Pedido_Caption; Fecha_Pedido_CaptionLbl)
                    {
                    }
                    column(Fecha_Requerida_Caption; Fecha_Requerida_CaptionLbl)
                    {
                    }
                    column(Tipo_de_Pedido_Caption; Tipo_de_Pedido_CaptionLbl)
                    {
                    }
                    column(Termino_de_Pago_Caption; Termino_de_Pago_CaptionLbl)
                    {
                    }
                    column(Grupo_de_Venta_Caption; Grupo_de_Venta_CaptionLbl)
                    {
                    }
                    column(Vendedor_Caption; Vendedor_CaptionLbl)
                    {
                    }
                    column(Almacen_Caption; Almacén_CaptionLbl)
                    {
                    }
                    column(Orden_de_Compra_Caption; Orden_de_Compra_CaptionLbl)
                    {
                    }
                    column(Pedido_ConsignacionCaption; Pedido_ConsignaciónCaptionLbl)
                    {
                    }
                    column(Orden_de_Compra_Caption_Control1000000057; Orden_de_Compra_Caption_Control1000000057Lbl)
                    {
                    }
                    column(ESTOS_PRECIOS_NO_INCLUYEN_IVA_Caption; ESTOS_PRECIOS_NO_INCLUYEN_IVA_CaptionLbl)
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Transfer Receipt Header";
                        DataItemTableView = SORTING (Number) WHERE (Number = FILTER (1 ..));

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.FindSet then
                                    CurrReport.Break;
                            end else
                                if not Continue then
                                    CurrReport.Break;

                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo('%1 - %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        '%1; %2 - %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.Next = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                                CurrReport.Break;
                        end;
                    }
                    dataitem("Transfer Receipt Line"; "Transfer Receipt Line")
                    {
                        DataItemLink = "Document No." = FIELD ("No.");
                        DataItemLinkReference = "Transfer Receipt Header";
                        DataItemTableView = SORTING ("Document No.", "Line No.");
                        column(Transfer_Receipt_Line__Item_No__; "Item No.")
                        {
                        }
                        column(Transfer_Receipt_Line_Description; Description)
                        {
                        }
                        column(Transfer_Receipt_Line_Quantity; Quantity)
                        {
                        }
                        column(Transfer_Receipt_Line__Precio_Venta_Consignacion_; "Precio Venta Consignacion")
                        {
                        }
                        column(Transfer_Receipt_Line__Descuento___Consignacion_; "Descuento % Consignacion")
                        {
                        }
                        column(Transfer_Receipt_Line__Importe_Consignacion_; "Importe Consignacion")
                        {
                        }
                        column(Transfer_Receipt_Line_Quantity_Control1000000002; Quantity)
                        {
                        }
                        column(Transfer_Receipt_Line__Importe_Consignacion__Control1000000005; "Importe Consignacion")
                        {
                        }
                        column(Comentario_1_; Comentario[1])
                        {
                        }
                        column(Comentario_2_; Comentario[2])
                        {
                        }
                        column(Comentario_3_; Comentario[3])
                        {
                        }
                        column(Comentario_4_; Comentario[4])
                        {
                        }
                        column(Comentario_5_; Comentario[5])
                        {
                        }
                        column(Transfer_Receipt_Line__Importe_IVA_; "Importe IVA")
                        {
                        }
                        column(Importe_Consignacion___Importe_IVA_; "Importe Consignacion" + "Importe IVA")
                        {
                        }
                        column(CodigoCaption; CódigoCaptionLbl)
                        {
                        }
                        column(TituloCaption; TítuloCaptionLbl)
                        {
                        }
                        column(CantidadCaption; CantidadCaptionLbl)
                        {
                        }
                        column(P_V_P_Caption; P_V_P_CaptionLbl)
                        {
                        }
                        column(DescuentoCaption; DescuentoCaptionLbl)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }
                        column(Total_de_Ejemplares_Caption; Total_de_Ejemplares_CaptionLbl)
                        {
                        }
                        column(Observaciones_Caption; Observaciones_CaptionLbl)
                        {
                        }
                        column(Importe_Neto_Caption; Importe_Neto_CaptionLbl)
                        {
                        }
                        column(Importe_IVA_Caption; Importe_IVA_CaptionLbl)
                        {
                        }
                        column(Importe_IVA_Inc__Caption; Importe_IVA_Inc__CaptionLbl)
                        {
                        }
                        column(Transfer_Receipt_Line_Document_No_; "Document No.")
                        {
                        }
                        column(Transfer_Receipt_Line_Line_No_; "Line No.")
                        {
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = SORTING (Number) WHERE (Number = FILTER (1 ..));

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.FindSet then
                                        CurrReport.Break;
                                end else
                                    if not Continue then
                                        CurrReport.Break;

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 - %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1; %2 - %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                    CurrReport.Break;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            DimSetEntry2.SetRange("Dimension Set ID", "Dimension Set ID");
                        end;

                        trigger OnPreDataItem()
                        begin
                            //CurrReport.CreateTotals(Quantity, "Importe Consignacion", "Importe IVA");
                            MoreLines := Find('+');
                            while MoreLines and (Description = '') and ("Item No." = '') and (Quantity = 0) do
                                MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break;
                            SetRange("Line No.", 0, "Line No.");
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := Text000;
                        OutputNo += 1;
                    end;
                    //CurrReport.PageNo := 1;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := 1 + Abs(NoOfCopies);
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                FormatAddr.TransferRcptTransferFrom(TransferFromAddr, "Transfer Receipt Header");
                FormatAddr.TransferRcptTransferTo(TransferToAddr, "Transfer Receipt Header");

                if "Devolucion Consignacion" then
                    rCliente.Get("Transfer-from Code")
                else
                    rCliente.Get("Transfer-to Code");

                if rContacto.Get(CopyStr(rCliente.Contact, 1, 20)) then;


                rInvCommentLine.Reset;
                rInvCommentLine.SetRange("Document Type", 3);
                rInvCommentLine.SetRange("No.", "Transfer Receipt Header"."No.");
                if rInvCommentLine.FindSet then
                    repeat
                        I += 1;
                        Comentario[I] := rInvCommentLine.Comment;
                    until (rInvCommentLine.Next = 0) or (I = 5);
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                    ApplicationArea = All;
                        Caption = 'No. of Copies';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                    ApplicationArea = All;
                        Caption = 'Show Internal Information';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text000: Label 'COPY';
        Text001: Label 'Transfer Receipt %1';
        Text002: Label 'Page %1';
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        FormatAddr: Codeunit "Format Address";
        TransferFromAddr: array[8] of Text[50];
        TransferToAddr: array[8] of Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        OutputNo: Integer;
        CompanyInfo: Record "Company Information";
        rCliente: Record Customer;
        rContacto: Record Contact;
        rInvCommentLine: Record "Inventory Comment Line";
        Comentario: array[9] of Text[100];
        I: Integer;
        Cliente_CaptionLbl: Label 'Cliente:';
        NIT_CaptionLbl: Label 'NIT:';
        Domicilio_CaptionLbl: Label 'Domicilio:';
        Entregar_en_CaptionLbl: Label 'Entregar en:';
        Ruta_de_Embarque_CaptionLbl: Label 'Ruta de Embarque:';
        "NOTA_DE_REMISIÓNCaptionLbl": Label 'NOTA DE REMISION (Recepción)';
        Pedido_CaptionLbl: Label 'Pedido:';
        Fecha_Pedido_CaptionLbl: Label 'Fecha Pedido:';
        Fecha_Requerida_CaptionLbl: Label 'Fecha Requerida:';
        Tipo_de_Pedido_CaptionLbl: Label 'Tipo de Pedido:';
        Termino_de_Pago_CaptionLbl: Label 'Termino de Pago:';
        Grupo_de_Venta_CaptionLbl: Label 'Grupo de Venta:';
        Vendedor_CaptionLbl: Label 'Vendedor:';
        "Almacén_CaptionLbl": Label 'Almacén:';
        Orden_de_Compra_CaptionLbl: Label 'Orden de Compra:';
        "Pedido_ConsignaciónCaptionLbl": Label 'Pedido Consignación';
        Orden_de_Compra_Caption_Control1000000057Lbl: Label 'Orden de Compra:';
        ESTOS_PRECIOS_NO_INCLUYEN_IVA_CaptionLbl: Label '*ESTOS PRECIOS NO INCLUYEN IVA*';
        "CódigoCaptionLbl": Label 'Código';
        "TítuloCaptionLbl": Label 'Título';
        CantidadCaptionLbl: Label 'Cantidad';
        P_V_P_CaptionLbl: Label 'P.V.P.';
        DescuentoCaptionLbl: Label '% Descuento';
        TotalCaptionLbl: Label 'Total';
        Total_de_Ejemplares_CaptionLbl: Label 'Total de Ejemplares:';
        Observaciones_CaptionLbl: Label 'Observaciones:';
        Importe_Neto_CaptionLbl: Label 'Importe Neto:';
        Importe_IVA_CaptionLbl: Label 'Importe IVA:';
        Importe_IVA_Inc__CaptionLbl: Label 'Importe IVA Inc.:';
}

