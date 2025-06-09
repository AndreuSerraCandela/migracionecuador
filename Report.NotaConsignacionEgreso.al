report 55008 "Nota Consignacion Egreso"
{
    // .
    DefaultLayout = RDLC;
    RDLCLayout = './NotaConsignacionEgreso.rdlc';

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
                    column(CompanyInformation_Picture; CompanyInformation.Picture)
                    {
                    }
                    column(TSH_Order_Date; Format("Transfer Shipment Header"."Transfer Order Date"))
                    {
                    }
                    column(TSH_Transfer_Shipment_Date; Format("Transfer Shipment Header"."Shipment Date"))
                    {
                    }
                    column(TSH_Receipt_Date; Format("Transfer Shipment Header"."Receipt Date"))
                    {
                    }
                    column(PageCaption; StrSubstNo(Text002, ''))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(Report_Title; UpperCase(Texto))
                    {
                    }
                    column(TSH_No; "Transfer Shipment Header"."No.")
                    {
                    }
                    column(USERID; UserId)
                    {
                    }
                    /*column(CurrReport_PAGENO; CurrReport.PageNo)
                    {
                    }*/
                    column(CompanyInformation_Address; CompanyInformation.Address + ', ' + CompanyInformation.City + ', ' + CompanyInformation.County)
                    {
                    }
                    column(rEmpresa__Phone_No; 'TELEFONO: ' + CompanyInformation."Phone No." + '    ' + 'FAX: ' + CompanyInformation."Fax No.")
                    {
                    }
                    column(CompanyInformation__VAT_Reg_RUC; 'R.U.C.: ' + CompanyInformation."VAT Registration No.")
                    {
                    }
                    column(CompanyInformation_Name; CompanyInformation.Name)
                    {
                    }
                    column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
                    {
                    }
                    column(Cust_No_Name; CodCliente)
                    {
                    }
                    column(Cust_Address; Direccion)
                    {
                    }
                    column(Cust__Phone_No; Telefono)
                    {
                    }
                    column(Cust_City; Provincia)
                    {
                    }
                    column(ICL_Comment; Comentario)
                    {
                    }
                    column(TransferFromCode; "Transfer Shipment Header"."Transfer-from Code" + ', ' + "Transfer Shipment Header"."Transfer-from Name")
                    {
                    }
                    column(PT_; "Transfer Shipment Header"."Transfer Order No.")
                    {
                    }
                    column(Vence_Caption; Vence_CaptionLbl)
                    {
                    }
                    column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                    {
                    }
                    column(No__Caption; No__CaptionLbl)
                    {
                    }
                    column(TSH_Date_Caption; TSH_Date_CaptionLbl)
                    {
                    }
                    column(Customer__Caption; Customer__CaptionLbl)
                    {
                    }
                    column(Address__Caption; Address__CaptionLbl)
                    {
                    }
                    column(Provincia_Caption; Provincia_CaptionLbl)
                    {
                    }
                    column(Telephone__Caption; Telephone__CaptionLbl)
                    {
                    }
                    column(Comments__Caption; Comments__CaptionLbl)
                    {
                    }
                    column(Plazo_Caption; Plazo_CaptionLbl)
                    {
                    }
                    column(Desde_Caption; Desde_CaptionLbl)
                    {
                    }
                    column(PT_Caption; PT_CaptionLbl)
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
                        column(TSL_Precio_Venta_Consig; "Transfer Shipment Line"."Precio Venta Consignacion")
                        {
                        }
                        column(Transfer_Shipment_Line__Transfer_Shipment_Line___Line_No__; "Transfer Shipment Line"."Line No.")
                        {
                        }
                        column(TSL_Desc_Consig; "Descuento % Consignacion")
                        {
                        }
                        column(TSL_Importe_Consig; "Transfer Shipment Line"."Importe Consignacion")
                        {
                        }
                        column(Autor_Name; Autor.Name)
                        {
                        }
                        column(ICR_Cross_Reference_No; ICR."Reference No.")
                        {
                        }
                        column(ShipmentMethod_Description; ShipmentMethod.Description)
                        {
                        }
                        column(TotCant; TotCant)
                        {
                        }
                        column(Total_Precio; TotalPrecio)
                        {
                        }
                        column(Item_No_Caption; Item_No_CaptionLbl)
                        {
                        }
                        column(Author_Caption; Author_CaptionLbl)
                        {
                        }
                        column(Product_Caption; Product_CaptionLbl)
                        {
                        }
                        column(BarCode_Caption; BarCode_CaptionLbl)
                        {
                        }
                        column(Qty_Caption; Qty_CaptionLbl)
                        {
                        }
                        column(Price_Caption; Price_CaptionLbl)
                        {
                        }
                        column(Disc_Caption; Disc_CaptionLbl)
                        {
                        }
                        column(Total_PriceCaption; Total_PriceCaptionLbl)
                        {
                        }
                        column(ShipmentMethod_DescriptionCaption; ShipmentMethod_DescriptionCaptionLbl)
                        {
                        }
                        column(Total_Fact_Caption; Total_Fact_CaptionLbl)
                        {
                        }
                        column(Total__Caption; Total__CaptionLbl)
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

                            // --------------------------------------- Codigo Dynasoft --------------------------------------------
                            if Item.Get("Item No.") then
                                if Autor.Get(Item.Autor) then;

                            //Codigo de Barra
                            ICR.Reset;
                            ICR.SetRange("Item No.", "Item No.");
                            ICR.SetRange("Unit of Measure", "Unit of Measure Code");
                            if ICR.FindFirst then;

                            TotCant += Quantity;  //DYN --------
                            TotalPrecio += "Importe Consignacion";  //DYN --------
                            // --------------------------------------- Codigo Dynasoft --------------------------------------------
                        end;

                        trigger OnPreDataItem()
                        begin
                            // --------------------------------------- Codigo Dynasoft --------------------------------------------
                            //CurrReport.CreateTotals(TotCant, TotalPrecio);  //DYN --------

                            // --------------------------------------- Codigo Dynasoft --------------------------------------------

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

                // --------------------------------------- Codigo Dynasoft --------------------------------------------
                if "Transfer Shipment Header"."Pedido Consignacion" and
                  not "Transfer Shipment Header"."Devolucion Consignacion" then
                    if Cust.Get("Transfer-to Code") then; //Cliente

                Clear(Comentario);
                ICL.SetRange("Document Type", ICL."Document Type"::"Posted Transfer Shipment");
                ICL.SetRange("No.", "No.");
                if ICL.FindFirst then
                    Comentario := ICL.Comment;
                //Cust.GET();

                // --------------------------------------- Codigo Dynasoft --------------------------------------------

                if "Transfer Shipment Header"."Pedido Consignacion" then begin
                    CodCliente := Cust."No." + ', ' + Cust.Name;
                    Direccion := Cust.Address;
                    Provincia := Cust.City;
                    Telefono := Cust."Phone No.";
                end
                else begin
                    CodCliente := "Transfer-to Code" + ', ' + "Transfer Shipment Header"."Transfer-to Name";
                    Direccion := "Transfer-to Address";
                    Provincia := "Transfer-to City";
                    Telefono := Cust."Phone No.";
                end;
            end;

            trigger OnPreDataItem()
            begin
                // --------------------------------------- Codigo Dynasoft --------------------------------------------
                CompanyInformation.Get();
                CompanyInformation.CalcFields(Picture);
                rPais.SetRange(Code, CompanyInformation."Country/Region Code");
                rPais.FindFirst;
                vPais := CompanyInformation.City + ', ' + rPais.Name + ' ' + CompanyInformation."Post Code";
                // --------------------------------------- Codigo Dynasoft --------------------------------------------
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
        "//DYN": Integer;
        CompanyInformation: Record "Company Information";
        Text005: Label 'Egreso Consignacion';
        rPais: Record "Country/Region";
        Cust: Record Customer;
        Item: Record Item;
        ICR: Record "Item Reference";
        Autor: Record Vendor;
        ICL: Record "Inventory Comment Line";
        vPais: Text[50];
        TotalPrecio: Decimal;
        TotCant: Decimal;
        Codigo: Text[40];
        Comentario: Text[80];
        Texto: Text[80];
        Text006: Label 'Egreso';
        CodCliente: Text[200];
        Direccion: Text[200];
        Provincia: Text[200];
        Telefono: Text[200];
        Vence_CaptionLbl: Label 'Due Date: ';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        No__CaptionLbl: Label 'Nota Egreso No.:';
        TSH_Date_CaptionLbl: Label 'Date: ';
        Customer__CaptionLbl: Label 'Customer: ';
        Address__CaptionLbl: Label 'Address: ';
        Provincia_CaptionLbl: Label 'Estate:';
        Telephone__CaptionLbl: Label 'Telephone: ';
        Comments__CaptionLbl: Label 'Comments: ';
        Plazo_CaptionLbl: Label 'Due by: ';
        Desde_CaptionLbl: Label 'Desde:';
        PT_CaptionLbl: Label 'Nº PT:';
        Item_No_CaptionLbl: Label 'Item No.';
        Author_CaptionLbl: Label 'Author';
        Product_CaptionLbl: Label 'Product';
        BarCode_CaptionLbl: Label 'Bar Code';
        Qty_CaptionLbl: Label 'Qty';
        Price_CaptionLbl: Label 'Price';
        Disc_CaptionLbl: Label 'Disc.';
        Total_PriceCaptionLbl: Label 'Total Price';
        ShipmentMethod_DescriptionCaptionLbl: Label 'Shipment Method';
        Total_Fact_CaptionLbl: Label 'Total Fact.:';
        Total__CaptionLbl: Label 'Total: ';
}

