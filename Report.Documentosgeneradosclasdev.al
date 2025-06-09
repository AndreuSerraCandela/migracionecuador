report 56037 "Documentos generados clas. dev"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Documentosgeneradosclasdev.rdlc';
    Caption = 'Documentos generados clasificación devoluciones';

    dataset
    {
        dataitem(PreDev; "Cab. clas. devolucion")
        {
            DataItemTableView = SORTING("No.") WHERE(Closed = CONST(true));
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column("Documentos_generados_por_clasificación_de_devolucionesCaption"; Documentos_generados_por_clasificación_de_devolucionesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(PreDev_No_; "No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                MarcarDocsClas;
            end;

            trigger OnPreDataItem()
            begin
                if blnEjecutadoAuto then begin
                    recTmpPreDev.Reset;
                    if recTmpPreDev.FindSet then
                        repeat
                            if Get(recTmpPreDev."No.") then
                                Mark(true);
                        until recTmpPreDev.Next = 0;
                    MarkedOnly(true);
                end;
            end;
        }
        dataitem(VentasClas; "Docs. clas. devoluciones")
        {
            DataItemTableView = SORTING("No. clas. devoluciones", "Tipo documento", "No. documento") WHERE("Tipo documento" = CONST(Venta));
            column(COMPANYNAME_Control1000000002; CompanyName)
            {
            }
            column(VentasClas__No__pre_devolucion_; "No. clas. devoluciones")
            {
            }
            column(Sales_Header__Amount_Including_VAT_Caption; Sales_Header__Amount_Including_VAT_CaptionLbl)
            {
            }
            column(Sales_Header_AmountCaption; Sales_Header_AmountCaptionLbl)
            {
            }
            column(Sales_Header__Location_Code_Caption; Sales_Header__Location_Code_CaptionLbl)
            {
            }
            column(Sales_Header__Posting_Date_Caption; Sales_Header__Posting_Date_CaptionLbl)
            {
            }
            column(Sales_Header__Bill_to_Name_Caption; Sales_Header__Bill_to_Name_CaptionLbl)
            {
            }
            column(Sales_Header__Sell_to_Customer_No__Caption; Sales_Header__Sell_to_Customer_No__CaptionLbl)
            {
            }
            column(Sales_Header__No__Caption; Sales_Header__No__CaptionLbl)
            {
            }
            column(VentasCaption; VentasCaptionLbl)
            {
            }
            column(Sales_ReturnsCaption; Sales_ReturnsCaptionLbl)
            {
            }
            column("Documentos_generados_por_clasificación_de_devolucionesCaption_Control1000000000"; Documentos_generados_por_clasificación_de_devolucionesCaption_Control1000000000Lbl)
            {
            }
            column(Control1000000003Caption; Control1000000003CaptionLbl)
            {
            }
            column("Pre_devolución_Caption"; Pre_devolución_CaptionLbl)
            {
            }
            column(VentasClas_Tipo_documento; "Tipo documento")
            {
            }
            column(VentasClas_No__documento; "No. documento")
            {
            }
            dataitem("Sales Header"; "Sales Header")
            {
                CalcFields = Amount, "Amount Including VAT";
                DataItemLink = "No." = FIELD("No. documento");
                DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST("Return Order"));
                column(Sales_Header__No__; "No.")
                {
                }
                column(Sales_Header__Sell_to_Customer_No__; "Sell-to Customer No.")
                {
                }
                column(Sales_Header__Bill_to_Name_; "Bill-to Name")
                {
                }
                column(Sales_Header__Posting_Date_; "Posting Date")
                {
                }
                column(Sales_Header__Location_Code_; "Location Code")
                {
                }
                column(Sales_Header_Amount; Amount)
                {
                }
                column(Sales_Header__Amount_Including_VAT_; "Amount Including VAT")
                {
                }
                column(Sales_Header_Document_Type; "Document Type")
                {
                }
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                    column(Sales_Line__No__; "No.")
                    {
                    }
                    column(Sales_Line_Description; Description)
                    {
                    }
                    column(Sales_Line__Unit_of_Measure_; "Unit of Measure")
                    {
                    }
                    column(Sales_Line_Quantity; Quantity)
                    {
                    }
                    column(Sales_Line__No__Caption; FieldCaption("No."))
                    {
                    }
                    column(Sales_Line_DescriptionCaption; FieldCaption(Description))
                    {
                    }
                    column(Sales_Line__Unit_of_Measure_Caption; Sales_Line__Unit_of_Measure_CaptionLbl)
                    {
                    }
                    column(Sales_Line_QuantityCaption; FieldCaption(Quantity))
                    {
                    }
                    column(Sales_Line_Document_Type; "Document Type")
                    {
                    }
                    column(Sales_Line_Document_No_; "Document No.")
                    {
                    }
                    column(Sales_Line_Line_No_; "Line No.")
                    {
                    }
                }
            }

            trigger OnPreDataItem()
            begin
                SetRange("Usuario imp.", UserId);
                SetRange("Fecha hora imp.", dtImpresion);
            end;
        }
        dataitem(TransferClas; "Docs. clas. devoluciones")
        {
            DataItemTableView = SORTING("No. clas. devoluciones", "Tipo documento", "No. documento") WHERE("Tipo documento" = CONST(Transferencia));
            column(COMPANYNAME_Control1000000005; CompanyName)
            {
            }
            column(TranferClas__No__pre_devolucion_; "No. clas. devoluciones")
            {
            }
            column(Transfer_Header__No__Caption; Transfer_Header__No__CaptionLbl)
            {
            }
            column(Transfer_ReturnsCaption; Transfer_ReturnsCaptionLbl)
            {
            }
            column(Transfer_Header__Posting_Date_Caption; Transfer_Header__Posting_Date_CaptionLbl)
            {
            }
            column(Transfer_Header__Transfer_from_Code_Caption; Transfer_Header__Transfer_from_Code_CaptionLbl)
            {
            }
            column(Transfer_Header__Transfer_from_Name_Caption; Transfer_Header__Transfer_from_Name_CaptionLbl)
            {
            }
            column(Transfer_Header__Transfer_from_Address_Caption; Transfer_Header__Transfer_from_Address_CaptionLbl)
            {
            }
            column(TransferenciasCaption; TransferenciasCaptionLbl)
            {
            }
            column(Transfer_Header__Transfer_to_Code_Caption; Transfer_Header__Transfer_to_Code_CaptionLbl)
            {
            }
            column(Control1000000004Caption; Control1000000004CaptionLbl)
            {
            }
            column("Documentos_generados_por_clasificación_de_devolucionesCaption_Control1000000033"; Documentos_generados_por_clasificación_de_devolucionesCaption_Control1000000033Lbl)
            {
            }
            column("Pre_devolución_Caption_Control1000000025"; Pre_devolución_Caption_Control1000000025Lbl)
            {
            }
            column(TransferClas_Tipo_documento; "Tipo documento")
            {
            }
            column(TransferClas_No__documento; "No. documento")
            {
            }
            dataitem("Transfer Header"; "Transfer Header")
            {
                DataItemLink = "No." = FIELD("No. documento");
                DataItemTableView = SORTING("No.");
                column(Transfer_Header__No__; "No.")
                {
                }
                column(Transfer_Header__Transfer_from_Code_; "Transfer-from Code")
                {
                }
                column(Transfer_Header__Transfer_from_Name_; "Transfer-from Name")
                {
                }
                column(Transfer_Header__Transfer_from_Address_; "Transfer-from Address")
                {
                }
                column(Transfer_Header__Transfer_to_Code_; "Transfer-to Code")
                {
                }
                column(Transfer_Header__Posting_Date_; "Posting Date")
                {
                }
                dataitem("Transfer Line"; "Transfer Line")
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document No.", "Line No.");
                    column(Transfer_Line__Item_No__; "Item No.")
                    {
                    }
                    column(Transfer_Line_Description; Description)
                    {
                    }
                    column(Transfer_Line__Unit_of_Measure_; "Unit of Measure")
                    {
                    }
                    column(Transfer_Line_Quantity; Quantity)
                    {
                    }
                    column(Transfer_Line__Item_No__Caption; FieldCaption("Item No."))
                    {
                    }
                    column(Transfer_Line_DescriptionCaption; FieldCaption(Description))
                    {
                    }
                    column(Transfer_Line__Unit_of_Measure_Caption; Transfer_Line__Unit_of_Measure_CaptionLbl)
                    {
                    }
                    column(Transfer_Line_QuantityCaption; FieldCaption(Quantity))
                    {
                    }
                    column(Transfer_Line_Document_No_; "Document No.")
                    {
                    }
                    column(Transfer_Line_Line_No_; "Line No.")
                    {
                    }
                }
            }

            trigger OnPreDataItem()
            begin
                SetRange("Usuario imp.", UserId);
                SetRange("Fecha hora imp.", dtImpresion);
            end;
        }
    }

    requestpage
    {
        SaveValues = false;

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        PreDev.Reset;
        dtImpresion := CurrentDateTime;
    end;

    var
        recDocClas: Record "Docs. clas. devoluciones";
        recTmpPreDev: Record "Cab. clas. devolucion" temporary;
        dlgProgreso: Dialog;
        dtImpresion: DateTime;
        blnEjecutadoAuto: Boolean;
        "Documentos_generados_por_clasificación_de_devolucionesCaptionLbl": Label 'Documentos generados por clasificación de devoluciones';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
        Sales_Header__Amount_Including_VAT_CaptionLbl: Label 'Amount Including Tax';
        Sales_Header_AmountCaptionLbl: Label 'Amount';
        Sales_Header__Location_Code_CaptionLbl: Label 'Location Code';
        Sales_Header__Posting_Date_CaptionLbl: Label 'Posting Date';
        Sales_Header__Bill_to_Name_CaptionLbl: Label 'Name';
        Sales_Header__Sell_to_Customer_No__CaptionLbl: Label 'Sell-to Customer No.';
        Sales_Header__No__CaptionLbl: Label 'No.';
        VentasCaptionLbl: Label 'Ventas';
        Sales_ReturnsCaptionLbl: Label 'Sales Returns';
        "Documentos_generados_por_clasificación_de_devolucionesCaption_Control1000000000Lbl": Label 'Documentos generados por clasificación de devoluciones';
        Control1000000003CaptionLbl: Label 'Pág.';
        "Pre_devolución_CaptionLbl": Label 'Clas. devolución:';
        Sales_Line__Unit_of_Measure_CaptionLbl: Label 'Unit of Measure';
        Transfer_Header__No__CaptionLbl: Label 'No.';
        Transfer_ReturnsCaptionLbl: Label 'Transfer Returns';
        Transfer_Header__Posting_Date_CaptionLbl: Label 'Posting Date';
        Transfer_Header__Transfer_from_Code_CaptionLbl: Label 'Transfer-from Name';
        Transfer_Header__Transfer_from_Name_CaptionLbl: Label 'Transfer-from Name';
        Transfer_Header__Transfer_from_Address_CaptionLbl: Label 'Transfer-from Address';
        TransferenciasCaptionLbl: Label 'Transferencias';
        Transfer_Header__Transfer_to_Code_CaptionLbl: Label 'Transfer-to Code';
        Control1000000004CaptionLbl: Label 'Pág.';
        "Documentos_generados_por_clasificación_de_devolucionesCaption_Control1000000033Lbl": Label 'Documentos generados por clasificación de devoluciones';
        "Pre_devolución_Caption_Control1000000025Lbl": Label 'Clas. devolución:';
        Transfer_Line__Unit_of_Measure_CaptionLbl: Label 'Unit of Measure';


    procedure MarcarDocsClas()
    begin
        recDocClas.Reset;
        recDocClas.SetRange("No. clas. devoluciones", PreDev."No.");
        if recDocClas.FindSet then
            repeat
                recDocClas."Usuario imp." := UserId;
                recDocClas."Fecha hora imp." := dtImpresion;
                recDocClas.Modify;
            until recDocClas.Next = 0;
    end;


    procedure PasarPreDev(var recPrmPreDev: Record "Cab. clas. devolucion" temporary)
    begin
        blnEjecutadoAuto := true;
        PreDev.Reset;

        recPrmPreDev.Reset;
        if recPrmPreDev.FindSet then
            repeat
                recTmpPreDev := recPrmPreDev;
                recTmpPreDev.Insert;
            until recPrmPreDev.Next = 0;
    end;
}

