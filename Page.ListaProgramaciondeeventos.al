page 76307 "Lista Programacion de eventos"
{
    ApplicationArea = all;
    Caption = 'Solicitud de Asistencia Técnico - Pedagógica';
    PageType = Card;
    SourceTable = "Solicitud de Taller - Evento";
    SourceTableView = WHERE(Status = CONST(" "));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No. Solicitud"; rec."No. Solicitud")
                {

                    trigger OnAssistEdit()
                    begin
                        if rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Cod. promotor"; rec."Cod. promotor")
                {
                    Editable = "Cod. promotorEditable";
                }
                field("Nombre promotor"; rec."Nombre promotor")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                }
                field("Tipo de Evento"; rec."Tipo de Evento")
                {
                }
                field("Cod. evento"; rec."Cod. evento")
                {
                }
                field("Descripcion evento"; rec."Descripcion evento")
                {
                }
                field(Delegacion; rec.Delegacion)
                {
                }
                field(Observaciones; rec.Observaciones)
                {
                    MultiLine = true;
                }
                field("Fecha Solicitud"; rec."Fecha Solicitud")
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Cod. Turno"; rec."Cod. Turno")
                {
                }
                field("Evento programado"; rec."Evento programado")
                {
                }
                field(Status; rec.Status)
                {
                    Editable = false;
                }
                field("Asistentes Esperados"; rec."Asistentes Esperados")
                {
                }
            }
            group("Event")
            {
                Caption = 'Event';
                field(Sala; rec.Sala)
                {
                }
                field("Horas programadas"; rec."Horas programadas")
                {
                }
                field("Asistentes Reales"; rec."Asistentes Reales")
                {
                }
                field("Eventos programados"; rec."Eventos programados")
                {
                }
                field("Importe Gasto Expositor"; rec."Importe Gasto Expositor")
                {
                }
                field("Importe Gasto mensajeria"; rec."Importe Gasto mensajeria")
                {
                }
                field("ImporteGastos Impresion"; rec."ImporteGastos Impresion")
                {
                }
                field("Importe Utiles"; rec."Importe Utiles")
                {
                }
                field("Importe Atenciones"; rec."Importe Atenciones")
                {
                }
                field("Otros Importes"; rec."Otros Importes")
                {
                }
                field("Nombre responsable"; rec."Nombre responsable")
                {
                }
                field("No. celular responsable"; rec."No. celular responsable")
                {
                }
                field("Objetivo promotor"; rec."Objetivo promotor")
                {
                }
                field("Cod. Expositor"; rec."Cod. Expositor")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Event")
            {
                Caption = '&Event';
                action("&Send request")
                {
                    Caption = '&Send request';

                    trigger OnAction()
                    begin
                        rec.Status := 1;
                        rec.Modify;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        "Cod. promotorEditable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if CodPromotor <> '' then begin
            UserSetup.Get(UserId);
            SalesPerson.Get(UserSetup."Salespers./Purch. Code");
            if SalesPerson.Tipo = 0 then //Salesperson
               begin
                UserSetup.TestField("Salespers./Purch. Code");
                rec.Validate("Cod. promotor", UserSetup."Salespers./Purch. Code");
                "Cod. promotorEditable" := false;
            end;
        end;
    end;

    var
        UserSetup: Record "User Setup";
        SalesPerson: Record "Salesperson/Purchaser";
        CodPromotor: Code[20];
        "Cod. promotorEditable": Boolean;


    procedure RecibeParam(CodProm: Code[20])
    begin
        CodPromotor := CodProm;
    end;
}

