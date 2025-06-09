page 76335 "Pagos a Expositores Ficha"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Pago a Expositores";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = wEdit;
                field("Cod. Expositor"; rec."Cod. Expositor")
                {
                }
                field("Nombre Expositor"; rec."Nombre Expositor")
                {
                    Editable = false;
                }
                field(Fecha; rec.Fecha)
                {
                }
                field("Tipo Documento"; rec."Tipo Documento")
                {
                }
                field("No. Documento"; rec."No. Documento")
                {
                }
                field("Estado Pago"; rec."Estado Pago")
                {
                }
            }
            /*  part(Subform; "Pagos a Expositores Subform")
             {
                 Caption = 'Detalle';
                 Editable = wEdit;
                 Enabled = wEdit;
                 SubPageLink = "ID Pago" = FIELD("ID Pago");
             } */
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000011>")
            {
                Caption = 'Pagos';
                action("<Action1000000010>")
                {
                    Caption = '&Pagar';
                    Enabled = wPendiente;
                    Image = SuggestVendorPayments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Text001: Label 'Importe del pago: %1. \Eventos incluidos: %2. \¿Desea continuar con el pago?';
                        Error001: Label 'No se ha ingresado ningun evento en este pago.';
                    begin
                        CurrPage.SaveRecord;
                        rec.CalcFields(Importe, "Numero Eventos");
                        rec.TestField("Cod. Expositor");
                        rec.TestField(Fecha);
                        rec.TestField("Tipo Documento");
                        rec.TestField("No. Documento");
                        if (rec."Numero Eventos" = 0) then
                            Error(Error001);
                        if Confirm(StrSubstNo(Text001, rec.Importe, rec."Numero Eventos")) then begin
                            rec."Estado Pago" := rec."Estado Pago"::Pagado;
                            rec.PagoEventos();
                            Estado;
                        end;
                    end;
                }
                action("<Action1000000012>")
                {
                    Caption = '&Retroceder Pagado';
                    Enabled = NOT wPendiente;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Text001: Label 'Importe del pago: %1. \Eventos incluidos: %2. \¿Desea retroceder el pago?';
                    begin
                        rec.CalcFields(Importe, "Numero Eventos");
                        if Confirm(StrSubstNo(Text001, rec.Importe, rec."Numero Eventos")) then begin
                            rec."Estado Pago" := rec."Estado Pago"::Pendiente;
                            rec.RetrocederPagoEventos();
                            Estado;
                        end;
                    end;
                }
                action(Estadisticas)
                {
                    Caption = 'Estadisticas';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Text001: Label 'Importe del pago: %1. \Eventos incluidos: %2.';
                    begin
                        rec.CalcFields(Importe, "Numero Eventos");
                        Message(StrSubstNo(Text001, rec.Importe, rec."Numero Eventos"));
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Estado;
    end;

    var

        wEdit: Boolean;

        wPendiente: Boolean;


    procedure Estado()
    begin
        if rec."Estado Pago" = rec."Estado Pago"::Pendiente then begin
            wEdit := true;
            wPendiente := true;
        end
        else begin
            wEdit := false;
            wPendiente := false;
        end;
    end;
}

