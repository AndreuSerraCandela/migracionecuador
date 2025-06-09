report 55021 "Importar Lista de Precios"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Import Price List';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
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

    trigger OnInitReport()
    begin

        /*         TempFile.CreateTempFile;
                FileName := TempFile.Name + '.csv';
                TempFile.Close;
                if Upload(Text001, '', Text002, '', FileName) then begin
                    ProfileFile.Open(FileName);
                    ProfileFile.CreateInStream(FileInStream);
                    XMLPORT.Import(XMLPORT::"Importa Lista de Precios PR2", FileInStream);
                    ProfileFile.Close;
                end;

                Commit;
                CurrReport.Quit; */
    end;

    var
        FileName: Text[250];
        FileInStream: InStream;
        ProfileFile: File;
        Text001: Label 'Import from CSV File';
        Text002: Label 'CSV Files (*.csv)|*.xml';
        gdgVentana: Dialog;
        giContador: Integer;
        giTotalContador: Integer;
        Text003: Label 'CSV Files (*.csvl)|*.csvl|All Files (*.*)|*.*';
        gtVentana: Label 'Procesando Cupones\Cupon #1#####\@2@@@@@';
        ConfPersMgt: Codeunit "Conf./Personalization Mgt.";
        TempFile: File;
        "lErrorAñoEscolar": Label 'Debe indicar el año escolar.';
}

