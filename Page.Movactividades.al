page 76325 "Mov. actividades"
{
    ApplicationArea = all;
    Caption = 'Activiry Entry';
    Editable = false;
    PageType = List;
    SourceTable = "Mov. actividades OJO";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Entry No."; rec."Entry No.")
                {
                }
                field("No. empleado"; rec."No. empleado")
                {
                }
                field("Posting Date"; rec."Posting Date")
                {
                }
                field("Puesto trabajo"; rec."Puesto trabajo")
                {
                }
                field("Apellidos y Nombre"; rec."Apellidos y Nombre")
                {
                }
                field("Job No."; rec."Job No.")
                {
                }
                field("Job Task No."; rec."Job Task No.")
                {
                }
                field("Resource No."; rec."Resource No.")
                {
                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {
                }
                field("Qty. per Unit of Measure"; rec."Qty. per Unit of Measure")
                {
                }
                field("Job Task Name"; rec."Job Task Name")
                {
                }
                field("Concepto salarial"; rec."Concepto salarial")
                {
                }
                field("Tipo concepto"; rec."Tipo concepto")
                {
                }
                field(Quantity; rec.Quantity)
                {
                }
                field(Amount; rec.Amount)
                {
                }
                field("Tipo Tarifa"; rec."Tipo Tarifa")
                {
                }
                field("Precio Tarifa"; rec."Precio Tarifa")
                {
                }
                field("Inicio Período"; rec."Inicio Período")
                {
                }
                field("Fin Período"; rec."Fin Período")
                {
                }
                field("Work Type Code"; rec."Work Type Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

