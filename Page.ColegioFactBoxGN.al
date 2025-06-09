#pragma implicitwith disable
page 76137 "Colegio - FactBox % GN"
{
    ApplicationArea = all;
    Editable = false;
    PageType = ListPart;
    SourceTable = "Datos auxiliares";
    SourceTableView = SORTING("Tipo registro", Codigo)
                      WHERE("Tipo registro" = CONST("Grupo de Negocio"));

    layout
    {
        area(content)
        {
            repeater(Control1000000003)
            {
                ShowCaption = false;
                field(Descripcion; rec.Descripcion)
                {
                    Caption = 'Grupo de negocio';
                }
                /*   field(TraerPorcentaje; rec.TraerPorcentaje)
                  {
                      Caption = '%';
                  } */
            }
        }
    }

    actions
    {
    }

    var
        codColegio: Code[20];


    procedure PasarParam(codPrmColegio: Code[20])
    begin
        codColegio := codPrmColegio;
    end;


    procedure TraerPorcentaje(): Decimal
    var
        recDetAdop: Record "Colegio - Adopciones Detalle";
        decTotalColegio: Decimal;
        decTotalNivel: Decimal;
    begin

        //Calcula el % del grupo de negociosobre el total de adopciones.

        recDetAdop.Reset;
        recDetAdop.SetRange("Cod. Colegio", codColegio);
        recDetAdop.SetFilter(Adopcion, '%1|%2', recDetAdop.Adopcion::Mantener, recDetAdop.Adopcion::Conquista);
        recDetAdop.SetFilter("Adopcion Real", '<>%1', 0);
        if recDetAdop.FindSet then
            repeat
                decTotalColegio += recDetAdop."Adopcion Real" * TraerPrecioUnitarioProducto(recDetAdop."Cod. Producto");
            until recDetAdop.Next = 0;

        if decTotalColegio <> 0 then begin
            recDetAdop.SetRange("Grupo de Negocio", Rec.Codigo);
            if recDetAdop.FindSet then
                repeat
                    decTotalNivel += recDetAdop."Adopcion Real" * TraerPrecioUnitarioProducto(recDetAdop."Cod. Producto");
                until recDetAdop.Next = 0;

            exit(Round(decTotalNivel / decTotalColegio * 100));
        end;
    end;


    procedure TraerPrecioUnitarioProducto(codPrmProducto: Code[20]): Decimal
    var
        //recPrecios: Record "Sales Price";
        recPrecios: Record "Price List Line";
    begin
        recPrecios.Reset;
        //recPrecios.SetRange("Item No.", codPrmProducto);
        recPrecios.SetRange("Asset Type", recPrecios."Asset Type"::Item);
        recPrecios.SetRange("Product No.", codPrmProducto);
        //recPrecios.SetRange("Sales Type", recPrecios."Sales Type"::"All Customers");
        recPrecios.SetRange("Source Type", recPrecios."Source Type"::"All Customers");
        //recPrecios.SetRange("Sales Code", '');
        recPrecios.SetRange("Assign-to No.", '');
        recPrecios.SetRange("Source No.", '');
        recPrecios.SetRange("Currency Code", '');
        recPrecios.SetRange("Variant Code", '');
        recPrecios.SetRange("Ending Date", 0D);
        if recPrecios.FindLast then
            exit(recPrecios."Unit Price");
    end;
}

#pragma implicitwith restore

