report 56041 "Imp. Lineas Ped. Venta"
{
    // #14738  FAA   30/03/2015  Controlar que no se repitan productos al importar desde Excel

    ProcessingOnly = true;

    dataset
    {
        dataitem("Excel Buffer"; "Excel Buffer")
        {
            DataItemTableView = SORTING("Row No.", "Column No.") ORDER(Ascending);

            trigger OnAfterGetRecord()
            begin
                SL.Reset;
                SL.SetRange("Document Type", SL."Document Type"::Order);
                SL.SetRange("Document No.", NoPedido);
                if SL.FindLast then
                    NoLinea := SL."Line No."
                else
                    NoLinea += 10000;

                NoLinea += 10000;

                //Creamos la linea temporal
                SalesLine.Init;
                SalesLine."Document Type" := SalesLine."Document Type"::Order;
                SalesLine."Document No." := NoPedido;
                SalesLine."Line No." := NoLinea;
                SalesLine.Type := SalesLine.Type::Item;
                SalesLine."No." := "Cell Value as Text";
                SalesLine.Validate("No.");
                Next(1);
                Evaluate(SalesLine."Cantidad Solicitada", "Cell Value as Text");
                SalesLine.Validate("Cantidad Solicitada");
                SalesLine.Insert(true);
            end;

            trigger OnPreDataItem()
            begin
                DeleteAll;
                /*             OpenBook(FileName, Sheetname); */
                ReadSheet();
                SetRange(xlColID, 'A', 'C');

                CompararDatosDuplicados;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(FileName; FileName)
                {
                    Caption = 'File Name';
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    var
                        ExcelFileExtensionTok: Label '.xlsx', Locked = true;
                        FileMgt: Codeunit "File Management";
                    begin
                        /*           FileName := FileMgt.UploadFile(Text002, ExcelFileExtensionTok); */
                    end;
                }
                field(Sheetname; Sheetname)
                {
                    Caption = 'Sheet Name';
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    begin
                        /*                Sheetname := ExcelBuf.SelectSheetsName(FileName); */
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
        //NoPedido := CFuncSantillana.EnviaNoTransferencia;
    end;

    var
        rExcelBuffer: Record "Excel Buffer";
        FileName: Text[1024];
        Sheetname: Text[1024];
        NoProd: Code[20];
        wCantidad: Text[30];
        NoLinea: Integer;
        NoPedido: Code[20];
        CodAlmacenCliente: Code[20];
        CodAlmacenOrigen: Code[20];
        I: Integer;
        Text000: Label 'Analyzing Data...\\';
        Text001: Label 'Filters';
        Text002: Label 'Update Workbook';
        CodAlmacenTransito: Code[20];
        CFuncSantillana: Codeunit "Funciones Santillana";
        rSalesHeader: Record "Sales Header";
        rSalesLine: Record "Sales Line";
        SalesLine: Record "Sales Line";
        txtPrecio: Text[30];
        txtDescuento: Text[30];
        wPrecio: Decimal;
        wDescuento: Decimal;
        rSalesHeader1: Record "Sales Header";
        Pedido: Boolean;
        Factura: Boolean;
        rSalesInvHeader: Record "Sales Invoice Header";
        txt003: Label 'At least one Order/Invoice have this External document No. %1 Confirm that you want to import the order';
        rSalesLine1: Record "Sales Line";
        SL: Record "Sales Line";
        ExcelBuf: Record "Excel Buffer" temporary;
        rSalesLineTMP: Record "Sales Line" temporary;
        vComparar: Code[13];
        vComparar2: Code[13];


    procedure RecibeNoPedido(NoDocumento: Code[20])
    begin
        NoPedido := NoDocumento;
    end;


    procedure CompararDatosDuplicados()
    var
        Err001: Label 'El Producto con el %1 esta duplicado en la hoja que se Importa';
        vRowNo: Integer;
        vColumnNo: Integer;
        vUltimaFila: Integer;
        vUltimaFila2: Integer;
        vRowNo2: Integer;
    begin
        //#14738+++
        if rExcelBuffer.FindLast then
            vUltimaFila := rExcelBuffer."Row No.";
        vUltimaFila2 := vUltimaFila;
        vRowNo := 1;
        vRowNo2 := vRowNo + 1;
        vColumnNo := 1;

        FiltrarPosicion(vRowNo, vColumnNo);
        rExcelBuffer.FindFirst;
        vComparar := rExcelBuffer."Cell Value as Text";

        FiltrarPosicion(vRowNo2, vColumnNo);

        repeat
            repeat
                if rExcelBuffer.FindSet then begin
                    vComparar2 := rExcelBuffer."Cell Value as Text";
                    if vComparar2 = vComparar then
                        Error(Err001, vComparar2);
                    vRowNo2 := vRowNo2 + 1;
                    FiltrarPosicion(vRowNo2, vColumnNo);
                    vUltimaFila2 := vUltimaFila2 - 1;
                end;
            until vUltimaFila2 = 1;

            vUltimaFila := vUltimaFila - 1;
            vUltimaFila2 := vUltimaFila;
            vRowNo := vRowNo + 1;
            vRowNo2 := vRowNo + 1;

            FiltrarPosicion(vRowNo, vColumnNo);
            rExcelBuffer.FindFirst;
            vComparar := rExcelBuffer."Cell Value as Text";

            FiltrarPosicion(vRowNo2, vColumnNo);

        until vUltimaFila = 1;
        //#14738---
    end;


    procedure FiltrarPosicion(vFila: Integer; vColumna: Integer)
    begin
        //#14738
        rExcelBuffer.SetRange("Row No.", vFila);
        rExcelBuffer.SetRange("Column No.", vColumna);
    end;
}

