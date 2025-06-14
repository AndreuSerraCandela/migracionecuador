report 50008 "Customer/Item Stat. Dev 2.0"
{
    // #866  20/12/2013  PLB      Se eliminan las columnas Unidad de medida, Margen contribución y Ratio contrib. Se añaden las columnas
    //                            PVP, Subtotal y Descuento %
    // 
    // MOI - 18/12/2014 (#8151): 1 Se permutan las columnas Importe y Subtotal
    //                           2 Se corrige el fallo de que el Total del Subtotal no reflejaba de manera correcta dicha suma.
    // MOI - 19/12/2014 (#8151): Se añade mensaje de error en el caso de que no existan registros para mostrar.
    // #28367  13/08/2015  MOI   Se modifica a nivel de layout el calculo del porcentaje.
    // 
    // 001    01/11/2024   LDP   SANTINAV-6811
    DefaultLayout = RDLC;
    RDLCLayout = './CustomerItemStatDev20.rdlc';

    ApplicationArea = Basic, Suite;
    Caption = 'Customer/Item Stat. Devolucion HN';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Customer Posting Group";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(TIME; Time)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Customer_TABLECAPTION___________FilterString; Customer.TableCaption + ':  ' + FilterString)
            {
            }
            column(Value_Entry__TABLECAPTION___________FilterString2; "Value Entry".TableCaption + ':  ' + FilterString2)
            {
            }
            column(groupno; groupno)
            {
            }
            column(PrintToExcel; PrintToExcel)
            {
            }
            column(FilterString; FilterString)
            {
            }
            column(FilterString2; FilterString2)
            {
            }
            column(OnlyOnePerPage; OnlyOnePerPage)
            {
            }
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(Customer__Phone_No__; "Phone No.")
            {
            }
            column(Customer_Contact; Contact)
            {
            }
            column(Value_Entry___Sales_Amount__Actual__; "Value Entry"."Sales Amount (Actual)")
            {
            }
            column(Profit; Profit)
            {
            }
            column(Value_Entry___Discount_Amount_; "Value Entry"."Discount Amount")
            {
            }
            column(Profit__; "Profit%")
            {
                DecimalPlaces = 1 : 1;
            }
            column(Customer_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Customer_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(Customer_Item_StatisticsCaption; Customer_Item_StatisticsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer_NoCaption; Customer_NoCaptionLbl)
            {
            }
            column(Customer_NameCaption; FieldCaption(Name))
            {
            }
            column(Value_Entry__Item_No__Caption; "Value Entry".FieldCaption("Item No."))
            {
            }
            column(Item_DescriptionCaption; Item_DescriptionCaptionLbl)
            {
            }
            column(Invoiced_Quantity_Caption; Invoiced_Quantity_CaptionLbl)
            {
            }
            column(Value_Entry__Sales_Amount__Actual__Caption; Value_Entry__Sales_Amount__Actual__CaptionLbl)
            {
            }
            column(Profit_Control38Caption; Profit_Control38CaptionLbl)
            {
            }
            column(Value_Entry__Discount_Amount_Caption; Value_Entry__Discount_Amount_CaptionLbl)
            {
            }
            column(Profit___Control40Caption; Profit___Control40CaptionLbl)
            {
            }
            column(Item__Base_Unit_of_Measure_Caption; Item__Base_Unit_of_Measure_CaptionLbl)
            {
            }
            column(Phone_Caption; Phone_CaptionLbl)
            {
            }
            column(Contact_Caption; Contact_CaptionLbl)
            {
            }
            column(Report_TotalCaption; Report_TotalCaptionLbl)
            {
            }
            column(Dev_Titule; Dev_Titule)
            {
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Source No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Source Type", "Source No.", "Item Ledger Entry Type", "Item No.", "Posting Date") WHERE("Source Type" = CONST(Customer), "Item Ledger Entry Type" = CONST(Sale), "Expected Cost" = CONST(false));
                RequestFilterFields = "Item No.", "Inventory Posting Group", "Posting Date";
                column(Value_Entry__Item_No__; "Item No.")
                {
                }
                column(Item_Description; Item.Description)
                {
                }
                column(Invoiced_Quantity_; -"Invoiced Quantity")
                {
                }
                column(Item__Base_Unit_of_Measure_; Item."Base Unit of Measure")
                {
                }
                column(Profit_Control38; Profit)
                {
                }
                column(Value_Entry__Discount_Amount_; "Discount Amount")
                {
                }
                column(Profit___Control40; "Profit%")
                {
                    DecimalPlaces = 1 : 1;
                }
                column(Value_Entry__Sales_Amount__Actual__; "Sales Amount (Actual)")
                {
                }
                column(Customer__No___Control41; Customer."No.")
                {
                }
                column(Value_Entry__Sales_Amount__Actual___Control42; "Sales Amount (Actual)")
                {
                }
                column(Profit_Control43; Profit)
                {
                }
                column(Value_Entry__Discount_Amount__Control44; "Discount Amount")
                {
                }
                column(Profit___Control45; "Profit%")
                {
                    DecimalPlaces = 1 : 1;
                }
                column(Value_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Value_Entry_Source_No_; "Source No.")
                {
                }
                column(Value_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(Value_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
                {
                }
                column(Customer_TotalCaption; Customer_TotalCaptionLbl)
                {
                }
                column(PVP; "Precio Unitario Consignacion")
                {
                }
                column(Descuento; "Descuento % Consignacion")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //MOI - 19/12/2014 (#8151):Inicio
                    gbHayRegistro := true;
                    //MOI - 19/12/2014 (#8151):Fin

                    //001+
                    if "Value Entry"."Invoiced Quantity" = 0 then begin
                        CurrReport.Skip
                    end;
                    //001-

                    if ValueEntryTotalForItem."Item No." <> "Item No." then begin
                        "CalculateProfit%";
                        if PrintToExcel and (ValueEntryTotalForItem."Item No." <> '') then
                            MakeExcelDataBody;
                        Clear(ValueEntryTotalForItem);
                        ProfitTotalForItem := 0;
                        if not Item.Get("Item No.") then begin
                            Item.Description := Text000;
                            Item."Base Unit of Measure" := '';
                        end;
                    end;
                    //MOI - 18/12/2014 (#8151): Inicio 2
                    //Profit := "Sales Amount (Actual)" + "Cost Amount (Actual)";
                    Profit := (("Value Entry"."Precio Unitario Consignacion") * (-"Value Entry"."Invoiced Quantity"));
                    //MOI - 18/12/2014 (#8151): Fin 2

                    "Discount Amount" := -"Discount Amount";

                    ValueEntryTotalForItem."Item No." := "Item No.";
                    ValueEntryTotalForItem."Invoiced Quantity" += "Invoiced Quantity";
                    ValueEntryTotalForItem."Sales Amount (Actual)" += "Sales Amount (Actual)";
                    ValueEntryTotalForItem."Discount Amount" += "Discount Amount";
                    ProfitTotalForItem += Profit;
                end;

                trigger OnPostDataItem()
                begin
                    if PrintToExcel and (ValueEntryTotalForItem."Item No." <> '') then begin
                        "CalculateProfit%";
                        MakeExcelDataBody;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    //001+
                    if "Value Entry"."Invoiced Quantity" = 0 then begin
                        CurrReport.Skip
                    end;
                    //001-
                    //CurrReport.CreateTotals("Invoiced Quantity", "Sales Amount (Actual)", Profit, "Discount Amount");
                    Clear(ValueEntryTotalForItem);
                    ProfitTotalForItem := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if OnlyOnePerPage then
                    groupno := groupno + 1
            end;

            trigger OnPostDataItem()
            var
                Error001: Label 'No hay datos disponibles con el filtro establecido. Amplie o elimine el filtro.';
            begin
                //MOI - 19/12/2014 (#8151):Inicio
                if not gbHayRegistro then
                    Error(Error001);
                //MOI - 19/12/2014 (#8151):Fin
            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.NewPagePerRecord := OnlyOnePerPage;

                //CurrReport.CreateTotals("Value Entry"."Sales Amount (Actual)", Profit, "Value Entry"."Discount Amount");
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
                    field(OnlyOnePerPage; OnlyOnePerPage)
                    {
                        ApplicationArea = All;
                        Caption = 'New Page per Account';
                    }
                    field(PrintToExcel; PrintToExcel)
                    {
                        ApplicationArea = All;
                        Caption = 'Print To Excel';
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

    trigger OnPostReport()
    begin
        if PrintToExcel then
            CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        //MOI - 19/12/2014 (#8151):Inicio
        Clear(gbHayRegistro);
        //MOI - 19/12/2014 (#8151):Fin
        PeriodText := "Value Entry".GetFilter("Posting Date");
        CompanyInformation.Get;
        FilterString := Customer.GetFilters;
        //"Value Entry".SETFILTER("Invoiced Quantity",'<>%1',0);//LDP+-
        FilterString2 := "Value Entry".GetFilters;
        if PrintToExcel then
            MakeExcelInfo;
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        FilterString: Text[250];
        FilterString2: Text[250];
        PeriodText: Text[30];
        Profit: Decimal;
        "Profit%": Decimal;
        OnlyOnePerPage: Boolean;
        Item: Record Item;
        CompanyInformation: Record "Company Information";
        PrintToExcel: Boolean;
        Text000: Label 'Invalid Item';
        Text001: Label 'Data';
        Text002: Label 'Customer/Item Statistics';
        Text003: Label 'Company Name';
        Text004: Label 'Report No.';
        Text005: Label 'Report Name';
        Text006: Label 'User ID';
        Text007: Label 'Date / Time';
        Text008: Label 'Customer Filters';
        Text009: Label 'Value Entry Filters';
        Text010: Label 'Contribution Margin';
        Text011: Label 'Contribution Ratio';
        groupno: Integer;
        ValueEntryTotalForItem: Record "Value Entry";
        ProfitTotalForItem: Decimal;
        Customer_Item_StatisticsCaptionLbl: Label 'Customer/Item Statistics';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Customer_NoCaptionLbl: Label 'Customer No';
        Item_DescriptionCaptionLbl: Label 'Item Description';
        Invoiced_Quantity_CaptionLbl: Label 'Quantity';
        Value_Entry__Sales_Amount__Actual__CaptionLbl: Label 'Amount';
        Profit_Control38CaptionLbl: Label 'Contribution Margin';
        Value_Entry__Discount_Amount_CaptionLbl: Label 'Discount';
        Profit___Control40CaptionLbl: Label 'Contrib Ratio';
        Item__Base_Unit_of_Measure_CaptionLbl: Label 'Unit';
        Phone_CaptionLbl: Label 'Phone:';
        Contact_CaptionLbl: Label 'Contact:';
        Report_TotalCaptionLbl: Label 'Report Total';
        Customer_TotalCaptionLbl: Label 'Customer Total';
        Text50000: Label 'PVP';
        Text50001: Label 'Subtotal';
        Text50002: Label 'Descuento %';
        gbHayRegistro: Boolean;
        Dev_Titule: Label 'DEVOLUCiÓN';


    procedure "CalculateProfit%"()
    begin
        if ValueEntryTotalForItem."Sales Amount (Actual)" <> 0 then
            "Profit%" := Round(100 * ProfitTotalForItem / ValueEntryTotalForItem."Sales Amount (Actual)", 0.1)
        else
            "Profit%" := 0;
    end;

    local procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(Format(Text003), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(CompanyInformation.Name, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text005), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(Format(Text002), false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text004), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddInfoColumn(REPORT::"Customer/Item Statistics", false, false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text006), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(UserId, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text007), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(Today, false, false, false, false, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddInfoColumn(Time, false, false, false, false, '', ExcelBuf."Cell Type"::Time);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text008), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(FilterString, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text009), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(FilterString2, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Customer.FieldCaption("No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.FieldCaption(Name), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Value Entry".FieldCaption("Item No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption(Description), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Value Entry".FieldCaption("Invoiced Quantity"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Base Unit of Measure"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        //+#866
        //ExcelBuf.AddColumn(Item.FIELDCAPTION("Base Unit of Measure"),FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(StrSubstNo('%1', Text50000), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(StrSubstNo('%1', Text50001), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(StrSubstNo('%1', Text50002), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        //-#866
        ExcelBuf.AddColumn("Value Entry".FieldCaption("Sales Amount (Actual)"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        //+#866
        //ExcelBuf.AddColumn(FORMAT(Text010),FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(FORMAT(Text011),FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        //-#866
        ExcelBuf.AddColumn("Value Entry".FieldCaption("Discount Amount"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeExcelDataBody()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Customer."No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ValueEntryTotalForItem."Item No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item.Description, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(-ValueEntryTotalForItem."Invoiced Quantity", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(Item."Base Unit of Measure",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//-#866
        ExcelBuf.AddColumn("Value Entry"."Precio Unitario Consignacion", false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number); //+#866

        //+#866
        ExcelBuf.AddColumn(ValueEntryTotalForItem."Sales Amount (Actual)" +
          ValueEntryTotalForItem."Discount Amount", false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Value Entry"."Descuento % Consignacion", false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        //-#866

        ExcelBuf.AddColumn(
          ValueEntryTotalForItem."Sales Amount (Actual)", false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(ProfitTotalForItem,FALSE,'',FALSE,FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);//-#866
        //ExcelBuf.AddColumn("Profit%" / 100,FALSE,'',FALSE,FALSE,FALSE,'0.0%',ExcelBuf."Cell Type"::Number);//-#866
        ExcelBuf.AddColumn(ValueEntryTotalForItem."Discount Amount", false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
    end;

    local procedure CreateExcelbook()
    begin
        /*      ExcelBuf.CreateBookAndOpenExcel(Text002, Text001, Text002, CompanyName, UserId); */
        Error('');
    end;
}

