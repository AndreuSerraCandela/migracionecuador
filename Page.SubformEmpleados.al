page 76050 "Subform Empleados"
{
    ApplicationArea = all;
    PageType = ListPart;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            repeater(Control1100000)
            {
                Editable = false;
                ShowCaption = false;
                field("No."; rec."No.")
                {
                    Caption = 'Nº empleado';
                }
                field("Full Name"; rec."Full Name")
                {
                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Fecha salida empresa"; rec."Fecha salida empresa")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }


    procedure AplicarFiltros(Activos: Boolean; "Filtro Dimension 1": Text[250]; "Filtro Dimension 2": Text[250]; "Filtro Empresa": Text[250])
    begin
        rec.Reset;

        if Activos then
            rec.SetRange("Fecha salida empresa", 0D);

        if "Filtro Dimension 1" <> '' then
            rec.SetFilter("Global Dimension 1 Code", "Filtro Dimension 1");

        if "Filtro Dimension 2" <> '' then
            rec.SetFilter("Global Dimension 2 Code", "Filtro Dimension 2");

        if "Filtro Empresa" <> '' then
            rec.SetFilter(Company, "Filtro Empresa");

        CurrPage.Update;
    end;


    procedure FichaEmpleado()
    var
        frmEmpleado: Page "Ficha Empleados";
    begin
        frmEmpleado.SetRecord(Rec);
        frmEmpleado.RunModal;
        Clear(frmEmpleado);
    end;


    procedure RetEmpleado() CodEmpl: Code[20]
    begin
        exit(rec."No.");
    end;
}

