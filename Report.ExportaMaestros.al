report 76074 "_Exporta Maestros"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.", "Last Date Modified";

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                window.Update(1, Text004 + Customer."No.");
                window.Update(2, Round(Counter / counterTotal * 10000, 1));
                rConfPOS.Get;
                //fes mig rConfPOS.TESTFIELD("Cod. Tienda");
                rConfImportVentas.Reset;
                //fes mig rConfImportVentas.SETRANGE("Cod. Tienda",rConfPOS."Cod. Tienda");
                rConfImportVentas.SetRange(Direccion, 0);
                if rConfImportVentas.FindSet then
                    repeat
                    /*                      testfile.Create(rConfImportVentas."Ruta Importa Ventas" + Text005);
                                         testfile.CreateOutStream(teststreamOut);
                                         XMLPORT.Export(76015, teststreamOut, Customer);
                                         testfile.Close; */
                    until rConfImportVentas.Next = 0;
            end;

            trigger OnPostDataItem()
            begin
                window.Close;
            end;

            trigger OnPreDataItem()
            begin
                window.Open(txt001);
                counterTotal := Count;
            end;
        }
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Last Date Modified";

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                window.Update(1, Text002 + "No.");
                window.Update(2, Round(Counter / counterTotal * 10000, 1));
                rConfPOS.Get;
                //fes mig rConfPOS.TESTFIELD("Cod. Tienda");
                rConfImportVentas.Reset;
                //fes mig rConfImportVentas.SETRANGE("Cod. Tienda",rConfPOS."Cod. Tienda");
                rConfImportVentas.SetRange(Direccion, 0);
                if rConfImportVentas.FindSet then
                    repeat
                    /*                         testfile.Create(rConfImportVentas."Ruta Importa Ventas" + Text003);
                                            testfile.CreateOutStream(teststreamOut);
                                            XMLPORT.Export(76020, teststreamOut, Item);
                                            testfile.Close; */
                    until rConfImportVentas.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                window.Open(txt001);
                counterTotal := Count;
                Counter := 0;
            end;
        }
        dataitem("Sales Line Discount"; "Sales Line Discount")
        {
            RequestFilterFields = "Code", "Sales Code", "Starting Date", "Sales Type", Type;

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                window.Update(1, Text006 + Code);
                window.Update(2, Round(Counter / counterTotal * 10000, 1));

                rConfPOS.Get;
                //fes mig rConfPOS.TESTFIELD("Cod. Tienda");
                rConfImportVentas.Reset;
                //fes mig rConfImportVentas.SETRANGE("Cod. Tienda",rConfPOS."Cod. Tienda");
                rConfImportVentas.SetRange(Direccion, 0);
                if rConfImportVentas.FindSet then
                    repeat
                    /*                         testfile.Create(rConfImportVentas."Ruta Importa Ventas" + Text007);
                                            testfile.CreateOutStream(teststreamOut);
                                            XMLPORT.Export(76027, teststreamOut, "Sales Line Discount");
                                            testfile.Close; */
                    until rConfImportVentas.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                window.Open(txt001);
                counterTotal := Count;
                Counter := 0;
            end;
        }
        dataitem("Item Unit of Measure"; "Item Unit of Measure")
        {
            RequestFilterFields = "Item No.", "Code";

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                window.Update(1, Text008 + "Item No.");
                window.Update(2, Round(Counter / counterTotal * 10000, 1));

                rConfPOS.Get;
                //fes mig rConfPOS.TESTFIELD("Cod. Tienda");
                rConfImportVentas.Reset;
                //fes mig rConfImportVentas.SETRANGE("Cod. Tienda",rConfPOS."Cod. Tienda");
                rConfImportVentas.SetRange(Direccion, 0);
                if rConfImportVentas.FindSet then
                    repeat
                    /*        testfile.Create(rConfImportVentas."Ruta Importa Ventas" + Text009);
                           testfile.CreateOutStream(teststreamOut);
                           XMLPORT.Export(76017, teststreamOut, "Item Unit of Measure");
                           testfile.Close; */
                    until rConfImportVentas.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                window.Open(txt001);
                counterTotal := Count;
                Counter := 0;
            end;
        }
        dataitem("Item Cross Reference"; "Item Reference")
        {

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                window.Update(1, Text011 + "Item No.");
                window.Update(2, Round(Counter / counterTotal * 10000, 1));

                rConfPOS.Get;
                //fes mig rConfPOS.TESTFIELD("Cod. Tienda");
                rConfImportVentas.Reset;
                //fes mig rConfImportVentas.SETRANGE("Cod. Tienda",rConfPOS."Cod. Tienda");
                rConfImportVentas.SetRange(Direccion, 0);
                if rConfImportVentas.FindSet then
                    repeat
                    /*                      testfile.Create(rConfImportVentas."Ruta Importa Ventas" + Text010);
                                         testfile.CreateOutStream(teststreamOut);
                                         XMLPORT.Export(76030, teststreamOut, "Item Cross Reference");
                                         testfile.Close; */
                    until rConfImportVentas.Next = 0;
            end;

            trigger OnPostDataItem()
            begin
                window.Close;
            end;

            trigger OnPreDataItem()
            begin
                window.Open(txt001);
                counterTotal := Count;
                Counter := 0;
            end;
        }
        dataitem("Discounts Groups"; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = FILTER(1));

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                window.Update(1, Text012 + Format("Discounts Groups".Number));
                window.Update(2, Round(Counter / counterTotal * 10000, 1));

                rConfPOS.Get;
                //fes mig rConfPOS.TESTFIELD("Cod. Tienda");
                rConfImportVentas.Reset;
                //fes mig rConfImportVentas.SETRANGE("Cod. Tienda",rConfPOS."Cod. Tienda");
                rConfImportVentas.SetRange(Direccion, 0);
                if rConfImportVentas.FindSet then
                    repeat
                    /*                     testfile.Create(rConfImportVentas."Ruta Importa Ventas" + Text013);
                                        testfile.CreateOutStream(teststreamOut);
                                        XMLPORT.Export(76227, teststreamOut);
                                        testfile.Close; */
                    until rConfImportVentas.Next = 0;
            end;

            trigger OnPostDataItem()
            begin

                window.Close;
            end;

            trigger OnPreDataItem()
            begin

                window.Open(txt001);
                counterTotal := Count;
                Counter := 0;
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
        testfile: File;
        teststreamIn: InStream;
        rSalesInvHeader: Record "Sales Invoice Header";
        teststreamOut: OutStream;
        window: Dialog;
        Counter: Integer;
        counterTotal: Integer;
        rConfImportVentas: Record "Conf. Rutas Imp/Exp. Ventas";
        rConfPOS: Record "Configuracion General DsPOS";
        txt001: Label ' #1########### @2@@@@@@@@@@@@@';
        Text002: Label 'Item';
        Text003: Label 'Productos.xml';
        Text004: Label 'Customers';
        Text005: Label 'Clientes.xml';
        Text006: Label 'Lineas Descuento ';
        Text007: Label 'Lineas_Descuento.xml';
        Text008: Label 'Item Unit Of Measure';
        Text009: Label 'Item_Unit_Of_Measure.xml';
        Text010: Label 'Item_Cross_Ref.xml';
        Text011: Label 'Item Cross Ref.';
        Text012: Label 'Grupos Descuentos';
        Text013: Label 'Grupos_Descuentos.xml';
}

