report 76422 "Genera archivo adopciones"
{
    // CODIGO_COLEGIO COD_ARTICULO ARTICULO RUBRO FAMILIA SUBFAMILIA SERIE GRADO

    ApplicationArea = Basic, Suite;
    Caption = 'Generate adoption archive';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UsageCategory = Tasks;
    UseRequestPage = false;

    dataset
    {
        dataitem("Colegio - Adopciones Detalle"; "Colegio - Adopciones Detalle")
        {
            DataItemTableView = SORTING("Cod. Colegio", "Cod. Nivel", "Cod. Grado", "Cod. Turno", "Cod. Promotor", "Cod. Producto") WHERE("Cantidad Alumnos" = FILTER(<> 0));

            trigger OnAfterGetRecord()
            begin
                Clear(Lin_Body);

                Counter := Counter + 1;
                Window.Update(1, "Cod. Colegio");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                Item.Get("Cod. Producto");
                //fes mig
                /*
                Lin_Body := "Cod. Colegio" + ';' + "Cod. Producto" + ';' + "Descripcion producto" + ';' + "Linea de negocio" + ';' +
                            Familia + ';' + "Sub Familia" + ';' + Serie + ';' + "Cod. Grado" + ';' + "Sub Familia" + ' ' + Serie +
                            ' ' + Item.Tipos;
                */
                //fes mig

                /*       Fichero.Write(Lin_Body); */

            end;

            trigger OnPostDataItem()
            begin
                /*            Fichero.Close;
                           Window.Close; */
            end;

            trigger OnPreDataItem()
            begin
                ConfAPS.Get();
                ConfAPS.TestField("Ruta archivos electronicos");
                CounterTotal := Count;
                Window.Open(Text001);

                if CopyStr(ConfAPS."Ruta archivos electronicos", StrLen(ConfAPS."Ruta archivos electronicos"), 1) = '\' then
                    NombreArchivo := ConfAPS."Ruta archivos electronicos" + 'ADOPCIONES.CSV'
                else
                    NombreArchivo := ConfAPS."Ruta archivos electronicos" + '\ADOPCIONES.CSV';

                /*                 Fichero.TextMode(true);
                                Fichero.Create(NombreArchivo);
                                Fichero.Trunc; */
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ConfAPS: Record "Commercial Setup";
        Item: Record Item;
        Lin_Body: Text[500];
        Fichero: File;
        Text002: Label 'Text documents (*.txt) |*.txt|Word Documents (*.doc*)|*.doc*|All files (*.*)|*.*';
        NombreArchivo: Text[30];
        Text001: Label 'Processing  #1########## @2@@@@@@@@@@@@@';
        CounterTotal: Integer;
        Counter: Integer;
        Window: Dialog;
}

