page 76282 "Lista de Docentes Sel. Eventos"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Docentes;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; rec."No.")
                {
                }
                field("Full Name"; rec."Full Name")
                {
                }
                field("First Name"; rec."First Name")
                {
                }
                field("Middle Name"; rec."Middle Name")
                {
                }
                field("Last Name"; rec."Last Name")
                {
                }
                field("Second Last Name"; rec."Second Last Name")
                {
                }
                field("Tipo documento"; rec."Tipo documento")
                {
                }
                field("Document ID"; rec."Document ID")
                {
                }
                field("Pertenece al CDS"; rec."Pertenece al CDS")
                {
                }
                field(Status; rec.Status)
                {
                }
            }
        }
        area(factboxes)
        {
            part(PlanifEventLP; "Consulta Asist. Taller/Evento")
            {
                SubPageLink = "Cod. Docente" = FIELD("No.");
            }
            part(Control1000000015; "Colegios -  Docentes ListPart")
            {
                SubPageLink = "Cod. Docente" = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1000000038>")
            {
                Caption = '&Event';
                action("<Action1000000039>")
                {
                    Caption = 'Associate Events';
                    Image = CalendarChanged;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ProgTyE: Record "Programac. Talleres y Eventos";
                        Seq: Integer;
                        IndSkip: Boolean;
                    begin
                        ListaSelEvent.RecibeParametro(rec."No.");
                        ListaSelEvent.RunModal;
                        Clear(ListaSelEvent);
                    end;
                }
            }
        }
    }

    var
        ListaSelEvent: Page "Lista Seleccion eventos";
}

