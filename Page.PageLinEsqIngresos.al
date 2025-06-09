page 76334 "Page Lin. Esq. Ingresos"
{
    ApplicationArea = all;
    Caption = 'Wage profile';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Perfil Salarial";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Tipo concepto"; rec."Tipo concepto")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Tipo Nomina"; rec."Tipo Nomina")
                {
                }
                field("Concepto salarial"; rec."Concepto salarial")
                {
                    Editable = false;
                    Enabled = true;
                }
                field(Descripcion; rec.Descripcion)
                {
                    Editable = false;
                }
                field(Cantidad; rec.Cantidad)
                {
                    Visible = CantidadVisible;
                }
                field(Importe; rec.Importe)
                {
                    Editable = ImporteEditable;
                    Visible = ImporteVisible;
                }
                field("1ra Quincena"; rec."1ra Quincena")
                {
                    Editable = false;
                    Visible = false;
                }
                field("2da Quincena"; rec."2da Quincena")
                {
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ImporteEditable := true;
        if rec."Formula calculo" <> '' then
            ImporteEditable := false
        else
            if rec."Concepto salarial" = ConfNom."Concepto Sal. Base" then
                ImporteEditable := ConfNom."Usar Acciones de personal";
    end;

    trigger OnInit()
    begin
        ImporteVisible := true;
        CantidadVisible := true;
    end;

    trigger OnOpenPage()
    begin
        ConfNom.Get();
    end;

    var
        ConfNom: Record "Configuracion nominas";

        CantidadVisible: Boolean;

        ImporteVisible: Boolean;

        ImporteEditable: Boolean;


    procedure FiltroEmpleado(CodEmpleado: Code[20]; TipoConcepto: Option Ingreso,Deduccion,Ambos; Muestra: Option Cantidad,Importe,Ambos; Concepto: Text[250])
    begin
        rec.Reset;
        CantidadVisible := true;
        ImporteVisible := true;

        if CodEmpleado <> '' then
            rec.SetRange("No. empleado", CodEmpleado);

        if TipoConcepto = 0 then
            rec.SetRange("Tipo concepto", 0) //Ingreso - Income
        else
            if TipoConcepto = 1 then
                rec.SetRange("Tipo concepto", 1); //Ingreso - Deduccion

        if Muestra = 0 then
            ImporteVisible := false //Hide Amount
        else
            if Muestra = 1 then
                CantidadVisible := false; //Hide Qty

        if Concepto <> '' then
            rec.SetFilter("Concepto salarial", Concepto);

        CurrPage.Update;
    end;
}

