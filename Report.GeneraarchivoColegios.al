report 76127 "Genera archivo Colegios"
{
    // CODIGO_COLEGIO NOMBRE NIVEL COLEGIO_UBIVEO DISTRITO DIRECCION CODIGO_PROMOTOR NOMBRE_PROMOTOR COD_DELE DESCRIPCION_DELE

    ApplicationArea = Basic, Suite;
    Caption = 'Generate school file';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UsageCategory = Tasks;
    UseRequestPage = false;

    dataset
    {
        dataitem(Contact; Contact)
        {
            DataItemTableView = SORTING("No.");
            dataitem("Colegio - Nivel"; "Colegio - Nivel")
            {
                DataItemLink = "Cod. Colegio" = FIELD("No.");
                DataItemTableView = SORTING("Cod. Colegio", "Cod. Nivel", Turno);

                trigger OnAfterGetRecord()
                begin
                    Clear(Lin_Body);

                    PR.Reset;
                    PR.SetRange("Cod. Ruta", Ruta);
                    if PR.FindFirst then begin
                        DimVal.Reset;
                        DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Delegacion");
                        DimVal.SetRange(Code, Contact.Región);
                        DimVal.FindFirst;

                        Promotor.Get(PR."Cod. Promotor");
                        Lin_Body := "Cod. Colegio" + ';' + Contact.Name + ';' + "Cod. Nivel" + ';' + Contact."Post Code" + ';' +
                                    Contact.City + ';' + Contact.Address + ';' + PR."Cod. Promotor" + ';' + Promotor.Name + ';' +
                                    Contact.Región + ';' + DimVal.Name;

                        /*          Fichero.Write(Lin_Body); */
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                Window.Update(1, "No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
            end;

            trigger OnPostDataItem()
            begin
                /*        Fichero.Close; */
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                ConfAPS.Get();
                ConfAPS.TestField("Ruta archivos electronicos");

                CounterTotal := Count;
                Window.Open(Text001);

                Blanco := '  ';
                if CopyStr(ConfAPS."Ruta archivos electronicos", StrLen(ConfAPS."Ruta archivos electronicos"), 1) = '\' then
                    NombreArchivo := ConfAPS."Ruta archivos electronicos" + 'COLEGIOS.CSV'
                else
                    NombreArchivo := ConfAPS."Ruta archivos electronicos" + '\COLEGIOS.CSV';
                /* 
                                Fichero.TextMode(true);
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
        PR: Record "Promotor - Rutas";
        Promotor: Record "Salesperson/Purchaser";
        DimVal: Record "Dimension Value";
        Lin_Body: Text[500];
        Fichero: File;
        Text002: Label 'Text documents (*.txt) |*.txt|Word Documents (*.doc*)|*.doc*|All files (*.*)|*.*';
        NombreArchivo: Text[30];
        Blanco: Text[30];
        CounterTotal: Integer;
        Counter: Integer;
        Window: Dialog;
        Text001: Label 'Processing  #1########## @2@@@@@@@@@@@@@';
}

