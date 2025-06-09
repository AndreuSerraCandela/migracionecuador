#pragma implicitwith disable
page 76091 "Archivo Transf. ITBIS 607"
{
    ApplicationArea = all;
    Caption = 'Archivo Transferencia ITBIS 607';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Archivo Transferencia ITBIS";
    SourceTableView = SORTING("Line No.", "Codigo reporte", "Número Documento", "Fecha Documento", RNC, "Cédula", "No. Mov.")
                      ORDER(Ascending)
                      WHERE("Codigo reporte" = CONST('607'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Codigo reporte"; rec."Codigo reporte")
                {
                }
                field("No. Mov."; rec."No. Mov.")
                {
                }
                field("Número Documento"; rec."Número Documento")
                {
                }
                field("Cod. Proveedor"; rec."Cod. Proveedor")
                {
                    Caption = 'Cod. Cliente';
                }
                field("Razón Social"; rec."Razón Social")
                {
                }
                field("Nombre Comercial"; rec."Nombre Comercial")
                {
                }
                field("Line No."; rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field("RNC/Cedula"; rec."RNC/Cedula")
                {
                    Caption = 'RNC/Cédula o Pasaporte';
                }
                field("Tipo Identificacion"; rec."Tipo Identificacion")
                {
                    Caption = 'ID type';
                }
                field(NCF; rec.NCF)
                {
                    Caption = 'Número Comprobante Fiscal';
                }
                field("NCF Relacionado"; rec."NCF Relacionado")
                {
                    Caption = 'Número Comprobante Fiscal Modificado';
                }
                field("Tipo de ingreso"; rec."Tipo de ingreso")
                {
                }
                field("Fecha Documento"; rec."Fecha Documento")
                {
                    Caption = 'Fecha Comprobante';
                }
                field("Fecha Retencion"; rec."Fecha Retencion")
                {
                    Caption = 'Fecha de Retención';
                }
                field("Total Documento"; rec."Total Documento")
                {
                    Caption = 'Grand total';
                }
                field("ITBIS Pagado"; rec."ITBIS Pagado")
                {
                    Caption = 'VAT paid';
                }
                field("ITBIS Retenido"; rec."ITBIS Retenido")
                {
                    Caption = 'Vat amount retained';
                }
                field("ITBIS Percibido"; rec."ITBIS Percibido")
                {
                    Caption = 'ITBIS Percibido';
                }
                field("ISR Retenido"; rec."ISR Retenido")
                {
                    Caption = 'ISR Retention';
                }
                field("ISR Percibido"; rec."ISR Percibido")
                {
                    Caption = 'ISR Percibido';
                }
                field("Monto Selectivo"; rec."Monto Selectivo")
                {
                    Caption = 'Impuesto Selectivo al Consumo';
                }
                field("Monto otros"; rec."Monto otros")
                {
                    Caption = 'Otros Impuestos/Tasas';
                }
                field("Monto Propina"; rec."Monto Propina")
                {
                    Caption = 'Monto Propina Legal';
                }
                field("Forma de pago DGII"; rec."Forma de pago DGII")
                {
                    Caption = 'Forma de Pago';
                }
                field("Monto Efectivo"; rec."Monto Efectivo")
                {
                    Caption = 'Efectivo';
                }
                field("Monto Cheque"; rec."Monto Cheque")
                {
                    Caption = 'Cheque/ Transferencia/ Depósito';
                }
                field("Monto tarjetas"; rec."Monto tarjetas")
                {
                    Caption = 'Tarjeta Débito/Crédito';
                }
                field("Venta a credito"; rec."Venta a credito")
                {
                    Caption = 'Venta a Crédito';
                }
                field("Venta bonos"; rec."Venta bonos")
                {
                    Caption = 'Bonos o Certificados de Regalo';
                }
                field("Venta Permuta"; rec."Venta Permuta")
                {
                    Caption = 'Permuta';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group("Formatos Mayo 2018")
            {
                Caption = 'Formatos Mayo 2018';
                Image = ElectronicDoc;
                action("Generate new 607 text file")
                {
                    Caption = 'Generate new 607 text file';
                    Image = ExportElectronicDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        XMLPORT.Run(76003, false, false);
                    end;
                }
            }
        }
        area(processing)
        {
            group(Action1000000049)
            {
                Caption = 'Process';
                action(AbrirDocumento)
                {
                    Caption = 'Open document';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PIH: Record "Purch. Inv. Header";
                        SIH: Record "Sales Invoice Header";
                        SSIH: Record "Service Invoice Header";
                        PCmH: Record "Purch. Cr. Memo Hdr.";
                        SCmH: Record "Sales Cr.Memo Header";
                        IFCMH: Record "Issued Fin. Charge Memo Header";
                    begin
                        if PIH.Get(Rec."Número Documento") then begin
                            PIH.SetRange(PIH."No.");
                            PAGE.Run(138, PIH)
                        end
                        else
                            if SIH.Get(Rec."Número Documento") then begin
                                SIH.SetRange("No.");
                                PAGE.Run(132, SIH)
                            end
                            else
                                if SSIH.Get(Rec."Número Documento") then begin
                                    SSIH.SetRange("No.");
                                    PAGE.Run(5978, SSIH)
                                end
                                else
                                    if PCmH.Get(Rec."Número Documento") then begin
                                        PCmH.SetRange("No.");
                                        PAGE.Run(140, PCmH)
                                    end
                                    else
                                        if SCmH.Get(Rec."Número Documento") then begin
                                            SCmH.SetRange("No.");
                                            PAGE.Run(134, SCmH)
                                        end
                                        else
                                            if IFCMH.Get(Rec."Número Documento") then begin
                                                IFCMH.SetRange("No.");
                                                PAGE.Run(450, IFCMH)
                                            end
                                            ;
                    end;
                }
                action("Stadisticas Comprobante Consumo")
                {
                    Caption = 'Resumen Facturas de Consumo';
                    Image = StatisticsDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PIH: Record "Purch. Inv. Header";
                        SIH: Record "Sales Invoice Header";
                        SSIH: Record "Service Invoice Header";
                        PCmH: Record "Purch. Cr. Memo Hdr.";
                        SCmH: Record "Sales Cr.Memo Header";
                    begin

                        PAGE.Run(76088);
                    end;
                }
                action("Resumen IT-1 Anexo A")
                {
                    Caption = 'Resumen IT-1 Anexo A';
                    Image = StatisticsDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PIH: Record "Purch. Inv. Header";
                        SIH: Record "Sales Invoice Header";
                        SSIH: Record "Service Invoice Header";
                        PCmH: Record "Purch. Cr. Memo Hdr.";
                        SCmH: Record "Sales Cr.Memo Header";
                    begin

                        PAGE.Run(76089);
                    end;
                }
            }
        }
    }
}

#pragma implicitwith restore

