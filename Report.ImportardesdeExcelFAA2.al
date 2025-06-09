report 56139 "Importar desde Excel FAA2"
{
    // FAA Creado para importar codigos de Paises para DATOS ATS
    DefaultLayout = RDLC;
    RDLCLayout = './ImportardesdeExcelFAA2.rdlc';


    dataset
    {
        dataitem(Lineas; "Excel Buffer")
        {

            trigger OnAfterGetRecord()
            begin

                if ("Row No." <> UltFila) and (UltFila > 0) then begin
                    ImportarLineaProcesada;
                    RecNo := RecNo + 1;
                    Clear(wAcumulador);
                    Acumular;
                end
                else
                    Acumular;

                wNreg += 1;
                wDialog.Update(1, Round((wNreg / wTotalRegs) * 10000, 1));

                UltFila := "Row No.";
            end;

            trigger OnPostDataItem()
            begin


                ImportarLineaProcesada;
                wDialog.Close;
            end;

            trigger OnPreDataItem()
            begin

                RecNo := 10000;
                wTotalRegs := Count;
                wNreg := 0;
                rLog.DeleteAll;

                wDialog.Open(text003);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Archivo de Excel"; FileName)
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        UploadFile;
                    end;

                    trigger OnValidate()
                    begin
                        FileNameOnAfterValidate;
                    end;
                }
                field(Hoja; SheetName)
                {

                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    begin
                        /*           if IsServiceTier then
                                      SheetName := ExcelBuf.SelectSheetsName(UploadedFileName)
                                  else
                                      SheetName := ExcelBuf.SelectSheetsName(FileName); */
                    end;
                }
            }
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

        ExcelBuf.DeleteAll;
        ExcelBuf.LockTable;
        ReadExcelSheet;
    end;

    var
        ExcelBuf: Record "Excel Buffer";
        FileName: Text[250];
        UploadedFileName: Text[1024];
        SheetName: Text[250];
        RecNo: Integer;
        wOpcion: Option ,"Productos: Diario","Productos:Documento Transferencia Consignacion","Proveedor:Dimensiones","Productos:Diaro Producto Almacén","Contabilidad:Diario General","Activos: Renombrar Activos","Activos: Diario A/F","Producto:Solo Costos","Productos: Diario Producto con Ubicacion","Activos:Dimension","Contabilidad:Arreglar Cuentas","Importa Promotores",TipoDoc,"Corrige Abono",DesmarcaAnula,ActualizarProveedores;
        wAcumulador: array[30] of Text[250];
        Description: Text[250];
        wFecha: Date;
        UltFila: Integer;
        wDialog: Dialog;
        wTotalRegs: Integer;
        wNreg: Integer;
        CodigoDoc: Code[20];
        NoLinea: Integer;
        LinDiaGen: Record "Gen. Journal Line";
        rLog: Record "Log Fallos Campos Requeridos";
        Text001: Label 'Import Excel File';
        text003: Label 'Insertado Datos @1@@@@@@@@@@@@@@@';
        text004: Label 'Especifique una fecha';
        text005: Label '¿Permitir Entrada Directa en TODAS las cuentas AUXILIARES?';
        Text006: Label 'Import Excel File';

    local procedure ReadExcelSheet()
    begin

        //if IsServiceTier then
        if UploadedFileName = '' then
            UploadFile
        else
            FileName := UploadedFileName;

        /*         ExcelBuf.OpenBook(FileName, SheetName); */
        ExcelBuf.ReadSheet;
    end;


    procedure UploadFile()
    var
        FileMgt: Codeunit "File Management";
        ExcelFileExtensionTok: Label '.xlsx', Locked = true;
    begin
        //UploadedFileName := CommonDialogMgt.OpenFile(Text001,'',2,'',0);
        //FileName := UploadedFileName;
        /*      UploadedFileName := FileMgt.UploadFile(Text006, ExcelFileExtensionTok); */
        FileName := UploadedFileName;
    end;


    procedure Acumular()
    var
        columna: Integer;
    begin

        Evaluate(columna, StrSubstNo('%1', Lineas."Column No."));
        wAcumulador[columna] := Lineas."Cell Value as Text";
    end;


    procedure aDecimal(var pText: Text[250]): Decimal
    var
        Num: Decimal;
    begin
        if pText = '' then
            exit(0);

        Num := 0;
        Evaluate(Num, StrSubstNo('%1', pText));
        exit(Num);
    end;


    procedure aFecha(pText: Text[30]) wFecha: Date
    begin

        Evaluate(wFecha, pText);
        exit(wFecha);
    end;


    procedure ImportarLineaProcesada()
    var
        rprov: Record Vendor;
        rvCountry: Record "Country/Region";
    begin
        rvCountry.Reset;

        rvCountry.SetRange(rvCountry.Name, wAcumulador[1]);
        if rvCountry.FindSet then
            rvCountry."Codigo Pais ATS" := wAcumulador[2];

        rvCountry.Modify;
    end;

    local procedure FileNameOnAfterValidate()
    begin
        UploadFile;
    end;
}

