report 76357 "Genera archivo Docentes"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Generate teacher archives';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UsageCategory = Tasks;
    UseRequestPage = false;

    dataset
    {
        dataitem(Docentes; Docentes)
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            begin
                Clear(Lin_Body);

                Counter := Counter + 1;
                Window.Update(1, "No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                if "Job Type Code" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::"Puestos de trabajo");
                    DA.SetRange(Codigo, "Job Type Code");
                    DA.FindFirst;
                end;
                Lin_Body := "Document ID" + ';' + "Salutation Code" + ';' + Format(Sexo) + ';' + Format(Hijos) + ';' + "Last Name" + ';' +
                            "Second Last Name" + ';' + "First Name" + ';' + "Tipo documento" + ';' + "Document ID" + ';' +
                            "Phone No." + ';' + "Mobile Phone No." + ';' + Address + ';' + "Address 2" + ';' + City + ';' +
                            "E-Mail" + ';' + Format("Dia Nacimiento", 0, '<Integer,2><Filler Character,0>') + '/' +
                            Format("Mes Nacimiento", 0, '<Integer,2><Filler Character,0>') + '/' +
                            Format("Ano Nacimiento", 0, '<Integer,4><Filler Character,0>') + ';' + "Nivel Docente" + ';' +
                            "Job Type Code" + ';' + DA.Descripcion;
                /*              Fichero.Write(Lin_Body); */
            end;

            trigger OnPostDataItem()
            begin
                /*        Fichero.Close;
                       Window.Close; */
            end;

            trigger OnPreDataItem()
            begin
                ConfAPS.Get();
                ConfAPS.TestField("Ruta archivos electronicos");

                CounterTotal := Count;
                Window.Open(Text001);

                Blanco := '  ';
                if CopyStr(ConfAPS."Ruta archivos electronicos", StrLen(ConfAPS."Ruta archivos electronicos"), 1) = '\' then
                    NombreArchivo := ConfAPS."Ruta archivos electronicos" + 'DOCENTES.CSV'
                else
                    NombreArchivo := ConfAPS."Ruta archivos electronicos" + '\DOCENTES.CSV';
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
        DimVal: Record "Dimension Value";
        DA: Record "Datos auxiliares";
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

