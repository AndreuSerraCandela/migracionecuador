table 76056 "Archivo Transferencia ITBIS"
{

    fields
    {
        field(1; Apellidos; Text[30])
        {
            Caption = 'Last names';
        }
        field(2; Nombres; Text[30])
        {
            Caption = 'Names';
        }
        field(3; "Razón Social"; Text[60])
        {
            Caption = 'Fiscal name';
        }
        field(4; "Nombre Comercial"; Text[60])
        {
            Caption = 'Commercial name';
        }
        field(5; RNC; Code[11])
        {
            Caption = 'Vat registration no.';
        }
        field(6; "Cédula"; Code[11])
        {
            Caption = 'Document ID';
        }
        field(7; "Número Documento"; Code[20])
        {
            Caption = 'Document no.';
        }
        field(8; "Fecha Documento"; Text[8])
        {
            Caption = 'Document date';
        }
        field(9; "Total Documento"; Decimal)
        {
            Caption = 'Grand total';
        }
        field(10; "ITBIS Pagado"; Decimal)
        {
            Caption = 'VAT paid';
        }
        field(11; NCF; Code[19])
        {
            Caption = 'NCF';
        }
        field(12; "Codigo Informacion"; Code[3])
        {
            Caption = 'Information code';
        }
        field(13; "Clasific. Gastos y Costos NCF"; Code[2])
        {
            Caption = 'Expense code';
        }
        field(14; "NCF Relacionado"; Code[19])
        {
            Caption = 'Related NCF';
        }
        field(15; "ITBIS Retenido"; Decimal)
        {
            Caption = 'Vat amount retained';
        }
        field(16; "Fecha Pago"; Text[8])
        {
            Caption = ' Payment date';
        }
        field(17; "Cod. Proveedor"; Code[20])
        {
            Caption = 'Vendor no.';
        }
        field(18; "Codigo reporte"; Code[10])
        {
            Caption = 'Report id';
        }
        field(19; "fecha registro"; Date)
        {
            Caption = 'Posting date';
        }
        field(20; Dia; Text[30])
        {
            Caption = 'Day';
        }
        field(21; "Dia Pago"; Text[30])
        {
            Caption = 'Payment day';
        }
        field(22; "No. Mov."; Integer)
        {
            Caption = 'Entry no.';
        }
        field(23; "RNC/Cedula"; Code[11])
        {
            Caption = 'RNC - Cedula';
        }
        field(24; "Tipo Identificacion"; Integer)
        {
            Caption = 'ID type';
        }
        field(25; "ISR Retenido"; Decimal)
        {
            Caption = 'ISR Retention';
        }
        field(26; "Tipo documento"; Integer)
        {
            Description = '1 = Factura, 2 = Nota de credito';
        }
        field(27; "Monto Bienes"; Decimal)
        {
        }
        field(28; "Monto Servicios"; Decimal)
        {
        }
        field(29; "Monto Selectivo"; Decimal)
        {
        }
        field(30; "Monto Propina"; Decimal)
        {
        }
        field(31; "Monto otros"; Decimal)
        {
        }
        field(32; "Forma de pago DGII"; Option)
        {
            OptionCaption = ' ,1 - Efectivo,2 - Cheques/Transferencias/Depósitos,3 - Tarjeta Crédito/Debito,4 - Compra a crédito, 5 - Permuta,6 - Nota de crédito,7 - Mixto';
            OptionMembers = " ","1 - Efectivo","2 - Cheques/Transferencias/Depositos","3 - Tarjeta Credito/Debito","4 - Compra a credito"," 5 - Permuta","6 - Nota de credito","7 - Mixto";
        }
        field(33; "Tipo retencion ISR"; Option)
        {
            OptionCaption = ' ,01 - ALQUILERES,02 - HONORARIOS POR SERVICIOS,03 - OTRAS RENTAS,04 - OTRAS RENTAS (Rentas Presuntas),05 - INTERESES PAGADOS A PERSONAS JURIDICAS RESIDENTES,06 - INTERESES PAGADOS A PERSONAS FISICAS RESIDENTES,07 - RETENCION POR PROVEEDORES DEL ESTADO,08 - JUEGOS TELEFONICOS';
            OptionMembers = " ","01 - ALQUILERES","02 - HONORARIOS POR SERVICIOS","03 - OTRAS RENTAS","04 - OTRAS RENTAS (Rentas Presuntas)","05 - INTERESES PAGADOS A PERSONAS JURIDICAS RESIDENTES","06 - INTERESES PAGADOS A PERSONAS FISICAS RESIDENTES","07 - RETENCION POR PROVEEDORES DEL ESTADO","08 - JUEGOS TELEFONICOS";
        }
        field(34; "Tipo de ingreso"; Code[2])
        {
            Caption = 'Income type';
            Description = 'DSLoc1.03';
            InitValue = '01';
        }
        field(35; "Fecha Retencion"; Date)
        {
        }
        field(36; "ITBIS Percibido"; Decimal)
        {
        }
        field(37; "ISR Percibido"; Decimal)
        {
        }
        field(38; "Monto Efectivo"; Decimal)
        {
            BlankZero = true;
        }
        field(39; "Monto Cheque"; Decimal)
        {
            BlankZero = true;
        }
        field(40; "Monto tarjetas"; Decimal)
        {
            BlankZero = true;
        }
        field(41; "Venta a credito"; Decimal)
        {
            BlankZero = true;
        }
        field(42; "Venta bonos"; Decimal)
        {
            BlankZero = true;
        }
        field(43; "Venta Permuta"; Decimal)
        {
            BlankZero = true;
        }
        field(44; "ITBIS sujeto a proporc."; Decimal)
        {
        }
        field(45; "ITBIS llevado al costo"; Decimal)
        {
        }
        field(46; "ITBIS Por adelantar"; Decimal)
        {
        }
        field(47; "Tipo Bienes y Serv. comprados"; Option)
        {
            Caption = 'Type of Goods and Services purchased';
            OptionCaption = ' ,01-GASTOS DE PERSONAL,02-GASTOS POR TRABAJOS - SUMINISTROS Y SERVICIOS,03-ARRENDAMIENTOS,04-GASTOS DE ACTIVOS FIJO,05-GASTOS DE REPRESENTACION,06-OTRAS DEDUCCIONES ADMITIDAS,07-GASTOS FINANCIEROS,08-GASTOS EXTRAORDINARIOS,09-COMPRAS Y GASTOS QUE FORMARAN PARTE DEL COSTO DE VENTA,10-ADQUISICIONES DE ACTIVOS,11-GASTOS DE SEGUROS';
            OptionMembers = " ","01-GASTOS DE PERSONAL","02-GASTOS POR TRABAJOS - SUMINISTROS Y SERVICIOS","03-ARRENDAMIENTOS","04-GASTOS DE ACTIVOS FIJO","05-GASTOS DE REPRESENTACION","06-OTRAS DEDUCCIONES ADMITIDAS","07-GASTOS FINANCIEROS","08-GASTOS EXTRAORDINARIOS","09-COMPRAS Y GASTOS QUE FORMARAN PARTE DEL COSTO DE VENTA","10-ADQUISICIONES DE ACTIVOS","11-GASTOS DE SEGUROS";
        }
        field(48; "Razon Anulacion"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(49; "Fecha Retencion Venta"; Text[8])
        {
            DataClassification = ToBeClassified;
        }
        field(50; Proporcionalidad; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,100% Admitido,% Admitido,0% Admitido,No Aplica';
            OptionMembers = " ","100% Admitido","% Admitido","0% Admitido","No Aplica";
        }
        field(60; CantidadNCF; Integer)
        {
            CalcFormula = Count ("Archivo Transferencia ITBIS" WHERE (NCF = FILTER ('B02*')));
            Caption = 'Cantidad NCFs Emitidos de F.C.';
            Description = 'Consumidor Final';
            FieldClass = FlowField;
        }
        field(61; TotalMontoFacturado; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Total Documento" WHERE (NCF = FILTER ('B02*')));
            Caption = 'Total Monto Facturado';
            Description = 'Consumidor Final';
            FieldClass = FlowField;
        }
        field(62; TotalITBISFacturado; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."ITBIS Pagado" WHERE (NCF = FILTER ('B02*')));
            Caption = 'Total ITBIS Facturado';
            Description = 'Consumidor Final';
            FieldClass = FlowField;
        }
        field(63; ImpuestoSelectivoAlConsumo; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Monto Selectivo" WHERE (NCF = FILTER ('B02*')));
            Caption = 'Impuesto Selectivo al Consumo';
            Description = 'Consumidor Final';
            FieldClass = FlowField;
        }
        field(64; TotalOtrosImpuestosTasas; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Monto otros" WHERE (NCF = FILTER ('B02*')));
            Caption = 'Total Otros Impuestos/Tasas';
            Description = 'Consumidor Final';
            FieldClass = FlowField;
        }
        field(65; TotalMontoPropinaLegal; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Monto Propina" WHERE (NCF = FILTER ('B02*')));
            Caption = 'Total Monto Propina Legal';
            Description = 'Consumidor Final';
            FieldClass = FlowField;
        }
        field(66; MontoEfectivo; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Monto Efectivo" WHERE (NCF = FILTER ('B02*')));
            Caption = 'Efectivo';
            Description = 'Consumidor Final';
            FieldClass = FlowField;
        }
        field(67; MontoChequeTransDeposito; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Monto Cheque" WHERE (NCF = FILTER ('B02*')));
            Caption = 'Cheque/Transferencia/Deposito';
            Description = 'Consumidor Final';
            FieldClass = FlowField;
        }
        field(68; MontoTarjeta; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Monto tarjetas" WHERE (NCF = FILTER ('B02*')));
            Caption = 'Tarjeta Debito/Credito';
            Description = 'Consumidor Final';
            FieldClass = FlowField;
        }
        field(69; MontoCredito; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Venta a credito" WHERE (NCF = FILTER ('B02*')));
            Caption = 'Venta a Credito';
            Description = 'Consumidor Final';
            FieldClass = FlowField;
        }
        field(70; MontoBonosCertificados; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Venta bonos" WHERE (NCF = FILTER ('B02*')));
            Caption = 'Bonos o Certificados de regalos';
            Description = 'Consumidor Final';
            FieldClass = FlowField;
        }
        field(71; MontoPermuta; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Venta Permuta" WHERE (NCF = FILTER ('B02*')));
            Caption = 'Permuta';
            Description = 'Consumidor Final';
            FieldClass = FlowField;
        }
        field(72; MontoOtrasFormaVentas; Decimal)
        {
            Caption = 'Otras Forma de Ventas';
            Description = 'Consumidor Final';
        }
        field(73; "Monto B01 y E31 IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Total Documento" WHERE (NCF = FILTER ('B01*' | 'E31*'),
                                                                                     "Codigo reporte" = CONST ('607')));
            Caption = 'Comprobantes válido para Crédito Fiscal (01 y 31) Monto';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(74; "Cant B01 y E31 IT-1"; Integer)
        {
            CalcFormula = Count ("Archivo Transferencia ITBIS" WHERE (NCF = FILTER ('B01*' | 'E31*'),
                                                                     "Codigo reporte" = CONST ('607')));
            Caption = 'Comprobantes válido para Crédito Fiscal (01 y 31) Cantidad';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(75; "Monto B02 y E32 IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Total Documento" WHERE (NCF = FILTER ('B02*' | 'E32*'),
                                                                                     "Codigo reporte" = CONST ('607')));
            Caption = 'Comprobantes Consumo (02 y 32) Monto';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(76; "Cant B02 y E32 IT-1"; Integer)
        {
            CalcFormula = Count ("Archivo Transferencia ITBIS" WHERE (NCF = FILTER ('B02*' | 'E32*'),
                                                                     "Codigo reporte" = CONST ('607')));
            Caption = 'Comprobantes Consumo (02 y 32) Cantidad';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(77; "Monto B03 y E33 IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Total Documento" WHERE (NCF = FILTER ('B03*' | 'E33*'),
                                                                                     "Codigo reporte" = CONST ('607')));
            Caption = 'Comprobantes Nota de Débito (03 y 33) Monto';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(78; "Cant B03 y E33 IT-1"; Integer)
        {
            CalcFormula = Count ("Archivo Transferencia ITBIS" WHERE (NCF = FILTER ('B03*' | 'E33*'),
                                                                     "Codigo reporte" = CONST ('607')));
            Caption = 'Comprobantes Nota de Débito (03 y 33) Cantidad';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(79; "Monto B04 y E34 IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Total Documento" WHERE (NCF = FILTER ('B04*' | 'E34*'),
                                                                                     "Codigo reporte" = CONST ('607')));
            Caption = 'Comprobantes Nota de Crédito (04 y 34) Monto';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(80; "Cant B04 y E34 IT-1"; Integer)
        {
            CalcFormula = Count ("Archivo Transferencia ITBIS" WHERE (NCF = FILTER ('B04*' | 'E34*'),
                                                                     "Codigo reporte" = CONST ('607')));
            Caption = 'Comprobantes Nota de Crédito (04 y 34) Cantidad';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(81; "Monto B12 IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Total Documento" WHERE (NCF = FILTER ('B12*'),
                                                                                     "Codigo reporte" = CONST ('607')));
            Caption = 'Comprobantes Registro Único de Ingresos (12) Monto';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(82; "Cant B12 IT-1"; Integer)
        {
            CalcFormula = Count ("Archivo Transferencia ITBIS" WHERE (NCF = FILTER ('B12*'),
                                                                     "Codigo reporte" = CONST ('607')));
            Caption = 'Comprobantes Registro Único de Ingresos (12) Cantidad';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(83; "Monto B14 y E44 IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Total Documento" WHERE (NCF = FILTER ('B14*' | 'E44*'),
                                                                                     "Codigo reporte" = CONST ('607')));
            Caption = 'Comprobante de Regímenes Especiales (14 y 44) Monto';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(84; "Cant B14 y E44 IT-1"; Integer)
        {
            CalcFormula = Count ("Archivo Transferencia ITBIS" WHERE (NCF = FILTER ('B14*' | 'E44*'),
                                                                     "Codigo reporte" = CONST ('607')));
            Caption = 'Comprobante de Regímenes Especiales (14 y 44) Cantidad';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(85; "Monto B15 y E45 IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Total Documento" WHERE (NCF = FILTER ('B15*' | 'E45*'),
                                                                                     "Codigo reporte" = CONST ('607')));
            Caption = 'Comprobante Gubernamentales (15 y 45) Monto';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(86; "Cant B15 y E45 IT-1"; Integer)
        {
            CalcFormula = Count ("Archivo Transferencia ITBIS" WHERE (NCF = FILTER ('B15*' | 'E45*'),
                                                                     "Codigo reporte" = CONST ('607')));
            Caption = 'Comprobante Gubernamentales (15 y 45) Cantidad';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(87; "Monto B16 y E46 IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Total Documento" WHERE (NCF = FILTER ('B16*' | 'E46*'),
                                                                                     "Codigo reporte" = CONST ('607')));
            Caption = 'Comprobante para exportaciones (16 y 46) Monto';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(88; "Cant B16 y E46 IT-1"; Integer)
        {
            CalcFormula = Count ("Archivo Transferencia ITBIS" WHERE (NCF = FILTER ('B16*' | 'E46*'),
                                                                     "Codigo reporte" = CONST ('607')));
            Caption = 'Comprobante para exportaciones (16 y 46) Cantidad';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(89; "MontoEfectivo IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Monto Efectivo" WHERE ("Codigo reporte" = CONST ('607')));
            Caption = 'Efectivo';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(90; "MontoChequeTransferencia IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Monto Cheque" WHERE ("Codigo reporte" = CONST ('607')));
            Caption = 'Cheque / Transferencia';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(91; "MontoTarjeta IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Monto tarjetas" WHERE ("Codigo reporte" = CONST ('607')));
            Caption = 'Tarjeta débito / crédito ';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(92; "MontoCredito IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Venta a credito" WHERE ("Codigo reporte" = CONST ('607')));
            Caption = 'A Credito';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(93; "MontoBonosCertificado IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Venta bonos" WHERE ("Codigo reporte" = CONST ('607')));
            Caption = 'Bonos o Certificado de Regalo';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(94; "MontoPermuta IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Venta Permuta" WHERE ("Codigo reporte" = CONST ('607')));
            Caption = 'Permutas';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(95; "Monto Operacional IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Total Documento" WHERE ("Codigo reporte" = CONST ('607'),
                                                                                     "Tipo de ingreso" = FILTER ('01' | '1')));
            Caption = 'Ingresos por Operaciones(No Financieros)';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(96; "Monto Financiero IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Total Documento" WHERE ("Codigo reporte" = CONST ('607'),
                                                                                     "Tipo de ingreso" = FILTER ('02' | '2')));
            Caption = 'Ingresos Financieros';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(97; "Monto Extraordinarios IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Total Documento" WHERE ("Codigo reporte" = CONST ('607'),
                                                                                     "Tipo de ingreso" = FILTER ('03' | '3')));
            Caption = 'Ingresos Extraordinarios';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(98; "Monto Arrendamiento IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Total Documento" WHERE ("Codigo reporte" = CONST ('607'),
                                                                                     "Tipo de ingreso" = FILTER ('04' | '4')));
            Caption = 'Ingreso por Arrendamiento';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(99; "Monto VentaActivo IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Total Documento" WHERE ("Codigo reporte" = CONST ('607'),
                                                                                     "Tipo de ingreso" = FILTER ('05' | '5')));
            Caption = 'Ingreso por Venta de Activos Depreciables';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(100; "Monto IngresoOtros IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Total Documento" WHERE ("Codigo reporte" = CONST ('607'),
                                                                                     "Tipo de ingreso" = FILTER ('06' | '6')));
            Caption = 'Otros Ingresos';
            Description = 'IT1';
            FieldClass = FlowField;
        }
        field(101; "MontoEspecial IT-1"; Decimal)
        {
            CalcFormula = Sum ("Archivo Transferencia ITBIS"."Total Documento" WHERE (NCF = FILTER ('B14*' | 'E44*'),
                                                                                     "Codigo reporte" = CONST ('606')));
            Caption = 'Total Facturas en Comprobantes Fiscales para Regímenes Especiales';
            FieldClass = FlowField;
        }
        field(105; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Número Documento", "Fecha Documento", RNC, "Cédula", "Codigo reporte", "No. Mov.")
        {
            Clustered = true;
        }
        key(Key2; "Nombre Comercial", "Fecha Documento")
        {
        }
        key(Key3; NCF)
        {
        }
        key(Key4; NCF, "Codigo reporte")
        {
        }
        key(Key5; "fecha registro")
        {
        }
    }

    fieldgroups
    {
    }
}

