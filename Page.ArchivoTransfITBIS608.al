#pragma implicitwith disable
page 76093 "Archivo Transf. ITBIS 608"
{
    ApplicationArea = all;
    Caption = 'Archivo Transferencia ITBIS 608';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Archivo Transferencia ITBIS";
    SourceTableView = SORTING("Line No.", "Codigo reporte", "Número Documento", "Fecha Documento", RNC, "Cédula", "No. Mov.")
                      ORDER(Ascending)
                      WHERE("Codigo reporte" = CONST('608'));

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
                    Caption = 'Cod. Cliente/Proveedor';
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
                field("NCF Relacionado"; rec."NCF Relacionado")
                {
                    Caption = 'Número de Comprobante Fiscal';
                }
                field("Fecha Documento"; rec."Fecha Documento")
                {
                    Caption = 'Fecha de Comprobante';
                }
                field("Razon Anulacion"; rec."Razon Anulacion")
                {
                    Caption = 'Tipo de Anulación';
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
                action("NCF anulados formato 608")
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
            }
        }
    }
}

#pragma implicitwith restore

