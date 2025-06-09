page 56125 "Cantidad deshacer-desarmar"
{
    ApplicationArea = all;
    // #14195   26/03/15  CAT  Page para ingresar la cantidad a deshacer de un ensamblado.
    // #36407   11/12/15  CAT  Elegir el almacen de desarme


    layout
    {
        area(content)
        {
            field(Cantidad; Cantidad)
            {
                Caption = 'Cantidad a deshacer-desarmar';
            }
            field(Fecha; Fecha)
            {
                Caption = 'Fecha';
            }
            field(CodAlmacen; CodAlm)
            {
                Caption = 'Cód. Almacén';
                TableRelation = Location;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Fecha := WorkDate;
    end;

    var
        Cantidad: Decimal;
        Fecha: Date;
        CodAlm: Code[20];


    procedure CantidadIngresada() rtnCantidad: Decimal
    begin
        rtnCantidad := Cantidad;
    end;


    procedure SetCantidad(pCantidad: Decimal)
    begin
        Cantidad := pCantidad;
    end;


    procedure FechaIngresada() rtnFecha: Date
    begin
        rtnFecha := Fecha;
    end;


    procedure SetAlmacen(pCodAlm: Code[20])
    begin
        //#36407
        CodAlm := pCodAlm;
    end;


    procedure AlmacenIngresado() rtnCodAlm: Code[20]
    begin
        //#36407
        rtnCodAlm := CodAlm;
    end;
}

