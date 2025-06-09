report 76078 "Llena 606"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                /*
                AT_Itbis.RESET;
                AT_Itbis.SETCURRENTKEY(NCF);
                AT_Itbis.SETRANGE("Codigo reporte",'606');
                IF AT_Itbis.FIND('-') THEN
                   REPEAT
                    Counter += 1;
                    Window.UPDATE(1,ROUND(Counter / CounterTotal * 10000,1));
                
                    ImporteFacturado += AT_Itbis."Total Documento";
                    ImporteITBIS     += AT_Itbis."ITBIS Pagado";
                    ImporteRetenido  += AT_Itbis."ITBIS Retenido";
                    NoRec            += 1;
                
                    xlSheet.Range("Col-b").Value := AT_Itbis.RNC;
                //    xlSheet.Range("Col-c").Value := FORMAT(AT_Itbis."Tipo ID");
                    CASE AT_Itbis."Clasific. Gastos y Costos NCF" OF
                     '01':
                       xlSheet.Range("Col-d").Value := '01-GASTOS DE PERSONAL';
                     '02':
                       xlSheet.Range("Col-d").Value := '02-GASTOS POR TRABAJOS, SUMINISTROS Y SERVICIOS';
                     '03':
                       xlSheet.Range("Col-d").Value := '03-ARRENDAMIENTOS';
                     '04':
                       xlSheet.Range("Col-d").Value := '04-GASTOS DE ACTIVOS FIJO';
                     '05':
                       xlSheet.Range("Col-d").Value := '05 -GASTOS DE REPRESENTACIÊN';
                     '06':
                       xlSheet.Range("Col-d").Value := '06 -OTRAS DEDUCCIONES ADMITIDAS';
                     '07':
                       xlSheet.Range("Col-d").Value := '07 -GASTOS FINANCIEROS';
                     '08':
                       xlSheet.Range("Col-d").Value := '08 -GASTOS EXTRAORDINARIOS';
                     '09':
                       xlSheet.Range("Col-d").Value := '09 -COMPRAS Y GASTOS QUE FORMARAN PARTE DEL COSTO DE VENTA';
                     '10':
                       xlSheet.Range("Col-d").Value := '10 -ADQUISICIONES DE ACTIVOS';
                     '11':
                       xlSheet.Range("Col-d").Value := '11- GASTOS DE SEGUROS';
                    END;
                
                    xlSheet.Range("Col-e").Value := AT_Itbis.NCF;
                    xlSheet.Range("Col-f").Value := AT_Itbis."NCF Relacionado";
                    xlSheet.Range("Col-g").Value := COPYSTR(AT_Itbis."Fecha Documento",1,6);
                    xlSheet.Range("Col-h").Value := COPYSTR(AT_Itbis."Fecha Documento",7,2);
                    xlSheet.Range("Col-i").Value := COPYSTR(AT_Itbis."Fecha Pago",1,6);
                    xlSheet.Range("Col-j").Value := COPYSTR(AT_Itbis."Fecha Pago",7,2);
                    xlSheet.Range("Col-k").Value := FORMAT(AT_Itbis."ITBIS Pagado");
                    xlSheet.Range("Col-l").Value := FORMAT(AT_Itbis."ITBIS Retenido");
                    xlSheet.Range("Col-m").Value := FORMAT(AT_Itbis."Total Documento");
                //    xlSheet.Range("Col-t").Value := FORMAT(AT_Itbis."Razón Social");
                //    xlSheet.Range("Col-u").Value := FORMAT(AT_Itbis."Número Factura");
                //    xlSheet.Range("Col-v").Value := FORMAT(AT_Itbis."No. Doc. Externo");
                
                    "Col-b" := INCSTR("Col-b");
                //    "Col-c" := INCSTR("Col-c");
                    "Col-d" := INCSTR("Col-d");
                    "Col-e" := INCSTR("Col-e");
                    "Col-f" := INCSTR("Col-f");
                    "Col-g" := INCSTR("Col-g");
                    "Col-h" := INCSTR("Col-h");
                    "Col-i" := INCSTR("Col-i");
                    "Col-j" := INCSTR("Col-j");
                    "Col-k" := INCSTR("Col-k");
                    "Col-l" := INCSTR("Col-l");
                    "Col-m" := INCSTR("Col-m");
                //    "Col-t" := INCSTR("Col-t");
                //    "Col-u" := INCSTR("Col-u");
                //    "Col-v" := INCSTR("Col-v");
                
                   UNTIL AT_Itbis.NEXT = 0;
                   */

            end;

            trigger OnPostDataItem()
            begin
                /*xlApp.Visible(TRUE);
                xlApp.UserControl(TRUE);
                */
                Window.Close;

            end;

            trigger OnPreDataItem()
            begin
                /*
                CounterTotal := COUNT;
                Window.OPEN(Text001);
                
                rCompany.GET();
                
                AT_Itbis.SETRANGE("Codigo reporte",'606');
                IF AT_Itbis.FIND('-') THEN
                   REPEAT
                    ImporteFacturado += AT_Itbis."Total Documento";
                    ImporteITBIS     += AT_Itbis."ITBIS Pagado";
                    ImporteRetenido  += AT_Itbis."ITBIS Retenido";
                    NoRec += 1;
                   UNTIL AT_Itbis.NEXT = 0;
                
                
                CREATE(xlApp,FALSE,TRUE);
                xlBook  := xlApp.Workbooks._Open(FileName);
                xlSheet := xlBook.Worksheets.Item(SheetName);
                
                xlSheet.Activate;
                
                //Llena encabezado
                Fila                          := 'C4';
                xlSheet.Range(Fila).Value     := rCompany."VAT Registration No.";
                Fila := 'C5';
                xlSheet.Range(Fila).Value     := COPYSTR(AT_Itbis."Fecha Documento",1,6);
                Fila := 'C6';
                xlSheet.Range(Fila).Value     := FORMAT(NoRec);
                Fila                          := 'C7';
                xlSheet.Range(Fila).Value     := FORMAT(ImporteFacturado);
                //Fin Encabezado
                
                "Col-b" := 'B12';
                "Col-c" := 'C12';
                "Col-d" := 'D12';
                "Col-e" := 'E12';
                "Col-f" := 'F12';
                "Col-g" := 'G12';
                "Col-h" := 'H12';
                "Col-i" := 'I12';
                "Col-j" := 'J12';
                "Col-k" := 'K12';
                "Col-l" := 'L12';
                "Col-m" := 'M12';
                //"Col-t" := 'T12';
                //"Col-u" := 'U12';
                //"Col-v" := 'V12';
                */

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1000000008)
                {
                    ShowCaption = false;
                    group("Import from")
                    {
                        Caption = 'Import from';
                        field(FileName; FileName)
                        {
                        ApplicationArea = All;
                            Caption = 'Workbook File Name';

                            trigger OnAssistEdit()
                            begin
                                UploadFile;
                            end;
                        }
                        field(SheetName; SheetName)
                        {
                        ApplicationArea = All;
                            Caption = 'Worksheet Name';

                            trigger OnAssistEdit()
                            begin
                                /*                  if IsServiceTier then
                                                     SheetName := ExcelBuf.SelectSheetsName(UploadedFileName)
                                                 else
                                                     SheetName := ExcelBuf.SelectSheetsName(FileName); */
                            end;
                        }
                    }
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

    var
        rCompany: Record "Company Information";
        AT_Itbis: Record "Archivo Transferencia ITBIS";
        PathArchivo: Text[150];
        Fichero: File;
        "Product Cell": Text[30];
        ExcelBuf: Record "Excel Buffer";
        FileName: Text[250];
        UploadedFileName: Text[1024];
        SheetName: Text[250];
        CounterTotal: Integer;
        Window: Dialog;
        Counter: Integer;
        CantLin: Integer;
        ImporteFacturado: Decimal;
        ImporteITBIS: Decimal;
        ImporteRetenido: Decimal;
        Fila: Text[30];
        "Col-b": Text[30];
        "Col-c": Text[30];
        "Col-d": Text[30];
        "Col-e": Text[30];
        "Col-f": Text[30];
        "Col-g": Text[30];
        "Col-h": Text[30];
        "Col-i": Text[30];
        "Col-j": Text[30];
        "Col-k": Text[30];
        "Col-l": Text[30];
        "Col-m": Text[30];
        "Col-t": Text[30];
        "Col-u": Text[30];
        "Col-v": Text[30];
        NoRec: Integer;
        Option: Option "Create Workbook","Update Workbook";
        FileNameEnable: Boolean;
        SheetNameEnable: Boolean;
        Text001: Label 'Exporting @1@@@@@@@@@@@@@';
        Text002: Label 'Update Workbook';
        Text006: Label 'Import Excel File';


    procedure UploadFile()
    var
        FileMgt: Codeunit "File Management";
        ClientFileName: Text[1024];
        ExcelFileExtensionTok: Label '.xlsx', Locked = true;
    begin
        /*         UploadedFileName := FileMgt.UploadFile(Text006, ExcelFileExtensionTok);
                FileName := UploadedFileName; */
    end;

    local procedure FileNameOnAfterValidate()
    begin
        UploadFile;
    end;
}

