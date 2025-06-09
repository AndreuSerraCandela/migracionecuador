report 55009 "Comprobante de Retencion"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ComprobantedeRetencion.55009.rdlc';
    Caption = 'Retention Receipt';
    UseRequestPage = true;

    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(Tipo_Comprob_Vta; TipoCompVta)
            {
            }
            column(No_Comprob_Vta; NoCompVta)
            {
            }
            column(Fecha_Emision; Format("Posting Date"))
            {
            }
            column(NCF; NoNCF)
            {
            }
            column(NombreProv; Vendor.Name)
            {
            }
            column(RUC; Vendor."VAT Registration No.")
            {
            }
            column(DirProv; Vendor.Address)
            {
            }
            column(Fecha_Registro; Format("Posting Date"))
            {
            }
            column(NoFactura; "No.")
            {
            }
            dataitem("Historico Retencion Prov."; "Historico Retencion Prov.")
            {
                DataItemLink = "No. documento" = FIELD("No.");
                DataItemTableView = SORTING("Tipo documento", "No. documento", "Código Retención") ORDER(Ascending);
                RequestFilterFields = "Cta. Contable";
                column(AnoFiscal; AnoFiscal)
                {
                }
                column(BaseRet; BaseRet)
                {
                }
                column(Impuesto; Impuesto)
                {
                }
                column(PCTRet; PCTRet)
                {
                }
                column(ImpRet; ImpRet)
                {
                }
                column(UPPERCASE_DescriptionLine_1_; UpperCase(DescriptionLine[1]) + '  ' + CurrName)
                {
                }
                column(ImpRetTotal; ImpRet)
                {
                }
                column(Comentario; Comentario)
                {
                }
                column(TOTAL_RETENIDOCaption; TOTAL_RETENIDOCaptionLbl)
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

                trigger OnAfterGetRecord()
                begin
                    N += 1;

                    if not CurrReport.Preview then begin
                        if (NCF <> '') and (Confirmado = false) then begin
                            if not Confirm(Error007, false, "Purch. Inv. Header"."No.", NCF, NoNCF) then
                                exit
                            else begin
                                Confirmado := true;
                                NCFAnulado.Init;
                                NCFAnulado."No. documento" := "No. documento";
                                NCFAnulado."Tipo Documento" := NCFAnulado."Tipo Documento"::Retencion;
                                NCFAnulado."No. Comprobante Fiscal" := NCF;
                                NCFAnulado."Fecha anulacion" := WorkDate;
                                NCFAnulado."No. Autorizacion" := "No. autorizacion NCF";
                                NCFAnulado."Punto Emision" := "Punto Emision";
                                NCFAnulado.Establecimiento := Establecimiento;
                                NCFAnulado.Insert;
                            end;
                        end;

                        NCF := NoNCF;
                        "No. autorizacion NCF" := NoAuto;
                        "Punto Emision" := PuntoEmision;
                        Establecimiento := Establ;
                        "Fecha Impresion" := WorkDate;
                        Modify;
                    end;

                    if not (N > 10) then begin
                        AnoFiscal := Format("Fecha Registro", 0, ('<year4>'));
                        BaseRet := "Historico Retencion Prov."."Importe Base Retencion";
                        ConfRet.Get("Código Retención");
                        Impuesto := ConfRet."Código Retención" + ' ' + ConfRet.Descripción;
                        /*
                        IF "Base Cálculo" = "Base Cálculo"::IVA THEN
                          Impuesto := 'IVA'
                        ELSE
                          Impuesto := 'RENTA';
                        */
                        PCTRet := "Importe Retención";
                        ImpRet := "Importe Retenido";
                    end
                    else
                        CurrReport.Quit;

                end;

                trigger OnPreDataItem()
                begin
                    Confirmado := false;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Comments.Reset;
                Comments.SetRange("Document Type", Comments."Document Type"::"Posted Invoice");
                Comments.SetRange("No.", "No.");
                if Comments.FindFirst then
                    Comentario := Comments.Comment
                else
                    Comentario := '';


                NoAuto := '';
                Establ := '';
                PuntoEmision := '';


                ConfSant.Get;

                Vendor.Get("Buy-from Vendor No.");

                if StrLen("No. Comprobante Fiscal") = 1 then
                    NoNCF := txt0007 + "No. Comprobante Fiscal";

                if StrLen("No. Comprobante Fiscal") = 2 then
                    NoNCF := txt0006 + "No. Comprobante Fiscal";

                if StrLen("No. Comprobante Fiscal") = 3 then
                    NoNCF := txt0001 + "No. Comprobante Fiscal";

                if StrLen("No. Comprobante Fiscal") = 4 then
                    NoNCF := txt0002 + "No. Comprobante Fiscal";

                if StrLen("No. Comprobante Fiscal") = 5 then
                    NoNCF := txt0003 + "No. Comprobante Fiscal";

                if StrLen("No. Comprobante Fiscal") = 6 then
                    NoNCF := txt0004 + "No. Comprobante Fiscal";

                if StrLen("No. Comprobante Fiscal") = 7 then
                    NoNCF := txt0005 + "No. Comprobante Fiscal";


                NoCompVta := Establecimiento + '-' + "Punto de Emision" + '-' + NoNCF;

                SRI.SetRange("Tipo Registro", SRI."Tipo Registro"::"TIPOS COMPROBANTES AUTORIZADOS");
                SRI.SetRange(Code, "Tipo de Comprobante");
                if SRI.FindFirst then
                    TipoCompVta := SRI.Description;


                if not CurrReport.Preview then begin
                    NoSeriesLin.Reset;
                    NoSeriesLin.SetRange("Series Code", NoSerieNCF);
                    NoSeriesLin.SetRange(Open, true);
                    NoSeriesLin.FindLast;

                    NoAuto := NoSeriesLin."No. Autorizacion";
                    Establ := NoSeriesLin.Establecimiento;
                    PuntoEmision := NoSeriesLin."Punto de Emision";

                    NoNCF := NoSeriesMagmt.GetNextNo(NoSerieNCF, WorkDate, true);

                    HistRetProv.Reset;
                    HistRetProv.SetRange(NCF, NoNCF);
                    HistRetProv.SetRange("No. autorizacion NCF", NoSeriesLin."No. Autorizacion");
                    HistRetProv.SetRange("Punto Emision", NoSeriesLin."Punto de Emision");
                    HistRetProv.SetRange(Establecimiento, NoSeriesLin.Establecimiento);
                    if HistRetProv.FindFirst then
                        Error(Error005, HistRetProv."No. documento");

                    RetDocReg.Reset;
                    RetDocReg.SetRange("Cód. Proveedor", "Purch. Inv. Header"."Buy-from Vendor No.");
                    RetDocReg.SetRange("No. documento", "Purch. Inv. Header"."No.");
                    if RetDocReg.FindSet then
                        repeat
                            RetDocReg."Fecha Impresion" := WorkDate;
                            RetDocReg.NCF := NoNCF;
                            RetDocReg.Modify;
                        until RetDocReg.Next = 0;

                end;
            end;

            trigger OnPreDataItem()
            begin
                if NoSerieNCF = '' then
                    Error(Error006);
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
                    Visible = false;
                }
                field(PuntoEmision; PuntoEmision)
                {
                    ApplicationArea = All;
                    Caption = 'Punto Emisión';
                    Visible = false;
                }
                field(Establ; Establ)
                {
                    ApplicationArea = All;
                    Caption = 'Establecimiento';
                    Visible = false;
                }
                field(NoNCF; NoNCF)
                {
                    ApplicationArea = All;
                    Caption = 'No. Comprobante';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        NoSeriesLin.Reset;
                        NoSeriesLin.SetRange("No. Autorizacion", NoAuto);
                        NoSeriesLin.SetRange("Punto de Emision", PuntoEmision);
                        NoSeriesLin.SetRange(Establecimiento, Establ);
                        NoSeriesLin.FindFirst;
                    end;
                }
                field("No. Serie Comprobante"; NoSerieNCF)
                {
                    ApplicationArea = All;
                    Caption = 'Fiscal No. Serie';
                    TableRelation = "No. Series Line";
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            NoSerieNCF := '';
        end;
    }

    labels
    {
    }

    var
        //ChkTransMgt: Report "Check Translation Management";
        DescriptionLine: array[2] of Text[250];
        CurrName: Text[100];
        Vendor: Record Vendor;
        AnoFiscal: Text[100];
        Impuesto: Text[200];
        BaseRet: Decimal;
        ImpRet: Decimal;
        PCTRet: Decimal;
        N: Integer;
        SerieRet: Code[100];
        ConfSant: Record "Config. Empresa";
        TipoCompVta: Text[100];
        NoCompVta: Text[100];
        "1NoAuto": Code[100];
        PuntoEmision: Code[3];
        Establecimiento: Code[3];
        NoNCF: Code[10];
        NoSeriesLin: Record "No. Series Line";
        Error001: Label 'Debe indicar No. de Autorización';
        Error002: Label 'Debe Indicar Punto de Emisión';
        Error003: Label 'Debe Indicar Establecimiento';
        Error004: Label 'Dede indicar No. Comprobante Fiscal';
        Error005: Label 'El No. de Comprobante ya existe en el Hist. de Retención, del documento %1';
        SRI: Record "SRI - Tabla Parametros";
        NoAuto: Code[100];
        Establ: Code[3];
        HistRetProv: Record "Historico Retencion Prov.";
        CodSerie: Code[20];
        NoSerie: Record "No. Series";
        RetDocReg: Record "Retencion Doc. Reg. Prov.";
        NoSerieNCF: Code[20];
        Error006: Label 'Fiscal Series No. must be specified';
        NoSeriesMagmt: Codeunit "No. Series";
        Error007: Label 'The retention corresponding to invoice %1 already has an assigned Receipt Number. If printed, Receipt Number %2 will be canceled and Receipt Number %3 will be assigned. Do you confirm that you want to proceed?';
        Comments: Record "Purch. Comment Line";
        Comentario: Text[200];
        Confirmado: Boolean;
        NCFAnulado: Record "NCF Anulados";
        ConfRet: Record "Config. Retencion Proveedores";
        noCNF: Code[9];
        txt0001: Label '000000';
        txt0002: Label '00000';
        txt0003: Label '0000';
        txt0004: Label '000';
        txt0005: Label '00';
        txt0006: Label '0000000';
        txt0007: Label '00000000';
        TOTAL_RETENIDOCaptionLbl: Label 'TOTAL RETENIDO';
}

