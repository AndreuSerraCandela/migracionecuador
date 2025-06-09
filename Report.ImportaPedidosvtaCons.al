report 51006 "Importa Pedidos vta. Cons."
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Excel Buffer"; "Excel Buffer")
        {
            DataItemTableView = SORTING("Row No.", "Column No.") ORDER(Ascending);

            trigger OnAfterGetRecord()
            begin
                /*
                rSalesLine.RESET;
                rSalesLine.SETRANGE("Document No.",NoPedido);
                IF rSalesLine.FINDLAST THEN
                  NoLinea := rSalesLine."Line No."
                ELSE
                */
                NoLinea += 10000;

                //Creamos la linea temporal
                rSalesLineTMP.Init;
                rSalesLineTMP."Document Type" := rSalesLineTMP."Document Type"::Order;
                rSalesLineTMP."Document No." := NoPedido;
                rSalesLineTMP."Line No." := NoLinea;
                rSalesLineTMP.Type := 2;
                rSalesLineTMP."No." := "Cell Value as Text";
                rSalesLineTMP.Insert;
                Next(3);

            end;

            trigger OnPreDataItem()
            begin
                DeleteAll;
                /*                 OpenBook(FileName, Sheetname); */
                ReadSheet();
                SetRange(xlColID, 'A', 'F');
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

    trigger OnPostReport()
    begin
        //Eliminamos las lineas de productos que no esten en el documento excel
        rSalesLine.Reset;
        rSalesLine.SetRange("Document Type", 1);
        rSalesLine.SetRange("Document No.", NoPedido);
        if rSalesLine.FindSet then
            repeat
                rSalesLineTMP.Reset;
                rSalesLineTMP.SetRange(rSalesLineTMP."No.", rSalesLine."No.");
                if not rSalesLineTMP.FindFirst then begin
                    rSalesLine1.Get(rSalesLine."Document Type", rSalesLine."Document No.", rSalesLine."Line No.");
                    rSalesLine1.Delete;
                end;
            until rSalesLine.Next = 0;
    end;

    trigger OnPreReport()
    begin
        NoPedido := CFuncSantillana.EnviaNoTransferencia;
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
        rSalesLineTMP: Record "Sales Line Buffer" temporary;
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


    procedure RecibeNoPedido(NoDocumento: Code[20])
    begin
        NoPedido := NoDocumento;
    end;
}

