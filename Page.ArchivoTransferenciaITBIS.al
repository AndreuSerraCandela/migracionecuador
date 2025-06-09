#pragma implicitwith disable
page 76087 "Archivo Transferencia ITBIS"
{
    ApplicationArea = all;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Archivo Transferencia ITBIS";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; rec."Line No.")
                {
                }
                field("Codigo reporte"; rec."Codigo reporte")
                {
                }
                field(Apellidos; rec.Apellidos)
                {
                    Visible = false;
                }
                field(Nombres; rec.Nombres)
                {
                    Visible = false;
                }
                field("Razón Social"; rec."Razón Social")
                {
                    Visible = false;
                }
                field("Nombre Comercial"; rec."Nombre Comercial")
                {
                }
                field(RNC; rec.RNC)
                {
                    Visible = false;
                }
                field("Clasific. Gastos y Costos NCF"; rec."Clasific. Gastos y Costos NCF")
                {
                }
                field("Tipo Identificacion"; rec."Tipo Identificacion")
                {
                }
                field("Cédula"; rec.Cédula)
                {
                    Visible = false;
                }
                field("RNC/Cedula"; rec."RNC/Cedula")
                {
                }
                field(NCF; rec.NCF)
                {
                }
                field("NCF Relacionado"; rec."NCF Relacionado")
                {
                }
                field("Tipo de ingreso"; rec."Tipo de ingreso")
                {
                }
                field("Fecha Documento"; rec."Fecha Documento")
                {
                }
                field("Fecha Pago"; rec."Fecha Pago")
                {
                }
                field("Monto Bienes"; rec."Monto Bienes")
                {
                }
                field("Monto Servicios"; rec."Monto Servicios")
                {
                }
                field("Número Documento"; rec."Número Documento")
                {
                    Visible = false;
                }
                field("Total Documento"; rec."Total Documento")
                {
                }
                field("ITBIS Pagado"; rec."ITBIS Pagado")
                {
                }
                field("ITBIS Retenido"; rec."ITBIS Retenido")
                {
                }
                field("ITBIS llevado al costo"; rec."ITBIS llevado al costo")
                {
                }
                field("ISR Retenido"; rec."ISR Retenido")
                {
                }
                field("Tipo retencion ISR"; rec."Tipo retencion ISR")
                {
                }
                field("Monto Selectivo"; rec."Monto Selectivo")
                {
                }
                field("Monto otros"; rec."Monto otros")
                {
                }
                field("Monto Propina"; rec."Monto Propina")
                {
                }
                field("Forma de pago DGII"; rec."Forma de pago DGII")
                {
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
                field("Codigo Informacion"; rec."Codigo Informacion")
                {
                }
                field("Cod. Proveedor"; rec."Cod. Proveedor")
                {
                    Visible = false;
                }
                field("fecha registro"; rec."fecha registro")
                {
                }
                field(Dia; rec.Dia)
                {
                    Visible = false;
                }
                field("Razon Anulacion"; rec."Razon Anulacion")
                {
                }
                field("Dia Pago"; rec."Dia Pago")
                {
                    Visible = false;
                }
                field("No. Mov."; rec."No. Mov.")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group("Formatos antes Mayo 2018")
            {
                Caption = 'Formatos antes Mayo 2018';
                Image = ElectronicDoc;
                action("<Action1000000028>")
                {
                    Caption = 'Generate 606 text file';
                    Image = ExportElectronicDocument;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        XMLPORT.Run(76042, false, false);
                    end;
                }
                action("2014 Archivo Compras formato 606")
                {
                    Caption = '2014 Archivo Compras formato 606';
                    Image = ExportElectronicDocument;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        XMLPORT.Run(76058, false, false);
                    end;
                }
                action("<Action1000000029>")
                {
                    Caption = 'Archivo Ventas formato 607';
                    Image = ExportElectronicDocument;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        XMLPORT.Run(76041, false, false);
                    end;
                }
                action("NCF anulados formato 608")
                {
                    Caption = 'NCF anulados formato 608';
                    Image = ExportElectronicDocument;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        XMLPORT.Run(76079, false, false);
                    end;
                }
                action("Pagos Exterior Formato 609")
                {
                    Caption = 'Pagos Exterior Formato 609';
                    Image = ExportElectronicDocument;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        XMLPORT.Run(76056, false, false);
                    end;
                }
                action("NCF Compras Formato 610")
                {
                    Caption = 'NCF Compras Formato 610';
                    Image = ExportElectronicDocument;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Message('Debe importar plantillas');
                    end;
                }
                action("NCF compra de divisas 612")
                {
                    Caption = 'NCF compra de divisas 612';
                    Image = ExportElectronicDocument;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        XMLPORT.Run(76080, false, false);
                    end;
                }
                separator(Action1000000027)
                {
                }
                separator(Action1000000050)
                {
                }
            }
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
                action(Action1000000063)
                {
                    Caption = 'NCF anulados formato 608';
                    Image = ExportElectronicDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        XMLPORT.Run(76006, false, false);
                    end;
                }
                separator(Action1000000051)
                {
                }
            }
        }
        area(processing)
        {
            group(Action1000000049)
            {
                Caption = 'Process';
                action("Pagos al exterior")
                {
                    Caption = 'Payments abroad';
                    Image = ExportElectronicDocument;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = XMLport "Pagos Exterior Formato 609";
                }
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

