page 76069 "Puestos laborares"
{
    ApplicationArea = all;
    AdditionalSearchTerms = 'Job types';
    //ApplicationArea = Basic, Suite, BasicHR;
    Caption = 'Job types';
    PageType = List;
    SourceTable = "Puestos laborales";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Cod. departamento"; rec."Cod. departamento")
                {
                    Visible = false;
                }
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Cod. nivel"; rec."Cod. nivel")
                {
                }
                field("Puesto Supervisor"; rec."Puesto Supervisor")
                {
                }
                field("Desc. puesto supervisor"; rec."Desc. puesto supervisor")
                {
                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {
                }
                field("Maximo de posiciones"; rec."Maximo de posiciones")
                {
                }
                field("Control de asistencia"; rec."Control de asistencia")
                {
                }
                field("Total Empleados"; rec."Total Empleados")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Position)
            {
                Caption = 'Position';
                action("&Perfil Salarial")
                {
                    Caption = '&Perfil Salarial';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Perfil Salario x Cargo";
                    RunPageLink = "Puesto de Trabajo" = FIELD(Codigo);
                }
                separator(Action1000000001)
                {
                }
                action(Niveles)
                {
                    Caption = 'Levels';
                    Image = BOMLevel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Niveles puestos laborales";
                }
                action(Requisitos)
                {
                    Caption = 'Job position profile';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Requisitos del Cargo";
                    RunPageLink = "Cod. Cargo" = FIELD(Codigo);
                }
            }
        }
    }
}

