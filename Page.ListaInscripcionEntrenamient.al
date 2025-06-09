page 76297 "Lista Inscripcion Entrenamient"
{
    ApplicationArea = all;
    Caption = 'Registration for training';
    Editable = false;
    PageType = List;
    SourceTable = Employee;
    SourceTableView = WHERE(Status = CONST(Active));

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
                field("Desc. Departamento"; rec."Desc. Departamento")
                {
                }
                field("Job Title"; rec."Job Title")
                {
                }
                field("Document Type"; rec."Document Type")
                {
                }
                field("Document ID"; rec."Document ID")
                {
                }
                field("Phone No."; rec."Phone No.")
                {
                }
                field("Mobile Phone No."; rec."Mobile Phone No.")
                {
                }
                field(Gender; rec.Gender)
                {
                }
                field("E-Mail"; rec."E-Mail")
                {
                }
                field("Employment Date"; rec."Employment Date")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000018; "Asist. Ent - Entrenam  Factbox")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "No. empleado" = FIELD("No."),
                              Inscrito = CONST(true);
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
                    Caption = 'Sign up for training';
                    Image = CalendarChanged;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ListaSelEntrenamientos.RecibeParametro(rec."No.");
                        ListaSelEntrenamientos.RunModal;
                        Clear(ListaSelEntrenamientos);
                    end;
                }
                action("<Action1000000019>")
                {
                    Caption = '&Employee Card';
                    Image = Employee;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Ficha Empleados";
                    RunPageLink = "No." = FIELD("No.");
                }
            }
        }
    }

    var
        ListaSelEntrenamientos: Page "Lista seleccion entrenamientos";
}

