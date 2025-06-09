report 50003 "Importar Prepedido Ventas"
{
    // YFC     : Yefrecis Francisco Cruz
    // ------------------------------------------------------------------------
    // No.         Firma   Fecha         Descripcion
    // ------------------------------------------------------------------------
    // 001         YFC     31/01/2024    SANTINAV-5207

    ApplicationArea = Basic, Suite;
    Caption = 'Import Preorders Massively';
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
                    XMLPORT.Import(XMLPORT::"Importar Prepedidos Ventas", FileInStream);
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

