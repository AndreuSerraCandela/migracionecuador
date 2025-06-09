report 56138 "Estadisticas de Vtas.."
{
    // 
    //  WHERE(Item Ledger Entry Type=FILTER(Sale),Invoiced Quantity=FILTER(<>0))
    DefaultLayout = RDLC;
    RDLCLayout = './EstadisticasdeVtas.56138.rdlc';


    dataset
    {
        dataitem("Value Entry"; "Value Entry")
        {
            DataItemTableView = SORTING("Gen. Bus. Posting Group", "Global Dimension 1 Code") ORDER(Ascending);
            RequestFilterFields = "Item No.", "Source No.", "Global Dimension 2 Code", "Posting Date", "Document Type";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Filtros; Filtros)
            {
            }
            column(Detallado_; Detallado)
            {
            }
            column(Value_Entry__Gen__Bus__Posting_Group_; "Gen. Bus. Posting Group")
            {
            }
            column(Dim1; Dim1)
            {
            }
            column(Value_Entry__Source_No__; "Source No.")
            {
            }
            column(Dim2; Dim2)
            {
            }
            column(Value_Entry__Item_No__; "Item No.")
            {
            }
            column(Value_Entry__Document_No__; "Document No.")
            {
            }
            column(Value_Entry__Posting_Date_; "Posting Date")
            {
            }
            column(CtdDevol; CtdDevol)
            {
            }
            column(ImpVtaBta; ImpVtaBta)
            {
            }
            column(ImpDevol; ImpDevol)
            {
            }
            column(CtdVtaBta___CtdDevol; CtdVtaBta - CtdDevol)
            {
            }
            column(ImpVtaBta___ImpDevol; ImpVtaBta - ImpDevol)
            {
            }
            column(Value_Entry__Discount_Amount_; DiscountAmount)
            {
            }
            column(ImpVtaBta___ImpDevol___ABS__Discount_Amount__; (ImpVtaBta - ImpDevol) - Abs(DiscountAmount))
            {
            }
            column(V1__Cost_Amount__Actual__; -1 * CostAmount)
            {
            }
            column(CtdVtaBta; CtdVtaBta)
            {
            }
            column(TotalFor___Dim1; TotalFor + Dim1)
            {
            }
            column(CtdVtaBta_Control1000000063; CtdVtaBtaDimTot)
            {
            }
            column(CtdDevol_Control1000000064; CtdDevolDimTot)
            {
            }
            column(ImpVtaBta_Control1000000065; ImpVtaBtaDimTot)
            {
            }
            column(ImpDevol_Control1000000066; ImpDevolDimTot)
            {
            }
            column(CtdVtaBta___CtdDevol_Control1000000067; CtdVtaBtaDimTot - CtdDevolDimTot)
            {
            }
            column(ImpVtaBta___ImpDevol_Control1000000068; ImpVtaBtaDimTot - ImpDevolDimTot)
            {
            }
            column(Value_Entry__Discount_Amount__Control1000000069; DiscountAmountDimTot)
            {
            }
            column(ImpVtaBta___ImpDevol___ABS__Discount_Amount___Control1000000070; (ImpVtaBtaDimTot - ImpDevolDimTot) - Abs(DiscountAmountDimTot))
            {
            }
            column(V1__Cost_Amount__Actual___Control1000000071; -1 * CostAmountDimTot)
            {
            }
            column(TotalFor____Gen__Bus__Posting_Group_; TotalFor + "Gen. Bus. Posting Group")
            {
            }
            column(CtdVtaBta_Control1000000081; CtdVtaBtaGenTot)
            {
            }
            column(CtdDevol_Control1000000082; CtdDevolGenTot)
            {
            }
            column(ImpVtaBta_Control1000000083; ImpVtaBtaGenTot)
            {
            }
            column(ImpDevol_Control1000000084; ImpDevolGenTot)
            {
            }
            column(CtdVtaBta___CtdDevol_Control1000000085; CtdVtaBtaGenTot - CtdDevolGenTot)
            {
            }
            column(ImpVtaBta___ImpDevol_Control1000000086; ImpVtaBtaGenTot - ImpDevolGenTot)
            {
            }
            column(Value_Entry__Discount_Amount__Control1000000087; DiscountAmountGenTot)
            {
            }
            column(ImpVtaBta___ImpDevol___ABS__Discount_Amount___Control1000000088; (ImpVtaBtaGenTot - ImpDevolGenTot) - Abs(DiscountAmountGenTot))
            {
            }
            column(V1__Cost_Amount__Actual___Control1000000089; -1 * CostAmountGenTot)
            {
            }
            column(CtdVtaBta_Control1000000011; CtdVtaBtaGranTot)
            {
            }
            column(CtdDevol_Control1000000012; CtdDevolGranTot)
            {
            }
            column(ImpVtaBta_Control1000000019; ImpVtaBtaGranTot)
            {
            }
            column(ImpDevol_Control1000000020; ImpDevolGranTot)
            {
            }
            column(CtdVtaBta___CtdDevol_Control1000000021; CtdVtaBtaGranTot - CtdDevolGranTot)
            {
            }
            column(ImpVtaBta___ImpDevol_Control1000000022; ImpVtaBtaGranTot - ImpDevolGranTot)
            {
            }
            column(Value_Entry__Discount_Amount__Control1000000025; DiscountAmountGranTot)
            {
            }
            column(ImpVtaBta___ImpDevol___ABS__Discount_Amount___Control1000000026; (ImpVtaBtaGranTot - ImpDevolGranTot) - Abs(DiscountAmountGranTot))
            {
            }
            column(V1__Cost_Amount__Actual___Control1000000027; -1 * CostAmountGranTot)
            {
            }
            column(Value_EntryCaption; Value_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column("Cód__ClienteCaption"; Cód__ClienteCaptionLbl)
            {
            }
            column(Tipor_ClienteCaption; Tipor_ClienteCaptionLbl)
            {
            }
            column(Value_Entry__Item_No__Caption; FieldCaption("Item No."))
            {
            }
            column(Cant__Ventas_BrutasCaption; Cant__Ventas_BrutasCaptionLbl)
            {
            }
            column("Vta__LíquidaCaption"; Vta__LíquidaCaptionLbl)
            {
            }
            column(Value_Entry__Discount_Amount_Caption; Value_Entry__Discount_Amount_CaptionLbl)
            {
            }
            column(Value_Entry__Document_No__Caption; FieldCaption("Document No."))
            {
            }
            column(Value_Entry__Posting_Date_Caption; FieldCaption("Posting Date"))
            {
            }
            column(Cant__Devol__BrutaCaption; Cant__Devol__BrutaCaptionLbl)
            {
            }
            column(Imp__Ventas_BrutasCaption; Imp__Ventas_BrutasCaptionLbl)
            {
            }
            column(Imp__Devol__BrutasCaption; Imp__Devol__BrutasCaptionLbl)
            {
            }
            column(Cant__Ventas_NetasCaption; Cant__Ventas_NetasCaptionLbl)
            {
            }
            column(Imp__Vtas__NetasCaption; Imp__Vtas__NetasCaptionLbl)
            {
            }
            column(Costo_de_Vta_Caption; Costo_de_Vta_CaptionLbl)
            {
            }
            column(Value_Entry__Gen__Bus__Posting_Group_Caption; FieldCaption("Gen. Bus. Posting Group"))
            {
            }
            column(Dim1Caption; Dim1CaptionLbl)
            {
            }
            column(TotalesCaption; TotalesCaptionLbl)
            {
            }
            column(Value_Entry_Entry_No_; "Entry No.")
            {
            }
            column(Value_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
            {
            }

            trigger OnAfterGetRecord()
            begin

                CtdVtaBta := 0;
                ImpVtaBta := 0;
                CtdDevol := 0;
                ImpDevol := 0;
                CostAmount := 0;
                DiscountAmount := 0;

                if FirstTime then
                    GroupHeader2;

                //total por dimension
                if (DimAnt <> "Global Dimension 1 Code") then begin
                    Borrardim;
                    DimAnt := "Value Entry"."Global Dimension 1 Code";
                end;

                // Totales  por grupo negocio
                if (GenAnt <> "Gen. Bus. Posting Group") then begin
                    Borrargen;
                    GenAnt := "Gen. Bus. Posting Group";
                end;


                CostAmount := "Cost Amount (Actual)";
                DiscountAmount := "Discount Amount";

                if "Invoiced Quantity" < 0 then begin
                    CtdVtaBta := Abs("Invoiced Quantity");
                    ImpVtaBta := Abs("Sales Amount (Actual)") + Abs("Discount Amount");
                end
                else begin
                    CtdDevol := Abs("Invoiced Quantity");
                    ImpDevol := Abs("Sales Amount (Actual)") + +Abs("Discount Amount");
                end;

                GLS.Get;
                if DV.Get(GLS."Global Dimension 1 Code", "Value Entry"."Global Dimension 1 Code") then
                    Dim1 := DV.Name
                else
                    Dim1 := "Value Entry"."Global Dimension 1 Code";

                if Detallado then begin
                    GLS.Get;
                    if DV.Get(GLS."Global Dimension 2 Code", "Value Entry"."Global Dimension 2 Code") then
                        Dim2 := DV.Name
                    else
                        Dim2 := "Global Dimension 2 Code";
                    if Cust.Get("Source No.") then
                        Nombre := Cust.Name
                    else
                        Nombre := '';
                    if Item.Get("Item No.") then
                        Desc := Item.Description
                    else
                        Desc := '';

                    if PrintToExcel then
                        MakeExcelDataBody;
                end;

                Acumular;
            end;

            trigger OnPostDataItem()
            begin

                if PrintToExcel then begin
                    GroupHeader1;
                    MakeExcelDataBody2;
                    MakeExcelDataBody3;
                    MakeExcelFooter;
                end;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Global Dimension 2 Code");

                FirstTime := true;

                if PrintToExcel then
                    MakeExcelDataHeader;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Detallado; Detallado)
                {
                ApplicationArea = All;
                }
                field("Exportar a Excel"; PrintToExcel)
                {
                ApplicationArea = All;
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
        CI.Get;
        Filtros := "Value Entry".GetFilters;
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: Label 'Total for ';
        Detallado: Boolean;
        Nombre: Text[150];
        Cust: Record Customer;
        Desc: Text[150];
        Item: Record Item;
        CtdVtaBta: Decimal;
        CtdDevol: Decimal;
        ImpVtaBta: Decimal;
        ImpDevol: Decimal;
        CostAmount: Decimal;
        DiscountAmount: Decimal;
        ExcelBuf: Record "Excel Buffer" temporary;
        PrintToExcel: Boolean;
        Text001: Label 'Data';
        Text000: Label 'Redeemed Cupon''s Report';
        CI: Record "Company Information";
        GLS: Record "General Ledger Setup";
        DV: Record "Dimension Value";
        Dim2: Text[100];
        Dim1: Text[100];
        Filtros: Text[1024];
        DimAnt: Code[20];
        GenAnt: Code[10];
        CtdVtaBtaGenTot: Decimal;
        CtdDevolGenTot: Decimal;
        ImpVtaBtaGenTot: Decimal;
        ImpDevolGenTot: Decimal;
        CostAmountGenTot: Decimal;
        DiscountAmountGenTot: Decimal;
        CtdVtaBtaDimTot: Decimal;
        CtdDevolDimTot: Decimal;
        ImpVtaBtaDimTot: Decimal;
        ImpDevolDimTot: Decimal;
        CostAmountDimTot: Decimal;
        DiscountAmountDimTot: Decimal;
        CtdVtaBtaGranTot: Decimal;
        CtdDevolGranTot: Decimal;
        ImpVtaBtaGranTot: Decimal;
        ImpDevolGranTot: Decimal;
        CostAmountGranTot: Decimal;
        DiscountAmountGranTot: Decimal;
        FirstTime: Boolean;
        lastgen: Code[10];
        Value_EntryCaptionLbl: Label 'Value Entry';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        "Cód__ClienteCaptionLbl": Label 'Cód. Cliente';
        Tipor_ClienteCaptionLbl: Label 'Tipor Cliente';
        Cant__Ventas_BrutasCaptionLbl: Label 'Cant. Ventas Brutas';
        "Vta__LíquidaCaptionLbl": Label 'Vta. Líquida';
        Value_Entry__Discount_Amount_CaptionLbl: Label 'Importe Descuento';
        Cant__Devol__BrutaCaptionLbl: Label 'Cant. Devol. Bruta';
        Imp__Ventas_BrutasCaptionLbl: Label 'Imp. Ventas Brutas';
        Imp__Devol__BrutasCaptionLbl: Label 'Imp. Devol. Brutas';
        Cant__Ventas_NetasCaptionLbl: Label 'Cant. Ventas Netas';
        Imp__Vtas__NetasCaptionLbl: Label 'Imp. Vtas. Netas';
        Costo_de_Vta_CaptionLbl: Label 'Costo de Vta.';
        Dim1CaptionLbl: Label 'Línea de negocio :';
        TotalesCaptionLbl: Label 'Totales';

    local procedure CreateExcelbook()
    begin
        /*         ExcelBuf.CreateBookAndOpenExcel('', Text001, Text000, CompanyName, UserId); */
        Error('');
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Filtros, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CI.Name + ' RUC ' + CI."VAT Registration No.", false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('MOVIMIENTO VALOR', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;

        ExcelBuf.AddColumn('No. Documento', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Fecha Registro', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Cod. Cliente', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Tipo Cliente', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('No. Producto', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Cant. Vtas. Brutas', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Imp. Vta. Bruta', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Cant. Devol. Brutas', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Imp. Devol. Bruta', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Cant. Vta. Neta', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Imp. Vta. Neta', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Imp. Dto.', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vta. Liquida', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Costo Vta.', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Grpo. Contable Neg.', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Desc. Producto', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Nombre Cliente', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeExcelDataBody()
    begin

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Value Entry"."Document No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Value Entry"."Posting Date", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Value Entry"."Source No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        GLS.Get;
        if DV.Get(GLS."Global Dimension 2 Code", "Value Entry"."Global Dimension 2 Code") then
            ExcelBuf.AddColumn(DV.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)
        else
            ExcelBuf.AddColumn("Value Entry"."Global Dimension 2 Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Value Entry"."Item No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CtdVtaBta, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ImpVtaBta, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CtdDevol, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ImpDevol, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CtdVtaBta - CtdDevol, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ImpVtaBta - ImpDevol, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Value Entry"."Discount Amount", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn((ImpVtaBta - ImpDevol) - Abs("Value Entry"."Discount Amount"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(-1 * "Value Entry"."Cost Amount (Actual)", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Value Entry"."Gen. Bus. Posting Group", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Desc, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Nombre, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeExcelFooter()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TOTALES ', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CtdVtaBtaGranTot, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ImpVtaBtaGranTot, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CtdDevolGranTot, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ImpDevolGranTot, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CtdVtaBtaGranTot - CtdDevolGranTot, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ImpVtaBtaGranTot - ImpDevolGranTot, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(DiscountAmountGranTot, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn((ImpVtaBtaGranTot - ImpDevolGranTot) - Abs(DiscountAmountGranTot), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(-1 * CostAmountGranTot, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
    end;


    procedure GroupHeader1()
    begin

        if Detallado then
            exit;

        if Dim1 = '' then
            exit;

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Línea de Negocio', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Dim1, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
    end;


    procedure GroupHeader2()
    begin

        if ((GenAnt = "Value Entry"."Gen. Bus. Posting Group") and (not FirstTime)) or
           ((lastgen = "Value Entry"."Gen. Bus. Posting Group") and (lastgen <> '')) then
            exit;


        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Grupo Cont. Negocio', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Value Entry"."Gen. Bus. Posting Group", false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);

        FirstTime := false;
        lastgen := "Value Entry"."Gen. Bus. Posting Group";
    end;

    local procedure MakeExcelDataBody2()
    begin

        if (CtdVtaBtaDimTot = 0) and (ImpVtaBtaDimTot = 0) and (CtdDevolDimTot = 0) and (ImpDevolDimTot = 0) then
            exit;

        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CtdVtaBtaDimTot, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ImpVtaBtaDimTot, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CtdDevolDimTot, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ImpDevolDimTot, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CtdVtaBtaDimTot - CtdDevolDimTot, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ImpVtaBtaDimTot - ImpDevolDimTot, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(DiscountAmountDimTot, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn((ImpVtaBtaDimTot - ImpDevolDimTot) - Abs(DiscountAmountDimTot), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(-1 * CostAmountDimTot, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeExcelDataBody3()
    begin

        if (CtdVtaBtaGenTot = 0) and (ImpVtaBtaGenTot = 0) and (CtdDevolGenTot = 0) and (ImpDevolGenTot = 0) then
            exit;

        ExcelBuf.NewRow;
        //ExcelBuf.AddColumn(TotalFor + "Value Entry"."Gen. Bus. Posting Group",FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(TotalFor + GenAnt, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CtdVtaBtaGenTot, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ImpVtaBtaGenTot, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CtdDevolGenTot, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ImpDevolGenTot, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CtdVtaBtaGenTot - CtdDevolGenTot, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ImpVtaBtaGenTot - ImpDevolGenTot, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(DiscountAmountGenTot, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn((ImpVtaBtaGenTot - ImpDevolGenTot) - Abs(DiscountAmountGenTot), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(-1 * CostAmountGenTot, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
    end;


    procedure Acumular()
    begin

        CtdVtaBtaGenTot += CtdVtaBta;
        CtdDevolGenTot += CtdDevol;
        ImpVtaBtaGenTot += ImpVtaBta;
        ImpDevolGenTot += ImpDevol;
        CostAmountGenTot += CostAmount;
        DiscountAmountGenTot += DiscountAmount;

        CtdVtaBtaDimTot += CtdVtaBta;
        CtdDevolDimTot += CtdDevol;
        ImpVtaBtaDimTot += ImpVtaBta;
        ImpDevolDimTot += ImpDevol;
        CostAmountDimTot += CostAmount;
        DiscountAmountDimTot += DiscountAmount;

        CtdVtaBtaGranTot += CtdVtaBta;
        CtdDevolGranTot += CtdDevol;
        ImpVtaBtaGranTot += ImpVtaBta;
        ImpDevolGranTot += ImpDevol;
        CostAmountGranTot += CostAmount;
        DiscountAmountGranTot += DiscountAmount;
    end;


    procedure Borrargen()
    begin

        if PrintToExcel then
            MakeExcelDataBody3;

        CtdVtaBtaGenTot := 0;
        CtdDevolGenTot := 0;
        ImpVtaBtaGenTot := 0;
        ImpDevolGenTot := 0;
        CostAmountGenTot := 0;
        DiscountAmountGenTot := 0;

        if PrintToExcel and (not FirstTime) then
            GroupHeader2;

        FirstTime := false;
    end;


    procedure Borrardim()
    begin

        if PrintToExcel then begin
            GroupHeader1;
            MakeExcelDataBody2;
        end;

        CtdVtaBtaDimTot := 0;
        CtdDevolDimTot := 0;
        ImpVtaBtaDimTot := 0;
        ImpDevolDimTot := 0;
        CostAmountDimTot := 0;
        DiscountAmountDimTot := 0;
    end;
}

