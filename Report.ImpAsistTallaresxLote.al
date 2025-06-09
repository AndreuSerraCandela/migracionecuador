report 76262 "Imp.Asist. Tallares x Lote"
{
    Caption = 'Import Assistance workshops by Lot';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                ReadExcelSheet;
                AnalyzeData;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message(Text001);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field("Nombre Fichero"; FileName)
                {
                    Caption = 'Nombre Fichero';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        UploadFile;
                    end;
                }
                field("Nombre Hoja"; SheetName)
                {
                    Caption = 'Nombre Hoja';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        /*          if IsServiceTier then
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
    var
        BusUnit: Record "Business Unit";
    begin
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        PlanifEvento: Record "Cab. Planif. Evento";
        "Asist_T&E": Record "Asistentes Talleres y Eventos";
        Docente: Record Docentes;
        FileName: Text[250];
        UploadedFileName: Text[1024];
        SheetName: Text[250];
        RecNo: Integer;
        CodTaller: Code[20];
        CodDocente: Code[20];
        Window: Dialog;
        TotalRecNo: Integer;
        wNreg: Integer;
        UltFila: Integer;
        Text007: Label 'Analyzing Data...\\';
        Text006: Label 'Import Excel File';
        Text001: Label 'Import completed, please review';

    local procedure ReadExcelSheet()
    begin
        //if IsServiceTier then
        if UploadedFileName = '' then
            UploadFile
        else
            FileName := UploadedFileName;

        /*         ExcelBuf.OpenBook(FileName, SheetName);
                ExcelBuf.ReadSheet; */
    end;

    local procedure AnalyzeData()
    var
        TempExcelBuf: Record "Excel Buffer" temporary;
        BudgetBuf: Record "Budget Buffer";
        TempBudgetBuf: Record "Budget Buffer" temporary;
        HeaderRowNo: Integer;
        CountDim: Integer;
        TestDate: Date;
        OldRowNo: Integer;
        DimRowNo: Integer;
        DimCode3: Code[20];
    begin
        Window.Open(
          Text007 +
          '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);
        TotalRecNo := ExcelBuf.Count;
        RecNo := 0;

        if ExcelBuf.Find('-') then
            repeat
                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / TotalRecNo * 10000, 1));

                Clear("Asist_T&E");
                CodTaller := ExcelBuf."Cell Value as Text";

                PlanifEvento.Reset;
                PlanifEvento.SetRange("Cod. Taller - Evento", CodTaller);
                PlanifEvento.FindFirst;

                ExcelBuf.Next(1);
                CodDocente := ExcelBuf."Cell Value as Text";
                Docente.Reset;
                Docente.SetRange("Document ID", CodDocente);
                Docente.FindFirst;

                Clear("Asist_T&E");
                "Asist_T&E".Validate("Tipo Evento", PlanifEvento."Tipo Evento");
                "Asist_T&E".Validate("Cod. Taller - Evento", CodTaller);
                "Asist_T&E".Validate("Cod. Expositor", PlanifEvento.Expositor);
                "Asist_T&E".Secuencia := PlanifEvento.Secuencia;
                "Asist_T&E".Validate("Cod. Docente", Docente."No.");
                if "Asist_T&E".Insert(true) then;

                RecNo := RecNo + 1;
            until ExcelBuf.Next = 0;
    end;


    procedure UploadFile()
    var
        CommonDialogMgt: Codeunit "File Management";
        ClientFileName: Text[1024];
    begin
        //UploadedFileName := CommonDialogMgt.OpenFile(Text006,ClientFileName,2,'',0);
        /*   UploadedFileName := CommonDialogMgt.UploadFile(Text006, ClientFileName);
          FileName := UploadedFileName; */
    end;

    local procedure FileNameOnAfterValidate()
    begin
        UploadFile;
    end;
}

