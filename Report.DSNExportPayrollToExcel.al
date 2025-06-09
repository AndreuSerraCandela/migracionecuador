report 76166 "DSN-Export Payroll To Excel"
{
    Caption = 'Export Payroll to Excel';
    ProcessingOnly = true;

    dataset
    {
        dataitem(HCN; "Historico Cab. nomina")
        {
            DataItemTableView = SORTING (Ano, "No. empleado", "Período", "Job No.", "Tipo de nomina");
            RequestFilterFields = "Tipo de nomina", "Período", "Job No.", "No. empleado";

            trigger OnAfterGetRecord()
            begin
                Window.Update(1, 0);

                Depto.Get(HCN.Departamento);
                Empl.Get(HCN."No. empleado");

                HLN.Reset;
                HLN.SetRange("No. empleado", HCN."No. empleado");
                HLN.SetRange("Tipo de nomina", "Tipo de nomina");
                HLN.SetRange(Período, Período);
                if HLN.FindSet then
                    repeat
                        WritePayrollEmpExcelBody;
                    until HLN.Next = 0;
            end;

            trigger OnPostDataItem()
            begin
                CreateExcelSheet('Datos Empleados', true);

                WriteExcelHeaderCP;

                HCN.FindSet;
                repeat
                    HLNCP.Reset;
                    HLNCP.SetRange("No. Empleado", HCN."No. empleado");
                    HLNCP.SetRange("Tipo de nomina", HCN."Tipo de nomina");
                    HLNCP.SetRange(Período, HCN.Período);
                    if HLNCP.FindSet then
                        repeat
                            WritePayrollEmpExcelBodyCP;
                        until HLNCP.Next = 0;
                until HCN.Next = 0;

                Window.Close;

                CreateExcelSheet('Datos Empresa', false);
                WriteExcelBook;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(
                  Text000 +
                  '@1@@@@@@@@@@@@@@@@@@@@@\');
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

    trigger OnPreReport()
    begin
        GLSetup.Get();

        TempExcelBuffer.Reset;
        TempExcelBuffer.DeleteAll;
        TempExcelBuffer.NewRow;

        WriteExcelHeader;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        DimVal: Record "Dimension Value";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        Depto: Record Departamentos;
        Puestos: Record "Puestos laborales";
        Empl: Record Employee;
        Text000: Label 'Analyzing Data...\\';
        DescDepto: Label 'Department description';
        HLN: Record "Historico Lin. nomina";
        HCN2: Record "Historico Cab. nomina";
        HLNCP: Record "Lin. Aportes Empresas";
        FileMgt: Codeunit "File Management";
        ClientFileName: Text;
        ServerFileName: Text;
        SheetName: Text[250];
        DescCargo: Label 'Job position name';
        Text002: Label 'Update Workbook';
        Window: Dialog;
        RecNo: Integer;
        TotalRecNo: Integer;
        ExcelFileName: Label 'Payroll %1 %2';
        DescDim1: Text;
        DescDim2: Text;

    local procedure WriteExcelHeader()
    begin
        TempExcelBuffer.AddColumn(HCN.FieldCaption("No. empleado"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HCN.FieldCaption("Full name"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Empl.FieldCaption("Document Type"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Empl.FieldCaption("Document ID"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HCN.FieldCaption(Departamento), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(DescDepto, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(DescCargo, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        if GLSetup."Global Dimension 1 Code" <> '' then begin
            TempExcelBuffer.AddColumn(Empl.FieldCaption("Global Dimension 1 Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Desc. ' + Empl.FieldCaption("Global Dimension 1 Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        end;

        if GLSetup."Global Dimension 2 Code" <> '' then begin
            TempExcelBuffer.AddColumn(Empl.FieldCaption("Global Dimension 2 Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Desc. ' + Empl.FieldCaption("Global Dimension 2 Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        end;
        TempExcelBuffer.AddColumn(Empl.FieldCaption(Gender), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HCN.FieldCaption("Forma de Cobro"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLN.FieldCaption("Tipo concepto"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLN.FieldCaption("Tipo de nomina"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLN.FieldCaption(Período), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Empl.FieldCaption("Termination Date"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLN.FieldCaption("Concepto salarial"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLN.FieldCaption(Descripción), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLN.FieldCaption(Cantidad), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLN.FieldCaption(Total), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLN.FieldCaption(Comentario), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure WritePayrollEmpExcelBody()
    begin
        TempExcelBuffer.NewRow;
        TempExcelBuffer.AddColumn(HCN."No. empleado", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HCN."Full name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Empl."Document Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Empl."Document ID", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HCN.Departamento, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Depto.Descripcion, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Empl."Job Title", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        if (GLSetup."Global Dimension 1 Code" <> '') and (HCN."Shortcut Dimension 1 Code" <> '') then begin
            DimVal.Reset;
            DimVal.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
            DimVal.SetRange(Code, HCN."Shortcut Dimension 1 Code");
            DimVal.FindFirst;
            TempExcelBuffer.AddColumn(HCN."Shortcut Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(DimVal.Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        end
        else begin
            TempExcelBuffer.AddColumn(' ', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(' ', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        end;

        if (GLSetup."Global Dimension 2 Code" <> '') and (HCN."Shortcut Dimension 2 Code" <> '') then begin
            DimVal.Reset;
            DimVal.SetRange("Dimension Code", GLSetup."Global Dimension 2 Code");
            DimVal.SetRange(Code, HCN."Shortcut Dimension 2 Code");
            DimVal.FindFirst;
            TempExcelBuffer.AddColumn(HCN."Shortcut Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(DimVal.Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        end
        else begin
            TempExcelBuffer.AddColumn(' ', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(' ', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        end;



        TempExcelBuffer.AddColumn(Empl.Gender, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HCN."Forma de Cobro", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLN."Tipo concepto", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLN."Tipo de nomina", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLN.Período, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(Empl."Termination Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(HLN."Concepto salarial", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLN.Descripción, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLN.Cantidad, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(HLN.Total, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(HLN.Comentario, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
    end;

    local procedure WriteExcelHeaderCP()
    begin
        TempExcelBuffer.AddColumn(HLNCP.FieldCaption("No. Empleado"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLNCP.FieldCaption("Apellidos y Nombre"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLNCP.FieldCaption("Tipo de nomina"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLNCP.FieldCaption(Período), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLNCP.FieldCaption("Concepto Salarial"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLNCP.FieldCaption(Descripcion), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLNCP.FieldCaption("Base Imponible"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLNCP.FieldCaption(Importe), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure WritePayrollEmpExcelBodyCP()
    begin
        TempExcelBuffer.NewRow;
        HLNCP.CalcFields("Apellidos y Nombre");
        TempExcelBuffer.AddColumn(HLNCP."No. Empleado", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLNCP."Apellidos y Nombre", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLNCP."Tipo de nomina", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLNCP.Período, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(HLNCP."Concepto Salarial", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLNCP.Descripcion, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HLNCP."Base Imponible", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(HLNCP.Importe, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
    end;

    local procedure CreateExcelSheet(SheetName: Text[250]; NewBook: Boolean)
    begin
        if NewBook then
            TempExcelBuffer.CreateNewBook(SheetName)
        else
            TempExcelBuffer.SelectOrAddSheet(SheetName);
        TempExcelBuffer.WriteSheet(SheetName, CompanyName, UserId);
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.ClearNewRow();
    end;

    local procedure WriteExcelBook()
    begin
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, HCN.GetRangeMax(Período), UserId));
        TempExcelBuffer.OpenExcel();
    end;
}

