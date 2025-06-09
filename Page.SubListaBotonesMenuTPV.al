page 76017 "SubLista - Botones Menu TPV"
{
    ApplicationArea = all;
    Caption = 'Botones Menu TPV';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = Botones;
    SourceTableView = SORTING("Tipo Accion", Orden)
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Orden; rec.Orden)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field(Etiqueta; rec.Etiqueta)
                {
                }
                field(Color; rec.Color)
                {
                    Editable = false;

                    trigger OnAssistEdit()
                    var
                    //DialogColor: Codeunit colordi;
                    //Colores: DotNet Color;
                    begin

                        /*if IsNull(DialogColor) then begin //TPV
                            DialogColor := DialogColor.ColorDialog;
                            Colores := Colores.Color;
                        end;

                        if Color <> 0 then
                            DialogColor.Color := Colores.FromArgb(Color);

                        DialogColor.SolidColorOnly := true;
                        DialogColor.AnyColor := false;
                        DialogColor.AllowFullOpen := false;
                        DialogColor.ShowDialog;

                        Colores := DialogColor.Color;
                        Color := Colores.ToArgb;*/
                    end;
                }
                field(Activo; rec.Activo)
                {
                }
                field(Pago; rec.Pago)
                {
                }
                field(Accion; rec.Accion)
                {
                    Caption = 'Action';

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Tipo Accion"; rec."Tipo Accion")
                {
                    BlankZero = true;
                }
                field(Seguridad; rec.Seguridad)
                {
                    OptionCaption = ' ,Password';
                }
                field("Descuento %"; rec."Descuento %")
                {
                    MaxValue = 100;
                    MinValue = 0;
                }
            }
        }
    }

    actions
    {
    }
}

