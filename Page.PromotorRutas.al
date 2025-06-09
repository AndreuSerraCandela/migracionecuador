page 76370 "Promotor - Rutas"
{
    ApplicationArea = all;

    Caption = 'Promoter - Routes';
    PageType = Card;
    SourceTable = "Promotor - Rutas";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                }
                field("Nombre Promotor"; rec."Nombre Promotor")
                {
                    Editable = false;
                }
                field("Cod. Ruta"; rec."Cod. Ruta")
                {
                }
                field("Descripcion Ruta"; rec."Descripcion Ruta")
                {
                    Editable = false;
                }
                field("Cod. Zona"; rec."Cod. Zona")
                {
                }
                field("Descripcion zona"; rec."Descripcion zona")
                {
                    Editable = false;
                }
                field("Cod. Supervisor"; rec."Cod. Supervisor")
                {
                }
                field("Nombre Supervisor"; rec."Nombre Supervisor")
                {
                    Editable = false;
                }
                field(Delegacion; rec.Delegacion)
                {
                }
                field("Descripcion Delegacion"; rec."Descripcion Delegacion")
                {
                }
            }
        }
    }

    actions
    {
    }
}

