#pragma implicitwith disable
page 76090 "Archivo Transf. ITBIS 606"
{
    ApplicationArea = all;
    Caption = 'Archivo Transferencia ITBIS 606';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Archivo Transferencia ITBIS";
    SourceTableView = SORTING("Line No.", "Codigo reporte", "Número Documento", "Fecha Documento", RNC, "Cédula", "No. Mov.")
                      ORDER(Ascending)
                      WHERE("Codigo reporte" = CONST('606'));

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
                    Caption = 'RNC - Cedula';
                }
                field("Tipo Identificacion"; rec."Tipo Identificacion")
                {
                    Caption = 'ID type';
                }
                field("Clasific. Gastos y Costos NCF"; rec."Clasific. Gastos y Costos NCF")
                {
                    Caption = 'Expense code';
                }
                field(NCF; rec.NCF)
                {
                }
                field("NCF Relacionado"; rec."NCF Relacionado")
                {
                    Caption = 'Related NCF';
                }
                field("Fecha Documento"; rec."Fecha Documento")
                {
                    Caption = 'Document date';
                }
                field("Fecha Pago"; rec."Fecha Pago")
                {
                }
                field("Monto Servicios"; rec."Monto Servicios")
                {
                    Caption = 'Monto Facturado en Servicios';
                }
                field("Monto Bienes"; rec."Monto Bienes")
                {
                    Caption = 'Monto Facturado en Bienes';
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
                field("ITBIS sujeto a proporc."; rec."ITBIS sujeto a proporc.")
                {
                    Caption = 'ITBIS sujeto a Proporcionalidad (Art. 349)';
                }
                field("ITBIS llevado al costo"; rec."ITBIS llevado al costo")
                {
                }
                field("ITBIS Por adelantar"; rec."ITBIS Por adelantar")
                {
                }
                field("ITBIS Percibido"; rec."ITBIS Percibido")
                {
                    Caption = 'ITBIS percibido en compras';
                }
                field("Tipo retencion ISR"; rec."Tipo retencion ISR")
                {
                    Caption = 'Tipo de Retención en ISR';
                }
                field("ISR Retenido"; rec."ISR Retenido")
                {
                    Caption = 'ISR Retention';
                }
                field("ISR Percibido"; rec."ISR Percibido")
                {
                    Caption = 'ISR Percibido en compras';
                }
                field("Monto Selectivo"; rec."Monto Selectivo")
                {
                    Caption = 'Impuesto Selectivo al Consumo';
                }
                field("Monto otros"; rec."Monto otros")
                {
                    Caption = 'Otros Impuesto/Tasas';
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
                }
                field("Monto Cheque"; rec."Monto Cheque")
                {
                }
                field("Monto tarjetas"; rec."Monto tarjetas")
                {
                }
                field("Venta a credito"; rec."Venta a credito")
                {
                }
                field("Venta bonos"; rec."Venta bonos")
                {
                }
                field("Venta Permuta"; rec."Venta Permuta")
                {
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
                action("Generate new 606 text file")
                {
                    Caption = 'Generate new 606 text file';
                    Image = ExportElectronicDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        XMLPORT.Run(76007, false, false);
                    end;
                }
            }
        }
        area(processing)
        {
            group(Action1000000049)
            {
                Caption = 'Process';
                action("Fill 606 Format")
                {
                    Caption = 'Fill 606 Format';
                    Image = ExportToExcel;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Report "Llena 606";
                }
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
            }
        }
    }
}

#pragma implicitwith restore

