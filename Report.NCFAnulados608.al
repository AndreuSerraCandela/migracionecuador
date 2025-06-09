report 76080 "NCF Anulados (608)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './NCFAnulados608.rdlc';

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "Posting Date";
            column(NCFRelacionado; ArchITBIS."NCF Relacionado")
            {
            }
            column(FechaRegistro; "Sales Cr.Memo Header"."Posting Date")
            {
            }
            column(RazonAnulNCF; "Sales Cr.Memo Header"."Razon anulacion NCF")
            {
            }
            column(NoNCF; "Sales Cr.Memo Header"."No.")
            {
            }
            column(NoFactura; NoF)
            {
            }
            column(DirEmpresa1; DirEmpresa[1])
            {
            }
            column(DirEmpresa2; DirEmpresa[2])
            {
            }
            column(DirEmpresa3; DirEmpresa[3])
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(SIH);
                Clear(NoF);
                //jpg 27/07/2020 ++

                //para excluir las que tiene corregida.
                SIH.Reset;
                SIH.SetRange("Applies-to Doc. No.", "No.");
                SIH.SetRange(Correction, true);
                SIH.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                if SIH.FindFirst then
                    CurrReport.Skip;



                //busca no. factura
                SIH.Reset;
                SIH.SetRange("No. Comprobante Fiscal", "No. Comprobante Fiscal Rel.");
                SIH.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                if SIH.FindFirst then
                    NoF := SIH."No.";

                if NoF = '' then begin
                    ServiceInvoiceHeader.Reset;
                    ServiceInvoiceHeader.SetRange("No. Comprobante Fiscal", "No. Comprobante Fiscal Rel.");
                    ServiceInvoiceHeader.SetRange("Bill-to Customer No.", "Sell-to Customer No.");
                    if ServiceInvoiceHeader.FindFirst then
                        NoF := ServiceInvoiceHeader."No.";
                end;



                //jpg 27/07/2020 ++


                ArchITBIS.Init;
                ArchITBIS."Fecha Documento" := Format("Posting Date", 0, '<year4>') + Format("Posting Date", 0, '<Month,2>') +
                                                Format("Posting Date", 0, '<day,2>');
                //ArchITBIS."Clasific. Gastos y Costos NCF" := "Razon anulacion NCF";
                //secuencia para insertar en ArchITBIS
                Seq := Seq + 1;

                ArchITBIS."No. Mov." := Seq;

                //De los NCF relacionados buscamos el del importe mayor
                //Buscamos el mov. cliente perteneciente al abono.


                if not Correction then begin  // si no es tipo correctiva validar que sea eliminada con ncf

                    if "No. Comprobante Fiscal" = '' then
                        CurrReport.Skip;

                    CalcFields("Amount Including VAT");
                    if "Amount Including VAT" <> 0 then
                        CurrReport.Skip;

                    SalesCrMemoLine.Reset;
                    SalesCrMemoLine.SetRange("Document No.", "No.");
                    SalesCrMemoLine.SetRange(Description, 'Deleted Document');
                    if not SalesCrMemoLine.FindFirst then
                        CurrReport.Skip;



                    ArchITBIS."NCF Relacionado" := "No. Comprobante Fiscal";

                end
                else begin
                    NCFLiq.Reset;
                    if NCFLiq.FindSet then
                        NCFLiq.DeleteAll;

                    CalcFields("Amount Including VAT");
                    if "Amount Including VAT" = 0 then // si es correctiva pero se borro no incluir en 608 el ncf rel
                      begin
                        SalesCrMemoLine.Reset;
                        SalesCrMemoLine.SetRange("Document No.", "No.");
                        SalesCrMemoLine.SetRange(Description, 'Deleted Document');
                        if not SalesCrMemoLine.FindFirst then
                            CurrReport.Skip;
                    end;

                    if "No. Comprobante Fiscal Rel." <> '' then //jpg 22/02/2021 para colocar "No. Comprobante Fiscal Rel." si no buscarlo  ++
                      begin

                        NCFLiq.NCF := "No. Comprobante Fiscal Rel.";
                        if not NCFLiq.Insert then
                            NCFLiq.Modify;
                    end
                    else begin //jpg 22/02/2021 para colocar "No. Comprobante Fiscal Rel." si no buscarlo  --

                        CLE.Reset;
                        CLE.SetCurrentKey("Customer No.", "Posting Date", "Document Type", "Document No.");
                        CLE.SetRange("Customer No.", "Sell-to Customer No.");
                        CLE.SetRange("Posting Date", "Posting Date");
                        CLE.SetRange("Document Type", 3);
                        CLE.SetRange("Document No.", "No.");
                        if CLE.FindFirst then begin
                            //Buscamos los movimientos que la cerraron
                            if CLE."Closed by Entry No." <> 0 then begin
                                if CLECopy.Get(CLE."Closed by Entry No.") then begin
                                    //Buscamos el historico de factura para capturar el NCF
                                    if SIH.Get(CLECopy."Document No.") then begin
                                        NCFLiq.NCF := SIH."No. Comprobante Fiscal";
                                        if not NCFLiq.Insert then
                                            NCFLiq.Modify;
                                    end;
                                end;
                            end;

                            if ArchITBIS."NCF Relacionado" = '' then begin
                                //Buscamos movimientos cerrados por ella
                                CLECopy.Reset;
                                CLECopy.SetCurrentKey("Closed by Entry No.");
                                CLECopy.SetRange("Closed by Entry No.", CLE."Entry No.");
                                if CLECopy.FindSet() then
                                    repeat
                                        //Buscamos el historico de factura para capturar el NCF
                                        if SIH.Get(CLECopy."Document No.") then begin
                                            NCFLiq.NCF := SIH."No. Comprobante Fiscal";
                                            if not NCFLiq.Insert then
                                                NCFLiq.Modify;
                                        end;
                                    until CLECopy.Next = 0;
                            end;
                        end;
                    end;

                    NCFLiq.SetCurrentKey(NCFLiq.NCF);
                    if NCFLiq.FindLast then
                        ArchITBIS."NCF Relacionado" := NCFLiq.NCF;

                end;

                //jpg 22/02/2021 si no encontro ncf no insertar ++
                if ArchITBIS."NCF Relacionado" = '' then
                    CurrReport.Skip;
                //jpg 22/02/2021 si no encontro ncf no insertar --


                ArchITBIS."Número Documento" := "No.";
                ArchITBIS."Codigo reporte" := '608';
                ArchITBIS."Razón Social" := DelChr(CopyStr("Bill-to Name", 1, 60), '=', ',');
                ArchITBIS."Cod. Proveedor" := "Bill-to Customer No.";
                ArchITBIS."Nombre Comercial" := ArchITBIS."Razón Social";
                RNCTxt := DelChr("VAT Registration No.", '=', '- ');
                if StrLen(RNCTxt) < 10 then
                    ArchITBIS.RNC := RNCTxt
                else
                    ArchITBIS.Cédula := CopyStr(RNCTxt, 1, 11);

                if ArchITBIS.RNC <> '' then begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC;
                    ArchITBIS."Tipo Identificacion" := 1;
                end
                else begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;
                    ArchITBIS."Tipo Identificacion" := 2;
                end;

                ArchITBIS."Razon Anulacion" := "Sales Cr.Memo Header"."Razon anulacion NCF";
                if ArchITBIS."Razon Anulacion" = '' then
                    ArchITBIS."Razon Anulacion" := '04';

                NumeroLinea += 1;
                ArchITBIS."Line No." := NumeroLinea;

                if not ArchITBIS.Insert then
                    Error(Error001);
            end;
        }
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            CalcFields = "Amount Including VAT";
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "Posting Date";
            column(NCFRelacionadoF; ArchITBIS."NCF Relacionado")
            {
            }
            column(FechaRegistroF; "Posting Date")
            {
            }
            column(RazonAnulNCFF; ArchITBIS."Razon Anulacion")
            {
            }
            column(NoNCFF; SCH."No.")
            {
            }
            column(NoFacturaF; "No.")
            {
            }
            column(DirEmpresa1F; DirEmpresa[1])
            {
            }
            column(DirEmpresa2F; DirEmpresa[2])
            {
            }
            column(DirEmpresa3F; DirEmpresa[3])
            {
            }

            trigger OnAfterGetRecord()
            begin

                SCH.Reset;
                SCH.SetRange("No. Comprobante Fiscal Rel.", "No. Comprobante Fiscal");
                SCH.SetRange(Correction, true);
                SCH.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                if SCH.FindFirst then
                    CurrReport.Skip;


                ArchITBIS.Init;
                ArchITBIS."Fecha Documento" := Format("Posting Date", 0, '<year4>') + Format("Posting Date", 0, '<Month,2>') +
                                                Format("Posting Date", 0, '<day,2>');
                //ArchITBIS."Clasific. Gastos y Costos NCF" := '05';

                //secuencia para insertar en ArchITBIS
                Seq := Seq + 1;

                ArchITBIS."No. Mov." := Seq;

                if not Correction then begin  // si no es tipo correctiva validar que sea eliminada con ncf
                    CalcFields("Amount Including VAT");
                    if "Amount Including VAT" <> 0 then
                        CurrReport.Skip;

                    SalesInvoiceLine.Reset;
                    SalesInvoiceLine.SetRange("Document No.", "No.");
                    SalesInvoiceLine.SetRange(Description, 'Deleted Document');
                    if not SalesInvoiceLine.FindFirst then
                        CurrReport.Skip;

                    if "No. Comprobante Fiscal" = '' then
                        CurrReport.Skip;

                    ArchITBIS."NCF Relacionado" := "No. Comprobante Fiscal";

                end
                else begin

                    NCFLiq.Reset;
                    if NCFLiq.FindSet then
                        NCFLiq.DeleteAll;

                    if "No. Comprobante Fiscal Rel." <> '' then  // si tiene "No. Comprobante Fiscal Rel." tomar directo
                      begin

                        NCFLiq.NCF := "No. Comprobante Fiscal Rel.";
                        if not NCFLiq.Insert then
                            NCFLiq.Modify;

                        SCH.Reset;
                        SCH.SetRange("No. Comprobante Fiscal", "No. Comprobante Fiscal Rel.");
                        SCH.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                        if SCH.FindFirst then;

                    end
                    else begin

                        CLE.Reset;
                        CLE.SetCurrentKey("Customer No.", "Posting Date", "Document Type", "Document No.");
                        CLE.SetRange("Customer No.", "Sell-to Customer No.");
                        CLE.SetRange("Posting Date", "Posting Date");
                        CLE.SetRange("Document Type", 2);
                        CLE.SetRange("Document No.", "No.");
                        if CLE.FindFirst then begin
                            //Buscamos los movimientos que la cerraron
                            if CLE."Closed by Entry No." <> 0 then begin
                                if CLECopy.Get(CLE."Closed by Entry No.") then begin
                                    //Buscamos el historico de factura para capturar el NCF
                                    if SCH.Get(CLECopy."Document No.") then begin
                                        NCFLiq.NCF := SCH."No. Comprobante Fiscal";
                                        if not NCFLiq.Insert then
                                            NCFLiq.Modify;
                                    end;
                                end;
                            end;

                            if NCFLiq.NCF = '' then begin
                                //Buscamos movimientos cerrados por ella
                                CLECopy.Reset;
                                CLECopy.SetCurrentKey("Closed by Entry No.");
                                CLECopy.SetRange("Closed by Entry No.", CLE."Entry No.");
                                if CLECopy.FindSet() then
                                    repeat
                                        //Buscamos el historico de factura para capturar el NCF
                                        if SCH.Get(CLECopy."Document No.") then begin
                                            NCFLiq.NCF := SCH."No. Comprobante Fiscal";
                                            if not NCFLiq.Insert then
                                                NCFLiq.Modify;
                                        end;
                                    until CLECopy.Next = 0;
                            end;
                        end;
                    end;

                    NCFLiq.SetCurrentKey(NCFLiq.NCF);
                    if NCFLiq.FindLast then
                        ArchITBIS."NCF Relacionado" := NCFLiq.NCF;

                end;

                ArchITBIS."Número Documento" := "No.";
                ArchITBIS."Codigo reporte" := '608';
                ArchITBIS."Razón Social" := DelChr(CopyStr("Bill-to Name", 1, 60), '=', ',');
                ArchITBIS."Cod. Proveedor" := "Bill-to Customer No.";
                ArchITBIS."Nombre Comercial" := ArchITBIS."Razón Social";
                RNCTxt := DelChr("VAT Registration No.", '=', '- ');
                if StrLen(RNCTxt) < 10 then
                    ArchITBIS.RNC := RNCTxt
                else
                    ArchITBIS.Cédula := CopyStr(RNCTxt, 1, 11);

                if ArchITBIS.RNC <> '' then begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC;
                    ArchITBIS."Tipo Identificacion" := 1;
                end
                else begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;
                    ArchITBIS."Tipo Identificacion" := 2;
                end;

                //ArchITBIS."Razon Anulacion" := "Sales Cr.Memo Header"."Razon anulacion NCF";
                //IF ArchITBIS."Razon Anulacion" =  '' THEN
                ArchITBIS."Razon Anulacion" := '05';

                //jpg 22/02/2021 si no encontro ncf no insertar ++
                if ArchITBIS."NCF Relacionado" = '' then
                    CurrReport.Skip;
                //jpg 22/02/2021 si no encontro ncf no insertar --

                NumeroLinea += 1;
                ArchITBIS."Line No." := NumeroLinea;

                if not ArchITBIS.Insert then
                    Error(Error001);
            end;
        }
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending) WHERE(Correction = CONST(true), "No. Comprobante Fiscal Rel." = FILTER('B11*' | 'B13*'));
            RequestFilterFields = "Posting Date";
            column(NCFRelacionadoFC; ArchITBIS."NCF Relacionado")
            {
            }
            column(FechaRegistroFC; "Posting Date")
            {
            }
            column(RazonAnulNCFFC; ArchITBIS."Razon Anulacion")
            {
            }
            column(NoNCFFC; "No.")
            {
            }
            column(NoFacturaFC; PIH."No.")
            {
            }
            column(DirEmpresa1FC; DirEmpresa[1])
            {
            }
            column(DirEmpresa2FC; DirEmpresa[2])
            {
            }
            column(DirEmpresa3FC; DirEmpresa[3])
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(PIH);
                Clear(NoFC);
                Clear(ArchITBIS);

                //para excluir las que tiene corregida.
                PIH.Reset;
                PIH.SetRange("Applies-to Doc. No.", "No.");
                PIH.SetRange(Correction, true);
                PIH.SetRange("Buy-from Vendor No.", "Buy-from Vendor No.");
                if PIH.FindFirst then
                    CurrReport.Skip;



                //busca no. factura
                PIH.Reset;
                PIH.SetRange("No. Comprobante Fiscal", "No. Comprobante Fiscal Rel.");
                PIH.SetRange("Buy-from Vendor No.", "Buy-from Vendor No.");
                if PIH.FindFirst then
                    NoFC := PIH."No.";


                ArchITBIS.Init;
                ArchITBIS."Fecha Documento" := Format("Posting Date", 0, '<year4>') + Format("Posting Date", 0, '<Month,2>') +
                                                Format("Posting Date", 0, '<day,2>');
                //ArchITBIS."Clasific. Gastos y Costos NCF" := "Cod. Clasificacion Gasto";

                //secuencia para insertar en ArchITBIS
                Seq := Seq + 1;

                ArchITBIS."No. Mov." := Seq;

                //De los NCF relacionados buscamos el del importe mayor
                //Buscamos el mov. cliente perteneciente al abono.



                ArchITBIS."NCF Relacionado" := "No. Comprobante Fiscal Rel.";


                //jpg 22/02/2021 si no encontro ncf no insertar ++
                if ArchITBIS."NCF Relacionado" = '' then
                    CurrReport.Skip;
                //jpg 22/02/2021 si no encontro ncf no insertar --


                ArchITBIS."Número Documento" := "No.";
                ArchITBIS."Codigo reporte" := '608';
                ArchITBIS."Cod. Proveedor" := "Buy-from Vendor No.";
                ArchITBIS."Razón Social" := DelChr(CopyStr("Buy-from Vendor Name", 1, 60), '=', ',');
                ArchITBIS."Nombre Comercial" := ArchITBIS."Razón Social";
                RNCTxt := DelChr("VAT Registration No.", '=', '- ');
                if StrLen(RNCTxt) < 10 then
                    ArchITBIS.RNC := RNCTxt
                else
                    ArchITBIS.Cédula := CopyStr(RNCTxt, 1, 11);

                if ArchITBIS.RNC <> '' then begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.RNC;
                    ArchITBIS."Tipo Identificacion" := 1;
                end
                else begin
                    ArchITBIS."RNC/Cedula" := ArchITBIS.Cédula;
                    ArchITBIS."Tipo Identificacion" := 2;
                end;

                //ArchITBIS."Razon Anulacion" := "Razon anulacion NCF";
                if ArchITBIS."Razon Anulacion" = '' then
                    ArchITBIS."Razon Anulacion" := '05';

                NumeroLinea += 1;
                ArchITBIS."Line No." := NumeroLinea;

                if not ArchITBIS.Insert then
                    Error(Error001);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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
        ArchITBIS.Reset;
        ArchITBIS.SetRange("Codigo reporte", '608');
        ArchITBIS.DeleteAll;

        NumeroLinea += 1;


        InfoEmpresa.Get;
        DirEmpresa[1] := InfoEmpresa.Name;
        DirEmpresa[2] := InfoEmpresa."Name 2";
        DirEmpresa[3] := InfoEmpresa.Address;
        DirEmpresa[4] := InfoEmpresa."Address 2";
        DirEmpresa[5] := InfoEmpresa.City;
        DirEmpresa[6] := InfoEmpresa."Post Code" + ' ' + InfoEmpresa.County;
        DirEmpresa[7] := txt001 + InfoEmpresa."VAT Registration No.";
        CompressArray(DirEmpresa);

        FiltrosSCMH := "Sales Cr.Memo Header".GetFilters;
        FiltrosPCMH := "Purch. Cr. Memo Hdr.".GetFilters;

        if "Sales Cr.Memo Header".GetFilter("Posting Date") = '' then
            Error(Error002, "Sales Cr.Memo Header".FieldCaption("Posting Date"));
    end;

    var
        ArchITBIS: Record "Archivo Transferencia ITBIS";
        NCFLiq: Record "NCF liquidados";
        CLE: Record "Cust. Ledger Entry";
        CLECopy: Record "Cust. Ledger Entry";
        SIH: Record "Sales Invoice Header";
        Error001: Label 'Ya existen registro similares en la tabla de archivo NCF, favor limpiarla';
        DirEmpresa: array[7] of Text[50];
        InfoEmpresa: Record "Company Information";
        FiltrosSCMH: Text[1024];
        txt001: Label 'RNC/Cédula ';
        txt002: Label 'Sales Invoice Header';
        txt003: Label 'Sales Cr.Memo Header';
        Error002: Label 'Filter Required for the field %1 of the table %2';
        Seq: Integer;
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        RNCTxt: Text[30];
        ServiceInvoiceHeader: Record "Service Invoice Header";
        NoF: Code[20];
        SCH: Record "Sales Cr.Memo Header";
        PIH: Record "Purch. Inv. Header";
        NoFC: Code[20];
        FiltrosPCMH: Text[1024];
        NCFRelacionadoFC: Text;
        NumeroLinea: Integer;
}

