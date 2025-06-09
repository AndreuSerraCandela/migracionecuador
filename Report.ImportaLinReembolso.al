report 55013 "Importa Lin. Reembolso"
{
    // #34843      CAT         10/11/2015   Validación contenido en los campos:
    //                                        - RUC
    //                                        - "Establecimiento Comprobante"
    //                                        - "Punto Emision Comprobante"
    //                                        - "Numero Secuencial Comprobante"
    //                                        - "Fecha Comprobante"
    //                                        - "No. Autorización Comprobante"
    // 
    // #34829      CAT       20/11/2015    Nueva columna BaseExenta
    // 
    // #44893      CAT       03/02/2016    Control del contenido de los campos

    Caption = 'Import Purch. Lines';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                ReadExcelSheet;
                Commit;
                AnalyzeData;
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
                group(Options)
                {
                    Caption = 'Options';
                    group("Import from")
                    {
                        Caption = 'Import from';
                        field(File_Name; FileName)
                        {
                            Caption = 'Workbook File Name';
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
                        field(Sheet_Name; SheetName)
                        {
                            Caption = 'Worksheet Name';
                            ApplicationArea = All;

                            trigger OnAssistEdit()
                            begin
                                /*                        if IsServiceTier then
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
        ExcelBuf: Record "Excel Buffer" temporary;
        PL: Record "Purchase Line";
        PL2: Record "Purchase Line";
        FileName: Text[250];
        UploadedFileName: Text[1024];
        SheetName: Text[250];
        Window: Dialog;
        Text0001: Label 'aaa';
        Text007: Label 'Analyzing Data...\\';
        TotalRecNo: Integer;
        RecNo: Integer;
        Text006: Label 'Import Excel File';
        Err001: Label 'The code %1 doesn''t exist either as Item or G/L Account';
        Err002: Label 'Cost can''t be zero, check line %1';
        Err003: Label 'Quantity can''t be zero, check line %1';
        Err004: Label 'G/L Account or Item code can''t be blank, check line %1';
        ExcelFileExtensionTok: Label '.xlsx', Locked = true;
        TipoDocumento: Integer;
        NoDocumento: Code[20];
        NoFila: Integer;
        Err005: Label 'El fichero no es válido.';
        Err006: Label 'El fichero está incompleto. La Fila %1 Columna %2 no tiene contenido.';
        Err007: Label 'El fichero está incompleto. La Fila %1, al menos una de las Columnas: %2 debe tener tiene contenido.';


    procedure RecibeParametros(TipoDoc: Integer; NoDoc: Code[20])
    begin
        TipoDocumento := TipoDoc;
        NoDocumento := NoDoc;
    end;

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
        DimVal: Record "Dimension Value";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
        vID: Code[20];
        vRuc: Code[20];
        vTipo: Code[20];
        vEstablecimiento: Code[20];
        vPuntoEmision: Code[20];
        vSecuencia: Code[20];
        vFecha: Date;
        vNoAutorizacion: Code[49];
        vBaseNoSujeto: Decimal;
        vBase0: Decimal;
        vBaseX: Decimal;
        vMontoICE: Decimal;
        vMontoIVA: Decimal;
        vTipoProveedor: Code[10];
        bEstructura: Boolean;
        FilaAnt: Integer;
        rFactRespaldo: Record "Facturas de reembolso";
        Error001: Label '%1 no válido.';
        Error002: Label 'Solo se permite que el Numero de Autorización tenga 10, 37 o 49 digitos. ';
        vBaseExenta: Decimal;
        I: Integer;
        C1: Boolean;
        C2: Boolean;
        C3: Boolean;
        C4: Boolean;
        C5: Boolean;
        C6: Boolean;
        C7: Boolean;
        C8: Boolean;
        C9: Boolean;
        C10: Boolean;
        C11: Boolean;
        C12: Boolean;
        C13: Boolean;
        C14: Boolean;
        C15: Boolean;
    begin
        Window.Open(
          Text007 +
          '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);
        RecNo := 0;

        FilaAnt := 0;
        Clear(vID);
        Clear(vRuc);
        Clear(vTipo);
        Clear(vEstablecimiento);
        Clear(vPuntoEmision);
        Clear(vSecuencia);
        Clear(vFecha);
        Clear(vNoAutorizacion);
        Clear(vBaseNoSujeto);
        //+#34829
        Clear(vBaseExenta);
        //+#34829
        Clear(vBase0);
        Clear(vBaseX);
        Clear(vMontoICE);
        Clear(vMontoIVA);
        Clear(vTipoProveedor);
        ExcelBuf.SetFilter("Row No.", '>%1', 1);
        ExcelBuf.SetRange("Column No.", 1, 15);

        //+#44893
        if ExcelBuf.Find('-') then begin
            FilaAnt := ExcelBuf."Row No.";
            Clear(C1);
            Clear(C2);
            Clear(C3);
            Clear(C4);
            Clear(C5);
            Clear(C6);
            Clear(C7);
            Clear(C8);
            Clear(C9);
            Clear(C10);
            Clear(C11);
            Clear(C12);
            Clear(C13);
            Clear(C14);
            Clear(C15);
            repeat
                if (FilaAnt <> ExcelBuf."Row No.") then begin
                    case true of
                        C1 = false:
                            Error(StrSubstNo(Err006, FilaAnt, 1));
                        C2 = false:
                            Error(StrSubstNo(Err006, FilaAnt, 2));
                        C3 = false:
                            Error(StrSubstNo(Err006, FilaAnt, 3));
                        C4 = false:
                            Error(StrSubstNo(Err006, FilaAnt, 4));
                        C5 = false:
                            Error(StrSubstNo(Err006, FilaAnt, 5));
                        C6 = false:
                            Error(StrSubstNo(Err006, FilaAnt, 6));
                        C7 = false:
                            Error(StrSubstNo(Err006, FilaAnt, 7));
                        C8 = false:
                            Error(StrSubstNo(Err006, FilaAnt, 8));
                        (C9 = false) and (C10 = false) and (C11 = false) and (C12 = false):
                            Error(StrSubstNo(Err007, FilaAnt, '9, 10, 11 o 12'));
                        C14 = false:
                            Error(StrSubstNo(Err006, FilaAnt, 14));
                        C15 = false:
                            Error(StrSubstNo(Err006, FilaAnt, 15));
                    end;
                    FilaAnt := ExcelBuf."Row No.";
                    Clear(C1);
                    Clear(C2);
                    Clear(C3);
                    Clear(C4);
                    Clear(C5);
                    Clear(C6);
                    Clear(C7);
                    Clear(C8);
                    Clear(C9);
                    Clear(C10);
                    Clear(C11);
                    Clear(C12);
                    Clear(C13);
                    Clear(C14);
                    Clear(C15);
                end;
                case ExcelBuf."Column No." of
                    1:
                        C1 := true;
                    2:
                        C2 := true;
                    3:
                        C3 := true;
                    4:
                        C4 := true;
                    5:
                        C5 := true;
                    6:
                        C6 := true;
                    7:
                        C7 := true;
                    8:
                        C8 := true;
                    9:
                        C9 := true;
                    10:
                        C10 := true;
                    11:
                        C11 := true;
                    12:
                        C12 := true;
                    13:
                        C13 := true;
                    14:
                        C14 := true;
                    15:
                        C15 := true;
                end;
            until ExcelBuf.Next = 0;
            case true of
                C1 = false:
                    Error(StrSubstNo(Err006, FilaAnt, 1));
                C2 = false:
                    Error(StrSubstNo(Err006, FilaAnt, 2));
                C3 = false:
                    Error(StrSubstNo(Err006, FilaAnt, 3));
                C4 = false:
                    Error(StrSubstNo(Err006, FilaAnt, 4));
                C5 = false:
                    Error(StrSubstNo(Err006, FilaAnt, 5));
                C6 = false:
                    Error(StrSubstNo(Err006, FilaAnt, 6));
                C7 = false:
                    Error(StrSubstNo(Err006, FilaAnt, 7));
                C8 = false:
                    Error(StrSubstNo(Err006, FilaAnt, 8));
                (C9 = false) and (C10 = false) and (C11 = false) and (C12 = false):
                    Error(StrSubstNo(Err007, FilaAnt, '9, 10, 11 o 12'));
                C14 = false:
                    Error(StrSubstNo(Err006, FilaAnt, 14));
                C15 = false:
                    Error(StrSubstNo(Err006, FilaAnt, 15));
            end;
        end;
        //+#44893

        if ExcelBuf.Find('-') then begin
            TotalRecNo := ExcelBuf.Count;
            FilaAnt := ExcelBuf."Row No.";
            repeat
                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / TotalRecNo * 10000, 1));
                if (FilaAnt <> ExcelBuf."Row No.") then begin
                    //+#44893
                    if vID = '' then
                        Error(StrSubstNo(Error001, 'Tipo Identificador'));
                    if vTipo = '' then
                        Error(StrSubstNo(Error001, 'Tipo Comprobante'));
                    if (vBaseNoSujeto = 0) and (vBaseExenta = 0) and (vBase0 = 0) and (vBaseX = 0) then
                        Error(StrSubstNo(Error001, 'Importe de las bases'));
                    //-#44893
                    //+#34843
                    if vRuc = '' then
                        Error(StrSubstNo(Error001, rFactRespaldo.FieldCaption(RUC)));
                    if vEstablecimiento = '' then
                        Error(StrSubstNo(Error001, rFactRespaldo.FieldCaption("Establecimiento Comprobante")));
                    if vPuntoEmision = '' then
                        Error(StrSubstNo(Error001, rFactRespaldo.FieldCaption("Punto Emision Comprobante")));
                    if vSecuencia = '' then
                        Error(StrSubstNo(Error001, rFactRespaldo.FieldCaption("Numero Secuencial Comprobante")));
                    if vFecha = 0D then
                        Error(StrSubstNo(Error001, rFactRespaldo.FieldCaption("Fecha Comprobante")));
                    if vNoAutorizacion = '' then
                        Error(StrSubstNo(Error001, rFactRespaldo.FieldCaption("No. Autorización Comprobante")))
                    else
                        if (StrLen(vNoAutorizacion) <> 37) and (StrLen(vNoAutorizacion) <> 49) and (StrLen(vNoAutorizacion) <> 10) then
                            Error(Error002);
                    //-#34843
                    ValidaDupicacion(vEstablecimiento, vPuntoEmision, vSecuencia, vNoAutorizacion);

                    rFactRespaldo.Init;
                    rFactRespaldo."Document Type" := TipoDocumento;
                    rFactRespaldo."Document No." := NoDocumento;
                    rFactRespaldo."Tipo ID" := vID;
                    rFactRespaldo.RUC := vRuc;
                    rFactRespaldo."Tipo Comprobante" := vTipo;
                    rFactRespaldo."Establecimiento Comprobante" := vEstablecimiento;
                    rFactRespaldo."Punto Emision Comprobante" := vPuntoEmision;
                    rFactRespaldo."Numero Secuencial Comprobante" := vSecuencia;
                    rFactRespaldo."Fecha Comprobante" := vFecha;
                    rFactRespaldo."No. Autorización Comprobante" := vNoAutorizacion;
                    rFactRespaldo."Base No Objeto IVA" := vBaseNoSujeto;
                    rFactRespaldo."Base Exenta IVA" := vBaseExenta;
                    rFactRespaldo."Base 0" := vBase0;
                    rFactRespaldo."Base X" := vBaseX;
                    rFactRespaldo."Monto ICE" := vMontoICE;
                    rFactRespaldo."Monto IVA" := vMontoIVA;
                    rFactRespaldo."Tipo Proveedor Reembolso" := vTipoProveedor;
                    rFactRespaldo.Insert(true);

                    FilaAnt := ExcelBuf."Row No.";
                    Clear(vID);
                    Clear(vRuc);
                    Clear(vTipo);
                    Clear(vEstablecimiento);
                    Clear(vPuntoEmision);
                    Clear(vSecuencia);
                    Clear(vFecha);
                    Clear(vNoAutorizacion);
                    Clear(vBaseNoSujeto);
                    //+#34829
                    Clear(vBaseExenta);
                    //+#34829
                    Clear(vBase0);
                    Clear(vBaseX);
                    Clear(vMontoICE);
                    Clear(vMontoIVA);
                    Clear(vTipoProveedor);
                end;
                case ExcelBuf."Column No." of
                    1:
                        vID := ExcelBuf."Cell Value as Text";
                    2:
                        vRuc := ExcelBuf."Cell Value as Text";
                    3:
                        vTipo := ExcelBuf."Cell Value as Text";
                    4:
                        vEstablecimiento := ExcelBuf."Cell Value as Text";
                    5:
                        vPuntoEmision := ExcelBuf."Cell Value as Text";
                    6:
                        vSecuencia := ExcelBuf."Cell Value as Text";
                    7:
                        Evaluate(vFecha, ExcelBuf."Cell Value as Text");
                    8:
                        vNoAutorizacion := ExcelBuf."Cell Value as Text";
                    9:
                        Evaluate(vBaseNoSujeto, ExcelBuf."Cell Value as Text");
                    10:
                        Evaluate(vBaseExenta, ExcelBuf."Cell Value as Text");
                    11:
                        Evaluate(vBase0, ExcelBuf."Cell Value as Text");
                    12:
                        Evaluate(vBaseX, ExcelBuf."Cell Value as Text");
                    13:
                        Evaluate(vMontoICE, ExcelBuf."Cell Value as Text");
                    14:
                        Evaluate(vMontoIVA, ExcelBuf."Cell Value as Text");
                    15:
                        vTipoProveedor := ExcelBuf."Cell Value as Text";
                end;
            until ExcelBuf.Next = 0;

            //+#44893
            if vID = '' then
                Error(StrSubstNo(Error001, 'Tipo Identificador'));
            if vTipo = '' then
                Error(StrSubstNo(Error001, 'Tipo Comprobante'));
            if (vBaseNoSujeto = 0) and (vBaseExenta = 0) and (vBase0 = 0) and (vBaseX = 0) then
                Error(StrSubstNo(Error001, 'Importe de las bases'));
            //-#44893

            //+#34843
            if vRuc = '' then
                Error(StrSubstNo(Error001, rFactRespaldo.FieldCaption(RUC)));
            if vEstablecimiento = '' then
                Error(StrSubstNo(Error001, rFactRespaldo.FieldCaption("Establecimiento Comprobante")));
            if vPuntoEmision = '' then
                Error(StrSubstNo(Error001, rFactRespaldo.FieldCaption("Punto Emision Comprobante")));
            if vSecuencia = '' then
                Error(StrSubstNo(Error001, rFactRespaldo.FieldCaption("Numero Secuencial Comprobante")));
            if vFecha = 0D then
                Error(StrSubstNo(Error001, rFactRespaldo.FieldCaption("Fecha Comprobante")));
            if vNoAutorizacion = '' then
                Error(StrSubstNo(Error001, rFactRespaldo.FieldCaption("No. Autorización Comprobante")))
            else
                if (StrLen(vNoAutorizacion) <> 37) and (StrLen(vNoAutorizacion) <> 49) and (StrLen(vNoAutorizacion) <> 10) then
                    Error(Error002);

            ValidaDupicacion(vEstablecimiento, vPuntoEmision, vSecuencia, vNoAutorizacion);
            //-#34843

            rFactRespaldo.Init;
            rFactRespaldo."Document Type" := TipoDocumento;
            rFactRespaldo."Document No." := NoDocumento;
            rFactRespaldo."Tipo ID" := vID;
            rFactRespaldo.RUC := vRuc;
            rFactRespaldo."Tipo Comprobante" := vTipo;
            rFactRespaldo."Establecimiento Comprobante" := vEstablecimiento;
            rFactRespaldo."Punto Emision Comprobante" := vPuntoEmision;
            rFactRespaldo."Numero Secuencial Comprobante" := vSecuencia;
            rFactRespaldo."Fecha Comprobante" := vFecha;
            rFactRespaldo."No. Autorización Comprobante" := vNoAutorizacion;
            rFactRespaldo."Base No Objeto IVA" := vBaseNoSujeto;
            rFactRespaldo."Base Exenta IVA" := vBaseExenta;
            rFactRespaldo."Base 0" := vBase0;
            rFactRespaldo."Base X" := vBaseX;
            rFactRespaldo."Monto ICE" := vMontoICE;
            rFactRespaldo."Monto IVA" := vMontoIVA;
            rFactRespaldo."Tipo Proveedor Reembolso" := vTipoProveedor;

            rFactRespaldo.Insert(true);
        end;
        Window.Close;
    end;


    procedure UploadFile()
    var
        FileMgt: Codeunit "File Management";
        ClientFileName: Text[1024];
    begin
        /*         UploadedFileName := FileMgt.UploadFile(Text006, ExcelFileExtensionTok); */

        FileName := UploadedFileName;
    end;

    local procedure FileNameOnAfterValidate()
    begin
        UploadFile;
    end;


    procedure ValidaDupicacion(prmEstabl: Code[10]; prmPtoEmi: Code[10]; prmSec: Code[20]; prmAuto: Code[49])
    var
        rFacts: Record "Facturas de reembolso";
        Error001: Label 'El documento con los valores de: \  Establecimiento: %1\  Punto Emision: %2\  Secuencia: %3\  No. Autorización: %4\ya existe en la factura %5.';
    begin

        rFacts.Reset;
        rFacts.SetRange("Establecimiento Comprobante", prmEstabl);
        rFacts.SetRange("Punto Emision Comprobante", prmPtoEmi);
        rFacts.SetRange("Numero Secuencial Comprobante", prmSec);
        rFacts.SetRange("No. Autorización Comprobante", prmAuto);
        if rFacts.FindSet then
            Error(StrSubstNo(Error001, prmEstabl, prmPtoEmi, prmSec, prmAuto, rFacts."Document No."));
    end;
}

