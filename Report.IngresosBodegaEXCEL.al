report 55033 "Ingresos Bodega (EXCEL)"
{
    // Proyecto: Implementacion Microsoft Dynamics Nav
    // AMS     : Agustin Mendez
    // GRN     : Guillermo Roman
    // AML     : Toni Moll
    // ------------------------------------------------------------------------
    // No.     Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // #967    11/12/2013      AML         #967 - Formato ingresos Bodega ECUADOR
    // #10097  21/01/2015      MOI         Para la version 2013R2 se tiene que usar CreateBookAndOpenExcel, se comentan las lineas antiguas.

    ProcessingOnly = true;

    dataset
    {
        dataitem(LinRegistradas; "Posted Whse. Receipt Line")
        {
            DataItemTableView = SORTING("Nº Documento Proveedor", "Posting Date", "Location Code", "Nº Proveedor") ORDER(Ascending);
            RequestFilterFields = "Posting Date", "Location Code", "Nº Proveedor";

            trigger OnAfterGetRecord()
            var
                rVend: Record Vendor;
                rProd: Record Item;
            begin


                if not ("Source Document" = "Source Document"::"Purchase Order") then
                    CurrReport.Skip;

                if LinRegistradas."Nº Documento Proveedor" = '' then
                    EnterCell(Row, 2, text015, false, false, false)
                else
                    EnterCell(Row, 2, LinRegistradas."Nº Documento Proveedor", false, false, false);

                if rVend.Get("Nº Proveedor") then
                    EnterCell(Row, 3, rVend.Name, false, false, false);

                EnterCell(Row, 4, LinRegistradas."Source No.", false, false, false);

                if rProd.Get("Item No.") then begin
                    EnterCell(Row, 5, rProd.Description, false, false, false);
                    EnterCell(Row, 6, rProd."No.", false, false, false);
                end;

                EnterCell(Row, 7, StrSubstNo('%1', LinRegistradas.Quantity), false, false, false);
                EnterCell(Row, 8, "No.", false, false, false);
                EnterCell(Row, 9, StrSubstNo('%1', "Posting Date"), false, false, false);

                Row += 1;
                Regs += 1;

                wDialog.Update(1, StrSubstNo('%1', Regs));
            end;

            trigger OnPostDataItem()
            begin
                wDialog.Close;

                //MOI - 23/01/2015 (#10097):Inicio
                /*                ExcelBuffer.CreateBookAndOpenExcel('', text002, text003, CompanyName, UserId); */
                //MOI - 23/01/2015 (#10097):Fin

                /*MOI - 23/01/2015 (#10097):Inicio
                ExcelBuffer.CreateBook(text002);
                ExcelBuffer.UpdateBook(text002,text003);
                ExcelBuffer.GiveUserControl();
                MOI - 23/01/2015 (#10097):Fin*/

                Clear(ExcelBuffer);

            end;

            trigger OnPreDataItem()
            begin
                if GetFilter("Posting Date") = '' then
                    Error(text001);

                if GetFilter("Location Code") <> '' then
                    rLoc.Get(GetFilter("Location Code"));

                DateFrom := GetRangeMin("Posting Date");
                DateTo := GetRangeMax("Posting Date");

                wDialog.Open(text004);

                ExcelBuffer.Reset;
                ExcelBuffer.DeleteAll;
                Clear(ExcelBuffer);

                EnterCell(3, 2, text003, true, false, false);
                EnterCell(4, 2, StrSubstNo(text005, DateFrom, DateTo), false, false, false);
                EnterCell(5, 2, StrSubstNo(text006, rLoc.Name), false, false, false);
                EnterCell(6, 2, CompanyName, false, false, false);

                EnterCell(8, 2, text007, true, false, true);
                EnterCell(8, 3, text008, true, false, true);
                EnterCell(8, 4, text009, true, false, true);
                EnterCell(8, 5, text010, true, false, true);
                EnterCell(8, 6, text011, true, false, true);
                EnterCell(8, 7, text012, true, false, true);
                EnterCell(8, 8, text013, true, false, true);
                EnterCell(8, 9, text014, true, false, true);

                Row := 9;
                Regs := 0;
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
        text001: Label 'Debe especificar una fecha';
        ExcelBuffer: Record "Excel Buffer" temporary;
        Row: Integer;
        text002: Label 'Info';
        text003: Label 'Reporte Ingresos Bodega';
        text004: Label 'Recopilando datos #1#####';
        wDialog: Dialog;
        text005: Label 'Periodo: %1..%2';
        DateFrom: Date;
        DateTo: Date;
        text006: Label 'Bodega: %1';
        rLoc: Record Location;
        text007: Label '# Documento Proveedor';
        text008: Label 'Proveedor';
        text009: Label 'CP ';
        text010: Label 'Producto Recibido';
        text011: Label 'Codigo Interno';
        text012: Label 'Cant. Física Recibida';
        text013: Label 'Número Ingreso NAV';
        text014: Label 'Fecha Ingreso';
        text015: Label 'SIN NUMERO';
        text016: Label 'Espere';
        Regs: Integer;

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; Italic: Boolean; UnderLine: Boolean)
    begin
        ExcelBuffer.Init;
        ExcelBuffer.Validate("Row No.", RowNo);
        ExcelBuffer.Validate("Column No.", ColumnNo);
        ExcelBuffer."Cell Value as Text" := CellValue;
        ExcelBuffer.Formula := '';
        ExcelBuffer.Bold := Bold;
        ExcelBuffer.Italic := Italic;
        ExcelBuffer.Underline := UnderLine;
        ExcelBuffer.Insert;
    end;
}

