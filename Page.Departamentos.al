page 76166 Departamentos
{
    ApplicationArea = all;
    AdditionalSearchTerms = 'Department';
    //ApplicationArea = Basic, Suite, BasicHR;
    Caption = 'Department';
    PageType = List;
    SourceTable = Departamentos;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Total Empleados"; rec."Total Empleados")
                {
                }
                field(Inactivo; rec.Inactivo)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Department")
            {
                Caption = '&Department';
                action("Sub Department")
                {
                    Caption = 'Sub Department';
                    Image = Departments;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sub-Departamento";
                    RunPageLink = "Cod. Departamento" = FIELD(Codigo);
                }
                action(Puestos)
                {
                    Image = Position;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Puestos laborares";
                    RunPageLink = "Cod. departamento" = FIELD(Codigo);
                }
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

