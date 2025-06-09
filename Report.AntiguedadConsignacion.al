report 56144 "Antiguedad Consignacion"
{
    // 001 #139 RRT 27.12.13 - Adaptación en RTC. La información sólo se está volcando en EXCEL.
    //                         Por tanto, la adaptación que realizaré será mínima. En caso de en un futuro tener que adaptar el
    //                         informe, podemos basarnos en el report 56074.
    DefaultLayout = RDLC;
    RDLCLayout = './AntiguedadConsignacion.rdlc';

    ApplicationArea = Suite, Basic;
    Caption = 'Age Consignment';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Global Dimension 1 Filter";
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
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(Customer__Balance_en_Consignacion_Act__; "Admite Pendientes en Pedidos")
            {
            }
            column(Customer__Inventario_en_Consignacion_Act_; "Inventario en Consignacion Act")
            {
            }
            column(w0a30; w0a30)
            {
            }
            column(w31a60; w31a60)
            {
            }
            column(w61a90; w61a90)
            {
            }
            column(w91enAde; w91enAde)
            {
            }
            column(wImp_0a30; wImp_0a30)
            {
            }
            column(wImp_31a60; wImp_31a60)
            {
            }
            column(wImp_61a90; wImp_61a90)
            {
            }
            column(wImp_91aAde; wImp_91aAde)
            {
            }
            column(w0a30_Control1000000032; w0a30)
            {
            }
            column(w31a60_Control1000000033; w31a60)
            {
            }
            column(w61a90_Control1000000034; w61a90)
            {
            }
            column(w91enAde_Control1000000035; w91enAde)
            {
            }
            column(CustomerCaption; CustomerCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer__No__Caption; FieldCaption("No."))
            {
            }
            column(Customer_NameCaption; FieldCaption(Name))
            {
            }
            column(Customer__Balance_en_Consignacion_Act__Caption; FieldCaption("Admite Pendientes en Pedidos"))
            {
            }
            column(Customer__Inventario_en_Consignacion_Act_Caption; FieldCaption("Inventario en Consignacion Act"))
            {
            }
            column(V91_a_120Caption; V91_a_120CaptionLbl)
            {
            }
            column("V0_a_90_díasCaption"; V0_a_90_díasCaptionLbl)
            {
            }
            column(V121_a_150Caption; V121_a_150CaptionLbl)
            {
            }
            column(V151_en_adelanteCaption; V151_en_adelanteCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            dataitem(t0a30; "Item Ledger Entry")
            {
                DataItemLink = "Location Code" = FIELD("No.");
                DataItemTableView = SORTING("Location Code", Open) WHERE(Open = FILTER(true));
                column(t0a30__Remaining_Quantity_; "Remaining Quantity")
                {
                }
                column(t0a30__Document_No__; "Document No.")
                {
                }
                column(Importe30; Importe30)
                {
                }
                column(t0a30_Entry_No_; "Entry No.")
                {
                }
                column(t0a30_Location_Code; "Location Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    wImporteDescuento := (("Precio Unitario Cons. Inicial" * "Remaining Quantity") * "Descuento % Cons. Inicial") / 100;
                    Importe30 := ("Precio Unitario Cons. Inicial" * "Remaining Quantity") - wImporteDescuento;
                end;

                trigger OnPreDataItem()
                begin
                    if not Detallado then
                        CurrReport.Skip;

                    SetRange("Posting Date", CalcDate('-90D', FechaDesde), FechaDesde);
                    Customer.CopyFilter("Global Dimension 1 Filter", "Global Dimension 1 Code");
                end;
            }
            dataitem(t31a60; "Item Ledger Entry")
            {
                DataItemLink = "Location Code" = FIELD("No.");
                DataItemTableView = SORTING("Location Code", "Item Category Code", "Posting Date", "Item No.");
                column(t31a60_Quantity; Quantity)
                {
                }
                column(t31a60__Document_No__; "Document No.")
                {
                }
                column(t31a60__Importe_Cons__Neto_Inicial_; "Importe Cons. Neto Inicial")
                {
                }
                column(t31a60_Entry_No_; "Entry No.")
                {
                }
                column(t31a60_Location_Code; "Location Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    wImporteDescuento := (("Precio Unitario Cons. Inicial" * "Remaining Quantity") * "Descuento % Cons. Inicial") / 100;
                    Importe60 := ("Precio Unitario Cons. Inicial" * rILE."Remaining Quantity") - wImporteDescuento;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", CalcDate('-120D', FechaDesde), CalcDate('-91D', FechaDesde));
                    Customer.CopyFilter("Global Dimension 1 Filter", "Global Dimension 1 Code");
                end;
            }
            dataitem(t61a90; "Item Ledger Entry")
            {
                DataItemLink = "Location Code" = FIELD("No.");
                DataItemTableView = SORTING("Location Code", "Item Category Code", "Posting Date", "Item No.");
                column(t61a90_Quantity; Quantity)
                {
                }
                column(t61a90__Document_No__; "Document No.")
                {
                }
                column(t61a90__Importe_Cons__Neto_Inicial_; "Importe Cons. Neto Inicial")
                {
                }
                column(t61a90_Entry_No_; "Entry No.")
                {
                }
                column(t61a90_Location_Code; "Location Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    wImporteDescuento := (("Precio Unitario Cons. Inicial" * "Remaining Quantity") * "Descuento % Cons. Inicial") / 100;
                    Importe90 := ("Precio Unitario Cons. Inicial" * rILE."Remaining Quantity") - wImporteDescuento;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", CalcDate('-150D', FechaDesde), CalcDate('-121D', FechaDesde));
                    Customer.CopyFilter("Global Dimension 1 Filter", "Global Dimension 1 Code");
                end;
            }
            dataitem(t91Adelante; "Item Ledger Entry")
            {
                DataItemLink = "Location Code" = FIELD("No.");
                DataItemTableView = SORTING("Location Code", "Item Category Code", "Posting Date", "Item No.");
                column(t91Adelante_Quantity; Quantity)
                {
                }
                column(t91Adelante__Document_No__; "Document No.")
                {
                }
                column(t91Adelante__Importe_Cons__Neto_Inicial_; "Importe Cons. Neto Inicial")
                {
                }
                column(t91Adelante_Entry_No_; "Entry No.")
                {
                }
                column(t91Adelante_Location_Code; "Location Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    wImporteDescuento := (("Precio Unitario Cons. Inicial" * "Remaining Quantity") * "Descuento % Cons. Inicial") / 100;
                    Importe91Ade := ("Precio Unitario Cons. Inicial" * rILE."Remaining Quantity") - wImporteDescuento;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", 0D, CalcDate('-151D', FechaDesde));
                    Customer.CopyFilter("Global Dimension 1 Filter", "Global Dimension 1 Code");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(w0a30);
                Clear(w31a60);
                Clear(w61a90);
                Clear(w91enAde);
                Clear(wImp_0a30);
                Clear(wImp_31a60);
                Clear(wImp_61a90);
                Clear(wImp_91aAde);
                Clear(wImporteDescuento);

                rILE.Reset;
                rILE.SetCurrentKey("Posting Date", "Location Code");
                rILE.SetRange("Posting Date", CalcDate('-90D', FechaDesde), FechaDesde);
                rILE.SetRange("Location Code", "No.");
                Customer.CopyFilter("Global Dimension 1 Filter", rILE."Global Dimension 1 Code");
                rILE.SetRange(rILE.Open, true);
                if rILE.FindSet then
                    repeat
                        //w0a30 += rILE."Cant. Consignacion Pendiente";
                        //w0a30 += rILE.Quantity;
                        w0a30 += rILE."Remaining Quantity";
                        //wImp_0a30 += rILE."Importe Consignacion Neto";
                        wImporteDescuento := ((rILE."Precio Unitario Cons. Inicial" * rILE."Remaining Quantity") * rILE."Descuento % Cons. Inicial") / 100;
                        wImp_0a30 += (rILE."Precio Unitario Cons. Inicial" * rILE."Remaining Quantity") - wImporteDescuento;
                    until rILE.Next = 0;

                rILE.Reset;
                rILE.SetCurrentKey("Posting Date", "Location Code");
                rILE.SetRange("Posting Date", CalcDate('-120D', FechaDesde), CalcDate('-91D', FechaDesde));
                rILE.SetRange("Location Code", "No.");
                Customer.CopyFilter("Global Dimension 1 Filter", rILE."Global Dimension 1 Code");
                rILE.SetRange(rILE.Open, true);
                if rILE.FindSet then
                    repeat
                        w31a60 += rILE."Remaining Quantity";
                        wImporteDescuento := ((rILE."Precio Unitario Cons. Inicial" * rILE."Remaining Quantity") * rILE."Descuento % Cons. Inicial") / 100;
                        wImp_31a60 += (rILE."Precio Unitario Cons. Inicial" * rILE."Remaining Quantity") - wImporteDescuento;
                    until rILE.Next = 0;

                rILE.Reset;
                rILE.SetCurrentKey("Posting Date", "Location Code");
                rILE.SetRange("Posting Date", CalcDate('-150D', FechaDesde), CalcDate('-121D', FechaDesde));
                rILE.SetRange("Location Code", "No.");
                Customer.CopyFilter("Global Dimension 1 Filter", rILE."Global Dimension 1 Code");
                rILE.SetRange(rILE.Open, true);
                if rILE.FindSet then
                    repeat
                        w61a90 += rILE."Remaining Quantity";
                        wImporteDescuento := ((rILE."Precio Unitario Cons. Inicial" * rILE."Remaining Quantity") * rILE."Descuento % Cons. Inicial") / 100;
                        wImp_61a90 += (rILE."Precio Unitario Cons. Inicial" * rILE."Remaining Quantity") - wImporteDescuento;
                    until rILE.Next = 0;

                rILE.Reset;
                rILE.SetCurrentKey("Posting Date", "Location Code");
                rILE.SetRange("Posting Date", 0D, CalcDate('-151D', FechaDesde));
                rILE.SetRange("Location Code", "No.");
                Customer.CopyFilter("Global Dimension 1 Filter", rILE."Global Dimension 1 Code");
                rILE.SetRange(rILE.Open, true);
                if rILE.FindSet then
                    repeat
                        w91enAde += rILE."Remaining Quantity";
                        wImporteDescuento := ((rILE."Precio Unitario Cons. Inicial" * rILE."Remaining Quantity") * rILE."Descuento % Cons. Inicial") / 100;
                        wImp_91aAde += (rILE."Precio Unitario Cons. Inicial" * rILE."Remaining Quantity") - wImporteDescuento;
                    until rILE.Next = 0;


                //+001
                if PrintToExcel then
                    MakeExcelDataBody1;
                //-001
            end;

            trigger OnPostDataItem()
            begin
                if Detallado then
                    MakeExcelDataHeader1;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Date Filter", 0D, FechaDesde);
                //CurrReport.CreateTotals(w0a30, w31a60, w61a90, w91enAde);
                ExcelBuf.SetUseInfoSheet;
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
        FechaDesde := WorkDate;
        PrintToExcel := true;

        //+001
        //Filtros := Customer.GETFILTERS;
        Filtros := txt100;
        //-001

        if PrintToExcel then
            MakeExcelDataHeader;
    end;

    var
        FechaDesde: Date;
        w0a30: Decimal;
        w31a60: Decimal;
        w61a90: Decimal;
        w91enAde: Decimal;
        rTransRecLin: Record "Transfer Receipt Line";
        rILE: Record "Item Ledger Entry";
        Filtros: Text[100];
        Detallado: Boolean;
        wImp_0a30: Decimal;
        wImp_31a60: Decimal;
        wImp_61a90: Decimal;
        wImp_91aAde: Decimal;
        ExcelBuf: Record "Excel Buffer" temporary;
        PrintToExcel: Boolean;
        Text000: Label 'Antiguedad Consignación';
        txt001: Label 'Balance en Consignación';
        txt002: Label 'Inventario en Consignación';
        txt003: Label '0 a 90 días';
        txt004: Label '91 a 120 días';
        txt005: Label '121 a 150 días';
        txt006: Label '151 en adelante';
        txt007: Label 'Total';
        txt008: Label 'Imp. 0 a 90 días';
        txt009: Label 'Imp. 91 a 120 días';
        txt010: Label 'Imp. 121 a 150 días';
        txt011: Label 'Imp. 151 en adelante';
        wImporteDescuento: Decimal;
        Importe30: Decimal;
        Importe60: Decimal;
        Importe90: Decimal;
        Importe91Ade: Decimal;
        TotalCant: Decimal;
        SP: Record "Salesperson/Purchaser";
        txt012: Label 'Salesperson';
        txt013: Label 'Detalle';
        txt014: Label 'Location Code';
        txt015: Label 'Name';
        txt016: Label 'Tipo';
        txt017: Label 'Nº documento externo';
        txt018: Label 'Fecha Registro';
        txt019: Label 'Nº documento';
        txt020: Label 'Nº producto';
        txt021: Label 'Descripcion Producto';
        txt022: Label 'Canitdad Facturada';
        txt023: Label 'Cantidad pendiente';
        txt024: Label 'Precio Unitario';
        txt025: Label 'Descuento % Consignacion';
        txt026: Label 'Vta Neta';
        txt027: Label 'Vta Liquida';
        txt028: Label 'Dim Línea Negocio';
        txt029: Label 'Detalle';
        FiltroLinNeg: Text[200];
        Item: Record Item;
        txt030: Label 'Antigüedad';
        txt031: Label 'Cód. Zona de Servicio';
        txt032: Label 'Cód. Vendedor';
        txt033: Label 'Cód. Cliente';
        txt034: Label 'Nombre Cliente';
        Cust: Record Customer;
        CantDias: Integer;
        CantDiastxt: Text[30];
        CodVendedor: Code[20];
        TRH: Record "Transfer Receipt Header";
        VentaNeta: Decimal;
        VentaLiquida: Decimal;
        ImporteDesc: Decimal;
        txt100: Label 'La información se ha volcado en documento EXCEL';
        CustomerCaptionLbl: Label 'Customer';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        V91_a_120CaptionLbl: Label '91 a 120';
        "V0_a_90_díasCaptionLbl": Label '0 a 90 días';
        V121_a_150CaptionLbl: Label '121 a 150';
        V151_en_adelanteCaptionLbl: Label '151 en adelante';
        TotalCaptionLbl: Label 'Total';


    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        MakeExcelDataHeader;
    end;


    procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow;


        ExcelBuf.AddColumn(Format(Text000), false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(CompanyName), false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Filtros: ' + Filtros, false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Format(Customer.FieldCaption("No.")), false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(Customer.FieldCaption(Name)), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(Customer.FieldCaption("Service Zone Code")), false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt012), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt001), false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt002), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt003), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt004), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt005), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt006), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(FORMAT(txt007),FALSE,'',TRUE,FALSE,FALSE,'@');
        ExcelBuf.AddColumn(Format(txt008), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt009), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt010), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt011), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
    end;


    procedure MakeExcelDataBody1()
    begin
        ExcelBuf.NewRow;
        //ExcelBuf.NewRow;

        if not SP.Get(Customer."Salesperson Code") then
            SP.Init;

        ExcelBuf.AddColumn(Format(Customer."No."), false, '', false, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(Customer.Name), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer."Service Zone Code", false, '', false, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SP.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer."Admite Pendientes en Pedidos", false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer."Inventario en Consignacion Act", false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(w0a30), false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(w31a60), false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(w61a90), false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(w91enAde), false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
        //TotalCant := w0a30 + w31a60 + w61a90 + w91enAde;
        //ExcelBuf.AddColumn(FORMAT(TotalCant),FALSE,'',FALSE,FALSE,FALSE,'#,###,##0.00');
        //ExcelBuf.NewRow;
        /*
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        */
        ExcelBuf.AddColumn(Format(wImp_0a30), false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(wImp_31a60), false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(wImp_61a90), false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(wImp_91aAde), false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);

    end;


    procedure MakeExcelDataFooter()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt007), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(w0a30, false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(w31a60, false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(w61a90, false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(w91enAde, false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
    end;


    procedure CreateExcelbook()
    begin
        /*         ExcelBuf.CreateBookAndOpenExcel('', Text000, Text000, CompanyName, UserId); */
        Error('');
    end;


    procedure MakeExcelDataBody2()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(t0a30."Document No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(t0a30.Quantity, false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(t0a30."Importe Cons. Neto Inicial", false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
    end;


    procedure MakeExcelDataBody3()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(t31a60."Document No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(t31a60.Quantity, false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        /*
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        */
        ExcelBuf.AddColumn(t31a60."Importe Cons. Neto Inicial", false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);

    end;


    procedure MakeExcelDataBody4()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(t61a90."Document No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(t61a90.Quantity, false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.NewRow;
        /*
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        */
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(t61a90."Importe Cons. Neto Inicial", false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);

    end;


    procedure MakeExcelDataBody5()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(t91Adelante."Document No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(t91Adelante.Quantity, false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);
        /*ExcelBuf.NewRow;
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        */
        ExcelBuf.AddColumn(t91Adelante."Importe Cons. Neto Inicial", false, '', false, false, false, '#,###,##0.00', ExcelBuf."Cell Type"::Text);

    end;


    procedure MakeExcelDataHeader1()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Format(txt029), false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Format(txt030), false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt031), false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt032), false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt033), false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt034), false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt015), false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt017), false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt018), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt019), false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt020), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt021), false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt022), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt023), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt024), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt025), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt026), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt027), false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Format(txt028), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);

        rILE.Reset;
        rILE.SetCurrentKey("Location Code");
        rILE.SetRange("Location Code", Customer."No.");
        rILE.SetRange(rILE.Open, true);
        if FiltroLinNeg <> '' then
            rILE.SetRange("Global Dimension 1 Code", Customer.GetRangeMin(Customer."Global Dimension 1 Filter"),
                          Customer.GetRangeMax(Customer."Global Dimension 1 Filter"));
        if rILE.FindSet then
            repeat
                Cust.Get(rILE."Location Code");
                Item.Get(rILE."Item No.");
                CantDias := WorkDate - rILE."Posting Date";
                if CantDias <= 90 then
                    CantDiastxt := txt003;

                if (CantDias > 90) and (CantDias <= 120) then
                    CantDiastxt := txt004;

                if (CantDias > 120) and (CantDias <= 150) then
                    CantDiastxt := txt005;

                if (CantDias > 150) then
                    CantDiastxt := txt006;

                if TRH.Get(rILE."Document No.") then
                    CodVendedor := TRH."Cod. Vendedor"
                else
                    CodVendedor := '';

                ImporteDesc := ((rILE."Remaining Quantity" * rILE."Precio Unitario Cons. Inicial") * rILE."Descuento % Cons. Inicial") / 100;
                VentaNeta := (rILE."Remaining Quantity" * rILE."Precio Unitario Cons. Inicial");
                VentaLiquida := (rILE."Remaining Quantity" * rILE."Precio Unitario Cons. Inicial") - ImporteDesc;

                ExcelBuf.NewRow;
                ExcelBuf.AddColumn(Format(CantDias), false, '', false, false, false, '@', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(Cust."Service Zone Code"), false, '', false, false, false, '@', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(CodVendedor), false, '', false, false, false, '@', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(Cust."No."), false, '', false, false, false, '@', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(Cust.Name), false, '', false, false, false, '@', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(rILE.Description), false, '', false, false, false, '@', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(rILE."External Document No."), false, '', false, false, false, '@', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(rILE."Posting Date"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(rILE."Document No."), false, '', false, false, false, '@', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(rILE."Item No."), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(Item.Description), false, '', false, false, false, '@', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(rILE."Invoiced Quantity"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(rILE."Remaining Quantity"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(rILE."Precio Unitario Cons. Inicial"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(rILE."Descuento % Cons. Inicial"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(VentaNeta), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(VentaLiquida), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(rILE."Global Dimension 1 Code"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            until rILE.Next = 0;
    end;
}

