report 56047 "Imp. Lineas Cupon"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Excel Buffer"; "Excel Buffer")
        {
            DataItemTableView = SORTING("Row No.", "Column No.") ORDER(Ascending);

            trigger OnAfterGetRecord()
            begin
                CreaCupLot.Init;
                CreaCupLot.Validate("Cod. Colegio", "Cell Value as Text");
                if rContacto.Get(CreaCupLot."Cod. Colegio") then begin
                    NombreColegio := rContacto.Name;
                    DescuentoAColegio := rContacto."% Descuento Cupon";
                    //CodVendedor := rContacto."Salesperson Code";
                    if rSalesperson.Get(CodVendedor) then
                        NombreVendedor := rSalesperson.Name
                    else
                        NombreVendedor := '';
                end;

                Next(1);
                CreaCupLot.Validate("Cod. Nivel", "Cell Value as Text");
                Next(1);
                CreaCupLot.Validate("Cod. Promotor", "Cell Value as Text");
                if rSalesperson.Get(CreaCupLot."Cod. Promotor") then
                    NombreVendedor := rSalesperson.Name
                else
                    NombreVendedor := '';


                Next(1);
                CreaCupLot.Validate("Cod. Grado", "Cell Value as Text");

                if DatAux.Get(DatAux."Tipo registro"::Grados, CreaCupLot."Cod. Grado") then
                    DescGrado := DatAux.Descripcion
                else
                    DescGrado := '';

                Next(1);
                Evaluate(CreaCupLot."% Descuento Colegio", "Cell Value as Text");
                CreaCupLot.Validate("% Descuento Colegio");
                Next(1);
                Evaluate(CreaCupLot."% Descuento Padre", "Cell Value as Text");
                CreaCupLot.Validate("% Descuento Padre");
                Next(1);
                CreaCupLot.Validate("Cod. Producto", "Cell Value as Text");
                Next(1);
                CreaCupLot.Validate(Descripcion, "Cell Value as Text");
                CreaCupLot.Cantidad := 1;
                CreaCupLot.Insert;
            end;

            trigger OnPreDataItem()
            begin
                DeleteAll;
                /*             OpenBook(FileName, Sheetname); */
                ReadSheet();
                SetRange(xlColID, 'A', 'H');
                Contador := 0;
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
                        FileMgt: Codeunit "File Management";
                        ExcelFileExtensionTok: Label '.xlsx', Locked = true;
                    begin
                        /*          FileName := FileMgt.UploadFile(Text002, ExcelFileExtensionTok); */
                    end;
                }
                field(Sheetname; Sheetname)
                {
                    Caption = 'Sheet Name';
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    begin
                        /*               Sheetname := ExcelBuf.SelectSheetsName(FileName); */
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

    trigger OnPostReport()
    begin
        /*
        //Eliminamos las lineas de productos que no esten en el documento excel
        rSalesLine.RESET;
        rSalesLine.SETRANGE("Document Type",1);
        rSalesLine.SETRANGE("Document No.",NoPedido);
        IF rSalesLine.FINDSET THEN
          REPEAT
            rSalesLineTMP.RESET;
            rSalesLineTMP.SETRANGE(rSalesLineTMP."No.",rSalesLine."No.");
            IF NOT rSalesLineTMP.FINDFIRST THEN
              BEGIN
                rSalesLine1.GET(rSalesLine."Document Type",rSalesLine."Document No.",rSalesLine."Line No.");
                rSalesLine1.DELETE;
              END;
          UNTIL rSalesLine.NEXT = 0;
        */

    end;

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
        ExcelBuf: Record "Excel Buffer";
        CreaCupLot: Record "Crear Cupon por Lote.";
        ValidoDesde: Date;
        ValidoHasta: Date;
        Contador: Integer;
        CodColegio: Code[20];
        CodVendedor: Code[20];
        NombreVendedor: Text[100];
        ValidaDesde: Date;
        ValidaHasta: Date;
        GradoAlumno: Text[30];
        DescuentoAColegio: Decimal;
        DescAPadre: Decimal;
        AnoEscolar: Text[30];
        NombreColegio: Text[100];
        rSalesperson: Record "Salesperson/Purchaser";
        rContacto: Record Contact;
        CantidadCupones: Integer;
        I: Integer;
        rCabCupon: Record "Cab. Cupon.";
        rLinCupon: Record "Lin. Cupon.";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        CounterOK: Integer;
        rConfEmpresa: Record "Config. Empresa";
        rCreaCupLot: Record "Crear Cupon por Lote";
        rCabCupon1: Record "Cab. Cupon.";
        rAnoEscolar: Record "Año Escolar.";
        rCrearCuponPorLote: Record "Crear Cupon por Lote";
        NoSeries: Code[20];
        rVendPorColegio: Record "Vendedores por Colegio";
        txtDescripcion: Text[250];
        txtDescrAnulacion: Text[250];
        cuFunSantillana: Codeunit "Funciones Santillana";
        Camp: Record Campaign;
        Adopcion: Code[20];
        ConfAPS: Record "Commercial Setup";
        AH: Record "Colegio - Adopciones Cab";
        AL: Record "Colegio - Adopciones Detalle";
        CCPL: Record "Crear Cupon por Lote.";
        DescGrado: Text[50];
        DatAux: Record "Datos auxiliares";
        ImportaLineas: Report "Imp. Lineas Cupon";


    procedure RecibeNoPedido(NoDocumento: Code[20])
    begin
    end;
}

