report 55004 "Comprobante de Retencion."
{
    // MOI - 04/05/2015(#16268): Se crea el campo direccion y se añade al dataset.
    DefaultLayout = RDLC;
    RDLCLayout = './ComprobantedeRetencion.rdlc';

    Caption = 'Retention Receipt';

    dataset
    {
        dataitem("Historico Retencion Prov."; "Historico Retencion Prov.")
        {
            DataItemTableView = SORTING("Tipo documento", "No. documento", "Código Retención");
            RequestFilterFields = "No. documento", "Código Retención", "Fecha Registro";
            column(Fecha_Registro; "Fecha Registro")
            {
            }
            column(Fecha_Emision; FechaEmision)
            {
            }
            column(Tipo_Comprob_Vta; TipoCompVta)
            {
            }
            column(NombreProv; NombreProv)
            {
            }
            column(RUC; RUC)
            {
            }
            column(NCF; NCF)
            {
            }
            column(DirProv; DirProv)
            {
            }
            column(No_Comprob_Vta; NoCompVta)
            {
            }
            column(TipoDoc1; TipoDoc[1])
            {
            }
            column(TipoDoc2; TipoDoc[2])
            {
            }
            column(TipoDoc3; TipoDoc[3])
            {
            }
            column(TipoDoc4; TipoDoc[4])
            {
            }
            column(TipoDoc5; TipoDoc[5])
            {
            }
            column(TipoDoc6; TipoDoc[6])
            {
            }
            column(Serie1; Serie[1])
            {
            }
            column(Serie2; Serie[2])
            {
            }
            column(Serie3; Serie[3])
            {
            }
            column(Serie4; Serie[4])
            {
            }
            column(Serie5; Serie[5])
            {
            }
            column(Serie6; Serie[6])
            {
            }
            column(Correlativo1; Correlativo[1])
            {
            }
            column(Correlativo2; Correlativo[2])
            {
            }
            column(Correlativo3; Correlativo[3])
            {
            }
            column(Correlativo4; Correlativo[4])
            {
            }
            column(Correlativo5; Correlativo[5])
            {
            }
            column(Correlativo6; Correlativo[6])
            {
            }
            column(Fecha1; Fecha[1])
            {
            }
            column(Fecha2; Fecha[2])
            {
            }
            column(Fecha3; Fecha[3])
            {
            }
            column(Fecha4; Fecha[4])
            {
            }
            column(Fecha5; Fecha[5])
            {
            }
            column(Fecha6; Fecha[6])
            {
            }
            column(MontoPago1; MontoPago[1])
            {
            }
            column(MontoPago2; MontoPago[2])
            {
            }
            column(MontoPago3; MontoPago[3])
            {
            }
            column(MontoPago4; MontoPago[4])
            {
            }
            column(MontoPago5; MontoPago[5])
            {
            }
            column(MontoPago6; MontoPago[6])
            {
            }
            column(ImporteRetenido1; ImporteRetenido[1])
            {
            }
            column(ImporteRetenido2; ImporteRetenido[2])
            {
            }
            column(ImporteRetenido3; ImporteRetenido[3])
            {
            }
            column(ImporteRetenido4; ImporteRetenido[4])
            {
            }
            column(ImporteRetenido5; ImporteRetenido[5])
            {
            }
            column(ImporteRetenido6; ImporteRetenido[6])
            {
            }
            column(TipoCambio1; TipoCambio[1])
            {
                DecimalPlaces = 2 : 5;
            }
            column(TipoCambio2; TipoCambio[2])
            {
            }
            column(TipoCambio3; TipoCambio[3])
            {
            }
            column(TipoCambio4; TipoCambio[4])
            {
            }
            column(TipoCambio5; TipoCambio[5])
            {
            }
            column(TipoCambio6; TipoCambio[6])
            {
            }
            column(UPPERCASE_DescriptionLine_1_; UpperCase(DescriptionLine[1]) + '  ' + CurrName)
            {
            }
            column(ImpRetTotal; "Importe Retenido DL")
            {
            }
            column(Historico_Retencion_Prov__Tipo_documento; "Tipo documento")
            {
            }
            column(Historico_Retencion_Prov__No__documento; "No. documento")
            {
            }
            column("Historico_Retencion_Prov__Código_Retención"; "Código Retención")
            {
            }
            column(gtDireccion; gtDireccion)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ConfSant.Get;

                TextDia := Format("Fecha Registro", 0, ('<day,2>'));
                TextMes := Format("Fecha Registro", 0, ('<month,2>'));
                TextAno := Format("Fecha Registro", 0, ('<year4>'));

                Vendor.Get("Cód. Proveedor");
                NombreProv := Vendor.Name;
                RUC := Vendor."VAT Registration No.";
                SerieRet := CopyStr(NCF, 1, 3);
                ComprobanteRet := CopyStr(NCF, 5, 20);
                DirProv := Vendor.Address;

                PIH.Get("No. documento");
                NoCompVta := PIH.Establecimiento + '-' + PIH."Punto de Emision" + '-' + PIH."No. Comprobante Fiscal";

                SRI.SetRange("Tipo Registro", SRI."Tipo Registro"::"TIPOS COMPROBANTES AUTORIZADOS");
                SRI.SetRange(Code, PIH."Tipo de Comprobante");
                if SRI.FindFirst then
                    TipoCompVta := SRI.Description;


                //ChkTransMgt.FormatNoText(DescriptionLine, "Historico Retencion Prov."."Importe Retenido DL", 2058, '');

                GLSetUp.Get;
                CurrName := GLSetUp."Nombre Divisa Local";

                //documentos liquidados
                VLE.Reset;
                VLE.SetRange("Vendor No.", "Cód. Proveedor");
                VLE.SetRange("Posting Date", "Fecha Registro");
                VLE.SetRange("Document No.", "No. documento");
                VLE.FindFirst;
                DVLE.Reset;
                DVLE.SetRange("Applied Vend. Ledger Entry No.", VLE."Entry No.");
                DVLE.SetFilter(DVLE."Vendor Ledger Entry No.", '<>%1', VLE."Entry No.");
                if DVLE.FindSet then
                    repeat
                        N += 1;
                        VLE1.Get(DVLE."Vendor Ledger Entry No.");
                        TipoDoc[N] := VLE1."Document Type".AsInteger();

                        if VLE1."Document Type" = VLE1."Document Type"::Invoice then begin
                            PIH.Get(VLE1."Document No.");
                            Correlativo[N] := PIH."No. Comprobante Fiscal"
                        end;
                        if VLE1."Document Type" = VLE1."Document Type"::"Credit Memo" then begin
                            PCMH.Get(VLE1."Document No.");
                            Correlativo[N] := PCMH."No. Comprobante Fiscal";
                        end;

                        if VLE1."Document Type" = VLE1."Document Type"::" " then begin
                            Serie[N] := CopyStr(VLE1."External Document No.", 1, 3);
                            Correlativo[N] := CopyStr(VLE1."External Document No.", 5, 15)
                        end;
                        //Para los asientos iniciales
                        if TipoDoc[N] = 0 then begin
                            VLE1.CalcFields("Original Amt. (LCY)");
                            if VLE1."Original Amt. (LCY)" < 0 then
                                TipoDoc[N] := 2
                            else
                                TipoDoc[N] := 3;
                        end;


                        Fecha[N] := "Fecha Registro";
                        VLE1.CalcFields("Amount (LCY)");
                        MontoPago[N] := -1 * VLE1."Amount (LCY)";
                        ImporteRetenido[N] := DVLE."Amount (LCY)";
                    until DVLE.Next = 0;


                if not CurrReport.Preview then begin
                    "Fecha Impresion" := WorkDate;
                    NCF := NoNCF;
                    "No. autorizacion NCF" := NoAuto;
                    "Punto Emision" := PuntoEmision;
                    Establecimiento := Establ;
                    Modify;

                    RetDocReg.Reset;
                    RetDocReg.SetRange("Cód. Proveedor", "Cód. Proveedor");
                    RetDocReg.SetRange("Código Retención", "Código Retención");
                    RetDocReg.SetRange("No. documento", "No. documento");
                    //RetDocReg.SETRANGE(NCF,NCF);
                    RetDocReg.FindFirst;
                    RetDocReg."Fecha Impresion" := WorkDate;
                end;
                //MOI - 04/05/2015(#16268):Inicio
                gtDireccion := NoSeriesLin.getDireccionSucursal("Historico Retencion Prov."."No. serie NCF", "Historico Retencion Prov."."Fecha Registro");
                //MOI - 04/05/2015(#16268):Fin
            end;

            trigger OnPreDataItem()
            begin

                if NoAuto = '' then
                    Error(Error001);

                if PuntoEmision = '' then
                    Error(Error002);

                if Establ = '' then
                    Error(Error003);

                if NoNCF = '' then
                    Error(Error004);

                HistRetProv.Reset;
                HistRetProv.SetRange(NCF, NoNCF);
                HistRetProv.SetRange("No. autorizacion NCF", NoAuto);
                if HistRetProv.FindFirst then
                    Error(Error005, HistRetProv."No. documento");
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
                field(NoAuto; NoAuto)
                {
                    ApplicationArea = All;
                    Caption = 'No. Autorización';
                }
                field(PuntoEmision; PuntoEmision)
                {
                    ApplicationArea = All;
                    Caption = 'Punto Emisión';
                }
                field(Establ; Establ)
                {
                    ApplicationArea = All;
                    Caption = 'Establecimiento';
                }
                field(NoNCF; NoNCF)
                {
                    ApplicationArea = All;
                    Caption = 'No. Comprobante';

                    trigger OnValidate()
                    begin
                        NoSeriesLin.Reset;
                        NoSeriesLin.SetRange("No. Autorizacion", NoAuto);
                        NoSeriesLin.SetRange("Punto de Emision", PuntoEmision);
                        NoSeriesLin.SetRange(Establecimiento, Establ);
                        NoSeriesLin.FindFirst;
                    end;
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
        NombreProv: Text[200];
        RUC: Text[30];
        TextDia: Text[30];
        TextMes: Text[30];
        TextAno: Text[30];
        Vendor: Record Vendor;
        //ChkTransMgt: Report "Check Translation Management";
        DescriptionLine: array[2] of Text[250];
        CurrName: Text[200];
        GLSetUp: Record "General Ledger Setup";
        TipoDoc: array[6] of Option " ",Pago,Factura,"Nota crédito","Docs. interés",Recordatorio,Reembolso;
        Serie: array[6] of Code[4];
        Correlativo: array[6] of Code[30];
        Fecha: array[6] of Date;
        MontoPago: array[6] of Decimal;
        ImporteRetenido: array[6] of Decimal;
        N: Integer;
        VLE: Record "Vendor Ledger Entry";
        VLE1: Record "Vendor Ledger Entry";
        SerieRet: Code[30];
        ComprobanteRet: Code[30];
        PIH: Record "Purch. Inv. Header";
        PCMH: Record "Purch. Cr. Memo Hdr.";
        DVLE: Record "Detailed Vendor Ledg. Entry";
        ConfSant: Record "Config. Empresa";
        TipoCambio: array[6] of Decimal;
        CurrExRate: Record "Currency Exchange Rate";
        RetDocReg: Record "Retencion Doc. Reg. Prov.";
        CodSerie: Code[20];
        NoSerie: Record "No. Series";
        DirProv: Text[100];
        FechaEmision: Date;
        TipoCompVta: Text[100];
        NoCompVta: Text[100];
        NoAuto: Code[30];
        PuntoEmision: Code[3];
        Establ: Code[3];
        NoNCF: Code[10];
        NoSeriesLin: Record "No. Series Line";
        Error001: Label 'Debe indicar No. de Autorización';
        Error002: Label 'Debe Indicar Punto de Emisión';
        Error003: Label 'Debe Indicar Establecimiento';
        Error004: Label 'Dede indicar No. Comprobante Fiscal';
        HistRetProv: Record "Historico Retencion Prov.";
        Error005: Label 'El No. de Comprobante ya existe en el Hist. de Retención, del documento %1';
        SRI: Record "SRI - Tabla Parametros";
        gtDireccion: Text[50];
}

