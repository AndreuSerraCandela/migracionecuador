report 56132 "Importar Pedido Call Center"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Import Call Center Orders';
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

    trigger OnPreReport()
    begin

        /*         TempFile.CreateTempFile;
                FileName := TempFile.Name + '.xml';
                TempFile.Close;
                if Upload(Text001, '', Text002, '', FileName) then begin
                    ProfileFile.Open(FileName);
                    ProfileFile.CreateInStream(FileInStream);
                    XMLPORT.Import(XMLPORT::"Importar Ped Call Center vs2", FileInStream);
                    ProfileFile.Close;
                end;
                CurrReport.Quit; */
    end;

    var
        FileName: Text[250];
        FileInStream: InStream;
        ProfileFile: File;
        Text001: Label 'Import from XML File';
        Text002: Label 'XML Files (*.xml)|*.xml';
        gdgVentana: Dialog;
        giContador: Integer;
        giTotalContador: Integer;
        Text003: Label 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*';
        gtVentana: Label 'Procesando Cupones\Cupon #1#####\@2@@@@@';
        ConfPersMgt: Codeunit "Conf./Personalization Mgt.";
        TempFile: File;
        "lErrorAñoEscolar": Label 'Debe indicar el año escolar.';
}

