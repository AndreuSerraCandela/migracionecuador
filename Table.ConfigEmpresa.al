table 56001 "Config. Empresa"
{
    // #842 04/02/13 CAT. Nuevos campos:
    //            56050 No. serie Palet
    //            56051 ID Report email packing
    //            56052 E-mail notificación envio ped.
    //            56053 ID Codeunit fic. transportista
    //            56054 No. Serie transportista
    //            56055 Ruta fichero transportista
    // 
    // 
    // #830 CAT Creación de los campos
    //   - Cód Cliente Call Center.
    //   - Días Borrado Rvas. Call Center
    // 
    // 
    // #34822  CAT Creación campo: Cta. Retención Vta. IVA (55005)
    // #72814  RRT, 30.11.2017: Funcion GetSistemaOrigen()
    // #81969 27/01/2018 PLB: Usuario notificacion para el "Historial MdE"
    // 
    //  Proyecto: Implementacion Business Central
    // 
    //  LDP: Luis Jose De La Cruz Paredes
    //  ------------------------------------------------------------------------
    //  No.        Fecha           Firma    Descripcion
    //  ------------------------------------------------------------------------
    //  SIC-JERM   04/09/2023      LDP      Creación campos "Liquidar Nota Credito TPV","Liquidar Factura TPV".
    //  001        13/02/2024      LDP      Se crean campos series sic configurables.


    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Country; Code[10])
        {
            Caption = 'Country';
            TableRelation = "Parametros Loc. x País";
        }
        field(3; "Titulo E-mail Pedido de Venta"; Text[30])
        {
        }
        field(4; "Ubicacion Temp. Reportes HTML"; Text[30])
        {
        }
        field(5; "No. serie Dev. Consignacion"; Code[20])
        {
            Caption = 'Return Consignment Series No.';
            TableRelation = "No. Series";
        }
        field(6; "No. serie Dev. Consg. Reg."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7; "Grpo. Contable Existencia"; Code[20])
        {
            TableRelation = "Inventory Posting Group";
        }
        field(8; "Cta. Contable existencia"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(9; "Alm. por Def. Consignacion"; Code[20])
        {
            Caption = 'Consignment Def. Location';
            TableRelation = Location;
        }
        field(10; "Titulo E-mail Confirm. Pedido"; Text[30])
        {
        }
        field(11; "Credito excedido %"; Decimal)
        {
        }
        field(12; "Ubicacion Reportes-Email"; Text[240])
        {
        }
        field(13; "Nombre Reporte Prod. Cero"; Text[10])
        {
        }
        field(14; "Notificacion de Credito %"; Decimal)
        {
            Caption = '% Notificacion Credito';
        }
        field(15; "No. serie pre pedido"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(16; "No. Serie Consig. Reg."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(17; "Proveedor Muestras"; Code[20])
        {
            Caption = 'Sample Vendor';
            TableRelation = Vendor;
        }
        field(18; "Dim. Tipo Facturacion"; Code[20])
        {
            Caption = 'Dim. Invoicing Type';
            TableRelation = Dimension;
        }
        field(19; "No. serie Cupon"; Code[20])
        {
            Caption = 'Coupon No. Series';
            TableRelation = "No. Series";
        }
        field(20; "Imprimir Remision Venta"; Boolean)
        {
            Caption = 'Print Sales Shipment';
        }
        field(21; "Habilitar NCF en Consignacion"; Boolean)
        {
            Caption = 'Enable NCF in Consignment';
        }
        field(22; "Location code for returns"; Code[20])
        {
            Caption = 'Location code for returns';
            TableRelation = Location;
        }
        field(23; "Direccion Cupon tienda 1"; Text[50])
        {
            Caption = 'Store 1 Coupon Address';
        }
        field(24; "Direccion Cupon tienda 2"; Text[50])
        {
            Caption = 'Store 2 Coupon Address';
        }
        field(25; "Direccion Cupon tienda 3"; Text[50])
        {
            Caption = 'Store 3 Coupon Address';
        }
        field(26; "Direccion Cupon tienda 4"; Text[50])
        {
            Caption = 'Store 4 Coupon Address';
        }
        field(27; "Direccion Cupon tienda 5"; Text[50])
        {
            Caption = 'Store 5 Coupon Address';
        }
        field(28; "Direccion Cupon tienda 6"; Text[50])
        {
            Caption = 'Store 6 Coupon Address';
        }
        field(29; "Cantidad Lineas en Cupón"; Integer)
        {
            Caption = 'Copuon Lines Qty.';
        }
        field(30; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'Tax Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(31; "Controla Transf. Alm. Consig."; Boolean)
        {
            Caption = 'Control Transfer Consignment';
            Description = 'Para controlar que no se puedan hacer transferencias en firme desde y hasta almacenes de consignacion';
        }
        field(32; "Almacen refacturacion"; Code[20])
        {
            Caption = 'Re invoice Location';
            TableRelation = Location;
        }
        field(33; "Cod. Dimemsion Refacturacion"; Code[20])
        {
            TableRelation = Dimension;
        }
        field(34; "Valor Dimemsion Refacturacion"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Cod. Dimemsion Refacturacion"));
        }
        field(35; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(36; "No. Serie Pre Devolucion"; Code[20])
        {
            Caption = 'Pre Return Series No.';
            TableRelation = "No. Series";
        }
        field(40; "ID Empresa FE"; Code[2])
        {
            Caption = 'Elect. Inv. Company ID';
        }
        field(41; "Funcionalidad FE Activa"; Boolean)
        {
            Caption = 'Electronica Invoice Active';
        }
        field(42; "Reporte Factura Resguardo"; Integer)
        {
            Caption = 'Guard Inv. Report';
        }
        field(43; "Reporte Factura Fact. Elect."; Integer)
        {
        }
        field(44; "Reporte NC Resguardo"; Integer)
        {
        }
        field(45; "Reporte NC Elect."; Integer)
        {
        }
        field(47; "Ubicacion XML Respuesta"; Text[250])
        {
            Caption = 'XML Response Path';
        }
        field(48; "% IVA Activo"; Decimal)
        {
            Caption = 'Vat % Active';
            Description = 'DerAut 1.0';
        }
        field(49; "Grupo Precio Int. Der. Aut."; Code[20])
        {
            Caption = 'Copyright Price Group';
            Description = 'DerAut 1.0';
            TableRelation = "Customer Price Group";
        }
        field(50; "No. Serie Packing"; Code[20])
        {
            Caption = 'Packing Series No.';
            TableRelation = "No. Series";
        }
        field(51; "No. Serie Cajas Packing"; Code[20])
        {
            Caption = 'Packing Box Series No.';
            TableRelation = "No. Series";
        }
        field(52; "No. Serie Packing Reg."; Code[20])
        {
            Caption = 'Posted Packing Series No.';
            TableRelation = "No. Series";
        }
        field(53; "ID Reporte Etiqueta de Caja"; Integer)
        {
            Caption = 'Box Tag ID Report';
        }
        field(54; "ID Reporte Borrador Packing"; Integer)
        {
        }
        field(55; "Clientes Nuevos Bloqueados"; Boolean)
        {
            Caption = 'New Customers Blocked';
        }
        field(56; "Precio de Venta Muestras"; Option)
        {
            Caption = 'Sample Sales Price';
            OptionCaption = 'Cost,Zero';
            OptionMembers = Costo,Cero;
        }
        field(57; "Precio de Venta Donaciones"; Option)
        {
            Caption = 'Donations Sales Price';
            OptionCaption = 'Cost,Zero';
            OptionMembers = Costo,Cero;
        }
        field(58; "Forma Pago Oblig. en Compra"; Boolean)
        {
            Caption = 'Payment Method mandatory on purchase';
        }
        field(59; "DS POS Activo"; Boolean)
        {
            Caption = 'DS POS Active';
        }
        field(60; "Funcionalidad NCF Activa"; Boolean)
        {
            Caption = 'NCF Functionality Active';
        }
        field(61; "Crea Ped. Compra de Muestras"; Boolean)
        {
            Caption = 'Create Purchase orders From Samples';
        }
        field(62; "Funcionalidad Consig. Activa"; Boolean)
        {
            Caption = 'Consignment Functionality Active';
        }
        field(63; "Cobrador Exigido en cobro"; Boolean)
        {
            Caption = 'Collector required in receipts';
        }
        field(64; "Funcionalidad Imp. Fiscal Act."; Boolean)
        {
            Caption = 'Fiscal Printer Functionality Active';
        }
        field(65; "Copia Fact. Imp. Fiscal Panama"; Integer)
        {
        }
        field(66; "Copia NDC Imp. Fiscal Panama"; Integer)
        {
        }
        field(67; "Impresion Muestras"; Integer)
        {
        }
        field(73; "Control Lin. por Factura"; Boolean)
        {
            Caption = 'Control Lines per Invoice';
        }
        field(74; "Cantidad Lin. por factura"; Integer)
        {
            Caption = 'Line Qty. per Invoice';
        }
        field(77; "Proveedor Bloqueado al crear"; Boolean)
        {
            Caption = 'Vendor Blocked in Creation';
            Description = 'Perú';
        }
        field(78; "Genera NCF en Retencion"; Boolean)
        {
            Caption = 'Generate NCF with the Retention';
            Description = 'Perú';
        }
        field(79; "NCF en Remision de Ventas"; Boolean)
        {
            Caption = 'Sales Shipment NCF Required';
        }
        field(84; "Vendedor Obligatorio"; Boolean)
        {
            Caption = 'Salesperson Required';
            Description = 'Perú';
        }
        field(85; "Cantidades sin Decimales"; Boolean)
        {
            Caption = 'No Decimals in Qty.';
            Description = 'Perú';
        }
        field(90; "Cod. Auditoria en Ventas Oblg."; Boolean)
        {
            Caption = 'Audit Code Mandatory in Sales';
            Description = 'Perú';
        }
        field(99; "Anula NCF al Reimprimir"; Boolean)
        {
            Caption = 'If Print Void NCF ';
        }
        field(100; "ID Reporte Copia Factura Vta."; Integer)
        {
            Caption = 'Sales Invoice Copy Report ID.';
            /*             TableRelation = Object.ID WHERE(Type = FILTER(Report)); */
        }
        field(101; "ID Reporte Copia Remision Vta."; Integer)
        {
            Caption = 'Sales Shippment Copy Report ID';
            /*     TableRelation = Object.ID WHERE(Type = FILTER(Report)); */
        }
        field(102; "ID Reporte Copia Nota Cr. Vta."; Integer)
        {
            Caption = 'Credit Memo Copy Report ID.';
            /*         TableRelation = Object.ID WHERE(Type = FILTER(Report)); */
        }
        field(103; "ID Reporte Copia Rem. Transf."; Integer)
        {
            Caption = 'Transfer Shipment Copy Report ID.';
            /*        TableRelation = Object.ID WHERE(Type = FILTER(Report)); */
        }
        field(104; "Productos nuevos bloqueados"; Boolean)
        {
            Caption = 'News Items Blocked';
        }
        field(105; "Permite Vtas. Importe Cero"; Boolean)
        {
            Caption = 'Allow Sales with amount cero';
        }
        field(106; "Permite Compras. Importe Cero"; Boolean)
        {
            Caption = 'Allow Purchase with Cero Amount';
        }
        field(113; "Directorio temporal etiquetas"; Text[100])
        {
            Caption = 'Labels Temp. Directory';
        }
        field(114; "ID Reporte Comprobante Ret."; Integer)
        {
            Description = 'Perú';
            /*             TableRelation = Object.ID WHERE(Type = FILTER(Report)); */
        }
        field(115; "Ubicacion XML SRI"; Text[30])
        {
            Caption = 'XML SRI Location';
            Description = 'Ecuador';
        }
        field(116; "Grupo Reg. Iva Prod. Exento"; Code[20])
        {
            Caption = 'Vat Producto Posting Group Exempt';
            Description = 'Ecuador';
            TableRelation = "VAT Product Posting Group";
        }
        field(118; "% Beneficio Vta. Cte. Internos"; Decimal)
        {
            Caption = 'Benefit % for Sales Internal Customer';
        }
        field(120; "Libro Diario Cheques Posf."; Code[20])
        {
            Caption = 'Future Checks Journal';
            Description = 'Ecuador';
            TableRelation = "Gen. Journal Template";
        }
        field(121; "Seccion Diario Cheques Posf."; Code[20])
        {
            Caption = 'Future Checks Batch';
            Description = 'Ecuador';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Libro Diario Cheques Posf."));
        }
        field(122; "No. serie Ofertas Combo"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(123; "Activos Fijos Nuevos Bloqueado"; Boolean)
        {
            Caption = 'New Fixed Assent Blocked';
        }
        field(140; "Cta. Ingresos Prov. Insolv."; Code[20])
        {
            Description = '#144';
            TableRelation = "G/L Account";
        }
        field(141; "Cta. Gastos Prov. Insolv."; Code[20])
        {
            Description = '#144';
            TableRelation = "G/L Account";
        }
        field(150; "Cód Cliente Call Center"; Code[20])
        {
            Description = '#830';
            TableRelation = Customer."No.";
        }
        field(151; "Días Borrado Rvas. Call Center"; Integer)
        {
            Description = '#830';
        }
        field(52000; "Cod. sociedad maestros Santill"; Text[10])
        {
            Caption = 'Cód. sociedad maestros Santillana';
            Description = 'Santillana,MdE,MdM';
        }
        field(52001; "Cod. pais maestros Santill"; Text[3])
        {
            Description = 'Santillana,MdE,MdM';
        }
        field(52002; "WS Respuesta MdE"; Text[100])
        {
            Description = 'Santillana,MdE';
        }
        field(52003; "Centro de coste MdE"; Option)
        {
            Description = 'Santillana,MdE';
            OptionCaption = 'No integrar,,Dimensión';
            OptionMembers = "No integrar",,Dimension;

            trigger OnValidate()
            begin
                ValidaTipoMdE("Centro de coste MdE", FieldNo("Centro de coste MdE"));
                if "Centro de coste MdE" <> "Centro de coste MdE"::Dimension then
                    "Dimension Centro Coste" := '';
            end;
        }
        field(52004; "Departamento MdE"; Option)
        {
            Description = 'Santillana,MdE';
            OptionCaption = 'No integrar,División,Dimensión';
            OptionMembers = "No integrar",Division,Dimension;

            trigger OnValidate()
            begin
                ValidaTipoMdE("Departamento MdE", FieldNo("Departamento MdE"));
                if "Departamento MdE" <> "Departamento MdE"::Dimension then
                    "Dimension Departamento" := '';
            end;
        }
        field(52005; "Division MdE"; Option)
        {
            Caption = 'División MdE';
            Description = 'Santillana,MdE';
            OptionCaption = 'No integrar,División,Dimensión';
            OptionMembers = "No integrar",Division,Dimension;

            trigger OnValidate()
            begin
                ValidaTipoMdE("Division MdE", FieldNo("Division MdE"));
                if "Division MdE" <> "Division MdE"::Dimension then
                    "Dimension Division" := '';
            end;
        }
        field(52006; "Area funcional MdE"; Option)
        {
            Caption = '…rea funcional MdE';
            Description = 'Santillana,MdE';
            OptionCaption = 'No integrar,División,Dimensión';
            OptionMembers = "No integrar",Division,Dimension;

            trigger OnValidate()
            begin
                ValidaTipoMdE("Area funcional MdE", FieldNo("Area funcional MdE"));
                if "Area funcional MdE" <> "Area funcional MdE"::Dimension then
                    "Dimension Area funcional" := '';
            end;
        }
        field(52007; "MdE Activo"; Boolean)
        {
            Description = 'Santillana,MdE';
        }
        field(52008; "WS Informacion Compl. MdE"; Text[100])
        {
            Description = 'Santillana,MdE';
        }
        field(52009; "Dimension Departamento"; Code[20])
        {
            Description = 'Santillana,MdE';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                ValidaDimensionMdE("Dimension Departamento", FieldNo("Dimension Departamento"));
            end;
        }
        field(52010; "Dimension Division"; Code[20])
        {
            Description = 'Santillana,MdE';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                ValidaDimensionMdE("Dimension Division", FieldNo("Dimension Division"));
            end;
        }
        field(52011; "Dimension Area funcional"; Code[20])
        {
            Description = 'Santillana,MdE';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                ValidaDimensionMdE("Dimension Area funcional", FieldNo("Dimension Area funcional"));
            end;
        }
        field(52012; "Dimension Centro Coste"; Code[20])
        {
            Description = 'Santillana,MdE';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                ValidaDimensionMdE("Dimension Centro Coste", FieldNo("Dimension Centro Coste"));
            end;
        }
        field(52013; "Cod. Sociedad CO maestros"; Text[10])
        {
            Description = 'Santillana,MdE';
        }
        field(52014; "Posicion MdE"; Option)
        {
            Caption = 'Posición MdE';
            Description = 'Santillana,MdE';
            OptionCaption = 'No integrar,Puesto laboral';
            OptionMembers = "No integrar","Puesto laboral";
        }
        field(52015; "Sistema origen"; Text[3])
        {
            Description = 'Santillana,MdE';
            InitValue = 'NAV';
        }
        field(52016; "Usuario notificaciones MdE"; Code[50])
        {
            Description = 'MdE,#81969';
            TableRelation = User."User Name";

            trigger OnLookup()
            var
                UserRec: Record User;
            begin
            end;

            trigger OnValidate()
            var
                UserRec: Record User;
            begin
                //UserMgt.ValidateUserID("Usuario notificaciones MdE");
                if "Usuario notificaciones MdE" <> '' then begin
                    if not UserRec.Get("Usuario notificaciones MdE") then
                        Error('El usuario %1 no existe en el sistema.', "Usuario notificaciones MdE");
                end;
            end;
        }
        field(55000; "Cta. Retencion Vta."; Code[20])
        {
            Caption = 'Sales Retention Account';
            Description = 'Ecuador';
            TableRelation = "G/L Account";
        }
        field(55001; "% Retencion Vta."; Decimal)
        {
            Caption = 'Sales Retention %';
            Description = 'Ecuador';
        }
        field(55002; "Importe para solicitar ID"; Decimal)
        {
            Caption = 'Amount to Require ID';
            Description = 'Ecuador';
        }
        field(55003; "E-Mail copia pagos a Proveedor"; Text[150])
        {
        }
        field(55004; "ID Formato Imp. Consignacion"; Integer)
        {
            Description = 'Ecuador';
        }
        field(55005; "Cta. Retención Vta. IVA"; Code[20])
        {
            Description = '#34822';
            TableRelation = "G/L Account";
        }
        field(56000; "Almacen prod. defectuosos"; Code[10])
        {
            Caption = 'Almacén productos defectuosos';
            Description = 'Clasificación devoluciones';
            TableRelation = Location;
        }
        field(56001; "Liquidacion devoluciones"; Option)
        {
            Caption = 'Liquidación devoluciones';
            Description = 'Clasificación devoluciones';
            OptionCaption = 'Manual,Por antigüedad';
            OptionMembers = Manual,"Por antiguedad";
        }
        field(56002; "Codeunit clas. devoluciones"; Integer)
        {
            Description = 'Clasificación devoluciones';
            /*      TableRelation = Object.ID WHERE(Type = CONST(Codeunit)); */
        }
        field(56003; "Fecha Origen"; Option)
        {
            Caption = 'Fecha Origen';
            Description = 'Clasificación devoluciones,#175585';
            OptionCaption = ' ,Fecha Emision,Fecha Registro';
            OptionMembers = " ","Fecha Emision","Fecha Registro";
        }
        field(56008; "Cod. divisa local MdX"; Code[10])
        {
            Caption = 'Cod. divisa local';
            Description = 'MdM,MdE';
        }
        field(56050; "No. serie Palet"; Code[20])
        {
            Description = '#842';
            TableRelation = "No. Series";
        }
        field(56051; "ID Codeunit email packing"; Integer)
        {
            Description = '#842';
            /*           TableRelation = Object WHERE(Type = CONST(Codeunit)); */
        }
        field(56052; "E-mail notificación envio ped."; Text[30])
        {
            Description = '#842';
            /*           TableRelation = Object.ID WHERE(Type = CONST(Codeunit)); */
        }
        field(56053; "ID Codeunit fic. transportista"; Integer)
        {
            Description = '#842';
            /*             TableRelation = Object.ID WHERE(Type = CONST(Codeunit)); */
        }
        field(56054; "No. Serie transportista"; Code[20])
        {
            Description = '#842';
            TableRelation = "No. Series";
        }
        field(56055; "Ruta fichero transportista"; Text[100])
        {
            Description = '#842';
        }
        field(56056; "Fecha Inicio Campaña"; Date)
        {
            Description = '#48474';
        }
        field(56057; "Fecha Fin Campaña"; Date)
        {
            Description = '#48474';
        }
        field(56071; "Emitir un Solo Documento"; Boolean)
        {
            Description = 'Clasificación devoluciones';
        }
        field(56072; "Email GD Local"; Text[80])
        {
            Caption = 'Email GD Local';
            Description = 'SANTINAV-1458';
        }
        field(56073; "Email Soporte Funcional"; Text[80])
        {
            Caption = 'Email Soporte Funcional';
            Description = 'SANTINAV-1458';
        }
        field(56074; "Email Encargado Proyecto"; Text[80])
        {
            Caption = 'Email Encargado Proyecto';
            Description = 'SANTINAV-1458';
        }
        field(56075; "Liquidar Nota Credito TPV"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'LDP - SIC-JERM';
        }
        field(56076; "Liquidar Factura TPV"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'LDP - SIC-JERM';
        }
        field(56077; "Serie Colegio SIC"; Code[15])
        {
            DataClassification = ToBeClassified;
            Description = '001';
            TableRelation = "No. Series";
        }
        field(56078; "Serie Vendedor SIC"; Code[15])
        {
            DataClassification = ToBeClassified;
            Description = '001';
            TableRelation = "No. Series";
        }
        field(56079; "Serie Cliente SIC"; Code[15])
        {
            DataClassification = ToBeClassified;
            Description = '001';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text52000: Label 'La dimensión %1 ya se utiliza en %2. Sólo puede haber una dimensión por cada tipo de dato.';
        Text52001: Label 'El valor %1 ya se utiliza en %2. Sólo puede haber tipo de dato configurado como %1.';
        UserMgt: Codeunit "User Management";


    procedure ValidaDimensionMdE(NewDimension: Code[20]; NewFieldId: Integer)
    begin
        if NewDimension = '' then
            exit;

        VerificaDimensionDuplicada(NewDimension, NewFieldId, "Dimension Departamento", FieldNo("Dimension Departamento"), FieldCaption("Dimension Departamento"));
        VerificaDimensionDuplicada(NewDimension, NewFieldId, "Dimension Division", FieldNo("Dimension Division"), FieldCaption("Dimension Division"));
        VerificaDimensionDuplicada(NewDimension, NewFieldId, "Dimension Area funcional", FieldNo("Dimension Area funcional"), FieldCaption("Dimension Area funcional"));
        VerificaDimensionDuplicada(NewDimension, NewFieldId, "Dimension Centro Coste", FieldNo("Dimension Centro Coste"), FieldCaption("Dimension Centro Coste"));
    end;


    procedure ValidaTipoMdE(NewValue: Option "No integrar",Division,Dimension; NewFieldId: Integer)
    begin
        if NewValue <> NewValue::Division then
            exit;

        VerificaTipoDuplicado(NewValue, NewFieldId, "Departamento MdE", FieldNo("Departamento MdE"), FieldCaption("Departamento MdE"));
        VerificaTipoDuplicado(NewValue, NewFieldId, "Division MdE", FieldNo("Division MdE"), FieldCaption("Division MdE"));
        VerificaTipoDuplicado(NewValue, NewFieldId, "Area funcional MdE", FieldNo("Area funcional MdE"), FieldCaption("Area funcional MdE"));
        VerificaTipoDuplicado(NewValue, NewFieldId, "Centro de coste MdE", FieldNo("Centro de coste MdE"), FieldCaption("Centro de coste MdE"));
    end;


    procedure VerificaDimensionDuplicada(NewDimension: Code[20]; NewFieldId: Integer; Dimension: Code[20]; FieldId: Integer; Caption: Text[100])
    begin
        if (NewFieldId <> FieldId) and (NewDimension = Dimension) then
            Error(Text52000, NewDimension, Caption);
    end;


    procedure VerificaTipoDuplicado(NewValue: Option "No integrar",Division,Dimension; NewFieldId: Integer; Value: Option "No integrar",Division,Dimension; FieldId: Integer; Caption: Text[100])
    begin
        if (NewFieldId <> FieldId) and (NewValue = Value) then
            Error(Text52001, NewValue, Caption);
    end;


    procedure GetSistemaOrigen(): Text[10]
    begin
        //+72814
        // "NAV" es el valor por defecto, que es para las empresas "Santillana"
        // para las empresas "Norma" hay que utilizar "NOR"

        if "Sistema origen" = '' then
            exit('NAV_' + "Cod. pais maestros Santill")
        else
            exit("Sistema origen" + '_' + "Cod. pais maestros Santill");
    end;
}

