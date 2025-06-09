report 56124 "Pagos Realizados Proveedores"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PagosRealizadosProveedores.rdlc';

    dataset
    {
        dataitem(Facturas; "Vendor Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.") ORDER(Ascending) WHERE("Document Type" = FILTER(Invoice), Open = FILTER(false));
            RequestFilterFields = "Posting Date", "Document No.";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(USERID; UserId)
            {
            }
            /*column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }*/
            column(vPais; vPais)
            {
            }
            column(rEmpresa_Address_________rEmpresa__Address_2_; CompanyInformation.Address + ' ' + CompanyInformation."Address 2")
            {
            }
            column(rEmpresa_Picture; CompanyInformation.Picture)
            {
            }
            column(Email______CompanyInformation__E_Mail_; 'Email: ' + CompanyInformation."E-Mail")
            {
            }
            column("Página_Web______CompanyInformation__Home_Page_"; 'Página Web: ' + CompanyInformation."Home Page")
            {
            }
            column(Fax_______rEmpresa__Fax_No__; 'Fax.: ' + CompanyInformation."Fax No.")
            {
            }
            column(Tel_______rEmpresa__Phone_No__; 'Tel.: ' + CompanyInformation."Phone No.")
            {
            }
            column(Facturas__Vendor_No__; "Vendor No.")
            {
            }
            column(Importe; Importe)
            {
            }
            column(NoFactura; NoFactura)
            {
            }
            column(FechaFactura; FechaFactura)
            {
            }
            column(Facturas_Description; Description)
            {
            }
            column(NoCheque; NoCheque)
            {
            }
            column(RazonGasto; RazonGasto)
            {
            }
            column(FechaCheque; FechaCheque)
            {
            }
            column(Importe_Control1000000001; Importe)
            {
            }
            column(Atencion; AtencionLbl)
            {
            }
            column(Page_No_Caption; Page_No_CaptionLbl)
            {
            }
            column(Seguimiento_de_ProductosCaption; Seguimiento_de_ProductosCaptionLbl)
            {
            }
            column(UM_Caption; UM_CaptionLbl)
            {
            }
            column(PrecioUnitCaption; PrecioUnitCaptionLbl)
            {
            }
            column(QuantityCaption; QuantityCaptionLbl)
            {
            }
            column(Envio; EnvioLbl)
            {
            }
            column(textoRegistro; textoRegistroLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(Item_CodeCaption; Item_CodeCaptionLbl)
            {
            }
            column(Total_Caption; Total_CaptionLbl)
            {
            }
            column(Facturas_Entry_No_; "Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                RazonGasto := '';
                Clear(FechaCheque);
                Clear(NoCheque);
                Clear(FechaFactura);
                Clear(NoFactura);

                if Open = false then begin
                    if "Closed by Entry No." = 0 then begin
                        //Buscamos los pagos cerrados por la factura
                        VLE.Reset;
                        VLE.SetRange("Document Type", VLE."Document Type"::Payment);
                        VLE.SetRange("Closed by Entry No.", Facturas."Entry No.");
                        if VLE.FindFirst then begin
                            VLE.CalcFields(VLE.Amount);
                            FechaCheque := VLE."Posting Date";
                            NoCheque := VLE."Document No.";
                            FechaFactura := "Posting Date";
                            NoFactura := "Document No.";
                            Importe := VLE.Amount * -1;
                            //Buscamos las lineas de la factura de compra para capturar la descripcion de las lineas tipo cuenta
                            /*
                            PIL.RESET;
                            PIL.SETRANGE("Document No.","Document No.");
                            PIL.SETRANGE(Type,PIL.Type::"G/L Account");
                            IF PIL.FINDSET THEN
                              REPEAT
                                IF (STRLEN(RazonGasto) + STRLEN(PIL.Description)) < 1024 THEN
                                  RazonGasto += PIL.Description + ', ';
                              UNTIL PIL.NEXT = 0;
                              */
                        end;
                    end
                    else
                      //Buscamos los pagos en el que el cerrado lo tiene la factura
                      begin
                        if VLE.Get("Closed by Entry No.") then begin
                            if VLE."Document Type" = VLE."Document Type"::Payment then begin
                                VLE.CalcFields(VLE.Amount);
                                FechaFactura := "Posting Date";
                                NoFactura := "Document No.";
                                FechaCheque := VLE."Posting Date";
                                NoCheque := VLE."Document No.";
                                Importe := VLE.Amount * -1;
                                //                TipoDoc := VLE."Document Type";

                                //Buscamos las lineas de la factura de compra para capturar la descripcion de las lineas tipo cuenta
                                /*
                                PIL.RESET;
                                PIL.SETRANGE("Document No.","Document No.");
                                PIL.SETRANGE(Type,PIL.Type::"G/L Account");
                                IF PIL.FINDSET THEN
                                  REPEAT
                                    IF (STRLEN(RazonGasto) + STRLEN(PIL.Description)) < 1024 THEN
                                      RazonGasto += PIL.Description + ', ';
                                  UNTIL PIL.NEXT = 0;
                                  */
                            end;
                        end;
                    end;
                end;

            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.CreateTotals(Importe);
            end;
        }
    }

    requestpage
    {

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
        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);

        rPais.SetRange(Code, CompanyInformation."Country/Region Code");
        rPais.FindFirst;
        vPais := CompanyInformation.City + ', ' + rPais.Name + ' ' + CompanyInformation."Post Code";
    end;

    var
        VLE: Record "Vendor Ledger Entry";
        PIL: Record "Purch. Inv. Line";
        CompanyInformation: Record "Company Information";
        rPais: Record "Country/Region";
        FechaCheque: Date;
        NoCheque: Code[20];
        FechaFactura: Date;
        NoFactura: Code[20];
        RazonGasto: Text[1024];
        TipoDoc: Option;
        Importe: Decimal;
        vPais: Text[50];
        AtencionLbl: Label 'Account / Expense reason';
        Page_No_CaptionLbl: Label 'Page No.';
        Seguimiento_de_ProductosCaptionLbl: Label 'Purchase Order Analysis';
        UM_CaptionLbl: Label 'Amount paid';
        PrecioUnitCaptionLbl: Label 'Check no.';
        QuantityCaptionLbl: Label 'Check date';
        EnvioLbl: Label 'Invoice No.';
        textoRegistroLbl: Label 'Invoice Date';
        DescriptionCaptionLbl: Label 'Name';
        Item_CodeCaptionLbl: Label 'Vendor';
        Total_CaptionLbl: Label 'Total:';
}

