report 56074 "Antiguedad Importe Consig."
{
    // No.         Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // 139         12/12/2013      RRT           Adaptación informes a RTC. Corrección de errores detectados.
    DefaultLayout = RDLC;
    RDLCLayout = './AntiguedadImporteConsig.rdlc';

    ApplicationArea = Suite, Basic;
    Caption = 'Age Amount Consignment';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING ("No.");
            RequestFilterFields = "No.";
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
            column(V31_a_60Caption; V31_a_60CaptionLbl)
            {
            }
            column(V0_a_30_diasCaption; V0_a_30_diasCaptionLbl)
            {
            }
            column(V61_a_97Caption; V61_a_97CaptionLbl)
            {
            }
            column(V98_en_adelanteCaption; V98_en_adelanteCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            dataitem(t0a30; "Item Ledger Entry")
            {
                DataItemLink = "Location Code" = FIELD ("No.");
                DataItemTableView = SORTING ("Item No.", "Variant Code", Open, Positive, "Location Code", "Posting Date") ORDER(Ascending);
                column(t0a30__Importe_Cons__Neto_Inicial_; "Importe Cons. Neto Inicial")
                {
                }
                column(t0a30__Document_No__; "Document No.")
                {
                }
                column(t0a30_Entry_No_; "Entry No.")
                {
                }
                column(t0a30_Location_Code; "Location Code")
                {
                }

                trigger OnPreDataItem()
                begin
                    if not Detallado then
                        //+139
                        //CurrReport.SKIP;
                        CurrReport.Break;
                    //-139

                    SetRange("Posting Date", CalcDate('-30D', FechaDesde), FechaDesde);
                end;
            }
            dataitem(t31a60; "Item Ledger Entry")
            {
                DataItemLink = "Location Code" = FIELD ("No.");
                DataItemTableView = SORTING ("Item No.", "Variant Code", Open, Positive, "Location Code", "Posting Date") ORDER(Ascending);
                column(t31a60__Importe_Cons__Neto_Inicial_; "Importe Cons. Neto Inicial")
                {
                }
                column(t31a60__Document_No__; "Document No.")
                {
                }
                column(t31a60_Entry_No_; "Entry No.")
                {
                }
                column(t31a60_Location_Code; "Location Code")
                {
                }

                trigger OnPreDataItem()
                begin
                    //+139
                    //... Si no se ha indicado mostrar el detalle, se abortará la ejecución del DataItem.
                    if not Detallado then
                        CurrReport.Break;
                    //-139

                    SetRange("Posting Date", CalcDate('-60D', FechaDesde), CalcDate('-31D', FechaDesde));
                end;
            }
            dataitem(t61a97; "Item Ledger Entry")
            {
                DataItemLink = "Location Code" = FIELD ("No.");
                DataItemTableView = SORTING ("Item No.", "Variant Code", Open, Positive, "Location Code", "Posting Date") ORDER(Ascending);
                column(t61a97__Importe_Cons__Neto_Inicial_; "Importe Cons. Neto Inicial")
                {
                }
                column(t61a97__Document_No__; "Document No.")
                {
                }
                column(t61a97_Entry_No_; "Entry No.")
                {
                }
                column(t61a97_Location_Code; "Location Code")
                {
                }

                trigger OnPreDataItem()
                begin
                    //+139
                    //... Si no se ha indicado mostrar el detalle, se abortará la ejecución del DataItem.
                    if not Detallado then
                        CurrReport.Break;
                    //-139

                    SetRange("Posting Date", CalcDate('-97D', FechaDesde), CalcDate('-61D', FechaDesde));
                end;
            }
            dataitem(t98Adelante; "Item Ledger Entry")
            {
                DataItemLink = "Location Code" = FIELD ("No.");
                DataItemTableView = SORTING ("Item No.", "Variant Code", Open, Positive, "Location Code", "Posting Date") ORDER(Ascending);
                column(t98Adelante__Importe_Cons__Neto_Inicial_; "Importe Cons. Neto Inicial")
                {
                }
                column(t98Adelante__Document_No__; "Document No.")
                {
                }
                column(t98Adelante_Entry_No_; "Entry No.")
                {
                }
                column(t98Adelante_Location_Code; "Location Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //+139
                    //... Cambio de trigger
                    //SETRANGE("Posting Date",0D,CALCDATE('-98D',FechaDesde));
                    //-139
                end;

                trigger OnPreDataItem()
                begin
                    //+139
                    //... Si no se ha indicado mostrar el detalle, se abortará la ejecución del DataItem.
                    if not Detallado then
                        CurrReport.Break;
                    //-139

                    //+139
                    //... Por error, esta acción estaba en el trigger OnAfterGetRecord()
                    SetRange("Posting Date", 0D, CalcDate('-98D', FechaDesde));
                    //-139
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(w0a30);
                Clear(w31a60);
                Clear(w61a90);
                Clear(w91enAde);

                rILE.Reset;
                rILE.SetCurrentKey("Posting Date", "Location Code");
                rILE.SetRange("Posting Date", CalcDate('-30D', FechaDesde), FechaDesde);
                rILE.SetRange("Location Code", "No.");
                //rILE.SETFILTER("Cant. Consignacion Pendiente",'>%1',0);

                if rILE.FindSet then
                    repeat
                        //w0a30 += rILE."Cant. Consignacion Pendiente";
                        w0a30 += rILE."Importe Cons. Neto Inicial";
                    until rILE.Next = 0;

                rILE.Reset;
                rILE.SetCurrentKey("Posting Date", "Location Code");
                rILE.SetRange("Posting Date", CalcDate('-60D', FechaDesde), CalcDate('-31D', FechaDesde));
                rILE.SetRange("Location Code", "No.");
                //rILE.SETFILTER("Cant. Consignacion Pendiente",'>%1',0);

                if rILE.FindSet then
                    repeat
                        w31a60 += rILE."Importe Cons. Neto Inicial";
                    until rILE.Next = 0;

                rILE.Reset;
                rILE.SetCurrentKey("Posting Date", "Location Code");
                rILE.SetRange("Posting Date", CalcDate('-97D', FechaDesde), CalcDate('-61D', FechaDesde));
                rILE.SetRange("Location Code", "No.");
                //rILE.SETFILTER("Cant. Consignacion Pendiente",'>%1',0);

                if rILE.FindSet then
                    repeat
                        w61a90 += rILE."Importe Cons. Neto Inicial";
                    until rILE.Next = 0;

                rILE.Reset;
                rILE.SetCurrentKey("Posting Date", "Location Code");
                rILE.SetRange("Posting Date", 0D, CalcDate('-98D', FechaDesde));
                rILE.SetRange("Location Code", "No.");
                //rILE.SETFILTER("Cant. Consignacion Pendiente",'>%1',0);

                if rILE.FindSet then
                    repeat
                        w91enAde += rILE."Importe Cons. Neto Inicial";
                    until rILE.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Date Filter", 0D, FechaDesde);
                //CurrReport.CreateTotals(w0a30, w31a60, w61a90, w91enAde);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Fecha Desde"; FechaDesde)
                {
                ApplicationArea = All;
                }
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

    trigger OnPreReport()
    begin
        Filtros := Customer.GetFilters;
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
        CustomerCaptionLbl: Label 'Customer';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        V31_a_60CaptionLbl: Label '31 a 60';
        V0_a_30_diasCaptionLbl: Label '0 a 30 dias';
        V61_a_97CaptionLbl: Label '61 a 97';
        V98_en_adelanteCaptionLbl: Label '98 en adelante';
        TotalCaptionLbl: Label 'Total';
}

