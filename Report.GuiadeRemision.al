report 55011 "Guia de Remision"
{
    // .
    DefaultLayout = RDLC;
    RDLCLayout = './GuiadeRemision.rdlc';

    Caption = 'Transfer Shipment';

    dataset
    {
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Transfer-from Code", "Transfer-to Code";
            RequestFilterHeading = 'Posted Transfer Shipment';
            column(Transfer_Shipment_Header_No_; "No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(STRSUBSTNO_Text001_CopyText_; StrSubstNo(Text001, CopyText))
                    {
                    }
                    /*column(CurrReport_PAGENO; StrSubstNo(Text002, Format(CurrReport.PageNo)))
                    {
                    }*/
                    column(External_Doc_no; "Transfer Shipment Header"."External Document No.")
                    {
                    }
                    column(TSH_Shipment_Date; "Transfer Shipment Header"."Shipment Date")
                    {
                    }
                    column(TSH_No; "Transfer Shipment Header"."No.")
                    {
                    }
                    column(TSH_Cod_Cliente; "Transfer Shipment Header"."Transfer-to Name")
                    {
                    }
                    column(PageCaption; StrSubstNo(Text002, ''))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(rEmpresa__Phone_No; 'TELEFONO: ' + rEmpresa."Phone No." + '    ' + 'FAX: ' + rEmpresa."Fax No.")
                    {
                    }
                    column(rEmpresa__VAT_Registration_No; 'R.U.C.: ' + rEmpresa."VAT Registration No.")
                    {
                    }
                    column(rEmpresa_Address; rEmpresa.Address + ', ' + rEmpresa.City + ', ' + rEmpresa.County)
                    {
                    }
                    column(rEmpresa_Name; rEmpresa.Name)
                    {
                    }
                    column(rEmpresa_Picture; rEmpresa.Picture)
                    {
                    }
                    column(Report_Title; Text003)
                    {
                    }
                    column(Vendedor; Vendedor)
                    {
                    }
                    column(Fecha_Hoy; Today)
                    {
                    }
                    column(Almacen; "Transfer Shipment Header"."Transfer-from Code")
                    {
                    }
                    column(TSH_Transfer_to_Code; "Transfer Shipment Header"."Transfer-to Code")
                    {
                    }
                    column(Cliente_Nam; Cliente)
                    {
                    }
                    column(Cliente_Add; Cliente_Add)
                    {
                    }
                    column(Cliente_VAT; Cliente_VAT)
                    {
                    }
                    column(Cliente_Cty; Cliente_Cty)
                    {
                    }
                    column(TSH_TransferOrderDAte; "Transfer Shipment Header"."Transfer Order Date")
                    {
                    }
                    column(TSH_FecRecep; "Transfer Shipment Header"."Receipt Date")
                    {
                    }
                    column(Transportista_Address; Transportista.Address)
                    {
                    }
                    column(ShippingAgentName; Transportista.Name)
                    {
                    }
                    column(ShippingAgentCode; Transportista.Code)
                    {
                    }
                    column(Tipo_Trans; Tipo_Trans)
                    {
                    }
                    column(Loc_Name; "Transfer Shipment Header"."Transfer-from Code" + ' - ' + "Transfer Shipment Header"."Transfer-from Name")
                    {
                    }
                    column(NPEDTRANS; 'Nº ped. transfer.:  ' + "Transfer Shipment Header"."Transfer Order No.")
                    {
                    }
                    column(Referencia; ReferenciaLbl)
                    {
                    }
                    column(No__Caption; No__CaptionLbl)
                    {
                    }
                    column(Customer_caption; Customer_captionLbl)
                    {
                    }
                    column(TSH_Date_Caption; TSH_Date_CaptionLbl)
                    {
                    }
                    column(Delegado___Caption; Delegado___CaptionLbl)
                    {
                    }
                    column(Destino_Caption; Destino_CaptionLbl)
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Transfer Shipment Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(ShowInternalInfo; ShowInternalInfo)
                        {
                        }
                        column(NoOfCopies; NoOfCopies)
                        {

                        }
                        column(TSL_Item_No; "Item No.")
                        {
                        }
                        column(TSL_Description; Description)
                        {
                        }
                        column(TSL_Quantity; Quantity)
                        {
                        }
                        column(Transfer_Shipment_Line__Transfer_Shipment_Line___Line_No__; "Transfer Shipment Line"."Line No.")
                        {
                        }
                        column(TotalCant; TotalCant)
                        {
                        }
                        column(TSL_Quantity_Caption; FieldCaption(Quantity))
                        {
                        }
                        column(TSL_Description_Caption; FieldCaption(Description))
                        {
                        }
                        column(TSL_Item_No__Caption; TSL_Item_No__CaptionLbl)
                        {
                        }
                        column(Total_Cant__Caption; Total_Cant__CaptionLbl)
                        {
                        }
                        column(Transfer_Shipment_Line_Document_No_; "Document No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            //PostedDocDim2.SETRANGE("Table ID",DATABASE::"Transfer Shipment Line");
                            //PostedDocDim2.SETRANGE("Document No.","Transfer Shipment Line"."Document No.");
                            //PostedDocDim2.SETRANGE("Line No.","Transfer Shipment Line"."Line No.");

                            TotalCant += Quantity;
                        end;

                        trigger OnPreDataItem()
                        begin
                            //CurrReport.CreateTotals(TotalCant);

                            MoreLines := Find('+');
                            while MoreLines and (Description = '') and ("Item No." = '') and (Quantity = 0) do
                                MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break;
                            SetRange("Line No.", 0, "Line No.");
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        /*IF SalesPerson.GET("Transfer Shipment Header"."Cod. Vendedor") THEN
                          Vendedor := FORMAT(SalesPerson.Code) + ' - ' + SalesPerson.Name;
                         */

                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := Text000;
                        //if IsServiceTier then
                        OutputNo += 1;
                    end;
                    //CurrReport.PageNo := 1;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := 1 + Abs(NoOfCopies);
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    //if IsServiceTier then
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //PostedDocDim1.SETRANGE("Table ID",DATABASE::"Transfer Shipment Header");
                //PostedDocDim1.SETRANGE("Document No.","Transfer Shipment Header"."No.");

                FormatAddr.TransferShptTransferFrom(TransferFromAddr, "Transfer Shipment Header");
                FormatAddr.TransferShptTransferTo(TransferToAddr, "Transfer Shipment Header");

                if not ShipmentMethod.Get("Shipment Method Code") then
                    ShipmentMethod.Init;

                if SalesPerson.Get("Cod. Vendedor") then
                    Vendedor := Format(SalesPerson.Code) + ' - ' + SalesPerson.Name;

                //IF Loc.GET() THEN;

                if Cust.Get("Transfer-to Code") then begin
                    Cliente := Cust."No." + ' - ' + Cust.Name;
                    Cliente_VAT := Cust."VAT Registration No.";
                    Cliente_Add := CopyStr(Cust.Address, 1, 50);
                    Cliente_Cty := Cust.City;
                    Tipo_Trans := 'Consignacion';
                end
                else
                    if Loc.Get("Transfer-to Code") then begin
                        Cliente := Loc.Code + ' - ' + Loc.Name;
                        Cliente_VAT := rEmpresa."VAT Registration No.";
                        Cliente_Add := CopyStr(Loc.Address, 1, 50);
                        Cliente_Cty := Loc.City;
                        Tipo_Trans := 'Transferencia';

                        //    CLEAR(Cust)
                    end;
                if Transportista.Get("Shipping Agent Code") then;
            end;

            trigger OnPreDataItem()
            begin
                rEmpresa.Get();
                rEmpresa.CalcFields(Picture);
                rPais.SetRange(Code, rEmpresa."Country/Region Code");
                rPais.FindFirst;
                vPais := rEmpresa.City + ', ' + rPais.Name + ' ' + rEmpresa."Post Code";
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
                        Caption = 'No. of Copies';
                        ApplicationArea = All;
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
                        ApplicationArea = All;
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
        Text001: Label 'Transfer Shipment %1';
        Text002: Label 'Page %1';
        ShipmentMethod: Record "Shipment Method";
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
        "//**DYN***": Integer;
        TotalCant: Decimal;
        rEmpresa: Record "Company Information";
        rPais: Record "Country/Region";
        vPais: Text[50];
        Text003: Label 'Transfer Shipment';
        SalesPerson: Record "Salesperson/Purchaser";
        Vendedor: Text[50];
        Cust: Record Customer;
        Loc: Record Location;
        Cliente: Text[250];
        Cliente_VAT: Text[30];
        Cliente_Add: Text[70];
        Cliente_Cty: Text[30];
        Transportista: Record "Shipping Agent";
        Tipo_Trans: Text[30];
        ReferenciaLbl: Label 'Reference: ';
        No__CaptionLbl: Label 'Nota Egreso:';
        Customer_captionLbl: Label 'Customer: ';
        TSH_Date_CaptionLbl: Label 'Date: ';
        Delegado___CaptionLbl: Label 'Delegado : ';
        Destino_CaptionLbl: Label 'Ship to: ';
        TSL_Item_No__CaptionLbl: Label 'CODIGO';
        Total_Cant__CaptionLbl: Label 'Total Cant.:';
}

