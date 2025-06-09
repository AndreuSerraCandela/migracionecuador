report 55010 "Registro Datos Crediticios"
{
    // Proyecto: Microsoft Dynamics Nav
    // ------------------------------------------------------------------------------
    // FES   : Fausto Serrata
    // ------------------------------------------------------------------------------
    // No.       Firma         Fecha           Descripción
    // ------------------------------------------------------------------------------
    // 
    // FAA 20/02/2015 Se han cambiado las variables CODE de 20 a 30, por solicitud del cliente.
    // MOI - 23/02/2015: Solo los documentos pendientes.
    // MOI - 26/03/2015: Se han solicitado una serie de cambios
    //                   La columna 15 se tiene que informar con el campo Importe Pendiente de Mov Cliente.
    //                   La columna 36 se tiene que informar con la suma de los movimientos conciliados.
    //                   La columna 37 se tiene que informar con la fecha del ultimo movimiento conciliado.
    //                   A la funcion DatosEndeudamiento se le añade el parametro de la fecha de cancelacion.
    //                   Se crea la funcion UltimoDiaMesAnterior
    //                   Se crea un segundo dataitem para poder buscar
    // MOI - 07/04/2015: 1.Se tiene que filtrar los movimientos por las fecha de registro, para que no salgan los datos erroneos.
    //                   2.En el caso de que no exista la factura los datos los tiene que obtener de MovCliente (si existe).
    //                   3.No debe saltar el movimiento del cliente si no existe la factura.
    //                   4.En el caso de no encontrar el CIF(RUC, Cedula), lo va a buscar en la ficha del cliente.
    // MOI - 08/04/2015: 1. Se borran todos los comentarios de codigo.
    //                   2. Se añade un nuevo dataitem que servirá para filtrar los movimientos del mes actual.
    //                   3. Se crea la funcion EsACredito que nos indica si el movimiento de cliente ha sido pagado a credito.
    // MOI - 09/04/2015: Se tiene que filtrar por el Document Date y no por el Posting Date.
    // MOI - 23/04/2015: Se crea la funcion que obtiene la fecha de vencimiento.
    // #25300  02/07/2015  MOI   En de que no exista la factura el nombre del cliente lo tiene que obtener del MovCliente (si existe).
    //                           2 Si la forma de pago esta informada hay que poner el valor que le corresponda.
    // 
    // #45300  09/02/2016  CAT 1- Identificación del sujeto, se excluyen las empresas relacionadas (santillana) y las empresas publicas
    //                         2- Valor de la Operación, se incluye en el request la posibilidad de establecer un valor mínimo de operación.
    //                         3- Saldo de Operación: importe pendiente a fecha referencia.
    //                         4- Periodicidad de Pago debe ser igual al Plazo Operación.
    //                         5- Cuota del credito incluye pagos y notas de credito del periodo.
    //                         6- Fecha cancelación solo debe constar las efectuadas en el periodo.
    // 
    // #45300 JPT 07/10/2016 "Cuota del Crédito: solo se debe incluir Pagos. Lizeth Chiliquinga
    // #45300 JPT 25/10/2016 "Cuota del Crédito: Se vuelven a cambiar las directrices, ahora incluye notas de credito. Lizeth Chiliquinga
    // #45300 JPT 25/10/2016 Cambiamos las directrices para determinar la clase Sujeto.
    //                       "Fecha de Cancelación: Solo debe constar fechas de los pagos y notas de crédito efectuados en el mes.
    // #45300 JPT 27/12/16 Cuota del Crédito: No deben salir valores en negativo. Chiliquinga Rodriguez, …ngela Lizeth
    // 
    // 
    // 001     FES           22-07-2021     SANTINAV-348: Optimizacion reporte de venta a credito - DYN-04019-T5Z3.

    ApplicationArea = Basic, Suite;
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code");
            dataitem(MovCliente; "Cust. Ledger Entry")
            {
                DataItemLink = "Entry No." = FIELD("Entry No.");
                DataItemTableView = SORTING("Entry No.") ORDER(Ascending);

                trigger OnAfterGetRecord()
                var
                    PlazoOpMovCli: Integer;
                begin
                    MovCliente.CalcFields("Amount (LCY)", "Remaining Amt. (LCY)");

                    if MovCliente."Amount (LCY)" = 0 then
                        CurrReport.Skip;

                    //001+
                    //Excluir Saldo de Operacion = 0
                    if MovCliente."Remaining Amt. (LCY)" = 0 then
                        CurrReport.Skip;

                    //Excluir documentos sin No. Operación
                    if MovCliente."No. Comprobante Fiscal" = '' then
                        CurrReport.Skip;

                    //Excluir documentos si plazo operacion es 0 (facturas de contado)
                    if (getFechaVencimiento(MovCliente) <> 0D) and (MovCliente."Posting Date" <> 0D) then begin
                        PlazoOpMovCli := getFechaVencimiento(MovCliente) - MovCliente."Posting Date";
                        if PlazoOpMovCli = 0 then
                            CurrReport.Skip;
                    end;
                    //001-

                    InsertLine(MovCliente);
                end;

                trigger OnPreDataItem()
                begin
                    MovCliente.SetFilter("Date Filter", '<=%1', FechaReferencia);
                end;
            }

            trigger OnAfterGetRecord()
            var
                SIH: Record "Sales Invoice Header";
                PlazoOpCLE: Integer;
            begin
                Ventana.Update(1, "Cust. Ledger Entry"."Document No.");

                //+#45300
                if not ValidaSujeto("Cust. Ledger Entry") then
                    CurrReport.Skip;
                //-#45300

                //+#45300
                if not ValidaValorOperacion("Cust. Ledger Entry") then
                    CurrReport.Skip;
                //-#45300

                //001+
                //Excluir documentos si plazo operacion es 0 (facturas de contado)
                if (getFechaVencimiento("Cust. Ledger Entry") <> 0D) and ("Cust. Ledger Entry"."Posting Date" <> 0D) then begin
                    PlazoOpCLE := getFechaVencimiento("Cust. Ledger Entry") - "Cust. Ledger Entry"."Posting Date";
                    if PlazoOpCLE = 0 then
                        CurrReport.Skip;
                end;

                //Excluir documentos sin No. Operación
                if "Cust. Ledger Entry"."No. Comprobante Fiscal" = '' then
                    CurrReport.Skip;
                //001-
            end;

            trigger OnPostDataItem()
            begin
                //Ventana.CLOSE;
            end;

            trigger OnPreDataItem()
            var
                rEmp: Record "Company Information";
            begin

                if FechaReferencia = 0D then
                    Error(Err001);

                if FechaReferencia > Today then
                    Error(Err002);

                if wValorOperacion < 0 then
                    Error(Err003);

                //MOI - 07/04/2015:Inicio
                //MOI - 09/08/2015:Inicio
                "Cust. Ledger Entry".SetRange("Posting Date", 0D, UltimoDiaMesAnterior(FechaReferencia));
                "Cust. Ledger Entry".SetRange("Cust. Ledger Entry"."Document Date", 0D, UltimoDiaMesAnterior(FechaReferencia));
                //MOI - 09/08/2015:Fin
                //MOI - 07/04/2015:Fin

                //MOI - 26/03/2015:Inicio
                "Cust. Ledger Entry".SetFilter("Date Filter", '<=%1', UltimoDiaMesAnterior(FechaReferencia));
                //MOI - 26/03/2015:Fin
                // JPT 25/10/16 incluimos reembolsos en el filtro
                //"Cust. Ledger Entry".SETRANGE("Document Type","Cust. Ledger Entry"."Document Type"::Invoice);
                "Cust. Ledger Entry".SetFilter("Document Type", '%1|%2', "Cust. Ledger Entry"."Document Type"::Invoice, "Cust. Ledger Entry"."Document Type"::Refund);

                Clear(CodigoEntidad);
                rEmp.Get;
                rEmp.TestField("Código otorgado por DINARDAP");
                CodigoEntidad := rEmp."Código otorgado por DINARDAP";

                //MOI - 23/02/2015:Inicio
                //"Cust. Ledger Entry".SETRANGE("Cust. Ledger Entry".Open,TRUE);
                "Cust. Ledger Entry".CalcFields("Remaining Amt. (LCY)");
                "Cust. Ledger Entry".SetFilter("Cust. Ledger Entry"."Remaining Amt. (LCY)", '>%1', 0);     //001+-
                //MOI - 23/02/2015:Fin
                Ventana.Open(Text001);
            end;
        }
        dataitem(MovClienteActual; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code") ORDER(Ascending);

            trigger OnAfterGetRecord()
            var
                lrMovClienteLiquidado: Record "Cust. Ledger Entry";
                PlazoOpMovCliAct: Integer;
            begin
                Ventana.Update(1, MovClienteActual."Document No.");

                MovClienteActual.CalcFields("Amount (LCY)", "Remaining Amt. (LCY)");

                if MovClienteActual."Amount (LCY)" = 0 then
                    CurrReport.Skip;

                //001+
                if MovClienteActual."Remaining Amt. (LCY)" = 0 then  //Excluir Saldo de Operacion = 0
                    CurrReport.Skip;

                //Excluir documentos sin No. Operación
                if MovClienteActual."No. Comprobante Fiscal" = '' then
                    CurrReport.Skip;

                //Excluir documentos si plazo operacion es 0 (facturas de contado)
                if (getFechaVencimiento(MovClienteActual) <> 0D) and (MovClienteActual."Posting Date" <> 0D) then begin
                    PlazoOpMovCliAct := getFechaVencimiento(MovClienteActual) - MovClienteActual."Posting Date";
                    if PlazoOpMovCliAct = 0 then
                        CurrReport.Skip;
                end;
                //001-

                //+#45300
                if not ValidaSujeto(MovClienteActual) then
                    CurrReport.Skip;
                //-#45300

                //+#45300
                if not ValidaValorOperacion(MovClienteActual) then
                    CurrReport.Skip;
                //-#45300

                if MovClienteActual."Amount (LCY)" = MovClienteActual."Remaining Amt. (LCY)" then
                    InsertLine(MovClienteActual)
                else
                    if EsACredito(MovClienteActual) then
                        InsertLine(MovClienteActual);
            end;

            trigger OnPostDataItem()
            begin
                Ventana.Close;
            end;

            trigger OnPreDataItem()
            begin
                //MOI - 09/08/2015:Inicio
                MovClienteActual.SetRange(MovClienteActual."Posting Date", PrimerDiaMesActual(FechaReferencia), FechaReferencia);
                MovClienteActual.SetRange(MovClienteActual."Document Date", PrimerDiaMesActual(FechaReferencia), FechaReferencia);
                //MOI - 09/08/2015:Fin
                // JPT 25/10/16 incluimos reembolsos en el filtro
                // MovClienteActual.SETRANGE(MovClienteActual."Document Type",MovClienteActual."Document Type"::Invoice);
                MovClienteActual.SetFilter("Document Type", '%1|%2', MovClienteActual."Document Type"::Invoice, MovClienteActual."Document Type"::Refund);
                MovClienteActual.SetFilter(MovClienteActual."Date Filter", '<=%1', FechaReferencia);

                //MovClienteActual.SETRANGE(MovClienteActual."Document No.",'VFR-102714');   //fes para probar
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(FechaReferencia; FechaReferencia)
                {
                ApplicationArea = All;
                    Caption = 'Fecha de Datos';
                }
                field(wValorOperacion; wValorOperacion)
                {
                ApplicationArea = All;
                    Caption = 'Valor Operación (Mínimo)';
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

        /*         TempExcelBuffer.CreateBook('', 'DatosCreditos');
                TempExcelBuffer.WriteSheet('DatosCreditos', CompanyName, UserId);
                TempExcelBuffer.CloseBook;
                TempExcelBuffer.OpenExcel;

                TempExcelBuffer.DownloadAndOpenExcel; */

        //TempExcelBuffer.UpdateBookStream(Instr,'DatosCreditos',TRUE);
    end;

    trigger OnPreReport()
    begin
        InsertHeader;
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        Row: Integer;
        FechaReferencia: Date;
        Text001: Label 'Generando datos ... \ Factura #1###########';
        Ventana: Dialog;
        Err001: Label 'No ha ingresado la fecha.';
        Err002: Label 'La fecha ingresada no es correcta.';
        TipoCelda: Option Number,Text,Date,Time;
        CodigoEntidad: Text[30];
        wValorOperacion: Decimal;
        Err003: Label 'El valor de la operación (mínimo) ingresado no puede ser inferior a 0.';
        Length: Integer;
        Instr: InStream;


    procedure InsertHeader()
    begin

        Row := 1;

        EnterValue(Row, 1, 'REGISTRO DE', true, false, TipoCelda::Text);

        Row += 1;
        EnterValue(Row, 1, 'DATOS CREDITICIOS', true, false, TipoCelda::Text);

        Row += 2;
        EnterValue(Row, 1, 'A Fecha: ' + Format(FechaReferencia), true, false, TipoCelda::Text);
        EnterValue(Row, 3, 'Valor mínimo operación: ' + Format(wValorOperacion), true, false, TipoCelda::Text);

        Row += 2;

        EnterValue(Row, 1, 'Código de la Entidad', true, false, TipoCelda::Text);
        EnterValue(Row, 2, 'Fecha de Datos', true, false, TipoCelda::Text);
        EnterValue(Row, 3, 'Tipo de Identificación del Sujeto', true, false, TipoCelda::Text);
        EnterValue(Row, 4, 'Identificación del Sujeto', true, false, TipoCelda::Text);
        EnterValue(Row, 5, 'Nombres y Apellidos del Sujeto', true, false, TipoCelda::Text);
        EnterValue(Row, 6, 'Clase del Sujeto', true, false, TipoCelda::Text);
        EnterValue(Row, 7, 'Provincia', true, false, TipoCelda::Text);
        EnterValue(Row, 8, 'Cantón', true, false, TipoCelda::Text);
        EnterValue(Row, 9, 'Parroquia', true, false, TipoCelda::Text);
        EnterValue(Row, 10, 'Sexo', true, false, TipoCelda::Text);
        EnterValue(Row, 11, 'Estado Civil', true, false, TipoCelda::Text);
        EnterValue(Row, 12, 'Origen de Ingresos', true, false, TipoCelda::Text);
        EnterValue(Row, 13, 'Número de Operación', true, false, TipoCelda::Text);
        EnterValue(Row, 14, 'Valor de la Operación', true, false, TipoCelda::Text);
        EnterValue(Row, 15, 'Saldo de Operación', true, false, TipoCelda::Text);
        EnterValue(Row, 16, 'Fecha de Concesión', true, false, TipoCelda::Text);
        EnterValue(Row, 17, 'Fecha de Vencimiento', true, false, TipoCelda::Text);
        EnterValue(Row, 18, 'Fecha que es Exigible', true, false, TipoCelda::Text);
        EnterValue(Row, 19, 'Plazo Operación (días)', true, false, TipoCelda::Text);
        EnterValue(Row, 20, 'Periodicidad de Pago (días)', true, false, TipoCelda::Text);
        EnterValue(Row, 21, 'Días de Morosidad', true, false, TipoCelda::Text);
        EnterValue(Row, 22, 'Monto de Morosidad', true, false, TipoCelda::Text);
        EnterValue(Row, 23, 'Monto de Interés en Mora', true, false, TipoCelda::Text);
        EnterValue(Row, 24, 'Valor por vencer de 1 a 30 días', true, false, TipoCelda::Text);
        EnterValue(Row, 25, 'Valor por vencer de 31 a 90 días', true, false, TipoCelda::Text);
        EnterValue(Row, 26, 'Valor por vencer de 91 a 180 días', true, false, TipoCelda::Text);
        EnterValue(Row, 27, 'Valor por vencer de 181 a 360 días', true, false, TipoCelda::Text);
        EnterValue(Row, 28, 'Valor por vencer de mas 360 días', true, false, TipoCelda::Text);
        EnterValue(Row, 29, 'Valor vencido 1 A 30 dias', true, false, TipoCelda::Text);
        EnterValue(Row, 30, 'Valor vencido de 31 a 90 días', true, false, TipoCelda::Text);
        EnterValue(Row, 31, 'Valor vencido de 91 a 180  días', true, false, TipoCelda::Text);
        EnterValue(Row, 32, 'Valor vencido de 181 a 360 días', true, false, TipoCelda::Text);
        EnterValue(Row, 33, 'Valor vencido de más de 360 días', true, false, TipoCelda::Text);
        EnterValue(Row, 34, 'Valor en Demanda Judicial', true, false, TipoCelda::Text);
        EnterValue(Row, 35, 'Cartera Castigada', true, false, TipoCelda::Text);
        EnterValue(Row, 36, 'Cuota del Crédito', true, false, TipoCelda::Text);
        EnterValue(Row, 37, 'Fecha de Cancelación', true, false, TipoCelda::Text);
        EnterValue(Row, 38, 'Forma de Cancelación', true, false, TipoCelda::Text);
    end;


    procedure EnterValue(Row: Integer; Col: Integer; Value: Text[150]; Bold: Boolean; Underline: Boolean; CellType: Option Number,Text,Date,Time)
    begin
        TempExcelBuffer.Init;
        TempExcelBuffer.Validate("Row No.", Row);
        TempExcelBuffer.Validate("Column No.", Col);
        TempExcelBuffer.Validate("Cell Value as Text", Value);
        TempExcelBuffer.Bold := Bold;
        TempExcelBuffer.Underline := Underline;
        TempExcelBuffer."Cell Type" := CellType;
        if TempExcelBuffer."Cell Type" = TempExcelBuffer."Cell Type"::Number then
            TempExcelBuffer.NumberFormat := '#,##0.00';

        TempExcelBuffer.Insert(true);
    end;


    procedure InsertLine(pMovCliente: Record "Cust. Ledger Entry")
    var
        ValorOperacion: Decimal;
        SaldoOperacion: Decimal;
        FechaConcesion: Date;
        FechaVencimiento: Date;
        FechaExigible: Date;
        PlazoOperacion: Integer;
        PeriocidadPago: Integer;
        DiasMorosidad: Integer;
        MontoMorosidad: Decimal;
        MontoInteresMora: Decimal;
        ValorVencer30D: Decimal;
        ValorVencer90D: Decimal;
        ValorVencer180D: Decimal;
        ValorVencer360D: Decimal;
        ValorVencerMas360D: Decimal;
        ValorVencido30D: Decimal;
        ValorVencido90D: Decimal;
        ValorVencido180D: Decimal;
        ValorVencido360D: Decimal;
        ValorVencidoMas360D: Decimal;
        ValorDemandaJudicial: Decimal;
        CarteraCastigada: Decimal;
        CuotaCredito: Decimal;
        TipoIdSujeto: Code[1];
        IdSujeto: Code[30];
        NombreSujeto: Text[150];
        ClaseSujeto: Code[1];
        Provincia: Code[2];
        Canton: Code[2];
        Parroquia: Code[2];
        Sexo: Code[1];
        EstadoCivil: Code[1];
        Origen: Code[1];
        NoComprobante: Code[30];
        ldtFechaCancelacion: Date;
        ltFormaCancelacion: Text[1];
    begin

        //Obtener datos del movimiento

        DatosFactura(pMovCliente, NoComprobante);

        DatosCliente(pMovCliente, TipoIdSujeto, IdSujeto, NombreSujeto, ClaseSujeto, Provincia, Canton, Parroquia, Sexo,
                     EstadoCivil, Origen);

        DatosEndeudamiento(pMovCliente, ValorOperacion, SaldoOperacion, FechaConcesion, FechaVencimiento, FechaExigible,
                           PlazoOperacion, PeriocidadPago, DiasMorosidad, MontoMorosidad, MontoInteresMora, ValorVencer30D,
                           ValorVencer90D, ValorVencer180D, ValorVencer360D, ValorVencerMas360D, ValorVencido30D, ValorVencido90D,
                           ValorVencido180D, ValorVencido360D, ValorVencidoMas360D, ValorDemandaJudicial, CarteraCastigada, CuotaCredito, ldtFechaCancelacion, ltFormaCancelacion);

        Row += 1;

        //Grabamos los datos
        EnterValue(Row, 1, CodigoEntidad, false, false, TipoCelda::Text);                        //Columna A  - Código de la Entidad
        EnterValue(Row, 2, Format(FechaReferencia), false, false, TipoCelda::Date);              //Columna B  - Fecha Datos

        EnterValue(Row, 3, TipoIdSujeto, false, false, TipoCelda::Text);                         //Columna C  - Tipo de Identificación del Sujeto
        EnterValue(Row, 4, IdSujeto, false, false, TipoCelda::Text);                             //Columna D  - Identificación del Sujeto
        EnterValue(Row, 5, NombreSujeto, false, false, TipoCelda::Text);                         //Columna E  - Nombres y Apellidos del Sujeto
        EnterValue(Row, 6, ClaseSujeto, false, false, TipoCelda::Text);                          //Columna F  - Clase del Sujeto
        EnterValue(Row, 7, Provincia, false, false, TipoCelda::Text);                            //Columna G  - Provincia
        EnterValue(Row, 8, Canton, false, false, TipoCelda::Text);                               //Columna H  - Cantón
        EnterValue(Row, 9, Parroquia, false, false, TipoCelda::Text);                            //Columna I  - Parroquia
        EnterValue(Row, 10, Sexo, false, false, TipoCelda::Text);                                //Columna J  - Sexo
        EnterValue(Row, 11, EstadoCivil, false, false, TipoCelda::Text);                         //Columna K  - Estado Civil
        EnterValue(Row, 12, Origen, false, false, TipoCelda::Text);                              //Columna L  - Origen Ingresos

        EnterValue(Row, 13, NoComprobante, false, false, TipoCelda::Text);                       //Columna M  - Número de Operación
        EnterValue(Row, 14, Format(ValorOperacion), false, false, TipoCelda::Number);            //Columna N  - Valor de la Operación
        EnterValue(Row, 15, Format(SaldoOperacion), false, false, TipoCelda::Number);            //Columna O  - Saldo de Operación
        EnterValue(Row, 16, Format(FechaConcesion), false, false, TipoCelda::Date);              //Columna P  - Fecha de Concesión
        EnterValue(Row, 17, Format(FechaVencimiento), false, false, TipoCelda::Date);            //Columna Q  - Fecha de Vencimiento
        EnterValue(Row, 18, Format(FechaExigible), false, false, TipoCelda::Date);               //Columna R  - Fecha que es Exigible
        EnterValue(Row, 19, Format(PlazoOperacion), false, false, TipoCelda::Text);              //Columna S  - Plazo Operación (días)
        EnterValue(Row, 20, Format(PeriocidadPago), false, false, TipoCelda::Text);              //Columna T  - Periodicidad de Pago (días)
        EnterValue(Row, 21, Format(DiasMorosidad), false, false, TipoCelda::Text);               //Columna U  - Días de Morosidad
        EnterValue(Row, 22, Format(MontoMorosidad), false, false, TipoCelda::Number);            //Columna V  - Monto de Morosidad
        EnterValue(Row, 23, Format(MontoInteresMora), false, false, TipoCelda::Number);          //Columna W  - Monto de Interés en Mora
        EnterValue(Row, 24, Format(ValorVencer30D), false, false, TipoCelda::Number);            //Columna X  - Valor por vencer de 1 a 30 días
        EnterValue(Row, 25, Format(ValorVencer90D), false, false, TipoCelda::Number);            //Columna Y  - Valor por vencer de 31 a 90 días
        EnterValue(Row, 26, Format(ValorVencer180D), false, false, TipoCelda::Number);           //Columna Z  - Valor por vencer de 91 a 180 días
        EnterValue(Row, 27, Format(ValorVencer360D), false, false, TipoCelda::Number);           //Columna AA - Valor por vencer de 181 a 360 días
        EnterValue(Row, 28, Format(ValorVencerMas360D), false, false, TipoCelda::Number);        //Columna AB - Valor por vencer de mas 360 días
        EnterValue(Row, 29, Format(ValorVencido30D), false, false, TipoCelda::Number);           //Columna AC - Valor vencido 1 A 30 dias
        EnterValue(Row, 30, Format(ValorVencido90D), false, false, TipoCelda::Number);           //Columna AD - Valor vencido de 31 a 90 días
        EnterValue(Row, 31, Format(ValorVencido180D), false, false, TipoCelda::Number);          //Columna AE - Valor vencido de 91 a 180  días
        EnterValue(Row, 32, Format(ValorVencido360D), false, false, TipoCelda::Number);          //Columna AF - Valor vencido de 181 a 360 días
        EnterValue(Row, 33, Format(ValorVencidoMas360D), false, false, TipoCelda::Number);       //Columna AG - Valor vencido de más de 360 días

        //001+
        //EnterValue(Row,34,'Valor en Demanda Judicial'),FALSE,FALSE,TipoCelda::Number);
        //EnterValue(Row,35,'Cartera Castigada'),FALSE,FALSE,TipoCelda::Text);

        EnterValue(Row, 34, Format(ValorDemandaJudicial), false, false, TipoCelda::Number);     //Columna AH - Valor en Demanda Judicial
        EnterValue(Row, 35, Format(CarteraCastigada), false, false, TipoCelda::Number);              //Columna AI - Cartera Castigada
        //001-

        EnterValue(Row, 36, Format(CuotaCredito), false, false, TipoCelda::Number);              //Columna AJ - Cuota del Crédito
        //MOI - 26/03/2015:Inicio
        if ldtFechaCancelacion <> 0D then
            EnterValue(Row, 37, Format(ldtFechaCancelacion), false, false, TipoCelda::Date);       //Columna AK - Fecha de Cancelación
        //MOI - 26/03/2015:Fin
        //#25300:Inicio 2
        EnterValue(Row, 38, ltFormaCancelacion, false, false, TipoCelda::Text);                  //Columna AL - Forma de Cancelación
        //#25300:Fin 2
    end;


    procedure DatosEndeudamiento(CLE: Record "Cust. Ledger Entry"; var _ValorOperacion: Decimal; var _SaldoOperacion: Decimal; var _FechaConcesion: Date; var _FechaVencimiento: Date; var _FechaExigible: Date; var _PlazoOperacion: Integer; var _PeriocidadPago: Integer; var _DiasMorosidad: Integer; var _MontoMorosidad: Decimal; var _MontoInteresMora: Decimal; var _ValorVencer30D: Decimal; var _ValorVencer90D: Decimal; var _ValorVencer180D: Decimal; var _ValorVencer360D: Decimal; var _ValorVencerMas360D: Decimal; var _ValorVencido30D: Decimal; var _ValorVencido90D: Decimal; var _ValorVencido180D: Decimal; var _ValorVencido360D: Decimal; var _ValorVencidoMas360D: Decimal; var _ValorDemandaJudicial: Decimal; var _CarteraCastigada: Decimal; var _CuotaCredito: Decimal; var pFechaCancelacion: Date; var pFormaCancelacion: Text[1])
    var
        lrMovClienteDetallado: Record "Detailed Cust. Ledg. Entry";
    begin

        Clear(_ValorOperacion);
        Clear(_SaldoOperacion);
        Clear(_FechaConcesion);
        Clear(_FechaVencimiento);
        Clear(_FechaExigible);
        Clear(_PlazoOperacion);
        Clear(_PeriocidadPago);
        Clear(_DiasMorosidad);
        Clear(_MontoMorosidad);
        Clear(_MontoInteresMora);
        Clear(_ValorVencer30D);
        Clear(_ValorVencer90D);
        Clear(_ValorVencer180D);
        Clear(_ValorVencer360D);
        Clear(_ValorVencerMas360D);
        Clear(_ValorVencido30D);
        Clear(_ValorVencido90D);
        Clear(_ValorVencido180D);
        Clear(_ValorVencido360D);
        Clear(_ValorVencidoMas360D);
        Clear(_ValorDemandaJudicial);
        Clear(_CarteraCastigada);
        Clear(_CuotaCredito);

        //MOI - 26/03/2015:Inicio
        Clear(pFechaCancelacion);
        //MOI - 26/03/2015:Fin

        //#25300:Inicio 2
        Clear(pFormaCancelacion);
        //#25300:Fin 2
        _ValorOperacion := CLE."Amount (LCY)";
        _SaldoOperacion := CLE."Remaining Amt. (LCY)";

        //001+
        if _SaldoOperacion < 0 then
            _SaldoOperacion := 0;
        //001-

        //+#45300
        /*
        //MOI - 08/04/2015:Inicio
        _CuotaCredito := _ValorOperacion - _SaldoOperacion;
        //MOI - 08/04/2015:Fin
        */
        _CuotaCredito := getCuotaCredito(CLE);
        //-#45300

        //001+
        if _CuotaCredito <= 0 then
            _CuotaCredito := _SaldoOperacion;
        //001-

        _FechaConcesion := CLE."Document Date";
        _FechaVencimiento := CLE."Due Date";
        _FechaExigible := CLE."Due Date";

        //fes
        //001+
        /*
        //MOI - 23/04/2015:Inicio
        //_PlazoOperacion        := CLE."Due Date" - CLE."Document Date";
        IF (getFechaVencimiento(CLE) = 0D) OR (CLE."Document Date" = 0D) THEN
        _PlazoOperacion := getFechaVencimiento(CLE) - CLE."Document Date";
        //MOI - 23/04/2015:Fin
        */

        if (getFechaVencimiento(CLE) <> 0D) and (CLE."Posting Date" <> 0D) then
            _PlazoOperacion := getFechaVencimiento(CLE) - CLE."Posting Date";
        //001-

        //001+
        /*
       //+#45300
       //_PeriocidadPago        := 0;
       _PeriocidadPago          := _PlazoOperacion;
       //-#45300
       */
        _PeriocidadPago := 30;
        //001-


        //MOI - 23/04/2015:Inicio
        //IF CLE."Due Date" - FechaReferencia < 0 THEN BEGIN
        if getFechaVencimiento(CLE) - FechaReferencia < 0 then begin
            //MOI - 23/04/2015:Fin

            //MOI - 23/04/2015:Inicio
            //_DiasMorosidad         := ABS(CLE."Due Date" - FechaReferencia);
            _DiasMorosidad := Abs(getFechaVencimiento(CLE) - FechaReferencia);
            //MOI - 23/04/2015:Fin

            _MontoMorosidad := CLE."Remaining Amt. (LCY)";
            _MontoInteresMora := 0;
        end;

        //MOI - 23/04/2015:Inicio
        //CASE (CLE."Due Date" - FechaReferencia)   OF
        case (getFechaVencimiento(CLE) - FechaReferencia) of
            //MOI - 23/04/2015:Fin
            1 .. 30:
                _ValorVencer30D := CLE."Remaining Amt. (LCY)";
            31 .. 90:
                _ValorVencer90D := CLE."Remaining Amt. (LCY)";
            91 .. 180:
                _ValorVencer180D := CLE."Remaining Amt. (LCY)";
            181 .. 360:
                _ValorVencer360D := CLE."Remaining Amt. (LCY)";
            360 .. 99999:
                _ValorVencerMas360D := CLE."Remaining Amt. (LCY)";
            -30 .. -1:
                _ValorVencido30D := CLE."Remaining Amt. (LCY)";
            -90 .. -31:
                _ValorVencido90D := CLE."Remaining Amt. (LCY)";
            -180 .. -91:
                _ValorVencido180D := CLE."Remaining Amt. (LCY)";
            -360 .. -181:
                _ValorVencido360D := CLE."Remaining Amt. (LCY)";
            -99999 .. -360:
                _ValorVencidoMas360D := CLE."Remaining Amt. (LCY)";
        end;

        //+#45300
        //IF _CuotaCredito<>0 THEN
        //  pFechaCancelacion:=getFechaCancelacion(CLE);
        // JPT 25/10/16 Cambio en las directrices "Fecha Cancelación" y "Forma Cancelación". Correo Lizeth Chiliquinga 25/10/16
        if esFacturaCancelada(CLE) then begin
            pFechaCancelacion := getFechaCancelacion(CLE);
            //-#45300
            /*
            //MOI - 26/03/2015:Inicio
            lrMovClienteDetallado.SETCURRENTKEY("Applied Cust. Ledger Entry No.","Entry Type");
            lrMovClienteDetallado.SETRANGE("Applied Cust. Ledger Entry No.",CLE."Entry No.");
            //lrMovClienteDetallado.setfilter("Entry Type",'<>%1&<>%2',lrMovClienteDetallado."Entry Type"::Application,lrMovClienteDetallado."Entry Type"::"Appln. Rounding");
            lrMovClienteDetallado.SETRANGE("Posting Date",0D,FechaReferencia);
            IF lrMovClienteDetallado.FINDSET(FALSE,FALSE) THEN
              REPEAT
                _CuotaCredito+=lrMovClienteDetallado."Amount (LCY)";
                IF pFechaCancelacion<lrMovClienteDetallado."Posting Date" THEN
                  pFechaCancelacion:=lrMovClienteDetallado."Posting Date";
              UNTIL lrMovClienteDetallado.NEXT=0;
            //MOI - 26/03/2015:Fin
            lrMovClienteLiquidado.reset;
            pFechaCancelacion:=getFechaCancelacion(CLE);
            */
            //#25300:Inicio 2
            //IF CLE."Payment Method Code"='EFECTIVO' THEN
            //  pFormaCancelacion:='E';

            if CLE."Payment Method Code" = 'CHEQUE' then
                pFormaCancelacion := 'C'
            else
                pFormaCancelacion := 'E';
            //#25300:Fin 2
        end;

    end;


    procedure DatosCliente(CLE: Record "Cust. Ledger Entry"; var _TipoIdSujeto: Code[1]; var _IdSujeto: Code[30]; var _NombreSujeto: Text[150]; var _ClaseSujeto: Code[1]; var _Provincia: Code[2]; var _Canton: Code[2]; var _Parroquia: Code[2]; var _Sexo: Code[1]; var _EstadoCivil: Code[1]; var _Origen: Code[1])
    var
        SIH: Record "Sales Invoice Header";
        Cust: Record Customer;
        lwPostCode: Code[20];
    begin

        Clear(_TipoIdSujeto);
        Clear(_IdSujeto);
        Clear(_NombreSujeto);
        Clear(_ClaseSujeto);
        Clear(_Provincia);
        Clear(_Canton);
        Clear(_Parroquia);
        Clear(_Sexo);
        Clear(_EstadoCivil);
        Clear(_Origen);

        Clear(lwPostCode);
        //MOI - 07/04/2015:Inicio 2

        // JPT 09/03/2017 Modifico para que en caso de no encontrar el codigo postal de la ficha de factura, lo tome de la ficha de cliente
        if SIH.Get(CLE."Document No.") then begin
            //001+
            if (SIH."Tipo Documento" = SIH."Tipo Documento"::RUC) and (SIH."Tipo Ruc/Cedula" = SIH."Tipo Ruc/Cedula"::"RUC PERSONA NATURAL") then begin
                Length := StrLen(SIH."VAT Registration No.");
                _IdSujeto := CopyStr(SIH."VAT Registration No.", 1, Length - 3);
            end
            else
                if (SIH."Tipo Documento" = SIH."Tipo Documento"::RUC) and (SIH."Tipo Ruc/Cedula" = SIH."Tipo Ruc/Cedula"::" ") then
                    _IdSujeto := ''    //PARA OBLIGAR A BUSCAR EN EL CLIENTE //FES
                else
                    _IdSujeto := SIH."VAT Registration No.";

            case SIH."Tipo Documento" of
                SIH."Tipo Documento"::RUC:
                    begin
                        if SIH."Tipo Ruc/Cedula" = SIH."Tipo Ruc/Cedula"::"RUC PERSONA NATURAL" then
                            _TipoIdSujeto := 'C'
                        else
                            if SIH."Tipo Ruc/Cedula" = SIH."Tipo Ruc/Cedula"::" " then
                                _TipoIdSujeto := ''   //se asigna en blanco para buscar en el cliente //fes
                            else
                                _TipoIdSujeto := 'R';
                    end;

                SIH."Tipo Documento"::Cedula:
                    _TipoIdSujeto := 'C';
                SIH."Tipo Documento"::Pasaporte:
                    _TipoIdSujeto := 'E';
            end;
            //001-

            _NombreSujeto := SIH."Bill-to Name";
            // JPT Se solicita que el codigo postal se tome siempre de la ficha de cliente  09/03/2017 Chiliquinga Rodriguez, …ngela Lizeth
            //lwPostCode      :=  SIH."Bill-to Post Code";
        end
        else
        //#25300:Inicio
        begin
            CLE.CalcFields(CLE."Nombre Cliente");
            _NombreSujeto := CLE."Nombre Cliente";
        end;
        //#25300:Fin
        //MOI - 07/04/2015:Fin 2

        Cust.Get(CLE."Customer No.");

        if lwPostCode = '' then
            lwPostCode := Cust."Post Code";

        if lwPostCode <> '' then begin
            case StrLen(lwPostCode) of
                6:
                    begin
                        _Provincia := CopyStr(lwPostCode, 1, 2);
                        _Canton := CopyStr(lwPostCode, 3, 2);
                        _Parroquia := CopyStr(lwPostCode, 5, 2);
                    end;
                5:
                    begin
                        _Provincia := CopyStr(lwPostCode, 1, 1);
                        _Canton := CopyStr(lwPostCode, 2, 2);
                        _Parroquia := CopyStr(lwPostCode, 4, 2);
                    end;
            end;
        end;

        //MOI - 07/04/2015:Inicio 4
        if _IdSujeto = '' then
          //001+
          begin
            if (Cust."Tipo Documento" = Cust."Tipo Documento"::RUC) and (Cust."Tipo Ruc/Cedula" = Cust."Tipo Ruc/Cedula"::"RUC PERSONA NATURAL") then begin
                Length := StrLen(Cust."VAT Registration No.");
                _IdSujeto := CopyStr(Cust."VAT Registration No.", 1, Length - 3);
            end
            else
                _IdSujeto := Cust."VAT Registration No.";
        end;
        //001-
        //MOI - 07/04/2015:Fin 4

        //001+
        if (_TipoIdSujeto = '') then begin
            case Cust."Tipo Documento" of
                Cust."Tipo Documento"::RUC:
                    begin
                        if Cust."Tipo Ruc/Cedula" = Cust."Tipo Ruc/Cedula"::"RUC PERSONA NATURAL" then
                            _TipoIdSujeto := 'C'
                        else
                            _TipoIdSujeto := 'R';
                    end;
                Cust."Tipo Documento"::Cedula:
                    _TipoIdSujeto := 'C';
                Cust."Tipo Documento"::Pasaporte:
                    _TipoIdSujeto := 'E';
            end;
        end;
        //001-

        // *** JPT 25/10/16 Cambiamos las directrices para determinar la clase Sujeto
        // Correo de Angela Lizeth Chiliquinga 25/10/16
        /*
        CASE Cust."Tax Identification Type" OF
          Cust."Tax Identification Type"::"Natural Person"  : _ClaseSujeto   := 'N';
          Cust."Tax Identification Type"::"Legal Entity"    : _ClaseSujeto   := 'J';
        END;
        */

        _ClaseSujeto := 'N';
        if Cust."Tipo Documento" = Cust."Tipo Documento"::RUC then begin
            if (StrLen(_IdSujeto) >= 13) then
                if _IdSujeto[3] = '9' then
                    _ClaseSujeto := 'J';
        end;
        // ***

        if _ClaseSujeto = 'N' then begin // Solo para personas naturales
            case Cust.Sexo of
                Cust.Sexo::Masculino:
                    _Sexo := 'M';
                Cust.Sexo::Femenino:
                    _Sexo := 'F';
            end;

            case Cust."Estado Civil" of
                Cust."Estado Civil"::Soltero:
                    _EstadoCivil := 'S';
                Cust."Estado Civil"::Casado:
                    _EstadoCivil := 'C';
                Cust."Estado Civil"::Divorciado:
                    _EstadoCivil := 'D';
                Cust."Estado Civil"::"Unión Libre":
                    _EstadoCivil := 'U';
                Cust."Estado Civil"::Viudo:
                    _EstadoCivil := 'V';
            end;

            case Cust."Origen Ingresos" of
                Cust."Origen Ingresos"::"Empleado Público":
                    _Origen := 'B';
                Cust."Origen Ingresos"::"Empleado Privado":
                    _Origen := 'V';
                Cust."Origen Ingresos"::Independiente:
                    _Origen := 'I';
                Cust."Origen Ingresos"::"Ama de Casa o Estudiante":
                    _Origen := 'A';
                Cust."Origen Ingresos"::Rentista:
                    _Origen := 'R';
                Cust."Origen Ingresos"::Jubilado:
                    _Origen := 'H';
                Cust."Origen Ingresos"::"Remesas del Exterior":
                    _Origen := 'M';
            end;
        end;

    end;


    procedure DatosFactura(CLE: Record "Cust. Ledger Entry"; var _NoComprobante: Code[30])
    var
        SIH: Record "Sales Invoice Header";
    begin
        //001+
        Clear(_NoComprobante);
        //MOI - 07/04/2015:Inicio2
        if SIH.Get(CLE."Document No.") then
            // _NoComprobante := SIH."No. Comprobante Fiscal"
            _NoComprobante := SIH."Establecimiento Factura" + SIH."Punto de Emision Factura" + SIH."No. Comprobante Fiscal"
        else
            _NoComprobante := CLE."No. Comprobante Fiscal";
        //MOI - 07/04/2015:Fin2
        //001-
    end;

    local procedure UltimoDiaMesAnterior(pFecha: Date): Date
    begin
        exit(DMY2Date(1, Date2DMY(pFecha, 2), Date2DMY(pFecha, 3)) - 1);
    end;

    local procedure PrimerDiaMesActual(pFecha: Date): Date
    begin
        exit(DMY2Date(1, Date2DMY(pFecha, 2), Date2DMY(pFecha, 3)));
    end;

    local procedure EsACredito(pMovCliente: Record "Cust. Ledger Entry"): Boolean
    var
        lrMovClienteLiquidado: Record "Cust. Ledger Entry";
        ldSumaImporte: Decimal;
    begin
        //comprobar que no tiene ningun pago en la misma fecha que la factura.
        Clear(ldSumaImporte);
        lrMovClienteLiquidado.Reset;
        lrMovClienteLiquidado.SetCurrentKey("Closed by Entry No.");
        lrMovClienteLiquidado.SetRange("Closed by Entry No.", pMovCliente."Entry No.");
        lrMovClienteLiquidado.SetRange("Posting Date", pMovCliente."Posting Date");
        lrMovClienteLiquidado.SetFilter("Date Filter", '<=%1', FechaReferencia);
        if lrMovClienteLiquidado.FindSet() then begin
            lrMovClienteLiquidado.CalcFields("Amount (LCY)");
            ldSumaImporte += lrMovClienteLiquidado."Amount (LCY)";
        end;

        if pMovCliente."Amount (LCY)" <> ldSumaImporte then
            exit(true);
    end;

    local procedure getFechaCancelacion(pMovCliente: Record "Cust. Ledger Entry"): Date
    var
        lrMovClienteDetallado: Record "Detailed Cust. Ledg. Entry";
        ldtFechaRegistro: Date;
    begin
        //Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Cust. Ledger Entry No.=FIELD(Entry No.),Posting Date=FIELD(Date Filter)))
        Clear(ldtFechaRegistro);
        lrMovClienteDetallado.Reset;
        lrMovClienteDetallado.SetCurrentKey("Cust. Ledger Entry No.", "Posting Date");
        lrMovClienteDetallado.SetRange("Cust. Ledger Entry No.", pMovCliente."Entry No.");
        //+#45300
        //lrMovClienteDetallado.SETRANGE(lrMovClienteDetallado."Posting Date",0D,FechaReferencia);
        lrMovClienteDetallado.SetRange("Posting Date", PrimerDiaMesActual(FechaReferencia), FechaReferencia);
        // #45300 JPT 25/10/2016 Solo debe constar fechas de los pagos y notas de crédito efectuados en el mes. Lizet Chiliquinga
        lrMovClienteDetallado.SetFilter("Document Type", '%1|%2', lrMovClienteDetallado."Document Type"::Payment, lrMovClienteDetallado."Document Type"::"Credit Memo");
        //-#45300
        if lrMovClienteDetallado.FindSet() then
            repeat
                if ldtFechaRegistro < lrMovClienteDetallado."Posting Date" then
                    ldtFechaRegistro := lrMovClienteDetallado."Posting Date";
            until lrMovClienteDetallado.Next = 0;
        exit(ldtFechaRegistro);
    end;

    local procedure getFechaVencimiento(pMovCliente: Record "Cust. Ledger Entry"): Date
    var
        lrHistoricoFacturaVenta: Record "Sales Invoice Header";
    begin
        //MOI - 23/04/2015:Inicio
        if pMovCliente."Due Date" <> 0D then
            exit(pMovCliente."Due Date")
        else
            if lrHistoricoFacturaVenta.Get(pMovCliente."Document No.") then
                exit(lrHistoricoFacturaVenta."Due Date");
        //MOI - 23/04/2015:Fin    +
    end;


    procedure ValidaSujeto(prmMovCli: Record "Cust. Ledger Entry"): Boolean
    var
        SIH: Record "Sales Invoice Header";
        Cust: Record Customer;
        Id: Text[30];
        CustPostingGroup: Record "Customer Posting Group";
    begin

        //+#45300
        Cust.Get(prmMovCli."Customer No.");
        if CustPostingGroup.Get(Cust."Customer Posting Group") then
            if CustPostingGroup."Cliente Interno" then
                exit(false);

        if SIH.Get(prmMovCli."Document No.") then
            Id := SIH."VAT Registration No.";

        if Id = '' then
            Id := Cust."VAT Registration No.";

        if CopyStr(Id, 3, 1) = '6' then
            exit(false);

        exit(true);
        //-#45300
    end;


    procedure ValidaValorOperacion(prmMovCli: Record "Cust. Ledger Entry"): Boolean
    begin

        //+#45300
        if wValorOperacion = 0 then
            exit(true);
        prmMovCli.CalcFields("Original Amt. (LCY)");
        exit(prmMovCli."Original Amt. (LCY)" >= wValorOperacion);
        //-#45300
    end;


    procedure getCuotaCredito(pMovCliente: Record "Cust. Ledger Entry") Cuota: Decimal
    var
        rMovClienteDetallado: Record "Detailed Cust. Ledg. Entry";
    begin
        //+#45300
        Clear(Cuota);
        rMovClienteDetallado.Reset;
        rMovClienteDetallado.SetCurrentKey("Cust. Ledger Entry No.", "Posting Date");
        rMovClienteDetallado.SetRange("Cust. Ledger Entry No.", pMovCliente."Entry No.");
        rMovClienteDetallado.SetRange("Posting Date", PrimerDiaMesActual(FechaReferencia), FechaReferencia);
        //rMovClienteDetallado.SETFILTER("Posting Date",'<=%1',FechaReferencia);
        rMovClienteDetallado.SetRange("Customer No.", pMovCliente."Customer No.");
        //- JPT 07/10/16 "Cuota del Crédito: solo se debe incluir Pagos. Lizeth Chiliquinga
        // rMovClienteDetallado.SETRANGE("Document Type", rMovClienteDetallado."Document Type"::Payment);
        // JPT 25/10/16 Se vuelven a cambiar las direcctrices, ahora incluye notas de credito. Lizeth Chiliquinga
        rMovClienteDetallado.SetFilter("Document Type", '%1|%2', rMovClienteDetallado."Document Type"::Payment, rMovClienteDetallado."Document Type"::"Credit Memo");

        //+
        if rMovClienteDetallado.FindSet() then
            repeat
                Cuota += rMovClienteDetallado."Amount (LCY)";
            until rMovClienteDetallado.Next = 0;
        // JPT 27/12/16 Cuota del Crédito: No deben salir valores en negativo. Chiliquinga Rodriguez, …ngela Lizeth
        Cuota := -Cuota;
        //+#45300
    end;


    procedure esFacturaCancelada(pMovCliente: Record "Cust. Ledger Entry"): Boolean
    var
        rMovCli: Record "Cust. Ledger Entry";
        rMovClienteDetallado: Record "Detailed Cust. Ledg. Entry";
    begin
        //+#45300
        //1. Comprobamos que la factura a fecha de referencia esté totalmente cancelada
        rMovCli.Reset;
        rMovCli.Get(pMovCliente."Entry No.");
        rMovCli.SetFilter("Date Filter", '<=%1', FechaReferencia);
        rMovCli.CalcFields("Remaining Amt. (LCY)");
        if rMovCli."Remaining Amt. (LCY)" <> 0 then
            exit(false);

        //2. Si está cancelada comprobamos que la cancelación se realizó en el periodo y no en un perido anterior
        rMovClienteDetallado.Reset;
        rMovClienteDetallado.SetCurrentKey("Cust. Ledger Entry No.", "Posting Date");
        rMovClienteDetallado.SetRange("Cust. Ledger Entry No.", pMovCliente."Entry No.");
        rMovClienteDetallado.SetRange("Posting Date", PrimerDiaMesActual(FechaReferencia), FechaReferencia);
        rMovClienteDetallado.SetRange("Customer No.", pMovCliente."Customer No.");
        exit(rMovClienteDetallado.FindSet);
        //-#45300
    end;
}

