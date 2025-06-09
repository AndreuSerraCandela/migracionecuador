report 76007 "Notificacion retencion"
{
    RDLCLayout = './Notificacionretencion.rdlc';
    WordLayout = './Notificacionretencion.docx';
    Caption = 'Notification of Withholdings';
    DefaultLayout = Word;

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemTableView = SORTING("Vendor No.", "Posting Date", "Currency Code") WHERE("Document Type" = CONST(Invoice));
            RequestFilterFields = "Posting Date", "Vendor No.", "Vendor Posting Group";
            column(Vendor_No_; "Vendor No.")
            {
            }
            column(Full_Name; Vendor.Name)
            {
            }
            column(RNC; Vendor."VAT Registration No.")
            {
            }
            column(Document_No_; "Document No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Concepto_; Concepto)
            {
            }
            column(Currency_Code; "Currency Code")
            {
            }
            column(Amount; Format(Amount, 0, '<Integer Thousand><Decimals,3>'))
            {
            }
            column(Dia; Format(Today, 0, '<Day,2>'))
            {
            }
            column(Nombre_Dia; NombreDia)
            {
            }
            column(Nombre_Mes; NombreMes)
            {
            }
            column(Mes_Actual; MesActual)
            {
            }
            column(Nombre_Ano; Format(Today, 0, '<Year4>'))
            {
            }
            column(Importe_Texto; ImporteTexto[1])
            {
            }
            column(Nombre_Empresa; Company.Name)
            {
            }
            column(RNC_Empresa; Company."VAT Registration No.")
            {
            }
            column(TituloRet1; TituloRet[1])
            {
            }
            column(TituloRet2; TituloRet[2])
            {
            }

            trigger OnAfterGetRecord()
            begin
                Vendor.Get("Vendor No.");

                if PrimeraVez then begin
                    ProvRet.Reset;
                    ProvRet.SetRange("Cód. Proveedor", "Vendor No.");
                    if ProvRet.FindSet then
                        repeat
                            i += 1;
                            ConfRet.Get(ProvRet."Código Retención");
                            TituloRet[i] := ConfRet.Descripción;
                            CodRet[i] := ProvRet."Código Retención";
                        until ProvRet.Next = 0;
                    PrimeraVez := false;
                end;

                case Format("Posting Date", 0, '<Month,2>') of
                    '01':
                        NombreMes := 'Enero';
                    '02':
                        NombreMes := 'Febrero';
                    '03':
                        NombreMes := 'Marzo';
                    '04':
                        NombreMes := 'Abril';
                    '05':
                        NombreMes := 'Mayo';
                    '06':
                        NombreMes := 'Junio';
                    '07':
                        NombreMes := 'Julio';
                    '08':
                        NombreMes := 'Agosto';
                    '09':
                        NombreMes := 'Septiembre';
                    '10':
                        NombreMes := 'Octubre';
                    '11':
                        NombreMes := 'Noviembre';
                    else
                        NombreMes := 'Diciembre';
                end;

                PurchInvHdr.Get("Document No.");
                PurchInvHdr.CalcFields(Amount, "Amount Including VAT");
                Amt := PurchInvHdr.Amount;
                MontoITBIS := PurchInvHdr."Amount Including VAT" - PurchInvHdr.Amount;
                TotFact += Amt;
                TotalITBIS += MontoITBIS;


                TempDetRet.Init;

                HistRet.Reset;
                HistRet.SetRange("No. documento", "Document No.");
                HistRet.SetRange("Tipo documento", HistRet."Tipo documento"::Invoice);
                HistRet.SetRange("Cód. Proveedor", "Vendor No.");
                if HistRet.FindSet then
                    repeat
                        /*
                         TempHistRet.TRANSFERFIELDS(HistRet);
                        TempHistRet."No. documento" := "No. Comprobante Fiscal";
                        TempHistRet.INSERT;
                        */

                        //fes mig
                        /*
                            TempDetRet."No. documento" := "No. Comprobante Fiscal";
                            TempDetRet."Fecha anulacion" := Amt;
                            TempDetRet."VAT Amount" := MontoITBIS;
                            TempDetRet."Tipo Documento" := PurchInvHdr."Posting Date";
                            IF HistRet."Código Retención" = CodRet[1] THEN
                                BEGIN
                                TempDetRet."Amount 10" := HistRet."Importe Retenido";
                                TotRet1 += TempDetRet."Amount 10";
                               END
                            ELSE
                               BEGIN
                                TempDetRet."Amount 30" := HistRet."Importe Retenido";
                                TotRet2 += TempDetRet."Amount 30";
                               END;
                        */
                        //fes mig
                        if TempDetRet.Insert then
                            Contador += 1
                        else
                            TempDetRet.Modify;

                    until HistRet.Next = 0;


                case Format(WorkDate, 0, '<Month,2>') of
                    '01':
                        MesActual := 'Enero';
                    '02':
                        MesActual := 'Febrero';
                    '03':
                        MesActual := 'Marzo';
                    '04':
                        MesActual := 'Abril';
                    '05':
                        MesActual := 'Mayo';
                    '06':
                        MesActual := 'Junio';
                    '07':
                        MesActual := 'Julio';
                    '08':
                        MesActual := 'Agosto';
                    '09':
                        MesActual := 'Septiembre';
                    '10':
                        MesActual := 'Octubre';
                    '11':
                        MesActual := 'Noviembre';
                    else
                        MesActual := 'Diciembre';
                end;

            end;

            // trigger OnPostDataItem()
            // begin
            //     ChkTransMgt.FormatNoText(ImporteTexto, Amount, 2058, '');
            // end;

            trigger OnPreDataItem()
            begin
                TempHistRet.DeleteAll;
                Clear(TituloRet);
                Clear(CodRet);
                i := 0;
                TotRet1 := 0;
                TotRet2 := 0;

                Company.Get();
                PrimeraVez := true;
                //CurrReport.CreateTotals(Amount);
            end;
        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number);
            column(Importe_; TempDetRet."Fecha anulacion")
            {
            }
            column(Fecha_documento; Format(TempDetRet."Tipo Documento", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(Importe_ITBIS; TempDetRet."No. documento")
            {
            }
            column(NCF; TempDetRet."No. documento")
            {
            }
            column(Ret_Importe_Retenido1; TempDetRet."No. documento")
            {
            }
            column(Ret_Importe_Retenido2; TempDetRet."No. documento")
            {
            }
            column(TotalRetencion1; TotRet1)
            {
            }
            column(TotalRetencion2; TotRet2)
            {
            }
            column(Total_Facturas; TotFact)
            {
            }
            column(Total_ITBIS; TotalITBIS)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    TempDetRet.FindSet
                else
                    TempDetRet.Next;

                //CRP.GET(TempdetRet."Código Retención");
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, Contador);
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

    var
        Vendor: Record Vendor;
        VLE: Record "Vendor Ledger Entry";
        PurchInvHdr: Record "Purch. Inv. Header";
        HistRet: Record "Historico Retencion Prov.";
        TempHistRet: Record "Historico Retencion Prov." temporary;
        //ChkTransMgt: Report "Check Translation Management";
        CRP: Record "Config. Retencion Proveedores";
        Company: Record "Company Information";
        ProvRet: Record "Proveedor - Retencion";
        ConfRet: Record "Config. Retencion Proveedores";
        TempDetRet: Record "NCF Anulados" temporary;
        NombreDia: Text[30];
        NombreMes: Text[30];
        ImporteTexto: array[2] of Text[1024];
        Concepto: Text[1024];
        Desc: Integer;
        PrimeraVez: Boolean;
        Contador: Integer;
        ImporteRet: Decimal;
        TituloRet: array[3] of Text[150];
        CodRet: array[3] of Code[20];
        i: Integer;
        TotRet1: Decimal;
        TotRet2: Decimal;
        Amt: Decimal;
        TotFact: Decimal;
        MontoITBIS: Decimal;
        TotalITBIS: Decimal;
        MesActual: Text[30];
}

